(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*ExperimentOvenDryPreview*)

DefineTests[ExperimentOvenDryPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentOvenDry:"},
      ExperimentOvenDryPreview[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID]
      ],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentOvenDryOptions:"},
      ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID]
      ],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentOvenDryQ:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID]
      ],
      True
    ]
  },
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> (
    (* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDryPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench, container1
        },

        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentOvenDryPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1
        }=UploadSample[
          {
            Model[Container, Vessel, "id:J8AY5jwzPPR7"] (* "250mL Glass Bottle" *)
          },
          {
            {"Work Surface", testBench}
          },
          Status -> Available,
          Name->{
            "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID
          }
        ];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDryPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryPreview Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];

(* ::Subsection::Closed:: *)
(*ValidExperimentOvenDryQ*)


DefineTests[ValidExperimentOvenDryQ,
  {
    (* ===Basic===*)
    Example[{Basic, "Create a protocol object to dry glassware in an oven and then cool in a desiccator:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID]
      ],
      True
    ],
    Example[{Basic, "Create a protocol object to dry a sample in an oven and then cool in a desiccator:"},
      ValidExperimentOvenDryQ[
        Object[Sample, "Sample 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID]
      ],
      True
    ],
    Example[{Options, Oven, "Select an oven to use in an OvenDry protocol:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        Oven -> Object[Instrument, Oven, "Oven for ValidExperimentOvenDryQ Tests" <> $SessionUUID]
      ],
      True
    ],
    Example[{Options, OvenTemperature, "Specify the temperature to which the oven should be set in an OvenDry protocol:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        OvenTemperature -> 150*Celsius
      ],
      True
    ],
    Example[{Options, OvenTime, "Specify the time for which the sample should be kept in the oven in an OvenDry protocol:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        OvenTime -> 45*Minute
      ],
      True
    ],
    Example[{Options, Desiccator, "Select a desiccator to use in an OvenDry protocol:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        Desiccator -> Object[Instrument, Desiccator, "Desiccator for ValidExperimentOvenDryQ Tests" <> $SessionUUID]
      ],
      True
    ],
    Example[{Options, DesiccatorTime, "Specify the time for which the sample should be kept in the desiccator in an OvenDry protocol:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        DesiccatorTime -> 45*Minute
      ],
      True
    ],
    (* ===Messages=== *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ValidExperimentOvenDryQ[Object[Sample, "Nonexistent sample"]],
      False,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ValidExperimentOvenDryQ[Object[Container, Vessel, "Nonexistent container"]],
      False,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ValidExperimentOvenDryQ[Object[Sample, "id:12345678"]],
      False,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ValidExperimentOvenDryQ[Object[Container, Vessel, "id:12345678"]],
      False,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "OvenTemperatureTooHighForContainer", "Throw a message if OvenTemperature exceeds the container's MaxTemperature:"},
      ValidExperimentOvenDryQ[Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        OvenTemperature -> 200*Celsius
      ],
      False
    ],
    Example[{Messages, "OvenTemperatureTooHighForSample", "Throw a message if OvenTemperature exceeds 110 Celsius for a sample.:"},
      ValidExperimentOvenDryQ[Object[Sample, "Sample 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        OvenTemperature -> 140*Celsius
      ],
      False
    ],
    Example[{Options, OutputFormat, "OutputFormat option indicates if the output should be a Boolean or a test summary:"},
      ValidExperimentOvenDryQ[
        Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary
    ]
  },
  SymbolSetUp :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentOvenDryQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ValidExperimentOvenDryQ Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ValidExperimentOvenDryQ Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ];

    Module[
      {
        testBench, testOven, testDesiccator, testContainer1, testContainer2, testContainer3, testSample, testContainerModel
      },

      {testBench, testOven, testDesiccator, testContainerModel} = Upload[{
        <|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for ValidExperimentOvenDryQ tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site->Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Object[Instrument, Oven],
          Model -> Link[Model[Instrument, Oven, "id:6V0npvmZnLWV"], Objects], (*"Thermo Fisher Large Oven"*)
          Name -> "Oven for ValidExperimentOvenDryQ Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Status -> Available,
          ImageFile -> Link[Object[EmeraldCloudFile, "id:3em6ZvrNkaXM"]],
          DatePurchased -> Now - 1 Year,
          DateInstalled -> Now - 1 Year + 1 Day,
          Replace[SerialNumbers] -> {},
          Replace[LocationLog] -> {{Now, In, Link[Object[Container, Room, "ECL-2 Lab"], ContentsLog, 3], "E2-Oven Slot", Link[$PersonID]}},
          Cost -> 10000 USD
        |>,
        <|
          Type -> Object[Instrument, Desiccator],
          Model -> Link[Model[Instrument, Desiccator, "id:aXRlGn6Vj640"], Objects], (*"5.8L Glass Non-Vacuum Desiccator"*) (* TODO: may replace with better desiccator *)
          Name -> "Desiccator for ValidExperimentOvenDryQ Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Model[Container, Vessel],
          Name -> "Test container model with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID,
          DeveloperObject -> True,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          MaxTemperature -> 150 Celsius
        |>
      }];

      {testContainer1, testContainer2, testContainer3} = UploadSample[
        {
          Model[Container, Vessel, "id:J8AY5jwzPPR7"], (* "250mL Glass Bottle" *)
          testContainerModel,
          Model[Container, Vessel, "id:J8AY5jwzPPR7"] (* "250mL Glass Bottle" *)
        },
        {
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench}
        },
        Name -> {
          "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID,
          "Vessel 2 with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID,
          Null
        }
      ];

      testSample = UploadSample[
        Model[Sample, "id:8qZ1VWNmdLBD"], (* "Milli-Q water" *)
        {"A1", testContainer3},
        Name -> "Sample 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID
      ];

      Upload[Flatten@{
        <|
          Object -> #,
          DeveloperObject -> True
        |>&/@{testContainer1, testContainer2, testContainer3, testSample}
      }]
    ];
  ),
  SymbolTearDown :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentOvenDryQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ValidExperimentOvenDryQ Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ValidExperimentOvenDryQ Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ValidExperimentOvenDryQ Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ]
  )
];

