(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineOptions[ExperimentVisualInspection,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the samples to be inspected, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the samples to be inspected, for use in downstream unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->Instrument,
				Default->Automatic,
				Description->"The instrument used to perform the inspection operation.",
				ResolutionDescription->"Resolved based on the compatibility of sample container with the rack in the inspector. If the sample container is incompatible with both inspectors, then the sample will be aliquoted into a 2-mL vial and inspected with inspector with the **2 mL-vial rack.**",
				Category->"General",
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Instrument, SampleInspector], Object[Instrument, SampleInspector]}]
				]
			},
			{
				OptionName->InspectionCondition,
				Default->Automatic,
				Description->"Indicates whether the interior of the sample inspector instrument should be or kept at ambient temperature.",
				ResolutionDescription->"Resolved based on the sample's StorageCondition. 'Chilled' for samples whose StorageCondition is Refrigerator, 'Ambient' for samples whose StorageCondition is AmbientStorage.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient, Chilled]
				],
				Category->"General"
			},
			{
				OptionName->TemperatureEquilibrationTime,
				Default->Automatic,
				Description->"The duration of wait time between placing the sample inside the instrument and starting to record the sample.",
				ResolutionDescription->"If InspectionCondition doesn't match the storage & transport conditions for the sample, set to 30 Minutes. If InspectionCondition matches storage & transport conditions for the sample, set to 0 Minute.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Minute,$MaxExperimentTime],
					Units->{Minute,{Second,Minute,Hour}}
				],
				Category->"General"
			},
			{
				OptionName->IlluminationDirection,
				Default-> {Top, Back},
				Description->"The sources of illumination that will be active during the inspection, where All implies all available light sources will be active simultaneously.",
				AllowNull->False,
				Widget-> Widget[Type->MultiSelect, Pattern:>DuplicateFreeListableP[Alternatives[Front, Top, Back, All, None]]],
				Category->"Imaging"
			},
			{
				OptionName->BackgroundColor,
				Default->White,
				Description->"The color of the panel placed on the inside of the inspector door serving as a backdrop for the video recording as the sample is being agitated.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>VisualInspectionBackgroundP
				],
				Category->"Imaging"
			},
			{
				OptionName->ColorCorrection,
				Default->True,
				Description ->"Indicates if the color correction card is placed visible within the frame of the video for downstream video processing, in which the colors of the video frames are adjusted to match the reference color values on the color correction card.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Imaging"
			},
			{
				OptionName->SampleMixingRate,
				Default->Automatic,
				Description->"The frequency at which the sample is rotated around the offset central axis of the shaker to agitate the sample for visualizing any particulates.",
				ResolutionDescription->"Automatically set to 1500 RPM--the minimum rate for the Vortex Genie--for samples run in the inspector with the Orbital Shaker; automatically set to 200 RPM for samples run in the inspector with the Orbital Shaker",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[30*RPM, 6000*RPM, 1*RPM],
					Units->RPM
				],
				Category->"Shaking"
			},
			{
				OptionName->SampleMixingTime,
				Default->5 Second,
				Description->"The duration of time for which the sample container is shaken on the agitator to suspend its contents prior to recording its settling.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Second, $MaxExperimentTime],
					Units->{Second,{Second,Minute,Hour}}
				],
				Category->"Imaging"
			},
			{
				OptionName->SampleSettlingTime,
				Default->5 Second,
				Description->"The duration of time for which the sample container is monitored for the movement of insoluble particulates in residual turbulence after halting the agitation.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Second, $MaxExperimentTime],
					Units->{Second,{Second,Minute,Hour}}
				],
				Category->"Imaging"
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SimulationOption,
		SamplesInStorageOption,
		SamplesOutStorageOption,
		ModelInputOptions
	}
];

Error::ConflictingInstrumentSampleMixingRates="The samples(s) `1` have specified SampleMixingRate(s) `2` that are either less than the minimum mixing rate or greater than the maximum mixing rate for the specified Instrument(s) `3`. Please adjust SampleMixingRate(s) `2` to a value between 30 RPM & 300 RPM for the Orbital Shaker, and between 540 RPM & 3200 RPM for the Vortex Genie.";
Error::ConflictingInstrumentAliquotContainers="The sample(s) `1` have specified AliquotContainer(s) `2` that are not compatible for inspection with the specified Instrument `3`.";
Error::ConflictingAliquotContainerSampleMixingRates = "For sample(s) `1`, the specified AliquotContainer(s) `2` and SampleMixingRate(s) `3` are not compatible with any of ECL's current Sample Inspector instruments.";
Error::ConflictingSampleContainerAliquotOptions = "The container model(s) `1` for sample(s) `2` are not compatible with any of ECL's current Sample Inspector instruments given the specified options `3` for Aliquot. Please revise your option(s) for Aliquot from `3` to True so that your sample(s) may be transferred to a suitable container.";
Warning::NonLiquidSamples="The specified sample(s) `1` do not have a liquid state. For ExperimentVisualInspection, it is recommended that the solid samples be prepared as a homogenous solution.";
Warning::InsufficientTemperatureEquilibrationTime="The specified sample(s) `1` have TemperatureEquilibrationTime(s) `2` set to value(s) that is/are lower than the recommended values. Please adjust their values so that TemperatureEquilibrationTime is greater than 1 Minute for all samples and greater than 30 Minute for samples whose Temperature option values are different than the sample storage temperatures.";


ExperimentVisualInspection[mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentVisualInspection]]:=ExperimentVisualInspection[{mySample},myOptions];

