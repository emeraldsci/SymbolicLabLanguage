(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentBioconjugationQ*)


DefineOptions[ValidExperimentBioconjugationQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentBioconjugation}
];

(* --- Source code --- *)
ValidExperimentBioconjugationQ[myInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}],_String]]], myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]], myOptions:OptionsPattern[ValidExperimentBioconjugationQ]]:=Module[
  {listedOptions, preparedOptions, bioconjugationTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentBioconjugation *)
  bioconjugationTests = ExperimentBioconjugation[myInputs, myNewIdentityModels, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[bioconjugationTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans,voqWarnings},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[Flatten[{myInputs,myNewIdentityModels}],Alternatives[_String,{_String..}]],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[Flatten[{myInputs,myNewIdentityModels}],_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Cases[Flatten[{initialTest,bioconjugationTests,voqWarnings}],_EmeraldTest]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentBioconjugationQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentBioconjugationQ"]
];

(* ::Subsubsection:: *)
(*ExperimentBioconjugationOptions*)


DefineOptions[ExperimentBioconjugationOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentBioconjugation}
];

(* --- Source code --- *)
ExperimentBioconjugationOptions[myInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}],_String]]], myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]], myOptions:OptionsPattern[ExperimentBioconjugationOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentBioconjugation *)
  options=ExperimentBioconjugation[myInputs, myNewIdentityModels, Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentBioconjugation],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ExperimentBioconjugationPreview*)


DefineOptions[ExperimentBioconjugationPreview,
  SharedOptions:>{ExperimentBioconjugation}
];


(* --- Source code --- *)
ExperimentBioconjugationPreview[myInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}],_String]]], myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]], myOptions:OptionsPattern[ExperimentBioconjugationPreview]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

  (* return only the preview for ExperimentBioconjugation *)
  ExperimentBioconjugation[myInputs,myNewIdentityModels, Append[noOutputOptions, Output -> Preview]]
];
