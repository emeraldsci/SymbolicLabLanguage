(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Define Options*)
DefineOptions[ExperimentSpreadCells,
  Options :> {
    {
      OptionName -> Instrument,
      Default -> Automatic,
      Description -> "The instrument that is used to transfer cells in suspension to a solid agar gel and then evenly spread the suspension across the plate.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]}]
      ],
      Category -> "Instrument"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* Dilution Shared Options *)
      ModifyOptions[DilutionSharedOptions,
        OptionName -> DilutionType,
        Default -> Automatic,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> DilutionStrategy
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> NumberOfDilutions,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1,96,1]
        ],
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> TargetAnalyte,
        ModifiedOptionName -> DilutionTargetAnalyte,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> CumulativeDilutionFactor,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> SerialDilutionFactor,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> TargetAnalyteConcentration,
        ModifiedOptionName -> DilutionTargetAnalyteConcentration,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> TransferVolume,
        ModifiedOptionName -> DilutionTransferVolume,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> TotalDilutionVolume,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> FinalVolume,
        ModifiedOptionName -> DilutionFinalVolume,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> DiscardFinalTransfer,
        ModifiedOptionName -> DilutionDiscardFinalTransfer
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> Diluent
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> DiluentVolume
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> ConcentratedBuffer,
        ModifiedOptionName -> DilutionConcentratedBuffer
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> ConcentratedBufferVolume
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> ConcentratedBufferDiluent
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> ConcentratedBufferDilutionFactor
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> ConcentratedBufferDiluentVolume
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> Incubate,
        ModifiedOptionName -> DilutionIncubate,
        AllowNull -> True
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> IncubationTime,
        ModifiedOptionName -> DilutionIncubationTime
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> IncubationInstrument,
        ModifiedOptionName -> DilutionIncubationInstrument
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> IncubationTemperature,
        ModifiedOptionName -> DilutionIncubationTemperature
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> MixType,
        ModifiedOptionName -> DilutionMixType
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> NumberOfMixes,
        ModifiedOptionName -> DilutionNumberOfMixes
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> MixRate,
        ModifiedOptionName -> DilutionMixRate
      ],
      ModifyOptions[DilutionSharedOptions,
        OptionName -> MixOscillationAngle,
        ModifiedOptionName -> DilutionMixOscillationAngle
      ],
      (* --- Source Options --- *)
      {
        OptionName -> SpreadVolume,
        Default -> Automatic, 
        Description -> "For each sample, the volume of suspended cells to transfer to the agar gel to be spread.",
        (* TODO: Formalize this *)
        ResolutionDescription -> "For now resolves to 100 Microliter",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[10 Microliter, 130 Microliter],
          Units -> Microliter
        ],
        Category -> "Source"
      },
      {
        OptionName -> SourceMix,
        Default -> Automatic,
        Description -> "For each sample, indicates whether the source cells should be mixed by pipette before being transferred to the agar gel to be spread.",
        ResolutionDescription -> "Automatically set to True if either MixVolume or NumberOfMixes are specified. False otherwise.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Category -> "Source"
      },
      {
        OptionName -> SourceMixVolume,
        Default -> Automatic, (* adjust with testing *)
        Description -> "For each sample, the amount of liquid to aspirate and dispense when mixing by pipette before being transferred to the agar gel to be spread.",
        ResolutionDescription -> "Automatically set to the minimum of 130 Microliter and 1/4th of the source sample volume. If 1/4th of the source sample volume is less than 10 Microliter, automatically set to 10 Microliter.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[10 Microliter, 130 Microliter],
          Units -> Microliter
        ],
        Category -> "Source"
      },
      {
        OptionName -> NumberOfSourceMixes,
        Default -> Automatic, (* Adjust with testing *)
        Description -> "For each sample, the number of times the source should be mixed by pipette before being transferred to the agar gel to be spread.",
        ResolutionDescription -> "If SourceMix is True, automatically set to 4.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0,1]
        ],
        Category -> "Source"
      },
      (* --- Spreading Options --- *)
      {
        OptionName -> ColonySpreadingTool,
        Default -> Automatic,
        Description -> "For each sample, the tool used to spread the suspended cells from the input sample onto the destination plate or into a destination well.",
        ResolutionDescription -> "If DestinationContainer is an 8 well solid media tray, resolves to Model[Part, ColonyHandlerHeadCassette, \"8-pin spreading head\"]. Otherwise resolves to Model[Part, ColonyHandlerHeadCassette, \"1-pin spreading head\"].",
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
              "Colony Spreading Head Cassettes"
            }
          }

        ],
        Category -> "Spreading"
      },
      {
        OptionName -> HeadDiameter,
        Default -> Automatic,
        Description -> "For each sample, the width of the metal probe that will spread the cells.",
        ResolutionDescription -> "Resolves from the ColonySpreadingTool[HeadDiameter].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Millimeter],
          Units -> Millimeter
        ],
        Category -> "Spreading"
      },
      {
        OptionName -> HeadLength,
        Default -> Automatic,
        Description -> "For each sample, the length of the metal probe that will spread the cells.",
        ResolutionDescription -> "Resolves from the ColonySpreadingTool[HeadLength].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Millimeter],
          Units -> Millimeter
        ],
        Category -> "Spreading"
      },
      {
        OptionName -> NumberOfHeads,
        Default -> Automatic,
        Description -> "For each sample, the number of metal probes on the ColonyHandlerHeadCassette that will spread the cells.",
        ResolutionDescription -> "Resolves from the ColonySpreadingTool[NumberOfHeads].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0,1]
        ],
        Category -> "Spreading"
      },
      {
        OptionName -> ColonyHandlerHeadCassetteApplication,
        Default -> Automatic,
        Description -> "For each sample, the designed use of the ColonySpreadingTool.",
        ResolutionDescription -> "Resolves from the ColonySpreadingTool[Application].",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> ColonyHandlerHeadCassetteTypeP (* Picking | Spreading | Streaking *)
        ],
        Category -> "Spreading"
      },
      {

        OptionName -> DispenseCoordinates,
        Default ->  Automatic,
        Description -> "For each sample, the location to dispense the suspended cells to be spread on the destination plate.",
        ResolutionDescription -> "Automatically set to the first coordinate of the resolved SpreadPattern.",
        AllowNull -> False,
        Widget -> Adder[
          {
            "XCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-63 Millimeter, 63 Millimeter],Units -> Millimeter],
            "YCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-43 Millimeter, 43 Millimeter],Units -> Millimeter]
          }
        ],
        Category -> "Spreading"
      },
      {
        OptionName -> SpreadPatternType,
        Default -> Spiral, (* I chose this at random *)
        Description -> "For each sample, the pattern the spreading colony handler head will move when spreading the colony on the plate. Can be specified as a pre-determined pattern or Custom to indicate the coordinates in CustomSpreadPattern should be used.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> SpreadPatternP (* Spiral | VerticalZigZag | HorizontalZigZag | Custom *)
        ],
        Category -> "Spreading"
      },
      {
        OptionName -> CustomSpreadPattern,
        Default -> Automatic,
        Description -> "For each sample, the user defined pattern used to spread the suspended cells across the plate. Specify a series of Spread[{{xCoordinate,yCoordinate}}..] to specify the pattern. In order to draw separate lines, specify series of coordinates in different Spread[...]'s. Between each Spread[...], the pin on colony spreading tool will be lifted off of the agar and then repositioned at the first coordinate of the next Spread[...].",
        AllowNull -> True,
          Widget -> Alternatives[
            "Single Spread stroke" -> Widget[
              Type -> Head,
              Head -> Spread,
              Widget -> Adder[
                {
                  "XCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-63 Millimeter, 63 Millimeter],Units -> Millimeter],
                  "YCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-43 Millimeter, 43 Millimeter],Units -> Millimeter]
                }
              ]
            ],
            "Multiple Spread strokes" -> Adder[
              Widget[
                Type -> Head,
                Head -> Spread,
                Widget -> Adder[
                  {
                    "XCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-63 Millimeter, 63 Millimeter],Units -> Millimeter],
                    "YCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-43 Millimeter, 43 Millimeter],Units -> Millimeter]
                  }
                ]
              ]
            ]
          ],
        Category -> "Spreading"
      },

      (* --- Destination Options --- *)
      {
        OptionName -> DestinationContainer,
        Default -> Automatic,
        Description -> "For each Sample, the desired type of container to have suspended cells spread in, with indices indicating grouping of samples in the same plate, if desired.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Container], Object[Container]}],
            ObjectTypes -> {Model[Container], Object[Container]},
            PreparedSample -> False,
            PreparedContainer -> True
          ],
          {
            "Index" -> Alternatives[
              Widget[
                Type -> Number,
                Pattern :> GreaterEqualP[1, 1]
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ],
            "Container" -> Alternatives[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Container]}],
                ObjectTypes -> {Model[Container]},
                PreparedSample -> False,
                PreparedContainer -> True
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ]
          }
        ],
        Category -> "Destination"
      },
      {
        OptionName -> DestinationWell,
        Default -> Automatic,
        Description -> "For each Sample, the well of the DestinationContainer to spread the suspended cells.",
        ResolutionDescription -> "Automatically set to A1.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> WellPositionP,
          Size -> Word,
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Category -> "Destination"
      },
      {
        OptionName -> DestinationMedia,
        Default -> Automatic,
        Description -> "For each sample, the media on which the cells are spread.",
        ResolutionDescription -> "Automatically set to the PreferredSolidMedia field of the first Model[Cell] of the composition of the Sample.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
        ],
        Category -> "Destination"
      },

      (* --- Label Options --- *)
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> String,Pattern :> _String,Size -> Line],
        Description -> "For each sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> String,Pattern :> _String,Size -> Line],
        Description -> "For each sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Single Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description -> "For each sample, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> ContainerOutLabel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Single Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description -> "For each sample, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        UnitOperation -> True
      },
      (* Add DilutionConflictErrors hidden option *)
      {
        OptionName -> DilutionConflictErrors,
        Widget -> {
          "Boolean" -> Widget[Type->Enumeration,Pattern:>BooleanP],
          "InvalidOptions" -> Adder[Widget[Type->Expression,Pattern:>_Symbol,Size->Line]]
        },
        Default -> Null,
        AllowNull -> True,
        Description -> "For each sample, the conflicting dilution options.",
        Category -> "Hidden"
      }
    ],
    (* Redefine Preparation and Workcell options because PickColonies can only occur robotically on the qpix *)
    {
      OptionName -> Preparation,
      Default -> Robotic,
      Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
      AllowNull -> False,
      Category -> "General",
      Widget->Widget[
        Type->Enumeration,
        Pattern:>Alternatives[Robotic]
      ]
    },
    {
      OptionName -> WorkCell,
      Widget -> Widget[Type -> Enumeration,Pattern :> Alternatives[qPix]],
      AllowNull -> False,
      Default -> qPix,
      Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
      Category -> "General"
    },
    ProtocolOptions,
    SubprotocolDescriptionOption,
    SimulationOption,
    SamplesInStorageOptions,
    SamplesOutStorageOptions,
    PostProcessingOptions,
    QPixSanitizationSharedOptions
  }
];

(* ::Subsection::Closed:: *)
(*Warning and Error Messages*)
Error::SourceMixMismatch = "The sample(s), `1`, at indices, `5`, have conflicting source mixing options. SourceMix is `2`, while SourceMixVolume is `3` and NumberOfSourceMixes is `4`. If SourceMix is True, neither SourceMixVolume or NumberOfSourceMixes can be Null. If SourceMix is False, neither SourceMixVolume or NumberOfSourceMixes can be specified. Please fix these conflicting options to submit a valid experiment.";
Error::ColonyHandlerHeadCassetteMismatch = "The sample(s), `1`, at indices, `7`, have conflicting colony handler head cassette options. ColonySpreadingTool is set to `2`, while HeadDiameter is `3`, HeadLength is `4`, NumberOfHeads is `5`, and ColonyHandlerHeadCassetteApplication is `6`. The values of HeadDiameter, HeadLength, NumberOfHeads, and ColonyHandlerHeadCassetteApplication must match the values stored in the ColonySpreadingTool. Please fix these options to submit a valid experiment.";
Error::NoColonyHandlerSpreadingHeadFound = "For the sample(s), `1`, at indices, `2`, no ColonyHandlerHeadCassette could be found that matches the given values of HeadDiameter, HeadLength, NumberOfHeads, and ColonyHandlerHeadCassetteApplication. Please adjust these options so a valid ColonySpreadingTool can be found. The valid ColonySpreadingTools can be found with Search[Object[Part,ColonyHandlerHeadCassette],Application == Spread].";
Error::NoColonyHandlerStreakingHeadFound = "For the sample(s), `1`, at indices, `2`, no ColonyHandlerHeadCassette could be found that matches the given values of HeadDiameter, HeadLength, NumberOfHeads, and ColonyHandlerHeadCassetteApplication. Please adjust these options so a valid ColonyStreakingTool can be found. The valid ColonyStreakingTools can be found with Search[Object[Part,ColonyHandlerHeadCassette],Application == Streak].";
Error::SpreadPatternMismatch = "The sample(s), `1`, at indices, `4`, have conflicting spread pattern options. SpreadPatternType is `2`, while CustomSpreadPattern is `3`. If SpreadPatternType is Custom, a CustomSpreadPattern must be specified. If CustomSpreadPattern is not Custom, a CustomSpreadPattern cannot be specified. Please fix these conflicting options to submit a valid experiment.";
Error::StreakPatternMismatch = "The sample(s), `1`, at indices, `6`, have conflicting streak pattern options. StreakPatternType is `2`, while CustomSpreadPattern is `3`, NumberOfSegments is `4`, and HatchesPerSegment is `5`. If StreakPatternType is Custom, a CustomStreakPattern must be specified and NumberOfSegments and HatchesPerSegment cannot be specified. If StreakPatternType is RotatedHatches or LinearHatches, a CustomStreakPattern cannot be specified and NumberOfSegments and HatchesPerSegment must be specified. If StreakPatternType is Radiant, CustomStreakPattern, NumberOfSegments, and HatchesPerSegment cannot be specified. Please fix these conflicting options to submit a valid experiment.";
Error::InvalidDestinationContainerType = "The sample(s), `1`, at indices, `3`, have invalid destination containers. If DilutionStrategy is Series, DestinationContainer must be specified as a Model[Container]. However, DestinationContainer is set to `2`. Please fix this conflict to submit a valid experiment.";
Error::NoAvailablePositionsInContainer = "The sample(s), `1`, at indices, `2`, have destination containers that do not have any available positions to spread cells. Please specify a Model[Container], an Object[Container] with open positions, or an Object[Container] that contains solid media to submit a valid experiment.";
Error::DilutionFinalVolumeTooSmall = "The sample(s), `1`, at indices, `7`, have conflicting `2`/DispenseCoordinates and DilutionFinalVolume/DilutionStrategy options. `2` is `3`, DispenseCoordinates is `4`, DilutionFinalVolume is `5`, and DilutionStrategy is `6`. If DilutionStrategy is Series, every final dilution volume in the series must be greater than the `2` times the number of dispense locations. If DilutionStrategy is Endpoint, the final dilution volume in the series must be greater than the `2` times the number of dispense locations. Please scale the dilution such that these conditions hold.";
Error::DilutionMismatch = "The sample(s), `1`, at indices, `3`, have conflicting Dilution options. DilutionType is Null while the option(s), `2`, are specified. Or DilutionType is not Null while the option(s) are Null. Please fix these conflicting options to submit a valid experiment.";
Warning::SpreadingMultipleSamplesOnSamePlate = "For the sample(s), `1`, at indices, `3`, have an Object[Container] specified for the DestinationContainer, `2`, option that is also specified as the DestinationContainer for another input sample. The samples will be spread on the same plate.";
Error::InvalidDestinationContainer = "The sample(s), `1`, at indices, `3`, have a destination container with more than one well. DestinationContainer is `2`. Please specify a destination container that contains a single well to submit a valid experiment.";
Error::InvalidDestinationWell = "The sample(s), `1`, at indices, `4`, have conflicting DestinationWell and DestinationContainer options. DestinationWell is `2`, however, `2` is not a position in the DestinationContainer, `3`. Please fix these conflicting options to submit a valid experiment.";
Error::ConflictingDestinationMedia = "The sample(s), `1`, at indices, `5`, have conflicting DestinationMedia and DestinationContainer options. DestinationMedia is `2`, however, that is not the model as the sample in well `3` of destination container `4`. Please fix these conflicting options to submit a valid experiment.";
Error::DestinationMediaNotSolid = "For the sample(s), `1`, at indices, `3`, the specified DestinationMedia, `2`, is not Solid. Please specify a DestinationMedia with Solid State to submit a valid experiment.";
Error::TotalDilutionVolumeTooLarge = "For the sample(s), `1`, at indices, `3`, there is a TotalDilutionVolume too large to fit in a sterile Deep Well Plate (), in `2`. Please scale the dilution such that all TotalDilutionVolumes are less than 1.9 Milliliter.";
Error::SampleOutLabelMismatch = "For the sample(s), `1`, at indices, `5`, the given SampleOutLabel, `2` does not match the DilutionStrategy, `3`, and the NumberOfDilutions, `4`. If DilutionStrategy is Series, the length of SampleOutLabel must be NumberOfDilutions + 1. If DilutionStrategy is Endpoint, the length of SampleOutLabel must be 1. If DilutionStrategy is Null (or DilutionType is Linear), the length of SampleOutLabel must be NumberOfDilutions. Please specify a valid SampleOutLabel to submit a valid experiment.";
Error::ContainerOutLabelMismatch = "For the sample(s), `1`, at indices, `5`, the given ContainerOutLabel, `2` does not match the DilutionStrategy, `3`, and the NumberOfDilutions, `4`. If DilutionStrategy is Series, the length of ContainerOutLabel must be NumberOfDilutions + 1. If DilutionStrategy is Endpoint, the length of ContainerOutLabel must be 1. If DilutionStrategy is Null (or DilutionType is Linear), the length of ContainerOutLabel must be NumberOfDilutions. Please specify a valid ContainerOutLabel to submit a valid experiment.";

(* ::Subsection::Closed:: *)
(*Experiment Function*)

(* Container Overload *)
ExperimentSpreadCells[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedContainers,listedOptions,simulation,
    containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedContainers, listedOptions}=removeLinks[ToList[myContainers], ToList[myOptions]];

  (* Lookup simulation option if it exists *)
  simulation = Lookup[listedOptions,Simulation,Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
      ExperimentSpreadCells,
      listedContainers,
      listedOptions,
      Output->{Result,Tests},
      Simulation->simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      containerToSampleOutput=containerToSampleOptions[
        ExperimentSpreadCells,
        listedContainers,
        listedOptions,
        Output->Result,
        Simulation->simulation
      ],
      $Failed,
      {Error::EmptyContainer}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentSpreadCells[samples,ReplaceRule[sampleOptions,Simulation->simulation]]
  ]
];

