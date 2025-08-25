(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*BindingKinetics: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*AnalyzeBindingKinetics*)


DefineTests[AnalyzeBindingKinetics,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry] with kinetics Data, AnalyzeBindingKinetics returns an Analysis Object:"},
      AnalyzeBindingKinetics[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics tests with dissociation"<>$SessionUUID]],
      {ObjectP[Object[Analysis, BindingKinetics]], ObjectP[Object[Analysis, BindingKinetics]]},
      TimeConstraint -> 1000
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with association and dissociation data, AnalyzeBindingKinetics returns an Analysis Object:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID]],
      ObjectP[Object[Analysis, BindingKinetics]],
      TimeConstraint -> 1000
    ],
    Example[{Additional, "Given raw association and dissociation data, AnalyzeBindingKinetics returns an Analysis Object:"},
      AnalyzeBindingKinetics[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID][KineticsAssociation],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID][KineticsDissociation],
        AnalyteDilutions -> {100, 50, 25, 12.5, 6.25}*10^-9*Molar
      ],
      ObjectP[Object[Analysis, BindingKinetics]],
      TimeConstraint -> 1000
    ],
    Example[{Basic, "AnalyzeBindingKinetics populates the KineticsAnalysis field with a data object containing the relevant fields:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID]];
      First[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID][KineticsAnalysis]
      ][{AssociationRates, DissociationRates, DissociationConstants, PredictedTrajectories, Residuals}],
      {
        {___},
        {___},
        {___},
        {___},
        {___}
      }
    ],
    Example[{Additional, "Given dilution concentrations in mass/volume units, AnalyzeBindingKinetics runs without issue:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with mg/mL concs"<>$SessionUUID]],
      ObjectP[Object[Analysis, BindingKinetics]]
    ],

    (* ------------- *)
    (* -- options -- *)
    (* ------------- *)

    Example[{Options, AnalyteDilutions, "Set the dilution values to set values:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AnalyteDilutions -> {100, 50, 25, 12.5, 6.25}*10^-9*Molar,
        Output->Options];
      Lookup[options, AnalyteDilutions],
      {100, 50, 25, 12.5, 6.25}*10^-9*Molar
    ],
    Example[{Options, AnalyteDilutions, "Automatically resolve the dilution values:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AnalyteDilutions -> Automatic,
        Output->Options];
      Lookup[options, AnalyteDilutions],
      {_?QuantityQ..}
    ],

    (* fit model *)
    Example[{Options, FitModel, "Set the fit model based on the expected binding stoichiometry and mechanism:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        FitModel -> OneToOne,
        Output->Options];
      Lookup[options, FitModel],
      OneToOne
    ],

    (* simultaneous fit *)
    Example[{Options, SimultaneousFit, "Request that each set of association/dissociaiton data be fit individually:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        SimultaneousFit -> True,
        Output->Options];
      Lookup[options, SimultaneousFit],
      True
    ],

    (* OptimizationType *)
    Example[{Options, OptimizationType, "Specify if the curves shoudl be fitted using Local or Global optimization:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        OptimizationType -> Global,
        Output->Options];
      Lookup[options, OptimizationType],
      Global
    ],

    (* LinkMaxResponse *)
    Example[{Options, LinkMaxResponse, "Specify a single value should be used to fit the maximum response of each probe, or if each probe shoudl be treated individually:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        LinkMaxResponse -> True,
        Output->Options];
      Lookup[options, LinkMaxResponse],
      True
    ],

    (* CompletelyReversibleBinding *)
    Example[{Options, CompletelyReversibleBinding, "Specify if dissociation is expected to be completely reversible meaning that the signal should return to pre-association baseline levels:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        CompletelyReversibleBinding -> True,
        Output->Options];
      Lookup[options, CompletelyReversibleBinding],
      True
    ],

    (* ExcludeDilution *)
    Example[{Options, ExcludeDilution, "Specify if a particular dilution value should be excluded in the fitting:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        ExcludeDilution -> {1,4},
        Output->Options];
      Lookup[options, ExcludeDilution],
      {1,4}
    ],
    (* AssociationFitDomain *)
    Example[{Options, AssociationFitDomain, "Specify the domain to fit for the association curves:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AssociationFitDomain -> ConstantArray[{1 Second, 1900 Second}, 5],
        Output->Options];
      Lookup[options, AssociationFitDomain],
      ConstantArray[{1 Second, 1900 Second}, 5]
    ],

    (* DissociationFitDomain *)
    (*TODO: looks like the domain is done after alignment. Should fix this or change the description.*)
    Example[{Options, DissociationFitDomain, "Specify the domain to fit for the dissociation curves:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DissociationFitDomain -> ConstantArray[{1 Second, 3500 Second}, 5],
        Output->Options];
      Lookup[options, DissociationFitDomain],
      ConstantArray[{1 Second, 3500 Second}, 5]
    ],
    (* NormalizeAssociationStart *)
    Example[{Options, NormalizeAssociationStart, "Specify if the association curves should be normalized ot start at (0 Second, 0 Nanometer):"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        NormalizeAssociationStart -> True,
        Output->Options];
      Lookup[options, NormalizeAssociationStart],
      True
    ],

    (* MatchDissociationStart *)
    Example[{Options, MatchDissociationStart, "Specify if the dissociation curves should be normalized to match the last value of the matching association data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        MatchDissociationStart -> True,
        Output->Options];
      Lookup[options, MatchDissociationStart],
      True
    ],

    (* AssociationBaselines *)
    Example[{Options, AssociationBaselines, "Specify a  data object containing the baseline values used for the association data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AssociationBaselines -> Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        Output->Options];
      Lookup[options, AssociationBaselines],
      Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID]
    ],
    Example[{Options, AssociationBaselines, "Specify a constant value to use as a baseline for all of the association data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AssociationBaselines -> ConstantArray[0.001 Nanometer, 5],
        Output->Options];
      Lookup[options, AssociationBaselines],
      ConstantArray[0.001 Nanometer, 5]
    ],
    Example[{Options, AssociationBaselines, "If the specified object does not have any baseline data, finish the analysis with the raw association/dissociation data:"},
      options = AnalyzeBindingKinetics[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 3"<>$SessionUUID],
        Output->Options
      ];
      Lookup[options, AssociationBaselines],
      {}
    ],

    (* DissociationBaselines *)
    Example[{Options, DissociationBaselines, "Specify a  data object containing the baseline values used for the dissociation data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DissociationBaselines -> Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        Output->Options];
      Lookup[options, DissociationBaselines],
      Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID]
    ],
    Example[{Options, DissociationBaselines, "Specify a constant value to use as a baseline for all of the dissocaition data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DissociationBaselines -> ConstantArray[0.001 Nanometer,5],
        Output->Options];
      Lookup[options, DissociationBaselines],
      ConstantArray[0.001 Nanometer,5]
    ],

    (* AssociationRate *)
    Example[{Options, AssociationRate, "Specify an initial guess for the range association rate constant (ka):"},
      options = Quiet[AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AssociationRate -> {10^5, 10^7},
        Output->Options],
        NMinimize::cvmit
      ];
      Lookup[options, AssociationRate],
      {10^5, 10^7}
    ],

    (* DissociationRate *)
    Example[{Options, DissociationRate, "Specify an initial guess for the range dissociation rate constant (kd):"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DissociationRate -> {10^-7, 10^-5},
        Output->Options];
      Lookup[options, DissociationRate],
      {10^-7, 10^-5}
    ],

    (* MaxResponse *)
    Example[{Options, MaxResponse, "Specify an initial guess for the range of maximum response (Rmax):"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        MaxResponse -> {1 Nanometer, 2 Nanometer},
        Output->Options];
      Lookup[options, MaxResponse],
      {1 Nanometer,2 Nanometer}
    ],

    (* OptimizationOptions *)
    Example[{Options, OptimizationOptions, "Specify the optimization options for a fit method:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        OptimizationOptions->{AccuracyGoal->8, PrecisionGoal->4},
        Output->Options];
      Lookup[options, OptimizationOptions],
      {AccuracyGoal->8, PrecisionGoal->4}
    ],

    (* DataFilterType *)
    Example[{Options, DataFilterType, "Specify the type of function used to filter the data (options restricted to Gaussian, Mean, and Median):"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DataFilterType->Mean,
        Output->Options];
      Lookup[options, DataFilterType],
      Mean
    ],

    (* DataFilterWidth *)
    Example[{Options, DataFilterWidth, "Specify the width (in time units) of the window used to filter the data:"},
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        DataFilterWidth->2*Second,
        Output->Options];
      Lookup[options, DataFilterWidth],
      2*Second
    ],

    (* Template *)
    Example[{Options, Template, "Specify a template object to copy option sets from. User-defined options in the current function call override any options in the template:"},
      temp = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID], DataFilterWidth->2*Second];
      options = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        Template->temp,
        Output->Options];
      Lookup[options, DataFilterWidth],
      2*Second
    ],

    (* -------------- *)
    (* -- Messages -- *)
    (* -------------- *)

    Example[{Messages, "BindingKineticsMultipleAnalytes", "A warning is printed when multiple analytes are present in the input sample:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with multiple analytes with mg/mL concs"<>$SessionUUID]],
      ObjectP[Object[Analysis,BindingKinetics]],
      Messages:>{Warning::BindingKineticsMultipleAnalytes}
    ],
    Example[{Messages, "NoMolecularWeight", "An error is thrown when the linked molecule has no molecular weight used to convert mg/mL units:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with mg/mL concs and no molecular weight"<>$SessionUUID]],
      $Failed,
      Messages:>{Error::NoMolecularWeight}
    ],
    Example[{Messages, "InvalidBindingKineticsDataType", "An error is thrown when the data input does not have the DataType of Kinetics:"},
      AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object with wrong DataType AnalyzeBindingKinetics "<>$SessionUUID]],
      $Failed,
      Messages:>{Error::InvalidBindingKineticsDataType}
    ],
    Example[{Messages, "NoBindingKineticsData", "An error is thrown when the input protocol does not have any data objects:"},
      AnalyzeBindingKinetics[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics with no data"<>$SessionUUID]],
      $Failed,
      Messages:>{Error::NoBindingKineticsData}
    ],
    Example[{Messages, "SwappedBindingKineticsParameterGuesses", "An error is thrown when the initial parameter guesses are inverted (for example, max should be min and vice versa):"},
      AnalyzeBindingKinetics[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        AssociationRate -> {10^7, 10^5}
      ],
      $Failed,
      Messages:>{Error::SwappedBindingKineticsParameterGuesses}
    ]

  },

  HardwareConfiguration->HighRAM,

  SymbolSetUp :> analyzeBindingKineticsSetUp["AnalyzeBindingKinetics"],

  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics tests with dissociation"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics with no data"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics tests with dissociation no baseline"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKinetics tests without dissociation"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with wrong DataType AnalyzeBindingKinetics "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests 3"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingKinetics tests (no dissociation) 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingKinetics tests (no dissociation) 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with mg/mL concs"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with mg/mL concs and no molecular weight"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKinetics tests with multiple analytes with mg/mL concs"<>$SessionUUID],
        Object[Sample, "Test sample for AnalyzeBindingKinetics 1"<>$SessionUUID],
        Object[Sample, "Test sample for AnalyzeBindingKinetics 2"<>$SessionUUID],
        Object[Sample, "Test sample for AnalyzeBindingKinetics with multiple analytes"<>$SessionUUID],
        Object[Sample, "Test sample for AnalyzeBindingKinetics with mg/mL analytes"<>$SessionUUID],
        Object[Sample, "Test sample for AnalyzeBindingKinetics with mg/mL analytes and no molecular weight"<>$SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];