(* ::Subsection::Closed:: *)
(*ExperimentOvenDryOptions*)


DefineTests[ExperimentOvenDryOptions,
  {
    (* ===Basic===*)
    Example[{Basic, "Create a protocol object to dry glassware in an oven and then cool in a desiccator:"},
      ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Basic, "Create a protocol object to dry a sample in an oven and then cool in a desiccator:"},
      ExperimentOvenDryOptions[
        Object[Sample, "Sample 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, Oven, "Select an oven to use in an OvenDry protocol:"},
      options = ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        Oven -> Object[Instrument, Oven, "Oven for ExperimentOvenDryOptions Tests" <> $SessionUUID],
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, OvenTemperature, "Specify the temperature to which the oven should be set in an OvenDry protocol:"},
      options = ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OvenTemperature -> 150*Celsius,
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, OvenTime, "Specify the time for which the sample should be kept in the oven in an OvenDry protocol:"},
      options = ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OvenTime -> 45*Minute,
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, Desiccator, "Select a desiccator to use in an OvenDry protocol:"},
      options = ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        Desiccator -> Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDryOptions Tests" <> $SessionUUID],
        OutputFormat -> List
      ],
      {__Rule}
    ],
    Example[{Options, DesiccatorTime, "Specify the time for which the sample should be kept in the desiccator in an OvenDry protocol:"},
      options = ExperimentOvenDryOptions[
        Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        DesiccatorTime -> 45*Minute,
        OutputFormat -> List
      ],
      {__Rule}
    ],
    (* ===Messages=== *)
    Example[{Messages, "OvenTemperatureTooHighForContainer", "Throw a message if OvenTemperature exceeds the container's MaxTemperature:"},
      ExperimentOvenDryOptions[Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OvenTemperature -> 200*Celsius,
        OutputFormat -> List
      ],
      {__Rule},
      Messages :> {Error::OvenTemperatureTooHighForContainer, Error::InvalidOption}
    ],
    Example[{Messages, "OvenTemperatureTooHighForSample", "Throw a message if OvenTemperature exceeds 110 Celsius for a sample.:"},
      ExperimentOvenDryOptions[Object[Sample, "Sample 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
        OvenTemperature -> 140*Celsius,
        OutputFormat -> List
      ],
      {__Rule},
      Messages :> {Error::OvenTemperatureTooHighForSample, Error::InvalidOption}
    ]
  },
  SymbolSetUp :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDryOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ExperimentOvenDryOptions Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDryOptions Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ];

    Module[
      {
        testBench, testOven, testDesiccator, testContainer1, testContainer2, testContainer3, testSample, testContainerModel
      },

      {testBench, testOven, testDesiccator, testContainerModel} = Upload[{
        <|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for ExperimentOvenDryOptions tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site->Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Object[Instrument, Oven],
          Model -> Link[Model[Instrument, Oven, "id:6V0npvmZnLWV"], Objects], (*"Thermo Fisher Large Oven"*)
          Name -> "Oven for ExperimentOvenDryOptions Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Object[Instrument, Desiccator],
          Model -> Link[Model[Instrument, Desiccator, "id:aXRlGn6Vj640"], Objects], (*"5.8L Glass Non-Vacuum Desiccator"*) (* TODO: may replace with better desiccator *)
          Name -> "Desiccator for ExperimentOvenDryOptions Tests" <> $SessionUUID,
          DeveloperObject -> True,
          Site -> Link[$Site],
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
        |>,
        <|
          Type -> Model[Container, Vessel],
          Name -> "Test container model with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID,
          DeveloperObject -> True,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          MaxTemperature -> 150 Celsius
        |>
      }];

      {testContainer1, testContainer2, testContainer3} = UploadSample[
        {
          Model[Container, Vessel, "id:J8AY5jwzPPR7"], (* "250mL Glass Bottle" *)
          testContainerModel,
          Model[Container, Vessel, "id:J8AY5jwzPPR7"] (* "250mL Glass Bottle" *)
        },
        {
          {"Work Surface", testBench},
          {"Work Surface", testBench},
          {"Work Surface", testBench}
        },
        Name -> {
          "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID,
          "Vessel 2 with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID,
          Null
        }
      ];

      testSample = UploadSample[
        Model[Sample, "id:8qZ1VWNmdLBD"], (* "Milli-Q water" *)
        {"A1", testContainer3},
        Name -> "Sample 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID
      ];

      Upload[Flatten@{
        <|
          Object -> #,
          DeveloperObject -> True
        |>&/@{testContainer1, testContainer2, testContainer3, testSample}
      }]
    ];
  ),
  SymbolTearDown :> (
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentOvenDryOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Object[Sample, "Sample 1 for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Object[Instrument, Oven, "Oven for ExperimentOvenDryOptions Tests" <> $SessionUUID],
          Object[Instrument, Desiccator, "Desiccator for ExperimentOvenDryOptions Tests" <> $SessionUUID],
          Object[Container, Vessel, "Vessel 2 with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID],
          Model[Container, Vessel, "Test container model with MaxTemperature 150C for ExperimentOvenDryOptions Tests"  <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ]
  )
];