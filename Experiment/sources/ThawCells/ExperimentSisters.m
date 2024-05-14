(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentThawCellsQ*)


DefineOptions[ValidExperimentThawCellsQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentThawCells}
];

(* --- Source code --- *)
ValidExperimentThawCellsQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[ValidExperimentThawCellsQ]]:=Module[
  {listedOptions, preparedOptions, ThawCellsTests,initialTestDescription, allTests, verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentThawCells *)
  ThawCellsTests = ExperimentThawCells[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[ThawCellsTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans,voqWarnings},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myInputs],Alternatives[_String,{_String..}]],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[ToList[myInputs],Alternatives[_String,{_String..}]],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Flatten[{initialTest,ThawCellsTests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentThawCellsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentThawCellsQ"]
];


(* ::Subsubsection:: *)
(*ExperimentThawCellsOptions*)


DefineOptions[ExperimentThawCellsOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentThawCells}
];

(* --- Source code --- *)
ExperimentThawCellsOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[ExperimentThawCellsOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentThawCells *)
  options=ExperimentThawCells[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentThawCells],
    options
  ]
];