(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentCentrifuge*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifuge - Options*)


DefineOptions[ExperimentCentrifuge,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being centrifuged, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being centrifuged, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName->Instrument,
				Default->Automatic,
				AllowNull -> False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Centrifuges"}
					}
				],
				Description->"The centrifuge that will be used to spin the provided samples.",
				ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified intensity, time, temperature, and sterility and (if possible) that is compatible with the sample in its current container."
			},
			{
				OptionName->RotorGeometry,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>RotorGeometryP],
				Description->"Indicates if the provided samples will be spun at a fixed angle or freely pivot. Unique when Preparation -> Manual.",
				ResolutionDescription->"Automatically set to a FixedAngleRotor if more than one rotors are available that fit the intensity and container constraints."
			},
			{
				OptionName->RotorAngle,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>RotorAngleP],
				Description->"The angle of the samples in the rotor that will be applied to spin the provided samples if ultracentrifuge instrument is selected. Unique when Preparation -> Manual.",
				ResolutionDescription->"Automatically set to a rotor that could spin samples at specific angle relative to the axis of rotation."
			},
			{
				OptionName->ChilledRotor,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the ultracentrifuge rotor is stored in refrigerator between usage thus it is prechilled on loading into the ultracentrifuge. Unique when Preparation -> Manual.",
				ResolutionDescription->"Automatically set to true if the ultracentrifuge is utilized at cold temperature."
			},
			{
				OptionName->Rotor,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,CentrifugeRotor],Object[Container,CentrifugeRotor]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Centrifuge",
							"Ultracentrifuge Rotors"
						}
					}
				],
				Description->"The centrifuge rotor that will be used to spin the provided samples if ultracentrifuge instrument is selected. Unique when Preparation -> Manual.",
				ResolutionDescription->"Automatically set to a rotor that can attain the specified intensity, time, temperature, and sterility and (if possible) fits the sample in its current container. "
			},
			{
				OptionName -> Intensity,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
				],
				Description -> "The rotational speed or the force that will be applied to the samples by centrifugation.",
				ResolutionDescription -> "Automatically resolves to one fifth of the maximum rotational rate of the centrifuge, rounded to the nearest attainable centrifuge precision."
			},
			{
				OptionName -> Time,
				Default -> 5Minute,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units->Alternatives[Second, Minute, Hour]],
				Description -> "The amount of time for which the samples will be centrifuged."
			},
			{
				OptionName->Temperature,
				Default->Automatic,
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity, Pattern:>RangeP[-10 Celsius,40Celsius], Units->Alternatives[Celsius, Fahrenheit, Kelvin]]
				],
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged.",
				ResolutionDescription->"Automatically set to 4 Celsius if ChilledRotor option is set to True."
			},
			{
				OptionName->CollectionContainer,
				Default->Automatic,
				Description->"The container that will be stacked on the bottom of the sample's container to collect the filtrate passing through the filter container.",
				ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] if the sample is in a filter plate.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers",
								"Plates"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[Type -> Number,Pattern :> GreaterEqualP[1, 1]]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers",
										"Plates"
									}
								}
							],
							Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
						]
					}
				]
			},
			{
				OptionName->CounterbalanceWeight,
				Default-> Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity, Pattern:>RangeP[0 Gram,500 Gram], Units->Alternatives[Gram, Milligram]],
					(* ExperimentFilter will send an empty list when calling as a sub if it wasn't suppplied with container weights *)
					Widget[Type -> Enumeration,Pattern :> Alternatives[{}]]
				],
				Description->"The weight of the item used as a counterweight for the centrifuged container, its contents, and the associated collection container (if applicable).",
				Category->"Hidden"
			},
			{
				OptionName -> Counterweight,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Object, Pattern:>ObjectP[{Model[Item, Counterweight], Object[Item, Counterweight]}]],
				Description -> "The counterweight to the input container.",
				Category -> "Hidden"
			}
		],
	(* Shared Options *)
	(* Here we would usually just include NonBiologyFuntopiaSharedOptions, but since this is a sample prep experiment, we have to exclude the centrifuge prep options. *)
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"Number of times each of the input samples will be centrifuged using identical experimental parameters.",
			AllowNull->True,
			Category->"Protocol",
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[1,1]]
		},

		(* === shared options === *)
		PreparationOption,
		ProtocolOptions,
		WorkCellOption,
		SimulationOption, (* TODO: Remove this and add to ProtocolOptions when it is time to blitz. Also add SimulateProcedureOption. *)
		IncubatePrepOptionsNew,
		FilterPrepOptionsNew,
		AliquotOptions,
		PreparatoryUnitOperationsOption,
		ModelInputOptions,
		NonBiologyPostProcessingOptions,
		SterileOption,

	(* SamplesIn Shared Options *)
		SamplesInStorageOption,

		{
			OptionName->EnableSamplePreparation,
			Default->True,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the sample preparation options for this function should be resolved. This option is set to False when ExperimentCentrifuge is called within resolveSamplePrepOptions to avoid an infinite loop.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifuge Messages *)


Error::IncompatibleCentrifuge = "The input container Model `1``2` cannot be centrifuged at the specified Intensity (`3`), Temperature (`4`), and/or Time (`5`) with the selected centrifuge (`6`). Please refer to the MaxStackHeight, MaxTemperature, MinTemperature, MaxRotationRate, MinRotationRate and MaxTime fields for the limitation of the instrument and specify `7`valid combinations of the options. CentrifugeDevices can be used to find centrifuges that can meet the desired settings.";
Error::NoCompatibleCentrifuge = "There are no centrifuges capable attaining the specified Intensity (`1`), Temperature (`2`), and/or Time (`3`) when Preparation is set to `4`. Please ensure that the specified containers can fit on the centrifuge, are not too heavy, and that spin parameters fall within the operating limits of available centrifuges. CentrifugeDevices can be used to find centrifuges that can meet the desired settings.";
Error::NoTransferContainerFound = "The samples `1` must be transferred to a different container in order to fit on a centrifuge that matches the specified options, but no appropriate transfer container could be found. Please manually set the AliquotAmount (if calling this function standalone) or CentrifugeAliquot (if calling this function from sample preparation) to specify a compatible volume amount. A volume under 50 Milliliter is usually compatible (depending on the other rate/temperature options you have specified).";
Error::SamplesNotInFilterContainer = "The sample(s) `1` have been specified to be collected in the CollectionContainer(s), `2`, however, the samples are not in a Model[Container, Plate, Filter] that has a Plate footprint or a Model[Container, Vessel, Filter]. Samples must be in a filter container in order to be collected. Please do not specify the CollectionContainer option for these samples or set the Aliquot->True option and aliquot the samples into a filter plate or vessel before the start of the experiment.";
Error::ConflictingCollectionContainers = "The sample(s) `1` have different CollectionContainer(s), `2`, specified. However, these samples are in the same container. Samples in the same container must be filtered into the same collection container. Please change the CollectionContainer option or let it resolve automatically.";
Error::InvalidCounterweights = "The CounterbalanceWeight `1` are not sufficiently close to the weights of any Model[Item,Counterweight]. Please provide weights within `2` of a Model[Item,Counterweight] with the same footprint.";
Warning::CentrifugePrecision="The specified intensities `1` are not attainable by the precisions `2` of the centrifuge that will be used. Therefore, these intensities have been rounded to `3`.";
Warning::ContainerCentrifugeIncompatible="The samples `1` are in containers that cannot fit on the centrifuges `2`. These samples will be transferred to `3`.";
Warning::SterileConflict="Sterile was set as False but some samples are marked as sterile. The experiment will proceed with a non-sterile instrument. If this is not desired, please adjust the sterile option.";
Error::RotorRotorGeometryConflict = "For sample(s) `1`, the specified Rotor `2` are `3`, which do not match the specified RotorGeometry `4`. Please change the Rotor or RotorGeometry option or let it resolve automatically.";
Error::RotorRotorAngleConflict = "For sample(s) `1`, the angle of the specified Rotor `2` are `3`, which do not match the desired RotorAngle `4`. Please change the Rotor or RotorAngle option or let it resolve automatically.";
Error::RotorInstrumentConflict = "For sample(s) `1`, the specified Rotor `2` are not compatible with the specified Instrument `3`. Please change the Rotor or Instrument option or let it resolve automatically.";
Error::RotorDefaultStorageConditionChilledRotorConflict="For samples `1`, ChilledRotor option set to True, it is desired to pick Rotor that are stored in Refrigerator. Please adjust either Rotor to a refrigerated model or object, or allow it to be set automatically.";
Error::InstrumentCentrifugeTypeChilledRotorConflict = "For sample(s) `1`, ChilledRotor option set to True, it is required to pick an Instrument that is Ultracentrifuge. Please change the ChilledRotor or Instrument option or let it resolve automatically.";
Warning::UltracentrifugeChilledRotorHighTempConflict="For samples `1`, ChilledRotor option set to True, it is desired to set the Temperature option to be between 4 Celsius and Ambient. Please adjust either options.";
Warning::UltracentrifugeChilledRotorLowTempConflict="For samples `1`, ChilledRotor option set to False, it is desired to set the Temperature option to be Ambient to 40 Celsius. Please adjust either options.";
Error::NoCompatibleRotor = "There are no rotors capable attaining the specified RotorAngle (`1`) and RotorGeometry (`2`). Please ensure that specified rotor parameters match those of the desired rotor.";
Warning::ConflictingOptionsWithinContainer = "Option values specified for sample(s) `1` are conflicting with other samples in the same container. These samples will therefore be transferred into a new container.";
Error::UltracentrifugeNotEnoughSample = "The following sample(s) `1` do not have sufficient volume(s) (`2`) for an ultracentrifuge run. The containers, with maximum volume of `3`, need to be filled to at least `4`. Consider starting with more samples or diluting your samples.";
Error::CentrifugeTemperatureMustBeAmbient = "The Temperature option was set to a value besides Ambient for the following input sample(s): `1`.  For liquid handling centrifuge operations, please set the Temperature to Ambient.";
Error::CentrifugeContainerNullTareWeight = "The container(s) of the provided sample(s) do not have their TareWeight (or their model's TareWeight) field populated: `1`.  In order to calculate which counterweights to use, a TareWeight of the sample's container or container models is required.";
Error::CentrifugeContainerTooHeavy = "The container(s) containing the provided sample(s) are too heavy to be spun: `1`. Make sure the weight of samples and plate are less than the maximum weight capacity of the chosen centrifuge.";
Error::CentrifugeContainerNoCounterweights = "The container(s) of the provided sample(s) do not have any counterweights that could be associated with them: `1`.  Please perform this operation in a container that has suitable counterweights.";
Error::CentrifugeAndPreparationMismatched= "For the following sample(s) `1`, their specified centrifuges `2` cannot be used in current Preparation method. If Preparation->Robotic, only instrument with a Model[Instrument,Centrifuge,\"VSpin\"] or Model[Instrument,Centrifuge,\"HiG4\"] can be used to spin the sample.";
Error::CentrifugeRotorOptionsNotSpecified= "For the following option(s), `1`,their value should be specified (Not Null). Please set them to change the value or leave them as Automatic.";
Error::ContainerCentrifugeIncompatibleRobotic="The samples `1` are in containers that cannot fit on the centrifuges `2` and will not be robotically transferred to another container. Please invoke a Transfer protocol to transfer samples to a suitable container or choose a different centrifuge/workcell/preparation type.";
(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifuge *)


