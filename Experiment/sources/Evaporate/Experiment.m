(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentEvaporate*)


(* ::Subsubsection:: *)
(*ExperimentEvaporate Options and Messages*)


DefineOptions[ExperimentEvaporate,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> EvaporationType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> EvaporationTypeP
				],
				Description -> "The method of inducing solvent evaporation and sample concentration. Potential types include rotary evaporation, speedvac, and nitrogen blowdown.",
				Category -> "Method"
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Instrument, VacuumCentrifuge],
							Model[Instrument, RotaryEvaporator],
							Model[Instrument, Evaporator],
							Object[Instrument, VacuumCentrifuge],
							Object[Instrument, RotaryEvaporator],
							Object[Instrument, Evaporator]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Evaporators"
						}
					}
				],
				Description -> "The instrument used to perform the vacuum evaporation, rotary evaporation, or nitrogen blow down evaporation.",
				Category -> "General"
			},

			(* --- Shared --- *)
			{
				OptionName -> EvaporationTemperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]],
					Widget[Type -> Quantity, Pattern :> RangeP[22 * Celsius, 90 * Celsius], Units -> Alternatives[Celsius, Fahrenheit, Kelvin]]
				],
				Description -> "The temperature of the sample chamber of a speedvac or the heatbath of a rotovap or nitrogen blower during evaporation.",
				Category -> "Evaporation"
			},

			{
				OptionName -> SolventBoilingPoints,
				Default -> Automatic,
				Description -> "Indicates the boiling points of the solvent(s) in the samples at atmospheric pressure. The boiling points may be specified a temperature or as a symbol. Low indicates boiling point less than 50 Celsius, Medium indicates boiling point between 50 Celsius and 90 Celsius, and High indicates boiling point greater than 90 Celsius. This information is used to determine the VacuumEvaporationMethod for the VacuumEvaporation instrument and EvaporationPressure for the RotaryEvaporation instrument and for estimating the EvaporationTemperature for the NitrogenBlowDown instruments if no value is specified.",
				ResolutionDescription -> "If no options are provided, the solvents present in the sample will be used to estimate a boiling point. If boiling point cannot be determined, will default to {Medium,High}.",
				AllowNull -> False,
				Category -> "Evaporation",
				Widget -> Alternatives[
					Adder[
						Alternatives[
							Widget[Type -> Quantity, Pattern :> GreaterP[0 * Kelvin], Units -> Alternatives[Celsius, Fahrenheit, Kelvin]],
							Widget[Type -> Enumeration, Pattern :> SolventBoilingPointP]
						]
					],
					Alternatives[
						Widget[Type -> Quantity, Pattern :> GreaterP[0 * Kelvin], Units -> Alternatives[Celsius, Fahrenheit, Kelvin]],
						Widget[Type -> Enumeration, Pattern :> SolventBoilingPointP]
					]
				]
			},

			{
				OptionName -> EvaporationTime,
				Default -> Automatic,
				AllowNull -> False,
				Category -> "Evaporation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[Minute, 48 * Hour],
					Units -> Alternatives[{Hour, {Hour, Minute, Second}}]
				],
				Description -> "The amount of time, after target temperature and pressure equilibration is achieved, that the sample(s) undergo evaporation and concentration during evaporation.",
				ResolutionDescription -> "If no options are provided, the sample volume and vapor pressures will be used to determine an estimated evaporation time."
			},

			{
				OptionName -> EvaporateUntilDry,
				Default -> False,
				AllowNull -> False,
				Category -> "Evaporation",
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "If the sample is not fully evaporated after the EvaporationTime has completed, indicates if the evaporation is repeated with the same settings until the MaxEvaporationTime is reached."
			},

			{
				OptionName -> MaxEvaporationTime,
				Default -> Automatic,
				AllowNull -> True,
				Category -> "Evaporation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Hour, {Hour, Minute, Second}}
				],
				Description -> "If the sample is not fully evaporated after the EvaporationTime has completed, maximum duration of time for which the evaporation is repeated in cycles of the EvaporationTime, using the same settings until either the sample is fully evaporated or the MaxEvaporationTime is reached.",
				ResolutionDescription -> "If EvaporateUntilDry is set to True, automatically set to three times the EvaporationTime, up to a maximum of 72 Hours."
			},

			{
				OptionName -> EquilibrationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Minute, 10 * Minute],
					Units -> Alternatives[{Minute, {Minute, Hour}}]
				],
				Description -> "The amount of time the samples will be incubated in the instrument at the EvaporationTemperature specified.",
				ResolutionDescription -> "If a VacuumEvaporationMethod is specified, it will pull EquilibrationTime from that. Otherwise it will default to 5 Minute.",
				Category -> "Evaporation"
			},

			(* Options shared by a subset of the instruments *)
			{
				OptionName -> EvaporationPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Milli * Bar, 1030 * Milli * Bar],
						Units -> Alternatives[
							{Bar, {Milli * Bar, Bar}},
							{Torr, {Torr}},
							{Kilo * Pascal, {Kilo * Pascal, Pascal}},
							{PSI, {PSI}}
						]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[MaxVacuum]
					]
				],
				Description -> "The vacuum pressure the evaporation will be conducted under.",
				ResolutionDescription -> "Will use the EvaporationPressure provided from the resolved VacuumEvaporationMethod object.  If a method object is not provided and using RotaryEvaporation, automatically set to 10 Millibar below the combined vapor pressure of the sample's Composition (if greater than 100 Millibar), or 5 Millibar below the combined vapor pressure (if greater than 50 Millibar), or otherwise the combined vapor pressures of the sample's Composition ifself.",
				Category -> "SpeedVac and RotaryEvaporation"
			},

			{
				OptionName -> PressureRampTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Hour, 12 * Hour],
					Units -> Alternatives[{Hour, {Hour, Minute}}]
				],
				Description -> "The amount of time the instrument will use to gradually evacuate the chamber until EvaporationPressure is achieved before evaporation.",
				ResolutionDescription -> "Will use the PressureRampTime provided from the VacuumEvaporationMethod object.  If not specified, otherwise set to 1 Hour for Speedvac and 10 Minute for RotaryEvaporation.",
				Category -> "SpeedVac and RotaryEvaporation"
			},

			(* --- Rotary Evaporation --- *)
			{
				OptionName -> RotationRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 RPM, 300 RPM], Units -> RPM],
				Description -> "Frequency of rotation that the evaporation flask is spun at during evaporation.",
				ResolutionDescription -> "If left as Automatic, the sample volume will be used to determine an appropriate rotation rate.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> EvaporationFlask,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Container, Vessel],
							Object[Container, Vessel]
						}
					]
				],
				Description -> "The container that will hold the pooled samples and rotate while partially submerged in the instrument's heatbath during evaporation.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> CondenserTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]],
					Widget[Type -> Quantity, Pattern :> RangeP[-30 * Celsius, $AmbientTemperature], Units -> Alternatives[Celsius, Fahrenheit, Kelvin]]
				],
				Description -> "The temperature of the cooling coil liquid during evaporation.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> RecoupBumpTrap,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the bump trap should be rinsed with BumpTrapRinseSolution to resuspend any dried material that was caught by the trap. Any sample saved will be stored in the container model specified in BumpTrapSampleContainer.",
				ResolutionDescription -> "If type is RotaryEvaporation, defaults to False. Otherwise defaults to Null.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> BumpTrapRinseSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Sample],
							Object[Sample]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Solvents"
						}
					}
				],
				Description -> "If RecoupBumpTrap is True, indicates which chemical or stock solution to rinse the bump trap with to resuspend any dried material that was caught by the trap.",
				ResolutionDescription -> "If EvaporationType is set to RotaryEvaporation, set to Acetone. Otherwise set to Null.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> BumpTrapRinseVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Milliliter, 500 * Milliliter],
					Units -> {Milliliter, {Milliliter, Liter, Microliter}}
				],
				Description -> "If RecoupBumpTrap is True, indicates how much BumpTrapRinseSolution should be used to rinse the bump trap with to resuspend any dried material that was caught by the trap.",
				ResolutionDescription -> "If RecoupBumpTrap is True, defaults to 25% the volume of the bump trap used.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> BumpTrapSampleContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Container],
							Object[Container]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "If RecoupBumpTrap is True, indicates which container to use or stock solution to rinse the bump trap with to resuspend any dried material that was caught by the trap.",
				ResolutionDescription -> "If RecoupBumpTrap is True and EvaporateUntilDry is False, defaults to a scintillation vial if BumpTrapRinseVolume is low enough. If RecoupBumpTrap is True and EvaporateUntilDry is True, defaults to EvaporationContainer to indicate material will be resuspended and then put back into the evaporation flask for additional evaporation.",
				Category -> "RotaryEvaporation"
			},
			{
				OptionName -> RecoupCondensate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the contents of the condensate flask rinsed should be collected.",
				ResolutionDescription -> "If type is RotaryEvaporation, defaults to False. Otherwise defaults to Null.",
				Category -> "RotaryEvaporation"
			},
			(* TODO message for making sure you don't have False and then a value here *)
			{
				OptionName -> CondensateSampleContainer,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[
						{
							Model[Container],
							Object[Container]
						}
					],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					}
				],
				Description -> "If RecoupCondensate is True, indicates the container into which condensate is transferred at the end of the protocol.",
				ResolutionDescription -> "If RecoupCondensate is True, then automatically set to the PreferredContainer for the full volume of the source sample.  Otherwise set to Null.",
				Category -> "RotaryEvaporation"
			},

			(* --- Vacuum Centrifugation --- *)

			{
				OptionName -> VacuumEvaporationMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, VacuumEvaporation]]
				],
				Description -> "The method object describing the set of conditions used to evaporate the samples.",
				ResolutionDescription -> "The SolventBoilingPoint option and the composition of the samples provided are used to pick from a list of preset methods objects.",
				Category -> "SpeedVac"
			},

			{
				OptionName -> BumpProtection,
				Default -> False,
				Description -> "Indicates whether the input samples should be handled with extra care when brought under vacuum to prevent them from boiling rapidly (bumping). The speedvac will decrease pressure gradually, instead of in a rapid and non-linear fashion, to prevent bumping.",
				AllowNull -> True,
				Category -> "SpeedVac",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},

			{
				OptionName -> BalancingSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials"
						}
					}
				],
				Description -> "The solution used to counterbalance samples during evaporation, if a counterbalance is needed.",
				Category -> "SpeedVac"
			},

			(* --- Needle Dryer --- *)

			{
				OptionName -> FlowRateProfile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"FlowRate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.25 Liter / Minute, 25 Liter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						],
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[Minute, 48 * Hour],
							Units -> Alternatives[{Hour, {Hour, Minute}}]
						]
					},
					Adder[
						{
							"FlowRate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.25 Liter / Minute, 25 Liter / Minute],
								Units :> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[Minute, 48 * Hour],
								Units -> Alternatives[{Hour, {Hour, Minute}}]
							]
						},
						Orientation -> Vertical
					]
				],
				Description -> "The volume of gas over time and time that nitrogen is blown over samples to increase evaporation. Up to three stages with different flow rates and times are possible.",
				ResolutionDescription -> "If the needle dryer is selected, defaults to 1 stage. If the tube dryer is selected, defaults to 2 stages. Total Time for 3 stages will be under 72 Hour",
				Category -> "NitrogenBlowDown"
			}

		],
		(*NumberOfReplicates would be here but ExperimentEvaporate utilizes an option, EvaporateUntilDry, to allow for users to repeat the experiment if their samples are not completely dry after 1 round.
			This is because it is difficult to gauge the length of an evaporation run, which can take 12+ hours or more. The EvaporateUntilDry option polls lab ops to determine whether a sample is fully evaporated,
 			and if not, then the sample will enter in another round of evaporation so long as the total time has not exceeded 72 h. *)
		SimulationOption,
		NonBiologyFuntopiaSharedOptionsPooled,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
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
		]
	}
];



(* ::Subsubsection:: *)
(*ExperimentEvaporate Errors and Warnings*)


Error::SpeedVacTemperature = "In ExperimentEvaporate, the EvaporationTemperature specified for `1` falls outside the instrument's operable range.";
Error::TurboVapFlowRate = "In ExperimentEvaporate, the specified Flow rate in FlowRateProfile, `1,` specified for Sample `2` falls outside the instrument's operable range of 0-3.5 Liter/Minute for 2-15 mL tubes or 0-5.5 Liter/Minute for 50 mL tubes.";
Error::EvaporationFlowRateProfileTimeConflict = "In ExperimentEvaporate, the total duration in the provided FlowRateProfile, `1` for Sample `2` is different from the provided EvaporationTime, `3`. Please set the EvaporationTime equal to the total duration specified in the FlowRateProfile.";
Error::FlowRateProfileLength = "In ExperimentEvaporate, the number of FlowRateProfile parameters specified for `1` is greater than the instrument's number of programmable settings. A maximum of 3 FlowRateProfiles may be specified for Model[Instrument,Evaporator, id:kEJ9mqRxKA3p]. A maximum of 1 FlowRateProfile may be specified for Model[Instrument,Evaporator,id:R8e1PjRDb36j].";
Warning::HighFlowRate = "In ExperimentEvaporate, the FlowRate is high and may result in sample splashing and cross-contamination for the following samples: `1`. A lower flow rate is recommended.";
Warning::EvaporateTemperatureGreaterThanSampleBoilingPoint = "In ExperimentEvaporate, the specified EvaporationTemperature for `1` is greater than the sample's BoilingPoint, `2`, and may result in sample degradation. An EvaporationTemperature below the SolventBoilingPoint is recommended.";
Error::SampleVolumeUnknown = "In ExperimentEvaporate, the volume of samples, `1`, is unknown. These volumes must be populated for ExperimentEvaporate to proceed.";
Error::EvaporateEvapFlaskIncompatible = "In ExperimentEvaporate, the value specified for EvaporationFlask `1`, is too small to safely evaporate the sample, `2` or does not contain the correct connector. Please make sure that the EvaporationFlask contains a 24/40 connector and that the MaxVolume is at least 2x as much as the sample volume or leave this option as Automatic.";
Error::IncompatibleSpeedVac = "In ExperimentEvaporate, specified samples `1` can not be used with the specified Instrument `2`, please check your inputs.";
Error::DuplicatedSamples = "In `2`, the specified samples `1` are duplicated entries in the input. Please make sure each sample is used only once in each protocol.";
Error::CannotComputeEvaporationPressure = "For the following samples using RotaryEvaporation, EvaporationPressure was not set, and the samples' vapor pressures at `2` cannot be calculated because the VaporPressure/BoilingPoint field is not populated for a sufficient percentage of the Composition: `1`.  Please specify EvaporationPressure directly, or populate the VaporPressure/BoilingPoint field in the models in the samples' Composition field such that greater than 70 VolumePercent of the sample has known VaporPressure/BoilingPoint.";
Error::IncompatibleBumpTrapVolume = "In ExperimentEvaporate, the BumpTrapRinseVolume, `2`, for samples `1` is too large for the collection container or the available Model[Container, BumpTrap]. Please ensure that the BumpTrapRinseVolume is less than the MaxVolume of BumpTrapSampleContainer and the available Model[Container, BumpTrap].";


(* ::Subsubsection:: *)
(*ExperimentEvaporate*)


