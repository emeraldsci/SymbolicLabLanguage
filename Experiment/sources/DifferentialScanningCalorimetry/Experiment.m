(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DifferentialScanningCalorimetry*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetry patterns and hardcoded values*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetry Options*)

DefineOptions[ExperimentDifferentialScanningCalorimetry,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, DifferentialScanningCalorimeter, "MicroCal VP-Capillary"],
			Description -> "The capillary-based differential scanning calorimetry (DSC) instrument used to measure thermodynamic properties of the samples in this experiment.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, DifferentialScanningCalorimeter], Object[Instrument, DifferentialScanningCalorimeter]}]
			]
		},
		(* mixing of the pool *)
		{
			OptionName -> NestedIndexMatchingMix,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if mixing of the pooled samples after aliquoting occurs inside the plate in which the samples are loaded onto the autosampler prior to injection.",
			ResolutionDescription -> "Automatically set to True if pooling and/or diluting the source samples, or other NestedIndexMatchingMix options are set, or False otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PooledMixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[750 RPM, 3200 RPM], Units -> RPM],
			Description -> "Frequency of rotation the plate vortex uses to mix the pooled samples after aliquoting.",
			ResolutionDescription -> "Automatically set to 1975 RPM if NestedIndexMatchingMix -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingMixTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units -> {1, {Hour, {Second, Minute, Hour}}}],
			Description -> "Duration of mixing of the pooled sample after aliquoting plate.",
			ResolutionDescription -> "Automatically set to 30 Minute if NestedIndexMatchingMix -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingCentrifuge,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if centrifugation of the pooled samples after aliquoting occurs inside the DSC plate (Model[Container, Plate, \"96-well 500uL Round Bottom DSC Plate\"]).",
			ResolutionDescription -> "Automatically set to True if NestedIndexMatchingMix -> True or other NestedIndexMatchingCentrifuge options are set, False if pooling but NestedIndexMatchingMix -> False, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingCentrifugeForce,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 GravitationalAcceleration, 16162.5 GravitationalAcceleration], Units -> GravitationalAcceleration],
			Description -> "The force with which the pooled samples after aliquoting are centrifuged prior to starting the experiment.",
			ResolutionDescription -> "Automatically resolves to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision if NestedIndexMatchingCentrifuge -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingCentrifugeTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 99 Minute], Units -> Alternatives[Second, Minute]],
			Description -> "Duration of centrifuging of the pooled sample after aliquoting plate prior to starting the experiment.",
			ResolutionDescription -> "Automatically set to 5 Minute if NestedIndexMatchingCentrifuge -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		(* incubation of the pools (annealing) *)
		{
			OptionName -> NestedIndexMatchingIncubate,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if thermal incubation of the pooled samples after aliquoting occurs prior to measurement.",
			ResolutionDescription -> "Automatically set to True if other NestedIndexMatchingIncubate options are set, or False otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> PooledIncubationTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Minute, $MaxExperimentTime], Units :> {1, {Hour, {Second, Minute, Hour}}}],
			Description -> "Duration for which the pooled samples after aliquoting are thermally incubated prior to measurement.",
			ResolutionDescription -> "Automatically set to 30 Minute if NestedIndexMatchingIncubate -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingIncubationTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[22 Celsius, 90 Celsius], Units :> Celsius],
				Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
			],
			Description -> "Temperature at which the pooled samples after aliquoting are thermally incubated prior to measurement.",
			ResolutionDescription -> "Automatically set to 40 Celsius if NestedIndexMatchingIncubate -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> NestedIndexMatchingAnnealingTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime], Units :> Alternatives[Second, Minute, Hour]],
			Description -> "Duration for which the pooled samples after aliquoting remain in the thermal incubation instrument before being removed, allowing the system to settle to room temperature after the PooledIncubationTime has passed.",
			ResolutionDescription -> "Automatically set to 0 Minute if NestedIndexMatchingIncubate -> True, or Null otherwise.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> AutosamplerTemperature,
			Default -> Ambient,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[2 Celsius, 50 Celsius],
					Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
				]
			],
			Description -> "The temperature at which the samples are held prior to injection.",
			Category -> "Sample Preparation"
		},
		{
			OptionName -> InjectionVolume,
			Default -> 300 Microliter,
			Description -> "The volume of sample (after aliquoting and/or pooling, if applicable) that is injected into the DSC instrument.",
			AllowNull -> False,
			Category -> "Injection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[250 Microliter, 350 Microliter],
				Units -> {1, {Microliter, {Microliter}}}
			]
		},
		{
			OptionName -> InjectionRate,
			Default -> 100 Microliter / Second,
			Description -> "The rate at which the sample is injected into the DSC instrument.",
			AllowNull -> False,
			Category -> "Injection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[50 Microliter / Second, 200 Microliter / Second],
				Units -> CompoundUnit[
					{1, {Microliter, {Microliter, Milliliter}}},
					{-1, {Second, {Second}}}
				]
			]
		},

		{
			OptionName -> CleaningFrequency,
			Default -> None,
			Description -> "Specify the frequency at which the sample chamber is washed with detergent between the injections of the samples (with a value of 2 indicating cleaning after every 2 samples).  Note that the sample chamber will always be cleaned after all samples are run.",
			AllowNull -> False,
			Category -> "Injection",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[None, First]
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Blanks,
				Default -> Model[Sample, "Milli-Q water"] ,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Description -> "The model or sample used to generate a blank sample whose heating profile will be subtract as background from the calorimetry measurements of the samples.",
				Category -> "Injection"
			},
			{
				OptionName -> StartTemperature,
				Default -> 4 Celsius,
				Description -> "The temperature at which the sample is held prior to heating. Note that althoug the sample will be held at this temperature, data collection will not start until 5-10 C higher than this temperature.  If you would like data collection at this lower end, be sure to lower StartTemperature below your desired data range.",
				AllowNull -> False,
				Category -> "Calorimetry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * Celsius, 110 * Celsius],
					Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
				]
			},
			{
				OptionName -> EndTemperature,
				Default -> 95 Celsius,
				Description -> "The temperature at which the sample is heated to in the course of the experiment.",
				AllowNull -> False,
				Category -> "Calorimetry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[11 * Celsius, 140 * Celsius],
					Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
				]
			},
			{
				OptionName -> TemperatureRampRate,
				Default -> 60 Celsius / Hour,
				Description -> "The rate at which the temperature is increased in the course of one heating cycle.",
				AllowNull -> False,
				Category -> "Calorimetry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Celsius / Hour, 300 Celsius / Hour],
					Units -> CompoundUnit[
						{1, {Celsius, {Celsius, Fahrenheit, Kelvin}}},
						{-1, {Hour, {Hour, Minute, Second}}}
					]
				]
			},
			{
				OptionName -> NumberOfScans,
				Default -> 1,
				Description -> "The number of heating cycles to apply to the given sample.",
				AllowNull -> False,
				Category -> "Calorimetry",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 27, 1]
				]
			},
			{
				OptionName -> RescanCoolingRate,
				Default -> Automatic,
				Description -> "The rate at which the temperature decreases from EndTemperature to StartTemperature between scans.",
				ResolutionDescription -> "Automatically set to 300 Celsius/Hour if NumberOfScans > 1, or Null otherwise.",
				AllowNull -> True,
				Category -> "Calorimetry",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[5 Celsius / Hour, 300 Celsius / Hour],
					Units -> CompoundUnit[
						{1, {Celsius, {Celsius, Fahrenheit, Kelvin}}},
						{-1, {Hour, {Hour, Minute, Second}}}
					]
				]
			}
		],
		(* Shared options *)
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True
				}
			}
		],
		NonBiologyFuntopiaSharedOptionsPooled,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SimulationOption,
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]],
			Description -> "The number of times to repeat the experiment on each sample or list of samples, if provided. Note that if Aliquot -> True, this indicates the number of times each provided sample is aliquoted/pooled into the plate before each pool is read once."
		}
	}
];

