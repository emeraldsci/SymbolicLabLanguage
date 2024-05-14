(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*ExperimentNMR2D*)


(* ::Subsubsection::Closed:: *)
(*ExperimentNMR2D Options and Messages*)


(* ::Subsubsection::Closed:: *)
(*ExperimentNMR2D*)


DefineOptions[ExperimentNMR2D,
	Options:>{
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ExperimentType,
				Default -> Automatic,
				Description -> "The spectroscopic method used to obtain the 2D NMR spectrum.",
				ResolutionDescription -> "Automatically set to HSQC if IndirectNucleus -> 13C | 15N, or COSY if IndirectNucleus -> 1H and TOCSYMixTime is not set, or TOCSY if IndirectNucleus -> 1H and TOCSYMixTime is set.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> NMR2DExperimentP
				]
			},
			{
				OptionName -> DeuteratedSolvent,
				Default -> Model[Sample, "Deuterium oxide"],
				Description -> "The deuterated solvent in which the provided samples will be dissolved in prior to taking their spectra (or, if the samples are already in the NMR tube, what solvent was used to dissolve them).",
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
				OptionName -> DirectNucleus,
				Default -> "1H",
				Description -> "The nucleus whose spectrum is measured repeatedly and directly over the course of the experiment.  This is sometimes referred to as the f2 or T2 nucleus, and is displayed on the horizontal axis of the output plot.",
				AllowNull -> False,
				Category -> "Hidden", (* Because there is currently only one option. *)
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> DirectNucleus2DP
				]
			},
			{
				OptionName -> IndirectNucleus,
				Default -> Automatic,
				Description -> "The nucleus whose spectrum is measured through the modulation of the directly-measured 1H spectrum as a function of time rather than directly-measured. This is sometimes referred to as the f1 or T1 nucleus, and is displayed on the vertical axis of the output plot.",
				ResolutionDescription -> "Automatically set to 13C if ExperimentType -> HSQC|HMQC|HMBC|HSQCTOCSY|HMQCTOCSY, and 1H otherwise.",
				AllowNull -> False,
				Category -> "Indirect Nucleus Stimulation",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IndirectNucleus2DP
				]
			},
			{
				OptionName -> DirectNumberOfPoints,
				Default -> Automatic,
				Description -> "The number of data points collected for each directly-measured free induction decay (FID).  A higher value represents in observation of the FID for a longer length of time and thus an increase of signal-to-noise in the direct dimension.",
				ResolutionDescription -> "If DirectAcquisitionTime and DirectSpectralDomain are both specified, automatically set to (DirectAcquisitionTime * (DirectSpectralDomain * 1e-06 * [Frequency of NMR Instrument])).  Otherwise, set to 1024 if ExperimentType-> HMQC|HMQCTOCSY, or 2048 for anything else.",
				AllowNull -> False,
				Category -> "Direct Nucleus Stimulation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[4, 4096, 1]
				]
			},
			{
				OptionName -> DirectAcquisitionTime,
				Default -> Automatic,
				Description -> "Length of time during which the NMR signal is sampled and digitized per directly-measured scan.",
				ResolutionDescription -> "Automatically set to ((DirectNumberOfPoints * 1e06) / (DirectSpectralDomain * [Frequency of NMR Instrument])).",
				AllowNull -> False,
				Category -> "Direct Nucleus Stimulation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Second, 30 Second],
					Units :> {1, {Second, {Second, Millisecond}}}
				]
			},
			{
				OptionName -> DirectSpectralDomain,
				Default -> Automatic,
				Description -> "The range of the observed frequencies for the directly-observed nucleus.",
				ResolutionDescription -> "See the table in the ExperimentNMR2D documentation to see what this is automatically set to if DirectNumberOfPoints and/or DirectAcquisitionTime are NOT specified.  If DirectNumberOfPoints and DirectAcquisitionTime are both specified, automatically set to a span of width ((DirectNumberOfPoints * 1e06) / (DirectAcquisitionTime * [Frequency of NMR Instrument])) and centered at 4.7 PPM if ExperimentType -> COSYBeta | TOCSY | HMQC | HSQCTOCSY | HMQCTOCSY | NOESY | ROESY, 6.0 PPM if ExperimentType-> COSY | HSQC (IndirectNucleus -> 13C) | HMBC (IndirectNucleus -> 15N), 5.5 PPM if ExperimentType-> DQFCOSY, 6.5 PPM if ExperimentType-> HSQC (IndirectNucleus -> 15N), and 6.3 PPM if ExperimentType-> HMBC (IndirectNucleus -> 13C).",
				AllowNull -> False,
				Category -> "Direct Nucleus Stimulation",
				Widget->Span[
					Widget[Type -> Quantity, Pattern :> RangeP[-5 PPM, 15 PPM], Units :> PPM],
					Widget[Type -> Quantity, Pattern :> RangeP[-5 PPM, 15 PPM], Units :> PPM]
				]
			},
			{
				OptionName -> IndirectSpectralDomain,
				Default -> Automatic,
				Description -> "The range of the observed frequencies for the indirectly-observed nucleus.",
				ResolutionDescription -> "See the table in the ExperimentNMR2D documentaiton to see what this is automatically set to.",
				AllowNull -> False,
				Category -> "Indirect Nucleus Stimulation",
				Widget -> Span[
					Widget[Type -> Quantity, Pattern :> RangeP[-200 PPM, 600 PPM], Units :> PPM],
					Widget[Type -> Quantity, Pattern :> RangeP[-200 PPM, 600 PPM], Units :> PPM]
				]
			},
			{
				OptionName -> IndirectNumberOfPoints,
				Default -> Automatic,
				Description -> "The number of directly-measured free induction decays (FIDs) collected that together constitute the FIDs of the indirectly-measured nucleus.",
				ResolutionDescription -> "Automatically set to 128 if ExperimentType-> COSY|COSYBeta|HMQC|HMBC|HMQCTOCSY and 256 if ExperimentType -> DQFCOSY|TOCSY|HSQC|HSQCTOCSY|NOESY|ROESY.",
				AllowNull -> False,
				Category -> "Indirect Nucleus Stimulation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[4, 32768, 1]
				]
			},
			{
				OptionName -> NumberOfScans,
				Default -> Automatic,
				Description -> "The number of pulse and read cycles that will be averaged together that are applied to each sample for each directly measured free induction decay (FID).",
				ResolutionDescription -> "Automatically set to 2 if ExperimentType -> COSY, 4 if ExperimentType -> HSQC (13C), DQFCOSY, HMBC (13C), HMQC, or HMQCTOCSY, 8 if ExperimentType -> HSQC (15N), COSYBeta, TOCSY, HMBC (15N), or HSQCTOCSY, and 16 if ExperimentType -> NOESY or ROESY.",
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
				OptionName -> NumberOfDummyScans,
				Default -> Automatic,
				Description -> "The number of scans performed before the receiver is turned on and data is collected for each directly measured free induction decay (FID).",
				ResolutionDescription -> "Automatically set to 16 if ExperimentType -> HSQC (15N), COSY, DQFCOSY, COSYBeta, TOCSY, HMBC (13C or 15N), HMQC, or HMQCTOCSY, and 32 if ExperimentType -> HSQC (13C), HSQCTOCSY, NOESY, or ROESY.",
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
				OptionName -> SamplingMethod,
				Default -> Automatic,
				(* https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5876871/ gives a good explanation here; I hope I've explained it good enough in the description *)
				Description -> "The method of spacing the directly-measured free induction decays (FIDs) to create the 2D spectrum.  Currently TraditionalSampling is the only method supported, with NonUniformSampling coming soon.", (*"TraditionalSampling spaces the directly-measured spectra uniformly, but because of the FID's periodicity, this collects a lot of redundancy.  NonUniformSampling spaces the FIDs such that less redundancy is obtained, which allows for the collection of more data and higher resolution spectra and/or shorter acquisition times.  NonUniformSampling can amplify already-strong peaks and so is not recommended for homonuclear methods featuring strong diagonal signals.",*)
				ResolutionDescription -> "Automatically set to TraditionalSampling for all ExperimentType values.",(*"Automatically set to NonUniformSampling if ExperimentType -> HSQC|HMQC|HMBC|HSQCTOCSY|HMQCTOCSY, or TraditionalSampling otherwise."*)
				AllowNull -> False,
				Category -> "Hidden", (* Because there is currently only one option. *)
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[TraditionalSampling]
					(*Pattern :> NMRSamplingMethodP*)
				]
			},
			{
				OptionName -> TOCSYMixTime,
				Default -> Automatic,
				Description -> "The duration of the spin-lock sequence prior to data collection for TOCSY, HSQCTOCSY, and HMQCTOCSY experiments.",
				ResolutionDescription -> "Automatically set to 80 Millisecond if ExperimentType -> TOCSY|HMQCTOCSY, 60 Millisecond if ExperimentType -> HSQC, or Null otherwise.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 Millisecond, 120 Millisecond],
					Units :> Millisecond
				]
			},
			{
				OptionName -> PulseSequence,
				Default -> Null,
				Description -> "The file delineating the custom pulse sequence desired for this experiment.  File must be a text file in the form described in the UserManualFiles field of Model[Instrument, NMR, \"Ascend 500\"]. This will override whatever the ExperimentType option is set to.  Note that this option should only be set by pro users and that the user is liable for any damage this custom pulse sequence may inflict on the probe or instrument.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					Widget[
						Type -> String,
						Pattern :> _String,
						Size -> Paragraph
					]
				]
			},
			{
				OptionName -> WaterSuppression,
				Default -> None,
				Description -> "Indicates the method of eliminating a water signal from the 1D spectrum collected prior to the 2D spectrum.  Note that this may only be set when IndirectNucleus is set to 13C or 15N.",
				AllowNull -> False,
				Category -> "Data Acquisition",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[WaterSuppressionMethodP, None]
				]
			}
		],
		{
			OptionName -> Probe,
			Default -> Automatic,
			Description -> "The part inserted into the NMR that excites nuclear spins, detects the signal, and collects data.",
			ResolutionDescription -> "Automatically set to Model[Part, NMRProbe, \"Inverse Triple Resonance (TXI) Probe (5 mm)\"] if performing an experiment with 15N as one of the nuclei, or Model[Part, NMRProbe, \"SmartProbe (5 mm)\"] otherwise.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Part, NMRProbe], Object[Part, NMRProbe]}]
			]
		},
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

