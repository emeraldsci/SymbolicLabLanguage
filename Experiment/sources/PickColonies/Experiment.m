(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*PickColonies*)


(* ::Subsection::Closed:: *)
(*Define Options*)


(* ::Subsubsection::Closed:: *)
(*Sanitization Option Set*)


(* ::Code::Initialization:: *)
DefineOptionSet[QPixSanitizationSharedOptions :> {
  IndexMatching[
    IndexMatchingInput -> "experiment samples",
    {
      OptionName -> PrimaryWash,
      Default -> True,
      Description -> "For each sample, indicates if the PrimaryWash stage should be turned on during the sanitization process.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> PrimaryWashSolution,
      Default -> Automatic,
      Description -> "For each sample, the first wash solution that is used during the sanitization process prior to each round of picking.",
      ResolutionDescription -> "Automatically set to Model[Sample,StockSolution,\"70% Ethanol\"], if PrimaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> NumberOfPrimaryWashes,
      Default -> Automatic,
      Description -> "For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the PrimaryWashSolution to clean any material off the head.",
      ResolutionDescription -> "Automatically set to 5 if PrimaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0, 1]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> PrimaryDryTime,
      Default -> Automatic,
      Description -> "For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in PrimaryWashSolution.",
      ResolutionDescription -> "Automatically set to 10 seconds if PrimaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Second
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> SecondaryWash,
      Default -> Automatic,
      Description -> "For each sample, indicates if the SecondaryWash stage should be turned on during the sanitization process.",
      ResolutionDescription -> "Automatically set to False if PrimaryWash is False.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> SecondaryWashSolution,
      Default -> Automatic,
      Description -> "For each sample, the second wash solution that can be used during the sanitization process prior to each round of picking.",
      ResolutionDescription -> "Automatically set to Model[Sample,\"Milli-Q water\"] if SecondaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> NumberOfSecondaryWashes,
      Default -> Automatic,
      Description -> "For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the SecondaryWashSolution to clean any material off the head.",
      ResolutionDescription -> "Automatically set to 5 if SecondaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0, 1]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> SecondaryDryTime,
      Default -> Automatic,
      Description -> "For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in SecondaryWashSolution.",
      ResolutionDescription -> "Automatically set to 10 seconds if SecondaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Second
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> TertiaryWash,
      Default -> Automatic,
      Description -> "For each sample, indicates if the TertiaryWash stage should be turned on during the sanitization process.",
      ResolutionDescription -> "Automatically set to False if SecondaryWash is False.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> TertiaryWashSolution,
      Default -> Automatic,
      Description -> "For each sample, the third wash solution that can be used during the sanitization process prior to each round of picking.",
      ResolutionDescription -> "Automatically set to Model[Sample, StockSolution, \"10% Bleach\"] if TertiaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> NumberOfTertiaryWashes,
      Default -> Automatic,
      Description -> "For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the TertiaryWashSolution to clean any material off the head.",
      ResolutionDescription -> "Automatically set to 5 if TertiaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0, 1]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> TertiaryDryTime,
      Default -> Automatic,
      Description -> "For each sample, the length of time to dry the ColonyHandlerHeadCassette over the halogen fan after the cassette is washed in TertiaryWashSolution.",
      ResolutionDescription -> "Automatically set to 10 seconds if TertiaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Second
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> QuaternaryWash,
      Default -> Automatic,
      Description -> "For each sample, indicates if the QuaternaryWash stage should be turned on during the sanitization process.",
      ResolutionDescription -> "Automatically set to False if TertiaryWash is False.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> QuaternaryWashSolution,
      Default -> Automatic,
      Description -> "For each sample, the fourth wash solution that can be used during the process prior to each round of picking.",
      ResolutionDescription -> "Automatically set to Model[Sample,StockSolution,\"70% Ethanol\"] if QuaternaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> NumberOfQuaternaryWashes,
      Default -> Automatic,
      Description -> "For each sample, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the QuaternaryWashSolution to clean any material off the head.",
      ResolutionDescription -> "Automatically set to 5 if QuaternaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0, 1]
      ],
      Category -> "Sanitization"
    },
    {
      OptionName -> QuaternaryDryTime,
      Default -> Automatic,
      Description -> "For each sample, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in QuaternaryWashSolution.",
      ResolutionDescription -> "Automatically set to 10 seconds if QuaternaryWash is True.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Second],
        Units -> Second
      ],
      Category -> "Sanitization"
    }
  ]
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentPickColonies Options*)


(* ::Code::Initialization:: *)
(* Define Options *)
DefineOptions[ExperimentPickColonies,
  Options :>  {
    (* Non-IndexMatching InstrumentOptions *)
    {
      OptionName -> Instrument,
      Default -> Automatic,
      Description -> "The robotic instrument that is used to transfer colonies incubating on solid media to fresh liquid or solid media.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Cell Culture",
            "Colony Handlers"
          }
        }
      ],
      Category -> "General"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* Selection Options *)
      ModifyOptions[AnalyzeColonies,
        OptionName -> Populations,
        Default -> Automatic,
        Description -> "For each sample, the criteria used to group colonies together into a population to pick. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen. Additionally, CustomCoordinates can be specified, which work in conjunction with the PickCoordinates option to select colonies based on pre-determined locations. For more information see documentation on colony population Unit Operations: Diameter, Isolation, Regularity, Circularity, Fluorescence, BlueWhiteScreen, MultiFeatured, and AllColonies under Experiment Principles section.",
        ResolutionDescription -> "If the Model[Cell] information in the sample object matches one of the fluorescent excitation and emission pairs of the colony picking instrument, Populations is set to Fluorescence. Otherwise, Populations is set to All.",
        Widget -> Alternatives[
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
          ],
          "Known Coordinates" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[CustomCoordinates]
          ]
        ],
        NestedIndexMatching -> True
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MinDiameter,
        Description -> "For each sample, the smallest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MaxDiameter,
        Description -> "For each sample, the largest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MinColonySeparation,
        Description -> "For each sample, the closest distance included colonies can be from each other from which colonies will be included. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MinRegularityRatio,
        Description -> "For each sample, the smallest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MaxRegularityRatio,
        Description -> "For each sample, the largest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MinCircularityRatio,
        Description -> "For each sample, the smallest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        Category -> "Selection"
      ],
      ModifyOptions[AnalyzeColoniesSharedOptions,
        OptionName -> MaxCircularityRatio,
        Description -> "For each sample, the largest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        Category -> "Selection"
      ],
      (* --- Picking Options --- *)
      {
        OptionName -> ColonyPickingTool,
        Default -> Automatic,
        Description -> "For each sample, the tool used to stab the source colonies plates from SamplesIn and either deposit any material stuck to the picking head onto the destination plate or into a destination well.",
        ResolutionDescription -> "If the DestinationContainer has 24 wells, set to Model[Part,ColonyHandlerHeadCassette, \"24-pin picking head for E. coli\" ]. If the DestinationContainer has 96 or 384 wells, or is an OmniTray, will use the PreferredColonyHandlerHeadCassette of the first Model[Cell] in the composition of the input sample. If the Composition field is not filled or there are not Model[Cell]'s in the composition, this option is automatically set to Model[Part,ColonyHandlerHeadCassette, \"96-pin picking head for E. coli - Deep well\"] if the destination is a deep well plate and Model[Part,ColonyHandlerHeadCassette, \"96-pin picking head for E. coli\"] otherwise.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Part,ColonyHandlerHeadCassette],Object[Part,ColonyHandlerHeadCassette]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Instruments",
              "Colony Handling",
              "Colony Handler Head Cassettes",
              "Colony Picking Head Cassettes"
            }
          }
        ],
        Category -> "Picking"
      },
      {
        OptionName -> HeadDiameter,
        Default -> Automatic,
        Description -> "For each sample, the width of the metal probe used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        ResolutionDescription -> "Resolves from the ColonyPickingTool[HeadDiameter].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Millimeter],
          Units -> Millimeter
        ],
        Category -> "Picking"
      },
      {
        OptionName -> HeadLength,
        Default -> Automatic,
        Description -> "For each sample, the length of the metal probe used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        ResolutionDescription -> "Resolves from the ColonyPickingTool[HeadLength].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Millimeter],
          Units -> Millimeter
        ],
        Category -> "Picking"
      },
      {
        OptionName -> NumberOfHeads,
        Default -> Automatic,
        Description -> "For each sample, the number of metal probes on the ColonyHandlerHeadCassette used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        ResolutionDescription -> "Resolves from the ColonyPickingTool[NumberOfHeads].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0, 1]
        ],
        Category -> "Picking"
      },
      {
        OptionName -> ColonyHandlerHeadCassetteApplication,
        Default -> Automatic,
        Description -> "For each sample, the designed use of the ColonyPickingTool used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        ResolutionDescription -> "Resolves from the ColonyPickingTool[Application].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> ColonyHandlerHeadCassetteTypeP (* Picking | Spreading | Streaking *)
        ],
        Category -> "Picking"
      },
      {
        OptionName -> ColonyPickingDepth,
        Default -> 2 Millimeter,
        Description -> "For each sample, the distance the picking head penetrates into the agar when picking a colony.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Millimeter, 20 Millimeter],
          Units -> Millimeter
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Picking"
      },
      {
        OptionName -> PickCoordinates,
        Default -> Automatic,
        Description -> "For each sample, the coordinates, in Millimeters, from which colonies will be picked from the source plate where {0 Millimeter, 0 Millimeter} is the center of the source well.",
        ResolutionDescription -> "Automatically set to Null if not specified.",
        AllowNull -> True,
        Widget -> Adder[
          {
            "XCoordinate" -> Widget[Type -> Quantity, Pattern :> RangeP[-63 Millimeter, 63 Millimeter], Units -> Millimeter],
            "YCoordinate" -> Widget[Type -> Quantity, Pattern :> RangeP[-43 Millimeter, 43 Millimeter], Units -> Millimeter]
          }
        ],
        Category -> "Picking"
      },
      (* --- Imaging Options --- *)
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ImagingChannels
      ],
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ImagingStrategies,
        Default -> Automatic,
        ResolutionDescription -> "Automatically set to include the BlueWhiteScreen along with BrightField if option Populations is set to include BlueWhiteScreen, set to include fluorescence along with BrightField if the Model[Cell] information in the sample matches one of the fluorescent excitation and emission pairs of the imaging instrument. Otherwise, set to BrightField as a BrightField image is always taken."
      ],
      ModifyOptions[ExperimentImageColonies,
        OptionName -> ExposureTimes,
        Description -> "For each Sample, and for each imaging strategy, a single length of time to allow the camera to capture an image. An increased exposure time leads to brighter images based on a linear scale. When set as Automatic, optimal exposure time is automatically determined during experiment. This is done by running AnalyzeImageExposure on images taken with suggested initial exposure times. The process adjusts the exposure time for subsequent image acquisitions until the optimal exposure time is found."
      ],
      (* --- Placing Options --- *)
      {
        OptionName -> DestinationMediaType,
        Default -> Automatic,
        Description -> "For each Sample, the type of media (liquid or solid) the picked colonies will be transferred in to.",
        ResolutionDescription -> "Automatically set to State that matches DestinationMedia if specified. Otherwise is set to LiquidMedia if there is a PreferredLiquidMedia specified in the Model[Cell] in the input sample. If there is no PreferredLiquidMedia but there is a PreferredSolidMedia, resolves to SolidMedia. If there is neither PreferredLiquidMedia or PreferredSolidMedia in the Model[Cell] in the input sample, defaults to LiquidMedia.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> DestinationMediaTypeP (* SolidMedia|LiquidMedia *)
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> DestinationMedia,
        Default -> Automatic,
        Description -> "For each sample, the media in which the picked colonies should be placed.",
        ResolutionDescription -> "If DestinationMediaType is LiquidMedia, automatically set to the value in the PreferredLiquidMedia field for the first Model[Cell] in the input sample Composition. If DestinationMediaType is SolidMedia, automatically set to the value in the PreferredSolidMedia field for the first Model[Cell] in the input sample.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Materials",
              "Cell Culture",
              "Media"
            }
          }
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> DestinationMediaContainer,
        Default -> Automatic,
        Description -> "For each Sample, the desired container to have picked colonies deposited in. The DestinationMediaContainer must be a SBS-format plate, either non-deepwelll type with 1, 24, or 96 wells, or deepwell plate type if it has 96 wells.",
        ResolutionDescription -> "Automatically set based on the DestinationMediaType and DestinationMedia options. Will default to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"] if DestinationMediaType is LiquidMedia and will default to Model[Container, Plate, \"Omni Tray Sterile Media Plate\"] if DestinationMediaType is SolidMedia.",
        AllowNull -> False,
        Widget -> Alternatives[
          "A single model of container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Containers",
                "Plates",
                "Colony Handling Plates"
              }
            }
          ],
          "A single container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "Multiple containers" -> Adder[
            Widget[
              Type -> Object,
              Pattern :> ObjectP[Object[Container]]
            ]
          ]
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      }
    ],
      {
        OptionName -> DestinationFillDirection,
        Default -> Row,
        Description -> "For each Sample, indicates if the DestinationMediaContainer is filled with picked colonies in row order, column order, or by custom coordinates. Row/Column completely fills spots in available row/column before moving to the next. If set to CustomCoordinates, ignores MaxDestinationNumberOfColumns and MaxDestinationNumberOfRows to fill at locations specified by DestinationCoordinates. CustomCoordinates is only applicable when DestinationMediaType is SolidMedia.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> DestinationFillDirectionP (* Row|Column|CustomCoordinates *)
        ],
        Category -> "Placing"
      },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> MaxDestinationNumberOfColumns,
        Default -> Automatic,
        Description -> "For each sample, the maximum number of columns of colonies to deposit in the destination container.",
        ResolutionDescription -> "Automatically set based on the below table after the number of colonies to pick has been determined.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0, 1]
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> MaxDestinationNumberOfRows,
        Default -> Automatic,
        Description -> "For each sample, the maximum number of rows of colonies to deposit in the destination container.",
        ResolutionDescription -> "Automatically set based on the below table after the number of colonies to pick has been determined.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0, 1]
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> DestinationCoordinates, (* If you want a specific pattern you can specify the coordinates just do it until you run out of plates for that population *)
        Default -> Null,
        Description -> "For each sample, the xy coordinates, in Millimeters, to deposit the picked colonies on solid media where {0 Millimeter, 0 Millimeter} is the center of the destination well. DestinationCoordinates is only applicable when Destination is SolidMedia.",
        AllowNull -> True,
        Widget -> Adder[
          {
            "XCoordinate" -> Widget[Type -> Quantity, Pattern :> RangeP[-60 Millimeter, 60 Millimeter], Units -> Millimeter],
            "YCoordinate" -> Widget[Type -> Quantity, Pattern :> RangeP[-40 Millimeter, 40 Millimeter], Units -> Millimeter]
          }
        ],
        NestedIndexMatching -> True,
        Category -> "Placing"
      },
      {
        OptionName -> MediaVolume,
        Default -> Automatic,
        Description -> "For each sample, the amount of liquid media in which the picked colonies are placed. MediaVolume is only applicable when DestinationMediaType -> LiquidMedia.",
        ResolutionDescription -> "Automatically set to the minimum of $MaxRoboticSingleTransferVolume and either the RecommendedFillVolume of the DestinationMediaContainer, or 40% of the MaxVolume if the field is not populated.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[1 Microliter, $MaxTransferVolume],
          Units -> {1, {Microliter, {Microliter, Milliliter}}}
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> DestinationMix,
        Default -> Automatic,
        Description -> "For each sample, indicates if the picking head is swirled in the destination plate while inoculating the liquid media. DestinationMix is only applicable when Destination -> LiquidMedia.",
        ResolutionDescription -> "If Destination is LiquidMedia or if DestinationNumberOfMixes is specified, automatically resolves to True.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      {
        OptionName -> DestinationNumberOfMixes,
        Default -> Automatic,
        Description -> "For each sample, the number of times the picking pin will be swirled in the liquid media during inoculation. DestinationNumberOfMixes is only applicable when Destination -> LiquidMedia.",
        ResolutionDescription -> "Automatically set to 5 if DestinationMix is True.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[0, $MaxNumberOfMixes, 1]
        ],
        NestedIndexMatching -> True, (* Matches to Populations *)
        Category -> "Placing"
      },
      (* --- Label Options --- *)
      {
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Adder[Widget[Type -> String, Pattern :> _String,Size -> Line]],
        Description -> "For each sample, the label of the sample(s) that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        NestedIndexMatching -> True, (* Matches to Populations *)
        UnitOperation -> True
      },
      {
        OptionName -> ContainerOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Label of Single Object Container" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "Label of Multiple Object Containers or Model Container" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description -> "For each sample, the label of the container(s) of the sample(s) that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        NestedIndexMatching -> True, (* Matches to Populations *)
        UnitOperation -> True
      },
      (* --- Storage Options --- *)
      {
        OptionName -> SamplesInStorageCondition,
        Default -> Refrigerator,
        Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be disposed.",
        AllowNull -> False,
        Category -> "Post Experiment",
        (* Null indicates the storage conditions will be inherited from the model *)
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP|Disposal]
        ]
      },
      {
        OptionName -> SamplesOutStorageCondition,
        Default -> Null,
        Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
        AllowNull -> True,
        Category -> "Post Experiment",
        (* Null indicates the storage conditions will be inherited from the model *)
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP|Disposal]
        ],
        NestedIndexMatching -> True (* Matches to Populations *)
      }
    ],
    {
      OptionName -> NumberOfReplicates,
      Default -> Null,
      Description -> "The number of times a colony selection should be picked from the input and placed in or on liquid or solid media.",
      AllowNull -> True,
      Category -> "General",
      Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]]
    },
    (* Redefine Preparation and WorkCell options because PickColonies can only occur robotically on the qpix *)
    {
      OptionName -> Preparation,
      Default -> Robotic,
      Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Robotic]
      ]
    },
    {
      OptionName -> WorkCell,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[qPix]],
      AllowNull -> False,
      Default -> qPix,
      Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
      Category -> "General"
    },

    (* Shared Options *)
    QPixSanitizationSharedOptions,
    SimulationOption,
    BiologyPostProcessingOptions,
    ProtocolOptions
  }
];


(* ::Subsection::Closed:: *)
(*Warning and Error Messages*)


(* ::Code::Initialization:: *)
(* TODO: Rewrite error checking to all be after mapthread so that we can include indices/other information in the error messages *)
(* Input Errors *)
Error::NonSolidSamples="The following input samples, `1`, do not have a solid state.";
Error::TooManyInputContainers="Among the input samples, `1`, there are more than four unique input containers. In order to prevent colony death from being outside of an incubator for an extended period of time. Please split this protocol into multiple protocols.";

(* Sanitization Errors *)
Error::PrimaryWashMismatch="The following samples, `1`, have PrimaryWash options that are in conflict with PrimaryWash. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::SecondaryWashMismatch="The following samples, `1`, have SecondaryWash options that are in conflict with SecondaryWash. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::TertiaryWashMismatch="The following samples, `1`, have TertiaryWash options that are in conflict with TertiaryWash. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::QuaternaryWashMismatch="The following samples, `1`, have QuaternaryWash options that are in conflict with QuaternaryWash. Please change the values of these options, or leave them unspecified to be set automatically.";
Error::TooManyWashSolutions="The following samples, `1`, have four unique wash solutions specified. The Model[Instrument,ColonyHandler,\"Qpix\"] only has 3 available wash baths so it can not house four different wash solutions. Please specify different WashSolutions or allow this option to be resolved automatically.";
Error::OutOfOrderWashStages="The following samples, `1`, have the following wash stages specified, `2`, but do not have the prerequisite stages specified, `3`. Please specify the required prerequisite stages or allow the options to be resolved automatically.";

(* Populations Errors *)
(* TODO: Clean up error names *)
Error::PickCoordinatesMissing="The following samples, `1`, are designated for CustomCoordinate colony selection, bypassing plate imaging and analysis. However, PickCoordinates are not specified. Please specify PickCoordinates or allow these options to be resolved automatically."; (* Populations -> CustomCoordinates but PickCoordinates are missing *)
Error::MultiplePopulationMethods="The following samples, `1`, have PickCoordinates specified but are also specifying a population primitive through the Populations option. Please align these options to either specify PickCoordinates or specify a ColonySelection."; (* Populations -> !CustomCoordinates and PickCoordinates are specified *)

(* Destination Errors *)
Error::InvalidDestinationMediaState="For the following samples, `1`, the DestinationMedia has a non `2` State. Please specify a different DestinationMedia or allow this option to be set automatically.";
Error::DestinationMediaTypeMismatch="For the following samples, `1`, the DestinationMediaType is not the same as the state of DestinationMedia. Please specify a different DestinationMedia or allow these options to be resolved automatically.";
Error::InvalidDestinationMediaContainer="The following samples, `1`, have an invalid DestinationMediaContainer. The DestinationMediaContainer must be a plate, either have 1, 24, or 96 wells, and can only be a deepwell plate if it has 96 wells. Please specify a different DestinationMediaContainer or allow this option to be resolved Automatically.";
Error::TooManyDestinationMediaContainers="The following samples, `1`, have more than 6 unique DestinationMediaContainers specified. In order to preserve deck space and to prevent colony death from being outside of an incubator, please specify fewer DestinationMediaContainers, split the protocol into multiple batches, split the protocol into multiple protocols, or allow this option to be resolved automatically.";
Error::DestinationFillDirectionMismatch="The following samples, `1`, have DestinationFillDirection set to CustomCoordinates and have either MaxDestinationNumberOfRows or MaxDestinationNumberOfColumns not set to Null. Please set MaxDestinationNumberOfRows and MaxDestinationNumberOfColumns to Null or allow these options to be resolved automatically.";
Error::MissingDestinationCoordinates="The following samples, `1`, have DestinationFillDirection set to CustomCoordinates but do not have DestinationCoordinates specified. Please specify DestinationCoordinates or allow these options to be resolved automatically.";
Warning::TooManyDestinationCoordinates="The following samples, `1`, have more than 384 specified destination coordinates. There are only 384 possible deposit locations on an omnitray so multiple colonies will be deposited at the same location. If this is not the intended behavior, please specify less than 384 DestinationCoordinates.";
Error::DestinationMixMismatch="When DestinationMix is set to True, option `2` should also be set to a non-Null value. When DestinationMix is False, option `2` should also be set as Null. The following samples, `1`, have DestinationMix and `2` option misaligned. Please adjust these options or allow these options to be set automatically.";
Error::InvalidMixOption="The following samples, `1`, have DestinationMediaType->SolidMedia and have Mix options (DestinationMix, DestinationNumberOfMixes) specified. Mixing cannot occur on a solid media destination. Please do not specify DestinationMix or DestinationNumberOfMixes when DestinationMediaType->SolidMedia or allow these options to be resolved automatically.";

(* Picking Errors *)
Error::PickingToolIncompatibleWithDestinationMediaContainer="The following samples, `1`, have a picking tool that is incompatible with the DestinationMediaContainer. Please select a tool that has the same NumberOfHeads as there are Wells in the DestinationMediaContainer, the PinLength aligns with the WellDepth of the Wells in the DestinationMediaContainer, and the Application of the ColonyPickingTool is Pick. Or allow these options to be resolved automatically.";
Error::NoAvailablePickingTool="For the following samples, `1`, a compatible picking tool could not be found. A cassette must be compatible with the all of the DestinationMediaContainers specified for the sample. A cassette is compatible with a destination container if the NumberOfHeads is the same as the NumberOfWells in the container (96 Head Cassettes are used for the 1 well omnitrays), and the PinLength aligns with the WellDepth of the Wells in the container. Please consider adjusting the DestinationMediaContainers for these samples, adjusting the batching inside this protocol, or splitting this protocol into multiple protocols.";
Warning::NotPreferredColonyHandlerHead="For the following samples, `1`, the selected ColonyPickingTool is not a PreferredColonyPickingTool for the colonies in the sample.";
Error::HeadDiameterMismatch="The following samples, `1`, have a HeadDiameter that is not the same as the HeadDiameter of the selected ColonyPickingTool. Please set this option to equal the value of the HeadDiameter field in the selected ColonyPickingTool or allow this option to be resolved automatically.";
Error::HeadLengthMismatch="The following samples, `1`, have a HeadLength that is not the same as the HeadLength of the selected ColonyPickingTool. Please set this option to equal the value of the HeadLength field in the selected ColonyPickingTool or allow this option to be resolved automatically.";
Error::NumberOfHeadsMismatch="The following samples, `1`, have a NumberOfHeads that is not the same as the NumberOfHeads of the selected ColonyPickingTool. Please set this option to equal the value of the NumberOfHeads field in the selected ColonyPickingTool or allow this option to be resolved automatically.";
Error::ColonyHandlerHeadCassetteApplicationMismatch="The following samples, `1`, have a ColonyHandlerHeadCassetteApplication that is not the same as the Application of the selected ColonyPickingTool. Please set this option to equal the value of the Application field in the selected ColonyPickingTool or allow this option to be resolved automatically.";
(* TODO: This should be greater than the well depth of the source container *)
Error::InvalidColonyPickingDepths="The following samples, `1`, have a ColonyPickingDepth that is greater than the WellDepth of a DestinationMediaContainer for that sample. Please select a smaller ColonyPickingDepth or allow this option to be resolved automatically.";
Error::TooManyPickCoordinates="The following samples, `1`, have more PickCoordinates specified than deposit locations among the DestinationMediaContainers. Please specify fewer PickCoordinates or use the Populations option to specify the types of colonies to be chosen.";

(* Label Errors *)
Error::InvalidSampleOutLabelLength = "The following samples `1`, at index, `2`, have a list of SampleOutLabels that is of invalid length for the populations `3`. The number of expected labels is `4`, while the number of provided labels is `5`. Please set this option to a list of the correct length or allow it to be resolved automatically.";
Error::InvalidContainerOutLabelLength = "The following samples `1`, at index, `2`, have a list of ContainerOutLabels that is of invalid length for the populations `3`. The number of expected labels is `4`, while the number of provided labels is `5`. Please set this option to a list of the correct length or allow it to be resolved automatically.";
Error::QPixWashSolutionInsufficientVolume = "For the sample(s), `1`, at indices, `5`, the given Object[Sample], `2`, specified as, `3`, only has volume of `4`. The wash solution needs to have at least 150mL. Please specify a valid Object[Sample] or use a Model[Sample].";


(* ::Subsection::Closed:: *)
(*Experiment Function*)


(* ::Code::Initialization:: *)
(* CORE Overload *)
ExperimentPickColonies[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
  {
    outputSpecification, output, gatherTests, listedSamplesNamed, listedOptionsNamed, safeOpsNamed, safeOpsTests,
    listedSamples, safeOps, validLengths, validLengthTests, returnEarlyQ, performSimulationQ, templatedOptions,
    templateTests, simulation, currentSimulation, inheritedOptions, preExpandedImagingStrategies, preExpandedImagingChannels,
    preExpandedExposureTimes, manuallyExpandedImagingStrategies, manuallyExpandedImagingChannels, manuallyExpandedExposureTimes,
    expandedSafeOps, cacheBall, resolvedOptionsResult, updatedSimulation, resolvedOptions, resolvedOptionsTests,
    preCollapsedResolvedOptions, collapsedResolvedOptions, protocolObject, unitOperationPacket, batchedUnitOperationPackets,
    runTime, resourcePacketTests, uploadQ, allUnitOperationPackets
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed, safeOpsTests} = If[gatherTests,
    SafeOptions[ExperimentPickColonies, listedOptionsNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentPickColonies, listedOptionsNamed, AutoCorrect -> False],{}}
  ];

  (* Replace all objects referenced by Name to ID *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed, Simulation -> Lookup[safeOpsNamed, Simulation, Null]];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentPickColonies, {listedSamples}, safeOps, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentPickColonies, {listedSamples}, safeOps], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentPickColonies, {ToList[listedSamples]}, safeOps, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentPickColonies, {ToList[listedSamples]}, safeOps], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null
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

  (* Expand index-matching options *)
  (* Normally, SingletonClassificationPreferred or ExpandedClassificationPreferred is used to expand nested index *)
  (* But only 1 set of nested indexmatching is allowed, which is Populations *)
  (* Here the only value allowed for singleton for ImagingStrategies is BrightField *)
  (* And ImagingChannels and ExposureTimes are index matched to ImagingStrategies *)
  {
    preExpandedImagingStrategies,
    preExpandedImagingChannels,
    preExpandedExposureTimes
  } = Lookup[inheritedOptions,
    {
      ImagingStrategies,
      ImagingChannels,
      ExposureTimes
    }
  ];

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
            MatchQ[preExpandedImagingChannels, _List] && !MemberQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels
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
            MatchQ[preExpandedExposureTimes, _List] && !MemberQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes
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
            MatchQ[preExpandedImagingChannels, _List] && !MemberQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels
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
            MatchQ[preExpandedExposureTimes, _List] && !MemberQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes
          ],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          True,
            preExpandedExposureTimes
        ]
      }
  ];
  (* Updating imaging options with the manually expanded values *)
  expandedSafeOps = Join[
    Last[
      ExpandIndexMatchedInputs[
        ExperimentPickColonies,
        {ToList[listedSamples]},
        Normal@KeyDrop[inheritedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes}]
      ]
    ],
    {
      ImagingStrategies -> manuallyExpandedImagingStrategies,
      ImagingChannels -> manuallyExpandedImagingChannels,
      ExposureTimes -> manuallyExpandedExposureTimes
    }
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* TODO: FILL THIS IN ONCE THE RESOLVE<TYPE>OPTIONS AND <TYPE>RESOURCE PACKETS ARE FINISHED *)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall={}; (* Quiet[Flatten[{samplePreparationCache,Download[..., Cache\[Rule]Lookup[expandedSafeOps, Cache, {}], Simulation\[Rule]updatedSimulation]}],Download::FieldDoesntExist] *)

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentPickColoniesOptions[
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
        resolveExperimentPickColoniesOptions[
          ToList[mySamples],
          expandedSafeOps,
          Cache -> cacheBall,
          Simulation -> currentSimulation],
        {}
      },
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Manually collapse ImagingStrategies, ImagingChannels, ExposureTimes. They are NestedIndexMatched to each other but that information is not *)
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
    {ImagingStrategies, ImagingChannels, ExposureTimes}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = Join[
    CollapseIndexMatchedOptions[
      ExperimentPickColonies,
      Normal@KeyDrop[resolvedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes}],
      Ignore -> ToList[myOptions],
      Messages -> False
    ],
    {
      ImagingStrategies -> Lookup[preCollapsedResolvedOptions, ImagingStrategies],
      ImagingChannels -> Lookup[preCollapsedResolvedOptions, ImagingChannels],
      ExposureTimes -> Lookup[preCollapsedResolvedOptions, ExposureTimes]
    }
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentPickColonies, collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* Figure out if we need to perform our simulation. *)
  (* NOTE: We need to perform simulation if Result is asked for in Pick since it's part of the CellPreparation experiments. *)
  (* This is because we pass down our simulation to ExperimentRCP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentPickColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> currentSimulation
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  (* NOTE: Because PickColonies can currently only happen robotically, resourcePackets only contains UnitOperationPackets *)
  {{unitOperationPacket, batchedUnitOperationPackets, runTime}, resourcePacketTests} = If[returnEarlyQ,
    {{$Failed, $Failed, $Failed}, {}},
    If[gatherTests,
      pickColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, ExperimentPickColonies, Cache -> cacheBall, Simulation -> currentSimulation, Output -> {Result, Tests}],
      {pickColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, ExperimentPickColonies, Cache -> cacheBall, Simulation -> currentSimulation], {}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  updatedSimulation = If[performSimulationQ,
    simulateExperimentPickColonies[unitOperationPacket, listedSamples, resolvedOptions, ExperimentPickColonies, Cache -> cacheBall, Simulation -> currentSimulation],
    currentSimulation
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output, Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentPickColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation->updatedSimulation
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps, Upload];

  (* Gather all the unit operation packets *)
  allUnitOperationPackets = Flatten[{unitOperationPacket, batchedUnitOperationPackets}];

  (* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[unitOperationPacket, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
      $Failed,

    (* If Upload->False, return the unit operation packets without RequireResources called*)
    !uploadQ,
      allUnitOperationPackets,

    (* Otherwise, upload an ExperimentRoboticCellPreparation *)
    True,
      Module[
        {
          primitive, nonHiddenOptions
        },
        (* Create the PickColonies primitive to feed into RoboticCellPreparation *)
        primitive = PickColonies@@Join[
          {
            Sample -> Download[ToList[mySamples], Object]
          },
          RemoveHiddenPrimitiveOptions[PickColonies, ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions = RemoveHiddenOptions[ExperimentPickColonies, collapsedResolvedOptions];

        (* Memoize the value of ExperimentPickColonies so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentPickColonies, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache = <||>;

          ExperimentPickColonies[___, options: OptionsPattern[]] := Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification = Lookup[ToList[options], Output];

            frameworkOutputSpecification/.{
              Result -> allUnitOperationPackets,
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> updatedSimulation,
              RunTime -> 1 Hour (* TODO: Make this accurate *)
            }
          ];

          ExperimentRoboticCellPreparation[
            {primitive},
            Name -> Lookup[safeOps, Name],
            Instrument -> Lookup[collapsedResolvedOptions, Instrument],
            Upload -> Lookup[safeOps, Upload],
            Confirm -> Lookup[safeOps, Confirm],
            CanaryBranch -> Lookup[safeOps, CanaryBranch],
            ParentProtocol -> Lookup[safeOps, ParentProtocol],
            Priority -> Lookup[safeOps, Priority],
            StartDate -> Lookup[safeOps, StartDate],
            HoldOrder -> Lookup[safeOps, HoldOrder],
            QueuePosition -> Lookup[safeOps, QueuePosition],
            Cache -> cacheBall
          ]
        ]
      ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentPickColonies, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> updatedSimulation,
    RunTime -> runTime
  }
];

(* Container Overload *)
ExperimentPickColonies[myContainers: ListableP[ObjectP[{Object[Container], Object[Sample]}]|_String], myOptions: OptionsPattern[]] := Module[
  {
    outputSpecification, output, gatherTests, listedContainers, listedOptions, simulation, containerToSampleResult,
    containerToSampleOutput, containerToSampleSimulation, samples, sampleOptions, containerToSampleTests
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links. *)
  {listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Lookup simulation option if it exists *)
  simulation = Lookup[listedOptions, Simulation, Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentPickColonies,
      listedContainers,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentPickColonies,
        listedContainers,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> simulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainer}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> simulation,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentPickColonies[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];


(* ::Subsection::Closed:: *)
(*Option Resolver*)


(* ::Subsubsection:: *)
(*resolveQPixSanitizationOptions*)

DefineOptions[resolveQPixSanitizationOptions,
  Options :> {
    CacheOption,
    OutputOption,
    SimulationOption
  }
];

resolveQPixSanitizationOptions[
  mySamples: {ObjectP[Object[Sample]]...},
  unresolvedSanitizationOptions: {_Rule..},
  resolvedInstrument: ObjectP[{Model[Instrument], Object[Instrument]}],
  myResolutionOptions: OptionsPattern[resolveQPixSanitizationOptions]
] := Module[
  {
    (* Set up variables *)
    outputSpecification, output, gatherTests, messages, cache, simulation, mapThreadFriendlySanitizationOptions,
    (* Error checking vars *)
    primaryWashMismatches, secondaryWashMismatches, tertiaryWashMismatches, quaternaryWashMismatches, tooManyWashSolutions,
    outOfOrderWashStages, washSolutionInsufficientVolumeErrors,
    (* Resolved Options *)
    resolvedPrimaryWashes, resolvedPrimaryWashSolutions, resolvedNumberOfPrimaryWashes, resolvedPrimaryDryTimes,
    resolvedSecondaryWashes, resolvedSecondaryWashSolutions, resolvedNumberOfSecondaryWashes, resolvedSecondaryDryTimes,
    resolvedTertiaryWashes, resolvedTertiaryWashSolutions, resolvedNumberOfTertiaryWashes, resolvedTertiaryDryTimes,
    resolvedQuaternaryWashes, resolvedQuaternaryWashSolutions, resolvedNumberOfQuaternaryWashes, resolvedQuaternaryDryTimes,
    (* InvalidOptions and Tests *)
    primaryWashMismatchOptions, primaryWashMismatchTests, secondaryWashMismatchOptions, secondaryWashMismatchTests,
    tertiaryWashMismatchOptions, tertiaryWashMismatchTests, quaternaryWashMismatchOptions, quaternaryWashMismatchTests,
    tooManyWashSolutionsOptions, tooManyWashSolutionsTests, outOfOrderWashStagesOptions, outOfOrderWashStagesTests,
    washSolutionInsufficientVolumeOptions, washSolutionInsufficientVolumeTests, uniqueWashSolutions, compatibleMaterialsBool,
    compatibleMaterialsTests, resolvedSanitizationOptions
  },

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

  (* Get the options in a mapthread friendly form *)
  mapThreadFriendlySanitizationOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPickColonies, unresolvedSanitizationOptions];

  (* Mapthread over the options and samples  *)
  {
    (* Error checking vars *)
    primaryWashMismatches,
    secondaryWashMismatches,
    tertiaryWashMismatches,
    quaternaryWashMismatches,
    tooManyWashSolutions,
    outOfOrderWashStages,
    (* Resolved Options *)
    resolvedPrimaryWashes,
    resolvedPrimaryWashSolutions,
    resolvedNumberOfPrimaryWashes,
    resolvedPrimaryDryTimes,
    resolvedSecondaryWashes,
    resolvedSecondaryWashSolutions,
    resolvedNumberOfSecondaryWashes,
    resolvedSecondaryDryTimes,
    resolvedTertiaryWashes,
    resolvedTertiaryWashSolutions,
    resolvedNumberOfTertiaryWashes,
    resolvedTertiaryDryTimes,
    resolvedQuaternaryWashes,
    resolvedQuaternaryWashSolutions,
    resolvedNumberOfQuaternaryWashes,
    resolvedQuaternaryDryTimes
  } = Transpose@MapThread[
    Function[{samples, options},
      Module[
        {
          (* error tracking vars *)
          primaryWashMismatch, secondaryWashMismatch, tertiaryWashMismatch, quaternaryWashMismatch, tooManyWashSolutions,
          outOfOrderWashStages,
          (* unresolvedOptions *)
          primaryWash, primaryWashSolution, numberOfPrimaryWashes, primaryDryTime, secondaryWash, secondaryWashSolution,
          numberOfSecondaryWashes, secondaryDryTime, tertiaryWash, tertiaryWashSolution, numberOfTertiaryWashes, tertiaryDryTime,
          quaternaryWash, quaternaryWashSolution, numberOfQuaternaryWashes, quaternaryDryTime,
          (* resolved options *)
          resolvedPrimaryWash, resolvedPrimaryWashSolution, resolvedNumberOfPrimaryWashes, resolvedPrimaryDryTime,
          resolvedSecondaryWash, resolvedSecondaryWashSolution, resolvedNumberOfSecondaryWashes, resolvedSecondaryDryTime,
          resolvedTertiaryWash, resolvedTertiaryWashSolution, resolvedNumberOfTertiaryWashes, resolvedTertiaryDryTime,
          resolvedQuaternaryWash, resolvedQuaternaryWashSolution, resolvedNumberOfQuaternaryWashes, resolvedQuaternaryDryTime
        },

        (* Initialize error tracking variables *)
        {
          primaryWashMismatch,
          secondaryWashMismatch,
          tertiaryWashMismatch,
          quaternaryWashMismatch,
          tooManyWashSolutions,
          outOfOrderWashStages
        } = ConstantArray[False, 6];

        (* Lookup the unresolved options *)
        {
          primaryWash,
          primaryWashSolution,
          numberOfPrimaryWashes,
          primaryDryTime,
          secondaryWash,
          secondaryWashSolution,
          numberOfSecondaryWashes,
          secondaryDryTime,
          tertiaryWash,
          tertiaryWashSolution,
          numberOfTertiaryWashes,
          tertiaryDryTime,
          quaternaryWash,
          quaternaryWashSolution,
          numberOfQuaternaryWashes,
          quaternaryDryTime
        } = Lookup[options,
          {
            PrimaryWash,
            PrimaryWashSolution,
            NumberOfPrimaryWashes,
            PrimaryDryTime,
            SecondaryWash,
            SecondaryWashSolution,
            NumberOfSecondaryWashes,
            SecondaryDryTime,
            TertiaryWash,
            TertiaryWashSolution,
            NumberOfTertiaryWashes,
            TertiaryDryTime,
            QuaternaryWash,
            QuaternaryWashSolution,
            NumberOfQuaternaryWashes,
            QuaternaryDryTime
          }
        ];

        (* Resolve Primary Wash Options *)
        resolvedPrimaryWash = primaryWash;

        resolvedPrimaryWashSolution = Which[
          !MatchQ[primaryWashSolution, Automatic],
            primaryWashSolution,
          (* If the option is Automatic, resolve it *)
          TrueQ[resolvedPrimaryWash],
            (* If PrimaryWash is True, set to ethanol *)
            Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], (* Model[Sample,StockSolution,"70% Ethanol"] *)
          True,
          (* If PrimaryWash is False, set to Null *)
            Null
        ];

        resolvedNumberOfPrimaryWashes = Which[
          !MatchQ[numberOfPrimaryWashes, Automatic],
            numberOfPrimaryWashes,
          (* If the option is Automatic, resolve it *)
          TrueQ[resolvedPrimaryWash],
            (* If PrimaryWash is True, set to 5 *)
            5,
          True,
            (* If PrimaryWash is False, set to Null *)
            Null
        ];

        resolvedPrimaryDryTime = Which[
          !MatchQ[primaryDryTime, Automatic],
            primaryDryTime,
          (* If the option is Automatic, resolve it *)
          TrueQ[resolvedPrimaryWash],
            (* If PrimaryWash is True, set to 10 seconds *)
            10 Second,
          True,
            (* If PrimaryWash is False, set to Null *)
            Null
        ];

        (* Check for primary wash mismatch *)
        (* There is a mismatch if PrimaryWash -> True and an option is Null, or if PrimaryWash -> False and an option is not Null *)
        primaryWashMismatch = Or[
          TrueQ[resolvedPrimaryWash] && MemberQ[{resolvedPrimaryWashSolution, resolvedNumberOfPrimaryWashes, resolvedPrimaryDryTime}, Null],
          !TrueQ[resolvedPrimaryWash] && MemberQ[{resolvedPrimaryWashSolution, resolvedNumberOfPrimaryWashes, resolvedPrimaryDryTime}, Except[Null]]
        ];

        (* Resolve Secondary Wash Options *)
        resolvedSecondaryWash = If[MatchQ[secondaryWash, Automatic],
          (* If the option is Automatic, resolve it *)
          Which[
            (* If PrimaryWash is True, resolve to True *)
            TrueQ[resolvedPrimaryWash],
              True,
            (* If any of the other Secondary wash options are set, set to True *)
            Or[
              MatchQ[secondaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfSecondaryWashes, Except[Null|Automatic]],
              MatchQ[secondaryDryTime, Except[Null|Automatic]]
            ],
              True,
            (* If any of the tertiary wash options are set, set to True *)
            Or[
              MatchQ[tertiaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfTertiaryWashes, Except[Null|Automatic]],
              MatchQ[tertiaryDryTime, Except[Null|Automatic]],
              TrueQ[tertiaryWash]
            ],
              True,
            (* If any of the Quaternary wash options are set, set to True *)
            Or[
              TrueQ[quaternaryWash],
              MatchQ[quaternaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfQuaternaryWashes, Except[Null|Automatic]],
              MatchQ[quaternaryDryTime, Except[Null|Automatic]]
            ],
             True,
            (* Otherwise set to False *)
            True,
              False
          ],
          (* Otherwise leave it as is *)
          secondaryWash
        ];

        resolvedSecondaryWashSolution = If[MatchQ[secondaryWashSolution, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedSecondaryWash],
            (* If SecondaryWash is True, set to water *)
            Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
            (* If SecondaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          secondaryWashSolution
        ];

        resolvedNumberOfSecondaryWashes = If[MatchQ[numberOfSecondaryWashes, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedSecondaryWash],
            (* If SecondaryWash is True, set to 5 *)
            5,
            (* If SecondaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave is as is *)
          numberOfSecondaryWashes
        ];

        resolvedSecondaryDryTime = If[MatchQ[secondaryDryTime, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedSecondaryWash],
            (* If SecondaryWash is True, set to 10 seconds *)
            10 Second,
            (* If SecondaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          secondaryDryTime
        ];

        (* Check for secondary wash mismatch *)
        (* There is a mismatch if SecondaryWash -> True and an option is Null, or if SecondaryWash -> False and an option is not Null *)
        secondaryWashMismatch = Or[
          TrueQ[resolvedSecondaryWash] && MemberQ[{resolvedSecondaryWashSolution, resolvedNumberOfSecondaryWashes, resolvedSecondaryDryTime}, Null],
          !TrueQ[resolvedSecondaryWash] && MemberQ[{resolvedSecondaryWashSolution, resolvedNumberOfSecondaryWashes, resolvedSecondaryDryTime}, Except[Null]]
        ];

        (* Resolve Tertiary Wash Options *)
        resolvedTertiaryWash = If[MatchQ[tertiaryWash, Automatic],
          (* If the option is Automatic, resolve it *)
          Which[
            (* If any of the other Tertiary wash options are set, set to True *)
            Or[
              MatchQ[tertiaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfTertiaryWashes, Except[Null|Automatic]],
              MatchQ[tertiaryDryTime, Except[Null|Automatic]]
            ],
              True,
            (* If any of the Quaternary wash options are set, set to True *)
            Or[
              TrueQ[quaternaryWash],
              MatchQ[quaternaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfQuaternaryWashes, Except[Null|Automatic]],
              MatchQ[quaternaryDryTime, Except[Null|Automatic]]
            ],
              True,
            (* Otherwise set to False *)
            True,
              False
          ],
          (* Otherwise leave it as is *)
          tertiaryWash
        ];

        resolvedTertiaryWashSolution = If[MatchQ[tertiaryWashSolution, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedTertiaryWash],
            (* If TertiaryWash is True, set to bleach *)
            Model[Sample, StockSolution, "id:qdkmxzq7lWRp"], (* Model[Sample, StockSolution, "10% Bleach"] *)
            (* If TertiaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          tertiaryWashSolution
        ];

        resolvedNumberOfTertiaryWashes = If[MatchQ[numberOfTertiaryWashes, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedTertiaryWash],
            (* If TertiaryWash is True, set to 5 *)
            5,
            (* If TertiaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave is as is *)
          numberOfTertiaryWashes
        ];

        resolvedTertiaryDryTime = If[MatchQ[tertiaryDryTime, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedTertiaryWash],
            (* If TertiaryWash is True, set to 10 seconds *)
            10 Second,
            (* If TertiaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          tertiaryDryTime
        ];

        (* Check for tertiary wash mismatch *)
        (* There is a mismatch if TertiaryWash -> True and an option is Null, or if TertiaryWash -> False and an option is not Null *)
        tertiaryWashMismatch = Or[
          TrueQ[resolvedTertiaryWash] && MemberQ[{resolvedTertiaryWashSolution, resolvedNumberOfTertiaryWashes, resolvedTertiaryDryTime}, Null],
          !TrueQ[resolvedTertiaryWash] && MemberQ[{resolvedTertiaryWashSolution, resolvedNumberOfTertiaryWashes, resolvedTertiaryDryTime}, Except[Null]]
        ];

        (* Resolve Quaternary Wash Options *)
        resolvedQuaternaryWash = If[MatchQ[quaternaryWash, Automatic],
          (* If the option is Automatic, resolve it *)
          If[
            Or[
              MatchQ[quaternaryWashSolution, Except[Null|Automatic]],
              MatchQ[numberOfQuaternaryWashes, Except[Null|Automatic]],
              MatchQ[quaternaryDryTime, Except[Null|Automatic]]
            ],
            (* If any of the other Quaternary wash options are set, set to True *)
            True,
            (* Otherwise set to False *)
            False
          ],
          (* Otherwise leave as is *)
          quaternaryWash
        ];

        resolvedQuaternaryWashSolution = If[MatchQ[quaternaryWashSolution, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedQuaternaryWash],
            (* If QuaternaryWash is True, set to ethanol *)
            Model[Sample, StockSolution, "70% Ethanol"],
            (* If QuaternaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          quaternaryWashSolution
        ];

        resolvedNumberOfQuaternaryWashes = If[MatchQ[numberOfQuaternaryWashes, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedQuaternaryWash],
            (* If QuaternaryWash is True, set to 5 *)
            5,
            (* If QuaternaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave is as is *)
          numberOfQuaternaryWashes
        ];

        resolvedQuaternaryDryTime = If[MatchQ[quaternaryDryTime, Automatic],
          (* If the option is Automatic, resolve it *)
          If[TrueQ[resolvedQuaternaryWash],
            (* If QuaternaryWash is True, set to 10 seconds *)
            10 Second,
            (* If QuaternaryWash is False, set to Null *)
            Null
          ],
          (* Otherwise leave it as is *)
          quaternaryDryTime
        ];

        (* Check for quaternary wash mismatch *)
        (* There is a mismatch if QuaternaryWash -> True and an option is Null, or if QuaternaryWash -> False and an option is not Null *)
        quaternaryWashMismatch = Or[
          TrueQ[resolvedQuaternaryWash] && MemberQ[{resolvedQuaternaryWashSolution, resolvedNumberOfQuaternaryWashes, resolvedQuaternaryDryTime}, Null],
          !TrueQ[resolvedQuaternaryWash] && MemberQ[{resolvedQuaternaryWashSolution, resolvedNumberOfQuaternaryWashes, resolvedQuaternaryDryTime}, Except[Null]]
        ];

        (* There are only 3 available wash baths, check to make sure there are no more than 3 unique wash solutions specified *)
        tooManyWashSolutions = Length[DeleteDuplicates[{resolvedPrimaryWashSolution, resolvedSecondaryWashSolution, resolvedTertiaryWashSolution, resolvedQuaternaryWashSolution}/.Null->Nothing,MatchQ[#1,ObjectP[#2]]&]] > 3;


        (* Determine if any prerequisite stages are not fulfilled for each stage - PrimaryWash has no prerequisites so it is always ok *)
        outOfOrderWashStages = Module[
          {
            secondaryWashMissingPrerequisites, tertiaryWashMissingPrerequisites, quaternaryWashMissingPrerequisites,
            allMissingPrerequisites, allTurnedOnWashStages
          },
          (* If the secondary stage is turned on, make sure PrimaryWash is also turned on *)
          secondaryWashMissingPrerequisites = If[TrueQ[resolvedSecondaryWash],
            If[TrueQ[resolvedPrimaryWash],
              {},
              {PrimaryWash}
            ],
            {}
          ];

          (* If the tertiary stage is turned on, make sure PrimaryWash and SecondaryWash are also turned on *)
          tertiaryWashMissingPrerequisites = If[TrueQ[resolvedTertiaryWash],
            Module[{missingStages},
              missingStages = {};
              If[!TrueQ[resolvedPrimaryWash],
                missingStages = Append[missingStages, PrimaryWash]
              ];
              If[!TrueQ[resolvedSecondaryWash],
                missingStages = Append[missingStages, SecondaryWash]
              ];
              missingStages
            ],
            {}
          ];

          (* If the quaternary stage is turned on, make sure PrimaryWash, SecondaryWash, and TertiaryWash are also turned on *)
          quaternaryWashMissingPrerequisites = If[TrueQ[resolvedQuaternaryWash],
            Module[{missingStages},
              missingStages = {};
              If[!TrueQ[resolvedPrimaryWash],
                missingStages = Append[missingStages, PrimaryWash]
              ];
              If[!TrueQ[resolvedSecondaryWash],
                missingStages = Append[missingStages, SecondaryWash]
              ];
              If[!TrueQ[resolvedTertiaryWash],
                missingStages = Append[missingStages, TertiaryWash]
              ];
              missingStages
            ],
            {}
          ];

          (* Get the unique missing stages *)
          allMissingPrerequisites = DeleteDuplicates[Join[secondaryWashMissingPrerequisites, tertiaryWashMissingPrerequisites, quaternaryWashMissingPrerequisites]];

          (* Get all the turned on stages *)
          allTurnedOnWashStages = {
            If[TrueQ[resolvedPrimaryWash], PrimaryWash, Nothing],
            If[TrueQ[resolvedSecondaryWash], SecondaryWash, Nothing],
            If[TrueQ[resolvedTertiaryWash], TertiaryWash, Nothing],
            If[TrueQ[resolvedQuaternaryWash], QuaternaryWash, Nothing]
          };

          (* Return in correct bool *)
          {Length[allMissingPrerequisites]>0, allTurnedOnWashStages, allMissingPrerequisites}
        ];


        (* Return the error tracking vars and the resolved options *)
        {
          (* Error tracking vars *)
          primaryWashMismatch, secondaryWashMismatch,
          tertiaryWashMismatch, quaternaryWashMismatch,
          tooManyWashSolutions, outOfOrderWashStages,

          (* Resolved options *)
          resolvedPrimaryWash, resolvedPrimaryWashSolution, resolvedNumberOfPrimaryWashes, resolvedPrimaryDryTime,
          resolvedSecondaryWash, resolvedSecondaryWashSolution, resolvedNumberOfSecondaryWashes, resolvedSecondaryDryTime,
          resolvedTertiaryWash, resolvedTertiaryWashSolution, resolvedNumberOfTertiaryWashes, resolvedTertiaryDryTime,
          resolvedQuaternaryWash, resolvedQuaternaryWashSolution, resolvedNumberOfQuaternaryWashes, resolvedQuaternaryDryTime
        }
      ]
    ],
    {
      mySamples,
      mapThreadFriendlySanitizationOptions
    }
  ];

  (* Throw any errors found during the option resolution *)
  (* PrimaryWash mismatch *)
  primaryWashMismatchOptions = If[MemberQ[primaryWashMismatches, True] && messages,
    Message[Error::PrimaryWashMismatch, PickList[mySamples, primaryWashMismatches]];
    {PrimaryWash, PrimaryWashSolution, NumberOfPrimaryWashes, PrimaryDryTime},
    {}
  ];
  
  primaryWashMismatchTests = If[MemberQ[primaryWashMismatches, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, primaryWashMismatches];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have conflicting PrimaryWash options:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " do not have conflicting PrimaryWash options:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* SecondaryWash mismatch *)
  secondaryWashMismatchOptions = If[MemberQ[secondaryWashMismatches, True] && messages,
    Message[Error::SecondaryWashMismatch, PickList[mySamples, secondaryWashMismatches]];
    {SecondaryWash, SecondaryWashSolution, NumberOfSecondaryWashes, SecondaryDryTime},
    {}
  ];

  secondaryWashMismatchTests = If[MemberQ[secondaryWashMismatches, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, secondaryWashMismatches];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have conflicting SecondaryWash options:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " do not have conflicting SecondaryWash options:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* TertiaryWash mismatch *)
  tertiaryWashMismatchOptions = If[MemberQ[tertiaryWashMismatches, True] && messages,
    Message[Error::TertiaryWashMismatch, PickList[mySamples, tertiaryWashMismatches]];
    {TertiaryWash, TertiaryWashSolution, NumberOfTertiaryWashes, TertiaryDryTime},
    {}
  ];

  tertiaryWashMismatchTests = If[MemberQ[tertiaryWashMismatches, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, tertiaryWashMismatches];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have conflicting TertiaryWash options:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " do not have conflicting TertiaryWash options:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* QuaternaryWash mismatch *)
  quaternaryWashMismatchOptions = If[MemberQ[quaternaryWashMismatches, True] && messages,
    Message[Error::QuaternaryWashMismatch, PickList[mySamples, quaternaryWashMismatches]];
    {QuaternaryWash, QuaternaryWashSolution, NumberOfQuaternaryWashes, QuaternaryDryTime},
    {}
  ];

  quaternaryWashMismatchTests = If[MemberQ[quaternaryWashMismatches, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, quaternaryWashMismatches];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have conflicting QuaternaryWash options:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " do not have conflicting QuaternaryWash options:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Too many wash solutions *)
  tooManyWashSolutionsOptions = If[MemberQ[tooManyWashSolutions, True] && messages,
    Message[Error::TooManyWashSolutions, PickList[mySamples, tooManyWashSolutions]];
    {PrimaryWashSolution, SecondaryWashSolution, TertiaryWashSolution, QuaternaryWashSolution},
    {}
  ];

  tooManyWashSolutionsTests = If[MemberQ[tooManyWashSolutions, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, tooManyWashSolutions];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have no more than 3 unique wash solutions specified:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " have no more than 3 unique wash solutions specified:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Out of order wash solutions *)
  outOfOrderWashStagesOptions = If[MemberQ[outOfOrderWashStages[[All, 1]], True] && messages,
    Message[Error::OutOfOrderWashStages, PickList[mySamples, outOfOrderWashStages[[All, 1]]], outOfOrderWashStages[[All, 2]], outOfOrderWashStages[[All, 3]]];
    DeleteDuplicates@Flatten[outOfOrderWashStages[[All, 3]]],
    {}
  ];

  outOfOrderWashStagesTests = If[MemberQ[outOfOrderWashStages[[All, 1]], True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, outOfOrderWashStages[[All, 1]]];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have wash stages specified in a valid order:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " have wash stages specified in a valid order:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (*Error::QPixWashSolutionInsufficientVolume*)
  washSolutionInsufficientVolumeErrors = MapThread[
    Function[{sample, primaryWashSolution, secondaryWashSolution, tertiaryWashSolution, quaternaryWashSolution, index},
      Module[{washSolutionVolumeTuples, errorBools, invalidWashSolutionOptions, invalidWashSolutionObjects, insufficientVolumes},
        (*Look up the volumes if an Object[Sample] is given*)
        washSolutionVolumeTuples = If[MatchQ[#, ObjectP[Object[Sample]]],
          {#, Lookup[fetchPacketFromCache[#, cache], Volume]},
          {#, Null}
        ]& /@ {primaryWashSolution,secondaryWashSolution, tertiaryWashSolution, quaternaryWashSolution};
        (*Determine the boolean list that corresponds to the wash solution list to indicate if this is an error-throwing condition, i.e. it is an Object[Sample], and the volume is either Null or less thann 150 mL*)
        errorBools = MatchQ[#, {ObjectP[Object[Sample]], Null|LessP[150 Milliliter]}]& /@ washSolutionVolumeTuples;

        (*Get list of insufficient volumes to return*)
        insufficientVolumes = PickList[washSolutionVolumeTuples, errorBools][[All, 2]];

        (*Get list of invalid options to return*)
        invalidWashSolutionOptions = PickList[{PrimaryWashSolution, SecondaryWashSolution, TertiaryWashSolution, QuaternaryWashSolution},
          errorBools
        ];
        (*Get list of solution objects to return*)
        invalidWashSolutionObjects = PickList[{primaryWashSolution, secondaryWashSolution, tertiaryWashSolution, quaternaryWashSolution},
          errorBools
        ];

        (*Gather the list to return*)
        If[Length[insufficientVolumes] > 0,
          {sample, invalidWashSolutionObjects, invalidWashSolutionOptions, insufficientVolumes, index},
          Nothing
        ]
      ]
    ],
    {mySamples, resolvedPrimaryWashSolutions, resolvedSecondaryWashSolutions, resolvedTertiaryWashSolutions, resolvedQuaternaryWashSolutions, Range[Length[mySamples]]}
  ];

  washSolutionInsufficientVolumeOptions = If[Length[washSolutionInsufficientVolumeErrors] > 0 && messages,
    Message[
      Error::QPixWashSolutionInsufficientVolume,
      ObjectToString[washSolutionInsufficientVolumeErrors[[All, 1]], Cache -> cache],
      ObjectToString[washSolutionInsufficientVolumeErrors[[All, 2]], Cache -> cache],
      washSolutionInsufficientVolumeErrors[[All, 3]],
      washSolutionInsufficientVolumeErrors[[All, 4]],
      washSolutionInsufficientVolumeErrors[[All, 5]]
    ];
    DeleteDuplicates[Flatten[washSolutionInsufficientVolumeErrors[[All, 3]]]],
    {}
  ];

  washSolutionInsufficientVolumeTests = If[Length[washSolutionInsufficientVolumeErrors] > 0 && gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = washSolutionInsufficientVolumeErrors[[All, 1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have at least 150mL of wash solution if an Object[Sample] is specified.", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have at least 150mL of wash solution if an Object[Sample] is specified.", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Check if any of the wash solutions are incompatible materials with the instrument *)
  uniqueWashSolutions = DeleteDuplicates[Flatten[{resolvedPrimaryWashSolutions, resolvedSecondaryWashSolutions, resolvedTertiaryWashSolutions, resolvedQuaternaryWashSolutions}/.Null -> Nothing]];

  {compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[resolvedInstrument, uniqueWashSolutions, Output -> {Result, Tests}, Cache -> cache, Simulation -> simulation],
    {CompatibleMaterialsQ[resolvedInstrument, uniqueWashSolutions, Messages -> messages, Cache -> cache,Simulation -> simulation], {}}
  ];

  (* resolvedOptions *)
  resolvedSanitizationOptions = {
    PrimaryWash -> resolvedPrimaryWashes,
    PrimaryWashSolution -> resolvedPrimaryWashSolutions,
    NumberOfPrimaryWashes -> resolvedNumberOfPrimaryWashes,
    PrimaryDryTime -> resolvedPrimaryDryTimes,
    SecondaryWash -> resolvedSecondaryWashes,
    SecondaryWashSolution -> resolvedSecondaryWashSolutions,
    NumberOfSecondaryWashes -> resolvedNumberOfSecondaryWashes,
    SecondaryDryTime -> resolvedSecondaryDryTimes,
    TertiaryWash -> resolvedTertiaryWashes,
    TertiaryWashSolution -> resolvedTertiaryWashSolutions,
    NumberOfTertiaryWashes -> resolvedNumberOfTertiaryWashes,
    TertiaryDryTime -> resolvedTertiaryDryTimes,
    QuaternaryWash -> resolvedQuaternaryWashes,
    QuaternaryWashSolution -> resolvedQuaternaryWashSolutions,
    NumberOfQuaternaryWashes -> resolvedNumberOfQuaternaryWashes,
    QuaternaryDryTime -> resolvedQuaternaryDryTimes
  };

  (* Return info about sanitization options *)
  {
    (* Invalid Options *)
    Join[
      If[!MatchQ[compatibleMaterialsBool, True],
        {Instrument},
        {}
      ],
      primaryWashMismatchOptions,
      secondaryWashMismatchOptions,
      tertiaryWashMismatchOptions,
      quaternaryWashMismatchOptions,
      tooManyWashSolutionsOptions,
      outOfOrderWashStagesOptions,
      washSolutionInsufficientVolumeOptions
    ],
    (* Tests *)
    {
      compatibleMaterialsTests,
      primaryWashMismatchTests,
      secondaryWashMismatchTests,
      tertiaryWashMismatchTests,
      quaternaryWashMismatchTests,
      tooManyWashSolutionsTests,
      outOfOrderWashStagesTests,
      washSolutionInsufficientVolumeTests
    },
    (* InvalidInputs *)
    {},
    resolvedSanitizationOptions
  }
  
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentPickColoniesOptions*)


(* ::Code::Initialization:: *)
DefineOptions[
  resolveExperimentPickColoniesOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentPickColoniesOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentPickColoniesOptions]] := Module[
  {
    (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
    outputSpecification, output, gatherTests, messages, cache, simulation, currentSimulation, pickColoniesOptionsAssociation,
    pickingColonyHandlerHeadCassettes, colonyPickingTools, destinationMedias, destinationContainers, primaryWashSolutions, 
    secondaryWashSolutions, tertiaryWashSolutions, quaternaryWashSolutions,allDestinationContainersNoLink,
    uniqueDestinationContainerObjects, uniqueDestinationContainerModels, defaultWashSolutions, allWashSolutionsNoLink,
    uniqueWashSolutionObjects, uniqueWashSolutionModels, allDestinationMediaNoLink, uniqueDestinationMediaObjects,
    uniqueDestinationMediaModels, allColonyPickingToolsNoLink, uniqueColonyPickingToolObjects, uniqueColonyPickingToolModels,
    sampleObjectDownloadPacket, sampleModelDownloadPacket, sampleContainerObjectDownloadPacket, sampleContainerModelDownloadPacket,
    containerDownloadPacket, containerModelDownloadPacket, colonyHandlerHeadCassetteObjectDownloadPacket,
    colonyHandlerHeadCassetteModelDownloadPacket, samplePackets, washSolutionObjectPackets, washSolutionModelPackets,
    destinationMediaObjectPackets, destinationMediaModelPackets, destinationContainerObjectPackets, destinationContainerModelPackets,
    colonyPickingToolObjectPackets, colonyPickingToolModelPackets, pickingColonyHandlerHeadCassettesPackets, flattenedCachePackets,
    combinedCache, combinedFastAssoc,
    (*-- INPUT VALIDATION CHECKS --*)
    discardedSamplePackets, discardedInvalidInputs, discardedTest, nonSolidSamplePackets, nonSolidInvalidInputs, nonSolidTest,
    nonOmniTrayInvalidInputs, nonOmniTrayTest, inputContainers, tooManyContainersInvalidInputs, tooManyInputContainersTest,
    compatibleMaterialsBools, compatibleMaterialsTests, duplicatedInvalidInputs, duplicatesTest,
    (*-- OPTION PRECISION CHECKS --*)
    optionPrecisions, roundedPickColoniesOptions, optionPrecisionTests,
    (*-- RESOLVE INDEPENDENT OPTIONS --*)
    instrument, destinationFillDirection, preparation, workCell, samplesInStorageCondition, samplesOutStorageCondition, mediaVolumes,
    resolvedInstrument, resolvedDestinationFillDirection, resolvedPreparation, resolvedWorkCell, resolvedSamplesInStorageCondition, 
    resolvedSamplesOutStorageCondition,
    (*-- RESOLVE SANITIZATION AND ANALYSIS OPTIONS --*)
    sanitizationOptionInvalidOptions, sanitizationOptionTests, sanitizationOptionInvalidInputs, resolvedSanitizationOptions,
    partiallyResolvedPickColoniesOptionsWithSanitization, analysisOptionInvalidOptions, analysisOptionTests, resolvedAnalysisOptions,
    resolvedPickCoordinates, partiallyResolvedPickColoniesOptionsWithAnalysis,
    (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
    mapThreadFriendlyOptions, strategiesMappingToChannels,
    (* Error Tracking *)
    missingImagingStrategiesInfos, imagingOptionSameLengthErrors, pickCoordinatesMismatchErrors, destinationMediaStateErrors,
    destinationMediaTypeMismatchErrors, invalidDestinationMediaContainerErrors, tooManyDestinationMediaContainersErrors,
    tooManyPickCoordinatesErrors, destinationFillDirectionMismatchErrors, missingDestinationCoordinatesErrors, tooManyDestinationCoordinatesWarnings,
    destinationMixMismatchErrors, invalidMixOptionErrors, pickingToolIncompatibleWithDestinationMediaContainerErrors,
    noAvailablePickingToolErrors, notPreferredColonyHandlerHeadWarnings, headDiameterMismatchErrors, headLengthMismatchErrors,
    numberOfHeadsMismatchErrors, colonyHandlerHeadCassetteApplicationMismatchErrors, invalidColonyPickingDepthErrors,
    (* Imaging *)
    resolvedImagingChannels, resolvedImagingStrategies, resolvedExposureTimes,
    (* Picking *)
    resolvedColonyPickingTools, resolvedHeadDiameters, resolvedHeadLengths, resolvedNumberOfHeads, resolvedColonyPickingDepths,
    resolvedColonyHandlerHeadCassetteApplications,
    (* Destination *)
    resolvedDestinationMediaTypes, resolvedDestinationMedia, resolvedDestinationMediaContainers, resolvedMaxDestinationNumberOfColumns,
    resolvedMaxDestinationNumberOfRows, resolvedDestinationCoordinates, resolvedMediaVolumes, resolvedDestinationMixes,
    resolvedDestinationNumberOfMixes, sampleOutLabelLengthErrors, containerOutLabelLengthErrors, resolvedSampleOutLabels,
    resolvedContainerOutLabels,
    (* -- MAPTHREAD ERROR THROWING -- *)
    invalidSampleOutLabelLengthErrors, invalidSampleOutLabelLengthOptions, invalidSampleOutLabelLengthTests,
    invalidContainerOutLabelLengthErrors, invalidContainerOutLabelLengthOptions, invalidContainerOutLabelLengthTests,
    missingImagingStrategiesOptions, missingImagingStrategiesTests, imagingOptionSameLengthOptions, imagingOptionSameLengthTests,
    destinationMediaStateOptions, destinationMediaStateTests, destinationMediaTypeMismatchOptions, destinationMediaTypeMismatchTests,
    invalidDestinationMediaContainerOptions, invalidDestinationMediaContainerTests, tooManyDestinationMediaContainersOptions,
    tooManyDestinationMediaContainersTests, tooManyPickCoordinatesOptions, tooManyPickCoordinatesTests, destinationFillDirectionMismatchOptions,
    destinationFillDirectionMismatchTests, missingDestinationCoordinatesOptions, missingDestinationCoordinatesTests,
    tooManyDestinationCoordinatesTests, destinationMixMismatchOptions, destinationMixMismatchTests, invalidMixOptionOptions,
    invalidMixOptionTests, pickingToolIncompatibleWithDestinationMediaContainerOptions, pickingToolIncompatibleWithDestinationMediaContainerTests,
    noAvailablePickingToolOptions, noAvailablePickingToolTests, notPreferredColonyHandlerHeadTests,
    headDiameterMismatchOptions, headDiameterMismatchTests, headLengthMismatchOptions, headLengthMismatchTests,
    numberOfHeadsMismatchOptions, numberOfHeadsMismatchTests, colonyHandlerHeadCassetteApplicationMismatchOptions,
    colonyHandlerHeadCassetteApplicationMismatchTests, invalidColonyPickingDepthOptions, invalidColonyPickingDepthTests,
    (*-- UNRESOLVABLE OPTION CHECKS --*)
    invalidInputs, invalidOptions, resolvedPostProcessingOptions, resolvedOptions
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation];

  (* Initialize the simulation if none exists *)
  currentSimulation = If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  pickColoniesOptionsAssociation = Association[myOptions];

  (* Search for all the ColonyHandlerHeadCassettes that are for picking colonies *)
  (* TODO: Memoize this *)
  pickingColonyHandlerHeadCassettes = Search[Model[Part,ColonyHandlerHeadCassette],Application==Pick&&Deprecated!=True];

  (* Pull out the options that may have models/objects whose information we need to download *)
  {
    colonyPickingTools,
    destinationMedias,
    destinationContainers,
    primaryWashSolutions,
    secondaryWashSolutions,
    tertiaryWashSolutions,
    quaternaryWashSolutions
  } = Lookup[
    pickColoniesOptionsAssociation,
    {
      ColonyPickingTool,
      DestinationMedia,
      DestinationMediaContainer,
      PrimaryWashSolution,
      SecondaryWashSolution,
      TertiaryWashSolution,
      QuaternaryWashSolution
    }
  ];

  (* Get the unique DestinationContainers *)
  allDestinationContainersNoLink = DeleteDuplicates[Download[Cases[Flatten@ToList[destinationContainers], ObjectP[]], Object]];
  uniqueDestinationContainerObjects = Cases[allDestinationContainersNoLink, ObjectReferenceP[Object[Container]]];
  uniqueDestinationContainerModels = Join[Cases[allDestinationContainersNoLink, ObjectReferenceP[Model[Container]]], {Model[Container, Plate, "id:n0k9mGkwbvG4"], Model[Container, Plate, "id:O81aEBZjRXvx"], Model[Container, Plate, "id:n0k9mGzRaaBn"]}]; (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Model[Container, Plate, "Omni Tray Sterile Media Plate"], Model[Container, Plate, "96-well UV-Star Plate"] *)

  (* Get the unique wash solutions *)
  defaultWashSolutions = {Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],Model[Sample, "id:8qZ1VWNmdLBD"],Model[Sample, StockSolution, "id:qdkmxzq7lWRp"]}; (* Model[Sample, StockSolution, "70% Ethanol"], Model[Sample, "Milli-Q water"], Model[Sample, StockSolution, "10% Bleach"]  *)
  allWashSolutionsNoLink = DeleteDuplicates[Download[Cases[Flatten[{primaryWashSolutions, secondaryWashSolutions, tertiaryWashSolutions, quaternaryWashSolutions, defaultWashSolutions}], ObjectP[]], Object]];
  uniqueWashSolutionObjects = Cases[allWashSolutionsNoLink, ObjectReferenceP[Object[Sample]]];
  uniqueWashSolutionModels = Cases[allWashSolutionsNoLink, ObjectReferenceP[Model[Sample]]];

  (* Get the unique destination media *)
  allDestinationMediaNoLink = DeleteDuplicates[Download[Cases[Flatten[ToList[destinationMedias]], ObjectP[]], Object]];
  uniqueDestinationMediaObjects = Cases[allDestinationMediaNoLink, ObjectReferenceP[Object[Sample]]];
  uniqueDestinationMediaModels = Cases[allDestinationMediaNoLink, ObjectReferenceP[Model[Sample]]];

  (* Get the unique colony picking tools *)
  allColonyPickingToolsNoLink = DeleteDuplicates[Download[Cases[Flatten[ToList[colonyPickingTools]], ObjectP[]], Object]];
  uniqueColonyPickingToolObjects = Cases[allColonyPickingToolsNoLink, ObjectReferenceP[Object[Part]]];
  uniqueColonyPickingToolModels = Cases[allColonyPickingToolsNoLink, ObjectReferenceP[Model[Part]]];

  (* Define the packets we need to extract from the downloaded cache. *)
  sampleObjectDownloadPacket = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence]];
  sampleModelDownloadPacket = Packet[SamplePreparationCacheFields[Model[Sample], Format -> Sequence]];
  sampleContainerObjectDownloadPacket = Packet[Container[SamplePreparationCacheFields[Object[Container], Format -> List]]];
  sampleContainerModelDownloadPacket = Packet[Container[Model[SamplePreparationCacheFields[Model[Container], Format -> List]]]];
  containerDownloadPacket = Packet[Model[SamplePreparationCacheFields[Model[Container], Format -> List]]];
  containerModelDownloadPacket = Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];
  colonyHandlerHeadCassetteObjectDownloadPacket = Packet[Model[{HeadDiameter, HeadLength, NumberOfHeads, Rows, Columns, Application, PreferredCellLines}]];
  colonyHandlerHeadCassetteModelDownloadPacket = Packet[HeadDiameter, HeadLength, NumberOfHeads, Rows, Columns, Application, PreferredCellLines];

  (* Download from cache and simulation *)
  {
    samplePackets,
    washSolutionObjectPackets,
    washSolutionModelPackets,
    destinationMediaObjectPackets,
    destinationMediaModelPackets,
    destinationContainerObjectPackets,
    destinationContainerModelPackets,
    colonyPickingToolObjectPackets,
    colonyPickingToolModelPackets,
    pickingColonyHandlerHeadCassettesPackets
  } = Quiet[
    Download[
      {
        mySamples,
        uniqueWashSolutionObjects,
        uniqueWashSolutionModels,
        uniqueDestinationMediaObjects,
        uniqueDestinationMediaModels,
        uniqueDestinationContainerObjects,
        uniqueDestinationContainerModels,
        uniqueColonyPickingToolObjects,
        uniqueColonyPickingToolModels,
        pickingColonyHandlerHeadCassettes
      },
      {
        {
          sampleObjectDownloadPacket,
          Packet[Composition[[All, 2]][{PreferredLiquidMedia, PreferredSolidMedia, PreferredColonyHandlerHeadCassettes}]],
          sampleContainerObjectDownloadPacket,
          sampleContainerModelDownloadPacket
        },
        {sampleObjectDownloadPacket},
        {sampleModelDownloadPacket},
        {sampleObjectDownloadPacket},
        {sampleModelDownloadPacket},
        {
          containerDownloadPacket,
          Packet[Contents, Model]
        },
        {containerModelDownloadPacket},
        {
          colonyHandlerHeadCassetteObjectDownloadPacket,
          Packet[Model]
        },
        {colonyHandlerHeadCassetteModelDownloadPacket},
        {colonyHandlerHeadCassetteModelDownloadPacket}
      },
      Cache -> cache,
      Simulation -> currentSimulation
    ],
    {
      Download::FieldDoesntExist,
      Download::MissingCacheField
    }
  ];

  (* combine the cache packets *)
  flattenedCachePackets = FlattenCachePackets[
    {
      samplePackets,
      washSolutionObjectPackets,
      washSolutionModelPackets,
      destinationMediaObjectPackets,
      destinationMediaModelPackets,
      destinationContainerObjectPackets,
      destinationContainerModelPackets,
      colonyPickingToolObjectPackets,
      colonyPickingToolModelPackets,
      pickingColonyHandlerHeadCassettesPackets
    }
  ];

  (* Create combined fast assoc *)
  combinedCache = FlattenCachePackets[{flattenedCachePackets, cache}];
  combinedFastAssoc = Experiment`Private`makeFastAssocFromCache[combinedCache];

  (*-- INPUT VALIDATION CHECKS --*)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> combinedCache] <> " are not discarded:", True, False]
      ];

      passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> combinedCache] <> " are not discarded:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];
  
  (* Get the samples from mySamples that do not have Solid state *)
  nonSolidSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[State -> Except[Solid]]];

  (* Set nonSolidInvalidInputs to the input objects whose state is not Solid *)
  nonSolidInvalidInputs = Lookup[nonSolidSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[nonSolidInvalidInputs] >0 && !gatherTests,
    Message[Error::NonSolidSamples, ObjectToString[nonSolidInvalidInputs, Cache -> combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonSolidTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nonSolidInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonSolidInvalidInputs, Cache -> combinedCache] <> " are Solid State:", True, False]
      ];

      passingTest = If[Length[nonSolidInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, nonSolidInvalidInputs], Cache -> combinedCache] <> " are Solid State:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];
  
  (* Make sure all input containers are omnitrays *)
  nonOmniTrayInvalidInputs = Module[{sampleContainerModelPackets, validContainerSampleQ},
    sampleContainerModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, {Container, Model}]& /@ mySamples;
    (* Make sure all input containers are SBS plates and only has 1 well *)
    validContainerSampleQ = validqPixContainer[sampleContainerModelPackets];
    PickList[mySamples, validContainerSampleQ, False]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[nonOmniTrayInvalidInputs] > 0 && !gatherTests,
    Message[Error::NonOmniTrayContainer, ObjectToString[nonOmniTrayInvalidInputs, Cache -> combinedCache, Simulation -> currentSimulation]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonOmniTrayTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nonOmniTrayInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonOmniTrayInvalidInputs, Cache -> combinedCache] <> " in an omnitray:", True, False]
      ];

      passingTest = If[Length[nonOmniTrayInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, nonOmniTrayInvalidInputs], Cache -> combinedCache] <> " in an omnitray:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Check to see if we have more than 4 input containers *)
  (* Get all the input containers *)
  inputContainers = DeleteDuplicates[fastAssocLookup[combinedFastAssoc, mySamples, {Container}]];

  tooManyContainersInvalidInputs = If[Length[inputContainers] > 4, mySamples, {}];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[tooManyContainersInvalidInputs] > 0 && !gatherTests,
    Message[Error::TooManyInputContainers, ObjectToString[mySamples, Cache -> combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  tooManyInputContainersTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[tooManyContainersInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[mySamples, Cache -> combinedCache] <> " have more than 4 unique containers:", True, False]
      ];

      passingTest = If[Length[tooManyContainersInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[mySamples, Cache -> combinedCache] <>" have more than 4 unique containers:", True, True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*--Duplicated Input check--*)
  (* - Check if samples are duplicated (QuantifyColonies does not handle replicates.) - *)
  (* Get the samples that are duplicated. *)
  duplicatedInvalidInputs = Cases[Tally[mySamples], {_, Except[1]}][[All, 1]];

  (* If there are invalid inputs and we are throwing messages, throw an error message .*)
  If[Length[duplicatedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DuplicatedSamples, ObjectToString[duplicatedInvalidInputs, Cache -> combinedCache], "ExperimentPickColonies"]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  duplicatesTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[duplicatedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[duplicatedInvalidInputs, Cache -> combinedCache]<>" are not listed more than once:", True, False]
      ];

      passingTest = If[Length[duplicatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, duplicatedInvalidInputs], Cache -> combinedCache] <> " are not listed more than once:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];


  (*-- OPTION PRECISION CHECKS --*)
  (* First, define the option precisions that need to be checked for PickColonies *)
  optionPrecisions = {
    {ColonyPickingDepth, 10^-2*Millimeter},
    {HeadDiameter, 10^-2*Millimeter},
    {HeadLength, 10^-1*Millimeter},
    {PickCoordinates, 10^-1*Millimeter},
    {DestinationCoordinates, 10^-1*Millimeter},
    {MediaVolume, 10^0*Microliter},
    {ExposureTimes, 10^0*Millisecond},
    {MinDiameter, 10^-2*Millimeter},
    {MaxDiameter, 10^-2*Millimeter},
    {MinColonySeparation, 10^-2*Millimeter},
    {PrimaryDryTime, 10^0*Second},
    {SecondaryDryTime, 10^0*Second},
    {TertiaryDryTime, 10^0*Second},
    {QuaternaryDryTime, 10^0*Second}
  };

  (* Check the precisions of these options. *)
  {roundedPickColoniesOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[pickColoniesOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[pickColoniesOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
  ];


  (*-- RESOLVE INDEPENDENT OPTIONS --*)
  (* Lookup the options we are resolving independently *)
  {
    instrument,
    destinationFillDirection,
    preparation,
    workCell,
    samplesInStorageCondition,
    samplesOutStorageCondition,
    mediaVolumes
  } = Lookup[roundedPickColoniesOptions,
    {
      Instrument,
      DestinationFillDirection,
      Preparation,
      WorkCell,
      SamplesInStorageCondition,
      SamplesOutStorageCondition,
      MediaVolume
    }
  ];

  (* Resolve the Instrument Option *)
  resolvedInstrument = If[MatchQ[instrument, Automatic],
    (* If instrument is Automatic, resolve it to the Qpix *)
    Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"], (* Model[Instrument, ColonyHandler, "QPix 420 HT"] *)
    (* Otherwise, keep it *)
    instrument
  ];

  (* Check that the input samples are compatible with the wetted materials of the resolved instrument *)
  {compatibleMaterialsBools, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[resolvedInstrument, mySamples, OutputFormat -> Boolean, Output -> {Result, Tests}, Cache -> cache, Simulation -> simulation],
    {CompatibleMaterialsQ[resolvedInstrument, mySamples, OutputFormat -> Boolean, Messages -> messages, Cache -> cache, Simulation -> simulation], {}}
  ];

  (* Resolve the DestinationFillDirection - no resolution necessary here. Check for CustomCoordinate mismatch later *)
  resolvedDestinationFillDirection = destinationFillDirection;

  (* Resolve Preparation and WorkCell - currently this function is only robotic on the qpix so no resolution is necessary here *)
  {resolvedPreparation, resolvedWorkCell} = {preparation, workCell};

  (* No resolution necessary for SamplesInStorageCondition *)
  (* NOTE: The default here is Disposal so resolution is handled by the default *)
  resolvedSamplesInStorageCondition = samplesInStorageCondition;

  (* No resolution necessary for SamplesOutStorageCondition *)
  (* If the value is still set to Null, the sample will just be stored the same as its model *)
  (* SamplesOutStorageCondition is nested indexmatching as well. Expand the value if necessary *)
  resolvedSamplesOutStorageCondition = If[ListQ[samplesOutStorageCondition] && ListQ[mediaVolumes] && Length[samplesOutStorageCondition] == Length[mediaVolumes],
    samplesOutStorageCondition,
    (mediaVolumes /. {VolumeP -> samplesOutStorageCondition})
  ];

  (*-- RESOLVE SANITIZATION AND ANALYSIS OPTIONS --*)

  (* Use resolveQPixSanitizationOptions to get the resolved sanitization options *)
  {
    (* Error checking vars *)
    sanitizationOptionInvalidOptions,
    sanitizationOptionTests,
    sanitizationOptionInvalidInputs,
    resolvedSanitizationOptions
  }= Module[{sanitizationOptionSymbols, unresolvedSanitizationOptions},

    (* Define list of options resolved though resolveQPixSanitizationOptions *)
    sanitizationOptionSymbols = {
      PrimaryWash,
      PrimaryWashSolution,
      NumberOfPrimaryWashes,
      PrimaryDryTime,
      SecondaryWash,
      SecondaryWashSolution,
      NumberOfSecondaryWashes,
      SecondaryDryTime,
      TertiaryWash,
      TertiaryWashSolution,
      NumberOfTertiaryWashes,
      TertiaryDryTime,
      QuaternaryWash,
      QuaternaryWashSolution,
      NumberOfQuaternaryWashes,
      QuaternaryDryTime
    };

    (* Separate the sanitization options from roundedPickColoniesOptions *)
    unresolvedSanitizationOptions = KeyTake[roundedPickColoniesOptions, sanitizationOptionSymbols];

    (* Resolve the options *)
    resolveQPixSanitizationOptions[mySamples, Normal@unresolvedSanitizationOptions, resolvedInstrument, Cache -> combinedCache, Output -> output, Simulation -> currentSimulation]

  ];

  (* Merge the resolved sanitization options in with our main list of options *)
  partiallyResolvedPickColoniesOptionsWithSanitization = Merge[{roundedPickColoniesOptions, resolvedSanitizationOptions}, Last];

  (* Use AnalyzeColonies to resolve the analysis options and the PickCoordinates Option *)
  {
    analysisOptionInvalidOptions,
    analysisOptionTests,
    resolvedAnalysisOptions,
    resolvedPickCoordinates
  } = Module[
    {
      analysisOptionSymbols, unresolvedAnalysisOptions, mapThreadFriendlyUnresolvedOptions, pickCoordinatesMissingErrors,
      multiplePopulationMethodErrors, overlappingPopulationErrors, resolvedPickCoordinates, partiallyResolvedPopulations,
      partiallyResolvedAnalysisOptions, pickCoordinatesMissingOptions, pickCoordinatesMissingTests, multiplePopulationMethodOptions,
      multiplePopulationMethodTests, overlappingPopulationsOptions, overlappingPopulationsTests, resolveThroughAnalyzeColoniesBools,
      mapThreadFriendlyPartiallyResolvedOptions, analyzeColonySamples, analyzeColonyOptions, nonAnalyzeColonyOptions, nonAnalyzeColonyPopulationsWithBlobs,
      sanitizedNonAnalyzeColonyOptions, dataAppearanceColoniesPackets, resolvedAnalysisOptions, resolvedAnalysisTests,
      invalidAnalysisOptions, resolvedAnalysisOptionsCleaned, optionsToRemove, fullyCollapsedResolvedAnalysisOptions,
      correctedLengthCollapsedOptions, expandedResolvedAnalysisOptions, falseBooleanPositions, positionValuesMap, threadedOptions
    },

    (* Define list of options resolved though AnalyzeColonies *)
    analysisOptionSymbols = {
      PickCoordinates,
      Populations,
      MinRegularityRatio,
      MaxRegularityRatio,
      MinCircularityRatio,
      MaxCircularityRatio,
      MinDiameter,
      MaxDiameter,
      MinColonySeparation
    };

    (* Lookup the analysis options *)
    unresolvedAnalysisOptions = KeyTake[partiallyResolvedPickColoniesOptionsWithSanitization, analysisOptionSymbols];

    (* -- FIGURE OUT WHICH SAMPLES ARE BEING MANIPULATED -- *)
    (* Get a MapThread friendly version of options. *)
    mapThreadFriendlyUnresolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPickColonies, unresolvedAnalysisOptions, AmbiguousNestedResolution -> IndexMatchingOptionPreferred];

    (* Do a quick mapthread to check for errors and resolve PickCoordinates and partially resolve Populations *)
    {
      pickCoordinatesMissingErrors,
      multiplePopulationMethodErrors,
      overlappingPopulationErrors,
      resolvedPickCoordinates,
      partiallyResolvedPopulations
    } = Transpose@Map[
      Function[{options},
        Module[
          {
            populations, pickCoordinates, multiplePopulationMethodError, pickCoordinatesMissingError, overlappingPopulationError,
            partiallyResolvedPopulations, partiallyResolvedPickCoordinates
          },

          (* Lookup the populations and PickCoordinates options *)
          {populations, pickCoordinates} = Lookup[options, {Populations, PickCoordinates}];

          (* initialize error tracking bools *)
          pickCoordinatesMissingError = False;
          multiplePopulationMethodError = False;
          overlappingPopulationError = False;

          (* Check for a Populations Overlapping *)
          (* Populations is mismatched/duplicated if it is a List of length > 1 and contains nonexclusive population grouping criteria *)
          overlappingPopulationError = If[!MatchQ[populations, {Automatic}],
            !exclusivePopulationsQ[populations],
            False
          ];

          (* Resolve the pick coordinates option *)
          {partiallyResolvedPopulations, partiallyResolvedPickCoordinates} = Switch[{populations, pickCoordinates, !MatchQ[DeleteCases[populations, CustomCoordinates], {}]},

            (* If the options are aligned, leave them *)
            (* PickCoordinates being set and Populations->CustomCoordinates signals to not call AnalyzeColonies *)
            (* PickCoordinates -> Null and Populations -> anything else signals to call AnalyzeColonies *)
            {{CustomCoordinates}, {_List..}, _},
              {populations, pickCoordinates},
            {{Automatic}, {_List..}, _},
              {{CustomCoordinates}, pickCoordinates},
            {{Automatic}, Automatic|Null, _},
              {{Automatic}, Null},
            (* Mark if there is a mismatch *)
            {{CustomCoordinates}, Null|Automatic, _},
              pickCoordinatesMissingError = True;
              {populations, Null},
            {_, {_List..}, True},
              Module[{},
                multiplePopulationMethodError = True;
                {populations, Null}
              ],
            (* Catch all *)
            {_, _, _},
              {populations, Null}
          ];

          (* Return necessary values *)
          {
            pickCoordinatesMissingError,
            multiplePopulationMethodError,
            overlappingPopulationError,
            PickCoordinates -> partiallyResolvedPickCoordinates,
            partiallyResolvedPopulations
          }
        ]
      ],
      mapThreadFriendlyUnresolvedOptions
    ];

    (* Re-insert the partially resolved Populations, and drop PickCoordinates as PickCoordinates is not resolved through AnalyzeColonies *)
    partiallyResolvedAnalysisOptions = KeyDrop[Merge[{unresolvedAnalysisOptions, Populations -> partiallyResolvedPopulations}, Last], PickCoordinates];

    (* Throw the appropriate messages or create the appropriate tests for the possible PickCoordinate errors *)
    pickCoordinatesMissingOptions = If[MemberQ[pickCoordinatesMissingErrors, True] && messages,
      Message[Error::PickCoordinatesMissing, PickList[mySamples, pickCoordinatesMissingErrors]];
      {Populations, PickCoordinates},
      {}
    ];

    pickCoordinatesMissingTests = If[gatherTests,
      (* We are gathering tests, create the appropriate tests *)
      Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
        (* Get the inputs that pass the test *)
        passingInputs = PickList[mySamples, pickCoordinatesMissingErrors,False];

        (* Get the non passing inputs *)
        nonPassingInputs = Complement[mySamples, passingInputs];

        (* Create a test for the passing inputs *)
        passingInputsTest=If[Length[passingInputs] > 0,
          Test["If Populations -> CustomCoordinates, PickCoordinates are also specified for the inputs " <> ObjectToString[passingInputs, Cache -> combinedCache] <> ":", True, True],
          Nothing
        ];

        (* Create a test for the non passing inputs *)
        nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
          Test["If Populations -> CustomCoordinates, PickCoordinates are also specified for the inputs " <> ObjectToString[nonPassingInputs, Cache -> combinedCache] <> ":", True, False],
          Nothing
        ];

        (* Return the created tests *)
        {passingInputsTest, nonPassingInputsTest}
      ],
      Nothing
    ];

    multiplePopulationMethodOptions = If[MemberQ[multiplePopulationMethodErrors ,True] && messages,
      (
        Message[Error::MultiplePopulationMethods, PickList[mySamples, multiplePopulationMethodErrors]];
        {Populations, PickCoordinates}
      ),
      {}
    ];

    multiplePopulationMethodTests = If[gatherTests,
      (* We are gathering tests, create the appropriate tests *)
      Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
        (* Get the inputs that pass the test *)
        passingInputs = PickList[mySamples, multiplePopulationMethodErrors, False];

        (* Get the non passing inputs *)
        nonPassingInputs = Complement[mySamples, passingInputs];

        (* Create a test for the passing inputs *)
        passingInputsTest = If[Length[passingInputs] > 0,
          Test["Either a Population Primitive or CustomCoordinates, not both, are specified for the inputs " <> ObjectToString[passingInputs, Cache -> combinedCache] <> ":", True, True],
          Nothing
        ];

        (* Create a test for the non passing inputs *)
        nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
          Test["Either a Population Primitive or CustomCoordinates, not both, are specified for the inputs " <> ObjectToString[nonPassingInputs, Cache -> combinedCache] <> ":", True, False],
          Nothing
        ];

        (* Return the created tests *)
        {passingInputsTest, nonPassingInputsTest}
      ],
      Nothing
    ];

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
          Test["The inputs" <> ObjectToString[passingInputs, Cache -> combinedCache] <> "have mutually exclusive Populations:", True, True],
          Nothing
        ];

        (* Create a test for the non passing inputs *)
        nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
          Test["The inputs" <> ObjectToString[passingInputs, Cache -> combinedCache] <> "have non mutually exclusive Populations:", True, False],
          Nothing
        ];

        (* Return the created tests *)
        {passingInputsTest, nonPassingInputsTest}
      ],
      Nothing
    ];

    (* Figure out if the options for each sample should be resolved through AnalyzeColonies. *)
    (* A samples options should be resolved through AnalyzeColonies if Populations -> {Automatic} | {PopulationPrimitive|PopulationSymbol..} *)
    resolveThroughAnalyzeColoniesBools = MapThread[
      Function[{populationsOption, overlappingPopulationError},
        Not[
          Or[
            MatchQ[populationsOption, {CustomCoordinates}],
            overlappingPopulationError
          ]
        ]
      ],
      {partiallyResolvedPopulations, overlappingPopulationErrors}
    ];

    (* Get the partially resolved options in a mapThreadFriendly state *)
    mapThreadFriendlyPartiallyResolvedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPickColonies, partiallyResolvedAnalysisOptions, IndexMatchingOptionPreferred -> {Populations}];

    (* Filter out the samples we are not calling AnalyzeColonies on *)
    analyzeColonySamples = PickList[mySamples, resolveThroughAnalyzeColoniesBools];
    
    (* Only use the select option for the samples we are calling AnalyzeColonies on *)
    analyzeColonyOptions = PickList[#, resolveThroughAnalyzeColoniesBools]& /@ partiallyResolvedAnalysisOptions;

    (* Create a temporary Object[Data,Appearance,Colonies] packets for each input sample to pass to AnalyzeColonies *)
    dataAppearanceColoniesPackets = Map[
      Function[{sample},
        Module[{cellModel},
          (* Get the main Model[Cell] in the composition of the sample (if one exists) *)
          cellModel = selectMainCellFromSample[sample, Cache -> combinedCache, Simulation -> currentSimulation];
          (* Return the data packet *)
          (* Note: here we are using the main cell identity model of the sample, should be able to specify/create cell identity model instead *)
          <|Object -> CreateID[Object[Data, Appearance, Colonies]], CellTypes -> Link[cellModel]|>
        ]
      ],
      analyzeColonySamples
    ];

    (*Initialize the invalid-option-tracking variable*)
    invalidAnalysisOptions = {};

    (* -- Resolve the options -- *)
    (* Use AnalyzeColonies to get the resolved analysis options *)
    {
      resolvedAnalysisOptions,
      resolvedAnalysisTests
    } = Which[
      (* If we are not doing any analysis option resolving, skip calling analyze colonies (Automatics go to Null) *)
      MatchQ[Length[dataAppearanceColoniesPackets], 0],
        {
          {},
          {}
        },
      (* If we are gathering tests, call AnalyzeColonies *)
      gatherTests,
        AnalyzeColonies[dataAppearanceColoniesPackets, Sequence@@Normal[analyzeColonyOptions, Association], AnalysisType -> Pick, ImageRequirement -> False, Output -> {Options, Tests}],
      (* If we require messages, call AnalyzeColonies through ModifyFunctionMessages *)
      True,
        {
          Module[{invalidOptionsBool, resolvedPopulationOptions},
  
            (* Run the analysis function to get the resolved options *)
            {resolvedPopulationOptions, invalidOptionsBool, invalidAnalysisOptions} = ModifyFunctionMessages[
              AnalyzeColonies,
              {dataAppearanceColoniesPackets},
              "",
              {},
              {Sequence@@Normal[analyzeColonyOptions], AnalysisType -> Pick, ImageRequirement -> False, Output -> Options},
              ExperimentFunction -> False,
              Output -> {Result, Boolean, InvalidOptions}
            ];
  
            (* Return the options *)
            resolvedPopulationOptions
          ],
          {}
        }
    ];

    (* Remove the options Batch, IncludedColonies, ManualPickTargets, and AnalysisType from the list of returned fields *)
    optionsToRemove = {Batch, IncludedColonies, ManualPickTargets, AnalysisType, Margin};
    resolvedAnalysisOptionsCleaned = resolvedAnalysisOptions/.{Verbatim[Rule][Alternatives@@optionsToRemove, _]:> Nothing, $Aborted -> Normal[analyzeColonyOptions, Association]};

    (* Collapse the resolved analysis options again. The Sci-Comp Framework has no concept of NestedIndexMatching so the Populations option does not get fully collapsed. *)
    fullyCollapsedResolvedAnalysisOptions = Quiet[CollapseIndexMatchedOptions[ExperimentPickColonies, resolvedAnalysisOptionsCleaned], Warning::CannotCollapse];

    (* There are still some cases where Populations does not get collapsed properly (for a single input sample) *)
    (* Use ValidInputLengthsQ to check if the options are of an ok length, if not, we know populations is wrong and can add an extra list around it *)
    (* We also need to add the extra list, if Populations is a flat list that is the same length as mySamples *)
    correctedLengthCollapsedOptions = Which[
      MatchQ[analyzeColonySamples, {}],
        {},
      Or[
        !ValidInputLengthsQ[ExperimentPickColonies, {ToList[analyzeColonySamples]}, fullyCollapsedResolvedAnalysisOptions, Messages -> False],
        And[
          MatchQ[Length[Lookup[fullyCollapsedResolvedAnalysisOptions, Populations]], Length[mySamples]],
          MatchQ[Lookup[fullyCollapsedResolvedAnalysisOptions, Populations], {ReleaseHold[Lookup[FirstCase[OptionDefinition[ExperimentPickColonies], KeyValuePattern["OptionName"->"Populations"]], "SingletonPattern"]]..}]
        ]
      ],
        Module[{resolvedPopulations,resolvedAnalysisOptionsNoPopulations},
          (* Get the populations option *)
          resolvedPopulations = Lookup[fullyCollapsedResolvedAnalysisOptions, Populations];
  
          (* Drop the population option *)
          resolvedAnalysisOptionsNoPopulations = DeleteCases[fullyCollapsedResolvedAnalysisOptions, Populations -> _];
  
          (* Add the corrected populations back in  *)
          Append[resolvedAnalysisOptionsNoPopulations, Populations -> ConstantArray[resolvedPopulations, Length[mySamples]]]
        ],
      True,
        fullyCollapsedResolvedAnalysisOptions
    ];

    (* Re-expand the analysis options so we can thread them back together and continue working with them *)
    expandedResolvedAnalysisOptions = If[MatchQ[correctedLengthCollapsedOptions,{}],
      {},
      Quiet[
        Last[
          ExpandIndexMatchedInputs[
            ExperimentPickColonies,
            {ToList[analyzeColonySamples]},
            correctedLengthCollapsedOptions,
            SingletonClassificationPreferred -> Populations]
        ],
        Warning::UnableToExpandInputs
      ]
    ];

    (* -- Thread the options back to the correct format -- *)
    (* Get the positions of the False booleans in masterSwitchBooleans. *)
    falseBooleanPositions = Position[resolveThroughAnalyzeColoniesBools, False];

    (* Get the options that were not used in AnalyzeColonies *)
    nonAnalyzeColonyOptions = PickList[#, resolveThroughAnalyzeColoniesBools, False]& /@ partiallyResolvedAnalysisOptions;

    (* Make sure that we turn all of the population symbols into blobs *)
    (* Default to 10 so we don't crash later on *)
    nonAnalyzeColonyPopulationsWithBlobs = Map[
      Function[{populationList},
        Map[Function[{populationValue},
          Switch[populationValue,
            Fluorescence, Fluorescence[NumberOfColonies -> 10],
            BlueWhiteScreen, BlueWhiteScreen[NumberOfColonies -> 10],
            Diameter, Diameter[NumberOfColonies -> 10],
            Circularity, Circularity[NumberOfColonies -> 10],
            Regularity, Regularity[NumberOfColonies -> 10],
            Isolation, Isolation[NumberOfColonies -> 10],
            AllColonies, AllColonies[NumberOfColonies -> 10],
            MultiFeatured, MultiFeatured[NumberOfColonies -> 10],
            _, populationValue
          ]
        ],
          populationList
        ]
      ],
      Lookup[nonAnalyzeColonyOptions, Populations, {{}}]
    ];

    (* Add the sanitized populations back in to the non analyzecolony options *)
    sanitizedNonAnalyzeColonyOptions = If[KeyExistsQ[nonAnalyzeColonyOptions, Populations],
      Module[{},
        nonAnalyzeColonyOptions[Populations] = nonAnalyzeColonyPopulationsWithBlobs;
        nonAnalyzeColonyOptions
      ],
      nonAnalyzeColonyOptions
    ];

    (* Link the user specified value with the position it needs to be placed back in. *)
    (* Create a list we will use in the fold below. The list will be structured as follows: *)
    (* {positionToInsert -> <|analysisOption -> originalValueOfAnalysisOption..|>..} *)
    positionValuesMap = MapIndexed[
      Function[{falseBoolOriginalPosition, positionInSeparatedList},
        falseBoolOriginalPosition -> Association@Map[
          First[#] -> Last[#][[positionInSeparatedList]][[1]]&,
          Normal[nonAnalyzeColonyOptions, Association]
        ]
      ],
      falseBooleanPositions
    ];

    (* If a sample is not being resolved, insert a Null for the option. *)
    threadedOptions = If[!MatchQ[expandedResolvedAnalysisOptions, _List] || MatchQ[expandedResolvedAnalysisOptions, {}],
      Normal[sanitizedNonAnalyzeColonyOptions, Association],
      Map[Function[{option},
        Module[{optionSymbol, optionStartingList, optionDefault},

          (* Expand the option into its parts *)
          optionSymbol = First[option];
          optionStartingList = Last[option];

          (* Get the default value for the option *)
          optionDefault = First[Lookup[Cases[OptionDefinition[ExperimentPickColonies], KeyValuePattern["OptionSymbol" -> optionSymbol]], "Default"]];

          (* Insert Nulls where ever samples are not being resolved.  *)
          optionSymbol -> Fold[Function[{currentList, insertRule},

            Module[{positionToInsert, potentialValueToInsert},

              (* The position to insert is the first part of the insertRule *)
              positionToInsert = First[insertRule];

              (* The potential values to insert is the second part of the rule (Association mapping option to value at this index) *)
              potentialValueToInsert = Lookup[Last[insertRule], optionSymbol];

              (* Insert a value into the current list at 'positionToInsert'. *)
              Insert[currentList,
                (* If the value of the current option matches the default: *)
                If[MatchQ[potentialValueToInsert, ReleaseHold[optionDefault]],
                  (* replace it with Null instead *)
                  Null,
                  (* If it is a user specified input, leave it as is *)
                  potentialValueToInsert
                ],
                positionToInsert
              ]
            ]
          ],
            (* Starting list *)
            optionStartingList,

            (* List to fold over *)
            positionValuesMap
          ]
        ]
      ],
        expandedResolvedAnalysisOptions
      ]
    ];

    (* Return the mismatch errors and the resolved analysis options *)
    {
      Join[pickCoordinatesMissingOptions, multiplePopulationMethodOptions, overlappingPopulationsOptions, invalidAnalysisOptions],
      Join[pickCoordinatesMissingTests, multiplePopulationMethodTests, overlappingPopulationsTests, resolvedAnalysisTests],
      threadedOptions,
      resolvedPickCoordinates
    }
  ];

  (* Merge the resolved analysis options and PickCoordinates option back into the main option set *)
  partiallyResolvedPickColoniesOptionsWithAnalysis = Merge[{partiallyResolvedPickColoniesOptionsWithSanitization, resolvedAnalysisOptions, Association @@ resolvedPickCoordinates}, Last];

  (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPickColonies, partiallyResolvedPickColoniesOptionsWithAnalysis, AmbiguousNestedResolution -> IndexMatchingOptionPreferred, SingletonOptionPreferred -> {PickCoordinates, Populations}];

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
    (* Error tracking variables *)
    missingImagingStrategiesInfos,(*1*)
    imagingOptionSameLengthErrors,(*3*)
    pickCoordinatesMismatchErrors,(*4*)
    destinationMediaStateErrors,(*5*)
    destinationMediaTypeMismatchErrors,(*6*)
    invalidDestinationMediaContainerErrors,(*7*)
    tooManyDestinationMediaContainersErrors,(*8*)
    tooManyPickCoordinatesErrors,(*9*)
    destinationFillDirectionMismatchErrors,(*10*)
    missingDestinationCoordinatesErrors,(*11*)
    tooManyDestinationCoordinatesWarnings,(*12*)
    destinationMixMismatchErrors,(*13*)
    invalidMixOptionErrors,(*14*)
    pickingToolIncompatibleWithDestinationMediaContainerErrors,(*15*)
    noAvailablePickingToolErrors,(*16*)
    notPreferredColonyHandlerHeadWarnings,(*17*)
    headDiameterMismatchErrors,(*18*)
    headLengthMismatchErrors,(*19*)
    numberOfHeadsMismatchErrors,(*20*)
    colonyHandlerHeadCassetteApplicationMismatchErrors,(*21*)
    invalidColonyPickingDepthErrors,(*22*)
    (* Imaging *)
    resolvedImagingChannels,(*23*)
    resolvedImagingStrategies,(*24*)
    resolvedExposureTimes,(*25*)
    (* Picking *)
    resolvedColonyPickingTools,(*26*)
    resolvedHeadDiameters,(*27*)
    resolvedHeadLengths,(*28*)
    resolvedNumberOfHeads,(*29*)
    resolvedColonyHandlerHeadCassetteApplications,(*30*)
    resolvedColonyPickingDepths,(*31*)
    (* Destination *)
    resolvedDestinationMediaTypes,(*32*)
    resolvedDestinationMedia,(*33*)
    resolvedDestinationMediaContainers,(*34*)
    resolvedMaxDestinationNumberOfColumns,(*35*)
    resolvedMaxDestinationNumberOfRows,(*36*)
    resolvedDestinationCoordinates,(*37*)
    resolvedMediaVolumes,(*38*)
    resolvedDestinationMixes,(*39*)
    resolvedDestinationNumberOfMixes,(*40*)
    resolvedSamplesOutStorageCondition(*41*)
  } = Transpose@MapThread[
    Function[{mySample, myMapThreadOptions},
      Module[
        {
          (* -- ERROR TRACKING VARIABLES -- *)
          imagingOptionSameLengthError, missingImagingStrategyInfo, pickCoordinatesMismatchError, destinationMediaStateError,
          destinationMediaTypeMismatchError, invalidDestinationMediaContainerError, tooManyDestinationMediaContainersError,
          tooManyPickCoordinatesError, mediaVolumeMismatchError, destinationFillDirectionMismatchError, missingDestinationCoordinatesError,
          tooManyDestinationCoordinatesWarning, destinationMixMismatchError, invalidMixOptionError,
          pickingToolIncompatibleWithDestinationMediaContainerError, noAvailablePickingToolError, notPreferredColonyHandlerHeadWarning,
          headDiameterMismatchError, headLengthMismatchError, numberOfHeadsMismatchError, colonyHandlerHeadCassetteApplicationMismatchError,
          invalidColonyPickingDepthError,
          (* -- UNRESOLVED OPTIONS -- *)
          (* Analysis *)
          resolvedPopulations,
          (* Imaging *)
          specifiedImagingStrategies, specifiedExposureTimes,
          (* Picking *)
          specifiedColonyPickingTool, specifiedHeadDiameter, specifiedHeadLength, specifiedNumberOfHeads,
          specifiedColonyHandlerHeadCassetteApplication, specifiedColonyPickingDepth, resolvedPickCoordinates,
          (* Destination *)
          specifiedDestinationMediaType, specifiedDestinationMedia, specifiedDestinationMediaContainer,
          specifiedMaxDestinationNumberOfColumns, specifiedMaxDestinationNumberOfRows, specifiedDestinationCoordinates,
          specifiedMediaVolume, specifiedDestinationMix, specifiedDestinationNumberOfMixes, samplesOutStorageConditionsPossiblyCollapsed,
          (* -- RESOLVED OPTIONS -- *)
          (* Imaging *)
          updatedImagingChannels, updatedImagingStrategies, updatedExposureTimes,
          (* Picking *)
          updatedColonyPickingTool, updatedHeadDiameter, updatedHeadLength, updatedNumberOfHeads,
          updatedColonyHandlerHeadCassetteApplication, updatedColonyPickingDepth,
          (* Destination *)
          updatedDestinationMediaType, updatedDestinationMedia, updatedDestinationMediaContainer, totalNumberUniqueDestinationMediaContainers,
          updatedMaxDestinationNumberOfColumns, updatedMaxDestinationNumberOfRows, updatedDestinationCoordinates,
          updatedMediaVolume, updatedDestinationMix, updatedDestinationNumberOfMixes, updatedSamplesOutStorageCondition
        },
  
        (* Setup our error tracking variables *)
        {
          pickCoordinatesMismatchError,
          destinationMediaStateError,
          destinationMediaTypeMismatchError,
          invalidDestinationMediaContainerError,
          tooManyDestinationMediaContainersError,
          tooManyPickCoordinatesError,
          mediaVolumeMismatchError,
          destinationFillDirectionMismatchError,
          missingDestinationCoordinatesError,
          tooManyDestinationCoordinatesWarning,
          destinationMixMismatchError,
          invalidMixOptionError,
          pickingToolIncompatibleWithDestinationMediaContainerError,
          noAvailablePickingToolError,
          notPreferredColonyHandlerHeadWarning,
          headDiameterMismatchError,
          headLengthMismatchError,
          numberOfHeadsMismatchError,
          colonyHandlerHeadCassetteApplicationMismatchError,
          invalidColonyPickingDepthError
        } = ConstantArray[False, 20];
  
        (* Look up the option values *)
        {
          (* Analysis *)
          resolvedPopulations,
          (* Imaging *)
          specifiedImagingStrategies,
          specifiedExposureTimes,
          (* Picking *)
          specifiedColonyPickingTool,
          specifiedHeadDiameter,
          specifiedHeadLength,
          specifiedNumberOfHeads,
          specifiedColonyHandlerHeadCassetteApplication,
          specifiedColonyPickingDepth,
          resolvedPickCoordinates,
          (* Destination *)
          specifiedDestinationMediaType,
          specifiedDestinationMedia,
          specifiedDestinationMediaContainer,
          specifiedMaxDestinationNumberOfColumns,
          specifiedMaxDestinationNumberOfRows,
          specifiedDestinationCoordinates,
          specifiedMediaVolume,
          specifiedDestinationMix,
          specifiedDestinationNumberOfMixes,
          samplesOutStorageConditionsPossiblyCollapsed
        } = Lookup[
          myMapThreadOptions,
          {
            (* Analysis *)
            Populations,
            (* Imaging *)
            ImagingStrategies,
            ExposureTimes,
            (* Picking *)
            ColonyPickingTool,
            HeadDiameter,
            HeadLength,
            NumberOfHeads,
            ColonyHandlerHeadCassetteApplication,
            ColonyPickingDepth,
            PickCoordinates,
            (* Destination *)
            DestinationMediaType,
            DestinationMedia,
            DestinationMediaContainer,
            MaxDestinationNumberOfColumns,
            MaxDestinationNumberOfRows,
            DestinationCoordinates,
            MediaVolume,
            DestinationMix,
            DestinationNumberOfMixes,
            SamplesOutStorageCondition
          }
        ];
  
  
        (* -- Resolve Imaging options -- *)

        (* Resolve imaging options *)
        updatedImagingStrategies = If[!MatchQ[specifiedImagingStrategies, Automatic],
          (* Is ImagingStrategies specified by the user? *)
          specifiedImagingStrategies,
          (* Otherwise, resolve all the required strategies from Populations *)
          (* Note: when ImagingStrategies is not specified, we prefer singleton form *)
          Module[{resolvedStrategiesFromPopulations},
            resolvedStrategiesFromPopulations = imagingStrategiesFromPopulations[ToList@resolvedPopulations];
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
          Complement[imagingStrategiesFromPopulations[ToList@resolvedPopulations], ToList@updatedImagingStrategies],
          {}
        ];

        (* -- Resolve Destination Options -- *)
  
        (* Resolve DestinationMediaType *)
        updatedDestinationMediaType = MapThread[
          Function[{destinationMediaType, destinationMedia},
            Module[{destinationMediaState, destMediaTypeLookup},
              
              (* Get information about the destination media state *)
              (* Get the state of DestinationMedia if it is specified *)
              destinationMediaState = If[!MatchQ[destinationMedia, Automatic],
                fastAssocLookup[combinedFastAssoc, destinationMedia, State],
                Null
              ];
    
              (* Check that the state of the DestinationMedia is either Liquid or Solid if it is specified *)
              If[!MatchQ[destinationMediaState, Liquid|Solid|Null],
                destinationMediaStateError = True
              ];
    
              (* Create Lookup from State -> DestinationMediaType *)
              destMediaTypeLookup = {Liquid -> LiquidMedia, Solid -> SolidMedia};
              
              (* Use the state information to help resolve if necessary *)
              If[MatchQ[destinationMediaType, Automatic],
                (* Resolution of Automatic *)
                Which[
                  (* If the DestinationMedia is specified and has a valid state -> use it*)
                  !NullQ[destinationMediaState] && !destinationMediaStateError,
                    destinationMediaState /. destMediaTypeLookup,
                  (* If the DestinationMedia is specified and does not have a valid state -> Default to LiquidMedia so further resolution does not error *)
                  !NullQ[destinationMediaState] && destinationMediaStateError,
                    LiquidMedia,
                  (* If the DestinationMedia is not specified, use the PreferredLiquidMedia of the first Model[Cell] in the composition of the input sample *)
                  (* if it exists. Otherwise use the PreferredSolidMedia. If neither PreferredLiquidMedia, or PreferredSolidMedia exist, default to LiquidMedia *)
                  (* TODO: This needs to take into account the DestiantionMediaContainer -> Same with DestiantionMedia resolution*)
                  NullQ[destinationMediaState],
                    Module[
                      {cellModel, preferredLiquidMedia, preferredSolidMedia},
    
                      (* Get the first Model[Cell] from the composition *)
                      cellModel = FirstOrDefault@selectMainCellFromSample[mySample, Cache -> combinedCache, Simulation -> currentSimulation];
    
                      (* Lookup the PreferredMedias from the cellModel if they exist *)
                      preferredLiquidMedia = fastAssocLookup[combinedFastAssoc, cellModel, PreferredLiquidMedia];
                      preferredSolidMedia = fastAssocLookup[combinedFastAssoc, cellModel, PreferredSolidMedia];
    
                      (* Resolve accordingly *)
                      Switch[{preferredLiquidMedia, preferredSolidMedia},
                        {ObjectP[], _}, LiquidMedia,
                        {Null, ObjectP[]}, SolidMedia,
                        {_, _}, LiquidMedia
                      ]
                    ]
                ],
    
                (* Resolution if destinationMediaType is not Automatic *)
                (* If the specified DestinationMediaType does not agree with the state of the DestinationMedia, mark an error *)
                If[!NullQ[destinationMediaState] && !destinationMediaStateError && !MatchQ[(destinationMediaState /. destMediaTypeLookup), destinationMediaType],
                  destinationMediaTypeMismatchError = True;
                  destinationMediaType,
                  (* Otherwise all options are happy *)
                  destinationMediaType
                ]
              ]
            ]
          ],
          {specifiedDestinationMediaType, specifiedDestinationMedia}
        ];
  
        (* Resolve DestinationMedia *)
        updatedDestinationMedia = MapThread[
          Function[{destinationMedia, destMediaType},
            If[MatchQ[destinationMedia, Automatic],
              (* If the option is Automatic, get the PreferredBLAHMedia from the first Model[Cell] in the composition of the sample if it exists *)
              Module[{cellModel, preferredMedia},
                (* Get the first Model[Cell] from the composition *)
                cellModel = FirstOrDefault@selectMainCellFromSample[mySample, Cache -> combinedCache, Simulation -> currentSimulation];
    
                (* Extract the preferred Media from the Model[Cell] *)
                preferredMedia = If[MatchQ[destMediaType, LiquidMedia],
                  Download[fastAssocLookup[combinedFastAssoc, cellModel, PreferredLiquidMedia], Object],
                  Download[fastAssocLookup[combinedFastAssoc, cellModel, PreferredSolidMedia], Object]
                ];
    
                (* If preferredMedia is Null, default to either LB Broth or LB Agar *)
                If[NullQ[preferredMedia],
                  If[MatchQ[destMediaType, LiquidMedia],
                    Model[Sample, Media, "id:XnlV5jlXbNx8"], (* Model[Sample, Media, "LB Broth, Miller"] *)
                    Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *)
                  ],
                  (* If the media was already found, use it *)
                  preferredMedia
                ]
              ],
              (* If the option is not automatic, keep it *)
              destinationMedia
            ]
          ],
          {specifiedDestinationMedia, updatedDestinationMediaType}
        ];
  
        (* Resolve DestinationMediaContainer *)
        (* If there are no PickCoordinates specified, resolve for each PopulationPrimitive in Populations *)
        updatedDestinationMediaContainer = MapThread[
          Function[{destinationMediaContainer, individualResolvedDestinationMediaType},
            If[MatchQ[destinationMediaContainer, Automatic],
              (* If the option is Automatic, set based on the DestinationMediaType and the ColonyPickingTool and HeadLength *)
              Module[{colonyPickingToolModel, colonyPickingToolDeepWellQ},
    
                (* Get the model of the specified colony picking tool (if it exists) *)
                colonyPickingToolModel = Which[
                  MatchQ[specifiedColonyPickingTool, ObjectP[Model[Part, ColonyHandlerHeadCassette]]],
                    specifiedColonyPickingTool,
                  MatchQ[specifiedColonyPickingTool, ObjectP[Object[Part, ColonyHandlerHeadCassette]]],
                    fastAssocLookup[combinedFastAssoc, specifiedColonyPickingTool, Model],
                  True,
                    Automatic
                ];
    
                colonyPickingToolDeepWellQ = EqualQ[fastAssocLookup[combinedFastAssoc, colonyPickingToolModel, HeadLength], 19.4 Millimeter];
    
                Which[
    
                  (* Resolve to an omni tray if destinationMediaType is SolidMedia *)
                  MatchQ[individualResolvedDestinationMediaType, SolidMedia],
                    Model[Container, Plate, "id:O81aEBZjRXvx"], (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
    
                  (* If we did not go into the case above we know destinationMediaType is LiquidMedia *)
                  (* If a colony picking tool was specified, use its depth to determine the type of plate to use *)
                  !MatchQ[colonyPickingToolModel, Automatic] && colonyPickingToolDeepWellQ,
                    Model[Container, Plate, "id:n0k9mGkwbvG4"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
    
                  (* If the colony picking tool is not deep well *)
                  !MatchQ[colonyPickingToolModel, Automatic] && !colonyPickingToolDeepWellQ,
                    Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
    
                  (* If head length specifies deep well *)
                  GreaterEqualQ[specifiedHeadLength, 19.4 Millimeter],
                    Model[Container, Plate, "id:n0k9mGkwbvG4"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
    
                  (* If head length specified at all *)
                  MatchQ[QuantityMagnitude[specifiedHeadLength], _Real],
                    Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
    
                  (* Catchall - default to deep well plate *)
                  True,
                    Model[Container, Plate, "id:n0k9mGkwbvG4"] (* Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"] *)
                ]
              ],
    
              (* Otherwise keep it *)
              destinationMediaContainer
            ]
          ],
          {specifiedDestinationMediaContainer, updatedDestinationMediaType}
        ];
  
        (* Check if the DestinationMediaContainer is invalid *)
        (* The plate is invalid if it does not have 1, 24, or 96 wells, or if it is a 24 well deep well plate *)
        Map[
          Function[{destMediaContainer},
            Module[{},
    
              (* Define a helper function to determine if a container is a valid destination media container *)
              invalidDestMediaContainerQ[container_, combinedAssoc_] := Module[
                {destContainerModel, destContainerNumberOfWells, destContainerWellDepthQ},
    
                (* Get the destination container model *)
                destContainerModel = Switch[container,
                  (* If container is an object look up the model *)
                  ObjectP[Object[Container, Plate]],
                    fastAssocLookup[combinedAssoc, container, Model],
                  (* Otherwise container is already a model *)
                  ObjectP[Model[Container, Plate]],
                    container,
                  (* In this case, the container is not a Plate, which means it is invalid *)
                  _,
                    Null
                ];

                (* If destContainerModel is Null, the container is not valid so return True *)
                If[NullQ[destContainerModel],
                  Return[True]
                ];

                (* Get the number of wells and whether the plate is deep well *)
                destContainerNumberOfWells = fastAssocLookup[combinedAssoc, destContainerModel, NumberOfWells];
                destContainerWellDepthQ = GreaterEqualQ[fastAssocLookup[combinedAssoc, destContainerModel, WellDepth], 37 Millimeter];
    
                (* Check if invalid *)
                Or[
                  !MatchQ[destContainerNumberOfWells, 1|24|96],
                  MatchQ[destContainerNumberOfWells, 1|24] && destContainerWellDepthQ
                ]
    
              ];
    
              (* If we are given a single object or a single model, see if it is valid. If we are given a list of objects *)
              (* map over the list to make sure they are all valid *)
              If[MatchQ[destMediaContainer, {ObjectP[Object[Container, Plate]]..}],
    
                invalidDestinationMediaContainerError = Or @@ (invalidDestMediaContainerQ[#, combinedFastAssoc]&/@destMediaContainer),

                invalidDestinationMediaContainerError = invalidDestMediaContainerQ[destMediaContainer, combinedFastAssoc]
              ]
            ]
          ],
          updatedDestinationMediaContainer
        ];
  
        (* Get the total number of unique destination media containers *)
        totalNumberUniqueDestinationMediaContainers = Module[
          {flattenedContainers, uniqueObjectContainers, uniqueModelContainers},
  
          (* Flatten the containers list *)
          flattenedContainers = Flatten@updatedDestinationMediaContainer;
  
          (* Get the objects that are specified as Object[Container]'s *)
          uniqueObjectContainers = DeleteDuplicates[Cases[flattenedContainers, ObjectP[Object[Container]]]];
  
          (* Get the objects that are specified as Model[Container]'s *)
          uniqueModelContainers = Cases[flattenedContainers, ObjectP[Model[Container]]];
  
          Length[uniqueObjectContainers] + Length[uniqueModelContainers]
  
        ];
        
        (* Check to see if there are more than 6 unique destination containers for this sample *)
        If[totalNumberUniqueDestinationMediaContainers > 6,
          tooManyDestinationMediaContainersError = True
        ];
        
  
        (* If PickCoordinates are set, check to see if there are more PickCoordinates than spots in the destination containers *)
        tooManyPickCoordinatesError = If[!MatchQ[resolvedPickCoordinates, Null],
          Module[
            {
              markedPositionsToExpand, numContAvailableToExpand, markedListPositionLookup,
              numContainersToAdd, expandedDestinationContainers, possibleDepositLocationsPerContainer
            },
  
            (* Expand the destination containers up to 6 if we do not exceed that already *)
            (* The expansion happens by continuously looping over the container list. If there is a model, add one of that model *)
            (* If there is an object/list of objects, leave them as they are *)
  
            (* Mark the positions that are able to be expanded *)
            markedPositionsToExpand = ({#, MatchQ[#, ObjectP[Model[Container]]]}& /@ ToList[updatedDestinationMediaContainer]);
  
            (* Calculate the number of containers we can expand *)
            numContAvailableToExpand = Length[Cases[markedPositionsToExpand, {_, True}]];
  
            (* Create a lookup from Object->position in the marked list (this ignores all Objects/Lists of objects) *)
            markedListPositionLookup = MapThread[
              Function[{markedPosition, position},
                First[markedPosition] -> position
              ],
              {Cases[markedPositionsToExpand, {_, True}], Range[numContAvailableToExpand]}
            ];
  
            (* Get the number of containers we can add (number of open positions on deck) *)
            numContainersToAdd = Max[6-totalNumberUniqueDestinationMediaContainers, 0];
  
            (* Do the transformation *)
            expandedDestinationContainers = Map[
              Function[{container},
                Module[{posInMarkedList},
    
                  (* Lookup the position in the marked list. Default to Null for Object[Container,Plate]/{Object[Container,Plate]..} *)
                  posInMarkedList = Lookup[markedListPositionLookup, container, Null];
    
                  (* Use the position, number of containers to add, and number of open spots to calculate how many containers to add at this position *)
                  Which[
                    (* If the container is an object or list of objects, skip it *)
                    MatchQ[posInMarkedList, ListableP[Null]],
                      container,
                    (* If the position==1, add the ceiling of containersToAdd/numberOfOpenSpots *)
                    MatchQ[posInMarkedList, 1],
                      ConstantArray[container, Ceiling[numContainersToAdd/numContAvailableToExpand]+1],
                    (* If the position > numContainersToAdd we will not add any containers here *)
                    GreaterQ[posInMarkedList, numContainersToAdd],
                      container,
                    (* If the position == numContainersToAdd, one container will be added *)
                    MatchQ[posInMarkedList, numContainersToAdd],
                      ConstantArray[container, 2],
                    (* Otherwise we will add the floor of containersToAdd/numberOfOpenSpots *)
                    True,
                      ConstantArray[container, Floor[numContainersToAdd/numContAvailableToExpand]+1]
                  ]
                ]
              ],
              ToList[updatedDestinationMediaContainer]
            ];
  
            (* Get the possible deposit locations *)
            possibleDepositLocationsPerContainer = Flatten@Map[
              Function[{container},
                Module[{destContainerModel, destContainerNumberOfWells},
    
                  (* Get the destination container Model *)
                  destContainerModel = Switch[#,
                    (* If container is an object look up the model *)
                    ObjectP[Object[Container]], fastAssocLookup[combinedFastAssoc, #, Model],
                    (* If container is {Number,Model} get the second element *)
                    _List, Last[#],
                    (* Otherwise container is already a model *)
                    _, #
                  ];
    
                  (* Get the number of wells in the container *)
                  destContainerNumberOfWells = If[MatchQ[fastAssocLookup[combinedFastAssoc, destContainerModel, NumberOfWells], $Failed],
                    (* Model[Container, Vessel] does not have field NumberOfWells *)
                    1,
                    fastAssocLookup[combinedFastAssoc, destContainerModel, NumberOfWells]
                  ];

                  (* An omnitray has 384 spots *)
                  If[MatchQ[destContainerNumberOfWells, 1],
                    384,
                    destContainerNumberOfWells
                  ]
                ]& /@ ToList[container]
              ],
              expandedDestinationContainers
            ];
            (* Do the check *)
            GreaterQ[Length[resolvedPickCoordinates], Total[possibleDepositLocationsPerContainer]]
          ],
          (* Do nothing if pick coordinates are not set *)
          False
        ];
  
        (* Resolve the MediaVolume *)
        updatedMediaVolume = MapThread[
          Function[{mediaVolume, individualResolvedDestinationMediaContainer, individualResolvedDestinationMediaType},
            If[MatchQ[mediaVolume, Automatic],
              (* If the option is Automatic, resolve based on the DestinationMediaType *)
              If[MatchQ[individualResolvedDestinationMediaType, LiquidMedia],
                (* If the option is liquid media, lookup the recommendedFillVolume and MaxVolume of the DestinationMediaContainer *)
                Module[{destContainerModel, recommendedFillVolume, maxVolume},
    
                  (* Get the destination container model *)
                  destContainerModel = If[MatchQ[individualResolvedDestinationMediaContainer, ListableP[ObjectP[Object[Container]]]],
                    (* If container is an object look up the model *)
                    fastAssocLookup[combinedFastAssoc, individualResolvedDestinationMediaContainer, Model],
                    (* Otherwise container is already a model *)
                    individualResolvedDestinationMediaContainer
                  ];
    
                  (* Lookup the necessary values *)
                  recommendedFillVolume = If[MatchQ[fastAssocLookup[combinedFastAssoc, destContainerModel, RecommendedFillVolume], VolumeP],
                    Min[fastAssocLookup[combinedFastAssoc, destContainerModel, RecommendedFillVolume]],
                    Null
                  ];
                  maxVolume = Min[fastAssocLookup[combinedFastAssoc, destContainerModel, MaxVolume]];
    
                  (* Use the recommended fill volume if it exists and is less than the max we can do with one transfer, or the max transfer volume, or otherwise use 40% of the max volume *)
                  If[!NullQ[recommendedFillVolume],
                    Min[recommendedFillVolume, $MaxRoboticSingleTransferVolume],
                    Min[maxVolume * 0.4, $MaxRoboticSingleTransferVolume]
                  ]
    
                ],
                (* If DestinationMediaType is not LiquidMedia, return Null *)
                Null
              ],
            (* If the option is not automatic, mark an error if DestinationMediaType is SolidMedia *)
            If[MatchQ[individualResolvedDestinationMediaType, SolidMedia],
              mediaVolumeMismatchError = True
            ];
  
            (* return the option as is *)
            mediaVolume
          ]
        ],
          {specifiedMediaVolume, updatedDestinationMediaContainer, updatedDestinationMediaType}
        ];
  
        (* Resolve the maxDestinationNumberOfRows and maxDestinationNumberOfColumns *)
        updatedMaxDestinationNumberOfRows = Map[
          Function[{maxDestinationNumberOfRows},
            If[MatchQ[maxDestinationNumberOfRows, Automatic],
              (* If the option is automatic, set to Null if destination fill direction is custom coordinates *)
              If[MatchQ[resolvedDestinationFillDirection, CustomCoordinates],
                Null,
                (* Otherwise leave as is (this is a long automatic as we don't know how many colonies we are picking yet) *)
                maxDestinationNumberOfRows
              ],
    
              (* If the option is not automatic (or Null), mark an error if destination fill direction is custom coordinates *)
              If[MatchQ[resolvedDestinationFillDirection, CustomCoordinates] && !NullQ[maxDestinationNumberOfRows],
                destinationFillDirectionMismatchError = True
              ];
    
              (* Return the option as is *)
              maxDestinationNumberOfRows
            ]
          ],
          specifiedMaxDestinationNumberOfRows
        ];
  
        (* Resolve the maxDestinationNumberOfColumns and maxDestinationNumberOfColumns *)
        updatedMaxDestinationNumberOfColumns = Map[
          Function[{maxDestinationNumberOfColumns},
            If[MatchQ[maxDestinationNumberOfColumns, Automatic],
              (* If the option is automatic, set to Null if destination fill direction is custom coordinates *)
              If[MatchQ[resolvedDestinationFillDirection, CustomCoordinates],
                Null,
                (* Otherwise leave as is (this is a long automatic as we don't know how many colonies we are picking yet) *)
                maxDestinationNumberOfColumns
              ],
    
              (* If the option is not automatic (or Null), mark an error if destination fill direction is custom coordinates *)
              If[MatchQ[resolvedDestinationFillDirection, CustomCoordinates] && !NullQ[maxDestinationNumberOfColumns],
                destinationFillDirectionMismatchError = True
              ];
    
              (* Return the option as is *)
              maxDestinationNumberOfColumns
            ]
          ],
          specifiedMaxDestinationNumberOfColumns
        ];
  
        (* Resolve DestinationCoordinates *)
        updatedDestinationCoordinates = Map[
          Function[{destinationCoordinates},
            If[MatchQ[destinationCoordinates, Null],
              (* Check for missing destination coordinates *)
              If[MatchQ[resolvedDestinationFillDirection, CustomCoordinates],
                missingDestinationCoordinatesError = True
              ];
    
              (* Return destinationCoordinates *)
              destinationCoordinates,
    
              (* If there are coordinates, check their length, but keep them *)
              If[Length[destinationCoordinates] > 384,
                tooManyDestinationCoordinatesWarning = True
              ];
              destinationCoordinates
            ]
          ],
          specifiedDestinationCoordinates
        ];
  
        (* Resolve DestinationMix *)
        updatedDestinationMix = MapThread[
          Function[{destinationMix, individualDestinationMediaType, destinationNumberOfMixes},
            If[MatchQ[destinationMix, Automatic],
              (* If the option is Automatic, set to True if DestinationMediaType is LiquidMedia or if DestinationNumberOfMixes is set *)
              If[MatchQ[individualDestinationMediaType, LiquidMedia] || IntegerQ[destinationNumberOfMixes],
                True,
                False
              ],
    
              (* Otherwise return the option as is *)
              destinationMix
            ]
          ],
          {specifiedDestinationMix, updatedDestinationMediaType, specifiedDestinationNumberOfMixes}
        ];
  
        updatedDestinationNumberOfMixes = MapThread[
          Function[{destinationNumberOfMixes, individualResolvedDestinationMix},
            If[MatchQ[destinationNumberOfMixes, Automatic],
              (* If the option is Automatic, set to 5 if destination mixing is turned on, otherwise resolve to Null *)
              If[TrueQ[individualResolvedDestinationMix],
                5,
                Null
              ],
    
              (* Otherwise keep the option as is *)
              destinationNumberOfMixes
            ]
          ],
          {specifiedDestinationNumberOfMixes, updatedDestinationMix}
        ];
  
        (* Check for mix option mismatch *)
        (* This occurs if one mix option is Null and the other is not, or if DestinationMix -> False but Number of mixes is still set *)
        MapThread[
          If[Or[
            NullQ[#1] && !NullQ[#2],
            NullQ[#2] && TrueQ[#1],
            MatchQ[#1,False] && IntegerQ[#2]
            ],
            destinationMixMismatchError = True
          ]&,
          {updatedDestinationMix, updatedDestinationNumberOfMixes}
        ];
  
        (* Check to see if Mixing can be turned on at all *)
        MapThread[
          Module[{mixOptionSetQ},
            mixOptionSetQ = TrueQ[#1] || IntegerQ[#2];
  
            If[mixOptionSetQ && MatchQ[#3, SolidMedia],
              invalidMixOptionError = True
            ]
          ]&,
          {updatedDestinationMix, updatedDestinationNumberOfMixes, updatedDestinationMediaType}
        ];
  
        (* -- Picking -- *)
        (* First resolve the ColonyPickingTool *)
        updatedColonyPickingTool = If[!MatchQ[specifiedColonyPickingTool, Automatic],
  
          (* If the tool is not Automatic, check if it is compatible with the DestinationMediaContainer *)
          Module[
            {
              destPlateModel, colonyPickingToolModel, destContainerNumberOfWells, destContainerDeepWellQ,
              colonyPickingToolNumberOfHeads, colonyPickingToolDeepWellQ, colonyPickingToolApplication
            },
  
            Map[
              Function[{destContainer},
              (* The tool can be invalid if: *)
              (* Deep well tool and not deep well plate (and vice versa) *)
              (* 24 pin tool in 96 well plate (and vice versa) *)
              (* *96 pins are ok on 1 well plates *)
              (* Its application is not picking *)
  
                (* Get the dest plate model *)
                destPlateModel = Switch[destContainer,
                  (* If container is an object look up the model *)
                  ObjectP[Object[Container]],
                    fastAssocLookup[combinedFastAssoc, destContainer, Model],
                  (* Otherwise container is already a model *)
                  _,
                    destContainer
                ];
    
                (* Get the colony picking tool model *)
                colonyPickingToolModel = Switch[specifiedColonyPickingTool,
                  (* If an Object, look up the Model *)
                  ObjectP[Object[Part, ColonyHandlerHeadCassette]],
                    Download[fastAssocLookup[combinedFastAssoc, specifiedColonyPickingTool, Model], Object],
                  (* Otherwise already a Model *)
                  _,
                    specifiedColonyPickingTool
    
                ];
    
                (* Extract the necessary information *)
                destContainerNumberOfWells = fastAssocLookup[combinedFastAssoc, destPlateModel, NumberOfWells]/.$Failed->1;
                destContainerDeepWellQ = GreaterEqualQ[fastAssocLookup[combinedFastAssoc, destPlateModel, WellDepth], 37 Millimeter];
    
                colonyPickingToolNumberOfHeads = fastAssocLookup[combinedFastAssoc, colonyPickingToolModel, NumberOfHeads];
                colonyPickingToolDeepWellQ = EqualQ[fastAssocLookup[combinedFastAssoc, colonyPickingToolModel, HeadLength], 19.4 Millimeter];
                colonyPickingToolApplication = fastAssocLookup[combinedFastAssoc, colonyPickingToolModel, Application];
    
                (* Check if they are compatible *)
                If[
                  Or[
                    !Or[
                      MatchQ[destContainerNumberOfWells, colonyPickingToolNumberOfHeads],
                      And[MatchQ[destContainerNumberOfWells, 1], MatchQ[colonyPickingToolNumberOfHeads, 96]]
                    ],
                    !MatchQ[destContainerDeepWellQ, colonyPickingToolDeepWellQ],
                    !MatchQ[colonyPickingToolApplication, Pick]
                  ],
                  pickingToolIncompatibleWithDestinationMediaContainerError = True
                ]
              ],
              Flatten@updatedDestinationMediaContainer
            ];
  
            specifiedColonyPickingTool
  
          ],
  
          (* Otherwise, use the specified parameters to choose the tool *)
          Module[
            {
              headDiameterPattern, headLengthPattern, numberOfHeadsPattern, colonyHandlerHeadCassetteApplicationPattern,
              filterPattern, filteredPartPackets
            },
  
            (* Create a pattern to filter our parts based on the given options *)
            (* Create a pattern for HeadDiameter *)
            headDiameterPattern = If[MatchQ[specifiedHeadDiameter, Except[Automatic]],
              KeyValuePattern[{
                HeadDiameter -> RangeP[specifiedHeadDiameter]
              }],
              _
            ];
  
            (* Create a pattern for HeadLength *)
            headLengthPattern = If[MatchQ[specifiedHeadLength, Except[Automatic]],
              KeyValuePattern[{
                HeadLength -> RangeP[specifiedHeadLength]
              }],
              _
            ];
  
            (* Create a pattern for NumberOfHeads *)
            numberOfHeadsPattern = If[IntegerQ[specifiedNumberOfHeads],
              KeyValuePattern[{
                NumberOfHeads -> specifiedNumberOfHeads
              }],
              _
            ];
  
            (* Create a pattern for Application *)
            colonyHandlerHeadCassetteApplicationPattern = If[IntegerQ[specifiedColonyHandlerHeadCassetteApplication],
              KeyValuePattern[{
                ColonyHandlerHeadCassetteApplication -> specifiedColonyHandlerHeadCassetteApplication
              }],
              _
            ];
  
            (* Combine the patterns *)
            filterPattern = PatternUnion[
              headDiameterPattern,
              headLengthPattern,
              numberOfHeadsPattern,
              colonyHandlerHeadCassetteApplicationPattern
            ];
  
            (* Filter the part packets to see if we can support the user requests *)
            filteredPartPackets = Cases[First /@ pickingColonyHandlerHeadCassettesPackets, filterPattern];
  
            (* Do we have any valid parts? *)
            Which[
              Length[filteredPartPackets] == 0,
                (* If we do not mark an error *)
                (* Return 96-pin as we cannot resolve Null for the picking tool and track noAvailablePickingToolError separately *)
                  noAvailablePickingToolError = True; Model[Part, ColonyHandlerHeadCassette, "id:vXl9j5l87OzZ"],
              (* If the destination media container is not valid *)
              (* Just default to 96 pin when destination media container is not valid *)
              invalidDestinationMediaContainerError,
                Model[Part, ColonyHandlerHeadCassette, "id:vXl9j5l87OzZ"],
              (* There are available parts - do additional checks to see if they match the destination media container *)
              (* or if they filtered out all heads compatible with the destination media container *)
              True,
                Module[
                  {
                    resolvedDestinationMediaContainerModels, destContainerNumWells, validNumberOfWellsParts, destContainerDeepwellQ,
                    validDeepWellParts, sampleComposition, modelCellToUse, preferredColonyHandlerHeads, validPreferredColonyHandlerHeads
                  },
  
                  resolvedDestinationMediaContainerModels = Switch[#,
  
                    (* If the plate is an object, look up the Model *)
                    ObjectP[Object[Container]],
                      Download[fastAssocLookup[combinedFastAssoc, #, Model], Object],
  
                    (* If the plate is a list of Objects[flatten and get the models] *)
                    {ObjectP[Object[Container]]..},
                      Sequence@@(Download[fastAssocLookup[combinedFastAssoc, #, Model], Object]),
  
                    (* If the plate is a Model, keep it *)
                    _,
                      #
                  ]& /@ updatedDestinationMediaContainer;
                  
                  (* Get the number of wells in the destination media container *)
                  destContainerNumWells = fastAssocLookup[combinedFastAssoc, resolvedDestinationMediaContainerModels, NumberOfWells]/.$Failed->1;
  
                  (* Filter based on number of wells of the destination media container *)
                  validNumberOfWellsParts = Which[
                    (* MemberQ[destContainerNumWells,24]No head can support both 24 well plates and 96 well plates *)
                    MemberQ[destContainerNumWells, 24]&&(MemberQ[destContainerNumWells, 96] || MemberQ[destContainerNumWells, 1]),
                      {},
                    (* 24 well plates support the 24 head cassettes *)
                    MemberQ[destContainerNumWells, 24],
                      Cases[filteredPartPackets, KeyValuePattern[NumberOfHeads -> 24]],
                    (* Omnitrays and 96 well plates use the 96 head cassettes *)
                    (MemberQ[destContainerNumWells, 96] || MemberQ[destContainerNumWells, 1]),
                      Cases[filteredPartPackets, KeyValuePattern[NumberOfHeads -> 96]],
                    (* Catch all *)
                    True,
                      {}
                  ];
  
                  (* Get whether the destination media container is a deep well plate *)
                  destContainerDeepwellQ = GreaterEqualQ[#, 37 Millimeter]& /@ fastAssocLookup[combinedFastAssoc, resolvedDestinationMediaContainerModels, WellDepth];
  
                  (* Filter based on whether the destination media container is deep well *)
                  validDeepWellParts = Which[
                    (* No head supports both deep well and non deep well depositing *)
                    !SameQ[destContainerDeepwellQ],
                        {},
                    (* If only Deep well plates are detected *)
                    MemberQ[destContainerDeepwellQ, True],
                      Cases[validNumberOfWellsParts, KeyValuePattern[HeadLength -> RangeP[19.4 Millimeter]]],
                    (* If only non deep well plates are detected *)
                    MemberQ[destContainerDeepwellQ, False],
                      Cases[validNumberOfWellsParts, KeyValuePattern[HeadLength -> RangeP[9.4 Millimeter]]],
                    (* Catch all *)
                    True,
                      {}
                  ];
  
                  (* Lookup the sample composition *)
                  sampleComposition = fastAssocLookup[combinedFastAssoc, mySample, Composition];
  
                  (* Get the first Model[Cell] in the composition if it exists *)
                  modelCellToUse = FirstOrDefault@selectMainCellFromSample[mySample, Cache -> combinedCache, Simulation -> currentSimulation];
  
                  (* If there is a model cell, lookup the PreferredColonyHandlerHeadCassettes *)
                  preferredColonyHandlerHeads = Download[If[!NullQ[modelCellToUse],
                    fastAssocLookup[combinedFastAssoc, modelCellToUse, PreferredColonyHandlerHeadCassettes],
                    {}
                  ], Object];
  
                  (* Get any preferred colony handler heads that also match our filters *)
                  validPreferredColonyHandlerHeads = Intersection[Lookup[validDeepWellParts, Object, {}], preferredColonyHandlerHeads];
  
                  (* Use a preferred head if one exists, if one does not exist, use a filtered part, if there are no more valid parts, return Null *)
                  Which[
                    (* There is a valid preferred head *)
                    Length[validPreferredColonyHandlerHeads] > 0,
                      First[validPreferredColonyHandlerHeads],
                    (* There is a valid head but it is not preferred *)
                    Length[validDeepWellParts] > 0,
                      Lookup[First[validDeepWellParts], Object],
                    (* There are no valid heads just default to 96 pin *)
                    True,
                      noAvailablePickingToolError = True;
                      Model[Part, ColonyHandlerHeadCassette, "id:vXl9j5l87OzZ"]
                  ]
                ]
            ]
          ]
        ];
  
        (* Check if the resolved colony picking tool is preferred for the sample *)
        (* Don't throw additional errors if a tool was not found *)
        If[!NullQ[updatedColonyPickingTool],
          Module[{colonyPickingToolModel, cellModel, preferredColonyHandlerHeads},
  
            (* Get the resolved tool model *)
            colonyPickingToolModel = If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part, ColonyHandlerHeadCassette]]],
              Download[fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, Model], Object],
              updatedColonyPickingTool
            ];
  
            (* Get the composition *)
            (* Get the first Model[Cell] from the composition *)
            cellModel = FirstOrDefault@selectMainCellFromSample[mySample, Cache -> combinedCache, Simulation -> currentSimulation];
  
            (* Get any PreferredColonyHandlerHeads *)
            preferredColonyHandlerHeads = Download[fastAssocLookup[combinedFastAssoc, cellModel, PreferredColonyHandlerHeadCassettes], Object];
  
            (* See if the chosen tool model is preferred for the cell *)
            notPreferredColonyHandlerHeadWarning = !MemberQ[preferredColonyHandlerHeads, colonyPickingToolModel]
          ]
        ];
        
        (* Resolve the ColonyHandler head parameter options *)
        (* HeadDiameter *)
        updatedHeadDiameter = If[MatchQ[specifiedHeadDiameter, Automatic],
          (* If the option is Automatic, resolve it to the value of the resolvedColonyPickingTool *)
          If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, HeadDiameter}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, HeadDiameter]
          ],
          (* If the option is not Automatic, make sure it matches the value of the resolvedColonyPickingTool *)
          If[!MatchQ[specifiedHeadDiameter, RangeP[If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, HeadDiameter}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, HeadDiameter]
          ]]],
            headDiameterMismatchError = True
          ];
          specifiedHeadDiameter
        ];
        
        (* HeadLength *)
        updatedHeadLength = If[MatchQ[specifiedHeadLength, Automatic],
          (* If the option is Automatic, resolve it to the value of the resolvedColonyPickingTool *)
          If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model,HeadLength}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, HeadLength]
          ],
          (* If the option is not Automatic, make sure it matches the value of the resolvedColonyPickingTool *)
          If[!MatchQ[specifiedHeadLength, RangeP[If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, HeadLength}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, HeadLength]
          ]]],
            headLengthMismatchError = True
          ];
          specifiedHeadLength
        ];
        
        (* NumberOfHeads *)
        updatedNumberOfHeads = If[MatchQ[specifiedNumberOfHeads, Automatic],
          (* If the option is Automatic, resolve it to the value of the resolvedColonyPickingTool *)
          (* If the resolvedColonyPickingTool is Null, set to Null *)
          If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, NumberOfHeads}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, NumberOfHeads]
          ],
          (* If the option is not Automatic, make sure it matches the value of the resolvedColonyPickingTool *)
          If[!MatchQ[specifiedNumberOfHeads, RangeP[If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, NumberOfHeads}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, NumberOfHeads]
          ]]],
            numberOfHeadsMismatchError = True
          ];
          specifiedNumberOfHeads
        ];
        
        (* ColonyHandlerHeadCassetteApplication *)
        updatedColonyHandlerHeadCassetteApplication = If[MatchQ[specifiedColonyHandlerHeadCassetteApplication, Automatic],
          (* If the option is Automatic, resolve it to the value of the resolvedColonyPickingTool *)
          (* If the resolvedColonyPickingTool is Null, set to Null *)
          If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, Application}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, Application]
          ],
          (* If the option is not Automatic, make sure it matches the value of the resolvedColonyPickingTool *)
          If[!MatchQ[specifiedColonyHandlerHeadCassetteApplication, If[MatchQ[updatedColonyPickingTool, ObjectP[Object[Part]]],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, {Model, Application}],
            fastAssocLookup[combinedFastAssoc, updatedColonyPickingTool, Application]
          ]],
            colonyHandlerHeadCassetteApplicationMismatchError = True
          ];
          specifiedColonyHandlerHeadCassetteApplication
        ];
  
        (* Resolve ColonyPickingDepth - check to see if it is too high *)
        updatedColonyPickingDepth = Map[
          Function[{colonyPickingDepth},
            Module[{sourceWellDepth},
    
              (* Lookup the depth of the source well *)
              sourceWellDepth = fastAssocLookup[combinedFastAssoc, mySample, {Container, Model, WellDepth}];
    
              If[sourceWellDepth < colonyPickingDepth,
                invalidColonyPickingDepthError = True;
              ];
    
              (* Return the picking depth *)
              colonyPickingDepth
            ]
          ],
          specifiedColonyPickingDepth
        ];

        (* Expand and resolve SamplesOutStorageConditon *)
        updatedSamplesOutStorageCondition = If[ListQ[samplesOutStorageConditionsPossiblyCollapsed] && ListQ[updatedMediaVolume] && Length[samplesOutStorageConditionsPossiblyCollapsed] == Length[updatedMediaVolume],
          samplesOutStorageConditionsPossiblyCollapsed,
          (updatedMediaVolume /. {VolumeP -> samplesOutStorageConditionsPossiblyCollapsed})
        ];

        (* Gather MapThread results *)
        {
          (* -- ERROR TRACKING VARIABLES -- *)
          missingImagingStrategyInfo,(*1*)
          imagingOptionSameLengthError,(*3*)
          pickCoordinatesMismatchError,(*4*)
          destinationMediaStateError,(*5*)
          destinationMediaTypeMismatchError,(*6*)
          invalidDestinationMediaContainerError,(*7*)
          tooManyDestinationMediaContainersError,(*8*)
          tooManyPickCoordinatesError,(*9*)
          destinationFillDirectionMismatchError,(*10*)
          missingDestinationCoordinatesError,(*11*)
          tooManyDestinationCoordinatesWarning,(*12*)
          destinationMixMismatchError,(*13*)
          invalidMixOptionError,(*14*)
          pickingToolIncompatibleWithDestinationMediaContainerError,(*15*)
          noAvailablePickingToolError,(*16*)
          notPreferredColonyHandlerHeadWarning,(*17*)
          headDiameterMismatchError,(*18*)
          headLengthMismatchError,(*19*)
          numberOfHeadsMismatchError,(*20*)
          colonyHandlerHeadCassetteApplicationMismatchError,(*21*)
          invalidColonyPickingDepthError,(*22*)
          (* -- RESOLVED OPTIONS -- *)
          (* Imaging *)
          updatedImagingChannels,(*23*)
          updatedImagingStrategies,(*24*)
          updatedExposureTimes,(*25*)
          (* Picking *)
          updatedColonyPickingTool,(*26*)
          updatedHeadDiameter,(*27*)
          updatedHeadLength,(*28*)
          updatedNumberOfHeads,(*29*)
          updatedColonyHandlerHeadCassetteApplication,(*30*)
          updatedColonyPickingDepth,(*31*)
          (* Destination *)
          updatedDestinationMediaType,(*32*)
          updatedDestinationMedia,(*33*)
          updatedDestinationMediaContainer,(*34*)
          updatedMaxDestinationNumberOfColumns,(*35*)
          updatedMaxDestinationNumberOfRows,(*36*)
          updatedDestinationCoordinates,(*37*)
          updatedMediaVolume,(*38*)
          updatedDestinationMix,(*39*)
          updatedDestinationNumberOfMixes,(*40*)
          updatedSamplesOutStorageCondition(*41*)
        }
      ]
    ],
    {mySamples, mapThreadFriendlyOptions}
  ];

  (* Variables to keep track of specified label errors *)
  (* NOTE: These contain lists of the form {sample, sample index, population head, number of labels provided, expected number of labels} *)
  sampleOutLabelLengthErrors = {};
  containerOutLabelLengthErrors = {};

  (* Resolve the label options *)
  (* Currently when there is a Population error, ExperimentPickColonies skip resolving SampleOutLabel/ContainerOutLabel and return {{{}}}. *)
  (* Since ExpandIndexMatchedInputs check the option pattern, expansion will fail with Error::ValueDoesNotMatchPattern. *)
  (* If we change this in the future, redo ExperimentInoculateLM resolver where we drop those 2 label options to avoid Error::ValueDoesNotMatchPattern *)
  {resolvedSampleOutLabels,resolvedContainerOutLabels} = Module[
    {
      objectContainerNumAvailablePositionsLookup, objectContainerToReservationsLookup, updatedObjectContainerReservations,
      modelContainerReservations,solidMediaSampleLabelLookup,objectContainerLabelRules
    },

    (* General Explanation/outline of the sample out label resolution: *)
    (* The number of sample out labels created relies on many factors including *)
    (* NestedIndexMatchingOptions: DestinationMediaType, DestinationMediaContainer, DestinationMaxNumberOfRows, DestinationMaxNumberOfColumns, Populations *)
    (* and IndexMatching options/inputs: Sample, PickCoordinates *)
    (* The biggest determining factors on how many/what labels are created are the DestinationMediaType and how the DestinationMediaContainer is specified *)
    (* If, for a particular sample, DestinationMediaType -> SolidMedia then we just need to make as many labels as there are Object[Container]'s *)
    (* or up to 6 labels for a Model[Container]. This is because each all of the picked colonies go into the single well of the destination container *)
    (* If, for a particular population DestinationMediaType -> LiquidMedia, then we have to case on how DestinationMediaContainer is specified. *)
    (* If it is specified as a Model[Container], we have up to 6 plates of that model to work with. *)
    (*     1. Figure out the max number of colonies that we could possibly pick (either from the population, or via pick coordinates) *)
    (*     2. Determine the number of possible wells in the container from its model and MaxDestinationNumRows/Cols *)
    (*     3. Create the labels *)
    (*     NOTE: If the max number of colonies is specified as All (either through the NumberOfColonies option in a Population primitive or through the AllColonies primitive) *)
    (*           6 plates will always be created. If the max number of colonies is known, we will limit the plates to the number necessary *)
    (* If it is specified as an Object[Container] or {Object[Container]..}, we have to take into account that different populations across different samples *)
    (* could be trying to place picked colonies into the object. Thus we use a reservation system that prioritizes populations that don't specify the number of colonies as 'All' *)
    (*     1. Create a lookup where each key is an Object[Container] and the value is a list that contains populations and the number of wells that population needs in that container *)
    (*     2. We prioritize populations that specify a specific number of colonies. So next, we go through and update these 'lists of reservations' and translate *)
    (*        any 'All's into actual numbers. The number of reservations specified through numbers (not all) is subtracted from *)
    (*        the total number of possible wells for that container (calculated same way as in the model case). Then any remaining spots are distributed evenly among *)
    (*        any populations that have 'All' reservations *)
    (* NOTE: doing the reservations in this manner helps prevent disconnects later on if the number of colonies expected to pick is not the same as the number that actually grew on the plate *)

    (* This is for convenience so we don't have to do this calculation over and over later on *)
    (* Create a lookup mapping each Object[Container] to the total number of available positions: Min[numberOfWells, maxRows * maxCols] *)
    objectContainerNumAvailablePositionsLookup = Merge[Association/@Flatten@MapThread[
      Function[{destinationMediaContainers, allMaxRows, allMaxCols},
        Module[{sanitizedMaxRows,sanitizedMaxCols},
          (* Sanitize max rows and max cols *)
          sanitizedMaxRows = allMaxRows /. {Automatic -> 8, Null -> 16};
          sanitizedMaxCols = allMaxCols /. {Automatic -> 12, Null -> 24};

          (* Loop again per population *)
          MapThread[
            Function[{destinationContainers, maxRows, maxCols},
              (* Switch on the value of the destination container *)
              Which[
                MatchQ[destinationContainers,ObjectP[Model[Container]]],
                Nothing,
                MatchQ[destinationContainers,ObjectP[Object[Container]]],
                destinationContainers -> Min[fastAssocLookup[combinedFastAssoc, destinationContainers, {Model,NumberOfWells}], maxRows * maxCols],
                True,
                Map[Function[{container},
                  container -> Min[fastAssocLookup[combinedFastAssoc, container, {Model,NumberOfWells}], maxRows * maxCols]
                ],
                  destinationContainers
                ]
              ]
            ],
            {
              destinationMediaContainers,
              sanitizedMaxRows,
              sanitizedMaxCols
            }
          ]
        ]
      ],
      {
        resolvedDestinationMediaContainers,
        resolvedMaxDestinationNumberOfRows,
        resolvedMaxDestinationNumberOfColumns
      }
    ],Min];

    (* The first step in resolving the sample out labels is to make a first pass through the populations/pick coordinates and destination media containers *)
    (* in order to determine if any populations will be placed in the same Object[Container] *)
    (* This will be done by creating a lookup of the structure Object[Container] -> {{sample, population, numberOfSpotsToReserve in the container}..} *)
    objectContainerToReservationsLookup = <||>;

    (* Loop over the values per sample to create the lookup *)
    MapThread[
      Function[{mySample,destinationMediaTypes,pickCoordinates,populations,destinationMediaContainers},
        MapThread[
          Function[{destinationMediaType,population,destinationContainers},
            Which[
              (* We can skip if the destination container is a Model[Container] or if destinationMediaType is SolidMedia. *)
              (* For Models we will always make a new set of containers per population so they don't need to be kept track of in the same way *)
              (* SolidMedia destinations always only have 1 sample, so once again they don't need to be kept track of in this manner *)
              MatchQ[destinationContainers,ObjectP[Model[Container]]] || MatchQ[destinationMediaType, SolidMedia],
              Null,

              (* TODO: Change it to combine the last to cases into 1 case (just always wrap a list around the single object case) *)
              (* If we have a liquid media destination and specified object container, mark it down *)
              MatchQ[destinationContainers, ObjectP[Object[Container]]],
              Module[
                {
                  existingReservationList,totalNumberOfReservationsSoFar,totalReservationsPossible,
                  numberOfSpotsToTryToReserve,numberOfSpotsToReserve,newReservationList
                },

                (* Get the value from the lookup if one exists for this object *)
                existingReservationList = Lookup[objectContainerToReservationsLookup, destinationContainers, {}];

                (* Total all non "All" values in the existing reservatino list *)
                totalNumberOfReservationsSoFar = Total[existingReservationList[[All,3]]/.{All -> 0}];

                (* Get the total number of reservations possible in the container *)
                totalReservationsPossible = Lookup[objectContainerNumAvailablePositionsLookup, destinationContainers, 0];

                (* Determine the number of spots that need to be reserved for this population in this container *)
                numberOfSpotsToTryToReserve = If[MatchQ[population,CustomCoordinates],
                  Length[pickCoordinates],
                  Module[{populationAssociation,populationHead},

                    (* Get the population primitive in association form *)
                    populationAssociation = population[[1]];

                    (* Get the head of the population *)
                    populationHead = Head[population];

                    (* Extract the value from the population *)
                    If[MatchQ[populationHead,AllColonies],
                      All,
                      Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                    ]
                  ]
                ];

                (* Determine the actual number of spots to reserve *)
                numberOfSpotsToReserve = If[MatchQ[numberOfSpotsToTryToReserve, All],
                  numberOfSpotsToTryToReserve,
                  Min[totalReservationsPossible - totalNumberOfReservationsSoFar, numberOfSpotsToTryToReserve]
                ];

                (* Add an entry to the end of the list *)
                newReservationList = Append[existingReservationList,{mySample, population, numberOfSpotsToReserve}];

                (* Update the lookup *)
                objectContainerToReservationsLookup[destinationContainers] = newReservationList;
              ],

              (* Otherwise, we have a liquid media destination and a list of object containers *)
              True,
              Module[{numberOfSpotsLeftToReserve},
                (* Get the number of spots to reserve over these containers *)
                (* NOTE: this variable will be iterated on as we go through the destination containers *)
                numberOfSpotsLeftToReserve = If[MatchQ[population,CustomCoordinates],
                  Length[pickCoordinates],
                  Module[{populationAssociation,populationHead},

                    (* Get the population primitive in association form *)
                    populationAssociation = population[[1]];

                    (* Get the head of the population *)
                    populationHead = Head[population];

                    If[MatchQ[populationHead,AllColonies],
                      All,
                      Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                    ]
                  ]
                ];

                (* Loop over our list of object containers and add them to the main lookup accordingly *)
                Map[Function[{container},
                  Module[
                    {
                      existingReservationList,totalNumberOfReservationsSoFar,totalReservationsPossible,
                      numberOfSpotsToReserve,newReservationList
                    },

                    (* Get the value from the lookup if one exists for this object *)
                    existingReservationList = Lookup[objectContainerToReservationsLookup, container, {}];

                    (* Total all non "All" values in the existing reservatino list *)
                    totalNumberOfReservationsSoFar = If[MatchQ[existingReservationList,{}],
                      0,
                      Total[existingReservationList[[All,3]]/.{All -> 0}]
                    ];

                    (* Get the total number of reservations possible in the container *)
                    totalReservationsPossible = Lookup[objectContainerNumAvailablePositionsLookup, container, 0];

                    (* Determine the actual number of spots to reserve *)
                    numberOfSpotsToReserve = If[MatchQ[numberOfSpotsLeftToReserve, All],
                      numberOfSpotsLeftToReserve,
                      Min[totalReservationsPossible - totalNumberOfReservationsSoFar, numberOfSpotsLeftToReserve]
                    ];

                    (* Add an entry to the end of the list *)
                    newReservationList = Append[existingReservationList,{mySample, population, numberOfSpotsToReserve}];

                    (* Update our tracking number *)
                    numberOfSpotsLeftToReserve = If[MatchQ[numberOfSpotsLeftToReserve,All],
                      All,
                      numberOfSpotsLeftToReserve - numberOfSpotsToReserve
                    ];

                    (* Update the lookup *)
                    objectContainerToReservationsLookup[container] = newReservationList;
                  ]
                ],
                  destinationContainers
                ]
              ]
            ]
          ],
          {
            destinationMediaTypes,
            populations,
            destinationMediaContainers
          }
        ]
      ],
      {
        mySamples,
        resolvedDestinationMediaTypes,
        resolvedPickCoordinates[[All,2]],
        Lookup[partiallyResolvedPickColoniesOptionsWithAnalysis,Populations],
        resolvedDestinationMediaContainers
      }
    ];

    (* Audit the reservations and translate any 'All''s into an actual number of positions *)
    updatedObjectContainerReservations = KeyValueMap[
      Function[{container,reservations},
        Module[{totalNumberOfAvailableWellsInContainer,allReservations,numericalReservations},

          (* Get the number of available wells in this container *)
          totalNumberOfAvailableWellsInContainer = Lookup[objectContainerNumAvailablePositionsLookup,container];

          (* Split the reservations into reservations that are already by number and ones that specify 'All' *)
          allReservations = Cases[reservations,{_,_,All}];
          numericalReservations = Cases[reservations,{_,_,NumberP}];

          (* If there are any reservations that are specified through "All" we need to translate that into a number *)
          If[Length[allReservations] > 0,
            Module[{totalNumberOfNonAllReservations,numPositionsAvailableForAlls,numReservationsPerAll,updatedAllReservations},

              (* Calculate the total number of non-All reservations *)
              totalNumberOfNonAllReservations = If[MatchQ[numericalReservations,{}],
                0,
                Total[numericalReservations[[All,3]]]
              ];

              (* Calculate the number of positions available for any 'All's to occupy *)
              numPositionsAvailableForAlls = Max[totalNumberOfAvailableWellsInContainer - totalNumberOfNonAllReservations, 0];

              (* Calculate the number of reservations each 'All' will get *)
              numReservationsPerAll = Floor[numPositionsAvailableForAlls / Length[allReservations]];

              (* Replace in the list of all reservations *)
              updatedAllReservations = ({#[[1]],#[[2]],numReservationsPerAll})&/@allReservations;

              (* Recombine the reservation list and return *)
              container -> Join[numericalReservations,updatedAllReservations]
            ],
            (* Otherwise just leave the reservations as they are *)
            container -> reservations
          ]
        ]
      ],
      objectContainerToReservationsLookup
    ];

    (* Also do a reservation system for the Model[Container]'s. This is so we know how many containers to create for each population *)
    (* if there are multiple populations for the same sample with Model[Container] as the DestinationMediaContainer *)
    (* NOTE: The structure of this lookup will be Model[Container] -> {{sample, population, numberOfContainers To Reserve} ..} *)
    modelContainerReservations = <||>;

    (* Populate the lookup *)
    MapThread[
      Function[{mySample,destinationMediaTypes,pickCoordinates,populations,destinationMediaContainers,maxDestNumRows,maxDestNumCols},
        Module[
          {
            numberOfColoniesToPickPerPopulation,numberOfContainersNeededPerPopulation,modelContainerAndNumColonies,
            tuplesThatNeedToBeAddedStill,numAvailableContainers,allTuplesToPopulate
          },

          (* 1. Get the number of colonies for each population *)
          numberOfColoniesToPickPerPopulation = Map[
            Function[{population},
              If[MatchQ[population,CustomCoordinates],
                Length[pickCoordinates],
                Module[{populationAssociation,populationHead},

                  (* Get the population primitive in association form *)
                  populationAssociation = population[[1]];

                  (* Get the head of the population *)
                  populationHead = Head[population];

                  (* Extract the value from the population *)
                  If[MatchQ[populationHead,AllColonies],
                    All,
                    Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                  ]
                ]
              ]
            ],
            populations
          ];

          (* 2. Determine how many of a Model[Container] it would take to hold the number of colonies *)
          numberOfContainersNeededPerPopulation = MapThread[Function[{numColonies,container,destinationMediaType,maxRows,maxCols},
            Which[
              (* If the container is not a Model, return the number of objects *)
              MatchQ[ToList[container],{ObjectP[Object[Container]]..}],
                Length[ToList[container]],

              (* If the numberOfColonies is All, just keep it *)
              MatchQ[numColonies,All],
                numColonies,

              (* If the destinationMediaType is SolidMedia, then each plate can hold 96 colonies (restricted by maxNumRows/Cols) *)
              MatchQ[destinationMediaType, SolidMedia],
                Ceiling[N[numColonies / Min[96, maxRows * maxCols]]],

              (* Otherwise, if destinationMediaType is LiquidMedia, then each plate can hold numberOfWells colonies (restricted by maxNumRows/Cols) *)
              MatchQ[fastAssocLookup[combinedFastAssoc,container,NumberOfWells], _Integer],
                Ceiling[N[numColonies / Min[fastAssocLookup[combinedFastAssoc,container,NumberOfWells], maxRows * maxCols]]],
              (* If there is no NumberOfWells fields, use 1. This is the case when a non-plate DestinationMediaContainer is wrongly specified *)
              True,
                Ceiling[N[numColonies / Min[1, maxRows * maxCols]]]
            ]
          ],
            {
              numberOfColoniesToPickPerPopulation,
              destinationMediaContainers,
              destinationMediaTypes,
              maxDestNumRows /. {Automatic -> 8, Null -> 16},
              maxDestNumCols /. {Automatic -> 12, Null -> 24}
            }
          ];

          (* 3. Link any Model[Container]'s in destinationMediaContainer's with the number of colonies per population *)
          modelContainerAndNumColonies = Cases[
            Transpose[{destinationMediaContainers, ConstantArray[mySample, Length[populations]], populations, numberOfContainersNeededPerPopulation}],
            {ObjectP[Model[Container]],_,_,_}
          ];

          (* 4. Determine the number of open container spots for this container (max 4) - number of object containers specified *)
          numAvailableContainers = Max[4 - (Length[Cases[Flatten[destinationMediaContainers],ObjectP[Object[Container]]]]), 0];
          
          (* 4. Add tuples with non All number of containers to the lookup if there is room *)
          (* NOTE: Only add the tuple if ALL of its required containers can fit *)
          tuplesThatNeedToBeAddedStill = Map[
            Function[{tuple},
              If[!MatchQ[Last[tuple], All] && (numAvailableContainers - Last[tuple] > 0),
                Module[{originalValue},
                  (* Get the original value *)
                  originalValue = Lookup[modelContainerReservations,First[tuple],{}];

                  (* Update the lookup *)
                  modelContainerReservations[First[tuple]] = Append[originalValue, Rest[tuple]];
                  
                  (* Update the number of available containers *)
                  numAvailableContainers = numAvailableContainers - Last[tuple];

                  (* Return nothing *)
                  Nothing
                ],
                (* Otherwise keep the tuple *)
                tuple
              ]
            ],
            modelContainerAndNumColonies
          ];

          (* 6. Split the remaining available containers among any tuples with numberOfContainers = All *)
          allTuplesToPopulate = Take[Flatten[ConstantArray[Cases[tuplesThatNeedToBeAddedStill,{_,_,_,All}],2],1],UpTo[numAvailableContainers]];

          (* 7. Update the lookup with any tuples with numberOfContainers = All that got assigned spots *)
          Map[
            Function[{tuple},
              Module[{tupleContainer,tupleSample,tuplePopulation,tupleNumContainers,originalListOfTuples,currentPosition,currentCount},
                (* Split the given tuple into its parts *)
                {tupleContainer,tupleSample,tuplePopulation,tupleNumContainers} = tuple;

                (* Get the list of tuples for the container *)
                originalListOfTuples = Lookup[modelContainerReservations, tupleContainer,{}];

                (* See if there is already a count for this container/sample/population combo *)
                currentPosition = Position[originalListOfTuples,{tupleSample, tuplePopulation, _}];

                (* Get the current count *)
                currentCount = If[MatchQ[currentPosition,{}],
                  0,
                  Last[originalListOfTuples[[First[First[currentPosition]]]]]
                ];

                (* Increment the count *)
                If[MatchQ[currentPosition,{}],
                  modelContainerReservations[tupleContainer] = Append[originalListOfTuples, {tupleSample,tuplePopulation,currentCount + 1}],
                  modelContainerReservations[tupleContainer] = ReplacePart[originalListOfTuples, currentPosition -> {tupleSample,tuplePopulation,currentCount + 1}]
                ];

                (* Remove the tuple from the list of tuples to still be added *)
                tuplesThatNeedToBeAddedStill = DeleteCases[tuplesThatNeedToBeAddedStill,tuple]
              ]
            ],
            allTuplesToPopulate
          ];

          (* Add a value to the lookup for any tuple that did not get any spots *)
          Map[
            Function[{tuple},
              Module[{tupleContainer,tupleSample,tuplePopulation,tupleNumContainers,originalListOfTuples},
                (* Split the given tuple into its parts *)
                {tupleContainer,tupleSample,tuplePopulation,tupleNumContainers} = tuple;

                (* Get the list of tuples for the container *)
                originalListOfTuples = Lookup[modelContainerReservations, tupleContainer,{}];

                (* Add the tuple *)
                modelContainerReservations[tupleContainer] = Append[originalListOfTuples, {tupleSample, tuplePopulation, 0}]
              ]
            ],
            tuplesThatNeedToBeAddedStill
          ]
        ]
      ],
      {
        mySamples,
        resolvedDestinationMediaTypes,
        resolvedPickCoordinates[[All,2]],
        Lookup[partiallyResolvedPickColoniesOptionsWithAnalysis,Populations],
        resolvedDestinationMediaContainers,
        resolvedMaxDestinationNumberOfRows,
        resolvedMaxDestinationNumberOfColumns
      }
    ];

    (* Initialize lookups to store sample label information *)
    (* NOTE: Key is Container and Value is Sample Label (_String) *)
    solidMediaSampleLabelLookup = {};

    (* Create a list of rules of Object[Container] -> label *)
    objectContainerLabelRules = {};

    (* Use the reservations and solid media lookup to make the sample out labels *)
    Transpose@ MapThread[
      Function[{mySample,sampleOutLabels, containerOutLabels, destinationMediaTypes, pickCoordinates, populations, destinationMediaContainers, allMaxRows, allMaxCols, sampleIndex},
        Module[{populationNumberLookup,sanitizedMaxRows,sanitizedMaxCols},
          (* Initialize a lookup to keep track of what number of each type of population we are on for this sample *)
          (* NOTE: This will have the form "Head" -> number seen so far *)
          populationNumberLookup = <||>;

          (* Sanitize MaxRows/MaxCols *)
          sanitizedMaxRows = allMaxRows /. {Automatic -> 8, Null -> 16};
          sanitizedMaxCols = allMaxCols /. {Automatic -> 12, Null -> 24};

          Transpose@ MapThread[
            Function[{sampleOutLabel, containerOutLabel, destinationMediaType, population, destinationContainers, maxRows, maxCols},
              {
                (* Sample Out Labels *)
                Module[{populationHeadString},
                  (* Extract the head of the population (if it exists), so we can use it inside our labeling *)
                  populationHeadString = ToString[Head[population]];

                  (* Case on DestinationMediaType *)
                  If[
                    (* If the destinationMediaType is SolidMedia, then we need to create one label (sample) per container *)
                    (* This is because all of our picked colonies are going to end up in the same well *)
                    MatchQ[destinationMediaType, SolidMedia],
                    Which[
                      (* Is the destination container specified as a Model[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Model[Container]]],
                      (* Yes, this means we need to create sample labels *)
                      Module[{numberOfSamplesToLabel,innerLabelString},

                        (* Get the number of samples to reserve from our reservation lookup *)
                        numberOfSamplesToLabel = Last[FirstCase[Lookup[modelContainerReservations, destinationContainers],{mySample,population,_}]];

                        (* Generate the inner portion of the label *)
                        innerLabelString = If[MatchQ[population,CustomCoordinates],
                          "",
                          Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                            (* Get the stored index of the population head *)
                            storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                            (* Increment the counter *)
                            populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                            (* Store the new value *)
                            populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                            (* Create the string *)
                            populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                          ]
                        ];

                        (* If we have a given label, keep it, but check its length *)
                        If[MatchQ[sampleOutLabel,Except[Automatic]],
                          Module[{},
                            (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                            If[!MatchQ[Length[ToList[sampleOutLabel]], numberOfSamplesToLabel],
                              AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], numberOfSamplesToLabel}]
                            ];

                            (* Return the given labels *)
                            ToList[sampleOutLabel]
                          ],
                          (* Otherwise, return the auto resolved labels *)
                          Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Sample Out"],{i,1,numberOfSamplesToLabel}]
                        ]
                      ],

                      (* Is the destination container specified as an Object[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Object[Container]]],
                      (* Yes, this means we need to create/lookup a single sample label *)
                      (* Check the given sample label first, if it exists *)
                      If[MatchQ[sampleOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[sampleOutLabel]], 1],
                            AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], 1}]
                          ];

                          (* Return the given labels *)
                          ToList[sampleOutLabel]
                        ],
                        (* Otherwise, create/lookup a single sample label *)
                        Module[{labelFromLookup},

                          (* See if we have already created a label for this object *)
                          labelFromLookup = destinationContainers/.solidMediaSampleLabelLookup;

                          (* If we did, use it *)
                          If[StringQ[labelFromLookup],
                            {labelFromLookup},
                            (* Otherwise, we need to make our own *)
                            Module[{innerLabelString,newLabel},
                              (* Get the inner label *)
                              innerLabelString = If[MatchQ[population,CustomCoordinates],
                                "",
                                Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                  (* Get the stored index of the population head *)
                                  storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                  (* Increment the counter *)
                                  populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                  (* Store the new value *)
                                  populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                  (* Create the string *)
                                  populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                ]
                              ];

                              (* Create the label *)
                              newLabel = "Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Sample Out 1";

                              (* Add it to the lookup *)
                              AppendTo[solidMediaSampleLabelLookup, destinationContainers -> newLabel];

                              (* Return the label *)
                              {newLabel}
                            ]
                          ]
                        ]
                      ],

                      (* Otherwise, the destination container must be a list of Object[Container]'s *)
                      True,
                      (* Check if there is a given sample label *)
                      If[MatchQ[sampleOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[sampleOutLabel]], Length[destinationContainers]],
                            AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], Length[destinationContainers]}]
                          ];

                          (* Return the given labels *)
                          ToList[sampleOutLabel]
                        ],
                        (* Otherwise, return the auto resolved labels *)
                        (* Create/lookup a label for each Object[Container] *)
                        Map[Function[{container},
                          Module[{labelFromLookup},

                            (* See if we have already created a label for this object *)
                            labelFromLookup = container/.solidMediaSampleLabelLookup;

                            (* If we did, use it *)
                            If[StringQ[labelFromLookup],
                              labelFromLookup,
                              (* Otherwise, we need to make our own *)
                              Module[{innerLabelString,newLabel},
                                (* Get the inner label *)
                                innerLabelString = If[MatchQ[population,CustomCoordinates],
                                  "",
                                  Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                    (* Get the stored index of the population head *)
                                    storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                    (* Increment the counter *)
                                    populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                    (* Store the new value *)
                                    populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                    (* Create the string *)
                                    populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                  ]
                                ];

                                (* Create the label *)
                                newLabel = CreateUniqueLabel["Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Sample Out"];

                                (* Add it to the lookup *)
                                AppendTo[solidMediaSampleLabelLookup, container -> newLabel];

                                (* Return the label *)
                                newLabel
                              ]
                            ]
                          ]
                        ],
                          destinationContainers
                        ]
                      ]
                    ],

                    (* For the rest of the cases we can assume we are picking into liquid media *)
                    Which[
                      (* Is the destination container specified as a Model[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Model[Container]]],
                      (* Yes, this means we need to figure out how many colonies we are going to pick and use *)
                      (* that to figure ouw how many sample plates/samples we will need *)
                      Module[{numContainersReserved,numberOfColoniesToPick,numberOfSamplesToLabel,innerLabelString},
                        (* Lookup the number of containers this population has reserved *)
                        numContainersReserved = Last[FirstCase[Lookup[modelContainerReservations,destinationContainers],{mySample,population,_}]];

                        (* Get the number of colonies to pick from the population (All means 96) or the pick coordinates *)
                        numberOfColoniesToPick = If[MatchQ[population,CustomCoordinates],
                          Length[pickCoordinates],
                          Module[{populationAssociation,populationHead,containerNumberOfWell},

                            (* Get the population primitive in association form *)
                            populationAssociation = population[[1]];

                            (* Get the head of the population *)
                            populationHead = Head[population];

                            (* If there is no NumberOfWells fields, use 1. This is the case when a non-plate DestinationMediaContainer is wrongly specified *)
                            containerNumberOfWell = If[MatchQ[fastAssocLookup[combinedFastAssoc,destinationContainers,NumberOfWells], $Failed],
                              1,
                              fastAssocLookup[combinedFastAssoc,destinationContainers,NumberOfWells]
                            ];

                            If[MatchQ[populationHead,AllColonies],
                              All,
                              Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                            ] /. {All -> (containerNumberOfWell * numContainersReserved)}
                          ]
                        ];

                        (* Restrict the number of colonies by max dest rows/cols *)
                        numberOfSamplesToLabel = Min[numberOfColoniesToPick, (maxRows * maxCols * numContainersReserved)];

                        (* Generate the inner portion of the label *)
                        innerLabelString = If[MatchQ[population,CustomCoordinates],
                          "",
                          Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                            (* Get the stored index of the population head *)
                            storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                            (* Increment the counter *)
                            populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                            (* Store the new value *)
                            populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                            (* Create the string *)
                            populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                          ]
                        ];

                        (* If we were provided a list of sample labels, use them but check its length first. Otherwise create our own labels *)
                        If[MatchQ[sampleOutLabel,Except[Automatic]],
                          Module[{},
                            (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                            If[!MatchQ[Length[ToList[sampleOutLabel]], numberOfSamplesToLabel],
                              AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], numberOfSamplesToLabel}]
                            ];

                            (* Return the given labels *)
                            ToList[sampleOutLabel]
                          ],
                          (* Otherwise, return the auto resolved labels *)
                          Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Sample Out"],{i,1,numberOfSamplesToLabel}]
                        ]
                      ],

                      (* Is the destination container specified as an Object[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Object[Container]]],
                      Module[{containerReservations,numberOfLabelsToCreate,innerLabelString},

                        (* We've already done the work for this with the reservations, just lookup the Object[Container] and then find the sample/population combo *)
                        containerReservations = Lookup[updatedObjectContainerReservations,destinationContainers];

                        (* Find the number of labels to make *)
                        numberOfLabelsToCreate = Last[FirstCase[containerReservations,{mySample,population,_},{Null,Null,0}]];

                        (* Generate the inner portion of the label *)
                        innerLabelString = If[MatchQ[population,CustomCoordinates],
                          "",
                          Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                            (* Get the stored index of the population head *)
                            storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                            (* Increment the counter *)
                            populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                            (* Store the new value *)
                            populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                            (* Create the string *)
                            populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                          ]
                        ];

                        (* If we were provided a list of sample labels, use them but check its length first. Otherwise create our own labels *)
                        If[MatchQ[sampleOutLabel,Except[Automatic]],
                          Module[{},
                            (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                            If[!MatchQ[Length[ToList[sampleOutLabel]], numberOfLabelsToCreate],
                              AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], numberOfLabelsToCreate}]
                            ];

                            (* Return the given labels *)
                            ToList[sampleOutLabel]
                          ],
                          (* Otherwise, return the auto resolved labels *)
                          Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Sample Out"],{i,1,numberOfLabelsToCreate}]
                        ]
                      ],

                      (* Otherwise, the destination container must be a list of Object[Container]'s *)
                      True,
                        Module[{allResolvedSampleLabels},
                          (* Get the auto generated labels for all of the containers *)
                          allResolvedSampleLabels = Flatten@Map[Function[{container},
                            Module[{containerReservations,numberOfLabelsToCreate,innerLabelString},

                              (* We've already done the work for this with the reservations, just lookup the Object[Container] and then find the sample/population combo *)
                              containerReservations = Lookup[updatedObjectContainerReservations,container];

                              (* Find the number of labels to make *)
                              numberOfLabelsToCreate = (FirstCase[containerReservations,{mySample,population,_},{Null,Null,0}][[3]]);

                              (* Generate the inner portion of the label *)
                              innerLabelString = If[MatchQ[population,CustomCoordinates],
                                "",
                                Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                  (* Get the stored index of the population head *)
                                  storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                  (* Increment the counter *)
                                  populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                  (* Store the new value *)
                                  populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                  (* Create the string *)
                                  populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                ]
                              ];

                              (* Generate the sample labels *)
                              Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Picked Colony"],{i,1,numberOfLabelsToCreate}]
                            ]
                          ],
                            destinationContainers
                          ];

                          (* If we were provided a list of sample labels, use them but check its length first. Otherwise use our own created labels *)
                          If[MatchQ[sampleOutLabel,Except[Automatic]],
                            Module[{},
                              (* If the length of sampleOutLabel does not match the number of labels we need to make add to our error list *)
                              If[!MatchQ[Length[ToList[sampleOutLabel]], Length[allResolvedSampleLabels]],
                                AppendTo[sampleOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[sampleOutLabel]], Length[allResolvedSampleLabels]}]
                              ];

                              (* Return the given labels *)
                              ToList[sampleOutLabel]
                            ],
                            (* Otherwise, return the auto resolved labels *)
                            allResolvedSampleLabels
                          ]
                        ]
                    ]
                  ]
                ],

                (* Container Out Labels *)
                Module[{populationHeadString},
                  (* Extract the head of the population (if it exists), so we can use it inside our labeling *)
                  populationHeadString = ToString[Head[population]];

                  (* Case on DestinationMediaType *)
                  If[
                    (* If the destinationMediaType is SolidMedia, then we need to create one label (sample) per container *)
                    (* This is because all of our picked colonies are going to end up in the same well *)
                    MatchQ[destinationMediaType, SolidMedia],
                    Which[
                      (* Is the destination container specified as a Model[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Model[Container]]],
                      (* Yes, this means we need to figure out how many colonies we are going to pick and use  *)
                      (* that to figure out how many containers we will need *)
                      Module[{numberOfContainersToLabel,innerLabelString},

                        (* Get the number of containers to label from the reservations *)
                        numberOfContainersToLabel = Last[FirstCase[Lookup[modelContainerReservations,destinationContainers],{mySample,population,_}]];

                        (* Generate the inner portion of the label *)
                        innerLabelString = If[MatchQ[population,CustomCoordinates],
                          "",
                          Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                            (* Get the stored index of the population head *)
                            storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                            (* Increment the counter *)
                            populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                            (* Store the new value *)
                            populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                            (* Create the string *)
                            populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                          ]
                        ];

                        (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                        If[MatchQ[containerOutLabel,Except[Automatic]],
                          Module[{},
                            (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                            If[!MatchQ[Length[ToList[containerOutLabel]], numberOfContainersToLabel],
                              AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], numberOfContainersToLabel}]
                            ];

                            (* Return the given labels *)
                            ToList[containerOutLabel]
                          ],
                          (* Otherwise, return the auto resolved labels *)
                          Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Container Out"],{i,1,numberOfContainersToLabel}]
                        ]
                      ],

                      (* Is the destination container specified as an Object[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Object[Container]]],
                      (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                      If[MatchQ[containerOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[containerOutLabel]], 1],
                            AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], 1}]
                          ];

                          (* Return the given labels *)
                          ToList[containerOutLabel]
                        ],
                        (* Otherwise, this means we need to create/lookup a single container label *)
                        Module[{labelFromLookup},

                          (* See if we have already created a label for this object *)
                          labelFromLookup = destinationContainers/.objectContainerLabelRules;

                          (* If we did, use it *)
                          If[StringQ[labelFromLookup],
                            labelFromLookup,
                            (* Otherwise, we need to make our own *)
                            Module[{innerLabelString,newLabel},
                              (* Get the inner label *)
                              innerLabelString = If[MatchQ[population,CustomCoordinates],
                                "",
                                Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                  (* Get the stored index of the population head *)
                                  storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                  (* Increment the counter *)
                                  populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                  (* Store the new value *)
                                  populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                  (* Create the string *)
                                  populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                ]
                              ];

                              (* Create the label *)
                              newLabel = "Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Container Out 1";

                              (* Add it to the lookup *)
                              AppendTo[objectContainerLabelRules, destinationContainers -> newLabel];

                              (* Return the label *)
                              {newLabel}
                            ]
                          ]
                        ]
                      ],

                      (* Otherwise, the destination container must be a list of Object[Container]'s *)
                      True,
                      (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                      If[MatchQ[containerOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[containerOutLabel]], Length[destinationContainers]],
                            AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], Length[destinationContainers]}]
                          ];

                          (* Return the given labels *)
                          ToList[containerOutLabel]
                        ],
                        (* Otherwise, Create/lookup a label for each Object[Container] *)
                        Map[Function[{container},
                          Module[{labelFromLookup},

                            (* See if we have already created a label for this object *)
                            labelFromLookup = container/.objectContainerLabelRules;

                            (* If we did, use it *)
                            If[StringQ[labelFromLookup],
                              labelFromLookup,
                              (* Otherwise, we need to make our own *)
                              Module[{innerLabelString,newLabel},
                                (* Get the inner label *)
                                innerLabelString = If[MatchQ[population,CustomCoordinates],
                                  "",
                                  Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                    (* Get the stored index of the population head *)
                                    storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                    (* Increment the counter *)
                                    populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                    (* Store the new value *)
                                    populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                    (* Create the string *)
                                    populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                  ]
                                ];

                                (* Create the label *)
                                newLabel = CreateUniqueLabel["Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Container Out"];

                                (* Add it to the lookup *)
                                AppendTo[objectContainerLabelRules, container -> newLabel];

                                (* Return the label *)
                                newLabel
                              ]
                            ]
                          ]
                        ],
                          destinationContainers
                        ]
                      ]
                    ],

                    (* For the rest of the cases we can assume we are picking into liquid media *)
                    Which[
                      (* Is the destination container specified as a Model[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Model[Container]]],
                      (* Yes, this means we need to figure out how many colonies we are going to pick and use *)
                      (* that to figure ouw how many plates we will need *)
                      Module[{numberOfSamplesToLabel,numberOfContainersToLabel,innerLabelString},

                        (* Get the number of containers to label from the reservations *)
                        numberOfContainersToLabel = Last[FirstCase[Lookup[modelContainerReservations,destinationContainers],{mySample,population,_}]];

                        (* Generate the inner portion of the label *)
                        innerLabelString = If[MatchQ[population,CustomCoordinates],
                          "",
                          Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                            (* Get the stored index of the population head *)
                            storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                            (* Increment the counter *)
                            populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                            (* Store the new value *)
                            populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                            (* Create the string *)
                            populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                          ]
                        ];

                        (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                        If[MatchQ[containerOutLabel,Except[Automatic]],
                          Module[{},
                            (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                            If[!MatchQ[Length[ToList[containerOutLabel]], numberOfContainersToLabel],
                              AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], numberOfContainersToLabel}]
                            ];

                            (* Return the given labels *)
                            ToList[containerOutLabel]
                          ],
                          (* Otherwise, return the auto resolved labels *)
                          Table[CreateUniqueLabel["Sample " <> sampleIndex <> ", " <> innerLabelString <> "Container Out"],{i,1,numberOfContainersToLabel}]
                        ]
                      ],

                      (* Is the destination container specified as an Object[Container]? *)
                      MatchQ[destinationContainers, ObjectP[Object[Container]]],
                      (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                      If[MatchQ[containerOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[containerOutLabel]], 1],
                            AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], 1}]
                          ];

                          (* Return the given labels *)
                          ToList[containerOutLabel]
                        ],
                        (* Otherwise, Create/lookup a single object container label *)
                        Module[{labelFromLookup},

                          (* See if we have already created a label for this object *)
                          labelFromLookup = destinationContainers/.objectContainerLabelRules;

                          (* If we did, use it *)
                          If[StringQ[labelFromLookup],
                            labelFromLookup,
                            (* Otherwise, we need to make our own *)
                            Module[{innerLabelString,newLabel},
                              (* Get the inner label *)
                              innerLabelString = If[MatchQ[population,CustomCoordinates],
                                "",
                                Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                  (* Get the stored index of the population head *)
                                  storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                  (* Increment the counter *)
                                  populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                  (* Store the new value *)
                                  populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                  (* Create the string *)
                                  populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                ]
                              ];

                              (* Create the label *)
                              newLabel = "Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Container Out 1";

                              (* Add it to the lookup *)
                              AppendTo[objectContainerLabelRules, destinationContainers -> newLabel];

                              (* Return the label *)
                              {newLabel}
                            ]
                          ]
                        ]
                      ],

                      (* Otherwise, the destination container must be a list of Object[Container]'s *)
                      True,
                      (* If we were provided a list of container out labels, use them but check its length first. Otherwise create our own labels *)
                      If[MatchQ[containerOutLabel,Except[Automatic]],
                        Module[{},
                          (* If the length of containerOutLabel does not match the number of labels we need to make add to our error list *)
                          If[!MatchQ[Length[ToList[containerOutLabel]], Length[destinationContainers]],
                            AppendTo[containerOutLabelLengthErrors, {mySample, sampleIndex, populationHeadString, Length[ToList[containerOutLabel]], Length[destinationContainers]}]
                          ];

                          (* Return the given labels *)
                          ToList[containerOutLabel]
                        ],
                        (* Otherwise, create/lookup a label for each container *)
                        Map[Function[{container},
                          Module[{labelFromLookup},

                            (* See if we have already created a label for this object *)
                            labelFromLookup = container/.objectContainerLabelRules;

                            (* If we did, use it *)
                            If[StringQ[labelFromLookup],
                              labelFromLookup,
                              (* Otherwise, we need to make our own *)
                              Module[{innerLabelString,newLabel},
                                (* Get the inner label *)
                                innerLabelString = If[MatchQ[population,CustomCoordinates],
                                  "",
                                  Module[{storedPopulationHeadIndex,populationHeadIndexToUse},
                                    (* Get the stored index of the population head *)
                                    storedPopulationHeadIndex = Lookup[populationNumberLookup, populationHeadString, 0];

                                    (* Increment the counter *)
                                    populationHeadIndexToUse = storedPopulationHeadIndex + 1;

                                    (* Store the new value *)
                                    populationNumberLookup[populationHeadString,populationHeadIndexToUse];

                                    (* Create the string *)
                                    populationHeadString <> " Population " <> ToString[populationHeadIndexToUse] <> ", "
                                  ]
                                ];

                                (* Create the label *)
                                newLabel = CreateUniqueLabel["Sample " <> ToString[sampleIndex] <> ", " <> innerLabelString <> "Container Out"];

                                (* Add it to the lookup *)
                                AppendTo[objectContainerLabelRules, container -> newLabel];

                                (* Return the label *)
                                newLabel
                              ]
                            ]
                          ]
                        ],
                          destinationContainers
                        ]
                      ]
                    ]
                  ]
                ]
              }
            ],
            {
              sampleOutLabels,
              containerOutLabels,
              destinationMediaTypes,
              populations,
              destinationMediaContainers,
              sanitizedMaxRows,
              sanitizedMaxCols
            }
          ]
        ]
      ],
      {
        mySamples,
        Lookup[myOptions,SampleOutLabel],
        Lookup[myOptions,ContainerOutLabel],
        resolvedDestinationMediaTypes,
        resolvedPickCoordinates[[All,2]],
        Lookup[partiallyResolvedPickColoniesOptionsWithAnalysis,Populations],
        resolvedDestinationMediaContainers,
        resolvedMaxDestinationNumberOfRows,
        resolvedMaxDestinationNumberOfColumns,
        ToString/@Range[Length[mySamples]]
      }
    ]
  ];

  (* -- MAPTHREAD ERROR MESSAGES -- *)

  (* Labels *)
  (* InvalidSampleOutLabelLength *)
  (* Group the sample out label length errors by sample *)
  invalidSampleOutLabelLengthErrors = Transpose/@Values@GroupBy[sampleOutLabelLengthErrors, First];

  invalidSampleOutLabelLengthOptions = If[Length[invalidSampleOutLabelLengthErrors] > 0 && messages,
    Module[{},
      Message[Error::InvalidSampleOutLabelLength,
        invalidSampleOutLabelLengthErrors[[All,1,1]],
        invalidSampleOutLabelLengthErrors[[All,2,1]],
        invalidSampleOutLabelLengthErrors[[All,3]],
        invalidSampleOutLabelLengthErrors[[All,5]],
        invalidSampleOutLabelLengthErrors[[All,4]]

      ];
      {SampleOutLabel}
    ],
    {}
  ];

  invalidSampleOutLabelLengthTests = If[Length[invalidSampleOutLabelLengthErrors] > 0 && gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidSampleOutLabelLengthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have valid length SamplesOutLabels:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " have valid length SamplesOutLabels:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* InvalidContainerOutLabelLength *)
  (* Group the Container out label length errors by sample *)
  invalidContainerOutLabelLengthErrors = Transpose/@Values@GroupBy[containerOutLabelLengthErrors, First];

  invalidContainerOutLabelLengthOptions = If[Length[invalidContainerOutLabelLengthErrors] > 0 && messages,
    Module[{},
      Message[Error::InvalidContainerOutLabelLength,
        invalidContainerOutLabelLengthErrors[[All,1,1]],
        invalidContainerOutLabelLengthErrors[[All,2,1]],
        invalidContainerOutLabelLengthErrors[[All,3]],
        invalidContainerOutLabelLengthErrors[[All,5]],
        invalidContainerOutLabelLengthErrors[[All,4]]

      ];
      {ContainerOutLabel}
    ],
    {}
  ];

  invalidContainerOutLabelLengthTests = If[Length[invalidContainerOutLabelLengthErrors] > 0 && gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidContainerOutLabelLengthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have valid length ContainersOutLabels:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cache] <> " have valid length ContainersOutLabels:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* Imaging *)
  (* Imaging Option Same Length *)
  imagingOptionSameLengthOptions = If[MemberQ[imagingOptionSameLengthErrors, True] && messages,
    Message[Error::ImagingOptionMismatch, PickList[mySamples, imagingOptionSameLengthErrors]];
    {ImagingChannels, ExposureTimes},
    {}
  ];

  imagingOptionSameLengthTests = If[MemberQ[imagingOptionSameLengthErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, imagingOptionSameLengthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> combinedCache] <> " have the same length:", True, True];

      (* Create the failing test *)
      failingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> combinedCache] <> " have the same length:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Missing imaging channels *)
  missingImagingStrategiesOptions = If[MemberQ[missingImagingStrategiesInfos, Except[{}]] && messages,
    Message[Error::MissingImagingStrategies,
      ObjectToString[PickList[mySamples, missingImagingStrategiesInfos, Except[{}]], Cache -> combinedCache],
      Cases[missingImagingStrategiesInfos, Except[{}]],
      Which[
        (* If it contains both, we include both clauses *)
        MemberQ[Flatten[missingImagingStrategiesInfos], BlueWhiteScreen] && MemberQ[Flatten[missingImagingStrategiesInfos], VioletFluorescence|GreenFluorescence|OrangeFluorescence|RedFluorescence|DarkRedFluorescence],
        "ImagingStrategies must include the BlueWhiteScreen along with BrightField because Populations is set to include BlueWhiteScreen. Additionally, because Populations is set to include fluorescent excitation and emission pairs, their corresponding fluorescence strategies must be included",
        MemberQ[Flatten[missingImagingStrategiesInfos], BlueWhiteScreen],
        "ImagingStrategies must include the BlueWhiteScreen along with BrightField because Populations is set to include BlueWhiteScreen",
        (* missingImagingStrategyInfos includes a fluroescence one *)
        True,
        "The fluorescence strategy must be included along with BrightField because Populations is set to include the corresponding fluorescent excitation and emission pairs"
      ]
    ];
    {ImagingStrategies},
    {}
  ];

  missingImagingStrategiesTests = If[MemberQ[missingImagingStrategiesInfos, Except[{}]] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, missingImagingStrategiesInfos, Except[{}]];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> combinedCache] <> " do not have imaging strategies required in Populations that are not listed in ImagingStrategies:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> combinedCache] <> " do not have imaging strategies required in Populations that are not listed in ImagingStrategies:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Invalid DestinationMedia State *)
  destinationMediaStateOptions = If[MemberQ[destinationMediaStateErrors,True]&&messages,
    Message[
      Error::InvalidDestinationMediaState,
      ObjectToString[PickList[mySamples,destinationMediaStateErrors],Cache->cache,Simulation->simulation],
      Which[
        MatchQ[Flatten@PickList[resolvedDestinationMediaTypes,destinationMediaStateErrors],{LiquidMedia..}],"Liquid",
        MatchQ[Flatten@PickList[resolvedDestinationMediaTypes,destinationMediaStateErrors],{SolidMedia..}],"Solid",
        True,"Liquid or Solid"
      ]
    ];
    {DestinationMedia},
    {}
  ];

  destinationMediaStateTests = If[MemberQ[destinationMediaStateErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,destinationMediaStateErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a specified DestinationMedia that has a state of Solid or Liquid:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a specified DestinationMedia that has a state of Solid or Liquid:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* DestinationMediaTypeMismatch *)
  destinationMediaTypeMismatchOptions = If[MemberQ[destinationMediaTypeMismatchErrors,True]&&messages,
    Message[Error::DestinationMediaTypeMismatch, PickList[mySamples,destinationMediaTypeMismatchErrors]];
    {DestinationMediaType,DestinationMedia},
    {}
  ];

  destinationMediaTypeMismatchTests = If[MemberQ[destinationMediaTypeMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,destinationMediaTypeMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " DestinationMedia State matches DestinationMediaType:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " DestinationMedia State matches DestinationMediaType:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* Invalid Destination Media Container *)
  invalidDestinationMediaContainerOptions = If[MemberQ[invalidDestinationMediaContainerErrors,True]&&messages,
    Message[Error::InvalidDestinationMediaContainer, PickList[mySamples,invalidDestinationMediaContainerErrors]];
    {DestinationMediaContainer},
    {}
  ];

  invalidDestinationMediaContainerTests = If[MemberQ[invalidDestinationMediaContainerErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidDestinationMediaContainerErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a valid DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a valid DestinationMediaContainer:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* TooManyDestinationMediaContainers *)
  tooManyDestinationMediaContainersOptions = If[MemberQ[tooManyDestinationMediaContainersErrors,True]&&messages,
    Message[Error::TooManyDestinationMediaContainers, PickList[mySamples,tooManyDestinationMediaContainersErrors]];
    {DestinationMediaContainer},
    {}
  ];

  tooManyDestinationMediaContainersTests = If[MemberQ[tooManyDestinationMediaContainersErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,tooManyDestinationMediaContainersErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have less than 6 unique DestinationMediaContainers specified:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have less than 6 unique DestinationMediaContainers specified:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* TooManyPickCoordinatesError *)
  tooManyPickCoordinatesOptions = If[MemberQ[tooManyPickCoordinatesErrors,True]&&messages,
    Message[Error::TooManyPickCoordinates, PickList[mySamples,tooManyPickCoordinatesErrors]];
    {PickCoordinates},
    {}
  ];

  tooManyPickCoordinatesTests = If[MemberQ[tooManyPickCoordinatesErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,tooManyPickCoordinatesErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have more specified PickCoordinates than there are deposit locations in DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have more specified PickCoordinates than there are deposit locations in DestinationMediaContainer:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* DestinationFillDirectionMismatch *)
  destinationFillDirectionMismatchOptions = If[MemberQ[destinationFillDirectionMismatchErrors,True]&&messages,
    Message[Error::DestinationFillDirectionMismatch, PickList[mySamples,destinationFillDirectionMismatchErrors]];
    {DestinationFillDirection,MaxDestinationNumberOfRows,MaxDestinationNumberOfColumns},
    {}
  ];

  destinationFillDirectionMismatchTests = If[MemberQ[destinationFillDirectionMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,destinationFillDirectionMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have Null MaxDestinationNumberOfRows and MaxDestinationNumberOfColumns if DestinationFillDirection is CustomCoordinates:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have Null MaxDestinationNumberOfRows and MaxDestinationNumberOfColumns if DestinationFillDirection is CustomCoordinates:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* missingDestinationCoordinates *)
  missingDestinationCoordinatesOptions = If[MemberQ[missingDestinationCoordinatesErrors,True]&&messages,
    Message[Error::MissingDestinationCoordinates, PickList[mySamples,missingDestinationCoordinatesErrors]];
    {DestinationFillDirection,DestinationCoordinates},
    {}
  ];

  missingDestinationCoordinatesTests = If[MemberQ[missingDestinationCoordinatesErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,missingDestinationCoordinatesErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have DestinationCoordinates specified if DestinationFillDirection->CustomCoordinates:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have DestinationCoordinates specified if DestinationFillDirection->CustomCoordinates:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* TooManyDestinationCoordinates *)
  If[MemberQ[tooManyDestinationCoordinatesWarnings,True]&&messages,
    Message[Warning::TooManyDestinationCoordinates, PickList[mySamples,tooManyDestinationCoordinatesWarnings]];
    {DestinationCoordinates},
    {}
  ];

  tooManyDestinationCoordinatesTests = If[MemberQ[tooManyDestinationCoordinatesWarnings,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,tooManyDestinationCoordinatesWarnings];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have specified less than 384 DestinationCoordinates:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have specified less than 384 DestinationCoordinates:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* destinationMixMismatch *)
  destinationMixMismatchOptions = If[MemberQ[destinationMixMismatchErrors,True]&&messages,
    Message[
      Error::DestinationMixMismatch,
      ObjectToString[PickList[mySamples, destinationMixMismatchErrors], Cache -> cache, Simulation -> simulation],
      "DestinationNumberOfMixes"
    ];
    {DestinationMix,DestinationNumberOfMixes},
    {}
  ];

  destinationMixMismatchTests = If[MemberQ[destinationMixMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,destinationMixMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have both or neither destination mix options specified:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have both or neither destination mix options specified:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* invalidMixOption *)
  invalidMixOptionOptions = If[MemberQ[invalidMixOptionErrors,True]&&messages,
    Message[Error::InvalidMixOption, PickList[mySamples,invalidMixOptionErrors]];
    {DestinationMix,DestinationNumberOfMixes},
    {}
  ];

  invalidMixOptionTests = If[MemberQ[invalidMixOptionErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidMixOptionErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have destination mix options set if DestinationMediaType->SolidMedia:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " do not have destination mix options set if DestinationMediaType->SolidMedia:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* pickingToolIncompatibleWithDestinationMediaContainer *)
  pickingToolIncompatibleWithDestinationMediaContainerOptions = If[MemberQ[pickingToolIncompatibleWithDestinationMediaContainerErrors,True]&&messages,
    Message[Error::PickingToolIncompatibleWithDestinationMediaContainer, PickList[mySamples,pickingToolIncompatibleWithDestinationMediaContainerErrors]];
    {ColonyPickingTool,DestinationMediaContainer},
    {}
  ];

  pickingToolIncompatibleWithDestinationMediaContainerTests = If[MemberQ[pickingToolIncompatibleWithDestinationMediaContainerErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,pickingToolIncompatibleWithDestinationMediaContainerErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingTool that is compatible with the DestinationMediaContainers:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingTool that is compatible with the DestinationMediaContainers:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* noAvailablePickingTool *)
  noAvailablePickingToolOptions = If[MemberQ[noAvailablePickingToolErrors,True]&&messages,
    Message[Error::NoAvailablePickingTool, PickList[mySamples,noAvailablePickingToolErrors]];
    {DestinationMediaContainer},
    {}
  ];

  noAvailablePickingToolTests = If[MemberQ[noAvailablePickingToolErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,noAvailablePickingToolErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a valid picking tool:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a valid picking tool:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* NotPreferredColonyHandlerHead *)
  If[MemberQ[notPreferredColonyHandlerHeadWarnings,True]&&messages,
    Message[Warning::NotPreferredColonyHandlerHead, PickList[mySamples,notPreferredColonyHandlerHeadWarnings]]
  ];

  notPreferredColonyHandlerHeadTests = If[MemberQ[notPreferredColonyHandlerHeadWarnings,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,notPreferredColonyHandlerHeadWarnings];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingTool that is preferred for their contained colonies:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingTool that is preferred for their contained colonies:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* HeadDiameterMismatch *)
  headDiameterMismatchOptions = If[MemberQ[headDiameterMismatchErrors,True]&&messages,
    Message[Error::HeadDiameterMismatch, PickList[mySamples,headDiameterMismatchErrors]];
    {ColonyPickingTool,HeadDiameter},
    {}
  ];

  headDiameterMismatchTests = If[MemberQ[headDiameterMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,headDiameterMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the HeadDiameter matches the HeadDiameter field of the ColonyPickingTool:",True,True];

      (* Create the failing test *)
      failingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the HeadDiameter matches the HeadDiameter field of the ColonyPickingTool:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* HeadLengthMismatch *)
  headLengthMismatchOptions = If[MemberQ[headLengthMismatchErrors,True]&&messages,
    Message[Error::HeadLengthMismatch, PickList[mySamples,headLengthMismatchErrors]];
    {ColonyPickingTool,HeadLength},
    {}
  ];

  headLengthMismatchTests = If[MemberQ[headLengthMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,headLengthMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the HeadLength matches the HeadLength field of the ColonyPickingTool:",True,True];

      (* Create the failing test *)
      failingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the HeadLength matches the HeadLength field of the ColonyPickingTool:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* NumberOfHeadsMismatch *)
  numberOfHeadsMismatchOptions = If[MemberQ[numberOfHeadsMismatchErrors,True]&&messages,
    Message[Error::NumberOfHeadsMismatch, PickList[mySamples,numberOfHeadsMismatchErrors]];
    {ColonyPickingTool,NumberOfHeads},
    {}
  ];

  numberOfHeadsMismatchTests = If[MemberQ[numberOfHeadsMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,numberOfHeadsMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the NumberOfHeads matches the NumberOfHeads field of the ColonyPickingTool:",True,True];

      (* Create the failing test *)
      failingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the NumberOfHeads matches the NumberOfHeads field of the ColonyPickingTool:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* ColonyHandlerHeadCassetteApplicationMismatch *)
  colonyHandlerHeadCassetteApplicationMismatchOptions = If[MemberQ[colonyHandlerHeadCassetteApplicationMismatchErrors,True]&&messages,
    Message[Error::ColonyHandlerHeadCassetteApplicationMismatch, PickList[mySamples,colonyHandlerHeadCassetteApplicationMismatchErrors]];
    {ColonyPickingTool,ColonyHandlerHeadCassetteApplication},
    {}
  ];

  colonyHandlerHeadCassetteApplicationMismatchTests = If[MemberQ[colonyHandlerHeadCassetteApplicationMismatchErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,colonyHandlerHeadCassetteApplicationMismatchErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the ColonyHandlerHeadCassetteApplication matches the Application field of the ColonyPickingTool:",True,True];

      (* Create the failing test *)
      failingTest = Test["For the input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " the ColonyHandlerHeadCassetteApplication matches the Application field of the ColonyPickingTool:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];

  (* InvalidColonyPickingDepths *)
  invalidColonyPickingDepthOptions = If[MemberQ[invalidColonyPickingDepthErrors,True]&&messages,
    Message[Error::InvalidColonyPickingDepths, PickList[mySamples,invalidColonyPickingDepthErrors]];
    {ColonyPickingTool,HeadDiameter},
    {}
  ];

  invalidColonyPickingDepthTests = If[MemberQ[invalidColonyPickingDepthErrors,True]&&gatherTests,
    Module[{passingInputs,failingInputs,passingTest,failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples,invalidColonyPickingDepthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples,failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingDepth that is valid for the DestinationMediaContainer:",True,True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cache] <> " have a ColonyPickingDepth that is valid for the DestinationMediaContainer:",True, False];

      (* Return the tests *)
      {passingTest,failingTest}
    ],
    Nothing
  ];


  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions, Living -> True];

  (* TODO: Add error checking for sampleOutLabel and ContainerOutLabel *)

  (*-- UNRESOLVABLE OPTION CHECKS --*)

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[
    {
      compatibleMaterialsTests,
      discardedInvalidInputs,
      nonSolidInvalidInputs,
      nonOmniTrayInvalidInputs,
      tooManyContainersInvalidInputs,
      duplicatedInvalidInputs,
      sanitizationOptionInvalidInputs
    }
  ]];

  invalidOptions = DeleteDuplicates[Flatten[
    {
      If[!MemberQ[compatibleMaterialsBools, True],
        {Instrument},
        {}
      ],
      sanitizationOptionInvalidOptions,
      analysisOptionInvalidOptions,
      invalidContainerOutLabelLengthOptions,
      invalidSampleOutLabelLengthOptions,
      missingImagingStrategiesOptions,
      imagingOptionSameLengthOptions,
      destinationMediaStateOptions,
      destinationMediaTypeMismatchOptions,
      tooManyDestinationMediaContainersOptions,
      tooManyPickCoordinatesOptions,
      invalidDestinationMediaContainerOptions,
      destinationFillDirectionMismatchOptions,
      missingDestinationCoordinatesOptions,
      destinationMixMismatchOptions,
      invalidMixOptionOptions,
      pickingToolIncompatibleWithDestinationMediaContainerOptions,
      noAvailablePickingToolOptions,
      headDiameterMismatchOptions,
      headLengthMismatchOptions,
      numberOfHeadsMismatchOptions,
      colonyHandlerHeadCassetteApplicationMismatchOptions,
      invalidColonyPickingDepthOptions,
      (* For experiments that the developer marks the post processing samples as Living -> True, we need to add potential failing options to invalidOptions list in order to properly fail the resolver *)
      If[MemberQ[Values[resolvedPostProcessingOptions], $Failed],
        PickList[Keys[resolvedPostProcessingOptions], Values[resolvedPostProcessingOptions], $Failed],
        Nothing]
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs] >0 && !gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> combinedCache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0 &&! gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];


  (* Put options in returnable form *)
  resolvedOptions = {
    Instrument -> resolvedInstrument,
    ColonyPickingTool -> resolvedColonyPickingTools,
    HeadDiameter -> resolvedHeadDiameters,
    HeadLength -> resolvedHeadLengths,
    NumberOfHeads -> resolvedNumberOfHeads,
    ColonyHandlerHeadCassetteApplication -> resolvedColonyHandlerHeadCassetteApplications,
    ColonyPickingDepth -> resolvedColonyPickingDepths,
    PickCoordinates -> resolvedPickCoordinates[[All, 2]],
    ImagingStrategies -> resolvedImagingStrategies,
    ImagingChannels -> resolvedImagingChannels,
    ExposureTimes -> resolvedExposureTimes,
    DestinationMediaType -> resolvedDestinationMediaTypes,
    DestinationMedia -> resolvedDestinationMedia,
    DestinationMediaContainer -> resolvedDestinationMediaContainers,
    DestinationFillDirection -> resolvedDestinationFillDirection,
    MaxDestinationNumberOfColumns -> resolvedMaxDestinationNumberOfColumns,
    MaxDestinationNumberOfRows -> resolvedMaxDestinationNumberOfRows,
    DestinationCoordinates -> resolvedDestinationCoordinates,
    MediaVolume -> resolvedMediaVolumes,
    DestinationMix -> resolvedDestinationMixes,
    DestinationNumberOfMixes -> resolvedDestinationNumberOfMixes,
    Preparation -> resolvedPreparation,
    WorkCell -> resolvedWorkCell,
    SamplesInStorageCondition -> resolvedSamplesInStorageCondition,
    SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
    SampleOutLabel -> resolvedSampleOutLabels,
    ContainerOutLabel -> resolvedContainerOutLabels
  };

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> Flatten[{
      resolvedOptions,
      resolvedSanitizationOptions,
      resolvedAnalysisOptions,
      resolvedPostProcessingOptions
    }],

    Tests -> Flatten[{
      discardedTest,
      nonSolidTest,
      nonOmniTrayTest,
      duplicatesTest,
      tooManyInputContainersTest,
      optionPrecisionTests,
      sanitizationOptionTests,
      analysisOptionTests,
      invalidContainerOutLabelLengthTests,
      invalidSampleOutLabelLengthTests,
      missingImagingStrategiesTests,
      imagingOptionSameLengthTests,
      destinationMediaStateTests,
      destinationMediaTypeMismatchTests,
      invalidDestinationMediaContainerTests,
      tooManyDestinationMediaContainersTests,
      tooManyPickCoordinatesTests,
      destinationFillDirectionMismatchTests,
      missingDestinationCoordinatesTests,
      tooManyDestinationCoordinatesTests,
      destinationMixMismatchTests,
      invalidMixOptionTests,
      pickingToolIncompatibleWithDestinationMediaContainerTests,
      noAvailablePickingToolTests,
      notPreferredColonyHandlerHeadTests,
      headDiameterMismatchTests,
      headLengthMismatchTests,
      numberOfHeadsMismatchTests,
      colonyHandlerHeadCassetteApplicationMismatchTests,
      invalidColonyPickingDepthTests,
      compatibleMaterialsTests,
      If[gatherTests,
        postProcessingTests[resolvedPostProcessingOptions],
        Nothing
      ]
    }]
  }
];


(* ::Subsection:: *)
(*Resource Packets*)
DefineOptions[pickColoniesResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

pickColoniesResourcePackets[
  mySamples:{ObjectP[Object[Sample]]..},
  myUnresolvedOptions:{_Rule...},
  myResolvedOptions:{_Rule...},
  experimentFunction: Alternatives[ExperimentPickColonies, ExperimentInoculateLiquidMedia],
  ops:OptionsPattern[pickColoniesResourcePackets]
] := Module[
  {
    unresolvedOptionsNoHidden, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, inheritedCache,
    simulation, resolvedPreparation, instrument, populations, colonyPickingTools, pickCoordinates, destinationMediaTypes,
    destinationMedia, destinationMediaContainers, destinationFillDirection, maxDestinationNumberOfRows,
    maxDestinationNumberOfColumns, mediaVolumes, primaryWashSolutions, secondaryWashSolutions, tertiaryWashSolutions,
    quaternaryWashSolutions, samplesOutStorageConditions, resolvedImagingStrategies,
    resolvedImagingChannels, resolvedExposureTimes, destinationMediaContainersObjectPackets, destinationMediaContainersModelPackets,
    fastAssoc, runTime, instrumentResource, samplesInResourceReplaceRules, samplesInResources, colonyPickingToolObjectPackets,
    colonyPickingToolResources, uniqueWashSolutions, uniqueWashSolutionVolumes, washSolutionsAndVolumes,
    washSolutionResourceLookup, primaryWashSolutionResources, secondaryWashSolutionResources, tertiaryWashSolutionResources,
    quaternaryWashSolutionResources, flatAllPopulations, opticalFilterResource, objectContainerNumAvailablePositionsLookup,
    objectContainerToReservationsLookup, updatedObjectContainerReservations, modelContainerReservations, filledObjectContainers,
    modelContainerLabelMapping, wellsToPopulatePerSample, labelContainerPrimitive, transferTuples, transferTuplesFlattened,
    transferPrimitive, allDestinationContainersFlat, modelContainerPositionLabelMap, uniqueImagingStrategies, uniqueImagingChannels,
    uniqueExposureTimes, updatedResolvedOptions, splitOptionPackets, sampleInfoPackets,
    unitOpGroupedByColonyHandlerHeadCassette,finalPhysicalGroups,carrierDeckPlateLocations,riserPlacements,carrierPlacements,
    riserReturns,carrierReturns,initialCarrierAndRiserResourcesToPick,colonyHandlerHeadCassettePlacements,colonyHandlerHeadCassetteRemovals,
    flatLightTableContainersPerPhysicalBatch, flatLightTableContainerPlacementsPerPhysicalBatch,lightTableContainerLengthsPerPhysicalBatch,
    carrierContainerDeckPlacements, batchedUnitOperationPackets, batchedUnitOperationPacketsWithID, outputUnitOperationPacket,
    allModelsAndLabels,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,allResourceBlobs,fulfillable,frqTests,
    previewRule,optionsRule,resultRule,testsRule,currentSimulation,
    colonyPickingToolResourceReplaceRules
  },

  (* Get the collapsed unresolved index-matching options that don't include hidden options *)
  unresolvedOptionsNoHidden = RemoveHiddenOptions[experimentFunction, myUnresolvedOptions];

  (* Get the collapsed resolved index-matching options that don't include hidden options *)
  (* Ignore to collapse those options that are set in expandedsafeoptions *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    experimentFunction,
    RemoveHiddenOptions[experimentFunction, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* Determine the requested output format of this function *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Get the inherited cache *)
  inheritedCache = Lookup[ToList[ops], Cache, {}];
  simulation = Lookup[ToList[ops], Simulation, {}];

  (* Initialize the simulation if it does not exist *)
  currentSimulation = If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Get the resolved preparation scale *)
  resolvedPreparation = Lookup[myResolvedOptions, Preparation];

  (* Extract necessary resolved options *)
  {
    instrument,
    populations,
    colonyPickingTools,
    pickCoordinates,
    destinationMediaTypes,
    destinationMedia,
    destinationMediaContainers,
    destinationFillDirection,
    maxDestinationNumberOfRows,
    maxDestinationNumberOfColumns,
    mediaVolumes,
    primaryWashSolutions,
    secondaryWashSolutions,
    tertiaryWashSolutions,
    quaternaryWashSolutions,
    samplesOutStorageConditions,
    resolvedImagingStrategies,
    resolvedImagingChannels,
    resolvedExposureTimes
  } = Lookup[myResolvedOptions,
    {
      Instrument,
      Populations,
      ColonyPickingTool,
      PickCoordinates,
      DestinationMediaType,
      DestinationMedia,
      DestinationMediaContainer,
      DestinationFillDirection,
      MaxDestinationNumberOfRows,
      MaxDestinationNumberOfColumns,
      MediaVolume,
      PrimaryWashSolution,
      SecondaryWashSolution,
      TertiaryWashSolution,
      QuaternaryWashSolution,
      SamplesOutStorageCondition,
      ImagingStrategies,
      ImagingChannels,
      ExposureTimes
    }
  ];

  (* Note:We are replacing index-matching Instrument from InoculateLiquidMedia to non-index matching instrument here *)
  instrument = If[MatchQ[experimentFunction, ExperimentInoculateLiquidMedia],
    FirstCase[instrument, ObjectP[{Model[Instrument], Object[Instrument]}]],
    instrument
  ];

  (* If the experiment type is Inoculate, we need to define destinationMediaTypes on our own as it is not an option of that experiment *)
  destinationMediaTypes = If[MatchQ[experimentFunction, ExperimentInoculateLiquidMedia],
    Map[LiquidMedia &, populations, {2}],
    destinationMediaTypes
  ];

  (* Download information from our destination containers *)
  (* Split the destination media containers into models and objects *)
  {
    destinationMediaContainersObjectPackets,
    destinationMediaContainersModelPackets,
    colonyPickingToolObjectPackets(*if its a model, it does not have holder info and we dont need it*)
  } = Quiet[Download[
    {
      Cases[Flatten@destinationMediaContainers, ListableP[ObjectP[Object[Container]]]],
      Cases[Flatten@destinationMediaContainers, ObjectP[Model[Container]]],
      Cases[colonyPickingTools, ObjectP[Object[Part]]]
    },
    {
      {
        Packet[Model, Contents],
        Packet[Model[Positions, MaxVolume, NumberOfWells, WellDepth]]
      },
      {
        Packet[Positions, MaxVolume, NumberOfWells, WellDepth]
      },
      {
        Packet[ColonyHandlerHeadCassetteHolder]
      }
    }
  ], {Download::FieldDoesntExist}];

  (* Make a fast assoc from the packets *)
  fastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{
    destinationMediaContainersObjectPackets,
    destinationMediaContainersModelPackets,
    colonyPickingToolObjectPackets
  }]];

  (* -- Generate the Instrument Resource -- *)
  (* Calculate the runTime of the experiment *)
  runTime = 30 Minute*Length[mySamples];
  instrumentResource = Resource[Instrument -> instrument, Time -> runTime];

  (*--Generate the samples in resources--*)

  (* Our input samples are Solid (Guaranteed by the resolver) - just create a unique resource for each unique object *)
  samplesInResourceReplaceRules = (# -> Resource[Sample -> #, Name -> CreateUUID[]])& /@ DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources = mySamples /. samplesInResourceReplaceRules;

  (* Create a resource for the ColonyPickingTool *)
  colonyPickingToolResourceReplaceRules = (# -> Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]])&/@DeleteDuplicates[Download[colonyPickingTools,Object]];
  colonyPickingToolResources = colonyPickingTools /. colonyPickingToolResourceReplaceRules;

  (* -- Create a resource for each unique wash solution -- *)
  (* Get the unique wash solutions *)
  uniqueWashSolutions = Download[DeleteDuplicates[Join[primaryWashSolutions, secondaryWashSolutions, tertiaryWashSolutions, quaternaryWashSolutions]]/.Null -> Nothing, Object];

  (* For each wash solution, we need 150 mLs *)
  uniqueWashSolutionVolumes = ConstantArray[150 Milliliter, Length[uniqueWashSolutions]];

  (* Combine the wash solutions and volumes *)
  washSolutionsAndVolumes = MapThread[Rule, {uniqueWashSolutions, uniqueWashSolutionVolumes}];

  (* Create a lookup of Sample -> Resource *)
  washSolutionResourceLookup = Map[
    Function[{solutionVolumeRule},
      Module[{sample, volume},
        (* Split the tuple into sample and volume *)
        sample = First[solutionVolumeRule];
        volume = Last[solutionVolumeRule];

        (* Create the proper resource based on whether we have an object or a model *)
        If[MatchQ[sample, ObjectP[Object[Sample]]],
          sample -> Resource[Sample -> sample, Name -> CreateUUID[]],
          sample -> Resource[Sample -> sample, Amount -> volume, Container -> First[ToList@PreferredContainer[sample, volume]], RentContainer -> True, Name -> CreateUUID[]]
        ]
      ]
    ],
    washSolutionsAndVolumes
  ];
  
  (* Use the lookup to assign resources  *)
  primaryWashSolutionResources = primaryWashSolutions /. washSolutionResourceLookup;
  secondaryWashSolutionResources = secondaryWashSolutions /. washSolutionResourceLookup;
  tertiaryWashSolutionResources = tertiaryWashSolutions /. washSolutionResourceLookup;
  quaternaryWashSolutionResources = quaternaryWashSolutions /. washSolutionResourceLookup;

  (* Make a resource for the absorbance filter if needed *)
  (* We need to make this resource if any of the populations for any of our samples are Absorbance or have Absorbance in the Feature key of a MultiFeatured primitive *)
  (* First, get a flat list of all of the populations *)
  flatAllPopulations = Flatten[populations];

  (* If we need to do blue-white screening(Absorbance), create the filter resource. *)
  opticalFilterResource = If[MemberQ[Flatten@resolvedImagingChannels, 400 Nanometer],
    Resource[Sample -> Model[Part, OpticalFilter, "id:aXRlGnRvl8K9"], Rent -> True](*"QPix Chroma Filter"*)
  ];

  (* We need to make sure there is media in all of the destination locations *)
  (* Instead of specifying specific wells, we use the options maxDestinationNumberOfRows and maxDestinationNumberOfColumns *)
  (* to limit which wells in a plate we should fill. *)
  (* Because we cannot do resource requests for samples in specific wells, yet, these transfers will be done through a Transfer Primitive *)

  (* TODO: Copy this down to the simulation function in the case the option resolver failed *)
  (* Write a helper function to restrict wells based on number of rows and columns *)
  (* NOTE: This function will have to be updated to handle 384 well plates when the time comes *)
  restrictWells[
    wellList: {_String..},
    rows_Integer,
    cols_Integer
  ] := Module[{rowMapping,rowRestricted},

    (* Define a mapping from numerical rows to alphabetical rows *)
    rowMapping = {
      1 -> Alternatives["A"],
      2 -> Alternatives["A","B"],
      3 -> Alternatives["A","B","C"],
      4 -> Alternatives["A","B","C","D"],
      5 -> Alternatives["A","B","C","D","E"],
      6 -> Alternatives["A","B","C","D","E","F"],
      7 -> Alternatives["A","B","C","D","E","F","G"],
      8 -> Alternatives["A","B","C","D","E","F","G","H"],
      _ -> Alternatives["A","B","C","D","E","F","G","H"]
    };

    (* Restrict based on rows *)
    rowRestricted = Select[wellList, StringStartsQ[#,rows/.rowMapping]&];

    (* Restrict based on columns *)
    Select[wellList, MemberQ[ToString/@Range[cols],StringRest[#]]&]
  ];

  (* NOTE: Much of this logic is taken from the SampleOutLabel Resolution from the option resolver. If the logic here changes *)
  (* make sure to check there as well *)
  (* General Explanation/outline of creating the transfer primitive: *)
  (* The number of transfers created relies on many factors including *)
  (* NestedIndexMatchingOptions: DestinationMediaType, DestinationMediaContainer, DestinationMaxNumberOfRows, DestinationMaxNumberOfColumns, Populations *)
  (* and IndexMatching options: PickCoordinates *)
  (* The biggest determining factors on how many transfers are created are the DestinationMediaType and how the DestinationMediaContainer is specified *)
  (* If, for a particular population, DestinationMediaType -> SolidMedia then we just need to make as many transfers as there are Object[Container]'s *)
  (* or up to 6 transfers if it is specified as a Model[Container]. This is because all of the picked colonies go into the single well of the destination container *)
  (* If, for a particular population DestinationMediaType -> LiquidMedia, then we have to case on how DestinationMediaContainer is specified. *)
  (* If it is specified as a Model[Container], we have up to 6 plates of that model to work with. *)
  (*     1. Figure out the max number of colonies that we could possibly pick (either from the population, or via pick coordinates) *)
  (*     2. Determine the number of possible wells in the container from its model and MaxDestinationNumRows/Cols *)
  (*     3. Create the transfers *)
  (*     NOTE: If the max number of colonies is specified as All (either through the NumberOfColonies option in a Population primitive or through the AllColonies primitive) *)
  (*           6 plates will always be created. If the max number of colonies is known, we will limit the plates to the number necessary to fit all of the colonies (1 per well) *)
  (* If it is specified as an Object[Container] or {Object[Container]..}, we have to take into account that different populations across different samples *)
  (* could be trying to place picked colonies into the object. Thus we use a reservation system that prioritizes populations that don't specify the number of colonies as 'All' *)
  (*     1. Create a lookup where each key is an Object[Container] and the value is a list that contains populations and the number of wells that population needs in that container *)
  (*     2. We prioritize populations that specify a specific number of colonies. So next, we go through and update these 'lists of reservations' and translate *)
  (*        any 'All's into actual numbers. The number of reservations specified through numbers (not all) is subtracted from *)
  (*        the total number of possible wells for that container (calculated same way as in the model case). Then any remaining spots are distributed evenly among *)
  (*        any populations that have 'All' reservations *)
  (* NOTE: doing the reservations in this manner helps prevent disconnects later on if the number of colonies expected to pick is not the same as the number that actually grew on the plate *)

  (* This is for convenience so we don't have to do this calculation over and over later on *)
  (* Create a lookup mapping each Object[Container] to the total number of available positions Min[numberOfWells, maxRows * maxCols] *)
  objectContainerNumAvailablePositionsLookup = Merge[Association/@Flatten@MapThread[
    Function[{destinationMediaContainers, allMaxRows, allMaxCols},
      Module[{sanitizedMaxRows,sanitizedMaxCols},
        (* Sanitize max rows and max cols *)
        sanitizedMaxRows = allMaxRows /. {Automatic -> 8, Null -> 16};
        sanitizedMaxCols = allMaxCols /. {Automatic -> 12, Null -> 24};

        (* Loop again per population *)
        MapThread[
          Function[{destinationContainers, maxRows, maxCols},
            (* Switch on the value of the destination container *)
            Which[
              MatchQ[destinationContainers,ObjectP[Model[Container]]],
              Nothing,
              MatchQ[destinationContainers,ObjectP[Object[Container]]],
              destinationContainers -> Min[fastAssocLookup[fastAssoc, destinationContainers, {Model,NumberOfWells}], maxRows * maxCols],
              True,
              Map[Function[{container},
                container -> Min[fastAssocLookup[fastAssoc, container, {Model,NumberOfWells}], maxRows * maxCols]
              ],
                destinationContainers
              ]
            ]
          ],
          {
            destinationMediaContainers,
            sanitizedMaxRows,
            sanitizedMaxCols
          }
        ]
      ]
    ],
    {
      destinationMediaContainers,
      maxDestinationNumberOfRows,
      maxDestinationNumberOfColumns
    }
  ],Min];

  (* The first step in resolving the sample out labels is to make a first pass through the populations/pick coordinates and destination media containers *)
  (* in order to determine if any populations will be placed in the same Object[Container] *)
  (* This will be done by creating a lookup of the structure Object[Container] -> {{sample, population, numberOfSpotsToReserve in the container}..} *)
  objectContainerToReservationsLookup = <||>;

  (* Loop over the values per sample to create the lookup *)
  MapThread[
    Function[{mySample,destinationMediaTypes,pickCoordinates,populations,destinationMediaContainers},
      MapThread[
        Function[{destinationMediaType,population,destinationContainers},
          Which[
            (* We can skip if the destination container is a Model[Container] or if destinationMediaType is SolidMedia. *)
            (* For Models we will always make a new set of containers per population so they don't need to be kept track of in the same way *)
            (* SolidMedia destinations always only have 1 sample, so once again they don't need to be kept track of in this manner *)
            MatchQ[destinationContainers,ObjectP[Model[Container]]] || MatchQ[destinationMediaType, SolidMedia],
            Null,

            (* TODO: Change it to combine the last to cases into 1 case (just always wrap a list around the single object case) *)
            (* If we have a liquid media destination and specified object container, mark it down *)
            MatchQ[destinationContainers, ObjectP[Object[Container]]],
            Module[
              {
                existingReservationList,totalNumberOfReservationsSoFar,totalReservationsPossible,
                numberOfSpotsToTryToReserve,numberOfSpotsToReserve,newReservationList
              },

              (* Get the value from the lookup if one exists for this object *)
              existingReservationList = Lookup[objectContainerToReservationsLookup, destinationContainers, {}];

              (* Total all non "All" values in the existing reservation list *)
              totalNumberOfReservationsSoFar = Total[existingReservationList[[All,3]]/.{All -> 0}];

              (* Get the total number of reservations possible in the container *)
              totalReservationsPossible = Lookup[objectContainerNumAvailablePositionsLookup, destinationContainers, 0];

              (* Determine the number of spots that need to be reserved for this population in this container *)
              numberOfSpotsToTryToReserve = If[MatchQ[population,CustomCoordinates],
                Length[pickCoordinates],
                Module[{populationAssociation,populationHead},

                  (* Get the population primitive in association form *)
                  populationAssociation = population[[1]];

                  (* Get the head of the population *)
                  populationHead = Head[population];

                  (* Extract the value from the population *)
                  If[MatchQ[populationHead,AllColonies],
                    All,
                    Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                  ]
                ]
              ];

              (* Determine the actual number of spots to reserve *)
              numberOfSpotsToReserve = If[MatchQ[numberOfSpotsToTryToReserve, All],
                numberOfSpotsToTryToReserve,
                Min[totalReservationsPossible - totalNumberOfReservationsSoFar, numberOfSpotsToTryToReserve]
              ];

              (* Add an entry to the end of the list *)
              newReservationList = Append[existingReservationList,{mySample, population, numberOfSpotsToReserve}];

              (* Update the lookup *)
              objectContainerToReservationsLookup[destinationContainers] = newReservationList;
            ],

            (* Otherwise, we have a liquid media destination and a list of object containers *)
            True,
            Module[{numberOfSpotsLeftToReserve},
              (* Get the number of spots to reserve over these containers *)
              (* NOTE: this variable will be iterated on as we go through the destination containers *)
              numberOfSpotsLeftToReserve = If[MatchQ[population,CustomCoordinates],
                Length[pickCoordinates],
                Module[{populationAssociation,populationHead},

                  (* Get the population primitive in association form *)
                  populationAssociation = population[[1]];

                  (* Get the head of the population *)
                  populationHead = Head[population];

                  If[MatchQ[populationHead,AllColonies],
                    All,
                    Lookup[populationAssociation,NumberOfColonies,Automatic]/. Automatic -> 10
                  ]
                ]
              ];

              (* Loop over our list of object containers and add them to the main lookup accordingly *)
              Map[Function[{container},
                Module[
                  {
                    existingReservationList,totalNumberOfReservationsSoFar,totalReservationsPossible,
                    numberOfSpotsToReserve,newReservationList
                  },

                  (* Get the value from the lookup if one exists for this object *)
                  existingReservationList = Lookup[objectContainerToReservationsLookup, container, {}];

                  (* Total all non "All" values in the existing reservatino list *)
                  totalNumberOfReservationsSoFar = If[MatchQ[existingReservationList,{}],
                    0,
                    Total[existingReservationList[[All,3]]/.{All -> 0}]
                  ];

                  (* Get the total number of reservations possible in the container *)
                  totalReservationsPossible = Lookup[objectContainerNumAvailablePositionsLookup, container, 0];

                  (* Determine the actual number of spots to reserve *)
                  numberOfSpotsToReserve = If[MatchQ[numberOfSpotsLeftToReserve, All],
                    numberOfSpotsLeftToReserve,
                    Min[totalReservationsPossible - totalNumberOfReservationsSoFar, numberOfSpotsLeftToReserve]
                  ];

                  (* Add an entry to the end of the list *)
                  newReservationList = Append[existingReservationList,{mySample, population, numberOfSpotsToReserve}];

                  (* Update our tracking number *)
                  numberOfSpotsLeftToReserve = If[MatchQ[numberOfSpotsLeftToReserve,All],
                    All,
                    numberOfSpotsLeftToReserve - numberOfSpotsToReserve
                  ];

                  (* Update the lookup *)
                  objectContainerToReservationsLookup[container] = newReservationList;
                ]
              ],
                destinationContainers
              ]
            ]
          ]
        ],
        {
          destinationMediaTypes,
          populations,
          destinationMediaContainers
        }
      ]
    ],
    {
      mySamples,
      destinationMediaTypes,
      pickCoordinates,
      populations,
      destinationMediaContainers
    }
  ];

  (* Audit the reservations and translate any 'All''s into an actual number of positions *)
  updatedObjectContainerReservations = KeyValueMap[
    Function[{container,reservations},
      Module[{totalNumberOfAvailableWellsInContainer,allReservations,numericalReservations},

        (* Get the number of available wells in this container *)
        totalNumberOfAvailableWellsInContainer = Lookup[objectContainerNumAvailablePositionsLookup,container];

        (* Split the reservations into reservations that are already by number and ones that specify 'All' *)
        allReservations = Cases[reservations,{_,_,All}];
        numericalReservations = Cases[reservations,{_,_,NumberP}];

        (* If there are any reservations that are specified through "All" we need to translate that into a number *)
        If[Length[allReservations] > 0,
          Module[{totalNumberOfNonAllReservations,numPositionsAvailableForAlls,numReservationsPerAll,updatedAllReservations},

            (* Calculate the total number of non-All reservations *)
            totalNumberOfNonAllReservations = If[MatchQ[numericalReservations,{}],
              0,
              Total[numericalReservations[[All,3]]]
            ];

            (* Calculate the number of positions available for any 'All's to occupy *)
            numPositionsAvailableForAlls = Max[totalNumberOfAvailableWellsInContainer - totalNumberOfNonAllReservations, 0];

            (* Calculate the number of reservations each 'All' will get *)
            numReservationsPerAll = Floor[numPositionsAvailableForAlls / Length[allReservations]];

            (* Replace in the list of all reservations *)
            updatedAllReservations = ({#[[1]],#[[2]],numReservationsPerAll})&/@allReservations;

            (* Recombine the reservation list and return *)
            container -> Join[numericalReservations,updatedAllReservations]
          ],
          (* Otherwise just leave the reservations as they are *)
          container -> reservations
        ]
      ]
    ],
    objectContainerToReservationsLookup
  ];

  (* Also do a reservation system for the Model[Container]'s. This is so we know how many containers to create for each population *)
  (* if there are multiple populations for the same sample with Model[Container] as the DestinationMediaContainer *)
  (* NOTE: The structure of this lookup will be Model[Container] -> {{sample, population, numberOfContainers To Reserve} ..} *)
  modelContainerReservations = <||>;

  (* Populate the lookup *)
  MapThread[
    Function[{mySample,destinationMediaTypes,pickCoordinates,populations,destinationMediaContainers,maxDestNumRows,maxDestNumCols},
      Module[
        {
          numberOfColoniesToPickPerPopulation,numberOfContainersNeededPerPopulation,modelContainerAndNumColonies,
          tuplesThatNeedToBeAddedStill,numAvailableContainers,allTuplesToPopulate
        },

        (* 1. Get the number of colonies for each population *)
        numberOfColoniesToPickPerPopulation = Map[
          Function[{population},
            If[MatchQ[population,CustomCoordinates],
              Length[pickCoordinates],
              Module[{populationAssociation,populationHead},

                (* Get the population primitive in association form *)
                populationAssociation = population[[1]];

                (* Get the head of the population *)
                populationHead = Head[population];

                (* Extract the value from the population *)
                If[MatchQ[populationHead,AllColonies],
                  All,
                  Total[ToList[Lookup[populationAssociation,NumberOfColonies,Automatic] /. Automatic -> 10]]
                ]
              ]
            ]
          ],
          populations
        ];

        (* 2. Determine how many of a Model[Container] it would take to hold the number of colonies *)
        numberOfContainersNeededPerPopulation = MapThread[Function[{numColonies,container,destinationMediaType,maxRows,maxCols},
          Which[
            (* If the container is not a Model, return the number of objects *)
            MatchQ[ToList[container],{ObjectP[Object[Container]]..}],
            Length[ToList[container]],

            (* If the numberOfColonies is All, just keep it *)
            MatchQ[numColonies,All],
            numColonies,

            (* If the destinationMediaType is SolidMedia, then each plate can hold 96 colonies (restricted by maxNumRows/Cols) *)
            MatchQ[destinationMediaType, SolidMedia],
            Ceiling[N[numColonies / Min[96, maxRows * maxCols]]],

            (* Otherwise, if destinationMediaType is LiquidMedia, then each plate can hold numberOfWells colonies (restricted by maxNumRows/Cols) *)
            True,
            Ceiling[N[numColonies / Min[fastAssocLookup[fastAssoc,container,NumberOfWells], maxRows * maxCols]]]
          ]
        ],
          {
            numberOfColoniesToPickPerPopulation,
            destinationMediaContainers,
            destinationMediaTypes,
            maxDestNumRows /. {Automatic -> 8, Null -> 16},
            maxDestNumCols /. {Automatic -> 12, Null -> 24}
          }
        ];

        (* 3. Link any Model[Container]'s in destinationMediaContainer's with the number of colonies per population *)
        modelContainerAndNumColonies = Cases[
          Transpose[{destinationMediaContainers, ConstantArray[mySample, Length[populations]], populations, numberOfContainersNeededPerPopulation}],
          {ObjectP[Model[Container]],_,_,_}
        ];

        (* 4. Determine the number of open container spots for this container (max 6) - number of object containers specified *)
        numAvailableContainers = Max[4 - (Length[Cases[Flatten[destinationMediaContainers],ObjectP[Object[Container]]]]), 0];

        (* 4. Add tuples with non All number of containers to the lookup if there is room *)
        (* NOTE: Only add the tuple if ALL of its required containers can fit *)
        tuplesThatNeedToBeAddedStill = Map[
          Function[{tuple},
            If[!MatchQ[Last[tuple], All] && (numAvailableContainers - Last[tuple] > 0),
              Module[{originalValue},
                (* Get the original value *)
                originalValue = Lookup[modelContainerReservations,First[tuple],{}];

                (* Update the lookup *)
                modelContainerReservations[First[tuple]] = Append[originalValue, Rest[tuple]];

                (* Update the number of available containers *)
                numAvailableContainers = numAvailableContainers - Last[tuple];

                (* Return nothing *)
                Nothing
              ],
              (* Otherwise keep the tuple *)
              tuple
            ]
          ],
          modelContainerAndNumColonies
        ];

        (* 6. Split the remaining available containers among any tuples with numberOfContainers = All *)
        allTuplesToPopulate = Take[Flatten[ConstantArray[Cases[tuplesThatNeedToBeAddedStill, {_, _, _, All}], 2], 1], UpTo[numAvailableContainers]];

        (* 7. Update the lookup with any tuples with numberOfContainers = All that got assigned spots *)
        Map[
          Function[{tuple},
            Module[{tupleContainer,tupleSample,tuplePopulation,tupleNumContainers,originalListOfTuples,currentPosition,currentCount},
              (* Split the given tuple into its parts *)
              {tupleContainer,tupleSample,tuplePopulation,tupleNumContainers} = tuple;

              (* Get the list of tuples for the container *)
              originalListOfTuples = Lookup[modelContainerReservations, tupleContainer,{}];

              (* See if there is already a count for this container/sample/population combo *)
              currentPosition = Position[originalListOfTuples,{tupleSample, tuplePopulation, _}];

              (* Get the current count *)
              currentCount = If[MatchQ[currentPosition,{}],
                0,
                Last[originalListOfTuples[[First[First[currentPosition]]]]]
              ];

              (* Increment the count *)
              If[MatchQ[currentPosition,{}],
                modelContainerReservations[tupleContainer] = Append[originalListOfTuples, {tupleSample,tuplePopulation,currentCount + 1}],
                modelContainerReservations[tupleContainer] = ReplacePart[originalListOfTuples, currentPosition -> {tupleSample,tuplePopulation,currentCount + 1}]
              ];

              (* Remove the tuple from the list of tuples to still be added *)
              tuplesThatNeedToBeAddedStill = DeleteCases[tuplesThatNeedToBeAddedStill,tuple]
            ]
          ],
          allTuplesToPopulate
        ];

        (* Add a value to the lookup for any tuple that did not get any spots *)
        Map[
          Function[{tuple},
            Module[{tupleContainer,tupleSample,tuplePopulation,tupleNumContainers,originalListOfTuples},
              (* Split the given tuple into its parts *)
              {tupleContainer,tupleSample,tuplePopulation,tupleNumContainers} = tuple;

              (* Get the list of tuples for the container *)
              originalListOfTuples = Lookup[modelContainerReservations, tupleContainer,{}];

              (* Add the tuple *)
              modelContainerReservations[tupleContainer] = Append[originalListOfTuples, {tupleSample, tuplePopulation, 0}]
            ]
          ],
          tuplesThatNeedToBeAddedStill
        ]
      ]
    ],
    {
      mySamples,
      destinationMediaTypes,
      pickCoordinates,
      populations,
      destinationMediaContainers,
      maxDestinationNumberOfRows,
      maxDestinationNumberOfColumns
    }
  ];

  (* Keep track of a list of the wells of Object[Container]s we have already made tuples for (we don't want to fill them with media multiple times) *)
  (* NOTE: This association is of the form Object[Container] -> {WellP...} *)
  (* Also keep track of a association of Model[Container]s, their positions and the label of that model container *)
  filledObjectContainers = <||>;
  modelContainerLabelMapping = <||>;
  (* Keep track of each {sample, population, container, container storage condition, wells to fill with sample} combination *)
  wellsToPopulatePerSample = {};

  (* First, loop over the destination media containers *)
  (* NOTE: These will be nested lists because we can be picking multiple populations per input sample *)
  transferTuples = Flatten[MapThread[
    Function[
      {
        mySample,populationsList,destinationMediaContainerList,destinationMediaList,mediaVolumeList,
        destinationMediaTypeList,maxDestinationNumberOfRowsList,maxDestinationNumberOfColumnsList,
        pickCoordinatesPerSample, samplesOutStorageConditionsList, outerIndex
      },
      MapThread[
        Function[
          {
            population,destinationMediaContainer, destinationMedia, mediaVolume, destinationMediaType,
            maxDestinationNumberOfRow, maxDestinationNumberOfCols, samplesOutStorageCondition, innerIndex
          },
          Module[{maxRows,maxCols},
            (* Convert the max rows and max cols into a usable form *)
            (* NOTE: Even though this is a long automatic, here we assume we will fill all wells *)
            maxRows = maxDestinationNumberOfRow /. {Automatic -> 8, Null -> 16};
            maxCols = maxDestinationNumberOfCols /. {Automatic -> 12, Null -> 24};

            Which[

              (* If destinationMediaContainer is a model, we need to fill the necessary wells of the number of plates specified by the reservations *)
              MatchQ[destinationMediaContainer, ObjectP[Model[Container]]],
                Module[{allWells,wellsInCorrectOrder,numContainers,modelContainerLabels,maxNumberOfColoniesToPick,numberOfColoniesLeftToPick,volToUse},

                  (* 1. Determine the wells to fill in the container *)
                  (* Get a list of possible wells *)
                  (* TODO: AllWells Cache *)
                  allWells = AllWells[destinationMediaContainer, Cache->inheritedCache];

                  (* Respect DestinationFillDirection/MaxDestinationNumberOfRows/MaxDestinationNumberOfCols *)
                  wellsInCorrectOrder = If[MatchQ[destinationFillDirection,Column],
                    restrictWells[Flatten[Transpose[allWells]], maxRows, maxCols],
                    restrictWells[Flatten[allWells], maxRows, maxCols]
                  ];

                  (* Get the number of model containers we need to make to fulfill our samples *)
                  numContainers = Last[FirstCase[Lookup[modelContainerReservations,destinationMediaContainer],{mySample,population,_}]];

                  (* Create a label for each container *)
                  modelContainerLabels = Map[Function[{containerIndex},
                    "Sample " <> ToString[outerIndex] <> " Population " <> ToString[innerIndex] <> " Container " <> ToString[containerIndex]
                  ],
                    Range[numContainers]
                  ];

                  (* Add our labels to the model container label mapping *)
                  modelContainerLabelMapping[Key[{{outerIndex,innerIndex},destinationMediaContainer}]] = modelContainerLabels;

                  (* Get the number of colonies to pick from the population (All means 96) or the pick coordinates *)
                  maxNumberOfColoniesToPick = If[MatchQ[population,CustomCoordinates],
                    Length[pickCoordinatesPerSample],
                    Module[{populationAssociation,populationHead},

                      (* Get the population primitive in association form *)
                      populationAssociation = population[[1]];

                      (* Get the head of the population *)
                      populationHead = Head[population];

                      If[MatchQ[populationHead,AllColonies],
                        All,
                        Lookup[populationAssociation,NumberOfColonies,Automatic]
                      ] /. {All -> (fastAssocLookup[fastAssoc,destinationMediaContainer,NumberOfWells] * numContainers), Automatic -> 10}
                    ]
                  ];

                  (* Restrict the number of colonies by max dest rows/cols *)
                  numberOfColoniesLeftToPick = Min[maxNumberOfColoniesToPick, (maxRows * maxCols * numContainers)];

                  (* 2. Determine the volume of media to fill in each well *)
                  (* If the destination media is Liquid, use the resolved volume, if it is solid fill the container to half of its max volume *)
                  volToUse = If[MatchQ[destinationMediaType,LiquidMedia],
                    mediaVolume,
                    N[fastAssocLookup[fastAssoc, destinationMediaContainer, MaxVolume] / 2]
                  ];

                  (* 3. Create the transfer tuples *)
                  Flatten[MapThread[
                    Function[{wellList,containerLabel},
                      Module[{wellsToFill,newTuples},

                        (* Get the specific wells to fill *)
                        wellsToFill = Take[wellList,UpTo[numberOfColoniesLeftToPick]];

                        (* Keep track of the wells we need to fill with sample *)
                        AppendTo[wellsToPopulatePerSample,{mySample,population,containerLabel,samplesOutStorageCondition,wellsToFill}];

                        (* Create the tuples *)
                        newTuples = Map[
                          Function[{well},
                            (* Create the tuple *)
                            {destinationMedia, containerLabel, volToUse, well}
                          ],
                          wellsToFill
                        ];

                        (* Update the colony count *)
                        numberOfColoniesLeftToPick = numberOfColoniesLeftToPick - Length[wellsToFill];

                        (* Return the tuples *)
                        newTuples
                      ]
                    ],
                    {
                      ConstantArray[wellsInCorrectOrder,numContainers],
                      modelContainerLabels
                    }
                  ],1]
                ],

              (* If the destinationMediaContainer is an object *)
              MatchQ[destinationMediaContainer, ObjectP[{Object[Container]}]],
                Module[{volToUse,numberOfWellsToReserve,wellsReservedAlready,allWells,wellsInCorrectOrder,filledWells,wellsToReserve},

                  (* 1. Determine the volume of media to fill in each well *)
                  (* If the destination media is Liquid, use the resovled volume, if it is solid fill the container to half of its max volume *)
                  volToUse = If[MatchQ[destinationMediaType,LiquidMedia],
                    mediaVolume,
                    N[fastAssocLookup[fastAssoc, destinationMediaContainer, {Model,MaxVolume}] / 2]
                  ];

                  (* Need to determine which wells of the container to fill with the given media *)
                  (* Determine how many wells are reserved by this population in this container *)
                  numberOfWellsToReserve = If[MatchQ[destinationMediaType,SolidMedia],
                    1,
                    Last[FirstCase[Lookup[updatedObjectContainerReservations,destinationMediaContainer],{mySample,population,_},{Null,Null,0}]]
                  ];

                  (* Get the wells that have already been reserved *)
                  wellsReservedAlready = Lookup[filledObjectContainers,destinationMediaContainer,{}];

                  (* Get a list of possible wells *)
                  (* TODO: AllWells Cache *)
                  allWells = AllWells[destinationMediaContainer, Cache->inheritedCache];

                  (* Respect DestinationFillDirection/MaxDestinationNumberOfRows/MaxDestinationNumberOfCols *)
                  wellsInCorrectOrder = If[MatchQ[destinationFillDirection,Column],
                    restrictWells[Flatten[Transpose[allWells]], maxRows /. {All -> 8}, maxCols /. {All -> 12}],
                    restrictWells[Flatten[allWells], maxRows /. {All -> 8}, maxCols /. {All -> 12}]
                  ];

                  (* Get a list of the wells of the container which already contain a sample *)
                  filledWells = fastAssocLookup[fastAssoc, destinationMediaContainer, Contents][[All,1]];

                  (* The wells we can reserve now are the restricted wells - the already reserved wells upto the number of wells to reserve *)
                  wellsToReserve = If[MatchQ[destinationMediaType,SolidMedia],
                    {"A1"},
                    Take[UnsortedComplement[Flatten[wellsInCorrectOrder], wellsReservedAlready], UpTo[numberOfWellsToReserve]]
                  ];

                  (* Keep track of the wells we need to fill with sample *)
                  AppendTo[wellsToPopulatePerSample,{mySample,population,destinationMediaContainer,samplesOutStorageCondition,wellsToReserve}];

                  (* Update the lookup with the new wells we are reserving *)
                  filledObjectContainers[destinationMediaContainer] = Join[wellsReservedAlready,wellsToReserve];

                  (* Create a transfer tuple at the first numberOfWellsToReserve wells of possibleWellsToReserve, skipping the well if there are already contents *)
                  (* 3. Create the transfer tuples *)
                  Map[
                    Function[{well},
                      If[MemberQ[filledWells,well],
                        Nothing,
                        {destinationMedia, destinationMediaContainer, volToUse, well}
                      ]
                    ],
                    wellsToReserve,
                    2
                  ]
                ],

              (* Finally, if we got here this means destinationMediaContainer is a list of objects *)
              (* Map over the list and get the tuples for each object *)
              True,
                Flatten[Map[
                  Function[{container},
                    Module[{volToUse,numberOfWellsToReserve,wellsReservedAlready,allWells,wellsInCorrectOrder,filledWells,wellsToReserve},

                      (* 1. Determine the volume of media to fill in each well *)
                      (* If the destination media is Liquid, use the resovled volume, if it is solid fill the container to half of its max volume *)
                      volToUse = If[MatchQ[destinationMediaType,LiquidMedia],
                        mediaVolume,
                        N[fastAssocLookup[fastAssoc, container, {Model,MaxVolume}] / 2]
                      ];

                      (* Need to determine which wells of the container to fill with the given media *)
                      (* Determine how many wells are reserved by this population in this container *)
                      numberOfWellsToReserve = If[MatchQ[destinationMediaType,SolidMedia],
                        1,
                        Last[FirstCase[Lookup[updatedObjectContainerReservations,container],{mySample,population,_},{Null,Null,0}]]
                      ];

                      (* Get the wells that have already been reserved *)
                      wellsReservedAlready = Lookup[filledObjectContainers,container,{}];

                      (* Get a list of possible wells *)
                      (* TODO: AllWells Cache *)
                      allWells = AllWells[container, Cache->inheritedCache];

                      (* Respect DestinationFillDirection/MaxDestinationNumberOfRows/MaxDestinationNumberOfCols *)
                      wellsInCorrectOrder = If[MatchQ[destinationFillDirection,Column],
                        restrictWells[Flatten[Transpose[allWells]], maxRows /. {All -> 8}, maxCols /. {All -> 12}],
                        restrictWells[Flatten[allWells], maxRows /. {All -> 8}, maxCols /. {All -> 12}]
                      ];

                      (* Get a list of the wells of the container which already contain a sample *)
                      filledWells = fastAssocLookup[fastAssoc, container, Contents][[All,1]];

                      (* The wells we can reserve now are the restricted wells - the already reserved wells upto the number of wells to reserve *)
                      wellsToReserve = If[MatchQ[destinationMediaType,SolidMedia],
                        {"A1"},
                        Take[UnsortedComplement[Flatten[wellsInCorrectOrder], wellsReservedAlready], UpTo[numberOfWellsToReserve]]
                      ];

                      (* Keep track of the wells we need to fill with sample *)
                      AppendTo[wellsToPopulatePerSample,{mySample,population,container,samplesOutStorageCondition,wellsToReserve}];

                      (* Update the lookup with the new wells we are reserving *)
                      filledObjectContainers[container] = Join[wellsReservedAlready,wellsToReserve];

                      (* Create a transfer tuple at the first numberOfWellsToReserve wells of possibleWellsToReserve, skipping the well if there are already contents *)
                      (* 3. Create the transfer tuples *)
                      Map[
                        Function[{well},
                          If[MemberQ[filledWells,well],
                            Nothing,
                            {destinationMedia, container, volToUse, well}
                          ]
                        ],
                        wellsToReserve,
                        2
                      ]
                    ]
                  ],
                  destinationMediaContainer
                ],1]
            ]
          ]
        ],
        {
          populationsList,destinationMediaContainerList,destinationMediaList,mediaVolumeList,
          destinationMediaTypeList,maxDestinationNumberOfRowsList,maxDestinationNumberOfColumnsList,
          samplesOutStorageConditionsList,Range[Length[populationsList]]
        }
      ]
    ],
    {
      mySamples,
      populations,
      destinationMediaContainers,
      destinationMedia,
      mediaVolumes,
      destinationMediaTypes,
      maxDestinationNumberOfRows,
      maxDestinationNumberOfColumns,
      pickCoordinates,
      samplesOutStorageConditions,
      Range[Length[mySamples]]
    }
  ],1];

  (* Flatten the transfer tuples *)
  transferTuplesFlattened = Flatten[transferTuples, 1];

  allModelsAndLabels = Flatten[KeyValueMap[
    Function[{key,value},
      Module[{position,model},
        (* Split the key into position and model *)
        {position, model} = key[[1]];

        Transpose@{
          ConstantArray[model,Length[value]],
          value
        }
      ]
    ],
    modelContainerLabelMapping
  ],1];

  (* Create a LabelContainer Primitive from the label mapping *)
  labelContainerPrimitive = If[Length[allModelsAndLabels] > 0,
    LabelContainer[
      Label -> allModelsAndLabels[[All,2]],
      Container -> allModelsAndLabels[[All,1]]
    ],
    Null
  ];

  (* Create the Transfer primitive *)
  transferPrimitive = If[Length[transferTuplesFlattened] > 0,
    Transfer[
      Source -> transferTuplesFlattened[[All,1]],
      Amount -> transferTuplesFlattened[[All,3]],
      Destination -> transferTuplesFlattened[[All,2]],
      DestinationWell -> transferTuplesFlattened[[All,4]],
      SterileTechnique -> True
    ],
    Null
  ];

  (* Get a flat list of all of the destination media containers *)
  allDestinationContainersFlat = Flatten[destinationMediaContainers];
  
  (* Get the model container label mapping into a different form *)
  modelContainerPositionLabelMap = Rule@@@Transpose@{Key/@(Keys@modelContainerLabelMapping)[[All, 1, 1]], Values@modelContainerLabelMapping};

  (* NOTE: We use Long Automatic for exposure times in option resolver, but records it as AutoExpose in batchedUO for clarity *)
  (* We convert BrightField to {BrightField} here so they can be grouped together for batch unit operations *)
  {uniqueImagingStrategies, uniqueImagingChannels, uniqueExposureTimes} = Transpose@MapThread[
    Function[{imageStrategies, imageChannels, exposureTimes},
      {ToList@imageStrategies, ToList@imageChannels, ToList[exposureTimes]/.Automatic -> AutoExpose}
    ],
    {resolvedImagingStrategies, resolvedImagingChannels, resolvedExposureTimes}
  ];

  (* Update the resolved options with unique imaging options *)
  updatedResolvedOptions = ReplaceRule[myResolvedOptions, {ImagingStrategies -> uniqueImagingStrategies, ImagingChannels -> uniqueImagingChannels, ExposureTimes -> uniqueExposureTimes}];

  (* Next, we need to batch our input samples to create batched unit operations *)
  (* In order to batch the samples we need to gather the information for each sample into packets we can move around *)
  (* Do this by mapthreading the resolved options and then adding sample keys for each packet *)
  splitOptionPackets = OptionsHandling`Private`mapThreadOptions[experimentFunction, updatedResolvedOptions, AmbiguousNestedResolution -> IndexMatchingOptionPreferred, SingletonOptionPreferred -> {PickCoordinates, Populations}];

  (* Add the sample keys and keep track of the original index of each sample *)
  (* Remove Cache from the options *)
  sampleInfoPackets = MapThread[
    Function[{sample, options, index},
      Merge[{KeyDrop[options, Cache], <|Sample -> sample, OriginalIndex -> index|>}, First]
    ],
    {mySamples, splitOptionPackets, Range[Length[mySamples]]}
  ];

  (* First, group by ColonyHandlerHeadCassette *)
  unitOpGroupedByColonyHandlerHeadCassette = Values@GroupBy[sampleInfoPackets, Lookup[#, ColonyPickingTool]&];

  {finalPhysicalGroups, carrierDeckPlateLocations} = Module[
    {physicalBatchCarrierConstraints, samplePacketsBatchedByDestinationContainerConstraints, batchedSamplePacketsSortedByImagingParameters},
    (* For Pick UnitOperations, we have to batch based on the amount of destination containers we can fit on deck *)
    (* Currently we have 12 spots *)
    (* There are also riser restrictions. On the deck of the qpix in the pick configuration, *)
    (* there are 3 tracks, each of which can hold 4 plates. Each track can either be raised, to hold shallow plates, *)
    (* or left alone to hold deep well plates. We have to split our current batches more, into groups that follow these restrictions *)

    (* Map over the grouped unit operations *)
    {
      physicalBatchCarrierConstraints,
      samplePacketsBatchedByDestinationContainerConstraints
    } = Module[{groupedResult},
      groupedResult = Map[
        Function[{groupPackets},
          Module[{currentGroupBatches,currentGroupContainers},
            (* This is a list of rules structured in the following way: *)
            (* Key: The key is a symbolization of the 3 available destination tracks and what type of/how many positions they have remaining (trackInformation) *)
            (* Value: A list of the samples that are in this batch *)
            (*{{{numNonDeepWellPositionsLeft, numDeepWellPositionsLeft},{numNonDeepWellPositionsLeft, numDeepWellPositionsLeft},{numNonDeepWellPositionsLeft, numDeepWellPositionsLeft}} -> {samplePackets in this batch}}*)
            currentGroupBatches = {};

            (* Keep track of the object containers that are already on deck in this batch. We don't need to reserve a spot for a container if it is already on the deck from a previous sample *)
            (* This is a nested list that corresponds to currentGroupBatches. Each inner list is a list of container objects that are "on the deck" for that batch *)
            currentGroupContainers = {};

            (* Map over the sample packets in this group and split them into their final batches *)
            Map[
              Function[{samplePacket},
                Module[{destinationMediaContainers,containerInfoPerBatch,potentialBatchPosition},

                  (* 1. Categorize the containers by how many are needed and if they are deep well or not *)
                  (* Get the destination containers, but delete duplicate Object[Container]'s *)
                  destinationMediaContainers = DeleteDuplicates[Lookup[samplePacket, DestinationMediaContainer]];

                  (* Replace each container with a tuple of a bool indicating if the container is deep well or not and a list of the new containers to add to the deck *)
                  containerInfoPerBatch = If[MatchQ[Length[currentGroupContainers], 0],
                    MapThread[
                      Function[{container, populationIndex},
                        Which[
                          MatchQ[container, ObjectP[Model[Container]]],
                          {
                            deepWellQ[container, fastAssoc],
                            Key[{Lookup[samplePacket, OriginalIndex], populationIndex}] /. modelContainerPositionLabelMap
                          },
                          MatchQ[container, ObjectP[Object[Container]]],
                          {
                            deepWellQ[container, fastAssoc],
                            {container}
                          },
                          True,
                          {
                            deepWellQ[container, fastAssoc],
                            container
                          }
                        ]
                      ],
                      {destinationMediaContainers, Range[Length[destinationMediaContainers]]}
                    ],
                    Map[
                      Function[{containersOnDeckInThisGroup},
                        MapThread[
                          Function[{container, populationIndex},
                            Which[
                              MemberQ[container, containersOnDeckInThisGroup],
                              {
                                deepWellQ[container, fastAssoc],
                                {}
                              },

                              MatchQ[container,ObjectP[Model[Container]]],
                              {
                                deepWellQ[container, fastAssoc],
                                Key[{Lookup[samplePacket, OriginalIndex], populationIndex}] /. modelContainerPositionLabelMap
                              },
                              MatchQ[container, ObjectP[Object[Container]]],
                              {
                                deepWellQ[container, fastAssoc],
                                {container}
                              },
                              True,
                              {
                                deepWellQ[container, fastAssoc],
                                If[MemberQ[#, containersOnDeckInThisGroup], Nothing, #]& /@ container
                              }
                            ]
                          ],
                          {destinationMediaContainers, Range[Length[destinationMediaContainers]]}
                        ]
                      ],
                      currentGroupContainers
                    ]
                  ];

                  (* 2. Determine if there is a current batch these containers could be added to *)
                  (* Can this sample fit into any of the current groups? *)
                  potentialBatchPosition = If[MatchQ[Length[currentGroupBatches], 0],
                    Null,
                    FirstOrDefault[
                      FirstPosition[
                        MapThread[
                          batchHasRoomQ[#1, Flatten[Cases[#2, {True, _}][[All, 2]]],Flatten[Cases[#2, {False,_}][[All, 2]]], 3]&,
                          {currentGroupBatches, containerInfoPerBatch}
                        ],
                        True,
                        Null
                      ],
                      Null
                    ]
                  ];

                  Which[
                    (* If we are on the first potential group *)
                    MatchQ[Length[currentGroupBatches], 0],
                      Module[{deepWellPlates, nonDeepWellPlates, updatedBatch, updatedGroupContainers},
                        (* Extract the plates of each type to add *)
                        deepWellPlates = Flatten[Cases[containerInfoPerBatch, {True,_}][[All, 2]]];
                        nonDeepWellPlates = Flatten[Cases[containerInfoPerBatch, {False,_}][[All, 2]]];

                        (* Get the updated batch *)
                        updatedBatch = addSampleToBatch[newBatch[3], samplePacket, deepWellPlates, nonDeepWellPlates, 3];

                        (* Get the updated containers *)
                        updatedGroupContainers = DeleteDuplicates@Cases[destinationMediaContainers, ObjectP[Object[Container]]];

                        AppendTo[currentGroupBatches, updatedBatch];
                        AppendTo[currentGroupContainers, updatedGroupContainers]
                      ],

                    (* If we are starting a new batch *)
                    NullQ[potentialBatchPosition],
                      Module[{deepWellPlates, nonDeepWellPlates, updatedBatch, updatedGroupContainers},
                        (* Extract the plates of each type to add *)
                        deepWellPlates = Flatten[Cases[containerInfoPerBatch[[1]], {True, _}][[All, 2]]];
                        nonDeepWellPlates = Flatten[Cases[containerInfoPerBatch[[1]], {False,_}][[All, 2]]];

                        (* Get the updated batch *)
                        updatedBatch = addSampleToBatch[newBatch[3], samplePacket, deepWellPlates, nonDeepWellPlates, 3];

                        (* Get the updated contaienrs *)
                        updatedGroupContainers = DeleteDuplicates@Cases[destinationMediaContainers, ObjectP[Object[Container]]];

                        (* Update our looping parameters *)
                        AppendTo[currentGroupBatches, updatedBatch];
                        AppendTo[currentGroupContainers, updatedGroupContainers]
                      ],

                    (* Finally, if we are adding to a batch *)
                    True,
                      Module[{deepWellPlates, nonDeepWellPlates, updatedBatch, updatedGroupContainers},
                        (* Extract the plates of each type to add *)
                        deepWellPlates = Flatten[Cases[containerInfoPerBatch[[potentialBatchPosition]], {True, _}][[All, 2]]];
                        nonDeepWellPlates = Flatten[Cases[containerInfoPerBatch[[potentialBatchPosition]],{False, _}][[All, 2]]];

                        (* Get the updated batch *)
                        updatedBatch = addSampleToBatch[currentGroupBatches[[potentialBatchPosition]], samplePacket, deepWellPlates, nonDeepWellPlates, 3];

                        (* Get the updated containers *)
                        updatedGroupContainers = DeleteDuplicates@Join[currentGroupContainers[[potentialBatchPosition]], Cases[Download[Flatten@destinationMediaContainers,Object], ObjectP[Object[Container]]]];

                        (* Update the current group batches *)
                        currentGroupBatches = ReplacePart[currentGroupBatches, potentialBatchPosition -> updatedBatch];

                        (* Update the current group containers *)
                        currentGroupContainers = ReplacePart[currentGroupContainers, potentialBatchPosition -> updatedGroupContainers];
                      ]
                  ];
                ]
              ],
              groupPackets
            ];

            currentGroupBatches
          ]
        ],
        unitOpGroupedByColonyHandlerHeadCassette
      ];

      (* Extract the data in a usable form *)
      {
        Flatten[groupedResult[[All, All, 1]], 1],
        Flatten[groupedResult[[All, All, 2]], 1]
      }
    ];

    (* We also have to group by the Imaging parameters (ImagingChannels and ExposureTimes). *)
    (* The ExposureFinding routine only works for up to 2 plates at a time and in order to minimize operator interactions with  *)
    (* the instrument, we want to do the imaging and picking for 2 source plates without having to remove them from the deck *)
    (* In order to achieve this we sort by imaging parameters and then partition upto groups of 2. *)
    batchedSamplePacketsSortedByImagingParameters = Map[
      Function[{groupByDestinationContainerConstraints},
        SortBy[groupByDestinationContainerConstraints, {OrderlessPatternSequence@@Transpose@Lookup[#, {ImagingChannels,ExposureTimes}]}&]
      ],
      samplePacketsBatchedByDestinationContainerConstraints
    ];

    {
      (* Next, for each imaging parameter group, we need to partition them by up to 2, this will give us the final pairs of input samples *)
      (* that will be put on the deck at the same time *)
      (* For example, in {{{a,b},{c}},{{d,e}}}, abc are from the same physical batch, de are from the same physical batch, ab and c are from different source group. *)
      Partition[#, UpTo[2]]& /@ batchedSamplePacketsSortedByImagingParameters,

      (* For each batch also return how the carriers need to be structured for that group (High position or low position) *)
      physicalBatchCarrierConstraints
    }
  ];

  (* Stage 1.4: Create all of the deck placement fields for the unit operation objects *)
  (* We need to make deck placements that show which risers/carriers to move *)
  (* We are creating lists for both deck placement fields and resource picking fields *)
  (* the resource picking fields will be populated when risers have to be returned *)
  (* Tho note that in order to take the risers off you have to take the carrier off first *)
  (* then the risers, then put the carriers back on. So these tasks need to have the  *)
  (* "In order" option turned on and we always do resource picking before deck placements *)
  (* Also, in order to limit the amount of movements, we need to detect if a track stays in *)
  (* the same place *)
  {
    riserPlacements,
    carrierPlacements,
    riserReturns,
    carrierReturns,
    initialCarrierAndRiserResourcesToPick
  }=getCarrierAndRiserBatchingFields[carrierDeckPlateLocations, experimentFunction];

  (* Stage 1.5: ColonyHandlerHeadCassette *)
  (* Go through each physical group and determine the ColonyHandlerHeadCassette that group requires. *)
  (* Then create a second list that keeps track of whether a ColonyHandlerHeadCassette needs to be removed first *)
  (* at the beginning of the physical batch *)
  {
    colonyHandlerHeadCassettePlacements,
    colonyHandlerHeadCassetteRemovals
  } = getColonyHandlerHeadCassetteBatchingFields[
    finalPhysicalGroups,
    colonyPickingToolResourceReplaceRules,
    instrumentResource,
    ColonyPickingTool
  ];

  (* Stage 1.6: LightTable Containers and Placements *)
  (* For each physical batch, create a list of the source containers that are a part of the physical batch *)
  (* as well as a list of batching lengths so we can batch loop in the procedure *)
  {
    flatLightTableContainersPerPhysicalBatch,
    flatLightTableContainerPlacementsPerPhysicalBatch,
    lightTableContainerLengthsPerPhysicalBatch
  } = Transpose@Map[Function[{physicalGroup},
    Module[{lightTableContainerPlacements},
      (* Determine the light table container placements from the physical group *)
      lightTableContainerPlacements = (MapIndexed[Function[{samplePacket,index},
        {Link[Lookup[samplePacket,Sample]],{"QPix LightTable Slot", "A1", First[index] /. {1 -> "A1", 2 -> "B1"}}}
      ],
        #
      ])&/@physicalGroup;

      {
        Download[Lookup[Flatten[physicalGroup],Sample],Object],
        Flatten[lightTableContainerPlacements,1],
        Length/@physicalGroup
      }
    ]
  ],
    finalPhysicalGroups
  ];

  (* Stage 1.7: Carrier Container Deck Placements *)
  (* For each physical batch, create a list of placements for the containers that will go on the carriers on the deck *)
  carrierContainerDeckPlacements = getCarrierContainerDeckPlacements[carrierDeckPlateLocations];

  (* Stage 1.7: Gather into Batched unit operation packets based on unit operation type *)
  (* For each physical batch, create a batched unit operation packet that contains the information to pass through to the *)
  (* procedure *)
  batchedUnitOperationPackets = MapThread[
    Function[
      {
        physicalBatchSamplePackets, physicalBatchRiserReturns, physicalBatchCarrierReturns, physicalBatchRiserPlacements,
        physicalBatchCarrierPlacements, colonyHandlerHeadCassettePlacement, colonyHandlerHeadCassetteToRemove,
        flatLightTableContainers, flatLightTableContainerPlacements, lightTableContainerLengths,physicalBatchCarrierContainerDeckPlacements
      },
      Module[{unitOperationType},
        (* Get the Unit Operation type from the experiment function *)
        unitOperationType = If[MatchQ[experimentFunction, ExperimentPickColonies],
          Object[UnitOperation,PickColonies],
          Object[UnitOperation,InoculateLiquidMedia]
        ];
        
        <|
          Type -> unitOperationType,
          UnitOperationType -> Batched,
          Replace[FlatBatchedSourceContainers] -> Link/@flatLightTableContainers /. samplesInResourceReplaceRules,
          Replace[FlatBatchedSourceContainerPlacements] -> flatLightTableContainerPlacements /. samplesInResourceReplaceRules,
          Replace[BatchedSourceContainerLengths] -> lightTableContainerLengths,
          Replace[RiserDeckPlacements] -> physicalBatchRiserPlacements,
          Replace[CarrierDeckPlacements] -> physicalBatchCarrierPlacements,
          Replace[RiserReturns] -> physicalBatchRiserReturns,
          Replace[CarrierReturns] -> physicalBatchCarrierReturns,
          ColonyHandlerHeadCassette -> First[colonyHandlerHeadCassettePlacement],
          ColonyHandlerHeadCassettePlacement -> colonyHandlerHeadCassettePlacement,
          ColonyHandlerHeadCassetteReturn -> colonyHandlerHeadCassetteToRemove,
          Replace[IntermediateDestinationContainerDeckPlacements] -> physicalBatchCarrierContainerDeckPlacements,
          Replace[FlatBatchedPickCoordinates] -> Lookup[Flatten[physicalBatchSamplePackets],PickCoordinates],
          Replace[FlatBatchedImagingChannels] -> Lookup[Flatten[physicalBatchSamplePackets],ImagingChannels],
          Replace[FlatBatchedExposureTimes] -> Lookup[Flatten[physicalBatchSamplePackets],ExposureTimes],
          Replace[FlatBatchedPopulations] -> Lookup[Flatten[physicalBatchSamplePackets,1],Populations],
          Replace[FlatBatchedMinDiameters] -> Lookup[Flatten[physicalBatchSamplePackets],MinDiameter],
          Replace[FlatBatchedMaxDiameters] -> Lookup[Flatten[physicalBatchSamplePackets],MaxDiameter],
          Replace[FlatBatchedMinColonySeparations] -> Lookup[Flatten[physicalBatchSamplePackets],MinColonySeparation],
          Replace[FlatBatchedMinRegularityRatios] -> Lookup[Flatten[physicalBatchSamplePackets],MinRegularityRatio],
          Replace[FlatBatchedMaxRegularityRatios] -> Lookup[Flatten[physicalBatchSamplePackets],MaxRegularityRatio],
          Replace[FlatBatchedMinCircularityRatios] -> Lookup[Flatten[physicalBatchSamplePackets],MinCircularityRatio],
          Replace[FlatBatchedMaxCircularityRatios] -> Lookup[Flatten[physicalBatchSamplePackets],MaxCircularityRatio],
          Replace[FlatBatchedSamplesInStorageConditions] -> Lookup[Flatten[physicalBatchSamplePackets], SamplesInStorageCondition]
        |>
      ]
    ],
    {
      finalPhysicalGroups,
      riserReturns,
      carrierReturns,
      riserPlacements,
      carrierPlacements,
      colonyHandlerHeadCassettePlacements,
      colonyHandlerHeadCassetteRemovals,
      flatLightTableContainersPerPhysicalBatch,
      flatLightTableContainerPlacementsPerPhysicalBatch,
      lightTableContainerLengthsPerPhysicalBatch,
      carrierContainerDeckPlacements
    }
  ];

  (* Currently, our batched unit operation packets do not have id's, give them ids but only call  *)
  (* CreateID a single time *)
  batchedUnitOperationPacketsWithID = Module[{unitOperationType,batchedUnitOperationNewObjects},

    (* Get the Unit Operation type from the experiment function *)
    unitOperationType = If[MatchQ[experimentFunction, ExperimentPickColonies],
      Object[UnitOperation,PickColonies],
      Object[UnitOperation,InoculateLiquidMedia]
    ];
    
    (* Use a single CreateID call to limit the number of times we contact the db *)
    batchedUnitOperationNewObjects = CreateID[ConstantArray[unitOperationType, Length[batchedUnitOperationPackets]]];

    (* Add a unique object to each packet *)
    MapThread[
      Function[{batchedUnitOpPacket, object},
        Append[batchedUnitOpPacket, Object -> object]
      ],
      {
        batchedUnitOperationPackets,
        batchedUnitOperationNewObjects
      }
    ]
  ];

  (* Create the pick colonies unit operation *)
  outputUnitOperationPacket=UploadUnitOperation[
    Module[{nonHiddenOptions,unitOpHead},
      (* Only include non-hidden options from ExperimentPickColonies. *)
      nonHiddenOptions=Lookup[
        Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category"->Except["Hidden"]]],
        "OptionSymbol"
      ];
      
      (* Get the unit operation head *)
      unitOpHead = If[MatchQ[experimentFunction, ExperimentPickColonies],
        PickColonies,
        InoculateLiquidMedia
      ];
      
      (* Join the Sample Key, Developer fields, and resolved options into a single unit op *)
      unitOpHead@@Join[
        {
          Sample->samplesInResources,
          PopulateDestContainerUnitOps -> If[MatchQ[labelContainerPrimitive,Null]&&MatchQ[transferPrimitive,Null],Null,{labelContainerPrimitive, transferPrimitive}/.Null->Nothing],
          DestinationMediaContainers -> allDestinationContainersFlat,
          WellReservations -> wellsToPopulatePerSample,
          ModelContainerReservations -> modelContainerReservations,
          ModelContainerPositionLabelMap -> Rule@@@Transpose@{Key/@(Keys@modelContainerLabelMapping)[[All, 1, 1]], Values@modelContainerLabelMapping},
          BatchedUnitOperations -> (Link/@Lookup[batchedUnitOperationPacketsWithID, Object]),
          PhysicalBatchingGroups -> finalPhysicalGroups,
          CarrierAndRiserInitialResources -> Link/@initialCarrierAndRiserResourcesToPick,
          AbsorbanceFilter -> Link[opticalFilterResource]
        },

        (* Put all of our resources in *)
        ReplaceRule[
          Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
          {
            Instrument -> instrumentResource,
            ColonyPickingTool -> colonyPickingToolResources,
            PrimaryWashSolution -> primaryWashSolutionResources,
            SecondaryWashSolution -> secondaryWashSolutionResources,
            TertiaryWashSolution -> tertiaryWashSolutionResources,
            QuaternaryWashSolution -> quaternaryWashSolutionResources,
            ExposureTimes -> (Lookup[myResolvedOptions, ExposureTimes]/. Automatic -> Null)
          }
        ]
      ]
    ],
    Preparation->Robotic,
    UnitOperationType->Output,
    FastTrack->True,
    Upload->False
  ];

  (* Update the simulation *)
  currentSimulation=UpdateSimulation[
    currentSimulation,
    Simulation[
      Packets -> {
        <|
          Object->SimulateCreateID[Object[Protocol,RoboticCellPreparation]],
          Replace[OutputUnitOperations]->(Link[Lookup[outputUnitOperationPacket,Object], Protocol]),
          ResolvedOptions->{}
        |>
      }
    ]
  ];

  (* Return early if the experiment function is ExperimentInoculateLiquidMedia *)
  If[MatchQ[experimentFunction,ExperimentInoculateLiquidMedia],
    Return[
      {
        Null,
        outputUnitOperationPacket,
        batchedUnitOperationPacketsWithID,
        currentSimulation,
        runTime
      }
    ]
  ];

  (*--Gather all the resource symbolic representations--*)

  (* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  rawResourceBlobs=DeleteDuplicates[Cases[{outputUnitOperationPacket,batchedUnitOperationPackets},_Resource,Infinity]];

  (* Get all resources without a name *)
  resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs,Resource[_?(MatchQ[KeyExistsQ[#,Name],False]&)]]];
  resourceToNameReplaceRules=MapThread[#1->#2&,{resourcesWithoutName,(Resource[Append[#[[1]],Name->CreateUUID[]]]&)/@resourcesWithoutName}];
  allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;


  (*---Call fulfillableResourceQ on all the resources we created---*)
  {fulfillable,frqTests}=Which[
    MatchQ[$ECLApplication,Engine],{True,{}},
    (* When Preparation->Robotic, the framework will call FRQ for us *)
    MatchQ[resolvedPreparation,Robotic],{True,{}},
    gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Cache->inheritedCache,Simulation->simulation],
    True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Messages->messages,Cache->inheritedCache,Simulation->simulation],Null}
  ];


  (*---Return our options, packets, and tests---*)

  (* Generate the preview output rule; Preview is always Null *)
  previewRule=Preview->Null;

  (* Generate the options output rule *)
  optionsRule=Options->If[MemberQ[output,Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
    {outputUnitOperationPacket,batchedUnitOperationPacketsWithID, runTime}/.resourceToNameReplaceRules,
    $Failed
  ];

  (* Generate the tests output rule *)
  testsRule=Tests->If[gatherTests,
    frqTests,
    {}
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];


(* ::Subsection:: *)
(*Simulation Function*)
DefineOptions[simulateExperimentPickColonies,
  Options:>{CacheOption,SimulationOption}
];

simulateExperimentPickColonies[
  myUnitOperationPacket:(PacketP[{Object[UnitOperation, PickColonies],Object[UnitOperation,InoculateLiquidMedia]}] | $Failed),
  mySamples:{ObjectP[Object[Sample]]..},
  myResolvedOptions:{_Rule..},
  experimentFunction:Alternatives[ExperimentPickColonies,ExperimentInoculateLiquidMedia],
  myResolutionOptions:OptionsPattern[simulateExperimentPickColonies]
] := Module[
  {
    inheritedCache,currentSimulation,inheritedFastAssoc,testProtocolObject,protocolPacket,
    resolvedDestinationMediaContainer,resolvedMaxDestinationNumberOfRows,resolvedMaxDestinationNumberOfColumns,
    resolvedPopulations,protocolObjectPackets,destinationObjectContainerPackets,destinationModelContainerPackets,
    flattenedProtocolPackets,combinedCache, fastCombinedAssoc, tuplesWithObjectContainers,labelObjectReplaceRules,
    destinationObjectsWithMediaPackets, uniqueDestinationContainers,containerPackets,
    containerFastAssoc,modelContainerPositionLabelMap,destinationMediaContainersWithLabels,destinationContainerAllObjects,wellReservations,
    uploadSampleTransferTuples,uploadSampleTransferPackets,simulatedLabels,updatedSimulation

  },

  (* Get simulation and cache *)
  {inheritedCache, currentSimulation} = Lookup[ToList[myResolutionOptions], {Cache,Simulation}, {}];

  (* Create a faster version of the cache to improve speed *)
  inheritedFastAssoc=makeFastAssocFromCache[inheritedCache];

  (* Simulate a protocol ID. *)
  testProtocolObject=SimulateCreateID[Object[Protocol,RoboticCellPreparation]];

  (* TODO: Handle case if myUnitOperationPacket is $Failed (Option resolver failed) *)
  (* Make a test protocol packet *)
  protocolPacket = <|
    Object -> testProtocolObject,
    Replace[OutputUnitOperations] -> {Link[myUnitOperationPacket,Protocol]},
    ResolvedOptions -> {}
  |>;

  (* Simulate the fulfillment of all resources by the procedure. *)
  currentSimulation=UpdateSimulation[
    currentSimulation,
    SimulateResources[
      protocolPacket,
      {myUnitOperationPacket},
      ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null],
      Simulation->currentSimulation
    ]
  ];

  (* ----------- Lookup any needed resolved options ---------------- *)
  {
    resolvedDestinationMediaContainer,
    resolvedMaxDestinationNumberOfRows,
    resolvedMaxDestinationNumberOfColumns,
    resolvedPopulations
  } = Lookup[
    myResolvedOptions,
    {
      DestinationMediaContainer,
      MaxDestinationNumberOfRows,
      MaxDestinationNumberOfColumns,
      Populations
    }
  ];

  (* ------------ Download any information needed from the protocol packet/input samples --------------- *)
  {
    protocolObjectPackets,
    destinationObjectContainerPackets,
    destinationModelContainerPackets
  } = Download[
    {
      {testProtocolObject},
      Cases[Flatten@resolvedDestinationMediaContainer, ObjectP[{Object[Container]}]],
      Cases[Flatten@resolvedDestinationMediaContainer, ObjectP[{Model[Container]}]]
    },
    {
      {Packet[OutputUnitOperations[PopulateDestContainerUnitOps,WellReservations,ModelContainerReservations,ModelContainerPositionLabelMap]]},
      {
        Packet[Contents,Model],
        Packet[Model[NumberOfWells, AspectRatio]]
      },
      {Packet[NumberOfWells,AspectRatio]}
    },
    Cache -> inheritedCache,
    Simulation -> currentSimulation
  ];

  (* Flatten the protocol packets *)
  flattenedProtocolPackets = Experiment`Private`FlattenCachePackets[protocolObjectPackets];
  
  (* Combine the destinationObjectPackets with the inheritedCache *)
  combinedCache = FlattenCachePackets[{inheritedCache,destinationObjectContainerPackets,destinationModelContainerPackets}];

  (* Create a fast assoc of the combined cache *)
  fastCombinedAssoc = Experiment`Private`makeFastAssocFromCache[combinedCache];
  
  (* Stage 1. Populate all containers with Object[Samples] *)
  (* The tuples are of the form {source, dest, amount, well} *)
  {tuplesWithObjectContainers, labelObjectReplaceRules} = Module[
    {
      transferPrimitiveAssociation,labelContainerPrimitiveAssociation,flattenedTransferTuples,
      containerObjectPackets,simulatedContainerObjects,labelObjectReplaceRules
    },

    (* Get the Transfer primitive *)
    transferPrimitiveAssociation = FirstCase[Flatten[Lookup[flattenedProtocolPackets, PopulateDestContainerUnitOps]],_Transfer][[1]];

    (* Get the label container unit operation *)
    labelContainerPrimitiveAssociation = FirstCase[Flatten[Lookup[flattenedProtocolPackets, PopulateDestContainerUnitOps]],_LabelContainer,{<||>}][[1]];
    
    flattenedTransferTuples = Transpose[{
      Lookup[transferPrimitiveAssociation, Source],
      Lookup[transferPrimitiveAssociation, Destination],
      Lookup[transferPrimitiveAssociation, Amount],
      Lookup[transferPrimitiveAssociation, DestinationWell]
    }];

    (* Upload a container for each entry in labelContainerPrimitiveAssociation *)
    containerObjectPackets = If[!MatchQ[labelContainerPrimitiveAssociation,<||>],
      UploadSample[
        Lookup[labelContainerPrimitiveAssociation,Container],
        ConstantArray[{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]},Length[Lookup[labelContainerPrimitiveAssociation,Container]]],
        FastTrack -> True,
        SimulationMode -> True,
        Upload -> False
      ],
      {}
    ];

    (* Get the new container objects *)
    simulatedContainerObjects = If[MatchQ[Length[containerObjectPackets],0],
      {},
      Lookup[containerObjectPackets[[1;;Length[Lookup[labelContainerPrimitiveAssociation,Container]]]],Object]
    ];

    (* Create replace rules for label -> Object[Container] *)
    labelObjectReplaceRules = Rule@@@Transpose[{Lookup[labelContainerPrimitiveAssociation,Label,{}],simulatedContainerObjects}];

    (* Update the simulation *)
    currentSimulation = UpdateSimulation[
      currentSimulation,
      Simulation[containerObjectPackets]
    ];

    {
      (* Use the replace rules to substitute in all objects *)
      flattenedTransferTuples /. labelObjectReplaceRules,
      (* Also return the labelObjectReplaceRules *)
      labelObjectReplaceRules
    }
  ];

  (* Do the upload sample *)
  destinationObjectsWithMediaPackets = UploadSample[
    tuplesWithObjectContainers[[All, 1]],
    Transpose@{tuplesWithObjectContainers[[All,4]], tuplesWithObjectContainers[[All,2]]},
    InitialAmount -> tuplesWithObjectContainers[[All,3]],
    FastTrack -> True,
    SimulationMode -> True,
    Simulation -> currentSimulation,
    Upload -> False
  ];

  (* Update the simulation *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[destinationObjectsWithMediaPackets]];

  (* Stage 2. Create the transfer tuples *)
  (* Get the unique destination containers *)
  (* NOTE: Need to add resolvedDestinationMediaContainers here because tuplesWithObjectContainers will only contain the containers that needed *)
  (* to have Media transferred into it. If Media is already present, they will not be in the list *)
  uniqueDestinationContainers = DeleteDuplicates@Flatten@Cases[Join[tuplesWithObjectContainers[[All,2]],Flatten@resolvedDestinationMediaContainer],ObjectP[Object[Container]]];

  (* Retrieve samples inside all containers of interest *)
  containerPackets = Quiet[
    Download[
      uniqueDestinationContainers,
      Packet[Contents, Model],
      Cache -> combinedCache,
      Simulation -> currentSimulation
    ],
    {Download::FieldDoesntExist}
  ];
  
  (* Create a fast lookup for the container packets *)
  containerFastAssoc = makeFastAssocFromCache[containerPackets];

  (* Stage 3. UploadSampleTransfer a couple cell/milliliter of cell in sample into container *)
  (* Lookup the model container position label map *)
  modelContainerPositionLabelMap = First[Lookup[flattenedProtocolPackets,ModelContainerPositionLabelMap, {<||>}]];

  (* Add indices to the models of resolvedDestinationMediaContainers *)
  destinationMediaContainersWithLabels = MapThread[
    Function[{containers, populations, mySample, sampleIndex},
      MapThread[
        Function[{container, population, populationIndex},
          If[MatchQ[container,ObjectP[Model[Container]]],
            (* Lookup the labels *)
            Key[{sampleIndex,populationIndex}]/.modelContainerPositionLabelMap,
            container
          ]
        ],
        {
          containers,
          populations,
          Range[Length[populations]]
        }
      ]
    ],
    {
      resolvedDestinationMediaContainer,
      resolvedPopulations,
      mySamples,
      Range[Length[mySamples]]
    }
  ];

  (* Destination container all objects *)
  destinationContainerAllObjects = destinationMediaContainersWithLabels /. labelObjectReplaceRules;

  (* Lookup the well reservations from the protocol packet *)
  wellReservations = Flatten[Lookup[flattenedProtocolPackets, WellReservations,{}],1];

  (* Create ust tuples *)
  uploadSampleTransferTuples = Flatten[MapThread[
    Function[{sample, destinationObjects, destinationObjectsWithLabels, populations},
      MapThread[
        Function[{container, destinationContainerWithLabel, population},
          If[MatchQ[container,_List],
            Flatten[MapThread[
              Function[{innerContainer, innerDestinationContainerWithLabel},
                Module[{wellsToTransfer,destinationSamples},

                  (* Get the wells to transfer to from the well reservations *)
                  wellsToTransfer = Last[FirstCase[wellReservations,{Download[sample,Object], population, innerDestinationContainerWithLabel,_,_},{Null,Null,Null,Null,{}}]];

                  (* Convert the well to a sample *)
                  destinationSamples = Download[Last[FirstCase[Experiment`Private`fastAssocLookup[containerFastAssoc, innerContainer, Contents], {#,_},"hi"]],Object]&/@wellsToTransfer;

                  (* Create a transfer tuple for each well *)
                  {sample, #, 3 Microliter}&/@destinationSamples
                ]
              ],
              {
                container,
                destinationContainerWithLabel
              }
            ],1],
            Module[{wellsToTransfer,destinationSamples},
              (* Get the wells to transfer to from the well reservations *)
              wellsToTransfer = Last[FirstCase[wellReservations,{Download[sample,Object], population, destinationContainerWithLabel,_,_},{Null,Null,Null,Null,{}}]];

              (* Convert the well to a sample *)
              destinationSamples = Download[Last[FirstCase[Experiment`Private`fastAssocLookup[containerFastAssoc, container, Contents], {#,_},"hi"]],Object]&/@wellsToTransfer;

              (* Create a transfer tuple for each well *)
              {sample, #, 3 Microliter}&/@destinationSamples
            ]
          ]
        ],
        {
          destinationObjects,
          destinationObjectsWithLabels,
          populations
        }
      ]
    ],
    {
      mySamples,
      destinationContainerAllObjects,
      destinationMediaContainersWithLabels,
      resolvedPopulations
    }
  ],2];

  (* Pass the tuples through UploadSampleTransfer *)
  uploadSampleTransferPackets = UploadSampleTransfer[
    uploadSampleTransferTuples[[All,1]],
    uploadSampleTransferTuples[[All,2]],
    uploadSampleTransferTuples[[All,3]],
    LivingDestination -> True,
    FastTrack -> True,
    Simulation -> currentSimulation,
    Upload -> False
  ];

  (* Update the simulation *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

  simulatedLabels = Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{Flatten@Lookup[myResolvedOptions, SampleOutLabel], Flatten@(uploadSampleTransferTuples[[All,2]])}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Flatten@Lookup[myResolvedOptions, ContainerOutLabel],Flatten@destinationContainerAllObjects}],
        {_String, ObjectP[]}
      ]
    ]
  ];

  (* Get the updated simulation *)
  updatedSimulation = UpdateSimulation[currentSimulation,simulatedLabels];

  (* Return the Updated simulation (and simulated protocol object (Null) if experiment function is ExperimentInoculateLiquidMedia) *)
  If[MatchQ[experimentFunction,ExperimentInoculateLiquidMedia],
    {Null,updatedSimulation},
    updatedSimulation
  ]

];

(* ::Subsection:: *)
(*workCellResolver Function*)
resolvePickColoniesWorkCell[
  myInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[
  {workCell},

  workCell=Lookup[myOptions,WorkCell,Automatic];

  (* Determine the WorkCell that can be used *)
  If[MatchQ[workCell,Except[Automatic]],
    {workCell},
    (* Just the qpix *)
    {qPix}
  ]
];


(* ::Subsection:: *)
(*Method Resolver Function*)
resolvePickColoniesMethod[
  myInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[
  {method},

  method=Lookup[myOptions,Preparation,Automatic];

  (* Determine the Method that can be used *)
  If[MatchQ[method,Except[Automatic]],
    {method},
    (* Just Robotic *)
    {Robotic}
  ]
];

(* ::Subsection:: *)
(* Batching helper functions *)
(* ::Subsubsection:: *)
(* deepWellQ *)
(* Make some small helper functions *)
deepWellQ[plateObject:ObjectP[Object[Container,Plate]], fastAssoc_] := Module[{wellDepth},
  (* Get the WellDepth of the plate *)
  wellDepth = Experiment`Private`fastAssocLookup[fastAssoc, plateObject, {Model,WellDepth}];

  (* The plate is deep well is the well depth is at least 3.7 cm *)
  GreaterEqualQ[wellDepth, 3.7 Centimeter]
];
deepWellQ[plateObject:ObjectP[Model[Container,Plate]], fastAssoc_] := Module[{wellDepth},
  (* Get the WellDepth of the plate *)
  wellDepth = Experiment`Private`fastAssocLookup[fastAssoc, plateObject, WellDepth];

  (* The plate is deep well is the well depth is at least 3.7 cm *)
  GreaterEqualQ[wellDepth, 3.7 Centimeter]
];
deepWellQ[plateObjectList:{ObjectP[Object[Container,Plate]]..}, fastAssoc_] := Module[{wellDepth},
  (* Get the WellDepth of the plate *)
  wellDepth = Experiment`Private`fastAssocLookup[fastAssoc, First[plateObjectList], {Model,WellDepth}];

  (* The plate is deep well is the well depth is at least 3.7 cm *)
  GreaterEqualQ[wellDepth, 3.7 Centimeter]
];

(* ::Subsubsection:: *)
(* updateTrackInformation *)
updateTrackInformation[
  trackInformation_,
  deepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  nonDeepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  maxNumberOfTracks_Integer,
  output:Alternatives[Boolean, Track]
] := Module[
  {
    currentTrackInformation,allPlatesFitBool
  },
  (* The currentTrackInformation starts as the given trackInformation *)
  currentTrackInformation = trackInformation;

  (* Define a bool to keep track of if we can fit all the plates *)
  allPlatesFitBool = True;

  (* Try and fill all of the deep well positions *)
  Map[
    Function[{container},
      Module[{plateAddedBool},
        (* Add this deep well plate to the deck *)
        (* Define a variable to keep track if we have added this plate successfully *)
        plateAddedBool = False;

        (* Try to add to the rightmost track *)
        If[LessEqualQ[3, maxNumberOfTracks] && Length[currentTrackInformation[[3,2]]] < 4,
          (* If there is room, update track info accordingly *)
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {{}, Append[currentTrackInformation[[3,2]],container]};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 3 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* Try to add to the middle track *)
        If[!plateAddedBool && Length[currentTrackInformation[[2,2]]] < 4 && LessEqualQ[2, maxNumberOfTracks],
          (* If there is room, update track info accordingly *)
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {{}, Append[currentTrackInformation[[2,2]],container]};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 2 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* Try to add to the leftmost track *)
        If[!plateAddedBool && Length[currentTrackInformation[[1,2]]] < 4,
          (* If there is room, update track info accordingly *)
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {{}, Append[currentTrackInformation[[1,2]],container]};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 1 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* If the plate could not be added to any of the tracks, set the bool to False *)
        allPlatesFitBool = allPlatesFitBool && plateAddedBool;
      ]
    ],
    deepWellPlatesToAdd
  ];

  (* Try and fill all of the non deep well positions *)
  Map[
    Function[{container},
      Module[{plateAddedBool},
        (* Add this non deep well plate to the deck *)
        (* Define a variable to keep track if we have added this plate successfully *)
        plateAddedBool = False;

        (* Try to add to the rightmost track *)
        If[LessEqualQ[3, maxNumberOfTracks] && Length[currentTrackInformation[[3,1]]] < 4,
          (* If there is room, update track info accordingly *)
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {Append[currentTrackInformation[[3,1]],container], {}};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 3 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* Try to add to the middle track *)
        If[!plateAddedBool && Length[currentTrackInformation[[2,1]]] < 4 && LessEqualQ[2, maxNumberOfTracks],
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {Append[currentTrackInformation[[2,1]],container], {}};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 2 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* Try to add to the leftmost track *)
        If[!plateAddedBool && Length[currentTrackInformation[[1,1]]] < 4,
          Module[{updatedInfo},
            (* Get the updated list *)
            updatedInfo = {Append[currentTrackInformation[[1,1]],container], {}};

            (* If there is room, update track info accordingly *)
            currentTrackInformation = ReplacePart[currentTrackInformation, 1 -> updatedInfo];

            (* Mark that we have added the plate *)
            plateAddedBool = True;
          ]
        ];

        (* If the plate could not be added to any of the tracks, set the bool to False *)
        allPlatesFitBool = allPlatesFitBool && plateAddedBool;
      ]
    ],
    nonDeepWellPlatesToAdd
  ];


  (* Return based on the output *)
  If[MatchQ[output, Boolean],
    allPlatesFitBool,
    currentTrackInformation
  ]
];
(* ::Subsubsection:: *)
(* batchHasRoomQ *)
batchHasRoomQ[
  batch_,
  deepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  nonDeepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  maxNumberOfTracks_Integer
] := Module[{trackInformation},
  (* Get the track information of the group *)
  trackInformation = batch[[1]];

  (* See if this track information could validly be updated *)
  updateTrackInformation[trackInformation, deepWellPlatesToAdd, nonDeepWellPlatesToAdd, maxNumberOfTracks, Boolean]
];
(* ::Subsubsection:: *)
(* addSampleToBatch *)
addSampleToBatch[
  batch_,
  samplePacket_,
  deepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  nonDeepWellPlatesToAdd:{(ObjectP[{Object[Container]}] | _String)...},
  maxNumberOfTracks_Integer
] := Module[{startingTrackInformation,updatedTrackInformation},

  (* Get the starting track information *)
  startingTrackInformation = batch[[1]];

  (* Get the updated track information *)
  updatedTrackInformation = updateTrackInformation[startingTrackInformation, deepWellPlatesToAdd, nonDeepWellPlatesToAdd, maxNumberOfTracks, Track];

  (* Add the sample to the batch *)
  updatedTrackInformation -> Append[batch[[2]], samplePacket]
];
(* ::Subsubsection:: *)
(* newBatch *)
newBatch[numberOfTracks_Integer] := ConstantArray[{{},{}}, numberOfTracks] -> {};


(* ::Subsubsection:: *)
(* getCarrierAndRiserBatchingFields *)
getCarrierAndRiserBatchingFields[
  carrierDeckPlateLocations_List,
  experimentFunction:Alternatives[ExperimentPickColonies,ExperimentInoculateLiquidMedia,ExperimentStreakCells,ExperimentSpreadCells]
]:=Module[
  {
    currentTracks,carrier1Resource, carrier2Resource, carrier3Resource, riser1Resource,
    riser2Resource, riser3Resource, riser4Resource, riser5Resource, riser6Resource,
    riserPlacements, carrierPlacements, riserReturns, carrierReturns, uniqueCarriersAndRisers
  },

  (* First we need to make the resources *)
  (* If we are doing a pick unit operation, we will always pick 3 carriers and 6 risers *)
  (* If we are doing a spread unit operation, we will always pick 2 carriers and 4 risers *)
  {
    carrier1Resource,
    carrier2Resource,
    carrier3Resource,
    riser1Resource,
    riser2Resource,
    riser3Resource,
    riser4Resource,
    riser5Resource,
    riser6Resource
  } = If[MatchQ[experimentFunction,Alternatives[ExperimentPickColonies,ExperimentInoculateLiquidMedia]],
    {
      Resource[Sample -> Model[Container, Rack, "id:wqW9BPWNxGeA"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Plate Carrier"] *)
      Resource[Sample -> Model[Container, Rack, "id:wqW9BPWNxGeA"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Plate Carrier"] *)
      Resource[Sample -> Model[Container, Rack, "id:wqW9BPWNxGeA"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Plate Carrier"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]]  (* Model[Container, Rack, "QPix Riser"] *)
    },
    {
      Null,
      Resource[Sample -> Model[Container, Rack, "id:wqW9BPWNxGeA"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Plate Carrier"] *)
      Resource[Sample -> Model[Container, Rack, "id:wqW9BPWNxGeA"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Plate Carrier"] *)
      Null,
      Null,
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]], (* Model[Container, Rack, "QPix Riser"] *)
      Resource[Sample -> Model[Container, Rack, "id:pZx9joxwWpE4"], Rent -> True, Name -> CreateUUID[]] (* Model[Container, Rack, "QPix Riser"] *)
    }
  ];

  (* Set a tracking variable to keep track of which tracks are high and which are low *)
  currentTracks = {None,None,None};

  (* Get our placements and returns *)
  {
    riserPlacements,
    carrierPlacements,
    riserReturns,
    carrierReturns
  } = Transpose[MapIndexed[Function[{trackInformationWithContainers,index},
    Module[
      {
        nextBatchTracks,carriers,risers,frontRiserIndices,backRiserIndices,
        allRiserDeckPlacements,allCarrierDeckPlacements,allRiserReturns,allCarrierReturns
      },

      (* Create a tuple of the structure we need for this batch *)
      nextBatchTracks = MapIndexed[Function[{containerTuple, index},
        Switch[containerTuple,
          (* If we have a list of objects in the second half of the tuple, this means we need a deep well configuration (no risers) *)
          {{},{(ObjectP[]|_String)..}}, Low,
          (* If we have a list of objects in the first half of the tuple, this means we need a non deep well configuration (with risers) *)
          {{(ObjectP[]|_String)..},{}}, High,
          (* Otherwise, we just keep what this track currently is (no plates are set for this track) *)
          _, currentTracks[[First[index]]]
        ]
      ],
        trackInformationWithContainers
      ];

      (* Define a list of possible carriers *)
      carriers = {carrier1Resource,carrier2Resource,carrier3Resource};

      (* Define a list of the risers *)
      risers = {riser1Resource, riser2Resource, riser3Resource, riser4Resource, riser5Resource, riser6Resource};

      (* Front riser indices are 1, 3 and 5 *)
      frontRiserIndices = {1,3,5};

      (* Back riser indices are 2, 4, 6 *)
      backRiserIndices = {2,4,6};

      (* Define some helper functions to create the placements *)
      placeNewLowCarrier[trackIndex_Integer] := Module[{},
        (* If we are placing a new carrier then we just need to create a deck placement, no resource pickings *)
        {
          (* No riser needed *)
          {
            {Null,Null}
          },

          (* Carrier placement *)
          {
            {Link[carriers[[trackIndex]]], {"QPix Track Slot " <> ToString[trackIndex]}}
          },

          (* No risers to return *)
          {Null},

          (* No carriers to return *)
          {Null}
        }
      ];

      placeNewHighCarrier[trackIndex_Integer] := Module[{frontRiser,backRiser},
        (* If we are placing a new raised carrier then we need to place risers first, then the carrier, but no resource picking tasks *)

        (* Determine the risers to place based on the index *)
        frontRiser = risers[[frontRiserIndices[[trackIndex]]]];
        backRiser = risers[[backRiserIndices[[trackIndex]]]];

        (* Define the placements *)
        {
          (* Riser placements *)
          {
            (* Place front riser *)
            {Link[frontRiser], {"QPix Track Slot " <> ToString[trackIndex]}},

            (* Place back riser *)
            {Link[backRiser], {"QPix Track Rear Slot " <> ToString[trackIndex]}}
          },

          (* Carrier placement *)
          {
            (* Place the carrier on the front riser *)
            {Link[carriers[[trackIndex]]], {"QPix Track Slot " <> ToString[trackIndex], "A1"}}
          },

          (* No risers to return *)
          {Null},

          (* No carriers to return *)
          {Null}
        }
      ];

      replaceLowCarrier[trackIndex_Integer] := Module[{deckPlacements},
        (* If we are replacing a low carrier with the a high carrier, then we need to first have a resource picking *)
        (* task to remove the carrier, then we can place the risers and the carrier back on the deck *)

        (* Get the deck placements *)
        deckPlacements = placeNewHighCarrier[trackIndex][[1;;2]];

        (* Return the deck placements and the item to resource pick *)
        Join[
          deckPlacements,

          (* No risers to return *)
          {{Null}},

          (* Carrier to return *)
          {{carriers[[trackIndex]]}}
        ]
      ];

      replaceHighCarrier[trackIndex_Integer] := Module[{deckPlacements},
        (* If we are replacing a high carrier with a low carrier, then we need to first remove the existing carrier *)
        (* then remove the two risers, then place the carrier again on the low position *)
        (* NOTE: ORDER MATTERS *)

        (* Get the deck placements *)
        deckPlacements = placeNewLowCarrier[trackIndex][[1;;2]];

        (* Return the deck placements and the items to resource pick *)
        Join[deckPlacements,

          (* Return both risers *)
          {
            {
              risers[[frontRiserIndices[[trackIndex]]]],
              risers[[backRiserIndices[[trackIndex]]]]
            }
          },

          (* Return the carrier *)
          {
            {
              carriers[[trackIndex]]
            }
          }
        ]
      ];

      (* Next, mapthread through the current tracks and the nextBatchTracks to determine the movements *)
      {
        allRiserDeckPlacements,
        allCarrierDeckPlacements,
        allRiserReturns,
        allCarrierReturns
      }=Transpose@MapThread[
        Function[{oldTrack, newTrack, index},
          Switch[{oldTrack,newTrack},
            (* If neither are set, just do nothing *)
            {None,None}, {{{Null,Null}}, {{Null,Null}}, {Null}, {Null}},

            (* If the oldTrack is empty, but we have a carrier to put on, do it *)
            {None, High}, placeNewHighCarrier[index],
            {None, Low}, placeNewLowCarrier[index],

            (* If we need to swap a low carrier for a high carrier *)
            {Low, High}, replaceLowCarrier[index],

            (* If we need to swap a high carrier with a low carrier *)
            {High, Low}, replaceHighCarrier[index],

            (* Otherwise, do nothing the track should stay how it is *)
            _, {{{Null,Null}}, {{Null,Null}}, {Null}, {Null}}
          ]
        ],
        {
          currentTracks,
          nextBatchTracks,
          Range[3]
        }
      ];

      (* Update the current tracks *)
      currentTracks = nextBatchTracks;

      (* Return the placement and resource picking lists *)
      {
        Join@@allRiserDeckPlacements /. {{Null,Null} -> Nothing},
        Join@@allCarrierDeckPlacements /. {{Null,Null} -> Nothing},
        Join@@allRiserReturns /. {Null -> Nothing},
        Join@@allCarrierReturns /. {Null -> Nothing}
      }
    ]
  ],
    carrierDeckPlateLocations
  ]];

  (* Get all of the unique carriers and risers we will need *)
  uniqueCarriersAndRisers = Cases[{riserPlacements,carrierPlacements},_Resource,Infinity];

  (* Return the placements, returns, and unique resources *)
  {
    riserPlacements,
    carrierPlacements,
    riserReturns,
    carrierReturns,
    uniqueCarriersAndRisers
  }
];
(* ::Subsubsection:: *)
(* getColonyHandlerHeadCassetteBatchingFields *)
getColonyHandlerHeadCassetteBatchingFields[
  finalPhysicalGroups_List,
  toolResourceRules:{_Rule...},
  colonyHandlerResource: _Resource,
  colonyHandlerHeadCassetteField_Symbol
] := Module[{currentColonyHandlerHeadCassette},
  (* Keep track of the current colony handler head cassette in the instrument *)
  currentColonyHandlerHeadCassette = Null;

  (* Loop over the physical batches and create our lists *)
  Transpose@Map[
    Function[{physicalGroup},
      Module[{nextGroupColonyHandlerHeadCassette,toolToAdd,toolToRemove},
        (* Lookup the ColonyHandlerHeadCassette from the physical group *)
        nextGroupColonyHandlerHeadCassette = Lookup[First[First[physicalGroup]],colonyHandlerHeadCassetteField];

        (* Determine if we need to remove the current colony handler head cassette *)
        (* If the tools don't match we have to remove - otherwise don't remove *)
        {
          toolToAdd,
          toolToRemove
        } = If[!MatchQ[currentColonyHandlerHeadCassette,ObjectP[nextGroupColonyHandlerHeadCassette]],
          {
            {Link[nextGroupColonyHandlerHeadCassette/.toolResourceRules],Link[colonyHandlerResource],"QPix ColonyHandlerHeadCassette Slot"},
            Link[currentColonyHandlerHeadCassette]
          },
          {{Null,Null,Null},Null}
        ];

        (* Update the current tool *)
        currentColonyHandlerHeadCassette = nextGroupColonyHandlerHeadCassette;

        (* Return the tool to remove and the placement of the tool to add *)
        {
          toolToAdd,
          toolToRemove
        }
      ]
    ],
    finalPhysicalGroups
  ]
]
(* ::Subsubsection:: *)
(* getCarrierContainerDeckPlacements *)
getCarrierContainerDeckPlacements[carrierDeckPlateLocations_List] := Map[
  Function[{carrierDeckPlateLocationsPerPhysicalBatch},
    Flatten[MapIndexed[Function[{platesForTrack,trackIndex},
      Module[{carrierRaisedQ,carrierPositions},
        (* Determine if we are placing containers on raised carriers or low carriers *)
        carrierRaisedQ = MatchQ[platesForTrack,{{ObjectP[Object[Container]] | _String..},{}}];

        (* Define the Carrier positions *)
        (* NOTE: This is in reverse order because that is the order the qpix fills the plates *)
        carrierPositions = {"D1", "C1", "B1", "A1"};

        (* Loop through each of the containers and make a placement field *)
        MapIndexed[
          Function[{container,carrierIndex},
            If[carrierRaisedQ,
              {container, {"QPix Track Slot " <> ToString[First[trackIndex]], "A1", carrierPositions[[First[carrierIndex]]]}},
              {container, {"QPix Track Slot " <> ToString[First[trackIndex]], carrierPositions[[First[carrierIndex]]]}}
            ]
          ],
          (Flatten@platesForTrack)
        ]
      ]
    ],
      carrierDeckPlateLocationsPerPhysicalBatch
    ],1]
  ],
  carrierDeckPlateLocations
]
(* ::Subsection:: *)
(* Sister Functions *)

(* ::Subsubsection:: *)
(* ExperimentPickColoniesOptions *)
DefineOptions[ExperimentPickColoniesOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentPickColonies}
];


ExperimentPickColoniesOptions[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ExperimentPickColoniesOptions]
]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Send in the correct Output option and remove the OutputFormat option*)
  preparedOptions=Normal[KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}],Association];

  resolvedOptions=ExperimentPickColonies[myInputs,preparedOptions];

  (*Return the option as a list or table*)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentPickColonies],
    resolvedOptions
  ]
];

(* ::Subsubsection:: *)
(* ValidExperimentPickColoniesQ *)
DefineOptions[ValidExperimentPickColoniesQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions:>{ExperimentPickColonies}
];


ValidExperimentPickColoniesQ[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ValidExperimentPickColoniesQ]
]:=Module[
  {listedOptions,preparedOptions,experimentPickColoniesTests,initialTestDescription,allTests,verbose,outputFormat},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Remove the output option before passing to the core function because it doesn't make sense here*)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (*Call the ExperimentPickColonies function to get a list of tests*)
  experimentPickColoniesTests=Quiet[
    ExperimentPickColonies[myInputs,Append[preparedOptions,Output->Tests]],
    {LinkObject::linkd,LinkObject::linkn}
  ];

  (*Define the general test description*)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test*)
  allTests=If[MatchQ[experimentPickColoniesTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[{initialTest,validObjectBooleans,voqWarnings},

      (*Generate the initial test, which should pass if we got this far*)
      initialTest=Test[initialTestDescription,True,True];

      (*Create warnings for invalid objects*)
      validObjectBooleans=ValidObjectQ[Cases[Flatten[myInputs],ObjectP[]],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {Cases[Flatten[myInputs],ObjectP[]],validObjectBooleans}
      ];

      (*Get all the tests/warnings*)
      Cases[Flatten[{initialTest,experimentPickColoniesTests,voqWarnings}],_EmeraldTest]
    ]
  ];

  (*Look up the test-running options*)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (*Run the tests as requested*)
  Lookup[RunUnitTest[<|"ValidExperimentPickColoniesQ"->allTests|>,Verbose->verbose,
    OutputFormat->outputFormat],"ValidExperimentPickColoniesQ"]
];
(* ::ExperimentPickColoniesPreview *)
DefineOptions[ExperimentPickColoniesPreview,
  SharedOptions :> {ExperimentPickColonies}
];

ExperimentPickColoniesPreview[myInputs : ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions : OptionsPattern[ExperimentPickColoniesPreview]] := Module[
  {listedOptions, noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (* return only the options for ExperimentGrind *)
  ExperimentPickColonies[myInputs, Append[noOutputOptions, Output -> Preview]]
];