(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentDynamicLightScatteringQ*)


DefineOptions[ValidExperimentDynamicLightScatteringQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentDynamicLightScattering}
];

(* --- Source code --- *)
ValidExperimentDynamicLightScatteringQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentDynamicLightScatteringQ]]:=Module[
  {listedOptions, preparedOptions, dlsTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentDynamicLightScattering *)
  dlsTests = ExperimentDynamicLightScattering[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[dlsTests,$Failed],
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
      Flatten[{initialTest,dlsTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentDynamicLightScatteringQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentDynamicLightScatteringQ"]
];


(* ::Subsubsection:: *)
(*ExperimentDynamicLightScatteringOptions*)


DefineOptions[ExperimentDynamicLightScatteringOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentDynamicLightScattering}
];

(* --- Source code --- *)
ExperimentDynamicLightScatteringOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentDynamicLightScatteringOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentDynamicLightScattering *)
  options=ExperimentDynamicLightScattering[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentDynamicLightScattering],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ExperimentDynamicLightScatteringPreview*)


DefineOptions[ExperimentDynamicLightScatteringPreview,
  SharedOptions:>{ExperimentDynamicLightScattering}
];


(* --- Source code --- *)
ExperimentDynamicLightScatteringPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentTotalProteinQuantificationPreview]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

  (* return only the preview for ExperimentDynamicLightScattering *)
  ExperimentDynamicLightScattering[myInputs, Append[noOutputOptions, Output -> Preview]]
];