ExperimentEvaporate[myInput:ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentEvaporate]] := ExperimentEvaporate[ToList[myInput], myOptions];
ExperimentEvaporate[myInputs:ListableP[{ObjectP[Object[Sample]]..}], myOptions:OptionsPattern[ExperimentEvaporate]] := Module[
	{
		listedSamples, listedOptions, listedOps, cacheOption, output, outputSpecification, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation,
		safeOps, safeOpsTests, validLengths, validLengthTests, containersFromOptions, samplesFromOptions,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, uploadOption, confirmOption, canaryBranchOption, parentProtocolOption,
		rawEmailOption, emailOption, allDownloads, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		cacheBall, resourcePacket, resourcePacketTests, allTests, protocolObject, availableVacEvapMethods, possibleInstruments,
		possibleRotovapFlasks, allRotovapFlasks, allCentrifugableContainers, sampleInfo, modelInfo, containerInfo, containerModelInfo,
		allTurbovapRacks, preferredVessels, modelContainerPacket, pooledSamples
	},

	(* Check that all options are singletons or match the length of their index-matched associate *)
	listedOps = ToList[myOptions];
	cacheOption = ToList[Lookup[listedOps, Cache, {}]];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentEvaporate,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentEvaporate, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentEvaporate, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOpsNamed, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* delete the PreparedResouces because of Cam's thing*)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentEvaporate, {mySamplesWithPreparedSamples}, safeOps, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentEvaporate, {mySamplesWithPreparedSamples}, safeOps], Null}
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
		ApplyTemplateOptions[ExperimentEvaporate, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentEvaporate, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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

	(* Expand index-matching options *)
	{{pooledSamples}, expandedSafeOps} = ExpandIndexMatchedInputs[ExperimentEvaporate, {mySamplesWithPreparedSamples}, inheritedOptions];

	(* Lookup some standard options from the safe options*)
	{uploadOption, confirmOption, canaryBranchOption, parentProtocolOption, rawEmailOption} = Lookup[
		inheritedOptions,
		{Upload, Confirm, CanaryBranch, ParentProtocol, Email}
	];

	(* adjust the email option based on the upload optoin *)
	emailOption = If[!MatchQ[emailOption, Automatic], rawEmailOption,
		If[And[uploadOption, MemberQ[output, Result]], True, False]
	];

	availableVacEvapMethods = Search[Object[Method, VacuumEvaporation], DeveloperObject != True];

	(* TODO: change this to a Search *)
	possibleInstruments = DeleteDuplicates@Join[
		ToList[Lookup[safeOps, Instrument]] /. Automatic -> Nothing,
		{
			Model[Instrument, VacuumCentrifuge, "id:n0k9mGzRal4w"],
			Model[Instrument, VacuumCentrifuge, "id:dORYzZJ9d64w"],
			Model[Instrument, RotaryEvaporator, "id:jLq9jXvmeYxR"],
			Model[Instrument, Evaporator, "id:R8e1PjRDb36j"],
			Model[Instrument, Balance, "id:o1k9jAGvbWMA"],
			Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"]
		}
	];

	(* get all the containers we need in a memoized search *)
	{
		allRotovapFlasks,
		allCentrifugableContainers,
		allTurbovapRacks
	} = nonDeprecatedEvaporationContainers["Memoization"];

	(* combine what we searched for with what was specified *)
	possibleRotovapFlasks = DeleteDuplicates[Flatten[{
		ToList[Lookup[safeOps, EvaporationFlask]] /. Automatic -> Nothing,
		allRotovapFlasks
		(* Model[Container,Vessel,"id:dORYzZn0ooED"],(*500mL Pear Shaped Flask with 24/40 Joint*)
			Model[Container,Vessel,"id:E8zoYveRllDm"],(*1L Pear Shaped Flask with 24/40 Joint*)
			Model[Container,Vessel,"id:jLq9jXY4kkdZ"],(*2L Pear Shaped Flask with 24/40 Joint*)
			Model[Container,Vessel,"id:54n6evKx00aG"](*3L Round Bottom Flask with 24/40 Joint*)*)
	}]];

	(* Get all of our preferred vessels. *)
	preferredVessels = DeleteDuplicates[Flatten[{
		PreferredContainer[All, Type -> Vessel],
		PreferredContainer[All, Sterile -> True, LightSensitive -> True, Type -> Vessel],
		PreferredContainer[All, Sterile -> False, LightSensitive -> True, Type -> Vessel],
		PreferredContainer[All, Sterile -> True, LightSensitive -> False, Type -> Vessel],
		Model[Container, Plate, "96-well 2mL Deep Well Plate"]
	}]];

	(* Get container objects/models from options *)
	containersFromOptions = Cases[Flatten[Lookup[safeOps,
		{
			EvaporationFlask,
			BumpTrapSampleContainer,
			CondensateSampleContainer,
			IncubateAliquotContainer,
			CentrifugeAliquotContainer,
			FilterContainerOut,
			FilterAliquotContainer,
			AliquotContainer
		}
	]], ObjectP[]];

	(* Get sample objects/models from options *)
	samplesFromOptions = Cases[Flatten[Lookup[safeOps,
		{
			BumpTrapRinseSolution,
			BalancingSolution,
			ConcentratedBuffer,
			BufferDiluent,
			AssayBuffer
		}
	]], ObjectP[]];

	(*Assign variables to the items for download to include sample prep fields*)

	(* Sample Information *)
	sampleInfo = Packet @@ Union[
		(*For sample prep*)
		SamplePreparationCacheFields[Object[Sample]],
		(* For ExperimentEvaporate *)
		{Notebook},
		(* For Caching *)
		{BoilingPoint}
	];

	(* Sample Model information *)
	modelInfo = Union[
		(*For sample prep*)
		SamplePreparationCacheFields[Model[Sample]],
		(* For ExperimentEvaporate *)
		{Notebook},
		(* For Caching *)
		{BoilingPoint, AluminumFoil, Parafilm}
	];

	(* Sample's Container packet information *)
	containerInfo = Union[Join[
		(*For sample prep*)
		SamplePreparationCacheFields[Object[Container]],
		(* additional fields *)
		{ModelName}
	]];

	(* Container Model Packet *)
	containerModelInfo = Union[
		(*For sample prep*)
		SamplePreparationCacheFields[Model[Container]],
		(* ExperimentEvaporate required *)
		{Connectors, AspirationDepth, VacuumCentrifugeCompatibility, MaxVolume},
		(* Cache required *)
		{CentrifugeCompatibility, VacuumCentrifugeCompatibility}
	];
	modelContainerPacket = Packet @@ containerModelInfo;

	(* Download all the needed things *)
	allDownloads = Flatten@Quiet[
		Download[
			{
				(* 1 *)Flatten[{pooledSamples, samplesFromOptions}],
				(* 2 *)availableVacEvapMethods,
				(* 3 *)possibleInstruments,
				(* 4 *)possibleRotovapFlasks,
				(* 5 *)allCentrifugableContainers,
				(* 6 *)allTurbovapRacks,
				(* 7 *)preferredVessels,
				(* 8 *)containersFromOptions
			},
			{
				{(* 1 *)
					sampleInfo,
					Packet[Model[modelInfo]],
					(* Model Composition *)
					Packet[Model[{BoilingPoint, State, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, SolidUnitWeight, Products, Dimensions, TransportTemperature}]],
					(* Object Compositions *)
					Packet[Composition[[All, 2]][{BoilingPoint, VaporPressure, State, MolecularWeight}]],
					Packet[Container[containerInfo]],
					Packet[Container[Model][containerModelInfo]]
				},
				{(* 2 *)
					Packet[
						Name, CentrifugalForce, PressureRampTime, EvaporationTime, EquilibrationPressure,
						EvaporationPressure, ControlledChamberEvacuation
					]
				},
				{(* 3 *)
					Packet[
						Name, MinTemperature, MaxTemperature, VacuumPressure, MaxSpinRate, BathFluid, MinFlowRate, MaxFlowRate, BathVolume,
						MinBathTemperature, MaxBathTemperature, MaxRotationRate, Model
					]
				},
				{(* 4 *)
					Evaluate[Packet @@ containerInfo],
					modelContainerPacket
				},
				{(* 5 *)
					modelContainerPacket,
					Packet[Field[VacuumCentrifugeCompatibility[[All, Instrument]][{MaxTime, MaxTemperature, MinTemperature, SpeedResolution, MaxRotationRate, MinRotationRate, CentrifugeType, AsepticHandling}]]],
					Packet[Field[VacuumCentrifugeCompatibility[[All, Rotor]][{MaxRotationRate, Positions, AvailableLayouts, MaxImbalance, Name, MaxRadius, MaxForce, Footprint, RotorType, DefaultStorageCondition, RotorAngle}]]],
					Packet[Field[VacuumCentrifugeCompatibility[[All, Bucket]][{Positions, AvailableLayouts, Name, MaxRadius, MaxForce, MaxRotationRate, Footprint, MaxStackHeight, DefaultStorageCondition}]]],
					Packet[Field[VacuumCentrifugeCompatibility[[All, Rack]][containerModelInfo]]]
				},
				{(* 6 *)
					modelContainerPacket
				},
				(*preferredVessels*)
				{(* 7 *)
					modelContainerPacket
				},
				{(* 8 *)
					modelContainerPacket,
					Evaluate[Packet @@ containerInfo],
					Packet[Model[containerModelInfo]]
				}
			},
			Cache -> cacheOption,
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::Part}
	];

	(* Add the new packets to the cache *)
	cacheBall = FlattenCachePackets[Flatten[{cacheOption, allDownloads}]];

	(* resolve the options*)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentEvaporateOptions[pooledSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentEvaporateOptions[pooledSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentEvaporate,
		resolvedOptions,
		Ignore -> ToList[myOptions],
		Messages -> False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentEvaporate, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* Build packets with resources *)
	(* Note that evaporateResourcePackets[...] will also return an EmeraldCloudFile objects/packets, so we have to do an extra filter here *)
	{resourcePacket, resourcePacketTests} = If[gatherTests,
		evaporateResourcePackets[Download[pooledSamples, Object], listedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{evaporateResourcePackets[Download[pooledSamples, Object], listedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentEvaporate, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* combine all the tests *)
	allTests = DeleteCases[Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}], Null];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePacket, $Failed],
		UploadProtocol[
			(* Note that evaporateResourcePackets[...] will also return EmeraldCloudFile objects/packets, so we have to do an extra screening here *)
			First[resourcePacket],
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],

			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],

			ConstellationMessage -> Object[Protocol, Evaporate],
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* return the result, depending on the output option *)
	outputSpecification /. {
		Tests -> allTests,
		Options -> RemoveHiddenOptions[ExperimentEvaporate, resolvedOptions],
		Result -> If[TrueQ[Lookup[safeOps, Upload]],
			(* If we are uploading, only return the protocol object *)
			protocolObject,
			(* Otherwise, return all upload packets *)
			Join[protocolObject, Rest[resourcePacket]]
		],
		Preview -> Null
	}
];

ExperimentEvaporate[myContainers:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample], Object[Container], Model[Sample]}], _String]]], myOptions:OptionsPattern[ExperimentEvaporate]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation, sampleCache,
		containerToSampleResult, containerToSampleOutput, samples, sampleOptions, containerToSampleTests, containerToSampleSimulation},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentEvaporate,
			ToList[myContainers],
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = pooledContainerToSampleOptions[
			ExperimentEvaporate,
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
			{containerToSampleOutput, containerToSampleSimulation} = pooledContainerToSampleOptions[
				ExperimentEvaporate,
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
		(* pooledContainerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentEvaporate[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsubsection::Closed:: *)
(*nonDeprecatedEvaporationContainers*)

(* Function to search the database for all non-deprecated evaporation containers.
 	Memoizes the result after first execution to avoid repeated database trips within a single kernel session. *)
nonDeprecatedEvaporationContainers[fakeString:_String] := nonDeprecatedEvaporationContainers[fakeString] = Module[{},
	(*Add allCentrifugeEquipmentSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`nonDeprecatedEvaporationContainers];

	Search[
		{
			(*TODO this seems woefully inefficient; see if you can make this better *)
			(* search for all possible rotovap flasks and bump traps, which need to have the Connectors Field informed*)
			{Model[Container, Vessel], Model[Container, BumpTrap]},
			{Model[Container, Plate], Model[Container, Vessel]},
			{Model[Container, Rack]}
		},
		{
			Connectors != Null && DeveloperObject != True,
			VacuumCentrifugeCompatibility != Null && Deprecated != True && DeveloperObject != True,
			Footprint == TurboVapRack && Deprecated != True && DeveloperObject != True
		}
	]
];

evaporateReplacementCounterweighContainers = {
	Model[Container, Plate, "id:E8zoYveRll17"] -> Model[Container, Plate, "id:L8kPEjkmLbvW"] (*DWP that is deprecated*)
};


(* ::Subsubsection:: *)
(*resolveExperimentEvaporateOptions *)


DefineOptions[
	resolveExperimentEvaporateOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentEvaporateOptions[mySamples:ListableP[{ObjectP[Object[Sample]]...}], myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentEvaporateOptions]] := Module[
	{outputSpecification, output, gatherTests, cache, samplePrepOptions, evaporationOptions, simulatedSamples, resolvedSamplePrepOptions,
		simulatedCache, fastAssocSimulatedCache, flatSimulatedSamples, samplePrepTests, samplePackets, sampleComponentPackets, sampleContainerModelPackets,
		sampleContainerPackets, methodPackets, rotorPackets, maxImbalance, discardedSamplePackets, allRotovapFlasks, allCentrifugableContainers,
		discardedInvalidInputs, discardedTest, noVolumeSamplePackets, noVolumeInvalidInputs, noVolumeTest, duplicatedInvalidInputs,
		duplicatesTest, roundedEvaporationOptions, optionPrecisionTests, allowedVacuumEvaporationTimeSettings, updatedSimulation,
		pooledSamplePackets, pooledSampleComponentPackets, pooledSampleContainerModelPackets, pooledSampleContainerPackets,
		poolVolumes, pooledContainerModel, pooledContainerModelCleaned,
		poolContainerPackets,

		emailOption, uploadOption, resolvedEmail, resolvedPostProcessingOptions, nameOption, nameValidBool, nameOptionInvalid,
		nameUniquenessTest, samplesInStorage, samplesOutStorage, quasiExpandedSamplesInStorage,
		optionsAssociation,

		speedVacExclusiveOptions,
		rotoVapExclusiveOptions,
		nitrogenBlowerExclusiveOptions,
		getModelPacket,

		mapThreadFriendlyOptions,

		resolvedTypes,
		resolvedEvapInstruments,
		resolvedEvapTemps,
		resolvedEquilibrationTimes,
		resolvedRampTimes,
		resolvedEvapTimes,
		resolvedEvapPressures,
		resolvedBoilingPoints,
		resolvedRotationRates,
		resolvedVacEvapMethods,
		resolvedBumps,
		resolvedBalancingSolutions,
		resolvedEvapFlasks,
		resolvedCondenserTemps,
		resolvedRecoupTraps,
		resolvedRecoupTrapSolutions,
		resolvedRecoupTrapVolumes,
		resolvedRecoupTrapContainers,
		resolvedRecoupCondensates,
		resolvedCondensateSampleContainers,
		resolvedFlowRateProfiles,
		resolvedEvapUntilDrys,
		resolvedMaxEvapTimes,

		(* Resolved Error Bools *)
		allTypeOptionConflicts,
		insufficientVolumeErrors,
		sampleVolumeTooLargeErrors,
		primaryEvaporationContainerConflictErrors, primaryEvaporationContainerConflictTests, primaryEvaporationContainerConflictOptions,
		nitrogenAmbiguousWarnings,
		rotovapAmbiguousWarnings,
		speedVacAmbiguousWarnings,
		rinseSolutionVolumeErrors,
		bumpTrapRinseSolutionVolumeErrors,
		bumpTrapRinseSolutionConflictOptions,
		bumpTrapRinseSolutionVolumeTests,
		bumpMethodConflictWarnings,
		impossibleEvapTempErrors,
		impossibleEvapTempErrorsTests,
		impossibleEvapTempOptions,
		flowRateProfileWarnings,
		flowRateProfileWarningTests,
		flowRateProfileWarningOptions,
		flowRateEvapTimeConflictWarnings,
		flowRateEvapTimeConflictTests,
		flowRateEvapTimeConflictOptions,
		highFlowRateWarnings,
		highFlowRateWarningTests,
		highFlowRateWarningOptions,
		impossibleFlowRates,
		impossibleFlowRatesTests,
		impossibleFlowRatesTestsOptions, evaporationPressureRequiredOptions, evaporationPressureRequiredTests,
		incompatibleContainers, noVaporPressureErrors,
		evapTempTooHighWarnings,
		evapTempTooHighTests,
		evapTempTooHighOptions,

		resolvedEvapContainers,
		allTurbovapRacks, turboInst, containerPacks, rotoPearContainerPackets, rotoRoundContainerPackets,
		allBumpTrapPacks, rotoBumpTrapPackets, turboVapRackPackets, simulation, rotoVapContainerPackets,
		(*Related to Aliquot options*)
		targetContainers, targetVolumes, aliquotOptions, resolveSamplePrepOptionsWithoutAliquot,
		resolvedAliquotOptions, aliquotTests, aliquotOpts, aliquotWarningMsg, validSampleStorageConditionQ,
		invalidStorageConditionOptions, invalidStorageConditionTest,
		invalidInputs, invalidOptions, allTests, mapThreadFriendlyPrepOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our Evaporation options from our Sample Prep options. *)
	{samplePrepOptions, evaporationOptions} = splitPrepOptions[myOptions];

	(* Resolve the sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentEvaporate, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentEvaporate, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* generate a fast cache association *)
	simulatedCache = FlattenCachePackets[{cache, Lookup[First[updatedSimulation], Packets]}];
	fastAssocSimulatedCache = makeFastAssocFromCache[simulatedCache];

	(* these were memoized before so inexpensive to get again*)
	{
		allRotovapFlasks,
		allCentrifugableContainers,
		allTurbovapRacks
	} = nonDeprecatedEvaporationContainers["Memoization"];

	(* pull out the turbovap packets from the fastAssoc which we Downloaded from in the main function *)
	turboVapRackPackets = fetchPacketFromFastAssoc[#, fastAssocSimulatedCache]& /@ allTurbovapRacks;

	(* pull out the sample packets (and related things) from the fast assoc*)
	flatSimulatedSamples = Flatten[simulatedSamples];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssocSimulatedCache]& /@ flatSimulatedSamples;
	sampleComponentPackets = Map[
		Function[{sample},
			With[{identityModels = fastAssocLookup[fastAssocSimulatedCache, sample, Composition][[All, 2]]},
				fetchPacketFromFastAssoc[#, fastAssocSimulatedCache]& /@ identityModels
			]
		],
		flatSimulatedSamples
	];
	sampleContainerModelPackets = fastAssocPacketLookup[fastAssocSimulatedCache, #, {Container, Model}]& /@ flatSimulatedSamples;
	sampleContainerPackets = fastAssocPacketLookup[fastAssocSimulatedCache, #, Container]& /@ flatSimulatedSamples;

	(* Re-list the samplePackets in the form of the original listed, pooled sample input *)
	pooledSamplePackets = TakeList[samplePackets, Length[ToList[#]]& /@ simulatedSamples];

	(* Re-list the sampleComponentPackets in the form of the original listed, pooled sample input *)
	pooledSampleComponentPackets = TakeList[sampleComponentPackets, Length[ToList[#]]& /@ simulatedSamples];

	(* Re-list the sampleContainerModelPacksts in the form of the original listed, pooled sample input *)
	pooledSampleContainerModelPackets = TakeList[sampleContainerModelPackets, Length[ToList[#]]& /@ simulatedSamples];

	(* Re-list the sampleContainerModelPacksts in the form of the original listed, pooled sample input *)
	pooledSampleContainerPackets = TakeList[sampleContainerPackets, Length[ToList[#]]& /@ simulatedSamples];

	aliquotOpts = Lookup[samplePrepOptions, Aliquot];

	(* In addition to each specific sample's volumes, look up the assay volume of each sample pool *)
	poolVolumes = MapThread[
		Function[{aliquotting, assayVol, sampList},
			If[MatchQ[aliquotting, True],
				If[MatchQ[assayVol, Except[Automatic]],
					(*If an aliquot volume is specified, use that*)
					assayVol,

					(*If no aliquot volume is specified, use the SampleVolume. We need this to resolve some options *)
					Total[ToList[Lookup[#, Volume]]& /@ sampList]
				],
				(*If we're not aliquoting, just use the Sample Volume*)
				Total[ToList[Lookup[#, Volume]]& /@ sampList]
			]
		],
		{
			aliquotOpts,
			Lookup[samplePrepOptions, AssayVolume],
			pooledSamplePackets
		}
	];

	(*In the case that the samples are pooled, look up what container they are going in.
		Replace any nulls with {Null,Null}*)
	pooledContainerModel = Lookup[resolvedSamplePrepOptions, AliquotContainer, Null] /. Null -> {Null, Null};

	(* Get the container models only *)
	pooledContainerModelCleaned = If[NullQ[pooledContainerModel],
		(*If poolecContainerModel is all null, then we are not pooling*)
		Table[Null, Length[ToList[simulatedSamples]]],

		pooledContainerModel[[All, 2]]
	];

	(*Download the object and max volume of the pooled container*)
	poolContainerPackets = Download[pooledContainerModelCleaned,
		Packet[Object, MaxVolume],
		Simulation->updatedSimulation
	];

	(* Relist the packets in the form of the original, listed samples *)

	(* Don't do the search again to find the method packets; just pull them from the cache *)
	methodPackets = Cases[cache, PacketP[Object[Method, VacuumEvaporation]]];

	(* Pull out the rotor packet and figure out the max imbalance from the cache *)
	rotorPackets = Cases[cache, ObjectP[Model[Container, CentrifugeRotor]]];

	maxImbalance = Min[DeleteCases[Lookup[rotorPackets, MaxImbalance], Null]];

	(*-- INPUT VALIDATION CHECKS --*)

	(* - Check if samples are discarded - *)

	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[discardedInvalidInputs] > 0 && !gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs, Cache -> simulatedCache]<>" are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples, discardedInvalidInputs], Cache -> simulatedCache]<>" are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* - Check if samples have volume - *)

	(* Get the samples from simulatedSamples that do not have volume populated. *)
	noVolumeSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Volume -> Null]];
	noVolumeInvalidInputs = Lookup[noVolumeSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[noVolumeInvalidInputs] > 0 && !gatherTests,
		Message[Error::SampleVolumeUnknown, ObjectToString[noVolumeInvalidInputs, Cache -> simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[noVolumeInvalidInputs] == 0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs, Cache -> simulatedCache]<>" have volume populated:", True, False]
			];

			passingTest = If[Length[noVolumeInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples, noVolumeInvalidInputs], Cache -> simulatedCache]<>" have volume populated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* - Check if samples are duplicated (Evaporation does not handle replicates since the solvent is evaporated over the course of the experiment.) - *)

	(* Get the samples from simulatedSamples that are duplicated. *)
	(* note that if we're aliquoting, then all bets are off because we don't actually simulate aliquoting if we're pooled so duplicate samples could be ok *)
	(* could go back into resolveSamplePrepOptions for changing that logic if we want, but for now we don't *)
	duplicatedInvalidInputs = If[MemberQ[Lookup[resolvedSamplePrepOptions, Aliquot], True],
		{},
		Cases[Tally[simulatedSamples], {_, Except[1]}][[All, 1]]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[duplicatedInvalidInputs] > 0 && !gatherTests,
		Message[Error::DuplicatedSamples, ObjectToString[duplicatedInvalidInputs, Cache -> simulatedCache], "ExperimentEvaporate"]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicatesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicatedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples "<>ObjectToString[duplicatedInvalidInputs, Cache -> simulatedCache]<>" are not listed more than once:", True, False]
			];

			passingTest = If[Length[duplicatedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples, duplicatedInvalidInputs], Cache -> simulatedCache]<>" are not listed more than once:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* Ensure that all the numerical options have the proper precision *)

	(* Convert list of rules to Association *)
	optionsAssociation = Association[evaporationOptions];

	{roundedEvaporationOptions, optionPrecisionTests} = Module[
		{flowProfs, frpFlowPositions, frpTimePositions, frpFlowAssociation, frpTimeAssociation,
			frpFlowRoundedAssociation, frpFlowRoundedTests, frpTimeRoundedAssociation,
			frpTimeRoundedTests, roundedFlowRateProfileOptions, singletonRoundedAssociations,
			singletonRoundedTests, allRoundedOptionsAssociation, allRoundingTests},

		(*Treat FlowRateProfile differently since it is a nested list*)
		flowProfs = {FlowRateProfile};

		(*Find all the positions in the FlowRateProfiles where a flow rate exists*)
		(*frpFlowPositions = Position[FlowRateProfile,_Quantity?FlowRateQ,Infinity,Heads->False];*)
		frpFlowPositions = Map[
			Position[ToList[#], _Quantity?FlowRateQ, Infinity, Heads -> False]&,
			Lookup[optionsAssociation, flowProfs]
		];

		(*Find all the positions in the FlowRateProfiles where a time exists*)
		frpTimePositions = Map[
			Position[ToList[#], _Quantity?TimeQ, Infinity, Heads -> False]&,
			Lookup[optionsAssociation, flowProfs]
		];

		(* Build an association with flattened flow rates: instead of {{1L/Minute, 60 min},{3L/Minute, 45 Minute}} it will be {1L/Minute,3L/Minute} with frpFlowPositions = {{1,1},{2,1}}*)
		frpFlowAssociation = Association@MapThread[
			Function[{optionName, indices},
				(optionName -> (Extract[ToList[Lookup[optionsAssociation, optionName]], #]& /@ indices))
			],
			{flowProfs, frpFlowPositions}
		];

		(* Build an association with flattened times *)
		frpTimeAssociation = Association@MapThread[
			Function[{optionName, indices},
				(optionName -> (Extract[ToList[Lookup[optionsAssociation, optionName]], #]& /@ indices))
			],
			{flowProfs, frpTimePositions}
		];

		(* Get rounded flow rate values *)
		{frpFlowRoundedAssociation, frpFlowRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				frpFlowAssociation,
				flowProfs,
				Table[10^-1 Liter / Minute, Length[flowProfs]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					frpFlowAssociation,
					flowProfs,
					Table[10^-1 Liter / Minute, Length[flowProfs]]
				],
				{}
			}
		];

		(* Get rounded times *)
		{frpTimeRoundedAssociation, frpTimeRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				frpTimeAssociation,
				flowProfs,
				Table[10^0 Minute, Length[flowProfs]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					frpTimeAssociation,
					flowProfs,
					Table[10^0 Minute, Length[flowProfs]]
				],
				{}
			}
		];

		(* Rebuid the Flow Rate profile association by replacing the orginal values with the rounded values *)
		roundedFlowRateProfileOptions = Association@MapThread[
			Function[{optionName, flowRatePositions, timePositions},
				optionName -> If[MatchQ[Lookup[optionsAssociation, optionName], _List],
					ReplacePart[
						Lookup[optionsAssociation, optionName],
						Join[
							MapThread[
								Rule,
								{flowRatePositions, Lookup[frpFlowRoundedAssociation, optionName]}
							],
							MapThread[
								Rule,
								{timePositions, Lookup[frpTimeRoundedAssociation, optionName]}
							]
						]
					],
					ReplacePart[
						ToList[Lookup[optionsAssociation, optionName]],
						Join[
							MapThread[
								Rule,
								{flowRatePositions, Lookup[frpFlowRoundedAssociation, optionName]}
							],
							MapThread[
								Rule,
								{timePositions, Lookup[frpTimeRoundedAssociation, optionName]}
							]
						]
					][[1]]
				]
			],
			{flowProfs, frpFlowPositions, frpTimePositions}
		];

		(*The rest of the options are singletons*)
		{singletonRoundedAssociations, singletonRoundedTests} = If[gatherTests,
			RoundOptionPrecision[
				optionsAssociation,
				{
					RotationRate,
					EvaporationPressure,
					PressureRampTime,
					EvaporationTemperature,
					CondenserTemperature,
					EquilibrationTime,
					EvaporationTime
				},
				{
					10^0 * RPM,
					5 * 10^-1 * Milli * Bar,
					10^-1 * Second,
					10^0 * Celsius,
					10^0 * Celsius,
					10^-1 * Second,
					10^-1 * Second
				},
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					optionsAssociation,
					{
						RotationRate,
						EvaporationPressure,
						PressureRampTime,
						EvaporationTemperature,
						CondenserTemperature,
						EquilibrationTime,
						EvaporationTime
					},
					{
						10^0 * RPM,
						5 * 10^-1 * Milli * Bar,
						10^-1 * Second,
						10^0 * Celsius,
						10^0 * Celsius,
						10^-1 * Second,
						10^-1 * Second
					},
					Output -> Result
				],
				{}
			}
		];

		(* Join all rounded associations together *)
		allRoundedOptionsAssociation = Join[
			optionsAssociation,
			singletonRoundedAssociations,
			roundedFlowRateProfileOptions

		];

		allRoundingTests = Join[
			frpFlowRoundedTests,
			singletonRoundedTests,
			frpTimeRoundedTests
		];

		(* Return the expected tuple of the rounded association and all tests*)
		{allRoundedOptionsAssociation, allRoundingTests}
	];

	(* - Check that time is available on the instrument - *)

	(* These are the times that are allowed. Stash them so we may look them up below in the MapThread *)
	allowedVacuumEvaporationTimeSettings = Join[
		Range[1 Minute, 15 Minute, 1 Minute],
		Range[20 Minute, 2 Hour, 5 Minute],
		Range[135 Minute, 4 Hour, 15 Minute],
		Range[4.5 Hour, 48 Hour, 0.5 Hour]
	];

	(* Stash the list of options that are VacuumCentrifuge Specific *)
	speedVacExclusiveOptions = {
		VacuumEvaporationMethod,
		BumpProtection,
		BalancingSolution
	};

	(* Stash the list of options that are RotaryEvaporation Specific *)
	rotoVapExclusiveOptions = {
		EvaporationFlask,
		CondenserTemperature,
		RecoupBumpTrap,
		BumpTrapRinseSolution,
		BumpTrapRinseVolume,
		BumpTrapSampleContainer,
		RecoupCondensate,
		CondensateSampleContainer
	};

	(* Stash the list of options that are NitrogenBlower Specific *)
	nitrogenBlowerExclusiveOptions = {
		FlowRateProfile
	};

	(* Pull out the Racks associated with the TurboVap instruments from the packet *)
	turboInst = Cases[cache, ObjectP[Model[Instrument, Evaporator, "TurboVap LV Evaporator"]]];

	containerPacks = Cases[cache, ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]];

	(* Pull out all possiblecrotovap container packets. We only want connectors with a 24/40 Thread*)
	rotoVapContainerPackets = Cases[containerPacks, KeyValuePattern[Connectors -> ListableP[{_, _, "24/40", _, _, _}]]];

	(* Separate the rotovap packets into pear shaped flasks and the round bottom flasks *)
	rotoPearContainerPackets = Join[
		(* We are doing two Cases, one for container objects and another for container models. Then joining them together in a list *)
		Cases[rotoVapContainerPackets, KeyValuePattern[ModelName -> _?(StringMatchQ[ToString[#], ___~~"Pear"~~___] &)]],
		Cases[rotoVapContainerPackets, KeyValuePattern[Name -> _?(StringMatchQ[ToString[#], ___~~"Pear"~~___] &)]]
		];

	rotoRoundContainerPackets = Sort[
	Join[
		(* We are doing two Cases, one for container objects and another for container models. Then joining them together in a list *)
		Cases[rotoVapContainerPackets, KeyValuePattern[ModelName -> _?(StringMatchQ[ToString[#], ___~~"Round"~~___] &)]],
		Cases[rotoVapContainerPackets, KeyValuePattern[Name -> _?(StringMatchQ[ToString[#], ___~~"Round"~~___] &)]]
	]
	];

	(* Pull out all possible rotovap bump trap packets*)
	allBumpTrapPacks = Cases[cache, ObjectP[Model[Container, BumpTrap]]];
	rotoBumpTrapPackets = Cases[allBumpTrapPacks, KeyValuePattern[Connectors -> ListableP[{_, _, "24/40", _, _, _}]]];
	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* MapThread-ify my options such that we can investigate each option value corresponding to the sample we're resolving around *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentEvaporate, roundedEvaporationOptions];
	mapThreadFriendlyPrepOptions= OptionsHandling`Private`mapThreadOptions[ExperimentEvaporate,resolvedSamplePrepOptions];

	(* Helper: getModelPacket takes an input object or model and fetches the model packet from cache *)
	getModelPacket[objectInput_]:=Module[{modelFromObject},
		(* Depending on whether we get the object or its model, we will have to do this in 2 or 1 step(s), repsectively *)
		If[MatchQ[objectInput, ObjectP[Object[]]],
			(* TRUE *)
			(* When our input is an object, we need to first get the model from its packet *)
			modelFromObject = Download[Lookup[fetchPacketFromFastAssoc[objectInput, fastAssocSimulatedCache], Model], Object];
			(* Now we can find the model's packet *)
			fetchPacketFromFastAssoc[modelFromObject, fastAssocSimulatedCache],
			(* FALSE *)
			(* Since we already got a model, we can get its packet *)
			fetchPacketFromFastAssoc[objectInput, fastAssocSimulatedCache]
		]
	];

	(* -------- MAP THREAD -------- *)
	{
		(*1*)resolvedTypes,
		(*2*)resolvedEvapInstruments,
		(*3*)resolvedEvapTemps,
		(*4*)resolvedEquilibrationTimes,
		(*5*)resolvedRampTimes,
		(*6*)resolvedEvapTimes,
		(*7*)resolvedEvapPressures,
		(*8*)resolvedBoilingPoints,
		(*9*)resolvedRotationRates,
		(*10*)resolvedVacEvapMethods,
		(*11*)resolvedBumps,
		(*12*)resolvedBalancingSolutions,
		(*13*)resolvedEvapFlasks,
		(*14*)resolvedCondenserTemps,
		(*17*)resolvedRecoupTraps,
		(*18*)resolvedRecoupTrapSolutions,
		(*19*)resolvedRecoupTrapVolumes,
		(*20*)resolvedRecoupTrapContainers,
		(*23a*)resolvedRecoupCondensates,
		(*24a*)resolvedCondensateSampleContainers,
		(*23b*)resolvedFlowRateProfiles,
		(*24b*)resolvedEvapUntilDrys,
		(*25*)resolvedMaxEvapTimes,
		(*26*)resolvedEvapContainers,
		(* Resolved Error Bools *)
		(*28*)allTypeOptionConflicts,
		(*29*)insufficientVolumeErrors,
		(*30*)sampleVolumeTooLargeErrors,
		(*31*)primaryEvaporationContainerConflictErrors,
		(*32*)nitrogenAmbiguousWarnings,
		(*33*)rotovapAmbiguousWarnings,
		(*34*)speedVacAmbiguousWarnings,
		(*35*)rinseSolutionVolumeErrors,
		(*36*)bumpTrapRinseSolutionVolumeErrors,
		(*37*)bumpMethodConflictWarnings,
		(*38*)impossibleEvapTempErrors,
		(*39*)flowRateProfileWarnings,
		(*40*)flowRateEvapTimeConflictWarnings,
		(*41*)highFlowRateWarnings,
		(*42*)impossibleFlowRates,
		(*43*)evapTempTooHighWarnings,
		(*44*)incompatibleContainers,
		(*45*)noVaporPressureErrors
	} = Transpose@MapThread[
		Function[{myMapThreadOptions, mySamplePool, myPoolVolume, mySampleComponents, myContainerModel, myPoolContainer, mySamplePrepOptions},
			Module[
				{
					evapType,
					evapInstrument,
					vacEvapMethod,
					solventBP,
					evapTemp,
					equilibrationTime,
					rampTime,
					evapTime,
					evapPressure,
					rotationRate,
					evapUntilDry,
					maxEvapTime,

					speedVacOptionVals,
					bump,
					balancingSolution,

					rotovapOptionVals,
					evapFlask,
					condenserTemp,
					recoupTrap,
					recoupTrapSolution,
					recoupTrapVolume,
					recoupTrapContainer,
					recoupCondensate,
					condensateSampleContainer,

					nitrogenOptionVals,
					flowRateProfile,

					mySampVol,

					resolvedType,
					resolvedVacEvapMethod,
					resolvedEvapInstrument,
					resolvedEvapTemp,
					resolvedEquilibrationTime,
					resolvedRampTime,
					resolvedEvapTime,
					resolvedEvapPressure,
					resolvedRotationRate,
					resolvedEvapUntilDry,
					resolvedMaxEvapTime,
					resolvedEvapContainer,
					resolvedEvapFlask,
					resolvedCondenserTemp,
					resolvedRecoupTrap,
					resolvedRecoupTrapSolution,
					resolvedRecoupTrapVolume,
					resolvedRecoupTrapContainer,
					resolvedRecoupCondensate,
					resolvedCondensateSampleContainer,
					resolvedBump,
					resolvedBalancingSolution,
					resolvedFlowRateProfile,

					rootComponentPackets,
					solventType,
					specifiedBoilingPoints,
					knownBoilingPoints, pooledVolumePercentages, combinedComposition,
					noVaporPressureError,
					resolvedBoilingPoint,
					resBoilingPointToTemp,

					insufficientVolumeError,
					sampleVolumeTooLargeError,
					primaryEvaporationContainerConflictError,
					nitrogenAmbiguousWarning,
					rotovapAmbiguousWarning,
					speedVacAmbiguousWarning,
					rinseSolutionVolumeError,
					bumpTrapRinseSolutionVolumeError,
					bumpMethodConflictWarning,
					impossibleEvapTempError,
					flowRateProfileWarning,
					flowRateEvapTimeConflictWarning,
					highFlowRateWarning,
					impossibleFlowRate,
					evapTempTooHigh,
					containerModelObj,
					sampleInTurboCompatibleContainer,
					incompatibleContainer,
					typeOptionConflicts
				},

				(* Setup our error tracking variables *)
				{
					insufficientVolumeError,
					sampleVolumeTooLargeError,
					primaryEvaporationContainerConflictError,
					nitrogenAmbiguousWarning,
					rotovapAmbiguousWarning,
					speedVacAmbiguousWarning,
					rinseSolutionVolumeError,
					bumpTrapRinseSolutionVolumeError,
					bumpMethodConflictWarning,
					flowRateProfileWarning,
					flowRateEvapTimeConflictWarning,
					highFlowRateWarning,
					impossibleFlowRate,
					evapTempTooHigh,
					incompatibleContainer
				} = ConstantArray[False, 15];

				(* Store our general options in their variables *)
				{
					evapType,
					evapInstrument,
					solventBP,
					evapTemp,
					equilibrationTime,
					rampTime,
					evapTime,
					evapPressure,
					rotationRate,
					evapUntilDry,
					maxEvapTime
				} = Lookup[
					myMapThreadOptions,
					{
						EvaporationType,
						Instrument,
						SolventBoilingPoints,
						EvaporationTemperature,
						EquilibrationTime,
						PressureRampTime,
						EvaporationTime,
						EvaporationPressure,
						RotationRate,
						EvaporateUntilDry,
						MaxEvaporationTime
					}
				];

				(* Store our SpeedVac specific options*)
				speedVacOptionVals = {
					vacEvapMethod,
					bump,
					balancingSolution
				} = Lookup[myMapThreadOptions, speedVacExclusiveOptions];

				(* Store our RotoVap specific options *)
				rotovapOptionVals = {
					evapFlask,
					condenserTemp,
					recoupTrap,
					recoupTrapSolution,
					recoupTrapVolume,
					recoupTrapContainer,
					recoupCondensate,
					condensateSampleContainer
				} = Lookup[myMapThreadOptions, rotoVapExclusiveOptions];

				(* Store our NitrogenBlower specific options *)
				nitrogenOptionVals = {
					flowRateProfile
				} = Lookup[myMapThreadOptions, nitrogenBlowerExclusiveOptions];

				(* Stash the default volume of the sample. If the volume is missing, default to 0. We will have thrown an error above *)
				mySampVol = Max[Replace[myPoolVolume, Null -> 0 * Milli * Liter]];

				(* We just want to know roughly what type of solvent (aqueous, organic, mixture) and what boiling points (<50C, 50-90C, 90C) we are dealing with as a whole.
					So we don't need to be super precise for each sample. *)
				(* Get the liquid samples and the liquid non-stock solution components of any stock solution samples *)
				rootComponentPackets = DeleteCases[
					Flatten[mySampleComponents],
					Alternatives[
						KeyValuePattern[State -> Solid],
						ObjectP[Object[Sample]],
						ObjectP[Model[Sample, StockSolution]],
						Null,
						$Failed
					]
				];

				(* Roughly figure out the type of solvents we are dealing with. *)
				solventType = Switch[Download[rootComponentPackets, Object],

					(* If all of the samples/liquid stock solution components are water, classify the solvent type as Aqueous *)
					{WaterModelP..},
					Aqueous,
					(* If the samples/liquid stock solution only contains one chemical, classify the solvent type as Organic (this isn't a great system, but we just need to know roughly anyway). *)
					{ObjectP[{Object[Sample], Model[Sample]}]},
					Organic,
					(* If the samples/liquid stock solution contains many chemicals, classify the solvent type as Mixture (this isn't a great system, but we just need to know roughly anyway). *)
					{ObjectP[{Object[Sample], Model[Sample]}]..},
					Mixture,
					(* Otherwise classify it as Mixture. *)
					_,
					Mixture
				];

				(* get the relative percentages of volumes for the pools *)
				(* Added check against myPoolVolume being 0 Liter because it threw an error that could halt Scripts *)
				pooledVolumePercentages = Which[
					MatchQ[myPoolVolume, {0. Liter}],
					{Indeterminate},
					
					(*if we have only one sample in the pool - the percent is 100%*)
					Length[mySamplePool]==1,
					{1},
					
					(*we have a pool with more than 1 sample - we actually need to calculate %*)
					True,
					Module[{safePoolVolume,componentsVolume},
						componentsVolume = MapThread[
							Which[
								VolumeQ[#1],#1,
								VolumeQ[Lookup[#2,Volume]],Lookup[#2,Volume],
								True,Null
							]&,
							{Lookup[mySamplePrepOptions,AliquotAmount],mySamplePool}
						];

						safePoolVolume = If[VolumeQ[myPoolVolume],
							myPoolVolume,
							Total@componentsVolume
						];

						Map[#/safePoolVolume&,componentsVolume]
					]
					
				];

				(* get the combined composition of the pool *)
				combinedComposition = Join @@ MapThread[
					Function[{composition, volumePercent},
						If[NullQ[volumePercent],
							Nothing,
							Map[
								If[NullQ[#[[1]]],
									Nothing,
									{#[[1]] * volumePercent, #[[2]]}
								]&,
								composition
							]
						]
					],
					{Lookup[mySamplePool, Composition], pooledVolumePercentages}
				];

				(* Pull out the boiling point option value *)
				specifiedBoilingPoints = ToList[solventBP];

				(* Get the boiling points of the samples, if it is known *)
				knownBoilingPoints = If[
					MatchQ[Lookup[mySamplePool, BoilingPoint], TemperatureP],

					(* Use the boiling point stashed in the sample *)
					Lookup[mySamplePool, BoilingPoint],

					(* Otherwise pull it out of the components *)
					Lookup[
						DeleteCases[(* TODO: Delete these nulls elsewhere *)
							Flatten[mySampleComponents],
							Null
						],
						BoilingPoint
					]
				];

				(* Resolve the boiling point *)
				resolvedBoilingPoint = Which[

					(* If boiling point(s) are specified, use them *)
					MatchQ[specifiedBoilingPoints, ListableP[GreaterP[0 Kelvin] | SolventBoilingPointP]],
					specifiedBoilingPoints,

					(* If boiling point is known for all of the samples, use them *)
					!MemberQ[knownBoilingPoints, Null | $Failed],
					DeleteDuplicates[knownBoilingPoints],

					(* Otherwise, resolve on what boiling points we do know and on the solvent type *)
					True,
					DeleteDuplicates[Flatten[Join[ToList[knownBoilingPoints], ToList[solventType]] /. {Null -> Nothing, $Failed -> Nothing, Aqueous -> High, Organic -> {Medium, High}, Mixture -> {Medium, High}}]]
				];

				(* Convert the resolvedBoilingPoint to a rough temperature if it is med/high/low *)
				resBoilingPointToTemp = If[MatchQ[Select[resolvedBoilingPoint, TemperatureQ], Alternatives[Null, {}]],
					Switch[DeleteCases[resolvedBoilingPoint, Null],
						{Low}, 40 Celsius,
						{Medium}, 60 Celsius,
						{High}, 80 Celsius,
						{Medium, High}, 60 Celsius,
						___, 35 Celsius
					],
					Min[Select[resolvedBoilingPoint, TemperatureQ]] (*If there is a temperature specified, use that*)
				];

				(* EvaporationType Master Switch*)
				resolvedType = Which[

					(* User has specified an evaporation type*)
					MatchQ[evapType, Except[Automatic]],
					evapType,

					(* User has specified an instrument*)
					MatchQ[evapInstrument, Except[Automatic]],
					(* Pull the instrument's type *)
					Switch[evapInstrument,
						ObjectP[{Object[Instrument, RotaryEvaporator], Model[Instrument, RotaryEvaporator]}],
						RotaryEvaporation,
						ObjectP[{Object[Instrument, VacuumCentrifuge], Model[Instrument, VacuumCentrifuge]}],
						SpeedVac,
						ObjectP[{Object[Instrument, Evaporator], Model[Instrument, Evaporator]}],
						NitrogenBlowDown,
						_, (* Failure Case *)
						SpeedVac
					],

					(* Determine if speedvac specific options are provided and no other option types are provided*)
					And[
						MemberQ[speedVacOptionVals, Except[Automatic | Null | False]],
						!MemberQ[Join[rotovapOptionVals, nitrogenOptionVals], Except[Automatic | Null | False]]
					],
					SpeedVac,

					(* Determine if rotovap specific options are provided and no other option types are provided*)
					And[
						MemberQ[rotovapOptionVals, Except[Automatic | Null | False]],
						!MemberQ[Join[speedVacOptionVals, nitrogenOptionVals], Except[Automatic | Null | False]]
					],
					RotaryEvaporation,

					(* Determine if nitrogen blower specific options are provided and no other option types are provided*)
					And[
						MemberQ[nitrogenOptionVals, Except[Automatic | Null | False]],
						!MemberQ[Join[speedVacOptionVals, rotovapOptionVals], Except[Automatic | Null | False]]
					],
					NitrogenBlowDown,

					(* Is the samples volume within the SpeedVac range? 50mL represents the largest compatible SpeedVac container *)
					Less[mySampVol, 50 * Milli * Liter],
					SpeedVac,

					(* Otherwise default to Rotovap as that can handle the largest range of volumes *)
					True,
					RotaryEvaporation
				];

				(* Based on the master switch, enter option resolution for the specific evaporation types*)
				{
					(*1*)resolvedEvapInstrument,
					(*2*)resolvedEvapTemp,
					(*3*)resolvedEquilibrationTime,
					(*4*)resolvedRampTime,
					(*5*)resolvedEvapTime,
					(*6*)resolvedEvapPressure,
					(*7*)resolvedRotationRate,
					(*8*)resolvedVacEvapMethod,
					(*9*)resolvedBump,
					(*10*)resolvedBalancingSolution,
					(*11*)resolvedEvapFlask,
					(*12*)resolvedCondenserTemp,
					(*15*)resolvedRecoupTrap,
					(*16*)resolvedRecoupTrapSolution,
					(*17*)resolvedRecoupTrapVolume,
					(*18*)resolvedRecoupTrapContainer,
					(*21*)resolvedRecoupCondensate,
					(*22*)resolvedCondensateSampleContainer,

					(*make sure these are accounted for in the SpeedVac and rotovap instruments*)
					(*23*)resolvedFlowRateProfile,
					(*24*)typeOptionConflicts,
					(*25*)noVaporPressureError
				} = Switch[resolvedType,

					(* -------- SpeedVac -------- *)
					SpeedVac, Module[
						{
							resInst, specifiedMethodPacket, controlledEvaporation, resMethod, balancingSolutionOption,
							resBalancingSolution, resMethodPacket, equilibrationTimeOption, evaporationTimeOption, defaultEquilibrationTime,
							defaultEvaporationTime, resEquilTime, resTime, optionConflicts, defaultedUnnecessaryOptions, resTemp, resInstPacket, resRampTime,
							resPressure, resFlowRateProfile, newNitrogenOptionVals, noVaporPressure
						},

						(* these error messages are just for rotovap so just set them False for speedvac*)
						noVaporPressure = False;

						(* TODO: Change if we get more models of speedvacs in *)
						(* Get the vacuum centrifuge option, which can either be a model or an object *)
						resInst = If[MatchQ[evapInstrument, Automatic],

							(* Default to the only model of instrument we have*)
							Model[Instrument, VacuumCentrifuge, "id:n0k9mGzRal4w"], (*Genevac EZ-2.3 Elite*)

							evapInstrument
						];

						(* TODO: Add an error in case they specified an instrument that isn't a speed vac *)

						(* Stash the packet of the instrument we've resolved to *)
						resInstPacket = fetchPacketFromFastAssoc[resInst, fastAssocSimulatedCache];

						(* - If the user told us that the sample is likely to bump but selected a method that does not have controlled chamber evacuation,
 							give them a warning and suggest that they use a different method or allow method to be resolved automatically. - *)
						(* Get the corresponding method packet. (If they didn't specify a method, this will be {}.) *)
						specifiedMethodPacket = FirstCase[methodPackets, KeyValuePattern[Object -> Download[vacEvapMethod, Object]], {}];

						(* Get the ControlledChamberEvacuation for the method. (This is Null if they didn't specify a method.) *)
						controlledEvaporation = Lookup[specifiedMethodPacket, ControlledChamberEvacuation, Null];

						(* If the user told us that the sample is likely to bump but selected a method that does not have controlled chamber evacuation,
						 give them a warning and suggest that they use a different method or allow method to be resolved automatically *)
						bumpMethodConflictWarning = bump && !controlledEvaporation;

						(* Resolve the method *)
						resMethod = If[MatchQ[vacEvapMethod, ObjectP[Object[Method, VacuumEvaporation]]],
							vacEvapMethod,
							Switch[{DeleteCases[resolvedBoilingPoint, Null], bump, solventType},
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, False, Aqueous}, Object[Method, VacuumEvaporation, "Aqueous"],
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, False, Organic}, Object[Method, VacuumEvaporation, "HighBoilingPoint"],
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, False, Mixture}, Object[Method, VacuumEvaporation, "HPLC"],
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, True, Aqueous}, Object[Method, VacuumEvaporation, "AqueousHCl"],
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, True, Organic}, Object[Method, VacuumEvaporation, "AqueousHCl"],
								{{Alternatives[GreaterEqualP[90 Celsius], High] ..}, True, Mixture}, Object[Method, VacuumEvaporation, "HPLC"],
								{{Alternatives[RangeP[50 Celsius, 90 Celsius], Medium] ..}, False, _}, Object[Method, VacuumEvaporation, "LowBoilingPoint"],
								{{Alternatives[RangeP[50 Celsius, 90 Celsius], Medium] ..}, True, _}, Object[Method, VacuumEvaporation, "LowBoilingPointMix"],
								{{Alternatives[LessP[50 Celsius], Low] ..}, _, _}, Object[Method, VacuumEvaporation, "VeryLowBoilingPoint"],
								{{Alternatives[GreaterEqualP[50 Celsius], High, Medium] ..}, _, _}, Object[Method, VacuumEvaporation, "HighAndLowBoilingPointMix"],
								{{Alternatives[LessP[90 Celsius], Low, Medium] ..}, _, _}, Object[Method, VacuumEvaporation, "VeryLowBoilingPointMix"],
								{{Alternatives[LessP[50 Celsius], GreaterEqualP[90 Celsius], High, Low] ..}, _, _}, Object[Method, VacuumEvaporation, "HighAndLowBoilingPointMix"],
								___, Object[Method, VacuumEvaporation, "HighAndLowBoilingPointMix"]
							]
						];

						(* Get the unresolved balancing solution option *)
						balancingSolutionOption = balancingSolution;

						(* Resolve the balancing solution. We don't need a perfect match, so just choose between methanol and water *)
						resBalancingSolution = Which[

							(* If the user specified a balancing solution, use that *)
							MatchQ[balancingSolutionOption, ObjectP[]],
							balancingSolutionOption,

							(* If the boiling points are <90C, use methanol*)
							MatchQ[ToList[resolvedBoilingPoint], {Alternatives[LessP[90 Celsius], Low, Medium] ..}],
							Model[Sample, "Methanol"],

							(* Otherwise, use water *)
							True,
							Model[Sample, "Milli-Q water"]
						];

						(* Find the packet that corresponds to the resolved method *)
						resMethodPacket = FirstCase[methodPackets, KeyValuePattern[Object -> Download[resMethod, Object]], {}];

						(* Get the specified equilibration time and evaporation time*)
						equilibrationTimeOption = equilibrationTime;
						evaporationTimeOption = evapTime;

						(* Resolve the temperature to Ambient unless specified otherwise *)
						resTemp = If[MatchQ[evapTemp, TemperatureP],
							evapTemp,
							25.` * Celsius
						];

						(* Double check if the evaporation temperature selected is outside the range of the instrument *)
						impossibleEvapTempError = And[
							(* If the instrument was specified incorrectly, that will be a different error and we can skip this check *)
							MatchQ[resInst, ObjectP[{Model[Instrument, VacuumCentrifuge], Object[Instrument, VacuumCentrifuge]}]],

							(* If a valid instrument was provided, make sure the temperature resolved to is between min/max temp of the instrument *)
							!MatchQ[resTemp, RangeP[Lookup[resInstPacket, MinTemperature], Lookup[resInstPacket, MaxTemperature]]]
						];

						(* Get the default equilibration time and evaporation time for the resolved method *)
						defaultEquilibrationTime = 0 * Minute(* TODO: Change the default wait time here if we decide we need a temp equil *);
						defaultEvaporationTime = Lookup[resMethodPacket, EvaporationTime];

						(* If the user specified an equilibration time, use that. Otherwise, use the default time for the method. *)
						resTime = If[MatchQ[evaporationTimeOption, TimeP],
							evaporationTimeOption,
							defaultEvaporationTime
						];

						(* If the user specified an equilibration time, use that. Otherwise, use the default time for the method. *)
						resEquilTime = If[MatchQ[equilibrationTimeOption, TimeP],
							equilibrationTimeOption,
							defaultEquilibrationTime
						];

						(* Resolve the Ramp Time to the specified value or to the method's value  *)
						resRampTime = If[MatchQ[rampTime, TimeP],
							rampTime,
							Lookup[resMethodPacket, PressureRampTime, 1 * Hour](*TODO: Potentiall remove this pressure ramp time hardcode *)
						];

						(* Resolve the EvaporationPressure to the specified value or to the method's value *)
						resPressure = If[MatchQ[evapPressure, PressureP],
							evapPressure,
							Lookup[resMethodPacket, EvaporationPressure, 0 * Millibar]
						];

						(* Pick out any options that apply to a non-speedvac evaporation type that are NOT Automatic|Null	*)
						optionConflicts = PickList[
							Join[{rotationRate}, rotoVapExclusiveOptions, nitrogenBlowerExclusiveOptions],
							Join[{rotationRate}, rotovapOptionVals, nitrogenOptionVals],
							Except[Automatic | Null | False | {Automatic, Automatic, Automatic} | {Automatic}]
						];

						(*default FlowRateProfile to Null: necessary since FlowRateProfiles are of the form *)
						resFlowRateProfile = Replace[flowRateProfile, Automatic -> Null];
						newNitrogenOptionVals = ReplacePart[nitrogenOptionVals, 2 -> resFlowRateProfile];

						(* Determine if we need to throw a warning below for this sample pool*)
						speedVacAmbiguousWarning = !MatchQ[optionConflicts, {}];

						(* Default any options that are still automatic to Null. Leave user values untouched *)
						defaultedUnnecessaryOptions = Replace[#, Automatic -> Null]& /@ Join[rotovapOptionVals, newNitrogenOptionVals];

						{
							resInst,
							resTemp,
							resEquilTime,
							resRampTime,
							resTime,
							resPressure,
							Replace[rotationRate, Automatic -> Null],
							resMethod,
							Lookup[resMethodPacket, ControlledChamberEvacuation], (* This is bump protection *)
							resBalancingSolution,
							Sequence @@ defaultedUnnecessaryOptions,
							optionConflicts,
							noVaporPressure
						}
					],

					(* -------- Rotary Evaporation -------- *)
					RotaryEvaporation, Module[
						{
							resInst, resTempEquil, resTemp, resCondenserTemp, resPressure, resRampTime, resTime, resEvapFlask, resRotationRate,
							resRecoupTrap, resRecoupTrapSolution, resRecoupTrapVolume, resRecoupTrapContainer,
							optionConflicts, defaultedUnnecessaryOptions, resFlowRateProfile, newNitrogenOptionVals,
							noVaporPressure, evapFlaskMaxVolume, resRecoupCondensate, resCondensateSampleContainer, combinedVaporPressure, vaporPressurePercentages
						},

						(* Resolve the instrument type *)
						resInst = Replace[evapInstrument, Automatic -> Model[Instrument, RotaryEvaporator, "id:jLq9jXvmeYxR"]];

						(* Default EquilibrationTime *)
						resTempEquil = Replace[equilibrationTime, {Automatic -> 5 * Minute, Null -> 0 Minute}];

						(* Default EvaporationTemperature to room temperature; the point of rotovap is you don't heat it high anyway *)
						(* We don't try to back calculate EvaporationTemperature given a EvaporationPressure - we assume user knows what they are doing when they set EvaporationPressure *)
						resTemp = Replace[evapTemp, {Automatic | Ambient -> 25.` * Celsius}];

						(* Default EvaporationTemperature *)
						resCondenserTemp = Replace[condenserTemp, {Automatic | Null -> -20.` * Celsius, Ambient -> 25.` * Celsius}];

						{combinedVaporPressure, vaporPressurePercentages} = Module[{pressuresAndPercentages},
							(* Resolve evaporation pressure based on Clausius-Clapeyron equation *)
							(*  Log P = Constant1 * 1/T + Constant 2 - Constant 1 and Constant 2 varies for different molecules - T_target = resTemp *)
							pressuresAndPercentages = Map[
								Function[{comp},
									Module[{compRTVapPressure, compBP, ccEquation, scaledRTVapPressure, scaledConst, scaledBP, scaledResVapPressure, scaledResTemp,
										solvedVarsRaw, compResVapPressure},
										(* Pull out the vapor pressure for the specific component at room temperature *)
										compRTVapPressure = fastAssocLookup[fastAssocSimulatedCache, comp[[2]], VaporPressure];
										(* Pull out the boiling point for the specific component *)
										compBP = fastAssocLookup[fastAssocSimulatedCache, comp[[2]], BoilingPoint];

										(* Set up the Clausius-Clapeyron equation *)
										(* P1 = atmosphere (KNOWN), T1 = compBP *)
										(* P2 = compRTVapPressure, T2 = 25*Celsius (KNOWN) *)
										(* P3 = vapPressureToSolve, T3 = resTemp (KNOWN) *)
										ccEquation = {
											(* Log(P1/P2) = const*(1/T1-1/T2) *)
											Log[(QuantityMagnitude[1 * Atmosphere, Pascal] / scaledRTVapPressure)] == scaledConst * (1 / scaledBP - 1 / QuantityMagnitude[25 * Celsius, Kelvin]),
											(* Log(P1/P3) = const*(1/T1-1/T3) *)
											Log[(QuantityMagnitude[1 * Atmosphere, Pascal] / scaledResVapPressure)] == scaledConst * (1 / scaledBP - 1 / scaledResTemp)
										};
										(* Convert everything into consistent unitless numbers, and assign values if we can *)
										(* Pressure -> Pascal *)
										(* Temperature -> Kelvin *)
										scaledBP = If[MatchQ[compBP, TemperatureP],
											QuantityMagnitude[compBP, Kelvin],
											scaledBP
										];
										scaledRTVapPressure = If[MatchQ[compRTVapPressure, PressureP],
											QuantityMagnitude[compRTVapPressure, Pascal],
											scaledRTVapPressure
										];
										scaledResTemp = If[MatchQ[resTemp, TemperatureP],
											QuantityMagnitude[resTemp, Kelvin],
											scaledResTemp
										];
										(* Solve the equation *)
										solvedVarsRaw = Quiet[First[Solve[ccEquation], {}]];
										(* Extract the solved pressure at given EvaporationTemperature for the current component *)
										compResVapPressure = (scaledResVapPressure /. solvedVarsRaw) * Pascal;
										(* Get the percentages and combined pressures as lists *)
										If[Not[PressureQ[compResVapPressure]] || Not[MatchQ[comp[[1]], VolumePercentP]],
											Nothing,
											With[{compNumber = Unitless[comp[[1]], VolumePercent] / 100},
												{compResVapPressure * compNumber, compNumber}
											]
										]
									]
								],
								combinedComposition
							];
							(* total them together here *)
							{Total[pressuresAndPercentages[[All, 1]]], Total[pressuresAndPercentages[[All, 2]]]}
						];

						(* if we have not set pressure and there is no vapor pressure for the input sample, then throw an error *)
						(* threshold we're setting for when we "know" the vapor pressure is if we know the vapor pressure of 70 volume percent of the components (or higher) *)
						noVaporPressure = MatchQ[evapPressure, Automatic | Null] && (Not[PressureQ[combinedVaporPressure]] || vaporPressurePercentages < 0.7);

						(* Default EvaporationPressure to 50 Millibar unless a User has provided a value.*)
						resPressure = Which[
							(* if it's specified, just go with it *)
							MatchQ[evapPressure, PressureP], evapPressure,
							(* if we have an error resolving the pressure, just pick 50 Millibar because it's arbitrary and going to get stopped anyway *)
							noVaporPressure, 50 Millibar,
							(* if the vapor pressure is at 100 Millibar or More, then set the pressure to 10 Millibar below the vapor pressure *)
							MatchQ[combinedVaporPressure, GreaterP[100 Millibar]], combinedVaporPressure - 10 Millibar,
							(* if the vapor pressure is at 50 Millibar or More, then set the pressure to 5 Millibar below the vapor pressure *)
							MatchQ[combinedVaporPressure, GreaterP[50 Millibar]], combinedVaporPressure - 5 Millibar,
							(* if the vapor pressure is _less_ than 50 Millibar, then do the combined vapor pressure itself *)
							True, combinedVaporPressure
						];

						(* Default PresureRampTime to based on sample volume unless a User has provided a value *)
						resRampTime = If[!MatchQ[rampTime, Automatic],

							(* User has specified a value so use it *)
							rampTime,

							(* Otherwise set to 10 minutes; the previous reasoning here was way too elaborate and not meaningful *)
							10 Minute
						];

						(* Default Evaporation Flask *)
						resEvapFlask = If[!MatchQ[evapFlask, Automatic],

							(* User has specified a value so use it. Make sure it is big enough and that it has a 24/40 joint*)
							If[And[
								Greater[mySampVol, 0.5 * Lookup[fetchPacketFromFastAssoc[evapFlask, fastAssocSimulatedCache], MaxVolume]],
								Not[ContainsAny[Lookup[fetchPacketFromFastAssoc[evapFlask, fastAssocSimulatedCache], Connectors][[All, 3]], {"24/40"}]]
							],

								(* The volume is great than half the flask, meaning we can't use it *)
								(
									primaryEvaporationContainerConflictError = True;
									evapFlask
								),

								(* If it's less than half the volume the flask is fine *)
								evapFlask
							],

							(* We should pick a container large enough. The volume of the flask must be 2x the volume of the sample *)
							(*We will select based on the max volume of all possible rotovap flasks*)

							Module[{sortedRotoPearContainerPackets, potentialContainer},
								(* Sort the found containers by their max volume *)
								sortedRotoPearContainerPackets = SortBy[rotoPearContainerPackets, Lookup[#, MaxVolume]&];
								(* try to find if we have a suitable evap that is at least 2x the volume of the sample *)
								potentialContainer = Lookup[FirstCase[sortedRotoPearContainerPackets, KeyValuePattern[MaxVolume -> GreaterEqualP[2 * mySampVol]]], Object];
								(* return if we found a container, otherwise failure mode *)
								If[MatchQ[potentialContainer, ObjectP[{Object[Container, Vessel], Model[Container, Vessel]}]],
									potentialContainer,
									(* The volume is great than half the flask, meaning we can't use it *)
									(
										primaryEvaporationContainerConflictError = True;
										Lookup[FirstCase[rotoVapContainerPackets, KeyValuePattern[MaxVolume -> GreaterEqualP[2 Liter]]], Object](* 2L Pear Shaped Flask with 24/40 Joint - Currently the largest we have *)
									)
								]

							]

						];

						(* get the MaxVolume of the sample's evaporation flask *)
						evapFlaskMaxVolume = If[MatchQ[resEvapFlask, ObjectP[Model[Container]]],
							fastAssocLookup[fastAssocSimulatedCache, resEvapFlask, MaxVolume],
							fastAssocLookup[fastAssocSimulatedCache, resEvapFlask, {Model, MaxVolume}]
						];

						(* Default EvaporationTime *)
						(* if we don't know the vapor pressure, then we need to just pick 2 hours (very arbitrary) *)
						(* we are assuming if we're 10 Millibar below the vapor pressure, we're going to evaporate ~300 mL per hour *)
						(* if we're at within less than 10 Millibar all the way to the vapor pressure, we're going to pick ~140 mL per hour *)
						(* if we're more than 10 Millibar below the vapor pressure, stick with 300 mL per hour, and if we're higher than the vapor pressure, just do 2x whatever we'd do at the vapor pressure *)
						(* this is fully understood to be rather ham-fisted and imprecise.  These numbers were obtained empirically with a bunch of runs with ethyl acetate and hexanes *)
						(* minimum value is 5 Minute unless the user set it too *)
						resTime = Which[
							Not[MatchQ[evapTime, Automatic]], evapTime,
							Not[PressureQ[combinedVaporPressure]], 2 Hour,
							MatchQ[resPressure - combinedVaporPressure, LessEqualP[-10 Millibar]], RoundOptionPrecision[mySampVol / (300 Milliliter / Hour), 10^0 Minute, Messages -> False] /. {x:LessP[5 Minute] :> 5 Minute},
							MatchQ[resPressure - combinedVaporPressure, RangeP[-10 Millibar, 0 Millibar]], RoundOptionPrecision[mySampVol / (140 Milliliter / Hour), 10^0 Minute, Messages -> False] /. {x:LessP[5 Minute] :> 5 Minute},
							True, 2 * RoundOptionPrecision[mySampVol / (140 Milliliter / Hour), 10^0 Minute, Messages -> False] /. {x:LessP[5 Minute] :> 5 Minute}
						];

						(* Default RotationRate to Null unless a User has provided a value. We'll generate a warning for that later *)
						resRotationRate = If[!MatchQ[rotationRate, Automatic],

							(* User has specified a value so use it *)
							rotationRate,

							(* Otherwise resolve the RotationRate base on the size of the EvaporationFlask *)
							Switch[evapFlaskMaxVolume,
								LessP[50 Milliliter], 200 RPM,
								RangeP[50Milliliter, 1 Liter, Inclusive -> Left], 150 RPM,
								GreaterEqualP[1 Liter], 80 RPM
							]
						];

						(* RecoupTrap only affects whether we store or discard/cleanup the BumpTrapSampleContainer after transferring and rinsing bump trap *)
						(* Always default to store the recouped sample from bump trap if no user-value provided *)
						resRecoupTrap = If[MatchQ[recoupTrap, Except[Automatic]], recoupTrap, True];
						(* Regardless of the RecoupTrap option, we are always resolving BumpTrapRinseSolution, BumpTrapRinseVolume, and BumpTrapSampleContainer *)
						{resRecoupTrapSolution, resRecoupTrapVolume, resRecoupTrapContainer} = Module[
							{resTrapRinseVol, resTrapRinseSamp, resTrapRinseCont},

							(* Resolve BumpTrapRinseVolume and make sure, if a volume was provided, it's not too big *)
							resTrapRinseVol = If[MatchQ[recoupTrapVolume, Automatic],

								(* TODO: Work out how this line will resolve, specifically how to get MaxVolume from the bump trap *)
								(* Base the volume off the bump trap. The bump trap is hard resolved based on which EvapFlask is being used *)
								Round[((1 / 8) * Lookup[fetchPacketFromFastAssoc[resEvapFlask, fastAssocSimulatedCache], MaxVolume]), 1 * Milliliter],

								(* The user gave us a value, make sure it's not too large for the container we're given *)
								If[

									(* Checking for error states *)
									And[

										(* If we were given a volume *)
										MatchQ[recoupTrapVolume, VolumeP],

										(* Following are error states*)
										Or[
											(* If the volume is greater than the size of the largest bump trap, we must throw an error *)
											recoupTrapVolume > 200 * Milliliter, (* TODO: Remove this hardcode, but at the moment it's the only size bump trap we use *)

											(* When BumpTrapSampleContainer is the same as EvaporationFlask, we must throw an error if the volume is greater than MaxVolume of that flask *)
											If[MatchQ[Download[recoupTrapContainer, Object], ObjectReferenceP[Download[resEvapFlask, Object]]],
												recoupTrapVolume > Lookup[getModelPacket[resEvapFlask], MaxVolume],
												(* if recoupTrapContainer is different from the evaporation flask, then we are good *)
												False
											],
											(* Or if they provided a container, we must throw an error if volume is greater than that containers MaxVolume *)
											If[MatchQ[recoupTrapContainer, ObjectP[]],
												recoupTrapVolume > Lookup[getModelPacket[recoupTrapContainer], MaxVolume],
												(* if recoupTrapContainer is Automatic, then we are good *)
												False
											]
										]
									],

									(* We've established the volume is too large, stash an error *)
									(
										bumpTrapRinseSolutionVolumeError = True;
										recoupTrapVolume
									),

									(* We were given a valid volume or Null. We already checked above the MapThread section whether it's ok for it to be Null *)
									recoupTrapVolume
								]
							];

							(* Default the bump trap rinse solution model *)
							resTrapRinseSamp = If[MatchQ[recoupTrapSolution, Automatic],

								(* default to a solvent *)
								Model[Sample, "id:Vrbp1jG80zno"], (*Acetone, Reagent Grade*)

								(* Otherwise return the user's value. If it wasn't a valid value, we would've already thrown an error *)
								recoupTrapSolution
							];

							(* Resolve the RinseContainer *)
							resTrapRinseCont = If[MatchQ[recoupTrapContainer, Automatic],

								(* Use PreferredContainer on the rinse volume to pick a suitable container for the rinsed solution *)
								PreferredContainer[resTrapRinseVol],

								(* If the user provided a value, return it. If it's not an object, we will have thrown an error above already *)
								recoupTrapContainer
							];

							(* True here represents RecoupBumpTrap, which we determine at the top of the If statement must be True *)
							{resTrapRinseSamp, resTrapRinseVol, resTrapRinseCont}
						];

						(* Resolve RecoupCondensate/CondensateSampleContainer *)
						(* if they're both specified, just go with both *)
						(* if they're both not specified, or one or the other is False/Null, then set both to Null *)
						(* if True, go with the PreferredContainer *)
						(* if a container is specified, assume True *)
						(* otherwise just default Automatics to Null *)
						{resRecoupCondensate, resCondensateSampleContainer} = Switch[{recoupCondensate, condensateSampleContainer},
							{Except[Automatic], Except[Automatic]}, {recoupCondensate, condensateSampleContainer},
							{Automatic | False | Null, Automatic | Null}, {False, Null},
							{True, Automatic}, {recoupCondensate, PreferredContainer[mySampVol /. {Null | LessP[5 Milliliter] -> 5 Milliliter}]},
							{Automatic, ObjectP[{Model[Container], Object[Container]}]}, {True, condensateSampleContainer},
							{_, _}, {recoupCondensate, condensateSampleContainer} /. {Automatic -> Null}
						];

						(* Pick out any options that apply to a non-rotovap evaporation type that are NOT Automatic|Null	*)
						optionConflicts = PickList[
							Join[speedVacExclusiveOptions, nitrogenBlowerExclusiveOptions],
							Join[speedVacOptionVals, nitrogenOptionVals],
							Except[Automatic | Null | False | {Automatic} | {Automatic, Automatic, Automatic}]
						];

						(* Determine if we need to throw a warning below for this sample pool*)
						rotovapAmbiguousWarning = !MatchQ[optionConflicts, {}];

						(*default FlowRateProfile to Null: necessary since FlowRateProfiles are of the form {{},{},{}}*)
						resFlowRateProfile = Replace[flowRateProfile, Automatic -> Null];
						newNitrogenOptionVals = ReplacePart[nitrogenOptionVals, 2 -> resFlowRateProfile];

						(* Build a list of rules in the form unnecessary option -> defaulted or user value *)
						defaultedUnnecessaryOptions = MapThread[
							Function[{optName, optVal}, optName -> Replace[optVal, Automatic -> Null]],
							{
								Join[speedVacExclusiveOptions, nitrogenBlowerExclusiveOptions],
								Join[speedVacOptionVals, newNitrogenOptionVals]
							}
						];

						{
							resInst,
							resTemp,
							resTempEquil,
							resRampTime,
							resTime,
							resPressure,
							resRotationRate,
							Lookup[defaultedUnnecessaryOptions, VacuumEvaporationMethod],
							Lookup[defaultedUnnecessaryOptions, BumpProtection],
							Lookup[defaultedUnnecessaryOptions, BalancingSolution],
							resEvapFlask,
							resCondenserTemp,
							resRecoupTrap,
							resRecoupTrapSolution,
							resRecoupTrapVolume,
							resRecoupTrapContainer,
							resRecoupCondensate,
							resCondensateSampleContainer,
							Lookup[defaultedUnnecessaryOptions, FlowRateProfile],
							optionConflicts,
							noVaporPressure
						}
					],

					(* -------- Nitrogen Blowing -------- *)
					NitrogenBlowDown, Module[
						{
							resInst, resNitrogenInstrumentType, resFRP, resTemp, resTempEquil, nitrogenEvapRate, resTime, resRampTime, resPressure, resRotationRate,
							optionConflicts, defaultedUnnecessaryOptions, evapContainerMaxVol, noVaporPressure
						},

						(* these error messages are just for rotovap so just set them False for nitrogen blow down *)
						noVaporPressure = False;

						(* Resolve the instrument type *)
						resInst = Which[
							(* Set to the specified Instrument, if specified *)
							MatchQ[evapInstrument, Except[Automatic]],
							evapInstrument,

							(* Select the needle dryer if the user specifies 1 FlowRateProfile and the sample is in a 96-well plate*)
							And[
								MatchQ[First[Lookup[myContainerModel, Object]], ObjectP[Model[Container, Plate]]],
								MatchQ[flowRateProfile, Alternatives[Automatic, {{_, _}}]]
							],
							Model[Instrument, Evaporator, "id:R8e1PjRDb36j"],

							(* Select the Tube Dryer if they specify > 1 flow rate profile *)
							Greater[Length[flowRateProfile], 1],
							Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"],

							(* Otherwise, default to the tube dryer *)
							True,
							Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"]
						];

						(* Distinguish between the needle dryer and tube dryer *)
						resNitrogenInstrumentType = If[
							MatchQ[resInst, ObjectP[{Model[Instrument, Evaporator, "id:R8e1PjRDb36j"], Object[Instrument, Evaporator, "id:xRO9n3vk1DDY"]}]],
							NeedleDryer,
							TubeDryer
						];

						(* Get the evaporation container. If the sample is pooled, it will be the preferred container, otherwise, it is the original container that the sample is in*)
						evapContainerMaxVol = If[
							MatchQ[Length[myContainerModel], 1], (*sample is not pooled*)
							First[Lookup[myContainerModel, MaxVolume]],
							Lookup[myPoolContainer, MaxVolume]
						];

						If[
							(* -- The NeedleDryer is selected -- *)
							MatchQ[resNitrogenInstrumentType, NeedleDryer],
							{resFRP, resTime} = Module[{flowRates, times},

								(* TODO: Experimentally verifiy *)
								nitrogenEvapRate = 1` * Milliliter / Hour;

								(* Resolve the flow rate *)
								If[
									(* User specified. Only one FRP can be specified. If there are more, throw an error; we'll generate this later. *)
									MatchQ[flowRateProfile, Except[Automatic | {Automatic} | {Automatic, Automatic}]],
									(*Get the evaporation times. If no value specified, set it equal to what is in the FlowRateProfile*)
									times = If[
										MatchQ[evapTime, Except[Automatic]],
										evapTime,
										Replace[evapTime, Automatic -> Plus @@ flowRateProfile[[All, 2]]]
									];

									If[
										(*1 FRP is specified*)
										MatchQ[Length[flowRateProfile], 1],
										flowRates = Convert[flowRateProfile, {Liter / Minute, Minute}];  (*Convert duration to Minute units*)

										(* If the flowRate is high, throw a warning about possible sample splashing *)
										highFlowRateWarning = If[
											And[
												GreaterEqual[mySampVol, 0.6 * evapContainerMaxVol],
												Greater[flowRates[[1, 1]], 16 Liter / Minute]
											],
											True,
											False
										],

										(* Otherwise, more than 1 flow rate profile is specified, throw an options conflict warning *)
										flowRateProfileWarning = True; flowRates = flowRateProfile
									],

									(* Otherwise, no flow rate profile is provided so we will automatically resolve: set the resTime to what the user-specified or what the sample volume is *)
									times = If[MatchQ[evapTime, Except[Automatic]],
										evapTime,
										Replace[evapTime, Automatic -> SafeRound[Min[48 * Hour, mySampVol / (nitrogenEvapRate)], 1 Minute]]
									];

									(* Then switch off intensity based on how large the volume is *)
									flowRates = If[
										GreaterEqual[mySampVol, 0.6 * evapContainerMaxVol],
										{{12.5` Liter / Minute, Convert[times, Minute]}},
										{{25.` Liter / Minute, Convert[times, Minute]}}
									];
									(*Return the resolved flow rate profiles and evaporation times*)
								];

								(*return the resolved FlowRate profiles, evaporation times, and bath fluids*)
								{flowRates, times}
							],


							(* -- Otherwise, the TubeDryer is selected -- *)
							{resFRP, resTime} = Module[{flowRates, times},
								(* Approximate evpaoration rate for water at 60 C and 3L/min gas flow*)
								nitrogenEvapRate = 2.5` * Milliliter / Hour;

								(* Resolve the flow rate and EvaporationTimes *)
								If[
									(* The user specified a FRP *)
									MatchQ[flowRateProfile, Except[Automatic | {Automatic} | {Automatic, Automatic} | {}]],
									If[
										(* The user specified 1, 2, or 3 FlowRateProfiles *)
										LessEqual[Length[flowRateProfile], 3],
										flowRates = Convert[flowRateProfile, {Liter / Minute, Minute}],

										(* Otherwise, they specified >3 FlowRateProfiles which the instrument cannot handle, so throw an error*)
										flowRateProfileWarning = True; flowRates = flowRateProfile
									];

									(* Resolve the EvaporationTime*)
									times = If[
										MatchQ[evapTime, Except[Automatic | Null]],
										evapTime,
										Replace[evapTime, Automatic -> Plus @@ flowRates[[All, 2]]]
									];

									(* To avoid sample splashing, check to see if all flow rates are reasonably low for the sample volume in the container. Generally, the sample volume should be < 0.8*Container Max volume *)
									(* We will only check the first flow rate provided, as over the evaporation run, the sample volume will decrease*)
									highFlowRateWarning = If[
										And[
											GreaterEqual[mySampVol, 0.6 * evapContainerMaxVol],
											Greater[flowRates[[1, 1]], 3 Liter / Minute]
										],
										True,
										False
									];

									(*Check to see if the Flow Rates are all less than 5.5L/min*)
									impossibleFlowRate = Which[
										(* If container model is has a max volume less than 15 mL (or we need to aliquot into a container of this size), we will need to use a 48-position rack, which can support flow rates 0-3.5L/min*)
										LessEqual[evapContainerMaxVol, 15 * Milliliter],
										If[Or @@ (Greater[#, 3.5` Liter / Minute]& /@ flowRates[[All, 1]]),
											True,
											False
										],

										(* If container model is between 15-50 mL (or we need to aliquot into a container of this size), we will need to use a 24-position rack, which can support flow rates 0-5.5L/min*)
										LessEqual[evapContainerMaxVol, 50 * Milliliter] && GreaterEqual[evapContainerMaxVol, 15 * Milliliter],
										If[Or @@ (Greater[#, 5.5` Liter / Minute]& /@ flowRates[[All, 1]]),
											True,
											False
										],

										True,
										False
									],

									(* Otherwise, the user did not specify a FRP *)
									(* First, resolve the evaporation time *)
									times = If[MatchQ[evapTime, TimeP],
										(*User specified a time so use that value*)
										evapTime,

										(* Otherwise automatically resolve *)
										Replace[evapTime, Automatic -> SafeRound[Min[48 * Hour, mySampVol / (nitrogenEvapRate)], 1 Minute]]
									];

									(*Then, resolve the FRPs *)
									flowRates = If[
										GreaterEqual[mySampVol, 0.6 * evapContainerMaxVol],
										{{1.0` Liter / Minute, Convert[(times / 2), Minute]}, {2.5` Liter / Minute, Convert[(times / 2), Minute]}},
										{{2.0` Liter / Minute, Convert[(times / 2), Minute]}, {3.5` Liter / Minute, Convert[(times / 2), Minute]}}
									]
								];


								(*return the values for the flowrate, evaporation time, and bath fluid*)
								{flowRates, times}
							]
						];

						(* Check to see if the provided evapTime is the same as the duration specified in the FlowRateProfile *)
						flowRateEvapTimeConflictWarning = If[
							!MatchQ[SafeRound[Convert[resTime, Minute], 10 Minute], SafeRound[Plus @@ resFRP[[All, 2]], 10 Minute]],
							True,
							False
						];

						(* Default EvaporationTemperature. We always want it to be below the SolventBoilingPoint *)
						resTemp = Replace[evapTemp, {Automatic -> SafeRound[resBoilingPointToTemp - 10 Celsius, 1 Celsius], Ambient -> $AmbientTemperature}];

						(* Default EquilibrationTime *)
						resTempEquil = Replace[equilibrationTime, Automatic -> 5 * Minute];

						(* Default PresureRampTime to Null unless a User has provided a value. We'll generate a warning for that later *)
						resRampTime = Replace[rampTime, Automatic -> Null];

						(* Default EvaporationPressure to Null unless a User has provided a value. We'll generate a warning for that later *)
						resPressure = Replace[evapPressure, Automatic -> Null];

						(* Default RotationRate to Null unless a User has provided a value. We'll generate a warning for that later *)
						resRotationRate = Replace[rotationRate, Automatic -> Null];

						(* Pick out any options that apply to a non-nitrogen blowing evaporation type that are NOT Automatic|Null	*)
						optionConflicts = PickList[
							Join[speedVacExclusiveOptions, rotoVapExclusiveOptions],
							Join[speedVacOptionVals, rotovapOptionVals],
							Except[Automatic | Null | False]
						];

						(* Determine if we need to throw a warning below for this sample pool*)
						nitrogenAmbiguousWarning = !MatchQ[optionConflicts, {}];

						(* Default any options that are still automatic to Null. Leave user values untouched *)
						defaultedUnnecessaryOptions = Replace[#, Automatic -> Null]& /@ Join[speedVacOptionVals, rotovapOptionVals];

						(* Return all the defualted options*)
						{
							resInst,
							resTemp,
							resTempEquil,
							resRampTime,
							resTime,
							resPressure,
							resRotationRate,
							Sequence @@ defaultedUnnecessaryOptions[[1;;3]],
							Sequence @@ defaultedUnnecessaryOptions[[4;;]],
							resFRP,
							optionConflicts,
							noVaporPressure
						}
					],

					(* If for some reason we didn't find a type, just table Null *)
					_,
					Table[
						Null,
						Length[{
							resolvedEvapInstrument,
							resolvedEvapTemp,
							resolvedEquilibrationTime,
							resolvedRampTime,
							resolvedEvapTime,
							resolvedEvapPressure,
							resolvedRotationRate,
							resolvedVacEvapMethod,
							resolvedBump,
							resolvedBalancingSolution,
							resolvedEvapFlask,
							resolvedCondenserTemp,
							resolvedRecoupTrap,
							resolvedRecoupTrapSolution,
							resolvedRecoupTrapVolume,
							resolvedRecoupTrapContainer,
							resolvedRecoupCondensate,
							resolvedCondensateSampleContainer,
							resolvedFlowRateProfile,
							typeOptionConflicts,
							(* these are the NoVaporPressure error *)
							False
						}]]
				];

				(* Yes this line is that dumb, but I want to conserve variable naming convention *)
				resolvedEvapUntilDry = evapUntilDry;

				(* If MaxEvapTime was specified use that (we'll error check later *)
				resolvedMaxEvapTime = If[MatchQ[maxEvapTime, TimeP],

					maxEvapTime,

					(* Otherwise check if evap until dry is specified *)
					If[resolvedEvapUntilDry,

						(* Then default Automatic -> 3x evap time and include ramp time IF SpeedVac or RotoVap *)
						If[MatchQ[resolvedType, SpeedVac | RotaryEvaporation],
							Replace[maxEvapTime, Automatic -> 3 * (resolvedEvapTime + resolvedRampTime)],
							Replace[maxEvapTime, Automatic -> 3 * (resolvedEvapTime)]
						],

						(* Otherwise we're not continuously evaporating so just make it equal to evap time and include ramp time IF SpeedVac or RotoVap *)
						If[MatchQ[resolvedType, SpeedVac | RotaryEvaporation],
							Replace[maxEvapTime, Automatic -> (resolvedEvapTime + resolvedRampTime)],
							Replace[maxEvapTime, Automatic -> (resolvedEvapTime)]
						]
					]
				];

				(*Get the container information for the sample. If it is pooled, used the pooled container. *)
				containerModelObj = If[
					MatchQ[Length[myContainerModel], 1],
					First[Lookup[myContainerModel, Object]],
					Lookup[myPoolContainer, Object]
				];

				(* Check to see if the smaple container can fit in at least one of the available turbovap racks *)
				sampleInTurboCompatibleContainer = ContainsAny[CompatibleFootprintQ[allTurbovapRacks, containerModelObj, ExactMatch -> False], {True}];

				(* Check to see if we are using the TurboVap AND the sample is in a compatible container.  *)
				(* For now this is only for the TurboVap Tube Dryer Instrument *)
				incompatibleContainer = If[
					And[
						(* We are using the TurboVap*)
						MatchQ[resolvedEvapInstrument, Alternatives[ObjectP[{Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"], Object[Instrument, Evaporator, "id:kEJ9mqRxKARz"]}]]],
						(* The sample is not in a compatible container *)
						MatchQ[sampleInTurboCompatibleContainer, False]
					],
					True,

					(*Otherwise, we are not using the TubeDryer or the sample is in a compatible container*)
					False
				];

				(* Check to see if BoilingPoint is below evaporation temperature *)
				evapTempTooHigh = If[
					Greater[resolvedEvapTemp, Min[resBoilingPointToTemp]],
					True,
					False
				];

				(* Gather MapThread results *)
				{
					(* Resolved Option Values*)
					(*1*)resolvedType,
					(*2*)resolvedEvapInstrument,
					(*3*)resolvedEvapTemp,
					(*4*)resolvedEquilibrationTime,
					(*5*)resolvedRampTime,
					(*6*)resolvedEvapTime,
					(*7*)resolvedEvapPressure,
					(*8*)resolvedBoilingPoint,
					(*9*)resolvedRotationRate,
					(*10*)resolvedVacEvapMethod,
					(*11*)resolvedBump,
					(*12*)resolvedBalancingSolution,
					(*13*)resolvedEvapFlask,
					(*14*)resolvedCondenserTemp,
					(*17*)resolvedRecoupTrap,
					(*18*)resolvedRecoupTrapSolution,
					(*19*)resolvedRecoupTrapVolume,
					(*20*)resolvedRecoupTrapContainer,
					(*23a*)resolvedRecoupCondensate,
					(*24a*)resolvedCondensateSampleContainer,
					(*23b*)resolvedFlowRateProfile,
					(*24b*)resolvedEvapUntilDry,
					(*25*)resolvedMaxEvapTime,
					(*26*)resolvedEvapContainer,
					(*27*)typeOptionConflicts,
					(* Resolved Error Bools *)
					(*28*)insufficientVolumeError,
					(*29*)sampleVolumeTooLargeError,
					(*30*)primaryEvaporationContainerConflictError,
					(*31*)nitrogenAmbiguousWarning,
					(*32*)rotovapAmbiguousWarning,
					(*33*)speedVacAmbiguousWarning,
					(*34*)rinseSolutionVolumeError,
					(*35*)bumpTrapRinseSolutionVolumeError,
					(*36*)bumpMethodConflictWarning,
					(*37*)impossibleEvapTempError,
					(*38*)flowRateProfileWarning,
					(*39*)flowRateEvapTimeConflictWarning,
					(*40*)highFlowRateWarning,
					(*41*)impossibleFlowRate,
					(*42*)evapTempTooHigh,
					(*43*)incompatibleContainer,
					(*44*)noVaporPressureError
				}
			]
		],

		(* MapThread over our index-matched lists *)
		{mapThreadFriendlyOptions, pooledSamplePackets, poolVolumes, pooledSampleComponentPackets, pooledSampleContainerModelPackets, poolContainerPackets, mapThreadFriendlyPrepOptions}
	];

	(* Pull Email, Upload and Name options from the expanded Options *)
	{emailOption, uploadOption, nameOption} = Lookup[roundedEvaporationOptions, {Email, Upload, Name}];

	(* Resolve Email option *)
	resolvedEmail = If[!MatchQ[emailOption, Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* - Validate the Name option - *)

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameValidBool = TrueQ[DatabaseMemberQ[Append[Object[Protocol, VacuumEvaporation], nameOption]]];

	(* If the name is invalid, will add it to the list if invalid options later *)
	nameOptionInvalid = If[nameValidBool,
		Name,
		Nothing
	];

	nameUniquenessTest = If[nameValidBool,

		(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.", False, True],
			Message[Error::DuplicateName, Object[Protocol, VacuumEvaporation]];
			Nothing
		],

		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[nameOption],
			Test["The specified name is unique.", False, True],
			Nothing
		]
	];


	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve TargetContainers and TargetSampleGroupings *)

	(* --- Errors --- *)

	(* TODO: fill this out for bump conflict warnings
	(* Give a failing warning or throw a message if the user told us that the sample is likely to bump but selected a method that does not have controlled chamber evacuation*)
	Switch[{gatherTests, $ECLApplication},
		{True, _}, Warning["Bump was specified as True but a Method that does not have Controlled Chamber Evacuation was specified:",False,True],
		{_, Except[Engine]}, (Message[Warning::SampleMayBump]; Nothing),
		{_, _}, Nothing
	],

	(* Give a passing warning or do nothing otherwise *)
	If[gatherTests,
		Warning["The specified Bump option agrees with the specified Method option:",True,True],
		Nothing
	]
	*)

	(* throw a message if a pulse sequence is directly specified *)
	If[MemberQ[impossibleEvapTempErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::SpeedVacTemperature, ObjectToString[PickList[simulatedSamples, impossibleEvapTempErrors], Cache -> simulatedCache]]
	];

	(* generate the PulseSequenceSpecified warnings *)
	impossibleEvapTempErrorsTests = If[gatherTests,
		Module[{failingSamples, failingInstruments, passingSamples, passingInstruments, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, impossibleEvapTempErrors];
			failingInstruments = PickList[resolvedEvapInstruments, impossibleEvapTempErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, impossibleEvapTempErrors, False];
			passingInstruments = PickList[resolvedEvapInstruments, impossibleEvapTempErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", an evaporation temperature was provided that was within the instruments "<>ObjectToString[failingInstruments, Cache -> simulatedCache]<>"possible temperature range:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", an evaporation temperature was provided that was within the instruments "<>ObjectToString[passingInstruments, Cache -> simulatedCache]<>"possible temperature range:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	impossibleEvapTempOptions = If[MemberQ[impossibleEvapTempErrors, True],
		{EvaporationTemperature},
		Nothing
	];

	(* throw a message if the specified Evaporationflask is too small or does not have the proper connection joint *)
	If[MemberQ[primaryEvaporationContainerConflictErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::EvaporateEvapFlaskIncompatible, PickList[resolvedEvapFlasks, primaryEvaporationContainerConflictErrors], ObjectToString[PickList[simulatedSamples, primaryEvaporationContainerConflictErrors], Cache -> simulatedCache]]
	];

	(* generate the error *)
	primaryEvaporationContainerConflictTests = If[gatherTests,
		Module[{failingSamples, failingFlasks, passingSamples, passingFlasks, passingSampleTests, failingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, primaryEvaporationContainerConflictErrors];
			failingFlasks = PickList[resolvedEvapFlasks, primaryEvaporationContainerConflictErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, primaryEvaporationContainerConflictErrors, False];
			passingFlasks = PickList[resolvedEvapFlasks, primaryEvaporationContainerConflictErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", an EvaporationFlask, "<>ObjectToString[failingFlasks, Cache -> simulatedCache]<>" was provided that has a MaxVolume at least 2x tha of the sample volume and has a 24/40 connector:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", an EvaporationFlask, "<>ObjectToString[passingFlasks, Cache -> simulatedCache]<>" was provided that has a MaxVolume at least 2x tha of the sample volume and has a 24/40 connector:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	primaryEvaporationContainerConflictOptions = If[MemberQ[primaryEvaporationContainerConflictErrors, True],
		{EvaporationFlask},
		Nothing
	];


	(* throw a warning message if more FRPs are specified than allowed by the instrument  *)
	If[MemberQ[flowRateProfileWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::FlowRateProfileLength, ObjectToString[PickList[simulatedSamples, flowRateProfileWarnings], Cache -> simulatedCache]]
	];

	(* -- generate the flowRateProfileTests warnings -- *)
	flowRateProfileWarningTests = If[gatherTests,
		Module[{failingSamples, failingInstruments, passingSamples, passingInstruments, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, flowRateProfileWarnings];
			failingInstruments = PickList[resolvedEvapInstruments, flowRateProfileWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, flowRateProfileWarnings, False];
			passingInstruments = PickList[resolvedEvapInstruments, flowRateProfileWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the number of FlowRate Profiles specified for "<>ObjectToString[failingInstruments, Cache -> simulatedCache]<>"is greater than the instrument's programmable capabilitites:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the number of FlowRate Profiles specified for "<>ObjectToString[passingInstruments, Cache -> simulatedCache]<>"is within the instrument's programmable capabilitites:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	flowRateProfileWarningOptions = If[MemberQ[flowRateProfileWarnings, True],
		{FlowRateProfile},
		Nothing
	];

	(* throw a warning message if the provided Flow Rate may result in sample splashing *)
	If[MemberQ[highFlowRateWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::HighFlowRate, ObjectToString[PickList[simulatedSamples, highFlowRateWarnings], Cache -> simulatedCache]]
	];

	(* -- generate the HighFlowRate warnings tests -- *)
	highFlowRateWarningTests = If[gatherTests,
		Module[{failingSamples, failingFRPs, passingSamples, passingFRPs, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, highFlowRateWarnings];
			failingFRPs = PickList[resolvedFlowRateProfiles, highFlowRateWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, highFlowRateWarnings, False];
			passingFRPs = PickList[resolvedFlowRateProfiles, highFlowRateWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the specified FlowRate"<>ObjectToString[failingFRPs, Cache -> simulatedCache]<>"is high and may result in sample splashing and contamination:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the specified FlowRate"<>ObjectToString[passingFRPs, Cache -> simulatedCache]<>"is low engough to prevent sample splashing and contamination:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	highFlowRateWarningOptions = If[MemberQ[highFlowRateWarnings, True],
		{FlowRateProfile},
		Nothing
	];

	(* -- throw an error message if the total duration specified in the flow rate profile is different from the specified EvaporationTime -- *)
	If[MemberQ[flowRateEvapTimeConflictWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::EvaporationFlowRateProfileTimeConflict, PickList[resolvedFlowRateProfiles, flowRateEvapTimeConflictWarnings], ObjectToString[PickList[simulatedSamples, flowRateEvapTimeConflictWarnings], Cache -> simulatedCache], PickList[resolvedEvapTimes, flowRateEvapTimeConflictWarnings]]
	];

	(* generate the HighFlowRate warnings tests *)
	flowRateEvapTimeConflictTests = If[gatherTests,
		Module[{failingSamples, failingFRPs, passingSamples, passingFRPs, failingSampleTests, passingSampleTests, failingEvapTimes, passingEvapTimes},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, flowRateEvapTimeConflictWarnings];
			failingFRPs = PickList[resolvedFlowRateProfiles, flowRateEvapTimeConflictWarnings];
			failingEvapTimes = PickList[resolvedEvapTimes, flowRateEvapTimeConflictWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, flowRateEvapTimeConflictWarnings, False];
			passingFRPs = PickList[resolvedFlowRateProfiles, flowRateEvapTimeConflictWarnings, False];
			passingEvapTimes = PickList[resolvedEvapTimes, flowRateEvapTimeConflictWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the sum of all the specified durations in the FlowRateProfile"<>ObjectToString[failingFRPs, Cache -> simulatedCache]<>"conflicts with the EvaporationTime,"<>ObjectToString[failingEvapTimes, Cache -> simulatedCache]<>":",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the sum of all the specified durations in the FlowRateProfile"<>ObjectToString[passingFRPs, Cache -> simulatedCache]<>"agrees with the EvaporationTime,"<>ObjectToString[passingEvapTimes, Cache -> simulatedCache]<>":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	flowRateEvapTimeConflictOptions = If[MemberQ[flowRateEvapTimeConflictWarnings, True],
		{FlowRateProfile, EvaporationTime},
		Nothing
	];

	(*-- throw an error message if the EvaporationTemperature is greater than the resolved Boiling Point  --*)
	If[MemberQ[evapTempTooHighWarnings, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::EvaporateTemperatureGreaterThanSampleBoilingPoint, ObjectToString[PickList[simulatedSamples, evapTempTooHighWarnings], Cache -> simulatedCache], PickList[resolvedBoilingPoints, evapTempTooHighWarnings]]
	];

	(* generate the impossibleFlowRate warnings tests *)
	evapTempTooHighTests = If[gatherTests,
		Module[{failingSamples, failingEvapTemps, passingSamples, passingEvapTemps, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, evapTempTooHighWarnings];
			failingEvapTemps = PickList[resolvedEvapTemps, evapTempTooHighWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, evapTempTooHighWarnings, False];
			passingEvapTemps = PickList[resolvedEvapTemps, evapTempTooHighWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the specified EvaporationTemperature"<>ObjectToString[failingEvapTemps, Cache -> simulatedCache]<>"is greater than the resolved sample boiling point:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the specified EvaporationTemperature"<>ObjectToString[passingEvapTemps, Cache -> simulatedCache]<>"is less than the resolved sample boiling point:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	bumpTrapRinseSolutionConflictOptions = If[MemberQ[bumpTrapRinseSolutionVolumeErrors, True],
		{BumpTrapRinseVolume, BumpTrapSampleContainer},
		Nothing
	];

	(*-- throw an error message if the EvaporationTemperature is greater than the resolved Boiling Point  --*)
	If[MemberQ[bumpTrapRinseSolutionVolumeErrors, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::IncompatibleBumpTrapVolume, ObjectToString[PickList[simulatedSamples, bumpTrapRinseSolutionVolumeErrors], Cache -> simulatedCache], PickList[resolvedRecoupTrapVolumes, bumpTrapRinseSolutionVolumeErrors]]
	];

	(* generate the impossibleFlowRate warnings tests *)
	bumpTrapRinseSolutionVolumeTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, bumpTrapRinseSolutionVolumeErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, bumpTrapRinseSolutionVolumeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the specified BumpTrapRinseVolume is greater than the MaxVolume of the BumpTrapSampleContainer:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the specified BumpTrapRinseVolume is less than the MaxVolume of the BumpTrapSampleContainer:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Stash the failing options related to this error *)
	evapTempTooHighOptions = If[MemberQ[evapTempTooHighWarnings, True],
		{EvaporationTemperature},
		Nothing
	];

	(*-- throw an error message if the flow rate is greater the TurboVap's max  --*)
	If[MemberQ[impossibleFlowRates, True] && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::TurboVapFlowRate, PickList[resolvedFlowRateProfiles, impossibleFlowRates], ObjectToString[PickList[simulatedSamples, impossibleFlowRates], Cache -> simulatedCache]]
	];


	(* generate the impossibleFlowRate warnings tests *)
	impossibleFlowRatesTests = If[gatherTests,
		Module[{failingSamples, failingFRPs, passingSamples, passingFRPs, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, impossibleFlowRates];
			failingFRPs = PickList[resolvedFlowRateProfiles, impossibleFlowRates];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, impossibleFlowRates, False];
			passingFRPs = PickList[resolvedFlowRateProfiles, impossibleFlowRates, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", the specified FlowRate"<>ObjectToString[failingFRPs, Cache -> simulatedCache]<>"is beyond the instrument's capabilities:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", the specified FlowRate"<>ObjectToString[passingFRPs, Cache -> simulatedCache]<>"is within the instrument's capabilities:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Stash the failing options related to this error *)
	impossibleFlowRatesTestsOptions = If[MemberQ[impossibleFlowRates, True],
		{FlowRateProfile},
		Nothing
	];

	(*--Throw an error message if we're doing rotovap, EvaporationPressure is not set, and we can't figure out the vapor pressure of the sample--*)
	evaporationPressureRequiredOptions = If[Not[gatherTests] && MemberQ[noVaporPressureErrors, True],
		(
			Message[Error::CannotComputeEvaporationPressure, ObjectToString[PickList[simulatedSamples, noVaporPressureErrors], Cache -> simulatedCache], PickList[resolvedEvapTemps, noVaporPressureErrors]];
			{EvaporationPressure}
		),
		{}
	];
	evaporationPressureRequiredTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, noVaporPressureErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, noVaporPressureErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[failingSamples, Cache -> simulatedCache]<>", if using RotaryEvaporation, EvaporationPressure is set, or can be computed from the VaporPressure of the samples' Compositions:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples "<>ObjectToString[passingSamples, Cache -> simulatedCache]<>", if using RotaryEvaporation, EvaporationPressure is set, or can be computed from the VaporPressure of the samples' Compositions:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Extract shared options relevant for aliquotting *)
	aliquotOptions = KeySelect[samplePrepOptions, And[MatchQ[#, Alternatives @@ ToExpression[Options[AliquotOptions][[All, 1]]]], MemberQ[Keys[samplePrepOptions], #]]&];
	(* Aliquot options for the TurboVap *)
	{targetContainers, targetVolumes} = Module[{suppliedAliquotBools, suppliedAliquotContainers,
		suppliedAliquotVolumes, targetAliquotContainers,
		aliquotVolumes, incompatibleContainerBools, preresolvedAliquotBools},

		(* Extract list of bools *)
		suppliedAliquotBools = Lookup[aliquotOptions, Aliquot];

		(* Extract list of supplied aliquot containers *)
		suppliedAliquotContainers = Lookup[aliquotOptions, AliquotContainer];

		(* Extract list of supplied aliquot volumes *)
		suppliedAliquotVolumes = Lookup[aliquotOptions, AliquotAmount];

		(* If the sample's container model is not compatible with the instrument, we may have to aliquot. *)
		(*For now, this test only applies to the TurboVap, which can only take tubes*)
		incompatibleContainerBools = incompatibleContainers;

		(*Set aliquot to True if not explicitly specified and we encounter an incompatible container *)
		preresolvedAliquotBools = MapThread[
			Function[{incompatibleContainer, suppliedAliquotBool},
				If[
					Or[incompatibleContainer, MatchQ[suppliedAliquotBool, True]],
					True,
					False
				]
			],
			{incompatibleContainerBools, suppliedAliquotBools}
		];

		(*If aliquot options are supplied, use those, otherwise resolve for Tube Dryer*)
		targetAliquotContainers = MapThread[
			Function[{preresolvedAliquotBool, suppliedAliquotContainer, sampleVolPacket},
				Which[
					(* If aliquoting and user specified a container, use that *)
					MatchQ[preresolvedAliquotBool, True] && MatchQ[suppliedAliquotContainer, Except[Automatic | Null]],
					suppliedAliquotContainer,

					(* If aliquoting and no container is specified, resolve based on sample volume*)
					MatchQ[preresolvedAliquotBool, True] && MatchQ[suppliedAliquotContainer, Alternatives[Automatic | Null]],
					Which[
						(* If sampleVolume < 1.7 mL, then set as  the 2mL tube*)
						Min[Lookup[sampleVolPacket, Volume]] <= 0.8 * 1.7Milliliter,
						Model[Container, Vessel, "2mL Tube"],

						(* If sampleVolume > 1.7 mL and < 15 mL, then set as  the 15mL tube*)
						Min[Lookup[sampleVolPacket, Volume]] > 0.8 * 1.7Milliliter && Min[Lookup[sampleVolPacket, Volume]] <= 0.8 * 15Milliliter,
						Model[Container, Vessel, "15mL Tube"],

						(* If sampleVolume > 15 mL, then set as  the 50mL tube*)
						True,
						Model[Container, Vessel, "50mL Tube"]
					],

					(*Otherwhise, set this to Null since sample is in correct container *)
					True,
					Null
				]
			],
			{preresolvedAliquotBools, suppliedAliquotContainers, pooledSamplePackets}
		];

		(* If we end up aliquoting and AliquotAmount is not specified, determine an aliquot amount. *)
		aliquotVolumes = MapThread[
			Function[
				{targetAliquotContainer, suppliedAliquotVolume, sampleVolPacket},
				Which[
					(* Target container is not null, meaning we are aliquoting, and an aliquot volume is specified, so use the specified volume *)
					MatchQ[targetAliquotContainer, ObjectP[]] && MatchQ[suppliedAliquotVolume, Except[Null | Automatic | {Automatic..}]],
					suppliedAliquotVolume,

					(* Target container is not null, meaning we are aliquoting, but an aliquot volume is NOT specified, so we resolve based on sample volume *)
					MatchQ[targetAliquotContainer, ObjectP[]] && MatchQ[suppliedAliquotVolume, Alternatives[Null | Automatic]],
					(*Set aliquot volume to the lesser of the sample volume or 0.8*MaxVolume of the vesssel *)
					Min[0.8 * targetAliquotContainer[MaxVolume], Min[Lookup[sampleVolPacket, Volume]]],

					(*Otherwise, sample is in the correct container, so set this as null*)
					True,
					Null
				]
			],
			{targetAliquotContainers, suppliedAliquotVolumes, pooledSamplePackets}
		];

		(*Return the targetAliquotContainers and aliquot volumes *)
		{targetAliquotContainers, aliquotVolumes}
	];

	aliquotWarningMsg = "because the given samples are not in containers that are compatible with the evaporation instrument:";

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot = First[splitPrepOptions[resolvedSamplePrepOptions, PrepOptionSets -> {IncubatePrepOptionsNew, CentrifugePrepOptionsNew, FilterPrepOptionsNew}]];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentEvaporate,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, resolveSamplePrepOptionsWithoutAliquot],
			RequiredAliquotAmounts -> RoundOptionPrecision[targetVolumes, 0.1 Microliter],
			AliquotWarningMessage -> aliquotWarningMsg,
			RequiredAliquotContainers -> targetContainers,
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cache,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentEvaporate,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, resolveSamplePrepOptionsWithoutAliquot],
				RequiredAliquotAmounts -> RoundOptionPrecision[targetVolumes, 0.1 Microliter],
				AliquotWarningMessage -> aliquotWarningMsg,
				RequiredAliquotContainers -> targetContainers,
				AllowSolids -> True,
				MinimizeTransfers -> True,
				Cache -> cache,
				Simulation -> updatedSimulation,
				Output -> Result
			],
			{}
		}
	];

	{samplesInStorage, samplesOutStorage} = Lookup[myOptions, {SamplesInStorageCondition, SamplesOutStorageCondition}];

	(* since we have a pooled system here, we need to do some quasi-expansion so that it is the same length as the flattened pooled samples *)
	quasiExpandedSamplesInStorage = If[ListQ[samplesInStorage],
		Flatten[MapThread[
			If[ListQ[#2],
				ConstantArray[#1, Length[#2]],
				#1
			]&,
			{samplesInStorage, mySamples}
		]],
		ConstantArray[samplesInStorage, Length[Flatten[mySamples]]]
	];

	validSampleStorageConditionQ = If[!MatchQ[quasiExpandedSamplesInStorage, ListableP[Automatic | Null]],
		If[!gatherTests && Not[MatchQ[$ECLApplication, Engine]],
			ValidContainerStorageConditionQ[Flatten[mySamples], quasiExpandedSamplesInStorage, Simulation -> updatedSimulation],
			Quiet[ValidContainerStorageConditionQ[Flatten[mySamples], quasiExpandedSamplesInStorage, Simulation -> updatedSimulation]]
		],
		True
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions = If[Not[And @@ validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(* generate test for storage condition *)
	invalidStorageConditionTest = Test[
		"The specified SamplesInStorageCondition can be filled for sample in a particular container or for samples sharing a container:",
		And @@ validSampleStorageConditionQ,
		True
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, noVolumeInvalidInputs, duplicatedInvalidInputs}]];
	invalidOptions = DeleteDuplicates[Flatten[{
		nameOptionInvalid,
		impossibleEvapTempOptions,
		flowRateEvapTimeConflictOptions,
		impossibleFlowRatesTestsOptions,
		flowRateProfileWarningOptions,
		primaryEvaporationContainerConflictOptions,
		invalidStorageConditionOptions,
		evaporationPressureRequiredOptions,
		bumpTrapRinseSolutionConflictOptions
	}]];

	allTests = Flatten[{
		samplePrepTests,
		discardedTest,
		noVolumeTest,
		duplicatesTest,
		optionPrecisionTests,
		flowRateProfileWarningTests,
		highFlowRateWarningTests,
		flowRateEvapTimeConflictTests,
		evapTempTooHighTests,
		impossibleFlowRatesTests,
		primaryEvaporationContainerConflictTests,
		invalidStorageConditionTest,
		evaporationPressureRequiredTests,
		bumpTrapRinseSolutionVolumeTests
	}];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> ReplaceRule[Normal[roundedEvaporationOptions],
			Join[
				{
					EvaporationType -> resolvedTypes,
					Instrument -> resolvedEvapInstruments,
					EvaporationTemperature -> resolvedEvapTemps,
					EquilibrationTime -> resolvedEquilibrationTimes,
					PressureRampTime -> resolvedRampTimes,
					EvaporationTime -> resolvedEvapTimes,
					MaxEvaporationTime -> resolvedMaxEvapTimes,
					EvaporateUntilDry -> resolvedEvapUntilDrys,
					EvaporationPressure -> resolvedEvapPressures,
					RotationRate -> resolvedRotationRates,
					VacuumEvaporationMethod -> resolvedVacEvapMethods,
					BumpProtection -> resolvedBumps,
					BalancingSolution -> resolvedBalancingSolutions,
					EvaporationFlask -> resolvedEvapFlasks,
					CondenserTemperature -> resolvedCondenserTemps,
					RecoupBumpTrap -> resolvedRecoupTraps,
					BumpTrapRinseSolution -> resolvedRecoupTrapSolutions,
					BumpTrapRinseVolume -> resolvedRecoupTrapVolumes,
					BumpTrapSampleContainer -> resolvedRecoupTrapContainers,
					RecoupCondensate -> resolvedRecoupCondensates,
					CondensateSampleContainer -> resolvedCondensateSampleContainers,
					FlowRateProfile -> resolvedFlowRateProfiles,
					SolventBoilingPoints -> resolvedBoilingPoints,
					Email -> resolvedEmail,
					SamplesInStorageCondition -> samplesInStorage,
					SamplesOutStorageCondition -> samplesOutStorage
				},
				resolveSamplePrepOptionsWithoutAliquot,
				resolvedAliquotOptions,
				resolvedPostProcessingOptions
			]
		],
		Tests -> allTests
	}
];




(* ::Subsubsection:: *)
(* evaporateResourcePackets (private helper)*)


DefineOptions[evaporateResourcePackets,
	Options :> {SimulationOption, CacheOption, HelperOutputOption}
];


evaporateResourcePackets[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}], myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myOptions:OptionsPattern[]] := Module[
	{outputSpecification, output, gatherTests, messages, upload, cache, poolLengths, expandedInputs, expandedResolvedOptions,
		resolvedOptionsNoHidden, evapTypes,
		sampleVolumesToReserve, simulatedSamples, simulatedCache, fastAssocSimulatedCache,
		sampleResourceReplaceRules, expPooledSamplesIn,
		samplesInResources, containersIn, estimatedRunTimes, instruments,
		balanceResources,
		simulatedContainers,
		simulatedModelContainers,
		pooledContainerModel,
		pooledContainerModelCleaned,
		workingModelContainers,
		simulatedWorkingContainers,
		maxTotalRunTimeEstimate, containerVacCentCompat, finalContainerVacCentCompat,

		aliquotQs,
		aliquotVols,
		intAliquotContainers,
		aliquotContainers,

		vacEvapMethods,

		weightVerificationTime,

		evapUntilDryVals, maxEvapTimes, tempEquilTimes, rampTimes, evapTimes, evapTemps,
		rinseSolutionObjVolPairs,
		groupedSolventVolPairs,
		uniqueSolventVolRequiredPairs,
		rinseSolutionResourceMap,
		trapRinseSolutionResources,
		bumpTrapSampleContainers, condensateRecoveryContainers,
		evaporationContainerResources,
		bumpTrapResources, allBumpTrapPacks,
		condensationFlaskResources, containerPacks, rotoVapContainerPacketsWithBallJoint, rotoRoundContainerPackets, turboRackPackets,
		condensationFlaskClampResource, evaporationFlaskClampResource,
		centRacksOnly,
		groupedBatches,
		evapParams,
		placeHolderInstResources,
		batchContainerLengths,
		batchSampleLengths,
		balances,

		bathFluidResources,
		cleanedEvapParams,

		batchedCounterWeights,
		batchedCentrifugeTubeRacks,
		batchedSpeedVacBuckets,
		batchedConnections,
		batchedConnectionLengths,

		unsortedInstrument,
		instrumentModel,

		batchedNitrogenTubeRacks,
		nozzlePlugs,
		drainTube,
		funnelResource,
		wasteContainerResource,

		simulateSamplesToPooledSamplesLookup,
		finalContainerIndexes,
		finalSampleIndexes,
		evapParamsRaw, evapParamsWithBath,

		protocolPacket, sharedFieldPacket, finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule,
		optionsRule, testsRule, resultRule, flowRateLookup, flowRateReformat,

		evapParamsTypes, evapParamsMaxEvapTimes, evapParamsTempEquilTimes, evapParamsRampTimes, evapParamsEvapTimes,
		expSubdivide, evapPressureProfileImageCloudFiles, updatedSimulation, simulation
	},

	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* lookup the cache *)
	cache = Lookup[ToList[myOptions], Cache, {}];
	simulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	(* lookup the upload option *)
	upload = Lookup[myResolvedOptions, Upload];

	(* determine the pool lengths*)
	poolLengths = Map[Length[ToList[#]]&, myPooledSamples];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentEvaporate, {myPooledSamples}, myResolvedOptions];

	(* Generate the list of pooled samples *)
	expPooledSamplesIn = TakeList[Flatten[expandedInputs], poolLengths];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentEvaporate, myPooledSamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* generate a fast cache association *)
	simulatedCache = FlattenCachePackets[{cache, Lookup[First[updatedSimulation], Packets]}];
	fastAssocSimulatedCache = makeFastAssocFromCache[simulatedCache];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentEvaporate,
		RemoveHiddenOptions[ExperimentEvaporate, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* stash the evaporation type *)
	evapTypes = Lookup[myResolvedOptions, EvaporationType];

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotQs = Lookup[myResolvedOptions, Aliquot, Null];

	(* determine if each sample list index has aliquot -> true or not *)
	aliquotVols = Lookup[myResolvedOptions, AliquotAmount, Null];

	(*Get the aliquot containers*)
	intAliquotContainers = Lookup[myResolvedOptions, AliquotContainer, Null];

	(*Extract only the model information of the aliquoted containers *)
	aliquotContainers = If[MatchQ[#, Null], Null, #[[All;2]]]& /@ intAliquotContainers;

	(* get the sample volumes we need to reserve with each sample, accounting for whether we're aliquoting *)
	(* if the samples is NOT getting aliquot, we'll reserve the whole sample without an amount request *)
	sampleVolumesToReserve = Flatten[MapThread[
		Function[{aliquot, volume},
			Which[
				aliquot, volume,
				True, Null
			]
		],
		{aliquotQs, aliquotVols}
	]];

	(* make replace rules for the samples and its resources - if we're aliquotting, we only get the amount that we're using *)
	sampleResourceReplaceRules = MapThread[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
			]
		],
		{
			Flatten[expandedInputs],
			Flatten[sampleVolumesToReserve]
		}
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Flatten[expandedInputs] /. sampleResourceReplaceRules;

	(* Create a list of the simulated containers and to list them so we can transpose down below *)
	simulatedContainers = Map[
		Function[{pool},
			If[MatchQ[pool, _List],
				Download[fastAssocLookup[fastAssocSimulatedCache, #, Container], Object]& /@ pool,
				Download[fastAssocLookup[fastAssocSimulatedCache, pool, Container], Object]
			]
		],
		simulatedSamples
	];

	(* Gather the models of the simulated containers*)
	simulatedModelContainers = Map[
		Function[{pool},
			If[MatchQ[pool, _List],
				Download[fastAssocLookup[fastAssocSimulatedCache, #, Model], Object]& /@ pool,
				Download[fastAssocLookup[fastAssocSimulatedCache, pool, Model], Object]
			]
		],
		simulatedContainers
	];

	(* Gather the information about AliquotContainers too *)
	(*In the case that the samples are pooled, look up what container they are going in.
    Replace any nulls with {Null,Null} to give index and container*)
	pooledContainerModel = Lookup[expandedResolvedOptions, AliquotContainer, Null] /. Null -> {Null, Null};

	(* Get the container models only *)
	pooledContainerModelCleaned = If[NullQ[pooledContainerModel],
		(*If poolecContainerModel is all null, then we are not pooling*)
		Table[Null, Length[ToList[simulatedSamples]]],

		pooledContainerModel[[All, 2]]
	];

	(* Assembly the list of working containers - if aliquoted, go with AliquotContainer; if not, go with Simulated Container *)
	workingModelContainers = MapThread[
		If[MatchQ[#2, ObjectP[Model[Container]]],
			Download[#2, Object],
			#1
		]&,
		{simulatedModelContainers, pooledContainerModelCleaned}
	];

	(* Build an image of what WorkingContainers should look like directly after SamplePrep *)
	(* This is just the DeletedDuplicates (order should be preserved) of the containers of the simulatedSamples *)
	simulatedWorkingContainers = DeleteDuplicates[simulatedContainers];

	(* create the containers in a flat non-duplicate list for the protocol packet *)

	containersIn = DeleteDuplicates[Download[fastAssocLookup[fastAssocSimulatedCache, #, Container], Object]& /@ Flatten[myPooledSamples]];

	(* Stash option values relevant for timing for EvaporateUntilDry *)
	{evapUntilDryVals, maxEvapTimes, tempEquilTimes, rampTimes, evapTimes, vacEvapMethods} = Lookup[
		myResolvedOptions,
		{EvaporateUntilDry, MaxEvaporationTime, EquilibrationTime, PressureRampTime, EvaporationTime, Method}
	];

	(* Stash the evaporation temperature and convert the symbol Ambient to 25*Celsius *)
	evapTemps = ReplaceAll[Lookup[myResolvedOptions, EvaporationTemperature], Ambient -> $AmbientTemperature];

	(* Stash the option values for EvaporateUntilDry *)
	evapUntilDryVals = Lookup[myResolvedOptions, EvaporateUntilDry];

	(* Build pairs of {solution, volumeRequired} for each sample pool's and BumpTrapRinseSolution *)
	rinseSolutionObjVolPairs = DeleteCases[#, {Null, _}]&@Transpose@Lookup[myResolvedOptions, {BumpTrapRinseSolution, BumpTrapRinseVolume}];

	(* Group the {solution, volumeRequired} pairs by the solution *)
	groupedSolventVolPairs = GatherBy[rinseSolutionObjVolPairs, First];

	(* Pull out the solvent and total volume for each pair *)
	uniqueSolventVolRequiredPairs = {First[First[#]], Total[#[[All, 2]]]} & /@ groupedSolventVolPairs;

	(* Generate resources for the rinse solutions required, and combine resources of the same model *)
	rinseSolutionResourceMap = Map[
		Function[
			{rinseSolventVolPair},
			First[rinseSolventVolPair] -> Resource[Sample -> First[rinseSolventVolPair], Amount -> (1.2 * Last[rinseSolventVolPair]), Name -> ToString[Unique[]]]
		],
		uniqueSolventVolRequiredPairs
	];

	(* Build field values for BumpTrapRinseSolution, replacing each value with the required resource*)
	trapRinseSolutionResources = Lookup[myResolvedOptions, BumpTrapRinseSolution] /. rinseSolutionResourceMap;

	(* make resources for the bump trap containers and the condensate containers *)
	(* if they're models never share; if they're objects conceivably you could share if that's what the customer wants *)
	bumpTrapSampleContainers = Map[
		If[NullQ[#],
			Null,
			Resource[Sample -> #, Name -> If[MatchQ[#, ObjectP[Model[Container]]], ToString[Unique[]], ToString[#]]]
		]&,
		Lookup[myResolvedOptions, BumpTrapSampleContainer]
	];
	condensateRecoveryContainers = Map[
		If[NullQ[#],
			Null,
			Resource[Sample -> #, Name -> If[MatchQ[#, ObjectP[Model[Container]]], ToString[Unique[]], ToString[#]]]
		]&,
		Lookup[myResolvedOptions, CondensateSampleContainer]
	];

	(* Determine which instrument we'll use *)
	instruments = Lookup[myResolvedOptions, Instrument];

	(* Figure out how long it will take to verify the weights of the containers and counterweights *)
	(* TODO: Limit this to SpeedVacs *)
	weightVerificationTime = 2 * Length[containersIn] * (2 Minute);

	(* TODO: This gets more complicated because it's 2minutes * number of containers IN THIS BATCH *)
	(* Balance Resource for weighing the samples/buckets *)
	balanceResources = If[MatchQ[#, SpeedVac],
		Resource[
			Instrument -> Model[Instrument, Balance, "id:o1k9jAGvbWMA"],
			Time -> weightVerificationTime
		],
		Null
	]& /@ evapTypes;

	balances = If[MatchQ[#, SpeedVac],
		Model[Instrument, Balance, "id:o1k9jAGvbWMA"],
		Null
	]& /@ evapTypes;

	(* Build resources for balancing solutions *)
	(* TODO: more intelligently account for amount here *)
	(* TODO: Determine if we have to create these resources here *)
	(*balancingSolutionResources = If[!NullQ[#],
		Resource[Sample->#,Amount->1Liter],
		Null
	]&/@Lookup[myResolvedOptions,BalancingSolution];*)

	(* Evaporation flask resources *)
	evaporationContainerResources = If[!NullQ[#], Link@Resource[Sample -> #, Name -> ToString[Unique[]]], Null]& /@ Lookup[myResolvedOptions, EvaporationFlask];

	(* Bump trap resources *)
	(* we currently only have one bump trap. if we add more, select one based on the sample volume*)
	(* Get the info from the cache packet that we need *)
	allBumpTrapPacks = Cases[cache, ObjectP[Model[Container, BumpTrap]]];

	bumpTrapResources = If[
		MatchQ[#1, RotaryEvaporation],
		Link@Resource[Sample -> First[Lookup[allBumpTrapPacks, Object]], Rent -> True, Name -> ToString[Unique[]]],
		Null
	]& /@ Lookup[myResolvedOptions, EvaporationType];

	(* Make resources for the keck clamps *)
	(* Since all of our current BumpTrap, EvaporationFlask are sharing the same size of Taper Joint Size of 24mm, we are going to just request for the same hard-coded model here *)
	evaporationFlaskClampResource = Module[{totalKeckClampsNeeded},
		(* For each RotarayEvaporation that we are doing, we need 2 keck clamps *)
		totalKeckClampsNeeded = 2 * Count[Lookup[myResolvedOptions, EvaporationType], RotaryEvaporation];
		If[TrueQ[GreaterQ[totalKeckClampsNeeded, 0]],
			(*  Replace the named model with ID after db refresh  *)
			Link@Resource[Sample -> Model[Item, Clamp, "Keck Clamps for 24/25, 24/40 Taper Joint"], Amount -> totalKeckClampsNeeded, Rent -> True],
			Null
		]
	];

	(* CondensationFlask resources *)
	containerPacks = Cases[cache, ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]];
	(* Pull out all possible rotovap container packets for condensation flask. We only want connectors with a 35/20 Thread and SphericalGroundGlass for condensation flask *)
	rotoVapContainerPacketsWithBallJoint = Cases[containerPacks, KeyValuePattern[Connectors -> ListableP[{_, SphericalGroundGlass, "35/20", _, _, _}]]];
	rotoRoundContainerPackets = Sort[Cases[rotoVapContainerPacketsWithBallJoint, KeyValuePattern[Name -> _?(StringMatchQ[#, ___~~"Round"~~___] &)]]];

	turboRackPackets = Cases[cache, KeyValuePattern[Footprint -> TurboVapRack]];

	condensationFlaskResources = MapThread[
		Function[{samples, evaType},
			Module[
				{sampleVolumes, totalVolume},
				sampleVolumes = fastAssocLookup[fastAssocSimulatedCache, #, Volume]& /@ ToList[samples];
				totalVolume = Total[sampleVolumes /. {Null -> 0Liter}];
				Which[
					MatchQ[evaType, RotaryEvaporation] && Less[totalVolume, 1.5Liter],
					Link@Resource[Sample -> Lookup[FirstCase[rotoRoundContainerPackets, KeyValuePattern[MaxVolume -> GreaterEqualP[2 Liter]]], Object], Rent -> True, Name -> ToString[Unique[]]], (*2L Round Bottom Flask with 24/40 Joint*)
					MatchQ[evaType, RotaryEvaporation],
					Link@Resource[Sample -> Lookup[FirstCase[rotoRoundContainerPackets, KeyValuePattern[MaxVolume -> GreaterP[2 Liter]]], Object], Rent -> True, Name -> ToString[Unique[]]], (*3L Round Bottom Flask with 24/40 Joint*)
					True, (* Equivalent to MatchQ[evaType,Except[RotaryEvaporation]] *)
					Null
				]
			]
		],
		{
			simulatedSamples,
			Lookup[myResolvedOptions, EvaporationType]
		}
	];

	(* Make resources for the metal clamp - we will request only 1 hard-coded metal clamp model however many RotaryEvaporation we are going to do *)
	condensationFlaskClampResource = If[MemberQ[Lookup[myResolvedOptions, EvaporationType], RotaryEvaporation],
		(* Replace the named model with ID after db refresh *)
		Link@Resource[Sample -> Model[Part, Clamp, "Stainless Pinch Locking Clamp for 35/20, 35/25 Ball Joint"], Rent -> True],
		Null
	];

	(* Make a Download call to get the vacuum centrifuge compatibility  of the input samples *)
	containerVacCentCompat = Quiet[
		Download[
			workingModelContainers,
			Packet[VacuumCentrifugeCompatibility],
			Cache -> cache,
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist}
	];

	(* If we have pooled sample but no aliquoting, our simulatedModelContainers is wrapped in another layer of list. However, this only happens in a single-sample pool. Basially we need to get the first of the VacuumCentrifugeCompatibility *)
	finalContainerVacCentCompat = FirstOrDefault[ToList[#]]& /@ containerVacCentCompat;

	(* ---- BATCHING CALCULATIONS ---- *)
	(* TODO: If you change the following index format, be sure to change all the references to the indexes below this section! *)
	groupedBatches = GatherBy[
		Transpose[{
			(* Required Matching *)
			(* General *)
			(*1*)expPooledSamplesIn,
			(*2*)simulatedSamples,
			(*3*)simulatedContainers,
			(*4*)workingModelContainers, (* Group by container model *)
			(*5*)evapTypes,

			(* Evaporation Parameters *)
			(*6*)Link /@ instruments,
			(*7*)tempEquilTimes,
			(*8*)evapTimes,
			(*9*)evapTemps,
			(*10*)evapUntilDryVals,
			(*11*)maxEvapTimes,

			(* Shared SV and RV not NB *)
			(*12*)rampTimes,
			(*13*)Lookup[myResolvedOptions, EvaporationPressure] /. MaxVacuum -> 0 * Millibar,

			(* Shared RV and NB not SV *)

			(* Rotovap Parameters *)
			(*14*)Lookup[myResolvedOptions, RotationRate],
			(*15*)Lookup[myResolvedOptions, CondenserTemperature],
			(*16*)bumpTrapResources,
			(*17*)evaporationContainerResources,
			(*18*)condensationFlaskResources,
			(*19*)Lookup[myResolvedOptions, RecoupCondensate],
			(*20*)ConstantArray[Null, Length[expPooledSamplesIn]], (* RinseSolution is deprecated *)
			(*21*)ConstantArray[Null, Length[expPooledSamplesIn]], (* RinseVolume is deprecated *)
			(*22*)Link /@ trapRinseSolutionResources,
			(*23*)Lookup[myResolvedOptions, BumpTrapRinseVolume],
			(*24*)Link /@ bumpTrapSampleContainers,
			(*25*)Link /@ condensateRecoveryContainers,

			(* SpeedVac Parameters *)
			(*26*)Link /@ balances,
			(*27*)Link /@ Lookup[myResolvedOptions, BalancingSolution],
			(*28*)Link /@ Lookup[myResolvedOptions, VacuumEvaporationMethod],

			(* Nitrogen blower *)
			(*29*)Lookup[myResolvedOptions, FlowRateProfile],
			(*30*)aliquotContainers,
			(*31*)finalContainerVacCentCompat
		}],

		(* Group by everything but the samples and containers themselves, as well as the final key which is the index of the samples in NestedIndexMatchingSamplesIn *)
		(*Most[#[[4;;]]]&*)#[[4;;]]&
	];

	(* For each grouping of batched parameters, break into the desired partition size based on container type *)
	(* We flatten the results because we're creating a list of associations and aren't worried that flatten will destroy essential structures *)
	evapParamsRaw = Flatten@Map[
		Function[{groupedEvapBatch},
			Module[
				{
					sharedBatchPacket, containerModel, gatheredContainers, groupedSamplesPools,
					groupedSamplesIndexes, groupedContainerIndexes, batchEvapType, maxContainersPairingsPerBatch,
					reGroupedContainers, racksNeededPerBatch, bucketsNeededPerBatch, uniqueContainers, counterweightRules,
					groupedCounterWeights, aliquotContainer, joinedContainers, batchInstrument, batchInstrumentModel
				},

				(*
					Since we've grouped by run parameters, build a template association out of most of the run parameters.
				 	This template packet will get the partitioned containers stapled to it later so that we can expand the evaporation
				 	batches acocrding to how many containers can go in each batch.
				*)
				sharedBatchPacket = AssociationThread[

					(* These are all the keys, IN ORDER, of the BatchedEvaporationParameters field *)
					{
						EvaporationType, Instrument, EquilibrationTime, EvaporationTime, EvaporationTemperature, EvaporateUntilDry,
						MaxEvaporationTime, PressureRampTime, EvaporationPressure, RotationRate, CondenserTemperature, BumpTrap,
						EvaporationFlask, CondensationFlask, CollectEvaporatedSolvent, RinseSolution, RinseVolume, BumpTrapRinseSolution,
						BumpTrapRinseVolume, BumpTrapSampleContainer, CondensateRecoveryContainer, Balance, BalancingSolution,
						VacuumEvaporationMethod, FlowRateProfile
					},
					First[groupedEvapBatch][[Range[5, 29]]]
				];

				(* Stash which mode of evaporation this batch will utilize *)
				batchEvapType = Lookup[sharedBatchPacket, EvaporationType];

				(* Stash the model of container we're handling in this group of batch. The model is stored as a packet in the 4th index of each sample's values *)
				containerModel = First[groupedEvapBatch][[4]];

				(* Generate packets of our unique containers *)
				uniqueContainers = fetchPacketFromFastAssoc[#, fastAssocSimulatedCache]& /@ DeleteDuplicates[Flatten[groupedEvapBatch[[All, 3]]]];
				aliquotContainer = First[groupedEvapBatch][[30]];

				(*
					In some essence this is the heart of the resource packet function. We've already determined the experimental parameters,
					and all that is left is to appropriately group the containers that will be used during evaporation. Below we will
				 	group containers and sample pools based on the evaporation type and the instrument capacity for each container footprint
				*)
				gatheredContainers = Switch[batchEvapType,
					RotaryEvaporation,
					ToList /@ Download[uniqueContainers, Object], (* A rotovap currently can only hold one evaporation flask at a time *)

					NitrogenBlowDown,
					(* TODO: Better to switch off of container type or instrument model? *)
					If[
						(* If the sample is in a plate, and the resolved EvaporationType is NitrogeBlowDown, we are using the needle dryer *)
						MatchQ[containerModel, ObjectP[{Model[Container, Plate], Object[Container, Plate]}]],

						(*The NeedleDryer can only handle one nitrogen blower plate at a time*)
						ToList /@ Download[uniqueContainers, Object],

						(*Otherwise we are using the tube dryer and the samples are in Object[Container,Vessel]. We want to separate containers based on type, since we use different racks for 2 ml tubes, 15 mL, and 50 mL*)
						ToList@Download[uniqueContainers, Object](*TODO: Change to use the footprint system*)
					],

					SpeedVac,
					Module[
						{
							containerSampleVolumePairs, duplicateValidPairs, shorteningValidPairs,
							growingValidPairs, finalBalancedContainerPairs, remainingUnbalancedContainers,
							containerCounterweightModelPairs
						},


						(* Build a list of lists in the form {{container,volume of contents}..} *)
						containerSampleVolumePairs = Map[
							Function[
								{containerPack},
								{
									Lookup[containerPack, Object],
									Total[
										fastAssocLookup[fastAssocSimulatedCache, #, Volume]& /@ (Lookup[containerPack, Contents][[All, 2]])
									]
								}
							],
							uniqueContainers
						];

						(* First gather all the unique containers in the batch that have a difference less than 5% of the greatest weight of the two containers *)
						duplicateValidPairs = Cases[
							Subsets[containerSampleVolumePairs, {2}],
							_?(
								LessEqual[
									(* We're examining subsets of the form: {{cont1,vol1},{cont2,vol2}} and want to minimize diff of vol1 & vol2 *)
									Abs[#[[1, 2]] - #[[2, 2]]],

									(* We want the different to be below 5% of the volume of the most volumous container *)
									0.05 * Max[#[[1, 2]], #[[2, 2]]]
								]&
							)
						];
						(* We need to initialize a variable that will shorten as we search the valid pairs *)
						shorteningValidPairs = duplicateValidPairs;

						(* We need to initialize a variable that will grow as we find valid pairs *)
						growingValidPairs = {};

						(*
								Now for the tricky part:
								- We will iterate enough times to find a list of unique pairs of containers
								- Whenever we find a valid pair, we add it to the growing list
								- Whenever we find a valid pair, we remove any existing pairs in the shortening list that contains objects in the valid pair we found
								This will build a list of containers who's volumes are within 5% of each other and will generate NO overlapping pairs
							*)
						(*
							 	We will map the following function over the length of the duplicate free to list to avoid usiing While.
								This means our function will iterate a finite number of times no matter what.
							*)
						Map[
							Function[
								{index},
								If[
									(* Make sure the list of remaining pairs is not empty *)
									MatchQ[shorteningValidPairs, {}],

									(* If it is empty, do not save any pairs of containers *)
									Nothing,

									(* If it's NOT empty, follow the logic above to pull out a pair of containers that can balance each other and scrub the volume info, leaving only containers *)
									growingValidPairs = Append[growingValidPairs, Flatten@DeleteCases[First[shorteningValidPairs], VolumeP, Infinity]];
									shorteningValidPairs = DeleteCases[
										shorteningValidPairs, _List?(
											MemberQ[#,
												Alternatives @@ First[shorteningValidPairs]]&
										)
									];
								]
							],
							Range[Length[duplicateValidPairs]]
						];

						(* Having completed pairing all the containers we could, gather all containers we couldn't pair	*)
						remainingUnbalancedContainers = DeleteCases[
							DeleteDuplicates[Lookup[uniqueContainers, Object]],
							Alternatives @@ Flatten[growingValidPairs]
						];

						(* Now mirror the paired container structures by adding a model resource that will become a counterweight plate *)
						containerCounterweightModelPairs = {
							#,
							Link@Resource[
								Sample -> Download[fastAssocLookup[fastAssocSimulatedCache, #, Model], Object] /. evaporateReplacementCounterweighContainers,
								Name -> ToString[Unique[]]]
						}& /@ remainingUnbalancedContainers;

						(* Now that we have a full list of balanced containers, add all the containers we couldn't balance to it and return *)
						Join[
							growingValidPairs,
							containerCounterweightModelPairs
						]
					],

					(* Failure case *)
					_,
					{{}}
				];

				(* Now that we've gathered containers, determine the number of racks we'd need. *)
				(* NOTE: This currently only applies to SpeedVac, but NitrogenBlowDown will get it as well shortly *)
				{
					racksNeededPerBatch,
					bucketsNeededPerBatch,
					maxContainersPairingsPerBatch
				} = Switch[batchEvapType,

					RotaryEvaporation,
					{{Null}, {Null}, 1},

					NitrogenBlowDown,
					(* Pullout the Instrument from sharedBatchPacket *)
					batchInstrument = Lookup[sharedBatchPacket, Instrument][Object];
					(* Get the model of the instrument, this is used in the next check *)
					batchInstrumentModel = If[
						!MatchQ[batchInstrument, ObjectP[Model[Instrument]]],
						batchInstrument[Model][Object],
						batchInstrument
					];
					(*If the instrument is the Needle Dryer, this should be {{Null},{Null},1} since it can only handle one sample at a time.*)
					If[MatchQ[batchInstrumentModel, Alternatives[Model[Instrument, Evaporator, "id:R8e1PjRDb36j"]]],
						(*The Needle Dryer can only handle one plate at a time. *)
						{{Null}, {Null}, 1},

						(*Otherwise, calculate how many racks and container pairings we can have. Should be {{1},{Null},24|48}*)
						Module[{availableRacks, numberOfTubePositions, rackTubeNumberRule, chosenRack, maxPositionsAvailable, rackCompatibiity},
							(*List of the available racks that fit in the TubeDryer*)
							availableRacks = Lookup[turboRackPackets, Object];

							(*Get the number of positions in each rack*)
							numberOfTubePositions = Length /@ Lookup[turboRackPackets, Positions];

							(*Make an association of RackObject->numberOfTubePositions*)
							rackTubeNumberRule = AssociationThread[availableRacks, numberOfTubePositions];

							(*Get the container model. If we are aliquoting, it will be the aliquot container *)
							joinedContainers = FirstCase[Flatten[{ToList[aliquotContainer], containerModel}], ObjectP[]];

							(*Check the compatibility of the container with the available racks *)
							rackCompatibiity = CompatibleFootprintQ[#, joinedContainers, ExactMatch -> False]& /@ availableRacks;

							(*Choose the rack with that is compatible with the container *)
							chosenRack = PickList[availableRacks, rackCompatibiity] /. {} -> {Null};

							maxPositionsAvailable = Lookup[rackTubeNumberRule, chosenRack];
							{
								Link[chosenRack],
								{Null},
								maxPositionsAvailable
							}
						]
					],

					SpeedVac,
					Module[
						{
							vacCentrifugeCompatibility, allowedRacks, allowedBuckets, allowedRotors, rackPositionsRules,
							bucketPositionRules, rotorPositionRules, numberSlotsByContainerByRack, numberSlotsByContainerByBucket,
							numberSlotsByContainerByRotor, numberOfPositionPerSetup, maxPositionsAvailable, chosenSpeedVacSetup,
							numberOfBucketsNeeded, numberOfRacksNeeded
						},

						(* vacCentrifugeCompatibility *)
						vacCentrifugeCompatibility = Cases[
							(*fastAssocLookup[fastAssocSimulatedCache,containerModel,VacuumCentrifugeCompatibility],*)Lookup[First[groupedEvapBatch][[31]], VacuumCentrifugeCompatibility],
							If[MatchQ[Lookup[sharedBatchPacket, Instrument], ObjectP[Model[Instrument]]],
								AssociationMatchP[<|Instrument -> ObjectP[Lookup[sharedBatchPacket, Instrument]]|>, AllowForeignKeys -> True],
								AssociationMatchP[<|Instrument -> ObjectP[Download[fastAssocLookup[fastAssocSimulatedCache, Lookup[sharedBatchPacket, Instrument], Model], Object]]|>, AllowForeignKeys -> True]
							]
						];

						(* Make sure the sample has entry for the instrument we're using. Otherwise throw an error *)
						If[MatchQ[vacCentrifugeCompatibility, {} | <||>],
							Message[Error::IncompatibleSpeedVac, Flatten@groupedEvapBatch[[All, 1]], Download[Lookup[sharedBatchPacket, Instrument], Object]];
							$Failed
						];

						(* Find the rack(s) and bucket(s) that each sample container could fit in on in this centrifuge *)
						allowedRacks = Download[Lookup[vacCentrifugeCompatibility, Rack], Object, {}];
						allowedBuckets = Download[Lookup[vacCentrifugeCompatibility, Bucket], Object, {}];
						allowedRotors = Download[Lookup[vacCentrifugeCompatibility, Rotor], Object, {}];

						(* Find the number of slots in each rotor/bucket/rack.
								 To avoid calling openLocations multiple times on the same object, we will call it on just the unique objects first and relate the object to the outcome *)
						rackPositionsRules = Map[Rule[#, If[NullQ[#], 1, Length[Locations`Private`openLocations[#, Cache -> cache, Simulation -> updatedSimulation]]]] &, DeleteDuplicates[Flatten[allowedRacks]]];
						bucketPositionRules = Map[Rule[#, If[NullQ[#], 1, Length[Locations`Private`openLocations[#, Cache -> cache, Simulation -> updatedSimulation]]]] &, DeleteDuplicates[Flatten[allowedBuckets]]];
						rotorPositionRules = Map[Rule[#, If[NullQ[#], 1, Length[Locations`Private`openLocations[#, Cache -> cache, Simulation -> updatedSimulation]]]] &, DeleteDuplicates[Flatten[allowedRotors]]];

						(* Then expand the rules so that we have the number of slots for each object *)
						numberSlotsByContainerByRack = allowedRacks /. rackPositionsRules;
						numberSlotsByContainerByBucket = allowedBuckets /. bucketPositionRules;
						numberSlotsByContainerByRotor = allowedRotors /. rotorPositionRules;

						(* For each container, find the number of positions in the rotor/bucket/rack combo that can fit the most containers*)
						numberOfPositionPerSetup = MapThread[
							Times[#1, #2, #3]&,
							{numberSlotsByContainerByRack, numberSlotsByContainerByBucket, numberSlotsByContainerByRotor}
						];

						(* Now determine the max *)
						maxPositionsAvailable = Max[numberOfPositionPerSetup];

						chosenSpeedVacSetup = First@Flatten@PickList[
							vacCentrifugeCompatibility,
							numberOfPositionPerSetup,
							maxPositionsAvailable
						];

						(* Stash how many buckets we can put into the rotor *)
						numberOfBucketsNeeded = Download[Lookup[chosenSpeedVacSetup, Rotor], Object] /. rotorPositionRules;

						(* Calculate how many racks are needed for the run, which is number of racks per bucket * number of buckets per rotor *)
						numberOfRacksNeeded = numberOfBucketsNeeded * (Download[Lookup[chosenSpeedVacSetup, Bucket], Object] /. bucketPositionRules);

						(* Return our batches' rack and bucket information - this information will be multiple by the number of batches we're making in this evap params section *)
						{
							Table[Link[Lookup[chosenSpeedVacSetup, Rack]], numberOfRacksNeeded],
							Table[Link[Lookup[chosenSpeedVacSetup, Bucket]], numberOfBucketsNeeded],

							(* Now since the gathered containers are balanced against a plate with equal weight, we need to divide this by 2 *)
							maxPositionsAvailable / 2
						}
					]
				];

				(* Now take our lists of balanced/grouped containers and partition them according to instrument capacity, and remove the counterweight resources *)
				reGroupedContainers = DeleteCases[
					Flatten /@ PartitionRemainder[gatheredContainers, maxContainersPairingsPerBatch],
					Link[Resource[__]],
					Infinity
				];
				(* Build a list of rules that will point a working container at Null or the resource for it's future balance plate *)
				counterweightRules = Which[

					(* If it's an Object - Resource pair, point the Object at the resource *)
					MatchQ[#, {ObjectP[Object[Container]], Link[Resource[__]]}],
					First[#] -> Last[#],

					(* Otherwise these containers don't have counterweights, as other WorkingContainers will balance them  *)
					MatchQ[#, {ObjectP[Object[Container]], ObjectP[Object[Container]]}],
					Sequence @@ {First[#] -> Null, Last[#] -> Null},

					(* If this was a nitrogen or rotavap plate that never gets pair, set counterweights to null *)
					MatchQ[#, {ObjectP[Object[Container]]}],
					First[#] -> Null,

					(* When in doubt set everything to null *)
					True,
					# -> Null
				]& /@ gatheredContainers;

				groupedCounterWeights = reGroupedContainers /. counterweightRules;
				(* Build a lookup guide of simulated container to samples in *)
				(* flattening here because we only care about object1 -> object2 and don't care about the pooling grouping here *)
				simulateSamplesToPooledSamplesLookup = AssociationThread[Flatten[groupedEvapBatch[[All, 2]]] -> Flatten[groupedEvapBatch[[All, 1]]]];

				(* Determine the index of working containers these batched containers point to so we can pull it out later *)
				(* NOTE: This variable is quite listed, but it doesn't matter as when we see these values next we're just gonna flatten everything *)
				groupedContainerIndexes = Flatten[
					Position[
						Flatten[Download[simulatedWorkingContainers, Object],1],
						Alternatives @@ #
					]
				]& /@ reGroupedContainers;

				(* Using the lookup table above, gather the relevant sample pools so we can determine which sample indexes these batches point at *)
				groupedSamplesPools = Flatten /@ Map[
					Function[{oneGroupingOfContainers},
						Lookup[
							simulateSamplesToPooledSamplesLookup,
							(fastAssocLookup[fastAssocSimulatedCache, #, Contents][[All, 2]]) /. xLink:LinkP[] :> First[xLink],
							Nothing(*Comes up if we find things in the containers that were not in our samplesin or simulated samples *)
						]& /@ oneGroupingOfContainers
					],
					reGroupedContainers
				];

				(* Now that we've grouped the input samples according to how they'll appear in the batch, determine which position in WorkingSamples these will point at*)
				groupedSamplesIndexes = Map[
					Function[{batchOfSamples},
						Flatten[Position[Flatten[myPooledSamples,1], #]& /@ batchOfSamples]
					],
					groupedSamplesPools
				];

				(* Build an association for each batched group of containers *)
				(* NOTE: In a later section we will drop the keys were adding here before uploading to the packet *)
				MapThread[
					Join[
						sharedBatchPacket,
						<|
							PooledSamplesIn -> #1,
							PooledContainersIn -> #2,
							PooledSampleIndex -> #3,
							PooledContainerIndex -> #4,
							CounterweightResources -> #5,
							RequiredRacks -> #6,
							SpeedVacBuckets -> #7
						|>
					]&,
					{
						groupedSamplesPools,
						reGroupedContainers,
						groupedSamplesIndexes,
						groupedContainerIndexes,
						groupedCounterWeights,
						Table[racksNeededPerBatch, Length[reGroupedContainers]],
						Table[bucketsNeededPerBatch, Length[reGroupedContainers]]
					}
				]
			]
		],

		(* We're mapping all the code above over our groupings to condense the batches for samples that can be evaporated together *)
			groupedBatches
	];

	(* Pull the list of pooled containers out and find the length of the containers*)
	batchContainerLengths = Length /@ Lookup[evapParamsRaw, PooledContainersIn];
	batchSampleLengths = Length /@ Lookup[evapParamsRaw, PooledSamplesIn];
	finalContainerIndexes = Flatten[Lookup[evapParamsRaw, PooledContainerIndex]];
	finalSampleIndexes = Flatten[Lookup[evapParamsRaw, PooledSampleIndex]];

	(* Get the final counterweight list. Note: It's batch lengths are the same as batchContainerLengths *)
	batchedCounterWeights = Flatten[Lookup[evapParamsRaw, CounterweightResources]];

	(* Get the list of the centrifuge racks only *)
	centRacksOnly = Lookup[evapParamsRaw, RequiredRacks] /. Alternatives[Model[Container, Rack, "id:54n6evLR9oEL"], Model[Container, Rack, "id:n0k9mG8wD6An"], Model[Container, Rack, "id:01G6nvwpN571"]] -> Null;

	(* Pull batching information for the SpeedVac racks and buckets *)
	batchedCentrifugeTubeRacks = Flatten[MapThread[Function[{evapType, centRack},
		If[
			MatchQ[evapType, SpeedVac],
			centRack,
			Table[Null, Length[centRack]]
		]
	],
		{Lookup[evapParamsRaw, EvaporationType], centRacksOnly}
	]];
	batchedSpeedVacBuckets = Flatten[Lookup[evapParamsRaw, SpeedVacBuckets]];

	(* Isolate the instrument object, which at this point can be either a specific instrument or a model *)
	unsortedInstrument = Download[Lookup[evapParamsRaw, Instrument], Object];

	(* If the unsortedInstrument isn't a model, get the model of the instrument *)
	instrumentModel = If[
		MatchQ[unsortedInstrument,ObjectP[Objet[Instrument]]],
		Download[unsortedInstrument, Model[Object], Simulation->updatedSimulation],
		unsortedInstrument
	];

	{batchedNitrogenTubeRacks, nozzlePlugs} = Transpose@MapThread[Function[{inst, rack},
		If[
			(*If the Instrument is the Turbovap, get the turbovap racks needed*)
			MatchQ[inst, ObjectP[Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"]]],
			Module[{nozzle, racks},
				racks = First[rack];
				nozzle = Model[Part, "Nozzle Plugs for TurboVap Evaporator"];
				{racks, nozzle}
			],
			(*Otherwise, the TurboVap is not selected for this batch so no Turbovap racks or nozzle plugs are needed *)
			{
				Table[Null, Length[rack]],
				{Null}
			}
		]
	],
		{instrumentModel, Download[Lookup[evapParamsRaw, RequiredRacks], Object]}
	];

	(* If the TurboVap is selected, we will need a funnel, a drain tube, and a waste container for the bath water *)
	{drainTube, funnelResource, wasteContainerResource} = If[
		MatchQ[instrumentModel, ObjectP[Model[Instrument, Evaporator, "id:kEJ9mqRxKA3p"]]],
		Module[{drain, funnel, waste},
			drain = ToList[Resource[Sample -> Model[Plumbing, Tubing, "TurboVap LV Water Bath Draining Tube"], Rent -> True]];
			funnel = ToList[Resource[Sample -> Model[Container, GraduatedCylinder, "4 L polypropylene graduated cylinder"], Rent -> True]];
			waste = ToList[Resource[Sample -> PreferredContainer[10 Liter], Rent -> True]];
			{drain, funnel, waste}
		],
		{
			{Null},
			{Null},
			{Null}
		}
	];

	(* Generate resources for any bath fluid we may create *)
	bathFluidResources = MapThread[
		Function[{evap, evapFlaskLinkedResource},
			Switch[evap,
				(*If we are using the RotaryEvaporator, we use Milli-Q water and we calculate the amount based on the volume of the pear flask*)
				RotaryEvaporation,
				Module[{evapFlask, flaskSize, bathVolume, bathVolumeRounded},
					(* evapFlask will be a Link[Resource[...]] so we have to extract model or object from it *)
					evapFlask = evapFlaskLinkedResource[[1]][Sample];
					(* Get the volume of the rotovap flask - make sure we always get this information from model *)
					flaskSize = If[MatchQ[evapFlask, ObjectP[Object[Container, Vessel]]],
						fastAssocLookup[fastAssocSimulatedCache, evapFlask, {Model, MaxVolume}],
						fastAssocLookup[fastAssocSimulatedCache, evapFlask, {MaxVolume}]
					];

					(* Calculate the volume of water we need for the water bath *)
					(* This is from empirically measuring how much water we needed to add to the water bath to reach a reasonable level for 500 mL, 1 L, 2 L pear flasks *)
					(* 500 mL flask -> 4.30 L *)
					(* 1 L flask    -> 3.60 L *)
					(* 2 L flask    -> 2.45 L *)
					(* Linear regression: bath volume (mL) = -1.2214 * flask volume (mL) + 5375 *)

					bathVolume = -1.2214 * flaskSize + 5375 Milliliter;

					(* Round to the nearest 50 mL as this is the resolution of the 4 L graduated cylinder *)
					bathVolumeRounded = SafeRound[bathVolume, 50 Milliliter];

					(* Generate the resource for the Milli-Q water with the calculated amount *)
					Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> bathVolumeRounded, Container -> PreferredContainer[bathVolumeRounded], Name -> ToString[Unique[]]]
				],
				NitrogenBlowDown,
				(*Otherwise, we are using NitrogenBlowDown, which requires 10 L of RO water*)
				Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> 10Liter, Container -> PreferredContainer[10Liter], Name -> ToString[Unique[]]],
				_, Null
			]
		],
		{Lookup[evapParamsRaw, EvaporationType], Lookup[evapParamsRaw, EvaporationFlask]}
	];

	(* Stash an instrument resource requesting at least one of the instruments we'll use to make sure the operators can actually run the protocol *)
	placeHolderInstResources = Module[{resInstruments, resInstrumentModels, resInstrumentObjects, placeHolderInstTime},
		(* We have split the resolved instruments by objects models since instrument resource does not accept mixed list *)
		resInstruments = ToList[Lookup[myResolvedOptions, Instrument]];
		resInstrumentModels = DeleteDuplicates@Cases[resInstruments, ObjectP[Model[Instrument]]];
		resInstrumentObjects = DeleteDuplicates@Cases[resInstruments, ObjectP[Object[Instrument]]];
		(* get a placeholder instrument time, does not need to be accurate updateEvaporationStatus will make a better resource that is actually used by individual batch *)
		placeHolderInstTime = Total[Lookup[myResolvedOptions, EvaporationTime]];
		Flatten[{
			(* For instrument objects, we have to make resource for each one of them *)
			Map[
				Resource[Instrument -> #1, Time -> placeHolderInstTime]&,
				resInstrumentObjects
			],
			(* For instrument models, we can just make one resource indicating as long as one of the instruments is available we can pass RC and run the protocol in lab *)
			If[Length[resInstrumentModels] > 0,
				Resource[Instrument -> resInstrumentModels, Time -> placeHolderInstTime],
				{}
			]
		}]

	];

	(* Remove the temporary keys used above for gathering batches *)
	cleanedEvapParams = KeyDrop[
		#,

		(* Make sure the list matches the list directly above that adds keys which aren't in the field *)
		{
			PooledSamplesIn,
			PooledContainersIn,
			PooledSampleIndex,
			PooledContainerIndex,
			CounterweightResources,
			RequiredRacks,
			SpeedVacBuckets
		}
	]& /@ evapParamsRaw;

	(*Replace the bath fluids with a link to the resources in cleanedEvapParams *)
	evapParamsWithBath = MapThread[Append[#1, BathFluid -> Link[#2]]&, {cleanedEvapParams, bathFluidResources}];

	(* expSubdivide: a helper that generates N exponentially spaced intermediate values between startVal and endVal *)
	expSubdivide[startVal_, endVal_, numberOfPoints_Integer] := Module[{logIntVals, truncatedLogIntVals},
		(* Generate N+2 evenly distributed intermediate values of the LOG of startVal and the LOG of endVal *)
		logIntVals = Subdivide[Log[startVal], Log[endVal], numberOfPoints + 1];
		(* Drop the first and last element so we have N values now *)
		truncatedLogIntVals = Take[logIntVals, {2, -2}];
		(* Convert LOG values back to real values *)
		Exp[truncatedLogIntVals]
	];

	(* Append the key BatchNumber to each batch association to indicate which batch it is *)
	(* need to do these shenanigans with BumpTrapSampleContainer and CondensateRecoveryContainer because I believe we can't easily add indices to a named multiple field except to the end, and we needed to add these later *)
	(* we are also going to make a pressure/rotation/time gradient table here so operator knows how to input parameters to rotovap, unfortunately we have to do this manually for now *)
	(* this table always looks like this {{Pressure, RPM, Time}..} and will always have EXACT 10 entries b/c we can only fill up 10 entries in the rotovap instrument *)
	{evapParams, evapPressureProfileImageCloudFiles} = Transpose@MapThread[
		Function[{evapParamsPerBatch, index},
			Module[{evapPressureProfile, evapPressureProfileImageCloudFile},
				(* Only try to generate the gradient table if we are doing RotaryEvaporation *)
				{evapPressureProfile, evapPressureProfileImageCloudFile} = If[MatchQ[Lookup[evapParamsPerBatch, EvaporationType], RotaryEvaporation],
					Module[
						{equilibrationTimePerBatch, pressureRampTimePerBatch, evapTimePerBatch, evapPressurePerBatch, rotationRatePerBatch, equilibrationTimeEntry,
							pressureRampEntries, evapTimeEntry, allEntries, allEntryStrings, allEntryFormattedStrings, allEntryTableContents, allEntryImage, entryImageCloudFilePacket},
						(* Pull out EquilibrationTime, PressureRampTime, EvaporationTime, EvaporationPressure *)
						{equilibrationTimePerBatch, pressureRampTimePerBatch, evapTimePerBatch, evapPressurePerBatch, rotationRatePerBatch} = Lookup[evapParamsPerBatch,
							{EquilibrationTime, PressureRampTime, EvaporationTime, EvaporationPressure, RotationRate}
						];
						(* See if we need to do equilibration up front - dont rotate since flask MIGHT fall off *)
						equilibrationTimeEntry = If[MatchQ[equilibrationTimePerBatch, GreaterP[0 * Minute]],
							{{1 * Atmosphere, 0 * RPM, equilibrationTimePerBatch}},
							{}
						];
						(* Now we need to do step-wise pressure ramp gradient - we will decrease pressure from atm to set pressure in an exponential way
						since we want to put more pressure/time points when it is close to the set pressure to avoid boiling/bumping *)
						(* We always try to generate three points, even though this may result in time for that intermediate pressure being 0 second, which is still okay *)
						pressureRampEntries = If[MatchQ[pressureRampTimePerBatch, GreaterP[0 * Minute]],
							Module[{startPressure, endPressure, intPressures, totalRampTime, timeEquation, startDuration, solvedStartDuration, intTimes},
								(* Convert to mBar then get rid of the unit *)
								startPressure = QuantityMagnitude[1 * Atmosphere, Millibar];
								endPressure = QuantityMagnitude[evapPressurePerBatch, Millibar];
								(* Use the helper to generate 3 exponentially spaced intermediate pressure values *)
								intPressures = expSubdivide[startPressure, endPressure, 3];

								(* Convert the total ramp time to Second, get rid of the unit, also conveniently just round it *)
								totalRampTime = QuantityMagnitude[pressureRampTimePerBatch, Second];
								(* We have to do a bit equation solving here, we know the total ramp time,
								but we want to get a span of exponentially spaced time durations that are reasonable and add up to total ramp time *)
								(* Assuming we will spend {startDuration} amount at the first pressure that is closest to atmosphere,
								then eventually spend 4 times longer at the pressure that is closet to the final set pressure *)
								timeEquation = (Total[expSubdivide[startDuration, startDuration * 4, 3]] == totalRampTime);
								solvedStartDuration = First[startDuration /. Solve[timeEquation], Null];
								(* With the solved value we can generate 3 exponentially spaced time intervals *)
								intTimes = expSubdivide[solvedStartDuration, solvedStartDuration * 4, 3];

								(* RPM will be the same for every entry *)
								Transpose[{
									intPressures * Millibar,
									ConstantArray[rotationRatePerBatch, 3],
									intTimes * Second
								}]
							],
							{}
						];
						(* The actual evaporation setting is going to be simply one-liner *)
						evapTimeEntry = If[MatchQ[evapTimePerBatch, GreaterP[0 * Minute]],
							{{evapPressurePerBatch, rotationRatePerBatch, evapTimePerBatch}},
							{}
						];
						(* Join all the entries *)
						allEntries = Join[equilibrationTimeEntry, pressureRampEntries, evapTimeEntry];

						(* Now we have all the entries, we can go make an image for the table so operator can easily see it in the task *)
						(* Easier if we just convert everything to string in the right unit. Quieting b/c we also do not need to hear warnings from SafeRound[...] here  *)
						allEntryStrings = Quiet[allEntries /. {
							(* Convert pressure to Millibar *)
							pressure:PressureP :> ToString[SafeRound[QuantityMagnitude[pressure, Millibar], 1]]<>" mBar",
							(* Convert rotation rate to RPM *)
							rotationRate:RPMP :> ToString[SafeRound[QuantityMagnitude[rotationRate, RPM], 1]]<>" RPM",
							(* Format time in form of hh\:mm\:ss since that is how instrument accepts values *)
							time:TimeP :> TextString[TimeObject @@ QuantityMagnitude[SafeRound[time, 1 * Second], MixedUnit[{"Hours", "Minutes", "Seconds"}]]]
						}];
						(* Pad the contents to a length 10 if we can b/c that is how many rotovap can take input in program mode *)
						allEntryFormattedStrings = Switch[Length[allEntryStrings],
							(* If we do not have any pressure value for some reason, return the error message *)
							0,
							{{"An error happened when trying to generate Pressure/Rotation/Time values, please stop and file a troubleshooting ticket.", "N/A", "N/A"}},
							(* Otherwise, always padding to a length of 10 also prepending index *)
							RangeP[1, 10],
							PadRight[allEntryStrings, 10, {{"1000 mBar", "100 RPM", "00:00:00"}}],
							(* For whatever other reasons that may cause error, return the error message *)
							_,
							{{"An error happened when trying to generate Pressure/Rotation/Time values, please stop and file a troubleshooting ticket.", "N/A", "N/A"}}
						];
						(* Make the table contents by prepending index to each row *)
						allEntryTableContents = Transpose[Join[{Range[Length[allEntryFormattedStrings]]}, Transpose[allEntryFormattedStrings]]];
						(* Rasterize the table so we can get an image to UploadCloudFile with *)
						allEntryImage = Rasterize[PlotTable[allEntryTableContents, TableHeadings -> {None, {"No.", "Pressure", "Rotation", "hh:mm:ss"}}, Alignment -> Center]];
						(* Make a cloud file, block $DisableVerbosePrinting True to not show constellation message of cloud file upload *)
						entryImageCloudFilePacket = Block[{$DisableVerbosePrinting = True}, UploadCloudFile[allEntryImage, Upload -> upload] /. $Failed -> Null];

						{
							allEntries,
							entryImageCloudFilePacket
						}
					],
					(* Otherwise dont bother making *)
					{Null, Null}
				];
				{
					(* Append the batch number as well BumpTrapSampleContainer, CondensateRecoveryContainer and all the above efforts *)
					Join[
						KeyDrop[evapParamsPerBatch, {BumpTrapSampleContainer, CondensateRecoveryContainer, EvaporationPressureProfile, EvaporationPressureProfileImage}],
						<|
							BatchNumber -> index,
							BumpTrapSampleContainer -> Lookup[evapParamsPerBatch, BumpTrapSampleContainer],
							CondensateRecoveryContainer -> Lookup[evapParamsPerBatch, CondensateRecoveryContainer],
							EvaporationPressureProfile -> evapPressureProfile,
							EvaporationPressureProfileImage -> Link[Download[evapPressureProfileImageCloudFile, Object]]
						|>
					],
					(* We also want to return the cloud file packet in case user wants to do Upload->False and see what they get *)
					evapPressureProfileImageCloudFile
				}
			]
		],
		{evapParamsWithBath, Range[Length[evapParamsWithBath]]}
	];

	(*getting all of the fields necessary to determine evaporation time estimates*)
	evapParamsTypes = Lookup[evapParams, EvaporationType];
	evapParamsMaxEvapTimes = Lookup[evapParams, MaxEvaporationTime];
	evapParamsTempEquilTimes = Lookup[evapParams, EquilibrationTime];
	evapParamsRampTimes = Lookup[evapParams, PressureRampTime];
	evapParamsEvapTimes = Lookup[evapParams, MaxEvaporationTime];

	(* Generate batched connections list *)
	batchedConnections = MapThread[
		Function[{currentEvapType, currentEvapParam},

			(* Only generate a connections list if we're in RotaryEvaporation mode *)
			If[MatchQ[currentEvapType, RotaryEvaporation],

				{
					(* We need to build connections between the instrument the bump trap*)
					{Lookup[currentEvapParam, Instrument], "Evaporation Flask Port", Lookup[currentEvapParam, BumpTrap], "Instrument Port"},

					(* The bump trap and the evaporation flask *)
					{Lookup[currentEvapParam, BumpTrap], "Evaporation Flask Port", Lookup[currentEvapParam, EvaporationFlask], "Neck Inlet"},

					(* The instrument and the condensation flask *)
					{Lookup[currentEvapParam, Instrument], "Condensation Flask Port", Lookup[currentEvapParam, CondensationFlask], "Neck Inlet"}
				},

				(* We're not in Rotovap so make an empty connection list *)
				{{Null, Null, Null, Null}}
			]
		],
		{
			evapParamsTypes,
			evapParams
		}
	];

	(* Stash the batched connection lengths *)
	batchedConnectionLengths = Length /@ batchedConnections;

	(* Estimate how long the actual run will take *)
	estimatedRunTimes = MapThread[
		Function[
			{evapType, maxEvapTime, tempEquilTime, rampTime, evapTime},

			(* If we're given a maxEvapTime, then default to that to be conservative on our time estimate *)
			If[!NullQ[maxEvapTime],

				(* return the max evap time *)
				maxEvapTime,

				(* Otherwise, based on which evap method we're using, calculate the total time of the relevant stages added together *)

				Switch[evapType,
					SpeedVac, tempEquilTime + rampTime + evapTime,
					RotaryEvaporation, tempEquilTime + rampTime + evapTime,
					NitrogenBlowDown, tempEquilTime + evapTime,
					_, evapTime
				]
			]
		],
		{
			evapParamsTypes,
			evapParamsMaxEvapTimes,
			evapParamsTempEquilTimes,
			evapParamsRampTimes,
			evapParamsEvapTimes
		}
	];

	(* Now add each run time together to get the worst case scenario run time *)
	maxTotalRunTimeEstimate = Total[estimatedRunTimes] /. Null -> 0;

	(* reformat the FlowRateProfile for the upload *)
	flowRateLookup = First[Lookup[myResolvedOptions, FlowRateProfile]];

	flowRateReformat = If[NullQ[flowRateLookup],
		{Null, Null},
		(*Otherwise reformat*)
		Map[Function[{flowRateTuple},
			{flowRateTuple[[1]],
				flowRateTuple[[2]]}
		],
			(* If it is one tuple, we should wrap it *)
			If[Depth[flowRateLookup] == 3, {flowRateLookup}, flowRateLookup]]
	];

	(* assemble the protocol packet *)
	protocolPacket = Join[
		Association[
			Type -> Object[Protocol, Evaporate],
			Object -> CreateID[Object[Protocol, Evaporate]],
			Template -> Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated],
			Name -> Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated],
			(* Give an initial estimated processing time so we can decide if we should reuse our covers in the procedure *)
			EstimatedProcessingTime -> Max[Min[estimatedRunTimes], 0Minute],
			(* General shared fields *)
			Replace[SamplesIn] -> Flatten[Map[Link[#, Protocols]&, samplesInResources]],
			Replace[PooledSamplesIn] -> expPooledSamplesIn,
			Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ containersIn,
			Replace[BatchedContainerIndexes] -> finalContainerIndexes,
			Replace[BatchedSampleIndexes] -> finalSampleIndexes,

			(* Pool-indexed fields *)
			Replace[Instruments] -> Link /@ instruments,
			Replace[ReadyCheckResourcePlaceholders] -> Link /@ placeHolderInstResources,

			Replace[Balances] -> balanceResources,
			Replace[BalancingSolutions] -> Link /@ Lookup[evapParamsRaw, BalancingSolution], (* NOTE: This is a simple link as the compiler builds resources based on sample weights *)
			Replace[CentrifugeBuckets] -> Link /@ batchedSpeedVacBuckets,
			Replace[CentrifugeRacks] -> Link /@ batchedCentrifugeTubeRacks,
			Replace[BucketBatchLengths] -> Length /@ Lookup[evapParamsRaw, SpeedVacBuckets],
			Replace[RackBatchLengths] -> Length /@ Lookup[evapParamsRaw, RequiredRacks],
			Replace[Counterbalances] -> batchedCounterWeights, (*counterweightResources,*)
			Replace[CentrifugalForces] -> {}, (*centForces,*)
			Replace[VacuumEvaporationMethods] -> Link[Lookup[myResolvedOptions, VacuumEvaporationMethod]],
			Replace[ContainerPlacements] -> Table[{Null, Null, Null}, Length[evapParamsRaw]],
			Replace[ContainerPlacementLengths] -> Table[1, Length[evapParamsRaw]],
			Replace[BucketPlacements] -> Table[{Null, Null, Null}, Length[Flatten@batchedSpeedVacBuckets]],

			Replace[BathFluids] -> Link /@ bathFluidResources,
			Replace[BumpTraps] -> bumpTrapResources,
			Replace[CollectEvaporatedSolvent] -> Lookup[myResolvedOptions, RecoupCondensate],
			Replace[BumpTrapRinseSolutions] -> trapRinseSolutionResources,
			Replace[BumpTrapRinseVolumes] -> Lookup[myResolvedOptions, BumpTrapRinseVolume],

			Replace[BatchedConnections] -> Flatten[batchedConnections, 1], (* This is currently grouped so we want to flatten to list of lists *)
			Replace[BatchedConnectionLengths] -> batchedConnectionLengths,

			Replace[EvaporationFlasks] -> evaporationContainerResources,
			Replace[CondensationFlasks] -> condensationFlaskResources,
			CondensationFlaskClamp -> condensationFlaskClampResource,
			EvaporationFlaskClamp -> evaporationFlaskClampResource,
			TransferAllPlaceholder -> All, (* This field is simply just populated to be All so we can enqueue a Transfer subprotocol with no issue when recouping from CondensationFlasks *)
			Replace[BumpTrapSampleContainers] -> Link /@ bumpTrapSampleContainers,
			Replace[CondensateRecoveryContainers] -> Link /@ condensateRecoveryContainers,

			Replace[EvaporationTypes] -> ToList[evapTypes],
			Replace[EquilibrationTimes] -> tempEquilTimes,
			Replace[EvaporationTemperatures] -> evapTemps,
			Replace[PressureRampTimes] -> rampTimes,
			Replace[EvaporationPressures] -> Lookup[myResolvedOptions, EvaporationPressure] /. MaxVacuum -> 0 * Millibar,
			Replace[EvaporationTimes] -> evapTimes,
			Replace[RotationRates] -> Lookup[myResolvedOptions, RotationRate],
			Replace[CondenserTemperatures] -> Lookup[myResolvedOptions, CondenserTemperature],

			(* Null out the batching parallelization fields so they can mapthread in the execute commands *)
			Replace[EvaporationReady] -> Table[Null, Length[evapParams]],
			Replace[CleanUpReady] -> Table[Null, Length[evapParams]],
			Replace[EvaporationStartTimes] -> Table[Null, Length[evapParams]],
			Replace[EvaporationEndTimes] -> Table[Null, Length[evapParams]],
			Replace[TotalEvaporationTimes] -> Table[Null, Length[evapParams]],
			Replace[FullyEvaporated] -> Table[Null, Length[myPooledSamples]],
			Replace[EvaporationComplete] -> Table[False, Length[evapParams]],

			Replace[FlowRateProfiles] -> flowRateReformat,
			Replace[NitrogenBlowerRacks] -> Link /@ Flatten[batchedNitrogenTubeRacks],
			Replace[NozzlePlugs] -> Link /@ Flatten[nozzlePlugs],
			Replace[DrainTube] -> Link /@ drainTube,
			Replace[Funnel] -> Link /@ funnelResource,
			Replace[WasteContainer] -> Link /@ wasteContainerResource,

			Replace[BatchLengths] -> batchContainerLengths,
			Replace[BatchedSampleLengths] -> batchSampleLengths,
			Replace[EvaporateUntilDry] -> evapUntilDryVals,
			Replace[MaxEvaporationTimes] -> maxEvapTimes,

			Replace[BatchedEvaporationParameters] -> evapParams,

			ResolvedOptions -> resolvedOptionsNoHidden,
			UnresolvedOptions -> myUnresolvedOptions,
			Replace[SamplesInStorage] -> Lookup[myResolvedOptions, SamplesInStorageCondition],
			Replace[SamplesOutStorage] -> Lookup[myResolvedOptions, SamplesOutStorageCondition],


			(* checkpoints *)

			Replace[Checkpoints] -> {
				{"Picking Resources", 5 * Minute, "Samples required to execute this protocol are gathered from storage.", Resource[Operator -> $BaselineOperator, Time -> 5 * Minute]},
				{"Preparing Samples", 30 * Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator -> $BaselineOperator, Time -> 30 * Minute]},
				{"Evaporating Samples", maxTotalRunTimeEstimate, "Samples are put under nitrogen airflow or vacuum pressure and concentrated.", Resource[Operator -> $BaselineOperator, Time -> maxTotalRunTimeEstimate]},
				{"Returning Materials", 5 Minute, "Samples are returned to storage.", Resource[Operator -> $BaselineOperator, Time -> 20 Minute]}
			}
		]
	];

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFieldsPooled[ToList /@ myPooledSamples, expandedResolvedOptions, Cache -> cache, Simulation -> updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Cache -> cache, Simulation -> updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> Result, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Messages -> messages, Cache -> cache, Simulation -> updatedSimulation], Null}
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
		(* We also want to return cloud file packet in case Upload->False *)
		Cases[Flatten[{finalizedPacket, evapPressureProfileImageCloudFiles}], PacketP[]],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsection:: *)
(*Helpers*)


(* TODO: Write a helper here that converts EvaporationFlask to BumpTrap model *)



(* ::Subsubsection:: *)
(*pairContainers helper*)


(*
A small helper function to quickly pair off containers with similar weights.
Inputs:
myContainerWeightPairs: a list of container/weight pairs
myMaxImbalance: the maximum desired mass difference between the pairs

Outputs:
The container/weight pairs paired off, and any container/weights that couldn't be paired
e.g.: {{{container1, mass1}, {container2,mass2}}, {{container3, mass3}, {container4,mass4}}, {container5, mass5}}

Note that LegacySLL`Private`centrifugeBalance also exists to more closely pair containers of similar weights, but is much, much slower, especially as the number of containers increases.
We use LegacySLL`Private`centrifugeBalance in the compile and parse, but we use this for speed purposes here to decide on groupings. Anything paired off here should also be pairable by centrifugeBalance.
*)

pairContainers[myContainerWeightPairs:{{ObjectP[{Object[Container], Model[Container]}], MassP}..}, myMaxImbalance:GreaterEqualP[0Gram]] := Module[
	{balancingGroups, mixGroups, pairedContainers, unpairedContainers},

	(* split containers into groups of similiar weights within the rotor imbalance range: {{within imbalance range containers}..,{single unpaired container}..} *)
	balancingGroups = Gather[myContainerWeightPairs, Abs[#1[[2]] - #2[[2]]] <= myMaxImbalance&];

	(* split the {within imbalance range containers}.. into pairs: {{paired containers}..,{single unpaired container}..} *)
	(* This will not necessarily generate the pairs with the smallest mass difference! *)
	mixGroups = Flatten[PartitionRemainder[#, 2]& /@ balancingGroups, 1];

	(* get a list of paired and unpaired containers *)
	pairedContainers = Cases[mixGroups, {{ObjectP[{Object[Container], Model[Container]}], _?MassQ}, {ObjectP[{Object[Container], Model[Container]}], _?MassQ}}];
	unpairedContainers = Cases[mixGroups, {{obj:ObjectP[{Object[Container], Model[Container]}], mass:_?MassQ}} :> {obj, mass}];

	(* Return the paired container/mass pairs and the unpaired container/masses *)
	Flatten[{pairedContainers, unpairedContainers}, 1]
];