Error::ExperimentTypeNucleusIncompatible = "The specified sample(s) `1` have IndirectNucleus -> `2` and ExperimentType -> `3`.  Note that if ExperimentType -> COSY | DQFCOSY | COSYBeta | TOCSY | ROESY | NOESY, IndirectNucleus must be set to 1H, if ExperimentType -> HMQC | HMQCTOCSY | HSQCTOCSY, IndirectNucleus must be set to 13C, and if ExperimentType -> HSQC | HMBC, IndirectNucleus must be set to 13C or 15N.";
Error::DirectAcquisitionParametersIncompatible = "The specified sample(s) `1` have DirectAcquisitionTime, DirectNumberOfPoints, and DirectSpectralDomain specified such that they do not follow the formula: DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>).  Please leave one or multiple of these options blank and they will be automatically set correctly.";
Error::TOCSYMixTimeIncompatible = "The specified sample(s) `1` have TOCSYMixTime -> `2` and ExperimentType -> `3`.  Note that TOCSYMixTime may be specified if and only if ExperimentType -> TOCSY | HSQCTOCSY | HMQCTOCSY.  Please leave one or multiple of these options blank and they will be automatically set to a suitable value.";
Warning::PulseSequenceSpecified = "A custom pulse sequence is specified for sample(s) `1`. This will override whatever the ExperimentType option is set to.  Note that this option should only be set by pro users and that the user is liable for any damage this custom pulse sequence may inflict on the probe or instrument.";
Error::PulseSequenceMustBeTextFile = "A custom pulse sequence was specified, but was not in the allowed format (.txt) for the following file(s): `1`.  Please provide a file in this format.";
Error::ZeroSpectralDomain = "The specified `1` was a domain of length 0 PPM for the following sample(s): `2`.  Please modify `1` such that the highest and lowest values are not the same.";
Error::WaterSuppression2DIncompatible="The specified sample(s) `1` have WaterSuppression specified but IndirectNucleus set to 1H.  WaterSuppression may be set only if IndirectNucleus -> 13C or 15N.  Please set this option to None, or select a different IndirectNucleus.";

(* core sample overload*)
ExperimentNMR2D[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[ExperimentNMR2D]]:=Module[
	{listedOptions, listedSamples, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests,
		safeOptionsNamed, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,
		validLengths, validLengthTests, upload, confirm, fastTrack, parentProt, inheritedCache, unresolvedOptions,
		applyTemplateOptionTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, allDownloadValues, newCache,
		finalizedPacket, resourcePacketTests, allTests, validQ, previewRule, optionsRule, testsRule, resultRule,
		validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache,
		finalizedPackets, cloudFilePackets,samplePreparationPacket, sampleModelPreparationPacket,
		specifiedNMRTubes, containerModelPreparationFields, nmrModel, cloudFilePulseSequences, nmrTubeRack,
		specifiedInstrument},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links (and also need to sanitize the sample IDs) *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCache} = simulateSamplePreparationPackets[
			ExperimentNMR2D,
			listedSamples,
			listedOptions
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
		SafeOptions[ExperimentNMR2D, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentNMR2D, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
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
		ValidInputLengthsQ[ExperimentNMR2D, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentNMR2D, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1], Null}
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
		ApplyTemplateOptions[ExperimentNMR2D, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentNMR2D, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
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
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentNMR2D, {mySamplesWithPreparedSamples}, combinedOptions, 1]];

	(* hard code the NMR tube rack here; we need to Download some stuff from it; if there were a field in the Model[Instrument, NMR] then we could do that but it seems that we do not *)
	(* Note that it is also hard coded in the resource packets function*)
	nmrTubeRack = Model[Container, Rack, "SampleJet NMR Tube Rack"];

	(* pull the specified NMR tubes out of the Instrument and NMRTube options *)
	{specifiedInstrument, specifiedNMRTubes} = Lookup[expandedCombinedOptions, {Instrument, NMRTube}];

	(* Set up the samplePreparationPacket using SamplePreparationCacheFields*)
	samplePreparationPacket = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, LiquidHandlerIncompatible, Tablet, TabletWeight, TransportWarmed, TransportChilled];
	sampleModelPreparationPacket = Packet[Model[Flatten[{Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];

	(* get the SamplePreparationCacheFields for Model[Container] objects*)
	containerModelPreparationFields = Packet[PermanentlySealed, SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

	(* pull out the pulse sequence options that are cloud files *)
	cloudFilePulseSequences = Cases[Lookup[expandedCombinedOptions, PulseSequence], ObjectP[Object[EmeraldCloudFile]]];

	(* Download the sample's packets and their models *)
	allDownloadValues = Quiet[Download[
		{
			mySamplesWithPreparedSamples,
			specifiedNMRTubes,
			{specifiedInstrument},
			{nmrTubeRack},
			cloudFilePulseSequences
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
				Packet[FileType]
			}
		},
		Cache -> Flatten[{inheritedCache,samplePreparationCache}],
		Date -> Now
	], {Download::NotLinkField, Download::FieldDoesntExist}];

	(* make the new cache combining what we inherited and the stuff we Downloaded *)
	newCache = Cases[FlattenCachePackets[{samplePreparationCache, inheritedCache, allDownloadValues}], PacketP[]];

	(* --- Resolve the options! --- *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveNMR2DOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache],
			{resolveNMR2DOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveNMR2DOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentNMR2D,
		RemoveHiddenOptions[ExperimentNMR2D, resolvedOptions],
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

	(* call the nmr2DResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPackets, resourcePacketTests} = If[gatherTests,
		nmr2DResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Tests}], Cache -> newCache],
		{nmr2DResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache], Null}
	];

	(* split out the protocol packet from the cloud file packets *)
	{finalizedPacket, cloudFilePackets} = If[MatchQ[finalizedPackets, _List],
		{First[finalizedPackets], Rest[finalizedPackets]},
		{$Failed, $Failed}
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
	(* need to do the Which shenanigans because UploadProtocol can't actually take a {} as its second argument because it gets treated like an option (since {} matches OptionsPattern[] (sorta)) *)
	resultRule = Result -> Which[
		MemberQ[output, Result] && validQ && MatchQ[cloudFilePackets, {}], UploadProtocol[finalizedPacket, Confirm -> confirm, Upload -> upload, FastTrack -> fastTrack, ParentProtocol -> parentProt, Priority->Lookup[safeOptions,Priority], StartDate->Lookup[safeOptions,StartDate], HoldOrder->Lookup[safeOptions,HoldOrder], QueuePosition->Lookup[safeOptions,QueuePosition], ConstellationMessage->{Object[Protocol,NMR2D]}, Cache->samplePreparationCache],
		MemberQ[output, Result] && validQ, UploadProtocol[finalizedPacket, cloudFilePackets, Confirm -> confirm, Upload -> upload, FastTrack -> fastTrack, ParentProtocol -> parentProt, Priority->Lookup[safeOptions,Priority], StartDate->Lookup[safeOptions,StartDate], HoldOrder->Lookup[safeOptions,HoldOrder], QueuePosition->Lookup[safeOptions,QueuePosition], ConstellationMessage->{Object[Protocol,NMR2D]}, Cache->samplePreparationCache],
		True, $Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}
];

(* container input *)
ExperimentNMR2D[myContainers:ListableP[(ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]})], myOptions:OptionsPattern[ExperimentNMR2D]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,
		containerToSampleTests, inputSamples, samplesOptions, nmr2dResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationCache, updatedCache, sampleCache, myContainersByID, listedOptionsByID},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* replace all objects referenced by Name to ID *)
	{myContainersByID, listedOptionsByID} = sanitizeInputs[ToList[myContainers], listedOptions];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentNMR2D,
			myContainersByID,
			listedOptionsByID
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
		SafeOptions[ExperimentNMR2D, myOptionsWithPreparedSamples, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentNMR2D, myOptionsWithPreparedSamples, AutoCorrect -> False], Null}
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
		containerToSampleOptions[ExperimentNMR2D, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache, Output -> {Result, Tests}],
		{containerToSampleOptions[ExperimentNMR2D, mySamplesWithPreparedSamples, safeOptions, Cache->samplePreparationCache], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions, sampleCache} = containerToSampleResult;

	(* Update our cache with our new simulated values. *)
	updatedCache = FlattenCachePackets[{
		samplePreparationCache,
		sampleCache
	}];

	(* call ExperimentNMR2D and get all its outputs *)
	nmr2dResults = ExperimentNMR2D[inputSamples, ReplaceRule[samplesOptions,Cache->updatedCache]];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, nmr2dResults}
		],
		{outputSpecification -> nmr2dResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentNMR2D call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection::Closed:: *)
(*resolveNMR2DOptions*)

