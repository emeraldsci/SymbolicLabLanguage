(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*BindingQuantitation: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*AnalyzeBindingQuantitation*)


DefineTests[AnalyzeBindingQuantitation,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], AnalyzeBindingQuantitation returns an Analysis Object:"},
      AnalyzeBindingQuantitation[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingQuantitation tests with standard"]],
      {ObjectP[Object[Analysis, BindingQuantitation]]..},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, AnalyzeBindingQuantitation returns an Analysis Object:"},
      AnalyzeBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"]],
      {ObjectP[Object[Analysis, BindingQuantitation]]..},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "Given an Object[Data,BioLayerInterferometry] without a standard, AnalyzeBindingQuantitation returns $Failed:"},
      AnalyzeBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 1"]],
      $Failed,
      Messages :> {Error::BindingQuantitationMissingStandardDataSets, Error::InvalidOption},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given multiple Object[Data,BioLayerInterferometry] with standards, AnalyzeBindingQuantitation returns an Analysis Object for each input:"},
      AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        }
      ],
      {ObjectP[Object[Analysis, BindingQuantitation]]..},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, calculate the concentration of the input sample:"},
      output = AnalyzeBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"]];
      output[[1]][SamplesInConcentrations],
      {_?QuantityQ..},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Additional, "AnalyzeBindingQuantitation populates the QuantitationAnalysis field with a data object containing the relevant fields:"},
      AnalyzeBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"]];
      First[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"][QuantitationAnalysis]
      ][{SamplesInConcentrations, SamplesInFitting, Rate, EquilibriumResponse, StandardDataFitAnalysis, StandardCurveFitAnalysis}],
      {
        {_?QuantityQ},
        {ObjectP[Object[Analysis, Fit]]},
        {_?QuantityQ},
        {},
        {ObjectP[Object[Analysis, Fit]]..},
        ObjectP[Object[Analysis, Fit]]
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      Messages :> {_}
    ],

    (* -------------- *)
    (* --  OPTIONS -- *)
    (* -------------- *)


    Example[{Options,FilterType, "Specify the type of filter to use to filter data for output plots:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FilterType->MeanFilter,
        Output->Options];
      Lookup[options,FilterType],
      MeanFilter,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,FilterWidth, "Specify the radius of data points to treat with the filter type:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FilterType -> MeanFilter,
        FilterWidth -> 2 Second,
        Output->Options];
      Lookup[options,FilterWidth],
      2 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,FittedParameter, "Specify the parameter that should be fit to generate the standard curve:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FittedParameter -> InitialRate,
        InitialFitDomain -> 50 Second,
        Output->Options];
      Lookup[options,FittedParameter],
      InitialRate,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Specify a constant baseline for each input data object:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        Baselines -> {0.01 Nanometer, 0.02 Nanometer},
        Output->Options];
      Lookup[options,Baselines],
      {0.01 Nanometer, 0.02 Nanometer},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Specify a single constant baseline to apply to all data objects:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        Baselines -> 0.01 Nanometer,
        Output->Options];
      Lookup[options,Baselines],
      0.01 Nanometer,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Automatically populate the baseline if the data object contains QuantitationAnalyteBaselines:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        Baselines -> Automatic,
        Output->Options
      ];
      Lookup[options,Baselines],
      {ObjectP[Object[Data, BioLayerInterferometry]], ObjectP[Object[Data, BioLayerInterferometry]]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, InitialFitDomain, "Specify the initial domain to fit for all samples and standards:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        InitialFitDomain -> 50 Second,
        FittedParameter -> InitialRate,
        Output->Options
      ];
      Lookup[options,InitialFitDomain],
      50 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FinalFitDomain, "Specify the final domain to fit for all samples and standards:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        FinalFitDomain -> 50 Second,
        FittedParameter -> AverageEquilibriumResponse,
        Output->Options
      ];
      Lookup[options,FinalFitDomain],
      50 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FinalFitDomain, "Automatically resolve the final domain based on the FittedParameter:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        FittedParameter -> AverageEquilibriumResponse,
        Output->Options
      ];
      Lookup[options, FinalFitDomain],
      40 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, InitialFitDomain, "Automatically resolve the final domain based on the FittedParameter:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        FittedParameter -> InitialRate,
        Output->Options
      ];
      Lookup[options, InitialFitDomain],
      40 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (* -- standard related options -- *)
    Example[{Options,StandardData, "Automatically populate the standard curve data if the data object contains QuantitationStandardDetection:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        StandardData -> Automatic,
        Output->Options
      ];
      Lookup[options,StandardData],
      ObjectP[Object[Data, BioLayerInterferometry]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardData, "Specify data objects with QuantitationStandardDetection which is appropriate for the sample:"},
      options=AnalyzeBindingQuantitation[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"]
        },
        StandardData -> Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Output->Options
      ];
      Lookup[options,StandardData],
      ObjectP[Object[Data, BioLayerInterferometry]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardBaselines, "Automatically resolve the baselines to fit for the standard data based on the presence of the standard data:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        StandardBaselines -> Automatic,
        Output->Options
      ];
      Lookup[options,StandardBaselines],
      {ObjectP[Object[Data, BioLayerInterferometry]]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardBaselines, "Specify the baselines for the standard data:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        StandardBaselines -> Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Output->Options
      ];
      Lookup[options,StandardBaselines],
      ObjectP[Object[Data, BioLayerInterferometry]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardConcentrations, "Specify the concentrations of the dilutions used in StandardData:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        StandardConcentrations -> {100 Nanomolar, 50 Nanomolar, 25 Nanomolar, 12.5 Nanomolar, 6.25 Nanomolar},
        Output->Options
      ];
      Lookup[options,StandardConcentrations],
      {100 Nanomolar, 50 Nanomolar, 25 Nanomolar, 12.5 Nanomolar, 6.25 Nanomolar},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardConcentrations, "Automatically resolve the concentrations of the dilutions used in StandardData when using data object input:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        StandardConcentrations -> Automatic,
        Output->Options
      ];
      Lookup[options,StandardConcentrations],
      ObjectP[Object[Data, BioLayerInterferometry]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardCurveFit, "Specify a function to generate a standard curve:"},
      options=AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        StandardCurveFit -> PolynomialOrder2,
        Output->Options
      ];
      Lookup[options,StandardCurveFit],
      PolynomialOrder2,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (*
    Example[{Options,Template, "Use options from previous AnalyzeBindingQuantitation analysis:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Template -> Object[Analysis, BindingQuantitation,"test template for AnalyzeBindingQuantitation"]
      ],
      ObjectP[Object[Analysis, BindingQuantitation]],
      SetUp:>(
        (*make an analysis object to test the template*)
        Module[{testanalyzeobject},
          testanalyzeobject=AnalyzeBindingQuantitation[
            Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"]
          ];
          Upload[<|Object -> testanalyzeobject, Name -> "test template for AnalyzeBindingQuantitation"|>]
        ];
      )
    ],
    *)


    (* -------------- *)
    (* -- MESSAGES -- *)
    (* -------------- *)

    (* bad domain *)
    Example[{Messages, InitialFitDomain, "When the InitialFitDomain is inconsistent with the Fitted Parameter, a warning is displayed:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        InitialFitDomain -> 10 Second,
        FittedParameter -> AverageEquilibriumResponse
      ],
      {ObjectP[Object[Analysis, BindingQuantitation]]},
      Messages:>{Warning::BindingQuantitationConflictingDomainAndParameter},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, FinalFitDomain, "When the InitialFitDomain is inconsistent with the Fitted Parameter, a warning is displayed:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FinalFitDomain -> 10 Second,
        FittedParameter -> InitialRate
      ],
      {ObjectP[Object[Analysis, BindingQuantitation]]},
      Messages:>{Warning::BindingQuantitationConflictingDomainAndParameter},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Domains, "When both Final and InitialFitDomain are specified, an error is shown:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FinalFitDomain -> 10 Second,
        InitialFitDomain -> 10 Second
      ],
      $Failed,
      Messages:>{
        Error::ConflictingBindingQuantitationFitDomainOptions,
        Error::InvalidOption
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Fit, "When parameters are specified such that the data cannot be fit, a message will inform the user that the fitting has failed:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        FinalFitDomain -> 10 Second
      ],
      $Failed,
      Messages:>{
        Error::BindingQuantitationFittingFailed
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    (* wrong data type *)

    (* bad baselines *)
    Example[{Messages, Baselines, "When a data baseline is provided that is too short to span the data, an error is thrown:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Baselines -> {{{0 Second, 0 Nanometer},{1 Second, 0 Nanometer}}}
      ],
      $Failed,
      Messages:>{
        Error::BindingQuantitationInvalidBaselineRange,
        Error::InvalidOption
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Baselines, "If an ambiguous number of baselines are given, an error is thrown:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Baselines -> {
          Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 2"],
          Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 2"]
        }
      ],
      $Failed,
      Messages:>{
        Error::BindingQuantitationAmbiguousBaseline,
        Error::InvalidOption
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    (* wrong number of concentrations *)
    (* unused options *)

    (* no standard data *)
    Example[{Messages, Fit, "When no standard data can be found an error is thrown:"},
      AnalyzeBindingQuantitation[
        Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 2"]
      ],
      $Failed,
      Messages:>{
        Error::BindingQuantitationMissingStandardDataSets,
        Error::InvalidOption
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]

  },
  SymbolSetUp :> analyzeBindingQuantitationSetUp["AnalyzeBindingQuantitation"],
  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingQuantitation tests with standard"],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingQuantitation tests without standard"],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 1"],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitation tests 2"],
        Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 1"],
        Object[Data, BioLayerInterferometry, "Test data object for AnalyzeBindingQuantitation tests (no standard curve) 2"],
        Object[Sample, "Test sample for AnalyzeBindingQuantitation 1"],
        Object[Sample, "Test sample for AnalyzeBindingQuantitation 2"]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];

