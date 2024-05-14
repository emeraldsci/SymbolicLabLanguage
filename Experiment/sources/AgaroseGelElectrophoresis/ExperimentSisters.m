(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentAgaroseGelElectrophoresisQ*)


DefineOptions[ValidExperimentAgaroseGelElectrophoresisQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentAgaroseGelElectrophoresis}
];

(* --- Source code --- *)
ValidExperimentAgaroseGelElectrophoresisQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentAgaroseGelElectrophoresisQ]]:=Module[
  {listedOptions, preparedOptions, agaroseTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentAgaroseGelElectrophoresis *)
  agaroseTests = ExperimentAgaroseGelElectrophoresis[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[agaroseTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans,voqWarnings},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myInputs],_String],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[ToList[myInputs],_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Flatten[{initialTest,agaroseTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentAgaroseGelElectrophoresisQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentAgaroseGelElectrophoresisQ"]
];


(* ::Subsubsection:: *)
(*ExperimentAgaroseGelElectrophoresisOptions*)


DefineOptions[ExperimentAgaroseGelElectrophoresisOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentAgaroseGelElectrophoresis}
];

(* --- Source code --- *)
ExperimentAgaroseGelElectrophoresisOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ExperimentAgaroseGelElectrophoresisOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentAgaroseGelElectrophoresis *)
  options=ExperimentAgaroseGelElectrophoresis[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentAgaroseGelElectrophoresis],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ExperimentAgaroseGelElectrophoresisPreview*)


DefineOptions[ExperimentAgaroseGelElectrophoresisPreview,
  SharedOptions:>{ExperimentAgaroseGelElectrophoresis}
];


(* --- Source code --- *)
ExperimentAgaroseGelElectrophoresisPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ExperimentTotalProteinQuantificationPreview]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

  (* return only the preview for ExperimentAgaroseGelElectrophoresis *)
  ExperimentAgaroseGelElectrophoresis[myInputs, Append[noOutputOptions, Output -> Preview]]
];