Error::RescanCoolingRateIncompatible="If RescanCoolingRate is specified, NumberOfScans must be greater than 1, and RescanCoolingRate is Null, NumberOfScans must be 1.  This is not the case for sample(s) `1`.  Please change the value of one or both of these options.";
Error::DestinationWellInvalid="If specifying the DestinationWell option, limitations of the DSC instrument dictate that it must be `1`.  Please change this option to that value, or leave it blank and allow it to be set automatically.";
Error::AliquotContainerOccupied="The following specified AliquotContainer objects are not empty: `1`.  If specifying an aliquot container object directly, it must be empty.  Please specify an empty container, a model, or leave the option to be set automatically.";
Error::PooledMixMismatch="If NestedIndexMatchingMix -> False, NestedIndexMatchingMixTime and PooledMixRate cannot be specified, and if NestedIndexMatchingMix -> True, they must not be Null.  Please change the values of these options, or leave them unspecified to be set automatically.";
Error::PooledCentrifugeMismatch="If NestedIndexMatchingCentrifuge -> False, NestedIndexMatchingCentrifugeTime and NestedIndexMatchingCentrifugeForce cannot be specified, and if NestedIndexMatchingCentrifuge -> True, they must not be Null.  Please change the values of these options, or leave them unspecified to be set automatically.";
Error::PooledIncubateMismatch="If NestedIndexMatchingIncubate -> False, PooledIncubationTime, PooledIncubationTime, and NestedIndexMatchingAnnealingTime cannot be specified, and if NestedIndexMatchingIncubate -> True, they must not be Null.  Please change the values of these options, or leave them unspecified to be set automatically.";
Error::StartTemperatureAboveEndTemperature="StartTemperature is higher than EndTemperature for the following sample(s): `1`.  StartTemperature must be below EndTemperature for every sample.";
Error::DSCTooManySamples="The number of input samples cannot fit onto the instrument in one run.  `1` were provided as input, but only `2` can be processed in a single protocol. Please consider splitting into several protocols.";
Error::CleaningFrequencyTooHigh="The specified CleaningFrequency (`1`) is greater than the number of provided samples * NumberOfReplicates (`2`).  Please set CleaningFrequency to a lower value.";


(* ::Subsubsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetry Experiment function*)


