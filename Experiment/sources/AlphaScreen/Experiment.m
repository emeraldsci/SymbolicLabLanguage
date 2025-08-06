(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


DefineOptions[ExperimentAlphaScreen,
	Options :> {
		{
			OptionName -> PreparedPlate,
			Default -> False,
			Description -> "Indicates if a prepared plate is provided for AlphaScreen measurement. The prepared plate contains the analytes, acceptor and donor AlphaScreen beads that are ready to be excited by AlphaScreen laser for luminescent AlphaScreen measurement in a plate reader. If the 'PreparedPlate' is False, the samples that contain all the components will be transferred to an assay plate for AlphaScreen measurement.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "General"
		},
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The plate reader for the signal measurement in AlphaScreen.",
			AllowNull -> False,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Instrument, PlateReader], Object[Instrument, PlateReader]}]],
			Category -> "General"
		},
		{
			OptionName -> AssayPlateModel, (* add new AlphaScreen category in our ECL catalog, so that user can select different plate types: non-treated plate vs low-binding-surface plate*)
			Default -> Automatic,
			Description -> "The plate where the samples are transferred and measured in the plate reader.",
			ResolutionDescription -> "Automatic resolves the plate where the 'AlphaAssayVolume' is within the volume limits. If multiple plate formats support the 'AlphaAssayVolume', automatic resolves to a half area 96-well plate if the number of samples is less than 96, or resolves to a 384-well plate if the number of samples is more than 96. If the 'AlphaAssayVolume' is also set to Automatic, automatic resolves to either a half are 96-well or 384-well plate based on the number of samples as described before.",
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, Plate]}]],
			Category -> "General"
		},
		{
			OptionName -> AlphaAssayVolume,
			Default -> Automatic,
			Description -> "The total volume that each sample is transferred to the assay plate for luminescent AlphaScreen measurement.",
			ResolutionDescription -> "Automatic resolves to the recommended fill volume of the 'AssayPlateModel'. If the 'AssayPlateModel' is also set to Automatic, automatic resolves to 100 Microliter.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 300 Microliter],
				Units :> Microliter
			],
			Category -> "AlphaScreen Sample Preparation"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of wells each sample is aliquoted into and read independently.",
			AllowNull -> True,
			Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 384, 1]],
			Category -> "AlphaScreen Sample Preparation"
		},
		AlphaScreenOpticsOptions,
		(*Sample Storage and Shared Options*)
		SamplesInStorageOptions,
		{
			OptionName -> StoreMeasuredPlates,
			Default -> False,
			Description -> "Indicate if the assay plates are stored after the experiment is completed. If it sets to True, the plates are stored according to the storage condition of the samples after measurement. If it sets to False, the plates are discarded after measurement.",
			AllowNull -> False,
			Category -> "Post Experiment",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		NonBiologyFuntopiaSharedOptions,
		ModelInputOptions,
		(* Overwrite ConsolidateAliquots pattern since it can never be set to True since we will never read the same well multiple times *)
		(*double check this with Hayley*)
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[False]]
		}
	}
];

Error::AlphaScreenRepeatedPlateReaderSamples = "Samples can only be repeated in the input if they are set to be aliquoted since repeat readings are performed by reading aliquots of a sample.";
Error::AlphaScreenNotSupportedPlateReader = "The plate reader `1` does not support AlphaScreen.  Please select a plate reader whose AlphaScreenEmissionFilter and AlphaScreenExcitationLaserWavelength fields are populated.";
Error::AlphaScreenPreparedPlateIrrelevant = "The `1` options are not relevant to a PreparedPlate measurement. If you would like to measure a PreparedPlate, `1` should be set to Null.";
Error::AlphaScreenAssayPlateInfoRequired = "The `1` options should not set to Null if PreparedPlate->False. Please specify the options `1` or let them resolve automatically.";
Error::AlphaScreenInvalidAssayPlate = "The assay plate model `1` is not compatible with liquid handler. Please consider setting AssayPlateModel to Automatic and PreparedPlate to False. The samples will be aliquoted to compatible plates automatically.";
Warning::AlphaScreenNotBMGPlates = "The plate model `1` doesn't match any available plate layouts in the reader. We recommend to resolve AssayPlateModel automatically or transfer the samples from a prepared plate.";
Error::AlphaScreenWellVolumeBelowLimit = "The assay volume (AlphaAssayVolume) `1` is below the lowest well volume allowed for available plates if AssayPlateModel is set to Automatic. Please make sure the assay volume is larger than `2`.";
Error::AlphaScreenWellVolumeAboveLimit = "The assay volume (AlphaAssayVolume) `1` is above the highest well volume allowed for available plates if AssayPlateModel is set to Automatic. Please make sure the assay volume is less than `2`.";
Warning::AlphaScreenHighWellVolume = "The assay volume (AlphaAssayVolume) `1` is close to the maximum working well volume of the plate `2`.";
Warning::AlphaScreenLowWellVolume = "The assay volume (AlphaAssayVolume) `1` is less than the minimum working well volume of the plate `2`.";
Error::AlphaScreenWellVolumeExceeded = "The assay volume (AlphaAssayVolume) `1` exceeds the maximum well volume of the plate `2`. Please reduce the assay volume.";
Warning::AlphaScreenOpticsOptimizationParametersUnneeded = "When an optics optimization template (OpticsOptimizationTemplate) is used, the options `1` are not needed. The options `1` are ignored and resolved to Null. The Gain and FocalHeight are set based on the template.";
Error::AlphaScreenGainOptimizationParametersUnneeded = "When gain optimization (OptimizeGain) is not needed, `1` should not be specified. Please set `1` to Null or allow the options to resolve automatically, if OptimizeGain->False.";
Error::AlphaScreenGainOptimizationParametersRequired = "When gain optimization (OptimizeGain) is needed, the relevant options `1` cannot be Null. Please specify `1` or let them resolve automatically, if OptimizeGain->True.";
Warning::AlphaScreenNoSamplesSpecifiedForOptimizeGain = "If gain optimization (OptimizeGain) is needed but the GainOptimizationSamples option is left Automatic, it is set to `1`, the first item in the input samples. Please check if it is okay to use `1` as the gain optimization sample or specify them using the GainOptimizationSamples option.";
Warning::AlphaScreenNoSamplesSpecifiedForOptimizeFocalHeight = "If focal height optimization (OptimizeFocalHeight) is needed but the FocalHeightOptimizationSamples option is left Automatic, it is set to `1`, the first item in the input samples. Please check if it is okay to use `1` as the focal height optimization sample or specify them using the FocalHeightOptimizationSamples option.";
Error::AlphaScreenFocalHeightOptimizationParametersUnneeded = "When focal height optimization (OptimizeFocalHeight) is not needed, `1` should not be specified. Please set `1` to Null or allow the options to resolve automatically, if OptimizeFocalHeight->False.";
Error::AlphaScreenFocalHeightOptimizationParametersRequired = "When focal height optimization (OptimizeFocalHeight) is needed, the relevant options `1` cannot be Null. Please specify `1` or let them resolve automatically, if OptimizeFocalHeight->True.";
Error::AlphaScreenInvalidSingleGainOptimizationSample = "When optimizing gain and PreparedPlate->False, only one sample should be provided in GainOptimizationSamples. The sample will be aliquoted multiple times according to the NumberOfGainOptimizations. Please revise the `1` so that it has only one optimization sample.";
Error::AlphaScreenInvalidGainOptimizationSamples = "The gain optimization samples `1` are not found in the prepared plate.";
Error::AlphaScreenRepeatedGainOptimizationSamples = "When optimizing gain and PreparedPlate->True, the gain optimization samples should not have repeats. The `1` has been repeated `2` times. Please check the GainOptimizationSamples.";
Error::AlphaScreenUnequalGainOptimizationSamples = "When optimizing gain and PreparedPlate->True, the amount of gain optimization samples `1` does not match the NumberOfGainOptimizations `2`.";
Error::AlphaScreenInvalidSingleFocalHeightOptimizationSample = "When optimizing focal height and PreparedPlate->False, only one sample should be provided for FocalHeightOptimizationSamples. The sample will be aliquoted multiple times according to the NumberOfFocalHeightOptimizations. Please revise the `1` so that it has only one optimization sample.";
Error::AlphaScreenInvalidFocalHeightOptimizationSamples = "The focal height optimization samples `1` are not found in the prepared plate.";
Error::AlphaScreenRepeatedFocalHeightOptimizationSamples = "When optimizing focal height and PreparedPlate->True, the focal height optimization samples should not have repeats. The `1` has been repeated `2` times. Please check the FocalHeightOptimizationSamples.";
Error::AlphaScreenUnequalFocalHeightOptimizationSamples = "When optimizing focal height and PreparedPlate->True, the amount of focal height optimization samples `1` does not match the NumberOfFocalHeightOptimizations `2`.";
Error::AlphaScreenMixParametersUnneeded = "When PlateReaderMix->False, plate reader mixing parameters such as PlateReaderMixTime cannot be specified. Please set PlateReaderMix->True or allow these options to resolve automatically.";
Error::AlphaScreenMixParametersRequired = "When PlateReaderMix->True, plate reader mixing parameters such as PlateReaderMixTime cannot be set to Null. Please set PlateReaderMix->False or allow these options to resolve automatically.";
Error::AlphaScreenMixParametersConflicting = "When PlateReaderMix is left Automatic, plate reader mixing parameters must all be set to values or all be set to Null. Please consider allowing some of these options to resolve automatically.";
Error::AlphaScreenMoatParametersUnneeded = "When MoatWells->False, moat parameters such as MoatSize cannot be specified. Please set MoatWells->True or allow these options to resolve automatically.";
Error::AlphaScreenMoatParametersRequired = "When MoatWells->True, moat parameters such as MoatSize cannot be set to Null. Please set MoatWells->False or allow these options to resolve automatically.";
Error::AlphaScreenMoatParametersConflicting = "When MoatWells is left Automatic, moat parameters must all be set to values or all be set to Null. Please consider allowing some of these options to resolve automatically.";
Error::AlphaScreenMoatAliquotsRequired = "In order to create a moat, sample must be aliquoted into a new plate and so Aliquot cannot be set to False. Please consider allowing Aliquot to resolve automatically or turn off all moat options.";
Error::AlphaScreenTooManyMoatWells = "The number of wells required to create the moat is too large which limits the available wells for the input samples. Please decrease the moat size.";
Error::AlphaScreenInvalidSampleAliquot = "When PreparedPlate->False, the samples are aliquoted to AssayPlateModel. Please set the Aliquot relevant options to Automatic.";
Error::AlphaScreenConfiltAliquotOption = "All (PreparedPlate->False) or none (PreparedPlate->True) of the samples should be aliquoted. Please consider allowing Aliquot to resolve automatically.";
Error::AlphaScreenWellOverlap = "Some of the wells requested as destinations for assay samples are also needed to create the requested moat (`1`). Please decrease the moat size or modify DestinationWell.";
Error::AlphaScreenMoatVolumeOverlimit = "The MoatVolume is above the highest well volume allowed for available plates if AssayPlateModel is set to Automatic. Please specify a lower volume or consider allowing this option to resolve automatically.";
Error::AlphaScreenMoatVolumeOverflow = "The MoatVolume must be less than the MaxVolume of the aliquot container. Please specify a lower volume or consider allowing this option to resolve automatically.";
Error::AlphaScreenCoverNotRecommended = "We currently do not support plate seal or lid on during the measurement in plate reader because AlphaScreen can only read from top. Please set RetainCover to false. If it is a prepared plate with lid, the lid will be removed during the measurement and put back after the measurement is done.";
Error::AlphaScreenInvalidExcitationWavelength = "The excitation wavelength (`1`) for AlphaScreen is not set as 680nm.";
Error::NumberOptimizationSamples = "We currently support all the optics optimization samples in one plate. Please reduce the number (`1`) of optimization samples or make sure they are all in one plate.";

(* global variable for the alpha plates *)
$AlphaPlates = {
	Model[Container, Plate, "id:jLq9jXvzR0XR"], (* "AlphaPlate Half Area 96-Well Gray Plate" *)
	Model[Container, Plate, "id:7X104vneWNvw"], (* "AlphaPlate Half Area 96-Well Gray Plate, Low Binding Surface" *)
	Model[Container, Plate, "id:1ZA60vL978v8"], (* "AlphaPlate 384-Well Gray Plate" *)
	Model[Container, Plate, "id:Z1lqpMzn3JMV"], (* "AlphaPlate 384-Well Gray Plate, Low Binding Surface" *)
	Model[Container, Plate, "id:dORYzZJqe6e5"], (* "AlphaPlate 384-Shallow-Well Gray Plate" *)
	Model[Container, Plate, "id:eGakldJRp9po"] (* "AlphaPlate 384-Shallow-Well Gray Plate, Low Binding Surface" *)
};

(* ::Subsubsection:: *)
(*ExperimentAlphaScreen*)


