DefineTests[
  preResolvePurificationSharedOptions,
  {
    Example[
      {Basic,"Base case test where no purification is turned on:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        preResolvePurificationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID]
          },
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent->{PlasmidDNA,PlasmidDNA},
          Output->Result
        ]
      ],
      {}
    ],
    Example[
      {Basic,"Test turning on all purification steps:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification -> {SolidPhaseExtraction, MagneticBeadSeparation, LiquidLiquidExtraction, Precipitation}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        preResolvePurificationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID]
          },
          expandedOptions,
          mapThreadOptions,
          TargetCellularComponent->{PlasmidDNA,PlasmidDNA},
          Output->Result
        ]
      ],
      {_Rule..}
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{
      existsFilter,emptyContainer1,emptyContainer2,mammalianSample1,mammalianSample2,mammalianSample3
    },
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[{
        Object[Container,Plate,"Test mammalian plate 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for preResolvePurificationSharedOptions)" <> $SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for preResolvePurificationSharedOptions)" <> $SessionUUID]
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
            Name->"Test mammalian plate 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for preResolvePurificationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 2 (for preResolvePurificationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 3 (for preResolvePurificationSharedOptions)" <> $SessionUUID
        }
      ];

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


DefineTests[
  checkPurificationConflictingOptions,
  {
    Example[{Basic, "Given inputs with no conflicting purification options and messagesQ set to True, returns empty list of options, Null test, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},PrecipitationTemperature->{Null,Ambient}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{},Null}
    ],

    Example[{Basic, "Given inputs with no conflicting purification options and messagesQ set to False, returns empty list of options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},PrecipitationTemperature->{Null,Ambient}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with conflicting precipitation options and messagesQ set to True, returns list of conflicting options, Null test, and Error::PrecipitationConflictingOptions:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,MagneticBeadSeparation},PrecipitationTemperature->{Null,Ambient}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{PrecipitationTemperature}, Null},
      Messages :> {Error::PrecipitationConflictingOptions}
    ],

    Example[{Basic, "Given inputs with conflicting precipitation options and messagesQ set to False, returns list of conflicting options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,MagneticBeadSeparation},PrecipitationTemperature->{Null,Ambient}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{PrecipitationTemperature}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with conflicting magnetic bead separation options and messagesQ set to True, returns list of conflicting options, Null test, and Error::MagneticBeadSeparationConflictingOptions:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation}, MagneticBeadSeparationPreWashMixTime->{Null,1 Minute}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{MagneticBeadSeparationPreWashMixTime}, Null},
      Messages :> {Error::MagneticBeadSeparationConflictingOptions}
    ],

    Example[{Basic, "Given inputs with conflicting magnetic bead separation options and messagesQ set to False, returns list of conflicting options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},MagneticBeadSeparationPreWashMixTime->{Null,1Minute}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{MagneticBeadSeparationPreWashMixTime}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with conflicting solid phase extraction options and messagesQ set to True, returns list of conflicting options, Null test, and Error::SolidPhaseExtractionConflictingOptions:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation}, SolidPhaseExtractionLoadingSampleVolume->{Null,50Microliter}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{SolidPhaseExtractionLoadingSampleVolume}, Null},
      Messages :> {Error::SolidPhaseExtractionConflictingOptions}
    ],

    Example[{Basic, "Given inputs with conflicting solid phase extraction options and messagesQ set to False, returns list of conflicting options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},SolidPhaseExtractionLoadingSampleVolume->{Null,50Microliter}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{SolidPhaseExtractionLoadingSampleVolume}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with conflicting liquid-liquid extraction options and messagesQ set to True, returns list of conflicting options, Null test, and Error::LiquidLiquidExtractionConflictingOptions:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the purification shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation}, LiquidLiquidExtractionTargetPhase->{Null,Aqueous}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{LiquidLiquidExtractionTargetPhase}, Null},
      Messages :> {Error::LiquidLiquidExtractionConflictingOptions}
    ],

    Example[{Basic, "Given inputs with conflicting liquid-liquid extraction options and messagesQ set to False, returns list of conflicting options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},LiquidLiquidExtractionTargetPhase->{Null,Aqueous}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{LiquidLiquidExtractionTargetPhase}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with multiple categories of conflicting purification options and messagesQ set to False, returns list of conflicting options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},LiquidLiquidExtractionTargetPhase->{Null,Aqueous},MagneticBeadSeparationPreWashMixTime->{1Minute,Null},PrecipitationTemperature->{Null,Ambient},PrecipitationTime->{30Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          False
        ]
      ],
      {{PrecipitationTime,MagneticBeadSeparationPreWashMixTime,LiquidLiquidExtractionTargetPhase}, {TestP..}}
    ],

    Example[{Basic, "Given inputs with multiple categories of conflicting purification options and messagesQ set to True, returns list of conflicting options, Null test, and appropriate error messages:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions, mapThreadOptionsWithNulls},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{None,Precipitation},LiquidLiquidExtractionTargetPhase->{Null,Aqueous},MagneticBeadSeparationPreWashMixTime->{1Minute,Null},PrecipitationTemperature->{Null,Ambient},PrecipitationTime->{30Minute,Null}}]
        ];

        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        (* Replace the Automatic option settings with Null *)
        mapThreadOptionsWithNulls = mapThreadOptions/.{Automatic->Null};

        checkPurificationConflictingOptions[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
          },
          mapThreadOptionsWithNulls,
          True
        ]
      ],
      {{PrecipitationTime,MagneticBeadSeparationPreWashMixTime,LiquidLiquidExtractionTargetPhase}, Null},
      Messages :> {Error::PrecipitationConflictingOptions,Error::MagneticBeadSeparationConflictingOptions,Error::LiquidLiquidExtractionConflictingOptions}
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
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
          Name -> "Test 96-well plate 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID,
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
          "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Bacterial,
          Bacterial
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for checkPurificationConflictingOptions) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for checkPurificationConflictingOptions) "<>$SessionUUID]
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

DefineTests[
  buildPurificationUnitOperations,
  {
    Example[
      {Basic,"Base case test where no purification is turned on:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractRNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        buildPurificationUnitOperations[
          {
            Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID]
          },
          expandedOptions,
          mapThreadOptions,
          ExtractedRNAContainerLabel,
          ExtractedRNALabel
        ]
      ],
      {ListableP[(_String) | ObjectP[]],{}} (* returns working samples with no unit operations built *)
    ],
    Example[
      {Basic,"Test turning on all purification steps:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {Purification -> {SolidPhaseExtraction, MagneticBeadSeparation, LiquidLiquidExtraction, Precipitation}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        buildPurificationUnitOperations[
          {
            Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID]
          },
          expandedOptions,
          mapThreadOptions,
          ExtractedRNAContainerLabel,
          ExtractedRNALabel
        ]
      ],
      {ListableP[(_String) | ObjectP[]],
        {Alternatives[_SolidPhaseExtraction, _MagneticBeadSeparation, _LiquidLiquidExtraction, _Precipitate] ..}}
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{
      existsFilter,emptyContainer1,emptyContainer2,mammalianSample1,mammalianSample2,mammalianSample3
    },
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[{
        Object[Container,Plate,"Test mammalian plate 1 (for buildPurificationUnitOperations)"<> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for buildPurificationUnitOperations)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for buildPurificationUnitOperations)" <> $SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for buildPurificationUnitOperations)" <> $SessionUUID]
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
            Name->"Test mammalian plate 1 (for buildPurificationUnitOperations)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for buildPurificationUnitOperations)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for buildPurificationUnitOperations)" <> $SessionUUID,
          "Test tissue culture sample 2 (for buildPurificationUnitOperations)" <> $SessionUUID,
          "Test tissue culture sample 3 (for buildPurificationUnitOperations)" <> $SessionUUID
        }
      ];

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
    $EmailEnabled=False,
    $DeveloperUpload=True
  }
];


