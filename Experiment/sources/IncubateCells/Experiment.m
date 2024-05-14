(* ::Package:: *)

(* ::Title:: *)
(*Experiment IncubateCells: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentIncubateCells*)


(* ::Subsection::Closed:: *)
(*Options*)
DefineOptions[
	ExperimentIncubateCells,
	Options :> {
		{
			OptionName -> Time,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Hour, $MaxCellIncubationTime],(*72 Hour*)
				Units ->  {Hour, {Hour, Day}}
			],
			Description -> "The duration during which the input cells are incubated inside of cell incubators.",
			ResolutionDescription -> "If Preparation is set to Manual, automatically set to the DoublingTime of the cells in the sample. If Preparation is set to Robotic, automatically set to the shorter time of 1 Hour and the DoublingTime of the cells in the sample.",
			Category -> "General"
		},
		(*Index-matching options*)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Incubator,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, Incubator], Object[Instrument, Incubator]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Mammalian Cell Culture"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Bacterial Cell Culture"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Yeast Cell Culture"
						},
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Storage Devices",
							"Incubators",
							"Custom Cell Culture"
						}
					}
				],
				Description -> "The instrument used to cultivate cell cultures under specified conditions, including, Temperature, CarbonDioxide, RelativeHumidity, ShakingRate, and ShakingRadius.",
				ResolutionDescription -> "If Preparation is set to Robotic, automatically set to Model[Instrument, Incubator, \"STX44-ICBT with Humidity Control\"] for Mammalian cell culture, or set to Model[Instrument, Incubator, \"STX44-ICBT with Shaking\"] for Bacterial and Yeast cell culture. If Preparation is Manual, is automatically set to an incubator that meets the requirements of desired incubation conditions (CellType, Temperature, CarbonDioxide, RelativeHumidity, Shake) and footprint of the container of the input sample. See the helpfile of the function IncubateCellsDevices for more information about operating parameters of all incubators." ,
				Category -> "General"
			},
			{
				OptionName -> CellType,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Bacterial, Mammalian, Yeast]
				],
				Description -> "The type of the most abundant cells that are thought to be present in this sample.",
				ResolutionDescription -> "Automatically set to match the value of CellType of the input sample if it is populated, or set to Mammalian if CultureAdhesion is Adherent or if WorkCell is bioSTAR. If there are multiple cell types in the input sample or if the cell type is unknown, automatically set to Null.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> CultureAdhesion,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CultureAdhesionP(*Adherent | Suspension | SolidMedia*)
				],
				Description -> "The manner of cell growth the cells in the sample are thought to employ (i.e., SolidMedia, Suspension, and Adherent). SolidMedia cells grow in colonies on a nutrient rich substrate, suspended cells grow free floating in liquid media, and adherent cells grow as a monolayer attached to a substrate.",
				ResolutionDescription -> "Automatically set to match the CultureAdhesion value of the input sample if it is populated. Otherwise set to Suspension.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> IncubationCondition,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Incubation Type" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[
							MammalianIncubation,
							BacterialIncubation,
							BacterialShakingIncubation,
							YeastIncubation,
							YeastShakingIncubation,
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
				Description -> "The type of incubation that defines the Temperature, Carbon Dioxide Percentage, Relative Humidity, Shaking Rate and Shaking Radius, under which the input cells are incubated. Custom incubation actively selects an incubator in the lab and uses a thread to incubate only the cells from this protocol for the specified Time. Selecting an IncubationCondition, through a symbol or an object, will passively store the cells for the specified time in a shared incubator, potentially with samples from other protocols. However, it will not consume a thread while the cells are inside the incubator. Currently, MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, and YeastShakingIncubation are supported cell culture incubation conditions with shared incubators.",
				ResolutionDescription -> "Automatically set to a storage condition matching specified CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, ShakingRate and ShakingRadius options, or set to Custom if no existing storage conditions can provide specified incubation condition options. If no Temperature, RelativeHumidity, CarbonDioxide, ShakingRate, or ShakingRadius are provided, automatically set based on the CellType and CultureAdhesion as described in the below table.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Preset Temperature" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationTemperatureP (* 30 C, 37 C *)
					],
					"Custom Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinCellIncubationTemperature, $MaxCellIncubationTemperature], (* 28 Celsius, 80 Celsius *)
						Units -> Celsius
					]
				],
				Description -> "Temperature at which the input cells are incubated. Currently, 30 Degrees Celsius and 37 Degrees Celsius are supported by default cell culture incubation conditions. Alternatively, a customized temperature can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the Temperature field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 37 Celsius if CellType is Bacterial or Mammalian, or 30 Celsius if CellType is Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> RelativeHumidity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Preset Relative Humidity" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationRelativeHumidityP (* 93 Percent *)
					],
					"Custom Relative Humidity" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					]
				],
				Description -> "Percent humidity at which the input cells are incubated. Currently, 93% Relative Humidity is supported by default cell culture incubation conditions. Alternatively, a customized relative humidity can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the RelativeHumidity field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 93% if CellType is Mammalian, or Null if CellType is Bacterial or Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> CarbonDioxide,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Preset Carbon Dioxide Percentage" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationCarbonDioxideP (* 5 Percent *)
					],
					"Custom Carbon Dioxide Percentage" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, $MaxCellIncubationCarbonDioxide],(*20 Percent*)
						Units -> Percent
					]
				],
				Description -> "Percent CO2 at which the input cells are incubated. Currently, 5% Carbon Dioxide is supported by default cell culture incubation conditions. Alternatively, a customized carbon dioxide percentage can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "Automatically set to match the CarbonDioxide field of specified IncubationCondition, see below table. If IncubationCondition is not provided, automatically set to 5% if CellType is Mammalian, or Null if CellType is Bacterial or Yeast.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> Shake,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the input cells are shaken during incubation.",
				ResolutionDescription -> "Automatically set to True if ShakingRate or ShakingRadius are provided, or if IncubationCondition is BacterialShakingIncubation or YeastShakingIncubation. Otherwise, set to False.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> ShakingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Preset Shaking Rate" -> Widget[
						Type -> Enumeration,
						Pattern :> CellIncubationShakingRateP(*200RPM,250RPM,400RPM*)
					],
					"Custom Shaking Rate" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinCellIncubationShakingRate, $MaxCellIncubationShakingRate],(*20RPM,1000RPM*)
						Units -> RPM
					]
				],
				Description -> "The frequency at which the sample is agitated by movement in a circular motion. Currently, 200 RPM, 250 RPM and 400 RPM are supported by preset cell culture incubation conditions with shaking. Alternatively, a customized shaking rate can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				ResolutionDescription -> "If Shake is True, automatically set match the ShakingRate value of specified IncubationCondition if it is provided. If IncubationCondition is not provided, automatically set to 400 RPM if the input sample is in a plate, or 250 RPM if the input sample is bacterial and in a vessel, or 200 RPM if the input sample is yeast and in a vessel.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> ShakingRadius,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellIncubatorShakingRadiusP (*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
				],
				Description -> "The radius of the circle of orbital motion applied to the sample during incubation. The MultitronPro Incubators for plates has a 25 mm shaking radius, and the Innova Incubators have a 25.4 Millimeter shaking radius. See the Instrumentation section of the helpfile for more information.",
				ResolutionDescription -> "If Shake is True, automatically set to match the ShakingRadius value of specified IncubationCondition if it is provided, or set to the shaking radius of incubator.",
				Category -> "Incubation Condition"
			},
			{
				OptionName -> SamplesOutStorageCondition,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP|Disposal
				],
				Description -> "The conditions under which samples will be stored after the protocol is completed.",
				ResolutionDescription -> "If IncubationCondition is Custom, automatically set based on the CellType and CultureAdhesion of the cells. If CellType and CultureAdhesion are unknown, automatically set to BacterialIncubation if the container is a shallow plate, or BacterialShakingIncubation otherwise. If IncubationCondition is not Custom, automatically set to the IncubationCondition.",
				Category -> "Post Experiment"
			}
		],

		(* Shared Options *)
		ProtocolOptions,
		PreparationOption,
		WorkCellOption,
		CacheOption,
		SimulationOption
	}
];

(* To avoid occupying Robotic WorkCell too long, we have a limit for the max duration of cell culture within LiquidHandlerIntegrated incubator *)
$RoboticIncubationTimeThreshold = 1 Hour;

(* ::Subsection::Closed:: *)
(*ExperimentIncubateCells *)

