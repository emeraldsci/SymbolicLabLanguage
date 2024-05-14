DefineTests[
  preResolveExtractionSolidPhaseSharedOptions,
  {
    Example[
      {Basic,"Base case test pre-resolving solid phase extraction shared options with no user input or specification:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {Purification->{SolidPhaseExtraction}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        preResolveExtractionSolidPhaseSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID]
          },
          {Custom,Custom},
          $SPEPurificationOptionMap,
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent -> {RNA, RNA}
        ]
      ],
      {_Rule..}
    ],
    Example[
      {Basic,"Base case test preresolve solid phase extraction shared options with user input and method specified fields:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {Purification->{SolidPhaseExtraction},
            Method->Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)"<>$SessionUUID],
            SolidPhaseExtractionLoadingSampleVolume -> 50 Microliter}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        preResolveExtractionSolidPhaseSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID]
          },
          {
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)"<>$SessionUUID],
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)"<>$SessionUUID]
          },
          $SPEPurificationOptionMap,
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent -> {RNA, RNA}
        ]
      ],
      KeyValuePattern[{
        SolidPhaseExtractionStrategy -> ListableP[Negative], (*Specified by test method*)
        SolidPhaseExtractionLoadingSampleVolume -> ListableP[EqualP[50 Microliter]](*Specified by user*)
      }]
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{
      existsFilter,emptyContainer1,emptyContainer2,mammalianSample1,mammalianSample2,mammalianSample3,testMethod
    },
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[{
        Object[Container,Plate,"Test mammalian plate 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
        Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)"<>$SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID],
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)"<>$SessionUUID]
          },
          existsFilter
        ],
        Force->True,
        Verbose->False
      ];

      (* Create some empty containers *)
      {
        emptyContainer1,
        emptyContainer2
      }=Upload[
        {
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>
        }
      ];

      (* Create some bacteria and mammalian samples *)
      {
        mammalianSample1,
        mammalianSample2,
        mammalianSample3
      }=ECL`InternalUpload`UploadSample[
        {
          Model[Sample, "HEK293"],
          Model[Sample, "HEK293"],
          Model[Sample, "HEK293"]
        },
        {
          {"A1",emptyContainer1},
          {"A2",emptyContainer1},
          {"A1",emptyContainer2}
        },
        InitialAmount->{
          2 Milliliter,
          2 Milliliter,
          2 Milliliter
        },
        Name->{
          "Test tissue culture sample 1 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 2 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 3 (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID
        }
      ];
      testMethod=Upload[<|
        Type -> Object[Method, Extraction, RNA],
        Name -> "Test TotalRNA extraction method SPE purification (for preResolveExtractionSolidPhaseSharedOptions)" <> $SessionUUID,
        DeveloperObject -> True,
        CellType -> Mammalian,
        TargetCellularComponent -> RNA,
        TargetRNA -> TotalRNA,
        Lyse -> True,
        HomogenizeLysate -> True,
        Purification -> {SolidPhaseExtraction},
        SolidPhaseExtractionStrategy->Negative
      |>];
      (* Make all of our samples and models DeveloperObjects, give them their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
      Upload[{
        <|Object -> emptyContainer1, DeveloperObject -> True|>,
        <|Object -> mammalianSample2, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>,
        <|Object -> mammalianSample2, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>,
        <|Object -> mammalianSample3, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>
      }];
    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $EmailEnabled=False
  }
];


(* ::Subsection:: *)
(*solidPhaseExtractionConflictingOptionsChecks*)

DefineTests[
  solidPhaseExtractionConflictingOptionsChecks,
  {
    Example[{Basic, "Given inputs with consistent SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument and gatherTestsQ set to False, returns Nulls in tests, empty invalid options, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
            SolidPhaseExtractionTechnique -> Pressure
          }]
        ];

        solidPhaseExtractionConflictingOptionsChecks[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {{}..}}
    ],

    Example[{Basic, "Given inputs with with consistent SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument and gatherTestsQ set to True, returns empty list of invalid options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
            SolidPhaseExtractionTechnique -> Pressure
          }]
        ];

        solidPhaseExtractionConflictingOptionsChecks[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
          },
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..},{{}..}}
    ],

    Example[{Basic, "Given inputs with conflicting SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::SolidPhaseExtractionTechniqueInstrumentMismatch:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"], (*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
            SolidPhaseExtractionTechnique -> Centrifuge
          }]
        ];

        solidPhaseExtractionConflictingOptionsChecks[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {{SolidPhaseExtractionTechnique, SolidPhaseExtractionInstrument}..}},
      Messages :> {Error::SolidPhaseExtractionTechniqueInstrumentMismatch}
    ],
    Example[{Basic, "Given inputs with conflicting SolidPhaseExtractionTechnique and SolidPhaseExtractionInstrument and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            SolidPhaseExtractionInstrument -> Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"],(*Model[Instrument, PressureManifold, "MPE2 Sterile"]*)
            SolidPhaseExtractionTechnique -> Centrifuge
          }]
        ];

        solidPhaseExtractionConflictingOptionsChecks[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
          },
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {{SolidPhaseExtractionTechnique, SolidPhaseExtractionInstrument}..}}
    ]
  },

  Stubs :> {
    $DeveloperUpload = True,
    $EmailEnabled = False,
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  },

  SymbolSetUp :> (
    Module[{allTestObjects, existsFilter, plate1, sample1, sample2},
      $CreatedObjects = {};
      Off[Warning::SamplesOutOfStock];
      Off[Warning::InstrumentUndergoingMaintenance];
      Off[Warning::DeprecatedProduct];

      allTestObjects = {
        Object[Container, Plate, "Test 96-well plate 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
      };

      existsFilter = DatabaseMemberQ[allTestObjects];

      EraseObject[
        PickList[
          allTestObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ];

      plate1 = Upload[
        <|
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
          Name -> "Test 96-well plate 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID,
          DeveloperObject -> True
        |>
      ];

      {sample1, sample2} = UploadSample[
        {
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
          {{100 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}}
        },
        {
          {"A1", plate1},
          {"A2", plate1}
        },
        Name -> {
          "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Microbial,
          Microbial
        },
        CultureAdhesion -> {
          Suspension,
          Suspension
        },
        Living -> {
          True,
          True
        },
        State -> Liquid,
        FastTrack -> True
      ];
      Upload[<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ {sample1, sample2}];
    ]
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];

    Module[{allTestObjects, existsFilter},
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allTestObjects = Cases[Flatten[{
        Object[Container, Plate, "Test 96-well plate 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for solidPhaseExtractionConflictingOptionsChecks) "<>$SessionUUID]
      }],ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allTestObjects];

      Quiet[EraseObject[
        PickList[
          allTestObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  )
];
