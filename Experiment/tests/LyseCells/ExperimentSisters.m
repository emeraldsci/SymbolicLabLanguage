(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentLyseCellsOptions*)
DefineTests[
  ExperimentLyseCellsOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentLyseCellsOptions[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID]
      ],
      _Grid
    ],
    Example[{Basic,"Basic cell lysis experiment with a sample of adherent mammalian cells:"},
      ExperimentLyseCellsOptions[
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Aliquot -> True,
        ClarifyLysate -> True
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentLyseCellsOptions[
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        MixType -> Pipette,
        LysisTemperature -> Ambient,
        LysisTime -> 10 Minute
      ],
      _Grid,
      Messages:>{
        Warning::UnknownCellType
      }
    ],

    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentLyseCellsOptions[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID]
        },
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  TurnOffMessages :> {Warning::ConflictingSourceAndDestinationAsepticHandling},
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),

  SymbolSetUp :> Module[{existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0, sample0, sample1, sample2, sample3, sample4, sample5},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
      Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
      Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
      Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],

      Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],

      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsOptions "<>$SessionUUID],

      Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID]

    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
          Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
          Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],

          Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],

          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsOptions "<>$SessionUUID],

          Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID]

        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    {tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test aliquot container tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Yeast, "Pichia Pastoris"]}},
        {{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5}
      },
      Name -> {
        "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID,
        "Suspension mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID,
        "Adherent yeast cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID,
        "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsOptions) "<>$SessionUUID,
        "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID,
        "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID
      },
      InitialAmount -> {
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter
      },
      CellType -> {
        Mammalian,
        Mammalian,
        Yeast,
        Mammalian,
        Mammalian,
        Null
      },
      CultureAdhesion -> {
        Adherent,
        Suspension,
        Adherent,
        Suspension,
        Null,
        Adherent
      },
      Living -> {
        True,
        True,
        True,
        True,
        True,
        True
      },
      State -> Liquid,
      FastTrack -> True
    ];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsOptions) "<>$SessionUUID],

        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsOptions "<>$SessionUUID],

        Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsOptions "<>$SessionUUID]

      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ::Subsection::Closed:: *)
(*ValidExperimentLyseCellsQ*)
DefineTests[
  ValidExperimentLyseCellsQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentLyseCellsQ[
        Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID]
      ],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentLyseCellsQ[
        {
          Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID]
        },
        MixType->Pipette,
        NumberOfMixes->Null
      ],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentLyseCellsQ[
        Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        OutputFormat->TestSummary
      ],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentLyseCellsQ[
        Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Verbose->True
      ],
      True
    ]
  },
  TurnOffMessages :> {Warning::ConflictingSourceAndDestinationAsepticHandling},
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),

  SymbolSetUp :> Module[{existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0, sample0, sample1, sample2, sample3, sample4, sample5},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
      Object[Sample, "Adherent yeast cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
      Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
      Object[Sample, "Adherent cell sample without information in CellType field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],

      Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],

      Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLyseCellsQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLyseCellsQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLyseCellsQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLyseCellsQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLyseCellsQ "<>$SessionUUID],

      Object[Container, Vessel, "Test aliquot container tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID]

    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
          Object[Sample, "Adherent cell sample without information in CellType field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],

          Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],

          Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLyseCellsQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLyseCellsQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLyseCellsQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLyseCellsQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLyseCellsQ "<>$SessionUUID],

          Object[Container, Vessel, "Test aliquot container tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID]

        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    {tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test aliquot container tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Yeast, "Pichia Pastoris"]}},
        {{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5}
      },
      Name -> {
        "Adherent mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID,
        "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID,
        "Adherent yeast cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID,
        "Suspension mammalian cell sample with cell concentration info in composition (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID,
        "Mammalian cell sample without information in CultureAdhesion field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID,
        "Adherent cell sample without information in CellType field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID
      },
      InitialAmount -> {
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter
      },
      CellType -> {
        Mammalian,
        Mammalian,
        Yeast,
        Mammalian,
        Mammalian,
        Null
      },
      CultureAdhesion -> {
        Adherent,
        Suspension,
        Adherent,
        Suspension,
        Null,
        Adherent
      },
      Living -> {
        True,
        True,
        True,
        True,
        True,
        True
      },
      State -> Liquid,
      FastTrack -> True
    ];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ValidExperimentLyseCellsQ) "<>$SessionUUID],

        Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLyseCellsQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLyseCellsQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLyseCellsQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLyseCellsQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLyseCellsQ "<>$SessionUUID],

        Object[Container, Vessel, "Test aliquot container tube 0 for ValidExperimentLyseCellsQ "<>$SessionUUID]

      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];
(* ::Subsection:: *)
(* ExperimentLyseCellsPreview *)
DefineTests[
  ExperimentLyseCellsPreview,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a preview for an ExperimentLyseCells call to lyse the cells in a single sample:"},
      ExperimentLyseCellsPreview[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID]],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentLyseCells call to lyse the cells in multiple samples:"},
      ExperimentLyseCellsPreview[{
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID]
      }],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentLyseCells call to lyse the cells in a single container:"},
      ExperimentLyseCellsPreview[Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsPreview "<>$SessionUUID]],
      Null
    ]
  },
  TurnOffMessages :> {Warning::ConflictingSourceAndDestinationAsepticHandling},
  SymbolSetUp :> Module[{existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0, sample0, sample1, sample2, sample3, sample4, sample5},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
      Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
      Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
      Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
      Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],

      Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],

      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsPreview "<>$SessionUUID],

      Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID]

    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
          Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
          Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
          Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
          Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],

          Object[Method, LyseCells, "Mammalian protein Lysis Method (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],

          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsPreview "<>$SessionUUID],

          Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID]

        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    {tube0, tube1, tube2, tube3, tube4, tube5, aliquotTube0} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test aliquot container tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 VolumePercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Yeast, "Pichia Pastoris"]}},
        {{10^10 EmeraldCell/Milliliter, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
        {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5}
      },
      Name -> {
        "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID,
        "Suspension mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID,
        "Adherent yeast cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID,
        "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsPreview) "<>$SessionUUID,
        "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID,
        "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID
      },
      InitialAmount -> {
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter,
        0.5 Milliliter
      },
      CellType -> {
        Mammalian,
        Mammalian,
        Yeast,
        Mammalian,
        Mammalian,
        Null
      },
      CultureAdhesion -> {
        Adherent,
        Suspension,
        Adherent,
        Suspension,
        Null,
        Adherent
      },
      Living -> {
        True,
        True,
        True,
        True,
        True,
        True
      },
      State -> Liquid,
      FastTrack -> True
    ];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample, "Adherent mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Adherent yeast cell sample (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Suspension mammalian cell sample with cell concentration info in composition (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Mammalian cell sample without information in CultureAdhesion field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],
        Object[Sample, "Adherent cell sample without information in CellType field (Test for ExperimentLyseCellsPreview) "<>$SessionUUID],

        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLyseCellsPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLyseCellsPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLyseCellsPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLyseCellsPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLyseCellsPreview "<>$SessionUUID],

        Object[Container, Vessel, "Test aliquot container tube 0 for ExperimentLyseCellsPreview "<>$SessionUUID]

      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  )
];
