(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(* Option Definitions *)

DefineOptions[ExperimentGrind,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> GrinderType,
        Default -> Automatic,
        Description -> "Method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard grinding balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
        ResolutionDescription -> "Automatically set to the type of the output of PreferredGrinder function.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> GrinderTypeP
        ]
      },
      {
        OptionName -> Instrument,
        Default -> Automatic,
        Description -> "The instrument that is used to grind the sample into a fine powder.",
        ResolutionDescription -> "Automatically determined by PreferredGrinder function.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Grinder], Object[Instrument, Grinder]}],
					OpenPaths->{
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Grinders"
						}
					}
        ]
      },
      {
        OptionName -> Amount,
        Default -> Automatic,
        Description -> "The mass of a sample to be ground into a fine powder.",
        ResolutionDescription -> "Automatically set to the minimum value for the specified grinder Instrument or All, whichever is less. If Instrument is not specified, Amount is automatically set to the minimum value of all grinders or All, which ever is less. Minimum value of a grinder is an estimated value which refers to the minimum of the sample that is ground efficiently by a specific grinder model.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "Mass" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Gram, $MaxTransferMass], Units -> Gram],
          "All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
        ]
      },
      {
        OptionName -> Fineness,
        Default -> 1 Millimeter,
        Description -> "The approximate size of the largest particle in a solid sample. Fineness, Amount, and BulkDensity are used to determine a suitable grinder Instrument using PreferredGrinder function if Instrument is not specified.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Millimeter],
          Units -> Millimeter
        ]
      },
      {
        OptionName -> BulkDensity,
        Default -> 1Gram / Milliliter,
        Description -> "The mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[0 Gram / Milliliter],
          Units -> CompoundUnit[{1, {Gram, {Milligram, Gram, Kilogram}}}, {-1, {Milliliter, {Microliter, Milliliter, Liter}}}]
        ]
      },
      {
        OptionName -> GrindingContainer,
        Default -> Automatic,
        Description -> "The container that the sample is transferred into for the grinding process. Refer to the Instrumentation Table for more information about the containers that are used for each model of grinders.",
        ResolutionDescription -> "Automatically set to a suitable container based on the selected grinder Instrument and Amount of the sample.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Container], Object[Container]}],
					OpenPaths->{
						{
							Object[Catalog, "Root"],
							"Containers",
							"Tubes & Vials"
						},
						{
							Object[Catalog, "Root"],
							"Containers",
							"Grinding Containers"
						}
					}
        ]
      },
      {
        OptionName -> GrindingBead,
        Default -> Automatic,
        Description -> "In ball mills, grinding beads or grinding balls are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result of rapid mechanical movements of the grinding container.",
        ResolutionDescription -> "Automatically set 2.8 mm stainless steel if GrinderType is set to BallMill.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Item, GrindingBead], Object[Item, GrindingBead]}],
					OpenPaths->{
						{
							Object[Catalog, "Root"],
							"Materials",
							"Grinding",
							"Grinding Beads"
						}
					}
        ]
      },
      {
        OptionName -> NumberOfGrindingBeads,
        Default -> Automatic,
        Description -> "In ball mills, determines how many grinding beads or grinding balls are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
        ResolutionDescription -> "Automatically set to a number of grinding beads that roughly have the same volume as the sample if GrinderType is set to BallMill. The number is estimated based on the estimated volume of the sample and diameter of the selected GrindingBead, considering 50% of packing void volume. When calculated automatically, NumberOfGrindingBeads will not be less than 1 or greater than 20.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterEqualP[1, 1]
        ]
      },
      {
        OptionName -> GrindingRate,
        Default -> Automatic,
        Description -> "Indicates the speed of the circular motion exerted by grinders to pulverize the samples into smaller powder particles.",
        ResolutionDescription -> "Automatically set to the default RPM for the selected grinder Instrument according to the values in the Instrumentation Table.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "RPM" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 RPM, 25000 RPM],
            Units -> RPM
          ],
          "Hertz" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Hertz, 420 Hertz],
            Units -> Hertz
          ]
        ]
      },
      {
        OptionName -> Time,
        Default -> Automatic,
        Description -> "Determines the duration for which the solid substance is ground into a fine powder in the grinder.",
        ResolutionDescription -> "Automatically set to a default value based on the Instrument selection according to Instrumentation Table.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {1, {Second, {Second, Minute, Hour}}}
        ]
      },
      {
        OptionName -> NumberOfGrindingSteps,
        Default -> Automatic,
        Description -> "Determines how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
        ResolutionDescription -> "Automatically set to 1 or determined based on the specified GrindingProfile Option.",
        AllowNull -> False,
        Category -> "Duty Cycle",
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1, 50, 1]
        ]
      },
      {
        OptionName -> CoolingTime,
        Default -> Automatic,
        Description -> "Determines the duration of time between each grinding step that the grinder is switched off to cool down the sample and prevent excessive rise in the sample's temperature.",
        ResolutionDescription -> "Automatically set to 30 Second if NumberOfGrindingSteps is greater than 1.",
        AllowNull -> True,
        Category -> "Duty Cycle",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute, $MaxExperimentTime],
          Units -> {1, {Second, {Second, Minute, Hour}}}
        ]
      },
      {
        OptionName -> GrindingProfile,
        Default -> Automatic,
        Description -> "A paired list of time and activities of the grinding process in the form of Activity (Grinding or Cooling), Duration, and GrindingRate.",
        ResolutionDescription -> "Automatically set to reflect the selections of GrindingRate, GrindingTime, NumberOfGrindingSteps, and CoolingTime.",
        AllowNull -> False,
        Category -> "Duty Cycle",
        Widget -> Adder[
          {
            "Activity" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Grinding , Cooling]],
            "Rate" -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, 25000 RPM], Units -> RPM],
            "Time" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> {1, {Second, {Second, Minute, Hour}}}]
          }
        ]
      },
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the samples that are being ground, for use in downstream unit operations.",
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
        OptionName -> SampleOutLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the sample collected at the end of the grinding step, for use in downstream unit operations.",
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
        Default -> Automatic,
        Description -> "The desired container that the generated ground samples should be transferred into after grinding.",
        ResolutionDescription -> "Automatically set to a preferred container based on the result of PreferredContainer function. PreferredContainer function returns the smallest model of ECL standardized container which is compatible with model and can hold the provided volume.",
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
        Description -> "A user defined word or phrase used to identify the ContainerOut that the sample is transferred into after the grinding step, for use in downstream unit operations.",
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
        (* Null indicates the storage conditions will be inherited from the model *)
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
(* ExperimentGrind Errors and Warnings *)
Warning::InsufficientAmount = "The specified amount `1` might be too small for efficient grinding of the sample by `2`. Please look at at the Instrumentation Table in the experiment help files to learn more about the amounts and feed fineness that grinders efficiently grind.";
Warning::ExcessiveAmount = "The specified amount `1` might be too much for efficient grinding of the sample by `2`.";
Error::LargeParticles = "The specified fineness of the sample(s) (`1`) is too large to be ground by `2`.";
Error::InvalidSampleAmounts = "The specified amount of sample(s) `1` are greater than the amount of the sample that is currently available.";
Error::GrinderTypeOptionMismatch = "The specified GrinderType(s) do not match the type(s) of the selected grinder(s) for sample(s) `1`.";
Error::HighGrindingRate = "The specified GrinderRate(s) are greater than the MaxGrindingRate of the specified grinder(s) for sample(s) `1`.";
Error::LowGrindingRate = "The specified GrinderRate(s) are smaller than the MinGrindingRate of the specified grinder(s) for sample(s) `1`.";
Error::HighGrindingTime = "The specified grinding Time(s) are greater than the maximum grinding time (MaxTime) that can be set by the timer of the specified grinder(s) for sample(s) `1`.";
Error::LowGrindingTime = "The specified grinding Time(s) are smaller than the minimum grinding time (MinTime) that can be set by the timer of the specified grinder(s) for sample(s) `1`.";
Warning::ModifiedNumberOfGrindingSteps = "The specified Number(s)OfGrindingSteps do not match the number of grinding steps that are specified in GrindingProfile for sample(s) `1`. NumberOfGrindingSteps is overwritten by the number of grinding steps determined by the GrindingProfile.";
Warning::ModifiedGrindingRates = "The specified GrindingRate(s) do not match to at least one of the grinding rate(s) that are specified in GrindingProfile for sample(s) `1`. GrindingRate is overwritten by grinding rates that are determined in the GrindingProfile.";
Warning::ModifiedGrindingTimes = "The specified grinding Time(s) do not match to at least one of the grinding time(s) that are specified in GrindingProfile for sample(s) `1`. Grinding Time is overwritten by grinding rates that are determined in the GrindingProfile.";
Warning::NonZeroCoolingRates = "At least one of the specified grinding rates(s) for the cooling steps in GrindingProfile is greater than 0 RPM for sample(s) `1`. Grinding the sample at cooling step might result in overheating the sample.";
Warning::ModifiedCoolingTimes = "The specified CoolingTime(s) do not match to at least one of the cooling time(s) that are specified in GrindingProfile for sample(s) `1`. CoolingTime is overwritten by cooling times that are determined in the GrindingProfile.";
Error::InvalidSamplesOutStorageCondition = "Storage conditions of the output sample(s) `1` are not informed. Please specify SampleOutStorageCondition in options or update the DefaultStorageCondition of the sample models.";
Warning::MissingMassInformation = "The sample(s) `1` are missing mass information. The MinAmount of the available grinders will be considered to calculate automatic options (MinAmount is minimum amount of the sample that is ground efficiently in a specific grinder).";


(* ::Subsection::Closed:: *)
(* ExperimentGrind *)