ExperimentAlphaScreen[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		upload, confirm, canaryBranch, fastTrack, parentProt, cache, simulatedProtocol, simulation, estimatedRunTime,
		samplePreparationSimulation, safeOptions, safeOptionsTests, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, returnEarlyQ, performSimulationQ, protocolObject, resourcePackets, resourcePacketTests,
		optionsWithObjects, allObjects, objectSamplePacketFields, modelSamplePacketFields, objectContainerFields,
		modelContainerFields, modelContainerObjects, instrumentObjects, modelInstrumentObjects, modelSampleObjects, sampleObjects,
		mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, downloadValues, modelFields,
		modelPacketFields, modelContainerPacketFields, modelInstrumentPacketFields, instrumentPacketFields, modelInstrumentFields
	},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAlphaScreen,
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

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionsTests} = If[gatherTests,
		SafeOptions[ExperimentAlphaScreen, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAlphaScreen, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAlphaScreen, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAlphaScreen, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];


	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentAlphaScreen, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAlphaScreen, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOptions, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentAlphaScreen, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Any options whose values could be an object *)
	optionsWithObjects = {
		Instrument,
		AssayPlateModel,
		OpticsOptimizationTemplate,
		GainOptimizationSamples,
		FocalHeightOptimizationSamples,
		MoatBuffer
	};

	(* $AlphaPlates are the plate models that we need to use in this experiment *)
	allObjects = Cases[
		Flatten[{
			mySamplesWithPreparedSamples,
			Lookup[expandedSafeOps, optionsWithObjects],
			$AlphaPlates
		}],
		ObjectReferenceP[],
		Infinity
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields = Packet @@ SamplePreparationCacheFields[Object[Sample]];
	modelFields = SamplePreparationCacheFields[Model[Sample]];
	modelSamplePacketFields = Packet[Model[modelFields]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = Flatten[{SamplePreparationCacheFields[Model[Container]], BMGLayout}];

	(* for Downloading not through links through the sample  *)
	modelPacketFields = Packet @@ modelFields;
	modelContainerPacketFields = Packet @@ modelContainerFields;
	modelInstrumentFields = {Object, Name, WettedMaterials, Deprecated, OpticModules, MinTemperature, MaxTemperature, AlphaScreenEmissionFilter, AlphaScreenExcitationLaserWavelength, IntegratedLiquidHandlers};
	modelInstrumentPacketFields = Packet @@ modelInstrumentFields;
	instrumentPacketFields = Packet[Object, Name, Status, Model, Deprecated, OpticModules, MinTemperature, MaxTemperature, AlphaScreenEmissionFilter, AlphaScreenExcitationLaserWavelength, IntegratedLiquidHandler];

	modelContainerObjects = Cases[allObjects, ObjectReferenceP[Model[Container]]];
	instrumentObjects = Cases[allObjects, ObjectReferenceP[Object[Instrument, PlateReader]]];
	modelInstrumentObjects = Cases[allObjects, ObjectReferenceP[Model[Instrument, PlateReader]]];
	modelSampleObjects = Cases[allObjects, ObjectReferenceP[Model[Sample]]];
	sampleObjects = Cases[allObjects, ObjectReferenceP[Object[Sample]]];

	downloadValues = Quiet[
		Download[
			{
				sampleObjects,
				modelSampleObjects,
				instrumentObjects,
				modelInstrumentObjects,
				modelContainerObjects
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All, 2]][{CellType}]]
				},
				{
					modelPacketFields
				},
				{
					instrumentPacketFields,
					Packet[Model[modelInstrumentFields]],
					Packet[IntegratedLiquidHandler[Model]],
					Packet[IntegratedLiquidHandler[Model][Object]]
				},
				{
					modelInstrumentPacketFields,
					Packet[IntegratedLiquidHandlers[Object]]
				},
				{
					modelContainerPacketFields
				}
			},
			Cache -> cache,
			Simulation -> samplePreparationSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	cacheBall = FlattenCachePackets[{cache, downloadValues}];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentAlphaScreenOptions[mySamplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> samplePreparationSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentAlphaScreenOptions[mySamplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> samplePreparationSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentAlphaScreen,
		resolvedOptions,
		Ignore -> ToList[myOptions],
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

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP] || MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> RemoveHiddenOptions[ExperimentAlphaScreen, collapsedResolvedOptions],
			Preview -> Null,
			Tests -> Join[safeOptionsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Simulation -> Simulation[],
			RunTime -> 0 Minute
		}]
	];

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
		{$Failed, {}},
		gatherTests,
		alphaScreenResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation, Output -> {Result, Tests}],
		True,
		{alphaScreenResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Simulation -> samplePreparationSimulation], {}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, AlphaScreen],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				ToList[resourcePackets[[2]]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation
		],
		{Null, Null}
	];

	estimatedRunTime = 15 Minute + (Lookup[resolvedOptions, PlateReaderMixTime] /. Null -> 0 Minute);

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOptionsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentAlphaScreen, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> estimatedRunTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject = Which[

		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, return $Failed *)
		MatchQ[resourcePackets, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions, Preparation], Robotic] && MatchQ[upload, False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions, Preparation], Robotic],
		Module[{primitive, nonHiddenOptions, experimentFunction},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive = AlphaScreen @@ Join[
				{
					Sample -> mySamples
				},
				RemoveHiddenPrimitiveOptions[AlphaScreen, ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions = RemoveHiddenOptions[ExperimentAlphaScreen, collapsedResolvedOptions];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentAlphaScreen so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentAlphaScreen, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache = <||>;

				DownValues[ExperimentAlphaScreen] = {};

				ExperimentAlphaScreen[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification = Lookup[ToList[options], Output];

					frameworkOutputSpecification /. {
						Result -> resourcePackets[[2]],
						Options -> nonHiddenOptions,
						Preview -> Null,
						Simulation -> simulation,
						RunTime -> estimatedRunTime
					}
				];

				experimentFunction[
					{primitive},
					Name -> Lookup[safeOptions, Name],
					Upload -> Lookup[safeOptions, Upload],
					Confirm -> Lookup[safeOptions, Confirm],
					CanaryBranch -> Lookup[safeOptions, CanaryBranch],
					ParentProtocol -> Lookup[safeOptions, ParentProtocol],
					Priority -> Lookup[safeOptions, Priority],
					StartDate -> Lookup[safeOptions, StartDate],
					HoldOrder -> Lookup[safeOptions, HoldOrder],
					QueuePosition -> Lookup[safeOptions, QueuePosition],
					Cache -> cacheBall
				]
			]
		],

		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			Upload -> Lookup[safeOptions, Upload],
			Confirm -> Lookup[safeOptions, Confirm],
			CanaryBranch -> Lookup[safeOptions, CanaryBranch],
			ParentProtocol -> Lookup[safeOptions, ParentProtocol],
			Priority -> Lookup[safeOptions, Priority],
			StartDate -> Lookup[safeOptions, StartDate],
			HoldOrder -> Lookup[safeOptions, HoldOrder],
			QueuePosition -> Lookup[safeOptions, QueuePosition],
			ConstellationMessage -> Object[Protocol, AlphaScreen],
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentAlphaScreen, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];


(* Note: The container overload should come after the sample overload. *)
ExperimentAlphaScreen[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, containerToSampleSimulation,
		samplePreparationSimulation, containerToSampleResult, containerToSampleOutput, updatedCache, samples, sampleOptions, containerToSampleTests},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* convert input into list if they are not already in list form *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAlphaScreen,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentAlphaScreen,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentAlphaScreen,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Update our cache with our new simulated values. *)
	(* It is important the sample preparation cache appears first in the cache ball. *)
	updatedCache = Flatten[{
		Lookup[listedOptions, Cache, {}]
	}];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> containerToSampleSimulation
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;
		(* Call our main function with our samples and converted options. *)
		ExperimentAlphaScreen[samples, ReplaceRule[sampleOptions, {Cache -> updatedCache, Simulation -> containerToSampleSimulation}]]
	]
];

(* ::Subsubsection:: *)

(*--Helper functions--*)
(* Returns the wells which should be filled to make the moat *)
alphaScreenGetMoatWells[plateWells : {{_String..}..}, moatSize_Integer] := Module[{minDimension},

	(* Get Min[{column,row}] *)
	minDimension = Min[Dimensions[plateWells]];

	(* Our moat will fill the perimeter wells *)
	(* We will take the first N rows, the last N rows, the first N columns and the last N columns *)
	(* This means moat size can't be more than half our minDimension, else we'll be covering the full plate *)
	If[moatSize <= Floor[minDimension / 2],
		DeleteDuplicates[
			Flatten[
				{
					Take[plateWells, moatSize],
					Take[plateWells, -moatSize],
					Take[Transpose[plateWells], moatSize],
					Take[Transpose[plateWells], -moatSize]
				},
				2
			]
		],
		Flatten[plateWells]
	]
];

