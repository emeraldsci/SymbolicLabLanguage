(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentLiquidLiquidExtractionOptions*)

DefineOptions[ExperimentLiquidLiquidExtractionOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions :> {ExperimentLiquidLiquidExtraction}
];

ExperimentLiquidLiquidExtractionOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentLiquidLiquidExtractionOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* Get only the options for ExperimentLiquidLiquidExtraction *)
  options=ExperimentLiquidLiquidExtraction[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentLiquidLiquidExtraction],
    options
  ]
];

(* ::Subsection:: *)
(*ValidExperimentLiquidLiquidExtractionQ*)

DefineOptions[ValidExperimentLiquidLiquidExtractionQ,
  Options:>
      {
        VerboseOption,
        OutputFormatOption
      },
  SharedOptions:>{ExperimentLiquidLiquidExtraction}
];

ValidExperimentLiquidLiquidExtractionQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentLiquidLiquidExtractionQ]]:=Module[
  {listedOptions,preparedOptions,experimentLiquidLiquidExtractionTests,initialTestDescription,allTests,verbose,outputFormat},

  (* Get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* Return only the tests for ExperimentLiquidLiquidExtraction *)
  experimentLiquidLiquidExtractionTests=ExperimentLiquidLiquidExtraction[myInputs,Append[preparedOptions,Output->Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[experimentLiquidLiquidExtractionTests,$Failed],
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
      Flatten[{initialTest,experimentLiquidLiquidExtractionTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentLiquidLiquidExtractionQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentLiquidLiquidExtractionQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentLiquidLiquidExtractionPreview*)


DefineOptions[ExperimentLiquidLiquidExtractionPreview,
  SharedOptions:>{ExperimentLiquidLiquidExtraction}
];
Authors[ExperimentLiquidLiquidExtractionPreview]:={"ben", "thomas", "lige.tonggu"};
ExperimentLiquidLiquidExtractionPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentLiquidLiquidExtractionPreview]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Output->_];

  (* return only the preview for ExperimentLiquidLiquidExtraction *)
  ExperimentLiquidLiquidExtraction[myInputs,Append[noOutputOptions,Output->Preview]]
];
