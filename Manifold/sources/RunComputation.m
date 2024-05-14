(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*RunComputation*)


(* ::Subsection::Closed:: *)
(*Options*)


(* Option Definitions *)
DefineOptions[RunComputation,
	Options:>{
		{
			OptionName->CreateTickets,
			Default->True,
			Description->"Specify if Asana tickets should be created in the event that an invalid computation is run.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[True,False]],
			Category->"Hidden"
		}
	}
];


(* ::Subsection::Closed:: *)
(*Main Function Body*)

(* Run a computation by parsing its pending/completed notebook files, updating computation status and checking for stops at each cell evaluation *)
RunComputation[compObj:ObjectP[Object[Notebook,Computation]], ops:OptionsPattern[RunComputation]]:=Quiet[
	(* Main function body is checked for exceptions/errors *)
	Module[
		{
			comp,jobCreatedBy,status,jobStatus,completedNotebookCloudFile,pendingNotebookCloudFile,maxTime,maxTimeSeconds,
			pastNotebookFile,futureNotebookFile,pastNotebookObject,futureNotebookObject
		},

		(* Make sure we are working with an object reference *)
		{comp, jobCreatedBy, status, jobStatus}=Download[compObj, {Object, Job[CreatedBy][Object], Status, Job[Status]}];

		(* Quit early if a stop was requested *)
		If[MatchQ[status, Stopping|Stopped|Aborting|Aborted]||MatchQ[jobStatus, Aborted],
			Return[$Failed]
		];

		(* Initialize the computation. This creates the Template and Completed Notebook files *)
		initiateComputation[comp];

		(* NOTE: Temporarily disable on stage/Manifold *)
		If[ProductionQ[],
			Echo["Check VOQ"];
			(* Error if VOQ doesn't pass *)
			If[!TrueQ[ValidObjectQ[comp, Verbose -> True]],
				Return[errorComputation[
					comp,
					"ERROR: Computation did not pass VOQ. Please run ValidObjectQ on "<>ToString[comp]<>" and address the test failures before re-running."
				]]
			];
			Echo["Passed VOQ"];,
			Echo["Skipping VOQ on stage!"];
		];

		(* Retrieve the completed (past) and pending (future) notebook files from the computation *)
		{completedNotebookCloudFile,pendingNotebookCloudFile,maxTime}=Download[comp,
			{CompletedNotebookFile,PendingNotebookFile,Job[MaximumRunTime]}
		];

		Echo["Retrieved Notebook Files"];


		(* Maximum running time to the nearest second *)
		maxTimeSeconds=Round[Unitless[maxTime,Second]];


		(* Download the notebook cloud files to local disc *)
		{pastNotebookFile,futureNotebookFile}={
			DownloadCloudFile[completedNotebookCloudFile,FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]],
			DownloadCloudFile[pendingNotebookCloudFile,FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]]
		};

		Echo["Downloaded Notebook Files"];


		(* Open the notebooks and get pointers to their objects. *)
		{pastNotebookObject,futureNotebookObject}={
			UsingFrontEnd[NotebookOpen[pastNotebookFile,Visible->True]],
			UsingFrontEnd[NotebookOpen[futureNotebookFile,Visible->True]]
		};

		Echo["Opened Notebook Files"];

		(* Make sure the notebooks are fully editable *)
		unlockNotebook[pastNotebookObject];
		unlockNotebook[futureNotebookObject];

		Echo["Unlocked Notebook Files"];

		(* Run the notebook code, timing out if the maximum time is exceeded  *)
		TimeConstrained[
			runComputationLoop[comp,pastNotebookObject,futureNotebookObject],
			maxTimeSeconds,
			timeOutComputation[comp]
		];

		(* Finish up the computation *)
		finishComputation[comp]
	],
	{FrontEndObject::notavail}
];


(* ::Subsubsection::Closed:: *)
(*initiateComputation*)

