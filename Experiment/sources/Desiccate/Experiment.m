(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(* Option Definitions *)

DefineOptions[ExperimentDesiccate,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Amount,
        Default -> All,
        Description -> "The mass of a sample to transfer from the input samples into a container before desiccation. If Amount is specified to a value other than All and SampleContainer is not informed, the specified Amount of the sample is transferred into a container before desiccation, determined by PreferredContainer function.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "Mass" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Gram, $MaxTransferMass], Units -> {1, {Gram, {Milligram, Gram}}}],
          "All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
        ]
      },
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the samples that are being desiccated, for use in downstream unit operations.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainer,
        Default -> Null,
        Description -> "The container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Container], Object[Container]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Containers",
              "Tubes & Vials"
            }
          }
        ]
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the sample containers that are used during the desiccation step, for use in downstream unit operations.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        UnitOperation -> True
      }
    ],
    {
      OptionName -> Method,
      Default -> StandardDesiccant,
      Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, Vacuum, and DesiccantUnderVacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> DesiccationMethodP
      ]
    },
    {
      OptionName -> Desiccant,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample.",
      ResolutionDescription -> "Automatically set to Model[Sample,\"Indicating Drierite\"], Model[Sample,\"Sulfuric acid\"], or Null if DesiccantPhase is Solid/not informed, Liquid, or Method is Vacuum.",
      Category -> "General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Item, Consumable], Object[Item, Consumable], Model[Sample], Object[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents",
            "Desiccants"
          }
        }
      ]
    },
    {
      OptionName -> DesiccantPhase,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample.",
      ResolutionDescription -> "Automatically set to the physical state of the selected desiccant, or Null if Desiccant is Null.",
      Category -> "General",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Solid, Liquid]
      ]
    },
    {
      OptionName -> DesiccantAmount,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample.",
      ResolutionDescription -> "Automatically set to 100 Gram if DesiccantPhase is Solid, 100 Milliliter if DesiccantPhase is Liquid, or Null if Method is Vacuum.",
      Category -> "General",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> Alternatives[RangeP[0 Gram, $MaxTransferMass], RangeP[0 Milliliter, $MaxTransferVolume]],
        Units -> Alternatives[Gram, Milliliter]
      ]
    },
    {  OptionName -> Desiccator,
      Default -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"],
      AllowNull -> False,
      Description -> "The instrument that is used to dry the sample by exposing the sample with its container lid open in a bell jar which includes a chemical desiccant either at atmosphere or vacuum.",
      Category -> "General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, Desiccator], Object[Instrument, Desiccator]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Storage Devices",
            "Desiccators",
            "Open Sample Desiccators"
          }
        }
      ]
    },
    {
      OptionName -> Time,
      Default -> 5 Hour,
      Description -> "Determines how long the sample (with the lid off) is dried via desiccation inside a desiccator.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Hour, $MaxExperimentTime],
        Units -> {1, {Hour, {Minute, Hour, Day}}}
      ]
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the sample collected at the end of the desiccation step, for use in downstream unit operations.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        UnitOperation -> True
      },
      (*Storage Information*)
      {
        OptionName -> ContainerOut,
        Default -> Null,
        Description -> "The desired container that the desiccated sample should be transferred into after desiccation. If specified, all of the sample is transferred into ContainerOut.",
        AllowNull -> True,
        Category -> "Storage Information",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Container], Object[Container]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Containers",
              "Tubes & Vials"
            }
          }
        ]
      },
      {
        OptionName -> ContainerOutLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the ContainerOut that the sample is transferred into after the desiccation step, for use in downstream unit operations.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        UnitOperation -> True
      },
      {
        OptionName -> SamplesOutStorageCondition,
        Default -> Null,
        Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition.",
        AllowNull -> True,
        Category -> "Storage Information",
        Widget -> Alternatives[
          Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
          ],
          Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Storage Conditions"
              }
            }
          ]
        ]
      }
    ],
    PreparatoryUnitOperationsOption,
    Experiment`Private`PreparatoryPrimitivesOption,
    ProtocolOptions,
    SimulationOption,
    PostProcessingOptions
  }
];

(* ::Subsection::Closed:: *)
(* ExperimentDesiccate Errors and Warnings *)
Error::NonSolidSample = "The samples `1` do not have a Solid state and cannot be processed. Please remove these samples from the function input.";
Error::DesiccantPhaseInformedForVacuumMethod = "Desiccation method is set to Vacuum which desiccates samples under vacuum with no desiccant. However, DesiccantPhase is informed for `1`. PLease change the Method option to DesiccantUnderVacuum or StandardDesiccant if you wish to desiccate the sample in the presence of a desiccant or set Desiccant and DesiccantPhase options to Null or Automatic.";
Error::MissingDesiccantPhaseInformation = "The State of the specified Desiccant `1` is not informed. Please add the State of the Desiccant to the Desiccant sample model.";
Error::InvalidDesiccantPhaseInformation = "The State of the specified Desiccant `1`, `2`, is not valid. Please use a Solid or Liquid chemical as a desiccant.";
Error::MissingDesiccantAmount = "Since the State of the specified Desiccant `1` is not valid, DesiccantAmount cannot be resolved automatically. Please set the DesiccantPhase to a valid State [Solid or Liquid] or determine the DesiccantAmount.";
Error::DesiccantAmountInformedForVacuumMethod = "Desiccation method is set to Vacuum which desiccates samples under vacuum with no desiccant. However, DesiccantAmount is specified to `1`. PLease change the Method option to DesiccantUnderVacuum or StandardDesiccant if you wish to desiccate the sample in the presence of a desiccant or set DesiccantAmount option to Null or Automatic.";
Error::MethodAndDesiccantPhaseMismatch = "The desiccation Method `1` does not match DesiccantPhase `2`. If DesiccantPhase is Liquid, desiccation method must be StandardDesiccant, NOT DesiccantUnderVacuum or Vacuum.";
Error::DesiccantPhaseAndAmountMismatch = "The unit of DesiccantAmount, `2`, does not match physical state of the desiccant, `1`. DesiccantAmount must be in mass or volume units if DesiccantPhase is Solid or Liquid, respectively.";
Error::InvalidSamplesOutStorageCondition = "Storage conditions of the output sample(s) `1` are not informed. Please specify SampleOutStorageCondition in options or update the DefaultStorageCondition of the model samples.";
Error::MissingMassInformation = "The sample(s) `1` are missing mass information. Please add the amount of the sample to the Mass field of the sample object, `1`.";
Warning::InsufficientDesiccantAmount = "The specified DesiccantAmount `1` might NOT be sufficient for efficient drying of the samples.";

(* ::Subsection::Closed:: *)
(* ExperimentDesiccate *)

