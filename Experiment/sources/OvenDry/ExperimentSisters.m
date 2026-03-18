(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentOvenDryQ*)


DefineOptions[ValidExperimentOvenDryQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentOvenDry}
];

(* --- Source code --- *)
ValidExperimentOvenDryQ[
  myInputs:ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample], Model[Container]}]],
  myOptions:OptionsPattern[ValidExperimentOvenDryQ]
]:=Module[
  {listedOptions, preparedOptions, ovenDryTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentOvenDry *)
  ovenDryTests = ExperimentOvenDry[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[ovenDryTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans,voqWarnings,allObjects},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      allObjects=DeleteDuplicates[Cases[Flatten[{myInputs, myOptions}], ObjectP[], Infinity]];
      validObjectBooleans=ValidObjectQ[
        allObjects,
        OutputFormat->Boolean
      ];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {allObjects,validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Flatten[{initialTest,ovenDryTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentOvenDryQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentOvenDryQ"]
];


(* ::Subsubsection:: *)
(*ExperimentOvenDryOptions*)


DefineOptions[ExperimentOvenDryOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentOvenDry}
];

(* --- Source code --- *)
ExperimentOvenDryOptions[
  myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[ExperimentOvenDryOptions]
]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentOvenDry *)
  options=ExperimentOvenDry[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentOvenDry],
    options
  ]
];

(* ::Subsection::Closed:: *)
(*ExperimentOvenDryPreview*)


DefineOptions[ExperimentOvenDryPreview,
  SharedOptions:>{ExperimentOvenDry}
];


(* --- Source code --- *)
ExperimentOvenDryPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample],Model[Container]}]|_String],myOptions:OptionsPattern[ExperimentOvenDry]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

  (* return only the preview for ExperimentOvenDry *)
  ExperimentOvenDry[myInputs, Append[noOutputOptions, Output -> Preview]]
];