(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(* ValidExperimentScriptQ *)

DefineTests[SaveScriptOutput,
	{
		Example[{Basic,"If the notebook page is not a script, then it will return unevaluated:"},
			Block[{$NotebookPage = Null},
				SaveScriptOutput[cloudFile]
			],
			_SaveScriptOutput
		],
		Example[{Basic,"If the input is not a cloud file, then it will return unevaluated:"},
			Block[{$NotebookPage = scriptObject1},
				SaveScriptOutput[notACloudFile]
			],
			_SaveScriptOutput
		],
		Example[{Basic,"If the input is not a cloud file, then it will return unevaluated:"},
			Block[{$NotebookPage = scriptObject2},
				SaveScriptOutput[cloudFile]
			];
			Download[scriptObject2, Output]
			,
			ObjectP[Object[EmeraldCloudFile]]
		]
	},
	SymbolSetUp:>(
		Block[{$Notebook = Upload[<|Type->Object[LaboratoryNotebook]|>]},
			scriptObject1=Upload[<|Type->Object[Notebook,Script]|>];
			scriptObject2=Upload[<|Type->Object[Notebook,Script]|>];
			cloudFile=UploadCloudFile[Export[FileNameJoin[{$TemporaryDirectory, "save_script_output_test.dat"}], "test"]];
		];),
	SymbolTearDown:>(
		Clear[cloudFile];
		EraseObject[{scriptObject1,scriptObject2}, Force->True, Verbose->False];
	)
];

DefineTests[ValidExperimentScriptQ,
	{
		Example[{Basic,"Indicates if the set of calls can be turned into an experiment script:"},
			ValidExperimentScriptQ[1+1],
			True
		],
		Example[{Messages,"ScriptExperimentCallInLoop","Experiment calls cannot be placed inside of a loop (Do, While, For, Nest, FixedPoint, NestWhile). Please use the Goto[...] and Label[...] functions if looping is desired:"},
			ValidExperimentScriptQ[
				While[True,
					ExperimentHPLC[mySample]
				]
			],
			False,
			Messages:>{Error::ScriptExperimentCallInLoop}
		],
		Example[{Messages,"MultipleLabelsInScript","Label[...] calls can only occur once inside of a given script to avoid ambiguity:"},
			ValidExperimentScriptQ[
				Label[myLabel];

				i=1;

				j=2;

				k=i+j;

				Label[myLabel];

				Goto[myLabel];
			],
			False,
			Messages:>{Error::MultipleLabelsInScript}
		],
		Example[{Messages,"MissingScriptLabelCall","All Goto[...] calls must have a corresponding Label[...]:"},
			ValidExperimentScriptQ[
				i=0;

				Label[myLabel];

				i=i+1;

				Goto[myLabel2];
			],
			False,
			Messages:>{Error::MissingScriptLabelCall}
		],
		Example[{Messages,"ScriptLabelSyntax","Label[...] calls must exist by themselves as a separate step of the script:"},
			ValidExperimentScriptQ[
				i=0;

				If[EvenQ[i],
					Label[myLabel]
				];

				i=i+1;

				Goto[myLabel];
			],
			False,
			Messages:>{Error::ScriptLabelSyntax}
		],
		Example[{Options,OutputFormat,"Return a boolean:"},
			ValidExperimentScriptQ[If[True,ExperimentHPLC[mySamples],ExperimentEvaporate[mySamples]],OutputFormat->Boolean],
			True,
			Messages:>{}
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentScriptQ[1+1,OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print the results of all tests:"},
			ValidExperimentScriptQ[1+1,Verbose->True],
			True
		]
	}
];

(* ::Subsection:: *)
(* Parallel *)

DefineTests[Parallel,
	{
		Example[{Basic,"Indicate that multiple protocols should run in parallel during a single step of the script (if the Parallel[...] head was not included, the DNA Synthesis protocol would have to be finished before the PNA Synthesis protocol could start):"},
			ExperimentScript[
				{myDNASynthesisProtocol,myPNASynthesisProtocol}= Parallel[ExperimentDNASynthesis[Model[Sample,"polyATTest"]],ExperimentPNASynthesis[Model[Sample,"id:6V0npvK7WX8q"],Scale->10 Micromole]];

				myHPLCProtocol = ExperimentHPLC[
					Join[{myDNASynthesisProtocol[SamplesOut],myPNASynthesisProtocol[SamplesOut]}],
					GradientStart->10 Percent,
					GradientEnd->50 Percent,
					GradientDuration->10 Minute
				];
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Additional,"Indicate that two protocols should be forked off and that the script should NOT wait for completion before running the next line:"},
			ExperimentScript[
				{myDNASynthesisProtocol,myPNASynthesisProtocol}= Parallel[ExperimentDNASynthesis[Model[Sample,"polyATTest"]],ExperimentPNASynthesis[Model[Sample,"id:6V0npvK7WX8q"],Scale->10 Micromole], ForkThreads->True];

				ExperimentMix[
					Object[Sample, "id:mnk9jORRPOWw"],
					MixType -> Invert,
					NumberOfMixes -> 5,
					MaxNumberOfMixes -> 10,
					MixUntilDissolved -> True,
					ImageSample -> False
				];
			],
			ObjectP[Object[Notebook,Script]]
		]
	}
];

(* ::Subsection:: *)
(* ExperimentScript *)


DefineTests[ExperimentScript,
	{
		Example[{Basic,"Make a new script using an existing object as a template:"},
			ExperimentScript["My New Script 1",Template->Object[Notebook,Script,"Existing Script"]],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Basic,"Create a new script (separate steps in the script are delineated via semicolons). First the DNA synthesis protocol will run, then the HPLC protocol will run:"},
			ExperimentScript[
				myDNASynthesisProtocol= ExperimentDNASynthesis[Model[Sample,"polyATTest"]];

  			myHPLCProtocol = ExperimentHPLC[
  				myDNASynthesisProtocol[SamplesOut],
  				GradientStart->10 Percent,
  				GradientEnd->50 Percent,
  				GradientDuration->10 Minute
  			];
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Basic,"Indicate that multiple protocols should run in parallel during a single step of the script (if the Parallel[...] head was not included, the DNA Synthesis protocol would have to be finished before the PNA Synthesis protocol could start):"},
			ExperimentScript[
				{myDNASynthesisProtocol,myPNASynthesisProtocol}= Parallel[ExperimentDNASynthesis[Model[Sample,"polyATTest"]],ExperimentPNASynthesis[Model[Sample,"id:6V0npvK7WX8q"],Scale->10 Micromole]];

  			myHPLCProtocol = ExperimentHPLC[
  				Join[{myDNASynthesisProtocol[SamplesOut],myPNASynthesisProtocol[SamplesOut]}],
  				GradientStart->10 Percent,
  				GradientEnd->50 Percent,
  				GradientDuration->10 Minute
  			];
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Basic,"Indicate that the script should pause (the user will be sent a notification):"},
			ExperimentScript[
				myDNASynthesisProtocol=ExperimentDNASynthesis[Model[Sample,"polyATTest"]];

				myHPLCProtocol = ExperimentHPLC[
  				myDNASynthesisProtocol[SamplesOut],
  				GradientStart->10 Percent,
  				GradientEnd->50 Percent,
  				GradientDuration->10 Minute
  			];

  			myPeakAnalysis=AnalyzePeaks[myHPLCProtocol,AbsoluteThreshold->{0},RelativeThreshold->{0.3},Baseline->LocalLinear,Domain->{{2.5,3.2}}];

  			If[Length[myPeakAnalysis[ParentPeak]]!=1||myPeakAnalysis[Area][[1]]<25,
  				PauseScript[];
  			];

  			ShipToUser[myDNASynthesisProtocol[SamplesOut]]
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Basic,"Indicate that the script should loop until a certain criteria is achieved (the sample will continue to be mixed until it is fully dissolved). For more information, please read the documentation pages for the functions Label and Goto:"},
			ExperimentScript[
				Label[start];

				myProtocol=ExperimentMix[
  					Object[Sample, "id:mnk9jORRPOWw"],
  					MixType -> Invert,
  					NumberOfMixes -> 5,
  					MaxNumberOfMixes -> 10,
  					MixUntilDissolved -> True,
  					ImageSample -> False
  				];

				If[!MatchQ[myProtocol[InvertFullyDissolved],{Yes}],
 					Goto[start];
 				];
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Basic,"Generated script notebook should have StyleDefinitions=CommandCenter.nb"},
			Module[{myNotebook},
				myNotebook = Download@ExperimentScript["My test script",Template->Object[Notebook,Script,"Existing Script"]];
				Lookup[
					Options[myNotebook, StyleDefinitions]
					StyleDefinitions
				] =!= "CommandCenter.nb"
			],
			True
		],
		Example[{Additional,"Indicate that two protocols should be forked off and that the script should NOT wait for completion before running the next line:"},
			ExperimentScript[
				{myDNASynthesisProtocol,myPNASynthesisProtocol}= Parallel[ExperimentDNASynthesis[Model[Sample,"polyATTest"]],ExperimentPNASynthesis[Model[Sample,"id:6V0npvK7WX8q"],Scale->10 Micromole], ForkThreads->True];

				ExperimentMix[
					Object[Sample, "id:mnk9jORRPOWw"],
					MixType -> Invert,
					NumberOfMixes -> 5,
					MaxNumberOfMixes -> 10,
					MixUntilDissolved -> True,
					ImageSample -> False
				];
			],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Options,TimeConstraint,"Create a new script which will throw an error if the next step within the script takes more than 30 minutes to evaluate:"},
			ExperimentScript["My New Script 2",Template->Object[Notebook,Script,"Existing Script"],TimeConstraint->30 Minute],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Options,IgnoreWarnings,"Indicate that the script should continue even if calls within throw warnings:"},
			ExperimentScript["My New Script 3",Template->Object[Notebook,Script,"Existing Script"],IgnoreWarnings->True],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Options,Template,"Use an existing object as a template:"},
			ExperimentScript["My New Templated Script",Template->Object[Notebook,Script,"Existing Script"]],
			ObjectP[Object[Notebook,Script]]
		],
		Example[{Options,Autogenerated,"Indicate if the script is generated programmatically:"},
			Module[{script},
				script=ExperimentScript[
					ExperimentTransfer[Model[Sample,"Milli-Q water"],Model[Container,Vessel,"50mL Tube"],1 Milliliter];
					ExperimentTransfer[Model[Sample,"Milli-Q water"],Model[Container,Vessel,"50mL Tube"],1 Milliliter];,
					Autogenerated->True
				];
				Download[script,Autogenerated]
			],
			True
		],
		Example[{Attributes,HoldFirst,"The input expression is held when printed to the script notebook:"},
			ExperimentScript[
				Print["Hello!"];
				2
			],
			ObjectP[Object[Notebook,Script]]
		]
	},
	SymbolSetUp:>Module[{templateNotebookFile,templateNotebook,cloudFile},
		$CreatedObjects={};

		(* Create a template notebook. *)
		(* Note: CreateDocument and CreateNotebook don't work without a front end so we get around this by making blank notebook files, then filling them with cells. *)
		(* Note: Do NOT export as Text as suggested on MM stack exchange. This exports into a .txt instead of a .nb *)
		templateNotebookFile=Export[FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}]," "];

		(* Import the notebooks. *)
		templateNotebook=NotebookOpen[templateNotebookFile,Visible->False];

		(* Put the cells that we want evaluated into the future notebook. *)
		NotebookWrite[templateNotebook,Cell["2+3","Input"]];

		NotebookSave[templateNotebook];
		NotebookClose[templateNotebook];

		cloudFile=UploadCloudFile[templateNotebookFile];
		Upload[
			<|
				Type->Object[Notebook,Script],
				TemplateNotebookFile->Link[cloudFile],
				Name->"Existing Script",
				IgnoreWarnings->False,
				TimeConstraint->5 Minute
			|>
		]
	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];