(*Mixed Input*)
ExperimentDesiccate[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
    sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
    mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

  (*Determine the requested return value from the function*)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (*Determine if we should keep a running list of tests*)
  gatherTests = MemberQ[output, Tests];

  (*Remove temporal links and named objects.*)
  {listedContainers, listedOptions} = sanitizeInputs[ToList[myInputs], ToList[myOptions]];

  (*First, simulate our sample preparation.*)
  validSamplePreparationResult = Check[
    (*Simulate sample preparation.*)
    {mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
      ExperimentDesiccate,
      listedContainers,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (*If we are given an invalid define name, return early.*)
  If[MatchQ[validSamplePreparationResult, $Failed],
    (*Return early.*)
    (*Note: We've already thrown a message above in simulateSamplePreparationPackets.*)
    Return[$Failed]
  ];

  (*Convert our given containers into samples and sample index-matched options.*)
  containerToSampleResult = If[gatherTests,
    (*We are gathering tests. This silences any messages being thrown.*)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentDesiccate,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output -> {Result, Tests, Simulation},
      Simulation -> updatedSimulation
    ];

    (*Therefore, we have to run the tests to see if we encountered a failure.*)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentDesiccate,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output -> {Result, Simulation},
        Simulation -> updatedSimulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentDesiccate[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];

(* Sample input/core overload*)
ExperimentDesiccate[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult,
    optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests, instruments,
    templatedOptions, templateTests, inheritedOptions, expandedSafeOps, packetObjectSample, preferredContainers, containerOutObjects, containerOutModels, instrumentOption,
    samplesWithPreparedSamples, modelSampleFields, modelContainerFields, objectContainerFields,
    instrumentObjects, allObjects, allInstruments, allContainers, objectSampleFields,
    updatedSimulation, upload, confirm, fastTrack, parentProtocol, cache,
    downloadedStuff, cacheBall, resolvedOptionsResult, desiccantSamples,
    resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
    samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
    safeOptionsNamed, allContainerModels, performSimulationQ,
    protocolPacketWithResources, resourcePacketTests, postProcessingOptions,
    result, simulatedProtocol, simulation, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* make sure we're working with a list of options and samples, and remove all temporal links *)
  {listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult = Check[
    (* Simulate sample preparation. *)
    {samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
      ExperimentDesiccate,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult, $Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptionsNamed, safeOpsTests} = If[gatherTests,
    SafeOptions[ExperimentDesiccate, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentDesiccate, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
  ];

  (* replace all objects referenced by Name to ID *)
  {samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentDesiccate, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentDesiccate, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOpsTests, validLengthTests}],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentDesiccate, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentDesiccate, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* get assorted hidden options *)
  {upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentDesiccate, {samplesWithPreparedSamples}, inheritedOptions]];

  (* --- Search for and Download all the information we need for resolver and resource packets function --- *)

  (* do a huge search to get everything we could need *)

  {
    instruments
  } = Search[
    {
      {Model[Instrument, Desiccator]}
    },
    {
      Deprecated != True && DeveloperObject != True
    }
  ];


  (* all possible containers that the resolver might use*)
  preferredContainers = DeleteDuplicates[
    Flatten[{
      PreferredContainer[All, Type -> All],
      PreferredContainer[All, LightSensitive -> True, Type -> All]
    }]
  ];

  (* any container the user provided (in case it's not on the PreferredContainer list) *)
  containerOutObjects = DeleteDuplicates[Cases[
    Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
    ObjectP[Object]
  ]];
  containerOutModels = DeleteDuplicates[Cases[
    Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
    ObjectP[Model]
  ]];

  (* gather the instrument option *)
  instrumentOption = Lookup[expandedSafeOps, Instrument];

  (* pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
  instrumentObjects = Cases[Flatten[{instrumentOption}], ObjectP[Object[Instrument]]];

  (* split things into groups by types (since we'll be downloading different things from different types of objects) *)
  allObjects = DeleteDuplicates[Flatten[{instruments, preferredContainers, containerOutModels, containerOutObjects}]];
  allInstruments = Cases[allObjects, ObjectP[Model[Instrument]]];
  allContainerModels = Flatten[{
    Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, Plate]}]],
    Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[{Model[Container]}], Infinity],

    (*Desiccant Container*)
    {Model[Container, Vessel, "id:4pO6dMOxdbJM"]} (*Pyrex Crystallization Dish*)
  }];
  allContainers = Flatten[{
    Cases[
      KeyDrop[inheritedOptions, {Cache, Simulation}],
      ObjectReferenceP[Object[Container]],
      Infinity
    ]
  }];


  (*articulate all the fields needed*)
  objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]]];
  modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {DefaultStorageCondition}];
  objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
  modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]]];

  (* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
  (* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
  packetObjectSample = {
    Packet[Sequence @@ objectSampleFields],
    Packet[Container[objectContainerFields]],
    Packet[Container[Model][modelContainerFields]],
    Packet[Model[modelSampleFields]],
    Packet[Model[{DefaultStorageCondition}]]
  };

  (* Lookup specified Desiccant *)
  desiccantSamples = If[
    MatchQ[Lookup[expandedSafeOps, Desiccant], Except[Automatic | Null]],
    Lookup[expandedSafeOps, Desiccant],
    {
      Model[Sample, "id:GmzlKjzrmB85"], (*Indicating Drierite*)
      Model[Sample, "id:Vrbp1jG80ZnE"] (*Sulfuric acid*)
    }
  ];

  (* download all the things *)
  downloadedStuff = Quiet[
    Download[
      {
        (*1*)ToList[mySamples],
        (*3*)ToList[desiccantSamples],
        (*4*)allContainerModels,
        (*5*)allContainers
      },
      Evaluate[
        {
          (*1*)packetObjectSample,
          (*3*){Packet[State, Mass, Volume, Status, Model]},
          (*4*){Evaluate[Packet @@ modelContainerFields]},

          (* all basic container models (from PreferredContainers) *)
          (*5*){
          Evaluate[Packet @@ objectContainerFields],
          Packet[Model[modelContainerFields]]
        }
        }
      ],
      Cache -> cache,
      Simulation -> updatedSimulation,
      Date -> Now
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* get all the cache and put it together *)
  cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

  (* Build the resolved options *)
  resolvedOptionsResult = Check[
    {resolvedOptions, resolvedOptionsTests} = If[gatherTests,
      resolveExperimentDesiccateOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
      {resolveExperimentDesiccateOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentDesiccate,
    resolvedOptions,
    Ignore -> listedOptions,
    Messages -> False
  ];

  (* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
  (* if Output contains Result or Simulation, then we can't do this *)
  optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
  returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyBecauseFailuresQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  (* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
  (* need to return some type of simulation to our parent function that called us. *)
  performSimulationQ = MemberQ[output, Result | Simulation] && MatchQ[Lookup[resolvedOptions, PreparatoryPrimitives], Null | {}];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
      Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {protocolPacketWithResources, resourcePacketTests} = Which[
    returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
      {$Failed, {}},
    gatherTests,
      desiccateResourcePackets[
        samplesWithPreparedSamples,
        templatedOptions,
        resolvedOptions,
        collapsedResolvedOptions,
        Cache -> cacheBall,
        Simulation -> updatedSimulation,
        Output -> {Result, Tests}
      ],
    True,
      {
        desiccateResourcePackets[
          samplesWithPreparedSamples,
          templatedOptions,
          resolvedOptions,
          collapsedResolvedOptions,
          Cache -> cacheBall,
          Simulation -> updatedSimulation,
          Output -> Result
        ],
        {}
      }
  ];

  (* --- Simulation --- *)
  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulation} = If[performSimulationQ,
    simulateExperimentDesiccate[
      If[MatchQ[protocolPacketWithResources, $Failed],
        $Failed,
        protocolPacketWithResources[[1]] (* protocolPacket *)
      ],
      If[MatchQ[protocolPacketWithResources, $Failed],
        $Failed,
        Flatten[ToList[protocolPacketWithResources[[2]]]] (* unitOperationPackets *)
      ],
      ToList[samplesWithPreparedSamples],
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> updatedSimulation
    ],
    {Null, Null}
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output, Result],
    Return[outputSpecification /. {
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> simulation
    }]
  ];

  postProcessingOptions = Map[
    If[
      MatchQ[Lookup[safeOps, #], Except[Automatic]],
      # -> Lookup[safeOps, #],
      Nothing
    ]&,
    {ImageSample, MeasureVolume, MeasureWeight}
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  result = Which[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[protocolPacketWithResources, $Failed], $Failed,

    (* Actually upload our protocol object. We are being called as a sub-protocol in ExperimentManualSamplePreparation. *)
    True,
      UploadProtocol[
        (* protocol packet *)
        protocolPacketWithResources[[1]], (*protocolPacket*)
        ToList[protocolPacketWithResources[[2]]], (*unitOperationPackets*)
        Upload -> Lookup[safeOps, Upload],
        Confirm -> Lookup[safeOps, Confirm],
        ParentProtocol -> Lookup[safeOps, ParentProtocol],
        Priority -> Lookup[safeOps, Priority],
        StartDate -> Lookup[safeOps, StartDate],
        HoldOrder -> Lookup[safeOps, HoldOrder],
        QueuePosition -> Lookup[safeOps, QueuePosition],
        ConstellationMessage -> {Object[Protocol, Desiccate]},
        Cache -> cacheBall,
        Simulation -> updatedSimulation
      ]
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> result,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation
  }
];

(* ::Subsection::Closed:: *)
(*resolveExperimentDesiccateOptions*)

DefineOptions[
  resolveExperimentDesiccateOptions,
  Options :> {HelperOutputOption, SimulationOption, CacheOption}
];

resolveExperimentDesiccateOptions[myInputSamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentDesiccateOptions]] := Module[
  {
    outputSpecification, output, gatherTests, cache,
    simulation, samplePrepOptions, desiccationOptions,
    simulatedSamples, resolvedSamplePrepOptions,
    updatedSimulation, samplePrepTests, samplePackets,
    modelPackets, inputSampleContainerPacketsWithNulls,
    sampleContainerModelPacketsWithNulls,
    cacheBall, sampleDownloads, fastAssoc,
    sampleContainerModelPackets, inputSampleContainerPackets,
    messages, discardedSamplePackets, discardedInvalidInputs,
    discardedTest, mapThreadFriendlyOptions,
    desiccationOptionAssociation, optionPrecisions, roundedDesiccationOptions, precisionTests,
    specifiedAmount, specifiedSampleContainer,
    specifiedSampleContainerLabel, specifiedMethod,
    specifiedDesiccant, specifiedDesiccantPhase,
    specifiedDesiccantAmount, specifiedSampleOutLabel, specifiedDesiccator, specifiedTime,
    specifiedSampleLabel, specifiedContainerOut,
    specifiedContainerOutLabel, specifiedSamplesOutStorageCondition,
    nonSolidSamplePackets, nonSolidSampleInvalidInputs,
    nonSolidSampleTest, missingMassSamplePackets, missingMassInvalidInputs,
    missingMassTest, resolvedDesiccantPhase, resolvedDesiccantAmount,
    resolvedDesiccator, resolvedDesiccant,
    resolvedAmount, resolvedSampleContainer, resolvedSampleContainerLabel,
    resolvedSampleLabel, resolvedContainerOut, resolvedContainerOutLabel,
    resolvedSamplesOutStorageCondition, methodDesiccantPhaseMismatch,
    methodDesiccantPhaseMismatchTest, resolvedOptions, resolvedSampleOutLabel, deficientDesiccantAmount,
    deficientDesiccantAmountTest, invalidDesiccantPhaseOption,
    invalidDesiccantPhaseTest, missingDesiccantAmountOption,
    missingDesiccantAmountTest, desiccantPhaseAmountMismatch,
    desiccantPhaseAmountMismatchTest, invalidSamplesOutStorageConditions,
    invalidSamplesOutStorageConditionsOptions, invalidSamplesOutStorageConditionsTest,
    resolvedPostProcessingOptions, aliquotTests,
    invalidInputs, invalidOptions, allTests
  },

  (* Determine the requested output format of this function. *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Separate out our Desiccate options from our Sample Prep options. *)
  {samplePrepOptions, desiccationOptions} = splitPrepOptions[myOptions];

  (* Resolve our sample prep options (only if the sample prep option is not true) *)
  {{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentDesiccate, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
    {resolveSamplePrepOptionsNew[ExperimentDesiccate, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
  ];

  (* Extract the packets that we need from our downloaded cache. *)
  (* need to do this even if we have caching because of the simulation stuff *)
  sampleDownloads = Quiet[Download[
    simulatedSamples,
    {
      Packet[Name, Volume, Mass, State, Status, Container, Solvent, Position, Model],
      Packet[Model[{DefaultStorageCondition}]],
      Packet[Container[{Object, Model}]],
      Packet[Container[Model[{MaxVolume}]]]
    },
    Simulation -> updatedSimulation
  ], {Download::FieldDoesntExist, Download::NotLinkField}];

  (* combine the cache together *)
  cacheBall = FlattenCachePackets[{
    cache,
    sampleDownloads
  }];

  (* generate a fast cache association *)
  fastAssoc = makeFastAssocFromCache[cacheBall];

  (* Get the downloaded mess into a usable form *)
  {
    samplePackets,
    modelPackets,
    inputSampleContainerPacketsWithNulls,
    sampleContainerModelPacketsWithNulls
  } = Transpose[sampleDownloads];

  (* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
      Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
  sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls, {Null -> {}}, 1];
  inputSampleContainerPackets = Replace[inputSampleContainerPacketsWithNulls, {Null -> {}}, 1];

  (*-- INPUT VALIDATION CHECKS --*)

  (* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
  (* Get the samples from samplePackets that are discarded. *)
  discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && messages,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
      ];
      passingTest = If[Length[discardedInvalidInputs] == Length[myInputSamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[myInputSamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];


  (* NOTE: MAKE SURE THE SAMPLES ARE SOLID - *)

  (* Get the samples that are not solids,cannot desiccate those *)
  nonSolidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Solid | Null]]&];

  (* Keep track of samples that are not Solid *)
  nonSolidSampleInvalidInputs = Lookup[nonSolidSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,do so *)
  If[Length[nonSolidSampleInvalidInputs] > 0 && messages,
    Message[Error::NonSolidSample, ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  nonSolidSampleTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nonSolidSampleInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall] <> " have a Solid State:", True, False]
      ];

      passingTest = If[Length[nonSolidSampleInvalidInputs] == Length[myInputSamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[myInputSamples, nonSolidSampleInvalidInputs], Cache -> cacheBall] <> " have a Solid State:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];


  (* NOTE: MAKE SURE THE SAMPLES HAVE A MASS IF THEY'RE a SOLID - *)
  (* Get the samples that do not have a MASS but are a solid *)
  missingMassSamplePackets = Select[Flatten[samplePackets], NullQ[Lookup[#, Mass]]&];

  (* Keep track of samples that do not have mass but are a solid *)
  missingMassInvalidInputs = Lookup[missingMassSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,do so *)
  If[Length[missingMassInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[Error::MissingMassInformation, ObjectToString[missingMassInvalidInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  missingMassTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[missingMassInvalidInputs] == 0,
        Nothing,
        Warning["Our input samples " <> ObjectToString[missingMassInvalidInputs, Cache -> cacheBall] <> " are not missing mass information:", True, False]
      ];

      passingTest = If[Length[missingMassInvalidInputs] == Length[myInputSamples],
        Nothing,
        Warning["Our input samples " <> ObjectToString[Complement[myInputSamples, missingMassInvalidInputs], Cache -> cacheBall] <> " are not missing mass information:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*-- OPTION PRECISION CHECKS --*)

  (* Convert list of rules to Association so we can Lookup,Append,Join as usual. *)
  desiccationOptionAssociation = Association[desiccationOptions];

  (* Define the options and associated precisions that we need to check *)
  optionPrecisions = {
    {Amount, 10^-3 Gram},
    {DesiccantAmount, 10^0 Gram},
    {Time, 10^0 Second}
  };

  (* round values for options based on option precisions *)
  {roundedDesiccationOptions, precisionTests} = If[
    gatherTests,
    RoundOptionPrecision[desiccationOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    {RoundOptionPrecision[desiccationOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], Null}
  ];

  (* Lookup the values of the options to resolve using the option names associated with the type of option being resolved *)
  {
    specifiedAmount,
    specifiedSampleContainer,
    specifiedSampleContainerLabel,
    specifiedMethod,
    specifiedDesiccant,
    specifiedDesiccantPhase,
    specifiedDesiccantAmount,
    specifiedSampleOutLabel,
    specifiedDesiccator,
    specifiedTime,
    specifiedSampleLabel,
    specifiedContainerOut,
    specifiedContainerOutLabel,
    specifiedSamplesOutStorageCondition
  } = Lookup[roundedDesiccationOptions,
    {
      Amount,
      SampleContainer,
      SampleContainerLabel,
      Method,
      Desiccant,
      DesiccantPhase,
      DesiccantAmount,
      SampleOutLabel,
      Desiccator,
      Time,
      SampleLabel,
      ContainerOut,
      ContainerOutLabel,
      SamplesOutStorageCondition
    }
  ];

  (* Options Method, and Time don't need option resolving. Null is not allowed, Default is not Automatic. *)

  (* Resolve Desiccant and DesiccantPhase option. Default is Automatic. *)
  {resolvedDesiccant, resolvedDesiccantPhase} = Which[
    MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Except[Automatic], Except[Automatic]}],
      {specifiedDesiccant, specifiedDesiccantPhase},

    MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Except[Automatic], Automatic}],
      If[
        MatchQ[specifiedMethod, Vacuum],
        {specifiedDesiccant, Null},
        {specifiedDesiccant, fastAssocLookup[fastAssoc, specifiedDesiccant, State]}
      ],

    MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Except[Automatic]}] && MatchQ[specifiedMethod, Vacuum],
      {Null, specifiedDesiccantPhase},

    MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Except[Automatic]}],
      If[
        MatchQ[specifiedDesiccantPhase, Liquid],
        {Model[Sample, "id:Vrbp1jG80ZnE"], specifiedDesiccantPhase},
        {Model[Sample, "id:GmzlKjzrmB85"], specifiedDesiccantPhase}
      ],

    MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Automatic}],
      If[
        MatchQ[specifiedMethod, Vacuum],
        {Null, Null},
        {Model[Sample, "id:GmzlKjzrmB85"], Solid}
      ]
  ];

  (* throw an error if State in resolvedDesiccant is Null or Gas if Method is not Vacuum; throw and error if Method is Vacuum but resolvedDesiccant is not NUll*)
  invalidDesiccantPhaseOption = Which[
    !NullQ[resolvedDesiccantPhase] && MatchQ[specifiedMethod, Vacuum],
      (
        Message[Error::DesiccantPhaseInformedForVacuumMethod, ObjectToString[resolvedDesiccant, Cache -> cacheBall]];
        {DesiccantPhase}
      ),

    NullQ[resolvedDesiccantPhase] && !MatchQ[specifiedMethod, Vacuum] && messages,
      (
        Message[Error::MissingDesiccantPhaseInformation, ObjectToString[resolvedDesiccant, Cache -> cacheBall]];
        {DesiccantPhase}
      ),

    MatchQ[resolvedDesiccantPhase, Gas] && messages,
      (
        Message[Error::InvalidDesiccantPhaseInformation, ObjectToString[resolvedDesiccant, Cache -> cacheBall], ObjectToString[resolvedDesiccantPhase, Cache -> cacheBall]];
        {DesiccantPhase}
      ),
    True, {}
  ];

  (* Define the tests the user will see for the above messages *)
  invalidDesiccantPhaseTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[MatchQ[resolvedDesiccantPhase, Alternatives[Null, Gas]],
        Test["The DesiccantPhase option or the State field of the specified Desiccant is informed:", True, False]
      ];
      passingTest = If[MatchQ[resolvedDesiccantPhase, Except[Null | Gas]],
        Test["The DesiccantPhase option or the State field of the specified Desiccant is informed:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Throw an error if the DesiccantPhase Liquid and the Method is Vacuum or Vacuum *)
  methodDesiccantPhaseMismatch = If[
    MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[specifiedMethod, DesiccantUnderVacuum | Vacuum] && messages,
    (
      Message[Error::MethodAndDesiccantPhaseMismatch, ToString[specifiedMethod], ToString[resolvedDesiccantPhase]];
      {Method, DesiccantPhase}
    ),
    {}
  ];

  (* Define the tests the user will see for the above messages *)
  methodDesiccantPhaseMismatchTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[specifiedMethod, DesiccantUnderVacuum | Vacuum],
        Test["Method and DesiccantPhase options ao not conflict:", True, False]
      ];
      passingTest = If[MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[specifiedMethod, StandardDesiccant],
        Test["Method and DesiccantPhase options ao not conflict:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Resolve DesiccantAmount Option *)
  resolvedDesiccantAmount = Which[
    MatchQ[specifiedDesiccantAmount, Except[Automatic]],
      specifiedDesiccantAmount,

    MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]] && NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume]],
      Null,

    MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
      Min[100Milliliter, fastAssocLookup[fastAssoc, resolvedDesiccant, Volume]],

    MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[resolvedDesiccant, ObjectP[Model[Sample]]],
      100Milliliter,

    MatchQ[resolvedDesiccantPhase, Solid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]] && NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass]],
      Null,

    MatchQ[resolvedDesiccantPhase, Solid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
      Min[100Gram, fastAssocLookup[fastAssoc, resolvedDesiccant, Mass]],

    MatchQ[resolvedDesiccantPhase, Solid] && MatchQ[resolvedDesiccant, ObjectP[Model[Sample]]],
      100Gram,

    MatchQ[specifiedMethod,Vacuum],
      Null,

    MatchQ[resolvedDesiccantPhase, Null],
      Null,

    True,
      100 Gram
  ];

  (* throw an error if resolvedDesiccantAmount is Null *)
  missingDesiccantAmountOption = Which[

    MatchQ[resolvedDesiccantAmount, Null] && !MatchQ[specifiedMethod, Vacuum] && messages,
      (
        Message[Error::MissingDesiccantAmount, ObjectToString[resolvedDesiccant, Cache -> cacheBall]];
        {DesiccantAmount, DesiccantPhase}
      ),

    !MatchQ[resolvedDesiccantAmount, Null] && MatchQ[specifiedMethod,Vacuum] && messages,
      (
        Message[Error::DesiccantAmountInformedForVacuumMethod, ObjectToString[resolvedDesiccantAmount, Cache -> cacheBall]];
        {DesiccantAmount, DesiccantPhase}
      ),

    True,
      {}
  ];

  (* Define the tests the user will see for the above message *)
  missingDesiccantAmountTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[MatchQ[resolvedDesiccantAmount, Null],
        Test["The DesiccantAmount option is informed:", True, False]
      ];
      passingTest = If[MatchQ[resolvedDesiccantAmount, Except[Null]],
        Test["The DesiccantAmount option is informed:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* throw an error if resolvedDesiccantAmount is too little (less than 100 g or 100 mL)*)
  deficientDesiccantAmount = If[
    LessQ[QuantityMagnitude[resolvedDesiccantAmount], 100]
        && messages
        && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[Warning::InsufficientDesiccantAmount, ToString[resolvedDesiccantAmount]];
      {DesiccantAmount}
    ),
    {}
  ];

  (* Define the tests the user will see for the above message *)
  deficientDesiccantAmountTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[LessQ[resolvedDesiccantAmount, 10 Gram] | LessQ[resolvedDesiccantAmount, 10 Milliliter],
        Warning["The DesiccantAmount is sufficient:", True, False]
      ];
      passingTest = If[GreaterEqualQ[resolvedDesiccantAmount, 10 Gram] | GreaterEqualQ[resolvedDesiccantAmount, 10 Milliliter],
        Warning["The DesiccantAmount is sufficient:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* throw an error if DesiccantAmount and DesiccantPhase conflict *)
  desiccantPhaseAmountMismatch = If[
    Or[
      MatchQ[resolvedDesiccantPhase, Solid] && !MatchQ[specifiedDesiccantAmount, Automatic] && !MassQ[specifiedDesiccantAmount],
      MatchQ[resolvedDesiccantPhase, Liquid] && !MatchQ[specifiedDesiccantAmount, Automatic] && !VolumeQ[specifiedDesiccantAmount]
    ] && messages,
    (
      Message[Error::DesiccantPhaseAndAmountMismatch, ObjectToString[resolvedDesiccantPhase, Cache -> cacheBall], ObjectToString[specifiedDesiccantAmount, Cache -> cacheBall]];
      {DesiccantPhase, DesiccantAmount}
    ),
    {}
  ];

  (* Define the tests the user will see for the above message *)
  desiccantPhaseAmountMismatchTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[
        Or[
          MatchQ[resolvedDesiccantPhase, Solid] && !MassQ[resolvedDesiccantAmount],
          MatchQ[resolvedDesiccantPhase, Liquid] && !VolumeQ[resolvedDesiccantAmount]
        ],
        Test["Option DesiccantAmount is in mass units if DesiccantPhase is Solid; Or option DesiccantAmount is in volume units if DesiccantPhase is Liquid:", True, False]
      ];
      passingTest = If[
        Or[
          resolvedDesiccantPhase == Solid && MassQ[resolvedDesiccantAmount],
          resolvedDesiccantPhase == Liquid && VolumeQ[resolvedDesiccantAmount]
        ],
        Test["Option DesiccantAmount is in mass units if DesiccantPhase is Solid; Or option DesiccantAmount is in volume units if DesiccantPhase is Liquid:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* Resolve Desiccator option. Null is not allowed; Default is Automatic. *)
  resolvedDesiccator = If[
    MatchQ[specifiedDesiccator, Except[Automatic]],
    specifiedDesiccator,
    Model[Instrument, Desiccator, "id:7X104v1xjLoZ"] (*Bel-Art Space Saver Vacuum Desiccator*)
  ];

  (* NOTE: MAPPING*)
  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentDesiccate, roundedDesiccationOptions];

  (* big MapThread to get all the options resolved *)
  {
    (*1*)resolvedAmount,
    (*2*)resolvedSampleContainer,
    (*3*)resolvedSampleContainerLabel,
    (*4*)resolvedSampleLabel,
    (*5*)resolvedSampleOutLabel,
    (*6*)resolvedContainerOut,
    (*7*)resolvedContainerOutLabel,
    (*8*)resolvedSamplesOutStorageCondition,
    (*9*)invalidSamplesOutStorageConditions
  } = Transpose[
    MapThread[
      Function[{samplePacket, modelPacket, options, inputSampleContainerPacket, sampleContainerModelPacket},
        Module[
          {
            unresolvedAmount, unresolvedSampleContainer, sampleContainer, unresolvedSampleContainerLabel, sampleContainerLabel, unresolvedSampleLabel, sampleLabel, unresolvedSampleOutLabel, sampleOutLabel, unresolvedContainerOut, unresolvedContainerOutLabel, containerOutLabel, unresolvedSamplesOutStorageCondition, invalidSamplesOutStorageCondition
          },

          (* error checking variables *)
          {
            invalidSamplesOutStorageCondition
          } = {
            False
          };

          (* pull out all the relevant unresolved options*)
          {
            unresolvedAmount,
            unresolvedSampleContainer,
            unresolvedSampleContainerLabel,
            unresolvedSampleLabel,
            unresolvedSampleOutLabel,
            unresolvedContainerOut,
            unresolvedContainerOutLabel,
            unresolvedSamplesOutStorageCondition
          } = Lookup[
            options,
            {
              Amount,
              SampleContainer,
              SampleContainerLabel,
              SampleLabel,
              SampleOutLabel,
              ContainerOut,
              ContainerOutLabel,
              SamplesOutStorageCondition
            }
          ];

          (* --- Resolve IndexMatched Options --- *)

          (* SampleLabel; Default: Automatic *)
          sampleLabel = Which[
            MatchQ[unresolvedSampleLabel, Except[Automatic]], unresolvedSampleLabel,
            And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]]],
            Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
            True, CreateUniqueLabel["sample " <> StringDrop[Lookup[samplePacket, ID], 3]]
          ];

          (* SampleOutLabel; Default: Automatic *)
          sampleOutLabel = Which[
            MatchQ[unresolvedSampleOutLabel, Except[Automatic]], unresolvedSampleOutLabel,
            NullQ[unresolvedSampleContainer] && NullQ[unresolvedContainerOut],
              sampleLabel,
            True,
              CreateUniqueLabel["SampleOut " <> StringDrop[Lookup[samplePacket, ID], 3]]
          ];

          (* SampleContainer; Default: Null; Null indicates Input Sample's Container. If Amount is set to a value other than All, the specified amount of the sample is transferred into a SampleContainer determined by PreferredContainer*)
          sampleContainer = Which[
            MatchQ[unresolvedSampleContainer, Except[Null]],
              unresolvedSampleContainer,

            MatchQ[unresolvedAmount, Except[All]],
              PreferredContainer[unresolvedAmount],

            True,
              unresolvedSampleContainer
          ];

          (* SampleContainerLabel; Default: Null.
          SampleContainer refers to the container that contains the sample during desiccation. It may or may not be the same as the Input's container.
          inputSampleContainerPacket refers to the input samples containers., *)
          sampleContainerLabel = Which[
            MatchQ[unresolvedSampleContainerLabel, Except[Automatic]],
              unresolvedSampleContainerLabel,
            And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[inputSampleContainerPacket, Object]]],
              Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[inputSampleContainerPacket, Object]],
            NullQ[sampleContainer],
              CreateUniqueLabel["input container " <> StringDrop[Lookup[inputSampleContainerPacket, ID], 3]],
            True,
              CreateUniqueLabel["sample container " <> StringDrop[Download[sampleContainer, ID], 3]]
          ];

          (* ContainerOutLabel; Default: Null *)
          containerOutLabel = Which[
            MatchQ[unresolvedContainerOutLabel, Except[Automatic]], unresolvedContainerOutLabel,
            NullQ[unresolvedContainerOut],
              sampleContainerLabel,
            True,
              CreateUniqueLabel["container out " <> StringDrop[Download[unresolvedContainerOut, ID], 3]]
          ];

          (*Throw an error if SamplesOutStorageCondition is Null and DefaultStorageCondition is not informed*)
          invalidSamplesOutStorageCondition = NullQ[unresolvedSamplesOutStorageCondition] && NullQ[Lookup[modelPacket, DefaultStorageCondition]];

          {
            (*1*)unresolvedAmount,
            (*2*)sampleContainer,
            (*3*)sampleContainerLabel,
            (*4*)sampleLabel,
            (*5*)sampleOutLabel,
            (*6*)unresolvedContainerOut,
            (*7*)containerOutLabel,
            (*8*)unresolvedSamplesOutStorageCondition,
            (*9*)invalidSamplesOutStorageCondition
          }
        ]
      ],
      {samplePackets, modelPackets, mapThreadFriendlyOptions, inputSampleContainerPackets, sampleContainerModelPackets}
    ]
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

  (* throw an error if SamplesOutStorageCondition is resolved to Null for any samples *)
  invalidSamplesOutStorageConditionsOptions = If[MemberQ[invalidSamplesOutStorageConditions, True] && messages,
    (
      Message[
        Error::InvalidSamplesOutStorageCondition,
        ObjectToString[PickList[simulatedSamples, invalidSamplesOutStorageConditions], Cache -> cacheBall]
      ];
      {SamplesOutStorageCondition}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  invalidSamplesOutStorageConditionsTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, invalidSamplesOutStorageConditions];
      passingInputs = PickList[simulatedSamples, invalidSamplesOutStorageConditions, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must have a valid SamplesOutStorageCondition.", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must have a valid SamplesOutStorageCondition.", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* gather all the resolved options together *)
  (* doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions*)
  resolvedOptions = ReplaceRule[
    myOptions,
    Flatten[{
      Amount -> resolvedAmount,
      SampleLabel -> resolvedSampleLabel,
      SampleOutLabel -> resolvedSampleOutLabel,
      SampleContainer -> resolvedSampleContainer,
      SampleContainerLabel -> resolvedSampleContainerLabel,
      Method -> specifiedMethod,
      Desiccant -> resolvedDesiccant,
      DesiccantPhase -> resolvedDesiccantPhase,
      DesiccantAmount -> resolvedDesiccantAmount,
      Desiccator -> resolvedDesiccator,
      Time -> specifiedTime,
      ContainerOut -> resolvedContainerOut,
      ContainerOutLabel -> resolvedContainerOutLabel,
      SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
      resolvedSamplePrepOptions,
      resolvedPostProcessingOptions
    }]
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[{
    nonSolidSampleInvalidInputs,
    discardedInvalidInputs,
    missingMassInvalidInputs
  }]];

  (* gather all the invalid options together *)
  invalidOptions = DeleteDuplicates[Flatten[{
    invalidDesiccantPhaseOption,
    missingDesiccantAmountOption,
    methodDesiccantPhaseMismatch,
    desiccantPhaseAmountMismatch,
    invalidSamplesOutStorageConditionsOptions
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[messages && Length[invalidInputs] > 0,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[messages && Length[invalidOptions] > 0,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* get all the tests together *)
  allTests = Cases[Flatten[{
    samplePrepTests,
    discardedTest,
    missingMassTest,
    nonSolidSampleTest,
    invalidDesiccantPhaseTest,
    methodDesiccantPhaseMismatchTest,
    missingDesiccantAmountTest,
    deficientDesiccantAmountTest,
    desiccantPhaseAmountMismatchTest,
    invalidSamplesOutStorageConditionsTest,
    aliquotTests

  }], TestP];

  (* pending to add updatedExperimentDesiccateSimulation to the Result *)
  (* return our resolved options and/or tests *)
  outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}
];

(* ::Subsection:: *)
(*desiccateResourcePackets*)

DefineOptions[desiccateResourcePackets,
  Options :> {
    CacheOption,
    HelperOutputOption,
    SimulationOption
  }
];

(*populate fields and make resources for samples and things we're using for desiccation*)
desiccateResourcePackets[
  mySamples : {ObjectP[Object[Sample]]..},
  myUnresolvedOptions : {___Rule},
  myResolvedOptions : {___Rule},
  myCollapsedResolvedOptions : {___Rule},
  myOptions : OptionsPattern[]
] := Module[
  {
    outputSpecification, output, cache, allResourceBlobs, safeOps, instrumentResources, samplesInResources,
    simulation, protocolPacket, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
    simulatedSamples, updatedSimulation, simulatedSampleContainers,
    gatherTests, messages, sampleLabel, fastAssoc, numericAmount,
    amount, sampleContainer, sampleContainerLabel, method, desiccant, desiccantPhase, desiccantAmount, desiccator, time, containerOut, containerOutLabel, samplesOutStorageCondition, numberOfReadings,
    sampleContainerResources, unitOperationPackets, updatedSamplesOutStorageCondition,
    finalizedPacket, sharedFieldPacket, desiccantResource,
    containerOutResourcesForProtocol, containerOutResourcesForUnitOperation
  },

  (* get the safe options for this function *)
  safeOps = SafeOptions[desiccateResourcePackets, ToList[myOptions]];

  (* pull out the output options *)
  outputSpecification = Lookup[safeOps, Output];
  output = ToList[outputSpecification];

  (* decide if we are gathering tests or throwing messages *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* lookup helper options *)
  {cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

  (* make the fast association *)
  fastAssoc = makeFastAssocFromCache[cache];

  (* simulate the sample preparation stuff so we have the right containers if we are aliquoting *)
  {simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentDesiccate, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

  (* this is the only real Download I need to do, which is to get the simulated sample containers *)
  simulatedSampleContainers = Download[simulatedSamples, Container[Object], Cache -> cache, Simulation -> updatedSimulation];

  (* lookup option values*)
  {
    amount,
    sampleContainer,
    sampleContainerLabel,
    method,
    desiccant,
    desiccantPhase,
    desiccantAmount,
    desiccator,
    time,
    sampleLabel,
    containerOut,
    containerOutLabel,
    samplesOutStorageCondition
  } = Lookup[
    myResolvedOptions,
    {
      Amount,
      SampleContainer,
      SampleContainerLabel,
      Method,
      Desiccant,
      DesiccantPhase,
      DesiccantAmount,
      Desiccator,
      Time,
      SampleLabel,
      ContainerOut,
      ContainerOutLabel,
      SamplesOutStorageCondition
    }
  ];

  (*Update amount value to quantity if it is resolved to All*)
  numericAmount = MapThread[If[
    MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
  ]&, {amount, mySamples}];

  samplesInResources = MapThread[Resource[
    Sample -> fastAssocLookup[fastAssoc, #1, Object],
    Name -> #2, Amount -> #3
  ]&,
    {mySamples, sampleLabel, numericAmount}];

  (*make instrument resources*)
  instrumentResources = Link[Resource[Instrument -> desiccator, Time -> time]];

  (*Create resource packet for sampleContainer if needed*)
  sampleContainerResources = MapThread[If[
    NullQ[#], Null,
    Link[Resource[Sample -> #, Name -> #2]]
  ]&, {sampleContainer, sampleContainerLabel}];

  (*Create resource packet for containerOut if needed*)
  containerOutResourcesForProtocol = MapThread[If[
    NullQ[#], Null,
    If[MatchQ[#, ObjectP[Object]],
      Link[Resource[Sample -> #, Name -> #2], Protocols],
      Link[Resource[Sample -> #, Name -> #2]]
    ]]&, {containerOut, containerOutLabel}];

  (*Pattern for ContainerOut in Object[Protocol] is _Link with
  Relation -> Alternatives[Object[Container][Protocols],Model[Container].
  However, if the same pattern is Relations is used in
  Object[UnitOperation,Desiccate], ValidTypeQ does not pass;
  Backlink check: Object[Container][Protocols] points back to
  Object[UnitOperation, Desiccate][ContainerOut]:	..................	[FAIL].
  Therefore, here this is a 1way link for UnitOperation*)
  containerOutResourcesForUnitOperation = MapThread[If[
    NullQ[#], Null,
    Link[Resource[Sample -> #, Name -> #2]]
  ]&, {containerOut, containerOutLabel}];

  (* Desiccant resource if not Null *)
  desiccantResource = If[
    !NullQ[desiccant],
    Link[Resource[Sample -> desiccant, Container -> Model[Container, Vessel, "id:4pO6dMOxdbJM"] (*Model[Container, Vessel, "Pyrex Crystallization Dish"]*), Amount -> desiccantAmount, RentContainer -> True]],
    Null
  ];

  updatedSamplesOutStorageCondition = Map[If[
    MatchQ[#, ObjectP[Model[StorageCondition]]],
    Link[#],
    #
  ]&, samplesOutStorageCondition];

  (*NumberOfReadings determines how many time the pressure sensor reads the pressure inside desiccator when desiccation Method is Vacuum or DesiccantUnderVacuum. To be used in procedures. Two times per minute with some additional readings*)
  numberOfReadings = QuantityMagnitude[Convert[time, Minute]] * 2 + 15;

  (* Preparing protocol and unitOperationObject packets: Are we making resources for Manual or Robotic? (Desiccate is manual only) *)
  (* Preparing unitOperationObject. Consider if we are making resources for Manual or Robotic *)
  unitOperationPackets = Module[{nonHiddenOptions},
    (* Only include non-hidden options from Transfer. *)
    nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Desiccate]];

    UploadUnitOperation[
      Desiccate @@ ReplaceRule[Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
        {
          Sample -> samplesInResources,
          Desiccator -> instrumentResources,
          Desiccant -> desiccantResource,
          SampleContainer -> sampleContainerResources,
          ContainerOut -> containerOutResourcesForUnitOperation,
          SamplesOutStorageCondition -> updatedSamplesOutStorageCondition
        }
      ],
      UnitOperationType -> Batched,
      Preparation -> Manual,
      FastTrack -> True,
      Upload -> False
    ]
  ];

  (* populate the RequiredObjects and RequiredInstruments fields of the protocol packet. *)
  protocolPacket = Join[
    <|
      Object -> CreateID[Object[Protocol, Desiccate]],
      Type -> Object[Protocol, Desiccate],
      Replace[SamplesIn] -> samplesInResources,
      Replace[Amounts] -> numericAmount,
      SampleType -> Open,
      Method -> method,
      Replace[SampleContainers] -> sampleContainerResources,
      Replace[ContainersOut] -> containerOutResourcesForProtocol,
      Replace[SamplesOutStorageConditions] -> updatedSamplesOutStorageCondition,
      Desiccant -> desiccantResource,
      Desiccator -> instrumentResources,
      Time -> time,
      NumberOfReadings -> numberOfReadings,
      UnresolvedOptions -> myUnresolvedOptions,
      ResolvedOptions -> myResolvedOptions,
      Replace[Checkpoints] -> {
        {"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
        {"Running Experiment", time, "Samples are incubated in the desiccator.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> time]]},
        {"Sample Post-Processing", 10 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
        {"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]}
      },
      Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ ToList[Lookup[unitOperationPackets, Object]]
    |>
  ];

  (* generate a packet with the shared fields *)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

  (* call fulfillableResourceQ on all the resources we created *)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Site -> Lookup[myResolvedOptions, Site], Cache -> cache],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation,Messages -> messages, Site -> Lookup[myResolvedOptions, Site], Cache -> cache], Null}
  ];

  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[output, Options],
    RemoveHiddenOptions[ExperimentDesiccate, myResolvedOptions],
    Null
  ];

  (* generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    frqTests,
    {}
  ];

  (* generate the Result output rule *)
  (* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
    {protocolPacket, unitOperationPackets},
    $Failed
  ];

  (* return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* ::Subsection::Closed:: *)
(*simulateExperimentDesiccate*)

DefineOptions[
  simulateExperimentDesiccate,
  Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentDesiccate[
  myProtocolPacket : PacketP[Object[Protocol, Desiccate]] | $Failed | Null,
  myUnitOperationPackets : {PacketP[Object[UnitOperation, Desiccate]]..} | $Failed,
  mySamples : {ObjectP[Object[Sample]]...},
  myResolvedOptions : {_Rule...},
  myResolutionOptions : OptionsPattern[simulateExperimentDesiccate]
] := Module[
  {
    cache, simulation, samplePackets, protocolObject, currentSimulation,
    simulationWithLabels, fastAssoc,
    samplesOutStorageCondition, method, unchangedSamples,
    desiccant, desiccantPhase, desiccantAmount, desiccator,
    time, sampleLabel, sampleOutLabel, sampleContainer, sampleContainerLabel,
    containerOut, containerOutLabel, transferAmount, simulatedSamplesOut,
    sampleContainerResources, containerOutResources,
    uploadSampleTransferPackets, destinationLocation,
    inputContainers, needNewSampleQ, newContainer, simulatedSourceSamples,
    amount, simulatedNewSamples, newSamplePackets, destinationContainer,
    simulatedProtocol, simulatedSampleContainer, simulatedContainerOut
  },

  (* Lookup our cache and simulation and make our fast association *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
  fastAssoc = makeFastAssocFromCache[cache];

  (*Download packets that will be needed*)
  {
    samplePackets
  } = Quiet[
    Download[
      {
        ToList[mySamples]
      },
      {
        Packet[Model, Container]
      },
      Simulation -> simulation
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  (*	(* Get our map thread friendly options. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
    ExperimentDesiccate,
    myResolvedOptions
  ];*)

  (* lookup option values*)
  {
    amount,
    sampleContainer,
    sampleContainerLabel,
    method,
    desiccant,
    desiccantPhase,
    desiccantAmount,
    desiccator,
    time,
    sampleLabel,
    sampleOutLabel,
    containerOut,
    containerOutLabel,
    samplesOutStorageCondition
  } = Lookup[
    myResolvedOptions,
    {
      Amount,
      SampleContainer,
      SampleContainerLabel,
      Method,
      Desiccant,
      DesiccantPhase,
      DesiccantAmount,
      Desiccator,
      Time,
      SampleLabel,
      SampleOutLabel,
      ContainerOut,
      ContainerOutLabel,
      SamplesOutStorageCondition
    }
  ];

  (*Create resource packet for sampleContainer if needed*)
  sampleContainerResources = MapThread[If[
    NullQ[#], Null,
    If[MatchQ[#, ObjectP[Object]],
      Link[Resource[Sample -> #, Name -> #2], Protocols],
      Link[Resource[Sample -> #, Name -> #2]]
    ]]&, {sampleContainer, sampleContainerLabel}];

  (*Create resource packet for containerOut if needed*)
  containerOutResources = MapThread[If[
    NullQ[#], Null,
    If[MatchQ[#, ObjectP[Object]],
      Link[Resource[Sample -> #, Name -> #2], Protocols],
      Link[Resource[Sample -> #, Name -> #2]]
    ]]&, {containerOut, containerOutLabel}];

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject = Which[
    MatchQ[myProtocolPacket, $Failed],
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
      SimulateCreateID[Object[Protocol, Desiccate]],
    True,
      Lookup[myProtocolPacket, Object]
  ];

  (* Simulate the fulfillment of all resources by the procedure. *)
  (* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
  (* just make a shell of a protocol object so that we can return something back. *)
  currentSimulation = If[

    (* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
    (* and skipped resource packet generation. *)
    MatchQ[myProtocolPacket, $Failed],
    SimulateResources[
      <|
        Object -> protocolObject,
        Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
        Desiccator -> Resource[Instrument -> Lookup[myResolvedOptions, Desiccator], Time -> Lookup[myResolvedOptions, Time]],
        Desiccant -> If[
          NullQ[desiccant] || NullQ[desiccantAmount],
          Null,
          Resource[Sample -> desiccant, Container -> Model[Container, Vessel, "id:4pO6dMOxdbJM"], Amount -> desiccantAmount] (*Pyrex Crystallization Dish*)
        ],
        Replace[SampleContainers] -> sampleContainerResources,
        Replace[ContainersOut] -> containerOutResources,
        ResolvedOptions -> myResolvedOptions
      |>,
      Cache -> cache,
      Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]
    ],
    (* Otherwise, our resource packets went fine and we have an Object[Protocol, Desiccate]. *)
    SimulateResources[myProtocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
  ];

  (*If the sample is transferred from its input container to SampleContainer or ContainerOut, a new sample should be created*)
  (*Find out which inputs need new sample to be created*)

  (*Lookup inputContainers from samplePackets*)
  inputContainers = Download[Map[Lookup[#, Container]&, samplePackets], Object];

  simulatedProtocol = Download[protocolObject, Simulation -> currentSimulation];

  simulatedSampleContainer = Lookup[simulatedProtocol, SampleContainers];

  simulatedContainerOut = Lookup[simulatedProtocol, ContainersOut];

  (*needNewSampleQ is True when sample is transferred from input Container to newContainer (ampleContainer or ContainerOut)*)
  {needNewSampleQ, newContainer} =
      Transpose@MapThread[Which[
        (!MatchQ[#1, #3] && !NullQ[#3]), {True, #3},
        (!MatchQ[#1, #2] && !NullQ[#2]), {True, #2},
        True, {False, Null}]&, {inputContainers, simulatedSampleContainer, simulatedContainerOut}];

  (*pick samples that need to create newSample for, also pick newContainer for newSample*)
  {simulatedSourceSamples, destinationContainer, transferAmount} =
      PickList[#, needNewSampleQ]& /@ {mySamples, newContainer, amount};

  (*Add position "A1" to destination containers to create destination locations*)
  destinationLocation = {"A1", #}& /@ destinationContainer;

  (* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
  newSamplePackets = UploadSample[
    (*Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
    ConstantArray[{}, Length[simulatedSourceSamples]],
    destinationLocation,
    State -> ConstantArray[Solid, Length[simulatedSourceSamples]],
    InitialAmount -> ConstantArray[Null, Length[simulatedSourceSamples]],
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject,
    FastTrack -> True,
    Upload -> False
  ];

  (* update our simulation with new sample packets*)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSamplePackets]];

  (*Lookup Object[Sample]s from newSamplePackets*)
  simulatedNewSamples = DeleteDuplicates[Cases[Lookup[newSamplePackets, Object], ObjectReferenceP[Object[Sample]]]];

  (*figure out what are the SampleOut*)
  (*in mySamples, only keep samples when needNewSampleQ is False*)
  unchangedSamples = PickList[mySamples, needNewSampleQ, False];

  (*simulatedSamplesOut is the same as mySamples (input samples) if no new sample is generated (SampleContainer is Null for all samples).
  If new Sample is generated, the related input sample is substituted with the new generated sample*)
  simulatedSamplesOut = RiffleAlternatives[simulatedNewSamples, unchangedSamples, needNewSampleQ];

  (* Call UploadSampleTransfer on our source and destination samples. *)
  uploadSampleTransferPackets = UploadSampleTransfer[
    simulatedSourceSamples,
    simulatedNewSamples,
    transferAmount,
    Upload -> False,
    FastTrack -> True,
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject
  ];

  (*update our simulation with UploadSampleTransferPackets*)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

  (* Uploaded Labels *)
  simulationWithLabels = Simulation[
    Labels -> Join[
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
        {_String, ObjectP[]}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleOutLabel]], Flatten@simulatedSamplesOut}],
        {_String, ObjectP[]}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[myResolvedOptions, SampleContainer]}],
        {_String, ObjectP[]}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, ContainerOutLabel]], Lookup[myResolvedOptions, ContainerOut]}],
        {_String, ObjectP[]}
      ]
    ],
    LabelFields -> Join[
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
        {_String, _}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleOutLabel]], (Field[SampleOutLink[[#]]]&) /@ Range[Length[mySamples]]}],
        {_String, _}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleContainer[[#]]]&) /@ Range[Length[mySamples]]}],
        {_String, _}
      ],
      Rule @@@ Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, ContainerOutLabel]], (Field[ContainerOut[[#]]]&) /@ Range[Length[mySamples]]}],
        {_String, _}
      ]
    ]
  ];

  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[currentSimulation, simulationWithLabels]
  }
];

(* ::Subsection::Closed:: *)
(*Define Author for primitive head*)
Authors[Desiccate] := {"Mohamad.Zandian"};


(* ::Subsection::Closed:: *)
(*ExperimentDesiccateOptions*)


DefineOptions[ExperimentDesiccateOptions,
  Options :> {
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }

  },
  SharedOptions :> {ExperimentDesiccate}];

ExperimentDesiccateOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions,options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

  (* get only the options for ExperimentDesiccate *)
  options=ExperimentDesiccate[myInputs, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentDesiccate],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDesiccateQ*)


DefineOptions[ValidExperimentDesiccateQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentDesiccate}
];


ValidExperimentDesiccateQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, preparedOptions, experimentDesiccateTests, initialTestDescription, allTests, verbose, outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentDesiccate *)
  experimentDesiccateTests = ExperimentDesiccate[myInputs, Append[preparedOptions, Output -> Tests]];

  (* define the general test description *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* make a list of all the tests, including the blanket test *)
  allTests = If[MatchQ[experimentDesiccateTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {initialTest, validObjectBooleans, voqWarnings},

      (* generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* create warnings for invalid objects *)
      validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs],_String], OutputFormat -> Boolean];
      voqWarnings = MapThread[
        Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[ToList[myInputs],_String], validObjectBooleans}
      ];

      (* get all the tests/warnings *)
      Flatten[{initialTest, experimentDesiccateTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentDesiccateQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDesiccateQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentDesiccatePreview*)

DefineOptions[ExperimentDesiccatePreview,
  SharedOptions :> {ExperimentDesiccate}
];

ExperimentDesiccatePreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (* return only the options for ExperimentDesiccate *)
  ExperimentDesiccate[myInputs, Append[noOutputOptions, Output -> Preview]]];