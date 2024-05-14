(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentPowderXRD*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPowderXRD Options and Messages*)


DefineOptions[ExperimentPowderXRD,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ExposureTime,
				Default -> 0.2 * Second,
				Description -> "The length of time the powder sample is exposed to the x-rays for each scan.",
				AllowNull -> False,
				Category -> "X-Ray Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.025 Second, 1 Hour],
					Units :> {1, {Second, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> DetectorDistance,
				Default -> Automatic,
				Description -> "The distance from the powder sample to the detector.",
				ResolutionDescription -> "Automatically set from the MinOmegaAngle, MaxOmegaAngle, MinDetectorAngle and MaxDetectorAngle options.",
				AllowNull -> False,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[60 Millimeter, 209 Millimeter],
					Units :> {1, {Millimeter, {Millimeter, Centimeter}}}
				]
			},
			{
				OptionName -> DetectorRotation,
				Default -> Automatic,
				Description -> "Determines whether the detector stays in one position or moves through multiple position through the course of a run.",
				ResolutionDescription -> "Automatically set from the MinOmegaAngle, MaxOmegaAngle, and OmegaAngleRange options.",
				AllowNull -> False,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Fixed, Sweeping]
				]
			},
			{
				OptionName -> FixedDetectorAngle,
				Default -> Automatic,
				Description -> "The angle between the X-ray source and the detector held constant through each data recording of a given sample.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to 0 AngularDegree if DetectorRotation-> Fixed.",
				AllowNull -> True,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> MinDetectorAngle,
				Default -> Automatic,
				Description -> "The initial angle between the X-ray source and the detector during the sweeping of detector angle during data recording of a given sample.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation -> Fixed, or to an angle based on the DetectorDistance option if DetectorRotation -> Sweeping.",
				AllowNull -> True,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> MaxDetectorAngle,
				Default -> Automatic,
				Description -> "The final angle between the X-ray source and the detector during the sweeping of detector angle during data recording of a given sample.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Fixed, or to an angle based on the DetectorDistance option if DetectorRotation-> Sweeping.",
				AllowNull -> True,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> DetectorAngleIncrement,
				Default -> Automatic,
				Description -> "The degree of change in the detector's angle in relation to X-ray source between each set of scans.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation -> Fixed, or from the MinDetectorAngle and MaxDetectorAngle options.",
				AllowNull -> True,
				Category -> "Detector Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 AngularDegree, 69 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> MinOmegaAngle,
				Default -> Automatic,
				Description -> "The angle between the sample and the X-ray source in this run during the first scan of the sample's run if DetectorRotation -> Fixed.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to an angle based on the DetectorDistance, MaxOmegaAngle, and OmegaAngleIncrement options if DetectorRotation-> Fixed.",
				AllowNull -> True,
				Category -> "Sample Handler Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-17.24 AngularDegree, 17.24 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> MaxOmegaAngle,
				Default -> Automatic,
				Description -> "The angle between the sample and the X-ray source in this run during the last scan of the sample's run if DetectorRotation -> Fixed.",
				ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to an angle based on the DetectorDistance, MinOmegaAngle, and OmegaAngleIncrement options if DetectorRotation-> Fixed.",
				AllowNull -> True,
				Category -> "Sample Handler Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-17.24 AngularDegree, 17.24 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> OmegaAngleIncrement,
				Default -> Automatic,
				Description -> "The degree of change in the sample's angle in relation to X-ray source between each scan. If DetectorRotation -> Sweeping, this rotation occurs for each detector angle as many times as required to reach 2 degrees.  Thus, if set to 0.5 degrees, there will be 4 scans per detector angle.",
				ResolutionDescription -> "Automatically set to 0.5 AngularDegree if DetectorRotation -> Sweeping, or from the MinOmegaAngle and MaxOmegaAngle options.",
				AllowNull -> False,
				Category -> "Sample Handler Parameters",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 AngularDegree, 2.0 AngularDegree],
					Units :> {1, {AngularDegree, {AngularDegree}}}
				]
			},
			{
				OptionName -> SpottingVolume,
				Default -> 3 Microliter,
				Description -> "The amount of sample to be spotted on each well of the crystallization plate.",
				AllowNull -> False,
				Category -> "Protocol",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 5 Microliter],
					Units :> {1, {Microliter, {Microliter}}}
				]
			}
		],
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat x-ray diffraction reading on each provided sample.  Specifying this option will result in the same sample being aliquoted into multiple wells in the X-ray plate.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]]
		},
		{
			OptionName -> Current,
			Default -> 30 * Milliampere,
			Description -> "The current used to generate the x-rays in this experiment.",
			AllowNull -> False,
			Category -> "X-Ray Parameters",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Milliampere, 30 Milliampere],
				Units :> {1, {Milliampere, {Milliampere, Ampere}}}
			]
		},
		{
			OptionName -> ImageXRDPlate,
			Default -> Automatic,
			Description -> "Indicates if the crystallization plate should be imaged after preparing and drying of plates but before loading onto the diffractometer.",
			ResolutionDescription -> "Automatically set to the template value, or False if no template exists.",
			AllowNull -> False,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Diffractometer, "XtaLAB Synergy-R"],
			Description -> "The diffractometer used for this experiment.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Diffractometer], Object[Instrument, Diffractometer]}]
			]
		},
		FuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOption,
		SamplesOutStorageOption
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentPowderXRD*)


Error::FixedOptionsWhileSweeping = "The following sample(s) have the MinOmegaAngle, MaxOmegaAngle, and/or FixedDetectorAngle option(s) specified when DetectorRotation -> Sweeping: `1`.  Please set DetectorRotation -> Fixed if you would like to specify FixedDetectorAngle.";
Error::SweepingOptionsWhileFixed = "The following sample(s) have the MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement option(s) specified when DetectorRotation -> Fixed: `1`.  Please set DetectorRotation -> Sweeping if you would like to specify these options.";
Error::MinOmegaAboveMax = "MinOmegaAngle is greater than MaxOmegaAngle for the following sample(s): `1`.  Please adjust MinOmegaAngle and/or MaxOmegaAngle or set them to Automatic.";
Error::MinDetectorAngleAboveMax = "MinDetectorAngle is greater than MaxDetectorAngle for the following sample(s): `1`.  Please Adjust MinDetectorAngle and/or MaxOmegaAngle or set them to Automatic.";
Error::FixedOptionsRequiredTogether = "The following sample(s) have the FixedDetectorAngle option set to Null when DetectorRotation -> Fixed: `1`.  Please adjust FixedDetectorAngle, or set it to Automatic.";
Error::SweepingOptionsRequiredTogether = "The following sample(s) have the MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement options set to Null when DetectorRotation -> Sweeping: `1`.  Please adjust these options, or set them to Automatic.";
Error::DetectorTooClose = "The following sample(s) have DetectorDistance too small than is allowed for the specified MinOmegaAngle, MaxOmegaAngle, MinDetectorAngle, MaxDetectorAngle, and/or FixedDetectorAngle options: `1`.  Please increase the DetectorDistance, or reduce the specified angles to be a narrower range.";
Error::PowderXRDTooManySamples = "The (number of input samples * NumberOfReplicates) cannot fit onto the instrument in a single protocol.  Please select fewer than `1` samples to run this protocol.";
Warning::PowderXRDHighVolume = "The volume of input samples `1` (or their resolved AssayVolume) (`2`) is above 100 microliters.  If using a sample that is a solid suspended in a solvent, we recommend using volumes at or below 100 microliters to ensure the suspension is adequately concentrated such that sufficient solid may be transferred to the XRD plate.";
Error::DetectorAngleIncrementTooLarge = "The DetectorAngleIncrement option is greater than the difference between MinDetectorAngle and MaxDetectorAngle for the following sample(s): `1`.  This may occur if MinDetectorAngle and MaxDetectorAngle are too close together; the minimum value for DetectorAngleIncrement is 0.1 AngularDegree.  Please adjust the values for these options.";
Error::OmegaAngleIncrementTooLarge = "The OmegaAngleIncrement option is greater than the difference between MinOmegaAngle and MaxOmegaAngle for the following sample(s): `1`.  This may occur if MinOmegaAngle and MaxOmegaAngle are too close together; the minimum value for OmegaAngleIncrement is 0.1 AngularDegree.  Please adjust the values for these options.";
Error::SpottingVolumeTooLarge = "The SpottingVolume option is greater than either the volume or the AssayVolume (if aliquoting) for the following sample(s): `1`.  Please use a smaller SpottingVolume or a larger AssayVolume for these sample(s).";



(*
	Single Sample with No Second Input:
		- Takes a single sample and passes through to core overload
*)
ExperimentPowderXRD[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentPowderXRD]] := ExperimentPowderXRD[{mySample}, myOptions];