DefineTests[
  purificationSharedOptionsTests,
  {
    Example[{Basic, "Given inputs with no Purification specified with step count greater than 3 and gatherTestsQ set to False, returns Nulls in tests, empty invalid options, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {SolidPhaseExtraction, MagneticBeadSeparation, LiquidLiquidExtraction, Precipitation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {}}
    ],

    Example[{Basic, "Given inputs with no Purification specified with step count greater than 3 and gatherTestsQ set to True, returns empty list of invalid options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {SolidPhaseExtraction, MagneticBeadSeparation, LiquidLiquidExtraction, Precipitation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..},{}}
    ],

    Example[{Basic, "Given inputs with Purification specified with more than 3 SolidPhaseExtraction steps and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::SolidPhaseExtractionStepCountLimitExceeded:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Purification..}},
      Messages :> {Error::SolidPhaseExtractionStepCountLimitExceeded}
    ],
    Example[{Basic, "Given inputs with Purification specified with more than 3 SolidPhaseExtraction steps and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {Purification..}}
    ],

    Example[{Basic, "Given inputs with Purification specified with more than 3 LiquidLiquidExtraction steps and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::LiquidLiquidExtractionStepCountLimitExceeded:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Purification..}},
      Messages :> {Error::LiquidLiquidExtractionStepCountLimitExceeded}
    ],
    Example[{Basic, "Given inputs with Purification specified with more than 3 LiquidLiquidExtraction steps and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {Purification..}}
    ],

    Example[{Basic, "Given inputs with Purification specified with more than 3 MagneticBeadSeparation steps and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::MagneticBeadSeparationStepCountLimitExceeded:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Purification..}},
      Messages :> {Error::MagneticBeadSeparationStepCountLimitExceeded}
    ],
    Example[{Basic, "Given inputs with Purification specified with more than 3 MagneticBeadSeparation steps and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {Purification..}}
    ],
    Example[{Basic, "Given inputs with Purification specified with more than 3 Precipitation steps and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::PrecipitationStepCountLimitExceeded:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {Precipitation, Precipitation, Precipitation, Precipitation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Purification..}},
      Messages :> {Error::PrecipitationStepCountLimitExceeded}
    ],
    Example[{Basic, "Given inputs with Purification specified with more than 3 Precipitation steps and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, {Purification -> {Precipitation, Precipitation, Precipitation, Precipitation}}]
        ];

        purificationSharedOptionsTests[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },
          Download[{
            Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
          },All],
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..}, {Purification..}}
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
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
          Name -> "Test 96-well plate 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID,
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
          "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Bacterial,
          Bacterial
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for purificationSharedOptionsTests) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for purificationSharedOptionsTests) "<>$SessionUUID]
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



DefineTests[
  optionsFromUnitOperation,
  {
    Example[{Basic, "Returns fully resolved options for used unit operations, and Nulls for unused unit operations:"},
      Module[{myPrimitives,myUnitOperationPackets,expandedInputs, expandedOptions,mapThreadOptions,output},
        myPrimitives = {
          LabelSample[
          Label -> {"RCP SampleIn 1","RCP SampleIn 2"},
          Sample -> {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID]}
          ],
          LyseCells[
            Sample -> {"RCP SampleIn 1","RCP SampleIn 2"},
            NumberOfLysisSteps -> 1
          ]
        };
        myUnitOperationPackets = First[
          ExperimentRoboticCellPreparation[
            myPrimitives,
            UnitOperationPackets -> True,
            Output -> Result,
            Upload -> False,
            CoverAtEnd -> False
        ]];
        (* fake a preResolved options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractProtein, { NumberOfLysisSteps -> 1, Purification -> None}]
        ];
        (* Get the map thread friendly version of the options *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        optionsFromUnitOperation[
          myUnitOperationPackets,
          {
            Object[UnitOperation, LyseCells],
            Object[UnitOperation, LiquidLiquidExtraction],
            Object[UnitOperation, SolidPhaseExtraction],
            Object[UnitOperation, Precipitate],
            Object[UnitOperation, MagneticBeadSeparation]
          },
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID]
          },
          {
            {Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) " <> $SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) " <> $SessionUUID]},
            {},{},{},{}
          },
          expandedOptions,
          mapThreadOptions,
          {
            Normal[KeyDrop[$LyseCellsSharedOptionsMap, {Method, RoboticInstrument, SampleOutLabel}], Association],
            $LLEPurificationOptionMap,
            $SPEPurificationOptionMap,
            $PrecipitationSharedOptionMap,
            $MBSPurificationOptionMap
          },
          {True,False,False,False,False}
        ]
      ],
      (*Returned options has LyseCells fully resolved, and unused unit operations has Automatic populated with Nulls*)
      {(*LyseCells*)
        KeyValuePattern[{CellType -> Bacterial,LysisMixType -> Shake}],
        (*LLE*)
        KeyValuePattern[{LiquidLiquidExtractionTechnique -> ListableP[Null],LiquidLiquidExtractionTargetLayer -> ListableP[Null]}],
        (*SPE*)
        KeyValuePattern[{SolidPhaseExtractionLoadingSampleVolume -> ListableP[Null],SolidPhaseExtractionCartridge -> ListableP[Null]}],
        (*Precipitation*)
        KeyValuePattern[{PrecipitationTargetPhase -> ListableP[Null],PrecipitationReagent -> ListableP[Null]}],
        (*MBS*)
        KeyValuePattern[{MagneticBeads -> ListableP[Null],MagneticBeadSeparationSampleVolume -> ListableP[Null]}]
      }
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID]
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
          Name -> "Test 96-well plate 1 (Test for optionsFromUnitOperation) "<>$SessionUUID,
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
          "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID
        },
        InitialAmount -> {
          0.5 Milliliter,
          0.5 Milliliter
        },
        CellType -> {
          Bacterial,
          Bacterial
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for optionsFromUnitOperation) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for optionsFromUnitOperation) "<>$SessionUUID]
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

DefineTests[
  resolvePurification,
  {
    Example[
      {Basic,"Base case test where no purification or option of specific step is specified by user or method:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractProtein, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {Method->Custom}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        resolvePurification[
          mapThreadOptions,
          Lookup[mapThreadOptions,Method]
        ]
      ],
      {{LiquidLiquidExtraction, Precipitation}..} (* returns default *)
    ],
    Example[
      {Basic,"Return the Purification specified by the user:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractProtein, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {Purification-> {Precipitation,SolidPhaseExtraction}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        resolvePurification[
          mapThreadOptions,
          {Custom,Custom}
        ]
      ],
      {{Precipitation,SolidPhaseExtraction}..}
    ],
    Example[
      {Basic,"If options of any purification step is specified by the user, that step is turned on:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractProtein, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {PrecipitationTargetPhase->Solid}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        resolvePurification[
          mapThreadOptions,
          {Custom,Custom}
        ]
      ],
      {{Precipitation}..}
    ],
    Example[
      {Basic,"Return the Purification specified by the method:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default options to ExperimentExtractProtein, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractProtein,
          {
            {Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
              Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractProtein, {Method->Object[Method,Extraction,Protein,"Method with specified Purification (Test for resolvePurification) "<> $SessionUUID]}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractProtein, expandedOptions];

        resolvePurification[
          mapThreadOptions,
          Lookup[mapThreadOptions,Method]
        ]
      ],
      {{SolidPhaseExtraction,LiquidLiquidExtraction}..}
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{
      existsFilter,emptyContainer1,emptyContainer2,mammalianSample1,mammalianSample2,mammalianSample3
    },
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[{
        Object[Container,Plate,"Test mammalian plate 1 (for resolvePurification)"<> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for resolvePurification)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for resolvePurification)" <> $SessionUUID],
        Object[Method,Extraction,Protein,"Method with specified Purification (Test for resolvePurification) "<> $SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for resolvePurification)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for resolvePurification)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for resolvePurification)" <> $SessionUUID],
            Object[Method,Extraction,Protein,"Method with specified Purification (Test for resolvePurification) "<> $SessionUUID]
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
            Name->"Test mammalian plate 1 (for resolvePurification)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for resolvePurification)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for resolvePurification)" <> $SessionUUID,
          "Test tissue culture sample 2 (for resolvePurification)" <> $SessionUUID,
          "Test tissue culture sample 3 (for resolvePurification)" <> $SessionUUID
        }
      ];

      (* Make all of our samples and models DeveloperObjects, give them their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
      Upload[{
        <|Object -> emptyContainer1, DeveloperObject -> True|>,
        <|Object -> mammalianSample2, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>,
        <|Object -> mammalianSample2, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>,
        <|Object -> mammalianSample3, CellType->Mammalian, CultureAdhesion->Adherent, DeveloperObject -> True|>
      }];
      Upload[
        <|
          Type -> Object[Method, Extraction, Protein],
          Name -> "Method with specified Purification (Test for resolvePurification) "<>$SessionUUID,
          DeveloperObject -> True,
          CellType -> Mammalian,
          DeveloperObject -> True,
          CellType -> Null,
          TargetProtein -> All,
          Lyse -> False,
          Purification ->{SolidPhaseExtraction,LiquidLiquidExtraction}
        |>
      ];
    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $EmailEnabled=False,
    $DeveloperUpload=True
  }
];