(* ::Subsection::Closed:: *)
(* PauseScript *)


createTestNotebook[]:=Module[{templateNotebookFile,templateNotebook},
	(* Create a template notebook. *)
	(* Note: CreateDocument and CreateNotebook don't work without a front end so we get around this by making blank notebook files, then filling them with cells. *)
	(* Note: Do NOT export as Text as suggested on MM stack exchange. This exports into a .txt instead of a .nb *)
	templateNotebookFile=Export[FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}]," "];

	(* Import the notebooks. *)
	templateNotebook=NotebookOpen[templateNotebookFile,Visible->False];

	(* Put the cells that we want evaluated into the future notebook. *)
	NotebookWrite[templateNotebook,Cell["2+3","Input"]];
	templateNotebook
];


DefineTests[PauseScript,
	{
		Example[{Basic,"Mark a script as paused so that it will not continue automatically after any current protocols have completed:"},
			Download[PauseScript[Object[Notebook,Script,"Running Script to Pause"]],Status],
			Paused
		],
		Example[{Messages,"IncorrectStatus","In order to pause a script it must be Running:"},
			Download[PauseScript[Object[Notebook,Script,"Completed Script to Pause"]],Status],
			$Failed,
			Messages:>{Error::IncorrectPauseScriptStatus}
		]
	},
	SymbolSetUp:>(
		Module[{templateNotebook,script1,script2},
			$CreatedObjects={};
			(* Create a mathematica notebook *)
			templateNotebook1=createTestNotebook[];
			templateNotebook2=createTestNotebook[];

			(* Create a script object. *)
			script1=SaveScript[templateNotebook1];
			script2=SaveScript[templateNotebook2];
			
			Upload[{
				<|Object->script1,Name->"Running Script to Pause",Status->Running|>,
				<|Object->script2,Name->"Completed Script to Pause",Status->Completed|>
			}]
		]
	),
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(* StopScript *)


DefineTests[StopScript,
	{
		Example[{Basic,"End a script early:"},
			Download[StopScript[Object[Notebook,Script,"Running Script to Stop"]],Status],
			Stopped
		],
		Example[{Basic,"When a script is stopped any of its CurrentProtocols which have not yet been started will be canceled:"},
			Download[StopScript[Object[Notebook,Script,"Script with Protocols to Stop"]],CurrentProtocols[Status]],
			{Processing,Canceled,Canceled,Canceled}
		],
		Example[{Messages,"IncorrectStopScriptStatus","A script can only be stopped if its Status is Running, Paused or Exception:"},
			Download[StopScript[Object[Notebook,Script,"Completed Script to Stop"]],Status],
			$Failed,
			Messages:>{Error::IncorrectStopScriptStatus}
		]
	},
	SymbolSetUp:>(
		createTestNotebook[]:=Module[{templateNotebookFile,templateNotebook},
			(* Create a template notebook. *)
			(* Note: CreateDocument and CreateNotebook don't work without a front end so we get around this by making blank notebook files, then filling them with cells. *)
			(* Note: Do NOT export as Text as suggested on MM stack exchange. This exports into a .txt instead of a .nb *)
			templateNotebookFile=Export[FileNameJoin[{$TemporaryDirectory,CreateUUID[]<>".nb"}]," "];

			(* Import the notebooks. *)
			templateNotebook=NotebookOpen[templateNotebookFile,Visible->False];

			(* Put the cells that we want evaluated into the future notebook. *)
			NotebookWrite[templateNotebook,Cell["2+3","Input"]];
			templateNotebook
		];

		Module[{templateNotebook,script1,script2,script3,incubateProtocol,fkProtocol,massSpecProtocol,statusPackets,centrifugeProtocol},
			$CreatedObjects={};
			(* Create a mathematica notebook *)
			templateNotebook1=createTestNotebook[];
			templateNotebook2=createTestNotebook[];
			templateNotebook3=createTestNotebook[];

			(* Create a script object. *)
			script1=SaveScript[templateNotebook1];
			script2=SaveScript[templateNotebook2];
			script3=SaveScript[templateNotebook3];

			{incubateProtocol,fkProtocol,massSpecProtocol,centrifugeProtocol}=Upload[{
				<|Type->Object[Protocol,Incubate]|>,
				<|Type->Object[Protocol,FluorescenceKinetics]|>,
				<|Type->Object[Protocol,MassSpectrometry]|>,
				<|Type->Object[Protocol,Centrifuge]|>
			}];

			statusPackets=UploadProtocolStatus[{incubateProtocol,fkProtocol},{OperatorProcessing,OperatorStart},Upload->False];

			Upload[
				Join[
					statusPackets,
					{
						<|Object->massSpecProtocol,OperationStatus->None,Status->Backlogged|>, (* Note: UploadProtocolStatus gets angry at us since we're not in a notebook so do this one manually. *)
						<|Object->centrifugeProtocol,OperationStatus->None,Status->ShippingMaterials,DateStarted->Null|>,
						<|Object->script1,Name->"Running Script to Stop",Status->Running|>,
						<|Object->script2,Name->"Script with Protocols to Stop",Status->Running,Replace[CurrentProtocols]->Link[{incubateProtocol,fkProtocol,massSpecProtocol,centrifugeProtocol}]|>,
						<|Object->script3,Name->"Completed Script to Stop",Status->Completed|>
					}
				]
			]
		]
	),
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];



(* ::Subsection::Closed:: *)
(* RunScript *)


DefineTests[RunScript,
	{
		Example[{Basic,"Run a script:"},
			RunScript[myScript],
			ObjectP[myScript]
		],
		Example[{Messages,"ScriptAlreadyCompleted","Scripts that are already completed cannot be run:"},
			RunScript[myCompletedScript],
			$Failed,
			Messages:>{Error::ScriptAlreadyCompleted}
		],
		Example[{Messages,"ScriptException","An error message was thrown during the execution of the script. Please look at the History field of the script or the CompletedNotebook to determine what caused the error:"},
			RunScript[myScriptDivideByZero],
			ObjectP[myScriptDivideByZero],
			Messages:>{Error::ScriptException,Power::infy}
		]
	},
	SymbolSetUp:>(
		Module[{templateNotebook,script1,script2,script3,incubateProtocol,fkProtocol,statusPackets},
			$CreatedObjects={};

			myScript=ExperimentScript[i=1+1];

			myScript2=ExperimentScript[i=1+1];
			myCompletedScript=Upload[<|Object->myScript2,Status->Completed|>];

			myScriptDivideByZero=ExperimentScript[i=1/0];
		]
	),
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
]