(* NOTE: This is what the code below implicitly does, it simply checks that it can fit on the deck and that it's a plate *)
(* with a BMGLayout. *)
BMGCompatiblePlates[AlphaScreen] := BMGCompatiblePlates[AlphaScreen] = Module[
	{compatiblePlates},

	(* get all the compatible plates; they don't even necessarily need to be liquid handleable *)
	compatiblePlates = Intersection[
		Experiment`Private`hamiltonAliquotContainers["Memoization"],
		Search[
			Model[Container, Plate],
			BMGLayout != Null
		]
	]
];

(*--Resolver--*)
DefineOptions[
	resolveExperimentAlphaScreenOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentAlphaScreenOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentAlphaScreenOptions]] := Module[
	{outputSpecification, output, gatherTests, message, cache, samplePrepOptions, alphaScreenOptions, simulatedSamples,
		resolvedSamplePrepOptions, simulatedCache, samplePrepTests, simulation, updatedSimulation, preparationResult, allowedPreparation,
		preparationTest, resolvedPreparation, alphaScreenOptionsAssociation, invalidInputs, invalidOptions, targetContainers,
		requiredAliquotAmounts, resolvedAliquotOptions, aliquotTests, suppliedPlateReader,
		samplePackets, suppliedPlateReaderModelPacket, suppliedPlateReaderObjPacket,
		sampleContainerModelPackets, duplicateSampleError, alphaPlatePackets,
		invalidRepeatSamples, repeatedSampleTest, invalidInstrumentOption,
		invalidInstrumentQ, availablePlateReaderTest, preparedPlateParametersCheckQ, compatiblePlateTypes, incompatiblePlatesBoolean,
		invalidAssayPlateTest, notBMGPlatesBoolean,
		optionPrecisions, filteredOptionPrecisions, roundedAlphaScreenOptionsAssociation,
		optionPrecisionTests, notBMGPlatesTest,
		preparedPlate, preparedPlateIrrelevantCheckList,
		preparedPlateIrrelevant, notNullPreparedPlateIrrelevantBoolean , preparedPlateIrrelevantOptions, invalidPreparedPlateIrrelevantQ,
		preparedPlateIrrelevantTest, assayPlateInfoRequiredCheckList, assayPlateInfoRequired, nullAssayPlateInfoRequiredBoolean,
		assayPlateInfoRequiredOptions, assayPlateInfoRequiredQ, assayPlateInfoRequiredTest, sampleVolumeList, sampleObjectList,
		alphaAssayVolume, plateLowVolumeLimit, invalidLowAlphaAssayVolumeOption, invalidLowAlphaAssayVolumeQ, alphaAssayVolumeLowLimitTest,
		plateHighVolumeLimit, invalidHighAlphaAssayVolumeOption, invalidHighAlphaAssayVolumeQ, alphaAssayVolumeHighLimitTest,
		assayPlateModel, minVolume, maxVolume, recommendedFillVolume, invalidAlphaAssayVolumeOption, invalidAlphaAssayVolumeQ,
		alphaAssayVolumeTest, highWellVolumeWarningQ, lowWellVolumeWarningQ, assayPlateModelPacket, highWellVolumeWarning, lowWellVolumeWarning,
		gain, focalHeight, plateReaderMix, mixParameterCheckList, mixParameter,
		notNullMixParameterBoolean, invalidNotNullMixParameterOptions, nullMixParameterBoolean, invalidNullMixParameterOptions,
		invalidNotNullMixParameterQ, invalidNullMixParameterQ, mixParametersUnneededTest, mixParametersRequiredTest, conflictingMixParameterQ,
		invalidConflictingMixParameterOptions, conflictingMixParameterTest, moatWells, moatParameterCheckList, moatParameter,
		notNullMoatParameterBoolean, invalidNotNullMoatParameterOptions, invalidNullMoatParameterOptions, invalidNotNullMoatParameterQ,
		invalidNullMoatParameterQ, moatParametersUnneededTest, nullMoatParameterBoolean, moatParametersRequiredTest,
		conflictingMoatParameterQ, invalidConflictingMoatParameterOptions, conflictingMoatParameterTest, allTogetherMoatParameterBoolean,
		invalidMoatParametersTogetherOptions, invalidMoatParametersTogetherQ, aliquot, impliedMoat, moatAliquotError,
		invalidMoatAliquotOptions, moatAliquotTest, invalidHighMoatVolumeOption, invalidHighMoatVolumeOptionQ, invalidHighMoatVolumeTest,
		invalidMoatVolumeOption, invalidMoatVolumeOptionQ, invalidMoatVolumeTest, destinationWells, validMoatSize, conflictingWells,
		invalidMoatSizeOption, invalidMoatSizeOptionQ, moatSizeTest, conflictingWellsQ, invalidDestinationWellsOption,
		invalidDestinationWellsQ, conflictingWellsTest, retainCover, coverOnUnrecommended, coverOnUnrecommendedTest,
		excitationWavelength, invalidExcitationWavelengthOption, invalidExcitationWavelengthTest, emissionWavelength,
		resolvedPlateReaderMixTime, resolvedPlateReaderMixRate, resolvedPlateReaderMixMode,
		resolvedMoatWells, resolvedMoatSize, resolvedMoatVolume, resolvedMoatBuffer, resolvedAlphaAssayVolume,
		totalNumberOfSamples,
		resolvedAssayPlateModel, resolvedAssayPlateModelPacket,
		resolvedGain, resolvedFocalHeight, conflictSampleAliquotOptions, conflictSampleAliquotOptionsQ, conflictSampleAliquotOptionsTest,
		notAliquotSampleBoolean, falseSampleAliquotQ, invalidSampleAliquotQ, invalidSampleAliquotOptions, invalidSampleAliquotTest,
		resolvedAliquot, resolvedACUOptions, resolvedACUInvalidOptions, resolvedACUTests,
		availableAssayWells, suppliedDestinationWells, suppliedDestinationWellsQ, plateWells, reservedMoatWells,
		duplicateDestinationWells, duplicateDestinationWellOption, duplicateDestinationWellTest, requiredNumberOfPlates, allTargetContainers,
		allDestinationWells, transferredContainers, transferredWells,
		updateResolvedAliquotOptions, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode, resolvedPlateReaderMix,
		moatSize, moatVolume, moatBuffer, resolvedPostProcessingOptions, instrument, numberOfReplicates,
		readDirection, readTemperature, readEquilibrationTime,
		settlingTime, excitationTime, delayTime, integrationTime, storeMeasuredPlates, confirm, canaryBranch, imageSample, name, template,
		samplesInStorageCondition, preparatoryPrimitives, email, fastTrack, operator, outputOption, parentProtocol, upload,
		resolvedOptions, allTests, resolvedSampleLabels, resolvedSampleContainerLabels,
		resolvedWorkCell,nAdd, invalidInstrumentOptionName, invalidAssayPlateModelOptionName,
		engineQ, invalidDestinationWellsOptionName, conflictSampleAliquotOptionsName, invalidSampleAliquotOptionsName,
		fastAssoc},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	message = !gatherTests;
	engineQ = MatchQ[$ECLApplication, Engine];

	(* Fetch our cache and simulation from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Separate out our AlphaScreen options from our Sample Prep options. *)
	{samplePrepOptions, alphaScreenOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentAlphaScreen, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentAlphaScreen, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Merge the simulation result into the simulatedCache *)
	simulatedCache = FlattenCachePackets[{cache, Lookup[updatedSimulation[[1]], Packets]}];

	(* get the fast assoc from the simulated cache to help with looking stuff up *)
	fastAssoc = makeFastAssocFromCache[simulatedCache];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	alphaScreenOptionsAssociation = Association[alphaScreenOptions];

	(* == Pulling packets out == *)

	(* Extract the packets that we need from our fastAssoc. *)
	(* note that since our fastAssoc has simulated values in here, we don't need to Download at all *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSamples;
	sampleContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ simulatedSamples;

	(* Get requested plate reader Object or Model*)
	suppliedPlateReader = Lookup[alphaScreenOptionsAssociation, Instrument];

	(* get the plate reader model and object packets *)
	suppliedPlateReaderModelPacket = Switch[suppliedPlateReader,
		ObjectP[Model[Instrument]],
		fetchPacketFromFastAssoc[suppliedPlateReader, fastAssoc],
		ObjectP[Object[Instrument]],
		fastAssocPacketLookup[fastAssoc, suppliedPlateReader, Model],
		_,
		Null
	];

	suppliedPlateReaderObjPacket = If[MatchQ[suppliedPlateReader, ObjectP[Object[Instrument]]],
		fetchPacketFromFastAssoc[suppliedPlateReader, fastAssoc],
		Null
	];

	(* get the packets for the AlphaPlates that we have to use in this experiment *)
	alphaPlatePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ $AlphaPlates;

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* START: -- Repeated samples check -- *)
	(* If given the same sample multiple times, we have to aliquot everything *)
	duplicateSampleError = MemberQ[Lookup[samplePrepOptions, Aliquot], False] && !DuplicateFreeQ[Lookup[samplePackets, Object]];

	(* Track invalid input error *)
	invalidRepeatSamples = If[duplicateSampleError,
		Cases[Tally[Lookup[samplePackets, Object]], {_, GreaterP[1]}][[All, 1]],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[duplicateSampleError && message,
		Message[Error::AlphaScreenRepeatedPlateReaderSamples, ObjectToString[invalidRepeatSamples, Cache -> simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	repeatedSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!duplicateSampleError,
				Nothing,
				Test["If any samples are repeated in the input then they are set to be aliquoted since repeat readings are performed on aliquots of the input samples:", True, False]
			];

			passingTest = If[duplicateSampleError,
				Nothing,
				Test["If any samples are repeated in the input then they are set to be aliquoted since repeat readings are performed on aliquots of the input samples:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* END: -- Repeated samples check -- *)

	(* START: -- Retired plate reader check -- *)

	(* Set invalidInstrumentOption to the Instrument option if a non-alpha-screen-compatible plate reader was selected*)
	{invalidInstrumentOption, invalidInstrumentOptionName} = If[!NullQ[suppliedPlateReaderModelPacket] && MemberQ[Lookup[suppliedPlateReaderModelPacket, {AlphaScreenExcitationLaserWavelength, AlphaScreenEmissionFilter}], Null],
		{ToList[suppliedPlateReader], {Instrument}},
		{{}, {}}
	];

	(* Invalid plate reader check tracking boolean *)
	invalidInstrumentQ = Length[invalidInstrumentOption] > 0;

	(* If none of the plate reader objects is either available or running and we are throwing messages, throw an error message and keep track of the invalid option.*)
	If[invalidInstrumentQ && message,
		Message[Error::AlphaScreenNotSupportedPlateReader, ObjectToString[invalidInstrumentOption, Cache -> simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	availablePlateReaderTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidInstrumentQ,
				Nothing,
				Test["The instrument " <> ObjectToString[invalidInstrumentOption, Cache -> simulatedCache] <> " can perform AlphaScreen:", True, False]
			];

			passingTest = If[invalidInstrumentQ,
				Nothing,
				Test["The instrument " <> ObjectToString[invalidInstrumentOption, Cache -> simulatedCache] <> " can perform AlphaScreen:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];
	(* END: -- Retired plate reader check -- *)

	(*Because the samples will not contact with the plate reader, we skip the CompatibleMaterials check*)

	(*-- OPTION PRECISION CHECKS --*)

	(* Gather precisions for all our options across the board *)
	optionPrecisions = {
		{AlphaAssayVolume, 10^-1 Microliter},
		{TargetSaturationPercentage, 1 Percent},
		{ReadTemperature, 10^-1 Celsius},
		{ReadEquilibrationTime, 1 Second},
		{TargetOxygenLevel,10^-1 Percent},
		{TargetCarbonDioxideLevel,10^-1 Percent},
		{AtmosphereEquilibrationTime,1 Second},
		{PlateReaderMixTime, 1 Second},
		{PlateReaderMixRate, 100 RPM},
		{Gain, 1 Microvolt},
		{FocalHeight, 10^-1 Millimeter},
		{SettlingTime, 10^-1 Second},
		{ExcitationTime, 10^-2 Second},
		{DelayTime, 10^-2 Second},
		{IntegrationTime, 10^-2 Second},
		{ExcitationWavelength, 1 Nanometer},
		{EmissionWavelength, 1 Nanometer},
		{MoatVolume, 1 Microliter}
	};

	(* Send RoundOptionPrecision only the options that apply to our current function *)
	filteredOptionPrecisions = Select[optionPrecisions, MemberQ[alphaScreenOptions[[All, 1]], First[#]]&];

	(* Verify that the experiment options are not overly precise *)
	{roundedAlphaScreenOptionsAssociation, optionPrecisionTests} = If[gatherTests,
		RoundOptionPrecision[alphaScreenOptionsAssociation, filteredOptionPrecisions[[All, 1]], filteredOptionPrecisions[[All, 2]], Output -> {Result, Tests}],
		{RoundOptionPrecision[alphaScreenOptionsAssociation, filteredOptionPrecisions[[All, 1]], filteredOptionPrecisions[[All, 2]]], Null}
	];

	(* Resolve our preparation option. *)
	preparationResult = Quiet[Check[
		{allowedPreparation, preparationTest} = If[MatchQ[gatherTests, False],
			{
				Experiment`Private`resolveReadPlateMethod[mySamples, Object[Protocol, AlphaScreen], ReplaceRule[Normal@roundedAlphaScreenOptionsAssociation, {Cache -> simulatedCache, Output -> Result}], {Cache -> simulatedCache, Output -> Result, Simulation -> simulation}],
				{}
			},
			Experiment`Private`resolveReadPlateMethod[mySamples, Object[Protocol, AlphaScreen], ReplaceRule[Normal@roundedAlphaScreenOptionsAssociation, {Cache -> simulatedCache, Output -> {Result, Tests}}], {Cache -> simulatedCache, Output -> {Result, Tests}, Simulation -> simulation}]
		],
		$Failed
	]];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation = If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve our WorkCell option. Do this after resolving the Preparation option, as this is only relevant if the experiment will be performed robotically.*)
	resolvedWorkCell = If[MatchQ[resolvedPreparation, Robotic],
		FirstOrDefault@Experiment`Private`resolveReadPlateWorkCell[ExperimentAlphaScreen, mySamples, ReplaceRule[Normal@roundedAlphaScreenOptionsAssociation, {Cache -> simulatedCache, Preparation -> resolvedPreparation}]],
		Null
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* All lookup for the variables *)
	preparedPlate = Lookup[roundedAlphaScreenOptionsAssociation, PreparedPlate];

	(* Get the assay plate information:
	if PreparedPlate->True, get the ContainersIn
	if PreparedPlate->False, get the AssayPlateModel *)
	assayPlateModel = If[MatchQ[preparedPlate, True],
		First@Lookup[sampleContainerModelPackets, Object],
		Lookup[roundedAlphaScreenOptionsAssociation, AssayPlateModel]
	];
	assayPlateModelPacket = If[MatchQ[assayPlateModel, ObjectP[Model[Container, Plate]]],
		fetchPacketFromFastAssoc[assayPlateModel, fastAssoc],
		Automatic
	];

	(* Obtain a list of all liquid handler compatible plate Models *)
	compatiblePlateTypes = Experiment`Private`hamiltonAliquotContainers["Memoization"];

	(* pull out information about the assay plate's minima and maxima *)
	{minVolume, maxVolume, recommendedFillVolume} = If[MatchQ[assayPlateModel, ObjectP[Model[Container, Plate]]],
		Lookup[assayPlateModelPacket, {MinVolume, MaxVolume, RecommendedFillVolume}],
		{Null, Null, Null}
	];

	(* --PreparedPlate check-- *)
	(* Obtain the default options from {AssayPlateModel, AlphaAssayVolume, NumberOfReplicates, MoatWells} that should be Null when PreparedPlate is True *)
	(* For a PreparedPlate, we will not allow any aliquot. The plate will be read as it is *)
	preparedPlateIrrelevantCheckList = {AssayPlateModel, AlphaAssayVolume, NumberOfReplicates, MoatWells};

	preparedPlateIrrelevant = Lookup[roundedAlphaScreenOptionsAssociation, preparedPlateIrrelevantCheckList];

	(* Get the options that are not Null, automatic or false, if the PreparedPlate is True *)
	notNullPreparedPlateIrrelevantBoolean = !MatchQ[#, Null | Automatic | False]& /@ preparedPlateIrrelevant;

	(* Check for Aliquot. The Aliquot cannot be True for a prepared plate *)
	(* Get the Aliquot option *)
	aliquot = Lookup[samplePrepOptions, Aliquot];

	(* Gather the invalid options that are not Null when the PreparedPlate is True. If PreparedPlate->False, set the tracking variable to Null *)
	(* Prepend the Aliquot to the check list *)
	preparedPlateIrrelevantOptions = If[MatchQ[preparedPlate, True],
		PickList[Join[preparedPlateIrrelevantCheckList, {Aliquot}], Join[notNullPreparedPlateIrrelevantBoolean, {MemberQ[Lookup[samplePrepOptions, Aliquot], True]}]],
		{}
	];

	(* Invalid options tracking boolean *)
	invalidPreparedPlateIrrelevantQ = Length[preparedPlateIrrelevantOptions] > 0;

	(* Do the check only if the PreparedPlate is True *)
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::PreparedPlateIrrelevant. *)
	If[invalidPreparedPlateIrrelevantQ && message,
		Message[Error::AlphaScreenPreparedPlateIrrelevant, preparedPlateIrrelevantOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	preparedPlateIrrelevantTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidPreparedPlateIrrelevantQ,
				Nothing,
				Test["When a PreparedPlate is used, the irrelevant options " <> ObjectToString[preparedPlateIrrelevantOptions, Cache -> simulatedCache] <> " are set to Null:", True, False]
			];

			passingTest = If[invalidPreparedPlateIrrelevantQ,
				Nothing,
				Test["When a PreparedPlate is used, the irrelevant options " <> ObjectToString[Complement[preparedPlateIrrelevantCheckList, preparedPlateIrrelevantOptions], Cache -> simulatedCache] <> " are set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Obtain the default options from {AssayPlateModel, AlphaAssayVolume} that should be specified when PreparedPlate is False *)
	assayPlateInfoRequiredCheckList = {AssayPlateModel, AlphaAssayVolume};

	assayPlateInfoRequired = Lookup[roundedAlphaScreenOptionsAssociation, assayPlateInfoRequiredCheckList];

	(* Get the options that are Null, if the PreparedPlate is False *)
	nullAssayPlateInfoRequiredBoolean = MatchQ[#, Null]& /@ assayPlateInfoRequired;

	(* Gather the invalid options that are Null when the PreparedPlate is False. If PreparedPlate->True, set the tracking variable to Null *)
	assayPlateInfoRequiredOptions = If[MatchQ[preparedPlate, False],
		PickList[assayPlateInfoRequiredCheckList, nullAssayPlateInfoRequiredBoolean],
		{}
	];

	(* Invalid options tracking boolean *)
	assayPlateInfoRequiredQ = Length[assayPlateInfoRequiredOptions] > 0;

	(* Do the check only if the PreparedPlate is False *)
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AssayPlateInfoRequired. *)
	If[assayPlateInfoRequiredQ && message,
		Message[Error::AlphaScreenAssayPlateInfoRequired, assayPlateInfoRequiredOptions];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	assayPlateInfoRequiredTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!assayPlateInfoRequiredQ,
				Nothing,
				Test["The options " <> ObjectToString[assayPlateInfoRequiredOptions, Cache -> simulatedCache] <> " are specified unless a PreparedPlate is given:", True, False]
			];

			passingTest = If[assayPlateInfoRequiredQ,
				Nothing,
				Test["The options " <> ObjectToString[Complement[assayPlateInfoRequiredCheckList, assayPlateInfoRequiredOptions], Cache -> simulatedCache] <> " are specified unless a PreparedPlate is given:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Set a PreparedPlate related check boolean. This check will master all other checks that relate to the parameters (AssayPlateModel, AlphaAssayVolume and MoatWells) *)
	preparedPlateParametersCheckQ = (!invalidPreparedPlateIrrelevantQ) && (!assayPlateInfoRequiredQ);

	(* START: -- Microplate and liquid handler compatible check *)

	(* Track if the plate model is compatible with liquid handler *)
	(* If AssayPlateMode is Automatic, we will resolve it to a compatible plate *)
	incompatiblePlatesBoolean = And[
		(* note that here I'm only matching against ObjectP[] (NOT Except[Automatic]) because if it is Null, then we already have a different error check for if that is ok *)
		MatchQ[assayPlateModel, ObjectP[]],
		Not[MemberQ[compatiblePlateTypes, assayPlateModel]]
	];

	(* If the plate (AssayPlateModel if PreparedPlate->False, or ContainersIn if PreparedPlate->True) in options is not compatible with liquid handler and we are throwing messages, throw an error message and keep track of the invalid option.*)
	invalidAssayPlateModelOptionName = If[incompatiblePlatesBoolean && message,
		(
			Message[Error::AlphaScreenInvalidAssayPlate, ObjectToString[assayPlateModel, Cache -> simulatedCache]];
			{AssayPlateModel}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidAssayPlateTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[incompatiblePlatesBoolean],
				Nothing,
				Test["The specified assay plate model is compatible with the liquid handler:", True, False]
			];

			passingTest = If[incompatiblePlatesBoolean,
				Nothing,
				Test["The specified assay plate model is compatible with the liquid handler:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* End: -- Microplate and liquid handler compatible check *)

	(* START: -- Microplate and BMG plate reader compatible check *)
	(* If the microplate does not have BMGLayout, we will throw a warning. *)
	notBMGPlatesBoolean = And[
		(* note that here I'm only matching against ObjectP[] (NOT Except[Automatic]) because if it is Null, then we already have a different error check for if that is ok *)
		MatchQ[assayPlateModel, ObjectP[]],
		NullQ[Lookup[assayPlateModelPacket, BMGLayout]]
	];

	If[notBMGPlatesBoolean && message && Not[engineQ],
		Message[Warning::AlphaScreenNotBMGPlates, ObjectToString[assayPlateModel, Cache -> simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	notBMGPlatesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Not[incompatiblePlatesBoolean],
				Nothing,
				Warning["The assay plate model " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> " has its BMGLayout field populatedP:", True, False]
			];

			passingTest = If[incompatiblePlatesBoolean,
				Nothing,
				Warning["The assay plate model " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> " has its BMGLayout field populatedP:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* End: -- Microplate and BMG plate reader compatible check *)

	(* Get the sample Volume from mySamples and its Object. *)
	sampleVolumeList = Lookup[samplePackets, Volume];
	sampleObjectList = Lookup[samplePackets, Object];

	(* Get the AlphaAssayVolume from roundedAlphaScreenOptionsAssociation *)
	alphaAssayVolume = Lookup[roundedAlphaScreenOptionsAssociation, AlphaAssayVolume];

	(* --AlphaAssayVolume lower limit check-- *)

	plateLowVolumeLimit = Min[Lookup[alphaPlatePackets, MinVolume]];
	plateHighVolumeLimit = Max[Lookup[alphaPlatePackets, MaxVolume]];

	(* Set invalidLowAlphaAssayVolumeOption if the AlphaAssayVolume is less than the lowest working volume. *)
	invalidLowAlphaAssayVolumeOption = If[
		And[
			!MatchQ[alphaAssayVolume, Automatic],
			alphaAssayVolume < plateLowVolumeLimit,
			preparedPlateParametersCheckQ,
			MatchQ[preparedPlate, False],
			MatchQ[Lookup[roundedAlphaScreenOptionsAssociation, AssayPlateModel], Automatic]
		],
		{AlphaAssayVolume},
		{}
	];

	(* Invalid option tracking boolean *)
	invalidLowAlphaAssayVolumeQ = Length[invalidLowAlphaAssayVolumeOption] > 0;

	(* If the AlphaAssayVolume in options is below the lowest working volume of plates and we are throwing messages, throw an error message and keep track of the invalid option.*)
	If[invalidLowAlphaAssayVolumeQ && message,
		Message[Error::AlphaScreenWellVolumeBelowLimit, ObjectToString[alphaAssayVolume, Cache -> simulatedCache], ObjectToString[plateLowVolumeLimit, Cache -> simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	alphaAssayVolumeLowLimitTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidLowAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) is not below 10uL (the lowest well volume of all available plates for AlphaScreen):", True, False]
			];

			passingTest = If[invalidLowAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) is not below 10uL (the lowest well volume of all available plates for AlphaScreen):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --AlphaAssayVolume upper limit check-- *)

	(* Set invalidHighAlphaAssayVolumeOption if the AlphaAssayVolume is greater than the highest working volume. *)
	invalidHighAlphaAssayVolumeOption = If[
		And[
			!MatchQ[alphaAssayVolume, Automatic],
			alphaAssayVolume > plateHighVolumeLimit,
			preparedPlateParametersCheckQ,
			MatchQ[preparedPlate, False],
			MatchQ[Lookup[roundedAlphaScreenOptionsAssociation, AssayPlateModel], Automatic]
		],
		{AlphaAssayVolume},
		{}
	];

	(* Invalid option tracking boolean *)
	invalidHighAlphaAssayVolumeQ = Length[invalidHighAlphaAssayVolumeOption] > 0;

	(* If the AlphaAssayVolume in options is above the highest working volume of plates and we are throwing messages, throw an error message and keep track of the invalid option.*)
	If[invalidHighAlphaAssayVolumeQ && message,
		Message[Error::AlphaScreenWellVolumeAboveLimit, ObjectToString[alphaAssayVolume, Cache -> simulatedCache], ObjectToString[plateHighVolumeLimit, Cache -> simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	alphaAssayVolumeHighLimitTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidHighAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) is not above 180uL (the highest well volume of all available plates for AlphaScreen):", True, False]
			];

			passingTest = If[invalidHighAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) is not above 180uL (the highest well volume of all available plates for AlphaScreen):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --AssayPlateModel vs. AlphaAssayVolume check-- *)

	(* Set invalidAlphaAssayVolume if AssayPlateModel is specified with Model and well volume is exceeded. *)
	invalidAlphaAssayVolumeOption = If[
		And[
			preparedPlateParametersCheckQ,
			!invalidHighAlphaAssayVolumeQ,
			!invalidLowAlphaAssayVolumeQ,
			alphaAssayVolume > maxVolume,
			!MatchQ[alphaAssayVolume, Automatic],
			MatchQ[assayPlateModel, ObjectP[]],
			MatchQ[preparedPlate, False],
			!incompatiblePlatesBoolean
		],
		{AlphaAssayVolume},
		{}
	];

	(* invalid option tracking boolean *)
	invalidAlphaAssayVolumeQ = Length[invalidAlphaAssayVolumeOption] > 0;

	(* Check the alphaAssayVolume with volume limits of the AssayPlateModel and throw Warning or Error messages*)
	highWellVolumeWarningQ = And[
		preparedPlateParametersCheckQ,
		alphaAssayVolume > recommendedFillVolume,
		alphaAssayVolume < maxVolume,
		!MatchQ[alphaAssayVolume, Automatic],
		!invalidHighAlphaAssayVolumeQ,
		MatchQ[assayPlateModel, ObjectP[]],
		MatchQ[preparedPlate, False],
		!incompatiblePlatesBoolean,
		message,
		!engineQ
	];

	If[highWellVolumeWarningQ,
		Message[Warning::AlphaScreenHighWellVolume, ObjectToString[alphaAssayVolume, Cache -> simulatedCache], ObjectToString[assayPlateModel, Cache -> simulatedCache]];
	];

	highWellVolumeWarning = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!highWellVolumeWarningQ,
				Nothing,
				Warning["The assay volume (AlphaAssayVolume) is close the maximum working cell volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, False]
			];

			passingTest = If[highWellVolumeWarningQ,
				Nothing,
				Warning["The assay volume (AlphaAssayVolume) is close the maximum working cell volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	lowWellVolumeWarningQ = And[
		preparedPlateParametersCheckQ,
		alphaAssayVolume < minVolume,
		!MatchQ[alphaAssayVolume, Automatic],
		!invalidLowAlphaAssayVolumeQ,
		MatchQ[assayPlateModel, ObjectP[]],
		MatchQ[preparedPlate, False],
		!incompatiblePlatesBoolean,
		message,
		!engineQ
	];

	If[lowWellVolumeWarningQ,
		Message[Warning::AlphaScreenLowWellVolume, ObjectToString[alphaAssayVolume, Cache -> simulatedCache], ObjectToString[assayPlateModel, Cache -> simulatedCache]];
	];

	lowWellVolumeWarning = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!lowWellVolumeWarningQ,
				Nothing,
				Warning["The assay volume (AlphaAssayVolume) is close the minimum working cell volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, False]
			];

			passingTest = If[lowWellVolumeWarningQ,
				Nothing,
				Warning["The assay volume (AlphaAssayVolume) is close the minimum working cell volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	If[invalidAlphaAssayVolumeQ && message,
		Message[Error::AlphaScreenWellVolumeExceeded, ObjectToString[alphaAssayVolume, Cache -> simulatedCache], ObjectToString[assayPlateModel, Cache -> simulatedCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	(* Not doing Test for Warning *)
	alphaAssayVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) does not exceed the maximum volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, False]
			];

			passingTest = If[invalidAlphaAssayVolumeQ,
				Nothing,
				Test["The total volume of samples (AlphaAssayVolume) does not exceed the maximum volume of " <> ObjectToString[assayPlateModel, Cache -> simulatedCache] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* Get the gain and focal height options from roundedAlphaScreenOptionsAssociation*)
	{gain, focalHeight} = Lookup[roundedAlphaScreenOptionsAssociation, {Gain, FocalHeight}];

	(* --Mixing switch check-- *)
	plateReaderMix = Lookup[roundedAlphaScreenOptionsAssociation, PlateReaderMix];

	(* Obtain the default options from {PlateReaderMixRate, PlateReaderMixTime, PlateReaderMixMode} that should be Null when PlateReaderMix is False *)
	mixParameterCheckList = {PlateReaderMixRate, PlateReaderMixTime, PlateReaderMixMode};

	mixParameter = Lookup[roundedAlphaScreenOptionsAssociation, mixParameterCheckList];

	(* Get the options that are not Null or Automatic, if the PlateReaderMix is False *)
	notNullMixParameterBoolean = !MatchQ[#, Null | Automatic]& /@ mixParameter;

	(* Gather the invalid options that are not Null when the PlateReaderMix is False *)
	invalidNotNullMixParameterOptions = If[MatchQ[plateReaderMix, False],
		PickList[mixParameterCheckList, notNullMixParameterBoolean],
		{}
	];

	(* invalid option tracking boolean *)
	invalidNotNullMixParameterQ = Length[invalidNotNullMixParameterOptions] > 0;

	(* Do the check only if PlateReaderMix is False *)
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::MixParametersUnneeded. *)
	If[invalidNotNullMixParameterQ && message,
		Message[Error::AlphaScreenMixParametersUnneeded, invalidNotNullMixParameterOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mixParametersUnneededTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidNotNullMixParameterQ),
				Nothing,
				Test["When plate reader mixing is not needed (PlateReaderMix is False), the relevant parameter options " <> ObjectToString[invalidNotNullMixParameterOptions, Cache -> simulatedCache] <> " are set to Null:", True, False]
			];

			passingTest = If[invalidNotNullMixParameterQ,
				Nothing,
				Test["When plate reader mixing is not needed (PlateReaderMix is False), the relevant parameter options " <> ObjectToString[Complement[mixParameterCheckList, invalidNotNullMixParameterOptions], Cache -> simulatedCache] <> " are set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Do the check only if PlateReaderMix is True *)
	(* Get the options that are Null, if the PlateReaderMix is True *)
	nullMixParameterBoolean = MatchQ[#, Null]& /@ mixParameter;

	(* Gather the invalid options that are Null when the PlateReaderMix is True *)
	invalidNullMixParameterOptions = If[MatchQ[plateReaderMix, True],
		PickList[mixParameterCheckList, nullMixParameterBoolean],
		{}
	];

	(* invalid option tracking boolean *)
	invalidNullMixParameterQ = Length[invalidNullMixParameterOptions] > 0;

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::MixParametersRequired. *)
	If[invalidNullMixParameterQ && message,
		Message[Error::AlphaScreenMixParametersRequired, invalidNullMixParameterOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mixParametersRequiredTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidNullMixParameterQ),
				Nothing,
				Test["When plate reader mixing is needed (PlateReaderMix is True), the relevant parameter options " <> ObjectToString[invalidNullMixParameterOptions, Cache -> simulatedCache] <> " are not set to Null:", True, False]
			];

			passingTest = If[invalidNullMixParameterQ,
				Nothing,
				Test["When plate reader mixing is needed (PlateReaderMix is True), the relevant parameter options " <> ObjectToString[Complement[mixParameterCheckList, invalidNullMixParameterOptions], Cache -> simulatedCache] <> " are not set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Do the check only if PlateReaderMix is Automatic *)
	conflictingMixParameterQ = MatchQ[plateReaderMix, Automatic] && MemberQ[mixParameter, Null] && MemberQ[mixParameter, UnitsP[] | MechanicalShakingP];

	(* Track the invalid options *)
	invalidConflictingMixParameterOptions = If[conflictingMixParameterQ, mixParameterCheckList, {}];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AlphaScreenMixParametersConflicting. *)
	If[conflictingMixParameterQ && message,
		Message[Error::AlphaScreenMixParametersConflicting, mixParameterCheckList, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingMixParameterTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!conflictingMixParameterQ),
				Nothing,
				Test["When plate reader mixing is resolved automatically (PlateReaderMix is Automatic), the relevant parameter options " <> ObjectToString[mixParameterCheckList, Cache -> simulatedCache] <> " must all be set to values or all be set to Null:", True, False]
			];

			passingTest = If[conflictingMixParameterQ,
				Nothing,
				Test["When plate reader mixing is resolved automatically (PlateReaderMix is Automatic), the relevant parameter options " <> ObjectToString[Complement[mixParameterCheckList, mixParameterCheckList], Cache -> simulatedCache] <> " must all be set to values or all be set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --Moat switch check-- *)
	moatWells = Lookup[roundedAlphaScreenOptionsAssociation, MoatWells];

	(* Obtain the default options from {MoatSize, MoatVolume, MoatBuffer} that should be Null when MoatWells is False *)
	moatParameterCheckList = {MoatSize, MoatVolume, MoatBuffer};

	moatParameter = Lookup[roundedAlphaScreenOptionsAssociation, moatParameterCheckList];

	{moatSize, moatVolume, moatBuffer} = moatParameter;

	(* Get the options that are not Null, if the MoatWells is False *)
	notNullMoatParameterBoolean = !MatchQ[#, Null | Automatic]& /@ moatParameter;

	(* Gather the invalid options that are not Null when the MoatWells is False *)
	invalidNotNullMoatParameterOptions = If[(MatchQ[moatWells, False]) && MatchQ[preparedPlate, False] && (preparedPlateParametersCheckQ),
		PickList[moatParameterCheckList, notNullMoatParameterBoolean],
		{}
	];

	(* invalid option tracking boolean *)
	invalidNotNullMoatParameterQ = Length[invalidNotNullMoatParameterOptions] > 0;

	(* Do the check only if MoatWells is False *)
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::MoatParametersUnneeded. *)
	If[invalidNotNullMoatParameterQ && message,
		Message[Error::AlphaScreenMoatParametersUnneeded, invalidNotNullMoatParameterOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	moatParametersUnneededTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidNotNullMoatParameterQ),
				Nothing,
				Test["When moat wells are not needed (MoatWells is False), the relevant parameter options " <> ObjectToString[invalidNotNullMoatParameterOptions, Cache -> simulatedCache] <> " are set to Null:", True, False]
			];

			passingTest = If[invalidNotNullMoatParameterQ,
				Nothing,
				Test["When moat wells are not needed (MoatWells is False), the relevant parameter options " <> ObjectToString[Complement[moatParameterCheckList, invalidNotNullMoatParameterOptions], Cache -> simulatedCache] <> " are set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Get the options that are Null, if the MoatWells is True *)
	nullMoatParameterBoolean = MatchQ[#, Null]& /@ moatParameter;

	(* Gather the invalid options that are Null when the MoatWells is True *)
	invalidNullMoatParameterOptions = If[MatchQ[moatWells, True] && MatchQ[preparedPlate, False] && (preparedPlateParametersCheckQ),
		PickList[moatParameterCheckList, nullMoatParameterBoolean],
		{}
	];

	(* invalid option tracking boolean *)
	invalidNullMoatParameterQ = Length[invalidNullMoatParameterOptions] > 0;

	(* Do the check only if MoatWells is True *)
	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::MoatParametersRequired. *)
	If[invalidNullMoatParameterQ && message,
		Message[Error::AlphaScreenMoatParametersRequired, invalidNullMoatParameterOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	moatParametersRequiredTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidNullMoatParameterQ),
				Nothing,
				Test["When moat wells are needed (MoatWells is True), the relevant parameter options " <> ObjectToString[invalidNullMoatParameterOptions, Cache -> simulatedCache] <> " are not set to Null:", True, False]
			];

			passingTest = If[invalidNullMoatParameterQ,
				Nothing,
				Test["When moat wells are needed (MoatWells is True), the relevant parameter options " <> ObjectToString[Complement[moatParameterCheckList, invalidNullMoatParameterOptions], Cache -> simulatedCache] <> " are not set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* Do the check only if MoatWells is Automatic *)
	(* Get the options that are Null, if the PlateReaderMix is True *)
	conflictingMoatParameterQ = MatchQ[moatWells, Automatic] && MemberQ[moatParameter, Null] && MemberQ[moatParameter, UnitsP[] | ObjectP[]];

	(* Track the invalid options *)
	invalidConflictingMoatParameterOptions = If[conflictingMoatParameterQ, moatParameterCheckList, {}];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AlphaScreenMoatParametersConflicting. *)
	If[conflictingMoatParameterQ && message,
		Message[Error::AlphaScreenMoatParametersConflicting, moatParameterCheckList, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingMoatParameterTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!conflictingMoatParameterQ),
				Nothing,
				Test["When moat is resolved automatically (MoatWells is Automatic), the relevant parameter options " <> ObjectToString[moatParameterCheckList, Cache -> simulatedCache] <> " must all be set to values or all be set to Null:", True, False]
			];

			passingTest = If[conflictingMoatParameterQ,
				Nothing,
				Test["When moat is resolved automatically (MoatWells is Automatic), the relevant parameter options " <> ObjectToString[Complement[moatParameterCheckList, mixParameterCheckList], Cache -> simulatedCache] <> " must all be set to values or all be set to Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --Moat parameters all together info gathering-- *)
	(* Get the relevant options that are Null after removing Automatic *)
	nullMoatParameterBoolean = MatchQ[#, Null]& /@ DeleteCases[moatParameter, Automatic];

	(* Return True if the options are all Null or all specified *)
	allTogetherMoatParameterBoolean = If[LessEqual[Length[DeleteDuplicates[nullMoatParameterBoolean]], 1],
		True,
		False
	];

	(* Gather the invalid options when the moat parameters are not all together *)
	invalidMoatParametersTogetherOptions = If[MatchQ[allTogetherMoatParameterBoolean, False] && MatchQ[preparedPlate, False] && (!invalidNotNullMoatParameterQ) && (!invalidNullMoatParameterQ) && (preparedPlateParametersCheckQ),
		moatParameterCheckList,
		{}
	];

	(* Return True if the moat parameters are all Null or all set. This boolean is used to infer if the user wants a moat. *)
	invalidMoatParametersTogetherQ = Length[invalidMoatParametersTogetherOptions] > 0;

	(* --Moat and Aliquot check-- *)

	(* Assume user wants a moat if they've set one of the parameters *)
	impliedMoat = !invalidMoatParametersTogetherQ && MemberQ[moatParameter, Except[Null | Automatic]];

	(* Must be aliquoting if we're gonna make a moat *)
	moatAliquotError = MemberQ[aliquot, False] && impliedMoat;

	(* Track invalid option *)
	invalidMoatAliquotOptions = If[moatAliquotError,
		Join[{Aliquot}, PickList[moatParameterCheckList, moatParameter, Except[Null | Automatic]]],
		{}
	];

	(* Throw message *)
	If[moatAliquotError && message,
		Message[Error::AlphaScreenMoatAliquotsRequired]
	];

	(* Create test *)
	moatAliquotTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!moatAliquotError,
				Nothing,
				Test["If a moat is to be created, the samples may be aliquoted in order to create a new plate with a moat surrounding the assay samples:", True, False]
			];

			passingTest = If[moatAliquotError,
				Nothing,
				Test["If a moat is to be created, the samples may be aliquoted in order to create a new plate with a moat surrounding the assay samples:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --MoatVolume limit check-- *)
	(* Gather invalid moat volume if it exceeds the maximum limit of current available AlphaScreen plate *)
	invalidHighMoatVolumeOption = If[
		And[
			moatVolume >= plateHighVolumeLimit,
			impliedMoat,
			!invalidNotNullMoatParameterQ,
			!invalidNullMoatParameterQ,
			MatchQ[moatVolume, Except[Automatic]],
			MatchQ[Lookup[roundedAlphaScreenOptionsAssociation, AssayPlateModel], Automatic]
		],
		{MoatVolume},
		{}
	];

	(* invalid high moat volume tracking boolean *)
	invalidHighMoatVolumeOptionQ = Length[invalidHighMoatVolumeOption] > 0;

	(* Throw message *)
	If[invalidHighMoatVolumeOptionQ && message,
		Message[Error::AlphaScreenMoatVolumeOverlimit]
	];

	(* Create test *)
	invalidHighMoatVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidHighMoatVolumeOptionQ,
				Nothing,
				Test["If a MoatVolume is specified, it does not exceed the max volume limit of available assay plates:", True, False]
			];

			passingTest = If[invalidHighMoatVolumeOptionQ,
				Nothing,
				Test["If a MoatVolume is specified, it does not exceed the max volume limit of available assay plates:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --MoatVolume vs Model plate check-- *)
	(* Gather invalid moat volume if it exceeds the maximum volume of the AssayPlateModel *)
	invalidMoatVolumeOption = If[GreaterEqual[moatVolume, maxVolume] && impliedMoat && (!invalidNotNullMoatParameterQ) && (!invalidNullMoatParameterQ) && (!invalidHighMoatVolumeOptionQ) && (MatchQ[assayPlateModel, Except[Automatic | {Automatic} | NullP]]) && (MatchQ[moatVolume, Except[Automatic | {Automatic}]]),
		{MoatVolume},
		{}
	];

	(* invalid moat volume tracking boolean *)
	invalidMoatVolumeOptionQ = Length[invalidMoatVolumeOption] > 0;

	(* Throw message *)
	If[invalidMoatVolumeOptionQ && message,
		Message[Error::AlphaScreenMoatVolumeOverflow]
	];

	(* Create test *)
	invalidMoatVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidMoatVolumeOptionQ,
				Nothing,
				Test["If a MoatVolume is specified, it does not exceed the max volume of the assay plate model:", True, False]
			];

			passingTest = If[invalidMoatVolumeOptionQ,
				Nothing,
				Test["If a MoatVolume is specified, it does not exceed the max volume of the assay plate model:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --Large MoatSize check-- *)

	(* Because we enable the use of multiple plates in single protocol, we will not check for the MoatSize vs samples in single plate. Instead, we hardcode a check for MoatSize that is suitable (i.e. MoatSize does not go above 3). The samples will be distributed in multiple plates if one plate does not have enough space.*)

	(* Gather the invalid option if MoatSize is above 3 *)
	invalidMoatSizeOption = If[Greater[moatSize, 3] && MatchQ[moatSize, Except[Automatic | Null]] && (!moatAliquotError),
		{MoatSize},
		{}
	];

	(* invalid option tracking boolean *)
	invalidMoatSizeOptionQ = Length[invalidMoatSizeOption] > 0;

	If[invalidMoatSizeOptionQ && message,
		Message[Error::AlphaScreenTooManyMoatWells, invalidMoatSizeOption, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	moatSizeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidMoatSizeOptionQ),
				Nothing,
				Test["The moat size " <> ObjectToString[invalidMoatSizeOption, Cache -> simulatedCache] <> " is not too large so that there will be enough wells for the input samples:", True, False]
			];

			passingTest = If[invalidMoatSizeOptionQ,
				Nothing,
				Test["The moat size " <> ObjectToString[invalidMoatSizeOption, Cache -> simulatedCache] <> " is not too large so that there will be enough wells for the input samples:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --Retain cover check-- *)
	(* We currently do not support cover, it may be updated later. *)
	(* Get the RetainCover option from roundedAlphaScreenOptionsAssociation *)
	retainCover = Lookup[roundedAlphaScreenOptionsAssociation, RetainCover];

	(* Gather the invalid option when the cover is on *)
	coverOnUnrecommended = If[MatchQ[retainCover, True],
		{RetainCover},
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AlphaScreenCoverNotRecommended. *)
	If[Length[coverOnUnrecommended] > 0 && message,
		Message[Error::AlphaScreenCoverNotRecommended, coverOnUnrecommended, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	coverOnUnrecommendedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!Length[coverOnUnrecommended] > 0,
				Nothing,
				Test["We currently do not support plate seal or lid on during the measurement in plate reader because AlphaScreen can only read from top:", True, False]
			];

			passingTest = If[Length[coverOnUnrecommended] > 0,
				Nothing,
				Test["We currently do not support plate seal or lid on during the measurement in plate reader because AlphaScreen can only read from top:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --ExcitationWavelength check-- *)
	(* Get the ExcitationWavelength option from roundedAlphaScreenOptionsAssociation *)
	excitationWavelength = Lookup[roundedAlphaScreenOptionsAssociation, ExcitationWavelength];

	(* Gather the invalid option if ExcitationWavelength is not 680nm *)
	invalidExcitationWavelengthOption = If[MatchQ[excitationWavelength, 680 Nanometer],
		{},
		{ExcitationWavelength}
	];

	(* If there is invalid option and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidExcitationWavelength. *)
	If[Length[invalidExcitationWavelengthOption] > 0 && message,
		Message[Error::AlphaScreenInvalidExcitationWavelength, excitationWavelength, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidExcitationWavelengthTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidExcitationWavelengthOption] == 0,
				Nothing,
				Test["The excitation wavelength of an AlphaScreen laser is 680 nanometer:", True, False]
			];

			passingTest = If[Length[invalidExcitationWavelengthOption] == Length[excitationWavelength],
				Nothing,
				Test["The excitation wavelength of an AlphaScreen laser is 680 nanometer:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --EmissionWavelength check-- *)
	(* Get the EmissionWavelength option from roundedAlphaScreenOptionsAssociation *)
	emissionWavelength = Lookup[roundedAlphaScreenOptionsAssociation, EmissionWavelength];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* --Resolve PlateReaderMix parameters-- *)

	(*Gather plate reader mixing parameters*)
	{plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[roundedAlphaScreenOptionsAssociation, {PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}];

	(* resolve PlateReaderMix master switch *)
	resolvedPlateReaderMix = Which[
		(* specified by user *)
		MatchQ[plateReaderMix, Except[Automatic]], plateReaderMix,

		(* resolve to False, if none of the parameters are specified or all set to Automatic *)
		(!MemberQ[mixParameter, UnitsP[] | MechanicalShakingP]), False,

		(* resolve to True, if none of the parameters are Null and any of the parameters are specified *)
		(!MemberQ[mixParameter, Null]) && MemberQ[mixParameter, UnitsP[] | MechanicalShakingP], True,

		(* remain to the supplied option in other cases *)
		True, plateReaderMix
	];

	(* resolve PlateReaderMixTime *)
	resolvedPlateReaderMixTime = Which[
		(*specified by user*)
		MatchQ[plateReaderMixTime, Except[Automatic]], plateReaderMixTime,

		(*resolve to 30 Second if it is Automatic and PlateReaderMix is True*)
		MatchQ[plateReaderMixTime, Automatic] && MatchQ[resolvedPlateReaderMix, True], 30 Second,

		(*resolve to Null if it is Automatic and PlateReaderMix is False*)
		MatchQ[plateReaderMixTime, Automatic] && MatchQ[resolvedPlateReaderMix, False], Null,

		(* Otherwise, remain to the supplied option *)
		True, plateReaderMixTime
	];

	(* resolve PlateReaderMixRate *)
	resolvedPlateReaderMixRate = Which[
		(*specified by user*)
		MatchQ[plateReaderMixRate, Except[Automatic]], plateReaderMixRate,

		(*resolve to 700 RPM if it is Automatic and PlateReaderMix is True*)
		MatchQ[plateReaderMixRate, Automatic] && MatchQ[resolvedPlateReaderMix, True], 700 RPM,

		(*resolve to Null if it is Automatic and PlateReaderMix is False*)
		MatchQ[plateReaderMixRate, Automatic] && MatchQ[resolvedPlateReaderMix, False], Null,

		(* Otherwise, remain to the supplied option *)
		True, plateReaderMixRate
	];

	(* resolve PlateReaderMixMode *)
	resolvedPlateReaderMixMode = Which[
		(*specified by user*)
		MatchQ[plateReaderMixMode, Except[Automatic]], plateReaderMixMode,

		(*resolve to DoubleOrbital if it is Automatic and PlateReaderMix is True*)
		MatchQ[plateReaderMixMode, Automatic] && MatchQ[resolvedPlateReaderMix, True], DoubleOrbital,

		(*resolve to Null if it is Automatic and PlateReaderMix is False*)
		MatchQ[plateReaderMixMode, Automatic] && MatchQ[resolvedPlateReaderMix, False], Null,

		(* Otherwise, remain to the supplied option *)
		True, plateReaderMixMode
	];

	(* --Resolve AlphaAssayVolume according to the recommended volume of AssayPlateModel *)
	resolvedAlphaAssayVolume = Which[
		(*specified by user*)
		MatchQ[alphaAssayVolume, Except[Automatic]], alphaAssayVolume,

		(*If PreparedPlate->True, resolve to Null if AlphaAssayVolume is Automatic*)
		MatchQ[preparedPlate, True] && MatchQ[alphaAssayVolume, Automatic], Null,

		(*If AlphaAssayVolume is Automatic and AssayPlateModel is specified, resolve to the recommended working volume of the plate model*)
		MatchQ[alphaAssayVolume, Automatic] && MatchQ[assayPlateModel, Except[Automatic | Null]], recommendedFillVolume,

		(*If both AlphaAssayVolume and AssayPlateModel are Automatic, resolve to 100 Microliter*)
		MatchQ[alphaAssayVolume, Automatic] && MatchQ[assayPlateModel, Automatic], 100 Microliter,

		True, Null
	];

	(* --Resolve AssayPlateModel according to sample sizes and volumes-- *)

	(* Get the number of replicates for calculation of required volume *)
	numberOfReplicates = Lookup[roundedAlphaScreenOptionsAssociation, NumberOfReplicates];

	(* Obtain the total number of samples, which includes SamplesIn and its replicates *)
	totalNumberOfSamples = Length[sampleObjectList] * Replace[numberOfReplicates, Null -> 1];

	resolvedAssayPlateModel = Which[
		(*specified by user*)
		MatchQ[assayPlateModel, Except[Automatic]],
			assayPlateModel,

		(*If PreparedPlate->True, resolve to Null if AssayPlateModel is Automatic*)
		MatchQ[preparedPlate, True] && MatchQ[assayPlateModel, Automatic],
			Null,

		(*If AlphaAssayVolume is also Automatic and AssayPlateModel is Automatic, resolve the plate model depends on the number of total samples*)
		(* when the total amount of samples is not more than 96 *)
		MatchQ[assayPlateModel, Automatic] && MatchQ[alphaAssayVolume, Automatic] && LessEqual[totalNumberOfSamples, 96],
			Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
		(* when the total amount of samples is more than 96 *)
		MatchQ[assayPlateModel, Automatic] && MatchQ[alphaAssayVolume, Automatic] && Greater[totalNumberOfSamples, 96],
			Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],

		(*If 10ul<=AlphaAssayVolume<=24ul and AssayPlateModel is Automatic, resolve to 384-shallow-well plate*)
		MatchQ[assayPlateModel, Automatic] && (!MatchQ[alphaAssayVolume, Automatic]) && GreaterEqual[alphaAssayVolume, 10 Microliter] && LessEqual[alphaAssayVolume, 24 Microliter],
			Model[Container, Plate, "AlphaPlate 384-Shallow-Well Gray Plate"],

		(*If 24ul<AlphaAssayVolume<40ul and AssayPlateModel is Automatic, resolve to 384-well plate*)
		MatchQ[assayPlateModel, Automatic] && (!MatchQ[alphaAssayVolume, Automatic]) && Greater[alphaAssayVolume, 24 Microliter] && Less[alphaAssayVolume, 40 Microliter],
			Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],

		(*If 60ul<AlphaAssayVolume<=180ul and AssayPlateModel is Automatic, resolve to half area 96-well plate*)
		MatchQ[assayPlateModel, Automatic] && (!MatchQ[alphaAssayVolume, Automatic]) && Greater[alphaAssayVolume, 60 Microliter] && LessEqual[alphaAssayVolume, 180 Microliter],
			Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],

		(*If 40ul<=AlphaAssayVolume<=60ul and AssayPlateModel is Automatic, resolve the plate model depends on the number of total samples*)
		(* when the total amount of samples is not more than 96 *)
		MatchQ[assayPlateModel, Automatic] && (!MatchQ[alphaAssayVolume, Automatic]) && GreaterEqual[alphaAssayVolume, 40 Microliter] && LessEqual[alphaAssayVolume, 60 Microliter] && LessEqual[totalNumberOfSamples, 96],
			Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
		(* when the total amount of samples is more than 96 *)
		MatchQ[assayPlateModel, Automatic] && (!MatchQ[alphaAssayVolume, Automatic]) && GreaterEqual[alphaAssayVolume, 40 Microliter] && LessEqual[alphaAssayVolume, 60 Microliter] && Greater[totalNumberOfSamples, 96],
			Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],

		True, Null
	];
	resolvedAssayPlateModelPacket = fetchPacketFromFastAssoc[resolvedAssayPlateModel, fastAssoc];

	(* --Resolve MoatWells parameters-- *)

	(* call moat resolver *)
	{resolvedMoatBuffer, resolvedMoatVolume, resolvedMoatSize} = resolveMoatOptions[
		Object[Protocol, AlphaScreen],
		resolvedAssayPlateModelPacket,
		(* this is a little weird; resolveMoatOptions doesn't have a MoatWells option, but AlphaScreen does so want to make sure they work ok together and we don't resolve everything to Null while MoatWells is True *)
		If[TrueQ[moatWells] && MatchQ[moatBuffer, Automatic], Model[Sample, "Milli-Q water"], moatBuffer],
		moatVolume,
		moatSize
	];

	(* resolve MoatWells *)
	resolvedMoatWells = Which[
		(* specified by user *)
		MatchQ[moatWells, Except[Automatic]], moatWells,
		(* if we didn't resolve any moat options, above, then just False *)
		NullQ[resolvedMoatBuffer], False,
		(* otherwise we did, so True *)
		True, True
	];


	(* --Resolve gain value-- *)
	resolvedGain = If[MatchQ[gain, Except[Automatic]],
		gain,
		3600 Microvolt
	];

	(* --Resolve focal height value-- *)
	resolvedFocalHeight = If[MatchQ[focalHeight, Except[Automatic]],
		focalHeight,
		Auto
	];

	(* ---Resolve all labels in map thread options --- *)
	resolvedSampleLabels = Module[{uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		uniqueSamples = DeleteDuplicates[simulatedSamples];
		preResolvedSampleLabels = Table[CreateUniqueLabel["alphascreen sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
						label,

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
						LookupObjectLabel[simulation, object],

					True, Lookup[preResolvedSampleLabelRules, object]
				]
			],
			{simulatedSamples, Lookup[roundedAlphaScreenOptionsAssociation, SampleLabel]}
		]
	];

	resolvedSampleContainerLabels = Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["alphascreen sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
						label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, object], _String],
						LookupObjectLabel[simulation, object],
					True,
						Lookup[preResolvedContainerLabelRules, object]
				]
			],
			{suppliedContainerObjects, Lookup[roundedAlphaScreenOptionsAssociation, SampleContainerLabel]}
		]
	];

	(* Aliquot Check *)

	(* Aliquot cannot have True and False elements at same time. e.g. If it is a preparedPlate, Aliquot cannot be done. If it is not a preparedPlate, Aliquot is needed to load SamplesIn to AlphaModelPlate. *)

	(* Gather the conflict aliquot options *)
	{conflictSampleAliquotOptions, conflictSampleAliquotOptionsName} = If[MemberQ[aliquot, False] && MemberQ[aliquot, True],
		{aliquot, {Aliquot}},
		{{}, {}}
	];

	(* Invalid options tracking boolean *)
	conflictSampleAliquotOptionsQ = Length[conflictSampleAliquotOptions] > 0;

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AlphaScreenConfiltAliquotOption. *)
	If[conflictSampleAliquotOptionsQ && message,
		Message[Error::AlphaScreenConfiltAliquotOption];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictSampleAliquotOptionsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!conflictSampleAliquotOptionsQ),
				Nothing,
				Test["Aliquot should not have a mix of True and False for SamplesIn in AlphaScreen:", True, False]
			];

			passingTest = If[(conflictSampleAliquotOptionsQ),
				Nothing,
				Test["Aliquot should not have a mix of True and False for SamplesIn in AlphaScreen:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* If it is not a preparedPlate, Aliquot has to be done. *)
	(* Find the samples that have Aliquot set to False for a not preparedPlate *)
	notAliquotSampleBoolean = MatchQ[#, False]& /@ aliquot;

	(* Invalid option tracking boolean *)
	falseSampleAliquotQ = MemberQ[aliquot, False];

	(* Gather the invalid sample inputs that are not aliquoted *)
	{invalidSampleAliquotOptions, invalidSampleAliquotOptionsName} = If[falseSampleAliquotQ && MatchQ[preparedPlate, False] && (!moatAliquotError) && (!duplicateSampleError) && (!conflictSampleAliquotOptionsQ),
		{PickList[sampleObjectList, notAliquotSampleBoolean], {Aliquot}},
		{{}, {}}
	];

	(* Track invalid options  *)
	invalidSampleAliquotQ = Length[invalidSampleAliquotOptions] > 0;

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::AlphaScreenInvalidSampleAliquot. *)
	If[invalidSampleAliquotQ && message,
		Message[Error::AlphaScreenInvalidSampleAliquot, invalidSampleAliquotOptions, Cache -> simulatedCache];
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	invalidSampleAliquotTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[(!invalidSampleAliquotQ),
				Nothing,
				Test["If it is not a prepared plate, the samples " <> ObjectToString[invalidSampleAliquotOptions, Cache -> simulatedCache] <> " need to be aliquoted to AssayPlateModel:", True, False]
			];

			passingTest = If[(invalidSampleAliquotQ),
				Nothing,
				Test["If it is not a prepared plate, the samples " <> ObjectToString[Complement[sampleObjectList, invalidSampleAliquotOptions], Cache -> simulatedCache] <> " need to be aliquoted to AssayPlateModel:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --Resolve Aliquot-- *) (*add an error check*)
	resolvedAliquot = Which[
		(!MemberQ[aliquot, False]) && (MatchQ[preparedPlate, False]), ConstantArray[True, Length[aliquot]],
		(!MemberQ[aliquot, True]) && (MatchQ[preparedPlate, True]), ConstantArray[False, Length[aliquot]],
		(* set all to False to avoid error in aliquot resolver. This error should have been checked. *)
		True, ConstantArray[False, Length[aliquot]]
	];

	(* Resolve Instrument *)
	instrument = Which[
		MatchQ[suppliedPlateReader, Except[Automatic]], suppliedPlateReader,
		(* if TargetCO2/TargetO2Level is specified, then we only have one option *)
		Or[
			MemberQ[Lookup[myOptions, {TargetCarbonDioxideLevel, TargetOxygenLevel}], PercentP],
			MatchQ[resolvedWorkCell,bioSTAR]
		],
		Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		True,
		Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"] (* Model[Instrument, PlateReader, "CLARIOstar"] *)
	];

	(* Resolve TargetCarbonDioxideLevel *)
	{{resolvedACUOptions, resolvedACUInvalidOptions}, resolvedACUTests} = If[gatherTests,
		resolveACUOptions[
			Object[Protocol, AlphaScreen],
			simulatedSamples,
			Association[roundedAlphaScreenOptionsAssociation,
				{
					Instrument -> instrument,
					Cache -> cache,
					Simulation -> updatedSimulation,
					Output -> {Result, Tests}
				}
			]
		],
		{
			resolveACUOptions[
				Object[Protocol, AlphaScreen],
				simulatedSamples,
				Association[roundedAlphaScreenOptionsAssociation,
					{
						Instrument -> instrument,
						Cache -> cache,
						Simulation -> updatedSimulation,
						Output -> Result
					}
				]
			],
			{}
		}
	];

	(* --Unresolvable options check-- *)

	(* --Moat vs DestinationWells check-- *)
	(* See what wells user wants to put aliquots in *)
	destinationWells = Lookup[samplePrepOptions, DestinationWell];

	(* - Make sure that moat doesn't overlap with DestinationWells - *)
	conflictingWells = If[!MemberQ[aliquot, False] && impliedMoat,
		Module[{plateWells, moatSizeCheck, moatWellsCheck, overlappingWells},
			(* Determine how many wells we'll have left once we've made our moat *)
			plateWells = AllWells[resolvedAssayPlateModel];

			(* If user asked for moat by setting volume or buffer, by not size, use default size 1*)
			moatSizeCheck = resolvedMoatSize;

			(* Get wells which should be filled with moat buffer *)
			moatWellsCheck = alphaScreenGetMoatWells[plateWells, moatSizeCheck];

			(* Make sure none of our destination wells are slated to be moat wells *)
			overlappingWells = Cases[destinationWells, Alternatives @@ moatWellsCheck];

			overlappingWells
		],
		{}
	];

	(* conflictingWells tracking boolean *)
	conflictingWellsQ = Length[conflictingWells] > 0;

	(* Track invalid option *)
	{invalidDestinationWellsOption, invalidDestinationWellsOptionName} = If[conflictingWellsQ && (!MemberQ[aliquot, False]) && impliedMoat,
		{destinationWells, {DestinationWell}},
		{{}, {}}
	];

	(* invalid option tracking boolean *)
	invalidDestinationWellsQ = Length[invalidDestinationWellsOption] > 0;

	(* throw message *)
	If[invalidDestinationWellsQ && message,
		Message[Error::AlphaScreenWellOverlap, conflictingWells]
	];

	(* Create tests *)
	conflictingWellsTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[!invalidDestinationWellsQ,
				Nothing,
				Test["If a moat is to be created, none of the specified destination wells are earmarked to be used as moat wells::", True, False]
			];

			passingTest = If[invalidDestinationWellsQ,
				Nothing,
				Test["If a moat is to be created, none of the specified destination wells are earmarked to be used as moat wells::", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --DestinationWells checks for aliquot-- *)
	suppliedDestinationWells = Lookup[samplePrepOptions, DestinationWell];

	(* Get the info about all the wells in the resolved plate *)
	plateWells = Quiet[AllWells[resolvedAssayPlateModel]];

	(* Get the moat wells reserved*)
	reservedMoatWells = If[impliedMoat && (!assayPlateInfoRequiredQ),
		getMoatWells[plateWells, resolvedMoatSize],
		{}
	];

	(* - Validate DestinationWell Option - *)
	(* Check whether the supplied DestinationWell have duplicated members. PlateReader experiment only allows one plate so we should not aliquot two samples into the same well. *)
	duplicateDestinationWells = DeleteDuplicates[
		Select[DeleteCases[ToList[suppliedDestinationWells], Automatic], Count[DeleteCases[ToList[suppliedDestinationWells], Automatic], #] > 1&]
	];
	duplicateDestinationWellOption = If[!MatchQ[duplicateDestinationWells, {}] && message,
		Message[Error::PlateReaderDuplicateDestinationWell, ToString[DeleteDuplicates[duplicateDestinationWells]]];{DestinationWell},
		{}
	];
	duplicateDestinationWellTest = If[gatherTests,
		Test["The specified DestinationWell should not have duplicated members:", MatchQ[duplicateDestinationWells, {}], True],
		{}
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{invalidRepeatSamples}]];
	invalidOptions = DeleteDuplicates[Flatten[{invalidInstrumentOptionName, invalidAssayPlateModelOptionName,
		preparedPlateIrrelevantOptions, assayPlateInfoRequiredOptions, invalidLowAlphaAssayVolumeOption, invalidHighAlphaAssayVolumeOption,
		invalidAlphaAssayVolumeOption,
		invalidNotNullMixParameterOptions, invalidNullMixParameterOptions, invalidConflictingMixParameterOptions,
		invalidNotNullMoatParameterOptions, invalidNullMoatParameterOptions, invalidConflictingMoatParameterOptions,
		invalidMoatParametersTogetherOptions, invalidMoatAliquotOptions, invalidMoatVolumeOption, invalidHighMoatVolumeOption,
		invalidMoatSizeOption, invalidDestinationWellsOptionName, invalidExcitationWavelengthOption,
		duplicateDestinationWellOption, conflictSampleAliquotOptionsName, invalidSampleAliquotOptionsName, coverOnUnrecommended,
		If[MatchQ[preparationResult, $Failed], {Preparation}, {}], resolvedACUInvalidOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && message,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && message,
		Message[Error::InvalidOption, invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Resolve RequiredAliquotContainers *)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	{targetContainers, requiredAliquotAmounts} = If[MatchQ[resolvedAliquot, {True..} | {Automatic..}] && (MatchQ[preparedPlate, False]),
		{
			ConstantArray[resolvedAssayPlateModel, Length[mySamples]],

			ConstantArray[resolvedAlphaAssayVolume, Length[mySamples]]
		},
		{Null, Null}
	];

	(* Resolve Aliquot Options *)
	(* NOTE: we let the aliquot options resolved automatic using the samples and number of replicates. This will not consider the moat and will not generate correct targetContainers or DestinationWell for our indexmatched samples. We will use replace rule to revise the targetContainers and DestinationWell. *)
	{resolvedAliquotOptions, aliquotTests} = With[
		{
			resolvedOptionValues = resolveAliquotOptions[
				ExperimentAlphaScreen,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, Join[resolvedSamplePrepOptions, {Aliquot -> resolvedAliquot}]],
				Cache -> cache,
				Simulation -> updatedSimulation,
				RequiredAliquotContainers -> targetContainers,
				RequiredAliquotAmounts -> requiredAliquotAmounts,
				Output -> If[gatherTests, {Result, Tests}, Result]
			]
		},
		If[gatherTests,
			resolvedOptionValues,
			{resolvedOptionValues, {}}
		]
	];

	(* We need to manually replace the correct AliquotContainer and DestinationWell in the resolvedAliquotOptions *)
	(* First, we find the available wells after moat options in each plate. This only resolves the available destination wells in one plate after moat addition. *)

	availableAssayWells = If[
		And[
			MatchQ[suppliedDestinationWells, {Automatic..}],
			MatchQ[preparedPlate, False],
			!invalidMoatSizeOptionQ,
			!invalidDestinationWellsQ,
			MatchQ[assayPlateModel, Except[NullP]],
			!invalidLowAlphaAssayVolumeQ,
			!invalidHighAlphaAssayVolumeQ
		],
		Module[{readDirection, orderedWells},

			(* Re-order the wells based on read direction *)
			readDirection = Lookup[alphaScreenOptionsAssociation, ReadDirection];
			orderedWells = Which[
				MatchQ[readDirection, Row],
					Flatten[plateWells],
				MatchQ[readDirection, Column],
					Flatten[Transpose[plateWells]],
				MatchQ[readDirection, SerpentineRow],
					Flatten[MapThread[
						If[OddQ[#2], #1, Reverse[#1]]&,
						{plateWells, Range[Length[plateWells]]}
					]],
				MatchQ[readDirection, SerpentineColumn],
					Flatten[MapThread[
						If[OddQ[#2], #1, Reverse[#1]]&,
						{Transpose[plateWells], Range[Length[Transpose[plateWells]]]}
					]]
			];

			(* Remove any moat wells from our possible wells - use DeleteCases to avoid rearranging *)
			DeleteCases[orderedWells, Alternatives @@ reservedMoatWells]
		],
		{}
	];

	(* Second, get how many plates we need for all the samples: input samples and optimization samples *)
	requiredNumberOfPlates = If[MatchQ[preparedPlate, False] && !MatchQ[availableAssayWells, {}],
		Ceiling[totalNumberOfSamples / Length[availableAssayWells]],
		{0}
	];

	(* Third, fill samples in the availableAssayWells. If one plate model is filled, move to next plate until all samples are filled. We will track both the AliquotContainer and DestinationWell which are both index-matched to samples *)

	(* Get the containers for all samples and their replicates *)
	allTargetContainers = If[MatchQ[preparedPlate, False] && !MatchQ[availableAssayWells, {}],
		Take[Flatten[ConstantArray[{#, resolvedAssayPlateModel}, Length[availableAssayWells]]& /@ Range[requiredNumberOfPlates], 1], totalNumberOfSamples],
		Null
	];

	(* Get the aliquot containers for the samples in which are needed to replace rule in our resolvedAliquotOptions *)
	transferredContainers = If[MatchQ[preparedPlate, False] && !MatchQ[availableAssayWells, {}],
		Take[allTargetContainers, totalNumberOfSamples],
		Null
	];

	(* Get the DestinationWell for all samples: input samples and their replicates *)
	allDestinationWells = If[MatchQ[preparedPlate, False] && !MatchQ[availableAssayWells, {}],
		Take[Flatten[ConstantArray[availableAssayWells, requiredNumberOfPlates]], totalNumberOfSamples],
		Null
	];

	(* Get the destination wells for the samples in which are needed to replace rule in our resolvedAliquotOptions *)
	transferredWells = If[MatchQ[preparedPlate, False] && !MatchQ[availableAssayWells, {}],
		Take[allDestinationWells, totalNumberOfSamples],
		Null
	];


	(* update the resolvedAliquotOptions to consider multiple plates only if the DestinationWell are set to be Automatic *)
	suppliedDestinationWellsQ = MatchQ[suppliedDestinationWells, {Automatic..}];

	updateResolvedAliquotOptions = If[suppliedDestinationWellsQ,
		ReplaceRule[resolvedAliquotOptions,
			{
				AliquotContainer -> transferredContainers,
				DestinationWell -> transferredWells
			}
		],
		resolvedAliquotOptions
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(*from original option association*)
	{
		numberOfReplicates,
		readDirection,
		readTemperature,
		readEquilibrationTime,
		settlingTime,
		excitationTime,
		delayTime,
		integrationTime,
		storeMeasuredPlates,
		confirm,
		canaryBranch,
		imageSample,
		name,
		template,
		samplesInStorageCondition,
		preparatoryPrimitives,
		email,
		fastTrack,
		operator,
		outputOption,
		parentProtocol,
		upload
	} = Lookup[roundedAlphaScreenOptionsAssociation, {NumberOfReplicates, ReadDirection, ReadTemperature, ReadEquilibrationTime, SettlingTime, ExcitationTime, DelayTime, IntegrationTime, StoreMeasuredPlates, Confirm, CanaryBranch, ImageSample, Name, Template, SamplesInStorageCondition, PreparatoryUnitOperations, Email, FastTrack, Operator, Output, ParentProtocol, Upload}];

	resolvedOptions = Flatten[{
		PreparedPlate -> preparedPlate,
		Instrument -> instrument,
		WorkCell -> resolvedWorkCell,
		AssayPlateModel -> resolvedAssayPlateModel,
		AlphaAssayVolume -> resolvedAlphaAssayVolume,
		NumberOfReplicates -> numberOfReplicates,
		ReadTemperature -> readTemperature,
		ReadEquilibrationTime -> readEquilibrationTime,
		PlateReaderMix -> resolvedPlateReaderMix,
		PlateReaderMixTime -> resolvedPlateReaderMixTime,
		PlateReaderMixRate -> resolvedPlateReaderMixRate,
		PlateReaderMixMode -> resolvedPlateReaderMixMode,
		Gain -> resolvedGain,
		FocalHeight -> resolvedFocalHeight,
		SettlingTime -> settlingTime,
		ExcitationTime -> excitationTime,
		DelayTime -> delayTime,
		IntegrationTime -> integrationTime,
		StoreMeasuredPlates -> storeMeasuredPlates,
		ExcitationWavelength -> excitationWavelength,
		EmissionWavelength -> emissionWavelength,
		RetainCover -> retainCover,
		ReadDirection -> readDirection,
		MoatWells -> resolvedMoatWells,
		MoatSize -> resolvedMoatSize,
		MoatVolume -> resolvedMoatVolume,
		MoatBuffer -> resolvedMoatBuffer,
		resolvedACUOptions,
		resolvedSamplePrepOptions,
		updateResolvedAliquotOptions,
		resolvedPostProcessingOptions,
		SampleLabel -> resolvedSampleLabels,
		SampleContainerLabel -> resolvedSampleContainerLabels,
		Preparation -> resolvedPreparation,
		WorkCell -> resolvedWorkCell,
		Confirm -> confirm,
		CanaryBranch -> canaryBranch,
		ImageSample -> imageSample,
		Name -> name,
		Template -> template,
		SamplesInStorageCondition -> samplesInStorageCondition,
		PreparatoryUnitOperations -> preparatoryPrimitives,
		Cache -> cache,
		Email -> email,
		FastTrack -> fastTrack,
		Operator -> operator,
		Output -> outputOption,
		ParentProtocol -> parentProtocol,
		Upload -> upload
	}];

	allTests = {
		samplePrepTests,
		aliquotTests,
		repeatedSampleTest,
		availablePlateReaderTest,
		invalidAssayPlateTest,
		notBMGPlatesTest,
		optionPrecisionTests,
		preparationTest,
		preparedPlateIrrelevantTest,
		assayPlateInfoRequiredTest,
		alphaAssayVolumeLowLimitTest,
		alphaAssayVolumeHighLimitTest,
		alphaAssayVolumeTest,
		highWellVolumeWarning,
		lowWellVolumeWarning,
		mixParametersUnneededTest,
		mixParametersRequiredTest,
		conflictingMixParameterTest,
		moatParametersUnneededTest,
		moatParametersRequiredTest,
		conflictingMoatParameterTest,
		invalidHighMoatVolumeTest,
		moatAliquotTest,
		invalidMoatVolumeTest,
		moatSizeTest,
		conflictingWellsTest,
		invalidExcitationWavelengthTest,
		duplicateDestinationWellTest,
		invalidSampleAliquotTest,
		conflictSampleAliquotOptionsTest,
		coverOnUnrecommendedTest,
		resolvedACUTests
	};

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> Flatten[{allTests}]
	}
];

(*--ResourcePackets--*)
DefineOptions[
	alphaScreenResourcePackets,
	Options :> {OutputOption, CacheOption, SimulationOption}
];

alphaScreenResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[]] := Module[
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, inheritedCache, numReplicates,
		samplePackets, expandedSamplesWithNumReplicates, optionsWithReplicates, minimumVolume, expandedAliquotVolume, sampleVolumes, pairedSamplesInAndVolumes, sampleVolumeRules,
		sampleResourceReplaceRules, samplesInResources, instrument, instrumentTime, instrumentResource, finalizedPacket,
		allResourceBlobs, testsRule, resultRule, resolvedPreparation, nonHiddenOptions, unitOperationPackets,
		sampleLabelsWithReplicates, sampleContainerPackets,
		alphaAssayVolume , resolvedPlateReaderMixTime, totalNumberOfSamples, sampleReadTime, preparedPlate, resolvedAssayPlateModel, numberOfPlateWells,
		moatWells, moatSize, numberOfMoatWells, remainingWells, requiredNumberOfPlates, measurementPlates, measurementPlateResources, assayPlates,
		lidResources, moatBuffer, moatVolume, totalMoatVolume, moatBufferContainer,
		moatBufferResources, simulation,
		resourcesOk, resourceTests, previewRule, optionsRule, fastAssoc
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentAlphaScreen, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAlphaScreen,
		RemoveHiddenOptions[ExperimentAlphaScreen, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache and simulation *)
	inheritedCache = Lookup[ToList[ops], Cache];
	simulation = Lookup[ToList[ops], Simulation];
	fastAssoc = makeFastAssocFromCache[inheritedCache];

	(* Determine if we need to make replicates; make sure Null becomes 1 *)
	numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};


	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	sampleContainerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;

	(* Expand the samples according to the number of replicates *)
	{expandedSamplesWithNumReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentAlphaScreen, mySamples, expandedResolvedOptions];

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* pull out the expanded AliquotAmount option *)
	expandedAliquotVolume = Lookup[optionsWithReplicates, AliquotAmount];

	(* Get the AlphaAssayVolume and use it for the minimum Volume *)
	alphaAssayVolume = Lookup[myResolvedOptions, AlphaAssayVolume];

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	minimumVolume = alphaAssayVolume;

	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)
	sampleVolumes = MapThread[
		If[VolumeQ[#1],
			#1,
			minimumVolume
		]&,
		{expandedAliquotVolume, expandedSamplesWithNumReplicates}
	];

	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		#1 -> #2&,
		{expandedSamplesWithNumReplicates, sampleVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
			]
		],
		sampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* If PreparedPlate->False, pick the resources *)
	preparedPlate = Lookup[myResolvedOptions, PreparedPlate];

	(* -- Generate assay plate resources for optics optimization -- *)
	(* We currently only support the gain and focal height optimization samples are in the same plate *)
	preparedPlate = Lookup[myResolvedOptions, PreparedPlate];
	resolvedAssayPlateModel = Lookup[myResolvedOptions, AssayPlateModel];

	(* -- Generate lid resources -- *)
	(* Obtain the total number of samples, which includes SamplesIn and their replicates *)
	totalNumberOfSamples = Length[mySamples] * Replace[numReplicates, Null -> 1];

	(* Lookup the assay plate model and related info *)
	numberOfPlateWells = fastAssocLookup[fastAssoc, resolvedAssayPlateModel, NumberOfWells];

	(* Lookup related moat options *)
	moatWells = Lookup[myResolvedOptions, MoatWells];
	moatSize = Lookup[myResolvedOptions, MoatSize];

	(* Lookup the moat information if MoatWells->True *)
	numberOfMoatWells = If[MatchQ[moatWells, True],
		Module[{plateWells, moatWellsCheck},
			(* Determine how many wells we'll have left once we've made our moat *)
			plateWells = AllWells[resolvedAssayPlateModel];

			(* Get wells which should be filled with moat buffer *)
			moatWellsCheck = getMoatWells[plateWells, moatSize];

			Length[moatWellsCheck]
		],
		0
	];

	(* Calculate the remaining wells in each plate after moat setup *)
	remainingWells = numberOfPlateWells - numberOfMoatWells;

	(* Calculate the required number of plates to aliquot all the samples with moat setting *)
	requiredNumberOfPlates = If[MatchQ[preparedPlate, True],
		0,
		Ceiling[totalNumberOfSamples / remainingWells]
	];

	measurementPlates = ConstantArray[resolvedAssayPlateModel, requiredNumberOfPlates];

	(* note that we're not USING this resource anywhere; we're just using the Unique name to help do things with the resource below.  It's definitely weird, but I'm not going to worry about it *)
	measurementPlateResources = Link@Resource[Sample -> #, Name -> ToString[Unique[]]]& /@ measurementPlates;

	assayPlates = If[MatchQ[preparedPlate, True], Link[DeleteDuplicates[Lookup[sampleContainerPackets, Object]]], measurementPlateResources];

	lidResources = Link@Resource[Sample -> #, Name -> ToString[Unique[]]]& /@ ConstantArray[Model[Item, Lid, "Universal Black Lid"], Length[assayPlates]];

	(* --Generate moat buffer resources -- *)
	(* Lookup relevant options *)
	moatBuffer = Lookup[myResolvedOptions, MoatBuffer];
	moatVolume = Lookup[myResolvedOptions, MoatVolume];
	totalMoatVolume = moatVolume * numberOfMoatWells * requiredNumberOfPlates;

	moatBufferContainer = Which[
		(*pick 2ml tube if the total moat volume is less or equal to 1.9mL*)
		MatchQ[moatWells, True] && LessEqual[totalMoatVolume, 1.9 Milliliter],
			PreferredContainer[totalMoatVolume], (* Model[Container, Vessel, "2mL Tube"] *)

		(*pick 50ml tube if the total moat volume is greater than 1.9mL, but less than 50mL*)
		MatchQ[moatWells, True] && Greater[totalMoatVolume, 1.9 Milliliter] && Less[totalMoatVolume, 50 Milliliter],
			PreferredContainer[totalMoatVolume], (* Model[Container, Vessel, "50mL Tube"] *)

		(*pick 200ml water reservoir if the total moat volume is greater than 50mL*)
		MatchQ[moatWells, True] && GreaterEqual[totalMoatVolume, 50 Milliliter],
			PreferredContainer[totalMoatVolume, Type -> Plate, LiquidHandlerCompatible -> True], (* Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"] *)

		(*otherwise, return Null*)
		True, Null
	];

	(*resource for moat buffer*)
	moatBufferResources = If[MatchQ[moatWells, True],
		Link@Resource[Sample -> moatBuffer, Container -> moatBufferContainer, Name -> ToString[Unique[]], Amount -> totalMoatVolume, RentContainer -> True],
		Null
	];

	(* -- Generate instrument resources -- *)

	(* Lookup relevant options *)
	(* Lookup plate reader model/object *)
	instrument = Lookup[myResolvedOptions, Instrument];

	(* Lookup plate mix time *)
	resolvedPlateReaderMixTime = Lookup[myResolvedOptions, PlateReaderMixTime];

	(* Lookup sample read time *)
	sampleReadTime = Total[Lookup[myResolvedOptions, {SettlingTime, ExcitationTime, DelayTime, IntegrationTime}]];

	instrumentTime = 15 Minute + (resolvedPlateReaderMixTime /. Null -> 0 Minute) * requiredNumberOfPlates + (sampleReadTime) * totalNumberOfSamples;

	(* Create the resource *)
	instrumentResource = Link@Resource[Instrument -> instrument, Time -> instrumentTime, Name -> ToString[Unique[]]];

	(* -- Generate our unit operation packet -- *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* get the non hidden options *)
	nonHiddenOptions = Lookup[
		Cases[OptionDefinition[ExperimentAlphaScreen], KeyValuePattern["Category" -> Except["Hidden"]]],
		"OptionSymbol"
	];

	(* expand sample labels for replicates *)
	sampleLabelsWithReplicates = Flatten[
		ConstantArray[#, (numReplicates /. {Null -> 1})]& /@ Lookup[myResolvedOptions, SampleLabel]
	];

	{finalizedPacket, unitOperationPackets} = If[MatchQ[resolvedPreparation, Manual],
		Module[{protocolPacket, sharedFieldPacket},
			(* --- Generate the protocol packet --- *)
			protocolPacket = <|
				Type -> Object[Protocol, AlphaScreen],
				Object -> CreateID[Object[Protocol, AlphaScreen]],
				Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
				Replace[ContainersIn] -> (Link[Resource[Sample -> #, Name -> ToString[#]], Protocols]&) /@ DeleteDuplicates[Lookup[sampleContainerPackets, Object]],
				UnresolvedOptions -> myUnresolvedOptions,
				ResolvedOptions -> myResolvedOptions,
				NumberOfReplicates -> numReplicates,
				Instrument -> instrumentResource,
				Replace[Checkpoints] -> {
					{"Picking Resources", 30 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
					{"Preparing Samples", 30 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
					{"Acquiring Data", instrumentTime, "Measurement of the samples in plates for AlphaScreen signal using a plate reader.",
						Resource[Operator -> $BaselineOperator, Time -> instrumentTime]
					},
					{"Sample Post-Processing", 15 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
					{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]}
				},
				Replace[PreparedPlate] -> preparedPlate,
				Replace[Instrument] -> instrumentResource,
				(* TBU: AssayPlates using compiler function *)
				Replace[AlphaAssayVolume] -> alphaAssayVolume,
				Replace[MoatSize] -> moatSize,
				Replace[MoatVolume] -> moatVolume,
				Replace[MoatBuffer] -> moatBufferResources,
				(*TBU: AssayPlateLoadingPrimitives,AssayPlateLoadingSampleManipulation*)
				ReadTemperature -> (Lookup[myResolvedOptions, ReadTemperature] /. Ambient -> Null),
				ReadEquilibrationTime -> Lookup[myResolvedOptions, ReadEquilibrationTime],
				TargetCarbonDioxideLevel -> Lookup[myResolvedOptions, TargetCarbonDioxideLevel],
				TargetOxygenLevel -> Lookup[myResolvedOptions, TargetOxygenLevel],
				AtmosphereEquilibrationTime -> Lookup[myResolvedOptions, AtmosphereEquilibrationTime],
				Replace[PlateReaderMix] -> Lookup[myResolvedOptions, PlateReaderMix],
				Replace[PlateReaderMixTime] -> Lookup[myResolvedOptions, PlateReaderMixTime],
				Replace[PlateReaderMixRate] -> Lookup[myResolvedOptions, PlateReaderMixRate],
				Replace[PlateReaderMixMode] -> Lookup[myResolvedOptions, PlateReaderMixMode],
				Replace[PlateReaderMixSchedule] -> If[Lookup[myResolvedOptions, PlateReaderMix], BeforeReadings, Null],
				Replace[Gain] -> If[!MatchQ[Lookup[myResolvedOptions, Gain], Automatic], Lookup[myResolvedOptions, Gain], Null],
				FocalHeight -> (Lookup[myResolvedOptions, FocalHeight] /. {Auto -> Null}),
				AutoFocalHeight -> MatchQ[Lookup[myResolvedOptions, FocalHeight], Auto],
				SettlingTime -> Lookup[myResolvedOptions, SettlingTime],
				ExcitationTime -> Lookup[myResolvedOptions, ExcitationTime],
				Replace[DelayTime] -> Lookup[myResolvedOptions, DelayTime],
				Replace[IntegrationTime] -> Lookup[myResolvedOptions, IntegrationTime],
				Replace[ExcitationWavelength] -> Lookup[myResolvedOptions, ExcitationWavelength],
				Replace[EmissionWavelength] -> Lookup[myResolvedOptions, EmissionWavelength],
				Replace[PlateCover] -> If[MatchQ[Lookup[myResolvedOptions, RetainCover], True], First[lidResources], Null],
				Replace[ReadDirection] -> Lookup[myResolvedOptions, ReadDirection],
				(*TBU: SamplesInStorage,MethodFilePath,DataFileName*)
				Replace[StoreMeasuredPlates] -> Lookup[myResolvedOptions, StoreMeasuredPlates],
				If[MatchQ[resolvedPreparation, Robotic], Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ ToList[Lookup[unitOperationPackets, Object]], Nothing]
			|>;

			(* generate a packet with the shared fields *)
			sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation];

			{
				Join[sharedFieldPacket, protocolPacket],
				{}
			}
		],
		Module[{unitOpPacket, unitOperationPacketWithLabeledObjects},
			unitOpPacket = UploadUnitOperation[
				AlphaScreen @@ Join[
					{
						Sample -> samplesInResources
					},
					ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
						{
							Instrument -> instrumentResource,
							MoatBuffer -> moatBufferResources,
							(* NOTE: Don't pass Name down. *)
							Name -> Null
						}
					],
					{SampleLabel -> sampleLabelsWithReplicates}
				],
				Preparation -> Robotic,
				UnitOperationType -> Output,
				FastTrack -> True,
				Upload -> False
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			unitOperationPacketWithLabeledObjects = Append[
				unitOpPacket,
				Replace[LabeledObjects] -> DeleteDuplicates@Join[
					Cases[
						Transpose[{sampleLabelsWithReplicates, samplesInResources}],
						{_String, Resource[KeyValuePattern[Sample -> ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						DeleteDuplicates@Transpose[{
							Lookup[myResolvedOptions, SampleContainerLabel],
							MapThread[
								Resource[Sample -> #2, Name -> #1]&,
								{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[sampleContainerPackets, Object]}
							]
						}],
						{_String, Resource[KeyValuePattern[Sample -> ObjectP[{Object[Container], Model[Container]}]]]}
					]
				]
			];

			(* Return our unit operation packet with labeled objects. *)
			{
				Null,
				{unitOperationPacketWithLabeledObjects}
			}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs = Cases[Flatten[{finalizedPacket, unitOperationPackets}], _Resource, Infinity];

	(* Verify we can satisfy all our resources *)
	{resourcesOk, resourceTests} = Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulation, Cache -> inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Messages -> messages, Simulation -> simulation, Cache -> inheritedCache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[resourcesOk],
		{finalizedPacket, unitOperationPackets},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentAlphaScreen,
	Options :> {CacheOption, SimulationOption}
];

simulateExperimentAlphaScreen::AlphaScreenMoatWellConflict = "The wells earmarked for the moat are already filled. This suggests an error occurred during aliquoting.";

simulateExperimentAlphaScreen[
	myResourcePacket : (PacketP[Object[Protocol, Incubate], {Object, ResolvedOptions}] | $Failed | Null),
	myUnitOperationPackets : ({PacketP[]..} | $Failed),
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentIncubate]
] := Module[
	{
		cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, updatedSimulation,

		(* Download *)
		fieldSpec, protPacket, workingContainerPacket, moatBufferModelPacket, gainOptimizationSamplesPacket, focalHeightOptimizationSamplesPacket,

		(* Moat *)
		moatVolume, moatSize, moatBuffer, moatBufferModel, workingContainers, currentContents, emptyMoatSizeQ, plateWells, reservedMoatWells, currentWells, wellConflictQ, moatPackets,

		preparedPlate, resolvedPreparation, gainOptimizationSamples, numberOfGainOptimizations, focalHeightOptimizationSamples, numberOfFocalHeightOptimizations, alphaAssayVolume, opticsOptimizationContainer, gainOptimizationSampleModels, focalHeightOptimizationSampleModels, noOptimizationSampleQ, optimizationSamplePackets,

		(* Sample labels *)
		simulationWithLabels
	},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Download containers from our sample packets. *)
	samplePackets = Download[
		mySamples,
		Packet[Container],
		Cache -> Lookup[ToList[myResolutionOptions], Cache, {}],
		Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[Lookup[myResolvedOptions, Preparation], Robotic],
			SimulateCreateID[Object[Protocol, RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myResourcePacket, $Failed],
			SimulateCreateID[Object[Protocol, AlphaScreen]],
		True,
			Lookup[myResourcePacket, Object]
	];


	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation = Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			Module[{protocolPacket},
				protocolPacket = <|
					Object -> protocolObject,
					Replace[OutputUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[myUnitOperationPackets, Object],
					Instrument -> Cases[Lookup[myUnitOperationPackets, Instrument], _Resource, Infinity],
					Replace[MoatBuffer] -> Cases[Lookup[myUnitOperationPackets, MoatBuffer], _Resource, Infinity],
					ResolvedOptions -> {}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],

		MatchQ[myResourcePacket, $Failed],
			SimulateResources[
				<|
					Object -> protocolObject,
					Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
					ResolvedOptions -> myResolvedOptions
				|>,
				Cache -> cache,
				Simulation -> simulation
			],

		True,
			SimulateResources[
				myResourcePacket,
				Cache -> cache,
				Simulation -> simulation
			]
	];

	(* Update simulation with fulfillment simulation *)
	updatedSimulation = UpdateSimulation[simulation, fulfillmentSimulation];


	(* == Download == *)
	fieldSpec = {
		(* Protocol *)
		Packet[
			(* General *)
			Type, Mode, SamplesIn, WorkingSamples, WorkingContainers, PreparedPlate, AlphaAssayVolume,

			(* Moat Related *)
			MoatVolume, MoatSize, MoatBuffer
		],

		(* WorkingContainers *)
		Packet[WorkingContainers[Contents]],

		(* MoatBuffer Model *)
		Packet[MoatBuffer[Model]]
	};

	(* Do the download *)
	{
		protPacket,
		workingContainerPacket,
		moatBufferModelPacket
	} = Quiet[Download[
		protocolObject,
		fieldSpec,
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* == Simulation == *)

	(* === Moat primitives === *)
	(* -- Lookup the Moat related variables -- *)
	{
		moatVolume,
		moatSize,
		moatBuffer
	} = Lookup[protPacket, {
		MoatVolume,
		MoatSize,
		MoatBuffer
	}] /. {x : ObjectP[] -> Download[x, Object]};

	moatBufferModel = If[MatchQ[moatBufferModelPacket, Null],
		Null,
		Lookup[moatBufferModelPacket, Model];
	] /. {x : ObjectP[] -> Download[x, Object]};

	{
		workingContainers,
		currentContents
	} = Transpose[Lookup[workingContainerPacket, {
		Object,
		Contents
	}]] /. {x : ObjectP[] -> Download[x, Object]};

	(* -- Initial Setup and Checks -- *)
	(* 1. Check if we have any moat *)
	emptyMoatSizeQ = If[MatchQ[moatSize, Null],
		True,
		False
	];

	(* 2. Check if we have any well conflict *)
	(* Determine which wells should be filled with buffer *)
	{plateWells, reservedMoatWells, currentWells} = If[!emptyMoatSizeQ,
		(* If we haven't encounter any errors so far *)
		{
			AllWells[First[workingContainers]],
			Experiment`Private`getMoatWells[AllWells[First[workingContainers]], moatSize],
			Flatten[currentContents[[All, All, 1]], 1]
		},
		(* Otherwise, return {{Null}, {Null}, {Null}} *)
		{{Null}, {Null}, {Null}}
	];

	(* check if there is any well conflict *)
	wellConflictQ = If[!emptyMoatSizeQ && ContainsAny[reservedMoatWells, currentWells],
		(
			Message[simulateExperimentAlphaScreen::WellConflict];
			True
		),
		False
	];

	moatPackets = If[emptyMoatSizeQ || wellConflictQ,
		(* Return an empty list if we have encountered any of the three previous errors *)
		{},

		(* Continue if no error has been raised *)
		Module[
			{numberOfMoatWells, moatWellDestinations, uploadPackets, packetsForTransfer, transferPackets},

			(* Find out the target moat wells and the number of them *)
			moatWellDestinations = Map[{#, First[workingContainers]}&, reservedMoatWells];
			numberOfMoatWells = Length[reservedMoatWells];

			(* UploadSample *)
			uploadPackets = UploadSample[
				ConstantArray[moatBufferModel, numberOfMoatWells],
				moatWellDestinations,
				Upload -> False,
				FastTrack -> True,
				Simulation -> updatedSimulation,
				SimulationMode -> True
			];

			(* UploadSampleTransfer *)
			packetsForTransfer = Take[uploadPackets, numberOfMoatWells];
			transferPackets = UploadSampleTransfer[
				ConstantArray[moatBuffer, numberOfMoatWells],
				packetsForTransfer,
				ConstantArray[moatVolume, numberOfMoatWells],
				Upload -> False,
				FastTrack -> True,
				Simulation -> updatedSimulation
			];

			(* Return the upload and transfer packets *)
			Flatten[{uploadPackets, transferPackets}]
		]
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation, Simulation[moatPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
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

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, simulationWithLabels]
	}
];