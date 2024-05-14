(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*preResolveExtractMixOptions*)

DefineTests[
  preResolveExtractMixOptions,
  {

    (*Basic Tests*)

    Example[
      {Basic,"Given an option list (association), a method packet (if specified), a step boolean, and a option name map, will return a pre-resolved set of mix options:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> 5,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM,
        DefaultNumberOfMixes -> 10,
        DefaultMixVolume -> 5 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 5 Microliter,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Null
        }
      ]
    ],

    Example[
      {Basic,"If no options are specified in the option list and no default options are set, then resolves all mix options to automatic (pre-resolved to be resolved elsewhere):"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        }
      ],
      KeyValuePattern[
        {
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        }
      ]
    ],

    Example[
      {Basic,"If some mix options are set, then resolves required options (first based off of set option(s), then default if no other indicators) and resolves non-needed options to Null:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> 300 RPM,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixType -> Pipette,
        DefaultMixTemperature -> Ambient,
        DefaultMixVolume -> 10 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Shake,
          TestMixRate -> 300 RPM,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Null,
          TestMixVolume -> Null,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> ObjectP[Model[Instrument, Shaker, "Inheco ThermoshakeAC"]]
        }
      ]
    ],

    Example[
      {Basic,"If mix options are already set in the option list (not Automatic), then those are used as the mix options:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 1 Milliliter,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> Null
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM,
        DefaultNumberOfMixes -> 10,
        DefaultMixVolume -> 5 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 1 Milliliter,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> Null
        }
      ]
    ],

    Example[
      {Basic,"If a method is specified, then those options will be used (if the option is set to Automatic in the option list):"},
      preResolveExtractMixOptions[
        <|
          PrecipitationMixType -> Automatic,
          PrecipitationMixRate -> Automatic,
          PrecipitationMixTime -> Automatic,
          NumberOfPrecipitationMixes -> Automatic,
          PrecipitationMixVolume -> Automatic,
          PrecipitationMixTemperature -> Automatic,
          PrecipitationMixInstrument -> Automatic
        |>,
        Download[Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]],
        False,
        {
          MixType -> PrecipitationMixType,
          MixRate -> PrecipitationMixRate,
          MixTime -> PrecipitationMixTime,
          NumberOfMixes -> NumberOfPrecipitationMixes,
          MixVolume -> PrecipitationMixVolume,
          MixTemperature -> PrecipitationMixTemperature,
          MixInstrument -> PrecipitationMixInstrument
        }
      ],
      KeyValuePattern[
        {
          PrecipitationMixType -> Shake,
          PrecipitationMixRate -> EqualP[300 RPM],
          PrecipitationMixTemperature -> EqualP[25 Celsius],
          PrecipitationMixTime -> EqualP[5 Minute]
        }
      ]
    ],

    Example[
      {Basic,"If the step boolean is False, then mix options are set to Null (if not already set by the method or the user):"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        False,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        }
      ],
      KeyValuePattern[
        {
          TestMixType -> Null,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> Null,
          TestMixVolume -> Null,
          TestMixTemperature -> Null,
          TestMixInstrument -> Null
        }
      ]
    ],

    (*Option Tests*)

    Example[
      {Options, DefaultMixType, "If no other options are set indicating the mix type (Automatic in option list, no method, and no other mix options set), then the DefaultMixType will be used for the MixType:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixType -> Shake
      ],
      KeyValuePattern[
        {
          TestMixType -> Shake
        }
      ]
    ],

    Example[
      {Options, DefaultMixRate, "If shaking is required and there is not a set MixRate (Automatic in option list and no method), then the DefaultMixRate will be used for the MixRate:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM
      ],
      KeyValuePattern[
        {
          TestMixRate -> EqualP[300 RPM]
        }
      ]
    ],

    Example[
      {Options, DefaultMixTime, "If shaking is required and there is not a set MixTime (Automatic in option list and no method), then the DefaultMixTime will be used for the MixTime:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixTime -> 1 Minute
      ],
      KeyValuePattern[
        {
          TestMixTime -> EqualP[1 Minute]
        }
      ]
    ],

    Example[
      {Options, DefaultNumberOfMixes, "If pipetting is required and there is not a set NumberOfMixes (Automatic in option list and no method), then the DefaultNumberOfMixes will be used for the NumberOfMixes:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultNumberOfMixes -> 10
      ],
      KeyValuePattern[
        {
          NumberOfTestMixes -> 10
        }
      ]
    ],

    Example[
      {Options, DefaultMixVolume, "If pipetting is required and there is not a set MixVolume (Automatic in option list and no method), then the DefaultMixVolume will be used for the MixVolume:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixVolume -> 10 Microliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[10 Microliter]
        }
      ]
    ],

    Example[
      {Options, DefaultMixTemperature, "If mixing is required (Shake or Pipette) and there is not a set MixTemperature (Automatic in option list and no method), then the DefaultMixTemperature will be used for the MixTemperature:"},
      preResolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixTemperature -> Ambient
      ],
      KeyValuePattern[
        {
          TestMixTemperature -> Ambient
        }
      ]
    ]

  },
  SymbolSetUp :> Module[{method0, existsFilter},
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    (*TODO::Replace with UploadMethod (any analyte) to simplify, but make sure to set mix options as wanted.*)
    {method0} = Upload[
      {
        <|
          Type -> Object[Method, Extraction, PlasmidDNA],
          Name -> "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID,
          Lyse -> True,
          CellType -> Bacterial,
          Append[TargetCellularComponent] -> PlasmidDNA,
          NumberOfLysisSteps -> 1,
          PreLysisPellet -> True,
          PreLysisPelletingIntensity -> 4000 GravitationalAcceleration,
          PreLysisPelletingTime -> 2 Minute,
          LysisSolution -> Link[Model[Sample,StockSolution,"RNase A\[Dash]containing resuspension buffer (Cold Spring Harbor)"]],
          LysisMixType -> None,
          LysisMixTime -> 0 Minute,
          LysisMixTemperature -> 25 Celsius,
          SecondaryLysisSolution -> Link[Model[Sample,StockSolution,"Lysis-denaturing solution (Cold Spring Harbor)"]],
          SecondaryLysisMixType -> Shake,
          SecondaryLysisMixRate -> 100 RPM,
          SecondaryLysisMixTime -> 4 Minute,
          SecondaryLysisMixTemperature -> 25 Celsius,
          ClarifyLysate -> False,
          Neutralize -> True,
          NeutralizationReagent -> Link[Model[Sample,StockSolution,"3M Sodium Acetate"]],
          NeutralizationSeparationTechnique -> Pellet,
          NeutralizationReagentTemperature -> 25 Celsius,
          NeutralizationReagentEquilibrationTime -> 1 Minute,
          NeutralizationMixType -> None,
          NeutralizationSettlingTemperature -> 0 Celsius,
          NeutralizationSettlingTime -> 10 Minute,
          NeutralizationPelletCentrifugeIntensity -> 4000 GravitationalAcceleration,
          NeutralizationPelletCentrifugeTime -> 10 Minute,
          Purification -> {Precipitation, LiquidLiquidExtraction, Precipitation},
          PrecipitationTargetPhase -> Solid,
          PrecipitationSeparationTechnique -> Pellet,
          PrecipitationReagent -> Link[Model[Sample,StockSolution,"95% Ethanol"]],
          PrecipitationReagentTemperature -> 25 Celsius,
          PrecipitationReagentEquilibrationTime -> 1 Minute,
          PrecipitationMixType -> Shake,
          PrecipitationMixRate -> 300 RPM,
          PrecipitationMixTemperature -> 25 Celsius,
          PrecipitationMixTime -> 5 Minute,
          PrecipitationTime -> 2 Hour,
          PrecipitationTemperature -> -20 Celsius,
          PrecipitationPelletCentrifugeIntensity -> 4000 GravitationalAcceleration,
          PrecipitationPelletCentrifugeTime -> 10 Minute,
          PrecipitationNumberOfWashes -> 0,
          PrecipitationDryingTime -> 5 Minute,
          PrecipitationDryingTemperature -> 25 Celsius,
          PrecipitationResuspensionBuffer -> Link[Model[Sample, StockSolution, "TE8 Buffer (Cold Spring Harbor)"]],
          PrecipitationResuspensionBufferTemperature -> 25 Celsius,
          PrecipitationResuspensionBufferEquilibrationTime -> 1 Minute,
          PrecipitationResuspensionMixType -> Pipette,
          PrecipitationNumberOfResuspensionMixes -> 10,
          LiquidLiquidExtractionTechnique -> Pipette,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionTargetLayer -> {Top, Top, Top},
          OrganicSolvent -> Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],
          OrganicSolventRatio -> 1,
          Append[LiquidLiquidExtractionSolventAdditions] -> {Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]},
          Append[DemulsifierAdditions] -> {Null, Null, Null},
          LiquidLiquidExtractionTemperature -> 25 Celsius,
          NumberOfLiquidLiquidExtractions -> 3,
          LiquidLiquidExtractionMixType -> Shake,
          LiquidLiquidExtractionMixTime -> 30 Second,
          LiquidLiquidExtractionMixRate -> 500 RPM,
          LiquidLiquidExtractionSettlingTime -> 1 Minute,
          LiquidLiquidExtractionCentrifuge -> True,
          LiquidLiquidExtractionCentrifugeTime -> 1 Minute,
          LiquidLiquidExtractionCentrifugeIntensity -> 4000 GravitationalAcceleration
        |>
      }
    ];


  ],
  SymbolTearDown :> Module[
    {allObjects, existsFilter},

    (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
    allObjects= Cases[Flatten[{
      Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
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
  ],
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $EmailEnabled=False
  }
]


(* ::Subsection:: *)
(*resolveExtractMixOptions*)

DefineTests[
  resolveExtractMixOptions,
  {

    (*Basic Tests*)

    Example[
      {Basic,"Given an option list (association), a method packet (if specified), a step boolean, and a option name map, will return a pre-resolved set of mix options:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> 5,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM,
        DefaultNumberOfMixes -> 10,
        DefaultMixVolume -> 5 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 5 Microliter,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> Null
        }
      ]
    ],

    Example[
      {Basic,"If no options are specified in the option list and no default options are set, then resolves all mix options to defaults:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        }
      ],
      KeyValuePattern[
        {
          TestMixType -> Shake,
          TestMixRate -> EqualP[300 RPM],
          TestMixTime -> EqualP[30 Second],
          NumberOfTestMixes -> Null,
          TestMixVolume -> Null,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> ObjectP[Model[Instrument, Shaker, "Inheco ThermoshakeAC"]]
        }
      ]
    ],

    Example[
      {Basic,"If some mix options are set, then resolves required options (first based off of set option(s), then default if no other indicators) and resolves non-needed options to Null:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> 500 RPM,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixType -> Pipette,
        DefaultMixVolume -> 10 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Shake,
          TestMixRate -> EqualP[500 RPM],
          TestMixTime -> EqualP[30 Second],
          NumberOfTestMixes -> Null,
          TestMixVolume -> Null,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> ObjectP[Model[Instrument, Shaker, "Inheco ThermoshakeAC"]]
        }
      ]
    ],

    Example[
      {Basic,"If mix options are already set in the option list (not Automatic), then those are used as the mix options:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 1 Milliliter,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> Null
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM,
        DefaultNumberOfMixes -> 10,
        DefaultMixVolume -> 5 Microliter
      ],
      KeyValuePattern[
        {
          TestMixType -> Pipette,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> 5,
          TestMixVolume -> 1 Milliliter,
          TestMixTemperature -> Ambient,
          TestMixInstrument -> Null
        }
      ]
    ],

    Example[
      {Basic,"If a method is specified, then those options will be used (if the option is set to Automatic in the option list):"},
      resolveExtractMixOptions[
        <|
          PrecipitationMixType -> Automatic,
          PrecipitationMixRate -> Automatic,
          PrecipitationMixTime -> Automatic,
          NumberOfPrecipitationMixes -> Automatic,
          PrecipitationMixVolume -> Automatic,
          PrecipitationMixTemperature -> Automatic,
          PrecipitationMixInstrument -> Automatic
        |>,
        Download[Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]],
        False,
        {
          MixType -> PrecipitationMixType,
          MixRate -> PrecipitationMixRate,
          MixTime -> PrecipitationMixTime,
          NumberOfMixes -> NumberOfPrecipitationMixes,
          MixVolume -> PrecipitationMixVolume,
          MixTemperature -> PrecipitationMixTemperature,
          MixInstrument -> PrecipitationMixInstrument
        }
      ],
      KeyValuePattern[
        {
          PrecipitationMixType -> Shake,
          PrecipitationMixRate -> EqualP[300 RPM],
          PrecipitationMixTemperature -> EqualP[25 Celsius],
          PrecipitationMixTime -> EqualP[5 Minute]
        }
      ]
    ],

    Example[
      {Basic,"If the step boolean is False, then mix options are set to Null (if not already set by the method or the user):"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        False,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        }
      ],
      KeyValuePattern[
        {
          TestMixType -> Null,
          TestMixRate -> Null,
          TestMixTime -> Null,
          NumberOfTestMixes -> Null,
          TestMixVolume -> Null,
          TestMixTemperature -> Null,
          TestMixInstrument -> Null
        }
      ]
    ],

    (*Option Tests*)

    Example[
      {Options, DefaultMixType, "If no other options are set indicating the mix type (Automatic in option list, no method, and no other mix options set), then the DefaultMixType will be used for the MixType:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Automatic,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixType -> Shake
      ],
      KeyValuePattern[
        {
          TestMixType -> Shake
        }
      ]
    ],

    Example[
      {Options, DefaultMixRate, "If shaking is required and there is not a set MixRate (Automatic in option list and no method), then the DefaultMixRate will be used for the MixRate:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixRate -> 300 RPM
      ],
      KeyValuePattern[
        {
          TestMixRate -> EqualP[300 RPM]
        }
      ]
    ],

    Example[
      {Options, DefaultMixTime, "If shaking is required and there is not a set MixTime (Automatic in option list and no method), then the DefaultMixTime will be used for the MixTime:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixTime -> 1 Minute
      ],
      KeyValuePattern[
        {
          TestMixTime -> EqualP[1 Minute]
        }
      ]
    ],

    Example[
      {Options, DefaultNumberOfMixes, "If pipetting is required and there is not a set NumberOfMixes (Automatic in option list and no method), then the DefaultNumberOfMixes will be used for the NumberOfMixes:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultNumberOfMixes -> 10
      ],
      KeyValuePattern[
        {
          NumberOfTestMixes -> 10
        }
      ]
    ],

    Example[
      {Options, DefaultMixVolume, "If pipetting is required and there is not a set MixVolume (Automatic in option list and no method), then the DefaultMixVolume will be used for the MixVolume:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixVolume -> 10 Microliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[10 Microliter]
        }
      ]
    ],

    Example[
      {Options, InputVolume, "If a mix volume is required, no default mix volume is specified, and an input volume is provided, then it will be used to calculate the mix volume:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        InputVolume -> 100 Microliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[50 Microliter]
        }
      ]
    ],

    Example[
      {Options, InputVolume, "If a mix volume is required, a default mix volume is specified, and an input volume is provided, then the default mix volume will be used as the mix volume (input volume only used when there is not already a default mix volume that overrides it):"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixVolume -> 70 Microliter,
        InputVolume -> 200 Microliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[70 Microliter]
        }
      ]
    ],

    Example[
      {Options, InputVolume, "If a mix volume is required, no default mix volume is specified, and 1/2 the input volume is less than 970 microliters (max single pipetting volume), then 1/2 the input volume will be used as the mix volume:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        InputVolume -> 100 Microliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[50 Microliter]
        }
      ]
    ],

    Example[
      {Options, InputVolume, "If a mix volume is required, no default mix volume is specified, and 1/2 the input volume is greater than or equal to 970 microliters (max single pipetting volume), then 970 microliters will be used as the mix volume:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        InputVolume -> 2 Milliliter
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[970 Microliter]
        }
      ]
    ],

    Example[
      {Options, InputVolume, "If a mix volume is required, an input volume is not specified, and there is not a default mix volume, then 0.5 microliters (minimum mixing volume) will be used as the mixing volume:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Pipette,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        }
      ],
      KeyValuePattern[
        {
          TestMixVolume -> EqualP[0.5 Microliter]
        }
      ]
    ],

    Example[
      {Options, DefaultMixTemperature, "If mixing is required (Shake or Pipette) and there is not a set MixTemperature (Automatic in option list and no method), then the DefaultMixTemperature will be used for the MixTemperature:"},
      resolveExtractMixOptions[
        <|
          TestMixType -> Shake,
          TestMixRate -> Automatic,
          TestMixTime -> Automatic,
          NumberOfTestMixes -> Automatic,
          TestMixVolume -> Automatic,
          TestMixTemperature -> Automatic,
          TestMixInstrument -> Automatic
        |>,
        Null,
        True,
        {
          MixType -> TestMixType,
          MixRate -> TestMixRate,
          MixTime -> TestMixTime,
          NumberOfMixes -> NumberOfTestMixes,
          MixVolume -> TestMixVolume,
          MixTemperature -> TestMixTemperature,
          MixInstrument -> TestMixInstrument
        },
        DefaultMixTemperature -> Ambient
      ],
      KeyValuePattern[
        {
          TestMixTemperature -> Ambient
        }
      ]
    ]

  },
  SymbolSetUp :> Module[{method0, existsFilter},
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    (*TODO::Replace with UploadMethod (any analyte) to simplify, but make sure to set mix options as wanted.*)
    {method0} = Upload[
      {
        <|
          Type -> Object[Method, Extraction, PlasmidDNA],
          Name -> "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID,
          Lyse -> True,
          CellType -> Bacterial,
          Append[TargetCellularComponent] -> PlasmidDNA,
          NumberOfLysisSteps -> 1,
          PreLysisPellet -> True,
          PreLysisPelletingIntensity -> 4000 GravitationalAcceleration,
          PreLysisPelletingTime -> 2 Minute,
          LysisSolution -> Link[Model[Sample,StockSolution,"RNase A\[Dash]containing resuspension buffer (Cold Spring Harbor)"]],
          LysisMixType -> None,
          LysisMixTime -> 0 Minute,
          LysisMixTemperature -> 25 Celsius,
          SecondaryLysisSolution -> Link[Model[Sample,StockSolution,"Lysis-denaturing solution (Cold Spring Harbor)"]],
          SecondaryLysisMixType -> Shake,
          SecondaryLysisMixRate -> 100 RPM,
          SecondaryLysisMixTime -> 4 Minute,
          SecondaryLysisMixTemperature -> 25 Celsius,
          ClarifyLysate -> False,
          Neutralize -> True,
          NeutralizationReagent -> Link[Model[Sample,StockSolution,"3M Sodium Acetate"]],
          NeutralizationSeparationTechnique -> Pellet,
          NeutralizationReagentTemperature -> 25 Celsius,
          NeutralizationReagentEquilibrationTime -> 1 Minute,
          NeutralizationMixType -> None,
          NeutralizationSettlingTemperature -> 0 Celsius,
          NeutralizationSettlingTime -> 10 Minute,
          NeutralizationPelletCentrifugeIntensity -> 4000 GravitationalAcceleration,
          NeutralizationPelletCentrifugeTime -> 10 Minute,
          Purification -> {Precipitation, LiquidLiquidExtraction, Precipitation},
          PrecipitationTargetPhase -> Solid,
          PrecipitationSeparationTechnique -> Pellet,
          PrecipitationReagent -> Link[Model[Sample,StockSolution,"95% Ethanol"]],
          PrecipitationReagentTemperature -> 25 Celsius,
          PrecipitationReagentEquilibrationTime -> 1 Minute,
          PrecipitationMixType -> Shake,
          PrecipitationMixRate -> 300 RPM,
          PrecipitationMixTemperature -> 25 Celsius,
          PrecipitationMixTime -> 5 Minute,
          PrecipitationTime -> 2 Hour,
          PrecipitationTemperature -> -20 Celsius,
          PrecipitationPelletCentrifugeIntensity -> 4000 GravitationalAcceleration,
          PrecipitationPelletCentrifugeTime -> 10 Minute,
          PrecipitationNumberOfWashes -> 0,
          PrecipitationDryingTime -> 5 Minute,
          PrecipitationDryingTemperature -> 25 Celsius,
          PrecipitationResuspensionBuffer -> Link[Model[Sample, StockSolution, "TE8 Buffer (Cold Spring Harbor)"]],
          PrecipitationResuspensionBufferTemperature -> 25 Celsius,
          PrecipitationResuspensionBufferEquilibrationTime -> 1 Minute,
          PrecipitationResuspensionMixType -> Pipette,
          PrecipitationNumberOfResuspensionMixes -> 10,
          LiquidLiquidExtractionTechnique -> Pipette,
          LiquidLiquidExtractionSelectionStrategy -> Negative,
          LiquidLiquidExtractionTargetPhase -> Aqueous,
          LiquidLiquidExtractionTargetLayer -> {Top, Top, Top},
          OrganicSolvent -> Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],
          OrganicSolventRatio -> 1,
          Append[LiquidLiquidExtractionSolventAdditions] -> {Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]],Link[Model[Sample,"Phenol: Chloroform: Iso-Amyl Alcohol (25:24:1) Mixture"]]},
          Append[DemulsifierAdditions] -> {Null, Null, Null},
          LiquidLiquidExtractionTemperature -> 25 Celsius,
          NumberOfLiquidLiquidExtractions -> 3,
          LiquidLiquidExtractionMixType -> Shake,
          LiquidLiquidExtractionMixTime -> 30 Second,
          LiquidLiquidExtractionMixRate -> 500 RPM,
          LiquidLiquidExtractionSettlingTime -> 1 Minute,
          LiquidLiquidExtractionCentrifuge -> True,
          LiquidLiquidExtractionCentrifugeTime -> 1 Minute,
          LiquidLiquidExtractionCentrifugeIntensity -> 4000 GravitationalAcceleration
        |>
      }
    ];


  ],
  SymbolTearDown :> Module[
    {allObjects, existsFilter},

    (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
    allObjects= Cases[Flatten[{
      Object[Method, Extraction, PlasmidDNA, "Sample Method (for preResolveExtractMixOptions) "<>$SessionUUID]
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
  ],
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $EmailEnabled=False
  }
];
(* ::Subsection:: *)
(*extractionMethodValidityTest*)

DefineTests[
  extractionMethodValidityTest,
  {
    Example[{Basic, "Given inputs with valid method object and gatherTestsQ set to False, returns Nulls in tests, empty invalid options, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractRNA, {Method-> {
            Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID],Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
          }}]
        ];

        extractionMethodValidityTest[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {}}
    ],

    Example[{Basic, "Given inputs with valid method and gatherTestsQ set to True, returns empty list of invalid options, list of tests, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractRNA, {Method-> {
            Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID],Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
          }}]
        ];

        extractionMethodValidityTest[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
          },
          expandedOptions,
          True
        ]
      ],
      {{ListableP[TestP]..},{}}
    ],

    Example[{Basic, "Given inputs with invalid method objects and gatherTestsQ set to False, returns list of Null tests, invalid option of Purification, and Error::InvalidExtractionMethod:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractRNA, {Method-> {
            Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID],Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
          }}]
        ];

        extractionMethodValidityTest[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
          },
          expandedOptions,
          False
        ]
      ],
      {{Null..}, {Method..}},
      Messages :> {Error::InvalidExtractionMethod}
    ],
    Example[{Basic, "Given inputs with Method specified with invalid method objects and gatherTestsQ set to True, returns list of tests, invalid option of Purification, and no message:"},
      Module[{expandedInputs, expandedOptions},
        (* Get the default options for ExperimentExtractPlasmidDNA, which uses the lysis shared options *)
        {expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[
          ExperimentExtractRNA,
          {
            {
              Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
              Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
            }
          },
          SafeOptions[ExperimentExtractRNA, {Method-> {
            Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID],Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
          }}]
        ];

        extractionMethodValidityTest[
          {
            Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
            Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID]
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
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
          Name -> "Test 96-well plate 1 (Test for extractionMethodValidityTest) "<>$SessionUUID,
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
          "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID,
          "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID
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
      Upload[{
        <|
          Type -> Object[Method, Extraction, RNA],
          Name -> "invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID,
          DeveloperObject -> True,
          CellType -> Mammalian,
          TargetCellularComponent -> RNA,
          TargetRNA -> TotalRNA,
          Lyse -> False,
          Purification -> None
        |>,
        <|
          Type -> Object[Method, Extraction, RNA],
          Name -> "valid method (Test for extractionMethodValidityTest) "<>$SessionUUID,
          DeveloperObject -> True,
          CellType -> Null,
          TargetCellularComponent -> RNA,
          TargetRNA -> mRNA,
          Lyse -> True,
          HomogenizeLysate -> False,
          Purification -> None
        |>}
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
        Object[Container, Plate, "Test 96-well plate 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 1 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Sample, "Suspension bacterial cell sample 2 (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Method,Extraction,RNA,"invalid method (Test for extractionMethodValidityTest) "<>$SessionUUID],
        Object[Method,Extraction,RNA,"valid method (Test for extractionMethodValidityTest) "<>$SessionUUID]
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