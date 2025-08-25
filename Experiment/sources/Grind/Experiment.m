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
					OpenPaths -> {
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
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, $MaxTransferMass, 0.1 Milligram],
						Units -> {1, {Gram, {Gram, Milligram}}}
					],
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
					Pattern :> RangeP[1 Micrometer, 80 Millimeter, 1 Micrometer],
					Units -> {1, {Millimeter, {Millimeter, Micrometer}}}
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
					Pattern :> RangeP[
						1 Milligram/Milliliter,
						25 Gram/Milliliter,
						1 Milligram/Milliliter
					],
					Units -> CompoundUnit[
						{1, {Gram, {Milligram, Gram, Kilogram}}},
						{-1, {Milliliter, {Microliter, Milliliter, Liter}}}
					]
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
					Pattern :> ObjectP[{
						Model[Container, Vessel],
						Model[Container, GrindingContainer]
					}],
					OpenPaths -> {
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
					OpenPaths -> {
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
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 RPM, 25000 RPM],
						Units -> RPM
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.01 Hertz, 420 Hertz],
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
					Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
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
					Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
					Units -> {1, {Second, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> GrindingProfile,
				Default -> Automatic,
				Description -> "A set of steps of the grinding process, with each step provided as {grinding rate, grinding time} or as {wait time} indicating a cooling period to prevent the sample from overheating.",
				ResolutionDescription -> "Automatically set to reflect the selections of GrindingRate, Time, NumberOfGrindingSteps, and CoolingTime.",
				AllowNull -> False,
				Category -> "Duty Cycle",
				Widget -> Adder[Alternatives[
					"Grinding" -> {
						"Rate" -> Widget[
							Type -> Quantity,
							Pattern :> Alternatives[RangeP[0 RPM, 25000 RPM], RangeP[0 Hertz, 420 Hertz]],
							Units -> Alternatives[RPM, Hertz]
						],
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
							Units -> {1, {Second, {Second, Minute, Hour}}}
						]
					},
					"Cooling" -> {
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Second, $MaxExperimentTime, 1 Second],
							Units -> {1, {Second, {Second, Minute, Hour}}}
						]
					}
				]]
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
				AllowNull -> False,
				Category -> "Storage Information",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
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
				Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their StorageCondition or their Models' DefaultStorageCondition.",
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
		ProtocolOptions,
		SimulationOption,
		NonBiologyPostProcessingOptions,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 1 Gram."
			}
		]
	}
];

(* ::Subsection::Closed:: *)
(* ExperimentGrind Errors and Warnings *)
Warning::InsufficientAmount = "The sample volume(s) `1`, calculated based on sample Amount and BulkDensity, may be too small for efficient grinding of the sample(s) `2` using `3`. Also, check the Instrumentation Table in the help files for ExperimentGrind or ExperimentMeasureMeltingPoint for more information.";
Warning::ExcessiveAmount = "The sample volume(s) `1`, calculated based on sample Amount and BulkDensity, may be too large for efficient grinding of the sample(s) `2` using `3`. Also, check the Instrumentation Table in the help files for ExperimentGrind or ExperimentMeasureMeltingPoint for more grinder options.";
Error::LargeParticles = "Based on the specified Fineness(es), `1`, the particles of the sample(s) `2` might be too large to be ground by `3`.";
Error::GrinderTypeOptionMismatch = "The specified GrinderType(s) do not match the type(s) of the selected grinder(s) for sample(s) `1`. Check these pairings: `2`. Here is the the type(s) of the selected grinder(s): `3`.";
Error::CoolingTimeMismatch = "The CoolingTime is set to Null for sample(s) `1`, however, NumberOfGrindingSteps, `2`, are greater than 1. Either set NumberOfGrindSteps to 1 or set CoolingTime to a time value. Otherwise, leave the option(s) unspecified to calculate automatically.";
Error::HighGrindingRate = "`1`. The MaxGrindingRate of the specified grinders are: `2`. `3`";
Error::LowGrindingRate = "`1`. The MinGrindingRate of the specified grinders are: `2`. `3`";
Error::HighGrindingTime = "`1`. The MaxTime of the specified grinders are: `2`. `3`";
Error::LowGrindingTime = "`1`. The MinTime of the specified grinders are: `2`. `3`";
Warning::ModifiedNumberOfGrindingSteps = "The specified NumberOfGrindingSteps, `1`, do not match the number of Grinding steps in GrindingProfile for sample(s) `2`. NumberOfGrindingSteps is overwritten by the number of grinding steps determined by GrindingProfile.";
Warning::ModifiedGrindingRates = "The specified GrindingRate, `1`, do not match at least one of the grinding rate(s) that are specified in GrindingProfile for sample(s) `2`. GrindingRate is overwritten by grinding rates that are determined in GrindingProfile.";
Warning::ModifiedGrindingTimes = "The specified grinding Time, `1`, do not match at least one of the grinding time(s) that are specified in GrindingProfile for sample(s) `2`. Grinding Time is overwritten by grinding rates that are determined in the GrindingProfile.";
Warning::ModifiedCoolingTimes = "The specified CoolingTime(s), `1`, do not match to at least one of the cooling time(s) that are specified in GrindingProfile for sample(s) `2`. CoolingTime is overwritten by cooling times that are determined in the GrindingProfile.";
Error::InvalidSamplesOutStorageCondition = "Storage conditions of sample(s) `1` are not informed, therefore, the SamplesOutStorageCondition cannot be automatically determined for their corresponding SamplesOut. Please specify SampleOutStorageCondition option or update the StorageCondition of the input sample(s) or DefaultStorageCondition of their model(s).";
Warning::MissingMassInformation = "Mass filed of Sample(s) `1` is empty.";
Error::GrindingContainerMismatch = "The specified grinding container(s) must be compatible with the resolved grinder(s) for `1`. Check these pairings: `2`. Please use the PreferredGrindingContainer function to select the correct container, or leave it unspecified to calculate automatically.";
Error::GrindingBeadMismatch = "The specified GrindingBead, `1`, does not match the specified GrinderType, `2`, for sample(s): `3`. GrindingBead should be specified only if GrinderType is BallMill; otherwise, it should be Null. Both options can be left undetermined to be calculated automatically.";
Error::NumberOfGrindingBeadsMismatch = "The specified NumberOfGrindingBeads, `1`, does not match the specified GrindingBead, `2`, for sample(s) `3`. GrindingBead is used for BallMill only; If the desired GrinderType is BallMill, GrindingBead and NumberOfGrindingBeads should be specified; for grinder types other than BallMill, they should be Null. Alternatively, these options can be left unspecified to be calculated automatically."


(* ::Subsection::Closed:: *)
(* ExperimentGrind *)

