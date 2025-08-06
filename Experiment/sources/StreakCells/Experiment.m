(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Define Options*)

DefineOptions[ExperimentStreakCells,
  Options:>{
    {
      OptionName -> InoculationSource,
      Default -> Automatic,
      Description -> "The type of media in which the source cell samples are stored before the experiment. The possible types accepted by ExperimentSpreadCells include LiquidMedia, FreezeDried, and FrozenGlycerol. For sources of type LiquidMedia, samples are mixed in the source containers, the well-mixed input sample is then transferred to th destination media container with fresh media. For sources of type FreezeDried, samples are resuspended with media in the source container, the resuspended material is then transferred to the destination media container with fresh media. For sources of type FrozenGlycerol, samples are scraped from the frozen surface using pipette tips while the source container is kept chilled, the scraped material is then deposited into the destination media container with fresh media. See Figure 1 of ExperimentInoculateSpreadCells to check inoculation source specific procedures and ExampleResults section in the helpfile for more information.",
      ResolutionDescription -> "If the source samples have liquid state, automatically set to LiquidMedia. If the source container models are hermetic or ampoules and the source samples have solid state, automatically set to FreezeDried. If the source containers are stored in cryogenic or deep freezer storage condition, automatically set to FrozenGlycerol.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> StreakSpreadInoculationSourceP (*LiquidMedia | FreezeDried | FrozenGlycerol *)
      ],
      Category -> "General"
    },

    {
      OptionName->Instrument,
      Default->Automatic,
      Description->"The robotic instrument that is used to transfer cells in suspension to a solid agar gel and then streak the suspension across the plate.",
      AllowNull->False,
      Widget->Widget[
        Type->Object,
        Pattern:>ObjectP[{Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Cell Culture",
            "Colony Handlers"
          }
        }
      ],
      Category->"Instrument"
    },
    IndexMatching[
      IndexMatchingInput->"experiment samples",

      (*Resuspension options*)
      {
        OptionName->ResuspensionMedia,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{Model[Sample],Object[Sample],Object[Container]}],
          Dereference->{Object[Container]->Field[Contents[[All,2]]]}
        ],
        Description->"The liquid media to add to the ResuspensionContainer or source container in order to resuspend the sample. For a source of frozen glycerol, the ResuspensionMedia is added to the ResuspensionContainer before dipping the scraped sample. For a freeze-dried source sample, the ResuspensionMedia is added to the source container directly followed by ResuspensionMix.",
        ResolutionDescription->"Automatically set to Model[Sample, Media, \"LB Broth, Miller\"].",
        Category->"Resuspension"
      },
      {
        OptionName->ResuspensionMediaVolume,
        Default-> Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "All"->Widget[Type->Enumeration, Pattern:>Alternatives[All]],
          "Volume"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[1 Microliter, 20 Liter],
            Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
          ]
        ],
        Description->"The amount of the liquid media added to the ResuspensionMediaContainer in order to resuspend the scraped frozen glycerol sample or the amount of the liquid media added to the freeze-dried sample.",
        ResolutionDescription->"Automatically set to 1/2 of the source sample container's volume or the volume of the provided ResuspensionMedia object (whichever is smaller), if ResuspensionMedia is not Null.",
        Category->"Resuspension"
      },
      {
        OptionName->ResuspensionContainer,
        Default-> Automatic,
        AllowNull->True,
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
        Description->"The desired container (or type of container) to contain the cell resuspension, with indices indicating grouping of samples in the same plate, if desired. For a source of frozen glycerol, the ResuspensionMedia is added to the ResuspensionContainer before dipping the scraped sample. For a freeze-dried source sample, the combined ResuspensionMedia and the source sample is added to the ResuspensionContainer.",
        ResolutionDescription->"If the ResuspensionMedia is specified as an Object[Sample], automatically set to its container. Otherwise if ResuspensionMedia is not Null, automatically set by PreferredContainer ",
        Category->"Resuspension"
      },
      {
        OptionName -> ResuspensionContainerWell,
        Default -> Automatic,
        Description -> "For each Sample, the well of the ResuspensionMediaContainer to contain the cell resuspension.",
        ResolutionDescription -> "Automatically set to the first empty position of the ResuspensionContainer. If no empty position is found, automatically set to \"A1\".",
        AllowNull -> True,
        Widget -> Widget[
          Type -> String,
          Pattern :> WellPositionP,
          Size -> Word,
          PatternTooltip -> "Enumeration must be any well from A1 to P24."
        ],
        Category -> "Resuspension"
      },

      {
        OptionName->NumberOfSourceScrapes,
        Default->Automatic,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[1,20,1]
        ],
        Description->"For each sample, the number of times that the frozen glycerol sample is scraped with the tip before it is dipped into the resuspension media and swirled.",
        ResolutionDescription -> "Automatically set to 5 if InoculationSource is FrozenGlycerol.",
        AllowNull->True,
        Category->"Resuspension"
      },

      ModifyOptions[ExperimentMix,
        OptionName->Mix,
        ModifiedOptionName->ResuspensionMix,
        AllowNull->True,
        Description->"For each sample, indicates if the cells in resuspension is mixed after combining the ResuspensionMedia and the source sample.",
        ResolutionDescription->"If InoculationSource is FreezeDried or FrozenGlycerol, or if any of the other ResuspensionMix options are set, automatically set to True. ",
        Category->"Resuspension"
      ],

      ModifyOptions[ExperimentMix,
        OptionName->MixType,
        ModifiedOptionName->ResuspensionMixType,
        Description->"For each sample, the type of mixing of the cells in resuspension after combining ResuspensionMedia and the source sample. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette.",
        ResolutionDescription->"If InoculationSource is FreezeDried or FrozenGlycerol, or if any of the other ResuspensionMix options are set, automatically set to Pipette.",
        Widget -> Widget[
          Type->Enumeration,
          Pattern:>Alternatives[Pipette]
        ],
        Category->"Hidden"(*Hide it since no option essentially, but jic we want to add more options in future*)
      ],

      ModifyOptions[ExperimentMix,
        OptionName->NumberOfMixes,
        ModifiedOptionName->NumberOfResuspensionMixes,
        Description->"For each sample, the number of times that the cells in resuspension is mixed after combining the ResuspensionMedia and the source sample.",
        ResolutionDescription->"If InoculationSource is FreezeDried or FrozenGlycerol, or if any of the other ResuspensionMix options are set, automatically set to 5.",
        Category->"Resuspension"
      ],

      ModifyOptions[ExperimentMix,
        OptionName->MixVolume,
        ModifiedOptionName->ResuspensionMixVolume,
        Description->"For each sample, the volume that will be repeatedly aspirated and dispensed via pipette from the cells in resuspension in order to mix after combining the ResuspensionMedia and the source sample. For freeze-dried source sample, the same pipette and tips used to add the ResuspensionMedia will be used to mix the cell resuspension. For frozen glycerol source sample, the same pipette and tips used to mix the cell resuspension will be used to deposit it onto the solid media.",
        ResolutionDescription->"If InoculationSource is FreezeDried or FrozenGlycerol, or if any of the other ResuspensionMix options are set, automatically set to 1/2 the ResuspensionMediaVolume.",
        Category->"Resuspension"
      ],

      (* Preparatory Dilution *)
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionType
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionStrategy
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> NumberOfDilutions
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionTargetAnalyte
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> CumulativeDilutionFactor
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> SerialDilutionFactor
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionTargetAnalyteConcentration
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionTransferVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> TotalDilutionVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionFinalVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionDiscardFinalTransfer
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> Diluent
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DiluentVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionConcentratedBuffer
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> ConcentratedBufferVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> ConcentratedBufferDiluent
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> ConcentratedBufferDilutionFactor
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> ConcentratedBufferDiluentVolume
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionIncubate
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionIncubationTime
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionIncubationInstrument
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionIncubationTemperature
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionMixType
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionNumberOfMixes
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionMixRate
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName -> DilutionMixOscillationAngle
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->SpreadVolume,
        ModifiedOptionName->StreakVolume,
        Description->"For each sample, the volume of suspended cells to transfer to the agar gel to be streaked."
        (* TODO: Formalize Resolution Description once I go back and look or decide on dippping *)
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->SourceMix,
        Description->"For each sample, indicates whether the source should be mixed by pipette before being transferred to the agar gel to be streaked."
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->SourceMixVolume,
        Description->"For each sample, the amount of liquid to aspirate and dispense when mixing by pipette before being transferred to the agar gel to be streaked."
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->NumberOfSourceMixes,
        Description->"For each sample, the number of times the source should be mixed by pipette before being transferred to the agar gel to be streaked."
      ],
      {
        OptionName->ColonyStreakingTool,
        Default->Automatic,
        Description->"For each sample, the tool used to streak the suspended cells from the input sample onto the destination plate or into a destination well.",
        ResolutionDescription->"If DestinationContainer is an 8 well solid media tray, resolves to Model[Part, ColonyHandlerHeadCassette, \"8-pin spreading head\"]. Otherwise resolves to Model[Part, ColonyHandlerHeadCassette, \"1-pin spreading head\"].",
        AllowNull->False,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{Model[Part,ColonyHandlerHeadCassette],Object[Part,ColonyHandlerHeadCassette]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Instruments",
              "Colony Handling",
              "Colony Handler Head Cassettes",
              "Colony Streaking Head Cassettes"
            }
          }
        ],
        Category->"Streaking"
      },
      ModifyOptions[ExperimentSpreadCells,
        OptionName->HeadDiameter,
        Description->"For each sample, the width of the metal probe that will streak the cells.",
        ResolutionDescription->"Resolves from the ColonyStreakingTool[HeadDiameter].",
        Category->"Streaking"
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->HeadLength,
        Description->"For each sample, the length of the metal probe that will streak the cells.",
        ResolutionDescription->"Resolves from the ColonyStreakingTool[HeadLength].",
        Category->"Streaking"
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->NumberOfHeads,
        Description->"For each sample, the number of metal probes on the ColonyHandlerHeadCassette that will streak the cells.",
        ResolutionDescription->"Resolves from the ColonyStreakingTool[NumberOfHeads].",
        Category->"Streaking"
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->ColonyHandlerHeadCassetteApplication,
        Description->"For each sample, the designed use of the ColonyStreakingTool.",
        ResolutionDescription->"Resolves from the ColonyStreakingTool[Application].",
        Category->"Streaking"
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->DispenseCoordinates,
        Description->"For each sample, the location to dispense the suspended cells to be streaked on the destination plate.",
        ResolutionDescription -> "Automatically set to the first coordinate of the resolved StreakPattern.",
        Category->"Streaking"
      ],
      {
        OptionName->StreakPatternType,
        Default->RotatedHatches,
        Description->"For each sample, the pattern the streaking colony handler head will move when streaking the colony on the plate. Can be specified as a pre-determined pattern, a modifiable general hatching pattern, or Custom to indicate the coordinates in CustomStreakPattern should be used. See the below figure.",
        AllowNull->False,
        Widget -> Widget[
          Type->Enumeration,
          Pattern:>StreakPatternP (* RotatedHatches | LinearHatches | Radiant | Custom *)
        ],
        Category->"Streaking"
      },

      ModifyOptions[ExperimentSpreadCells,
        {
          OptionName->CustomSpreadPattern,
          ModifiedOptionName->CustomStreakPattern,
          Description -> "For each sample, the user defined pattern used to streak the suspended cells across the plate. Specify a series of Streak[{{xCoordinate,yCoordinate}}..] to specify the pattern. In order to draw separate lines, specify series of coordinates in different Streak[...]'s. Between each Streak[...], the pin on colony spreading tool will be lifted off of the agar and then repositioned at the first coordinate of the next Streak[...].",
          Widget->Alternatives[
            "Single Streak stroke" -> Widget[
              Type -> Head,
              Head -> Streak,
              Widget -> Adder[
                {
                  "XCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-63 Millimeter, 63 Millimeter],Units -> Millimeter],
                  "YCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-43 Millimeter, 43 Millimeter],Units -> Millimeter]
                }
              ]
            ],
            "Multiple Streak strokes" -> Adder[
              Widget[
                Type -> Head,
                Head -> Streak,
                Widget -> Adder[
                  {
                    "XCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-63 Millimeter, 63 Millimeter],Units -> Millimeter],
                    "YCoordinate"->Widget[Type -> Quantity,Pattern :> RangeP[-43 Millimeter, 43 Millimeter],Units -> Millimeter]
                  }
                ]
              ]
            ]
          ]
        }
      ],
      {
        OptionName->NumberOfSegments,
        Default->Automatic, (* Default to 4 segments then back calculate how many hatches can fit *)
        AllowNull->True,
        Description->"For each sample, if StreakPatternType->RotatedHatches, the number of times the plate is rotated during the streak. If StreakPatternType->LinearHatches, the amount of sections that have sets of hatches. See the below figure for examples.",
        ResolutionDescription->"If StreakPatternType->RotatedHatches or LinearHatches, automatically set to 4. Otherwise set to Null.",
        Widget->Widget[
          Type->Number,
          Pattern:>GreaterEqualP[1,1]
        ],
        Category->"Streaking"
      },
      {
        OptionName->HatchesPerSegment,
        Default->Automatic,
        AllowNull->True,
        Description->"For each sample, the number of zig-zags per segment. See the below table for a visual definition.",
        ResolutionDescription->"If StreakPatternType->RotatedHatches or LinearHatches, automatically set to 5. Otherwise set to Null.",
        Widget->Widget[
          Type->Number,
          Pattern:>GreaterEqualP[1,1]
        ],
        Category->"Streaking"
      },
      ModifyOptions[ExperimentSpreadCells,
        OptionName->DestinationContainer,
        Description->"For each Sample, the desired type of container to have suspended cells streaked in, with indices indicating grouping of samples in the same plate, if desired."
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->DestinationWell,
        Description->"For each Sample, the well of the DestinationContainer to streak the suspended cells."
      ],
      ModifyOptions[ExperimentSpreadCells,
        OptionName->DestinationMedia,
        Description->"For each sample, the media on which the cells are streaked."
      ],

      (* --- Label Options --- *)
      {
        OptionName->SampleLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"For each sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->SampleContainerLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"For each sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->SampleOutLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Single Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description->"For each sample, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->ContainerOutLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Single Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
          "List of Labels" -> Adder[Widget[Type -> String,Pattern :> _String,Size -> Line]]
        ],
        Description->"For each sample, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        UnitOperation->True
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
    BiologyPostProcessingOptions,
    QPixSanitizationSharedOptions
  }
];