(* Mixed Input *)
ExperimentCentrifuge[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult,containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCentrifuge,
			listedContainers,
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentCentrifuge,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation,
			EmptyContainers -> MatchQ[$ECLApplication, Engine]
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentCentrifuge,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation,
				EmptyContainers -> MatchQ[$ECLApplication, Engine]
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
		ExperimentCentrifuge[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* Sample input/core overload*)
ExperimentCentrifuge[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		safeOpsNamed, safeOps, safeOpsTests, validLengths, validLengthTests, optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ,collectionContainerOption,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, sampleObjects, centrifugeOption,allCentrifugeEquipmentPackets,
		allPreferredContainers, samplePackets, centrifugeFields, centrifugeRotorOption, centrifugeRotorFields,
		allCounterweights, counterweightModelFields, updatedSimulation,
		thingsToDownload, fieldsToDownload, downloadedStuff, protocolPacketWithResources, resourcePacketTests, protocolObject,
		sampleFields, objectContainerFields, modelContainerFields, resolvedPreparation, centrifugeInstruments,
		centrifugeRotors, centrifugeBuckets, centrifugeAdapters, sampleContainers, uniqueSampleContainers, centrifugeModelFields, centrifugeRotorModelFields,
		centrifugeBucketModelFields, centrifugeAdapterModelFields, simulation, performSimulationQ, simulatedProtocol,
		cacheToUse, specifiedParentProtocol
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentCentrifuge,
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
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentCentrifuge, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentCentrifuge, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

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
		ValidInputLengthsQ[ExperimentCentrifuge, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentCentrifuge, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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
		ApplyTemplateOptions[ExperimentCentrifuge, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentCentrifuge, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
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

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentCentrifuge, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Get the centrifuge option *)
	{centrifugeOption} = Lookup[expandedSafeOps, {Instrument}];

	(* Centrifuge defaults to model, but can be specified as an object. Get the appropriate fields to download. *)
	centrifugeFields = Switch[#,
		ObjectP[Model[Instrument]], {Packet[MaxTime, RequestedResources, MaxTemperature, MinTemperature, SpeedResolution, MaxRotationRate, MinRotationRate, CentrifugeType, AsepticHandling, Positions]},
		ObjectP[Object[Instrument]], {Packet[Model], Packet[Field[Model[{MaxTime, RequestedResources, MaxTemperature, MinTemperature, SpeedResolution, MaxRotationRate, MinRotationRate, CentrifugeType, AsepticHandling, Positions}]]]},
		Automatic, {}
	]& /@ ToList[centrifugeOption];

	(* Get the rotor option *)
	centrifugeRotorOption = Lookup[expandedSafeOps, Rotor];

	(* Get the collection container option *)
	collectionContainerOption=Lookup[expandedSafeOps,CollectionContainer];

	(* Centrifuge defaults to model, but can be specified as an object. Get the appropriate fields to download. *)
	centrifugeRotorFields = Switch[#,
		ObjectP[Model[Container,CentrifugeRotor]], {Packet[Name, MaxRadius, MaxForce, MaxRotationRate, MaxImbalance, Footprint, Positions, AvailableLayouts, RotorType, DefaultStorageCondition, RotorAngle]},
		ObjectP[Object[Container,CentrifugeRotor]], {Packet[StorageCondition],Packet[Field[StorageCondition[{StorageCondition}]]],Packet[Model],Packet[Field[Model[{Name, MaxRadius, MaxForce, MaxRotationRate, MaxImbalance, Footprint, Positions, AvailableLayouts, RotorType, DefaultStorageCondition, RotorAngle}]]]},
		Automatic, {}
	]& /@ ToList[centrifugeRotorOption];


	(* Find all the counterweights models *)
	allCounterweights=allCounterweightsSearch["Memoization"];

	(* Download the necessary fields from the counterweight models *)
	counterweightModelFields={Packet[Footprint, Weight, Name, RentByDefault, Dimensions]};

	(* Separate download to fetch centrifuge/rotor/bucket information required for subsequent resolution steps *)
	(* Find all centrifuge-related objects (instruments, rotors, and buckets) from which we might need information *)
	(* This must be done in a separate Download call here because incoming cache from other functions will not have searched to include all centrifuge equipment *)
	(* This download is memoized so it should only run once in a single kernel session.  Note that it includes all the other memoized searches too *)
	allCentrifugeEquipmentPackets = nonDeprecatedCentrifugeModelPackets["Memoization"];

	(* Get a list of preferred container models which we potential transfer sample in order to centrifuge. *)
	allPreferredContainers = DeleteDuplicates@Join[
		PreferredContainer[All, Type -> All],
		PreferredContainer[All, UltracentrifugeCompatible -> True]
	];

	(* Format the list of things to download *)
	thingsToDownload = Join[
		{
			mySamplesWithPreparedSamples,
			ToList[ParentProtocol /. safeOps]
		},
		List /@ ToList[centrifugeOption] /. Automatic -> Null,
		List /@ ToList[centrifugeRotorOption] /. Automatic -> Null,
		{allCounterweights},
		{allPreferredContainers}
	];

	(* Sample Fields. *)
	sampleFields = SamplePreparationCacheFields[Object[Sample], Format -> Packet];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]],ToList[{DestinationContainerModel,Counterweights}]];

	(* Format the fields to download *)
	fieldsToDownload = Join[
		{
			{
				sampleFields,
				Packet[Container[Model[modelContainerFields]]],
				Packet[Container[objectContainerFields]],
				Packet[Field[Container[Contents][[All, 2]][SamplePreparationCacheFields[Object[Sample]]]]]
			},
			{
				Packet[ImageSample, Name]
			}
		},
		centrifugeFields,
		centrifugeRotorFields,
		{counterweightModelFields},
		{{Packet[Footprint, Dimensions, Name]}}
	];

	cacheToUse = ToList[Lookup[expandedSafeOps, Cache, {}]];

	(* The download *)
	downloadedStuff = Quiet[
		Download[
			thingsToDownload,
			fieldsToDownload,
			Cache -> cacheToUse,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* Get the sample by object instead of Name so we don't have to Download[x,Object] continuously *)
	samplePackets = downloadedStuff[[1]];
	sampleObjects = Lookup[Transpose[samplePackets][[1]], Object];

	(* Download dump *)
	cacheBall = FlattenCachePackets[{Lookup[expandedSafeOps, Cache, {}], Flatten[{downloadedStuff,allCentrifugeEquipmentPackets}]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests} = If[gatherTests,
			resolveExperimentCentrifugeOptions[sampleObjects, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentCentrifugeOptions[sampleObjects, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption,Error::ConflictingUnitOperationMethodRequirements}
	];
	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentCentrifuge,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];
	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo[ReplaceRule[resolvedOptions, Cache -> {}], "resolvedOptions"];
	];
	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

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

	(* NOTE: We need to perform simulation if Result is asked for in Centrifuge since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				DeleteCases[collapsedResolvedOptions, Cache -> _],
				RemoveHiddenOptions[ExperimentCentrifuge, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		(returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly), {$Failed, {}},
		gatherTests, centrifugeResourcePackets[sampleObjects, templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		True, {centrifugeResourcePackets[sampleObjects, templatedOptions, resolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
	];

	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo["centrifugeResourcePackets done"];
	];
	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentCentrifuge[
				(* protocolPacket *)
				protocolPacketWithResources[[1]],
				(* unitOperationPackets *)
				Flatten[ToList[protocolPacketWithResources[[2]]]],
				ToList[sampleObjects],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True, {Null, Null}
	];
	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo["centrifuge simulation done"];
	];
	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> If[MatchQ[resolvedPreparation, Robotic],
				DeleteCases[collapsedResolvedOptions, Cache -> _],
				RemoveHiddenOptions[ExperimentCentrifuge, collapsedResolvedOptions]
			],
			Preview -> Null,
			Simulation -> simulation
		}]
	];


	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources,$Failed], $Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
		protocolPacketWithResources[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive,nonHiddenOriginOptions, samplesMaybeWithModels},

				(* convert the samples to models if we had model inputs originally *)
				(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
				(* NOTE: this is important. Need to use updatedSimulation here and not simulation.  This is because mySamples needs to get converted to model via the simulation _before_ SimulateResources is called in simulateExperimentFilter *)
				(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
				samplesMaybeWithModels = If[NullQ[updatedSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
					mySamples,
					simulatedSamplesToModels[
						Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
						updatedSimulation,
						mySamples
					]
				];

				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				(* Remove any hidden options before returning. *)
				nonHiddenOriginOptions=RemoveHiddenPrimitiveOptions[Centrifuge,listedOptions];
				primitive=Centrifuge@@Join[
					{
						Sample->samplesMaybeWithModels
					},
					nonHiddenOriginOptions
				];

				(* Memoize the value of ExperimentCentrifuge so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentCentrifuge, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentCentrifuge]={};

					ExperimentCentrifuge[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> protocolPacketWithResources[[2]],
							Options -> collapsedResolvedOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> (Max[Lookup[collapsedResolvedOptions, Time]] + 1Minute)
						}
					];

					Module[{experimentFunction,resolvedWorkCell},
						(* look up which workcell we've chosen *)
						resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

						(* pick the corresponding function from the association above *)
						experimentFunction=Lookup[$WorkCellToExperimentFunction,resolvedWorkCell];

						(* run the experiment *)
						experimentFunction[
							{primitive},
							Upload->Lookup[safeOps,Upload],
							Confirm->Lookup[safeOps,Confirm],
							CanaryBranch->Lookup[safeOps,CanaryBranch],
							ParentProtocol->Lookup[safeOps,ParentProtocol],
							Priority->Lookup[safeOps,Priority],
							StartDate->Lookup[safeOps,StartDate],
							HoldOrder->Lookup[safeOps,HoldOrder],
							QueuePosition->Lookup[safeOps,QueuePosition],
							Cache->cacheBall
						]
					]
				]
			],

		(* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualSamplePreparation, generate an *)
		(* Object[Protocol, ManualSamplePreparation]. *)
		And[
			!MatchQ[Lookup[safeOps,ParentProtocol], ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]}]],
			MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], Null|{}],
			MatchQ[Lookup[resolvedOptions, Incubate], {False..}],
			(* NOTE: No Centrifuge prep for Centrifuge. *)
			MatchQ[Lookup[resolvedOptions, Filtration], {False..}],
			MatchQ[Lookup[resolvedOptions, Aliquot], {False..}]
		],
			Module[{primitive, nonHiddenOptions,nonHiddenOriginOptions},
				nonHiddenOptions=RemoveHiddenOptions[ExperimentCentrifuge,collapsedResolvedOptions];
				nonHiddenOriginOptions=RemoveHiddenPrimitiveOptions[Centrifuge,listedOptions];
				primitive=Centrifuge@@Join[
					{
						Sample->mySamples
					},
					nonHiddenOriginOptions
				];

				(* Remove any hidden options before returning.*)
				(* Memoize the value of ExperimentCentrifuge so the framework doesn't spend time resolving it again.*)
				Internal`InheritedBlock[{ExperimentCentrifuge, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentCentrifuge]={};

					ExperimentCentrifuge[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							RunTime -> (Max[Lookup[nonHiddenOptions,Time]]+1Minute)
						}
					];

					ExperimentManualSamplePreparation[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			],


		(* Actually upload our protocol object. *)
		True,
			UploadProtocol[
				protocolPacketWithResources[[1]],
				Null,
				Upload -> Lookup[safeOps, Upload],
				Confirm -> Lookup[safeOps, Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol -> Lookup[safeOps, ParentProtocol],
				Priority -> Lookup[safeOps, Priority],
				StartDate -> Lookup[safeOps, StartDate],
				HoldOrder -> Lookup[safeOps, HoldOrder],
				QueuePosition -> Lookup[safeOps, QueuePosition],
				ConstellationMessage -> Object[Protocol,Centrifuge],
				Simulation -> updatedSimulation
			]
	];
	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo["centrifuge everything done"];
	];
	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> If[MatchQ[resolvedPreparation, Robotic],
			DeleteCases[collapsedResolvedOptions, Cache -> _],
			RemoveHiddenOptions[ExperimentCentrifuge, collapsedResolvedOptions]
		],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> (Max[Lookup[collapsedResolvedOptions,Time]]+1Minute)
	}
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentCentrifugeOptions *)


DefineOptions[
	resolveExperimentCentrifugeOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentCentrifugeOptions[mySamples:{ObjectP[Object[Sample]]..},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentCentrifugeOptions]]:=Module[
	{outputSpecification,output,gatherTests,messages,cache,samplePrepOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,
		centrifugeNewOptions,sampleDownloads, specifiedEmail,specifiedUpload,resolvedEmail,
		resolvedPostProcessingOptions,specifiedParentProtocol, samplePackets, sampleContainerModelPackets,sampleContainerPackets,
		discardedSamplePackets,discardedInvalidInputs, discardedTest,roundedOptions,precisionTests,invalidInputs,invalidOptions,
		sampleContainerModelPacketsWithNulls, sampleContainerPacketsWithNulls, specifiedCentrifuges,specifiedIntensities,
		specifiedTimes,specifiedTemperatures, inputContainerModels, centrifugesAndContainersByOptionSet, specifiedCentrifugeAsModel,
		semiResolvedCentrifuges, semiResolvedTargetContainers, incompatibleCentrifugeBools, noCentrifugeFoundBools,
		noTransferFoundBools, centrifugeInvalidOptions,centrifugeCompatibleTests,noCentrifugeFoundInvalidOptions,
		noCentrifugeFoundTests, noTransferContainerInvalidInputs,noTransferContainerTests, semiResolvedCentrifugesAsModel,
		centrifugeModelCounts,centrifugesByFrequency,resolvedCentrifugeLists,roundedIntensities, intensityPrecisionValidBools,
		semiResolvedTargetContainerModels,resolvedCentrifugeModels,resolvedRotors,resolvedBuckets,maxRadii,optionsWithRoundedIntensity,intensityPrecisionTests, resolvedCentrifugesAsModelLists,resolvedCentrifugesAsModels,resolvedCentrifuges,
		resolvedCentrifugeModelPackets,centrifugeRateResolutions,centrifugeMaxRates,resolvedIntensities, groupedContainerPackets,
		groupedSamples, groupedTargetContainers, groupedTimes, groupedTemperatures, groupedIndexes, centrifugeTransferTests,
		sampleContainerContents, stowAwayBools, stowAways, stowawayTest, targetContainerWithStowAwayTransfers, infoByContainerSet,
		sampleRules, samplesToGroupingIndexRules, sampleToTargetContainerRules, targetContainers, groupingIndexes, groupedCentrifuges,
		groupedIntensities,containerOptionConflicts,containerConflictTransferTests,requestedCounterweights,
		potentialCounterweightPackets,potentialCounterweightWeights,uniqueBucketsAndRotors,uniqueBucketsAndRotorsPositionRule,resolvedCounterbalanceWeights,
		maxImbalances,badWeights,exceededImbalances,invalidWeightsOptions,specifiedName,nameValidBool, nameOptionInvalid,
		nameUniquenessTest,aliquotContainerForResolver,resolvedAliquotOptions,expandByReplicates,
		specifiedSterile, sampleSterility,sterileValidationWarning,resolvedSterile,aliquotTests,allContentsPackets,
		samplePrepTests,specifiedReplicates,expandedSampleContainerPackets, expandedSimulatedSamples, expandedTargetContainerWithStowAwayTransfers,
		expandedResolvedCentrifuges, expandedResolvedIntensities, expandedSpecifiedTemperatures, expandedSpecifiedTimes,
		allCounterweights, centrifugeInstruments, centrifugeRotors, centrifugeBuckets, rotorStorageConditionInvalidOptions,
		allFootprintCentrifugeEquipment, centrifugeInstrumentPackets, centrifugeRotorPackets, centrifugeBucketPackets,
		rotorStorageConditionInvaildTests,
		footprintCentrifugeEquipmentLookup, allFootprints, specifiedCollectionContainers, sampleContainerToSpecifiedCollectionContainerMap,
		resolvedCollectionContainers, conflictingCollectionContainerTests, invalidConflictingContainerOptions, invalidConflictingContainerInputs,
		conflictingContainerToSpecifiedCollectionContainerMap, gatheredContainerToSpecifiedCollectionContainersMap, invalidSampleFilterTests,
		invalidSampleFilterOptions, invalidSampleFilterInputs, invalidSampleFilterResults, centrifugeAdapters, centrifugeAdapterPackets,counterbalancePackets, centrifugeOptionsAssociation,
		simulation, cacheBall, suppliedRotor, suppliedRotorGeometry, suppliedRotorType, rotorRotorGeometryMismatchBooleans, mismatchedRotorRotorGeometrySamples,
		rotorRotorGeometryTest, suppliedRotorAngle, suppliedAngle, rotorRotorAngleMismatchBooleans, mismatchedRotorRotorAngleSamples, suppliedInstrument,
		suppliedRotorFootprint, suppliedInstrumentPositionsFootprint, rotorInstrumentMismatchBooleans, mismatchedRotorInstrumentSamples, suppliedChilledRotor,
		suppliedRotorDefaultStorageCondition, rotorDefaultStorageConditionChilledRotorMismatchBooleans, mismatchedRotorDefaultStorageConditionChilledRotorSamples,
		temperatureChilledRotorTest, suppliedInstrumentCentrifugeType, instrumentCentrifugeTypeChilledRotorMismatchBooleans, mismatchedInstrumentCentrifugeTypeChilledRotorSamples,
		temperatureChilledRotorMismatchBooleans, mismatchedTemperatureChilledRotorSamples, lowTemperatureChilledRotorMismatchBooleans,
		chilledRotorTemperaturesTests, chilledRotorLowTemperaturesTests,
		mismatchedLowTemperatureChilledRotorSamples, suppliedRotorModel, suppliedInstrumentModel, resolvedRotorAngle, resolvedRotorGeometry,
		noRotorFoundBools, noRotorFoundInvalidOptions, noRotorFoundTests, resolvedTemperature, resolvedChilledRotor, roundedTemperatures, rotorRotorGeometryInvalidOptions,
		rotorRotorAngleInvalidOptions, rotorInstrumentInvalidOptions, chilledRotorInstrumentInvalidOptions, resolvedCentrifugeType, semiResolvedTargetContainerMaxVolumes,
		ultracentrifugeContainerMaxVolumes, sampleVolumes, ultracentrifugeSamples, ultracentrifugeSampleVolumes, percentFilled, invalidVolumeSamples, invalidSampleVolumes,
		invalidSampleContainerMaxVolumes, insufficientVolumeInputs, ultracentrifugeVolumeTests, preparationResult, allowedPreparation, preparationTest, resolvedPreparation,
		roboticPritimitveQ,samplesNoDupes,preResolvedSampleLabels,preResolvedLabelRules,resolvedSampleLabels,containersNoDupes,
		preResolvedContainerLabels,preResolvedContainerLabelRules,resolvedSampleContainerLabels,mapThreadFriendlyOptions,temperatureMustBeAmbientSamples,
		temperatureMustBeAmbientOptions,temperatureMustBeAmbientTest,invalidTemperatures, mismatchedSamples,mismatchedCentrifugeOptions,mismatchedCentrifugeTests,
		resolvedCounterweight, mismatchedInstruments, nullTareWeightErrors, noCounterweightErrors,nullTareWeightSamples,
		nullTareWeightInputs,nullTareWeightTest,noCounterweightSamples,noCounterweightInputs,noCounterweightTest,incompatiblePreparationOptions,incompatiblePreparationTests,
		misMatchedInstrumentPreparationQ, allowedWorkCells, resolvedWorkCell,priorityOfCentrifuges,cantTransferRoboticBools,
		cantTransferContainerRoboticInvalidInputs,centrifugeMinRates,plateTooHeavyForCentrifugeErrors,tooHeavyPlateSamples,tooHeavyPlateInputs, fastAssoc
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];
	
	(* Fetch our cache from the parent function. *)
	cache = Quiet[OptionValue[Cache]];
	simulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our CentrifugeNew options from our Sample Prep options. *)
	{samplePrepOptions,centrifugeNewOptions}=splitPrepOptions[myOptions, PrepOptionSets -> {IncubatePrepOptionsNew, FilterPrepOptionsNew, AliquotOptions}];

	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentCentrifuge,mySamples,samplePrepOptions,EnableSamplePreparation->Lookup[myOptions,EnableSamplePreparation],Cache->cache,Simulation->simulation, Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentCentrifuge,mySamples,samplePrepOptions,EnableSamplePreparation->Lookup[myOptions,EnableSamplePreparation],Cache->cache,Simulation->simulation, Output->Result],{}}
	];

	(* Pull out options and assign them to variables *)
	{
		specifiedCentrifuges,
		specifiedIntensities,
		specifiedTimes,
		specifiedTemperatures,
		specifiedParentProtocol,
		specifiedEmail,
		specifiedUpload,
		specifiedName,
		specifiedSterile,
		specifiedReplicates,
		specifiedCollectionContainers
	}=Lookup[
		centrifugeNewOptions,
		{
			Instrument,
			Intensity,
			Time,
			Temperature,
			ParentProtocol,
			Email,
			Upload,
			Name,
			Sterile,
			NumberOfReplicates,
			CollectionContainer
		}
	];

	(* Find all the counterweights *)
	allCounterweights=allCounterweightsSearch["Memoization"];

	(* Extract the packets that we need from our downloaded cache. *)
	(* only even bother Downloading if simulatedSamples and mySamples are different from each other; otherwise we already have the information in the cache *)
	sampleDownloads = If[Not[MatchQ[simulatedSamples, mySamples]],
		Quiet[Download[
			simulatedSamples,
			{
				Packet[Status, LiquidHandlerIncompatible, Volume, Container, Sterile, Name, Mass, Model, Position, StorageCondition],
				Packet[Container[Model[{MaxVolume,NumberOfWells, Name, Deprecated, Sterile, AspectRatio, Counterweights, TareWeight, Footprint,Positions,Dimensions}]]],
				Packet[Container[{Contents,Model, Name, Status, Sterile, TareWeight}]],
				Packet[Container[Contents][[All, 2]][{Container, Volume, Mass, Model}]]
			},
			Cache->cache,
			Simulation -> updatedSimulation
		],{Download::FieldDoesntExist}],
		{}
	];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{cache, sampleDownloads}];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Find all centrifuge equipment in order to download required information from it *)
	(* Search for all centrifuge models in the lab to download from. *)
	{
		centrifugeInstruments,
		centrifugeRotors,
		centrifugeBuckets,
		centrifugeAdapters
	}=allCentrifugeEquipmentSearch["Memoization"];

	centrifugeInstrumentPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeInstruments;
	centrifugeRotorPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeRotors;
	centrifugeBucketPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeBuckets;
	centrifugeAdapterPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeAdapters;
	counterbalancePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ allCounterweights;

	(* Get the downloaded mess into a usable form *)
	{samplePackets, sampleContainerModelPacketsWithNulls,sampleContainerPacketsWithNulls,allContentsPackets}=If[Not[MatchQ[simulatedSamples, mySamples]],
		Transpose[sampleDownloads],
		{
			fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSamples,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, {Container, Model}], fastAssoc]& /@ simulatedSamples,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Container], fastAssoc]& /@ simulatedSamples,
			With[
				{
					containerContents = Map[
						If[MatchQ[fastAssocLookup[fastAssoc, #, {Container, Contents}],$Failed],
							(* If the Container is Null because the sample is discarded, assume that we only have this sample to check. We will throw an error message later for discarded sample. Any non-discarded sample should ALWAYS have a container *)
							{#},
							fastAssocLookup[fastAssoc, #, {Container, Contents}][[All,2]]
						]&,
						simulatedSamples
					]
				},
				Map[
					fetchPacketFromFastAssoc[#, fastAssoc]&,
					containerContents,
					{2}
				]
			]
		}
	];


	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
		Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls,{Null-><||>,$Failed-><||>}, 1];
	sampleContainerPackets = Replace[sampleContainerPacketsWithNulls,{Null-><||>,$Failed-><||>}, 1];

	(* Pull out footprints for input containers *)
	(* inputContainerFootprints = Lookup[sampleContainerModelPackets, Footprint, Null]; *)
	allFootprints = List@@CentrifugeableFootprintP;

	(* Get centrifuge equipment ensembles (i.e., instrument/rotor(/bucket) combos for all possible footprints (must account for the possibility of container change) *)
	(* Note: We don't have any collection containers resolved at this point, so we pass this input as Null down to the footprint function. *)
	allFootprintCentrifugeEquipment = centrifugesForFootprint[
		allFootprints,
		ConstantArray[Null, Length[allFootprints]],
		ConstantArray[Null, Length[allFootprints]],
		Flatten[{centrifugeInstrumentPackets, centrifugeRotorPackets, centrifugeBucketPackets, centrifugeAdapterPackets}]
	];

	(* Generate a lookup table from footprint to centrifuge equipment *)
	footprintCentrifugeEquipmentLookup = AssociationThread[allFootprints, allFootprintCentrifugeEquipment];


	(*-- INPUT VALIDATION CHECKS --*)

	(* - Check if samples are discarded - *)

	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];
	discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message .*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs, Cache->cacheBall]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs], Cache->cacheBall]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Note that we may catch more invalid inputs later when we figure out the transfers that need to happen
	(if we find that a sample needs to be transferred but can't find a container to transfer it to.) *)


	(*-- OPTION PRECISION CHECKS --*)

	(* - Check that temperature is not more precise than 1C and time not more than 1s - *)
	{roundedOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[Association[centrifugeNewOptions],{Temperature,Time},{1 Celsius,1 Second},Output->{Result,Tests}],
		{RoundOptionPrecision[Association[centrifugeNewOptions],{Temperature,Time},{1 Celsius,1 Second}],Null}
	];

	(* Note that intensity precision isn't checked until we know the centrifuge that will be used and the container that the sample will be in
	since we can't convert between rate and force without knowing the container and the centrifuge
	 and since we don't know the rate precision until we know the centrifuge. *)

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	centrifugeOptionsAssociation = Association[roundedOptions];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentCentrifuge, Normal[roundedOptions]];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* -- 1. Rotor & RotorGeometry conflict -- *)

	(* Lookup the value of the options and the field(s) in specified Rotor *)
	suppliedRotor = Lookup[centrifugeOptionsAssociation,Rotor];
	suppliedRotorModel = Map[
		Switch[#,
			ObjectP[Object[Container,CentrifugeRotor]],Download[Lookup[fetchPacketFromFastAssoc[Download[#,Object],fastAssoc],Model],Object],
			ObjectP[Model[Container,CentrifugeRotor]],Download[#,Object],
			Automatic,#
		]&,
		suppliedRotor
	];
	suppliedRotorGeometry = Lookup[centrifugeOptionsAssociation,RotorGeometry]/.{FixedAngleRotor->FixedAngle,SwingingBucketRotor->SwingingBucket};

	(* Lookup the value of the field(s) in specified Rotor *)
	suppliedRotorType = Map[
		Function[{rotor},
			If[MatchQ[rotor,Automatic],
				Automatic,
				Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc],RotorType]
			]
		],
		suppliedRotorModel
	];

	rotorRotorGeometryMismatchBooleans=MapThread[
		Function[{rotor,type,geometry},
			If[MatchQ[rotor,Automatic]||MatchQ[geometry,Automatic],
				False,
				If[MatchQ[type,geometry],
					False,
					True
				]
			]
		],
		{suppliedRotor,suppliedRotorType,suppliedRotorGeometry}
	];

	(* Get the samples for which the RotorGeometry is invalid *)
	mismatchedRotorRotorGeometrySamples=PickList[simulatedSamples,rotorRotorGeometryMismatchBooleans,True];

	(* Throw message *)
	rotorRotorGeometryInvalidOptions=If[!gatherTests&&!MatchQ[mismatchedRotorRotorGeometrySamples,{}],
		Message[Error::RotorRotorGeometryConflict,
			ObjectToString[mismatchedRotorRotorGeometrySamples,Cache->cacheBall],
			suppliedRotor,
			suppliedRotorType,
			suppliedRotorGeometry
		];
		{Rotor,RotorGeometry},
		{}
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	rotorRotorGeometryTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedRotorRotorGeometrySamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedRotorRotorGeometrySamples,Cache->cacheBall]<>" the specified Rotor option should match RotorGeometry:",True,False]
			];
			passingTest=If[Length[mismatchedRotorRotorGeometrySamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedRotorRotorGeometrySamples],Cache->cacheBall]<>" the specified Rotor option should match RotorGeometry:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- 2. Rotor & RotorAngle conflict -- *)

	(* Lookup the value of the options *)
	(* suppliedRotor is already defined *)
	suppliedRotorAngle = Lookup[centrifugeOptionsAssociation,RotorAngle];

	(* Lookup the value of the field(s) in specified Rotor *)
	suppliedAngle = Map[
		Function[{rotor},
			If[MatchQ[rotor,Automatic],
				Automatic,
				Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc],RotorAngle]
			]
		],
		suppliedRotorModel
	];

	rotorRotorAngleMismatchBooleans=MapThread[
		Function[{rotor,rotorAngle,angle},
			If[MatchQ[rotor,Automatic]||MatchQ[angle,Automatic],
				False,
				If[MatchQ[rotorAngle,angle],
					False,
					True
				]
			]
		],
		{suppliedRotor,suppliedAngle,suppliedRotorAngle}
	];

	(* Get the samples for which the RotorAngle is invalid *)
	mismatchedRotorRotorAngleSamples=PickList[simulatedSamples,rotorRotorAngleMismatchBooleans,True];

	(* Throw message *)
	rotorRotorAngleInvalidOptions=If[!gatherTests&&!MatchQ[mismatchedRotorRotorAngleSamples,{}],
		Message[Error::RotorRotorAngleConflict,
			ObjectToString[mismatchedRotorRotorAngleSamples,Cache->cacheBall],
			suppliedRotor,
			suppliedAngle,
			suppliedRotorAngle
		];
		{Rotor,RotorAngle},
		{}
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	rotorRotorGeometryTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedRotorRotorAngleSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedRotorRotorAngleSamples,Cache->cacheBall]<>" the specified Rotor option should match RotorAngle:",True,False]
			];
			passingTest=If[Length[mismatchedRotorRotorAngleSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedRotorRotorAngleSamples],Cache->cacheBall]<>" the specified Rotor option should match RotorAngle:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* -- 3. Rotor & Instrument conflict -- *)

	(* Lookup the value of the options *)
	(* suppliedRotor is already defined *)
	suppliedInstrument = Lookup[centrifugeOptionsAssociation,Instrument];
	suppliedInstrumentModel = Map[
		Switch[#,
			ObjectP[Object[Instrument,Centrifuge]],Download[Lookup[fetchPacketFromFastAssoc[Download[#,Object],fastAssoc],Model],Object],
			ObjectP[Model[Instrument,Centrifuge]],Download[#,Object],
			Automatic,#
		]&,
		suppliedInstrument
	];

	(* Lookup the value of the field(s) in specified Rotor *)
	suppliedRotorFootprint = Map[
		Function[{rotor},
			If[MatchQ[rotor,Automatic],
				Automatic,
				Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc],Footprint]
			]
		],
		suppliedRotorModel
	];

	(* Lookup the value of the fields in the specified Instrument *)
	suppliedInstrumentPositionsFootprint = Flatten@Map[
		Function[{instrument},
			If[MatchQ[instrument, Automatic],
				Automatic,
				Lookup[Lookup[fetchPacketFromFastAssoc[instrument, fastAssoc], Positions], Footprint]
			]
		],
		suppliedInstrumentModel
	];

	rotorInstrumentMismatchBooleans=MapThread[
		Function[{rotor,instrument,rotorFootprint,instrumentPositions},
			If[MatchQ[rotor,Automatic]||MatchQ[instrument,Automatic],
				False,
				If[MatchQ[rotorFootprint,instrumentPositions],
					False,
					True
				]
			]
		],
		{suppliedRotor,suppliedInstrument,suppliedRotorFootprint,suppliedInstrumentPositionsFootprint}
	];

	(* Get the samples for which the Footprint of Rotor does not match with the Instrument *)
	mismatchedRotorInstrumentSamples=PickList[simulatedSamples,rotorInstrumentMismatchBooleans,True];

	(* Throw message *)
	rotorInstrumentInvalidOptions=If[!gatherTests&&!MatchQ[mismatchedRotorInstrumentSamples,{}],
		Message[Error::RotorInstrumentConflict,
			ObjectToString[mismatchedRotorInstrumentSamples,Cache->cacheBall],
			suppliedRotor,
			suppliedInstrument
		];
		{Rotor,Instrument},
		{}
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	rotorRotorGeometryTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedRotorInstrumentSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedRotorInstrumentSamples,Cache->cacheBall]<>" the specified Rotor option should be compatible with the Instrument:",True,False]
			];
			passingTest=If[Length[mismatchedRotorInstrumentSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedRotorInstrumentSamples],Cache->cacheBall]<>" the specified Rotor option should be compatible with the Instrument:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* -- 4. ChilledRotor & Rotor(DefaultStorageCondition) conflict -- *)

	(* Lookup the value of the options *)
	(* suppliedRotor is already defined *)
	suppliedChilledRotor = Lookup[centrifugeOptionsAssociation,ChilledRotor];

	(* Lookup the value of the fields：what if the result is Null ultracentrifuge will not be Null *)
	suppliedRotorDefaultStorageCondition = Map[
		Function[{rotor},
			If[MatchQ[rotor, Automatic],
				Automatic,
				Which[
					MatchQ[rotor, ObjectP[Model[Container,CentrifugeRotor]]],
					Automatic,

					MatchQ[rotor, ObjectP[Object[Container,CentrifugeRotor]]],
					If[
						MatchQ[Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc], StorageCondition], Null],
						Null,
						Lookup[
							fetchPacketFromFastAssoc[
								Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc], StorageCondition],
								fastAssoc
							],
							StorageCondition,
							{}
						]
					]
				]
			]
		],
		suppliedRotor
	];

	rotorDefaultStorageConditionChilledRotorMismatchBooleans=MapThread[
		Function[{rotor,chilledRotor,rotorDefaultStorageCondition},
			If[MatchQ[rotor,Automatic]||MatchQ[chilledRotor,Automatic],
				False,
				If[MatchQ[chilledRotor,True],
					If[MatchQ[rotorDefaultStorageCondition,Refrigerator|Automatic],
						False,
						True
					]
				]
			]
		],
		{suppliedRotor,suppliedChilledRotor,suppliedRotorDefaultStorageCondition}
	];

	(* Get the samples for which the Rotor(DefaultStorageCondition) and ChilledRotor are mismatched *)
	mismatchedRotorDefaultStorageConditionChilledRotorSamples=PickList[simulatedSamples,rotorDefaultStorageConditionChilledRotorMismatchBooleans,True];

	(* Throw message *)
	rotorStorageConditionInvalidOptions = If[!gatherTests&&!MatchQ[mismatchedRotorDefaultStorageConditionChilledRotorSamples,{}],
		(
			Message[Error::RotorDefaultStorageConditionChilledRotorConflict, ObjectToString[mismatchedRotorDefaultStorageConditionChilledRotorSamples,Cache->cacheBall]];
			{Rotor, ChilledRotor}
		),
		{}
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	rotorStorageConditionInvaildTests = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedRotorDefaultStorageConditionChilledRotorSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedRotorDefaultStorageConditionChilledRotorSamples,Cache->cacheBall]<>" when ChillRotor sets to True, the DefaultStorageCondition of the Rotor should be Refrigerator:",True,False]
			];
			passingTest=If[Length[mismatchedRotorDefaultStorageConditionChilledRotorSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedRotorDefaultStorageConditionChilledRotorSamples],Cache->cacheBall]<>" when ChillRotor sets to True, the DefaultStorageCondition of the Rotor should be Refrigerator:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- 5. ChilledRotor & Instrument(CentrifugeType) conflict -- *)
	(* If ChilledRotor is set to True, the centrifuge instrument has to be an ultracentrifuge *)

	(* suppliedChilledRotor and suppliedInstrument are already defined *)

	(* Lookup the value of the fields *)
	(* Lookup the value of the fields in the specified Instrument: CentrifugeType *)
	suppliedInstrumentCentrifugeType = Flatten@Map[
		Function[{instrument},
			If[MatchQ[instrument, Automatic],
				Automatic,
				Lookup[fetchPacketFromFastAssoc[instrument, fastAssoc], CentrifugeType]
			]
		],
		suppliedInstrumentModel
	];

	instrumentCentrifugeTypeChilledRotorMismatchBooleans=MapThread[
		Function[{instrument,chilledRotor,instrumentCentrifugeType},
			If[MatchQ[instrument,Automatic]||MatchQ[chilledRotor,Automatic],
				False,
				If[MatchQ[chilledRotor,True],
					If[MatchQ[instrumentCentrifugeType,Ultra],
						False,
						True
					]
				]
			]
		],
		{suppliedInstrument,suppliedChilledRotor,suppliedInstrumentCentrifugeType}
	];

	(* Get the samples for which the Rotor(DefaultStorageCondition) and ChilledRotor are mismatched *)
	mismatchedInstrumentCentrifugeTypeChilledRotorSamples=PickList[simulatedSamples,instrumentCentrifugeTypeChilledRotorMismatchBooleans,True];

	(* Throw message *)
	chilledRotorInstrumentInvalidOptions=If[!gatherTests&&!MatchQ[mismatchedInstrumentCentrifugeTypeChilledRotorSamples,{}],
		Message[Error::InstrumentCentrifugeTypeChilledRotorConflict,
			ObjectToString[mismatchedInstrumentCentrifugeTypeChilledRotorSamples,Cache->cacheBall]
		];
		{ChilledRotor,Instrument},
		{}
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	temperatureChilledRotorTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedInstrumentCentrifugeTypeChilledRotorSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedInstrumentCentrifugeTypeChilledRotorSamples,Cache->cacheBall]<>" when ChillRotor sets to True, the Instrument should be an ultracentrifuge:",True,False]
			];
			passingTest=If[Length[mismatchedInstrumentCentrifugeTypeChilledRotorSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedInstrumentCentrifugeTypeChilledRotorSamples],Cache->cacheBall]<>" when ChillRotor sets to True, the Instrument should be an ultracentrifuge:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- 6. Temperature & ChilledRotor conflict -- *)
	(* If ChilledRotor is set to True, Temperature needs to be in between 4 and Ambient temperature *)

	(* Lookup the value of the options *)
	roundedTemperatures = Lookup[centrifugeOptionsAssociation,Temperature];

	(* suppliedChillRotor is already defined, so is specifiedTempeartures *)
	temperatureChilledRotorMismatchBooleans=MapThread[
		Function[{temp,chilledRotor},
			If[MatchQ[temp,Automatic],
				False,
				If[MatchQ[chilledRotor,True],
					If[RangeQ[temp, {4 Celsius,$AmbientTemperature}, Inclusive -> False],
						False,
						True
					],
					False
				]
			]
		],
		{roundedTemperatures,suppliedChilledRotor}
	];

	(* Get the samples for which the Temperature and ChilledRotor are mismatched *)
	mismatchedTemperatureChilledRotorSamples=PickList[simulatedSamples,temperatureChilledRotorMismatchBooleans,True];

	(* Throw message *)
	If[!gatherTests&&!MatchQ[mismatchedTemperatureChilledRotorSamples,{}]&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::UltracentrifugeChilledRotorHighTempConflict,
			ObjectToString[mismatchedTemperatureChilledRotorSamples,Cache->cacheBall]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	chilledRotorTemperaturesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedTemperatureChilledRotorSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedTemperatureChilledRotorSamples,Cache->cacheBall]<>" when ChillRotor sets to True, Temperature should be in a range from 4 Celsius to Ambient:",True,False]
			];
			passingTest=If[Length[mismatchedTemperatureChilledRotorSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedTemperatureChilledRotorSamples],Cache->cacheBall]<>" when ChillRotor sets to True, Temperature should be in a range from 4 Celsius to Ambient:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- 7. Temperature & ChilledRotor conflict -- *)
	(* If ChilledRotor is set to False, Temperature cannot be below ambient temperature *)

	(* Lookup the value of the options *)
	(* suppliedChilledRotor are both defined already *)

	lowTemperatureChilledRotorMismatchBooleans=MapThread[
		Function[{temp,chilledRotor},
			If[MatchQ[temp,Automatic],
				False,
				If[MatchQ[chilledRotor,False],
					If[RangeQ[temp, {4 Celsius, $AmbientTemperature}, Inclusive -> False],
						True,
						False
					],
					False
				]
			]
		],
		{roundedTemperatures,suppliedChilledRotor}
	];

	(* Get the samples for which the Temperature and ChilledRotor are mismatched *)
	mismatchedLowTemperatureChilledRotorSamples=PickList[simulatedSamples,lowTemperatureChilledRotorMismatchBooleans,True];

	(* Throw message *)
	If[!gatherTests&&!MatchQ[mismatchedLowTemperatureChilledRotorSamples,{}]&&(!MatchQ[$ECLApplication, Engine]),
		Message[Warning::UltracentrifugeChilledRotorLowTempConflict,
			ObjectToString[mismatchedLowTemperatureChilledRotorSamples,Cache->cacheBall]
		]
	];

	(* Create a test for the valid samples and one for the invalid samples *)
	chilledRotorLowTemperaturesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[mismatchedLowTemperatureChilledRotorSamples]==0,
				Nothing,
				Test["For our input samples "<>ObjectToString[mismatchedLowTemperatureChilledRotorSamples,Cache->cacheBall]<>" when ChillRotor sets to False, Temperature should be in a range from Ambient to 40 Celsius:",True,False]
			];
			passingTest=If[Length[mismatchedLowTemperatureChilledRotorSamples]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,mismatchedLowTemperatureChilledRotorSamples],Cache->cacheBall]<>"  when ChillRotor sets to False, Temperature should be in a range from Ambient to 40 Celsius:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(*---  Resolve the Preparation to determine liquidhandling scale ---*)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveCentrifugeMethod[simulatedSamples, ReplaceRule[myOptions, {FromExperimentCentrifuge -> True, Cache->cacheBall, Simulation -> simulation, Output->Result}]],
				{}
			},
			resolveCentrifugeMethod[simulatedSamples, ReplaceRule[myOptions, {FromExperimentCentrifuge -> True, Cache->cacheBall, Simulation -> simulation, Output->{Result, Tests}}]]
		],
		$Failed
	];
	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* build a short hand for robotic primitive*)
	roboticPritimitveQ=MatchQ[resolvedPreparation, Robotic];

	allowedWorkCells=If[roboticPritimitveQ,
		resolveExperimentCentrifugeWorkCell[mySamples, ReplaceRule[myOptions, {Simulation -> updatedSimulation, Cache->cacheBall, Output->Result}]]
	];

	(*--- Resolve all Sample Labels ---*)
	(* get the samples without duplicates and make fake labels for them that might be used *)
	samplesNoDupes = DeleteDuplicates[Lookup[samplePackets, Object, {}]];
	preResolvedSampleLabels = Table[CreateUniqueLabel["centrifugation sample"], Length[samplesNoDupes]];
	preResolvedLabelRules = MapThread[
		#1 -> #2&,
		{samplesNoDupes, preResolvedSampleLabels}
	];

	(* Resolve SampleLabel if it's not given. *)
	resolvedSampleLabels = MapThread[
		Which[

			(* Use user specified values first*)
			MatchQ[#1, Except[Automatic]],
			#1,

			(* Then check if they are labeled in simulation*)
			MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[#2, Object]], _String],
			LookupObjectLabel[simulation, Download[#2, Object]],

			(* Then fetch the label from preresolved value *)
			True,
			Lookup[preResolvedLabelRules, #2]
		]&,
		{Lookup[mapThreadFriendlyOptions, SampleLabel], Lookup[samplePackets, Object, {}]}
	];

	(* get the containers without duplicates and make fake labels for them that might be used *)
	containersNoDupes = DeleteDuplicates[Download[Lookup[samplePackets, Container, {}], Object]];
	preResolvedContainerLabels = Table[CreateUniqueLabel["centrifugation container"], Length[containersNoDupes]];
	preResolvedContainerLabelRules = MapThread[
		#1 -> #2&,
		{containersNoDupes, preResolvedContainerLabels}
	];

	(* Resolve SampleContainerLabel if it's not given. *)
	resolvedSampleContainerLabels = MapThread[
		Which[

			(* Use user specified values first*)
			MatchQ[#1, Except[Automatic]],
			#1,

			(* Then check if they are labeled in simulation*)
			MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[#2, Object]], _String],
			LookupObjectLabel[simulation, Download[#2, Object]],

			(* Then fetch the label from preresolved value *)
			True,
			Lookup[preResolvedContainerLabelRules, #2]
		]&,
		{Lookup[mapThreadFriendlyOptions, SampleContainerLabel], Download[Lookup[samplePackets, Container, {}], Object]}
	];


	(* Pull out the sample sterility settings *)
	sampleSterility = Lookup[samplePackets,Sterile];

	(* If Sterile was set to False and any samples are marked as sterile, throw a warning. *)
	sterileValidationWarning = If[MemberQ[sampleSterility,True] && MatchQ[specifiedSterile,False],

	(* Give a failing warning or throw a message if the user specified sterile as False and any samples are sterile *)
		If[gatherTests||MatchQ[$ECLApplication,Engine],
			Warning["Sterile was set as False but some samples are marked as sterile.",False,True],
			Message[Warning::SterileConflict,ObjectToString[PickList[simulatedSamples,sampleSterility], Cache->cacheBall]];
			Nothing
		],

	(* Give a passing warning or don't throw a message otherwise. If the user did not specify sterile, do nothing since this test is irrelevant. *)
		If[gatherTests && !MatchQ[specifiedSterile,Automatic],
			Warning["The specified sterile option does not conflict with the sterility of the samples.",True,True],
			Nothing
		]
	];

	(* If sterile was already specified, use that. Otherwise, resolve to True if any samples are sterile and False if no samples are sterile. *)
	resolvedSterile=Which[
		BooleanQ[specifiedSterile], specifiedSterile,
		MemberQ[sampleSterility,True], True,
		True, False
	];

	(* Resolve temperature *)
	resolvedTemperature = MapThread[
		Function[{temperature,chillRotor,chilledRotorCentrifugeTypeConflict},
			Which[
				(* If temperature is specifed, go with it *)
				MatchQ[temperature, Except[Automatic]],
				temperature,

				(* If ChilledRotor is specifed, we need to look at whether its specified value is True or False *)
				BooleanQ[chillRotor],
				(* If ChilledRotor is True, set the temperature to 4 degree *)
				(* Otherwise set it to Ambient temperature *)
				If[TrueQ[chillRotor]&&!TrueQ[chilledRotorCentrifugeTypeConflict],
					4 Celsius,
					Ambient
				],

				(* All other cases, resolve temperature to Ambient *)
				True,
				Ambient
			]
		],
		{roundedTemperatures,suppliedChilledRotor,instrumentCentrifugeTypeChilledRotorMismatchBooleans}
	];

	(* if we using robotic primitive, then everything temperature needs to be Ambient or 25 Celsius*)
	invalidTemperatures=If[roboticPritimitveQ,Cases[resolvedTemperature,Except[Ambient|$AmbientTemperature]],{}];

	(*Throw errors and making tests*)
	(* throw a message if temperature is anything but ambient *)
	temperatureMustBeAmbientSamples = PickList[mySamples, resolvedTemperature,Except[Ambient|$AmbientTemperature]];
	temperatureMustBeAmbientOptions = If[messages && Length[invalidTemperatures]>0,
		(
			Message[Error::CentrifugeTemperatureMustBeAmbient, ObjectToString[temperatureMustBeAmbientSamples, Cache -> cache]];
			{Temperature}
		),
		{}
	];

	(* make a test for if temperature is anything but ambient *)
	temperatureMustBeAmbientTest = If[gatherTests,
		Test["Temperature option is set to Ambient or Null for all samples:",
			(Length[invalidTemperatures]==0),
			True
		]
	];


	(* Resolve the CollectionContainer option. Any samples that are in filter containers should get a collection container set. *)
	(* Additionally, we have multiple samples in the same plate and the user has set a collection container for one of those samples *)
	(* we should copy over that value to all samples in the same plate. *)

	(* Make a map between any user set collection container indexes and the container that option pertains to. *)
	sampleContainerToSpecifiedCollectionContainerMap=MapThread[
		Function[{collectionContainer,sampleContainerPacket},
			(* Did the user set collection container and do we have a sample container? *)
			If[!MatchQ[collectionContainer, Automatic] && MatchQ[sampleContainerPacket, ObjectP[Object[Container]]],
				(* Yes, make a rule. *)
				Lookup[sampleContainerPacket, Object] -> collectionContainer,
				(* No. Ignore. *)
				Nothing
			]
		],
		{specifiedCollectionContainers,sampleContainerPacketsWithNulls}
	];

	resolvedCollectionContainers=MapThread[
		Function[{collectionContainer,samplePacket,sampleModelContainerPacket},
			(* Did the user set collection container? *)
			If[!MatchQ[collectionContainer, Automatic],
				(* Yes. Leave it alone. *)
				collectionContainer,
				(* Otherwise, we have to resolve it. *)

				(* Has the user set the sample's container to have a collection elsewhere in the options? *)
				If[MemberQ[Keys[sampleContainerToSpecifiedCollectionContainerMap], Download[Lookup[samplePacket,Container], Object]],
					(* Yes. Pull out their previously set value. *)
					(* Note: There can be conflicting values (multiple entries) that the user has given us so a lookup will just pull out one of them. *)
					Lookup[sampleContainerToSpecifiedCollectionContainerMap, Download[Lookup[samplePacket,Container], Object]],
					(* No. Is the sample in a filter container that has a Plate footprint? *)
					If[MatchQ[Quiet[Lookup[sampleModelContainerPacket, Object]], ObjectP[Model[Container, Plate, Filter]]] && MatchQ[Quiet[Lookup[sampleModelContainerPacket, Footprint]], Plate],
						(* Yes. Set the collection container to be a UV-Star or DWP depending on Preparation. *)
						(* Note: we distinguish between unique plates later in the resource packets function. *)
						If[MatchQ[resolvedPreparation,Robotic],
							(* collection container should be the UV-Star plate for centrifuges using robotic preparation because of height restrictions *)
							(* Same logic as ExperiemntFilter *)
							Model[Container, Plate, "96-well UV-Star Plate"],
							Model[Container, Plate, "96-well 2mL Deep Well Plate"]
						],
						(* No collection container needed. *)
						Null
					]
				]
			]
		],
		{specifiedCollectionContainers,samplePackets,sampleContainerModelPacketsWithNulls}
	];

	(* Error check the CollectionContainer option. *)

	(* Samples have to be in a filter container with a Plate footprint, or a Model[Container, Vessel, Filter], in order to have a CollectionContainer. *)
	invalidSampleFilterResults=MapThread[
		Function[{resolvedCollectionContainer,samplePacket,sampleModelContainerPacket},
			If[NullQ[resolvedCollectionContainer] || MatchQ[sampleModelContainerPacket, ObjectP[Model[Container, Vessel, Filter]]] || (MatchQ[sampleModelContainerPacket, ObjectP[Model[Container, Plate, Filter]]] && MatchQ[Lookup[sampleModelContainerPacket, Footprint], Plate]),
				Nothing,
				{Lookup[samplePacket, Object], resolvedCollectionContainer}
			]
		],
		{resolvedCollectionContainers,samplePackets,sampleContainerModelPacketsWithNulls}
	];

	{invalidSampleFilterInputs,invalidSampleFilterOptions}=If[Length[invalidSampleFilterResults] > 0,
		{invalidSampleFilterResults[[All,1]], {CollectionContainer}},
		{{},{}}
	];

	invalidSampleFilterTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidSampleFilterInputs] > 0,
				Test["The samples "<>ObjectToString[invalidSampleFilterInputs, Cache->cacheBall]<>" are in a stacking-compatible Model[Container, Plate, Filter]s, or Model[Container, Vessel, Filter]s, if the CollectionContainer option is set:",True,False],
				Nothing
			];

			passingTest=If[Length[Complement[invalidSampleFilterInputs, simulatedSamples]] > 0,
				Test["The samples "<>ObjectToString[Complement[invalidSampleFilterInputs, simulatedSamples], Cache->cacheBall]<>" are in a stacking-compatible Model[Container, Plate, Filter]s, or Model[Container, Vessel, Filter]s, if the CollectionContainer option is set:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		If[Length[invalidSampleFilterInputs] > 0,
			Message[Error::SamplesNotInFilterContainer, ObjectToString[invalidSampleFilterResults[[All,1]], Cache->cacheBall], invalidSampleFilterResults[[All,2]]]
		];

		{}
	];

	(* In the form:
		{
			sampleContainer->{collectionContainer..},
			...
		}
	*)

	gatheredContainerToSpecifiedCollectionContainersMap=GroupBy[DeleteDuplicates[sampleContainerToSpecifiedCollectionContainerMap], First->Last];

	(* The conflicting collection containers are the elements that have more than one collection container on the right hand side. *)
	conflictingContainerToSpecifiedCollectionContainerMap=(If[Length[#[[2]]]>1, #, Nothing]&)/@Normal[gatheredContainerToSpecifiedCollectionContainersMap];

	{invalidConflictingContainerInputs,invalidConflictingContainerOptions}=If[Length[conflictingContainerToSpecifiedCollectionContainerMap] > 0,
		{
			(* Get the samples out of the container that has a problem. *)
			Intersection[
				Lookup[samplePackets, Object],
				Flatten[
					(
						Download[Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Contents][[All,2]], Object]
					&)/@conflictingContainerToSpecifiedCollectionContainerMap[[All,1]]
				]
			],
			{CollectionContainer}
		},
		{{},{}}
	];

	conflictingCollectionContainerTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingContainerInputs] > 0,
				Test["The samples "<>ObjectToString[invalidConflictingContainerInputs, Cache->cacheBall]<>" do not have conflicting CollectionContainers set:",True,False],
				Nothing
			];

			passingTest=If[Length[Complement[invalidConflictingContainerInputs, simulatedSamples]] > 0,
				Test["The samples "<>ObjectToString[Complement[invalidConflictingContainerInputs, simulatedSamples], Cache->cacheBall]<>" do not have conflicting CollectionContainers set:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		If[Length[invalidConflictingContainerInputs]>0,
			Message[Error::ConflictingCollectionContainers, ObjectToString[invalidConflictingContainerInputs, Cache->cacheBall], conflictingContainerToSpecifiedCollectionContainerMap[[All,2]]];
		];

		{}
	];
	
	(* Check if centrifuge and preparation is matched*)
	mismatchedSamples=If[roboticPritimitveQ,
		PickList[simulatedSamples,suppliedInstrumentModel,Except[Alternatives@@$OnDeckCentrifuges|Automatic]]
	];
	mismatchedInstruments=If[roboticPritimitveQ,
		PickList[suppliedInstrument,suppliedInstrumentModel,Except[Alternatives@@$OnDeckCentrifuges|Automatic]],
		PickList[suppliedInstrument,suppliedInstrumentModel,Alternatives@@$OnDeckCentrifuges|Automatic]
	];
	
	(* build a checker for this mis match*)
	misMatchedInstrumentPreparationQ=(Length[mismatchedSamples]>0);
	
	(* Throw messages*)
	mismatchedCentrifugeOptions=If[misMatchedInstrumentPreparationQ,
		Message[Error::CentrifugeAndPreparationMismatched,ObjectToString[mismatchedSamples],ObjectToString[mismatchedInstruments]];;{Instrument,Preparation},
		{}
	
	];

	
	
	(* Build tests *)
	mismatchedCentrifugeTests=If[gatherTests,
		Test["All specified instruments "<>ObjectToString[suppliedInstrument]<>" are compatible with Preparation:",(Length[mismatchedSamples]==0),True],
		{}
	];
	
	
	(* Call CentrifugeDevices to get the centrifuge models (and corresponding container models) that would work for each option set.
		If we're doing robotic, we can't ever transfer automatically anyway so just get the stuff for the samples
		If we're doing manual, we can also transfer into the PreferredContainers so add those here
		Importantly, we are NOT collecting _all_ centrifugable containers because that would be silly and time consuming and not a thing that we let slow us down for 5+ years *)
	(* get the input samples as container models. Note that if we don't have a container because of discarded sample, we give a default value of 2mL tube just for resolver purposes (CentrifugeDevices won't be happy with Null input) *)
	inputContainerModels = Lookup[sampleContainerModelPackets,Object,Model[Container, Vessel, "id:3em6Zv9NjjN8"]];
	centrifugesAndContainersByOptionSet = If[MatchQ[resolvedPreparation, Robotic],
		Module[{compatibleCentrifuges, centrifugesToContainerRules, mergedCentrifugesToContainerRules},

			compatibleCentrifuges = CentrifugeDevices[
				inputContainerModels,
				Time->specifiedTimes,
				Temperature->resolvedTemperature/.{Ambient -> $AmbientTemperature},
				Intensity->specifiedIntensities,
				CollectionContainer->resolvedCollectionContainers,
				Preparation->resolvedPreparation,
				WorkCell->Lookup[myOptions,WorkCell,Automatic],
				Cache->cacheBall,
				Simulation -> updatedSimulation
			];

			(* make the rules correlating all the centrifuges to each container *)
			centrifugesToContainerRules = MapThread[
				Function[{containerModel, centrifuges},
					Map[
						# -> containerModel&,
						centrifuges
					]
				],
				{inputContainerModels, compatibleCentrifuges}
			];

			(* merge them together without dupes to get rules for each centrifuge -> its containers, and return as a list of pairs instead of as an association *)
			mergedCentrifugesToContainerRules = Merge[#, DeleteDuplicates]& /@ centrifugesToContainerRules;

			Map[
				Function[{centrifugeAndContainers},
					KeyValueMap[
						{#1, #2}&,
						centrifugeAndContainers
					]
				],
				mergedCentrifugesToContainerRules
			]

		],
		(* this logic is mirroring what CentrifugeDevices itself does to add the extra preferred containers and make sure the options are correctly index matching *)
		Module[
			{allPreferredContainers, expandedTimeByContainer, expandedTemperatureByContainer, expandedContainers,
			expandedIntensityByContainer, expandedCollectionContainerByContainer, containerOptionSets, uniqueOptionSets,
			uniqueContainers, uniqueTimes, uniqueTemperatures, uniqueIntensity, uniqueCollectionContainer, compatibleCentrifuges,
			centrifugesToContainerRules, mergedCentrifugesToContainerRules, optionSetToCompatibleCentrifuges,
			optionSetsPerInput, centrifugesByOptionsByContainer, allCentrifugableContainers},

			(* get all the containers that we could aliquot into *)
			allPreferredContainers = DeleteDuplicates@Flatten[{
				PreferredContainer[All, Type -> All],
				PreferredContainer[All, UltracentrifugeCompatible -> True]
			}];

			(* filter allPreferredContainers and select only Container has CentrifugeableFootprintP *)
			allCentrifugableContainers = Module[{centrifugableContainerQs},
				centrifugableContainerQs = MemberQ[CentrifugeableFootprintP, fastAssocLookup[fastAssoc, #, Footprint]]& /@ allPreferredContainers;
				PickList[allPreferredContainers, centrifugableContainerQs]
			];

			(* expand the containers and options in question *)
			expandedContainers = Map[
				Flatten[{#, allCentrifugableContainers}]&,
				inputContainerModels
			];
			{expandedTimeByContainer, expandedTemperatureByContainer, expandedIntensityByContainer, expandedCollectionContainerByContainer} = Map[
				(* doing Length[allPreferredContainers] + 1 because we are taking all the preferred containers and also the input container for each sample *)
				Flatten[Transpose[ConstantArray[#,Length[allCentrifugableContainers]+1]],1]&,
				{specifiedTimes, resolvedTemperature, specifiedIntensities,resolvedCollectionContainers}
			];

			(* remove duplicates *)
			containerOptionSets = Transpose[{
				Flatten[expandedContainers],
				Flatten[expandedTimeByContainer],
				Flatten[expandedTemperatureByContainer],
				Flatten[expandedIntensityByContainer],
				Flatten[expandedCollectionContainerByContainer]
			}];
			uniqueOptionSets = DeleteDuplicates[containerOptionSets];
			{uniqueContainers, uniqueTimes, uniqueTemperatures, uniqueIntensity, uniqueCollectionContainer} = Transpose[uniqueOptionSets];

			(* get the compatible centrifuges *)
			compatibleCentrifuges = CentrifugeDevices[
				uniqueContainers,
				Time -> uniqueTimes,
				Temperature -> uniqueTemperatures /. {Ambient -> $AmbientTemperature},
				Intensity -> uniqueIntensity,
				CollectionContainer -> uniqueCollectionContainer,
				Preparation -> resolvedPreparation,
				WorkCell -> Lookup[myOptions, WorkCell, Automatic],
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			];

			(* Order the centrifuge devices result by the original expanded option sets by using rules that relate each original set and each result to its index in the unique sets *)
			optionSetToCompatibleCentrifuges = AssociationThread[uniqueOptionSets, compatibleCentrifuges];
			optionSetsPerInput = containerOptionSets /. optionSetToCompatibleCentrifuges;

			(* Partition the result to reflect the centrifuges for each option set for each possible container *)
			centrifugesByOptionsByContainer = TakeList[optionSetsPerInput,Length /@ expandedContainers];

			(* make the rules correlating all the centrifuges to each container *)
			centrifugesToContainerRules = MapThread[
				Function[{allCentrifuges, allContainers},
					Flatten[MapThread[
						Function[{centrifuges, containerModel},
							# -> containerModel& /@ centrifuges
						],
						{allCentrifuges, allContainers}
					]]
				],
				{centrifugesByOptionsByContainer, expandedContainers}
			];

			(* merge them together without dupes to get rules for each centrifuge -> its containers, and return as a list of pairs instead of as an association *)
			mergedCentrifugesToContainerRules = Map[
				Merge[#, DeleteDuplicates]&,
				centrifugesToContainerRules
			];

			Map[
				Function[{centrifugeAndContainers},
					KeyValueMap[
						{#1, #2}&,
						centrifugeAndContainers
					]
				],
				mergedCentrifugesToContainerRules
			]
		]
	];

	(* If centrifuge was specified as an object, get the corresponding model.(Automatics remain Automatic.) *)
	specifiedCentrifugeAsModel = Map[
		Switch[#,
			ObjectP[Object[Instrument,Centrifuge]],Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[#,Object],Model->_}]],Model],Object],
			ObjectP[Model[Instrument,Centrifuge]],Download[#,Object],
			Automatic,#
		]&,specifiedCentrifuges];

	(* For each sample, figure out which centrifuge(s) can be used, the target container as far as we know at this point, and whether we need to throw errors related to being able to find a centrifuge that will work *)
	{semiResolvedCentrifuges, semiResolvedTargetContainers, incompatibleCentrifugeBools, noCentrifugeFoundBools, noTransferFoundBools,cantTransferRoboticBools} = Transpose[MapThread[
		Function[{centrifugeOption,centrifugeOptionModel, compatibleCentrifugesAndContainers,samplePacket,currentContainerPacket,rotorModel},

			Which[
				(* If the sample is discarded, it won't have a container, but we still need to handle it.
				Return Null as the centrifuge and target container, and don't throw any errors (we are already throwing one for the sample being discarded). *)
				MatchQ[currentContainerPacket,<||>],
				{Null,Null,False,False,False,False},

				(* If they specified a centrifuge that is NOT on the list of centrifuges that would work with the settings,
				use that centrifuge, but we will also throw IncompatibleCentrifuge and InvalidOption Errors/Test.
				Don't throw the no centrifuge found error since it is irrelevant to this case. TargetContainer is the current sample container. *)
				MatchQ[centrifugeOption,ObjectP[]] && !MemberQ[compatibleCentrifugesAndContainers[[All,1]],centrifugeOptionModel],
				{centrifugeOption,Lookup[currentContainerPacket,Object],True,False,False,False},

				(* If they specified a centrifuge that IS on the list AND the container that the sample is in will work with the desired centrifuge,
				use that centrifuge. TargetContainer is the current sample container. No errors will be thrown. *)
				MatchQ[centrifugeOption,ObjectP[]] && MemberQ[FirstCase[compatibleCentrifugesAndContainers, {centrifugeOptionModel, _}][[2]], Download[Lookup[currentContainerPacket,Model],Object]],
				{centrifugeOption,Lookup[currentContainerPacket,Object],False,False,False,False},

				(* If they specified a centrifuge that IS on the list but the container is NOT in a container that will work with the desired centrifuge,
				use that centrifuge and try to find an appropriate transfer container. *)
				MatchQ[centrifugeOption,ObjectP[]],
				Module[{compatibleContainers,maxVolumes,fittingContainerVolumePairs,sortedFittingContainersByVolume,transferContainer,ultracentrifugeQ,rotorCompatibleContainers,containerFootprints,rotorFootprint,roboticCantTransfer},

					(* Get all of the containers that are compatible with the desired centrifuge *)
					compatibleContainers=LastOrDefault[FirstCase[compatibleCentrifugesAndContainers, {centrifugeOptionModel, _}]];

					(* Then get all of the containers that are compatible with the desired rotor *)
					(* If rotor is not specified, then go with all compatibleContainers for the centrifuge *)
					(* Otherwise, find the rotor compatible containers based on container footprint *)
					containerFootprints=Lookup[fetchPacketFromFastAssoc[#,fastAssoc],Footprint]&/@compatibleContainers;
					rotorFootprint=If[MatchQ[rotorModel,ObjectP[]],
						First[
							Lookup[
								Lookup[fetchPacketFromFastAssoc[rotorModel,fastAssoc],Positions],
								Footprint
							]
						],
						Null
					];

					rotorCompatibleContainers=If[MatchQ[rotorModel,Automatic],
						compatibleContainers,
         				Pick[compatibleContainers,containerFootprints,rotorFootprint]
					];

					(* Get the max volume of all of the compatible containers *)
					maxVolumes = Map[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->#,MaxVolume->_}]],MaxVolume]&,rotorCompatibleContainers];

					(* Get all of the compatible containers (along with their volume) that can fit the current sample volume *)
					fittingContainerVolumePairs=Select[Transpose[{rotorCompatibleContainers,maxVolumes}], (#[[2]] >= Lookup[samplePacket,Volume]) &];

					(* Sort the containers that can fit the current sample in order of container size (smallest to largest) *)
					sortedFittingContainersByVolume = SortBy[fittingContainerVolumePairs, Last][[All,1]];

					(* Find the smallest container that can fit the sample that matches the current container type and is a preferred container.
					If this is not possible, find the smallest container (any type) that can fit the sample and is a preferred container.
						If this still is not possible, Null*)

					(* Before finding the preferred container, first check if the centrifuge of interest is an ultracentrifuge, whose preferred container is different *)
					ultracentrifugeQ = Lookup[fetchPacketFromFastAssoc[#, fastAssoc], CentrifugeType] &/@(compatibleCentrifugesAndContainers[[All,1]]);
					transferContainer = Module[{preferredTransferContainers, centrifugableContainers},
						preferredTransferContainers = Which[
							MatchQ[Lookup[currentContainerPacket, Type], Object[Container, Plate]| Object[Container, Plate, Filter]],
								PreferredContainer[All, Type -> Plate, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])],
							MatchQ[Lookup[currentContainerPacket, Type], Object[Container, Vessel] | Object[Container, Vessel, Filter]],
								PreferredContainer[All, Type -> Vessel, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])],
							True,
								(* For other container types like Object[Container, Plate, Irregular] or Object[Container, ReactionVessel] use this condition *)
								PreferredContainer[All, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])]
						];
						(* filter preferredTransferContainers and select only Container has CentrifugeableFootprintP *)
						centrifugableContainers = PickList[preferredTransferContainers, MemberQ[CentrifugeableFootprintP, fastAssocLookup[fastAssoc, #, Footprint]]& /@ preferredTransferContainers];
						(* If the rotor compatible container model sorted by volume consists of the centrifugableContainers, use first of it, otherwise use any preferred container in the list *)
						If[MemberQ[sortedFittingContainersByVolume, Alternatives @@ centrifugableContainers],
							FirstCase[sortedFittingContainersByVolume, Alternatives @@ centrifugableContainers],
							(* If no compatible container can be found to transfer the sample into, return Null *)
							FirstCase[sortedFittingContainersByVolume, Alternatives @@ PreferredContainer[All], Null]
						]
					];
					(*if we are robotic and we need to transfer, then that is an error because we can't auto-transfer using robotic *)
					roboticCantTransfer=If[Not[NullQ[transferContainer]]&&roboticPritimitveQ,True,False ];
					(* If the sample cannot fit into any of the containers that would work with the desired centrifuge,
						throw NoValidTransfer/InvalidInput errors/test and use the current container as the transfer container.
						If a container was found that the sample could be transferred into in order to fit on the desired centrifuge,
						set the transfer container to that container, and don't throw any errors. In either case, use the user-specified centrifuge option *)
					{centrifugeOption,If[NullQ[transferContainer],Lookup[currentContainerPacket,Object],transferContainer],False,False,NullQ[transferContainer],roboticCantTransfer}
				],

				(* If centrifuge was Automatic and no compatible centrifuges were found, throw NoCompatibleCentrifuge and InvalidOption Errors/Test, and use Null. TargetContainer is the current sample container. *)
				MatchQ[compatibleCentrifugesAndContainers,{}],
				{Null,Lookup[currentContainerPacket,Object],False,True,False,False},

				(* If centrifuge was Automatic and compatible centrifuges were found that will work with the sample in its current container,
				 use the centrifuge(s) that will work with the current container. TargetContainer is the current sample container and no errors will be thrown. *)
				MemberQ[Flatten[compatibleCentrifugesAndContainers[[All, 2]]], Download[Lookup[currentContainerPacket,Model],Object]],
				{Select[compatibleCentrifugesAndContainers,MemberQ[#[[2]], Download[Lookup[currentContainerPacket,Model],Object]] &][[All, 1]],Lookup[currentContainerPacket,Object],False,False,False,False},

				(* If centrifuge was Automatic and no compatible centrifuges were found that will work with the sample in its current container,
				see if we can transfer into a container that would work. *)
				True,
				Module[{compatibleContainers,maxVolumes,fittingContainerVolumePairs,sortedFittingContainersByVolume,transferContainer,centrifuges,ultracentrifugeQ,containerFootprints,rotorFootprint,rotorCompatibleContainers,roboticCantTransfer},

				(* Get all of the containers that are compatible with the centrifuges that are compatible with the settings *)
					compatibleContainers=DeleteDuplicates[Flatten[compatibleCentrifugesAndContainers[[All, 2]]]];

					(* Then get all of the containers that are compatible with the desired rotor *)
					(* If rotor is not specified, then go with all compatibleContainers for the centrifuge *)
					(* Otherwise, find the rotor compatible containers based on container footprint *)
					containerFootprints=Lookup[fetchPacketFromFastAssoc[#,fastAssoc],Footprint]&/@compatibleContainers;
					rotorFootprint=If[MatchQ[rotorModel,ObjectP[]],
						First[
							Lookup[
								Lookup[fetchPacketFromFastAssoc[rotorModel,fastAssoc],Positions],
								Footprint
							]
						],
						Null
					];

					rotorCompatibleContainers=If[MatchQ[rotorModel,Automatic],
						compatibleContainers,
						Pick[compatibleContainers,containerFootprints,rotorFootprint]
					];

					(* Get the max volume of all of the compatible containers *)
					maxVolumes = Map[
						Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->#,MaxVolume->_}]],MaxVolume]&,
						rotorCompatibleContainers
					];

					(* Get all of the compatible containers (along with their volume) that can fit the current sample volume *)
					fittingContainerVolumePairs=Select[Transpose[{rotorCompatibleContainers,maxVolumes}], (#[[2]] >= Lookup[samplePacket,Volume]) &];

					(* Sort the containers that can fit the current sample in order of container size (smallest to largest) *)
					sortedFittingContainersByVolume = SortBy[fittingContainerVolumePairs, Last][[All,1]];

					(* Find the smallest container that can fit the sample that matches the current container type and is a preferred container.
					If this is not possible, find the smallest container (any type) that can fit the sample and is a preferred container.
						If this still is not possible, Null*)

					(* Before finding the preferred container, first check if the centrifuge of interest is an ultracentrifuge, whose preferred container is different *)
					ultracentrifugeQ = Lookup[fetchPacketFromFastAssoc[#, fastAssoc], CentrifugeType] &/@(compatibleCentrifugesAndContainers[[All,1]]);
					transferContainer = Module[{preferredTransferContainers, centrifugableContainers},
						preferredTransferContainers = Which[
							MatchQ[Lookup[currentContainerPacket, Type], Object[Container, Plate]| Object[Container, Plate, Filter]],
								PreferredContainer[All, Type -> Plate, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])],
							MatchQ[Lookup[currentContainerPacket, Type], Object[Container, Vessel] | Object[Container, Vessel, Filter]],
								PreferredContainer[All, Type -> Vessel, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])],
							True,
								(* For other container types like Object[Container, Plate, Irregular] or Object[Container, ReactionVessel] use this condition *)
								PreferredContainer[All, UltracentrifugeCompatible -> (Automatic/.If[MatchQ[ultracentrifugeQ, {Ultra}], {Automatic -> True}, {}])]
						];
						(* filter preferredTransferContainers and select only Container has CentrifugeableFootprintP *)
						centrifugableContainers = PickList[preferredTransferContainers, MemberQ[CentrifugeableFootprintP, fastAssocLookup[fastAssoc, #, Footprint]]& /@ preferredTransferContainers];
						(* If the rotor compatible container model sorted by volume consists of the centrifugableContainers, use first of it, otherwise use any preferred container in the list *)
						If[MemberQ[sortedFittingContainersByVolume, Alternatives @@ centrifugableContainers],
							FirstCase[sortedFittingContainersByVolume, Alternatives @@ centrifugableContainers],
							(* If no compatible container can be found to transfer the sample into, return Null *)
							FirstCase[sortedFittingContainersByVolume, Alternatives @@ PreferredContainer[All], Null]
						]
					];
					(*if we are robotic and we need to transfer, then that is an error because we can't auto-transfer using robotic *)
					roboticCantTransfer=If[Not[NullQ[transferContainer]]&&roboticPritimitveQ,True,False ];

					(* Find the centrifuge(s) that will work with the transfer container. (If no centrifuges were found (because transferContainer is Null, change the resulting {} to Null) *)
					centrifuges=Select[compatibleCentrifugesAndContainers,MemberQ[#[[2]], transferContainer] &][[All,1]]/.{}->Null;

					(* If the sample cannot fit into any of the containers that would work with the settings-compatible centrifuges,
						throw NoValidTransfer/InvalidInput errors/test and use Null as the centrifuge and the current container as the transfer container.
						If a container was found that the sample could be transferred into to fit on one of the settings-compatible centrifuges,
						use the centrifuge(s) that are compatible with that container, set the transfer container to that container, and don't throw any errors. *)
					{centrifuges,If[NullQ[transferContainer],Lookup[currentContainerPacket,Object],transferContainer],False,False,NullQ[transferContainer],roboticCantTransfer}
				]
			]
		],{specifiedCentrifuges,specifiedCentrifugeAsModel,centrifugesAndContainersByOptionSet,samplePackets,sampleContainerPackets,suppliedRotorModel}]];


	(* -- Deal with any errors related to centrifuge not being able to reach the Time/Temperature/Intensity -- *)

	(* Store the invalid options due to the specified centrifuge not being able to reach the Time/Temperature/Intensity. (Only give the option symbols if the option is not Automatic at indexes corresponding to this error.) *)
	centrifugeInvalidOptions=PickList[{Instrument,Intensity, Time, Temperature}, {PickList[specifiedCentrifuges, incompatibleCentrifugeBools],PickList[specifiedIntensities, incompatibleCentrifugeBools], PickList[specifiedTimes, incompatibleCentrifugeBools], PickList[resolvedTemperature, incompatibleCentrifugeBools]}, Except[{} | {Automatic ..}]];

	(* If the user specified a centrifuge that will not work with the specified Time/Temperature/Intensity options and we are throwing messages, throw an error message .*)
	(* But if instrument and preparation is mismatched, skip this error message because this was checked before *)
	
	If[MemberQ[incompatibleCentrifugeBools,True]&&!gatherTests&&!misMatchedInstrumentPreparationQ,
		If[MemberQ[PickList[resolvedCollectionContainers,incompatibleCentrifugeBools],ObjectP[]],
			(* Provide more specific error messages if we have collection container because that can be the issue for going beyond MaxStackHeight *)
			Message[
				Error::IncompatibleCentrifuge,
				ObjectToString[PickList[inputContainerModels,incompatibleCentrifugeBools]],
				" with the collection containers " <> ObjectToString[PickList[resolvedCollectionContainers,incompatibleCentrifugeBools]],
				ObjectToString[PickList[specifiedIntensities,incompatibleCentrifugeBools]],
				ObjectToString[PickList[resolvedTemperature,incompatibleCentrifugeBools]],
				ObjectToString[PickList[specifiedTimes,incompatibleCentrifugeBools]],
				ObjectToString[PickList[specifiedCentrifuges,incompatibleCentrifugeBools], Cache->cacheBall],
				"shorter filter and collection container stacks with "
			],
			Message[
				Error::IncompatibleCentrifuge,
				ObjectToString[PickList[inputContainerModels,incompatibleCentrifugeBools]],
				"",
				ObjectToString[PickList[specifiedIntensities,incompatibleCentrifugeBools]],
				ObjectToString[PickList[resolvedTemperature,incompatibleCentrifugeBools]],
				ObjectToString[PickList[specifiedTimes,incompatibleCentrifugeBools]],
				ObjectToString[PickList[specifiedCentrifuges,incompatibleCentrifugeBools], Cache->cacheBall],
				""
			]
		]
	];

	(* If the user specified a centrifuge that will not work with the specified Time/Temperature/Intensity options and we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	centrifugeCompatibleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[incompatibleCentrifugeBools,True],
				Test["The specified Centrifuge "<>ObjectToString[PickList[specifiedCentrifuges,incompatibleCentrifugeBools], Cache->cacheBall]<>" is compatible with the specified Time, Temperature, and Intensity:",True,False],
				Nothing
			];

			passingTest=If[MemberQ[incompatibleCentrifugeBools,False],
				Test["The specified Centrifuge "<>ObjectToString[PickList[specifiedCentrifuges,incompatibleCentrifugeBools,False], Cache->cacheBall]<>" is compatible with the specified Time, Temperature, and Intensity:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Deal with any errors related to no centrifuge being able to meet the desired Time/Temperature/Intensity -- *)

	(* Store the invalid options no centrifuge being able to meet the desired Time/Temperature/Intensity. (Only give the option symbols if the option is not Automatic at indexes corresponding to this error.) *)
	noCentrifugeFoundInvalidOptions=PickList[{Intensity, Time, Temperature}, {PickList[specifiedIntensities, noCentrifugeFoundBools], PickList[specifiedTimes, noCentrifugeFoundBools], PickList[resolvedTemperature, noCentrifugeFoundBools]}, Except[{} | {Automatic ..}]];

	(* If the user specified Time/Temperature/Intensity options for which no centrifuge could be found and we are throwing messages, throw an error message .*)
	If[MemberQ[noCentrifugeFoundBools,True]&&!gatherTests,
		Message[Error::NoCompatibleCentrifuge, ObjectToString[PickList[specifiedIntensities,noCentrifugeFoundBools]], ObjectToString[PickList[resolvedTemperature,noCentrifugeFoundBools]], ObjectToString[PickList[specifiedTimes,noCentrifugeFoundBools]], resolvedPreparation]
	];

	(* If the user specified Time/Temperature/Intensity options and we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noCentrifugeFoundTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[noCentrifugeFoundBools,True],
				Test["A centrifuge could be found that meets the specified Time, Temperature, and Intensity options "<> ObjectToString[{PickList[specifiedIntensities,noCentrifugeFoundBools], PickList[resolvedTemperature,noCentrifugeFoundBools], PickList[specifiedTimes,noCentrifugeFoundBools]}]<>":",True,False],
				Nothing
			];

			passingTest=If[MemberQ[noCentrifugeFoundBools,False],
				Test["A centrifuge could be found that meets the specified Time, Temperature, and Intensity options "<> ObjectToString[{PickList[specifiedIntensities,noCentrifugeFoundBools,False], PickList[resolvedTemperature,noCentrifugeFoundBools,False], PickList[specifiedTimes,noCentrifugeFoundBools,False]}]<>":",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Deal with any errors related to no target container being found for samples that need to be transferred -- *)

	(* Store the invalid inputs due to no target container being found *)
	noTransferContainerInvalidInputs = PickList[simulatedSamples,noTransferFoundBools];

	(* Store the invalid inputs due to samples not being able to be moved to another container when the protocol is done Robotically *)
	cantTransferContainerRoboticInvalidInputs=PickList[simulatedSamples,cantTransferRoboticBools];

	(* If we need to transfer but we can't because we are in Robotic, then throw an error *)
	If[MemberQ[cantTransferRoboticBools,True]&&!gatherTests,
		Message[Error::ContainerCentrifugeIncompatibleRobotic, ObjectToString[PickList[simulatedSamples,cantTransferRoboticBools],Cache->cacheBall],ObjectToString[PickList[semiResolvedCentrifuges,cantTransferRoboticBools],Cache->cacheBall]]
	];

	(* If the sample needs to be transferred to a container, but no appropriate container could be found, throw an error*)
	If[MemberQ[noTransferFoundBools,True]&&!gatherTests,
		Message[Error::NoTransferContainerFound, ObjectToString[PickList[simulatedSamples,noTransferFoundBools], Cache->cacheBall]]
	];

	(* If the user specified a centrifuge that will not work with the specified Time/Temperature/Intensity options and we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noTransferContainerTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[noTransferFoundBools,True],
				Test["A transfer container was found for the samples that must be transferred  "<>ObjectToString[PickList[simulatedSamples,noTransferFoundBools], Cache->cacheBall]<>":",True,False],
				Nothing
			];

			passingTest=If[MemberQ[noTransferFoundBools,False],
				Test["A transfer container was found for the samples that must be transferred  "<>ObjectToString[PickList[simulatedSamples,semiResolvedTargetContainers,ObjectP[Model[Container]]], Cache->cacheBall]<>":",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- From the list of centrifuge(s) that will work for each input, choose one centrifuge for each input,
	optimizing to use as few different centrifuges as possible. --- *)

	(* Get all of the semi-resolved centrifuges into the corresponding models. We don't care about preserving the list structure here. *)
	semiResolvedCentrifugesAsModel = Map[
		Switch[#,
			ObjectP[Object[Instrument,Centrifuge]],Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[#,Object],Model->_}]],Model],Object],
			ObjectP[Model[Instrument,Centrifuge]],Download[#,Object],
			Automatic|Null,#
		]&,Flatten[semiResolvedCentrifuges]];

	(* Count how many times each centrifuge model appears in the flat semi-resolved centrifuge model list *)
	centrifugeModelCounts = Tally[Flatten[semiResolvedCentrifugesAsModel]];

	(* Get the centrifuge models in order of frequency that they appear in the semi-resolved list. If one centrifuge has the same frequency, we may use any one of that. *)
	(* For example, if we get an instrument list {1,1,2,2,2,3,3}, we will get a sorted list like {{2},{1,3}} so 1 and 3 are at the same frequency level in the list. *)
	centrifugesByFrequency = Map[
		#[[All,1]]&,
		GatherBy[Reverse[SortBy[centrifugeModelCounts, Last]],Last]
	];

	(* For any centrifuge options that were semi-resolved to a list, choose the centrifuge on the list that appears most
	frequently among the models of all of the potential centrifuge resolutions.(If the centrifuge is semi-resolved to a list, it will be a list of models.)
	If the centrifuge option is a single (meaning it was specified), just use that centrifuge. *)
	(* When some instruments have the same frequency, their will still be a list here *)
	resolvedCentrifugeLists = Map[Function[currentCentrifuge,
		If[MatchQ[currentCentrifuge, {ObjectP[]..}],
			Intersection[
				FirstCase[centrifugesByFrequency, _?(IntersectingQ[currentCentrifuge, #]&)],
				currentCentrifuge
			],
			currentCentrifuge
		]], semiResolvedCentrifuges];

	(* Get all of the resolved centrifuges into the corresponding models. *)
	resolvedCentrifugesAsModelLists = Map[
		Function[
			{centrifugeList},
			Which[
				(* Single Centrifuge Object *)
				MatchQ[centrifugeList,ObjectP[Object[Instrument,Centrifuge]]],
				Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[centrifugeList,Object],Model->_}]],Model],Object],
				(* Single Centrifuge Model *)
				MatchQ[centrifugeList,ObjectP[Model[Instrument,Centrifuge]]],
				Download[centrifugeList,Object],
				(* List of Objects *)
				MatchQ[centrifugeList,{ObjectP[]..}],
				(* Get the model of every single object in the list *)
				Map[
					If[MatchQ[#,ObjectP[Object[Instrument,Centrifuge]]],
						Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[#,Object],Model->_}]],Model],Object],
						Download[#,Object]
					]&,
					centrifugeList
				],
				True,
				centrifugeList
			]
		],
		resolvedCentrifugeLists
	];

	(* --- Intensity Precision Check (done here since we need to know the container and the centrifuge) --- *)

	(* Get a list of target container models *)
	semiResolvedTargetContainerModels = If[MatchQ[#,ObjectP[Object[Container]]],
		Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[#,Object],Model->_}]],Model],Object],
		#
	]&/@semiResolvedTargetContainers;

	(* We now know the centrifuge that will be used for each sample and the container model that the sample will be in.
	 	From this info, figure out the max radius so that we can convert between rate and force. Also, resolve the final Centrifuge for the samples. This could be a list earlier because of the same frequency *)
	{resolvedCentrifugeModels,resolvedRotors,resolvedBuckets,maxRadii,resolvedRotorAngle,resolvedRotorGeometry,resolvedChilledRotor,noRotorFoundBools}=Transpose@MapThread[
		Function[{containerModel,centrifugeModelList,rotorModelList, rotorAngle, rotorGeometry, chilledRotor},
			Module[
				{containerModelPacket, containerModelFootprint, centrifugeCompatibilities, potentialCentrifugeCompatibility, centrifugeCompatibility, centrifuge, rotor,
					bucket, rotorMaxRadius, bucketMaxRadius,radius,semiResolvedRotorModels, allRotors, allCompatibleRotors, allRotorAngles, allRotorGeometries, incompatibleRotorQ, angle, geometry, chilled,
					centrifugeType, allRotorPackets, potentialCentrifugeCompatibilityConsideringChilledRotor},

				(* Get the packet corresponding to the target container model *)
				containerModelPacket = FirstCase[cacheBall,KeyValuePattern[{Object->containerModel,Footprint->_}],{}];

				(* Look up the container's footprint *)
				containerModelFootprint = Lookup[containerModelPacket, Footprint, Null];

				(* Look up container model's footprint's compatible centrifuge equipment sets *)
				centrifugeCompatibilities = Lookup[footprintCentrifugeEquipmentLookup, containerModelFootprint, {}];

				(* From the compatible sets, collect all rotors *)
				allCompatibleRotors = Cases[Flatten[centrifugeCompatibilities], ObjectP[Model[Container,CentrifugeRotor]]];
				allRotorPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ allCompatibleRotors;

				(* get the compatible rotors based on whether they're chilled or not; if chilledRotor was specified as True then only take ones with DefaultStorageCondition being Model[StorageCondition, "Refrigerator"] *)
				(* if it was specified to False, deliberately exclude Refrigerator ones *)
				(* otherwise, take everything *)

				(* Fish out RotorAngle and RotorGeometry information from the cache for all compatible rotors *)
				{allRotorAngles, allRotorGeometries} = If[!MatchQ[allCompatibleRotors, {}],
					Transpose[
						Lookup[fetchPacketFromFastAssoc[#, fastAssoc], {RotorAngle,RotorType}]&/@allCompatibleRotors
					],
					{{},{}}
				];

				(* Then we resolve the rotors based on other rotor parameters *)
				(* If the rotor is specified, then go with user specified object *)
				semiResolvedRotorModels = If[MatchQ[rotorModelList, ObjectP[Model[Container,CentrifugeRotor]]],

					rotorModelList,

					(* If rotor is not specified, then we have to resolve rotor based on RotorAngle and RotorGeometry *)
					Which[
						(* First case: both RotorAngle and RotorGeometry are specified *)
						MatchQ[{rotorAngle,rotorGeometry}, {Except[Automatic|Null], Except[Automatic|Null]}],
							Intersection[
								PickList[allCompatibleRotors, allRotorAngles, rotorAngle],
								PickList[allCompatibleRotors, allRotorGeometries, (rotorGeometry/.{FixedAngleRotor->FixedAngle,SwingingBucketRotor->SwingingBucket})]
							],

						(* Second case: only RotorAngle is specified *)
						MatchQ[{rotorAngle,rotorGeometry}, {Except[Automatic|Null], Automatic|Null}],
							PickList[allCompatibleRotors, allRotorAngles, rotorAngle],

						(* Third case: only RotorGeometry is specified *)
						MatchQ[{rotorAngle,rotorGeometry}, {Automatic|Null, Except[Automatic|Null]}],
							PickList[allCompatibleRotors, allRotorGeometries, (rotorGeometry/.{FixedAngleRotor->FixedAngle,SwingingBucketRotor->SwingingBucket})],

						(* Final case: neither option is specified *)
						True,
							allCompatibleRotors
					]
				];

				(* Extract the best entry that corresponds to the instrument model that will be used *)
				(* Extract the entry that corresponds to the instrument model that will be used *)
				potentialCentrifugeCompatibility = If[MatchQ[semiResolvedRotorModels, ListableP[ObjectP[Model[Container, CentrifugeRotor]]]],
					Select[centrifugeCompatibilities, And[MemberQ[#, ObjectP[centrifugeModelList]], MemberQ[#, ObjectP[semiResolvedRotorModels]]]&],
					Select[centrifugeCompatibilities, MemberQ[#, ObjectP[centrifugeModelList]]&]
				];

				(* if ChilledRotor is set to True, then delete all the potential centrifuge compatibilities that don't have chilled rotors *)
				(* if ChilledRotor is set to False, then delete all potential centrifuge compatibilities that have chilled rotors *)
				(* if ChilledRotor is Null or Automatic, don't do anything here *)
				potentialCentrifugeCompatibilityConsideringChilledRotor = Switch[chilledRotor,
					True,
						Select[
							potentialCentrifugeCompatibility,
							With[{potentialRotor = FirstCase[#, ObjectP[Model[Container, CentrifugeRotor]], Null]},
								MatchQ[fastAssocLookup[fastAssoc, potentialRotor, DefaultStorageCondition], ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]]]  (* this ID is for Model[StorageCondition, "Refrigerator"] *)
							]&
						],
					False,
						Select[
							potentialCentrifugeCompatibility,
							With[{potentialRotor = FirstCase[#, ObjectP[Model[Container, CentrifugeRotor]], Null]},
								Not[MatchQ[fastAssocLookup[fastAssoc, potentialRotor, DefaultStorageCondition], ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]]]]  (* this ID is for Model[StorageCondition, "Refrigerator"] *)
							]&
						],
					Null | Automatic, potentialCentrifugeCompatibility
				];

				(* Default to the one that has least layers of equipment - rotor/bucket/adapters for our experiment. *)
				centrifugeCompatibility = FirstOrDefault[
					SortBy[
						(* Extract the entry that corresponds to the instrument model that will be used *)
						potentialCentrifugeCompatibilityConsideringChilledRotor,
						(* Sort the entries to get the shortest length to be the first one *)
						Length[Cases[#,ObjectP[Model[Part,CentrifugeAdapter]]]]&
					],
					(* Default to empty list so that we can get rotor/bucket and adapters out of it *)
					{}
				];

				(* Get the centrifuge, rotor and bucket that would be used with this centrifuge/container combo, for robotic primitive, resovl*)
				(* after we get centrifuge though we need to resolve ChilledRotor first *)
				centrifuge = FirstCase[centrifugeCompatibility, ObjectP[Model[Instrument, Centrifuge]], Null];

				(* Get centrifuge type of the resolved centrifuge so that we can corrected assign ChilledRotor values *)
				centrifugeType = If[!NullQ[centrifuge],
					fastAssocLookup[fastAssoc, centrifuge, CentrifugeType],
					Null
				];

				(* pick out the first rotor from the centrifuge we selected *)
				rotor = If[MatchQ[semiResolvedRotorModels,{}],
					Null,
					FirstCase[centrifugeCompatibility, ObjectP[Model[Container, CentrifugeRotor]], Null]
				];

				(* resolve ChilledRotor *)
				(* if it's set, then just go with that *)
				(* if it's Automatic and we're Ultra, then check whether the resolved Rotor is chilled or not *)
				(* if it's Automatic otherwise (or already Null), then it's Null *)
				chilled = Switch[{chilledRotor, centrifugeType},
					{BooleanP, _}, chilledRotor,
					{Automatic, Ultra}, MatchQ[fastAssocLookup[fastAssoc, rotor, DefaultStorageCondition], ObjectP[Model[StorageCondition, "id:N80DNj1r04jW"]]], (* this ID is for Model[StorageCondition, "Refrigerator"] *)
					{Automatic|Null, _}, Null
				];

				bucket = If[MatchQ[semiResolvedRotorModels,{}],
					Null,
					FirstCase[centrifugeCompatibility, ObjectP[Model[Container, CentrifugeBucket]], Null]
				];

				(* Error tracking variable for incompatible rotors *)
				incompatibleRotorQ = Not[MatchQ[centrifuge, {}|Null|{Null}]] && MatchQ[semiResolvedRotorModels, {}|Null|{Null}];

				(* Get the rotor angle and geometry from the resolved rotor *)
				angle = If[!NullQ[rotor],
					Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc], RotorAngle],
					Null
				];
				geometry = If[!NullQ[rotor],
					Lookup[fetchPacketFromFastAssoc[rotor, fastAssoc], RotorType]/.{FixedAngle->FixedAngleRotor,SwingingBucket->SwingingBucketRotor},
					Null
				];



				(* Get he max radius of the rotor and bucket *)
				{rotorMaxRadius, bucketMaxRadius} = Map[
					fastAssocLookup[fastAssoc, #, MaxRadius] /. {$Failed -> Null}&,
					{rotor, bucket}
				];

				(* If there is a max radius for the bucket, use that as the overall max radius. Otherwise use the max radius of the rotor. If neither has a max radius, the value will be Null. *)
				radius=FirstCase[{bucketMaxRadius,rotorMaxRadius}, DistanceP, Null];

				(* Return the rotor and the bucket for downstream use *)
				{centrifuge,rotor,bucket,radius,angle,geometry,chilled,incompatibleRotorQ}
			]
		],
		{semiResolvedTargetContainerModels,resolvedCentrifugesAsModelLists, suppliedRotorModel, suppliedRotorAngle, suppliedRotorGeometry, suppliedChilledRotor}
	];

	(* -- Deal with any errors related to no rotor being able to meet the desired RotorAngle/RotorGeometry -- *)

	(* Store the invalid options no centrifuge being able to meet the desired Time/Temperature/Intensity. (Only give the option symbols if the option is not Automatic at indexes corresponding to this error.) *)
	noRotorFoundInvalidOptions=PickList[{RotorAngle, RotorGeometry}, {PickList[suppliedRotorAngle, noRotorFoundBools], PickList[suppliedRotorGeometry, noRotorFoundBools]}, Except[{} | {Automatic ..}]];

	(* If the user specified Time/Temperature/Intensity options for which no centrifuge could be found and we are throwing messages, throw an error message .*)
	If[MemberQ[noRotorFoundBools,True]&&!gatherTests,
		Message[Error::NoCompatibleRotor, ObjectToString[PickList[suppliedRotorAngle,noRotorFoundBools]], ObjectToString[PickList[suppliedRotorGeometry,noRotorFoundBools]]]
	];

	(* If the user specified Time/Temperature/Intensity options and we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noRotorFoundTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[noRotorFoundBools,True],
				Test["A rotor could be found that meets the specified RotorAngle and RotorGeometry options "<> ObjectToString[{PickList[suppliedRotorAngle,noRotorFoundBools], PickList[suppliedRotorGeometry,noRotorFoundBools]}]<>":",True,False],
				Nothing
			];

			passingTest=If[MemberQ[noRotorFoundBools,False],
				Test["A rotor could be found that meets the specified  RotorAngle and RotorGeometry options "<> ObjectToString[{PickList[suppliedRotorAngle,noRotorFoundBools,False], PickList[suppliedRotorGeometry,noRotorFoundBools,False]}]<>":",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];
	(* set centrifuge priority *)
	priorityOfCentrifuges = Function[centrifugemodel, FirstPosition[
			(* prefer VSpin if given an option *)
			{Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], (* VSpin *)
			(* the HiG goes second *)
			Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}, (* HiG *)
			centrifugemodel
	]];
	(* Get the final resolvedCentrifuges - This may not be the same as resolvedCentrifugeModels if an object has been provided by the user *)
	(* resolvedCentrifugeLists may be structured as {{centrifuge..}..} or as {centrifuge..}. In the first case resolvedCentrifugeModels will tell us which thing in the inner list we want *)
	resolvedCentrifuges=MapThread[
		Which[
			MatchQ[#1,ObjectP[]],
				#1,
			(* NOTE: In the case of Robotic, we skip the bucket and rotor compatibility checks since they don't apply. *)
			MatchQ[#1,{ObjectP[]..}] && MatchQ[roboticPritimitveQ, True],
				(* sort the list by centrifuge priority to make sure that VSpin comes before HiG *)
				First[SortBy[#1,priorityOfCentrifuges]],
			True,
				#2
		]&,
		{resolvedCentrifugeLists,resolvedCentrifugeModels}
	];

	(* Get all of the resolved centrifuges into the corresponding models. *)
	resolvedCentrifugesAsModels = Map[
		If[MatchQ[#,ObjectP[Object[Instrument,Centrifuge]]],
			Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[#,Object],Model->_}]],Model],Object],
			Download[#,Object]
		]&,
		resolvedCentrifuges
	];
	resolvedWorkCell=Which[
		(*choose user selected workcell if the user selected one *)
		MatchQ[Lookup[myOptions, WorkCell,Automatic], Except[Automatic]], Lookup[myOptions, WorkCell],
		(*if we are doing the protocol by hand, then there is no robotic workcell *)
		MatchQ[resolvedPreparation, Manual], Null,
		(*choose the first workcell that is presented *)
		Length[allowedWorkCells]>0, First[allowedWorkCells],
		(*if none of the above, then the default is the most common workcell, the STAR *)
		True, STAR
	];

	(* Get the model packet corresponding to each resolved centrifuge. *)
	resolvedCentrifugeModelPackets = Map[
		If[NullQ[#],
			<||>,
			fetchPacketFromFastAssoc[#, fastAssoc]
		]&,
		resolvedCentrifugesAsModels
	];
	

	(* Get the resolution of each centrifuge model *)
	centrifugeRateResolutions = Lookup[resolvedCentrifugeModelPackets,SpeedResolution,Null];

	(* If the user supplied a centrifuge intensity, check if we can attain that precision. (We do this check here instead of earlier
	because we won't know what container the sample will be in (in case a transfer is required to fit on the centrifuge)
	and because we don't know the centrifuge until now unless centrifuge was specified. Without knowing both the
	container and centrifuge, we can't convert between force and rate to do the precision check.) *)
	{roundedIntensities, intensityPrecisionValidBools} = Transpose[MapThread[Function[{intensity,maxRadius,resolution,centrifuge},
		Which[

		(* If intensity is Automatic or if we couldn't resolve the centrifuge due to invalid input,
		keep the value as is and set the precision validity bool as True *)
			MatchQ[intensity,Automatic] || NullQ[centrifuge],
			{intensity,True},

		(* If intensity is specified as a rate and the rate is attainable at the centrifuge precision,
			keep the value as is and set the precision validity bool as True. Otherwise,
			round the value and set the precision validity bool as False *)
			MatchQ[intensity,GreaterP[0 RPM]],
			If[PossibleZeroQ[Mod[intensity,resolution]],
				{intensity,True},
				{Round[intensity,resolution],False}
			],

		(* If we have to convert force to RPM, we can't really do the precision check since the units are different, skip it *)
			True,
			{intensity,True}
		]
	],{specifiedIntensities,maxRadii,centrifugeRateResolutions,resolvedCentrifuges}]];
	(* Update the options with the rounded intensities *)
	optionsWithRoundedIntensity = ReplaceRule[Normal[roundedOptions],Intensity -> roundedIntensities];

	(* If we had to round the intensity, throw a warning *)
	If[MemberQ[intensityPrecisionValidBools,False]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::CentrifugePrecision, ObjectToString[PickList[specifiedIntensities,intensityPrecisionValidBools,False]],ObjectToString[PickList[centrifugeRateResolutions,intensityPrecisionValidBools,False]],ObjectToString[PickList[roundedIntensities,intensityPrecisionValidBools,False]]]
	];

	(* Make warnings regarding intensity precision rounding*)
	intensityPrecisionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[intensityPrecisionValidBools,False],
				Warning["The precision of any user-supplied Intensity options is compatible with instrumental precision:",True,False],
				Nothing
			];

			passingTest=If[MemberQ[intensityPrecisionValidBools,True],
				Warning["The precision of any user-supplied Intensity options is compatible with instrumental precision:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Resolve Intensity --- *)

	(* Get the max rate of each centrifuge model *)
	centrifugeMaxRates = Lookup[resolvedCentrifugeModelPackets,MaxRotationRate,Null];

	(* Get the minimum rate of each centrifuge model *)
	centrifugeMinRates = Lookup[resolvedCentrifugeModelPackets,MinRotationRate,Null];

	(*If Intensity is specified, use it. Otherwise, calculate from 1/5 of the centrifuge max rate (rounded to centrifuge precision)
	and give the result units of force since this is more relevant than rate. (If centrifuge could not be resolved due to invalid input, resolve intensity to Null.) *)
	resolvedIntensities = MapThread[
		Function[{intensity,maxRadius,minRate,maxRate,resolution,centrifuge},
			Which[
				MatchQ[intensity,Except[Automatic]],
					(*if we can, we should convert RPM to G right here, if we are doing robotic *)
					If[Not[NullQ[maxRadius]]&&Not[CompatibleUnitQ[intensity,1 GravitationalAcceleration]]&&roboticPritimitveQ,
						RPMToRCF[intensity,maxRadius],
						(*if we don't have a max radius and we are not doing robotic, that means the conversion shouldnt be made and thus we stick with specified intensity *)
						intensity
					],

				(* if we don't know the max radius of the rotor then we can't calculate the force, in that case stick with RPM *)
				NullQ[maxRadius],Round[Max[{(maxRate/5),minRate*1.1}],resolution],

				MatchQ[centrifuge,ObjectP[]],
				RPMToRCF[Round[Max[{(maxRate/5),minRate*1.1}],resolution], maxRadius],

				NullQ[centrifuge],
				Null
			]
		],
		{roundedIntensities,maxRadii,centrifugeMinRates,centrifugeMaxRates,centrifugeRateResolutions,resolvedCentrifuges}
	];

	(* - Validate the Name option - *)

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameValidBool=TrueQ[DatabaseMemberQ[Append[Object[Protocol, Centrifuge], specifiedName]]];

	(* If the name is invalid, will add it to the list if invalid options later *)
	nameOptionInvalid=If[nameValidBool,
		Name,
		Nothing
	];

	nameUniquenessTest=If[nameValidBool,

	(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.",False,True],
			Message[Error::DuplicateName,Object[Protocol, Centrifuge]];
			Nothing
		],

	(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[specifiedName],
			Test["The specified name is unique.",True,True],
			Nothing
		]
	];

	(* - Resolve Email - *)
	(* Pull Email and Upload options from the expanded Options *)
	(* Resolve Email option *)
	resolvedEmail = If[!MatchQ[specifiedEmail, Automatic],
	(* If Email is specified, use the supplied value *)
		specifiedEmail,
	(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[specifiedUpload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[centrifugeNewOptions];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* - Centrifuge compatibility transfer check - *)

	(* If a sample needs to be transferred in order to fit on the centrifuge, throw ContainerCentrifugeIncompatible warning.
	(We already figured out these cases when resolving the centrifuge since centrifuge and container are connected.) *)
	If[MemberQ[semiResolvedTargetContainers,ObjectP[Model[Container]]]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		If[!MatchQ[resolvedPreparation,Robotic],
			Message[Warning::ContainerCentrifugeIncompatible,
				ObjectToString[PickList[simulatedSamples,semiResolvedTargetContainers,ObjectP[Model[Container]]], Cache->cacheBall],
				ObjectToString[PickList[resolvedCentrifuges,semiResolvedTargetContainers,ObjectP[Model[Container]]], Cache->cacheBall],
				ObjectToString[Cases[semiResolvedTargetContainers,ObjectP[Model[Container]]], Cache->cacheBall]
			]
		]
	];

	(* Make warnings regarding centrifuge compatibility transfers *)
	centrifugeTransferTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[semiResolvedTargetContainers,ObjectP[Model[Container]]],
				Warning["The samples "<>ObjectToString[PickList[simulatedSamples,semiResolvedTargetContainers,ObjectP[Model[Container]]], Cache->cacheBall]<>" are in containers that will fit on the centrifuge:",True,False],
				Nothing
			];

			passingTest=If[MemberQ[semiResolvedTargetContainers,ObjectP[Object[Container]]],
				Warning["The samples "<>ObjectToString[PickList[simulatedSamples,semiResolvedTargetContainers,ObjectP[Object[Container]]], Cache->cacheBall]<>" are in containers that will fit on the centrifuge:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ultracentrifuge sample volume check - *)

	(* For ultracentrifuge, the centrifuge tube needs to be almost full. So we need to make sure there's enough sample in each tube before creating the protocol. *)
	(* Setting an arbitraty 95% filled threshold here and if there's not enough sample volume in the tube, an error message will be thrown *)

	(* First get the centrifuge types from the resolved centrifuge models *)
	(* This error check if only applicable for ultracentrifuge runs *)
	resolvedCentrifugeType=Map[
		If[!NullQ[#],
			fastAssocLookup[fastAssoc, #, CentrifugeType],
			Null
		]&,
		resolvedCentrifugeModels
	];

	(* Get the max volume of the semi target containers *)
	(* Pick out the containers that are actually going into the ultracentrifuge *)
	semiResolvedTargetContainerMaxVolumes=Map[
		Which[
			(* If the semi resolved target container is already an object container, then get max volume from its model packet *)
			MatchQ[#,ObjectP[Object[Container]]],
			fastAssocLookup[fastAssoc, #, {Model, MaxVolume}],

			(* If the semi resolved target container is a model container, grab max volume directly from the packet *)
			MatchQ[#,ObjectP[Model[Container]]],
			fastAssocLookup[fastAssoc, #, MaxVolume],

			(* Otherwise resolve to Null *)
			True,
			Null
		]&,
		semiResolvedTargetContainers
	];
	ultracentrifugeContainerMaxVolumes=PickList[semiResolvedTargetContainerMaxVolumes,resolvedCentrifugeType,Ultra];

	(* Get the volume of each sample from the sample packet *)
	(* Similarly pick out the samples and containers that are actually going into the ultracentrifuge *)
	sampleVolumes=MapThread[
		If[MatchQ[#1,True]||MatchQ[#2,ObjectP[Model[Container]]],
			#3,
			fastAssocLookup[fastAssoc, #4, Volume]
		]&,
		{noTransferFoundBools,semiResolvedTargetContainers,Lookup[samplePrepOptions,AliquotAmount],simulatedSamples}
	];
	ultracentrifugeSamples=PickList[simulatedSamples,resolvedCentrifugeType,Ultra];
	ultracentrifugeSampleVolumes=PickList[sampleVolumes,resolvedCentrifugeType,Ultra];

	(* Calculate % filled in the ultracentrifuge tube: sample volume / max volume of the tube *)
	percentFilled=Divide[ultracentrifugeSampleVolumes,ultracentrifugeContainerMaxVolumes];

	(* Pick out samples and volumes that fill the ultracentrifuge tube for less than 95% *)
	invalidVolumeSamples=PickList[ultracentrifugeSamples,percentFilled,LessEqualP[0.95]];
	invalidSampleVolumes=PickList[ultracentrifugeSampleVolumes,percentFilled,LessEqualP[0.95]];

	(* Also pick out the max volumes of the ultracentrifuge tube that do not have enough samples in them *)
	invalidSampleContainerMaxVolumes=PickList[ultracentrifugeContainerMaxVolumes,percentFilled,LessEqualP[0.95]];

	insufficientVolumeInputs=If[Length[invalidVolumeSamples]>0&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		(
			Message[Error::UltracentrifugeNotEnoughSample,ObjectToString[invalidVolumeSamples,Cache->cacheBall],invalidSampleVolumes,invalidSampleContainerMaxVolumes,"95 Percent"];
			{invalidVolumeSamples}
		),
		{}
	];

	(* Make warnings regarding centrifuge compatibility transfers *)
	ultracentrifugeVolumeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidVolumeSamples]>0,
				Test["The samples "<>ObjectToString[invalidVolumeSamples, Cache->cacheBall]<>" fill to at least 95% of the maximum volume of the ultracentrifuge container:",True,False],
				Nothing
			];

			passingTest=If[Length[invalidVolumeSamples]==0,
				Test["The samples "<>ObjectToString[invalidVolumeSamples, Cache->cacheBall]<>" fill to at least 95% of the maximum volume of the ultracentrifuge container:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Stow aways check - *)

	(* Get the contents of the sample containers *)
	sampleContainerContents=Download[Lookup[sampleContainerPackets, Contents, {}][[All, All, 2]], Object];

	(* Check if there are contents that are not in the input sample list. This will give us a list of bools indexed to the input samples indicating whether that sample will need to be transferred due to stowaways. *)
	stowAwayBools=!ContainsAll[simulatedSamples, #] & /@ sampleContainerContents;

	(*Find any stowaways (to show in the warning). (We want to get the flat list because we don't want to complain about the same sample multiple times)*)
	stowAways=Complement[Flatten[sampleContainerContents], simulatedSamples];

	(* Make tests/messages for stowaways *)
	stowawayTest=If[MatchQ[stowAways,{}],
	(* If there are no stowaways, give a passing warning *)
		If[gatherTests,
			Warning["The input sample containers do not contain any samples that are not in the input list:",True,True],
			Nothing
		],

	(* If any stowaways, throw a warning that the non-stowaways will be transferred *)
		If[gatherTests||MatchQ[$ECLApplication,Engine],
			Warning["The input sample containers "<>ObjectToString[PickList[Lookup[sampleContainerPackets, Object, {}], stowAwayBools], Cache->cacheBall]<>" contain samples "<>ObjectToString[stowAways, Cache->cacheBall]<>" that are not in the input list:",False,True],
			Message[Warning::SampleStowaways, ObjectToString[Lookup[sampleContainerPackets, Object,{}], Cache->cacheBall],ObjectToString[stowAways, Cache->cacheBall]];
			Nothing
		]
	];

	(* We already know if a sample needs to be transferred in order to fit on the centrifuge since we needed this info to resolve centrifuge.
 		TargetContainer is already set to the desired container model if a transfer must happen to fit on the centrifuge,
 		or to the container of the sample if no transfer needs to happen to fit on the centrifuge.
 		Update the list of target containers to reflect whether a sample needs to be transferred due to stowaways.*)
	targetContainerWithStowAwayTransfers=MapThread[Function[{targetContainer,currentContainerModel,stowAwayBool},
		Which[
		(* If target container has already been set to something other than the current container,
		we have already determined that transfers need to be done to fit on the centrifuge, so don't update TargetContainer in this case. *)
			MatchQ[targetContainer,ObjectP[Model[Container]]]  || NullQ[targetContainer],
			targetContainer,

		(* If the sample must be transferred due to stowaways, update TargetContainer to be a the model of the current container*)
			stowAwayBool,
			currentContainerModel,

		(* If the sample doesn't have to be transferred due to stowaways, don't change the target container*)
			!stowAwayBool,
			targetContainer
		]
	],{semiResolvedTargetContainers,Lookup[sampleContainerModelPackets,Object,Null],stowAwayBools}];

	(* - Conflicting Options Transfers -
		The sample groupings up to this point just reflects the current container groupings.
		However, if samples in the same container are specified with different time,temperature,instrument, or intensity options,
		or if the number of replicates/number of times the sample was given as input differ
		these samples need to be transferred. *)

	(* Helper function to expand listed options/inputs by the number of replicates *)
	expandByReplicates[numberOfReplicates:Alternatives[GreaterEqualP[1, 1], Null], stuffToExpand:{_List ..}]:=
		  Map[Function[listToExpand,
			  Flatten[Map[Function[indexToExpand,
					  ConstantArray[indexToExpand, (numberOfReplicates /. {Null -> 1})]],
				  listToExpand], 1]
		  ], stuffToExpand];

	(* Expand things by the number of replicates *)
	{expandedSampleContainerPackets, expandedSimulatedSamples, expandedTargetContainerWithStowAwayTransfers,
		expandedResolvedCentrifuges, expandedResolvedIntensities, expandedSpecifiedTemperatures,
		expandedSpecifiedTimes} = expandByReplicates[specifiedReplicates, {sampleContainerPackets, simulatedSamples,
		targetContainerWithStowAwayTransfers, resolvedCentrifuges, resolvedIntensities, (resolvedTemperature /. {Ambient -> $AmbientTemperature}), specifiedTimes}
	];

	(* Group each set of options, container, sample, target container, and a potential index by container *)
	infoByContainerSet = Transpose /@ GatherBy[Transpose[{
		expandedSampleContainerPackets, expandedSimulatedSamples, expandedTargetContainerWithStowAwayTransfers,
		expandedResolvedCentrifuges, expandedResolvedIntensities, expandedSpecifiedTemperatures,
		expandedSpecifiedTimes,
		Range[Length[expandedSimulatedSamples]]
	}], First];

	(* Separate the grouped info into variables *)
	{groupedContainerPackets, groupedSamples, groupedTargetContainers, groupedCentrifuges, groupedIntensities, groupedTemperatures, groupedTimes, groupedIndexes} = Map[infoByContainerSet[[All, #]] &, Range[8]];

	(* For each container, make a list of rules relating the samples in that container to their target container and to their grouping index. *)
	sampleRules=MapThread[
		Function[{containers, samples, targetContainers, centrifuges,intensities, temperatures, times, indexes},

			Module[{optionsBySamples, optionsGroupedBySample,largestOptionSet, otherOptionSets, largestOptionSetRules, otherOptionSetRules},

			(* Group each sample with its option info. If a sample is replicated/duplicated, we will have multiple option info for that sample: {{sample, {optionInfo..}}..}*)
				optionsBySamples = Map[{#[[1, 1]], #[[All, 2 ;; -1]]} &, GatherBy[Transpose[{samples, containers, targetContainers, centrifuges, intensities, temperatures, times, indexes}], #[[1]] &]];

				(* Group samples that use the same option info together: {{{sample, {optionInfo ..}} ..} ..} *)
				optionsGroupedBySample = GatherBy[optionsBySamples, OrderlessPatternSequence[Sequence @@ (#[[2]][[All, 3;;6]])] &];

				(* Separate the largest option set from the others. (If there is only one option set, there will be no "otherOptionSets".) *)
				largestOptionSet = FirstCase[optionsGroupedBySample, _?(Length[#] == Max[Length /@ optionsGroupedBySample] &)];
				otherOptionSets = DeleteCases[optionsGroupedBySample, largestOptionSet];

				(*The option set with the most samples will stay together in the current target container.
				Relate each sample to the same index, and relate each sample to its current target container.*)
				largestOptionSetRules = Module[{targetContainersForSet,targetContainerModel,numberOfWells,indexesToUse,
					samplesForSet,indexesForSet},

					(* Pull out the samples, the target container for each sample, and the potential index for each sample *)
					samplesForSet = largestOptionSet[[All, 1]];
					targetContainersForSet = largestOptionSet[[All, 2]][[All, All, 2]][[All, 1]];
					indexesForSet=largestOptionSet[[All, 2]][[All, All, -1]][[All, 1]];

					(* Get the target container model *)
					targetContainerModel = If[MatchQ[targetContainersForSet[[1]],ObjectP[Object[Container]]],
						Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[targetContainersForSet[[1]],Object],Model->_}]],Model],Object],
						targetContainersForSet[[1]]
					];

					(* Get the number of wells in the target container *)
					numberOfWells = Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->targetContainerModel,NumberOfWells->_}],{}],NumberOfWells,1];

					(* Determine what grouping indexes to use. If the target container is a vessel, each sample will get a unique index.
					If the target container is a plate, use the same index for all samples (using more indices as needed if the number of samples exceeds the number of wells). *)
					indexesToUse = If[MatchQ[targetContainersForSet, {ObjectP[{Object[Container, Plate], Model[Container, Plate]}] ..}],
						Flatten[MapThread[ConstantArray[First[#1], Length[#2]] &, {Partition[indexesForSet, UpTo[numberOfWells]], Partition[samplesForSet, UpTo[numberOfWells]]}]],
						indexesForSet];

					(* Relate each sample to an index, and relate each sample to its current target container. *)
					{
						AssociationThread[samplesForSet, indexesToUse],
						AssociationThread[samplesForSet, targetContainersForSet]
					}
				];

				(* The other option sets will move to different containers, each option set to a different container.
				Update the target container to be a model of the current container (if the current target container is not already a model).
				Update the sample grouping to reflect the desired movement of these samples. *)
				otherOptionSetRules = Map[Function[{set},

					Module[{targetContainersForSet,targetContainerModel,numberOfWells,indexesToUse,
						samplesForSet,indexesForSet,containerPacketsForSet,targetContainersToUse},

					(* Pull out the samples, the target container for each sample, the potential index, and the current container for each sample *)
						samplesForSet = set[[All, 1]];
						targetContainersForSet = set[[All, 2]][[All, All, 2]][[All, 1]];
						indexesForSet=set[[All, 2]][[All, All, -1]][[All, 1]];
						containerPacketsForSet = set[[All, 2]][[All, All, 1]][[All, 1]];

						(* Get the target container model *)
						targetContainerModel = If[MatchQ[targetContainersForSet[[1]],ObjectP[Object[Container]]],
							Download[Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->Download[targetContainersForSet[[1]],Object],Model->_}]],Model],Object],
							targetContainersForSet[[1]]
						];

						(* Get the number of wells in the target container *)
						numberOfWells = Lookup[FirstCase[cacheBall,KeyValuePattern[{Object->targetContainerModel,NumberOfWells->_}]],NumberOfWells];

						(* Determine what grouping indexes to use. If the target container is a vessel, each sample will get a unique index.
						If the target container is a plate, use the same index for all samples (using more indices as needed if the number of samples exceeds the number of wells). *)
						indexesToUse = If[MatchQ[targetContainersForSet, {ObjectP[{Object[Container, Plate], Model[Container, Plate]}] ..}],
							Flatten[MapThread[ConstantArray[First[#1], Length[#2]] &, {Partition[indexesForSet, UpTo[numberOfWells]], Partition[samplesForSet, UpTo[numberOfWells]]}]],
							indexesForSet];

						targetContainersToUse = If[MatchQ[targetContainersForSet, {ObjectP[Model[Container]]..}],
							targetContainersForSet,
							Download[Lookup[containerPacketsForSet, Model], Object]
						];

						(* Relate each sample to an index, and relate each sample to its current target container. *)
						{
							AssociationThread[samplesForSet, indexesToUse],
							AssociationThread[samplesForSet, targetContainersToUse]
						}
					]
				],otherOptionSets];

				(* Return the rules for all the option sets *)
				{
					Association @@ {{largestOptionSetRules[[1]]}, otherOptionSetRules[[All, 1]]},
					Association @@ {{largestOptionSetRules[[2]]}, otherOptionSetRules[[All, 2]]}
				}
			]], {groupedContainerPackets, groupedSamples, groupedTargetContainers, groupedCentrifuges, groupedIntensities, groupedTemperatures, groupedTimes, groupedIndexes}];


	(* Pool all of the target container rules and all of the index rules *)
	samplesToGroupingIndexRules = Association@@sampleRules[[All,1]];
	sampleToTargetContainerRules =Association@@sampleRules[[All,2]];

	(* We now have rules relating each sample to its target container and to its grouping index.
	Order the target containers and grouping indexes so that they are indexed to the samples*)
	targetContainers = simulatedSamples/.sampleToTargetContainerRules;
	groupingIndexes = simulatedSamples/.samplesToGroupingIndexRules;

	(* If we need to transfer a sample due to option conflicts within a container, this will be reflected in any target containers that have been switched to models now. *)
	containerOptionConflicts=MapThread[!MatchQ[#1, #2] &, {targetContainerWithStowAwayTransfers, targetContainers}];

	(* If a sample needs to be transferred due to conflicting options within a container, throw a warning. *)
	If[MemberQ[containerOptionConflicts,True]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::ConflictingOptionsWithinContainer,ObjectToString[DeleteDuplicates[PickList[simulatedSamples,containerOptionConflicts]], Cache->cacheBall]]
	];

	(* Make warnings regarding transfers due to conflicting options within a container *)
	containerConflictTransferTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MemberQ[containerOptionConflicts,True],
				Warning["The samples "<>ObjectToString[DeleteDuplicates[PickList[simulatedSamples,containerOptionConflicts]], Cache->cacheBall]<>" share the same options with other samples in the same container:",True,False],
				Nothing
			];

			passingTest=If[MemberQ[containerOptionConflicts,False],
				Warning["The samples "<>ObjectToString[DeleteDuplicates[PickList[simulatedSamples,containerOptionConflicts]], Cache->cacheBall]<>" share the same options with other samples in the same container:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Lookup the requested weights - these should be the weights of the containers *)
	requestedCounterweights=Lookup[myOptions,CounterbalanceWeight];

	(* For each sample get a list of all the counterweights with the same footprint *)
	potentialCounterweightPackets=Map[
		Function[containerModelPacket,
			Select[Flatten@counterbalancePackets,MatchQ[Lookup[containerModelPacket,Footprint],Lookup[#,Footprint]]&]
		],
		sampleContainerModelPackets
	];

	(* For each sample get a list of all the available counterweight weights *)
	potentialCounterweightWeights=Lookup[#,Weight,{}]&/@potentialCounterweightPackets;

	(* Determine the counterweights that could be used *)
	(* Here we are just checking that a counterweight exists -
		it may be the case that we end up using another sample as a counterweight so don't actually change this option value *)
	uniqueBucketsAndRotors=Cases[DeleteDuplicates[Download[Flatten[{resolvedRotors,resolvedBuckets}],Object]],ObjectP[]];

	uniqueBucketsAndRotorsPositionRule=Map[
		If[MatchQ[#, ObjectP[Model]],
			# -> Lookup[fastAssocLookup[fastAssoc, #, Positions], Name, {}],
			# -> DeleteCases[
				Lookup[fastAssocLookup[fastAssoc, #, {Model, Positions}], Name, {}],
				Alternatives @@ fastAssocLookup[fastAssoc, #, Contents][[All, 1]]
			]
		]&,
		uniqueBucketsAndRotors
	];

	{resolvedCounterbalanceWeights,maxImbalances}=Transpose[If[MatchQ[requestedCounterweights,{MassP..}]&&(!roboticPritimitveQ),
		MapThread[
			Function[{requestedWeight,rotorModel,bucketModel,counterweightWeights},

				Module[{bucketPositions,rotorPositions,numberOfPositions,maxImbalance,pairImbalance,validWeights},
					(* Get the number of bucketModel positions that this bucketModel has. If there is no bucketModel being used, default to 1. *)
					bucketPositions=If[NullQ[bucketModel],
						Null,
						Lookup[uniqueBucketsAndRotorsPositionRule,bucketModel,Null]
					];

					(* Get the number of positions that this rotorModel has.*)
					rotorPositions=Lookup[uniqueBucketsAndRotorsPositionRule,rotorModel,Null];

					(* Get the total number of positions that are available in this bucketModel/rotorModel combo. (If there is no bucketModel, consider the number of bucketModel positions to be 1.) *)
					numberOfPositions=((Length[bucketPositions]/. {0 -> 1})*Length[rotorPositions]);

					(* - Pair each container with another container of similar mass or with a counterweight - *)
					
					(* determine the max imbalance of the rotorModel, and the equally distributed max imbalance between pairs *)
					maxImbalance = If[NullQ[rotorModel],0Gram,fastAssocLookup[fastAssoc, rotorModel, MaxImbalance]];
					pairImbalance = If[numberOfPositions>0,maxImbalance/(numberOfPositions/2),0];

					(* select the possible counterweights within the rotor imbalance *)
					validWeights = Select[counterweightWeights,Abs[requestedWeight-#]<=pairImbalance&];
					
					
					(* get the best counterweight for having the smallest differences in weight*)
					(* if no counterpart was found in the last step, return $Failed *)
					If[MatchQ[validWeights,{}],
						{$Failed,pairImbalance},
						{First[TakeSmallestBy[validWeights,Abs[# - requestedWeight]&,1]],pairImbalance}
					]
				]
			],
			{requestedCounterweights,resolvedRotors,resolvedBuckets,potentialCounterweightWeights}
		],
		ConstantArray[{Null,Null},Length[mySamples]]
	]];

	(* Find any requests that don't have an associated counterweight *)
	badWeights=PickList[requestedCounterweights,resolvedCounterbalanceWeights,$Failed];
	exceededImbalances=PickList[maxImbalances,resolvedCounterbalanceWeights,$Failed];

	(* Throw a message if we couldn't find a counterweight. No test since this is a hidden option *)
	invalidWeightsOptions=If[!MatchQ[badWeights,{}],
		Message[Error::InvalidCounterweights,badWeights,exceededImbalances];{CounterbalanceWeight},
		{}
	];


	(* Resolve counterweights*)
	(* NOTE: We need to make sure that all samples and containers have labels attached to them so that we know how to distinguish *)
	(* them in our compiler/parser once we've done the resource picking. *)
	{
		resolvedCounterweight,
		nullTareWeightErrors,
		noCounterweightErrors,
		plateTooHeavyForCentrifugeErrors
	}=If[roboticPritimitveQ,
		Transpose@MapThread[
			Function[{mySample, myMapThreadOptions, containerPacket, contentsPackets, containerModelPacket,myCentrifuge},
				Module[{nullTareWeightError, specifiedCounterweight, counterweight, sampleMasses, containerModelWeight,
					containerModelHeight, containerWeight, noCounterweightsError,plateTooHeavyForCentrifugeError,centrifugeMaxWeight,
					mycentrifugepacket},

					(* set the error checking variables *)
					{
						nullTareWeightError,
						noCounterweightsError,
						plateTooHeavyForCentrifugeError
					} = {
						False,
						False,
						False
					};


					(* figure out the masses of all the samples in the plate *)
					sampleMasses = Map[
						If[MassQ[Lookup[#, Mass]],
							Lookup[#, Mass],
							Lookup[#, Volume] * (0.997` Gram / Milliliter)
						]&,
						contentsPackets
					];
					(* get the container model weight (or container, if that's populated) *)
					containerModelWeight = If[MassQ[Lookup[containerPacket, TareWeight]],
						Lookup[containerPacket, TareWeight],
						Lookup[containerModelPacket, TareWeight]
					];

					(* Get the container model's height *)
					containerModelHeight = If[MatchQ[Lookup[containerPacket, Dimensions],{DistanceP,DistanceP,DistanceP}],
						LastOrDefault[Lookup[containerPacket, Dimensions]],
						LastOrDefault[Lookup[containerModelPacket, Dimensions]]
					];

					(* get the specified counterweight *)
					specifiedCounterweight = Lookup[myMapThreadOptions, Counterweight];

					(* flip an error switch if the TareWeight of the specified container is Null *)
					(* if we have directly specified a counterweight then this is fine even since we assume we're good if passing that in *)
					nullTareWeightError = NullQ[containerModelWeight] && MatchQ[specifiedCounterweight, Null | Automatic];

					(* get the total weight of the container  *)
					containerWeight = Replace[Total[Cases[Flatten[{sampleMasses, containerModelWeight}], MassP]], {0 -> 0 Gram}, {0}];
					mycentrifugepacket=fetchPacketFromFastAssoc[myCentrifuge,fastAssoc];

					centrifugeMaxWeight=If[NullQ[mycentrifugepacket],
																Null,
																Lookup[fetchPacketFromFastAssoc[myCentrifuge,fastAssoc],MaxWeight,Null]];
					plateTooHeavyForCentrifugeError=Which[
						(*if there is no container weight or we don't know the max weight then we can't calculate this *)
						Or[NullQ[containerWeight],NullQ[centrifugeMaxWeight]],False,
						(*if the weight is greater than the max weight then this error triggers *)
						MatchQ[containerWeight,GreaterP[centrifugeMaxWeight]],True,
						(*otherwise, say false incase weird stuff happens *)
						True,False
					];
					{
						counterweight,
						noCounterweightsError
					} = getProperCounterweight[containerWeight,containerModelHeight,specifiedCounterweight,Lookup[containerModelPacket,Footprint],Flatten@counterbalancePackets];
					{
						counterweight,
						nullTareWeightError,
						noCounterweightsError,
						plateTooHeavyForCentrifugeError
					}
				]
			],
			{mySamples, mapThreadFriendlyOptions, sampleContainerPacketsWithNulls, allContentsPackets,sampleContainerModelPacketsWithNulls,resolvedCentrifugeModels}
		],
		{
			ConstantArray[Null,Length[simulatedSamples]],
			ConstantArray[False,Length[simulatedSamples]],
			ConstantArray[False,Length[simulatedSamples]],
			ConstantArray[False,Length[simulatedSamples]]
		}
	];

	(* Error messages for the counterweight, for now this is specifically for the robotic centrifuge*)
	(* throw a message if the plate is too heavy to be spun on this centrifuge *)

	tooHeavyPlateSamples = PickList[mySamples,plateTooHeavyForCentrifugeErrors];
	tooHeavyPlateInputs = If[messages && MemberQ[plateTooHeavyForCentrifugeErrors,True],
		(
			Message[Error::CentrifugeContainerTooHeavy,
				ObjectToString[tooHeavyPlateSamples, Cache -> cache]
			];
			tooHeavyPlateSamples
		),
		tooHeavyPlateSamples
	];


	(* throw a message if there is no tare weight *)
	nullTareWeightSamples = PickList[mySamples, nullTareWeightErrors];
	nullTareWeightInputs = If[messages && MemberQ[nullTareWeightErrors, True],
		(
			Message[Error::CentrifugeContainerNullTareWeight, ObjectToString[nullTareWeightSamples, Cache -> cache]];
			nullTareWeightSamples
		),
		nullTareWeightSamples
	];

	(* make a test if the TareWeight is Null *)
	nullTareWeightTest = If[gatherTests,
		Test["The container of the provided sample(s) has the TareWeight field populated for either the container itself or its model:",
			nullTareWeightErrors,
			{False..}
		]
	];

	(* throw a message if there is no counterweight *)
	noCounterweightSamples = PickList[mySamples, noCounterweightErrors];
	noCounterweightInputs = If[messages && MemberQ[noCounterweightErrors, True],
		(
			Message[Error::CentrifugeContainerNoCounterweights, ObjectToString[noCounterweightSamples, Cache -> cache]];
			noCounterweightSamples
		),
		noCounterweightSamples
	];

	(* make a test if there are no counterweights *)
	noCounterweightTest = If[gatherTests,
		Test["The container of the provided sample(s) has the Counterweights field of its model populated:",
			noCounterweightErrors,
			{False..}
		]
	];


	(* Resolve Aliquot Options *)

	(* If we aren't aliquoting (i.e., target container is still an object (or is Null due to the sample being discarded), update the aliquot container option to be automatic (otherwise the aliquot resolver is unhappy since it can't work with non-empty containers) *)
	aliquotContainerForResolver = If[(!roboticPritimitveQ),Transpose[{groupingIndexes,targetContainers}]/.{_, ObjectP[Object[Container]]|Null} -> Null, Null];

	(* resolve the aliquot options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentCentrifuge,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			RequiredAliquotAmounts -> Null,
			AliquotWarningMessage -> Null,
			RequiredAliquotContainers -> aliquotContainerForResolver,
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentCentrifuge,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				RequiredAliquotAmounts -> Null,
				AliquotWarningMessage -> Null,
				RequiredAliquotContainers -> aliquotContainerForResolver,
				AllowSolids -> True,
				MinimizeTransfers -> True,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> Result
			],
			{}
		}
	];

	(* Final check, based on the preparation scale, check if the related options are null or not.*)
	incompatiblePreparationOptions=
		Which[
			(* if no centrifuges have been resolved, then we have bigger problems than rotors not being resolved. *)
			MatchQ[resolvedCentrifugeModels,ListableP[Null]],
				{},
			True,
			(*if centrifuges are resolved, then rotors should be too.. *)
				Module[{relaventOptionValues,relaventOptions,incompatibleOptions},

				relaventOptionValues={
					resolvedRotors,
					resolvedRotorGeometry
				};

				relaventOptions={
					Rotors,
					RotorGeometry
				};

				incompatibleOptions=PickList[relaventOptions,relaventOptionValues,ListableP[Null]]

			]
		];

	If[Length[incompatiblePreparationOptions]>0,
		Message[
			Error::CentrifugeRotorOptionsNotSpecified,
			ObjectToString[incompatiblePreparationOptions]
		];
	];

	incompatiblePreparationTests = If[gatherTests,
		Test["The container of the provided sample(s) has the Counterweights field of its model populated:",
			Length[incompatiblePreparationOptions]==0,
			True
		]
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[
		Flatten[{
			discardedInvalidInputs,
			noTransferContainerInvalidInputs,
			invalidSampleFilterInputs,
			invalidConflictingContainerInputs,
			insufficientVolumeInputs,
			nullTareWeightInputs,
			noCounterweightInputs,
			cantTransferContainerRoboticInvalidInputs,
			tooHeavyPlateInputs
		}]
	];

	invalidOptions=DeleteDuplicates[
		Flatten[{
			centrifugeInvalidOptions,
			noCentrifugeFoundInvalidOptions,
			nameOptionInvalid,
			invalidSampleFilterOptions,
			invalidConflictingContainerOptions,
			invalidWeightsOptions,
			rotorRotorGeometryInvalidOptions,
			rotorRotorAngleInvalidOptions,
			rotorInstrumentInvalidOptions,
			chilledRotorInstrumentInvalidOptions,
			rotorStorageConditionInvalidOptions,
			noRotorFoundInvalidOptions,
			temperatureMustBeAmbientOptions,
			mismatchedCentrifugeOptions,
			incompatiblePreparationOptions,
			If[MatchQ[preparationResult, $Failed],
				{Preparation},
				Nothing
			]
		}]
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests&&Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs, Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests&&Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];
	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> ReplaceRule[Normal[optionsWithRoundedIntensity],
			Join[
				{
					Instrument->resolvedCentrifuges,
					Intensity->resolvedIntensities,
					Temperature->resolvedTemperature,
					Rotor->resolvedRotors,
					RotorAngle->resolvedRotorAngle,
					RotorGeometry->resolvedRotorGeometry,
					ChilledRotor->resolvedChilledRotor,
					Counterweight -> resolvedCounterweight,
					SampleLabel->resolvedSampleLabels,
					SampleContainerLabel->resolvedSampleContainerLabels,
					Preparation->resolvedPreparation,
					WorkCell->resolvedWorkCell,
					Name -> specifiedName,
					Email -> resolvedEmail,
					Sterile -> resolvedSterile,
					CollectionContainer -> resolvedCollectionContainers,
					CounterbalanceWeight -> resolvedCounterbalanceWeights,
					Cache -> cache,
					Simulation -> updatedSimulation
				},
				resolvedAliquotOptions,
				resolvedSamplePrepOptions,
				resolvedPostProcessingOptions
			]
		],
		Tests -> Flatten[
			{
				discardedTest,
				centrifugeCompatibleTests,
				noCentrifugeFoundTests,
				noTransferContainerTests,
				intensityPrecisionTests,
				nameUniquenessTest,
				centrifugeTransferTests,
				stowawayTest,
				containerConflictTransferTests,
				sterileValidationWarning,
				invalidSampleFilterTests,
				conflictingCollectionContainerTests,
				aliquotTests,
				noRotorFoundTests,
				rotorStorageConditionInvaildTests,
				chilledRotorTemperaturesTests,
				chilledRotorLowTemperaturesTests,
				temperatureMustBeAmbientTest,
				mismatchedCentrifugeTests,
				incompatiblePreparationTests
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(* centrifugeResourcePackets *)


DefineOptions[
	centrifugeResourcePackets,
	Options:>{
		{
			Output -> Result,
			ListableP[Result|Tests],
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		},
		SimulationOption,
		CacheOption
	}
];

(* private function to generate the list of protocol packets containing resource blobs *)
centrifugeResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},myResourceOptions:OptionsPattern[centrifugeResourcePackets]]:=Module[
	{resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,cache, simulatedSampleContainerPacketsWithNull,
		times,centrifuges,containersIn,rates,parentProtocol,imageSample,samplePackets, simulatedSampleContainerModelPackets,
		simulatedSampleContainerPackets,sampleDownloads,rotors,temperatures,intensities,aliquotContainerInfo, simulatedSampleContainerModelPacketsWithNull,
		groupedSampleParameters,centrifugeResources,batchesByParameterGroup,
		operatorSetupTime,operatorSpinTime,centrifugeInstrumentTimeByParameterGroup,centrifugesByParameterGroup,
		centrifugeToResourceRules,indexedBucketsByParameterGroup,gatheringEstimate,bucketResources,operatorCentrifugingEstimate,
		centrifugingEstimate,spinTimesByParameterGroup,samplesInResources,returningEstimate,postProcessingEstimate,name,
		balancingEstimate,allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,protocolPacket,
		aliquotBools,currentContainers,currentContainerModels,balanceResource,tareRackResources,
		allRacks,allRackPackets,containerModelsNeedingRacks,containerModelsNeedingRacksPackets,containerModelsNeedingRacksFootprint,availableRackFootprints,openRackFootprintQ,defaultOpenHolder,holders,	commonFootprintToRackLookup,commonRackLookup,

		potentialRacksByContainer,tareRackSets,replicates,preparation,
		expandedTargetContainers,expandedTargetContainerModels,expandedCentrifuges,expandedTimes,expandedForces,
		expandedTemperatures,expandedBuckets,expandedAdapters,expandedSecondaryAdapters, expandedTertiaryAdapters,allCounterweights,counterbalancePackets,expandedCounterbalanceAdapters,expandedCounterbalanceSecondaryAdapters,expandedCounterbalanceTertiaryAdapters,expandedRotors,expandedSamples,expandedRates,expandedSampleResource,
		expandedCentrifugeResources,simulatedSamples,expandByReplicates,expandedAliquotBools,
		expandedCurrentContainers,expandedCurrentContainerModels,expandedIntensities,expandedCentrifugesModels,expandedMaxRadii,
		expandedCentrifugesModelPackets,centrifugeRateResolutions,simulatedSamplePackets,simulatedSampleDownloads,
	 	centrifugeInstruments, centrifugeRotors, centrifugeBuckets, centrifugeInstrumentPackets,
		centrifugeRotorPackets, centrifugeBucketPackets, inputContainerFootprints, inputContainerCentrifugeEquipment,unitOperationPackets,
		containerCentrifugeEquipmentLookup, collectionContainerNoIndices, simulation, updatedSimulation,
		collectionContainerModelPackets, collectionContainerObjectPackets, collectionContainerPackets,roboticPrimitiveQ,
		collectionContainers, collectionContainerModels, collectionContainerResources, collectionContainerIndicesToUUIDs, collectionContainerIndices,
		sampleContainerToUUIDs, centrifugeAdapters, centrifugeAdapterPackets, adapterResources, secondaryAdapterResources, tertiaryAdapterResources, counterbalanceAdapterLinks, secondaryCounterbalanceAdapterLinks, tertiaryCounterbalanceAdapterLinks,
		expandedRotorsModels, rotorByParameterGroup, rotorToResourceRules, rotorResources, expandedRotorResources, plierResourceReplaceRules, plierResource, chilledRotors,
		expandedChilledRotors, chilledRotorByParameterGroup, centrifugeRotorObjectPackets, rotorObjectByParameterGroup,
		rotorAngle,rotorGeometry,counterbalanceWeights,sampleLabel, sampleContainerLabel,
		counterweight,sampleToResourceRules,sampleContainerResources,sampleContainerToResourceRules,collectionContainerToResourceRules,
		expandedCollectionContainers,expandedSampleLabel, expandedSampleContainerLabel, expandedCounterweight,
		uniqueCounterweightResourceRules, counterweightResources, counterweightToResourceRules,resourcesWithoutName,resourceToNameReplaceRules,previewRule,optionsRule,
		rawResourceBlobs,resolvedOptionsExpanded, cacheBall, fastAssoc, existingInputCollectionContainerModelPackets,
		existingInputCollectionContainerPackets, riffleAlternativesBoolsCollectionContainerModels, riffleAlternativesBoolsCollectionContainers,
		remainingCollectionContainerModels, remainingCollectionContainers, remainingCollectionContainerModelPackets,
		remainingCollectionContainerObjectPackets, existingSimulatedSamplePackets, riffleAlternativesBoolsSimulatedSamples,
		remainingSimulatedSamples, remainingSimulatedSampleDownloads,

		adapterResourcesIndexMatchedToContainer, secondaryAdapterResourcesIndexMatchedToContainer, tareRackIndexMatched,
		tertiaryAdapterResourcesIndexMatchedToContainer, counterbalanceAdapterLinksIndexMatchedToContainer, tareRackResourcesIndexMatched,
		secondaryCounterbalanceAdapterLinksIndexMatchedToContainer, tertiaryCounterbalanceAdapterLinksIndexMatchedToContainer
	},

	resolvedOptionsExpanded=RemoveHiddenOptions[ExperimentCentrifuge, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentCentrifuge,
		resolvedOptionsExpanded,
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[ToList[myResourceOptions], Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Get the cache *)
	cache = Lookup[ToList[myResourceOptions], Cache];
	simulation = Lookup[ToList[myResourceOptions], Simulation];
	fastAssoc = makeFastAssocFromCache[cache];

	(*if we didn't Incubate, Filter, or Aliquot then skip this step *)
	{simulatedSamples, updatedSimulation} = If[Not[MatchQ[Flatten[Lookup[myResolvedOptions, {Incubate, Filter, Aliquot}]], {(False|Null)..}]],
		simulateSamplesResourcePacketsNew[ExperimentCentrifuge, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation],
		{mySamples, simulation}
	];

	(* Get rid of any indices in the collection container option. *)
	(* This will leave us with Object[Container] and Model[Container]. *)
	collectionContainerNoIndices = Map[
		Switch[#,
			Automatic | {_, Automatic}, Automatic,
			{_Integer, _}, Download[#[[2]], Object],
			_, Download[#, Object]
		]&,
		Lookup[myResolvedOptions, CollectionContainer]
	];
	collectionContainerModels = Cases[collectionContainerNoIndices, ObjectP[Model[Container]]];
	collectionContainers = Cases[collectionContainerNoIndices, ObjectP[Object[Container]]];

	(* if any of the objects already exist in the fastAssoc, then just pull that instead *)
	existingSimulatedSamplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSamples;
	existingInputCollectionContainerModelPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[#, fastAssoc]
		}&,
		collectionContainerModels
	];
	existingInputCollectionContainerPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Model], fastAssoc]
		}&,
		collectionContainers
	];

	(* get the RiffleAlternatives Booleans for the three cases here *)
	riffleAlternativesBoolsSimulatedSamples = MatchQ[#, PacketP[Object[Sample]]]& /@ existingSimulatedSamplePackets;
	riffleAlternativesBoolsCollectionContainerModels = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputCollectionContainerModelPackets;
	riffleAlternativesBoolsCollectionContainers = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputCollectionContainerPackets;

	(* get the ones that are remaining *)
	remainingSimulatedSamples = PickList[simulatedSamples, riffleAlternativesBoolsSimulatedSamples, False];
	remainingCollectionContainerModels = PickList[collectionContainerModels, riffleAlternativesBoolsCollectionContainerModels, False];
	remainingCollectionContainers = PickList[collectionContainers, riffleAlternativesBoolsCollectionContainers, False];

	(* Extract the packets that we need from our downloaded cache. *)
	(* note that depending on what we already have in the fastAssoc, we might not actually be Downloading anything here *)
	{
		remainingSimulatedSampleDownloads,
		remainingCollectionContainerModelPackets,
		remainingCollectionContainerObjectPackets
	} = If[MatchQ[{remainingSimulatedSamples, remainingCollectionContainerModels, remainingCollectionContainers}, {{}..}],
		(* Doing this short circuit because if the simulation is large, even if we are Downloading from {} it can still be slow*)
		{{}, {}, {}},
		Quiet[
			Download[
				{
					remainingSimulatedSamples,
					remainingCollectionContainerModels,
					remainingCollectionContainers
				},
				{
					{
						Packet[Status, Volume, Container,Name],
						Packet[Container[Model[{Name,MaxVolume,NumberOfWells,SelfStanding,Dimensions,Footprint}]]],
						Packet[Container[{Contents,Model,Name}]]
					},
					{Object, Packet[Footprint, Dimensions]},
					{Object, Packet[Model[{Footprint, Dimensions}]]}
				},
				Cache->cache,
				Simulation -> updatedSimulation
			],
			{Download::FieldDoesntExist}
		]
	];


	(* re-combine the things we Downloaded together *)
	simulatedSamplePackets = RiffleAlternatives[
		DeleteCases[existingSimulatedSamplePackets, $Failed|{}|<||>],
		remainingSimulatedSampleDownloads[[All, 1]],
		riffleAlternativesBoolsSimulatedSamples
	];
	simulatedSampleContainerModelPacketsWithNull = RiffleAlternatives[
		DeleteCases[
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, {Container, Model}], fastAssoc]& /@ simulatedSamples,
			$Failed|{}|<||>
		],
		remainingSimulatedSampleDownloads[[All, 2]],
		riffleAlternativesBoolsSimulatedSamples
	];
	simulatedSampleContainerPacketsWithNull = RiffleAlternatives[
		DeleteCases[
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Container], fastAssoc]& /@ simulatedSamples,
			$Failed|{}|<||>
		],
		remainingSimulatedSampleDownloads[[All, 3]],
		riffleAlternativesBoolsSimulatedSamples
	];

	collectionContainerModelPackets = RiffleAlternatives[
		DeleteCases[existingInputCollectionContainerModelPackets, {_, $Failed|{}|<||>}],
		remainingCollectionContainerModelPackets,
		riffleAlternativesBoolsCollectionContainerModels
	];
	collectionContainerObjectPackets = RiffleAlternatives[
		DeleteCases[existingInputCollectionContainerPackets, {_, $Failed|{}|<||>}],
		remainingCollectionContainerObjectPackets,
		riffleAlternativesBoolsCollectionContainers
	];

	(* Find all centrifuge equipment in order to download required information from it *)
	(* Search for all centrifuge models in the lab to download from. *)
	{
		centrifugeInstruments,
		centrifugeRotors,
		centrifugeBuckets,
		centrifugeAdapters
	} = allCentrifugeEquipmentSearch["Memoization"];

	(* Also make resources for counterweight adapters *)
	(* We try to use the same adapters as the input sample if possible - i.e., same footprint with the input container. *)
	(* Find all the counterweights *)
	allCounterweights=allCounterweightsSearch["Memoization"];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{cache, sampleDownloads}];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	centrifugeInstrumentPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeInstruments;
	centrifugeRotorPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeRotors;
	centrifugeBucketPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeBuckets;
	centrifugeAdapterPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ centrifugeAdapters;
	counterbalancePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ allCounterweights;

	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	collectionContainerPackets=ToList[collectionContainerNoIndices]/.((ObjectP[#[[1]]]->#[[2]]&)/@Join[collectionContainerModelPackets, collectionContainerObjectPackets]);

	(* get the simulated container and model packets without Nulls in case we don't actually have a container*)
	simulatedSampleContainerPackets = If[NullQ[#], <||>, #]& /@ simulatedSampleContainerPacketsWithNull;

	simulatedSampleContainerModelPackets = If[NullQ[#], <||>, #]& /@ simulatedSampleContainerModelPacketsWithNull;

	(* Get the container and container model of each sample *)
	currentContainers = Download[Lookup[simulatedSamplePackets,Container],Object];
	currentContainerModels = Lookup[simulatedSampleContainerModelPackets,Object, Null];

	(* Pull out footprints for input containers *)
	inputContainerFootprints = Lookup[simulatedSampleContainerModelPackets, Footprint, Null];

	(* Get centrifuge equipment combos (i.e., instrument/rotor(/bucket) for each input container,
	passing in downloaded centrifuge equipment packets as cache *)
	(* We can safely only calculate centrifuge equipment combos for the specified containers at this point,
	because we're using simulated samples and we know what the current containers will be *)
	inputContainerCentrifugeEquipment = centrifugesForFootprint[
		inputContainerFootprints,
		(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions, Null],Null],Null,Lookup[#, Dimensions, Null][[3]]]&)/@simulatedSampleContainerModelPackets,
		(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions, Null],Null],Null,Lookup[#, Dimensions, Null][[3]]]&)/@collectionContainerPackets,
		Flatten[{centrifugeInstrumentPackets, centrifugeRotorPackets, centrifugeBucketPackets, centrifugeAdapterPackets}]
	];

	(* Generate a lookup table from object to centrifuge equipment *)
	(* We can do this before expanding since this will still cover all unique containers and allow for later lookup *)
	containerCentrifugeEquipmentLookup = AssociationThread[Lookup[simulatedSampleContainerModelPackets, Object], inputContainerCentrifugeEquipment];

	(* Pull out relevant info from the resolved options *)
	{
		times,
		intensities,
		aliquotContainerInfo,
		aliquotBools,
		parentProtocol,
		imageSample,
		name,
		replicates,
		collectionContainers,
		preparation,
		rotorAngle,
		rotorGeometry,
		counterbalanceWeights,
		sampleLabel,
		sampleContainerLabel,
		counterweight
	}=Lookup[myResolvedOptions,
		{
			Time,
			Intensity,
			AliquotContainer,
			Aliquot,
			ParentProtocol,
			ImageSample,
			Name,
			NumberOfReplicates,
			CollectionContainer,
			Preparation,
			RotorAngle,
			RotorGeometry,
			CounterbalanceWeights,
			SampleLabel,
			SampleContainerLabel,
			Counterweight
		}
	];

	temperatures=(Lookup[myResolvedOptions,Temperature]/.{Ambient->$AmbientTemperature});
	centrifuges=Download[Lookup[myResolvedOptions,Instrument],Object,Cache->cache, Simulation -> updatedSimulation];
	rotors=Lookup[myResolvedOptions,Rotor];
	chilledRotors=Lookup[myResolvedOptions,ChilledRotor];

	(* Build a short hand for robotic primitive *)
	roboticPrimitiveQ=MatchQ[preparation,Robotic];

	(* Helper function to expand listed options/inputs by the number of replicates *)
	expandByReplicates[numberOfReplicates:Alternatives[GreaterEqualP[1, 1], Null], stuffToExpand:{_List ..}]:=
		  Map[Function[listToExpand,
			  Flatten[Map[Function[indexToExpand,
				  ConstantArray[indexToExpand, (numberOfReplicates /. {Null -> 1})]],
				  listToExpand], 1]
		  ], stuffToExpand];

	(* AliquotContainers is indexed to samples expanded by NumberOfReplicates, but all of the other options and inputs are not expanded. Expand here. *)
	{
		expandedAliquotBools,
		expandedCurrentContainers,
		expandedCurrentContainerModels,
		expandedCentrifuges,
		expandedRotors,
		expandedTimes,
		expandedTemperatures,
		expandedSamples,
		expandedIntensities,
		expandedChilledRotors,
		expandedCollectionContainers,
		expandedSampleLabel,
		expandedSampleContainerLabel,
		expandedCounterweight
	}=expandByReplicates[
		replicates,
		{
			aliquotBools,
			currentContainers,
			currentContainerModels,
			centrifuges,
			rotors,
			times,
			temperatures,
			mySamples,
			intensities,
			chilledRotors,
			collectionContainers,
			sampleLabel,
			sampleContainerLabel,
			counterweight
		}
	];

	(* Figure out the target container or the samples expanded to include number of replicates. If the sample will not be aliquoted/transferred, this is the current container.
	If the sample will be transferred, this is the AliquotContainer for that sample (index, model container). *)
	{expandedTargetContainers,expandedTargetContainerModels}=Transpose[MapThread[Function[{aliquotBool,aliquotContainer,currentContainer,currentContainerModel},
		If[aliquotBool,
			{aliquotContainer,aliquotContainer[[2]]},
			{currentContainer,currentContainerModel}
		]
	],{expandedAliquotBools,aliquotContainerInfo,expandedCurrentContainers,expandedCurrentContainerModels}]];

	(* Get all of the resolved centrifuges and rotors into the corresponding models. *)
	expandedCentrifugesModels = Map[
		If[MatchQ[#,ObjectP[Object[Instrument,Centrifuge]]],
			Download[Lookup[FirstCase[cache,KeyValuePattern[{Object->#,Model->_}]],Model],Object],
			#
		]&,expandedCentrifuges];

	expandedRotorsModels = Map[
		If[MatchQ[#,ObjectP[Object[Container,CentrifugeRotor]]],
			Download[Lookup[FirstCase[cache,KeyValuePattern[{Object->#,Model->_}]],Model],Object],
			#
		]&,
		expandedRotors
	];

	(* Get the packets of the centrifuge models *)
	expandedCentrifugesModelPackets=Map[FirstCase[cache,KeyValuePattern[{Object->#}], <||>]&,expandedCentrifugesModels];

	(* We know the centrifuge that will be used for each sample and the container model that the sample will be in.
	 	From this info, figure out the max radius so that we can convert between rate and force. *)
	(*Also get the bucket, rotor, and centrifuge adapter that will be used for each sample. *)
	{expandedMaxRadii,expandedBuckets,expandedAdapters, expandedSecondaryAdapters, expandedTertiaryAdapters}=Transpose[MapThread[Function[{containerModel,centrifugeModel,rotorModel},
		Module[
			{containerModelPacket, centrifugeCompatibilities, potentialCentrifugeCompatibility, centrifugeCompatibility, rotor,
			bucket, rotorMaxRadius, bucketMaxRadius, maxRadius, adapters, adapter1, adapter2, adapter3},

			(* Look up container model's compatible centrifuge equipment sets *)
			centrifugeCompatibilities = Lookup[containerCentrifugeEquipmentLookup, containerModel, {}];

			(* Extract the best entry that corresponds to the instrument model that will be used *)
			(* Extract the entry that corresponds to the instrument model that will be used *)
			potentialCentrifugeCompatibility = Select[centrifugeCompatibilities, And[MemberQ[#, ObjectP[centrifugeModel]],MemberQ[#,ObjectP[rotorModel]]]&];

			(* Default to the one that has least layers of equipment - rotor/bucket/adapters for our experiment. *)
			centrifugeCompatibility = FirstOrDefault[
				SortBy[
					(* Extract the entry that corresponds to the instrument model that will be used *)
					potentialCentrifugeCompatibility,
					(* Sort the entries to get the shortest length to be the first one *)
					Length[Cases[#,ObjectP[Model[Part,CentrifugeAdapter]]]]&
				],
				(* Default to empty list so that we can get rotor/bucket and adapters out of it *)
				{}
			];

			(* Get the rotor and bucket that would be used with this centrifuge/container combo *)
			bucket = FirstCase[centrifugeCompatibility, ObjectP[Model[Container, CentrifugeBucket]], Null];
			adapters = Cases[centrifugeCompatibility, ObjectP[Model[Part, CentrifugeAdapter]]];

			(* Right now we only support 3 layers of adapters. Separate them into different variables. Give Null if there is no such adapter *)
			{adapter1,adapter2,adapter3}=Which[
				Length[adapters]==0,{Null,Null,Null},
				Length[adapters]==1,{First[adapters],Null,Null},
				Length[adapters]==2,{adapters[[2]],First[adapters],Null},
				Length[adapters]>=3,{Last[adapters],adapters[[2]],First[adapters]}
			];

			(* Get the max radius of the rotor and bucket *)
			{rotorMaxRadius, bucketMaxRadius} = Lookup[FirstCase[cache, KeyValuePattern[{Object -> Download[#, Object], MaxRadius -> _}], {}], MaxRadius, Null]& /@ {rotorModel, bucket};

			(* If there is a max radius for the bucket, use that as the overall max radius. Otherwise use the max radius of the rotor. If neither has a max radius, the value will be Null. *)
			maxRadius = FirstCase[{bucketMaxRadius,rotorMaxRadius}, DistanceP, Null];

			{maxRadius, bucket, adapter1, adapter2, adapter3}
		]
	],{expandedTargetContainerModels,expandedCentrifugesModels,expandedRotorsModels}]];

	(* For each sample, try to find the counterweights *)
	{expandedCounterbalanceAdapters,expandedCounterbalanceSecondaryAdapters,expandedCounterbalanceTertiaryAdapters}=Transpose[
		MapThread[
			Function[
				{containerModel,containerAdapter,containerSecondaryAdapter,containerTertiaryAdapter},
				Module[
					{containerModelPacket,adapterPacket,secondaryAdapterPacket,potentialContainerCounterWeights,potentialAdapterCounterWeights,potentialSecondaryAdapterCounterWeights,potentialTertiaryAdapterCounterWeights,counterbalanceAdapter,counterbalanceSecondaryAdapter,counterbalanceTertiaryAdapter},

					(* Get the packets of container and adapters so that we can compare the footprint *)
					containerModelPacket=fetchPacketFromFastAssoc[containerModel, fastAssoc];
					adapterPacket=fetchPacketFromFastAssoc[containerAdapter, fastAssoc];
					secondaryAdapterPacket=fetchPacketFromFastAssoc[containerSecondaryAdapter, fastAssoc];

					(* Find the potential counterweights using different footprint *)
					potentialContainerCounterWeights=Select[Flatten[counterbalancePackets],MatchQ[Lookup[containerModelPacket,Footprint, Null],Lookup[#,Footprint]]&];
					potentialAdapterCounterWeights=If[NullQ[adapterPacket],
						{},
						Select[Flatten[counterbalancePackets],MatchQ[Lookup[adapterPacket,Footprint],Lookup[#,Footprint]]&]
					];
					potentialSecondaryAdapterCounterWeights=If[NullQ[secondaryAdapterPacket],
						{},
						Select[Flatten[counterbalancePackets],MatchQ[Lookup[secondaryAdapterPacket,Footprint],Lookup[#,Footprint]]&]
					];

					(* Depending on what counter weights we found, return the adapters *)
					{counterbalanceAdapter,counterbalanceSecondaryAdapter,counterbalanceTertiaryAdapter}=Which[
						!MatchQ[potentialContainerCounterWeights,{}],{containerAdapter,containerSecondaryAdapter,containerTertiaryAdapter},
						!MatchQ[potentialAdapterCounterWeights,{}],{containerSecondaryAdapter,containerTertiaryAdapter,Null},
						!MatchQ[potentialSecondaryAdapterCounterWeights,{}],{containerTertiaryAdapter,Null,Null},
						True,{Null,Null,Null}
					];

					(* Return the adapters *)
					{counterbalanceAdapter,counterbalanceSecondaryAdapter,counterbalanceTertiaryAdapter}
				]
			],
			{expandedTargetContainerModels,expandedAdapters,expandedSecondaryAdapters,expandedTertiaryAdapters}
		]
	];

	(* Get the RPM resolution of each centrifuge *)
	centrifugeRateResolutions = Lookup[expandedCentrifugesModelPackets,SpeedResolution];

	(* Figure out the force or rate that corresponds with the intensity (which can be in units of force or rate) *)
	{expandedForces, expandedRates} = Transpose[MapThread[Function[{intensity,maxRadius,resolution},
		If[MatchQ[intensity,GreaterP[0 RPM]],

		(* If intensity is specified as a rate  *)
			{RPMToRCF[intensity,maxRadius], intensity},

		(* If intensity is specified as a force.
		Make sure that the rate is rounded to the speed resolution. (We already checked this in the resolver, but there are some precision issues in converting back and forth between force and rate.) *)
			{intensity, Round[RCFToRPM[intensity,maxRadius],resolution]}
		]
	],{expandedIntensities,expandedMaxRadii,centrifugeRateResolutions}]];

	(* Group each set of sample parameters by samples that will use the same centrifuge, time, temperature, force, bucket, rotor *)
	groupedSampleParameters = GatherBy[Transpose[{
		(*1*)expandedTargetContainers,
		(*2*)expandedTargetContainerModels,
		(*3*)expandedCentrifuges,
		(*4*)expandedTimes,
		(*5*)expandedForces,
		(*6*)expandedTemperatures,
		(*7*)expandedBuckets,
		(*8*)expandedRotors,
		(*9*)expandedSamples,
		(*10*)expandedChilledRotors
	}], {#[[3]], #[[4]], #[[5]], #[[6]], #[[7]], #[[8]]} &];

	(* Figure out how many batches each sample parameter group will needed to be divided into and the buckets each batch needs *)
	{batchesByParameterGroup, indexedBucketsByParameterGroup} = Transpose[Map[Function[sampleParameters,
		Module[{bucketPacket, rotorPacket,bucket,rotor,bucketPositions,rotorPositions,numberOfPositions,numberOfBatches,bucketPreResources,
			containerSampleComboCounts,uniqueContainers,containerRepeats,containersPerSet,numberOfContainersBySpin},

			(* Figure out the number of times each container-sample combo appears*)
			containerSampleComboCounts = Tally[Transpose[{sampleParameters[[All, 1]], sampleParameters[[All, 9]]}]];

			(* Figure out the unique containers that will be centrifuged *)
			uniqueContainers = DeleteDuplicates[sampleParameters[[All, 1]]];

			(* Figure out how many times each unique container will be centrifuged *)
			containerRepeats = uniqueContainers /. AssociationThread[containerSampleComboCounts[[All, 1, 1]], containerSampleComboCounts[[All, 2]]];

			(* Get the  bucket and rotor that this set of parameters uses *)
			bucket=sampleParameters[[1,7]];
			rotor=sampleParameters[[1,8]];

			(* get the packets for the buckets and rotors *)
			bucketPacket = fetchPacketFromFastAssoc[bucket, fastAssoc];
			rotorPacket = fetchPacketFromFastAssoc[rotor, fastAssoc];

			(* Get the number of bucket positions that this bucket has. If there is no bucket being used, default to 1. *)
			bucketPositions=If[NullQ[bucket],
				1,
				Length @ If[MatchQ[bucket, ObjectP[Model]],
					Lookup[fastAssocLookup[fastAssoc, bucket, Positions], Name, {}],
					DeleteCases[
						Lookup[fastAssocLookup[fastAssoc, bucket, {Model, Positions}], Name, {}],
						Alternatives @@ fastAssocLookup[fastAssoc, bucket, Contents][[All, 1]]
					]
				]
			];

			(* Get the number of rotor positions that this rotor has.*)
			rotorPositions = Length @ If[MatchQ[rotor, ObjectP[Model]],
				Lookup[fastAssocLookup[fastAssoc, rotor, Positions], Name, {}],
				DeleteCases[
					Lookup[fastAssocLookup[fastAssoc, rotor, {Model, Positions}], Name, {}],
					Alternatives @@ fastAssocLookup[fastAssoc, rotor, Contents][[All, 1]]
				]
			];

			(* Get the total number of positions that are available in this bucket/rotor combo.
			Assume that all of the containers will need a counterweight (i.e. cannot be balanced by another experiment container), so divide by 2.*)
			numberOfPositions=(bucketPositions*rotorPositions)/2;

			(* Assuming infinite space in the centrifuge, figure out how many spins we need and how many containers would be in each spin to accommodate replicates.
			(If container 1 is spun twice and container 2 is spun once, we need at least two spins, the first spin with 2 containers (container 1 and 2) and the second spin with one container (container 1)).
			Use this recursive function to generate a list with length equal to the number of spins and with each index indicating the number of containers in that spin. *)
			containersPerSet[containerRepeats:{_Integer ..}]:= containersPerSet[DeleteCases[(containerRepeats - 1), LessEqualP[0]], {Length[containerRepeats]}];
			containersPerSet[containerRepeats:{GreaterP[0, 1] ..}, setSizes:{_Integer ..}]:= containersPerSet[DeleteCases[(containerRepeats - 1), LessEqualP[0]], Append[setSizes, Length[DeleteCases[containerRepeats, LessEqualP[0]]]]];
			containersPerSet[containerRepeats:{}, setSizes:{_Integer ..}]:= setSizes;
			numberOfContainersBySpin = containersPerSet[containerRepeats];

			(* Figure out how many batches we need to divide the containers into keeping in mind that the same container can not be spun more than once per batch *)
			numberOfBatches=Total[Ceiling[#/numberOfPositions]&/@numberOfContainersBySpin];

			(* Also figure out how many buckets we need and make a list of {{bucketModel, index}..} to make resources later.
				We need one bucket per rotor slot (unless we aren't using buckets) *)
			bucketPreResources = MapIndexed[If[NullQ[bucket],{},{bucket, #2[[1]]}] &, Range[rotorPositions]];

			{numberOfBatches, bucketPreResources}
		]
	],groupedSampleParameters]];

	(* Get the spin time for each parameter group *)
	spinTimesByParameterGroup = groupedSampleParameters[[All, All, 4]][[All, 1]];

	(* Figure out the time needed for operators to set up the instrument (5 Min to set up each batch). *)
	operatorSetupTime = Total[batchesByParameterGroup*5 Minute];

	(* Figure out long we need the operator for centrifuging (we only need the operator for the run time if there is no processing).*)
	operatorSpinTime = Total[MapThread[
		If[#1 > 15 Minute,
			Nothing,
			(#1*#2)
		] &, {spinTimesByParameterGroup, batchesByParameterGroup}]
	];

	(* Figure out the total operator time for centrifuging *)
	operatorCentrifugingEstimate = operatorSetupTime + operatorSpinTime;

	(* Figure out how long each parameter group will need the centrifuge for. (5 Min to set up each batch, plus the spin time for each batch) *)
	centrifugeInstrumentTimeByParameterGroup = (batchesByParameterGroup*5 Minute) + (batchesByParameterGroup*spinTimesByParameterGroup);

	(* Figure out the centrifuge and rotors used for each parameter group *)
	centrifugesByParameterGroup = groupedSampleParameters[[All, All, 3]][[All, 1]];
	rotorByParameterGroup = groupedSampleParameters[[All, All, 8]][[All, 1]];
	chilledRotorByParameterGroup = groupedSampleParameters[[All, All, 10]][[All, 1]];

	(* Group the centrifuge times by centrifuge, and make rules relating each unique centrifuge to a resource. *)
	centrifugeToResourceRules = Rule[
		#[[1, 1]],
		Resource[
			Instrument -> #[[1, 1]],
			Time -> Total[#[[All, 2]]],
			Name -> CreateUUID[]
		]
	] & /@ GatherBy[Transpose[{centrifugesByParameterGroup, centrifugeInstrumentTimeByParameterGroup}], First];

	(* Group the rotor times by rotor objects, and make rules relating each unique rotor to a resource. *)
	(* Only the ultracentrifuge rotors need to have resources because all other rotors just sit in the centrifuge and therefore no need for resource picking *)
	rotorToResourceRules = Map[
		Which[
			(* For robotic primitive we don't need this resource*)
			roboticPrimitiveQ, {},
			MatchQ[fastAssocLookup[fastAssoc, #, Footprint], Alternatives[XPN80Rotor, SW32Bucket]],
				# -> Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]],
			True,
				# -> Link[#]
		]&,
		rotorByParameterGroup
	];

	(* In order to get tubes out of the ultracentrifuge carefully, we need to use pliers. *)
	(* Create resource rules that replace an ultracentrifuge rotor with the proper plier resource *)
	plierResourceReplaceRules = Map[
		Function[{rotorModel},
			Which[
				(* For robotic primitive we don't need this resource *)
				roboticPrimitiveQ, {},
				MatchQ[fastAssocLookup[fastAssoc, rotorModel, Footprint], XPN80Rotor],rotorModel -> Resource[Sample -> Model[Item, Plier, "1.5 Inch NeedNose Plier"], Rent -> True, Name -> "Plier for ultracentrifuge"],
				True,{}
			]
		],
		rotorByParameterGroup
	];

	(* Get the centrifuge and rotor resources indexed to the centrifuge option *)
	centrifugeResources = centrifuges /. centrifugeToResourceRules;
	rotorResources = rotors /.rotorToResourceRules;
	(* Importantly, it is okay for us to share the same plier across different samples b/c why not, so we only need one resource here *)
	plierResource = FirstCase[rotors /. plierResourceReplaceRules, _Resource, Null];

	(* Make the bucket resources. The index in indexedBucketsByParameterGroup makes sure that we make enough buckets to fill the rotor slots.
	We only make one resource per bucket model * the number of those buckets that are needed.
	Buckets can't be indexed to SamplesIn or ContainersIn since it is possible to have more buckets than containers
	(e.g. centrifuging 1 bucket, but you still need a second bucket for the counterweight). *)
	bucketResources = Resource[
		Sample->#[[1]],
		Rent->True,
		Name -> CreateUUID[]
	] & /@ DeleteCases[DeleteDuplicates[Flatten[indexedBucketsByParameterGroup, 1]], {}];

	(* Make resources for our adapters. *)
	(* Right now we just make new resources for each adapter that we need. We could optimize this a little more by *)
	(* only requesting unique adapters per batch. *)
	adapterResources = If[MatchQ[#,Null],
		Null,
		Resource[
			Sample->#,
			Name->CreateUUID[]
		]
	]&/@expandedAdapters;

	secondaryAdapterResources = If[MatchQ[#,Null],
		Null,
		Resource[
			Sample->#,
			Name->CreateUUID[]
		]
	]&/@expandedSecondaryAdapters;

	tertiaryAdapterResources = If[MatchQ[#,Null],
		Null,
		Resource[
			Sample->#,
			Name->CreateUUID[]
		]
	]&/@expandedTertiaryAdapters;

	(* We don't prepare resources for counterweight adapters because this is not the final resources we need. We can prepare the resources in compiler after we match the weights of different counters and decide the number of adapters to use. *)
	counterbalanceAdapterLinks = If[MatchQ[#,Null],
		Null,
		Link[#]
	]&/@expandedCounterbalanceAdapters;



	secondaryCounterbalanceAdapterLinks = If[MatchQ[#,Null],
		Null,
		Link[#]
	]&/@expandedCounterbalanceSecondaryAdapters;

	tertiaryCounterbalanceAdapterLinks = If[MatchQ[#,Null],
		Null,
		Link[#]
	]&/@expandedCounterbalanceTertiaryAdapters;


	(* Make the sample resources. We don't need to specify amount since the sample will not be consumed. SamplesIn use the input samples, not the simulated samples.*)
	samplesInResources=MapThread[
		If[
			MatchQ[#2,_String],
			Resource[
				Sample->Lookup[#1,Object],
				Name->#2
			],
			Resource[
				Sample->Lookup[#1,Object]
			]
		]&,
		{samplePackets,sampleLabel}
	];

	(* Build a look up for replace all later *)
	sampleToResourceRules=Rule@@@DeleteDuplicates[Transpose[{Lookup[samplePackets,Object],samplesInResources}]];

 	(* ContainersIn doesn't get turned into a resource. Use the container of the input samples, not of the simulated samples *)
	containersIn=DeleteDuplicates[Download[Lookup[samplePackets,Container],Object]];

	(* Build a sample container resource for  *)
	sampleContainerResources=MapThread[
		If[
			MatchQ[#2,_String],
			Resource[
				Sample->Download[#1,Object],
				Name->#2
			],
			Resource[
				Sample->Download[#1,Object]
			]
		]&,
		{Download[Lookup[samplePackets,Container],Object],sampleContainerLabel}
	];

	sampleContainerToResourceRules=Rule@@@DeleteDuplicates[Transpose[{Download[Lookup[samplePackets,Container],Object],sampleContainerResources}]];

	(* Resource gathering will only be necessary if this is not a subprotocol *)
	gatheringEstimate = If[NullQ[parentProtocol],
		1 Minute * Length[containersIn],
		1 Minute
	];

	(* 2 minutes for balance selection and tare weighing; 2 minutes for each container *)
	balancingEstimate = 2 Minute + (2 Minute * Length[containersIn]);

	(* Estimate total time spent setting up and running centrifuges *)
	centrifugingEstimate = Ceiling[Total[centrifugeInstrumentTimeByParameterGroup], 5 Minute];

	(* Returning materials will only be necessary if this is not a subprotocol; allow 1 min per container *)
	returningEstimate = If[NullQ[parentProtocol],
		1 Minute * Length[containersIn],
		1 Minute
	];

	(* Most of post-processing is spent running subprotocols; allow for 5 minutes that is actually spent in the centrifuge protocol *)
	postProcessingEstimate = If[imageSample,
		5 Minute,
		1 Minute
	];

	(* ExperimentMeasureWeight doesn't accept plates and also doesn't populate container weight (only sample weight and tare weight of the empty container).
	 So, we make resources for a balance and tare racks, have custom tasks in the procedure for measuring container weight, and have sections in the compile and parse for dealing with the weight data. *)
	balanceResource = Resource[
		Instrument -> Model[Instrument, Balance, "Ohaus EX6202"],
		Time -> (1 Minute * Length[containersIn])
	];

	(* Get all the racks from the cache*)
	allRacks = DeleteDuplicates[Lookup[Cases[cache,KeyValuePattern[{Object->ObjectP[Model[Container,Rack]],TareWeight->Except[Null]}]],Object]];

	allRackPackets=Experiment`Private`fetchPacketFromCache[#, cache]&/@allRacks;

	(* Get just the non-self standing container models (these are the ones that will need racks.) *)
	(* TODO: In the case that we actually need to weigh an adapter together with the container, we cannot check SelfStanding field of the container. Instead, we need to check footprint. Right now the Procedure instructions given to operators have been updated so that the adapters can be temporarily taken out for weighing. *)
	containerModelsNeedingRacks = DeleteDuplicates[Lookup[Cases[simulatedSampleContainerModelPackets, KeyValuePattern[SelfStanding -> False]], Object,{}]];
	containerModelsNeedingRacksPackets=Experiment`Private`fetchPacketFromCache[#, cache]&/@containerModelsNeedingRacks;
	containerModelsNeedingRacksFootprint=Lookup[#,Footprint, Null]&/@containerModelsNeedingRacksPackets;

	(* define lookup tables that contain rack models for commonly used CONTAINERS *)
	commonRackLookup={
		(*15mL Tube*)
		Model[Container,Vessel,"id:xRO9n3vk11pw"]->Model[Container,Rack,"id:R8e1PjRDbbo7"],
		(*50mL Tube*)
		Model[Container,Vessel,"id:bq9LA0dBGGR6"]->Model[Container,Rack,"id:GmzlKjY5EEdE"],
		(*2mL Tube - MicrocentrifugeTube*)
		Model[Container,Vessel,"id:3em6Zv9NjjN8"]->Model[Container,Rack,"id:vXl9j57WEJ8Z"],
		(*1.5mL Tube with 2mL Tube Skirt - MicrocentrifugeTube*)
		Model[Container,Vessel,"id:eGakld01zzpq"]->Model[Container,Rack,"id:vXl9j57WEJ8Z"],
		(*0.5mL Tube with 2mL Tube Skirt - MicrocentrifugeTube*)
		Model[Container,Vessel,"id:o1k9jAG00e3N"]->Model[Container,Rack,"id:vXl9j57WEJ8Z"]
	};

	(* define lookup tables that contain rack models for commonly used FOOTPRINTS *)
	commonFootprintToRackLookup={
		Conical15mLTube->Model[Container, Rack, "id:R8e1PjRDbbo7"], (*15mL Tube Stand*)
		Conical50mLTube->Model[Container, Rack, "id:GmzlKjY5EEdE"], (*50mL Tube Stand*)
		MicrocentrifugeTube->Model[Container, Rack, "id:vXl9j57WEJ8Z"], (*2mL Tube Stand*)
		Round9mLOptiTube->Model[Container, Rack, "id:n0k9mG8EWdNp"],
		Round32mLOptiTube->Model[Container, Rack, "id:GmzlKjY5EEdE"],
		Round94mLUltraClearTube->Model[Container, Rack, "id:zGj91a7NxY1j"]
	};

	(* get information about the racks *)
	(* Foorprint information *)
	availableRackFootprints = Map[
		Lookup[#, Positions, {}][[All,2]]&,
		allRackPackets
	];

	(* Get the holder that has an Open Footprint *)
	openRackFootprintQ = Map[
		MemberQ[#,Open]&,
		availableRackFootprints
	];
	defaultOpenHolder = FirstOrDefault[
		PickList[allRackPackets,openRackFootprintQ]
	];

	(* If the container is not SelfStanding, and we find a holder for it, we will need a holder, otherwise, this is Null *)
	potentialRacksByContainer=MapThread[
		Function[{containerModel,containerFootprint},
			(* If we're not InSitu, resolve a holder if necessary *)
				Module[
					{footprintCompatibleQ,bestHolder, possibleDefaultByModel, possibleDefaultByFootprint},

					(* check if we have any of the common situations. This is the same logic used in RackFinder *)
					possibleDefaultByModel = Lookup[commonRackLookup, containerModel];
					possibleDefaultByFootprint = Lookup[commonFootprintToRackLookup,containerFootprint];
					If[MemberQ[{possibleDefaultByModel,possibleDefaultByFootprint}, ObjectP[Model[Container, Rack]]],
						Return[
							ObjectP[containerModel] -> FirstCase[
								{possibleDefaultByModel,possibleDefaultByFootprint},
								ObjectP[Model[Container, Rack]]
							],
							Module
						]
					];

					(* if we have an uncommon case, we will usually need an uncommon rack. *)
					footprintCompatibleQ=Map[
						MemberQ[#,containerFootprint]&,
						availableRackFootprints
					];

					bestHolder=If[MemberQ[footprintCompatibleQ,True],
						(* If we get a compatible footprint *)
						First[PickList[allRacks,footprintCompatibleQ]],
						(* otherwise, fill in with the default rack *)
						defaultOpenHolder
					];

					ObjectP[containerModel] -> bestHolder
				]
		],
		{containerModelsNeedingRacks,containerModelsNeedingRacksFootprint}
	];

	(*A 15 mL tube and light sensitive 15mL tube will return the same set of potential tare racks, so get only the unique sets *)
	tareRackSets = DeleteCases[DeleteDuplicates[Values[potentialRacksByContainer]],{}];

	(* Make resources for any tube racks we need for weighing the containers. We only take the first allowed Model from the list of Racks as our Resource system no longer supports list of potential models. This is valid because empty list is deleted earlier. *)
	tareRackResources = Map[
		Resource[
			Sample -> #,
			Name -> CreateUniqueLabel["Tare Rack"],
			Rent -> True
		]&,tareRackSets
	];

	(* potentialRacksByContainer are a list of rules pointing from Model[Container] to a tare rack for that model. *)
	(* For each simulated working container look up its model and make the replacement. *)
	(* Add a catch all ObjectP if a tare rack is not needed. *)
	tareRackIndexMatched = Lookup[DeleteDuplicates[simulatedSampleContainerPackets], Model] /. Join[potentialRacksByContainer, {ObjectP[] -> Null}];

	(* Convert the index matched tare racks to resources. *)
	tareRackResourcesIndexMatched = tareRackIndexMatched /. MapThread[Rule[#1,#2]&, {tareRackSets,tareRackResources}];

	(* Get any indices that we've specified in our collection container options. *)
	collectionContainerIndices=DeleteDuplicates[Cases[collectionContainers, {_Integer, _}][[All,1]]];

	(* Map from these indices to UUIDs. *)
	collectionContainerIndicesToUUIDs=(#->CreateUUID[]&)/@collectionContainerIndices;

	(* Map from sample containers to UUIDs. *)
	sampleContainerToUUIDs=(#->CreateUUID[]&)/@DeleteDuplicates[Lookup[simulatedSampleContainerPackets,Object]];

	(* Create resources for our collection containers. *)
	(* We create a rule from the sample's container to the collection container resource since we want to have the *)
	(* collection container index matched to the sample's container. This will make this field index matched *)
	(* to WorkingContainers (since we're using the simulated sample containers here to delete duplicates. *)
	collectionContainerToResourceRules=MapThread[
		Function[{collectionContainer, sampleContainerPacket},
			Lookup[sampleContainerPacket,Object]->Switch[collectionContainer,
				ObjectP[{Object[Container]}],
				Resource[
					Sample->collectionContainer
				],
				ObjectP[{Model[Container]}],
				Resource[
					Sample->collectionContainer,
					Name->Lookup[
						sampleContainerToUUIDs,
						Lookup[sampleContainerPacket, Object]
					]
				],
				{_Integer, _},
				Resource[
					Sample->#[[2]],
					Name->Lookup[collectionContainerIndicesToUUIDs,#[[1]]]
				],
				_,
				Null
			]
		],
		{collectionContainers, simulatedSampleContainerPackets}
	];

	collectionContainerResources=DeleteDuplicates[Download[simulatedSampleContainerPackets,Object]]/.collectionContainerToResourceRules;

	(* Expand resources by the number of replicates *)
	{expandedSampleResource,expandedCentrifugeResources,expandedRotorResources} = expandByReplicates[replicates, {samplesInResources,centrifugeResources,rotorResources}];

	(* make the resource rules for the counterweights; this should be index matching with the samples *)
	uniqueCounterweightResourceRules = Map[
		(#->Resource[Sample->#,Name->CreateUUID[]])&,
		DeleteCases[DeleteDuplicates[Download[counterweight,Object]],Null]
	];
	counterweightResources = If[roboticPrimitiveQ,
		Download[counterweight,Object]/.uniqueCounterweightResourceRules,
		{}
	];

	counterweightToResourceRules=If[roboticPrimitiveQ,Rule@@@DeleteDuplicates[Transpose[{counterweight,counterweightResources}]],{}];

	(* Convert our adapters which were index-matched to samples above to be index-matched with containers *)
	{
		adapterResourcesIndexMatchedToContainer,
		secondaryAdapterResourcesIndexMatchedToContainer,
		tertiaryAdapterResourcesIndexMatchedToContainer,
		counterbalanceAdapterLinksIndexMatchedToContainer,
		secondaryCounterbalanceAdapterLinksIndexMatchedToContainer,
		tertiaryCounterbalanceAdapterLinksIndexMatchedToContainer
	} = Drop[
		Transpose[DeleteDuplicatesBy[Transpose[
			{
				adapterResources,
				secondaryAdapterResources,
				tertiaryAdapterResources,
				counterbalanceAdapterLinks,
				secondaryCounterbalanceAdapterLinks,
				tertiaryCounterbalanceAdapterLinks,
				expandedTargetContainers
			}
		], Last]], -1];

	(* --- Generate our unit operation protocol protocol packet --- *)
	(* fill in the protocol packet with all the resources *)
	{protocolPacket,unitOperationPackets} = If[MatchQ[preparation, Manual],
		Module[
			{
				innerPrococolPacket, innerUnitOperationPackets
			},

			(* we will leave the batched unit operation as the empty fields right now, they will be batched in the compiler *)

			innerUnitOperationPackets={};

			innerPrococolPacket=<|
				Object -> CreateID[Object[Protocol,Centrifuge]],
				Type -> Object[Protocol,Centrifuge],
				Replace[SamplesIn] -> expandedSampleResource,
				Replace[ContainersIn] -> (Link[Resource[Sample->#], Protocols]&)/@containersIn,
				Replace[Speeds] -> expandedRates,
				Replace[Forces] -> expandedForces,
				Replace[Centrifuges] -> expandedCentrifugeResources,
				Replace[Rotors] -> expandedRotorResources, (* Resources are only generated for ultracentrifuge rotors and not generated for other rotors because most rotors remain attached to associated centrifuges and are never gathered/placed *)
				Replace[Plier] -> plierResource,
				Replace[Buckets] -> bucketResources,
				Replace[CentrifugeAdapters]-> adapterResourcesIndexMatchedToContainer,
				Replace[SecondaryCentrifugeAdapters]-> secondaryAdapterResourcesIndexMatchedToContainer,
				Replace[TertiaryCentrifugeAdapters]-> tertiaryAdapterResourcesIndexMatchedToContainer,
				Replace[CounterbalanceAdapters] -> counterbalanceAdapterLinksIndexMatchedToContainer,
				Replace[SecondaryCounterbalanceAdapters] -> secondaryCounterbalanceAdapterLinksIndexMatchedToContainer,
				Replace[TertiaryCounterbalanceAdapters] -> tertiaryCounterbalanceAdapterLinksIndexMatchedToContainer,
				Replace[Times] -> expandedTimes,
				Replace[Temperatures] -> expandedTemperatures,
				Balance -> If[MatchQ[Lookup[myResolvedOptions,CounterbalanceWeight],{MassP..}],
					Null,
					balanceResource
				],
				Replace[TareRacks] -> If[MatchQ[Lookup[myResolvedOptions,CounterbalanceWeight],{MassP..}],
					{},
					tareRackResources
				],
				Replace[TareRacksIndexMatched] -> tareRackResourcesIndexMatched,
				Replace[CollectionContainers] -> collectionContainerResources,
				Replace[SamplesInStorage] -> Lookup[myResolvedOptions, SamplesInStorageCondition],
				Replace[CounterbalanceWeights] -> (Lookup[myResolvedOptions,CounterbalanceWeight]/.{{(Automatic|Null)..}->{}}),
				Replace[RotorGeometry] -> Lookup[myResolvedOptions,RotorGeometry]/.{FixedAngle->FixedAngleRotor,SwingingBucket->SwingingBucketRotor},
				Replace[Checkpoints] -> {
					{"Preparing Samples",5 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation,	filteration, and aliquoting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 5Minute]]},
					{"Picking Resources",gatheringEstimate,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> gatheringEstimate]]},
					{"Balancing Centrifuge",balancingEstimate,"Containers are weighed and counterweights are gathered to balance the centrifuge.", Link[Resource[Operator -> $BaselineOperator, Time -> balancingEstimate]]},
					{"Centrifuging Samples",centrifugingEstimate,"Samples are centrifuged.", Link[Resource[Operator -> $BaselineOperator, Time -> operatorCentrifugingEstimate]]},
					{"Sample Post-Processing",postProcessingEstimate,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> postProcessingEstimate]]},
					{"Returning Materials",returningEstimate,"Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> returningEstimate]]}
				},

				Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
				UnresolvedOptions -> myUnresolvedOptions,
				ResolvedOptions -> resolvedOptionsExpanded,
				Name->name,
				ImageSample -> Lookup[resolvedOptionsNoHidden, ImageSample],
				Sterile -> Lookup[resolvedOptionsNoHidden, Sterile],
				KeyDrop[populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache, Simulation -> updatedSimulation],Sterile]
			|>;

			(* Return the protocol packet and unit operation packet *)
			{innerPrococolPacket,innerUnitOperationPackets}
		],
		Module[
			{
				innerPrococolPacket, innerUnitOperationPackets,innerUnitOperationPacketWithLabeleds, newLabelSampleUO,
				oldResourceToNewResourceRules, labelSampleAndCentrifugeUnitOperationPackets,
				labelSampleUOPacket
			},

			(* get the new label sample unit operation if it exists; need to replace the models in it with the sample resources we've already created/simulated *)
			{newLabelSampleUO, oldResourceToNewResourceRules} = If[MatchQ[Lookup[myResolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}],
				generateLabelSampleUO[
					Lookup[myResolvedOptions, PreparatoryUnitOperations][[1, 1]],
					updatedSimulation,
					Join[expandedSampleResource, sampleContainerResources]
				],
				{Null, {}}
			];

			(* No protocol packets will be returned*)
			innerPrococolPacket={};
			labelSampleAndCentrifugeUnitOperationPackets = UploadUnitOperation[{
				If[NullQ[newLabelSampleUO], Nothing, newLabelSampleUO],
				Centrifuge@@{
					Sample->expandedSampleResource /. oldResourceToNewResourceRules,
					Intensity->expandedIntensities,
					Time->expandedTimes,
					SampleLabel->expandedSampleLabel,
					SampleContainerLabel->expandedSampleContainerLabel,
					Instrument->expandedCentrifugeResources,
					Temperature->expandedTemperatures,
					CollectionContainer->(expandedCollectionContainers/.collectionContainerToResourceRules),
					Counterweight->(expandedCounterweight/.counterweightToResourceRules),
					NumberOfReplicates->replicates
				}},
				Preparation->Robotic,
				UnitOperationType->Output,
				FastTrack->True,
				Upload->False
			];
			{labelSampleUOPacket, innerUnitOperationPackets} = If[NullQ[newLabelSampleUO],
				{Null, First[labelSampleAndCentrifugeUnitOperationPackets]},
				labelSampleAndCentrifugeUnitOperationPackets
			];


			innerUnitOperationPacketWithLabeleds=Append[
				innerUnitOperationPackets,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{sampleLabel, samplesInResources /. oldResourceToNewResourceRules}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Download[Lookup[samplePackets,Container],Object], (Download[Lookup[samplePackets,Container],Object]/.sampleContainerToResourceRules) /. oldResourceToNewResourceRules}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					]
				]
			];

			{innerPrococolPacket,{If[NullQ[labelSampleUOPacket], Nothing, labelSampleUOPacket], innerUnitOperationPacketWithLabeleds}}

		]
	];

	(* --- fulfillableResourceQ --- *)

	(* get all the resource blobs*)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	rawResourceBlobs = DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},

		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		roboticPrimitiveQ,{True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation->updatedSimulation, Cache->cache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Simulation->updatedSimulation, Messages -> messages,Cache->cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
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
		{protocolPacket, unitOperationPackets}/.resourceToNameReplaceRules,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];






(* ::Subsection::Closed:: *)
(*Simulation*)

(* ::Subsubsection::Closed:: *)
(*simulateExperimentCentrifuge*)

DefineOptions[
	simulateExperimentCentrifuge,
	Options:>{CacheOption, SimulationOption}
];

simulateExperimentCentrifuge[
	myResourcePacket : (PacketP[Object[Protocol, Centrifuge], {Object, ResolvedOptions}]|{}|$Failed),
	myUnitOperationPackets:({PacketP[]...}|{}|$Failed),
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentCentrifuge]
] := Module[
	{cache, simulation, listySamplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels,resolvedPreparation,
		manualProtocolPacket, workingContainerPackets, collectionContainerPackets, newCollectionContainerPositions,
		newCollectionContainerSamplePackets, workingContainerContentsPackets, simulationWithSamples, fulfillmentSimulationWithLabels,
		collectionContainerPacketsWithNewSamples, samplesToTransfer, samplesToTransferPackets, volumesToTransfer,
		positionsToTransferTo, samplesToTransferInto, uploadSampleTransferPackets, simulationWithTransfers},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];


	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[resolvedPreparation, Robotic],
			SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myResourcePacket, $Failed],
			SimulateCreateID[Object[Protocol,Centrifuge]],
		True,
			Lookup[myResourcePacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	fulfillmentSimulation = Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myResourcePacket, (Null|{})] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],


		MatchQ[myResourcePacket, $Failed],
			SimulateResources[
				<|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					ResolvedOptions -> myResolvedOptions
				|>,
				Simulation->simulation
			],
		True,
			SimulateResources[
				myResourcePacket,
				Null,
				Simulation->simulation
			]
	];

	(* HEREAFTER EVERYTHING IS MANUAL ONLY *)
	(* Ideally robotic would also do the simulation of stuff that went into the bottom part of the collection container through the filter, but ExperimentFilter[..., Preparation -> Robotic] already simulates that so there would be redundancy.  Probably worth straightening out at some point, but not done yet *)
	(* Download containers from our sample packets. *)
	{
		listySamplePackets,
		{{
			manualProtocolPacket,
			workingContainerPackets,
			collectionContainerPackets,
			workingContainerContentsPackets
		}}
	} = Quiet[Download[
		{
			mySamples,
			{protocolObject}
		},
		{
			{Packet[Container]},
			{
				Packet[CollectionContainers, WorkingContainers],
				Packet[WorkingContainers[Contents]],
				Packet[CollectionContainers[Contents]],
				Packet[WorkingContainers[Contents][[All, 2]][Position, Volume]]
			}
		},
		Cache -> cache,
		Simulation -> fulfillmentSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Download[Lookup[Flatten[listySamplePackets], Container],Object]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> If[MatchQ[resolvedPreparation, Manual],
			Join[
				Rule @@@ Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule @@@ Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* combine fulfillmentSimulation and simulationWithLabels *)
	fulfillmentSimulationWithLabels = UpdateSimulation[fulfillmentSimulation, simulationWithLabels];

	(* Merge our packets with our labels. *)
	(* if we're doing Robotic then we will just return early here *)
	If[MatchQ[resolvedPreparation, Robotic],
		Return[{
			protocolObject,
			UpdateSimulation[fulfillmentSimulation, simulationWithLabels]
		}]
	];

	(* for each collection container, get the position into which a new sample must be created *)
	newCollectionContainerPositions = If[MatchQ[collectionContainerPackets, {(PacketP[]|Null)..}],
		MapThread[
			Function[{workingContainerPacket, collectionContainerPacket},
				If[NullQ[collectionContainerPacket],
					Nothing,
					Map[
						If[MemberQ[Lookup[collectionContainerPacket, Contents][[All, 1]], First[#]],
							Nothing,
							First[#]
						]&,
						Lookup[workingContainerPacket, Contents]
					]
				]
			],
			{workingContainerPackets, collectionContainerPackets}
		],
		{}
	];

	(* make new samples in the collection container *)
	newCollectionContainerSamplePackets = If[MatchQ[newCollectionContainerPositions, {}],
		{},
		UploadSample[
			ConstantArray[{}, Length[Flatten[newCollectionContainerPositions]]],
			Join @@ MapThread[
				Function[{positions, containerPacket},
					Map[
						{#, Lookup[containerPacket, Object]}&,
						positions
					]
				],
				{newCollectionContainerPositions, DeleteCases[collectionContainerPackets, Null]}
			],
			Upload -> False,
			Simulation -> fulfillmentSimulation,
			UpdatedBy -> protocolObject,
			SimulationMode -> True
		]
	];

	(* update the simulation with the new samples *)
	simulationWithSamples = UpdateSimulation[fulfillmentSimulationWithLabels, Simulation[newCollectionContainerSamplePackets]];

	(* get the contents of the working containers and collection containers after making the new samples *)
	(* Download containers from our sample packets. *)
	collectionContainerPacketsWithNewSamples = Download[
		protocolObject,
		Packet[CollectionContainers[Contents]],
		Cache -> cache,
		Simulation -> simulationWithSamples
	];

	(* get the samples we're transferring to the bottom *)
	samplesToTransfer = If[MatchQ[collectionContainerPackets, {}],
		{},
		MapThread[
			Function[{workingContainerPacket, collectionContainerPacket},
				If[MatchQ[collectionContainerPacket, PacketP[]],
					Download[Lookup[workingContainerPacket, Contents][[All, 2]], Object],
					{}
				]
			],
			{workingContainerPackets, collectionContainerPacketsWithNewSamples}
		]
	];
	samplesToTransferPackets = Map[
		FirstCase[Flatten[workingContainerContentsPackets], ObjectP[#]]&,
		samplesToTransfer,
		{2}
	];

	(* get the volumes to transfer and the positions we're in *)
	volumesToTransfer = Lookup[#, Volume, {}]& /@ samplesToTransferPackets;
	positionsToTransferTo = Lookup[#, Position, {}]& /@ samplesToTransferPackets;

	(* get the samples that we're transferring into *)
	samplesToTransferInto = MapThread[
		Function[{collectionContainerPacket, positions},
			Map[
				Function[{position},
					Download[
						SelectFirst[Lookup[collectionContainerPacket, Contents], MatchQ[First[#], position]&][[2]],
						Object
					]
				],
				positions
			]
		],
		{collectionContainerPacketsWithNewSamples, positionsToTransferTo}
	];

	(* transfer the samples *)
	uploadSampleTransferPackets = If[MatchQ[Flatten[samplesToTransfer], {}],
		{},
		UploadSampleTransfer[
			Flatten[samplesToTransfer],
			Flatten[samplesToTransferInto],
			Flatten[volumesToTransfer],
			Upload -> False,
			FastTrack -> True,
			Simulation -> simulationWithSamples
		]
	];

	(* make a new simulation with the samples *)
	simulationWithTransfers = UpdateSimulation[simulationWithSamples, Simulation[uploadSampleTransferPackets]];

	{
		protocolObject,
		simulationWithTransfers
	}

];


(* ::Subsection::Closed:: *)
(*CentrifugeDevices - Options*)


DefineOptions[CentrifugeDevices,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Intensity,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units->Alternatives[RPM]],
					Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units->Alternatives[GravitationalAcceleration]]
				],
				Description -> "The rotational speed or the force that will be applied to the samples by centrifugation."
			},
			{
				OptionName -> Time,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units->Alternatives[Second, Minute, Hour]],
				Description -> "The amount of time for which the samples will be centrifuged."
			},
			{
				OptionName->Temperature,
				Default-> Automatic,
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Ambient]],
					Widget[Type->Quantity, Pattern:>RangeP[-10 Celsius,40Celsius], Units->Alternatives[Celsius, Fahrenheit, Kelvin]]
				],
				Description->"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged."
			},
			{
				OptionName->CollectionContainer,
				Default->Null,
				Description->"The container that should be stacked on the bottom of the sample's container to collect the filtrate passing through the filter container.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]}
					],
					{
						"Index" -> Alternatives[
							Widget[Type -> Number,Pattern :> GreaterEqualP[1, 1]],
							Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]}
							],
							Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic]]
						]
					}
				]
			}
		],
		{
			OptionName -> Preparation,
			Default -> Manual,
			Description -> "Indicates if centrifugation will be conducted on a liquid handler.",
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>PreparationMethodP
			]
		},
		WorkCellOption,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


(* ::Subsubsection::Closed:: *)
(*CentrifugeDevices - Messages*)


Error::OptionLengthDisagreement="The options `1` do not have the same length. Please check that the lengths of any listed options match.";


(* ::Subsubsection::Closed:: *)
(* CentrifugeDevices - Download Fields *)

centrifugeInstrumentDownloadFields[]:={MaxTime, MaxTemperature, MinTemperature, MaxRotationRate, MinRotationRate, CentrifugeType, AsepticHandling, Footprint, Positions, Name, MaxStackHeight, MaxWeight, SpeedResolution};

centrifugeRotorDownloadFields[]:={MaxRadius, MaxForce, MaxRotationRate, Footprint, Positions, StorageCondition, Name, MaxImbalance, AvailableLayouts, RotorType, DefaultStorageCondition, RotorAngle};

centrifugeBucketDownloadFields[]:={MaxRadius, MaxForce, MaxRotationRate, Footprint, Positions, MaxStackHeight, Name, MaxImbalance, AvailableLayouts, RotorType, DefaultStorageCondition, RotorAngle};

centrifugeAdapterDownloadFields[]:={Footprint, AdapterFootprint, Name};



(* ::Subsubsection::Closed:: *)
(*CentrifugeDevices*)


(* Overload with no container inputs (to find all centrifuges that can attain the desired settings, regardless of container) *)
CentrifugeDevices[myOptions:OptionsPattern[]]:=Module[{
	safeOps,outputSpecification,output,gatherTests,
	safeOpsTests,cacheOption,timeOption,temperatureOption,intensityOption,
	expandedTimeOption, expandedTemperatureOption, expandedIntensityOption,listedOptionLengths,
	optionLengthTest,allCentrifugableContainers,
	centrifugesByOptionsByContainer,centrifugeContainerSetsByOptions,
	resultOutput,downloadedStuff,expandedContainers,expandedTimeByContainer,expandedTemperatureByContainer,
	expandedIntensityByContainer,containerOptionSets,uniqueOptionSets,uniqueContainers,
	uniqueTimes,uniqueTemperatures,uniqueIntensity,centrifugeDevicesByUniqueSet,setRules,resultRules,
	centrifugeDevicesBySet,collectionContainerOption,expandedCollectionContainerOption,expandedCollectionContainerByContainer,
	uniqueCollectionContainer, safeOpsNamed, simulation,preparationMethod
},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[CentrifugeDevices,ToList[myOptions],AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[CentrifugeDevices,ToList[myOptions],AutoCorrect->False],{}}
	];

	(* Make sure we're working with a list of options and we replace all Names with IDs *)
	safeOps = sanitizeInputs[safeOpsNamed, Simulation -> Lookup[safeOpsNamed, Simulation]];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* retrieve preparation scale *)
	preparationMethod = Lookup[safeOps,Preparation,Manual];

	(* Pull out options and assign them to variables *)
	{cacheOption,simulation,timeOption,temperatureOption,intensityOption,collectionContainerOption}=Lookup[safeOps,{Cache,Simulation,Time,Temperature,Intensity,CollectionContainer}];

	(* This overload doesn't have any input, so we can't use the built in index matching checks to make sure the options are the right length/to expand the options.
	Instead, do this manually below. *)

	(* Figure out the length of each option that was provided as a list *)
	listedOptionLengths = If[ListQ[#], Length[#], Nothing] & /@ {timeOption, temperatureOption, intensityOption, collectionContainerOption};

	(* Give an error if there are any listed options with differing lengths *)
	optionLengthTest = If[!Length[DeleteDuplicates[listedOptionLengths]] > 1,
		(* If the option lengths all match, give a passing test *)
		If[gatherTests,
			Test["The lengths of all listed options are the same:",True,True],
			Nothing
		],

		(* Otherwise, give an error*)
		If[gatherTests,
			Test["The lengths of these listed options are the same "<>ToString[PickList[{Time,Temperature,Intensity},{timeOption, temperatureOption, intensityOption}, _List]]<>":",False,True],
			Message[Error::OptionLengthDisagreement,PickList[{Time,Temperature,Intensity},{timeOption, temperatureOption, intensityOption}, _List]];
			Nothing
		]
	];

	(* If there are any listed options with differing lengths return $Failed (or the tests up to this point)*)
	If[Length[DeleteDuplicates[listedOptionLengths]] > 1,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests,optionLengthTest}]
		}]
	];

	(* Expand any singleton options *)
	{expandedTimeOption, expandedTemperatureOption, expandedIntensityOption, expandedCollectionContainerOption}=If[ListQ[#], #, ConstantArray[#, Max[listedOptionLengths, 1]]] & /@ {timeOption, temperatureOption, intensityOption, collectionContainerOption};

	(* Downloaded stuff about the centrifuges/rotors/buckets that can be used to centrifuge each container model *)
	downloadedStuff = nonDeprecatedCentrifugeModelPackets["Memoization"];

	(* To speed things up, only *)

	(* Centrifuges and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the rotor/bucket/centrifuge combo in order to calculate force/speed limits, and this combo is container-specific.) *)
	allCentrifugableContainers = allCentrifugableContainersSearch["Memoization"];

	(* Expand the containers and options *)
	expandedContainers = ConstantArray[allCentrifugableContainers,Length[expandedTimeOption]];
	{expandedTimeByContainer, expandedTemperatureByContainer, expandedIntensityByContainer, expandedCollectionContainerByContainer} = Map[
		Flatten[Transpose[ConstantArray[#,Length[allCentrifugableContainers]]],1]&,
		{expandedTimeOption, expandedTemperatureOption, expandedIntensityOption,expandedCollectionContainerOption}
	];

	(* Get each container with its options *)
	containerOptionSets = Transpose[{Flatten[expandedContainers],expandedTimeByContainer, expandedTemperatureByContainer, expandedIntensityByContainer, expandedCollectionContainerByContainer}];

	(* Get just unique container-option sets. *)
	uniqueOptionSets = DeleteDuplicates[containerOptionSets];
	{uniqueContainers, uniqueTimes, uniqueTemperatures, uniqueIntensity, uniqueCollectionContainer} = Transpose[uniqueOptionSets];

	(* For each unique container-option set, call the container overload on all centrifugable container models *)
	centrifugeDevicesByUniqueSet = CentrifugeDevices[uniqueContainers,ReplaceRule[safeOps,{Time->uniqueTimes,Temperature->uniqueTemperatures,Intensity->uniqueIntensity,CollectionContainer->uniqueCollectionContainer,Cache->Cases[Flatten[downloadedStuff],PacketP[]]}]];

	(* Order the centrifuge devices result by the original expanded option sets by using rules that relate each original set and each result to its index in the unique sets *)
	setRules = MapIndexed[Rule[#1, #2[[1]]] &, uniqueOptionSets];
	resultRules = MapIndexed[Rule[#2[[1]], #1] &, centrifugeDevicesByUniqueSet];
	centrifugeDevicesBySet = (containerOptionSets /. setRules) /. resultRules;

	(* Partition the result to reflect the centrifuges for each option set for each possible container *)
	centrifugesByOptionsByContainer = TakeList[centrifugeDevicesBySet,Length /@ expandedContainers];

	(* For each option set, return the centrifuges that would work along with the containers that the centrifuge is compatible with *)
	centrifugeContainerSetsByOptions = Map[Function[centrifugesByContainer,
		With[{
		(* Organize the containers and the centrifuges that would work for each container with the given settings into a list of {centrifuge,container} pairs *)
			centrifugeContainerPairs=Flatten[
				MapThread[Function[{container, centrifuges},
					Map[Function[centrifuge,
						{centrifuge, container}
					], centrifuges]
				], {allCentrifugableContainers, centrifugesByContainer}
				], 1]
		},

		(* Organize the info into a list in the form {{centrifuge, {containers}} .. } *)
			Map[{#[[1, 1]], #[[All, 2]]} &, GatherBy[centrifugeContainerPairs, First]]]

	], centrifugesByOptionsByContainer];

	(* If none of the options were listed, remove one level of listing, otherwise return the centrifuge/container info as is *)
	resultOutput = If[MatchQ[listedOptionLengths,{}],
		First[centrifugeContainerSetsByOptions],
		centrifugeContainerSetsByOptions
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> resultOutput,
		Tests -> Flatten[{safeOpsTests,optionLengthTest}]
	}

];

(* Single container overload *)
CentrifugeDevices[myInput:ObjectP[{Model[Container],Object[Container],Object[Sample]}],myOptions:OptionsPattern[]]:=Module[{output},

	(* Call CentrifugeDevices on the listed inputs *)
	output=CentrifugeDevices[ToList[myInput],myOptions];

	(* If the result is $Failed, return that. Otherwise, get the unlisted output. *)
	If[MatchQ[output,$Failed],
		$Failed,
		FirstOrDefault[output,{}]
	]
];

(* Overload with container model/container/sample inputs (to find all centrifuges that can attain the desired settings AND fit the container) *)
CentrifugeDevices[myInputs : {ObjectP[{Model[Container], Object[Container], Object[Sample]}]..}, myOptions : OptionsPattern[]] := Module[
	{
		sanitizedInputs, safeOps, expandedSafeOps, outputSpecification, output, gatherTests, preparationMethod,
		safeOpsTests, validLengths, validLengthTests, cacheOption, timeOption, temperatureOption, intensityOption,
		compatibleCentrifugesByContainer,
		inputPackets, centrifugeEquipmentPackets, inputContainerFootprints, inputContainerCentrifugeEnsembles, centrifugeEnsemblesByType,
		centrifugeObjectPacketLookup, centrifugeEnsemblesPackets, inputModelContainerPackets, inputObjectContainerPackets,
		inputSamplePackets, collectionContainerPackets,
		collectionContainerOption, collectionContainerNoIndices, allCentrifugableContainers , fastAssoc,
		collectionContainerModelPackets, collectionContainerObjectPackets, simulation,

		inputModelContainers, inputObjectContainers, inputSamples, collectionContainerModels, collectionContainers,
		existingInputModelContainerPackets, existingInputObjectContainerPackets, existingInputSamplePackets,
		existingInputCollectionContainerModelPackets, existingInputCollectionContainerPackets,
		riffleAlternativesBoolsInputModelContainers, riffleAlternativesBoolsInputObjectContainers,
		riffleAlternativesBoolsInputSamples, riffleAlternativesBoolsCollectionContainerModels,
		riffleAlternativesBoolsCollectionContainers, remainingInputModelContainers, remainingInputObjectContainers,
		remainingInputSamples, remainingCollectionContainerModels, remainingCollectionContainers,
		remainingInputModelContainerPackets, remainingInputObjectContainerPackets, remainingInputSamplePackets,
		remainingCollectionContainerModelPackets, remainingCollectionContainerObjectPackets, safeOpsNamed

	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[CentrifugeDevices, ToList[myOptions], AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[CentrifugeDevices, ToList[myOptions], AutoCorrect -> False], {}}
	];

	(* Make sure we're working with a list of options *)
	{sanitizedInputs, safeOps} = sanitizeInputs[myInputs, safeOpsNamed, Simulation -> Lookup[safeOpsNamed, Simulation]];

	(* If the specified options don't match their patterns return $Failed  (or the tests up to this point)*)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[CentrifugeDevices, {sanitizedInputs}, safeOps, Output -> {Result, Tests}],
		{ValidInputLengthsQ[CentrifugeDevices, {sanitizedInputs}, safeOps], {}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}]
		}]
	];

	(* retrieve preparation scale *)
	preparationMethod = Lookup[safeOps, Preparation, Manual];

	(* Expand any safe ops *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[CentrifugeDevices, {ToList[sanitizedInputs]}, safeOps]];

	(* Pull out options and assign them to variables *)
	{cacheOption, simulation, timeOption, temperatureOption, intensityOption, collectionContainerOption} = Lookup[
		expandedSafeOps,
		{Cache, Simulation, Time, Temperature, Intensity, CollectionContainer}
	];

	(* Centrifuges and related parameters are stored in Model[Container,Plate]/Model[Container,Vessel]. Find all of these containers.
	(We need to know the rotor/bucket/centrifuge combo in order to calculate force/speed limits, and this combo is container-specific.) *)
	allCentrifugableContainers = allCentrifugableContainersSearch["Memoization"];


	fastAssoc = makeFastAssocFromCache[cacheOption];

	(* Get rid of any indices in the collection container option. *)
	(* This will leave us with Object[Container] and Model[Container]. *)
	(* get the Object too here *)
	collectionContainerNoIndices = Map[
		Switch[#,
			Automatic | {_, Automatic}, Automatic,
			{_Integer, _}, Download[#[[2]], Object],
			_, Download[#, Object]
		]&,
		collectionContainerOption
	];

	(* With the phasing out of CentrifugeCompatibility, which previously allowed direct downloading of centrifuge / rotor / bucket packets for each container,
		we must now do the following:
			- Get a list of all centrifuge-related objects (inst/rotor/bucket)
			- Download sample container model footprints along with relevant information from all the above models
			- Run centrifugesForFootprint on all footprints
			- Cases out the packets for each container's centrifuge, rotor, and bucket packets
			- For each container, transpose the lists of packets so we have: {{all centrifuge packets},{all rotor packets},{all bucket packets}}
	*)

	(* Downloaded stuff about the centrifuges/rotors/buckets that can be used to centrifuge each container model *)
	centrifugeEquipmentPackets = Cases[Flatten[nonDeprecatedCentrifugeModelPackets["Memoization"]], PacketP[]];

	(* get what we need to Download from *)
	inputModelContainers = Cases[ToList[sanitizedInputs], ObjectP[Model[Container]]];
	inputObjectContainers = Cases[ToList[sanitizedInputs], ObjectP[Object[Container]]];
	inputSamples = Cases[ToList[sanitizedInputs], ObjectP[Object[Sample]]];
	collectionContainerModels = Cases[collectionContainerNoIndices, ObjectP[Model[Container]]];
	collectionContainers = Cases[collectionContainerNoIndices, ObjectP[Object[Container]]];

	(* if any of the objects already exist in the fastAssoc, then just pull that instead *)
	existingInputModelContainerPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[#, fastAssoc]
		}&,
		inputModelContainers
	];
	existingInputObjectContainerPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Model], fastAssoc]
		}&,
		inputObjectContainers
	];
	existingInputSamplePackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, {Container, Model}], fastAssoc],
			fetchPacketFromFastAssoc[#, fastAssoc]
		}&,
		inputSamples
	];
	existingInputCollectionContainerModelPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[#, fastAssoc]
		}&,
		collectionContainerModels
	];
	existingInputCollectionContainerPackets = Map[
		{
			#,
			fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, Model], fastAssoc]
		}&,
		collectionContainers
	];

	(* get the RiffleAlternatives Booleans for the five cases here *)
	riffleAlternativesBoolsInputModelContainers = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputModelContainerPackets;
	riffleAlternativesBoolsInputObjectContainers = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputObjectContainerPackets;
	riffleAlternativesBoolsInputSamples = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputSamplePackets;
	riffleAlternativesBoolsCollectionContainerModels = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputCollectionContainerModelPackets;
	riffleAlternativesBoolsCollectionContainers = MatchQ[#[[2]], PacketP[Model[Container]]]& /@ existingInputCollectionContainerPackets;

	(* get the ones that are remaining *)
	remainingInputModelContainers = PickList[inputModelContainers, riffleAlternativesBoolsInputModelContainers, False];
	remainingInputObjectContainers = PickList[inputObjectContainers, riffleAlternativesBoolsInputObjectContainers, False];
	remainingInputSamples = PickList[inputSamples, riffleAlternativesBoolsInputSamples, False];
	remainingCollectionContainerModels = PickList[collectionContainerModels, riffleAlternativesBoolsCollectionContainerModels, False];
	remainingCollectionContainers = PickList[collectionContainers, riffleAlternativesBoolsCollectionContainers, False];

	(* Downloaded stuff about the centrifuges/rotors/buckets that can be used to centrifuge each container model *)
	{
		remainingInputModelContainerPackets,
		remainingInputObjectContainerPackets,
		remainingInputSamplePackets,
		remainingCollectionContainerModelPackets,
		remainingCollectionContainerObjectPackets
	} = If[MatchQ[{remainingInputModelContainers, remainingInputObjectContainers, remainingInputSamples, remainingCollectionContainerModels, remainingCollectionContainers}, {{}..}],
		(* Doing this short circuit because if the simulation is large, even if we are Downloading from {} it can still be slow*)
		{{}, {}, {}, {}, {}},
		Quiet[
			Download[
				{
					(* Inputs *)
					remainingInputModelContainers,
					remainingInputObjectContainers,
					remainingInputSamples,
					remainingCollectionContainerModels,
					remainingCollectionContainers
				},
				{
					{Object, Packet[Footprint, Dimensions, TareWeight, WellDepth]},
					{Object, Packet[Model[{Footprint, Dimensions, TareWeight, WellDepth}]]},
					{Object, Packet[Container[Model][{Footprint, Dimensions, TareWeight, WellDepth}]], Packet[Volume, Mass]},
					{Object, Packet[Footprint, Dimensions, TareWeight]},
					{Object, Packet[Model[{Footprint, Dimensions, TareWeight}]]}
				},
				Simulation -> simulation
			],
			{Download::FieldDoesntExist}
		]
	];

	(* use RiffleAlternatives to reassemble everything that we Downloaded here and already had *)
	inputModelContainerPackets = RiffleAlternatives[
		DeleteCases[existingInputModelContainerPackets, {_, $Failed|{}|<||>}],
		remainingInputModelContainerPackets,
		riffleAlternativesBoolsInputModelContainers
	];
	inputObjectContainerPackets = RiffleAlternatives[
		DeleteCases[existingInputObjectContainerPackets, {_, $Failed|{}|<||>}],
		remainingInputObjectContainerPackets,
		riffleAlternativesBoolsInputObjectContainers
	];
	inputSamplePackets = RiffleAlternatives[
		DeleteCases[existingInputSamplePackets, {_, $Failed|{}|<||>, _}|{_, _, $Failed|{}|<||>}],
		remainingInputSamplePackets,
		riffleAlternativesBoolsInputSamples
	];
	collectionContainerModelPackets = RiffleAlternatives[
		DeleteCases[existingInputCollectionContainerModelPackets, {_, $Failed|{}|<||>}],
		remainingCollectionContainerModelPackets,
		riffleAlternativesBoolsCollectionContainerModels
	];
	collectionContainerObjectPackets = RiffleAlternatives[
		DeleteCases[existingInputCollectionContainerPackets, {_, $Failed|{}|<||>}],
		remainingCollectionContainerObjectPackets,
		riffleAlternativesBoolsCollectionContainers
	];

	(* Thread out input information back into the order that we got it from the user. *)
	inputPackets = Download[ToList[sanitizedInputs], Object] /. Map[
		Function[{inList},
			Module[{sampleAmounts, sampleAmountsListed},
				If[Length[inList] > 2,
					sampleAmounts = inList[[3]];
					sampleAmountsListed = If[Not[MatchQ[sampleAmounts, _List]], {sampleAmounts}, sampleAmounts];
					inList[[1]] -> Append[inList[[2]], SampleAmounts -> sampleAmountsListed],
					inList[[1]] -> inList[[2]]
				]
			]
		],
		Join[inputModelContainerPackets, inputObjectContainerPackets, inputSamplePackets]
	];

	(* Extract centrifuge-specific packets for use in *)
	collectionContainerPackets = collectionContainerNoIndices /. ((#[[1]] -> #[[2]]&) /@ Join[collectionContainerModelPackets, collectionContainerObjectPackets]);

	(* Pull out footprints for input containers *)
	inputContainerFootprints = Lookup[inputPackets, Footprint];

	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo[preparationMethod, "preparationMethod"];
	];
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo[inputContainerFootprints, "inputContainerFootprints"];
	];
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo[Lookup[inputPackets, Object], "inputPackets-Object"];
	];

	(* Get centrifuge equipment ensembles (i.e., instrument/rotor(/bucket) combos for each input container,
	passing in downloaded centrifuge equipment packets as cache *)
	inputContainerCentrifugeEnsembles = If[MatchQ[preparationMethod, Manual],
		centrifugesForFootprint[
			inputContainerFootprints,
			(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions], Null], Null, Lookup[#, Dimensions][[3]]]&) /@ inputPackets,
			(If[MatchQ[#, Null] || MatchQ[Lookup[#, Dimensions], Null], Null, Lookup[#, Dimensions][[3]]]&) /@ collectionContainerPackets,
			centrifugeEquipmentPackets
		],
		(* list of workcell names indexed to the $OnDeckCentrifuges list *)

		(* For robotic centrifuge: 1. only plate is acceptable. 2. no rotor and bucket, plate will be send to desired location ondeck and inserted into the centrifuge directly *)
		With[{
			(* Filter $OnDeckCentrifuges based on workcell *)
			filteredOnDeckCentrifuges = Switch[Lookup[safeOps, WorkCell],
				STAR, {$OnDeckCentrifuges[[1]]},
				bioSTAR | microbioSTAR, {$OnDeckCentrifuges[[2]]},
				_, $OnDeckCentrifuges
			]},
			Map[
				If[
					MatchQ[#, Plate],
					{filteredOnDeckCentrifuges, ConstantArray[{Null}, Length[filteredOnDeckCentrifuges]], ConstantArray[{Null}, Length[filteredOnDeckCentrifuges]]},
					{{}, {}, {}}
				]&,
				inputContainerFootprints
			]
		]
	];
	(* echo some debugging information when running tests in manifold *)
	If[MatchQ[$UnitTestObject, ObjectP[]],
		Echo[inputContainerCentrifugeEnsembles, "inputContainerCentrifugeEnsembles"];
	];

	(* Transpose each input's possible centrifuge ensembles so that they're groups of {{all centrifuges},{all buckets}}*)
	(* Must first pad them out to length 6 with Nulls to account for the fact that there may not be buckets or adapters - We allow a total of 6 adapters *)
	centrifugeEnsemblesByType = If[
		MatchQ[preparationMethod, Manual],
		Map[
			If[Length[#] == 0, {{}, {}, {}}, Transpose[#]]&,
			Map[
				If[MatchQ[#, {ObjectP[Model[Instrument, Centrifuge]], ObjectP[Model[Container, CentrifugeRotor]], ObjectP[Model[Part, CentrifugeAdapter]], ___}],
					(* Must process differently if we get an adapter but no buckets. Otherwise adapter shows up at bucket position. After adding Null to the position of the bucket, we can PadRight to match the length *)
					PadRight[Join[#[[1 ;; 2]], {Null}, #[[3 ;;]]], 6, Null],
					PadRight[#, 6, Null]
				]&,
				inputContainerCentrifugeEnsembles,
				{2}
			]
		],

		(*For robotic preparation, no rotor and bucket, and the Footprint can only be Plate*)
		inputContainerCentrifugeEnsembles
	];

	(* Make a look up to replace all objects with packets as expected below *)
	centrifugeObjectPacketLookup = Rule[Lookup[#, Object], #]& /@ centrifugeEquipmentPackets;

	(* Replace all objects with their corresponding packets *)
	centrifugeEnsemblesPackets = ReplaceAll[centrifugeEnsemblesByType, centrifugeObjectPacketLookup];


	(* For each container input/option set combo, find the compatible centrifuges *)
	(* Outer MapThread: Iterate over containers, which may have multiple CentrifugeCompatibility entries *)
	(* Delete duplicate centrifuges for each container input/option set combo. It is possible to have
		duplicate centrifuges in each set because there are now multiple rotors of the same footprint
		that are technically usable in a given centrifuge (e.g. Microfuge 16 with FX241.5 and FA361.5) *)
	compatibleCentrifugesByContainer = DeleteDuplicates /@ MapThread[
		Function[{packets, desiredTime, desiredTemperature, desiredIntensity, collectionContainerPacket, inputPacket},
			(* Return {} if the inputPackets is not in allCentrifugableContainers *)
			(* Note: this is the case for deprecated or Quartz container which we can still resolve centrifuge based on footprint, but we should not proceed *)
			If[!MemberQ[allCentrifugableContainers, ObjectP[Lookup[inputPacket, Object]]],
				{},
			Module[
				{
					inputDimensions, inputTareWeight, inputWellDepth, collectionContainerWeight, collectionContainerDimensions,
					collectionContainerFootprint, inputSampleAmounts
				},

				(* assign variables we'll be needing here so we don't keep obtaining them again and again below *)
				{inputDimensions, inputTareWeight, inputWellDepth, inputSampleAmounts} = Lookup[inputPacket, {Dimensions, TareWeight, WellDepth, SampleAmount}, Null];
				collectionContainerWeight = If[Not[NullQ[inputTareWeight]] && Not[NullQ[collectionContainerPacket]],
					Lookup[collectionContainerPacket, TareWeight, inputTareWeight / 2],
					0 Gram
				];
				{collectionContainerDimensions, collectionContainerFootprint} = If[Not[NullQ[collectionContainerPacket]],
					Lookup[collectionContainerPacket, {Dimensions, Footprint}],
					{Null, Null}
				];

				(* Inner MapThread: Iterate over each centrifuge/rotor/bucket combination for each container *)
				MapThread[
					Function[{centrifugePacket, rotorPacket, bucketPacket},
						Module[
							{
								maxTime, maxTemperature, minTemperature, centrifugeMinRate, centrifugeMaxRate, rotorMaxRadius, bucketMaxRadius,
								maxRadius, rotorMaxForce, bucketMaxForce, centrifugeMinForce, centrifugeMaxForce, rotorMaxRate, bucketMaxRate,
								maxForce, maxRate, timeCompatible, temperatureCompatible, speedCompatible, forceCompatible, centrifugeType, typeCompatible,
								asepticHandling, stackCompatible, object, preparationMethodCompatible, weightCompatible, HiGCompatible
							},

							(* Get info about the centrifuge *)
							{object, maxTime, maxTemperature, minTemperature, centrifugeMinRate, centrifugeMaxRate, centrifugeType, asepticHandling} = Lookup[
								centrifugePacket,
								{Object, MaxTime, MaxTemperature, MinTemperature, MinRotationRate, MaxRotationRate, CentrifugeType, AsepticHandling},
								Null
							];

							(* Figure out the max radius of the rotor/bucket *)
							rotorMaxRadius = If[NullQ[rotorPacket], Null, Lookup[rotorPacket, MaxRadius]];
							bucketMaxRadius = If[NullQ[bucketPacket], Null, Lookup[bucketPacket, MaxRadius]];

							(* If there is a max radius for the bucket, use that as the overall max radius. Otherwise use the max radius of the rotor. If neither has a max radius, the value will be Null. If we are robotic, we can guess that value should instead be 100 Millimeter *)
							maxRadius = FirstCase[{bucketMaxRadius, rotorMaxRadius},
								DistanceP,
								If[MatchQ[preparationMethod, Robotic],
									100 Millimeter,
									Null
								]
							];

							(* Figure out the max force of the bucket and rotor *)
							rotorMaxForce = If[NullQ[rotorPacket], Null, Lookup[rotorPacket, MaxForce]];
							bucketMaxForce = If[NullQ[bucketPacket], Null, Lookup[bucketPacket, MaxForce]];

							(* Convert the min/max rates of the centrifuge to the min/max forces *)
							centrifugeMinForce = If[NullQ[maxRadius], Null, RPMToRCF[centrifugeMinRate, maxRadius]];
							centrifugeMaxForce = If[NullQ[maxRadius], Null, RPMToRCF[centrifugeMaxRate, maxRadius]];

							(* Convert the max forces of the rotor/bucket to max rates *)
							rotorMaxRate = If[NullQ[rotorPacket], Null, RCFToRPM[rotorMaxForce, maxRadius]];
							bucketMaxRate = If[NullQ[bucketPacket], Null, RCFToRPM[bucketMaxForce, maxRadius]];

							(* Figure out the overall max force and rate for the system *)
							maxForce = Min[DeleteCases[{centrifugeMaxForce, rotorMaxForce, bucketMaxForce}, Null]];
							maxRate = Min[DeleteCases[{centrifugeMaxRate, rotorMaxRate, bucketMaxRate}, Null]];

							(* Check if the desired time setting is less than the max time for this instrument *)
							timeCompatible = If[MatchQ[desiredTime, Automatic] || NullQ[maxTime],
								True,
								MatchQ[desiredTime, LessEqualP[maxTime]]
							];

							(* Check if the desired temperature setting is within the possible temperatures for this instrument *)
							(* NOTE: RangeP currently much faster than RangeQ due to recent speedups so be sure to use that one *)
							temperatureCompatible = If[MatchQ[desiredTemperature, Automatic],
								True,
								MatchQ[desiredTemperature, RangeP[minTemperature, maxTemperature]]
							];

							(* If intensity was specified as a rate, check if the setting is within the possible speeds for this instrument *)
							(* NOTE: RangeP currently much faster than RangeQ due to recent speedups so be sure to use that one *)
							speedCompatible = If[!MatchQ[desiredIntensity, GreaterP[0 RPM]],
								True,
								MatchQ[desiredIntensity, RangeP[centrifugeMinRate, maxRate]]
							];

							(* If intensity was specified as a force, check if the setting is within the possible speeds for this instrument *)
							(* NOTE: RangeP currently much faster than RangeQ due to recent speedups so be sure to use that one *)
							forceCompatible = If[!MatchQ[desiredIntensity, GreaterP[0 GravitationalAcceleration]],
								True,
								MatchQ[desiredIntensity, RangeP[centrifugeMinForce, maxForce]]
							];
							weightCompatible = Which[
								(* if centrifuge max weight is not defined, say true *)
								NullQ[Lookup[centrifugePacket, MaxWeight, Null]], True,
								(* if the centrifuge weight is defined but the plate weight is not, then say true *)
								NullQ[inputTareWeight], True,
								(* if the plate weight is defined, and the centrifuge max weight is defined, do the comparison *)
								And[
									MatchQ[inputTareWeight, MassP],
									MatchQ[Lookup[centrifugePacket, MaxWeight], MassP]
								],
								Module[{containerWeight, sampleMasses},
									(*get the sample volumes and *)
									(*calculate the mass of the samples *)
									sampleMasses = If[Not[NullQ[inputSampleAmounts]],
										Map[
											If[MassQ[Lookup[#, Mass]],
												Lookup[#, Mass],
												Lookup[#, Volume] * (0.997` Gram / Milliliter)
											]&,
											inputSampleAmounts
										],
										0 Gram
									];
									(*calculate the container weight *)
									containerWeight = Replace[Total[Cases[Flatten[{sampleMasses, inputTareWeight, collectionContainerWeight}], MassP]], {0 -> 0 Gram}, {0}];
									containerWeight < Lookup[centrifugePacket, MaxWeight]
								]
							];

							(* Make sure the centrifuge is not a quick spin (Touch) or integrated (AutomatedMicro) centrifuge when looking at CentrifugeTypeP *)
							(* Directly by pass this check if Preparation->Robotic *)
							typeCompatible = If[MatchQ[preparationMethod, Manual], MatchQ[centrifugeType, Tabletop | Micro | Ultra], True];
							(* Figure out if the bucket is compatible if a collection container is specified. *)

							stackCompatible = Which[
								(*If there is no collection container, we still check if the plate is compatible with the centrifuge
								because what if there's a really tall plate. *)
								MatchQ[collectionContainerPacket, Except[PacketP[]]],
								If[
									And[
										Not[NullQ[Lookup[centrifugePacket, MaxStackHeight, Null]]],
										MatchQ[inputDimensions, List[_Quantity, _Quantity, _Quantity]]
									],
									(* check if the plate is taller than the specified max height of the centrifuge. This field is specific to the automated centrifuges which have irreplaceable rotors, but they tend to have the biggest height limitations so that's why we are checking them *)
									MatchQ[inputDimensions[[3]], LessP[Lookup[centrifugePacket, MaxStackHeight]]],
									(* if the centrifuge does not have a MaxStackHeight then assume that this comparison is impossible to make and thus return true *)
									True
								],
								(* We have a collection container specified for a Model[Container, Vessel, Filter], we just assume it's fine since we don't have the fields for it anyway and yes we probably should do the calculations but for now we're not going to *)
								MatchQ[inputPacket, ObjectP[{Model[Container, Vessel, Filter], Object[Container, Vessel, Filter]}]], True,
								(* We have a collection container specified. *)
								(* if we are doing this robotically, need to make sure the plate stack *)
								(* make sure the dimensions of the plate are actually populated *)
								MatchQ[preparationMethod, Robotic] && Not[NullQ[inputDimensions]],
								And[
									MatchQ[inputDimensions[[3]] + collectionContainerDimensions[[3]], LessP[Lookup[centrifugePacket, MaxStackHeight, 48 Millimeter]]], (* Lookup the maximum stack height, assume its 48 millimeters if it doesnt exist *)
									MatchQ[collectionContainerFootprint, Plate]
								],
								(* The bucket must have a MaxStackHeight field specified and that must be greater than the height of the sample plate *)
								(* plus the height of the collection container. *)
								!MatchQ[bucketPacket, PacketP[]] || MatchQ[Lookup[bucketPacket, MaxStackHeight], Except[GreaterP[0 Millimeter]]],
								False,
								True,
								And[
									MatchQ[Lookup[bucketPacket, MaxStackHeight], GreaterP[inputDimensions[[3]] + collectionContainerDimensions[[3]]]],
									MatchQ[collectionContainerFootprint, Plate]
								]
							];

							(* special skirt length check for HiG because it has a pedestal insert *)
							(*skirt height of the plate in question must be longer than 1 mm so the plate won't fly off the pedestal *)
							HiGCompatible = If[
								And[
									MatchQ[Lookup[centrifugePacket, Object], Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]],
									MatchQ[inputDimensions, List[_Quantity, _Quantity, _Quantity]],
									MatchQ[inputWellDepth, _Quantity]
								],
								(* if we are using the HiG and we have the dimensions and well depth, then make the comparison *)
								If[
									MatchQ[inputDimensions[[3]] - inputWellDepth, GreaterP[0.99 Millimeter]],
									True,
									False
								],
								(* we don't have the means to make the comparison so just assume True *)
								True
							];

							(* preparation method compatible *)
							preparationMethodCompatible = If[
								MatchQ[preparationMethod, Robotic], MemberQ[$OnDeckCentrifuges, object],
								!MemberQ[$OnDeckCentrifuges, object]
							];

							(* If the centrifuge is compatible on all settings, return the centrifuge object. Otherwise return nothing. *)
							If[MatchQ[{timeCompatible, temperatureCompatible, speedCompatible, forceCompatible, typeCompatible, stackCompatible, preparationMethodCompatible, weightCompatible, HiGCompatible}, {True..}],
								Lookup[centrifugePacket, Object, Nothing],
								Nothing
							]
						]
					],
					(* Each 'packets' entry is a set of {{centrifuge packet..}, {rotor packet..}, {bucket packet..}} that is index matched and set for MapThreading*)
					(* converting all times to seconds and all weights to grams*)
					packets
				]
			]]
		],
		{centrifugeEnsemblesPackets, timeOption, (temperatureOption /. {Ambient -> $AmbientTemperature}), intensityOption, collectionContainerPackets, inputPackets}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> compatibleCentrifugesByContainer,
		Tests -> Flatten[{safeOpsTests, validLengthTests}]
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugeOptions*)


DefineOptions[ExperimentCentrifugeOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentCentrifuge}];

ExperimentCentrifugeOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for ExperimentCentrifuge *)
	options=ExperimentCentrifuge[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentCentrifuge],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCentrifugeQ*)


DefineOptions[ValidExperimentCentrifugeQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentCentrifuge}
];


ValidExperimentCentrifugeQ[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, ExperimentCentrifugeNewTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentCentrifuge *)
	ExperimentCentrifugeNewTests = ExperimentCentrifuge[myInputs, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[ExperimentCentrifugeNewTests, $Failed],
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
			Flatten[{initialTest, ExperimentCentrifugeNewTests, voqWarnings}]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentCentrifugeQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentCentrifugeQ"]
];



(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugePreview*)


DefineOptions[ExperimentCentrifugePreview,
	SharedOptions :> {ExperimentCentrifuge}
];

ExperimentCentrifugePreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentCentrifuge *)
	ExperimentCentrifuge[myInputs, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsubsection::Closed:: *)
(*allCentrifugeEquipmentSearch*)

(* Function to search the database for all non-deprecated centrifuge instruments, rotors, and buckets.
 	Memoizes the result after first execution to avoid repeated database trips within a single kernel session. *)
allCentrifugeEquipmentSearch[fakeString:_String] := allCentrifugeEquipmentSearch[fakeString] = Module[{},
	(*Add allCentrifugeEquipmentSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allCentrifugeEquipmentSearch];

	Search[
		{
			{Model[Instrument, Centrifuge]},
			{Model[Container, CentrifugeRotor]},
			{Model[Container, CentrifugeBucket]},
			{Model[Part, CentrifugeAdapter]}
		},
		Deprecated!=True && DeveloperObject != True
	]
];
(* Function to search the database for all non-deprecated centrifuges and related parameters that are stored in
	Model[Container,Plate]/Model[Container,Vessel] to download stuff from, since might transfer into one of them.
	Memoizes the result after first execution to avoid repeated database trips within a single kernel session.
	*)
allCentrifugableContainersSearch[fakeString:_String]:=allCentrifugableContainersSearch[fakeString]=Module[{compatibleObjs},
	(*Add allCentrifugableContainersSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allCentrifugableContainersSearch];
	compatibleObjs = Search[
		{
			Model[Container, Plate],
			Model[Container, Vessel],
			Model[Container, Vessel, Filter]
		},
		{
			(* we definitely do not allow open plates to be centrifuged *)
			And[
				Deprecated != True,
				OpenContainer != True,
				Footprint == CentrifugeableFootprintP,
				ContainerMaterials != Quartz,
				DeveloperObject != True,
				Or[
					MaxCentrifugationForce == Null,
					MaxCentrifugationForce >= 1 GravitationalAcceleration
				]
			],
			(* we definitely do not allow open vessels to be centrifuged *)
			And[
				Deprecated != True,
				OpenContainer != True,
				Footprint == CentrifugeableFootprintP,
				ContainerMaterials != Quartz,
				DeveloperObject != True,
				Or[
					MaxCentrifugationForce == Null,
					MaxCentrifugationForce >= 1 GravitationalAcceleration
				]
			],
			(* we allow open container filter as long as we are sure it is a filter, DestinationContainerModel is populated *)
			And[
				Deprecated != True,
				OpenContainer == True,
				DestinationContainerModel != Null,
				Footprint == CentrifugeableFootprintP,
				ContainerMaterials != Quartz,
				DeveloperObject != True,
				Or[
					MaxCentrifugationForce == Null,
					MaxCentrifugationForce >= 1 GravitationalAcceleration
				]
			]
		}
	];
	
	(* return a flatten list *)
	Flatten[compatibleObjs]

];

(* Find all possible racks (we need this for making resources to hold containers for weighing)
 Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allRacksSearch[fakeString:_String] :=allRacksSearch[fakeString] = Module[{},
	(*Add allRacksSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allRacksSearch];
	Search[Model[Container, Rack], Deprecated!=True&&DeveloperObject!=True&&Length[Objects]>5, SubTypes -> False]
];

(* Find all the counterweights
Memoizes the result after first execution to avoid repeated database trips within a single kernel session.*)
allCounterweightsSearch[fakeString:_String] := allCounterweightsSearch[fakeString] = Module[{},
	(*Add allCounterweightsSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allCounterweightsSearch];
	Search[Model[Item, Counterweight], DeveloperObject != True]
];

(*Function to download all the necessary centrifuge info as packets and memoize the results to prevent multiple downloads in a single kernel session*)
(* NOTE: These are the non-deprecated model packets that we ALWAYS download so we memoize it. *)
nonDeprecatedCentrifugeModelPackets[fakeString:_String]:=nonDeprecatedCentrifugeModelPackets[fakeString]=Module[
	{centrifugeInstruments,centrifugeRotors,centrifugeBuckets,centrifugeAdapters,
		thingsToDownload,allCentrifugableContainers,allRacks,allCounterweights,
		modelContainerFields,
		centrifugeModelFields,centrifugeRotorModelFields,centrifugeBucketModelFields,centrifugeAdapterModelFields,
		fieldsToDownload,downloadedStuff,downloadedPackets
		},
	(*Add nonDeprecatedCentrifugeModelPackets to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`nonDeprecatedCentrifugeModelPackets];
	(* Search for all centrifuge models in the lab to download from. *)
	{
		centrifugeInstruments,
		centrifugeRotors,
		centrifugeBuckets,
		centrifugeAdapters
	}=allCentrifugeEquipmentSearch["Memoization"];

	(* Search for all centrifuge container models in the lab to download from. *)
	allCentrifugableContainers=allCentrifugableContainersSearch["Memoization"];

	(* Search for all container rack models in the lab to download from. *)
	allRacks=allRacksSearch["Memoization"];

	(* Search for all container rack models in the lab to download from. *)
	allCounterweights=allCounterweightsSearch["Memoization"];

	(* Format the list of things to download *)
	thingsToDownload = Join[
		{
			ToList[allCentrifugableContainers],
			allRacks,
			allCounterweights
		},
		{centrifugeInstruments},
		{centrifugeRotors},
		{centrifugeBuckets},
		{centrifugeAdapters}
	];


	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* Centrifuge equipment fields *)
	centrifugeModelFields = centrifugeInstrumentDownloadFields[];
	centrifugeRotorModelFields = centrifugeRotorDownloadFields[];
	centrifugeBucketModelFields = centrifugeBucketDownloadFields[];
	centrifugeAdapterModelFields = centrifugeAdapterDownloadFields[];

	(* Format the fields to download *)
	fieldsToDownload = {

		{
			Packet[Name, MaxVolume, NumberOfWells, Footprint, Sterile, Deprecated, AspectRatio, SelfStanding, Dimensions, InternalDepth, InternalDiameter, Positions, PoreSize, MolecularWeightCutoff, PrefilterPoreSize, MembraneMaterial, PrefilterMembraneMaterial, MinVolume, FilterType, Aperture, OpenContainer, InternalDimensions, MaxTemperature]
		},
		{
			Packet[Positions, AvailableLayouts, TareWeight, Name]
		},
		{
			Packet[Footprint, Weight, Name, RentByDefault]
		},
		{Packet[Sequence @@ centrifugeModelFields]},
		{Packet[Sequence @@ centrifugeRotorModelFields]},
		{Packet[Sequence @@ centrifugeBucketModelFields]},
		{Packet[Sequence @@ centrifugeAdapterModelFields]}
	};

	(* Download the fields that we need. *)
	downloadedStuff = Quiet[
		Download[
			thingsToDownload,
			fieldsToDownload,
			Date -> Now
		],
		{Download::NotLinkField,Download::FieldDoesntExist}
	];

	(*Flatten our packets.*)
	downloadedPackets=Flatten/@downloadedStuff;

	(*Return our packets*)
	downloadedPackets
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentCentrifugeWorkCell*)


(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveExperimentCentrifugeWorkCell,
	SharedOptions:>{
		ExperimentCentrifuge,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(*resolveExperimentCentrifugeWorkCell*)

resolveExperimentCentrifugeWorkCell[
	myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]], myOptions : OptionsPattern[]
] := Module[{workCell, allowedInstruments, userChosenInstrument, usableCentrifugeDevices, hasHiG, hasVSpin},

	workCell = Lookup[myOptions, WorkCell, Automatic];

	userChosenInstrument = Lookup[myOptions, Instrument, {}];
	(*determine if the list of instruments has hig or vspin *)
	usableCentrifugeDevices = Flatten[DeleteDuplicates[Which[
		(* if a set of instruments is passed in, use those only *)
		MatchQ[userChosenInstrument, {ObjectP[] ..}],
		userChosenInstrument,
		(*else, figure out which centrifuges can be used from inputted options. For now the only difference between
		hig and vspin is the speed it can spin, so that is the only thing we are checking *)
		True,
		CentrifugeDevices[myContainers,
			Intensity -> Lookup[myOptions, Intensity, Automatic],
			(* this is a workcell selector so assume robotic *)
			Preparation -> Robotic,
			Cache -> Lookup[myOptions, Cache],
			Simulation -> Lookup[myOptions, Simulation]
		]
	]]];

	hasHiG = MemberQ[usableCentrifugeDevices, ObjectP[Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]]];
	hasVSpin = MemberQ[usableCentrifugeDevices, ObjectP[Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]]];
	(* Determine the WorkCell that can be used: *)
	Which[
		MatchQ[workCell, Except[Automatic]], {workCell},
		(* The VSpin is only available on the STAR *)
		And[hasVSpin, Not[hasHiG]], {STAR},
		(* The HiG4 is only available in bioSTAR and microbioSTAR. *)
		And[hasHiG, Not[hasVSpin]], {bioSTAR, microbioSTAR},
		(* All *)
		True, {STAR, bioSTAR, microbioSTAR}
	]
];

(* ::Subsubsection::Closed:: *)
(*resolveCentrifugeMethod*)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveCentrifugeMethod,
	Options :> {
		{
			OptionName->FromExperimentCentrifuge,
			Default-> False,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type -> Enumeration,Pattern :> BooleanP]
			],
			Description->"Indicates if this function is called inside of ExperimentCentrifuge (in which case we have all the Cache information and thus don't need to Download again).",
			Category->"Hidden"
		}
	},
	SharedOptions:>{
		ExperimentCentrifuge,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* Error message for resolveCentrifugeMethod*)
Error::ConflictingCentrifugeMethodRequirements="The following option(s)/input(s) were specified that require a Manual Preparation method, `1`. However, the following option(s)/input(s) were specified that require a Robotic Preparation method, `2`. Please resolve this conflict in order to submit a valid Centrifuge protocol.";

(* Build a global constant for ondeck centrifuges *)
$OnDeckCentrifuges = {

	(* VSpin *)
	Model[Instrument, Centrifuge,"id:vXl9j57YaYrk"],
	(*HiG4*)
	Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]
};

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveCentrifugeMethod[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}]|Automatic], myOptions : OptionsPattern[]] := Module[
	{containerPackets, samplePackets, instrument, collectionContainer, allModelContainerPackets, collectionContainerObjPackets,
		collectionContainerModelPackets, allallowedInstrumentPackets, instrumentModelPackets, allModelContainerPlatePackets, liquidHandlerIncompatibleContainers,
		intensity,temperature, safeOps, manualOnlyOptions, manualRequirementStrings, roboticRequirementStrings,
		maxOndeckRotationRate,result,tests,counterbalanceWeight, outputSpecification,allInstrumentModels,fromExperimentCentrifugeQ,
		innerCache,innerSimulation,suppliedPreparation,output,gatherTests, fastAssoc
	},


	(* get the safe options *)
	safeOps = SafeOptions[resolveCentrifugeMethod, ToList[myOptions]];

	(* Cache needs to match the pattern (Automatic|Session|Download|{(_Association|Null)...})*)
	innerCache=Lookup[safeOps, Cache, {}];
	fastAssoc = makeFastAssocFromCache[innerCache];
	fromExperimentCentrifugeQ = Lookup[safeOps, FromExperimentCentrifuge];

	(* Simulation needs to match the pattern (Null | SimulationP) *)
	innerSimulation=Lookup[ToList[myOptions], Simulation, Null];

	(* Fetch the information we need from the options *)
	{
		instrument,
		intensity,
		temperature,
		collectionContainer,
		counterbalanceWeight
	}=Lookup[
		ToList[myOptions],
		{
			Instrument,
			Intensity,
			Temperature,
			CollectionContainer,
			CounterbalanceWeight
		}
	];
	(* Generate the output specification*)

	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	
	(* check if we need to return test *)
	gatherTests=MemberQ[output,Tests];
	(* get user specified Preparation *)
	suppliedPreparation=Lookup[safeOps, Preparation];

	(* Pickout those options that can only be applied to the manual primitives*)
	manualOnlyOptions = Select[
		{
			RotorAngle,
			ChilledRotor
		},
		(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]]&)
	];

	containerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[ToList[myContainers], ObjectP[Object[Container]]];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[ToList[myContainers], ObjectP[Object[Sample]]];
	collectionContainerObjPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[ToList[collectionContainer],ObjectP[Object[Container]]];
	collectionContainerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[ToList[collectionContainer],ObjectP[Model[Container]]];
	allallowedInstrumentPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ $OnDeckCentrifuges;
	instrumentModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[ToList[instrument],ObjectP[Object[Instrument]]];

	(* Download information that we need from our inputs and/or options. *)
	(* if FromExperimentCentrifuge -> True, then we've already Downloaded this information and don't need to do it again *)
	{
		containerPackets,
		samplePackets,
		collectionContainerObjPackets,
		collectionContainerModelPackets,
		allallowedInstrumentPackets,
		instrumentModelPackets
	} = If[Not[fromExperimentCentrifugeQ],
		Quiet[
			Download[
				{
					Cases[ToList[myContainers], ObjectP[Object[Container]]],
					Cases[ToList[myContainers], ObjectP[Object[Sample]]],
					Cases[ToList[collectionContainer],ObjectP[Object[Container]]],
					Cases[ToList[collectionContainer],ObjectP[Model[Container]]],
					$OnDeckCentrifuges,
					Cases[ToList[instrument],ObjectP[Object[Instrument]]]
				},
				Evaluate[{
					{Packet[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]},
					{Packet[Container,Name, LiquidHandlerIncompatible, Position], Packet[Container[Model[{Name, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]]},
					{Packet[Model[{Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]},
					{Packet[Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix]},
					{Packet[MaxRotationRate,MinRotationRate]},
					{Packet[Model]}
				}],
				Cache ->innerCache,
				Simulation ->innerSimulation,
				Date->Now
			],
			{Download::NotLinkField,Download::FieldDoesntExist}
		],
		{
			containerPackets,
			samplePackets,
			collectionContainerObjPackets,
			collectionContainerModelPackets,
			allallowedInstrumentPackets,
			instrumentModelPackets
		}
	];

	(* Get all of our Model[Container]s and look at their footprints. *)
	allModelContainerPackets = Cases[Flatten[{containerPackets, samplePackets,collectionContainerObjPackets,collectionContainerModelPackets}], PacketP[Model[Container]]];
	allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];
	(* Get the containers that are liquid handler incompatible (robotic liquid handler only accepts plate) *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[Plate]]],Object,{}],
			Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];

	(* check if instrument model are allowed*)
	allInstrumentModels=Join[
		Download[
			Lookup[
				Cases[Flatten[{allallowedInstrumentPackets}], PacketP[Object[Instrument]]],
				Model,
				{}
			],
			Object
		],
		Cases[ToList[instrument],ObjectP[Model[Instrument]]]
	];

	(* Retrieve the max allowed RPM for ondeck centrifuge  *)
	maxOndeckRotationRate=Max[Flatten[Lookup[Flatten[allallowedInstrumentPackets], MaxRotationRate]]];

	(* make a boolean for if it is ManualSamplePreparation or not *)
	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the sample/collection containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not compatible plates for liquid handlers and the integrated centrifuges",
			Nothing
		],
		If[Length[Cases[allInstrumentModels, Except[Alternatives@@$OnDeckCentrifuges]]]>0,
			"the specified instrument "<>ToString[Cases[allInstrumentModels, Except[Alternatives@@$OnDeckCentrifuges]]]<>" are not integrated to any of the liquid handler",
			Nothing
		],
		If[Length[Cases[ToList[intensity], GreaterP[maxOndeckRotationRate]]]>0,
			"specified intensity can only be achieved manually",
			Nothing
		],
		If[Length[Cases[ToList[temperature], Except[Ambient|$AmbientTemperature|Automatic]]]>0,
			"robotic centrifuge can only spin at room temperature",
			Nothing
		],
		If[Length[manualOnlyOptions]>0,
			"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
			Nothing
		],
		If[MemberQ[Lookup[Flatten[samplePackets/.{Null->Nothing}], LiquidHandlerIncompatible,Null], True],
			"the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[samplePackets, KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->Flatten[samplePackets]],
			Nothing
		],
		If[MemberQ[safeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		(* NOTE: No centrifuge prep options for ExperimentCentrifuge. *)
		If[MemberQ[safeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOps, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MatchQ[Lookup[safeOps, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[safeOps, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		MatchQ[suppliedPreparation, Except[Automatic]], suppliedPreparation,
		Length[manualRequirementStrings]>0,	Manual,
		Length[roboticRequirementStrings]>0,	Robotic,
		True,{Manual, Robotic}
	];
	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Centrifuge primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}

];


(* ::Subsubsection::Closed:: *)
(*centrifugesForFootprint*)

(* centrifugesForFootprint: traverses footprint graph for all provided centrifuge-related containers starting at the provided footprint(s)
and returns a list of paths terminating at centrifuges for the provided footprint(S)
This is a replacement for the CentrifugeCompatibility field that was phased out in favor of using the footprint system

	Inputs:
		myFootprint(s): Footprint(s) to use as starting point
		myCentrifugeEquipmentPackets: List of packets of all centrifuge instruments/rotors/buckets that should be considered for use
			- Packets must contain Footprint (where applicable) and Positions fields
	Outputs:
		For each provided footprint, a list of centrifuge-anchored paths that represent sets of centrifuges/rotors/buckets that can be used to spin a container
		of that footprint
	*)
centrifugesForFootprint[myFootprint:FootprintP|Null, sampleContainerHeight:DistanceP, collectionContainerHeight:DistanceP, myCentrifugeEquipmentPackets:{PacketP[]..}] := FirstOrDefault[
	centrifugesForFootprint[{myFootprint}, {sampleContainerHeight}, {collectionContainerHeight}, myCentrifugeEquipmentPackets]
];
centrifugesForFootprint[myFootprints:{(FootprintP|Null)..}, sampleContainerHeights_List, collectionContainerHeights_List, myCentrifugeEquipmentPackets:{PacketP[]..}] := Module[
	{cache, uniqueFootprints, rawPathsLists, flattenedPathsLists, reversedPathsLists, culledPathsLists,innterPacket,
	pathsPerFootprint, footprintPathLookup, possibleCentrifugePaths},

	(* Delete duplicate footprints so we only do the work once per footprint *)
	(* Exclude 'Null' -- we'll hard-code Null->{} at the end *)
	uniqueFootprints = DeleteCases[DeleteDuplicates[myFootprints], Null];

	(* Get raw paths *)
	(* ONLY pass centrifuge-relevant containers in via cache to keep from having to do this in the recursive function *)
	rawPathsLists = Map[
		rawCentrifugeFootprintPaths[#, myCentrifugeEquipmentPackets]&,
		uniqueFootprints
	];

	(* Get rid of extra listing from recursive search by grabbing innermost lists *)
	flattenedPathsLists = Cases[#, {Except[_List]..}, Infinity]& /@ rawPathsLists;

	(* Reverse all paths to read from biggest to smallest *)
	reversedPathsLists = Map[Reverse, flattenedPathsLists, {2}];

	(* Remove any paths that don't start with a Model[Instrument, Centrifuge] *)
	pathsPerFootprint = DeleteCases[#, Except[{ObjectP[Model[Instrument, Centrifuge]], ___}]]& /@ reversedPathsLists;

	(* Generate a lookup to convert Footprint -> Paths *)
	footprintPathLookup = Append[
		AssociationThread[uniqueFootprints, pathsPerFootprint],
		Null->{}
	];

	(* Look up the list of possible centrifuge paths for each input footprint and return *)
	possibleCentrifugePaths=ReplaceAll[myFootprints, footprintPathLookup];

	(* Filter out any bucket results for stack heights that can't be held in the possible buckets. *)
	(* This only applies when we have a collection container -- that is, we assume the bucket can hold the container *)
	(* if there is no stacking. *)
	MapThread[
		Function[{packets, sampleContainerHeight, collectionContainerHeight, footprint},
			(* If we don't have a collection container, no filtering is needed. *)
			Which[
				!MatchQ[collectionContainerHeight, GreaterP[0 Millimeter]], packets,
				(* for microcentrifuge tubes and conical 15mL/50mL tubes we're giving them a pass because they are actually inside each other rather than stacking *)
				MatchQ[footprint, MicrocentrifugeTube|Conical50mLTube|Conical15mLTube], packets,
				(* We have a collection container. *)
				(* Figure out if the bucket is compatible if a collection container is specified. *)

				(* centrifugeTuple is in the form {instrument, rotor, bucket}. *)
				(* Note: Sometimes we don't have a bucket so we have the check the length of centrifugeTuple. *)
				True,
					Map[
						Function[{centrifugeTuple},
							If[Length[centrifugeTuple]<3 || MatchQ[centrifugeTuple[[3]], Except[ObjectP[]]],
								Nothing,
								Module[{bucketPacket},

									bucketPacket=fetchPacketFromCache[centrifugeTuple[[3]], myCentrifugeEquipmentPackets];

									(* The bucket must have a MaxStackHeight field specified and that must be greater than the height of the sample plate *)
									(* plus the height of the collection container. *)
									If[MatchQ[Lookup[bucketPacket, MaxStackHeight], Except[GreaterP[0 Millimeter]]],
										Nothing,
										If[
											MatchQ[Lookup[bucketPacket, MaxStackHeight], GreaterP[sampleContainerHeight + collectionContainerHeight]],
											centrifugeTuple,
											Nothing
										]
									]
								]
							]
						],
						packets
					]
			]
		],
		{possibleCentrifugePaths, sampleContainerHeights, collectionContainerHeights, myFootprints}
	]
];

(* helper function that selects the appropriate counterweight from a list of possible counterweights *)
getProperCounterweight[myWeight_, myHeight : DistanceP, specifiedCounterweight : Null | Automatic | ObjectP[], myFootprint : FootprintP, counterweightPackets : {_Association ..}] := Module[
	{
		counterweightWeights, noCounterweightsError, nearestCounterweightWeight, nearestHeavierCounterweightWeight,
		nearestCounterweightPacket,nearestHeavierCounterweightPacket,nearestCounterweightHeight,preferredCounterWeight,
		counterweight, potentialCounterweightPackets
	},

	If[MatchQ[myWeight, MassP],

		(* get list of potential counterweights *)
		potentialCounterweightPackets = Select[Flatten@counterweightPackets, Lookup[#, Footprint] == myFootprint&];

		(* get the counterweight weight *)
		counterweightWeights = Lookup[potentialCounterweightPackets, Weight, {}];

		(* flip an error switch if we don't have any counterweights and one wasn't specified *)
		noCounterweightsError = MatchQ[counterweightWeights, {}] && MatchQ[specifiedCounterweight, Null | Automatic];

		(* get the nearest counterweight weight *)
		(* Nearest freaks out if operating on {} so need to put this if statement in *)
		nearestCounterweightWeight = If[Not[noCounterweightsError],
			First[Nearest[counterweightWeights, myWeight]],
			Null
		];

		(* Get the nearest counterweight weight that is heavier than myWeight *)
		nearestHeavierCounterweightWeight = If[Not[noCounterweightsError],
			Min[PickList[counterweightWeights, counterweightWeights - myWeight, GreaterEqualP[0 Gram]]],
			Null
		];

		(* get the nearest counterweight packet and the nearest heavier counterweight packet *)
		nearestCounterweightPacket = SelectFirst[potentialCounterweightPackets, EqualQ[Lookup[#, Weight], nearestCounterweightWeight]&, {}];
		nearestHeavierCounterweightPacket = SelectFirst[potentialCounterweightPackets, EqualQ[Lookup[#, Weight], nearestHeavierCounterweightWeight]&, {}];

		(* Get the height of the nearest counterweight *)
		nearestCounterweightHeight = LastOrDefault[Lookup[nearestCounterweightPacket,Dimensions,Null]];

		(* If we are balancing plates, and the nearest counterweight in weight is more than 1 cm taller than our plate,
		then the preferred counterweight is the nearest in weight that is heavier than our plate (if there is one). *)
		(* We do this because when there is a mismatch in the heights of plates being centrifuged, there is a much larger
		tolerance for weight imbalances if the taller plate is also heavier. *)
		preferredCounterWeight = If[
			And[
				MatchQ[myFootprint,Plate],
				nearestCounterweightHeight - myHeight > 1 Centimeter,
				!MatchQ[nearestHeavierCounterweightPacket,{}]
			],
			Lookup[nearestHeavierCounterweightPacket,Object],
			(* Otherwise, we prefer the counterweight nearest to our container's weight *)
			Lookup[nearestCounterweightPacket,Object,Null]
		];

		(* Use the preferred counterweight unless a counterweight is specified *)
		counterweight = If[MatchQ[specifiedCounterweight, Null | Automatic],
			preferredCounterWeight,
			specifiedCounterweight
		];

		{
			counterweight,
			noCounterweightsError
		},
		{
			Null,
			True
		}
	]
];

(* Recursive helper: traverses footprint graph for all centrifuge-related containers in cache starting at the provided footprint
	and returns all paths starting at that footprint (not necessarily all terminating with centrifuges)

	Inputs:
		myFootprint: Footprint to use as starting point
		myCurrentPath: During recursion, this input is populated with the path that has been traced thus far
		myCentrifugeEquipmentPackets: List of packets of centrifuge-related containers to be considered in building the footprint graph
			- Packets must contain Footprint (where applicable) and Positions fields
	Outputs:
		Nested list of footprint paths within centrifuge-related containers for the provided footprint
	*)
rawCentrifugeFootprintPaths[myFootprint:FootprintP, myCentrifugeEquipmentPackets_List, myCurrentPath_List] := Module[
	{containerModelsForFootprint, footprintMatchQList, centrifugeAdapters, compatibleCentrifugerAdapters, allEquipmentForFootprint},

	(* Look up Positions for each container model and figure out which can accommodate the footprint of interest. Note that Adapters do not have Positions field and will not show up in this list. *)

	footprintMatchQList = MemberQ[#, myFootprint]& /@ (Lookup[#, Footprint, Null]& /@ Lookup[myCentrifugeEquipmentPackets, Positions, {}]);

	(* Find all centrifuge-relevant containers that have the footprint we want *)
	containerModelsForFootprint = PickList[myCentrifugeEquipmentPackets, footprintMatchQList];

	(* Get all the centrifuge adapters *)
	centrifugeAdapters = Cases[myCentrifugeEquipmentPackets, ObjectP[Model[Part, CentrifugeAdapter]]];

	(* Get the adapters that can fit out footprint. *)
	compatibleCentrifugerAdapters=PickList[
		centrifugeAdapters,
		MatchQ[#, myFootprint]& /@ Lookup[centrifugeAdapters, AdapterFootprint, {}]
	];

	(* Get a combined list of all containers/adapters that can fit in our footprint *)
	allEquipmentForFootprint = Join[containerModelsForFootprint,compatibleCentrifugerAdapters];

	(* If there are more higher-level containers or adapters that can contain this container model's footprint, pass to next level, appending to path appropriately. *)
	(* Note that we limit our experiment to 3 layers of adapters to avoid infinite loop. If we already have more than three layers of adapters, directly return the current path *)
	If[Length[allEquipmentForFootprint] > 0 && Count[myCurrentPath, ObjectP[Model[Part, CentrifugeAdapter]]] <= 3,
		Map[
			rawCentrifugeFootprintPaths[Lookup[#, Footprint], myCentrifugeEquipmentPackets, Append[myCurrentPath, Lookup[#, Object]]]&,
			allEquipmentForFootprint
		],
		(* Return the current path. *)
		myCurrentPath
	]
];
(* If current path was not provided, initialize it as an empty list and pass to main function *)
rawCentrifugeFootprintPaths[myFootprint:FootprintP, myCentrifugeEquipmentPackets_List] := rawCentrifugeFootprintPaths[myFootprint, myCentrifugeEquipmentPackets, {}];
(* If we encounter anything that doesn't have the Footprint field (i.e., an instrument), or anything that doesn't have Footprint populated, cease recursion *)
rawCentrifugeFootprintPaths[myFootprint:($Failed|Null), myCentrifugeEquipmentPackets_, myCurrentPath_] := myCurrentPath;



(* ::Section:: *)
(*End Private*)


(* ::Section:: *)
(*End Private*)
