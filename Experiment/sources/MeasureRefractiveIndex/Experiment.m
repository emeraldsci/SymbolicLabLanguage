(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(*ExperimentMeasureRefractiveIndex*)
(* ::Section:: *)


(* ::Subsection:: *)
(*ExperimentRefractiveIndex Options and Messages*)


DefineOptions[ExperimentMeasureRefractiveIndex,
	Options :> {
		{
			OptionName -> Refractometer,
			Default -> Object[Instrument, Refractometer, "Double Rainbow"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument,Refractometer],Object[Instrument,Refractometer]}],
				ObjectTypes -> {Model[Instrument,Refractometer],Object[Instrument,Refractometer]}
			],
			Description -> "The refractometer that is used to measure the refractive index of the sample.",
			Category -> "General"
		},
		{
			OptionName -> Preparation,
			Default -> Manual,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PreparationMethodP
			],
			Description -> "The method by which the primitive should be executed in the laboratory. Manual primitives are executed by a laboratory operator and Robotic primitives are executed by a liquid handling work cell.",
			Category -> "General"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			],
			Description -> "The number of times sample volume will be injected into the refractometer and measured.",
			Category -> "Sample Injection"
		},
		{
			OptionName -> NumberOfReads,
			Default -> 1,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 10, 1]
			],
			Description -> "The number of consecutive measurements (up to 10) taken of each sample after the sample is injected into the instrument. This only works with FixedMeasurement mode.",
			Category -> "Measurement"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True,
				Description -> "A user defined word or phrase used to identify the Sample for use in downstream unit operations."
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True,
				Description -> "A user defined word or phrase to identify the Sample's container for use in downstream unit operations."
			},
			{
				OptionName -> RefractiveIndexReadingMode,
				Default -> FixedMeasurement,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> RefractiveIndexReadingModeP(*FixedMeasurement,TemperatureScan,TimeScan*)
				],
				Description -> "The refractometer can perform different measurement modes. FixedMeasurement mode measures the sample at fixed temperature. TemperatureScan mode measures samples over a temperature range with fixed intervals. TimeScan mode performs multiple measurements over a period of time by taking repeated measurement over a fixed time interval.",
				Category -> "Measurement"
			},
			{
				OptionName -> SampleVolume,
				Default -> 120 Microliter,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[100 Microliter, 200 Microliter],
					Units -> {Microliter,{Microliter, Milliliter, Liter}}
				],
				Description -> "The amount of sample volume injected into the flow cell in order to measure the refractive index. The minimum required volume to fill U-shaped micro flow cell unit for the refractometer is 100 Microliters. If the sample volume is more than 200 Microliters, excess sample volume will be flushed to waste.",
				Category -> "Sample Injection"
			},
			{
				OptionName -> SampleFlowRate,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter/Second, 1000 Microliter/Second],
					Units -> {Microliter/Second,{Microliter/Second, Microliter/Minute, Microliter/Hour, Milliliter/Second, Milliliter/Minute, Milliliter/Hour, Liter/Second, Liter/Minute, Liter/Hour}}
				],
				Description -> "The rate at which the sample is drawn from the vial and injected into the refractometer. With high viscosity samples a slower SampleFlowRate is recommended (10% of SampleVolume/second).",
				ResolutionDescription -> "Automatically set to 20% SampleVolume / second.",
				Category -> "Sample Injection"
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 125 Celsius],
						Units -> {Celsius,{Celsius, Fahrenheit, Kelvin}}
					],
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[4 Celsius, 125 Celsius],
							Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[4 Celsius, 125 Celsius],
							Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
						]
					]
				],
				Description -> "The temperature at which the flow cell will be incubated for the course of refractive index measurement.",
				ResolutionDescription -> "If RefractiveIndexReadingMode is set to FixedMeasurement or TimeScan, default temperature is set to 20.00 Celsius. If RefractiveIndexReadingMode is set to TemperatureScan, default temperature is set to Span[20 Celsius ,50 Celsius].",
				Category -> "Measurement"
			},
			{
				(* Mod[(T_end - T_start),T_step] must be 0. otherwise, it asks to change it.*)
				OptionName -> TemperatureStep,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Celsius, 120 Celsius],
					Units -> {Celsius,{Celsius, Fahrenheit, Kelvin}}
				],
				Description -> "When RefractiveIndexReadingMode is set to TemperatureScan mode, refractive index measurement starts at the initial temperature and is remeasured at each temperature step until final temperature is reached. Temperature interval must be an integer multiple of the TemperatureStep.",
				ResolutionDescription -> "If RefractiveIndexReadingMode is set to TemperatureScan mode, automatically set to (Temperature range)/10 Celsius.",
				Category -> "Measurement"
			},
			{
				OptionName -> TimeDuration,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Hour, $MaxExperimentTime],
					Units -> {Hour,{Second, Minute, Hour, Day}}
				],
				Description -> "When RefractiveIndexReadingMode is set to TimeScan mode, the sample is measured every TimeStep until it reaches to the total length of time duration.",
				ResolutionDescription -> "If RefractiveIndexReadingMode is set to TimeScan mode, automatically set to 2 hours.",
				Category -> "Measurement"
			},
			{
				(* Mod[TimeDuration,TimeStep] can be non zero. It stops at or before the length of time duration. *)
				OptionName -> TimeStep,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, $MaxExperimentTime],
					Units -> {Hour, {Second, Minute, Hour}}
				],
				Description -> "When RefractiveIndexReadingMode is set to TimeScan mode, the sample is measured every TimeStep until it reaches to the duration. The measurement will stop when the duration is reached even if it has not reached the next TimeStep.",
				ResolutionDescription -> "If RefractiveIndexReadingMode is set to TimeScan, automatically set to TimeDuration/10 hours.",
				Category -> "Measurement"
			},
			{
				OptionName -> EquilibrationTime,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 1 Hour],
					Units -> {Second,{Second,Minute,Hour}}
				],
				Description -> "The amount of time that the sample is allowed to equilibrate after the temperature reaches to the desired value before recording the refractive index. EquilibrationTime improves the stability of the measurement. With FixedMeasurement mode, the sample will be measured after EquilibrationTime once it reaches the input Temperature. With TemperatureScan mode, the sample will be measured after EquilibrationTime whenever temperature increased by TemperatureStep.",
				ResolutionDescription -> "Automatically set to 10 seconds when RefractiveIndexReadingMode is set to TemperatureScan. Otherwise set to 1 second.",
				Category -> "Measurement"
			},
			{
				OptionName -> MeasurementAccuracy,
				Default -> 0.00001,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[0.00001, 0.00002, 0.00006]
				],
				Description -> "The target accuracy of the refractive index measurement. Higher accuracy measurement can be achieved by waiting longer for the temperature to stabilize after the EquilibrationTime has passed. At accuracy 0.00001, the instrument requires the temperature to be stable within 0.005 Celsius for 15 seconds before recording the refractive index (if the stability is not reached the instrument must wait longer in order to start recording). At accuracy 0.00002, the instrument requires the temperature to be stable within 0.01 Celsius for 10 seconds before recording the refractive index. At accuracy 0.00006, the instrument requires the temperature to be stable within 0.03 Celsius for 5 seconds before recording the refractive index.",
				Category -> "Measurement"
			}
		],
		{
			OptionName -> PrimaryWashSolution,
			Default -> Model[Sample,"Milli-Q water"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description -> "The first solution used to flush out the flow cell of the instrument before and after each sample. The washing cycle involves the first flushing the flow cell with PrimaryWashSolution, then flushing with the SecondaryWashSolution, and then optionally with the TertiaryWashSolution. After all wash cycle has completed, the flow cell is dried with air for DryTime. If WashSoakTime is provided, each wash solution is allowed to sit in the flow cell for WashSoakTime before being flushed out.",
			Category -> "Washing"
		},
		{
			OptionName -> SecondaryWashSolution,
			Default -> Model[Sample,"Ethanol, Reagent Grade"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description -> "A fast-evaporating solution used to flush the primary wash solution out. The washing cycle involves the first flushing the flow cell with PrimaryWashSolution, then flushing with the SecondaryWashSolution, and then optionally with the TertiaryWashSolution. After all wash cycle has completed, the flow cell is dried with air for DryTime. If WashSoakTime is provided, each wash solution is allowed to sit in the flow cell for WashSoakTime before being flushed out.",
			Category -> "Washing"
		},
		{
			OptionName -> TertiaryWashSolution,
			Default -> Model[Sample,"Acetone, Reagent Grade"],
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
			],
			Description -> "A fast-evaporating solution used to flush the secondary wash solution out. The washing cycle involves the first flushing the flow cell with PrimaryWashSolution, then flushing with the SecondaryWashSolution, and then flushing with the TertiaryWashSolution. After all wash cycle has completed, the flow cell is dried with air for DryTime. If SoakTime is provided, each wash solution is allowed to sit in the flow cell for SoakTime before being flushed out.",
			Category -> "Washing"
		},
		{
			OptionName -> WashingVolume,
			Default -> 2 Milliliter,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[2 Milliliter, 10 Milliliter],
				Units -> Milliliter
			],
			Description -> "The volume of each washing solution injected during each wash cycle into the flow cell to clean sample residue inside of the refractometer.",
			Category -> "Washing"
		},
		{
			OptionName -> WashSoakTime,
			Default -> 0 Second,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second,15 Minute],
				Units -> {Second, {Second, Minute, Hour}}
			],
			Description -> "The length of time each washing solution is allowed to sit in the flow cell in order to allow any residue to dissolve most effectively.",
			Category -> "Washing"
		},
		{
			OptionName -> NumberOfWashes,
			Default -> 2,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 10, 1]
			],
			Description -> "The number of repeated washing process with each solution. The washing process involves the first flushing the flow cell with PrimaryWashSolution, then flushing with the SecondaryWashSolution, and then flushing with the TertiaryWashSolution. Given NumberOfWashes, each washing solution flushes through the flow cell NumberOfWashes times.",
			Category -> "Washing"
		},
		{
			OptionName -> DryTime,
			Default -> 5 Minute,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 10 Minute],
				Units -> {Second, {Second, Minute, Hour}}
			],
			Description -> "After all wash cycles have been completed, drying process starts. In order to remove any trace of washing solution in the instrument, the instrument flow cell is flushed for the duration of the DryTime.",
			Category -> "Washing"
		},
		{
			OptionName -> Calibration,
			Default -> None,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[None, BeforeRun, BetweenSamples]
			],
			Description -> "Indicates when the calibration process is performed. The instrument can be calibrated once before any measurement or once between each sample. Calibration process involves measuring the refractive index of Calibrant and comparing it to the known literature value.",
			Category -> "Calibration"
		},
		{
			OptionName -> Calibrant,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				]
			],
			Description -> "The Calibrant of known refractive index used to adjust the instrument.",
			ResolutionDescription -> "If Calibration is set to BeforeRun or BetweenSample, automatically set to Milli-Q water. Otherwise it is set to user specified calibrant.",
			Category -> "Calibration",
			UnitOperation -> True
		},
		{
			OptionName -> CalibrationTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Celsius, 40 Celsius],
				Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
			],
			Description -> "The temperature in which the refractive index of Calibrant is measured.",
			ResolutionDescription -> "If Calibration is set to BeforeRun or BetweenSample, CalibrationTemperature is set to 20 Celsius. Otherwise it is set to user specified temperature.",
			Category -> "Calibration"
		},
		{
			OptionName -> CalibrantRefractiveIndex,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1.26, 1.72]
			],
			Description -> "The known refractive index of the given Calibrant at CalibrationTemperature.",
			ResolutionDescription -> "Set to match the Calibrant model refractive index field.",
			Category -> "Calibration"
		},
		{
			OptionName -> CalibrantVolume,
			Default -> 120 Microliter,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[100 Microliter, 200 Microliter],
				Units -> {Microliter, {Microliter, Milliliter, Liter}}
			],
			Description -> "The volume of Calibrant is injected into the flow cell before adjusting the calibration function to match the known CalibrantRefractiveIndex.",
			Category -> "Calibration"
		},
		{
			OptionName -> CalibrantStorageCondition,
			Default -> Disposal,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> SampleStorageTypeP | Disposal
			],
			Description -> "After calibration is completed, any remaining Calibrant which has not been injected is stored under the CalibrantStorageCondition. It is set to disposal by default.",
			Category -> "Storage"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> RecoupSample,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "If RecoupSample is True, each sample is flushed back to the original container. Otherwise, the sample is flushed into the waste bottle after measurement has been completed.",
				Category -> "Storage"
			}
		],

		(* Shared options *)
		NonBiologyFuntopiaSharedOptions,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 40 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		SimulationOption,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions (* wash solution, *)
	}
];