(* CORE Overload *)
ExperimentSpreadCells[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedSamplesNamed,listedOptionsNamed,safeOpsNamed,safeOpsTests,
    listedSamples,safeOps,validLengths,validLengthTests,returnEarlyQ,performSimulationQ,
    templatedOptions,templateTests,simulation,currentSimulation,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,updatedSimulation,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,unitOperationPacket,batchedUnitOperationPackets,
    resourcePacketTests,uploadQ,runTime
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedSamplesNamed, listedOptionsNamed}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentSpreadCells,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentSpreadCells,listedOptionsNamed,AutoCorrect->False],{}}
  ];

  (* replace all objects referenced by Name to ID *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentSpreadCells,{listedSamples},safeOps,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentSpreadCells,{listedSamples},safeOps],Null}
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
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentSpreadCells,{ToList[listedSamples]},safeOps,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentSpreadCells,{ToList[listedSamples]},safeOps],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Lookup simulation *)
  simulation = Lookup[safeOps,Simulation];

  (* Initialize it if it doesn't exist *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];


  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentSpreadCells,{ToList[listedSamples]},inheritedOptions]];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* TODO: FILL THIS IN ONCE THE RESOLVE<TYPE>OPTIONS AND <TYPE>RESOURCE PACKETS ARE FINISHED *)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall={}; (* Quiet[Flatten[{samplePreparationCache,Download[..., Cache\[Rule]Lookup[expandedSafeOps, Cache, {}], Simulation\[Rule]updatedSimulation]}],Download::FieldDoesntExist] *)

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentSpreadAndStreakCellsOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->currentSimulation,Output->{Result,Tests},ExperimentFunction -> ExperimentSpreadCells];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentSpreadAndStreakCellsOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->currentSimulation,ExperimentFunction -> ExperimentSpreadCells],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentSpreadCells,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentSpreadCells,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
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
  (* NOTE: We need to perform simulation if Result is asked for in SpreadCells since it's part of the CellPreparation experiments. *)
  (* This is because we pass down our simulation ExperimentRCP. *)
  performSimulationQ=MemberQ[output, Result|Simulation];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentSpreadCells,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  (* NOTE: Because Spread/Streak Cells can currently only happen robotically, resourcePackets only contains UnitOperationPackets *)
  {{unitOperationPacket, batchedUnitOperationPackets, runTime},resourcePacketTests}=If[returnEarlyQ,
    {{$Failed, $Failed}, {}},
    If[gatherTests,
      streakAndSpreadCellsResourcePackets[listedSamples,listedOptionsNamed,resolvedOptions,ExperimentSpreadCells,Cache->cacheBall,Simulation->currentSimulation,Output->{Result,Tests}],
      {streakAndSpreadCellsResourcePackets[listedSamples,listedOptionsNamed,resolvedOptions,ExperimentSpreadCells,Cache->cacheBall,Simulation->currentSimulation],{}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  updatedSimulation = If[performSimulationQ,
    simulateExperimentSpreadAndStreakCells[unitOperationPacket,ToList[mySamples],resolvedOptions,ExperimentSpreadCells,Cache->cacheBall,Simulation->currentSimulation],
    Null
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentSpreadCells,collapsedResolvedOptions],
      Preview -> Null,
      Simulation->updatedSimulation
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps,Upload];

  (* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[unitOperationPacket,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
      $Failed,

    (* If Upload->False, return the unit operation packets without RequireResources called*)
    !uploadQ,
      unitOperationPacket,

    (* Otherwise, upload an ExperimentRoboticCellPreparation *)
    True,
      Module[
        {
          primitive,nonHiddenOptions
        },
        (* Create the SpreadCells primitive to feed into RoboticCellPreparation *)
        primitive=SpreadCells@@Join[
          {
            Sample->Download[ToList[mySamples],Object]
          },
          RemoveHiddenPrimitiveOptions[SpreadCells,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentSpreadCells,collapsedResolvedOptions];

        (* Memoize the value of ExperimentPickColonies so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentSpreadCells,$PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          ExperimentSpreadCells[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification=Lookup[ToList[options],Output];

            frameworkOutputSpecification/.{
              Result -> Flatten[{unitOperationPacket,batchedUnitOperationPackets}],
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> updatedSimulation,
              RunTime -> 1 Hour (* TODO: Make this accurate *)
            }
          ];

          ExperimentRoboticCellPreparation[
            {primitive},
            Name->Lookup[safeOps,Name],
            Instrument -> Lookup[collapsedResolvedOptions,Instrument],
            Upload->Lookup[safeOps,Upload],
            Confirm->Lookup[safeOps,Confirm],
            ParentProtocol->Lookup[safeOps,ParentProtocol],
            Priority->Lookup[safeOps,Priority],
            StartDate->Lookup[safeOps,StartDate],
            HoldOrder->Lookup[safeOps,HoldOrder],
            QueuePosition->Lookup[safeOps,QueuePosition],
            Cache->cacheBall,
            CoverAtEnd->False
          ]
        ]
      ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentSpreadCells,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> updatedSimulation,
    RunTime -> runTime
  }
];


(* ::Subsection::Closed:: *)
(*OptionResolver*)

DefineOptions[
  resolveExperimentSpreadAndStreakCellsOptions,
  Options:>{
    {
      OptionName->ExperimentFunction,
      Default->ExperimentSpreadCells,
      AllowNull->True,
      Widget->Widget[
        Type->Expression,
        Pattern:>_,
        Size->Line
      ],
      Description->"The experiment function that we're actually calling."
    },
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

resolveExperimentSpreadAndStreakCellsOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentSpreadAndStreakCellsOptions]]:=Module[
  {
    (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
    outputSpecification,output,gatherTests,messages,cache,simulation,currentSimulation,experimentFunction,
    spreadAndStreakOptionsAssociation,spreadAndStreakColonyHandlerHeadCassettes,
    colonySpreadingAndStreakingTools,destinationMedias,destinationContainers,
    primaryWashSolutions,secondaryWashSolutions,tertiaryWashSolutions,
    quaternaryWashSolutions, allDestinationContainersNoLink,uniqueDestinationContainerObjects,
    uniqueDestinationContainerModels,defaultWashSolutions,allWashSolutionsNoLink,uniqueWashSolutionObjects,uniqueWashSolutionModels,
    allDestinationMediaNoLink,uniqueDestinationMediaObjects,uniqueDestinationMediaModels,
    allColonySpreadingAndStreakingToolsNoLink,uniqueColonySpreadingAndStreakingToolObjects,uniqueColonySpreadingAndStreakingToolModels,
    sampleObjectDownloadPacket,sampleModelDownloadPacket,sampleContainerObjectDownloadPacket,sampleContainerModelDownloadPacket,
    containerDownloadPacket,containerModelDownloadPacket,colonyHandlerHeadCassetteObjectDownloadPacket,
    colonyHandlerHeadCassetteModelDownloadPacket,samplePackets,washSolutionObjectPackets,washSolutionModelPackets,
    destinationMediaObjectPackets,destinationMediaModelPackets,destinationContainerObjectPackets,
    destinationContainerModelPackets,colonySpreadAndStreakToolObjectPackets,colonySpreadAndStreakToolModelPackets,
    spreadAndStreakColonyHandlerHeadCassettesPackets,flattenedCachePackets,combinedCache,combinedFastAssoc,

    (*-- INPUT VALIDATION CHECKS --*)
    discardedSamplePackets,discardedInvalidInputs,discardedTest,nonLiquidSamplePackets,nonLiquidInvalidInputs,
    nonLiquidTest,optionPrecisions,roundedSpreadAndStreakOptions,optionPrecisionTests,

    (*-- RESOLVE INDEPENDENT OPTIONS --*)
    instrument,preparation,workCell,samplesInStorageCondition,samplesOutStorageCondition,
    resolvedInstrument,resolvedPreparation,resolvedWorkCell,resolvedSamplesInStorageCondition,resolvedSamplesOutStorageCondition,
    compatibleMaterialsBools,compatibleMaterialsTests,

    (*-- RESOLVE SANITIZATION AND DILUTION OPTIONS --*)
    sanitizationOptionInvalidOptions,sanitizationOptionTests,sanitizationOptionInvalidInputs,
    resolvedSanitizationOptions,partiallyResolvedSpreadAndStreakCellsOptionsWithSanitization,
    dilutionOptionsToResolve,resolvedDilutionOptions,allDilutionConflictErrors,
    resolvedDilutionTypes,
    resolvedDilutionStrategies,
    resolvedNumberOfDilutions,
    resolvedDilutionTargetAnalytes,
    resolvedCumulativeDilutionFactors,
    resolvedSerialDilutionFactors,
    resolvedDilutionTargetAnalyteConcentrations,
    resolvedDilutionTransferVolumes,
    resolvedTotalDilutionVolumes,
    resolvedDilutionFinalVolumes,
    resolvedDilutionDiscardFinalTransfers,
    resolvedDiluents,
    resolvedDiluentVolumes,
    resolvedConcentratedBuffers,
    resolvedConcentratedBufferVolumes,
    resolvedConcentratedBufferDiluents,
    resolvedConcentratedBufferDilutionFactors,
    resolvedConcentratedBufferDiluentVolumes,
    resolvedDilutionIncubates,
    resolvedDilutionIncubationTimes,
    resolvedDilutionIncubationInstruments,
    resolvedDilutionIncubationTemperatures,
    resolvedDilutionMixTypes,
    resolvedDilutionNumberOfMixes,
    resolvedDilutionMixRates,
    resolvedDilutionMixOscillationAngles,
    invalidDilutionOptionBool,
    partiallyResolvedSpreadAndStreakCellsOptionsWithDilution,

    (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
    mapThreadFriendlyOptions,
    
    (* -- RESOLVED OPTIONS -- *)
    resolvedSpreadVolumes,
    resolvedStreakVolumes,
    resolvedSourceMixes,
    resolvedSourceMixVolumes,
    resolvedNumberOfSourceMixes,
    resolvedColonySpreadingTools,
    resolvedColonyStreakingTools,
    resolvedHeadDiameters,
    resolvedHeadLengths,
    resolvedNumberOfHeads,
    resolvedColonyHandlerHeadCassetteApplications,
    resolvedDestinationMedia,
    resolvedDestinationContainers,
    resolvedDispenseCoordinates,
    resolvedSpreadPatternTypes,
    resolvedCustomSpreadPatterns,
    resolvedStreakPatternTypes,
    resolvedCustomStreakPatterns,
    resolvedNumberOfSegments,
    resolvedHatchesPerSegments,
    destinationContainerOpenPositionLookup,
    resolvedDestinationWells,functionString,
    resolvedSampleLabels,
    resolvedSampleContainerLabels,
    resolvedSampleOutLabels,
    resolvedContainerOutLabels,

    (* CONFLICTING OPTION CHECKS *)
    dilutionMismatchOptions,dilutionMismatchTests,
    sampleOutLabelMismatch,sampleOutLabelMismatchOptions,sampleOutLabelMismatchTests,
    containerOutLabelMismatch,containerOutLabelMismatchOptions,containerOutLabelMismatchTests,
    sourceMixMismatch,sourceMixMismatchOptions,sourceMixMismatchTests,
    colonyHandlerHeadCassetteMismatches,colonyHandlerHeadCassetteMismatchOptions,colonyHandlerHeadCassetteMismatchTests,
    noColonyHandlerSpreadingHeadFoundErrors,noColonyHandlerSpreadingHeadFoundOptions,noColonyHandlerSpreadingHeadFoundTests,
    noColonyHandlerStreakingHeadFoundErrors,noColonyHandlerStreakingHeadFoundOptions,noColonyHandlerStreakingHeadFoundTests,
    spreadPatternMismatchErrors,spreadPatternMismatchOptions,spreadPatternMismatchTests,
    streakPatternMismatchErrors,streakPatternMismatchOptions,streakPatternMismatchTests,
    invalidDestinationContainerTypeErrors,invalidDestinationContainerTypeOptions,invalidDestinationContainerTypeTests,
    noAvailablePositionsInContainerErrors,noAvailablePositionsInContainerOptions,noAvailablePositionsInContainerTests,
    dilutionFinalVolumeTooSmallErrors,dilutionFinalVolumeTooSmallOptions,dilutionFinalVolumeTooSmallTests,
    duplicateDestinationContainerObjects,spreadingMultipleSamplesOnSamePlateWarnings,
    invalidDestinationContainerErrors,invalidDestinationContainerOptions,invalidDestinationContainerTests,
    invalidDestinationWellErrors,invalidDestinationWellOptions,invalidDestinationWellTests,
    conflictingDestinationMediaErrors,conflictingDestinationMediaOptions,conflictingDestinationMediaTests,
    destinationMediaNotSolidErrors,destinationMediaNotSolidOptions,destinationMediaNotSolidTests,
    totalDilutionVolumeTooLargeErrors,totalDilutionVolumeTooLargeOptions,totalDilutionVolumeTooLargeTests,

    invalidOptions,invalidInputs,resolvedOptions
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Initialize the simulation if none exists *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];

  (* Look up which experiment function we are resolving *)
  experimentFunction = Lookup[ToList[myResolutionOptions],ExperimentFunction];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  spreadAndStreakOptionsAssociation = Association[myOptions];

  (* Search for all the ColonyHandlerHeadCassettes that are for spreading/streaking cells *)
  (* TODO: Memoize this *)
  spreadAndStreakColonyHandlerHeadCassettes = Search[Model[Part,ColonyHandlerHeadCassette],Application==Spread||Application==Streak&&Deprecated!=True];

  (* Pull out the options that may have models/objects whose information we need to download *)
  {
    colonySpreadingAndStreakingTools,
    destinationMedias,
    destinationContainers,
    primaryWashSolutions,
    secondaryWashSolutions,
    tertiaryWashSolutions,
    quaternaryWashSolutions
  }=Lookup[
    spreadAndStreakOptionsAssociation,
    {
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        ColonySpreadingHead,
        ColonyStreakingHead
      ],
      DestinationMedia,
      DestinationContainer,
      PrimaryWashSolution,
      SecondaryWashSolution,
      TertiaryWashSolution,
      QuaternaryWashSolution
    }
  ];

  (* Get the unique DestinationContainers *)
  allDestinationContainersNoLink = DeleteDuplicates[Download[Cases[Flatten@ToList[destinationContainers],ObjectP[]],Object]];
  uniqueDestinationContainerObjects = Cases[allDestinationContainersNoLink,ObjectReferenceP[Object[Container]]];
  uniqueDestinationContainerModels = Join[Cases[allDestinationContainersNoLink,ObjectReferenceP[Model[Container]]],{Model[Container, Plate, "id:O81aEBZjRXvx"]}]; (* Model[Container, Plate, "96-well 2mL Deep Well Plate"], Model[Container, Plate, "Omni Tray Sterile Media Plate"], Model[Container, Plate, "96-well UV-Star Plate"] *)

  (* Get the unique wash solutions *)
  defaultWashSolutions = {Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"],Model[Sample, "id:8qZ1VWNmdLBD"],Model[Sample, StockSolution, "id:qdkmxzq7lWRp"]};
  allWashSolutionsNoLink = DeleteDuplicates[Download[Cases[Flatten[{primaryWashSolutions,secondaryWashSolutions,tertiaryWashSolutions,quaternaryWashSolutions,defaultWashSolutions}],ObjectP[]],Object]];
  uniqueWashSolutionObjects = Cases[allWashSolutionsNoLink,ObjectReferenceP[Object[Sample]]];
  uniqueWashSolutionModels = Cases[allWashSolutionsNoLink,ObjectReferenceP[Model[Sample]]];

  (* Get the unique destination media *)
  allDestinationMediaNoLink = DeleteDuplicates[Download[Cases[Flatten[ToList[destinationMedias]],ObjectP[]],Object]];
  uniqueDestinationMediaObjects = Cases[allDestinationMediaNoLink,ObjectReferenceP[Object[Sample]]];
  uniqueDestinationMediaModels = Append[Cases[allDestinationMediaNoLink,ObjectReferenceP[Model[Sample]]],Model[Sample, Media, "LB (Solid Agar)"]]; (* Add our default *)

  (* Get the unique colony SpreadingAndStreaking tools *)
  allColonySpreadingAndStreakingToolsNoLink = DeleteDuplicates[Download[Cases[Flatten[ToList[colonySpreadingAndStreakingTools]],ObjectP[]],Object]];
  uniqueColonySpreadingAndStreakingToolObjects = Cases[allColonySpreadingAndStreakingToolsNoLink,ObjectReferenceP[Object[Part]]];
  uniqueColonySpreadingAndStreakingToolModels = Cases[allColonySpreadingAndStreakingToolsNoLink,ObjectReferenceP[Model[Part]]];

  (* Define the packets we need to extract from the downloaded cache. *)
  sampleObjectDownloadPacket=Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence],Media,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock];
  sampleModelDownloadPacket=Packet[SamplePreparationCacheFields[Model[Sample],Format->Sequence]];
  sampleContainerObjectDownloadPacket=Packet[Container[SamplePreparationCacheFields[Object[Container],Format->List]]];
  sampleContainerModelDownloadPacket=Packet[Container[Model[SamplePreparationCacheFields[Model[Container],Format->List]]]];
  containerDownloadPacket=Packet[Model[SamplePreparationCacheFields[Model[Container],Format->List]]];
  containerModelDownloadPacket=Packet[SamplePreparationCacheFields[Model[Container],Format->Sequence]];
  colonyHandlerHeadCassetteObjectDownloadPacket=Packet[Model[{HeadDiameter,HeadLength,NumberOfHeads,Rows,Columns,Application}]];
  colonyHandlerHeadCassetteModelDownloadPacket=Packet[HeadDiameter,HeadLength,NumberOfHeads,Rows,Columns,Application];

  (* Download from cache and simulation *)
  {
    samplePackets,
    washSolutionObjectPackets,
    washSolutionModelPackets,
    destinationMediaObjectPackets,
    destinationMediaModelPackets,
    destinationContainerObjectPackets,
    destinationContainerModelPackets,
    colonySpreadAndStreakToolObjectPackets,
    colonySpreadAndStreakToolModelPackets,
    spreadAndStreakColonyHandlerHeadCassettesPackets
  }=Quiet[
    Download[
      {
        mySamples,
        uniqueWashSolutionObjects,
        uniqueWashSolutionModels,
        uniqueDestinationMediaObjects,
        uniqueDestinationMediaModels,
        uniqueDestinationContainerObjects,
        uniqueDestinationContainerModels,
        uniqueColonySpreadingAndStreakingToolObjects,
        uniqueColonySpreadingAndStreakingToolModels,
        spreadAndStreakColonyHandlerHeadCassettes
      },
      {
        {
          sampleObjectDownloadPacket,
          Packet[Composition[[All,2]][{PreferredSolidMedia}]],
          sampleContainerObjectDownloadPacket,
          sampleContainerModelDownloadPacket
        },
        {
          sampleObjectDownloadPacket
        },
        {
          sampleModelDownloadPacket
        },
        {
          sampleObjectDownloadPacket
        },
        {
          sampleModelDownloadPacket
        },
        {
          containerDownloadPacket,
          Packet[Contents,Model],
          Packet[Model[AllowedPositions]],
          Packet[Contents[[All,2]][Model,State]],
          Packet[Contents[[All,2]][Model[UsedAsMedia]]]
        },
        {
          containerModelDownloadPacket
        },
        {
          colonyHandlerHeadCassetteObjectDownloadPacket,
          Packet[Model]
        },
        {
          colonyHandlerHeadCassetteModelDownloadPacket
        },
        {
          colonyHandlerHeadCassetteModelDownloadPacket
        }
      },
      Cache->cache,
      Simulation->currentSimulation
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
      colonySpreadAndStreakToolObjectPackets,
      colonySpreadAndStreakToolModelPackets,
      spreadAndStreakColonyHandlerHeadCassettesPackets
    }
  ];

  (* Create combined fast assoc *)
  combinedCache=FlattenCachePackets[{flattenedCachePackets,cache}];
  combinedFastAssoc=Experiment`Private`makeFastAssocFromCache[combinedCache];

  (*-- INPUT VALIDATION CHECKS --*)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
    {},
    Lookup[discardedSamplePackets,Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[discardedInvalidInputs]==0,
        Nothing,
        Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->combinedCache]<>" are not discarded:",True,False]
      ];

      passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
        Nothing,
        Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->combinedCache]<>" are not discarded:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Get the samples from mySamples that do not have Liquid state *)
  nonLiquidSamplePackets = Cases[Flatten[samplePackets],KeyValuePattern[State->Except[Liquid]]];

  (* Set nonLiquidInvalidInputs to the input objects whose state is not Liquid *)
  nonLiquidInvalidInputs = Lookup[nonLiquidSamplePackets,Object,{}];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[nonLiquidInvalidInputs]>0&&!gatherTests,
    Message[Error::NonLiquidSamples,ObjectToString[nonLiquidInvalidInputs,Cache->combinedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonLiquidTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[nonLiquidInvalidInputs]==0,
        Nothing,
        Test["Our input samples "<>ObjectToString[nonLiquidInvalidInputs,Cache->combinedCache]<>" are Liquid State:",True,False]
      ];

      passingTest=If[Length[nonLiquidInvalidInputs]==Length[mySamples],
        Nothing,
        Test["Our input samples "<>ObjectToString[Complement[mySamples,nonLiquidInvalidInputs],Cache->combinedCache]<>" are Liquid State:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*-- OPTION PRECISION CHECKS --*)
  (* First, define the option precisions that need to be checked for SpreadAndStreak Cells *)
  (* TODO: Get rounding precisions from qpix (vnc currently down) *)
  optionPrecisions={
    {ColonyPickingDepth,10^-2*Millimeter},
    {ExposureTimes,10^0*Millisecond},
    {PrimaryDryTime,10^0*Second},
    {SecondaryDryTime,10^0*Second},
    {TertiaryDryTime,10^0*Second},
    {QuaternaryDryTime,10^0*Second}
  };

  (* Check the precisions of these options. *)
  {roundedSpreadAndStreakOptions,optionPrecisionTests}=If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[spreadAndStreakOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[spreadAndStreakOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  (*-- RESOLVE INDEPENDENT OPTIONS --*)
  (* Lookup the options we are resolving independently *)
  {instrument,preparation,workCell,samplesInStorageCondition,samplesOutStorageCondition} = Lookup[roundedSpreadAndStreakOptions,{Instrument,Preparation,WorkCell,SamplesInStorageCondition,SamplesOutStorageCondition}];


  (* Resolve the Instrument Option *)
  resolvedInstrument=If[MatchQ[instrument,Automatic],

    (* If instrument is Automatic, resolve it to the Qpix *)
    Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"], (* Model[Instrument, ColonyHandler, "QPix 420 HT"] *)

    (* Otherwise, keep it *)
    instrument
  ];

  (* Check that the input samples are compatible with the wetted materials of the resolved instrument *)
  {compatibleMaterialsBools, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[resolvedInstrument, mySamples, OutputFormat -> Boolean, Output -> {Result, Tests}, Cache -> cache, Simulation->simulation],
    {CompatibleMaterialsQ[resolvedInstrument, mySamples, OutputFormat -> Boolean, Messages -> messages, Cache -> cache,Simulation->simulation], {}}
  ];

  (* Resolve Preparation and WorkCell - currently this function is only robotic on the qpix so no resolution is necessary here *)
  {resolvedPreparation,resolvedWorkCell} = {preparation,workCell};

  (* No resolution necessary for SamplesInStorageCondition *)
  resolvedSamplesInStorageCondition = samplesInStorageCondition;

  (* No resolution necessary for SamplesOutStorageCondition *)
  (* If the value is still set to Null, the sample will just be stored the same as its model *)
  resolvedSamplesOutStorageCondition = samplesOutStorageCondition;

  (*-- RESOLVE SANITIZATION AND DILUTION OPTIONS --*)

  (* Use resolveQPixSanitizationOptions to get the resolved sanitization options *)
  {
    (* Error checking vars *)
    sanitizationOptionInvalidOptions,
    sanitizationOptionTests,
    sanitizationOptionInvalidInputs,
    resolvedSanitizationOptions
  }=Module[{sanitizationOptionSymbols,unresolvedSanitizationOptions,sanitzationOutput},

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

    (* Separate the sanitization options from roundedSpreadAndStreakOptions *)
    unresolvedSanitizationOptions=KeyTake[roundedSpreadAndStreakOptions,sanitizationOptionSymbols];

    (* Resolve the options *)
    sanitzationOutput = resolveQPixSanitizationOptions[mySamples,Normal@unresolvedSanitizationOptions, resolvedInstrument, Cache->combinedCache, Output->output, Simulation -> currentSimulation];

    sanitzationOutput
  ];

  (* Merge the resolved sanitization options in with our main list of options *)
  partiallyResolvedSpreadAndStreakCellsOptionsWithSanitization = Merge[{roundedSpreadAndStreakOptions,Association@resolvedSanitizationOptions},Last];

  (* The dilution options we are resolving *)
  dilutionOptionsToResolve = {
    DilutionType,
    DilutionStrategy,
    NumberOfDilutions,
    DilutionTargetAnalyte,
    CumulativeDilutionFactor,
    SerialDilutionFactor,
    DilutionTargetAnalyteConcentration,
    DilutionTransferVolume,
    TotalDilutionVolume,
    DilutionFinalVolume,
    DilutionDiscardFinalTransfer,
    Diluent,
    DiluentVolume,
    DilutionConcentratedBuffer,
    ConcentratedBufferVolume,
    ConcentratedBufferDiluent,
    ConcentratedBufferDilutionFactor,
    ConcentratedBufferDiluentVolume,
    DilutionIncubate,
    DilutionIncubationTime,
    DilutionIncubationInstrument,
    DilutionIncubationTemperature,
    DilutionMixType,
    DilutionNumberOfMixes,
    DilutionMixRate,
    DilutionMixOscillationAngle
  };

  (* Resolve the dilution options *)
  {
    resolvedDilutionOptions,
    allDilutionConflictErrors
  } = Module[
    {
      (* Intermediate pre resolving *)
      specifiedDilutionOptions,mapThreadFriendlyDilutionOptions,optionDefinition,intermediateDilutionTypes,
      intermediateDilutionStrategies,intermediateCumulativeDilutionFactor, intermediateSerialDilutionFactor,
      intermediateDilutionTargetAnalyteConcentration, intermediateDilutionTransferVolume, intermediateTotalDilutionVolume,
      intermediateDilutionFinalVolume, intermediateDiluentVolume, intermediateConcentratedBufferVolume,
      intermediateConcentratedBufferDilutionFactor, intermediateConcentratedBufferDiluentVolume,dilutionConflictErrors,
      intermediateStreakSpreadOptions, intermediateDilutionOptions,

      (* Separating options to pass on and options to stay *)
      spreadLabels,spreadLabelsNoNull,mySplitLists,samplesForDilution,
      optionsForDilutionResolving,optionNamingMap
    },

    (* Lookup the options we are going to resolve *)
    specifiedDilutionOptions = Lookup[roundedSpreadAndStreakOptions,dilutionOptionsToResolve];

    (* Initialize invalid dilution option bool *)
    invalidDilutionOptionBool = False;

    (* Get the dilution options into a usable form *)
    mapThreadFriendlyDilutionOptions = OptionsHandling`Private`mapThreadOptions[experimentFunction,KeyTake[roundedSpreadAndStreakOptions,dilutionOptionsToResolve]];

    (* Get the option definition of the function *)
    optionDefinition = OptionDefinition[experimentFunction];
    
    (* Do some pre-resolution of the dilution options *)
    {
      intermediateDilutionTypes,
      intermediateDilutionStrategies,
      intermediateCumulativeDilutionFactor,
      intermediateSerialDilutionFactor,
      intermediateDilutionTargetAnalyteConcentration,
      intermediateDilutionTransferVolume,
      intermediateTotalDilutionVolume,
      intermediateDilutionFinalVolume,
      intermediateDiluentVolume,
      intermediateConcentratedBufferVolume,
      intermediateConcentratedBufferDilutionFactor,
      intermediateConcentratedBufferDiluentVolume,
      dilutionConflictErrors
    } = Transpose@Map[
      Function[{myMapThreadOptions},
        Module[
          {
            dilutionConflictError,specifiedDilutionOptions,specifiedDilutionType,specifiedDilutionStrategy,specifiedNumberOfDilutions,
            possiblyConflictingDilutionOptions,dilutionOptionSetBool,resolvedDilutionType,resolvedDilutionStrategy,effectiveNumberOfDilutions,
            specifiedCumulativeDilutionFactor, specifiedSerialDilutionFactor, specifiedDilutionTargetAnalyteConcentration,
            specifiedDilutionTransferVolume, specifiedTotalDilutionVolume, specifiedDilutionFinalVolume,
            specifiedDiluentVolume, specifiedConcentratedBufferVolume, specifiedConcentratedBufferDilutionFactor,
            specifiedConcentratedBufferDiluentVolume,correctedNestedLengths
          },
          (* Initialize our error checking bool *)
          dilutionConflictError = {False,{}};
          
          (* Lookup the dilution options *)
          specifiedDilutionOptions = Lookup[myMapThreadOptions,dilutionOptionsToResolve];
          
          (* Get dilution type *)
          specifiedDilutionType = First[specifiedDilutionOptions];

          (* Get dilution strategy *)
          specifiedDilutionStrategy = specifiedDilutionOptions[[2]];

          (* Lookup the nested index matching dilution options *)
          {
            specifiedNumberOfDilutions,
            specifiedCumulativeDilutionFactor,
            specifiedSerialDilutionFactor,
            specifiedDilutionTargetAnalyteConcentration,
            specifiedDilutionTransferVolume,
            specifiedTotalDilutionVolume,
            specifiedDilutionFinalVolume,
            specifiedDiluentVolume,
            specifiedConcentratedBufferVolume,
            specifiedConcentratedBufferDilutionFactor,
            specifiedConcentratedBufferDiluentVolume
          } = Lookup[myMapThreadOptions,
            {
              NumberOfDilutions,
              CumulativeDilutionFactor,
              SerialDilutionFactor,
              DilutionTargetAnalyteConcentration,
              DilutionTransferVolume,
              TotalDilutionVolume,
              DilutionFinalVolume,
              DiluentVolume,
              ConcentratedBufferVolume,
              ConcentratedBufferDilutionFactor,
              ConcentratedBufferDiluentVolume
            }
          ];
          
          (* Separate out the rest of the dilution options *)
          possiblyConflictingDilutionOptions = Rest[specifiedDilutionOptions];
          
          (* Is a Non-DilutionType dilution option set *)
          dilutionOptionSetBool = MapThread[Function[{optionSymbol,optionValue},
            Module[{defaultPattern},
              (* Get the default pattern of the symbol *)
              defaultPattern = Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol]],"Default"];

              (* The option is set if it does not match its default *)
              !MatchQ[optionValue, ListableP[ReleaseHold[defaultPattern]]]
            ]
          ],
            {
              Rest[dilutionOptionsToResolve],
              possiblyConflictingDilutionOptions
            }
          ];

          (* Resolve DilutionType *) 
          resolvedDilutionType = Which[
            (* If the option is specified, keep it *)
            MatchQ[specifiedDilutionType,Except[Automatic]],
            specifiedDilutionType,
            
            (* Otherwise, if there is a dilution option set, resolve *)
            MemberQ[dilutionOptionSetBool,True],
              Module[{dilutionStrategy,serialDilutionFactors},
                
                (* Lookup the DilutionStrategy and SerialDilutionFactor options *)
                {dilutionStrategy,serialDilutionFactors} = Lookup[myMapThreadOptions,{DilutionStrategy,SerialDilutionFactor}];
                
                (* If DilutionStrategy is set to Series, or of SerialDilutionFactor is not Null or Automatic *)
                (* Resolve to Serial, otherwise resolve to Linear *)
                If[MatchQ[dilutionStrategy,Series]||MatchQ[serialDilutionFactors,Except[Null|Automatic]],
                  Serial,
                  Linear
                ]
              ],
            
            (* Finally, if there are no dilution options set, resolve to Null *)
            True,
            Null
          ];

          (* Resolve DilutionStrategy *)
          resolvedDilutionStrategy = Which[
            (* If the option is specified, keep it *)
            MatchQ[specifiedDilutionStrategy, Except[Automatic]],
            specifiedDilutionStrategy,

            (* If the type is Null, set to Null *)
            NullQ[resolvedDilutionType],
            Null,

            (* If the type is serial, default to series *)
            MatchQ[resolvedDilutionType, Serial],
            Series,

            (* Otherwise (type is linear), default to Null *)
            True,
            Null
          ];

          (* If we have a conflict, mark the conflicting options *)
          If[Or[
            MatchQ[resolvedDilutionType,Null] && MemberQ[dilutionOptionSetBool,True],
            MatchQ[resolvedDilutionType,Except[Null] && MemberQ[possiblyConflictingDilutionOptions,Null]]
          ],
            dilutionConflictError = {True,PickList[Rest[dilutionOptionsToResolve],dilutionOptionSetBool]}
          ];

          (* Determine the number of dilutions to expand the nested options to *)
          effectiveNumberOfDilutions = Which[
            MatchQ[specifiedNumberOfDilutions,Automatic],
              Max[Length/@{
                specifiedCumulativeDilutionFactor,
                specifiedSerialDilutionFactor,
                specifiedDilutionTargetAnalyteConcentration,
                specifiedDilutionTransferVolume,
                specifiedTotalDilutionVolume,
                specifiedDilutionFinalVolume,
                specifiedDiluentVolume,
                specifiedConcentratedBufferVolume,
                specifiedConcentratedBufferDilutionFactor,
                specifiedConcentratedBufferDiluentVolume
              }],
            MatchQ[specifiedNumberOfDilutions,Null],
            1,
            True,
            specifiedNumberOfDilutions
          ];

          (* Define a helper function to expand the option. We want to expand if the length is not correct and the value of the option is the same *)
          correctNestedLength[specifiedValue_] := If[!MatchQ[Length[specifiedValue], effectiveNumberOfDilutions] && SameQ@@specifiedValue,
            ConstantArray[First[specifiedValue], effectiveNumberOfDilutions],
            specifiedValue
          ];

          (* Get the corrected length options *)
          correctedNestedLengths = correctNestedLength/@{
            specifiedCumulativeDilutionFactor,
            specifiedSerialDilutionFactor,
            specifiedDilutionTargetAnalyteConcentration,
            specifiedDilutionTransferVolume,
            specifiedTotalDilutionVolume,
            specifiedDilutionFinalVolume,
            specifiedDiluentVolume,
            specifiedConcentratedBufferVolume,
            specifiedConcentratedBufferDilutionFactor,
            specifiedConcentratedBufferDiluentVolume
          };
          
          (* Return the resolved option and conflicting list *)
          {
            resolvedDilutionType,
            resolvedDilutionStrategy,
            Sequence@@correctedNestedLengths,
            dilutionConflictError
          }
        ]
      ],
      mapThreadFriendlyDilutionOptions
    ];

    (* Add Dilution strategies back into our dilution options *)
    intermediateStreakSpreadOptions = ReplaceRule[Normal[roundedSpreadAndStreakOptions,Association],
      {
        DilutionType -> intermediateDilutionTypes,
        DilutionStrategy -> intermediateDilutionStrategies,
        CumulativeDilutionFactor -> intermediateCumulativeDilutionFactor,
        SerialDilutionFactor -> intermediateSerialDilutionFactor,
        DilutionTargetAnalyteConcentration -> intermediateDilutionTargetAnalyteConcentration,
        DilutionTransferVolume -> intermediateDilutionTransferVolume,
        TotalDilutionVolume -> intermediateTotalDilutionVolume,
        DilutionFinalVolume -> intermediateDilutionFinalVolume,
        DiluentVolume -> intermediateDiluentVolume,
        ConcentratedBufferVolume -> intermediateConcentratedBufferVolume,
        ConcentratedBufferDilutionFactor -> intermediateConcentratedBufferDilutionFactor,
        ConcentratedBufferDiluentVolume -> intermediateConcentratedBufferDiluentVolume
      }
    ];

    (* Re - lookup the dilution options *)
    intermediateDilutionOptions = Lookup[intermediateStreakSpreadOptions,dilutionOptionsToResolve];

    (* Create unique labels for each sample we are mixing *)
    spreadLabels = (If[!NullQ[#],CreateUniqueLabel["spread index"]])&/@intermediateDilutionTypes;
    spreadLabelsNoNull = spreadLabels/.Null->Nothing;

    (* Create a helper to split the option lists *)
    splitList[dilutionTypeList_,optionOrSampleList_,labelList_] := Transpose@MapThread[
      Function[{dilutionType,option,label},
        If[!NullQ[dilutionType],
          {label,option},
          {option,None}
        ]
      ],
      {dilutionTypeList, optionOrSampleList, labelList}
    ];

    (* Use the helper to split the option lists *)
    mySplitLists = (splitList[intermediateDilutionTypes,#,spreadLabels]/.{None->Nothing})&/@intermediateDilutionOptions;

    (* Gather the samples to send to ResolveSharedDilutionOptions *)
    samplesForDilution = PickList[mySamples,Transpose[{intermediateDilutionTypes,dilutionConflictErrors[[All,1]]}],{Except[Null], False}];

    (* Gather the options to send to resolve dilution shared options *)
    optionsForDilutionResolving = MapThread[Rule, {dilutionOptionsToResolve, mySplitLists[[All, 2]]}];

    (* Define a mapping from Spread/Streak option names to DilutionSharedOption names for those that differ *)
    optionNamingMap = {
      DilutionConcentratedBuffer -> ConcentratedBuffer,
      DilutionTargetAnalyte->TargetAnalyte,
      DilutionTargetAnalyteConcentration->TargetAnalyteConcentration,
      DilutionTransferVolume->TransferVolume,
      DilutionFinalVolume -> FinalVolume,
      DilutionDiscardFinalTransfer->DiscardFinalTransfer,
      DilutionIncubate->Incubate,
      DilutionIncubationTime->IncubationTime,
      DilutionIncubationInstrument->IncubationInstrument,
      DilutionIncubationTemperature->IncubationTemperature,
      DilutionMixType->MixType,
      DilutionNumberOfMixes->NumberOfMixes,
      DilutionMixRate->MixRate,
      DilutionMixOscillationAngle->MixOscillationAngle
    };

    (* Call ResolvedDilutionSharedOptions! *)
    If[MatchQ[Length[samplesForDilution],0] && !MemberQ[dilutionConflictErrors[[All,1]], True],
      {
        (* No samples to dilute and no conflict errors - everything resolves to Null *)
        ConstantArray[
          ConstantArray[
            Null,Length[mySamples]
          ],
          Length[dilutionOptionsToResolve]
        ],
        dilutionConflictErrors
      },

      (* We have samples to dilute! *)
      Module[{dilutionResult,dilutionTests},
        (* Call ResolveDilutionSharedOptions *)
        {dilutionResult,dilutionTests}=Which[
          MemberQ[dilutionConflictErrors[[All,1]], True],
          {
            mapThreadFriendlyDilutionOptions /. {Automatic -> Null},
            {}
          },
          gatherTests,
            ResolveDilutionSharedOptions[samplesForDilution, Sequence@@optionsForDilutionResolving, Output->{Result,Tests}],
          True,
            {
              Module[{invalidOptionsBool,resolvedOptions},

                (* Run the analysis function to get the resolved options *)
                {resolvedOptions,invalidOptionsBool} = ModifyFunctionMessages[
                  ResolveDilutionSharedOptions,
                  {samplesForDilution},
                  "",
                  optionNamingMap,
                  optionsForDilutionResolving,
                  Simulation -> currentSimulation,
                  Cache -> combinedCache,
                  Output -> {Result,Boolean}
                ];

                (* Set the invalid analysis option boolean if appropriate *)
                If[invalidOptionsBool,
                  invalidDilutionOptionBool = True
                ];

                (* Return the options *)
                resolvedOptions
              ],
              {}
            }
        ];

        {
          (* Translate the resolved dilution options back into their proper index in our options *)
          MapThread[
            Function[{dilutionOption,dilutionOptionWithLabels},
              Module[{resolvedDilutionOption,labledResolvedDilutionOption},

                (* Lookup the mix option from the result *)
                resolvedDilutionOption = Lookup[dilutionResult,dilutionOption]/.{{}->Null};

                (* Thread the labels with the resolved option *)
                labledResolvedDilutionOption = Thread[spreadLabelsNoNull -> resolvedDilutionOption];

                (* Use the label rules to reinsert the resolved options at the correct indices *)
                (dilutionOptionWithLabels)/.labledResolvedDilutionOption/.Automatic->Null
              ]
            ],
            {dilutionOptionsToResolve,mySplitLists[[All,1]]}
          ],
          (* Return the conflict errors *)
          dilutionConflictErrors
        }
      ]
    ]
  ];

  (* Extract the individual dilution options *)
  {
    resolvedDilutionTypes,
    resolvedDilutionStrategies,
    resolvedNumberOfDilutions,
    resolvedDilutionTargetAnalytes,
    resolvedCumulativeDilutionFactors,
    resolvedSerialDilutionFactors,
    resolvedDilutionTargetAnalyteConcentrations,
    resolvedDilutionTransferVolumes,
    resolvedTotalDilutionVolumes,
    resolvedDilutionFinalVolumes,
    resolvedDilutionDiscardFinalTransfers,
    resolvedDiluents,
    resolvedDiluentVolumes,
    resolvedConcentratedBuffers,
    resolvedConcentratedBufferVolumes,
    resolvedConcentratedBufferDiluents,
    resolvedConcentratedBufferDilutionFactors,
    resolvedConcentratedBufferDiluentVolumes,
    resolvedDilutionIncubates,
    resolvedDilutionIncubationTimes,
    resolvedDilutionIncubationInstruments,
    resolvedDilutionIncubationTemperatures,
    resolvedDilutionMixTypes,
    resolvedDilutionNumberOfMixes,
    resolvedDilutionMixRates,
    resolvedDilutionMixOscillationAngles
  } = resolvedDilutionOptions;

  (* Merge the resolved dilution options in with the current options *)
  partiallyResolvedSpreadAndStreakCellsOptionsWithDilution = Merge[
    {
      partiallyResolvedSpreadAndStreakCellsOptionsWithSanitization,
      Association[MapThread[Rule, {dilutionOptionsToResolve, resolvedDilutionOptions}]]
    },
    Last
  ];

  (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[experimentFunction,partiallyResolvedSpreadAndStreakCellsOptionsWithDilution,AmbiguousNestedResolution->IndexMatchingOptionPreferred];

  {
    resolvedSpreadVolumes,
    resolvedStreakVolumes,
    resolvedSourceMixes,
    resolvedSourceMixVolumes,
    resolvedNumberOfSourceMixes,
    resolvedColonySpreadingTools,
    resolvedColonyStreakingTools,
    resolvedHeadDiameters,
    resolvedHeadLengths,
    resolvedNumberOfHeads,
    resolvedColonyHandlerHeadCassetteApplications,
    resolvedDestinationMedia,
    resolvedDestinationContainers,
    resolvedDispenseCoordinates,
    resolvedSpreadPatternTypes,
    resolvedCustomSpreadPatterns,
    resolvedStreakPatternTypes,
    resolvedCustomStreakPatterns,
    resolvedNumberOfSegments,
    resolvedHatchesPerSegments
  } = Transpose@MapThread[Function[{mySample,myMapThreadOptions},
    Module[
      {
        (* User specified options *)
        specifiedSpreadVolume,
        specifiedStreakVolume,
        specifiedSourceMix,
        specifiedSourceMixVolume,
        specifiedNumberOfSourceMixes,
        specifiedColonySpreadingTool,
        specifiedColonyStreakingTool,
        specifiedHeadDiameter,
        specifiedHeadLength,
        specifiedNumberOfHeads,
        specifiedColonyHandlerHeadCassetteApplication,
        specifiedDestinationMedia,
        specifiedDestinationContainer,
        specifiedDestinationWell,
        specifiedDispenseCoordinates,
        specifiedSpreadPatternType,
        specifiedCustomSpreadPattern,
        specifiedStreakPatternType,
        specifiedCustomStreakPattern,
        specifiedNumberOfSegments,
        specifiedHatchesPerSegment,
        resolvedDilutionType,
        resolvedDilutionStrategy,
        resolvedDilutionFinalVolume,
        
        (* Resolved options *)
        resolvedSpreadVolume,
        resolvedStreakVolume,
        resolvedSourceMix,
        resolvedSourceMixVolume,
        resolvedNumberOfSourceMixes,
        resolvedColonySpreadingTool,
        resolvedColonyStreakingTool,
        resolvedHeadDiameter,
        resolvedHeadLength,
        resolvedNumberOfHeads,
        resolvedColonyHandlerHeadCassetteApplication,
        resolvedDestinationMedia,
        resolvedDestinationContainer,
        resolvedDispenseCoordinate,
        resolvedSpreadPatternType,
        resolvedCustomSpreadPattern,
        resolvedStreakPatternType,
        resolvedCustomStreakPattern,
        resolvedNumberOfSegments,
        resolvedHatchesPerSegment,

        (* Other variables *)
        resolvedColonyTool
      },

      (* Look up the option values *)
      {
        specifiedSpreadVolume,
        specifiedStreakVolume,
        specifiedSourceMix,
        specifiedSourceMixVolume,
        specifiedNumberOfSourceMixes,
        specifiedColonySpreadingTool,
        specifiedColonyStreakingTool,
        specifiedHeadDiameter,
        specifiedHeadLength,
        specifiedNumberOfHeads,
        specifiedColonyHandlerHeadCassetteApplication,
        specifiedDestinationMedia,
        specifiedDestinationContainer,
        specifiedDestinationWell,
        specifiedDispenseCoordinates,
        specifiedSpreadPatternType,
        specifiedCustomSpreadPattern,
        specifiedStreakPatternType,
        specifiedCustomStreakPattern,
        specifiedNumberOfSegments,
        specifiedHatchesPerSegment,
        resolvedDilutionType,
        resolvedDilutionStrategy,
        resolvedDilutionFinalVolume
      }=Lookup[
        myMapThreadOptions,
        {
          SpreadVolume,
          StreakVolume,
          SourceMix,
          SourceMixVolume,
          NumberOfSourceMixes,
          ColonySpreadingTool,
          ColonyStreakingTool,
          HeadDiameter,
          HeadLength,
          NumberOfHeads,
          ColonyHandlerHeadCassetteApplication,
          DestinationMedia,
          DestinationContainer,
          DestinationWell,
          DispenseCoordinates,
          SpreadPatternType,
          CustomSpreadPattern,
          StreakPatternType,
          CustomStreakPattern,
          NumberOfSegments,
          HatchesPerSegment,
          DilutionType,
          DilutionStrategy,
          DilutionFinalVolume
        },
        Null
      ];
      
      (* -- Resolve Volume options -- *)
      resolvedSpreadVolume = Which[
        (* Null out if not this experiment *)
        MatchQ[experimentFunction,ExperimentStreakCells],
        Null,
        
        (* If anything but automatic, leave it alone *)
        MatchQ[specifiedSpreadVolume,Except[Automatic]],
        specifiedSpreadVolume,
        
        (* Otherwise, resolve to 100 Microliter *)
        True,
        100 Microliter
      ];

      resolvedStreakVolume = Which[
        (* Null out if not this experiment *)
        MatchQ[experimentFunction,ExperimentSpreadCells],
        Null,

        (* If anything but automatic, leave it alone *)
        MatchQ[specifiedStreakVolume,Except[Automatic]],
        specifiedStreakVolume,

        (* Otherwise, resolve to 100 Microliter *)
        True,
        100 Microliter
      ];

      (* Resolve Source Mixing *)
      resolvedSourceMix = Which[
        (* If the option is specified, keep it *)
        MatchQ[specifiedSourceMix,Except[Automatic]],
        specifiedSourceMix,

        (* If any of the other source mix options are set, resolve to True *)
        Or[
          MatchQ[specifiedSourceMixVolume,Except[Automatic]],
          MatchQ[specifiedNumberOfSourceMixes,Except[Automatic]]
        ],
        True,

        (* Otherwise resolve to false *)
        True,
        False
      ];

      (* Resolve SourceMixVolume *)
      resolvedSourceMixVolume = Module[{sampleVolume},

        (* Get the volume of the sample we are mixing - either after dilution or if not diluting - our initial sample *)
        sampleVolume = Which[
          (* If we aren't diluting - use sample volume if populated, if not try to convert from mass *)
          NullQ[resolvedDilutionType],
            Module[{sampleVolume,sampleMass,sampleDensity},
              sampleVolume = fastAssocLookup[combinedFastAssoc,mySample,Volume];
              sampleMass = fastAssocLookup[combinedFastAssoc,mySample,Mass];
              sampleDensity = fastAssocLookup[combinedFastAssoc,mySample,Density];


              Which[
                (* If volume is populated use it *)
                MatchQ[sampleVolume,VolumeP],sampleVolume,
                (* If density and mass are populated use them *)
                MatchQ[sampleMass,MassP] && MatchQ[sampleDensity,DensityP],sampleMass / sampleDensity,
                (* If only mass is populated use density of water *)
                MatchQ[sampleMass,MassP],sampleMass / (0.997 Gram/Milliliter),
                (* Default to 1 Milliliter so we don't crash *)
                True,1 Milliliter
              ]
            ],

          (* If we are diluting and dilution strategy is endpoint - take the last final volume *)
          !NullQ[resolvedDilutionType] && MatchQ[resolvedDilutionStrategy,Endpoint],
          Last[resolvedDilutionFinalVolume],

          (* If we are diluting and dilution strategy is series - take the smallest volume *)
          !NullQ[resolvedDilutionType] && MatchQ[resolvedDilutionStrategy,Series],
          Min[resolvedDilutionFinalVolume],

          (* If we made it this far, something errored earlier, just default to 1mL *)
          True,
          1 Milliliter
        ];

        Which[
          (* If volume to mix is specified, use it *)
          MatchQ[specifiedSourceMixVolume,Except[Automatic]],
          specifiedSourceMixVolume,

          (* If we are not mixing, resolve to Null *)
          !resolvedSourceMix,
          Null,

          (* If volume is not specified and we are mixing, take 1/4th of the sampleVolume clamped between 10 and 130 microliter *)
          True,
          Module[{volToMix},
            (* Volume to mix is 1/4th sample volume *)
            volToMix = N[sampleVolume / 4];

            (* Clamp it between 10 and 130 microliter *)
            Which[
              GreaterQ[volToMix,130 Microliter],130 Microliter,
              LessQ[volToMix,10 Microliter],10 Microliter,
              True,volToMix
            ]
          ]
        ]
      ];

      (* Resolve SourceNumberOfMixes *)
      resolvedNumberOfSourceMixes = Which[
        MatchQ[specifiedNumberOfSourceMixes,Except[Automatic]], specifiedNumberOfSourceMixes,
        resolvedSourceMix,4,
        True,Null
      ];

      (* Resolve the streaking / spreading tool *)
      resolvedColonyTool = Which[
        (* If the tool is specified, keep it *)
        MatchQ[experimentFunction,ExperimentSpreadCells] && MatchQ[specifiedColonySpreadingTool,Except[Automatic]],
        specifiedColonySpreadingTool,
        MatchQ[experimentFunction,ExperimentStreakCells]&& MatchQ[specifiedColonyStreakingTool,Except[Automatic]],
        specifiedColonyStreakingTool,

        (* Otherwise, try to resolve the tool based on HeadDiameter, HeadLength, NumberOfHeads, and Application *)
        True,
        Module[
          {
            headDiameterPattern,headLengthPattern,numberOfHeadsPattern,
            colonyHandlerHeadCassetteApplicationPattern,filterPattern,filteredPartPackets
          },

          (* Create a pattern to filter our parts based on the given options *)
          (* Create a pattern for HeadDiameter *)
          headDiameterPattern = If[MatchQ[specifiedHeadDiameter,Except[Automatic]],
            KeyValuePattern[{
              HeadDiameter -> RangeP[specifiedHeadDiameter]
            }],
            _
          ];

          (* Create a pattern for HeadLength *)
          headLengthPattern = If[MatchQ[specifiedHeadLength,Except[Automatic]],
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
              Application -> specifiedColonyHandlerHeadCassetteApplication
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
          filteredPartPackets = Cases[First/@spreadAndStreakColonyHandlerHeadCassettesPackets,filterPattern];
          
          (* Choose our value *)
          Which[
            (* If there is a single valid packet, use it *)
            MatchQ[Length[filteredPartPackets],1],Lookup[filteredPartPackets[[1]],Object],
            
            (* If there are multiple valid packets, default to the 1 pin head (as of rn we only have 2 heads - the 1 pin and the 8 pin) *)
            (* NOTE: Null default just to not wall of red - SHOULD NEVER GET HERE THOUGH *)
            MatchQ[Length[filteredPartPackets],2],Lookup[FirstCase[filteredPartPackets,KeyValuePattern[NumberOfHeads -> 1],Null],Object],
            
            (* Otherwise if we have no valid packets - return Null (error will be detected later) *)
            True,
            Null
          ]
        ]
      ];
      
      (* Set the actual resolved option values *)
      resolvedColonySpreadingTool = If[MatchQ[experimentFunction,ExperimentSpreadCells],
        resolvedColonyTool,
        Null
      ];
      resolvedColonyStreakingTool = If[MatchQ[experimentFunction,ExperimentStreakCells],
        resolvedColonyTool,
        Null
      ];
      
      (* Resolve HeadDiameter *)
      resolvedHeadDiameter = Which[
        (* If it is specified, keep it *)
        MatchQ[specifiedHeadDiameter,Except[Automatic]], specifiedHeadDiameter,
        (* If we found a head to use - use its value *)
        !NullQ[resolvedColonyTool],fastAssocLookup[combinedFastAssoc,resolvedColonyTool,HeadDiameter],
        (* If we couldn't find a head - default to Null *)
        True,Null
      ];
      
      (* Resolve HeadLength *)
      resolvedHeadLength = Which[
        (* If it is specified, keep it *)
        MatchQ[specifiedHeadLength,Except[Automatic]], specifiedHeadLength,
        (* If we found a head to use - use its value *)
        !NullQ[resolvedColonyTool],fastAssocLookup[combinedFastAssoc,resolvedColonyTool,HeadLength],
        (* If we couldn't find a head - default to Null *)
        True,Null
      ];

      (* Resolve NumberOfHeads *)
      resolvedNumberOfHeads = Which[
        (* If it is specified, keep it *)
        MatchQ[specifiedNumberOfHeads,Except[Automatic]], specifiedNumberOfHeads,
        (* If we found a head to use - use its value *)
        !NullQ[resolvedColonyTool],fastAssocLookup[combinedFastAssoc,resolvedColonyTool,NumberOfHeads],
        (* If we couldn't find a head - default to Null *)
        True,Null
      ];

      (* Resolve ColonyHandlerHeadCassetteApplication *)
      resolvedColonyHandlerHeadCassetteApplication = Which[
        (* If it is specified, keep it *)
        MatchQ[specifiedColonyHandlerHeadCassetteApplication,Except[Automatic]], specifiedColonyHandlerHeadCassetteApplication,
        (* If we found a head to use - use its value *)
        !NullQ[resolvedColonyTool],fastAssocLookup[combinedFastAssoc,resolvedColonyTool,Application],
        (* If we couldn't find a head - default to Null *)
        True,Null
      ];

      (* Resolve DestinationMedia *)
      resolvedDestinationMedia = If[MatchQ[specifiedDestinationMedia,Except[Automatic]],
        (* If it is specified, keep it *)
        specifiedDestinationMedia,
        (* Otherwise resolved based on the Model[Cell] and Destination Container *)
        Module[{destContainerMedia,prefSolidMedia},

          (* Get any media from the DestinationContainer *)
          destContainerMedia = If[MatchQ[specifiedDestinationContainer,ObjectP[Object[Container]]],
            Module[{destinationContainerContents,destinationContainerWell,destinationSample},

              (* Get the contents and well we are spreading in *)
              destinationContainerContents = fastAssocLookup[combinedFastAssoc,specifiedDestinationContainer,Contents];
              destinationContainerWell = If[MatchQ[specifiedDestinationWell,Except[Automatic]],
                specifiedDestinationWell,
                "A1"
              ];

              (* Get the sample in the specified well *)
              destinationSample = Download[FirstCase[destinationContainerContents,{destinationContainerWell,x_}:>x,Null],Object];

              (* Get the media of the sample *)
              Which[
                (* If the sample is UsedAsMedia = True - use it *)
                fastAssocLookup[combinedFastAssoc,destinationSample,{Model,UsedAsMedia}],
                destinationSample,
                (* Otherwise if the sample contains media, use that sample *)
                MatchQ[fastAssocLookup[combinedFastAssoc,destinationSample,Media],ObjectP[Model[Sample]]],
                Download[fastAssocLookup[combinedFastAssoc,destinationSample,Media],Object],
                (* Otherwise, default to Null *)
                True,
                Null
              ]
            ],
            Null
          ];

          (* Get the preferred solid media from the composition of the input sample if one exists *)
          prefSolidMedia = Module[{sampleComposition,cellModel},
            (* Get composition of the input sample *)
            sampleComposition = If[MatchQ[fastAssocLookup[combinedFastAssoc,mySample,Composition],$Failed],
              {},
              fastAssocLookup[combinedFastAssoc,mySample,Composition]
            ];

            (* Get the first model cell (if there are any) *)
            cellModel = FirstCase[sampleComposition,{_,x:ObjectP[Model[Cell]]} :> x, Null];

            (* If there is a cell model, look up its PreferredSolidMedia *)
            If[MatchQ[fastAssocLookup[combinedFastAssoc,cellModel,PreferredSolidMedia],ObjectP[Model[Sample]]],
              Download[fastAssocLookup[combinedFastAssoc,cellModel,PreferredSolidMedia],Object],
              Null
            ]
          ];

          Which[
            (* If we found a media in the destination container, use it *)
            MatchQ[destContainerMedia,ObjectP[{Model[Sample],Object[Sample]}]], destContainerMedia,
            (* Otherwise, if we found a media in a Model[Cell] in the Composition of the input sample, use it *)
            MatchQ[prefSolidMedia,ObjectP[Model[Sample]]], prefSolidMedia,
            (* If all else fails, default to LB agar *)
            True,Model[Sample, Media, "id:9RdZXvdwAEo6"] (* Model[Sample, Media, "LB (Solid Agar)"] *)
          ]
        ]
      ];

      (* Resolve Destination Container *)
      resolvedDestinationContainer = If[MatchQ[specifiedDestinationContainer,Except[Automatic]],
        (* If it is specified, keep it *)
        specifiedDestinationContainer,
        (* Otherwise, resolve to Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
        Model[Container, Plate, "id:O81aEBZjRXvx"]
      ];

      (* Resolve SpreadPatternType *)
      (* This defaults through the widget so no resolution necessary *)
      resolvedSpreadPatternType = If[MatchQ[experimentFunction,ExperimentStreakCells],
        Null,
        specifiedSpreadPatternType
      ];

      (* Resolve CustomSpreadPattern *)
      resolvedCustomSpreadPattern = Which[
        (* If we are doing streaking, resolve to Null *)
        MatchQ[experimentFunction,ExperimentStreakCells],
        Null,
        (* If the option is specified, keep it *)
        MatchQ[specifiedCustomSpreadPattern,Except[Automatic]],
        specifiedCustomSpreadPattern,
        (* Otherwise, resolve to Null *)
        True,
        Null
      ];

      (* Resolve StreakPatternType *)
      (* This defaults through the widget so no resolution necessary *)
      resolvedStreakPatternType = If[MatchQ[experimentFunction,ExperimentSpreadCells],
        Null,
        specifiedStreakPatternType
      ];

      (* Resolve CustomStreakPattern *)
      resolvedCustomStreakPattern = Which[
        (* If we are doing spreading, resolve to Null *)
        MatchQ[experimentFunction,ExperimentSpreadCells],
        Null,
        (* If the option is specified, keep it *)
        MatchQ[specifiedCustomStreakPattern,Except[Automatic]],
        specifiedCustomStreakPattern,
        (* Otherwise, resolve to Null *)
        True,
        Null
      ];
      
      (* Resolve NumberOfSegments *)
      resolvedNumberOfSegments = Which[
        (* If we are doing spreading, resolve to Null *)
        MatchQ[experimentFunction,ExperimentSpreadCells],
        Null,
        (* If the option is specified, keep it *)
        MatchQ[specifiedNumberOfSegments,Except[Automatic]],
        specifiedNumberOfSegments,
        (* If the custom streak pattern is RotatedHatches or LinearHatches, resolve to 4 *)
        MatchQ[resolvedStreakPatternType,RotatedHatches | LinearHatches],
        4,
        (* Otherwise, resolve to Null *)
        True,
        Null
      ];
      
      (* Resolve HatchesPerSegment *)
      resolvedHatchesPerSegment = Which[
        (* If we are doing spreading, resolve to Null *)
        MatchQ[experimentFunction,ExperimentSpreadCells],
        Null,
        (* If the option is specified, keep it *)
        MatchQ[specifiedHatchesPerSegment,Except[Automatic]],
        specifiedHatchesPerSegment,
        (* TODO: Update this logic to make it smarter based on dest container and num pins in spreading head *)
        (* If the custom streak pattern is RotatedHatches or LinearHatches, resolve to 4 *)
        MatchQ[resolvedStreakPatternType,RotatedHatches | LinearHatches],
        4,
        (* Otherwise, resolve to Null *)
        True,
        Null
      ];

      resolvedDispenseCoordinate = Which[
        (* If its specified, keep it *)
        MatchQ[specifiedDispenseCoordinates,Except[Automatic]],
        specifiedDispenseCoordinates,

        (* ---- Spread Cases ---- *)
        (* Spiral Starts in the center *)
        MatchQ[resolvedSpreadPatternType,Spiral],
        {
          {0 Millimeter, 0 Millimeter},
          {24 Millimeter, 16 Millimeter},
          {48 Millimeter, 32 Millimeter},
          {24 Millimeter, -16 Millimeter},
          {48 Millimeter, -32 Millimeter},
          {-24 Millimeter, -16 Millimeter},
          {-48 Millimeter, -32 Millimeter},
          {-24 Millimeter, 16 Millimeter},
          {-48 Millimeter, 32 Millimeter}
        },

        (* Vertical zig zag starts on bottom *)
        MatchQ[resolvedSpreadPatternType,VerticalZigZag],
        {
          {-48 Millimeter, -32 Millimeter},
          {-24 Millimeter, -32 Millimeter},
          {-0 Millimeter, -32 Millimeter},
          {24 Millimeter, -32 Millimeter},
          {48 Millimeter, -32 Millimeter}
        },

        (* Horizontal zig zag starts on right *)
        MatchQ[resolvedSpreadPatternType,HorizontalZigZag],
        {
          {-32 Millimeter, 48 Millimeter},
          {-16 Millimeter, 48 Millimeter},
          {0 Millimeter, 48 Millimeter},
          {16 Millimeter, 48 Millimeter},
          {32 Millimeter, 48 Millimeter}
        },

        (* Custom resolves to the start point of the first Spread[], or {0,0} *)
        MatchQ[resolvedSpreadPatternType,Custom],
        Module[{},
          Switch[resolvedCustomSpreadPattern,
            Null,{0Millimeter,0Millimeter},
            _Spread, {First[First[resolvedCustomSpreadPattern]]},
            {_Spread..}, {First[First[First[resolvedCustomSpreadPattern]]]}
          ]
        ],
        
        (* ---- Streak Cases ---- *)
        (* Radiant starts in the center *)
        MatchQ[resolvedStreakPatternType,Radiant],
        {
          {0 Millimeter, 0 Millimeter}
        },
        
        (* Rotated hatches start on the left side of the x-axis of the plate *)
        MatchQ[resolvedStreakPatternType,RotatedHatches],
        {{-50 Millimeter, 0 Millimeter}},
        
        (* Linear hatches start at the bottom left of the plate *)
        MatchQ[resolvedStreakPatternType,LinearHatches],
        {{-50 Millimeter, -30 Millimeter}},
        
        (* Custom resolves to the start point of the first Streak[], or {0,0} *)
        MatchQ[resolvedSpreadPatternType,Custom],
        Module[{},
          Switch[resolvedCustomStreakPattern,
            Null,{0Millimeter,0Millimeter},
            _Streak, {First[resolvedCustomStreakPattern]},
            {_Streak..}, {First[First[resolvedCustomStreakPattern]]}
          ]
        ],
        
        (* Everything else defaults to {0,0} so we don't crash *)
        True,
        {{0 Millimeter, 0 Millimeter}}
      ];

      (* Return from the mapthread *)
      {
        resolvedSpreadVolume,
        resolvedStreakVolume,
        resolvedSourceMix,
        resolvedSourceMixVolume,
        resolvedNumberOfSourceMixes,
        resolvedColonySpreadingTool,
        resolvedColonyStreakingTool,
        resolvedHeadDiameter,
        resolvedHeadLength,
        resolvedNumberOfHeads,
        resolvedColonyHandlerHeadCassetteApplication,
        resolvedDestinationMedia,
        resolvedDestinationContainer,
        resolvedDispenseCoordinate,
        resolvedSpreadPatternType,
        resolvedCustomSpreadPattern,
        resolvedStreakPatternType,
        resolvedCustomStreakPattern,
        resolvedNumberOfSegments,
        resolvedHatchesPerSegment
      }
    ]
  ],
    {mySamples,mapThreadFriendlyOptions}
  ];
  
  (* Resolve DestinationWell *)
  (* First, create a lookup of all of the open positions in each destination container *)
  destinationContainerOpenPositionLookup = <||>;
  Map[
    Function[{destinationContainer},
      (* If the container is a Model, skip it *)
      If[MatchQ[destinationContainer,ObjectP[Model[Container]]],
        Null,

        (* If it is an object, get its "open" positions (positions that are either empty or contain only a solid media) *)
        Module[{containerContents,containerPopulatedPositions,containerAllowedPositions,emptyPositionsInContainer,mediaPositionsInContainer},
          (* Get the contents of the container *)
          containerContents = If[MatchQ[fastAssocLookup[combinedFastAssoc,destinationContainer,Contents],_List],
            fastAssocLookup[combinedFastAssoc,destinationContainer,Contents],
            {}
          ];

          (* Extract which positions in the container are populated *)
          containerPopulatedPositions = containerContents[[All,1]];

          (* Get the allowed positions of the container *)
          containerAllowedPositions = If[MatchQ[List@@fastAssocLookup[combinedFastAssoc,destinationContainer,{Model,AllowedPositions}],_List],
            List@@fastAssocLookup[combinedFastAssoc,destinationContainer,{Model,AllowedPositions}],
            {}
          ];

          (* Get the empty positions in the container *)
          emptyPositionsInContainer = Complement[containerAllowedPositions,containerPopulatedPositions];

          (* Define a helper function to select "valid contents" *)
          critFunc[contentsList_] := Module[{sample,sampleUsedAsMedia,sampleState},
            (* Get the contents *)
            sample = contentsList[[2]];

            (* Get the sample UsedAsMedia and State *)
            sampleUsedAsMedia = fastAssocLookup[combinedFastAssoc,sample,{Model,UsedAsMedia}];
            sampleState = fastAssocLookup[combinedFastAssoc,sample,State];

            (* Return True If the position only contains solid media *)
            And[
              TrueQ[sampleUsedAsMedia],
              MatchQ[sampleState,Solid]
            ]
          ];

          (* Get the positions that only contain solid media *)
          mediaPositionsInContainer = Select[containerContents,critFunc][[All,1]];

          (* Associate the positions with the container in the lookup *)
          destinationContainerOpenPositionLookup[destinationContainer] = DeleteDuplicates[Join[mediaPositionsInContainer,emptyPositionsInContainer]]
        ]
      ]
    ],
    resolvedDestinationContainers
  ];

  (* Next, map over the containers and wells, and pick an open position for each *)
  resolvedDestinationWells = MapThread[Function[{container,well},
    Which[
      (* If the well is specified, use it *)
      MatchQ[well,Except[Automatic]],
      well,

      (* If the container is a model, default to A1 *)
      MatchQ[container,ObjectP[Model[Container]]],
      "A1",

      (* If the container is an object and there is an open position, use it *)
      MatchQ[container,ObjectP[Object[Container]]] && Length[destinationContainerOpenPositionLookup[container]] > 0,
      First[destinationContainerOpenPositionLookup[container]],

      (* If the container is an object and there are no positions, return Null *)
      MatchQ[container,ObjectP[Object[Container]]],
      Null,

      (* In any other case, return Null *)
      True,
      Null
    ]
  ],
    {resolvedDestinationContainers,Lookup[partiallyResolvedSpreadAndStreakCellsOptionsWithDilution,DestinationWell]}
  ];

  (* Translate the experiment function into a string to use for labels *)
  functionString = If[MatchQ[experimentFunction,ExperimentSpreadCells],
    "SpreadCells",
    "StreakCells"
  ];

  (* Resolve SampleLabel *)
  resolvedSampleLabels=Module[{uniqueSamples,sampleLabelLookup},
    (* get the unique samples in *)
    uniqueSamples=DeleteDuplicates[mySamples];

    (* create a lookup of unique sample to label *)
    sampleLabelLookup=(#->CreateUniqueLabel[functionString <> " Sample"])&/@uniqueSamples;

    (* replace samples with their container's label *)
    MapThread[Function[{sample,givenLabel},
      If[MatchQ[givenLabel,Automatic],
        Lookup[sampleLabelLookup,sample],
        givenLabel
      ]
    ],
      {
        mySamples,
        Lookup[mapThreadFriendlyOptions,SampleLabel]
      }
    ]
  ];

  (* Resolve SampleContainerLabel *)
  resolvedSampleContainerLabels=Module[{uniqueSamples,sampleContainerLookup,containerLabelLookup},

    (* get the unique samples in containers *)
    uniqueSamples=DeleteDuplicates[mySamples];

    (* create a lookup of sample to container *)
    sampleContainerLookup=(#->Download[fastAssocLookup[combinedFastAssoc,#,Container],Object])&/@uniqueSamples;

    (* create a lookup of container to label *)
    containerLabelLookup=(#->CreateUniqueLabel[functionString <> " SampleContainer"])&/@Values[sampleContainerLookup];

    (* replace samples with their container's label *)
    MapThread[Function[{sample,givenLabel},
      If[MatchQ[givenLabel,Automatic],
        Lookup[containerLabelLookup,Lookup[sampleContainerLookup,sample]],
        givenLabel
      ]
    ],
      {
        mySamples,
        Lookup[mapThreadFriendlyOptions,SampleContainerLabel]
      }
    ]
  ];

  (* If sampleOutLabels is Automatic, resolve it *)
  resolvedSampleOutLabels=MapThread[
    Function[{sampleOutLabel,dilutionType,dilutionStrategy,numberOfDilutions,index},
      Which[
        (* If the given label is not automatic, leave it alone *)
        MatchQ[sampleOutLabel,Except[Automatic]],
          sampleOutLabel,

        (* If dilutionStrategy is Null and dilutionType is Null we have 1 sample out *)
        MatchQ[dilutionStrategy,Null] && MatchQ[dilutionType,Null],
          CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"],

        (* If dilutionStrategy is Null and dilutionType is LinearDilution we have NumberOfDilutions samples out *)
        MatchQ[dilutionStrategy,Null] && MatchQ[dilutionType,Linear] && !NullQ[numberOfDilutions],
          Table[CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"],{i,1,numberOfDilutions}],

        (* If dilutionStrategy is Endpoint, we have a single sample out *)
        MatchQ[dilutionStrategy,Endpoint],
          {CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"]},

        (* If we made it this far and numberOfDilutions is Null this means we have a conflict, make 1 sample out label *)
        NullQ[numberOfDilutions],
          CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"],

        (* Otherwise, dilutionStrategy is Series, so we make numberOfDilutions + 1 samples out *)
        True,
          Table[CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"],{i,1,numberOfDilutions+1}]
      ]
    ],
    {
      Lookup[partiallyResolvedSpreadAndStreakCellsOptionsWithDilution,SampleOutLabel],
      resolvedDilutionTypes,
      resolvedDilutionStrategies,
      resolvedNumberOfDilutions,
      Range[Length[mySamples]]
    }
  ];

  (* Resolve ContainerOutLabel *)
  resolvedContainerOutLabels=Module[{containerOutObjectLookup},

    (* Define a unique container out object lookup *)
    (* NOTE: Has the structure <|Object -> Label|> *)
    containerOutObjectLookup = <||>;

    (* Loop over the resolved containers and dilution strategies *)
    MapThread[
      Function[{containerOutLabel, destinationContainer, dilutionType, dilutionStrategy,numberOfDilutions,index},
        Which[
          (* If the given label is not automatic, leave it alone *)
          MatchQ[containerOutLabel,Except[Automatic]],
            Module[{},
              (* If the container is an object add it to the lookup *)
              If[MatchQ[destinationContainer,ObjectP[Object[Container]]],
                containerOutObjectLookup[destinationContainer] = containerOutLabel
              ];

              (* Return the given label *)
              containerOutLabel
            ],

          (* If dilutionStrategy is Endpoint, or destination container is an object, we just have one destination plate *)
          MatchQ[dilutionStrategy,Endpoint] || MatchQ[destinationContainer,ObjectP[Object[Container]]],
            Module[{label},

              (* Create or find the new label *)
              label = If[!NullQ[Lookup[containerOutObjectLookup,destinationContainer,Null]],
                Lookup[containerOutObjectLookup,destinationContainer,Null],
                CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Container Out"]
              ];

              (* If the container is an object add it to the lookup *)
              If[MatchQ[destinationContainer,ObjectP[Object[Container]]],
                containerOutObjectLookup[destinationContainer] = label
              ];

              (* Return the label *)
              label
            ],

          (* If dilutionStrategy is Null and dilutionType is Null, then we aren't diluting and have 1 container out *)
          MatchQ[dilutionStrategy,Null] && MatchQ[dilutionType, Null],
            CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Container Out"],

          (* If dilutionStrategy is Null and dilutionType is Linear, this means we are in LinearDilution - so we have NumberOfDilutions destination plates *)
          MatchQ[dilutionStrategy,Null] && MatchQ[dilutionType,Linear] && !NullQ[numberOfDilutions],
            Table[CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Container Out"],{i,1,numberOfDilutions}],

          (* If we made it this far and numberOfDilutions is Null this means we have a conflict, make 1 sample out label *)
          NullQ[numberOfDilutions],
          CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Sample Out"],

          (* Otherwise, dilutionStrategy is Series, so we make numberOfDilutions + 1 samples out *)
          True,
            Table[CreateUniqueLabel[functionString <> " Sample " <> ToString[index] <> " Container Out"],{i,1,numberOfDilutions+1}]
        ]
      ],
      {
        Lookup[partiallyResolvedSpreadAndStreakCellsOptionsWithDilution,ContainerOutLabel],
        resolvedDestinationContainers,
        resolvedDilutionTypes,
        resolvedDilutionStrategies,
        resolvedNumberOfDilutions,
        Range[Length[mySamples]]
      }
    ]
  ];

  (* CONFLICTING OPTION CHECKS *)
  (* DilutionMismatchErrors *)
  dilutionMismatchOptions = If[MemberQ[allDilutionConflictErrors[[All,1]], True] && messages,
    Message[
      Error::DilutionMismatch,
      PickList[mySamples, allDilutionConflictErrors[[All,1]], True],
      PickList[allDilutionConflictErrors[[All,2]], allDilutionConflictErrors[[All,1]], True],
      PickList[Range[Length[mySamples]], allDilutionConflictErrors[[All,1]], True]
    ];
    {DilutionType},
    Nothing
  ];

  dilutionMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = PickList[mySamples, allDilutionConflictErrors[[All,1]], True];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a non mismatched dilution options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have non mismatched dilution options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* SampleOutLabelMismatch *)
  sampleOutLabelMismatch = MapThread[
    Function[{sample, sampleOutLabel, dilutionType, dilutionStrategy, numberOfDilutions, index},
      Which[
        (* If dilution strategy is EndPoint, we can only have a single sampleOutLabel *)
        MatchQ[dilutionStrategy, Endpoint] && Length[ToList[sampleOutLabel]] > 1,
          {sample, sampleOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Null and dilutionType is Null, we are not diluting and have a single sample out *)
        MatchQ[dilutionStrategy, Null] && MatchQ[dilutionType, Null] && Length[ToList[sampleOutLabel]] > 1,
        {sample, sampleOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Null and dilutionType is Linear, we must have NumberOfDilutions sample out labels *)
        MatchQ[dilutionStrategy, Null] && !NullQ[numberOfDilutions] && Length[ToList[sampleOutLabel]] != (numberOfDilutions),
        {sample, sampleOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Series, we must have as many sample out labels as number of dilutions + 1 *)
        MatchQ[dilutionStrategy, Series] && !NullQ[numberOfDilutions] && Length[ToList[sampleOutLabel]] != (numberOfDilutions + 1),
        {sample, sampleOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* Otherwise, were good *)
        True,
        Nothing
      ]
    ],
    {mySamples, resolvedSampleOutLabels, resolvedDilutionTypes, resolvedDilutionStrategies, resolvedNumberOfDilutions, Range[Length[mySamples]]}
  ];

  sampleOutLabelMismatchOptions = If[Length[sampleOutLabelMismatch] > 0 && messages,
    Message[
      Error::SampleOutLabelMismatch,
      ObjectToString[sampleOutLabelMismatch[[All,1]], Cache -> combinedCache],
      sampleOutLabelMismatch[[All,2]],
      sampleOutLabelMismatch[[All,3]],
      sampleOutLabelMismatch[[All,4]],
      sampleOutLabelMismatch[[All,5]]
    ];
    {SampleOutLabel},
    {}
  ];

  sampleOutLabelMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = sampleOutLabelMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a valid length SampleOutLabel option:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a valid length SampleOutLabel option:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* containerOutLabelMismatch *)
  containerOutLabelMismatch = MapThread[
    Function[{sample, containerOutLabel, dilutionType, dilutionStrategy, numberOfDilutions, index},
      Which[
        (* If dilution strategy is EndPoint, we can only have a single containerOutLabel *)
        MatchQ[dilutionStrategy, Endpoint] && Length[ToList[containerOutLabel]] > 1,
        {sample, containerOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Null and dilutionType is Null, we are not diluting and have a single sample out *)
        MatchQ[dilutionStrategy, Null] && MatchQ[dilutionType, Null] && Length[ToList[containerOutLabel]] > 1,
        {sample, containerOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Series, we must have NumberOfDilutions sample out labels *)
        MatchQ[dilutionStrategy, Null] && !NullQ[numberOfDilutions] && Length[ToList[containerOutLabel]] != (numberOfDilutions),
        {sample, containerOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* If dilution strategy is Series, we must have as many container out labels as number of dilutions + 1 *)
        MatchQ[dilutionStrategy, Series] && !NullQ[numberOfDilutions] && Length[ToList[containerOutLabel]] != (numberOfDilutions + 1),
        {sample, containerOutLabel, dilutionStrategy, numberOfDilutions, index},
        (* Otherwise, were good *)
        True,
        Nothing
      ]
    ],
    {mySamples, resolvedContainerOutLabels, resolvedDilutionTypes, resolvedDilutionStrategies, resolvedNumberOfDilutions, Range[Length[mySamples]]}
  ];

  containerOutLabelMismatchOptions = If[Length[containerOutLabelMismatch] > 0 && messages,
    Message[
      Error::ContainerOutLabelMismatch,
      ObjectToString[containerOutLabelMismatch[[All,1]], Cache -> combinedCache],
      containerOutLabelMismatch[[All,2]],
      containerOutLabelMismatch[[All,3]],
      containerOutLabelMismatch[[All,4]],
      containerOutLabelMismatch[[All,5]]
    ];
    {SampleOutLabel},
    {}
  ];

  containerOutLabelMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = containerOutLabelMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a valid length ContainerOutLabel option:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a valid length ContainerOutLabel option:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Source Mixing *)
  sourceMixMismatch = MapThread[
    Function[{sample,sourceMix,sourceMixVolume, numberOfSourceMixes,index},
      If[
        Or[
          And[
            TrueQ[sourceMix],
            Or[
              NullQ[sourceMixVolume],
              NullQ[numberOfSourceMixes]
            ]
          ],
          And[
            !TrueQ[sourceMix],
            Or[
              VolumeQ[sourceMixVolume],
              NumberQ[numberOfSourceMixes]
            ]
          ]
        ],
        {sample,sourceMix,sourceMixVolume, numberOfSourceMixes,index},
        Nothing
      ]
    ],
    {mySamples,resolvedSourceMixes,resolvedSourceMixVolumes,resolvedNumberOfSourceMixes,Range[Length[mySamples]]}
  ];

  sourceMixMismatchOptions = If[Length[sourceMixMismatch] > 0 && messages,
    Message[
      Error::SourceMixMismatch,
      ObjectToString[sourceMixMismatch[[All,1]], Cache -> combinedCache],
      sourceMixMismatch[[All,2]],
      sourceMixMismatch[[All,3]],
      sourceMixMismatch[[All,4]],
      sourceMixMismatch[[All,5]]
    ];
    {SourceMix,SourceMixVolume,NumberOfSourceMixes},
    {}
  ];

  sourceMixMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = sourceMixMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have conflicting SourceMix options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have conflicting SourceMix options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Error::ColonyHandlerHeadCassetteMismatch *)
  colonyHandlerHeadCassetteMismatches = MapThread[
    Function[{sample,tool,headDiameter,headLength,numberOfHeads,application,index},
      If[
        Or[
          !NullQ[tool] && !MatchQ[headDiameter,RangeP[fastAssocLookup[combinedFastAssoc,tool,HeadDiameter]]],
          !NullQ[tool] && !MatchQ[headLength,RangeP[fastAssocLookup[combinedFastAssoc,tool,HeadLength]]],
          !NullQ[tool] && !MatchQ[numberOfHeads,fastAssocLookup[combinedFastAssoc,tool,NumberOfHeads]],
          !NullQ[tool] && !MatchQ[application,fastAssocLookup[combinedFastAssoc,tool,Application]]
        ],
        {sample,tool,headDiameter,headLength,numberOfHeads,application,index},
        Nothing
      ]
    ],
    {mySamples,If[MatchQ[experimentFunction,ExperimentSpreadCells],resolvedColonySpreadingTools,resolvedColonyStreakingTools],resolvedHeadDiameters,resolvedHeadLengths,resolvedNumberOfHeads,resolvedColonyHandlerHeadCassetteApplications,Range[Length[mySamples]]}
  ];

  colonyHandlerHeadCassetteMismatchOptions = If[Length[colonyHandlerHeadCassetteMismatches] > 0 && messages,
    Message[
      Error::ColonyHandlerHeadCassetteMismatch,
      ObjectToString[colonyHandlerHeadCassetteMismatches[[All,1]], Cache -> combinedCache],
      ObjectToString[colonyHandlerHeadCassetteMismatches[[All,2]], Cache -> combinedCache],
      colonyHandlerHeadCassetteMismatches[[All,3]],
      colonyHandlerHeadCassetteMismatches[[All,4]],
      colonyHandlerHeadCassetteMismatches[[All,5]],
      colonyHandlerHeadCassetteMismatches[[All,6]],
      colonyHandlerHeadCassetteMismatches[[All,7]]
    ];
    {ColonySpreadingTool,HeadDiameter,HeadLength,NumberOfHeads,ColonyHandlerHeadCassetteApplication},
    {}
  ];

  colonyHandlerHeadCassetteMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = colonyHandlerHeadCassetteMismatches[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have conflicting colony spreading tool options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have conflicting colony spreading tool options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Error::NoColonyHandlerSpreadingHeadFound *)
  noColonyHandlerSpreadingHeadFoundErrors = MapThread[
    Function[{sample,colonySpreadingTool,index},
      If[
        MatchQ[experimentFunction,ExperimentSpreadCells] && NullQ[colonySpreadingTool],
        {sample,index},
        Nothing
      ]
    ],
    {mySamples,resolvedColonySpreadingTools,Range[Length[mySamples]]}
  ];

  noColonyHandlerSpreadingHeadFoundOptions = If[Length[noColonyHandlerSpreadingHeadFoundErrors] > 0 && messages,
    Message[
      Error::NoColonyHandlerSpreadingHeadFound,
      ObjectToString[noColonyHandlerSpreadingHeadFoundErrors[[All,1]], Cache -> combinedCache],
      noColonyHandlerSpreadingHeadFoundErrors[[All,2]]
    ];
    {ColonySpreadingTool,HeadDiameter,HeadLength,NumberOfHeads,ColonyHandlerHeadCassetteApplication},
    {}
  ];

  noColonyHandlerSpreadingHeadFoundTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noColonyHandlerSpreadingHeadFoundErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have a valid ColonyHandlerSpreadingHead:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have a valid ColonyHandlerSpreadingHead:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Error::NoColonyHandlerStreakingHeadFound *)
  noColonyHandlerStreakingHeadFoundErrors = MapThread[
    Function[{sample,colonyStreakingTool,index},
      If[
        MatchQ[experimentFunction,ExperimentStreakCells] && NullQ[colonyStreakingTool],
        {sample,index},
        Nothing
      ]
    ],
    {mySamples,resolvedColonyStreakingTools,Range[Length[mySamples]]}
  ];

  noColonyHandlerStreakingHeadFoundOptions = If[Length[noColonyHandlerStreakingHeadFoundErrors] > 0 && messages,
    Message[
      Error::NoColonyHandlerStreakingHeadFound,
      ObjectToString[noColonyHandlerStreakingHeadFoundErrors[[All,1]], Cache -> combinedCache],
      noColonyHandlerStreakingHeadFoundErrors[[All,2]]
    ];
    {ColonyStreakingTool,HeadDiameter,HeadLength,NumberOfHeads,ColonyHandlerHeadCassetteApplication},
    {}
  ];

  noColonyHandlerStreakingHeadFoundTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noColonyHandlerStreakingHeadFoundErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have a valid ColonyHandlerStreakingHead:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have a valid ColonyHandlerStreakingHead:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Error::SpreadPatternMismatch*)
  spreadPatternMismatchErrors = MapThread[
    Function[{sample,spreadPatternType,customSpreadPattern,index},
      If[
        Or[
          And[
            !MatchQ[spreadPatternType,Custom],
            !NullQ[customSpreadPattern]
          ],
          And[
            MatchQ[spreadPatternType,Custom],
            NullQ[customSpreadPattern]
          ]
        ],
        {sample,spreadPatternType,customSpreadPattern,index},
        Nothing
      ]
    ],
    {mySamples,resolvedSpreadPatternTypes,resolvedCustomSpreadPatterns,Range[Length[mySamples]]}
  ];

  spreadPatternMismatchOptions = If[Length[spreadPatternMismatchErrors] > 0 && messages,
    Message[
      Error::SpreadPatternMismatch,
      ObjectToString[spreadPatternMismatchErrors[[All,1]], Cache -> combinedCache],
      spreadPatternMismatchErrors[[All,2]],
      spreadPatternMismatchErrors[[All,3]],
      spreadPatternMismatchErrors[[All,4]]
    ];
    {SpreadPatternType,CustomSpreadPattern},
    {}
  ];

  spreadPatternMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = spreadPatternMismatchErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have a conflicting spread pattern type options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have a conflicting spread pattern type options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Error::StreakPatternMismatch*)
  streakPatternMismatchErrors = MapThread[
    Function[{sample,streakPatternType,customStreakPattern,numberOfSegments,hatchesPerSegment,index},
      Which[
        MatchQ[experimentFunction,ExperimentSpreadCells],
          Nothing,
        Or[
          And[
            MatchQ[streakPatternType,Custom],
            Or[
              NullQ[customStreakPattern],
              !NullQ[numberOfSegments],
              !NullQ[hatchesPerSegment]
            ]
          ],
          And[
            MatchQ[streakPatternType,RotatedHatches|LinearHatches],
            Or[
              !NullQ[customStreakPattern],
              NullQ[numberOfSegments],
              NullQ[hatchesPerSegment]
            ]
          ],
          And[
            MatchQ[streakPatternType,Radiant],
            Or[
              !NullQ[customStreakPattern],
              !NullQ[numberOfSegments],
              !NullQ[hatchesPerSegment]
            ]
          ]
        ],
          {sample,streakPatternType,customStreakPattern,numberOfSegments,hatchesPerSegment,index},
        True,
          Nothing
      ]
    ],
    {mySamples,resolvedStreakPatternTypes,resolvedCustomStreakPatterns,resolvedNumberOfSegments,resolvedHatchesPerSegments,Range[Length[mySamples]]}
  ];

  streakPatternMismatchOptions = If[Length[streakPatternMismatchErrors] > 0 && messages,
    Message[
      Error::StreakPatternMismatch,
      ObjectToString[streakPatternMismatchErrors[[All,1]], Cache -> combinedCache],
      streakPatternMismatchErrors[[All,2]],
      streakPatternMismatchErrors[[All,3]],
      streakPatternMismatchErrors[[All,4]],
      streakPatternMismatchErrors[[All,5]],
      streakPatternMismatchErrors[[All,6]]
    ];
    {StreakPatternType,CustomStreakPattern,NumberOfSegments,HatchesPerSegment},
    {}
  ];

  streakPatternMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = streakPatternMismatchErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have a conflicting streak pattern type options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have a conflicting streak pattern type options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];
  
  (* Error::InvalidDestinationContainerType *)
  invalidDestinationContainerTypeErrors = MapThread[
    Function[{sample,dilutionStrategy,destinationContainer,index},
      If[
        And[
          MatchQ[dilutionStrategy,Series],
          !MatchQ[destinationContainer,ObjectP[Model[Container]]]
        ],
        {sample,destinationContainer,index},
        Nothing
      ]
    ],
    {mySamples,resolvedDilutionStrategies,resolvedDestinationContainers,Range[Length[mySamples]]}
  ];

  invalidDestinationContainerTypeOptions = If[Length[invalidDestinationContainerTypeErrors] > 0 && messages,
    Message[
      Error::InvalidDestinationContainerType,
      ObjectToString[invalidDestinationContainerTypeErrors[[All,1]], Cache -> combinedCache],
      ObjectToString[invalidDestinationContainerTypeErrors[[All,2]], Cache -> combinedCache],
      invalidDestinationContainerTypeErrors[[All,3]]

    ];
    {DilutionStrategy,DestinationContainer},
    {}
  ];

  invalidDestinationContainerTypeTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidDestinationContainerTypeErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have a conflicting DilutionStrategy and DestinationContainer:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " do not have a conflicting DilutionStrategy and DestinationContainer:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Error::NoAvailablePositionsInContainer *)
  noAvailablePositionsInContainerErrors = MapThread[
    Function[{sample,well,container,index},
      If[
        And[
          MatchQ[container,ObjectP[Object[Container]]],
          !MemberQ[Lookup[destinationContainerOpenPositionLookup, container], well]
        ],
        {sample,index},
        Nothing
      ]
    ],
    {mySamples,resolvedDestinationWells,resolvedDestinationContainers,Range[Length[mySamples]]}
  ];

  noAvailablePositionsInContainerOptions = If[Length[noAvailablePositionsInContainerErrors] > 0 && messages,
    Message[
      Error::NoAvailablePositionsInContainer ,
      ObjectToString[noAvailablePositionsInContainerErrors[[All,1]], Cache -> combinedCache],
      noAvailablePositionsInContainerErrors[[All,2]]

    ];
    {DestinationContainer},
    {}
  ];

  noAvailablePositionsInContainerTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = noAvailablePositionsInContainerErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have available positions to spread cells in the DestinationContainer:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have available positions to spread cells in the DestinationContainer:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Error::DilutionFinalVolumeTooSmall *)
  dilutionFinalVolumeTooSmallErrors = MapThread[
    Function[{sample,finalVolume,depositVolume,dispenseCoords, dilutionStrategy, index},
      Module[{},
        Which[
          (* If the dilution strategy is series, all final volumes must be less than deposit volume * number of dispenses *)
          MatchQ[dilutionStrategy,Series],
            If[
              Or@@Map[(LessQ[#,depositVolume * Length[dispenseCoords]])&,finalVolume],
              {sample,If[MatchQ[experimentFunction,ExperimentSpreadCells],"SpreadVolume", "StreakVolume"],depositVolume,dispenseCoords, finalVolume, dilutionStrategy, index},
              Nothing
            ],
          (* If dilution strategy is Endpoint, just the last final volume must be less than deposit volume * number of dispenses *)
          MatchQ[dilutionStrategy,Endpoint],
            If[
              LessQ[Last[finalVolume],depositVolume * Length[dispenseCoords]],
              {sample,If[MatchQ[experimentFunction,ExperimentSpreadCells],"SpreadVolume", "StreakVolume"],depositVolume,dispenseCoords, finalVolume, dilutionStrategy, index},
              Nothing
            ],
          (* Otherwise, if we are not diluting, we are good *)
          True,
          Nothing
        ]
      ]
    ],
    {mySamples,resolvedDilutionFinalVolumes,If[MatchQ[experimentFunction,ExperimentSpreadCells],resolvedSpreadVolumes,resolvedStreakVolumes],resolvedDispenseCoordinates,resolvedDilutionStrategies,Range[Length[mySamples]]}
  ];

  dilutionFinalVolumeTooSmallOptions = If[Length[dilutionFinalVolumeTooSmallErrors] > 0 && messages,
    Message[
      Error::DilutionFinalVolumeTooSmall,
      ObjectToString[dilutionFinalVolumeTooSmallErrors[[All,1]], Cache -> combinedCache],
      dilutionFinalVolumeTooSmallErrors[[All,2]],
      dilutionFinalVolumeTooSmallErrors[[All,3]],
      dilutionFinalVolumeTooSmallErrors[[All,4]],
      dilutionFinalVolumeTooSmallErrors[[All,5]],
      dilutionFinalVolumeTooSmallErrors[[All,6]],
      dilutionFinalVolumeTooSmallErrors[[All,7]]
    ];
    {DilutionFinalVolume,If[MatchQ[experimentFunction,ExperimentSpreadCells],SpreadVolume,StreakVolume],DispenseCoordinates,DilutionStrategy},
    {}
  ];

  dilutionFinalVolumeTooSmallTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = dilutionFinalVolumeTooSmallErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a DilutionFinalVolume that is greater than the " <> If[MatchQ[experimentFunction,ExperimentSpreadCells],"SpreadVolume","StreakVolume"] <> " times the number of dispense locations:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a DilutionFinalVolume that is greater than the " <> If[MatchQ[experimentFunction,ExperimentSpreadCells],"SpreadVolume","StreakVolume"] <> " times the number of dispense locations:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Warning::SpreadingMultipleSamplesOnSamePlate *)
  (* Get the Object[Container]'s that appear twice *)
  duplicateDestinationContainerObjects = (Tally[Cases[resolvedDestinationContainers,ObjectP[Object[Container]]]]/.{{_,LessP[2]} :> Nothing})[[All,1]];
  spreadingMultipleSamplesOnSamePlateWarnings = MapThread[
    Function[{sample,destinationContainer,index},
      If[
        MemberQ[duplicateDestinationContainerObjects,destinationContainer],
        {sample,destinationContainer,index},
        Nothing
      ]
    ],
    {mySamples,resolvedDestinationContainers,Range[Length[mySamples]]}
  ];

  If[Length[spreadingMultipleSamplesOnSamePlateWarnings] > 0 && messages,
    Message[
      Warning::SpreadingMultipleSamplesOnSamePlate ,
      ObjectToString[spreadingMultipleSamplesOnSamePlateWarnings[[All,1]], Cache -> combinedCache],
      ObjectToString[spreadingMultipleSamplesOnSamePlateWarnings[[All,2]], Cache -> combinedCache],
      spreadingMultipleSamplesOnSamePlateWarnings[[All,3]]
    ]
  ];

  (* Error::InvalidDestinationContainer *)
  invalidDestinationContainerErrors = MapThread[
    Function[{sample,destinationContainer,index},
      If[
        GreaterQ[fastAssocLookup[combinedFastAssoc,destinationContainer,NumberOfWells],1],
        {sample,destinationContainer,index},
        Nothing
      ]
    ],
    {mySamples,resolvedDestinationContainers,Range[Length[mySamples]]}
  ];

  invalidDestinationContainerOptions = If[Length[invalidDestinationContainerErrors] > 0 && messages,
    Message[
      Error::InvalidDestinationContainer,
      ObjectToString[invalidDestinationContainerErrors[[All,1]], Cache -> combinedCache],
      ObjectToString[invalidDestinationContainerErrors[[All,2]], Cache -> combinedCache],
      invalidDestinationContainerErrors[[All,3]]
    ];
    {DestinationContainer},
    {}
  ];

  invalidDestinationContainerTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidDestinationContainerErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have destination containers with more than one well", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have destination containers with more than one well", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Error::InvalidDestinationWell*)
  invalidDestinationWellErrors = MapThread[
    Function[{sample,destinationContainer,destinationWell,index},
      Module[{validPositions},
        (* Get the valid positions in the container *)
        validPositions = If[MatchQ[destinationContainer,ObjectP[Model[Container]]],
          fastAssocLookup[combinedFastAssoc,destinationContainer,Positions]/.$Failed->Null,
          fastAssocLookup[combinedFastAssoc,destinationContainer,{Model,Positions}/.$Failed->Null]
        ];

        If[!MemberQ[Lookup[validPositions,Name],destinationWell],
          {sample,destinationWell,destinationContainer,index},
          Nothing
        ]
      ]
    ],
    {mySamples,resolvedDestinationContainers,resolvedDestinationWells,Range[Length[mySamples]]}
  ];

  invalidDestinationWellOptions = If[Length[invalidDestinationWellErrors] > 0 && messages,
    Message[
      Error::InvalidDestinationWell,
      ObjectToString[invalidDestinationWellErrors[[All,1]], Cache -> combinedCache],
      invalidDestinationWellErrors[[All,2]],
      ObjectToString[invalidDestinationWellErrors[[All,3]], Cache -> combinedCache],
      invalidDestinationWellErrors[[All,4]]

    ];
    {DestinationContainer,DestinationWell},
    {}
  ];

  invalidDestinationWellTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidDestinationWellErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a destination well that is a position in its destination container.", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a destination well that is a position in its destination container.", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Error::ConflictingDestinationMedia*)
  conflictingDestinationMediaErrors = MapThread[
    Function[{sample,destinationMedia,destinationContainer,destinationWell,index},
      Module[{containerContents,sampleInContainer,sampleInContainerModel,destinationMediaModel,equalToMediaBool},
        (* Get the contents in the container *)
        containerContents = fastAssocLookup[combinedFastAssoc,destinationContainer,Contents]/.{$Failed -> {}};

        (* Get the sample in the contents if there is one *)
        sampleInContainer = FirstCase[containerContents,{destinationWell,x_}:>x,Null];

        (* Get the model of the sample *)
        sampleInContainerModel = fastAssocLookup[combinedFastAssoc,sampleInContainer,Model]/.{$Failed -> Null};

        (* Get the destination media model *)
        destinationMediaModel = If[MatchQ[destinationMedia,ObjectP[Model[Sample]]],
          destinationMedia,
          fastAssocLookup[combinedFastAssoc,destinationMedia,Model]/.{$Failed -> Null}
        ];

        (* Define a bool to see if the sample is equal to destinationMedia *)
        equalToMediaBool = MatchQ[sampleInContainerModel,ObjectP[destinationMediaModel]] || MatchQ[sampleInContainer,ObjectP[destinationMedia]];

        (* If the media are not equal, we have an error *)
        If[!NullQ[sampleInContainerModel]&&!equalToMediaBool,
          {sample,destinationMedia,destinationWell,destinationContainer,index},
          Nothing
        ]
      ]
    ],
    {mySamples,resolvedDestinationMedia,resolvedDestinationContainers,resolvedDestinationWells,Range[Length[mySamples]]}
  ];

  conflictingDestinationMediaOptions = If[Length[conflictingDestinationMediaErrors] > 0 && messages,
    Message[
      Error::ConflictingDestinationMedia,
      ObjectToString[conflictingDestinationMediaErrors[[All,1]], Cache -> combinedCache],
      ObjectToString[conflictingDestinationMediaErrors[[All,2]], Cache -> combinedCache],
      conflictingDestinationMediaErrors[[All,3]],
      ObjectToString[conflictingDestinationMediaErrors[[All,4]], Cache -> combinedCache],
      conflictingDestinationMediaErrors[[All,5]]

    ];
    {DestinationMedia,DestinationContainer,DestinationWell},
    {}
  ];

  conflictingDestinationMediaTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingDestinationMediaErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a destination media that is the same sample as the sample in the destination container.", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a destination media that is the same sample as the sample in the destination container.", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Error::DestinationMediaNotSolid*)
  destinationMediaNotSolidErrors = MapThread[
    Function[{sample,destinationMedia,index},
      If[
        !MatchQ[fastAssocLookup[combinedFastAssoc,destinationMedia,State],Solid],
        {sample,destinationMedia,index},
        Nothing
      ]
    ],
    {mySamples,resolvedDestinationMedia,Range[Length[mySamples]]}
  ];

  destinationMediaNotSolidOptions = If[Length[destinationMediaNotSolidErrors] > 0 && messages,
    Message[
      Error::DestinationMediaNotSolid,
      ObjectToString[destinationMediaNotSolidErrors[[All,1]], Cache -> combinedCache],
      ObjectToString[destinationMediaNotSolidErrors[[All,2]], Cache -> combinedCache],
      destinationMediaNotSolidErrors[[All,3]]

    ];
    {DestinationMedia},
    {}
  ];

  destinationMediaNotSolidTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = destinationMediaNotSolidErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a destination media that is solid.", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a destination media that is solid.", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*(* Error::TotalDilutionVolumeTooLarge *)
  totalDilutionVolumeTooLargeErrors = MapThread[
    Function[{sample, totalDilutionVolumes, index},
      If[
        MemberQ[totalDilutionVolumes, GreaterP[1.9 Milliliter]],
        {sample, totalDilutionVolumes, index},
        Nothing
      ]
    ],
    {mySamples, resolvedTotalDilutionVolumes, Range[Length[mySamples]]}
  ];

  totalDilutionVolumeTooLargeOptions = If[Length[totalDilutionVolumeTooLargeErrors] > 0 && messages,
    Message[
      Error::TotalDilutionVolumeTooLarge,
      ObjectToString[totalDilutionVolumeTooLargeErrors[[All,1]], Cache -> combinedCache],
      totalDilutionVolumeTooLargeErrors[[All,2]],
      totalDilutionVolumeTooLargeErrors[[All,3]]

    ];
    {TotalDilutionVolume},
    {}
  ];

  totalDilutionVolumeTooLargeTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = totalDilutionVolumeTooLargeErrors[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have a total dilution volume less than or equal to 1.9 Milliliters for all stages of dilution.", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[mySamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> combinedCache] <> " have a total dilution volume less than or equal to 1.9 Milliliters for all stages of dilution.", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];*)

  invalidOptions = DeleteDuplicates@Flatten[
    {
      destinationMediaNotSolidOptions,
      conflictingDestinationMediaOptions,
      invalidDestinationWellOptions,
      invalidDestinationContainerOptions,
      noAvailablePositionsInContainerOptions,
      dilutionFinalVolumeTooSmallOptions,
      invalidDestinationContainerTypeOptions,
      streakPatternMismatchOptions,
      spreadPatternMismatchOptions,
      noColonyHandlerStreakingHeadFoundOptions,
      noColonyHandlerSpreadingHeadFoundOptions,
      colonyHandlerHeadCassetteMismatchOptions,
      sourceMixMismatchOptions,
      dilutionMismatchOptions,
      sampleOutLabelMismatchOptions,
      containerOutLabelMismatchOptions
    }
  ];

  invalidInputs = DeleteDuplicates@Flatten[
    {
      sanitizationOptionInvalidInputs,
      nonLiquidInvalidInputs,
      discardedInvalidInputs
    }
  ];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[And[Length[invalidInputs]>0,messages],
    Message[Error::InvalidInput,ObjectToString/@invalidInputs]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[And[Length[invalidOptions]>0,messages],
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Gather the resolved options *)
  resolvedOptions = Join[
    {
      Instrument->resolvedInstrument,
      DilutionType -> resolvedDilutionTypes,
      DilutionStrategy -> resolvedDilutionStrategies,
      NumberOfDilutions -> resolvedNumberOfDilutions,
      DilutionTargetAnalyte -> resolvedDilutionTargetAnalytes,
      CumulativeDilutionFactor -> resolvedCumulativeDilutionFactors,
      SerialDilutionFactor -> resolvedSerialDilutionFactors,
      DilutionTargetAnalyteConcentration -> resolvedDilutionTargetAnalyteConcentrations,
      DilutionTransferVolume -> resolvedDilutionTransferVolumes,
      TotalDilutionVolume -> resolvedTotalDilutionVolumes,
      DilutionFinalVolume -> resolvedDilutionFinalVolumes,
      DilutionDiscardFinalTransfer -> resolvedDilutionDiscardFinalTransfers,
      Diluent -> resolvedDiluents,
      DiluentVolume -> resolvedDiluentVolumes,
      DilutionConcentratedBuffer -> resolvedConcentratedBuffers,
      ConcentratedBufferVolume -> resolvedConcentratedBufferVolumes,
      ConcentratedBufferDiluent -> resolvedConcentratedBufferDiluents,
      ConcentratedBufferDilutionFactor -> resolvedConcentratedBufferDilutionFactors,
      ConcentratedBufferDiluentVolume -> resolvedConcentratedBufferDiluentVolumes,
      DilutionIncubate -> resolvedDilutionIncubates,
      DilutionIncubationTime -> resolvedDilutionIncubationTimes,
      DilutionIncubationInstrument -> resolvedDilutionIncubationInstruments,
      DilutionIncubationTemperature -> resolvedDilutionIncubationTemperatures,
      DilutionMixType -> resolvedDilutionMixTypes,
      DilutionNumberOfMixes -> resolvedDilutionNumberOfMixes,
      DilutionMixRate -> resolvedDilutionMixRates,
      DilutionMixOscillationAngle -> resolvedDilutionMixOscillationAngles,
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        SpreadVolume -> resolvedSpreadVolumes,
        StreakVolume -> resolvedStreakVolumes
      ],
      SourceMix -> resolvedSourceMixes,
      SourceMixVolume -> resolvedSourceMixVolumes,
      NumberOfSourceMixes -> resolvedNumberOfSourceMixes,
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        ColonySpreadingTool -> resolvedColonySpreadingTools,
        ColonyStreakingTool -> resolvedColonyStreakingTools
      ],
      HeadDiameter->resolvedHeadDiameters,
      HeadLength->resolvedHeadLengths,
      NumberOfHeads->resolvedNumberOfHeads,
      ColonyHandlerHeadCassetteApplication->resolvedColonyHandlerHeadCassetteApplications,
      DestinationMedia->resolvedDestinationMedia,
      DestinationContainer->resolvedDestinationContainers,
      DestinationWell -> resolvedDestinationWells,
      DispenseCoordinates -> resolvedDispenseCoordinates,
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        Sequence@@{
          SpreadPatternType -> resolvedSpreadPatternTypes,
          CustomSpreadPattern -> resolvedCustomSpreadPatterns
        },
        Sequence@@{
          StreakPatternType -> resolvedStreakPatternTypes,
          CustomStreakPattern -> resolvedCustomStreakPatterns,
          NumberOfSegments -> resolvedNumberOfSegments,
          HatchesPerSegment -> resolvedHatchesPerSegments
        }
      ],
      Preparation->resolvedPreparation,
      WorkCell->resolvedWorkCell,

      SamplesInStorageCondition -> resolvedSamplesInStorageCondition,
      SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,

      SampleLabel->resolvedSampleLabels,
      SampleContainerLabel->resolvedSampleContainerLabels,
      SampleOutLabel->resolvedSampleOutLabels,
      ContainerOutLabel->resolvedContainerOutLabels,

      DilutionConflictErrors -> allDilutionConflictErrors
    },
    resolvedSanitizationOptions
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> Flatten[{
      resolvedOptions
    }],

    Tests -> Flatten[{
      discardedTest,
      nonLiquidTest,
      destinationMediaNotSolidTests,
      conflictingDestinationMediaTests,
      invalidDestinationWellTests,
      invalidDestinationContainerTests,
      noAvailablePositionsInContainerTests,
      dilutionFinalVolumeTooSmallTests,
      invalidDestinationContainerTypeTests,
      streakPatternMismatchTests,
      spreadPatternMismatchTests,
      noColonyHandlerStreakingHeadFoundTests,
      noColonyHandlerSpreadingHeadFoundTests,
      colonyHandlerHeadCassetteMismatchTests,
      sourceMixMismatchTests,
      dilutionMismatchTests,
      sampleOutLabelMismatchTests,
      containerOutLabelMismatchTests,
      sanitizationOptionTests,
      compatibleMaterialsTests
    }]
  }
];

(* ::Subsection::Closed:: *)
(*Resource Packets*)
DefineOptions[streakAndSpreadCellsResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

streakAndSpreadCellsResourcePackets[
  mySamples:{ObjectP[Object[Sample]]..},
  myUnresolvedOptions:{_Rule...},
  myResolvedOptions:{_Rule...},
  experimentFunction:ExperimentStreakCells | ExperimentSpreadCells,
  ops:OptionsPattern[streakAndSpreadCellsResourcePackets]
] := Module[
  {
    unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,
    gatherTests,messages,inheritedCache,simulation,currentSimulation,resolvedPreparation,
    specifiedInstrument, specifiedDilutionType, specifiedDilutionStrategy, specifiedDilutionTransferVolume,
    specifiedDiluent, specifiedDiluentVolume, specifiedConcentratedBuffer, specifiedConcentratedBufferVolume,
    specifiedConcentratedBufferDiluent, specifiedConcentratedBufferDiluentVolume, specifiedDilutionFinalVolume,specifiedNumberOfDilutions,
    specifiedTotalDilutionVolumes,specifiedDilutionIncubation,
    specifiedDilutionIncubationTime, specifiedDilutionIncubationInstrument, specifiedDilutionIncubationTemperature, specifiedDilutionMixType,
    specifiedDilutionNumberOfMixes, specifiedDilutionMixRate, specifiedDilutionMixOscillationAngle, specifiedSpreadStreakVolume,
    specifiedColonyStreakSpreadTool, specifiedDispenseCoordinate, specifiedDestinationContainer, specifiedDestinationWell,
    specifiedDestinationMedia, specifiedPrimaryWashSolution, specifiedSecondaryWashSolution, specifiedTertiaryWashSolution,
    specifiedQuaternaryWashSolution,dilutionConflictErrors,

    (* Download *)
    sampleContainerPackets,sampleContainerModelPackets,specifiedDestinationContainerObjectPackets,specifiedDestinationContainerModelPackets,
    fastAssoc,

    (* Gathering resources *)
    runTime,instrumentResource,
    samplesInVolumesRequired,samplesInAndVolumes,samplesInResourceReplaceRules,samplesInResources,
    colonyStreakSpreadToolResourceReplaceRules,colonyStreakSpreadToolResources,uniqueWashSolutions,
    uniqueWashSolutionVolumes,washSolutionsAndVolumes,washSolutionResourceLookup,primaryWashSolutionResources,
    secondaryWashSolutionResources,tertiaryWashSolutionResources,quaternaryWashSolutionResources,

    qpixCompatibleContainers,assayContainerResources,assayContainerPrimitives, sampleToWellLabelMapping,
    destinationContainerResources, destinationContainerResourceLengths,mySampleToContainersSpreadMapping,assayContainerLabelLookup,
    splitOptionPackets,samplePackets,
    unitOpGroupedByColonyHandlerHeadCassette,finalPhysicalGroups,carrierDeckPlateLocations,numTipsRequired,riserPlacements,
    carrierPlacements, riserReturns, carrierReturns, initialCarrierAndRiserResourcesToPick, colonyHandlerHeadCassetteAdds,
    colonyHandlerHeadCassetteRemovals,flatLightTableContainersPerPhysicalBatch,flatLightTableContainerPlacementsPerPhysicalBatch,
    lightTableContainerLengthsPerPhysicalBatch,carrierContainerDeckPlacements, tipRackPlacements,tipRackReturns,
    batchedUnitOperationPackets, batchedUnitOperationPacketsWithID,streakSpreadUnitOperationPacket,
    rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,allResourceBlobs,
    fulfillable,frqTests,previewRule,optionsRule,resultRule,testsRule
  },
  
  (* Get the collapsed unresolved index-matching options that don't include hidden options *)
  unresolvedOptionsNoHidden=RemoveHiddenOptions[experimentFunction,myUnresolvedOptions];

  (* Get the collapsed resolved index-matching options that don't include hidden options *)
  (* Ignore to collapse those options that are set in expandedsafeoptions *)
  resolvedOptionsNoHidden=Quiet[
    CollapseIndexMatchedOptions[
      experimentFunction,
      RemoveHiddenOptions[experimentFunction,myResolvedOptions],
      Ignore->myUnresolvedOptions
    ],
    {Warning::CannotCollapse}
  ];

  (* Determine the requested output format of this function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Get the inherited cache *)
  inheritedCache=Lookup[ToList[ops],Cache,{}];
  simulation=Lookup[ToList[ops],Simulation,{}];

  (* Initialize the simulation if it does not exist *)
  currentSimulation = If[MatchQ[simulation,SimulationP],
    simulation,
    Simulation[]
  ];

  (* Get the resolved preparation scale *)
  resolvedPreparation=Lookup[myResolvedOptions,Preparation];
  
  (* Extract necessary resolved options *)
  {
    specifiedInstrument,
    specifiedDilutionType,
    specifiedDilutionStrategy,
    specifiedDilutionTransferVolume,
    specifiedDiluent,
    specifiedDiluentVolume,
    specifiedConcentratedBuffer,
    specifiedConcentratedBufferVolume,
    specifiedConcentratedBufferDiluent,
    specifiedConcentratedBufferDiluentVolume,
    specifiedDilutionFinalVolume,
    specifiedNumberOfDilutions,
    specifiedTotalDilutionVolumes,
    specifiedDilutionIncubation,
    specifiedDilutionIncubationTime,
    specifiedDilutionIncubationInstrument,
    specifiedDilutionIncubationTemperature,
    specifiedDilutionMixType,
    specifiedDilutionNumberOfMixes,
    specifiedDilutionMixRate,
    specifiedDilutionMixOscillationAngle,
    specifiedSpreadStreakVolume,
    specifiedColonyStreakSpreadTool,
    specifiedDispenseCoordinate,
    specifiedDestinationContainer,
    specifiedDestinationWell,
    specifiedDestinationMedia,
    specifiedPrimaryWashSolution,
    specifiedSecondaryWashSolution,
    specifiedTertiaryWashSolution,
    specifiedQuaternaryWashSolution,
    dilutionConflictErrors
  } = Lookup[myResolvedOptions,
    {
      Instrument,
      DilutionType,
      DilutionStrategy,
      DilutionTransferVolume,
      Diluent,
      DiluentVolume,
      DilutionConcentratedBuffer,
      ConcentratedBufferVolume,
      ConcentratedBufferDiluent,
      ConcentratedBufferDiluentVolume,
      DilutionFinalVolume,
      NumberOfDilutions,
      TotalDilutionVolume,
      DilutionIncubate,
      DilutionIncubationTime,
      DilutionIncubationInstrument,
      DilutionIncubationTemperature,
      DilutionMixType,
      DilutionNumberOfMixes,
      DilutionMixRate,
      DilutionMixOscillationAngle,
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        SpreadVolume,
        StreakVolume
      ],
      If[MatchQ[experimentFunction,ExperimentSpreadCells],
        ColonySpreadingTool,
        ColonyStreakingTool
      ],
      DispenseCoordinates,
      DestinationContainer,
      DestinationWell,
      DestinationMedia,
      PrimaryWashSolution,
      SecondaryWashSolution,
      TertiaryWashSolution,
      QuaternaryWashSolution,
      DilutionConflictErrors
    }
  ];

  (* Download information *)
  (* Split the destination containers into models and objects *)
  {
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    specifiedDestinationContainerObjectPackets,
    specifiedDestinationContainerModelPackets
  } = Quiet[
    Download[
      {
        mySamples,
        mySamples,
        mySamples,
        (* Split the destination containers into models and objects *)
        Cases[specifiedDestinationContainer,ObjectP[Object[Container]]],
        Cases[specifiedDestinationContainer,ObjectP[Model[Container]]]
      },
      {
        {
          Packet[Container]
        },
        {
          Packet[Container[Model,Contents]]
        },
        {
          Packet[Container[Model][WellDepth]]
        },
        {
          Packet[Model,Contents],
          Packet[Model[Positions, WellDepth]]
        },
        {
          Packet[Positions, WellDepth]
        }
      }
    ],
    {Download::FieldDoesntExist}
  ];

  (* Make a fast assoc from the packets *)
  fastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{
    samplePackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    specifiedDestinationContainerObjectPackets,
    specifiedDestinationContainerModelPackets
  }]];
  
  (* ---------------- First make resources for instrument, samplesIn, tools, destination containers ------------------------------ *)

  (* -- Generate the Instrument Resource -- *)
  (* Calculate the runTime of the experiment *)
  (* TODO: Actually estimate RunTime based on number of input samples *)
  runTime = 30 Minute;
  instrumentResource = Resource[Instrument -> specifiedInstrument,Time -> 30 Minute];

  (* SamplesIn *)
  (* Calculate the total volume we need of each sample in.  *)
  samplesInVolumesRequired = MapThread[
    Function[{spreadStreakVolume,transferVolume,dispenseCoordinates,dilutionType,dilutionStrategy},
      Which[
        (* If we aren't diluting - only need amount we are streaking/spreading *)
        MatchQ[dilutionType,Null],
          spreadStreakVolume * Length[dispenseCoordinates],

        (* If we are doing a linear dilution - need the sum of all the transfer volumes *)
        MatchQ[dilutionType,Linear],
          Total[transferVolume],

        (* If we are doing a serial dilution with Endpoint Strategy - only need the first TransferVolume *)
        MatchQ[dilutionType,Serial] && MatchQ[dilutionStrategy,Endpoint],
          First[transferVolume],

        (* If we are doing a serial dilution with Series Strategy - need both the transfer volume and amount we are spreading/streaking *)
        True,
          First[transferVolume] + (spreadStreakVolume * Length[dispenseCoordinates])
      ]
    ],
    {specifiedSpreadStreakVolume,specifiedDilutionTransferVolume,specifiedDispenseCoordinate,specifiedDilutionType,specifiedDilutionStrategy}
  ];

  (* Pair up each sample with its volume *)
  samplesInAndVolumes = Merge[MapThread[Association[#1->#2]&, {mySamples, samplesInVolumesRequired}],Total];

  samplesInResourceReplaceRules = (#->Resource[Sample -> #, Name -> ToString[Unique[]]])&/@DeleteDuplicates[mySamples];
  samplesInResources = mySamples /. samplesInResourceReplaceRules;

  (* Create a resource for the ColonySpreading/StreakingTool *)
  colonyStreakSpreadToolResourceReplaceRules = (# -> Resource[Sample -> #, Name -> ToString[Unique[]]])&/@DeleteDuplicates[Download[specifiedColonyStreakSpreadTool,Object]];
  colonyStreakSpreadToolResources = specifiedColonyStreakSpreadTool /. colonyStreakSpreadToolResourceReplaceRules;

  (* -- Create a resource for each unique wash solution -- *)
  (* Get the unique wash solutions *)
  uniqueWashSolutions = Download[DeleteDuplicates[Join[specifiedPrimaryWashSolution, specifiedSecondaryWashSolution, specifiedTertiaryWashSolution, specifiedQuaternaryWashSolution]]/.Null->Nothing,Object];

  (* For each wash solution, we need 150 mLs *)
  uniqueWashSolutionVolumes = ConstantArray[150 Milliliter,Length[uniqueWashSolutions]];

  (* Combine the wash solutions and volumes *)
  washSolutionsAndVolumes = MapThread[Rule,{uniqueWashSolutions,uniqueWashSolutionVolumes}];

  (* Create a lookup of Sample -> Resource *)
  washSolutionResourceLookup = (#[[1]] -> Resource[Sample -> #[[1]], Amount -> #[[2]], Container -> First[ToList@PreferredContainer[#[[1]], #[[2]]]], Name -> ToString[Unique[]]])&/@washSolutionsAndVolumes;

  (* Use the lookup to assign resources  *)
  primaryWashSolutionResources = specifiedPrimaryWashSolution /. washSolutionResourceLookup;
  secondaryWashSolutionResources = specifiedSecondaryWashSolution /. washSolutionResourceLookup;
  tertiaryWashSolutionResources = specifiedTertiaryWashSolution /. washSolutionResourceLookup;
  quaternaryWashSolutionResources = specifiedQuaternaryWashSolution /. washSolutionResourceLookup;

  (* -------------------------- Make resources for assay container/dilutions -------------------------- *)
  (* Create a list of qpix compatible containers *)
  (* TODO: Swap current DWP for Sterile DWP *)
  qpixCompatibleContainers = {
    Model[Container, Plate, "id:L8kPEjkmLbvW"], (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
    Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
  };

  (* Are we doing any dilutions? *)
  {
    assayContainerResources,
    assayContainerPrimitives,
    sampleToWellLabelMapping
  } = If[MemberQ[specifiedDilutionType,Except[Null]] && !MemberQ[dilutionConflictErrors[[All,1]], True],
    (* Yes *)
    Module[
      {
        multipleAssayContainerBool,assayContainerModel,qpixAssayContainerModel,assayContainerAvailableWells,qpixAssayContainerAvailableWells,
        assayContainerTotalNumberOfWells,qpixAssayContainerTotalNumberOfWells,totalNumberOfAssayContainers,totalNumberOfQPixAssayContainers,
        assayContainerLabels,qpixAssayContainerLabels, assayContainerLabelContainer,diluentLabelLookup, concentratedBufferLabelLookup,
        concentratedBufferDiluentLabelLookup, allInfoTuples, validTuplesNullVolumes,labelSamplePrimitive,
        allLabels, diluentLabels, concentratedBufferLabels,concentratedBufferDiluentLabels,
        assayContainerCurrentWell,assayContainerPreviousWell,assayContainerNextWells,currentAssayContainerLabel,previousAssayContainerLabel,nextAssayContainerLabels,
        qpixAssayContainerCurrentWell,qpixAssayContainerPreviousWell,qpixAssayContainerNextWells,currentQPixAssayContainerLabel,
        previousQPixAssayContainerLabel,nextQPixAssayContainerLabels,
        dilutionPrimitives,finalTransferTuples,sampleToSpreadSourceMapping,flattenedSampleToSpreadSourceMapping, finalTransferPrimitive,allPrimitives
      },

      (* If there is not a single TotalDilutionVolume > 1.9 mL then default to Model[Container, Plate, "96-well 2mL Deep Well Plate"], otherwise *)
      (* Use PreferredContainer on the max TotalDilutionVolume to determine the container(s) to use for the dilutions. Also define a  *)
      (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] as the qpix assay container that will house the final samples to be plated *)
      {
        multipleAssayContainerBool,
        assayContainerModel,
        qpixAssayContainerModel
      } = If[Length[Select[Flatten[specifiedTotalDilutionVolumes], GreaterQ[#,1.9 Milliliter]&]] < 1,
        {
          False,
          {},
          Model[Container, Plate, "id:L8kPEjkmLbvW"] (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
        },
        Module[{maxTotalDilutionVolume},
          (* Get the preferred vessel for dilutions *)
          maxTotalDilutionVolume = Max[Flatten[specifiedTotalDilutionVolumes]];

          {
            True,
            PreferredContainer[
              maxTotalDilutionVolume,
              Sterile -> True,
              Type -> Vessel,
              LiquidHandlerCompatible->True,
              Messages -> False
            ],
            Model[Container, Plate, "id:L8kPEjkmLbvW"] (* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
          }
        ]
      ];

      (* Get the available wells in the assay container *)
      (* TODO: Cache AllWells *)
      assayContainerAvailableWells = Flatten[AllWells[assayContainerModel]];
      qpixAssayContainerAvailableWells = Flatten[AllWells[qpixAssayContainerModel]];

      (* Figure out how many assay containers we will need and then make a label container primitive *)
      {
        assayContainerTotalNumberOfWells,
        qpixAssayContainerTotalNumberOfWells
      } = Total/@Transpose@MapThread[
        Function[{dilutionType,numberOfDilutions,dilutionStrategy},
          Which[
            (* If this sample is not being diluted - we need one well for the sample in the qpix assay container - none in the assay container *)
            NullQ[dilutionType],{0,1},
            (* If there was a dilution conflict error, assume one sample (no dilutions) *)
            NullQ[numberOfDilutions],{0,1},
            (* If dilution type is Linear and we are not using multiple assay containers, we need number of dilutions spots in the qpix assay container *)
            MatchQ[dilutionType,Linear] && !multipleAssayContainerBool, {0,numberOfDilutions},
            (* If dilution type is Linear and we ARE using multiple assay containers, we need number of dilutions spots in the assay container and qpix assay container *)
            MatchQ[dilutionType,Linear] && multipleAssayContainerBool, {numberOfDilutions,numberOfDilutions},
            (* If dilution strategy is endpoint and we are not using multiple assay containers, we need number of dilutions spots in the qpix assay container *)
            MatchQ[dilutionStrategy,Endpoint] && !multipleAssayContainerBool, {0,numberOfDilutions},
            (* If dilution strategy is endpoint and we ARE using multiple assay containers, we need number of dilutions spots in the assay container and 1 spot in the qpix assay container *)
            MatchQ[dilutionStrategy,Endpoint] && multipleAssayContainerBool, {numberOfDilutions,1},
            (* If dilution strategy is series, and we are not using multiple assay containers, we need number of dilutions + 1 spots in the qpix assay container *)
            MatchQ[dilutionStrategy,Series] && !multipleAssayContainerBool, {0,numberOfDilutions + 1},
            (* Otherwise, we need number of dilutions + 1 spots in both the assay container and qpix assay container *)
            True, {numberOfDilutions + 1,numberOfDilutions + 1}
          ]
        ],
        {
          specifiedDilutionType,specifiedNumberOfDilutions,specifiedDilutionStrategy
        }
      ];

      (* The number of assay containers we need is the ceiling of totalNumberOfWells / 96 *)
      {
        totalNumberOfAssayContainers,
        totalNumberOfQPixAssayContainers
      } = {
        Ceiling[N[assayContainerTotalNumberOfWells / Length[assayContainerAvailableWells]]],
        Ceiling[N[qpixAssayContainerTotalNumberOfWells / Length[qpixAssayContainerAvailableWells]]]
      };

      (* Create the labels for the assay containers *)
      assayContainerLabels = Map[If[MatchQ[experimentFunction,ExperimentSpreadCells],
        "Experiment spread cells assay container " <> ToString[#],
        "Experiment streak cells assay container " <> ToString[#]
      ]&,Range[totalNumberOfAssayContainers]];

      qpixAssayContainerLabels = Map[If[MatchQ[experimentFunction,ExperimentSpreadCells],
        "Experiment spread cells qpix assay container " <> ToString[#],
        "Experiment streak cells qpix assay container " <> ToString[#]
      ]&,Range[totalNumberOfQPixAssayContainers]];

      (* Create a LabelContainer for the assay container *)
      assayContainerLabelContainer = LabelContainer[
        Label -> Join[assayContainerLabels,qpixAssayContainerLabels],
        Container -> Join[
          ConstantArray[assayContainerModel,totalNumberOfAssayContainers],
          ConstantArray[qpixAssayContainerModel,totalNumberOfQPixAssayContainers]
        ]
      ];

      (* Now we need to label all of the samples for the dilution *)  
      (* Loop through the transfers we are doing for the dilutions and keep track of the diluents, concentrated buffers, and concentrated buffer diluents *)
      (* NOTE: The structure of the following lookups is sample-><|label->{label, amount} *)
      (* They have to be in this nested structure because we can't put more than 50 mL of a sample in a single container on the robot deck *)
      diluentLabelLookup = <||>;
      concentratedBufferLabelLookup = <||>;
      concentratedBufferDiluentLabelLookup = <||>;

      (* Loop through our dilutions to get our labels and total volumes *)
      allLabels = MapThread[
        Function[
          {dilutionType, diluent, diluentVolumes, concentratedBuffer, concentratedBufferVolumes, concentratedBufferDiluent, concentratedBufferDiluentVolumes},
          (* Only add to the lookups if we are diluting this sample *)
          If[MatchQ[dilutionType,Except[Null]],
            (* Loop through the dilutions we are performing *)
            MapThread[
              Function[{diluentVolume, concentratedBufferVolume, concentratedBufferDiluentVolume},
                {
                  (* --------- Label the diluent if there is one ---------------- *)
                  If[MatchQ[diluent,ObjectP[{Object[Sample],Model[Sample]}]],
                    Module[{diluentFromLookup,currentDiluentInfo},
                      (* See if this diluent already exists in the lookup and there is an instance that can hold the needed volume *)
                      diluentFromLookup=Lookup[diluentLabelLookup,diluent,<||>];
                      currentDiluentInfo=FirstCase[diluentFromLookup,_?(LessEqualQ[#[[2]] + diluentVolume, 50 Milliliter] &),Null];

                      (* Do we have a container that can hold the diluent? *)
                      If[NullQ[currentDiluentInfo],

                        (* No - we need to make a new label *)
                        Module[{newLabel,newAssoc},

                          (* Create new label *)
                          newLabel=CreateUniqueLabel[If[MatchQ[experimentFunction,ExperimentSpreadCells],"ExperimentSpreadCells","ExperimentStreakCells"] <> " Diluent"];

                          (* Add to the lookup *)
                          newAssoc=<|newLabel->{newLabel,diluentVolume}|>;
                          diluentLabelLookup=AssociateTo[diluentLabelLookup,
                            diluent->AssociateTo[diluentFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          newLabel
                        ],

                        (* Yes - add to existing label *)
                        Module[{label,amount,newAssoc},
                          (* Extract current info *)
                          {label, amount}=currentDiluentInfo;

                          (* Add to the amount *)
                          newAssoc=<|label->{label,amount+diluentVolume}|>;
                          diluentLabelLookup=AssociateTo[diluentLabelLookup,
                            diluent->AssociateTo[diluentFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          label
                        ]
                      ]
                    ],

                    (* If there is not a diluent return Null *)
                    Null
                  ],

                  (* ---------- Label the concentrated buffer if there is one -------------- *)
                  If[MatchQ[concentratedBuffer,ObjectP[{Object[Sample],Model[Sample]}]],
                    Module[{concentratedBufferFromLookup,currentConcentratedBufferInfo},
                      (* See if this concentratedBuffer already exists in the lookup and there is an instance that can hold the needed volume *)
                      concentratedBufferFromLookup=Lookup[concentratedBufferLabelLookup,concentratedBuffer,<||>];
                      currentConcentratedBufferInfo=FirstCase[concentratedBufferFromLookup,_?(LessEqualQ[#[[2]] + concentratedBufferVolume, 50 Milliliter] &),Null];

                      (* Do we have a container that can hold the concentratedBuffer? *)
                      If[NullQ[currentConcentratedBufferInfo],

                        (* No - we need to make a new label *)
                        Module[{newLabel,newAssoc},

                          (* Create new label *)
                          newLabel=CreateUniqueLabel[If[MatchQ[experimentFunction,ExperimentSpreadCells],"ExperimentSpreadCells","ExperimentStreakCells"] <> " ConcentratedBuffer"];

                          (* Add to the lookup *)
                          newAssoc=<|newLabel->{newLabel,concentratedBufferVolume}|>;
                          concentratedBufferLabelLookup=AssociateTo[concentratedBufferLabelLookup,
                            concentratedBuffer->AssociateTo[concentratedBufferFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          newLabel
                        ],

                        (* Yes - add to existing label *)
                        Module[{label,amount,newAssoc},
                          (* Extract current info *)
                          {label, amount}=currentConcentratedBufferInfo;

                          (* Add to the amount *)
                          newAssoc=<|label->{label,amount+concentratedBufferVolume}|>;
                          concentratedBufferLabelLookup=AssociateTo[concentratedBufferLabelLookup,
                            concentratedBuffer->AssociateTo[concentratedBufferFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          label
                        ]
                      ]
                    ],

                    (* If there is not a diluent return Null *)
                    Null
                  ],

                  (* ---------- Label the concentrated buffer diluent if there is one ----------- *)
                  If[MatchQ[concentratedBufferDiluent,ObjectP[{Object[Sample],Model[Sample]}]],
                    Module[{concentratedBufferDiluentFromLookup,currentConcentratedBufferDiluentInfo},
                      (* See if this concentratedBufferDiluent already exists in the lookup and there is an instance that can hold the needed volume *)
                      concentratedBufferDiluentFromLookup=Lookup[concentratedBufferDiluentLabelLookup,concentratedBufferDiluent,<||>];
                      currentConcentratedBufferDiluentInfo=FirstCase[concentratedBufferDiluentFromLookup,_?(LessEqualQ[#[[2]] + concentratedBufferDiluentVolume, 50 Milliliter] &),Null];

                      (* Do we have a container that can hold the concentratedBufferDiluent? *)
                      If[NullQ[currentConcentratedBufferDiluentInfo],

                        (* No - we need to make a new label *)
                        Module[{newLabel,newAssoc},

                          (* Create new label *)
                          newLabel=CreateUniqueLabel[If[MatchQ[experimentFunction,ExperimentSpreadCells],"ExperimentSpreadCells","ExperimentStreakCells"] <> " ConcentratedBufferDiluent"];

                          (* Add to the lookup *)
                          newAssoc=<|newLabel->{newLabel,concentratedBufferDiluentVolume}|>;
                          concentratedBufferDiluentLabelLookup=AssociateTo[concentratedBufferDiluentLabelLookup,
                            concentratedBufferDiluent->AssociateTo[concentratedBufferDiluentFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          newLabel
                        ],

                        (* Yes - add to existing label *)
                        Module[{label,amount,newAssoc},
                          (* Extract current info *)
                          {label, amount}=currentConcentratedBufferDiluentInfo;

                          (* Add to the amount *)
                          newAssoc=<|label->{label,amount+concentratedBufferDiluentVolume}|>;
                          concentratedBufferDiluentLabelLookup=AssociateTo[concentratedBufferDiluentLabelLookup,
                            concentratedBufferDiluent->AssociateTo[concentratedBufferDiluentFromLookup,newAssoc]
                          ];

                          (* Return the label *)
                          label
                        ]
                      ]
                    ],

                    (* If there is not a diluent return Null *)
                    Null
                  ]
                }
              ],
              {diluentVolumes,concentratedBufferVolumes,concentratedBufferDiluentVolumes}
            ],
            {{Null,Null,Null}}
          ]
        ],
        {
          specifiedDilutionType,
          Download[specifiedDiluent,Object],
          specifiedDiluentVolume,
          Download[specifiedConcentratedBuffer,Object],
          specifiedConcentratedBufferVolume,
          Download[specifiedConcentratedBufferDiluent,Object],
          specifiedConcentratedBufferDiluentVolume
        }
      ];

      (* Create tuples of {sample, label, amount} from the lookups *)
      allInfoTuples = Join[
        Flatten[KeyValueMap[
          Function[{beads, instances},
            KeyValueMap[
              (Prepend[#2,beads])&,
              instances
            ]
          ],
          diluentLabelLookup
        ],1],
        Flatten[KeyValueMap[
          Function[{beads, instances},
            KeyValueMap[
              (Prepend[#2,beads])&,
              instances
            ]
          ],
          concentratedBufferLabelLookup
        ],1],
        Flatten[KeyValueMap[
          Function[{beads, instances},
            KeyValueMap[
              (Prepend[#2,beads])&,
              instances
            ]
          ],
          concentratedBufferDiluentLabelLookup
        ],1]
      ];

      (* If the sample is an object set the volume to Null *)
      validTuplesNullVolumes=Map[
        Function[{tuple},
          If[MatchQ[tuple[[1]], ObjectP[Object[Sample]]],
            Join[tuple[[1;;2]],{Null}],
            tuple
          ]
        ],
        allInfoTuples
      ];

      (* Create the LabelSample primitive *)
      labelSamplePrimitive = If[Length[validTuplesNullVolumes] > 0,
        LabelSample[
          Sample -> validTuplesNullVolumes[[All,1]],
          Label -> validTuplesNullVolumes[[All,2]],
          Amount -> validTuplesNullVolumes[[All,3]]
        ],
        Nothing
      ];

      (* Separate out the labels *)
      diluentLabels = allLabels[[All,All,1]];
      concentratedBufferLabels = allLabels[[All,All,2]];
      concentratedBufferDiluentLabels = allLabels[[All,All,3]];

      (* Set up some tracking variables *)
      (* Assay Container *)
      assayContainerCurrentWell = "A1";
      assayContainerPreviousWell = Null;
      assayContainerNextWells = Rest[assayContainerAvailableWells];
      currentAssayContainerLabel = FirstOrDefault[assayContainerLabels,Null];
      previousAssayContainerLabel = Null;
      nextAssayContainerLabels = RestOrDefault[assayContainerLabels,{}];

      (* QPix Assay Container *)
      qpixAssayContainerCurrentWell = "A1";
      qpixAssayContainerPreviousWell = Null;
      qpixAssayContainerNextWells = Rest[qpixAssayContainerAvailableWells];
      currentQPixAssayContainerLabel = FirstOrDefault[qpixAssayContainerLabels,Null];
      previousQPixAssayContainerLabel = Null;
      nextQPixAssayContainerLabels = RestOrDefault[qpixAssayContainerLabels,Null];

      echoAssayContainerTrackingVariables[] := Echo[{
        assayContainerCurrentWell,
        assayContainerPreviousWell,
        assayContainerNextWells,
        currentAssayContainerLabel,
        previousAssayContainerLabel,
        nextAssayContainerLabels
      },"{
        assayContainerCurrentWell,
        assayContainerPreviousWell,
        assayContainerNextWells,
        currentAssayContainerLabel,
        previousAssayContainerLabel,
        nextAssayContainerLabels
      }"];
      echoQPixAssayContainerTrackingVariables[] := Echo[{
        qpixAssayContainerCurrentWell,
        qpixAssayContainerPreviousWell,
        qpixAssayContainerNextWells,
        currentQPixAssayContainerLabel,
        previousQPixAssayContainerLabel,
        nextQPixAssayContainerLabels
      },"{
      qpixAssayContainerCurrentWell,
        qpixAssayContainerPreviousWell,
        qpixAssayContainerNextWells,
        currentQPixAssayContainerLabel,
        previousQPixAssayContainerLabel,
        nextQPixAssayContainerLabels}"];

      (* Define some helper functions to iterate through our tracking variables *)
      (* If there are no more wells in this container - move to next container *)
      updateAssayContainerTrackingVariables[] := If[Length[assayContainerNextWells] == 0,
        Module[{},
          assayContainerPreviousWell = assayContainerCurrentWell;
          assayContainerCurrentWell = "A1";
          assayContainerNextWells = Rest[assayContainerAvailableWells];
          previousAssayContainerLabel = currentAssayContainerLabel;
          currentAssayContainerLabel = FirstOrDefault[nextAssayContainerLabels,Null];
          nextAssayContainerLabels = RestOrDefault[nextAssayContainerLabels,{}];
        ],

        (* If there are more available wells, just move the well *)
        Module[{},
          assayContainerPreviousWell = assayContainerCurrentWell;
          previousAssayContainerLabel = currentAssayContainerLabel;
          assayContainerCurrentWell = First[assayContainerNextWells];
          assayContainerNextWells = Rest[assayContainerNextWells];
        ]
      ];

      (* If there are no more wells in this container - move to next container *)
      updateQPixAssayContainerTrackingVariables[] := If[Length[qpixAssayContainerNextWells] == 0,
        Module[{},
          qpixAssayContainerPreviousWell = qpixAssayContainerCurrentWell;
          qpixAssayContainerCurrentWell = "A1";
          qpixAssayContainerNextWells = Rest[qpixAssayContainerAvailableWells];
          previousQPixAssayContainerLabel = currentQPixAssayContainerLabel;
          currentQPixAssayContainerLabel = FirstOrDefault[nextQPixAssayContainerLabels,Null];
          nextQPixAssayContainerLabels = RestOrDefault[nextQPixAssayContainerLabels,Null];
        ],

        (* If there are more available wells, just move the well *)
        Module[{},
          qpixAssayContainerPreviousWell = qpixAssayContainerCurrentWell;
          previousQPixAssayContainerLabel = currentQPixAssayContainerLabel;
          qpixAssayContainerCurrentWell = First[qpixAssayContainerNextWells];
          qpixAssayContainerNextWells = Rest[qpixAssayContainerNextWells];
        ]
      ];

      (* Loop through the dilutions to create the mix/transfer primitives *)
      {dilutionPrimitives,finalTransferTuples,sampleToSpreadSourceMapping} = Transpose@MapThread[
        Function[
          {
            mySample,
            streakSpreadVolume,
            dispenseCoordinates,
            transferVolumes,
            dilutionType,
            dilutionStrategy,
            diluentLabelsPerSample,
            diluentVolumes,
            concentratedBufferLabelsPerSample,
            concentratedBufferVolumes,
            concentratedBufferDiluentLabelsPerSample,
            concentratedBufferDiluentVolumes,
            finalVolumes,
            incubation,
            incubationTime,
            incubationInstrument,
            incubationTemperature,
            mixType,
            numberOfMixes,
            mixRate,
            mixOscillationAngle
          },
          (* If we are not diluting the sample, just transfer the sample into the next available well in the qpix assay container *)
          If[MatchQ[dilutionType,Null],
            Module[{amountToTransfer,transferPrimitive},

              (* The amount to transfer is the streak/spread volume * Length[deposits] *)
              amountToTransfer = streakSpreadVolume * Length[dispenseCoordinates];

              (* Create the Transfer Primitive *)
              transferPrimitive = Transfer[
                Source -> {mySample},
                Destination -> {currentQPixAssayContainerLabel},
                Amount -> {amountToTransfer},
                DestinationWell -> {qpixAssayContainerCurrentWell}
              ];

              (* Update current well and assay container for the qpix assay container *)
              updateQPixAssayContainerTrackingVariables[];

              (* Return the Transfer primitive and the wells that need to be spread from this sample *)
              (* NOTE: We are going straight into the qpix container so no need for a final transfer tuple *)
              {
                transferPrimitive,
                Null,
                (* NOTE: Make sure we use the "previous" label and well because we have already updated them *)
                {<|mySample -> {{previousQPixAssayContainerLabel, qpixAssayContainerPreviousWell}}|>}
              }
            ],

            (* If we are diluting, then loop over all the transfers/mixes of the dilution *)
            Transpose@MapThread[
              Function[
                {
                  transferVolume,
                  diluentLabel,
                  diluentVolume,
                  concentratedBufferLabel,
                  concentratedBufferVolume,
                  concentratedBufferDiluentLabel,
                  concentratedBufferDiluentVolume,
                  finalVolume,
                  firstTransferBool,
                  lastTransferBool
                },
                Module[
                  {
                    sourceTransferTuple,sourceFinalTransferTuple,initialSourceTransferTupleSpreadMapping,
                    concentratedBufferDiluentTransferTuple,concentratedBufferTransferTuple,
                    diluentTransferTuple,sampleToTransfer,sampleTransferTuple,
                    allTransferTuples,transferPrimitive,mixPrimitive,finalTransferTuple
                  },

                  (* If this is the first transfer for this sample and DilutionStrategy is Series, transfer just the source sample *)
                  {
                    sourceTransferTuple,
                    sourceFinalTransferTuple,
                    initialSourceTransferTupleSpreadMapping
                  } = If[firstTransferBool && MatchQ[dilutionStrategy,Series],
                    (* If we have multiple assay containers, we need to do a transfer into the assay container *)
                    (* AND mark a final transfer from the assay container to the qpix assay container *)
                    (* If we don't have multiple assay containers, just do the transfer into the qpix assay container *)
                    If[multipleAssayContainerBool,
                      Module[{transferTuple,finalTransferTuple},
                        (* Make the transfer tuple *)
                        transferTuple = {
                          mySample,
                          currentAssayContainerLabel,
                          transferVolume,
                          assayContainerCurrentWell
                        };

                        (* Update our current well and assay containers *)
                        updateAssayContainerTrackingVariables[];

                        (* Determine the final transfer from the assay container to the qpix assay container *)
                        finalTransferTuple = {
                          previousAssayContainerLabel,
                          assayContainerPreviousWell,
                          currentQPixAssayContainerLabel,
                          Min[finalVolume, 1.9 Milliliter],
                          qpixAssayContainerCurrentWell
                        };

                        (* Update the current well and container for the qpix assay container *)
                        updateQPixAssayContainerTrackingVariables[];

                        (* Return the transferTuple and spread mapping association *)
                        {
                          transferTuple,
                          finalTransferTuple,
                          {previousQPixAssayContainerLabel, qpixAssayContainerPreviousWell}
                        }
                      ],
                      Module[{transferTuple},
                        (* Make the transfer tuple *)
                        transferTuple = {
                          mySample,
                          currentQPixAssayContainerLabel,
                          transferVolume,
                          qpixAssayContainerCurrentWell
                        };

                        (* Update current well and assay container for the qpix assay container *)
                        updateQPixAssayContainerTrackingVariables[];

                        (* Return the transferTuple and spread mapping association *)
                        {
                          transferTuple,
                          Null,
                          {previousQPixAssayContainerLabel, qpixAssayContainerPreviousWell}
                        }
                      ]
                    ],
                    {
                      Null,
                      Null,
                      Null
                    }
                  ];

                  (* Add the concentrated buffer diluent (If Necessary) to the correct container *)
                  concentratedBufferDiluentTransferTuple = If[!NullQ[concentratedBufferDiluentLabel],
                    {
                      concentratedBufferDiluentLabel,
                      If[multipleAssayContainerBool,
                        currentAssayContainerLabel,
                        currentQPixAssayContainerLabel
                      ],
                      concentratedBufferDiluentVolume,
                      If[multipleAssayContainerBool,
                        assayContainerCurrentWell,
                        qpixAssayContainerCurrentWell
                      ]
                    },
                    Nothing
                  ];

                  (* Add the concentrated buffer *)
                  concentratedBufferTransferTuple = If[!NullQ[concentratedBufferLabel],
                    {
                      concentratedBufferLabel,
                      If[multipleAssayContainerBool,
                        currentAssayContainerLabel,
                        currentQPixAssayContainerLabel
                      ],
                      concentratedBufferVolume,
                      If[multipleAssayContainerBool,
                        assayContainerCurrentWell,
                        qpixAssayContainerCurrentWell
                      ]
                    },
                    Nothing
                  ];

                  (* Add the diluent *)
                  diluentTransferTuple = If[!NullQ[diluentLabel],
                    {
                      diluentLabel,
                      If[multipleAssayContainerBool,
                        currentAssayContainerLabel,
                        currentQPixAssayContainerLabel
                      ],
                      diluentVolume,
                      If[multipleAssayContainerBool,
                        assayContainerCurrentWell,
                        qpixAssayContainerCurrentWell
                      ]
                    },
                    Nothing
                  ];

                  (* Sample Transfer Tuple *)
                  (* First determine if we pull from the main sample, or from the previous well *)
                  sampleToTransfer = Which[
                    MatchQ[dilutionType, Linear], mySample,
                    firstTransferBool, mySample,
                    multipleAssayContainerBool, {assayContainerPreviousWell, previousAssayContainerLabel},
                    True, {qpixAssayContainerPreviousWell, previousQPixAssayContainerLabel}
                  ];

                  sampleTransferTuple = {
                    sampleToTransfer,
                    If[multipleAssayContainerBool,
                      currentAssayContainerLabel,
                      currentQPixAssayContainerLabel
                    ],
                    transferVolume /. Null -> 1 Microliter,
                    If[multipleAssayContainerBool,
                      assayContainerCurrentWell,
                      qpixAssayContainerCurrentWell
                    ]
                  };

                  (* Gather the Transfers into a single Transfer Primitive *)
                  allTransferTuples = {
                    sourceTransferTuple /. Null -> Nothing,
                    concentratedBufferDiluentTransferTuple,
                    concentratedBufferTransferTuple,
                    diluentTransferTuple,
                    sampleTransferTuple
                  };

                  transferPrimitive = Transfer[
                    Source -> allTransferTuples[[All,1]],
                    Destination -> allTransferTuples[[All,2]],
                    Amount -> allTransferTuples[[All,3]],
                    DestinationWell -> allTransferTuples[[All,4]]
                  ];

                  (* Create the mix primitive for the current well*)
                  mixPrimitive = If[TrueQ[incubation],
                    Mix[
                      Sample -> If[multipleAssayContainerBool,
                        {assayContainerCurrentWell, currentAssayContainerLabel},
                        {qpixAssayContainerCurrentWell, qpixAssayContainerCurrentWell}
                      ],
                      Time -> incubationTime,
                      Instrument -> incubationInstrument,
                      Temperature -> incubationTemperature,
                      MixType -> mixType,
                      NumberOfMixes -> numberOfMixes,
                      MixRate -> mixRate,
                      OscillationAngle -> mixOscillationAngle
                    ],
                    Nothing
                  ];

                  (* Update our current well and assay containers *)
                  If[multipleAssayContainerBool,
                    updateAssayContainerTrackingVariables[],
                    updateQPixAssayContainerTrackingVariables[]
                  ];
                  
                  (* Determine if this dilution is one we are spreading - If we have different assay container and qpix assay containers define a "final" transfer *)
                  (* from the assay container to the qpix assay container *)
                  finalTransferTuple = If[
                    Or[
                      (* We have different assay containers and this is the last dilution in the series and we want the endpoint *)
                      And[
                        multipleAssayContainerBool,
                        MatchQ[dilutionStrategy,Endpoint] && lastTransferBool
                      ],
                      (* We have different assay containers and we want the whole series *)
                      And[
                        multipleAssayContainerBool,
                        MatchQ[dilutionStrategy,Series]
                      ],
                      (* We have different assay containers and we are doing linear dilution *)
                      And[
                        multipleAssayContainerBool,
                        MatchQ[dilutionType,Linear]
                      ]
                    ],
                    {
                      previousAssayContainerLabel,
                      assayContainerPreviousWell,
                      currentQPixAssayContainerLabel,
                      Min[finalVolume,1.9Milliliter],
                      qpixAssayContainerCurrentWell
                    },
                    (* In any other scenario, we do not need to have an additional transfer to the qpix assay container *)
                    Null
                  ];

                  (* Update the current well and assay container of the qpix assay container if we have a final transfer *)
                  If[!NullQ[finalTransferTuple],
                    updateQPixAssayContainerTrackingVariables[]
                  ];

                  (* Return our combined primitives and the locations in the assay container that need to be spread for this sample *)
                  {
                    {
                      transferPrimitive,
                      mixPrimitive
                    },
                    {
                      sourceFinalTransferTuple,
                      finalTransferTuple
                    },
                    (* NOTE: Make sure we use the "previous" label and well because we have already updated them *)
                    (* If we have a finalTransferTuple, extract the info from that *)
                    (* If we do not have a final transfer tuple, add to the lookup as long as DilutionStrategy is not Endpoint and we are not at the final dilution *)
                    Which[
                      MatchQ[dilutionStrategy, Endpoint] && !lastTransferBool,
                      <||>,
                      True,
                      <|mySample -> {initialSourceTransferTupleSpreadMapping /. Null -> Nothing,{previousQPixAssayContainerLabel, qpixAssayContainerPreviousWell}}|>
                    ]
                  }
                ]
              ],
              {
                transferVolumes,
                diluentLabelsPerSample,
                diluentVolumes,
                concentratedBufferLabelsPerSample,
                concentratedBufferVolumes,
                concentratedBufferDiluentLabelsPerSample,
                concentratedBufferDiluentVolumes,
                finalVolumes,
                Join[{True},ConstantArray[False,Length[transferVolumes] - 1]],
                Join[ConstantArray[False,Length[transferVolumes] - 1],{True}]
              }
            ]
          ]
        ],
        {
          mySamples,
          specifiedSpreadStreakVolume,
          specifiedDispenseCoordinate,
          specifiedDilutionTransferVolume,
          specifiedDilutionType,
          specifiedDilutionStrategy,
          diluentLabels,
          specifiedDiluentVolume,
          concentratedBufferLabels,
          specifiedConcentratedBufferVolume,
          concentratedBufferDiluentLabels,
          specifiedConcentratedBufferDiluentVolume,
          specifiedDilutionFinalVolume,
          specifiedDilutionIncubation,
          specifiedDilutionIncubationTime,
          specifiedDilutionIncubationInstrument,
          specifiedDilutionIncubationTemperature,
          specifiedDilutionMixType,
          specifiedDilutionNumberOfMixes,
          specifiedDilutionMixRate,
          specifiedDilutionMixOscillationAngle
        }
      ];

      (* Gather the sampleToSpreadSourceMapping into a list of associations *)
      flattenedSampleToSpreadSourceMapping = Merge[Flatten[Merge[#,Identity]&/@sampleToSpreadSourceMapping],First];

      (* Create the final Transfer tuple to make sure all required samples are in the qpix assay container *)
      finalTransferPrimitive = Module[{sanitizedFinalTransferTuples},
        (* First, sanitize the final transfer tuples *)
        sanitizedFinalTransferTuples = Flatten[finalTransferTuples,2] /. {Null -> Nothing};

        (* Create the primitive *)
        If[Length[sanitizedFinalTransferTuples] > 0,
          Transfer[
            Source -> sanitizedFinalTransferTuples[[All,1]],
            SourceWell -> sanitizedFinalTransferTuples[[All,2]],
            Destination -> sanitizedFinalTransferTuples[[All,3]],
            Amount -> sanitizedFinalTransferTuples[[All,4]],
            DestinationWell -> sanitizedFinalTransferTuples[[All,5]]
          ],
          Null
        ]
      ];

      (* Gather all of the primitives and return *)
      allPrimitives = Flatten[{
        assayContainerLabelContainer,
        labelSamplePrimitive,
        dilutionPrimitives,
        finalTransferPrimitive /. Null -> Nothing
      }];

      {
        {},
        allPrimitives,
        flattenedSampleToSpreadSourceMapping
      }
    ],
    (* No *)
    Module[{inputSampleContainerModels},
      (* Get the container model of each input sample *)
      inputSampleContainerModels = Download[fastAssocLookup[fastAssoc,mySamples,{Container,Model}],Object];

      (* Are all input samples in a QPix Compatible container? *)
      If[And@@Map[MemberQ[qpixCompatibleContainers,#]&,inputSampleContainerModels],
        (* Yes - we are good and don't need to do any transfers. But we need to determine the wells of the containers our samples are in *)
        Module[{sampleToWellRules},

          (* Determine the well of the input sample *)
          sampleToWellRules = Function[{mySample},
            Module[{sampleContainer,sampleContainerContents,mySampleWell},

              sampleContainer = Download[fastAssocLookup[fastAssoc,mySample,{Container}],Object];

              (* Get the contents of the container of the input sample *)
              sampleContainerContents = fastAssocLookup[fastAssoc, sampleContainer, {Contents}];

              (* Get the well *)
              mySampleWell = First[FirstCase[sampleContainerContents, {_,ObjectP[mySample]}]];

              (* Return the sample and well *)
              mySample -> {{{sampleContainer, mySampleWell}}}

            ]
          ]/@mySamples;

          (* Return the rules in an association *)
          {
            {},
            {},
            Association@@sampleToWellRules
          }
        ],
        (* No - Do a Transfer to aliquot the required amount into a dwp *)
        (* NOTE: We are making an assumption here that there are no more than 96 input samples *)
        (* TODO: Fix above note *)
        Module[{assayContainerLabel,labelContainerPrimitive,transferTuples,transferPrimitive,sampleToWellLabelLookup},
          (* Label the assay container *)
          assayContainerLabel = If[MatchQ[experimentFunction,ExperimentSpreadCells],
            "Experiment spread cells assay container",
            "Experiment streak cells assay container"
          ];
          (* NOTE: These need to stay in lists to make future resolution consistent *)
          labelContainerPrimitive = LabelContainer[
            Label -> {assayContainerLabel},
            Container -> {Model[Container, Plate, "id:L8kPEjkmLbvW"]}
          ];

          (* Create a Transfer tuple for each sample *)
          transferTuples = MapThread[
            Function[{sample, depositVolume, dispenseCoords, well},
              {
                sample,
                assayContainerLabel,
                depositVolume * Length[dispenseCoords],
                well
              }
            ],
            {
              mySamples,
              specifiedSpreadStreakVolume,
              specifiedDispenseCoordinate,
              (* TODO: Cache the AllWells call *)
              Flatten[AllWells[Model[Container, Plate, "id:L8kPEjkmLbvW"]]][[1;;Length[mySamples]]] (* 96 well plate *)
            }
          ];

          (* Create a TransferPrimitive to transfer to the assay container *)
          transferPrimitive = Transfer[
            Source -> transferTuples[[All,1]],
            Destination -> transferTuples[[All,2]],
            Amount -> transferTuples[[All,3]],
            DestinationWell -> transferTuples[[All,4]]
          ];

          (* Make the sample to well label lookup *)
          sampleToWellLabelLookup = Function[{inputSample},
            Module[{sampleIsSourceTuples,containerWellPairs},
              (* Get the transfer tuples where the input sample is the source *)
              sampleIsSourceTuples = Cases[transferTuples,{ObjectP[inputSample],_,_,_}];

              (* For each of those, create a {container, well} pair *)
              containerWellPairs = ({{#[[2]],#[[4]]}})&/@sampleIsSourceTuples;

              (* Return the rule for the sample *)
              inputSample -> containerWellPairs
            ]
          ]/@DeleteDuplicates[mySamples];

          (* Return *)
          {
            {},
            {labelContainerPrimitive,transferPrimitive},
            Association@@sampleToWellLabelLookup
          }
        ]
      ]
    ]
  ];

  (* -------------------------- Make Destination container resources ------------------------------ *)
  (* If DilutionType is Linear: the sample gets NumberOfDilutions DestinationPlates *)
  (* If DilutionType is Serial and DilutionStrategy is Endpoint: the sample gets 1 DestinationPlates *)
  (* If DilutionType is Serial and DilutionStrategy is Series: the sample gets NumberOfDilutions + 1 DestinationPlates *)
  destinationContainerResources = MapThread[
    Function[{destinationContainer, destinationMedia, dilutionType, dilutionStrategy, numberOfDilutions},
      Which[
        (* If the destination container is an object, just create the resource *)
        (* NOTE: We have a guarantee from the option resolver that if the dest container is an object, dilution strategy is Null *)
        MatchQ[destinationContainer,ObjectP[Object[Container]]],
          If[Length[fastAssocLookup[fastAssoc,destinationContainer,Contents]] > 0,
            {Resource[Sample -> destinationContainer, Name -> StringJoin[If[MatchQ[experimentFunction, ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", CreateUUID[]]]},
            (* Otherwise, create a resource of the media in the container *)
            {Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Milliliter, Name -> StringJoin[If[MatchQ[experimentFunction, ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", CreateUUID[]]]}
          ],

        (* If we have a dilution conflict error, default to 1 *)
        NullQ[numberOfDilutions],
        Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Milliliter, Name -> StringJoin[If[MatchQ[experimentFunction,ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", ToString[i], " ", CreateUUID[]]],

        (* If Dilution strategy is Series, make numberOfDilutions + 1 duplicate resources of the media in the plate model *)
        MatchQ[dilutionStrategy,Series],
          Table[
            Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Milliliter, Name -> StringJoin[If[MatchQ[experimentFunction,ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", ToString[i], " ", CreateUUID[]]],
            {i,1,numberOfDilutions + 1}
          ],

        (* If DilutionType is Linear, make NumberOfDilutions destination plate resources *)
        MatchQ[dilutionType,Linear],
          Table[
            Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Milliliter, Name -> StringJoin[If[MatchQ[experimentFunction,ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", ToString[i], " ", CreateUUID[]]],
            {i,1,numberOfDilutions}
          ],

        (* Otherwise, DilutionStrategy is Null or Endpoint, so just make a single resource *)
        True,
          {Resource[Sample -> destinationMedia, Container -> destinationContainer, Amount -> 50 Milliliter, Name -> StringJoin[If[MatchQ[experimentFunction, ExperimentSpreadCells], "spread cells", "streak cells"], " destination plate ", CreateUUID[]]]}
      ]
    ],
    {
      Download[specifiedDestinationContainer,Object],
      Download[specifiedDestinationMedia,Object],
      specifiedDilutionType,
      specifiedDilutionStrategy,
      specifiedNumberOfDilutions
    }
  ];

  (* Get the batching lengths of the destination container resources to store in the unit op *)
  destinationContainerResourceLengths = Length /@ destinationContainerResources;

  (* We need to create a mapping of InputSample to the containers that are required to be on deck *)
  (* for that sample *)
  (* NOTE: This is <|Object[Sample] -> {(_String)..}|> *)
  mySampleToContainersSpreadMapping = <||>;

  (* Add to the lookup based on the AssayContainerPrimitive *)
  (* NOTE: This is {Label_String -> Model[Container]...} *)
  assayContainerLabelLookup = If[MatchQ[assayContainerPrimitives,{}],
    (* {} means to just use the source containers for all input samples, add those to the mapping *)
    Module[{},
      (* Add to the mapping *)
      (mySampleToContainersSpreadMapping[#] = {Download[Experiment`Private`fastAssocLookup[fastAssoc,#,Container],Object]})&/@mySamples;

      (* we have no assay containers *)
      {}
    ],

    (* Anything else means we have a list of primitives to unpack *)
    Module[{labelContainerPrimitive,labelContainerLookup,transferPrimitives,allTransferTuples},

      (* Extract the label container primitive *)
      labelContainerPrimitive = FirstCase[assayContainerPrimitives, _LabelContainer,LabelContainer[<||>]];

      (* Transform the label container into a lookup *)
      labelContainerLookup = Rule@@@Transpose@Lookup[labelContainerPrimitive[[1]], {Label, Container}];

      (* Extract any transfer primitives *)
      transferPrimitives = Cases[assayContainerPrimitives, _Transfer];

      (* Combine the transfer primitives into a big list of transfer tuples *)
      allTransferTuples = Flatten[Transpose/@({
        Lookup[#[[1]], Source],
        Lookup[#[[1]], Destination],
        Lookup[#[[1]], Amount]
      }&/@transferPrimitives),1];

      (* Create a rule for each input sample *)
      (
        mySampleToContainersSpreadMapping[#] = DeleteDuplicates[Cases[allTransferTuples,{#,_,_}][[All,2]]]
      )&/@mySamples;

      (* Return the assay container lookup *)
      labelContainerLookup
    ]
  ];

  (* Next, we need to batch our input samples to create batched unit operations *)
  (* In order to batch the samples we need to gather the information for each sample into packets we can move around *)
  (* Do this by mapthreading the resolved options and then adding sample keys for each packet *)
  splitOptionPackets = OptionsHandling`Private`mapThreadOptions[experimentFunction, myResolvedOptions, AmbiguousNestedResolution->IndexMatchingOptionPreferred];

  (* Add the sample keys, destination container resources, and keep track of the original index of each sample *)
  samplePackets = MapThread[
    Function[{sample,options,destContResources,index},
      Merge[{options,<|Sample -> sample, DestinationContainerResources -> destContResources, OriginalIndex -> index|>}, First]
    ],
    {
      mySamples,
      splitOptionPackets,
      destinationContainerResources,
      Range[Length[mySamples]]
    }
  ];

  (* First, group by ColonyHandlerHeadCassette *)
  unitOpGroupedByColonyHandlerHeadCassette = Values@GroupBy[samplePackets, Lookup[#, If[MatchQ[experimentFunction,ExperimentSpreadCells], ColonySpreadingTool, ColonyStreakingTool]]&];

  {finalPhysicalGroups,carrierDeckPlateLocations, numTipsRequired} = Module[{physicalBatchCarrierPlacements,samplePacketsBatchedBySourceContainerConstraints,numTipsRequiredForBatch,expandedAndSortedPhysicalGroups},

    (* For Streak and Spread UnitOperations, we have to batch based on the amount of source containers we can fit on deck *)
    (* Currently we have 8 spots *)
    (* There are also riser restrictions. On the deck of the qpix in the streak/spread configuration, *)
    (* there are 2 tracks, each of which can hold 4 plates. Each track can either be raised, to hold shallow plates, *)
    (* or left alone to hold deep well plates. However, for plating operations, all of the plates in each routine must be of the same model *)
    (* Additionally, we group the sample packets by all other "routine" options here as well. *)
    (* Additionally, we cannot have more than 96 pipette operations in a single batch *)

    (* Map over the grouped unit operations *)
    {
      physicalBatchCarrierPlacements,
      samplePacketsBatchedBySourceContainerConstraints,
      numTipsRequiredForBatch
    } = Module[{groupedResult},
      groupedResult = Map[Function[{groupPackets},
        Module[{currentGroupBatches,routineParameterSymbols},
          (* This is a list of associations where each association has the following key-value pairs: *)
          (*
           PlateType -> DeepWell | NonDeepWell - signifies if this group is of deep well plates or non deep well plates
           NumberOfPipetteTipsRemaining -> _Int - represents the number of pipettes remaining in this group (each group can't have more than 96)
           Containers -> {(ObjectP[] | _String)..} - a list of the containers that are currently on the deck. we can always include a sample if its container is already on the deck
           RoutineParameters -> {
              (Source Options)
              - sourceMix,
              - sourceMixVolume,
              - numberOfSourceMixes

              (Spreading Options)
              - streak/spread pattern
              - CustomSpreadPattern
              - spread volume
              - DispenseCoordinates

              (Sanitization options)
              - PrimaryWashSolution
              - PrimaryDryTime
              - NumberOfPrimaryWashes
              - SecondaryWashSolution
              - SecondaryDryTime
              - NumberOfSecondaryWashes
              - TertiaryWashSolution
              - TertiaryDryTime
              - NumberOfTertiaryWashes
              - QuaternaryWashSolution
              - QuaternaryDryTime
              - NumberOfQuaternaryWashes
           }
           Samples -> {samplePackets..} - a list of the sample packets that are in this physical batch
           *)
          currentGroupBatches = {};

          (* Define the list of "Routine Parameters" *)
          routineParameterSymbols = {
            SourceMix,
            SourceMixVolume,
            NumberOfSourceMixes,
            If[MatchQ[experimentFunction,ExperimentSpreadCells],
              Sequence@@{
                SpreadPatternType,
                CustomSpreadPattern,
                SpreadVolume
              },
              Sequence@@{
                StreakPatternType,
                CustomStreakPattern,
                StreakVolume
              }
            ],
            DispenseCoordinates,
            PrimaryWashSolution,
            PrimaryDryTime,
            NumberOfPrimaryWashes,
            SecondaryWashSolution,
            SecondaryDryTime,
            NumberOfSecondaryWashes,
            TertiaryWashSolution,
            TertiaryDryTime,
            NumberOfTertiaryWashes,
            QuaternaryWashSolution,
            QuaternaryDryTime,
            NumberOfQuaternaryWashes
          };

          (* Map over the sample packets in this group and split them into their final batches *)
          Map[
            Function[{samplePacket},
              Module[
                {
                  sourceContainers,deepWellContainerQ,numberOfPipetteTipsRequired,
                  sampleRoutineParameters,potentialBatchPosition
                },

                (* Get the requirements for this sample *)
                (* TODO: Explain why this is ok *)
                sourceContainers = Lookup[mySampleToContainersSpreadMapping,Download[Lookup[samplePacket,Sample],Object]];

                (* Determine whether the container(s) are deep well or not *)
                deepWellContainerQ = deepWellQ[# /. assayContainerLabelLookup, fastAssoc]&/@sourceContainers;

                (* Get the number of pipette tips required from this sample *)
                numberOfPipetteTipsRequired = Module[{dilutionType,dilutionStrategy,numberOfDilutions},
                  (* Lookup the relevant dilution information *)
                  {
                    dilutionType,
                    dilutionStrategy,
                    numberOfDilutions
                  } = Lookup[samplePacket,
                    {
                      DilutionType,
                      DilutionStrategy,
                      NumberOfDilutions
                    }
                  ];

                  (* Determine the number of pipettes from these parameters - we need a new pipette for each dilution sample *)
                  Which[
                    NullQ[numberOfDilutions], 1,
                    MatchQ[dilutionType, Linear], numberOfDilutions,
                    MatchQ[dilutionType, Serial] && MatchQ[dilutionStrategy, Endpoint], 1,
                    MatchQ[dilutionType, Serial] && MatchQ[dilutionStrategy, Series], numberOfDilutions + 1,
                    True, 1
                  ]
                ];

                (* Lookup the routine parameters for this sample *)
                sampleRoutineParameters = Lookup[samplePacket,routineParameterSymbols];

                (* Can this sample fit into any of the current groups? *)
                potentialBatchPosition = If[MatchQ[Length[currentGroupBatches],0],
                  Null,
                  FirstOrDefault[
                    FirstPosition[
                      Map[Function[{batchAssociation},
                        Or[
                          And[
                            (* The batch is deep well *)
                            MatchQ[Lookup[batchAssociation,PlateType], DeepWell],

                            (* The containers are deep well *)
                            SameQ@@deepWellContainerQ,
                            TrueQ[First[deepWellContainerQ]],

                            (* We have enough pipettes *)
                            LessEqualQ[numberOfPipetteTipsRequired,Lookup[batchAssociation,NumberOfPipetteTipsRemaining]],

                            (* We have enough deep well container slots *)
                            (* Either the container is already in the batch or there are enough spots remaining *)
                            (* Below: Each True means we have to add a container to the deck *)
                            LessEqualQ[Total[(!MemberQ[Lookup[batchAssociation,Containers],#]&/@sourceContainers) /. {True -> 1, False -> 0}],8 - Length[Lookup[batchAssociation,Containers]]],

                            (* The routine parameters match *)
                            MatchQ[Lookup[batchAssociation,RoutineParameters],sampleRoutineParameters]

                          ],
                          And[
                            (* The batch is non deep well *)
                            MatchQ[Lookup[batchAssociation,PlateType], NonDeepWell],

                            (* The containers are non - deep well *)
                            SameQ@@deepWellContainerQ,
                            !TrueQ[First[deepWellContainerQ]],

                            (* We have enough pipettes *)
                            LessEqualQ[numberOfPipetteTipsRequired,Lookup[batchAssociation,NumberOfPipetteTipsRemaining]],

                            (* We have enough deep well container slots *)
                            (* Either the container is already in the batch or there are enough spots remaining *)
                            (* Below: Each True means we have to add a container to the deck *)
                            LessEqualQ[Total[(!MemberQ[Lookup[batchAssociation,Containers],#]&/@sourceContainers) /. {True -> 1, False -> 0}],8 - Length[Lookup[batchAssociation,Containers]]],

                            (* The routine parameters match *)
                            MatchQ[Lookup[batchAssociation,RoutineParameters],sampleRoutineParameters]
                          ]
                        ]
                      ],
                        currentGroupBatches
                      ],
                      True,
                      {}
                    ],
                    Null
                  ]
                ];

                Which[
                  (* Creating a new batch *)
                  MatchQ[Length[currentGroupBatches],0] || NullQ[potentialBatchPosition],
                    AppendTo[currentGroupBatches,
                      <|
                        PlateType -> If[MatchQ[First[deepWellContainerQ],True], DeepWell, NonDeepWell],
                        NumberOfPipetteTipsRemaining -> 96 - numberOfPipetteTipsRequired,
                        Containers -> DeleteDuplicates[sourceContainers],
                        Samples -> {samplePacket},
                        RoutineParameters -> sampleRoutineParameters
                      |>
                    ],

                  (* Adding to an existing batch *)
                  True,
                    Module[{existingBatch,updatedContainers,updatedPipettes,updatedSamplePackets},

                      (* Get the existing batch *)
                      existingBatch = currentGroupBatches[[potentialBatchPosition]];

                      (* Get the updated containers list *)
                      updatedContainers = DeleteDuplicates[Join[Lookup[existingBatch,Containers],sourceContainers]];

                      (* Get the updated number of pipette tips remaining *)
                      updatedPipettes = Lookup[existingBatch, NumberOfPipetteTipsRemaining] - numberOfPipetteTipsRequired;

                      (* Get the updated list of sample packets in this batch *)
                      updatedSamplePackets = Append[Lookup[existingBatch, Samples], samplePacket];

                      (* Update the batch *)
                      currentGroupBatches = ReplacePart[
                        currentGroupBatches,
                        potentialBatchPosition -> <|
                          PlateType -> Lookup[existingBatch, PlateType],
                          NumberOfPipetteTipsRemaining -> updatedPipettes,
                          Containers -> updatedContainers,
                          Samples -> updatedSamplePackets,
                          RoutineParameters -> sampleRoutineParameters
                        |>
                      ]
                    ]
                ]
              ]
            ],
            groupPackets
          ];

          (* Translate the batches into a consistent format *)
          Function[{batchAssociation},
            If[MatchQ[Lookup[batchAssociation,PlateType], DeepWell],
              Module[{batchContainers,deepWellContainerTrackLists,nonDeepWellContainerTrackLists,numTipsRequired},
                (* Lookup the containers from the batch *)
                batchContainers = Lookup[batchAssociation,Containers];

                (* Lookup the required number of tips for this batch *)
                numTipsRequired = 96 - Lookup[batchAssociation,NumberOfPipetteTipsRemaining];

                deepWellContainerTrackLists = If[MatchQ[Length[Partition[batchContainers, UpTo[4]]], 2],
                  Prepend[Reverse@Partition[batchContainers, UpTo[4]],{}],
                  {{},{},batchContainers}
                ];

                nonDeepWellContainerTrackLists = {{},{},{}};

                Transpose[{nonDeepWellContainerTrackLists,deepWellContainerTrackLists}] -> {Lookup[batchAssociation,Samples], numTipsRequired}
              ],
              Module[{batchContainers,deepWellContainerTrackLists,nonDeepWellContainerTrackLists,numTipsRequired},
                (* Lookup the containers from the batch *)
                batchContainers = Lookup[batchAssociation,Containers];

                (* Lookup the required number of tips for this batch *)
                numTipsRequired = 96 - Lookup[batchAssociation,NumberOfPipetteTipsRemaining];

                nonDeepWellContainerTrackLists = If[MatchQ[Length[Partition[batchContainers, UpTo[4]]], 2],
                  Prepend[Reverse@Partition[batchContainers, UpTo[4]],{}],
                  {{},{},batchContainers}
                ];

                deepWellContainerTrackLists = {{},{},{}};

                Transpose[{nonDeepWellContainerTrackLists,deepWellContainerTrackLists}] -> {Lookup[batchAssociation,Samples], numTipsRequired}
              ]
            ]
          ]/@currentGroupBatches
        ]
      ],
        unitOpGroupedByColonyHandlerHeadCassette
      ];

      (* Extract the data in a usable form *)
      {
        Flatten[groupedResult[[All,All,1]],1],
        Flatten[groupedResult[[All,All,2,1]],1],
        Flatten[groupedResult[[All,All,2,2]]]
      }
    ];

    (* We can only have 2 destination containers on the deck at a time. This means that we have to group again, this time *)
    (* based on the destination containers. In order to limit the amount of routine files we will make, we will *)
    (* create duplicates of each sample packet for each destination container it requires. Then sort those by *)
    (* routine parameters and Partition into groups of 2 *)

    (* Expand and sort the groups *)
    expandedAndSortedPhysicalGroups = Map[Function[{physicalGroupSamplePackets},
      Module[{flattenedTransferSources,flattenedExpandedGroups,flattenedDestinationContainers,correctedFlattenedExpandedGroups},
        (* Create a list of the transfer sources that need to occur for this batch *)
        flattenedTransferSources = Flatten[Function[{sample},Flatten[Lookup[sampleToWellLabelMapping, sample] /. {x:ObjectP[] :> Download[x, ID]},1]]/@Lookup[physicalGroupSamplePackets,Sample],1];

        (* Also create a list of our flattened expanded groups *)
        flattenedExpandedGroups = Flatten[Function[{samplePacket},ConstantArray[samplePacket,Length[Lookup[samplePacket,DestinationContainerResources]]]]/@physicalGroupSamplePackets];

        (* We also want to update our batching packets to properly reflect the DestinationContainers for each *)
        flattenedDestinationContainers = Flatten[Lookup[physicalGroupSamplePackets,DestinationContainerResources]];

        (* Thread the DestinationContainers into the expanded groups *)
        (* Also add a key to store the corresponding transfer (this will be used when making the routine) *)
        correctedFlattenedExpandedGroups = MapThread[Function[{packet,container,routineTransferTuple},
          Merge[{packet,<|DestinationContainerResources -> {container},RoutineTransfer -> routineTransferTuple|>},Last]
        ],
          {
            flattenedExpandedGroups,
            flattenedDestinationContainers,
            flattenedTransferSources
          }
        ];

        (* Sort the groups by routine parameters *)
        (* !!!!!!!!!!NOTE: Right now we are assuming all destination plates are OmniTrays so they are the same model!!!!!!!!!!!!!!!!!! *)
        (*
          (Source Options)
          - source plate model
          - sourceMix,
          - sourceMixVolume,
          - numberOfSourceMixes

          (Spreading Options)
          - streak/spread pattern
          - CustomSpreadPattern
          - spread volume


          (Sanitization options)
          - PrimaryWashSolution
          - PrimaryDryTime
          - NumberOfPrimaryWashes
          - SecondaryWashSolution
          - SecondaryDryTime
          - NumberOfSecondaryWashes
          - TertiaryWashSolution
          - TertiaryDryTime
          - NumberOfTertiaryWashes
          - QuaternaryWashSolution
          - QuaternaryDryTime
          - NumberOfQuaternaryWashes
        *)
        SortBy[correctedFlattenedExpandedGroups,{
          {
            Switch[Download[Lookup[mySampleToContainersSpreadMapping,Lookup[correctedFlattenedExpandedGroups,Sample]],Object],
              ObjectP[Model[Container]],Download[Lookup[mySampleToContainersSpreadMapping,Lookup[correctedFlattenedExpandedGroups,Sample]],Object],
              ObjectP[Object[Container]],Download[Experiment`Private`fastAssocLookup[fastAssoc,Lookup[mySampleToContainersSpreadMapping,Lookup[correctedFlattenedExpandedGroups,Sample]],Model],Object],
              (* NOTE: The only way we can have multiple source containers is if the sample spans multiple assay containers. *)
              (* We always choose a dwp as the assay container so the model is the same *)
              {ObjectP[Model[Container]]..},Download[Experiment`Private`fastAssocLookup[fastAssoc,First[Lookup[mySampleToContainersSpreadMapping,Lookup[correctedFlattenedExpandedGroups,Sample]]],Model],Object]
            ]
          },
          Lookup[#, {
            (* Source Options *)
            SourceMix,
            SourceMixVolume,
            NumberOfSourceMixes,

            (* Spreading Options *)
            If[MatchQ[experimentFunction,ExperimentSpreadCells],
              Sequence@@{
                SpreadPatternType,
                SpreadVolume,
                CustomSpreadPattern
              },
              Sequence@@{
                StreakPatternType,
                StreakVolume,
                CustomStreakPattern
              }
            ],

            (* Sanitization Options *)
            PrimaryWashSolution,
            PrimaryDryTime,
            NumberOfPrimaryWashes,
            SecondaryWashSolution,
            SecondaryDryTime,
            NumberOfSecondaryWashes,
            TertiaryWashSolution,
            TertiaryDryTime,
            NumberOfTertiaryWashes,
            QuaternaryWashSolution,
            QuaternaryDryTime,
            NumberOfQuaternaryWashes
          }]
        }&]
      ]
    ],
      samplePacketsBatchedBySourceContainerConstraints
    ];

    (* Now we can take the expanded and sorted groups and partition them *)
    {
      Partition[#,UpTo[2]]&/@expandedAndSortedPhysicalGroups,

      (* For each batch also return how the carriers need to be structured for that group (High position or low position) *)
      physicalBatchCarrierPlacements,

      (* Also return the number of pipette tips required for each batch *)
      numTipsRequiredForBatch
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
  (* NOTE: This helper function is defined in Experiment/sources/PickColonies/Experiment.m *)
  {
    riserPlacements,
    carrierPlacements,
    riserReturns,
    carrierReturns,
    initialCarrierAndRiserResourcesToPick
  } = getCarrierAndRiserBatchingFields[carrierDeckPlateLocations, experimentFunction];


  (* Stage 1.5: ColonyHandlerHeadCassette *)
  (* Go through each physical group and determine the ColonyHandlerHeadCassette that group requires. *)
  (* Then create a second list that keeps track of whether a ColonyHandlerHeadCassette needs to be removed first *)
  (* at the beginning of the physical batch *)
  (* NOTE: This helper function is defined in Experiment/sources/PickColonies/Experiment.m *)
  {
    colonyHandlerHeadCassetteAdds,
    colonyHandlerHeadCassetteRemovals
  } = getColonyHandlerHeadCassetteBatchingFields[
    finalPhysicalGroups /. colonyStreakSpreadToolResourceReplaceRules,
    If[MatchQ[experimentFunction,ExperimentSpreadCells], ColonySpreadingTool, ColonyStreakingTool]
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
        {First[Lookup[samplePacket,DestinationContainerResources]],{"QPix LightTable Slot", "A1", First[index] /. {1 -> "A1", 2 -> "B1"}}}
      ],
        #
      ])&/@physicalGroup;

      {
        Flatten[Lookup[Flatten[physicalGroup],DestinationContainerResources]],
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

  (* Tip Resources and Placements *)
  {
    tipRackPlacements,
    tipRackReturns
  } = Module[{tipCountsWithBuffer,partitionedLists,accumulatedList,tipResources,currentTipRackResource},
    (* First, we need to translate the number of tips required for each batch into actual tip resources *)
    (* However, note that the qpix can only have 1 tip box on the deck at a time and you cannot swap out  *)
    (* tip boxes during the middle of a routine. This means it is vital that we request the resources  *)
    (* in a way such that a routine does not have its tips spanning multiple tip racks *)

    (* Add a buffer to our required tip counts *)
    tipCountsWithBuffer = Ceiling[# * 1.1]&/@numTipsRequired;

    (* Group into groups of upto 96 - each of these groups will get a tip resource *)
    partitionedLists={};
    accumulatedList=Rest@FoldList[
      Function[{currentTuple,nextNumber},
        Module[{currentGroupList,currentGroupSum},
          (* Extract info from our group tuple *)
          currentGroupList=currentTuple[[2]];
          currentGroupSum=currentTuple[[1]];

          Which[

            (* If the next number fits, add it to the group *)
            currentGroupSum + nextNumber <= 96,
            {currentGroupSum + nextNumber, Append[currentGroupList,nextNumber]},

            (* If the next number does not fit, add to the group list and start a new group *)
            True,
            Module[{},
              AppendTo[partitionedLists,currentGroupList];
              {nextNumber, {nextNumber}}
            ]
          ]
        ]
      ],
      (* {totalTipCount,listOfTipCounts in this group} *)
      {0,{}},
      tipCountsWithBuffer
    ];

    (* Add the last list *)
    AppendTo[partitionedLists,accumulatedList[[-1,2]]];

    (* Create a resource for each member of this list *)
    tipResources = Flatten[Function[{listOfTipCounts},
      ConstantArray[Resource[Sample -> Model[Item, Tips, "id:P5ZnEjZ9ZWkR"] (* Model[Item, Tips, "QPix Tips"] *), Amount -> Total[listOfTipCounts], Name -> CreateUUID[]], Length[listOfTipCounts]] (* Model[Item, Tips, "QPix Tips"] *)
    ]/@partitionedLists];

    (* Create our placement and return fields *)
    (* Keep track of the current tip rack on the instrument *)
    currentTipRackResource = Null;

    (* Loop over our tip resources per physical batch *)
    Transpose[Function[{nextTipResource},
      Module[{tipRackToAddPlacement,tipRackToRemove},
        (* Determine if we need to remve the current tip rack *)
        (* If the tip rack resources match, don't remove. Otherwise, remove *)
        {
          tipRackToAddPlacement,
          tipRackToRemove
        } = If[!MatchQ[currentTipRackResource,nextTipResource],
          {{Link[nextTipResource],{"QPix Tip Slot"}}, Link[currentTipRackResource]},
          {{Null,Null},Null}
        ];

        (* Update the current tip rack *)
        currentTipRackResource = nextTipResource;

        (* Return the tiprack placement and tiprack to remove *)
        {
          tipRackToAddPlacement,
          tipRackToRemove
        }
      ]
    ]/@tipResources]
  ];

  (* Stage 1.7: Gather into Batched unit operation packets based on unit operation type *)
  (* For each physical batch, create a batched unit operation packet that contains the information to pass through to the *)
  (* procedure *)
  batchedUnitOperationPackets = MapThread[
    Function[
      {
        physicalBatchSamplePackets, physicalBatchRiserReturns, physicalBatchCarrierReturns, physicalBatchRiserPlacements,
        physicalBatchCarrierPlacements, colonyHandlerHeadCassetteToAdd, colonyHandlerHeadCassetteToRemove,
        flatLightTableContainers, flatLightTableContainerPlacements, lightTableContainerLengths,
        physicalBatchCarrierContainerDeckPlacements, tipRackPlacement, tipRackReturn
      },
      <|
        Type -> If[MatchQ[experimentFunction,ExperimentSpreadCells], Object[UnitOperation,SpreadCells], Object[UnitOperation,StreakCells]],
        UnitOperationType -> Batched,
        Replace[FlatBatchedDestinationContainers] -> Link/@flatLightTableContainers,
        Replace[FlatBatchedDestinationContainerPlacements] -> flatLightTableContainerPlacements,
        If[MatchQ[experimentFunction,ExperimentSpreadCells],
          Replace[FlatBatchedSpreadVolumes] -> Lookup[Flatten[physicalBatchSamplePackets], SpreadVolume],
          Replace[FlatBatchedStreakVolumes] -> Lookup[Flatten[physicalBatchSamplePackets], StreakVolume]
        ],
        Replace[FlatBatchedDispenseCoordinates] -> Lookup[Flatten[physicalBatchSamplePackets], DispenseCoordinates],
        Replace[FlatBatchedTransfers] -> Lookup[Flatten[physicalBatchSamplePackets], RoutineTransfer],
        Replace[BatchedDestinationContainerLengths] -> lightTableContainerLengths,
        Replace[RiserDeckPlacements] -> physicalBatchRiserPlacements,
        Replace[CarrierDeckPlacements] -> physicalBatchCarrierPlacements,
        Replace[RiserReturns] -> physicalBatchRiserReturns,
        Replace[CarrierReturns] -> physicalBatchCarrierReturns,
        ColonyHandlerHeadCassette -> colonyHandlerHeadCassetteToAdd,
        ColonyHandlerHeadCassetteReturn -> colonyHandlerHeadCassetteToRemove,
        Replace[IntermediateSourceContainerDeckPlacements] -> physicalBatchCarrierContainerDeckPlacements /. samplesInResourceReplaceRules,
        Replace[FlatBatchedSamplesOutStorageConditions] -> Lookup[Flatten[physicalBatchSamplePackets], SamplesOutStorageCondition],
        TipRackDeckPlacement -> tipRackPlacement,
        TipRackReturn -> tipRackReturn
      |>
    ],
    {
      finalPhysicalGroups,
      riserReturns,
      carrierReturns,
      riserPlacements,
      carrierPlacements,
      colonyHandlerHeadCassetteAdds,
      colonyHandlerHeadCassetteRemovals,
      flatLightTableContainersPerPhysicalBatch,
      flatLightTableContainerPlacementsPerPhysicalBatch,
      lightTableContainerLengthsPerPhysicalBatch,
      carrierContainerDeckPlacements,
      tipRackPlacements,
      tipRackReturns
    }
  ];

  (* Currently, our batched unit operation packets do not have id's, give them ids but only call  *)
  (* CreateID a single time *)
  batchedUnitOperationPacketsWithID = Module[{unitOperationType,batchedUnitOperationNewObjects},

    unitOperationType = If[MatchQ[experimentFunction, ExperimentSpreadCells],Object[UnitOperation,SpreadCells], Object[UnitOperation,StreakCells]];

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


  (* Create the streak/spread unit operation *)
  streakSpreadUnitOperationPacket=UploadUnitOperation[
    Module[{nonHiddenOptions,unitOpHead},
      (* Only include non-hidden options from ExperimentPickColonies. *)
      nonHiddenOptions=Lookup[
        Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category"->Except["Hidden"]]],
        "OptionSymbol"
      ];

      (* Get the unit op head based off of the experiment function *)
      unitOpHead = If[MatchQ[experimentFunction,ExperimentSpreadCells],
        SpreadCells,
        StreakCells
      ];

      (* Join the Sample Key, Developer fields, and resolved options into a single unit op *)
      unitOpHead@@Join[
        {
          Sample->samplesInResources,
          AssayContainerPrimitives -> assayContainerPrimitives,
          AssayContainerResources -> Flatten@assayContainerResources,
          DestinationContainerResources -> Flatten@destinationContainerResources,
          DestinationContainerResourceLengths -> destinationContainerResourceLengths,
          SampleToSourceWellMapping -> sampleToWellLabelMapping,
          BatchedUnitOperations -> (Link/@Lookup[batchedUnitOperationPacketsWithID, Object]),
          PhysicalBatchingGroups -> finalPhysicalGroups /. {_Resource:> Nothing},
          CarrierAndRiserInitialResources -> First[initialCarrierAndRiserResourcesToPick]
        },

        (* Put all of our resources in *)
        ReplaceRule[
          Cases[Normal[myResolvedOptions,Association], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
          {
            Instrument -> instrumentResource,
            If[MatchQ[experimentFunction,ExperimentSpreadCells],
              ColonySpreadingTool -> colonyStreakSpreadToolResources,
              ColonyStreakingTool -> colonyStreakSpreadToolResources
            ],
            PrimaryWashSolution -> primaryWashSolutionResources,
            SecondaryWashSolution -> secondaryWashSolutionResources,
            TertiaryWashSolution -> tertiaryWashSolutionResources,
            QuaternaryWashSolution -> quaternaryWashSolutionResources
          }
        ]
      ]
    ],
    Preparation->Robotic,
    UnitOperationType->Output,
    FastTrack->True,
    Upload->False
  ];

  (*--Gather all the resource symbolic representations--*)

  (* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{streakSpreadUnitOperationPacket,batchedUnitOperationPacketsWithID}],_Resource,Infinity]];

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
    {streakSpreadUnitOperationPacket, batchedUnitOperationPacketsWithID, runTime}/.resourceToNameReplaceRules,
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


(* ::Subsection::Closed:: *)
(*Simulation Function*)
DefineOptions[simulateExperimentSpreadAndStreakCells,
  Options :> {CacheOption, SimulationOption}
];

simulateExperimentSpreadAndStreakCells[
  myUnitOperationPacket : PacketP[{Object[UnitOperation, SpreadCells], Object[UnitOperation,StreakCells]}],
  mySamples : {ObjectP[Object[Sample]]..},
  myResolvedOptions : {_Rule..},
  experimentFunction :  Alternatives[ExperimentSpreadCells, ExperimentStreakCells],
  myResolutionOptions :OptionsPattern[simulateExperimentPickColonies]
] := Module[
  {
    inheritedCache,currentSimulation,inheritedFastAssoc,testProtocolObject,protocolPacket,volumeSymbol,relevantUnitOpInfo,
    sampleContainerPackets,sampleContainerObjects,flattenedContainerPackets,fulfilledDestinationContainerResources,destinationSamples,destinationSampleBatchLengths,platingVolume,dispenses,
    sanitizedDestinationSamples,transferTuples,uploadSampleTransferPackets,simulatedLabels
  },

  (* Get simulation and cache *)
  {inheritedCache, currentSimulation} = Lookup[ToList[myResolutionOptions], {Cache,Simulation}, {}];
  currentSimulation = If[MatchQ[currentSimulation,Null],
    Simulation[],
    currentSimulation
  ];

  (* Create a faster version of the cache to improve speed *)
  inheritedFastAssoc=makeFastAssocFromCache[inheritedCache];

  (* Simulate a protocol ID. *)
  testProtocolObject=SimulateCreateID[Object[Protocol,RoboticCellPreparation]];

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

  (* Get the volume symbol from the experiment function *)
  volumeSymbol = If[MatchQ[experimentFunction,ExperimentSpreadCells],
    SpreadVolume,
    StreakVolume
  ];

  (* Download the destination container samples, volume to spread, and number of dispenses *)
  {
    relevantUnitOpInfo,
    sampleContainerPackets,
    sampleContainerObjects
  } = Quiet[
    Download[
      {
        {testProtocolObject},
        {testProtocolObject},
        mySamples
      },
      {
        {
          Packet[OutputUnitOperations[{
            DestinationContainerResources,
            DestinationContainerResourceLengths,
            volumeSymbol,
            DispenseCoordinates
          }]]
        },
        {
          Packet[OutputUnitOperations[DestinationContainerResources[Container]]],
          Packet[OutputUnitOperations[DestinationContainerResources[Contents]]]
        },
        {
          Container
        }
      },
      Simulation->currentSimulation
    ],
    {Download::FieldDoesntExist}
  ];

  (* Flatten the container contents packets *)
  flattenedContainerPackets = Experiment`Private`FlattenCachePackets[sampleContainerPackets];

  (* Get the info into a usable form *)
  {
    fulfilledDestinationContainerResources,
    destinationSampleBatchLengths,
    platingVolume,
    dispenses
  } = Lookup[
    relevantUnitOpInfo[[1,1,1]],
    {
      DestinationContainerResources,
      DestinationContainerResourceLengths,
      volumeSymbol,
      DispenseCoordinates
    }
  ];

  (* Sanitize the destination samples *)
  (* 1. Group them by their batching lengths *)
  (* 2. Remove any links *)
  sanitizedDestinationSamples = Download[TakeList[fulfilledDestinationContainerResources, destinationSampleBatchLengths],Object];

  (* Make sure everything is a sample. If a resource is a container, then lookup the "A1" contents *)
  destinationSamples = Map[Function[{containerOrSample},
    If[MatchQ[containerOrSample, ObjectP[Object[Container]]],
      Download[Last[FirstCase[Lookup[fetchPacketFromCache[containerOrSample, flattenedContainerPackets],Contents],{"A1",_},{Null,Null}]],Object],
      containerOrSample
    ]
  ],
    sanitizedDestinationSamples,
    2
  ];

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
        destinationSamples,
        platingVolume,
        Length/@dispenses
      }
    ],
    {1,2}
  ];

  (* Pass the transfers to UploadSampleTransfer to get upload packets *)
  uploadSampleTransferPackets = UploadSampleTransfer[
    transferTuples[[All,1]],
    transferTuples[[All,2]],
    transferTuples[[All,3]],
    Upload -> False,
    Simulation -> currentSimulation,
    FastTrack -> True
  ];

  (* UpdateSimulation *)
  currentSimulation=UpdateSimulation[currentSimulation,Simulation[uploadSampleTransferPackets]];

  (* Update the simulated labels *)
  simulatedLabels = Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Download[Flatten[sampleContainerObjects],Object]}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Flatten@Lookup[myResolvedOptions, SampleOutLabel], Flatten@sanitizedDestinationSamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Flatten@Lookup[myResolvedOptions, ContainerOutLabel],Lookup[sampleContainerPackets[[1,1,1]],Object]}],
        {_String, ObjectP[]}
      ]
    ]
  ];

  (* Return the protocol object and updated simulation *)
  UpdateSimulation[currentSimulation, simulatedLabels]

];


(* ::Subsection::Closed:: *)
(*workCellResolver Function*)
resolveSpreadAndStreakWorkCell[
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

(* ::Subsection::Closed:: *)
(*Method Resolver Function*)
resolveSpreadAndStreakMethod[
  myInputs:ListableP[ObjectP[{Object[Sample],Object[Container]}]],
  myOptions:OptionsPattern[]
]:=Module[
  {method},

  method=Lookup[myOptions,Method,Automatic];

  (* Determine the Method that can be used *)
  If[MatchQ[method,Except[Automatic]],
    {method},
    (* Just Robotic *)
    {Robotic}
  ]
];

(* ::Subsection:: *)
(* Sister Functions *)

(* ::Subsubsection:: *)
(* ExperimentSpreadCellsOptions *)
DefineOptions[ExperimentSpreadCellsOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentSpreadCells}
];


ExperimentSpreadCellsOptions[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ExperimentSpreadCellsOptions]
]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Send in the correct Output option and remove the OutputFormat option*)
  preparedOptions=Normal[KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}],Association];

  resolvedOptions=ExperimentSpreadCells[myInputs,preparedOptions];

  (*Return the option as a list or table*)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentSpreadCells],
    resolvedOptions
  ]
];

(* ::Subsubsection:: *)
(* ValidExperimentSpreadCellsQ *)
DefineOptions[ValidExperimentSpreadCellsQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions:>{ExperimentSpreadCells}
];


ValidExperimentSpreadCellsQ[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ValidExperimentSpreadCellsQ]
]:=Module[
  {listedOptions,preparedOptions,experimentSpreadCellsTests,initialTestDescription,allTests,verbose,outputFormat},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Remove the output option before passing to the core function because it doesn't make sense here*)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (*Call the ExperimentSpreadCells function to get a list of tests*)
  experimentSpreadCellsTests=Quiet[
    ExperimentSpreadCells[myInputs,Append[preparedOptions,Output->Tests]],
    {LinkObject::linkd,LinkObject::linkn}
  ];

  (*Define the general test description*)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test*)
  allTests=If[MatchQ[experimentSpreadCellsTests,$Failed],
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
      Cases[Flatten[{initialTest,experimentSpreadCellsTests,voqWarnings}],_EmeraldTest]
    ]
  ];

  (*Look up the test-running options*)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (*Run the tests as requested*)
  Lookup[RunUnitTest[<|"ValidExperimentSpreadCellsQ"->allTests|>,Verbose->verbose,
    OutputFormat->outputFormat],"ValidExperimentSpreadCellsQ"]
];