(* Mixed Input *)
ExperimentGrind[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Get containers and options as lists. *)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGrind,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 1 Gram
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
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
		result, updatedSimulation, upload, confirm, canaryBranch, fastTrack,
		parentProtocol, cache, downloadedStuff, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		performSimulationQ, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		protocolPacketWithResources, resourcePacketTests, safeOptionsNamed, allContainerModels,
		allGrindingBeadModels, simulatedProtocol, simulation, grinderClampAssemblyModels, grinderClampAssemblyObjects,
		grinderTubeHolderModels, grinderTubeHolderObjects, grindingBeadObjects, optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, allGrindingContainerModels
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentGrind,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
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
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

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
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

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
			{Model[Item, GrindingBead]},
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
			DeveloperObject != True && Status == (Available | Stocked) && Missing != True,
			DeveloperObject != True && Deprecated != True,
			DeveloperObject != True && Status == (Available | Stocked) && Missing != True
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

	(* all grinding containers that are used in PreferredGrindingContainer function *)
	allGrindingContainerModels = {
		Model[Container, Vessel, "id:pZx9joxq0ko9"], (* Model[Container, Vessel, "2 mL conical tube (no skirt) with cap and sealing ring"] *)
		Model[Container, Vessel, "id:eGakld01zzpq"], (* Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"] *)
		Model[Container, Vessel, "id:xRO9n3vk11pw"], (* Model[Container, Vessel, "15mL Tube"] *)
		Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
		Model[Container, GrindingContainer, "id:8qZ1VWZeG8mp"], (* Model[Container, GrindingContainer, "Grinding Chamber for Tube Mill Control"] *)
		Model[Container, GrindingContainer, "id:N80DNj09nGxk"] (* Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"] *)
	};

	containerModels = DeleteDuplicates[Cases[
		Flatten[{
			Lookup[expandedSafeOps, {GrindingContainer, ContainerOut}],
			allGrindingContainerModels
		}],
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
					(*2*){Packet[Name, GrinderType, Objects, MinAmount, MaxAmount, MinTime, MaxTime, FeedFineness, MaxGrindingRate, MinGrindingRate, Positions, AssociatedAccessories]},
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
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

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
	performSimulationQ = MemberQ[output, Result | Simulation];

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
		{Null, updatedSimulation}
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

		(* Actually upload our protocol object. We are being called as a sub-protocol in ExperimentManualSamplePreparation. *)
		True,
		UploadProtocol[
			protocolPacketWithResources[[1]], (*protocol packet*)
			ToList[protocolPacketWithResources[[2]]], (*unit operation packets*)
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> {Object[Protocol, Grind]},
			Cache -> cacheBall,
			Simulation -> simulation
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
		knifeMills, grinderTypeMinAmount, resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, samplePackets, modelPackets,
		sampleContainerPacketsWithNulls, sampleContainerModelPacketsWithNulls, mortarGrinders, cacheBall, sampleDownloads,
		fastAssoc, grinderModelPackets, grinderModels, absoluteMinGrinderVolume, maxFeedFineness, sampleContainerModelPackets,
		sampleContainerPackets, messages, discardedSamplePackets, discardedInvalidInputs, discardedTest, lowAmountMessages,
		mapThreadFriendlyOptions, grindOptionAssociation, optionPrecisions, roundedGrindOptions, precisionTests,
		nonSolidSamplePackets, nonSolidSampleInvalidInputs, nonSolidSampleTest, missingMassSamplePackets, invalidCoolingTimes,
		missingMassInvalidInputs, missingMassTest, highSampleAmounts, lowSampleAmounts, finenessMessages, coolingTimeMismatch,
		resolvedTime, resolvedAmount, resolvedFineness, resolvedBulkDensity, resolvedSampleLabel, resolvedContainerOut,
		resolvedSamplesOutStorageCondition, resolvedGrinderType, resolvedInstrument, resolvedGrindingRate, coolingTimeMismatchTests,
		resolvedNumberOfGrindingSteps, resolvedCoolingTime, resolvedGrindingProfiles, resolvedSampleOutLabel,
		resolvedContainerOutLabel, ratePrecisionsTests,  ratePrecisionWarningQs, timePrecisionWarningQs, timePrecisionsTests,
		resolvedOptions, resolvedGrindingContainer, resolvedGrindingBead, resolvedNumberOfGrindingBeads, outputAmounts,
		invalidSamplesFineness, finenessInvalidOption, invalidSampleFinenessTest, lowAmountOptions, sampleModels,
		grinderTypeMismatches, highAmountMessages, grinderTypeMinVolume, lowAmountTests, maxGrindingTimes, minGrindingTimes,
		grinderTypeMismatchOption, grindTypeMismatchTest, highGrindingRate, highGrindingRates, highGrindingRateOption,
		highGrindingRateTest, lowGrindingRate, lowGrindingRates, lowGrindingRateOption, lowGrindingRateTest, highGrindingTime,
		highGrindingTimes, highGrindingTimeOption, highGrindingTimeTest, lowGrindingTime, lowGrindingTimes,
		lowGrindingTimeOption, lowGrindingTimeTest, containerOutLabel, sampleOutLabel, highAmountOptions, unresolvedAmounts,
		profileGrindingSteps, changedNumberOfGrindingSteps, changedNumbersOfGrindingSteps, changedNumberOfGrindingStepsOption,
		changedNumberOfGrindingStepsTest, rateChangedQ, changedRate, changedRates, changedRateOption, changedRateTest,
		timeChangedQ, changedTime, changedTimes, changedTimeOption, changedTimeTest, profileCoolingSteps,
		changedCoolingTime, coolingTimeChangedQ, changedCoolingTimes, changedCoolingTimeOption, changedCoolingTimeTest, resolvedInstrumentModels,
		rateUnitsChanged, defaultGrindingBead, grindingBeadModels, invalidSamplesOutStorageConditions, namedResolvedInstruments,
		invalidSamplesOutStorageConditionsOptions, invalidSamplesOutStorageConditionsTest, resolvedPostProcessingOptions,
		invalidInputs, invalidOptions, allTests, grindingContainerMismatches, highAmountTests, ratePrecisions, timePrecisions,
		grindingContainerMismatchOptions, grindingBeadMismatches, grindingBeadNumberMismatches, grindingBeadMismatchOption,
		grindingBeadMismatchTest, grindingBeadNumberMismatchOption, grindingBeadNumberMismatchTest, resolvedInstrumentTypes,
		grindingContainerMismatchTest, ratePrecisionOption, timePrecisionOption, minGrindingRates, maxGrindingRates,
		lowGrindingProfileTimes, highGrindingProfileTimes, lowGrindingProfileRates, highGrindingProfileRates,
		lowGrindingProfileTimeTest, highGrindingProfileTimeTest, lowGrindingProfileRateTest, highGrindingProfileRateTest
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
			Packet[Name, Volume, Mass, State, Status, Container, LiquidHandlerIncompatible, Solvent, Position, Model, StorageCondition],
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
	grinderTypeMinVolume = {BallMill -> Min[Lookup[ballMills, MinAmount]], KnifeMill -> Min[Lookup[knifeMills, MinAmount]], MortarGrinder -> Min[Lookup[mortarGrinders, MinAmount]]};

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

	(* look up sample models *)
	sampleModels = Lookup[samplePackets, Model, Null];

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
		{Amount, 0.1 Milligram},
		(* GrindingRate and Time will be rounded for each sample based on the selected Instrument *)
		{CoolingTime, 10^0 Second}
	};

	(* round values for options based on option precisions *)
	{roundedGrindOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[grindOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True, Output -> {Result, Tests}],
		{RoundOptionPrecision[grindOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True], Null}
	];

	(* -- RESOLVE INDEX-MATCHED OPTIONS *)

	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentGrind, roundedGrindOptions];

	(* big MapThread to get all the options resolved *)
	{
		resolvedGrinderType,
		resolvedInstrument,
		resolvedAmount,
		resolvedFineness,
		resolvedBulkDensity,
		resolvedGrindingContainer,
		resolvedGrindingBead,
		resolvedNumberOfGrindingBeads,
		resolvedGrindingRate,
		(*10*)resolvedTime,
		resolvedNumberOfGrindingSteps,
		resolvedCoolingTime,
		resolvedGrindingProfiles,
		resolvedSampleLabel,
		resolvedSampleOutLabel,
		resolvedContainerOut,
		resolvedContainerOutLabel,
		resolvedSamplesOutStorageCondition,
		rateUnitsChanged,
		(*20*)invalidSamplesFineness,
		grinderTypeMismatches,
		highGrindingRates,
		lowGrindingRates,
		highGrindingTimes,
		lowGrindingTimes,
		changedNumbersOfGrindingSteps,
		changedRates,
		changedTimes,
		changedCoolingTimes,
		(*30*)invalidSamplesOutStorageConditions,
		grindingContainerMismatches,
		highSampleAmounts,
		lowSampleAmounts,
		finenessMessages,
		lowAmountMessages,
		highAmountMessages,
		grindingBeadMismatches,
		grindingBeadNumberMismatches,
		invalidCoolingTimes,
		(*40*)ratePrecisionsTests,
		timePrecisionsTests,
		ratePrecisionWarningQs,
		timePrecisionWarningQs,
		ratePrecisions,
		timePrecisions,
		lowGrindingProfileTimes,
		highGrindingProfileTimes,
		lowGrindingProfileRates,
		(*49*)highGrindingProfileRates

	} = Transpose[MapThread[
			Function[{samplePacket, modelPacket, options, sampleContainerPacket, sampleContainerModelPacket},
				Module[
					{
						unresolvedGrinderType, grinderType, unresolvedInstrument, instrument, instrumentModel,
						unresolvedGrindingRate, roundedRate, preferredUnitGrindingRate, preferredGrinderErrors,
						ratePrecision, mortarQ, tubeMillQ, mm400Q, beadGenieQ, finenessMessage, lowAmountMessage,
						highAmountMessage, lowSampleAmount, highSampleAmount, halfResolvedGrinderType, invalidCoolingTime,
						beadBug3Q, unresolvedFineness, unresolvedBulkDensity, unresolvedAmount, amount, numericAmount,
						unresolvedTime, time, optimalTime, timePrecision, roundedTimeOption, unresolvedContainerOut,
						containerOut, numericAll, unresolvedSampleLabel, sampleLabel, unresolvedSampleOutLabel,
						unresolvedContainerOutLabel, preferredGrinderOptions, unresolvedOptions, errorCheckingVariables,
						unresolvedSamplesOutStorageCondition, invalidSamplesOutStorageCondition, ratePrecisionTests,
						unresolvedNumberOfGrindingSteps, numberOfGrindingSteps, unresolvedCoolingTime, coolingTime,
						unresolvedGrindingProfile, grindingProfile, unresolvedGrindingContainer, grindingContainer,
						unresolvedGrindingBead, grindingBead, unresolvedNumberOfGrindingBeads, numberOfGrindingBeads,
						calculatedNumberOfGrindingBeads, grindingContainerMismatch, grindingBeadNumberMismatch,
						grindingContainerModel, grindingContainerFootprint, grindingBeadMismatch, roundedTime,
						timePrecisionTests, ratePrecisionWarningQ, timePrecisionWarningQ, roundedRateOption,
						invalidSampleFineness, grinderTypeMismatch, rateUnitChanged, lowGrindingProfileTime,
						highGrindingProfileTime, timesFromGrindingProfile, lowGrindingProfileRate, highGrindingProfileRate,
						ratesFromGrindingProfile
					},

					(* error checking variables *)
					errorCheckingVariables = {
						invalidSampleFineness,
						grinderTypeMismatch,
						rateUnitChanged,
						invalidSamplesOutStorageCondition,
						grindingContainerMismatch,
						grindingBeadMismatch,
						grindingBeadNumberMismatch,
						invalidCoolingTime,
						ratePrecisionWarningQ,
						timePrecisionWarningQ
					};

					Evaluate[errorCheckingVariables] = ConstantArray[False, Length[Evaluate[errorCheckingVariables]]];

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

					(*For healthy functioning of PreferredGrinder, Convert All to Mass if Amount->All. if the sample does not have mass information, the minimum required amount of the sample is considered for automatic option resolutions*)
					numericAll = If[
						NullQ[Lookup[samplePacket, Mass]],
						UnitSimplify[absoluteMinGrinderVolume * unresolvedBulkDensity],
						Lookup[samplePacket, Mass]
					];

					numericAmount = If[MatchQ[unresolvedAmount, All], numericAll, unresolvedAmount];

					(* determining GrindingBead or NumberOfGrindingBeads options indirectly determines the GrinderType to BalMill *)
					halfResolvedGrinderType = Which[
						And[
							MatchQ[{unresolvedGrinderType, unresolvedInstrument}, {Automatic, Automatic}],
							Or[
								MatchQ[unresolvedGrindingBead, ObjectP[]] && !MatchQ[unresolvedNumberOfGrindingBeads, Null],
								!MatchQ[unresolvedGrindingBead, Null] && MatchQ[unresolvedNumberOfGrindingBeads, _Integer]
							]
						],
							BallMill,

						And[
							MatchQ[{unresolvedGrinderType, unresolvedInstrument}, {Automatic, Automatic}],
							Or[
								MatchQ[unresolvedGrindingBead, Null] && !MatchQ[unresolvedNumberOfGrindingBeads, _Integer],
								!MatchQ[unresolvedGrindingBead, ObjectP[]] && MatchQ[unresolvedNumberOfGrindingBeads, Null]
							]
						],
							DeleteCases[List @@ GrinderTypeP, BallMill],

						True, unresolvedGrinderType
					];

					(* GrinderType, Instrument and Amount depend on each other, so they are resolved together*)
					unresolvedOptions = {unresolvedGrinderType, unresolvedInstrument, unresolvedAmount};

					(* set options for PreferredGrinder. OutputFormat is set to Messages so the function does not throw errors on the fly. it returns error messages as a list of rules *)
					preferredGrinderOptions = {
						GrinderType -> halfResolvedGrinderType,
						Fineness -> unresolvedFineness,
						BulkDensity -> unresolvedBulkDensity,
						OutputFormat -> ErrorType
					};
					
					(* resolve GrinderType, Instrument, and Amount; and collect errors errors thrown from PreferredGrinder *)
					{grinderType, instrument, preferredGrinderErrors, amount} = Which[
						MatchQ[unresolvedOptions, {Except[Automatic], Except[Automatic], Except[Automatic]}],
							{halfResolvedGrinderType, unresolvedInstrument, Null, numericAmount},

						MatchQ[unresolvedOptions, {Automatic, Except[Automatic], Except[Automatic]}],
							{fastAssocLookup[fastAssoc, unresolvedInstrument, GrinderType], unresolvedInstrument, Null, numericAmount},

						MatchQ[unresolvedOptions, {Except[Automatic], Automatic, Except[Automatic]}],
							With[{preferredGrinderOutput = PreferredGrinder[numericAmount, preferredGrinderOptions]},
								{
									halfResolvedGrinderType,
									preferredGrinderOutput[[1]],
									preferredGrinderOutput[[2]],
									numericAmount
								}
							],

						MatchQ[unresolvedOptions, {Except[Automatic], Except[Automatic], Automatic}],
							{
								halfResolvedGrinderType,
								unresolvedInstrument,
								Null,
								UnitSimplify[fastAssocLookup[fastAssoc, unresolvedInstrument, MinAmount] * unresolvedBulkDensity]
							},

						MatchQ[unresolvedOptions, {Automatic, Automatic, Except[Automatic]}],
							With[{preferredGrinderOutput = PreferredGrinder[numericAmount, preferredGrinderOptions]},
								{
									fastAssocLookup[fastAssoc, preferredGrinderOutput[[1]], GrinderType],
									preferredGrinderOutput[[1]],
									preferredGrinderOutput[[2]],
									numericAmount
								}
							],

						MatchQ[unresolvedOptions, {Automatic, Except[Automatic], Automatic}],
							{
								fastAssocLookup[fastAssoc, unresolvedInstrument, GrinderType],
								unresolvedInstrument,
								Null,
								Min[UnitSimplify[fastAssocLookup[fastAssoc, unresolvedInstrument, MinAmount] * unresolvedBulkDensity], numericAll]
							},

						MatchQ[unresolvedOptions, {Except[Automatic], Automatic, Automatic}],
							Module[
								{preferredGrinderOutput, sampleAmount},
								
								grinderTypeMinAmount = UnitSimplify[Lookup[grinderTypeMinVolume, halfResolvedGrinderType] * unresolvedBulkDensity];
								sampleAmount = Min[Flatten[{grinderTypeMinAmount, numericAll}]];
								preferredGrinderOutput = PreferredGrinder[sampleAmount, preferredGrinderOptions];

								{
									halfResolvedGrinderType,
									preferredGrinderOutput[[1]],
									preferredGrinderOutput[[2]],
									sampleAmount
								}
							],

						MatchQ[unresolvedOptions, {Automatic, Automatic, Automatic}],
							With[{preferredGrinderOutput = PreferredGrinder[absoluteMinGrinderVolume, preferredGrinderOptions]},
								{
									fastAssocLookup[fastAssoc, preferredGrinderOutput[[1]], GrinderType],
									preferredGrinderOutput[[1]],
									preferredGrinderOutput[[2]],
									Min[UnitSimplify[absoluteMinGrinderVolume * unresolvedBulkDensity], numericAll]
								}
							]
					];

					(* extract PreferredGrinder error messages *)
					{invalidSampleFineness, lowSampleAmount, highSampleAmount} = If[
						NullQ[preferredGrinderErrors],
						{False, False, False},
						!NullQ[#]& /@ preferredGrinderErrors
					];

					(* Throw and error if the specified GrinderType and the grinder Instrument do not match *)
					grinderTypeMismatch = MatchQ[instrument, ObjectP[]] && Not[MatchQ[grinderType, fastAssocLookup[fastAssoc, instrument, GrinderType]]];

					(*lookup instrument models*)
					instrumentModel = If[
						MatchQ[instrument, ObjectP[Model[Instrument, Grinder]]],
						instrument,
						fastAssocLookup[fastAssoc, instrument, Model]];

					grindingContainer = If[
						MatchQ[unresolvedGrindingContainer, Except[Automatic]],
						unresolvedGrindingContainer,
						PreferredGrindingContainer[instrument, amount, unresolvedBulkDensity]
					];

					(* Lookup Model of the grinding container *)
					grindingContainerModel = If[
						MatchQ[grindingContainer, ObjectP[Model]],
						grindingContainer,
						fastAssocLookup[fastAssoc, grindingContainer, Model]
					];

					(* Lookup Footprint of the grinding container *)
					grindingContainerFootprint = fastAssocLookup[fastAssoc, grindingContainerModel, Footprint];

					(* does the specified grinding container works with the specified / automatically resolved instrument model? *)
					grindingContainerMismatch = Not[TrueQ[grindingContainerMatchQ[instrumentModel, grindingContainerModel, grindingContainerFootprint]]];

					(*resolve GrindingBead*)
					(*extract all grinding beads from fastAssoc*)
					grindingBeadModels = Cases[fastAssoc, ObjectP[Model[Item, GrindingBead]]];

					(*find the first model of grinding bead with a diameter of 2.8 mm and lookup its object*)
					defaultGrindingBead = Lookup[FirstCase[grindingBeadModels, KeyValuePattern[Diameter -> 2.8Millimeter]], Object];

					(*resolve GrindingBead and flip error switch if needed*)
					{grindingBead, grindingBeadMismatch} = Which[
						(* GrindingBead is used with BallMills only *)
						(* If GrindingBead is set to an Object and GrinderType is BallMill, error switch is False *)
						MatchQ[unresolvedGrindingBead, Except[Automatic | Null]] && MatchQ[grinderType, BallMill],
							{unresolvedGrindingBead, False},

						(* If GrindingBead is set to an Object but GrinderType is not BallMill, flip the error switch *)
						MatchQ[unresolvedGrindingBead, Except[Automatic | Null]] && MatchQ[grinderType, Except[BallMill]],
							{unresolvedGrindingBead, True},

						(* If GrindingBead is set to Null but GrinderType is BallMill, flip the error switch *)
						MatchQ[unresolvedGrindingBead, Null] && MatchQ[grinderType, BallMill],
							{unresolvedGrindingBead, True},

						(* If GrindingBead is set to Null but GrinderType is not BallMill, error switch is False *)
						MatchQ[unresolvedGrindingBead, Null] && MatchQ[grinderType, Except[BallMill]],
							{unresolvedGrindingBead, False},

						(* If GrindingBead is Automatic and GrinderType is BallMill, resolve GrindingBead to the default model; error switch is False *)
						MatchQ[unresolvedGrindingBead, Automatic] && MatchQ[grinderType, BallMill],
							{defaultGrindingBead, False},

						(* the only other case is when GrindingBead is Automatic and GrinderType is not BallMill. In that case, GrindingBead resolves to Null and error switch is off *)
						True, {Null, False}
					];

					(* resolve GrindingBead numbers and error switch based on the resolved GrindingBead *)
					{numberOfGrindingBeads, grindingBeadNumberMismatch} = Which[
						(* If GrindingBead is set to an Object and NumberOfGrindingBeads is set to a number, error switch is False *)
						MatchQ[unresolvedNumberOfGrindingBeads, Except[Automatic | Null]] && MatchQ[grindingBead, Except[Null]],
							{unresolvedNumberOfGrindingBeads, False},

						(* If GrindingBead is set to Null and NumberOfGrindingBeads is set to a number, error switch flips on *)
						MatchQ[unresolvedNumberOfGrindingBeads, Except[Automatic | Null]] && MatchQ[grindingBead, Null],
							{unresolvedNumberOfGrindingBeads, True},

						(* If GrindingBead is set to Null and NumberOfGrindingBeads is set to a number, error switch is False *)
						MatchQ[unresolvedNumberOfGrindingBeads, Null] && MatchQ[grindingBead, Null],
							{unresolvedNumberOfGrindingBeads, False},

						(* If GrindingBead is set to an object and NumberOfGrindingBeads is set to Null, error switch flips on *)
						MatchQ[unresolvedNumberOfGrindingBeads, Null] && MatchQ[grindingBead, Except[Null]],
							{unresolvedNumberOfGrindingBeads, True},

						(* If GrindingBead is set to an object and NumberOfGrindingBeads is Automatic, calculate NumberOfGrindingBeads. error switch is off *)
						MatchQ[unresolvedNumberOfGrindingBeads, Automatic] && MatchQ[grindingBead, Except[Null]],
							(*Calculate sample volume, then estimate number of required beads, considering 50% void volume*)
							(*the calculated number is then rounded to an integer.*)
							calculatedNumberOfGrindingBeads = Round[UnitSimplify[
								(0.5 * (amount) / (unresolvedBulkDensity)) / ((4 / 3) * Pi * (fastAssocLookup[fastAssoc, grindingBead, Diameter] / 2)^3)]
							];
							(*If the final integer is less than 1, 1 is returned. If the final integer is greater than 20, 20 is returned.*)
							{Max[1, Min[20, calculatedNumberOfGrindingBeads]], False},

						(* the only other case is that NumberOfGrindingBead is Automatic and GrindingBead is Null so NumberOfGrindingBead is resolved to Null, with error switch set False *)
						True, {Null, False}
					];


					(**** Check Grinding Rates and Times in GrindingProfile if it's not Automatic ****)
					(* check if grinding rates in GrindingProfile are out of instrument range *)
					ratesFromGrindingProfile = Cases[Flatten[{unresolvedGrindingProfile}], RPMP | FrequencyP] /. {rate : FrequencyP :> (QuantityMagnitude[rate]*60)RPM};

					(* Throw an error if any of the specified rates in GrindingProfile is greater than the max rate of the selected grinder *)
					highGrindingProfileRate = MemberQ[Map[GreaterQ[#, fastAssocLookup[fastAssoc, instrument, MaxGrindingRate]]&, ratesFromGrindingProfile], True];

					(* Throw an error if any of the specified grinding times in GrindingProfile is less than the min time of the selected grinder *)
					lowGrindingProfileRate = MemberQ[Map[LessQ[#, fastAssocLookup[fastAssoc, instrument, MinGrindingRate]]&, ratesFromGrindingProfile], True];

					(* check if grinding times in GrindingProfile are out of instrument range *)
					timesFromGrindingProfile = Cases[unresolvedGrindingProfile, {rate : RPMP | FrequencyP, time : TimeP} :> time];

					(* Throw an error if any of the specified times in GrindingProfile is greater than the max time of the selected grinder *)
					highGrindingProfileTime = MemberQ[Map[GreaterQ[#, fastAssocLookup[fastAssoc, instrument, MaxTime]]&, timesFromGrindingProfile], True];

					(* Throw an error if any of the specified grinding times in GrindingProfile is less than the min time of the selected grinder *)
					lowGrindingProfileTime = MemberQ[Map[LessQ[#, fastAssocLookup[fastAssoc, instrument, MinTime]]&, timesFromGrindingProfile], True];

					(* Round GrindingRate and Time based on the selected grinder Instrument *)
					(* Determine the model of the selected grinder *)
					beadBug3Q = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]];

					beadGenieQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]];

					mm400Q = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]]];

					tubeMillQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:zGj91ajA6LYO"]]];

					mortarQ = MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]];

					(* The following code block converts GrindingRate to the instrument unit: RPM for BeadBug3, BeadGenie, AutomatedMortarGrinder, and TubeMillControl; Hertz for MixerMill MM400 *)
					(* Additionally, the following block determines sets the ratePrecision, optimalTime, and timePrecision. *)
					{{preferredUnitGrindingRate, rateUnitChanged}, ratePrecision, optimalTime, timePrecision} = Which[
						beadBug3Q, {
							Which[
								MatchQ[unresolvedGrindingRate, Automatic], {2800 RPM, False},
								RPMQ[unresolvedGrindingRate], {unresolvedGrindingRate, False},
								FrequencyQ[unresolvedGrindingRate], {(QuantityMagnitude[unresolvedGrindingRate]*60)RPM, True}
							],
							100 RPM, 10 Second, 10^0 Second
						},

						beadGenieQ, {
							Which[
								MatchQ[unresolvedGrindingRate, Automatic], {2000 RPM, False},
								RPMQ[unresolvedGrindingRate], {unresolvedGrindingRate, False},
								FrequencyQ[unresolvedGrindingRate], {(QuantityMagnitude[unresolvedGrindingRate]*60)RPM, True}
							],
							5 RPM, 30 Second, 10^0 Second
						},

						mm400Q, {
							Which[
								MatchQ[unresolvedGrindingRate, Automatic], {20 Hertz, False},
								FrequencyQ[unresolvedGrindingRate], {unresolvedGrindingRate, False},
								RPMQ[unresolvedGrindingRate], {(QuantityMagnitude[unresolvedGrindingRate]/60)Hertz, True}
							],
							0.1 Hertz, 30 Second, 10^0 Second
						},

						tubeMillQ, {
							Which[
								MatchQ[unresolvedGrindingRate, Automatic], {5000 RPM, False},
								RPMQ[unresolvedGrindingRate], {unresolvedGrindingRate, False},
								FrequencyQ[unresolvedGrindingRate], {(QuantityMagnitude[unresolvedGrindingRate]*60)RPM, True}
							],
							100 RPM, 15 Second, 5 Second
						},

						mortarQ, {
							Which[
								MatchQ[unresolvedGrindingRate, Automatic], {70 RPM, False},
								RPMQ[unresolvedGrindingRate], {unresolvedGrindingRate, False},
								FrequencyQ[unresolvedGrindingRate], {(QuantityMagnitude[unresolvedGrindingRate]*60)RPM, True}
							],
							10 RPM, 60 Minute, 10^0 Minute
						},

						MatchQ[instrument, $Failed], {{unresolvedGrindingRate, False}, 1 RPM, Null, 1 Second}
					];

					(* Round Rate values *)
					(* using RoundOptionPrecision here in the resolver MapThread throws a warning for each sample.
					 To prevent that, the Messages is Off here; the messages are collected and thrown altogether in one message for each option at the end *)
					{roundedRateOption, ratePrecisionTests} = If[gatherTests,
						RoundOptionPrecision[
							<|GrindingRate -> preferredUnitGrindingRate|>,
							GrindingRate,
							ratePrecision,
							AvoidZero -> True,
							Output -> {Result, Tests},
							Messages -> False
						],
						{
							RoundOptionPrecision[
								<|GrindingRate -> preferredUnitGrindingRate|>,
								GrindingRate,
								ratePrecision,
								AvoidZero -> True,
								Messages -> False
							],
							Null
						}
					];

					roundedRate = Lookup[roundedRateOption, GrindingRate];

					(* check to see if precision warning was thrown *)
					ratePrecisionWarningQ = If[
						TrueQ[Quiet[
							Check[
								RoundOptionPrecision[
									<|GrindingRate -> preferredUnitGrindingRate|>,
									GrindingRate,
									ratePrecision,
									AvoidZero -> True
								], True, Warning::InstrumentPrecision
							]
						]],
						True,
						False
					];

					(* Round Time values *)
					(* using RoundOptionPrecision here in the resolver MapThread throws a warning for each sample.
					To prevent that, the Messages is Off here; the messages are collected and thrown altogether in one message for each option at the end *)
					{roundedTimeOption, timePrecisionTests} = If[gatherTests,
						RoundOptionPrecision[
							<|Time -> unresolvedTime|>,
							Time,
							timePrecision,
							AvoidZero -> True,
							Output -> {Result, Tests},
							Messages -> False
						],
						{
							RoundOptionPrecision[
								<|Time -> unresolvedTime|>,
								Time,
								timePrecision,
								AvoidZero -> True,
								Messages -> False
							],
							Null
						}
					];

					roundedTime = Lookup[roundedTimeOption, Time];

					(* check to see if precision warning was thrown *)
					timePrecisionWarningQ = If[
						TrueQ[Quiet[
							Check[
								RoundOptionPrecision[
									<|Time -> unresolvedTime|>,
									Time,
									timePrecision,
									AvoidZero -> True
								], True, Warning::InstrumentPrecision
							]
						]],
						True,
						False
					];

					(* Throw an error if the specified rate is greater than the max rate of the selected grinder *)
					highGrindingRate = TrueQ[GreaterQ[
						roundedRate /. {rate : FrequencyP :> (QuantityMagnitude[rate] * 60)RPM},
						fastAssocLookup[fastAssoc, instrument, MaxGrindingRate]
					]];

					(* Throw an error if the specified rate is smaller than the min rate of the selected grinder *)
					lowGrindingRate = TrueQ[LessQ[
						roundedRate /. {rate : FrequencyP :> (QuantityMagnitude[rate] * 60)RPM},
						fastAssocLookup[fastAssoc, instrument, MinGrindingRate]
					]];

					(* Resolve Time *)
					time = If[
						MatchQ[roundedTime, Except[Automatic]],
						roundedTime,
						optimalTime
					];

					(* Throw an error if the specified Time is greater than the max grinding time of the selected grinder *)
					highGrindingTime = GreaterQ[time, fastAssocLookup[fastAssoc, instrument, MaxTime]];

					(* Throw an error if the specified Time is smaller than the min grinding time of the selected grinder *)
					lowGrindingTime = LessQ[time, fastAssocLookup[fastAssoc, instrument, MinTime]];

					(* NumberOfGrindingSteps, AllowNull:False *)
					numberOfGrindingSteps = Which[
						MatchQ[unresolvedNumberOfGrindingSteps, Except[Automatic]],
						unresolvedNumberOfGrindingSteps,
						MatchQ[unresolvedGrindingProfile, Except[Automatic]],
						Count[Flatten[unresolvedGrindingProfile], RPMP | FrequencyP],
						MatchQ[unresolvedNumberOfGrindingSteps, Automatic],
						1
					];

					(* CoolingTime *)
					coolingTime = Which[
						MatchQ[unresolvedCoolingTime, Except[Automatic]], unresolvedCoolingTime,
						MatchQ[unresolvedCoolingTime, Automatic] && GreaterQ[numberOfGrindingSteps, 1], 30 Second,
						True, Null
					];

					(* throw an error if numberOfGrindingSteps is more than 1 but CoolingTime is Null *)
					invalidCoolingTime = NullQ[coolingTime] && GreaterQ[numberOfGrindingSteps, 1] && MatchQ[unresolvedGrindingProfile, Automatic];

					(*GrindingProfile*)
					grindingProfile = If[
						MatchQ[unresolvedGrindingProfile, Except[Automatic]],
						unresolvedGrindingProfile,
						Most[Join @@ ConstantArray[{{roundedRate, time}, {coolingTime}}, numberOfGrindingSteps]]
					];

					(* Throw a warning if the specified GrindingRate, Time, and number of steps are different from specified GrindingProfile *)
					(* Extract Grinding steps from grindingProfile *)
					profileGrindingSteps = Cases[grindingProfile, {RPMP | FrequencyP, TimeP}];

					(* Throw a warning if the specified NumberOfGrindingSteps is different from number of grinding steps in GrindingProfile *)
					changedNumberOfGrindingSteps = Length[profileGrindingSteps] != numberOfGrindingSteps;

					(* Throw a warning if the specified GrindingRate (if not automatic) is different from any specified rates in GrindingProfile *)
					(* Are any of the rates in profileGrindingSteps different from roundedRate? *)
					rateChangedQ = roundedRate != #& /@ profileGrindingSteps[[All, 1]];

					changedRate = MemberQ[rateChangedQ, True] && Not[MatchQ[unresolvedGrindingRate, Automatic]];

					(* Throw a warning if the specified grinding Time is different from any specified grinding times in GrindingProfile *)
					(* Are any of the grinding times in profileGrindingSteps different from specified Time? *)
					timeChangedQ = time != #& /@ profileGrindingSteps[[All, 2]];

					changedTime = MemberQ[timeChangedQ, True] && Not[MatchQ[unresolvedTime, Automatic]];

					(* Throw a warning if any of the specified cooling rates is not 0 RPM or CoolingTime is different from any of the specified cooling times in GrindingProfile *)
					(* Extract Cooling steps from grindingProfile *)
					profileCoolingSteps = Cases[grindingProfile, {TimeP}];

					(* Throw a warning if CoolingTime is different from any of the specified cooling times in GrindingProfile *)
					(* Are any of the cooling times in profileGrindingSteps different from specified CoolingTime? *)
					coolingTimeChangedQ = coolingTime != #& /@ profileCoolingSteps[[All, 1]];
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
					invalidSamplesOutStorageCondition = And[
						NullQ[unresolvedSamplesOutStorageCondition],
						NullQ[Lookup[samplePacket, StorageCondition, Null]],
						Or[
							NullQ[modelPacket],
							NullQ[Lookup[modelPacket, DefaultStorageCondition, Null]]
						]
					];

					{
						grinderType,
						instrument,
						amount,
						unresolvedFineness,
						unresolvedBulkDensity,
						grindingContainer,
						grindingBead,
						numberOfGrindingBeads,
						roundedRate,
						(*10*)time,
						numberOfGrindingSteps,
						coolingTime,
						grindingProfile,
						sampleLabel,
						sampleOutLabel,
						containerOut,
						containerOutLabel,
						unresolvedSamplesOutStorageCondition,
						rateUnitChanged,
						(*20*)invalidSampleFineness,
						grinderTypeMismatch,
						highGrindingRate,
						lowGrindingRate,
						highGrindingTime,
						lowGrindingTime,
						changedNumberOfGrindingSteps,
						changedRate,
						changedTime,
						changedCoolingTime,
						(*30*)invalidSamplesOutStorageCondition,
						grindingContainerMismatch,
						highSampleAmount,
						lowSampleAmount,
						finenessMessage,
						lowAmountMessage,
						highAmountMessage,
						grindingBeadMismatch,
						grindingBeadNumberMismatch,
						invalidCoolingTime,
						(*40*)ratePrecisionTests,
						timePrecisionTests,
						ratePrecisionWarningQ,
						timePrecisionWarningQ,
						ratePrecision,
						timePrecision,
						lowGrindingProfileTime,
						highGrindingProfileTime,
						lowGrindingProfileRate,
						(*49*)highGrindingProfileRate
					}
				]
			],
			{samplePackets, modelPackets, mapThreadFriendlyOptions, sampleContainerPackets, sampleContainerModelPackets}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* look up some resolved instrument data *)
	resolvedInstrumentModels = Download[If[
		MatchQ[#, ObjectP[Model[]]],
		#,
		fastAssocLookup[fastAssoc, #, Model]
	]& /@ resolvedInstrument, Object];

	resolvedInstrumentTypes = fastAssocLookup[fastAssoc, resolvedInstrumentModels, GrinderType];

	(* obtain named form instruments to use in messages *)
	namedResolvedInstruments = ObjectToString[#, Cache -> cacheBall]& /@ resolvedInstrument;

	(* if Amount is All, use that for the resolved amount option *)
	unresolvedAmounts = Lookup[mapThreadFriendlyOptions, Amount];
	outputAmounts = MapThread[If[MatchQ[#1, All], #1, Round[#2, 0.0001]]&, {unresolvedAmounts, resolvedAmount}];

	(* throw a warning if sample amount is too low or too low *)
	lowAmountOptions = If[MemberQ[lowSampleAmounts, True] && messages,
		(
			Message[
				Warning::InsufficientAmount,
				"",
				ObjectToString[PickList[simulatedSamples, lowSampleAmounts], Cache -> cacheBall],
				"calculated/specified grinders. Please use PreferredGrinder function for more details"
			];
			{Amount}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	lowAmountTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, lowSampleAmounts];
			passingInputs = PickList[simulatedSamples, lowSampleAmounts, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The amount of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " are more than the minAmount of grinders.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The amount of the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " are more than the MinAmount of grinders.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw a warning if sample amount is too low or too low *)
	highAmountOptions = If[MemberQ[highSampleAmounts, True] && messages,
		(
			Message[
				Warning::ExcessiveAmount,
				"",
				ObjectToString[PickList[simulatedSamples, highSampleAmounts], Cache -> cacheBall],
				"calculated/specified grinders. Please use PreferredGrinder function for more details."
			];
			{Amount}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	highAmountTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, highSampleAmounts];
			passingInputs = PickList[simulatedSamples, highSampleAmounts, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The amount of the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " are less than the maxAmount of grinders.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The amount of the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " are less than the MaxAmount of grinders.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if the specified Fineness is greater than the max FeedFineness of the grinders available at ECL *)
	finenessInvalidOption = If[MemberQ[invalidSamplesFineness, True] && messages,
		(
			Message[
				Error::LargeParticles,
				ObjectToString[PickList[resolvedFineness, invalidSamplesFineness], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, invalidSamplesFineness], Cache -> cacheBall],
				"calculated/specified grinders. Please use PreferredGrinder function for more details."
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
				Test["The largest particles of the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " are smaller than than the maximum FeedFineness of grinders.", True, True],
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

				ObjectToString[PickList[simulatedSamples, grinderTypeMismatches], Cache -> cacheBall],

				ObjectToString[DeleteDuplicates[Transpose[{
					PickList[resolvedInstrument, grinderTypeMismatches],
					PickList[resolvedGrinderType, grinderTypeMismatches]
				}]], Cache -> cacheBall],

				ObjectToString[DeleteDuplicates[PickList[
					Transpose[{resolvedInstrumentModels, resolvedInstrumentTypes}],
					grinderTypeMismatches]
				], Cache -> cacheBall]
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
				Test["The specified GrinderType(s) and type(s) of the specified grinder Instrument(s) match for the following sample(s), " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw and error if the specified GrindingBead and GrinderType do not match *)
	grindingBeadMismatchOption = If[MemberQ[grindingBeadMismatches, True] && messages,
		(
			Message[
				Error::GrindingBeadMismatch,
				ObjectToString[PickList[resolvedGrindingBead, grindingBeadMismatches], Cache -> cacheBall],
				ObjectToString[PickList[resolvedGrinderType, grindingBeadMismatches], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, grindingBeadMismatches], Cache -> cacheBall]
			];
			{GrindingBead}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	grindingBeadMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, grindingBeadMismatches];
			passingInputs = PickList[simulatedSamples, grindingBeadMismatches, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified GrinderBead does not match the specified GrinderType for the following sample(s), " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified GrinderBead does not match the specified GrinderType for the following sample(s), " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw and error if the specified NumberOfGrindingBeads and GrindingBead do not match *)
	grindingBeadNumberMismatchOption = If[MemberQ[grindingBeadNumberMismatches, True] && messages,
		(
			Message[
				Error::NumberOfGrindingBeadsMismatch,
				ObjectToString[PickList[resolvedNumberOfGrindingBeads, grindingBeadNumberMismatches], Cache -> cacheBall],
				ObjectToString[PickList[resolvedGrindingBead, grindingBeadNumberMismatches], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, grindingBeadNumberMismatches], Cache -> cacheBall]
			];
			{NumberOfGrindingBeads, GrindingBead}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	grindingBeadNumberMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, grindingBeadNumberMismatches];
			passingInputs = PickList[simulatedSamples, grindingBeadNumberMismatches, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified NumberOfGrinderBeads does not match the specified GrindingBead for the following sample(s), " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified NumberOfGrinderBeads does not match the specified GrindingBead for the following sample(s), " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* lookup MaxGrindingRate, MinGrindingRate, MaxTime, and MinTime of the resolved instruments *)
	{
		maxGrindingRates,
		minGrindingRates,
		maxGrindingTimes,
		minGrindingTimes
	} = fastAssocLookup[fastAssoc, resolvedInstrument, #]& /@ {
		MaxGrindingRate,
		MinGrindingRate,
		MaxTime,
		MinTime
	};

	(* Throw an error if the specified rate is greater than the max rate of the selected grinder *)
	highGrindingRateOption = Switch[{messages, MemberQ[highGrindingProfileRates, True], MemberQ[highGrindingRates, True]},
		{False, _, _} | {_, False, False},
			{},

		{_, False, True},
			(
				Message[
					Error::HighGrindingRate,

					"The specified GrindingRate(s) for sample(s) " <> ObjectToString[PickList[resolvedInstrument, highGrindingRates], Cache -> cacheBall] <> " is greater than the MaxGrindingRate of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, maxGrindingRates}], highGrindingProfileRates]]],

					"Change GrindingRate(s) accordingly or leave it unspecified to calculate automatically."
				];

				{GrindingRate}
			),

		{_, True, False},
			(
				Message[
					Error::HighGrindingRate,

					"At least one of the specified grinding rate(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingProfileRates], Cache -> cacheBall] <> " is greater than the MaxGrindingRate of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, maxGrindingRates}], highGrindingProfileRates]]],

					"Change the grinding rates in GrindingProfile accordingly or leave them unspecified to calculate automatically."
				];

				{GrindingProfile}
			),

		{_, True, True},
			(
				With[{allHighRateErrorQs = MapThread[Or, {highGrindingProfileRates, highGrindingRates}]},
					Message[
						Error::HighGrindingRate,

						"At least one of the specified grinding rate(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingProfileRates], Cache -> cacheBall] <> " is greater than the MaxGrindingRate of the specified grinder(s). Also, the specified GrindingRate(s) for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingRates], Cache -> cacheBall] <> " are greater than the MaxGrindingRate of the specified grinder(s)",

						Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, allHighRateErrorQs}], highGrindingRates]]],

						"Change GrindingProfile's grinding rate(s) and GrindingRate(s) of the specified samples accordingly or leave them unspecified to be calculated automatically."
					]
				];

				{GrindingRate, GrindingProfile}
			)
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
				Test["The specified GrindingRate(s) are equal to or smaller than the maximum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	highGrindingProfileRateTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, highGrindingProfileRates];
			passingInputs = PickList[simulatedSamples, highGrindingProfileRates, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified grinding rates in GrindingProfile are equal to or smaller than the maximum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified grinding rate(s) are equal to or smaller than the maximum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if the specified rate is smaller than the min rate of the selected grinder *)
	lowGrindingRateOption = Switch[{messages, MemberQ[lowGrindingProfileRates, True], MemberQ[lowGrindingRates, True]},
		{False, _, _} | {_, False, False},
			{},

		{_, False, True},
			(
				Message[
					Error::LowGrindingRate,

					"The specified GrindingRate(s) for sample(s) " <> ObjectToString[PickList[resolvedInstrument, lowGrindingRates], Cache -> cacheBall] <> " is smaller than the MinGrindingRate of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, minGrindingRates}], lowGrindingProfileRates]]],

					"Change GrindingRate(s) accordingly or leave it unspecified to calculate automatically."
				];

				{GrindingRate}
			),

		{_, True, False},
		(
			Message[
				Error::LowGrindingRate,

				"At least one of the specified grinding rate(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingProfileRates], Cache -> cacheBall] <> " is smaller than the MinGrindingRate of the specified grinder(s)",

				Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, minGrindingRates}], lowGrindingProfileRates]]],

				"Change the grinding rates in GrindingProfile accordingly or leave them unspecified to calculate automatically."
			];

			{GrindingProfile}
		),

		{_, True, True},
		(
			With[{allLowRateErrorQs = MapThread[Or, {lowGrindingProfileRates, lowGrindingRates}]},
				Message[
					Error::LowGrindingRate,

					"At least one of the specified grinding rate(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingProfileRates], Cache -> cacheBall] <> " is smaller than the MinGrindingRate of the specified grinder(s). Also, the specified GrindingRate(s) for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingRates], Cache -> cacheBall] <> " are smaller than the MinGrindingRate of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, allLowRateErrorQs}], lowGrindingRates]]],

					"Change GrindingProfile's grinding rate(s) and GrindingRate(s) of the specified samples accordingly or leave them unspecified to be calculated automatically."
				]
			];

			{GrindingRate, GrindingProfile}
		)
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
				Test["The specified GrindingRate(s) are equal to or greater than the minimum GrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	lowGrindingProfileRateTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, lowGrindingProfileRates];
			passingInputs = PickList[simulatedSamples, lowGrindingProfileRates, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified grinding rates in GrindingProfile are equal to or greater than the MinGrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified grinding rates in GrindingProfile are equal to or greater than the MinGrindingRate of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if the specified Time is greater than the max grinding time of the selected grinder *)
	highGrindingTimeOption = Switch[{messages, MemberQ[highGrindingProfileTimes, True], MemberQ[highGrindingTimes, True]},
		{False, _, _} | {_, False, False},
			{},

		{_, False, True},
			(
				Message[
					Error::HighGrindingTime,
					
					"The specified grinding Time(s) for sample(s) " <> ObjectToString[PickList[resolvedInstrument, highGrindingTimes], Cache -> cacheBall] <> " is greater than the MaxTime of the specified grinder(s)",
					
					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, maxGrindingTimes}], highGrindingProfileTimes]]],
					
					"Change Time accordingly or leave it unspecified to calculate automatically."
				];
				
				{Time}
			),

		{_, True, False},
			(
				Message[
					Error::HighGrindingTime,
					
					"At least one of the specified grinding Time(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingProfileTimes], Cache -> cacheBall] <> " is greater than the MaxTime of the specified grinder(s)",
					
					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, maxGrindingTimes}], highGrindingProfileTimes]]],
					
					"Change the grinding times in GrindingProfile accordingly or leave them unspecified to calculate automatically."
				];
				
				{GrindingProfile}
			),

		{_, True, True},
			(
				With[{allHighTimeErrorQs = MapThread[Or, {highGrindingProfileTimes, highGrindingTimes}]},
					Message[
						Error::HighGrindingTime,
						
						"At least one of the specified grinding Time(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingProfileTimes], Cache -> cacheBall] <> " is greater than the MaxTime of the specified grinder(s). Also, the specified grinding Time(s) for sample(s) " <> ObjectToString[PickList[simulatedSamples, highGrindingTimes], Cache -> cacheBall] <> " are greater than the MaxTime of the specified grinder(s)",
						
						Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, allHighTimeErrorQs}], highGrindingTimes]]],
						
						"Change GrindingProfile's grinding time(s) and Time(s) of the specified samples accordingly or leave them unspecified to be calculated automatically."
					]
				];
				
				{Time, GrindingProfile}
			)
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
				Test["The specified grinding Time(s) are equal to or smaller than the maximum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	highGrindingProfileTimeTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, highGrindingProfileTimes];
			passingInputs = PickList[simulatedSamples, highGrindingProfileTimes, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified grinding times in GrindingProfile are equal to or smaller than the maximum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified grinding times in GrindingProfile are equal to or smaller than the maximum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if the specified Time is smaller than the min grinding time of the selected grinder *)
	lowGrindingTimeOption = Switch[{messages, MemberQ[lowGrindingProfileTimes, True], MemberQ[lowGrindingTimes, True]},

		{False, _, _} | {_, False, False},
			{},

		{_, False, True},
			(
				Message[
					Error::LowGrindingTime,

					"The specified grinding Time(s) for sample(s) " <> ObjectToString[PickList[resolvedInstrument, lowGrindingTimes], Cache -> cacheBall] <> " is smaller than the MinTime of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, minGrindingTimes}], lowGrindingProfileTimes]]],

					"Change Time accordingly or leave it unspecified to calculate automatically."
				];

				{Time}
			),

		{_, True, False},
			(
				Message[
					Error::LowGrindingTime,

					"At least one of the specified grinding Time(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingProfileTimes], Cache -> cacheBall] <> " is smaller than the MinTime of the specified grinder(s)",

					Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, minGrindingTimes}], lowGrindingProfileTimes]]],

					"Change the grinding times in GrindingProfile accordingly or leave them unspecified to calculate automatically."
				];

				{GrindingProfile}
			),

		{_, True, True},
			(
				With[{allLowTimeErrorQs = MapThread[Or, {lowGrindingProfileTimes, lowGrindingTimes}]},
					Message[
						Error::LowGrindingTime,

						"At least one of the specified grinding Time(s) in the GrindingProfile for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingProfileTimes], Cache -> cacheBall] <> " is smaller than the MinTime of the specified grinder(s). Also, the specified grinding Time(s) for sample(s) " <> ObjectToString[PickList[simulatedSamples, lowGrindingTimes], Cache -> cacheBall] <> " are greater than the MinTime of the specified grinder(s)",

						Map[StringRiffle[#, ": "]&, DeleteDuplicates[PickList[Transpose[{namedResolvedInstruments, allLowTimeErrorQs}], lowGrindingTimes]]],

						"Change GrindingProfile's grinding time(s) and Time(s) of the specified samples accordingly or leave them unspecified to be calculated automatically."
					]
				];

				{Time, GrindingProfile}
			)
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
				Test["The specified grinding Time(s) are equal to or greater than the minimum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	lowGrindingProfileTimeTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, lowGrindingTimes];
			passingInputs = PickList[simulatedSamples, lowGrindingTimes, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified grinding times in GrindingProfile are equal to or greater than the minimum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified grinding times in GrindingProfile are equal to or greater than the minimum grinding time that can be set by the timer of the specified Instrument for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an error if NumberOfGrindingSteps is greater than 1 but CoolingTime is Null *)
	coolingTimeMismatch = If[MemberQ[invalidCoolingTimes, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Error::CoolingTimeMismatch,
				ObjectToString[PickList[simulatedSamples, invalidCoolingTimes], Cache -> cacheBall],
				ObjectToString[PickList[resolvedNumberOfGrindingSteps, invalidCoolingTimes], Cache -> cacheBall]
			];
			{CoolingTime}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	coolingTimeMismatchTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, invalidCoolingTimes];
			passingInputs = PickList[simulatedSamples, invalidCoolingTimes, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["If NumberOfGrindingSteps is greater than 1, CoolingTime is not Null for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["If NumberOfGrindingSteps is greater than 1, CoolingTime is not Null for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
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
				ObjectToString[PickList[resolvedNumberOfGrindingSteps, changedNumbersOfGrindingSteps], Cache -> cacheBall],
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
				Warning["The specified NumberOfGrindingSteps is equal to the number of grinding steps in GrindingProfile for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
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
				ObjectToString[PickList[resolvedGrindingRate, changedRates], Cache -> cacheBall],
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
				Warning["All specified grinding rate(s) in GrindingProfile are equal to the specified grinding Rate(s) for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw a warning if rate changes due to precision *)
	ratePrecisionOption = If[MemberQ[ratePrecisionWarningQs, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InstrumentPrecision,
				ToString[GrindingRate],
				ObjectToString[PickList[ratePrecisions, ratePrecisionWarningQs], Cache -> cacheBall],
				ObjectToString[PickList[Lookup[grindOptionAssociation, GrindingRate], ratePrecisionWarningQs], Cache -> cacheBall],
				ObjectToString[PickList[resolvedGrindingRate, ratePrecisionWarningQs], Cache -> cacheBall]
			];
			{}
		),
		{}
	];

	(* Throw a warning if the specified grinding Time is different from any of the specified grinding times in GrindingProfile *)
	changedTimeOption = If[MemberQ[changedTimes, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::ModifiedGrindingTimes,
				ObjectToString[PickList[resolvedTime, changedTimes], Cache -> cacheBall],
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
				Warning["All specified grinding times in GrindingProfile are equal to the specified grinding Time(s) for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw a warning if time changes due to precision *)
	timePrecisionOption = If[MemberQ[timePrecisionWarningQs, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::InstrumentPrecision,
				ToString[Time],
				ObjectToString[PickList[timePrecisions, timePrecisionWarningQs], Cache -> cacheBall],
				ObjectToString[PickList[Lookup[grindOptionAssociation, Time], timePrecisionWarningQs], Cache -> cacheBall],
				ObjectToString[PickList[resolvedTime, timePrecisionWarningQs], Cache -> cacheBall]
			];
			{}
		),
		{}
	];

	(* Throw a warning if the specified CoolingTime is different from any of the specified cooling times in GrindingProfile *)
	changedCoolingTimeOption = If[MemberQ[changedCoolingTimes, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Warning::ModifiedCoolingTimes,
				ObjectToString[PickList[resolvedCoolingTime, changedCoolingTimes], Cache -> cacheBall],
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
				Warning["All specified cooling times in GrindingProfile are equal to the specified CoolingTime(s) for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* Throw an if the specified GrindingContainer does not match the grinder *)
	grindingContainerMismatchOptions = If[MemberQ[grindingContainerMismatches, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		(
			Message[
				Error::GrindingContainerMismatch,
				ObjectToString[PickList[simulatedSamples, grindingContainerMismatches], Cache -> cacheBall],
				ObjectToString[DeleteDuplicates[Transpose[{
					PickList[resolvedGrindingContainer, grindingContainerMismatches],
					PickList[resolvedInstrument, grindingContainerMismatches]
				}]], Cache -> cacheBall]
			];
			{GrindingContainer}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	grindingContainerMismatchTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, grindingContainerMismatches];
			passingInputs = PickList[simulatedSamples, grindingContainerMismatches, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The specified grinding containers match the grinder for the following sample(s) " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " .", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The specified grinding containers match the grinder for the following sample(s) " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " .", True, True],
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
			Amount -> outputAmounts,
			Fineness -> resolvedFineness,
			BulkDensity -> Round[resolvedBulkDensity, 0.0001],
			GrindingContainer -> resolvedGrindingContainer,
			GrindingBead -> resolvedGrindingBead,
			NumberOfGrindingBeads -> resolvedNumberOfGrindingBeads,
			GrindingRate -> resolvedGrindingRate,
			Time -> resolvedTime,
			NumberOfGrindingSteps -> resolvedNumberOfGrindingSteps,
			CoolingTime -> resolvedCoolingTime,
			GrindingProfile -> resolvedGrindingProfiles,
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
		grinderTypeMismatchOption,
		coolingTimeMismatch,
		highGrindingRateOption,
		lowGrindingRateOption,
		highGrindingTimeOption,
		lowGrindingTimeOption,
		invalidSamplesOutStorageConditionsOptions,
		grindingContainerMismatchOptions,
		grindingBeadMismatchOption,
		grindingBeadNumberMismatchOption
	}]];

	(* this constant is used to track InvalidOptions found here. it can be used by other functions to throw all InvalidOptions generated by all functions in one place *)
	$GrindInvalidOptions = invalidOptions;
	$GrindInvalidInputs = invalidInputs;

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
		grindTypeMismatchTest,
		lowGrindingProfileTimeTest,
		highGrindingProfileTimeTest,
		lowGrindingProfileRateTest,
		highGrindingProfileRateTest,
		highGrindingRateTest,
		lowGrindingRateTest,
		highGrindingTimeTest,
		lowGrindingTimeTest,
		coolingTimeMismatchTests,
		changedNumberOfGrindingStepsTest,
		changedRateTest,
		changedTimeTest,
		changedCoolingTimeTest,
		grindingContainerMismatchTest,
		lowAmountTests,
		highAmountTests,
		grindingBeadMismatchTest,
		grindingBeadNumberMismatchTest,
		ratePrecisionsTests,
		timePrecisionsTests
	}], TestP];

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
		safeOps, outputSpecification, output, gatherTests, messages, noSamplesWithWarning, amountAllQs,
		cache, simulation, fastAssoc, grinderGrouper, containerResources,
		simulatedSampleContainersIn, samplesInResources,
		instrumentTag, grinderType, instruments, amount, fineness, grinderGroupedOptions,
		grindingRate, time, numberOfGrindingSteps, coolingTime, rawGrindingProfile,
		grindingBeadResourceRules, mergedBeadsAndNumbers, beadsAndNumbers,
		grindingProfiles, sampleLabel, containerOut, bulkDensity, unitOperationPackets,
		grindingContainer, grindingBead, numberOfGrindingBeads, sampleOutLabel, containerOutLabel,
		totalTimes, instrumentAndTimeRules, mergedInstrumentTimes, instrumentResources,
		grindingBeadResources, containerOutResourcesForProtocol, containerOutResourcesForUnitOperation,
		updatedSamplesOutStorageCondition, sampleModels, numericAmount, groupedOptions,
		samplesOutStorageCondition, protocolPacket, sharedFieldPacket, finalizedPacket,
		instrumentModelKey, instrumentModels, grindingContainerModelKey, grindingContainerModels,
		allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
		tubeHolderModels, tweezerResource, weighingContainerResources,
		grindingProfileForEngineDisplay, accessoriesTuples, tubeHolderTupleLists, tubeHolderQs, clampTupleLists,
		clampQs, clampModels
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

	(* this is the only real Download I need to do, which is to get the simulated sample containers *)
	containersIn = Download[mySamples, Container[Object], Cache -> cache, Simulation -> simulation];
	containerResources = Resource[Sample -> #, Name->ToString[Unique[]]]& /@ containersIn;

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
		(*13*)rawGrindingProfile,
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

	(* --- Make all the resources needed in the experiment --- *)

	(*Update amount value to quantity if it is resolved to All*)
	numericAmount = MapThread[If[
		MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
	]&, {amount, mySamples}];

	(* frq should throw SamplesMustBeMoved warning only when Amount is All *)
	amountAllQs = MatchQ[#, All]& /@ amount;
	noSamplesWithWarning = PickList[mySamples, amountAllQs, False];

	(*SampleIn and GrindingContainer Resources*)
	samplesInResources = MapThread[Resource[
		Sample -> #,
		Name -> #2,
		Amount -> #3,
		Container -> Download[#4, Object],
		ExactAmount -> True,
		(* 10% Tolerance (or 0.01 Gram, whichever is greater): The mass that the sample is allowed to deviate from the requested Amount when fulfilling the sample, because ExactAmount is True. *)
		Tolerance -> Max[0.1 * #3, 0.01 Gram],
		AutomaticDisposal -> False
	]&, {mySamples, sampleLabel, numericAmount, grindingContainer}];

	grindingContainerModels = If[
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
			Model[Item, WeighBoat, "id:N80DNj1N7GLX"], (* "Weigh boats, medium" *)
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

	(* GrindingProfile is in the form of {{GrindingRate, GrindingTime}|{GrindingTime}..}, The former indicates a grinding step and the latter indicates a cooling step. The grinding profile should be expanded to the form of {{Grinding|Cooling, GrindingRate, GrindingTime}..} *)
	grindingProfiles = Map[If[
		MatchQ[#, {_}],

		(* if grinding profile has only one member, prepend {Cooling, 0 RPM} to it *)
		ReleaseHold[Prepend[#, Hold[Sequence@@{Cooling, 0 RPM}]]],

		(* if grinding profile has two members, prepend Grinding to it *)
		Prepend[#, Grinding]
	]&, rawGrindingProfile, {2}];

	(*Calculate the time required for grinding from GrindingProfile*)
	totalTimes = Map[Total, grindingProfiles[[All, All, 3]]];
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
	instrumentModels = (If[
		MatchQ[#, ObjectP[Object]],
		fastAssocLookup[fastAssoc, #, Model],
		#
	]& /@ instruments)[Object];


	(* does the instrument need accessories like tube holders or clamp assembly? *)
	(* lookup associated accessories *)
	accessoriesTuples = fastAssocLookup[fastAssoc, #, AssociatedAccessories] & /@ instrumentModels;

	(* lookup tube holders *)
	tubeHolderTupleLists = Cases[#, {ObjectP[Model[Container, GrinderTubeHolder]] ,_}]& /@ accessoriesTuples;

	(* does the instrument need tube holders? *)
	tubeHolderQs = !MatchQ[#, Null | {}]& /@ tubeHolderTupleLists;

	(* if the type of the grinding container is not Model[Container, GrindingContainer] and the grinder requires a tube holder, determine the tube holder that matches the grinding container *)
	tubeHolderModels = MapThread[
		Function[{tubeHolderQ, tubeHolderTuples, grindingContainerModel},
			If[
				(* if the type of the grinding container is Model[Container, GrindingContainer] or the grinder does not have a tube holder, return Null for tube holder model *)
				!TrueQ[tubeHolderQ] || MatchQ[grindingContainerModel, ObjectP[Model[Container, GrindingContainer]]],
				Null,

				(* if the type of the grinding container is not Model[Container, GrindingContainer] and the grinder requires a tube holder, determine the tube holder that matches the grinding container *)
				Module[
					{tubeHolderModels, tubeHolderNumbers, tubeHolderProvidedFootprints, grindingContainerFootprint, tubeHolderModel},

					(* extract the tube holder models that match with the grinder model *)
					{tubeHolderModels, tubeHolderNumbers} = Transpose[tubeHolderTuples];

					(* lookup the footprint that tube holders provide *)
					tubeHolderProvidedFootprints = Map[
						Lookup[fastAssocLookup[fastAssoc, #, Positions], Footprint][[1]]&,
						tubeHolderModels
					];

					(* lookup the footprint of the grinding container *)
					grindingContainerFootprint = fastAssocLookup[fastAssoc, grindingContainerModel, Footprint];

					(* return the tube holder model that the footprint that it provides matches the footprint of the grinding container *)
					tubeHolderModel = First @ tubeHolderModels[[Flatten[Position[tubeHolderProvidedFootprints, grindingContainerFootprint]]]];
					Download[tubeHolderModel, Object]
				]
			]
		],
		{tubeHolderQs, tubeHolderTupleLists, grindingContainerModels}
	];


	(* lookup grinder clamps *)
	clampTupleLists = Cases[#, {ObjectP[Model[Part, GrinderClampAssembly]] ,_}]& /@ accessoriesTuples;

	(* does the instrument need clamp assembly? *)
	clampQs = !MatchQ[#, Null | {}]& /@ clampTupleLists;

	(* determine the clamp assembly if the grinder needs one *)
	clampModels = MapThread[
		If[
			!TrueQ[#1],
			Null,
			Download[First[Cases[Flatten[#2], ObjectP[Model[Part, GrinderClampAssembly]]]], Object]
		]&,
		{clampQs, clampTupleLists}
	];

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

		(* Model[Instrument, Grinder, "BeadBug3"]: the quantity to enter in the instrument for grinding rate should be GrindingRate divided by 10 *)
		MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]],
			Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]] / 10]&, grindingProfile],

		(* Model[Instrument, Grinder, "BeadGenie"]: the quantity to enter in the instrument for grinding rate should be GrindingRate multiplied by 2 *)
		MatchQ[instrumentModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]],
			Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]] * 2]&, grindingProfile],

		(*no change needed for other grinders *)
		True,
			Map[ReplacePart[#, 2 -> QuantityMagnitude[#[[2]]]]&, grindingProfile]
	]], {instrumentModels, grindingProfiles}];

	(* group relevant options into batches (based on Instrument and Sterile option) *)
	(* NOTE THAT I HAVE TO REPLICATE THIS CODE TO SOME DEGREE IN grindPopulateWorkingSamples SO IF THE LOGIC CHANGES HERE CHANGE IT THERE TOO*)
	(* note that we don't actually have to do any grouping if we're doing robotic, then we just want a list so we are just grouping by the preparation *)
	groupedOptions = Experiment`Private`groupByKey[
		{
			Sample -> Link /@ samplesInResources,
			WorkingSample -> Link /@ mySamples,
			GrinderType -> grinderType,
			Instrument -> instrumentResources,
			GrinderTubeHolder -> Link /@ tubeHolderModels,
			GrinderClampAssembly -> Link /@ clampModels,
			WeighingContainer -> weighingContainerResources,
			Amount -> numericAmount,
			Fineness -> fineness,
			BulkDensity -> bulkDensity,
			GrindingContainer -> grindingContainer,
			GrindingBead -> grindingBeadResources,
			NumberOfGrindingBeads -> numberOfGrindingBeads,
			GrindingRate -> grindingRate,
			Time -> time,
			NumberOfGrindingSteps -> numberOfGrindingSteps,
			CoolingTime -> coolingTime,
			GrindingProfile -> grindingProfiles,
			GrindingProfileForEngineDisplay -> grindingProfileForEngineDisplay,
			SampleLabel -> sampleLabel,
			SampleOutLabel -> sampleOutLabel,
			ContainerOut -> containerOutResourcesForUnitOperation,
			ContainerOutLabel -> containerOutLabel,
			SamplesOutStorageCondition -> samplesOutStorageCondition,
			(*The following keys are added for the sake of grouping.*)
			grindingContainerModelKey -> grindingContainerModels,
			instrumentModelKey -> instrumentModels
		},
		{instrumentModelKey, grindingContainerModelKey, GrindingProfile}
	];

	(*grinderGrouper, a function to group samples based on the number of samples that a grinder can grind at the same time*)
	grinderGrouper[groupedOption : {_Rule..}] := Module[
		{groupedGrinderModel, groupedContainerModel, containerFootprint, grouperFunction, expandedOptions,
			optionsPacket, partitionedOptions, collapsedOptions, mergedOptions, groupedTubeHolderModels, grindPositionNumber},

		groupedGrinderModel = First@Lookup[groupedOption, instrumentModelKey];
		groupedContainerModel = First@Lookup[groupedOption, grindingContainerModelKey];
		containerFootprint = fastAssocLookup[fastAssoc, groupedContainerModel, Footprint];

		groupedTubeHolderModels = First@Lookup[groupedOption, GrinderTubeHolder];

		grindPositionNumber = If[
			NullQ[groupedTubeHolderModels],
			Length @ Flatten[fastAssocLookup[fastAssoc, groupedGrinderModel, Positions]],
			Length @ Flatten[fastAssocLookup[fastAssoc, groupedTubeHolderModels, Positions]]
		];

		grouperFunction = Function[{groupMe, number},
			expandedOptions = Thread /@ groupMe;
			optionsPacket = Transpose@expandedOptions;
			partitionedOptions = Partition[optionsPacket, UpTo[number]];
			collapsedOptions = Map[Transpose, partitionedOptions];
			mergedOptions = Sequence @@ Normal[Map[Merge[#, Join]&, collapsedOptions]]
		];

		Which[
			MatchQ[groupedGrinderModel, Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]], (*BeadBug3*)
			grouperFunction[groupedOption, grindPositionNumber],

			MatchQ[groupedGrinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && MatchQ[containerFootprint, Conical50mLTube], (*BeadGenie*)
			grouperFunction[groupedOption, grindPositionNumber],

			MatchQ[groupedGrinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && MatchQ[containerFootprint, Conical15mLTube], (*BeadGenie*)
			grouperFunction[groupedOption, grindPositionNumber],

			MatchQ[groupedGrinderModel, Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]] && MatchQ[containerFootprint, MicrocentrifugeTube], (*BeadGenie*)
			grouperFunction[groupedOption, grindPositionNumber],

			MatchQ[groupedGrinderModel, Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]], (*Mixer Mill MM400*)
			grouperFunction[groupedOption, grindPositionNumber],

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
							GrinderTubeHolder -> DeleteDuplicates @ Flatten[Lookup[options, GrinderTubeHolder]],
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
			Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
			Replace[ContainersIn] -> Map[Link[#, Protocols]&, containerResources],
			Replace[Amounts] -> numericAmount,
			Replace[BulkDensities] -> bulkDensity,
			Replace[CoolingTimes] -> coolingTime,
			Replace[Finenesses] -> fineness,
			Replace[GrinderTypes] -> grinderType,
			Replace[GrindingRates] -> grindingRate,
			Replace[NumbersOfGrindingSteps] -> numberOfGrindingSteps,
			Replace[Times] -> time,
			Replace[GrindingProfiles] -> grindingProfiles,
			Replace[GrinderTypes] -> grinderType,
			Replace[Instruments] -> instrumentResources,
			Replace[GrindingContainers] -> Link /@ grindingContainer,
			Replace[GrindingBeads] -> grindingBeadResources,
			Replace[NumbersOfGrindingBeads] -> numberOfGrindingBeads,
			Replace[ContainersOut] -> containerOutResourcesForProtocol,
			Tweezer -> tweezerResource,
			Replace[WeighingContainers] -> weighingContainerResources,
			Replace[SamplesOutStorageConditions] -> updatedSamplesOutStorageCondition,

			(* Post-processing options *)
			ImageSample -> Lookup[myResolvedOptions, ImageSample],
			MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
			MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],

			UnresolvedOptions -> myUnresolvedOptions,
			ResolvedOptions -> myResolvedOptions,
			Replace[Checkpoints] -> {
				{
					"Picking Resources",
					60Minute,
					"Samples are gathered from storage and processed.",
					Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60Minute]]
				},
				{
					"Running Experiment",
					(Plus @@ totalTimes + 1Hour),
					"Samples are being ground into smaller particles.",
					Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> (Plus @@ totalTimes + 10 Minute)]]
				},
				{
					"Sample Post-Processing",
					60Minute,
					"Any measuring of volume, weight, or sample imaging post experiment is performed.",
					Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 30Minute]]
				},
				{
					"Returning Materials",
					60Minute,
					"Samples are returned to storage.",
					Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60Minute]]
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
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> simulation, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> noSamplesWithWarning, Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> simulation, Messages -> messages, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> noSamplesWithWarning, Cache -> cache], Null}
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
		{finalizedPacket, unitOperationPackets},
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
		simulationWithLabels, fastAssoc, rawGrindingProfile,
		uploadSampleTransferPackets, simulatedDestinationLocation,
		simulatedNewSamples, newSamplePackets,
		grinderType, instrument, amount, fineness, bulkDensity,
		grindingContainer, grindingBead, numberOfGrindingBeads,
		grindingRate, time, numberOfGrindingSteps, coolingTime,
		grindingProfiles, sampleLabel, sampleOutLabel, containerOut,
		containerOutLabel, samplesOutStorageCondition, instrumentResources,
		instrumentTag, samplesInResources, grindingBeadResources, totalTimes,
		instrumentAndTimeRules, mergedInstrumentTimes, containerOutResourcesForProtocol,
		simulatedContainerOutObjects, numericAmount, sampleUpdatePackets
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
				Packet[Model, Container, Tablet, SampleHandling]
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
		(*13*)rawGrindingProfile,
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
	grindingBeadResources = MapThread[
		If[
			MatchQ[#, Null],
			Null,
			(* if bead resource is not Null but amount is Null, we are in an Error state, so change Null to 1 to continue simulation *)
			Link[Resource[Sample -> #, Amount -> (#2 /. Null :> 1)]]
		]&,
		{grindingBead, numberOfGrindingBeads}
	];

	(* Make a list of tags for each unique instrument *)
	instrumentTag = Map[
		# -> ToString[Unique[]]&,
		DeleteDuplicates[instrument]
	];

	(* GrindingProfile is in the form of {{GrindingRate, GrindingTime}|{GrindingTime}..}, The former indicates a grinding step and the latter indicates a cooling step. The grinding profile should be expanded to the form of {{Grinding|Cooling, GrindingRate, GrindingTime}..} *)
	grindingProfiles = Map[If[
		MatchQ[#, {_}],

		(* if grinding profile has only one member, prepend {Cooling, 0 RPM} to it *)
		ReleaseHold[Prepend[#, Hold[Sequence@@{Cooling, 0 RPM}]]],

		(* if grinding profile has two members, prepend Grinding to it *)
		Prepend[#, Grinding]
	]&, rawGrindingProfile, {2}];

	(* Calculate the time required for grinding from GrindingProfile *)
	totalTimes = Map[Total, grindingProfiles[[All, All, 3]]];
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

	(* If the sample is tablet or itemized, they should not be at the end of ExperimentGrind *)
	sampleUpdatePackets = Map[
		Function[newSample,
			Module[{newSamplePacket, tablet, sampleHandling},
				(* Get the packet of the simulated sample after the transfer*)
				newSamplePacket = fetchPacketFromCache[newSample, uploadSampleTransferPackets];
				(* Look up the fields *)
				{tablet, sampleHandling} = Transpose[Lookup[newSamplePacket, {Tablet, SampleHandling}, Null]];
				(* Make update packets based on current values *)
				Switch[{tablet, sampleHandling},
					(* If it currently is individual tablet, update to powder, no longer tablet *)
					{True, Itemized},
						<|Object -> newSample, Tablet -> False, Count -> Null, SampleHandling -> Powder|>,
					(* If it is tablet, somehow with other sample handling, we respect it (?), but it is no longer a tablet coming out of Grind *)
					{True, _},
						<|Object -> newSample, Tablet -> False, Count -> Null|>,
					{_,_},
						Nothing
				]
			]
		],
		simulatedNewSamples
	];

	(*update our simulation with UploadSampleTransferPackets*)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[Join[uploadSampleTransferPackets,sampleUpdatePackets]]];

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
Authors[Grind] := {"mohamad.zandian"};


(* ::Subsection::Closed:: *)
(*PreferredGrinder*)

(* ::Subsubsection::Closed:: *)
(*PreferredGrinder Options*)

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
				Pattern :> ListableP[GrinderTypeP]
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
		},
		{
			OptionName -> OutputFormat,
			Default -> Result,
			Description -> "The format of the final output. Result returns the natural flow of errors, warnings, and final output. ErrorType returns a list error names that can be used to form proper Message structures when PreferredGrinder is used in other functions.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Result, ErrorType]
			]
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*PreferredGrinder Memoization*)

(* need to set DeveloperObject != True here directly because if someone happens to call this with $DeveloperSearch=True the first time in their kernel, then this will memoize to {} and fail for all subsequent uses of this function *)
cachePreferredGrinderPackets[string_] := cachePreferredGrinderPackets[string] = Module[{},
	If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets],
		AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets]
	];

	Flatten @ Quiet[
		Download[
			Search[{Model[Instrument, Grinder], Object[Instrument, Grinder]}, DeveloperObject != True],
			Packet[Name, MinAmount, MaxAmount, FeedFineness, GrinderType, Model]
		],
		Download::FieldDoesntExist
	]
];


(* Create fast cache *)
preferredGrinderFastCache[string_] := preferredGrinderFastCache[string] = Module[{},
	If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets],
		AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrinderPackets]
	];
	Experiment`Private`makeFastAssocFromCache[cachePreferredGrinderPackets["Memoization"]]
];


(* ::Subsubsection::Closed:: *)
(*PreferredGrinder Main Function*)

PreferredGrinder[amount : (MassP | VolumeP), options : OptionsPattern[PreferredGrinder]] := Module[
	{
		safeOptions, grinderFastCache, grinderModels, absoluteMinGrinderVolume, volumeAmount, preferredGrinder,
		grinderType, fineness, bulkDensity, priorityList, preferredGrinderFinder, grinderFastCacheWithDeprecated,
		fastCacheKeys, fastCacheValues, grinderTypeMaxFinenessRule, maxFeedFineness, grinderTypeMinAmountRule,
		grinderTypeMaxAmountRule, absoluteMaxGrinderVolume, grinderModelTuples, grinderTypeModelRules, selectedGrinder,
		preferredGrindersNoError, outputFormat, largeParticleMessage, insufficientAmountMessage, excessiveAmountMessage,
		grinderTypePattern, particleMessage, insufficientMessage, excessiveMessage
	},

	(*Call SafeOptions to make sure all options match pattern*)
	safeOptions = SafeOptions[PreferredGrinder, ToList[options]];

	(*Lookup options*)
	{grinderType, fineness, bulkDensity, outputFormat} = Lookup[safeOptions, {GrinderType, Fineness, BulkDensity, OutputFormat}];
	grinderTypePattern = Alternatives @@ ToList[grinderType];

	(*Convert amount mass to volume*)
	volumeAmount = If[MassQ[amount], UnitSimplify[amount / bulkDensity], amount];

	(* generate fast cache *)
	grinderFastCacheWithDeprecated = preferredGrinderFastCache["Memoization"];

	(* remove deprecated models *)
	grinderFastCache = Select[grinderFastCacheWithDeprecated, (!KeyExistsQ[#, Deprecated] || #[Deprecated] =!= True)&];

	(*Extract data from cache*)
	fastCacheKeys = Keys[grinderFastCache];
	fastCacheValues = Values[grinderFastCache];
	grinderModels = Cases[Keys[grinderFastCache], ObjectP[Model[Instrument, Grinder]]];

	(* an association in which the keys are GrinderTypes and Value is the max FeedFineness of the GrinderType *)
	grinderTypeMaxFinenessRule = GroupBy[
		Rule @@@ Lookup[fastCacheValues, {GrinderType, FeedFineness}],
		First -> Last,
		Max
	];

	(* max FeedFineness of all grinders *)
	maxFeedFineness = Max[grinderTypeMaxFinenessRule];

	(* an association in which the keys are GrinderTypes and Value is the MinAmount of the GrinderType (Minimum amount of sample that can be effectively ground) *)
	grinderTypeMinAmountRule = GroupBy[
		Rule @@@ Lookup[fastCacheValues, {GrinderType, MinAmount}],
		First -> Last,
		Min
	];

	(* smallest MinAmount of all grinders *)
	absoluteMinGrinderVolume = Min[grinderTypeMinAmountRule];

	(* an association in which the keys are GrinderTypes and Value is the MaxAmount of the GrinderType (Maximum amount of sample that can be effectively ground) *)
	grinderTypeMaxAmountRule = GroupBy[
		Rule @@@ Lookup[fastCacheValues, {GrinderType, MaxAmount}],
		First -> Last,
		Max
	];

	(* smallest MinAmount of all grinders *)
	absoluteMaxGrinderVolume = Max[grinderTypeMaxAmountRule];

	(* a tuple of Grinder Models *)
	grinderModelTuples =  Cases[
		DeleteDuplicates[Lookup[fastCacheValues, {Object, GrinderType, FeedFineness, MinAmount, MaxAmount}]],
		{ObjectP[Model], GrinderTypeP, _?QuantityQ, VolumeP, VolumeP}
	];

	(* a list of rules that associate GrinderTypes to Models *)
	grinderTypeModelRules = Rule @@@ grinderModelTuples[[All, {2, 1}]];

	(******************************************************************)
	(***** Criteria within instrument limits (No Errors/Warnings) *****)
	(******************************************************************)

	(* List of available grinder models sorted based on the priority of their use *)
	priorityList = DeleteDuplicates[Flatten[{
		BallMill -> Model[Instrument, Grinder, "id:O81aEB1lX1Mx"], (* Model[Instrument, Grinder, "BeadBug3"], Default grinder *)
		grinderTypeModelRules
	}]];

	(* A function that adds a grinder model to the preferredGrinders list if the fineness and amount of the sample fits *)
	preferredGrinderFinder = Function[grinderModel, If[
		And[
			volumeAmount >= fastAssocLookup[grinderFastCache, grinderModel, MinAmount],
			volumeAmount <= fastAssocLookup[grinderFastCache, grinderModel, MaxAmount],
			fineness <= fastAssocLookup[grinderFastCache, grinderModel, FeedFineness]
		],
		grinderModel,
		Nothing
	]];

	(* Map preferredGrinderFinder over the list of available grinder models to find grinders that suit the sample amount and fineness *)
	preferredGrindersNoError = If[
		MatchQ[grinderType, Automatic],
		(*If grinderType is Automatic, look at all available grinder models*)
		Map[preferredGrinderFinder, Values[priorityList]],
		(*If grinderType is set to a specific grinderType, only look at the grinders of that type*)
		Map[preferredGrinderFinder, Flatten@Values[KeyTake[Merge[priorityList, Join], grinderType]]]
	];

	(*********************************************************************)
	(***** Criteria beyond instrument limits (Throw Errors/Warnings) *****)
	(*********************************************************************)

	(* Select a grinder for amounts/finenesses that are not covered by the criteria in preferredGrinderFinder function *)
	(* Throw Warnings or Errors if Amounts or finenesses do not match the criteria *)
	{preferredGrinder, largeParticleMessage, insufficientAmountMessage, excessiveAmountMessage} = If[
		(* if we already found a suitable grinder, skip the error/warning check *)
		Length[preferredGrindersNoError] > 0,

		{First[preferredGrindersNoError], Null, Null, Null},

		Which[
			(*******************)
			(*** 1. Fineness ***)
			(*******************)

			(* 1.a. Error if fineness is greater than the max FeedFineness *)
			fineness > maxFeedFineness,
				Module[{},
					selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderTypePattern /. {Automatic -> _}, Max[grinderType /. Join[grinderTypeMaxFinenessRule, <|Automatic -> maxFeedFineness|>]], _, _} :> model]];

					(* LargeParticles error throws different messages. if largeParticleMessage is not Null, it means LargeParticles error is triggered *)
					particleMessage = "available grinders";

					(* InsufficientAmount and ExcessiveAmount errors throw different messages. if insufficientAmountMessage is not Null, it means LargeParticles error is triggered *)
					{insufficientMessage, excessiveMessage} = Which[
						volumeAmount < fastAssocLookup[grinderFastCache, selectedGrinder, MinAmount],
							{ToString[selectedGrinder], Null},
						volumeAmount > fastAssocLookup[grinderFastCache, selectedGrinder, MaxAmount],
							{Null, ToString[selectedGrinder]},
						True, {Null, Null}
					];

					{selectedGrinder, particleMessage, insufficientMessage, excessiveMessage}
				],

			(* 1.b. Error if the determined fineness is greater than the max FeedFineness of the determined GrinderType *)
			grinderType =!= Automatic && fineness > Max[grinderType /. grinderTypeMaxFinenessRule],
				Module[{},
					selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderTypePattern, Max[grinderType /. grinderTypeMaxFinenessRule], _, _} :> model]];

					(* LargeParticles error throws different messages. if largeParticleMessage is not Null, it means LargeParticles error is triggered *)
					particleMessage = "available selected grinder types (" <> StringRiffle[ToList[grinderType], "s, "] <> "s)";

					(* InsufficientAmount and ExcessiveAmount errors throw different messages. if insufficientAmountMessage is not Null, it means LargeParticles error is triggered *)
					{insufficientMessage, excessiveMessage} = Which[
						volumeAmount < fastAssocLookup[grinderFastCache, selectedGrinder, MinAmount],
						{ToString[selectedGrinder], Null},
						volumeAmount > fastAssocLookup[grinderFastCache, selectedGrinder, MaxAmount],
						{Null, ToString[selectedGrinder]},
						True, {Null, Null}
					];

					{selectedGrinder, particleMessage, insufficientMessage, excessiveMessage}
				],

			(*****************)
			(*** 2. Amount ***)
			(*****************)

			(* 2.a. Warning if the amount is smaller than MinAmount of all grinders, choose a grinder with the smallest MinAmount *)
			volumeAmount < absoluteMinGrinderVolume,
				(* InsufficientAmount error throws different messages. if insufficientAmountMessage is not Null, it means LargeParticles error is triggered *)
				insufficientMessage = "available grinders";
				selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderTypePattern /. {Automatic -> _}, _, Min[grinderType /. Join[grinderTypeMinAmountRule, <|Automatic -> absoluteMinGrinderVolume|>]], _} :> model]];

				(* output *)
				{selectedGrinder, Null, insufficientMessage, Null},

			(* 2.b. Warning if amount is less than the MinAmount of the determined GrinderType *)
			grinderType =!= Automatic && volumeAmount < Min[grinderType /. grinderTypeMinAmountRule],
				(* InsufficientAmount error throws different messages. if insufficientAmountMessage is not Null, it means LargeParticles error is triggered *)
				insufficientMessage = "available selected grinder types (" <> StringRiffle[ToList[grinderType], "s, "] <> "s)";

				selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderTypePattern, _, Min[grinderType /. grinderTypeMinAmountRule], _} :> model]];

				(* output *)
				{selectedGrinder, Null, insufficientMessage, Null},

			(* 2.c. Warning if amount is greater than the MaxAmount of the determined GrinderType *)
			volumeAmount > absoluteMaxGrinderVolume,
				(* ExcessiveAmount error throws different messages. if excessiveAmountMessage is not Null, it means LargeParticles error is triggered *)
				excessiveMessage = "available grinders";
				selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderTypePattern /. {Automatic -> _}, _, _, Max[grinderType /. Join[grinderTypeMaxAmountRule, <|Automatic -> absoluteMaxGrinderVolume|>]]} :> model]];

				(* output *)
				{selectedGrinder, Null, Null, excessiveMessage},

			(* 2.d. Warning if amount is greater than the MaxAmount of the determined GrinderType *)
			grinderType =!= Automatic && volumeAmount > Max[grinderType /. grinderTypeMaxAmountRule],

				(* ExcessiveAmount error throws different messages. if excessiveAmountMessage is not Null, it means LargeParticles error is triggered *)
				excessiveMessage = "available selected grinder types (" <> StringRiffle[ToList[grinderType], "s, "] <> "s)";

				selectedGrinder = First[Cases[grinderModelTuples, {model:ObjectP[Model], grinderType, _, _, Max[grinderType /. grinderTypeMaxAmountRule]} :> model]];

				(* output *)
				{selectedGrinder, Null, Null, excessiveMessage},

			(********************************)
			(************* 3 ****************)
			(*** GrinderType: Automatic *****)
			(**** Fineness within limits ****)
			(*** amount beyond limits *******)
			(********************************)
			(********************************)

			(* these are the cases with Automatic GrinderType that have Fineness within instrument limits but their amount is less than MinAmount or greater than the MaxAmount of the grinder models that provide the requested Fineness *)
			True,
				Module[{goodFinenessModels},
					(* grinder models that provide the requested Fineness *)
					goodFinenessModels = Cases[grinderModelTuples, {model:ObjectP[Model], _, GreaterEqualP[fineness], minAmount_, maxAmount_} :> {model, minAmount, maxAmount}];

					If[
						(* the sample amount is either less than the MinAmount of the suitable grinders or greater than the MaxAmount.  *)
						volumeAmount < Min[goodFinenessModels[[All, 2]]],

						(* if the sample amount is less than the MinAmount of good grinders, select the grinder with lowest MinAmount and throw InsufficientAmount warning. *)
						selectedGrinder = First[Cases[goodFinenessModels, {model:ObjectP[Model], Min[goodFinenessModels[[All, 2]]], _} :> model]];
						(* InsufficientAmount error throws different messages. if insufficientAmountMessage is not Null, it means LargeParticles error is triggered *)
						insufficientMessage = "the automatically selected grinder model: " <> ToString[selectedGrinder] <> ". Please note that this grinder model was automatically selected based on the provided Fineness.";
						(* output *)
						{selectedGrinder, Null, insufficientMessage, Null},

						(* if the sample amount is greater than the MaxAmount of good grinders, select the grinder with greatest MaxAmount and throw ExcessiveAmount warning. *)
						selectedGrinder = First[Cases[goodFinenessModels, {model:ObjectP[Model], _, Max[goodFinenessModels[[All, 3]]]} :> model]];
						(* ExcessiveAmount error throws different messages. if excessiveAmountMessage is not Null, it means LargeParticles error is triggered *)
						excessiveMessage = "the automatically selected grinder model: " <> ToString[selectedGrinder] <> ". Please note that this grinder model was automatically selected based on the provided Fineness.";
						(* output *)
						{selectedGrinder, Null, Null, excessiveMessage}
					]
				]
		]
	];

	(* final output *)
	If[
		MatchQ[outputFormat, Result],

		(
			largeParticleMessage /. {_String :> Message[Error::LargeParticles, fineness, largeParticleMessage, " available grinders"]};
			insufficientAmountMessage /. {_String :> Message[Warning::InsufficientAmount, volumeAmount, "", insufficientAmountMessage]};
			excessiveAmountMessage /. {_String :> Message[Warning::ExcessiveAmount, volumeAmount, "", excessiveAmountMessage]};
			preferredGrinder
		),

		{
			preferredGrinder,
			{
				largeParticleMessage /. {_String :> Hold[Error::LargeParticles]},
				insufficientAmountMessage /. {_String :> Hold[Warning::InsufficientAmount]},
				excessiveAmountMessage /. {_String :> Hold[Warning::ExcessiveAmount]}
			}
		}
	]
];

(* ::Subsection::Closed:: *)
(*PreferredGrindingContainer*)

(* need to set DeveloperObject != True here directly because if someone happens to call this function with $DeveloperSearch=True the first time in their kernel, then this will memoize to {} and fail for all subsequent uses of this function *)
cachePreferredGrindingContainerPackets[string_] := cachePreferredGrindingContainerPackets[string] = Module[{},
	If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets],
		AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets]
	];
	Flatten @ Quiet[
		Download[
			Search[{Model[Container, GrindingContainer], Object[Instrument, Grinder]}, DeveloperObject != True],
			Packet[Name, Model]
		], 
		Download::FieldDoesntExist
	]
];