(*
	CORE OVERLOAD: List Sample with No Second Input (all options):
		- Core functionality lives here
		- If initial experiment call involved volume/concentration second inputs, these will be in option values for this overload
*)
ExperimentPowderXRD[mySamples : {ObjectP[Object[Sample]]..}, myOptions : OptionsPattern[ExperimentPowderXRD]] := Module[
	{
		inheritedCache, allDownloadValues, newCache, listedOptions,
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions, sampleObjectDownloadFields, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, finalizedPacket, resourcePacketTests, allTests, validQ,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, sampleModelDownloadFields,
		sampleContainerFields, sampleContainerModelFields, previewRule, optionsRule, testsRule, resultRule,
		validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed,safeOptionsNamed,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed} = simulateSamplePreparationPackets[
			ExperimentPowderXRD,
			listedSamples,
			ToList[listedOptions]
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

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	{mySamplesWithPreparedSamples,{safeOptions,myOptionsWithPreparedSamples,samplePreparationCache}}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,{safeOptionsNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, applyTemplateOptionTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, combinedOptions, 1]];

	(* --- Make our one big Download call --- *)

	(* Define the fields from which to download information *)
	sampleObjectDownloadFields = Packet[LiquidHandlerIncompatible, Tablet, TabletWeight, TransportWarmed, TransportChilled, SamplePreparationCacheFields[Object[Sample], Format->Sequence]];
	sampleModelDownloadFields = Packet[Model[{UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Products, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]}]];
	sampleContainerFields = Packet[Container[{Model, SamplePreparationCacheFields[Object[Container], Format -> Sequence]}]];
	sampleContainerModelFields = Packet[Container[Model][{MaxVolume,SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]];

	(* Download the sample's packets and their models *)
	allDownloadValues = Quiet[Download[
		listedSamples,
		{
			sampleObjectDownloadFields,
			sampleModelDownloadFields,
			sampleContainerFields,
			sampleContainerModelFields
		},
		Cache -> FlattenCachePackets[{samplePreparationCache, inheritedCache}],
		Date -> Now
	], Download::FieldDoesntExist];

	(* combine the cache we inherited with what we Downloaded  *)
	newCache = FlattenCachePackets[{samplePreparationCache, inheritedCache, allDownloadValues}];

	(* --- Resolve the options! --- *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolvePowderXRDOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache],
			{resolvePowderXRDOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolvePowderXRDOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentPowderXRD,
		RemoveHiddenOptions[ExperimentPowderXRD, resolvedOptions],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {Result -> $Failed, Options -> resolvedOptionsNoHidden, Preview -> Null, Tests -> Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests}]}]
	];

	(* call the powderXRDResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPacket, resourcePacketTests} = If[gatherTests,
		powderXRDResourcePackets[Download[mySamplesWithPreparedSamples, Object, Cache -> newCache], unresolvedOptions, resolvedOptions, Output -> {Result, Tests}, Cache -> newCache],
		{powderXRDResourcePackets[Download[mySamplesWithPreparedSamples, Object, Cache -> newCache], unresolvedOptions, resolvedOptions, Output -> Result, Cache -> newCache], Null}
	];

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MatchQ[finalizedPacket, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
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
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	resultRule = Result -> If[MemberQ[output, Result] && validQ,
		(* need to do this because want to return only one protocol and not a list of length one *)
		UploadProtocol[finalizedPacket,
			Confirm -> confirm,
			Upload -> upload,
			FastTrack -> fastTrack,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage -> {Object[Protocol, PowderXRD]},
			Cache -> samplePreparationCache],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(*
	Single container with no second input:
		- Takes a single container and passes it to the core container overload
*)

ExperimentPowderXRD[myContainer : (ObjectP[{Object[Container], Object[Sample]}] | _String), myOptions : OptionsPattern[ExperimentPowderXRD]] := ExperimentPowderXRD[{myContainer}, myOptions];

(*
	Multiple containers with no second input:
		- expands the Containers into their contents and passes to the core function
*)

ExperimentPowderXRD[myContainers : {(ObjectP[{Object[Container], Object[Sample]}] | _String)..}, myOptions : OptionsPattern[ExperimentPowderXRD]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,sampleCache,
		containerToSampleTests, inputSamples, samplesOptions, aliquotResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationCache, updatedCache},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache} = simulateSamplePreparationPackets[
			ExperimentPowderXRD,
			ToList[myContainers],
			ToList[myOptions]
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

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamples, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamples, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		containerToSampleOptions[ExperimentPowderXRD, mySamplesWithPreparedSamples, safeOptions, Cache -> samplePreparationCache, Output -> {Result, Tests}],
		{containerToSampleOptions[ExperimentPowderXRD, mySamplesWithPreparedSamples, safeOptions, Cache -> samplePreparationCache], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult, $Failed],
		Return[$Failed]
	];

	(* Update our cache with our new simulated values. *)
	updatedCache = Flatten[{
		samplePreparationCache,
		Lookup[listedOptions, Cache, {}]
	}];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions, sampleCache} = containerToSampleResult;

	(* call ExperimentPowderXRD and get all its outputs *)
	aliquotResults = ExperimentPowderXRD[inputSamples, ReplaceRule[samplesOptions, Cache -> updatedCache]];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, aliquotResults}
		],
		{outputSpecification -> aliquotResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentPowderXRD call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];



(* ::Subsubsection::Closed:: *)
(* resolvePowderXRDOptions *)


DefineOptions[resolvePowderXRDOptions,
	Options :> {HelperOutputOption, CacheOption}
];

