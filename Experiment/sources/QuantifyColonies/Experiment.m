(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*QuantifyColonies*)


(* ::Subsection::Closed:: *)
(*Define Options*)



(* ::Subsubsection::Closed:: *)
(*ExperimentQuantifyColonies Options*)


(* ::Code::Initialization:: *)
(* Define Options *)
DefineOptions[ExperimentQuantifyColonies,
  Options :>  {
    (* Non-IndexMatching General Options *)
    ModifyOptions[ExperimentImageColonies,
      OptionName -> Instrument,
      ModifiedOptionName -> ImagingInstrument
    ],
    {
      OptionName -> PreparedSample,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the provided samples containing microbial cells that are counted have been previously transferred onto a solid media plate and cultivated to grow colonies. If PreparedSample is set to True, the provided sample container is placed directly into the imaging instrument for imaging and counting, bypassing the cell spreading and incubation steps.",
      ResolutionDescription -> "Set to False if the provided samples is not in the state of Solid, otherwise set to True.",
      Category -> "General"
    },
    {
      OptionName -> SpreaderInstrument,
      Default -> Automatic,
      Description -> "The colony handler that is used to spread the provided samples on solid media to prepare colony samples.",
      ResolutionDescription -> "When PreparedSample is set to False, automatically set SpreaderInstrument to Model[Instrument, ColonyHandler, \"QPix 420 HT\"].",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Cell Culture",
            "Plate Spreader"
          }
        }
      ],
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "General"]
    },
    {
      OptionName -> Incubator,
      Default -> Automatic,
      Description -> "The cell incubator that is used to grow colonies in the desired environment before colonies are imaged. Custom incubation actively selects an incubator in the lab and uses a thread to incubate only the cells from this protocol for the specified Time. Selecting a default IncubationCondition (BacterialIncubation, YeastIncubation) will passively store the cells for the specified time in a shared incubator, potentially with samples from other protocols. However, it will not consume a thread while the cells are inside the incubator.",
      ResolutionDescription -> "When PreparedSample is set to False, automatically set Incubator to an incubator that meets the requirements according to IncubateCellsDevices that provides desired incubation conditions.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, Incubator], Object[Instrument, Incubator]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Storage Devices",
            "Incubators"
          }
        }
      ],
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "General"]
    },
    (* Shared options *)
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the input samples to be quantified, for use in downstream unit operations.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the container of the input samples to be quantified, for use in downstream unit operations.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Category -> "General",
        UnitOperation -> True
      },
      (* --- ImageColonies Options --- *)
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ImagingChannels
      ],
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ImagingStrategies,
        Default -> Automatic,
        ResolutionDescription -> "Automatically set to include BlueWhiteScreen along with BrightField if Populations is set to include BlueWhiteScreen; set to include a specific fluorescence strategy along with BrightField if the Model[Cell] information in the sample matches one of the fluorescent excitation and emission pairs supported by the imaging instrument. Otherwise, set to BrightField, as a BrightField image is always taken."
      ],
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ExposureTimes
      ],
      {
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Single Label" -> Widget[Type -> String, Pattern :> _String, Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]]
        ],
        Description -> "The label of the solid media samples that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "General"],
        UnitOperation -> True
      },
      {
        OptionName -> ContainerOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Single Label" -> Widget[Type -> String, Pattern :> _String, Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]]
        ],
        Description -> "The label of the containers of the solid media sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "General"],
        UnitOperation -> True
      },
      (* --- Dilution Options for spreading cells --- *)
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionType,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionStrategy,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> NumberOfDilutions,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> CumulativeDilutionFactor,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> SerialDilutionFactor,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      (* --- SpreadCells Options --- *)
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> ColonySpreadingTool,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> SpreadVolume,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DispenseCoordinates,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> SpreadPatternType,
        Default -> Automatic,
        ResolutionDescription -> "If PreparedSample is set to False, automatically set to Spiral.",
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> CustomSpreadPattern,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DestinationContainer,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DestinationWell,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DestinationMedia,
        AllowNull -> True,
        Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Spreading"]
      ]
    ],
    (* --- IncubateCells Options --- *)
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> IncubationCondition,
      Widget -> Alternatives[
        "Incubation Type" -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[
            BacterialIncubation,
            YeastIncubation,
            Custom
          ]
        ],
        "Incubation Model" -> Widget[
          Type -> Object,
          Pattern :> ObjectP[Model[StorageCondition]],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Storage Conditions",
              "Incubation",
              "Cell Culture"
            }
          }
        ]
      ],
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation"]
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> Temperature,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "Automatically set to match the Temperature field of specified IncubationCondition. If IncubationCondition is set to Custom, automatically set to 30 Celsius.",
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation"]
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> RelativeHumidity,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "If IncubationCondition is set to Custom, automatically set to Ambient, otherwise match the Humidity field in specified IncubationCondition.",
      Category -> "Hidden"
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> CarbonDioxide,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "If IncubationCondition is set to Custom, automatically set to Ambient, otherwise match the CarbonDioxide field in specified IncubationCondition.",
      Category -> "Hidden"
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> Shake,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "If IncubationCondition is set to Custom, automatically set to False, otherwise set to True if PlateShakingRate and ShakingRadius are specified in IncubationCondition.",
      Category -> "Hidden"
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> ShakingRadius,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "If IncubationCondition is set to Custom, automatically set to Null, otherwise match the ShakingRadius field in specified IncubationCondition.",
      Category -> "Hidden"
    ],
    ModifyOptions[ExperimentIncubateCells,
      OptionName -> ShakingRate,
      AllowNull -> True,
      IndexMatching -> None,
      IndexMatchingInput -> Null,
      IndexMatchingParent -> Null,
      IndexMatchingOptions -> {},
      ResolutionDescription -> "If IncubationCondition is set to Custom, automatically set to Null, otherwise use the Value of PlateShakingRate in IncubationCondition option.",
      Category -> "Hidden"
    ],
    {
      OptionName -> ColonyIncubationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 Hour, $MaxCellIncubationTime],
        Units ->  {Hour, {Minute, Hour, Day}}
      ],
      Description -> "The duration during which the colony samples are incubated inside of cell incubator before imaging.",
      ResolutionDescription -> "If PreparedSample is set to False, automatically set to the shorter time of 10 Hour or ten times the DoublingTime of the cells in the samples, with a minimum of 1 hour.",
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation"]
    },
    {
      OptionName -> MinReliableColonyCount,
      Default -> Automatic,
      Description -> "The smallest number of colonies that can be counted on a solid media plate to provide a statistically reliable estimate of the concentration of microorganisms in a sample. Below this number, the count is considered statistically unreliable and the result is typically referred to as \"Too Few To Count\" (TFTC).",
      ResolutionDescription -> "If PreparedSample is set to False, automatically set to 30, otherwise set to 1.",
      AllowNull -> False,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 100, 1]],
      Category -> "Analysis"
    },
    {
      OptionName -> MaxReliableColonyCount,
      Default -> 300,
      Description -> "The largest number of colonies that can be counted on a solid media plate beyond which accurate counting becomes impractical and unreliable. This threshold is typically set at 300 colonies. When the number of colonies exceeds this limit, it is difficult to distinguish and count individual colonies accurately, and the result is typically referred as \"Too Numerous To Count\" (TNTC).",
      AllowNull -> False,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 1000, 1]],
      Category -> "Analysis"
    },
    {
      OptionName -> IncubateUntilCountable,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Description -> "Indicates whether colony samples should undergo repeated cycles of incubation, imaging, and analysis until one of the following conditions is met: 1) The TotalColonyCounts from analyses are no longer increasing after surpassing the MinReliableColonyCount. 2) The TotalColonyCounts from analyses exceed the MaxReliableColonyCount. 3) A predetermined maximum incubation time is reached. The criteria for identifying colonies large enough to be counted can be set using the following options: MinDiameter, MaxColonySeparation, MinRegularityRatio, MaxRegularityRatio, MinCircularityRatio, and MaxCircularityRatio. Refer to Figure 3.2 for more information on colony identification criteria.",
      ResolutionDescription -> "Automatically set to True if PreparedSample is False.",
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation Repeat"]
    },
    {
      OptionName -> NumberOfStableIntervals,
      Default -> Automatic,
      Description -> "The number of consecutive intervals during which the TotalColonyCounts remain stable (do not increase). For example, if the TotalColonyCounts (e.g. {200, 240, 240}) do not increase for the last two consecutive incubation intervals, the stable interval number is 1. This metric is used to determine whether all viable colonies have been counted when calculating Colony Forming Units (CFU). This stability indicates that the growth phase of the colonies has plateaued, ensuring an accurate count of all viable colonies present.",
      ResolutionDescription -> "Automatically set to 1 if IncubateUntilCountable is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[1, 5]
      ],
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation Repeat"]
    },
    {
      OptionName -> MaxColonyIncubationTime,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[2 Hour, $MaxCellIncubationTime],
        Units ->  {Hour, {Minute, Hour, Day}}
      ],
      Description -> "The maximum duration during which the colony samples are allowed to be incubated inside of cell incubator.",
      ResolutionDescription -> "If PreparedSample is set to False and IncubateUntilCountable is set to True, automatically set to the shorter time of 20 Hour or twenty times the DoublingTime of the cells in the samples, with a minimum of 2 hour. Otherwise set to the same value as IncubationTime if IncubateUntilCountable is set to False.",
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation Repeat"]
    },
    {
      OptionName -> IncubationInterval,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 Hour, $MaxCellIncubationTime],
        Units ->  {Hour, {Minute, Hour, Day}}
      ],
      Description -> "The duration during which colony samples are placed inside a cell incubator as part of repeated cycles of incubation, imaging, and analysis. Following this interval, the samples are moved out of the cell incubator and undergo imaging and analysis until all analyses return at least one value of TotalColonyCounts above the MinReliableColonyCount or until the MaxIncubationTime is reached.",
      ResolutionDescription -> "If IncubateUntilCountable is set to True, automatically set to the shorter time of 5 hours or five times the DoublingTime of the cells in the samples, with a minimum of 1 hour. Any time less than 1 hour is not sufficient to complete the cycle of setting up incubator and imaging instrument.",
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Incubation Repeat"]
    },
    (*Criteria*)
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MinDiameter,
      Description -> "The smallest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MaxDiameter,
      Description -> "The largest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MinColonySeparation,
      Description -> "The closest distance included colonies can be from each other from which colonies will be included in the data and analysis. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MinRegularityRatio,
      Description -> "The smallest regularity ratio from which colonies will be included in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MaxRegularityRatio,
      Description -> "The largest regularity ratio from which colonies will be included in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MinCircularityRatio,
      Description -> "The smallest circularity ratio from which colonies will be included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    ModifyOptions[AnalyzeColoniesSharedOptions,
      OptionName -> MaxCircularityRatio,
      Description -> "The largest circularity ratio from which colonies will be included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
      IndexMatching -> None,
      Category -> "Analysis"
    ],
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* --- AnalyzeColonies Options --- *)
      ModifyOptions[AnalyzeColonies,
        OptionName -> Populations,
        Default -> Automatic,
        Description -> "The criteria used to group colonies together into a population to count. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen. For more information see documentation on colony population Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, BlueWhiteScreen, MultiFeatured, and AllColonies under Experiment Principles section.",
        ResolutionDescription -> "If the Model[Cell] information in the sample object matches one of the fluorescent excitation and emission pairs of the colony picking instrument, Populations is set to Fluorescence. If BlueWhiteScreen is specified in ImagingStrategies, Populations is set to BlueWhiteScreen. Otherwise, Populations is set to All.",
        Widget -> Alternatives[
          "Single Colony Population" -> Alternatives[
            Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Fluorescence, BlueWhiteScreen, Diameter, Isolation, Circularity, Regularity, All]
            ],
            "Fluorescence" -> Widget[
              Type -> UnitOperation,
              Pattern :> FluorescencePrimitiveP
            ],
            "BlueWhiteScreen" -> Widget[
              Type -> UnitOperation,
              Pattern :> BlueWhiteScreenPrimitiveP
            ],
            "Diameter" -> Widget[
              Type -> UnitOperation,
              Pattern :> DiameterPrimitiveP
            ],
            "Isolation" -> Widget[
              Type -> UnitOperation,
              Pattern :> IsolationPrimitiveP
            ],
            "Circularity" -> Widget[
              Type -> UnitOperation,
              Pattern :> CircularityPrimitiveP
            ],
            "Regularity" -> Widget[
              Type -> UnitOperation,
              Pattern :> RegularityPrimitiveP
            ],
            "AllColonies" -> Widget[
              Type -> UnitOperation,
              Pattern :> AllColoniesPrimitiveP
            ],
            "MultiFeatured" -> Widget[
              Type -> UnitOperation,
              Pattern :> MultiFeaturedPrimitiveP
            ]
          ],
          "Multiple Colony Populations" -> Adder[
            Alternatives[
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Fluorescence, BlueWhiteScreen, Diameter, Isolation, Circularity, Regularity, All]
              ],
              "Fluorescence" -> Widget[
                Type -> UnitOperation,
                Pattern :> FluorescencePrimitiveP
              ],
              "BlueWhiteScreen" -> Widget[
                Type -> UnitOperation,
                Pattern :> BlueWhiteScreenPrimitiveP
              ],
              "Diameter" -> Widget[
                Type -> UnitOperation,
                Pattern :> DiameterPrimitiveP
              ],
              "Isolation"-> Widget[
                Type -> UnitOperation,
                Pattern :> IsolationPrimitiveP
              ],
              "Circularity" -> Widget[
                Type -> UnitOperation,
                Pattern :> CircularityPrimitiveP
              ],
              "Regularity" -> Widget[
                Type -> UnitOperation,
                Pattern :> RegularityPrimitiveP
              ],
              "AllColonies" -> Widget[
                Type -> UnitOperation,
                Pattern :> AllColoniesPrimitiveP
              ],
              "MultiFeatured" -> Widget[
                Type -> UnitOperation,
                Pattern :> MultiFeaturedPrimitiveP
              ]
            ]
          ]
        ],
        NestedIndexMatching -> False,
        Category -> "Analysis"
      ],
      {
        OptionName -> PopulationCellTypes,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          "CellType for single Colony Population" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Bacterial, Yeast]
          ],
          "CellTypes for Multiple Colony Populations" -> Adder[
            Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Bacterial, Yeast]
            ]
          ]
        ],(* Matches to Populations *)
        Description -> "The cell type thought to represent the physiological characteristics defined in each of the Populations.",
        ResolutionDescription -> "Automatically set to the cell type of the specified PopulationIdentities if it is a Model[Cell]. Otherwise, PopulationCellTypes is set to the cell type of the analyte or the cell model with the highest concentration from the input sample.",
        Category -> "Analysis"
      },
      {
        OptionName -> PopulationIdentities,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Alternatives[
          "CellIdentity for single Colony Population" -> Alternatives[
            "New characterized Name" -> Widget[Type -> String, Pattern :> _String, Size -> Line],
            "Existing Identities Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Cell, Bacteria], Model[Cell, Yeast]}]]
            ],
          "CellIdentities for Multiple Colony Populations" -> Adder[
            Alternatives[
              "New characterized Name" -> Widget[Type -> String, Pattern :> _String, Size -> Line],
              "Existing Identities Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Cell, Bacteria], Model[Cell, Yeast]}]]
            ]
          ]
        ],(* Matches to Populations *)
        Description -> "The cell constituent thought to represent the physiological characteristics defined in each of the Populations. If given as a string, a new Model[Cell] with the given name will be created with the type specified in option PopulationCellTypes and the current model of the given sample will be removed after the quantification step.",
        ResolutionDescription -> "Automatically set to the cell model of the analyte or the cell model if there is only one cell model in the Composition of the input sample, otherwise set to \"Characterized Colony from <SampleID> #\", and the protocol ID is always appended to the end of name string automatically at the time of model creation.",
        Category -> "Analysis"
      }
    ],
    {
      OptionName -> WorkCell,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[qPix]],
      AllowNull -> True,
      Default -> Automatic,
      Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
      ResolutionDescription -> "Automatically set to qPix if Preparation->Robotic.",
      Category -> "General"
    },
    (* Shared Options *)
    (* We still need these post-processing options to exist for QuantifyColonies to work properly as a primitive in framework. But they are not really options for users. If the user has a valid sample, this is going to error whenever the user wants to change the value of these post-processing options. Therefore making them hidden. *)
    ModifyOptions[BiologyPostProcessingOptions,
      OptionName -> ImageSample,
      Category -> "Hidden"
    ],
    ModifyOptions[BiologyPostProcessingOptions,
      OptionName -> MeasureVolume,
      Category -> "Hidden"
    ],
    ModifyOptions[BiologyPostProcessingOptions,
      OptionName -> MeasureWeight,
      Category -> "Hidden"
    ],
    ProtocolOptions,
    SamplesInStorageOptions,
    ModifyOptions[SamplesOutStorageOptions,
      OptionName -> SamplesOutStorageCondition,
      Category -> If[TrueQ[$QuantifyColoniesPreparedOnly], "Hidden", "Post Experiment"]
    ],
    SimulationOption,
    PreparationOption
  }
];


(* ::Subsection::Closed:: *)
(*Warning and Error Messages*)


(* Version Errors *)
Error::QuantifyColoniesPreparationNotSupported = "Currently only a prepared colony plate is supported as input, please use ExperimentCellPreparation to construct a prepared plate with colonies prior to imaging and quantification.";
Error::ConflictingPreparedSampleWithSpreading = "Spread cells option `1` is set to `2` and PreparedSample is set to `3`. When PreparedSample is set to True, no spread cell options should be used. When PreparedSample is set to False, SpreaderInstrument, ColonySpreadingTool, SpreadVolume, DestinationContainer, and DestinationMedia must be populated. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingPreparedSampleWithIncubation = "Cell incubation option(s) `1` is set to `2` and PreparedSample is set to `3`. When PreparedSample is set to True, no cell incubation options should be used. When PreparedSample is set to False, Incubator, IncubationCondition, Temperature, ColonyIncubationTime, and IncubateUntilCountable must be populated. Please fix these conflicting options to specify a valid experiment.";
(* Imaging Errors *)
Error::MissingImagingStrategies = "The following sample(s), `1`, have missing ImagingStrategies `2`. `3`. Please ensure all necessary imaging strategies are included to properly group colonies for the sample.";
(* Population Errors *)
Error::ConflictingPopulationIdentitiesWithPopulations = "The following sample(s), `1`, have PopulationIdentities set to  `2` and Populations set to `3`. Please ensure there is a cell identity model for each population by setting both of these options as a list, neither of them as a list, or allow them to be set automatically.";
Error::ConflictingPopulationCellTypesWithIdentities = "The following sample(s), `1`, have PopulationCellTypes set to `2` and PopulationIdentities set to `3`. PopulationCellTypes should be the cell type of PopulationIdentities if existing Model[Cell] is specified. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingPopulationCellTypesWithPopulations = "The following sample(s), `1`, have PopulationCellTypes set to  `2` and Populations set to `3`. Please ensure there is a cell type for each population by setting both of these options as a list, neither of them as a list, or  or allow them to be set automatically.";
Error::OverlappingPopulations = "The following sample(s), `1`, have the Populations that are not mutually exclusive. If AllColonies or CustomCoordinates are selected, no other populations can be specified from the same sample. Please remove some of the grouping criteria from Populations.";
Error::NewColonyNameInUse = "The provided PopulationIdentities `1` is already in use in Constellation. Please choose a different Name for this new cell identity model, or consider using the existing cell identity model with this name.";
Error::DuplicatedPopulationIdentities = "PopulationIdentities contains duplicates. The name of each cell model must be unique. Please make PopulationIdentities unique.";
(* Incubate Errors *)
Error::TooManyIncubationConditions = "The sample(s) `1` have main cell component `2` to be stored at IncubationCondition `3` by default, but only one incubator can be used per protocol, currently `3` is selected. For these sample(s), either utilize custom incubation condition with the same incubator and set temperature, or split the experiment call into separate protocols.";
(* Temporarily make a new error and use the same phrase as the old "Error::IncubatorIsIncompatible" for ExperimentQuantifyColonies only because currently we do not call ExperimentIncubateCells. We have far from enough information to incorporate the new message format and use the message defined there. Will need to discuss whether make the logic in ExperimentIncubateCells a very big helper, or make QuantifyColonies call ModifyFunctionMessages[ExperimentIncubateCells] instead. *)
Error::IncubatorIsIncompatibleForColonies = "The sample(s) `1` at indices `2` have cell incubator specified as, `3`. However,  this sample can only be incubated in the following cell incubator models, `4`. Please use the function IncubateCellsDevices to select a compatible cell incubator, or allow Incubator to be set automatically.";
Error::UnsuitableIncubationInterval = "The IncubationInterval option is set to `1` and the NumberOfStableIntervals is set to `2`. Please specify an IncubationInterval less than `3`, but more than 1 Hour in order to submit a valid experiment, or extend MaxColonyIncubationTime. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingIncubationRepeatOptions = "The IncubateUntilCountable is set to `1`, ColonyIncubationTime set to `2`, MaxColonyIncubationTime set to `3`, and IncubationInterval set to `4`. If IncubateUntilCountable is set to True, MaxColonyIncubationTime must be longer than ColonyIncubationTime, and IncubationInterval is not Null. If IncubateUntilCountable is set to False, MaxColonyIncubationTime must be equal to ColonyIncubationTime. Please fix these conflicting options to specify a valid experiment.";


(* ::Subsection::Closed:: *)
(*Experiment Function*)


