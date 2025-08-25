(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentCoverQ*)


DefineOptions[ValidExperimentCoverQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentCover}
];

(* --- Source code --- *)
ValidExperimentCoverQ[
  myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[ValidExperimentCoverQ]
]:=Module[
  {listedOptions, preparedOptions, coverTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentCover *)
  coverTests = ExperimentCover[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[coverTests,$Failed],
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
      Flatten[{initialTest,coverTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentCoverQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentCoverQ"]
];


(* ::Subsubsection:: *)
(*ExperimentCoverOptions*)


DefineOptions[ExperimentCoverOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentCover}
];

(* --- Source code --- *)
ExperimentCoverOptions[
  myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions:OptionsPattern[ExperimentCoverOptions]
]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentCover *)
  options=ExperimentCover[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentCover],
    options
  ]
];