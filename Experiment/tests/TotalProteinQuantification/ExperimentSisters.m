(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentTotalProteinQuantificationPreview*)
DefineTests[
  ExperimentTotalProteinQuantificationPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentTotalProteinQuantification:"},
      ExperimentTotalProteinQuantificationPreview[Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID]],
      Null,
      TimeConstraint -> 150
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentTotalProteinQuantificationOptions:"},
      ExperimentTotalProteinQuantificationOptions[Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID]],
      _Grid,
      TimeConstraint -> 150
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentTotalProteinQuantificationQ:"},
      ValidExperimentTotalProteinQuantificationQ[Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID]],
      True,
      TimeConstraint -> 150
    ]
  },
  Stubs:>{
    (* I am an important stub that prevents the tester from getting a bunch of notifications *)
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,
          container1,
          sample1
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Test container 1 for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID
          }
        ];

        {
          sample1
        }=UploadSample[
          {
            Model[Sample, "id:WNa4ZjKMrPeD"]
          },
          {
            {"A1", container1}
          },
          InitialAmount->{
            1*Milliliter
          },
          Name->{
            "Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,sample1}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|Object -> sample1, Status -> Available|>
        }], PacketP[]]];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationPreview tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ExperimentTotalProteinQuantificationOptions*)
DefineTests[
  ExperimentTotalProteinQuantificationOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentTotalProteinQuantificationOptions[Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID]],
      _Grid,
      TimeConstraint -> 150
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentTotalProteinQuantificationOptions[Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID]],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      },
      TimeConstraint -> 150
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentTotalProteinQuantificationOptions[Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],OutputFormat->List],
      {(_Rule|_RuleDelayed)..},
      TimeConstraint -> 150
    ]
  },
  Stubs:>{
    (* I am an important stub that prevents the tester from getting a bunch of notifications *)
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],
          Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,
          container1,
          container2,
          sample1,
          sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1,container2
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Test container 1 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID,
            "Test container 2 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID
          }
        ];

        {
          sample1,
          sample2
        }=UploadSample[
          {
            Model[Sample, "id:WNa4ZjKMrPeD"],
            Model[Sample, "id:WNa4ZjKMrPeD"]
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          InitialAmount->{
            1*Milliliter,
            1*Milliliter
          },
          Name->{
            "Test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID,
            "Test discarded test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|Object -> sample1, Status -> Available|>,
          <|Object -> sample2, Status -> Discarded|>
        }], PacketP[]]];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID],
          Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantificationOptions tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentTotalProteinQuantificationQ*)
DefineTests[
  ValidExperimentTotalProteinQuantificationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentTotalProteinQuantificationQ[Object[Sample,"Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID]],
      True,
      TimeConstraint -> 150
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentTotalProteinQuantificationQ[Object[Sample,"Test discarded test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID]],
      False,
      TimeConstraint -> 150
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentTotalProteinQuantificationQ[Object[Sample,"Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary,
      TimeConstraint -> 150
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentTotalProteinQuantificationQ[Object[Sample,"Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],Verbose->True],
      True,
      TimeConstraint -> 150
    ]
  },
  Stubs:>{
    (* I am an important stub that prevents the tester from getting a bunch of notifications *)
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],
          Object[Sample,"Test discarded test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,
          container1,
          container2,
          sample1,
          sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1,container2
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Test container 1 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID,
            "Test container 2 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID
          }
        ];

        {
          sample1,
          sample2
        }=UploadSample[
          {
            Model[Sample, "id:WNa4ZjKMrPeD"],
            Model[Sample, "id:WNa4ZjKMrPeD"]
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          InitialAmount->{
            1*Milliliter,
            1*Milliliter
          },
          Name->{
            "Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID,
            "Test discarded test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|Object -> sample1, Status -> Available|>,
          <|Object -> sample2, Status -> Discarded|>
        }], PacketP[]]];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],

          Object[Container,Vessel,"Test container 1 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],

          Object[Sample,"Test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID],
          Object[Sample,"Test discarded test lysate for ValidExperimentTotalProteinQuantificationQ tests"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];
