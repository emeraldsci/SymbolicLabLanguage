(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ExperimentPAGEPreview *)

DefineTests[
  ExperimentPAGEPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentPAGE:"},
      ExperimentPAGEPreview[Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentPAGEOptions:"},
      ExperimentPAGEOptions[Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
      ValidExperimentPAGEQ[Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID]],
      True
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentPAGEPreview tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentPAGEPreview tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentPAGEPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ExperimentPAGEPreview tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID]
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

          container1,container2,

          sample1,sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentPAGEPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test Containers and Gels *)
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
            "Fake container 1 for ExperimentPAGEPreview tests" <> $SessionUUID,
            "Fake container 2 for ExperimentPAGEPreview tests" <> $SessionUUID
          }
        ];

        (* Create Oligomer Molecule ID Models for the test samples' Composition field *)
        Upload[
          {
            <|
              Type->Model[Molecule,Oligomer],
              Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
              PolymerType-> DNA,
              Name-> "Fake 40mer DNA Model Molecule for ExperimentPAGEPreview tests" <> $SessionUUID,
              MolecularWeight->12295.9*(Gram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1,sample2
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentPAGEPreview tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            },
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentPAGEPreview tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          InitialAmount-> {
            1 * Milliliter,
            1 * Milliliter
          },
          Name->{
            "Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID,
            "Fake discarded 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|
            Object -> Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID],
            Status -> Discarded
          |>
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
          Object[Container, Bench, "Fake bench for ExperimentPAGEPreview tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentPAGEPreview tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentPAGEPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ExperimentPAGEPreview tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEPreview tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  ),
  Stubs:>{
    $EmailEnabled=False,
    $AllowSystemsProtocols = True,
    $PersonID = Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ExperimentPAGEOptions *)

DefineTests[
  ExperimentPAGEOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentPAGEOptions[Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentPAGEOptions[Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID]],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentPAGEOptions[Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID],OutputFormat->List],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentPAGEOptions tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentPAGEOptions tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentPAGEOptions tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ExperimentPAGEOptions tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID]
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

          container1,container2,

          sample1,sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentPAGEOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test Containers and Gels *)
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
            "Fake container 1 for ExperimentPAGEOptions tests" <> $SessionUUID,
            "Fake container 2 for ExperimentPAGEOptions tests" <> $SessionUUID
          }
        ];

        (* Create Oligomer Molecule ID Models for the test samples' Composition field *)
        Upload[
          {
            <|
              Type->Model[Molecule,Oligomer],
              Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
              PolymerType-> DNA,
              Name-> "Fake 40mer DNA Model Molecule for ExperimentPAGEOptions tests" <> $SessionUUID,
              MolecularWeight->12295.9*(Gram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1,sample2
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentPAGEOptions tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            },
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentPAGEOptions tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          InitialAmount-> {
            1 * Milliliter,
            1 * Milliliter
          },
          Name->{
            "Fake 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID,
            "Fake discarded 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|
            Object -> Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID],
            Status -> Discarded
          |>
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
          Object[Container, Bench, "Fake bench for ExperimentPAGEOptions tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentPAGEOptions tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentPAGEOptions tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ExperimentPAGEOptions tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ExperimentPAGEOptions tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  ),
  Stubs:>{
    $EmailEnabled=False,
    $AllowSystemsProtocols = True,
    $PersonID = Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ValidExperimentPAGEQ *)

DefineTests[
  ValidExperimentPAGEQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentPAGEQ[Object[Sample,"Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentPAGEQ[Object[Sample,"Fake discarded 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentPAGEQ[Object[Sample,"Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentPAGEQ[Object[Sample,"Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID],Verbose->True],
      True
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ValidExperimentPAGEQ tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID]
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

          container1,container2,

          sample1,sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentPAGEQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test Containers and Gels *)
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
            "Fake container 1 for ValidExperimentPAGEQ tests" <> $SessionUUID,
            "Fake container 2 for ValidExperimentPAGEQ tests" <> $SessionUUID
          }
        ];

        (* Create Oligomer Molecule ID Models for the test samples' Composition field *)
        Upload[
          {
            <|
              Type->Model[Molecule,Oligomer],
              Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
              PolymerType-> DNA,
              Name-> "Fake 40mer DNA Model Molecule for ValidExperimentPAGEQ tests" <> $SessionUUID,
              MolecularWeight->12295.9*(Gram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1,sample2
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ValidExperimentPAGEQ tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            },
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ValidExperimentPAGEQ tests" <> $SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          InitialAmount-> {
            1 * Milliliter,
            1 * Milliliter
          },
          Name->{
            "Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID,
            "Fake discarded 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|
            Object -> Object[Sample,"Fake discarded 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID],
            Status -> Discarded
          |>
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
          Object[Container, Bench, "Fake bench for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ValidExperimentPAGEQ tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ValidExperimentPAGEQ tests" <> $SessionUUID],

          Object[Sample,"Fake 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 40mer DNA oligomer for ValidExperimentPAGEQ tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  ),
  Stubs:>{
    $EmailEnabled=False,
    $AllowSystemsProtocols = True,
    $PersonID = Object[User,"Test user for notebook-less test protocols"]
  }
];