(* Overload for mixed input like {s1,{s2,s3}} -> We assume the first sample is going to be inside a pool and turn this into {{s1},{s2,s3}} *)
ExperimentDifferentialScanningCalorimetry[mySemiPooledInputs : ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}], _String]]], myOptions : OptionsPattern[]] := Module[
	{listedInputs, outputSpecification, output, gatherTests, containerToSampleResult, containerToSampleOutput,
		containerToSampleTests, samples, sampleOptions, validSamplePreparationResult, containerToSampleSimulation,
		updatedSimulation, updatedCache, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed},


	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentDifferentialScanningCalorimetry,
			ToList[mySemiPooledInputs],
			ToList[myOptions]
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


	(* Wrap a list around any single sample inputs to convert flat input into a nested list *)
	listedInputs = Map[
		If[Not[MatchQ[#, ObjectP[Object[Container, Plate]]]],
			ToList[#],
			#
		]&,
		mySamplesWithPreparedSamplesNamed
	];

	(* for each group, mapping containerToSampleOptions over each group to get the samples out *)
	(* ignoring the options, since'll use the ones from from ExpandIndexMatchedInputs *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = pooledContainerToSampleOptions[
			ExperimentDifferentialScanningCalorimetry,
			listedInputs,
			myOptionsWithPreparedSamplesNamed,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		{
			Check[
				{containerToSampleOutput, containerToSampleSimulation} = pooledContainerToSampleOptions[
					ExperimentDifferentialScanningCalorimetry,
					listedInputs,
					myOptionsWithPreparedSamplesNamed,
					Output -> {Result, Simulation},
					Simulation -> updatedSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],
			{}
		}
	];


	(* If we were given an empty container,return early. *)
	If[ContainsAny[containerToSampleResult, {$Failed}],

		(* if containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions *)
		(* this way we'll end up index matching each grouping to an option *)
		experimentDifferentialScanningCalorimetryCore[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
experimentDifferentialScanningCalorimetryCore[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetry]] := Module[
	{outputSpecification, output, gatherTests, listedSamples,listedOptions,validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,
		myOptionsWithPreparedSamplesNamed, safeOps, safeOpsTests, validLengths,
		validLengthTests, templatedOptions, templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol,
		cache, expandedSafeOps, newCache, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,
		objectSampleFields, objectContainerFields, packetObjectSample, packetObjectContainer,
		collapsedResolvedOptions, resourcePackets, resourcePacketTests, packetModel,
		allTests, validQ, previewRule, optionsRule, testsRule, resultRule,
		returnEarlyQ, allPackets, specifiedAliquotContainerObjects, modelFields, safeOpsNamed,
		sanitizedPooledSamples, sanitizedOptions, updatedSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[myPooledSamples], ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentDifferentialScanningCalorimetry,
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
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentDifferentialScanningCalorimetry, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentDifferentialScanningCalorimetry, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	{sanitizedPooledSamples,safeOps,sanitizedOptions}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentDifferentialScanningCalorimetry, {sanitizedPooledSamples}, sanitizedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentDifferentialScanningCalorimetry, {sanitizedPooledSamples}, sanitizedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentDifferentialScanningCalorimetry, {sanitizedPooledSamples}, sanitizedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentDifferentialScanningCalorimetry, {sanitizedPooledSamples}, sanitizedOptions], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentDifferentialScanningCalorimetry, {sanitizedPooledSamples}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* pull out all the objects specified in the AliquotContainer option *)
	specifiedAliquotContainerObjects = Cases[Flatten[{Lookup[expandedSafeOps, AliquotContainer]}], ObjectP[Object[Container]]];

	(*specify the field and packet form that we require for SamplePrep*)
	objectSampleFields = Union[{IncompatibleMaterials}, SamplePreparationCacheFields[Object[Sample]]];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
	modelFields = Union[{Name, Deprecated}, SamplePreparationCacheFields[Model[Sample]]];

	packetObjectSample = Packet[Sequence @@ objectSampleFields];
	packetObjectContainer = Packet[Container[objectContainerFields]];
	packetModel = Packet[Model[modelFields]];

	(* make the up front Download call *)
	allPackets = Quiet[
		Download[
			{
				Flatten[sanitizedPooledSamples],
				specifiedAliquotContainerObjects
			},
			{
				{
					packetObjectSample,
					packetObjectContainer,
					(*needed for the Error::DeprecatedModels testing*)
					packetModel
				},
				{Packet[Contents, Name]}
			},
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* combine all the Download information together  *)
	newCache = FlattenCachePackets[{cache, allPackets}];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveDifferentialScanningCalorimetryOptions[sanitizedPooledSamples, expandedSafeOps, Output -> {Result, Tests}, Cache -> newCache, Simulation -> updatedSimulation],
			{resolveDifferentialScanningCalorimetryOptions[sanitizedPooledSamples, expandedSafeOps, Output -> Result, Cache -> newCache, Simulation -> updatedSimulation], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentDifferentialScanningCalorimetry,
		RemoveHiddenOptions[ExperimentDifferentialScanningCalorimetry, resolvedOptions],
		Ignore -> ReplaceRule[sanitizedOptions, ContainerOut -> Lookup[resolvedOptions, ContainerOut]],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* if returnEarlyQ is True, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {Result -> $Failed, Options -> collapsedResolvedOptions, Preview -> Null, Tests -> Flatten[Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests]]}]
	];

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = If[gatherTests,
		dscResourcePackets[sanitizedPooledSamples, templatedOptions, resolvedOptions, collapsedResolvedOptions, Cache -> newCache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{dscResourcePackets[sanitizedPooledSamples, templatedOptions, resolvedOptions, collapsedResolvedOptions, Cache -> newCache, Simulation -> updatedSimulation], {}}
	];

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* if the Output option includes Tests _and_ Result, messages will be suppressed.Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed *)
	(* Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[resourcePackets, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentDifferentialScanningCalorimetry, collapsedResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* Upload the resulting protocol/resource objects; must upload protocol and resource before Status change for UPS' ShippingMaterials stuff *)
	resultRule = Result -> If[MemberQ[output, Result] && validQ,
		UploadProtocol[
			resourcePackets,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Upload -> upload,
			ParentProtocol -> parentProtocol,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage -> Object[Protocol, DifferentialScanningCalorimetry],
			Cache -> newCache,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsubsection::Closed:: *)
(*resolveDifferentialScanningCalorimetryOptions*)


(* ========== resolveDifferentialScanningCalorimetryOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)
(* the inputs are the sample packet, the model packet, and the input options (safeOptions) *)

DefineOptions[
	resolveDifferentialScanningCalorimetryOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveDifferentialScanningCalorimetryOptions[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveDifferentialScanningCalorimetryOptions]] := Module[
	{outputSpecification, output, flatSampleList, gatherTests, messages, inheritedCache, samplePrepOptions, dscOptions,
		simulatedSamples, resolvedSamplePrepOptions, simulatedCache, samplePrepTests, flatSimulatedSamples,
		poolingLengths, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		instrument, compatibleMaterialsBool, compatibleMaterialsTests, autosamplerTemperature,
		compatibleMaterialsInvalidOption, allDownloadValues, samplePackets, containerPackets, sampleModelPackets,
		fastTrack, modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest,
		numberOfReplicates, name, parentProtocol, injectionVolume, injectionRate, cleaningFrequency, blanks,
		startTemperature, endTemperature, temperatureRampRate, numScans, numSamples, tooManySamplesQ, tooManySamplesInputs,
		tooManySamplesTest, roundedDSCOptions, precisionTests, validNameQ, nameInvalidOptions, validNameTest,
		mapThreadFriendlyOptions, resolvedRescanCoolingRate, rescanCoolingRateErrors, rescanCoolingRateInvalidOptions,
		rescanCoolingRateTests, requiredAliquotContainers, pooledContainerPackets, pooledSamplePackets,
		allowedDSCWellsWithExtras, samplesAndCleanings, allowedDSCWells, preResolvedDestinationWell, poolingQ,
		specifiedDestinationWell, semiResolvedDestinationWell, destinationWellInvalidOptions, destinationWellTest,
		requiredAliquotAmounts, resolvedAliquotOptions, aliquotTests, resolveSamplePrepOptionsWithoutAliquot, dilutingQ,
		specifiedPooledMix, specifiedPooledMixRate, specifiedPooledMixTime, resolvedPooledMix, resolvedPooledMixRate,
		resolvedPooledMixTime, invalidPoolMixOptionsQ, pooledMixMismatchOptions, pooledMixMismatchTest,
		specifiedPooledCentrifuge, specifiedPooledCentrifugeForce, specifiedPooledCentrifugeTime,
		resolvedPooledCentrifuge, resolvedPooledCentrifugeForce, resolvedPooledCentrifugeTime,
		invalidPoolCentrifugeOptionsQ, pooledCentrifugeMismatchOptions, pooledCentrifugeMismatchTest,
		specifiedPooledIncubate, specifiedPooledIncubationTemperature, specifiedPooledIncubationTime,
		specifiedPooledAnnealingTime, resolvedPooledIncubate, resolvedPooledIncubationTime, startTempAboveEndTempBools,
		startTempAboveEndTempOptions, startTempAboveEndTempTests, cleaningFrequencyTooHighQ, cleaningFrequencyTooHighOptions,
		cleaningFrequencyTooHighTest,
		resolvedPooledIncubationTemperature, resolvedPooledAnnealingTime, invalidPoolIncubateOptionsQ,
		pooledIncubateMismatchOptions, pooledIncubateMismatchTest, invalidOptions, invalidInputs, allTests, confirm, canaryBranch,
		template, cache, operator, upload, outputOption, subprotocolDescription, samplesInStorage, samplePreparation,
		email, resolvedPostProcessingOptions, resolvedOptions, testsRule, resultRule, specifiedAliquotContainerObjects,
		sampleDownloadValues, aliquotContainerPackets, notEmptyAliquotContainers, notEmptyAliquotContainerOptions,
		nonEmptyAliquotContainerTest, numReplicatesNoNull, simulatedSamplesWithNumReplicates, simulation, updatedSimulation},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];
	flatSampleList = Flatten[myPooledSamples];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* separate out our abs spece options from our sample prep options *)
	{samplePrepOptions, dscOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDifferentialScanningCalorimetry, myPooledSamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDifferentialScanningCalorimetry, myPooledSamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> Result], {}}
	];

	(* get the pooled samples flatter and also get the lengths of the pooled simulated samples*)
	flatSimulatedSamples = Flatten[simulatedSamples];
	poolingLengths = Length /@ simulatedSamples;

	(* pull out all the objects specified in the AliquotContainer option *)
	specifiedAliquotContainerObjects = Cases[Flatten[{Lookup[myOptions, AliquotContainer]}], ObjectP[Object[Container]]];

	(* download everything we Downloaded from the parent function *)
	allDownloadValues = Quiet[
		Download[
			{
				Flatten[simulatedSamples],
				specifiedAliquotContainerObjects
			},
			{
				{
					Packet[Object, Type, Status, Container, Count, Volume, Model, Position, Name, Mass, Sterile, StorageCondition, ThawTime, ThawTemperature, IncompatibleMaterials],
					Packet[Container[{Model, StorageCondition, Name, Contents, TareWeight, Sterile, Status}]],
					(*needed for the Error::DeprecatedModels testing*)
					Packet[Model[{Name, Deprecated}]]
				},
				{Packet[Contents, Name]}
			},
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* split out the information about the aliquot containers and the samples themselves *)
	{sampleDownloadValues, aliquotContainerPackets} = allDownloadValues;

	(* split out the sample packets, container packets, and sample model packets *)
	samplePackets = sampleDownloadValues[[All, 1]];
	containerPackets = sampleDownloadValues[[All, 2]];
	sampleModelPackets = sampleDownloadValues[[All, 3]];

	(* get the pooled container and sample packets *)
	pooledSamplePackets = TakeList[samplePackets, poolingLengths];
	pooledContainerPackets = TakeList[containerPackets, poolingLengths];

	(* pull out some of the options that are defaulted *)
	{numberOfReplicates, instrument, fastTrack} = Lookup[dscOptions, {NumberOfReplicates, Instrument, FastTrack}];

	(* get NumberOfReplicates without Null so that math works below *)
	numReplicatesNoNull = numberOfReplicates /. {Null -> 1};

	(* --- Discarded samples are not ok --- *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[flatSampleList],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[flatSampleList, discardedInvalidInputs], Simulation -> updatedSimulation] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets = If[Not[fastTrack],
		Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Simulation -> updatedSimulation] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Simulation -> updatedSimulation] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Too many samples check --- *)

	(* get the number of samples that will go onto the instrument *)
	numSamples = If[NullQ[numberOfReplicates],
		Length[simulatedSamples],
		Length[simulatedSamples] * numberOfReplicates
	];

	(* if we have more than 40 samples, throw an error *)
	(* this might not be necessary and it might be easy to use multiple plates but for now we're doing it *)
	tooManySamplesQ = numSamples > 40;

	(* if there are more than 40 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManySamplesInputs = Which[
		TrueQ[tooManySamplesQ] && messages,
			(
				Message[Error::DSCTooManySamples, numSamples, 40];
				Download[myPooledSamples, Object]
			),
		TrueQ[tooManySamplesQ], Download[myPooledSamples, Object],
		True, {}
	];

	(* if we are gathering tests, create a test indicating whether we have too many samples or not *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided times NumberOfReplicates is not greater than 40:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[instrument, flatSimulatedSamples, Output -> {Result, Tests}, Simulation -> updatedSimulation],
		{CompatibleMaterialsQ[instrument, flatSimulatedSamples, Messages -> messages, Simulation -> updatedSimulation], {}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messages,
		{Instrument},
		{}
	];

	(* --- Option precision checks --- *)

	(* ensure that all the numerical options have the proper precision *)
	{roundedDSCOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			Association[dscOptions],
			{PooledMixRate, NestedIndexMatchingMixTime, NestedIndexMatchingCentrifugeTime, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime, AutosamplerTemperature, InjectionVolume, InjectionRate, StartTemperature, EndTemperature, TemperatureRampRate, RescanCoolingRate},
			{1 RPM, 1 Second, 1 Second, 1 Second, 1 Celsius, 1 Second, 0.1 Celsius, 10 Microliter, 10 Microliter / Second, 10^-1 Celsius, 10^-1 Celsius, 10^-1 Celsius / Hour, 10^-1 Celsius / Hour},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				Association[dscOptions],
				{PooledMixRate, NestedIndexMatchingMixTime, NestedIndexMatchingCentrifugeTime, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime, AutosamplerTemperature, InjectionVolume, InjectionRate, StartTemperature, EndTemperature, TemperatureRampRate, RescanCoolingRate},
				{1 RPM, 1 Second, 1 Second, 1 Second, 1 Celsius, 1 Second, 0.1 Celsius, 10 Microliter, 10 Microliter / Second, 10^-1 Celsius, 10^-1 Celsius, 10^-1 Celsius / Hour, 10^-1 Celsius / Hour}
			],
			{}
		}
	];

	(* pull out the options that are defaulted *)
	{
		name,
		parentProtocol,
		injectionVolume,
		injectionRate,
		cleaningFrequency,
		blanks,
		startTemperature,
		endTemperature,
		temperatureRampRate,
		numScans,
		autosamplerTemperature
	} = Lookup[
		roundedDSCOptions,
		{
			Name,
			ParentProtocol,
			InjectionVolume,
			InjectionRate,
			CleaningFrequency,
			Blanks,
			StartTemperature,
			EndTemperature,
			TemperatureRampRate,
			NumberOfScans,
			AutosamplerTemperature
		}
	];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, DifferentialScanningCalorimetry, Lookup[roundedDSCOptions, Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "DifferentialScanningCalorimetry protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a DifferentialScanningCalorimetry object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Make sure CleaningFrequency isn't larger than the number of samples --- *)

	(* get if the cleaning frequency is too high *)
	cleaningFrequencyTooHighQ = IntegerQ[cleaningFrequency] && cleaningFrequency > numSamples;
	cleaningFrequencyTooHighOptions = If[cleaningFrequencyTooHighQ && messages,
		(
			Message[Error::CleaningFrequencyTooHigh, cleaningFrequency, numSamples];
			{CleaningFrequency}
		),
		{}
	];

	(* generate a test for the CleaningFrequency check *)
	cleaningFrequencyTooHighTest = If[gatherTests && IntegerQ[cleaningFrequency],
		Test["If specified as an integer, CleaningFrequency must not be greater than the number of input samples * NumberOfReplicates:",
			cleaningFrequencyTooHighQ,
			False
		],
		Null
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentDifferentialScanningCalorimetry, roundedDSCOptions];

	(* do our "big" MapThread *)
	{
		resolvedRescanCoolingRate,
		rescanCoolingRateErrors
	} = Transpose[MapThread[
		Function[{options},
			Module[
				{rescanCoolingRateError, specifiedNumScans, specifiedRescanCoolingRate, rescanCoolingRate},

				(* set our error checking variables *)
				rescanCoolingRateError = False;

				(* pull out what was specified for RescanCoolingRate and NumberOfScans *)
				{specifiedNumScans, specifiedRescanCoolingRate} = Lookup[options, {NumberOfScans, RescanCoolingRate}];

				(* resolve the RescanCoolingRate and flip the switch if necessary *)
				{rescanCoolingRate, rescanCoolingRateError} = Which[
					(* if Automatic and we're rescanning, resolve to 300 Celsius / Hour *)
					MatchQ[specifiedRescanCoolingRate, Automatic] && MatchQ[specifiedNumScans, GreaterP[1]], {300 Celsius / Hour, False},
					(* if Automatic and we're not rescanning, resolve to Null *)
					MatchQ[specifiedRescanCoolingRate, Automatic], {Null, False},
					(* if directly specified as Null and we are rescanning, flip the error switch *)
					NullQ[specifiedRescanCoolingRate] && MatchQ[specifiedNumScans, GreaterP[1]], {specifiedRescanCoolingRate, True},
					(* if directly specified as a number and we are NOT rescanning, also flip the error switch *)
					MatchQ[specifiedRescanCoolingRate, GreaterP[0 Celsius / Hour]] && TrueQ[specifiedNumScans == 1], {specifiedRescanCoolingRate, True},
					(* otherwise, just stick with what was specified and don't flip the switch *)
					True, {specifiedRescanCoolingRate, False}
				];

				(* return the resolved value and also the error *)
				{rescanCoolingRate, rescanCoolingRateError}
			]
		],
		{mapThreadFriendlyOptions}
	]];

	(* --- Unresolvable error checking --- *)

	(* get the cases where EndTemperature is below StartTemperature *)
	startTempAboveEndTempBools = MapThread[
		#1 > #2&,
		{startTemperature, endTemperature}
	];

	(* throw a message if we have StartTemperature above EndTemperature *)
	startTempAboveEndTempOptions = If[MemberQ[startTempAboveEndTempBools, True] && messages,
		(
			Message[Error::StartTemperatureAboveEndTemperature, ObjectToString[PickList[simulatedSamples, startTempAboveEndTempBools], Simulation -> updatedSimulation]];
			{StartTemperature, EndTemperature}
		),
		{}
	];

	(* generate the StartTemperatureAboveEndTemperature tests*)
	startTempAboveEndTempTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, startTempAboveEndTempBools];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, startTempAboveEndTempBools, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", StartTemperature is below EndTemperature:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", StartTemperature is below EndTemperature:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if RescanCoolingRate and NumberOfScans are incompatible *)
	rescanCoolingRateInvalidOptions = If[MemberQ[rescanCoolingRateErrors, True] && messages,
		(
			Message[Error::RescanCoolingRateIncompatible, ObjectToString[PickList[simulatedSamples, rescanCoolingRateErrors], Simulation -> updatedSimulation]];
			{RescanCoolingRate, NumberOfScans}
		),
		{}
	];

	(* generate the RescanCoolingRateIncompatible tests *)
	rescanCoolingRateTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, rescanCoolingRateErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, rescanCoolingRateErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", RescanCoolingRate is Null if NumberOfScans is 1, or RescanCoolingRate is not Null if NumberOfScans > 1:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", RescanCoolingRate is Null if NumberOfScans is 1, or RescanCoolingRate is not Null if NumberOfScans > 1:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* --- Resolve the aliquot options --- *)

	(* get the only-even-wells from a 96 well plate since those are the only ones that samples can go into *)
	allowedDSCWellsWithExtras = Partition[Flatten[AllWells[]], 2][[All, 2]];

	(* expand the simulated samples to include number of replicates *)
	simulatedSamplesWithNumReplicates = Join @@ Map[
		ConstantArray[#, numReplicatesNoNull]&,
		simulatedSamples
	];

	(* get the pooled samples in addition to the cleaning that CleaningFrequency stated, including NumberOfReplicates expansion *)
	samplesAndCleanings = If[MatchQ[cleaningFrequency, First],
		Prepend[simulatedSamplesWithNumReplicates, "Clean"],
		simulatedSamplesWithNumReplicates
	];

	(* get the actual wells that will be used for samples and/or cleaning *)
	(* note that if we have too many samples then we are just going to fake this and repeat the allowed DSC Wells *)
	(* there might be a better way to do this? *)
	allowedDSCWells = If[Length[samplesAndCleanings] > Length[allowedDSCWellsWithExtras],
		Take[Flatten[ConstantArray[allowedDSCWellsWithExtras, Ceiling[Length[samplesAndCleanings] / Length[allowedDSCWellsWithExtras]]]], Length[samplesAndCleanings]],
		Take[allowedDSCWellsWithExtras, Length[samplesAndCleanings]]
	];

	(* get the actual pre-resolved DestinationWell option *)
	preResolvedDestinationWell = PickList[allowedDSCWells, samplesAndCleanings, ListableP[ObjectP[]]];

	(* pull out the specified DestinationWell option *)
	specifiedDestinationWell = Lookup[myOptions, DestinationWell];

	(* get the resolved DestinationWell option; if it was specified then it will be that, but might have to throw an error *)
	(* note that if we have too many samples, then this option gets super hokey so just keep it at automatic to keep it okay *)
	semiResolvedDestinationWell = Which[
		MatchQ[specifiedDestinationWell, {WellP..}],specifiedDestinationWell,
		Length[samplesAndCleanings] > Length[allowedDSCWellsWithExtras], ConstantArray[Automatic, Length[preResolvedDestinationWell]],
		True,  preResolvedDestinationWell
	];

	(* throw an error if the specified DestinationWell is incorrect *)
	destinationWellInvalidOptions = If[messages && Not[MatchQ[semiResolvedDestinationWell, {Automatic..} | preResolvedDestinationWell]],
		(
			Message[Error::DestinationWellInvalid, preResolvedDestinationWell];
			{DestinationWell}
		),
		{}
	];

	(* if we are gathering tests, create a test for the DestinationWell option *)
	destinationWellTest = If[gatherTests,
		Test["The DestinationWell option is set to a value that is compatible with the required " <> ToString[preResolvedDestinationWell] <> ":",
			MatchQ[semiResolvedDestinationWell, {Automatic..} | preResolvedDestinationWell],
			True
		],
		Nothing
	];

	(* Pick the specified aliquot containers that are not empty *)
	notEmptyAliquotContainers = Select[Flatten[aliquotContainerPackets], Not[MatchQ[Lookup[#, Contents], {}]]&];

	(* if there are any occupied containers, throw an error *)
	notEmptyAliquotContainerOptions = If[messages && Not[MatchQ[notEmptyAliquotContainers, {}]],
		(
			Message[Error::AliquotContainerOccupied, ObjectToString[notEmptyAliquotContainers, Simulation -> updatedSimulation]];
			{AliquotContainer}
		),
		{}
	];

	(* if we are gathering tests, create a test for the AliquotContainer option *)
	nonEmptyAliquotContainerTest = If[gatherTests,
		Test["The AliquotContainer option does not include already-occupied container objects:",
			MatchQ[notEmptyAliquotContainers, {}],
			True
		],
		Nothing
	];

	(* get the RequiredAliquotContainers; this is just always the DSC plate *)
	requiredAliquotContainers = ConstantArray[Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"], Length[simulatedSamples]];

	(* get the RequiredAliquotAmount; this is always 400 microliter *)
	requiredAliquotAmounts = ConstantArray[400 * Microliter, Length[simulatedSamples]];

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot = First[splitPrepOptions[resolvedSamplePrepOptions, PrepOptionSets -> {IncubatePrepOptionsNew, CentrifugePrepOptionsNew, FilterPrepOptionsNew}]];

	(* resolve the aliquot options *)
	(* we are not cool with having solids here *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[ExperimentDifferentialScanningCalorimetry, myPooledSamples, simulatedSamples, ReplaceRule[myOptions, Flatten[{resolveSamplePrepOptionsWithoutAliquot, DestinationWell -> semiResolvedDestinationWell}]], Simulation -> updatedSimulation, RequiredAliquotContainers -> requiredAliquotContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> False, Output -> {Result, Tests}],
		{resolveAliquotOptions[ExperimentDifferentialScanningCalorimetry, myPooledSamples, simulatedSamples, ReplaceRule[myOptions, Flatten[{resolveSamplePrepOptionsWithoutAliquot, DestinationWell -> semiResolvedDestinationWell}]], Simulation -> updatedSimulation, RequiredAliquotContainers -> requiredAliquotContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> False, Output -> Result], {}}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* figure out if we are ever diluting anything in the resolved aliquot options *)
	dilutingQ = MapThread[
		#2 > Total[#1]&,
		Lookup[resolvedAliquotOptions, {AliquotAmount, AssayVolume}]
	];

	(* figure out if we are pooling and/or diluting *)
	poolingQ = MemberQ[poolingLengths, GreaterP[1]] || AnyTrue[dilutingQ, TrueQ];

	(* --- Resolve the post-aliquot-pooling options --- *)

	(* pull out the specified pooled mix options *)
	{specifiedPooledMix, specifiedPooledMixRate, specifiedPooledMixTime} = Lookup[myOptions, {NestedIndexMatchingMix, PooledMixRate, NestedIndexMatchingMixTime}];

	(* NestedIndexMatchingMix resolves to True if the other pooled mixing options are specified, or if poolingQ is True *)
	resolvedPooledMix = Which[
		BooleanQ[specifiedPooledMix], specifiedPooledMix,
		MatchQ[specifiedPooledMix, Automatic] && (RPMQ[specifiedPooledMixRate] || TimeQ[specifiedPooledMixTime]), True,
		True, poolingQ
	];

	(* PooledMixRate resolves to 1975 RPM if we are mixing, or Null otherwise *)
	resolvedPooledMixRate = Which[
		MatchQ[specifiedPooledMixRate, Except[Automatic]], specifiedPooledMixRate,
		MatchQ[specifiedPooledMixRate, Automatic] && resolvedPooledMix, 1975 RPM,
		True, Null
	];

	(* NestedIndexMatchingMixTime resolves to 30 Minute if we are mixing, or Null otherwise *)
	resolvedPooledMixTime = Which[
		MatchQ[specifiedPooledMixTime, Except[Automatic]], specifiedPooledMixTime,
		MatchQ[specifiedPooledMixTime, Automatic] && resolvedPooledMix, 30 Minute,
		True, Null
	];

	(* need to throw an error if we are pool-mixing and some pool-mixing options are Null, or if we are not pool-mixing and some pool-mixing options are specified *)
	invalidPoolMixOptionsQ = Or[
		resolvedPooledMix && Not[TimeQ[resolvedPooledMixTime] && RPMQ[resolvedPooledMixRate]],
		Not[resolvedPooledMix] && Not[NullQ[resolvedPooledMixTime] && NullQ[resolvedPooledMixRate]]
	];

	(* actually throw the error *)
	pooledMixMismatchOptions = If[messages && invalidPoolMixOptionsQ,
		(
			Message[Error::PooledMixMismatch];
			{NestedIndexMatchingMix, PooledMixRate, NestedIndexMatchingMixTime}
		),
		{}
	];

	(* make the test for the pooled mix mismatch if we are gathering tests *)
	pooledMixMismatchTest = If[gatherTests,
		Test["PooledMixRate and NestedIndexMatchingMixTime are not Null if NestedIndexMatchingMix -> True, or are not specified if NestedIndexMatchingMix -> False:",
			invalidPoolMixOptionsQ,
			False
		],
		Nothing
	];

	(* pull out the specified pooled centrifuge options *)
	{specifiedPooledCentrifuge, specifiedPooledCentrifugeForce, specifiedPooledCentrifugeTime} = Lookup[myOptions, {NestedIndexMatchingCentrifuge, NestedIndexMatchingCentrifugeForce, NestedIndexMatchingCentrifugeTime}];

	(* NestedIndexMatchingCentrifuge resolves to True if the other pooled centrifuging options are specified, or if poolingQ is True *)
	resolvedPooledCentrifuge = Which[
		BooleanQ[specifiedPooledCentrifuge], specifiedPooledCentrifuge,
		MatchQ[specifiedPooledCentrifuge, Automatic] && (MatchQ[specifiedPooledCentrifugeForce, UnitsP[GravitationalAcceleration]] || TimeQ[specifiedPooledCentrifugeTime]), True,
		True, resolvedPooledMix
	];

	(* PooledMixRate resolves to 852.22 GravitationalAcceleration if we are centrifuging, or Null otherwise *)
	resolvedPooledCentrifugeForce = Which[
		MatchQ[specifiedPooledCentrifugeForce, Except[Automatic]], specifiedPooledCentrifugeForce,
		MatchQ[specifiedPooledCentrifugeForce, Automatic] && resolvedPooledCentrifuge, 852.22 GravitationalAcceleration,
		True, Null
	];

	(* NestedIndexMatchingCentrifugeTime resolves to 5 Minute if we are centrifuging, or Null otherwise *)
	resolvedPooledCentrifugeTime = Which[
		MatchQ[specifiedPooledCentrifugeTime, Except[Automatic]], specifiedPooledCentrifugeTime,
		MatchQ[specifiedPooledCentrifugeTime, Automatic] && resolvedPooledCentrifuge, 5 Minute,
		True, Null
	];

	(* need to throw an error if we are pool-centrifuging and some pool-centrifuging options are Null, or if we are not pool-centrifuging and some pool-centrifuging options are specified *)
	invalidPoolCentrifugeOptionsQ = Or[
		resolvedPooledCentrifuge && Not[TimeQ[resolvedPooledCentrifugeTime] && MatchQ[resolvedPooledCentrifugeForce, UnitsP[GravitationalAcceleration]]],
		Not[resolvedPooledCentrifuge] && Not[NullQ[resolvedPooledCentrifugeTime] && NullQ[resolvedPooledCentrifugeForce]]
	];

	(* actually throw the error *)
	pooledCentrifugeMismatchOptions = If[messages && invalidPoolCentrifugeOptionsQ,
		(
			Message[Error::PooledCentrifugeMismatch];
			{NestedIndexMatchingCentrifuge, NestedIndexMatchingCentrifugeForce, NestedIndexMatchingCentrifugeTime}
		),
		{}
	];

	(* make the test for the pooled centrifuge mismatch if we are gathering tests *)
	pooledCentrifugeMismatchTest = If[gatherTests,
		Test["NestedIndexMatchingCentrifugeForce and NestedIndexMatchingCentrifugeTime are not Null if NestedIndexMatchingCentrifuge -> True, or are not specified if NestedIndexMatchingCentrifuge -> False:",
			invalidPoolCentrifugeOptionsQ,
			False
		],
		Nothing
	];

	(* pull out the specified pooled incubate options *)
	{specifiedPooledIncubate, specifiedPooledIncubationTemperature, specifiedPooledIncubationTime, specifiedPooledAnnealingTime} = Lookup[myOptions, {NestedIndexMatchingIncubate, NestedIndexMatchingIncubationTemperature, PooledIncubationTime, NestedIndexMatchingAnnealingTime}];

	(* PooledPooledIncubate resolves to True if the other pooled incubation options are specified *)
	resolvedPooledIncubate = Which[
		BooleanQ[specifiedPooledIncubate], specifiedPooledIncubate,
		MatchQ[specifiedPooledIncubate, Automatic] && (TemperatureQ[specifiedPooledIncubationTemperature] || TimeQ[specifiedPooledIncubationTime] || TimeQ[specifiedPooledAnnealingTime]), True,
		True, False
	];

	(* PooledIncubationTime resolves to 30 Minute if we are incubating, or Null otherwise *)
	resolvedPooledIncubationTime = Which[
		MatchQ[specifiedPooledIncubationTime, Except[Automatic]], specifiedPooledIncubationTime,
		MatchQ[specifiedPooledIncubationTime, Automatic] && resolvedPooledIncubate, 30 Minute,
		True, Null
	];

	(* NestedIndexMatchingIncubationTemperature resolves to 40 Celsius if we are incubating, or Null otherwise *)
	resolvedPooledIncubationTemperature = Which[
		MatchQ[specifiedPooledIncubationTemperature, Except[Automatic]], specifiedPooledIncubationTemperature,
		MatchQ[specifiedPooledIncubationTemperature, Automatic] && resolvedPooledIncubate, 40 Celsius,
		True, Null
	];

	(* NestedIndexMatchingAnnealingTime resolves to 0 Minute if we are incubating, or Null otherwise *)
	resolvedPooledAnnealingTime = Which[
		MatchQ[specifiedPooledAnnealingTime, Except[Automatic]], specifiedPooledAnnealingTime,
		MatchQ[specifiedPooledAnnealingTime, Automatic] && resolvedPooledIncubate, 0 Minute,
		True, Null
	];

	(* need to throw an error if we are pool-incubating and some pool-incubating options are Null, or if we are not pool-incubating and some pool-incubating options are specified *)
	invalidPoolIncubateOptionsQ = Or[
		resolvedPooledIncubate && Not[TimeQ[resolvedPooledIncubationTime] && TimeQ[resolvedPooledAnnealingTime] && TemperatureQ[resolvedPooledIncubationTemperature]],
		Not[resolvedPooledIncubate] && Not[NullQ[resolvedPooledIncubationTime] && NullQ[resolvedPooledAnnealingTime] && NullQ[resolvedPooledIncubationTemperature]]
	];

	(* actually throw the error *)
	pooledIncubateMismatchOptions = If[messages && invalidPoolIncubateOptionsQ,
		(
			Message[Error::PooledIncubateMismatch];
			{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}
		),
		{}
	];

	(* make the test for the pooled incubate mismatch if we are gathering tests *)
	pooledIncubateMismatchTest = If[gatherTests,
		Test["PooledIncubationTime, NestedIndexMatchingIncubationTemperature and NestedIndexMatchingAnnealingTime are not Null if NestedIndexMatchingIncubate -> True, or are not specified if NestedIndexMatchingIncubate -> False:",
			invalidPoolIncubateOptionsQ,
			False
		],
		Nothing
	];

	(* --- Gather the errors together and throw them if we'r edoing that --- *)

	(* combine the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		rescanCoolingRateInvalidOptions,
		destinationWellInvalidOptions,
		pooledMixMismatchOptions,
		pooledCentrifugeMismatchOptions,
		pooledIncubateMismatchOptions,
		notEmptyAliquotContainerOptions,
		startTempAboveEndTempOptions,
		cleaningFrequencyTooHighOptions
	}]];

	(* combine the invalid input stogether *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInputs
	}]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		deprecatedTest,
		tooManySamplesTest,
		precisionTests,
		validNameTest,
		rescanCoolingRateTests,
		destinationWellTest,
		aliquotTests,
		pooledMixMismatchTest,
		pooledCentrifugeMismatchTest,
		pooledIncubateMismatchTest,
		nonEmptyAliquotContainerTest,
		startTempAboveEndTempTests,
		cleaningFrequencyTooHighTest
	}], _EmeraldTest];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{confirm, canaryBranch, template, cache, operator, upload, outputOption, subprotocolDescription, samplesInStorage, samplePreparation} = Lookup[myOptions, {Confirm, CanaryBranch, Template, Cache, Operator, Upload, Output, SubprotocolDescription, SamplesInStorageCondition, PreparatoryUnitOperations}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[Output -> Short]]], False,
		True, Lookup[myOptions, Email]
	];

	(* --- Do the final preparations --- *)

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = Flatten[{
		NumberOfReplicates -> numberOfReplicates,
		AutosamplerTemperature -> autosamplerTemperature,
		InjectionVolume -> injectionVolume,
		InjectionRate -> injectionRate,
		CleaningFrequency -> cleaningFrequency,
		Blanks -> blanks,
		StartTemperature -> startTemperature,
		EndTemperature -> endTemperature,
		TemperatureRampRate -> temperatureRampRate,
		NumberOfScans -> numScans,
		RescanCoolingRate -> resolvedRescanCoolingRate,
		Instrument -> instrument,
		NestedIndexMatchingMix -> resolvedPooledMix,
		PooledMixRate -> resolvedPooledMixRate,
		NestedIndexMatchingMixTime -> resolvedPooledMixTime,
		NestedIndexMatchingCentrifuge -> resolvedPooledCentrifuge,
		NestedIndexMatchingCentrifugeForce -> resolvedPooledCentrifugeForce,
		NestedIndexMatchingCentrifugeTime -> resolvedPooledCentrifugeTime,
		NestedIndexMatchingIncubate -> resolvedPooledIncubate,
		PooledIncubationTime -> resolvedPooledIncubationTime,
		NestedIndexMatchingIncubationTemperature -> resolvedPooledIncubationTemperature,
		NestedIndexMatchingAnnealingTime -> resolvedPooledAnnealingTime,
		PreparatoryUnitOperations -> samplePreparation,
		resolveSamplePrepOptionsWithoutAliquot,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		Confirm -> confirm,
		CanaryBranch -> canaryBranch,
		Name -> name,
		Template -> template,
		Cache -> cache,
		Email -> email,
		FastTrack -> fastTrack,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		Upload -> upload,
		SubprotocolDescription -> subprotocolDescription,
		SamplesInStorageCondition -> samplesInStorage
	}];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}

];



(* ::Subsubsection::Closed:: *)
(* dscResourcePackets (private helper)*)


DefineOptions[dscResourcePackets,
	Options :> {CacheOption, HelperOutputOption, SimulationOption}
];

dscResourcePackets[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}], myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myCollapsedResolvedOptions:{___Rule}, myOptions:OptionsPattern[]] := Module[
	{expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, poolLengths, numReplicates, samplesInWithReplicates, pooledSamplesInWithReplicates,
		expandForNumReplicates, aliquotsQ, blanks, startTemps, endTemps, tempRampRates, numScans, rescanCoolingRate,
		aliquotAmounts, allBlankResources, expandedSamplesInStorage, nestedSampleRequiredAmounts, runTime,
		pairedSamplesInAndVolumes, sampleVolumeRules, sampleResourceReplaceRules, samplesInResources, containerObjs,
		protocolPacket, sharedFieldPacket, finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule,
		optionsRule, testsRule, resultRule, containerModelPackets, plateSealResource, refillSampleResource,
		sampleRunTimes, cleaningFrequency, cleaningRunTimes, pooledIncubateSamplePrep, pooledMixSamplePrep, simulation,
		pooledCentrifugeSamplePrep,cleaningContainer,cleaningBottleCap,cleaningSolutionResources,cleaningBottleCapResources},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentDifferentialScanningCalorimetry, {myPooledSamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentDifferentialScanningCalorimetry,
		RemoveHiddenOptions[ExperimentDifferentialScanningCalorimetry, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[myOptions], Cache];
	simulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	(* Get the information we need via Download *)
	{
		containerObjs,
		containerModelPackets
	} = Download[
		{
			Flatten[myPooledSamples],
			Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling]
		},
		{
			{Container[Object]},
			{Packet[MaxVolume]}
		},
		Simulation -> simulation,
		Date -> Now
	];

	(* determine the pool lengths*)
	poolLengths = Length[#]& /@ myPooledSamples;

	(* get the number of replicates so that we can expand the fields (samplesIn etc.) accordingly  *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* == make the resources == *)

	(* get the SamplesIn accounting for the number of replicates *)
	(* note that we Flatten AFTER expanding so that we will have something like {s1,s2,s3,s1,2,s3,s4,s5,s4,s5} (from {{s1,s2,s3},{s4,s5}} *)
	pooledSamplesInWithReplicates = Join @@ Map[
		ConstantArray[#, numReplicates]&,
		Download[myPooledSamples, Object]
	];
	samplesInWithReplicates = Flatten[pooledSamplesInWithReplicates];

	(* we need to expand lots of the options to include number of replicates; making a function that just does this *)
	(* map over the provided option names; for each one, expand the value for it by the number of replicates*)
	expandForNumReplicates[myExpandedOptions:{__Rule}, myOptionNames:{__Symbol}, myNumberOfReplicates_Integer]:=Module[
		{},
		Map[
			Function[{optionName},
				(* need the Join @@ for this to work with pooled options *)
				Join @@ Map[
					ConstantArray[#, myNumberOfReplicates]&,
					Lookup[myExpandedOptions, optionName]
				]
			],
			myOptionNames
		]
	];

	(* expand all the important index matching fields for NumberOfReplicates *)
	{
		aliquotsQ,
		aliquotAmounts,
		blanks,
		startTemps,
		endTemps,
		tempRampRates,
		numScans,
		rescanCoolingRate,
		expandedSamplesInStorage
	} = expandForNumReplicates[expandedResolvedOptions, {Aliquot, AliquotAmount, Blanks, StartTemperature, EndTemperature, TemperatureRampRate, NumberOfScans, RescanCoolingRate, SamplesInStorageCondition}, numReplicates];

	(* get the amount required of each sample in the correct nesting arrangement *)
	nestedSampleRequiredAmounts = MapThread[
		Function[{aliquotQ, aliquotAmount},
			If[aliquotQ,
				aliquotAmount,
				{400 Microliter}
			]
		],
		{aliquotsQ, aliquotAmounts}
	];

	(* make a list of rules that connect the samples and the necessary amounts *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, Flatten[nestedSampleRequiredAmounts]}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesInWithReplicates, sampleResourceReplaceRules, {1}];

	(* make the Blank resources *)
	allBlankResources = Module[
		{talliedBlanks, blanksNoDupes, talliedBlankResources, blankPositions, blankResourceReplaceRules,
			blankResourceVolumes, blankResourceContainers},

		(* tally how many of each given blank we will be using *)
		talliedBlanks = Tally[blanks];

		(* get the blanks without the duplicates *)
		blanksNoDupes = talliedBlanks[[All, 1]];

		(* get the volumes for the blank resources *)
		blankResourceVolumes = talliedBlanks[[All, 2]] * 400 Microliter;

		(* get the containers that could actually hold the given blank resource *)
		blankResourceContainers = Map[
			Function[volume,
				Lookup[Select[Flatten[containerModelPackets], Lookup[#, MaxVolume] >= volume &], Object]
			],
			blankResourceVolumes
		];

		(* make a resource for each blank with the appropriate amount *)
		talliedBlankResources = MapThread[
			Resource[
				Sample -> #1,
				Amount -> #2,
				Container -> #3,
				Name -> ToString[Unique[]]
			]&,
			{blanksNoDupes, blankResourceVolumes, blankResourceContainers}
		];

		(* get the position of each of the models in the list of blanks *)
		blankPositions = Map[
			Position[blanks, #]&,
			blanksNoDupes
		];

		(* make replace rules converting the blank models to their resources to be used in ReplacePart below *)
		blankResourceReplaceRules = MapThread[
			#1 -> #2&,
			{blankPositions, talliedBlankResources}
		];

		(* use ReplacePart to return the blank resources *)
		ReplacePart[blanks, blankResourceReplaceRules]
	];

	(* make a resource for the water sample that I'll be making to refill the instrument *)
	refillSampleResource = Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 1*Liter, RentContainer -> True, Container -> Model[Container, Vessel, "1L Glass Bottle"]];

	(* make the resource for the plate seal *)
	plateSealResource = Resource[Sample -> Model[Item, PlateSeal, "DSC Plate Seal, 96-Well Round Pierceable"]];

	(* calculate the RunTime based on the experiment parameters *)
	sampleRunTimes = MapThread[
		Function[{start, end, rampUpRate, numScan, coolRate},
			(* get the total time of a.) all the up scans, b.) all the down scans except the last (if there is more than one), c.) the last scan, and d.) the 3 minute lead time for everything *)
			If[numScan == 1,
				numScan * (end - start) / rampUpRate + ((end - start) / (300 Celsius/Hour)) + 3 Minute,
				numScan * (end - start) / rampUpRate + (numScan - 1) * ((end - start) / coolRate) + ((end - start) / (300 Celsius/Hour)) + 3 Minute
			]
		],
		{startTemps, endTemps, tempRampRates, numScans, rescanCoolingRate}
	];

	(* pull out the CleaningFrequency option *)
	cleaningFrequency = Lookup[expandedResolvedOptions, CleaningFrequency];

	(* calculate the cleaning times *)
	(* cleans are 4 to 95 celsius with no looping and at 60 degrees celsius per hour *)
	(* we always have 3 cleanings at the end and maybe 1 at the beginning depending on CleaningFrequency *)
	cleaningRunTimes = Switch[cleaningFrequency,
		First, 4 * (95 Celsius - 4 Celsius) / (60 Celsius / Hour),
		None, 3 * (95 Celsius - 4 Celsius) / (60 Celsius / Hour),
		_Integer, (3 + Quotient[Length[samplesInResources], cleaningFrequency]) * (95 Celsius - 4 Celsius) / (60 Celsius / Hour)
	];

	(* get the total run time by combining the sampleRunTimes, cleaningRunTime, and the lead time that happens every time *)
	runTime = Total[sampleRunTimes] + cleaningRunTimes + 30 Minute;

	(* make the NestedIndexMatchingIncubateSamplePreparation field *)
	(* note that the Nulls are just for things that we don't have control over here *)
	pooledIncubateSamplePrep = ConstantArray[
		<|
			Incubate -> Lookup[expandedResolvedOptions, NestedIndexMatchingIncubate],
			IncubationTemperature -> Lookup[expandedResolvedOptions, NestedIndexMatchingIncubationTemperature],
			IncubationTime -> Lookup[expandedResolvedOptions, PooledIncubationTime],
			Mix -> Lookup[expandedResolvedOptions, NestedIndexMatchingMix],
			MixType -> Null,
			MixUntilDissolved -> Null,
			MaxIncubationTime -> Null,
			IncubationInstrument -> Null,
			AnnealingTime -> Lookup[expandedResolvedOptions, NestedIndexMatchingAnnealingTime],
			IncubateAliquotContainer -> Null,
			IncubateAliquot -> Null,
			IncubateAliquotDestinationWell -> Null
		|>,
		Length[pooledSamplesInWithReplicates]
	];

	(* make the NestedIndexMatchingMixSamplePreparation field *)
	(* this will probably get deleted eventually when we can mix and heat at the same time, but for now that is not posible so we have to use two fields *)
	pooledMixSamplePrep = ConstantArray[
		<|
			Mix -> Lookup[expandedResolvedOptions, NestedIndexMatchingMix],
			MixRate -> Lookup[expandedResolvedOptions, PooledMixRate],
			MixTime -> Lookup[expandedResolvedOptions, NestedIndexMatchingMixTime]
		|>,
		Length[pooledSamplesInWithReplicates]
	];

	(* make the NestedIndexMatchingCentrifugeSamplePreparation field *)
	(* note that the Nulls are just for things that we don't have control over here *)
	pooledCentrifugeSamplePrep = ConstantArray[
		<|
			Centrifuge -> Lookup[expandedResolvedOptions, NestedIndexMatchingCentrifuge],
			CentrifugeInstrument -> Null,
			CentrifugeIntensity -> Lookup[expandedResolvedOptions, NestedIndexMatchingCentrifugeForce],
			CentrifugeTime -> Lookup[expandedResolvedOptions, NestedIndexMatchingCentrifugeTime],
			CentrifugeTemperature -> Null,
			CentrifugeAliquotContainer -> Null,
			CentrifugeAliquot -> Null,
			CentrifugeAliquotDestinationWell -> Null
		|>,
		Length[pooledSamplesInWithReplicates]
	];
	
	(* Cleaning container *)
	cleaningContainer=Model[Container,Vessel,"DSC Wash Vessel"];
	cleaningBottleCap=Model[Item,Cap,"Snap cap for PAL3 wash and solvent module containers"];
	
	(* Make the resources for the cleaning solutions *)
	cleaningSolutionResources={
		Resource[Sample->Model[Sample,"Milli-Q water"],Amount->100 Milliliter,Container->cleaningContainer,RentContainer->True],
		Resource[Sample->Model[Sample,StockSolution,"10% Contrad solution"],Amount->100 Milliliter,Container->cleaningContainer,RentContainer->True],
		Resource[Sample->Model[Sample,StockSolution,"20% Contrad solution"],Amount->100 Milliliter,Container->cleaningContainer,RentContainer->True]
	};
	
	(* Make the resources for the cleaning solution bottle caps *)
	cleaningBottleCapResources=ConstantArray[Resource[Sample->cleaningBottleCap],3];

	(* --- Generate our protocol packet --- *)

	(* fill in the protocol packet with all the resources *)
	protocolPacket = <|
		Object -> CreateID[Object[Protocol, DifferentialScanningCalorimetry]],
		Type -> Object[Protocol, DifferentialScanningCalorimetry],
		Template -> If[MatchQ[Lookup[resolvedOptionsNoHidden, Template], FieldReferenceP[]],
			Link[Most[Lookup[resolvedOptionsNoHidden, Template]], ProtocolsTemplated],
			Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated]
		],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> resolvedOptionsNoHidden,
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ Flatten[containerObjs],
		Replace[PooledSamplesIn] -> pooledSamplesInWithReplicates,

		(* populate checkpoints with reasonable time estimates *)
		Replace[Checkpoints] -> {
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 1 Minute]]},
			{"Picking Resources", 10*Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
			(* the Thermocycling checkpoint mirrors the runTime estimated above almost directly, padded with a little bit of overhead *)
			{"Thermocycling", runTime + 30*Minute, "The thermocycling of samples is performed and data is collected.", Link[Resource[Operator -> $BaselineOperator, Time -> (runTime + 30*Minute)]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 5*Minute]]}
		},
		RunTime -> runTime,

		Instrument -> Link[Resource[Instrument -> Lookup[expandedResolvedOptions, Instrument], Time -> 5 Hour]],

		(* shared options/fields *)
		NumberOfReplicates -> numReplicates,
		ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
		MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
		MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
		Name -> Lookup[myResolvedOptions, Name],
		Operator -> Link[Lookup[myResolvedOptions, Operator]],
		SubprotocolDescription -> Lookup[myResolvedOptions, SubprotocolDescription],

		(* pooled fields *)
		Replace[NestedIndexMatchingIncubateSamplePreparation] -> pooledIncubateSamplePrep,
		Replace[NestedIndexMatchingMixSamplePreparation] -> pooledMixSamplePrep,
		Replace[NestedIndexMatchingCentrifugeSamplePreparation] -> pooledCentrifugeSamplePrep,

		(* DSC-specific options/fields *)
		InjectionVolume -> Lookup[expandedResolvedOptions, InjectionVolume],
		InjectionRate -> Lookup[expandedResolvedOptions, InjectionRate],
		AutosamplerTemperature -> (Lookup[expandedResolvedOptions, AutosamplerTemperature] /. {Ambient -> Null}),
		CleaningFrequency -> cleaningFrequency,
		Replace[StartTemperatures] -> startTemps,
		Replace[EndTemperatures] -> endTemps,
		Replace[TemperatureRampRates] -> tempRampRates,
		Replace[NumberOfScans] -> numScans,
		Replace[RescanCoolingRates] -> rescanCoolingRate,
		Replace[Blanks] -> (Link[#] & /@ allBlankResources),
		InjectionPlateSeal -> Link[plateSealResource],
		RefillSample -> Link[refillSampleResource],
		Replace[SamplesInStorage] -> expandedSamplesInStorage,
		CleaningSolutions->(Link[#]&/@cleaningSolutionResources),
		CleaningBottleCaps->(Link[#]&/@cleaningBottleCapResources)
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFieldsPooled[myPooledSamples, myResolvedOptions, Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Simulation -> simulation], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
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
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}


];

(* ::Subsection::Closed:: *)
(*ValidExperimentDifferentialScanningCalorimetryQ*)


DefineOptions[ValidExperimentDifferentialScanningCalorimetryQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentDifferentialScanningCalorimetry}
];


(* --- Overloads --- *)
ValidExperimentDifferentialScanningCalorimetryQ[myContainer : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myOptions : OptionsPattern[ValidExperimentDifferentialScanningCalorimetryQ]] := ValidExperimentDifferentialScanningCalorimetryQ[{myContainer}, myOptions];

ValidExperimentDifferentialScanningCalorimetryQ[myContainers : {ObjectP[{Object[Container], Model[Sample]}]..}, myOptions : OptionsPattern[ValidExperimentDifferentialScanningCalorimetryQ]] := Module[
	{listedOptions, preparedOptions, dscTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDifferentialScanningCalorimetry *)
	dscTests = ExperimentDifferentialScanningCalorimetry[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[dscTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[myContainers, Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[myContainers, Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, dscTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDifferentialScanningCalorimetryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDifferentialScanningCalorimetryQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDifferentialScanningCalorimetryQ"]

];

(* --- Overload for SemiPooledInputs --- *)
ValidExperimentDifferentialScanningCalorimetryQ[mySemiPooledInputs : ListableP[ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryOptions]] := Module[
	{listedOptions, preparedOptions, dscTests, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDifferentialScanningCalorimetry *)
	dscTests = ExperimentDifferentialScanningCalorimetry[mySemiPooledInputs, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[Flatten[mySemiPooledInputs], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[mySemiPooledInputs], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{dscTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDifferentialScanningCalorimetryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDifferentialScanningCalorimetryQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDifferentialScanningCalorimetryQ"]

];


(* --- Core Function --- *)
ValidExperimentDifferentialScanningCalorimetryQ[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ValidExperimentDifferentialScanningCalorimetryQ]] := Module[
	{listedOptions, preparedOptions, dscTests, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDifferentialScanningCalorimetry *)
	dscTests = ExperimentDifferentialScanningCalorimetry[myPooledSamples, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[Flatten[myPooledSamples], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[myPooledSamples], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{dscTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentDifferentialScanningCalorimetryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDifferentialScanningCalorimetryQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDifferentialScanningCalorimetryQ"]

];



(* ::Subsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetryOptions*)


DefineOptions[ExperimentDifferentialScanningCalorimetryOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentDifferentialScanningCalorimetry}
];

(* --- Overloads --- *)
ExperimentDifferentialScanningCalorimetryOptions[myContainer : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryOptions]] := ExperimentDifferentialScanningCalorimetryOptions[{myContainer}, myOptions];
ExperimentDifferentialScanningCalorimetryOptions[myContainers : {ObjectP[{Object[Container], Model[Sample]}]..}, myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDifferentialScanningCalorimetry *)
	options = ExperimentDifferentialScanningCalorimetry[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDifferentialScanningCalorimetry],
		options
	]

];

(* --- Overload for SemiPooledInputs --- *)
ExperimentDifferentialScanningCalorimetryOptions[mySemiPooledInputs : ListableP[ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryOptions]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDifferentialScanningCalorimetry *)
	options = ExperimentDifferentialScanningCalorimetry[mySemiPooledInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDifferentialScanningCalorimetry],
		options
	]
];

(* --- Core Function for PooledSamples--- *)
ExperimentDifferentialScanningCalorimetryOptions[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentDifferentialScanningCalorimetry *)
	options = ExperimentDifferentialScanningCalorimetry[myPooledSamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDifferentialScanningCalorimetry],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetryPreview*)


DefineOptions[ExperimentDifferentialScanningCalorimetryPreview,
	SharedOptions :> {ExperimentDifferentialScanningCalorimetry}
];

(* --- Overloads --- *)
ExperimentDifferentialScanningCalorimetryPreview[myContainer : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryPreview]] := ExperimentDifferentialScanningCalorimetryPreview[{myContainer}, myOptions];
ExperimentDifferentialScanningCalorimetryPreview[myContainers : {ObjectP[{Object[Container], Model[Sample]}]..}, myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDifferentialScanningCalorimetry *)
	ExperimentDifferentialScanningCalorimetry[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* SemiPooledInputs *)
ExperimentDifferentialScanningCalorimetryPreview[mySemiPooledInputs : ListableP[ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDifferentialScanningCalorimetry *)
	ExperimentDifferentialScanningCalorimetry[mySemiPooledInputs, Append[noOutputOptions, Output -> Preview]]
];

(* --- Core Function --- *)
ExperimentDifferentialScanningCalorimetryPreview[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myOptions : OptionsPattern[ExperimentDifferentialScanningCalorimetryPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentDifferentialScanningCalorimetry *)
	ExperimentDifferentialScanningCalorimetry[myPooledSamples, Append[noOutputOptions, Output -> Preview]]
];