(* ::Subsection:: *)
(* Container and Prepared Samples Overload *)
ExperimentIncubateCells[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions: OptionsPattern[]] := Module[
	{
		listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, containerToSampleOutput,
		samples, sampleOptions, containerToSampleTests, containerToSampleSimulation, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, updatedSimulation, validSamplePreparationResult
	},

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
			ExperimentIncubateCells,
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
			ExperimentIncubateCells,
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
				ExperimentIncubateCells,
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
		ExperimentIncubateCells[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(*---Main function accepting sample objects as inputs---*)
ExperimentIncubateCells[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, safeOps,
		safeOpsTests, validLengths, validLengthTests, uploadProtocolOptions, performSimulationQ, templatedOptions,
		templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult, simulatedProtocol, simulation,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, resourcePacketTests,
		instruments, incubationStorageConditions, sampleFields, modelSampleFields, objectContainerFields, modelContainerFields,
		incubatorRacks, incubatorDecks, incubatorInstrumentFields, incubatorRackFields, incubatorDeckFields,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation, safeOptionsNamed,
		samplesWithPreparedSamples, optionsWithPreparedSamples, upload, confirm, fastTrack, parentProtocol, cache,
		downloadedStuff, resolvedPreparation, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly,
		returnEarlyBecauseFailuresQ, protocolPacketWithResources, parentProtocolStack, totalTimesEstimate, result,
		rootProtocol, overclockPacket
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
			ExperimentIncubateCells,
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
		SafeOptions[ExperimentIncubateCells, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentIncubateCells, listedOptions, AutoCorrect -> False], {}}
	];

	(* Replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentIncubateCells, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentIncubateCells, {listedSamples}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentIncubateCells, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentIncubateCells, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			RunTime -> 0 Minute
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentIncubateCells, {ToList[listedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Get the incubator instruments in the lab that are not deprecated. *)
	instruments = Flatten[{
		nonDeprecatedIncubatorsSearch["Memoization"],
		Cases[KeyDrop[ToList[myOptions],{Cache,Simulation}], ObjectReferenceP[{Object[Instrument, Incubator], Model[Instrument, Incubator]}], Infinity]
	}];

	(*Get all the possible incubator racks and decks that are not deprecated*)
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	(* get all the incubation storage conditions *)
	incubationStorageConditions = allIncubationStorageConditions["Memoization"];

	(*Instrument, rack, and deck fields*)
	(* TODO possibly just kill this one too because I don't see why we'd need this in more than one place (maybe need it in IncubateCellsDevices) *)
	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Sample Fields. *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	downloadedStuff = Check[
		Quiet[
			Download[
				{
					(* Download {CellTypes,ShakingRadius,Positions,MinTemperature,MaxTemperature,MinCO2,MaxCO2,MinHumidity,MaxHumidity} from our instruments. *)
					ToList[listedSamples],
					instruments,
					incubatorRacks,
					incubatorDecks,
					incubationStorageConditions,
					{parentProtocol} /. {Null -> Nothing}
				},
				{
					{
						sampleFields,
						Packet[Model[modelSampleFields]],
						Packet[Container[objectContainerFields]],
						Packet[Container[Model][modelContainerFields]],
						Packet[Composition[[All, 2]][{CellType, CultureAdhesion, DoublingTime}]]
					},
					{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
					{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
					{Evaluate[Packet[Sequence @@ incubatorDeckFields]]},
					{Packet[StorageCondition, CellType, CultureHandling, Temperature, Humidity, Temperature, CarbonDioxide, ShakingRate, VesselShakingRate, PlateShakingRate, ShakingRadius]},
					{Object, ParentProtocol..[Object]}
				},
				Cache -> cache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Pull out the parent protocol stack *)
	parentProtocolStack = Flatten[downloadedStuff[[6]]];

	(* Return early if objects do not exist *)
	If[MatchQ[downloadedStuff, $Failed],
		Return[$Failed]
	];
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentIncubateCellsOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentIncubateCellsOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption,Error::ConflictingUnitOperationMethodRequirements}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentIncubateCells,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* Lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	(* for now, just returning early always *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{protocolPacketWithResources, resourcePacketTests} = If[returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
		{$Failed, {}},
		If[gatherTests,
			incubateCellsResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> {Result, Tests}
			],
			{
				incubateCellsResourcePackets[
					samplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					collapsedResolvedOptions,
					Cache -> cacheBall,
					Simulation -> updatedSimulation
				],
				{}
			}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, updatedSimulation},
		performSimulationQ,
			simulateExperimentIncubateCells[
				protocolPacketWithResources[[1]], (* protocolPacket *)
				Flatten[ToList[protocolPacketWithResources[[2]]]], (* unitOperationPackets *)
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True, {Null, Null}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* Determine the root protocol here and then use that to mark it as Overclock -> True *)
	(* IncubateCells protocols need Overclock -> True in order to ensure that even if the queue is full, we can handle the cells in a timely fashion *)
	(* Only need to bother if we're doing Manual or if we haven't failed in the resource packets *)
	rootProtocol = Which[
		MatchQ[resolvedPreparation, Robotic], Null,
		MatchQ[protocolPacketWithResources, $Failed], Null,
		NullQ[parentProtocol], Lookup[protocolPacketWithResources[[1]], Object],
		True, Last[parentProtocolStack]
	];
	(* only add an overclocking packet for the root protocol if we are a subprotocol here *)
	(* doing this because UploadProtocol behaves oddly when you are uploading a packet and also have a different packet for the same object in the accessory packets overload *)
	(* thus, if this IncubateCells is the root protocol, we will have already populated that field in the resource packets function *)
	overclockPacket = If[MatchQ[rootProtocol, ObjectP[]] && Not[NullQ[parentProtocol]],
		<|Object -> rootProtocol, Overclock -> True|>,
		Nothing
	];

	(* Estimate the time; this is solely based on the Time option+some buffer*)
	totalTimesEstimate = 1.5 * Lookup[resolvedOptions, Time];

	(* Put the UploadProtocol options together so we don't have to type them out multiple times*)
	(* making it a sequence because UploadProtocol misbehaves with lists sometimes *)
	uploadProtocolOptions = Sequence[
		Upload -> Lookup[safeOps, Upload],
		Confirm -> Lookup[safeOps, Confirm],
		ParentProtocol -> Lookup[safeOps, ParentProtocol],
		Priority -> Lookup[safeOps, Priority],
		StartDate -> Lookup[safeOps, StartDate],
		HoldOrder -> Lookup[safeOps, HoldOrder],
		QueuePosition -> Lookup[safeOps, QueuePosition],
		ConstellationMessage -> {Object[Protocol, IncubateCells]},
		Cache -> cacheBall,
		Simulation -> updatedSimulation
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps, Upload], False],
			ToList[protocolPacketWithResources[[2]]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions},
				(* Create our IncubateCells primitive to feed into RoboticSamplePreparation. *)
				primitive = IncubateCells @@ Join[
					{
						Sample -> mySamples
					},
					RemoveHiddenPrimitiveOptions[IncubateCells, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentIncubateCells, resolvedOptions];

				(* Memoize the value of ExperimentTransfer so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentIncubateCells, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					DownValues[ExperimentIncubateCells] = {};

					ExperimentIncubateCells[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> protocolPacketWithResources[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> totalTimesEstimate
						}
					];
					Module[{resolvedWorkCell},
						(* Look up which workcell we've chosen *)
						resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

						(* Run the experiment *)
						ExperimentRoboticCellPreparation[
							{primitive},
							{
								Name -> Lookup[nonHiddenOptions, Name],
								Upload -> Lookup[safeOps, Upload],
								Confirm -> Lookup[safeOps, Confirm],
								ParentProtocol -> Lookup[safeOps, ParentProtocol],
								Priority -> Lookup[safeOps, Priority],
								StartDate -> Lookup[safeOps, StartDate],
								HoldOrder -> Lookup[safeOps, HoldOrder],
								QueuePosition -> Lookup[safeOps, QueuePosition],
								Cache -> cacheBall
							}
						]
					]
				]
			],

		(* Actually upload our protocol object.  This is only for Manual. *)
		(* Note that since we only make batched unit operations sometimes and UploadProtocol can't take {} as the second argument, need to do this two different times *)
		MatchQ[ToList[protocolPacketWithResources[[2]]], {}] && Not[MatchQ[overclockPacket, PacketP[]]],
			UploadProtocol[
				(* protocol packet*)
				protocolPacketWithResources[[1]],
				uploadProtocolOptions
			],
		True,
			UploadProtocol[
				(* protocol packet *)
				protocolPacketWithResources[[1]],
				(* unit operation packets *)
				Flatten[{protocolPacketWithResources[[2]], overclockPacket}],
				uploadProtocolOptions
			]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> If[MatchQ[resolvedPreparation, Robotic],
			collapsedResolvedOptions,
			RemoveHiddenOptions[ExperimentIncubateCells, collapsedResolvedOptions]
		],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> totalTimesEstimate
	}
];


(* ::Subsubsection::Closed:: *)
(*Errors and warnings *)

Error::InvalidPlateSamples = "Sample(s) `1` are found in the same container as input sample(s) `2` but they are not specified as input samples. Since a plate is stored inside of the cell incubator as a whole during cell culture, please transfer sample(s) into an empty container beforehand.";
Error::UnsealedCellCultureVessels = "The sample(s) `1` at indices `2` are in a container `3` without any cover. Please cover `3` with suitable lid or cap beforehand.";
Error::UnsupportedCellTypes = "The CellType option of sample `1` at indices `2` is set to `3`. Currently, only Mammalian, Bacterial and Yeast cell culture are supported. Please contact us if you have a sample that falls outside our current support.";
Error::ConflictingWorkCells = "The following requirements can only be performed on a bioSTAR: `1`. However, the following requirements can only be performed on a microbioSTAR: `2`. Please resolve this conflict in order to submit a valid IncubateCells protocol or unit operation.";
Error::ConflictingWorkCellWithPreparation = "WorkCell option is set at `1` and Preparation option is set at `2`. If Preparation is Manual, WorkCell must be Null; if Preparation is Robotic, WorkCell must be populated. Please correct the values.";
Error::ConflictingPreparationWithIncubationTime = "Preparation option is set at `1` and Time is set at `2`. When Preparation is set at Robotic, samples are stored in a liquid handler integrated cell incubator temporarily before robotic cell preparation. Please shorten the Time to 1 Hour or less or select Manual Preparation.";
Warning::CellTypeNotSpecified = "The sample(s) `1` have no CellType specified in the options or Object. For these sample(s), the CellType is defaulting to Bacterial. If this is not desired, please specify a CellType.";
Warning::CultureAdhesionNotSpecified = "The sample(s) `1` at indices `2` have no CultureAdhesion specified in the options or Object. For these sample(s), the CultureAdhesion is defaulting to `3`. If this is not desired, please specify a CultureAdhesion.";
Warning::CustomIncubationConditionNotSpecified = "For sample(s) `1` at indices `2` have IncubationCondition specified as Custom and option(s) `3` are defaulting to `4`. If this is not desired, please specify value for `3`.";
Error::InvalidIncubationConditions = "The sample(s) `1` at indices `2` have an IncubationCondition  specified as `3`. Currently, the supported default incubation conditions are MammalianIncubation, BacterialIncubation, BacterialShakingIncubation, YeastIncubation, and YeastShakingIncubation. If you have a desired IncubationCondition that falls outside our current default incubation conditions, please choose Custom and specify Temperature, CarbonDioxide, RelativeHumidity, ShakingRate and ShakingRadius options.";
Error::TooManyCustomIncubationConditions = "The sample(s) `1` have been specified to use different custom incubator(s) `2`, but only one custom incubator can be used per protocol (currently `3`). For these sample(s), either utilize default incubation conditions to use shared incubator devices, or split the experiment call into separate protocols.";
Error::ConflictingCellType = "The sample(s) `1` at indices `2` have a CellType specified in the option as `3` and CellType of the Object as `4`. For these sample(s), please specify the same CellType as the Object or let the option be set automatically.";
Error::ConflictingCultureAdhesion = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` that does not match the current CultureAdhesion of the sample Object(s) `4`. For these sample(s), please specify the same CultureAdhesion as the Object or let the option be set automatically.";
Error::ConflictingShakingConditions = "The sample(s) `1` at indices `2` are specified with conflicting options for Shake (`3`), ShakingRate (`4`), and ShakingRadius (`5`). When Shake is True, ShakingRate and ShakingRadius must be populated. When Shake is False, ShakingRate and ShakingRadius should be Null. For these sample(s), please change these options to a valid combination or let them be set automatically.";
Error::UnsupportedCellCultureType = "The sample(s) `1` at indices `2` require Mammalian Suspension Cell Culture. Currently only Mammalian Adherent Cell Culture is supported. Please contact us if you have a sample that falls outside our current support.";
Error::ConflictingCellTypeWithCultureAdhesion = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` and CellType specified in the option as `4`. When CellType is Mammalian, CultureAdhesion cannot be SolidMedia. When CellType is Bacterial or Yeast, CultureAdhesion cannot be Adherent. For these sample(s), please change these options to specify a valid protocol.";
Error::ConflictingCellTypeWithIncubator = "The sample(s) `1` at indices `2` have a CellType specified or automatically set in the option as `3` and Incubator specified as `4`. Incubator(s) `4` are only compatible with CellTypes `5`. Please change these options to specify a valid protocol.";
Error::ConflictingCultureAdhesionWithContainer = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3`. When samples are in plates, CultureAdhesion should be Adherent for liquid media and SolidMedia for solid media. For these sample(s), please specify the same CultureAdhesion as the Object or let the option be set automatically.";
Error::ConflictingIncubationConditionsForSameContainer = "The sample(s) `1` have different incubation settings `2`, but are in the same container as another sample. For these sample(s), either transfer to different containers, allow the conflicting incubation options to be set automatically, or specify the same incubation conditions for each sample in the same container.";
Error::ConflictingCellTypeWithStorageCondition = "The sample(s) `1` at indices `2` have a CellType specified in the option as `3` and SamplesOutStorageCondition specified in the option as `4`. `4` is not compatible with `3`. For these sample(s), please change these options to specify a valid protocol.";
Error::ConflictingCultureAdhesionWithStorageCondition = "The sample(s) `1` at indices `2` have a CultureAdhesion specified in the option as `3` and SamplesOutStorageCondition specified in the option as `4`. `4` is not compatible with `3`. For these sample(s), please change these options to specify a valid protocol.";
Error::IncubationMaxTemperature = "The sample(s) `1` at indices `2` are in container(s) `3`, which have MaxTemperature(s) of, `4`. For these sample(s), Temperature cannot be set above the MaxTemperature of the given container(s). Please change these options to specify a valid protocol.";
Error::NoCompatibleIncubator = "The sample(s) `1` at indices `2` have no cell incubator instruments that are compatible with the footprint of the sample container and the option(s) specified (including specified incubator(s)).  To see the instruments that are compatible with this sample, use the function IncubateCellsDevices.";
Error::DuplicateSamples = "The following sample(s) `1` are specified more than once.  Please only specify a sample as an input one time in a given experiment call.";
Error::TooManyIncubationSamples = "The following incubator(s) `1` have enough space for `2` `3`, but `4` were specified instead.  Please split the experiment call into multiple in order to not exceed the capacity of the incubators.";

(* ::Subsubsection::Closed:: *)
(*resolveExperimentIncubateCellsOptions *)

DefineOptions[
	resolveExperimentIncubateCellsOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentIncubateCellsOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentIncubateCellsOptions]] := Module[
	{
		(* Setup *)
		outputSpecification, output, gatherTests, messages, notInEngine, cacheBall, simulation, fastAssoc,  confirm, template,
		fastTrack, operator, parentProtocol, upload, outputOption, samplePackets, sampleModelPackets, sampleContainerPackets,
		sampleContainerModelPackets, sampleContainerHeights, sampleContainerFootprints, fastAssocKeysIDOnly, incubatorPackets,
		rackPackets, deckPackets, storageConditionPackets, incubationConditionOptionDefinition, allowedStorageConditionSymbols,
		customIncubatorPackets, customIncubators,
		(* Input invalidation check *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples,
		invalidCellTypePositions, invalidCellTypeCellTypes, invalidCellTypeTest, inputContainerContents, stowawaySamples,
		invalidPlateSampleInputs, invalidPlateSampleTest, talliedSamples, duplicateSamples, duplicateSamplesTest,
		(* Option precision check *)
		roundedIncubateCellsOptions, precisionTests,
		(* MapThread propagation*)
		mapThreadFriendlyOptionsNotPropagated, mapThreadFriendlyOptions, indexMatchingOptionNames, nonAutomaticOptionsPerContainer,
		mergedNonAutomaticOptionsPerContainer,
		(* Conflicting Check I *)
		preparationResult, allowedPreparation, preparationTest, resolvedPreparation, roboticPrimitiveQ, workCellResult,
		allowedWorkCell, workCellTest, resolvedWorkCell, conflictingWorkCellAndPreparationQ, conflictingWorkCellAndPreparationOptions,
		conflictingWorkCellAndPreparationTest, specifiedTime, incompatiblePreparationAndTimeQ, incompatiblePreparationAndTimeOptions,
		incompatiblePreparationAndTimeTest, coveredContainerQs, uncoveredSamples, uncoveredSamplePositions, uncoveredContainers,
		uncoveredSampleInputs, uncoveredContainerTest,
		(* Single General option Time *)
		allDoublingTimes, resolvedTime,
		(* MapThread IncubationCondition options and errors *)
		optionsToPullOut, cellTypes, cultureAdhesions, temperatures, carbonDioxidePercentages, relativeHumidities,
		shaking, shakingRates, semiResolvedShakingRadii, samplesOutStorageCondition, incubationCondition, cellTypesFromSample,
		cultureAdhesionsFromSample, conflictingShakingConditionsErrors, conflictingCellTypeErrors, conflictingCultureAdhesionErrors,
		invalidIncubationConditionErrors, conflictingCellTypeAdhesionErrors, unsupportedCellCultureTypeErrors,
		conflictingCellTypeWithIncubatorErrors, conflictingCultureAdhesionWithContainerErrors,
		conflictingCellTypeWithStorageConditionErrors, conflictingCultureAdhesionWithStorageConditionErrors,
		cellTypeNotSpecifiedWarnings, cultureAdhesionNotSpecifiedWarnings, customIncubationConditionNotSpecifiedWarnings,
		unspecifiedMapThreadOptions,
		(* Incubators *)
		sampleContainerModels, possibleIncubatorPackets, possibleIncubators, incubators, resolvedShakingRadiiPreRounding,
		resolvedShakingRadii,
		(* Combine *)
		email, resolvedOptions, resolvedMapThreadOptions,
		(* Unresolvable option check *)
		containersToSamples, incubatorsToContainers, incubatorFootprints, incubatorsOverCapacityAmounts,
		(* Conflicting Check II *)
		tooManySamples, tooManySamplesTest, groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer,
		samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors, conflictingIncubationConditionsForSameContainerOptions,
		conflictingIncubationConditionsForSameContainerTests, temperatureAboveMaxTemperatureQs, incubationMaxTemperatureOptions,
		incubationMaxTemperatureTests, resolvedUnspecifiedOptions, customIncubationWarningSamples, customIncubationWarningPositions,
		customIncubationWarningUnspecifiedOptionNames, customIncubationWarningResolvedOptions, customIncubationNotSpecifiedTest,
		noCompatibleIncubatorErrors, noCompatibleIncubatorTests, noCompatibleIncubatorsInvalidInputs, firstCustomIncubator,
		invalidCustomIncubatorsTests, invalidCustomIncubatorsOptions, invalidCustomIncubatorsErrors,
		invalidShakingConditionsOptions, invalidShakingConditionsTests, conflictingCellTypeOptions, conflictingCellTypeTests,
		conflictingCultureAdhesionOptions, conflictingCultureAdhesionTests, cellTypeNotSpecifiedTests, cultureAdhesionNotSpecifiedTests,
		invalidIncubationConditionOptions, invalidIncubationConditionTest, conflictingCellTypeAdhesionOptions,
		conflictingCellTypeAdhesionTests, unsupportedCellCultureTypeOptions, unsupportedCellCultureTypeTests,
		conflictingCellTypeWithIncubatorOptions, conflictingCellTypeWithIncubatorTests,
		incubatorOverCapacityIncubators,  incubatorOverCapacityCapacities, incubatorsOverCapacityFootprints,
		incubatorsOverCapacityQuantities, conflictingCultureAdhesionWithContainerOptions, conflictingCultureAdhesionWithContainerTests,
		conflictingCellTypeWithStorageConditionOptions, conflictingCellTypeWithStorageConditionTests,
		conflictingCultureAdhesionWithStorageConditionOptions, conflictingCultureAdhesionWithStorageConditionTests,
		(* Wrap up *)
		invalidInputs, invalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine = !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function, and convert it to a fastAssoc for quick lookups *)
	cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the options that do not need to be resolved directly from SafeOptions. *)
	{confirm, template, fastTrack, operator, parentProtocol, upload, outputOption} = Lookup[
		myOptions,
		{Confirm, Template, FastTrack, Operator, ParentProtocol, Upload, Output}
	];

	(* Pull out packets from the fast association *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	sampleModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ mySamples;
	sampleContainerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	sampleContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ mySamples;

	(* Get the height of the containers and the footprint (will be needed later) *)
	{sampleContainerHeights, sampleContainerFootprints} = Transpose[Map[
		{
			(* Dimensions must be populated here; otherwise this will throw an error, but that is probably ok because if we have no Dimensions we are hosed no matter what *)
			Lookup[#, Dimensions][[3]],
			Lookup[#, Footprint]
		}&,
		sampleContainerModelPackets
	]];

	(* the incubators/racks/decks are straightforward enough to get here by just matching on the types *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	incubatorPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Incubator]]];
	rackPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Rack]]];
	deckPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Deck]]];
	storageConditionPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];

	(* Pull out the allowed storage condition symbols for the IncubationCondition option *)
	incubationConditionOptionDefinition = FirstCase[OptionDefinition[ExperimentIncubateCells], KeyValuePattern["OptionName" -> "IncubationCondition"]];
	allowedStorageConditionSymbols = Cases[Lookup[incubationConditionOptionDefinition, "SingletonPattern"], SampleStorageTypeP|Custom, Infinity];

	(* Custom incubators objects and models. If ProvidedStorageCondition is Null, then they must be custom incubators *)
	(* don't love this hard coding *)
	customIncubatorPackets = Cases[incubatorPackets, KeyValuePattern[ProvidedStorageCondition -> Null]];
	customIncubators = Lookup[customIncubatorPackets, Object, {}];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1.) Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 2.) Get whether the samples have deprecated models. *)
	deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];
	deprecatedSampleModelInputs = Lookup[deprecatedSampleModelPackets, Object, {}];
	deprecatedSampleInputs = Lookup[
		PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]],
		Object,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedSampleModelInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[deprecatedSampleInputs, Cache -> cacheBall] <> " have models that are not Deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, deprecatedSampleInputs], Cache -> cacheBall] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 3.) Get whether the input cell types are supported *)

	(* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
	mainCellIdentityModels = Map[
		Function[{composition},
			(* this gets the composition sorted in order of its concentration, where the first is the most concentrated *)
			With[{reverseSortedIdentityModels = ReverseSortBy[composition, First][[All, 2]]},
				Download[SelectFirst[reverseSortedIdentityModels, MatchQ[#, ObjectP[Model[Cell]]]&, Null], Object]
			]
		],
		Lookup[samplePackets, Composition, {}]
	];

	(* Determine what kind of cells the input samples are *)
	sampleCellTypes = MapThread[
		Function[{samplePacket, modelPacket, mainCellIdentityModel},
			Which[
				MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
				!NullQ[modelPacket] && MatchQ[Lookup[modelPacket, CellType], CellTypeP] && MatchQ[modelPacket, PacketP[]], Lookup[modelPacket, CellType],
				MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]], fastAssocLookup[fastAssoc, mainCellIdentityModel, CellType],
				True, Null
			]
		],
		{samplePackets, sampleModelPackets, mainCellIdentityModels}
	];
	(* Note here that Null is acceptable because we're going to assume it's Bacterial later *)
	validCellTypeQs = MatchQ[#, Mammalian|Yeast|Bacterial|Null]& /@ sampleCellTypes;
	invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
	invalidCellTypePositions = First /@ Position[validCellTypeQs, False];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[Error::UnsupportedCellTypes, ObjectToString[invalidCellTypeSamples, Cache -> cacheBall], invalidCellTypePositions, invalidCellTypeCellTypes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCellTypeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 4.) Get whether there are stowaway samples inside the input plates.  We're forbidding users from incubating samples when there are other samples in the plate already *)
	inputContainerContents = Lookup[sampleContainerPackets, Contents];
	stowawaySamples = Map[
		Function[{contents},
			Module[{contentsObjects},
				contentsObjects = Download[contents[[All, 2]], Object];
				Select[contentsObjects, Not[MemberQ[mySamples, #]]&]
			]
		],
		inputContainerContents
	];
	invalidPlateSampleInputs = Lookup[
		PickList[samplePackets, stowawaySamples, Except[{}]],
		Object,
		{}
	];

	If[Length[invalidPlateSampleInputs] > 0 && messages,
		Message[Error::InvalidPlateSamples, ObjectToString[#, Cache -> cacheBall]& /@ DeleteCases[stowawaySamples, {}], ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall] <> " are in containers that do not have other, not-provided samples in them:", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall] <> " are in containers that do not have other, not-provided samples in them:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 5.) Throw an error if we have duplicate samples provided *)
	talliedSamples = Tally[mySamples];
	duplicateSamples = Cases[talliedSamples, {sample_, tally:GreaterEqualP[2]} :> sample];

	If[Length[duplicateSamples] > 0 && messages,
		Message[Error::DuplicateSamples, ObjectToString[duplicateSamples, Cache -> cacheBall]]
	];
	duplicateSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicateSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[duplicateSamples, Cache -> cacheBall] <> " have not been specified more than once:", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, duplicateSamples], Cache -> cacheBall] <> " have not been specified more than once:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(*-- OPTION PRECISION CHECKS --*)

	{roundedIncubateCellsOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			(* dropping these two keys because they are often huge and make variables unnecssarily take up memory + become unreadable *)
			KeyDrop[Association[myOptions], {Cache, Simulation}],
			{Temperature, Time, CarbonDioxide, RelativeHumidity, ShakingRate},
			{1 Celsius, 1 Minute, 1 Percent, 1 Percent, 1 RPM},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				(* dropping these two keys because they are often huge and make variables unnecssarily take up memory + become unreadable *)
				KeyDrop[Association[myOptions], {Cache, Simulation}],
				{Temperature, Time, CarbonDioxide, RelativeHumidity, ShakingRate},
				{1 Celsius, 1 Minute, 1 Percent, 1 Percent, 1 RPM}
			],
			Null
		}
	];


	(* --- Propagate options specified for one sample in a container to all the other samples in that same container --- *)

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptionsNotPropagated = OptionsHandling`Private`mapThreadOptions[ExperimentIncubateCells, roundedIncubateCellsOptions];

	(* Make rules associating a given input container with the suite of specified options *)
	indexMatchingOptionNames = ToExpression[Lookup[
		Select[OptionDefinition[ExperimentIncubateCells], Not[NullQ[Lookup[#, "IndexMatchingInput"]]]&],
		"OptionName",
		{}
	]];
	nonAutomaticOptionsPerContainer = MapThread[
		Function[{sample, options},
			(* this is a weird use of Select *)
			(* basically select all the instances of our index matching options that don't have Automatic and return that association *)
			fastAssocLookup[fastAssoc, sample, {Container, Object}] -> Select[
				KeyTake[options, indexMatchingOptionNames],
				Not[MatchQ[#, Automatic]]&
			]
		],
		{mySamples, mapThreadFriendlyOptionsNotPropagated}
	];

	(* Merging them together is super weird because we call Merge twice! *)
	(* the format of the input will be something like this: *)
	(* {container1 -> <|Temperature -> 30 Celsius|>, container1 -> <|RelativeHumidity -> 94 Percent|>, container2 -> <||>} *)
	(* Merge[..., Merge[#, First] & ] will convert this to <|container1 -> <|Temperature -> 30 Celsius, RelativeHumidity -> 94 Percent|>, container2 -> <||>|> *)
	(* If I just did Merge[..., Join] then I would end up with <|container1 -> {<|Temperature -> 30 Celsius|>, <|RelativeHumidity -> 94 Percent|>}, container2 -> {<||>}|>*)
	(* that gets me part of the way there, but I need to merge the interior associations too *)
	(* the First part is also weird; if I put Join there then I end up with a list, when really I want only one value per container *)
	(* if someone happens to give me something like the following: *)
	(* {container1 -> <|Temperature -> 30 Celsius|>, container1 -> <|Temperature -> 37 Celsius|>, container2 -> <||>}*)
	(* then my First here does lose the information of the 37 Celsius; however, that is ok because in this case we are going to be throwing an error message later for conflicting incubation conditions *)
	(* thus, it doesn't really matter what I resolve to for the _other_ automatics, because both values will be invalid anyway *)
	mergedNonAutomaticOptionsPerContainer = Merge[nonAutomaticOptionsPerContainer, Merge[#, First] &];

	(* Propagate the options I am dealing with out *)
	mapThreadFriendlyOptions = MapThread[
		Function[{sample, options},
			(* Join the options we already have with the ones we're propagating out *)
			(* the Join will cause the second set of options to replace the first set if possible *)
			Join[
				options,
				Module[{container, containerOptions},
					(* get the container of the sample in question, and the associated options we want to propagate across this container that we calculated above *)
					container = fastAssocLookup[fastAssoc, sample, {Container, Object}];
					containerOptions = Lookup[mergedNonAutomaticOptionsPerContainer, container, <||>];

					(* for each option, if *)
					(* 1.) The specified value for that option is Automatic for the given sample *)
					(* 2.) A different sample in the same container has a value that is not Automatic *)
					(* then we propagate the non-Automatic value in the same container to this sample too *)
					Association[Map[
						Function[{optionName},
							If[MatchQ[Lookup[options, optionName], Automatic] && KeyExistsQ[containerOptions, optionName],
								optionName -> Lookup[containerOptions, optionName],
								Nothing
							]
						],
						indexMatchingOptionNames
					]]

				]
			]
		],
		{mySamples, mapThreadFriendlyOptionsNotPropagated}
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)


	(*---  Resolve the Preparation to determine liquidhandling scale, then do this for WorkCell too  ---*)
	preparationResult = Check[
		{allowedPreparation, preparationTest} = If[gatherTests,
			resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> {Result, Tests}}]],
			{
				resolveIncubateCellsMethod[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> Result}]],
				{}
			}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation = If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Build a short hand for robotic primitive*)
	roboticPrimitiveQ = MatchQ[resolvedPreparation, Robotic];

	(* Do the same as above except with WorkCell *)
	workCellResult = Check[
		{allowedWorkCell, workCellTest} = Which[
			MatchQ[resolvedPreparation, Manual], {Null, Null},
			 gatherTests,
				resolveIncubateCellsWorkCell[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> {Result, Tests}}]],
			True,
				{
					resolveIncubateCellsWorkCell[mySamples, ReplaceRule[myOptions, {Cache -> cacheBall, Output -> Result}]],
					{}
				}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, choose microbioSTAR first because we're going to resolve to Bacterial below. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedWorkCell = Which[
		Not[MatchQ[Lookup[myOptions, WorkCell], Automatic]], Lookup[myOptions, WorkCell],
		ListQ[allowedWorkCell] && MemberQ[allowedWorkCell, microbioSTAR], microbioSTAR,
		ListQ[allowedWorkCell], FirstOrDefault[allowedWorkCell],
		True, allowedWorkCell
	];

	(* If Preparation -> Robotic, WorkCell can't be Null.  If Preparation -> Manual, WorkCell can't be specified *)
	conflictingWorkCellAndPreparationQ = Or[
		MatchQ[resolvedPreparation, Robotic] && NullQ[resolvedWorkCell],
		MatchQ[resolvedPreparation, Manual] && Not[NullQ[resolvedWorkCell]]
	];
	(* NOT throwing this message if we already thew Error::ConflictingWorkCells because if that message got thrown than our work cell is always Null and so this will always get thrown too *)
	conflictingWorkCellAndPreparationOptions = If[conflictingWorkCellAndPreparationQ && Not[MatchQ[workCellResult, $Failed]] && messages,
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

	(* If Preparation -> Robotic, can't have more than 1 hour incubation time *)
	specifiedTime = Lookup[myOptions, Time];
	incompatiblePreparationAndTimeQ = roboticPrimitiveQ && TimeQ[specifiedTime] && specifiedTime > $RoboticIncubationTimeThreshold;

	incompatiblePreparationAndTimeOptions = If[incompatiblePreparationAndTimeQ && messages,
		(
			Message[Error::ConflictingPreparationWithIncubationTime, resolvedPreparation, specifiedTime];
			{Preparation, Time}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatiblePreparationAndTimeTest = If[gatherTests,
		Test["If Preparation -> Robotic, Time must not be more than " <> ToString[$RoboticIncubationTimeThreshold] <> ":",
			incompatiblePreparationAndTimeQ,
			False
		],
		Nothing
	];

	(* Get whether the input samples are in covered containers *)
	coveredContainerQs = Not[NullQ[#]]& /@ Lookup[sampleContainerPackets, Cover, {}];
	uncoveredSamples = PickList[samplePackets, coveredContainerQs, False];
	uncoveredSamplePositions = First /@ Position[coveredContainerQs, False];
	uncoveredContainers = PickList[sampleContainerPackets, coveredContainerQs, False];

	(* If we're doing robotic this is always {} *)
	uncoveredSampleInputs = If[MatchQ[resolvedPreparation, Robotic],
		{},
		Lookup[uncoveredSamples, Object, {}]
	];

	If[Length[uncoveredSampleInputs] > 0 && messages,
		Message[Error::UnsealedCellCultureVessels, ObjectToString[uncoveredSampleInputs, Cache -> cacheBall], uncoveredSamplePositions, ObjectToString[uncoveredContainers, Cache -> cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	uncoveredContainerTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[uncoveredSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[uncoveredSampleInputs, Cache -> cacheBall] <> " are in covered containers if Preparation -> Manual:", True, False]
			];

			passingTest = If[Length[uncoveredSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, uncoveredSampleInputs], Cache -> cacheBall] <> " are in covered containers if Preparation -> Manual:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* --- Resolve the Time option --- *)

	(* Get all the doubling times of the input cells  *)
	allDoublingTimes = fastAssocLookup[fastAssoc, #, DoublingTime]& /@ mainCellIdentityModels;

	(* Resolve the Time option *)
	resolvedTime = Which[
		(* always use user specified time if applicable *)
		TimeQ[Lookup[myOptions, Time]], Lookup[myOptions, Time],
		(* if we're robotic, we're rather limited; just take what the default is there *)
		roboticPrimitiveQ, $RoboticIncubationTimeThreshold,
		(* if we're manual and know the doubling times of our input samples, then take the shortest one *)
		MemberQ[allDoublingTimes, TimeP], Min[Cases[allDoublingTimes, TimeP]],
		(* otherwise, going with 12 hours *)
		True, 12 Hour
	];


	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Options that Custom needs specified *)
	(* want this outside of the MapThread because want to use it below *)
	optionsToPullOut = {
		CellType,
		CultureAdhesion,
		Incubator,
		Temperature,
		CarbonDioxide,
		RelativeHumidity,
		Shake,
		ShakingRadius,
		ShakingRate
	};

	(* MapThread over each of our samples. *)
	{
		(*1*)cellTypes,
		(*2*)cultureAdhesions,
		(*3*)temperatures,
		(*4*)carbonDioxidePercentages,
		(*5*)relativeHumidities,
		(*6*)shaking,
		(*7*)shakingRates,
		(*8*)semiResolvedShakingRadii,
		(*9*)samplesOutStorageCondition,
		(*10*)incubationCondition,
		(*11*)cellTypesFromSample,
		(*12*)cultureAdhesionsFromSample,

		(* Errors *)
		(*13*)conflictingShakingConditionsErrors,
		(*14*)conflictingCellTypeErrors,
		(*15*)conflictingCultureAdhesionErrors,
		(*16*)invalidIncubationConditionErrors,
		(*17*)conflictingCellTypeAdhesionErrors,
		(*18*)unsupportedCellCultureTypeErrors,
		(*19*)conflictingCellTypeWithIncubatorErrors,
		(*20*)conflictingCultureAdhesionWithContainerErrors,
		(*21*)conflictingCellTypeWithStorageConditionErrors,
		(*22*)conflictingCultureAdhesionWithStorageConditionErrors,

		(* Warnings *)
		(*23*)cellTypeNotSpecifiedWarnings,
		(*24*)cultureAdhesionNotSpecifiedWarnings,
		(*25*)customIncubationConditionNotSpecifiedWarnings,
		(*26*)unspecifiedMapThreadOptions
	} = Transpose[MapThread[
		Function[{mySample, options, mainCellIdentityModel},
			Module[
				{
					specifiedCellType, specifiedCultureAdhesion, modelPacket, resolvedCellType, resolvedCultureAdhesion,
					resolvedTemperature, resolvedCarbonDioxidePercentage, resolvedRelativeHumidity, resolvedShaking, resolvedShakingRate,
					semiResolvedShakingRadius, semiResolvedShakingRadiusBadFloat, samplePacket, containerModelPacket, containerPacket,
					mainCellIdentityModelPacket, specifiedIncubationCondition, specifiedIncubator, samplesOutStorageConditionPacketForCustom,
					conflictingShakingConditionsError, samplesOutStorageConditionPattern, conflictingCellTypeAdhesionError,
					conflictingCellTypeError, conflictingCultureAdhesionError, specifiedIncubatorModelPacket,
					conflictingCultureAdhesionWithContainerError, resolvedSamplesOutStorageConditionSymbol,
					resolvedSamplesOutStorageConditionObject, conflictingCellTypeWithStorageConditionError,
					conflictingCultureAdhesionWithStorageConditionError, cellTypeNotSpecifiedWarning, cultureAdhesionNotSpecifiedWarning,
					cellTypeFromSample, cultureAdhesionFromSample, unsupportedCellCultureTypeError, incubatorCellTypes,
					conflictingCellTypeWithIncubatorError, specifiedTemperature, specifiedCarbonDioxide, specifiedRelativeHumidity,
					specifiedShake, specifiedShakingRadius, specifiedShakingRate, incubationConditionFromOptions, incubationConditionPattern,
					specifiedSamplesOutStorageCondition, resolvedIncubationCondition, resolvedIncubationConditionPacket,
					resolvedSamplesOutStorageCondition, customIncubationConditionNotSpecifiedWarning, unspecifiedOptions,
					invalidIncubationConditionError
				},

				(* Setup our error tracking variables *)
				{
					(* Hard errors *)
					conflictingShakingConditionsError,
					conflictingCellTypeError,
					conflictingCultureAdhesionError,
					invalidIncubationConditionError,
					conflictingCellTypeAdhesionError,
					unsupportedCellCultureTypeError,
					conflictingCellTypeWithIncubatorError,
					conflictingCultureAdhesionWithContainerError,
					conflictingCellTypeWithStorageConditionError,
					conflictingCultureAdhesionWithStorageConditionError,

					(* Warnings *)
					cellTypeNotSpecifiedWarning,
					cultureAdhesionNotSpecifiedWarning,
					customIncubationConditionNotSpecifiedWarning
				} = ConstantArray[False, 13];

				(* Lookup information about our sample and container packets *)
				samplePacket = fetchPacketFromFastAssoc[mySample, fastAssoc];
				modelPacket = fastAssocPacketLookup[fastAssoc, mySample, Model];
				containerPacket = fastAssocPacketLookup[fastAssoc, mySample, Container];
				containerModelPacket = fastAssocPacketLookup[fastAssoc, mySample, {Container, Model}];
				mainCellIdentityModelPacket = fetchPacketFromFastAssoc[mainCellIdentityModel, fastAssoc];

				(* Pull out the specified options *)
				{
					specifiedCellType,
					specifiedCultureAdhesion,
					specifiedIncubationCondition,
					specifiedIncubator,
					specifiedTemperature,
					specifiedCarbonDioxide,
					specifiedRelativeHumidity,
					specifiedShake,
					specifiedShakingRadius,
					specifiedShakingRate,
					specifiedSamplesOutStorageCondition
				} = Lookup[
					options,
					{
						CellType,
						CultureAdhesion,
						IncubationCondition,
						Incubator,
						Temperature,
						CarbonDioxide,
						RelativeHumidity,
						Shake,
						ShakingRadius,
						ShakingRate,
						SamplesOutStorageCondition
					}
				];

				(* Get the options that were not specified up front here *)
				unspecifiedOptions = PickList[
					optionsToPullOut,
					Lookup[options, optionsToPullOut],
					Automatic
				];

				(* If IncubationCondition was set to Custom but unspecifiedOptions is not {}, then flip the warning saying user should specify them *)
				customIncubationConditionNotSpecifiedWarning = MatchQ[specifiedIncubationCondition, Custom] && Not[MatchQ[unspecifiedOptions, {}]];

				(* If we have a specified incubator, get the packet *)
				specifiedIncubatorModelPacket = Which[
					MatchQ[specifiedIncubator, ObjectP[Model[Instrument, Incubator]]], fetchPacketFromFastAssoc[specifiedIncubator, fastAssoc],
					MatchQ[specifiedIncubator, ObjectP[Object[Instrument, Incubator]]], fastAssocPacketLookup[fastAssoc, specifiedIncubator, Model],
					True, Null
				];

				(* Get the CellType that we can discern from the sample *)
				cellTypeFromSample = Which[
					(* if the sample has a CellType, use that *)
					MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
					(* if sample doesn't have it but its model does, use that*)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CellType], CellTypeP], Lookup[modelPacket, CellType],
					(* if there is a cell type identity model in its composition, pick the most concentrated one *)
					MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]], Lookup[mainCellIdentityModelPacket, CellType],
					(* otherwise, we have no idea and pick Null *)
					True, Null
				];

				(* Resolve the CellType option as if it wasn't specified, and the CellTypeNotSpecified warning and the ConflictingCellTypeError *)
				{
					resolvedCellType,
					conflictingCellTypeError,
					cellTypeNotSpecifiedWarning
				} = Which[
					(* if CellType was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[specifiedCellType, CellTypeP] && MatchQ[cellTypeFromSample, CellTypeP] && specifiedCellType =!= cellTypeFromSample, {specifiedCellType, True, False},
					(* if CellType was specified otherwise, just go with it *)
					MatchQ[specifiedCellType, CellTypeP], {specifiedCellType, False, False},
					(* if CellType was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cellTypeFromSample, CellTypeP], {cellTypeFromSample, False, False},
					(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial and flip warning switch *)
					True, {Bacterial, False, True}
				];

				(* Get the CultureAdhesion that we can discern from the sample *)
				cultureAdhesionFromSample = Which[
					(* if the sample has a CultureAdhesion, use that *)
					MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP], Lookup[samplePacket, CultureAdhesion],
					(* if sample doesn't have it but its model does, use that*)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CultureAdhesion], CultureAdhesionP], Lookup[modelPacket, CultureAdhesion],
					(* if there is a cell type identity model in its composition, pick the most concentrated one's CultureAdhesion *)
					MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]], Lookup[mainCellIdentityModelPacket, CultureAdhesion],
					(* otherwise, we have no idea and pick Null *)
					True, Null
				];

				(* Resolve the CultureAdhesion option if it wasn't specified, and the CultureAdhesionNotSpecified warning and the ConflictingClutureAdhesion error *)
				{
					resolvedCultureAdhesion,
					conflictingCultureAdhesionError,
					cultureAdhesionNotSpecifiedWarning
				} = Which[
					(* if CultureAdhesion was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP] && MatchQ[cultureAdhesionFromSample, CultureAdhesionP] && specifiedCultureAdhesion =!= cultureAdhesionFromSample, {specifiedCultureAdhesion, True, False},
					(* if CultureAdhesion was specified otherwise, just go with it*)
					MatchQ[specifiedCultureAdhesion, CultureAdhesionP], {specifiedCultureAdhesion, False, False},
					(* if CultureAdhesion was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cultureAdhesionFromSample, CultureAdhesionP], {cultureAdhesionFromSample, False, False},
					(* if CultureAdhesion was not specified and we coudln't figure it out from the sample, default to Suspension and flip warning switch *)
					True, {Suspension, False, True}
				];

				(* Get the incubation condition from the specified options *)
				incubationConditionPattern = KeyValuePattern[{
					CellType -> resolvedCellType,
					If[TemperatureQ[specifiedTemperature],
						Temperature -> EqualP[specifiedTemperature],
						Nothing
					],
					If[PercentQ[specifiedCarbonDioxide],
						CarbonDioxide -> EqualP[specifiedCarbonDioxide],
						Nothing
					],
					If[PercentQ[specifiedRelativeHumidity],
						Humidity -> EqualP[specifiedRelativeHumidity],
						Nothing
					],
					If[DistanceQ[specifiedShakingRadius],
						ShakingRadius -> EqualP[specifiedShakingRadius],
						Nothing
					],
					If[RPMQ[specifiedShakingRate] && MatchQ[containerModelPacket, ObjectP[Model[Container, Plate]]],
						PlateShakingRate -> EqualP[specifiedShakingRate],
						Nothing
					],
					If[RPMQ[specifiedShakingRate] && MatchQ[containerModelPacket, ObjectP[Model[Container, Vessel]]],
						VesselShakingRate -> EqualP[specifiedShakingRate],
						Nothing
					],
					(* this one is goofy.  Basically, if we haven't specified any other shaking things but we need it to shake, we specify ShakingRadius as non-null (but don't bother if stuff above is already specified *)
					(* if we are not Suspension and haven't specified any shaking options, then we just want ShakingRadius to be Null *)
					If[(TrueQ[specifiedShake] || MatchQ[resolvedCultureAdhesion, Suspension]) && Not[RPMQ[specifiedShakingRate]] && Not[DistanceQ[specifiedShakingRadius]],
						ShakingRadius -> Except[Null],
						ShakingRadius -> Null
					]
				}];

				(* Given all the specified options, pick an incubation condition that would fit *)
				(* if it's nothing, then we go to Custom *)
				(* certainly my Lookup trick here is a little goofy but it works (obviously Lookup will not work with Custom directly) *)
				incubationConditionFromOptions = Lookup[
					FirstCase[storageConditionPackets, incubationConditionPattern, <|Object -> Custom|>],
					Object
				];

				(* Resolve the incubation condition *)
				resolvedIncubationCondition = Which[
					(* if the user set it, use it *)
					Not[MatchQ[specifiedIncubationCondition, Automatic]], specifiedIncubationCondition,
					(* If preparation is Robotic, always custom *)
					MatchQ[resolvedPreparation, Robotic], Custom,
					(* if Incubator is specified and it's a custom incubator, set to Custom *)
					MatchQ[specifiedIncubator, ObjectP[]] && MemberQ[customIncubators, ObjectP[specifiedIncubator]], Custom,
					(* if Incubator is specified otherwise, get its ProvidedStorageCondition (replacing Null with Custom on the off chance we get that) *)
					MatchQ[specifiedIncubator, ObjectP[]], Lookup[specifiedIncubatorModelPacket, ProvidedStorageCondition] /. {Null -> Custom},
					(* otherwise we figured out incubation condition based on the specified options, so go with that *)
					True, incubationConditionFromOptions
				];

				(* Get the resolved incubation condition packet *)
				resolvedIncubationConditionPacket = Switch[resolvedIncubationCondition,
					(* if we have an object, take the object *)
					ObjectP[Model[StorageCondition]], fetchPacketFromFastAssoc[resolvedIncubationCondition, fastAssoc],
					(* if it's custom, then just stick with Custom *)
					Custom, Custom,
					(* otherwise need to get the first storage condition that matches the symbol we chose *)
					_, FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> resolvedIncubationCondition]]
				];

				(* Resolve the Temperature option *)
				resolvedTemperature = Which[
					(* If the user directly provided a Temperature, use that*)
					TemperatureQ[specifiedTemperature], specifiedTemperature,
					(* if IncubationCondition is not custom, take the temperature from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, Temperature],
					(* if an incubator was specified and it has a DefaultTemperature, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && TemperatureQ[Lookup[specifiedIncubatorModelPacket, DefaultTemperature]], Lookup[specifiedIncubatorModelPacket, DefaultTemperature],
					(* otherwise, default to 37 Celsius for Mammalian and Bacterial cells, and 30 Celsius for Yeast *)
					MatchQ[resolvedCellType, Yeast], 30 Celsius,
					True, 37 Celsius
				];

				(* Resolve the RelativeHumidity option *)
				resolvedRelativeHumidity = Which[
					(* If the user directly provided a RelativeHumidity, use that *)
					PercentQ[specifiedRelativeHumidity], specifiedRelativeHumidity,
					(* if IncubationCondition is not custom, take the humidity from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, Humidity],
					(* if an incubator was specified and it has a DefaultRelativeHumidity, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity]], Lookup[specifiedIncubatorModelPacket, DefaultRelativeHumidity],
					(* otherwise, default to 93 Celsius for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian], 93 Percent,
					True, Null
				];

				(* Resolve the CarbonDioxide option *)
				resolvedCarbonDioxidePercentage = Which[
					(* If the user directly provided a CarbonDioxide value, use that *)
					PercentQ[specifiedCarbonDioxide], specifiedCarbonDioxide,
					(* if IncubationCondition is not custom, take the CarbonDioxide from that *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]], Lookup[resolvedIncubationConditionPacket, CarbonDioxide],
					(* if an incubator was specified and it has a DefaultCarbonDioxide, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && PercentQ[Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide]], Lookup[specifiedIncubatorModelPacket, DefaultCarbonDioxide],
					(* otherwise, default to 5 Percent for Mammalian, and Null otherwise *)
					MatchQ[resolvedCellType, Mammalian], 5 Percent,
					True, Null
				];

				(* Resolve the Shake option *)
				resolvedShaking = Which[
					(* If the user directly provided Shaking as True, use that*)
					BooleanQ[specifiedShake], specifiedShake,
					(*If Shaking is Automatic and either ShakingRate or ShakingRadius is specified, set Shake to True*)
					RPMQ[specifiedShakingRate] || DistanceQ[specifiedShakingRadius], True,
					(* if IncubationCondition is not custom and ShakingRadius is populated, then True *)
					(* note that I don't need to check ShakingRadius _and_ ShakingRate because both are populated together *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]]
					], True,
					(* if none of the shaking options are specified and we're in a custom incubation, then suspensions cells should shake and others should not *)
					MatchQ[resolvedCultureAdhesion, Suspension], True,
					True, False
				];

				(* Resolve the ShakingRate option *)
				resolvedShakingRate = Which[
					(* If the user directly provided a ShakingRate, use that*)
					RPMQ[specifiedShakingRate], specifiedShakingRate,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking], Null,
					(* if IncubationCondition is not custom and ShakingRate is populated, then use the Plate/VesselShakingRate *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, PlateShakingRate]]]
					], Lookup[resolvedIncubationConditionPacket, PlateShakingRate],
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						MatchQ[containerModelPacket, PacketP[Model[Container, Vessel]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, VesselShakingRate]]]
					], Lookup[resolvedIncubationConditionPacket, VesselShakingRate],
					(* if an incubator was specified and it has a DefaultShakingRate, go with that; I don't expect this to usually be populated for custom incubators but we can have this here in case *)
					Not[NullQ[specifiedIncubatorModelPacket]] && RPMQ[Lookup[specifiedIncubatorModelPacket, DefaultShakingRate]], Lookup[specifiedIncubatorModelPacket, DefaultShakingRate],
					(* if we have nothing else to go on, then do 400 RPM for a plate and 200 RPM (yeast) or 250 RPM (bacterial) otherwise *)
					MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]], 400 RPM,
					MatchQ[resolvedCellType, Yeast], 200 RPM,
					True, 250 RPM
				];

				(* Resolve the ShakingRadius option *)
				semiResolvedShakingRadiusBadFloat = Which[
					(* If the user directly provided a ShakingRadius, use that*)
					DistanceQ[specifiedShakingRadius], specifiedShakingRadius,
					(* if Shake is resolved to False, then Null *)
					Not[resolvedShaking], Null,
					(* if IncubationCondition is not custom and ShakingRadius is populated, then use the ShakingRadius *)
					And[
						MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]],
						Not[NullQ[Lookup[resolvedIncubationConditionPacket, ShakingRadius]]]
					], Lookup[resolvedIncubationConditionPacket, ShakingRadius],
					(* if an Incubator was specified and it has ShakingRadius, go with that *)
					Not[NullQ[specifiedIncubatorModelPacket]] && DistanceQ[Lookup[specifiedIncubatorModelPacket, ShakingRadius]], Lookup[specifiedIncubatorModelPacket, ShakingRadius],
					(* otherwise this is staying Automatic and we're going to figure it out when we have an incubator *)
					True, Automatic
				];

				(* Because ShakingRadius is an enumeration, floating point numbers can mess us up here.  IncubateCellsDevices will break if given 25.40000000000002` Millimeter even though that is what was stored in the database *)
				(* so I need to do our quasi-rounding to avoid that *)
				semiResolvedShakingRadius = If[DistanceQ[semiResolvedShakingRadiusBadFloat],
					FirstOrDefault[MinimalBy[List @@ CellIncubatorShakingRadiusP, Abs[# - semiResolvedShakingRadiusBadFloat]&, 1]],
					semiResolvedShakingRadiusBadFloat
				];

				(* Flip the conflicting shaking conditions error if we are shaking and have ShakingRadius or ShakingRate to Null *)
				(* or if we are not shaking and ShakingRadius or ShakingRate are not Null *)
				conflictingShakingConditionsError = Or[
					resolvedShaking && (NullQ[resolvedShakingRate] || NullQ[semiResolvedShakingRadius]),
					Not[resolvedShaking] && (RPMQ[resolvedShakingRate] || DistanceQ[semiResolvedShakingRadius])
				];

				(* Get the incubation condition from the specified options *)
				(* this is _only_ to tell the shaking and cell type and nothing else because we don't use custom SamplesOutStorageConditions *)
				samplesOutStorageConditionPattern = KeyValuePattern[{
					CellType -> resolvedCellType,
					(* checking all three of these options because of the case where a user specifies conflicting shaking options (i.e., Shake -> False, ShakingRate -> 200 RPM) *)
					(* if the user does that, we're already going to throw an error, but if we don't check all three,
					we're potentially going to go down a path that will cause us to throw even more messages, which customers will (rightly) find annoying and unhelpful*)
					If[resolvedShaking || DistanceQ[semiResolvedShakingRadius] || RPMQ[resolvedShakingRate],
						ShakingRadius -> Except[Null],
						ShakingRadius -> Null
					]
				}];

				(* Given all the specified options, pick an incubation condition that would fit *)
				samplesOutStorageConditionPacketForCustom = FirstCase[storageConditionPackets, samplesOutStorageConditionPattern];

				(* Resolve the SamplesOutStorageCondition option *)
				resolvedSamplesOutStorageCondition = Which[
					(* if samples out storage condition is specified, use it *)
					Not[MatchQ[specifiedSamplesOutStorageCondition, Automatic]], specifiedSamplesOutStorageCondition,
					(* if IncubationCondition is not custom, then get the incubation condition *)
					(* note that we somehow have a non-cell-culture incubation condition here, don't resolve to that because things are already borked and we don't want to throw unnecessary options together with the necessary ones  *)
					MatchQ[resolvedIncubationConditionPacket, PacketP[Model[StorageCondition]]] && Not[NullQ[Lookup[resolvedIncubationConditionPacket, CellType]]], Lookup[resolvedIncubationConditionPacket, StorageCondition],
					(* if IncubationCondition is custom, then pick a storage condition based only on CellType and CultureAdhesion (and just pick something based on CellType otherwise) *)
					MatchQ[samplesOutStorageConditionPacketForCustom, PacketP[Model[StorageCondition]]], Lookup[samplesOutStorageConditionPacketForCustom, StorageCondition],
					(* if we somehow can't find anything, just say BacterialShakingIncubation and we're going to throw an error below *)
					(* we resolve down to BacterialShakingIncubation because we're already resolving to Suspension and so if we do that and non-shaking we're going to throw too many more unncessary errors *)
					True, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[CellType -> resolvedCellType], <|StorageCondition -> BacterialShakingIncubation|>], StorageCondition]
				];

				(* Flip error switch for if IncubationCondition is specified and is not an actual IncubationCondition *)
				invalidIncubationConditionError = Or[
					MatchQ[specifiedIncubationCondition, ObjectP[Model[StorageCondition]]] && Not[MemberQ[allowedStorageConditionSymbols, fastAssocLookup[fastAssoc, specifiedIncubationCondition, StorageCondition]]],
					MatchQ[specifiedIncubationCondition, SampleStorageTypeP] && Not[MemberQ[allowedStorageConditionSymbols, specifiedIncubationCondition]]
				];

				(* Flip error switch if we're doing Mammalian samples with SolidMedia, or if we're doing Yeast/Bacterial with Adherent *)
				conflictingCellTypeAdhesionError = Or[
					MatchQ[resolvedCellType, Mammalian] && MatchQ[resolvedCultureAdhesion, SolidMedia],
					MatchQ[resolvedCellType, Bacterial|Yeast] && MatchQ[resolvedCultureAdhesion, Adherent]
				];

				(* Flip error switch if doing Mammalian and Suspension (not currently supported) *)
				unsupportedCellCultureTypeError = MatchQ[resolvedCellType, Mammalian] && MatchQ[resolvedCultureAdhesion, Suspension];

				(* Get the cell types compatilbe with the specified incubator *)
				incubatorCellTypes = If[NullQ[specifiedIncubatorModelPacket],
					Null,
					Lookup[specifiedIncubatorModelPacket, CellTypes]
				];

				(* Flip error switch if specified incubator CellTypes doesn't match the resolved CellType option *)
				conflictingCellTypeWithIncubatorError = Not[NullQ[incubatorCellTypes]] && Not[MemberQ[incubatorCellTypes, resolvedCellType]];

				(* Flip error switch if the container type doesn't work with the culture adhesion *)
				(* solid media or adherent must be in a plate *)
				conflictingCultureAdhesionWithContainerError = MatchQ[resolvedCultureAdhesion, SolidMedia|Adherent] && Not[MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]]];

				(* Get the symbol form of the SamplesOutStorageCondition at this point because that's easier to deal with *)
				(* also get the object form if we don't have it already *)
				resolvedSamplesOutStorageConditionSymbol = If[MatchQ[resolvedSamplesOutStorageCondition, ObjectP[Model[StorageCondition]]],
					fastAssocLookup[fastAssoc, resolvedSamplesOutStorageCondition, StorageCondition],
					resolvedSamplesOutStorageCondition
				];
				resolvedSamplesOutStorageConditionObject = Switch[resolvedSamplesOutStorageCondition,
					Disposal, Null,
					ObjectP[Model[StorageCondition]], resolvedSamplesOutStorageCondition,
					_, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> resolvedSamplesOutStorageCondition], <|Object -> Null|>], Object]
				];

				(* Flip error switch for if the SamplesOutStorageCondition doesn't agree with what the cells are *)
				conflictingCellTypeWithStorageConditionError = Which[
					(* Disposal always ok *)
					MatchQ[resolvedSamplesOutStorageConditionSymbol, Disposal], False,
					(* if CellType is Mammalian, then we need MammalianIncubation *)
					MatchQ[resolvedCellType, Mammalian], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, MammalianIncubation]],
					(* if CultureAdhesion is SolidMedia, then Refrigerator is fine *)
					MatchQ[resolvedCultureAdhesion, SolidMedia] && MatchQ[resolvedSamplesOutStorageConditionSymbol, Refrigerator], False,
					(* if CellType is Bacterial, then we need SamplesOutStorageCondition to be BacterialIncubation or BacterialShakingIncubation *)
					MatchQ[resolvedCellType, Bacterial], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, BacterialIncubation|BacterialShakingIncubation]],
					(* if CellType is Yeast, then we need SamplesOutStorageCondition to be YeastIncubation or YeastShakingIncubation *)
					MatchQ[resolvedCellType, Yeast], Not[MatchQ[resolvedSamplesOutStorageConditionSymbol, YeastIncubation|YeastShakingIncubation]],
					(* fallback; shouldn't get here *)
					True, False
				];

				(* Flip error switch for if we are trying to store suspension samples without shaking *)
				conflictingCultureAdhesionWithStorageConditionError = If[MatchQ[resolvedSamplesOutStorageConditionSymbol, Disposal] || NullQ[resolvedSamplesOutStorageConditionObject],
					(* Disposal is always ok *)
					False,
					(* if CultureAdhesion is Suspension, we have to have a shaking storage condition *)
					MatchQ[resolvedCultureAdhesion, Suspension] && NullQ[fastAssocLookup[fastAssoc, resolvedSamplesOutStorageConditionObject, ShakingRadius]]
				];

				(* Gather MapThread results *)
				{
					(*1*)resolvedCellType,
					(*2*)resolvedCultureAdhesion,
					(*3*)resolvedTemperature,
					(*4*)resolvedCarbonDioxidePercentage,
					(*5*)resolvedRelativeHumidity,
					(*6*)resolvedShaking,
					(*7*)resolvedShakingRate,
					(*8*)semiResolvedShakingRadius,
					(*9*)resolvedSamplesOutStorageCondition,
					(*10*)resolvedIncubationCondition,
					(*11*)cellTypeFromSample,
					(*12*)cultureAdhesionFromSample,
					(*13*)conflictingShakingConditionsError,
					(*14*)conflictingCellTypeError,
					(*15*)conflictingCultureAdhesionError,
					(*16*)invalidIncubationConditionError,
					(*17*)conflictingCellTypeAdhesionError,
					(*18*)unsupportedCellCultureTypeError,
					(*19*)conflictingCellTypeWithIncubatorError,
					(*20*)conflictingCultureAdhesionWithContainerError,
					(*21*)conflictingCellTypeWithStorageConditionError,
					(*22*)conflictingCultureAdhesionWithStorageConditionError,
					(*23*)cellTypeNotSpecifiedWarning,
					(*24*)cultureAdhesionNotSpecifiedWarning,
					(*25*)customIncubationConditionNotSpecifiedWarning,
					(*26*)unspecifiedOptions
				}
			]
		],
		{mySamples, mapThreadFriendlyOptions, mainCellIdentityModels}
	]];

	(* To avoid mapping IncubateCellsDevices, once all other options are resolved in the MapThread above, pass the all the resolved options and the cache
		to IncubateCellsDevices (using sample's containers as inputs) *)

	(* Stash the container models to use as input*)
	sampleContainerModels = Lookup[sampleContainerModelPackets, Object];

	(* Call IncubateCellsDevices to find all compatible incubators. If a list other than {} is returned, check the mode and return one valid instrument model*)
	possibleIncubators = IncubateCellsDevices[
		sampleContainerModels,
		CellType -> cellTypes,
		CultureAdhesion -> cultureAdhesions,
		Temperature -> temperatures,
		CarbonDioxide -> carbonDioxidePercentages,
		RelativeHumidity -> relativeHumidities,
		Shake -> shaking,
		ShakingRate -> shakingRates,
		ShakingRadius -> semiResolvedShakingRadii,
		Preparation -> resolvedPreparation,
		Cache -> cacheBall,
		Simulation -> simulation
	];
	possibleIncubatorPackets = Map[
		fetchPacketFromFastAssoc[#, fastAssoc]&,
		possibleIncubators,
		{2}
	];

	(* Resolve the incubator based on the information we had above from IncubateCellsDevices and the MapThread *)
	incubators = MapThread[
		Function[{potentialIncubatorPacketsPerSample, desiredIncubator, resolvedCondition},
			Which[
				(* If user specified, just go with that *)
				MatchQ[desiredIncubator, ObjectP[{Model[Instrument, Incubator], Object[Instrument, Incubator]}]], desiredIncubator,
				(* If potential incubators is {}, then we're just picking Null and throwing an error below *)
				MatchQ[potentialIncubatorPacketsPerSample, {}], Null,
				(* If we're dealing with Robotic and on the bioSTAR, pick a robotic NonMicrobial incubator, pick the one that matches the desired work cell *)
				(* doing this <|Object -> Null|> trick because obviously we can't do Lookup[Null, Object] and we're dealing with packets.  I know it's kind of dumb *)
				MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedWorkCell, bioSTAR],
					Lookup[
						FirstCase[potentialIncubatorPacketsPerSample, KeyValuePattern[{Mode -> Robotic, CellTypes -> {NonMicrobialCellTypeP..}}], <|Object -> Null|>],
						Object
					],
				(* If we're dealing with Robotic and on the microbioSTAR, pick a robotic NonMicrobial incubator, pick the one that matches the desired work cell *)
				MatchQ[resolvedPreparation, Robotic] && MatchQ[resolvedWorkCell, microbioSTAR],
					Lookup[
						FirstCase[potentialIncubatorPacketsPerSample, KeyValuePattern[{Mode -> Robotic, CellTypes -> {MicrobialCellTypeP..}}], <|Object -> Null|>],
						Object
					],
				(* If we have a Custom incubation condition, we need to pick an incubator that we can use *)
				(* to do this, pick the first potential incubator that is a custom incubator *)
				MatchQ[resolvedCondition, Custom],
					SelectFirst[Lookup[potentialIncubatorPacketsPerSample, Object], MemberQ[customIncubators, #]&, Null],
				(* If we can avoid picking a custom incubator here, let's do it *)
				True,
					SelectFirst[
						Lookup[potentialIncubatorPacketsPerSample, Object],
						Not[MemberQ[customIncubators, #]]&,
						(* if we can't find any non-custom incubators, just pick whatever we can find*)
						FirstOrDefault[Lookup[potentialIncubatorPacketsPerSample, Object]]
					]

			]
		],
		{possibleIncubatorPackets, Lookup[mapThreadFriendlyOptions, Incubator], incubationCondition}
	];

	(* Finally resolve the ShakingRadius now that we know the incubator we're using  *)
	resolvedShakingRadiiPreRounding = MapThread[
		Function[{incubator, shakingRadius},
			If[MatchQ[shakingRadius, Automatic],
				fastAssocLookup[fastAssoc, incubator, ShakingRadius],
				shakingRadius
			]
		],
		{incubators, semiResolvedShakingRadii}
	];

	(* Need to select the shaking radius closest to the values here *)
	(* this is admittedly super jank, but it's because the ShakingRadius is stored as a float inside the incubator, but ShakingRadius must match CellIncubatorShakingRadiusP exactly *)
	resolvedShakingRadii = Map[
		Function[{radius},
			Which[
				NullQ[radius], Null,
				MatchQ[radius, CellIncubatorShakingRadiusP], radius,
				True, FirstOrDefault[MinimalBy[List @@ CellIncubatorShakingRadiusP, Abs[# - radius]&, 1]]
			]
		],
		resolvedShakingRadiiPreRounding
	];

	(* Get the resolved Email option; for this experiment, the default is True *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* Combine the resolved options together at this point; everything after is error checking, and for the warning below I need this for better error checking *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Incubator -> incubators,
			CellType -> cellTypes,
			CultureAdhesion -> cultureAdhesions,
			Temperature -> temperatures,
			CarbonDioxide -> carbonDioxidePercentages,
			RelativeHumidity -> relativeHumidities,
			Time -> resolvedTime,
			Shake -> shaking,
			ShakingRate -> shakingRates,
			ShakingRadius -> resolvedShakingRadii,
			IncubationCondition -> incubationCondition,
			SamplesOutStorageCondition -> samplesOutStorageCondition,
			Email -> email,
			Confirm -> confirm,
			Template -> template,
			Preparation -> resolvedPreparation,
			WorkCell -> resolvedWorkCell,
			(* explicitly overriding these options to be {} and Null to make things more manageable to pass around and also more readable *)
			Cache -> {},
			Simulation -> Null,
			FastTrack -> fastTrack,
			Operator -> operator,
			ParentProtocol -> parentProtocol,
			Upload -> upload,
			Output -> outputOption
		}]
	];

	(* Doing this because it makes the warning check below easier *)
	resolvedMapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentIncubateCells, resolvedOptions];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Make rules converting containers to the samples inside them *)
	containersToSamples = Merge[
		MapThread[
			#1 -> #2&,
			{Lookup[sampleContainerPackets, Object], Lookup[samplePackets, Object]}
		],
		Join
	];

	(* Make rules converting incubators to the containers *)
	(* delete duplicates though *)
	incubatorsToContainers = Merge[
		MapThread[
			#1 -> #2&,
			{incubators, Lookup[sampleContainerPackets, Object]}
		],
		DeleteDuplicates[Join[#]] &
	];

	(* Tally the footprints for each incubator *)
	incubatorFootprints = Merge[
		KeyValueMap[
			Function[{incubator, containers},
				incubator -> fastAssocLookup[fastAssoc, #, {Model, Footprint}]& /@ containers
			],
			incubatorsToContainers
		],
		(* the assumption here is that we have only one footprint trying to go into each incubator; I think this is a reasonable assumption*)
		(* if this is not true then let's change it *)
		First[Tally[#]] &
	];

	(* Determine if the total of a given type of footprint has been exceeded for each incubator *)
	(* here for each failure, we're going to have a list of length four, where the first value is the incubator, the second is the capacity number, the third is the footprint, and the foruth is the value we actually have *)
	incubatorsOverCapacityAmounts = KeyValueMap[
		Function[{incubator, footprintTally},
			Module[{incubatorModel, maxCapacityAllFootprints, footprintOverLimitQ, capacity},

				(* If we had an incubator object at this point, convert it to a model *)
				incubatorModel = If[MatchQ[incubator, ObjectP[Object[Instrument, Incubator]]],
					fastAssocLookup[fastAssoc, incubator, Model],
					incubator
				];

				(* Determine the max capacity for the whole incubator (i.e., all footprints) *)
				maxCapacityAllFootprints = Lookup[$CellIncubatorMaxCapacity, incubatorModel, <||>];

				(* For each footprint that we're putting in a given incubator, determine if we've gone over the limit *)
				(* if we don't have the limit, just assume we're fine *)
				capacity = Lookup[maxCapacityAllFootprints, footprintTally[[1]], Null];
				footprintOverLimitQ = Not[NullQ[capacity]] && capacity < footprintTally[[2]];

				If[footprintOverLimitQ,
					{
						incubator,
						capacity,
						footprintTally[[1]],
						footprintTally[[2]]
					},
					Nothing
				]
			]
		],
		incubatorFootprints
	];

	incubatorOverCapacityIncubators = incubatorsOverCapacityAmounts[[All, 1]];
	incubatorOverCapacityCapacities = incubatorsOverCapacityAmounts[[All, 2]];
	incubatorsOverCapacityFootprints = incubatorsOverCapacityAmounts[[All, 3]];
	incubatorsOverCapacityQuantities = incubatorsOverCapacityAmounts[[All, 4]];

	tooManySamples = Flatten[{
		Map[
			Function[{incubator},
				With[{containers = Lookup[incubatorsToContainers, incubator]},
					Lookup[containersToSamples, #]& /@ containers
				]
			],
			incubatorOverCapacityIncubators
		]
	}];

	(* If we have too many samples for an incubator, throw an error: *)
	If[Not[MatchQ[incubatorsOverCapacityAmounts, {}]] && messages,
		Message[
			Error::TooManyIncubationSamples,
			ObjectToString[incubatorOverCapacityIncubators, Cache -> cacheBall],
			incubatorOverCapacityCapacities,
			incubatorsOverCapacityFootprints,
			incubatorsOverCapacityQuantities

		]
	];
	tooManySamplesTest = If[gatherTests,
		Test["Too many samples are not provided for a given incubator:",
			incubatorOverCapacityIncubators,
			{}
		]

	];

	(* Gather the samples that are in the same container together with their options *)
	groupedSamplesContainersAndOptions = GatherBy[
		Transpose[{mySamples, sampleContainerPackets, resolvedMapThreadOptions}],
		#[[2]]&
	];

	(* Get the options that are not the same across the board for each container *)
	inconsistentOptionsPerContainer = Map[
		Function[{samplesContainersAndOptions},
			Map[
				Function[{optionToCheck},
					If[SameQ @@ Lookup[samplesContainersAndOptions[[All, 3]], optionToCheck],
						Nothing,
						optionToCheck
					]
				],
				Append[optionsToPullOut, SamplesOutStorageCondition]
			]
		],
		groupedSamplesContainersAndOptions
	];

	(* Get the samples that have conflicting options for the same container *)
	samplesWithSameContainerConflictingOptions = MapThread[
		Function[{samplesContainersAndOptions, inconsistentOptions},
			If[MatchQ[inconsistentOptions, {}],
				Nothing,
				samplesContainersAndOptions[[All, 1]]
			]
		],
		{groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer}
	];
	samplesWithSameContainerConflictingErrors = Not[MatchQ[#, {}]]& /@ inconsistentOptionsPerContainer;

	(* Throw an error if we have these same-container samples with different options specified *)
	conflictingIncubationConditionsForSameContainerOptions = If[MemberQ[samplesWithSameContainerConflictingErrors, True] && messages,
		(
			Message[
				Error::ConflictingIncubationConditionsForSameContainer,
				PickList[samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors],
				PickList[inconsistentOptionsPerContainer, samplesWithSameContainerConflictingErrors]
			];
			DeleteDuplicates[Flatten[inconsistentOptionsPerContainer]]
		),
		{}
	];
	conflictingIncubationConditionsForSameContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,samplesWithSameContainerConflictingErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cacheBall]<>",have the same incubation conditions as all other samples in the same container:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cacheBall]<>",have the same incubation conditions as all other samples in the same container:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If the Temperature is greater than the MaxTemperature of an input container, throw an error *)
	temperatureAboveMaxTemperatureQs = MapThread[
		With[{maxTemp = Lookup[#1, MaxTemperature]},
			TemperatureQ[maxTemp] && maxTemp < #2
		]&,
		{sampleContainerModelPackets, temperatures}
	];
	incubationMaxTemperatureOptions = If[MemberQ[temperatureAboveMaxTemperatureQs, True] && messages,
		(
			Message[
				Error::IncubationMaxTemperature,
				ObjectToString[PickList[mySamples, temperatureAboveMaxTemperatureQs], Cache -> cacheBall],
				First /@ Position[temperatureAboveMaxTemperatureQs, True],
				ObjectToString[PickList[Lookup[sampleContainerModelPackets, Object], temperatureAboveMaxTemperatureQs], Cache -> cacheBall],
				PickList[Lookup[sampleContainerModelPackets, MaxTemperature], temperatureAboveMaxTemperatureQs]
			];
			{Temperature}
		),
		{}
	];
	incubationMaxTemperatureTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, temperatureAboveMaxTemperatureQs];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", do not have Temperature set higher than the MaxTemperature of their containers:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If IncubationCondition was set to Custom but not all incubation conditions were specified, throw a warning saying what we resolved them to *)
	resolvedUnspecifiedOptions = Lookup[resolvedOptions, unspecifiedMapThreadOptions];
	customIncubationWarningSamples = PickList[mySamples, customIncubationConditionNotSpecifiedWarnings];
	customIncubationWarningPositions = First /@ Position[customIncubationConditionNotSpecifiedWarnings, True];
	customIncubationWarningUnspecifiedOptionNames = PickList[unspecifiedMapThreadOptions, customIncubationConditionNotSpecifiedWarnings];
	customIncubationWarningResolvedOptions = MapThread[
		If[#1,
			Lookup[#2, #3],
			Nothing
		]&,
		{customIncubationConditionNotSpecifiedWarnings, resolvedMapThreadOptions, unspecifiedMapThreadOptions}
	];
	If[MemberQ[customIncubationConditionNotSpecifiedWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::CustomIncubationConditionNotSpecified,
			ObjectToString[customIncubationWarningSamples, Cache -> cacheBall],
			customIncubationWarningPositions,
			customIncubationWarningUnspecifiedOptionNames,
			customIncubationWarningResolvedOptions
		]
	];
	customIncubationNotSpecifiedTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, customIncubationConditionNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", if IncubationCondition is set to Custom, all incubation conditions are directly specified rather than automatically set:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* No compatible incubator options error check *)
	noCompatibleIncubatorErrors = MatchQ[#, ({}|Null)]& /@ possibleIncubators;

	noCompatibleIncubatorsInvalidInputs = If[Or@@noCompatibleIncubatorErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, noCompatibleIncubatorErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::NoCompatibleIncubator,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[noCompatibleIncubatorErrors, True]
			];

			(* Return our invalid inputs. *)
			invalidSamples
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	noCompatibleIncubatorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, noCompatibleIncubatorErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a valid incubator capable of incubating the samples with the provided options", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a valid incubator capable of incubating the samples with the provided options", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	firstCustomIncubator = FirstCase[incubators, Alternatives @@ customIncubators];
	(*Too many custom incubator options error check *)
	invalidCustomIncubatorsErrors = MatchQ[#, Alternatives @@ DeleteCases[customIncubators, firstCustomIncubator]]& /@ incubators;

	invalidCustomIncubatorsOptions = If[Or @@ invalidCustomIncubatorsErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, invalidCustomIncubatorsErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::TooManyCustomIncubationConditions,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				ObjectToString[PickList[incubators, invalidCustomIncubatorsErrors]],
				ObjectToString[firstCustomIncubator]
			];

			(* Return our invalid options. *)
			{Incubator}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidCustomIncubatorsTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, invalidCustomIncubatorsErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", all only utilize one custom incubator to incubate the samples with the provided options", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Invalid shaking conditions options error check *)
	invalidShakingConditionsOptions = If[Or @@ conflictingShakingConditionsErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingShakingConditionsErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[
				Error::ConflictingShakingConditions,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingShakingConditionsErrors, True],
				PickList[shaking, conflictingShakingConditionsErrors],
				PickList[shakingRates, conflictingShakingConditionsErrors],
				PickList[resolvedShakingRadii, conflictingShakingConditionsErrors]
			];

			(* Return our invalid options. *)
			{Shake, ShakingRate, ShakingRadius}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidShakingConditionsTests= If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingShakingConditionsErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have selected shaking options compatible with each other", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have selected shaking options compatible with each other", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Conflicting CellType options error check *)
	conflictingCellTypeOptions = If[Or @@ conflictingCellTypeErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingCellTypeErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::ConflictingCellType,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingCellTypeErrors, True],
				PickList[cellTypes, conflictingCellTypeErrors],
				PickList[cellTypesFromSample, conflictingCellTypeErrors]
			];

			(* Return our invalid options. *)
			{CellType}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	conflictingCellTypeTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CellType that matches the CellType option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CellType that matches the CellType option value provided", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Conflicting CultureAdhesion options error check *)
	conflictingCultureAdhesionOptions = If[Or @@ conflictingCultureAdhesionErrors && !gatherTests,
		Module[{invalidSamples, invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples = PickList[mySamples, conflictingCultureAdhesionErrors];
			invalidOptions = invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::ConflictingCultureAdhesion,
				ObjectToString[invalidSamples, Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionErrors, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionErrors],
				PickList[cultureAdhesionsFromSample, conflictingCultureAdhesionErrors]
			];

			(* Return our invalid options. *)
			{CultureAdhesion}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	conflictingCultureAdhesionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion that matches the CultureAdhesion option value provided", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* CellType not specified options warning check *)
	If[Or@@cellTypeNotSpecifiedWarnings&&!gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::CellTypeNotSpecified, ObjectToString[PickList[mySamples, cellTypeNotSpecifiedWarnings], Cache -> cacheBall]]
	];

	(* Create the corresponding test for the invalid options. *)
	cellTypeNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cellTypeNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CellType specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CellType specified (as an option or in the Model)", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* CultureAdhesion not specified options warning check *)
	If[Or @@ cultureAdhesionNotSpecifiedWarnings && !gatherTests && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::CultureAdhesionNotSpecified,
			ObjectToString[PickList[mySamples, cultureAdhesionNotSpecifiedWarnings], Cache -> cacheBall],
			First /@ Position[cultureAdhesionNotSpecifiedWarnings, True],
			PickList[cultureAdhesions, cultureAdhesionNotSpecifiedWarnings, True]
		]
	];
	(* Create the corresponding test for the invalid options. *)
	cultureAdhesionNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cultureAdhesionNotSpecifiedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If IncubationCondition was set to a non-incubation storage type, throw an error *)
	invalidIncubationConditionOptions = If[MemberQ[invalidIncubationConditionErrors, True] && messages,
		(
			Message[
				Error::InvalidIncubationConditions,
				ObjectToString[PickList[mySamples, invalidIncubationConditionErrors], Cache -> cacheBall],
				First /@ Position[invalidIncubationConditionErrors, True],
				ObjectToString[PickList[incubationCondition, invalidIncubationConditionErrors], Cache -> cacheBall]
			];
			{IncubationCondition}
		),
		{}
	];
	invalidIncubationConditionTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, invalidIncubationConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have a specified IncubationCondition that is currently supported:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have a specified IncubationCondition that is currently supported:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Can't do Mammalian + SolidMedia, or Yeast|Bacterial + Adherent *)
	conflictingCellTypeAdhesionOptions = If[MemberQ[conflictingCellTypeAdhesionErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithCultureAdhesion,
				ObjectToString[PickList[mySamples, conflictingCellTypeAdhesionErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeAdhesionErrors, True],
				PickList[cultureAdhesions, conflictingCellTypeAdhesionErrors],
				PickList[cellTypes, conflictingCellTypeAdhesionErrors]
			];
			{CultureAdhesion, CellType}
		),
		{}
	];
	conflictingCellTypeAdhesionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeAdhesionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", don't try Mammalian+SolidMedia, or Bacterial|Yeast+Adherent:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Can't do Mammalian + Suspension right now  *)
	unsupportedCellCultureTypeOptions = If[MemberQ[unsupportedCellCultureTypeErrors, True] && messages,
		(
			Message[
				Error::UnsupportedCellCultureType,
				ObjectToString[PickList[mySamples, unsupportedCellCultureTypeErrors], Cache -> cacheBall],
				First /@ Position[unsupportedCellCultureTypeErrors, True]
			];
			{CultureAdhesion, CellType}
		),
		{}
	];
	unsupportedCellCultureTypeTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, unsupportedCellCultureTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", do not request the currently unsupported Mammalian Suspension culture:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Make sure we don't specify an incubator that conflicts with the input cell type *)
	conflictingCellTypeWithIncubatorOptions = If[MemberQ[conflictingCellTypeWithIncubatorErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithIncubator,
				ObjectToString[PickList[mySamples, conflictingCellTypeWithIncubatorErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeWithIncubatorErrors, True],
				PickList[cellTypes, conflictingCellTypeWithIncubatorErrors],
				ObjectToString[PickList[incubators, conflictingCellTypeWithIncubatorErrors], Cache -> cacheBall],
				fastAssocLookup[fastAssoc, #, CellTypes]& /@ PickList[incubators, conflictingCellTypeWithIncubatorErrors]
			];
			{Incubator, CellType}
		),
		{}
	];
	conflictingCellTypeWithIncubatorTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, unsupportedCellCultureTypeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " only specify Incubators that are compatible with the samples' cell types:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " only specify Incubators that are compatible with the samples' cell types:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If samples are not in plates, can't be be SolidMedia or Adherent *)
	conflictingCultureAdhesionWithContainerOptions = If[MemberQ[conflictingCultureAdhesionWithContainerErrors, True] && messages,
		(
			Message[
				Error::ConflictingCultureAdhesionWithContainer,
				ObjectToString[PickList[mySamples, conflictingCultureAdhesionWithContainerErrors], Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionWithContainerErrors, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionWithContainerErrors]
			];
			{CultureAdhesion}
		),
		{}
	];
	conflictingCultureAdhesionWithContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionWithContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", are in plates if CultureAdhesion is SolidMedia or Adherent:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If not disposing of things, then SamplesOutStorageCondition must be in agreement with what kind of cells we have *)
	conflictingCellTypeWithStorageConditionOptions = If[MemberQ[conflictingCellTypeWithStorageConditionErrors, True] && messages,
		(
			Message[
				Error::ConflictingCellTypeWithStorageCondition,
				ObjectToString[PickList[mySamples, conflictingCellTypeWithStorageConditionErrors], Cache -> cacheBall],
				First /@ Position[conflictingCellTypeWithStorageConditionErrors, True],
				PickList[cellTypes, conflictingCellTypeWithStorageConditionErrors],
				PickList[samplesOutStorageCondition, conflictingCellTypeWithStorageConditionErrors]
			];
			{CellType, SamplesOutStorageCondition}
		),
		{}
	];
	conflictingCellTypeWithStorageConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCellTypeWithStorageConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CellType:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CellTyps:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If not disposing of things, then SamplesOutStorageCondition must be in agreement with CultureAdhesion *)
	conflictingCultureAdhesionWithStorageConditionOptions = If[MemberQ[conflictingCultureAdhesionWithStorageConditionErrors, True] && messages,
		(
			Message[
				Error::ConflictingCultureAdhesionWithStorageCondition,
				ObjectToString[PickList[mySamples, conflictingCultureAdhesionWithStorageConditionErrors], Cache -> cacheBall],
				First /@ Position[conflictingCultureAdhesionWithStorageConditionErrors, True],
				PickList[cultureAdhesions, conflictingCultureAdhesionWithStorageConditionErrors],
				PickList[samplesOutStorageCondition, conflictingCultureAdhesionWithStorageConditionErrors]
			];
			{CultureAdhesion, SamplesOutStorageCondition}
		),
		{}
	];
	conflictingCultureAdhesionWithStorageConditionTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, conflictingCultureAdhesionWithStorageConditionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ", have SamplesOutStorageCondition that are consistent with their CultureAdhesion:", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* -- MESSAGE AND RETURN --*)



	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[
			{
				discardedInvalidInputs,
				deprecatedSampleInputs,
				uncoveredSampleInputs,
				invalidCellTypeSamples,
				invalidPlateSampleInputs,
				duplicateSamples,
				noCompatibleIncubatorsInvalidInputs,
				tooManySamples
			}
		]
	];
	invalidOptions = DeleteDuplicates[Flatten[
			{
				invalidShakingConditionsOptions,
				incompatiblePreparationAndTimeOptions,
				conflictingWorkCellAndPreparationOptions,
				conflictingCellTypeOptions,
				conflictingCultureAdhesionOptions,
				invalidCustomIncubatorsOptions,
				invalidIncubationConditionOptions,
				conflictingCellTypeAdhesionOptions,
				unsupportedCellCultureTypeOptions,
				conflictingCellTypeWithIncubatorOptions,
				conflictingCultureAdhesionWithContainerOptions,
				conflictingCellTypeWithStorageConditionOptions,
				conflictingCultureAdhesionWithStorageConditionOptions,
				conflictingIncubationConditionsForSameContainerOptions,
				incubationMaxTemperatureOptions,
				If[MatchQ[preparationResult, $Failed],
					{Preparation},
					Nothing
				],
				If[MatchQ[workCellResult, $Failed],
					{WorkCell},
					Nothing
				]
			}
		]
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];


	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[Flatten[{
			discardedTest,
			deprecatedTest,
			uncoveredContainerTest,
			invalidCellTypeTest,
			invalidPlateSampleTest,
			duplicateSamplesTest,
			incompatiblePreparationAndTimeTest,
			conflictingWorkCellAndPreparationTest,
			precisionTests,
			preparationTest,
			invalidShakingConditionsTests,
			cellTypeNotSpecifiedTests,
			cultureAdhesionNotSpecifiedTests,
			conflictingCellTypeTests,
			conflictingCultureAdhesionTests,
			invalidCustomIncubatorsTests,
			noCompatibleIncubatorTests,
			customIncubationNotSpecifiedTest,
			invalidIncubationConditionTest,
			unsupportedCellCultureTypeTests,
			conflictingCellTypeAdhesionTests,
			conflictingCellTypeWithIncubatorTests,
			conflictingCultureAdhesionWithContainerTests,
			conflictingCellTypeWithStorageConditionTests,
			conflictingCultureAdhesionWithStorageConditionTests,
			conflictingIncubationConditionsForSameContainerTests,
			incubationMaxTemperatureTests,
			tooManySamplesTest,
			workCellTest
		}], _EmeraldTest]
	}
];

(* ::Subsubsection::Closed:: *)
(* incubateCellsResourcePackets *)


DefineOptions[
	incubateCellsResourcePackets,
	Options :> {
		SimulationOption,
		CacheOption,
		HelperOutputOption
	}
];

incubateCellsResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myCollapsedResolvedOptions: {___Rule}, ops:OptionsPattern[]] := Module[
	{
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, simulation,
		samplePackets, containersNoDupes, sampleResources, sampleContainerResources, allResourceBlobs, fulfillable, frqTests,
		testsRule, resultRule, customIncubationOptions, containerResourceRules, allIncubationStorageConditionSymbols,
		protocolID, unitOperationID, cellTypes, cultureAdhesions, temperatures, carbonDioxidePercentages, relativeHumidities,
		time, shakingRates, incubators, resolvedStorageConditions, groupedOptions, customIncubators, uniqueContainerPositions,
		parentProtocol, instrumentResourcesLink, incubatorResources, previewRule, optionsRule, nonHiddenOptions, safeOps,
		cache, fastAssoc, containerPackets, preparation, incubationConditions, containers, containerMovesToDifferentStorageConditionQs,
		containerStoredInNonIncubatorQs, nonIncubationStorageContainerObjs, nonIncubationStorageContainerResources,
		defaultIncubatorQs, nonIncubationStorageContainerConditions, postDefaultIncubationContainerObjs,
		postDefaultIncubationContainerResources, defaultIncubationContainerObjs, defaultIncubationContainerResources,
		shakes, shakingRadii, samplesOutStorageConditionSymbols, unitOperationPacket, fastAssocKeysIDOnly, storageConditionPackets,
		incubationConditionSymbols, incubationConditionObjects, incubationStorageConditionSymbols, manualProtocolPacket
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentIncubateCells, myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentIncubateCells,
		RemoveHiddenOptions[ExperimentIncubateCells, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[incubateCellsResourcePackets, ToList[ops]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[Output, Tests];
	messages = Not[gatherTests];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* Pull out the packets from the fast assoc *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	containers = Lookup[containerPackets, Object];
	storageConditionPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[StorageCondition]]];


	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* Prepare the sample resources *)
	sampleResources = Resource[Sample -> #, Name -> ToString[#]]& /@ mySamples;

	(* Pull out the necessary resolved options that need to be in discrete fields in the protocol object *)
	{
		cellTypes,
		cultureAdhesions,
		temperatures,
		carbonDioxidePercentages,
		relativeHumidities,
		time,
		shakes,
		shakingRates,
		shakingRadii,
		incubators,
		resolvedStorageConditions,
		incubationConditions,
		preparation,
		parentProtocol
	} = Lookup[myResolvedOptions,
		{
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Time,
			Shake,
			ShakingRate,
			ShakingRadius,
			Incubator,
			SamplesOutStorageCondition,
			IncubationCondition,
			Preparation,
			ParentProtocol
		}
	];

	(* Prepare the container resources *)
	containersNoDupes = DeleteDuplicates[containers];
	sampleContainerResources = Resource[Sample -> #, Name -> ToString[#]]& /@ containersNoDupes;
	containerResourceRules = AssociationThread[containersNoDupes, sampleContainerResources];

	(* Create a list of all of the possible incubation storage condition sybmols *)
	allIncubationStorageConditionSymbols = Lookup[storageConditionPackets,StorageCondition];
	
	(* Figure out the samples out storage condition symbol *)
	samplesOutStorageConditionSymbols = Map[
		If[MatchQ[#, ObjectP[Model[StorageCondition]]],
			fastAssocLookup[fastAssoc, #, StorageCondition],
			#
		]&,
		resolvedStorageConditions
	];

	(* Figure out the incubation condition symbols and objects *)
	incubationConditionSymbols = Map[
		If[MatchQ[#, ObjectP[Model[StorageCondition]]],
			fastAssocLookup[fastAssoc, #, StorageCondition],
			#
		]&,
		incubationConditions
	];
	incubationConditionObjects = Map[
		Which[
			(* custom doesn't have a storage condition object that goes with it *)
			MatchQ[#, Custom], Null,
			MatchQ[#, ObjectP[Model[StorageCondition]]], #,
			(* get the storage condition object that corresponds to the symbol we have already *)
			True, Lookup[FirstCase[storageConditionPackets, KeyValuePattern[StorageCondition -> #], <|Object -> Null|>], Object]
		]&,
		incubationConditions
	];
	incubationStorageConditionSymbols = Lookup[Cases[storageConditionPackets, KeyValuePattern[Object -> ObjectP[$IncubatorStorageConditions]]],StorageCondition];

	(* Determine if a given container needs to be stored in a different incubator than the one we incubated in *)
	(* this excludes all the custom ones *)
	containerMovesToDifferentStorageConditionQs = MapThread[
		Function[{incubationConditionSymbol, storageConditionSymbol},
			Not[MatchQ[incubationConditionSymbol, Custom]] && incubationConditionSymbol =!= storageConditionSymbol && MemberQ[incubationStorageConditionSymbols,incubationConditionSymbol]
		],
		{incubationConditionSymbols, samplesOutStorageConditionSymbols}
	];

	(* Determine if a given container is going to be stored not in an incubator after the experiment *)
	containerStoredInNonIncubatorQs = Map[
		Function[{storageConditionSymbol},
			!MemberQ[incubationStorageConditionSymbols, storageConditionSymbol]
		],
		samplesOutStorageConditionSymbols
	];

	(* Determine if a given container is going to be stored in a custom incubator or default incubator during the experiment *)
	defaultIncubatorQs = Map[
		!MatchQ[#, Custom]&,
		incubationConditions
	];

	(* Determine if a given container is going into a default incubation condition *)
	(* this is just everything that doesn't have Custom IncubationCondition *)
	(* don't need to do any of this for robotic; all Robotic are Custom anyway though so don't need to be explicit about Robotic here *)
	defaultIncubationContainerObjs = DeleteDuplicates[PickList[containers, defaultIncubatorQs]];
	defaultIncubationContainerResources = defaultIncubationContainerObjs /. containerResourceRules;

	(* Determine if a given container is going to be moved to non incubation condition after the experiment *)
	(* Note this container can be either a CustomIncubationConditionContainer or a DefaultIncubationConditionContainer *)
	nonIncubationStorageContainerObjs = PickList[containers, containerStoredInNonIncubatorQs];
	nonIncubationStorageContainerResources = nonIncubationStorageContainerObjs /. containerResourceRules;
	nonIncubationStorageContainerConditions = PickList[samplesOutStorageConditionSymbols, containerStoredInNonIncubatorQs];

	(* Generate the PostDefaultIncubationContainers field *)
	(* Determine if a given container is stored at default incubator, is it going to be stored in another default incubation condtion after the experiment*)
	postDefaultIncubationContainerObjs = DeleteDuplicates[PickList[containers, MapThread[And[#1, Not[#2], #3]&, {containerMovesToDifferentStorageConditionQs, containerStoredInNonIncubatorQs, defaultIncubatorQs}]]];
	postDefaultIncubationContainerResources = postDefaultIncubationContainerObjs /. containerResourceRules;

	(* If we have a custom incubator, make a resource for that incubator (note that we do NOT make resources for non-custom incubators) *)
	(* note that we're excluding the robotic custom incubators because the framework will make those resources *)
	customIncubators = If[MatchQ[preparation, Robotic],
		{},
		DeleteDuplicates[PickList[incubators, incubationConditions, Custom]]
	];
	incubatorResources = Map[
		Resource[Instrument -> #, Time -> time, Name -> ToString[#]]&,
		customIncubators
	];
	instrumentResourcesLink = Link /@ (incubators /. AssociationThread[customIncubators, incubatorResources]);

	(* --- Batch the manual stuff --- *)

	(* We want to work with everything in terms of Containers*)
	(* Get the first position of each unique container *)
	uniqueContainerPositions = FirstPosition[containers,#]&/@containersNoDupes;
	
	(* Group the options by incubation condition; really all I want here are the custom incubations that I can then put together in a UnitOperation object *)
	(* the default incubations will get made during an execute function later *)
	groupedOptions = groupByKey[
		{
			Container -> Link /@ (Extract[containers, uniqueContainerPositions] /. containerResourceRules),
			Time -> time,
			CellType -> Extract[cellTypes, uniqueContainerPositions],
			CultureAdhesion -> Extract[cultureAdhesions, uniqueContainerPositions],
			Temperature -> Extract[temperatures, uniqueContainerPositions],
			CarbonDioxide -> Extract[carbonDioxidePercentages, uniqueContainerPositions],
			RelativeHumidity -> Extract[relativeHumidities, uniqueContainerPositions],
			Shake -> Extract[shakes, uniqueContainerPositions],
			ShakingRate -> Extract[shakingRates, uniqueContainerPositions],
			ShakingRadius -> Extract[shakingRadii, uniqueContainerPositions],
			Incubator -> Extract[instrumentResourcesLink, uniqueContainerPositions],
			SamplesOutStorageCondition -> Extract[samplesOutStorageConditionSymbols, uniqueContainerPositions],
			IncubationCondition -> Extract[incubationConditions, uniqueContainerPositions]
		},
		(* note that we don't actually have to do any grouping if we're doing robotic *)
		If[MatchQ[preparation, Robotic],
			{},
			{IncubationCondition}
		]
	];

	(* Get the custom incubation options *)
	customIncubationOptions = FirstCase[groupedOptions, {{IncubationCondition -> Custom}, customOptions:{__Rule}} :> customOptions, Null];

	(* Make the IDs for the protocol object and the unit operation objects *)
	{protocolID, unitOperationID} = Which[
		(* for robotic, don't need to do either of these *)
		MatchQ[preparation, Robotic], {Null, Null},
		(* for manual with no custom, only need to make protocol object *)
		Not[MemberQ[incubationConditions, Custom]], {CreateID[Object[Protocol, IncubateCells]], Null},
		(* for manual with custom, we need to make precisely one unit operation object (because we can only have one custom batch) *)
		True, CreateID[{Object[Protocol, IncubateCells], Object[UnitOperation, IncubateCells]}]
	];

	(* Get all the non-hidden options that go into the unit operation objects *)
	nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, IncubateCells]];

	(* Generate the relevant unit operation packets *)
	unitOperationPacket = Which[
		MatchQ[preparation, Manual] && NullQ[customIncubationOptions], {},
		MatchQ[preparation, Manual],
			Module[{customUnitOperation, unitOpPacket},

				customUnitOperation = IncubateCells @@ ReplaceRule[
					Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
					{
						Sample -> Lookup[customIncubationOptions, Container],
						Time -> Lookup[customIncubationOptions, Time],
						CellType -> Lookup[customIncubationOptions, CellType],
						CultureAdhesion -> Lookup[customIncubationOptions, CultureAdhesion],
						Temperature -> Lookup[customIncubationOptions, Temperature],
						CarbonDioxide -> Lookup[customIncubationOptions, CarbonDioxide],
						RelativeHumidity -> Lookup[customIncubationOptions, RelativeHumidity],
						Shake -> Lookup[customIncubationOptions, Shake],
						ShakingRate -> Lookup[customIncubationOptions, ShakingRate],
						ShakingRadius -> Lookup[customIncubationOptions, ShakingRadius],
						Incubator -> Lookup[customIncubationOptions, Incubator],
						SamplesOutStorageCondition -> Lookup[customIncubationOptions, SamplesOutStorageCondition],
						IncubationCondition -> Lookup[customIncubationOptions, IncubationCondition]
					}
				];

				unitOpPacket = UploadUnitOperation[
					customUnitOperation,
					UnitOperationType -> Batched,
					Preparation -> Manual,
					FastTrack -> True,
					Upload -> False
				]
			],
		(* Robotic branch *)
		True,
			UploadUnitOperation[
				IncubateCells @@ Join[
					{
						Sample -> sampleResources
					},
					Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]]
				],
				Preparation -> Robotic,
				UnitOperationType -> Output,
				FastTrack -> True,
				Upload -> False
			]
	];

	(* Generate the raw protocol packet *)
	manualProtocolPacket = <|
		Object -> protocolID,
		Replace[BatchedUnitOperations] -> If[MatchQ[unitOperationPacket, {}],
			{},
			{Link[Lookup[unitOperationPacket, Object], Protocol]}
		],
		Name -> Lookup[myResolvedOptions, Name],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ sampleContainerResources),
		(* if we are in the root protocol here, then mark it as Overclock -> True *)
		(* if we're not in the root protocol here, then don't worry about it and in the parent function we will mark the root as Overclock -> True *)
		(* if we're robotic then it will get set in RCP itself *)
		If[NullQ[parentProtocol],
			Overclock -> True,
			Nothing
		],
		Time -> time,
		Replace[Incubators] -> instrumentResourcesLink,
		Replace[IncubationConditions] -> incubationConditionSymbols,
		Replace[IncubationConditionObjects] -> Link[incubationConditionObjects],
		Replace[Temperatures] -> temperatures,
		Replace[RelativeHumidities] -> relativeHumidities,
		Replace[CarbonDioxide] -> carbonDioxidePercentages,
		Replace[CellTypes] -> cellTypes,
		Replace[CultureAdhesions] -> cultureAdhesions,
		Replace[ShakingRates] -> shakingRates,
		Replace[ShakingRadii] -> shakingRadii,
		Replace[DefaultIncubationContainers] -> (Link[#] & /@ defaultIncubationContainerResources),
		Replace[PostDefaultIncubationContainers] -> (Link[#]& /@ postDefaultIncubationContainerResources),
		Replace[NonIncubationStorageContainers] -> Link /@ nonIncubationStorageContainerResources,
		Replace[NonIncubationStorageContainerConditions] -> nonIncubationStorageContainerConditions,
		Replace[SamplesOutStorage] -> samplesOutStorageConditionSymbols,
		UnresolvedOptions -> unresolvedOptionsNoHidden,
		ResolvedOptions -> resolvedOptionsNoHidden,
		Replace[Checkpoints] -> {
			{"Reserving Incubators", 5 Minute, "Reservations of StorageAvailability of Default incubators.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 5 Minute]]},
			{"Loading Incubators", 30 Minute, "Store containers into cell incubators with desired incubation conditions-PreIncubation Loop.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 30 Minute]]},
			{"Incubating Samples", time, "Keep containers inside of cell incubators with desired incubation conditions.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> time]]},
			{"Storing Samples", 30 Minute, "Store containers into SamplesOutStorageCondition -PostIncubation Loop.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 30 Minute]]}
		}
	|>;

	(* Get all of the resource out of the packet so they can be tested*)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[{unitOperationPacket, manualProtocolPacket}], _Resource, Infinity]];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		(* don't need to do this here becuase framework will already call it itself for the robotic case *)
		MatchQ[preparation, Robotic], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulation, Cache -> cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulation, Messages -> messages, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentIncubateCells, myResolvedOptions],
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> Which[
		MatchQ[preparation, Manual] && MemberQ[output, Result] && TrueQ[fulfillable],
			{manualProtocolPacket, unitOperationPacket},
		(* for robotic, the result is Null for the protocol packet (because we're going to generate the real thing later in RoboticCellPreparation) *)
		MemberQ[output, Result] && TrueQ[fulfillable],
			{Null, unitOperationPacket},
		True, $Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentIncubateCells,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentIncubateCells[
	myProtocolPacket : (PacketP[Object[Protocol, IncubateCells], {Object, ResolvedOptions}] | $Failed | Null),
	myUnitOperationPackets : ({PacketP[]...} | $Failed),
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentIncubateCells]
] := Module[
	{cache, simulation, samplePackets, protocolObject, resolvedPreparation,
		fulfillmentSimulation, fastAssoc},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Download containers from our sample packets. *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;

	(* Lookup our resolved preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[resolvedPreparation, Robotic],
			SimulateCreateID[Object[Protocol, RoboticCellPreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol, IncubateCells]],
		True,
			Lookup[myProtocolPacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation = Which[
		(* When Preparation -> Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticCellPreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[Object[UnitOperation, IncubateCells]]..}],
			Module[{protocolPacket},
				protocolPacket = <|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
					],
					(* not sure when we'll ever need to do this but we can keep it for now *)
					Replace[RequiredInstruments] -> DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions -> {}
				|>;

				SimulateResources[
					protocolPacket,
					myUnitOperationPackets,
					ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
					Cache -> cache,
					Simulation -> simulation
				]
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, IncubateCells]. *)
		True,
			SimulateResources[
				myProtocolPacket,
				myUnitOperationPackets,
				Cache -> cache,
				Simulation -> simulation
			]
	];


	(* Merge our packets with our simulation. *)
	(* note that we don't have any label options for our current experiment so truly all this is is passing the SimulateResources down *)
	{
		protocolObject,
		fulfillmentSimulation
	}
];

(* ::Subsubsection:: *)
(* Helper functions*)
(* nonDeprecatedIncubatorsSearch - memoized to prevent multiple round trips to the database in one kernel session*)
nonDeprecatedIncubatorsSearch[testString: _String] := nonDeprecatedIncubatorsSearch[testString] = Module[{},
	(*Add nonDeprecatedIncubatorsSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`nonDeprecatedIncubatorsSearch];

	Flatten@Search[
		{
			Model[Instrument, Incubator]
		},
		(*don't want incubators that are not _cell_ incubators *)
		Deprecated == (False|Null) && DeveloperObject != True && CellTypes != Null
	]
];

(* Find all possible racks (we need this for determining if containers will fit in the incubator racks)
 Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allIncubatorRacksSearch[testString: _String] := allIncubatorRacksSearch[testString] = Module[{},
	(*Add allIncubatorRacksSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubatorRacksSearch];
	Search[Model[Container, Rack], Deprecated != True && Footprint == CellIncubatorRackP, SubTypes -> False]
];

(* Find all possible Decks (we need this to see which racks are associated with each incubator for those that have them, and the dimension of the decks for those without racks)
 Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allIncubatorDecksSearch[testString: _String] :=allIncubatorDecksSearch[testString] = Module[{},
	(*Add allIncubatorDecksSearch to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubatorDecksSearch];
	Search[Model[Container, Deck], Deprecated != True && Footprint == CellIncubatorDeckP, SubTypes -> False]
];

(* find all possible incubation conditions; note that this, weirdly, includes _all_ storage conditions because we need information about non-incubation ones too (so that if someone tries something we know it's wrong I think?  maybe revisit this later) *)
allIncubationStorageConditions[testString_String] := allIncubationStorageConditions[testString] = Module[{},
	(*Add allIncubationStorageConditions to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allIncubationStorageConditions];
	Search[Model[StorageCondition], DeveloperObject != True]
];

(* ::Subsubsection:: *)
(*compatibleCellIncubationContainers*)
allCellIncubationContainersSearch[testString: _String] := allCellIncubationContainersSearch[testString] = Module[{},
	(*Add compatibleCellIncubationContainers to list of Memoized functions*)
	AppendTo[$Memoization, Experiment`Private`allCellIncubationContainersSearch];
	Flatten@Search[
		{Model[Container, Plate], Model[Container, Vessel]},
		Footprint == (Erlenmeyer50mLFlask|Erlenmeyer125mLFlask|Erlenmeyer250mLFlask|Erlenmeyer500mLFlask|Erlenmeyer1000mLFlask|Plate),
		SubTypes -> False
	]
];

(* ::Subsubsection:: *)
(*$CellIncubatorMaxCapacity*)

(* temporary variable storing the max capacity of all the relevant footprints of the incubator *)

(* FOR NOW HARD CODING BECAUSE IT IS NOT IMMEDIATELY OBVIOUS HOW TO STORE THIS IN CODE INTELLIGENTLY *)
(* making a lookup table for how many plates fit into each model of incubator we care about *)
$CellIncubatorMaxCapacity = <|
	(*"Multitron Pro with 3mm Orbit"*)
	Model[Instrument, Incubator, "id:GmzlKjY5EEG9"] -> <|Plate -> 20|>,
	(*"Multitron Pro with 25mm Orbit"*)
	Model[Instrument, Incubator, "id:AEqRl954GG0l"] -> <|Erlenmeyer1000mLFlask -> 6,  Erlenmeyer500mLFlask -> 8, Erlenmeyer250mLFlask -> 10|>,
	(*"STX44-ICBT with Humidity Control"*)
	Model[Instrument, Incubator, "id:AEqRl954GpOw"] -> <|Plate -> 20|>,
	(*"STX44-ICBT with Shaking"*)
	Model[Instrument, Incubator, "id:N80DNjlYwELl"] -> <|Plate -> 16|>,
	(*"Cytomat HERAcell 240i TT 10"*)
	Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"] -> <|Plate -> 210|>,
	(*"Bactomat HERAcell 240i TT 10 for Yeast"*)
	Model[Instrument, Incubator, "id:7X104vK9ZbLR"] -> <|Plate -> 210|>,
	(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
	Model[Instrument, Incubator, "id:xRO9n3vk1JbO"] -> <|Plate -> 210|>,
	(*"Innova 44 for Yeast Plates"*)
	Model[Instrument, Incubator, "id:O81aEB4kJJre"] -> <|Plate -> 48|>,
	(*"Innova 44 for Bacterial Plates"*)
	Model[Instrument, Incubator, "id:AEqRl954Gpjw"] -> <|Plate -> 48|>,
	(*"Innova 44 for Bacterial Flasks"*)
	Model[Instrument, Incubator, "id:D8KAEvdqzXok"] -> <|Erlenmeyer1000mLFlask -> 6, Erlenmeyer250mLFlask -> 8, Erlenmeyer125mLFlask -> 11|>,
	(*"Innova 44 for Yeast Flasks"*)
	Model[Instrument, Incubator, "id:rea9jl1orkAx"] -> <|Erlenmeyer1000mLFlask -> 6, Erlenmeyer250mLFlask -> 8, Erlenmeyer125mLFlask -> 11|>
|>;


(* ::Subsection::Closed:: *)
(*IncubateCellsDevices*)

DefineOptions[IncubateCellsDevices,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Temperature,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 Celsius], Units -> Celsius]
				],
				Description -> "Temperature at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 37 Celsius if the CellType is Mammalian for this sample, otherwise resolves to the default temperature for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> CarbonDioxide,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
					Units -> Percent
				],
				Description -> "Percent CO2 at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 5% if the CellType is Mammalian for this sample, otherwise resolves to the default percentage for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> RelativeHumidity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent, 1 Percent],
					Units -> Percent
				],
				Description -> "Percent humidity at which the SamplesIn should be incubated.",
				ResolutionDescription -> "Resolves to 93% if the CellType is Mammalian, otherwise resolves to the default percentage for the specified CellType.",
				Category -> "General"
			},
			{
				OptionName -> Shake,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if any samples should be shaken during incubation.",
				ResolutionDescription -> "Resolves to True if any corresponding Shake options are set. Otherwise, resolves to False.",
				Category -> "General"
			},
			{
				OptionName -> ShakingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> RPM],
				Description -> "Frequency of rotation the shaking incubator instrument should use to mix the samples.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model.",
				Category -> "General"
			},
			{
				OptionName -> ShakingRadius,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellIncubatorShakingRadiusP (*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
				],
				Description -> "Frequency of rotation the shaking incubator instrument should use to mix the samples.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model.",
				Category -> "General"
			},
			{
				OptionName -> CellType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
				Description -> "The primary types of cells that are contained within this sample.",
				ResolutionDescription -> "Automatically set based on the input. If left Null, this will resolve to Bacterial.",
				Category -> "General"
			},
			{
				OptionName -> CultureAdhesion,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
				Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells.
				If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
				ResolutionDescription -> "Automatically set based on the sample container and instrument model. If left Null, this will resolve to Suspension.",
				Category -> "General"
			}
		],
		PreparationOption,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices - Messages*)


Error::OptionLengthDisagreement = "The options `1` do not have the same length. Please check that the lengths of any listed options match.";
Error::ConflictingIncubationConditionWithOptions = "The options `4` for inputs `1` are specified as `3`. But `1` have `4` set at `2`. Please choose a different StorageCondition as input or let the option value resolves automatically.";


(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Instrument Download Fields *)

cellIncubatorInstrumentDownloadFields[]:={
	Name,Model,Objects,Mode,CellTypes,ShakingRadius,MinShakingRate,MaxShakingRate,DefaultShakingRate,
	Positions,MinTemperature,MaxTemperature,DefaultTemperature,MinCarbonDioxide,MaxCarbonDioxide,DefaultCarbonDioxide,
	MinRelativeHumidity,MaxRelativeHumidity,DefaultRelativeHumidity,ProvidedStorageCondition
};

(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Rack Download Fields *)

cellIncubatorRackDownloadFields[]:={
	Name,Model,Container,Positions,Footprint,MinTemperature,MaxTemperature
};

(* ::Subsubsection::Closed:: *)
(* IncubateCellsDevices - Deck Download Fields *)

cellIncubatorDeckDownloadFields[]:={
	Name,Footprint,Container,Positions
};

(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices*)


(* Overload with no container inputs (to find all incubators that can attain the desired settings, regardless of container) *)
IncubateCellsDevices[myOptions: OptionsPattern[]] := IncubateCellsDevices[All, myOptions];

(* Main Overload with All (all possible container inputs) *)
IncubateCellsDevices[myInput: All, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOps,  safeOpsTests, cacheOption, simulation,
		cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption,
		shakingOption, shakingRateOption, shakingRadiusOption, prepModeOption, listedOptionLengths, optionLengthTest,
		expandedCellTypeOption, expandedCultureAdhesionOption, expandedTemperatureOption, expandedCarbonDioxidePercentageOption,
		expandedRelativeHumidityOption, expandedShakingOption, expandedShakingRateOption, expandedShakingRadiusOption,
		allCellIncubationContainers, incubatorInstruments, incubatorRacks, incubatorDecks, incubatorInstrumentFields,
		incubatorRackFields, incubatorDeckFields, downloadedStuff, expandedContainers, expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer, expandedTemperatureOptionByContainer, expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer, expandedShakingOptionByContainer, expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer, containerOptionSets, uniqueOptionSets, uniqueContainers,
		uniqueCellType, uniqueCultureAdhesion, uniqueTemperature, uniqueCarbonDioxidePercentage, uniqueRelativeHumidity,
		uniqueShaking, uniqueShakingRate, uniqueShakingRadius, incubationDevicesByUniqueSet, setRules, resultRules,
		incubationDevicesBySet, incubatorsByOptionsByContainer, incubationContainerSetsByOptions, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Pull out options and assign them to variables *)
	{
		cacheOption,
		simulation,
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption,
		prepModeOption
	} = Lookup[safeOps,
		{
			Cache,
			Simulation,
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius,
			Preparation
		}];

	(* This overload doesn't have any input, so we can't use the built in index matching checks to make sure the options are the right length/to expand the options.
	Instead, do this manually below. *)

	(* Figure out the length of each option that was provided as a list *)
	listedOptionLengths = Map[
		If[ListQ[#], Length[#], Nothing]&,
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		}
	];

	(* Give an error if there are any listed options with differing lengths *)
	optionLengthTest = If[!Length[DeleteDuplicates[listedOptionLengths]] > 1,
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The lengths of all listed options are the same:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The lengths of these listed options are the same " <> ToString[
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]] <> ":",
				False,
				True
			],
			Message[Error::OptionLengthDisagreement,
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[Length[DeleteDuplicates[listedOptionLengths]] > 1,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, optionLengthTest}]
		}]
	];

	(* Expand any singleton options *)
	{
		expandedCellTypeOption,
		expandedCultureAdhesionOption,
		expandedTemperatureOption,
		expandedCarbonDioxidePercentageOption,
		expandedRelativeHumidityOption,
		expandedShakingOption,
		expandedShakingRateOption,
		expandedShakingRadiusOption
	} = If[ListQ[#], #, ConstantArray[#, Max[listedOptionLengths, 1]]] & /@
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		};

	(* Incubators and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the incubator/deck/rack/container combo in order to determine if the container is compatible with the incubator) *)
	allCellIncubationContainers = allCellIncubationContainersSearch["Memoization"];

	(* Find all incubator-related objects (instruments, racks, and decks) from which we might need information *)
	(* Rather than downloading this information through links, we now need to find ALL incubator-related objects that we might need to look at *)
	(* Search for all incubator models in the lab to download from. *)
	incubatorInstruments = nonDeprecatedIncubatorsSearch["Memoization"];
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Downloaded stuff about the incubators/racks/decks that can be used for each container model *)
	downloadedStuff = Quiet[
		Download[
			{
				ToList[allCellIncubationContainers],
				incubatorInstruments,
				incubatorRacks,
				incubatorDecks
			},
			{
				{Packet[Footprint, Dimensions]},
				{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
				{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
				{Evaluate[Packet[Sequence @@ incubatorDeckFields]]}
			},
			Cache -> cacheOption,
			Simulation -> simulation
		],
		Download::FieldDoesntExist
	];

	(* Expand the containers and options *)
	expandedContainers = ConstantArray[allCellIncubationContainers, Length[expandedTemperatureOption]];
	{
		expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer,
		expandedTemperatureOptionByContainer,
		expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer,
		expandedShakingOptionByContainer,
		expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer
	} = Map[
		Flatten[Transpose[ConstantArray[#, Length[allCellIncubationContainers]]], 1]&,
		{
			expandedCellTypeOption,
			expandedCultureAdhesionOption,
			expandedTemperatureOption,
			expandedCarbonDioxidePercentageOption,
			expandedRelativeHumidityOption,
			expandedShakingOption,
			expandedShakingRateOption,
			expandedShakingRadiusOption
		}
	];

	(* Get each container with its options *)
	containerOptionSets = Transpose[{
		Flatten[expandedContainers],
		expandedCellTypeOptionByContainer,
		expandedCultureAdhesionOptionByContainer,
		expandedTemperatureOptionByContainer,
		expandedCarbonDioxidePercentageOptionByContainer,
		expandedRelativeHumidityOptionByContainer,
		expandedShakingOptionByContainer,
		expandedShakingRateOptionByContainer,
		expandedShakingRadiusOptionByContainer
	}];

	(* Get just unique container-option sets. *)
	uniqueOptionSets = DeleteDuplicates[containerOptionSets];

	{
		uniqueContainers,
		uniqueCellType,
		uniqueCultureAdhesion,
		uniqueTemperature,
		uniqueCarbonDioxidePercentage,
		uniqueRelativeHumidity,
		uniqueShaking,
		uniqueShakingRate,
		uniqueShakingRadius
	} = Transpose[uniqueOptionSets];

	(* For each unique container-option set, call the container overload on all incubatable container models *)
	(* Do not return tests from calling each unique container *)
	incubationDevicesByUniqueSet = IncubateCellsDevices[
		uniqueContainers,
		ReplaceRule[safeOps,
			{
				CellType -> uniqueCellType,
				CultureAdhesion -> uniqueCultureAdhesion,
				Temperature -> uniqueTemperature,
				CarbonDioxide -> uniqueCarbonDioxidePercentage,
				RelativeHumidity -> uniqueRelativeHumidity,
				Shake -> uniqueShaking,
				ShakingRate -> uniqueShakingRate,
				ShakingRadius -> uniqueShakingRadius,
				Cache -> Cases[Flatten[downloadedStuff], PacketP[]],
				Output -> Result
			}
		]
	];

	(* Order the incubation devices result by the original expanded option sets by using rules that relate each original set and each result to its index in the unique sets *)
	setRules = MapIndexed[Rule[#1, #2[[1]]] &, uniqueOptionSets];
	resultRules = MapIndexed[Rule[#2[[1]], #1] &, incubationDevicesByUniqueSet];
	incubationDevicesBySet = (containerOptionSets /. setRules) /. resultRules;

	(* Partition the result to reflect the incubators for each option set for each possible container *)
	incubatorsByOptionsByContainer = Unflatten[incubationDevicesBySet, expandedContainers];

	(* For each option set, return the incubators that would work along with the containers that the incubator is compatible with *)
	incubationContainerSetsByOptions = Map[
		Function[incubatorsByContainer,
			With[{
				(* Organize the containers and the incubators that would work for each container with the given settings into a list of {incubator,container} pairs *)
				incubatorContainerPairs = Flatten[
					MapThread[
						Function[{container, incubators},
							Map[
								Function[incubator,
									{incubator, container}
								],
								incubators
							]
						],
						{allCellIncubationContainers, incubatorsByContainer}
					],
					1]
				},
				(* Organize the info into a list in the form {{incubator, {containers}} .. } *)
				Map[{#[[1, 1]], #[[All, 2]]} &, GatherBy[incubatorContainerPairs, First]]
			]
		],
		incubatorsByOptionsByContainer
	];

	(* If none of the options were listed, remove one level of listing, otherwise return the incubator/container info as is *)
	resultOutput = If[MatchQ[listedOptionLengths, {}],
		First[incubationContainerSetsByOptions],
		incubationContainerSetsByOptions
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, optionLengthTest}]
	}

];

(* Singleton overload *)
IncubateCellsDevices[myInput: ObjectP[{Model[Container], Object[Container], Object[Sample], Model[StorageCondition]}], myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOps,  safeOpsTests, cellTypeOption, cultureAdhesionOption,
		temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption,
		shakingRadiusOption, listedOptionLengths, optionLengthTest, expandedCellTypeOption, expandedCultureAdhesionOption,
		expandedTemperatureOption, expandedCarbonDioxidePercentageOption, expandedRelativeHumidityOption, expandedShakingOption,
		expandedShakingRateOption, expandedShakingRadiusOption, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, ToList[myOptions], AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Pull out options and assign them to variables *)
	{
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption
	} = Lookup[safeOps,
		{
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius
		}];

	(* Figure out the length of each option that was provided as a list *)
	listedOptionLengths = Map[
		If[ListQ[#], Length[#], Nothing]&,
		{
			cellTypeOption,
			cultureAdhesionOption,
			temperatureOption,
			carbonDioxidePercentageOption,
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption
		}
	];

	(* Give an error if there are any listed options with differing lengths *)
	optionLengthTest = If[!Length[DeleteDuplicates[listedOptionLengths]] > 1,
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The lengths of all listed options are the same:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The lengths of these listed options are the same " <> ToString[
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]] <> ":",
				False,
				True
			],
			Message[Error::OptionLengthDisagreement,
				PickList[{CellType, CultureAdhesion, Temperature, CarbonDioxide, RelativeHumidity, Shake, ShakingRate, ShakingRadius}, {cellTypeOption, cultureAdhesionOption, temperatureOption, carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption}, _List]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[Length[DeleteDuplicates[listedOptionLengths]] > 1,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, optionLengthTest}]
		}]
	];

	(* Expand any singleton options *)
	{
		 expandedCellTypeOption,
		 expandedCultureAdhesionOption,
		 expandedTemperatureOption,
		 expandedCarbonDioxidePercentageOption,
		 expandedRelativeHumidityOption,
		 expandedShakingOption,
		 expandedShakingRateOption,
		 expandedShakingRadiusOption
	} = If[ListQ[#], #, ConstantArray[#, Max[listedOptionLengths, 1]]] & /@
     {
			 cellTypeOption,
			 cultureAdhesionOption,
			 temperatureOption,
			 carbonDioxidePercentageOption,
			 relativeHumidityOption,
			 shakingOption,
			 shakingRateOption,
			 shakingRadiusOption
		 };

	(* Call IncubateCellsDevices on the listed inputs *)
	output = IncubateCellsDevices[
		ConstantArray[myInput, Max[listedOptionLengths, 1]],
		ReplaceRule[safeOps,
			{
				 CellType -> expandedCellTypeOption,
				 CultureAdhesion -> expandedCultureAdhesionOption,
				 Temperature -> expandedTemperatureOption,
				 CarbonDioxide -> expandedCarbonDioxidePercentageOption,
				 RelativeHumidity -> expandedRelativeHumidityOption,
				 Shake -> expandedShakingOption,
				 ShakingRate -> expandedShakingRateOption,
				 ShakingRadius -> expandedShakingRadiusOption
			}
		]
	];


	resultOutput = Which[
		MatchQ[output, $Failed],
			$Failed,
		GreaterQ[Max[listedOptionLengths, 1], 1],
			output,
		True,
			FirstOrDefault[output, {}]
	];

	(* If the result is $Failed, return that. Otherwise, get the unlisted output. *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, optionLengthTest}]
	}
];

(* StorageCondition overload *)
IncubateCellsDevices[myInputs: {___, ObjectP[Model[StorageCondition]], ___}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, cache, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, incubationStorageConditions, positionsOfStorageCondition, cellTypesFromSafeOps,
		temperaturesFromSafeOps, carbonDioxidesFromSafeOps, relativeHumiditiesFromSafeOps, shakingsFromSafeOps,
		shakingRatesFromSafeOps, shakingRadiiFromFromSafeOps, cultureAdhesionsFromSafeOps, prepModesFromSafeOps,
		updatedInputs, downloadedStuff, cellTypesFromStorageCondition, cultureAdhesionsFromStorageCondition,
		rawTemperaturesFromStorageCondition, rawCarbonDioxidesFromStorageCondition, rawRelativeHumiditiesFromStorageCondition,
		rawShakingRadiiFromStorageCondition, temperaturesFromStorageCondition, carbonDioxidesFromStorageCondition,
		relativeHumiditiesFromStorageCondition, shakingsFromStorageCondition, shakingRatesFromStorageCondition,
		possibleShakingRatesFromStorageConditions, shakingRadiiFromStorageCondition, prepModesFromStorageCondition,
		conflictingOptions, conflictingOptionTest, updatedOptions
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];
	cache = Lookup[listedOptions, Cache];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Extract StorageCondition inputs *)
	incubationStorageConditions = Cases[myInputs, ObjectP[Model[StorageCondition]]];
	(* Positions of extracted StorageCondition inputs from myInput *)
	positionsOfStorageCondition = Position[myInputs, ObjectP[Model[StorageCondition]]];
	(* Pull out options from safe ops *)
	cellTypesFromSafeOps = Extract[Lookup[expandedSafeOps, CellType], positionsOfStorageCondition];
	temperaturesFromSafeOps = Extract[Lookup[expandedSafeOps, Temperature], positionsOfStorageCondition];
	carbonDioxidesFromSafeOps = Extract[Lookup[expandedSafeOps, CarbonDioxide], positionsOfStorageCondition];
	relativeHumiditiesFromSafeOps = Extract[Lookup[expandedSafeOps, RelativeHumidity], positionsOfStorageCondition];
	shakingsFromSafeOps = Extract[Lookup[expandedSafeOps, Shake], positionsOfStorageCondition];
	shakingRatesFromSafeOps = Extract[Lookup[expandedSafeOps, ShakingRate], positionsOfStorageCondition];
	shakingRadiiFromFromSafeOps = Extract[Lookup[expandedSafeOps, ShakingRadius], positionsOfStorageCondition];
	cultureAdhesionsFromSafeOps = Extract[Lookup[expandedSafeOps, CultureAdhesion], positionsOfStorageCondition];
	prepModesFromSafeOps = ConstantArray[Lookup[expandedSafeOps, Preparation], Length[positionsOfStorageCondition]];(*Preparation is not index matching*)

	(* Big download *)
	downloadedStuff = Quiet[
		Download[
			incubationStorageConditions,
			Packet[CellType, CultureHandling, Temperature, Humidity, Temperature, CarbonDioxide, ShakingRate, VesselShakingRate, PlateShakingRate, ShakingRadius],
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* We are updating the input at the position of Model[StorageCondition] to All *)
	updatedInputs = myInputs/.ObjectP[Model[StorageCondition]] :> All;

	(* Pull out options from StorageCondition *)
	{
		cellTypesFromStorageCondition,
		rawTemperaturesFromStorageCondition,
		rawCarbonDioxidesFromStorageCondition,
		rawRelativeHumiditiesFromStorageCondition,
		rawShakingRadiiFromStorageCondition
	} = Transpose@Map[
		Lookup[
			fetchPacketFromCache[#, downloadedStuff],
			{
				CellType,
				Temperature,
				CarbonDioxide,
				Humidity,
				ShakingRadius
			}
		]&,
		incubationStorageConditions
	];

	(* Since there are 2 shaking rates for each incubation condition (plate vs vessel) and we want to resolve both, we set it to Automatic when Shake is True *)
	{shakingsFromStorageCondition, shakingRatesFromStorageCondition, possibleShakingRatesFromStorageConditions} = Transpose@Map[
		Module[{possibleRates},
			possibleRates = Cases[Lookup[fetchPacketFromCache[#, downloadedStuff], {ShakingRate, PlateShakingRate, VesselShakingRate}], Except[Null]];
			If[MatchQ[possibleRates, {}],
				{False, Null, Null},
				{True, Automatic, possibleRates}
			]
		]&,
		incubationStorageConditions
	];


	cultureAdhesionsFromStorageCondition = MapThread[
		Module[{cultureHandling},
			cultureHandling = Lookup[fetchPacketFromCache[#1, downloadedStuff], CultureHandling];
			Which[
				MatchQ[cultureHandling, Microbial] && TrueQ[#2],
					Suspension,
				MatchQ[cultureHandling, Microbial],
					SolidMedia,
				MatchQ[cultureHandling, NonMicrobial],
					Adherent,
				True,
					Null
			]
		]&,
		{incubationStorageConditions, shakingsFromStorageCondition}
	];

	prepModesFromStorageCondition = ConstantArray[Manual, Length[incubationStorageConditions]];

	(* Round Temperature, CarbonDioxide, RelativeHumidity, and ShakingRadius *)
	(* Note when we look up values from SC, extra digit might be added *)
	temperaturesFromStorageCondition = SafeRound[rawTemperaturesFromStorageCondition, 1 Celsius];
	carbonDioxidesFromStorageCondition = SafeRound[rawCarbonDioxidesFromStorageCondition, 1 Percent];
	relativeHumiditiesFromStorageCondition = SafeRound[rawRelativeHumiditiesFromStorageCondition, 1 Percent];
	shakingRadiiFromStorageCondition = Map[
		If[!NullQ[#],
			(* Note: here we are not using CellIncubatorShakingRadiusP to ensure the digit *)
			First@Nearest[{3 Millimeter, 25 Millimeter, 25.4 Millimeter}, #](*CellIncubatorShakingRadiusP*)
		]&,
		rawShakingRadiiFromStorageCondition
	];


	(* Check conflicting between myOptions and desired options from Model[StorageCondition] *)
	conflictingOptions = Flatten[MapThread[
		{
			If[!MatchQ[#4, Automatic] && MatchQ[#3, #4],
				{#2, #3, #4, CellType},
				Nothing
			],
			If[!MatchQ[#6, Automatic] && !MatchQ[#5, #6],
				{#2, #5, #6, CultureAdhesion},
				Nothing
			],
			If[!MatchQ[#8, Automatic] && !EqualQ[#7, #8],
				{#2, #7, #8, Temperature},
				Nothing
			],
			If[!MatchQ[#10, Automatic] && !EqualQ[#9, #10],
				{#2, #9, #10, CarbonDioxide},
				Nothing
			],
			If[!MatchQ[#12, Automatic] && !EqualQ[#11, #12],
				{#2, #11, #12, RelativeHumidity},
				Nothing
			],
			If[!MatchQ[#14, Automatic] && MatchQ[#13, #14],
				{#2, #13, #14, Shake},
				Nothing
			],
			If[!MatchQ[#16, Automatic] && !EqualQ[#15, #16],
				{#2, #15, #16, ShakingRadius},
				Nothing
			],
			If[!MatchQ[#18, Automatic] && !MemberQ[#17, #18],
				{#2, #17, #18, ShakingRate},
				Nothing
			],
			If[!MatchQ[#20, Automatic] && MatchQ[#19, #20],
				{#2, #19, #20, Preparation},
				Nothing
			]
		}&,
		{
			Range[Length@incubationStorageConditions], incubationStorageConditions,
			cellTypesFromStorageCondition, cellTypesFromSafeOps,
			cultureAdhesionsFromStorageCondition, cultureAdhesionsFromSafeOps,
			temperaturesFromStorageCondition, temperaturesFromSafeOps,
			carbonDioxidesFromStorageCondition, carbonDioxidesFromSafeOps,
			relativeHumiditiesFromStorageCondition, relativeHumiditiesFromSafeOps,
			shakingsFromStorageCondition, shakingsFromSafeOps,
			shakingRadiiFromStorageCondition, shakingRadiiFromFromSafeOps,
			possibleShakingRatesFromStorageConditions, shakingRatesFromSafeOps,
			prepModesFromStorageCondition, prepModesFromSafeOps
		}
	], 1];

	(* Give an error if there are any conflicts between options and IncubationConditions *)
	conflictingOptionTest = If[MatchQ[conflictingOptions, {}],
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The specified incubation option and IncubationCondition are not conflicted:", True, True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The specified incubation options:" <> ToString[conflictingOptions[[All, 4]]] <> " are different from IncubationCondition for samples:" <> ToString[conflictingOptions[[All, 1]]] <> ":",
				False,
				True
			],
			Message[
				Error::ConflictingIncubationConditionWithOptions,
				conflictingOptions[[All, 1]],
				conflictingOptions[[All, 2]],
				conflictingOptions[[All, 3]],
				conflictingOptions[[All, 4]]
			];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[!MatchQ[conflictingOptions, {}],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, conflictingOptionTest}]
		}]
	];

	(* Replace the expanded safe options with options from storage conditions for inputs on positionsOfStorageCondition*)
	updatedOptions = {
		CellType -> ReplacePart[Lookup[expandedSafeOps, CellType], Thread[positionsOfStorageCondition -> cellTypesFromStorageCondition]],
		CultureAdhesion -> ReplacePart[Lookup[expandedSafeOps, CultureAdhesion], Thread[positionsOfStorageCondition -> cultureAdhesionsFromStorageCondition]],
		Temperature -> ReplacePart[Lookup[expandedSafeOps, Temperature], Thread[positionsOfStorageCondition -> temperaturesFromStorageCondition]],
		CarbonDioxide -> ReplacePart[Lookup[expandedSafeOps, CarbonDioxide], Thread[positionsOfStorageCondition -> carbonDioxidesFromStorageCondition]],
		RelativeHumidity -> ReplacePart[Lookup[expandedSafeOps, RelativeHumidity], Thread[positionsOfStorageCondition -> relativeHumiditiesFromStorageCondition]],
		Shake -> ReplacePart[Lookup[expandedSafeOps, Shake], Thread[positionsOfStorageCondition -> shakingsFromStorageCondition]],
		ShakingRate -> ReplacePart[Lookup[expandedSafeOps, ShakingRate], Thread[positionsOfStorageCondition -> shakingRatesFromStorageCondition]],
		ShakingRadius -> ReplacePart[Lookup[expandedSafeOps, ShakingRadius], Thread[positionsOfStorageCondition -> shakingRadiiFromStorageCondition]],
		Preparation -> Manual
	};

	(* Call IncubateCellsDevices on the listed inputs *)
	IncubateCellsDevices[updatedInputs, ReplaceRule[expandedSafeOps, updatedOptions]]
];

(* All containers overload *)
IncubateCellsDevices[myInputs: {___, All, ___}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, cache, gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, croppedInputLists, croppedInputPositions, positionsOfAll, croppedOutputs, croppedTests, croppedExpandedSafeOps,
		allBranchOutputs, allBranchExpandedSafeOps, allBranchTests, resultOutput
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];
	cache = Lookup[listedOptions, Cache, {}];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Crop the input to only have Samples and Containers *)
	croppedInputLists = Cases[myInputs, ObjectP[{Model[Container], Object[Container], Object[Sample]}]];
	(* Positions of extracted StorageCondition inputs from myInput *)
	croppedInputPositions = Position[myInputs, ObjectP[{Model[Container], Object[Container], Object[Sample]}]];

	croppedExpandedSafeOps = {
		CellType -> Extract[Lookup[expandedSafeOps, CellType], croppedInputPositions];
		Temperature -> Extract[Lookup[expandedSafeOps, Temperature], croppedInputPositions];
		CarbonDioxide -> Extract[Lookup[expandedSafeOps, CarbonDioxide], croppedInputPositions];
		RelativeHumidity -> Extract[Lookup[expandedSafeOps, RelativeHumidity], croppedInputPositions];
		Shake -> Extract[Lookup[expandedSafeOps, Shake], croppedInputPositions];
		ShakingRate -> Extract[Lookup[expandedSafeOps, ShakingRate], croppedInputPositions];
		ShakingRadius -> Extract[Lookup[expandedSafeOps, ShakingRadius], croppedInputPositions];
		CultureAdhesion -> Extract[Lookup[expandedSafeOps, CultureAdhesion], croppedInputPositions];
		Preparation -> Lookup[expandedSafeOps, Preparation],
		Cache -> cache,
		Simulation -> Lookup[expandedSafeOps, Simulation]
	};

	{croppedOutputs, croppedTests} = Which[
		MatchQ[croppedInputLists, {}],
			{{}, {}},
		gatherTests,
			IncubateCellsDevices[croppedInputLists, Append[croppedExpandedSafeOps, Output -> {Result, Tests}]],
		True,
			{IncubateCellsDevices[croppedInputLists, Append[croppedExpandedSafeOps, Output -> Result]], {}}
	];

	(* Positions of All inputs from myInputs *)
	positionsOfAll = Position[myInputs, All];

	allBranchExpandedSafeOps = {
		CellType -> Extract[Lookup[expandedSafeOps, CellType], positionsOfAll],
		Temperature -> Extract[Lookup[expandedSafeOps, Temperature], positionsOfAll],
		CarbonDioxide -> Extract[Lookup[expandedSafeOps, CarbonDioxide], positionsOfAll],
		RelativeHumidity -> Extract[Lookup[expandedSafeOps, RelativeHumidity], positionsOfAll],
		Shake -> Extract[Lookup[expandedSafeOps, Shake], positionsOfAll],
		ShakingRate -> Extract[Lookup[expandedSafeOps, ShakingRate], positionsOfAll],
		ShakingRadius -> Extract[Lookup[expandedSafeOps, ShakingRadius], positionsOfAll],
		CultureAdhesion -> Extract[Lookup[expandedSafeOps, CultureAdhesion], positionsOfAll],
		Cache -> cache,
		Preparation -> Lookup[expandedSafeOps, Preparation],
		Simulation -> Lookup[expandedSafeOps, Simulation]
	};

	{allBranchOutputs, allBranchTests} = If[gatherTests,
		IncubateCellsDevices[All, Append[allBranchExpandedSafeOps, Output -> {Result, Tests}]],
		{IncubateCellsDevices[All, Append[allBranchExpandedSafeOps, Output -> Result]], {}}
	];

	(* Now we want to assemble the results from cropped sample branch and all branch back based on their original positions *)
	resultOutput = MapThread[
		If[MatchQ[#1, All],
			Extract[allBranchOutputs, FirstPosition[positionsOfAll, {#2}]],
			Extract[croppedOutputs, FirstPosition[croppedInputPositions, {#2}]]
		]&,
		{myInputs, Range[Length@myInputs]}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests, croppedTests, allBranchTests}]
	}
];

(* Overload with container model/container/sample inputs (to find all incubators that can attain the desired settings AND fit the container) *)
IncubateCellsDevices[myInputs: {ObjectP[{Model[Container], Object[Container], Object[Sample]}]..}, myOptions: OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output,  gatherTests, safeOps, safeOpsTests, validLengths, validLengthTests,
		expandedSafeOps, cacheOption, simulation, cellTypeOption, cultureAdhesionOption, temperatureOption,
		carbonDioxidePercentageOption, relativeHumidityOption, shakingOption, shakingRateOption, shakingRadiusOption,
		prepMethodOption, allCellIncubationContainers, incubatorInstruments, incubatorRacks, incubatorDecks,
		incubatorInstrumentFields, incubatorRackFields, incubatorDeckFields, incubatorInstrumentPackets, incubatorRackPackets,
		incubatorDeckPackets, inputPackets, inputContainerFootprints, inputContainerPossibleIncubators,
		inputModelContainerPackets, inputObjectContainerPackets, inputSamplePackets, incubatorObjectPacketLookup,
		inputContainerPossibleIncubatorsPackets, compatibleIncubatorsByContainer
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests} = If[gatherTests,
		SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[IncubateCellsDevices, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[IncubateCellsDevices, {myInputs}, listedOptions], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[IncubateCellsDevices, {ToList[myInputs]}, safeOps]];

	(* Pull out options and assign them to variables *)
	{
		cacheOption,
		simulation,
		cellTypeOption,
		cultureAdhesionOption,
		temperatureOption,
		carbonDioxidePercentageOption,
		relativeHumidityOption,
		shakingOption,
		shakingRateOption,
		shakingRadiusOption,
		prepMethodOption
	} = Lookup[
		expandedSafeOps,
		{
			Cache,
			Simulation,
			CellType,
			CultureAdhesion,
			Temperature,
			CarbonDioxide,
			RelativeHumidity,
			Shake,
			ShakingRate,
			ShakingRadius,
			Preparation
		}
	];

	(* To avoid downloading through links, we must now do the following:
			- Get a list of all incubator-related objects (instrument/racks/decks)
			- Download sample container model footprints along with relevant information from all the above models
			- Run incubatorsForFootprint on all footprints
			- Cases out the packets for each container's incubator, rack, and deck packets
			- For each container, transpose the lists of packets so we have: {{all incubator packets},{all rack packets},{all deck packets}}
	*)

	(* Find all incubator-related objects (instruments, racks, and decks) from which we might need information *)
	(* Rather than downloading this information through links, we now need to find ALL incubator-related objects that we might need to look at *)
	(* The Search results should already be memoized, so extract types from the ordered list to avoid multiple database round-trips *)

	(* Incubators and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the incubator/deck/rack/container combo in order to determine if the container is compatible with the incubator) *)
	allCellIncubationContainers = allCellIncubationContainersSearch["Memoization"];

	(* Search for all incubator models in the lab to download from. *)
	incubatorInstruments = nonDeprecatedIncubatorsSearch["Memoization"];
	incubatorRacks = allIncubatorRacksSearch["Memoization"];
	incubatorDecks = allIncubatorDecksSearch["Memoization"];

	incubatorInstrumentFields = cellIncubatorInstrumentDownloadFields[];
	incubatorRackFields = cellIncubatorRackDownloadFields[];
	incubatorDeckFields = cellIncubatorDeckDownloadFields[];

	(* Downloaded stuff about the incubators/racks/decks that can be used to incubate each container model *)
	{
		inputModelContainerPackets,
		inputObjectContainerPackets,
		inputSamplePackets,
		incubatorInstrumentPackets,
		incubatorRackPackets,
		incubatorDeckPackets
	} = Quiet[
		Download[
			{
				(* Inputs *)
				Cases[ToList[myInputs], ObjectP[Model[Container]]],
				Cases[ToList[myInputs], ObjectP[Object[Container]]],
				Cases[ToList[myInputs], ObjectP[Object[Sample]]],
				incubatorInstruments,
				incubatorRacks,
				incubatorDecks
			},
			{
				{Object, Packet[Footprint, Dimensions]},
				{Object, Packet[Model[{Footprint, Dimensions}]]},
				{Object, Packet[Container[Model][{Footprint, Dimensions}]]},
				{Evaluate[Packet[Sequence @@ incubatorInstrumentFields]]},
				{Evaluate[Packet[Sequence @@ incubatorRackFields]]},
				{Evaluate[Packet[Sequence @@ incubatorDeckFields]]}
			},
			Cache -> cacheOption,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist}
	];

	(* Thread out input information back into the order that we got it from the user. *)
	inputPackets = ToList[myInputs] /. ((ObjectP[#[[1]]] -> #[[2]]&) /@ Join[inputModelContainerPackets, inputObjectContainerPackets, inputSamplePackets]);

	(* Pull out footprints for input containers *)
	inputContainerFootprints = Lookup[inputPackets, Footprint];

	(* Get incubator equipment ensembles (i.e., instrument/rack or instrument/deck) combos for each input container,
	passing in downloaded incubator equipment packets as cache *)
	inputContainerPossibleIncubators = incubatorsForFootprint[
		inputContainerFootprints,
		(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions], Null], Null, Lookup[#, Dimensions][[3]]]&) /@ inputPackets,
		incubatorInstrumentPackets,
		incubatorRackPackets,
		incubatorDeckPackets
	];

	(* Make a look up to replace all objects with packets as expected below *)
	incubatorObjectPacketLookup = Rule[Lookup[#, Object], #]& /@ Flatten[incubatorInstrumentPackets];

	(* Replace all objects with their corresponding packets *)
	inputContainerPossibleIncubatorsPackets = ReplaceAll[inputContainerPossibleIncubators, incubatorObjectPacketLookup];

	(* For each container input/option set combo, find the compatible incubators *)
	(* Outer MapThread: Iterate over containers, which may have multiple compatible incubator entries *)
	compatibleIncubatorsByContainer = DeleteDuplicates /@ MapThread[
		Function[
			{
				inputContainerPossibleIncubatorsPacket,
				desiredCellType,
				desiredTemperature,
				desiredCarbonDioxidePercentage,
				desiredRelativeHumidity,
				desiredShake,
				desiredShakingRate,
				desiredShakingRadius,
				inputPacket
			},
			(* Inner MapThread: Iterate over each possible incubator for each container *)
			MapThread[
				Function[{incubatorPacket},
					Module[
						{
							incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorMaxCarbonDioxidePercentage,
							incubatorMinCarbonDioxidePercentage, incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorShakingRadius, loadingMode, shakeQ,
							incubatorDefaultTemperature, incubatorDefaultCarbonDioxidePercentage, incubatorDefaultRelativeHumidity,
							incubatorDefaultShakingRate, cellTypeCompatible, temperatureCompatible, carbonDioxidePercentageCompatible,
							relativeHumidityCompatible, shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible
						},

						(* Get info about the incubator *)
						{incubatorCellTypes, incubatorMaxTemperature, incubatorMinTemperature, incubatorDefaultTemperature,
							incubatorMaxCarbonDioxidePercentage, incubatorMinCarbonDioxidePercentage, incubatorDefaultCarbonDioxidePercentage,
							incubatorMaxRelativeHumidity, incubatorMinRelativeHumidity, incubatorDefaultRelativeHumidity,
							incubatorMaxShakingRate, incubatorMinShakingRate, incubatorDefaultShakingRate, incubatorShakingRadius, loadingMode
						} = Lookup[
							incubatorPacket,
							{CellTypes, MaxTemperature, MinTemperature, DefaultTemperature, MaxCarbonDioxide, MinCarbonDioxide, DefaultCarbonDioxide, MaxRelativeHumidity, MinRelativeHumidity, DefaultRelativeHumidity, MaxShakingRate, MinShakingRate, DefaultShakingRate, ShakingRadius, Mode},
							Null
						];
						(*TODO: Possibly check the cellType of the samples in the container if we want to do any resolving in this function *)
						(* If no CellType is provided, assume that this is a broad check for any incubator of any CellType and set this to True.
						 If a desired CellType is provided, see if it is one of the allowed CellType for this instrument *)
						cellTypeCompatible = If[MatchQ[desiredCellType, (Null | Automatic)],
							True,
							MemberQ[incubatorCellTypes, desiredCellType]
						];

						(* Check if the desired temperature setting is within the possible temperatures for this instrument *)
						temperatureCompatible = If[MatchQ[desiredTemperature, Automatic],
							True,
							If[MatchQ[incubatorDefaultTemperature, (Null | {} | $Failed)],
								(*If no defaultTemperature is informed, it is a custom incubator, so check the full operating range of the instrument *)
								RangeQ[(desiredTemperature /. Ambient -> 25 Celsius), {incubatorMinTemperature, incubatorMaxTemperature}],
								(*If a defaultTemperature is informed, it is a storage incubator, so check only the default value of the instrument *)
								RangeQ[(desiredTemperature /. Ambient -> 25 Celsius), {(incubatorDefaultTemperature - 0.1 Celsius), (incubatorDefaultTemperature + 0.1 Celsius)}]
							]
						];

						(* Check if the desired CO2 setting is within the possible ranges for this instrument *)
						carbonDioxidePercentageCompatible = If[MatchQ[desiredCarbonDioxidePercentage, Automatic],
							True,
							If[MatchQ[incubatorDefaultCarbonDioxidePercentage, (Null | {} | $Failed)],
								(*If no incubatorDefaultCarbonDioxidePercentage is informed, it is a custom incubator, so check the full operating range of the instrument *)
								RangeQ[desiredCarbonDioxidePercentage, {(incubatorMinCarbonDioxidePercentage /. Null -> 0 Percent), (incubatorMaxCarbonDioxidePercentage /. Null -> 0 Percent)}],
								(*If incubatorDefaultCarbonDioxidePercentage is informed, it is a storage incubator, so check only the default value of the instrument *)
								RangeQ[desiredCarbonDioxidePercentage, {(incubatorDefaultCarbonDioxidePercentage - 1 Percent), (incubatorDefaultCarbonDioxidePercentage + 1 Percent)}]
							]
						];

						(* Check if the desired relative humidity setting is within the possible ranges for this instrument *)
						relativeHumidityCompatible = If[MatchQ[desiredRelativeHumidity, Automatic],
							True,
							Which[
								(* If the incubator doesn't support humidity, the desired humidity must be Null. *)
								MatchQ[incubatorMinRelativeHumidity, Null] && MatchQ[incubatorMaxRelativeHumidity, Null],
								MatchQ[desiredRelativeHumidity, Null],

								(*If no incubatorDefaultRelativeHumidity is informed, it is a custom incubator, so check the full operating range of the instrument *)
								MatchQ[incubatorDefaultRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {(incubatorDefaultRelativeHumidity - 1 Percent), (incubatorDefaultRelativeHumidity + 1 Percent)}],

								(*If incubatorDefaultRelativeHumidity is informed, it is a storage incubator, so check only the default value of the instrument *)
								MatchQ[desiredRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {incubatorMinRelativeHumidity, incubatorMaxRelativeHumidity}],

								(*If incubatorMinRelativeHumidity incubatorMaxRelativeHumidity and desiredRelativeHumidity is informed, it is a storage incubator, so check only the default value of the instrument *)
								MatchQ[incubatorMinRelativeHumidity, PercentP] && MatchQ[incubatorMaxRelativeHumidity, PercentP] &&
									MatchQ[desiredRelativeHumidity, PercentP],
								RangeQ[(desiredRelativeHumidity), {incubatorMinRelativeHumidity, incubatorMaxRelativeHumidity}],

								(* If the incubator doesn't support humidity, the desired humidity must be Null. *)
								MatchQ[incubatorDefaultRelativeHumidity, Null] ,
								MatchQ[desiredRelativeHumidity, Null]

							]
						];

						(* Check if any specified option can resolve Shake Option *)
						shakeQ = Which[
							MatchQ[desiredShake, BooleanP], desiredShake,
							MatchQ[desiredShakingRate, GreaterP[0 RPM]], True,
							MatchQ[desiredShakingRadius, GreaterP[0 Millimeter]], True,
							True, Automatic
						];

						(* Check if the desired shaking rate is within the possible ranges for this instrument *)
						shakingRateCompatible = Which[
							(* If the incubator doesn't support shaking, the desired shaking must be Null. *)
							MatchQ[incubatorMinShakingRate, Null] && MatchQ[incubatorMaxShakingRate, Null] && MatchQ[incubatorDefaultShakingRate, Null],
								MatchQ[desiredShakingRate, Null|Automatic] && !TrueQ[shakeQ],
							(* If no incubatorDefaultShakingRate but min/max are informed, it is a custom incubator  *)
							MatchQ[incubatorDefaultShakingRate, Null],
								Or[
									RangeQ[desiredShakingRate, {((incubatorMinShakingRate /. Null -> 0 RPM) - 5 RPM), ((incubatorMaxShakingRate /. Null -> 0 RPM) + 5 RPM)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRate, Null] && !TrueQ[shakeQ],
									MatchQ[desiredShakingRate, Automatic]
								],
							(* If incubatorDefaultShakingRate is informed, it is a default shaking incubator, so check only the default value of the instrument *)
							True,
								Or[
									EqualQ[desiredShakingRate, incubatorDefaultShakingRate] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRate, Automatic] && MatchQ[shakeQ, True|Automatic]
								]
						];

						(* Check if the desired shaking radius matches this instrument within +/-0.05 Centimeter *)
						(* to account for the 2.5->2.54cm scenario and the fact this is a single field in the instrument model *)
						shakingRadiusCompatible = Which[
							(* If the incubator doesn't support shaking, the desired shaking must be Null. *)
							MatchQ[incubatorShakingRadius, Null],
								MatchQ[desiredShakingRadius, Null|Automatic] && !TrueQ[shakeQ],

							(* If no incubatorDefaultShakingRate, but shakingRadius is informed, it is a custom incubator *)
							(* NOTE: Definitely a little weird that we are using shaking rate in the shaking radius resolution, however *)
							(* we don't have specific 'custom' field, so this is a simple way to check *)
							(* If we are custom incubating, we can either shake or not shake. If we want to shake, make sure our radius is within *)
							(* the allowed tolerance *)
							MatchQ[incubatorDefaultShakingRate, Null],
								Or[
									RangeQ[desiredShakingRadius, {(incubatorShakingRadius - 0.1 Centimeter), (incubatorShakingRadius + 0.1 Centimeter)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRadius, Null] && !TrueQ[shakeQ],
									MatchQ[desiredShakingRadius, Automatic]
								],
							(* If incubator default shaking rate is informed, it is a default incubator, so only check whether the value is in the tolerances *)
							True,
								Or[
									RangeQ[desiredShakingRadius, {(incubatorShakingRadius - 0.1 Centimeter), (incubatorShakingRadius + 0.1 Centimeter)}] && MatchQ[shakeQ, True|Automatic],
									MatchQ[desiredShakingRadius, Automatic] && MatchQ[shakeQ, True|Automatic]
								]
						];

						(* Check if the desired preparation method (mode) matches this instrument *)
						prepMethodCompatible = If[MatchQ[prepMethodOption, (Automatic | Null)],
							True,
							MatchQ[loadingMode, prepMethodOption]
						];
						(* If the incubator is compatible on all settings, return the incubator object. Otherwise return nothing. *)
						If[MatchQ[{cellTypeCompatible, temperatureCompatible, carbonDioxidePercentageCompatible, relativeHumidityCompatible,
							shakingRateCompatible, shakingRadiusCompatible, prepMethodCompatible}, {True..}],
							Lookup[incubatorPacket, Object, Nothing],
							Nothing
						]
					]
				],
				(* Each 'packets' entry is a set of {incubator packet..} that is index matched and set for MapThreading*)
				{inputContainerPossibleIncubatorsPacket}
			]
		],
		{
			inputContainerPossibleIncubatorsPackets,
			cellTypeOption,
			(temperatureOption /. {Ambient -> 22Celsius}),
			(carbonDioxidePercentageOption /. {Null -> 0. Percent}),
			relativeHumidityOption,
			shakingOption,
			shakingRateOption,
			shakingRadiusOption,
			inputPackets
		}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> compatibleIncubatorsByContainer,
		Tests -> Flatten[{safeOpsTests, validLengthTests}]
	}
];

(* ::Subsubsection::Closed:: *)
(*incubatorsForFootprint*)

(* incubatorsForFootprint: traverses footprint graph for all provided incubator-related containers starting at the provided footprint(s)
and returns a list of paths terminating at incubators for the provided footprint(S)

	Inputs:
		myFootprint(s): Footprint(s) to use as starting point
		sampleContainerHeight: Height of the container to compare with the max height allowed in the incubator/rack/deck
		myIncubatorInstrumentPackets: List of packets of all incubator instruments that should be considered for use
		myIncubatorRackPackets: List of packets of all incubator racks that should be considered for use
		myIncubatorDeckPackets: List of packets of all incubator decks that should be considered for use
			- Packets must contain Footprint (where applicable) and Positions fields
	Outputs:
		For each provided footprint, a list of incubator-anchored paths that represent sets of {incubator,(rack|deck),footprint,MaxHeight}
		that can be used to incubate a container of that footprint
	*)
incubatorsForFootprint[
	myFootprint: FootprintP|Null,
	sampleContainerHeight: DistanceP,
	myIncubatorInstrumentPackets: ListableP[{PacketP[]..}],
	myIncubatorRackPackets: ListableP[{PacketP[]..}],
	myIncubatorDeckPackets: ListableP[{PacketP[]..}]
] := FirstOrDefault[
	incubatorsForFootprint[{myFootprint}, {sampleContainerHeight}, myIncubatorInstrumentPackets,myIncubatorRackPackets,myIncubatorDeckPackets]
];
incubatorsForFootprint[
	myFootprints: {(FootprintP | Null)..},
	sampleContainerHeights_List,
	myIncubatorInstrumentPackets: ListableP[{PacketP[]..}],
	myIncubatorRackPackets: ListableP[{PacketP[]..}],
	myIncubatorDeckPackets: ListableP[{PacketP[]..}]
] := Module[
	{
		incubatorModels, incubatorPositions, incubatorModelsAlternatives,
		decks, deckFootprints, deckPositions, incubatorsForDecks, incubatorsForDecksFootprints, incubatorDeckFootprints, deckFootprintToModelLookup,
		relevantDecks, relevantDecksPositions, relevantDecksFootprints, relevantDecksPositionsFootprints, relevantDecksMaxHeights,
		incubatorDeckCombos, decksWithFootprintsAndMaxHeights, relevantDecksReplaceRules,
		racks, rackFootprints, rackPositions, decksWithRacks, decksWithRacksRackFootprints,
		relevantRacks, relevantRacksPositions, relevantRacksFootprints, relevantRacksPositionsFootprints, relevantRacksMaxHeights,
		racksWithFootprintsAndMaxHeights, deckRackReplacementRules, incubatorDeckOrRackCombos,
		finalIncubatorDeckOrRackCombos, possibleIncubatorsByFootprint, openIncubatorShelfHeights, openFootprintIncubators, openIncubatorAndMaxHeightPairs
	},

	(* Stash the list of incubator models & their positions *)
	incubatorModels = Lookup[Flatten[myIncubatorInstrumentPackets], Object];
	incubatorPositions = Lookup[Flatten[myIncubatorInstrumentPackets], Positions];

	(* Stash all the footprints of the incubator's decks*)
	incubatorDeckFootprints = Lookup[incubatorPositions[[All, 1]], Footprint];

	(* Convert to a list of alternatives to help filtering out decks and racks below *)
	incubatorModelsAlternatives = Alternatives @@ incubatorModels;

	(* Lookup the deck, deck's footprint, and deckPositions from the packets *)
	{
		decks,
		deckFootprints,
		deckPositions
	} = {
		Lookup[Flatten[myIncubatorDeckPackets], Object],
		Lookup[Flatten[myIncubatorDeckPackets], Footprint],
		Lookup[Flatten[myIncubatorDeckPackets], Positions]
	};

	(* Get the incubators relevant to the decks from their Positions Footprint *)
	incubatorsForDecks = PickList[incubatorModels, (MatchQ[#, CellIncubatorDeckP]& /@ incubatorDeckFootprints)];

	(* Get the relevant incubators' deck Positions Footprint *)
	incubatorsForDecksFootprints = PickList[incubatorDeckFootprints, (MatchQ[#, CellIncubatorDeckP]& /@ incubatorDeckFootprints)];

	(* Filter out only the relevant decks that are in incubators *)
	relevantDecks =
		PickList[decks,
			MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints
		];

	(* Stash the footprints of the relevant decks' themselves (the deck footprint, not the footprint of the deck's positions *)
	relevantDecksFootprints = PickList[deckFootprints, MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints];

	(* Stash the positions of the relevant decks *)
	relevantDecksPositions = PickList[deckPositions, MatchQ[#, CellIncubatorDeckP]& /@ deckFootprints];

	(* Stash the incubator models with an open shelf footprint*)
	openFootprintIncubators = PickList[incubatorModels, (MatchQ[#, IncubatorShelf]& /@ incubatorDeckFootprints)];

	(* Stash the open shelf incubator position's max allowed height*)
	openIncubatorShelfHeights = Max[Lookup[#, MaxHeight]]& /@ PickList[incubatorPositions, (MatchQ[#, IncubatorShelf]& /@ incubatorDeckFootprints)];

	(* Pair the open shelf incubators with their max supported height*)
	openIncubatorAndMaxHeightPairs = Transpose[{openFootprintIncubators, openIncubatorShelfHeights}];

	(* Lookup the footprints of the relevant decks' positions, and remove any duplicates *)
	relevantDecksPositionsFootprints = DeleteDuplicates /@ (Lookup[#, Footprint]& /@ relevantDecksPositions);

	(* Lookup the MaxHeights of the relevant decks' positions *)
	relevantDecksMaxHeights = DeleteDuplicates /@ (Lookup[#, MaxHeight]& /@ relevantDecksPositions);

	(*Make a list of replacement rules to swap the deck footprints for their Model*)
	deckFootprintToModelLookup = Normal[AssociationThread[relevantDecksFootprints, relevantDecks]];

	(* Make an initial list of all the incubator models and their associated decks in the form {{incubator,deck}..} *)
	incubatorDeckCombos = Transpose[{Flatten[incubatorsForDecks], (Flatten[incubatorsForDecksFootprints] /. deckFootprintToModelLookup)}];

	(* Assemble the lists of footprints (if any footprint matches it should work with the container), get the Max of the MaxHeight values
	allowed in the decks (to keep this a single value for each list), and combine with the list of deck models.
	If there is no MaxHeight, assume the typical separation between shelves of 15 Centimeter *)
	decksWithFootprintsAndMaxHeights =
		Transpose[{
			Flatten[relevantDecks],
			relevantDecksPositionsFootprints,
			Max /@ (relevantDecksMaxHeights /. {Null -> .15 Meter})
		}];

	(* Make a list of replace rules to swap any deck models in the list of {{incubator,deck}..} to be in the form of {{incubator,deck,Footprins,MaxHeight}..}
	This is NOT applied at this point, since some incubator decks have racks. First get all the rack info, then apply this last. *)
	relevantDecksReplaceRules =
		Normal[AssociationThread[Flatten[relevantDecks], decksWithFootprintsAndMaxHeights]];

	(* Lookup the rack, rack's containers, and rackPositions from the packets *)
	{
		racks,
		rackFootprints,
		rackPositions
	} = {
		Lookup[Flatten[myIncubatorRackPackets], Object],
		Lookup[Flatten[myIncubatorRackPackets], Footprint],
		Lookup[Flatten[myIncubatorRackPackets], Positions]
	};

	(* Filter out only the decks that have racks from the list of incubator relevant decks *)
	decksWithRacks = PickList[relevantDecks, (MatchQ[First[#], CellIncubatorRackP]& /@ relevantDecksPositionsFootprints)];

	(* Filter out only the decks that have racks from the list of incubator relevant decks *)
	decksWithRacksRackFootprints = PickList[relevantDecksPositionsFootprints, (MatchQ[First[#], CellIncubatorRackP]& /@ relevantDecksPositionsFootprints)];

	(* Get the relevant racks whose Footprint is in the list of incubator relevant racks *)
	relevantRacks = PickList[racks, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Use the same PickList to pull out the Footprint of the incubator relevant racks *)
	relevantRacksFootprints = PickList[rackFootprints, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Use the same PickList to pull out the Positions of the incubator relevant racks *)
	relevantRacksPositions = PickList[rackPositions, MatchQ[#, CellIncubatorRackP]& /@ rackFootprints];

	(* Pull out the unique Footprints from the Positions of the incubator relevant racks *)
	(* NOTE that I am doing a big hack here to hard code that Model[Container, Rack, "Standard Well Microplate Holder Stack"] takes plates even though its position footprints are Open *)
	(* doing this because these stacks are special and take a stack of plates but that are all in the same position (i.e., A1)*)
	(* we need to do this because the StorageAvailability system doesn't work very smootholy with plate stacks, and the Open trick gets us around it *)
	(* but the Open trick messes up the footprint tracking here when it really should be a plate, so I need to manually set this back *)
	(* ideally in the future we would be able to have the footprint of these positions to just be Plate to begin with, but as of writing this this is not the case *)
	relevantRacksPositionsFootprints = MapThread[
		DeleteDuplicates[
			If[MatchQ[#1, Model[Container, Rack, "id:J8AY5jwzPPjK"]],(*Standard Well Microplate Holder Stack*)
				Lookup[#2, Footprint] /. {Open -> Plate},
				Lookup[#2, Footprint]
			]
		]&,
		{relevantRacks, relevantRacksPositions}
	];

	(* Pull out the unique MaxHeights from the Positions of the incubator relevant racks *)
	relevantRacksMaxHeights = DeleteDuplicates /@ (Lookup[#, MaxHeight]& /@ relevantRacksPositions);

	(* Combine the list of the incubator relevant racks with Alternatives of their available Footprints and the Max Height of each rack
	(if Null, assume the standard height of a plate), to make a list of {{rack,FootprintAlternatives,MaxHeight}..} *)
	racksWithFootprintsAndMaxHeights = Transpose[{relevantRacks, relevantRacksPositionsFootprints, (Max /@ (relevantRacksMaxHeights /. {Null -> 0.045 Meter}))}];

	(* Use the above list to swap out footprints of the deck's racks with the appropriate rack/footprints/height combo *)
	deckRackReplacementRules = Normal[
		AssociationThread[
			Flatten[decksWithRacks],
			Flatten[decksWithRacksRackFootprints]
		]
	] /. Normal[AssociationThread[relevantRacksFootprints, racksWithFootprintsAndMaxHeights]];

	(* Use the deck-> rack replacement rules to swap out any decks that have racks with the appropriate rack/footprints/height combo*)
	incubatorDeckOrRackCombos = incubatorDeckCombos /. deckRackReplacementRules;

	(* Finally, use the earlier replacement rules to replace any remaining decks in the list with the deck/footprints/height combo.
	Flatten each sublist to level 1, so the only remaining sublist is the list of possible footprints (everything else should be a single value).
	This should result in a final list of {{incubator,rack|deck,{footprints},maxheight}..} to compare the container with *)

	finalIncubatorDeckOrRackCombos = Flatten[#, 1]& /@ (incubatorDeckOrRackCombos /. relevantDecksReplaceRules);

	(* Pick out the possible incubators for each footprint and MaxHeight to return an
	index-matched list of incubators for each provided footprint/MaxHeight input *)
	possibleIncubatorsByFootprint = MapThread[
		Function[{myFootprint, myMaxHeight},
			(*Outer MapThread: If either the footprint or the max height is Null,give an empty list (e.g.no compatible incubators).
			As long as both the footprint and height are informed, pass the footprint and height to the inner MapThread across the possible incubators
			 to get the list of possible incubators that can work with the provided footprint and the max height of the sample's container.
			*)
			If[
				NullQ[myFootprint] || NullQ[myMaxHeight],
				{},
				(* Inner MapThread:
				 If no incubator/height combos match the footprint and maxheight, then return nothing as no standard incubators are compatible*)
				MapThread[
					Function[{incubator, rackOrDeck, footprints, maxHeight},
						Module[{possibleIncubators, openIncubators},
							possibleIncubators = If[MemberQ[footprints, myFootprint] && maxHeight >= myMaxHeight,
								incubator,
								Nothing
							];
							(*InnerMost Map: Check the open footprint incubator/max height pairs against the max height of the containers*)
							openIncubators = If[
								#[[2]] >= myMaxHeight,
								#[[1]],
								Nothing
							]& /@ openIncubatorAndMaxHeightPairs;
							Flatten[{possibleIncubators, openIncubators}]
						]
					],
					Transpose[finalIncubatorDeckOrRackCombos]
				]
			]
		],
		{myFootprints, sampleContainerHeights}
	];
	DeleteDuplicates[Flatten[#]]& /@ possibleIncubatorsByFootprint
];

(* ::Section:: *)
(*End Private*)

(* ::Subsection:: *)
(*IncubateCells Resolvers *)

(*::Subsubsection::Closed:: *)
(*resolveIncubateCellsMethod and resolveIncubateCellsWorkCell*)

(* these two functions serve different purposes but are extremely similar on the inside so they are just wrappers for a shared internal function *)
DefineOptions[resolveIncubateCellsMethod,
	Options :> {
		{
			OptionName -> FromExperimentIncubateCells,
			Default -> False,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> BooleanP]
			],
			Description -> "Indicates if this function is called inside of ExperimentIncubateCells (in which case we have all the Cache information and thus don't need to Download again).",
			Category -> "Hidden"
		}
	},
	SharedOptions :> {
		ExperimentIncubateCells,
		CacheOption,
		SimulationOption
	}
];

DefineOptions[resolveIncubateCellsWorkCell,
	SharedOptions :> {
		resolveIncubateCellsMethod
	}
];

(* call the core function with the Method input *)
resolveIncubateCellsMethod[
	myContainers: ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions: OptionsPattern[]
] := resolveIncubateCellsMethodCore[
	Method,
	myContainers,
	myOptions
];

(* call the core function with the WorkCell input *)
resolveIncubateCellsWorkCell[
	myContainers:ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions:OptionsPattern[]
] := resolveIncubateCellsMethodCore[
	WorkCell,
	myContainers,
	myOptions
];

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveIncubateCellsMethodCore[
	myMethodOrWorkCell: Method | WorkCell,
	myContainers: ListableP[(ObjectP[{Object[Container], Object[Sample]}] | Automatic)],
	myOptions: OptionsPattern[]
] := Module[
	{allSamplePackets, downloadedPacketsFromContainers,
		downloadedPacketsFromSamples, downloadedPacketsFronInstruments, downloadedPacketsFromInstrumentModels,
		cache, simulation, listedInputs, specifiedPreparation, safeOps, fastAssoc,
		gatherTests, outputSpecification, output, result, tests, manualRequirementStrings, roboticRequirementStrings,
		allFootprintsRobotCompatibleQ, roboticIncubatorQ, fromExperimentIncubateCellsQ, specifiedWorkCell,
		allModelContainerPackets, allModelContainerFootprints, allInstrumentObjects, inputContainers, inputSamples,
		inputInstruments, inputInstrumentModels, allInstrumentModelPackets, incubator, compositionCellTypes,
		allSampleCellTypes, optionsCellTypes, allCellTypes, workCellBasedOnCellType, incubatorCellTypes, workCellResult,
		workCellBasedOnIncubators, bioSTARRequirementStrings, microbioSTARRequirementStrings, methodResult},

	(* make sure these are a list *)
	listedInputs = ToList[myContainers];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* get the safe options*)
	(* resolveIncubateCellsMethod and resolveIncubateCellsWorkCell have the same options so just pick one *)
	safeOps = SafeOptions[resolveIncubateCellsMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];


	(* pull out the cache, simulation, incubator, and specified preparation *)
	{cache, simulation, specifiedPreparation, specifiedWorkCell, incubator} = Lookup[safeOps, {Cache, Simulation, Preparation, WorkCell, Incubator}];

	(* generate a fast assoc from the cache passed in; if we're from within ExperimentIncubateCells then we don't need to Download information over again *)
	fromExperimentIncubateCellsQ = Lookup[safeOps, FromExperimentIncubateCells];
	fastAssoc = If[fromExperimentIncubateCellsQ,
		makeFastAssocFromCache[cache],
		<||>
	];

	inputContainers = Cases[myContainers, ObjectP[Object[Container]]];
	inputSamples = Cases[myContainers, ObjectP[Object[Sample]]];
	inputInstruments = Cases[ToList[incubator], ObjectP[Object[Instrument]]];
	inputInstrumentModels = Cases[ToList[incubator], ObjectP[Model[Instrument]]];

	(* Download information that we need from our inputs and/or options. *)
	(* pull the information out of the fastAssoc and use that instead of the Download if we have it *)
	(* formatting is admittedly a little bit weird; deconvolute it below *)
	{
		downloadedPacketsFromContainers,
		downloadedPacketsFromSamples,
		downloadedPacketsFronInstruments,
		downloadedPacketsFromInstrumentModels
	} = If[Not[fromExperimentIncubateCellsQ],
		Quiet[
			Download[
				{
					inputContainers,
					inputSamples,
					inputInstruments,
					inputInstrumentModels
				},
				{

					{
						(* getting Model container packet from Object[Container]*)
						Packet[Model[Footprint]],
						(* getting contents packets from Object[Container] *)
						Packet[Contents[[All, 2]][{CellType, Composition}]]
					},
					{
						(* getting Model container packet from Object[Sample]*)
						Packet[Container[Model][Footprint]],
						(* getting sample packet from Object[Sample] *)
						Packet[CellType, Composition]
					},
					(* getting the model packet from the Object[Instrument] *)
					{Packet[Model[{Mode, CellTypes}]]},
					(* getting the model pacekt from the Model[Instrument] *)
					{Packet[Mode, CellTypes]}
				},
				Simulation -> simulation
			],
			{Download::NotLinkField, Download::FieldDoesntExist}
		],
		{
			(* same format as the Download above except pulling from the fastAssoc *)
			{
				fastAssocPacketLookup[fastAssoc, #, Model]& /@ inputContainers,
				Map[
					Function[{container},
						Map[
							Function[{content},
								fetchPacketFromFastAssoc[content, fastAssoc]
							],
							fastAssocLookup[fastAssoc, container, Contents][[All, 2]]
						]
					],
					inputContainers
				]
			},
			{
				fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ inputSamples,
				fetchPacketFromFastAssoc[#, fastAssoc]& /@ inputSamples
			},
			{fastAssocPacketLookup[fastAssoc, #, Model]& /@ inputInstruments},
			{fetchPacketFromFastAssoc[#, fastAssoc]& /@ inputInstrumentModels}
		}
	];

	(* Deconvolute the Download above *)
	allModelContainerPackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Model[Container]]];
	allSamplePackets = Cases[Flatten[{downloadedPacketsFromContainers, downloadedPacketsFromSamples}], PacketP[Object[Sample]]];
	allInstrumentModelPackets = Cases[Flatten[{downloadedPacketsFronInstruments, downloadedPacketsFromInstrumentModels}], PacketP[Model[Instrument]]];

	(* determine if all the container model packets in question can fit on the liquid handler *)
	allModelContainerFootprints = Lookup[allModelContainerPackets, Footprint, {}];
	allFootprintsRobotCompatibleQ = MatchQ[allModelContainerFootprints, {LiquidHandlerCompatibleFootprintP..}];

	(* Get all of our Model[Instrument]s *)
	allInstrumentObjects = Lookup[allInstrumentModelPackets, Object, {}];

	(* determine whether we're using a robotic incubator; don't love this hardcoded list but going with it for now *)
	(* {Model[Instrument, Incubator, "STX44-ICBT with Humidity Control"], Model[Instrument, Incubator, "STX44-ICBT with Shaking"]} *)
	roboticIncubatorQ = MemberQ[allInstrumentObjects, ObjectP[{Model[Instrument, Incubator, "id:AEqRl954GpOw"], Model[Instrument, Incubator, "id:N80DNjlYwELl"]}]];

	(* get all the CellTypes of the samples *)
	(* if we can't figure it out from the CellType field, go to the Composition field.  If we can't figure it out from there, look at what was specified *)
	compositionCellTypes = Map[
		Function[{composition},
			With[{reverseSortedIdentityModels = ReverseSortBy[composition, First][[All, 2]]},
				(* this [[2]] is definitely weird here; basically, I want Model[Cell, Bacterial, "id:lkjlkjlkj"] to become Bacterial *)
				Download[SelectFirst[reverseSortedIdentityModels, MatchQ[#, ObjectP[Model[Cell]]]&, {Null, Null}],Object][[2]]
			]
		],
		Lookup[allSamplePackets, Composition, {}]
	];
	allSampleCellTypes = MapThread[
		Function[{samplePacket, compositionCellType},
			Which[
				MatchQ[Lookup[samplePacket, CellType], CellTypeP], Lookup[samplePacket, CellType],
				MatchQ[compositionCellType, CellTypeP], compositionCellType,
				True, Null
			]
		],
		{allSamplePackets, compositionCellTypes}
	];

	(* figure out the CellTypes specified in the options, then smush it all together *)
	optionsCellTypes = ToList[Lookup[safeOps, CellType]];
	allCellTypes = Cases[Flatten[{allSampleCellTypes, optionsCellTypes}], CellTypeP|Null];

	(* determine what work cell we can use based on the cell type *)
	workCellBasedOnCellType = Which[
		(* if we're ONLY Nulls, then we don't know and can just pick either *)
		MatchQ[allCellTypes, {Null..}], {microbioSTAR, bioSTAR},
		(* if any CellType are NonMicrobial (or we have Nulls), need to use bioSTAR *)
		MatchQ[allCellTypes, {(NonMicrobialCellTypeP|Null)..}], {bioSTAR},
		(* if any CellType are Microbial (or we have Nulls), need to use microbioSTAR *)
		MatchQ[allCellTypes, {(MicrobialCellTypeP|Null)..}], {microbioSTAR},
		(* if somehow we have some microbial and some non microbial then we can't have any work cell and will throw an error below *)
		True, {}
	];

	(* determine which work cell we can use based on the incubator(s) specified *)
	incubatorCellTypes = Flatten[Lookup[allInstrumentModelPackets, CellTypes, {}]];
	workCellBasedOnIncubators = Which[
		(* if we didn't specify an incubator, we don't have a preference at this point *)
		MatchQ[incubatorCellTypes, {}], {microbioSTAR, bioSTAR},
		MatchQ[incubatorCellTypes, {NonMicrobialCellTypeP..}], {bioSTAR},
		MatchQ[incubatorCellTypes, {MicrobialCellTypeP..}], {microbioSTAR},
		(* if we have a microbial and a non microbial incubator specified in the same protocol, then we need to throw an error because can't do both at once *)
		True, {}
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings = {
		If[MatchQ[specifiedPreparation, Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		],
		If[MemberQ[allModelContainerFootprints, Except[Plate]],
			"the sample containers do not have Plate footprint for Robotic incubation",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings = {
		If[MatchQ[specifiedPreparation, Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		],
		If[roboticIncubatorQ,
			"the Robotic incubators are requested by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[MatchQ[myMethodOrWorkCell, Method] && Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Determine the method that can be performed (robotic|manual) *)
	methodResult = Which[
		(* Always respect the user's input *)
		!MatchQ[specifiedPreparation, Automatic], specifiedPreparation,
		(* If we have any non-plate footprints we definitely can only do this manually *)
		MemberQ[allModelContainerFootprints, Except[Plate]], Manual,
		(* If any robotic incubators are specified, it should be robotic*)
		roboticIncubatorQ, Robotic,
		True, {Manual, Robotic}
	];

	(* Create a list of reasons why we need WorkCell -> bioSTAR. *)
	bioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, bioSTAR],
			"the WorkCell option is set to bioSTAR by the user",
			Nothing
		],
		If[MemberQ[optionsCellTypes, NonMicrobialCellTypeP],
			"the specified CellType option includes a non-microbial cell type",
			Nothing
		],
		If[MemberQ[allSampleCellTypes, NonMicrobialCellTypeP],
			"the input samples contain a non-microbial cell type",
			Nothing
		],
		If[MemberQ[incubatorCellTypes, NonMicrobialCellTypeP],
			"the specified Incubator option includes an incubator for a non-microbial cell type",
			Nothing
		]
	};

	(* Create a list of reasons why we need WorkCell -> microbioSTAR. *)
	microbioSTARRequirementStrings = {
		If[MatchQ[specifiedWorkCell, microbioSTAR],
			"the WorkCell option is set to microbioSTAR by the user",
			Nothing
		],
		If[MemberQ[optionsCellTypes, MicrobialCellTypeP],
			"the specified CellType option includes a microbial cell type",
			Nothing
		],
		If[MemberQ[allSampleCellTypes, MicrobialCellTypeP],
			"the input samples contain a microbial cell type",
			Nothing
		],
		If[MemberQ[incubatorCellTypes, MicrobialCellTypeP],
			"the specified Incubator option includes an incubator for a microbial cell type",
			Nothing
		]
	};


	(* throw an error if we don't have a work cell we can use *)
	(* only bother with this if we're using Robotic anyway *)
	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[MatchQ[myMethodOrWorkCell, WorkCell] && MemberQ[ToList[methodResult], Robotic] && Length[bioSTARRequirementStrings] > 0 && Length[microbioSTARRequirementStrings] > 0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingWorkCells,
				listToString[bioSTARRequirementStrings],
				listToString[microbioSTARRequirementStrings]
			]
		]
	];

	(* Determine the method that can be performed (bioSTAR|microbioSTAR) *)
	(* Always respect the user's input *)
	workCellResult = If[!MatchQ[specifiedWorkCell, Automatic],
		specifiedWorkCell,
		(* doing unsorted because Intersection is dumb and it sorts *)
		UnsortedIntersection[workCellBasedOnCellType, workCellBasedOnIncubators]
	];

	tests = Which[
		MatchQ[gatherTests, False], {},
		MatchQ[myMethodOrWorkCell, Method],
			{Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the IncubateCells unit operation:",
				False,
				Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0
			]},
		True,
			{Test["There are not conflicting bioSTAR and microbioSTAR requirements when resolving the WorkCell method for the IncubateCells unit operation:",
				False,
				Length[manualRequirementStrings] > 0 && Length[roboticRequirementStrings] > 0
			]}
	];

	outputSpecification /. {Result -> If[MatchQ[myMethodOrWorkCell, Method], methodResult, workCellResult], Tests -> tests}

];

(* ::Subsection::Closed:: *)
(*ExperimentIncubateCellsPreview*)


DefineOptions[ExperimentIncubateCellsPreview,
	SharedOptions :> {ExperimentIncubateCells}
];


ExperimentIncubateCellsPreview[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentIncubateCellsPreview]] := Module[
	{listedOptions},

	listedOptions = ToList[myOptions];

	ExperimentIncubateCells[myInput, ReplaceRule[listedOptions, Output -> Preview]]
];

(* ::Subsection::Closed:: *)

(*ExperimentIncubateCellsOptions*)


DefineOptions[ExperimentIncubateCellsOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentIncubateCells}
];


ExperimentIncubateCellsOptions[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentIncubateCellsOptions]] := Module[
	{listedOptions, preparedOptions, resolvedOptions},

	listedOptions = ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Options], {OutputFormat}];

	resolvedOptions  =ExperimentIncubateCells[myInput, preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]], Table]&&MatchQ[resolvedOptions ,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions, ExperimentIncubateCells],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentIncubateCellsQ*)

DefineOptions[ValidExperimentIncubateCellsQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentIncubateCells}
];


ValidExperimentIncubateCellsQ[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ValidExperimentIncubateCellsQ]] := Module[
	{listedInput, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat},

	listedInput = ToList[myInput];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests = ExperimentIncubateCells[myInput, preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings},
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1, InputForm] <> " is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest}, functionTests, voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps = SafeOptions[ValidExperimentIncubateCellsQ, Normal@KeyTake[listedOptions, {Verbose, OutputFormat}]];
	{verbose, outputFormat} = Lookup[safeOps, {Verbose, OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentIncubateCells" -> allTests|>,
			Verbose -> verbose,
			OutputFormat -> outputFormat
		],
		"ExperimentIncubateCells"
	]
];

(* ::Section:: *)
(*End Private*)