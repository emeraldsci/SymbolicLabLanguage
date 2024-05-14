(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection::Closed:: *)
(*Deuterated Solvents and NMR tubes*)


(* these are the currently-supported solvents (in ID form):*)
(* {
		Model[Sample, "id:eGakld01zzoo"],
 		Model[Sample, "id:D8KAEvdqzzGR"],
 		Model[Sample, "id:BYDOjv1VAA6z"],
 		Model[Sample, "id:WNa4ZjRr55V7"],
 		Model[Sample, "id:n0k9mGzRaaPp"],
 		Model[Sample, "Methanol-d4"],
 		Model[Sample, "id:xRO9n3vk11Pw"]
 	} *)
deuteratedSymbolsToSolvents[] := {
	Chloroform -> Model[Sample, "Chloroform-d"],
	DMSO -> Model[Sample, "Dimethyl sulfoxide-d6"],
	Benzene -> Model[Sample, "Benzene-d6"],
	Acetone -> Model[Sample, "Acetone-d6"],
	Acetonitrile -> Model[Sample, "Acetonitrile-d3"],
	Methanol -> Model[Sample, "Methanol-d4"],
	Water -> Model[Sample, "Deuterium oxide"]
};


(* ::Subsection:: *)
(*ExperimentNMR*)


(* ::Subsubsection::Closed:: *)
(*ExperimentNMR Options and Messages*)


DefineOptions[ExperimentNMR,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Nucleus,
				Default -> "1H",
				Description -> "The nucleus whose spins will be recorded in this experiment.",
				AllowNull -> False,
				Category -> "Sample Parameters",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Nucleus1DP
				]
			},
			{
				OptionName -> DeuteratedSolvent,
				Default -> Automatic,
				Description ->  "The deuterated solvent in which the provided samples will be dissolved in prior to taking their spectra (or, if the samples are already in the NMR tube, what solvent was used to dissolve them).",
				ResolutionDescription ->  "Automatically set to Model[Sample, \"Milli-Q water\"] if UseExternalStandard is True, otherwise set to Model[Sample, \"Deuterium oxide\"].",
				AllowNull -> False,
				Category -> "Sample Parameters",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> DeuteratedSolventP
					],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
					]
				]
			},
			{
				OptionName -> NumberOfScans,
				Default -> Automatic,
				Description -> "The number of pulse and read cycles that will be averaged together that are applied to each sample.",
				ResolutionDescription -> "Automatically set to 16 if Nucleus -> 1H or 19F, 1024 if Nucleus -> 13C, and 32 if Nucleus -> 31P.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Number,
					(* don't really know the upper limit we want to allow for number of scans.  For carbon spectra, tens of thousands is routine, so we want to allow quite a bit higher than that, so I somewhat arbitrarily picked 500k *)
					Pattern :> RangeP[1, 500000, 1]
				]
			},
			{
				OptionName -> NumberOfDummyScans,
				Default -> Automatic,
				Description -> "The number of scans performed before the receiver is turned on and data is collected for each sample.",
				ResolutionDescription -> "Automatically set to 2 if Nucleus -> 1H, and 4 if Nucleus -> 13C, 19F, or 31P.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Alternatives[
					"1" -> Widget[
						Type -> Number,
						Pattern :> RangeP[1, 1]
					],
					"Multiple of 2" -> Widget[
						Type -> Number,
						(* don't really know the upper limit we want to allow for number of scans. Must be a multiple of 2 (though 1 is okay); usually it is a low number like 4, so setting the upper bound to 128 is probably reasonable enough *)
						Pattern :> RangeP[2, 128, 2]
					]

				]
			},
			{
				OptionName -> AcquisitionTime,
				Default -> Automatic,
				Description -> "Length of time during which the NMR signal is sampled and digitized per scan.",
				ResolutionDescription -> "Automatically set to 4 Second if Nucleus -> 1H, 1.1 Second if Nucleus -> 13C, 0.6 Second if Nucleus -> 19F, and 0.4 Second if Nucleus -> 31P",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Second, 30 Second],
					Units :> {1, {Second, {Second, Millisecond}}}
				]
			},
			{
				OptionName -> RelaxationDelay,
				Default -> Automatic,
				Description -> "Length of time before the beginning of the PulseWidth of a given scan.  In effect, this is also the length of time after the AcquisitionTime before the next scan begins.",
				ResolutionDescription -> "Automatically set to 1 Second if Nucleus -> 1H or 19F, and 2 Second if Nucleus -> 13C or 31P.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Second, 30 Second],
					Units :> {1, {Second, {Second, Millisecond}}}
				]
			},
			{
				OptionName -> PulseWidth,
				Default -> Automatic,
				Description -> "Length of time during which the radio frequency pulse is turned on and the sample is irradiated per scan, assuming a 90 degree pulse.  Note that for Nucleus -> 1H | 13C | 31P, the experiment is run with a 30 degree pulse, and so the specified pulse width is actually divided by 3. Although this lowers sensitivity per scan, it allows faster accumulation of data such that sensitivity is increased overall.",
				ResolutionDescription -> "Automatically set to 10 Microsecond if Nucleus -> 1H or 13C, 15 Microsecond if Nucleus -> 19F, and 14 Microsecond if Nucleus -> 31P.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microsecond, 60 Microsecond],
					Units :> {1, {Microsecond, {Microsecond}}}
				]
			},
			{
				OptionName -> FlipAngle,
				Default -> Automatic,
				Description -> "Angle of rotation for the first radio-frequency pulse",
				ResolutionDescription -> "Automatically set to 90 AngularDegree if Nucleus -> 19F, or if WaterSuppression is set to anything but None. All other cases set to 30 AngularDegree.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[30 AngularDegree, 90 AngularDegree]
				]
			},
			{
				OptionName -> SpectralDomain,
				Default -> Automatic,
				Description -> "The range of the observed frequencies for a given spectrum.",
				ResolutionDescription -> "Automatically set to Span[-4 PPM, 16 PPM] if Nucleus -> 1H, Span[-20 PPM, 220 PPM] if Nucleus -> if 13C, Span[-220 PPM, 20 PPM] if Nucleus -> 19F, and Span[-250 PPM, 150 PPM] if Nucleus -> 31P.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget->Span[
					Widget[Type -> Quantity, Pattern :> RangeP[-200 PPM, 600 PPM], Units :> PPM],
					Widget[Type -> Quantity, Pattern :> RangeP[-200 PPM, 600 PPM], Units :> PPM]
				]
			},
			{
				OptionName -> WaterSuppression,
				Default -> None,
				Description -> "Indicates the method of eliminating a water signal from the spectrum.  Note that this may only be set if Nucleus -> 1H.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[WaterSuppressionMethodP, None]
				]
			},
			{
				OptionName -> TimeCourse,
				Default -> Automatic,
				Description -> "Indicates if multiple spectra should be collected over time.",
				ResolutionDescription -> "Automatically set to True if TimeInterval, NumberOfTimedScans,  are specified, or False otherwise.",
				AllowNull -> False,
				Category -> "Kinetic Data Acquisition",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> TimeInterval,
				Default -> Automatic,
				Description -> "Indicates the length of time between the start of scans of the same sample when TimeCourse -> True.",
				ResolutionDescription -> "Automatically set to length of time for one scan + 1 Minute if TimeCourse is True, or Null otherwise.",
				AllowNull -> True,
				Category -> "Kinetic Data Acquisition",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Second],
					Units :> {1, {Minute, {Second, Minute, Hour}}}
				]
			},
			{
				OptionName -> NumberOfTimeIntervals,
				Default -> Automatic,
				Description -> "Indicates the number of spectra to be collected of the input sample when TimeCourse -> True.",
				ResolutionDescription -> "Automatically set to Floor[TotalTimeCourse / TimeInterval] + 1 if TotalTimeCourse is set, or 10 if TimeCourse is otherwise True, or Null otherwise.",
				AllowNull -> True,
				Category -> "Kinetic Data Acquisition",
				Widget -> Widget[
					Type -> Number,
					(* don't really know the upper limit we want to allow for number of timed scans; semi arbitrarily set to 1000 which seems excessive but potentially could conceivably exist *)
					Pattern :> RangeP[1, 1000, 1]
				]
			},
			{
				OptionName -> TotalTimeCourse,
				Default -> Automatic,
				Description -> "Indicates the total duration of time during which scans are taken according to the TimeInterval.",
				ResolutionDescription -> "Automatically set to TimeInterval * NumberOfTimeIntervals if TimeCourse -> True, or Null otherwise.",
				AllowNull -> True,
				Category -> "Kinetic Data Acquisition",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Second],
					Units :> {1, {Minute, {Second, Minute, Hour, Day}}}
				]
			},
			(* NMR external standards *)
			{
				OptionName -> UseExternalStandard,
				Default -> Automatic,
				Description -> "Indicate if an external standard is used in this experiment. For example, in an NMR experiment, an external standard is stored separately in a coaxial insert (sealed or not) inserted into the NMR tube. The external standard helps lock the magnetic field if not using a deuterated solvent for the experiment or helps quantify the sample amount. For now, we only support one sealed coaxial insert: Model[Container,Vessel,\"3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide\"].",
				ResolutionDescription -> "Automatically set to True if SealedCoaxialInsert is specified. Else set to False.",
				AllowNull -> False,
				Category -> "Sample Parameters",
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP]
			},
			{
				OptionName -> SealedCoaxialInsert,
				Default -> Automatic,
				Description -> "The sealed coaxial insert that used as an external standards during the experiment.",
				ResolutionDescription -> "Automatically set to Null if UseExternalStandard is False. Else set to Model[Container, Vessel, \"3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide\"]",
				AllowNull -> True,
				Category -> "Sample Parameters",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel]}]
				]
			}
		],
		{
			OptionName -> Instrument,
			Default ->  Model[Instrument, NMR, "Ascend 500"],
			Description -> "The NMR instrument used for this experiment.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, NMR], Object[Instrument, NMR]}]
			]
		},
		NMRSharedOptions,
		FuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOption,
		SamplesOutStorageOption
	}
];



(* ::Subsubsection:: *)
(*ExperimentNMR*)