analyzeBindingQuantitationSetUp[label_String]:=Module[{objs, existingObjs, standardData, testData, dataPackets, protocolObjectPacket,
  fakeUnitlessStandardData, standardConcentrations, fakeStandardData,
  fakeStandardBaselines, fakeUnitlessSampleData, fakeSampleData, fakeSampleBaselines,
  fakeSample1, fakeSample2},

  objs = Quiet[Cases[
    Flatten[{
      Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" tests with standard"],
      Object[Protocol, BioLayerInterferometry, "Test protocol object for "<>label<>" tests without standard"],
      Object[Data, BioLayerInterferometry, "Test data object with standard curve for "<>label<>" tests 1"],
      Object[Data, BioLayerInterferometry, "Test data object with standard curve for "<>label<>" tests 2"],
      Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no standard curve) 1"],
      Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no standard curve) 2"],
      Object[Sample, "Test sample for "<>label<>" 1"],
      Object[Sample, "Test sample for "<>label<>" 2"]
    }],
    ObjectP[]
  ]];
  existingObjs = PickList[objs, DatabaseMemberQ[objs]];
  EraseObject[existingObjs, Force -> True, Verbose -> False];

  (* make an expression to generate fake data with 1:1 model, Rmax = 2 nm, kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
  fakeABQResponse[t_, conc_]:= 2*(1/(1+0.0001/(20000*conc)))*(1 - Exp[-(20000*conc + 0.0001)*t]);
  standardConcentrations = {100, 50, 25, 12.5, 6.25}*10^-9;

  (* generate some fake data *)
  fakeUnitlessStandardData = Map[
    Table[
      {t,N[(fakeABQResponse[t, #]+RandomReal[{-0.05,0.05}])]},
      {t,0,2000}
    ]&,
    standardConcentrations
  ];

  (* make Quantity arrays for the data and some baselines *)
  fakeStandardData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessStandardData;
  fakeStandardBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,0, 2000}], {Second, Nanometer}], 5];

  (* generate fake data ofr the curve *)
  fakeUnitlessSampleData = Map[
    Table[
      {t,N[(fakeABQResponse[t, #]+RandomReal[{-0.05,0.05}])]},
      {t,0,2000}
    ]&,
    {70*10^-9, 30*10^-9}
  ];

  (*make the fake sample data Quantity Arrays and baselines*)
  fakeSampleData = QuantityArray[fakeUnitlessSampleData, {Second, Nanometer}];
  fakeSampleBaselines = QuantityArray[Table[{t,0}, {t, 0, 2000}], {Second, Nanometer}];

  (* make a basic fake sample to reference *)
  {fakeSample1, fakeSample2} = Upload[
    {
      <|
        Type -> Object[Sample],
        Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
        Name -> "Test sample for "<>label<>" 1"
      |>,
      <|
        Type -> Object[Sample],
        Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
        Name -> "Test sample for "<>label<>" 2"
      |>
    }
  ];

  (*Make test data packets.*)
  dataPackets = {
    Association[
      Type -> Object[Data, BioLayerInterferometry],
      Name -> "Test data object with standard curve for "<>label<>" tests 1",
      Replace[SamplesIn] -> {Link[fakeSample1, Data]},
      DataType -> Quantitation,
      Replace[QuantitationStandardDilutionConcentrations] -> standardConcentrations*(10^9)*Nanomolar,
      Replace[QuantitationAnalyteDetection] -> fakeSampleData[[1]],
      Replace[QuantitationStandardDetection] -> fakeStandardData,
      Replace[QuantitationAnalyteDetectionBaseline] -> fakeSampleBaselines,
      Replace[QuantitationStandardDetectionBaselines] -> fakeStandardBaselines
    ],
    Association[
      Type -> Object[Data, BioLayerInterferometry],
      Name -> "Test data object with standard curve for "<>label<>" tests 2",
      Replace[SamplesIn] -> {Link[fakeSample2, Data]},
      DataType -> Quantitation,
      Replace[QuantitationStandardDilutionConcentrations] -> standardConcentrations*(10^9)*Nanomolar,
      Replace[QuantitationAnalyteDetection] -> fakeSampleData[[2]],
      Replace[QuantitationStandardDetection] -> fakeStandardData,
      Replace[QuantitationAnalyteDetectionBaseline] -> fakeSampleBaselines,
      Replace[QuantitationStandardDetectionBaselines] -> fakeStandardBaselines
    ],
    Association[
      Type -> Object[Data, BioLayerInterferometry],
      Name -> "Test data object for "<>label<>" tests (no standard curve) 1",
      Replace[SamplesIn] -> {Link[fakeSample1, Data]},
      DataType -> Quantitation,
      Replace[QuantitationStandardDilutionConcentrations] -> standardConcentrations*(10^9)*Nanomolar,
      Replace[QuantitationAnalyteDetection] -> fakeSampleData[[1]],
      Replace[QuantitationStandardDetection] -> Null,
      Replace[QuantitationAnalyteDetectionBaseline] -> fakeSampleBaselines,
      Replace[QuantitationStandardDetectionBaselines] -> Null
    ],
    Association[
      Type -> Object[Data, BioLayerInterferometry],
      Name -> "Test data object for "<>label<>" tests (no standard curve) 2",
      Replace[SamplesIn] -> {Link[fakeSample2, Data]},
      DataType -> Quantitation,
      Replace[QuantitationStandardDilutionConcentrations] -> standardConcentrations*(10^9)*Nanomolar,
      Replace[QuantitationAnalyteDetection] -> fakeSampleData[[2]],
      Replace[QuantitationStandardDetection] -> Null,
      Replace[QuantitationAnalyteDetectionBaseline] -> fakeSampleBaselines,
      Replace[QuantitationStandardDetectionBaselines] -> Null
    ]
  };

  Upload[dataPackets];

  (*Make a test protocol object*)
  protocolObjectPacket = {
    Association[
      Type -> Object[Protocol, BioLayerInterferometry],
      Name ->  "Test protocol object for "<>label<>" tests with standard",
      (*add the data*)
      Replace[Data] -> {
        Link[Object[Data, BioLayerInterferometry, "Test data object with standard curve for "<>label<>" tests 1"], Protocol],
        Link[Object[Data, BioLayerInterferometry, "Test data object with standard curve for "<>label<>" tests 2"], Protocol]
      }
    ],
    Association[
      Type -> Object[Protocol, BioLayerInterferometry],
      Name ->  "Test protocol object for "<>label<>" tests without standard",
      (*add the data*)
      Replace[Data] -> {
        Link[Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no standard curve) 1"], Protocol],
        Link[Object[Data, BioLayerInterferometry, "Test data object for "<>label<>" tests (no standard curve) 2"], Protocol]
      }
    ]
  };

  Upload[protocolObjectPacket];
];


(* ::Subsubsection:: *)
(*ValidAnalyzeBindingQuantitationQ*)


DefineTests[ValidAnalyzeBindingQuantitationQ,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], ValidAnalyzeBindingQuantitationQ returns True:"},
      ValidAnalyzeBindingQuantitationQ[Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingQuantitationQ tests with standard"]],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, ValidAnalyzeBindingQuantitationQ return True:"},
      ValidAnalyzeBindingQuantitationQ[Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"]],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "Given an Object[Data,BioLayerInterferometry] without a standard, ValidAnalyzeBindingQuantitationQ returns False:"},
      ValidAnalyzeBindingQuantitationQ[Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 1"]],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given multiple Object[Data,BioLayerInterferometry] with standards, ValidAnalyzeBindingQuantitationQ True:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        }
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, calculate the concentration of the input sample:"},
      ValidAnalyzeBindingQuantitationQ[Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"]],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Additional, "ValidAnalyzeBindingQuantitationQ populates the QuantitationAnalysis field with a data object containing the relevant fields:"},
      ValidAnalyzeBindingQuantitationQ[Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"]],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      Messages :> {_}
    ],

    (* -------------- *)
    (* --  OPTIONS -- *)
    (* -------------- *)


    Example[{Options,FilterType, "Specify the type of filter to use to filter data for output plots:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FilterType->MeanFilter
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,FilterWidth, "Specify the radius of data points to treat with the filter type:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FilterType -> MeanFilter,
        FilterWidth -> 2 Second
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,FittedParameter, "Specify the parameter that should be fit to generate the standard curve:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FittedParameter -> InitialRate,
        InitialFitDomain -> 50 Second
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Specify a constant baseline for each input data object:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        Baselines -> {0.01 Nanometer, 0.02 Nanometer}
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Specify a single constant baseline to apply to all data objects:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        Baselines -> 0.01 Nanometer
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options,Baselines, "Automatically populate the baseline if the data object contains QuantitationAnalyteBaselines:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        Baselines -> Automatic
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, InitialFitDomain, "Specify the initial domain to fit for all samples and standards:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        InitialFitDomain -> 50 Second,
        FittedParameter -> InitialRate
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FinalFitDomain, "Specify the final domain to fit for all samples and standards:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        FinalFitDomain -> 50 Second,
        FittedParameter -> AverageEquilibriumResponse
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FinalFitDomain, "Automatically resolve the final domain based on the FittedParameter:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        FittedParameter -> AverageEquilibriumResponse
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, InitialFitDomain, "Automatically resolve the final domain based on the FittedParameter:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        FittedParameter -> InitialRate
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (* -- standard related options -- *)
    Example[{Options,StandardData, "Automatically populate the standard curve data if the data object contains QuantitationStandardDetection:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        StandardData -> Automatic
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardData, "Specify data objects with QuantitationStandardDetection which is appropriate for the sample:"},
      ValidAnalyzeBindingQuantitationQ[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"]
        },
        StandardData -> Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"]
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardBaselines, "Automatically resolve the baselines to fit for the standard data based on the presence of the standard data:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        StandardBaselines -> Automatic
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardBaselines, "Specify the baselines for the standard data:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        StandardBaselines -> Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"]
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardConcentrations, "Specify the concentrations of the dilutions used in StandardData:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        StandardConcentrations -> {100 Nanomolar, 50 Nanomolar, 25 Nanomolar, 12.5 Nanomolar, 6.25 Nanomolar}
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardConcentrations, "Automatically resolve the concentrations of the dilutions used in StandardData when using data object input:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        StandardConcentrations -> Automatic
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, StandardCurveFit, "Specify a function to generate a standard curve:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        StandardCurveFit -> PolynomialOrder2
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (* -------------- *)
    (* -- MESSAGES -- *)
    (* -------------- *)

    (* bad domain *)
    Example[{Messages, InitialFitDomain, "When the InitialFitDomain is inconsistent with the Fitted Parameter, a warning is displayed:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        InitialFitDomain -> 10 Second,
        FittedParameter -> AverageEquilibriumResponse
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, FinalFitDomain, "When the InitialFitDomain is inconsistent with the Fitted Parameter, a warning is displayed:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FinalFitDomain -> 10 Second,
        FittedParameter -> InitialRate
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Domains, "When both Final and InitialFitDomain are specified, an error is shown:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FinalFitDomain -> 10 Second,
        InitialFitDomain -> 10 Second
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Fit, "When parameters are specified such that the data cannot be fit, a message will inform the user that the fitting will fail:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        FinalFitDomain -> 10 Second
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    (* wrong data type *)

    (* bad baselines *)
    Example[{Messages, Baselines, "When a data baseline is provided that is too short to span the data, an error is thrown:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        Baselines -> {{{0 Second, 0 Nanometer},{1 Second, 0 Nanometer}}}
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Baselines, "If an ambiguous number of baselines are given, an error is thrown:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        Baselines -> {
          Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 2"],
          Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 2"]
        }
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    (* wrong number of concentrations *)
    (* unused options *)

    (* no standard data *)
    Example[{Messages, Fit, "When no standard data can be found an error is thrown:"},
      ValidAnalyzeBindingQuantitationQ[
        Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 2"]
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]

  },
  SymbolSetUp :> analyzeBindingQuantitationSetUp["ValidAnalyzeBindingQuantitationQ"],
  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingQuantitationQ tests with standard"],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for ValidAnalyzeBindingQuantitationQ tests without standard"],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 1"],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for ValidAnalyzeBindingQuantitationQ tests 2"],
        Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 1"],
        Object[Data, BioLayerInterferometry, "Test data object for ValidAnalyzeBindingQuantitationQ tests (no standard curve) 2"],
        Object[Sample, "Test sample for ValidAnalyzeBindingQuantitationQ 1"],
        Object[Sample, "Test sample for ValidAnalyzeBindingQuantitationQ 2"]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];


DefineTests[AnalyzeBindingQuantitationOptions,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], AnalyzeBindingQuantitation returns the calculated options:"},
      AnalyzeBindingQuantitationOptions[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingQuantitationOptions tests with standard"]],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, AnalyzeBindingQuantitation returns the calculated options:"},
      AnalyzeBindingQuantitationOptions[Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationOptions tests 1"]],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given multiple Object[Data,BioLayerInterferometry] with standards, AnalyzeBindingQuantitationOptions returns the calculated options:"},
      AnalyzeBindingQuantitationOptions[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationOptions tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationOptions tests 2"]
        }
      ],
      _Grid,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]
  },
  SymbolSetUp :> analyzeBindingQuantitationSetUp["AnalyzeBindingQuantitationOptions"]
];


DefineTests[AnalyzeBindingQuantitationPreview,
  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], AnalyzeBindingQuantitationPreview returns the preview:"},
      AnalyzeBindingQuantitationPreview[Object[Protocol, BioLayerInterferometry, "Test protocol object for AnalyzeBindingQuantitationPreview tests with standard"]],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Data,BioLayerInterferometry] with a standard, AnalyzeBindingQuantitationPreview returns the preview:"},
      AnalyzeBindingQuantitationPreview[Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationPreview tests 1"]],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given multiple Object[Data,BioLayerInterferometry] with standards, AnalyzeBindingQuantitationPreview returns the preview:"},
      AnalyzeBindingQuantitationPreview[
        {
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationPreview tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for AnalyzeBindingQuantitationPreview tests 2"]
        }
      ],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]
  },
  SymbolSetUp :> analyzeBindingQuantitationSetUp["AnalyzeBindingQuantitationPreview"]
];


(* ::Section:: *)
(*End Test Package*)