ExperimentVisualInspection[mySamples:{ObjectP[Object[Sample]]..}, myOptions:OptionsPattern[ExperimentVisualInspection]]:=Module[
	{outputSpecification, output, gatherTests, listedSamples, listedOptions, validSamplePreparationResult,
		mySamplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation, safeOptionsNamed, expandedInheritedOptions,
		safeOpsTests, mySamplesWithPreparedSamples, safeOps, optionsWithPreparedSamples, validLengths, validLengthTests,
		unresolvedOptions, templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, instrumentModels,
		specifiedInstruments, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields, packetObjectSample,
		downloadedStuff, containerPackets, samplePackets, cacheBall, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,
		collapsedResolvedOptions, returnEarlyQ, performSimulationQ, protocolPacketWithResources, resourcePacketTests, simulatedProtocol, simulation, protocolObject
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
		{mySamplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentVisualInspection,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentVisualInspection, optionsWithPreparedSamplesNamed, AutoCorrect->False, Output->{Result, Tests}],
		{SafeOptions[ExperimentVisualInspection, optionsWithPreparedSamplesNamed, AutoCorrect->False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentVisualInspection, {mySamplesWithPreparedSamples}, optionsWithPreparedSamples, Output->{Result, Tests}],
		{ValidInputLengthsQ[ExperimentVisualInspection, {mySamplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOpsTests, validLengthTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentVisualInspection, {ToList[mySamplesWithPreparedSamples]}, optionsWithPreparedSamples, Output->{Result, Tests}],
		{ApplyTemplateOptions[ExperimentVisualInspection, {ToList[mySamplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, unresolvedOptions];

	(* expand the inherited options *)
	expandedInheritedOptions = Last[ExpandIndexMatchedInputs[ExperimentVisualInspection, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[expandedInheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	instrumentModels = Join[Search[Model[Instrument, SampleInspector],Deprecated != True],Cases[Lookup[expandedInheritedOptions,Instrument],ObjectP[Model[Instrument]]]];
	specifiedInstruments = Cases[Lookup[expandedInheritedOptions,Instrument],Alternatives[ObjectP[Object[Instrument]],ObjectP[Model[Instrument]]]];

	objectSampleFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]],
		Packet[StorageCondition[StorageCondition]]
	};

	downloadedStuff = Quiet[Download[
		{
			mySamples,
			mySamplesWithPreparedSamples,
			instrumentModels,
			specifiedInstruments
		},
		Evaluate[{
			{Packet[Container[Model]]},
			packetObjectSample,
			{
				Packet[Object, Model, Cameras, Illumination, MinRotationRate, MaxRotationRate, MinAgitationTime, MaxAgitationTime]
			},
			{
				Packet[Object,Model],
				Packet[Model[{Object, Cameras, Illumination, MinTemperature, MaxTemperature, MinRotationRate, MaxRotationRate, MinAgitationTime, MaxAgitationTime}]]
			}
		}],
		Cache->cache,
		Simulation->updatedSimulation,
		Date->Now
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	containerPackets = downloadedStuff[[1]][[All, 1]];
	samplePackets = downloadedStuff[[2]][[All, 1]];

	(* get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, updatedSimulation, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveVisualInspectionOptions[mySamplesWithPreparedSamples, expandedInheritedOptions, Cache->cacheBall, Simulation->updatedSimulation, Output->{Result, Tests}],
			{resolveVisualInspectionOptions[mySamplesWithPreparedSamples, expandedInheritedOptions, Cache->cacheBall, Simulation->updatedSimulation, Output->Result], {}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentVisualInspection,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>, Verbose->False, OutputFormat->SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we need to return some type of simulation to our parent function that called us.*)
	performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result->$Failed,
			Tests->Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options->RemoveHiddenOptions[ExperimentVisualInspection, collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{protocolPacketWithResources, resourcePacketTests}=Which[
		returnEarlyQ,
			{$Failed, {}},
		gatherTests,
			visualInspectionResourcePackets[
				ToList[mySamplesWithPreparedSamples],
				unresolvedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result, Tests}
			],
		True,
		{
			visualInspectionResourcePackets[
				ToList[mySamplesWithPreparedSamples],
				unresolvedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation
			],
			{}
		}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentVisualInspection[
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				protocolPacketWithResources[[1]] (* protocolPacket *)
			],
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				Flatten[ToList[protocolPacketWithResources[[2]]]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		{Null, updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result->Null,
			Tests->Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options->If[MatchQ[Lookup[resolvedOptions, Preparation], Robotic],
				DeleteCases[collapsedResolvedOptions, Cache->_],
				RemoveHiddenOptions[ExperimentVisualInspection, collapsedResolvedOptions]
			],
			Preview->Null,
			Simulation->simulation
		}]
	];

	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed],
		$Failed,

		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			protocolPacketWithResources[[1]],
			protocolPacketWithResources[[2]],
			Upload->Lookup[safeOps, Upload],
			Confirm->Lookup[safeOps, Confirm],
			CanaryBranch->Lookup[safeOps, CanaryBranch],
			ParentProtocol->Lookup[safeOps, ParentProtocol],
			Priority->Lookup[safeOps, Priority],
			StartDate->Lookup[safeOps, StartDate],
			HoldOrder->Lookup[safeOps, HoldOrder],
			QueuePosition->Lookup[safeOps, QueuePosition],
			ConstellationMessage->Object[Protocol, VisualInspection],
			Simulation->simulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentVisualInspection, collapsedResolvedOptions],
		Preview->Null,
		Simulation->simulation
	}
];

DefineOptions[
	resolveVisualInspectionOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveVisualInspectionOptions[myInputSamples:{ObjectP[Object[Sample]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveVisualInspectionOptions]]:=Module[
	{outputSpecification, output, gatherTests, messages, cache, simulation, allInstrumentModels, fastTrack, samplePrepOptions, visualInspectionOptions, simulatedSamples, simulatedContainerModelPackets, resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, specifiedInstruments, specifiedIlluminationDirection, specifiedSampleMixingRates, specifiedInspectionConditions, specifiedTemperatureEquilibrationTimes, specifiedAliquotQs, specifiedAliquotAmounts, specifiedAliquotContainers, specifiedTargetConcentrations, specifiedAssayVolumes, sampleDownloads, instrumentDownloads, cacheBall, fastAssoc, samplePackets, sampleContainerObjectPacketsWithNulls, specifiedInstrumentsWithoutAutomatic, automaticInstrumentPositions, specifiedInstrumentPositions, instrumentDownloadsWithAutomatic, sampleContainerModelPacketsWithNulls, sampleContainerModelPackets, sampleContainerObjectPackets, discardedSamplePackets, discardedInvalidInputs, discardedTest, conflictingSampleContainerAliquotQ, conflictingSampleContainerAliquotSamplePackets, conflictingAliquotSampleContainerModels, conflictingSampleContainerAliquots, conflictingSampleContainerAliquotInvalidInputs, conflictingSampleContainerAliquotInvalidOptions, conflictingInstrumentSampleMixingRateQ, sampleModelPacketsWithNulls, conflictingInstrumentSampleMixingRatesSamplePackets, conflictingInstrumentSampleMixingRatesInvalidInputs, conflictingInstrumentSampleMixingRates, conflictingInstrumentSampleMixingRatesInvalidOptions, conflictingInstrumentSampleMixingRateTests, nonLiquidSampleQs, liquidSampleQ, nonLiquidSamplePackets, nonLiquidSampleWarningInputs, nonLiquidSampleTest, roundedVisualInspectionOptions, precisionTests, mapThreadFriendlyOptions, resolvedInstruments, resolvedSampleMixingRates, resolvedInspectionCondition, resolvedTemperatureEquilibrationTimes, specifiedSampleMixingTimes, specifiedSampleSettlingTimes, insufficientTemperatureEquilibrationTimeWarnings, aliquotQs, aliquotContainers, aliquotAmounts, specifiedSampleLabels, specifiedContainerLabels, resolvedSampleLabels, resolvedContainerLabels, confirm, canaryBranch, template, unresolvedOperator, resolvedPostProcessingOptions, parentProtocol, upload, unresolvedEmail, unresolvedName, resolvedEmail, resolvedOperator, nameInvalidBool, nameInvalidOption, nameInvalidTest, sampleMixingRateTooLowTests, sampleMixingRateTooHighTests, insufficientTemperatureEquilibrationTimeSamples, insufficientTemperatureEquilibrationTimes, insufficientTemperatureEquilibrationTimeOptions, conflictingInstrumentAliquotContainerQ, conflictingInstrumentAliquotContainerSamplePackets, conflictingInstrumentAliquotContainerInvalidInputs, conflictingInstrumentAliquotContainers, conflictingInstrumentAliquotContainerInvalidOptions, theoreticalMaxAgitationTime, automaticInstrumentReplacements, allInstrumentDownloads, specifiedAliquotContainersPositions, specifiedAliquotContainersDownload,specifiedAliquotContainerModels, conflictingAliquotContainerSampleMixingRateQ, conflictingAliquotContainerSampleMixingRateSamplePackets, conflictingAliquotContainerSampleMixingRateInvalidInputs, conflictingAliquotContainerSampleMixingRates, conflictingAliquotContainerSampleMixingRateInvalidOptions, conflictingAliquotContainerSampleMixingRateTests, optionsForAliquot, resolvedAliquotOptions, aliquotTests, resolvedOptions, invalidInputs, invalidOptions, allTests, storageConditionPackets, debugOptions,debugCache, debugSimulation, debugSamplePrepOptions, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields, packetObjectSample},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	allInstrumentModels = {Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"], Model[Instrument, SampleInspector, "Cooled Visual Inspector with Orbital Shaker"]};

	(* Separate out visualInspection options from Sample Prep options. *)
	{samplePrepOptions, visualInspectionOptions} = splitPrepOptions[myOptions];
	debugOptions = myOptions;
	debugCache = cache;
	debugSimulation = simulation;
	debugSamplePrepOptions = samplePrepOptions;

	(* Resolve our sample prep options (only if the sample prep option is not true. *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentVisualInspection, myInputSamples, samplePrepOptions, Cache->cache, Simulation->simulation, Output->{Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentVisualInspection, myInputSamples, samplePrepOptions, Cache->cache, Simulation->simulation, Output->Result], {}}
	];

	(* get the current container model of the simulated samples *)
	simulatedContainerModelPackets = Download[simulatedSamples, Packet[Container[Model][Object]], Cache->cache, Simulation->updatedSimulation, Date->Now];

	(* Pull out the relevant options *)
	{
		(*1*)specifiedInstruments,
		(*2*)specifiedIlluminationDirection,
		(*3*)specifiedSampleMixingRates,
		(*4*)specifiedSampleMixingTimes,
		(*5*)specifiedSampleSettlingTimes,
		(*6*)specifiedInspectionConditions,
		(*7*)specifiedTemperatureEquilibrationTimes,
		(*8*)specifiedAliquotQs,
		(*9*)specifiedAliquotAmounts,
		(*10*)specifiedAliquotContainers,
		(*11*)specifiedTargetConcentrations,
		(*12*)specifiedAssayVolumes
	} = Lookup[myOptions,
		{
			(*1*)Instrument,
			(*2*)IlluminationDirection,
			(*3*)SampleMixingRate,
			(*4*)SampleMixingTime,
			(*5*)SampleSettlingTime,
			(*6*)InspectionCondition,
			(*7*)TemperatureEquilibrationTime,
			(*8*)Aliquot,
			(*9*)AliquotAmount,
			(*10*)AliquotContainer,
			(*11*)TargetConcentration,
			(*12*)AssayVolume
		}
	];

	specifiedInstrumentsWithoutAutomatic = Cases[specifiedInstruments, Except[Automatic]];
	automaticInstrumentPositions = Flatten[Position[specifiedInstruments, Automatic]];
	specifiedInstrumentPositions = Flatten[Position[specifiedInstruments, ObjectP[{Object[Instrument, SampleInspector], Model[Instrument, SampleInspector]}]]];

	(* get the fields we're Downloading from*)
	objectSampleFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]],
		Packet[StorageCondition[StorageCondition]]
	};

	(* Extract necessary packets from downloaded cache. *)
	{sampleDownloads, instrumentDownloads} = Quiet[Download[
		{simulatedSamples, specifiedInstrumentsWithoutAutomatic},
		Evaluate[{
			packetObjectSample,
			{
				Packet[Object, Model, Objects, CompatibleVessels, Cameras, Illumination, MinTemperature,
					MaxTemperature, MinRotationRate, MaxRotationRate, MinAgitationTime,
					MaxAgitationTime]
			}
		}],
		Simulation->updatedSimulation
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	theoreticalMaxAgitationTime = 999 Second;
	automaticInstrumentReplacements = <|CompatibleVessels -> {}, MinRotationRate -> Null, MaxRotationRate -> Null, MaxAgitationTime -> theoreticalMaxAgitationTime|>;
	instrumentDownloadsWithAutomatic = ReplacePart[specifiedInstruments/.{Automatic -> automaticInstrumentReplacements}, MapThread[#1->#2&, {specifiedInstrumentPositions, instrumentDownloads}]];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{cache, sampleDownloads}];

	(* generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		sampleContainerObjectPacketsWithNulls,
		sampleContainerModelPacketsWithNulls,
		sampleModelPacketsWithNulls,
		storageConditionPackets
	} = Transpose[sampleDownloads];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null. Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerObjectPackets = Replace[sampleContainerObjectPacketsWithNulls,{Null->{}}, 1];
	sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls,{Null->{}}, 1];

	(* ::Section:: *)
	(* DISCARDED SAMPLE CHECK *)

	(* Select discarded samples from SamplePackets *)
	discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set discardedInvalidInputs to the Object values of discardedSamplePackets *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples,
			ObjectToString[discardedInvalidInputs, Cache->cacheBall]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache->cacheBall] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, discardedInvalidInputs], Cache->cacheBall] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(* ::Section:: *)
	(* CONFLICTING OPTIONS CHECK *)

	(* Mismatch between specified Aliquot & current sample container *)
	conflictingSampleContainerAliquotQ = MapThread[
		If[And[TrueQ[!#1], !MatchQ[#2, SampleInspectorCompatibleVialsP]],
			True,
			False
		]&,{specifiedAliquotQs, Lookup[sampleContainerModelPackets, Object]}
	];

	{conflictingSampleContainerAliquotSamplePackets, conflictingAliquotSampleContainerModels, conflictingSampleContainerAliquots} = Map[
			PickList[#, conflictingSampleContainerAliquotQ]&,
		{samplePackets, Lookup[sampleContainerModelPackets, Object], specifiedAliquotQs}
	];
	conflictingSampleContainerAliquotInvalidInputs = Lookup[conflictingSampleContainerAliquotSamplePackets, Object, {}];
	
	conflictingSampleContainerAliquotInvalidOptions = If[MemberQ[conflictingSampleContainerAliquotQ, True] && messages,
		(
			Message[Error::ConflictingSampleContainerAliquotOptions,
				conflictingAliquotSampleContainerModels,
				ObjectToString[conflictingSampleContainerAliquotInvalidInputs, Cache -> cacheBall],
				conflictingSampleContainerAliquots
			];
			{Aliquot}
		),
		{}
	];

	conflictingInstrumentSampleMixingRateTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},
			failingSamples = conflictingInstrumentSampleMixingRatesInvalidInputs;
			passingSamples = Lookup[PickList[samplePackets, conflictingSampleContainerAliquotQ, False], Object, {}];
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["The provided samples " <> ObjectToString[failingSamples, Cache -> cacheBall] <> "cannot be inspected on ECL's current Sample Inspector instruments in its current container.",
					False,
					True
				], Nothing
			];
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["The provided samples " <> ObjectToString[failingSamples, Cache -> cacheBall] <> "may be inspected on ECL's current Sample Inspector instruments in its current container.",
					True,
					True
				],
				Nothing
			];
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Mismatch between specified Instrument & SampleMixingRate *)
	conflictingInstrumentSampleMixingRateQ = MapThread[
		Which[
			Or[MemberQ[{#1, #2}, Automatic], MatchQ[{#3, #4}, {Null, Null}]],
			False,

			True,
			!MatchQ[#2, RangeP[#3, #4]]
		]&,{specifiedInstruments, specifiedSampleMixingRates, Lookup[Flatten[instrumentDownloadsWithAutomatic], MinRotationRate],Lookup[Flatten[instrumentDownloadsWithAutomatic], MaxRotationRate]}
	];

	(* Select sample packets with conflicting Instrument & SampleMixingRate options *)
	conflictingInstrumentSampleMixingRatesSamplePackets = PickList[samplePackets, conflictingInstrumentSampleMixingRateQ];
	conflictingInstrumentSampleMixingRatesInvalidInputs = Lookup[conflictingInstrumentSampleMixingRatesSamplePackets, Object, {}];

	conflictingInstrumentSampleMixingRates = Map[
		PickList[#, conflictingInstrumentSampleMixingRateQ]&,
		{specifiedSampleMixingRates, specifiedInstruments}
	];

	conflictingInstrumentSampleMixingRatesInvalidOptions = If[MemberQ[conflictingInstrumentSampleMixingRateQ, True] && messages,
		(
			Message[Error::ConflictingInstrumentSampleMixingRates,
				ObjectToString[conflictingInstrumentSampleMixingRatesInvalidInputs, Cache -> cacheBall],
				conflictingInstrumentSampleMixingRates[[1]],
				conflictingInstrumentSampleMixingRates[[2]]
			];
			{Instrument, SampleMixingRate}
		),
		{}
	];

	conflictingInstrumentSampleMixingRateTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},
			failingSamples = conflictingInstrumentSampleMixingRatesInvalidInputs;
			passingSamples = Lookup[PickList[samplePackets, conflictingInstrumentSampleMixingRateQ, False], Object, {}];
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> cacheBall] <> ", the specified values for Instrument and SampleMixingRate cannot be simultaneously fulfilled by a single instrument.",
					False,
					True
				],
				Nothing
			];
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache->cacheBall] <> ", the specified values for Instrument and SampleMixingRate may be simultaneously fulfilled by a single instrument.",
					True,
					True
				],
				Nothing
			];
			{passingSampleTests, failingSampleTests}
		]
	];

	(* Mismatch between specified Instrument & AliquotContainer *)
	conflictingInstrumentAliquotContainerQ = MapThread[
		Function[{specifiedAliquotContainer, compatibleVessels},
			Which[
				Or[MemberQ[{compatibleVessels,specifiedAliquotContainer},Automatic], MatchQ[compatibleVessels, {}]],
				False,

				True,
				!Module[{vesselCompatibility},
					vesselCompatibility = Map[MatchQ[specifiedAliquotContainer,ObjectP[#]]&, compatibleVessels];
					MemberQ[vesselCompatibility, True]
				]
			]
		],{specifiedAliquotContainers, Lookup[Flatten[instrumentDownloadsWithAutomatic], CompatibleVessels]}
	];

	(* Select sample packets with conflicting Instrument & AliquotContainer options *)
	conflictingInstrumentAliquotContainerSamplePackets = PickList[samplePackets, conflictingInstrumentAliquotContainerQ];
	conflictingInstrumentAliquotContainerInvalidInputs = Lookup[conflictingInstrumentAliquotContainerSamplePackets, Object, {}];

	conflictingInstrumentAliquotContainers = Map[
		PickList[#, conflictingInstrumentAliquotContainerQ]&,
		{specifiedAliquotContainers, specifiedInstruments}
	];
	conflictingInstrumentAliquotContainerInvalidOptions = If[MemberQ[conflictingInstrumentAliquotContainerQ, True] && messages,
		Module[{conflictingInstruments, conflictingAliquotContainers},
			{conflictingInstruments, conflictingAliquotContainers} = conflictingInstrumentAliquotContainers;
			(
				Message[Error::ConflictingInstrumentAliquotContainers,
					ObjectToString[conflictingInstrumentAliquotContainerInvalidInputs, Cache -> cacheBall],
					ObjectToString[conflictingInstruments],
					ObjectToString[conflictingAliquotContainers]
				];
				{Instrument, AliquotContainer}
			)
		],
		{}
	];

	(* Mismatch between specified AliquotContainer & SampleMixingRate--there is no Model[Instrument, SampleInspector] that can fulfill both options simultaneously *)
	allInstrumentDownloads = Download[allInstrumentModels, {CompatibleVessels[Object], MinRotationRate, MaxRotationRate}];
	specifiedAliquotContainersPositions = Flatten[Position[specifiedAliquotContainers, ObjectP[{Object[Container], Model[Container]}]]];
	specifiedAliquotContainersDownload = Quiet[
		Download[specifiedAliquotContainers[[specifiedAliquotContainersPositions]], {Object, Model[Object]}],
		{Download::ObjectDoesNotExist,Download::FieldDoesntExist,Download::NotLinkField}
	];

	specifiedAliquotContainerModels = ReplacePart[specifiedAliquotContainers, MapThread[#1 -> Cases[#2, ObjectP[Model[Container]]][[1]]&,{specifiedAliquotContainersPositions, specifiedAliquotContainersDownload}]];

	conflictingAliquotContainerSampleMixingRateQ = MapThread[
		Function[{specifiedAliquotContainerModel, specifiedSampleMixingRate},
			Which[
				MemberQ[{specifiedAliquotContainerModel, specifiedSampleMixingRate}, Automatic],
				False,

				(* There is at least one instrument model that can fulfill the specified AliquotContainer & SampleMixingRate *)
				Module[{fulfillable},
					fulfillable = Map[
						{
							MemberQ[#[[1]], specifiedAliquotContainerModel],
							#[[2]] <= specifiedSampleMixingRate <= #[[3]]
						}&, allInstrumentDownloads];
					MemberQ[fulfillable, ListableP[True]]
				],
				False,

				(* Otherwise, mark conflictingAliquotContainerSampleMixingRateQ as True, incompatible options *)
				True,
				True
			]
		],{specifiedAliquotContainerModels, specifiedSampleMixingRates}];

	(* ::Section:: *)
	conflictingAliquotContainerSampleMixingRateSamplePackets = PickList[samplePackets, conflictingAliquotContainerSampleMixingRateQ];
	conflictingAliquotContainerSampleMixingRateInvalidInputs = Lookup[conflictingAliquotContainerSampleMixingRateSamplePackets, Object, {}];
	conflictingAliquotContainerSampleMixingRates = Map[PickList[#, conflictingAliquotContainerSampleMixingRateQ]&,
		{specifiedAliquotContainerModels, specifiedSampleMixingRates}
	];
	conflictingAliquotContainerSampleMixingRateInvalidOptions = If[MemberQ[conflictingAliquotContainerSampleMixingRateQ, True] && messages,
		Module[{conflictingAliquotContainers, conflictingSampleMixingRates},
			{conflictingAliquotContainers, conflictingSampleMixingRates} = conflictingAliquotContainerSampleMixingRates;
			(
				Message[Error::ConflictingAliquotContainerSampleMixingRates,
					ObjectToString[conflictingAliquotContainerSampleMixingRateInvalidInputs, Cache -> cacheBall],
					ObjectToString[conflictingAliquotContainers],
					conflictingSampleMixingRates
				];
				{AliquotContainer, SampleMixingRate}
			)
		],
		{}
	];

	conflictingAliquotContainerSampleMixingRateTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},
			failingSamples = PickList[simulatedSamples, conflictingAliquotContainerSampleMixingRateQ];
			passingSamples = PickList[simulatedSamples, conflictingAliquotContainerSampleMixingRateQ, False];
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache->cacheBall] <> ", the specified values for AliquotContainer and SampleMixingRate cannot be simultaneously fulfilled by a single instrument.",
					False,
					True
				],
				Nothing
			];
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache->cacheBall] <> ", the specified values for AliquotContainer and SampleMixingRate may be simultaneously fulfilled by a single instrument.",
					True,
					True
				],
				Nothing
			];
			(* Return the created tests. *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* ::Section:: *)
	(* OPTION PRECISION CHECK *)

	(* ensure that all the numerical options have the proper precision *)
	{roundedVisualInspectionOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[Association[visualInspectionOptions],
			{
				TemperatureEquilibrationTime,
				VortexSampleMixingRate,
				OrbitalShakerSampleMixingRate,
				SampleMixingTime,
				SampleSettlingTime
			},
			{
				10^0*Minute,
				10*RPM,
				10^0,
				10^0*Second,
				10^0*Second
			},
			Output->{Result, Tests}],
		{RoundOptionPrecision[Association[visualInspectionOptions],
			{
				TemperatureEquilibrationTime,
				VortexSampleMixingRate,
				OrbitalShakerSampleMixingRate,
				SampleMixingTime,
				SampleSettlingTime
			},
			{
				10^0*Minute,
				10*RPM,
				10^0,
				10^0*Second,
				10^0*Second
			}], {}}
	];

	(* MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentVisualInspection, roundedVisualInspectionOptions];

	{
		(*1*)resolvedInstruments,
		(*2*)resolvedSampleMixingRates,
		(*3*)resolvedInspectionCondition,
		(*4*)resolvedTemperatureEquilibrationTimes,
		(*5*)insufficientTemperatureEquilibrationTimeWarnings
	} = Transpose[MapThread[
		Function[{options, sampleContainerPacket, storageConditionPacket},
			Module[
				{instrument, sampleMixingRate, storageCondition, inspectionCondition, temperatureEquilibrationTime, insufficientTemperatureEquilibrationTimeWarning},

				(* set error checking variables *)
				{
					insufficientTemperatureEquilibrationTimeWarning
				} = {False};

				(*-- OPTION RESOLVER --*)

				(* Instrument & SampleMixingRate *)
				(* Resolve the Instrument and SampleMixingRate options based on the container dimensions of the input sample. First pick the sample inspector instrument that has a shaker rack that is compatible with the container, then set the sample mixing rate to the minimum RPM for the resolved sample inspector instrument. *)

				{instrument, sampleMixingRate} = Which[
					MatchQ[Lookup[sampleContainerPacket, Model], ObjectP[Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"]]],
					{
						Lookup[options, Instrument] /. {Automatic->Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"]},
						Lookup[options, SampleMixingRate] /. {Automatic->540 RPM}
					},
					MatchQ[Lookup[sampleContainerPacket, Model],ObjectP[{Model[Container, Vessel, "50mL clear glass vial with stopper"],Model[Container, Vessel, "50 mL glass serum bottle with crimp seal"],Model[Container, Vessel, "5oz clear plastic bottle"]}]],
					{
						Lookup[options, Instrument] /. {Automatic->Model[Instrument, SampleInspector, "Cooled Visual Inspector with Orbital Shaker"]},
						Lookup[options, SampleMixingRate] /. {Automatic->200 RPM}
					},
					True,
					{
						Lookup[options, Instrument] /. {Automatic->Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"]},
						Lookup[options, SampleMixingRate] /. {Automatic->540 RPM}
					}
				];

				(* InspectionCondition *)
				(* Resolve the InspectionCondition option based on the StorageCondition of the input sample. Resolve to True if StorageCondition==Refrigerator, False if StorageCondition==AmbientStorage. *)

				storageCondition = If[!NullQ[storageConditionPacket],
					Lookup[storageConditionPacket, StorageCondition],
					AmbientStorage
				];
				inspectionCondition = Lookup[options, InspectionCondition]/.{Automatic->Which[
					MatchQ[storageCondition, Refrigerator], Chilled,
					MatchQ[storageCondition, AmbientStorage], Ambient
				]};

				(* TemperatureEquilibrationTime *)
				(* Resolve the TemperatureEquilibrationTime option to 10 Minute if inspectionCondition == Chilled & StorageCondition == Ambient. *)
				temperatureEquilibrationTime = Lookup[options, TemperatureEquilibrationTime]/.{Automatic->Which[
					And[MatchQ[storageCondition, AmbientStorage], MatchQ[inspectionCondition, Ambient]], Null,
					And[MatchQ[storageCondition, Refrigerator], MatchQ[inspectionCondition, Chilled]], Null,
					And[MatchQ[storageCondition, AmbientStorage], MatchQ[inspectionCondition, Chilled]], 10 Minute
				]};

				(* Flip insufficientTemperatureEquilibrationTimeWarning if temperatureEquilibrationTime is less than 10 Minute for any samples where experimentTemperature is different than storageTemperature *)
				insufficientTemperatureEquilibrationTimeWarning = Or[
					And[MatchQ[storageCondition, AmbientStorage], MatchQ[inspectionCondition, Chilled], temperatureEquilibrationTime < 10 Minute],
					And[MatchQ[storageCondition, Refrigerator], MatchQ[inspectionCondition, Ambient], temperatureEquilibrationTime < 10 Minute]
				];

				{
					(*1*)instrument,
					(*2*)sampleMixingRate,
					(*3*)inspectionCondition,
					(*4*)temperatureEquilibrationTime,
					(*5*)insufficientTemperatureEquilibrationTimeWarning
				}
			]
		],
		{mapThreadFriendlyOptions, sampleContainerObjectPackets, storageConditionPackets}
	]];

	(* Resolve the SampleLabel and SampleContainerLabel options.
	 If set to Automatic, resolve to the String form of the sample/container Object field *)
	{specifiedSampleLabels, specifiedContainerLabels} = Transpose[Lookup[mapThreadFriendlyOptions, {SampleLabel, SampleContainerLabel}]];

	resolvedSampleLabels = MapThread[
		If[MatchQ[#2, Automatic],
			ToString[#1],
			#2
		]&,
		{Lookup[samplePackets, Object], specifiedSampleLabels}
	];

	resolvedContainerLabels = MapThread[
		If[MatchQ[#2, Automatic],
			ToString[#1],
			#2
		]&,
		{Lookup[sampleContainerObjectPackets, Object], specifiedContainerLabels}
	];

	(* Get the rest of our options directly from SafeOptions. *)
	{confirm, canaryBranch, template, fastTrack, unresolvedOperator, parentProtocol, upload, unresolvedEmail, unresolvedName} = Lookup[myOptions, {Confirm, CanaryBranch, Template, FastTrack, Operator, ParentProtocol, Upload, Email, Name}];

	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[unresolvedEmail, Automatic],
		unresolvedEmail,
		upload && MemberQ[output, Result]
	];

	(* Resolve the operator option *)
	resolvedOperator = If[NullQ[unresolvedOperator], Model[User, Emerald, Operator, "Level 0"], unresolvedOperator];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool = StringQ[unresolvedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, VisualInspection], unresolvedName]]];

	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list of invalid options later *)
	nameInvalidOption = If[nameInvalidBool && messages,
		(
			Message[Error::DuplicateName, Object[Protocol, VisualInspection]];
			{Name}
		),
		{}
	];
	nameInvalidTest = If[gatherTests,
		Test["The specified Name is unique:", False, nameInvalidBool],
		Nothing
	];

	(* ::Section:: *)
	(*-- Warnings & Tests for TemperatureEquilibrationTime --*)
	insufficientTemperatureEquilibrationTimeSamples = PickList[simulatedSamples, insufficientTemperatureEquilibrationTimeWarnings];
	insufficientTemperatureEquilibrationTimes = PickList[resolvedTemperatureEquilibrationTimes, insufficientTemperatureEquilibrationTimeWarnings];
	insufficientTemperatureEquilibrationTimeOptions = If[MemberQ[insufficientTemperatureEquilibrationTimeWarnings, True] && messages,
		(
			Message[Warning::InsufficientTemperatureEquilibrationTime,
				ObjectToString[insufficientTemperatureEquilibrationTimeSamples, Cache->cacheBall],
				insufficientTemperatureEquilibrationTimes
			];
			{TemperatureEquilibrationTime}
		),
		{}
	];

	(* ::Section:: *)
	(* NON-LIQUID SAMPLE CHECK *)

	{nonLiquidSampleQs, liquidSampleQ} = Transpose[Map[
		{
			!MatchQ[Lookup[#, State], Liquid],
			MatchQ[Lookup[#, State], Liquid]
		} &, samplePackets]];

	(* Select non-liquid samples from samplePackets *)
	nonLiquidSamplePackets = PickList[samplePackets, nonLiquidSampleQs];

	(* Set nonLiquidSampleWarningInputs to the Object values of nonLiquidSamplePackets *)
	nonLiquidSampleWarningInputs = Lookup[nonLiquidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, do so. *)
	If[Length[nonLiquidSampleWarningInputs] > 0 && messages,
		Message[Warning::NonLiquidSamples,
			ObjectToString[nonLiquidSampleWarningInputs, Cache->cacheBall]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidSampleWarningInputs] == 0,
				Nothing,
				Warning["Our input samples " <> ObjectToString[nonLiquidSampleWarningInputs, Cache->cacheBall] <> " have a Liquid State:", True, False]
			];
			passingTest = If[Length[nonLiquidSampleWarningInputs] == Length[myInputSamples],
				Nothing,
				Warning["Our input samples " <> ObjectToString[Complement[myInputSamples, nonLiquidSampleWarningInputs], Cache->cacheBall] <> " have a Liquid State:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	aliquotQs = MapThread[
		Function[{aliquot, aliquotAmount, nonLiquidSampleQ, sampleContainerModel},
			Which[
				Or[TrueQ[aliquot], TrueQ[nonLiquidSampleQ]],True,
				MatchQ[aliquot, False],False,
				MatchQ[aliquotAmount, VolumeP], True,
				!MatchQ[sampleContainerModel, SampleInspectorCompatibleVialsP], True,
				MatchQ[sampleContainerModel, SampleInspectorCompatibleVialsP], False,
				True, False
			]
		],
		{Lookup[myOptions, Aliquot], Lookup[myOptions, AliquotAmount], nonLiquidSampleQs, Lookup[sampleContainerModelPackets, Object]}
	];

	(* Resolve AliquotContainer based on instrument. *)
	aliquotContainers = MapThread[
		Function[{resolvedInstrument, aliquotQ, specifiedAliquotContainer},
			 Which[
				 aliquotQ && MatchQ[resolvedInstrument, ObjectP[Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"]]],
				 specifiedAliquotContainer/.{Automatic->Model[Container, Vessel, "2ml clear glass wide neck bottle"]},

				 aliquotQ && MatchQ[resolvedInstrument, ObjectP[Model[Instrument, SampleInspector, "Cooled Visual Inspector with Orbital Shaker"]]],
				 specifiedAliquotContainer/.{Automatic->Model[Container, Vessel, "50 mL glass serum bottle with crimp seal"]},

				 True,
				 Null
			 ]
		], {resolvedInstruments, aliquotQs, specifiedAliquotContainers}];

	(* Resolve AliquotVolumes based on aliquotContainers *)
	aliquotAmounts = Module[{sampleStates, sampleMasses, sampleVolumes},
		{sampleStates, sampleMasses, sampleVolumes} = Transpose[Lookup[samplePackets, {State, Mass, Volume}]];
		MapThread[
			Function[{aliquotContainer, sampleState, aliquotAmount},
				Which[
					Or[MatchQ[aliquotAmount, VolumeP], MatchQ[aliquotAmount, MassP]],
					aliquotAmount,

					And[MatchQ[sampleState, Solid], MatchQ[aliquotContainer, ObjectP[{Model[Container, Vessel, "4mL Screw Cap Clear Glass Vial"], Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"]}]]],
					5 Milligram,

					And[MatchQ[sampleState, Liquid], MatchQ[aliquotContainer, ObjectP[Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"]]]],
					2 Milliliter,

					And[MatchQ[sampleState, Solid], MatchQ[aliquotContainer, ObjectP[Model[Container, Vessel, "50 mL glass serum bottle with crimp seal"]]]],
					100 Milligram,

					And[MatchQ[sampleState, Liquid], MatchQ[aliquotContainer, ObjectP[Model[Container, Vessel, "50 mL glass serum bottle with crimp seal"]]]],
					50 Milliliter,

					True,
					Null
				]
			],
			{aliquotContainers, sampleStates, Lookup[myOptions, AliquotAmount]}
		]
	];

	(* add the sample prep options to the options being passed into resolveAliquotOptions *)
	optionsForAliquot = ReplaceRule[myOptions, resolvedSamplePrepOptions];

	(* Resolve Aliquot options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[ExperimentVisualInspection,
			Lookup[samplePackets, Object],
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotContainers->aliquotContainers,
			RequiredAliquotAmounts->aliquotAmounts,
			AllowSolids->True,
			MinimizeTransfers->True,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->{Result, Tests}
		],
		{resolveAliquotOptions[ExperimentVisualInspection,
			Lookup[samplePackets, Object],
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotContainers->aliquotContainers,
			RequiredAliquotAmounts->aliquotAmounts,
			AllowSolids->True,
			MinimizeTransfers->True,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->Result], {}
		}
	];

	(*-- The complete resolved options --*)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Instrument->(*1*)resolvedInstruments,
			SampleMixingRate->(*2*)resolvedSampleMixingRates,
			InspectionCondition->(*3*)resolvedInspectionCondition,
			TemperatureEquilibrationTime->(*4*)resolvedTemperatureEquilibrationTimes,
			SampleMixingTime->specifiedSampleMixingTimes,
			SampleSettlingTime->specifiedSampleSettlingTimes,
			IlluminationDirection->specifiedIlluminationDirection,
			Operator->resolvedOperator,
			Email->resolvedEmail,
			SampleLabel->resolvedSampleLabels,
			SampleContainerLabel->resolvedContainerLabels,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			Simulation->updatedSimulation
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		conflictingSampleContainerAliquotInvalidInputs,
		conflictingInstrumentSampleMixingRatesInvalidInputs,
		conflictingInstrumentAliquotContainerInvalidInputs,
		conflictingAliquotContainerSampleMixingRateInvalidInputs
	}]];

	(* Gather all invalid options *)
	invalidOptions = DeleteDuplicates[Flatten[{
		conflictingSampleContainerAliquotInvalidOptions,
		conflictingInstrumentSampleMixingRatesInvalidOptions,
		conflictingInstrumentAliquotContainerInvalidOptions,
		conflictingAliquotContainerSampleMixingRateInvalidOptions,
		nameInvalidOption
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Gather all tests *)
	allTests = Cases[Flatten[{
		nameInvalidTest,
		discardedTest,
		conflictingInstrumentSampleMixingRateTests,
		precisionTests,
		nonLiquidSampleTest,
		sampleMixingRateTooLowTests,
		sampleMixingRateTooHighTests,
		conflictingAliquotContainerSampleMixingRateTests,
		aliquotTests
	}], TestP];

	(* Return our resolved options and/or tests *)
	outputSpecification /. {Result->resolvedOptions, Tests->allTests}
];

(* ::Subsection:: *)
(* resolveVisualInspectionMethod *)

DefineOptions[resolveVisualInspectionMethod,
	SharedOptions:>{
		ExperimentVisualInspection,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySamples can be Automatic when the user has not yet specified a value for autofill. *)
resolveVisualInspectionMethod[
	mySamples:ListableP[Automatic|(ObjectP[{Object[Sample], Object[Container]}])],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, result, tests},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveVisualInspectionMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOptions, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* for VisualInspection, result is always ManualSamplePreparation and there are no tests *)
	result = Manual;
	tests = {};

	outputSpecification /. {Result->result, Tests->tests}
];

(* ::Subsection:: *)
(*simulateExperimentVisualInspection*)

DefineOptions[
	simulateExperimentVisualInspection,
	Options:>{HelperOutputOption, CacheOption, SimulationOption}
];

simulateExperimentVisualInspection[
	myResourcePacket:(PacketP[Object[Protocol, VisualInspection], {Object, ResolvedOptions}]|{}|$Failed),
	myUnitOperationPackets:({PacketP[]...}|{}|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentVisualInspection]
]:= Module[
	{cache, simulation, samplePackets, protocolObject, fulfillmentSimulation},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download object and containers from our sample packets. *)
	samplePackets = Download[
		mySamples,
		Packet[Object, Container],
		Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
		Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver.
		Simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol, VisualInspection]],

		True,
		Lookup[myResourcePacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	fulfillmentSimulation = Which[
		MatchQ[myResourcePacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->MapThread[
					Resource[Sample->#1, Name->#2, Amount->#3]&,
					{
						mySamples,
						Lookup[myResolvedOptions, AliquotAmount],
						Lookup[myResolvedOptions, SampleLabel]
					}
				],
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],

		True,
		SimulateResources[
			myResourcePacket,
			Null,
			Cache->cache,
			Simulation->simulation
		]
	];

	{
		protocolObject,
		UpdateSimulation[simulation, fulfillmentSimulation]
	}
];

(* ::Subsection:: *)
(*visualInspectionResourcePackets*)

DefineOptions[visualInspectionResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

visualInspectionResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myOptions:OptionsPattern[]]:=Module[
	{expandedInputs, expandedResolvedOptions, safeOps, outputSpecification, output, gatherTests, messages, cache, simulation, fastAssoc, simulatedSamples, updatedSimulation, aliquotQs, aliquotContainers, aliquotAmounts, operator, instruments, inspectionConditions, temperatureEquilibrationTimes, sampleMixingTimes, sampleSettlingTimes,illuminationDirections, backgrounds, colorCorrectionBooleans, sampleMixingRates, orbitalShakerSampleMixingRates, vortexSampleMixingRates, sampleLabels, sampleContainerLabels, sampleObjects, sampleVolumes, sampleContainerObjects, sampleContainerModels, simulatedContainerModels, instrumentModels, sampleAgitatorModels, inspectorRunTimes, inspectorGroups, inspectorResources, backdropPlacements, samplesInResources, backdropResources, protocolID, protocolFilePath, sampleIndices, dataFilePaths, unitOperationFieldNames, batchedUnitOperationParameters, instrumentModelsAndTimes, unitOperationIDs, unitOperationPackets, sortedUnitOperationPackets, inspectorResourcesForProtocol, unitOperationParameters, protocolPacket, allResourceBlobs, sharedFieldPacket, finalizedPacket, frqTests, previewRule, optionsRule, testsRule, resultRule, allDownloadValues, fulfillable},

	(* No NumberOfReplicates for VisualInspection, for now *)
	{expandedInputs, expandedResolvedOptions} = {mySamples, myResolvedOptions};

	(* get the safe options for this function *)
	safeOps = SafeOptions[visualInspectionResourcePackets, ToList[myOptions]];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* simulate the sample preparation stuff so we have the right containers if we are aliquoting *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentVisualInspection, mySamples, myResolvedOptions, Cache->cache, Simulation->simulation];

	(* Lookup option values *)
	{
		aliquotQs,
		aliquotContainers,
		aliquotAmounts,
		operator,
		instruments,
		inspectionConditions,
		temperatureEquilibrationTimes,
		illuminationDirections,
		backgrounds,
		colorCorrectionBooleans,
		sampleMixingRates,
		sampleMixingTimes,
		sampleSettlingTimes,
		sampleLabels,
		sampleContainerLabels
	} = Lookup[expandedResolvedOptions,
		{
			Aliquot,
			AliquotContainer,
			AliquotAmount,
			Operator,
			Instrument,
			InspectionCondition,
			TemperatureEquilibrationTime,
			IlluminationDirection,
			BackgroundColor,
			ColorCorrection,
			SampleMixingRate,
			SampleMixingTime,
			SampleSettlingTime,
			SampleLabel,
			SampleContainerLabel
		}
	];

	{instrumentModels, sampleAgitatorModels} = Transpose[
		Map[
			Which[
				MatchQ[#, ObjectP[Model[Instrument, SampleInspector]]],
				Download[#, {Object, IntegratedAgitator}],

				MatchQ[#, ObjectP[Object[Instrument, SampleInspector]]],
				Download[#, {Model, IntegratedAgitator[Model]}]
			]&, instruments
		]
	];

    Transpose[
	    Quiet[Download[instruments, {Model, IntegratedAgitator}], {Download::FieldDoesntExist, Download::NotLinkField}]
	];

	allDownloadValues = Download[
		{
			simulatedSamples,
			mySamples
		},
		{
			Packet[Object, Volume],
			Packet[Container[Model, Object]]
		},
		Cache->cache,
		Simulation->updatedSimulation
	];
	
	{sampleObjects, sampleVolumes} = Transpose[Lookup[allDownloadValues[[2, All, 1]], {Object, Volume}]];
	{sampleContainerObjects, sampleContainerModels} = Transpose[Lookup[allDownloadValues[[2, All, 2]], {Object, Model}]];
	simulatedContainerModels = Lookup[allDownloadValues[[1, All, 2]], Model];

	(* Converting the RPM mixing rate values specified for Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"] to their corresponding numerical values for the Vortex *)

	{vortexSampleMixingRates, orbitalShakerSampleMixingRates} = Transpose[MapThread[
		Function[{sampleAgitatorModel, instrument, sampleMixingRate},
			Module[{vortexSampleMixingRate, orbitalShakerSampleMixingRate},
				vortexSampleMixingRate = Which[
					Or[
						MatchQ[sampleAgitatorModel, ObjectP[Model[Instrument, Vortex, "Visual Inspector Shaker Vortex Genie 2"]]],
						MatchQ[instrument, ObjectP[Object[Instrument, SampleInspector, "Visual Inspector 2"]]]
					],
					Round[10*(QuantityMagnitude[sampleMixingRate]-600)/(3200-600), 0.5],

					Or[
						MatchQ[sampleAgitatorModel, ObjectP[Model[Instrument, Shaker, "Visual Inspector 16mm Orbital Shaker"]]],
						MatchQ[instrument, ObjectP[Object[Instrument, SampleInspector, "Visual Inspector 1"]]]
					],
					Null
				];

				orbitalShakerSampleMixingRate = Which[
					Or[
						MatchQ[sampleAgitatorModel, ObjectP[Model[Instrument, Shaker, "Visual Inspector 16mm Orbital Shaker"]]],
						MatchQ[instrument, ObjectP[Object[Instrument, SampleInspector, "Visual Inspector 1"]]]
					],
					sampleMixingRate,

					Or[
						MatchQ[sampleAgitatorModel, ObjectP[Model[Instrument, Vortex, "Visual Inspector Shaker Vortex Genie 2"]]],
						MatchQ[instrument, Object[Object[Instrument, SampleInspector, "Visual Inspector 2"]]]
					],
					Null
				];

				{vortexSampleMixingRate, orbitalShakerSampleMixingRate}
			]
		],
		{sampleAgitatorModels, instruments, sampleMixingRates}
	]];

	inspectorRunTimes = (Total[{temperatureEquilibrationTimes, sampleMixingTimes, sampleSettlingTimes}] + 2 Minute)/.{Null->0 Second}; (* 2 Minute buffer after each sample run *)

	(* Gather the instruments & inspectorRunTimes by the instrument and add up all the inspectorRunTimes for each instrument for creating one Resource per instrument *)
	inspectorGroups = MapThread[{#1, #2}&, {instruments, inspectorRunTimes}];

	(* Make sample resource *)
	samplesInResources = MapThread[
		Function[{simulatedContainerModel, sampleContainerModel, sampleObject, sampleVolume, aliquotAmount, sampleLabel, aliquotQ},
			Which[
				!MatchQ[simulatedContainerModel, sampleContainerModel] && aliquotQ,
					Resource[Sample->sampleObject, Amount->aliquotAmount, Name->sampleLabel, Container->simulatedContainerModel],
				MatchQ[simulatedContainerModel, sampleContainerModel] && !aliquotQ,
					Resource[Sample->sampleObject, Amount->sampleVolume, Name->sampleLabel, Container->sampleContainerModel]
				]
			],
		{simulatedContainerModels, sampleContainerModels, sampleObjects, sampleVolumes, aliquotAmounts, sampleLabels, aliquotQs}
	];

	(* Backdrop resources *)
	backdropResources = MapThread[
		Function[{background, instrumentModel},
			Link[
				Which[
					MatchQ[instrumentModel, ObjectP[Model[Instrument, SampleInspector, "Cooled Visual Inspector with Vortex"]]],
					Which[
						MatchQ[background, Black],
						Link[Resource[Sample->Model[Part, Backdrop, "Black Backdrop for Visual Inspector 2"], Name->"Black Backdrop for Visual Inspector 2", Rent->True]],
						MatchQ[background, White],
						Link[Resource[Sample->Model[Part, Backdrop, "White Backdrop for Visual Inspector 2"], Name->"White Backdrop for Visual Inspector 2", Rent->True]]
					],
					MatchQ[instrumentModel, ObjectP[Model[Instrument, SampleInspector, "Cooled Visual Inspector with Orbital Shaker"]]],
					Which[
						MatchQ[background, Black],
						Link[Resource[Sample->Model[Part, Backdrop, "Black Backdrop for Visual Inspector 1"], Name->"Black Backdrop for Visual Inspector 1", Rent->True]],
						MatchQ[background, White],
						Link[Resource[Sample->Model[Part, Backdrop, "White Backdrop for Visual Inspector 1"], Name->"White Backdrop for Visual Inspector 1", Rent->True]]
					]
				]
			]
		],
		{backgrounds, instrumentModels}
	];
	
	protocolID = CreateID[Object[Protocol, VisualInspection]];
	protocolFilePath = ObjectToFilePath[protocolID, FastTrack->True];
	
	(* The indices of all samples within each UO, which will be incorporated into the file directory for each sample so that each directory contains a unique video that can be unambiguously mapped to a sample in a UO *)
	sampleIndices = Range[Length[mySamples]];
	
	dataFilePaths = MapThread[FileNameJoin[{$PublicPath, "Data", "VisualInspection", protocolFilePath, ToString[#1], ObjectToFilePath[#2, FastTrack->True]}]&, {sampleIndices, mySamples}];

	unitOperationParameters = ReplaceRule[expandedResolvedOptions,
		{
			(* Fields generated after option resolution  *)
			SampleLink->samplesInResources,
			Backdrop->backdropResources,
			OrbitalShakerSampleMixingRate->orbitalShakerSampleMixingRates,
			VortexSampleMixingRate->vortexSampleMixingRates,
			DataFilePath->dataFilePaths,
			SampleIndex->sampleIndices
		}
	];
	unitOperationFieldNames = {SampleLabel, SampleContainerLabel, SampleLink, InspectionCondition, TemperatureEquilibrationTime, BackgroundColor, Backdrop, IlluminationDirection, ColorCorrection, SampleMixingRate, VortexSampleMixingRate, OrbitalShakerSampleMixingRate, SampleMixingTime, SampleSettlingTime, DataFilePath, SampleIndex};

	batchedUnitOperationParameters = groupByKey[
		Join[
			(#->Lookup[unitOperationParameters, #])&/@unitOperationFieldNames,
			(* Joining this information for instrument resources with other UO parameters so that we can include them in groupByKey for making batched UOs, to help create instrument resource per batched UO *)
			{
				Instruments->instruments,
				Times->inspectorRunTimes
			}
		],
		{Instruments, InspectionCondition}
	][[All,2]];

	unitOperationIDs = CreateID[ConstantArray[Object[UnitOperation,VisualInspection],Length@batchedUnitOperationParameters]];
	
	instrumentModelsAndTimes = Lookup[batchedUnitOperationParameters, {Instruments, Times}];
	inspectorResources = MapThread[
		Link[
			Resource[
				Instrument->#1[[1]][[1]],
				Time->Total[#1[[2]]],
				Name->ToString[#2]
			]
		]&,
		{instrumentModelsAndTimes, unitOperationIDs}
	];

	backdropPlacements = MapThread[
		Function[{inspector, backdrops},
			Map[{#, inspector, "Backdrop Slot"} &, backdrops]
		],
		{inspectorResources, Lookup[batchedUnitOperationParameters, Backdrop]}
	];

	(* Make the unit operation packets *)
	unitOperationPackets = MapThread[
		Function[{unitOperationID, unitOperationParameters, instruments, backdropPlacement},
			<|
				Object->unitOperationID,
				Replace[SampleLabel]->Lookup[unitOperationParameters, SampleLabel],
				Replace[SampleContainerLabel]->Lookup[unitOperationParameters, SampleContainerLabel],
				Replace[SampleLink]->Lookup[unitOperationParameters, SampleLink],
				Replace[SampleContainerPlacement]->ConstantArray[{Null, Null, Null}, Length[Lookup[unitOperationParameters, SampleLink]]],
				Replace[Instrument]->ConstantArray[instruments, Length[Lookup[unitOperationParameters, SampleLink]]],
				Replace[InspectionCondition]->Lookup[unitOperationParameters, InspectionCondition],
				Replace[TemperatureEquilibrationTime]->Lookup[unitOperationParameters, TemperatureEquilibrationTime],
				Replace[BackgroundColor]->Lookup[unitOperationParameters, BackgroundColor],
				Replace[Backdrop]->Lookup[unitOperationParameters, Backdrop],
				Replace[BackdropPlacement]->backdropPlacement,
				Replace[IlluminationDirection]->Lookup[unitOperationParameters, IlluminationDirection],
				Replace[ColorCorrection]->Lookup[unitOperationParameters, ColorCorrection],
				Replace[SampleMixingRate]->Lookup[unitOperationParameters, SampleMixingRate],
				Replace[OrbitalShakerSampleMixingRate]->Lookup[unitOperationParameters, OrbitalShakerSampleMixingRate],
				Replace[VortexSampleMixingRate]->Lookup[unitOperationParameters, VortexSampleMixingRate],
				Replace[SampleMixingTime]->Lookup[unitOperationParameters, SampleMixingTime],
				Replace[SampleSettlingTime]->Lookup[unitOperationParameters, SampleSettlingTime],
				Replace[DataFilePath]->Lookup[unitOperationParameters, DataFilePath],
				Replace[SampleIndex]->Lookup[unitOperationParameters, SampleIndex]
			|>
		],
		{unitOperationIDs, batchedUnitOperationParameters, inspectorResources, backdropPlacements}
	];

	(* Sort the unit operation packets such that the UO's with InspectionCondition->Ambient are set first. This is so that the Ambient Temperature samples could get run first in the Procedure. *)
	sortedUnitOperationPackets = SortBy[unitOperationPackets, Lookup[#,Replace[InspectionCondition]][[1]]&];

	(* Also need to ConstantArray the instrument resource to preserve indexMatching *)
	inspectorResourcesForProtocol = Flatten[MapThread[
		ConstantArray[#1, Length[#2]] &,
		{inspectorResources, Lookup[batchedUnitOperationParameters, SampleIndex]}
	]];

	(* Make the protocol packet including resources *)
	protocolPacket = <|
		Object->protocolID,
		Type->Object[Protocol, VisualInspection],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->CollapseIndexMatchedOptions[ExperimentVisualInspection, myResolvedOptions, Messages->False, Ignore->myUnresolvedOptions],
		Template->If[MatchQ[Lookup[myResolvedOptions, Template],FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],

		(* Resources *)
		Replace[SamplesIn]->Map[Link[#,Protocols]&, samplesInResources],
		Replace[ContainersIn]->Map[Link[Resource[Sample->#], Protocols]&, sampleContainerObjects],
		Replace[Instruments]->inspectorResourcesForProtocol,
		Replace[Backdrops]->backdropResources,

		(* Experiment parameters *)
		Replace[InspectionConditions]->inspectionConditions,
		Replace[TemperatureEquilibrationTimes]->temperatureEquilibrationTimes,
		Replace[IlluminationDirections]->illuminationDirections,
		Replace[ColorCorrections]->colorCorrectionBooleans,
		Replace[SampleMixingRates]->sampleMixingRates,
		Replace[SampleMixingTimes]->sampleMixingTimes,
		Replace[OrbitalShakerSampleMixingRates]->orbitalShakerSampleMixingRates,
		Replace[VortexSampleMixingRates]->vortexSampleMixingRates,
		Replace[SampleSettlingTimes]->sampleSettlingTimes,
		Replace[DataFilePaths]->dataFilePaths,
		Replace[SampleIndices]->sampleIndices,

		(* Unit Operations *)
		Replace[BatchedUnitOperations]->Link[sortedUnitOperationPackets, Protocol],

		(* Checkpoints *)
		Replace[Checkpoints]->Join[
			{
				{"Picking Resources", 10 * Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
				{"Preparing Samples", 2 * Minute, "Samples that need aliquoting are transferred to appropriate containers.", Link[Resource[Operator -> $BaselineOperator, Time -> 2 Minute]]}
			},
			Table[
				{"Inspecting Sample", 5*Minute, "The prepared samples are agitated and recorded in the sample inspector instrument, one by one.",
					Link[Resource[
						Operator -> $BaselineOperator,
						Time -> 2 Minute
					]]
				},
				Length[sampleIndices]
			]
		]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache->cache];

	(* Fulfillable resources check *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[{unitOperationPackets, protocolPacket}]],_Resource, Infinity]];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack->Lookup[myResolvedOptions, FastTrack], Site->Lookup[myResolvedOptions,Site], Simulation->updatedSimulation, Messages->messages, Cache->cache], {}}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview->Null;

	(* Generate the options output rule *)
	optionsRule = Options->If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentFilter, myResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests->If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result->If[MemberQ[output, Result] && TrueQ[fulfillable],
		{finalizedPacket, unitOperationPackets},
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* singleton container input *)
ExperimentVisualInspection[myContainer:(ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String), myOptions:OptionsPattern[ExperimentVisualInspection]]:=ExperimentVisualInspection[{myContainer}, myOptions];

(* multiple container input *)
ExperimentVisualInspection[myContainers:{(ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String)..}, myOptions:OptionsPattern[ExperimentVisualInspection]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleResult,containerToSampleOutput,
		updatedCache,samples,sampleOptions,containerToSampleTests,objectsExistQs,objectsExistTests,currentSimulation},
	
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Remove temporal links. *)
	{listedContainers, listedOptions}=sanitizeInputs[ToList[myContainers], ToList[myOptions]];
	
	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,currentSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentVisualInspection,
			ToList[listedContainers],
			ToList[listedOptions]
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];
	
	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulatedSamplePreparationPackets];
		Return[$Failed]
	];
	
	(* Before we turn containers into samples, we want to check that all containers exist in the database. We don't check any other option objects as they will be checked in our main Sample overload. We don't want random result to be returned from containerToSample function *)
	
	objectsExistQs=DatabaseMemberQ[ToList[myContainers]];
	
	(* Build tests for object existence *)
	objectsExistTests=If[gatherTests,
		Module[{failingTest,passingTest},
			
			failingTest=If[!MemberQ[objectsExistQs,False],
				Nothing,
				Test["The specified objects "<>ToString[PickList[ToList[myContainers],objectsExistQs,False]]<>" exist in the database:",True,False]
			];
			
			passingTest=If[!MemberQ[objectsExistQs,True],
				Nothing,
				Test["The specified objects "<>ToString[PickList[ToList[myContainers],objectsExistQs,True]]<>" exist in the database:",True,True]
			];
			
			{failingTest,passingTest}
		],
		{}
	];
	
	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[ToList[myContainers],objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[ToList[myContainers],objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->objectsExistTests,
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentVisualInspection,
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
				ExperimentVisualInspection,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> Result,
				Simulation -> currentSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];
	
	(* Update our cache with our new simulated values. *)
	(* It is important the the sample preparation cache appears first in the cache ball. *)
	updatedCache = FlattenCachePackets[{
		currentSimulation,
		Lookup[listedOptions,Cache,{}]
	}];
	
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
		ExperimentVisualInspection[samples,ReplaceRule[sampleOptions,Simulation -> currentSimulation]]
	]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentVisualInspectionOptions*)


DefineOptions[ExperimentVisualInspectionOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentVisualInspection}
];

ExperimentVisualInspectionOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentVisualInspection *)
	options = ExperimentVisualInspection[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentVisualInspection],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ValidExperimentVisualInspectionQ*)


DefineOptions[ValidExperimentVisualInspectionQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentVisualInspection}
];

(* --- Overloads --- *)
ValidExperimentVisualInspectionQ[mySample:_String|ObjectP[{Model[Sample], Object[Sample]}], myOptions:OptionsPattern[ValidExperimentVisualInspectionQ]] := ValidExperimentVisualInspectionQ[{mySample}, myOptions];

ValidExperimentVisualInspectionQ[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentVisualInspectionQ]] := ValidExperimentVisualInspectionQ[{myContainer}, myOptions];

ValidExperimentVisualInspectionQ[myContainers : {(_String|ObjectP[{Object[Container], Model[Sample]}])..}, myOptions : OptionsPattern[ValidExperimentVisualInspectionQ]] := Module[
	{listedOptions, preparedOptions, visualInspectionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat)->_];

	(* return only the tests for ExperimentVisualInspection *)
	visualInspectionTests = ExperimentVisualInspection[myContainers, Append[preparedOptions, Output->Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[visualInspectionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[myContainers, _String], Object], OutputFormat->Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[myContainers, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, visualInspectionTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentVisualInspectionQ, {Horse->Zebra, Verbose->True, OutputFormat->Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse->Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentVisualInspectionQ"->allTests|>, OutputFormat->outputFormat, Verbose->verbose], "ValidExperimentVisualInspectionQ"]

];

(* --- Core Function --- *)
ValidExperimentVisualInspectionQ[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ValidExperimentVisualInspectionQ]]:=Module[
	{listedOptions, preparedOptions, visualInspectionTests, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat)->_];

	(* return only the tests for ExperimentVisualInspection *)
	visualInspectionTests = ExperimentVisualInspection[mySamples, Append[preparedOptions, Output->Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[DeleteCases[mySamples, _String], OutputFormat->Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{DeleteCases[mySamples, _String], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{visualInspectionTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentVisualInspectionQ, {Horse->Zebra, Verbose->True, OutputFormat->Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse->Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentVisualInspectionQ"->allTests|>, OutputFormat->outputFormat, Verbose->verbose], "ValidExperimentVisualInspectionQ"]
];