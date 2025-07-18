(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingQuantitation*)


DefineTests[PlotBindingQuantitation,
  {
    Example[{Basic, "Given an analyzed Object[Data,BioLayerInterferometry], PlotBindingQuantitation returns an plot:"},
      PlotBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID]],
      ValidGraphicsP[],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Analysis,BindingQuantitation], PlotBindingQuantitation returns an plot:"},
      PlotBindingQuantitation[Object[Analysis, BindingQuantitation, "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID]],
      ValidGraphicsP[],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Options, Color, "Set the color of the overlay data:"},
      options = PlotBindingQuantitation[
        Object[Analysis, BindingQuantitation, "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID],
        Color->Red,
        Output -> Options
      ];
      Lookup[options, Color],
      Red,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      Variables:>{options}
    ],
    Example[{Options, PointSize, "Set the point size for the overlay marker:"},
      options = PlotBindingQuantitation[
        Object[Analysis, BindingQuantitation, "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID],
        PointSize->0.01,
        Output -> Options
      ];
      Lookup[options, PointSize],
      0.01,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      Variables:>{options}
    ],

    Example[{Messages, "BindingQuantitationAnalysisMissing", "Given an unanalyzed Object[Data,BioLayerInterferometry], PlotBindingQuantitation returns a plot of hte unanalyzed data:"},
      PlotBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 2 "<>$SessionUUID]],
      $Failed,
      Messages:>{
        Warning::BindingQuantitationAnalysisMissing
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

  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests with standard "<>$SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests with no data "<>$SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests without standard "<>$SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 2 "<>$SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 1 "<>$SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 2 "<>$SessionUUID],
          Object[Sample, "Test sample for PlotBindingQuantitation 1 "<>$SessionUUID],
          Object[Sample, "Test sample for PlotBindingQuantitation 2 "<>$SessionUUID],
          Object[Analysis, BindingQuantitation, "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{standardData, testData, dataPackets, protocolObjectPacket,
      fakeUnitlessStandardData, standardConcentrations, fakeStandardData,
      fakeStandardBaselines, fakeUnitlessSampleData, fakeSampleData, fakeSampleBaselines,
      fakeSample1, fakeSample2, analysisObject},

      (* make an expression to generate fake data with 1:1 model, Rmax = 2 nm, kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      fakeABQResponse[t_, conc_]:= 2*(1/(1+0.0001/(20000*conc)))*(1 - Exp[-(20000*conc + 0.0001)*t]);
      standardConcentrations = {100, 50, 25, 12.5, 6.25}*10^-9;

      (* generate some fake data *)
      fakeUnitlessStandardData = Map[
        Table[
          {t,N[(fakeABQResponse[t, #]+RandomReal[{-0.01,0.01}])]},
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
          {t,N[(fakeABQResponse[t, #]+RandomReal[{-0.01,0.01}])]},
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
            Name -> "Test sample for PlotBindingQuantitation 1 "<>$SessionUUID
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Test sample for PlotBindingQuantitation 2 "<>$SessionUUID
          |>
        }
      ];

      (*Make test data packets.*)
      dataPackets = {
        Association[
          Type -> Object[Data, BioLayerInterferometry],
          Name -> "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID,
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
          Name -> "Test data object with standard curve for PlotBindingQuantitation tests 2 "<>$SessionUUID,
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
          Name -> "Test data object for PlotBindingQuantitation tests (no standard curve) 1 "<>$SessionUUID,
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
          Name -> "Test data object for PlotBindingQuantitation tests (no standard curve) 2 "<>$SessionUUID,
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
          Name ->  "Test protocol object for PlotBindingQuantitation tests with standard "<>$SessionUUID,
          (*add the data*)
          Replace[Data] -> {
            Link[Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID], Protocol],
            Link[Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 2 "<>$SessionUUID], Protocol]
          }
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol object for PlotBindingQuantitation tests without standard "<>$SessionUUID,
          (*add the data*)
          Replace[Data] -> {
            Link[Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 1 "<>$SessionUUID], Protocol],
            Link[Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 2 "<>$SessionUUID], Protocol]
          }
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->"Test protocol object for PlotBindingQuantitation tests with no data "<>$SessionUUID
        ]
      };

      Upload[protocolObjectPacket];

      (* do the analysis *)
      analysisObject = AnalyzeBindingQuantitation[Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID], StandardCurveFit -> Polynomial];
      Upload[<|Object -> First[analysisObject], Name -> "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID|>]
    ];

  },

  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests with standard "<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests with no data "<>$SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingQuantitation tests without standard "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 1 "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object with standard curve for PlotBindingQuantitation tests 2 "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 1 "<>$SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data object for PlotBindingQuantitation tests (no standard curve) 2 "<>$SessionUUID],
        Object[Sample, "Test sample for PlotBindingQuantitation 1 "<>$SessionUUID],
        Object[Sample, "Test sample for PlotBindingQuantitation 2 "<>$SessionUUID],
        Object[Analysis, BindingQuantitation, "Test analysis object for PlotBindingQuantitation 1 "<>$SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];
