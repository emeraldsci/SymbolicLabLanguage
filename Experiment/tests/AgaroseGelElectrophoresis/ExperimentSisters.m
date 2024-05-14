(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*ExperimentAgaroseGelElectrophoresisPreview*)

DefineTests[ExperimentAgaroseGelElectrophoresisPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentAgaroseGelElectrophoresis:"},
      ExperimentAgaroseGelElectrophoresisPreview[Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentAgaroseGelElectrophoresisOptions:"},
      ExperimentAgaroseGelElectrophoresisOptions[Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentAgaroseGelElectrophoresisQ:"},
      ValidExperimentAgaroseGelElectrophoresisQ[Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID]],
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
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Test bench for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench,
          container1,
          sample1
        },

		  testBench=Upload[
			  <|Type->Object[Container,Bench],
				  Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				  Name->"Test bench for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID,
				  DeveloperObject->True,
				  StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			  |>
		  ];

        {
          container1
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", testBench}
          },
          Status->Available,
          Name->{
            "Test container 1 for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID
          }
        ];

        (* Create a Oligomer Molecule Model for the test samples' Composition field *)
        Upload[
          <|
            Type->Model[Molecule,Oligomer],
            Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 400]]]],
            PolymerType->DNA,
            Name->"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID,
            DeveloperObject->True
          |>
        ];

        (* Upload test sample objects *)
        {
          sample1
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
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
            "Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID
          }
        ];
        Upload[<|Object->#, DeveloperObject->True, AwaitingStorageUpdate->Null|> & /@ Cases[Flatten[{container1,sample1}], ObjectP[]]];
      ]
    ]
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Test bench for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisPreview tests "<>$SessionUUID],
          Object[Sample,"Test test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisPreview "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ]
  )
];

(* ::Subsection::Closed:: *)
(*ExperimentAgaroseGelElectrophoresisOptions*)

DefineTests[ExperimentAgaroseGelElectrophoresisOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentAgaroseGelElectrophoresisOptions[Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentAgaroseGelElectrophoresisOptions[Object[Sample,"Test discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat->List, return a list of options:"},
      ExperimentAgaroseGelElectrophoresisOptions[Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],OutputFormat->List],
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
    Off[Warning::SamplesOutOfStock];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Sample,"Test discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench,
          container1,container2,
          sample1,sample2
        },

        testBench=Upload[
          <|
            Type->Object[Container,Bench],
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Name->"Test bench for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID,
            DeveloperObject->True,
            StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
          |>
        ];

        {
          container1,
          container2
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Status->Available,
          Name->{
            "Test container 1 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID,
            "Test container 2 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID
          }
        ];

        (* Create an Oligomer Molecule Model for the test samples' Composition field *)
        Upload[
          <|
            Type->Model[Molecule,Oligomer],
            Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 400]]]],
            PolymerType->DNA,
            DeveloperObject->True,
            Name->"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID
          |>
        ];

        (* Upload test sample objects *)
        {
          sample1,
          sample2
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            },
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
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
            "Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID,
            "Test discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID
          }
        ];

        Upload[<|Object->#, DeveloperObject->True, AwaitingStorageUpdate->Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|Object->sample2, Status->Discarded|>
        }], PacketP[]]];
      ]
    ]

  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Sample,"Test 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID],
          Object[Sample,"Test discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresisOptions tests "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentAgaroseGelElectrophoresisQ*)

DefineTests[ValidExperimentAgaroseGelElectrophoresisQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentAgaroseGelElectrophoresisQ[Object[Sample,"Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentAgaroseGelElectrophoresisQ[Object[Sample,"Test discarded 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentAgaroseGelElectrophoresisQ[Object[Sample,"Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentAgaroseGelElectrophoresisQ[Object[Sample,"Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],Verbose->True],
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
    Off[Warning::SamplesOutOfStock];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Sample,"Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Sample,"Test discarded 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench,
          container1,container2,
          sample1,sample2
        },

        testBench=Upload[
          <|
            Type->Object[Container,Bench],
            Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
            Name->"Test bench for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID,
            DeveloperObject->True,
            StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
          |>
        ];

        {
          container1,
          container2
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Status->Available,
          Name->{
            "Test container 1 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID,
            "Test container 2 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID
          }
        ];

        (* Create a Oligomer Molecule Model for the test samples' Composition field *)
        Upload[
          <|
            Type->Model[Molecule,Oligomer],
            Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 400]]]],
            PolymerType->DNA,
            DeveloperObject->True,
            Name->"Test 1600mer DNA Model Molecule for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID
          |>
        ];


        (* Upload test sample objects *)
        {
          sample1,
          sample2
        }=UploadSample[
          {
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Test 1600mer DNA Model Molecule for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            },
            {
              {20*Micromolar,Link[Model[Molecule, Oligomer, "Test 1600mer DNA Model Molecule for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]]},
              {100*VolumePercent,Link[Model[Molecule, "Water"]]}
            }
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
            "Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID,
            "Test discarded 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID
          }
        ];

        Upload[<|Object->#, DeveloperObject->True, AwaitingStorageUpdate->Null|> & /@ Cases[Flatten[{container1,container2,sample1,sample2}], ObjectP[]]];

        Upload[Cases[Flatten[{
          <|Object->sample2, Status->Discarded|>
        }], PacketP[]]];
      ]
    ]

  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Test bench for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 1 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Model[Molecule,Oligomer,"Test 1600mer DNA Model Molecule for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Sample,"Test 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID],
          Object[Sample,"Test discarded 1600mer DNA oligomer for ValidExperimentAgaroseGelElectrophoresisQ tests "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force->True, Verbose->False]
    ]
  )
]