Error::SamplesNotInContainers="The samples `1` are not in a container. It must be assigned to a container.";
Error::RefractiveIndexNoVolume="The samples `1` do not have volume populated. Please specify samples with non-Null volume, or use ExperimentMeasureVolume to measure the volume of the samples.";
Error::TemperatureStepValueError="The samples `1` should have a temperature step value such that the remainder on division of temperature range by temperature step is zero.";
Error::TimeStepValueError="The samples `1` should have a time step value such that the remainder on division of duration by time step is zero.";
Error::InsufficientVolumeRefractiveIndex="The samples `1` do not have enough volume to measure refractive index. The sample volume must be greater than 120 Microliters.";
Error::InvalidRefractiveIndexReadingMode = "If NumberOfReads option is greater than 1, refractive index reading mode must be FixedMeasurement. TemperatureScan and TimeScan do not support NumberOfReads greater than 1.";
Error::CalibrantRefractiveIndexDoesntExist = "The provide calibrant model `1` does not have refractive index value. Please provide refractive index of the calibrant using CalibrantRefractiveIndex option.";

(* ::Subsection:: *)
(* ExperimentMeasureRefractiveIndex Source Code *)

ExperimentMeasureRefractiveIndex[
	mySamples:ListableP[ObjectP[{Object[Sample],Model[Sample]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,safeOps,
		mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,safeOpsNamed,safeOpsTests,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,
		expandedSafeOps,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,
		protocolObject,resourcePackets,resourcePacketTests,specifiedInstrumentObjects, specifiedInstrumentModels,refractometerInstrumentModels,
		primaryWashSolutionModels,secondaryWashSolutionModels,tertiaryWashSolutionModels,mySamplesWithPreparedSamplesFields,
		mySamplesWithPreparedSamplesModelFields,mySamplesWithPreparedSamplesContainerFields,
		mySamplesWithPreparedSamplesContainerModelFields,allInstrumentModels,allSamplePackets,instrumentObjectPacket,
		instrumentModelPacket,primaryWashSolutionModelsPacket,secondaryWashSolutionModelsPacket,
		tertiaryWashSolutionModelsPacket,primaryWashSolutionObjects,primaryWashSolutionObjectsPacket,
		secondaryWashSolutionObjects,secondaryWashSolutionObjectsPacket,tertiaryWashSolutionObjects,
		tertiaryWashSolutionObjectsPacket,currentSimulation,inheritedCache,returnEarlyQ, performSimulationQ,
		simulatedProtocol,simulation,resolvedPreparation
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,currentSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureRefractiveIndex,
			listedSamples,
			listedOptions,
			DefaultPreparedModelAmount -> 40 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentMeasureRefractiveIndex, listedOptions, AutoCorrect -> False, Output -> {Result,Tests}],
		{SafeOptions[ExperimentMeasureRefractiveIndex, listedOptions, AutoCorrect -> False], {}}
	];

	(* Replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> currentSimulation];

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
	{validLengths,validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureRefractiveIndex, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentMeasureRefractiveIndex, {listedSamples}, listedOptions], Null}
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

	(* Get cache from safeOps *)
	inheritedCache = Lookup[safeOps,Cache];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[
			ExperimentMeasureRefractiveIndex,
			{ToList[mySamplesWithPreparedSamples]},
			myOptionsWithPreparedSamples,
			Output->{Result,Tests}
		],
		{ApplyTemplateOptions[
			ExperimentMeasureRefractiveIndex,
			{ToList[mySamplesWithPreparedSamples]},
			myOptionsWithPreparedSamples],Null}
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

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentMeasureRefractiveIndex,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Get specified refractometer object/model *)
	specifiedInstrumentObjects = Cases[{Lookup[expandedSafeOps,Refractometer]},ObjectP[Object[Instrument]]];
	specifiedInstrumentModels = Cases[{Lookup[expandedSafeOps,Refractometer]},ObjectP[Model[Instrument]]];

	refractometerInstrumentModels = Search[Model[Instrument, Refractometer]];
	allInstrumentModels = Join[specifiedInstrumentModels, refractometerInstrumentModels];

	(* Get specified wash solution object/model*)
	primaryWashSolutionObjects = Cases[{Lookup[expandedSafeOps,PrimaryWashSolution]},ObjectP[Object[Sample]]];
	primaryWashSolutionModels = Cases[{Lookup[expandedSafeOps,PrimaryWashSolution]},ObjectP[Model[Sample]]];
	secondaryWashSolutionObjects = Cases[{Lookup[expandedSafeOps,SecondaryWashSolution]},ObjectP[Object[Sample]]];
	secondaryWashSolutionModels = Cases[{Lookup[expandedSafeOps,SecondaryWashSolution]},ObjectP[Model[Sample]]];
	tertiaryWashSolutionObjects = Cases[{Lookup[expandedSafeOps,TertiaryWashSolution]},ObjectP[Object[Sample]]];
	tertiaryWashSolutionModels = Cases[{Lookup[expandedSafeOps,TertiaryWashSolution]},ObjectP[Model[Sample]]];


	(* ContainerMaterials in SamplePreparationCacheFields is a computable field that should be removed once SamplePreparationCacheFields are updated *)
	mySamplesWithPreparedSamplesFields=DeleteDuplicates[Packet[
		(* For sample prep *)
		Sequence@@SamplePreparationCacheFields[Object[Sample]],
		(* For Experiment *)
		RefractiveIndex,Viscosity,IncompatibleMaterials,Composition,StorageCondition,Density,
		(* Safety and transport *)
		Ventilated,BoilingPoint,
		(* Storage *)
		DefaultStorageCondition
	]];


	mySamplesWithPreparedSamplesModelFields=DeleteDuplicates[Packet[Model[{
		(* For sample prep *)
		Sequence@@SamplePreparationCacheFields[Model[Sample]],
		(* For Experiment *)
		RefractiveIndex,Viscosity,IncompatibleMaterials,Composition,Name,Solvent,State,Deprecated,Sterile,Products,
		(* Transport *)
		TransportTemperature,
		(* Storage *)
		DefaultStorageCondition
	}]]];


	mySamplesWithPreparedSamplesContainerFields=Packet[Container[{
		Sequence@@SamplePreparationCacheFields[Object[Container]]
	}]];

	mySamplesWithPreparedSamplesContainerModelFields=DeleteDuplicates[Packet[Container[Model][{
		(*For sample prep*)
		Sequence@@SamplePreparationCacheFields[Model[Container]],
		(* Experiment required *)
		MaxVolume,Name,DefaultStorageCondition,DestinationContainerModel
	}]]];

	{
		allSamplePackets,
		instrumentObjectPacket,
		instrumentModelPacket,
		primaryWashSolutionObjectsPacket,
		primaryWashSolutionModelsPacket,
		secondaryWashSolutionObjectsPacket,
		secondaryWashSolutionModelsPacket,
		tertiaryWashSolutionObjectsPacket,
		tertiaryWashSolutionModelsPacket
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				specifiedInstrumentObjects,
				allInstrumentModels,
				primaryWashSolutionObjects,
				primaryWashSolutionModels,
				secondaryWashSolutionObjects,
				secondaryWashSolutionModels,
				tertiaryWashSolutionObjects,
				tertiaryWashSolutionModels
			},
			{
				(* Downloading from mySamplesWithPreparedSamples *)
				{
					(* Download the fields specified from each sample *)
					mySamplesWithPreparedSamplesFields,

					(* Download the fields specified from each model sample *)
					mySamplesWithPreparedSamplesModelFields,

					(* Download details of the sample's container object *)
					mySamplesWithPreparedSamplesContainerFields,

					(* Download details of the sample's container model *)
					mySamplesWithPreparedSamplesContainerModelFields,

					(* Sample composition *)
					Packet[Composition[[All,2]][{State,Viscosity}]],

					(* Storage condition *)
					Packet[StorageCondition[{StorageCondition}]]
				},

				(* Download from instrument objects *)
				{
					Packet[Object,Name,Status,Model,MinSampleVolume,MinFlowRate],
					Packet[Model[{Object,Name}]]
				},

				(* Download from instrument models *)
				{
					Packet[Object, Name, MinSampleVolume, MinFlowRate]
				},

				(*Download from primary wash solution objects *)
				{mySamplesWithPreparedSamplesModelFields},

				(* Download from primary wash solution models *)
				{mySamplesWithPreparedSamplesFields},

				(*Download from secondary wash solution objects *)
				{mySamplesWithPreparedSamplesModelFields},

				(* Download from secondary wash solution models *)
				{mySamplesWithPreparedSamplesFields},
				(* Download from tertiary wash solution objects *)
				{mySamplesWithPreparedSamplesModelFields},

				(* Download from tertiary wash solution models *)
				{mySamplesWithPreparedSamplesFields}
			},
			Cache -> inheritedCache,
			Simulation -> currentSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)


	cacheBall=FlattenCachePackets[{
		inheritedCache,allSamplePackets,instrumentObjectPacket,instrumentModelPacket,primaryWashSolutionObjectsPacket,
		primaryWashSolutionModelsPacket,secondaryWashSolutionObjectsPacket,secondaryWashSolutionModelsPacket,
		tertiaryWashSolutionObjectsPacket,tertiaryWashSolutionModelsPacket
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasureRefractiveIndexOptions[
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> currentSimulation,
			Output -> {Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean,Verbose -> False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasureRefractiveIndexOptions[
				ToList[mySamplesWithPreparedSamples],
				expandedSafeOps,
				Cache->cacheBall,
				Simulation -> currentSimulation
			],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureRefractiveIndex,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureRefractiveIndex,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Preparation option in MeasureRefractiveIndex is always manual. *)
	resolvedPreparation =Manual;

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which [
		MatchQ[resolvedOptionsTests, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentMeasureRefractiveIndex,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[],
			RunTime -> 0 Minute
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		experimentMeasureRefractiveIndexResourcePackets[
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			resolvedOptions,
			Cache->cacheBall,
			Simulation -> currentSimulation,
			Output->{Result,Tests}
		],
		{experimentMeasureRefractiveIndexResourcePackets[
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> currentSimulation
		],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentMeasureRefractiveIndex[
			resourcePackets,
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> currentSimulation
		],
		{Null, currentSimulation}
	];


	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureRefractiveIndex,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* Return the raw resource packets if we are asked to do. *)
	If[MatchQ[Lookup[safeOps,UploadResources],False],
		Return[outputSpecification/.{
			Result -> resourcePackets,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureRefractiveIndex, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets, $Failed] || MatchQ[resolvedOptionsResult, $Failed],$Failed,

		(* If we want to upload an actual protocol object. *)
		True,UploadProtocol[
			resourcePackets,
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> Object[Protocol, MeasureRefractiveIndex],
			Cache -> cacheBall,
			Simulation -> simulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMeasureRefractiveIndex,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];

(* Container overload *)
ExperimentMeasureRefractiveIndex[
	myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]
]:=Module[
	{
		listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleResult,containerToSampleOutput,
		samples,sampleOptions,containerToSampleTests,currentSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,currentSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureRefractiveIndex,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentMeasureRefractiveIndex,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result,Tests},
			Simulation -> currentSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean,Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentMeasureRefractiveIndex,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> Result,
				Simulation -> currentSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
		ExperimentMeasureRefractiveIndex[samples,ReplaceRule[sampleOptions,Simulation -> currentSimulation]]
	]
];

(* ::Subsubsection:: *)
(* resolveExperimentMeasureRefractiveIndexMethod *)
DefineOptions[resolveExperimentMeasureRefractiveIndexMethod,
	SharedOptions :> {
		ExperimentMeasureRefractiveIndex,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveExperimentMeasureRefractiveIndexMethod[
	mySamples: ListableP[Automatic|(ObjectP[{Object[Sample],Object[Container]}])],
	myOptions: OptionsPattern[resolveExperimentMeasureRefractiveIndexMethod]
] := Module[
	{outputSpecification, output, gatherTests, result, tests},


	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	result = Manual;
	tests = {};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];

(* ::Subsubsection:: *)
(* Option Resolver *)

DefineOptions[
	resolveExperimentMeasureRefractiveIndexOptions,
	Options :> {HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentMeasureRefractiveIndexOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentMeasureRefractiveIndexOptions]
]:=Module[
	{outputSpecification,output,gatherTests,cache,samplePrepOptions,measureRefractiveIndexOptions,simulatedSamples,
		resolvedSamplePrepOptions,samplePrepTests, measureRefractiveIndexOptionsAssociation,currentSimulation,
		resolvedPreparation,preparationTests,simulation,simulatedCache,
		(* Input options *)
		instrument, refractiveIndexReadingMode, sampleVolume, sampleFlowRate,
		intNumberOfReplicates, numberOfReplicates, numberOfReads, measurementAccuracy, primaryWashSolution, secondaryWashSolution,
		tertiaryWashSolution, washingVolume, washSoakTime, numberOfWashes, dryTime, calibrantVolume, calibration, calibrant, calibrationTemperature,
		calibrantRefractiveIndex, recoupSample, name,samplePackets,
		(* Invalid input check *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,samplesNotInContainersPackets,samplesNotInContainersInputs,
		samplesNotInContainersTest,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,
		insufficientVolumeCheck,insufficientVolumeSamplePackets,insufficientVolumeInputs,
		insufficientVolumeTests,
		(* Options precision test *)
		refractiveIndexOptionsChecks,refractiveIndexPrecisions,roundedExperimentMeasureRefractiveIndexOptions,precisionTests,
		roundedExperimentMeasureRefractiveIndexOptionsList,allOptionsRounded,
		(* Conflicting options checks *)
		validNameQ,nameInvalidOption,validNameTest,validReadingModeQs,invalidReadingModeQ,readingModeInvalidOption,validReadingModeTest,invalidCalibrantRefractiveIndexQ,calibrantRefractiveIndexOption,validCalibrantRefractiveIndexTest,
		(* Resolve experiment options *)
		calibrantStorageCondition, resolvedCalibrant, mapThreadFriendlyOptions,resolvedCalibrantRefractiveIndex,
		resolvedSampleFlowRate,resolvedTemperature,resolvedTemperatureStep,resolvedTimeDuration,resolvedTimeStep,
		resolvedEquilibrationTime,temperatureStepWarnings,failingTemperatureStepVars,failingTemperatureStepInputs,
		failingTemperatureStepOptions,temperatureStepWarningTests,timeStepWarnings,failingTimeStepVars,failingTimeStepInputs,
		failingTimeStepOptions,timeStepWarningTests,modTempRange, resolvedCalibrationTemperature,
		(* Unresolvable option checks *)
		(* Miscellaneous options *)
		emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,
		samplesInStorageCondition,samplesOutStorageCondition,operator,imageSample,
		measureWeight,measureVolume,validSampleStorageConditionQ,validSampleStorageTests, invalidStorageConditionOptions,
		resolvedEmail,
		(* Resolve Aliquot options *)
		invalidInputs,invalidOptions,resolvedAliquotOptions,aliquotTests,requiredAliquotAmounts,requiredAliquotContainers,
		(* Resolve post processing options *)
		resolvedPostProcessingOptions,resolvedSampleLabel,resolvedSampleContainerLabel,
		resolvedOptions,allTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if Ture, then silence messages *)
	gatherTests = MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation];


	(* Separate out our MeasureRefractiveIndex options from our Sample Prep options. *)
	{samplePrepOptions,measureRefractiveIndexOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,currentSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[
			ExperimentMeasureRefractiveIndex,
			mySamples,
			samplePrepOptions,
			Cache->cache,
			Simulation -> simulation,
			Output->{Result,Tests}
		],
		{resolveSamplePrepOptionsNew[
			ExperimentMeasureRefractiveIndex,
			mySamples,
			samplePrepOptions,
			Cache->cache,
			Simulation -> simulation,
			Output->Result
		],{}}
	];
	simulatedCache = Experiment`Private`FlattenCachePackets[{cache, currentSimulation[[1]][Packets]}];

	(* Resolve preparation option. *)
	{resolvedPreparation, preparationTests} = If[MatchQ[gatherTests,True],
		resolveExperimentMeasureRefractiveIndexMethod[
			simulatedSamples,
			ReplaceRule[myOptions, ReplaceRule[resolvedSamplePrepOptions,{Simulation -> currentSimulation, Output -> {Result, Tests}}]]
		],
		{
			resolveExperimentMeasureRefractiveIndexMethod[
				simulatedSamples,
				ReplaceRule[myOptions, ReplaceRule[resolvedSamplePrepOptions,{Simulation -> currentSimulation, Output -> Result}]]
			],
			{}
		}
	];

	(* Extract the sample packets from cache.*)
	samplePackets = fetchPacketFromCache[#,simulatedCache]&/@simulatedSamples;


	(*-- INPUT VALIDATION CHECKS --*)
	(*** Check if samples are discarded ****)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*** Check if samples are in a container ***)

	(* Get the sample containers that are not in a container *)
	samplesNotInContainersPackets = Cases[Flatten[samplePackets],KeyValuePattern[Container->Null]];
	samplesNotInContainersInputs = Lookup[samplesNotInContainersPackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message. *)
	If[Length[samplesNotInContainersInputs]>0&&!gatherTests,
		Message[Error::SamplesNotInContainers, ObjectToString[samplesNotInContainersInputs, Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	samplesNotInContainersTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[samplesNotInContainersInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[samplesNotInContainersInputs, Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[samplesNotInContainersInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,samplesNotInContainersInputs], Cache->simulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*** Check if samples have volume populated ***)

	(* Get the samples from simulatedSamples that do not have volume populated. *)
	noVolumeSamplePackets = Cases[Flatten[samplePackets],KeyValuePattern[Volume->NullP]];
	noVolumeInvalidInputs = Lookup[noVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::RefractiveIndexNoVolume,ObjectToString[noVolumeInvalidInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Cache->simulatedCache]<> " have volume populated:",True,False]
			];

			passingTest = If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs],Cache->simulatedCache]<>" have volume populated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*** Check if samples have enough volume ***)

	(* Get the samples from simulatedSamples that do not have enough volume. *)
	insufficientVolumeCheck = If[NullQ[#],False,
		MatchQ[Lookup[#,Volume],LessP[120 Microliter]]
	]&/@samplePackets;
	insufficientVolumeSamplePackets = PickList[samplePackets, insufficientVolumeCheck,True];
	insufficientVolumeInputs = Lookup[insufficientVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[insufficientVolumeInputs]>0&&!gatherTests,
		Message[Error::InsufficientVolumeRefractiveIndex,ObjectToString[insufficientVolumeInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	insufficientVolumeTests = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest = If[Length[insufficientVolumeInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[insufficientVolumeInputs,Cache->simulatedCache]<> " have at least 120 Microliter of volume:",True,False]
			];

			passingTest = If[Length[insufficientVolumeInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,insufficientVolumeInputs],Cache->simulatedCache]<>" have at least 120 Microliter of volume:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)
	refractiveIndexOptionsChecks = {
		Temperature,
		TemperatureStep,
		SampleVolume,
		SampleFlowRate,
		TimeDuration,
		TimeStep,
		EquilibrationTime,
		WashingVolume,
		WashSoakTime,
		DryTime,
		CalibrantVolume,
		CalibrationTemperature
	};

	refractiveIndexPrecisions = {
		1*10^-2 Celsius,
		1*10^-2 Celsius,
		1 Microliter,
		1 Microliter/Second,
		1 Second,
		1 Second,
		1 Second,
		1 Microliter,
		1 Second,
		1 Second,
		1 Microliter,
		1*10^-2  Celsius
	};


	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureRefractiveIndexOptionsAssociation = Association[measureRefractiveIndexOptions];

	(* Round the options *)
	{roundedExperimentMeasureRefractiveIndexOptions,precisionTests} = If[
		gatherTests,
		RoundOptionPrecision[measureRefractiveIndexOptionsAssociation,refractiveIndexOptionsChecks,refractiveIndexPrecisions, Output-> {Result,Tests}],
		{RoundOptionPrecision[measureRefractiveIndexOptionsAssociation,refractiveIndexOptionsChecks,refractiveIndexPrecisions],Null}
	];

	(*	*)(* Convert association of rounded options to a list of rules *)
	roundedExperimentMeasureRefractiveIndexOptionsList = Normal[roundedExperimentMeasureRefractiveIndexOptions];

	(*	*)(* Replace the raw options with rounded values in full set of options, myOptions *)
	allOptionsRounded = ReplaceRule[
		myOptions,
		roundedExperimentMeasureRefractiveIndexOptionsList,
		Append->False
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* Pull out the options that are defaulted *)
	{
		instrument,
		refractiveIndexReadingMode,
		sampleVolume,
		sampleFlowRate,
		numberOfReplicates,
		numberOfReads,
		measurementAccuracy,
		primaryWashSolution,
		secondaryWashSolution,
		tertiaryWashSolution,
		washingVolume,
		washSoakTime,
		numberOfWashes,
		dryTime,
		calibration,
		calibrant,
		calibrationTemperature,
		calibrantVolume,
		calibrantRefractiveIndex,
		calibrantStorageCondition,
		recoupSample,
		name
	} = Lookup[allOptionsRounded,
		{
			Refractometer,
			RefractiveIndexReadingMode,
			SampleVolume,
			SampleFlowRate,
			NumberOfReplicates,
			NumberOfReads,
			MeasurementAccuracy,
			PrimaryWashSolution,
			SecondaryWashSolution,
			TertiaryWashSolution,
			WashingVolume,
			WashSoakTime,
			NumberOfWashes,
			DryTime,
			Calibration,
			Calibrant,
			CalibrationTemperature,
			CalibrantVolume,
			CalibrantRefractiveIndex,
			CalibrantStorageCondition,
			RecoupSample,
			Name
		}];

	(* Duplicated name check *)
	validNameQ = If[MatchQ[name,_String],
		(* If the name was specified, make sure it's not a duplicated name *)
		Not[DatabaseMemberQ[Object[Protocol,MeasureRefractiveIndex,name]]],

		(* Otherwise, it's okay *)
		True
	];

	(* If validNameQ is False and we are throwing messages, throw an error message. *)
	nameInvalidOption = If[!validNameQ&&!gatherTests,
		(Message[Error::DuplicateName,"MeasureRefractiveIndex protocol"];{Name}),
		{}
	];

	(* Generate test for name check *)
	validNameTest = If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already an MeasureRefractiveIndex protocol Object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(*	 If the number of reads is more than 1, then refractive index reading mode must be FixedMeasurement. *)
	validReadingModeQs = MapThread[
		Function[{readingMode},
			If[MatchQ[numberOfReads,GreaterP[1]]&&!MatchQ[readingMode,FixedMeasurement],
				False,
				True
			]
		],
		{refractiveIndexReadingMode}
	];

	invalidReadingModeQ = MemberQ[validReadingModeQs,False];

	(* if invalidReadingModeQ is True, then throw error message. *)
	readingModeInvalidOption = If[invalidReadingModeQ,
		Message[Error::InvalidRefractiveIndexReadingMode];
		{refractiveIndexReadingMode,numberOfReads},
		{}
	];

	(* Generate test for reading mode check *)
	validReadingModeTest = If[gatherTests&&MatchQ[numberOfReads,GreaterP[1]],
		Test["If the number of reading is greater than 1, the reading mode must be FixedMeasurement: ",
			invalidReadingModeQ,
			False
		],
		Nothing
	];


	(*-- RESOLVE EXPERIMENT OPTIONS --*)


	(* Options to be resolved outside of Map Thread *)
	(* Resolve calibrant solution *)
	(* Current ECL calibrant solution is Milli-Q water *)

	resolvedCalibrant = Which[

		(* If calibration is set to None, calibrant is Null*)
		MatchQ[calibration,None],Null,

		(* If calibration is not None, and calibrant is automatic, calibrant is automatically set to Milli-Q water. *)
		!MatchQ[calibration,None]&&MatchQ[calibrant,Automatic],Model[Sample,"Milli-Q water"],

		(* If calibration is not None, and a user provides a calibrant, use the specific calibrant. *)
		!MatchQ[calibration,None]&&!MatchQ[calibrant,Automatic],calibrant
	];

	(* Resolve calibration temperature*)
	resolvedCalibrationTemperature = Which[

		(* If calibration is wet to None, calibration temperature is Null*)
		MatchQ[calibration,None],Null,

		(* If calibration is not None and calibration temperature is automatic, calibration temperature is automatically set to 20 Celsius.*)
		!MatchQ[calibration,None]&&MatchQ[calibrationTemperature,Automatic],20.00 Celsius,

		(* If calibration is not None and a user provides a calibration temperature, use the specific temperature. *)
		!MatchQ[calibration,None]&&!MatchQ[calibrationTemperature,Automatic],calibrationTemperature
	];

	(* Resolve calibrant refractive index *)
	(* Refractive index of Milli-Q water is 1.332987 at 20 Celsius *)
	(* Reference: https://nvlpubs.nist.gov/nistpubs/jres/20/jresv20n4p419_A1b.pdf *)

	resolvedCalibrantRefractiveIndex = Which[

		(*If calibration is not None and calibrant refractive index is set to automatic, use refractive index of water as calibrant refractive index. *)
		!MatchQ[calibration,None]&&MatchQ[calibrantRefractiveIndex, Automatic],

		If[MatchQ[resolvedCalibrant,ObjectP[Model[Sample]]],
			resolvedCalibrant[RefractiveIndex],
			Download[resolvedCalibrant,Model,Simulation->simulation][RefractiveIndex]
		],

		(* If calibration is not None and a user provides specific refractive index, use the given value as a calibrant refractive index. *)
		!MatchQ[calibration,None]&&!MatchQ[calibrantRefractiveIndex,Automatic],calibrantRefractiveIndex,

		(* If calibration is None, refractive index of calibrant is set to Null. *)
		True,Null
	];

	(* If calibration is not None and CalibrantRefractiveIndex is Automatic and resolved calibrant refractive index value is Null, it is invalid option. *)
	invalidCalibrantRefractiveIndexQ = If[!MatchQ[calibration,None]&&MatchQ[calibrantRefractiveIndex, Automatic]&&NullQ[resolvedCalibrantRefractiveIndex],
		True,
		False
	];

	(* If invalidCalibrantRefractiveIndexQ is True, then throw error message. *)
	calibrantRefractiveIndexOption = If[invalidCalibrantRefractiveIndexQ,
		Message[Error::CalibrantRefractiveIndexDoesntExist,resolvedCalibrant];
		{calibrantRefractiveIndex,resolvedCalibrant},
		{}
	];

	(* Generate test for calibrant refractive index check *)
	validCalibrantRefractiveIndexTest = If[gatherTests&&MatchQ[resolvedCalibrant,ObjectP[{Object[Sample],Model[Sample]}]],
		Test["If Calibration is not None, refractive index of calibrant must exist:",
			invalidCalibrantRefractiveIndexQ,
			False
		],
		Nothing
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureRefractiveIndex,roundedExperimentMeasureRefractiveIndexOptions];


	(* MapThread over each of our samples. *)
	{
		(*Resolved variables *)
		resolvedSampleFlowRate,
		resolvedTemperature,
		resolvedTemperatureStep,
		resolvedTimeDuration,
		resolvedTimeStep,
		resolvedEquilibrationTime,
		(* Set up error tracking booleans*)
		temperatureStepWarnings,
		failingTemperatureStepVars,
		timeStepWarnings,
		failingTimeStepVars

	}=Transpose[MapThread[
		Function[{mySample,myMapThreadOptions},
			Module[{
				(* Variables for resolving *)
				sampleFlowRate,
				temperature,
				temperatureStep,
				timeDuration,
				timeStep,
				equilibrationTime,
				refractiveIndexReadingMode,
				mySampleObject,
				(* supplied option values *)
				subSampleFlowRate,
				subTemperature,
				subTemperatureStep,
				subTimeDuration,
				subTimeStep,
				subEquilibrationTime,
				subSampleVolume,
				(* Error tracking booleans *)
				temperatureStepWarning,
				failingTemperatureStep,
				timeStepWarning,
				failingTimeStep
			},
				(* Setup our error tracking variables *)
				{temperatureStepWarning}=ConstantArray[False, 1];

				(* Store our options in their variables *)
				{
					refractiveIndexReadingMode,
					subSampleFlowRate,
					subTemperature,
					subTemperatureStep,
					subTimeDuration,
					subTimeStep,
					subEquilibrationTime,
					subSampleVolume
				} = Lookup[myMapThreadOptions,
					{
						RefractiveIndexReadingMode,
						SampleFlowRate,
						Temperature,
						TemperatureStep,
						TimeDuration,
						TimeStep,
						EquilibrationTime,
						SampleVolume
					}
				];

				(* Shortcut to sample object *)
				mySampleObject = Lookup[mySample, Object];

				(* Resolve SampleFlowRate *)
				sampleFlowRate = If[MatchQ[subSampleFlowRate,Automatic],
					subSampleVolume*0.2 /Second,
					subSampleFlowRate
				];

				(* Resolve Temperature *)
				temperature = Which[
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&MatchQ[subTemperature,Automatic],Span[20.00 Celsius, 50.00 Celsius],
					MatchQ[refractiveIndexReadingMode,TemperatureScan],subTemperature,
					MatchQ[refractiveIndexReadingMode,TimeScan]&&MatchQ[subTemperature,Automatic],20.00 Celsius,
					MatchQ[refractiveIndexReadingMode,TimeScan],subTemperature,
					MatchQ[refractiveIndexReadingMode,FixedMeasurement]&&MatchQ[subTemperature,Automatic], 20.00 Celsius,
					True,subTemperature
				];

				(* Resolve Temperature and TemperatureStep *)
				(* Mod[temperature range, temperature step] must be zero. *)
				(* temperature range = temperature[[2]] - temperature[[1]] *)
				modTempRange = If[MatchQ[refractiveIndexReadingMode, TemperatureScan],
					Mod[temperature[[2]]-temperature[[1]],subTemperatureStep],
					Nothing
				];

				(* Initially set temperature step waring to be false. *)
				temperatureStepWarning = False;

				{temperature,temperatureStep} = Which[

					(* If the reading mode is TemperatureScan and TemperatureStep is set to automatic, then TemperatureStep is set to the temperature range divided by 10. *)
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&MatchQ[subTemperatureStep,Automatic],{temperature,(temperature[[2]]-temperature[[1]])/10.00},

					(* If the reading mode is TemperatureScan and TemperatureStep is specified by the user and Mod[temperature range,TemperatureStep] = 0 Celsius, then use the given TemperatureStep. *)
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&MatchQ[modTempRange,EqualP[0 Celsius]],{temperature,subTemperatureStep},

					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&!MatchQ[modTempRange,EqualP[0 Celsius]] && MatchQ[temperature[[2]]-modTempRange+subTemperatureStep ,LessEqualP[125 Celsius]],
					temperatureStepWarning = True; {Span[temperature[[1]],temperature[[2]]-modTempRange+subTemperatureStep],subTemperatureStep},
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&!MatchQ[modTempRange,EqualP[0 Celsius]],
					temperatureStepWarning = True; {Span[temperature[[1]],temperature[[2]]-modTempRange],subTemperatureStep},

					(* If the reading mode is TemperatureScan and TemperatureStep is specified by the user and Mod[temperature range,TemperatureStep] != 0 Celsius, *)
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&!MatchQ[modTempRange,EqualP[0 Celsius]],

					(* Set temperature step warning to be true. *)
					temperatureStepWarning = True;

					(* and then adjust temperature[[2]] such that Mod[adjusted temperature range,temperature step] = 0. *)
					If[MatchQ[temperature[[2]]-modTempRange+subTemperatureStep, LessEqualP[125]],

						(* If the adjusted temperature[[2]] is smaller or equal to 125 Celsius, use it for temperature. *)
						{Span[temperature[[1]],temperature[[2]]-modTempRange+subTemperatureStep],subTemperatureStep},

						(* If the adjusted temperature[[2]] is greater than 125 Celsius, subtract one step from the value. *)
						{Span[temperature[[1]],temperature[[2]]-modTempRange],subTemperatureStep}
					],

					(* If the reading mode is not TemperatureScan, TemperatureStep is set to Null *)
					True,{temperature,Null}
				];


				(* Collect sample and temperature step value which are failing. *)
				failingTemperatureStep = If[temperatureStepWarning,
					{mySampleObject,{subTemperatureStep}},
					{Null,{}}
				];

				(* Resolve TimeDuration *)
				timeDuration = Which[

					(* If the reading mode is TimeScan and TimeDuration is automatic, TimeDuration is set to 2 hour. *)
					MatchQ[refractiveIndexReadingMode,TimeScan]&&MatchQ[subTimeDuration,Automatic],2 Hour,

					(* If the reading mode is TimeScan and a user gives a specific TimeDuration, use the given value. *)
					MatchQ[refractiveIndexReadingMode,TimeScan],subTimeDuration,

					(* If the reading mode is not TimeScan, timeDuration is set to Null. *)
					True,Null
				];


				(* Resolve TimeStep *)

				(* Initially set time step warning to be false. *)
				timeStepWarning = False;

				{timeDuration,timeStep} = Which[

					(* If the reading mode is TimeScan and time step is automatic, time step is set to (time duration)/10. *)
					MatchQ[refractiveIndexReadingMode,TimeScan]&&MatchQ[subTimeStep,Automatic],{timeDuration,timeDuration/10},

					(* If the reading mode is TimeScan and a user provides a specific time step and Mod[time duration, time step] = 0, use the given value as time step. *)
					MatchQ[refractiveIndexReadingMode,TimeScan]&&MatchQ[Mod[timeDuration,subTimeStep],(subTimeStep-subTimeStep)],{timeDuration,subTimeStep},

					(* If the reading mode is TimeScan and a user provides a specific time step and Mod[time duration, time step] != 0, *)
					MatchQ[refractiveIndexReadingMode,TimeScan],

					(* Set time step warning to be true. *)
					timeStepWarning = True;

					(* adjust the length of time duration such that Mod[time duration, time step] = 0. *)
					{timeDuration-Mod[timeDuration,subTimeStep],timeStep},

					(* If the reading mode is not TimeScan, both time duration and time step are Null. *)
					True,{Null,Null}
				];


				(* Collect sample object and time step value which are failing. *)
				failingTimeStep =  If[timeStepWarning,
					{mySampleObject,{subTimeStep}},
					{Null,{}}
				];

				(* Resolve EquilibrationTime *)
				equilibrationTime = Which[
					MatchQ[refractiveIndexReadingMode,TemperatureScan]&&MatchQ[subEquilibrationTime,Automatic],10 Second,
					MatchQ[refractiveIndexReadingMode,TemperatureScan],subEquilibrationTime,
					!MatchQ[refractiveIndexReadingMode,TemperatureScan]&&MatchQ[subEquilibrationTime,Automatic],1 Second,
					True,subEquilibrationTime
				];

				(* Gather MapThread results *)
				{
					(* Resolved variables *)
					sampleFlowRate,
					temperature,
					temperatureStep,
					timeDuration,
					timeStep,
					equilibrationTime,
					(* Error tracking booleans. *)
					temperatureStepWarning,
					failingTemperatureStep,
					timeStepWarning,
					failingTimeStep
				}
			]
		],
		(* MapThread over index matched lists *)
		{samplePackets,mapThreadFriendlyOptions}
	]];

	{failingTemperatureStepInputs, failingTemperatureStepOptions} = Transpose[failingTemperatureStepVars]/.{Null->Nothing,{}->Nothing};

	(* Temperature step warning *)
	If[MemberQ[temperatureStepWarnings,True]&&!gatherTests,
		Message[Error::TemperatureStepValueError,ObjectToString[failingTemperatureStepInputs, Cache->simulatedCache]]
	];

	(* Generate the test *)
	temperatureStepWarningTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* Get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples,temperatureStepWarnings];

			(* Get the inputs that pass the test *)
			passingSamples = PickList[simulatedSamples,temperatureStepWarnings,False];

			(* Create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the remainder on division of temperature range by temperature step is zero: ",
					True,
					False
				],
				Nothing
			];
			passingSampleTests = If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the remainder on division of temperature range by temperature step is zero: ",
					True,
					True
				],
				Nothing
			];
			{passingSampleTests,failingSampleTests}
		]
	];

	{failingTimeStepInputs, failingTimeStepOptions} = Transpose[failingTimeStepVars]/.{Null->Nothing,{}->Nothing};


	(* Time step warning *)
	If[MemberQ[timeStepWarnings,True]&&!gatherTests,
		Message[Error::TimeStepValueError,ObjectToString[failingTimeStepInputs,Cache->simulatedCache]]
	];

	(* Generate the tests *)
	timeStepWarningTests = If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* Get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples,timeStepWarnings];

			(* Get the inputs that pass the test *)
			passingSamples = PickList[simulatedSamples,timeStepWarnings,False];

			(* Create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples]>0,
				Warning["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the remainder on division of duration by time step is zero: ",
					True,
					False
				],
				Nothing
			];
			passingSampleTests = If[Length[passingSamples]>0,
				Warning["For the provided samples "<>ObjectToString[failingSamples,Cache->simulatedCache]<>", the remainder on division of duration by time step is zero: ",
					True,
					True
				],
				Nothing
			];
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Pull out miscellaneous options *)
	{
		emailOption,
		uploadOption,
		nameOption,
		confirmOption,
		canaryBranchOption,
		parentProtocolOption,
		fastTrackOption,
		templateOption,
		samplesInStorageCondition,
		samplesOutStorageCondition,
		operator,
		imageSample,
		measureWeight,
		measureVolume
	}=Lookup[
		allOptionsRounded,
		{
			Email,
			Upload,
			Name,
			Confirm,
			CanaryBranch,
			ParentProtocol,
			FastTrack,
			Template,
			SamplesInStorageCondition,
			SamplesOutStorageCondition,
			Operator,
			ImageSample,
			MeasureWeight,
			MeasureVolume
		}
	];


	(* Check if the provided sampleStorageCondition is valid *)
	{validSampleStorageConditionQ,validSampleStorageTests} = If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageCondition,Output->{Result,Tests},Cache->simulatedCache],
		{ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageCondition,Output->Result,Cache->simulatedCache],{}}
	];

	(* If the sample storage test passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions = If[MemberQ[validSampleStorageConditionQ,False],
		{samplesInStorageCondition},
		{}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[
		Flatten[{
			discardedInvalidInputs,
			samplesNotInContainersInputs,
			noVolumeInvalidInputs,
			insufficientVolumeInputs
		}]];
	invalidOptions=DeleteDuplicates[
		Flatten[{
			nameInvalidOption,
			readingModeInvalidOption,
			failingTemperatureStepOptions,
			failingTimeStepOptions,
			invalidStorageConditionOptions,
			calibrantRefractiveIndexOption
		}]];


	allTests = Flatten[{
		(* Invalid input tests *)
		discardedTest,samplesNotInContainersTest,insufficientVolumeTests,noVolumeTest,
		(* Precision tests *)
		precisionTests,
		(* Conflicting options tests *)
		validNameTest,validSampleStorageTests,validReadingModeTest,validCalibrantRefractiveIndexTest,
		(* Map thread tests *)
		temperatureStepWarningTests,timeStepWarningTests
	}];


	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(*targetContainers=(
		(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
		(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
		(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	);*)
	intNumberOfReplicates = numberOfReplicates/.{Null->1};

	(*	requiredAliquotContainers = MapThread[*)
	(*		Function[*)
	(*			Model[Container,Vessel,"5mL Tube"]*)
	(*		],*)
	(*		{simulatedSamples}*)
	(*	];*)
	(*	requiredAliquotAmounts = MapThread[*)
	(*		Function[*)
	(*			120 Microliter * intNumberOfReplicates*)
	(*		],*)
	(*		{simulatedSamples}*)
	(*	];*)

	requiredAliquotContainers = Null;
	requiredAliquotAmounts = {120 Microliter};

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[
			ExperimentMeasureRefractiveIndex,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> simulatedCache,
			Simulation->Simulation[simulatedCache],
			RequiredAliquotContainers-> requiredAliquotContainers,
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			AllowSolids -> False,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMeasureRefractiveIndex,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache -> simulatedCache,
				Simulation->Simulation[simulatedCache],
				RequiredAliquotContainers-> requiredAliquotContainers,
				RequiredAliquotAmounts -> requiredAliquotAmounts,
				AllowSolids -> False,
				Output->Result
			],
			{}
		}
	];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["measure refractive index sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
					LookupObjectLabel[currentSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[allOptionsRounded, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["measure refractive index sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[object, Object]], _String],
					LookupObjectLabel[currentSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[allOptionsRounded , SampleContainerLabel]}
		]
	];


	(* Resolve email option *)
	resolvedEmail = If[!MatchQ[emailOption,Automatic],
		(* If email is specified, use the supplied value *)
		emailOption,

		(*If both upload->true and result is a member of output, send emails. Otherwise, do not send emails. *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* All resolved options *)
	resolvedOptions = ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				Refractometer -> instrument,
				RefractiveIndexReadingMode -> refractiveIndexReadingMode,
				SampleVolume -> sampleVolume,
				SampleFlowRate -> resolvedSampleFlowRate,
				NumberOfReplicates -> intNumberOfReplicates,
				NumberOfReads -> Round[numberOfReads],
				Temperature -> resolvedTemperature,
				TemperatureStep -> resolvedTemperatureStep,
				TimeDuration -> resolvedTimeDuration,
				TimeStep -> resolvedTimeStep,
				EquilibrationTime -> resolvedEquilibrationTime,
				MeasurementAccuracy -> measurementAccuracy,
				RecoupSample -> recoupSample,
				PrimaryWashSolution -> primaryWashSolution,
				SecondaryWashSolution -> secondaryWashSolution,
				TertiaryWashSolution -> tertiaryWashSolution,
				WashingVolume -> washingVolume,
				WashSoakTime -> washSoakTime,
				NumberOfWashes -> numberOfWashes,
				DryTime -> dryTime,
				Calibration -> calibration,
				Calibrant -> resolvedCalibrant,
				CalibrationTemperature -> resolvedCalibrationTemperature,
				CalibrantRefractiveIndex -> resolvedCalibrantRefractiveIndex,
				CalibrantVolume -> calibrantVolume,
				CalibrantStorageCondition -> calibrantStorageCondition,
				Confirm -> confirmOption,
				CanaryBranch -> canaryBranchOption,
				Name -> nameOption,
				Template -> templateOption,
				Cache -> simulatedCache,
				Email -> resolvedEmail,
				FastTrack -> fastTrackOption,
				Operator -> operator,
				ParentProtocol -> parentProtocolOption,
				Upload -> uploadOption,
				SamplesInStorageCondition -> samplesInStorageCondition,
				SamplesOutStorageCondition -> samplesOutStorageCondition,
				ImageSample -> imageSample,
				MeasureWeight -> measureWeight,
				MeasureVolume -> measureVolume,
				Simulation -> currentSimulation,
				SampleContainerLabel -> resolvedSampleContainerLabel,
				SampleLabel -> resolvedSampleLabel,
				Preparation -> resolvedPreparation
			}
		],
		Append -> False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> allTests
	}
];


(* ::Subsubsection:: *)
(*experimentMeasureRefractiveIndexResourcePackets*)


DefineOptions[
	experimentMeasureRefractiveIndexResourcePackets,
	Options:>{OutputOption,CacheOption,SimulationOption}
];


experimentMeasureRefractiveIndexResourcePackets[
	mySamples:{ObjectP[Object[Sample]]..},
	myUnresolvedOptions:{_Rule..},
	myResolvedOptions:{_Rule..},
	myOptions:OptionsPattern[]
]:=Module[
	{
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,
		inheritedCache,samplePackets,expandedAliquotVolume,pairedSamplesInAndVolumes,
		sampleVolumeRules,sampleResourceReplaceRules,samplesInResources,instrument,instrumentTime,instrumentResource,protocolPacket,
		sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,samplesWithReplicates,
		optionsWithReplicates,sampleDownloads,samplesWithoutLinks,numberOfSamples,simulation,simulatedSamples,updatedSimulation,
		cache,cacheBall,simulationRule,optionsRule,sampleLabel,sampleContainerLabel,
		(*Options*)
		refractiveIndexReadingMode,numberOfReads,numberOfReplicates,sampleVolume,sampleFlowRate,temperature,temperatureStep,
		timeDuration,timeStep,equilibrationTime,measurementAccuracy,recoupSample,intNumberOfReplicates,numberOfExpandedSamples,
		expandedForNumberOfReplicatesSampleVolumes,sampleVolumesRequired,primaryWashSolution,secondaryWashSolution,
		tertiaryWashSolution,washingVolume,numberOfWashes,calibrant,calibrantVolume,calibrantStorageCondition,calibration,
		washSoakTime,dryTime,calibrationTemperature,calibrantRefractiveIndex,
		(* Resources *)
		containersInResources,sampleSyringeResources,sampleNeedleResources,primaryWashSolutionResources,
		primaryWashSyringeResources,primaryWashNeedleResources,totalPrimaryWashVolume,totalSecondaryWashVolume,
		totalTertiaryWashVolume,totalCalibrantVolume,secondaryWashSolutionResources,secondaryWashSyringeResources,
		secondaryWashNeedleResources,tertiaryWashSolutionResources,tertiaryWashSyringeResources,tertiaryWashNeedleResources,
		wasteContainerResources,calibrantResources,calibrantSyringeResources,calibrantNeedleResources,runTime,waterResource,
		waterSyringeResource, waterNeedleResource, washDryTime, waterResourceVolume
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureRefractiveIndex, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMeasureRefractiveIndex,
		RemoveHiddenOptions[ExperimentMeasureRefractiveIndex,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Lookup cache and simulation *)
	cache = Lookup[ToList[myOptions], Cache];
	simulation =  Lookup[ToList[myOptions], Simulation];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[myResolvedOptions],Cache];
	cacheBall = FlattenCachePackets[{cache,inheritedCache}];

	(* Get rid of links in mySamples *)
	samplesWithoutLinks = mySamples/.{link_Link:>Download[link,Object]};

	(* Simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[
		ExperimentMeasureRefractiveIndex,
		mySamples,
		myResolvedOptions,
		Cache -> cacheBall,
		Simulation -> simulation
	];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates} = expandNumberOfReplicates[ExperimentMeasureRefractiveIndex,samplesWithoutLinks,expandedResolvedOptions];

	(* --- Make our one big Download call --- *)
	sampleDownloads = Quiet[
		Download[
			{mySamples},
			{
				{
					Packet[Object,State,Container,Volume,Viscosity]
				}
			},
			Cache->cacheBall,
			Simulation -> updatedSimulation,
			Date->Now
		],
		Download::FieldDoesntExist
	];

	samplePackets = Flatten[sampleDownloads];

	(* --- Make all the resources needed in the experiment --- *)

	(* Pull out options *)
	{
		sampleLabel,
		sampleContainerLabel,
		instrument,
		refractiveIndexReadingMode,
		numberOfReads,
		numberOfReplicates,
		sampleVolume,
		sampleFlowRate,
		temperature,
		temperatureStep,
		timeDuration,
		timeStep,
		equilibrationTime,
		measurementAccuracy,
		recoupSample,
		primaryWashSolution,
		secondaryWashSolution,
		tertiaryWashSolution,
		washingVolume,
		numberOfWashes,
		calibrant,
		calibrantRefractiveIndex,
		calibrantVolume,
		calibrantStorageCondition,
		calibrationTemperature,
		calibration,
		washSoakTime,
		dryTime
	}=Lookup[
		optionsWithReplicates,
		{
			SampleLabel,
			SampleContainerLabel,
			Refractometer,
			RefractiveIndexReadingMode,
			NumberOfReads,
			NumberOfReplicates,
			SampleVolume,
			SampleFlowRate,
			Temperature,
			TemperatureStep,
			TimeDuration,
			TimeStep,
			EquilibrationTime,
			MeasurementAccuracy,
			RecoupSample,
			PrimaryWashSolution,
			SecondaryWashSolution,
			TertiaryWashSolution,
			WashingVolume,
			NumberOfWashes,
			Calibrant,
			CalibrantRefractiveIndex,
			CalibrantVolume,
			CalibrantStorageCondition,
			CalibrationTemperature,
			Calibration,
			WashSoakTime,
			DryTime
		}
	];


	(* -- Generate resources for the SamplesIn -- *)

	(* Parse the number of replicates*)
	(* Convert NumberOfReplicates such that Null->1 *)
	intNumberOfReplicates = numberOfReplicates/.{Null->1};

	(* Total Number of samples to run, accounting for replicates *)
	numberOfExpandedSamples = Length[samplesWithReplicates];

	(* Total Number of samples without accounting replicates *)
	numberOfSamples = Length[mySamples];

	(* Total up the total volume of each sample used, accounting for replicates *)
	expandedForNumberOfReplicatesSampleVolumes = (# * intNumberOfReplicates)&/@Lookup[myResolvedOptions,SampleVolume];

	(* pull out the AliquotAmount option *)
	expandedAliquotVolume = Lookup[myResolvedOptions, AliquotAmount];

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)
	sampleVolumesRequired = MapThread[
		Function[{sampleVolume,aliquotVolume},
			If[VolumeQ[aliquotVolume],
				aliquotVolume,
				sampleVolume
			]
		],
		{expandedForNumberOfReplicatesSampleVolumes,expandedAliquotVolume}
	];

	(* Pair the SamplesIn and th
	eir Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		Function[{sample,volume},
			sample->volume
		],
		{samplesWithoutLinks, sampleVolumesRequired}
	];



	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[
					Sample -> sample,
					Name -> ToString[Unique[]],
					Amount -> volume
				],
				sample -> Resource[
					Sample -> sample,
					Name -> ToString[Unique[]]
				]
			]
		],
		sampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];

	(* -- Generate instrument resources -- *)

	(* ContainersIn resources *)
	containersInResources =(Link[
		Resource[
			Sample->#,
			Name-> ToString[Unique[]]
		],Protocols]&)/@Lookup[samplePackets,Container][Object];

	(* Sample syringe & needle resources *)
	sampleSyringeResources = ConstantArray[
		Resource[
			Sample -> Model[Container,Syringe,"1mL All-Plastic Disposable Syringe"],
			Name -> ToString[Unique[]]
		],numberOfExpandedSamples];

	sampleNeedleResources = ConstantArray[
		Resource[
			Sample -> Model[Item,Needle,"21g x 1 Inch Single-Use Needle"],
			Name -> ToString[Unique[]]
		],numberOfExpandedSamples];

	(* Washing resources *)
	(* Here we allow (3 + extra)-wash/dry procedures, in case it fails water check more than three times.
	 For example, calibration is set to None, if it passes water check, the total required volume for the washing solution
	is WashingVolume x NumberOfWashes x (NumberOfSamples + 2).
	 If it fails once, it would be WashingVolume x NumberOfWashes x (NumberOfSamples + 3).
	 If it fails three times, it would be WashingVolume x NumberOfWashes x (NumberOfSamples + 5).
	 The same logic applies to the case where calibration isn't set to None. *)
	totalPrimaryWashVolume = Which[
		MatchQ[calibration,None], washingVolume * (numberOfExpandedSamples + 6)*numberOfWashes,
		MatchQ[calibration,BeforeRun], washingVolume * (numberOfExpandedSamples + 7)*numberOfWashes,
		MatchQ[calibration,BetweenSamples], washingVolume *(numberOfExpandedSamples*4 + 6)*numberOfWashes
	];

	primaryWashSolutionResources = Resource[
		Sample -> primaryWashSolution,
		Container -> PreferredContainer[totalPrimaryWashVolume],
		Amount -> totalPrimaryWashVolume
	];

	primaryWashSyringeResources = Resource[
		Sample -> preferredSyringe[washingVolume],
		Name -> ToString[Unique[]]
	];

	primaryWashNeedleResources = Resource[
		Sample -> preferredNeedle[primaryWashSolutionResources[Container]],
		Name -> ToString[Unique[]]
	];

	totalSecondaryWashVolume = totalPrimaryWashVolume;

	secondaryWashSolutionResources = Resource[
		Sample -> secondaryWashSolution,
		Container -> PreferredContainer[totalSecondaryWashVolume],
		Amount -> totalSecondaryWashVolume
	];

	secondaryWashSyringeResources = Resource[
		Sample -> preferredSyringe[washingVolume],
		Name -> ToString[Unique[]]
	];

	secondaryWashNeedleResources = Resource[
		Sample -> preferredNeedle[secondaryWashSolutionResources[Container]],
		Name -> ToString[Unique[]]
	];

	totalTertiaryWashVolume = totalPrimaryWashVolume;

	tertiaryWashSolutionResources = Resource[
		Sample -> tertiaryWashSolution,
		Container -> PreferredContainer[totalTertiaryWashVolume],
		Amount -> totalTertiaryWashVolume
	];

	tertiaryWashSyringeResources = Resource[
		Sample -> preferredSyringe[washingVolume],
		Name -> ToString[Unique[]]
	];

	tertiaryWashNeedleResources = Resource[
		Sample -> preferredNeedle[tertiaryWashSolutionResources[Container]],
		Name -> ToString[Unique[]]
	];

	(* Container resources *)
	wasteContainerResources = Resource[
		Sample -> PreferredContainer[4*totalPrimaryWashVolume],
		Name -> ToString[Unique[]]
	];

	(* Calibration resources *)
	totalCalibrantVolume = Which[
		MatchQ[calibration,None], Null,
		MatchQ[calibration,BeforeRun], calibrantVolume,
		MatchQ[calibration,BetweenSamples], calibrantVolume * numberOfExpandedSamples
	];

	calibrantResources = If[MatchQ[totalCalibrantVolume,Null],
		Null,
		Resource[
			Sample -> calibrant,
			Container -> PreferredContainer[totalCalibrantVolume],
			Amount -> totalCalibrantVolume
		]
	];

	calibrantSyringeResources = If[MatchQ[totalCalibrantVolume,Null],
		Null,
		Resource[
			Sample -> Model[Container,Syringe,"1mL All-Plastic Disposable Syringe"],
			Name -> ToString[Unique[]]
		]
	];

	calibrantNeedleResources = If[MatchQ[totalCalibrantVolume,Null],
		Null,
		Resource[
			Sample -> Model[Item,Needle,"21g x 1 Inch Single-Use Needle"],
			Name -> ToString[Unique[]]
		]
	];

	waterResourceVolume = If[MatchQ[calibration,BetweenSamples],
		2*120*Microliter*numberOfExpandedSamples + 1 Milliliter,
		1 Milliliter
	];

	(* Water resources *)
	waterResource = If[MatchQ[totalCalibrantVolume,Null],
		Resource[
			Sample -> Model[Sample,"Milli-Q water"],
			Container -> PreferredContainer[1 Milliliter],
			Amount -> waterResourceVolume
		],
		Resource[
			Sample -> Model[Sample,"Milli-Q water"],
			Container -> PreferredContainer[waterResourceVolume],
			Amount -> waterResourceVolume
		]
	];

	waterSyringeResource = Resource[
		Sample -> Model[Container,Syringe,"1mL All-Plastic Disposable Syringe"],
		Name -> ToString[Unique[]]
	];

	waterNeedleResource = Resource[
		Sample -> Model[Item,Needle,"21g x 1 Inch Single-Use Needle"],
		Name -> ToString[Unique[]]
	];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)

	(* Single measurement *)
	runTime = 5 Minute;

	(* Single wash and dry process*)
	washDryTime = 10 Minute;

	instrumentTime = Which[
		MatchQ[calibration,None], runTime * numberOfExpandedSamples + washDryTime*(numberOfExpandedSamples + 3)*numberOfWashes,
		MatchQ[calibration,BeforeRun], runTime * (numberOfExpandedSamples+1) + washDryTime*(numberOfExpandedSamples + 4)*numberOfWashes,
		MatchQ[calibration,BetweenSamples], runTime *(numberOfExpandedSamples*2) + washDryTime*(numberOfExpandedSamples*4 + 3)*numberOfWashes
	];

	instrumentResource = Resource[
		Instrument -> instrument,
		Time -> instrumentTime,
		Name -> ToString[Unique[]]
	];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|

		Type -> Object[Protocol,MeasureRefractiveIndex],
		Object -> CreateID[Object[Protocol,MeasureRefractiveIndex]],
		Replace[SamplesIn] -> samplesInResources,
		Replace[ContainersIn] -> containersInResources,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> myResolvedOptions,
		Replace[NumberOfReads] -> Round[numberOfReads],
		Replace[NumberOfReplicates] -> intNumberOfReplicates,

		(* General set up *)
		Replace[Refractometer] -> Link[instrumentResource],
		Replace[WasteContainer] -> Link[wasteContainerResources],
		Replace[DensityMeter] -> Link[Object[Instrument, DensityMeter, "id:vXl9j57BZjLk"]],
		Replace[RefractiveIndexReadingModes] -> refractiveIndexReadingMode,
		Replace[MeasurementAccuracies] -> measurementAccuracy,
		DryingCartridge -> Link[Object[Part,DryingCartridge,"Refractometer Drying Cartridge"]],
		RefractometerTool -> Link[Object[Part, RefractometerTool,"Refractometer Flat Driver"]],
		ORing -> Link[Object[Part, ORing, "Refractometer Flow Cell O-Ring"]],

		(* Sample loading *)
		Replace[SampleVolumes] -> sampleVolume,
		Replace[SampleFlowRates] -> sampleFlowRate,
		Replace[SampleSyringes] -> (Link[#]&/@sampleSyringeResources),
		Replace[SampleNeedles] -> (Link[#]&/@sampleNeedleResources),

		(* Measure *)
		Replace[Temperature] -> temperature,
		Replace[TemperatureSteps] -> temperatureStep,
		Replace[TimeDurations] -> timeDuration,
		Replace[TimeSteps] -> timeStep,
		Replace[EquilibrationTimes] -> equilibrationTime,
		Replace[RecoupSamples] -> recoupSample,

		(* Washing *)
		Replace[PrimaryWashSolution] -> Link[primaryWashSolutionResources],
		Replace[PrimaryWashSyringe] -> Link[primaryWashSyringeResources],
		Replace[PrimaryWashNeedle] -> Link[primaryWashNeedleResources],
		Replace[SecondaryWashSolution] -> Link[secondaryWashSolutionResources],
		Replace[SecondaryWashSyringe] -> Link[secondaryWashSyringeResources],
		Replace[SecondaryWashNeedle] -> Link[secondaryWashNeedleResources],
		Replace[TertiaryWashSolution] -> Link[tertiaryWashSolutionResources],
		Replace[TertiaryWashSyringe] -> Link[tertiaryWashSyringeResources],
		Replace[TertiaryWashNeedle] -> Link[tertiaryWashNeedleResources],
		Replace[WashSoakTime] -> washSoakTime,
		Replace[DryTime] -> dryTime,
		Replace[NumberOfWashes] -> numberOfWashes,
		Replace[WashingVolume] -> washingVolume,

		(* Calibration *)
		Replace[Calibration] -> calibration,
		Replace[Calibrant] -> Link[calibrantResources],
		Replace[CalibrantRefractiveIndex] -> calibrantRefractiveIndex,
		Replace[CalibrantSyringe] -> Link[calibrantSyringeResources],
		Replace[CalibrantNeedle] -> Link[calibrantNeedleResources],
		Replace[CalibrantVolume] -> calibrantVolume,
		Replace[CalibrationTemperature] -> calibrationTemperature,
		Replace[CalibrantStorageCondition] -> calibrantStorageCondition,

		(* Water Check/adjustment *)
		Replace[WaterResource] -> Link[waterResource],
		Replace[WaterSyringe] -> Link[waterSyringeResource],
		Replace[WaterNeedle] -> Link[waterNeedleResource],

		Replace[Checkpoints] -> {
			{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 1 Minute]]},
			{"Measuring Refractive Index", instrumentTime, "The refractive index of the samples are measured.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> instrumentTime ]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 1*Hour]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->cacheBall,Simulation->updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[
			allResourceBlobs,
			Output -> {Result, Tests},
			FastTrack -> Lookup[myResolvedOptions, FastTrack],
			Cache->cacheBall,
			Site->Lookup[myResolvedOptions,Site],Simulation->updatedSimulation
		],
		True, {Resources`Private`fulfillableResourceQ[
			allResourceBlobs,
			FastTrack -> Lookup[myResolvedOptions, FastTrack],
			Messages -> messages,
			Cache->cacheBall,
			Site->Lookup[myResolvedOptions,Site],
			Simulation->updatedSimulation], Null}
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

	(* Generate the simulation output rule*)
	simulationRule = Simulation -> If[MemberQ[output, Simulation]&&!MemberQ[output,Result],
		finalizedPacket,
		Null
	];

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule, optionsRule, simulationRule}
];


(* ::Subsection::Closed:: *)
(*simulateExperimentMeasureRefractiveIndex*)

DefineOptions[
	simulateExperimentMeasureRefractiveIndex,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentMeasureRefractiveIndex[
	myProtocolPacket : (PacketP[Object[Protocol, MeasureRefractiveIndex], {Object, ResolvedOptions}]|$Failed|Null),
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentMeasureRefractiveIndex]
] := Module[
	{
		cache, simulation, sampleContainerPackets, protocolObject, resolvedPreparation, currentSimulation,simulationWithLabels,
		sampleTransfer,sampleVolume,numberOfReplicates,recoupSample,primaryWashSolution,secondaryWashSolution,
		tertiaryWashSolution,washingVolume,numberOfWashes, calibration, calibrant, calibrantVolume, drainWaste,allSources,
		allDestinations,allVolumes,allWashSolutions,waterSolution,intExpandedSamplesWithReplicates
	},

	(* Lookup our cache and simulation *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Look up our resolved options *)
	{
		sampleVolume,
		numberOfReplicates,
		recoupSample,
		washingVolume,
		numberOfWashes,
		calibration,
		calibrantVolume
	} = Lookup[
		myResolvedOptions,
		{
			SampleVolume,
			NumberOfReplicates,
			RecoupSample,
			WashingVolume,
			NumberOfWashes,
			Calibration,
			CalibrantVolume
		}];


	(* Download containers from our sample packets *)
	sampleContainerPackets = Download[
		mySamples,
		Packet[Container],
		Cache -> cache,
		Simulation -> simulation
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[
		MatchQ[myProtocolPacket, $Failed],SimulateCreateID[Object[Protocol,MeasureRefractiveIndex]],
		Lookup[myProtocolPacket, Object]
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation = Manual;

	(* Simulate the fulfillment of all resources by the procedure.*)
	currentSimulation = If[
		MatchQ[myProtocolPacket, $Failed],
		SimulateResources[
			<|
				Object -> protocolObject,
				Replace [SamplesIn] -> (Resource[Sample -> #]&)/@mySamples,
				ResolvedOptions -> myResolvedOptions
			|>,
			Cache -> cache,
			Simulation -> simulation
		],
		SimulateResources[
			myProtocolPacket,
			Cache -> cache,
			Simulation -> simulation
		]
	];

	(* Look up resources from protocol packet *)
	{
		primaryWashSolution,
		secondaryWashSolution,
		tertiaryWashSolution,
		calibrant,
		waterSolution
	} = Quiet[Download[
		protocolObject,
		{
			PrimaryWashSolution[Object],
			SecondaryWashSolution[Object],
			TertiaryWashSolution[Object],
			Calibrant[Object],
			WaterResource[Object]
		},
		Simulation -> currentSimulation
	],{Download::FieldDoesntExist, Download::ObjectDoesNotExist}];

	(* Define drain waste object *)
	drainWaste = Object[Sample, "id:lYq9jRzZmWZB"];

	(* All wash solutions *)
	allWashSolutions = Flatten[{primaryWashSolution,secondaryWashSolution,tertiaryWashSolution}];



	(* Define all source objects *)
	(* Since RecoupSample is an index-matching option, it can be a list of mixed True or False. We need to expand the sources list considering all RecoupSample conditions*)
	allSources = If[
		(* If Calibration is None, select False samples and wash solutions*)
		MatchQ[calibration,None],
		Join[ToList[waterSolution],PickList[mySamples,recoupSample,False],allWashSolutions],
		(* Otherwise Calibration is not None, select False samples, wash solutions and calibrant.*)
		Join[ToList[waterSolution],PickList[mySamples,recoupSample,False],allWashSolutions,ToList[calibrant]]
	];

	(* Define all destination objects *)
	allDestinations = ConstantArray[drainWaste,Length[allSources]];

	(* Expanded length of samples with replicates. *)
	intExpandedSamplesWithReplicates = numberOfReplicates * Length[mySamples];

	(* Define all transfer volume *)
	(* Similar to allSources, Since RecoupSample is an index-matching option, it can be a list of mixed True or False. We need to expand the sources list considering all RecoupSample conditions*)
	allVolumes = Which[

		(* Calibration is none *)
		MatchQ[calibration, None],
			Join[
				(* total water check volume *)
				{2*120 Microliter},
				(* total sample volume for those with false RecoupSample *)
				PickList[sampleVolume,recoupSample,False]*numberOfReplicates,
				(* total washing volume *)
				ConstantArray[washingVolume*(intExpandedSamplesWithReplicates*4 + 3)*numberOfWashes,Length[allWashSolutions]]
			],

		(* Calibration is BeforeRun *)
		MatchQ[calibration, BeforeRun],
			Join[
				(* total water check volume *)
				{2*120 Microliter},
				(* total sample volume for those with false RecoupSample *)
				PickList[sampleVolume,recoupSample,False]*numberOfReplicates,
				(* total washing volume*)
				ConstantArray[washingVolume*(intExpandedSamplesWithReplicates + 4)*numberOfWashes, Length[allWashSolutions]],
				(* total calibrant volume *)
				{calibrantVolume}
			],

		(* Calibration is BetweenSamples *)
		True,
			Join[
				(* total water check volume *)
				{2*120 Microliter},
				(* total sample volume for those with false RecoupSample *)
				PickList[sampleVolume,recoupSample,False]*numberOfReplicates,
				(* total washing volume*)
				ConstantArray[washingVolume*(intExpandedSamplesWithReplicates*4 + 3)*numberOfWashes, Length[allWashSolutions]],
				(* total calibrant volume *)
				{calibrantVolume*intExpandedSamplesWithReplicates}
			]

	];

	(* Call UploadSampleTransfer on our source and destination samples. *)
	sampleTransfer = UploadSampleTransfer[
		allSources,
		allDestinations,
		allVolumes,
		Upload -> False,
		Simulation -> currentSimulation
	];

	(* Update our simulation *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[sampleTransfer]];

	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Download[Lookup[sampleContainerPackets, Container], Object]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> If[MatchQ[resolvedPreparation, Manual],
			Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];


(* ::Subsubsection::Closed:: *)
(* ExperimentMeasureRefractiveIndex: Sister Functions *)

preferredSyringe[inputVol_?QuantityQ]:=Module[
	{syringeToUse},
	syringeToUse = Switch[inputVol,

		(* 3mL Sterile Disposable Syringe *)
		RangeP[0 Milliliter, 3 Milliliter, Inclusive->Left], Model[Container, Syringe, "id:01G6nvkKrrKY"],

		(* 5mL Sterile Disposable Syringe *)
		RangeP[3 Milliliter, 5 Milliliter, Inclusive->Left], Model[Container, Syringe, "id:P5ZnEj4P88P0"],

		(* 10mL Syringe *)
		RangeP[5 Milliliter, 10 Milliliter, Inclusive->Left], Model[Container, Syringe, "id:4pO6dMWvnn7z"],

		(* 20mL Syringe *)
		RangeP[10 Milliliter, 20 Milliliter, Inclusive->Left], Model[Container, Syringe, "id:P5ZnEj4P88OL"]
	];
	syringeToUse
];

(* Find a needle that can reach to the bottom of container. *)
preferredNeedle[input:ObjectP[{Model[Container],Object[Container]}]]:=Module[
	{containerPacket, containerDepth,needleToUse},
	containerPacket = Download[input];

	(* Find container's depth *)
	containerDepth = FirstCase[Lookup[containerPacket,{InternalDepth,WellDepth}],Except[Null],Null];

	(* Find a needle according to the internal depth of the container.*)
	needleToUse = Switch[containerDepth,

		(* Reusable Stainless Steel Non-Coring 4 in x 18G Needle *)
		RangeP[0 Inch,4 Inch],  Model[Item, Needle, "id:AEqRl9x4OE7p"],(*"14Ga x 4In Disposable Blunt Tip Lure Lock Dispensing Needle"*)

		(* Reusable Stainless Steel Non-Coring 6 in x 18G Needle *)
		GreaterP[4 Inch],  Model[Item, Needle, "id:Y0lXejrKm0Po"](*"14Ga x 10.7In Disposable Blunt Tip Lure Lock Dispensing Needle"*)
	];
	needleToUse
];

(* ::Subsection::Closed:: *)
(*ExperimentMeasureRefractiveIndexOptions*)


DefineOptions[ExperimentMeasureRefractiveIndexOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Table,List]
			],
			Description -> "Indicates whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {ExperimentMeasureRefractiveIndex}
];

ExperimentMeasureRefractiveIndexOptions[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, (Output -> _) | (OutputFormat->_)];

	(* return only the preview for ExperimentMeasureSurfaceTension *)
	options = ExperimentMeasureRefractiveIndex[myInput, Append[noOutputOptions, Output -> Options]];

	(* If options fail, return failure *)
	If[MatchQ[options,$Failed],
		Return[$Failed]
	];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureRefractiveIndex],
		options
	]
];

(* ::Subsection::Closed:: *)
(*ExperimentMeasureRefractiveIndexPreview*)

DefineOptions[ExperimentMeasureRefractiveIndexPreview,
	SharedOptions :> {ExperimentMeasureRefractiveIndex}
];

ExperimentMeasureRefractiveIndexPreview[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:= Module[
	{listedOptions, noOutputOptions},

	(* Get the options as a list*)
	listedOptions = ToList[myOptions];

	(* Remove the Output options before passing to the main function.*)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* Return only the preview for ExperimentMeasureRefractiveIndex *)
	ExperimentMeasureRefractiveIndex[myInput, Append[noOutputOptions, Output -> Preview]]
];

(* ::Subsection::Closed:: *)
(* ValidExperimentMeasureRefractiveIndexQ *)

DefineOptions[ValidExperimentMeasureRefractiveIndexQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentMeasureRefractiveIndex}
];

ValidExperimentMeasureRefractiveIndexQ[
	myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentMeasureRefractiveIndexQ]]:= Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* Remove the Output option before passing to the core function *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Return only the tests for ExperimentMeasureRefractiveIndex *)
	filterTests = ExperimentMeasureRefractiveIndex[listedInput, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test *)
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureConductivityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureRefractiveIndexQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureRefractiveIndexQ"]
];
