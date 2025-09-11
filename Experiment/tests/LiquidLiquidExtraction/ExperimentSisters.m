(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection::Closed:: *)
(*ExperimentLiquidLiquidExtractionOptions*)
DefineTests[
  ExperimentLiquidLiquidExtractionOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentLiquidLiquidExtractionOptions[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        ExtractionTechnique -> PhaseSeparator,
        SelectionStrategy -> Positive,
        TargetPhase -> Organic
      ],
      _Grid
    ],
    Example[{Basic,"Basic liquid liquid extraction with an aqueous sample with ExtractionTechnique->Pipette:"},
      ExperimentLiquidLiquidExtractionOptions[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Positive
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentLiquidLiquidExtractionOptions[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        TargetAnalyte -> Model[Molecule, "Caffeine"]
      ],
      _Grid,
      Messages:>{
        Warning::WeakTargetAnalytePhaseAffinity
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentLiquidLiquidExtractionOptions[
        {
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID]
        },
        SamplePhase->Biphasic,
        ExtractionTechnique->Pipette,
        SelectionStrategy->Negative,
        TargetPhase->Organic,
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> Module[
    {
      existsFilter, testBench, tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7, sample0, sample1, sample2, sample3,
      sample4, sample5, sample6, sample7
    },
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
      Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
          Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    testBench = Upload[<|
      Type -> Object[Container, Bench],
      Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
      Name -> "Test bench for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
      DeveloperObject -> True,
      Site -> Link[$Site]
    |>];

    {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7} = UploadSample[
      ConstantArray[Model[Container, Vessel, "50mL Tube"], 8],
      ConstantArray[{"Work Surface", testBench}, 8],
      Name -> {
        "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID,
        "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID
      }
    ];
    Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7};

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Dimethyl sulfoxide"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {35 VolumePercent, Model[Molecule, "Water"]}, {65 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{Null, Null}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5},
        {"A1", tube6},
        {"A1", tube7}
      },
      Name -> {
        "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID,
        "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID
      },
      InitialAmount -> {
        10 Milliliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter
      },
      State -> Liquid,
      Sterile -> True,
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7}];

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

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionOptions) "<>$SessionUUID],
        Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionOptions "<>$SessionUUID]
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
(*ValidExperimentLiquidLiquidExtractionQ*)
DefineTests[
  ValidExperimentLiquidLiquidExtractionQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentLiquidLiquidExtractionQ[
        Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID]
      ],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentLiquidLiquidExtractionQ[
        {
          Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) " <> $SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) " <> $SessionUUID]
        },
        ExtractionMixType->Pipette,
        NumberOfExtractionMixes->Null
      ],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentLiquidLiquidExtractionQ[
        Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        OutputFormat->TestSummary
      ],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentLiquidLiquidExtractionQ[
        Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Verbose->True
      ],
      True
    ]
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> Module[{existsFilter, tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7, sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Large Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Large Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];


    {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 0 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 1 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 2 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 3 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 4 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 5 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 6 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test 50mL Tube 7 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Dimethyl sulfoxide"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {35 VolumePercent, Model[Molecule, "Water"]}, {65 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{Null, Null}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5},
        {"A1", tube6},
        {"A1", tube7}
      },
      Name -> {
        "Large Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample in Ethyl Acetate (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample in DMSO (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample with Water in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample with Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample with Water and Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID,
        "Sample with No Composition or Solvent Information (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID
      },
      InitialAmount -> {
        10 Milliliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter
      },
      State -> Liquid,
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7}];

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

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        Object[Sample, "Large Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample in Water (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample in Ethyl Acetate (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample in DMSO (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample with Water in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Sample, "Sample with No Composition or Solvent Information (Test for ValidExperimentLiquidLiquidExtractionQ) "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 6 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 7 for ValidExperimentLiquidLiquidExtractionQ "<>$SessionUUID]
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
(*ExperimentLiquidLiquidExtractionPreview*)
DefineTests[
  ExperimentLiquidLiquidExtractionPreview,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentLiquidLiquidExtractionPreview[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        ExtractionTechnique -> PhaseSeparator,
        SelectionStrategy -> Positive,
        TargetPhase -> Organic
      ],
      Null
    ],
    Example[{Basic,"Basic liquid liquid extraction with an aqueous sample with ExtractionTechnique->Pipette:"},
      ExperimentLiquidLiquidExtractionPreview[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        ExtractionTechnique -> Pipette,
        SelectionStrategy -> Positive
      ],
      Null
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentLiquidLiquidExtractionPreview[
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        TargetAnalyte -> Model[Molecule, "Caffeine"]
      ],
      Null,
      Messages:>{
        Warning::WeakTargetAnalytePhaseAffinity
      }
    ]
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> Module[
    {
      existsFilter, testBench, tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7, sample0, sample1, sample2, sample3,
      sample4, sample5, sample6, sample7
    },
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
      Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
      Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
          Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
          Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    testBench = Upload[<|
      Type -> Object[Container, Bench],
      Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
      Name -> "Test bench for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
      DeveloperObject -> True,
      Site -> Link[$Site]
    |>];

    {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7} = UploadSample[
      ConstantArray[Model[Container, Vessel, "50mL Tube"], 8],
      ConstantArray[{"Work Surface", testBench}, 8],
      Name -> {
        "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID,
        "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID
      }
    ];
    Upload[<|Object -> #, DeveloperObject -> True|>]& /@ {tube0, tube1, tube2, tube3, tube4, tube5, tube6, tube7};

    (* Create some samples for testing purposes *)
    {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Dimethyl sulfoxide"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Water"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {100 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{10 Molar, Model[Molecule,"Taxol"]}, {35 VolumePercent, Model[Molecule, "Water"]}, {65 VolumePercent, Model[Molecule, "Ethyl acetate"]}},
        {{Null, Null}}
      },
      {
        {"A1", tube0},
        {"A1", tube1},
        {"A1", tube2},
        {"A1", tube3},
        {"A1", tube4},
        {"A1", tube5},
        {"A1", tube6},
        {"A1", tube7}
      },
      Name -> {
        "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID,
        "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID
      },
      InitialAmount -> {
        10 Milliliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter,
        500 Microliter
      },
      State -> Liquid,
      Sterile -> True,
      FastTrack -> True
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample0, sample1, sample2, sample3, sample4, sample5, sample6, sample7}];

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

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        Object[Sample, "Large Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample in Water (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample in Ethyl Acetate (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample in DMSO (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample with Water in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample with Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample with Water and Ethyl Acetate in Composition (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Sample, "Sample with No Composition or Solvent Information (Test for ExperimentLiquidLiquidExtractionPreview) "<>$SessionUUID],
        Object[Container, Bench, "Test bench for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 0 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID],
        Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentLiquidLiquidExtractionPreview "<>$SessionUUID]
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