(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ValidExperimentSerialDiluteQ*)


DefineOptions[ValidExperimentSerialDiluteQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions:>{ExperimentSerialDilute}
];

(* --- Overloads --- *)
ValidExperimentSerialDiluteQ[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=ValidExperimentSerialDiluteQ[{{mySample}},myOptions];

(*ValidExperimentSerialDiluteQ[mySample:ObjectP[Object[Sample]],myAmount:(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All),myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=ValidExperimentSerialDiluteQ[{{mySample}},{{myAmount}},myOptions];*)

(*ValidExperimentSerialDiluteQ[myContainer:ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=ValidExperimentSerialDiluteQ[{{myContainer}}, myOptions];

ValidExperimentSerialDiluteQ[myContainers:{ListableP[ObjectP[Object[Container]]]..}, myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=Module[
  {listedOptions, preparedOptions, serialDiluteTests, initialTestDescription, allTests, verbose, outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentSerialDilute *)
  serialDiluteTests = ExperimentSerialDilute[myContainers, Append[preparedOptions, Output -> Tests]];

  (* define the general test description *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* make a list of all the tests, including the blanket test *)
  allTests = If[MatchQ[serialDiluteTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {initialTest, validObjectBooleans, voqWarnings, testResults},

      (* generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* create warnings for invalid objects *)
      validObjectBooleans = ValidObjectQ[Download[myContainers, Object], OutputFormat -> Boolean];
      voqWarnings = MapThread[
        Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {Download[myContainers, Object], validObjectBooleans}
      ];

      (* get all the tests/warnings *)
      Flatten[{initialTest, serialDiluteTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentSerialDiluteQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentSerialDiluteQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentSerialDiluteQ"]

];*)

(*Overload for ValidExpSD[{samples},{finalvolume}]*) (*use VolumeP*)
ValidExperimentSerialDiluteQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume -> myFinalVolumes}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[{samples},{serialdilutionfactors}]*) (*use NumericP*)
ValidExperimentSerialDiluteQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {SerialDilutionFactors -> mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[{samples},{targetconcentrations}]*) (*use ConcentrationP*)
ValidExperimentSerialDiluteQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume}]*)
ValidExperimentSerialDiluteQ[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume -> myFinalVolumes}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[samples,{serialdilutionfactors}]*)
ValidExperimentSerialDiluteQ[mySamples:ObjectP[Object[Sample]],mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {SerialDilutionFactors -> mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[samples,{targetconcentrations}]*)
ValidExperimentSerialDiluteQ[mySamples:ObjectP[Object[Sample]],myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[{samples},{finalvolume,targetConcentrations}]*)
ValidExperimentSerialDiluteQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume,targetConcentrations}]*)
ValidExperimentSerialDiluteQ[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[{samples},{finalvolume,serialDilutionFactors}]*)
ValidExperimentSerialDiluteQ[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,SerialDilutionFactors ->mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume,serialDilutionFactors}]*)
ValidExperimentSerialDiluteQ[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,SerialDilutionFactors ->mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ValidExperimentSerialDiluteQ[{mySamples},updatedOptions]
];

(* --- Core Function --- *)
ValidExperimentSerialDiluteQ[mySamples:{ObjectP[Object[Sample]]..},myOptions:OptionsPattern[ValidExperimentSerialDiluteQ]]:=Module[
  {listedOptions,preparedOptions,aliquotTests,allTests,verbose,outputFormat},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* return only the tests for ExperimentSerialDilute *)
  aliquotTests=ExperimentSerialDilute[mySamples,Append[preparedOptions,Output -> Tests]];

  (* make a list of all the tests, including the blanket test *)
  allTests=Module[
    {validObjectBooleans,voqWarnings,testResults},

    (* create warnings for invalid objects *)
    validObjectBooleans=ValidObjectQ[mySamples,OutputFormat->Boolean];
    voqWarnings=MapThread[
      Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
        #2,
        True
      ]&,
      {mySamples,validObjectBooleans}
    ];

    (* get all the tests/warnings *)
    Flatten[{aliquotTests,voqWarnings}]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentSerialDiluteQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
    it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
     ^ what he said - Cam *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentSerialDiluteQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentSerialDiluteQ"]
];


