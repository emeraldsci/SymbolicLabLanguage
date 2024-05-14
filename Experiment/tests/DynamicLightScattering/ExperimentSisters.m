(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*ExperimentDynamicLightScatteringPreview*)

DefineTests[ExperimentDynamicLightScatteringPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentDynamicLightScattering:"},
      ExperimentDynamicLightScatteringPreview[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentDynamicLightScatteringOptions:"},
      ExperimentDynamicLightScatteringOptions[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentDynamicLightScatteringQ:"},
      ValidExperimentDynamicLightScatteringQ[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]],
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
          Object[Container, Bench, "Fake bench for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]
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

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

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
            "Fake container 1 for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID
          }
        ];

        Upload[
          {
            <|
              Type->Model[Molecule,Protein],
              Name->"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID,
              MolecularWeight->40*(Kilogram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Create test Model[Sample]s *)
        Upload[
          {
            <|
              Type->Model[Sample],
              Name->"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1
        }=UploadSample[
          {
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]
          },
          {
            {"A1", container1}
          },
          InitialAmount->{
            1*Milliliter
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          Name->{
            "Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,sample1}], ObjectP[]]];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringPreview tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];

(* ::Subsection::Closed:: *)
(*ExperimentDynamicLightScatteringOptions*)

DefineTests[ExperimentDynamicLightScatteringOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentDynamicLightScatteringOptions[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentDynamicLightScatteringOptions[Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentDynamicLightScatteringOptions[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],OutputFormat->List],
      {(_Rule|_RuleDelayed)..}
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
          Object[Container, Bench, "Fake bench for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]
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

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1,
          container2
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
            "Fake container 1 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID,
            "Fake container 2 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID
          }
        ];

        Upload[
          {
            <|
              Type->Model[Molecule,Protein],
              Name->"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID,
              MolecularWeight->40*(Kilogram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Create test Model[Sample]s *)
        Upload[
          {
            <|
              Type->Model[Sample],
              Name->"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1,
          sample2
        }=UploadSample[
          {
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          InitialAmount->{
            1*Milliliter,
            1*Milliliter
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          Name->{
            "Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID,
            "Fake discarded 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];
        Upload[<|Object -> sample2, Status -> Discarded|>];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScatteringOptions tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];



(* ::Subsection::Closed:: *)
(*ValidExperimentDynamicLightScatteringQ*)

DefineTests[ValidExperimentDynamicLightScatteringQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentDynamicLightScatteringQ[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentDynamicLightScatteringQ[Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentDynamicLightScatteringQ[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentDynamicLightScatteringQ[Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],Verbose->True],
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
          Object[Container, Bench, "Fake bench for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]
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

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        {
          container1,
          container2
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
            "Fake container 1 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID,
            "Fake container 2 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID
          }
        ];

        Upload[
          {
            <|
              Type->Model[Molecule,Protein],
              Name->"Test 40 kDa Model[Molecule,Protein] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID,
              MolecularWeight->40*(Kilogram/Mole),
              DeveloperObject->True
            |>
          }
        ];

        (* Create test Model[Sample]s *)
        Upload[
          {
            <|
              Type->Model[Sample],
              Name->"40 kDa test protein Model[Sample] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>
          }
        ];

        (* Upload test sample objects *)
        {
          sample1,
          sample2
        }=UploadSample[
          {
            Model[Sample,"40 kDa test protein Model[Sample] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A1", container2}
          },
          InitialAmount->{
            1*Milliliter,
            1*Milliliter
          },
          StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
          State->Liquid,
          Status->Available,
          Name->{
            "Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID,
            "Fake discarded 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];
        Upload[<|Object -> sample2, Status -> Discarded|>];
      ]
    ]

  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Object[Container,Vessel,"Fake container 1 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],
          Object[Container,Vessel,"Fake container 2 for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Model[Sample,"40 kDa test protein Model[Sample] for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],

          Object[Sample,"Fake test 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID],
          Object[Sample,"Fake discarded 10 mg/mL 40 kDa protein sample for ValidExperimentDynamicLightScatteringQ tests" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
]