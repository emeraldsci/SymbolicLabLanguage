(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentPAGEOptions*)


(* ExperimentPAGEOptions *)
DefineOptions[ExperimentPAGEOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Determines whether the function returns a table or a list of the options."
    }},
  SharedOptions:>{ExperimentPAGE}
];

ExperimentPAGEOptions[myInputs:ListableP[ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* Get only the options for ExperimentPAGE *)
  options=ExperimentPAGE[myInputs,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentPAGE],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ExperimentPAGEPreview*)


(* ExperimentPAGEPreview *)
DefineOptions[ExperimentPAGEPreview,
  SharedOptions:>{ExperimentPAGE}
];

ExperimentPAGEPreview[myInputs:ListableP[ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions},

  (* Get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Output->_];

  (* Return Null *)
  ExperimentPAGE[myInputs,Append[noOutputOptions,Output->Preview]]
];

(* ValidExperimentPAGEQ *)
DefineOptions[ValidExperimentPAGEQ,
  Options:>
      {
        VerboseOption,
        OutputFormatOption
      },
  SharedOptions:>{ExperimentPAGE}
];


(* ::Subsection::Closed:: *)
(*ValidExperimentPAGEQ*)


ValidExperimentPAGEQ[myInputs:ListableP[ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,preparedOptions,ExperimentPAGETests,initialTestDescription,allTests,verbose,outputFormat},

  (* Get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* Return only the tests for ExperimentPAGE *)
  ExperimentPAGETests=ExperimentPAGE[myInputs,Append[preparedOptions,Output->Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[ExperimentPAGETests,$Failed],
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
      Flatten[{initialTest,ExperimentPAGETests,voqWarnings}]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentPAGEQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentPAGEQ"]
];
