(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*ExperimentLyseCellsOptions*)


DefineOptions[ExperimentLyseCellsOptions,
  SharedOptions :> {ExperimentLyseCells},
  {
    OptionName -> OutputFormat,
    Default -> Table,
    AllowNull -> False,
    Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
    Description -> "Determines whether the function returns a table or a list of the options."
  }
];


ExperimentLyseCellsOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentLyseCellsOptions[{sampleIn},myOptions];
ExperimentLyseCellsOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

  (* return only the options for ExperimentLyseCells *)
  options = ExperimentLyseCells[samplesIn, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
    LegacySLL`Private`optionsToTable[options,ExperimentLyseCells],
    options
  ]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentLyseCellsQ*)


DefineOptions[ValidExperimentLyseCellsQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentEvaporate}
];


ValidExperimentLyseCellsQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentLyseCellsQ]]:=Module[
  {listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat},

  listedInput=ToList[myInput];
  listedOptions=ToList[myOptions];

  (* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
  preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

  (* Call the function to get a list of tests *)
  functionTests=ExperimentLyseCells[myInput,preparedOptions];

  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  allTests=If[MatchQ[functionTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
      voqWarnings=MapThread[
        Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
          #2,
          True
        ]&,
        {DeleteCases[listedInput,_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Join[{initialTest},functionTests,voqWarnings]
    ]
  ];

  (* Lookup test running options *)
  safeOps=SafeOptions[ValidExperimentLyseCellsQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
  {verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

  (* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
  Lookup[
    RunUnitTest[
      <|"ExperimentLyseCells"->allTests|>,
      Verbose->verbose,
      OutputFormat->outputFormat
    ],
    "ExperimentLyseCells"
  ]
];



(* ::Section:: *)
(*End Private*)