analyzeBindingKineticsSetUp[label_String]:=Module[{objs, existingObjs, standardData, testData, dataPackets, protocolObjectPacket,
    fakeUnitlessAssociationData, analyteConcentrations, fakeAssociationData,
    fakeAssociationBaselines, fakeDissociationData, fakeUnitlessDissociationData, fakeDissociationBaselines,
    fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, proteins, badProtein,
    associationEndTime, dissociationEndTime},

    objs = Quiet[Cases[
      Flatten[{
        Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" with no data"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" tests with dissociation"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" tests with dissociation no baseline"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" tests without dissociation"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with wrong DataType "<>label<>" "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 3"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no dissociation) 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no dissociation) 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests with mg/mL concs"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests with mg/mL concs and no molecular weight"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests with multiple analytes with mg/mL concs"<>$SessionUUID],
        Object[Sample, "Test sample for "<>label<>" 1"<>$SessionUUID],
        Object[Sample, "Test sample for "<>label<>" 2"<>$SessionUUID],
        Object[Sample, "Test sample for "<>label<>" with multiple analytes"<>$SessionUUID],
        Object[Sample, "Test sample for "<>label<>" with mg/mL analytes"<>$SessionUUID],
        Object[Sample, "Test sample for "<>label<>" with mg/mL analytes and no molecular weight"<>$SessionUUID]
      }],
      ObjectP[]
    ]];

    existingObjs = PickList[objs, DatabaseMemberQ[objs]];

    EraseObject[existingObjs, Force -> True, Verbose -> False];

    (*TODO: make more of the models - right now it is only 1:1. This can be fit usign the other models so it should be ok for testing but can cause NDSolve to freak out*)
    (* make an expression to generate fake data with 1:1 model, Rmax = 2 nm, kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
    fakeABKAssociation[t_, conc_]:= 2*(1/(1+0.0001/(20000*conc)))*(1 - Exp[-(20000*conc + 0.0001)*t]);
    fakeABKDissociation[t_,t0_,conc_]:=fakeABKAssociation[t0, conc]*Exp[-(0.0001)*(t-t0)];
    analyteConcentrations = {100, 50, 25, 12.5, 6.25}*10^-9;

    associationEndTime = 1000;
    dissociationEndTime = 2000;

    (* generate some fake data *)
    fakeUnitlessAssociationData = Map[
      Table[
        {t,N[(fakeABKAssociation[t, #])]},
        {t,0,associationEndTime}
      ]&,
      analyteConcentrations
    ];
    fakeUnitlessDissociationData = Map[
      Table[
        {t,N[(fakeABKDissociation[t, associationEndTime, #])]},
        {t,associationEndTime,dissociationEndTime}
      ]&,
      analyteConcentrations
    ];

    (* make Quantity arrays for the data and some baselines *)
    fakeAssociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessAssociationData;
    fakeAssociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,0, associationEndTime}], {Second, Nanometer}], 5];
    fakeDissociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessDissociationData;
    fakeDissociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,associationEndTime, dissociationEndTime}], {Second, Nanometer}], 5];

    (* create 2 protein packets with a MW and 1 without *)
    proteinPackets = {<|Type -> Model[Molecule, Protein, Antibody], MolecularWeight -> 100 Gram/Mole|>,
                      <|Type -> Model[Molecule, Protein, Antibody], MolecularWeight -> 200 Gram/Mole|>};
    proteins = Upload[proteinPackets];

    badproteinPackets = {<|Type -> Model[Molecule, Protein, Antibody], MolecularWeight -> Null|>};
    badProtein = First[Upload[badproteinPackets]];

    (* make a basic fake sample to reference *)
    {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5} = Upload[
      {
        <|
          Type -> Object[Sample],
          Name -> "Test sample for "<>label<>" 1"<>$SessionUUID
        |>,
        <|
          Type -> Object[Sample],
          Name -> "Test sample for "<>label<>" 2"<>$SessionUUID
        |>,
        <|
          Type -> Object[Sample],
          Name -> "Test sample for "<>label<>" with multiple analytes"<>$SessionUUID,
          Replace[Composition] -> {{0.1 Milligram/Milliliter, Link[proteins[[1]]], Now},{0.2 Milligram/Milliliter, Link[proteins[[2]]], Now}}
        |>,
        <|
          Type -> Object[Sample],
          Name -> "Test sample for "<>label<>" with mg/mL analytes"<>$SessionUUID,
          Replace[Composition] -> {{0.1 Milligram/Milliliter, Link[proteins[[1]]], Now}}
        |>,
        <|
          Type -> Object[Sample],
          Name -> "Test sample for "<>label<>" with mg/mL analytes and no molecular weight"<>$SessionUUID,
          Replace[Composition] -> {{0.1 Milligram/Milliliter, Link[badProtein], Now}}
        |>
      }
    ];

    (* data packets for full data sets and those without dissociation *)
    dataPackets = {
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with wrong DataType "<>label<>" "<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample1, Data]},
        DataType -> Quantitation,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests 1"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample1, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests 2"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample2, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests with mg/mL concs"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample4, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^7)*Milligram/Milliliter,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests with mg/mL concs and no molecular weight"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample5, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^7)*Milligram/Milliliter,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests with multiple analytes with mg/mL concs"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample3, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^7)*Milligram/Milliliter,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object for "<>label<>" tests (no dissociation) 1"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample1, Data]},
        DataType -> Kinetics,
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> Null,
        Replace[KineticsDissociationBaselines] -> Null
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object for "<>label<>" tests (no dissociation) 2"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample2, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
        Replace[KineticsDissociation] -> Null,
        Replace[KineticsDissociationBaselines] -> Null
      ],
      Association[
        Type -> Object[Data, BioLayerInterferometry],
        Name -> "Test data object with dissociation for "<>label<>" tests 3"<>$SessionUUID,
        Replace[SamplesIn] -> {Link[fakeSample2, Data]},
        DataType -> Kinetics,
        Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
        Replace[KineticsAssociation] -> fakeAssociationData,
        Replace[KineticsAssociationBaselines] -> Null,
        Replace[KineticsDissociation] -> fakeDissociationData,
        Replace[KineticsDissociationBaselines] -> Null
      ]
    };

    Upload[dataPackets];

    (*Make a test protocol object*)
    protocolObjectPacket = {
      Association[
        Type -> Object[Protocol, BioLayerInterferometry],
        Name ->  "Test protocol object for "<>label<>" with no data"<>$SessionUUID,
        (*add the data*)
        Replace[Data] -> {}
      ],
      Association[
        Type -> Object[Protocol, BioLayerInterferometry],
        Name ->  "Test protocol object for "<>label<>" tests with dissociation"<>$SessionUUID,
        (*add the data*)
        Replace[Data] -> {
          Link[Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 1"<>$SessionUUID], Protocol],
          Link[Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 2"<>$SessionUUID], Protocol]
        }
      ],
      Association[
        Type -> Object[Protocol, BioLayerInterferometry],
        Name ->  "Test protocol object for "<>label<>" tests without dissociation"<>$SessionUUID,
        (*add the data*)
        Replace[Data] -> {
          Link[Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no dissociation) 1"<>$SessionUUID], Protocol],
          Link[Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no dissociation) 2"<>$SessionUUID], Protocol]
        }
      ],
      Association[
        Type -> Object[Protocol, BioLayerInterferometry],
        Name ->  "Test protocol object for "<>label<>" tests with dissociation no baseline"<>$SessionUUID,
        Replace[Data] -> {
          Link[Object[Data, BioLayerInterferometry, "Test data object with dissociation for "<>label<>" tests 3"<>$SessionUUID], Protocol]
        }
      ]
    };

    Upload[protocolObjectPacket];
  ];





(* ::Subsubsection:: *)
(*ValidAnalyzeBindingKineticsQ*)


DefineTests[ValidAnalyzeBindingKineticsQ,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry] with kinetics Data, ValidAnalyzeBindingKineticsQ returns True:"},
      ValidAnalyzeBindingKineticsQ[Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests with dissociation"<>$SessionUUID]],
      True,
      TimeConstraint -> 1000
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with association and dissociation data, ValidAnalyzeBindingKineticsQ returns True:"},
      ValidAnalyzeBindingKineticsQ[Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 1"<>$SessionUUID]],
      True,
      TimeConstraint -> 1000
    ],
    Example[{Basic, "Given raw association and dissociation data, ValidAnalyzeBindingKineticsQ returns True:"},
      ValidAnalyzeBindingKineticsQ[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 1"<>$SessionUUID][KineticsAssociation],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 1"<>$SessionUUID][KineticsDissociation],
        AnalyteDilutions -> {100, 50, 25, 12.5, 6.25}*10^-9*Molar
      ],
      True,
      TimeConstraint -> 1000
    ],
    Example[{Additional, "Given dilution concentrations in mass/volume units, ValidAnalyzeBindingKineticsQ runs without issue:"},
      ValidAnalyzeBindingKineticsQ[Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests with mg/mL concs"<>$SessionUUID]],
      True
    ],
    Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidAnalyzeBindingKineticsQ[Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests with dissociation"<>$SessionUUID], OutputFormat->TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		ValidAnalyzeBindingKineticsQ[Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests with dissociation"<>$SessionUUID],Verbose->True],
		True
	]
  },

  SymbolSetUp :> analyzeBindingKineticsSetUp["ValidAnalyzeBindingKineticsQ"],

  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests with dissociation"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ with no data"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests with dissociation no baseline"<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingKineticsQ tests without dissociation"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with wrong DataType ValidAnalyzeBindingKineticsQ "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests 3"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingKineticsQ tests (no dissociation) 1"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingKineticsQ tests (no dissociation) 2"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests with mg/mL concs"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests with mg/mL concs and no molecular weight"<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for ValidAnalyzeBindingKineticsQ tests with multiple analytes with mg/mL concs"<>$SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeBindingKineticsQ 1"<>$SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeBindingKineticsQ 2"<>$SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeBindingKineticsQ with multiple analytes"<>$SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeBindingKineticsQ with mg/mL analytes"<>$SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeBindingKineticsQ with mg/mL analytes and no molecular weight"<>$SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];

