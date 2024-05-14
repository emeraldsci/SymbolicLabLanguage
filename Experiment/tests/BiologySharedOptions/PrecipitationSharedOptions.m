DefineTests[
  preResolvePrecipitationSharedOptions,
  {
    Example[
      {Basic,"Base case test pre-resolving precipitation shared options with no user input or specification:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {Purification->{Precipitation}}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        preResolvePrecipitationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID]
          },
          {Custom,Custom},
          $PrecipitationSharedOptionMap,
          expandedOptions,
          mapThreadOptions
        ]
      ],
      {_Rule..}
    ],
    Example[
      {Basic,"Base case test preresolve precipitation shared options with user input and method specified fields:"},
      Module[{expandedInputs, expandedOptions, mapThreadOptions},
        (* Get the default optinos to ExperimentExtractPlasmidDNA, which uses the lysis shared options. *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID], Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID]}
          },
          SafeOptions[ExperimentExtractRNA, {Purification->{Precipitation},
            Method->Object[Method, Extraction, RNA, "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)"<>$SessionUUID],
            PrecipitationReagentVolume -> 50 Microliter}]
        ];

        (* Get map thread options version. *)
        mapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentExtractRNA, expandedOptions];

        preResolvePrecipitationSharedOptions[
          {
            Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID]
          },
          {
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)"<>$SessionUUID],
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)"<>$SessionUUID]
          },
          $PrecipitationSharedOptionMap,
          expandedOptions,
          mapThreadOptions
        ]
      ],
      KeyValuePattern[{
        PrecipitationSeparationTechnique -> ListableP[Filter], (*Specified by test method*)
        PrecipitationReagentVolume -> ListableP[EqualP[50 Microliter]](*Specified by user*)
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
        Object[Container,Plate,"Test mammalian plate 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample 3 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
        Object[Method, Extraction, RNA, "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)"<>$SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Plate,"Test mammalian plate 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Container,Plate,"Test mammalian plate 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample 3 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID],
            Object[Method, Extraction, RNA, "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)"<>$SessionUUID]
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
            Name->"Test mammalian plate 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID,
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "id:eGakld01zzLx"],Objects],
            Name->"Test mammalian plate 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID,
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
          "Test tissue culture sample 1 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 2 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID,
          "Test tissue culture sample 3 (for preResolvePrecipitationSharedOptions)" <> $SessionUUID
        }
      ];
      testMethod=Upload[<|
        Type -> Object[Method, Extraction, RNA],
        Name -> "Test TotalRNA extraction method precipitation purification (for preResolvePrecipitationSharedOptions)" <> $SessionUUID,
        DeveloperObject -> True,
        CellType -> Mammalian,
        TargetCellularComponent -> RNA,
        TargetRNA -> TotalRNA,
        Lyse -> True,
        HomogenizeLysate -> True,
        Purification -> {Precipitation},
        PrecipitationSeparationTechnique->Filter
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