(* Set Status to Running and initiate the Pending and Completed notebooks *)
initiateComputation[comp:ObjectReferenceP[Object[Notebook,Computation]]]:=Module[
	{
		currStatus,templateCloudFile,templateInputFile,templateAssetFile,
		completedNotebook,resolvedSLLCommit,initialDateStarted,randomDelay,
		uploadResult,initialUploadPacket
	},

	(* Logging for manifold *)
	Echo["Initializing Computation..."];
	(* we are adding random delay to decrease the probability of 2 AWS pods starting at once *)
	randomDelay=RandomInteger[10];
	Echo["Adding a delay of "<>ToString[randomDelay]<>" seconds"];
	Pause[randomDelay];

	(* Make sure we have an object reference *)
	{currStatus,templateInputFile,templateAssetFile,initialDateStarted}=Download[comp,{
		Status,
		Job[TemplateNotebookFile][Object],
		Job[TemplateNotebook][AssetFile],
		DateStarted
	}];

	(* if DateStarted is populated already, this means that another AWS pod is running this and we are inside a secondary pod somehow *)
	If[DateObjectQ[initialDateStarted] && !MatchQ[currStatus,Staged],
		Echo["This Computation is already running! Aborting this instance..."];Abort[]
	];

	(* choose to use the notebook asset file if it exists, if not use the input file *)
	templateCloudFile=If[MatchQ[templateAssetFile,Null],
		templateInputFile,
		templateAssetFile
	];

	Echo["Initializing Computation...(Download Object)"];

	(* Create an empty completed notebook *)
	completedNotebook=makeBlankNotebook[];

	Echo["Initializing Computation...(Create Notebook)"];


	(* First try $Distro, then try GitCommitHash[$EmeraldPath], otherwise default to Null *)
	resolvedSLLCommit=Which[
		(* Pull from distro if we loaded from distro *)
		MatchQ[$Distro,ObjectP[Object[Software,Distro]]],Download[$Distro,Commit],
		(* If unit testing, check the commit global variable set in the test environment *)
		MatchQ[ECL`$ManifoldTestDistroCommit,_String],$ManifoldTestDistroCommit,
		(* Otherwise, get the hash from the local SLL path *)
		True,Quiet[ECL`GitCommitHash[$EmeraldPath]]/.{$Failed->Null}
	];

	Echo["Initializing Computation...(Resolve Distro)"];

	(* Make sure the SLL Commit pattern matches *)
	resolvedSLLCommit=If[MatchQ[resolvedSLLCommit,_String],
		resolvedSLLCommit,
		Null
	];

	Echo["Initializing Computation...(Resolve Commit)"];

	(* Upload initial progress *)
	initialUploadPacket=<|
		Object->comp,
		Status->Running,
		DateStarted->Now,
		SLLCommit->resolvedSLLCommit,
		CompletedNotebookFile->Link[completedNotebook],
		Append[CompletedNotebookFileLog]->{Now,Link[completedNotebook],Link[$PersonID]},
		PendingNotebookFile->Link[templateCloudFile],
		Append[PendingNotebookFileLog]->{Now,Link[templateCloudFile],Link[$PersonID]}
	|>;

	(* Echo our progress packet and the upload result for debugging *)
	Echo[initialUploadPacket,"initial progress upload packet:"];
	uploadResult=Upload[initialUploadPacket];
	Echo[uploadResult,"initial upload result:"];

	(* if we failed to upload progress, abort computation *)
	If[MatchQ[uploadResult,$Failed | {$Failed}],
		Echo["We failed to upload the initial progress, aborting..."];Abort[],

		(* if we have uploaded everything but our Status has not updated from Staged somehow, update it *)
		Module[{currentStatusAfterUpload},
			ClearDownload[]; (* just in case we have some weird caching happening somewhere on our side (non-DB) *)
			currentStatusAfterUpload=Download[comp,Status];
			If[!MatchQ[currentStatusAfterUpload,Running],
				Echo["Aberrant computation status detected: "<>currentStatusAfterUpload<>". Applying corrective measure..."];
				Upload[<|Object->comp,Status->Running|>]
			]
		]
	];

	Echo["Initializing Computation...(Upload initial progress)"];

];



(* ::Subsubsection::Closed:: *)
(*timeOutComputation*)