(* Mixed Input *)
ExperimentGrind[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
    sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
    mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = sanitizeInputs[ToList[myInputs], ToList[myOptions]];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult = Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
      ExperimentGrind,
      listedContainers,
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

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentGrind,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
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
        ExperimentGrind,
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
    ExperimentGrind[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];

(* Sample input/core overload*)
ExperimentGrind[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    listedSamples, listedOptions, outputSpecification, output, gatherTests,
    validSamplePreparationResult, samplesWithPreparedSamples,
    optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests,
    templatedOptions, templateTests, inheritedOptions, cacheLessInheritedOptions, expandedSafeOps, packetObjectSample,
    preferredContainers, containerObjects, containerModels, instrumentOption,
    instrumentModels, instrumentObjects, grindingBeads, grindingContainers,
    allObjects, allInstruments, allContainers, objectSampleFields,
    modelSampleFields, modelContainerFields, objectContainerFields,
    result, postProcessingOptions, updatedSimulation, upload, confirm, fastTrack,
    parentProtocol, cache, downloadedStuff, cacheBall, resolvedOptionsResult,
    resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
    performSimulationQ, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
    protocolPacketWithResources, resourcePacketTests, safeOptionsNamed, allContainerModels,
    allGrindingBeadModels, simulatedProtocol, simulation, grinderClampAssemblyModels, grinderClampAssemblyObjects,
    grinderTubeHolderModels, grinderTubeHolderObjects, grindingBeadObjects, optionsResolverOnly,
    returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ
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
      ExperimentGrind,
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
    SafeOptions[ExperimentGrind, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentGrind, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
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
    ValidInputLengthsQ[ExperimentGrind, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentGrind, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
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
    ApplyTemplateOptions[ExperimentGrind, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentGrind, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
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
  cacheLessInheritedOptions = KeyDrop[inheritedOptions, {Cache, Simulation}];

  (* get assorted hidden options *)
  {upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentGrind, {samplesWithPreparedSamples}, inheritedOptions]];

  (* --- Search for and Download all the information we need for resolver and resource packets function --- *)
  (* do a huge search to get everything we could need *)

  {
    instrumentModels,
    instrumentObjects,
    grindingContainers,
    grindingBeads,
    grinderTubeHolderModels,
    grinderTubeHolderObjects,
    grinderClampAssemblyModels,
    grinderClampAssemblyObjects
  } = Search[
    {
      {Model[Instrument, Grinder]},
      {Object[Instrument, Grinder]},
      {Model[Container, GrindingContainer]},
      {Model[Item,GrindingBead]},
      {Model[Container, GrinderTubeHolder]},
      {Object[Container, GrinderTubeHolder]},
      {Model[Part, GrinderClampAssembly]},
      {Object[Part, GrinderClampAssembly]}
    },
    {
      DeveloperObject != True && Deprecated != True,
      Status != UndergoingMaintenance && Status != Retired,
      DeveloperObject != True && Deprecated != True,
      DeveloperObject != True && Deprecated != True,
      DeveloperObject != True && Deprecated != True,
      DeveloperObject != True && Status == (Available | Stocked),
      DeveloperObject != True && Deprecated != True,
      DeveloperObject != True && Status == (Available | Stocked)
    }
  ];

  (* all possible containers that the resolver might use*)
  preferredContainers = DeleteDuplicates[
    Flatten[{
      PreferredContainer[All, Type -> Vessel],
      PreferredContainer[All, LightSensitive -> True, Type -> Vessel]
    }]
  ];

  (* any container the user provided (in case it's not on the PreferredContainer list) *)
  containerObjects = DeleteDuplicates[Cases[
    Flatten[Lookup[expandedSafeOps, {GrindingContainer, ContainerOut}]],
    ObjectP[Object]
  ]];
  containerModels = DeleteDuplicates[Cases[
    Flatten[{Lookup[expandedSafeOps, {GrindingContainer, ContainerOut}], Model[Container, Vessel, "id:pZx9jo8o0wEP"(*2mL tube with no skirt*)](*TODO change this hardcoded model, probably by changing preferredGrindingContainer function*)}],
    ObjectP[Model]
  ]];

  (* gather the instrument option *)
  instrumentOption = Lookup[expandedSafeOps, Instrument];

  (* pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
  instrumentObjects = Cases[Flatten[{instrumentOption}], ObjectP[Object[Instrument]]];

  (* split things into groups by types (since we'll be downloading different things from different types of objects) *)
  allObjects = DeleteDuplicates[Flatten[{
    instrumentModels, instrumentObjects,
    grindingContainers, grindingBeads,
    preferredContainers, containerModels, containerObjects
  }]];
  allInstruments = Cases[allObjects, ObjectP[{Model[Instrument], Object[Instrument]}]];
  allContainerModels = Flatten[{
    Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, GrindingContainer]}]],
    Cases[cacheLessInheritedOptions, ObjectReferenceP[{Model[Container]}], Infinity]
  }];
  allContainers = Flatten[{Cases[cacheLessInheritedOptions, ObjectReferenceP[Object[Container]], Infinity]}];

  allGrindingBeadModels = Flatten[{
    Cases[allObjects, ObjectP[Model[Item, GrindingBead]]],
    Cases[cacheLessInheritedOptions, ObjectReferenceP[Model[Item, GrindingBead]], Infinity]
  }];

  grindingBeadObjects = Flatten[{
    Cases[allObjects, ObjectP[Object[Item, GrindingBead]]],
    Cases[cacheLessInheritedOptions, ObjectReferenceP[Object[Item, GrindingBead]], Infinity]
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

  (* download all the things *)
  downloadedStuff = Quiet[
    Download[
      {
        (*1*)samplesWithPreparedSamples,
        (*2*)instrumentModels,
        (*3*)instrumentObjects,
        (*4*)allContainerModels,
        (*5*)allContainers,
        (*6*)allGrindingBeadModels,
        (*7*)grinderTubeHolderModels,
        (*8*)grinderTubeHolderObjects,
        (*9*)grinderClampAssemblyModels,
        (*10*)grinderClampAssemblyObjects,
        (*11*)grindingBeadObjects
      },
      Evaluate[
        {
          (*1*)packetObjectSample,
          (*2*){Packet[Name, GrinderType, Objects, MinAmount, MaxAmount, MinTime, MaxTime, FeedFineness, MaxGrindingRate, MinGrindingRate]},
          (*3*){Packet[Name, GrinderType, Model, MinAmount, MaxAmount, MinTime, MaxTime, FeedFineness, MaxGrindingRate, MinGrindingRate]},
          (*4*){Evaluate[Packet @@ modelContainerFields]},

          (* all basic container models (from PreferredContainers) *)
          (*5*){
          Evaluate[Packet @@ objectContainerFields],
          Packet[Model[modelContainerFields]]
        },
          (*6*){Packet[Diameter]},
          (*7*){Packet[Positions, SupportedInstruments]},
          (*8*){Packet[Model]},
          (*9*){Packet[Object, SupportedInstruments]},
          (*10*){Packet[Model]},
          (*11*){Packet[Diameter]}
        }
      ],
      Cache -> cache,
      Simulation -> updatedSimulation,
      Date -> Now
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* get all the cache and put it together *)
  cacheBall = FlattenCachePackets[{cache, downloadedStuff}];

  (* Build the resolved options *)
  resolvedOptionsResult = Check[
    {resolvedOptions, resolvedOptionsTests} = If[gatherTests,
      resolveExperimentGrindOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
      {resolveExperimentGrindOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentGrind,
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
      Options -> RemoveHiddenOptions[ExperimentGrind, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {protocolPacketWithResources, resourcePacketTests} = Which[
    returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
      {$Failed, {}},
    gatherTests,
      grindResourcePackets[
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
        grindResourcePackets[
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
    simulateExperimentGrind[
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
      Options -> RemoveHiddenOptions[ExperimentGrind, collapsedResolvedOptions],
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
    MatchQ[protocolPacketWithResources, $Failed],
    $Failed,

    (* If we're in global script simulation mode and are Preparation->Manual (preparation is always manual for Grind), we want to upload our simulation to the global simulation. *)
    MatchQ[$CurrentSimulation, SimulationP],
    Module[{},
      UpdateSimulation[$CurrentSimulation, simulation],

      If[MatchQ[Lookup[safeOps, Upload], False],
        Lookup[simulation[[1]], Packets],
        simulatedProtocol
      ]
    ],

    (* Actually upload our protocol object. We are being called as a sub-prootcol in ExperimentManualSamplePreparation. *)
    True,
    UploadProtocol[
      protocolPacketWithResources[[1]], (*protocol packet*)
      ToList[protocolPacketWithResources[[2]]], (*unit operation packets*)
      Upload -> Lookup[safeOps, Upload],
      Confirm -> Lookup[safeOps, Confirm],
      ParentProtocol -> Lookup[safeOps, ParentProtocol],
      Priority -> Lookup[safeOps, Priority],
      StartDate -> Lookup[safeOps, StartDate],
      HoldOrder -> Lookup[safeOps, HoldOrder],
      QueuePosition -> Lookup[safeOps, QueuePosition],
      ConstellationMessage -> {Object[Protocol, Grind]},
      Cache -> cacheBall,
      Simulation -> updatedSimulation
    ]
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> result,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentGrind, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation
  }
];

(* ::Subsection::Closed:: *)
(*resolveExperimentGrindOptions*)

DefineOptions[
  resolveExperimentGrindOptions,
  Options :> {HelperOutputOption, SimulationOption, CacheOption}
];

resolveExperimentGrindOptions[myInputSamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentGrindOptions]] := Module[
  {
    outputSpecification, output, gatherTests, cache, simulation, samplePrepOptions, grindOptions, simulatedSamples, ballMills,
    knifeMills, grinderMinAmount, resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, samplePackets, modelPackets,
    sampleContainerPacketsWithNulls, sampleContainerModelPacketsWithNulls, mortarGrinders, cacheBall, sampleDownloads,
    fastAssoc, grinderModelPackets, grinderModels, absoluteMinGrinderVolume, maxFeedFineness, sampleContainerModelPackets,
    sampleContainerPackets, messages, discardedSamplePackets, discardedInvalidInputs, discardedTest,
    mapThreadFriendlyOptions, grindOptionAssociation, optionPrecisions, roundedGrindOptions, precisionTests,
    nonSolidSamplePackets, nonSolidSampleInvalidInputs, nonSolidSampleTest, spmGrindingRate, missingMassSamplePackets,
    missingMassInvalidInputs, missingMassTest, preparationResult, allowedPreparation, preparationTest,
    resolvedTime, resolvedAmount, resolvedFineness, resolvedBulkDensity, resolvedSampleLabel, resolvedContainerOut,
    resolvedSamplesOutStorageCondition, resolvedGrinderType, resolvedInstrument, resolvedGrindingRate,
    resolvedNumberOfGrindingSteps, resolvedCoolingTime, resolvedGrindingProfile, resolvedSampleOutLabel,
    resolvedContainerOutLabel, optionRateAndTimePrecisions, grindingRateAndTime, rateAndTimePrecisionTests,
    roundedRateAndTime, resolvedOptions, resolvedGrindingContainer, resolvedGrindingBead, resolvedNumberOfGrindingBeads,
    invalidSampleFineness, invalidSamplesFineness, finenessInvalidOption, invalidSampleFinenessTest, invalidAmountOption,
    invalidSampleAmount, invalidSampleAmounts, invalidSampleAmountTest, grinderTypeMismatch, grinderTypeMismatches,
    grinderTypeMismatchOption, grindTypeMismatchTest, highGrindingRate, highGrindingRates, highGrindingRateOption,
    highGrindingRateTest, lowGrindingRate, lowGrindingRates, lowGrindingRateOption, lowGrindingRateTest, highGrindingTime,
    highGrindingTimes, highGrindingTimeOption, highGrindingTimeTest, lowGrindingTime, lowGrindingTimes,
    lowGrindingTimeOption, lowGrindingTimeTest, initialGrindingProfile, containerOutLabel, sampleOutLabel,
    profileGrindingSteps, changedNumberOfGrindingSteps, changedNumbersOfGrindingSteps, changedNumberOfGrindingStepsOption,
    changedNumberOfGrindingStepsTest, rateChangedQ, changedRate, changedRates, changedRateOption, changedRateTest,
    timeChangedQ, changedTime, changedTimes, changedTimeOption, changedTimeTest, profileCoolingSteps, nonZeroCoolingRateQ,
    nonZeroCoolingRate, changedCoolingTime, coolingTimeChangedQ, nonZeroCoolingRates, nonZeroCoolingRateOption,
    nonZeroCoolingRateTest, changedCoolingTimes, changedCoolingTimeOption, changedCoolingTimeTest, rateUnitChanged,
    rateUnitsChanged, defaultGrindingBead, grindingBeadModels, invalidSamplesOutStorageConditions,
    invalidSamplesOutStorageConditionsOptions, invalidSamplesOutStorageConditionsTest, resolvedPostProcessingOptions,
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

  (* Separate out our Grind options from our Sample Prep options. *)
  {samplePrepOptions, grindOptions} = splitPrepOptions[myOptions];

  (* Resolve our sample prep options (only if the sample prep option is not true) *)
  {{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentGrind, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
    {resolveSamplePrepOptionsNew[ExperimentGrind, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
  ];


  (* Extract the packets that we need from our downloaded cache. *)
  (* need to do this even if we have caching because of the simulation stuff *)
  sampleDownloads = Quiet[Download[
    simulatedSamples,
    {
      Packet[Name, Volume, Mass, State, Status, Container, LiquidHandlerIncompatible, Solvent, Position, Model],
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

  (* determine what is the absolute minimum amount of sample that can efficiently be ground *)
  (* list of grinder models. Models are duplicate: Model[Instrument, Grinder, "name"] and Model[Instrument, Grinder, "ID" *)
  grinderModels = Cases[Keys[fastAssoc], ObjectP[Model[Instrument, Grinder]]];

  (*list of packets of grinder models*)
  grinderModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ grinderModels;

  (*list of packets of BallMill models*)
  ballMills = Select[grinderModelPackets, MatchQ[Lookup[#, GrinderType], BallMill]&];

  (*list of packets of KnifeMill models*)
  knifeMills = Select[grinderModelPackets, MatchQ[Lookup[#, GrinderType], KnifeMill]&];

  (*list of packets of MortarGrinder models*)
  mortarGrinders = Select[grinderModelPackets, MatchQ[Lookup[#, GrinderType], MortarGrinder]&];

  (*MinAmount of each grinder type*)
  grinderMinAmount = {BallMill -> Min[Lookup[ballMills, MinAmount]], KnifeMill -> Min[Lookup[knifeMills, MinAmount]], MortarGrinder -> Min[Lookup[mortarGrinders, MinAmount]]};

  (*MinAmount of all grinders*)
  absoluteMinGrinderVolume = Min[(fastAssocLookup[fastAssoc, #, MinAmount]& /@ grinderModels)];

  (* determine maxFeedFineness *)
  maxFeedFineness = Max[(fastAssocLookup[fastAssoc, #, FeedFineness]& /@ grinderModels)];

  (* Get the downloaded mess into a usable form *)
  {
    samplePackets,
    modelPackets,
    sampleContainerPacketsWithNulls,
    sampleContainerModelPacketsWithNulls
  } = Transpose[sampleDownloads];

  (* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
			Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
  sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls, {Null -> {}}, 1];
  sampleContainerPackets = Replace[sampleContainerPacketsWithNulls, {Null -> {}}, 1];

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

  (*NOTE: MAKE SURE THE SAMPLES ARE SOLID*)
  (*Get the samples that are not solids,cannot grind those*)
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
  missingMassSamplePackets = Select[samplePackets, NullQ[Lookup[#, Mass]]&];

  (* Keep track of samples that do not have mass but are a solid *)
  missingMassInvalidInputs = Lookup[missingMassSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages,do so *)
  If[Length[missingMassInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::MissingMassInformation, ObjectToString[missingMassInvalidInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
  missingMassTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[missingMassInvalidInputs] == 0,
        Nothing,
        Warning["Input samples " <> ObjectToString[missingMassInvalidInputs, Cache -> cacheBall] <> " contain mass information:", True, False]
      ];

      passingTest = If[Length[missingMassInvalidInputs] == Length[myInputSamples],
        Nothing,
        Warning["Input samples " <> ObjectToString[Complement[myInputSamples, missingMassInvalidInputs], Cache -> cacheBall] <> " contain mass information:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*-- OPTION PRECISION CHECKS --*)

  (* Convert list of rules to Association so we can Lookup,Append,Join as usual. *)
  grindOptionAssociation = Association[grindOptions];

  (* Define the options and associated precisions that we need to check *)
  optionPrecisions = {
    {Amount, 10^-3 Gram},
    (* GrindingRate and Time will be rounded for each sample based on the selected Instrument *)
    {CoolingTime, 10^0 Second}
  };

  (* round values for options based on option precisions *)
  {roundedGrindOptions, precisionTests} = If[gatherTests,
    RoundOptionPrecision[grindOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    {RoundOptionPrecision[grindOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], Null}
  ];

  (* -- RESOLVE INDEX-MATCHED OPTIONS *)

  (* NOTE: MAPPING*)
  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentGrind, roundedGrindOptions];

  (* big MapThread to get all the options resolved *)
  {
    (*1*)resolvedGrinderType,
    (*2*)resolvedInstrument,
    (*3*)resolvedAmount,
    (*4*)resolvedFineness,
    (*5*)resolvedBulkDensity,
    (*6*)resolvedGrindingContainer,
    (*7*)resolvedGrindingBead,
    (*8*)resolvedNumberOfGrindingBeads,
    (*9*)resolvedGrindingRate,
    (*10*)resolvedTime,
    (*11*)resolvedNumberOfGrindingSteps,
    (*12*)resolvedCoolingTime,
    (*13*)resolvedGrindingProfile,
    (*14*)resolvedSampleLabel,
    (*15*)resolvedSampleOutLabel,
    (*16*)resolvedContainerOut,
    (*17*)resolvedContainerOutLabel,
    (*18*)resolvedSamplesOutStorageCondition,
    (*19*)rateUnitsChanged,
    (*20*)invalidSamplesFineness,
    (*21*)invalidSampleAmounts,
    (*22*)grinderTypeMismatches,
    (*23*)highGrindingRates,
    (*24*)lowGrindingRates,
    (*25*)highGrindingTimes,
    (*26*)lowGrindingTimes,
    (*27*)changedNumbersOfGrindingSteps,
    (*28*)changedRates,
    (*29*)changedTimes,
    (*30*)nonZeroCoolingRates,
    (*31*)changedCoolingTimes,
    (*32*)invalidSamplesOutStorageConditions
  } = Transpose[
    MapThread[
      Function[{samplePacket, modelPacket, options, sampleContainerPacket, sampleContainerModelPacket},
        Module[
          {
            unresolvedGrinderType, grinderType,
            unresolvedInstrument, instrument, instrumentModel,
            unresolvedGrindingRate, grindingRate, specifiedRate,
            preferredUnitGrindingRate, optimalGrindingRate, ratePrecision,
            hertzQ, mortarQ, tubeMillQ, mm400Q, beadGenieQ, beadBug3Q,
            unresolvedFineness, unresolvedBulkDensity,
            unresolvedAmount, amount, numericAmount,
            unresolvedTime, time, optimalTime, timePrecision, specifiedTime,
            unresolvedContainerOut, containerOut, numericAll,
            unresolvedSampleLabel, sampleLabel, unresolvedSampleOutLabel,
            unresolvedContainerOutLabel, preferredGrinderOptions,
            unresolvedOptions, unresolvedSamplesOutStorageCondition,
            invalidSamplesOutStorageCondition,
            unresolvedNumberOfGrindingSteps, numberOfGrindingSteps,
            unresolvedCoolingTime, coolingTime,
            unresolvedGrindingProfile, grindingProfile,
            unresolvedGrindingContainer, grindingContainer,
            unresolvedGrindingBead, grindingBead,
            unresolvedNumberOfGrindingBeads, numberOfGrindingBeads, calculatedNumberOfGrindingBeads
          },

          (* error checking variables *)
          {
            invalidSampleFineness,
            invalidSampleAmount,
            grinderTypeMismatch,
            rateUnitChanged,
            invalidSamplesOutStorageCondition
          } = {
            False,
            False,
            False,
            False,
            False
          };

          (* pull out all the relevant unresolved options*)
          {
            (*1*)unresolvedGrinderType,
            (*2*)unresolvedInstrument,
            (*3*)unresolvedAmount,
            (*4*)unresolvedFineness,
            (*5*)unresolvedBulkDensity,
            (*6*)unresolvedGrindingContainer,
            (*7*)unresolvedGrindingBead,
            (*8*)unresolvedNumberOfGrindingBeads,
            (*9*)unresolvedGrindingRate,
            (*10*)unresolvedTime,
            (*11*)unresolvedNumberOfGrindingSteps,
            (*12*)unresolvedCoolingTime,
            (*13*)unresolvedGrindingProfile,
            (*14*)unresolvedSampleLabel,
            (*15*)unresolvedSampleOutLabel,
            (*16*)unresolvedContainerOut,
            (*17*)unresolvedContainerOutLabel,
            (*18*)unresolvedSamplesOutStorageCondition
          } = Lookup[
            options,
            {
              (*1*)GrinderType,
              (*2*)Instrument,
              (*3*)Amount,
              (*4*)Fineness,
              (*5*)BulkDensity,
              (*6*)GrindingContainer,
              (*7*)GrindingBead,
              (*8*)NumberOfGrindingBeads,
              (*9*)GrindingRate,
              (*10*)Time,
              (*11*)NumberOfGrindingSteps,
              (*12*)CoolingTime,
              (*13*)GrindingProfile,
              (*14*)SampleLabel,
              (*15*)SampleOutLabel,
              (*16*)ContainerOut,
              (*17*)ContainerOutLabel,
              (*18*)SamplesOutStorageCondition
            }
          ];

          (* --- Resolve IndexMatched Options --- *)

          (* Fineness; Default=1 Millimeter, Null not allowed. *)
          (* Throw an error if the specified Fineness is greater than the maximum fineness that can be handled at ECL *)
          invalidSampleFineness = GreaterQ[unresolvedFineness, maxFeedFineness];

          (*resolve BulkDensity: Default:1g/mL, AllowNull:False, no need to resolve*)

          (*For healthy functioning of PreferredGrinder, Convert All to Mass if Amount->All. if the sample does not have mass information, the minimum required amount of the sample is considered for automatic option resolutions*)
          numericAll = If[
            NullQ[Lookup[samplePacket, Mass]],
            UnitSimplify[absoluteMinGrinderVolume * unresolvedBulkDensity],
            Lookup[samplePacket, Mass]
          ];

          numericAmount = If[MatchQ[unresolvedAmount, All], numericAll, unresolvedAmount];

          (* GrinderType, Instrument and Amount depend on each other, so they are resolved together*)
          unresolvedOptions = {unresolvedGrinderType, unresolvedInstrument, unresolvedAmount};

          preferredGrinderOptions = {GrinderType -> unresolvedGrinderType, Fineness -> unresolvedFineness, BulkDensity -> unresolvedBulkDensity};

          {grinderType, instrument, amount} = Which[
            MatchQ[unresolvedOptions, {Except[Automatic], Except[Automatic], Except[Automatic]}],
            {unresolvedGrinderType, unresolvedInstrument, numericAmount},

            MatchQ[unresolvedOptions, {Automatic, Except[Automatic], Except[Automatic]}],
            {fastAssocLookup[fastAssoc, unresolvedInstrument, GrinderType], unresolvedInstrument, numericAmount},

            MatchQ[unresolvedOptions, {Except[Automatic], Automatic, Except[Automatic]}],
            {
              unresolvedGrinderType,
              PreferredGrinder[numericAmount, preferredGrinderOptions],
              numericAmount
            },

            MatchQ[unresolvedOptions, {Except[Automatic], Except[Automatic], Automatic}],
            {unresolvedGrinderType, unresolvedInstrument, UnitSimplify[fastAssocLookup[fastAssoc, unresolvedInstrument, MinAmount] * unresolvedBulkDensity]},

            MatchQ[unresolvedOptions, {Automatic, Automatic, Except[Automatic]}],
            With[{preferredGrinder = PreferredGrinder[numericAmount, preferredGrinderOptions]},
              {
                fastAssocLookup[fastAssoc, preferredGrinder, GrinderType],
                preferredGrinder,
                numericAmount
              }
            ],

            MatchQ[unresolvedOptions, {Automatic, Except[Automatic], Automatic}],
            {
              fastAssocLookup[fastAssoc, unresolvedInstrument, GrinderType],
              unresolvedInstrument,
              Min[UnitSimplify[fastAssocLookup[fastAssoc, unresolvedInstrument, MinAmount] * unresolvedBulkDensity], numericAll]
            },

            MatchQ[unresolvedOptions, {Except[Automatic], Automatic, Automatic}],
            {
              unresolvedGrinderType,
              PreferredGrinder[Min[UnitSimplify[Lookup[grinderMinAmount, unresolvedGrinderType] * unresolvedBulkDensity], numericAll], preferredGrinderOptions],
              Min[UnitSimplify[Lookup[grinderMinAmount, unresolvedGrinderType] * unresolvedBulkDensity], numericAll]
            },

            MatchQ[unresolvedOptions, {Automatic, Automatic, Automatic}],
            With[{preferredGrinder = PreferredGrinder[absoluteMinGrinderVolume, preferredGrinderOptions]},
              {
                fastAssocLookup[fastAssoc, preferredGrinder, GrinderType],
                preferredGrinder,
                Min[UnitSimplify[absoluteMinGrinderVolume * unresolvedBulkDensity], numericAll]
              }
            ]
          ];

          (* Throw an error if the specified Amount is greater than the total available mass of the sample *)
          invalidSampleAmount = GreaterQ[amount, Lookup[samplePacket, Mass]];

          (* Throw and error if the specified GrinderType and the grinder Instrument do not match *)
          grinderTypeMismatch = MatchQ[instrument, ObjectP[]] && Not[MatchQ[grinderType, fastAssocLookup[fastAssoc, instrument, GrinderType]]];

          grindingContainer = If[
            MatchQ[unresolvedGrindingContainer, Except[Automatic]],
            unresolvedGrindingContainer,
            PreferredGrindingContainer[instrument, amount, unresolvedBulkDensity]
          ];

          (*resolve GrindingBead*)
          (*extract all grinding beads from fastAssoc*)
          grindingBeadModels = Cases[fastAssoc, ObjectP[Model[Item, GrindingBead]]];

          (*find the first model of grinding bead with a diameter of 2.8 mm and lookup its object*)
          defaultGrindingBead = Lookup[FirstCase[grindingBeadModels, KeyValuePattern[Diameter -> 2.8Millimeter]], Object];

          (*resolve GrindingBead*)
          grindingBead = Which[
            MatchQ[unresolvedGrindingBead, Except[Automatic]],
            unresolvedGrindingBead,
            MatchQ[unresolvedGrindingBead, Automatic] && MatchQ[grinderType, BallMill],
            defaultGrindingBead,
            True, Null
          ];

          (*resolve GrindingBead*)
          numberOfGrindingBeads = Which[
            MatchQ[unresolvedNumberOfGrindingBeads, Except[Automatic]],
            unresolvedNumberOfGrindingBeads,
            MatchQ[unresolvedNumberOfGrindingBeads, Automatic] && MatchQ[grinderType, BallMill],
            (*Calculate sample volume, then estimate number of required beads, considering 50% void volume*)
            (*the calculated number is then rounded to an integer.*)
            calculatedNumberOfGrindingBeads = Round[UnitSimplify[
              (0.5 * (amount) / (unresolvedBulkDensity)) / ((4 / 3) * Pi * (fastAssocLookup[fastAssoc, grindingBead, Diameter] / 2)^3)]
            ];
            (*If the final integer is less than 2, 2 is returned. If the final integer is greater than 20, 20 is returned.*)
            Max[1, Min[20, calculatedNumberOfGrindingBeads]],
            True, Null
          ];

          (* Round GrindingRate and Time based on the selected grinder Instrument *)
          (* Hertz and RPM are not compatible units *)
          (* Extract GrindingRate and GrindingRate unit *)
          hertzQ = FrequencyQ[unresolvedGrindingRate];

          (*lookup instrument models*)
          instrumentModel = If[
            MatchQ[instrument, ObjectP[Model[Instrument, Grinder]]],
            instrument,
            fastAssocLookup[fastAssoc, instrument, Model]];

          (* Determine the model of the selected grinder *)
          beadBug3Q = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]];

          beadGenieQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]];

          mm400Q = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]]];

          tubeMillQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:zGj91ajA6LYO"]]];

          mortarQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]];

          (* The following code block converts GrindingRate to the instrument unit: RPM for BeadBug3, AutomatedMortarGrinder, and TubeMillControl;*)
          (* Hertz for MixerMill MM400; StrokesPerMinute for BeadGenie (1 RPM=2 StrokesPerMinute) *)
          (* Additionally, the following block determines sets the optimalGrindingRate, ratePrecision, optimalTime, and timePrecision. *)
          {{preferredUnitGrindingRate, rateUnitChanged}, optimalGrindingRate, ratePrecision, optimalTime, timePrecision} = Which[
            beadBug3Q, {If[
              hertzQ,
              {Quantity[QuantityMagnitude[unresolvedGrindingRate] * 60, "RPM"], True},
              {unresolvedGrindingRate, False}
            ], 2800 RPM, {GrindingRate, 100 RPM}, 10 Second, {Time, 10^0 Second}},

            beadGenieQ, {Which[
              hertzQ,
              {Quantity[QuantityMagnitude[unresolvedGrindingRate] * 120, IndependentUnit["StrokesPerMinute"]], True},
              RPMQ[unresolvedGrindingRate], {Quantity[QuantityMagnitude[unresolvedGrindingRate] * 2, IndependentUnit["StrokesPerMinute"]], True},
              True, {unresolvedGrindingRate, False}
            ], Quantity[4000, IndependentUnit["StrokesPerMinute"]], {GrindingRate, Quantity[10, IndependentUnit["StrokesPerMinute"]]}, 30 Second, {Time, 10^0 Second}},

            mm400Q, {Which[
              hertzQ, {unresolvedGrindingRate, False},
              RPMQ[unresolvedGrindingRate], {Quantity[QuantityMagnitude[unresolvedGrindingRate] / 60, "Hertz"], True},
              True, {unresolvedGrindingRate, False}
            ], 20 Hertz, {GrindingRate, 0.1 Hertz}, 30 Second, {Time, 10^0 Second}},

            tubeMillQ, {If[
              hertzQ,
              {Quantity[QuantityMagnitude[unresolvedGrindingRate] * 60, "RPM"], True},
              {unresolvedGrindingRate, False}
            ], 5000 RPM, {GrindingRate, 100 RPM}, 15 Second, {Time, 5 Second}},

            mortarQ, {If[
              hertzQ,
              {Quantity[QuantityMagnitude[unresolvedGrindingRate] * 60, "RPM"], True},
              {unresolvedGrindingRate, False}
            ], 70 RPM, {GrindingRate, 10 RPM}, 60 Minute, {Time, 10^0 Minute}},
            MatchQ[instrument, $Failed], {{unresolvedGrindingRate, False}, Null, {GrindingRate, 0 RPM}, Null, {Time, 0 Second}}
          ];


          (* round values for options based on option precisions *)
          (* Extract GrindingRate and Time from options *)
          grindingRateAndTime = <|GrindingRate -> preferredUnitGrindingRate, Time -> unresolvedTime|>;

          (* round GrindingRate and Time *)
          optionRateAndTimePrecisions = {ratePrecision, timePrecision};
          {roundedRateAndTime, rateAndTimePrecisionTests} = If[gatherTests,
            RoundOptionPrecision[grindingRateAndTime, optionRateAndTimePrecisions[[All, 1]], optionRateAndTimePrecisions[[All, 2]], Output -> {Result, Tests}],
            {RoundOptionPrecision[grindingRateAndTime, optionRateAndTimePrecisions[[All, 1]], optionRateAndTimePrecisions[[All, 2]]], Null}
          ];

          specifiedRate = Lookup[roundedRateAndTime, GrindingRate];
          specifiedTime = Lookup[roundedRateAndTime, Time];

          (*Resolve GrindingRate*)
          spmGrindingRate = Which[
            MatchQ[specifiedRate, Except[Automatic]],
            specifiedRate,
            MatchQ[specifiedRate, Automatic],
            optimalGrindingRate
          ];

          (*Unit "StrokesPerMinute" is not acceptable at ECL yet. Therefore, change spm back to RPM*)
          grindingRate = If[MatchQ[QuantityUnit[spmGrindingRate], IndependentUnit["StrokesPerMinute"]],
            Quantity[QuantityMagnitude[spmGrindingRate] / 2, RPM], spmGrindingRate
          ];

          (* Throw an error if the specified rate is greater than the max rate of the selected grinder *)
          highGrindingRate = Which[
            RPMQ[grindingRate] && grindingRate > fastAssocLookup[fastAssoc, instrument, MaxGrindingRate], True,
            FrequencyQ[grindingRate] && Quantity[QuantityMagnitude[grindingRate] * 60, "RPM"] > fastAssocLookup[fastAssoc, instrument, MaxGrindingRate], True,
            MatchQ[QuantityUnit[grindingRate], IndependentUnit["StrokesPerMinute"]] && Quantity[QuantityMagnitude[grindingRate] / 2, "RPM"] > fastAssocLookup[fastAssoc, instrument, MaxGrindingRate], True,
            True, False
          ];

          (* Throw an error if the specified rate is smaller than the min rate of the selected grinder *)
          lowGrindingRate = Which[
            RPMQ[grindingRate] && grindingRate < fastAssocLookup[fastAssoc, instrument, MinGrindingRate], True,
            FrequencyQ[grindingRate] && Quantity[QuantityMagnitude[grindingRate] * 60, "RPM"] < fastAssocLookup[fastAssoc, instrument, MinGrindingRate], True,
            MatchQ[QuantityUnit[grindingRate], IndependentUnit["StrokesPerMinute"]] && Quantity[QuantityMagnitude[grindingRate] / 2, "RPM"] < fastAssocLookup[fastAssoc, instrument, MinGrindingRate], True,
            True, False
          ];


          (* Resolve Time *)
          time = Which[
            MatchQ[specifiedTime, Except[Automatic]],
            specifiedTime,
            MatchQ[specifiedTime, Automatic],
            optimalTime
          ];

          (* Throw an error if the specified Time is greater than the max grinding time of the selected grinder *)
          highGrindingTime = If[
            time > fastAssocLookup[fastAssoc, instrument, MaxTime],
            True,
            False
          ];

          (* Throw an error if the specified Time is smaller than the min grinding time of the selected grinder *)
          lowGrindingTime = If[
            time < fastAssocLookup[fastAssoc, instrument, MinTime],
            True,
            False
          ];

          (* NumberOfGrindingSteps, AllowNull:False *)
          numberOfGrindingSteps = Which[
            MatchQ[unresolvedNumberOfGrindingSteps, Except[Automatic]],
            unresolvedNumberOfGrindingSteps,
            MatchQ[unresolvedGrindingProfile, Except[Automatic]],
            Count[Flatten[unresolvedGrindingProfile], Grinding],
            MatchQ[unresolvedNumberOfGrindingSteps, Automatic],
            1
          ];

          (* CoolingTime *)
          coolingTime = Which[
            MatchQ[unresolvedCoolingTime, Except[Automatic]], unresolvedCoolingTime,
            MatchQ[unresolvedCoolingTime, Automatic] && GreaterQ[numberOfGrindingSteps, 1], 30 Second,
            True, Null
          ];

          (*GrindingProfile*)
          grindingProfile = If[
            MatchQ[unresolvedGrindingProfile, Except[Automatic]],
            unresolvedGrindingProfile,
            Most[Join @@ ConstantArray[{{Grinding, grindingRate, time}, {Cooling, 0 RPM, coolingTime}}, numberOfGrindingSteps]]
          ];

          (* Throw a warning if the specified GrindingRate, Time, and number of steps are different from specified GrindingProfile *)
          (* Extract Grinding steps from grindingProfile *)
          profileGrindingSteps = Select[grindingProfile, #[[1]] == Grinding &];

          (* Throw a warning if the specified NumberOfGrindingSteps is different from number of grinding steps in GrindingProfile *)
          changedNumberOfGrindingSteps = Length[profileGrindingSteps] != numberOfGrindingSteps;

          (* Throw a warning if the specified GrindingRate (if not automatic) is different from any specified rates in GrindingProfile *)
          (* Are any of the rates in profileGrindingSteps different from grindingRate? *)
          rateChangedQ = grindingRate != #& /@ profileGrindingSteps[[All, 2]];

          changedRate = MemberQ[rateChangedQ, True] && Not[MatchQ[unresolvedGrindingRate, Automatic]];

          (* Throw a warning if the specified grinding Time is different from any specified grinding times in GrindingProfile *)
          (* Are any of the grinding times in profileGrindingSteps different from specified Time? *)
          timeChangedQ = time != #& /@ profileGrindingSteps[[All, 3]];

          changedTime = MemberQ[timeChangedQ, True] && Not[MatchQ[unresolvedTime, Automatic]];

          (* Throw a warning if any of the specified cooling rates is not 0 RPM or CoolingTime is different from any of the specified cooling times in GrindingProfile *)
          (* Extract Cooling steps from grindingProfile *)
          profileCoolingSteps = Select[grindingProfile, #[[1]] == Cooling &];

          (* Throw a warning if the specified cooling rate is 0 RPM in GrindingProfile *)
          nonZeroCoolingRateQ = 0 RPM != #& /@ profileCoolingSteps[[All, 2]];
          nonZeroCoolingRate = MemberQ[nonZeroCoolingRateQ, True];

          (* Throw a warning if CoolingTime is different from any of the specified cooling times in GrindingProfile *)
          (* Are any of the cooling times in profileGrindingSteps different from specified CoolingTime? *)
          coolingTimeChangedQ = coolingTime != #& /@ profileCoolingSteps[[All, 3]];
          changedCoolingTime = MemberQ[coolingTimeChangedQ, True] && Not[MatchQ[unresolvedCoolingTime, Automatic]];

          (* SampleLabel; Default: Automatic *)
          sampleLabel = Which[
            Not[MatchQ[unresolvedSampleLabel, Automatic]], unresolvedSampleLabel,
            And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]]],
            Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
            True, CreateUniqueLabel["sample " <> StringDrop[Lookup[samplePacket, ID], 3]]
          ];

          (* SampleOutLabel; Default: Null *)
          sampleOutLabel = If[
            Not[MatchQ[unresolvedSampleOutLabel, Automatic]],
            unresolvedSampleOutLabel,
            CreateUniqueLabel["SampleOut " <> StringDrop[Lookup[samplePacket, ID], 3]]
          ];

          (* ContainerOut; Default: Null; Null indicates Input Sample's Container. *)
          containerOut = If[
            MatchQ[unresolvedContainerOut, Except[Automatic]],
            unresolvedContainerOut,
            PreferredContainer[UnitSimplify[amount / unresolvedBulkDensity]]
          ];

          (* resolve ContainerOutLabel *)
          containerOutLabel = If[
            MatchQ[unresolvedContainerOutLabel, Except[Automatic]],
            unresolvedContainerOutLabel,
            CreateUniqueLabel["ContainerOut " <> StringDrop[Lookup[samplePacket, ID], 3]]
          ];

          (*Throw an error if samplesOutStorageCondition resolves to Null*)
          invalidSamplesOutStorageCondition =
              NullQ[unresolvedSamplesOutStorageCondition] &&
                  MatchQ[Lookup[modelPacket, DefaultStorageCondition], Null];

          {
            (*1*)grinderType,
            (*2*)instrument,
            (*3*)amount,
            (*4*)unresolvedFineness,
            (*5*)unresolvedBulkDensity,
            (*6*)grindingContainer,
            (*7*)grindingBead,
            (*8*)numberOfGrindingBeads,
            (*9*)grindingRate,
            (*10*)time,
            (*11*)numberOfGrindingSteps,
            (*12*)coolingTime,
            (*13*)grindingProfile,
            (*14*)sampleLabel,
            (*15*)sampleOutLabel,
            (*16*)containerOut,
            (*17*)containerOutLabel,
            (*18*)unresolvedSamplesOutStorageCondition,
            (*19*)rateUnitChanged,
            (*20*)invalidSampleFineness,
            (*21*)invalidSampleAmount,
            (*22*)grinderTypeMismatch,
            (*23*)highGrindingRate,
            (*24*)lowGrindingRate,
            (*25*)highGrindingTime,
            (*26*)lowGrindingTime,
            (*27*)changedNumberOfGrindingSteps,
            (*28*)changedRate,
            (*29*)changedTime,
            (*30*)nonZeroCoolingRate,
            (*31*)changedCoolingTime,
            (*32*)invalidSamplesOutStorageCondition
          }
        ]
      ],
      {samplePackets, modelPackets, mapThreadFriendlyOptions, sampleContainerPackets, sampleContainerModelPackets}
    ]
  ];


  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];


  (* throw an error if the specified Fineness is greater than the max FeedFineness of the grinders available at ECL *)
  finenessInvalidOption = If[MemberQ[invalidSamplesFineness, True] && messages,
    (
      Message[
        Error::LargeParticles,
        ObjectToString[PickList[simulatedSamples, invalidSamplesFineness], Cache -> cacheBall],
        "available grinders"
      ];
      {Fineness}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  invalidSampleFinenessTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, invalidSamplesFineness];
      passingInputs = PickList[simulatedSamples, invalidSamplesFineness, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The largest particles of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " are smaller than than the maximum FeedFineness of grinders.", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The largest particles of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " are smaller than than the maximum FeedFineness of grinders.", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* throw an error if the specified amount is greater than All for any samples *)
  invalidAmountOption = If[MemberQ[invalidSampleAmounts, True] && messages,
    (
      Message[
        Error::InvalidSampleAmounts,
        ObjectToString[PickList[simulatedSamples, invalidSampleAmounts], Cache -> cacheBall]
      ];
      {Amount}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  invalidSampleAmountTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, invalidSampleAmounts];
      passingInputs = PickList[simulatedSamples, invalidSampleAmounts, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " have valid sample Amount(s).", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have valid sample Amount(s).", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw and error if the specified GrinderType and grinder Instrument do not match *)
  grinderTypeMismatchOption = If[MemberQ[grinderTypeMismatches, True] && messages,
    (
      Message[
        Error::GrinderTypeOptionMismatch,
        ObjectToString[PickList[simulatedSamples, grinderTypeMismatches], Cache -> cacheBall]
      ];
      {GrinderType}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  grindTypeMismatchTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, grinderTypeMismatches];
      passingInputs = PickList[simulatedSamples, grinderTypeMismatches, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The specified GrinderType(s) and type(s) of the specified grinder Instrument(s) match for the following sample(s), " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The specified GrinderType(s) and type(s) of the specified grinder Instrument(s) match for the following sample(s), " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw an error if the specified rate is greater than the max rate of the selected grinder *)
  highGrindingRateOption = If[MemberQ[highGrindingRates, True] && messages,
    (
      Message[
        Error::HighGrindingRate,
        ObjectToString[PickList[simulatedSamples, highGrindingRates], Cache -> cacheBall]
      ];
      {GrindingRate}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  highGrindingRateTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, highGrindingRates];
      passingInputs = PickList[simulatedSamples, highGrindingRates, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The specified GrindingRate(s) are equal to or smaller than the maximum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The specified GrindingRate(s) are equal to or smaller than the maximum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw an error if the specified rate is smaller than the min rate of the selected grinder *)
  lowGrindingRateOption = If[MemberQ[lowGrindingRates, True] && messages,
    (
      Message[
        Error::LowGrindingRate,
        ObjectToString[PickList[simulatedSamples, lowGrindingRates], Cache -> cacheBall]
      ];
      {GrindingRate}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  lowGrindingRateTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, lowGrindingRates];
      passingInputs = PickList[simulatedSamples, lowGrindingRates, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The specified GrindingRate(s) are equal to or greater than the minimum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The specified GrindingRate(s) are equal to or greater than the minimum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw an error if the specified Time is greater than the max grinding time of the selected grinder *)
  highGrindingTimeOption = If[MemberQ[highGrindingTimes, True] && messages,
    (
      Message[
        Error::HighGrindingTime,
        ObjectToString[PickList[simulatedSamples, highGrindingTimes], Cache -> cacheBall]
      ];
      {Time}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  highGrindingTimeTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, highGrindingTimes];
      passingInputs = PickList[simulatedSamples, highGrindingTimes, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The specified grinding Time(s) are equal to or smaller than the maximum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The specified grinding Time(s) are equal to or smaller than the maximum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw an error if the specified Time is smaller than the min grinding time of the selected grinder *)
  lowGrindingTimeOption = If[MemberQ[lowGrindingTimes, True] && messages,
    (
      Message[
        Error::LowGrindingTime,
        ObjectToString[PickList[simulatedSamples, lowGrindingTimes], Cache -> cacheBall]
      ];
      {Time}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  lowGrindingTimeTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, lowGrindingTimes];
      passingInputs = PickList[simulatedSamples, lowGrindingTimes, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Test["The specified grinding Time(s) are equal to or greater than the minimum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The specified grinding Time(s) are equal to or greater than the minimum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw a warning if the specified NumberOfGrindingSteps is different from the number of grinding steps in GrindingProfile *)
  changedNumberOfGrindingStepsOption = If[MemberQ[changedNumbersOfGrindingSteps, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[
        Warning::ModifiedNumberOfGrindingSteps,
        ObjectToString[PickList[simulatedSamples, changedNumbersOfGrindingSteps], Cache -> cacheBall]
      ];
      {GrindingRate, GrindingProfile}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  changedNumberOfGrindingStepsTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, changedNumbersOfGrindingSteps];
      passingInputs = PickList[simulatedSamples, changedNumbersOfGrindingSteps, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Warning["The specified NumberOfGrindingSteps is equal to the number of grinding steps in GrindingProfile for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["The specified NumberOfGrindingSteps is equal to the number of grinding steps in GrindingProfile for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw a warning if the specified GrindingRate is different from any of the specified grinding rates in GrindingProfile *)
  changedRateOption = If[MemberQ[changedRates, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[
        Warning::ModifiedGrindingRates,
        ObjectToString[PickList[simulatedSamples, changedRates], Cache -> cacheBall]
      ];
      {GrindingRate, GrindingProfile}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  changedRateTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, changedRates];
      passingInputs = PickList[simulatedSamples, changedRates, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Warning["All specified grinding rate(s) in GrindingProfile are equal to the specified grinding Rate(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["All specified grinding rate(s) in GrindingProfile are equal to the specified grinding Rate(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw a warning if the specified grinding Time is different from any of the specified grinding times in GrindingProfile *)
  changedTimeOption = If[MemberQ[changedTimes, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[
        Warning::ModifiedGrindingTimes,
        ObjectToString[PickList[simulatedSamples, changedTimes], Cache -> cacheBall]
      ];
      {GrindingRate, GrindingProfile}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  changedTimeTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, changedTimes];
      passingInputs = PickList[simulatedSamples, changedTimes, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Warning["All specified grinding times in GrindingProfile are equal to the specified grinding Time(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["All specified grinding times in GrindingProfile are equal to the specified grinding Time(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw a warning if any of the specified cooling rates in GrindingProfile are greater than zero *)
  nonZeroCoolingRateOption = If[MemberQ[nonZeroCoolingRates, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[
        Warning::NonZeroCoolingRates,
        ObjectToString[PickList[simulatedSamples, nonZeroCoolingRates], Cache -> cacheBall]
      ];
      {GrindingRate, GrindingProfile}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  nonZeroCoolingRateTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, nonZeroCoolingRates];
      passingInputs = PickList[simulatedSamples, nonZeroCoolingRates, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Warning["None of the specified cooling rate(s) in GrindingProfile are greater than 0 RPM for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["None of the specified cooling rate(s) in GrindingProfile are greater than 0 RPM for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];

  (* Throw a warning if the specified CoolingTime is different from any of the specified cooling times in GrindingProfile *)
  changedCoolingTimeOption = If[MemberQ[changedCoolingTimes, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
    (
      Message[
        Warning::ModifiedCoolingTimes,
        ObjectToString[PickList[simulatedSamples, changedCoolingTimes], Cache -> cacheBall]
      ];
      {GrindingRate, GrindingProfile}
    ),
    {}
  ];

  (* Create appropriate tests if gathering them, or return {} *)
  changedCoolingTimeTest = If[gatherTests,
    Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

      (* Get the failing and not failing samples *)
      failingInputs = PickList[simulatedSamples, changedCoolingTimes];
      passingInputs = PickList[simulatedSamples, changedCoolingTimes, False];

      (* Create the passing and failing tests *)
      failingInputTest = If[Length[failingInputs] > 0,
        Warning["All specified cooling times in GrindingProfile are equal to the specified CoolingTime(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["All specified cooling times in GrindingProfile are equal to the specified CoolingTime(s) for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, True],
        Nothing
      ];

      (* Return our created tests. *)
      {passingInputsTest, failingInputTest}
    ],
    {}
  ];



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
        Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " have a valid SamplesOutStorageCondition.", True, False],
        Nothing
      ];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have a valid SamplesOutStorageCondition.", True, True],
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
      GrinderType -> resolvedGrinderType,
      Instrument -> resolvedInstrument,
      Amount -> resolvedAmount,
      Fineness -> resolvedFineness,
      BulkDensity -> resolvedBulkDensity,
      GrindingContainer -> resolvedGrindingContainer,
      GrindingBead -> resolvedGrindingBead,
      NumberOfGrindingBeads -> resolvedNumberOfGrindingBeads,
      GrindingRate -> resolvedGrindingRate,
      Time -> resolvedTime,
      NumberOfGrindingSteps -> resolvedNumberOfGrindingSteps,
      CoolingTime -> resolvedCoolingTime,
      GrindingProfile -> resolvedGrindingProfile,
      SampleLabel -> resolvedSampleLabel,
      SampleOutLabel -> resolvedSampleOutLabel,
      ContainerOut -> resolvedContainerOut,
      ContainerOutLabel -> resolvedContainerOutLabel,
      SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
      resolvedPostProcessingOptions
    }]
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[{
    nonSolidSampleInvalidInputs,
    discardedInvalidInputs
  }]];

  (* gather all the invalid options together *)
  invalidOptions = DeleteDuplicates[Flatten[{
    finenessInvalidOption,
    invalidAmountOption,
    grinderTypeMismatchOption,
    highGrindingRateOption,
    lowGrindingRateOption,
    highGrindingTimeOption,
    lowGrindingTimeOption,
    invalidSamplesOutStorageConditionsOptions,
    invalidAmountOption
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
    invalidSamplesOutStorageConditionsTest,
    invalidSampleFinenessTest,
    invalidSampleAmountTest,
    grindTypeMismatchTest,
    highGrindingRateTest,
    lowGrindingRateTest,
    highGrindingTimeTest,
    lowGrindingTimeTest,
    changedNumberOfGrindingStepsTest,
    changedRateTest,
    changedTimeTest,
    nonZeroCoolingRateTest,
    changedCoolingTimeTest
  }], TestP];






  (* pending to add updatedExperimentGrindSimulation to the Result *)
  (* return our resolved options and/or tests *)
  outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}
];

(* ::Subsection::Closed:: *)
(*grindResourcePackets*)

DefineOptions[grindResourcePackets,
  Options :> {
    CacheOption,
    HelperOutputOption,
    SimulationOption
  }
];

grindResourcePackets[
  mySamples : {ObjectP[Object[Sample]]..},
  myUnresolvedOptions : {___Rule},
  myResolvedOptions : {___Rule},
  myCollapsedResolvedOptions : {___Rule},
  myOptions : OptionsPattern[]
] := Module[
  {
    safeOps, outputSpecification, output, gatherTests, messages,
    cache, simulation, fastAssoc, simulatedSamples, grinderGrouper,
    updatedSimulation, simulatedSampleContainers, samplesInResources,
    instrumentTag, grinderType, instruments, amount, fineness, grinderGroupedOptions,
    grindingRate, time, numberOfGrindingSteps, coolingTime,
    grindingBeadResourceRules, mergedBeadsAndNumbers, beadsAndNumbers,
    grindingProfile, sampleLabel, containerOut, bulkDensity, unitOperationPackets,
    grindingContainer, grindingBead, numberOfGrindingBeads, sampleOutLabel, containerOutLabel,
    totalTimes, instrumentAndTimeRules, mergedInstrumentTimes, instrumentResources,
    grindingBeadResources, containerOutResourcesForProtocol, containerOutResourcesForUnitOperation,
    updatedSamplesOutStorageCondition, sampleModels, numericAmount, groupedOptions,
    samplesOutStorageCondition, protocolPacket, sharedFieldPacket, finalizedPacket,
    instrumentModelKey, instrumentModel, grindingContainerModelKey, grindingContainerModel,
    allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
    tubeHolderModelsCache, tubeHolderObjectsCache, tubeHolderModels, tubeHoldersSupportedInstruments, tubeHoldersPositions,
    tubeHoldersProvidedFootprint, tubeHolderRules, grindingContainerFootprint, neededTubeHolderModels, neededTubeHolderObjects, holderModelToObjectRule,
    clampAssemblyModelsCache, clampAssemblyObjectsCache, clampAssemblyModels, clampAssemblySupportedInstruments,
    clampAssemblyRules, neededClampAssemblyModels, clampModelToObjectRule, neededClamObjects, tweezerResource, weighingContainerResources, grindingProfileForEngineDisplay
  },

  (* get the safe options for this function *)
  safeOps = SafeOptions[grindResourcePackets, ToList[myOptions]];

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
  {simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentGrind, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

  (* this is the only real Download I need to do, which is to get the simulated sample containers *)
  simulatedSampleContainers = Download[simulatedSamples, Container[Object], Cache -> cache, Simulation -> updatedSimulation];

  (* lookup option values*)
  {
    (*1*)grinderType,
    (*2*)instruments,
    (*3*)amount,
    (*4*)fineness,
    (*5*)bulkDensity,
    (*6*)grindingContainer,
    (*7*)grindingBead,
    (*8*)numberOfGrindingBeads,
    (*9*)grindingRate,
    (*10*)time,
    (*11*)numberOfGrindingSteps,
    (*12*)coolingTime,
    (*13*)grindingProfile,
    (*14*)sampleLabel,
    (*15*)sampleOutLabel,
    (*16*)containerOut,
    (*17*)containerOutLabel,
    (*18*)samplesOutStorageCondition
  } = Lookup[
    Join[myResolvedOptions, myUnresolvedOptions],
    {
      (*1*)GrinderType,
      (*2*)Instrument,
      (*3*)Amount,
      (*4*)Fineness,
      (*5*)BulkDensity,
      (*6*)GrindingContainer,
      (*7*)GrindingBead,
      (*8*)NumberOfGrindingBeads,
      (*9*)GrindingRate,
      (*10*)Time,
      (*11*)NumberOfGrindingSteps,
      (*12*)CoolingTime,
      (*13*)GrindingProfile,
      (*14*)SampleLabel,
      (*15*)SampleOutLabel,
      (*16*)ContainerOut,
      (*17*)ContainerOutLabel,
      (*18*)SamplesOutStorageCondition
    }
  ];

  (* --- Make all the resources needed in the experiment --- *)

  (*Update amount value to quantity if it is resolved to All*)
  numericAmount = MapThread[If[
    MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
  ]&, {amount, mySamples}];

  (*SampleIn and GrindingContainer Resources*)
  samplesInResources = MapThread[Resource[
    Sample -> #, Name -> #2, Amount -> #3, Container -> Download[#4, Object]
  ]&, {mySamples, sampleLabel, numericAmount, grindingContainer}];

  grindingContainerModel = If[
    MatchQ[#, ObjectP[Object]],
    fastAssocLookup[fastAssoc, #, Model],
    #
  ]& /@ grindingContainer;

  (*merge the grinding beads and amounts together*)
  beadsAndNumbers = MapThread[If[NullQ[#1], Nothing,
    Download[#1, Object] -> #2]&,
    {grindingBead, numberOfGrindingBeads}
  ];
  mergedBeadsAndNumbers = Merge[beadsAndNumbers, Total];

  (*make resource replace rules for the beads, but not yet index matching*)
  grindingBeadResourceRules = KeyValueMap[
    #1 -> Resource[Sample -> #1, Amount -> #2, Name -> ToString[Unique[]]]&,
    mergedBeadsAndNumbers
  ];

  (*GrindingBead resources with the replace rules we made above*)
  grindingBeadResources = Download[grindingBead, Object] /. grindingBeadResourceRules;

  (* Tweezers resources *)
  tweezerResource = If[
    MemberQ[grinderType, BallMill],
    Link[Resource[Sample -> Model[Item, Tweezer, "id:8qZ1VWNwNDVZ"] (* "Straight flat tip tweezer" *), Name -> CreateUniqueLabel["Tweezers Resources"], Rent -> True]]
  ];

  (* Weigh boat resources *)
  weighingContainerResources = Link[Resource[
    Sample -> If[LessEqual[#, 10 Gram],
      Model[Item, Consumable, "id:Vrbp1jG80zRw"],(* "Weigh boats, medium" *)
      Model[Item, WeighBoat, "id:vXl9j57j0zpm"] (* "Weigh boats, large" *)
    ],
    Amount -> 1,
    Name -> CreateUniqueLabel["Weigh Boat Resources"]
  ]]& /@ numericAmount;

  (*Make a list of tags for each unique instrument*)
  instrumentTag = Map[
    # -> ToString[Unique[]]&,
    DeleteDuplicates[instruments]
  ];

  (*Calculate the time required for grinding from GrindingProfile*)
  totalTimes = Map[Total, grindingProfile[[All, All, 3]]];
  instrumentAndTimeRules = MapThread[#1 -> #2&, {instruments, totalTimes}];

  (*merge the instrument and time rules*)
  mergedInstrumentTimes = Merge[instrumentAndTimeRules, Total];

  (* make instrument resources *)
  (* For Manual preparation, do this trick with the instrument tags to ensure we don't have duplicate instrument resources *)
  (* For Robotic preparation, 1.2 * total time is a little hokey but I think gives us a little more wiggle room of how long it will actually take *)
  instrumentResources = Module[{lookup},
    (* Build a Instrument->Resource Lookup *)
    lookup = KeyValueMap[If[NullQ[#1], #1 -> Null,
      #1 -> Link[Resource[Instrument -> #1, Time -> (ReplaceAll[#2, {Null -> 1Minute}] + 5Minute), Name -> (#1 /. instrumentTag)]]
    ]&,
      mergedInstrumentTimes
    ];
    (* Return all instrument resources*)
    instruments /. lookup
  ];

  (* get all the instrument models. the last [Object] is used to remove links from models*)
  instrumentModel = (If[
    MatchQ[#, ObjectP[Object]],
    fastAssocLookup[fastAssoc, #, Model],
    #
  ]& /@ instruments)[Object];

  (* grinder tube holder. it is not a resource and does not have to be picked as a resource. it's a simple object sitting near the beadgenie grinder *)
  tubeHolderModelsCache = Cases[fastAssoc, ObjectP[{Model[Container, GrinderTubeHolder]}]];
  tubeHolderObjectsCache = Cases[fastAssoc, ObjectP[{Object[Container, GrinderTubeHolder]}]];

  tubeHolderModels = Lookup[#, Object]& /@ tubeHolderModelsCache;

  tubeHoldersSupportedInstruments = Download[Flatten[Lookup[#, SupportedInstruments]& /@ tubeHolderModelsCache], Object];

  tubeHoldersPositions = Lookup[#, Positions]& /@ tubeHolderModelsCache;

  tubeHoldersProvidedFootprint = Lookup[#[[1]], Footprint]& /@ tubeHoldersPositions;

  tubeHolderRules = MapThread[RuleDelayed[{#1, #2}, #3]&, {tubeHoldersSupportedInstruments, tubeHoldersProvidedFootprint, tubeHolderModels}];

  grindingContainerFootprint = fastAssocLookup[fastAssoc, #, Footprint]& /@ grindingContainerModel;

  neededTubeHolderModels = Replace[MapThread[{#1, #2}&, {instrumentModel, grindingContainerFootprint}], Join[tubeHolderRules, { {_, _} :> Null}], 1];

  holderModelToObjectRule = GroupBy[MapThread[Rule, {Lookup[tubeHolderObjectsCache, Model][Object], Lookup[tubeHolderObjectsCache, Object]}], First -> Last];

  neededTubeHolderObjects = Map[First[#, Null]&, (neededTubeHolderModels /. holderModelToObjectRule)];

  (* grinder clamp assembly resources *)
  clampAssemblyModelsCache = Cases[fastAssoc, ObjectP[{Model[Part, GrinderClampAssembly]}]];
  clampAssemblyObjectsCache = Cases[fastAssoc, ObjectP[{Object[Part, GrinderClampAssembly]}]];

  clampAssemblyModels = Lookup[#, Object]& /@ clampAssemblyModelsCache;

  clampAssemblySupportedInstruments = Download[Flatten[Lookup[#, SupportedInstruments]& /@ clampAssemblyModelsCache], Object];

  clampAssemblyRules = MapThread[RuleDelayed[#1, #2]&, {clampAssemblySupportedInstruments, clampAssemblyModels}];

  neededClampAssemblyModels = instrumentModel /. Join[clampAssemblyRules, {ObjectP[Model[Instrument]] -> Null}];

  clampModelToObjectRule = GroupBy[MapThread[Rule, {Lookup[clampAssemblyObjectsCache, Model][Object], Lookup[clampAssemblyObjectsCache, Object]}], First -> Last];

  neededClamObjects = Map[First[#, Null]&, (neededClampAssemblyModels /. clampModelToObjectRule)];

  (*Create resource packet for containerOut if needed*)
  containerOutResourcesForProtocol = MapThread[If[
    NullQ[#], Null,
    If[MatchQ[#, ObjectP[Object]],
      Link[Resource[Sample -> #, Name -> #2], Protocols],
      Link[Resource[Sample -> #, Name -> #2]]
    ]]&, {containerOut, containerOutLabel}];

  (*Pattern for ContainerOut in Object[Protocol] is _Link with
  Relation->Alternatives[Object[Container][Protocols],Model[Container].
  However, if the same pattern is Relations is used in
  Object[UnitOperation,Desiccate], ValidTypeQ does not pass;
  Backlink check: Object[Container][Protocols] points back to
  Object[UnitOperation, Desiccate][ContainerOut]:	..................	[FAIL].
  Therefore, here this is a 1way link for UnitOperation*)
  containerOutResourcesForUnitOperation = MapThread[If[
    NullQ[#], Null,
    Link[Resource[Sample -> #, Name -> #2]]
  ]&, {containerOut, containerOutLabel}];

  (*Change SampleStorageCondition to Model's default if it is resolved to Null*)
  sampleModels = Download[fastAssocLookup[fastAssoc, #, Model], Object]& /@ mySamples;
  updatedSamplesOutStorageCondition = MapThread[
    If[NullQ[#1], Link@Download[fastAssocLookup[fastAssoc, #2, DefaultStorageCondition], Object], #1]&,
    {samplesOutStorageCondition, sampleModels}
  ];

  (* GrindingProfileForEngineDisplay: a hidden field in Grind protocol and unit operation. This is for displaying corrected unitless numbers for grinding rate. these rates should be corrected because, for example, for a grinding rate of 2000 RPM,the operator should enter 200 in the instrument *)

  grindingProfileForEngineDisplay = MapThread[Function[{instrumentModel, grindingProfile}, Which[
    MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]],
    Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]] / 10]&, grindingProfile],

    MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]],
    Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]] * 2]&, grindingProfile],

    True,
    Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]]]&, grindingProfile]
  ]], {instrumentModel, grindingProfile}];

  (* group relevant options into batches (based on Instrument and Sterile option) *)
  (* NOTE THAT I HAVE TO REPLICATE THIS CODE TO SOME DEGREE IN grindPopulateWorkingSamples SO IF THE LOGIC CHANGES HERE CHANGE IT THERE TOO*)
  (* note that we don't actually have to do any grouping if we're doing robotic, then we just want a list so we are just grouping by the preparation *)
  groupedOptions = Experiment`Private`groupByKey[
    {
      Sample -> Link /@ samplesInResources,
      WorkingSample -> Link /@ mySamples,
      GrinderType -> grinderType,
      Instrument -> instrumentResources,
      GrinderTubeHolder -> Link /@ neededTubeHolderObjects,
      GrinderClampAssembly -> Link /@ neededClamObjects,
      WeighingContainer -> weighingContainerResources,
      Amount -> amount,
      Fineness -> fineness,
      BulkDensity -> bulkDensity,
      GrindingContainer -> grindingContainer,
      GrindingBead -> grindingBeadResources,
      NumberOfGrindingBeads -> numberOfGrindingBeads,
      GrindingRate -> grindingRate,
      Time -> time,
      NumberOfGrindingSteps -> numberOfGrindingSteps,
      CoolingTime -> coolingTime,
      GrindingProfile -> grindingProfile,
      GrindingProfileForEngineDisplay -> grindingProfileForEngineDisplay,
      SampleLabel -> sampleLabel,
      SampleOutLabel -> sampleOutLabel,
      ContainerOut -> containerOutResourcesForUnitOperation,
      ContainerOutLabel -> containerOutLabel,
      SamplesOutStorageCondition -> samplesOutStorageCondition,
      (*The following keys are added for the sake of grouping.*)
      grindingContainerModelKey -> grindingContainerModel,
      instrumentModelKey -> instrumentModel
    },
    {instrumentModelKey, grindingContainerModelKey, GrindingProfile}
  ];

  (*grinderGrouper, a function to group samples based on the number of samples that a grinder can grind at the same time*)
  grinderGrouper[groupedOption : {_Rule..}] := Module[
    {grinderModel, containerVolume, grouperFunction, expandedOptions,
      optionsPacket, partitionedOptions, collapsedOptions, mergedOptions},

    grinderModel = First@Lookup[groupedOption, instrumentModelKey];
    containerVolume = Download[First@Lookup[groupedOption, GrindingContainer], MaxVolume];

    grouperFunction = Function[{groupMe, number},
      expandedOptions = Thread /@ groupMe;
      optionsPacket = Transpose@expandedOptions;
      partitionedOptions = Partition[optionsPacket, UpTo[number]];
      collapsedOptions = Map[Transpose, partitionedOptions];
      mergedOptions = Sequence @@ Normal[Map[Merge[#, Join]&, collapsedOptions]]
    ];

    Which[
      MatchQ[grinderModel, Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]], (*BeadBug3*)
      grouperFunction[groupedOption, 3],

      MatchQ[grinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && EqualQ[containerVolume, 50Milliliter], (*BeadGenie*)
      grouperFunction[groupedOption, 3],

      MatchQ[grinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && EqualQ[containerVolume, 15Milliliter], (*BeadGenie*)
      grouperFunction[groupedOption, 6],

      MatchQ[grinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && (EqualQ[containerVolume, 1.5Milliliter] || EqualQ[containerVolume, 1.9Milliliter] || EqualQ[containerVolume, 2Milliliter]), (*BeadGenie*)
      grouperFunction[groupedOption, 12],

      MatchQ[grinderModel, Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]], (*Mixer Mill MM400*)
      grouperFunction[groupedOption, 2],

      True, groupedOption
    ]
  ];

  grinderGroupedOptions = Map[grinderGrouper, groupedOptions[[All, 2]]];

  (* Preparing protocol and unitOperationObject packets: Are we making resources for Manual or Robotic? (Desiccate is manual only) *)
  (* Preparing unitOperationObject. Consider if we are making resources for Manual or Robotic *)
  unitOperationPackets = Map[
    Function[{options},
      Module[{nonHiddenOptions},

        (* Only include non-hidden options from Transfer. *)
        nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Grind]];

        UploadUnitOperation[
          Grind @@ ReplaceRule[
            Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
            {
              Sample -> Lookup[options, Sample],
              Instrument -> Lookup[options, Instrument],
              GrindingBead -> Lookup[options, GrindingBead],
              ContainerOut -> Lookup[options, ContainerOut],
              Preparation -> Manual,
              GrinderType -> Lookup[options, GrinderType],
              GrinderTubeHolder -> Lookup[options, GrinderTubeHolder],
              GrinderClampAssembly -> Lookup[options, GrinderClampAssembly],
              WeighingContainer -> Lookup[options, WeighingContainer],
              Amount -> Lookup[options, Amount],
              Fineness -> Lookup[options, Fineness],
              BulkDensity -> Lookup[options, BulkDensity],
              GrindingContainer -> Lookup[options, GrindingContainer],
              NumberOfGrindingBeads -> Lookup[options, NumberOfGrindingBeads],
              GrindingRate -> Lookup[options, GrindingRate],
              Time -> Lookup[options, Time],
              NumberOfGrindingSteps -> Lookup[options, NumberOfGrindingSteps],
              CoolingTime -> Lookup[options, CoolingTime],
              (*next one is a single field*)
              GrindingProfile -> First@Lookup[options, GrindingProfile],
              GrindingProfileForEngineDisplay -> First@Lookup[options, GrindingProfileForEngineDisplay],
              SampleLabel -> Lookup[options, SampleLabel],
              SampleOutLabel -> Lookup[options, SampleOutLabel],
              ContainerOut -> Lookup[options, ContainerOut],
              ContainerOutLabel -> Lookup[options, ContainerOutLabel],
              SamplesOutStorageCondition -> Lookup[options, SamplesOutStorageCondition]
            }
          ],
          UnitOperationType -> Batched,
          Preparation -> Manual,
          FastTrack -> True,
          Upload -> False
        ]
      ]
    ],
    grinderGroupedOptions
  ];

  (*---Generate the protocol packet---*)
  protocolPacket = Join[
    <|
      Object -> CreateID[Object[Protocol, Grind]],
      Type -> Object[Protocol, Grind],
      Replace[SamplesIn] -> samplesInResources,
      Replace[Times] -> time,
      Replace[GrindingProfiles] -> grindingProfile,
      Replace[GrinderTypes] -> grinderType,
      Replace[Instruments] -> instrumentResources,
      Replace[GrindingContainers] -> Link /@ grindingContainer,
      Replace[GrindingBeads] -> grindingBeadResources,
      Replace[ContainersOut] -> containerOutResourcesForProtocol,
      Tweezer -> tweezerResource,
      Replace[WeighingContainers] -> weighingContainerResources,
      Replace[SamplesOutStorageConditions] -> updatedSamplesOutStorageCondition,
      UnresolvedOptions -> myUnresolvedOptions,
      ResolvedOptions -> myResolvedOptions,
      Replace[Checkpoints] -> {
        {
          "Picking Resources",
          30Minute,
          "Samples required to execute this protocol are gathered from storage.",
          Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 30Minute]]
        },
        {
          "Preparing Samples",
          60Minute,
          "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",
          Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60Minute]]
        },
        {
          "Running Experiment",
          (Plus @@ totalTimes + 10 Minute),
          "The samples are being ground into smaller particles via the grinders.",
          Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> (Plus @@ totalTimes + 10 Minute)]]
        },
        {
          "Sample Post-Processing",
          30Minute,
          "Any measuring of volume, weight, or sample imaging post experiment is performed.",
          Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 30Minute]]
        },
        {
          "Returning Materials",
          30Minute,
          "Samples are returned to storage.",
          Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 30Minute]]
        }
      },
      Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ ToList[Lookup[unitOperationPackets, Object]]
    |>
  ];

  (*generate a packet with the shared fields*)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[protocolPacket]], _Resource, Infinity]];

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
    RemoveHiddenOptions[ExperimentGrind, myResolvedOptions],
    Null
  ];

  (* generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    frqTests,
    Null
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
(*simulateExperimentGrind*)

DefineOptions[
  simulateExperimentGrind,
  Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentGrind[
  myProtocolPacket : PacketP[Object[Protocol, Grind]] | $Failed | Null,
  myUnitOperationPackets : {PacketP[Object[UnitOperation, Grind]]..} | $Failed,
  mySamples : {ObjectP[Object[Sample]]...},
  myResolvedOptions : {_Rule...},
  myResolutionOptions : OptionsPattern[simulateExperimentGrind]
] := Module[
  {
    cache, simulation, samplePackets, protocolObject, currentSimulation,
    simulationWithLabels, mapThreadFriendlyOptions, fastAssoc,
    uploadSampleTransferPackets, simulatedContainerOut, simulatedDestinationLocation,
    inputContainers, needNewSampleQ, newContainer,
    simulatedInputSampleContainer, simulatedOutSampleContainer,
    simulatedNewSamples, newSamplePackets, destinationContainer,
    grinderType, instrument, amount, fineness, bulkDensity,
    grindingContainer, grindingBead, numberOfGrindingBeads,
    grindingRate, time, numberOfGrindingSteps, coolingTime,
    grindingProfile, sampleLabel, sampleOutLabel, containerOut,
    containerOutLabel, samplesOutStorageCondition, instrumentResources,
    instrumentTag, samplesInResources, grindingBeadResources, totalTimes,
    instrumentAndTimeRules, mergedInstrumentTimes, containerOutResourcesForProtocol,
    simulatedContainerOutObjects, numericAmount
  },

  (* Lookup our cache and simulation and make our fast association *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
  fastAssoc = makeFastAssocFromCache[cache];

  {
    samplePackets
  } = Quiet[
    Download[
      {
        ToList[mySamples]
        (*protocolObject,*)
      },
      {
        Packet[Model, Container]
      },
      Simulation -> simulation
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  {
    (*1*)grinderType,
    (*2*)instrument,
    (*3*)amount,
    (*4*)fineness,
    (*5*)bulkDensity,
    (*6*)grindingContainer,
    (*7*)grindingBead,
    (*8*)numberOfGrindingBeads,
    (*9*)grindingRate,
    (*10*)time,
    (*11*)numberOfGrindingSteps,
    (*12*)coolingTime,
    (*13*)grindingProfile,
    (*14*)sampleLabel,
    (*15*)sampleOutLabel,
    (*16*)containerOut,
    (*17*)containerOutLabel,
    (*18*)samplesOutStorageCondition
  } = Lookup[
    myResolvedOptions,
    {
      (*1*)GrinderType,
      (*2*)Instrument,
      (*3*)Amount,
      (*4*)Fineness,
      (*5*)BulkDensity,
      (*6*)GrindingContainer,
      (*7*)GrindingBead,
      (*8*)NumberOfGrindingBeads,
      (*9*)GrindingRate,
      (*10*)Time,
      (*11*)NumberOfGrindingSteps,
      (*12*)CoolingTime,
      (*13*)GrindingProfile,
      (*14*)SampleLabel,
      (*15*)SampleOutLabel,
      (*16*)ContainerOut,
      (*17*)ContainerOutLabel,
      (*18*)SamplesOutStorageCondition
    }
  ];

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject = Which[
    MatchQ[myProtocolPacket, $Failed],
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
    SimulateCreateID[Object[Protocol, Grind]],
    True,
    Lookup[myProtocolPacket, Object]
  ];

  (*	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentGrind,
		myResolvedOptions
	];*)

  (*Update amount value to quantity if it is resolved to All*)
  numericAmount = MapThread[If[
    MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
  ]&, {amount, mySamples}];

  (*SampleIn and GrindingContainer Resources*)
  samplesInResources = MapThread[Resource[
    Sample -> #, Name -> #2, Amount -> #3, Container -> #4
  ]&, {ToList[mySamples], sampleLabel, numericAmount, grindingContainer}];

  (*GrindingBead resources*)
  grindingBeadResources = MapThread[If[
    MatchQ[#, Null], Null,
    Link[Resource[Sample -> #, Amount -> #2]]]&,
    {grindingBead, numberOfGrindingBeads}
  ];

  (* Make a list of tags for each unique instrument *)
  instrumentTag = Map[
    # -> ToString[Unique[]]&,
    DeleteDuplicates[instrument]
  ];

  (* Calculate the time required for grinding from GrindingProfile *)
  totalTimes = Map[Total, grindingProfile[[All, All, 3]]];
  instrumentAndTimeRules = MapThread[#1 -> #2&, {instrument, totalTimes}];

  (* merge the instrument and time rules *)
  mergedInstrumentTimes = Merge[instrumentAndTimeRules, Total];

  (* make instrument resources *)
  (* For Manual preparation, do this trick with the instrument tags to ensure we don't have duplicate instrument resources *)
  (* For Robotic preparation, 1.2 * total time is a little hokey but I think gives us a little more wiggle room of how long it will actually take *)
  instrumentResources = Module[{lookup},
    (* Build a Instrument->Resource Lookup *)
    lookup = KeyValueMap[If[NullQ[#1], #1 -> Null,
      #1 -> Link[Resource[Instrument -> #1, Time -> (ReplaceAll[#2, {Null -> 1Minute}] + 5Minute), Name -> (# /. instrumentTag)]]
    ]&,
      mergedInstrumentTimes
    ];
    (* Return all instrument resources*)
    instrument /. lookup
  ];

  (*Create resource packet for containerOut if needed*)
  containerOutResourcesForProtocol = MapThread[If[
    NullQ[#], Null,
    If[MatchQ[#, ObjectP[Object]],
      Link[Resource[Sample -> #, Name -> #2], Protocols],
      Link[Resource[Sample -> #, Name -> #2]]
    ]]&, {containerOut, containerOutLabel}];

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
        Replace[SamplesIn] -> samplesInResources,
        Replace[Instruments] -> instrumentResources,
        Replace[GrindingBeads] -> grindingBeadResources,
        Replace[ContainersOut] -> containerOutResourcesForProtocol,
        ResolvedOptions -> myResolvedOptions
      |>,
      Cache -> cache,
      Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]
    ],
    (* Otherwise, our resource packets went fine and we have an Object[Protocol, Grind]. *)
    SimulateResources[myProtocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
  ];

  (*Download simulated ContainerOut Objects from simulation*)
  simulatedContainerOutObjects = Download[protocolObject, ContainersOut, Simulation -> currentSimulation];

  (*Create new samples for simulating transfer*)
  (*Add position "A1" to destination containers to create destination locations*)
  simulatedDestinationLocation = {"A1", #}& /@ simulatedContainerOutObjects;

  (* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
  newSamplePackets = UploadSample[
    (* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
    ConstantArray[{}, Length[simulatedDestinationLocation]],
    simulatedDestinationLocation,
    State -> ConstantArray[Solid, Length[simulatedDestinationLocation]],
    InitialAmount -> ConstantArray[Null, Length[simulatedDestinationLocation]],
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject,
    FastTrack -> True,
    Upload -> False
  ];

  (* update our simulation with new sample packets*)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSamplePackets]];

  (*Lookup Object[Sample]s from newSamplePackets*)
  simulatedNewSamples = DeleteDuplicates[Cases[Lookup[newSamplePackets, Object], ObjectReferenceP[Object[Sample]]]];

  (* Call UploadSampleTransfer on our source and destination samples. *)
  uploadSampleTransferPackets = UploadSampleTransfer[
    ToList[mySamples],
    simulatedNewSamples,
    amount,
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
        Transpose[{ToList[Lookup[myResolvedOptions, SampleOutLabel]], simulatedNewSamples}],
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
Authors[Grind] := {"Mohamad.Zandian"};


(* ::Subsection::Closed:: *)
(*PreferredGrinder*)

DefineOptions[PreferredGrinder,
  Options :> {
    {
      OptionName -> GrinderType,
      Default -> Automatic,
      Description -> "Method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard grinding balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
      ResolutionDescription -> "Automatically set to the type of the output of PreferredGrinder function.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> GrinderTypeP
      ]
    },
    {
      OptionName -> Fineness,
      Default -> 1 Millimeter,
      Description -> "The approximate size of the largest particle in a solid sample.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter
      ]
    },
    {
      OptionName -> BulkDensity,
      Default -> 1Gram / Milliliter,
      Description -> "The mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount).",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> GreaterP[0 Gram / Milliliter],
        Units -> CompoundUnit[{1, {Gram, {Milligram, Gram, Kilogram}}}, {-1, {Milliliter, {Microliter, Milliliter, Liter}}}]
      ]
    }
  }
];

(* need to set DeveloperObject != True here directly because if someone happens to call this with $DeveloperSearch=True the first time in their kernel, then this will memoize to {} and fail for all subsequent uses of this function *)
cachePreferredGrinderPackets[string_] := cachePreferredGrinderPackets[string] = Module[{},
  If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets],
    AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets]
  ];

  Flatten@Download[
    Search[{{Model[Instrument, Grinder]}}, Deprecated != True && DeveloperObject != True],
    {
      {Packet[Object, Name, MinAmount, MaxAmount, FeedFineness, GrinderType]}
    }
  ]];

preferredGrinderFastCache[string_] := preferredGrinderFastCache[string] = Module[{},
  If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets],
    AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets]
  ];
  Experiment`Private`makeFastAssocFromCache[cachePreferredGrinderPackets["Memoization"]]
];

PreferredGrinder[myAmount : (MassP | VolumeP), options : OptionsPattern[PreferredGrinder]] := Module[
  {safeOptions, grinderPackets, grinderFastCache, grinderModels,
    absoluteMinGrinderVolume, myVolumeAmount, preferredGrinders,
    grinderType, fineness, bulkDensity,
    priorityList, preferredGrinderFinder},

  (*Call SafeOptions to make sure all options match pattern*)
  safeOptions = SafeOptions[PreferredGrinder, ToList[options]];

  (*Lookup options*)

  grinderType = Lookup[safeOptions, GrinderType];
  fineness = Lookup[safeOptions, Fineness];
  bulkDensity = Lookup[safeOptions, BulkDensity];

  (*Download our Instrument packets.*)
  grinderPackets = cachePreferredGrinderPackets["Memoization"];
  grinderFastCache = preferredGrinderFastCache["Memoization"];

  (*Determine MinAmount and MaxAmount of all grinders*)
  grinderModels = Cases[Keys[grinderFastCache], ObjectP[Model[Instrument, Grinder]]];

  absoluteMinGrinderVolume = Min[(fastAssocLookup[grinderFastCache, #, MinAmount]& /@ grinderModels)];

  (*Convert myAmount mass to volume*)
  myVolumeAmount = If[MassQ[myAmount], UnitSimplify[myAmount / bulkDensity], myAmount];

  (* List of available grinder models sorted based on the priority of their use *)
  priorityList = {
    BallMill -> Model[Instrument, Grinder, "id:O81aEB1lX1Mx"],
    BallMill -> Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"],
    KnifeMill -> Model[Instrument, Grinder, "id:zGj91ajA6LYO"],
    MortarGrinder -> Model[Instrument, Grinder, "id:qdkmxzk16DO0"],
    BallMill -> Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]
  };

  (* Make an empty list to add suitable grinder later *)
  preferredGrinders = {};

  (* A function that adds a grinder model to the preferredGrinders list if the fineness and amount of the sample fits *)
  preferredGrinderFinder = Function[grinderModel, If[
    myVolumeAmount >= fastAssocLookup[grinderFastCache, grinderModel, MinAmount] &&
        myVolumeAmount <= fastAssocLookup[grinderFastCache, grinderModel, MaxAmount] &&
        fineness <= fastAssocLookup[grinderFastCache, grinderModel, FeedFineness],
    AppendTo[preferredGrinders, grinderModel],
    Nothing
  ]];

  (* Map preferredGrinderFinder over the list of available grinder models to find grinders that suit the sample amount and fineness *)
  If[MatchQ[grinderType, Automatic],
    (*If grinderType is Automatic, look at all available grinder models*)
    Map[preferredGrinderFinder, Values[priorityList]],
    (*If grinderType is set to a specific grinderType, only look at the grinders of that type*)
    Map[preferredGrinderFinder, Flatten@Values[KeyTake[Merge[priorityList, Join], grinderType]]]
  ];

  (* Select a grinder for amounts/finenesses that are not covered by the criteria in preferredGrinderFinder function*)
  (*Throw Warnings or Errors if Amounts or finenesses do not match the criteria*)
  Which[
    (* Error if fineness is greater than 10 mm *)
    fineness > 10 Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]];
    Message[Error::LargeParticles, fineness, "available grinders"],

    (* Error if grinderType is greater than 2 mm and fineness is greater than 2 mm *)
    MatchQ[grinderType, MortarGrinder] &&
        fineness > 2Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]; Message[Error::LargeParticles, fineness, "available MortarGrinders"],

    (* Error if grinderType is BallMill and fineness is greater than 8 mm *)
    MatchQ[grinderType, BallMill] &&
        fineness > 8Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]];Message[Error::LargeParticles, fineness, "available BallMills"],

    (* Error if amount is Fineness is greater than 10 mm and grinderType is KnifeMill *)
    MatchQ[grinderType, KnifeMill] &&
        fineness > 10Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]];Message[Error::LargeParticles, fineness, "available grinders"],

    (* Select Model[Instrument, Grinder, "BeadBug3"] if the amount is smaller than MinAmount of all grinders and grinderType is set to BallMill|Automatic *)
    MatchQ[grinderType, BallMill | Automatic] &&
        myVolumeAmount < absoluteMinGrinderVolume,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]];Message[Warning::InsufficientAmount, myAmount, "available grinders"],

    (* Select Model[Instrument, Grinder, "Mixer Mill MM400"] if the amount is more than BallMill capacity and grinderType is set to BallMill *)
    MatchQ[grinderType, BallMill] &&
        myVolumeAmount > 40Milliliter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]];Message[Warning::ExcessiveAmount, myAmount, "available BallMills"],

    (* Select Model[Instrument, Grinder, "Tube Mill Control"] if amount is smaller than 1 and greater than 0.1 Gram and Fineness is greater than 8 and smaller than 10 Millimeter and grinderType is Automatic*)
    MatchQ[grinderType, Automatic] &&
        myVolumeAmount >= absoluteMinGrinderVolume &&
        myVolumeAmount < 1Milliliter &&
        fineness > 8Millimeter && fineness <= 10Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]];Message[Warning::InsufficientAmount, myAmount, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]],

    (* Warning if amount is more than 40 mL and grinderType is KnifeMill *)
    MatchQ[grinderType, KnifeMill] &&
        myVolumeAmount > 40Milliliter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]];Message[Warning::ExcessiveAmount, myAmount, "available KnifeMills"],

    (* Warning if amount is more than 40 mL and grinderType is KnifeMill *)
    MatchQ[grinderType, KnifeMill] &&
        myVolumeAmount < 1Milliliter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]];Message[Warning::InsufficientAmount, myAmount, "available KnifeMills"],

    (* Select Model[Instrument, Grinder, "Tube Mill Control"] if amount is greater than 40 Gram and Fineness is greater than 2 and smaller than 10 Millimeter *)
    MatchQ[grinderType, Automatic] && myVolumeAmount > 40Milliliter &&
        fineness > 2 Millimeter && fineness < 10 Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]]; Message[Warning::ExcessiveAmount, myAmount, Model[Instrument, Grinder, "id:zGj91ajA6LYO"]],

    (* Warning if amount is more than 150 mL and grinderType is Automatic *)
    MatchQ[grinderType, Automatic] &&
        myVolumeAmount > 150 Milliliter && fineness <= 2 Millimeter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]; Message[Warning::ExcessiveAmount, myAmount, "available grinders"],

    (* Warning if amount is more than 150 mL and grinderType is Automatic *)
    MatchQ[grinderType, MortarGrinder] &&
        myVolumeAmount > 150 Milliliter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]; Message[Warning::ExcessiveAmount, myAmount, "available grinders"],

    (* Warning if amount is more than 5 and grinderType is MortarGrinder *)
    MatchQ[grinderType, MortarGrinder] &&
        myVolumeAmount < 5 Milliliter,
    AppendTo[preferredGrinders, Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]; Message[Warning::InsufficientAmount, myAmount, "available MortarGrinders"]

  ];

  (* Output is the first grinder in the list, since the list was sorted based on grinder use priority *)
  If[Length[preferredGrinders] < 1, Return[$Failed], First[preferredGrinders]]
];

(* ::Subsection::Closed:: *)
(*PreferredGrindingContainer*)

(* need to set DeveloperObject != True here directly because if someone happens to call TransferDevices with $DeveloperSearch=True the first time in their kernel, then this will memoize to {} and fail for all subsequent uses of this function *)
cachePreferredGrindingContainer[string_] := cachePreferredGrindingContainerPackets[string] = Module[{},
  If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets],
    AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets]
  ];
  Flatten@Download[
    Search[{{Model[Container, GrindingContainer]}}, Deprecated != True && DeveloperObject != True],
    {
      {Packet[Object, Name, MinAmount, MaxAmount, FeedFineness]}
    }
  ]];

preferredGrindingContainerFastCache[string_] := preferredGrindingContainerFastCache[string] = Module[{},
  If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets],
    AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets]
  ];
  Experiment`Private`makeFastAssocFromCache[cachePreferredGrindingContainerPackets["Memoization"]]
];

PreferredGrindingContainer[myGrinder : Alternatives[ObjectP[Model[Instrument, Grinder]], ObjectP[Object[Instrument, Grinder]]], myAmount : (MassP | VolumeP | All), bulkDensity : GreaterP[0Gram / Milliliter]] := Module[
  {myVolumeAmount},

  (*Convert myAmount mass to volume*)
  myVolumeAmount = If[MassQ[myAmount], UnitSimplify[myAmount / bulkDensity], myAmount];

  Which[
    MatchQ[myGrinder, ObjectP[{Model[Instrument, Grinder, "id:O81aEB1lX1Mx"], Object[Instrument, Grinder, "id:bq9LA09a84ma"]}]],
    Model[Container, Vessel, "id:pZx9jo8o0wEP"], (* Model[Container, Vessel, "2mL tube with no skirt"] *)

    MatchQ[myGrinder, ObjectP[{Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"], Object[Instrument, Grinder, "id:vXl9j5l466mB"]}]],
    Which[
      myVolumeAmount <= 1 Milliliter, Model[Container, Vessel, "id:eGakld01zzpq"], (* Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"] *)
      myVolumeAmount <= 7.5 Milliliter, Model[Container, Vessel, "id:xRO9n3vk11pw"], (* Model[Container, Vessel, "15mL Tube"] *)
      True, Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *)
    ],

    MatchQ[myGrinder, ObjectP[{Model[Instrument, Grinder, "id:zGj91ajA6LYO"], Object[Instrument, Grinder, "id:dORYzZRmbBBw"]}]],
    Model[Container, GrindingContainer, "id:8qZ1VWZeG8mp"], (* Model[Container, GrindingContainer, "Grinding Chamber for Tube Mill Control"] *)

    MatchQ[myGrinder, Alternatives[ObjectP[Model[Instrument, Grinder, "id:qdkmxzk16DO0"]], ObjectP[Object[Instrument, Grinder, "Mortar"]]]],
    Model[Container, GrindingContainer, "id:N80DNj09nGxk"] (* Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"] *)
    (*TODO add MixerMill400*)
  ]
];
(* ::Subsection::Closed:: *)
(*ExperimentGrindOptions*)


DefineOptions[ExperimentGrindOptions,
  Options :> {
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }

  },
  SharedOptions :> {ExperimentGrind}];

ExperimentGrindOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions,options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

  (* get only the options for ExperimentGrind *)
  options=ExperimentGrind[myInputs, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentGrind],
    options
  ]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentGrindQ*)


DefineOptions[ValidExperimentGrindQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentGrind}
];


ValidExperimentGrindQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, preparedOptions, experimentGrindTests, initialTestDescription, allTests, verbose, outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentGrind *)
  experimentGrindTests = ExperimentGrind[myInputs, Append[preparedOptions, Output -> Tests]];

  (* define the general test description *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* make a list of all the tests, including the blanket test *)
  allTests = If[MatchQ[experimentGrindTests, $Failed],
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
      Flatten[{initialTest, experimentGrindTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentGrindQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentGrindQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentGrindPreview*)

DefineOptions[ExperimentGrindPreview,
  SharedOptions :> {ExperimentGrind}
];

ExperimentGrindPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (* return only the options for ExperimentGrind *)
  ExperimentGrind[myInputs, Append[noOutputOptions, Output -> Preview]]];