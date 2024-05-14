(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*splitExpressionToNotebook (Helper Function)*)


(* The following function takes in a held expression and split it into separate Input cells in a notebook. *)

SetAttributes[splitExpressionToNotebook,HoldFirst];

DefineOptions[splitExpressionToNotebook,
	Options:>{
		{OutputFormat->Notebook,Notebook|Cells,"Indicates how the data should be returned."}
	}
];

splitExpressionToNotebook[myExpression_,ops:OptionsPattern[]]:=Module[
	{outputFormat,scriptNotebookFile,scriptNotebook,boxes,boxList,splitBoxes,boxRows,cells},

	outputFormat=OptionValue[OutputFormat];

	(* Generate script notebook *)
	(* Note: CreateDocument and CreateNotebook don't work without a front end so we get around this by making blank notebook files, then filling them with cells. *)
	(* Note: Do NOT export as Text as suggested on MM stack exchange. This exports into a .txt instead of a .nb *)
	scriptNotebookFile=Export[FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}]," "];

	(* Open our blank notebook. *)
	scriptNotebook=UsingFrontEnd[NotebookOpen[scriptNotebookFile,Visible->False,StyleDefinitions->"CommandCenter.nb"]];

	(* Delete any cells in the notebook. Creating a notebook sometimes makes a blank cell we don't want. *)
	UsingFrontEnd[NotebookDelete[Cells[scriptNotebook]]];

	(* Returns boxes where each statement is separated by a newline *)
	(* Internal`InheritedBlock is the same as Block except that it allows DownValue definitions to pass through it. *)
	(* Note: This code is based on https://mathematica.stackexchange.com/questions/138436/code-request-make-copy-formatted-code-bulletproof *)
	boxes=Internal`InheritedBlock[
		{
			GeneralUtilities`Formatting`PackagePrivate`sn,
			GeneralUtilities`Formatting`PackagePrivate`fullbox,
			GeneralUtilities`Formatting`PackagePrivate`postHeavyQ,
			GeneralUtilities`Formatting`PackagePrivate`rowbox,
			GeneralUtilities`Formatting`PackagePrivate`box2,
			GeneralUtilities`Formatting`PackagePrivate`$weakSyntax,
			GeneralUtilities`Formatting`PackagePrivate`$syntax
		},

		(* -- The following downvalue/ownvalue overwrites are so that the MM code formatter follows SLL style guide (mainly). -- *)

		(* Overwrite global constants so that syntax uses short hand forms (except for @, which is covered by our next overwrite). *)
		GeneralUtilities`Formatting`PackagePrivate`$weakSyntax = True;
		GeneralUtilities`Formatting`PackagePrivate`$syntax = True;

		(* Overwrite GeneralUtilities`Formatting`PackagePrivate`sn so that symbol names don't include context paths if they are System`, Global`, or ECL`. *)
		GeneralUtilities`Formatting`PackagePrivate`sn[e_] := If[MatchQ[Context[e],"System`"|"Global`"|"ECL`"],
			SymbolName[Unevaluated[e]],
			StringJoin[Context[e], SymbolName[Unevaluated[e]]]
		];

		(* Make a rule for Equal so that we get symbol\[Equal]value, not Equal[symbol, value]. *)
		GeneralUtilities`Formatting`PackagePrivate`fullbox[$lhs:Equal[a_,b_]]:=If[GeneralUtilities`Formatting`PackagePrivate`$syntax,
			GeneralUtilities`Formatting`PackagePrivate`op[GeneralUtilities`Formatting`PackagePrivate`binop["Equal","==",a,b]],
			GeneralUtilities`Formatting`PackagePrivate`box2[$lhs]
		];

		(* Overwrite GeneralUtilities`Formatting`PackagePrivate`fullbox so that @ instead of head[args] doesn't happen. *)
		GeneralUtilities`Formatting`PackagePrivate`fullbox[PatternTest[head_Symbol,Developer`HoldSymbolQ][arg_?GeneralUtilities`Formatting`PackagePrivate`syntaxFreeQ]]:=GeneralUtilities`Formatting`PackagePrivate`stdbox[head,arg];

		(* Overwrite GeneralUtilities`Formatting`PackagePrivate`rowbox for If[...] statements so we get custom formatting (always have indentations between conditions). *)
		(* By the time that rowbox is called (from fullbox \[Rule] box2 \[Rule] stdbox \[Rule] rowbox), stdbox has already fullboxed the args and the head so we don't have to worry about our downvalue overwrite affecting the expansion of the head or args. *)
		GeneralUtilities`Formatting`PackagePrivate`rowbox["If",args___]:=(

			(* Call our main function *)
			(* We use our own functions in the mml to always get indenting for the conditions of the If[...]. *)
			GeneralUtilities`Formatting`PackagePrivate`row[
				"If",
				"[",
				GeneralUtilities`Formatting`PackagePrivate`scope[
					GeneralUtilities`Formatting`PackagePrivate`row[
						GeneralUtilities`Formatting`PackagePrivate`mml@@{ (* We use a List and @@ so that our Sequence@@args evaluates before the HoldAllComplete mml[...]. *)
							Function[GeneralUtilities`Formatting`PackagePrivate`t,
								GeneralUtilities`Formatting`PackagePrivate`seq[GeneralUtilities`Formatting`PackagePrivate`$nt,GeneralUtilities`Formatting`PackagePrivate`t,","]
							],
							Function[GeneralUtilities`Formatting`PackagePrivate`t,
								GeneralUtilities`Formatting`PackagePrivate`seq[GeneralUtilities`Formatting`PackagePrivate`$nt,GeneralUtilities`Formatting`PackagePrivate`t,GeneralUtilities`Formatting`PackagePrivate`$ont]
							],
							Sequence@@args
						}
					]
				],
				"]"
			]
		);

		(* Overwrite GeneralUtilities`Formatting`PackagePrivate`fullbox for Switch statments. *)
		GeneralUtilities`Formatting`PackagePrivate`fullbox[GeneralUtilities`Formatting`PackagePrivate`sw_Switch] := Block[
			{GeneralUtilities`Formatting`PackagePrivate`$i= 1, GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw},

			(* If there are less than 3 parameters or there aren't an odd number of parameters, just format the Switch like normal. *)
			If[Or[
					Less[GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw, 3],
					!OddQ[GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw]
				],
				Return[GeneralUtilities`Formatting`PackagePrivate`box2 @ GeneralUtilities`Formatting`PackagePrivate`sw]
			];

			(* Switch is valid, special formatting. *)
			GeneralUtilities`Formatting`PackagePrivate`row[
				"Switch",
				"[",
				Extract[Unevaluated@GeneralUtilities`Formatting`PackagePrivate`sw,1,GeneralUtilities`Formatting`PackagePrivate`fullbox], (* Take the first element and wrap it in fullbox. *)
				",",
				GeneralUtilities`Formatting`PackagePrivate`scope[ (* Create a scope with the rest of the parameters *)
					GeneralUtilities`Formatting`PackagePrivate`row@@Map[
						GeneralUtilities`Formatting`PackagePrivate`switchArg,
						Rest[Hold @@ Unevaluated[GeneralUtilities`Formatting`PackagePrivate`sw]]
					]
				],
				GeneralUtilities`Formatting`PackagePrivate`$nt,
				"]"
			]
		];

		(* Overwrite GeneralUtilities`Formatting`PackagePrivate`fullbox for Which statments. *)
		GeneralUtilities`Formatting`PackagePrivate`fullbox[GeneralUtilities`Formatting`PackagePrivate`sw_Which] := Block[
			{GeneralUtilities`Formatting`PackagePrivate`$i= 1, GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw},

			(* If there are less than 2 parameters or there aren't an even number of parameters, just format the Which like normal. *)
			If[Or[
					Less[GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw, 2],
					!EvenQ[GeneralUtilities`Formatting`PackagePrivate`$len = Length @ Unevaluated @ GeneralUtilities`Formatting`PackagePrivate`sw]
				],
				Return[GeneralUtilities`Formatting`PackagePrivate`box2 @ GeneralUtilities`Formatting`PackagePrivate`sw]
			];

			(* Which is valid, special formatting. *)
			GeneralUtilities`Formatting`PackagePrivate`row[
				"Which",
				"[",
				GeneralUtilities`Formatting`PackagePrivate`scope[
					GeneralUtilities`Formatting`PackagePrivate`row@@Map[
						GeneralUtilities`Formatting`PackagePrivate`switchArg,
						Hold @@ Unevaluated[GeneralUtilities`Formatting`PackagePrivate`sw]
					]
				],
				GeneralUtilities`Formatting`PackagePrivate`$nt,
				"]"
			]
		];

		(* Overwrite the helper function to determine the indentation for the switches and whiches. *)
		GeneralUtilities`Formatting`PackagePrivate`switchArg[Pattern[GeneralUtilities`Formatting`PackagePrivate`arg, Blank[]]]:=If[!OddQ[Increment@GeneralUtilities`Formatting`PackagePrivate`$i], (* Note: Increment returns the old value of $i *)
			(* Odd case *)
			GeneralUtilities`Formatting`PackagePrivate`scope[
				GeneralUtilities`Formatting`PackagePrivate`seq[
					GeneralUtilities`Formatting`PackagePrivate`$nt,
					GeneralUtilities`Formatting`PackagePrivate`fullbox @ GeneralUtilities`Formatting`PackagePrivate`arg,
					If[GeneralUtilities`Formatting`PackagePrivate`$i>GeneralUtilities`Formatting`PackagePrivate`$len-1,
						GeneralUtilities`Formatting`PackagePrivate`seq[], ","
					]
				]
			],
			(* Even case *)
			GeneralUtilities`Formatting`PackagePrivate`seq[GeneralUtilities`Formatting`PackagePrivate`$nt, GeneralUtilities`Formatting`PackagePrivate`fullbox @ GeneralUtilities`Formatting`PackagePrivate`arg, ","]
		];

		(* Call our main function. *)
		GeneralUtilities`MakeFormattedBoxes[myExpression]
	];

	(* Extract list of boxed expressions. *)
	(* If we have multiple cells, we will have a RowBox of RowBoxes (check to make sure the first argument in the RowBox is another RowBox). Otherwise, we only have one cell. *)
	boxList=If[MatchQ[boxes,Verbatim[RowBox][{Verbatim[RowBox][___],___}]],
		First[boxes],
		{boxes}
	];

	(* MakeFormattedBoxes splits expressions by newlines. So we'll split into lists where each list
	of boxes book-ended by a newline  *)
	splitBoxes=SequenceSplit[DeleteCases[boxList,""],{"\n"}];

	(* Re-wrap RowBox around each expression *)
	splitBoxes=RowBox/@splitBoxes;

	(* Generate cells for script expressions *)
	cells=Cell[BoxData[#],"Input"]&/@splitBoxes;

	If[MatchQ[outputFormat,Notebook],
		(* Write cells to notebook *)
		UsingFrontEnd[NotebookWrite[scriptNotebook,#]]&/@cells;

		(* Return our generated notebook handle. *)
		scriptNotebook,

		cells
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentScript*)


Error::ScriptTemplateRequired="To create a new script, a template script must be specified or the SLL commands must be specified. Please make sure that one of these inputs is given.";

DefineOptions[
	ExperimentScript,
	Options :> {
		{Template->Null,ObjectP[Object[Notebook,Script]],"Indicates the template from which a new script should be generated."},
		{TimeConstraint->Automatic,TimeP,"The maximum amount of time that each cell in this script is allowed to run for before timing out."},
		{IgnoreWarnings->Automatic,BooleanP,"Indicates if the script should be continued even if warnings are thrown."},
		{DisplayName->Null,Null|_String,"Indicates the display name that should be shown when viewing the script in Command Center."},
		{Name->Null,Null|_String,"Indicates the name that should be given to the script object."},
		{ParentProtocol -> Null, Null | ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}], "Indicates the protocol that is generating this script."},
		{Autogenerated->False,BooleanP,"Indicates if the script was created programmatically or by a user."},
		UploadOption
	}
];

(* HoldFirst for raw expression overload *)
SetAttributes[ExperimentScript,HoldFirst];

(* Overload to take in raw expression and create a notebook *)
ExperimentScript[myExpression_,ops:OptionsPattern[]]:=Module[
	{scriptNotebook,script},

	(* Split out held expression into input cells in a notebook. *)
	scriptNotebook=splitExpressionToNotebook[myExpression];

	(* Run the validator -- if it return true, save the script and return it. *)
	If[ValidExperimentScriptQ[myExpression],

		(* Pass notebook to core function to generate script object *)
		script=SaveScript[scriptNotebook,ops];

		(* Close local script notebook *)
		UsingFrontEnd[NotebookClose[scriptNotebook]];

		(* Return script object *)
		script,
		(* Otherwise, just close the notebook and return $Failed. *)
		UsingFrontEnd[NotebookClose[scriptNotebook]];

		$Failed
	]
];

(* Overload to take in raw expression and create a notebook *)
ExperimentScript[myName_String,ops:OptionsPattern[]]:=Module[
	{template,scriptNotebook,script},

	template=Lookup[SafeOptions[ExperimentScript,ToList[ops]], Template];
	If[!MatchQ[template, ObjectP[Object[Notebook, Script]]],
		Message[Error::ScriptTemplateRequired];
	];

	(* Split out held expression into input cells in a notebook. *)
	scriptNotebook=Download[template,TemplateNotebookFile];

	script=SaveScript[scriptNotebook,ops]
];



(* ::Subsection::Closed:: *)
(*RunScript*)


Error::ScriptAlreadyCompleted="The script, `1`, is already completed. Please only specify non-completed scripts to be run.";
Error::ScriptException="During the execution of the script, `1`, messages were thrown or the evaluation of the cell timed out. Messages thrown can be viewed in the History field of the script object. Please inspect these messages before continuing the script. Any protocol objects that were generated have not been automatically confirmed. If you wish for this script to ignore Warning messages, please pass the option IgnoreWarnings->True into ExperimentScript.";

(* The backend function RunScriptJSON does the following: *)
(* This takes a script object and runs it in the local kernel. *)
(* Takes protocols from the CurrentProtocols field and confirms them, if they have not already been confirmed (if pausing happened). *)
(* If there is nothing in CurrentProtocols, runs the next lines in the script, pre-confirming all of the experiments as it goes. *)
(* If the user hits Alt+. on a running script, this function is smart enough to detect that there are no CurrentProtocols and just continues running like nothing ever happened. *)
RunScript[myScript:ObjectP[Object[Notebook,Script]]]:=Module[{scriptStatus,scriptResponse},

	(* Download information from our script. *)
	scriptStatus=Download[
		myScript,
		Status
	];

	(* If the script is already completed, short circuit. *)
	If[MatchQ[scriptStatus,Completed],
		Message[Error::ScriptAlreadyCompleted,ToString[myScript,InputForm]];
		Return[$Failed];
	];

	(* Call our main backend function to run the script. *)
	scriptResponse=RunScriptJSON[myScript,Output->Association];

	(* Throw an error if our script threw an exception. *)
	If[MatchQ[Lookup[scriptResponse,"Status"],Exception],
		Message[Error::ScriptException,myScript];
	];

	(* Return our script object. *)
	Download[myScript,Object]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentScriptQ*)


SetAttributes[ValidExperimentScriptQ,HoldFirst];

DefineOptions[
	ValidExperimentScriptQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	}
];

ValidExperimentScriptQ[myExpression_,ops:OptionsPattern[ValidExperimentScriptQ]]:=Module[
	{safeOps,verbose,outputFormat,scriptNotebook,result},

	(* Get options indicating what to return *)
	safeOps=SafeOptions[ValidExperimentScriptQ,ToList[ops]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(*  Convert our raw script code to a mathematica notebook. *)
	(* Note: Our JSON function will insert red error cells in the given NotebookObject[...] but we're going to throw away the notebook so we don't care. *)
	scriptNotebook=splitExpressionToNotebook[myExpression];

	(* Check validity *)
	result=If[MatchQ[outputFormat,TestSummary]||MatchQ[verbose,True|Failures],
		Module[{tests},
			(* Get a list of tests to run *)
			tests=ValidScriptQJSON[
				scriptNotebook,
				Output->Tests
			];

			(* Run the tests and return the result in the requested format *)
			Lookup[
				RunUnitTest[
					<|"ValidScript"->tests|>,
					Verbose->verbose,
					OutputFormat->outputFormat
				],
				"ValidScript"
			]
		],
		(* Throw messages and return a boolean *)
		ValidScriptQJSON[
			scriptNotebook,
			Messages->True
		]
	];

	(* Close the notebook before we return our result. *)
	UsingFrontEnd[NotebookClose[scriptNotebook]];

	(* Return our result. *)
	result
];


(* ::Subsection::Closed:: *)
(*PauseScript*)


Error::IncorrectPauseScriptStatus="The given script, `1`, has a status of `2`. Only scripts with the status Running can be set to Paused. Please only specify Running scripts to be Paused.";

PauseScript[myScript:ObjectP[Object[Notebook,Script]]]:=Module[
	{status},

	(* Get the current status of our script *)
	status=Download[myScript,Status];

	(* If the script is not running, return early *)
	If[!MatchQ[status,Running],
		Message[Error::IncorrectPauseScriptStatus,ToString[myScript,InputForm],ToString[status]];
		Return[$Failed];
	];

	(* Upload the status to paused. *)
	Upload[<|
		Object->myScript,
		Status->Paused
	|>]
];


(* ::Subsection::Closed:: *)
(*StopScript*)


Error::IncorrectStopScriptStatus="The given script, `1`, has a status of `2`. Only scripts with the status Running, Paused, or Exception can be set to Stopped. Please only specify scripts with these statuses to be Stopped.";

StopScript[myScript:ObjectP[Object[Notebook,Script]]]:=Module[
	{status,currentProtocols,protocolOperationStatuses,protocolStatuses,protocolsToCancel,protocolStatusPackets,protocolStartDates,shippingMaterialsProtocols},

	(* Get the status of our script, current protocol and operation status of current protocols *)
	{status,currentProtocols,protocolOperationStatuses,protocolStatuses,protocolStartDates}=Download[
		myScript,
		{Status,CurrentProtocols,CurrentProtocols[OperationStatus],CurrentProtocols[Status],CurrentProtocols[DateStarted]}
	];

	(* If the script is not in a state from which it can be canceled return early *)
	If[!MatchQ[status,Running|Paused|Exception|Template|InCart],
		Message[Error::IncorrectStopScriptStatus,ToString[myScript,InputForm],ToString[status]];
		Return[$Failed]
	];

	(* Get protocols that are awaiting materials that we should cancel. *)
	shippingMaterialsProtocols=PickList[currentProtocols,Transpose[{protocolOperationStatuses,protocolStatuses,protocolStartDates}],{_,ShippingMaterials,Null}];

	(* We have to set these protocols to InCart before we can cancel them. Upload now. *)
	(* This is okay because we these protocols will not have started yet (DateStarted==Null). *)
	UploadProtocolStatus[shippingMaterialsProtocols,InCart];

	(* Select any protocols which haven't yet been started (OperatorStart, InCart/Backlogged, or protocols that are ShippingMaterials and haven't been started yet). *)
	protocolsToCancel=PickList[currentProtocols,Transpose[{protocolOperationStatuses,protocolStatuses,protocolStartDates}],{OperatorStart,_,_}|{_,Backlogged|InCart,_}|{_,ShippingMaterials,Null}];

	(* Generate updates to cancel those protocols  *)
	protocolStatusPackets=UploadProtocolStatus[protocolsToCancel,Canceled,Upload->False];

	Upload[Join[
		protocolStatusPackets,
		{<|Object->myScript,Status->Stopped|>}
	]];

	(* Return our script object. *)
	Download[myScript,Object]
];


(* ::Subsection::Closed:: *)
(*Parallel*)

Authors[Parallel] := {"brad"};

(* When protocol objects are returned inside of a parallel head, strip off the parallel head (often it's on the right hand side of a set). *)
(* NOTE: This can be a protocol, maintenance, qualification, or script. *)
Parallel[myProtocols___?(MatchQ[ToList[#],{ObjectP[]..}]&), ops:OptionsPattern[]]:=ToList[myProtocols];

(* ::Subsection::Closed:: *)
(*SaveScriptOutput*)

(*When SaveScriptOutput is encountered during the run of a script, it will link the emerald cloud file to the
Output field of the script object.  This is referenced from downloading results of a scrip from Afterburner.*)
SaveScriptOutput[cf: ObjectP[Object[EmeraldCloudFile]]] /; MatchQ[ECL`$NotebookPage, ObjectP[Object[Notebook, Script]]] :=
    Upload[<|Object->ECL`$NotebookPage, Output->Link[cf]|>];