(* Set Status to TimedOut and update the DateCompleted and ActualRunTime fields *)
timeOutComputation[comp:ObjectReferenceP[Object[Notebook,Computation]]]:=Module[
	{},

	(* Logging for Manifold *)
	Echo["Computation Timed Out. Updating Logs..."];

	(* Do a final update on the status of the job. We don't need to update the notebook files on successful exit. *)
	Upload[<|
		Object->comp,
		Status->TimedOut,
		DateCompleted->Now,
		ActualRunTime->(Now-Download[comp,DateStarted]),
		ComputationFinancingTeam->Null
	|>];
];



(* ::Subsubsection::Closed:: *)
(*errorComputation*)

(* Set Status to Error *)
errorComputation[comp:ObjectReferenceP[Object[Notebook,Computation]], message_String]:=Module[{},
	(* Logging for Manifold *)
	Echo[message<>" Computation terminating with state Error..."];

	(* Set computation status to Error *)
	Upload[<|
		Object->comp,
		Status->Error,
		DateCompleted->Now,
		ActualRunTime->(Now-Download[comp,DateStarted]),
		ErrorMessage->message,
		ComputationFinancingTeam->Null
	|>];

	(* Return False indicated unsuccessful completion *)
	False
];



(* ::Subsubsection::Closed:: *)
(*finishComputation*)

(* Set Status to Completed and update the DateCompleted and ActualRunTime fields *)
finishComputation[comp:ObjectReferenceP[Object[Notebook,Computation]]]:=Module[
	{currStatus,startTime,destinationNotebook,destinationNameFunction,finalStatus,
	destinationNotebookPackets,computedNotebookFile,computationPacket},

	(* Logging for Manifold *)
	Echo["Finishing Computation..."];

	(* Make sure we have an object reference and grab some info re saving the computation *)
	(* Warning: This download is stubbed in the unit tests and updates here must be reflected in the tests *)
	{currStatus,startTime,destinationNotebook,destinationNameFunction,computedNotebookFile}=Download[
		comp,
		{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}
	];

	(* If job was Stopping, finish with Stopped. If Aborting, finish with Aborted. Otherwise assume successful completion if Running, and Error otherwise. *)
	finalStatus=Switch[currStatus,
		Stopping,Stopped,
		Aborting,Aborted,
		Running,Completed,
		TimedOut,TimedOut,
		_,(Echo["   WARNING: Invalid status when finishing computation."];Error)
	];

	(* -  Upload the computation to the requested notebook - *)

	destinationNotebookPackets = If[MatchQ[destinationNotebook,ObjectP[]],
		Module[{pageID,pagePacket,notebookPacket},
			pageID=CreateID[Object[Notebook,Page]];

			(* Create a new notebook page for the completed computation *)
			pagePacket=<|
				Object -> pageID,
				AssetFile -> Link[computedNotebookFile],
				Replace[AssetFileLog] -> {Now, Link[computedNotebookFile], Link[$PersonID]},
				DisplayName -> (destinationNameFunction[]),
				Notebook -> Link[destinationNotebook,Objects]
			|>;

			(* Add the page to the existing lab notebook pages *)
			notebookPacket=<|
				Object->destinationNotebook,
				Append[Pages] -> Link[pageID]
			|>;

			{pagePacket,notebookPacket}
		],
		{}
	];

	(* Do a final update on the status of the job. *)
	computationPacket=<|
		Object->comp,
		Status->finalStatus,
		DateCompleted->Now,
		ActualRunTime->(Now-startTime),
		ComputationFinancingTeam->Null
	|>;

	Upload[Append[destinationNotebookPackets,computationPacket]];

	(* Return True if the final status was Completed, and false otherwise *)
	MatchQ[finalStatus,Completed]
];



(* ::Subsubsection::Closed:: *)
(*runComputationLoop*)

(* Run a computation by parsing its pending/completed notebook files, updating computation status and checking for stops at each cell evaluation *)
runComputationLoop[
	comp:ObjectReferenceP[Object[Notebook,Computation]],
	pastNotebookInput_NotebookObject,
	futureNotebookInput_NotebookObject
]:=Module[
	{
		historyLength,pastCellObjects,futureCellObjects,pastCells,futureCells,
		currentFutureCellObject,currentFutureCell,echoToPastNotebook,
		currentHeldExpression,currentCell,evaluatedExpression,currentCreatedObjects,
		messages,sectionsJSON,erroredOut,newPastNotebookFilename,newFutureNotebookFilename,
		newPastNotebookCloudFile,newFutureNotebookCloudFile, pastNotebook, futureNotebook
	},
	
	(*
		assign notebooks to new variables so we can set them.
		In 12.0 the notebooks get set correctly by default after saving,
		but in 12.3.1 we have to set them to the default we want.
	*)
	pastNotebook = pastNotebookInput;
	futureNotebook = futureNotebookInput;

	(* Get all of the cells in this notebook. *)
	historyLength=1;
	{pastCellObjects,futureCellObjects}={UsingFrontEnd[Cells[pastNotebook]],UsingFrontEnd[Cells[futureNotebook]]};
	{pastCells,futureCells}={UsingFrontEnd[NotebookRead[pastCellObjects]],UsingFrontEnd[NotebookRead[futureCellObjects]]};

	(* Run the computation to completion. *)
	While[
		(* Continue as long as current status is running AND there are future cells to evaluate *)
		And[
			MatchQ[Download[comp,Status],Running],
			Length[futureCells]>0
		],

		(*** Pop one of the cells from the future notebook, run it if it is an input/code cell, then update notebooks and status ***)

		(* Move pointer to the end of the past notebook. *)
		UsingFrontEnd[SelectionMove[pastNotebook,After,Notebook]];

		(* Update cell variables to make sure things are up to date *)
		{pastCellObjects,futureCellObjects}={UsingFrontEnd[Cells[pastNotebook]],UsingFrontEnd[Cells[futureNotebook]]};
		{pastCells,futureCells}={UsingFrontEnd[NotebookRead[pastCellObjects]],UsingFrontEnd[NotebookRead[futureCellObjects]]};

		(* Get the pointer to and the first cell from the future (pending) notebook. *)
		(* Get the pointer to and the first cell from the future (pending) notebook. *)
		currentFutureCellObject=FirstOrDefault[futureCellObjects,$Failed];
		currentFutureCell=FirstOrDefault[futureCells,$Failed];

		(* Get the remaining future cells as well *)
		futureCellObjects=Rest[futureCellObjects];
		futureCells=Rest[futureCells];

		(* Delete the future cell *)
		UsingFrontEnd[NotebookDelete[currentFutureCellObject]];

		(* If the current cell is NOT Code or Input, just move it to the past notebook and continue to the next cell *)
		If[!MatchQ[currentFutureCell,Cell[_,"Input"|"Code",___]],
			(* If not a Code or Input cell, just put it in the past notebook *)
			Echo["   Current cell is not Input or Code, skipping evaluation..."];
			UsingFrontEnd[SelectionMove[pastNotebook,After,Notebook]];
			UsingFrontEnd[NotebookWrite[pastNotebook,currentFutureCell]];
			Continue[];
		];

		(* Extract a held expression from the current input/code cell *)
		currentHeldExpression=ToExpression[First[currentFutureCell],StandardForm,Hold];

		(* Echo the expression to be evaluated to stdout on Manifold, for logging purposes *)
		Echo["Evaluating expression "<>ToString[currentHeldExpression]];

		(* Put the future (now current) cell in the past notebook, give it an In[...] tag. *)
		(* Note: The CellLabel option may already exist for this Cell so either Replace or Append. SetOptions[...] doesn't work with Cells. *)
		currentCell=If[KeyExistsQ[Rest@Rest@(List@@currentFutureCell),CellLabel],
			(* Cell Label already exists. Change the cell label. *)
			Append[
				currentFutureCell/.{(CellLabel->_)->CellLabel->"In["<>ToString[historyLength]<>"]:="},
				ShowCellLabel->True
			],
			(* Cell label does not exist. Append it. *)
			Append[
				Append[currentFutureCell,CellLabel->"In["<>ToString[historyLength]<>"]:="],
				ShowCellLabel->True
			]
		];

		(* Write the current cell to the past notebook. *)
		UsingFrontEnd[NotebookWrite[pastNotebook,currentCell]];

		(* Reset $CreatedObjects *)
		$CreatedObjects={};

		(* Redirected overload of echo that writes to the past notebook file *)
		echoToPastNotebook[expr_]:=(
			Quiet@Print[expr];
			UsingFrontEnd[NotebookWrite[
				pastNotebook,
				Language`EchoDump`echoCell[expr, StandardForm]
			]];
			expr
		);

		(* Redirected overload of echo that writes to the past notebook file *)
		echoToPastNotebook[expr_, tag_]:=(
			Quiet@Print[ToString[tag]<>": "<>ToString[expr]];
			UsingFrontEnd[NotebookWrite[
				pastNotebook,
				Language`EchoDump`echoCell[Sequence[expr, tag], StandardForm]
			]];
			expr
		);

		(* Get evaluation data for the current expression, ensuring echos get written to notebook *)
		(* Block guarantees that Echo is reverted to its original definition after the execution of this line of code *)
		evaluatedExpression=Block[
			{Echo=echoToPastNotebook},
			EvaluationData[ReleaseHold[currentHeldExpression]]
		];

		(* Save current created objects *)
		currentCreatedObjects=If[MatchQ[$CreatedObjects,{ObjectP[]...}],
      $CreatedObjects,
      {}
    ];

		(* Update created objects in the computation notebook page. *)
		Block[{$NotebookPage=comp},
			HandleCreatedObjects[];
		];

		(* Lookup messages from the evaluation *)
		messages=DeleteCases[
			Lookup[evaluatedExpression,"MessagesText"],
			_?(StringContainsQ[#,"FrontEndObject::notavail"]&),
			1
		];

		(* Handle any messages thrown by the computation *)
		If[Length[messages]>0,
			Map[
				Module[{messageDelimiter,messageExpression,messageText,messageHead,messageName,messageCell},
					(* Split the message name from text *)
					messageDelimiter=First@StringPosition[#," : "];
					messageExpression=StringTake[#,{1,messageDelimiter[[1]]-1}];
					messageText=StringTake[#,{messageDelimiter[[2]]+1,-1}];
					(* Split the message head from the name *)
					{messageHead,messageName}={
						FirstOrDefault[StringSplit[messageExpression,"::"],"MessageHead"],
						LastOrDefault[StringSplit[messageExpression,"::"],"MessageName"]
					};
					(* Create a cell for messages *)
					messageCell=Cell[BoxData[TemplateBox[{messageHead,messageName,messageText},"MessageTemplate"]],"Message","MSG",CellLabel->"During evaluation of In["<>ToString[historyLength]<>"]:=",ShowCellLabel->True];
					(* Move to the end of the past notebook. *)
					UsingFrontEnd[SelectionMove[pastNotebook,After,Notebook]];
					(* Insert our message. *)
					UsingFrontEnd[NotebookWrite[pastNotebook,messageCell]]
				]&,
				DeleteDuplicates[messages]
			];
		];

		(* Move to the end of the past notebook. *)
		UsingFrontEnd[SelectionMove[pastNotebook,After,Notebook]];

		(* Write the expression output to the completed notebook. Do not write anything if the output is either a sequence or Null *)
		If[!MatchQ[Extract[evaluatedExpression,"Result",Hold],Hold[Null]|Hold[_, __]],
			UsingFrontEnd[NotebookWrite[
				pastNotebook,
				Cell[BoxData[ToBoxes[Lookup[evaluatedExpression,"Result"]]],"Output",CellLabel->"Out["<>ToString[historyLength]<>"]=",ShowCellLabel->True]
			]]
		];

		(* Re-parse the sectionsJSON file since we've updated the cells *)
		sectionsJSON=Quiet[UsingFrontEnd[ParseNotebookNew[pastNotebook,futureNotebook]]];

		(* Set erroredOut to True if there were any messages explicitly tagged with Error *)
		erroredOut=(Length[Cases[messages,_?(StringContainsQ[#,"Error::"]&)]]>0);

		(* Save the updated past and future notebooks to random UUIDs in $TemporaryDirectory. *)
		newPastNotebookFilename=FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}];
		newFutureNotebookFilename=FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}];

		(* Make the past and future editable and deletable before saving. *)
		unlockNotebook[pastNotebook];
		unlockNotebook[futureNotebook];

		(* Save the notebook objects to the new filenames *)
		UsingFrontEnd[NotebookSave[pastNotebook,newPastNotebookFilename]];
		UsingFrontEnd[NotebookSave[futureNotebook,newFutureNotebookFilename]];
		
		(*
			set pastNotebook/futureNotebook to the last location is was saved,
			otherwise it will default to the UUID and be unusable.
		*)
		pastNotebook = UsingFrontEnd[NotebookOpen[newPastNotebookFilename]];
		futureNotebook = UsingFrontEnd[NotebookOpen[newFutureNotebookFilename]];

		(* Upload these notebooks to cloud file objects. *)
		{newPastNotebookCloudFile,newFutureNotebookCloudFile}=Upload[
			{
				UploadCloudFile[newPastNotebookFilename,Upload->False],
				UploadCloudFile[newFutureNotebookFilename,Upload->False]
			},
			ConstellationMessage->{}
		];

		(* Update the history length since we use these to number the output cells *)
		historyLength=historyLength+1;

		(* Upload with updates *)
		Upload[<|
			Object->comp,

			(* Set Status to error if we errored out *)
			If[erroredOut,Status->Error,Nothing],

			(* Update our kernel history. *)
			Append[History]-><|
				Expression->currentHeldExpression,
				Kernel->SaveKernel[],
				Messages->messages,
				Exception->erroredOut,
				Output->With[{outputExpr=Lookup[evaluatedExpression,"Result"]}, Hold[outputExpr]],
				ObjectsGenerated->Download[currentCreatedObjects,Object]
			|>,

			(* Update the sections JSON, using a Thomas-coined FAT HACK to enforce Base64 encoding *)
			InstanceSectionsJSON->ExportString[
				StringReplace[
					sectionsJSON,
					Alternatives@@AppHelpers`Private`$SpecialCharacters:>""
				],
				"Base64"
			],

			(* Update all of the notebook files and logs *)
			CompletedNotebookFile->Link[newPastNotebookCloudFile],
			Append[CompletedNotebookFileLog]->{Now,Link[newPastNotebookCloudFile],Link[$PersonID]},
			PendingNotebookFile->Link[newFutureNotebookCloudFile],
			Append[PendingNotebookFileLog]->{Now,Link[newFutureNotebookCloudFile],Link[$PersonID]}
		|>];
	];

	(* Manifold logging; if the loop stopped early because of a status change then Echo to stdout *)
	With[{currStatus=Download[comp,Status]},
		If[!MatchQ[currStatus,Running],
			Echo["   Computation stopped early because Status is "<>ToString[currStatus]<>"..."];
		];
	];

	(* Close the notebook objects on exit *)
	UsingFrontEnd[NotebookClose[pastNotebook]];
	UsingFrontEnd[NotebookClose[futureNotebook]];
];


(* ::Subsubsubsection::Closed:: *)
(* unlockNotebook *)

(* Unlock a notebook so that it can be edited. *)
(* NOTE: This function exists separately from the CommandCenter AppHelper version to account for differences between the front-end and Manifold stand-alone Linux Kernel *)
unlockNotebook[notebook_]:=UsingFrontEnd[SetOptions[notebook,
	Editable->True,
	Selectable->True,
	Copyable->True,
	Deletable->True,
	WindowElements->{"VerticalScrollBar","HorizontalScrollBar"}
]];


(* ::Subsubsubsection::Closed:: *)
(* lockNotebook *)

(* Lock a notebook so that it cannot be edited. *)
(* NOTE: This function exists separately from the CommandCenter AppHelper version to account for differences between the front-end and Manifold stand-alone Linux Kernel *)
lockNotebook[notebook_]:=UsingFrontEnd[SetOptions[notebook,
	Editable->False,
	Selectable->True,
	Copyable->False,
	Deletable->False,
	WindowElements->{}
]];