Error::NMRTooManySamples="The (number of input samples * NumberOfReplicates) cannot fit onto the instrument in a single protocol.  Please selectPlease select fewer than `1` samples to run this protocol.";
Warning::NonStandardSolvent="The specified solvent(s) `1` are not one of ECL's currently supported solvents `2`.  Note that this may result in a poor spectrum, and we recommend using a deuterated solvent.";
Error::SampleAmountStateConflict="The state of sample(s) after aliquoting (if applicable) `1` is not compatible with the units specified in the SampleAmount option `2`.  Please set SampleAmount and/or the Aliquoting options to correspond to the state of the sample.";
Error::SampleAmountTooHigh="The specified SampleAmount value(s) `1` are higher than the available amount(s) `2` for sample(s) `3`.  Please lower SampleAmount, or leave it as Automatic.";
Error::UnsupportedNMRTube="The following specified NMRTube are not currently supported by the ECL: `1`.  Please select a container model where the Footprint field is set to NMRTube.";
Error::WaterSuppressionIncompatible="The specified sample(s) `1` have WaterSuppression specified but Nucleus set to something other than 1H.  WaterSuppression may be set only if Nucleus -> 1H.  Please set this option to None, or change Nucleus to 1H.";
Error::NMRTubesIncompatible="The specified sample(s) `1` are not compatible with the objects specified in the NMRTube option `2`.  NMRTube is to be set to a container with PermanentlySealed -> True if and only if the sample is already in a sealed NMR tube.  Please leave the NMRTube option blank, or set it in accordance with the sample's current container.";
Error::SampleAmountNull="The specified sample(s) `1` have the SampleAmount and/or SolventVolume options set incorrectly.  If a sample is already in an NMR tube, these options must be Null; if the sample is already in an NMR tube, these options must not be Null.  Please leave these options unspecified and they will resolve automatically.";
Error::KineticOptionsRequiredTogether = "The specified sample(s) `1` have the TimeCourse, TimeInterval, NumberOfTimeIntervals, and/or TotalTimeCourse options set incorrectly.  If TimeCourse -> True, then TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must not be Null. If TimeCourse -> False, then TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must be Null (or unspecified).";
Error::KineticOptionsIncompatibleNucleus = "The specified sample(s) `1` have TimeCourse set to True, but Nucleus set to something other than 1H.  Currently kinetic experiments may only be performed if Nucleus -> 1H.  Change Nucleus to 1H, or set TimeCourse to False.";
Error::KineticOptionMismatch = "The specified sample(s) `1` have the TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse options specified such that TotalTimeCourse / TimeInterval (rounded down) does not equal NumberOfTimeIntervals.  Please leave one or more of these options unspecified so that they may be set automatically.";
Error::TimeIntervalTooSmall = "The specified sample(s) `1` have TimeInterval set to a duration `2` less than the duration of a single spectrum `3`.  Please increase TimeInterval to be less than (AcquisitionTime + RelaxationDelay) * NumberOfScans.";
Error::KineticOptionsWaterSuppression = "The specified sample(s) `1` have TimeCourse set to True and WaterSuppression set to a value besides None.  Water suppression of timed kinetic experiments is currently not supported. Please specify only one of these two options for a given sample.";
Error::SealedNMRTubeCannotUseExternalStandards="The specified sample(s) `1` are in a permanently sealed NMR tube, thereby we cannot use external standard for this sample.";
Error::ConflictingExternalStandardOptions="The specified sample(s) `1` have conflicting options: UseExternalStandard and SealedCoaxialInsert. If UseExternalStandard is True, SealedCoaxialInsert must be specified. Else if UseExternalStandard is false, SealedCoaxialInsert cannot be specified. Please change accordingly or leave them as Automatic.";
Error::No30DegFlipAngleFor19F = "The specified sample(s) `1` have nucleus set to 19F while FlipAngle set to 30 AngularDegree. Our instrument method does not support non-90 AngularDegree flip angle for 19F, please change the FlipAngle to 90 AngularDegree, or change the nucleus to something else.";
Error::No30DegFlipAngleForWaterSuppression = "The specified sample(s) `1` has FlipAngle set to 30 AngularDegree while WaterSuppression set to `2`, which are not compatible. Please set the FlipAngle to 90 AngularDegree, or change the WaterSuppression to Presaturation.";

(* core sample overload*)
ExperimentNMR[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[ExperimentNMR]]:=Module[
	{listedOptions, listedSamples, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests,
		safeOptionsNamed, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, specifiedSealedCoaxialInsert,
		validLengths, validLengthTests, upload, confirm, fastTrack, parentProt, inheritedCache, unresolvedOptions,
		applyTemplateOptionTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, allDownloadValues, newCache, containerModelPreparationFields,
		specifiedNMRTubes, finalizedPacket, resourcePacketTests, allTests, validQ, previewRule, optionsRule, testsRule, resultRule,
		validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache,
		specifiedInstrument, samplePreparationPacket,sampleModelPreparationPacket, nmrTubeRack, sealedCoaxialInsertObjects},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentNMR,
			listedSamples,
			ToList[listedOptions]
		],
		$Failed,
	 	{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];


	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentNMR, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentNMR, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentNMR, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentNMR, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentNMR, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentNMR, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests, applyTemplateOptionTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentNMR, {mySamplesWithPreparedSamples}, combinedOptions, 1]];

	(* hard code the NMR tube rack here; we need to Download some stuff from it; if there were a field in the Model[Instrument, NMR] then we could do that but it seems that we do not *)
	(* Note that it is also hard coded in the resource packets function*)
	nmrTubeRack = Model[Container, Rack, "SampleJet NMR Tube Rack"];

	(* pull the specified NMR tubes out of the Instrument and NMRTube options *)
	{specifiedInstrument, specifiedNMRTubes, specifiedSealedCoaxialInsert} = Lookup[expandedCombinedOptions, {Instrument, NMRTube, SealedCoaxialInsert}];

	(* Set up the samplePreparationPacket using SamplePreparationCacheFields*)
	samplePreparationPacket = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], IncompatibleMaterials, LiquidHandlerIncompatible, Tablet, TabletWeight, TransportWarmed, TransportChilled];
	sampleModelPreparationPacket = Packet[Model[Flatten[{Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];

	(* get the SamplePreparationCacheFields for Model[Container] objects*)
	containerModelPreparationFields = Packet[PermanentlySealed, SamplePreparationCacheFields[Model[Container], Format -> Sequence]];
	
	(* collect all inserts we want to download into the cache *)
	sealedCoaxialInsertObjects=Flatten[DeleteDuplicates[{Cases[specifiedSealedCoaxialInsert, ObjectP[]],Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]}]];
	
	(* Download the sample's packets and their models *)
	allDownloadValues = Quiet[Download[
		{
			mySamplesWithPreparedSamplesNamed,
			specifiedNMRTubes,
			{specifiedInstrument},
			{nmrTubeRack},
			ToList[sealedCoaxialInsertObjects]
		},
		{
			{
				samplePreparationPacket,
				sampleModelPreparationPacket,
				Packet[Composition[[All,2]][MolecularWeight]]
			},
			{
				containerModelPreparationFields
			},
			{
				Packet[Name, ResonanceFrequency, WettedMaterials],
				Packet[Model[{Name, ResonanceFrequency, WettedMaterials}]]
			},
			{
				containerModelPreparationFields
			},
			{
				Packet[Name, ResonanceFrequency, WettedMaterials, IncompatibleMaterials, Dimensions, Container],
				Packet[Model[{Name, ResonanceFrequency, WettedMaterials, IncompatibleMaterials, Dimensions}]]
			}
		},
		Cache -> Flatten[{inheritedCache,samplePreparationCache}],
		Date -> Now
	], {Download::NotLinkField, Download::FieldDoesntExist}];

	(* make the new cache combining what we inherited and the stuff we Downloaded *)
	newCache = Cases[FlattenCachePackets[{samplePreparationCache, inheritedCache, allDownloadValues}],PacketP[]];

	(* --- Resolve the options! --- *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveNMROptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache],
			{resolveNMROptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];


	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveNMROptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentNMR,
		RemoveHiddenOptions[ExperimentNMR, resolvedOptions],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
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


	(* call the nmrResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPacket, resourcePacketTests} = If[gatherTests,
		nmrResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Tests}], Cache -> newCache],
		{nmrResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache], Null}
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
		UploadProtocol[
			finalizedPacket,
			Confirm -> confirm,
			Upload -> upload,
			FastTrack -> fastTrack,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->{Object[Protocol,NMR]},
			Cache->samplePreparationCache],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}
];

(* multiple container input *)
ExperimentNMR[myContainers:ListableP[(ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]})], myOptions:OptionsPattern[ExperimentNMR]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,
		containerToSampleTests, inputSamples, samplesOptions, aliquotResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationCache, updatedCache, containerToSampleCache},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentNMR,
			ToList[myContainers],
			ToList[myOptions]
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentNMR, myOptionsWithPreparedSamples, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentNMR, myOptionsWithPreparedSamples, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		containerToSampleOptions[ExperimentNMR, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache, Output -> {Result, Tests}],
		{containerToSampleOptions[ExperimentNMR, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions, containerToSampleCache} = containerToSampleResult;

	(* Update our cache with our new simulated values. *)
	updatedCache=FlattenCachePackets[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}],
		containerToSampleCache
	}];

	(* call ExperimentNMR and get all its outputs *)
	aliquotResults = ExperimentNMR[inputSamples, ReplaceRule[samplesOptions,Cache->updatedCache]];

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

	(* Results rule is just always what was output in the ExperimentNMR call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection::Closed:: *)
(*resolveNMROptions*)


