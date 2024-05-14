(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ExperimentThawCells: Tests*)

(* ::Subsection:: *)
(*ExperimentThawCells*)

DefineTests[ExperimentThawCells,
  {
    Example[{Basic, "Thaw a single vial of HEK293:"},
      ExperimentThawCells[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Example[{Basic, "Thaw 2 cryovials of HEK293 using a bead bath:"},
      ExperimentThawCells[
        {
          Model[Sample, "id:qdkmxz0A88r3"],
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"]
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Example[{Basic, "Thaw a single vial of HEK293, specifiying that the vials should be placed in the bead bath at 37C for up to 1 minute, until they are fully thawed:"},
      ExperimentThawCells[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"],
        Temperature -> 37 Celsius,
        MaxTime -> 1 Minute
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Test["Set up inputs as the {Position,Plate}:",
      ExperimentThawCells[
        {
          "A2",
          Object[Container,Plate,"Test Plate 1 for ExperimentThawCells "<>$SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Test["Set up inputs as a mixture of plates and samples:",
      ExperimentThawCells[
        {
          Object[Sample,"Test Bacterial Sample 7 (Model 4) for ExperimentThawCells "<>$SessionUUID],
          {"A2", Object[Container, Plate, "Test Plate 1 for ExperimentThawCells "<>$SessionUUID]}
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]]
    ],
    Test["Resolves a basic set of options for some adherent cells:",
      ExperimentThawCells[
        {
          Object[Sample,"Test Adherent Mammalian Sample 1 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 2 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 3 (Model 2) for ExperimentThawCells "<>$SessionUUID]
        },
        Output->Options
      ],
      KeyValuePattern[{
        Instrument -> ObjectP[{Model[Instrument, HeatBlock]}]
      }]
    ],
    Test["Specify a robotic protocol to thaw a vial of cells:",
      ExperimentThawCells[
        Model[Sample, "id:qdkmxz0A88r3"],
        Preparation->Robotic
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]]
    ],
    Test[{Messages, "NoWorkCellsPossibleForUnitOperation", "When thawing cells robotically, cryovials will be grouped into thermally conductive racks (Model[Container, Rack, \"Small Cryogenic Vial Heater Shaker Rack\"]) based on their specified thawing time. If too many different thawing times are specified, this will result in too many individual racks -- which means that they will not fit into the same work cell:"},
      ExperimentThawCells[
        ConstantArray[Model[Sample, "id:qdkmxz0A88r3"],100],
        Time->Table[x*Minute,{x,1,100}],
        Preparation->Robotic
      ],
      $Failed,
      Messages:>{
        Error::NoWorkCellsPossibleForUnitOperation,
        Error::InvalidOption
      }
    ],
    Test[{Messages, "ThawInstrumentTemperatureMismatch", "Temperature option cannot be specified if using a ThawSTAR:"},
      ExperimentThawCells[
        Model[Sample, "id:qdkmxz0A88r3"],
        Instrument->Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
        Temperature->37 Celsius
      ],
      $Failed,
      Messages:>{
        Error::ThawInstrumentTemperatureMismatch,
        Error::InvalidOption
      }
    ],
    Test[{Messages, "ThawInstrumentTimeMismatch", "Time option cannot be specified if using a ThawSTAR:"},
      ExperimentThawCells[
        Model[Sample, "id:qdkmxz0A88r3"],
        Instrument->Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
        Time->3 Minute
      ],
      $Failed,
      Messages:>{
        Error::ThawInstrumentTimeMismatch,
        Error::InvalidOption
      }
    ],
    Test[{Messages, "ThawInstrumentContainerMismatch", "The ThawSTAR instrument can only accept samples in a 2mL cryovial format (Model[Container, Vessel, \"id:vXl9j5qEnnOB\"]):"},
      ExperimentThawCells[
        Object[Container, Plate, "Test Plate 1 for ExperimentThawCells "<>$SessionUUID],
        Instrument->Model[Instrument, CellThaw, "id:E8zoYveRllXB"]
      ],
      $Failed,
      Messages:>{
        Error::ThawInstrumentContainerMismatch,
        Error::InvalidOption
      }
    ]
  },
  Stubs:>{
    $EmailEnabled=False,
    $PublicPath=$TemporaryDirectory,
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  (*  build test objects *)
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Fake bench for ExperimentThawCells "<>$SessionUUID],

          Model[Sample,"Test Adherent Mammalian Model 1 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Adherent Mammalian Model 2 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Suspension Mammalian Model 3 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Bacterial Model 4 for ExperimentThawCells "<>$SessionUUID],

          Object[Sample,"Test Adherent Mammalian Sample 1 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 2 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 3 (Model 2) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test AdherentTissueCulture Sample 4 (Model 2) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Suspension Mammalian Sample 5 (Model 3) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Suspension Mammalian Sample 6 (Model 3) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Bacterial Sample 7 (Model 4) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Bacterial Sample 8 (Model 4) for ExperimentThawCells "<>$SessionUUID],

          Object[Container, Plate, "Test Plate 1 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Plate, "Test Plate 2 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentThawCells "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,plate1,plate2,tube3,tube4,tube5,tube6,
          sampleList,containerList
        },
        
        (* set up fake bench as a location for the vessel *)
        fakeBench=Upload[<|
          Type->Object[Container,Bench],
          Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
          Name->"Fake bench for ExperimentThawCells "<>$SessionUUID,
          DeveloperObject->True,
          StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
        |>];

        (* set up containers for our samples *)
        {
          (*1*)plate1,
          (*2*)plate2,
          (*3*)tube3,
          (*4*)tube4,
          (*5*)tube5,
          (*6*)tube6
        }=UploadSample[
          {
            (*1*)Model[Container, Plate, "id:eGakld01zzLx"],
            (*2*)Model[Container, Plate, "id:eGakld01zzLx"],
            (*3*)Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            (*4*)Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            (*5*)Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            (*6*)Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          },
          {
            (*1*){"Work Surface",fakeBench},
            (*2*){"Work Surface",fakeBench},
            (*3*){"Work Surface",fakeBench},
            (*4*){"Work Surface",fakeBench},
            (*5*){"Work Surface",fakeBench},
            (*6*){"Work Surface",fakeBench}
          },
          Status->
              {
                (*1*)Available,
                (*2*)Available,
                (*3*)Available,
                (*4*)Available,
                (*5*)Available,
                (*6*)Available
              },
          Name->
              {
                "Test Plate 1 for ExperimentThawCells "<>$SessionUUID,
                "Test Plate 2 for ExperimentThawCells "<>$SessionUUID,
                "Test 50mL Tube 3 for ExperimentThawCells "<>$SessionUUID,
                "Test 50mL Tube 4 for ExperimentThawCells "<>$SessionUUID,
                "Test 50mL Tube 5 for ExperimentThawCells "<>$SessionUUID,
                "Test 50mL Tube 6 for ExperimentThawCells "<>$SessionUUID
              }
        ];

        UploadSampleModel[
          "Test Adherent Mammalian Model 1 for ExperimentThawCells "<>$SessionUUID,
          Composition->{
            {70 VolumePercent,Model[Cell, Mammalian, "HeLa"]},
            {30 VolumePercent, Model[Molecule,"Glycerol"]}
          },
          IncompatibleMaterials->{None},
          Expires->False,
          DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
          MSDSRequired->False,
          BiosafetyLevel->"BSL-2",
          State->Liquid,
          CellType->Mammalian,
          Living -> True,
          CultureAdhesion->Adherent
        ];

        UploadSampleModel[
          "Test Adherent Mammalian Model 2 for ExperimentThawCells "<>$SessionUUID,
          Composition->{
            {70 VolumePercent,Model[Cell, Mammalian, "HEK293"]},
            {30 VolumePercent, Model[Molecule,"Glycerol"]}
          },
          IncompatibleMaterials->{None},
          Expires->False,
          DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
          MSDSRequired->False,
          BiosafetyLevel->"BSL-2",
          State->Liquid,
          CellType->Mammalian,
          Living -> True,
          CultureAdhesion->Adherent
        ];

        UploadSampleModel[
          "Test Suspension Mammalian Model 3 for ExperimentThawCells "<>$SessionUUID,
          Composition->{
            {70 VolumePercent,Model[Cell, Mammalian, "SiHa"]},
            {30 VolumePercent, Model[Molecule,"Glycerol"]}
          },
          IncompatibleMaterials->{None},
          Expires->False,
          DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
          MSDSRequired->False,
          BiosafetyLevel->"BSL-2",
          State->Liquid,
          CellType->Mammalian,
          Living -> True,
          CultureAdhesion->Suspension
        ];

        UploadSampleModel[
          "Test Bacterial Model 4 for ExperimentThawCells "<>$SessionUUID,
          Composition->{
            {70 VolumePercent,Model[Cell, Bacteria, "E.coli MG1655"]},
            {30 VolumePercent, Model[Molecule,"Glycerol"]}
          },
          IncompatibleMaterials->{None},
          Expires->False,
          DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
          MSDSRequired->False,
          BiosafetyLevel->"BSL-2",
          State->Liquid,
          CellType->Bacterial,
          Living -> True,
          CultureAdhesion->Suspension
        ];

        (* set up fake samples to test *)
        {
          (*1*)sample1,
          (*2*)sample2,
          (*3*)sample3,
          (*4*)sample4,
          (*5*)sample5,
          (*6*)sample6,
          (*7*)sample7,
          (*8*)sample8
        }=UploadSample[
          {
            (*1*)Model[Sample,"Test Adherent Mammalian Model 1 for ExperimentThawCells "<>$SessionUUID],
            (*2*)Model[Sample,"Test Adherent Mammalian Model 1 for ExperimentThawCells "<>$SessionUUID],
            (*3*)Model[Sample,"Test Adherent Mammalian Model 2 for ExperimentThawCells "<>$SessionUUID],
            (*4*)Model[Sample,"Test Adherent Mammalian Model 2 for ExperimentThawCells "<>$SessionUUID],
            (*5*)Model[Sample,"Test Suspension Mammalian Model 3 for ExperimentThawCells "<>$SessionUUID],
            (*6*)Model[Sample,"Test Suspension Mammalian Model 3 for ExperimentThawCells "<>$SessionUUID],
            (*7*)Model[Sample,"Test Bacterial Model 4 for ExperimentThawCells "<>$SessionUUID],
            (*8*)Model[Sample,"Test Bacterial Model 4 for ExperimentThawCells "<>$SessionUUID]
          },
          {
            (*1*){"A1",plate1},
            (*2*){"A2",plate1},
            (*3*){"A1",plate2},
            (*4*){"A2",plate2},
            (*5*){"A1",tube3},
            (*6*){"A1",tube4},
            (*7*){"A1",tube5},
            (*8*){"A1",tube6}
          },
          InitialAmount->{
            (*1*)2 Milliliter,
            (*2*)2 Milliliter,
            (*3*)2 Milliliter,
            (*4*)2 Milliliter,
            (*5*)25 Milliliter,
            (*6*)25 Milliliter,
            (*7*)25 Milliliter,
            (*8*)25 Milliliter
          },
          Name-> {
            "Test Adherent Mammalian Sample 1 (Model 1) for ExperimentThawCells "<>$SessionUUID,
            "Test Adherent Mammalian Sample 2 (Model 1) for ExperimentThawCells "<>$SessionUUID,
            "Test Adherent Mammalian Sample 3 (Model 2) for ExperimentThawCells "<>$SessionUUID,
            "Test AdherentTissueCulture Sample 4 (Model 2) for ExperimentThawCells "<>$SessionUUID,
            "Test Suspension Mammalian Sample 5 (Model 3) for ExperimentThawCells "<>$SessionUUID,
            "Test Suspension Mammalian Sample 6 (Model 3) for ExperimentThawCells "<>$SessionUUID,
            "Test Bacterial Sample 7 (Model 4) for ExperimentThawCells "<>$SessionUUID,
            "Test Bacterial Sample 8 (Model 4) for ExperimentThawCells "<>$SessionUUID
          }
        ];

        (* gather all our samples and containers *)
        sampleList={sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8};
        containerList={plate1,plate2,tube3,tube4,tube5,tube6};

        (* upload DeveloperObject -> True for all test objects *)
        Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@Cases[Flatten[{sampleList,containerList}],ObjectP[]]];

        $CreatedObjects={};
      ]
    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          $CreatedObjects,

          Object[Container,Bench,"Fake bench for ExperimentThawCells "<>$SessionUUID],

          Model[Sample,"Test Adherent Mammalian Model 1 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Adherent Mammalian Model 2 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Suspension Mammalian Model 3 for ExperimentThawCells "<>$SessionUUID],
          Model[Sample,"Test Bacterial Model 4 for ExperimentThawCells "<>$SessionUUID],

          Object[Sample,"Test Adherent Mammalian Sample 1 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 2 (Model 1) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Adherent Mammalian Sample 3 (Model 2) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test AdherentTissueCulture Sample 4 (Model 2) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Suspension Mammalian Sample 5 (Model 3) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Suspension Mammalian Sample 6 (Model 3) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Bacterial Sample 7 (Model 4) for ExperimentThawCells "<>$SessionUUID],
          Object[Sample,"Test Bacterial Sample 8 (Model 4) for ExperimentThawCells "<>$SessionUUID],

          Object[Container, Plate, "Test Plate 1 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Plate, "Test Plate 2 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentThawCells "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentThawCells "<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False];

      (* clear $CreatedObjects *)
      Unset[$CreatedObjects];
    ]
  )
];

DefineTests[ThawCells,
  {
    Example[{Basic,"Create a thaw cells unit operation to thaw a frozen cell sample:"},
      ThawCells[
        Sample->Object[Sample,"Frozen Cell Sample"]
      ],
      _ThawCells
    ],
    Example[{Basic, "Thaw 2 cryovials of HEK293 using a bead bath:"},
      ThawCells[
        {
          Model[Sample, "id:qdkmxz0A88r3"],
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"]
      ],
      _ThawCells
    ],
    Example[{Basic, "Thaw a single vial of HEK293, specifying that the vials should be placed in the bead bath at 37C for up to 1 minute, until they are fully thawed:"},
      ThawCells[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"],
        Temperature -> 37 Celsius,
        MaxTime -> 1 Minute
      ],
      _ThawCells
    ]
  }
];

DefineTests[ExperimentThawCellsOptions,
  {
    Example[{Basic, "Display the option values when thawing a single vial of HEK293:"},
      ExperimentThawCellsOptions[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        }
      ],
      _Grid
    ],
    Example[{Basic, "Display the option values when thawing 2 cryovials of HEK293 using a bead bath:"},
      ExperimentThawCellsOptions[
        {
          Model[Sample, "id:qdkmxz0A88r3"],
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"]
      ],
      _Grid
    ],
    Example[{Basic, "Display the option values when thawing a single vial of HEK293, specifiying that the vials should be placed in the bead bath at 37C for up to 1 minute, until they are fully thawed:"},
      ExperimentThawCellsOptions[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"],
        Temperature -> 37 Celsius,
        MaxTime -> 1 Minute
      ],
      _Grid
    ]
  },
  Stubs:>{
    $EmailEnabled=False,
    $PublicPath=$TemporaryDirectory,
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  (*  build test objects *)
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
  )
];

DefineTests[ValidExperimentThawCellsQ,
  {
    Example[{Basic, "Validate a protocol to thaw a single vial of HEK293:"},
      ValidExperimentThawCellsQ[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        }
      ],
      True
    ],
    Example[{Basic, "Validate a protocol to thaw 2 cryovials of HEK293 using a bead bath:"},
      ValidExperimentThawCellsQ[
        {
          Model[Sample, "id:qdkmxz0A88r3"],
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"]
      ],
      True
    ],
    Example[{Basic, "Validate a protocol to thaw a single vial of HEK293, specifiying that the vials should be placed in the bead bath at 37C for up to 1 minute, until they are fully thawed:"},
      ValidExperimentThawCellsQ[
        {
          Model[Sample, "id:qdkmxz0A88r3"]
        },
        Instrument -> Model[Instrument, HeatBlock, "id:eGakldJWknme"],
        Temperature -> 37 Celsius,
        MaxTime -> 1 Minute
      ],
      True
    ]
  },
  Stubs:>{
    $EmailEnabled=False,
    $PublicPath=$TemporaryDirectory,
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  },
  (*  build test objects *)
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
  )
];