(* ::Subsection::Closed:: *)
(*Experiment Function*)

(* Container Overload *)
ExperimentStreakCells[myContainers:ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedContainers,listedOptions,simulation,
    containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,
    containerToSampleSimulation
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links. *)
  {listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

  (* Lookup simulation option if it exists *)
  simulation = Lookup[listedOptions,Simulation,Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentStreakCells,
      listedContainers,
      listedOptions,
      Output->{Result,Tests,Simulation},
      Simulation->simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
        ExperimentStreakCells,
        listedContainers,
        listedOptions,
        Output-> {Result,Simulation},
        Simulation->simulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainer}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> simulation
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentStreakCells[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
  ]
];

(* CORE Overload *)
ExperimentStreakCells[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,gatherTests,listedSamplesNamed,listedOptionsNamed,safeOpsNamed,safeOpsTests,
    listedSamples,safeOps,validLengths,validLengthTests,returnEarlyQ,performSimulationQ,
    templatedOptions,templateTests,simulation,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,updatedSimulation,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,unitOperationPacket,batchedUnitOperationPackets,
    runTime,resourcePacketTests,uploadQ,allUnitOperationPackets
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
    SafeOptions[ExperimentStreakCells,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentStreakCells,listedOptionsNamed,AutoCorrect->False],{}}
  ];

  (* replace all objects referenced by Name to ID *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed, Simulation->Lookup[safeOpsNamed, Simulation, Null]];

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
    ValidInputLengthsQ[ExperimentStreakCells,{listedSamples},safeOps,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentStreakCells,{listedSamples},safeOps],Null}
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
    ApplyTemplateOptions[ExperimentStreakCells,{ToList[listedSamples]},safeOps,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentStreakCells,{ToList[listedSamples]},safeOps],Null}
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

  (* Lookup simulation if it exists *)
  simulation = Lookup[safeOps,Simulation];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentStreakCells,{ToList[listedSamples]},inheritedOptions]];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* TODO: FILL THIS IN ONCE THE RESOLVE<TYPE>OPTIONS AND <TYPE>RESOURCE PACKETS ARE FINISHED *)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall={}; (* Quiet[Flatten[{samplePreparationCache,Download[..., Cache\[Rule]Lookup[expandedSafeOps, Cache, {}], Simulation\[Rule]updatedSimulation]}],Download::FieldDoesntExist] *)

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    (* NOTE: All shared functions (Option Resolver, Resource Packets, simulation, etc. ) are in SpreadCells/Experiment.m *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentSpreadAndStreakCellsOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->simulation,Output->{Result,Tests},ExperimentFunction -> ExperimentStreakCells];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentSpreadAndStreakCellsOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->simulation,ExperimentFunction -> ExperimentStreakCells],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];


  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentStreakCells,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentStreakCells,collapsedResolvedOptions],
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
  (* NOTE: We need to perform simulation if Result is asked for in StreakCells since it's part of the CellPreparation experiments. *)
  (* This is because we pass down our simulation ExperimentRCP. *)
  performSimulationQ=MemberQ[output, Result|Simulation];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentStreakCells,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  (* NOTE: Because Spread/Streak Cells can currently only happen robotically, resourcePackets only contains UnitOperationPackets *)
  {{unitOperationPacket, batchedUnitOperationPackets, runTime},resourcePacketTests}=If[returnEarlyQ,
    {{$Failed,$Failed}, {}},
    If[gatherTests,
      streakAndSpreadCellsResourcePackets[listedSamples,listedOptionsNamed,resolvedOptions,ExperimentStreakCells,Cache->cacheBall,Simulation->simulation,Output->{Result,Tests}],
      {streakAndSpreadCellsResourcePackets[listedSamples,listedOptionsNamed,resolvedOptions,ExperimentStreakCells,Cache->cacheBall,Simulation->simulation],{}}
    ]
  ];


  (* If we were asked for a simulation, also return a simulation. *)
  updatedSimulation = If[performSimulationQ,
    simulateExperimentSpreadAndStreakCells[unitOperationPacket,listedSamples,resolvedOptions,ExperimentStreakCells,Cache->cacheBall,Simulation->simulation],
    Null
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentStreakCells,collapsedResolvedOptions],
      Preview -> Null,
      Simulation->updatedSimulation
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps,Upload];

  (* Gather all the unit operation packets *)
  allUnitOperationPackets = Flatten[{unitOperationPacket,batchedUnitOperationPackets}];

  (* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[unitOperationPacket,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
      $Failed,

    (* If Upload->False, return the unit operation packets without RequireResources called*)
    !uploadQ,
      allUnitOperationPackets,

    (* Otherwise, upload an ExperimentRoboticCellPreparation *)
    True,
      Module[
        {
          primitive,nonHiddenOptions
        },
        (* Create the StreakCells primitive to feed into RoboticCellPreparation *)
        primitive=StreakCells@@Join[
          {
            Sample->Download[ToList[mySamples],Object]
          },
          RemoveHiddenPrimitiveOptions[StreakCells,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentStreakCells,collapsedResolvedOptions];

        (* Memoize the value of ExperimentPickColonies so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentStreakCells,$PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          ExperimentStreakCells[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification=Lookup[ToList[options],Output];

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
            Name->Lookup[safeOps,Name],
            Instrument -> Lookup[collapsedResolvedOptions,Instrument],
            Upload->Lookup[safeOps,Upload],
            Confirm->Lookup[safeOps,Confirm],
            CanaryBranch->Lookup[safeOps,CanaryBranch],
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
    Options -> RemoveHiddenOptions[ExperimentStreakCells,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> updatedSimulation,
    RunTime -> runTime
  }
];

(* ::Subsection:: *)
(* Sister Functions *)

(* ::Subsubsection:: *)
(* ExperimentStreakCellsOptions *)
DefineOptions[ExperimentStreakCellsOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions:>{ExperimentStreakCells}
];


ExperimentStreakCellsOptions[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ExperimentStreakCellsOptions]
]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Send in the correct Output option and remove the OutputFormat option*)
  preparedOptions=Normal[KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}],Association];

  resolvedOptions=ExperimentStreakCells[myInputs,preparedOptions];

  (*Return the option as a list or table*)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentStreakCells],
    resolvedOptions
  ]
];

