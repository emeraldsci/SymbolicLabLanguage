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
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Diffractometer, "XtaLAB Synergy-R"],
			Description -> "The diffractometer used for this experiment.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Diffractometer], Object[Instrument, Diffractometer]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"X-Ray Crystallography",
						"X-Ray Diffractometers"
					}
				}
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ExposureTime,
				Default -> 0.2 * Second,
				Description -> "The length of time the powder sample is exposed to the X-rays for each scan.",
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
					Pattern :> RangeP[61 Millimeter, 209 Millimeter],
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
					Pattern :> RangeP[-50.49 AngularDegree, 81.25 AngularDegree],
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
					Pattern :> RangeP[-50.49 AngularDegree, 81.25 AngularDegree],
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
					Pattern :> RangeP[-50.49 AngularDegree, 81.25 AngularDegree],
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
					Pattern :> RangeP[-21.24 AngularDegree, 51.99 AngularDegree],
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
					Pattern :> RangeP[-21.24 AngularDegree, 51.99 AngularDegree],
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
				Default -> Automatic,
				Description -> "The amount of sample to be spotted on each well of the crystallization plate.",
				ResolutionDescription -> "Automatically set to 3 Microliter for TransferType -> Slurry.",
				AllowNull -> True,
				Category -> "Protocol",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 5 Microliter],
					Units :> {1, {Microliter, {Microliter}}}
				]
			}
		],
		{
			OptionName -> CrystallizationPlatePreparation,
			Default -> Automatic,
			Description -> "Indicates if the sample loading onto the crystallization plate should occur manually or on a robotic liquid handler.",
			ResolutionDescription -> "Automatically set to Robotic if TransferType is Slurry. Otherwise, automatically set to Manual.",
			AllowNull -> False,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PreparationMethodP
			]
		},
		{
			OptionName -> TransferType,
			Default -> Automatic,
			Description -> "How samples are to be transferred to the CrystallizationPlate via Slurry or MassTransfer. The model of crystallization plate used is determined by this option.",
			ResolutionDescription -> "Automatically set to Slurry if Preparation is Robotic. If Preparation is Manual, automatically set to Slurry for liquid samples or MassTransfer for solid samples.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Slurry, MassTransfer]
			]
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat X-ray diffraction reading on each provided sample.  Specifying this option will result in the same sample being aliquoted into multiple wells in the X-ray plate.",
			AllowNull -> True,
			Category -> "Protocol",
			Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[2, 1]]
		},
		{
			OptionName -> Current,
			Default -> 30 * Milliampere,
			Description -> "The current used to generate the X-rays in this experiment.",
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
			Description -> "Indicates if the crystallization plate should be imaged after preparing of the plate but before loading onto the diffractometer.",
			ResolutionDescription -> "Automatically set to the template value, or False if no template exists.",
			AllowNull -> False,
			Category -> "Protocol",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		NonBiologyFuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOption,
		SamplesOutStorageOption,
		SimulationOption,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 25 Microliter."
			}
		]
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
Error::PowderXRDTooManySamples = "The (number of input samples * NumberOfReplicates) cannot fit onto the instrument in a single TransferType -> `1` protocol.  Please select fewer than `2` samples to run this protocol.";
Warning::PowderXRDHighVolume = "The volume of input samples `1` (or their resolved AssayVolume) (`2`) is above 100 microliters.  If using a sample that is a solid suspended in a solvent, we recommend using volumes at or below 100 microliters to ensure the suspension is adequately concentrated such that sufficient solid may be transferred to the XRD plate.";
Error::DetectorAngleIncrementTooLarge = "The DetectorAngleIncrement option is greater than the difference between MinDetectorAngle and MaxDetectorAngle for the following sample(s): `1`.  This may occur if MinDetectorAngle and MaxDetectorAngle are too close together; the minimum value for DetectorAngleIncrement is 0.1 AngularDegree.  Please adjust the values for these options.";
Error::OmegaAngleIncrementTooLarge = "The OmegaAngleIncrement option is greater than the difference between MinOmegaAngle and MaxOmegaAngle for the following sample(s): `1`.  This may occur if MinOmegaAngle and MaxOmegaAngle are too close together; the minimum value for OmegaAngleIncrement is 0.1 AngularDegree.  Please adjust the values for these options.";
Error::InvalidSpottingVolumeForTransferType = "When TransferType -> `1`, SpottingVolume must be `2`.";
Error::SpottingVolumeTooLarge = "The SpottingVolume option is greater than either the volume or the AssayVolume (if aliquoting) for the following sample(s): `1`.  Please use a smaller SpottingVolume or a larger AssayVolume for these sample(s).";
Error::CrystallizationPlatePreparationTransferTypeMismatch = "Robotic solid transfers are unsupported. Please specify TransferType -> MassTransfer with CrystallizationPlatePreparation -> Manual, TransferType -> Slurry with CrystallizationPlatePreparation -> Robotic, or allow either option to be resolved automatically.";
Error::InvalidSamplesForTransferType = "The inputs `1` at indices `2` will be in the wrong state (following any indicated sample preparation) for a `3` TransferType. If TransferType is MassTransfer, only solid samples may be used; for Slurry, only liquid-containing samples may be used. The function does not support a mixture of solid and liquid-containing samples as inputs.";
Error::UnableToResolveTransferType = "The inputs at indices `1` are solids and at indices `2` are liquid-containing (following any indicated sample preparation). The function does not support a mixture of solid and liquid-containing samples as inputs.";
Error::NoPossibleDetectorDistanceForAngles = "The following sample(s) `1` have `2` options unable to be reached by the goniometer at any DetectorDistance. Adjust the omega and theta angles such that they are nearer in value or allow the options to resolve automatically.";
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
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, canaryBranch, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions, sampleObjectDownloadFields, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, finalizedPacket, resourcePacketTests, allTests, validQ,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, sampleModelDownloadFields,
		sampleContainerFields, sampleContainerModelFields, previewRule, optionsRule, testsRule, resultRule,
		validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOptionsNamed,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

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
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentPowderXRD,
			listedSamples,
			ToList[listedOptions]
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
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentPowderXRD, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed,Simulation -> updatedSimulation];

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
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentPowderXRD, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1,  Output -> {Result, Tests}],
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
	sampleObjectDownloadFields = Packet[LiquidHandlerIncompatible, Tablet, SolidUnitWeight,TransportTemperature, SamplePreparationCacheFields[Object[Sample], Format->Sequence]];
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
		(*Cache -> FlattenCachePackets[{inheritedCache}],*)
		Simulation-> updatedSimulation,
		Date -> Now
	], Download::FieldDoesntExist];

	(* combine the cache we inherited with what we Downloaded  *)
	newCache = FlattenCachePackets[{inheritedCache, allDownloadValues}];

	(* --- Resolve the options! --- *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolvePowderXRDOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache,Simulation->updatedSimulation],
			{resolvePowderXRDOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache,Simulation->updatedSimulation], Null}
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
		powderXRDResourcePackets[Download[mySamplesWithPreparedSamples, Object, Cache -> newCache], unresolvedOptions, resolvedOptions, Output -> {Result, Tests}, Cache -> newCache,Simulation->updatedSimulation],
		{powderXRDResourcePackets[Download[mySamplesWithPreparedSamples, Object, Cache -> newCache], unresolvedOptions, resolvedOptions, Output -> Result, Cache -> newCache,Simulation->updatedSimulation], Null}
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
			CanaryBranch -> canaryBranch,
			Upload -> upload,
			FastTrack -> fastTrack,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage -> {Object[Protocol, PowderXRD]},
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(*
	Single container with no second input:
		- Takes a single container and passes it to the core container overload
*)

