DefineTests[PredictSamplePhase,
  {
    Example[
      {Basic,"The phase of a sample whose solvent is Model[Sample, \"Milli-Q water\"] is Aqueous:"},
      PredictSamplePhase[Object[Sample, "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID]],
      Aqueous
    ],
    Example[
      {Basic,"The phase of a sample whose solvent is Model[Sample, \"Ethyl acetate, Reagent Grade\"\] is Organic:"},
      PredictSamplePhase[Object[Sample, "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID]],
      Organic
    ],
    Example[
      {Basic,"The phase of a sample whose solvent is Model[Sample, \"DMSO, anhydrous\"] is Unknown:"},
      PredictSamplePhase[Object[Sample, "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID]],
      Unknown
    ],
    Example[
      {Basic,"Predict the phase for a list of Model[Sample] inputs:"},
      PredictSamplePhase[{Model[Sample, "Milli-Q water"], Model[Sample, "Toluene"]}],
      {Aqueous, Organic}
    ],
    Example[
      {Additional,"The phase of a sample with no Solvent but with 100 VolumePercent Model[Molecule, \"Water\"] in its Composition is Aqueous:"},
      PredictSamplePhase[Object[Sample, "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID]],
      Aqueous
    ],
    Example[
      {Additional,"The phase of a sample with no Solvent but with 100 VolumePercent Model[Molecule, \"Ethyl acetate\"] in its Composition is Organic:"},
      PredictSamplePhase[Object[Sample, "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID]],
      Organic
    ],
    Example[
      {Additional,"The phase of a sample with no Solvent but with 35 VolumePercent Model[Molecule, \"Water\"] and 65 VolumePercent Model[Molecule, \"Ethyl acetate\"] in its Composition is Biphasic:"},
      PredictSamplePhase[Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID]],
      Biphasic
    ],
    Example[
      {Additional,"The phase of a sample with no Composition and no Solvent information is Unknown:"},
      PredictSamplePhase[Object[Sample, "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID]],
      Unknown
    ],
    Example[
      {Additional,"Correctly predicts that Water will comprise the Aqueous phase and Ethyl Acetate will comprise the Organic phase:"},
      PredictSamplePhase[
        Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
        Output -> Molecule
      ],
      {Aqueous -> {Model[Molecule, "id:vXl9j57PmP5D"]}, Organic -> {Model[Molecule, "id:01G6nvwRWRvE"]}}
    ]
  },
  SetUp:>(ClearMemoization[];ClearDownload[];),
  SymbolSetUp:>Module[{existsFilter, tube1, tube2, tube3, tube4, tube5, tube6, tube7, sample1, sample2, sample3, sample4, sample5, sample6, sample7},
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for PredictSamplePhase "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for PredictSamplePhase "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];


    {tube1, tube2, tube3, tube4, tube5, tube6, tube7} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 6 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 7 for PredictSamplePhase "<>$SessionUUID,
        DeveloperObject -> True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample1, sample2, sample3, sample4, sample5, sample6, sample7} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        Model[Sample, "Reference Buffer - pH 7.38"],
        Model[Sample, "Reference Buffer - pH 7.38"],
        Model[Sample, "Reference Buffer - pH 7.38"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Ethyl acetate, Reagent Grade"],
        {{35 VolumePercent, Model[Molecule, "Water"]}, {65 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{Null, Null}}
      },
      {
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5},
        {"A1", tube6},
        {"A1", tube7}
      },
      Name -> {
        "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID,
        "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID
      },
      InitialAmount -> 10 Milliliter,
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample1, sample2, sample3, sample4, sample5, sample6, sample7}];

    Upload[{
      <|
        Object -> sample2,
        Solvent -> Link[Model[Sample, "Ethyl acetate, Reagent Grade"]]
      |>,
      <|
        Object -> sample3,
        Solvent -> Link[Model[Sample, "DMSO, anhydrous"]]
      |>,
      <|
        Object -> sample4,
        Solvent -> Null
      |>,
      <|
        Object -> sample5,
        Solvent -> Null
      |>,
      <|
        Object -> sample6,
        Solvent -> Null
      |>
    }];
  ],
  SymbolTearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];

    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for PredictSamplePhase "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for PredictSamplePhase "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Sample in Water (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for PredictSamplePhase) "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for PredictSamplePhase "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for PredictSamplePhase "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];

DefineTests[PredictDestinationPhase,
  {
    Example[
      {Basic,"Taxol is predicted to have a higher concentration in the Organic phase because its LogP is 3 (hydrophobic):"},
      PredictDestinationPhase[Model[Molecule,"Taxol"]],
      Organic
    ],
    Example[
      {Basic,"Caffeine is predicted to have a slightly concentration in the Aqueous phase because its LogP is -0.07 (slightly hydrophilic):"},
      PredictDestinationPhase[Model[Molecule,"Caffeine"]],
      Aqueous
    ],
    Example[
      {Basic,"Acetaminophen is predicted to have a slightly concentration in the Organic phase because its LogP is 0.46 (slightly hydrophobic):"},
      PredictDestinationPhase[Model[Molecule, "Acetaminophen"]],
      Organic
    ],
    Example[
      {Basic,"Molecules without an experimentally derived or simulated LogP have an unknown destination phase:"},
      PredictDestinationPhase[Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]],
      Unknown
    ]
  },
  SetUp:>(ClearMemoization[];ClearDownload[];),
  SymbolSetUp:>(
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];


    (*Create a protocol that we'll use for template testing*)
    Upload[{
      <|
        Type->Model[Molecule],
        Name->"Proprietary Molecule (test for PredictDestinationPhase) "<>$SessionUUID
      |>
    }];
  ),
  SymbolTearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];

    existsFilter=DatabaseMemberQ[{
      Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
      Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
          Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];

DefineTests[SimulateLogPartitionCoefficient,
  {
    Example[
      {Basic,"Simulate the Log Partition Coefficient (LogP) of Water (Log < 0 indicates that the molecule is hydrophilic):"},
      SimulateLogPartitionCoefficient[Model[Molecule,"Water"]],
      -1.38`
    ],
    Example[
      {Basic,"Simulate the Log Partition Coefficient (LogP) of DMSO (Log < 0 indicates that the molecule is hydrophilic):"},
      SimulateLogPartitionCoefficient[Model[Molecule, "Dimethyl sulfoxide"]],
      -1.35`
    ],
    Example[
      {Basic,"Simulate the Log Partition Coefficient (LogP) of Taxol (Log > 0 indicates that the molecule is hydrophobic):"},
      SimulateLogPartitionCoefficient[Model[Molecule, "Taxol"]],
      3
    ],
    Test["Make sure that the PubChem API connection is working (with no LogP filled out, this function should contact PubChem):",
      SimulateLogPartitionCoefficient[Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]],
      -1.35`
    ],
    Example[{Messages, "NoAvailableLogP", "A message is thrown if there is no experiemntally measured or simulated LogP on PubChem:"},
      SimulateLogPartitionCoefficient[Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]],
      Null,
      Messages :> {
        Error::NoAvailableLogP,
        Error::InvalidInput
      }
    ]
  },
  SetUp:>(ClearMemoization[];ClearDownload[];),
  SymbolSetUp:>(
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
      Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
          Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];


    (*Create a protocol that we'll use for template testing*)
    Upload[{
      <|
        Type -> Model[Molecule],
        Molecule -> Molecule["C(S(C([H])([H])[H])=O)([H])([H])[H]"],
        Name -> "DMSO (test for SimulateLogPartitionCoefficient) " <> $SessionUUID
      |>,
      <|
        Type->Model[Molecule],
        Name->"Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID
      |>
    }];
  ),
  SymbolTearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];

    existsFilter=DatabaseMemberQ[{
      Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
      Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Model[Molecule, "DMSO (test for SimulateLogPartitionCoefficient) "<>$SessionUUID],
          Model[Molecule, "Proprietary Molecule (test for SimulateLogPartitionCoefficient) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];