preferredGrindingContainerFastCache[string_] := preferredGrindingContainerFastCache[string] = Module[{},
	If[!MemberQ[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets],
		AppendTo[ECL`$Memoization, Experiment`Private`cachePreferredGrindingContainerPackets]
	];
	Experiment`Private`makeFastAssocFromCache[cachePreferredGrindingContainerPackets["Memoization"]]
];

PreferredGrindingContainer[grinder : Alternatives[ObjectP[Model[Instrument, Grinder]], ObjectP[Object[Instrument, Grinder]]], amount : (MassP | VolumeP), bulkDensity : GreaterP[0Gram / Milliliter]] := Module[
	{volumeAmount, grinderModel, fastCache},

	(*Convert amount mass to volume*)
	volumeAmount = If[MassQ[amount], UnitSimplify[amount / bulkDensity], amount];

	(* generate fast cache *)
	fastCache = preferredGrindingContainerFastCache["Memoization"];

	grinderModel = If[MatchQ[grinder, ObjectP[Model]], grinder, fastAssocLookup[fastCache, grinder, Model]];

	(***********************)
	(*** !!!ATTENTION!!! ***)
	(***********************)
	(* if any new container model is added here, update this variable "allGrindingContainerModels" in ExperimentGrind *)
	Which[

		(* Model[Instrument, Grinder, "BeadBug3"] *)
		MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]],
			Model[Container, Vessel, "id:pZx9joxq0ko9"], (* Model[Container, Vessel, "2 mL conical tube (no skirt) with cap and sealing ring"] *)

		(* Model[Instrument, Grinder, "BeadGenie"] *)
		MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]],
			Which[
				volumeAmount <= 1 Milliliter, Model[Container, Vessel, "id:eGakld01zzpq"], (* Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"] *)
				volumeAmount <= 7.5 Milliliter, Model[Container, Vessel, "id:xRO9n3vk11pw"], (* Model[Container, Vessel, "15mL Tube"] *)
				True, Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *)
			],

		(* Model[Instrument, Grinder, "Tube Mill Control"] *)
		MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:zGj91ajA6LYO"]]],
			Model[Container, GrindingContainer, "id:8qZ1VWZeG8mp"], (* Model[Container, GrindingContainer, "Grinding Chamber for Tube Mill Control"] *)

		(* Model[Instrument, Grinder, "Automated Mortar Grinder"] *)
		MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]],
			Model[Container, GrindingContainer, "id:N80DNj09nGxk"], (* Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"] *)

		(* Model[Instrument, Grinder, "Mixer Mill MM400"] *)
		MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]]],
			(* other containers can be added when other adapters are purchased *)
			Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *)
	]
];


(* ::Subsection::Closed:: *)
(* grindingContainerMatchQ *)
(* This function determines whether an specified grinding container works with the specified/automatically resolved grinder *)
grindingContainerMatchQ[grinderModel:ObjectP[Model[Instrument, Grinder]], grindingContainerModel:ObjectP[Model[Container]], grindingContainerFootprint:FootprintP|Null] := Which[

	(* Model[Instrument, Grinder, "BeadBug3"] *)
	MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:O81aEB1lX1Mx"]]],
		MatchQ[grindingContainerModel, ObjectP[Model[Container, Vessel, "id:pZx9joxq0ko9"]]], (* Model[Container, Vessel, "2 mL conical tube (no skirt) with cap and sealing ring"] *)

	(* Model[Instrument, Grinder, "BeadGenie"] *)
	MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:J8AY5jAvdnEZ"]]],
		MatchQ[grindingContainerFootprint, MicrocentrifugeTube | Conical15mLTube | Conical50mLTube],

	(* Model[Instrument, Grinder, "Tube Mill Control"] *)
	MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:zGj91ajA6LYO"]]],
		MatchQ[grindingContainerModel, ObjectP[Model[Container, GrindingContainer, "id:8qZ1VWZeG8mp"]]], (* Model[Container, GrindingContainer, "Grinding Chamber for Tube Mill Control"] *)

	(* Model[Instrument, Grinder, "Automated Mortar Grinder"] *)
	MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:qdkmxzk16DO0"]]],
		MatchQ[grindingContainerModel, ObjectP[Model[Container, GrindingContainer, "id:N80DNj09nGxk"]]], (* Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"] *)

	(* Model[Instrument, Grinder, "Mixer Mill MM400"] *)
	MatchQ[grinderModel, ObjectP[Model[Instrument, Grinder, "id:XnlV5jlxRxq3"]]],
	(* other containers/footprints can be added when other grinding containers / adapters are purchased *)
		Or[
			MatchQ[grindingContainerModel, ObjectP[Model[Container, GrindingContainer, "id:n0k9mGkjbBA1"]]], (* Model[Container, GrindingContainer, "50mL Grinding Jar - MM400"] *)
			MatchQ[grindingContainerFootprint, Conical50mLTube]
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
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentGrind}];

ExperimentGrindOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentGrind *)
	options = ExperimentGrind[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentGrind],
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


ValidExperimentGrindQ[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
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
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs], _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs], _String], validObjectBooleans}
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

ExperimentGrindPreview[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentGrind *)
	ExperimentGrind[myInputs, Append[noOutputOptions, Output -> Preview]]];