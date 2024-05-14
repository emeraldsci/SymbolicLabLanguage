(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotBioLayerInterferometry*)

DefineTests[PlotBioLayerInterferometry,
  {
    Example[{Basic, "Given an unanalyzed Object[Data,BioLayerInterferometry] with kinetics data, PlotBioLayerInterferometry returns an plot:"},
      PlotBioLayerInterferometry[Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 1"]],
      {ValidGraphicsP[]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Channels, "Given a Object[Data,BioLayerInterferometry] with any data, PlotBioLayerInterferometry returns an plot showing the binding for the specified channels:"},
      PlotBioLayerInterferometry[
        Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 1"],
        Channels -> {1,2,3,8}
      ],
      ValidGraphicsP[],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Channels, "Given a Object[Data,BioLayerInterferometry] with any data, PlotBioLayerInterferometry returns an plot showing the binding for all channels:"},
      PlotBioLayerInterferometry[
        Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 1"],
        Channels -> All
      ],
      ValidGraphicsP[]
    ],
    Example[{Options, Channels, "Given a Object[Data,BioLayerInterferometry] with any data, PlotBioLayerInterferometry returns an plot showing the binding for all channels:"},
      options = PlotBioLayerInterferometry[
        Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 1"],
        Channels -> All,
        Output ->Options
      ];
      Lookup[options, Channels],
      All,
      Variables :>{options}
    ],
    Example[{Basic, "Given an analyzed Object[Data,BioLayerInterferometry] with kinetics data, PlotBioLayerInterferometry returns an plot:"},
      PlotBioLayerInterferometry[
        Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 2"]],
      {ValidGraphicsP[]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry] with associated kinetics data, PlotBioLayerInterferometry returns plot for all associated data objects:"},
      PlotBioLayerInterferometry[Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry"]],
      {ValidGraphicsP[], ValidGraphicsP[]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (*messages*)
    Example[{Messages, "BLIPlotTooManyRequestedChannels", "When the Channels option is used, the input must be a single data object:"},
      PlotBioLayerInterferometry[
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry"],
        Channels -> {1,3,4}
      ],
      $Failed,
      Messages:>{Error::BLIPlotTooManyRequestedChannels}
    ],
    Example[{Messages, "NoBLIDataToPlot", "The protocol input must contain data objects:"},
      PlotBioLayerInterferometry[
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry with no data"]
      ],
      $Failed,
      Messages:>{Error::NoBLIDataToPlot}
    ],
    Example[{Messages, "MixedBLIPlotDataTypes", "When multiple data objects are provided as input, they must have been generated from the same type of assay:"},
      PlotBioLayerInterferometry[
        {
          Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry without data"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 2"]
        }
      ],
      $Failed,
      Messages:>{Error::MixedBLIPlotDataTypes}
    ]
  },

  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry"],
          Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry with no data"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 1"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry tests 2"],
          Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry without data"],
          Object[Sample, "Test sample for PlotBioLayerInterferometry 1"],
          Object[Sample, "Test sample for PlotBioLayerInterferometry 2"]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{standardData, testData, dataPackets, protocolObjectPacket,
      fakeUnitlessAssociationData, analyteConcentrations, fakeAssociationData,
      fakeAssociationBaselines, fakeDissociationData, fakeUnitlessDissociationData, fakeDissociationBaselines,
      fakeSample1, fakeSample2, dataObjects, fakeWellData, fakeWellInformation},

      (*TODO: make more of the models - right now it is only 1:1. This can be fit usign the other models so it should be ok for testing but can cause NDSolve to freak out*)
      (* make an expression to generate fake data with 1:1 model, Rmax = 2 nm, kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      fakeABKAssociation[t_, conc_]:= 2*(1/(1+0.0001/(20000*conc)))*(1 - Exp[-(20000*conc + 0.0001)*t]);
      fakeABKDissociation[t_,t0_,conc_]:=fakeABKAssociation[t0, conc]*Exp[-(0.0001)*(t-t0)];
      analyteConcentrations = {100, 50, 25, 12.5, 6.25}*10^-9;

      (* TODO: turn this in to the real data *)
      (* generate some fake data *)
      fakeUnitlessAssociationData = Map[
        Table[
          {t,N[(fakeABKAssociation[t, #]+RandomReal[{-0.01,0.01}])]},
          {t,0,2000}
        ]&,
        analyteConcentrations
      ];
      fakeUnitlessDissociationData = Map[
        Table[
          {t,N[(fakeABKDissociation[t, 2000, #]+RandomReal[{-0.01,0.01}])]},
          {t,2000,6000}
        ]&,
        analyteConcentrations
      ];

      (* make Quantity arrays for the data and some baselines *)
      fakeAssociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessAssociationData;
      fakeAssociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,0, 2000}], {Second, Nanometer}], 5];
      fakeDissociationData = QuantityArray[#, {Second, Nanometer}]&/@fakeUnitlessDissociationData;
      fakeDissociationBaselines = ConstantArray[QuantityArray[Table[{t, 0}, {t,2000, 6000}], {Second, Nanometer}], 5];

      (* generate well info fo channels plotting *)
      fakeWellInformation = Flatten[Table[
        {
          1,
          step,
          1,
          channel,
          If[MatchQ[step, 1], MeasureAssociation, MeasureDissociation],
          Link[Model[Sample, "Milli-Q water"]]
        },
        {step, 1, 2},
        {channel, 1, 8}
      ],
        1
      ];

      (* generate well data also for channels plotting *)
      fakeWellData = Join[
        fakeAssociationData,
        ConstantArray[fakeAssociationBaselines[[1]], 3],
        fakeDissociationData,
        ConstantArray[fakeDissociationBaselines[[1]], 3]
      ];

      (* make a basic fake sample to reference *)
      {fakeSample1, fakeSample2} = Upload[
        {
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Test sample for PlotBioLayerInterferometry 1"
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Test sample for PlotBioLayerInterferometry 2"
          |>
        }
      ];

      (*Make test data packets.*)
      dataPackets = {
        Association[
          Type -> Object[Data, BioLayerInterferometry],
          Name -> "Test data object for PlotBioLayerInterferometry tests 1",
          Replace[SamplesIn] -> {Link[fakeSample1, Data]},
          DataType -> Kinetics,
          Replace[KineticsDilutionConcentrations] -> analyteConcentrations*(10^9)*Nanomolar,
          Replace[KineticsAssociation] -> fakeAssociationData,
          Replace[KineticsAssociationBaselines] -> fakeAssociationBaselines,
          Replace[KineticsDissociation] -> fakeDissociationData,
          Replace[KineticsDissociationBaselines] -> fakeDissociationBaselines,

          (* mock up for a simple 2 step assay with association/dissocaition. there are 5 dilutions and one sample *)
          Replace[WellInformation] -> fakeWellInformation,
          Replace[WellData]-> fakeWellData
        ],
        Association[
          Type -> Object[Data, BioLayerInterferometry],
          Name -> "Test data object for PlotBioLayerInterferometry tests 2",
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
          Name -> "Test data object for PlotBioLayerInterferometry without data",
          DataType -> Quantitation
        ]
      };

      dataObjects = Upload[dataPackets];

      (*Make a test protocol object*)
      protocolObjectPacket = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol object for PlotBioLayerInterferometry",
          (*add the data*)
          Replace[Data] -> {
            Link[dataObjects[[1]], Protocol],
            Link[dataObjects[[2]], Protocol]
          }
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol object for PlotBioLayerInterferometry with no data"
        ]
      };

      Upload[protocolObjectPacket];
    ];

  },

  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry"],
        Object[Protocol, BioLayerInterferometry, "Test protocol object for PlotBioLayerInterferometry with no data"],
        Object[Data, BioLayerInterferometry, "Test data object with for PlotBioLayerInterferometry tests 1"],
        Object[Data, BioLayerInterferometry, "Test data object with for PlotBioLayerInterferometry tests 2"],
        Object[Data, BioLayerInterferometry, "Test data object for PlotBioLayerInterferometry without data"],
        Object[Sample, "Test sample for PlotBioLayerInterferometry 1"],
        Object[Sample, "Test sample for PlotBioLayerInterferometry 2"]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];

