(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBindingKinetics*)


DefineTests[PlotBindingKinetics,
  {
    Example[{Messages,"BindingKineticsAnalysisMissing", "Given an unanalyzed Object[Data,BioLayerInterferometry], PlotBindingKinetics returns Null:"},
      PlotBindingKinetics[Object[Data, BioLayerInterferometry,  "Test data object for PlotBindingKinetics tests 1"]],
      Null,
      Messages:>{
        Warning::BindingKineticsAnalysisMissing
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an analyzed Object[Data,BioLayerInterferometry], PlotBindingKinetics returns an plot:"},
      PlotBindingKinetics[Object[Data, BioLayerInterferometry,  "Test data object for PlotBindingKinetics tests 2"]],
      ValidGraphicsP[],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given a Object[Analysis, BindingKinetics], PlotBindingKinetics returns an plot:"},
      PlotBindingKinetics[Object[Analysis, BindingKinetics, "Test analysis object for PlotBindingKinetics tests 1"]],
      ValidGraphicsP[],
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
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingKinetics"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBindingKinetics tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBindingKinetics tests 2"],
          Object[Sample, "Test sample for PlotBindingKinetics 1"],
          Object[Sample, "Test sample for PlotBindingKinetics 2"],
          Object[Analysis, BindingKinetics, "Test analysis object for PlotBindingKinetics tests 1"]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{standardData, testData, dataPackets, protocolObjectPacket,
      fakeUnitlessAssociationData, analyteConcentrations, fakeAssociationData,
      fakeAssociationBaselines, fakeDissociationData, fakeUnitlessDissociationData, fakeDissociationBaselines,
      fakeSample1, fakeSample2, analysisObject},

      (*TODO: make more of the models - right now it is only 1:1. This can be fit usign the other models so it should be ok for testing but can cause NDSolve to freak out*)
      (* make an expression to generate fake data with 1:1 model, Rmax = 2 nm, kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      fakeABKAssociation[t_, conc_]:= 2*(1/(1+0.0001/(20000*conc)))*(1 - Exp[-(20000*conc + 0.0001)*t]);
      fakeABKDissociation[t_,t0_,conc_]:=fakeABKAssociation[t0, conc]*Exp[-(0.0001)*(t-t0)];
      analyteConcentrations = {100, 50, 25, 12.5, 6.25}*10^-9;

      (* TODO: turn this in to the real data *)
      (* generate some fake data *)
      fakeUnitlessAssociationData = Map[
        Table[
          {t,N[(fakeABKAssociation[t, #])]},
          {t,0,2000}
        ]&,
        analyteConcentrations
      ];
      fakeUnitlessDissociationData = Map[
        Table[
          {t,N[(fakeABKDissociation[t, 2000, #])]},
          {t,2000,6000}
        ]&,
        analyteConcentrations
      ];

      (* make Quantity arrays for the data and some baselines *)
      fakeAssociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessAssociationData;
      fakeAssociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,0, 2000}], {Second, Nanometer}], 5];
      fakeDissociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessDissociationData;
      fakeDissociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,2000, 6000}], {Second, Nanometer}], 5];


      (* make a basic fake sample to reference *)
      {fakeSample1, fakeSample2} = Upload[
        {
          <|
            Type -> Object[Sample],
            Name -> "Test sample for PlotBindingKinetics 1"
          |>,
          <|
            Type -> Object[Sample],
            Name -> "Test sample for PlotBindingKinetics 2"
          |>
        }
      ];

      (*Make test data packets.*)
      dataPackets = {
        Association[
          Type -> Object[Data, BioLayerInterferometry],
          Name -> "Test data object for PlotBindingKinetics tests 1",
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
          Name -> "Test data object for PlotBindingKinetics tests 2",
          Replace[SamplesIn] -> {Link[fakeSample2, Data]},
          DataType -> Kinetics,
          Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
          Replace[KineticsAssociation] -> fakeAssociationData,
          Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
          Replace[KineticsDissociation] -> fakeDissociationData,
          Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines
        ]
      };

      Upload[dataPackets];

      (*Make a test protocol object*)
      protocolObjectPacket = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol object for PlotBindingKinetics",
          (*add the data*)
          Replace[Data] -> {
            Link[Object[Data, BioLayerInterferometry, "Test data object for PlotBindingKinetics tests 2"], Protocol],
            Link[Object[Data, BioLayerInterferometry, "Test data object for PlotBindingKinetics tests 2"], Protocol]
          }
        ]
      };

      Upload[protocolObjectPacket];

      (* do the analysis to build a analysis object on the second data object *)
      analysisObject = AnalyzeBindingKinetics[Object[Data, BioLayerInterferometry, "Test data object for PlotBindingKinetics tests 2"]];
      Upload[<|Object -> analysisObject, Name -> "Test analysis object for PlotBindingKinetics tests 1"|>]
    ]

  },

  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBindingKinetics"],
        Object[Data, BioLayerInterferometry, "Test data object with for PlotBindingKinetics tests 1"],
        Object[Data, BioLayerInterferometry, "Test data object with for PlotBindingKinetics tests 2"],
        Object[Sample, "Test sample for PlotBindingKinetics 1"],
        Object[Sample, "Test sample for PlotBindingKinetics 2"],
        Object[Analysis, BindingKinetics, "Test analysis object for PlotBindingKinetics tests 1"]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];