(* private function to resolve all the options *)
resolvePowderXRDOptions[mySamples : {ObjectP[Object[Sample]]..}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolvePowderXRDOptions]] := Module[
	{outputSpecification, output, gatherTests, messages, inheritedCache, samplePrepOptions, xrdOptions, simulatedSamples,
		resolvedSamplePrepOptions, simulatedCache, samplePrepTests, exposureTime, current, numberOfReplicates, name,
		parentProtocol, samplePackets, sampleModelPackets, fastTrack, combinedCache,
		samplePacketsToCheckIfDiscarded, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest, roundedXRDOptions,
		precisionTests, validNameQ, nameInvalidOptions, validNameTest, mapThreadFriendlyOptions,
		resolvedExposureTime, resolvedDetectorDistance, resolvedDetectorRotation, resolvedMinOmegaAngle, resolvedMaxOmegaAngle,
		resolvedFixedDetectorAngle, resolvedMinDetectorAngle, resolvedMaxDetectorAngle, resolvedDetectorAngleIncrement,
		fixedOptionsWhenSweepingErrors, sweepingOptionsWhenFixedErrors, minOmegaAboveMaxErrors, minDetectorAngleAboveMaxErrors,
		fixedOptionsRequiredTogetherErrors, sweepingOptionsRequiredTogetherErrors, detectorTooCloseErrors,
		fixedOptionsWhenSweepingOptions, fixedOptionsWhenSweepingTest, detectorAngleIncrementTooLargeErrors,
		sweepingOptionsWhenFixedOptions, sweepingOptionsWhenFixedTest, minOmegaAboveMaxOptions, minOmegaAboveMaxTest,
		minDetectorAboveMaxOptions, minDetectorAngleAboveMaxTest, fixedOptionsRequiredTogetherOptions,
		fixedOptionsRequiredTogetherTest, sweepingOptionsRequiredTogetherOptions, sweepingOptionsRequiredTogetherTest,
		detectorTooCloseOptions, detectorTooCloseTest, simulatedContainerModels, samplePreparation,
		targetContainers, samplesInStorage, samplesOutStorage, instrument, detectorAngleIncrementTooLargeOptions,
		detectorAngleIncrementTooLargeTest, resolvedOmegaAngleIncrement, omegaAngleIncrementTooLargeOptions,
		omegaAngleIncrementTooLargeTest, resolvedAliquotOptions, aliquotTests, invalidOptions, invalidInputs, allTests,
		confirm, template, cache, operator, upload, outputOption, email, subprotocolDescription, resolvedOptions, testsRule,
		resultRule, numSamples, tooManySamplesQ, tooManySamplesInputs, tooManySamplesTest, imageXRDPlate, spottingVolume,
		resolvedAssayVolume, sampleVolume, volumesTooLargeBool, samplesWithVolumesTooLarge, volumesTooLarge,
		volumeTooLargeWarning, resolvedPostProcessingOptions, requiredAliquotAmount, aliquotWarningMessage,
		omegaAngleIncrementTooLargeErrors, spottingVolumePerSample,
		spottingVolumesTooLargeBool, spottingVolumesTooLargeOptions, spottingVolumesTooLargeTest},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache option *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* get the sample and model packets *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[mySamples, Object];
	sampleModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Model], Object];

	(* --- split out and resolve the sample prep options --- *)

	(* split out the options *)
	{samplePrepOptions, xrdOptions} = splitPrepOptions[myOptions];

	(* resolve the sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptions[ExperimentPowderXRD, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> {Result, Tests}],
		{resolveSamplePrepOptions[ExperimentPowderXRD, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> Result], {}}
	];

	(* merge caches together *)
	combinedCache = FlattenCachePackets[{inheritedCache, simulatedCache}];

	(* pull out the options that are defaulted *)
	{exposureTime, current, numberOfReplicates, name, parentProtocol, fastTrack} = Lookup[xrdOptions, {ExposureTime, Current, NumberOfReplicates, Name, ParentProtocol, FastTrack}];

	(* --- Do the Input Validation Checks --- *)

	(* get all the sample packets together that are going to be checked for whether they are discarded *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	samplePacketsToCheckIfDiscarded = Cases[samplePackets, PacketP[Object[Sample]]];

	(* get the samples that are discarded; if on the FastTrack, don't bother checking *)
	discardedSamplePackets = If[Not[fastTrack],
		Select[samplePacketsToCheckIfDiscarded, MatchQ[Lookup[#, Status], Discarded]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {PacketP[]..}] && messages,
		(
			Message[Error::DiscardedSamples, Lookup[discardedSamplePackets, Object, {}]];
			Lookup[discardedSamplePackets, Object, {}]
		),
		Lookup[discardedSamplePackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples " <> ObjectToString[discardedInvalidInputs, Cache -> inheritedCache] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[samplePacketsToCheckIfDiscarded],
				Nothing,
				Test["Provided input samples " <> ObjectToString[Download[Complement[samplePacketsToCheckIfDiscarded, discardedInvalidInputs], Object], Cache -> inheritedCache] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

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
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> inheritedCache] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Cache -> inheritedCache] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* get the number of samples *)
	numSamples = If[NullQ[numberOfReplicates],
		Length[mySamples],
		Length[mySamples] * numberOfReplicates
	];

	(* if we have more than 96 samples, throw an error *)
	tooManySamplesQ = numSamples > 96;

	(* if there are more than 96 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManySamplesInputs = Which[
		TrueQ[tooManySamplesQ] && messages,
		(
			Message[Error::PowderXRDTooManySamples, 96];
			Download[mySamples, Object]
		),
		TrueQ[tooManySamplesQ], Download[mySamples, Object],
		True, {}
	];

	(* if we are gathering tests, create a test indicating whether we have too many samples or not *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided times NumberOfReplicates is not greater than 96:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	(* --- Option precision checks --- *)

	(* ensure that all the numerical options have the proper precision *)
	{roundedXRDOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[Association[xrdOptions], {ExposureTime, DetectorDistance, OmegaAngleIncrement, MinOmegaAngle, MaxOmegaAngle, FixedDetectorAngle, MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement, SpottingVolume}, {10^-3 * Second, 1 * Millimeter, 10^-1 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-1 * AngularDegree, 10^-1 * Microliter}, Output -> {Result, Tests}],
		{RoundOptionPrecision[Association[xrdOptions], {ExposureTime, DetectorDistance, OmegaAngleIncrement, MinOmegaAngle, MaxOmegaAngle, FixedDetectorAngle, MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement, SpottingVolume}, {10^-3 * Second, 1 * Millimeter, 10^-1 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-2 * AngularDegree, 10^-1 * AngularDegree, 10^-1 * Microliter}], {}}
	];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, PowderXRD, Lookup[roundedXRDOptions, Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "PowderXRD protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name, _String],
		Test["If specified, Name is not already a PowderXRD object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentPowderXRD, roundedXRDOptions];

	(* do our big MapThread *)
	{
		resolvedExposureTime,
		resolvedDetectorDistance,
		resolvedDetectorRotation,
		resolvedMinOmegaAngle,
		resolvedMaxOmegaAngle,
		resolvedOmegaAngleIncrement,
		resolvedFixedDetectorAngle,
		resolvedMinDetectorAngle,
		resolvedMaxDetectorAngle,
		resolvedDetectorAngleIncrement,
		fixedOptionsWhenSweepingErrors,
		sweepingOptionsWhenFixedErrors,
		minOmegaAboveMaxErrors,
		minDetectorAngleAboveMaxErrors,
		fixedOptionsRequiredTogetherErrors,
		sweepingOptionsRequiredTogetherErrors,
		detectorTooCloseErrors,
		detectorAngleIncrementTooLargeErrors,
		omegaAngleIncrementTooLargeErrors
	} = Transpose[MapThread[
		Function[{samplePacket, options},
			Module[
				{fixedOptionsWhenSweepingError, sweepingOptionsWhenFixedError, minOmegaAboveMaxError, minDetectorAngleAboveMaxError,
					fixedOptionsRequiredTogetherError, sweepingOptionsRequiredTogetherError, detectorTooCloseError,
					specifiedDetectorRotation, specifiedMinDetectorAngle, specifiedMaxDetectorAngle, omegaAngleIncrementTooLargeError,
					specifiedDetectorAngleIncrement, detectorRotation, minDetectorAngle, maxDetectorAngle, detectorAngleIncrement,
					specifiedMinOmegaAngle, specifiedMaxOmegaAngle, specifiedDetectorDistance, specifiedFixedDetectorAngle,
					minOmegaAngle, maxOmegaAngle, fixedDetectorAngle, detectorDistance, minDetectorDistance, temporaryDetectorDistance,
					detectorAngleIncrementTooLargeError, specifiedOmegaAngleIncrement, omegaAngleIncrement, roundedOmegaAngleDiff},

				(* set our error tracking variables *)
				{
					fixedOptionsWhenSweepingError,
					sweepingOptionsWhenFixedError,
					minOmegaAboveMaxError,
					minDetectorAngleAboveMaxError,
					fixedOptionsRequiredTogetherError,
					sweepingOptionsRequiredTogetherError,
					detectorTooCloseError,
					detectorAngleIncrementTooLargeError,
					omegaAngleIncrementTooLargeError
				} = {False, False, False, False, False, False, False, False, False};

				(* pull out the specified values of the options *)
				{
					specifiedDetectorRotation,
					specifiedMinDetectorAngle,
					specifiedMaxDetectorAngle,
					specifiedDetectorAngleIncrement,
					specifiedMinOmegaAngle,
					specifiedMaxOmegaAngle,
					specifiedOmegaAngleIncrement,
					specifiedDetectorDistance,
					specifiedFixedDetectorAngle
				} = Lookup[options, {DetectorRotation, MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement, MinOmegaAngle, MaxOmegaAngle, OmegaAngleIncrement, DetectorDistance, FixedDetectorAngle}];

				(* resolve the DetectorRotation master switch *)
				(* - If it's specified, then obviously it's that *)
				(* - If it's not specified but any of the fixed options are specified, then it's fixed *)
				(* - Otherwise, it's sweeping *)
				detectorRotation = Which[
					MatchQ[specifiedDetectorRotation, Fixed | Sweeping], specifiedDetectorRotation,
					(* if the fixed or sweeping options are specified then go to those *)
					MemberQ[{specifiedFixedDetectorAngle, specifiedMinOmegaAngle, specifiedMaxOmegaAngle}, UnitsP[]], Fixed,
					MemberQ[{specifiedMinDetectorAngle, specifiedMaxDetectorAngle, specifiedDetectorAngleIncrement}, UnitsP[]], Sweeping,
					(* if the fixed or sweeping options are explicitly Null, go with the other one *)
					MemberQ[{specifiedFixedDetectorAngle, specifiedMinOmegaAngle, specifiedMaxOmegaAngle}, Null], Sweeping,
					MemberQ[{specifiedMinDetectorAngle, specifiedMaxDetectorAngle, specifiedDetectorAngleIncrement}, Null], Fixed,
					(* otherwise just go with Sweeping *)
					True, Sweeping
				];

				(* resolve the rest of the MapThread options; this depends heavily on whether detectorRotation is Fixed or Sweeping *)
				If[MatchQ[detectorRotation, Fixed],
					(* DetectorRotation -> Fixed *)
					Module[{},

						(* if MinDetectorAngle is specified then go with that but flip the sweepingOptionsWhenFixedError switch; otherwise, pick Null and leave it be *)
						{minDetectorAngle, sweepingOptionsWhenFixedError} = If[MatchQ[specifiedMinDetectorAngle, Automatic | Null],
							{Null, sweepingOptionsWhenFixedError},
							{specifiedMinDetectorAngle, True}
						];

						(* if MaxDetectorAngle is specified then go with that but flip the sweepingOptionsWhenFixedError switch; otherwise, pick Null and leave it be *)
						{maxDetectorAngle, sweepingOptionsWhenFixedError} = If[MatchQ[specifiedMaxDetectorAngle, Automatic | Null],
							{Null, sweepingOptionsWhenFixedError},
							{specifiedMaxDetectorAngle, True}
						];

						(* if DetectorAngleIncrement is specified then go with that but flip the sweepingOptionsWhenFixedError switch; otherwise, pick Null and leave it be *)
						{detectorAngleIncrement, sweepingOptionsWhenFixedError} = If[MatchQ[specifiedDetectorAngleIncrement, Automatic | Null],
							{Null, sweepingOptionsWhenFixedError},
							{specifiedDetectorAngleIncrement, True}
						];

						(* resolve the FixedDetectorAngle option; if it is Null then stick with that but flip the fixedOptionsRequiredTogetherError switch *)
						(* otherwise, resolve to 0*AngularDegree if Automatic, or stick with whatever the user wanted *)
						{fixedDetectorAngle, fixedOptionsRequiredTogetherError} = Which[
							NullQ[specifiedFixedDetectorAngle], {Null, True},
							MatchQ[specifiedFixedDetectorAngle, Automatic], {0 * AngularDegree, fixedOptionsRequiredTogetherError},
							True, {specifiedFixedDetectorAngle, fixedOptionsRequiredTogetherError}
						];

						(* get the temporary detector distance if it doesn't exist already *)
						(* basically this helps us with using the empiricalPowderXRDValues function in a way that doesn't corner us before we _actually_ try to resolve it *)
						temporaryDetectorDistance = empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> specifiedMinOmegaAngle, MaxOmegaAngle -> specifiedMaxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, MinDetectorAngle -> specifiedMinDetectorAngle, MaxDetectorAngle -> specifiedMaxDetectorAngle];

						(* resolve the MinOmegaAngle option; if it is specified obviously go with that *)
						(* if not and DetectorDistance isn't specified, go with the minimum value of with the instrument (i.e., -17.24 AngularDegree) *)
						(* if MinOmegaAngle isn't specified but DetectorDistance _is_ specified, use the empirical function for what the minimum value this instrument can have given the detector distance *)
						minOmegaAngle = Which[
							MatchQ[specifiedMinOmegaAngle, UnitsP[AngularDegree]], specifiedMinOmegaAngle,
							MatchQ[specifiedDetectorDistance, Null | Automatic], empiricalPowderXRDValues[MinOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, DetectorDistance -> temporaryDetectorDistance],
							True, empiricalPowderXRDValues[MinOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, DetectorDistance -> specifiedDetectorDistance]
						];

						(* resolve the MaxOmegaAngle option; if it is specified obviously go with that *)
						(* if not go with the empirical function *)
						maxOmegaAngle = Which[
							MatchQ[specifiedMaxOmegaAngle, UnitsP[AngularDegree]], specifiedMaxOmegaAngle,
							MatchQ[specifiedDetectorDistance, Null | Automatic], empiricalPowderXRDValues[MaxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, DetectorDistance -> temporaryDetectorDistance],
							True, empiricalPowderXRDValues[MaxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, DetectorDistance -> specifiedDetectorDistance]
						];

						(* get rounded 1/4 of maxOmegaAngle - minOmegaAngle *)
						roundedOmegaAngleDiff = Round[Abs[(maxOmegaAngle - minOmegaAngle) / 4], 0.1 * AngularDegree];

						(* resolve the OmegaAngleIncrement option; if it is specified obviously go with that *)
						(* if not get 1/4 the difference between MinOmegaAngle and MaxOmegaAngle, within the bounds of 0.1 being the minimum and 2.0 being the maximum *)
						omegaAngleIncrement = Which[
							MatchQ[specifiedOmegaAngleIncrement, UnitsP[AngularDegree]], specifiedOmegaAngleIncrement,
							TrueQ[roundedOmegaAngleDiff < 0.1 AngularDegree], 0.1 AngularDegree,
							TrueQ[roundedOmegaAngleDiff > 2.0 AngularDegree], 2.0 AngularDegree,
							True, roundedOmegaAngleDiff
						];

						(* if OmegaAngleIncrement is greater than the difference between Max and MinOmegaAngle, flip an error switch *)
						omegaAngleIncrementTooLargeError = If[Abs[maxOmegaAngle - minOmegaAngle] < omegaAngleIncrement,
							True,
							omegaAngleIncrementTooLargeError
						];

						(* resolve the DetectorDistance option *)
						detectorDistance = If[MatchQ[specifiedDetectorDistance, UnitsP[Millimeter]],
							specifiedDetectorDistance,
							empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> minOmegaAngle, MaxOmegaAngle -> maxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, MinDetectorAngle -> minDetectorAngle, MaxDetectorAngle -> maxDetectorAngle]
						];

						(* make sure MinOmegaAngle is less than MaxOmegaAngle *)
						minOmegaAboveMaxError = If[minOmegaAngle >= maxOmegaAngle,
							True,
							minOmegaAboveMaxError
						];
					],
					(* DetectorRotation -> Sweeping *)
					Module[
						{},

						(* if FixedDetectorAngle is specified then go with that but flip the fixedOptionsWhenSweepingError switch; otherwise, pick Null and leave it be *)
						{fixedDetectorAngle, fixedOptionsWhenSweepingError} = If[MatchQ[specifiedFixedDetectorAngle, Automatic | Null],
							{Null, fixedOptionsWhenSweepingError},
							{specifiedFixedDetectorAngle, True}
						];

						(* if MinOmegaAngle is Automatic, resolve to Null because it doesn't make sense for Sweeping; otherwise go with what the user says, but flip the fixedOptionsWhenSweepingError if it's not Null *)
						{minOmegaAngle, fixedOptionsWhenSweepingError} = Which[
							MatchQ[specifiedMinOmegaAngle, Automatic], {Null, fixedOptionsWhenSweepingError},
							MatchQ[specifiedMinOmegaAngle, Null], {specifiedMinOmegaAngle, fixedOptionsWhenSweepingError},
							True, {specifiedMinOmegaAngle, True}
						];

						(* if MaxOmegaAngle is Automatic, resolve to Null because it doesn't make sense for Sweeping;  otherwise go with what the user says, but flip the fixedOptionsWhenSweepingError if it's not Null *)
						{maxOmegaAngle, fixedOptionsWhenSweepingError} = Which[
							MatchQ[specifiedMaxOmegaAngle, Automatic], {Null, fixedOptionsWhenSweepingError},
							MatchQ[specifiedMaxOmegaAngle, Null], {specifiedMaxOmegaAngle, fixedOptionsWhenSweepingError},
							True, {specifiedMaxOmegaAngle, True}
						];

						(* resolve the OmegaAngleIncrement option; basically just do what was specified, or 0.5 AngularDegrees otherwise *)
						omegaAngleIncrement = If[MatchQ[specifiedOmegaAngleIncrement, UnitsP[AngularDegree]],
							specifiedOmegaAngleIncrement,
							0.5 AngularDegree
						];

						(* - if MinDetectorAngle is Null, flip the sweepingOptionsRequiredTogetherError switch *)
						(* - if it is specified, just go with that *)
						(* - if it is Automatic, resolve to 0 AngularDegree *)
						{minDetectorAngle, sweepingOptionsRequiredTogetherError} = Switch[specifiedMinDetectorAngle,
							Null, {Null, True},
							Automatic, {0 * AngularDegree, sweepingOptionsRequiredTogetherError},
							UnitsP[AngularDegree], {specifiedMinDetectorAngle, sweepingOptionsRequiredTogetherError}
						];

						(* - if MaxDetectorAngle is Null, flip the sweepingOptionsRequiredTogetherError switch *)
						(* - if it is specified, just go with that *)
						(* - if it is Automatic and DetectorDistance is not specified, resolve to the max of 81.24 AngularDegree *)
						(* - if it is Automatic and DetectorDistance is specified, resolve to what the empirical function says *)
						{maxDetectorAngle, sweepingOptionsRequiredTogetherError} = Which[
							NullQ[specifiedMaxDetectorAngle], {Null, True},
							MatchQ[specifiedMaxDetectorAngle, UnitsP[AngularDegree]], {specifiedMaxDetectorAngle, sweepingOptionsRequiredTogetherError},
							MatchQ[specifiedMaxDetectorAngle, Automatic] && MatchQ[specifiedDetectorDistance, Automatic | Null], {81.24 * AngularDegree, sweepingOptionsRequiredTogetherError},
							MatchQ[specifiedMaxDetectorAngle, Automatic] && MatchQ[specifiedDetectorDistance, UnitsP[Millimeter]], {empiricalPowderXRDValues[MaxDetectorAngle, DetectorDistance -> specifiedDetectorDistance], sweepingOptionsRequiredTogetherError}
						];

						(* - if DetectorAngleIncrement is Null, flip the sweepingOptionsRequiredTogetherError switch *)
						(* - if it is specified, just go with that *)
						(* - otherwise, make the increment 0.25 times the range of detector angles (use Abs to ensure we don't have a negative increment) *)
						(* make sure we don't go below 0.1 AngularDegree  *)
						{detectorAngleIncrement, sweepingOptionsRequiredTogetherError} = Switch[specifiedDetectorAngleIncrement,
							Null, {Null, True},
							Automatic, {Max[Cases[{Round[Abs[(maxDetectorAngle - minDetectorAngle) / 4], 0.1 * AngularDegree], 0.1 * AngularDegree}, UnitsP[AngularDegree]]], sweepingOptionsRequiredTogetherError},
							UnitsP[AngularDegree], {specifiedDetectorAngleIncrement, sweepingOptionsRequiredTogetherError}
						];

						(* resolve the DetectorDistance option *)
						detectorDistance = If[MatchQ[specifiedDetectorDistance, UnitsP[Millimeter]],
							specifiedDetectorDistance,
							empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> minOmegaAngle, MaxOmegaAngle -> maxOmegaAngle, MinDetectorAngle -> minDetectorAngle, MaxDetectorAngle -> maxDetectorAngle]
						];

						(* make sure MinDetectorAngle is less than MaxDetectorAngle *)
						minDetectorAngleAboveMaxError = If[minDetectorAngle >= maxDetectorAngle,
							True,
							minDetectorAngleAboveMaxError
						];

						(* make sure MinOmegaAngle is less than MaxOmegaAngle *)
						minOmegaAboveMaxError = If[minOmegaAngle >= maxOmegaAngle,
							True,
							minOmegaAboveMaxError
						];

					]
				];

				(* calculate the minimum allowed DetectorDistance based on the values resolved above *)
				minDetectorDistance = empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> minOmegaAngle, MaxOmegaAngle -> maxOmegaAngle, MinDetectorAngle -> minDetectorAngle, MaxDetectorAngle -> maxDetectorAngle, FixedDetectorAngle -> fixedDetectorAngle];

				(* if the actual detector distance is less than the minDetectorDistance, flip the detectorTooCloseError switch *)
				detectorTooCloseError = If[detectorDistance < minDetectorDistance,
					True,
					detectorTooCloseError
				];

				(* if the MaxDetectorAngle - MinDetectorAngle is less than the DetectorAngleIncrement, throw an error *)
				detectorAngleIncrementTooLargeError = If[Abs[(maxDetectorAngle - minDetectorAngle)] < detectorAngleIncrement,
					True,
					detectorAngleIncrementTooLargeError
				];

				(* return all the variables here *)
				{
					exposureTime,
					detectorDistance,
					detectorRotation,
					minOmegaAngle,
					maxOmegaAngle,
					omegaAngleIncrement,
					fixedDetectorAngle,
					minDetectorAngle,
					maxDetectorAngle,
					detectorAngleIncrement,
					fixedOptionsWhenSweepingError,
					sweepingOptionsWhenFixedError,
					minOmegaAboveMaxError,
					minDetectorAngleAboveMaxError,
					fixedOptionsRequiredTogetherError,
					sweepingOptionsRequiredTogetherError,
					detectorTooCloseError,
					detectorAngleIncrementTooLargeError,
					omegaAngleIncrementTooLargeError
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions}
	]];

	(* --- Unresolvable error checking --- *)

	(* throw a message if options exclusive to a fixed detector are specified when we are sweeping *)
	fixedOptionsWhenSweepingOptions = If[MemberQ[fixedOptionsWhenSweepingErrors, True] && messages,
		(
			Message[Error::FixedOptionsWhileSweeping, ObjectToString[PickList[Lookup[samplePackets, Object], fixedOptionsWhenSweepingErrors, True], Cache -> inheritedCache]];
			{FixedDetectorAngle}
		),
		{}
	];

	(* generate the FixedOptionsWhileSweeping tests *)
	fixedOptionsWhenSweepingTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], fixedOptionsWhenSweepingErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], fixedOptionsWhenSweepingErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", FixedDetectorAngle is not specified if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", FixedDetectorAngle is not specified if DetectorRotation -> Sweeping:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if options exclusive to a sweeping detector are specified when we are fixed *)
	sweepingOptionsWhenFixedOptions = If[MemberQ[sweepingOptionsWhenFixedErrors, True] && messages,
		(
			Message[Error::SweepingOptionsWhileFixed, ObjectToString[PickList[Lookup[samplePackets, Object], sweepingOptionsWhenFixedErrors, True], Cache -> inheritedCache]];
			{MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement}
		),
		{}
	];

	(* generate the SweepingOptionsWhileFixed tests *)
	sweepingOptionsWhenFixedTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], sweepingOptionsWhenFixedErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], sweepingOptionsWhenFixedErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement are not specified if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement are not specified if DetectorRotation -> Fixed:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if MinOmegaAngle > MaxOmegaAngle *)
	minOmegaAboveMaxOptions = If[MemberQ[minOmegaAboveMaxErrors, True] && messages,
		(
			Message[Error::MinOmegaAboveMax, ObjectToString[PickList[Lookup[samplePackets, Object], minOmegaAboveMaxErrors, True], Cache -> inheritedCache]];
			{MinOmegaAngle, MaxOmegaAngle}
		),
		{}
	];

	(* generate the MinOmegaAboveMax tests *)
	minOmegaAboveMaxTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], minOmegaAboveMaxErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], minOmegaAboveMaxErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", MinOmegaAngle is less than MaxOmegaAngle:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", MinOmegaAngle is less than MaxOmegaAngle:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if MaxOmegaAngle - MinOmegaAngle < OmegaAngleIncrement *)
	omegaAngleIncrementTooLargeOptions = If[MemberQ[omegaAngleIncrementTooLargeErrors, True] && messages,
		(
			Message[Error::OmegaAngleIncrementTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], omegaAngleIncrementTooLargeErrors, True], Cache -> inheritedCache]];
			{OmegaAngleIncrement, MinOmegaAngle, MaxOmegaAngle}
		),
		{}
	];

	(* generate the DetectorAngleIncrementTooLarge tests *)
	omegaAngleIncrementTooLargeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], omegaAngleIncrementTooLargeErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], omegaAngleIncrementTooLargeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", OmegaAngleIncrement is less than the difference between MaxOmegaAngle and MaxOmegaAngle if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", OmegaAngleIncrement is less than the difference between MaxOmegaAngle and MaxOmegaAngle if DetectorRotation -> Fixed:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];


	(* throw a message if MinDetectorAngle > MaxDetectorAngle *)
	minDetectorAboveMaxOptions = If[MemberQ[minDetectorAngleAboveMaxErrors, True] && messages,
		(
			Message[Error::MinDetectorAngleAboveMax, ObjectToString[PickList[Lookup[samplePackets, Object], minDetectorAngleAboveMaxErrors, True], Cache -> inheritedCache]];
			{MinDetectorAngle, MaxDetectorAngle}
		),
		{}
	];

	(* generate the MinDetectorAngleAboveMax tests *)
	minDetectorAngleAboveMaxTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], minDetectorAngleAboveMaxErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], minDetectorAngleAboveMaxErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle is less than MaxDetectorAngle, or both are Null:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle is less than MaxDetectorAngle, or both are Null:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if MaxDetectorAngle - MinDetectorAngle < DetectorAngleIncrement *)
	detectorAngleIncrementTooLargeOptions = If[MemberQ[detectorAngleIncrementTooLargeErrors, True] && messages,
		(
			Message[Error::DetectorAngleIncrementTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], detectorAngleIncrementTooLargeErrors, True], Cache -> inheritedCache]];
			{DetectorAngleIncrement, MinDetectorAngle, MaxDetectorAngle}
		),
		{}
	];

	(* generate the DetectorAngleIncrementTooLarge tests *)
	detectorAngleIncrementTooLargeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], detectorAngleIncrementTooLargeErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], detectorAngleIncrementTooLargeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", DetectorAngleIncrement is less than the difference between MaxDetectorAngle and MaxDetectorAngle if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", DetectorAngleIncrement is less than the difference between MaxDetectorAngle and MaxDetectorAngle if DetectorRotation -> Sweeping:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if FixedDetectorAngle is Null when DetectorRotation -> Fixed *)
	fixedOptionsRequiredTogetherOptions = If[MemberQ[fixedOptionsRequiredTogetherErrors, True] && messages,
		(
			Message[Error::FixedOptionsRequiredTogether, ObjectToString[PickList[Lookup[samplePackets, Object], fixedOptionsRequiredTogetherErrors, True], Cache -> inheritedCache]];
			{FixedDetectorAngle}
		),
		{}
	];

	(* generate the FixedOptionsRequiredTogether tests *)
	fixedOptionsRequiredTogetherTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], fixedOptionsRequiredTogetherErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], fixedOptionsRequiredTogetherErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", FixedDetectorAngle is not Null if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", FixedDetectorAngle is not Null if DetectorRotation -> Fixed:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if MinDetectorAngle, MaxDetectorAngle, or DetectorAngleIncrement is Null when DetectorRotation -> Sweeping *)
	sweepingOptionsRequiredTogetherOptions = If[MemberQ[sweepingOptionsRequiredTogetherErrors, True] && messages,
		(
			Message[Error::SweepingOptionsRequiredTogether, ObjectToString[PickList[Lookup[samplePackets, Object], sweepingOptionsRequiredTogetherErrors, True], Cache -> inheritedCache]];
			{MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement}
		),
		{}
	];

	(* generate the SweepingOptionsRequiredTogether tests *)
	sweepingOptionsRequiredTogetherTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], sweepingOptionsRequiredTogetherErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], sweepingOptionsRequiredTogetherErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement is not Null if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement is not Null if DetectorRotation -> Sweeping:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if the detector is too close *)
	detectorTooCloseOptions = If[MemberQ[detectorTooCloseErrors, True] && messages,
		(
			Message[Error::DetectorTooClose, ObjectToString[PickList[Lookup[samplePackets, Object], detectorTooCloseErrors, True], Cache -> inheritedCache]];
			{DetectorDistance}
		),
		{}
	];

	(* generate the DetectorTooClose tests *)
	detectorTooCloseTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], detectorTooCloseErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], detectorTooCloseErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", DetectorDistance is not too low:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", DetectorDistance is not too low:",
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

	(* get the simulated sample's container models *)
	simulatedContainerModels = Download[simulatedSamples, Container[Model][Object], Cache -> combinedCache, Date -> Now];

	(* get the target containers; if the simulatedContainerModel is a liquid-handler-compatible model, then pick that one; if not pick a different one *)
	targetContainers = Map[
		If[MemberQ[Experiment`Private`hamiltonAliquotContainers["Memoization"], ObjectP[#]],
			#,
			Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		]&,
		simulatedContainerModels
	];

	(* RequiredAliquotAmount is going to be set to Null.  This is because transferring the slurry really requires us to transfer everything in ExperimentPowderXRD or we risk losing stuff.  I don't really know how else to handle it; these slurries are weird *)
	requiredAliquotAmount = Null;

	(* AliquotWarningMessage tells the aliquot resolver what to say about transferring containers *)
	aliquotWarningMessage = "because the given samples are not compatible with the parameters required to load the PowderXRD read plate.  You may set how much volume you wish to be aliquoted using the AliquotAmount option.";

	(* resolve the aliquot options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[ExperimentPowderXRD, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, resolvedSamplePrepOptions], Cache -> combinedCache, AliquotWarningMessage -> aliquotWarningMessage, RequiredAliquotContainers ->targetContainers, RequiredAliquotAmounts -> requiredAliquotAmount, Output -> {Result, Tests}],
		{resolveAliquotOptions[ExperimentPowderXRD, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, resolvedSamplePrepOptions], Cache -> combinedCache, AliquotWarningMessage -> aliquotWarningMessage, RequiredAliquotContainers ->targetContainers, RequiredAliquotAmounts -> requiredAliquotAmount, Output -> Result], {}}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* pull out the resolved assay volume *)
	resolvedAssayVolume = Lookup[resolvedAliquotOptions, AssayVolume];

	(* get the volume and spotting volume of the input samples *)
	sampleVolume = Lookup[samplePackets, Volume];
	spottingVolume = Lookup[roundedXRDOptions, SpottingVolume];

	(* get the amount of spotting volume coming from each sample*)
	spottingVolumePerSample = Merge[Thread[samplePackets -> spottingVolume], Total];

	(* get the booleans for if the sample has a volume smaller than the spotting volume *)
	(* account for the fact that replicates can mess with this and so if you are not aliquoting but have replicates, your _total_ spotting volume needs to be below the sample volume*)
	spottingVolumesTooLargeBool = MapThread[
		Function[{assayVolume, sampleVol, spottingVol, samplePacket},
			If[VolumeQ[assayVolume],
				spottingVol > assayVolume,
				(samplePacket /. spottingVolumePerSample) > sampleVol
			]
		],
		{resolvedAssayVolume, sampleVolume, spottingVolume, samplePackets}
	];

	(* throw a message if the spotting volume is too large *)
	spottingVolumesTooLargeOptions = If[MemberQ[spottingVolumesTooLargeBool, True] && messages,
		(
			Message[Error::SpottingVolumeTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], spottingVolumesTooLargeBool, True], Cache -> inheritedCache]];
			{SpottingVolume}
		),
		{}
	];

	(* generate the SpottingVolumeTooLarge tests *)
	spottingVolumesTooLargeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], spottingVolumesTooLargeBool];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], spottingVolumesTooLargeBool, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the total SpottingVolume is less than the volume of the sample, or, if aliquoting, the AssayVolume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", the total SpottingVolume is less than the volume of the sample, or, if aliquoting, the AssayVolume:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the booleans for if the sample has a volume that is too large *)
	(* if only dealing with solids then I guess don't throw a warning here; if that's a problem, then it should be caught elsewhere *)
	volumesTooLargeBool = MapThread[
		Function[{assayVolume, volume},
			Which[
				VolumeQ[assayVolume], assayVolume > 100 * Microliter,
				VolumeQ[volume], volume > 100 * Microliter,
				True, False
			]
		],
		{resolvedAssayVolume, sampleVolume}
	];

	(* get the volume that we care about and the samples too *)
	samplesWithVolumesTooLarge = PickList[Lookup[samplePackets, Object, {}], volumesTooLargeBool];
	volumesTooLarge = MapThread[
		Which[
			Not[#3], Nothing,
			VolumeQ[#1], #1,
			VolumeQ[#2], #2,
			True, Nothing
		]&,
		{resolvedAssayVolume, sampleVolume, volumesTooLargeBool}
	];

	(* thow a warning if the volume is too large *)
	If[messages && Not[MatchQ[$ECLApplication, Engine]] && MemberQ[volumesTooLargeBool, True],
		Message[Warning::PowderXRDHighVolume, samplesWithVolumesTooLarge, volumesTooLarge]
	];

	(* make a warning for the volume being too high *)
	volumeTooLargeWarning = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = samplesWithVolumesTooLarge;

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], volumesTooLargeBool, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", Volume or AssayVolume is 100 microliters or less:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", Volume or AssayVolume is 100 microliters or less:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* --- Final stuff --- *)

	(* combine all the invalid options *)
	invalidOptions = DeleteDuplicates[Join[
		nameInvalidOptions,
		fixedOptionsWhenSweepingOptions,
		sweepingOptionsWhenFixedOptions,
		minOmegaAboveMaxOptions,
		minDetectorAboveMaxOptions,
		fixedOptionsRequiredTogetherOptions,
		sweepingOptionsRequiredTogetherOptions,
		detectorTooCloseOptions,
		detectorAngleIncrementTooLargeOptions,
		omegaAngleIncrementTooLargeOptions,
		spottingVolumesTooLargeOptions
	]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* combine all the invalid inputs *)
	invalidInputs = DeleteDuplicates[Join[
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInputs
	]];


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
		validNameTest,
		fixedOptionsWhenSweepingTest,
		sweepingOptionsWhenFixedTest,
		minOmegaAboveMaxTest,
		minDetectorAngleAboveMaxTest,
		fixedOptionsRequiredTogetherTest,
		sweepingOptionsRequiredTogetherTest,
		detectorTooCloseTest,
		aliquotTests,
		volumeTooLargeWarning,
		detectorAngleIncrementTooLargeTest,
		omegaAngleIncrementTooLargeTest,
		spottingVolumesTooLargeTest
	}], _EmeraldTest];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{instrument, confirm, template, cache, operator, upload, outputOption, subprotocolDescription, samplesInStorage, samplesOutStorage, samplePreparation} = Lookup[myOptions, {Instrument, Confirm, Template, Cache, Operator, Upload, Output, SubprotocolDescription, SamplesInStorageCondition, SamplesOutStorageCondition, PreparatoryUnitOperations}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* get the resolved ImageXRDPlate option; if it is still Automatic by now (i.e., not templated), set to False *)
	imageXRDPlate = Lookup[myOptions, ImageXRDPlate] /. {Automatic -> False};

	(* --- Do the final preparations --- *)

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = Flatten[{
		NumberOfReplicates -> numberOfReplicates,
		Current -> current,
		ExposureTime -> exposureTime,
		OmegaAngleIncrement -> resolvedOmegaAngleIncrement,
		DetectorDistance -> resolvedDetectorDistance,
		DetectorRotation -> resolvedDetectorRotation,
		MinOmegaAngle -> resolvedMinOmegaAngle,
		MaxOmegaAngle -> resolvedMaxOmegaAngle,
		FixedDetectorAngle -> resolvedFixedDetectorAngle,
		MinDetectorAngle -> resolvedMinDetectorAngle,
		MaxDetectorAngle -> resolvedMaxDetectorAngle,
		DetectorAngleIncrement -> resolvedDetectorAngleIncrement,
		SpottingVolume -> spottingVolume,
		ImageXRDPlate -> imageXRDPlate,
		Instrument -> instrument,
		PreparatoryUnitOperations -> samplePreparation,
		PreparatoryPrimitives->Lookup[myOptions,PreparatoryPrimitives],
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions,
		Confirm -> confirm,
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
		SamplesInStorageCondition -> samplesInStorage,
		SamplesOutStorageCondition -> samplesOutStorage
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
(*empiricalPowderXRDValues (private helper) *)


DefineOptions[empiricalPowderXRDValues,
	Options :> {
		{
			OptionName -> DetectorDistance,
			Default -> Automatic,
			Description -> "The distance from the powder sample to the detector.",
			ResolutionDescription -> "Automatically set from the MinOmegaAngle, MaxOmegaAngle, MinDetectorAngle and MaxDetectorAngle options.",
			AllowNull -> False,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[60 Millimeter, 209 Millimeter],
				Units :> {1, {Millimeter, {Millimeter, Centimeter}}}
			]
		},
		{
			OptionName -> MinOmegaAngle,
			Default -> Automatic,
			Description -> "The angle between the sample and the X-ray source in this run during the first scan of the sample's run.",
			ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to an angle based on the DetectorDistance, MaxOmegaAngle, and OmegaAngleIncrement options if DetectorRotation-> Fixed.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-21.24 AngularDegree, 51.99 AngularDegree],
				Units :> {1, {AngularDegree, {AngularDegree}}}
			]
		},
		{
			OptionName -> MaxOmegaAngle,
			Default -> Automatic,
			Description -> "The angle between the sample and the X-ray source in this run during the last scan of the sample's run.",
			ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to an angle based on the DetectorDistance, MinOmegaAngle, and OmegaAngleIncrement options if DetectorRotation-> Fixed.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-21.24 AngularDegree, 51.99 AngularDegree],
				Units :> {1, {AngularDegree, {AngularDegree}}}
			]
		},
		{
			OptionName -> FixedDetectorAngle,
			Default -> Automatic,
			Description -> "The angle between the X-ray source and the detector held constant through each data recording of a given sample.",
			ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Sweeping, or to 0 AngularDegree if DetectorRotation-> Fixed.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
				Units :> {1, {AngularDegree, {AngularDegree}}}
			]
		},
		{
			OptionName -> MinDetectorAngle,
			Default -> Automatic,
			Description -> "The initial angle between the X-ray source and the detector during the sweeping of detector angle during data recording of a given sample.",
			ResolutionDescription -> "Automatically set to Null if DetectorRotation -> Fixed, or to an angle based on the DetectorDistance option if DetectorRotation -> Sweeping.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
				Units :> {1, {AngularDegree, {AngularDegree}}}
			]
		},
		{
			OptionName -> MaxDetectorAngle,
			Default -> Automatic,
			Description -> "The final angle between the X-ray source and the detector during the sweeping of detector angle during data recording of a given sample.",
			ResolutionDescription -> "Automatically set to Null if DetectorRotation-> Fixed, or to an angle based on the DetectorDistance option if DetectorRotation-> Sweeping.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-50.49 AngularDegree, 81.24 AngularDegree],
				Units :> {1, {AngularDegree, {AngularDegree}}}
			]
		}
	}
];