(* ::Subsubsection:: *)
(* ValidExperimentStreakCellsQ *)
DefineOptions[ValidExperimentStreakCellsQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions:>{ExperimentStreakCells}
];


ValidExperimentStreakCellsQ[
  myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],
  myOptions:OptionsPattern[ValidExperimentStreakCellsQ]
]:=Module[
  {listedOptions,preparedOptions,experimentStreakCellsTests,initialTestDescription,allTests,verbose,outputFormat},

  (*Get the options as a list*)
  listedOptions=ToList[myOptions];

  (*Remove the output option before passing to the core function because it doesn't make sense here*)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (*Call the ExperimentStreakCells function to get a list of tests*)
  experimentStreakCellsTests=Quiet[
    ExperimentStreakCells[myInputs,Append[preparedOptions,Output->Tests]],
    {LinkObject::linkd,LinkObject::linkn}
  ];

  (*Define the general test description*)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (*Make a list of all of the tests, including the blanket test*)
  allTests=If[MatchQ[experimentStreakCellsTests,$Failed],
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
      Cases[Flatten[{initialTest,experimentStreakCellsTests,voqWarnings}],_EmeraldTest]
    ]
  ];

  (*Look up the test-running options*)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (*Run the tests as requested*)
  Lookup[RunUnitTest[<|"ValidExperimentStreakCellsQ"->allTests|>,Verbose->verbose,
    OutputFormat->outputFormat],"ValidExperimentStreakCellsQ"]
];
(* ::Subsubsection:: *)
(* ExperimentStreakCellsPreview *)
DefineOptions[ExperimentStreakCellsPreview,
  SharedOptions :> {ExperimentStreakCells}
];

ExperimentStreakCellsPreview[myInputs : ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions : OptionsPattern[ExperimentStreakCellsPreview]] := Module[
  {listedOptions, noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (* return only the options for ExperimentGrind *)
  ExperimentStreakCells[myInputs, Append[noOutputOptions, Output -> Preview]]
];