ExperimentPowderXRD[myContainer : (ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String), myOptions : OptionsPattern[ExperimentPowderXRD]] := ExperimentPowderXRD[{myContainer}, myOptions];

(*
	Multiple containers with no second input:
		- expands the Containers into their contents and passes to the core function
*)

ExperimentPowderXRD[myContainers : {(ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String)..}, myOptions : OptionsPattern[ExperimentPowderXRD]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,containerToSampleOutput,
		containerToSampleTests, inputSamples, samplesOptions, aliquotResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
	 containerToSampleSimulation,updatedSimulation},

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
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentPowderXRD,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 25 Microliter
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
	containerToSampleResult= If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentPowderXRD,
			mySamplesWithPreparedSamples,
			safeOptions,
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
				ExperimentPowderXRD,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult, $Failed],
		Return[$Failed]
	];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions} = containerToSampleOutput;

	(* call ExperimentPowderXRD and get all its outputs *)
	aliquotResults = ExperimentPowderXRD[inputSamples, ReplaceRule[samplesOptions, Simulation->containerToSampleSimulation]];

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
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* private function to resolve all the options *)
resolvePowderXRDOptions[mySamples : {ObjectP[Object[Sample]]..}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolvePowderXRDOptions]] := Module[
	{outputSpecification, output, gatherTests, messages, inheritedCache,simulation, samplePrepOptions, xrdOptions, simulatedSamples,
		resolvedSamplePrepOptions,  updatedSimulation,samplePrepTests, exposureTime, current, numberOfReplicates, name,
		parentProtocol, samplePackets, sampleModelPackets, fastTrack, combinedCache, sampleStates, invalidStateInputs,
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
		confirm, canaryBranch, template, cache, operator, upload, outputOption, email, subprotocolDescription, resolvedOptions, testsRule,
		resultRule, numSamples, tooManySamplesQ, tooManySamplesInputs, tooManySamplesTest, imageXRDPlate,
		resolvedSpottingVolumes, resolvedAssayVolume, sampleVolume, volumesTooLargeBool, samplesWithVolumesTooLarge, volumesTooLarge,
		volumeTooLargeWarning, resolvedPostProcessingOptions, requiredAliquotAmount, aliquotWarningMessage,
		omegaAngleIncrementTooLargeErrors, spottingVolumePerSample, resolvedTransferType, resolvedCrystallizationPlatePreparation,
		spottingVolumesTooLargeBool, spottingVolumesTooLargeOptions, spottingVolumesTooLargeTest, transferTypePreparationMismatchQ,
		transferTypePreparationMismatchOptions, transferTypePreparationMismatchTest, transferTypeSampleConflictQ,
		samplesIncompatibleWithTransferTypeOptions, samplesIncompatibleWithTransferTypeTests, unableToResolveTransferTypeOption,
		unableToResolveTransferTypeOptionTest, unableToResolveTransferTypeBoole, allowedNumberOfSamples, invalidSpottingVolumeForTransferTypeQ,
		invalidSpottingVolumeForTransferType, invalidSpottingVolumeForTransferTypeTest, simulatedSamplePackets, noDetectorDistanceForAnglesErrors,
		noDetectorDistanceInvalidOptionsList, noDetectorDistanceOptions, noDetectorDistanceTest
	},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache and Simulation option *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* get the sample and model packets *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[mySamples, Object];
	sampleModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Model], Object];

	(* --- split out and resolve the sample prep options --- *)

	(* split out the options *)
	{samplePrepOptions, xrdOptions} = splitPrepOptions[myOptions];

	(* resolve the sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentPowderXRD, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation->simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentPowderXRD, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation->simulation, Output -> Result], {}}
	];

	(* merge caches together *)
	combinedCache = FlattenCachePackets[{inheritedCache}];

	simulatedSamplePackets = Download[simulatedSamples,Simulation->updatedSimulation];

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
				Test["Provided samples " <> ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[samplePacketsToCheckIfDiscarded],
				Nothing,
				Test["Provided input samples " <> ObjectToString[Download[Complement[samplePacketsToCheckIfDiscarded, discardedInvalidInputs], Object], Simulation -> updatedSimulation] <> " are not discarded:", True, True]
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

	(* Determine the State of our samples *)
	sampleStates = Lookup[simulatedSamplePackets, State];

	(* Set error checking variable to a boole, assuming no error. *)
	unableToResolveTransferTypeBoole = False;

	(* --- Resolve the plate preparation --- *)
	resolvedTransferType = Which[
		(* Trivial case: *)
		MatchQ[Lookup[roundedXRDOptions, TransferType], Except[Automatic]],
		Lookup[roundedXRDOptions, TransferType],
		(* If Robotic was specified, resolve to Slurry. *)
		MatchQ[Lookup[roundedXRDOptions, CrystallizationPlatePreparation], Robotic],
		Slurry,
		(* For Automatic/Manual preparation and solid samples resolve to MassTransfer. *)
		MatchQ[sampleStates, {Solid..}],
		MassTransfer,
		(* For Automatic/Manual preparation and non solid samples resolve to Slurry. *)
		MatchQ[sampleStates, {Liquid..}],
		Slurry,
		True,
		unableToResolveTransferTypeBoole = True;
		Slurry
	];

	(* get the number of samples *)
	numSamples = If[NullQ[numberOfReplicates],
		Length[mySamples],
		Length[mySamples] * numberOfReplicates
	];

	(* If we are *)
	unableToResolveTransferTypeOption = If[TrueQ[unableToResolveTransferTypeBoole] && messages,
		Message[Error::UnableToResolveTransferType, Flatten[Position[sampleStates, Solid]], Flatten[Position[sampleStates, Liquid]]];
		{TransferType},
		{}
	];

	unableToResolveTransferTypeOptionTest = If[gatherTests,
		Test["The transfer type option was specified or resolvable based on the state of the samples (following any sample preparation):",
			!TrueQ[unableToResolveTransferTypeBoole],
			True
		],
		Nothing
	];

	(* if we have more than 92 or 96 samples, throw an error *)
	allowedNumberOfSamples = If[MatchQ[resolvedTransferType, MassTransfer], 92, 96];
	tooManySamplesQ = numSamples > allowedNumberOfSamples;

	(* if there are more than 96 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	tooManySamplesInputs = Which[
		TrueQ[tooManySamplesQ] && messages,
		(
			Message[Error::PowderXRDTooManySamples, resolvedTransferType, allowedNumberOfSamples];
			Download[mySamples, Object]
		),
		TrueQ[tooManySamplesQ], Download[mySamples, Object],
		True, {}
	];

	(* if we are gathering tests, create a test indicating whether we have too many samples or not *)
	tooManySamplesTest = If[gatherTests,
		Test["The number of samples provided times NumberOfReplicates is not greater than 92 for TransferType -> MassTransfer or 96 for SlurryTransfer:",
			tooManySamplesQ,
			False
		],
		Nothing
	];

	resolvedCrystallizationPlatePreparation = Which[
		(* Trivial case: *)
		MatchQ[Lookup[roundedXRDOptions, CrystallizationPlatePreparation], Except[Automatic]],
		Lookup[roundedXRDOptions, CrystallizationPlatePreparation],
		(* If a slurry transfer was selected or resolved, default to Robotic. *)
		MatchQ[resolvedTransferType, Slurry],
		Robotic,
		(* If a mass transfer was selected or resolved, default to Manual. *)
		MatchQ[resolvedTransferType, MassTransfer],
		Manual
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
		resolvedSpottingVolumes,
		fixedOptionsWhenSweepingErrors,
		sweepingOptionsWhenFixedErrors,
		minOmegaAboveMaxErrors,
		minDetectorAngleAboveMaxErrors,
		fixedOptionsRequiredTogetherErrors,
		sweepingOptionsRequiredTogetherErrors,
		detectorTooCloseErrors,
		detectorAngleIncrementTooLargeErrors,
		omegaAngleIncrementTooLargeErrors,
		noDetectorDistanceForAnglesErrors,
		noDetectorDistanceInvalidOptionsList
	} = Transpose[MapThread[
		Function[{samplePacket, options},
			Module[
				{
					fixedOptionsWhenSweepingError, sweepingOptionsWhenFixedError, minOmegaAboveMaxError, minDetectorAngleAboveMaxError,
					fixedOptionsRequiredTogetherError, sweepingOptionsRequiredTogetherError, detectorTooCloseError,
					specifiedDetectorRotation, specifiedMinDetectorAngle, specifiedMaxDetectorAngle, omegaAngleIncrementTooLargeError,
					specifiedDetectorAngleIncrement, detectorRotation, minDetectorAngle, maxDetectorAngle, detectorAngleIncrement,
					specifiedMinOmegaAngle, specifiedMaxOmegaAngle, specifiedDetectorDistance, specifiedFixedDetectorAngle,
					minOmegaAngle, maxOmegaAngle, fixedDetectorAngle, detectorDistance, minDetectorDistance, temporaryDetectorDistance,
					detectorAngleIncrementTooLargeError, specifiedOmegaAngleIncrement, omegaAngleIncrement, roundedOmegaAngleDiff,
					specifiedSpottingVolume, resolvedSpottingVolume, noDetectorDistanceForAnglesError, noDetectorDistanceInvalidOptions,
					partiallyResolvedTemporaryDetectorDistance, partiallyResolvedDetectorDistance
				},

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
					specifiedFixedDetectorAngle,
					specifiedSpottingVolume
				} = Lookup[options, {DetectorRotation, MinDetectorAngle, MaxDetectorAngle, DetectorAngleIncrement, MinOmegaAngle, MaxOmegaAngle, OmegaAngleIncrement, DetectorDistance, FixedDetectorAngle, SpottingVolume}];

				(* Resolve SpottingVolume*)
				resolvedSpottingVolume = Which[
					(* In the trivial case, take what the user specified. *)
					MatchQ[specifiedSpottingVolume, Except[Automatic]],
					specifiedSpottingVolume,
					MatchQ[resolvedTransferType, MassTransfer],
					Null,
					True,
					3 Microliter
				];

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
						partiallyResolvedTemporaryDetectorDistance = empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> specifiedMinOmegaAngle, MaxOmegaAngle -> specifiedMaxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, MinDetectorAngle -> specifiedMinDetectorAngle, MaxDetectorAngle -> specifiedMaxDetectorAngle];

						(* If there is no possible detector distance, empiricalPowderXRDValues will have returned a list of invalid options. *)
						temporaryDetectorDistance = If[MatchQ[partiallyResolvedTemporaryDetectorDistance, UnitsP[Millimeter]],
							(* If the function returned a distance use that *)
							partiallyResolvedTemporaryDetectorDistance,
							(* Otherwise pick an arbirary detector distance to allow the options resolution and error checking to continue. *)
							61 Millimeter
						];

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
						partiallyResolvedDetectorDistance = If[MatchQ[specifiedDetectorDistance, UnitsP[Millimeter]],
							specifiedDetectorDistance,
							empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> minOmegaAngle, MaxOmegaAngle -> maxOmegaAngle, FixedDetectorAngle -> fixedDetectorAngle, MinDetectorAngle -> minDetectorAngle, MaxDetectorAngle -> maxDetectorAngle]
						];

						(* As partiallyResolvedDetectorDistance may have a list of options for which are precluding any possible detector distance, fully resolve it to a possible value. *)
						detectorDistance = If[MatchQ[partiallyResolvedDetectorDistance, UnitsP[Millimeter]],
							partiallyResolvedDetectorDistance,
							(* Arbitrarily pick the smallest detector distance in the event no detector distance works. *)
							61 Millimeter
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
						(* - if it is Automatic and DetectorDistance is not specified, resolve to the max of 81.25 AngularDegree *)
						(* - if it is Automatic and DetectorDistance is specified, resolve to what the empirical function says *)
						{maxDetectorAngle, sweepingOptionsRequiredTogetherError} = Which[
							NullQ[specifiedMaxDetectorAngle], {Null, True},
							MatchQ[specifiedMaxDetectorAngle, UnitsP[AngularDegree]], {specifiedMaxDetectorAngle, sweepingOptionsRequiredTogetherError},
							MatchQ[specifiedMaxDetectorAngle, Automatic] && MatchQ[specifiedDetectorDistance, Automatic | Null], {81.25 * AngularDegree, sweepingOptionsRequiredTogetherError},
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
						partiallyResolvedDetectorDistance = If[MatchQ[specifiedDetectorDistance, UnitsP[Millimeter]],
							specifiedDetectorDistance,
							empiricalPowderXRDValues[DetectorDistance, MinOmegaAngle -> minOmegaAngle, MaxOmegaAngle -> maxOmegaAngle, MinDetectorAngle -> minDetectorAngle, MaxDetectorAngle -> maxDetectorAngle]
						];

						(* As partiallyResolvedDetectorDistance may have a list of options for which are precluding any possible detector distance, fully resolve it to a possible value. *)
						detectorDistance = If[MatchQ[partiallyResolvedDetectorDistance, UnitsP[Millimeter]],
							partiallyResolvedDetectorDistance,
							(* Arbitrarily pick the smallest detector distance in the event no detector distance works. *)
							61 Millimeter
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

				(* Check that empiricalPowderXRDValues returned a distance rather than a list of invalid options. *)
				{noDetectorDistanceForAnglesError, noDetectorDistanceInvalidOptions} = If[!MatchQ[minDetectorDistance, UnitsP[]],
					{True, minDetectorDistance},
					{False, {}}
				];

				(* If there is no detector distance possible no need to say its too close.*)
				detectorTooCloseError = If[noDetectorDistanceForAnglesError,
					False,
					(* If the actual detector distance is less than the minDetectorDistance, flip the detectorTooCloseError switch *)
					detectorDistance < minDetectorDistance
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
					resolvedSpottingVolume,
					fixedOptionsWhenSweepingError,
					sweepingOptionsWhenFixedError,
					minOmegaAboveMaxError,
					minDetectorAngleAboveMaxError,
					fixedOptionsRequiredTogetherError,
					sweepingOptionsRequiredTogetherError,
					detectorTooCloseError,
					detectorAngleIncrementTooLargeError,
					omegaAngleIncrementTooLargeError,
					noDetectorDistanceForAnglesError,
					noDetectorDistanceInvalidOptions
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions}
	]];

	(* --- Unresolvable error checking --- *)


	(* Check if there is a mismatch between the resolved TransferType and CrystallizationPlatePreparation. *)
	transferTypePreparationMismatchQ = MatchQ[{resolvedTransferType, resolvedCrystallizationPlatePreparation}, {MassTransfer, Robotic}];

	(* Throw a message if the TransferType and CrystallizationPlatePreparation option are mismatched. *)
	transferTypePreparationMismatchOptions = If[transferTypePreparationMismatchQ && messages,
		Message[Error::CrystallizationPlatePreparationTransferTypeMismatch];
		{TransferType, CrystallizationPlatePreparation},
		{}
	];

	(* When Output includes tests, return a test checking for a mismatch between the TransferType and CyrstallizationPlatePreparation options. *)
	transferTypePreparationMismatchTest = If[gatherTests,
		Test["If the TransferType option is MassTransfer than CrystalPlatePreparation is not Robotic:",
			transferTypePreparationMismatchQ,
			False
		],
		Nothing
	];

	transferTypeSampleConflictQ =  Which[
		MatchQ[resolvedTransferType, MassTransfer], MatchQ[#, Except[Solid]]& /@ sampleStates,
		MatchQ[resolvedTransferType, Slurry], MatchQ[#, Except[Liquid]]& /@ sampleStates,
		True, ConstantArray[False, Length[sampleStates]]
	];

	invalidStateInputs = Lookup[PickList[samplePackets, transferTypeSampleConflictQ], Object, {}];

	(* Throw a message if the any samples invalidate the TransferType option. *)
	samplesIncompatibleWithTransferTypeOptions = If[MemberQ[transferTypeSampleConflictQ, True] && messages,
		Message[Error::InvalidSamplesForTransferType, ObjectToString[invalidStateInputs, Simulation -> updatedSimulation], Flatten[Position[transferTypeSampleConflictQ,True]], resolvedTransferType];
		{TransferType},
		{}
	];

	(* When Output includes tests, return tests checking each sample for incompatiblity with the TransferType option. *)
	samplesIncompatibleWithTransferTypeTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], transferTypeSampleConflictQ];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], transferTypeSampleConflictQ, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The TransferType is " <> ToString[resolvedTransferType] <> " but the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", will not be " <> If[MatchQ[resolvedTransferType, MassTransfer], "solid", "liquid-containing"] <> " (following any sample preparation):",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = Which[
				(* If we do not know the TransferType do not make passing tests. *)
				MatchQ[resolvedTransferType, Automatic],
				Nothing,
				(* If there are passing samples generate tests for the samples. *)
				Length[passingSamples] > 0,
				Test[ObjectToString[passingSamples, Simulation -> updatedSimulation] <> " are compatible the " <> ToString[resolvedTransferType] <>" TransferType:",
					True,
					True
				],
				(* If there are no passing samples, do nothing. *)
				True,
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}
		]
	];

	(* throw a message if options exclusive to a fixed detector are specified when we are sweeping *)
	fixedOptionsWhenSweepingOptions = If[MemberQ[fixedOptionsWhenSweepingErrors, True] && messages,
		(
			Message[Error::FixedOptionsWhileSweeping, ObjectToString[PickList[Lookup[samplePackets, Object], fixedOptionsWhenSweepingErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", FixedDetectorAngle is not specified if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", FixedDetectorAngle is not specified if DetectorRotation -> Sweeping:",
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
			Message[Error::SweepingOptionsWhileFixed, ObjectToString[PickList[Lookup[samplePackets, Object], sweepingOptionsWhenFixedErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement are not specified if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement are not specified if DetectorRotation -> Fixed:",
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
			Message[Error::MinOmegaAboveMax, ObjectToString[PickList[Lookup[samplePackets, Object], minOmegaAboveMaxErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", MinOmegaAngle is less than MaxOmegaAngle:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", MinOmegaAngle is less than MaxOmegaAngle:",
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
			Message[Error::OmegaAngleIncrementTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], omegaAngleIncrementTooLargeErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", OmegaAngleIncrement is less than the difference between MaxOmegaAngle and MaxOmegaAngle if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", OmegaAngleIncrement is less than the difference between MaxOmegaAngle and MaxOmegaAngle if DetectorRotation -> Fixed:",
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
			Message[Error::MinDetectorAngleAboveMax, ObjectToString[PickList[Lookup[samplePackets, Object], minDetectorAngleAboveMaxErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle is less than MaxDetectorAngle, or both are Null:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle is less than MaxDetectorAngle, or both are Null:",
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
			Message[Error::DetectorAngleIncrementTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], detectorAngleIncrementTooLargeErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", DetectorAngleIncrement is less than the difference between MaxDetectorAngle and MaxDetectorAngle if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", DetectorAngleIncrement is less than the difference between MaxDetectorAngle and MaxDetectorAngle if DetectorRotation -> Sweeping:",
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
			Message[Error::FixedOptionsRequiredTogether, ObjectToString[PickList[Lookup[samplePackets, Object], fixedOptionsRequiredTogetherErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", FixedDetectorAngle is not Null if DetectorRotation -> Fixed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", FixedDetectorAngle is not Null if DetectorRotation -> Fixed:",
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
			Message[Error::SweepingOptionsRequiredTogether, ObjectToString[PickList[Lookup[samplePackets, Object], sweepingOptionsRequiredTogetherErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement is not Null if DetectorRotation -> Sweeping:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", MinDetectorAngle, MaxDetectorAngle, and DetectorAngleIncrement is not Null if DetectorRotation -> Sweeping:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* Throw a message if the there are no possible detector distances for the angles *)
	noDetectorDistanceOptions = If[MemberQ[noDetectorDistanceForAnglesErrors, True] && messages,
		(
			Message[Error::NoPossibleDetectorDistanceForAngles, ObjectToString[PickList[Lookup[samplePackets, Object], noDetectorDistanceForAnglesErrors, True], Simulation -> updatedSimulation], DeleteDuplicates[Flatten[noDetectorDistanceInvalidOptionsList]]];
			DeleteDuplicates[Flatten[{noDetectorDistanceInvalidOptionsList, DetectorDistance}]]
		),
		{}
	];

	(* Generate the NoPossibleDetectorDistanceForAngles tests *)
	noDetectorDistanceTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], noDetectorDistanceForAnglesErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], noDetectorDistanceForAnglesErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", no DetectorDistance is able to fulfill the specified angles:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", a DetectorDistance is able to fulfill the specified angles:",
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
			Message[Error::DetectorTooClose, ObjectToString[PickList[Lookup[samplePackets, Object], detectorTooCloseErrors, True], Simulation -> updatedSimulation]];
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
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", DetectorDistance is not too low:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", DetectorDistance is not too low:",
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
	simulatedContainerModels = Download[simulatedSamples, Container[Model][Object], Simulation->updatedSimulation, Date -> Now];


	targetContainers = If[MatchQ[resolvedTransferType, Slurry],
		(* get the target containers; if the simulatedContainerModel is a liquid-handler-compatible model, then pick that one; if not pick a different one *)
		Map[
			If[MemberQ[Experiment`Private`hamiltonAliquotContainers["Memoization"], ObjectP[#]],
				#,
				Model[Container, Plate, "96-well 2mL Deep Well Plate"]
			]&,
			simulatedContainerModels
		],
		(* If the plate is being prepared by manual MassTransfer, a Hamilton compatable container is not necessary. *)
		simulatedContainerModels
	];

	(* RequiredAliquotAmount is going to be set to Null.  This is because transferring the slurry really requires us to transfer everything in ExperimentPowderXRD or we risk losing stuff.  I don't really know how else to handle it; these slurries are weird *)
	requiredAliquotAmount = Null;

	(* AliquotWarningMessage tells the aliquot resolver what to say about transferring containers *)
	aliquotWarningMessage = "because the given samples are not compatible with the parameters required to load the PowderXRD read plate.  You may set how much volume you wish to be aliquoted using the AliquotAmount option.";

	(* resolve the aliquot options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[ExperimentPowderXRD, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, resolvedSamplePrepOptions], Cache -> combinedCache, Simulation->updatedSimulation, AliquotWarningMessage -> aliquotWarningMessage, RequiredAliquotContainers ->targetContainers, RequiredAliquotAmounts -> requiredAliquotAmount, AllowSolids -> True, Output -> {Result, Tests}],
		{resolveAliquotOptions[ExperimentPowderXRD, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, resolvedSamplePrepOptions], Cache -> combinedCache, Simulation->updatedSimulation, AliquotWarningMessage -> aliquotWarningMessage, RequiredAliquotContainers ->targetContainers, RequiredAliquotAmounts -> requiredAliquotAmount, AllowSolids -> True, Output -> Result], {}}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* pull out the resolved assay volume *)
	resolvedAssayVolume = Lookup[resolvedAliquotOptions, AssayVolume];

	(* get the volume and spotting volume of the input samples *)
	sampleVolume = Lookup[samplePackets, Volume];

	invalidSpottingVolumeForTransferTypeQ = MatchQ[{resolvedSpottingVolumes, resolvedTransferType}, Alternatives[{Except[{GreaterP[0 Microliter]..}], Slurry}, {Except[{Null..}], MassTransfer}]];

	(* Check for a Null SpottingVolume when TransferType -> Slurry *)
	invalidSpottingVolumeForTransferType = If[invalidSpottingVolumeForTransferTypeQ && messages,
		Message[Error::InvalidSpottingVolumeForTransferType, resolvedTransferType, If[MatchQ[resolvedTransferType, MassTransfer], "Null", "not Null"]];
		{TransferType, SpottingVolume},
		{}
	];

	(* generate the SpottingVolumeTooLarge tests *)
	invalidSpottingVolumeForTransferTypeTest = If[gatherTests,
		Test["For a TransferType -> " <> ToString[resolvedTransferType] <> ", SpottingVolume must be " <> If[MatchQ[resolvedTransferType, MassTransfer], "Null:", "not Null:"],
			invalidSpottingVolumeForTransferTypeQ,
			False
		],
		Nothing
	];

	(* get the amount of spotting volume coming from each sample*)
	spottingVolumePerSample = Merge[Thread[samplePackets -> resolvedSpottingVolumes], Total];

	(* get the booleans for if the sample has a volume smaller than the spotting volume *)
	(* account for the fact that replicates can mess with this and so if you are not aliquoting but have replicates, your _total_ spotting volume needs to be below the sample volume*)
	spottingVolumesTooLargeBool = MapThread[
		Function[{assayVolume, sampleVol, spottingVol, samplePacket},
			If[VolumeQ[assayVolume],
				spottingVol > assayVolume,
				(samplePacket /. spottingVolumePerSample) > sampleVol
			]
		],
		{resolvedAssayVolume, sampleVolume, (resolvedSpottingVolumes /. Null -> 0 Microliter), samplePackets}
	];

	(* throw a message if the spotting volume is too large *)
	spottingVolumesTooLargeOptions = If[MemberQ[spottingVolumesTooLargeBool, True] && messages,
		(
			Message[Error::SpottingVolumeTooLarge, ObjectToString[PickList[Lookup[samplePackets, Object], spottingVolumesTooLargeBool, True], Simulation -> updatedSimulation]];
			{SpottingVolume}
		),
		{}
	];

	(* generate the SpottingVolumeTooLarge tests *)
	spottingVolumesTooLargeTest = If[gatherTests && MatchQ[resolvedTransferType, Slurry],
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], spottingVolumesTooLargeBool];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], spottingVolumesTooLargeBool, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", the total SpottingVolume is less than the volume of the sample, or, if aliquoting, the AssayVolume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Simulation -> updatedSimulation] <> ", the total SpottingVolume is less than the volume of the sample, or, if aliquoting, the AssayVolume:",
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
				Warning["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", Volume or AssayVolume is 100 microliters or less:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Simulation -> updatedSimulation] <> ", Volume or AssayVolume is 100 microliters or less:",
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
		unableToResolveTransferTypeOption,
		transferTypePreparationMismatchOptions,
		samplesIncompatibleWithTransferTypeOptions,
		fixedOptionsWhenSweepingOptions,
		sweepingOptionsWhenFixedOptions,
		minOmegaAboveMaxOptions,
		minDetectorAboveMaxOptions,
		fixedOptionsRequiredTogetherOptions,
		sweepingOptionsRequiredTogetherOptions,
		detectorTooCloseOptions,
		detectorAngleIncrementTooLargeOptions,
		omegaAngleIncrementTooLargeOptions,
		invalidSpottingVolumeForTransferType,
		spottingVolumesTooLargeOptions,
		noDetectorDistanceOptions
	]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* combine all the invalid inputs *)
	invalidInputs = DeleteDuplicates[Join[
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInputs,
		invalidStateInputs
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
		unableToResolveTransferTypeOptionTest,
		transferTypePreparationMismatchTest,
		samplesIncompatibleWithTransferTypeTests,
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
		invalidSpottingVolumeForTransferTypeTest,
		spottingVolumesTooLargeTest,
		noDetectorDistanceTest
	}], _EmeraldTest];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{instrument, confirm, canaryBranch, template, cache, operator, upload, outputOption, subprotocolDescription, samplesInStorage, samplesOutStorage, samplePreparation} = Lookup[myOptions, {Instrument, Confirm, CanaryBranch, Template, Cache, Operator, Upload, Output, SubprotocolDescription, SamplesInStorageCondition, SamplesOutStorageCondition, PreparatoryUnitOperations}];

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
		SpottingVolume -> resolvedSpottingVolumes,
		ImageXRDPlate -> imageXRDPlate,
		Instrument -> instrument,
		PreparatoryUnitOperations -> samplePreparation,
		CrystallizationPlatePreparation -> resolvedCrystallizationPlatePreparation,
		TransferType -> resolvedTransferType,
		resolvedSamplePrepOptions,
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
	SharedOptions :> {ExperimentPowderXRD}
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
		{61, 8.49},
		{65, 11.99},
		{68, 13.49},
		{70, 17.24},
		{209, 17.24}
	},
	MinDetectorAngle -> {
		(* CMU Instrument is incapable of 60 mm*)
		(*{60, -27.75},*) {61, -29.5}, {61, -29.5}, {62, -29.5}, {63, -31.25}, {64, -31.25},
		{65, -33}, {66, -33}, {67, -34.5}, {68, -34.5}, {69, -38.25},
		{70, -38.25}, {71, -38.25}, {72, -38.25}, {73, -38.25}, {74, -41.75},
		{75, -41.75}, {76, -41.75}, {77, -41.75}, {78, -41.75}, {79, -45},
		{80, -45}, {81, -45}, {82, -45}, {83, -45}, {84, -48},
		{85, -48}, {86, -48}, {87, -48}, {88, -48}, {89, -50.5},
		{90, -50.5}, {91, -50.5}, {92, -50.5}, {93, -50.5}, {94, -50.5},
		{95, -50.5}, {96, -50.5}, {97, -50.5}, {98, -50.5}, {99, -50.5},
		{100, -50.5}, {101, -50.5}, {102, -50.5}, {103, -50.5}, {104, -50.5},
		{105, -50.5}, {106, -50.5}, {107, -50.5}, {108, -50.5}, {109, -50.5},
		{110, -50.5}, {111, -50.5}, {112, -50.5}, {113, -50.5}, {114, -50.5},
		{115, -50.5}, {116, -50.5}, {117, -50.5}, {118, -50.5}, {119, -50.5},
		{120, -50.5}, {121, -50.5}, {122, -50.5}, {123, -50.5}, {124, -50.5},
		{125, -50.5}, {126, -50.5}, {127, -50.5}, {128, -50.5}, {129, -50.5},
		{130, -50.5}, {131, -50.5}, {132, -50.5}, {133, -50.5}, {134, -50.5},
		{135, -50.5}, {136, -50.5}, {137, -50.5}, {138, -50.5}, {139, -50.5},
		{140, -50.5}, {141, -50.5}, {142, -50.5}, {143, -50.5}, {144, -50.5},
		{145, -50.5}, {146, -50.5}, {147, -50.5}, {148, -50.5}, {149, -50.5},
		{150, -50.5}, {151, -50.5}, {152, -50.5}, {153, -48.75}, {154, -48.75},
		{155, -48.75}, {156, -48.75}, {157, -48.75}, {158, -48.75}, {159, -48.75},
		{160, -48.75}, {161, -48.75}, {162, -48.75}, {163, -47}, {164, -47},
		{165, -47}, {166, -47}, {167, -47}, {168, -47}, {169, -47},
		{170, -47}, {171, -47}, {172, -45}, {173, -45}, {174, -45},
		{175, -45}, {176, -45}, {177, -45}, {178, -45}, {179, -45},
		{180, -45}, {181, -45}, {182, -45}, {183, -45}, {184, -45},
		{185, -45}, {186, -45}, {187, -42.75}, {188, -42.75}, {189, -42.75},
		{190, -42.75}, {191, -42.75}, {192, -42.75}, {193, -42.75}, {194, -42.75},
		{195, -42.75}, {196, -42.75}, {197, -42.75}, {198, -42.75}, {199, -42.75},
		{200, -42.75}, {201, -41}, {202, -41}, {203, -41}, {204, -41},
		{205, -41}, {206, -41}, {207, -41}, {208, -41}, {209, -41}, {209, -41}
	},
	MaxDetectorAngle -> {
		(* CMU Instrument is incapable of 60 mm*)
		(*{60, 58.5}*){61, 60.25}, {61, 60.25}, {62, 60.25}, {63, 62}, {64, 62},
		{65, 63.75}, {66, 63.75}, {67, 65.25}, {68, 65.25}, {69, 69},
		{70, 69}, {71, 69}, {72, 69}, {73, 69}, {74, 72.5},
		{75, 72.5}, {76, 72.5}, {77, 72.5}, {78, 72.5}, {79, 75.75},
		{80, 75.75}, {81, 75.75}, {82, 75.75}, {83, 75.75}, {84, 78.75},
		{85, 78.75}, {86, 78.75}, {87, 78.75}, {88, 78.75}, {89, 81.25},
		{90, 81.25}, {91, 81.25}, {92, 81.25}, {93, 81.25}, {94, 81.25},
		{95, 81.25}, {96, 81.25}, {97, 81.25}, {98, 81.25}, {99, 81.25},
		{100, 81.25}, {101, 81.25}, {102, 81.25}, {103, 81.25}, {104, 81.25},
		{105, 81.25}, {106, 81.25}, {107, 81.25}, {108, 81.25}, {109, 81.25},
		{110, 81.25}, {111, 81.25}, {112, 81.25}, {113, 81.25}, {114, 81.25},
		{115, 81.25}, {116, 81.25}, {117, 81.25}, {118, 81.25}, {119, 81.25},
		{120, 81.25}, {121, 81.25}, {122, 81.25}, {123, 81.25}, {124, 81.25},
		{125, 81.25}, {126, 81.25}, {127, 81.25}, {128, 81.25}, {129, 81.25},
		{130, 81.25}, {131, 81.25}, {132, 81.25}, {133, 81.25}, {134, 81.25},
		{135, 81.25}, {136, 81.25}, {137, 81.25}, {138, 81.25}, {139, 81.25},
		{140, 81.25}, {141, 81.25}, {142, 81.25}, {143, 81.25}, {144, 81.25},
		{145, 81.25}, {146, 81.25}, {147, 81.25}, {148, 81.25}, {149, 81.25},
		{150, 81.25}, {151, 81.25}, {152, 81.25}, {153, 81.25}, {154, 81.25},
		{155, 79.75}, {156, 79.75}, {157, 79.75}, {158, 77.75}, {159, 76},
		{160, 76}, {161, 76}, {162, 76}, {163, 73.75}, {164, 73.75},
		{165, 73.75}, {166, 73.75}, {167, 71.75}, {168, 71.75}, {169, 71.75},
		{170, 71.75}, {171, 70}, {172, 70}, {173, 70}, {174, 70},
		{175, 70}, {176, 70}, {177, 46}, {178, 46}, {179, 46},
		{180, 46}, {181, 46}, {182, 46}, {183, 46}, {184, 46},
		{185, 46}, {186, 46}, {187, 46}, {188, 46}, {189, 46},
		{190, 46}, {191, 43.75}, {192, 43.75}, {193, 43.75}, {194, 43.75},
		{195, 43.75}, {196, 43.75}, {197, 43.75}, {198, 43.75}, {199, 43.75},
		{200, 43.75}, {201, 43.75}, {202, 43.75}, {203, 43.75}, {204, 43.75},
		{205, 43.75}, {206, 43.75}, {207, 43.75}, {208, 43.75}, {209, 41.75}, {209, 41.75}
	}
};

(* a couple of global variables for the absolute max/min of the omega angles *)
absoluteMinOmega = -21.24 AngularDegree;
absoluteMaxOmega = 51.99 AngularDegree;

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
		61,
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
		{MinOmegaAngle, GreaterP[absoluteMaxOmega]}, absoluteMaxOmega - 0.24 AngularDegree,
		{MinOmegaAngle, _}, desiredAngleNoRounding,
		{MaxOmegaAngle, LessP[absoluteMinOmega]}, absoluteMinOmega + 0.24 AngularDegree,
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
		61,
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
		MatchQ[maxDetectorAngle, Automatic | Null] && MatchQ[fixedDetectorAngle, Automatic | Null], 81.25,
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
		Null
	];
	maxOmegaAnglePiecewiseFunction = Piecewise[
		MapThread[
			(* need to have <= here because we're in positive here *)
			{#1, #2[[1]] <= y <= #2[[2]]}&,
			{maxOmegaAngleFormulae, partitionedMaxOmegaAngleData[[All, All, 1]]}
		],
		(* otherwise the distance is just going to be the closest we can be *)
		Null
	];
	minDetectorAnglePiecewiseFunction = Piecewise[
		Join[{{61, y > partitionedMinDetectorAngleData[[1,1,1]]}},
		MapThread[
			(* need to have >= here because we're in the negative here *)
			{#1, #2[[1]] >= y >= #2[[2]]}&,
			{minDetectorAngleFormulae, partitionedMinDetectorAngleData[[All, All, 1]]}
		]],
		(* otherwise the distance is just going to be the closest we can be *)
		Null
	];
	maxDetectorAnglePiecewiseFunction = Piecewise[
		Join[{{61, y < partitionedMaxDetectorAngleData[[1, 1, 1]]}},
			MapThread[
			(* need to have <= here because we're in positive here *)
			{#1, #2[[1]] <= y <= #2[[2]]}&,
			{maxDetectorAngleFormulae, partitionedMaxDetectorAngleData[[All, All, 1]]}
		]],
		(* otherwise the distance is just going to be the closest we can be *)
		Null
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
	unitlessClosestDetectorDistance = If[MemberQ[{unitlessDDFromMinOmega, unitlessDDFromMaxOmega, unitlessDDFromMinDetector, unitlessDDFromMaxDetector}, Null],
		Return[{
			If[MatchQ[unitlessDDFromMinOmega, Null], MinOmegaAngle, Nothing],
			If[MatchQ[unitlessDDFromMaxOmega, Null], MaxOmegaAngle, Nothing],
			Sequence @@ Which[
				MatchQ[unitlessMinDetectorAngle, unitlessMaxDetectorAngle] && (MatchQ[unitlessDDFromMinDetector, Null] || MatchQ[unitlessDDFromMaxDetector, Null]), {FixedDetectorAngle},
				MatchQ[{unitlessDDFromMinDetector, unitlessDDFromMaxDetector}, {Null, Null}], {MinDetectorAngle, MaxDetectorAngle},
				MatchQ[unitlessDDFromMinDetector, Null], {MinDetectorAngle},
				MatchQ[unitlessDDFromMaxDetector, Null], {MaxDetectorAngle},
				True, {}
			]}],
		Max[{unitlessDDFromMinOmega, unitlessDDFromMaxOmega, unitlessDDFromMinDetector, unitlessDDFromMaxDetector}]
	];

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
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, simulation,simulatedSamples, updatedSimulation,numReplicates, expandedSamplesWithNumReplicates, diffractometerTime, diffractometerResource,
		expandForNumReplicates, expandedExposureTime, expandedOmegaAngleIncrement, expandedDetectorDistance,
		expandedDetectorRotation, expandedMinOmegaAngle, expandedMaxOmegaAngle, expandedFixedDetectorAngle,
		expandedMinDetectorAngle, expandedMaxDetectorAngle, expandedDetectorAngleIncrement, omegaAngles, detectorAngles,
		protocolPacket, samplePackets, containersIn, sampleHandler, expandedAliquotVolume, sampleVolumes,
		pairedSamplesInAndVolumes, sampleVolumeRules, sampleResourceReplaceRules, samplesInResources, sharedFieldPacket,
		finalizedPacket, allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
		xrdParameters, plateID, crystallizationPlate, readingDiffractionTimeEstimate, expandedSamplesInStorage,
		expandedSamplesOutStorage, expandedSpottingVolume, safeOps, transferType, wells, xrdParametersIndexMatched,
		plateXCoordinates, plateYCoordinates, availableWells, plateAdapter, plateAdapterStoragePlacement
	},

	(* get the safe options for this function *)
	safeOps = SafeOptions[powderXRDResourcePackets, ToList[myOptions]];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* get the inherited cache *)
	inheritedCache = Lookup[safeOps, Cache];
	simulation = Lookup[ToList[safeOps], Simulation, Simulation[]];
	
	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentPowderXRD, mySamples, myResolvedOptions, Simulation -> simulation];

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
	samplePackets = Download[mySamples, Packet[Container, Volume], Simulation->updatedSimulation, Date -> Now];

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
	sampleHandler = Model[Container, Rack, "id:R8e1PjpeYzJX"](*XtalCheck*);

	transferType = Lookup[myResolvedOptions, TransferType];

	(* make a resource for the crystallization plate *)
	crystallizationPlate = If[MatchQ[transferType, MassTransfer],
		Resource[Sample -> Model[Container, Plate, "id:AEqRl9xjk896"]], (*"Microlytic High Throughput Crystal Former Plate"*)
		Resource[Sample -> Model[Container, Plate, "In Situ-1 Crystallization Plate"]]
	];

	(* compute the length of time the diffractometer will take to run *)
	(* 1 Hour is for ramping up the instrument; 10 minutes is getting the experiment ready; 10 minutes per sample is how much it takes for each sample to run; 30 minutes is to tear down the instrument *)
	diffractometerTime = 1 * Hour + 10 * Minute + (Length[expandedSamplesWithNumReplicates] * 10 * Minute) + 30 * Minute;

	(* make the instrument resource *)
	diffractometerResource = Resource[Instrument -> Lookup[resolvedOptionsNoHidden, Instrument], Name -> "Diffractometer", Time -> diffractometerTime];

	transferType = Lookup[myResolvedOptions, TransferType];

	(* make a resource for the crystallization plate *)
	{crystallizationPlate, plateAdapter, plateAdapterStoragePlacement} = If[MatchQ[transferType, MassTransfer],
		{
			Resource[Sample -> Model[Container, Plate, "id:AEqRl9xjk896"](*Microlytic High Throughput Crystal Former Plate*)],
			Resource[Sample -> Model[Container, Rack, "id:o1k9jAonE8Bm"], Name -> "Plate Adapter"(*Xtal Check-S Adapter for Microlytic High Throughput Crystal Former Plate*)],
			{Link[Resource[Sample -> Model[Container, Rack, "id:o1k9jAonE8Bm"], Name -> "Plate Adapter"]], Link[diffractometerResource], "Left Side Storage Slot"}
		},
		{
			Resource[Sample -> Model[Container, Plate, "id:pZx9jo8x59oP"](*In Situ-1 Crystallization Plate*)],
			Null,
			Null
		}
	];

	(* pull out the AliquotAmount option *)
	expandedAliquotVolume = Lookup[expandedResolvedOptions, AliquotAmount];

	(* get the sample volume; if we're aliquoting, use that amount; otherwise it's going to be 20 Microliter since it is too small to pipette less anyway*)
	sampleVolumes = MapThread[
		Which[VolumeQ[#1],
			#1,
			MatchQ[transferType, MassTransfer],
			3 Milligram,
			True,
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

	availableWells = If[MatchQ[transferType, Slurry],
		(* For SlurryTransfer, we use all wells and the usual order. *)
		Flatten[AllWells[]],
		(* For MassTransfer, a snake shape across the plate (i.e. going from the end of A to the end of B, start of B to start of C, saves time. *)
		(* Wells A1, A12, H1, and H12 are used to correct for any plate (loading) variability and will be empty. *)
		(Flatten[Riffle[
			AllWells[][[1 ;; ;; 2]],
			Reverse /@ AllWells[][[2 ;; ;; 2]]]
		] /. Alternatives["A1", "A12", "H1", "H12"] -> Nothing)
	];

	(* Determine which wells we will be using: *)
	wells = Take[availableWells, Length[samplesInResources]];

	plateXCoordinates = MapThread[#1 -> #2 &,
		{
			(* Well Positions for the LHS of the Rule: *)
			Flatten[AllWells[]],
			(* Coordinates for teh RHS of the Rule: *)
			Flatten[Table[
				Table[6.34 + i * 9.04, {i, 0, 11}],
			{i, 0, 7}]]
		}
	];

	plateYCoordinates = MapThread[#1 -> #2 &,
		{
			(* Well Positions for the LHS of the Rule: *)
			Flatten[AllWells[]],
			(* Coordinates for teh RHS of the Rule: *)
			Flatten[Table[
				Table[1.84, {i, 0, 11}] + i * ConstantArray[8.99, 12],
				{i, 0, 7}]]
		}
	];

	(* Uncollapsed version of XRDParameter*)
	xrdParametersIndexMatched = MapThread[
		Function[{
			sample, well, exposureTime, detectorDistance, omegaAngleIncrement, detectorRotation,
			minOmegaAngle, maxOmegaAngle, minDetectorAngle, maxDetectorAngle, detectorAngleIncrement
		},
			<|
				Sample -> sample,
				Position -> well,
				XCoordinate -> Lookup[plateXCoordinates, well],
				YCoordinate -> Lookup[plateYCoordinates, well],
				ZCoordinate -> 0.4,
				ExposureTime -> exposureTime,
				DetectorDistance -> detectorDistance,
				OmegaAngleIncrement -> omegaAngleIncrement,
				DetectorRotation -> detectorRotation,
				MinOmegaAngle -> minOmegaAngle,
				MaxOmegaAngle -> maxOmegaAngle,
				MinDetectorAngle -> minDetectorAngle,
				MaxDetectorAngle -> maxDetectorAngle,
				DetectorAngleIncrement -> detectorAngleIncrement
			|>
		],
	(* MapThread Over: *)
		{
		samplesInResources, wells, expandedExposureTime, expandedDetectorDistance, expandedOmegaAngleIncrement,
		expandedDetectorRotation, expandedMinOmegaAngle, expandedMaxOmegaAngle, expandedMinDetectorAngle,
		expandedMaxDetectorAngle, expandedDetectorAngleIncrement
		}
	];

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
		PlateAdapter -> Link[plateAdapter],
		PlateAdapterStoragePlacement -> plateAdapterStoragePlacement,
		TransferType -> transferType,
		CrystallizationPlatePreparation -> Lookup[myResolvedOptions, CrystallizationPlatePreparation],
		Instrument -> Link[diffractometerResource],

		(* populate checkpoints with reasonable time estimates TODO probably make these better because they're rather rough right now *)
		Replace[Checkpoints] -> {
			{"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
			{"Preparing Samples", 1 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Minute]]},
			{"Instrument Warm-Up", 1 * Hour, "X-ray diffractometer power is ramped up.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 * Hour]]},
			{"Reading Diffraction", readingDiffractionTimeEstimate, "Sample X-ray diffraction is measured.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 * Hour]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 * Hour]]},
			{"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 * Minute]]}
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
		Replace[XRDParametersIndexMatched] -> xrdParametersIndexMatched,
		PlateFileName -> plateID,
		(* Set Startup to Automatic, if the automatic script hits troubleshooting it may get toggled to Manual. *)
		Startup -> Automatic,
		(* Resources for MassTransfer *)
		Sequence@@If[MatchQ[transferType, MassTransfer],
			{
				Replace[Spatulas] -> Table[Resource[Sample -> Model[Item, Spatula, "Disposable Polypropylene Double-Ended Spatula MicroTip, 14 cm, Individual"], Name -> CreateUniqueLabel["Spatula"]], Length[samplesInResources]],
				Pestle -> Resource[Sample -> Model[Item, Spatula, "id:vXl9j57rvK6k" (*"Flat-Spoon Spatula"*)]],
				PlateSealFoils -> Resource[Sample -> Model[Item, Consumable, "id:6V0npvqEWrO8" (*"Roll of Kapton Discs, 3/8" Diameter"*)]],
				Tweezer -> Resource[Sample -> Model[Item, Tweezer, "id:8qZ1VWNwNDVZ" (*"Straight flat tip tweezer"*)]],
				(* Operations requested transfer for this protocol be done in a fume hood. In the future we may resolve this based on the hazard class or call some ExperimentTransfer/ExperimentTransfer helper to determine the safe transfer environment. *)
				TransferEnvironment -> Resource[Instrument -> commonFumeHoodHandlingStationModels["Memoization"]]
			},
			{}
		]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Simulation -> updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],  Simulation -> updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages,  Simulation -> updatedSimulation], Null}
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
ValidExperimentPowderXRDQ[mySample : (_String | ObjectP[{Object[Sample], Model[Sample]}]), myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := ValidExperimentPowderXRDQ[{mySample}, myOptions];

ValidExperimentPowderXRDQ[myContainer : (_String | ObjectP[Object[Container]]), myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := ValidExperimentPowderXRDQ[{myContainer}, myOptions];

ValidExperimentPowderXRDQ[myContainers : {(_String | ObjectP[{Object[Container], Object[Sample], Model[Sample]}])..}, myOptions : OptionsPattern[ValidExperimentPowderXRDQ]] := Module[
	{listedOptions, preparedOptions, xrdTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
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

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
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
ExperimentPowderXRDOptions[mySample : _String | ObjectP[{Object[Sample], Model[Sample]}], myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := ExperimentPowderXRDOptions[{mySample}, myOptions];

ExperimentPowderXRDOptions[myContainer : _String | ObjectP[Object[Container]], myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := ExperimentPowderXRDOptions[{myContainer}, myOptions];

ExperimentPowderXRDOptions[myContainers : {(_String | ObjectP[Object[Container], Object[Sample], Model[Sample]])..}, myOptions : OptionsPattern[ExperimentPowderXRDOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
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

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
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
ExperimentPowderXRDPreview[mySample : (_String | ObjectP[{Object[Sample], Model[Sample]}]), myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := ExperimentPowderXRDPreview[{mySample}, myOptions];

ExperimentPowderXRDPreview[myContainer : (_String | ObjectP[Object[Container]]), myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := ExperimentPowderXRDPreview[{myContainer}, myOptions];

ExperimentPowderXRDPreview[myContainers : {(_String | ObjectP[Object[Container], Object[Sample], Model[Sample]])..}, myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentPowderXRD *)
	ExperimentPowderXRD[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* --- Core Function --- *)
ExperimentPowderXRDPreview[mySamples : {(_String | ObjectP[Object[Sample]])..}, myOptions : OptionsPattern[ExperimentPowderXRDPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentPowderXRD *)
	ExperimentPowderXRD[mySamples, Append[noOutputOptions, Output -> Preview]]
];