DefineOptions[resolveNMROptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveNMROptions[mySamples:{ObjectP[Object[Sample]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveNMROptions]]:=Module[
	{outputSpecification, output, gatherTests, messages, inheritedCache, samplePackets, resolvedRelaxationDelays,
		sampleModelPackets, samplePrepOptions, nmrOptions, simulatedSamples, resolvedSamplePrepOptions,
		simulatedCache, samplePrepTests, nucleus, solvent, resolvedSolventVolume, sampleTemperature,
		nmrTubes, numberOfReplicates, name, parentProtocol, fastTrack,samplePacketsToCheckIfDiscarded,
		discardedSamplePackets, discardedInvalidInputs, discardedTest, modelPacketsToCheckIfDeprecated,
		deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest, numSamples, tooManySamplesQ,
		tooManySamplesInputs, tooManySamplesTest, roundedNMROptions, precisionTests, validNameQ, nameInvalidOptions,
		validNameTest, mapThreadFriendlyOptions, resolvedNumberOfScans, resolvedAcquisitionTimes, resolvedPulseWidths,
		resolvedSpectralDomains, nonStandardSolventWarnings, nonStandardSolventWarningTests, targetContainers,
		resolvedAliquotOptions, aliquotTests, resolvedAssayVolume, resolvedSampleAmount, sampleAmountStateErrors,
		resolvedAliquotAmount, simulatedVolumes, simulatedMasses, simulatedCounts, sampleAmountStateOptions,
		sampleAmountStateTests, invalidOptions, invalidInputs, allTests, confirm, template, cache, operator, upload,
		outputOption, subprotocolDescription, samplesInStorage, samplesOutStorage, email,
		resolvedOptions, testsRule, resultRule, sampleAmountTooHighErrors, simulatedAmounts, sampleAmountTooHighOptions,
		sampleAmountTooHighTests, unsupportedNMRTubeQ, unsupportedNMRTubeOptions, unsupportedNMRTubeTest,
		preResolvedAliquotBool, resolvedPostProcessingOptions, specifiedSampleAmount, requiredAliquotAmounts,
		resolvedWaterSuppression, waterSuppressionErrors, waterSuppressionInvalidOptions, waterSuppressionTests,
		samplePreparation, compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs,
		nmrModelPacket, nmrTubeErrors, tubeIncompatibleSamples, tubeIncompatibleTubes,
		nmrTubeErrorOptions, nmrTubeErrorTests, sampleAmountNullErrors, sampleAmountNullOptions, sampleAmountNullTests,
		instrument, sampleAnalytePackets, zeroSpectralWidthErrors, simulatedContainerModelPackets,
		zeroSpectralDomainSamples, zeroSpectralDomainOptions, zeroSpectralDomainTests, specifiedNMRTubes, nmrTubeModelPackets,
		validContainerStorageConditionBool, validContainerStorageConditionTests, validContainerStoragConditionInvalidOptions,
		resolvedTimeCourse, resolvedTimeInterval, resolvedNumberOfTimeIntervals, resolvedTotalTimeCourse,
		kineticOptionsRequiredTogetherErrors, kineticOptionNotProtonErrors, kineticOptionMismatchErrors,
		kineticOptionsRequiredTogetherErrorOptions, kineticOptionsRequiredTogetherErrorTests, kineticOptionNotProtonErrorOptions,
		kineticOptionNotProtonErrorTests, kineticOptionMismatchErrorOptions, kineticOptionMismatchErrorTests,
		timeIntervalTooSmallErrors, timeIntervalTooSmallSamples, timeIntervalTooSmallTimeIntervals, timeIntervalTooSmallSpectrumTime,
		timeIntervalTooSmallOptions, timeIntervalTooSmallErrorTests, waterSuppressionAndKineticErrors, waterSuppressionAndKineticErrorOptions,
		waterSuppressionAndKineticErrorTests, resolvedNumberOfDummyScans, resolvedUseExternalStandards,
		resolvedSealedCoaxialInserts, conflictingExternalStandardErrors, invalidExernalStandardErrors,conflictingExternalStandardErrorOptions,
		conflictingExternalStandardErrorTests, invalidExernalStandardErrorOptions, invalidExernalStandardErrorTests,
		resolvedDeuteratedSolvents, resolvedFlipAngles, flipAngleNucleusErrors, flipAngleWaterSuppressionErrors,
		flipAngleNucleusInvalidOptions, flipAngleNucleusTests, flipAngleWaterSuppressionInvalidOptions, flipAngleWaterSuppressionTests
	},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache option *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	fastTrack = Lookup[ToList[myResolutionOptions], FastTrack, False];

	(* currently the instrument model is always this; in the future this will be an option and we will just pull it out there, but for now it's not useful to be an option *)
	nmrModelPacket = FirstCase[inheritedCache, ObjectP[Model[Instrument, NMR]]];

	(* pull the specified NMR tubes out of the NMRTube option *)
	specifiedNMRTubes = Lookup[myOptions, NMRTube];

	(* split out the sample and model packets *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySamples;
	sampleModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[samplePackets, Model, {}];
	sampleAnalytePackets = Map[
		fetchPacketFromCache[#, inheritedCache]&,
		Lookup[samplePackets, Composition, {}][[All, All, 2]],
		{2}
	];
	nmrTubeModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[specifiedNMRTubes, Object];

	(* --- split out and resolve the sample prep options --- *)

	(* split out the options *)
	{samplePrepOptions, nmrOptions} = splitPrepOptions[myOptions];

	(* resolve the sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptions[ExperimentNMR, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> {Result, Tests}],
		{resolveSamplePrepOptions[ExperimentNMR, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> Result], {}}
	];

	(* get the current container model of the simulated samples *)
	simulatedContainerModelPackets = Download[simulatedSamples, Packet[Container[Model][{Object, PermanentlySealed, Footprint}]], Cache -> simulatedCache, Date -> Now];

	(* pull out the options that are defaulted *)
	{
		nucleus,
		sampleTemperature,
		nmrTubes,
		numberOfReplicates,
		name,
		parentProtocol,
		instrument
	} = Lookup[nmrOptions, {Nucleus, SampleTemperature, NMRTube, NumberOfReplicates, Name, ParentProtocol, Instrument}];

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

	(* pull the models out of the sampleModelPackets and remove Nulls, then check if deprecated. In the case that the Model itself is Null, the sampleModelPackets will also be Null *)
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
			Message[Error::NMRTooManySamples, 96];
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

	(* if we have an NMR tube that is not supported, figure this out *)
	unsupportedNMRTubeQ = Not[MatchQ[Lookup[#, Footprint], NMRTube]]& /@ nmrTubeModelPackets;

	(* if we have an unsupported NMR tube, throw an error *)
	unsupportedNMRTubeOptions = If[MemberQ[unsupportedNMRTubeQ, True] && messages,
		(
			Message[Error::UnsupportedNMRTube, ObjectToString[DeleteDuplicates @ PickList[nmrTubeModelPackets, unsupportedNMRTubeQ]]];
			{NMRTube}
		),
		{}
	];

	(* Generate test for UnsupportedNMRTube *)
	unsupportedNMRTubeTest = If[gatherTests,
		Test["All specified NMRTube are currently supported by ECL:",
			MemberQ[unsupportedNMRTubeQ, True],
			False
		],
		Null
	];

	(* --- Option precision checks --- *)

	(* ensure that all the numerical options have the proper precision *)
	{roundedNMROptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[Association[nmrOptions], {SampleTemperature, AcquisitionTime, RelaxationDelay, PulseWidth, TimeInterval, TotalTimeInterval, SpectralDomain}, {10^0*Celsius, 10^-2*Second, 10^-2*Second, 10^-1*Microsecond, 10^0 Second, 10^0 Second, 0.01 PPM}, Output -> {Result, Tests}],
		{RoundOptionPrecision[Association[nmrOptions], {SampleTemperature, AcquisitionTime, RelaxationDelay, PulseWidth, TimeInterval, TotalTimeInterval, SpectralDomain}, {10^0*Celsius, 10^-2*Second, 10^-2*Second, 10^-1*Microsecond, 10^0 Second, 10^0 Second, 0.01 PPM}], {}}
	];

	(* ---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[nmrModelPacket, simulatedSamples, Cache -> simulatedCache, Output -> {Result, Tests}],
		{CompatibleMaterialsQ[nmrModelPacket, simulatedSamples, Cache -> simulatedCache, Messages -> messages], {}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
		Download[mySamples, Object],
		{}
	];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, NMR, Lookup[roundedNMROptions, Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "NMR protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a NMR object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentNMR, roundedNMROptions];

	(* do our big MapThread *)
	{
		resolvedNumberOfScans,
		resolvedDeuteratedSolvents,
		resolvedNumberOfDummyScans,
		resolvedAcquisitionTimes,
		resolvedRelaxationDelays,
		resolvedPulseWidths,
		resolvedFlipAngles,
		resolvedSpectralDomains,
		resolvedWaterSuppression,
		resolvedTimeCourse,
		resolvedTimeInterval,
		resolvedNumberOfTimeIntervals,
		resolvedTotalTimeCourse,
		resolvedUseExternalStandards,
		resolvedSealedCoaxialInserts,
		nonStandardSolventWarnings,
		waterSuppressionErrors,
		nmrTubeErrors,
		zeroSpectralWidthErrors,
		kineticOptionsRequiredTogetherErrors,
		kineticOptionNotProtonErrors,
		kineticOptionMismatchErrors,
		timeIntervalTooSmallErrors,
		waterSuppressionAndKineticErrors,
		conflictingExternalStandardErrors,
		invalidExernalStandardErrors,
		flipAngleNucleusErrors,
		flipAngleWaterSuppressionErrors
	} = Transpose[MapThread[
		Function[{samplePacket, options, containerModelPacket, tubeModelPacket},
			Module[
				{nonStandardSolventWarning, solventOption, numberOfScans, acquisitionTime, pulseWidth, spectralDomain,
					waterSuppressionError, waterSuppression, nmrTubeError, zeroSpectralWidthError, spectralWidth,
					kineticOptionMismatchError, kineticOptionNotProtonError, lengthOfOneSpectrum, specifiedTimeCourse,
					specifiedTimeInterval, specifiedNumTimeIntervals, specifiedTotalTimeCourse, totalTimeCourse,
					kineticOptionsRequiredTogetherError, timeCourse, timeInterval, numberOfTimeIntervals, specifiedNucleus,
					timeIntervalTooSmallError, waterSuppressionAndKineticError, relaxationDelay, numberOfDummyScans,
					useExternalStandard, sealedCoaxialInsert, conflictingExternalStandardError,invalidExernalStandarderror,
					deuteratuedSolvent, flipAngle, flipAngleNucleusError, flipAngleWaterSuppressionError
				},

				(* set our error checking variables *)
				{
					nonStandardSolventWarning,
					waterSuppressionError,
					nmrTubeError,
					zeroSpectralWidthError,
					kineticOptionMismatchError,
					kineticOptionNotProtonError,
					kineticOptionsRequiredTogetherError,
					timeIntervalTooSmallError,
					waterSuppressionAndKineticError
				} = {False, False, False, False, False, False, False, False, False};
				
				(* first resolve deuteratued solvent *)
				deuteratuedSolvent=Which[
					MatchQ[Lookup[options, DeuteratedSolvent],Except[Automatic]],Lookup[options, DeuteratedSolvent],
					TrueQ[Lookup[options,UseExternalStandard]], Model[Sample, "Milli-Q water"],
					True, Model[Sample, "Deuterium oxide"]
				];
				
				
				(* pull out the DeuteratedSolvent option; if it's a packet do a Lookup; if it's a Link, Download Object *)
				solventOption = Switch[Lookup[options, DeuteratedSolvent],
					DeuteratedSolventP | ObjectReferenceP[], Lookup[options, DeuteratedSolvent],
					LinkP[], Download[Lookup[options, DeuteratedSolvent], Object],
					PacketP[], Lookup[Lookup[options, DeuteratedSolvent], Object]
				];

				(* flip the non standard solvent warning switch if the DeuteratedSolvent option is not one of our standard deuterated solvents *)
				(* if it's not an object (i.e., it's a symbol), then we're not throwing the warning because all the symbols are fine *)
				(* note that I'm making a special exception for if we're using 90% water / 10% D2O because that is supported *)
				(* Model[Sample, StockSolution, "id:xRO9n3BxlXnj"] is the object for Model[Sample, StockSolution, "90% water / 10% D2O"] *)
				nonStandardSolventWarning = Not[MatchQ[solventOption, ObjectP[Model[Sample, StockSolution, "id:xRO9n3BxlXnj"]]]] && MatchQ[solventOption, ObjectP[]] && Not[MemberQ[Values[deuteratedSymbolsToSolvents[]], ObjectP[solventOption]]];

				(* flip the error switch if containerModel and NMRTube are not either both or neither sealed NMR tubes *)
				(* need this gross And because if the input sample has no container (invalidly) we don't want to trainwreck *)
				nmrTubeError = Xor[
					And[
						MatchQ[containerModelPacket, ObjectP[Model[Container]]],
						MatchQ[Lookup[containerModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}]
					],
					MatchQ[Lookup[tubeModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}]
				];

				(* get the specified Nucleus *)
				specifiedNucleus = Lookup[options, Nucleus];

				(* Gather the WaterSuppression method *)
				waterSuppression = Lookup[options, WaterSuppression];

				(* resolve the NumberOfScans, AcquisitionTime, PulseWidth, and SpectralDomain options depending on the nucleus *)
				{
					numberOfScans,
					numberOfDummyScans,
					acquisitionTime,
					relaxationDelay,
					pulseWidth,
					spectralDomain,
					flipAngle
				} = Switch[{specifiedNucleus, waterSuppression},
					{"1H",None},
						{
							Lookup[options, NumberOfScans] /. {Automatic -> 16},
							Lookup[options, NumberOfDummyScans] /. {Automatic -> 2},
							Lookup[options, AcquisitionTime] /. {Automatic -> 4*Second},
							Lookup[options, RelaxationDelay] /. {Automatic -> 1 Second},
							Lookup[options, PulseWidth] /. {Automatic -> 10*Microsecond},
							Lookup[options, SpectralDomain] /. {Automatic -> Span[-4*PPM, 16*PPM]},
							Lookup[options, FlipAngle] /. {Automatic -> 30 AngularDegree}
						},
					{"1H",Except[None|Null]},
						{
							Lookup[options, NumberOfScans] /. {Automatic -> 16},
							Lookup[options, NumberOfDummyScans] /. {Automatic -> 2},
							Lookup[options, AcquisitionTime] /. {Automatic -> 4*Second},
							Lookup[options, RelaxationDelay] /. {Automatic -> 1 Second},
							Lookup[options, PulseWidth] /. {Automatic -> 10*Microsecond},
							Lookup[options, SpectralDomain] /. {Automatic -> Span[-4*PPM, 16*PPM]},
							Lookup[options, FlipAngle] /. {Automatic -> 90 AngularDegree}
						},
					{"13C",_},
						{
							Lookup[options, NumberOfScans] /. {Automatic -> 1024},
							Lookup[options, NumberOfDummyScans] /. {Automatic -> 4},
							Lookup[options, AcquisitionTime] /. {Automatic -> 1.1*Second},
							Lookup[options, RelaxationDelay] /. {Automatic -> 2 Second},
							Lookup[options, PulseWidth] /. {Automatic -> 10*Microsecond},
							Lookup[options, SpectralDomain] /. {Automatic -> Span[-20*PPM,220*PPM]},
							Lookup[options, FlipAngle] /. {Automatic -> 30 AngularDegree}
						},
					{"19F", _},
						{
							Lookup[options, NumberOfScans] /. {Automatic -> 16},
							Lookup[options, NumberOfDummyScans] /. {Automatic -> 4},
							Lookup[options, AcquisitionTime] /. {Automatic -> 0.6*Second},
							Lookup[options, RelaxationDelay] /. {Automatic -> 1 Second},
							Lookup[options, PulseWidth] /. {Automatic -> 15*Microsecond},
							Lookup[options, SpectralDomain] /. {Automatic -> Span[-220*PPM, 20*PPM]},
							Lookup[options, FlipAngle] /. {Automatic -> 90 AngularDegree}
						},
					{"31P",_},
						{
							Lookup[options, NumberOfScans] /. {Automatic -> 32},
							Lookup[options, NumberOfDummyScans] /. {Automatic -> 4},
							Lookup[options, AcquisitionTime] /. {Automatic -> 0.4*Second},
							Lookup[options, RelaxationDelay] /. {Automatic -> 2 Second},
							Lookup[options, PulseWidth] /. {Automatic -> 14*Microsecond},
							Lookup[options, SpectralDomain] /. {Automatic -> Span[-250*PPM, 150*PPM]},
							Lookup[options, FlipAngle] /. {Automatic -> 30 AngularDegree}
						}
				];

				(* get the spectral width *)
				spectralWidth = Last[Sort[spectralDomain]] - First[Sort[spectralDomain]];

				(* if spectral width is zero, then flip an error switch *)
				zeroSpectralWidthError = spectralWidth == 0 PPM;

				(* WaterSuppression can only be anything but None if Nucleus -> "1H" *)
				waterSuppressionError = MatchQ[waterSuppression, WaterSuppressionMethodP] && Not[MatchQ[specifiedNucleus, "1H"]];

				(* 30 Degree flip angle is not supported by our 19F method *)
				flipAngleNucleusError = MatchQ[specifiedNucleus, "19F"] && MatchQ[flipAngle, EqualP[30 AngularDegree]];

				(* 30 Degree flip angle is not supported by Excitation Sculpting and WATERGATE water suppression method *)
				flipAngleWaterSuppressionError = MatchQ[flipAngle, EqualP[30 AngularDegree]] && MatchQ[waterSuppression, WATERGATE|ExcitationSculpting];

				(* calculate the length of one spectrum to be calculated *)
				lengthOfOneSpectrum = numberOfScans * (acquisitionTime + relaxationDelay);

				(* pull the timed options out *)
				{
					specifiedTimeCourse,
					specifiedTimeInterval,
					specifiedNumTimeIntervals,
					specifiedTotalTimeCourse
				} = Lookup[options, {TimeCourse, TimeInterval, NumberOfTimeIntervals, TotalTimeCourse}];

				(* resolve the master switch; if specified obviously that is fine; if not, False if all the other timed options are  *)
				timeCourse = Which[
					BooleanQ[specifiedTimeCourse], specifiedTimeCourse,
					MatchQ[{specifiedTimeInterval, specifiedNumTimeIntervals, specifiedTimeCourse}, {Automatic, Automatic, Automatic}], False,
					True, True
				];

				(* resolve the TimeInterval option *)
				(* 1.) If specified, obviously pick *)
				(* 2.) If not specified but NumberOfTimeIntervals and TotalTimeCourse are specified, then do TotalTimeCourse / NumberOfTimeIntervals *)
				(* 3.) If not specified otherwise but TimeCourse -> True, set to lengthOfOneSpectrum + 1 Minute*)
				(* 4.) Otherwise, set to Null *)
				timeInterval = Which[
					TimeQ[specifiedTimeInterval], specifiedTimeInterval,
					IntegerQ[specifiedNumTimeIntervals] && TimeQ[specifiedTotalTimeCourse], Quiet[RoundOptionPrecision[specifiedTotalTimeCourse / specifiedNumTimeIntervals, 10^0 Second]],
					timeCourse, lengthOfOneSpectrum + 1 Minute,
					True, Null
				];

				(* resolve the NumberOfTimeIntervals option *)
				(* 1.) If specified, obviously pick *)
				(* 2.) If not specified but TotalTimeCourse is specified, then do TotalTimeCourse / TimeInterval, rounded down *)
				(* 3.) If not specified but TimeCourse -> True, set to 10 *)
				(* 4.) Otherwise, set to Null *)
				numberOfTimeIntervals = Which[
					IntegerQ[specifiedNumTimeIntervals], specifiedNumTimeIntervals,
					TimeQ[specifiedTotalTimeCourse] && TimeQ[timeInterval], Quiet[RoundOptionPrecision[specifiedTotalTimeCourse / timeInterval + 1, Round -> Down]],
					timeCourse, 10,
					True, Null
				];

				(* resolve the TotalTimeCourse option *)
				(* 1.) If specified, obviously pick *)
				(* 2.) If not specified but TimeCourse -> True, then do NumberOfTimeIntervals * TimeInterval *)
				(* 3.) Otherwise, set to Null *)
				totalTimeCourse = Which[
					TimeQ[specifiedTotalTimeCourse], specifiedTotalTimeCourse,
					timeCourse && TimeQ[timeInterval] && IntegerQ[numberOfTimeIntervals], SafeRound[numberOfTimeIntervals * timeInterval, 10^0 Second],
					True, Null
				];

				(* flip the error switch if TimeInterval, TotalTimeCourse, and NumberOfTimeIntervals don't agree with each other*)
				(* also we are fine if any of the time course options are Null/False *)
				kineticOptionMismatchError = If[Not[timeCourse] || NullQ[timeInterval] || NullQ[totalTimeCourse] || NullQ[numberOfTimeIntervals],
					False,
					SafeRound[totalTimeCourse / timeInterval, 10^0, RoundAmbiguous -> Down] != numberOfTimeIntervals
				];

				(* flip the error switch if any of the time course options are specified but Nucleus is not Proton *)
				kineticOptionNotProtonError = If[Not[timeCourse] || NullQ[timeInterval] || NullQ[totalTimeCourse] || NullQ[numberOfTimeIntervals],
					False,
					Not[MatchQ[specifiedNucleus, "1H"]]
				];

				(* flip the error switch if some of the kinetic options but others are Null*)
				kineticOptionsRequiredTogetherError = Not[Or[
					TrueQ[timeCourse] && TimeQ[timeInterval] && IntegerQ[numberOfTimeIntervals] && TimeQ[totalTimeCourse],
					MatchQ[timeCourse, False] && NullQ[timeInterval] && NullQ[numberOfTimeIntervals] && NullQ[totalTimeCourse]
				]];

				(* flip the error switch if TimeInterval is less than the length of one spectrum *)
				timeIntervalTooSmallError = If[NullQ[timeInterval],
					False,
					timeInterval < lengthOfOneSpectrum
				];

				(* flip the error switch if TimeCourse and WaterSuppression are both populated *)
				waterSuppressionAndKineticError = TrueQ[timeCourse] && Not[MatchQ[waterSuppression, None]];
				
				(* resolve the UseExternalStandard *)
				useExternalStandard=Which[
					
					(* Use user specified value*)
					MatchQ[Lookup[options,UseExternalStandard],Except[Automatic]], Lookup[options,UseExternalStandard],
					
					(* Is user specified SealedCoaxialInsert, resolve to True *)
					MatchQ[Lookup[options,SealedCoaxialInsert],ObjectReferenceP[]],True,
					
					(* default to False*)
					True,False
					
				];
				
				(* Resolved SealedCoaxialInsert *)
				sealedCoaxialInsert=Which[
					
					(* User user specified value *)
					MatchQ[Lookup[options,SealedCoaxialInsert],Except[Automatic]],Lookup[options,SealedCoaxialInsert],
					
					(* resolved based on the master switch *)
					TrueQ[useExternalStandard],Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"],
					
					(* default to Null *)
					True, Null
					
				];
				
				(* Check for concflicting *)
				conflictingExternalStandardError=If[TrueQ[useExternalStandard],
					MatchQ[sealedCoaxialInsert,Null],
					MatchQ[sealedCoaxialInsert,Except[Null]]
				]; 
				
				(* For seared NMR tube cannot specify external standards *)
				invalidExernalStandarderror=And[TrueQ[Lookup[tubeModelPacket,PermanentlySealed]],TrueQ[useExternalStandard]];
				
				{
					numberOfScans,
					deuteratuedSolvent,
					numberOfDummyScans,
					acquisitionTime,
					relaxationDelay,
					pulseWidth,
					flipAngle,
					spectralDomain,
					waterSuppression,
					timeCourse,
					timeInterval,
					numberOfTimeIntervals,
					totalTimeCourse,
					useExternalStandard,
					sealedCoaxialInsert,
					nonStandardSolventWarning,
					waterSuppressionError,
					nmrTubeError,
					zeroSpectralWidthError,
					kineticOptionsRequiredTogetherError,
					kineticOptionNotProtonError,
					kineticOptionMismatchError,
					timeIntervalTooSmallError,
					waterSuppressionAndKineticError,
					conflictingExternalStandardError,
					invalidExernalStandarderror,
					flipAngleNucleusError,
					flipAngleWaterSuppressionError
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions, simulatedContainerModelPackets, nmrTubeModelPackets}
	]];

	(* --- Unresolvable error checking --- *)

	(* throw a message if DirectSpectralDomain has a length of zero *)
	zeroSpectralDomainSamples = PickList[simulatedSamples, zeroSpectralWidthErrors];
	zeroSpectralDomainOptions = If[MemberQ[zeroSpectralWidthErrors, True] && messages,
		(
			Message[Error::ZeroSpectralDomain, SpectralDomain, ObjectToString[zeroSpectralDomainSamples, Cache -> inheritedCache]];
			{SpectralDomain}
		),
		{}
	];

	(* generate the ZeroSpectralDomain errors for SpectralDomain *)
	zeroSpectralDomainTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, zeroSpectralWidthErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, zeroSpectralWidthErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the SpectralDomain has a length of greater than 0 PPM:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", the SpectralDomain has a length of greater than 0 PPM:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if using a nonstandard NMR solvent *)
	If[MemberQ[nonStandardSolventWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::NonStandardSolvent, NamedObject @ DeleteDuplicates[PickList[Lookup[roundedNMROptions, DeuteratedSolvent], nonStandardSolventWarnings]], Values[deuteratedSymbolsToSolvents[]]]
	];

	(* generate the NonStandardSolvent warnings *)
	nonStandardSolventWarningTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, nonStandardSolventWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, nonStandardSolventWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", a deuterated solvent is specified with the DeuteratedSolvent option:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", a deuterated solvent is specified with the DeuteratedSolvent option:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if WaterSuppression is not None and Nucleus -> Except[1H] *)
	waterSuppressionInvalidOptions = If[MemberQ[waterSuppressionErrors, True] && messages,
		(
			Message[Error::WaterSuppressionIncompatible, ObjectToString[PickList[simulatedSamples, waterSuppressionErrors], Cache -> simulatedCache]];
			{WaterSuppression, Nucleus}
		),
		{}
	];

	(* generate the WaterSuppressionIncompatible errors *)
	waterSuppressionTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, waterSuppressionErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, waterSuppressionErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", WaterSuppression is only set when Nucleus -> 1H:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", WaterSuppression is only set when Nucleus -> 1H:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if FlipAngle is 30 Degree and Nucleus -> 19F *)
	flipAngleNucleusInvalidOptions = If[MemberQ[flipAngleNucleusErrors, True] && messages,
		(
			Message[Error::No30DegFlipAngleFor19F, ObjectToString[PickList[simulatedSamples, flipAngleNucleusErrors], Cache -> simulatedCache]];
			{FlipAngle, Nucleus}
		),
		{}
	];

	(* generate the WaterSuppressionIncompatible errors *)
	flipAngleNucleusTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, flipAngleNucleusErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, flipAngleNucleusErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", FlipAngle is set to 90 AngularDegree when Nucleus -> 19F:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", FlipAngle is set to 90 AngularDegree when Nucleus -> 19F:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];


	(* throw a message if FlipAngle is 30 Degree and WaterSuppression is set to Excitation Sculpting or WATERGATE *)
	flipAngleWaterSuppressionInvalidOptions = If[MemberQ[flipAngleWaterSuppressionErrors, True] && messages,
		(
			Message[Error::No30DegFlipAngleForWaterSuppression, ObjectToString[PickList[simulatedSamples, flipAngleWaterSuppressionErrors], Cache -> simulatedCache], PickList[resolvedWaterSuppression, flipAngleWaterSuppressionErrors]];
			{FlipAngle, WaterSuppression}
		),
		{}
	];

	(* generate the WaterSuppressionIncompatible errors *)
	flipAngleWaterSuppressionTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, flipAngleWaterSuppressionErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, flipAngleWaterSuppressionErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", FlipAngle is set to 90 AngularDegree when SolventSuppression -> WATERGATE|ExcitationSculpting:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", FlipAngle is set to 90 AngularDegree when SolventSuppression -> WATERGATE|ExcitationSculpting:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples and NMR tubes that are incompatible with each other *)
	tubeIncompatibleSamples = PickList[simulatedSamples, nmrTubeErrors];
	tubeIncompatibleTubes = PickList[nmrTubes, nmrTubeErrors];

	(* throw a message if NMRTubes is not compatible with the current sample containers *)
	nmrTubeErrorOptions = If[MemberQ[nmrTubeErrors, True] && messages,
		(
			Message[Error::NMRTubesIncompatible, ObjectToString[tubeIncompatibleSamples, Cache -> simulatedCache], ObjectToString[tubeIncompatibleTubes, Cache -> simulatedCache]];
			{NMRTube}
		),
		{}
	];

	(* generate the NMRTubesIncompatible errors *)
	nmrTubeErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, nmrTubeErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, nmrTubeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", NMRTube is set to a tube with PermanentlySealed -> True if and only if the sample is already in a sealed NMR tube:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", NMRTube is set to a tube with PermanentlySealed -> True if and only if the sample is already in a sealed NMR tube:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if some kinetic options are specified but not others *)
	kineticOptionsRequiredTogetherErrorOptions = If[MemberQ[kineticOptionsRequiredTogetherErrors, True] && messages,
		(
			Message[Error::KineticOptionsRequiredTogether, ObjectToString[PickList[simulatedSamples, kineticOptionsRequiredTogetherErrors], Cache -> simulatedCache]];
			{TimeCourse, TimeInterval, NumberOfTimeIntervals, TotalTimeCourse}
		),
		{}
	];

	(* generate the KineticNMROptionsRequiredTogether errors *)
	kineticOptionsRequiredTogetherErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, kineticOptionsRequiredTogetherErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, kineticOptionsRequiredTogetherErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must not be Null, or if TimeCourse -> False, TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must be Null (or unspecified):",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must not be Null, or if TimeCourse -> False, TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse must be Null (or unspecified):",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if trying to do a kinetic run on something besides proton *)
	kineticOptionNotProtonErrorOptions = If[MemberQ[kineticOptionNotProtonErrors, True] && messages,
		(
			Message[Error::KineticOptionsIncompatibleNucleus, ObjectToString[PickList[simulatedSamples, kineticOptionNotProtonErrors], Cache -> simulatedCache]];
			{TimeCourse, Nucleus}
		),
		{}
	];

	(* generate the KineticOptionsIncompatibleNucleus errors *)
	kineticOptionNotProtonErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, kineticOptionNotProtonErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, kineticOptionNotProtonErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, Nucleus -> 1H:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, Nucleus -> 1H:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if the TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse options don't agree with each other mathematically *)
	kineticOptionMismatchErrorOptions = If[MemberQ[kineticOptionMismatchErrors, True] && messages,
		(
			Message[Error::KineticOptionMismatch, ObjectToString[PickList[simulatedSamples, kineticOptionMismatchErrors], Cache -> simulatedCache]];
			{TimeCourse, Nucleus}
		),
		{}
	];

	(* generate the KineticOptionMismatch errors *)
	kineticOptionMismatchErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, kineticOptionMismatchErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, kineticOptionMismatchErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse, if specified, must be specified such that TotalTimeCourse / TimeInterval + 1 (rounded down) equals NumberOfTimeIntervals:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse, if specified, must be specified such that TotalTimeCourse / TimeInterval + 1 (rounded down) equals NumberOfTimeIntervals:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples where TimeInterval is too small *)
	timeIntervalTooSmallSamples = PickList[simulatedSamples, timeIntervalTooSmallErrors];

	(* get the TimeInterval and length of one spectrum for when TimeInterval is too small*)
	timeIntervalTooSmallTimeIntervals = PickList[resolvedTimeInterval, timeIntervalTooSmallErrors];
	timeIntervalTooSmallSpectrumTime = PickList[resolvedNumberOfScans * resolvedAcquisitionTimes, timeIntervalTooSmallErrors];

	(* throw a message if the TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse options don't agree with each other mathematically *)
	timeIntervalTooSmallOptions = If[MemberQ[timeIntervalTooSmallErrors, True] && messages,
		(
			Message[Error::TimeIntervalTooSmall, ObjectToString[timeIntervalTooSmallSamples, Cache -> simulatedCache], timeIntervalTooSmallTimeIntervals, timeIntervalTooSmallSpectrumTime];
			{TimeInterval, AcquisitionTime, NumberOfScans}
		),
		{}
	];

	(* generate the TimeIntervalTooSmall errors *)
	timeIntervalTooSmallErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, timeIntervalTooSmallErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, timeIntervalTooSmallErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", TimeInterval (if specified) must be longer than NumberOfScans * AcquisitionTime:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", TimeInterval (if specified) must be longer than NumberOfScans * AcquisitionTime:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if TimeCourse is True and WaterSuppression is something besides None *)
	waterSuppressionAndKineticErrorOptions = If[MemberQ[waterSuppressionAndKineticErrors, True] && messages,
		(
			Message[Error::KineticOptionsWaterSuppression, ObjectToString[PickList[simulatedSamples, waterSuppressionAndKineticErrors], Cache -> simulatedCache]];
			{TimeCourse, WaterSuppression}
		),
		{}
	];

	(* generate the TimeIntervalTooSmall errors *)
	waterSuppressionAndKineticErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, waterSuppressionAndKineticErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, waterSuppressionAndKineticErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, then WaterSuppression must be None:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", if TimeCourse -> True, then WaterSuppression must be None:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];
	
	(* generate errors for conflicting external standard options *)
	invalidExernalStandardErrorOptions = If[MemberQ[invalidExernalStandardErrors, True] && messages,
		(
			Message[Error::SealedNMRTubeCannotUseExternalStandards, ObjectToString[PickList[simulatedSamples, invalidExernalStandardErrors], Cache -> simulatedCache]];
			{UseExternalStandard, NMRTube}
		),
		{}
	];
	
	(* generate the tests *)
	invalidExernalStandardErrorTests = If[gatherTests,
		Module[{failingSamples, failingSampleTests},
			
			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, invalidExernalStandardErrors];
			
			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", UseExternalStandard cannot be used for a permanentlySealed NMRTube:",
					False,
					True
				],
				Nothing
			];
			
			(* return the created tests *)
			{failingSampleTests}
		
		]
	];
	
	(* generate errors for conflicting external standard options *)
	conflictingExternalStandardErrorOptions = If[MemberQ[conflictingExternalStandardErrors, True] && messages,
		(
			Message[Error::ConflictingExternalStandardOptions, ObjectToString[PickList[simulatedSamples, conflictingExternalStandardErrors], Cache -> simulatedCache]];
			{UseExternalStandard, SealedCoaxialInsert}
		),
		{}
	];
	
	(* generate the tests *)
	conflictingExternalStandardErrorTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},
			
			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, conflictingExternalStandardErrors];
			
			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, conflictingExternalStandardErrors, False];
			
			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", SealedCoaxialInsert cannot be specified when UserExternalStandard is False:",
					False,
					True
				],
				Nothing
			];
			
			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", SealedCoaxialInsert must be specified when UserExternalStandard is True:",
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

	(* pre-resolve the Aliquot option because this will determine stuff with handling solids *)
	(* basically, is True if it is set to True or any of the aliquot options were set *)
	preResolvedAliquotBool = MapThread[
		Function[{aliquot, aliquotAmount, targetConc, assayVolume, aliquotContainer, destWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, aliquotStorage, containerModelPacket},
			Which[
				TrueQ[aliquot], True,
				MatchQ[aliquot, False], False,
				(* if in a sealed NMR tube, always resolve to False if it wasn't directly set because we never want to aliquot out of this guy since it's sealed and can't be opened *)
				MatchQ[containerModelPacket, ObjectP[Model[Container]]] && MatchQ[Lookup[containerModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}], False,
				Or[
					MatchQ[aliquotAmount, MassP|VolumeP|NumericP],
					MatchQ[targetConc, ConcentrationP|MassConcentrationP],
					VolumeQ[assayVolume],
					Not[MatchQ[aliquotContainer, Automatic|{Automatic, Automatic}|Null|{Null, Null}]],
					MatchQ[destWell, WellP],
					MatchQ[concBuffer, ObjectP[]],
					MatchQ[bufferDilutionFactor, NumericP],
					MatchQ[bufferDiluent, ObjectP[]],
					MatchQ[assayBuffer, ObjectP[]],
					Not[MatchQ[aliquotStorage,Automatic | Null]]
				], True,
				True, False
			]
		],
		Join[Lookup[myOptions, {Aliquot, AliquotAmount, TargetConcentration, AssayVolume, AliquotContainer, DestinationWell, ConcentratedBuffer, BufferDilutionFactor, BufferDiluent, AssayBuffer, AliquotSampleStorageCondition}], {simulatedContainerModelPackets}]
	];

	(* get the volumes/masses/counts of the simulated samples *)
	{simulatedVolumes, simulatedMasses, simulatedCounts} = Transpose[Download[simulatedSamples, {Volume, Mass, Count}, Cache -> simulatedCache, Date -> Now]];

	(* we want to be aliquoting into a 2mL tube if necessary *)
	(* we don't want to aliquot just because we need to move into a 2mL tube because who cares; only aliquot to a 2mL tube if we're already aliquoting *)
	targetContainers = MapThread[
		Function[{aliquotBool, aliquotContainer},
			Which[
				MatchQ[aliquotContainer, ObjectP[]], aliquotContainer,
				MatchQ[aliquotContainer, {_, ObjectP[]}], aliquotContainer[[2]],
				aliquotBool, Model[Container, Vessel, "2mL Tube"],
				True, Null
			]
		],
		{preResolvedAliquotBool, Lookup[myOptions, AliquotContainer]}
	];

	(* get the specified sample amount *)
	specifiedSampleAmount = Lookup[myOptions, SampleAmount];

	(* get the RequiredAliquotAmount. Note that this must always be greater than the specified SampleAmount *)
	(* if SampleAmount is Null, set to 50 microliter because we need to fake it anyway *)
	(* if the sample is a liquid then we will aliquot 50 uL.  If it is a solid, we will say 10 mg or 50 uL because they might have specified things such that it is dissolved in something*)
	(* if SampleAmount was specified, just do 10% higher than that value *)
	requiredAliquotAmounts = MapThread[
		Which[
			MatchQ[#2, Automatic|Null] && VolumeQ[Lookup[#1, Volume]], 50*Microliter,
			MatchQ[#2, Automatic|Null] && MassQ[Lookup[#1, Mass]], {10*Milligram, 50*Microliter},
			True, #2 * 1.1
		]&,
		{samplePackets, specifiedSampleAmount}
	];

	(* resolve the aliquot options *)
	(* we are cool with having solids here *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		(* we are cool with having solids here *)
		resolveAliquotOptions[ExperimentNMR, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, Flatten[{resolvedSamplePrepOptions, Aliquot -> preResolvedAliquotBool}]], Cache -> simulatedCache, RequiredAliquotContainers -> targetContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> True, Output -> {Result, Tests}],
		{resolveAliquotOptions[ExperimentNMR, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, Flatten[{resolvedSamplePrepOptions, Aliquot -> preResolvedAliquotBool}]], Cache -> simulatedCache, RequiredAliquotContainers -> targetContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> True, Output -> Result], {}}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* pull out the resolved assay volume and AliquotAmount *)
	resolvedAssayVolume = Lookup[resolvedAliquotOptions, AssayVolume];
	resolvedAliquotAmount = Lookup[resolvedAliquotOptions, AliquotAmount];

	(* get the simulated amount based on the above values *)
	simulatedAmounts = MapThread[
		Function[{volume, mass, count},
			Which[
				VolumeQ[volume], volume,
				MatchQ[count, GreaterP[0., 1.]], count,
				True, mass
			]
		],
		{simulatedVolumes, simulatedMasses, simulatedCounts}
	];

	(* need to do a second MapThread to resolve the SampleAmount option; need to do it here because we don't know what the sate of the sample is going to be until after we resolve the aliquot options *)
	{
		resolvedSampleAmount,
		resolvedSolventVolume,
		sampleAmountStateErrors,
		sampleAmountTooHighErrors,
		sampleAmountNullErrors
	} = Transpose[MapThread[
		Function[{simulatedVolume, simulatedMass, simulatedCount, options, assayVolume, aliquotAmount, containerModelFootprint, useExternalStandards},
			Module[
				{sampleAmountStateError, state, sampleAmount, sampleAmountTooHighError, solventVolume, preResolvedSolventVolume,
					specifiedSolventVolume, sampleAmountNullError, roundedSampleAmount},

				(* set the error checking Booleans here *)
				{sampleAmountStateError, sampleAmountTooHighError} = {False, False};

				(* figure out what the state of the sample is going to be after aliquoting *)
				(* if AssayVolume is populated, we're going to have a liquid *)
				(* if AssayVolume is _not_ populated and we have a counted item, then it's still going to be counted after aliquoting *)
				(* if AssayVolume is _not_ populated and we have a liquid item, then it's still going to be liquid after aliquoting *)
				(* if AssayVolume is _not_ populated and we have a solid item, then it's still going to be solid after aliquoting *)
				state = Which[
					VolumeQ[assayVolume], Liquid,
					MatchQ[simulatedCount, GreaterP[0., 1.]], Count,
					VolumeQ[simulatedVolume], Liquid,
					True, Solid
				];

				(* pull out the specified solvent volume *)
				specifiedSolventVolume = Lookup[options, SolventVolume];

				(* pre-resolve the solvent volume; it's a little goofy because both the SampleAmount and SolventVolume options need to inform each other's resolution *)
				(* if it is Automatic and containerModel is an NMR tube and aliquotAmount is Null, then resolve to Null *)
				preResolvedSolventVolume = If[MatchQ[specifiedSolventVolume, Automatic] && MatchQ[containerModelFootprint, NMRTube] && NullQ[aliquotAmount],
					Null,
					specifiedSolventVolume
				];

				(* resolve the SampleAmount volume based on what the state is that we got above *)
				sampleAmount = Which[
					(* if SampleAmount was specified directly, then just go with that *)
					MatchQ[Lookup[options, SampleAmount], Except[Automatic]], Lookup[options, SampleAmount],
					(* if we're Automatic and solventVolume is Null, resolve this to Null as well *)
					NullQ[preResolvedSolventVolume], Null,
					(* if we're Automatic and dealing with a counted sample, resolve just to 1 *)
					MatchQ[state, Count], 1,
					(* if we're dealing with a solid but not aliquoting, take the smaller of 5 milligram or the current mass of the sample (and do a DeleteCases of Null here in case Mass is Null; there is going to be error checking there anyway so just make sure it doesn't crash here) *)
					MatchQ[state, Solid] && NullQ[aliquotAmount], Min[DeleteCases[{5*Milligram, simulatedMass}, Null]],
					(* if we're dealing with a solid and aliquoting, take the smaller of 5 milligram or the aliquot amount *)
					MatchQ[state, Solid], Min[{5*Milligram, aliquotAmount}],
					(* if we're dealing with a liquid but not aliquoting, take the smaller of 10 microliter or the current volume of the sample (and do the same Null trick as above) *)
					MatchQ[state, Liquid] && NullQ[assayVolume], Min[DeleteCases[{10*Microliter, simulatedVolume}, Null]],
					(* if we're dealing with a liquid and aliquoting, take the smaller of 10 microliter or the aliquot amount *)
					MatchQ[state, Liquid], Min[{10*Microliter, aliquotAmount}]
				];

				(* round the sample amount *)
				roundedSampleAmount = Which[
					NullQ[sampleAmount], Null,
					MatchQ[state, Solid], RoundOptionPrecision[sampleAmount, 10^-1 Milligram],
					MatchQ[state, Liquid], RoundOptionPrecision[sampleAmount, 10^-1 Microliter],
					MatchQ[state, Count], sampleAmount
				];

				(* resolve the SolventVolume option *)
				(* if SolventVolume is set directly, just pick that value *)
				(* otherwise, if we resolved to use the external standards,resolve to use 400 Microliter - roundedSampleAmoun,resolve to 700 Microliter - roundedSampleAmount (if a volume) *)
				(* otherwise, if we resolved to use the external standards,set to use 400 Microliter,else just 700 Microliter *)
				(* we need extra room for coaxialinserts *)
				solventVolume = Which[
					MatchQ[preResolvedSolventVolume, Except[Automatic]], preResolvedSolventVolume,
					useExternalStandards && VolumeQ[roundedSampleAmount], Max[{400 Microliter - roundedSampleAmount, 0 Microliter}],
					VolumeQ[roundedSampleAmount], Max[{700 Microliter - roundedSampleAmount, 0 Microliter}],
					useExternalStandards,400 Microliter,
					True, 700 Microliter
				];

				(* flip the sampleAmountStateError switch if the resolved sample amount doesn't correspond to the sample's state (if it is Null that is fine; we will have thrown errors elsewhere) *)
				sampleAmountStateError = Or[
					MatchQ[state, Count] && Not[MatchQ[roundedSampleAmount, Null|GreaterP[0, 1]]],
					MatchQ[state, Solid] && Not[MatchQ[roundedSampleAmount, Null|MassP]],
					MatchQ[state, Liquid] && Not[MatchQ[roundedSampleAmount, Null|VolumeP]]
				];

				(* flip the sampleAmountTooHighError switch if the volume/mass/count of the simulated sample is going to be too low to fulfill the specified SampleAmount *)
				sampleAmountTooHighError = Which[
					(* if the SampleAmount is in the wrong state, then we're already just going to say this error is fine because we can't properly check it anyway *)
					sampleAmountStateError, False,
					(* if a liquid/solid/counted, flip the switch if the sampleAmount is more than the simulated amount *)
					MatchQ[state, Liquid], roundedSampleAmount > simulatedVolume,
					MatchQ[state, Solid], roundedSampleAmount > simulatedMass,
					True, roundedSampleAmount > simulatedCount
				];

				(* flip the switch if we are already in an NMR tube and aren't aliquoting and one or both of sampleAmount/solventVolume are not Null, or if we aren't and one or both of sampleAmount/solventVolume are Null*)
				sampleAmountNullError = If[NullQ[aliquotAmount] && MatchQ[containerModelFootprint, NMRTube],
					Not[NullQ[roundedSampleAmount]] || Not[NullQ[solventVolume]],
					NullQ[roundedSampleAmount] || NullQ[solventVolume]
				];


				{roundedSampleAmount, solventVolume, sampleAmountStateError, sampleAmountTooHighError, sampleAmountNullError}

			]
		],
		{simulatedVolumes, simulatedMasses, simulatedCounts, mapThreadFriendlyOptions, resolvedAssayVolume, resolvedAliquotAmount, If[NullQ[#], Null, Lookup[#, Footprint, {}]]& /@ simulatedContainerModelPackets,resolvedUseExternalStandards}
	]];

	(* throw an error if the state and resolved SampleAmount don't agree with each other *)
	sampleAmountStateOptions = If[MemberQ[sampleAmountStateErrors, True] && messages,
		(
			Message[Error::SampleAmountStateConflict, ObjectToString[PickList[simulatedSamples, sampleAmountStateErrors], Cache -> simulatedCache], ObjectToString[PickList[resolvedSampleAmount, sampleAmountStateErrors]]];
			{SampleAmount}
		),
		{}
	];

	(* generate the SampleAmountStateConflict tests *)
	sampleAmountStateTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], sampleAmountStateErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], sampleAmountStateErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the state after aliquoting (if applicable) is compatible with the units of the corresponding specified SampleAmount:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", the state after aliquoting (if applicable) is compatible with the units of the corresponding specified SampleAmount:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw an error if the SampleAmount is too high relative to the amount in the sample *)
	sampleAmountTooHighOptions = If[MemberQ[sampleAmountTooHighErrors, True] && messages,
		(
			Message[Error::SampleAmountTooHigh, ObjectToString[PickList[resolvedSampleAmount, sampleAmountTooHighErrors]], ObjectToString[PickList[simulatedAmounts, sampleAmountTooHighErrors]], ObjectToString[PickList[simulatedSamples, sampleAmountTooHighErrors], Cache -> simulatedCache]];
			{SampleAmount}
		),
		{}
	];

	(* generate the SampleAmountTooHigh tests *)
	sampleAmountTooHighTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[samplePackets, Object, {}], sampleAmountTooHighErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[samplePackets, Object, {}], sampleAmountTooHighErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " the specified SampleAmount option is less than or equal to the amount of that sample after sample prep:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " the specified SampleAmount option is less than or equal to the amount of that sample after sample prep:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw an error if SampleAmount or SolventVolume is set to Null when using an already-existing NMR tube, or set to Not-Null otherwise *)
	sampleAmountNullOptions = If[MemberQ[sampleAmountNullErrors, True] && messages,
		(
			Message[Error::SampleAmountNull, ObjectToString[PickList[simulatedSamples, sampleAmountNullErrors], Cache -> simulatedCache]];
			{SampleAmount, SolventVolume}
		),
		{}
	];

	(* generate the SampleAmountTooHigh tests *)
	sampleAmountNullTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, sampleAmountNullErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, sampleAmountNullErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " SolventVolume and SampleAmount are Null if and only if the sample is already in an NMR tube:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " SolventVolume and SampleAmount are Null if and only if the sample is already in an NMR tube:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get whether the SamplesInStorage option is ok *)
	samplesInStorage = Lookup[myOptions, SamplesInStorageCondition];

	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
		ValidContainerStorageConditionQ[mySamples, samplesInStorage, Output -> {Result, Tests}, Cache -> simulatedCache],
		{ValidContainerStorageConditionQ[mySamples, samplesInStorage, Output -> Result, Cache -> simulatedCache], {}}
	];
	validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];


	(* combine the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		sampleAmountStateOptions,
		sampleAmountTooHighOptions,
		unsupportedNMRTubeOptions,
		waterSuppressionInvalidOptions,
		nmrTubeErrorOptions,
		sampleAmountNullOptions,
		zeroSpectralDomainOptions,
		validContainerStoragConditionInvalidOptions,
		kineticOptionsRequiredTogetherErrorOptions,
		kineticOptionNotProtonErrorOptions,
		kineticOptionMismatchErrorOptions,
		timeIntervalTooSmallOptions,
		waterSuppressionAndKineticErrorOptions,
		conflictingExternalStandardErrorOptions,
		invalidExernalStandardErrorOptions,
		flipAngleNucleusInvalidOptions,
		flipAngleWaterSuppressionInvalidOptions
	}]];

	(* combine the invalid inputs together *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		tooManySamplesInputs,
		compatibleMaterialsInvalidInputs
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
		discardedTest,
		deprecatedTest,
		tooManySamplesTest,
		unsupportedNMRTubeTest,
		validNameTest,
		sampleAmountStateTests,
		nonStandardSolventWarningTests,
		sampleAmountTooHighTests,
		waterSuppressionTests,
		nmrTubeErrorTests,
		sampleAmountNullTests,
		zeroSpectralDomainTests,
		kineticOptionsRequiredTogetherErrorTests,
		kineticOptionNotProtonErrorTests,
		kineticOptionMismatchErrorTests,
		timeIntervalTooSmallErrorTests,
		waterSuppressionAndKineticErrorTests,
		conflictingExternalStandardErrorTests,
		invalidExernalStandardErrorTests,
		flipAngleNucleusTests,
		flipAngleWaterSuppressionTests
	}], _EmeraldTest];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{confirm, template, cache, operator, upload, outputOption, subprotocolDescription, samplesOutStorage, samplePreparation} = Lookup[myOptions, {Confirm, Template, Cache, Operator, Upload, Output, SubprotocolDescription, SamplesOutStorageCondition, PreparatoryUnitOperations}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
		True, Lookup[myOptions, Email]
	];

	(* --- Do the final preparations --- *)

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = Flatten[{
		NumberOfReplicates -> numberOfReplicates,
		Nucleus -> nucleus,
		DeuteratedSolvent -> resolvedDeuteratedSolvents,
		SolventVolume -> resolvedSolventVolume,
		SampleAmount -> resolvedSampleAmount,
		SampleTemperature -> sampleTemperature,
		NumberOfScans -> resolvedNumberOfScans,
		NumberOfDummyScans -> resolvedNumberOfDummyScans,
		AcquisitionTime -> resolvedAcquisitionTimes,
		RelaxationDelay -> resolvedRelaxationDelays,
		PulseWidth -> resolvedPulseWidths,
		FlipAngle -> resolvedFlipAngles,
		SpectralDomain -> resolvedSpectralDomains,
		WaterSuppression -> resolvedWaterSuppression,
		TimeCourse -> resolvedTimeCourse,
		TimeInterval -> resolvedTimeInterval,
		NumberOfTimeIntervals -> resolvedNumberOfTimeIntervals,
		TotalTimeCourse -> resolvedTotalTimeCourse,
		NMRTube -> nmrTubes,
		Instrument -> instrument,
		UseExternalStandard -> resolvedUseExternalStandards,
		SealedCoaxialInsert -> resolvedSealedCoaxialInserts, 
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


(* ::Subsection:: *)
(*nmrResourcePackets*)

DefineOptions[
	nmrResourcePackets,
	Options :> {HelperOutputOption, CacheOption}
];


(* create the protocol packet with resource blobs included *)
nmrResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[nmrResourcePackets]]:=Module[
	{expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, samplePackets, numReplicates, expandedSimulatedSamplesWithNumReplicates, tubeOption, tubeResources,
		nmrTime, nmrResource, expandedAliquotAmount, sampleAmountsToReserve, pairedSamplesInAndVolumes, nmrTubeRack, nmrTubeRackPacket,
		sampleAmounts, sampleAmountRules, sampleResourceReplaceRules, samplesInResources, expandForNumReplicates,
		expandedNuclei, expandedSolvents, expandedSolventVolume, expandedSampleAmount, expandedSampleTemperature,
		expandedNumScans, expandedAcquisitionTime, expandedPulseWidth, expandedSpectralDomain, expandedWaterSuppression,
		containersIn, protocolPacket, sharedFieldPacket, finalizedPacket, allResourceBlobs, fulfillable, frqTests,
		previewRule, optionsRule, testsRule, resultRule, runTime, nmrTubeRackResource, aliquotQs, allDownloadValues,
		containerModelPackets, simulatedSamples, simulatedCache, depthGaugeResource, nmrSpinnerResources, expandedContainerModelPackets,
		expandedSamplesInStorage, expandedSamplesOutStorage, containerObjs, expandedSamplesWithNumReplicates,
		maxTubeRackHeight, needsTallTubeQ, expandedTimeCourse, expandedTimeInterval, expandedNumberOfTimeIntervals,
		expandedTotalTimeCourse, expandedRelaxationDelay, expandedNumDummyScans, expandedUseExternalStandard,
		expandedSealedCoaxialInsert, sealedCoaxialInsertContainerResources, tweezerResource, fumeHoodResource,
		insertsWashWasteContainerResource, combinedFastAssoc,tubeInsertLookup, expandedFlipAngle},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentNMR, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentNMR,
		RemoveHiddenOptions[ExperimentNMR, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(*get the cache*)
	inheritedCache = Lookup[ToList[ops], Cache, {}];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, simulatedCache} = simulateSamplesResourcePackets[ExperimentNMR, mySamples, myResolvedOptions, Cache -> inheritedCache];

	(* --- Make our one big Download call --- *)

	(* make our one big Download call *)
	allDownloadValues = Download[
		{
			simulatedSamples,
			mySamples
		},
		{
			{
				Packet[Container, Volume],
				Packet[Container[Model][{Object, Dimensions, Footprint}]]
			},
			{Container[Object]}
		},
		Cache -> simulatedCache,
		Date -> Now
	];
	
	(* Make combined fast association *)
	combinedFastAssoc=makeFastAssocFromCache[FlattenCachePackets[{inheritedCache, simulatedCache}]];
	
	(* split out the sample packets and the container models and the original objects *)
	samplePackets = allDownloadValues[[1, All, 1]];
	containerModelPackets = allDownloadValues[[1, All, 2]];
	containerObjs = Flatten[allDownloadValues[[2]]];

	(* Note that this is hard coded in the above Experiment function too so if you change that then you have to change it here too *)
	nmrTubeRack = Model[Container, Rack, "SampleJet NMR Tube Rack"];
	nmrTubeRackPacket = fetchPacketFromCache[Download[nmrTubeRack, Object], inheritedCache];

	(* --- Make all the resources needed in the experiment --- *)

	(* pull out the number of replicates; make sure all Nulls become 1 *)
	numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* expand the samples according to the number of replicates *)
	(* need to Download Object because we will be merging later *)
	(* need to do this with samples _and_ simulated samples *)
	expandedSimulatedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		samplePackets
	]];
	expandedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		Download[mySamples, Object]
	]];

	(* we need to expand lots of the options to include number of replicates; making a function that just does this *)
	(* map over the provided option names; for each one, expand the value for it by the number of replicates*)
	expandForNumReplicates[myExpandedOptions:{__Rule}, myOptionNames:{__Symbol}, myNumberOfReplicates_Integer]:=Module[
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

	(* pull out the aliquot option *)
	{
		aliquotQs,
		tubeOption,
		expandedSolvents,
		expandedSolventVolume,
		expandedSampleAmount,
		expandedSealedCoaxialInsert
	} = expandForNumReplicates[expandedResolvedOptions, {Aliquot, NMRTube, DeuteratedSolvent, SolventVolume, SampleAmount,SealedCoaxialInsert}, numReplicates];

	(* need to expand container models to have num replicates expansion too *)
	expandedContainerModelPackets = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		containerModelPackets
	]];

	(* note that these need to be unique resources so we need to use Table and not ConstantArray here *)
	(* if we're already in NMR tubes, then we just need to pick the specific object and not the model *)
	tubeResources = MapThread[
		Function[{tubeModel, aliquotQ, containerModelPacket, sampleContainer, sample, tube, solvent, solventVolume, sampleAmount,sealedCoaxialInsert},
			If[MatchQ[Lookup[containerModelPacket, Footprint], NMRTube] && Not[aliquotQ],
				Resource[Sample -> sampleContainer, Name -> ToString[sampleContainer]],
				(* note that this name means that if we have duplicate all the way through the simulation AND the tube/solvent/solvent volume/sample amount are the same then we want these resources to be the same *)
				Resource[Sample -> tubeModel, Rent -> False, Name -> StringJoin[ToString[sample], ToString[tube], ToString[solvent], ToString[solventVolume], ToString[sampleAmount],ToString[sealedCoaxialInsert]]]
			]
		],
		{tubeOption, aliquotQs, expandedContainerModelPackets, Download[Lookup[expandedSimulatedSamplesWithNumReplicates, Container], Object], Lookup[expandedSimulatedSamplesWithNumReplicates, Object], tubeOption, Download[expandedSolvents /. deuteratedSymbolsToSolvents[], Object], expandedSolventVolume, expandedSampleAmount,expandedSealedCoaxialInsert}
	];

	(* get the maximum height for the NMRTubeRack *)
	maxTubeRackHeight = First[Lookup[Lookup[nmrTubeRackPacket, Positions], MaxHeight]];

	(* determine if we can use the autosampler or if we need to use a spinner for each container *)
	needsTallTubeQ = Map[
		MatchQ[Lookup[#, {Footprint, Dimensions}], {NMRTube, {_, _, GreaterP[maxTubeRackHeight]}}]&,
		expandedContainerModelPackets
	];

	(* make a resource for the DepthGauge field; need one if at least one of the input containers is too large to fit into the autosampler rack need to use spinners/ depth gauge *)
	depthGaugeResource = If[MemberQ[needsTallTubeQ, True],
		Resource[Sample -> Model[Part, NMRDepthGauge, "Bruker Sample Depth Gauge"], Rent -> True],
		Null
	];

	(* make resources for the NMRSpinners field; Null for the indices where we don't need a spinner *)
	nmrSpinnerResources = MapThread[
		If[TrueQ[#1],
			Resource[Sample -> Model[Container, NMRSpinner, "Standard Bore POM Spinner"], Name -> StringJoin["Spinner resource ", #2[Name]], Rent -> True],
			Null
		]&,
		{needsTallTubeQ, tubeResources}
	];

	(* use the resolved options to come up with a time estimate for how long until all the experiments are done *)
	(* the acquisition time * num scans tells us how long each individaul run will take, and add 5 minutes to each to account for locking/shimming/etc *)
	(* if we're doing kinetic runs, then go off the TotalTimeCourse instead *)
	runTime = Total[MapThread[
		If[TimeQ[#5],
			#5 + 5 Minute,
			(#1 + #2) * (#3 + #4) + 5*Minute
		]&,
		{Lookup[myResolvedOptions, AcquisitionTime], Lookup[myResolvedOptions, RelaxationDelay], Lookup[myResolvedOptions, NumberOfScans], Lookup[myResolvedOptions, NumberOfDummyScans], Lookup[myResolvedOptions, TotalTimeCourse]}
	]];

	(* Estimate the amount of NMR time by taking the runTime calculated above *)
	(* this mainly includes the run time of the experiment itself and the loading of the NMR tubes; hard to estimate too well here but let's say it takes 20 minutes per sample and then 10 minutes of overhead for everything else *)
	nmrTime = runTime + (20*Minute * Length[mySamples]) + 10*Minute;

	(* make the resource for the nmr instrument *)
	nmrResource = Resource[Instrument -> Lookup[myResolvedOptions, Instrument], Time -> nmrTime];

	(* make the resource for the NMR tube rack *)
	(* if we are using none of the rackable NMR tubes (i.e., all the NMR tubes are too long to fit into the autosampler), then be Null instead *)
	nmrTubeRackResource = If[MatchQ[needsTallTubeQ, {True..}],
		Null,
		Resource[Sample -> nmrTubeRack, Rent -> True]
	];

	(* pull out the AliquotAmount and SampleAmount options *)
	{expandedAliquotAmount, sampleAmounts} = Lookup[expandedResolvedOptions, {AliquotAmount, SampleAmount}];

	(* get the sample volume; if we're aliquoting, use that amount; otherwise it's going to be what was specified in the SampleAmount field *)
	sampleAmountsToReserve = Flatten[MapThread[
		If[Not[NullQ[#1]],
			ConstantArray[#1, numReplicates],
			ConstantArray[#2, numReplicates]
		]&,
		{expandedAliquotAmount, sampleAmounts}
	]];

	(* pair the SamplesIn and their Volumes; need to also use the resource names for the tubes because this is how we figured out uniqueness and will be useful for the DeleteDuplicates call below *)
	pairedSamplesInAndVolumes = MapThread[
		{#1, #2[Name]} -> #3&,
		{expandedSamplesWithNumReplicates, tubeResources, sampleAmountsToReserve}
	];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleAmountRules = Merge[DeleteDuplicates[pairedSamplesInAndVolumes], Total];

	(* make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sampleAndName, amount},
			If[VolumeQ[amount] || MassQ[amount] || MatchQ[amount, GreaterP[0., 1.]],
				First[sampleAndName] -> Resource[Sample -> First[sampleAndName], Name -> StringJoin["Sample resource ", Last[sampleAndName]], Amount -> amount],
				First[sampleAndName] -> Resource[Sample -> First[sampleAndName], Name -> StringJoin["Sample resource ", Last[sampleAndName]]]
			]
		],
		sampleAmountRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* --- Generate the protocol packet --- *)

	(* expand all the options ot account for number of replicates *)
	{
		expandedNuclei,
		expandedSampleTemperature,
		expandedNumScans,
		expandedNumDummyScans,
		expandedAcquisitionTime,
		expandedRelaxationDelay,
		expandedPulseWidth,
		expandedFlipAngle,
		expandedSpectralDomain,
		expandedWaterSuppression,
		expandedTimeCourse,
		expandedTimeInterval,
		expandedNumberOfTimeIntervals,
		expandedTotalTimeCourse,
		expandedSamplesInStorage,
		expandedSamplesOutStorage,
		expandedUseExternalStandard
	} = expandForNumReplicates[
		expandedResolvedOptions,
		{
			Nucleus,
			SampleTemperature,
			NumberOfScans,
			NumberOfDummyScans,
			AcquisitionTime,
			RelaxationDelay,
			PulseWidth,
			FlipAngle,
			SpectralDomain,
			WaterSuppression,
			TimeCourse,
			TimeInterval,
			NumberOfTimeIntervals,
			TotalTimeCourse,
			SamplesInStorageCondition,
			SamplesOutStorageCondition,
			UseExternalStandard
		},
		numReplicates
	];
	
	(* For each unique nmr tube, we will give them a unique insert resources if neccessary *)
	tubeInsertLookup=Map[
		(#->Resource[Sample -> Model[Container, Bag, "2 x 3 Inch Plastic Bag For NMR Sealed Inserts"], Name -> ToString[CreateUUID[]], Rent -> True])&,
		DeleteDuplicates[tubeResources]
	];
	
	(* Resource for expandedSealedCoaxialInsert *)
	sealedCoaxialInsertContainerResources=MapThread[
		If[
			(* If user specified the Model of the insert, we hardcode the bag we use to store the insert as the container resource *)
			MatchQ[#1,ObjectP[Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]]],
			Link[Lookup[tubeInsertLookup,#2]],
			
			Null
		]&,
		{expandedSealedCoaxialInsert,tubeResources}
	];
	
	(* generate the resource for tweezer, this is used to move and recover the coaxial inserts *)
	tweezerResource=If[MemberQ[expandedUseExternalStandard,True],Link[Resource[Sample->Model[Item, Tweezer, "Straight flat tip tweezer"],Rent->True]],Null];
	
	(* We also gonna ask the transfer of coaxial inserts to be finished in a fume hood *)
	fumeHoodResource = If[MemberQ[expandedUseExternalStandard,True],Link[Resource[Instrument -> Model[Instrument, FumeHood, "Labconco Premier 6 Foot"], Time -> 1Hour]],Null];
	insertsWashWasteContainerResource = If[MemberQ[expandedUseExternalStandard,True],Link[Resource[Sample->Model[Container, Vessel, "250mL Kimax Beaker"],Rent->True,Name->ToString[Unique[]]]],Null];
	
	(* get the ContainersIn with no Duplicates *)
	containersIn = DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]];

	(* make the protocol packet including resources *)
	protocolPacket = <|
		Object -> CreateID[Object[Protocol, NMR]],
		Type -> Object[Protocol, NMR],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> CollapseIndexMatchedOptions[ExperimentNMR, myResolvedOptions, Messages -> False, Ignore -> myUnresolvedOptions],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],

		(* resource (and resource-adjacent) fields *)
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@containerObjs,
		Instrument -> Link[nmrResource],
		Replace[NMRTubes] -> (Link[#]& /@ tubeResources),
		Replace[NMRSpinners] -> (Link[#]& /@ nmrSpinnerResources),
		NMRTubeRack -> Link[nmrTubeRackResource],
		DepthGauge -> Link[depthGaugeResource],

		(* populate checkpoints with reasonable time estimates *)
		Replace[Checkpoints] -> {
			{"Picking Resources", 10*Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
			(* the ReadingResonance checkpoint mirrors the runTime estimated above almost directly, padded with a little bit of overhead *)
			{"Reading Resonance", runTime + 20*Minute, "The NMR spectra of the samples are measured.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> (runTime + 20*Minute)]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 5*Minute]]}
		},
		DataCollectionTime -> runTime,

		(* assorted option-controlled fields that are generic and not particular to NMR *)
		NumberOfReplicates -> numReplicates,
		Name -> Lookup[myResolvedOptions, Name],
		Replace[SamplesInStorage] -> expandedSamplesInStorage,
		Replace[SamplesOutStorage] -> expandedSamplesOutStorage,
		Operator -> Link[Lookup[myResolvedOptions, Operator]],
		SubprotocolDescription -> Lookup[myResolvedOptions, SubprotocolDescription],
		Tweezer->tweezerResource,
		FumeHood->fumeHoodResource,
		InsertWashWasteContainer->insertsWashWasteContainerResource,
		
		(* assorted option-controlled fields that are specific to NMR *)
		Replace[Nuclei] -> expandedNuclei,
		(* currently I am _not_ making resources for DeuteratedSolvents; this is mainly because the SampleManipulation sub will do this *)
		(* also some NMR solvents are in ampuoles and SM needs to handle this anyway so punting the issue to that for now *)
		Replace[DeuteratedSolvents] -> (Link[expandedSolvents] /. deuteratedSymbolsToSolvents[]),
		Replace[SolventVolumes] -> expandedSolventVolume,
		Replace[SampleAmounts] -> expandedSampleAmount,
		Replace[SampleTemperatures] -> (expandedSampleTemperature /. Ambient -> Null),
		Replace[NumberOfScans] -> expandedNumScans,
		Replace[NumberOfDummyScans] -> expandedNumDummyScans,
		Replace[AcquisitionTimes] -> expandedAcquisitionTime,
		Replace[RelaxationDelays] -> expandedRelaxationDelay,
		Replace[PulseWidths] -> expandedPulseWidth,
		Replace[FlipAngles] -> expandedFlipAngle,
		(* need to do First[Sort[#]] or Last[Sort[#]] since Min and Max doesn't work for spans *)
		Replace[SpectralDomains] -> ({First[Sort[#]], Last[Sort[#]]}& /@ expandedSpectralDomain),
		Replace[WaterSuppression] -> (expandedWaterSuppression /. {None -> Null}),
		Replace[TimeIntervals] -> expandedTimeInterval,
		Replace[NumberOfTimeIntervals] -> expandedNumberOfTimeIntervals,
		Replace[TotalTimeCourses] -> expandedTotalTimeCourse,
		Replace[UseExternalStandards]->expandedUseExternalStandard,
		Replace[SealedCoaxialInserts]->Link[expandedSealedCoaxialInsert],
		Replace[SealedCoaxialInsertContainers]->sealedCoaxialInsertContainerResources
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
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages,Cache->inheritedCache], Null}
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
(*ValidExperimentNMRQ*)


DefineOptions[ValidExperimentNMRQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentNMR}
];

(* --- Overloads --- *)
ValidExperimentNMRQ[mySample:_String|ObjectP[Object[Sample]], myOptions:OptionsPattern[ValidExperimentNMRQ]] := ValidExperimentNMRQ[{mySample}, myOptions];

ValidExperimentNMRQ[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentNMRQ]] := ValidExperimentNMRQ[{myContainer}, myOptions];

ValidExperimentNMRQ[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ValidExperimentNMRQ]] := Module[
	{listedOptions, preparedOptions, nmrTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentNMR *)
	nmrTests = ExperimentNMR[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[nmrTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

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
			Flatten[{initialTest, nmrTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentNMRQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentNMRQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentNMRQ"]

];

(* --- Core Function --- *)
ValidExperimentNMRQ[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ValidExperimentNMRQ]]:=Module[
	{listedOptions, preparedOptions, nmrTests, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentNMR *)
	nmrTests = ExperimentNMR[mySamples, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

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
		Flatten[{nmrTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentNMRQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentNMRQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentNMRQ"]

];


(* ::Subsubsection:: *)
(*ExperimentNMROptions*)


DefineOptions[ExperimentNMROptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentNMR}
];

(* --- Overloads --- *)
ExperimentNMROptions[mySample:ObjectP[Object[Sample]]|_String, myOptions:OptionsPattern[ExperimentNMROptions]] := ExperimentNMROptions[{mySample}, myOptions];

ExperimentNMROptions[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ExperimentNMROptions]] := ExperimentNMROptions[{myContainer}, myOptions];

ExperimentNMROptions[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentNMROptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentNMR *)
	options = ExperimentNMR[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentNMR],
		options
	]

];



(* --- Core Function --- *)
ExperimentNMROptions[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ExperimentNMROptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentNMR *)
	options=ExperimentNMR[mySamples,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentNMR],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentNMRPreview*)


DefineOptions[ExperimentNMRPreview,
	SharedOptions:>{ExperimentNMR}
];

(* --- Overloads --- *)
ExperimentNMRPreview[mySample:_String|ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentNMRPreview]] := ExperimentNMRPreview[{mySample}, myOptions];

ExperimentNMRPreview[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ExperimentNMRPreview]] := ExperimentNMRPreview[{myContainer}, myOptions];

ExperimentNMRPreview[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentNMRPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentNMR *)
	ExperimentNMR[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* --- Core Function --- *)
ExperimentNMRPreview[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ExperimentNMRPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentNMR *)
	ExperimentNMR[mySamples, Append[noOutputOptions, Output -> Preview]]
];
