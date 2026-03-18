(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentOvenDry: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentOvenDry*)


DefineTests[ExperimentOvenDry,
  {
    (* ===Basic===*)
    Example[{Basic, "Create a protocol object to dry glassware in an oven and then cool in a desiccator:"},
      ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, OvenDry]]
    ],
    Example[{Basic, "Create a protocol object to dry a sample in an oven and then cool in a desiccator:"},
      ExperimentOvenDry[
        Object[Sample, "Sample 1 for ExperimentOvenDry Tests"  <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, OvenDry]]
    ],
    Example[{Options, Oven, "Select an oven to use in an OvenDry protocol:"},
      options = ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        Oven -> Object[Instrument, Oven, "Oven for ExperimentOvenDry Tests" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Oven],
      ObjectP[Object[Instrument, Oven, "Oven for ExperimentOvenDry Tests" <> $SessionUUID]]
    ],
    Example[{Options, OvenTemperature, "Specify the temperature to which the oven should be set in an OvenDry protocol:"},
      options = ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        OvenTemperature -> 150*Celsius,
        Output -> Options
      ];
      Lookup[options, OvenTemperature],
      150*Celsius
    ],
    Example[{Options, OvenTime, "Specify the time for which the sample should be kept in the oven in an OvenDry protocol:"},
      options = ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        OvenTime -> 45*Minute,
        Output -> Options
      ];
      Lookup[options, OvenTime],
      45*Minute
    ],
    Example[{Options, Desiccator, "Select a desiccator to use in an OvenDry protocol:"},
      options = ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        Desiccator -> Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDry Tests" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Desiccator],
      ObjectP[Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDry Tests" <> $SessionUUID]]
    ],
    Example[{Options, DesiccatorTime, "Specify the time for which the sample should be kept in the desiccator in an OvenDry protocol:"},
      options = ExperimentOvenDry[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        DesiccatorTime -> 45*Minute,
        Output -> Options
      ];
      Lookup[options, DesiccatorTime],
      45*Minute
    ],
    (* ===Messages=== *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentOvenDry[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentOvenDry[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentOvenDry[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentOvenDry[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "OvenTemperatureTooHighForContainer", "Throw a message if OvenTemperature exceeds the container's MaxTemperature:"},
      ExperimentOvenDry[Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID],
        OvenTemperature -> 200*Celsius
      ],
      $Failed,
      Messages :> {Error::OvenTemperatureTooHighForContainer, Error::InvalidOption}
    ],
    Example[{Messages, "OvenTemperatureTooHighForSample", "Throw a message if OvenTemperature exceeds 110 Celsius for a sample:"},
      ExperimentOvenDry[Object[Sample, "Sample 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
        OvenTemperature -> 140*Celsius
      ],
      $Failed,
      Messages :> {Error::OvenTemperatureTooHighForSample, Error::InvalidOption}
    ],
    Example[{Messages, "OvenDryIncompatibleMaterials", "Throw a message if the container is made out of incompatible materials:"},
      ExperimentOvenDry[Object[Container, Vessel, "Vessel 3 (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID]
      ],
      $Failed,
      Messages :> {Error::OvenDryIncompatibleMaterials, Error::InvalidInput}
    ],
    Example[{Messages, "OvenDryContainerIncompatibleMaterials", "Throw a message if the sample is in a container made out of incompatible materials:"},
      ExperimentOvenDry[Object[Sample, "Sample 2 for ExperimentOvenDry Tests"  <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, OvenDry]],
      Messages :> {Warning::OvenDryContainerIncompatibleMaterials}
    ],
    Example[{Messages, "OvenDryContainerIncompatibleCoverFootprint", "Throw a message if the sample is in a container with an incompatible container footprint:"},
      ExperimentOvenDry[Object[Sample, "Sample 3 for ExperimentOvenDry Tests"  <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, OvenDry]],
      Messages :> {Warning::OvenDryContainerIncompatibleCoverFootprint}
    ]
  },
  SymbolSetUp :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDry tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 2 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 3 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ExperimentOvenDry Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDry Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Container, Vessel, "Vessel 3 (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model (plastic) for ExperimentOvenDry Tests" <> $SessionUUID],
          Model[Container, Vessel, "Test container model (not GL45) for ExperimentOvenDry Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ];

    Module[
      {
        testBench, testOven, testDesiccator, testContainer1, testContainer2, testContainer3, testContainer4, testContainer5,
        testContainer6, testSample1, testSample2, testSample3, testContainerModel1, testContainerModel2, testContainerModel3
      },

      {testBench, testOven, testDesiccator, testContainerModel1, testContainerModel2, testContainerModel3} = Upload[{
        <|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for ExperimentOvenDry tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site->Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Object[Instrument, Oven],
          Model -> Link[Model[Instrument, Oven, "id:6V0npvmZnLWV"], Objects], (*"Thermo Fisher Large Oven"*)
          Name -> "Oven for ExperimentOvenDry Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Object[Instrument, Desiccator],
          Model -> Link[Model[Instrument, Desiccator, "id:aXRlGn6Vj640"], Objects], (*"5.8L Glass Non-Vacuum Desiccator"*) (* TODO: may replace with better desiccator *)
          Name -> "Desiccator for ExperimentOvenDry Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Model[Container, Vessel],
          Name -> "Test container model with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID,
          DeveloperObject -> True,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.06985 Meter, MaxDepth -> 0.06985 Meter, MaxHeight -> Null|>},
          Replace[PositionPlotting] -> {<|Name -> "A1", XOffset -> 0.034925 Meter, YOffset -> 0.034925 Meter, ZOffset -> 0 Meter, CrossSectionalShape -> Circle, Rotation -> 0|>},
          MaxTemperature -> 150 Celsius,
          Replace[ContainerMaterials] -> {Glass},
          Replace[CoverFootprints] -> {CapGL45}
        |>,
        <|
          Type -> Model[Container, Vessel],
          Name -> "Test container model (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID,
          DeveloperObject -> True,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.06985 Meter, MaxDepth -> 0.06985 Meter, MaxHeight -> Null|>},
          Replace[PositionPlotting] -> {<|Name -> "A1", XOffset -> 0.034925 Meter, YOffset -> 0.034925 Meter, ZOffset -> 0 Meter, CrossSectionalShape -> Circle, Rotation -> 0|>},
          MaxTemperature -> 500 Celsius,
          Replace[ContainerMaterials] -> {Polypropylene},
          Replace[CoverFootprints] -> {CapGL45}
        |>,
        <|
          Type -> Model[Container, Vessel],
          Name -> "Test container model (not GL45) for ExperimentOvenDry Tests"  <> $SessionUUID,
          DeveloperObject -> True,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.06985 Meter, MaxDepth -> 0.06985 Meter, MaxHeight -> Null|>},
          Replace[PositionPlotting] -> {<|Name -> "A1", XOffset -> 0.034925 Meter, YOffset -> 0.034925 Meter, ZOffset -> 0 Meter, CrossSectionalShape -> Circle, Rotation -> 0|>},
          MaxTemperature -> 500 Celsius,
          Replace[ContainerMaterials] -> {Glass},
          Replace[CoverFootprints] -> {LidAluminumFoil}
        |>
      }];

      {testContainer1, testContainer2, testContainer3, testContainer4, testContainer5, testContainer6} = UploadSample[
        {
          Model[Container, Vessel, "id:J8AY5jwzPPR7"], (* "250mL Glass Bottle" *)
          testContainerModel1,
          testContainerModel2,
          Model[Container, Vessel, "id:J8AY5jwzPPR7"], (* "250mL Glass Bottle" *)
          testContainerModel2,
          testContainerModel3
        },
        {
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench}
        },
        Name -> {
          "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID,
          "Vessel 2 with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID,
          "Vessel 3 (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID,
          Null,
          Null,
          Null
        }
      ];

      {testSample1, testSample2, testSample3} = UploadSample[
        {
          Model[Sample, "id:8qZ1VWNmdLBD"], (* "Milli-Q water" *)
          Model[Sample, "id:8qZ1VWNmdLBD"], (* "Milli-Q water" *)
          Model[Sample, "id:8qZ1VWNmdLBD"] (* "Milli-Q water" *)
        },
        {
          {"A1", testContainer4},
          {"A1", testContainer5},
          {"A1", testContainer6}
        },
        Name -> {
          "Sample 1 for ExperimentOvenDry Tests" <> $SessionUUID,
          "Sample 2 for ExperimentOvenDry Tests" <> $SessionUUID,
          "Sample 3 for ExperimentOvenDry Tests" <> $SessionUUID
        }
      ];

      Upload[Flatten@{
        <|
          Object -> #,
          DeveloperObject -> True
        |>&/@{
          testContainer1, testContainer2, testContainer3, testContainer4, testContainer5, testContainer6,
          testSample1, testSample2, testSample3
        }
      }]
    ];
  ),
  SymbolTearDown :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDry tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 2 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Sample, "Sample 3 for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ExperimentOvenDry Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDry Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID],
          Object[Container, Vessel, "Vessel 3 (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ExperimentOvenDry Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model (plastic) for ExperimentOvenDry Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ]
  )
]