(* ::Subsubsection:: *)
(*AnalyzeBindingKineticsOptions*)


DefineTests[AnalyzeBindingKineticsOptions,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry] with kinetics Data, AnalyzeBindingKinetics returns the calculated options:"},
      AnalyzeBindingKineticsOptions[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKineticsOptions tests with dissociation"<>$SessionUUID]],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with association and dissociation data, AnalyzeBindingKineticsOptions returns the calculated options:"},
      AnalyzeBindingKineticsOptions[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsOptions tests 1"<>$SessionUUID]],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Additional, "Given raw association and dissociation data, AnalyzeBindingKineticsOptions returns the calculated optionns:"},
      AnalyzeBindingKineticsOptions[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsOptions tests 1"<>$SessionUUID][KineticsAssociation],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsOptions tests 1"<>$SessionUUID][KineticsDissociation],
        AnalyteDilutions -> {100, 50, 25, 12.5, 6.25}*10^-9*Molar
      ],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ]
  },

  SymbolSetUp :> analyzeBindingKineticsSetUp["AnalyzeBindingKineticsOptions"]
];


(* ::Subsubsection:: *)
(*AnalyzeBindingKineticsPreview*)


DefineTests[AnalyzeBindingKineticsPreview,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry] with kinetics Data, AnalyzeBindingKinetics returns the calculated options:"},
      AnalyzeBindingKineticsPreview[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingKineticsPreview tests with dissociation"<>$SessionUUID]],
      {_TabView..},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with association and dissociation data, AnalyzeBindingKineticsPreview returns the calculated options:"},
      AnalyzeBindingKineticsPreview[Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsPreview tests 3"<>$SessionUUID]],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Additional, "Given raw association and dissociation data, AnalyzeBindingKineticsPreview returns the calculated options:"},
      AnalyzeBindingKineticsPreview[
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsPreview tests 1"<>$SessionUUID][KineticsAssociation],
        Object[Data, BioLayerInterferometry, "Test data object with dissociation for AnalyzeBindingKineticsPreview tests 2"<>$SessionUUID][KineticsDissociation],
        AnalyteDilutions -> {100, 50, 25, 12.5, 6.25}*10^-9*Molar
      ],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ]
  },

  SymbolSetUp :> analyzeBindingKineticsSetUp["AnalyzeBindingKineticsPreview"]
];

(* ::Section:: *)
(*End Test Package*)
