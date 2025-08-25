DefineTests[
  preResolveMagneticBeadSeparationSharedOptions,
  {
    Example[
      {Basic,"Base case test pre-resolving magnetic bead separation shared options with no user input or specification:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {Purification->{MagneticBeadSeparation}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        preResolveMagneticBeadSeparationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID]
          },
          {Custom,Custom},
          $MBSPurificationOptionMap,
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent -> {TotalProtein,TotalProtein}
        ]
      ],
      {_Rule..}
    ],
    Example[
      {Basic,"Base case test preresolve magnetic bead separation shared options with user input and method specified fields:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {Purification->{MagneticBeadSeparation},
            Method->Object[Method, Extraction, Protein, "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)"<>$SessionUUID],
            MagneticBeadVolume -> 20 Microliter}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        preResolveMagneticBeadSeparationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID]
          },
          {
            Object[Method, Extraction, Protein, "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)"<>$SessionUUID],
            Object[Method, Extraction, Protein, "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)"<>$SessionUUID]
          },
          $MBSPurificationOptionMap,
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent -> {TotalProtein,TotalProtein}
        ]
      ],
      KeyValuePattern[{
        MagneticBeadSeparationSelectionStrategy -> ListableP[Negative], (*Specified by test method*)
        MagneticBeadVolume -> ListableP[EqualP[20 Microliter]](*Specified by user*)
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
        Object[Container,Plate,"Test mammalian plate 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
        Object[Method, Extraction, Protein, "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)"<>$SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID],
            Object[Method, Extraction, Protein, "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)"<>$SessionUUID]
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
            Name->"Test mammalian plate 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 2 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 3 (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID
        }
      ];
      testMethod=Upload[<|
        Type -> Object[Method, Extraction, Protein],
        Name -> "Test TotalProtein extraction method MBS purification (for preResolveMagneticBeadSeparationSharedOptions)" <> $SessionUUID,
        DeveloperObject -> True,
        CellType -> Mammalian,
        TargetCellularComponent -> TotalProtein,
        TargetProtein -> All,
        Lyse -> True,
        Purification -> {MagneticBeadSeparation},
        MagneticBeadSeparationSelectionStrategy->Negative
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
(*mbsMethodsConflictingOptionsTests*)

DefineTests[
  mbsMethodsConflictingOptionsTests,
  {
    Example[{Basic, "Given inputs with consistent MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode and gatherTestsQ set to False, returns Nulls in tests, empty invalid options, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Method-> Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]}]
        ];

        mbsMethodsConflictingOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {}}
    ],

    Example[{Basic, "Given inputs with with consistent MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode and gatherTestsQ set to True, returns empty list of invalid options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            Method-> Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
          }]
        ];

        mbsMethodsConflictingOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
          },
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..},{}}
    ],

    Example[{Basic, "Given inputs with MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode conflicting from method and user input and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::InvalidExtractionMethod:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            MagneticBeadSeparationSelectionStrategy ->Negative,
            MagneticBeadSeparationMode -> NormalPhase,
            Method-> Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]}]
        ];

        mbsMethodsConflictingOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Method..}},
      Messages :> {Error::ConflictingMagneticBeadSeparationMethods}
    ],
    Example[{Basic, "Given inputs with MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode conflicting from method and user input and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {
            MagneticBeadSeparationSelectionStrategy ->Negative,
            MagneticBeadSeparationMode -> NormalPhase,
            Method-> Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]}]
        ];

        mbsMethodsConflictingOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
          },
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {Method..}}
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
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
          Name -> "Test 96-well plate 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID,
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
          "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID
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
      (*Upload valid and invalid methods*)
      Upload[
        <|
          Type -> Object[Method, Extraction, Protein],
          Name -> "mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID,
          DeveloperObject->True,
          Lyse -> False,
          TargetProtein -> All,
          Purification -> {MagneticBeadSeparation},
          MagneticBeadSeparationSelectionStrategy -> Positive,
          MagneticBeadSeparationMode -> IonExchange,
          MagneticBeads -> Link[Model[Sample, "Pierce Ni-NTA Magnetic Agarose Beads"]]
        |>
      ];
    ]
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];

    Module[{allTestObjects, existsFilter},
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allTestObjects = Cases[Flatten[{
        Object[Container, Plate, "Test 96-well plate 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID],
        Object[Method,Extraction,Protein,"mbs method (Test for mbsMethodsConflictingOptionsTests) "<>$SessionUUID]
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