(* ::Subsection::Closed:: *)
(*ExperimentSerialDiluteOptions*)


DefineOptions[ExperimentSerialDiluteOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentSerialDilute}
];

(* --- Overloads --- *)
ExperimentSerialDiluteOptions[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentSerialDiluteOptions]] := ExperimentSerialDiluteOptions[{mySample}, myOptions];

ExperimentSerialDiluteOptions[myContainer : ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentSerialDiluteOptions]] := ExperimentSerialDiluteOptions[{{myContainer}}, myOptions];

ExperimentSerialDiluteOptions[myContainers : {ListableP[ObjectP[Object[Container]]]..}, myOptions : OptionsPattern[ExperimentSerialDiluteOptions]] := Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

  (* return only the options for ExperimentSerialDilute *)
  options = ExperimentSerialDilute[myContainers, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
    LegacySLL`Private`optionsToTable[options, ExperimentSerialDilute],
    options
  ]

];

(*Overload for ValidExpSD[{samples},{finalvolume}]*) (*use VolumeP*)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume -> myFinalVolumes}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[{samples},{serialdilutionfactors}]*) (*use NumericP*)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {SerialDilutionFactors -> mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[{samples},{targetconcentrations}]*) (*use ConcentrationP*)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume}]*)
ExperimentSerialDiluteOptions[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume -> myFinalVolumes}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[samples,{serialdilutionfactors}]*)
ExperimentSerialDiluteOptions[mySamples:ObjectP[Object[Sample]],mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {SerialDilutionFactors -> mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[samples,{targetconcentrations}]*)
ExperimentSerialDiluteOptions[mySamples:ObjectP[Object[Sample]],myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[{samples},{finalvolume,targetConcentrations}]*)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume,targetConcentrations}]*)
ExperimentSerialDiluteOptions[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  myTargetConcentrations:{ListableP[ConcentrationP]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,TargetConcentrations -> myTargetConcentrations}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[{mySamples},updatedOptions]
];

(*Overload for ValidExpSD[{samples},{finalvolume,serialDilutionFactors}]*)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,SerialDilutionFactors ->mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[mySamples,updatedOptions]
];

(*Overload for ValidExpSD[samples,{finalvolume,serialDilutionFactors}]*)
ExperimentSerialDiluteOptions[mySamples:ObjectP[Object[Sample]],myFinalVolumes:{ListableP[(GreaterP[0 Liter]|GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..},
  mySerialDilutionFactors:{ListableP[GreaterP[0]]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]] :=Module[{updatedOptions},
  (* update these option values in the provided options *)
  updatedOptions = ReplaceRule[ToList[myOptions], {FinalVolume->myFinalVolumes,SerialDilutionFactors ->mySerialDilutionFactors}];

  (* pipe to the main overload *)
  ExperimentSerialDiluteOptions[{mySamples},updatedOptions]
];

(* --- Core Function --- *)
ExperimentSerialDiluteOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myOptions:OptionsPattern[ExperimentSerialDiluteOptions]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* return only the options for ExperimentSerialDilute *)
  options=ExperimentSerialDilute[mySamples,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentSerialDilute],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ExperimentSerialDilutePreview*)


DefineOptions[ExperimentSerialDilutePreview,
  SharedOptions:>{ExperimentSerialDilute}
];

(* --- Overloads --- *)
ExperimentSerialDilutePreview[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ExperimentSerialDilutePreview]]:=ExperimentSerialDilutePreview[{mySample},myOptions];

(* --- Core Function --- *)
ExperimentSerialDilutePreview[mySamples:{ListableP[ObjectP[Object[Sample]]]..},myOptions:OptionsPattern[ExperimentSerialDilutePreview]]:=Module[
  {listedOptions,noOutputOptions},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Output->_];

  (* return only the options for ExperimentSerialDilute *)
  ExperimentSerialDilute[mySamples,Append[noOutputOptions,Output->Preview]]
];
