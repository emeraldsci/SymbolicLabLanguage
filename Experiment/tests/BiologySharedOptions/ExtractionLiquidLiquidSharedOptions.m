DefineTests[
  preResolveLiquidLiquidExtractionSharedOptions,
  {
    Example[
      {Basic,"Base case test pre-resolving liquid liquid extraction shared options with no user input or specification:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{LiquidLiquidExtraction}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        preResolveLiquidLiquidExtractionSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID]
          },
          {Custom,Custom},
          $LLEPurificationOptionMap,
          expandedOptions,
          mapThreadOptions
        ]
      ],
      {_Rule..}
    ],
    Example[
      {Basic,"Base case test preresolve liquid liquid extraction shared options with user input and method specified fields:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractPlasmidDNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractPlasmidDNA, {Purification->{LiquidLiquidExtraction},
            Method->Object[Method, Extraction, PlasmidDNA, "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)"<>$SessionUUID],
            LiquidLiquidExtractionTechnique -> Pipette}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractPlasmidDNA, expandedOptions];

        preResolveLiquidLiquidExtractionSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID]
          },
          {
            Object[Method, Extraction, PlasmidDNA, "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)"<>$SessionUUID],
            Object[Method, Extraction, PlasmidDNA, "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)"<>$SessionUUID]
          },
          $LLEPurificationOptionMap,
          expandedOptions,
          mapThreadOptions
        ]
      ],
      KeyValuePattern[{
        NumberOfLiquidLiquidExtractions -> ListableP[2], (*Specified by test method*)
        LiquidLiquidExtractionTechnique -> ListableP[Pipette](*Specified by user*)
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
        Object[Container,Plate,"Test mammalian plate 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
        Object[Method, Extraction, PlasmidDNA, "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)"<>$SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID],
            Object[Method, Extraction, PlasmidDNA, "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)"<>$SessionUUID]
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
            Name->"Test mammalian plate 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 2 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 3 (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID
        }
      ];
      testMethod=Upload[<|
        Type -> Object[Method, Extraction, PlasmidDNA],
        Name -> "Test PlasmidDNA extraction method LLE purification (for preResolveLiquidLiquidExtractionSharedOptions)" <> $SessionUUID,
        DeveloperObject -> True,
        CellType -> Mammalian,
        TargetCellularComponent -> PlasmidDNA,
        Lyse -> True,
        Neutralize -> True,
        Purification -> {LiquidLiquidExtraction},
        NumberOfLiquidLiquidExtractions -> 2
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