(* list of rules correlating a given type with its empirical data *)
(* ordered pair where first entry is detector distance in Millimeter and second is value in AngularDegree *)
(* don't have the units in there because that will mess up the Fit function *)
empiricalPowderXRDRules = {
	MinOmegaAngle -> {
		{209, 17.24},
		{70, 16.24},
		{68, 12.49},
		{65, 10.99},
		{61, 7.49},
		{60, 3.99},
		{60, -4.99},
		{61, -8.49},
		{65, -11.99},
		{68, -13.49},
		{70, -17.24},
		{209, -17.24}
	},
	MaxOmegaAngle -> {
		{209, -17.24},
		{70, -16.24},
		{68, -12.49},
		{65, -10.99},
		{61, -7.49},
		{60, -3.99},
		{60, 4.99},
		{61, 8.49},
		{65, 11.99},
		{68, 13.49},
		{70, 17.24},
		{209, 17.24}
	},
	MinDetectorAngle -> {
		{209, 81.24},
		{100, 80.24},
		{90, 80.24},
		{80, 74.74},
		{70, 67.99},
		{60, 55.74},
		{60, -25.99},
		{70, -37.99},
		{80, -44.99},
		{90, -50.49},
		{100, -50.49},
		{209, -50.49}
	},
	MaxDetectorAngle -> {
		{209, -50.49},
		{100, -49.49},
		{90, -49.49},
		{80, -43.99},
		{70, -36.99},
		{60, -24.99},
		{60, 56.74},
		{70, 68.99},
		{80, 75.74},
		{90, 81.24},
		{100, 81.24},
		{209, 81.24}
	}
};

(* a couple of global variables for the absolute max/min of the omega angles *)
absoluteMinOmega = -21.24 * AngularDegree;
absoluteMaxOmega = 51.99 * AngularDegree;

(* private function used to calculate the values that the Rigaku Synergy-R instrument can handle *)
(* overload for giving the MinOmegaAngle/MaxOmegaAngle *)
empiricalPowderXRDValues[mySymbol : (MinOmegaAngle | MaxOmegaAngle), myOptions : OptionsPattern[empiricalPowderXRDValues]] := Module[
	{safeOps, detectorDistance, empiricalData, unitlessDetectorDistance, partitionedEmpiricalData, formulasPerSegment,
		piecewiseFunction, unitlessAngle, omegaAngleZeroTheta, fixedDetectorAngle, desiredAngleNoRounding},

	(* call safe options and get the detector distance *)
	safeOps = SafeOptions[empiricalPowderXRDValues, ToList[myOptions]];
	{detectorDistance, fixedDetectorAngle} = Lookup[safeOps, {DetectorDistance, FixedDetectorAngle}];

	(* get the detector distance without any units; Automatic resolves to the closest you can get *)
	unitlessDetectorDistance = If[MatchQ[detectorDistance, Automatic],
		60,
		Unitless[detectorDistance, Millimeter]
	];

	(* compile the empirically-derived data points of the observed detector distance and the value we want here *)
	empiricalData = mySymbol /. empiricalPowderXRDRules;

	(* partition the empirical data into pairs *)
	partitionedEmpiricalData = Partition[empiricalData, 2, 1];

	(* get the piecewise formulae between each of the empirical data points *)
	formulasPerSegment = Map[
		Fit[#, {1, x}, x]&,
		partitionedEmpiricalData
	];

	(* create a piecewise function with the fits we have obtained *)
	piecewiseFunction = Piecewise[
		Join[
			MapThread[
				{#1, #2[[1]] <= x < #2[[2]]}&,
				{formulasPerSegment, partitionedEmpiricalData[[All, All, 1]]}
			],
			{
				{Last[formulasPerSegment], x == partitionedEmpiricalData[[-1, 2, 1]]}
			}
		]
	];

	(* get the angle and return it; need to multiply by AngularDegrees because we are unitless right now *)
	unitlessAngle = piecewiseFunction /. x -> unitlessDetectorDistance;

	(* return the rounded angle to two decimal points *)
	(* note that this is ONLY for if theta is zero; going to handle the other cases below *)
	omegaAngleZeroTheta = Round[unitlessAngle, 0.01] * AngularDegree;

	(* the desired Omega angle is the zero-theta angle + the fixed detector angle (with the caveat that we might have to get within a limit) *)
	desiredAngleNoRounding = If[MatchQ[fixedDetectorAngle, UnitsP[AngularDegree]],
		omegaAngleZeroTheta + fixedDetectorAngle,
		omegaAngleZeroTheta
	];

	(* if desiredAngleNoRounding is outside the Max/Min values, pick those limits instead and return that *)
	Switch[{mySymbol, desiredAngleNoRounding},
		{MinOmegaAngle, LessP[absoluteMinOmega]}, absoluteMinOmega,
		{MinOmegaAngle, GreaterP[absoluteMaxOmega]}, absoluteMaxOmega - 0.24 * AngularDegree,
		{MinOmegaAngle, _}, desiredAngleNoRounding,
		{MaxOmegaAngle, LessP[absoluteMinOmega]}, absoluteMinOmega + 0.24 * AngularDegree,
		{MaxOmegaAngle, GreaterP[absoluteMaxOmega]}, absoluteMaxOmega,
		{MaxOmegaAngle, _}, desiredAngleNoRounding
	]

];


(* private function used to calculate the values that the Rigaku Synergy-R instrument can handle *)
(* overload for giving the MinDetectorAngle/MaxDetectorAngle *)
empiricalPowderXRDValues[mySymbol : (MinDetectorAngle | MaxDetectorAngle), myOptions : OptionsPattern[empiricalPowderXRDValues]] := Module[
	{safeOps, detectorDistance, empiricalData, unitlessDetectorDistance, partitionedEmpiricalData, formulasPerSegment,
		piecewiseFunction, unitlessAngle},

	(* call safe options and get the detector distance *)
	safeOps = SafeOptions[empiricalPowderXRDValues, ToList[myOptions]];
	detectorDistance = Lookup[safeOps, DetectorDistance];

	(* get the detector distance without any units; Automatic resolves to the closest you can get *)
	unitlessDetectorDistance = If[MatchQ[detectorDistance, Automatic],
		60,
		Unitless[detectorDistance, Millimeter]
	];

	(* compile the empirically-derived data points of the observed detector distance and the value we want here *)
	empiricalData = mySymbol /. empiricalPowderXRDRules;

	(* partition the empirical data into pairs *)
	partitionedEmpiricalData = Partition[empiricalData, 2, 1];

	(* get the piecewise formulae between each of the empirical data points *)
	formulasPerSegment = Map[
		Fit[#, {1, x}, x]&,
		partitionedEmpiricalData
	];

	(* create a piecewise function with the fits we have obtained *)
	piecewiseFunction = Piecewise[
		Join[
			MapThread[
				{#1, #2[[1]] <= x < #2[[2]]}&,
				{formulasPerSegment, partitionedEmpiricalData[[All, All, 1]]}
			],
			{
				{Last[formulasPerSegment], x == partitionedEmpiricalData[[-1, 2, 1]]}
			}
		]
	];

	(* get the angle and return it; need to multiply by AngularDegrees because we are unitless right now *)
	unitlessAngle = piecewiseFunction /. x -> unitlessDetectorDistance;

	(* return the rounded angle to two decimal points *)
	Round[unitlessAngle, 0.01] * AngularDegree

];

(* overload for giving the detector distance given all the information we have *)
empiricalPowderXRDValues[DetectorDistance, myOptions : OptionsPattern[empiricalPowderXRDValues]] := Module[
	{safeOps, minOmegaAngle, maxOmegaAngle, minDetectorAngle, maxDetectorAngle, unitlessMinOmegaAngle, unitlessMaxOmegaAngle,
		unitlessMinDetectorAngle, unitlessMaxDetectorAngle, minOmegaAngleData, maxOmegaAngleData, minDetectorAngleData,
		maxDetectorAngleData, fixedDetectorAngle, partitionedMinOmegaAngleData, partitionedMaxOmegaAngleData,
		partitionedMinDetectorAngleData, partitionedMaxDetectorAngleData, minOmegaAngleFormulae, maxOmegaAngleFormulae,
		minDetectorAngleFormulae, maxDetectorAngleFormulae, minOmegaAnglePiecewiseFunction, maxOmegaAnglePiecewiseFunction,
		minDetectorAnglePiecewiseFunction, maxDetectorAnglePiecewiseFunction, unitlessDDFromMinOmega, unitlessDDFromMaxOmega,
		unitlessDDFromMinDetector, unitlessDDFromMaxDetector, unitlessClosestDetectorDistance, minOmegaAngleValuesPreRounding,
		maxOmegaAngleValuesPreRounding, minOmegaAngleDataAdjusted, maxOmegaAngleDataAdjusted, unitlessAbsoluteMaxOmega,
		unitlessAbsoluteMinOmega},

	(* call safe options and pull out the values *)
	safeOps = SafeOptions[empiricalPowderXRDValues, ToList[myOptions]];
	{minOmegaAngle, maxOmegaAngle, minDetectorAngle, maxDetectorAngle, fixedDetectorAngle} = Lookup[safeOps, {MinOmegaAngle, MaxOmegaAngle, MinDetectorAngle, MaxDetectorAngle, FixedDetectorAngle}];

	(* get the omega angles without any units; If Automatic or Null, resolve to Null *)
	unitlessMinOmegaAngle = If[MatchQ[minOmegaAngle, Automatic | Null],
		Null,
		Unitless[minOmegaAngle, AngularDegree]
	];
	unitlessMaxOmegaAngle = If[MatchQ[maxOmegaAngle, Automatic | Null],
		Null,
		Unitless[maxOmegaAngle, AngularDegree]
	];

	(* get the detector angles without any units; if FixedDetectorAngle was specified, make that the min and max angles *)
	unitlessMinDetectorAngle = Which[
		MatchQ[minDetectorAngle, Automatic | Null] && MatchQ[fixedDetectorAngle, Automatic | Null], -50.49,
		MatchQ[minDetectorAngle, Automatic | Null] && MatchQ[fixedDetectorAngle, UnitsP[AngularDegree]], Unitless[fixedDetectorAngle, AngularDegree],
		True, Unitless[minDetectorAngle, AngularDegree]
	];
	unitlessMaxDetectorAngle = Which[
		MatchQ[maxDetectorAngle, Automatic | Null] && MatchQ[fixedDetectorAngle, Automatic | Null], 81.24,
		MatchQ[maxDetectorAngle, Automatic | Null] && MatchQ[fixedDetectorAngle, UnitsP[AngularDegree]], Unitless[fixedDetectorAngle, AngularDegree],
		True, Unitless[maxDetectorAngle, AngularDegree]
	];

	(* get the empirical data for the four different symbols; need to Reverse for the fit to work next *)
	{minOmegaAngleData, maxOmegaAngleData, minDetectorAngleData, maxDetectorAngleData} = Map[
		Reverse[#]&,
		Lookup[empiricalPowderXRDRules, {MinOmegaAngle, MaxOmegaAngle, MinDetectorAngle, MaxDetectorAngle}],
		{2}
	];

	(* Adjust the MinOmegaAngle and MaxOmegaAngle data to work with the MinDetectorAngle/MaxDetectorAngle *)
	(* only need to worry about this if not sweeping *)
	minOmegaAngleValuesPreRounding = If[MatchQ[fixedDetectorAngle, UnitsP[AngularDegree]],
		minOmegaAngleData[[All, 1]] + Unitless[fixedDetectorAngle, AngularDegree],
		minOmegaAngleData[[All, 1]]
	];
	maxOmegaAngleValuesPreRounding = If[MatchQ[fixedDetectorAngle, UnitsP[AngularDegree]],
		maxOmegaAngleData[[All, 1]] + Unitless[fixedDetectorAngle, AngularDegree],
		maxOmegaAngleData[[All, 1]]
	];

	(* get the unitless absolute min and max omegas *)
	unitlessAbsoluteMaxOmega = Unitless[absoluteMaxOmega, AngularDegree];
	unitlessAbsoluteMinOmega = Unitless[absoluteMinOmega, AngularDegree];

	(* if the min or max omega angles exceed the absolute maxes, then just do those *)
	minOmegaAngleDataAdjusted = MapThread[
		{
			Which[
				#2 > unitlessAbsoluteMaxOmega, (unitlessAbsoluteMaxOmega - 0.24),
				#2 < unitlessAbsoluteMinOmega, unitlessAbsoluteMinOmega,
				True, #2
			],
			#1[[2]]
		}&,
		{minOmegaAngleData, minOmegaAngleValuesPreRounding}
	];
	maxOmegaAngleDataAdjusted = MapThread[
		{
			Which[
				#2 > unitlessAbsoluteMaxOmega, unitlessAbsoluteMaxOmega,
				#2 < unitlessAbsoluteMinOmega, (unitlessAbsoluteMinOmega + 0.24),
				True, #2
			],
			#1[[2]]
		}&,
		{maxOmegaAngleData, maxOmegaAngleValuesPreRounding}
	];

	(* partition the data into pairs *)
	partitionedMinOmegaAngleData = Partition[minOmegaAngleDataAdjusted, 2, 1];
	partitionedMaxOmegaAngleData = Partition[maxOmegaAngleDataAdjusted, 2, 1];
	partitionedMinDetectorAngleData = Partition[minDetectorAngleData, 2, 1];
	partitionedMaxDetectorAngleData = Partition[maxDetectorAngleData, 2, 1];

	(* get the piecewise formulae between each set of empirical data points *)
	minOmegaAngleFormulae = Map[
		Fit[#, {1, y}, y]&,
		partitionedMinOmegaAngleData
	];
	maxOmegaAngleFormulae = Map[
		Fit[#, {1, y}, y]&,
		partitionedMaxOmegaAngleData
	];
	minDetectorAngleFormulae = Map[
		Fit[#, {1, y}, y]&,
		partitionedMinDetectorAngleData
	];
	maxDetectorAngleFormulae = Map[
		Fit[#, {1, y}, y]&,
		partitionedMaxDetectorAngleData
	];

	(* create the piecewise function with the fits that we have obtained *)
	minOmegaAnglePiecewiseFunction = Piecewise[
		MapThread[
			(* need to have >= here because we're in the negative here *)
			{#1, #2[[1]] >= y >= #2[[2]]}&,
			{minOmegaAngleFormulae, partitionedMinOmegaAngleData[[All, All, 1]]}
		],
		(* otherwise the distance is just going to be the closest we can be *)
		60.
	];
	maxOmegaAnglePiecewiseFunction = Piecewise[
		MapThread[
			(* need to have <= here because we're in positive here *)
			{#1, #2[[1]] <= y <= #2[[2]]}&,
			{maxOmegaAngleFormulae, partitionedMaxOmegaAngleData[[All, All, 1]]}
		],
		(* otherwise the distance is just going to be the closest we can be *)
		60.
	];
	minDetectorAnglePiecewiseFunction = Piecewise[
		MapThread[
			(* need to have >= here because we're in the negative here *)
			{#1, #2[[1]] >= y >= #2[[2]]}&,
			{minDetectorAngleFormulae, partitionedMinDetectorAngleData[[All, All, 1]]}
		],
		(* otherwise the distance is just going to be the closest we can be *)
		60.
	];
	maxDetectorAnglePiecewiseFunction = Piecewise[
		MapThread[
			(* need to have <= here because we're in positive here *)
			{#1, #2[[1]] <= y <= #2[[2]]}&,
			{maxDetectorAngleFormulae, partitionedMaxDetectorAngleData[[All, All, 1]]}
		],
		(* otherwise the distance is just going to be the closest we can be *)
		60.
	];

	(* get the detector distance according to the two metrics *)
	(* if the angle we have is Null though ignore it *)
	unitlessDDFromMinOmega = If[NullQ[unitlessMinOmegaAngle],
		Nothing,
		minOmegaAnglePiecewiseFunction /. y -> unitlessMinOmegaAngle
	];
	unitlessDDFromMaxOmega = If[NullQ[unitlessMaxOmegaAngle],
		Nothing,
		maxOmegaAnglePiecewiseFunction /. y -> unitlessMaxOmegaAngle
	];
	unitlessDDFromMinDetector = If[NullQ[unitlessMinDetectorAngle],
		Nothing,
		minDetectorAnglePiecewiseFunction /. y -> unitlessMinDetectorAngle
	];
	unitlessDDFromMaxDetector = If[NullQ[unitlessMaxDetectorAngle],
		Nothing,
		maxDetectorAnglePiecewiseFunction /. y -> unitlessMaxDetectorAngle
	];

	(* get the closest the detector can be within the constraints of all four measurements here *)
	unitlessClosestDetectorDistance = Max[{unitlessDDFromMinOmega, unitlessDDFromMaxOmega, unitlessDDFromMinDetector, unitlessDDFromMaxDetector}];

	(* return the rounded detector distance *)
	Round[unitlessClosestDetectorDistance] * Millimeter

];



(* ::Subsubsection::Closed:: *)
(* powderXRDResourcePackets *)


DefineOptions[powderXRDResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

(* create the protocol packet with resource blobs included *)
powderXRDResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, myOptions:OptionsPattern[]] := Module[
	{expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, numReplicates, expandedSamplesWithNumReplicates, diffractometerTime, diffractometerResource,
		expandForNumReplicates, expandedExposureTime, expandedOmegaAngleIncrement, expandedDetectorDistance,
		expandedDetectorRotation, expandedMinOmegaAngle, expandedMaxOmegaAngle, expandedFixedDetectorAngle,
		expandedMinDetectorAngle, expandedMaxDetectorAngle, expandedDetectorAngleIncrement, omegaAngles, detectorAngles,
		protocolPacket, samplePackets, containersIn, sampleHandler, expandedAliquotVolume, sampleVolumes,
		pairedSamplesInAndVolumes, sampleVolumeRules, sampleResourceReplaceRules, samplesInResources, sharedFieldPacket,
		finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
		xrdParameters, plateID, crystallizationPlate, readingDiffractionTimeEstimate, expandedSamplesInStorage,
		expandedSamplesOutStorage, expandedSpottingVolume, safeOps},

	(* get the safe options for this function *)
	safeOps = SafeOptions[powderXRDResourcePackets, ToList[myOptions]];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* get the inherited cache *)
	inheritedCache = Lookup[safeOps, Cache];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentPowderXRD, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentPowderXRD,
		RemoveHiddenOptions[ExperimentPowderXRD, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* --- Make our one big Download call --- *)

	(* make our one big (but not really) Download call *)
	samplePackets = Download[mySamples, Packet[Container, Volume], Cache -> inheritedCache, Date -> Now];

	(* --- Make all the resources needed in the experiment --- *)

	(* pull out the number of replicates; make sure all Nulls become 1 *)
	numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* expand the samples according to the number of replicates *)
	(* need to Download Object because we will be merging later *)
	expandedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		samplePackets
	]];

	(* don't make the resource for the sample handler since it just lives on the instrument and we can figure out what specific one we have later *)
	sampleHandler = Model[Container, Rack, "XtalCheck"];

	(* make a resource for the crystallization plate *)
	crystallizationPlate = Resource[Sample -> Model[Container, Plate, "In Situ-1 Crystallization Plate"]];

	(* compute the length of time the diffractometer will take to run *)
	(* 1 Hour is for ramping up the instrument; 10 minutes is getting the experiment ready; 10 minutes per sample is how much it takes for each sample to run; 30 minutes is to tear down the instrument *)
	diffractometerTime = 1 * Hour + 10 * Minute + (Length[expandedSamplesWithNumReplicates] * 10 * Minute) + 30 * Minute;

	(* make the instrument resource *)
	diffractometerResource = Resource[Instrument -> Lookup[resolvedOptionsNoHidden, Instrument], Time -> diffractometerTime];

	(* pull out the AliquotAmount option *)
	expandedAliquotVolume = Lookup[expandedResolvedOptions, AliquotAmount];

	(* get the sample volume; if we're aliquoting, use that amount; otherwise it's going to be 20 Microliter since it is too small to pipette less anyway*)
	sampleVolumes = MapThread[
		If[VolumeQ[#1],
			#1,
			20 * Microliter
		]&,
		{expandedAliquotVolume, samplePackets}
	];

	(* pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		#1 -> #2&,
		{samplePackets, sampleVolumes}
	];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> Lookup[sample, Object], Name -> ToString[Unique[]], Amount -> volume * numReplicates],
				sample -> Resource[Sample -> Lookup[sample, Object], Name -> ToString[Unique[]]]
			]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* --- Generate the protocol packet --- *)

	(* we need to expand lots of the options to include number of replicates; making a function that just does this *)
	(* map over the provided option names; for each one, expand the value for it by the number of replicates*)
	expandForNumReplicates[myExpandedOptions : {__Rule}, myOptionNames : {__Symbol}, myNumberOfReplicates_Integer] := Module[
		{},
		Map[
			Function[{optionName},
				Flatten[Map[
					ConstantArray[#, myNumberOfReplicates]&,
					Lookup[myExpandedOptions, optionName]
				]]
			],
			myOptionNames
		]

	];

	(* expand all the options to account for number of replicates *)
	{
		expandedExposureTime,
		expandedOmegaAngleIncrement,
		expandedDetectorDistance,
		expandedDetectorRotation,
		expandedMinOmegaAngle,
		expandedMaxOmegaAngle,
		expandedFixedDetectorAngle,
		expandedMinDetectorAngle,
		expandedMaxDetectorAngle,
		expandedDetectorAngleIncrement,
		expandedSpottingVolume,
		expandedSamplesInStorage,
		expandedSamplesOutStorage
	} = expandForNumReplicates[
		expandedResolvedOptions,
		{
			ExposureTime,
			OmegaAngleIncrement,
			DetectorDistance,
			DetectorRotation,
			MinOmegaAngle,
			MaxOmegaAngle,
			FixedDetectorAngle,
			MinDetectorAngle,
			MaxDetectorAngle,
			DetectorAngleIncrement,
			SpottingVolume,
			SamplesInStorageCondition,
			SamplesOutStorageCondition
		},
		numReplicates
	];

	(* get the omega angles as an ordered pair for the OmegaAngles field *)
	omegaAngles = Transpose[{expandedMinOmegaAngle, expandedMaxOmegaAngle}];

	(* if we are fixed then the Min and Max DetectorAngles are the same (the FixedDetectorAngle) and if we are sweeping, they are different*)
	detectorAngles = MapThread[
		Function[{detectorRotation, minAngle, maxAngle, fixedAngle},
			If[MatchQ[detectorRotation, Fixed],
				{fixedAngle, fixedAngle},
				{minAngle, maxAngle}
			]
		],
		{expandedDetectorRotation, expandedMinDetectorAngle, expandedMaxDetectorAngle, expandedFixedDetectorAngle}
	];

	(* get the ContainersIn with no Duplicates *)
	containersIn = DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]];

	(* populate the named single that "collapses" things for the procedure *)
	xrdParameters = <|
		ExposureTime -> If[Length[DeleteDuplicates[expandedExposureTime]] == 1,
			First[expandedExposureTime],
			Null
		],
		DetectorDistance -> If[Length[DeleteDuplicates[expandedDetectorDistance]] == 1,
			First[expandedDetectorDistance],
			Null
		],
		OmegaAngleIncrement -> If[Length[DeleteDuplicates[expandedOmegaAngleIncrement]] == 1,
			First[expandedOmegaAngleIncrement],
			Null
		],
		DetectorRotation -> If[Length[DeleteDuplicates[expandedDetectorRotation]] == 1,
			First[expandedDetectorRotation],
			Null
		],
		MinOmegaAngle -> If[Length[DeleteDuplicates[expandedMinOmegaAngle]] == 1,
			First[expandedMinOmegaAngle],
			Null
		],
		MaxOmegaAngle -> If[Length[DeleteDuplicates[expandedMaxOmegaAngle]] == 1,
			First[expandedMaxOmegaAngle],
			Null
		],
		(* these two are special because it includes MinDetectorAngle/MaxDetectorAngle AND FixedDetectorAngle *)
		MinDetectorAngle -> Which[
			(* if MinDetectorAngle is not Null and there's only one thing in it, then use that *)
			Length[DeleteDuplicates[expandedMinDetectorAngle]] == 1 && Not[NullQ[expandedMinDetectorAngle]], First[expandedMinDetectorAngle],
			(* otherwise, if FixedDetectorAngle is not Null and there's only one thing in it, use that *)
			Length[DeleteDuplicates[expandedFixedDetectorAngle]] == 1 && Not[NullQ[expandedFixedDetectorAngle]], First[expandedFixedDetectorAngle],
			(* double otherwise, resolve to Null *)
			True, Null
		],
		MaxDetectorAngle -> Which[
			(* if MinDetectorAngle is not Null and there's only one thing in it, then use that *)
			Length[DeleteDuplicates[expandedMaxDetectorAngle]] == 1 && Not[NullQ[expandedMaxDetectorAngle]], First[expandedMaxDetectorAngle],
			(* otherwise, if FixedDetectorAngle is not Null and there's only one thing in it, use that *)
			Length[DeleteDuplicates[expandedFixedDetectorAngle]] == 1 && Not[NullQ[expandedFixedDetectorAngle]], First[expandedFixedDetectorAngle],
			(* double otherwise, resolve to Null *)
			True, Null
		],
		DetectorAngleIncrement -> If[Length[DeleteDuplicates[expandedDetectorAngleIncrement]] == 1,
			First[expandedDetectorAngleIncrement],
			Null
		]
	|>;

	(* generate the ID for the plate *)
	(* the Rigaku XRD is weird in that it 1.) can't take ANY non-alphanumeric character (which precludes using ObjectToFilePath), 2.) has a character limit of 15, and 3.) Can't lead with a number.  So that's super dumb.  Best I can do to guarantee uniqueness is use CreateUUID starting with a letter and without the dashes and only 15 characters *)
	plateID = StringTake[
		StringDelete[
			CreateUUID[RandomChoice[Alphabet[]]],
			"-"
		],
		15
	];

	(* calculate the length of time of the sample reading part *)
	(* adding 45 minutes for the setup overhead *)
	readingDiffractionTimeEstimate = Total[Flatten[MapThread[
		Function[{exposureTime, detectorRotation, detectorAngleIncrement, detectorAngleMinMax},
			(* if fixed, then only have 4 scans really *)
			(* if sweeping, it's more complicated *)
			If[MatchQ[detectorRotation, Fixed],
				(* adding 10 seconds because the 4 scans don't go IMMEDIATELY back to back to back *)
				4 * exposureTime + 10 * Second,
				Quotient[detectorAngleMinMax[[2]] - detectorAngleMinMax[[1]], detectorAngleIncrement] * 4 * exposureTime
			]
		],
		{expandedExposureTime, expandedDetectorRotation, expandedDetectorAngleIncrement, detectorAngles}
	]]] + 45 * Minute;

	(* make the protocol packet including resources *)
	protocolPacket = <|
		Object -> CreateID[Object[Protocol, PowderXRD]],
		Type -> Object[Protocol, PowderXRD],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> CollapseIndexMatchedOptions[ExperimentPowderXRD, myResolvedOptions, Messages -> False, Ignore -> myUnresolvedOptions],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],

		(* resource (and resource-adjacent) fields *)
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ containersIn,
		SampleHandler -> Link[sampleHandler],
		CrystallizationPlate -> Link[crystallizationPlate],
		Instrument -> Link[diffractometerResource],

		(* populate checkpoints with reasonable time estimates TODO probably make these better because they're rather rough right now *)
		Replace[Checkpoints] -> {
			{"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
			{"Preparing Samples", 1 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
			{"Instrument Warm-Up", 1 * Hour, "X-ray diffractometer power is ramped up.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 * Hour]]},
			{"Reading Diffraction", readingDiffractionTimeEstimate, "Sample X-ray diffraction is measured.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 * Hour]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 * Hour]]},
			{"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 * Minute]]}
		},

		(* assorted other option-controlled fields *)
		NumberOfReplicates -> numReplicates,
		Current -> Lookup[myResolvedOptions, Current],
		Name -> Lookup[myResolvedOptions, Name],
		Replace[SamplesInStorage] -> expandedSamplesInStorage,
		Replace[SamplesOutStorage] -> expandedSamplesOutStorage,
		Replace[ExposureTimes] -> expandedExposureTime,
		Replace[DetectorDistances] -> expandedDetectorDistance,
		Replace[OmegaAngleIncrements] -> expandedOmegaAngleIncrement,
		Replace[DetectorRotations] -> expandedDetectorRotation,
		Replace[OmegaAngles] -> omegaAngles,
		Replace[DetectorAngles] -> detectorAngles,
		Replace[DetectorAngleIncrements] -> expandedDetectorAngleIncrement,
		ImageXRDPlate -> Lookup[myResolvedOptions, ImageXRDPlate],
		Replace[SpottingVolumes] -> expandedSpottingVolume,
		Operator -> Link[Lookup[myResolvedOptions, Operator]],
		SubprotocolDescription -> Lookup[myResolvedOptions, SubprotocolDescription],
		XRDParameters -> xrdParameters,
		PlateFileName -> plateID
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> inheritedCache], Null}
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
(*ValidExperimentPowderXRDQ*)


DefineOptions[ValidExperimentPowderXRDQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentPowderXRD}
];

(* --- Overloads --- *)
ValidExperimentPowderXRDQ[mySample : (_String | ObjectP[Object[Sample]]), myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := ValidExperimentPowderXRDQ[{mySample}, myOptions];

ValidExperimentPowderXRDQ[myContainer : (_String | ObjectP[Object[Container]]), myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := ValidExperimentPowderXRDQ[{myContainer}, myOptions];

ValidExperimentPowderXRDQ[myContainers : {(_String | ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := Module[
	{listedOptions, preparedOptions, xrdTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentPowderXRD *)
	xrdTests = ExperimentPowderXRD[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[xrdTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[myContainers, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[myContainers, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, xrdTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentPowderXRDQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentPowderXRDQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentPowderXRDQ"]

];

(* --- Core Function --- *)
ValidExperimentPowderXRDQ[mySamples : {(_String | ObjectP[Object[Sample]])..}, myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := Module[
	{listedOptions, noOutputOptions, preparedOptions, xrdTests, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentPowderXRD *)
	xrdTests = ExperimentPowderXRD[mySamples, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings, testResults},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[DeleteCases[mySamples, _String], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{DeleteCases[mySamples, _String], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{xrdTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentPowderXRDQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentPowderXRDQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentPowderXRDQ"]

];



(* ::Subsection::Closed:: *)
(*ExperimentPowderXRDOptions*)


DefineOptions[ExperimentPowderXRDOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentPowderXRD}
];

(* --- Overloads --- *)
ExperimentPowderXRDOptions[mySample : _String | ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := ExperimentPowderXRDOptions[{mySample}, myOptions];

ExperimentPowderXRDOptions[myContainer : _String | ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := ExperimentPowderXRDOptions[{myContainer}, myOptions];

ExperimentPowderXRDOptions[myContainers : {(_String | ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentPowderXRD *)
	options = ExperimentPowderXRD[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentPowderXRD],
		options
	]

];


(* --- Core Function --- *)
ExperimentPowderXRDOptions[mySamples : {(_String | ObjectP[Object[Sample]])..}, myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentAliquotNew *)
	options = ExperimentPowderXRD[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentPowderXRD],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentPowderXRDPreview*)


DefineOptions[ExperimentPowderXRDPreview,
	SharedOptions :> {ExperimentPowderXRD}
];

(* --- Overloads --- *)
ExperimentPowderXRDPreview[mySample : (_String | ObjectP[Object[Sample]]), myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := ExperimentPowderXRDPreview[{mySample}, myOptions];

ExperimentPowderXRDPreview[myContainer : (_String | ObjectP[Object[Container]]), myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := ExperimentPowderXRDPreview[{myContainer}, myOptions];

ExperimentPowderXRDPreview[myContainers : {(_String | ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentPowderXRD *)
	ExperimentPowderXRD[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* --- Core Function --- *)
ExperimentPowderXRDPreview[mySamples : {(_String | ObjectP[Object[Sample]])..}, myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentPowderXRD *)
	ExperimentPowderXRD[mySamples, Append[noOutputOptions, Output -> Preview]]
];