DefineOptions[resolveNMR2DOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveNMR2DOptions[mySamples:{ObjectP[Object[Sample]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveNMR2DOptions]]:=Module[
	{outputSpecification, output, gatherTests, messages, inheritedCache, fastTrack, samplePackets, simulatedContainerModelPackets,
		sampleModelPackets, samplePrepOptions, nmr2DOptions, simulatedSamples, resolvedSamplePrepOptions,
		simulatedCache, samplePrepTests, solvent, solventVolume, sampleTemperature, nmrTubes, numberOfReplicates,
		name, parentProtocol, pulseSequence, samplePacketsToCheckIfDiscarded, discardedSamplePackets, discardedInvalidInputs,
		discardedTest, modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest,
		numSamples, tooManySamplesQ, tooManySamplesInputs, tooManySamplesTest, unsupportedNMRTubeQ, unsupportedNMRTubeOptions,
		unsupportedNMRTubeTest, roundedNMR2DOptions, precisionTests, validNameQ, nameInvalidOptions, validNameTest,
		specifiedProbe, expandedSpecifiedIndirectNucleus, probe, mapThreadFriendlyOptions, nonStandardSolventWarnings,
		nucleusExperimentIncompatibleErrors, directAcquisitionParamsIncompatibleErrors, tocsyMixTimeIncompatibleErrors,
		pulseSequenceWarnings, resonanceFrequencies, frequencyReplaceRules, directNucleus, resolvedExperimentType,
		resolvedIndirectNucleus, resolvedDirectSpectralDomain, resolvedDirectNumPoints, resolvedDirectAcquisitionTime,
		resolvedSamplingMethod, resolvedIndirectNumPoints, resolvedIndirectSpectralDomain, resolvedTOCSYMixTime,
		nonStandardSolventWarningTests, expTypeNucleusIncompatibleSamples, expTypeNucleusIncompatibleIndNucs,
		expTypeNucleusIncompatibleExpTypes, experimentTypeNucleusOptions, experimentTypeNucleusTypeTests,
		directAcqParamOptions, directAcqParamTests, tocsyIncompatibleSamples, tocsyIncompatibleExpTypes,
		tocsyIncompatibleOptions, tocsyIncompatibleMixTime, tocsyMixTimeTests, pulseSequenceWarningTests,
		preResolvedAliquotBool, simulatedVolumes, simulatedMasses, simulatedCounts, targetContainers, specifiedSampleAmount,
		requiredAliquotAmounts, resolvedAliquotOptions, aliquotTests, resolvedPostProcessingOptions, resolvedAssayVolume,
		resolvedAliquotAmount, simulatedAmounts, resolvedSampleAmount, sampleAmountStateErrors, sampleAmountTooHighErrors,
		sampleAmountStateOptions, sampleAmountStateTests, sampleAmountTooHighOptions, sampleAmountTooHighTests,
		invalidOptions, invalidInputs, allTests, confirm, template, cache, operator, upload, outputOption,
		subprotocolDescription, samplesInStorage, samplesOutStorage, samplePreparation, email, resolvedOptions,
		testsRule, resultRule, compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs,
		nmrTubeErrors, tubeIncompatibleSamples, tubeIncompatibleTubes, nmrTubeErrorOptions,
		nmrTubeErrorTests, resolvedSolventVolume, sampleAmountNullErrors, sampleAmountNullOptions, sampleAmountNullTests,
		instrument, sampleAnalytesPackets, nmrModelPacket, cloudFilePackets,
		cloudFilePulseSequences, pulseSequenceFileTypeErrors, pulseSequenceFileTypeOptions, pulseSequenceFileTypeTest,
		zeroDirectSpectralWidthErrors, zeroIndirectSpectralWidthErrors, zeroDirectSpectralDomainSamples,
		zeroDirectSpectralDomainOptions, zeroDirectSpectralDomainTests, zeroIndirectSpectralDomainSamples,
		zeroIndirectSpectralDomainOptions, zeroInirectSpectralDomainTests, nmrTubeModelPackets, specifiedNMRTubes,
		validContainerStorageConditionBool, validContainerStorageConditionTests, validContainerStorageConditionInvalidOptions,
		resolvedNumberOfScans, resolvedNumberOfDummyScans, resolvedWaterSuppression, waterSuppressionErrors,
		waterSuppressionInvalidOptions, waterSuppressionTests
	},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache and FastTrack options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	fastTrack = Lookup[ToList[myResolutionOptions], FastTrack, False];

	(* currently the instrument model is always this; in the future this will be an option and we will just pull it out there, but for now it's not useful to be an option *)
	nmrModelPacket = FirstCase[inheritedCache, ObjectP[Model[Instrument, NMR]]];

	(* pull the specified NMR tubes out of the NMRTube option *)
	specifiedNMRTubes = Lookup[myOptions, NMRTube];

	(* pull out the pulse sequence options that are cloud files *)
	cloudFilePulseSequences = Cases[Lookup[myOptions, PulseSequence], ObjectP[Object[EmeraldCloudFile]]];

	(* split out the sample and model packets *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySamples;
	sampleModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[samplePackets, Model, {}];
	sampleAnalytesPackets = Map[
		fetchPacketFromCache[#, inheritedCache]&,
		Lookup[samplePackets, Composition, {}][[All, All, 2]],
		{2}
	];

	(* get the cloud file packets *)
	cloudFilePackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[cloudFilePulseSequences, Object];

	(* get the NMR model and NMR tube models *)
	nmrTubeModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[specifiedNMRTubes, Object];

	(* pull out the NMR resonance frequencies, and convert to replace rules converting nucleus to frequency *)
	resonanceFrequencies = Lookup[nmrModelPacket, ResonanceFrequency];
	frequencyReplaceRules = Map[
		Lookup[#, Nucleus] -> Lookup[#, Frequency]&,
		resonanceFrequencies
	];


	(* --- split out and resolve the sample prep options --- *)

	(* split out the options *)
	{samplePrepOptions, nmr2DOptions} = splitPrepOptions[myOptions];

	(* resolve the sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptions[ExperimentNMR2D, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> {Result, Tests}],
		{resolveSamplePrepOptions[ExperimentNMR2D, mySamples, samplePrepOptions, Cache -> inheritedCache, Output -> Result], {}}
	];

	(* get the current container model of the simulated samples *)
	simulatedContainerModelPackets = Download[simulatedSamples, Packet[Container[Model][{Object, PermanentlySealed, Footprint}]], Cache -> simulatedCache, Date -> Now];

	(* pull out the options that are defaulted *)
	{
		solvent,
		solventVolume,
		sampleTemperature,
		nmrTubes,
		numberOfReplicates,
		name,
		parentProtocol,
		pulseSequence,
		directNucleus,
		instrument
	} = Lookup[nmr2DOptions, {DeuteratedSolvent, SolventVolume, SampleTemperature, NMRTube, NumberOfReplicates, Name, ParentProtocol, PulseSequence, DirectNucleus, Instrument}];

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

	(* ensure that all the numerical options have the proper precision *)
	{roundedNMR2DOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[Association[nmr2DOptions], {SampleTemperature, DirectAcquisitionTime, DirectSpectralDomain, IndirectSpectralDomain}, {10^0*Celsius, 10^-3*Second, 0.01 PPM, 0.01 PPM}, Output -> {Result, Tests}],
		{RoundOptionPrecision[Association[nmr2DOptions], {SampleTemperature, DirectAcquisitionTime, DirectSpectralDomain, IndirectSpectralDomain}, {10^0*Celsius, 10^-3*Second, 0.01 PPM, 0.01 PPM}], {}}
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
		Not[DatabaseMemberQ[Object[Protocol, NMR2D, Lookup[roundedNMR2DOptions, Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "NMR2D protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a NMR2D object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Resolve the Probe option --- *)

	(* pull out the value for the IndirectNucleus and probe; this is used to resolve the Probe option *)
	{specifiedProbe, expandedSpecifiedIndirectNucleus} = Lookup[roundedNMR2DOptions, {Probe, IndirectNucleus}];

	(* set the Probe option to the TXI probe if we're doing Nitrogen 2D experiments or the SmartProbe otherwise (or whatever was specified otherwise) *)
	probe = Which[
		MatchQ[specifiedProbe, Automatic] && MemberQ[expandedSpecifiedIndirectNucleus, "15N"], Model[Part, NMRProbe, "Inverse Triple Resonance (TXI) Probe (5 mm)"],
		MatchQ[specifiedProbe, Automatic], Model[Part, NMRProbe, "SmartProbe (5 mm)"],
		True, specifiedProbe
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options os that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentNMR2D, roundedNMR2DOptions];

	(* do our big MapThread *)
	{
		resolvedExperimentType,
		resolvedNumberOfScans,
		resolvedNumberOfDummyScans,
		resolvedIndirectNucleus,
		resolvedDirectSpectralDomain,
		resolvedDirectNumPoints,
		resolvedDirectAcquisitionTime,
		resolvedSamplingMethod,
		resolvedIndirectNumPoints,
		resolvedIndirectSpectralDomain,
		resolvedTOCSYMixTime,
		resolvedWaterSuppression,
		nonStandardSolventWarnings,
		nucleusExperimentIncompatibleErrors,
		directAcquisitionParamsIncompatibleErrors,
		tocsyMixTimeIncompatibleErrors,
		pulseSequenceWarnings,
		nmrTubeErrors,
		pulseSequenceFileTypeErrors,
		zeroDirectSpectralWidthErrors,
		zeroIndirectSpectralWidthErrors,
		waterSuppressionErrors
	} = Transpose[MapThread[
		Function[{samplePacket, options, containerModelPacket, tubeModelPacket},
			Module[
				{nonStandardSolventWarning, solventOption, nucleusExperimentIncompatibleError, directAcquisitionParamsIncompatibleError,
					tocsyMixTimeIncompatibleError, pulseSequenceWarning, specPulseSequence, specifiedExpType, specifiedIndNuc,
					specifiedDirectNumPoints, specifiedDirectAcqTime, specifiedDirectSpectralDomain, experimentType, indirectNucleus,
					directNumPoints, directAcqTime, resolvedSpectralWidth, directNucFreq, specifiedTOCSYMixTime, preRoundedDirectAcqTime,
					directSpectralDomain, samplingMethod, indirectNumPoints, indirectSpectralDomain, tocsyMixTime, preRoundedDirectNumPoints,
					nmrTubeError, pulseSequenceFileTypeError, zeroDirectSpectralWidthError, zeroIndirectSpectralWidthError,
					resolvedIndirectSpectralWidth, numberOfScans, numberOfDummyScans, specifiedNumberOfScans,
					specifiedNumberOfDummyScans, waterSuppressionError, waterSuppression},

				(* set our error checking variables *)
				{
					nonStandardSolventWarning,
					nucleusExperimentIncompatibleError,
					directAcquisitionParamsIncompatibleError,
					tocsyMixTimeIncompatibleError,
					pulseSequenceWarning,
					nmrTubeError,
					pulseSequenceFileTypeError,
					zeroDirectSpectralWidthError,
					zeroIndirectSpectralWidthError,
					waterSuppressionError
				} = {False, False, False, False, False, False, False, False, False, False};

				(* get the resonance frequency of the DirectNucleus *)
				directNucFreq = Lookup[options, DirectNucleus] /. frequencyReplaceRules;

				(* pull out the DeuteratedSolvent option; if it's a packet do a Lookup; if it's a Link, Download Object *)
				solventOption = Switch[Lookup[options, DeuteratedSolvent],
					DeuteratedSolventP | ObjectReferenceP[], Lookup[options, DeuteratedSolvent],
					LinkP[], Download[Lookup[options, DeuteratedSolvent], Object],
					PacketP[], Lookup[Lookup[options, DeuteratedSolvent], Object]
				];

				(* flip the non standard solvent warning switch if the DeuteratedSolvent option is not one of our standard deuterated solvents *)
				(* if it's not an object (i.e., it's a symbol), then we're not throwing the warning because all the symbols are fine *)
				(* note that I'm making a special exception for if we're using 90% water / 10% D2O because that is supported *)
				nonStandardSolventWarning = Not[MatchQ[solventOption, ObjectP[Model[Sample, StockSolution, "90% water / 10% D2O"]]]] && MatchQ[solventOption, ObjectP[]] && Not[MemberQ[Values[deuteratedSymbolsToSolvents[]], ObjectP[solventOption]]];

				(* flip the error switch if containerModel and NMRTube are not either both or neither Model[Container, Vessel, "Sealed NMR Tube"] *)
				nmrTubeError = Xor[
					MatchQ[Lookup[containerModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}],
					MatchQ[Lookup[tubeModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}]
				];

				(* pull out the specified values needed to resolve the options and throw the errors below *)
				{
					specPulseSequence,
					specifiedExpType,
					specifiedIndNuc,
					specifiedDirectNumPoints,
					specifiedDirectAcqTime,
					specifiedDirectSpectralDomain,
					specifiedTOCSYMixTime,
					specifiedNumberOfScans,
					specifiedNumberOfDummyScans
				} = Lookup[
					options,
					{
						PulseSequence,
						ExperimentType,
						IndirectNucleus,
						DirectNumberOfPoints,
						DirectAcquisitionTime,
						DirectSpectralDomain,
						TOCSYMixTime,
						NumberOfScans,
						NumberOfDummyScans
					}
				];

				(* resolve the ExperimentType and IndirectNucleus options *)
				{
					experimentType,
					indirectNucleus
				} =  Switch[{specifiedExpType, specifiedIndNuc},
					(* if double automatic, resolve to COSY/TOCSY depending on the TOCSYMixTime option and 1H *)
					{Automatic, Automatic|"1H"}, {If[TimeQ[specifiedTOCSYMixTime], TOCSY, COSY], "1H"},
					(* if Automatic but need to use carbon or nitrogen, the default is HSQC *)
					{Automatic, "13C"|"15N"}, {HSQC, specifiedIndNuc},
					(* if any of the heteronuclear experiments are specified, resolve to 13C and not nitrogen *)
					{HSQC|HMQC|HMBC|HSQCTOCSY|HMQCTOCSY, Automatic}, {specifiedExpType, "13C"},
					(* if we had any other experiment (homonuclear) then resolve to 1H *)
					{_, Automatic}, {specifiedExpType, "1H"},
					(* otherwise, whatever was specified goes *)
					{_, _}, {specifiedExpType, specifiedIndNuc}
				];

				(* flip the error switch if the experiment type corresponds to an incompatible nucleus *)
				nucleusExperimentIncompatibleError = Or[
					MatchQ[indirectNucleus, "1H"] && MatchQ[experimentType, HMBC|HSQC|HSQCTOCSY|HMQC|HMQCTOCSY],
					MatchQ[indirectNucleus, "13C"] && MatchQ[experimentType, COSY|DQFCOSY|COSYBeta|TOCSY|NOESY|ROESY],
					MatchQ[indirectNucleus, "15N"] && MatchQ[experimentType, COSY|DQFCOSY|COSYBeta|TOCSY|NOESY|ROESY|HMQC|HSQCTOCSY|HMQCTOCSY]
				];

				(* Gather the WaterSuppression method *)
				waterSuppression = Lookup[options, WaterSuppression];

				(* WaterSuppression can only be anything but None if Nucleus -> "1H" *)
				waterSuppressionError = MatchQ[waterSuppression, WaterSuppressionMethodP] && Not[MatchQ[indirectNucleus, "13C" | "15N"]];


				(* resolve the NumberOfScans option *)
				numberOfScans = Switch[{indirectNucleus, experimentType, specifiedNumberOfScans},
					{_, _, _Integer}, specifiedNumberOfScans,
					{"1H", COSY, Automatic}, 2,
					{"13C", HSQC, Automatic}, 4,
					{"1H", DQFCOSY, Automatic}, 4,
					{"13C", HMBC, Automatic}, 4,
					{"13C", HMQC, Automatic}, 4,
					{"13C", HMQCTOCSY, Automatic}, 4,
					{"15N", HSQC, Automatic}, 8,
					{"1H", COSYBeta, Automatic}, 8,
					{"1H", TOCSY, Automatic}, 8,
					{"15N", HMBC, Automatic}, 8,
					{"13C", HSQCTOCSY, Automatic}, 8,
					{"1H", NOESY, Automatic}, 16,
					{"1H", ROESY, Automatic}, 16,
					(* shouldn't go down this path; only get here if IndirectNucleus or ExperimentType is resolved wrong; those messages will be thrown anyway so just pick something arbitrarily here *)
					{_, _, _}, 4
				];

				(* resolve the NumberOfDummyScans option *)
				numberOfDummyScans = Switch[{indirectNucleus, experimentType, specifiedNumberOfDummyScans},
					{_, _, _Integer}, specifiedNumberOfDummyScans,
					{"1H", COSY, Automatic}, 16,
					{"1H", DQFCOSY, Automatic}, 16,
					{"13C" | "15N", HMBC, Automatic}, 16,
					{"13C", HMQC, Automatic}, 16,
					{"13C", HMQCTOCSY, Automatic}, 16,
					{"15N", HSQC, Automatic}, 16,
					{"1H", COSYBeta, Automatic}, 16,
					{"1H", TOCSY, Automatic}, 16,
					{"13C", HSQC, Automatic}, 32,
					{"13C", HSQCTOCSY, Automatic}, 32,
					{"1H", NOESY, Automatic}, 32,
					{"1H", ROESY, Automatic}, 32,
					(* shouldn't go down this path; only get here if IndirectNucleus or ExperimentType is resolved wrong; those messages will be thrown anyway so just pick something arbitrarily here *)
					{_, _, _}, 16
				];

				(* resolve the spectral domain option *)
				directSpectralDomain = Switch[{specifiedDirectNumPoints, specifiedDirectAcqTime, specifiedDirectSpectralDomain},
					(* resolve special if SpectralDomain is Automatic and one or both (but not neither!) of DirectNumberOfPoints/DirectAcquisitionTime are Automatic *)
					(* depends heavily on experiment type *)
					{Automatic, Automatic, Automatic} | {Except[Automatic], Automatic, Automatic} | {Automatic, Except[Automatic], Automatic},
						Switch[{indirectNucleus, experimentType},
							{"1H",  COSY}, Span[-0.5 PPM, 12.5 PPM],
							{"1H", DQFCOSY}, Span[-1 PPM, 12 PPM],
							(* this _ is just a failsafe; we shouldn't actually get here *)
							{"1H", COSYBeta|TOCSY|NOESY|ROESY|_}, Span[-0.3 PPM, 9.7 PPM],
							{"13C", HSQC}, Span[0 PPM, 12 PPM],
							{"13C", HMQC|HMQCTOCSY}, Span[-1.8 PPM, 11.2 PPM],
							{"13C", HMBC}, Span[-0.1 PPM, 12.8 PPM],
							(* this _ is just a failsafe; we shouldn't actually get here *)
							{"13C", HSQCTOCSY|_}, Span[-3.3 PPM, 12.7 PPM],
							{"15N", _}, Span[-0.5 PPM, 13.5 PPM]
						],
					(* if directly specified, just use that *)
					{_, _, Except[Automatic]}, specifiedDirectSpectralDomain,
					(* if both DirectNumberOfPoints AND DirectAcquisitionTime are specified, need to get fancy because we calculate the _width_ of the domain based on those two values, and then center it based on values particular to the instrument type *)
					{_, _, Automatic},
						With[{halfDirectSpecWidthRange = 0.5 * (specifiedDirectNumPoints * 10^6 * PPM) / (specifiedDirectAcqTime * directNucFreq)},
							Switch[{indirectNucleus, experimentType},
								{"1H"|"13C",  COSYBeta|TOCSY|HMQC|HSQCTOCSY|HMQCTOCSY|NOESY|ROESY}, Span[4.7 PPM - halfDirectSpecWidthRange, 4.7 PPM + halfDirectSpecWidthRange],
								{"1H"|"13C", COSY|HSQC}, Span[6.0 PPM - halfDirectSpecWidthRange, 6.0 PPM + halfDirectSpecWidthRange],
								{"1H"|"13C", DQFCOSY}, Span[5.5 PPM - halfDirectSpecWidthRange, 5.5 PPM + halfDirectSpecWidthRange],
								(* this _ is just a failsafe; we shouldn't actually get here *)
								{"1H"|"13C", HMBC|_}, Span[6.3 PPM - halfDirectSpecWidthRange, 6.3 PPM + halfDirectSpecWidthRange],
								{"15N", HSQC}, Span[6.5 PPM - halfDirectSpecWidthRange, 6.5 PPM + halfDirectSpecWidthRange],
								(* this _ is just a failsafe; we shouldn't actually get here *)
								{"15N", HMBC|_}, Span[6.0 PPM - halfDirectSpecWidthRange, 6.0 PPM + halfDirectSpecWidthRange]
							]
						]
				];

				(* get the width of the resolved spectral domain *)
				resolvedSpectralWidth = Last[Sort[directSpectralDomain]] - First[Sort[directSpectralDomain]];

				(* if spectral width is zero, then flip an error switch *)
				zeroDirectSpectralWidthError = resolvedSpectralWidth == 0 PPM;

				(* resolve the DirectNumberOfPoints option *)
				preRoundedDirectNumPoints  = Switch[{specifiedDirectNumPoints, specifiedDirectAcqTime, experimentType},
					(* if directly specified then just use that and we're all good *)
					{Except[Automatic], _, _}, specifiedDirectNumPoints,
					(* if both DirectNumberOfPoints and DirectAcquisitionTime are Automatic, set to 1024 for HMQC or HMQCTOCSY, or 2048 otherwise *)
					{Automatic, Automatic, HMQC|HMQCTOCSY}, 1024,
					{Automatic, Automatic, _}, 2048,
					(* if DirectAcquisitionTime is set but DirectNumberOfPoints is Automatic, calculate value according to what was specified + the spectral width above *)
					{Automatic, Except[Automatic], _}, (specifiedDirectAcqTime * 10^-6) * (Unitless[resolvedSpectralWidth, PPM] * directNucFreq)
				];

				(* resolve the DirectAcquisitionTime option *)
				(* need to do the Convert[blah, Second] because MM gets sort of confused regarding the units of 1/Megahertz (which it clearly _sometimes_ understands are time units, but seemingly not in UnitSimplify/UnitScale outright) *)
				(* also need to do a divide-by-zero check *)
				preRoundedDirectAcqTime = Which[
					MatchQ[specifiedDirectAcqTime, Automatic] && Not[zeroDirectSpectralWidthError],
						Convert[(preRoundedDirectNumPoints * 10^6) / (Unitless[resolvedSpectralWidth, PPM] * directNucFreq), Second],
					MatchQ[specifiedDirectAcqTime, Automatic],
						Convert[(preRoundedDirectNumPoints * 10^6) / directNucFreq, Second],
					True, specifiedDirectAcqTime
				];

				(* check to make sure that the spectral domain, number of points, and acquisition times all agree with each other *)
				(* round both sides of the equal sign here becuase we just want to be basically close enough (and we will be by going to the closest 0.1 PPM; this is pretty lax but this way we get a "close enough" and don't run into as many weird rounding errors) *)
				directAcquisitionParamsIncompatibleError = Not[RoundOptionPrecision[resolvedSpectralWidth, 10^-1 PPM] == RoundOptionPrecision[(preRoundedDirectNumPoints * 10^6 * PPM) / (preRoundedDirectAcqTime * directNucFreq), 10^-1 PPM]];

				(* now need to round DirectAcquisitionTime because using the rounded version above messes with the math *)
				directAcqTime = RoundOptionPrecision[preRoundedDirectAcqTime, 10^-3 Second];

				(* using Round to the nearest integer because technically this could be a decimal but it must be an integer *)
				directNumPoints = Round[preRoundedDirectNumPoints];

				(* resolve the SamplingMethod option; if doing the heteronuclear experiments NonUniformSampling is better; otherwise, TraditionalSampling is better *)
				samplingMethod = Which[
					(* TODO once we have the license for NonUniformSampling, remove this and allow it to resolve to something besides TraditionalSampling sometimes; currently though we can only do that *)
					True, TraditionalSampling,
					MatchQ[Lookup[options, SamplingMethod], Automatic] && MatchQ[experimentType, HSQC | HMBC | HMQC | HMQCTOCSY | HSQCTOCSY], NonUniformSampling,
					MatchQ[Lookup[options, SamplingMethod], Automatic], TraditionalSampling,
					True, Lookup[options, SamplingMethod]
				];

				(* resolve the IndirectNumberOfPoints option *)
				indirectNumPoints = Which[
					MatchQ[Lookup[options, IndirectNumberOfPoints], Automatic] && MatchQ[experimentType, COSY | COSYBeta | HMQC | HMBC | HMQCTOCSY], 128,
					MatchQ[Lookup[options, IndirectNumberOfPoints], Automatic], 256,
					True, Lookup[options, IndirectNumberOfPoints]
				];

				(* resolve the IndirectSpectralDomain option *)
				indirectSpectralDomain = If[MatchQ[Lookup[options, IndirectSpectralDomain], Automatic],
					Switch[{indirectNucleus, experimentType},
						{"1H", COSY}, Span[-0.5 PPM, 12.5 PPM],
						{"1H", COSYBeta | TOCSY | NOESY | ROESY}, Span[-0.3 PPM, 9.3 PPM],
						(* underscore is just a failsafe here *)
						{"1H", DQFCOSY | _}, Span[-1.0 PPM, 12 PPM],
						{"13C", HMQC | HSQCTOCSY | HMQCTOCSY}, Span[-7.5 PPM, 157.5 PPM],
						{"13C", HSQC}, Span[0 PPM, 180 PPM],
						(* underscore is just a failsafe here *)
						{"13C", HMBC | _}, Span[-10 PPM, 210 PPM],
						{"15N", _}, Span[-50 PPM, 350 PPM]
					],
					Lookup[options, IndirectSpectralDomain]
				];

				(* get the width of the resolved indirect spectral domain *)
				resolvedIndirectSpectralWidth = Last[Sort[indirectSpectralDomain]] - First[Sort[indirectSpectralDomain]];

				(* if spectral width is zero, then flip an error switch *)
				zeroIndirectSpectralWidthError = resolvedIndirectSpectralWidth == 0 PPM;

				(* resolve the TOCSYMixTime option (and flip the tocsyMixTimeIncompatibleError flag if necessary) *)
				{tocsyMixTime, tocsyMixTimeIncompatibleError} = Switch[{specifiedTOCSYMixTime, experimentType},
					(* if using TOCSY or HMQCTOCSY, resolve to 80 Millisecond (and since we're resolving there isn't an error) *)
					{Automatic, TOCSY|HMQCTOCSY}, {80 Millisecond, False},
					(* if using HSQCTOCSY, resolve to 60 Millisecond (and since we're resolving there isn't an error) *)
					{Automatic, HSQCTOCSY}, {60*Millisecond, False},
					(* otherwise, just resolve to Null because there is no TOCSYMixTime *)
					{Automatic, _}, {Null, False},
					(* if a value was specified and we're doing a variant of TOCSY, everything is fine *)
					{UnitsP[Millisecond], TOCSY|HSQCTOCSY|HMQCTOCSY}, {specifiedTOCSYMixTime, False},
					(* if a value was specified and we're NOT doing a variant of TOCSY, flip the error switch *)
					{UnitsP[Millisecond], _}, {specifiedTOCSYMixTime, True},
					(* if Null was specified and we're doing a variant of TOCSY, flip the error switch *)
					{Null, TOCSY|HSQCTOCSY|HMQCTOCSY}, {Null, True},
					(* if Null was specified but we're not doing a variant of TOCSY, we're all good *)
					{Null, _}, {Null, False}
				];

				(* if the PulseSequence option is anything other than Null, need to flip the switch because we're throwing a warning below *)
				pulseSequenceWarning = Not[NullQ[specPulseSequence]];

				(* if the pulse sequence is a cloud file, flip the switch if it is anything besides a txt file *)
				pulseSequenceFileTypeError = If[MatchQ[specPulseSequence, ObjectP[Object[EmeraldCloudFile]]],
					With[{packet = SelectFirst[cloudFilePackets, MatchQ[Lookup[#, Object], ObjectP[specPulseSequence]]&]},
						Not[MatchQ[Lookup[packet, FileType], "txt"]]
					],
					False
				];


				(* return everything we resolved here and the errors *)
				{
					experimentType,
					numberOfScans,
					numberOfDummyScans,
					indirectNucleus,
					directSpectralDomain,
					directNumPoints,
					directAcqTime,
					samplingMethod,
					indirectNumPoints,
					indirectSpectralDomain,
					tocsyMixTime,
					waterSuppression,
					nonStandardSolventWarning,
					nucleusExperimentIncompatibleError,
					directAcquisitionParamsIncompatibleError,
					tocsyMixTimeIncompatibleError,
					pulseSequenceWarning,
					nmrTubeError,
					pulseSequenceFileTypeError,
					zeroDirectSpectralWidthError,
					zeroIndirectSpectralWidthError,
					waterSuppressionError
				}

			]
		],
		{samplePackets, mapThreadFriendlyOptions, simulatedContainerModelPackets, nmrTubeModelPackets}
	]];

	(* --- Unresolvable error checking --- *)

	(* throw a message if DirectSpectralWidth has a length of zero *)
	zeroDirectSpectralDomainSamples = PickList[simulatedSamples, zeroDirectSpectralWidthErrors];
	zeroDirectSpectralDomainOptions = If[MemberQ[zeroDirectSpectralWidthErrors, True] && messages,
		(
			Message[Error::ZeroSpectralDomain, DirectSpectralDomain, ObjectToString[zeroDirectSpectralDomainSamples, Cache -> inheritedCache]];
			{DirectSpectralDomain}
		),
		{}
	];

	(* generate the ZeroSpectralDomain errors for DirectSpectralDomain *)
	zeroDirectSpectralDomainTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, zeroDirectSpectralWidthErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, zeroDirectSpectralWidthErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the DirectSpectralDomain has a length of greater than 0 PPM:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", the DirectSpectralDomain has a length of greater than 0 PPM:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if IndirectSpectralWidth has a length of zero *)
	zeroIndirectSpectralDomainSamples = PickList[simulatedSamples, zeroIndirectSpectralWidthErrors];
	zeroIndirectSpectralDomainOptions = If[MemberQ[zeroIndirectSpectralWidthErrors, True] && messages,
		(
			Message[Error::ZeroSpectralDomain, IndirectSpectralDomain, ObjectToString[zeroIndirectSpectralDomainSamples, Cache -> inheritedCache]];
			{IndirectSpectralDomain}
		),
		{}
	];

	(* generate the ZeroSpectralDomain for IndirectSpectralDomain errors *)
	zeroInirectSpectralDomainTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, zeroIndirectSpectralWidthErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, zeroIndirectSpectralWidthErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the IndirectSpectralDomain has a length of greater than 0 PPM:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", the IndirectSpectralDomain has a length of greater than 0 PPM:",
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
		Message[Warning::NonStandardSolvent, NamedObject @ DeleteDuplicates[PickList[Lookup[roundedNMR2DOptions, DeuteratedSolvent], nonStandardSolventWarnings]], Values[deuteratedSymbolsToSolvents[]]]
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

	(* get the samples, IndirectNucleus, and ExperimentType for the ExperimentTypeNucleusIncompatible error *)
	expTypeNucleusIncompatibleSamples = PickList[simulatedSamples, nucleusExperimentIncompatibleErrors];
	expTypeNucleusIncompatibleIndNucs = PickList[resolvedIndirectNucleus, nucleusExperimentIncompatibleErrors];
	expTypeNucleusIncompatibleExpTypes = PickList[resolvedExperimentType, nucleusExperimentIncompatibleErrors];

	(* throw a message if ExperimentType and IndirectNucleus are incompatible *)
	experimentTypeNucleusOptions = If[messages && MemberQ[nucleusExperimentIncompatibleErrors, True],
		(
			Message[Error::ExperimentTypeNucleusIncompatible, ObjectToString[expTypeNucleusIncompatibleSamples, Cache -> inheritedCache], expTypeNucleusIncompatibleIndNucs, expTypeNucleusIncompatibleExpTypes];
			{IndirectNucleus, ExperimentType}
		),
		{}
	];

	(* generate the ExperimentTypeNucleusIncompatible warnings *)
	experimentTypeNucleusTypeTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, nucleusExperimentIncompatibleErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, nucleusExperimentIncompatibleErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", a IndirectNucleus and ExperimentType options do not conflict with each other:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", a IndirectNucleus and ExperimentType options do not conflict with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if DirectNumberOfPoints, DirectAcquisitionTime, and DirectSpectralDomain do not agree with each other *)
	directAcqParamOptions = If[messages && MemberQ[directAcquisitionParamsIncompatibleErrors, True],
		(
			Message[Error::DirectAcquisitionParametersIncompatible, ObjectToString[PickList[simulatedSamples, directAcquisitionParamsIncompatibleErrors], Cache -> inheritedCache]];
			{DirectAcquisitionTime, DirectNumberOfPoints, DirectSpectralDomain}
		),
		{}
	];

	(* generate the DirectAcquisitionParametersIncompatible warnings *)
	directAcqParamTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, directAcquisitionParamsIncompatibleErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, directAcquisitionParamsIncompatibleErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the specified values for the DirectAcquisitionTime, DirectNumberOfPoints, and DirectSpectralDomain are consistent with the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", the specified values for the DirectAcquisitionTime, DirectNumberOfPoints, and DirectSpectralDomain are consistent with the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples, TOCSYMixTime, and ExperimentType for the TOCSYMixTimeIncompatible error *)
	tocsyIncompatibleSamples = PickList[simulatedSamples, tocsyMixTimeIncompatibleErrors];
	tocsyIncompatibleMixTime = PickList[resolvedTOCSYMixTime, tocsyMixTimeIncompatibleErrors];
	tocsyIncompatibleExpTypes = PickList[resolvedExperimentType, tocsyMixTimeIncompatibleErrors];

	(* throw a message if ExperimentType and IndirectNucleus are incompatible *)
	tocsyIncompatibleOptions = If[messages && MemberQ[tocsyMixTimeIncompatibleErrors, True],
		(
			Message[Error::TOCSYMixTimeIncompatible, ObjectToString[tocsyIncompatibleSamples, Cache -> inheritedCache], tocsyIncompatibleMixTime, tocsyIncompatibleExpTypes];
			{TOCSYMixTime, ExperimentType}
		),
		{}
	];

	(* generate the TOCSYMixTimeIncompatible tests *)
	tocsyMixTimeTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, tocsyMixTimeIncompatibleErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, tocsyMixTimeIncompatibleErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", TOCSYMixTime is specified if and only if ExperimentType -> TOCSY | HSQCTOCSY | HMQCTOCSY:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", TOCSYMixTime is specified if and only if ExperimentType -> TOCSY | HSQCTOCSY | HMQCTOCSY:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if a pulse sequence is directly specified *)
	If[MemberQ[pulseSequenceWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::PulseSequenceSpecified, ObjectToString[PickList[simulatedSamples, pulseSequenceWarnings], Cache -> inheritedCache]]
	];

	(* generate the PulseSequenceSpecified warnings *)
	pulseSequenceWarningTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, pulseSequenceWarnings];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, pulseSequenceWarnings, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", a custom pulse sequence is not specified. This will override whatever the ExperimentType option is set to.  Note that this option should only be set by pro users and that the user is liable for any damage this custom pulse sequence may inflict on the probe or instrument:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", a custom pulse sequence is not specified. This will override whatever the ExperimentType option is set to.  Note that this option should only be set by pro users and that the user is liable for any damage this custom pulse sequence may inflict on the probe or instrument:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if PulseSequence is the wrong format *)
	pulseSequenceFileTypeOptions = If[messages && MemberQ[pulseSequenceFileTypeErrors, True],
		(
			Message[Error::PulseSequenceMustBeTextFile, ObjectToString[PickList[pulseSequence, pulseSequenceFileTypeErrors], Cache -> inheritedCache]];
			{PulseSequence}
		),
		{}
	];

	(* generate the PulseSequenceMustBeTextFile tests *)
	pulseSequenceFileTypeTest = If[gatherTests,
		Module[{failingPulseSequences, failingSampleTests},

			(* get the inputs that fail this test *)
			failingPulseSequences = PickList[pulseSequence, pulseSequenceFileTypeErrors];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingPulseSequences] > 0,
				Test["For the provided pulse sequences " <> ObjectToString[failingPulseSequences, Cache -> inheritedCache] <> ", the file is a text file:",
					False,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{failingSampleTests}

		]
	];

	(* throw a message if WaterSuppression is not None and Nucleus -> Except[1H] *)
	waterSuppressionInvalidOptions = If[MemberQ[waterSuppressionErrors, True] && messages,
		(
			Message[Error::WaterSuppression2DIncompatible, ObjectToString[PickList[simulatedSamples, waterSuppressionErrors], Cache -> simulatedCache]];
			{WaterSuppression, IndirectNucleus}
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
				Warning["For the provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> ", WaterSuppression is only set when IndirectNucleus -> 13C or 15N:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["For the provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> ", WaterSuppression is only set when IndirectNucleus -> 13C or 15N:",
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
				MatchQ[Lookup[containerModelPacket, {Footprint, PermanentlySealed}], {NMRTube, True}], False,
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
	(* if the sample is a liquid then we will aliquot 50 uL.  If it is a solid, we will say 10 mg or 50 uL because they might have specified things such that it is dissolved in something*)
	(* if SampleAmount was specified, just do 10% higher than that value *)
	requiredAliquotAmounts = MapThread[
		Which[
			MatchQ[#2, Automatic|Null] && VolumeQ[Lookup[#1, Volume]], 50*Microliter,
			MatchQ[#2, Automatic|Null] && MassQ[Lookup[#1, Mass]], {10*Milligram, 50*Microliter},
			True, #2 * 1.1
		]&,
		{samplePackets, Lookup[myOptions, SampleAmount]}
	];

	(* resolve the aliquot options *)
	(* we are cool with having solids here *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
	(* we are cool with having solids here *)
		resolveAliquotOptions[ExperimentNMR2D, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, Flatten[{resolvedSamplePrepOptions, Aliquot -> preResolvedAliquotBool}]], Cache -> simulatedCache, RequiredAliquotContainers -> targetContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> True, Output -> {Result, Tests}],
		{resolveAliquotOptions[ExperimentNMR2D, Lookup[samplePackets, Object], simulatedSamples, ReplaceRule[myOptions, Flatten[{resolvedSamplePrepOptions, Aliquot -> preResolvedAliquotBool}]], Cache -> simulatedCache, RequiredAliquotContainers -> targetContainers, RequiredAliquotAmounts -> requiredAliquotAmounts, AllowSolids -> True, Output -> Result], {}}
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
		Function[{simulatedVolume, simulatedMass, simulatedCount, options, assayVolume, aliquotAmount, containerModelFootprint},
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
				(* otherwise, resolve to 700 Microliter - roundedSampleAmount (if a volume) *)
				(* otherwise, just 700 Microliter *)
				solventVolume = Which[
					MatchQ[preResolvedSolventVolume, Except[Automatic]], preResolvedSolventVolume,
					VolumeQ[roundedSampleAmount], Max[{700 Microliter - roundedSampleAmount, 0 Microliter}],
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
		{simulatedVolumes, simulatedMasses, simulatedCounts, mapThreadFriendlyOptions, resolvedAssayVolume, resolvedAliquotAmount, Lookup[simulatedContainerModelPackets, Footprint, {}]}
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
	validContainerStorageConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];


	(* combine the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		sampleAmountStateOptions,
		sampleAmountTooHighOptions,
		unsupportedNMRTubeOptions,
		experimentTypeNucleusOptions,
		directAcqParamOptions,
		tocsyIncompatibleOptions,
		nmrTubeErrorOptions,
		sampleAmountNullOptions,
		pulseSequenceFileTypeOptions,
		zeroDirectSpectralDomainOptions,
		zeroIndirectSpectralDomainOptions,
		validContainerStorageConditionInvalidOptions,
		waterSuppressionInvalidOptions
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
		experimentTypeNucleusTypeTests,
		directAcqParamTests,
		tocsyMixTimeTests,
		pulseSequenceWarningTests,
		nmrTubeErrorTests,
		sampleAmountNullTests,
		pulseSequenceFileTypeTest,
		zeroDirectSpectralDomainTests,
		zeroInirectSpectralDomainTests,
		validContainerStorageConditionTests,
		waterSuppressionTests
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
		ExperimentType -> resolvedExperimentType,
		NumberOfScans -> resolvedNumberOfScans,
		NumberOfDummyScans -> resolvedNumberOfDummyScans,
		DirectNucleus -> directNucleus,
		IndirectNucleus -> resolvedIndirectNucleus,
		DeuteratedSolvent -> solvent,
		SolventVolume -> resolvedSolventVolume,
		SampleAmount -> resolvedSampleAmount,
		SampleTemperature -> sampleTemperature,
		DirectNumberOfPoints -> resolvedDirectNumPoints,
		DirectAcquisitionTime -> resolvedDirectAcquisitionTime,
		DirectSpectralDomain -> resolvedDirectSpectralDomain,
		IndirectNumberOfPoints -> resolvedIndirectNumPoints,
		IndirectSpectralDomain -> resolvedIndirectSpectralDomain,
		WaterSuppression -> resolvedWaterSuppression,
		NMRTube -> nmrTubes,
		Probe -> probe,
		Instrument -> instrument,
		TOCSYMixTime -> resolvedTOCSYMixTime,
		SamplingMethod -> resolvedSamplingMethod,
		PulseSequence -> pulseSequence,
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

(* ::Subsection::Closed:: *)
(*nmr2DResourcePackets*)


DefineOptions[
	nmr2DResourcePackets,
	Options :> {HelperOutputOption, CacheOption}
];

(* create the protocol packet with resource blobs included *)
nmr2DResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[nmr2DResourcePackets]]:=Module[
	{expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, samplePackets, numReplicates, expandedSamplesWithNumReplicates, tubeOption, tubeResources,
		runTime, nmrTime, nmrResource, nmrTubeRackResource, expandedAliquotAmount, sampleAmounts, sampleAmountsToReserve,
		pairedSamplesInAndVolumes, sampleAmountRules, sampleResourceReplaceRules, samplesInResources, maxTubeRackHeight,
		needsTallTubeQ, expandedNumberOfScans, expandedNumberOfDummyScans,
		expandForNumReplicates, expandedSolvents, expandedSolventVolume, expandedSampleAmount,
		expandedSampleTemperature, expandedExperimentType, expandedDirectNumberOfPoints, expandedDirectAcquisitionTime,
		expandedDirectSpectralDomain, expandedIndirectNucleus, expandedIndirectNumberOfPoints,
		expandedIndirectSpectralDomain, expandedSamplingMethod, expandedTOCSYMixTime, expandedPulseSequence, containersIn,
		protocolPacket, protID, pulseSequenceStrings, pulseSequenceNewCloudFilePackets, pulseSequenceReplaceRules,
		expandedPulseSequenceFinal, expandedDirectNucleus, probeResource, sharedFieldPacket, finalizedPacket,
		allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule, exportedStringFiles,
		simulatedSamples, simulatedCache, allDownloadValues, expandedContainerModelPackets, aliquotQs,
		depthGaugeResource, nmrSpinnerResources, expandedSamplesInStorage, expandedSamplesOutStorage, containerObjs,
		expandedSimulatedSamplesWithNumReplicates, probe, shimmingStandardResource, shimmingStandardSpinnerResource,
		probeSwapQ, probeSwapTime, runTimePerSample, containerModelPackets, nmrTubeRack, nmrTubeRackPacket, expandedWaterSuppression
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentNMR2D, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentNMR2D,
		RemoveHiddenOptions[ExperimentNMR2D, myResolvedOptions],
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
	{simulatedSamples, simulatedCache} = simulateSamplesResourcePackets[ExperimentNMR2D, mySamples, myResolvedOptions, Cache -> inheritedCache];

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

	(* expand the samples according to the number of replicates *)
	(* need to Download Object because we will be merging later *)
	expandedSamplesWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		samplePackets
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
		expandedSampleAmount
	} = expandForNumReplicates[expandedResolvedOptions, {Aliquot, NMRTube, DeuteratedSolvent, SolventVolume, SampleAmount}, numReplicates];

	(* need to expand container models to have num replicates expansion too *)
	expandedContainerModelPackets = Flatten[Map[
		ConstantArray[#, numReplicates]&,
		containerModelPackets
	]];

	(* make a resource for the probe object *)
	probe = Download[Lookup[myResolvedOptions, Probe], Object];
	probeResource = Resource[Sample -> Lookup[myResolvedOptions, Probe]];

	(* decide whether we need to make a resource for the shimming standard (only if we're doing a probe change) *)
	shimmingStandardResource = If[MatchQ[probe, Model[Part, NMRProbe, "SmartProbe (5 mm)"] | Model[Part, NMRProbe, "id:mnk9jORGR1AK"]],
		Null,
		Resource[Sample -> Model[Sample, "2 mM Sucrose 0.5 mM DSS 2 mM NaN3 in H2O/D2O 90/10, NMR water suppression standard"], Amount -> 500*Microliter]
	];

	(* if we are changing probes, we also need a spinner *)
	shimmingStandardSpinnerResource = If[NullQ[shimmingStandardResource],
		Null,
		Resource[Sample -> Model[Container, NMRSpinner, "Standard Bore POM Spinner"], Rent -> True]
	];

	(* note that these need to be unique resources so we need to use Table and not ConstantArray here *)
	(* if we're already in NMR tubes, then we just need to pick the specific object and not the model *)
	tubeResources = MapThread[
		Function[{tubeModel, aliquotQ, containerModelPacket, sampleContainer, sample, tube, solvent, solventVolume, sampleAmount},
			If[MatchQ[Lookup[containerModelPacket, Footprint], NMRTube] && Not[aliquotQ],
				Resource[Sample -> sampleContainer, Name -> ToString[sampleContainer]],
				(* note that this name means that if we have duplicate all the way through the simulation AND the tube/solvent/solvent volume/sample amount are the same then we want these resources to be the same *)
				Resource[Sample -> tubeModel, Rent -> False, Name -> StringJoin[ToString[sample], ToString[tube], ToString[solvent], ToString[solventVolume], ToString[sampleAmount]]]
			]
		],
		{tubeOption, aliquotQs, expandedContainerModelPackets, Download[Lookup[expandedSimulatedSamplesWithNumReplicates, Container], Object], Lookup[expandedSimulatedSamplesWithNumReplicates, Object], tubeOption, Download[expandedSolvents /. deuteratedSymbolsToSolvents[], Object], expandedSolventVolume, expandedSampleAmount}
	];

	(* get the maximum height for the NMRTubeRack *)
	maxTubeRackHeight = First[Lookup[Lookup[nmrTubeRackPacket, Positions], MaxHeight]];

	(* determine if we can use the autosampler or if we need to use a spinner for each container *)
	needsTallTubeQ = Map[
		MatchQ[Lookup[#, {Footprint, Dimensions}], {NMRTube, {_, _, GreaterP[maxTubeRackHeight]}}]&,
		expandedContainerModelPackets
	];

	(* make a resource for the DepthGauge field; need one if at least one of the input containers is too large to fit into the autosampler rack need to use spinners/ depth gauge *)
	(* Also need a depth gauge if we have a shimming spinner resource*)
	depthGaugeResource = If[MemberQ[needsTallTubeQ, True] || Not[NullQ[shimmingStandardSpinnerResource]],
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

	(* decide if we are swapping probes or not; this will affect the time estimates since the probe swapping is hard *)
	probeSwapQ = Not[MatchQ[probe, ObjectP[{Model[Part, NMRProbe, "id:mnk9jORGR1AK"], Object[Part, NMRProbe, "id:M8n3rx0v0WqO"]}]]];

	(* make the amount of time for the probe swapping; if we're not swapping the probe this is 0 minute, and if so it will be about an hour *)
	probeSwapTime = If[probeSwapQ, 1*Hour, 0*Minute];

	(* get the amount of time each experiment will take; going to total this below in a bit; if we have NumberOfReplicates set, we are multiplying by that one *)
	runTimePerSample = MapThread[
		Function[{expType, indNucleus, indNumPoints, numScans},
			numReplicates * Switch[{expType, indNucleus},
				{COSY, _}, 6 Minute * numScans * (indNumPoints / 128),
				{DQFCOSY, _}, 10 Minute * numScans * (indNumPoints / 256),
				{COSYBeta, _}, 5 Minute * numScans * (indNumPoints / 128),
				{TOCSY, _}, 10 Minute * numScans * (indNumPoints / 256),
				{HMBC, "13C"}, 3.75 Minute * numScans * (indNumPoints / 128),
				{HMBC, "15N"}, 5 Minute * numScans * (indNumPoints / 128),
				{HSQC, "13C"}, 10 Minute * numScans * (indNumPoints / 256),
				{HSQC, "15N"}, 10 Minute * numScans * (indNumPoints / 256),
				{HSQCTOCSY, _}, 10 Minute * numScans * (indNumPoints / 256),
				{HMQC, _}, 3.75 Minute * numScans * (indNumPoints / 128),
				{HMQCTOCSY, _}, 3.75 Minute * numScans * (indNumPoints / 128),
				{NOESY, _}, 12 Minute * numScans * (indNumPoints / 256),
				{ROESY, _}, 12 Minute * numScans * (indNumPoints / 256)
			]
		],
		Lookup[myResolvedOptions, {ExperimentType, IndirectNucleus, IndirectNumberOfPoints, NumberOfScans}]
	];

	(* get the total length of time for running the experiment *)
	runTime = Total[runTimePerSample];

	(* Estimate the amount of NMR time by taking the runTime calculated above *)
	(* this mainly includes the run time of the experiment itself and the loading of the NMR tubes; hard to estimate too well here but let's say it takes 20 minutes per sample and then 10 minutes of overhead for everything else *)
	nmrTime = runTime + (20*Minute * Length[mySamples]) + 10*Minute;

	(* make the resource for the nmr instrument *)
	nmrResource = Resource[Instrument -> Lookup[myResolvedOptions, Instrument], Time -> nmrTime, Name -> "NMR Instrument Resource"];

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
				First[sampleAndName] -> Resource[Sample -> Download[First[sampleAndName], Object], Name -> StringJoin["Sample resource ", Last[sampleAndName]], Amount -> amount],
				First[sampleAndName] -> Resource[Sample -> Download[First[sampleAndName], Object], Name -> StringJoin["Sample resource ", Last[sampleAndName]]]
			]
		],
		sampleAmountRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* --- Generate the protocol packet --- *)

	(* expand all the options ot account for number of replicates *)
	{
		expandedSampleTemperature,
		expandedExperimentType,
		expandedNumberOfScans,
		expandedNumberOfDummyScans,
		expandedDirectNucleus,
		expandedDirectNumberOfPoints,
		expandedDirectAcquisitionTime,
		expandedDirectSpectralDomain,
		expandedIndirectNucleus,
		expandedIndirectNumberOfPoints,
		expandedIndirectSpectralDomain,
		expandedSamplingMethod,
		expandedTOCSYMixTime,
		expandedPulseSequence,
		expandedWaterSuppression,
		expandedSamplesInStorage,
		expandedSamplesOutStorage
	} = expandForNumReplicates[
		expandedResolvedOptions,
		{
			SampleTemperature,
			ExperimentType,
			NumberOfScans,
			NumberOfDummyScans,
			DirectNucleus,
			DirectNumberOfPoints,
			DirectAcquisitionTime,
			DirectSpectralDomain,
			IndirectNucleus,
			IndirectNumberOfPoints,
			IndirectSpectralDomain,
			SamplingMethod,
			TOCSYMixTime,
			PulseSequence,
			WaterSuppression,
			SamplesInStorageCondition,
			SamplesOutStorageCondition
		},
		numReplicates
	];

	(* generate the protocol ID *)
	protID = CreateID[Object[Protocol, NMR2D]];

	(* get the strings from the PulseSequence option and make cloud files out of these *)
	pulseSequenceStrings = DeleteDuplicates[Cases[expandedPulseSequence, _String]];

	(* need to export the strings to a user's temporary directory *)
	exportedStringFiles = Map[
		FastExport[FileNameJoin[{$TemporaryDirectory, StringJoin["pulse-sequence-file-", CreateUUID[], ".txt"]}], #, "Text"]&,
		pulseSequenceStrings
	];

	(* make the pulse sequence files *)
	pulseSequenceNewCloudFilePackets = UploadCloudFile[exportedStringFiles, Name -> StringJoin["Pulse Sequence file for ", ToString[protID]], Upload -> False];

	(* make replace rules converting the strings to cloud file IDs *)
	pulseSequenceReplaceRules = MapThread[
		#1 -> Lookup[#2, Object]&,
		{pulseSequenceStrings, pulseSequenceNewCloudFilePackets}
	];

	(* convert all the pulse sequences to cloud files *)
	expandedPulseSequenceFinal = Replace[expandedPulseSequence, pulseSequenceReplaceRules, {1}];

	(* get the ContainersIn with no Duplicates *)
	containersIn = DeleteDuplicates[Download[Lookup[samplePackets, Container], Object]];

	(* make the protocol packet including resources *)
	protocolPacket = <|
		Object -> protID,
		Type -> Object[Protocol, NMR2D],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> CollapseIndexMatchedOptions[ExperimentNMR2D, myResolvedOptions, Messages -> False, Ignore -> myUnresolvedOptions],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],
		Author -> Link[$PersonID, ProtocolsAuthored],

		(* resource (and resource-adjacent) fields *)
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
		Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@containerObjs,
		Instrument -> Link[nmrResource],
		ProbeDisconnectionSlot -> {Link[nmrResource], "Cable Slot"},
		Replace[NMRTubes] -> (Link[#]& /@ tubeResources),
		Replace[NMRSpinners] -> (Link[#]& /@ nmrSpinnerResources),
		NMRTubeRack -> Link[nmrTubeRackResource],
		DepthGauge -> Link[depthGaugeResource],

		(* populate checkpoints with reasonable time estimates *)
		Replace[Checkpoints] -> {
			{"Picking Resources", 10*Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
			(* the ReadingResonance checkpoint mirrors the runTime estimated above almost directly, padded with a little bit of overhead and the amount of time it takes to change the probe, if we're doing that *)
			{"Reading Resonance", (runTime + 20*Minute + probeSwapTime), "The NMR spectra of the samples are measured.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> (runTime + 20*Minute + probeSwapTime)]]},
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

		(* assorted option-controlled fields that are specific to NMR2D *)
		(* currently I am _not_ making resources for DeuteratedSolvents; this is mainly because the SampleManipulation sub will do this *)
		(* also some NMR solvents are in ampuoles and SM needs to handle this anyway so punting the issue to that for now *)
		Replace[DeuteratedSolvents] -> (Link[expandedSolvents] /. deuteratedSymbolsToSolvents[]),
		Replace[SolventVolumes] -> expandedSolventVolume,
		Replace[SampleAmounts] -> expandedSampleAmount,
		Replace[SampleTemperatures] -> (expandedSampleTemperature /. Ambient -> Null),
		Replace[ExperimentTypes] -> expandedExperimentType,
		Replace[NumberOfScans] -> expandedNumberOfScans,
		Replace[NumberOfDummyScans] -> expandedNumberOfDummyScans,
		Replace[DirectNuclei] -> expandedDirectNucleus,
		Replace[DirectNumberOfPoints] -> expandedDirectNumberOfPoints,
		Replace[DirectAcquisitionTimes] -> expandedDirectAcquisitionTime,
		Replace[IndirectNuclei] -> expandedIndirectNucleus,
		Replace[IndirectNumberOfPoints] -> expandedIndirectNumberOfPoints,
		Replace[TOCSYMixTimes] -> expandedTOCSYMixTime,
		Replace[SamplingMethods] -> expandedSamplingMethod,
		Replace[PulseSequences] -> Link[expandedPulseSequenceFinal],
		Replace[WaterSuppression] -> (expandedWaterSuppression /. {None -> Null}),
		Probe -> Link[probeResource],
		ShimmingStandard -> Link[shimmingStandardResource],
		ShimmingStandardSpinner -> Link[shimmingStandardSpinnerResource],
		(* need to do First[Sort[#]] or Last[Sort[#]] since Min and Max doesn't work for spans *)
		Replace[DirectSpectralDomains] -> ({First[Sort[#]], Last[Sort[#]]}& /@ expandedDirectSpectralDomain),
		Replace[IndirectSpectralDomains] -> ({First[Sort[#]], Last[Sort[#]]}& /@ expandedIndirectSpectralDomain)

	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache -> simulatedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],Cache -> simulatedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages,Cache -> simulatedCache], Null}
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
	(* note that this includes the protocol packet AND whatever cloud file objects I make *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		Flatten[{finalizedPacket, pulseSequenceNewCloudFilePackets}],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}



];

(* ::Subsection::Closed:: *)
(*ValidExperimentNMR2DQ*)

DefineOptions[ValidExperimentNMR2DQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentNMR2D}
];


(* --- Overloads --- *)
ValidExperimentNMR2DQ[mySample:_String|ObjectP[Object[Sample]], myOptions:OptionsPattern[ValidExperimentNMR2DQ]] := ValidExperimentNMR2DQ[{mySample}, myOptions];

ValidExperimentNMR2DQ[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentNMR2DQ]] := ValidExperimentNMR2DQ[{myContainer}, myOptions];

ValidExperimentNMR2DQ[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ValidExperimentNMR2DQ]] := Module[
	{listedOptions, preparedOptions, nmrTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentNMR2D *)
	nmrTests = ExperimentNMR2D[myContainers, Append[preparedOptions, Output -> Tests]];

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
	(* like if I ran OptionDefault[OptionValue[ValidExperimentNMR2DQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentNMR2DQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentNMR2DQ"]

];

(* --- Core Function --- *)
ValidExperimentNMR2DQ[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ValidExperimentNMR2DQ]]:=Module[
	{listedOptions, preparedOptions, nmrTests, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentNMR2D *)
	nmrTests = ExperimentNMR2D[mySamples, Append[preparedOptions, Output -> Tests]];

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
	(* like if I ran OptionDefault[OptionValue[ValidExperimentNMR2DQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentNMR2DQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentNMR2DQ"]

];



(* ::Subsubsection:: *)
(*ExperimentNMR2DOptions*)


DefineOptions[ExperimentNMR2DOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentNMR2D}
];

(* --- Overloads --- *)
ExperimentNMR2DOptions[mySample:_String|ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentNMR2DOptions]] := ExperimentNMR2DOptions[{mySample}, myOptions];

ExperimentNMR2DOptions[myContainer:_String|ObjectP[Object[Container]], myOptions:OptionsPattern[ExperimentNMR2DOptions]] := ExperimentNMR2DOptions[{myContainer}, myOptions];

ExperimentNMR2DOptions[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentNMR2DOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentNMR2D *)
	options = ExperimentNMR2D[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentNMR2D],
		options
	]

];



(* --- Core Function --- *)
ExperimentNMR2DOptions[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ExperimentNMR2DOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentNMR2D *)
	options=ExperimentNMR2D[mySamples,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentNMR2D],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentNMR2DPreview*)


DefineOptions[ExperimentNMR2DPreview,
	SharedOptions:>{ExperimentNMR2D}
];

(* --- Overloads --- *)
ExperimentNMR2DPreview[mySample:_String|ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentNMR2DPreview]] := ExperimentNMR2DPreview[{mySample}, myOptions];

ExperimentNMR2DPreview[myContainer:ObjectP[_String|Object[Container]], myOptions:OptionsPattern[ExperimentNMR2DPreview]] := ExperimentNMR2DPreview[{myContainer}, myOptions];

ExperimentNMR2DPreview[myContainers : {(_String|ObjectP[Object[Container]])..}, myOptions : OptionsPattern[ExperimentNMR2DPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentNMR2D *)
	ExperimentNMR2D[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* --- Core Function --- *)
ExperimentNMR2DPreview[mySamples:{(_String|ObjectP[Object[Sample]])..},myOptions:OptionsPattern[ExperimentNMR2DPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentNMR2D *)
	ExperimentNMR2D[mySamples, Append[noOutputOptions, Output -> Preview]]
];