(* ::Code::Initialization:: *)
(* CORE Overload *)
ExperimentQuantifyColonies[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[ExperimentQuantifyColonies]] := Module[
  {
    outputSpecification, output, gatherTests, listedSamplesNamed, listedOptionsNamed,  safeOpsNamed, safeOpsTests,
    listedSamples, safeOps, validLengths, validLengthTests, templatedOptions, templateTests, simulation, currentSimulation,
    inheritedOptions, name, upload, confirm, canaryBranch, fastTrack, parentProtocol, priority, startDate, holdOrder, queuePosition,
    specifiedSampleOutLabel, specifiedContainerOutLabel, listySampleOutLabel, listyContainerOutLabel, listyInheritedOptions,
    preExpandedImagingStrategies, preExpandedImagingChannels, preExpandedExposureTimes, preExpandedPopulations,
    preExpandedPopulationCellTypes, preExpandedPopulationIdentities, manuallyExpandedImagingStrategies,
    manuallyExpandedImagingChannels, manuallyExpandedExposureTimes, manuallyExpandedPopulations, manuallyExpandedPopulationCellTypes,
    manuallyExpandedPopulationIdentities, expandedSafeOps, cache, defaultObjects, allObjects,
    objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields, modelInstrumentFields, modelCellFields,
    sampleObjects, instrumentObjects, modelInstrumentObjects, objectContainerObjects, modelContainerObjects, modelCellObjects,
    incubationStorageConditions, downloadedCache, cacheBall, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,
    preCollapsedResolvedOptions, collapsedResolvedOptions, resolvedPreparation, resolvedPreparedSample,
    returnEarlyQBecauseOptionsResolverOnly, optionsResolverOnly, returnEarlyBecauseFailuresQ, performSimulationQ,
    protocolPacket, unitOperationPacket, batchedUnitOperationPackets, runTime, simulatedProtocol, updatedSimulation, uploadQ,
    allUnitOperationPackets, protocolObject, resourcePacketTests
  },

  (* Determine the requested return value from the function. *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests. *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links. *)
  (* Make sure we're working with a list of options/inputs. *)
  {listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Note: we do not have sample prep options, not check validSamplePrep here *)

  (* Call SafeOptions to make sure all options match pattern. *)
  {safeOpsNamed, safeOpsTests} = If[gatherTests,
    SafeOptions[ExperimentQuantifyColonies, listedOptionsNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentQuantifyColonies, listedOptionsNamed, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any named objects. *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed, Simulation -> Lookup[safeOpsNamed, Simulation, Null]];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length. *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentQuantifyColonies, {listedSamples}, safeOps, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentQuantifyColonies, {listedSamples}, safeOps], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point). *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions. *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentQuantifyColonies, {ToList[listedSamples]}, safeOps, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentQuantifyColonies, {ToList[listedSamples]}, safeOps], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Lookup simulation if it exists *)
  simulation = Lookup[safeOps, Simulation];

  (* Initialize the simulation if it doesn't exist *)
  currentSimulation = If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* Get assorted hidden options *)
  {name, upload, confirm, canaryBranch, fastTrack, parentProtocol, priority, startDate, holdOrder, queuePosition} = Lookup[inheritedOptions,
    {Name, Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Priority, StartDate, HoldOrder, QueuePosition}
  ];

  (* explicitly handle the SampleOutLabel/ContainerOutLabel options if they are specified *)
  (* the case where we have 4 inputs and a list of length 4 for SampleOutLabel is ambiguous.  It could mean we want to expand that list of length 4 for each input, or we could want each singleton value to be index matched with the input *)
  (* in our case, the second case is always right.  So to get this, if we specify a flat list that is the same length as the input, then we add a ToList in there to make sure *)
  {
    specifiedSampleOutLabel,
    specifiedContainerOutLabel
  } = Lookup[inheritedOptions, {SampleOutLabel, ContainerOutLabel}];

  listySampleOutLabel = Which[
    (* We need to handle Null or list of Null case first.*)
    (* This is a realistic case when this is called by framework function within a script, the script would have been generated with a resolved collapsed SampleOutLabel -> Null. It got expanded to same length with mySamples by framework function, e.g. {Null, Null} for 2 samples, then this should be collapsed into a Null rather than expanded into {{Null}, {Null}}. Otherwise it will error out due to pattern not allowed. Same for the ContainerOutLabel option below. *)
    NullQ[specifiedSampleOutLabel],
      Null,
    ListQ[specifiedSampleOutLabel] && Length[specifiedSampleOutLabel] == Length[ToList[mySamples]],
      ToList /@ specifiedSampleOutLabel,
    True,
      specifiedSampleOutLabel
  ];
  listyContainerOutLabel = Which[
    NullQ[specifiedContainerOutLabel],
      Null,
    ListQ[specifiedContainerOutLabel] && Length[specifiedContainerOutLabel] == Length[ToList[mySamples]],
      ToList /@ specifiedContainerOutLabel,
    True,
      specifiedContainerOutLabel
  ];

  (* replace the old values for SampleOutLabel/ContainerOutLabel with the new one *)
  listyInheritedOptions = ReplaceRule[inheritedOptions, {SampleOutLabel -> listySampleOutLabel, ContainerOutLabel -> listyContainerOutLabel}];


  (* Expand index-matching options *)
  (* Normally, SingletonClassificationPreferred or ExpandedClassificationPreferred is used to expand nested indexmatching options *)
  (* But only one set of nested options is allowed, for us, it is Dilution *)
  (* So we can be smart here to check if it is singleton or not for imaging/population options *)
  {
    preExpandedImagingStrategies,
    preExpandedImagingChannels,
    preExpandedExposureTimes,
    preExpandedPopulations,
    preExpandedPopulationCellTypes,
    preExpandedPopulationIdentities
  } = Lookup[listyInheritedOptions,
    {
      ImagingStrategies,
      ImagingChannels,
      ExposureTimes,
      Populations,
      PopulationCellTypes,
      PopulationIdentities
    }
  ];
  (* Basically, the only value allowed for singleton for ImagingStrategies is BrightField *)
  (* And ImagingChannels and ExposureTimes are index matched to ImagingStrategies *)
  {
    manuallyExpandedImagingStrategies,
    manuallyExpandedImagingChannels,
    manuallyExpandedExposureTimes
  } = Which[
    MatchQ[preExpandedImagingStrategies, BrightField|Automatic],
      (* If a singleton value is given and collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{BrightField(for s1),BrightField(for s2)}, ExposureTimes:{Automatic|10ms(for s1),Automatic|10ms(for s2)}*)
      {
        ConstantArray[preExpandedImagingStrategies, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedImagingChannels, _List],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, _List],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, {(BrightField|Automatic)..}] && EqualQ[Length[preExpandedImagingStrategies], Length@ToList[listedSamples]],
      (* If a singleton value is given and not collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{BrightField(for s1),BrightField(for s2)}, ExposureTimes:{Automatic|10ms(for s1),Automatic|10ms(for s2)}*)
      {
        preExpandedImagingStrategies,
        If[!MatchQ[preExpandedImagingChannels, _List],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, _List],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, _List] && !MemberQ[preExpandedImagingStrategies, _List],
      (* If it is a list and collapsed *)
      (* Example1: samples:{s1,s2}, ImagingChannels:{{BrightField,400nm}(for s1),{BrightField,400nm}(for s2)}, ExposureTimes:{Automatic|{10ms, 10ms}(for s1),Automatic|{10ms, 10ms}(for s2)}*)
      (* Example2: samples:{s1,s2}, ImagingChannels:{{BrightField(for s1)},{BrightField(for s2)}}, ExposureTimes:{Automatic(for s1),Automatic(for s2)}*)
      {
        ConstantArray[preExpandedImagingStrategies, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedImagingChannels, {_List..}],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, {_List..}],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, {_List..}],
      (* If a list of values are given and not collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{{BrightField(for s1)},{BrightField, 400nm(for s2)}}, ExposureTimes:{Automatic(for s1),Automatic(for s2)}*)
      {
        preExpandedImagingStrategies,
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedImagingChannels, {_List..}],
            MatchQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels && !MemberQ[preExpandedImagingChannels, _List]
          ],
            ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          True,
            preExpandedImagingChannels
        ],
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedExposureTimes, {_List..}],
            MatchQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes && !MemberQ[preExpandedExposureTimes, _List]
          ],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          True,
            preExpandedExposureTimes
        ]
      },
    True,
      (* If a mixture of singleton and list of values are given and not collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{BrightField(for s1),{BrightField, 400nm(for s2)}}, ExposureTimes:{Automatic(for s1),Automatic(for s2)}*)
      {
        preExpandedImagingStrategies,
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedImagingChannels, {_List..}],
            MatchQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels && !MemberQ[preExpandedImagingChannels, _List]
          ],
            ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          True,
            preExpandedImagingChannels
        ],
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedExposureTimes, {_List..}],
            MatchQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes && !MemberQ[preExpandedExposureTimes, _List]
          ],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          True,
            preExpandedExposureTimes
        ]
      }
  ];

  (* And Populations does not allow multiple All for the same sample *)
  (* And PopulationCellTypes and PopulationIdentities are index matched to Populations *)
  {
    manuallyExpandedPopulations,
    manuallyExpandedPopulationCellTypes,
    manuallyExpandedPopulationIdentities
  } = Which[
    !MatchQ[preExpandedPopulations, _List],
      (* If a singleton value is given and collapsed *)
      {
        ConstantArray[preExpandedPopulations, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedPopulationCellTypes, _List], ConstantArray[preExpandedPopulationCellTypes, Length[ToList[listedSamples]]], preExpandedPopulationCellTypes],
        If[!MatchQ[preExpandedPopulationIdentities, _List], ConstantArray[preExpandedPopulationIdentities, Length[ToList[listedSamples]]], preExpandedPopulationIdentities]
      },
    MatchQ[preExpandedPopulations, {(All|Automatic|AllColoniesPrimitiveP)..}] && EqualQ[Length[preExpandedPopulations], Length@ToList[listedSamples]],
      (* If a singleton value is given and not collapsed *)
      {
        preExpandedPopulations,
        If[!MatchQ[preExpandedPopulationCellTypes, _List], ConstantArray[preExpandedPopulationCellTypes, Length[ToList[listedSamples]]], preExpandedPopulationCellTypes],
        If[!MatchQ[preExpandedPopulationIdentities, _List], ConstantArray[preExpandedPopulationIdentities, Length[ToList[listedSamples]]], preExpandedPopulationIdentities]
      },
    MatchQ[preExpandedPopulations, _List] && !MemberQ[preExpandedPopulations, _List],
      (* If it is a list and collapsed *)
      {
        ConstantArray[preExpandedPopulations, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedPopulationCellTypes, {_List..}], ConstantArray[preExpandedPopulationCellTypes, Length[ToList[listedSamples]]], preExpandedPopulationCellTypes],
        If[!MatchQ[preExpandedPopulationIdentities, {_List..}], ConstantArray[preExpandedPopulationIdentities, Length[ToList[listedSamples]]], preExpandedPopulationIdentities]
      },
    MatchQ[preExpandedPopulations, {_List..}],
      (* If a list of values are given and not collapsed *)
      {
        preExpandedPopulations,
        If[Or[
          !MatchQ[preExpandedPopulationCellTypes, {_List..}],
          MatchQ[preExpandedPopulationCellTypes, _List] && !SameQ @@ preExpandedPopulationCellTypes && !MemberQ[preExpandedPopulationCellTypes, _List]
        ],
          ConstantArray[preExpandedPopulationCellTypes, Length[ToList[listedSamples]]],
          preExpandedPopulationCellTypes
        ],
        If[Or[
          !MatchQ[preExpandedPopulationIdentities, {_List..}],
          MatchQ[preExpandedPopulationIdentities, _List] && !SameQ @@ preExpandedPopulationIdentities && !MemberQ[preExpandedPopulationIdentities, _List]
        ],
          ConstantArray[preExpandedPopulationIdentities, Length[ToList[listedSamples]]],
          preExpandedPopulationIdentities
        ]
      },
    True,
      (* If a mixture of singleton and list of values are given and not collapsed *)
      {
        preExpandedPopulations,
        If[MatchQ[preExpandedPopulationCellTypes, Automatic],
          ConstantArray[preExpandedPopulationCellTypes, Length[ToList[listedSamples]]],
          preExpandedPopulationCellTypes
        ],
        If[MatchQ[preExpandedPopulationIdentities, Automatic],
          ConstantArray[preExpandedPopulationIdentities, Length[ToList[listedSamples]]],
          preExpandedPopulationIdentities
        ]
      }
  ];

  (* Updating imaging/population options with the manually expanded values *)
  expandedSafeOps = Join[
    Last[
      ExpandIndexMatchedInputs[
        ExperimentQuantifyColonies,
        {ToList[listedSamples]},
        Normal@KeyDrop[listyInheritedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes, Populations, PopulationCellTypes, PopulationIdentities}]
      ]
    ],
    {
      ImagingStrategies -> manuallyExpandedImagingStrategies,
      ImagingChannels -> manuallyExpandedImagingChannels,
      ExposureTimes -> manuallyExpandedExposureTimes,
      Populations -> manuallyExpandedPopulations,
      PopulationCellTypes -> manuallyExpandedPopulationCellTypes,
      PopulationIdentities -> manuallyExpandedPopulationIdentities
    }
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cache = Lookup[expandedSafeOps, Cache, {}];

  (* Default instrument and container model. *)
  defaultObjects = Join[
    {
      Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"],(*"QPix 420 HT"*)
      Model[Container, Plate, "id:L8kPEjkmLbvW"],(*Model[Container, Plate, "96-well 2mL Deep Well Plate"]*)
      Model[Container, Plate, "id:O81aEBZjRXvx"],(*Model[Container, Plate, "Omni Tray Sterile Media Plate"]*)
      Model[Container, Plate, "id:n0k9mGzRaaBn"] (*Model[Container, Plate, "96-well UV-Star Plate"]*)
    },
    (* Get the incubator instruments in the lab that are not deprecated. *)
    Flatten[{
      nonDeprecatedIncubatorsSearch["Memoization"],
      Cases[KeyDrop[ToList[myOptions], {Cache, Simulation}], ObjectReferenceP[{Object[Instrument, Incubator], Model[Instrument, Incubator]}], Infinity]
    }]
  ];

  (* Get all the incubation storage conditions *)
  incubationStorageConditions = allIncubationStorageConditions["Memoization"];

  (* All the objects. *)
  (* NOTE: Include the default samples, containers, methods and instruments that we can use since we want their packets as well. *)
  allObjects = DeleteDuplicates@Download[
    Cases[
      Flatten@Join[
        ToList[listedSamples],
        ToList[Lookup[expandedSafeOps, {ImagingInstrument, SpreaderInstrument, Incubator, DestinationContainer, PopulationIdentities, DestinationMedia, DestinationContainer}]],
        defaultObjects
      ],
      ObjectP[]
    ],
    Object,
    Date -> Now
  ];

  (* Create the Packet Download syntax for our Object and Model. *)
  objectSampleFields = Union[{Volume, Composition, Media, State, CultureAdhesion, Position, Notebook}, SamplePreparationCacheFields[Object[Sample]]];
  modelSampleFields = Union[{Composition, CultureAdhesion, State}, SamplePreparationCacheFields[Model[Sample]]];
  objectContainerFields = Union[{Notebook}, SamplePreparationCacheFields[Object[Container]]];
  modelContainerFields = SamplePreparationCacheFields[Model[Container]];
  modelInstrumentFields = Union[{Name, Positions, WettedMaterials}, cellIncubatorInstrumentDownloadFields[]];
  modelCellFields = {CellType, DoublingTime, CultureAdhesion, BiosafetyLevel, Name, Notebook, IncompatibleMaterials};

  sampleObjects = Cases[allObjects, ObjectP[Object[Sample]]];
  instrumentObjects = Cases[allObjects, ObjectP[Object[Instrument]]];
  modelInstrumentObjects = Cases[allObjects, ObjectP[Model[Instrument]]];
  objectContainerObjects = Cases[allObjects, ObjectP[Object[Container]]];
  modelContainerObjects = Cases[allObjects, ObjectP[Model[Container]]];
  modelCellObjects = Cases[allObjects, ObjectP[Model[Cell]]];

  (* Combine our simulated cache and download cache. *)
  downloadedCache = Quiet[
    Download[
      {
        sampleObjects,
        instrumentObjects,
        modelInstrumentObjects,
        objectContainerObjects,
        modelContainerObjects,
        modelCellObjects,
        incubationStorageConditions
      },
      {
        {
          Evaluate[Packet@@objectSampleFields],
          Packet[Model[modelSampleFields]],
          Packet[Composition[[All, 2]][{CellType, CultureAdhesion, DoublingTime}]],
          Packet[Container[objectContainerFields]],
          Packet[Container[Model][modelContainerFields]]
        },
        {
          Packet[Name, Status, Model, Contents],
          Packet[Model[modelInstrumentFields]]
        },
        {
          Evaluate[Packet@@modelInstrumentFields]
        },
        {
          Evaluate[Packet@@objectContainerFields],
          Packet[Model[modelContainerFields]]
        },
        {
          Evaluate[Packet@@modelContainerFields]
        },
        {
          Evaluate[Packet@@modelCellFields]
        },
        {
          Packet[StorageCondition, CellType, CultureHandling, Temperature, Humidity, Temperature, CarbonDioxide, ShakingRate, VesselShakingRate, PlateShakingRate, ShakingRadius]
        }
      },
      Cache -> cache,
      Simulation -> currentSimulation
    ],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  cacheBall = FlattenCachePackets[{
    cache,
    downloadedCache
  }];

  (* Build the resolved options. *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentQuantifyColoniesOptions[
      ToList[mySamples],
      expandedSafeOps,
      Cache -> cacheBall,
      Simulation -> currentSimulation,
      Output -> {Result, Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {resolvedOptions, resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions, resolvedOptionsTests} = {
        resolveExperimentQuantifyColoniesOptions[
          ToList[mySamples],
          expandedSafeOps,
          Cache -> cacheBall,
          Simulation -> currentSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Manually collapse imaging and population options. They are NestedIndexMatched to each other but that information is not *)
  (* in their OptionDefinition because there can only be one NestedIndexMatching block per IndexMatching block *)
  (* NOTE: This collapsing logic is mirrored from CollapseIndexMatchedOptions. We know that both options are IndexMatching *)
  (* are currently in an expanded form and are nested index matching *)
  preCollapsedResolvedOptions = Map[
    Function[{option},
      Module[{resolvedOptionRule, inheritedOptionRule},
        resolvedOptionRule = Lookup[resolvedOptions, option];
        inheritedOptionRule = Lookup[inheritedOptions, option];
        Which[
          (* If the option was specified by the user, ignore it *)
          MatchQ[resolvedOptionRule, inheritedOptionRule],
            option -> resolvedOptionRule,
          (* If there is the same singleton pattern across all samples, collapse it to a single singleton value *)
          And[
            MatchQ[resolvedOptionRule, _List],
            !MemberQ[resolvedOptionRule, _List],
            SameQ @@ Flatten[ToList[resolvedOptionRule], 1]
          ],
            option -> First[ToList[resolvedOptionRule]],
          (* If there is the same list pattern across all nested lists, collapse it to a list value *)
          MatchQ[resolvedOptionRule, {_List..}] && SameQ @@ resolvedOptionRule,
            option -> First[resolvedOptionRule],
          (* Otherwise, this means the option is not the same across all nested lists, so leave it alone *)
          True,
            option -> resolvedOptionRule
        ]
      ]
    ],
    {ImagingStrategies, ImagingChannels, ExposureTimes, Populations, PopulationCellTypes, PopulationIdentities}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = Join[
    CollapseIndexMatchedOptions[
      ExperimentQuantifyColonies,
      Normal@KeyDrop[resolvedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes, Populations, PopulationCellTypes, PopulationIdentities}],
      Ignore -> ToList[myOptions],
      Messages -> False
    ],
    {
      ImagingStrategies -> Lookup[preCollapsedResolvedOptions, ImagingStrategies],
      ImagingChannels -> Lookup[preCollapsedResolvedOptions, ImagingChannels],
      ExposureTimes -> Lookup[preCollapsedResolvedOptions, ExposureTimes],
      Populations -> Lookup[preCollapsedResolvedOptions, Populations],
      PopulationCellTypes -> Lookup[preCollapsedResolvedOptions, PopulationCellTypes],
      PopulationIdentities -> Lookup[preCollapsedResolvedOptions, PopulationIdentities]
    }
  ];

  (* Lookup our option values.  This will determine if we skip the resource packets and simulation functions *)
  (* If Output contains Result or Simulation, then we can't do this *)
  {resolvedPreparation, resolvedPreparedSample, optionsResolverOnly} = Lookup[resolvedOptions, {Preparation, PreparedSample, OptionsResolverOnly}];
  returnEarlyQBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyBecauseFailuresQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  (* NOTE: We need to perform simulation if Result is asked for in GrowCrystal since it's part of the SamplePreparation experiments. *)
  (* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];

  (* If option resolution failed or we aren't asked for the simulation or output, return early. *)
  If[(returnEarlyBecauseFailuresQ || returnEarlyQBecauseOptionsResolverOnly) && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentQuantifyColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> currentSimulation
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  {{protocolPacket, unitOperationPacket, batchedUnitOperationPackets, runTime}, resourcePacketTests} = If[returnEarlyBecauseFailuresQ || returnEarlyQBecauseOptionsResolverOnly,
    {{$Failed, $Failed, $Failed, $Failed}, {}},
    If[gatherTests,
      quantifyColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> currentSimulation, Output -> {Result, Tests}],
      {quantifyColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> currentSimulation], {}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  (* If option resolver fails, return Null *)
  {simulatedProtocol, updatedSimulation} = If[returnEarlyBecauseFailuresQ || !performSimulationQ,
    {Null, currentSimulation},
    simulateExperimentQuantifyColonies[
      protocolPacket,
      unitOperationPacket,
      listedSamples,
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> currentSimulation,
      ParentProtocol -> parentProtocol
    ]
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output, Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentQuantifyColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> updatedSimulation
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps, Upload];

  (* Gather all the unit operation packets *)
  allUnitOperationPackets = Flatten[{unitOperationPacket, batchedUnitOperationPackets}];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[protocolPacket, $Failed] || MatchQ[unitOperationPacket, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
      $Failed,

    (* If Upload->False, return the unit operation packets without RequireResources called*)
    !uploadQ,
      allUnitOperationPackets,

    (* If we're in global script simulation mode and are Preparation->Manual, we want to upload our simulation to the global simulation *)
    MatchQ[$CurrentSimulation, SimulationP] && MatchQ[resolvedPreparation, Manual],
      Module[{},
        UpdateSimulation[$CurrentSimulation, updatedSimulation];
        If[MatchQ[upload, False],
          Lookup[updatedSimulation[[1]], Packets],
          simulatedProtocol
        ]
      ],

    (* If we're doing Preparation->Robotic and Upload->False, return the unit operation packets without RequireResources called *)
    MatchQ[resolvedPreparation, Robotic] && !uploadQ,
      allUnitOperationPackets,

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive *)
    MatchQ[resolvedPreparation, Robotic],
      Module[
        {
          primitive, nonHiddenOptions, protocolID, newCellModelPackets, newCellReplacementRules
        },
        (* Create the QuantifyColonies primitive to feed into RoboticCellPreparation *)
        primitive = QuantifyColonies@@Join[
          {
            Sample -> Download[ToList[mySamples], Object]
          },
          RemoveHiddenPrimitiveOptions[QuantifyColonies, ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions = RemoveHiddenOptions[ExperimentQuantifyColonies, collapsedResolvedOptions];
        (* To avoid creating NEW cell model every time in option resolver, we do it right after protocol generation *)

        (* Memoize the value of ExperimentQuantifyColonies so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentQuantifyColonies, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache = <||>;

          ExperimentQuantifyColonies[___, options: OptionsPattern[]] := Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification = Lookup[ToList[options], Output];

            frameworkOutputSpecification/.{
              Result -> allUnitOperationPackets,
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> updatedSimulation,
              RunTime -> runTime
            }
          ];

          protocolID = ExperimentRoboticCellPreparation[
            {primitive},
            Name -> Lookup[safeOps, Name],
            Instrument -> Lookup[collapsedResolvedOptions, ImagingInstrument],(*Note: for robotic version, the only instrument is imaging instrument *)
            Upload -> Lookup[collapsedResolvedOptions, Upload],
            ImageSample -> Lookup[collapsedResolvedOptions, ImageSample],
            MeasureVolume -> Lookup[collapsedResolvedOptions, MeasureVolume],
            MeasureWeight -> Lookup[collapsedResolvedOptions, MeasureWeight],
            Confirm -> Lookup[collapsedResolvedOptions, Confirm],
            CanaryBranch -> Lookup[collapsedResolvedOptions, CanaryBranch],
            ParentProtocol -> Lookup[collapsedResolvedOptions, ParentProtocol],
            Priority -> Lookup[collapsedResolvedOptions, Priority],
            StartDate -> Lookup[collapsedResolvedOptions, StartDate],
            HoldOrder -> Lookup[collapsedResolvedOptions, HoldOrder],
            QueuePosition -> Lookup[collapsedResolvedOptions, QueuePosition],
            Cache -> cacheBall
          ];

          (* Note: what we are doing here is to create upload packets for new model cell *)
          newCellModelPackets = Module[
            {allPopulationIdentities, allPopulationCellTypes, newCellModelNames, newCellTypes, userSpecifiedQ, yeastModelNames, bacterialModelNames},
            (* Pull expanded resolved PopulationIdentities and PopulationCellTypes options *)
            allPopulationIdentities = Lookup[resolvedOptions, PopulationIdentities];
            allPopulationCellTypes = Lookup[resolvedOptions, PopulationCellTypes];
            (* Extract index-matched options where at least one string is resolved *)
            newCellModelNames = Cases[allPopulationIdentities, {___, _String, ___}|_String];
            newCellTypes = PickList[allPopulationCellTypes, allPopulationIdentities, {___, _String, ___}|_String];
            (* Check if the new name is automatic from resolver(expandedNonHiddenOptions) or from user(expandedSafeOps) *)
            userSpecifiedQ = MatchQ[#, {Except[Automatic]..}|Except[Automatic]]& /@ PickList[Lookup[expandedSafeOps, PopulationIdentities], allPopulationIdentities, {___, _String, ___}|_String];
            (* Add protocol ID to each model name if not specified by user *)
            {yeastModelNames, bacterialModelNames, newCellReplacementRules} = If[!MatchQ[newCellModelNames, {}],
              Transpose@MapThread[
                Function[{indexCellModelNames, indexCellTypes, indexSpecifiedQ},
                  Module[{indexAllNames, indexAllCellTypes, indexYeastNames, indexBacterialNames, nameReplacementRules},
                    (* Note: indexCellModelNames can either be a string of a list *)
                    indexAllNames = Cases[ToList[indexCellModelNames], _String];
                    indexAllCellTypes = PickList[ToList[indexCellTypes], ToList[indexCellModelNames], _String];
                    {indexYeastNames, indexBacterialNames, nameReplacementRules} = Transpose@MapThread[
                      Which[
                        TrueQ[indexSpecifiedQ] && MatchQ[#2, Yeast],
                          {#1, Null, {}},
                        TrueQ[indexSpecifiedQ] && MatchQ[#2, Bacterial],
                          {Null, #1, {}},
                        MatchQ[#2, Yeast],
                          {StringJoin[#1, " from ", ObjectToString@protocolID], Null, {#1 -> StringJoin[#1, " from ", ObjectToString@protocolID]}},
                        True,
                          {Null, StringJoin[#1, " from ", ObjectToString@protocolID], {#1 -> StringJoin[#1, " from ", ObjectToString@protocolID]}}
                      ]&,
                      {indexAllNames, indexAllCellTypes}
                    ];
                    {indexYeastNames, indexBacterialNames, Flatten[nameReplacementRules]}
                  ]
                ],
                {newCellModelNames, newCellTypes, userSpecifiedQ}
              ],
              {{}, {}, {}}
            ];
            {
              {
                If[!MatchQ[Flatten@yeastModelNames, {Null...} | {}],
                  UploadYeastCell[
                    Cases[Flatten@yeastModelNames, Except[Null]],
                    CellType -> Yeast,
                    CultureAdhesion -> SolidMedia,
                    BiosafetyLevel -> "BSL-2",
                    Flammable -> False,
                    MSDSRequired -> False,
                    IncompatibleMaterials -> {None},
                    Upload -> False
                  ],
                  Nothing
                ],
                If[!MatchQ[Flatten@bacterialModelNames, {Null...} | {}],
                  UploadBacterialCell[
                    Cases[Flatten@bacterialModelNames, Except[Null]],
                    CellType -> Bacterial,
                    Morphology -> Cocci,
                    CultureAdhesion -> SolidMedia,
                    BiosafetyLevel -> "BSL-2",
                    Flammable -> False,
                    MSDSRequired -> False,
                    IncompatibleMaterials -> {None},
                    Upload -> False
                  ],
                  Nothing
                ]
              }
            }
          ];
          (* Upload new cell models to constellation *)
          Upload[Flatten@newCellModelPackets];

          (* Update the OutputUnitOperation PopulationIdentities option values with updated strings containing ProtocolID *)
          (* For robotic branch, there is one and only OutputUnitOperation in unitOperationPackets *)
          If[!MatchQ[Flatten@newCellReplacementRules, {}],
            Module[{previousPopulationIdentities},
              previousPopulationIdentities = Download[Download[unitOperationPacket, Object], PopulationIdentities];
              Upload[<|
                Object -> Download[unitOperationPacket, Object],
                Replace[PopulationIdentities] -> (previousPopulationIdentities/.Flatten[newCellReplacementRules])
              |>]
            ]
          ];

          (* Return ID *)
          protocolID
        ]
      ],

    (* If we're doing Preparation->Manual, actually upload our protocol object. *)
    True,
      (* NOTE: If Preparation->Manual, we don't have auxiliary unit operation packets since there aren't batches. *)
      (* We only have unit operation packets when doing robotic. *)
      Module[
        {protocolID, newCellModelPackets, newCellReplacementRules},
        protocolID = UploadProtocol[
          protocolPacket,
          Upload -> upload,
          Confirm -> confirm,
          CanaryBranch -> canaryBranch,
          ParentProtocol -> parentProtocol,
          Priority -> priority,
          StartDate -> startDate,
          HoldOrder -> holdOrder,
          QueuePosition -> queuePosition,
          ConstellationMessage -> Object[Protocol, QuantifyColonies],
          Cache -> cacheBall,
          Simulation -> updatedSimulation
        ];
        (* To avoid creating NEW cell model every time in option resolver, we do it right after protocol generation *)
        (* Note: what we are doing here is to create upload packets for new model cell *)
        newCellModelPackets = Module[
        {allPopulationIdentities, allPopulationCellTypes, newCellModelNames, newCellTypes, userSpecifiedQ, yeastModelNames, bacterialModelNames},
        (* Pull expanded resolved PopulationIdentities and PopulationCellTypes options *)
        allPopulationIdentities = Lookup[resolvedOptions, PopulationIdentities];
        allPopulationCellTypes = Lookup[resolvedOptions, PopulationCellTypes];
        (* Extract index-matched options where at least one string is resolved *)
        newCellModelNames = Cases[allPopulationIdentities, {___, _String, ___}|_String];
        newCellTypes = PickList[allPopulationCellTypes, allPopulationIdentities, {___, _String, ___}|_String];
        (* Check if the new name is automatic from resolver(expandedNonHiddenOptions) or from user(expandedSafeOps) *)
        userSpecifiedQ = MatchQ[#, {Except[Automatic]..}|Except[Automatic]]& /@ PickList[Lookup[expandedSafeOps, PopulationIdentities], allPopulationIdentities, {___, _String, ___}|_String];
        (* Add protocol ID to each model name if not specified by user *)
        {yeastModelNames, bacterialModelNames, newCellReplacementRules} = If[!MatchQ[newCellModelNames, {}],
          Transpose@MapThread[
            Function[{indexCellModelNames, indexCellTypes, indexSpecifiedQ},
              Module[{indexAllNames, indexAllCellTypes, indexYeastNames, indexBacterialNames, nameReplacementRules},
                (* Note: indexCellModelNames can either be a string of a list *)
                indexAllNames = Cases[ToList[indexCellModelNames], _String];
                indexAllCellTypes = PickList[ToList[indexCellTypes], ToList[indexCellModelNames], _String];
                {indexYeastNames, indexBacterialNames, nameReplacementRules} = Transpose@MapThread[
                  Which[
                    TrueQ[indexSpecifiedQ] && MatchQ[#2, Yeast],
                      {#1, Null, {#1 -> Model[Cell, Yeast, #1]}},
                    TrueQ[indexSpecifiedQ] && MatchQ[#2, Bacterial],
                      {Null, #1, {#1 -> Model[Cell, Bacteria, #1]}},
                    MatchQ[#2, Yeast],
                      {StringJoin[#1, " from ", ObjectToString@protocolID], Null, {#1 -> Model[Cell, Yeast, StringJoin[#1, " from ", ObjectToString@protocolID]]}},
                    True,
                      {Null, StringJoin[#1, " from ", ObjectToString@protocolID], {#1 -> Model[Cell, Bacteria, StringJoin[#1, " from ", ObjectToString@protocolID]]}}
                  ]&,
                  {indexAllNames, indexAllCellTypes}
                ];
                {indexYeastNames, indexBacterialNames, Flatten[nameReplacementRules]}
              ]
            ],
            {newCellModelNames, newCellTypes, userSpecifiedQ}
          ],
          {{}, {}, {}}
        ];
        {
          {
            If[!MatchQ[Flatten@yeastModelNames, {Null...} | {}],
              UploadYeastCell[
                Cases[Flatten@yeastModelNames, Except[Null]],
                CellType -> Yeast,
                CultureAdhesion -> SolidMedia,
                BiosafetyLevel -> "BSL-2",
                Flammable -> False,
                MSDSRequired -> False,
                IncompatibleMaterials -> {None},
                Upload -> False
              ],
              Nothing
            ],
            If[!MatchQ[Flatten@bacterialModelNames, {Null...} | {}],
              UploadBacterialCell[
                Cases[Flatten@bacterialModelNames, Except[Null]],
                CellType -> Bacterial,
                Morphology -> Cocci,
                CultureAdhesion -> SolidMedia,
                BiosafetyLevel -> "BSL-2",
                Flammable -> False,
                MSDSRequired -> False,
                IncompatibleMaterials -> {None},
                Upload -> False
              ],
              Nothing
            ]
          }
        }
      ];
        (* Upload new cell models to constellation *)
        Upload[Flatten@newCellModelPackets];

        (* Update the protocol PopulationIdentities field values with new Model[Cell]s *)
        If[!MatchQ[Flatten@newCellModelPackets, {}],
          Module[{previousPopulationIdentities},
            previousPopulationIdentities = Download[Lookup[protocolPacket, Replace[PopulationIdentities]], Object];
            Upload[<|
              Object -> protocolID,
              Replace[PopulationIdentities] -> Link /@ (previousPopulationIdentities/.Flatten[newCellReplacementRules])
            |>]
          ]
        ];

        (* Return ID *)
        protocolID
    ]
  ];

  (* Return requested output. *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentQuantifyColonies, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> updatedSimulation,
    RunTime -> runTime
  }
];

(* Container Overload *)
ExperimentQuantifyColonies[myContainers: ListableP[ObjectP[{Object[Container], Object[Sample]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}], myOptions: OptionsPattern[ExperimentQuantifyColonies]] := Module[
  {
    outputSpecification, output, gatherTests, messages, listedInputs, listedOptions, updatedSimulation, containerToSampleResult,
    containerToSampleOutput, containerToSampleSimulation, containerToSampleTests, samples, sampleOptions
  },

  (* Determine the requested return value from the function. *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Make sure we're working with a list of options/inputs. *)
  {listedInputs, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Lookup simulation option if it exists *)
  updatedSimulation = Lookup[listedOptions, Simulation, Null];

  (* Note: we do not have sample prep options, not check validSamplePrep here *)

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentQuantifyColonies,
      listedInputs,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> updatedSimulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentQuantifyColonies,
        listedInputs,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> updatedSimulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainer, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* If containerToSampleOptions failed - return $Failed. *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> updatedSimulation,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentQuantifyColonies[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];

(* Make some small helper functions *)
(* ::Subsubsection:: *)
(*imagingStrategiesFromPopulations*)

imagingStrategiesFromPopulations[myPopulations:{(_Diameter|_Fluorescence|_BlueWhiteScreen|_Isolation|_Regularity|_Circularity|_MultiFeatured|_AllColonies|CustomCoordinates)..}] := Module[
  {uniqueImagingStrategiesFromPopulations, imagingChannelToStrategiesReplacements},

  (* Convert filter wavelength and excitation/emission wavelengths to ImagingStrategies *)
  imagingChannelToStrategiesReplacements = {
    400 Nanometer -> BlueWhiteScreen,
    {377 Nanometer, 447 Nanometer} -> VioletFluorescence,
    {457 Nanometer, 536 Nanometer} -> GreenFluorescence,
    {531 Nanometer, 593 Nanometer} -> OrangeFluorescence,
    {531 Nanometer, 624 Nanometer} -> RedFluorescence,
    {628 Nanometer, 692 Nanometer} -> DarkRedFluorescence
  };

  (* Extract any imaging channels from the population primitives *)
  uniqueImagingStrategiesFromPopulations = DeleteDuplicates[Flatten[Map[Function[{populationsValue},
    If[MatchQ[populationsValue, Except[CustomCoordinates]],
      Module[{populationPrimitiveAssociation, imagingChannelsFromPopulations},

        (* Convert from Blob form to association form *)
        populationPrimitiveAssociation = populationsValue[[1]];

        (* Switch based on the type of population primitive we have *)
        imagingChannelsFromPopulations = Switch[Head[populationsValue],

          (* For a FluorescencePrimitive *)
          Fluorescence,
            Module[{excitationWavelength, emissionWavelength},

              (* Lookup the Excitation and Emission wavelength *)
              {excitationWavelength, emissionWavelength} = Lookup[populationPrimitiveAssociation, {ExcitationWavelength, EmissionWavelength}];

              (* Pair them up and return *)
              {{excitationWavelength, emissionWavelength}}
            ],

          (* For an BlueWhiteScreenPrimitive *)
          BlueWhiteScreen,
            (* Return the Absorbance wavelength *)
            {Lookup[populationPrimitiveAssociation, FilterWavelength]},

          (* For a MultiFeatured Primitive *)
          MultiFeatured,
            Module[
              {
                features, excitationWavelengths, emissionWavelengths, absorbanceWavelengths,
                imagingFeaturePickList, imagingChannelsFromFluorescenceFeatures, imagingChannelsFromAbsorbanceFeatures
              },
              (* Lookup the Features and Wavelengths *)
              {
                features,
                excitationWavelengths,
                emissionWavelengths,
                absorbanceWavelengths
              } = Lookup[populationPrimitiveAssociation,
                {
                  Features,
                  ExcitationWavelength,
                  EmissionWavelength,
                  FilterWavelength
                }
              ];

              (* Generate a pick list of features that are imaging channels *)
              imagingFeaturePickList = (MatchQ[#, Fluorescence|BlueWhiteScreen|BrightField])& /@ features;

              (* use the pick list to extract the fluorescent channels to image on *)
              (* Note we have Null or Automatic as Fluorescence*Wavelength if MultiFeatured has some other primitives *)
              imagingChannelsFromFluorescenceFeatures = If[MatchQ[excitationWavelengths, _List] && MatchQ[emissionWavelengths, _List] && SameLengthQ[excitationWavelengths,imagingFeaturePickList]||!SameLengthQ[emissionWavelengths, imagingFeaturePickList],
                Transpose[{
                  PickList[excitationWavelengths, imagingFeaturePickList],
                  PickList[emissionWavelengths, imagingFeaturePickList]
                }]/.{{Null, Null} -> Nothing, {Automatic, Automatic} -> Nothing},
                {}

              ];

              (* use the pick list to extract the absorbance channels to image on *)
              (* Note we have Null or Automatic as Wavelength if MultiFeatured has some other primitives *)
              imagingChannelsFromAbsorbanceFeatures = If[MatchQ[absorbanceWavelengths, _List] && SameLengthQ[absorbanceWavelengths, imagingFeaturePickList],
                PickList[absorbanceWavelengths, imagingFeaturePickList]/.{Null -> Nothing, Automatic -> Nothing},
                {}
              ];

              (* Join the lists and return *)
              DeleteCases[Join[imagingChannelsFromFluorescenceFeatures, imagingChannelsFromAbsorbanceFeatures], Null]
            ],

          (* For any other primitive - no extra images *)
          _,
            {}
        ];

        (* Convert ImagingChannels to ImagingStrategies *)
        (* Prepend BrightField to the detected images as the BrightField image is always taken *)
        Prepend[imagingChannelsFromPopulations, BrightField]/.imagingChannelToStrategiesReplacements
      ],
      {BrightField}
    ]
  ],
    myPopulations
  ], 1]]
];

(* ::Subsubsection:: *)
(*selectMainCellFromSample*)

DefineOptions[selectMainCellFromSample,
  Options :> {
    {CellType -> Automatic, Automatic |  {(CellTypeP|Null)..} | {{(CellTypeP|Null)..}..}, "The list of cell type(s) specified as the main cell type for samples. If not specified, all Model[Cell] will be checked."},
    CacheOption,
    SimulationOption,
    HelperOutputOption
  }
];

Error::OptionLengthDisagreement = "The option CellType do not have the same length as input samples. Please check that the lengths of any listed options match.";

(* The basic logic is similar to selectAnalyteFromSample *)
(* if Analytes/Composition field is populated with one Model[Cell] matching CellType option, pick the value there *)
(* if multiple Model[Cell]s exist, pick the Model[Cell] with the highest concentration in the Composition field matching CellType option *)
(* otherwise, pick Null *)
selectMainCellFromSample[mySample: ObjectP[{Object[Sample], Model[Sample]}], ops: OptionsPattern[]] := selectMainCellFromSample[{mySample}, ops];
selectMainCellFromSample[mySamples: {ObjectP[{Object[Sample], Model[Sample]}]..}, ops: OptionsPattern[]] := Module[
  {
    safeOps, cache, simulation, outputSpecification, specifiedCellTypes, expandedCellTypes,
    output, gatherTests, messages, allPackets,	cellTypesPerComposition, cellIdentityP,
    componentToCellType, analyteObjs, compositionObjs, ambiguousQ, mainCellModel
  },

  (* Get the Cache and Output options *)
  safeOps = SafeOptions[selectMainCellFromSample, ToList[ops]];
  {cache, simulation, outputSpecification, specifiedCellTypes} = Lookup[safeOps, {Cache, Simulation, Output, CellType}];

  (* All Identity models for cells *)
  cellIdentityP = {Mammalian, Bacterial, Yeast};

  (* Expand specifiedCellTypes to be the same length as mySamples *)
  expandedCellTypes = Which[
    MatchQ[specifiedCellTypes, Automatic],
      ConstantArray[cellIdentityP, Length[mySamples]],
    MatchQ[specifiedCellTypes, {{CellTypeP..}..}],
      specifiedCellTypes,
    True,
      ConstantArray[specifiedCellTypes, Length[mySamples]]
  ];

  (* Figure out whether to gather the tests and throw messages *)
  output = ToList[outputSpecification];
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Throw aen error if analyte option and input have different length *)
  If[messages && !EqualQ[Length@expandedCellTypes, Length@mySamples],
    Message[Error::OptionLengthDisagreement]
  ];

  (* Get the composition and analytes fields from all the input samples or models *)
  {allPackets, cellTypesPerComposition} = Transpose@Quiet[
    Download[
      mySamples,
      {
        Packet[Analytes, Composition, CellType],
        Composition[[All, 2]][CellType]
      },
      Cache -> cache,
      Simulation -> simulation,
      Date -> Now
    ],
    {Download::FieldDoesntExist, Download::MissingField, Download::MissingCacheField}
  ];

  (* Get the analyte objects and the composition objects *)
  analyteObjs = Download[Lookup[#, Analytes], Object]& /@ allPackets;
  compositionObjs = Download[Lookup[#, Composition][[All, 2]], Object]& /@ allPackets;

  (* Build an association of the Model[Molecule]->CellType *)
  componentToCellType = Association[Rule @@@ Transpose[{Flatten[compositionObjs, 1], Flatten[cellTypesPerComposition, 1]}]];

  (* Decide whether the analyte choices are ambiguous (i.e., more than one object in Analytes or Composition *)
  (* For ambiguous case, we need to sort and check concentration later *)
  ambiguousQ = MapThread[
    Function[{composition, analytes, cellTypes},
      Or[
        !MatchQ[analytes, {}] && Length[Cases[Lookup[componentToCellType, analytes], Alternatives @@ cellTypes]] > 1,
        MatchQ[analytes, {}] && Length[Cases[Lookup[componentToCellType, composition], Alternatives @@ cellTypes]] > 1
      ]
    ],
    {compositionObjs, analyteObjs, expandedCellTypes}
  ];

  (* Parse the Analytes and Composition fields to find the correct analytes/components to use *)
  mainCellModel = MapThread[
    Function[{composition, analytes, samplePacket, checkConcentrationQ, cellTypes},
      If[TrueQ[checkConcentrationQ],
        Module[
          {
            componentAmounts, componentIdentities, potentialComponentIdentities, potentialComponentConcentrations,
            sortedTalledUnits, mostCommonUnit, cellConcentrationUnitPattern, convertedConcentrations, reverseSortedIdentityModels
          },
          componentAmounts = Lookup[samplePacket, Composition, {}][[All, 1]];
          componentIdentities = Download[Lookup[samplePacket, Composition, {}][[All, 2]], Object];
          (* Extract only components meet the requirement of cell types *)
          potentialComponentIdentities = PickList[componentIdentities, Lookup[componentToCellType, componentIdentities], Alternatives @@ cellTypes];
          potentialComponentConcentrations = PickList[componentAmounts, Lookup[componentToCellType, componentIdentities], Alternatives @@ cellTypes];
          sortedTalledUnits = ReverseSortBy[Tally[Units[potentialComponentConcentrations]], Last][[All, 1]];
          mostCommonUnit = FirstOrDefault@sortedTalledUnits;
          (* Convert the concentration unit in potentialComponentConcentrations to the same unit if mostCommonUnit is a cell unit *)
          cellConcentrationUnitPattern = Alternatives @@ (UnitsP /@ Alternatives[OD600, Cell/Milliliter, CFU/Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit]);
          convertedConcentrations = If[MatchQ[mostCommonUnit,  cellConcentrationUnitPattern] && MatchQ[sortedTalledUnits,  {cellConcentrationUnitPattern..}],
            (* using standard curve from each component. If failed, just use whatever unit without conversion *)
            Quiet[
              ConvertCellConcentration[potentialComponentConcentrations, mostCommonUnit, potentialComponentIdentities],
              {Error::NoCompatibleStandardCurveInCellModel}
            ]/.$Failed -> potentialComponentConcentrations,
            potentialComponentConcentrations
          ];
          (* Sort the Model[Cell] based on concentration, highest concentration first *)
          reverseSortedIdentityModels = ReverseSortBy[Transpose[{convertedConcentrations, potentialComponentIdentities}], First][[All, 2]];
          FirstOrDefault@reverseSortedIdentityModels
        ],
        (* If we do not need to look up concentration, just find the key whose value is the required cell type *)
        If[MatchQ[analytes, {}],
          FirstOrDefault@Keys[Select[KeyTake[componentToCellType, composition], MatchQ[#, Alternatives @@ cellTypes]&]],
          FirstOrDefault@Keys[Select[KeyTake[componentToCellType, analytes], MatchQ[#, Alternatives @@ cellTypes]&]]
        ]
      ]
    ],
    {compositionObjs, analyteObjs, allPackets, ambiguousQ, expandedCellTypes}
  ];

  outputSpecification /. Result -> mainCellModel
];

(* ::Subsubsection:: *)
(*lookUpCellTypes*)

DefineOptions[lookUpCellTypes,
  Options :> {
    CacheOption,
    HelperOutputOption
  }
];


(* The helper function is used in IncubateCells,FreezeCells,ImageColonies and QuantifyColonies *)
lookUpCellTypes[mySamplePackets: {PacketP[Object[Sample]]..}, mySampleModelPackets: {(PacketP[Model[Sample]]|Null)..}, myCellModels: {(ObjectP[Model[Cell]]|Null)..}, ops: OptionsPattern[]] := Module[
  {
    safeOps, cache, outputSpecification, specifiedCellTypes, output, gatherTests, messages
  },

  (* Get the Cache and Output options *)
  safeOps = SafeOptions[lookUpCellTypes, ToList[ops]];
  {cache, outputSpecification, specifiedCellTypes} = Lookup[safeOps, {Cache, Output, CellType}];

  (* Figure out whether to gather the tests and throw messages *)
  output = ToList[outputSpecification];
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  MapThread[
    Function[{samplePacket, modelPacket, mainCellIdentityModel},
      Which[
        MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
        !NullQ[modelPacket] && MatchQ[Lookup[modelPacket, CellType], CellTypeP] && MatchQ[modelPacket, PacketP[]], Lookup[modelPacket, CellType],
        MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]], Lookup[fetchPacketFromCache[mainCellIdentityModel, cache], CellType],
        True, Null
      ]
    ],
    {mySamplePackets, mySampleModelPackets, myCellModels}
  ]
];

(* ::Subsubsection:: *)
(*validqPixContainer*)
validqPixContainer[myContainerModelPacket: PacketP[Model[Container]]] := validqPixContainer[{myContainerModelPacket}];
validqPixContainer[myContainerModelPackets: {PacketP[Model[Container]]..}] := Module[{},
  (* Check if the container model is SBS plate and only has 1 well *)
  Map[
    If[Or[
      !MatchQ[Lookup[#, Type], Model[Container, Plate]],
      !MatchQ[Lookup[#, Dimensions], {RangeP[0.126 Meter, 0.129 Meter], RangeP[0.084 Meter, 0.087 Meter], _}],
      !MatchQ[Lookup[#, NumberOfWells], 1]
    ],
      False,
      True
    ]&,
    myContainerModelPackets
  ]
];

(* ::Subsubsection:: *)
(*exclusivePopulationsQ*)
exclusivePopulationsQ[myPopulation: Alternatives[ColonySelectionFeatureP, All, ColonySelectionPrimitiveP, CustomCoordinates]] := True;
exclusivePopulationsQ[myPopulations: {Alternatives[ColonySelectionFeatureP, All, ColonySelectionPrimitiveP, CustomCoordinates]..}] := Module[{},
  Which[
    Length[myPopulations] == 1,
      (* If there is only 1 population *)
      True,
    MemberQ[myPopulations, CustomCoordinates] && !MatchQ[DeleteCases[myPopulations, CustomCoordinates], {}],
      (* If custom coordinates of 1 population is specified, it cannot be mutually exclusive *)
      False,
    MemberQ[myPopulations, All|_AllColonies] && !MatchQ[DeleteCases[myPopulations, All|_AllColonies], {}],
    (* If 1 population is specified as all colonies, it cannot be mutually exclusive *)
      False,
    Length[myPopulations] > 1,
      (* If there are duplicates ColonySelectionPrimitiveP *)
      DuplicateFreeQ[
        Map[
          Function[{populationValue},
            Module[{populationPrimitive, uniquePopulationName, toUpdateName},
              (* Make sure that we turn all of the population symbols into blobs *)
              populationPrimitive = Switch[populationValue,
                Fluorescence, Fluorescence[NumberOfColonies -> All],
                BlueWhiteScreen, BlueWhiteScreen[NumberOfColonies -> All],
                Diameter, Diameter[NumberOfColonies -> All],
                Circularity, Circularity[NumberOfColonies -> All],
                Regularity, Regularity[NumberOfColonies -> All],
                Isolation, Isolation[NumberOfColonies -> All],
                AllColonies, AllColonies[NumberOfColonies -> All],
                MultiFeatured, MultiFeatured[NumberOfColonies -> All],
                _, populationValue
              ];
              uniquePopulationName = Lookup[populationPrimitive[[-1]], PopulationName, "colony 1"];
              toUpdateName = "colony 1";
              (* PopulationName is unique even if the population criteria is the same, we need to remove it before checking duplicates *)
              populationPrimitive/. {uniquePopulationName -> toUpdateName}
            ]
          ],
          myPopulations
        ]
      ],
    True,
      True
  ]
];


(* ::Subsection::Closed:: *)
(*Option Resolver*)

(* ::Subsubsection::Closed:: *)
(*resolveExperimentQuantifyColoniesOptions*)


(* ::Code::Initialization:: *)
DefineOptions[
  resolveExperimentQuantifyColoniesOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentQuantifyColoniesOptions[
  mySamples: {ObjectP[Object[Sample]]...},
  myOptions: {_Rule...},
  myResolutionOptions: OptionsPattern[resolveExperimentQuantifyColoniesOptions]
] := Module[
  {
    (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
    outputSpecification, output, gatherTests, messages, cacheBall, currentSimulation, quantifyColoniesOptionsAssociation,
    samplePackets, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets, combinedFastAssoc,
    (*-- INPUT VALIDATION CHECKS --*)
    mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples, invalidCellTypePositions,
    invalidCellTypeCellTypes, invalidCellTypeTest, discardedSamplePackets, discardedInvalidInputs, discardedTest,
    deprecatedSampleModelPackets, deprecatedInvalidInputs, deprecatedTest, nonSolidSamplePackets, nonSolidInvalidInputs,
    nonSolidTest, liquidMediaSamples, freezeDriedSamples, frozenGlycerolSamples, nonLiquidInvalidInputs, nonLiquidTest,
    validContainerSampleQ, invalidContainerSampleInputs, invalidContainerTest, duplicatedInvalidInputs, duplicatesTest,
    (*-- OPTION PRECISION CHECKS --*)
    optionPrecisions, roundedQuantifyColoniesOptions, optionPrecisionTests, suppliedSpreadCellOptions, suppliedIncubationOptions,
    optionsForPreparingSample,
    (*-- RESOLVE INDEPENDENT OPTIONS --*)
    preparedSample, suppliedImager, suppliedSpreaderInstrument, suppliedIncubator, suppliedDilutionType, suppliedDilutionStrategy,
    suppliedNumberOfDilutions, suppliedCumulativeDilutionFactor, suppliedSerialDilutionFactor, suppliedColonySpreadingTool,
    suppliedSpreadVolume, suppliedDispenseCoordinates, suppliedSpreadPatternType, suppliedCustomSpreadPattern,
    suppliedDestinationContainer, suppliedDestinationWell, suppliedDestinationMedia, suppliedSampleOutLabel, suppliedContainerOutLabel,
    suppliedIncubationCondition, suppliedTemperature, suppliedColonyIncubationTime, suppliedMaxColonyIncubationTime,
    suppliedIncubationInterval, suppliedMinReliableColonyCount, suppliedMaxReliableColonyCount, suppliedIncubateUntilCountable,
    suppliedNumberOfStableIntervals, suppliedMinDiameter, suppliedMaxDiameter, suppliedMinColonySeparation, suppliedMinRegularityRatio,
    suppliedMaxRegularityRatio, suppliedMinCircularityRatio, suppliedMaxCircularityRatio, suppliedImagingChannels, suppliedExposureTimes,
    suppliedPopulations, suppliedPopulationCellTypes, suppliedPopulationIdentities, resolvedPreparedSample, suppliedSamplesOutStorageCondition,
    resolvedPreparation, allowedPreparations, preparationTest, preparationResult, resolvedWorkCell, resolvedInstrument,
    resolvedMinReliableColonyCount, resolvedMaxReliableColonyCount, resolvedSampleLabels, resolvedSampleContainerLabels,
    resolvedAnalysisCriteria, userSpecifiedLabels,
    (* -- CONFLICTING OPTIONS CHECKS I-- *)
    preparedOnlyError, preparedOnlyTest, conflictingWorkCellAndPreparationOptions, conflictingWorkCellAndPreparationQ,
    conflictingWorkCellAndPreparationTest, conflictingPreparedSampleWithSpreadingErrors, conflictingPreparedSampleWithSpreadingOption,
    conflictingPreparedSampleWithSpreadingTest, conflictingPreparedSampleWithIncubationErrors, conflictingPreparedSampleWithIncubationOption,
    conflictingPreparedSampleWithIncubationTest, compatibleMaterialsBools, compatibleMaterialsTests,
    (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
    mapThreadFriendlyOptions, resolvedSpreadCellsOptions, spreadCellsTest, invalidSpreadCellOptions, invalidAnalysisOptions,
    strategiesMappingToChannels, overlappingPopulationErrors, ambiguousAllPopulationErrors, duplicatedIdentitiesErrors,
    conflictingCellTypeWithPopulationErrors, conflictingCellIdentitiesWithPopulationErrors, conflictingCellTypeWithIdentitiesErrors,
    imagingOptionSameLengthErrors, missingImagingStrategyInfos, resolvedImagingStrategies, resolvedImagingChannels,
    resolvedExposureTimes, resolvedPopulations, resolvedPopulationCellTypes, resolvedPopulationIdentities, resolvedAnalysisTests,
    (* -- CONFLICTING OPTIONS CHECKS II-- *)
    overlappingPopulationsOptions, overlappingPopulationsTests, conflictingCellTypeWithPopulationOptions,
    conflictingCellTypeWithPopulationTests, conflictingCellTypeWithIdentitiesOptions, conflictingIdentitiesWithPopulationOptions,
    conflictingIdentitiesWithPopulationTests, conflictingCellTypeWithIdentitiesTests, imagingOptionSameLengthOptions,
    imagingOptionSameLengthTests, missingImagingStrategiesOptions, missingImagingStrategyTests, resolvedIncubateCellsOptions,
    resolvedHiddenOptions, invalidIncubationConditionError, tooManyIncubationConditionError, incubatorCapacityError,
    incubationMaxTemperatureError, incubatorIsIncompatibleError, invalidIncubationConditionTest, tooManyIncubationConditionTest,
    incubatorIsIncompatibleTest,  incubatorCapacityTest, incubationMaxTemperatureTest, conflictingIncubationRepeatOptionQ,
    conflictingIncubationRepeatTest, unsuitableIncubationIntervalQ, unsuitableIncubationIntervalTest,
    (*-- UNRESOLVED OPTIONS CHECKS --*)
    namesAlreadyInUse, namesAlreadyInUseOptions, namesAlreadyInUseTest,
    duplicateFreeNameQ, duplicateNameOptions, duplicateNameTest, specifiedOperator, upload, specifiedEmail, specifiedName, resolvedEmail,
    resolvedOperator, nameInvalidBool, nameInvalidOption, nameInvalidTest,
    (*-- SUMMARY OF CHECKS --*)
    invalidInputs, invalidOptions, allTests, resolvedPostProcessingOptions, resolvedOptions
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
  (* Initialize the simulation if none exists *)
  currentSimulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Note: There is no sample prep options, no resolveSamplePrpOptionsNew is needed here *)

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  quantifyColoniesOptionsAssociation = Association[myOptions];

  (* Create combined fast assoc *)
  combinedFastAssoc = makeFastAssocFromCache[cacheBall];

  (* Pull out packets from the fast association *)
  samplePackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ mySamples;
  sampleModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ mySamples;
  sampleContainerPackets = fastAssocPacketLookup[combinedFastAssoc, #, Container]& /@ mySamples;
  sampleContainerModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, {Container, Model}]& /@ mySamples;

  (*-- INPUT VALIDATION CHECKS --*)

  (*--Unsupported Cell Type check--*)
  (* Get whether the input cell types are supported *)

  (* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
  mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> cacheBall, Simulation -> currentSimulation];

  (* Determine what kind of cells the input samples are *)
  sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> cacheBall];

  validCellTypeQs = MatchQ[#, Yeast|Bacterial]& /@ sampleCellTypes;
  invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
  invalidCellTypePositions = First /@ Position[validCellTypeQs, False];
  invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

  If[Length[invalidCellTypeSamples] > 0 && messages,
    Message[Error::UnsupportedColonyTypes, ObjectToString[invalidCellTypeSamples, Cache -> cacheBall, Simulation -> currentSimulation], invalidCellTypePositions, invalidCellTypeCellTypes, "ExperimentQuantifyColonies", "ExperimentQuantifyCells"]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  invalidCellTypeTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[invalidCellTypeSamples] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall, Simulation -> currentSimulation] <> " are of supported cell types (Bacterial or Yeast):", True, False]
      ];

      passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall, Simulation -> currentSimulation] <> " are of supported cell types (Bacterial or Yeast):", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Discarded input check--*)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && messages,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " are not discarded:", True, False]
      ];

      passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " are not discarded:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];


  (*--Deprecated input check--*)
  (* Get the model packets from simulatedSamples that are deprecated *)
  deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];

  (* Set deprecatedInvalidInputs to the input objects whose models are Deprecated. *)
  deprecatedInvalidInputs = If[MatchQ[deprecatedSampleModelPackets, {}],
    {},
    PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[deprecatedInvalidInputs] > 0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[Lookup[deprecatedSampleModelPackets, Object], Cache -> cacheBall, Simulation -> currentSimulation]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " that are not deprecated:", True, False]
      ];

      passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples have models " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " that are not deprecated:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Non Solid input check--*)
  (* Get the samples from mySamples that do not have Solid state *)
  nonSolidSamplePackets = Cases[samplePackets, KeyValuePattern[State -> Except[Solid]]];

  (* Set nonSolidInvalidInputs to the input objects whose state is not Solid *)
  (* Note: if the sample is liquid, we will need to spread it on SolidMedia before imaging which is not possible for v1 *)
  nonSolidInvalidInputs = If[TrueQ[$QuantifyColoniesPreparedOnly],
    Lookup[nonSolidSamplePackets, Object, {}],
    {}
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[nonSolidInvalidInputs] > 0 && messages,
    Message[Error::NonSolidSamples, ObjectToString[nonSolidInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonSolidTest = If[gatherTests && TrueQ[$QuantifyColoniesPreparedOnly],
    Module[{failingTest, passingTest},
      failingTest = If[Length[nonSolidInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonSolidInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " are Solid State:", True, False]
      ];

      passingTest = If[Length[nonSolidInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, nonSolidInvalidInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " are Solid State:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Non Liquid input check--*)
  (* Classify each sample as a LiquidMedia source sample, FreezeDried source sample, or FrozenGlycerol source sample *)
  {
    liquidMediaSamples,
    freezeDriedSamples,
    frozenGlycerolSamples
  } = classifyStreakSpreadSampleTypes[mySamples, combinedFastAssoc];

  (* Set nonLiquidInvalidInputs to the input objects whose state is not Liquid *)
  (* Note: if the sample is liquid, we will need to spread it on SolidMedia before imaging which is not possible for v1 *)
  nonLiquidInvalidInputs = If[!TrueQ[Lookup[quantifyColoniesOptionsAssociation, PreparedSample]],
    Join[freezeDriedSamples, frozenGlycerolSamples],
    {}
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[nonLiquidInvalidInputs] > 0 && messages,
    Message[Error::NonLiquidSamples, ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonLiquidTest = If[gatherTests && !TrueQ[$QuantifyColoniesPreparedOnly],
    Module[{failingTest,passingTest},
      failingTest = If[Length[nonLiquidInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonLiquidInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " are Liquid State when to spread cells:", True, False]
      ];

      passingTest = If[Length[nonLiquidInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, nonLiquidInvalidInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " are Liquid State when to spread cells:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Invalid Input Container Model check--*)
  validContainerSampleQ = Flatten@MapThread[
    If[TrueQ[Lookup[quantifyColoniesOptionsAssociation, PreparedSample]] || TrueQ[$QuantifyColoniesPreparedOnly],
      (* Make sure all solid sample input containers are SBS plates and only has 1 well *)
      validqPixContainer[#2],
      (* Aliquot is allowed if we are to spread suspension samples *)
      True
    ]&,
    {samplePackets, sampleContainerModelPackets}
  ];

  invalidContainerSampleInputs =  If[MemberQ[validContainerSampleQ, False],
    PickList[samplePackets, validContainerSampleQ, False],
    {}
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[invalidContainerSampleInputs] > 0 && messages,
    Message[Error::NonOmniTrayContainer, ObjectToString[invalidContainerSampleInputs, Cache -> cacheBall, Simulation -> currentSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  invalidContainerTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[invalidContainerSampleInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[invalidContainerSampleInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " in a SBS format plate:", True, False]
      ];

      passingTest = If[Length[invalidContainerSampleInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidContainerSampleInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " in a SBS format plate:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Duplicated Input check--*)
  (* - Check if samples are duplicated (QuantifyColonies does not handle replicates.) - *)
  (* Get the samples that are duplicated. *)
  duplicatedInvalidInputs = Cases[Tally[mySamples], {_, Except[1]}][[All, 1]];

  (* If there are invalid inputs and we are throwing messages, throw an error message .*)
  If[Length[duplicatedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DuplicatedSamples, ObjectToString[duplicatedInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation], "ExperimentQuantifyColonies"]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  duplicatesTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[duplicatedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[duplicatedInvalidInputs, Cache -> cacheBall, Simulation -> currentSimulation]<>" are not listed more than once:", True, False]
      ];

      passingTest = If[Length[duplicatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, duplicatedInvalidInputs], Cache -> cacheBall, Simulation -> currentSimulation] <> " are not listed more than once:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*-- OPTION PRECISION CHECKS --*)
  (* Define the option precisions that need to be checked for ImageColonies *)
  optionPrecisions = {
    {ExposureTimes, 10^0*Millisecond},
    {MinDiameter, 10^-2*Millimeter},
    {MaxDiameter, 10^-2*Millimeter},
    {MinColonySeparation, 10^-2*Millimeter},
    {SpreadVolume, 10^0*Microliter},
    {DispenseCoordinates, 10^-1*Millimeter},
    {CustomSpreadPattern, 10^-1*Millimeter},
    {Temperature, 10^0*Celsius},
    {ColonyIncubationTime, 10^0*Minute},
    {MaxColonyIncubationTime, 10^0*Minute},
    {IncubationInterval, 10^0*Minute}
  };

  (* Check the precisions of these options. *)
  {roundedQuantifyColoniesOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[quantifyColoniesOptionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[quantifyColoniesOptionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All, 2]]], {}}
  ];


  (*--- Resolve non-IndexMatching General options ---*)
  (* Pull out options from myOptions. *)
  {
    (*1*)preparedSample,
    (*2*)suppliedImager,
    (*3*)suppliedSpreaderInstrument,
    (*4*)suppliedIncubator,
    (*5*)suppliedDilutionType,
    (*6*)suppliedDilutionStrategy,
    (*7*)suppliedNumberOfDilutions,
    (*8*)suppliedCumulativeDilutionFactor,
    (*9*)suppliedSerialDilutionFactor,
    (*10*)suppliedColonySpreadingTool,
    (*11*)suppliedSpreadVolume,
    (*12*)suppliedDispenseCoordinates,
    (*13*)suppliedSpreadPatternType,
    (*14*)suppliedCustomSpreadPattern,
    (*15*)suppliedDestinationContainer,
    (*16*)suppliedDestinationWell,
    (*17*)suppliedDestinationMedia,
    (*18*)suppliedSampleOutLabel,
    (*19*)suppliedContainerOutLabel,
    (*20*)suppliedIncubationCondition,
    (*21*)suppliedTemperature,
    (*22*)suppliedColonyIncubationTime,
    (*23*)suppliedMaxColonyIncubationTime,
    (*24*)suppliedIncubationInterval,
    (*25*)suppliedMinReliableColonyCount,
    (*26*)suppliedMaxReliableColonyCount,
    (*27*)suppliedIncubateUntilCountable,
    (*28*)suppliedNumberOfStableIntervals,
    (*29*)suppliedMinDiameter,
    (*30*)suppliedMaxDiameter,
    (*31*)suppliedMinColonySeparation,
    (*32*)suppliedMinRegularityRatio,
    (*33*)suppliedMaxRegularityRatio,
    (*34*)suppliedMinCircularityRatio,
    (*35*)suppliedMaxCircularityRatio,
    (*36*)suppliedImagingChannels,
    (*37*)suppliedExposureTimes,
    (*38*)suppliedPopulations,
    (*39*)suppliedPopulationCellTypes,
    (*40*)suppliedPopulationIdentities,
    (*41*)suppliedSamplesOutStorageCondition
  } = Lookup[roundedQuantifyColoniesOptions,
    {
      (*1*)PreparedSample,
      (*2*)ImagingInstrument,
      (*3*)SpreaderInstrument,
      (*4*)Incubator,
      (*5*)DilutionType,
      (*6*)DilutionStrategy,
      (*7*)NumberOfDilutions,
      (*8*)CumulativeDilutionFactor,
      (*9*)SerialDilutionFactor,
      (*10*)ColonySpreadingTool,
      (*11*)SpreadVolume,
      (*12*)DispenseCoordinates,
      (*13*)SpreadPatternType,
      (*14*)CustomSpreadPattern,
      (*15*)DestinationContainer,
      (*16*)DestinationWell,
      (*17*)DestinationMedia,
      (*18*)SampleOutLabel,
      (*19*)ContainerOutLabel,
      (*20*)IncubationCondition,
      (*21*)Temperature,
      (*22*)ColonyIncubationTime,
      (*23*)MaxColonyIncubationTime,
      (*24*)IncubationInterval,
      (*25*)MinReliableColonyCount,
      (*26*)MaxReliableColonyCount,
      (*27*)IncubateUntilCountable,
      (*28*)NumberOfStableIntervals,
      (*29*)MinDiameter,
      (*30*)MaxDiameter,
      (*31*)MinColonySeparation,
      (*32*)MinRegularityRatio,
      (*33*)MaxRegularityRatio,
      (*34*)MinCircularityRatio,
      (*35*)MaxCircularityRatio,
      (*36*)ImagingChannels,
      (*37*)ExposureTimes,
      (*38*)Populations,
      (*39*)PopulationCellTypes,
      (*40*)PopulationIdentities,
      (*41*)SamplesOutStorageCondition
    }
  ];
  (* Generate a list of SpreadCells options  *)
  suppliedSpreadCellOptions = {
    SpreaderInstrument -> suppliedSpreaderInstrument,
    DilutionType -> suppliedDilutionType,
    DilutionStrategy -> suppliedDilutionStrategy,
    NumberOfDilutions -> suppliedNumberOfDilutions,
    CumulativeDilutionFactor -> suppliedCumulativeDilutionFactor,
    SerialDilutionFactor -> suppliedSerialDilutionFactor,
    ColonySpreadingTool -> suppliedColonySpreadingTool,
    SpreadVolume -> suppliedSpreadVolume,
    DispenseCoordinates -> suppliedDispenseCoordinates,
    SpreadPatternType -> suppliedSpreadPatternType,
    CustomSpreadPattern -> suppliedCustomSpreadPattern,
    DestinationContainer -> suppliedDestinationContainer,
    DestinationWell -> suppliedDestinationWell,
    DestinationMedia -> suppliedDestinationMedia,
    SampleOutLabel -> suppliedSampleOutLabel,
    ContainerOutLabel -> suppliedContainerOutLabel,
    SamplesOutStorageCondition -> suppliedSamplesOutStorageCondition
  }/.{{Automatic..} -> Automatic, {{Automatic}...} -> Automatic};

  (* Generate a list of IncubateCells options  *)
  suppliedIncubationOptions = {
    Incubator -> suppliedIncubator,
    IncubationCondition -> suppliedIncubationCondition,
    Temperature -> suppliedTemperature,
    ColonyIncubationTime -> suppliedColonyIncubationTime,
    MaxColonyIncubationTime -> suppliedMaxColonyIncubationTime,
    IncubationInterval -> suppliedIncubationInterval,
    IncubateUntilCountable -> suppliedIncubateUntilCountable,
    NumberOfStableIntervals -> suppliedNumberOfStableIntervals
  };

  (* Get the list of option values that should not be specified when PreparedSample is True *)
  (* Note: all these options are to be resolved using ExperimentSpreadCells and ExperimentIncubateCells *)
  optionsForPreparingSample = Join[
    Values@suppliedSpreadCellOptions,
    Values@suppliedIncubationOptions
  ];

  (* Resolve master switch PreparedSample *)
  (* Determine if the input samples are in a prepared plate. *)
  resolvedPreparedSample = Which[
    (* Is PreparedSample specified by the user? *)
    !MatchQ[preparedSample, Automatic],
      preparedSample,
    (* Are all samples not solid? *)
    !MatchQ[nonSolidSamplePackets, {}],
      False,
    (* Is any SpreadCell or Incubation options specified? *)
    !MemberQ[Flatten@optionsForPreparingSample, Automatic],
      False,
    (* Otherwise *)
    True,
      True
  ];

  (* Resolve Preparation and WorkCell *)
  preparationResult = Check[
    {allowedPreparations, preparationTest} = If[gatherTests,
      resolveQuantifyColoniesMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> {Result, Tests}}]],
      {
        resolveQuantifyColoniesMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> Result}]],
        {}
      }
    ],
    $Failed
  ];
  resolvedPreparation = FirstOrDefault[allowedPreparations];
  resolvedWorkCell = FirstOrDefault[resolveQuantifyColoniesWorkCell[mySamples, ReplaceRule[myOptions, {Preparation -> resolvedPreparation}]]];

  (* Resolve the ImagingInstrument Option *)
  resolvedInstrument = suppliedImager;

  (* Resolve Analysis Option *)
  resolvedMinReliableColonyCount = Which[
    !MatchQ[suppliedMinReliableColonyCount, Automatic], suppliedMinReliableColonyCount,
    MatchQ[resolvedPreparedSample, False], 30,
    True, 1
  ];

  (* Extract the rounded value for analysis options. Note they all have default value so no resolver *)
  (* Note: error messages for AnalyzeColonies will be thrown later *)
  resolvedMaxReliableColonyCount = Lookup[roundedQuantifyColoniesOptions, MaxReliableColonyCount];

  (* Generate a list of resolved analysis options so we do not need to lookup in the mapthread *)
  resolvedAnalysisCriteria = Flatten@ Map[
    # -> Lookup[roundedQuantifyColoniesOptions, #]&,
    {
      MinRegularityRatio,
      MaxRegularityRatio,
      MinCircularityRatio,
      MaxCircularityRatio,
      MinDiameter,
      MaxDiameter,
      MinColonySeparation
    }
  ];

  (* Resolve label options *)
  (* Get all of the user specified labels. *)
  userSpecifiedLabels = DeleteDuplicates@Cases[
    Flatten@Lookup[
      roundedQuantifyColoniesOptions,
      {SampleLabel, SampleContainerLabel, PopulationIdentities}
    ],
    _String
  ];

  resolvedSampleLabels = Module[
    {specifiedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelLookup},

    (* Create a unique label for each unique sample in the input *)
    specifiedSampleObjects = Lookup[samplePackets, Object];
    uniqueSamples = DeleteDuplicates[specifiedSampleObjects];
    preResolvedSampleLabels = Table[CreateUniqueLabel["quantify colonies input sample", UserSpecifiedLabels -> userSpecifiedLabels], Length[uniqueSamples]];
    preResolvedSampleLabelLookup = MapThread[
      (#1 -> #2)&,
      {uniqueSamples, preResolvedSampleLabels}
    ];

    (* Expand the sample-specific unique labels *)
    MapThread[
      Function[{object, label},
        Which[
          (* respect user specification *)
          MatchQ[label, Except[Automatic]], label,
          (* respect upstream LabelSample/LabelContainer input *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object], _String], LookupObjectLabel[currentSimulation, object],
          (* get a label from the lookup *)
          True, Lookup[preResolvedSampleLabelLookup, object]
        ]
      ],
      {specifiedSampleObjects, Lookup[myOptions, SampleLabel]}
    ]
  ];

  resolvedSampleContainerLabels = Module[
    {specifiedContainerObjects, uniqueContainers, preResolvedSampleContainerLabels, preResolvedContainerLabelLookup},

    (* Create a unique label for each unique container in the input *)
    specifiedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
    uniqueContainers = DeleteDuplicates[specifiedContainerObjects];
    preResolvedSampleContainerLabels = Table[CreateUniqueLabel["quantify colonies input sample container", UserSpecifiedLabels -> userSpecifiedLabels], Length[uniqueContainers]];
    preResolvedContainerLabelLookup = MapThread[
      (#1 -> #2)&,
      {uniqueContainers, preResolvedSampleContainerLabels}
    ];

    (* Expand the sample-specific unique labels *)
    MapThread[
      Function[{object, label},
        Which[
          (* respect user specification *)
          MatchQ[label, Except[Automatic]], label,
          (* respect upstream LabelSample/LabelContainer input *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object], _String], LookupObjectLabel[currentSimulation, object],
          (* get a label from the lookup *)
          True, Lookup[preResolvedContainerLabelLookup, object]
        ]
      ],
      {specifiedContainerObjects, Lookup[myOptions, SampleContainerLabel]}
    ]
  ];

  (*--- CONFLICTING OPTIONS CHECKS I---*)

  (*--Feature flag check--*)
  (* If the $QuantifyColoniesPreparedOnly is set to True, no unprepared plate is accepted. *)
  preparedOnlyError = If[Not[gatherTests] && TrueQ[$QuantifyColoniesPreparedOnly] && MatchQ[resolvedPreparedSample, False],
    Message[Error::QuantifyColoniesPreparationNotSupported];
    {PreparedSample},
    {}
  ];

  preparedOnlyTest = If[Not[gatherTests] && TrueQ[$QuantifyColoniesPreparedOnly],
    Test["PreparedSample is not set to False while it is not yet supported:",
      resolvedPreparedSample,
      False
    ]
  ];

  (*--ConflictingWorkCellWithPreparation--*)
  (* If Preparation -> Robotic, WorkCell can't be Null.  If Preparation -> Manual, WorkCell can't be specified *)
  conflictingWorkCellAndPreparationQ = Or[
    MatchQ[resolvedPreparation, Robotic] && NullQ[resolvedWorkCell],
    MatchQ[resolvedPreparation, Manual] && !NullQ[resolvedWorkCell]
  ];
  (* NOT throwing this message if we already thew Error::ConflictingIncubationWorkCells because if that message got thrown than our work cell is always Null and so this will always get thrown too *)
  conflictingWorkCellAndPreparationOptions = If[conflictingWorkCellAndPreparationQ && Not[MatchQ[preparationResult, $Failed]] && messages,
    (
      Message[Error::ConflictingWorkCellWithPreparation, resolvedWorkCell, resolvedPreparation];
      {WorkCell, Preparation}
    ),
    {}
  ];
  conflictingWorkCellAndPreparationTest = If[gatherTests,
    Test["If Preparation -> Robotic, WorkCell must not be Null.  If Preparation -> Manual, WorkCell must not be specified:",
      conflictingWorkCellAndPreparationQ,
      False
    ]
  ];

  (*--ConflictingPreparedSampleWithSpreading--*)
  (* If PreparedSample-> True, spreading options can't be specified *)
  conflictingPreparedSampleWithSpreadingErrors = Map[
    If[
      Or[
        (* If there is a specified spreading cell option and PreparedSample is True, return the options that mismatch. *)
        !MatchQ[Values[#], ListableP[Automatic | Null]] && MatchQ[resolvedPreparedSample, True],
        (* If there is Null specified and PreparedSample is False, return the options that mismatch. *)
        And[
          MatchQ[Keys[#], SpreaderInstrument|ColonySpreadingTool|SpreadVolume|DispenseCoordinates|SpreadPatternType|DestinationContainer|DestinationMedia],
          NullQ[Values[#]],
          MatchQ[resolvedPreparedSample, False]
        ]
      ],
      {Keys[#], Values[#]},
      Nothing
    ]&,
    suppliedSpreadCellOptions
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
  If[Length[conflictingPreparedSampleWithSpreadingErrors] > 0 && messages,
    Message[
      Error::ConflictingPreparedSampleWithSpreading,
      ToString[conflictingPreparedSampleWithSpreadingErrors[[All, 1]]],
      ObjectToString[conflictingPreparedSampleWithSpreadingErrors[[All, 2]], Cache -> cacheBall, Simulation -> currentSimulation],
      resolvedPreparedSample
    ]
  ];

  conflictingPreparedSampleWithSpreadingOption = If[Length[conflictingPreparedSampleWithSpreadingErrors] > 0,
    Append[conflictingPreparedSampleWithSpreadingErrors[[All, 1]], PreparedSample],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedSampleWithSpreadingTest = If[gatherTests,
    Test["The spreading cell options are only specified when PreparedSample is False:",
      MatchQ[conflictingPreparedSampleWithSpreadingErrors, {}],
      True
    ],
    Nothing
  ];

  (*--ConflictingPreparedSampleWithIncubation--*)
  (* If PreparedSample-> True, incubation options can't be specified *)
  conflictingPreparedSampleWithIncubationErrors = Map[
    If[
      Or[
        (* If there is a specified incubate cell option and PreparedSample is True, return the options that mismatch. *)
        !MatchQ[Values[#], Automatic] && MatchQ[resolvedPreparedSample, True],
        (* If there is Null specified and PreparedSample is False, return the options that mismatch. *)
        And[
          MatchQ[Keys[#], Incubator|IncubationCondition|Temperature|ColonyIncubationTime|MaxColonyIncubationTime|IncubateUntilCountable],
          NullQ[Values[#]],
          MatchQ[resolvedPreparedSample, False]
        ]
      ],
      {Keys[#], Values[#]},
      Nothing
    ]&,
    suppliedIncubationOptions
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
  If[Length[conflictingPreparedSampleWithIncubationErrors] > 0 && messages,
    Message[
      Error::ConflictingPreparedSampleWithIncubation,
      ToString[conflictingPreparedSampleWithIncubationErrors [[All, 1]]],
      ObjectToString[conflictingPreparedSampleWithIncubationErrors [[All, 2]], Cache -> cacheBall, Simulation -> currentSimulation],
      resolvedPreparedSample
    ]
  ];

  conflictingPreparedSampleWithIncubationOption = If[Length[conflictingPreparedSampleWithIncubationErrors] > 0,
    Append[conflictingPreparedSampleWithIncubationErrors[[All, 1]], PreparedSample],
    {}
  ];
  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedSampleWithIncubationTest = If[gatherTests,
    Test["The incubate cell options are only specified when PreparedSample is False:",
      MatchQ[conflictingPreparedSampleWithIncubationErrors, {}],
      True
    ],
    Nothing
  ];

  (*--Compatible Material Check--*)
  (* Check that the input samples are compatible with the wetted materials of the resolved instrument *)
  {compatibleMaterialsBools, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[
      resolvedInstrument,
      mySamples,
      OutputFormat -> Boolean,
      Output -> {Result, Tests},
      Cache -> cacheBall,
      Simulation -> currentSimulation
    ],
    {
      CompatibleMaterialsQ[
        resolvedInstrument,
        mySamples,
        OutputFormat -> Boolean,
        Messages -> messages,
        Cache -> cacheBall,
        Simulation -> currentSimulation
      ],
      {}
    }
  ];


  (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentQuantifyColonies, roundedQuantifyColoniesOptions, AmbiguousNestedResolution -> IndexMatchingOptionPreferred];

  (* Resolve SpreadCell Options *)
  {resolvedSpreadCellsOptions, spreadCellsTest, invalidSpreadCellOptions} = If[TrueQ[resolvedPreparedSample] || TrueQ[$QuantifyColoniesPreparedOnly],
    (* If PreparedSample is True, all spread cells options should be Null if they are Automatic *)
    {
      suppliedSpreadCellOptions/. Automatic -> Null,
      {},
      {}
    },
    Module[
      {
        spreadCellsOptionNamesMap, spreadCellOptionsToPass, presolvedSpreadCellOptions, presolvedSpreadCellTest,
        invalidSpreadCellOption, expandedSpreadCellOptions, postsolvedSpreadCellOptions
      },

      (* SpreaderInstrument is for QuantifyColonies, change it to Instrument to pass to SpreadCells *)
      spreadCellsOptionNamesMap = {
        SpreaderInstrument -> Instrument
      };
      (* Update options to work with ExperimentSpreadCells *)
      spreadCellOptionsToPass = Map[
        Which[
          (* For options:SpreaderInstrument|ColonySpreadingTool|SpreadVolume|DispenseCoordinates|SpreadPatternType|DestinationContainer|DestinationMedia, *)
          (* they are not allowed to be Null by ExperimentSpreadCells but allowed here if PreparedSample is True *)
          (* We change the value to Automatic before passing them on and will change back *)
          MatchQ[Keys[#], SpreaderInstrument|ColonySpreadingTool|SpreadVolume|DispenseCoordinates|DestinationContainer|DestinationMedia],
            Keys[#] -> (Values[#]/.Null -> Automatic),
          (* Default value for SpreadPatternType is Spiral instead of Automatic in SpreadCells *)
          MatchQ[Keys[#], SpreadPatternType] && MatchQ[suppliedSpreadPatternType, {Automatic..}],
            SpreadPatternType -> Spiral,
          True,
            #
        ]&,
        suppliedSpreadCellOptions
      ];
      (* Initialize our error checking *)
      invalidSpreadCellOption = {};

      (* Pass options to SpreadCells to resolve and check *)
      (* Call ModifyFunctionMessages to resolve the options and modify any messages. *)
      {presolvedSpreadCellOptions, presolvedSpreadCellTest} = If[gatherTests,
        ExperimentSpreadCells[mySamples, Sequence @@ (spreadCellOptionsToPass/.SpreaderInstrument -> Instrument), InoculationSource -> LiquidMedia, Cache -> cacheBall, Simulation -> currentSimulation, Output -> {Options, Tests}],
        {
          Module[{resolvedOptions, invalidOptionsBool},
            {resolvedOptions, invalidOptionsBool, invalidSpreadCellOption} = Quiet[
              ModifyFunctionMessages[
                ExperimentSpreadCells,
                {mySamples},
                "",
                spreadCellsOptionNamesMap,
                Join[spreadCellOptionsToPass, {InoculationSource -> LiquidMedia, Upload -> False, Output -> Options}],
                Cache -> cacheBall,
                Simulation -> currentSimulation,
                Output -> {Result, Boolean, InvalidOptions}
              ],
              {Download::MissingCacheField}
              ];

            (* Return the options *)
            resolvedOptions
            ],
          {}
        }
      ];
      (* Expand presolvedSpreadCellOptions since options might have collapsed *)
      (* Note:SampleOutLabel, ContainerOutLabel should not be expanded again *)
      expandedSpreadCellOptions = Join[
        Last[ExpandIndexMatchedInputs[ExperimentSpreadCells, {mySamples}, Normal@KeyDrop[presolvedSpreadCellOptions, {SpreaderInstrument, SampleOutLabel, ContainerOutLabel}]]],
        {
          SpreaderInstrument -> Lookup[presolvedSpreadCellOptions, SpreaderInstrument],
          SampleOutLabel -> Lookup[presolvedSpreadCellOptions, SampleOutLabel],
          ContainerOutLabel -> Lookup[presolvedSpreadCellOptions, ContainerOutLabel]
        }
      ];

      (* Extract relevant options and tests *)
      postsolvedSpreadCellOptions = Map[
        (* For options:SpreaderInstrument|ColonySpreadingTool|SpreadVolume|DispenseCoordinates|SpreadPatternType|DestinationContainer|DestinationMedia, *)
        (* they are not allowed to be Null by ExperimentSpreadCells but allowed here if PreparedSample is True *)
        (* We change the value back to Null if they were specified as Null *)
        If[MatchQ[Keys[#], SpreaderInstrument|ColonySpreadingTool|SpreadVolume|DispenseCoordinates|DestinationContainer|DestinationMedia] && NullQ[Value[#]],
          Keys[#] -> Value[#],
          Keys[#] -> If[gatherTests, Lookup[expandedSpreadCellOptions, Keys[#]/.SpreaderInstrument -> Instrument], Lookup[expandedSpreadCellOptions, Keys[#]]]
        ]&,
        suppliedSpreadCellOptions
      ];
      (* Change the options we previous updated to Automatic back to specified values *)
      {
        {
          SpreaderInstrument -> Lookup[postsolvedSpreadCellOptions, SpreaderInstrument],
          DilutionType -> Lookup[postsolvedSpreadCellOptions, DilutionType],
          DilutionStrategy -> Lookup[postsolvedSpreadCellOptions, DilutionStrategy],
          NumberOfDilutions -> Lookup[postsolvedSpreadCellOptions, NumberOfDilutions],
          CumulativeDilutionFactor -> Lookup[postsolvedSpreadCellOptions, CumulativeDilutionFactor],
          SerialDilutionFactor -> Lookup[postsolvedSpreadCellOptions, SerialDilutionFactor],
          ColonySpreadingTool -> Lookup[postsolvedSpreadCellOptions, ColonySpreadingTool],
          SpreadVolume -> Lookup[postsolvedSpreadCellOptions, SpreadVolume],
          DispenseCoordinates -> Lookup[postsolvedSpreadCellOptions, DispenseCoordinates],
          SpreadPatternType -> Lookup[postsolvedSpreadCellOptions, SpreadPatternType],
          CustomSpreadPattern -> Lookup[postsolvedSpreadCellOptions, CustomSpreadPattern],
          DestinationContainer -> Lookup[postsolvedSpreadCellOptions, DestinationContainer],
          DestinationWell -> Lookup[postsolvedSpreadCellOptions, DestinationWell],
          DestinationMedia -> Lookup[postsolvedSpreadCellOptions, DestinationMedia],
          SampleOutLabel -> Lookup[postsolvedSpreadCellOptions, SampleOutLabel],
          ContainerOutLabel -> Lookup[postsolvedSpreadCellOptions, ContainerOutLabel]
        },
        presolvedSpreadCellTest,
        invalidSpreadCellOption
      }
    ]
  ];

  (* Lookup table for each imaging strategy what imaging channel it is corresponding to *)
  strategiesMappingToChannels = {
    BlueWhiteScreen -> 400 Nanometer,
    VioletFluorescence -> {377 Nanometer, 447 Nanometer},
    GreenFluorescence -> {457 Nanometer, 536 Nanometer},
    OrangeFluorescence -> {531 Nanometer, 593 Nanometer},
    RedFluorescence -> {531 Nanometer, 624 Nanometer},
    DarkRedFluorescence -> {628 Nanometer, 692 Nanometer}
  };

  (* MapThread over each of our samples *)
  {
    (*1*)invalidAnalysisOptions,
    (*2*)overlappingPopulationErrors,
    (*3*)ambiguousAllPopulationErrors,
    (*4*)duplicatedIdentitiesErrors,
    (*5*)conflictingCellTypeWithPopulationErrors,
    (*6*)conflictingCellIdentitiesWithPopulationErrors,
    (*7*)conflictingCellTypeWithIdentitiesErrors,
    (*8*)imagingOptionSameLengthErrors,
    (*9*)missingImagingStrategyInfos,
    (*10*)resolvedPopulations,
    (*11*)resolvedPopulationCellTypes,
    (*12*)resolvedPopulationIdentities,
    (*13*)resolvedAnalysisTests,
    (*14*)resolvedImagingStrategies,
    (*15*)resolvedImagingChannels,
    (*16*)resolvedExposureTimes
  } = Transpose[
    MapThread[
      Function[{existingSampleCellType, existingMainCellModel, samplePacket, myMapThreadOptions},
        Module[
          {
            specifiedPopulations, specifiedPopulationCellTypes, specifiedPopulationIdentities, specifiedImagingStrategies,
            specifiedImagingChannels, specifiedExposureTimes,
            (* -- ERROR TRACKING VARIABLES -- *)
            invalidAnalysisOption, overlappingPopulationError, ambiguousAllPopulationError, duplicatedIdentitiesError,
            conflictingCellTypeWithPopulationError, conflictingCellIdentitiesWithPopulationError,
            conflictingCellTypeWithIdentitiesError, missingImagingStrategyInfo, imagingOptionSameLengthError,
            (* Analysis *)
            dataAppearanceColoniesPacket, semiUpdatedPopulations, updatedAnalysisOption, updatedAnalysisTest, updatedPopulations,
            updatedPopulationCellTypes, updatedPopulationIdentities, updatedPopulationsWithIdentities,
            (* Imaging *)
            updatedImagingStrategies, updatedImagingChannels, updatedExposureTimes
          },

          (* Look up the option values *)
          {
            specifiedPopulations,
            specifiedPopulationCellTypes,
            specifiedPopulationIdentities,
            specifiedImagingStrategies,
            specifiedImagingChannels,
            specifiedExposureTimes
          } = Lookup[
            myMapThreadOptions,
            {
              Populations,
              PopulationCellTypes,
              PopulationIdentities,
              ImagingStrategies,
              ImagingChannels,
              ExposureTimes
            }
          ];

          (* Create a variable to keep track if we need to include Populations in InvalidOptions *)
          {
            overlappingPopulationError,
            ambiguousAllPopulationError,
            duplicatedIdentitiesError,
            conflictingCellTypeWithPopulationError,
            conflictingCellIdentitiesWithPopulationError,
            conflictingCellTypeWithIdentitiesError
          } = ConstantArray[False, 6];

          invalidAnalysisOption = {};

          (*==Analysis==*)
          (* Figure out if the options for each sample should be resolved through AnalyzeColonies. *)
          (* NOTE: we are sending analysis options to AnalyzeColonies even if all options are specified since we want to get tests/errors there *)

          (* Create a temporary Object[Data,Appearance,Colonies] packets to pass to AnalyzeColonies *)
          dataAppearanceColoniesPacket = <|
            Object -> CreateID[Object[Data, Appearance, Colonies]],
            CellTypes -> {Link[existingMainCellModel]}
          |>;

          (* Partially resolve Populations if only one ImagingStrategies other than BrightField is specified *)
          (* Otherwise pass specified Populations or Automatic Populations to AnalyzeColonies *)
          semiUpdatedPopulations = Which[
            MatchQ[specifiedPopulations, Automatic|{Automatic}] && MatchQ[specifiedImagingStrategies, BrightField|{BrightField..}],
              All,
            MatchQ[specifiedPopulations, Automatic|{Automatic}] && EqualQ[Length@DeleteCases[ToList@specifiedImagingStrategies, BrightField], 1],
              DeleteCases[ToList@specifiedImagingStrategies, BrightField]/.{
                BlueWhiteScreen -> BlueWhiteScreen,
                VioletFluorescence -> Fluorescence[ExcitationWavelength -> 377 Nanometer, EmissionWavelength -> 447 Nanometer],
                GreenFluorescence -> Fluorescence[ExcitationWavelength -> 457 Nanometer, EmissionWavelength -> 536 Nanometer],
                OrangeFluorescence -> Fluorescence[ExcitationWavelength -> 531 Nanometer, EmissionWavelength -> 593 Nanometer],
                RedFluorescence -> Fluorescence[ExcitationWavelength -> 531 Nanometer, EmissionWavelength -> 624 Nanometer],
                DarkRedFluorescence -> Fluorescence[ExcitationWavelength -> 628 Nanometer, EmissionWavelength -> 692 Nanometer]
              },
            True,
              specifiedPopulations
          ];

          (* Use AnalyzeColonies to get the resolved Populations and conflicting option checks *)
          {updatedAnalysisOption, updatedAnalysisTest} = If[gatherTests,
            (* If we are gathering tests, call AnalyzeColonies *)
            AnalyzeColonies[
              {dataAppearanceColoniesPacket},
              Sequence@@resolvedAnalysisCriteria, Populations -> semiUpdatedPopulations, AnalysisType -> Count, ImageRequirement -> False, Output -> {Options, Tests}
            ],
            (* If we require messages, call AnalyzeColonies through ModifyFunctionMessages *)
            {
              Module[{invalidOptionsBool, resolvedPopulationOptions},

                (* Run the analysis function to get the resolved options *)
                {resolvedPopulationOptions, invalidOptionsBool, invalidAnalysisOption} = ModifyFunctionMessages[
                  AnalyzeColonies,
                  {dataAppearanceColoniesPacket},
                  "",
                  {},
                  {Sequence@@resolvedAnalysisCriteria, Populations -> semiUpdatedPopulations, AnalysisType -> Count, ImageRequirement -> False, Output -> Options},
                  ExperimentFunction -> False,
                  Output -> {Result, Boolean, InvalidOptions}
                ];


                (* Return the options *)
                resolvedPopulationOptions
              ],
              {}
            }
          ];

          (* Only extract Populations from the updatedAnalysisOption *)
          (* Note: when Populations is not specified, we prefer singleton form *)
          (* However, if any Populations-index-matching options is specified while Populations is not specified, Populations will take the form of the specified option *)
          updatedPopulations = Module[{singlePopulationFromAnalysisQ, resolvedPopulationsFromAnalysis, resolvedPopulationsFromAnalysisSingleton},
            resolvedPopulationsFromAnalysis = Flatten@Lookup[updatedAnalysisOption, Populations];
            singlePopulationFromAnalysisQ = MatchQ[Length[resolvedPopulationsFromAnalysis], 1];
            (*Get the first item from the analysis populations for use in the Which call*)
            resolvedPopulationsFromAnalysisSingleton = If[singlePopulationFromAnalysisQ,
              FirstOrDefault[resolvedPopulationsFromAnalysis],
              Null
            ];

            Which[
              (* If PopulationCellTypes is specified as a list of 1, take the form of it insert our resolved populations singleton *)
              (* If it is more than 1 in a list, we will resolve to singleton populations and let it error out downstream. Because we wouldn't know how the user wants to correspond it with the Populations automatically resolved *)
              And[
                MatchQ[specifiedPopulations, Automatic|{Automatic}],
                singlePopulationFromAnalysisQ,
                !MatchQ[specifiedPopulationCellTypes, Automatic],
                MatchQ[specifiedPopulationCellTypes, _List],
                Length[specifiedPopulationCellTypes] == 1
              ],
                specifiedPopulationCellTypes /. Alternatives[Bacterial, Yeast] -> resolvedPopulationsFromAnalysisSingleton,
              (* If PopulationIdentities is specified as a list, take the form of it insert our resolved populations singleton *)
              And[
                MatchQ[specifiedPopulations, Automatic|{Automatic}],
                singlePopulationFromAnalysisQ,
                !MatchQ[specifiedPopulationIdentities, Automatic],
                MatchQ[specifiedPopulationIdentities, _List],
                Length[specifiedPopulationIdentities] == 1
              ],
                specifiedPopulationIdentities /. Alternatives[(_String), ObjectP[]] -> resolvedPopulationsFromAnalysisSingleton,
              (* Otherwise, none of the populations-index-matching option is specified as list, we prefer singleton *)
              MatchQ[specifiedPopulations, Automatic|{Automatic}] && singlePopulationFromAnalysisQ,
                resolvedPopulationsFromAnalysisSingleton,
              !MatchQ[specifiedPopulations, _List] && singlePopulationFromAnalysisQ,
                resolvedPopulationsFromAnalysisSingleton,
              True,
                resolvedPopulationsFromAnalysis
            ]
          ];

          (* If any specified Population is not unique, throw an error *)
          overlappingPopulationError = !exclusivePopulationsQ[updatedPopulations];

          (* Resolve PopulationCellTypes *)
          updatedPopulationCellTypes = Which[
            (* Is PopulationCellTypes specified by the user? *)
            !MatchQ[specifiedPopulationCellTypes, Automatic],
              specifiedPopulationCellTypes,
            (* Is PopulationIdentities specified by the user? *)
            !MatchQ[updatedPopulations, _List] && MatchQ[specifiedPopulationIdentities, {ObjectP[]..}|ObjectP[]],
              First[fastAssocLookup[combinedFastAssoc, #, CellType]& /@ ToList[specifiedPopulationIdentities]],
            MatchQ[specifiedPopulationIdentities, {ObjectP[]..}|ObjectP[]],
              fastAssocLookup[combinedFastAssoc, #, CellType]& /@ ToList[specifiedPopulationIdentities],
            !MatchQ[updatedPopulations, _List],
              existingSampleCellType,
            True,
              ConstantArray[existingSampleCellType, Length[updatedPopulations]]
          ];

          (* Resolve PopulationIdentities *)
          updatedPopulationIdentities = If[!MatchQ[specifiedPopulationIdentities, Automatic],
            (* Is PopulationIdentities specified by the user? *)
            specifiedPopulationIdentities,
            Module[{mainCellModelsfromType, allCellIdentities},
              mainCellModelsfromType = selectMainCellFromSample[
                ConstantArray[Lookup[samplePacket, Object], Length[ToList@updatedPopulationCellTypes]],
                CellType -> Thread[List[updatedPopulationCellTypes]],
                Cache -> cacheBall,
                Simulation -> currentSimulation
              ];
              allCellIdentities = Cases[Lookup[samplePacket, Composition][[All, 2]], ObjectP[Model[Cell]]];
              (* Is there more than 1 cell identity model in the input sample? *)
              (* If All colonies are to be counted, the colony identity need to be either specified or the only one existing in current Composition or Analytes. *)
              ambiguousAllPopulationError = And[
                GreaterQ[Length[allCellIdentities], 1] && !EqualQ[Length@Lookup[samplePacket, Analytes], 1],
                MatchQ[ToList@updatedPopulations, _AllColonies|All|{_AllColonies|All}]
              ];
              Which[
                And[
                  !MatchQ[updatedPopulations, _List],
                  Or[
                    MatchQ[updatedPopulations, _AllColonies|All],
                    EqualQ[Length[allCellIdentities], 1],
                    !MemberQ[mainCellModelsfromType, Null] && !MatchQ[updatedPopulationCellTypes, _List]
                  ]
                ],
                  (* Use the main cell identity model when All colonies are to be counted *)
                  (* If the highest concentration of each cell types model if no duplicated cell type is specified *)
                  FirstOrDefault[mainCellModelsfromType],
                And[
                  MatchQ[updatedPopulations, _List],
                  Or[
                    MatchQ[updatedPopulations, {_AllColonies|All}],
                    EqualQ[Length[allCellIdentities], 1] && EqualQ[Length[updatedPopulations], 1],
                    !MemberQ[mainCellModelsfromType, Null] && DuplicateFreeQ[ToList@updatedPopulationCellTypes]
                  ]
                ],
                  (* Use the only cell identity model when only 1 population is selected, such as 1 yeast and 1 bacterial *)
                  (* This logic only works if the composition only contains 1 yeast/1bacterial *)
                  mainCellModelsfromType,
                (* Generate new cell model names *)
                !MatchQ[updatedPopulations, _List],
                  CreateUniqueLabel["Characterized Colony from " <> Lookup[samplePacket, ID] <> " #", UserSpecifiedLabels -> userSpecifiedLabels],
                True,
                  Table[CreateUniqueLabel["Characterized Colony from " <> Lookup[samplePacket, ID] <> " #", UserSpecifiedLabels -> userSpecifiedLabels], Length[updatedPopulations]]
              ]
            ]
          ];

          (* If any specified PopulationIdentities are specified more than once for the same sample, throw an error*)
          duplicatedIdentitiesError = !DuplicateFreeQ[Cases[ToList@updatedPopulationIdentities, ObjectP[]]];

          (* Check that Populations are the same length as PopulationCellTypes *)
          conflictingCellTypeWithPopulationError = Which[
            MatchQ[updatedPopulationCellTypes, Bacterial|Yeast] && MatchQ[updatedPopulations, _List],
              True,
            MatchQ[updatedPopulationCellTypes, {(Bacterial|Yeast)..}] && !MatchQ[updatedPopulations, _List],
              True,
            !EqualQ[Length@ToList[updatedPopulationCellTypes], Length@ToList[updatedPopulations]],
              True,
            True,
              False
          ];

          (* Check that Populations are the same length as PopulationCellTypes *)
          conflictingCellIdentitiesWithPopulationError = Which[
            MatchQ[updatedPopulationIdentities, ObjectP[]|_String] && MatchQ[updatedPopulations, _List],
              True,
            MatchQ[updatedPopulationIdentities, {(ObjectP[]|_String)..}] && !MatchQ[updatedPopulations, _List],
              True,
            !EqualQ[Length@ToList[updatedPopulationIdentities], Length@ToList[updatedPopulations]],
              True,
            True,
              False
          ];

          (* Check that PopulationIdentities are the same in PopulationCellTypes *)
          conflictingCellTypeWithIdentitiesError = Which[
            (* Check that PopulationIdentities are the same length as PopulationCellTypes *)
            (* Note: we check whether they are singleton or list in the other 2 errors above *)
            !EqualQ[Length@ToList[updatedPopulationCellTypes], Length@ToList[updatedPopulationIdentities]],
              True,
            (* If they are the same length and PopulationIdentities are existing Model[Cell], check if the CellType match *)
            !MatchQ[ToList@updatedPopulationIdentities, {_String..}],
              !MatchQ[fastAssocLookup[combinedFastAssoc, #, CellType]& /@ Cases[ToList@updatedPopulationIdentities, ObjectP[]], PickList[ToList@updatedPopulationCellTypes, ToList@updatedPopulationIdentities, ObjectP[]]],
            True,
              False
          ];

          (* Note: Default PopulationName is "ColonySelection#", update it to string of PopulationIdentity *)
          (* For Diameter,Circularity,Regularity and Isolation, NumberOfColonies were default to 10, update to All *)
          updatedPopulationsWithIdentities = Which[
            And[
              !MatchQ[updatedPopulations, _List],
              !MatchQ[updatedPopulationIdentities, _List]
            ],
              Module[{populationPrimitive, datedPopulationName, toUpdateName, datedNumberOfColonies},
                (* Make sure that we turn all of the population symbols into blobs *)
                populationPrimitive = Switch[updatedPopulations,
                  Fluorescence, Fluorescence[NumberOfColonies -> All],
                  BlueWhiteScreen, BlueWhiteScreen[NumberOfColonies -> All],
                  Diameter, Diameter[NumberOfColonies -> All],
                  Circularity, Circularity[NumberOfColonies -> All],
                  Regularity, Regularity[NumberOfColonies -> All],
                  Isolation, Isolation[NumberOfColonies -> All],
                  AllColonies, AllColonies[NumberOfColonies -> All],
                  MultiFeatured, MultiFeatured[NumberOfColonies -> All],
                  _, updatedPopulations
                ];
                datedPopulationName = Lookup[populationPrimitive[[-1]], PopulationName, "This does not exist"];
                toUpdateName = Which[
                  StringQ[updatedPopulationIdentities], updatedPopulationIdentities,
                  StringContainsQ[datedPopulationName, ToString[Download[updatedPopulationIdentities, ID]]], datedPopulationName,
                  True, datedPopulationName <> " on cell model " <> ToString[Download[updatedPopulationIdentities, ID]]
                ];
                datedNumberOfColonies = Lookup[populationPrimitive[[-1]], NumberOfColonies, "This does not exist"];
                (* If the original primitive does not contain NumberOfColonies or PopulationName, nothing happens *)
                populationPrimitive/. {datedPopulationName -> toUpdateName, datedNumberOfColonies -> All}
              ],
            And[
              MatchQ[updatedPopulations, _List],
              MatchQ[updatedPopulationIdentities, _List],
              EqualQ[Length@updatedPopulations, Length@updatedPopulationIdentities]
            ],
              MapThread[
                Function[{populationValue, populationIdentity},
                  Module[{populationPrimitive, datedPopulationName, toUpdateName, datedNumberOfColonies},
                    (* Make sure that we turn all of the population symbols into blobs *)
                    populationPrimitive = Switch[populationValue,
                      Fluorescence, Fluorescence[NumberOfColonies -> All],
                      BlueWhiteScreen, BlueWhiteScreen[NumberOfColonies -> All],
                      Diameter, Diameter[NumberOfColonies -> All],
                      Circularity, Circularity[NumberOfColonies -> All],
                      Regularity, Regularity[NumberOfColonies -> All],
                      Isolation, Isolation[NumberOfColonies -> All],
                      AllColonies, AllColonies[NumberOfColonies -> All],
                      MultiFeatured, MultiFeatured[NumberOfColonies -> All],
                      _, populationValue
                    ];
                    datedPopulationName = Lookup[populationPrimitive[[-1]], PopulationName, "This does not exist"];
                    toUpdateName = If[StringQ[populationIdentity], populationIdentity, datedPopulationName <> " on sample " <> Download[populationIdentity, ID]];
                    datedNumberOfColonies = Lookup[populationPrimitive[[-1]], NumberOfColonies, "This does not exist"];
                    (* If the original primitive does not contain NumberOfColonies or PopulationName, nothing happens *)
                    populationPrimitive/. {datedPopulationName -> toUpdateName, datedNumberOfColonies -> All}
                  ]
                ],
                {updatedPopulations, updatedPopulationIdentities}
              ],
            True,
              (* If Population related options do not match length, we simply return the value *)
              updatedPopulations
          ];

          (*=== Imaging ===*)

          (* Resolve imaging options *)
          updatedImagingStrategies = If[!MatchQ[specifiedImagingStrategies, Automatic],
            (* Is ImagingStrategies specified by the user? *)
            specifiedImagingStrategies,
            (* Otherwise, resolve all the required strategies from Populations *)
            (* Note: when ImagingStrategies is not specified, we prefer singleton form *)
            Module[{resolvedStrategiesFromPopulations},
              resolvedStrategiesFromPopulations = imagingStrategiesFromPopulations[ToList@updatedPopulations];
              If[Length[resolvedStrategiesFromPopulations] > 1,
                resolvedStrategiesFromPopulations,
                First[resolvedStrategiesFromPopulations]
              ]
            ]
          ];

          updatedImagingChannels = updatedImagingStrategies/.strategiesMappingToChannels;

          updatedExposureTimes = Which[
            !MatchQ[specifiedExposureTimes, Automatic],
              specifiedExposureTimes,
            MatchQ[updatedImagingStrategies, QPixImagingStrategiesP],
              (* If ImagingStrategies is a single value, ExposureTime should also be a single value *)
              Automatic,
            True,
              (* If ImagingStrategies is a list, ExposureTime should also be a list *)
              ConstantArray[Automatic, Length[updatedImagingStrategies]]
          ];

          (* Check errors *)

          (* Check that ImagingStrategies and ExposureTimes are the same length manually *)
          (* There is an imagingOption mismatch error if ImagingStrategies -> single channel and ExposureTimes -> list of times or *)
          (* ImagingStrategies -> list of channels and ExposureTimes -> single time *)
          imagingOptionSameLengthError = Or[
            MatchQ[updatedImagingStrategies, QPixImagingStrategiesP] && MatchQ[updatedExposureTimes, _List],
            MatchQ[updatedImagingStrategies, {QPixImagingStrategiesP..}] && MatchQ[updatedExposureTimes, _Real],
            !EqualQ[Length[ToList[updatedImagingStrategies]], Length[ToList[updatedExposureTimes]]]
          ];

          (* Check that ImagingStrategies are all present with required Populations *)
          missingImagingStrategyInfo = If[!MatchQ[specifiedImagingStrategies, Automatic],
            Complement[imagingStrategiesFromPopulations[ToList@updatedPopulations], ToList@updatedImagingStrategies],
            {}
          ];

          (* Gather MapThread results *)
          {
            (*1*)invalidAnalysisOption,
            (*2*)overlappingPopulationError,
            (*3*)ambiguousAllPopulationError,
            (*4*)duplicatedIdentitiesError,
            (*5*)conflictingCellTypeWithPopulationError,
            (*6*)conflictingCellIdentitiesWithPopulationError,
            (*7*)conflictingCellTypeWithIdentitiesError,
            (*8*)imagingOptionSameLengthError,
            (*9*)missingImagingStrategyInfo,
            (*10*)updatedPopulationsWithIdentities,
            (*11*)updatedPopulationCellTypes,
            (*12*)updatedPopulationIdentities,
            (*13*)updatedAnalysisTest,
            (*14*)updatedImagingStrategies,
            (*15*)updatedImagingChannels,
            (*16*)updatedExposureTimes
          }
        ]
      ],
      {sampleCellTypes, mainCellIdentityModels, samplePackets, mapThreadFriendlyOptions}
    ]
  ];

  (*---INCUBATION OPTIONS AND CHECKS---*)
  (* This resolution has to be after the MapThread because DestinationContainer and Dilution options are needed to resolve Incubator. *)
  (* Resolve Incubation related Options using ExperimentIncubateCells *)
  {
    resolvedIncubateCellsOptions,
    resolvedHiddenOptions,
    {
      (*1*)invalidIncubationConditionError,
      (*2*)tooManyIncubationConditionError,
      (*3*)incubatorIsIncompatibleError,
      (*4*)incubatorCapacityError,
      (*5*)incubationMaxTemperatureError
    }
  } = If[TrueQ[resolvedPreparedSample] || TrueQ[$QuantifyColoniesPreparedOnly],
    (* If PreparedSample is True, all incubation options should be Null if they are Automatic *)
    {
      suppliedIncubationOptions/. Automatic -> Null,
      {
        CarbonDioxide -> Null,
        RelativeHumidity -> Null,
        Shake -> Null,
        ShakingRadius -> Null,
        ShakingRate -> Null
      },
      {
        (*1*)False,
        (*2*)False,
        (*3*){},
        (*4*){},
        (*5*){}
      }
    },
    Module[
      {
        (*--Related SpreadCells Options--*)
        expandedSpreadCellOptions, resolvedDestinationContainer, resolvedDilutionStrategy, resolvedNumberOfDilutions,
        (*-- ERROR TRACKING VARIABLES --*)
        invalidIncubationConditionQ, tooManyIncubationConditionQ, invalidIncubatorError, incubatorCapacityInfo,
        incubationMaxTemperatureInfo,
        (* IncubationCondition and Hidden options *)
        sameCellTypeQ, fastAssocKeysIDOnly, incubatorPackets, customIncubatorPackets, customIncubators, specifiedIncubatorModelPacket,
        possibleIncubatorModels, resolvedIncubator, resolvedIncubationCondition, storageConditionPackets, resolvedIncubationConditionPacket,
        resolvedTemperature, resolvedCarbonDioxide, resolvedRelativeHumidity, resolvedShake, resolvedShakingRadius,
        resolvedPlateShakingRate, modelDestinationContainer, footprintsTally, allDoublingTimes, min5xDoublingTime,
        min10xDoublingTime, min20xDoublingTime, resolvedIncubationTime, resolvedMaxColonyIncubationTime, resolvedIncubationInterval,
        resolvedIncubateUntilCountable, resolvedNumberOfStableIntervals
      },

      (* Expand previously resolved SpreadCells options *)
      expandedSpreadCellOptions = Last@ExpandIndexMatchedInputs[
        ExperimentSpreadCells, {mySamples},
        {
          DestinationContainer -> Lookup[resolvedSpreadCellsOptions, DestinationContainer],
          DilutionStrategy -> Lookup[resolvedSpreadCellsOptions, DilutionStrategy],
          NumberOfDilutions -> Lookup[resolvedSpreadCellsOptions, NumberOfDilutions]
        }
      ];
      (* Look up resolved SpreadCells option values *)
      {
        resolvedDestinationContainer,
        resolvedDilutionStrategy,
        resolvedNumberOfDilutions
      } = Lookup[
        expandedSpreadCellOptions,
        {
          DestinationContainer,
          DilutionStrategy,
          NumberOfDilutions
        }
      ];

      (* Check if all main model cell types are the same *)
      sameCellTypeQ = SameQ@@sampleCellTypes;

      (* Custom incubators objects and models. If ProvidedStorageCondition is Null, then they must be custom incubators *)
      (* don't love this hard coding *)
      fastAssocKeysIDOnly = Select[Keys[combinedFastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
      incubatorPackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Incubator]]];
      customIncubatorPackets = Cases[incubatorPackets, KeyValuePattern[ProvidedStorageCondition -> Null]];
      customIncubators = Lookup[customIncubatorPackets, Object, {}];
      (* If we have a specified incubator, get the packet *)
      specifiedIncubatorModelPacket = Which[
        MatchQ[suppliedIncubator, ObjectP[Model[Instrument, Incubator]]], fetchPacketFromFastAssoc[suppliedIncubator, combinedFastAssoc],
        MatchQ[suppliedIncubator, ObjectP[Object[Instrument, Incubator]]], fastAssocPacketLookup[combinedFastAssoc, suppliedIncubator, Model],
        True, Null
      ];

      (* Resolve the incubation condition *)
      resolvedIncubationCondition = Which[
        (* if the user set it, use it *)
        Not[MatchQ[suppliedIncubationCondition, Automatic]], suppliedIncubationCondition,
        (* if Incubator is specified and it's a custom incubator, set to Custom *)
        MatchQ[suppliedIncubator, ObjectP[]] && MemberQ[customIncubators, ObjectP[suppliedIncubator]], Custom,
        (* if Incubator is specified otherwise, get its ProvidedStorageCondition (replacing Null with Custom on the off chance we get that) *)
        MatchQ[suppliedIncubator, ObjectP[]], Lookup[specifiedIncubatorModelPacket, ProvidedStorageCondition] /. {Null -> Custom},
        (* if main cell types are more than one, default to Custom *)
        !TrueQ[sameCellTypeQ], Custom,
        (* otherwise we figured out incubation condition based on the model Cell, so go with that *)
        MatchQ[First@sampleCellTypes, Bacterial], BacterialIncubation,
        True, YeastIncubation
      ];

      (* Check if IncubationCondition is valid *)
      (* We are splitting the invalid error messages to 2:InvalidIncubationCondition and TooManyIncubationConditions *)
      invalidIncubationConditionQ = Which[
        (* We only support 2 default SA:BacterialIncubation,YeastIncubation and custom IncubationCondition *)
        MatchQ[resolvedIncubationCondition, ObjectP[]] && !MatchQ[resolvedIncubationCondition, ObjectP[{Model[StorageCondition, "Bacterial Incubation"], Model[StorageCondition, "Yeast Incubation"]}]],
          True,
        sameCellTypeQ && MatchQ[First@sampleCellTypes, Bacterial] && !MatchQ[resolvedIncubationCondition, Custom|BacterialIncubation|ObjectP[Model[StorageCondition, "Bacterial Incubation"]]],
          True,
        sameCellTypeQ && MatchQ[First@sampleCellTypes, Yeast] && !MatchQ[resolvedIncubationCondition, Custom|YeastIncubation|ObjectP[Model[StorageCondition, "Yeast Incubation"]]],
          True,
        True,
          False
      ];
      tooManyIncubationConditionQ = !sameCellTypeQ && !MatchQ[resolvedIncubationCondition, Custom];

      storageConditionPackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];

      (* Get the resolved incubation condition packet *)
      resolvedIncubationConditionPacket = Switch[resolvedIncubationCondition,
        (* if we have an object, take the object *)
        ObjectP[Model[StorageCondition]], fetchPacketFromFastAssoc[resolvedIncubationCondition, combinedFastAssoc],
        (* if it's Null, then just stick with Null *)
        Null, Null,
        (* if it's custom, then just stick with Null *)
        Custom, Null,
        (* otherwise need to get the first storage condition that matches the symbol we chose *)
        _, FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> resolvedIncubationCondition]]
      ];

      resolvedTemperature = Which[
        MatchQ[suppliedTemperature, TemperatureP], suppliedTemperature,
        NullQ[resolvedIncubationConditionPacket], 30 Celsius,
        (* Note when we look up values from SC, extra digit might be added *)
        True, SafeRound[Lookup[resolvedIncubationConditionPacket, Temperature], 1 Celsius]
      ];

      (* Resolve Hidden options *)
      (* Note: We need to pass those options to IncubateCells subprotocol when Custom is True, otherwise it errors out *)
      (* Extract incubation conditions from resolvedIncubationCondition or default to Null *)
      (* Note when we look up values from SC, extra digit might be added *)
      resolvedCarbonDioxide = If[NullQ[resolvedIncubationConditionPacket],
        Ambient,
        SafeRound[Lookup[resolvedIncubationConditionPacket, CarbonDioxide], 1 Percent]/.Null -> Ambient
      ];
      resolvedRelativeHumidity = If[NullQ[resolvedIncubationConditionPacket],
        Ambient,
        SafeRound[Lookup[resolvedIncubationConditionPacket, Humidity], 1 Percent]/.Null -> Ambient
      ];
      (* But SolidMedia plates should not require shaking so default to False *)
      resolvedShake = If[NullQ[resolvedIncubationConditionPacket],
        False,
        !NullQ[Lookup[resolvedIncubationConditionPacket, PlateShakingRate]]
      ];
      resolvedPlateShakingRate = If[NullQ[resolvedIncubationConditionPacket],
        Null,
        SafeRound[Lookup[resolvedIncubationConditionPacket, ShakingRate], 1 RPM]
      ];
      resolvedShakingRadius = Which[
        NullQ[resolvedIncubationConditionPacket], Null,
        NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]], Null,
        True, First@Nearest[{3 Millimeter, 25 Millimeter, 25.4 Millimeter}, Lookup[resolvedIncubationConditionPacket, ShakingRadius]]
      ];

      modelDestinationContainer = Which[
        MatchQ[FirstOrDefault@resolvedDestinationContainer, ObjectP[Model[Container, Plate]]],
          FirstOrDefault@resolvedDestinationContainer,
        MatchQ[FirstOrDefault@resolvedDestinationContainer, ObjectP[Object[Container, Plate]]],
          fastAssocPacketLookup[combinedFastAssoc, FirstOrDefault@resolvedDestinationContainer, Model],
        True,
          Model[Container, Plate, "id:O81aEBZjRXvx"](*Model[Container, Plate, "Omni Tray Sterile Media Plate"]*)
      ];

      (* If the Temperature is greater than the MaxTemperature of an input container, throw an error *)
      incubationMaxTemperatureInfo = Module[{maxTemp},
        maxTemp = Lookup[fetchPacketFromFastAssoc[modelDestinationContainer, combinedFastAssoc], MaxTemperature];
        If[TemperatureQ[maxTemp] && LessQ[maxTemp, resolvedTemperature],
          {maxTemp, modelDestinationContainer},
          {}
        ]
      ];

      (* Use IncubateCellDevices to search for suitable incubator models to grow samples  *)
      (* Note: IncubateCellDevices check not only Footprint but also all dimensions(such as plate height). *)
      (* Calculate all possible incubators *)
      (* Note: currently we do not allow using Liconic for incubation over $RoboticIncubationTimeThreshold so only Manual Preparation *)
      possibleIncubatorModels = Flatten@IncubateCellsDevices[
        modelDestinationContainer,
        CellType -> DeleteDuplicates@sampleCellTypes,
        CultureAdhesion -> SolidMedia,
        Temperature -> resolvedTemperature,
        CarbonDioxide -> resolvedCarbonDioxide,
        RelativeHumidity -> resolvedRelativeHumidity,
        Shake -> False,
        Preparation -> Manual,
        Cache -> cacheBall
      ];

      resolvedIncubator = Which[
        !MatchQ[suppliedIncubator, Automatic],
          suppliedIncubator,
        (* If we have a Custom incubation condition, we need to pick an incubator that we can use *)
        (* to do this, pick the first potential incubator that is a custom incubator *)
        MatchQ[resolvedIncubationCondition, Custom],
          SelectFirst[possibleIncubatorModels, MemberQ[customIncubators, #]&, Null],
        (* If we can avoid picking a custom incubator here, let's do it *)
        True,
          SelectFirst[
            possibleIncubatorModels,
            Not[MemberQ[customIncubators, #]]&,
            (* if we can't find any non-custom incubators, just pick whatever we can find*)
            FirstOrDefault[possibleIncubatorModels]
          ]
      ];

      (* Check IncubatorIsIncompatible error *)
      invalidIncubatorError = If[And[!MatchQ[possibleIncubatorModels, {}],
          Or[
            MatchQ[suppliedIncubator, ObjectP[Model[Instrument]]] && !MemberQ[possibleIncubatorModels, ObjectP[resolvedIncubator]],
            MatchQ[suppliedIncubator, ObjectP[Object[Instrument]]] && !MemberQ[possibleIncubatorModels, ObjectP[Experiment`Private`fastAssocLookup[combinedFastAssoc, resolvedIncubator, Model]]]
          ]
        ],
        {mySamples, Range[Length[mySamples]], suppliedIncubator, possibleIncubatorModels},
        {}
      ];

      (* Check how many solid media plates we need to incubate *)
      footprintsTally = Module[{dilutionContainersOut},
        dilutionContainersOut = MapThread[
          If[MatchQ[#1, Series],
            (* ContainerOut number is NumberOfDilutions + 1 *)
            #2 + 1,
            (* If there is no dilution or DilutionStrategy is Endpoint, we just have 1 solid plate *)
            1
          ]&,
          {resolvedDilutionStrategy, resolvedNumberOfDilutions}
        ];
        <|Plate -> Total[dilutionContainersOut]|>
      ];

      (* After Incubator is resolved, we check here if it is valid 1)Compatible with foot print of DestinationContainer 2)have enough space if it is empty *)
      incubatorCapacityInfo = Module[{modelIncubatorCapacityLookup},
        (* Note: $CellIncubatorMaxCapacity is copied from ExperimentIncubateCells *)
        modelIncubatorCapacityLookup = Which[
          NullQ[resolvedIncubator],
            <||>,
          MatchQ[resolvedIncubator, ObjectP[Model[Instrument]]],
            Lookup[Experiment`Private`$CellIncubatorMaxCapacity, resolvedIncubator],
          True,
            Lookup[Experiment`Private`$CellIncubatorMaxCapacity, Download[Experiment`Private`fastAssocLookup[combinedFastAssoc, resolvedIncubator, Model], Object]]
        ];
        If[And[
          !NullQ[resolvedIncubator],
          MatchQ[invalidIncubatorError, {}],
          !GreaterEqualQ[Lookup[modelIncubatorCapacityLookup, Plate, 0], Lookup[footprintsTally, Plate]]
        ],
          (* Check if the footprint tally of model instrument for Plate is larger than the number of plates *)
          {Lookup[modelIncubatorCapacityLookup, Plate, 0], Lookup[footprintsTally, Plate]},
          (* If there is no suitable incubator model for specified footprint and condition, error has been thrown *)
          {}
        ]
      ];

      (* Resolve IncubateRepeat Option *)

      (* Get all the doubling times of the input cells  *)
      allDoublingTimes = fastAssocLookup[combinedFastAssoc, #, DoublingTime]& /@ mainCellIdentityModels;
      (* Select the smallest doubling time of all samples, and round to 1 hour *)
      min5xDoublingTime = If[MemberQ[allDoublingTimes, TimeP],
        SafeRound[5*Min[Cases[allDoublingTimes, TimeP]], 1 Hour, AvoidZero -> True]
      ];
      min10xDoublingTime = If[MemberQ[allDoublingTimes, TimeP],
        SafeRound[10*Min[Cases[allDoublingTimes, TimeP]], 1 Hour, AvoidZero -> True]
      ];
      min20xDoublingTime = If[MemberQ[allDoublingTimes, TimeP],
        SafeRound[20*Min[Cases[allDoublingTimes, TimeP]], 1 Hour, AvoidZero -> True]
      ];

      resolvedIncubateUntilCountable = Which[
        (* always use user specified IncubateUntilCountable if applicable *)
        !MatchQ[suppliedIncubateUntilCountable, Automatic], suppliedIncubateUntilCountable,
        (* if user specified the same time for MaxColonyIncubationTime and ColonyIncubationTime *)
        TimeQ[suppliedColonyIncubationTime] && SameQ[suppliedMaxColonyIncubationTime, suppliedColonyIncubationTime], False,
        (* if user specified NumberOfStableIntervals as a number *)
        GreaterQ[suppliedNumberOfStableIntervals, 0], True,
        (* otherwise, default to True *)
        True, True
      ];

      resolvedNumberOfStableIntervals = Which[
        (* always use user specified NumberOfStableIntervals if applicable *)
        !MatchQ[suppliedNumberOfStableIntervals, Automatic], suppliedNumberOfStableIntervals,
        (* if user specified the same time for MaxColonyIncubationTime and ColonyIncubationTime *)
        TrueQ[resolvedIncubateUntilCountable], 1,
        (* otherwise, default to True *)
        True, Null
      ];

      (* Resolve the Time option *)
      resolvedIncubationTime = Which[
        (* always use user specified time if applicable *)
        TimeQ[suppliedColonyIncubationTime], suppliedColonyIncubationTime,
        (* if we're manual and know the doubling times of our input samples, then take the shortest one times 10 *)
        MemberQ[allDoublingTimes, TimeP], Min[min10xDoublingTime, 10 Hour],
        (* otherwise, going with 10 hours *)
        True, 10 Hour
      ];

      resolvedMaxColonyIncubationTime = Which[
        (* always use user specified time if applicable *)
        TimeQ[suppliedMaxColonyIncubationTime], suppliedMaxColonyIncubationTime,
        (* if we're not repeat incubation, MaxColonyIncubationTime is the same as ColonyIncubationTime *)
        !TrueQ[resolvedIncubateUntilCountable], resolvedIncubationTime,
        (* if we're manual and know the doubling times of our input samples, then take the shortest one times 20 *)
        MemberQ[allDoublingTimes, TimeP], Max[Min[min20xDoublingTime, 20 Hour], resolvedIncubationTime + min5xDoublingTime],
        (* otherwise, going with 20 hours *)
        True, 20 Hour
      ];

      resolvedIncubationInterval = Which[
        (* always use user specified time if applicable *)
        TimeQ[suppliedIncubationInterval], suppliedIncubationInterval,
        (* if we're not repeat incubation, set to Null *)
        !TrueQ[resolvedIncubateUntilCountable], Null,
        (* if NumberOfStableIntervals is not Null, we should be able to complete at least NumberOfStableIntervals+1 before reaching MaxColonyIncubationTime*)
        !MemberQ[{resolvedMaxColonyIncubationTime, resolvedIncubationTime, resolvedNumberOfStableIntervals}, Null],
          (* Round the interval in 0.5 hour step, then take the maximum value of interval and 1 hour *)
          Max[SafeRound[(resolvedMaxColonyIncubationTime - resolvedIncubationTime)/(resolvedNumberOfStableIntervals + 1), 0.5 Hour], 1 Hour],
        (* if we're manual and know the doubling times of our input samples, then take the shortest one times 5 *)
        MemberQ[allDoublingTimes, TimeP], Min[min5xDoublingTime, 5 Hour],
        (* otherwise, going with 5 hours *)
        True, 5 Hour
      ];

      (*Return the result*)
      {
        {
          Incubator -> resolvedIncubator,
          IncubationCondition -> resolvedIncubationCondition,
          Temperature -> resolvedTemperature,
          ColonyIncubationTime -> resolvedIncubationTime,
          MaxColonyIncubationTime -> resolvedMaxColonyIncubationTime,
          IncubationInterval -> resolvedIncubationInterval,
          IncubateUntilCountable -> resolvedIncubateUntilCountable,
          NumberOfStableIntervals -> resolvedNumberOfStableIntervals
        },
        {
          CarbonDioxide -> resolvedCarbonDioxide,
          RelativeHumidity -> resolvedRelativeHumidity,
          Shake -> resolvedShake,
          ShakingRadius -> resolvedShakingRadius,
          ShakingRate -> resolvedPlateShakingRate
        },
        {
          (*1*)invalidIncubationConditionQ,
          (*2*)tooManyIncubationConditionQ,
          (*3*)invalidIncubatorError,
          (*4*)incubatorCapacityInfo,
          (*5*)incubationMaxTemperatureInfo
        }
      }
    ]
  ];

  (* -- CONFLICTING OPTIONS CHECKS I-- *)

  (* -- MAPTHREAD ERROR MESSAGES -- *)
  (* OverlappingPopulations *)
  overlappingPopulationsOptions = If[MemberQ[overlappingPopulationErrors, True] && messages,
    Message[Error::OverlappingPopulations,
      PickList[mySamples, overlappingPopulationErrors]
    ];
    {Populations},
    {}
  ];

  overlappingPopulationsTests = If[gatherTests,
    (* We are gathering tests, create the appropriate tests *)
    Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
      (* Get the inputs that pass the test *)
      passingInputs = PickList[mySamples, overlappingPopulationErrors, False];

      (* Get the non passing inputs *)
      nonPassingInputs = Complement[mySamples, passingInputs];

      (* Create a test for the passing inputs *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The inputs" <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> "have mutually exclusive Populations:", True, True],
        Nothing
      ];

      (* Create a test for the non passing inputs *)
      nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
        Test["The inputs" <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> "have non mutually exclusive Populations:", True, False],
        Nothing
      ];

      (* Return the created tests *)
      {passingInputsTest, nonPassingInputsTest}
    ],
    Nothing
  ];

  (* ConflictingPopulationCellTypesWithPopulations *)
  conflictingCellTypeWithPopulationOptions = If[MemberQ[conflictingCellTypeWithPopulationErrors, True] && messages,
    Message[
      Error::ConflictingPopulationCellTypesWithPopulations,
      PickList[mySamples, conflictingCellTypeWithPopulationErrors],
      PickList[resolvedPopulationCellTypes, conflictingCellTypeWithPopulationErrors],
      PickList[resolvedPopulations, conflictingCellTypeWithPopulationErrors]
    ];
    {PopulationCellTypes, Populations},
    {}
  ];

  conflictingCellTypeWithPopulationTests = If[MemberQ[conflictingCellTypeWithPopulationErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, conflictingCellTypeWithPopulationErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " have same length for PopulationCellTypes and Populations:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " do not have same length for PopulationCellTypes and Populations:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* ConflictingPopulationIdentitiesWithPopulations *)
  conflictingIdentitiesWithPopulationOptions = If[MemberQ[conflictingCellIdentitiesWithPopulationErrors, True] && messages,
    Message[
      Error::ConflictingPopulationIdentitiesWithPopulations,
      ObjectToString[PickList[mySamples, missingImagingStrategyInfos, Except[{}]], Cache -> cacheBall, Simulation -> currentSimulation],
      PickList[resolvedPopulationIdentities, conflictingCellIdentitiesWithPopulationErrors],
      PickList[resolvedPopulations, conflictingCellIdentitiesWithPopulationErrors]
    ];
    {PopulationIdentities, Populations},
    {}
  ];

  conflictingIdentitiesWithPopulationTests = If[MemberQ[conflictingCellIdentitiesWithPopulationErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, conflictingCellIdentitiesWithPopulationErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " have same length for PopulationIdentities and Populations:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " do not have same length for PopulationIdentities and Populations:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* ConflictingPopulationCellTypesWithIdentities *)
  conflictingCellTypeWithIdentitiesOptions = If[MemberQ[conflictingCellTypeWithIdentitiesErrors, True] && messages,
    Message[
      Error::ConflictingPopulationCellTypesWithIdentities,
      PickList[mySamples, conflictingCellTypeWithIdentitiesErrors],
      PickList[resolvedPopulationCellTypes, conflictingCellTypeWithIdentitiesErrors],
      PickList[resolvedPopulationIdentities, conflictingCellTypeWithIdentitiesErrors]
    ];
    {PopulationCellTypes, PopulationIdentities},
    {}
  ];

  conflictingCellTypeWithIdentitiesTests = If[MemberQ[conflictingCellTypeWithIdentitiesErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, conflictingCellTypeWithIdentitiesErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " have PopulationCellTypes specified in PopulationIdentities:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " do not have PopulationCellTypes specified in PopulationIdentities:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Imaging Option Same Length *)
  imagingOptionSameLengthOptions = If[MemberQ[imagingOptionSameLengthErrors, True] && messages,
    Message[Error::ImagingOptionMismatch, PickList[mySamples, imagingOptionSameLengthErrors]];
    {ImagingStrategies, ExposureTimes},
    {}
  ];

  imagingOptionSameLengthTests = If[MemberQ[imagingOptionSameLengthErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, imagingOptionSameLengthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " have the same length:", True, True];

      (* Create the failing test *)
      failingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " have the same length:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Missing imaging channels *)
  missingImagingStrategiesOptions = If[MemberQ[missingImagingStrategyInfos, Except[{}]] && messages,
    Message[Error::MissingImagingStrategies,
      PickList[mySamples, missingImagingStrategyInfos, Except[{}]],
      Cases[missingImagingStrategyInfos, Except[{}]],
      Which[
        (* If it contains both, we include both clauses *)
        MemberQ[Flatten[missingImagingStrategyInfos], BlueWhiteScreen] && MemberQ[Flatten[missingImagingStrategyInfos], VioletFluorescence|GreenFluorescence|OrangeFluorescence|RedFluorescence|DarkRedFluorescence],
          "ImagingStrategies must include the BlueWhiteScreen along with BrightField because Populations is set to include BlueWhiteScreen. Additionally, because Populations is set to include fluorescent excitation and emission pairs, their corresponding fluorescence strategies must be included",
        MemberQ[Flatten[missingImagingStrategyInfos], BlueWhiteScreen],
          "ImagingStrategies must include the BlueWhiteScreen along with BrightField because Populations is set to include BlueWhiteScreen",
        (* missingImagingStrategyInfos includes a fluroescence one *)
        True,
          "The fluorescence strategy must be included along with BrightField because Populations is set to include the corresponding fluorescent excitation and emission pairs"
      ]
    ];
    {ImagingStrategies},
    {}
  ];

  missingImagingStrategyTests = If[MemberQ[missingImagingStrategyInfos, Except[{}]] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, missingImagingStrategyInfos, Except[{}]];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " do not have imaging strategies required in Populations that are not listed in ImagingStrategies:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> currentSimulation] <> " do not have imaging strategies required in Populations that are not listed in ImagingStrategies:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* InvalidIncubationConditions *)
  If[TrueQ[invalidIncubationConditionError] && messages,
    Message[
      Error::InvalidIncubationConditions,
      StringJoin[
        samplesForMessages[mySamples, Cache -> cacheBall, Simulation -> currentSimulation],
        If[Length[mySamples] == 1,
          " has",
          " have"
        ]
      ],
      ObjectToString[Lookup[resolvedIncubateCellsOptions, IncubationCondition], Cache -> cacheBall, Simulation -> currentSimulation]
    ]
  ];

  invalidIncubationConditionTest = If[TrueQ[invalidIncubationConditionError] && gatherTests,
    Test["The IncubationCondition option is supported for the sample cell type:",
      MatchQ[invalidIncubationConditionError, False],
      True
    ],
    Nothing
  ];

  (* TooManyIncubationConditions *)
  If[TrueQ[tooManyIncubationConditionError] && messages,
    Message[
      Error::TooManyIncubationConditions,
      ObjectToString[mySamples, Cache -> cacheBall, Simulation -> currentSimulation],
      ObjectToString[mainCellIdentityModels, Cache -> cacheBall, Simulation -> currentSimulation],
      ObjectToString[Lookup[resolvedIncubateCellsOptions, IncubationCondition], Cache -> cacheBall, Simulation -> currentSimulation]
    ]
  ];

  tooManyIncubationConditionTest = If[TrueQ[tooManyIncubationConditionError] && gatherTests,
    Test["The IncubationCondition option is Custom if incubate a mix of bacterial and yeast samples together:",
      MatchQ[tooManyIncubationConditionError, False],
      True
    ],
    Nothing
  ];

  (* IncubationMaxTemperature *)
  If[!MatchQ[incubationMaxTemperatureError, {}] && messages,
    Message[
      Error::IncubationMaxTemperature,
      (*1*)Capitalize@samplesForMessages[mySamples, mySamples],(* collapse to the sample or all samples instead of ID here *)
      (*2*)If[Length[mySamples] == 1,
        "resides in DestinationContainer(s) with model ",
        "reside in DestinationContainer(s) with model "
      ],
      (*3*)StringJoin[
        ObjectToString[incubationMaxTemperatureError[[2]], Cache -> cacheBall, Simulation -> currentSimulation],
        ", which has"
      ],
      (*4*)ToString[incubationMaxTemperatureError[[1]]]
    ]
  ];

  incubationMaxTemperatureTest = If[!MatchQ[incubationMaxTemperatureError, {}] && gatherTests,
    Test["The spread solid media plates do not have Temperature set higher than the MaxTemperature of their containers:",
      MatchQ[incubationMaxTemperatureError, {}],
      True
    ],
    Nothing
  ];

  (* IncubatorIsIncompatible *)
  If[!MatchQ[incubatorIsIncompatibleError, {}] && !gatherTests,
    (* Throw the corresponding error. *)
    Message[Error::IncubatorIsIncompatibleForColonies,
      ObjectToString[incubatorIsIncompatibleError[[1]], Cache -> cacheBall, Simulation -> currentSimulation],
      incubatorIsIncompatibleError[[2]],
      ObjectToString[incubatorIsIncompatibleError[[3]], Cache -> cacheBall, Simulation -> currentSimulation],
      ObjectToString[incubatorIsIncompatibleError[[4]], Cache -> cacheBall, Simulation -> currentSimulation]
    ]
  ];
  (* Create the corresponding test for the invalid options. *)
  incubatorIsIncompatibleTest = If[!MatchQ[incubatorIsIncompatibleError, {}] && gatherTests,
    Test["The following samples, " <> ObjectToString[mySamples, Cache -> cacheBall, Simulation -> currentSimulation] <> ", has the incubator compatible if specified:", True, False],
    Nothing
  ];

  (* TooManyIncubationSamples *)
  (* If we have too many samples for an incubator, throw an error: *)
  If[!MatchQ[incubatorCapacityError, {}] && messages,
    Message[
      Error::TooManyIncubationSamples,
      StringJoin[ObjectToString[Lookup[resolvedIncubateCellsOptions, Incubator], Cache -> cacheBall, Simulation -> currentSimulation], " has enough space for ", ToString[incubatorCapacityError[[1]]], " containers with Footprint as Plate but ", ToString[incubatorCapacityError[[2]]], " containers were specified instead"]
    ]
  ];
  incubatorCapacityTest = If[!MatchQ[incubatorCapacityError, {}] && gatherTests,
    Test["Too many samples are not provided for a given incubator:",
      MatchQ[incubatorCapacityError, {}],
      True
    ],
    Nothing
  ];

  (* Incubation Repeat Errors *)
  Module[{resolvedIncubationTime, resolvedMaxColonyIncubationTime, resolvedIncubationInterval, resolvedIncubateUntilCountable, resolvedNumberOfIntervals},
    resolvedIncubationTime = Lookup[resolvedIncubateCellsOptions, ColonyIncubationTime]/.Null -> 0 Hour;
    resolvedMaxColonyIncubationTime = Lookup[resolvedIncubateCellsOptions, MaxColonyIncubationTime]/.Null -> 0 Hour;
    resolvedIncubationInterval = Lookup[resolvedIncubateCellsOptions, IncubationInterval];
    resolvedIncubateUntilCountable = Lookup[resolvedIncubateCellsOptions, IncubateUntilCountable];
    resolvedNumberOfIntervals = Lookup[resolvedIncubateCellsOptions, NumberOfStableIntervals];
    (* ConflictingIncubationRepeatOptions *)
    conflictingIncubationRepeatOptionQ = If[!TrueQ[resolvedPreparedSample] && !TrueQ[$QuantifyColoniesPreparedOnly],
        Or[
          TrueQ[resolvedIncubateUntilCountable] && NullQ[resolvedIncubationInterval],
          TrueQ[resolvedIncubateUntilCountable] && GreaterQ[resolvedIncubationTime, resolvedMaxColonyIncubationTime],
          !TrueQ[resolvedIncubateUntilCountable] && !NullQ[resolvedIncubationInterval],
          !TrueQ[resolvedIncubateUntilCountable] && !EqualQ[resolvedIncubationTime, resolvedMaxColonyIncubationTime]
      ],
      False
    ];
    If[TrueQ[conflictingIncubationRepeatOptionQ] && messages,
      Message[
        Error::ConflictingIncubationRepeatOptions,
        resolvedIncubateUntilCountable,
        Lookup[resolvedIncubateCellsOptions, ColonyIncubationTime],
        Lookup[resolvedIncubateCellsOptions, MaxColonyIncubationTime],
        resolvedIncubationInterval
      ]
    ];
    conflictingIncubationRepeatTest = If[TrueQ[conflictingIncubationRepeatOptionQ] && gatherTests,
      Test["MaxColonyIncubationTime is longer than ColonyIncubationTime only when IncubateUntilCountable is True:",
        TrueQ[conflictingIncubationRepeatOptionQ],
        False
      ],
      Nothing
    ];

    (* UnsuitableIncubationInterval *)
    unsuitableIncubationIntervalQ = If[!TrueQ[resolvedPreparedSample] && !TrueQ[$QuantifyColoniesPreparedOnly],
      And[
        TrueQ[resolvedIncubateUntilCountable],
        !NullQ[resolvedIncubationInterval],
        Or[
          !NullQ[resolvedNumberOfIntervals] && GreaterQ[resolvedIncubationInterval, (resolvedMaxColonyIncubationTime - resolvedIncubationTime)/resolvedNumberOfIntervals],
          NullQ[resolvedNumberOfIntervals] && GreaterQ[resolvedIncubationInterval, (resolvedMaxColonyIncubationTime - resolvedIncubationTime)],
          LessQ[resolvedIncubationInterval, 1 Hour]
        ]
      ],
      False
    ];
    If[TrueQ[unsuitableIncubationIntervalQ] && messages,
      Message[
        Error::UnsuitableIncubationInterval,
        resolvedIncubationInterval,
        resolvedNumberOfIntervals,
        (resolvedMaxColonyIncubationTime - resolvedIncubationTime)/(resolvedNumberOfIntervals/.Null -> 1)
      ]
    ];
    unsuitableIncubationIntervalTest = If[TrueQ[unsuitableIncubationIntervalQ] && gatherTests,
      Test["IncubationInterval is properly set:",
        TrueQ[unsuitableIncubationIntervalQ],
        False
      ],
      Nothing
    ];
  ];

  (*---SHARED OPTIONS AND CHECKS---*)
  (* NOTE: there is no Aliquot options *)

  (* Check to make sure the new cell model name doesn't already exist *)
  (* Note:we only check user specified name since autoresolved names are always unique *)
  namesAlreadyInUse = Module[{namesAndUUIDs, possibleModels, databaseQ, inUseQ, inUseNames},
    namesAndUUIDs = Cases[Flatten[suppliedPopulationIdentities], _String];
    (* For each name, there are 3 possible types to check *)
    possibleModels = {Model[Cell, #], Model[Cell, Bacteria, #], Model[Cell, Yeast, #]}& /@ namesAndUUIDs;
    (* Check whether all 3 possible types with the given string are not existing in database *)
    databaseQ = Unflatten[DatabaseMemberQ[Flatten@possibleModels], possibleModels];
    inUseQ = MemberQ[#, True]& /@ databaseQ;
    (* Get the names that are already InUse *)
    inUseNames = PickList[namesAndUUIDs, inUseQ]
  ];

  (* Throw an error if there are names already in use *)
  namesAlreadyInUseOptions = If[!MatchQ[namesAlreadyInUse, {}] && messages,
    Message[Error::NewColonyNameInUse, namesAlreadyInUse];
    {PopulationIdentities},
    {}
  ];

  (* Make tests for if the name is already in use *)
  namesAlreadyInUseTest = If[gatherTests,
    Module[{failingNames, test},

      (* Get the inputs that fail this test *)
      failingNames = namesAlreadyInUse;

      (* Duplicate component test *)
      test = If[Length[failingNames] > 0,
        Test["The provided name(s) " <> failingNames <> " are not already in use by existing cell Identity model(s):",
          False,
          True
        ],
        Test["The provided names(s) are not already in use by existing cell Identity model(s):",
          True,
          True
        ]
      ]
    ]
  ];


  (* Make sure there are no duplicates in the PopulationIdentities option *)
  (* Note:we have to check unique strings after mapthread to make sure new name for model cells are unique across all samples *)
  duplicateFreeNameQ = DuplicateFreeQ[Cases[Flatten[resolvedPopulationIdentities], _String]];

  (* Throw an error if there duplicates in the PopulationIdentities option *)
  duplicateNameOptions = If[(!duplicateFreeNameQ || MemberQ[duplicatedIdentitiesErrors, True]) && messages,
    Message[Error::DuplicatedPopulationIdentities];
    {PopulationIdentities},
    {}
  ];

  (* Make a test for the duplicate names *)
  duplicateNameTest = If[gatherTests,
    Test["The PopulationIdentities option does not have duplicates specified:",
      duplicateFreeNameQ && !MemberQ[duplicatedIdentitiesErrors, True],
      True
    ],
    Null
  ];

  (* Get the options needed to resolve Email and Operator and to check for Error::DuplicateName. *)
  {
    specifiedOperator,
    upload,
    specifiedEmail,
    specifiedName
  } = Lookup[myOptions, {Operator, Upload, Email, Name}];

  (* Adjust the email option based on the upload option *)
  resolvedEmail = If[!MatchQ[specifiedEmail, Automatic],
    specifiedEmail,
    upload && MemberQ[output, Result]
  ];

  (* Resolve the operator option. *)
  resolvedOperator = If[NullQ[specifiedOperator], Model[User, Emerald, Operator, "Level 2"], specifiedOperator];

  (* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
  nameInvalidBool = StringQ[specifiedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, RoboticCellPreparation], specifiedName]]];

  (* NOTE: unique *)
  (* If the name is invalid, will add it to the list if invalid options later. *)
  nameInvalidOption = If[nameInvalidBool && messages,
    (
      Message[Error::DuplicateName, Object[Protocol, RoboticCellPreparation]];
      {Name}
    ),
    {}
  ];
  nameInvalidTest = If[gatherTests,
    Test["The specified Name is unique:", False, nameInvalidBool],
    Nothing
  ];

  (* We are overriding the default post processing options to False but honor user-specified values *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions, Living -> True];

  (* Get the final resolved options  *)
  resolvedOptions = ReplaceRule[
    myOptions,
    Join[
      resolvedPostProcessingOptions,
      resolvedSpreadCellsOptions,
      resolvedIncubateCellsOptions,
      resolvedHiddenOptions,
      {
        PreparedSample -> resolvedPreparedSample,
        MinReliableColonyCount -> resolvedMinReliableColonyCount,
        MaxReliableColonyCount -> resolvedMaxReliableColonyCount,
        MinDiameter -> Lookup[resolvedAnalysisCriteria, MinDiameter],
        MaxDiameter -> Lookup[resolvedAnalysisCriteria, MaxDiameter],
        MinColonySeparation -> Lookup[resolvedAnalysisCriteria, MinColonySeparation],
        MinRegularityRatio -> Lookup[resolvedAnalysisCriteria, MinRegularityRatio],
        MaxRegularityRatio -> Lookup[resolvedAnalysisCriteria, MaxRegularityRatio],
        MinCircularityRatio -> Lookup[resolvedAnalysisCriteria, MinCircularityRatio],
        MaxCircularityRatio -> Lookup[resolvedAnalysisCriteria, MaxCircularityRatio],
        Populations -> resolvedPopulations,
        PopulationCellTypes -> resolvedPopulationCellTypes,
        PopulationIdentities -> resolvedPopulationIdentities,
        ImagingInstrument -> resolvedInstrument,
        ImagingStrategies -> resolvedImagingStrategies,
        ImagingChannels -> resolvedImagingChannels,
        ExposureTimes -> resolvedExposureTimes,
        Preparation -> resolvedPreparation,
        WorkCell -> resolvedWorkCell,
        SampleLabel -> resolvedSampleLabels,
        SampleContainerLabel -> resolvedSampleContainerLabels,
        Name -> specifiedName,
        Email -> resolvedEmail,
        Operator -> resolvedOperator
      }
    ]
  ];

  (*-- SUMMARY OF CHECKS --*)
  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[
    {
      invalidCellTypeSamples,
      discardedInvalidInputs,
      deprecatedInvalidInputs,
      nonSolidInvalidInputs,
      nonLiquidInvalidInputs,
      invalidContainerSampleInputs,
      duplicatedInvalidInputs
    }
  ]];

  invalidOptions = DeleteDuplicates[Flatten[
    {
      nameInvalidOption,
      preparedOnlyError,
      If[MatchQ[preparationResult, $Failed],
        {Preparation},
        Nothing
      ],
      conflictingWorkCellAndPreparationOptions,
      conflictingPreparedSampleWithSpreadingOption,
      conflictingPreparedSampleWithIncubationOption,
      invalidAnalysisOptions,
      overlappingPopulationsOptions,
      conflictingCellTypeWithPopulationOptions,
      conflictingIdentitiesWithPopulationOptions,
      conflictingCellTypeWithIdentitiesOptions,
      imagingOptionSameLengthOptions,
      missingImagingStrategiesOptions,
      invalidSpreadCellOptions,
      If[TrueQ[invalidIncubationConditionError],
        {IncubationCondition},
        Nothing
      ],
      If[TrueQ[tooManyIncubationConditionError],
        {IncubationCondition},
        Nothing
      ],
      If[!MatchQ[incubatorIsIncompatibleError, {}],
        {Incubator},
        Nothing
      ],
      If[!MatchQ[incubationMaxTemperatureError, {}],
        {Temperature},
        Nothing
      ],
      If[!MatchQ[incubatorCapacityError, {}],
        {Incubator},
        Nothing
      ],
      If[TrueQ[conflictingIncubationRepeatOptionQ],
        {IncubateUntilCountable, ColonyIncubationTime, MaxColonyIncubationTime, IncubationInterval},
        Nothing
      ],
      If[TrueQ[unsuitableIncubationIntervalQ],
        {IncubationInterval, NumberOfStableIntervals},
        Nothing
      ],
      namesAlreadyInUseOptions,
      duplicateNameOptions,
      If[MemberQ[compatibleMaterialsBools, False],
        {Instrument},
        Nothing
      ],
      (* For experiments that the developer marks the post processing samples as Living -> True, we need to add potential failing options to invalidOptions list in order to properly fail the resolver *)
      If[MemberQ[Values[resolvedPostProcessingOptions], $Failed],
        PickList[Keys[resolvedPostProcessingOptions], Values[resolvedPostProcessingOptions], $Failed],
        Nothing]
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs] > 0 && messages,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall, Simulation -> currentSimulation]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && messages,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* Get all the tests together. *)
  allTests = Cases[Flatten[{
    invalidCellTypeTest,
    discardedTest,
    deprecatedTest,
    nonSolidTest,
    invalidContainerTest,
    duplicatesTest,
    optionPrecisionTests,
    preparationTest,
    preparedOnlyTest,
    conflictingWorkCellAndPreparationTest,
    conflictingPreparedSampleWithSpreadingTest,
    conflictingPreparedSampleWithIncubationTest,
    overlappingPopulationsTests,
    conflictingCellTypeWithPopulationTests,
    conflictingCellTypeWithIdentitiesTests,
    invalidIncubationConditionTest,
    tooManyIncubationConditionTest,
    incubatorIsIncompatibleTest,
    incubatorCapacityTest,
    incubationMaxTemperatureTest,
    conflictingIncubationRepeatTest,
    unsuitableIncubationIntervalTest,
    spreadCellsTest,
    imagingOptionSameLengthTests,
    missingImagingStrategyTests,
    resolvedAnalysisTests,
    compatibleMaterialsTests,
    namesAlreadyInUseTest,
    duplicateNameTest,
    nameInvalidTest,
    If[gatherTests,
      postProcessingTests[resolvedPostProcessingOptions],
      Nothing
    ]
  }], TestP];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> allTests
  }
];


(* ::Subsection:: *)
(*Resource Packets*)
DefineOptions[quantifyColoniesResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

quantifyColoniesResourcePackets[
  mySamples: {ObjectP[Object[Sample]]..},
  myUnresolvedOptions: {_Rule...},
  myResolvedOptions: {_Rule...},
  ops:OptionsPattern[quantifyColoniesResourcePackets]
] := Module[
  {
    unresolvedOptionsNoHidden, resolvedOptionsNoHidden, safeOps, preparedSample, cache, inheritedSimulation, outputSpecification,
    gatherTests, messages, result, resourcePacketTests, fulfillable, previewRule, optionsRule, resultRule, testsRule
  },

  (* Get the collapsed unresolved index-matching options that don't include hidden options *)
  unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentQuantifyColonies, myUnresolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentQuantifyColonies,
    RemoveHiddenOptions[ExperimentQuantifyColonies, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* Get the safe options for this function *)
  safeOps = SafeOptions[quantifyColoniesResourcePackets, ToList[ops]];

  (* Get master option PreparedSample *)
  preparedSample = Lookup[ToList[myResolvedOptions], PreparedSample];

  (* Pull out the cache, simulation, and output from options *)
  {cache, inheritedSimulation, outputSpecification} = Lookup[safeOps, {Cache, Simulation, Output}];

  (* Decide if we are gathering tests or throwing messages *)
  gatherTests = MemberQ[ToList@outputSpecification, Tests];
  messages = Not[gatherTests];

  (*---Make all the packets for the experiment---*)

  (*--Make the protocol and unit operation packets--*)
  {result, resourcePacketTests, fulfillable} = If[TrueQ[preparedSample]|| TrueQ[$QuantifyColoniesPreparedOnly],
    (* $QuantifyColoniesPreparedOnly is another layer of safe-guard here to prevent user check resource packet for preparing samples *)
    Module[
      {unitOperationPacket, batchedUnitOperationPackets, runTime, roboticResourcePacketTests},
      (* If PreparedSample is True, we are doing RCP which use imageColoniesResourcePackets *)
      If[gatherTests,
        {
          {unitOperationPacket, batchedUnitOperationPackets, runTime},
          roboticResourcePacketTests
        } = imageColoniesResourcePackets[
          mySamples,
          myUnresolvedOptions,
          myResolvedOptions,
          ExperimentQuantifyColonies,
          Cache -> cache,
          Simulation -> inheritedSimulation,
          Output -> {Result, Tests}
        ],
        {
          {unitOperationPacket, batchedUnitOperationPackets, runTime},
          roboticResourcePacketTests
        } = {
          imageColoniesResourcePackets[
            mySamples,
            myUnresolvedOptions,
            myResolvedOptions,
            ExperimentQuantifyColonies,
            Cache -> cache,
            Simulation -> inheritedSimulation,
            Output -> Result],
          {}
        }
      ];
      (* Return result and tests *)
      {{Null, unitOperationPacket, batchedUnitOperationPackets, runTime}, roboticResourcePacketTests, True}
    ],
    Module[
      {
        fastAssoc, fastAssocKeysIDOnly, samplePackets, containerPackets, containers, storageConditionPackets,
        imagingInstrument, spreaderInstrument, incubator, dilutionTypes, dilutionStrategies, numberOfDilutions,
        cumulativeDilutionFactors, serialDilutionFactors, colonySpreadingTools, spreadVolumes, dispenseCoordinates,
        spreadPatternTypes, customSpreadPatterns, destinationContainers, destinationWells, destinationMedia, incubationCondition,
        temperature, relativeHumidity, carbonDioxide, shake, shakingRadius, shakingRate, colonyIncubationTime,
        maxColonyIncubationTime, incubationInterval, minReliableColonyCount, maxReliableColonyCount, incubateUntilCountable,
        numberOfStableIntervals, minDiameter, maxDiameter, minColonySeparation, minRegularityRatio, maxRegularityRatio,
        minCircularityRatio, maxCircularityRatio, imagingStrategies, exposureTimes, populations, populationCellTypes,
        populationIdentities, samplesInStorageConditions, samplesOutStorageConditions, parentProtocol, sampleResources,
        inputContainersNoDupes, sampleContainerResources, containerResourceRules, samplesInStorageConditionSymbols,
        samplesOutStorageConditionSymbols, incubationConditionSymbol, incubationConditionObject, incubationStorageConditionSymbols,
        imagingRunTime, spreadingRunTime, repeatedCycleRunTime, runTime, imagerResource, spreaderResource, incubatorResource,
        manualProtocolPacket, allResourceBlobs, fulfillableQ, frqTests
      },

      (* Make the fast association *)
      fastAssoc = makeFastAssocFromCache[cache];

      (* Pull out the packets from the fast assoc *)
      fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
      samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
      containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
      containers = Lookup[containerPackets, Object];
      storageConditionPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];

      (* Pull out the necessary resolved options that need to be in discrete fields in the protocol object *)
      {
        (*1*)imagingInstrument,
        (*2*)spreaderInstrument,
        (*3*)incubator,
        (*4*)dilutionTypes,
        (*5*)dilutionStrategies,
        (*6*)numberOfDilutions,
        (*7*)cumulativeDilutionFactors,
        (*8*)serialDilutionFactors,
        (*9*)colonySpreadingTools,
        (*10*)spreadVolumes,
        (*11*)dispenseCoordinates,
        (*12*)spreadPatternTypes,
        (*13*)customSpreadPatterns,
        (*14*)destinationContainers,
        (*15*)destinationWells,
        (*16*)destinationMedia,
        (*17*)incubationCondition,
        (*18*)temperature,
        (*19*)relativeHumidity,
        (*20*)carbonDioxide,
        (*21*)shake,
        (*22*)shakingRadius,
        (*23*)shakingRate,
        (*24*)colonyIncubationTime,
        (*25*)maxColonyIncubationTime,
        (*26*)incubationInterval,
        (*27*)minReliableColonyCount,
        (*28*)maxReliableColonyCount,
        (*29*)incubateUntilCountable,
        (*30*)numberOfStableIntervals,
        (*31*)minDiameter,
        (*32*)maxDiameter,
        (*33*)minColonySeparation,
        (*34*)minRegularityRatio,
        (*35*)maxRegularityRatio,
        (*36*)minCircularityRatio,
        (*37*)maxCircularityRatio,
        (*38*)imagingStrategies,
        (*39*)exposureTimes,
        (*40*)populations,
        (*41*)populationCellTypes,
        (*42*)populationIdentities,
        (*43*)samplesInStorageConditions,
        (*44*)samplesOutStorageConditions,
        (*45*)parentProtocol
      } = Lookup[myResolvedOptions,
        {
          (*1*)ImagingInstrument,
          (*2*)SpreaderInstrument,
          (*3*)Incubator,
          (*4*)DilutionType,
          (*5*)DilutionStrategy,
          (*6*)NumberOfDilutions,
          (*7*)CumulativeDilutionFactor,
          (*8*)SerialDilutionFactor,
          (*9*)ColonySpreadingTool,
          (*10*)SpreadVolume,
          (*11*)DispenseCoordinates,
          (*12*)SpreadPatternType,
          (*13*)CustomSpreadPattern,
          (*14*)DestinationContainer,
          (*15*)DestinationWell,
          (*16*)DestinationMedia,
          (*17*)IncubationCondition,
          (*18*)Temperature,
          (*19*)RelativeHumidity,
          (*20*)CarbonDioxide,
          (*21*)Shake,
          (*22*)ShakingRadius,
          (*23*)ShakingRate,
          (*24*)ColonyIncubationTime,
          (*25*)MaxColonyIncubationTime,
          (*26*)IncubationInterval,
          (*27*)MinReliableColonyCount,
          (*28*)MaxReliableColonyCount,
          (*29*)IncubateUntilCountable,
          (*30*)NumberOfStableIntervals,
          (*31*)MinDiameter,
          (*32*)MaxDiameter,
          (*33*)MinColonySeparation,
          (*34*)MinRegularityRatio,
          (*35*)MaxRegularityRatio,
          (*36*)MinCircularityRatio,
          (*37*)MaxCircularityRatio,
          (*38*)ImagingStrategies,
          (*39*)ExposureTimes,
          (*40*)Populations,
          (*41*)PopulationCellTypes,
          (*42*)PopulationIdentities,
          (*43*)SamplesInStorageCondition,
          (*44*)SamplesOutStorageCondition,
          (*45*)ParentProtocol
        }
      ];

      (* --- Make all the resources needed in the experiment --- *)
      (* -- Generate resources for the SamplesIn -- *)

      (* Prepare the sample resources *)
      sampleResources = Resource[Sample -> #, Name -> ToString[#]]& /@ mySamples;

      (* Prepare the container resources *)
      inputContainersNoDupes = DeleteDuplicates[containers];
      sampleContainerResources = Resource[Sample -> #, Name -> ToString[#]]& /@ inputContainersNoDupes;
      containerResourceRules = AssociationThread[inputContainersNoDupes, sampleContainerResources];

      (* Figure out the samples in storage condition symbol *)
      samplesInStorageConditionSymbols = Map[
        If[MatchQ[#, ObjectP[Model[StorageCondition]]],
          fastAssocLookup[fastAssoc, #, StorageCondition],
          #
        ]&,
        samplesInStorageConditions
      ];

      (* Figure out the samples out storage condition symbol *)
      samplesOutStorageConditionSymbols = Map[
        If[MatchQ[#, ObjectP[Model[StorageCondition]]],
          fastAssocLookup[fastAssoc, #, StorageCondition],
          #
        ]&,
        samplesOutStorageConditions
      ];

      (* Figure out the incubation condition symbols and objects *)
      incubationConditionSymbol = If[MatchQ[incubationCondition, ObjectP[Model[StorageCondition]]],
        fastAssocLookup[fastAssoc, incubationCondition, StorageCondition],
        incubationCondition
      ];

      incubationConditionObject = Which[
          (* custom doesn't have a storage condition object that goes with it *)
          MatchQ[incubationCondition, Custom], Null,
          MatchQ[incubationCondition, ObjectP[Model[StorageCondition]]], incubationCondition,
          (* get the storage condition object that corresponds to the symbol we have already *)
          True, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> incubationCondition], <|Object -> Null|>], Object]
      ];

      incubationStorageConditionSymbols = Lookup[Cases[storageConditionPackets, KeyValuePattern[Object -> ObjectP[$IncubatorStorageConditions]]], StorageCondition];

      (*--Generate Instrument and Runtime in resources--*)
      imagingRunTime = 20 Minute * Length[mySamples];
      imagerResource = Resource[Instrument -> imagingInstrument, Time -> imagingRunTime, Name -> CreateUUID["QuantifyColoniesProtocol ImagingInstrument"]];

      spreadingRunTime = 40 Minute * Length[mySamples];
      spreaderResource = Resource[Instrument -> spreaderInstrument, Time -> spreadingRunTime, Name -> CreateUUID["QuantifyColoniesProtocol SpreaderInstrument"]];

      (* If we have a custom incubator, make a resource for that incubator (note that we do NOT make resources for non-custom incubators) *)
      (* note that we're excluding the robotic custom incubators because the framework will make those resources *)
      incubatorResource = If[MatchQ[incubationCondition, Custom],
        Resource[Instrument -> incubator, Time -> maxColonyIncubationTime, Name -> CreateUUID["QuantifyColoniesProtocol Custom Incubator"]],
        incubator
      ];
      repeatedCycleRunTime = If[TrueQ[incubateUntilCountable],
        maxColonyIncubationTime - colonyIncubationTime,
        1 Minute
      ];
      runTime = Total[{imagingRunTime, spreadingRunTime, repeatedCycleRunTime}];

      (* Generate the raw protocol packet *)
      manualProtocolPacket = <|
        (*=== Organizational Information ===*)
        Object -> CreateID[Object[Protocol, QuantifyColonies]],
        Type -> Object[Protocol, QuantifyColonies],
        Name -> If[MatchQ[Lookup[myResolvedOptions, Name], _String], Lookup[myResolvedOptions, Name]],
        Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
        Replace[ContainersIn] -> (Link[#, Protocols]& /@ sampleContainerResources),
        Author -> If[MatchQ[parentProtocol, Null], Link[$PersonID, ProtocolsAuthored]],
        ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], Link[parentProtocol, Subprotocols]],
        (* if we are in the root protocol here, then mark it as Overclock -> True *)
        (* if we're not in the root protocol here, then don't worry about it and in the parent function we will mark the root as Overclock -> True *)
        (* if we're robotic then it will get set in RCP itself *)
        If[NullQ[parentProtocol],
          Overclock -> True,
          Nothing
        ],
        (*=== Options Handling ===*)
        UnresolvedOptions -> unresolvedOptionsNoHidden,
        ResolvedOptions -> resolvedOptionsNoHidden,
        (*=== General ===*)
        ImagingInstrument -> Link@imagerResource,
        SpreaderInstrument -> Link@spreaderResource,
        Incubator -> Link@incubatorResource,
        (*=== Incubation ===*)
        IncubationCondition -> incubationConditionSymbol,
        IncubationConditionObject -> Link@incubationConditionObject,
        Temperature -> temperature,
        RelativeHumidity -> relativeHumidity,
        CarbonDioxide -> carbonDioxide,
        ShakingRate -> shakingRate,
        ShakingRadius -> shakingRadius,
        ColonyIncubationTime -> colonyIncubationTime,
        IncubateUntilCountable -> incubateUntilCountable,
        IncubationInterval -> incubationInterval,
        NumberOfStableIntervals -> numberOfStableIntervals,
        MaxColonyIncubationTime -> maxColonyIncubationTime,
        (*=== Spreading ===*)
        Replace[DilutionTypes] -> dilutionTypes,
        Replace[DilutionStrategies] -> dilutionStrategies,
        Replace[NumberOfDilutions] -> numberOfDilutions,
        Replace[CumulativeDilutionFactors] -> cumulativeDilutionFactors,
        Replace[SerialDilutionFactors] -> serialDilutionFactors,
        Replace[ColonySpreadingTools] -> (Link /@ colonySpreadingTools),
        Replace[SpreadVolumes] -> spreadVolumes,
        Replace[DispenseCoordinates]  -> dispenseCoordinates,
        Replace[SpreadPatternTypes] -> spreadPatternTypes,
        Replace[CustomSpreadPatterns] -> customSpreadPatterns,
        Replace[DestinationContainers] -> (Link /@ destinationContainers),
        Replace[DestinationMedia] -> (Link /@ destinationMedia),
        (*=== Analysis ===*)
        MinReliableColonyCount -> minReliableColonyCount,
        MaxReliableColonyCount -> maxReliableColonyCount,
        MinDiameter -> minDiameter,
        MaxDiameter -> maxDiameter,
        MinColonySeparation -> minColonySeparation,
        MinRegularityRatio -> minRegularityRatio,
        MaxRegularityRatio -> maxRegularityRatio,
        MinCircularityRatio -> minCircularityRatio,
        MaxCircularityRatio -> maxCircularityRatio,
        Replace[Populations] -> populations,
        Replace[PopulationCellTypes] -> populationCellTypes,
        Replace[PopulationIdentities] -> populationIdentities,
        (*=== Imaging ===*)
        Replace[ImagingStrategies] -> imagingStrategies,
        Replace[ExposureTimes] -> exposureTimes,
        (*=== Storage ===*)
        Replace[SamplesInStorage] -> samplesInStorageConditionSymbols,
        Replace[SamplesOutStorage] -> samplesOutStorageConditionSymbols,
        (*=== CheckPoint ===*)
        Replace[Checkpoints] -> {
          {"QuantificationColonySamples Preparation", spreadingRunTime, "Spread samples to solid media plates.", Link[Resource[Operator -> $BaselineOperator, Time -> spreadingRunTime]]},
          {"Incubating QuantificationColonySamples", colonyIncubationTime, "Store containers into cell incubators with desired incubation conditions.", Link[Resource[Operator -> $BaselineOperator, Time -> colonyIncubationTime]]},
          {"Quantification Colonies", imagingRunTime, "Image samples with colonies and analyze colonies.", Link[Resource[Operator -> $BaselineOperator, Time -> imagingRunTime]]},
          {"Quantification Repeat", repeatedCycleRunTime, "Incubate containers and image repeatedly.", Link[Resource[Operator -> $BaselineOperator, Time -> repeatedCycleRunTime]]},
          {"Storing Samples", 30 Minute, "Store containers into SamplesOutStorageCondition.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]}
        }
      |>;

      (* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
      allResourceBlobs = DeleteDuplicates[Cases[manualProtocolPacket, _Resource, Infinity]];

      (*---Call fulfillableResourceQ on all the resources we created---*)
      (* Call fulfillableResourceQ on all the resources we created *)
      {fulfillableQ, frqTests} = Which[
        MatchQ[$ECLApplication, Engine], {True, {}},
        gatherTests,
          Resources`Private`fulfillableResourceQ[
            allResourceBlobs,
            Output -> {Result, Tests},
            FastTrack -> Lookup[myResolvedOptions, FastTrack],
            Site -> Lookup[myResolvedOptions, Site],
            Simulation -> inheritedSimulation,
            Cache -> cache
          ],
        True,
        {
          Resources`Private`fulfillableResourceQ[
            allResourceBlobs,
            FastTrack -> Lookup[myResolvedOptions, FastTrack],
            Site -> Lookup[myResolvedOptions, Site],
            Simulation -> inheritedSimulation,
            Messages -> messages,
            Cache -> cache
          ],
          Null
        }
      ];

      (* Return result and tests *)
      {{manualProtocolPacket, Null, {}, runTime}, frqTests, fulfillableQ}
    ]
  ];
  (* --- Output --- *)
  (*---Return our options, packets, and tests---*)

  (* Generate the preview output rule; Preview is always Null *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[ToList@outputSpecification, Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
  resultRule = Result -> If[MemberQ[ToList@outputSpecification, Result] && TrueQ[fulfillable],
    result,
    $Failed
  ];

  (* Generate the tests output rule *)
  testsRule = Tests -> If[gatherTests,
    resourcePacketTests,
    {}
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule, optionsRule, resultRule, testsRule}
];

(* ::Subsection:: *)
(*Simulation Function*)
DefineOptions[simulateExperimentQuantifyColonies,
  Options :> {
    CacheOption,
    SimulationOption,
    ParentProtocolOption
  }
];

simulateExperimentQuantifyColonies[
  myProtocolPacket: (PacketP[Object[Protocol, QuantifyColonies], {Object, ResolvedOptions}]|Null|$Failed),
  myUnitOperationPacket: (PacketP[Object[UnitOperation, QuantifyColonies]]|$Failed|Null),
  mySamples: {ObjectP[Object[Sample]]..},
  myResolvedOptions: {_Rule..},
  myResolutionOptions: OptionsPattern[simulateExperimentQuantifyColonies]
] := Module[
  {preparedSample, cache, inheritedSimulation, parentProtocol, protocolObject, updatedSimulation},

  (* Get master option PreparedSample *)
  preparedSample = Lookup[ToList[myResolvedOptions], PreparedSample];
  (* Pull out the cache and simulation from the resolution options *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  inheritedSimulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
  parentProtocol = Lookup[ToList[myResolutionOptions], ParentProtocol, Null];

  (* Get our protocol ID. This should already be in our protocol packet for manual branch, unless the resource packets failed *)
  protocolObject = Which[
    (* If we are doing robotic protocol, no protocolObject here *)
    TrueQ[preparedSample] || TrueQ[$QuantifyColoniesPreparedOnly], Null,
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver *)
    MatchQ[myProtocolPacket, $Failed], SimulateCreateID[Object[Protocol, QuantifyColonies]],
    (* Otherwise, we lookup protocol from input *)
    True, Lookup[myProtocolPacket, Object]
  ];

  updatedSimulation = If[TrueQ[preparedSample] || TrueQ[$QuantifyColoniesPreparedOnly],
    (* When PreparedSample is True, we are passing simulation to simulateExperimentImageColonies *)
    (* $QuantifyColoniesPreparedOnly is another layer of safe-guard *)
    simulateExperimentImageColonies[myUnitOperationPacket, mySamples, myResolvedOptions, ExperimentQuantifyColonies, Cache -> cache, Simulation -> inheritedSimulation],
    (* For manual branch when PreparedSample is False *)
    Module[
      {
        fastAssoc, sampleContainerObjects, mapThreadFriendlyOptions, dilutionTypes, dilutionStrategies, numberOfDilutions,
        cumulativeDilutionFactors, serialDilutionFactors, destinationContainers, destinationMedia, platingVolumes, dispenses, totalPlatingVolumes,
        minReliableCount, maxReliableCount, currentSimulation, quantificationColonySampleResources, simulatedQuantificationColonySamples,
        assayContainerUnitOperations, transferSimulationPackets, updatedProtocolPacket, simulatedIncubationSamples,
        simulatedIncubationContainers, simulatedSamplePackets, compositionSimulationPackets, simulatedLabels
      },

      (* Make the fast association *)
      fastAssoc = makeFastAssocFromCache[cache];

      sampleContainerObjects = Quiet[
        Download[
          mySamples,
          Container,
          Cache -> cache,
          Simulation -> inheritedSimulation
        ],
        {Download::NotLinkField, Download::FieldDoesntExist}
      ];

      (* Get our map thread friendly options. *)
      mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
        ExperimentQuantifyColonies,
        myResolvedOptions
      ];

      (* Lookup necessary resolved options *)
      {
        dilutionTypes,
        dilutionStrategies,
        numberOfDilutions,
        cumulativeDilutionFactors,
        serialDilutionFactors,
        destinationContainers,
        destinationMedia,
        platingVolumes,
        dispenses
      } = Transpose@Map[
        Lookup[
          #,
          {
            DilutionType,
            DilutionStrategy,
            NumberOfDilutions,
            CumulativeDilutionFactor,
            SerialDilutionFactor,
            DestinationContainer,
            DestinationMedia,
            SpreadVolume,
            DispenseCoordinates
          }
        ]&,
        mapThreadFriendlyOptions
      ];
      totalPlatingVolumes = MapThread[
        #1*Length[#2]&,
        {platingVolumes, dispenses}
      ];
      {minReliableCount, maxReliableCount} = Lookup[myResolvedOptions, {MinReliableColonyCount, MaxReliableColonyCount}];

      (* Note: the destination containers are going to be fulfill checked by SpreadCells subprotocol *)
      (* NOTE: This logic is the same in streakAndSpreadCellsResourcePackets when generating destinationContainerResources *)
      (* but since they are the samplesOut, we make a flattened resource(IncubationSamples) here to pass on simulation *)
      quantificationColonySampleResources = MapThread[
        Function[{destinationContainer, destinationMedia, dilutionType, dilutionStrategy, numberOfDilutions},
          Which[
            MatchQ[destinationContainer, ObjectP[Object[Container]]] && Length[fastAssocLookup[fastAssoc, destinationContainer, Contents]] > 0,
              (* If the destination container is an object, just create the resource *)
              {Resource[Sample -> First[Download[fastAssocLookup[fastAssoc, destinationContainer, Contents][[All, 2]], Object]], Name ->  CreateUUID[]]},
            MatchQ[destinationContainer, ObjectP[Object[Container]]],
              (* Otherwise, create a resource of the media in the container *)
              {Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Gram, Name -> CreateUUID[]]},
            NullQ[numberOfDilutions] || NullQ[dilutionType],
              (* If we have a dilution conflict error, default to 1 *)
              {Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Gram, Name -> CreateUUID[]]},
            MatchQ[dilutionStrategy, Series],
              (* If Dilution strategy is Series, make numberOfDilutions + 1 duplicate resources of the media in the plate model *)
              Table[
                Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Gram, Name -> CreateUUID[]],
                {i, 1, numberOfDilutions + 1}
              ],
            MatchQ[dilutionType, Linear],
              (* If DilutionType is Linear, make NumberOfDilutions destination plate resources *)
              Table[
                Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Gram, Name -> CreateUUID[]],
                {i, 1, numberOfDilutions}
              ],
            True,
              (* Otherwise, just make a single resource *)
              {Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Gram, Name -> CreateUUID[]]}
          ]
        ],
        {
          Download[destinationContainers, Object],
          Download[destinationMedia, Object],
          dilutionTypes,
          dilutionStrategies,
          numberOfDilutions
        }
      ];

      (* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving and skipped resource packet generation. *)
      (* Just make a shell protocol object so that we can call SimulateResources with important fields *)
      (* Note:IncubationSamples is just the flatten version of QuantificationColonySamples *)
      updatedProtocolPacket = If[MatchQ[myProtocolPacket, $Failed],
        <|
          Object -> protocolObject,
          Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
          Replace[IncubationSamples] -> Link /@ (Flatten@quantificationColonySampleResources),
          ResolvedOptions -> myResolvedOptions
        |>,
        Association[
          Append[
            Normal@myProtocolPacket,
            Replace[IncubationSamples] -> Link /@ (Flatten@quantificationColonySampleResources)
          ]
        ]
      ];

      (* Simulate the fulfillment of all resources by the procedure. *)
      currentSimulation = SimulateResources[
        updatedProtocolPacket,(*ProtocolPacket*)
        Null,(*AccessoryPacket*)
        Cache -> cache,
        ParentProtocol -> parentProtocol,
        Simulation -> inheritedSimulation
      ];

      (* Update our simulation *)
      currentSimulation = UpdateSimulation[inheritedSimulation, currentSimulation];

      (* Extract IncubationSamples from the simulation *)
      {simulatedIncubationSamples, simulatedIncubationContainers} = Quiet[
        Download[
          protocolObject,
          {
            IncubationSamples,
            IncubationSamples[Container]
          },
          Cache -> cache,
          Simulation -> currentSimulation
        ],
        {Download::NotLinkField, Download::FieldDoesntExist}
      ];

      (* Partition IncubationSamples back to list of list to generate QuantificationColonySamples *)
      simulatedQuantificationColonySamples = Unflatten[simulatedIncubationSamples, quantificationColonySampleResources];

      (* Are we doing any dilutions? *)
      assayContainerUnitOperations = If[NullQ[dilutionTypes],
        (* No *)
        {},
        (* Yes *)
        Module[{spreadingSubprotocolSimulation},
          spreadingSubprotocolSimulation = ExperimentSpreadCells[
            mySamples,
            DestinationContainer-> destinationContainers,
            DestinationMedia -> destinationMedia,
            DilutionType -> dilutionTypes,
            DilutionStrategy -> dilutionStrategies,
            SpreadVolume -> platingVolumes,
            DispenseCoordinates -> dispenses,
            NumberOfDilutions -> numberOfDilutions,
            CumulativeDilutionFactor -> cumulativeDilutionFactors,
            SerialDilutionFactor -> serialDilutionFactors,
            Output -> Simulation
          ];
          (* Extract the AssayContainerUO from OutputUnitOperations *)
          Module[{uoPackets, outputUOPacket},
            uoPackets = Cases[Lookup[spreadingSubprotocolSimulation[[1]], Packets], PacketP[Object[UnitOperation, SpreadCells]]];
            outputUOPacket = FirstCase[uoPackets, KeyValuePattern[{UnitOperationType -> Output}]];
            Lookup[outputUOPacket, AssayContainerUnitOperations]
          ]
        ]
      ];

      (* Update the dilution of SamplesIn *)
      transferSimulationPackets = If[MatchQ[assayContainerUnitOperations, {}],
        Module[{transferTuples},
          (* NOTE: This logic is the same as simulateExperimentSpreadAndStreakCells, no dilution is simulated *)
          (* Here we also want to update the sample with simulated volume *)
          (* Create transfer tuples to pass to UploadSampleTransfer *)
          transferTuples = Flatten[
            MapThread[
              Function[{mySample, destinationSamples, spreadVolume, numberOfDispenses},
                Map[
                  Function[{destinationSample},
                    {
                      mySample,
                      destinationSample,
                      spreadVolume * numberOfDispenses
                    }
                  ],
                  destinationSamples
                ]
              ],
              {
                mySamples,
                simulatedQuantificationColonySamples,
                platingVolumes,
                Length /@ dispenses
              }
            ],
            {1, 2}
          ];

          (* Pass the transfers to UploadSampleTransfer to get upload packets *)
          UploadSampleTransfer[
            transferTuples[[All, 1]],
            transferTuples[[All, 2]],
            transferTuples[[All, 3]],
            Upload -> False,
            Simulation -> currentSimulation,
            FastTrack -> True
          ]
        ],
        (* Here we simulate dilution for SamplesIn with CP *)
        Module[{allMCPSimulatedPackets, samplesInSimulatedPackets},
          allMCPSimulatedPackets = Lookup[
            ExperimentCellPreparation[
              assayContainerUnitOperations,
              Output -> Simulation,
              ImageSample -> False,
              MeasureWeight -> False,
              MeasureVolume -> False][[1]],
            Packets
          ];
          (* Remove protocol and UO simulation packets *)
          samplesInSimulatedPackets = Cases[allMCPSimulatedPackets, Except[PacketP[{Object[Protocol], Object[UnitOperation]}]]];
          samplesInSimulatedPackets
        ]
      ];

      (* UpdateSimulation *)
      currentSimulation = UpdateSimulation[currentSimulation, Simulation[transferSimulationPackets]];

      (* Extract the Composition of IncubationSamples/QuantificationColonySamples after UploadSampleTransfer simulation *)
      simulatedSamplePackets = Quiet[
        Download[
          protocolObject,
          Packet[IncubationSamples[Composition]],
          Cache -> cache,
          Simulation -> currentSimulation
        ],
        {Download::NotLinkField, Download::FieldDoesntExist}
      ];

      (* Update Composition of SamplesIn *)
      (* --- simulate the composition update --- *)
      compositionSimulationPackets = Flatten@MapThread[
        Function[{mySample, destinationSamples, cumulativeDilutionFactor, dilutionType, platingVolume},
          Module[
            {
              updatingAnalyte, samplesOutUpdatePackets, maxQuantificationDilutionFactor, calculatedCFU,
              previousComposition, updatedComposition, sampleInUpdatePacket
            },
            (* Select the main cell identity model of input sample *)
            updatingAnalyte = First@Experiment`Private`selectMainCellFromSample[mySample, CellType -> {Bacterial, Yeast}, Cache -> cache, Simulation -> currentSimulation];
            (* Assume all SolidMedia plates prepared from my sample has the optimized colony count:1/2*(minReliableCount + maxReliableCount) *)
            samplesOutUpdatePackets = Map[
              Module[{oldComposition, newComposition},
                oldComposition = Lookup[fetchPacketFromCache[#, simulatedSamplePackets], Composition];
                (* create the new composition *)
                newComposition = Prepend[
                  DeleteCases[oldComposition, {_, LinkP[updatingAnalyte], _}],
                  {0.5*(minReliableCount + maxReliableCount) Colony, Link[Download[updatingAnalyte, Object]], Now}
                ];
                <|
                  Object -> Download[#, Object],
                  Replace[Composition] -> newComposition
                |>
              ]&,
              destinationSamples
            ];
            (* Estimate the SampleIn composition based on QuantificationColonyDilutionFactors *)
            maxQuantificationDilutionFactor = If[!NullQ[dilutionType],
              (* If dilution is performed, the largest factor is the last element in CumulativeDilutionFactor *)
              LastOrDefault[ToList@cumulativeDilutionFactor],
              (* If no dilution is performed, DilutionFactor is 1 *)
              1
            ];
            (* Calculate CFU with the largest colony number *)
            calculatedCFU = Quantity[
              maxQuantificationDilutionFactor*0.5*(minReliableCount + maxReliableCount)/Unitless[UnitConvert[platingVolume, "Microliters"]],
              CFU/Microliter
            ];
            previousComposition = Experiment`Private`fastAssocLookup[fastAssoc, mySample, Composition];
            updatedComposition = Prepend[
              DeleteCases[previousComposition, {_, LinkP[updatingAnalyte], _}],
              {calculatedCFU, Link[Download[updatingAnalyte, Object]], Now}
            ];
            sampleInUpdatePacket = <|
              Object -> Download[mySample, Object],
              Replace[Composition] -> updatedComposition
            |>;
            Join[samplesOutUpdatePackets, {sampleInUpdatePacket}]
          ]
        ],
        {mySamples, simulatedQuantificationColonySamples, cumulativeDilutionFactors, dilutionTypes, totalPlatingVolumes}
      ];

      (* UpdateSimulation *)
      currentSimulation = UpdateSimulation[currentSimulation, Simulation[compositionSimulationPackets]];

      (* Update the simulated labels *)
      simulatedLabels = Simulation[
        Labels -> Join[
          Rule @@@ Cases[
            Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
            {_String, ObjectP[]}
          ],
          Rule @@@ Cases[
            Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Download[Flatten[sampleContainerObjects], Object]}],
            {_String, ObjectP[]}
          ],
          Rule @@@ Cases[
            Transpose[{Flatten@Lookup[myResolvedOptions, SampleOutLabel], Download[simulatedIncubationSamples, Object]}],
            {_String, ObjectP[]}
          ],
          Rule @@@ Cases[
            Transpose[{Flatten@Lookup[myResolvedOptions, ContainerOutLabel], Download[simulatedIncubationContainers, Object]}],
            {_String, ObjectP[]}
          ]
        ]
      ];

      (* Return the updated simulation *)
      currentSimulation = UpdateSimulation[currentSimulation, simulatedLabels]
    ]
  ];
  (* Return the Updated simulation *)
  {protocolObject, updatedSimulation}
];

(* ::Subsection:: *)
DefineOptions[resolveQuantifyColoniesMethod,
  SharedOptions :> {
    ExperimentQuantifyColonies,
    CacheOption,
    SimulationOption
  }
];

resolveQuantifyColoniesMethod[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]|{_String, ObjectP[Object[Container]]}],
  myOptions: OptionsPattern[]
] := Module[
  {
    safeOps, outputSpecification, output, gatherTests, cache, simulation, specifiedPreparation, specifiedPreparedSample,
    initialFastAssoc, initialFastAssocKeys, allSpecifiedContainerObjs, allSpecifiedSampleObjs, samplePacketsExistQs,
    containerPacketsExistQs, remainingSampleObjs, remainingContainerObjs, allDownloadedStuff, allPackets, fastAssoc,
    sampleStates, manualSpecificOptions, manualRequirementStrings, roboticRequirementStrings, result, tests
  },

  (* Get the safe options *)
  safeOps = SafeOptions[resolveQuantifyColoniesMethod, ToList[myOptions]];

  (* Determine the requested return value from the function *)
  outputSpecification = Lookup[safeOps, Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Pull out the cache, simulation, and specified preparation *)
  {cache, simulation, specifiedPreparation, specifiedPreparedSample} = Lookup[safeOps, {Cache, Simulation, Preparation, PreparedSample}];
  initialFastAssoc = makeFastAssocFromCache[cache];
  initialFastAssocKeys = Keys[initialFastAssoc];

  (* Get all the relevant sample/container objects/models from inputs *)
  allSpecifiedContainerObjs = Download[DeleteDuplicates[Cases[Flatten[ToList@myInputs], ObjectP[Object[Container]]]], Object];
  allSpecifiedSampleObjs = Download[DeleteDuplicates[Cases[Flatten[ToList@myInputs], ObjectP[Object[Sample]]]], Object];

  (* Figure out if we have all the information about input samples, containers, and models *)
  (* for input models this is easy: just do we have the packet at all? *)
  (* for samples, this means do we have packets for the container models, the containers, and the samples? *)
  samplePacketsExistQs = Map[
    Function[specifiedSampleObj,
      And[
        MemberQ[initialFastAssocKeys, specifiedSampleObj],
        MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Object}]],
        MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedSampleObj, {Container, Model, Object}]]
      ]
    ],
    allSpecifiedSampleObjs
  ];
  containerPacketsExistQs = Map[
    Function[specifiedContainerObj,
      And[
        MemberQ[initialFastAssocKeys, specifiedContainerObj],
        MemberQ[initialFastAssocKeys, fastAssocLookup[initialFastAssoc, specifiedContainerObj, {Model, Object}]],
        And @@ (MemberQ[initialFastAssocKeys, #]& /@ Download[fastAssocLookup[initialFastAssoc, specifiedContainerObj, Contents][[All, 2]], Object])
      ]
    ],
    allSpecifiedContainerObjs
  ];

  (* Get the remaining objects that we don't have any information about *)
  remainingSampleObjs = PickList[allSpecifiedSampleObjs, samplePacketsExistQs, False];
  remainingContainerObjs = PickList[allSpecifiedContainerObjs, containerPacketsExistQs, False];

  allDownloadedStuff = Quiet[
    Download[
      {
        remainingSampleObjs,
        remainingContainerObjs
      },
      {
        {
          Packet[Contents[[All, 2]][{Name, State, Container}]],
          Packet[Name, State, Contents],
          Packet[Model[{Name, State}]]
        },
        {
          Packet[Name, State, Container],
          Packet[Container[{Name, Model}]],
          Packet[Container[Model[{Name}]]]
        }
      },
      Cache -> cache,
      Simulation -> simulation
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  (* Join all packets. *)
  allPackets = FlattenCachePackets[{cache, allDownloadedStuff}];
  fastAssoc = makeFastAssocFromCache[allPackets];

  (* Get information that we need from our input samples. *)
  sampleStates = Map[
    Which[
      MatchQ[#, ObjectP[Object[Sample]]],
        fastAssocLookup[fastAssoc, #, State],
      MatchQ[#, ObjectP[Object[Container]]],
        fastAssocLookup[fastAssoc, FirstOrDefault[Download[fastAssocLookup[fastAssoc, #, Contents][[All, 2]], Object]], State],
      True,
        Null
    ]&,
    Join[allSpecifiedContainerObjs, allSpecifiedSampleObjs]
  ];

  (* Pull out options which can determine WorkCell *)
  manualSpecificOptions = {
    SpreaderInstrument,
    Incubator,
    DilutionType,
    DilutionStrategy,
    NumberOfDilutions,
    CumulativeDilutionFactor,
    SerialDilutionFactor,
    ColonySpreadingTool,
    SpreadVolume,
    DispenseCoordinates,
    SpreadPatternType,
    CustomSpreadPattern,
    DestinationContainer,
    DestinationWell,
    DestinationMedia,
    IncubationCondition,
    Temperature,
    SampleOutLabel,
    ContainerOutLabel,
    ColonyIncubationTime,
    MaxColonyIncubationTime,
    IncubationInterval,
    IncubateUntilCountable,
    NumberOfStableIntervals
  };

  (* Create a list of reasons why we need Preparation->Manual. *)
  manualRequirementStrings = {
    If[MatchQ[specifiedPreparation, Manual],
      "the Preparation option is set to Manual by the user",
      Nothing
    ],
    If[MatchQ[specifiedPreparedSample, False],
      "the PreparedSample option is set to False by the user",
      Nothing
    ],
    Module[{manualOnlyOptions},
      manualOnlyOptions = Select[manualSpecificOptions, (!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic|{{Automatic..}...}]]&)];

      If[Length[manualOnlyOptions] > 0,
        "the following Manual-only options were specified " <> ToString[manualOnlyOptions],
        Nothing
      ]
    ],
    Module[{},
      (* If switched to V1, we should not throw manual-required for liquid samples as they are outright not allowed, instead of requiring manual prep. *)
      If[MemberQ[sampleStates, Liquid] && !TrueQ[$QuantifyColoniesPreparedOnly],
        "the following samples are liquid " <> ObjectToString[PickList[Join[allSpecifiedContainerObjs, allSpecifiedSampleObjs], sampleStates, Liquid], Cache -> cache, Simulation -> simulation],
        Nothing
      ]
    ]
  };

  (* Create a list of reasons why we need Preparation->Robotic. *)
  roboticRequirementStrings = {
    If[MatchQ[specifiedPreparation, Robotic],
      "the Preparation option is set to Robotic by the user",
      Nothing
    ],
    If[MatchQ[specifiedPreparedSample, True],
      "the PreparedSample option is set to True by the user",
      Nothing
    ],
    Module[{},
      If[MemberQ[sampleStates, Solid],
        "the following samples are solid " <> ObjectToString[PickList[Join[allSpecifiedContainerObjs, allSpecifiedSampleObjs], sampleStates, Solid], Cache -> cache, Simulation -> simulation],
        Nothing
      ]
    ]
  };

  (* Throw an error if the user has already specified the WorkCell option and it's in conflict with our requirements. *)
  If[Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0 && !gatherTests,
    (* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
    Block[{$MessagePrePrint},
      Message[
        Error::ConflictingUnitOperationMethodRequirements,
        listToString[manualRequirementStrings],
        listToString[roboticRequirementStrings]
      ]
    ]
  ];

  (* Return our result and tests. *)
  result = Which[
    !MatchQ[specifiedPreparation, Automatic], {specifiedPreparation},
    (* Just Robotic for v1 *)
    TrueQ[$QuantifyColoniesPreparedOnly], {Robotic},
    Length[manualRequirementStrings] > 0, {Manual},
    Length[roboticRequirementStrings] > 0, {Robotic},
    True, {Manual, Robotic}
  ];

  tests = If[MatchQ[gatherTests, False],
    {},
    {
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation for QuantifyColonies",
        Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0,
        False
      ]
    }
  ];

  outputSpecification/.{Result -> result, Tests -> tests}
];

(* ::Subsection:: *)
(*workCellResolver Function*)
resolveQuantifyColoniesWorkCell[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions: OptionsPattern[]
] := Module[{workCell, preparation},

  (* Pull out WorkCell and Preparation options *)
  workCell = Lookup[myOptions, WorkCell, Automatic];
  preparation = Lookup[myOptions, Preparation];

  (* Determine the WorkCell that can be used *)
  Which[
    MatchQ[workCell, Except[Automatic]], {workCell},
    (* Just qPix for v1 *)
    TrueQ[$QuantifyColoniesPreparedOnly], {qPix},
    MatchQ[preparation, Robotic], {qPix},
    True, Null
  ]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentQuantifyColoniesOptions*)

DefineOptions[ExperimentQuantifyColoniesOptions,
  Options :> {
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }

  },
  SharedOptions :> {ExperimentQuantifyColonies}
];

ExperimentQuantifyColoniesOptions[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

  (* get only the options for ExperimentQuantifyColonies *)
  options = ExperimentQuantifyColonies[myInputs, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
    LegacySLL`Private`optionsToTable[options, ExperimentQuantifyColonies],
    options
  ]
];

(* ::Subsection:: *)
(*ExperimentQuantifyColoniesPreview*)


DefineOptions[ExperimentQuantifyColoniesPreview,
  SharedOptions :> {ExperimentQuantifyColonies}
];

ExperimentQuantifyColoniesPreview[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {listedOptions, noOutputOptions},

  (* Get the options as a list*)
  listedOptions = ToList[myOptions];

  (* Remove the Output options before passing to the main function. *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (*PlotContents, MouseOver, Tooltip*)
  (* Return only the preview for ExperimentQuantifyColonies *)
  ExperimentQuantifyColonies[myInputs, Append[noOutputOptions, Output -> Preview]]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentQuantifyColoniesQ*)


DefineOptions[ValidExperimentQuantifyColoniesQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentQuantifyColonies}
];

ValidExperimentQuantifyColoniesQ[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {
    listedOptions, preparedOptions, experimentQuantifyColoniesTests, initialTestDescription, allTests, verbose, outputFormat
  },

  (* Get the options as a list. *)
  listedOptions = ToList[myOptions];

  (* Remove the Output option before passing to the core function because it doesn't make sense here. *)
  preparedOptions = DeleteCases[listedOptions, (Output|Verbose|OutputFormat) -> _];

  (* Return only the tests for ExperimentQuantifyColonies. *)
  experimentQuantifyColoniesTests = ExperimentQuantifyColonies[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description. *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* Make a list of all the tests, including the blanket test. *)
  allTests = If[MatchQ[experimentQuantifyColoniesTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {
        initialTest, validObjectBooleans, voqWarnings, inputObjects, inputStrands, inputSequences, validStrandBooleans,
        validStrandsWarnings, validSequenceBooleans, validSequencesWarnings
      },

      (* Generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* Sort inputs by what kind of input this is. *)
      inputObjects = Cases[ToList[myInputs], ObjectP[]];
      inputStrands = Cases[ToList[myInputs], StrandP[]];
      inputSequences = Cases[ToList[myInputs], SequenceP[]];

      (* Create warnings for invalid objects. *)
      validObjectBooleans = If[Length[inputObjects] > 0,
        ValidObjectQ[inputObjects, OutputFormat -> Boolean],
        {}
      ];
      voqWarnings = If[Length[inputObjects] > 0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputObjects, validObjectBooleans}
          ]
        ],
        {}
      ];

      (* Create warnings for invalid Strands. *)
      validStrandBooleans = If[Length[inputStrands] > 0,
        ValidStrandQ[inputStrands],
        {}
      ];
      validStrandsWarnings = If[Length[inputStrands] > 0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidStrandQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputStrands, validStrandBooleans}
          ]
        ],
        {}
      ];

      (* Create warnings for invalid Strands. *)
      validSequenceBooleans = If[Length[inputSequences] > 0,
        ValidSequenceQ[inputSequences],
        {}
      ];
      validSequencesWarnings = If[Length[inputSequences] > 0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidSequenceQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputSequences, validSequenceBooleans}
          ]
        ],
        {}
      ];

      (* Get all the tests/warnings. *)
      DeleteCases[Flatten[{initialTest, experimentQuantifyColoniesTests, voqWarnings, validStrandsWarnings, validSequencesWarnings}], Null]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense. *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* Run all the tests as requested. *)
  Lookup[RunUnitTest[<|"ValidExperimentQuantifyColoniesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentQuantifyColoniesQ"]
];

(* ::Subsubsection::Closed:: *)
