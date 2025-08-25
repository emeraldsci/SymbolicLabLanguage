(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAbsorbanceSpectroscopy*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[ExperimentAbsorbanceSpectroscopy,
	Options :> {
		{
			OptionName -> Methods,
			Default -> Automatic,
			Description -> "Indicates the type of vessel to be used to measure the absorbance of SamplesIn. PlateReaders utilize an open well container that transveres light from top to bottom. Cuvette uses a square container with transparent sides to transverse light from the front to back at a fixed path length. Microfluidic uses small channels to load samples which are then gravity-driven towards chambers where light transverse from top to bottom and measured at a fixed path length.",
			ResolutionDescription -> "Automatically determined based on the instrument that can satisfy the requested options. If all instruments are possible, defaults to Microfluidic.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> AbsorbanceMethodP
			]
		},
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The instrument used for proceeding with measuring the absorbance of the samples according to the AbsorbanceMethod.",
			ResolutionDescription -> "If using Microfluidic Method, set to Model[Instrument, PlateReader, \"Lunatic\"]; if using Cuvette Method, set to Model[Instrument, Spectrophotometer, \"Cary 3500\"]; If using PlateReader Method set to Model[Instrument, PlateReader, \"FLUOstar Omega\"] .",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, PlateReader], Object[Instrument, PlateReader], Object[Instrument,Spectrophotometer], Model[Instrument,Spectrophotometer]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments", "Spectrophotometers", "UV-Vis Spectrometers"
					}
				}
			]
		},

		{
			OptionName->MicrofluidicChipLoading,
			Default->Automatic,
			AllowNull->True,
			Description->"Indicates whether the SamplesIn are loaded by a robotic liquid handler or manually.",
			ResolutionDescription -> "When using the Microfluidic plate readers, automatically set to Robotic.",
			Widget-> Widget[Type->Enumeration,Pattern:>Alternatives[Robotic, Manual]],
			Category->"General"
		},
		{
			OptionName->SpectralBandwidth,
			Default->Automatic,
			AllowNull->True,
			Description->"When using the Cuvette Method, indicates the physical size of the slit from which light passes out from the monochromator. The narrower the bandwidth, the greater the resolution in measurements.",
			ResolutionDescription -> "When using the Cuvette Method, automatically set 1.0 Nanometer. If using plate reader, set to Null.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[0.5 Nanometer, 5 Nanometer],Units:>Nanometer],
			Category->"Absorbance Measurement"
		},
		{
			OptionName -> TemperatureMonitor,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration,Pattern :> Alternatives[CuvetteBlock, ImmersionProbe]],
			Description -> "When using Cuvette Method (Cary 3500), which device (probe or block) will be used to monitor temperature during the Experiment.",
			ResolutionDescription -> "When using the Cuvette Method, automatically set to CuvetteBlock. If using plate reader, set to Null.",
			Category -> "Absorbance Measurement"
		},
		{
			OptionName->AcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"When using the Cuvette Method, indicates the rate at which the samples within the cuvette should be mixed with a stir bar during data acquisition.",
			ResolutionDescription -> "If AcquisitionMix is True, automatically set AcquisitionMixRate 400 RPM.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[400 RPM, 1400 RPM],Units->RPM],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->AdjustMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"When using a stir bar, if specified AcquisitionMixRate does not provide a stable or consistent circular rotation of the magnetic bar, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples. If stir bar is wiggling, decrease AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still wiggling. If it is, decrease by AcquisitionMixRateIncrements again. If still wiggling, repeat decrease until MaxStirAttempts. If the stir bar is not moving/stationary, increase the AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still stationary. If it is, increase by AcquisitionMixRateIncrements again. If still stationary, repeat increase until MaxStirAttempts. Mixing will occur during data acquisition. After MaxStirAttempts, if stable stirring was not achieved, StirringError will be set to True in the protocol object.",
			ResolutionDescription -> "Automatically set to True if AcquisitionMix is True.",
			Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Hidden"
		},
		{
			OptionName->MinAcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"Sets the lower limit stirring rate to be decreased to for sample mixing in the cuvette while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
			ResolutionDescription->"Automatically sets to 400 RPM if AdjustMixRate is True.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[400 RPM,1400 RPM],Units->RPM],
			Category->"Hidden"
		},
		{
			OptionName->MaxAcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"Sets the upper limit stirring rate to be increased to for sample mixing in the cuvette while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
			ResolutionDescription -> "Automatically sets to 1400 RPM if AdjustMixRate is True.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[400 RPM, 1400 RPM],Units->RPM],
			Category->"Hidden"
		},
		{
			OptionName->AcquisitionMixRateIncrements,
			Default->Automatic,
			AllowNull->True,
			Description->"Indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
			ResolutionDescription->"Automatically sets to 50 RPM if AdjustMixRate is True.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[50 RPM,500 RPM],Units->RPM],
			Category->"Hidden"
		},
		{
			OptionName->MaxStirAttempts,
			Default->Automatic,
			AllowNull->True,
			Description->"Indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt.",
			ResolutionDescription->"If AdjustMixRate is True, automatically sets to 10.",
			Widget->Widget[Type->Number,Pattern:>RangeP[1,40]],
			Category->"Hidden"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->AcquisitionMix,
				Default->Automatic,
				AllowNull->True,
				Description->"When using the Cuvette Method, indicates whether the samples within the cuvette should be mixed with a stir bar during data acquisition.",
				ResolutionDescription -> "When using the Cuvette Method, automatically set to False.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Absorbance Measurement"
			},
			{
				OptionName->StirBar,
				Default->Automatic,
				AllowNull->True,
				Description->"When using the Cuvette Method, indicates which model stir bar to be inserted into the cuvette to mix the sample.",
				ResolutionDescription -> "If AcquisitionMix is True, StirBar is automatically specified depending on the cuvette. Otherwise, automatically set to Null.",
				Widget-> Widget[Type->Object,
					Pattern:>ObjectP[{Model[Part, StirBar], Object[Part, StirBar]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments","Mixing Devices", "Stir Bars"
						}
					}
				],
				Category->"Absorbance Measurement"
			},
			{
				OptionName->RecoupSample,
				Default->False,
				AllowNull->True,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if the aliquot used to measure the absorbance should be returned to source container after each reading.",
				Category->"General"
			},
			{
				OptionName->ContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Container],Object[Container]}]
				],
				Description->"The desired container generated samples should be transferred into by the end of the experiment, with indices indicating grouping of samples in the same plates.",
				ResolutionDescription->"Automatically selected from ECL's stocked containers based on the volume of solution being prepared.",
				Category->"General"
			}
		],
		IndexMatching[
			{
				OptionName -> QuantifyConcentration,
				Default -> Automatic,
				Description -> "Indicates if the concentration of the samples should be determined. Automatically calls AnalyzeAbsorbanceConcentration to update the concentration of analytes on completion of the experiment.",
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				ResolutionDescription -> "Automatically set to True if QuantificationWavelength is specified.",
				Category -> "Quantification"
			},
			{
				OptionName -> QuantificationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose concentration should be determined during this experiment.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[List @@ IdentityModelTypeP]
				],
				Category -> "Quantification"
			},
			{
				OptionName->QuantificationWavelength,
				Default->Automatic,
				Description->"Gets the ExtinctionCoefficient for the analyte.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Nanometer,1000 Nanometer],
					Units->Alternatives[Nanometer]
				],
				Category->"Quantification",
				ResolutionDescription->"Automatically set to the ExtinctionCoefficients field of the analyte, and set to Null if QuantifyConcentration is False or Automatic."
			},
				IndexMatchingInput -> "experiment samples"
		],
		AbsorbanceSharedOptions,
		SamplesOutStorageOptions
	}
];


(* ::Subsubsection:: *)
(*ExperimentAbsorbanceSpectroscopy (sample input)*)


(* grouping error messages roughly in order of where they appear *)
(* these messages can all happen before option resolution *)
Error::UnsupportedPlateReader = "The provided instrument `1` is not supported for `2` at this time.  Please check Model[Instrument,PlateReader][PlateReaderMode] to see which instruments can perform which experiments.";
Error::AbsorbanceSamplingCombinationUnavailable="The specified combination of sampling pattern options and wavelength option is not valid. SamplingDistance option applies to Spiral, Ring and Matrix sampling. SamplingDimension option only applies to Matrix sampling. Only up to 8 discrete wavelengths can be specified in the Wavelength option with Matrix sampling. Please verify these options match these requirements or allow some to resolve automatically.";

Error::TemperatureIncompatibleWithPlateReader = "The EquilibrationTime and Temperature options are not compatible with `1`.  Please specify a different Instrument if you wish to specify these temperature options.";
Error::BlanksContainSamplesIn = "The following provided sample(s): `1` were also provided with the Blank option.  Please specify samples and blanks such that neither contains members of the other.";
Error::ConcentrationWavelengthMismatch = "If QuantifyConcentration->False, `1` or QuantificationAnalyte cannot be specified, and if QuantifyConcentration->True, `1` or QuantificationAnalyte cannot be set to Null. This is broken for the following sample(s): `2`.";
Warning::ExtCoeffNotFound = "The ExtinctionCoefficients field is not populated for the model(s) of the following input sample(s): `1`. Please upload ExtinctionCoefficients to the corresponding Model in the form of {<|Wavelength->_, ExtinctionCoefficient->_|>}. Defaulting wavelength to 260 nm (if not a protein or peptide) or 280 nm (if a protein or peptide).";
Error::ExtinctionCoefficientMissing = "The ExtinctionCoefficients field is not populated for the model of the following input sample(s) `1` and cannot be calculated for the resolved quantification wavelength(s) `2`, and so quantification cannot occur.  Please upload ExtinctionCoefficients to the corresponding Model in the form of {<|Wavelength->_, ExtinctionCoefficient->_|>}.";
Error::SampleMustContainQuantificationAnalyte = "The QuantificationAnalyte option is specified for substance(s) that are not components of the following input sample(s): `1`.  Please specify analytes that are component(s) of the sample(s), or leave this option blank.";
Error::SpectralBandwidthIncompatibleWithPlateReader = "`1` does not support specification of SpectralBandwidth options.  Please specify a different Instrument if you wish to specify these options.";
Error::AcquisitionMixIncompatibleWithPlateReader = "`1` does not support specification of AcquisitionMix options.  Please specify a different Instrument if you wish to specify these options.";
Error::AcquisitionMixRequiredOptions = "If any AcquisitionMix options are set (AcquisitionMix, AcquisitionMixRate, AcquisitionMixRateIncrements, AcquisitionMinMixRate, AcquisitionMaxMixRate, MaxStirAttempts, StirBar, AdjustMixRate), these options cannot be Null.";
Error::MethodsInstrumentMismatch = "`1` instrument is not compatible with the `2` Method.  Please specify a different Instrument if you wish to set the `2` Method or allow the instrument to automatically be resolved.";
Error::AbsorbanceSpectroscopyIncompatibleCuvette="For the following sample(s), `1`, the option AliquotContainer is set to a cuvette that is not compatible with this experiment. Please specify one of the following cuvettes , `2`, or leave this option Automatic.";
Error::AbsorbanceSpectroscopyCuvetteVolumeOutOfRange="For the following sample(s), `1`, the specified or projected total volume(s) (`2`) cannot be read reliably in any of the available cuvettes. Please consult the experiment function's documentation for a list of available cuvettes and their working ranges.";
Error::AbsSpecSamplesOutStorageConditionConflict="For the following sample(s), `1`, the SamplesOutStorageCondition was set to Disposal while the ContainerOut was also specified (`2`) or RecoupSample is True. Please set SamplesOutStorageCondition to SampleStorageTypeP or only set ContainerOut and RecoupSample to True for samples that are not being disposed.";

(* these options happen during/after option resolution *)
Error::IncompatibleBlankOptions = "The specified blank options (BlankAbsorbance, Blanks, or BlankVolumes) are incompatible with each other.  Blanks and BlankVolumes may only be specified if BlankAbsorbance -> True, and must not be specified if BlankAbsorbance -> False.";
Error::BlankVolumeNotRecommended = "The provided volume in the BlankVolumes option `1` does not match the allowed volume (`2`) for the provided instrument `3`.  Please specify `2` for BlankVolume, or leave as Automatic.";
Error::QuantificationRequiresBlanking = "If QuantifyConcentration -> True, BlankAbsorbance cannot be False.  Please set BlankAbsorbance -> True if you wish to calculate the concentration of your samples.";
Error::AbsSpecTooManySamples = "The number of input samples and blanks times the NumberOfReplicates cannot fit on `1` in a single protocol.  Please select less than or equal to `2` samples when using `1`, or use the BMG plate readers, which are unrestricted by number of samples.";
Error::TooManyBlanks = "The specified Blanks, `1`, cannot be used simultaneously because when using cuvette method, all input samples can only share 1 blank sample. Please adjust the number of blanks and try again.";
Warning::AbsSpecInsufficientSampleVolume = "The specified sample volumes `1` are below the minimum required volume for the specified instrument type of `2`. Please consider using larger sample volumes or select an instrument that can read samples of this size.";
Warning::BlankStateWarning = "The blanks (`1`) do not have a state of liquid. If this is not intended, please check the blank samples (`1`).";
Warning::NotEqualBlankVolumes = "The blank volume (`1`) is not equal to the volume of the sample (`2`). We recommend a blank volume that equals to the sample volume, or let the BlankVolumes resolve automatically.";
Error::InjectionSampleStateError = "The injection samples (`1`) do not have a state of liquid. The instrument can only inject liquid samples. Please make sure the injection samples have a state of liquid.";
Error::SkippedInjectionError = "Injection options (`1`) are not specified before the use of injection option (`2`). Please make sure the injections are specified in order. For example, secondary injection can be specified only if the primary injection is already specified.";

Error::PlateReaderReadings = "The NumberOfReadings option is specified to `1` while the requested instrument `2` `3`. The NumberOfReadings cannot be set for any spectrophotometer for cuvetter measurements. If the plate reader is unable to take multiple readings to calculate an average absorbance value, this option cannot be set to an integer. However, if the plate reader can accept multiple readings, the option cannot be set to Null. Please refer to the `4` help file and specify the option according to the instrument type or allow it to be resolved automatically.";
Error::PlateReaderMixingUnsupported = "The PlateReaderMix options are not compatible with `1`.  Please specify a different Instrument if you wish to specify these mix options.";
Error::PlateReaderInjectionsUnsupported = "`1` does not support specification of any injection options.  Please specify a different Instrument if you wish to perform injections.";
Error::PlateReaderReadDirectionUnsupported= "`1` does not support specification of ReadDirection.  Please specify a different Instrument if you wish to specify these options.";
Error::PlateReaderMoatUnsupported = "`1` does not support specification of Moat options.  Please specify a different Instrument if you wish to specify these options.";
Error::CoverUnsupported="`1` uses microfluidic chips which cannot be covered during the read. Please specify a plate-based instrument to use RetainCover->True.";
Error::InvalidCuvetteMoatOptions = "`1` does not support specification of Moat options.  Please specify a different Instrument if you wish to specify these options.";
Error::InvalidCuvettePlateReaderOptions = "`1` does not support specification of PlateReaderMix options.  Please specify a different Instrument if you wish to specify these options.";
Error::InvalidCuvetteSamplingOptions = "`1` does not support specification of Sampling options.  Please specify a different Instrument if you wish to specify these options.";
Error::InvalidAcquisitionMixRateRange = "The option MinAcquisitionMixRate has been specified to `1` which is greater than the MaxAcquisitionMixRate (`2`). Please modify the range such that MinAcquisitionMixRate is smaller or equal to MaxAcquisitionMixRate.";

Warning::ReplicateChipSpace="When concentration is being quantified, 3 replicates are recommended, however there is insufficient space in the chip to do this. NumberOfReplicates will be set to `1`, the largest possible value, but you may wish to consider splitting this into multiple experiments.";
Error::InvalidBlankContainer="BlankVolume must be provided if a blank is not an existing sample which is already in `1`. For each of the following blank samples, please specify the volume which should be transferred into a compatible container in order to do the reading: `2`";
Warning::UnnecessaryBlankTransfer="Although they are already in compatible containers, blanks wil be transferred from their current container into new containers. If you don't wish for these samples to be transferred set BlankVolumes->Null for `1`";

Error::SamplingPatternMismatch="Sampling is not Null if the instrument does sampling, otherwise it must be Null. Please consider allowing SamplingPattern to resolve automatically";

Error::TooManyWavelength="The number of discrete `1` (`2`) cannot exceed the instrument limit. Please make sure the number of discrete wavelengths is less or equal to 8.";
Warning::SpanWavelengthOrder="The span wavelength (`1`) is specified from high-wavelength to low-wavelength. The instrument will automatically adjust and scan the samples from low-wavelength to high-wavelength.";

Error::MicrofluidicChipLoading="The specified MicrofluidicChipLoading (`1`) must be set to Robotic or Manual when using Lunatic or, otherwise, to Null. Please make sure this option is set accordingly or consider setting it to Automatic.";
Warning::TemperatureNoEquilibration = "The Temperature option is specified as `1` while EquilibrationTime is specified as `2`. The instrument might not reach the set temperature before starting the temperature-controlled assay, potentially leading to inaccurate results";

(* these are the currently supported plates and plate reader models; using ObjectP below, but not making these patterns themselves because then the error messages will look ugly *)
allowedAbsSpecPlateReaderModels := {Model[Instrument, PlateReader, "PHERAstar FS"], Model[Instrument, PlateReader, "FLUOstar Omega"], Model[Instrument, PlateReader, "Lunatic"],Model[Instrument,PlateReader,"CLARIOstar"], Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"]};


(* Store a list of available cuvette models *)
absorbanceAllowedCuvettes = {
	Model[Container, Cuvette, "id:eGakld01zz3E"], (* Micro scale *)
	Model[Container, Cuvette, "id:R8e1PjRDbbld"], (* Semi-micro scale *)
	Model[Container, Cuvette, "id:Y0lXejGKdd1x"], (* Standard scale *)
	Model[Container, Cuvette, "id:Vrbp1jKkre0x"], (* Micro scale with Stirring *)
	Model[Container, Cuvette, "id:Y0lXejMD0VBm"], (* Semi-micro scale with Stirring *)
	Model[Container, Cuvette, "id:mnk9jOR4n89R"], (* Standard scale with Stirring *)
	Model[Container, Cuvette, "id:D8KAEvK9DoWb"] (* Semi-Micro Disposable PS Cuvette *)
};
absorbanceAllowedCuvettesP = Alternatives@@absorbanceAllowedCuvettes;

absorbanceAllowedCuvettesForAutomaticResolution[string_]:=absorbanceAllowedCuvettesForAutomaticResolution[string]=Module[{},
	If[!MemberQ[ECL`$Memoization,Experiment`Private`absorbanceAllowedCuvettesForAutomaticResolution],
		AppendTo[ECL`$Memoization,Experiment`Private`absorbanceAllowedCuvettesForAutomaticResolution]
	];
	Search[Model[Container,Cuvette],EngineDefault==True]
];

(* Store a list of the options that are listable per-sample rather than per-cuvette *)
absorbanceSampleIndexedOptions = {AliquotVolume,TargetConcentration};

(* Store a list of the options that are MapThreaded; calculated only once upon loading, because it shouldn't change *)
absorbanceCuvetteIndexedOptions = Module[
	{optionDefs,optionNames,mapThreadBools},

	optionDefs = OptionDefinition[ExperimentAbsorbanceSpectroscopy];

	optionNames = Lookup[optionDefs,"OptionName"];

	mapThreadBools = MatchQ[#,"Input"]&/@Lookup[optionDefs,"IndexMatching",Null];

	Pick[optionNames,mapThreadBools]

];
absorbanceCuvetteIndexedOptionQ[optionName_Symbol] := MemberQ[absorbanceCuvetteIndexedOptions,optionName];


(* ::Subsubsection::Closed:: *)



(* Authors definition for BMGCompatiblePlates *)
Authors[BMGCompatiblePlates]:={"axu"};

BMGCompatiblePlates[Absorbance] := BMGCompatiblePlates[Absorbance] = Module[
	{compatiblePlates},

	(* get all the compatible plates; they don't even necessarily need to be liquid handleable *)
	compatiblePlates = Search[
		Model[Container, Plate],
		And[
			(* the 36 well plate is for the weird testing plate; it is treated like a 96 well plate elsewhere so we're just going to do so now too*)
			NumberOfWells == (96 | 384 | 36),
			Opaque != True,
			Dimensions[[3]] <= 2.0 Centimeter,
			Footprint == Plate
		]
	];

	(* for now deleting filter plates because those won't work here, but I don't want to set SubTypes -> False in the Search call because there could in the future be acceptable subtypes *)
	DeleteCases[compatiblePlates, ObjectP[{Model[Container, Plate, Filter], Model[Container, Plate, Irregular]}]]

];


(* Authors definition for BMGCompatiblePlatesP *)
Authors[BMGCompatiblePlatesP]:={"axu"};

BMGCompatiblePlatesP[Absorbance] := Alternatives@@BMGCompatiblePlates[Absorbance];

(* --- Core Function --- *)
ExperimentAbsorbanceSpectroscopy[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopy]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests, upload,
		confirm, canaryBranch, fastTrack, parentProt, unresolvedOptions, unresolvedOptionsTests, combinedOptions, resolveOptionsResult,
		resolvedOptionsNoHidden, allTests, estimatedRunTime,
		resourcePackets, resourcePacketTests, simulatedProtocol, simulation,
		resolvedOptions, resolutionTests, returnEarlyQ, performSimulationQ, validLengths, validLengthTests, expandedCombinedOptions, specifiedInstruments, protocolObject,
		cache, newCache, allPackets, listedSamples, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationSimulation, downloadFields, mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed
	},

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
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAbsorbanceSpectroscopy,
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
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAbsorbanceSpectroscopy, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAbsorbanceSpectroscopy, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

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
		ValidInputLengthsQ[ExperimentAbsorbanceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAbsorbanceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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
	{upload, confirm, canaryBranch, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, unresolvedOptionsTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentAbsorbanceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAbsorbanceSpectroscopy, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, unresolvedOptionsTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentAbsorbanceSpectroscopy, {mySamplesWithPreparedSamples}, combinedOptions]];

	(* get all specified instruments *)
	specifiedInstruments = DeleteDuplicates[Cases[Flatten[Lookup[combinedOptions, {Instrument}]], ObjectP[{Object[Instrument], Model[Instrument]}]]];

	(* get all the Download fields *)
	downloadFields = {
		{
			Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]],
			Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
			Packet[Field[Composition[[All, 2]][{CellType, Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight}]]]
		},
		{
			Packet[Model, Status, IntegratedLiquidHandler, WettedMaterials, PlateReaderMode, SamplingPatterns, IntegratedLiquidHandlers],
			Packet[Model[{WettedMaterials, PlateReaderMode, SamplingPatterns}]],
			Packet[IntegratedLiquidHandler[Model]],
			Packet[IntegratedLiquidHandler[Model][Object]],
			Packet[IntegratedLiquidHandlers[Object]]
		}
	};

	(* make the up front Download call *)
	allPackets = Check[
		Quiet[
			Download[
				{
					mySamplesWithPreparedSamples,
					specifiedInstruments
				},
				Evaluate[downloadFields],
				Cache -> cache,
				Simulation->samplePreparationSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allPackets, $Failed],
		Return[$Failed]
	];

	(* Download information we need in both the Options and ResourcePackets functions *)
	newCache = FlattenCachePackets[{cache, allPackets, standardPlatesDownloadCache["Memoization"]}];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolutionTests} = resolveAbsorbanceOptions[Object[Protocol, AbsorbanceSpectroscopy], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolutionTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolutionTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolutionTests} = {resolveAbsorbanceOptions[Object[Protocol, AbsorbanceSpectroscopy], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation], Null},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveAbsorbanceOptions doesn't have access to myOptionsWithPreparedSamples *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAbsorbanceSpectroscopy,
		RemoveHiddenOptions[ExperimentAbsorbanceSpectroscopy, resolvedOptions],
		Ignore -> ToList[myOptionsWithPreparedSamples],
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

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP] || MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Tests -> Flatten[{safeOptionTests, unresolvedOptionsTests, resolutionTests}],
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* call the absorbanceResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{resourcePackets, resourcePacketTests} = Which[
		MatchQ[resolveOptionsResult, $Failed],
			{$Failed,{}},
		gatherTests,
			absorbanceResourcePackets[
				Object[Protocol, AbsorbanceSpectroscopy],
				Download[mySamplesWithPreparedSamples, Object],
				unresolvedOptions,
				ReplaceRule[resolvedOptions, {Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation}]
			],
		True,
			{
				absorbanceResourcePackets[
					Object[Protocol, AbsorbanceSpectroscopy],
					Download[mySamplesWithPreparedSamples, Object],
					unresolvedOptions,
					ReplaceRule[resolvedOptions, {Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation}]],
				Null
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, AbsorbanceSpectroscopy],
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
			Cache->newCache,
			Simulation->samplePreparationSimulation
		],
		{Null, samplePreparationSimulation}
	];

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, unresolvedOptionsTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification /.{
			Result -> Null,
			Tests -> allTests,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> estimatedRunTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[

		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, return $Failed *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolveOptionsResult,$Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic]&&MatchQ[upload,False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic],
		Module[{primitive, nonHiddenOptions,experimentFunction},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive=AbsorbanceSpectroscopy@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[AbsorbanceSpectroscopy,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentAbsorbanceSpectroscopy,resolvedOptionsNoHidden];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentAbsorbanceSpectroscopy so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentAbsorbanceSpectroscopy, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentAbsorbanceSpectroscopy]={};

				ExperimentAbsorbanceSpectroscopy[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification=Lookup[ToList[options], Output];

					frameworkOutputSpecification/.{
						Result -> resourcePackets[[2]],
						Options -> nonHiddenOptions,
						Preview -> Null,
						Simulation -> simulation,
						RunTime -> estimatedRunTime
					}
				];

				experimentFunction[
					{primitive},
					Name->Lookup[safeOptions,Name],
					Upload->Lookup[safeOptions,Upload],
					Confirm->Lookup[safeOptions,Confirm],
					CanaryBranch->Lookup[safeOptions,CanaryBranch],
					ParentProtocol->Lookup[safeOptions,ParentProtocol],
					Priority->Lookup[safeOptions,Priority],
					StartDate->Lookup[safeOptions,StartDate],
					HoldOrder->Lookup[safeOptions,HoldOrder],
					QueuePosition->Lookup[safeOptions,QueuePosition],
					Cache->newCache
				]
			]
		],

		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			Upload->Lookup[safeOptions,Upload],
			Confirm->Lookup[safeOptions,Confirm],
			CanaryBranch->Lookup[safeOptions,CanaryBranch],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,AbsorbanceSpectroscopy],
			Cache -> newCache,
			Simulation -> simulation
		]
	];

	(* return the output as we desire it *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> allTests,
		Options -> resolvedOptionsNoHidden,
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}

];



(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopy (container input) *)


ExperimentAbsorbanceSpectroscopy[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String| {LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopy]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, containerToSampleResult,containerToSampleSimulation,
		containerToSampleTests, inputSamples, messages, listedContainers, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationSimulation, containerToSampleOutput, sampleOptions},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAbsorbanceSpectroscopy,
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
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentAbsorbanceSpectroscopy,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentAbsorbanceSpectroscopy,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[ToList[containerToSampleResult],{$Failed..}],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{inputSamples,sampleOptions}=containerToSampleOutput;

		(* call ExperimentAbsorbanceSpectroscopy and get all its outputs *)
		ExperimentAbsorbanceSpectroscopy[inputSamples, ReplaceRule[sampleOptions, Simulation->containerToSampleSimulation]]
	]
];



(* ::Subsubsection:: *)
(* resolveReadPlateMethod *)

DefineOptions[resolveReadPlateMethod,
	SharedOptions:>{
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySamples can be Automatic when the user has not yet specified a value for autofill. *)
resolveReadPlateMethod[
	mySamples:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container], Model[Sample]}]|{LocationPositionP,ObjectP[Object[Container]]}],
	myType:(
		Object[Protocol, AbsorbanceSpectroscopy] | Object[Protocol, AbsorbanceIntensity] | Object[Protocol, AbsorbanceKinetics] |
		Object[Protocol, FluorescenceSpectroscopy] | Object[Protocol, FluorescenceIntensity] | Object[Protocol, FluorescenceKinetics] |
		Object[Protocol, FluorescencePolarization] | Object[Protocol, FluorescencePolarizationKinetics] |
		Object[Protocol, LuminescenceSpectroscopy] | Object[Protocol, LuminescenceIntensity] | Object[Protocol, LuminescenceKinetics] |
		Object[Protocol, AlphaScreen] | Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics]
	),
	experimentOptions:{___Rule},
	myOptions:OptionsPattern[resolveReadPlateMethod]
]:=Module[
	{safeOptions, allOptions, outputSpecification, output, gatherTests, containerPackets, instrumentModel, instrumentOption,
		allModelContainerPackets, allModelContainerPlatePackets, liquidHandlerIncompatibleContainers, samplePackets, allPackets, instrumentPacket,
		manualRequirementStrings, roboticRequirementStrings, result, tests, validPlateModelsList},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveReadPlateMethod, ToList[myOptions]];

	(* combine all options- the options are separated like this so that this function will work for all plate reader experiments *)
	allOptions = ReplaceRule[experimentOptions,safeOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	instrumentOption = Lookup[allOptions, Instrument]/.Automatic->Null;

	(* Download information that we need from our inputs and/or options. *)
	{containerPackets, samplePackets, instrumentPacket}=Quiet[
		Download[
			{
				Cases[Flatten[ToList[mySamples]], ObjectP[Object[Container]]],
				Cases[Flatten[ToList[mySamples]], ObjectP[Object[Sample]]],
				Flatten[{instrumentOption}]
			},
			{
				{Packet[Model[{Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]},
				{Packet[Container], Packet[Container[Model[{Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]]},
				{Packet[Model]}
			},
			Cache->Lookup[allOptions, Cache, {}],
			Simulation->Lookup[allOptions, Simulation, Null]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Join all packets. *)
	allPackets=Flatten[{containerPackets, samplePackets, instrumentPacket}];

	(* Get all of our Model[Container]s and look at their footprints. *)
	allModelContainerPackets=Cases[Flatten[{containerPackets, samplePackets}], PacketP[Model[Container]]];
	allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];
	(* Get the containers that are liquid handler incompatible (plate reader only accepts plate) *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[Plate]]],Object,{}],
			Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];


	(* Check if the instrumentOption is Automatic/Model/Object *)
	instrumentModel = Switch[instrumentOption,
		(* If instrumentOptions is still Automatic, we don't have to do anything at this point *)
		Automatic,
		Null,
		(* If instrumentOption is a Model, return directly *)
		ObjectP[{Model[Instrument, PlateReader], Model[Instrument, Nephelometer], Model[Instrument, Spectrophotometer]}],
		instrumentOption,
		(* If instrumentOption is an Object, return its Model *)
		ObjectP[{Object[Instrument, PlateReader], Object[Instrument, Nephelometer], Object[Instrument, Spectrophotometer]}],
		Lookup[Flatten[instrumentPacket,1], Model]
	];

	(* Get the valid container models that can be used with this experiment. If the sample is not already in one of these *)
	(* containers, then we cannot perform the experiment robotically. *)
	validPlateModelsList=Switch[myType,
		Object[Protocol, AbsorbanceSpectroscopy] | Object[Protocol, AbsorbanceIntensity] | Object[Protocol, AbsorbanceKinetics],
		Flatten[{BMGCompatiblePlates[Absorbance],absorbanceAllowedCuvettes}],

		Alternatives[
			Object[Protocol,FluorescenceIntensity],
			Object[Protocol,FluorescenceKinetics],
			Object[Protocol,FluorescenceSpectroscopy],
			Object[Protocol,LuminescenceIntensity],
			Object[Protocol,LuminescenceKinetics],
			Object[Protocol,LuminescenceSpectroscopy],
			Object[Protocol,FluorescencePolarization],
			Object[Protocol,FluorescencePolarizationKinetics]
		],
			BMGCompatiblePlates[Fluorescence],

		Object[Protocol, AlphaScreen],
			BMGCompatiblePlates[AlphaScreen],

		Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics],
			BMGCompatiblePlates[Nephelometry]
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the sample containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible",
			Nothing
		],
		Module[{incompatibleContainerModels},
			incompatibleContainerModels=Complement[DeleteDuplicates[Lookup[allModelContainerPackets, Object, {}]], validPlateModelsList];

			If[Length[incompatibleContainerModels]>0,
				"the container models "<>ObjectToString[incompatibleContainerModels]<>" are not compatible with the plate reader and thus require an aliquot (manual only) into a compatible container. Please consult the experiment help file documentation for a full list of compatible containers. In order to perform the unit operation robotically, please prepare the samples in a compatible container model",
				Nothing
			]
		],
		Module[{duplicatedSamples},
			duplicatedSamples=Cases[Tally[Download[Cases[mySamples, ObjectP[]], Object]], {_, GreaterP[1]}][[All,1]];

			If[Length[duplicatedSamples]>0,
				"the sample(s), "<>ObjectToString[duplicatedSamples]<>", are replicated -- in order for a sample to be measured multiple times, an aliquot is required. Please perform an aliquot prior to reading the samples in the plate",
				Nothing
			]
		],
		(* NOTE: If we are using Lunatic or PHERAstar, we can only do it manually *)
		If[MatchQ[instrumentModel, ObjectP[{Model[Instrument, PlateReader, "id:N80DNj1lbD66"], Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]}]],  (* Lunatic or PHERAstar *)
			"the Lunatic and PHERAstar instruments can only be used manually",
			Nothing
		],
		(* FluorescencePolarization and FluorescencePolarizationKinetics experiments can only be done on the PHERAstar, which can only be used manually *)
		If[MatchQ[myType, Object[Protocol, FluorescencePolarization] | Object[Protocol, FluorescencePolarizationKinetics]],
			"FluorescencePolarization and FluorescencePolarizationKinetics experiments can only be performed manually",
			Nothing
		],
		If[MemberQ[Lookup[allOptions, Blanks, {}], ObjectP[Model[]]] || MemberQ[Lookup[allOptions, BlankVolumes, {}], VolumeP],
			"manual aliquots must be made to transfer the Blanks into the measurement plate (only existing samples, created via previous Transfer[...] unit operations, can be used as blanks if Preparation->Robotic)",
			Nothing
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{ImageSample, MeasureVolume, MeasureWeight, PreparatoryUnitOperations},(!MatchQ[Lookup[allOptions, #, Null], ListableP[{}|False|Null|Automatic]]&)];

			(* if PrepUO matches this super strict pattern that means we are dealing with a model sample, in which case it is okay to do Robotic *)
			If[Length[manualOnlyOptions]>0 && Not[MatchQ[Lookup[allOptions, PreparatoryUnitOperations], {_[LabelSample[KeyValuePattern[{Label -> {__?(StringStartsQ[#, "Prepared sample "] &)}}]]]}]],
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{DualEmissionWavelength, DualEmissionGain},(!MatchQ[Lookup[allOptions, #, Null], ListableP[Null|Automatic]]&)];

			If[Length[manualOnlyOptions]>0,
				"the following options "<>ToString[manualOnlyOptions]<>" are only supported by the PHERAstar, which is not integrated on a robotic workcell",
				Nothing
			]
		],
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[{MoatBuffer, MoatSize, MoatVolume, NumberOfReplicates, DilutionCurve, SerialDilutionCurve, Diluent},(!MatchQ[Lookup[allOptions, #, Null], ListableP[Null|Automatic]]&)];

			If[Length[manualOnlyOptions]>0,
				"the following options "<>ToString[manualOnlyOptions]<>" require aliquotting and thus are only supported Manually. Please build your Transfer[...] unit operations to first create a moat, if you'd like your plate to be read with a moat.",
				Nothing
			]
		],
		If[MemberQ[allOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[allOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[allOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[allOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[Lookup[Cases[Flatten[samplePackets,1],PacketP[]], LiquidHandlerIncompatible], True],
			"the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[Cases[Flatten[samplePackets,1],PacketP[]], KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->allPackets],
			Nothing
		],
		If[MatchQ[Lookup[allOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[allOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		Message[
			Error::ConflictingMethodRequirements,
			listToString[manualRequirementStrings],
			listToString[roboticRequirementStrings]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		!MatchQ[Lookup[allOptions, Preparation, Automatic], Automatic],
			Lookup[allOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the plate reader primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];



(* NOTE: You should NOT throw messages in this function. Just return the work cells by which you can perform your primitive with *)
(* the given options. *)
(* NOTE: This is a simple function, but is needed for our primitive to slot into the framework. Plate Reader experiments can be done on the STAR,
bioSTAR, or microbioSTAR, depending on CellType, except FluorescencePolarization and FluorescencePolarizationKinetics, which cannot be performed robotically since the PHERAstar is not attached to a robot *)
resolveReadPlateWorkCell[
	myFunction:(
		ExperimentAbsorbanceSpectroscopy|ExperimentAbsorbanceIntensity|ExperimentAbsorbanceKinetics|
		ExperimentLuminescenceSpectroscopy|ExperimentLuminescenceIntensity|ExperimentLuminescenceKinetics|
		ExperimentFluorescenceSpectroscopy|ExperimentFluorescenceIntensity|ExperimentFluorescenceKinetics|
		ExperimentFluorescencePolarization|ExperimentFluorescencePolarizationKinetics|
		ExperimentAlphaScreen|ExperimentNephelometry|ExperimentNephelometryKinetics
	),
	mySamples:ListableP[(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|{LocationPositionP,ObjectP[Object[Container]]}|Automatic)],
	myOptions:OptionsPattern[]
]:= Module[
	{specifiedInstrument, objectsToDownload, fieldsToDownload, allDownloads, containerPackets, samplePackets, integratedLHModels, integratedWorkCells, allCellTypes},

	(* determine the objects to download *)
	(* find out the specified instrument option *)
	specifiedInstrument = Lookup[myOptions, Instrument];

	(* if user supplied a instrument object or model, include that, otherwise just download input sample/container information *)
	objectsToDownload = {
		Cases[mySamples, ObjectP[Object[Container]]],
		Cases[mySamples, ObjectP[Object[Sample]]],
		If[MatchQ[specifiedInstrument, ObjectP[{Object[Instrument], Model[Instrument]}]], {specifiedInstrument}, Nothing]
	};

	(* determine the field to download *)
	fieldsToDownload = {
		{Packet[Field[Contents[[All, 2]][{CellType}]]]},
		{Packet[CellType]},
		Switch[specifiedInstrument,
			(* if we are given a instrument model, need to check if it is integrated with a given liquid handler model already *)
			ObjectP[Model[Instrument]],
			{IntegratedLiquidHandlers[Object]},
			(* if we are given a instrument object, need to check if it is integrated with a given liquid handler object already *)
			ObjectP[Object[Instrument]],
			{IntegratedLiquidHandler[Model][Object]},
			(* no instrument, nothing to download here *)
			_,
			Nothing
		]
	};

	(* Download information that we need from our inputs and/or options. *)
	allDownloads = Quiet[
		Download[
			objectsToDownload,
			Evaluate[fieldsToDownload],
			Cache -> Lookup[ToList[myOptions], Cache, {}],
			Simulation -> Lookup[ToList[myOptions], Simulation, Null],
			Date -> Now
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* parse packets from download *)
	{containerPackets, samplePackets} = allDownloads[[{1, 2}]];
	integratedLHModels = If[!MatchQ[specifiedInstrument, ObjectP[{Object[Instrument], Model[Instrument]}]],
		Null,
		allDownloads[[3]]
	];

	(* from integrated LH models, get the corresponding work cells *)
	integratedWorkCells = DeleteDuplicates[
		Lookup[Experiment`Private`$InstrumentsToWorkCells,
			Cases[Flatten[{integratedLHModels}], ObjectReferenceP[Model[Instrument, LiquidHandler]]],
			Nothing
		]
	];

	(* Get all of our CellTypes *)
	allCellTypes = Lookup[Cases[Flatten[{containerPackets, samplePackets}], PacketP[Object[Sample]]], CellType];

	(* Determine the WorkCell that can be used (bioSTAR|microbioSTAR|STAR) *)
	Which[
		(* respect user input for sure *)
		MatchQ[Lookup[myOptions, WorkCell, Automatic], WorkCellP],
			ToList@Lookup[myOptions, WorkCell, Automatic],
		(* if user provided a instrument model and it has integrated liquid handler models, use the workcell from those LH models *)
		MatchQ[specifiedInstrument, ObjectP[Model[Instrument]]] && Length[integratedWorkCells] > 0,
			integratedWorkCells,
		(* if user provided a instrument object, then this object MUST have already been integrated to a LH, otherwise, it does not make sense *)
		MatchQ[specifiedInstrument, ObjectP[Object[Instrument]]],
			integratedWorkCells,
		MatchQ[myFunction, ExperimentNephelometry | ExperimentNephelometryKinetics] && MemberQ[allCellTypes, MicrobialCellTypeP],
			{microbioSTAR},
		MatchQ[myFunction, ExperimentNephelometry | ExperimentNephelometryKinetics] && MatchQ[allCellTypes, {(NonMicrobialCellTypeP | Null)..}],
			{bioSTAR, microbioSTAR},
		MatchQ[myFunction, ExperimentNephelometry | ExperimentNephelometryKinetics],
			{bioSTAR, microbioSTAR},
		!MemberQ[allCellTypes, CellTypeP],
			{STAR, bioSTAR, microbioSTAR},
		MatchQ[allCellTypes, {(Mammalian | Null)..}],
			{bioSTAR, STAR, microbioSTAR},
		True,
			{microbioSTAR, bioSTAR, STAR}
	]
];




(* ::Subsubsection:: *)
(*resolveAbsorbanceOptions *)


DefineOptions[resolveAbsorbanceOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* private function to resolve all the options for either AbsorbanceSpectroscopy or AbsorbanceIntensity depending on what we're doing *)
resolveAbsorbanceOptions[
	myType : (Object[Protocol, AbsorbanceSpectroscopy] | Object[Protocol, AbsorbanceIntensity] | Object[Protocol, AbsorbanceKinetics]),
	mySamples : {ObjectP[Object[Sample]]..},
	myOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[resolveAbsorbanceOptions]
] := Module[
	{outputSpecification,output,gatherTests,messages,inheritedCache,simulatedCache,samplePrepOptions,absSpecOptions,absSpecOptionsAssoc,
		experimentFunction,experimentMode,allInstrumentModels,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,resolveSamplePrepTests,wavelengthOptionName,
		specifiedMethods,specifiedInstrument,specifiedInstrumentModel,specifiedSpectralBandwidth,specifiedStirBar,specifiedAcquisitionMix,specifiedAcquisitionMixRate,specifiedAcquisitionMixRateIncrements,specifiedMinAcquisitionMixRate,
		specifiedMaxAcquisitionMixRate,specifiedMaxStirAttempts,specifiedAdjustMixRate,specifiedRecoupSample,specifiedContainerOut,specifiedSamplesOutStorageCondition,numberOfReplicates,blankAbsorbance,name,preparationResult,
		allowedPreparation,preparationTest,resolvedPreparation,resolvedWorkCell,acquisitionMixRateRangeMismatch,mismatchingAcquisitionMixRateTests,mismatchingAcquisitionMixRateOptions,mismatchCuvettePlateReaderValidQ,mismatchCuvettePlateReaderTestString,mismatchCuvettePlateReaderTest,mismatchCuvettePlateReaderOptions,specifiedTemperatureMonitor,
		mismatchCuvetteMoatValidQ,mismatchCuvetteMoatTestString,mismatchCuvetteMoatTest,mismatchCuvetteMoatOptions,
		mismatchCuvettePlateSamplingValidQ,mismatchCuvettePlateSamplingTestString,mismatchCuvettePlateSamplingTest,mismatchCuvettePlateSamplingOptions,
		specifiedTemp,specifiedPlateReaderMixRate,specifiedPlateReaderMixTime,specifiedPlateReaderMix,specifiedPlateReaderMixMode,
		specifiedPlateReaderMixSchedule,specifiedEquilibrationTime,specifiedMoatBuffer,specifiedMoatVolume,specifiedMoatSize,
		specifiedReadDirection,injectionOptionNames,injectionOptions,bmgRequired,instrument,uniqueInjectionSamples,uniqueBlankSamples,
		preresolvedInstrument,potentialAnalytesToUse,possibleAliquotContainers,listedSampleContainerPackets,listedContainerInPackets,listedInjectionSamplePackets,listedBlankPackets,
		parentProt,specifiedQuantifyConcentration,specifiedTargetCarbonDioxideLevel, specifiedTargetOxygenLevel,
		listedInstrumentPackets,listedAliquotContainerPackets,samplePackets,containerPackets,
		sampleContainerModelPackets,containerInPackets,injectionSamplePackets,blankSamplePackets,blankContainerPackets,suppliedInstrumentPacket,suppliedModelInstrumentPacket,instrumentPacket,
		modelInstrumentPacket,allInstrumentPacketLists,allPlateReaderModelPackets,aliquotContainerModelPacket,discardedSamplePackets,discardedInvalidInputs,discardedTest,
		cuvetteQ,spectralBandwidthValidQ,spectralBandwidthTestString,spectralBandwidthIncompatibleTest,spectralBandwidthIncompatibleInvalidOptions,acquisitionMixValidQ,acquisitionMixTestString,
		acquisitionMixIncompatibleTest,acquisitionMixIncompatibleInvalidOptions,acquisitionMixQ,acquisitionMixDependentOptionsValidQ,acquisitionMixDependentOptionsTestString,acquisitionMixDependentOptionsIncompatibleTest,acquisitionMixDependentOptionsInvalidOptions,
		supportedInstrumentBool,supportedModeBool,validInstrumentOption,supportedInstrumentTests,compatibleMaterialsBool,methodsInstrumentValidQ,methodsInstrumentTestString,methodsInstrumentIncompatibleTest,methodsInstrumentIncompatibleOptions,
		compatibleMaterialsTests,compatibleMaterialsInvalidOption,optionPrecisions,filteredOptionPrecisions,roundedOptionsAssoc,
		precisionTests,validNameQ,nameInvalidOptions,validNameTest,separateSamplesAndBlanksQ,blanksInvalidTest,blanksInvalidOptions,
		lunaticQ,tempAndTempTimeValidQ,tempAndTempTimeTestString,temperatureIncompatibleTest,temperatureIncompatibleInvalidOptions,
		plateReaderMixTests,plateReaderMixOptionInvalidities,lunaticMixingError,lunaticMixTest,invalidLunaticMixOptions,
		moatInstrumentTest,readDirectionError,readDirectionInvalidOptions,readDirectionTest,injectionInstrumentError,injectionInstrumentInvalidOptions,
		injectionInstrumentTest,anyInjectionsQ,specifiedRetainCover,resolvedRetainCover,validRetainCover,retainCoverTest,injectionSampleStateError,injectionSampleStateErrorTest,invalidCoverOption,invalidCoverInstrument,
		invalidCoverInstrumentTest,specifiedWavelength,specifiedReadOrder,orderError,invalidOrderOption,
		orderTest,exceedWavelengthError,invalidWavelengthOption,wavelengthTest,spanWavelengthWarning,spanWavelengthWarningTest,resolvedACUOptions, resolvedACUInvalidOptions, resolvedACUTests, roundedTemperature,temperature,specifiedEquilibrationTimePostRounding,
		resolvedMethods,preresolvedAcquisitionMix,resolvedAcquisitionMix,roundedAcquisitionMixRate,roundedMinAcquisitionMixRate,roundedMaxAcquisitionMixRate,roundedAcquisitionMixRateIncrements,defaultSpectralBandwidth,
		roundedSpectralBandwidth,resolvedSpectralbandwidth,defaultAcquisitionMixRate,defaultMinAcquisitionMixRate,defaultMaxAcquisitionMixRate,defaultAcquisitionMixRateIncrements,
		defaultMaxStirAttempts,resolvedAcquisitionMixRate,resolvedMinAcquisitionMixRate,resolvedMaxAcquisitionMixRate,resolvedAcquisitionMixRateIncrements,resolvedMaxStirAttempts,resolvedAdjustMixRate,resolvedCuvetteContainerModels,
		temperatureEquilibriumTime,resolvedReadDirection,resolvedPlateReaderMix,defaultMixingRate,defaultMixingTime,
		defaultMixingMode,defaultMixingSchedule,roundedMixTime,roundedPlateReaderMixRate,resolvedPlateReaderMixRate,resolvedPlateReaderMixTime,resolvedPlateReaderMixMode,resolvedCuvetteStirBars,resolvedContainersOut,resolvedRecoupSamples,resolvedSamplesOutStorageCondition,
		resolvedPlateReaderMixSchedule,suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate,primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ,resolvedPrimaryFlowRate,resolvedSecondaryFlowRate,resolvedTertiaryFlowRate,resolvedQuaternaryFlowRate,impliedMoat,
		resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize,suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,
		suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers, suppliedAliquotContainerModels,
		automaticAliquotingBooleans,uniqueContainers,
		tooManySourceContainers,numberOfAliquotContainers,tooManyAliquotContainers,replicateAliquotsRequired,replicatesError,
		replicatesWarning,sampleRepeatAliquotsRequired,sampleRepeatError,sampleRepeatWarning,bmgAliquotRequired,blankAliquotRequired,specifiedBlanks,specifiedBlankVolumes,aliquotContainerConflicts,badAliquotContainerOptions,
		badAliquotContainerTests,unresolvedAliquotContainers,unresolvedAliquotContainerModels,totalVolumeConflicts,badTotalVolumeOptions,badTotalVolumeTests,cuvettePackets,nonLiquidSamplePackets,nonLiquidSampleInvalidInputs,nonLiquidSampleTest,
		potentialAnalyteTests,suppliedConsolidateAliquots,suppliedSamplingPattern,suppliedSamplingDistance,suppliedSamplingDimension,containerOutConflicts,badContainerOutOptions,badContainerOutTests,
		plateReaderTemperatureNoEquilibrationWarning, plateReaderTemperatureNoEquilibrationTest,
		validSamplingCombo,validSamplingComboTest,resolvedSamplingPattern,samplingRequested,instrumentSupportedSampling,noSampling,validSamplingInstrumentTest,
		plateReadersForSampling,anyInstrumentSupportsSampling,validSamplingModeTest,validSamplingInstrumentCombo,validSamplingInstrumentComboTest,invalidSamplingOptions,
		preresolvedNumReplicates,blanksWithVolumesToMove,numberOfTransferBlanks,containerContents,numbersOfWells,insufficientBlankSpace,
		blankSpaceError,blankSpaceWarning,aliquotContainerTest,replicatesAliquotTest,sampleRepeatTest,blankSpaceTest,invalidAliquotOption,mapThreadFriendlyOptions,
		quantificationWavelengths,preferredWavelengths,quantifyConcentrations,blanks,blankVolumes,concInvalidOptionsErrors,extCoefficientNotFoundWarnings,
		incompatibleBlankOptionsErrors,blankVolumeNotAllowedErrors,blankContainerErrors,blankContainerWarnings,
		blankObjects,numBlanks,numOfBlankAdditions,totalNumSamples,resolvedNumberOfReplicates,tooFewReplicatesWarning,tooFewReplicatesTest,intNumReplicates,
		missingExtCoefficientErrors,specifiedAnalytes,quantificationAnalytes,resolvedNumberOfReadings,specifiedNumReadings,specifiedMicrofluidicChipLoading,
		sampleCompositionPackets,sampleContainsAnalyteErrors,sampleContainsAnalyteOptions,sampleContainsAnalyteOptionTests,
		preResolvedQuantifyConcentration,preResolvedQuantAnalyte,resolvedConsolidateAliquots,simulation,
		plateReaderNumberOfReadingsErrorQ,plateReaderNumberOfReadingsNullQ,plateReaderNumberOfReadingsErrorTest,plateReaderNumberOfReadingsInvalidOptions,
		tooManySamplesError,tooManySamplesOptions,tooManySamplesTest,tooManyBlanksError,tooManyBlanksOptions,blankAliquotError,tooManyBlanksTest,blankContainerErrorTest,incompatibleBlankVolumesInvalidOptions,
		blankContainerWarningTest,incompatibleBlankInvalidOptions,incompatibleBlankOptionTests,selectedBlanks,nonLiquidBlanksBoolean,nonLiquidBlanks,blankStateWarning,blankStateWarningTest,sampleVolumes,sampleObjs,notEqualBlankVolumes,notEqualSamples,notEqualBlankVolumesWarning,notEqualBlankVolumesWarningTest,skippedInjectionError,injectionQList,injectionOptionList,skippedInjectionIndex,invalidSkippedInjection,skippedInjectionErrorTest,blankVolumeNotAllowedInvalidOptions,blankVolumeNotAllowedTests,
		quantRequiresBlankingInvalidOptions,quantRequiresBlankingTest,concInvalidOptions,concInvalidOptionsTests,extCoefficientNotFoundTests,
		missingExtinctionCoefficientOptions,missingExtinctionCoefficientOptionTests,invalidMoatOptions,moatTests,moatError,moatInstrumentInvalidOptions,
		preresolvedAliquot,validPlateModelsList,resolutionAliquotContainer,requiredAliquotContainers,suppliedDestinationWells,
		plateWells,moatWells,suppliedDestinationWellsNoAutomatic,duplicateDestinationWells,duplicateDestinationWellError,duplicateDestinationWellOption,duplicateDestinationWellTest,invalidDestinationWellLengthQ,invalidDestinationWellLengthOption,invalidDestinationWellLengthTest,resolvedDestinationWells,requiredAliquotAmounts,aliquotWarningMessage,preresolvedAliquotOptions,
		resolvedSamplingDistance,resolvedSamplingDimension,resolvedAliquotOptions,resolveAliquotOptionsTests,assayContainerModelPacket,invalidInjectionOptions,validInjectionTests,
		resolvedMicrofluidicChipLoading,microfluidicChipLoadingErrorQ,microfluidicChipLoadingErrorTest,microfluidicChipLoadingInvalidOptions,
		resolvedPostProcessingOptions,email,invalidOptions,invalidInputs,roundedWavelengths,resolvedWavelengths,resolvedOptions,allTests,testsRule,resultRule,
		sampleVolumesTooSmallQ,tooSmallSampleVolumes,sampleVolumesTest,tooSmallSamples,liquidHandlerRequiredDefault,
		resolvedSampleLabels,resolvedSampleContainerLabels,
		resolvedBlankLabels,resolvedTemperatureMonitor,allowedCuvettes,mainDownloadResult,cacheBall,fastCacheBall
	},

	(* --- Setup our user specified options and cache --- *)

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* Stash the parent protocol if there is one *)
	parentProt = Lookup[myOptions,ParentProtocol,Null];

	messages = Not[gatherTests];

	(* pull out the Cache and Simulation option *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* separate out our abs spec options from our sample prep options *)
	(* NOTE: Aliquot options used to be a part of the prep options, but we removed them. We are duplicating them here just so we can do proper lookups *)
	{samplePrepOptions, absSpecOptions} = splitPrepOptions[myOptions];
	AppendTo[absSpecOptions,Cases[samplePrepOptions,Verbatim[Rule][Aliquot|AssayVolume|AliquotContainer,_]]];

	(* change absSpecOptions into an Association from a list because we like replacing rules with Append instead of ReplaceRules now, apparently *)
	absSpecOptionsAssoc = Association[absSpecOptions];

	(* get the experiment function that we care about *)
	{experimentFunction,experimentMode} = Switch[myType,
		Object[Protocol, AbsorbanceSpectroscopy], {ExperimentAbsorbanceSpectroscopy, AbsorbanceSpectroscopy},
		Object[Protocol, AbsorbanceIntensity], {ExperimentAbsorbanceIntensity, AbsorbanceIntensity},
		Object[Protocol, AbsorbanceKinetics], {ExperimentAbsorbanceKinetics, AbsorbanceKinetics}
	];

	(* Search for all plate reader models; we may need this to help resolve options *)
	allInstrumentModels=Join[Search[Model[Instrument,PlateReader],Deprecated!=True&&PlateReaderMode==experimentMode],Search[Model[Instrument, Spectrophotometer],
		Deprecated!=True&&ElectromagneticRange==UV]];

	(* resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, resolveSamplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[experimentFunction, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[experimentFunction, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Merge the simulation result into the simulatedCache *)
	simulatedCache = FlattenCachePackets[{inheritedCache, Lookup[updatedSimulation[[1]], Packets]}];

	(* --- Make our one big Download call --- *)

	(* get the wavelength option we care about *)
	wavelengthOptionName = If[MatchQ[myType, Object[Protocol, AbsorbanceSpectroscopy]], QuantificationWavelength, Wavelength];

	(* Pull out options needed to resolve our instrument prior to download *)
	{
		specifiedMethods,
		specifiedInstrument,
		specifiedSpectralBandwidth,
		specifiedAcquisitionMix,
		specifiedAcquisitionMixRate,
		specifiedAcquisitionMixRateIncrements,
		specifiedMinAcquisitionMixRate,
		specifiedMaxAcquisitionMixRate,
		specifiedMaxStirAttempts,
		specifiedStirBar,
		specifiedAdjustMixRate,
		specifiedRecoupSample,
		specifiedContainerOut,
		specifiedSamplesOutStorageCondition,
		specifiedTemperatureMonitor,
		numberOfReplicates,
		blankAbsorbance,
		name,
		specifiedTemp,
		specifiedPlateReaderMixRate,
		specifiedPlateReaderMixTime,
		specifiedPlateReaderMix,
		specifiedPlateReaderMixMode,
		specifiedPlateReaderMixSchedule,
		specifiedEquilibrationTime,
		specifiedAnalytes,
		specifiedMoatBuffer,
		specifiedMoatVolume,
		specifiedMoatSize,
		specifiedReadDirection,
		suppliedSamplingPattern,
		suppliedSamplingDistance,
		suppliedSamplingDimension,
		specifiedNumReadings,
		specifiedMicrofluidicChipLoading,
		specifiedQuantifyConcentration,
		specifiedTargetCarbonDioxideLevel,
		specifiedTargetOxygenLevel
	} = Lookup[
		absSpecOptionsAssoc,
		{
			Methods,
			Instrument,
			SpectralBandwidth,
			AcquisitionMix,
			AcquisitionMixRate,
			AcquisitionMixRateIncrements,
			MinAcquisitionMixRate,
			MaxAcquisitionMixRate,
			MaxStirAttempts,
			StirBar,
			AdjustMixRate,
			RecoupSample,
			ContainerOut,
			SamplesOutStorageCondition,
			TemperatureMonitor,
			NumberOfReplicates,
			BlankAbsorbance,
			Name,
			Temperature,
			PlateReaderMixRate,
			PlateReaderMixTime,
			PlateReaderMix,
			PlateReaderMixMode,
			PlateReaderMixSchedule,
			EquilibrationTime,
			QuantificationAnalyte,
			MoatBuffer,
			MoatVolume,
			MoatSize,
			ReadDirection,
			SamplingPattern,
			SamplingDistance,
			SamplingDimension,
			NumberOfReadings,
			MicrofluidicChipLoading,
			QuantifyConcentration,
			TargetCarbonDioxideLevel,
			TargetOxygenLevel
		},
		Automatic
	];

	(* List all the injection option names for easy lookup *)
	injectionOptionNames={
		PrimaryInjectionSample,
		PrimaryInjectionVolume,
		PrimaryInjectionTime,
		SecondaryInjectionSample,
		SecondaryInjectionVolume,
		SecondaryInjectionTime,
		TertiaryInjectionSample,
		TertiaryInjectionVolume,
		TertiaryInjectionTime,
		QuaternaryInjectionSample,
		QuaternaryInjectionVolume,
		QuaternaryInjectionTime,
		PrimaryInjectionFlowRate,
		SecondaryInjectionFlowRate,
		TertiaryInjectionFlowRate,
		QuaternaryInjectionFlowRate
	};

	(* Lookup all the injection options *)
	injectionOptions=Lookup[absSpecOptionsAssoc,injectionOptionNames,Automatic];

	(* Plate mixing, injections require BMG *)
	(* Moat only makes sense in a BMG plate *)
	bmgRequired=Or[
		!MatchQ[
			Join[
				{
					specifiedPlateReaderMixRate,
					specifiedPlateReaderMixTime,
					specifiedPlateReaderMix,
					specifiedPlateReaderMixMode,
					specifiedMoatBuffer,
					specifiedMoatVolume,
					specifiedMoatSize,
					specifiedReadDirection,
					suppliedSamplingPattern,
					suppliedSamplingDistance,
					suppliedSamplingDimension,
					specifiedTargetCarbonDioxideLevel,
					specifiedTargetOxygenLevel
				},
				injectionOptions
			],
			{ListableP[Null|Automatic]..}
		],
		MatchQ[experimentMode,AbsorbanceKinetics]
	];

	(* Resolve our preparation option. Do this after resolving the instrument option, as the instrument determines whether the experiment can be done robotically or not.*)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveReadPlateMethod[mySamples, myType, ReplaceRule[Normal@absSpecOptionsAssoc, {Cache->inheritedCache, Output->Result}], {Cache -> inheritedCache, Output -> Result, Simulation -> simulation}],
				{}
			},
			resolveReadPlateMethod[mySamples, myType, ReplaceRule[Normal@absSpecOptionsAssoc, {Cache->inheritedCache, Output->{Result, Tests}}], {Cache -> inheritedCache, Output -> {Result, Tests}, Simulation -> simulation}]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve our WorkCell option. Do this after resolving the Preparation option, as this is only relevant if the experiment will be performed robotically.*)
	resolvedWorkCell = If[MatchQ[resolvedPreparation, Robotic],
		FirstOrDefault@Experiment`Private`resolveReadPlateWorkCell[
			experimentFunction,
			mySamples,
			ReplaceRule[Normal@absSpecOptionsAssoc, {Cache->inheritedCache, Preparation->resolvedPreparation}]
		],
		Null
	];

	(* get the model of the specified instrument *)
	specifiedInstrumentModel = Which[
		(* if we are provided with a instrument object, then we have to do this standalone download here *)
		MatchQ[specifiedInstrument, ObjectP[Object[Instrument]]],
		Download[specifiedInstrument, Model, Cache -> inheritedCache],
		(* if we are provided with a instrument model, then go with that *)
		MatchQ[specifiedInstrument, ObjectP[Model[Instrument]]],
		specifiedInstrument,
		(* otherwise we do not know the model yet *)
		True,
		Null
	];

	(* Resolve the Methods *)
	(* to resolve the method, use the following *)
	(* if Instrument is set, pick the corresponding method (Lunatic -> Microfluidic, PlateReader -> PlateReader, Cary -> Cuvette) *)
	(* If SpectralBandwidth is set, Cuvette *)
	(* if MicrofluidicChipLoading is set, Microfluidic *)
	(* If AcquisitionMix is set, Cuvette*)
	(* If StirBar/AcquisitionMixRate/AdjustMixRate/MinAcquisitionMixRate/MaxAcquisitionMixRate/AcquisitionMixRateIncrements/MaxStirAttempts is set for any sample, Cuvette *)
	(* If ReadDirection/SamplingPattern/SamplingDistance/SamplingDimension/any PlateReaderMixOptions is set, PlateReader *)
	(* If PrimaryInjectionSample/PrimaryInjectionVolume/SecondaryInjectionSample/SecondaryInjectionVolume/PrimaryInjectionFlowRate/SecondaryInjectionFlowRate/InjectionSampleStorageCondition is set for any sample, PlateReader *)
	(* Otherwise, Lunatic since it is the safest option *)
	resolvedMethods = Which[
		Not[MatchQ[specifiedMethods, Automatic]], specifiedMethods,
		(* set to Lunatic if instrument is Lunatic model or object *)
		MatchQ[specifiedInstrumentModel, ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)]], Microfluidic,
		MatchQ[specifiedInstrument, ObjectP[{Object[Instrument, PlateReader], Model[Instrument, PlateReader]}]], PlateReader,
		Not[MatchQ[specifiedMicrofluidicChipLoading, Automatic | Null]], Microfluidic,
		MatchQ[specifiedInstrument, ObjectP[{Object[Instrument, Spectrophotometer], Model[Instrument, Spectrophotometer]}]], Cuvette,
		Not[MatchQ[specifiedSpectralBandwidth, Automatic | Null]], Cuvette,
		Not[ContainsOnly[Flatten[{specifiedAcquisitionMix}], {Automatic, Null}]], Cuvette,
		MemberQ[
			Flatten[{
				specifiedAcquisitionMixRate, specifiedAcquisitionMixRateIncrements, specifiedMinAcquisitionMixRate,
				specifiedMaxAcquisitionMixRate, specifiedMaxStirAttempts, specifiedStirBar, specifiedAdjustMixRate,
				specifiedTemperatureMonitor
			}],
			Except[Automatic | Null]
		], Cuvette,
		MemberQ[
			Flatten[{
				specifiedReadDirection, suppliedSamplingPattern, suppliedSamplingDistance, suppliedSamplingDimension, specifiedPlateReaderMixRate, specifiedPlateReaderMixTime, specifiedPlateReaderMix, specifiedPlateReaderMixMode, specifiedPlateReaderMixSchedule, specifiedMoatBuffer, specifiedMoatVolume, specifiedMoatSize, injectionOptions, specifiedNumReadings, specifiedTargetCarbonDioxideLevel, specifiedTargetOxygenLevel
			}],
			Except[Automatic | Null]
		], PlateReader,
		MatchQ[resolvedPreparation, Robotic], PlateReader,
		Not[MatchQ[specifiedEquilibrationTime, Automatic | Null]] || Not[MatchQ[specifiedTemp, Automatic | Null]], If[MemberQ[Map[(# >= 400 Microliter)&, Download[simulatedSamples, Volume, Simulation -> updatedSimulation]], True], Cuvette, PlateReader],
		bmgRequired, PlateReader,
		True, Microfluidic
	];

	(* pre-resolve the instrument before making the Download call; *)
	(* Always use Lunatic unless BMG is required *)
	(* AbsorbanceKinetics can only be done on a BMG instrument but defaults to Omega (i.e. will never be automatic) *)
	(* preresolve instrument based on resolved methods *)
	(* if specified sampling pattern is ring/matrix/spiral, resolve to CLARIOstar, otherwise, FLUOstar Omega *)
	(* if we are requesting this resolves as a part of a robotic primitive, do not return Lunatic *)
	preresolvedInstrument= Which[
		MatchQ[specifiedInstrument, Except[Automatic]],
			specifiedInstrument,
		(* default to Cary 3500 if we are doing Cuvette *)
		MatchQ[resolvedMethods, Cuvette],
			Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"], (* Cary 3500 *)
		(* default to Lunatic if we are doing Microfluidic *)
		MatchQ[resolvedMethods, Microfluidic],
			Model[Instrument, PlateReader, "id:N80DNj1lbD66"], (* Lunatic *)
		(* if TargetCO2/TargetO2Level is specified, then we only have one option *)
		MemberQ[Flatten[{specifiedTargetCarbonDioxideLevel, specifiedTargetOxygenLevel}], PercentP],
			Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		bmgRequired || MatchQ[resolvedMethods, PlateReader],
			Null,
		MatchQ[resolvedPreparation, Robotic] || MatchQ[Lookup[myOptions, LiquidHandler], True],
			Null,
		True,
			Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)
	];

	(* Get our unique injection samples for download *)
	uniqueInjectionSamples=DeleteDuplicates[
		Download[
			Cases[
				Flatten[Lookup[absSpecOptionsAssoc,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Automatic]],
				ObjectP[Object]
			],
			Object
		]
	];

	(* Get our unique injection blank for download *)
	uniqueBlankSamples=DeleteDuplicates[Download[Cases[Lookup[absSpecOptionsAssoc,Blanks],ObjectP[Object]],Object]];

	(* Get the container we'll use for any aliquots - either the user's or we'll default to first compatible *)
	possibleAliquotContainers=Join[
		DeleteDuplicates[Cases[Flatten[Lookup[samplePrepOptions,AliquotContainer],1],ObjectP[]]],
		{First[BMGCompatiblePlates[Absorbance]]},
		absorbanceAllowedCuvettes
	];

	allowedCuvettes=absorbanceAllowedCuvettesForAutomaticResolution["Memoization"];

	(* Make the Download call *)
	(* --- DO WE ACTUALLY NEED THIS? shouldn't this already covered in the main experiment function? --- *)
	mainDownloadResult = Quiet[
		Download[
			{
				simulatedSamples,
				mySamples,
				uniqueInjectionSamples,
				uniqueBlankSamples,
				{preresolvedInstrument},
				allInstrumentModels,
				allowedCuvettes,
				possibleAliquotContainers
			},
			Evaluate[{
				{
					Packet[IncompatibleMaterials, Well, Volume, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]],
					Packet[Field[Composition[[All, 2]][{CellType, Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight}]]],
					Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
					Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]]
				},
				{
					Packet[IncompatibleMaterials, Well, Volume, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]],
					Packet[Field[Composition[[All, 2]][{CellType, Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight}]]],
					Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
					Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]]
				},
				{Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]]},
				{Packet[Container],Packet[Container[{Model}]],Packet[Container[Model][{MaxVolume,RecommendedFillVolume}]]},
				(* Download info as if we're working with an object and as if we're working with a model *)
				{Packet[Model, Status], Packet[Model[{WettedMaterials, PlateReaderMode, SamplingPatterns}]], Packet[WettedMaterials, PlateReaderMode, SamplingPatterns]},
				{Packet[WettedMaterials, PlateReaderMode, SamplingPatterns]},
				{Packet[MinVolume,MaxVolume,RecommendedFillVolume,Name]},
				{Packet[Model, SamplePreparationCacheFields[Model[Container], Format -> Sequence]]}
			}],
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* update our cache to now include everything that we have just downloaded *)
	cacheBall=Experiment`Private`FlattenCachePackets[{simulatedCache,mainDownloadResult}];

	(* make fast cache ball *)
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* extract out the packets *)
	{listedSampleContainerPackets, listedContainerInPackets,listedInjectionSamplePackets, listedBlankPackets, listedInstrumentPackets, allInstrumentPacketLists, cuvettePackets,listedAliquotContainerPackets}=mainDownloadResult;
	samplePackets = listedSampleContainerPackets[[All, 1]];
	sampleCompositionPackets = listedSampleContainerPackets[[All, 2]];
	containerPackets = listedSampleContainerPackets[[All, 3]];
	sampleContainerModelPackets = listedSampleContainerPackets[[All, 4]];

	containerInPackets = listedContainerInPackets[[All, 3]];

	(* extract injection packets *)
	injectionSamplePackets=listedInjectionSamplePackets[[All,1]];

	(* extract blank packets *)
	blankSamplePackets=listedBlankPackets[[All,1]];
	blankContainerPackets=listedBlankPackets[[All,2]];

	(* extract relevant packets - first two assume instrument, last assumes model *)
	{suppliedInstrumentPacket, suppliedModelInstrumentPacket} = Which[
		MatchQ[preresolvedInstrument,ObjectP[Object]], {listedInstrumentPackets[[1,1]],listedInstrumentPackets[[1,2]]},
		MatchQ[preresolvedInstrument,ObjectP[Model]],{<||>,listedInstrumentPackets[[1,3]]},
		True,{<||>,<||>}
	];

	(* Get a flat list of packets for every plate reader model; we may have to reference these to resolve options *)
	allPlateReaderModelPackets=Select[Flatten[allInstrumentPacketLists, 1], MatchQ[Lookup[#, Type], Model[Instrument,PlateReader]]&];

	(* sort cuvette packets by the recommended fill volume *)
	cuvettePackets=SortBy[Flatten@cuvettePackets,Lookup[#,RecommendedFillVolume]&];

	(* --- Do the Input Validation Checks --- *)

	(* -- Validate Sampling options-- *)
	(* - Check if SamplingDistance, SamplingDimension and SamplingPattern are compatible - *)

	(* SamplingPattern *)

	(* Get the specified wavelength *)
	specifiedWavelength=Lookup[absSpecOptionsAssoc,wavelengthOptionName];

	(* If SamplingDistance is set to a value resolve to Ring somewhat arbitrarily - this is the first thing in BMG's dropdown *)
	resolvedSamplingPattern=Switch[{suppliedSamplingPattern,suppliedSamplingDistance,suppliedSamplingDimension,bmgRequired||MatchQ[resolvedMethods, PlateReader],specifiedWavelength,Length[DeleteDuplicates[ToList[specifiedWavelength]]]},
		{Except[Automatic],_,_,_,_,_},suppliedSamplingPattern,
		{_,_,_Integer,_,ListableP[DistanceP],LessEqualP[8]},Matrix,
		{_,DistanceP,Null|Automatic,_,_,_},Ring,
		{_,_,_,True,_,_},Center,
		_,Null
	];

	(* Determine if the user set anything suggesting they actually want to do sampling *)
	samplingRequested=MemberQ[{suppliedSamplingPattern,suppliedSamplingDistance,suppliedSamplingDimension},Except[Automatic]];

	(* SamplingDistance must be Null if using Center, can't be Null if using any other pattern *)
	(* SamplingDimension only applies to Matrix scans *)
	(* If at least 2 options are left Automatic then we can resolve the other appropriately *)
	validSamplingCombo=MatchQ[
		{suppliedSamplingPattern,suppliedSamplingDistance,suppliedSamplingDimension,specifiedWavelength,Length[DeleteDuplicates[ToList[specifiedWavelength]]],myType},
		Alternatives[
			{Center,Null|Automatic,Null|Automatic,_,_,_},
			{Matrix,DistanceP|Automatic,Automatic|_Integer,ListableP[DistanceP]|ListableP[Automatic],LessEqualP[8],Object[Protocol,AbsorbanceIntensity]},
			(* We have different errors for AbsorbanceKinetics later, if the number of wavelengths is more than 8 *)
			{Matrix,DistanceP|Automatic,Automatic|_Integer,ListableP[DistanceP]|ListableP[Automatic],_,Object[Protocol,AbsorbanceKinetics]},
			(* Matrix is NOT allowed in AbsorbanceSpectroscopy and we have UnsupportedInstrumentSamplingPattern for this later. Let it go here. *)
			{Matrix,DistanceP|Automatic,Automatic|_Integer,_,_,Object[Protocol,AbsorbanceSpectroscopy]},
			{Except[Center|Matrix,PlateReaderSamplingP],DistanceP,Automatic|Null,_,_,_},
			{Automatic,DistanceP,_Integer,_,_,_},
			{Automatic,DistanceP,Null,_,_,_},
			{Null,Null|Automatic,Null|Automatic,_,_,_},
			(* We covered all valid cases of Matrix above so if we get here, it is invalid *)
			_?(Length[Cases[#[[1;;3]],Automatic]]>=2&&!MatchQ[suppliedSamplingPattern,Matrix]&)
		]
	];

	(* Create test *)
	validSamplingComboTest=If[gatherTests,
		Test["A SamplingDistance is provided if and only if the SamplingPattern is set to Matrix, Ring or Spiral, SamplingDimension is only set if using a Matrix sampling pattern, and if SamplingPattern is set to Matrix, only up to 8 discrete wavelength is specified:",validSamplingCombo,True]
	];

	(* Throw message only if we haven't already indicated that one of the wavelengths isn't possible *)
	If[!validSamplingCombo&&!gatherTests,
		Message[Error::AbsorbanceSamplingCombinationUnavailable]
	];

	(* If nothing was supplied, if we're not doing sampling or if we're using an instrument that doesn't do sampling automatically set to True *)
	instrumentSupportedSampling=Which[
		MatchQ[preresolvedInstrument, ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"](* Cary 3500 *)]],True,
		MatchQ[suppliedModelInstrumentPacket,<||>]||MatchQ[resolvedSamplingPattern,Null]||MatchQ[Lookup[suppliedModelInstrumentPacket,SamplingPatterns],Null],True,
		True,MemberQ[Lookup[Replace[Lookup[suppliedModelInstrumentPacket,SamplingPatterns],Null-><||>],experimentMode],resolvedSamplingPattern]
	];

	(* Create test *)
	validSamplingInstrumentTest=If[gatherTests,
		Test["If an instrument is provided and a sampling pattern is requested, the instrument can support that sampling pattern:",instrumentSupportedSampling,True]
	];

	(* Throw message only if we haven't already indicated that one of the wavelengths isn't possible *)
	If[!instrumentSupportedSampling&&!gatherTests,
		Message[Error::UnsupportedInstrumentSamplingPattern,experimentMode]
	];

	(* Check if sampling patterns are supported for the current type *)
	(* Plate reader models have a named single indicating what they can do *)
	(* Sort by plate readers which we have the most instances of so it's less likely user will run into instrument limitations *)
	noSampling=MatchQ[resolvedSamplingPattern,Null];
	plateReadersForSampling=If[noSampling,
		{},
		SortBy[
			Select[
				allPlateReaderModelPackets,
				MemberQ[Lookup[Replace[Lookup[#,SamplingPatterns],Null-><||>],experimentMode],resolvedSamplingPattern]&
			],
			-Length[Lookup[#,Objects]]&
		]
	];

	(* If we are working on a liquid handler and we weren't given a specific instrument model, default to *)
	(* CLARIOstar with ACU if we are using a (micro)bioSTAR workcell, or regular CLARIOstar if we are not. *)
	liquidHandlerRequiredDefault = Which[
		(* We're using one of the cell bio work cells, equipped with ACU clariostars. *)
		MatchQ[resolvedWorkCell, Alternatives[bioSTAR, microbioSTAR]],
			fetchPacketFromCache[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"],allPlateReaderModelPackets], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		(* Preparation is robotic but we aren't using a (micro)bioSTAR. *)
		Or[
			TrueQ[Lookup[myOptions, LiquidHandler]],
			MatchQ[resolvedPreparation, Robotic]
		],
			fetchPacketFromCache[Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"],allPlateReaderModelPackets], (* Model[Instrument, PlateReader, "CLARIOstar"] *)
		(* Otherwise, we don't need anything here. *)
		True,
			{}
	];

	(* Skip this check if sampling pattern is Null - this is checked with Error::SamplingPatternMismatch *)
	anyInstrumentSupportsSampling=If[MatchQ[resolvedSamplingPattern,Null],
		True,
		Length[plateReadersForSampling]>0
	];

	(* Create test *)
	validSamplingModeTest=If[gatherTests&&!noSampling,
		Test["The sampling pattern requested is supported for a "<>ToString[experimentMode]<> " protocol.",anyInstrumentSupportsSampling,True],
		{}
	];

	(* Throw message if there are no instruments that can do the requested sampling pattern *)
	If[!anyInstrumentSupportsSampling&&!gatherTests&&!noSampling,
		Message[Error::UnsupportedSamplingPattern,experimentMode,resolvedSamplingPattern]
	];

	(* If user specified instrument or if they can use lunatic this will already be reflected *)
	(* Only criteria left is to resolve instrument based on sampling pattern *)
	(* Do this early since it's assumed that we know our instrument up front *)
	{instrumentPacket,modelInstrumentPacket}=Which[
		MatchQ[preresolvedInstrument,ObjectP[]],
			{suppliedInstrumentPacket, suppliedModelInstrumentPacket},
		(* If we need a sampling plate reader and are on a liquid handler, pick the liquid handler default if it allows sampling. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[noSampling, False] && MemberQ[Lookup[plateReadersForSampling, Object], ObjectP[Lookup[liquidHandlerRequiredDefault, Object]]],
			{<||>,liquidHandlerRequiredDefault},
		(* If we are using plate reader manually, and will need to prep blank plate, we need to consider what work cell it will go to because the compiler will look at the picked instrument's integrated liquid handler and generate a Transfer primitive with WorkCell -> liquidHandlerContainingOurPlateReader. *)
		(* At this point we do not have blank-related options resolved, we approximate the need of blank prep by if Blank or BlankVolume is specified as Null. *)
		(* Note that this is a semi-temporary fix, lab and user feedback will be observed to decide if we want to keep it this way. Because technically we can prep the blank plate on one liquid handler, seal the plate, and read it on another liquid handler, we prefer not to go that way for now for efficiency. *)
		And[
			MatchQ[resolvedPreparation, Manual],
			MatchQ[resolvedMethods,PlateReader],
			MemberQ[
				Flatten[Lookup[absSpecOptionsAssoc, {Blanks, BlankVolumes}]],
				Except[Null]
			]
		],
			Module[{specifiedAliquot, validPlateModels, inputsForPotentialWorkCell, potentialBlankPrepWorkCells, allPlateReaderPackets, screenedPlateReaderPackets},
				(* Determine potential workcells, consider all samples in input samples containers if Aliquot is explicitly set to false, otherwise send samples to resolvePotentialWorkCells. *)
				specifiedAliquot = ToList[Lookup[absSpecOptionsAssoc, Aliquot]];
				(* get the valid container models that can be used with this experiment *)
				validPlateModels = BMGCompatiblePlates[Absorbance];
				inputsForPotentialWorkCell =  If[Or[
						(* all sample are already in valid plates and aliquot is not set explicitly set to True *)
						And[
							Sequence @@ (
								MemberQ[validPlateModels, #]& /@ Lookup[(sampleContainerModelPackets/. Null -> <||>), Object, Null]
							),
							!MemberQ[specifiedAliquot, True]
						],
						(* Or there is no Aliquot option explicitly set to False *)
						!AllTrue[specifiedAliquot, TrueQ]
					],
					(* Highly likely not aliquoting and blank will be packed into the plate, use the whole sample containers *)
					Cases[Lookup[(containerPackets /. Null -> <||>), Object], ObjectP[]],
					(* Otherwise use the samples *)
					Cases[Lookup[samplePackets, Object], ObjectP[]]
				];

				(* Estimate the potential workcells that the blank prep TransferUO will likely get *)
				potentialBlankPrepWorkCells = resolvePotentialWorkCells[
					(* Regardless of what the experiment will use, force the helper to consider it robotic so that it will not early return *)
					inputsForPotentialWorkCell,
					{Preparation -> Robotic, Sterile -> Null, SterileTechnique  -> Null},
					Cache -> cacheBall
				];
				allPlateReaderPackets = If[noSampling,
					Flatten[{liquidHandlerRequiredDefault, allPlateReaderModelPackets}],
					plateReadersForSampling
				];
				(* Refer to resolvePotentialWorkCells for potential outcomes. Consider all scenarios of its final Which call *)
				screenedPlateReaderPackets = Which[
					(* If STAR is not allowed, i.e. we have microbioSTAR or bioSTAR or both, prefer the integrated CLARIOstar Plus if it passed previous screenings *)
					(* Note that although there are occasions that only one of microbioSTAR and bioSTAR is allowed, we can resolve to any model not restricted to STAR, as the execute absorbanceConstrainInstrument will limit the instrument selection based on cell types *)
					!MemberQ[potentialBlankPrepWorkCells, STAR] && MemberQ[allPlateReaderPackets, ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]],(* "CLARIOstar Plus with ACU" *)
						{fetchPacketFromCache[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], allPlateReaderPackets]},
					(* Otherwise if STAR cannot be used, just filter out FLUOstar Omega and CLARIOstar *)
					(* Note that this is possible when this is called by experiment using a plate reader mode not supported by CLARIOstar Plus, e.g. *)
					!MemberQ[potentialBlankPrepWorkCells, STAR],
						Cases[
							allPlateReaderPackets,
							Except[ObjectP[{Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"], Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"]}]] (*"FLUOstar Omega", "CLARIOstar" *)
						],
					True,
					(* Otherwise if all workcells are allowed, we can use any model *)
						allPlateReaderPackets
				];
				(* return the instrument packet and model instrument packet. If nothing passed screening due to workcell or sampling pattern, make sure to output a packet so that calculations downstream does not crash. There are error checkings that capture why there no instrument support the given options. If not, we need to add the specific error checking. *)
				{<||>, FirstOrDefault[screenedPlateReaderPackets, First[allPlateReaderModelPackets]]}
			],
		True,
			{
				<||>,
				First[
					plateReadersForSampling, First[Flatten[{liquidHandlerRequiredDefault, allPlateReaderModelPackets}]]
				]
			}
	];

	instrument=If[MatchQ[preresolvedInstrument,ObjectP[]],
		preresolvedInstrument,
		Lookup[modelInstrumentPacket,Object]
	];

	(* Sampling is not Null if our instrument does sampling, otherwise must be Null *)
	(* Only throw this error if the user actually set any of the sampling options *)
	validSamplingInstrumentCombo=Or[
		MatchQ[resolvedSamplingPattern,Null]&&MatchQ[Lookup[modelInstrumentPacket,SamplingPatterns],Null|$Failed],
		MatchQ[resolvedSamplingPattern,Except[Null]]&&MatchQ[Lookup[modelInstrumentPacket,SamplingPatterns],_Association],
		!samplingRequested
	];

	validSamplingInstrumentComboTest=If[gatherTests,
		Test["Sampling is not Null if our instrument does sampling, otherwise it must be Null:",validSamplingInstrumentCombo,True]
	];

	If[!gatherTests&&!validSamplingInstrumentCombo,
		Message[Error::SamplingPatternMismatch]
	];

	invalidSamplingOptions=Which[
		!instrumentSupportedSampling,{SamplingPattern,SamplingDistance,SamplingDimension,Instrument},
		!validSamplingCombo,{SamplingPattern,SamplingDistance,SamplingDimension},
		!anyInstrumentSupportsSampling,{SamplingPattern},
		!validSamplingInstrumentCombo,{SamplingPattern,Instrument},
		True,Null
	];

	(* get the samples that are discarded *)
	discardedSamplePackets = Select[samplePackets, MatchQ[Lookup[#, Status], Discarded]&];

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
				Test["Provided input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				(* this Download[simulatedSamples, Object] call can become just simulatedSamples once we guarantee that the ID is always returned and not the Name anymore *)
				Test["Provided input samples " <> ObjectToString[Complement[Download[simulatedSamples, Object], discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Make sure the instrument is supported --- *)

	(* If the specified instrument is a model, make sure it is one that is supported in this experiment *)
	(* If the specified instrument is an object, then make sure its model is supported AND that it is not itself retired *)
	supportedInstrumentBool = If[MatchQ[instrument, ObjectP[{Model[Instrument, PlateReader],Model[Instrument,Spectrophotometer]}]],
		True,
		Not[MatchQ[Lookup[instrumentPacket, Status], Retired]]
	];

	(* figure out if we are using Cary 3500 or not *)

	cuvetteQ=If[MatchQ[instrument,ObjectP[Model[Instrument,Spectrophotometer]]],
		MatchQ[instrument,ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"](* Cary 3500 *)]],
		MatchQ[Lookup[instrumentPacket,Model],ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"](* Cary 3500 *)]]
	];


	(* Check to see if the reader supports the mode (e.g. reader can do AbsorbanceKinetics); since spectrophotometers don't have plate reader mode as a field, using cuvette checks for supported instruments *)
	supportedModeBool = supportedInstrumentBool && (cuvetteQ||MemberQ[Lookup[modelInstrumentPacket,PlateReaderMode],experimentMode]);

	(* If the instrument is not supported and we are throwing messages, throw an error message and keep track of the invalid options *)
	validInstrumentOption = If[Not[supportedModeBool] && messages,
		(
			Message[Error::UnsupportedPlateReader, instrument, experimentMode];
			{Instrument}
		),
		{}
	];

	(* Generate tests for whether the instrument is supported (if we are gathering tests) *)
	(* Need to do this check for an UnsupportedPlateReader _before_ checking compatibility between the provided containers and the plate reader (because otherwise we'll throw an error that something is incompatible with a plate reader that we also don't support, which is silly) *)
	supportedInstrumentTests = If[gatherTests,
		{Test["The provided instrument " <> ObjectToString[instrument, Cache -> cacheBall] <> " is currently supported for "<>ToString[experimentMode]<>":",
			supportedModeBool,
			True
		]},
		Null
	];

	(* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[instrument, simulatedSamples, Output -> {Result, Tests}, Cache -> inheritedCache, Simulation->updatedSimulation],
		{CompatibleMaterialsQ[instrument, simulatedSamples, Messages -> messages, Cache -> inheritedCache,Simulation->updatedSimulation], {}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messages,
		{Instrument},
		{}
	];

	(* 2. SOLID SAMPLES ARE NOT OK *)

	(* Get the samples that are not liquids,cannot filter those *)
	nonLiquidSamplePackets=If[Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
		#,
		Nothing
	] & /@ samplePackets;

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[MatchQ[nonLiquidSamplePackets,{}],{},Lookup[nonLiquidSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::NonLiquidSample,ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]<>" have a Liquid State:",True,False]
			];

			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[samplePackets],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[Lookup[samplePackets,Object],nonLiquidSampleInvalidInputs],Cache->cacheBall]<>" have a Liquid State:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* --- Option precision checks --- *)

	(* Gather precisions for all our options across the board *)
	optionPrecisions={
		{Temperature,10^-1 Celsius},
		{EquilibrationTime,1 Second},
		{TargetOxygenLevel,10^-1 Percent},
		{TargetCarbonDioxideLevel,10^-1 Percent},
		{AtmosphereEquilibrationTime,1 Second},
		{FocalHeight,10^-1 Millimeter},
		{PrimaryInjectionVolume,1 Microliter},
		{SecondaryInjectionVolume,1 Microliter},
		{TertiaryInjectionVolume,1 Microliter},
		{QuaternaryInjectionVolume,1 Microliter},
		{MoatVolume,1 Microliter},
		{PlateReaderMixTime,1 Second},
		{wavelengthOptionName, 1 Nanometer},
		{BlankVolumes, 10^-1 Microliter},
		{PlateReaderMixRate, 100 RPM},
		{SamplingDistance, 1 Millimeter},
		{SpectralBandwidth, 10^-1 Nanometer},
		{Wavelength, 1 Nanometer},
		{AcquisitionMixRate, 50 RPM},
		{MinAcquisitionMixRate, 50 RPM},
		{MaxAcquisitionMixRate, 50 RPM},
		{AcquisitionMixRateIncrements, 50 RPM}
	};

	(* Send RoundOptionPrecision only the options that apply to our current function *)
	filteredOptionPrecisions=Select[optionPrecisions,MemberQ[Keys[absSpecOptionsAssoc],First[#]]&];

	(* ensure that the quantity options have the proper precision *)
	{roundedOptionsAssoc, precisionTests} = If[gatherTests,
		RoundOptionPrecision[absSpecOptionsAssoc,filteredOptionPrecisions[[All,1]],filteredOptionPrecisions[[All,2]],Output->{Result,Tests}],
		{RoundOptionPrecision[absSpecOptionsAssoc,filteredOptionPrecisions[[All,1]],filteredOptionPrecisions[[All,2]],Output->Result],{}}
	];

	(* --- Conflicting options checks that don't need resolution --- *)

	(* --- Check to see if the Name option is properly specified --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Append[myType, Lookup[roundedOptionsAssoc, Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, ToString[Last[myType]] <> " protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name, _String],
		Test["If specified, Name is not already an "<>ToString[experimentMode]<>" object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Check to make sure there are no input samples in the Blanks field *)

	(* make sure there are no blanks that are also samples *)
	(* note that in this case I am deliberately NOT using simulated samples since this depends on what the user specifies for the blanks vis a vis the samples they specify *)
	separateSamplesAndBlanksQ = If[MatchQ[Lookup[roundedOptionsAssoc, Blanks], ListableP[Null | Automatic] | {}],
		True,
		ContainsNone[Lookup[blankSamplePackets,Object,{}], Lookup[samplePackets, Object]]
	];

	(* generate tests for cases where some of the specified samples are also the specified blanks *)
	blanksInvalidTest = If[gatherTests,
		{Test["None of the provided samples are also provided as Blanks:",
			separateSamplesAndBlanksQ,
			True
		]},
		Null
	];

	(* throw an error if SamplesIn are also appearing in Blanks *)
	(* note that we are returning $Failed below because we need _something_ for the resolved options *)
	blanksInvalidOptions = If[Not[separateSamplesAndBlanksQ] && messages,
		(
			Message[Error::BlanksContainSamplesIn, ObjectToString[Select[Lookup[samplePackets, Object], MemberQ[Lookup[blankSamplePackets, Object], #]&],Cache->cacheBall]];
			{Blanks}
		),
		{}
	];

	(* - Validate Temperature/EquilibrationTime options - *)

	(* figure out if we are using the Lunatic or not *)
	lunaticQ=If[MatchQ[instrument,ObjectP[Model[Instrument,PlateReader]]],
		MatchQ[instrument,ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)]],
		MatchQ[Lookup[instrumentPacket,Model],ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)]]
	];

	(* get whether the Temperature and EquilibrationTime options are fine *)
	(* if using the Lunatic, both must be Null; if not, both must NOT be Null *)
	tempAndTempTimeValidQ=If[lunaticQ,
		MatchQ[specifiedTemp,Ambient|Automatic]&&MatchQ[specifiedEquilibrationTime,Null|Automatic],
		Not[NullQ[specifiedTemp]]&&Not[NullQ[specifiedEquilibrationTime]]
	];

	(* get the text for the test we are generating depending on if we're using the Lunatic or a BMG plate reader *)
	tempAndTempTimeTestString=If[lunaticQ,
		"If the specified Instrument is an Unchained Labs Lunatic, EquilibrationTime and Temperature are not specified:",
		"If the specified Instrument is a BMG plate reader or Cary 3500, EquilibrationTime and Temperature are not Null:"
	];

	(* generate tests  *)
	temperatureIncompatibleTest=If[gatherTests,
		{Test[tempAndTempTimeTestString,
			tempAndTempTimeValidQ,
			True
		]},
		Null
	];

	(* throw an error if EquilibrationTime/Temperature are not compatible with their respective instruments *)
	temperatureIncompatibleInvalidOptions=If[Not[tempAndTempTimeValidQ]&&messages,
		(
			Message[Error::TemperatureIncompatibleWithPlateReader,instrument];
			{Instrument,EquilibrationTime,Temperature}
		),
		{}
	];


	(* - SpectralBandwidth can only be set if using Cuvettes/Cary 3500 - *)


	(* if using cuvette/cary 3500, SpectralBandwidth must NOT be Null; if not, SpectralBandwidth must be Null *)
	spectralBandwidthValidQ=If[cuvetteQ,
		Not[NullQ[specifiedSpectralBandwidth]],
		MatchQ[specifiedSpectralBandwidth, Automatic | Null]
	];

	(* get the text for the test we are generating depending on the instrument *)
	spectralBandwidthTestString=If[cuvetteQ,
		"If the specified Instrument is the Cary 3500, SpectralBandwidth is specified:",
		"If the specified Instrument is a BMG plate reader or Unchained Labs Lunatic, SpectralBandwidth is Null:"
	];

	(* generate tests for SpectralBandwidth *)
	spectralBandwidthIncompatibleTest=If[gatherTests,
		{Test[spectralBandwidthTestString,
			spectralBandwidthValidQ,
			True
		]},
		Null
	];

	(* throw an error if SpectralBandwidth is not compatible with respective instrument *)

	spectralBandwidthIncompatibleInvalidOptions=If[Not[spectralBandwidthValidQ]&&messages,
		(
			Message[Error::SpectralBandwidthIncompatibleWithPlateReader,instrument];
			{Methods,SpectralBandwidth}
		),
		{}
	];


	(* - AcquisitionMix can only be set if using Cuvettes/Cary 3500 - *)
	(* if not using cuvette/cary 3500, AcquisitionMix must be Null or Automatic*)
	acquisitionMixValidQ=If[cuvetteQ,
		True,
		ContainsOnly[Flatten[{specifiedAcquisitionMix}], {Automatic, Null}]
	];

	(* get the text for the test we are generating depending on the instrument *)
	acquisitionMixTestString=If[cuvetteQ,
		"If the specified Instrument is the Cary 3500, AcquisitionMix is specified:",
		"If the specified Instrument is a BMG plate reader or Unchained Labs Lunatic, AcquisitionMix is Null:"
	];

	(* generate tests for AcquisitionMix *)
	acquisitionMixIncompatibleTest=If[gatherTests,
		{Test[acquisitionMixTestString,
			acquisitionMixValidQ,
			True
		]},
		Null
	];

	(* throw an error if AcquisitionMix is not compatible with respective instrument *)

	acquisitionMixIncompatibleInvalidOptions=If[Not[acquisitionMixValidQ]&&messages,
		(
			Message[Error::AcquisitionMixIncompatibleWithPlateReader,instrument];
			{Methods,AcquisitionMix}
		),
		{}
	];


	(* - StirBar, AcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, and MaxStirAttempts can only be set if AcquisitionMix is True - *)

	(* figure out if AcquisitionMix is True*)
	acquisitionMixQ=ContainsAny[Flatten[{specifiedAcquisitionMix}],{True}];

	(* if AcquisitionMix is True, StirBar, AcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, and MaxStirAttempts CANNOT be Null; if AcquisitionMix is False, options must be null *)
	acquisitionMixDependentOptionsValidQ=If[acquisitionMixQ,
		!MemberQ[{specifiedStirBar,specifiedAcquisitionMixRate,specifiedMinAcquisitionMixRate,specifiedMaxAcquisitionMixRate,specifiedAcquisitionMixRateIncrements,specifiedAdjustMixRate,
	specifiedMaxStirAttempts},NullP],
		ContainsOnly[Flatten[{specifiedStirBar,specifiedAcquisitionMixRate,specifiedMinAcquisitionMixRate,specifiedMaxAcquisitionMixRate,specifiedAcquisitionMixRateIncrements,specifiedAdjustMixRate,specifiedMaxStirAttempts}],{Automatic,False,Null}]
	];

	(* get the text for the test we are generating depending on the instrument *)
	acquisitionMixDependentOptionsTestString=If[acquisitionMixQ,
		"If the AcquisitionMix is set to True, StirBar, AcquisitionMixRate, MinAcquisitionMixRate, MaxAcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, and MaxStirAttempts CANNOT be Null:",
		"If the AcquisitionMix is set to False, StirBar, AcquisitionMixRate, MinAcquisitionMixRate, MaxAcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, and MaxStirAttempts must be Null:"
	];

	(* generate tests for AcquisitionMix compatible options *)
	acquisitionMixDependentOptionsIncompatibleTest=If[gatherTests,
		{Test[acquisitionMixDependentOptionsTestString,
			acquisitionMixDependentOptionsValidQ,
			True
		]},
		Null
	];
	acquisitionMixDependentOptionsInvalidOptions=If[Not[acquisitionMixDependentOptionsValidQ]&&messages,
		(
			Message[Error::AcquisitionMixRequiredOptions,instrument];
			{Methods, AcquisitionMix, StirBar, AcquisitionMixRate, MinAcquisitionMixRate, MaxAcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, MaxStirAttempts}
		),
		{}
	];


	(* - check if the supplied instrument is of a compatible type with method - *)
	methodsInstrumentValidQ=If[
		!MatchQ[specifiedMethods,Automatic]&&!MatchQ[specifiedInstrument,Automatic],
		Which[
			MatchQ[specifiedMethods,Cuvette],cuvetteQ,
			MatchQ[specifiedMethods,Microfluidic],lunaticQ,
			MatchQ[specifiedMethods,PlateReader],!lunaticQ&&MatchQ[specifiedInstrument,ObjectP[{Model[Instrument, PlateReader], Object[Instrument, PlateReader]}]]
		],
		True
	];

	(* get the text for the test we are generating depending on the instrument *)
	methodsInstrumentTestString=If[methodsInstrumentValidQ,
		{},
		"If Methods and Instrument is specified, the instrument should be compatible with the method (Cuvette->Cary 3500, Microfluidic->Lunatic,PlateReader->Model[Instrument,PlateReader]):"
	];

	(* generate tests for AcquisitionMix *)
	methodsInstrumentIncompatibleTest=If[gatherTests,
		{Test[methodsInstrumentTestString,
			methodsInstrumentValidQ,
			True
		]},
		Null
	];

	(* throw an error if AcquisitionMix is not compatible with respective instrument *)

	methodsInstrumentIncompatibleOptions=If[Not[methodsInstrumentValidQ]&&messages,
		(
			Message[Error::MethodsInstrumentMismatch,instrument,resolvedMethods];
			{Instrument,Methods}
		),
		{}
	];


	(* - MinAcquisitionMixRate can't be larger than MaxAcquisitionMixRate - *)
	acquisitionMixRateRangeMismatch=If[!MatchQ[specifiedMinAcquisitionMixRate,Automatic]&&!MatchQ[specifiedMaxAcquisitionMixRate,Automatic]&&MatchQ[specifiedMinAcquisitionMixRate, GreaterP[specifiedMaxAcquisitionMixRate]],
		{specifiedMinAcquisitionMixRate,specifiedMaxAcquisitionMixRate},
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingAcquisitionMixRateOptions=If[Length[acquisitionMixRateRangeMismatch]>0&&messages,
		Message[Error::InvalidAcquisitionMixRateRange,
			acquisitionMixRateRangeMismatch[[1]],
			acquisitionMixRateRangeMismatch[[2]]
		];
		{MinAcquisitionMixRate,MaxAcquisitionMixRate},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingAcquisitionMixRateTests=If[gatherTests,

		(* Get the inputs that pass this test. *)
		If[MatchQ[acquisitionMixRateRangeMismatch,{}],

			{Test["The specified value for MinAcquisitionMixRate is smaller than MaxAcquisitionMixRate:",True,True]},
			{Test["The specified value for MinAcquisitionMixRate is smaller than MaxAcquisitionMixRate:",True,False]}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* - if using Cuvettes, PlateReaderMixRate, PlateReaderMixTime, PlateReaderMix, PlateReaderMixMode, PlateReaderMixSchedule must be Null or False  - *)


	(* test if PlateReaderMix options are set when using Cuvettes *)
	mismatchCuvettePlateReaderValidQ=If[cuvetteQ,
		ContainsOnly[{specifiedPlateReaderMixRate,specifiedPlateReaderMixTime,specifiedPlateReaderMix,specifiedPlateReaderMixMode,specifiedPlateReaderMixSchedule},{Null,False,Automatic}],
		True
	];

	(* get the text for the test we are generating depending on the instrument *)
	mismatchCuvettePlateReaderTestString=If[mismatchCuvettePlateReaderValidQ,
		{},
		"If using Cuvettes, PlateReaderMixRate, PlateReaderMixTime, PlateReaderMix, PlateReaderMixMode, and PlateReaderMixSchedule must be Null:"
	];

	(* generate tests for Cuvette and PlateReaderMix options *)
	mismatchCuvettePlateReaderTest=If[gatherTests,
		{Test[mismatchCuvettePlateReaderTestString,
			mismatchCuvettePlateReaderValidQ,
			True
		]},
		Null
	];
	mismatchCuvettePlateReaderOptions=If[Not[mismatchCuvettePlateReaderValidQ]&&messages,
		(
			Message[Error::InvalidCuvettePlateReaderOptions,instrument];
			{Methods, PlateReaderMixRate, PlateReaderMixTime, PlateReaderMix, PlateReaderMixMode, PlateReaderMixSchedule}
		),
		{}
	];


	(* - if using Cuvettes, MoatSize, MoatVolume, and MoatBuffer must be Null - *)


	(* test if Moat options are set when using Cuvettes *)
	mismatchCuvetteMoatValidQ=If[cuvetteQ,
		ContainsOnly[{specifiedMoatSize,specifiedMoatVolume,specifiedMoatBuffer},{Null,False,Automatic}],
		True
	];

	(* get the text for the test we are generating depending on the instrument *)
	mismatchCuvetteMoatTestString=If[mismatchCuvetteMoatValidQ,
		{},
		"If using Cuvettes, MoatSize, MoatVolume, and MoatBuffer must be Null:"
	];

	(* generate tests for moat options and cuvettes *)
	mismatchCuvetteMoatTest=If[gatherTests,
		{Test[mismatchCuvetteMoatTestString,
			mismatchCuvetteMoatValidQ,
			True
		]},
		Null
	];
	mismatchCuvetteMoatOptions=If[Not[mismatchCuvetteMoatValidQ]&&messages,
		(
			Message[Error::InvalidCuvetteMoatOptions,instrument];
			{MoatSize,MoatVolume,MoatBuffer}
		),
		{}
	];

	(* - if using Cuvettes, ReadDirection, SamplingPattern,  SamplingDistance, and SamplingDimension must be Null - *)


	(* test if Moat options are set when using Cuvettes *)
	mismatchCuvettePlateSamplingValidQ=If[cuvetteQ,
		ContainsOnly[{specifiedReadDirection,suppliedSamplingPattern,suppliedSamplingDistance,suppliedSamplingDimension},{Null,False,Automatic}],
		True
	];

	(* get the text for the test we are generating depending on the instrument *)
	mismatchCuvettePlateSamplingTestString=If[mismatchCuvettePlateSamplingValidQ,
		{},
		"If using ReadDirection, SamplingPattern, SamplingDistance, and SamplingDimension must be Null:"
	];

	(* generate tests for SpectralBandwidth *)
	mismatchCuvettePlateSamplingTest=If[gatherTests,
		{Test[mismatchCuvettePlateSamplingTestString,
			mismatchCuvettePlateSamplingValidQ,
			True
		]},
		Null
	];
	mismatchCuvettePlateSamplingOptions=If[Not[mismatchCuvettePlateSamplingValidQ]&&messages,
		(
			Message[Error::InvalidCuvetteSamplingOptions,instrument];
			{ReadDirection,SamplingPattern,SamplingDistance,SamplingDimension}
		),
		{}
	];


	(* - Cuvette Compatibility Error - *)

	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	unresolvedAliquotContainers=Lookup[samplePrepOptions,AliquotContainer];

	(* get the model container of the user specified aliquot container *)
	unresolvedAliquotContainerModels=Map[
		If[MatchQ[#,Automatic],
			Null,
			If[MatchQ[#, ObjectP[Model]],
				#,
				fastAssocLookup[fastCacheBall,#,{Model}]
			]
		]&,
		unresolvedAliquotContainers
	];

	(* check whether the AliquotContainers, if specified, are compatible with the instrument. Currently these are hardcoded in 'absorbanceAllowedCuvettesP' *)
	aliquotContainerConflicts=If[cuvetteQ,
		MapThread[
			Function[{unresolvedAliquotContainer,acModel,sampleObject},
				Switch[unresolvedAliquotContainer,
					(* we're fine if the AliquotContainer is Automatic *)
					Automatic,
					Nothing,
					(* the user may have given us objects, or models *)
					ObjectP[{Object[Container],Model[Container]}],
					If[
						(* we're fine if the AliquotContainer is one of the allowed container models - make sure to Download the Object from it if we were given a Name *)
						MatchQ[Download[acModel,Object],absorbanceAllowedCuvettesP],
						Nothing,
						{sampleObject,unresolvedAliquotContainer}
					],
					_,
					Nothing
				]
			],
			{unresolvedAliquotContainers,unresolvedAliquotContainerModels,simulatedSamples}
		],
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	badAliquotContainerOptions=If[Length[aliquotContainerConflicts]>0&&messages,
		Message[Error::AbsorbanceSpectroscopyIncompatibleCuvette,
			ObjectToString[aliquotContainerConflicts[[All,1]],Cache->cacheBall],
			ObjectToString[absorbanceAllowedCuvettesP]
		];
		{AliquotContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badAliquotContainerTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[aliquotContainerConflicts,{}],{},aliquotContainerConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>", the AliquotContainer, if specified, is a cuvette supported by this experiment:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Cache->cacheBall]<>",the AliquotContainer, if specified, is a cuvette supported by this experiment:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
];


	(* - Total Volume Compatibility Error - *)

	(* check whether the resolved total volume falls into the range of available cuvettes *)
	totalVolumeConflicts=If[cuvetteQ,
		MapThread[
			Function[{sampleObject,sampleVolume,specifiedAliquotOption,specifiedAssayVolume,specifiedAliquotContainer},Module[{allowedCuvettePackets,minCuvetteSampleVolume},
				(* we resolve Aliquot options later, but if the user has given us the cuvette they want to use for this sample, error-check against it *)
				allowedCuvettePackets=If[MatchQ[specifiedAliquotContainer,ObjectP[Model[Container,Cuvette]]],
					Cases[cuvettePackets,ObjectP[specifiedAliquotContainer]],
					cuvettePackets
				];
				minCuvetteSampleVolume=Min[Lookup[allowedCuvettePackets,MinVolume,0 Microliter]];
				Which[
					(* make sure that we have enough volume for at least one of our cuvettes, otherwise none of this matters *)
					sampleVolume<minCuvetteSampleVolume,
					{sampleObject,sampleVolume},

					(* there is AssayVolume specified by the user - check if we have a cuvette that can fit it *)
					MatchQ[specifiedAssayVolume,VolumeP],
					If[
						!MatchQ[specifiedAssayVolume,Alternatives@@Map[RangeP[Lookup[#,MinVolume],Lookup[#,MaxVolume]] &,allowedCuvettePackets]],
						{sampleObject,specifiedAssayVolume},
						Nothing
					],

					(* user allowed us to do aliquot - we can use anything *)
					MatchQ[specifiedAliquotOption,Automatic], Nothing,

					(* make sure that we have enough sample to fit at least in some cuvette *)
					MatchQ[sampleVolume,VolumeP],
					If[
						!MatchQ[sampleVolume,Alternatives @@ Map[RangeP[Lookup[#,MinVolume],Lookup[#,MaxVolume]] &,allowedCuvettePackets]],
						{sampleObject,specifiedAssayVolume},
						Nothing
					],

					(* we are not allowed to auto-aliquot, we don't have the assay volume specified, try to see if we have a cuvette that will fit the sample as is *)
					(* we should not be here at all, but just in case - count this as an error so we can look at it later on *)
					True, {sampleObject,0Microliter}
				]
			]],
			{
				Lookup[samplePackets,Object],
				Lookup[samplePackets,Volume],
				Lookup[myOptions,Aliquot],
				Lookup[myOptions,AssayVolume],
				Lookup[myOptions,AliquotContainer]
			}
		],
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	(* we don't want to throw this error if we already have thrown the discarded / non-volume / non-liquid input test *)
	badTotalVolumeOptions=If[cuvetteQ&&Length[totalVolumeConflicts]>0 && messages && !(Length[discardedInvalidInputs]>0) && !(Length[nonLiquidSampleInvalidInputs]>0),
		Message[Error::AbsorbanceSpectroscopyCuvetteVolumeOutOfRange,
			ObjectToString[totalVolumeConflicts[[All,1]]],
			UnitConvert[totalVolumeConflicts[[All,2]],Milliliter]
		];
		{AliquotContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badTotalVolumeTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[totalVolumeConflicts,{}],{},totalVolumeConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>", the total volume falls into the working range of the compatible cuvettes:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Cache->cacheBall]<>", the total volume falls into the working range of the compatible cuvettes:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* - Validate PlateReaderMix options - *)
	(* Do checks for BMG plate reader mixing *)
	{plateReaderMixOptionInvalidities,plateReaderMixTests}=If[gatherTests,
		validPlateReaderMixing[experimentFunction,absSpecOptionsAssoc,Output->{Options,Tests}],
		{validPlateReaderMixing[experimentFunction,absSpecOptionsAssoc,Output->Options],{}}
	];

	lunaticMixingError=And[
		lunaticQ,
		Or[
			TrueQ[specifiedPlateReaderMix],
			MatchQ[{specifiedPlateReaderMixRate,specifiedPlateReaderMixTime,specifiedPlateReaderMixMode,specifiedPlateReaderMixSchedule},{Except[Automatic|Null]..}]
		]
	];

	(* Throw message *)
	If[lunaticMixingError&&messages,Message[Error::PlateReaderMixingUnsupported,instrument]];

	(* Create test *)
	lunaticMixTest=If[gatherTests,
		Test["The specified plate reader can perform any requested mixing",lunaticMixingError,False]
	];

	invalidLunaticMixOptions=If[lunaticMixingError,
		PickList[
			{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixMode,PlateReaderMixSchedule},
			{specifiedPlateReaderMix,specifiedPlateReaderMixRate,specifiedPlateReaderMixTime,specifiedPlateReaderMixMode,specifiedPlateReaderMixSchedule},
			Except[Null|Automatic|False]
		]
	];

	(* - Validate ReadDirection - *)
	(* Lunatic can't set read direction *)
	readDirectionError=lunaticQ&&!MatchQ[specifiedReadDirection,Automatic|Null];

	(* Throw a message if ReadDirection is invalid *)
	If[readDirectionError&&messages,Message[Error::PlateReaderReadDirectionUnsupported,instrument]];

	(* Track invalid options *)
	readDirectionInvalidOptions=If[readDirectionError,
		{Instrument,ReadDirection},
		{}
	];

	readDirectionTest=Test["If ReadDirection is set the specified instrument is capable of controlling it:",readDirectionError,False];

	(* - Validate Injections x Instrument - *)

	(* Lunatic/Cary can't perform injections *)
	injectionInstrumentError=(lunaticQ||cuvetteQ)&&!MatchQ[injectionOptions,{ListableP[Null|Automatic]..}];

	(* Throw a message if Injections are invalid is invalid *)
	If[injectionInstrumentError&&messages,Message[Error::PlateReaderInjectionsUnsupported,instrument]];

	(* Track invalid options *)
	injectionInstrumentInvalidOptions=If[injectionInstrumentError,
		Append[
			PickList[injectionOptionNames,injectionOptions,Except[ListableP[Null|Automatic]]],
			Instrument
		],
		{}
	];

	(* Create test *)
	injectionInstrumentTest=Test["If injections are specified, the specified instrument is capable of injection samples.",injectionInstrumentError,False];

	(* - Validate Injections x RetainCover - *)
	(* If there are any injections, RetainCover must be set to False - otherwise it can be set to anything *)
	anyInjectionsQ=MemberQ[Flatten[Lookup[absSpecOptionsAssoc,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}]],VolumeP];

	specifiedRetainCover=Lookup[absSpecOptionsAssoc,RetainCover];

	resolvedRetainCover=If[
		cuvetteQ&&MatchQ[specifiedRetainCover,False],
		True,
		specifiedRetainCover
	];

	validRetainCover=(anyInjectionsQ&&MatchQ[resolvedRetainCover,False])||(!anyInjectionsQ);

	(* Create test *)
	retainCoverTest=If[gatherTests,
		Test["If RetainCover is set to True, injections cannot be specified:",validRetainCover,True]
	];

	(* Throw message *)
	If[!validRetainCover&&messages,
		Message[Error::CoveredInjections]
	];

	(* - Validate Instrument x RetainCover - *)
	invalidCoverInstrument=MatchQ[resolvedRetainCover,True]&&lunaticQ;

	If[invalidCoverInstrument&&messages,
		Message[Error::CoverUnsupported,ObjectToString[instrument]]
	];

	invalidCoverInstrumentTest=If[gatherTests,
		Test["If using "<>ObjectToString[instrument]<>" RetainCover is not set to True:",invalidCoverInstrument,False]
	];

	(* Track invalid option *)
	invalidCoverOption=If[!validRetainCover||invalidCoverInstrument,RetainCover];


	(* - Validate ReadOrder x Wavelengths -  *)

	(* Lookup relevant options *)
	specifiedReadOrder=Lookup[absSpecOptionsAssoc,ReadOrder];

	(* BMG won't allow a span or multiple wavelength if ReadOrder -> Serial *)
	orderError=MatchQ[specifiedWavelength,_Span|All]&&MatchQ[specifiedReadOrder,Serial];

	(* Throw message *)
	If[messages&&orderError,
		Message[Error::MultipleWavelengthsUnsupported]
	];

	(* Track invalid option *)
	invalidOrderOption=If[orderError,{ReadOrder,Wavelength}];

	(* Create test *)
	orderTest=If[gatherTests&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Test["The Wavelength and ReadOrder specifications are compatible:",orderError,False]
	];

	(* - Validate the number of discrete wavelengths specified: only for ExperimentAbsorbanceKinetics - *)

	(* The relevant option has been obtained in previous error check: specifiedWavelength *)
	(* If the specifiedWavelength is a list, we assume that the input is a list of discrete values. The length of the list cannot exceed the instrument limit which is eight. *)
	exceedWavelengthError=MatchQ[specifiedWavelength,_?ListQ]&&Greater[Length[specifiedWavelength],8]&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]];

	(* Throw message *)
	If[messages&&exceedWavelengthError,
		Message[Error::TooManyWavelength,wavelengthOptionName,Length[specifiedWavelength]]
	];

	(* Track invalid option *)
	invalidWavelengthOption=If[exceedWavelengthError,wavelengthOptionName];

	(* Create test *)
	wavelengthTest=If[gatherTests&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Test["The number of specified discrete wavelengths does not exceed the instrument limit:",exceedWavelengthError,False]
	];

	(* - Verify the Wavelength option if it is a span - *)
	spanWavelengthWarning=MatchQ[specifiedWavelength,_Span]&&Greater[First[specifiedWavelength],Last[specifiedWavelength]];

	(* Throw message *)
	If[spanWavelengthWarning&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::SpanWavelengthOrder,specifiedWavelength]
	];

	(* Create test *)
	spanWavelengthWarningTest=If[gatherTests,
		Warning["If Wavelength is a span, it is specified as low-wavelength;;high-wavelength:",spanWavelengthWarning,False]
	];

	(* --- Non-IndexMatching option resolution --- *)

	(* Resolve TargetCarbonDioxideLevel *)
	{{resolvedACUOptions, resolvedACUInvalidOptions}, resolvedACUTests} = If[gatherTests,
		resolveACUOptions[
			myType,
			simulatedSamples,
			Association[roundedOptionsAssoc,
				{
					Instrument -> instrument,
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> {Result, Tests}
				}
			]
		],
		{
			resolveACUOptions[
				myType,
				simulatedSamples,
				Association[roundedOptionsAssoc,
					{
						Instrument -> instrument,
						Cache -> cacheBall,
						Simulation -> updatedSimulation,
						Output -> Result
					}
				]
			],
			{}
		}
	];

	(* get the rounded temperature value *)
	roundedTemperature=Lookup[roundedOptionsAssoc,Temperature];

	(* get the resolved temperature *)
	temperature=Which[
		lunaticQ&&MatchQ[roundedTemperature,Automatic],Ambient,
		Not[lunaticQ]&&MatchQ[roundedTemperature,Automatic],Ambient,
		True,roundedTemperature
	];

	(* get the specified temperature equilibrium time value *)
	specifiedEquilibrationTimePostRounding=Lookup[roundedOptionsAssoc,EquilibrationTime];

	(* get the resolved temperature equilibrium time  *)
	temperatureEquilibriumTime=Which[
		lunaticQ&&MatchQ[specifiedEquilibrationTimePostRounding,Automatic],Null,
		Not[lunaticQ]&&MatchQ[specifiedEquilibrationTimePostRounding,Automatic]&&MatchQ[temperature,GreaterEqualP[$AmbientTemperature]],5*Minute,
		Not[lunaticQ]&&MatchQ[specifiedEquilibrationTimePostRounding,Automatic],0*Minute,
		True,specifiedEquilibrationTimePostRounding
	];

	resolvedTemperatureMonitor = Which[
		MatchQ[specifiedTemperatureMonitor,Except[Automatic]], specifiedTemperatureMonitor,
		MatchQ[resolvedMethods,Cuvette], CuvetteBlock,
		True, Null
	];

	(* -- Resolve SpectralBandwidth -- *)

	defaultSpectralBandwidth= 1.0 Nanometer;

	roundedSpectralBandwidth=Lookup[roundedOptionsAssoc,SpectralBandwidth];

	resolvedSpectralbandwidth=If[cuvetteQ,
		Replace[roundedSpectralBandwidth,Automatic->defaultSpectralBandwidth],
		Replace[roundedSpectralBandwidth,Automatic->Null]
	];

	(* -- Resolve Cuvette Mixing options (AcquisitionMix) -- *)
	preresolvedAcquisitionMix=Which[
		ContainsAny[Flatten[{specifiedAcquisitionMix}],{True}],True,
		MemberQ[
			Flatten[{
			specifiedAcquisitionMixRate, specifiedAcquisitionMixRateIncrements, specifiedMinAcquisitionMixRate,
			specifiedMaxAcquisitionMixRate, specifiedMaxStirAttempts, specifiedStirBar, specifiedAdjustMixRate
		}],
			Except[Automatic|Null]],True,
		True,False
	];

	(* - Resolve Cuvette Mixing (AcquisitionMix) Parameters - *)

	(* Mixing defaults for automatic resolution *)
	defaultAcquisitionMixRate=400 RPM;
	defaultMinAcquisitionMixRate=400 RPM;
	defaultMaxAcquisitionMixRate=1400 RPM;
	defaultAcquisitionMixRateIncrements=50 RPM;
	defaultMaxStirAttempts=10;

	(* get the rounded AcquisitionMixRate value *)
	roundedAcquisitionMixRate=Lookup[roundedOptionsAssoc,AcquisitionMixRate];
	roundedMinAcquisitionMixRate=Lookup[roundedOptionsAssoc,MinAcquisitionMixRate];
	roundedMaxAcquisitionMixRate=Lookup[roundedOptionsAssoc,MaxAcquisitionMixRate];
	roundedAcquisitionMixRateIncrements=Lookup[roundedOptionsAssoc,AcquisitionMixRateIncrements];

	(* If we're mixing replace Automatics with defaults, otherwise replace with Null *)
	{
		resolvedAcquisitionMixRate, resolvedMinAcquisitionMixRate,
		resolvedMaxAcquisitionMixRate, resolvedAcquisitionMixRateIncrements, resolvedMaxStirAttempts, resolvedAdjustMixRate
	}=If[preresolvedAcquisitionMix,
		{
			Replace[roundedAcquisitionMixRate,
				Which[
					MatchQ[roundedMinAcquisitionMixRate,!Automatic],Automatic->roundedMinAcquisitionMixRate*1.25,
					MatchQ[roundedMaxAcquisitionMixRate,!Automatic],Automatic->roundedMaxAcquisitionMixRate*0.83,
					True,Automatic->defaultAcquisitionMixRate]
			],
			Replace[roundedMinAcquisitionMixRate,
				Which[
					MatchQ[roundedAcquisitionMixRate,!Automatic],Automatic->roundedAcquisitionMixRate*0.8,
					MatchQ[roundedMaxAcquisitionMixRate,!Automatic],Automatic->roundedMaxAcquisitionMixRate*0.83*0.8,
					True,Automatic->defaultMinAcquisitionMixRate]
			],
			Replace[roundedMaxAcquisitionMixRate,
				Which[
					MatchQ[roundedAcquisitionMixRate,!Automatic],Automatic->roundedAcquisitionMixRate*1.2,
					MatchQ[roundedMinAcquisitionMixRate,!Automatic],Automatic->roundedMaxAcquisitionMixRate*1.25*1.2,
					True,Automatic->defaultMaxAcquisitionMixRate]
			],
			Replace[roundedAcquisitionMixRateIncrements,Automatic->defaultAcquisitionMixRateIncrements],
			Replace[specifiedMaxStirAttempts,Automatic->defaultMaxStirAttempts],
			Replace[specifiedAdjustMixRate,Automatic->True]
		},
		{
			Replace[roundedAcquisitionMixRate,Automatic->Null],
			Replace[roundedMinAcquisitionMixRate,Automatic->Null],
			Replace[roundedMaxAcquisitionMixRate,Automatic->Null],
			Replace[roundedAcquisitionMixRateIncrements,Automatic->Null],
			Replace[specifiedMaxStirAttempts,Automatic->Null],
			Replace[specifiedAdjustMixRate,Automatic->Null]
		}
	];


	(* - Resolve ReadDirection - *)
	resolvedReadDirection=If[!MatchQ[specifiedReadDirection,Automatic],
		specifiedReadDirection,
		If[lunaticQ || cuvetteQ,
			Null,
			Row
		]
	];

	(* -- Resolve Plate Reader Mixing options -- *)
	resolvedPlateReaderMix=Which[
		MatchQ[specifiedPlateReaderMix,BooleanP],specifiedPlateReaderMix,
		MemberQ[{specifiedPlateReaderMixRate,specifiedPlateReaderMixTime,specifiedPlateReaderMixMode,specifiedPlateReaderMixSchedule},Except[Automatic|Null]],True,
		True,False
	];

	(* - Resolve PlateReaderMix Parameters - *)

	(* Mixing defaults for automatic resolution *)
	defaultMixingRate=700 RPM;
	defaultMixingTime=30 Second;
	defaultMixingMode=DoubleOrbital;
	defaultMixingSchedule=If[anyInjectionsQ,
		AfterInjections,
		If[MatchQ[Lookup[absSpecOptionsAssoc,ReadOrder],Serial],
			BeforeReadings,(* In Serial mode mixing is only allowed before reads begin *)
			BetweenReadings
		]
	];
	roundedMixTime=Lookup[roundedOptionsAssoc,PlateReaderMixTime];
	roundedPlateReaderMixRate=Lookup[roundedOptionsAssoc,PlateReaderMixRate];

	(* If we're mixing replace Automatics with defaults, otherwise replace with Null *)
	{resolvedPlateReaderMixRate,resolvedPlateReaderMixTime,resolvedPlateReaderMixMode,resolvedPlateReaderMixSchedule}=If[resolvedPlateReaderMix,
		{
			Replace[roundedPlateReaderMixRate,Automatic->defaultMixingRate],
			Replace[roundedMixTime,Automatic->defaultMixingTime],
			Replace[specifiedPlateReaderMixMode,Automatic->defaultMixingMode],
			Replace[specifiedPlateReaderMixSchedule,Automatic->defaultMixingSchedule]
		},
		{
			Replace[roundedPlateReaderMixRate,Automatic->Null],
			Replace[roundedMixTime,Automatic->Null],
			Replace[specifiedPlateReaderMixMode,Automatic->Null],
			Replace[specifiedPlateReaderMixSchedule,Automatic->Null]
		}
	];

	(* - Resolve InjectionFlowRate Option - *)
	(* Defaults to Null as Thertiary/Quaternary injections are not available for non-kinetics experiments. *)
	{suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate}=Lookup[absSpecOptionsAssoc,{PrimaryInjectionFlowRate,SecondaryInjectionFlowRate,TertiaryInjectionFlowRate,QuaternaryInjectionFlowRate},Null];

	{primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ}=Map[
		MemberQ[Lookup[absSpecOptionsAssoc,#,{}],VolumeP]&,
		{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}
	];

	(* Default to 300uL/s if we're injecting, Null if we're not *)
	{resolvedPrimaryFlowRate,resolvedSecondaryFlowRate,resolvedTertiaryFlowRate,resolvedQuaternaryFlowRate}=MapThread[
		Which[
			MatchQ[#1,Automatic]&&TrueQ[#2],300 Microliter/Second,
			MatchQ[#1,Automatic]&&!TrueQ[#2],Null,
			True,#1
		]&,
		{{suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate},{primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ}}
	];

(* NOTE: This cannot happen before validMoat where invalidMoatOptions is generated.
	(* - Resolve Moat Options - *)

	impliedMoat=MatchQ[invalidMoatOptions,{}]&&MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]];

	(* Use water and min fill volume *)
	defaultMoatBuffer=Model[Sample,"Milli-Q water"];
	defaultMoatVolume=Lookup[aliquotContainerModelPacket,MinVolume];
	defaultMoatSize=1;

	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize}=If[impliedMoat,
		{
			Replace[specifiedMoatBuffer,Automatic->defaultMoatBuffer],
			Replace[specifiedMoatVolume,Automatic->defaultMoatVolume],
			Replace[specifiedMoatSize,Automatic->defaultMoatSize]
		},
		{
			Replace[specifiedMoatBuffer,Automatic->Null],
			Replace[specifiedMoatVolume,Automatic->Null],
			Replace[specifiedMoatSize,Automatic->Null]
		}
	];
*)
	(* - Pre-resolve Aliquot Options - *)

	(* Lookup relevant options *)
	{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers, suppliedConsolidateAliquots}=Lookup[
		samplePrepOptions,
		{Aliquot,AliquotAmount,AssayVolume,TargetConcentration,AssayBuffer,AliquotContainer, ConsolidateAliquots}
	];

	(* Determine if all the core aliquot options are left automatic for a given sample (note that although we pulled out ConsolidateAliquots above, that does NOT count as a core aliquot option and isn't checked here) *)
	(* If no aliquot options are specified for a sample we want to be able to warn that it will be aliquoted if that comes up *)
	automaticAliquotingBooleans=MapThread[
		Function[{aliquot,aliquotVolume,assayVolume,targetConcentration,assayBuffer,aliquotContainer},
			MatchQ[{aliquot,assayVolume,aliquotVolume,targetConcentration,assayBuffer,aliquotContainer},{Automatic..}]
		],
		{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers}
	];

	(* -- Gather potential errors, then throw a single message -- *)

	(* - Check source container count - *)

	(* Number of simulated sample containers *)
	uniqueContainers=DeleteDuplicates[containerPackets];

	(* Because AbsorbanceKinetics experiments are long running we only allow one container *)
	tooManySourceContainers=Length[uniqueContainers]>1&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation, Manual];

	(* - Check aliquot container count - *)

	(* Get the number of unique aliquot containers requested *)
	(* Convert any links/names to objects for fair comparison *)
	numberOfAliquotContainers=Length[
		DeleteCases[
			DeleteDuplicates[
				Replace[suppliedAliquotContainers,{{id_Integer,object:ObjectP[]}:>{id,Download[object,Object]},object:ObjectP[]:>Download[object,Object]},{1}]
			],
			Automatic
		]
	];

	(* If we're aliquoting some samples we can go wrong is if:
		Aliquot->False for some samples, Aliquot->True for others (or something like AliquotAmount->Null, but we'll ignore and use error thrown by resolveAliquotOptions when we send in Aliquot->True)
		If AliquotContainer -> multiple distinct containers
		If there are multiple unique containers and Aliquot->False in some cases
	*)
	tooManyAliquotContainers=MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation, Manual]&&Or[
		(* If user is specifying aliquots they can only request a single unique container *)
		Length[numberOfAliquotContainers]>1,

		(* Can't request some sample be aliquoted and others not *)
		MemberQ[suppliedAliquotBooleans,True]&&MemberQ[suppliedAliquotBooleans,False],

		(* If we have more than one container in play then somethings are set to be aliquoted or there are multiple sources *)
		(* In either case these then means everything must be aliquoted *)
		MemberQ[suppliedAliquotBooleans,False]&&Length[uniqueContainers]>1
	];

	(* - Check Aliquot and NumberOfReplicates for a conflict - *)
	(* We're interpreting N NumberOfReplicates to mean we should read N aliquots of each sample, so Aliquot must be set to True if we're doing replicates on the BMG *)

	(* Must be aliquoting if we're doing replicates on a BMG reader *)
	(* Warn them if there are any samples which don't have any aliquoting info specified *)
	replicateAliquotsRequired=!MatchQ[numberOfReplicates,Null|Automatic]&&!lunaticQ;
	replicatesError=MemberQ[suppliedAliquotBooleans,False]&&replicateAliquotsRequired;
	replicatesWarning=MemberQ[automaticAliquotingBooleans,True]&&!replicatesError&&replicateAliquotsRequired;


	(* - Check Aliquot and Sample Repeats for a conflict - *)
	(* Must be aliquoting if we have repeated samples on a BMG reader *)

	sampleRepeatAliquotsRequired=!DuplicateFreeQ[Lookup[samplePackets,Object]]&&!lunaticQ;
	sampleRepeatError=MemberQ[suppliedAliquotBooleans,False]&&sampleRepeatAliquotsRequired;
	sampleRepeatWarning=MemberQ[automaticAliquotingBooleans,True]&&!sampleRepeatError&&sampleRepeatAliquotsRequired&&!cuvetteQ;

	(* Since we can only put one container into the plate reader everything must be in a single supported plate or we will need to aliquot all samples *)
	(* RequiredAliquotContainer will throw message if there's a problem with that container *)
	(* Moat, replicates and repeated samples also all require us to create aliquots with current set-up *)
	bmgAliquotRequired=Or[
		tooManySourceContainers,
		sampleRepeatAliquotsRequired,
		replicateAliquotsRequired,
		(*because invalidMoatOptions is not generated at this point for impliedMoat, we use MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]] to skip the moat error checking.*)
		(*impliedMoat*)
		MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]]
	];

	(* - Validate we have enough space for our blanks in the AbsorbanceKinetics case - *)

	(* Get the specified options *)
	{specifiedBlanks,specifiedBlankVolumes}=Lookup[absSpecOptionsAssoc,{Blanks,BlankVolumes}];

	(* convert numberOfReplicates such that Null|Automatic -> 1 *)
	(* We'll assume this for now but resolve to 3 for quantification runs if we find we have enough space after blank resolution *)
	preresolvedNumReplicates=numberOfReplicates/.{(Null|Automatic)->1};

	(* Figure out how many blanks will need to be moved *)
	(* We'll move any sample with BlankVolume specified (and throw an error below if blank needs to move and Volume->Null) *)
	blanksWithVolumesToMove=MapThread[
		Function[{blank,blankVolume,samplePacket},
			Module[{blankPacket,blankContainer},
				(* Find the sample packet for our blank, then get its container *)
				blankPacket=SelectFirst[blankSamplePackets,MatchQ[Lookup[#,Object],ObjectP[blank]]&,<||>];
				blankContainer=Lookup[blankPacket,Container,Null];

				(* Count as needing transfer if a volume has been specified or if left Automatic and we detect transfer is needed *)
				Which[
					MatchQ[blankAbsorbance,False],Nothing,
					MatchQ[blankVolume,VolumeP],{blank,blankVolume},
					(MatchQ[blankVolume,Automatic]&&(!MatchQ[First[containerPackets],ObjectP[blankContainer]]||NullQ[First[containerPackets]]||bmgAliquotRequired)),{blank,Min[Cases[{Lookup[samplePacket,Volume],300*Microliter},VolumeP]]},
					True,Nothing
				]
			]
		],
		{specifiedBlanks,specifiedBlankVolumes,samplePackets}
	];

	(* We also make replicates for blanks so account for this in our total *)
	numberOfTransferBlanks=preresolvedNumReplicates*Length[DeleteDuplicates[blanksWithVolumesToMove]];

	(* Determine if our container has sufficient space - only need to consider first because if we have multiple containers, then we're aliquoting *)
	(* If we have insufficientBlankSpace we must aliquot *)
	containerContents=Lookup[FirstCase[containerPackets,PacketP[],<||>],Contents,{}];
	numbersOfWells=Lookup[FirstCase[sampleContainerModelPackets,PacketP[],<||>],NumberOfWells];
	insufficientBlankSpace=If[MatchQ[FirstCase[sampleContainerModelPackets,PacketP[],<||>],ObjectP[Model[Container,Plate]]],
		(numbersOfWells-Length[containerContents])<numberOfTransferBlanks&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation, Manual],
		(* If we aren't working with a plate we'll have to aliquot anyways and we don't want to confuse that with blank space *)
		False
	];

	(* Check Aliquot and BlankVolumes for a conflict *)

	blankSpaceError=MemberQ[suppliedAliquotBooleans,False]&&insufficientBlankSpace;
	blankSpaceWarning=MemberQ[automaticAliquotingBooleans,True]&&!blankSpaceError&&insufficientBlankSpace;

	(* Create tests but wait to throw our messages until we've done some final error checking post resolution *)
	aliquotContainerTest=If[gatherTests,
		Test["All samples are in a single supported container or are set to be aliquoted into a single supported container:",tooManyAliquotContainers,False]
	];

	replicatesAliquotTest=If[gatherTests,
		Test["If replicate readings are to be done, the samples may be aliquoted in order to create replicate samples for these readings:",replicatesError,False]
	];

	sampleRepeatTest=If[gatherTests,
		Test["If any samples are repeated in the input then they are set to be aliquoted since repeat readings are performed on aliquots of the input samples:",sampleRepeatError,False]
	];

	blankSpaceTest=If[gatherTests,
		Test["Samples may be aliquoted if it's necessary to do so in order to add the necessary blanks to the assay plate:",blankSpaceError,False]
	];

	invalidAliquotOption=If[tooManyAliquotContainers||replicatesError||sampleRepeatError||blankSpaceError,
		Aliquot,
		{}
	];

	(* For AbsorbanceKinetics we have to aliquot if samples are being aliquoted since everything goes in the same plate *)
	(* For others we only need to aliquot if we have to make replicate samples *)
	blankAliquotRequired=Which[
		cuvetteQ,If[MatchQ[Lookup[blankSamplePackets,Container],ObjectP[Model[Container,Cuvette]]],
			False,
			True
			],
		MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation,Manual],bmgAliquotRequired||MemberQ[suppliedAliquotBooleans,True]||insufficientBlankSpace,
		True,replicateAliquotsRequired
	];

	(*  ContainerOut vs SamplesOutStorageCondition *)

	(* check whether the ContainerOut is specified while the SamplesOutStorageCondition is set to Disposal for which we will need to throw an error *)
	containerOutConflicts=If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		{},
		MapThread[
		Function[{containerOut,sc,sampleObject,recoupSample},
			If[MatchQ[sc,Disposal]&&!MatchQ[containerOut,Automatic|Null]||MatchQ[sc,Disposal]&&MatchQ[recoupSample,True],
				{sampleObject,containerOut},
				Nothing
			]
		],
		{specifiedContainerOut,specifiedSamplesOutStorageCondition,simulatedSamples,specifiedRecoupSample}
		]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	(* we don't want to throw this error if we already have thrown the discarded / non-volume / non-liquid input test *)
	badContainerOutOptions=If[Length[containerOutConflicts]>0 && messages,
		Message[Error::AbsSpecSamplesOutStorageConditionConflict,
			ObjectToString[containerOutConflicts[[All,1]],Cache->cacheBall],
			containerOutConflicts[[All,2]]
		];
		{ContainerOut, SamplesOutStorageCondition, RecoupSample},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badContainerOutTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[containerOutConflicts,{}],{},containerOutConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Cache->cacheBall]<>", the SamplesOutStorageCondition is set to Disposal when ContainerOut is not specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Cache->cacheBall]<>", the SamplesOutStorageCondition is set to Disposal when ContainerOut is not specified:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check if Temperature is specified but EquilibrationTime was specified zero. Need to warn the user that there might be fluctuations. *)
	plateReaderTemperatureNoEquilibrationWarning = If[And[
		MatchQ[temperature,GreaterP[$AmbientTemperature]],
		EqualQ[temperatureEquilibriumTime, 0 Minute]],
		True,
		False
	];

	(* Throw message *)
	If[TrueQ[plateReaderTemperatureNoEquilibrationWarning]&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::TemperatureNoEquilibration, temperature, temperatureEquilibriumTime]
	];

	(*If we are gathering tests, create a test for Quantification and Method mismatch*)
	plateReaderTemperatureNoEquilibrationTest=If[gatherTests,
		Test["If Temperature is Solubility, EquilibriumTime is above 0 Minute:",
			plateReaderTemperatureNoEquilibrationWarning,
			False
		],
		Nothing
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[experimentFunction,roundedOptionsAssoc];

	(* need to pre-resolve the QuantifyConcentration option *)
	preResolvedQuantifyConcentration = Map[
		Which[
			(* if specified, then pick whatever that is *)
			BooleanQ[Lookup[#, QuantifyConcentration]], Lookup[#, QuantifyConcentration],
			(* if QuantificationAnalyte is specified, then True *)
			MatchQ[Lookup[#, QuantificationAnalyte], IdentityModelP], True,
			(* if not specified and we're in AbsorbanceIntensity, keep as Automatic (this is because AbsorbanceIntensity always has wavelength and so that isn't enough to say we're quantifying and the logic below in the MapThread is slightly different) *)
			MatchQ[Lookup[#, QuantifyConcentration], Automatic] && MatchQ[myType, Object[Protocol, AbsorbanceIntensity]], Automatic,
			(* if a wavelength is specified and we're in AbsSpec, resolve to True *)
			MatchQ[Lookup[#, wavelengthOptionName], UnitsP[Nanometer]], True,
			(* otherwise, False *)
			True, False
		]&,
		mapThreadFriendlyOptions
	];

	(* pre-resolve the QuantificationAnalyte option; if it is Automatic and QuantifyConcentration -> False, change to Null *)
	preResolvedQuantAnalyte = MapThread[
		If[MatchQ[#1, False] && MatchQ[#2, Automatic],
			Null,
			#2
		]&,
		{preResolvedQuantifyConcentration, Lookup[mapThreadFriendlyOptions, QuantificationAnalyte]}
	];

	(* decide the potential analytes to use; specifying the Analyte here will pre-empt warnings thrown by this function *)
	{potentialAnalytesToUse, potentialAnalyteTests} = If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		(* For AbsorbanceKinetics, we still want to try to find the analyte. This will help us resolve the best Wavelengths to use. We do not want to complain about this with messages though *)
		{Quiet[selectAnalyteFromSample[samplePackets, Cache -> cacheBall, Output -> Result, DetectionMethod -> Absorbance]], Null},
		If[gatherTests,
			selectAnalyteFromSample[samplePackets, Analyte -> preResolvedQuantAnalyte, Cache -> cacheBall, DetectionMethod -> Absorbance, Output -> {Result, Tests}],
			{selectAnalyteFromSample[samplePackets, Analyte -> preResolvedQuantAnalyte, Cache -> cacheBall, DetectionMethod -> Absorbance, Output -> Result], Null}
		]
	];

	(* get the valid container models that can be used with this experiment; Lunatic has special requirements since we load the chip with a 50ul tip *)
	validPlateModelsList=Which[
		lunaticQ,validModelsForLunaticLoading[],
		cuvetteQ,absorbanceAllowedCuvettes,
		True,BMGCompatiblePlates[Absorbance]
	];

	(* Do a quick pre-resolve on aliquot options since it will be needed to resolve blank options *)
	(* Set Aliquot->True if some other action was requested that will require aliquots *)
	preresolvedAliquot=Map[
		If[(bmgAliquotRequired||insufficientBlankSpace)&&MatchQ[#,Automatic]&&MatchQ[resolvedPreparation, Manual],
			True,
			#
		]&,
		suppliedAliquotBooleans
	];

	{
		resolvedAcquisitionMix,
		resolvedCuvetteContainerModels,
		resolvedCuvetteStirBars,
		resolvedContainersOut,
		resolvedRecoupSamples,
		resolvedSamplesOutStorageCondition,
		quantificationWavelengths,
		preferredWavelengths,
		quantifyConcentrations,
		quantificationAnalytes,
		blanks,
		blankVolumes,
		concInvalidOptionsErrors,
		extCoefficientNotFoundWarnings,
		incompatibleBlankOptionsErrors,
		blankVolumeNotAllowedErrors,
		missingExtCoefficientErrors,
		sampleContainsAnalyteErrors,
		blankContainerErrors,
		blankContainerWarnings
	}=Transpose[MapThread[
		Function[{samplePacket,containerPacket,containerInPacket,compositionPackets,potentialAnalyte,options, aliquotQ},
			Module[
				{incompatibleBlankOptionsError,blankVolumeNotAllowedError,specifiedBlank,specifiedBlankVolume,
					concInvalidOptionsError,extCoefficientNotFoundWarning,blank,blankVolume,extCoefficients,
					specifiedAcqMix,acquisitionMixes,resolvedVolume,cuvetteMixPackets,cuvetteContainerModel,resolvedStirBars,
					specRecoupSample,specContainerOut,specSamplesOutStorageCondition,resolvedOutputContainer,
					specifiedQuantConc,specifiedQuantWavelength,quantificationWavelength,preferredWavelength,quantifyConcentration,
					missingExtCoefficientError,blankSamplePacket,blankContainerPacket,badBlankContainer,blankContainerError,
					blankContainerWarning,resolvedExtinctionCoefficient,specifiedQuantAnalyte,sampleComposition,
					quantAnalyte,quantAnalytePacket,calculatedExtCoefficient,containerMaxVolume,containerRecommendedVolume,
					sampleContainsAnalyteError,peptideQ,bestGuessBlankContainerModel,bestInitialGuessBlankContainerModel},

				(* set up our error tracking variables *)
				{concInvalidOptionsError, extCoefficientNotFoundWarning, incompatibleBlankOptionsError, blankVolumeNotAllowedError, missingExtCoefficientError, sampleContainsAnalyteError,blankContainerError,blankContainerWarning} = {False, False, False, False, False, False, False, False};

				(* --- AcquisitionMix resolution --- *)

				(* look up user specified AcquisitionMix *)
				specifiedAcqMix=Lookup[options,AcquisitionMix];

				(* if we are using cuvettes, resolve acquisitionmix *)
				acquisitionMixes=If[cuvetteQ,
					Which[
						(* if the user specified AcquisitionMix, use that *)
						MatchQ[specifiedAcqMix,BooleanP],specifiedAcqMix,
						(* if we are using lunatic, resolve to null *)
						lunaticQ,Null,
						(* if the resolvedMethods is Microfluidic or PlateReader, resolve to Null *)
						MatchQ[resolvedMethods,Microfluidic|PlateReader],Null,
						(* if AcquisitionMixRate, AcquisitionMixRateIncrements, Min/MaxAcquisitionMixRate, MaxStirAttempts, StirBar, or AdjustMixRate was specified as True, resolve to True *)
						MemberQ[
							Flatten[{
								specifiedAcquisitionMixRate, specifiedAcquisitionMixRateIncrements, specifiedMinAcquisitionMixRate,
								specifiedMaxAcquisitionMixRate, specifiedMaxStirAttempts, specifiedStirBar, specifiedAdjustMixRate
							}],
							True],True,
						(* otherwise, set to false *)
						True,False
					],
					Null
				];

				(* -- Aliquot Cuvettes Resolution -- *)
				(* If the volume is Null, we still want to return a valid target container, even if we're throwing errors. Therefore default to the MaxVolume of the container that the sample is currently in *)
				(*
					if we have the AssayVolume - use that volume to pick a cuvette
					if we are allowed to aliquot - just pick the smallest cuvette with required mixing
					if we have an error on this sample, ???
				*)

				(* find cuvettes that are compatible with a stir bar if AcquisitionMix is true *)
				cuvetteMixPackets=If[cuvetteQ&&TrueQ[acquisitionMixes],
					Select[cuvettePackets, StringContainsQ[Lookup[#,Name], "Stirring"]&],
					cuvettePackets
				];

				{resolvedVolume, cuvetteContainerModel} = Module[{naiveVolume},
					naiveVolume = If[MatchQ[Lookup[options,AssayVolume],VolumeP],
						Lookup[options,AssayVolume],
						Lookup[samplePacket,Volume]
					];
					Which[
						(* we are not in a cuvette - return assay volume or sample volume and no cuvette *)
						!cuvetteQ,{naiveVolume,Null},

						(*- we are in a cuvette -*)

						(* we are erroring out about weird volume for this sample already *)
						MemberQ[totalVolumeConflicts,{Lookup[samplePacket,Object],_}],{naiveVolume,Null},

						(* if we know the AssayVolume - find the smallest cuvette that will fit it, we would have caught
						any problematic cases in the error above, so it is safe to not have a default here *)
						MatchQ[Lookup[options,AssayVolume],VolumeP],
						{
							Lookup[options,AssayVolume],
							SelectFirst[
								cuvetteMixPackets,
								And[
									Lookup[#,MinVolume]<Lookup[options,AssayVolume],
									Lookup[#,MaxVolume]>Lookup[options,AssayVolume]
								]&
							]
						},

						(* we have a user-specified aliquot container MODEL *)
						MatchQ[Lookup[options,AliquotContainer],ObjectP[Model[Container]]],
						{
							Lookup[fetchPacketFromCache[Lookup[options,AliquotContainer],cacheBall],RecommendedFillVolume],
							Lookup[options,AliquotContainer]
						},

						(* we have a user-specified aliquot container OBJECT *)
						MatchQ[Lookup[options,AliquotContainer],ObjectP[Object[Container]]],
						{
							fastAssocLookup[fastCacheBall, Lookup[options,AliquotContainer], {Model, RecommendedFillVolume}],
							fastAssocLookup[fastCacheBall, Lookup[options,AliquotContainer], Model]
						},

						(* we will aliquot things without a specified container, take the RecommendedFillVolume of the smallest default Cuvette we are using *)
						MatchQ[Lookup[options,Aliquot],Automatic|True],
						{
							Lookup[cuvetteMixPackets[[1]],RecommendedFillVolume],
							Lookup[cuvetteMixPackets[[1]],Object]
						}
					]];

				(* -- resolve stir bar--*)
				resolvedStirBars = Which[
					(* respect user input, if it is set it is set *)
					MatchQ[Lookup[options, StirBar], Except[Automatic]],
						Lookup[options, StirBar],
					(* otherwise if we not using cuvette method, or acquisition mix is not needed, set to Null *)
					(!cuvetteQ) || (!TrueQ[acquisitionMixes]),
						Null,
					(* resolve stir bars depending on the resolved cuvette model; currently, cuvettes and stir bars are hardcoded *)
					True,
						cuvetteContainerModel /. {
							ObjectP[Model[Container, Cuvette, "id:mnk9jOR4n89R"]] -> Model[Part, StirBar, "id:xRO9n3BLRZZO"], (* Standard Scale with Stirring *)
							ObjectP[Model[Container, Cuvette, "id:Y0lXejMD0VBm"]] -> Model[Part, StirBar, "id:Z1lqpMza1XPV"], (* Semi-Micro Scale with Stirring *)
							ObjectP[Model[Container, Cuvette, "id:Vrbp1jKkre0x"]] -> Model[Part, StirBar, "id:Y0lXejMD0VKP"], (* Micro Scale with Stirring *)
							_ -> Null
						}
				];


				(* -- CUVETTE CONTAINER OUT RESOLUTION -- *)

				(* lookup user specified values for RecoupSample *)
				specRecoupSample = If[cuvetteQ, Lookup[options, RecoupSample]];

				(* lookup user specified values for ContainerOut *)
				specContainerOut = If[cuvetteQ, Lookup[options, ContainerOut]];

				(* lookup user specified sample storage conditions *)
				specSamplesOutStorageCondition = If[cuvetteQ, Lookup[options, SamplesOutStorageCondition]];

				(* resolve ContainersOut for samples *)
				resolvedOutputContainer = Which[
					!cuvetteQ, Null,
					(*	If ContainerOut specified, take specified *)
					MatchQ[specContainerOut, Except[Automatic]], specContainerOut,
					(* if RecoupSample specified, resolve to original container, *)
					TrueQ[specRecoupSample], Lookup[containerInPacket, Object],
					(* if SamplesOutStorageCondition is set to disposal, set ContainerOut to Null *)
					MatchQ[specSamplesOutStorageCondition, Disposal], Null,
					(* Otherwise, take the preferred container of the maximum possible final total volume *)
					True, PreferredContainer[resolvedVolume]
				];


				(* --- Quantification value resolution --- *)

				(* pull out the specified values for QuantifyConcentration, QuantificationWavelength, and QuantificationAnalyte *)
				{specifiedQuantConc, specifiedQuantWavelength, specifiedQuantAnalyte} = Lookup[options, {QuantifyConcentration, wavelengthOptionName, QuantificationAnalyte}];

				(* resolve the QuantifyConcentration value *)
				quantifyConcentration=Which[
					(* We don't do any quantification in AbsorbanceKinetics so just turn this off *)
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],False,
					(* if specified, then pick whatever that is *)
					BooleanQ[specifiedQuantConc],specifiedQuantConc,
					(* if QuantificationAnalyte is specified, then True *)
					MatchQ[specifiedQuantAnalyte, IdentityModelP], True,
					(* if not specified and we're in AbsorbanceIntensity, resolve to False (this is because AbsorbanceIntensity always has wavelength and so that isn't enough to say we're quantifying)  *)
					MatchQ[specifiedQuantConc,Automatic]&&MatchQ[myType,Object[Protocol,AbsorbanceIntensity]],False,
					(* if a wavelength is specified and we're in AbsSpec, resolve to True *)
					MatchQ[specifiedQuantWavelength,UnitsP[Nanometer]],True,
					(* otherwise, False *)
					True,False
				];

				(* pull out the composition of the sample packets *)
				sampleComposition = Lookup[samplePacket, Composition];

				(* resolve the QuantificationAnalyte option *)
				quantAnalyte = Which[
					(* if specified, obviously go with it *)
					MatchQ[specifiedQuantAnalyte, IdentityModelP], specifiedQuantAnalyte,
					(* if not specified and we are not quantifying, then this should be Null *)
					MatchQ[quantifyConcentration, False], Null,
					(* if not specified but we are quantifying, pick the value we resolved to above*)
					True, potentialAnalyte
				];

				(* get the quantification analyte packets *)
				quantAnalytePacket = Which[
					MatchQ[quantAnalyte, IdentityModelP],
					SelectFirst[compositionPackets, Not[NullQ[#]] && MatchQ[quantAnalyte, ObjectP[Lookup[#, Object]]]&, Null],
					(* for AbsIntensity, even if we are not quantifying we still need the analyte to resolve the wavelength reasonably *)
					MatchQ[myType, Object[Protocol, AbsorbanceIntensity]],
					SelectFirst[compositionPackets, Not[NullQ[#]] && MatchQ[potentialAnalyte, ObjectP[Lookup[#, Object]]]&, Null],
					(* otherwise set to Null *)
					True,
					Null
				];

				(* get whether we're dealing with a peptide or protein *)
				peptideQ = Not[NullQ[quantAnalytePacket]] && (MatchQ[Lookup[quantAnalytePacket, PolymerType], Peptide] || MatchQ[quantAnalyte, ObjectP[Model[Molecule, Protein]]]);

				(* pull out the ExtinctionCoefficients field from the analyte packet *)
				(* use the function if the field isn't populated *)
				extCoefficients = If[NullQ[quantAnalytePacket],
					Null,
					Lookup[quantAnalytePacket, ExtinctionCoefficients]
				];

				(* resolve the QuantificationWavelength option and also flip error switches if necessary *)
				(* We don't do any quantification in AbsorbanceKinetics so just turn this off *)
				{quantificationWavelength,concInvalidOptionsError,extCoefficientNotFoundWarning}=Which[
				(*We don't do any quantification in AbsorbanceKinetics so just turn this off*)
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],{Null,False,False},
					(* if doing AbsorbanceIntensity and Wavelength is specified, go with that *)
					MatchQ[myType, Object[Protocol, AbsorbanceIntensity]] && MatchQ[specifiedQuantWavelength, UnitsP[Nanometer]], {specifiedQuantWavelength, False, False},
					(* if doing AbsorbanceIntensity and Wavelength is Automatic and ExtinctionCoefficients is populated, use the first value*)
					MatchQ[myType, Object[Protocol, AbsorbanceIntensity]] && MatchQ[specifiedQuantWavelength, Automatic] && MatchQ[extCoefficients, {__Association}], {Lookup[First[extCoefficients], Wavelength], False, False},
					(* if doing AbsorbanceIntensity and Wavelength is Automatic and ExtinctionCoefficients is not populated and the polymer type is a Peptide, resolve to 280 Nanometer and throw a warning *)
					MatchQ[myType, Object[Protocol, AbsorbanceIntensity]] && MatchQ[specifiedQuantWavelength, Automatic] && Not[MatchQ[extCoefficients, {__Association}]] && peptideQ, {280 * Nanometer, False, True},
					(* if doing AbsorbanceIntensity and Wavelength is Automatic and ExtinctionCoefficients is not populated and the polymer type is not a Peptide, resolve to 260 Nanometer and throw a warning *)
					MatchQ[myType, Object[Protocol, AbsorbanceIntensity]] && MatchQ[specifiedQuantWavelength, Automatic] && Not[MatchQ[extCoefficients, {__Association}]], {260 * Nanometer, False, True},
					(* if neither the QuantifyConcentration nor the (Quantification)Wavelength nor the QuantificationAnalyte options were specified, we are not quantifying and so the wavelength becomes Null *)
					MatchQ[specifiedQuantConc, Automatic] && MatchQ[specifiedQuantWavelength, Automatic] && MatchQ[specifiedQuantAnalyte, Automatic], {Null, False, False},
					(* if QuantifyConcentration was not set but the (Quantification)Wavelength options was, just go with that value (and we know that we can't run into the errors in that case so don't need to do error checking logic) *)
					MatchQ[specifiedQuantConc, Automatic] && MatchQ[specifiedQuantWavelength, Null | UnitsP[Nanometer]], {specifiedQuantWavelength, False, False},
					(* if (Quantification)Wavelength is Null and QuantifyConcentration is True, set to Null and flip the concInvalidOptionsError switch *)
					NullQ[specifiedQuantWavelength] && TrueQ[quantifyConcentration], {Null, True, False},
					(* if (Quantification)Wavelength is specified and not Null and QuantifyConcentration is False, set to specified value and flip the concInvalidOptionsError switch *)
					MatchQ[specifiedQuantWavelength, UnitsP[Nanometer]] && Not[TrueQ[quantifyConcentration]], {specifiedQuantWavelength, True, False},
					(* if (Quantification)Wavelength is specified otherwise, just use that value and don't flip any error switches *)
					MatchQ[specifiedQuantWavelength, Null | UnitsP[Nanometer]], {specifiedQuantWavelength, False, False},
					(* if (Quantification)Wavelength is not specified and we're not quantifying, resolve to Null *)
					MatchQ[specifiedQuantWavelength, Automatic] && Not[TrueQ[quantifyConcentration]], {Null, False, False},
					(* if (Quantification)Wavelength is not specified and we are quantifying and the ExtinctionCoefficients field is populated, use its first wavelength *)
					MatchQ[specifiedQuantWavelength, Automatic] && TrueQ[quantifyConcentration] && MatchQ[extCoefficients, {__Association}], {Lookup[First[extCoefficients], Wavelength], False, False},
					(* if (Quantification)Wavelength is not specified and we are quantifying and the ExtinctionCoefficients field is not populated and the polymer type is Peptide, use 280 Nanometer and flip the warning switch *)
					MatchQ[specifiedQuantWavelength, Automatic] && TrueQ[quantifyConcentration] && Not[MatchQ[extCoefficients, {__Association}]] && peptideQ, {280 * Nanometer, False, True},
					(* if (Quantification)Wavelength is not specified and we are quantifying and the ExtinctionCoefficients field is not populated and the polymer type is not a peptide, use 260 Nanometer and flip the warning switch *)
					MatchQ[specifiedQuantWavelength, Automatic] && TrueQ[quantifyConcentration] && Not[MatchQ[extCoefficients, {__Association}]], {260 * Nanometer, False, True}
				];

				(*We don't do any quantification in AbsorbanceKinetics so we just give a number for resolving our wavelength later *)
				preferredWavelength=Which[
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[extCoefficients, {__Association}],Lookup[First[extCoefficients], Wavelength],
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&peptideQ,280*Nanometer,
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],260*Nanometer,
					True,Null
				];

					(* also flip the concInvalidOptionsError variable if QuantificationAnalyte is specified/Null when the other is not *)
				concInvalidOptionsError = Or[
					(* QuantificationAnalyte is Null but QuantifyConcentration is True, this is for sure error state *)
					NullQ[quantAnalyte] && TrueQ[quantifyConcentration],
					(* QuantificationAnalyte is Null but Wavelength is specified, gonna be an error state for any protocol type other than AbsorbanceIntensity, since Wavelength is always specified *)
					NullQ[quantAnalyte] && DistanceQ[quantificationWavelength] && !MatchQ[myType, Object[Protocol, AbsorbanceIntensity]],
					(* QuantificationAnalyte is an object but one of the other quantification options is not specified *)
					MatchQ[quantAnalyte, IdentityModelP] && (NullQ[quantificationWavelength] || Not[TrueQ[quantifyConcentration]]),
					(* we've already flipped the switch *)
					concInvalidOptionsError
				];

				(* --- Blank resolution --- *)

				(* pull out blank and blankVolume option values *)
				{specifiedBlank, specifiedBlankVolume} = Lookup[options, {Blanks, BlankVolumes}];

				(* resolve the Blank option, and return what the re-assigned incompatibleBlankOptionsError value is (note that we are passing the previous value of incompatibleBlankOptionsError down; I am only explicitly setting it if marking as True) *)
				{blank, incompatibleBlankOptionsError} = Which[
					(* if BlankAbsorbance -> True, but the specified blank is Null, then we are in an erroreous state (hence True) *)
					TrueQ[blankAbsorbance] && NullQ[specifiedBlank], {Null, True},
					(* if BlankAbsorbance -> True and we're Robotic, pick the first sample in the plate. *)
					TrueQ[blankAbsorbance] && MatchQ[resolvedPreparation, Robotic] && MatchQ[specifiedBlank, Automatic],
						{
							FirstCase[
								Download[Lookup[containerPacket, Contents][[All,2]], Object],
								Except[ObjectP[simulatedSamples]],
								FirstOrDefault[simulatedSamples]
							],
							False
						},
					(* if BlankAbsorbance -> True and Blank -> Automatic, check to see if the SamplesIn has a Solvent - If so, use it *)
					TrueQ[blankAbsorbance] && MatchQ[specifiedBlank, Automatic] && MatchQ[Download[Lookup[samplePacket,Solvent],Object],ObjectP[Model[Sample]]],  {Download[Lookup[samplePacket,Solvent],Object], False},
					(* if BlankAbsorbance -> True and Blank -> Automatic and there is no Solvent specified in the samplePacket, resolve to water *)
					TrueQ[blankAbsorbance] && MatchQ[specifiedBlank, Automatic], {Model[Sample, "Milli-Q water"], False},
					(* if BlankAbsorbance -> True and Blank is something else, stick with that something else *)
					TrueQ[blankAbsorbance], {specifiedBlank, False},
					(* if BlankAbsorbance -> False and Blank is Automatic or Null, then resolve to Null *)
					MatchQ[blankAbsorbance, False] && MatchQ[specifiedBlank, Automatic | Null], {Null, False},
					(* if BlankAbsorbance -> False and Blank is specified as something besides Automatic or Null, this is an erroneous state (hence True) *)
					MatchQ[blankAbsorbance, False] && Not[MatchQ[specifiedBlank, Automatic | Null]], {specifiedBlank, True},
					(* catch-all for some weird case where none of the above applied; if this happens we are definitely in an errneous state so mark True *)
					True, {specifiedBlank, True}
				];


				(* BMG blank objects must be in a supported container if they aren't going to be moved into one (i.e. if BlankVolume->Null) *)
				(* For the blank container to be valid in AbsorbanceKinetics, it must match sample container since we only allow one plate *)
				(* Just check the container - we'll do a global check below to see if any aliquoting needs to happen *)
				blankSamplePacket=SelectFirst[blankSamplePackets,MatchQ[Lookup[#,Object],ObjectP[blank]]&,<||>];
				blankContainerPacket=SelectFirst[blankContainerPackets,MatchQ[Lookup[#,Object],ObjectP[Lookup[blankSamplePacket,Container]]]&,<||>];
				badBlankContainer=If[MatchQ[specifiedBlank,ObjectP[Object]],
					Or[
						(* If we are doing aliquot on sample, then always say we need to move the blank *)
						TrueQ[aliquotQ],
						If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation, Manual],
							!MemberQ[Lookup[containerPackets,Object],ObjectP[Lookup[blankContainerPacket,Object]]]&&!blankAliquotRequired,
							!MemberQ[BMGCompatiblePlates[Absorbance],ObjectP[Lookup[blankContainerPacket,Model]]]
						]
					],
					(* All models need a volume *)
					True
				];

				(* this is a bit janky, but we are trying to guess which container we will be using for the experiment here. We don't have _all_ the information we need to know for sure since it needs info for all samples *)
				bestInitialGuessBlankContainerModel=Which[
					cuvetteQ && MemberQ[validPlateModelsList,ObjectP[FirstCase[Flatten[suppliedAliquotContainers],ObjectP[]]]],suppliedAliquotContainers,
					MemberQ[validPlateModelsList,ObjectP[FirstCase[Flatten[suppliedAliquotContainers],ObjectP[]]]],FirstCase[Flatten[suppliedAliquotContainers],ObjectP[]],
					cuvetteQ,resolvedCuvetteContainerModels,
					True,First[BMGCompatiblePlates[Absorbance]]
				];

				bestGuessBlankContainerModel=If[MemberQ[validPlateModelsList,ObjectP[Download[Lookup[blankContainerPacket,Model],Object]]],
					Download[Lookup[blankContainerPacket,Model],Object],
					bestInitialGuessBlankContainerModel
				];

				(* Get the model container's max volume to do comparisons later *)
				containerMaxVolume =Replace[
					Lookup[
						fetchPacketFromCache[bestGuessBlankContainerModel,cacheBall],
						MaxVolume,
						Null
					],
					{Null->300 * Microliter}
				];(*largest volume of the microtiter plates*)

				containerRecommendedVolume =Replace[
					Lookup[
						fetchPacketFromCache[bestGuessBlankContainerModel,cacheBall],
						RecommendedFillVolume,
						Null
					],
					{Null | $Failed->0.2 * containerMaxVolume}
				];

				(* resolve the BlankVolume option, and return what the reassigned error values are *)
				{blankVolume,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning}=Which[
					(* if BlankAbsorbance -> True, BlankVolume -> Automatic, and we are using the Lunatic, BlankVolume resolves to 2 Microliter *)
					TrueQ[blankAbsorbance]&&MatchQ[specifiedBlankVolume,Automatic]&&lunaticQ,{2.1*Microliter,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolume -> Automatic, and we are using a Cary 3500, BlankVolume resolves to the current volume of the sample or 300 Microliter, whichever is smaller; note that this is the same as the RequiredAliquotAmount stuff below*)
					TrueQ[blankAbsorbance]&&MatchQ[specifiedBlankVolume,Automatic]&&cuvetteQ,
					{
						If[(badBlankContainer||blankAliquotRequired) && !MatchQ[cuvetteContainerModel, Null],
							Max[{cuvetteContainerModel[MaxVolume],containerRecommendedVolume}],
							Null
						],
						incompatibleBlankOptionsError,
						blankVolumeNotAllowedError,
						blankContainerError,
						blankContainerWarning
					},

					(* if BlankAbsorbance -> True, BlankVolume -> Automatic, and we are using Cary 3500, blank volume; note that this is the same as the RequiredAliquotAmount stuff below*)
					TrueQ[blankAbsorbance]&&MatchQ[specifiedBlankVolume,Automatic]&&Not[lunaticQ],
					{
						If[badBlankContainer||blankAliquotRequired,
							Max[{Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]],containerRecommendedVolume}],
							Null
						],
						incompatibleBlankOptionsError,
						blankVolumeNotAllowedError,
						blankContainerError,
						blankContainerWarning
					},

					(* if BlankAbsorbance -> True, BlankVolumes is Null, and we are using the Lunatic, we are in a double-erroneous state *)
					TrueQ[blankAbsorbance]&&NullQ[specifiedBlankVolume]&&lunaticQ,{Null,True,True,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolumes is Null, and we are NOT on the Lunatic and sample needs to be moved then we have an error *)
					TrueQ[blankAbsorbance]&&NullQ[specifiedBlankVolume]&&Not[lunaticQ]&&badBlankContainer,{Null,incompatibleBlankOptionsError,blankVolumeNotAllowedError,True,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolumes is Null, and we are NOT on the Lunatic and sample doesn't needs to be moved then we are okay *)
					TrueQ[blankAbsorbance]&&NullQ[specifiedBlankVolume]&&Not[lunaticQ]&&!badBlankContainer,{Null,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolumes is not Null or Automatic, and we're NOT using the lunatic, warn the user that they're making an unnecessary transfer *)
					TrueQ[blankAbsorbance]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&Not[lunaticQ]&&!(badBlankContainer||blankAliquotRequired),{specifiedBlankVolume,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,True},

					(* if BlankAbsorbance -> True, BlankVolumes is not Null or Automatic, and we're NOT using the lunatic, use the user specified value *)
					TrueQ[blankAbsorbance]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&Not[lunaticQ]&&(badBlankContainer||blankAliquotRequired),{specifiedBlankVolume,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolumes is not Null or Automatic, we're using the Lunatic, AND blank volumes is not 2.1*Microliter, we are in the Blank-Volume-Not-Allowed erroneous state *)
					TrueQ[blankAbsorbance]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&lunaticQ&&Not[TrueQ[specifiedBlankVolume==2.1*Microliter]],{specifiedBlankVolume,incompatibleBlankOptionsError,True,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> True, BlankVolumes is not Null or Automatic, we're using the Lunatic, AND blank volumes is 2.1*Microliter, we are all good *)
					TrueQ[blankAbsorbance]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&lunaticQ&&TrueQ[specifiedBlankVolume==2.1*Microliter],{specifiedBlankVolume,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> False and BlankVolumes is Automatic or Null, resolve to Null *)
					MatchQ[blankAbsorbance,False]&&MatchQ[specifiedBlankVolume,Automatic|Null],{Null,incompatibleBlankOptionsError,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* if BlankAbsorbance -> False and BlankVolumes is not Null, we are in an erroneous state *)
					MatchQ[blankAbsorbance,False]&&Not[MatchQ[specifiedBlankVolume,Automatic|Null]],{specifiedBlankVolume,True,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning},

					(* catch-all for some weird case where none of the above applied; if this happens we are definitely in an erroneous state *)
					True,{specifiedBlankVolume,True,blankVolumeNotAllowedError,blankContainerError,blankContainerWarning}
				];

				(* call the ExtinctionCoefficients field *)
				calculatedExtCoefficient = Which[
					(* if we have no Analyte, straight to Null *)
					Not[MatchQ[quantAnalytePacket, PacketP[]]]||MatchQ[myType,Object[Protocol,AbsorbanceKinetics]], Null,
					(* if we have ExtinctionCoefficients populated, then pull it from there *)
					MatchQ[Lookup[quantAnalytePacket, ExtinctionCoefficients, {}], Except[{}]], ExtinctionCoefficient[quantAnalytePacket],
					(* if we have Molecule populated, we can calculate the ExtinctionCoefficient so do so *)
					Not[NullQ[Lookup[quantAnalytePacket, Molecule, Null]]], ExtinctionCoefficient[Lookup[quantAnalytePacket, Molecule, Null]],
					(* otherwise it's Null *)
					True, Null
				];

				(* get the resolved extinction coefficient of the wavelength we just resolved; use the calculated value if we need to *)
				resolvedExtinctionCoefficient = Which[
					MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],Null,
					MatchQ[extCoefficients, {__Association}],
						FirstOrDefault[Flatten[Map[
							Function[{extinctionCoefficientWavelengthPair},
								If[MatchQ[Lookup[extinctionCoefficientWavelengthPair, Wavelength], EqualP[quantificationWavelength]],
									Lookup[extinctionCoefficientWavelengthPair, ExtinctionCoefficient],
									Nothing
								]
							],
							extCoefficients
						]]],
					ExtinctionCoefficientQ[calculatedExtCoefficient], calculatedExtCoefficient,
					True, Null
				];

				(* determine if we need to figure out the extinction coefficient but don't have one *)
				(* 1.) We don't have an extinction coefficient *)
				(* 2.) We have resolved a quantification wavelength *)
				(* 3.) We have resolved that we are quantifying *)
				missingExtCoefficientError=And[
					NullQ[resolvedExtinctionCoefficient],
					DistanceQ[quantificationWavelength],
					TrueQ[quantifyConcentration]
				];

				(* determine if the resolved quantification analyte is a component of the sample *)
				sampleContainsAnalyteError = If[MatchQ[quantAnalyte, IdentityModelP]&&!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
					Not[MemberQ[sampleComposition[[All, 2]], ObjectP[quantAnalyte]]],
					False
				];

				(* return the MapThread variables in order *)
				{acquisitionMixes,cuvetteContainerModel,resolvedStirBars,resolvedOutputContainer,specRecoupSample,specSamplesOutStorageCondition,quantificationWavelength, preferredWavelength, quantifyConcentration, quantAnalyte, blank, blankVolume, concInvalidOptionsError, extCoefficientNotFoundWarning, incompatibleBlankOptionsError, blankVolumeNotAllowedError, missingExtCoefficientError, sampleContainsAnalyteError,blankContainerError,blankContainerWarning}

			]
		],
		{samplePackets, containerPackets, containerInPackets,sampleCompositionPackets, potentialAnalytesToUse, mapThreadFriendlyOptions, preresolvedAliquot}
	]];

	(*-- Pre-resolve some of the aliquot options (we resolve the rest down the line) -- *)

	(* Set Aliquot->True if some other action was requested that will require aliquots *)
	preresolvedAliquot=Map[
		If[(bmgAliquotRequired||insufficientBlankSpace)&&MatchQ[#,Automatic]&&MatchQ[resolvedPreparation, Manual],
			True,
			#
		]&,
		suppliedAliquotBooleans
	];

	(* - Pre-resolve aliquot container - *)
	(* If there is aliquot container supplied as Object[Container], covert to its model for the validity check below *)
	suppliedAliquotContainerModels = Map[
		Function[suppliedContainer,
			If[MatchQ[suppliedContainer, ObjectP[Object[Container]]],
				(* If supplied an object, pull its model *)
				Lookup[fetchPacketFromCache[suppliedContainer, FlattenCachePackets[listedAliquotContainerPackets]], Model],
				(* Otherwise, leave as it is *)
				suppliedContainer
			]
		],
		Flatten[suppliedAliquotContainers]
	];

	(* If the user gave us a valid container to aliquot into use that same container for any other aliquoting *)
	(* This will make sure it ends up all in one plate when possible *)
	(* User could have specified as {{1,container}..}, sneakily flatten so we can pull out object *)
	(* We don't bother using this in the Lunatic since we're just selecting containers for the liquid handler and things will end up in a chip no matter what *)
	resolutionAliquotContainer=Which[
		cuvetteQ && MemberQ[validPlateModelsList,ObjectP[FirstCase[Flatten[suppliedAliquotContainerModels],ObjectP[]]]],suppliedAliquotContainers,
		MemberQ[validPlateModelsList,ObjectP[FirstCase[Flatten[suppliedAliquotContainerModels],ObjectP[]]]],First[suppliedAliquotContainers],
		cuvetteQ,resolvedCuvetteContainerModels,
		True,First[BMGCompatiblePlates[Absorbance]]
	];

	(* get the target containers: if the samples are already in a valid container, just pick that one; otherwise pick UV-star plate if we're on BMG, or the Model[Container, Vessel, "0.5mL Tube with 2mL Tube Skirt"] if not Lunatic *)
	requiredAliquotContainers = If[MatchQ[resolvedPreparation, Robotic],
		ConstantArray[Null, Length[mySamples]],
		If[cuvetteQ && !MemberQ[validPlateModelsList,ObjectP[Download[sampleContainerModelPackets,Object]]],
			Flatten[{resolutionAliquotContainer}],
			MapThread[
				Which[
					(*we should only let it pass if the sample is already in a valid plate when user gives False/Null*)
					MatchQ[#2,False|Null] && MemberQ[validPlateModelsList,ObjectP[#1]],Null,
					(* Otherwise we were not given aliquot bool, but the sample is already in a valid container, feed the required container the same as the sample container*)
					MemberQ[validPlateModelsList,ObjectP[#1]],#1,
					lunaticQ, PreferredContainer[0.4*Milliliter],
					(* If we reach here, we need to aliquot the sample to new container, despite whether the user gives a aliquot bool. We need to feed resolveAliquotOptions the requried aliquot container so that if the aliquot bool is specified to be false, it will throw an error.*)
					True,resolutionAliquotContainer
				]&,
				{Download[sampleContainerModelPackets,Object],suppliedAliquotBooleans}
			]
		]
	];

	(* extract aliquot model container packet *)
	aliquotContainerModelPacket = With[{firstContainer=First@Flatten[requiredAliquotContainers]},
		If[MatchQ[firstContainer,ObjectP[]],
			fetchPacketFromCache[firstContainer,cacheBall],
			(*
				if we don't need an aliquot container, use the first of the possible aliquot containers to use in the option resolution downstream.
				I do not understand why this behavior was introduced in the first place and why we rely so heavily on it later on in the code,
				but we do this abominable thing to support legacy behavior of the code
			 *)
			If[MatchQ[preresolvedInstrument,ObjectP[{Object[Instrument, Spectrophotometer], Model[Instrument, Spectrophotometer]}]]&&!MatchQ[Lookup[samplePrepOptions, AliquotContainer],{ObjectP[{Model[Container, Cuvette], Object[Container, Cuvette]}]}],
				listedAliquotContainerPackets[[2,1]],
				listedAliquotContainerPackets[[1,1]]
			]
		]
	];

	(* --- Post option resolution error checking --- *)

	(* - Check Sample Number - *)
	(* figure out how many unique blanks there are *)
	(* for BMG assays we will have resolved different BlankVolumes based on sample volume *)
	blankObjects=Download[blanks,Object];
	numBlanks=Length[DeleteDuplicates[blankObjects]];
	numOfBlankAdditions=Length[DeleteDuplicates[Transpose[{blankObjects,blankVolumes}]]];

	(* Figure out if the combination of (NumberOfReplicates * number of samples) + (2* number of blanks) (if we're blanking), or NumberOfReplicates * Number of samples if we are not *)
	(* Note Moat sample space gets checked below by validMoat *)

	totalNumSamples = Which[
		!blankAbsorbance,
			preresolvedNumReplicates*Length[simulatedSamples],
		(* Lunatic doesn't make replicate blanks *)
		lunaticQ,
			(preresolvedNumReplicates*Length[simulatedSamples])+numBlanks,
		(* cuvette only allows one blank sample, if numOfBlankAdditions is somehow larger than 1, Error::TooManyBlanks will be thrown *)
		cuvetteQ,
			(preresolvedNumReplicates*Length[simulatedSamples]) + numOfBlankAdditions,
		True,
			(preresolvedNumReplicates*Length[simulatedSamples])+(numOfBlankAdditions*preresolvedNumReplicates)
	];

	(* Throw an error if we have too many samples *)
	(* We can only actually even have too many samples if we are using the lunatic or Cary 3500 or doing a kinetics run *)
	{tooManySamplesError,tooManySamplesOptions}=Which[
		lunaticQ&&(totalNumSamples>94),
		(
			If[messages,Message[Error::AbsSpecTooManySamples,"the Lunatic","94"]];
			{True,{BlankAbsorbance,Instrument,NumberOfReplicates}}
		),
		cuvetteQ&&(totalNumSamples>8),
		(
			If[messages,Message[Error::AbsSpecTooManySamples,"Cary 3500","7"]];
			{True,{BlankAbsorbance,Instrument,NumberOfReplicates}}
		),
		MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&totalNumSamples>96&&MatchQ[resolvedPreparation,Manual],
		(
			If[messages,Message[Error::AbsorbanceKineticsTooManySamples]];
			{True,{BlankAbsorbance,Instrument,NumberOfReplicates}}
		),
		True,{False,{}}
	];

	(* Make a test for having too many samples *)
	tooManySamplesTest=If[gatherTests,
		Test["Number of samples, blanks, and replicates is low enough such that the specified experiment can be run in one protocol:",
			tooManySamplesError,
			False
		],
		Null
	];

	(* Throw a single message or error if we have to aliquot for some reason *)
	If[messages,Which[
		tooManyAliquotContainers&&!tooManySamplesError,Message[Error::SinglePlateRequired],
		replicatesError&&!tooManySamplesError,Message[Error::ReplicateAliquotsRequired],
		sampleRepeatError&&!tooManySamplesError,Message[Error::RepeatedPlateReaderSamples],
		blankSpaceError&&!tooManySamplesError,Message[Error::InsufficientBlankSpace],


		(* If any aliquot options are set, count is not reliable since simulation will mimic putting samples into vessels during the aliquot so only complain if no aliquoting is happening *)
		Not[MatchQ[$ECLApplication, Engine]]&&tooManySourceContainers&&!tooManySamplesError&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::SinglePlateRequired],
		Not[MatchQ[$ECLApplication, Engine]]&&replicatesWarning&&!tooManySamplesError&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::ReplicateAliquotsRequired],
		Not[MatchQ[$ECLApplication, Engine]]&&sampleRepeatWarning&&!tooManySamplesError&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::RepeatedPlateReaderSamples],
		Not[MatchQ[$ECLApplication, Engine]]&&blankSpaceWarning&&!tooManySamplesError&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::InsufficientBlankSpace]
	]];

	(* - Resolve NumberOfReplicates - *)

	{resolvedNumberOfReplicates,tooFewReplicatesWarning}=If[MatchQ[numberOfReplicates,Automatic]&&MemberQ[quantifyConcentrations,True],
		(* If we're quantifying concentration, resolve to 3 as long as there's space (always true unless we're on the Lunatic )*)
		Which[
			(* If we're doing BMG we don't want to auto-resolve replicates since replicates in this case require aliquots *)
			!lunaticQ&&MemberQ[suppliedAliquotBooleans,False],{Null,False},
			cuvetteQ,{1,False},
			!lunaticQ,{3,False},
			(3*Length[simulatedSamples])+numBlanks<=94,{3,False},
			(2*Length[simulatedSamples])+numBlanks<=94,{2,True},
			(Length[simulatedSamples])+numBlanks<=94,{Null,True},
			True,{Null,False}
		],
		(* Use user value, or if automatic and we're not quantifying default to standard of Null *)
		{numberOfReplicates/.{Automatic->Null},False}
	];

	(* Warn about there not being enough space - this is set such that this doesn't also get thrown if we have a tooManySamplesError *)
	If[tooFewReplicatesWarning&&messages&&!MatchQ[parentProt,ObjectP[Object[Qualification]]]&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ReplicateChipSpace,resolvedNumberOfReplicates]
	];

	tooFewReplicatesTest=If[gatherTests&&!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Warning["There is sufficient space to read the recommended number of replicates in a single experiment.",tooFewReplicatesWarning,False]
	];

	(* convert numberOfReplicates such that Null|Automatic -> 1 *)
	intNumReplicates=resolvedNumberOfReplicates/.{Null->1};

	(* - Resolve NumberOfReadings - *)

	(* Resolve the number of readings based on which instrument we're using *)
	resolvedNumberOfReadings = If[MatchQ[specifiedNumReadings,Automatic],
		If[lunaticQ||cuvetteQ,
			Null,
			100
		],
		specifiedNumReadings
	];

	(* If Lunatic is being used but a number is provided *)
	plateReaderNumberOfReadingsErrorQ = And[lunaticQ||cuvetteQ,MatchQ[resolvedNumberOfReadings,Except[Null]]];

	(* Or we're not using the lunatic and Null is specified *)
	plateReaderNumberOfReadingsNullQ=And[!(lunaticQ||cuvetteQ),MatchQ[resolvedNumberOfReadings,Null]];

	Which[
		plateReaderNumberOfReadingsErrorQ&&messages,
		Message[Error::PlateReaderReadings,resolvedNumberOfReadings,ObjectToString[instrument],"cannot support multiple NumberOfReadings",experimentFunction],
		plateReaderNumberOfReadingsNullQ&&messages,
		Message[Error::PlateReaderReadings,resolvedNumberOfReadings,ObjectToString[instrument],"must specify NumberOfReadings",experimentFunction]
	];

	(* Create test *)
	plateReaderNumberOfReadingsErrorTest = If[gatherTests,
		Test["If a plate reader is incapable of accepting NumberOfReadings, the NumberOfReadings option was not set to an integer:",{lunaticQ||cuvetteQ,resolvedNumberOfReadings},Except[{True,_Integer}|{False,Null}]]
	];

	(* Track invalid option *)
	plateReaderNumberOfReadingsInvalidOptions = If[plateReaderNumberOfReadingsErrorQ||plateReaderNumberOfReadingsNullQ,NumberOfReadings];

	(* - BlankVolumes is specified if blanks need to be moved - *)

	(* Throw message in the simple case where blankContainerErrors is True indicating BlankVolume->Null and container is incompatible *)
	If[MemberQ[blankContainerErrors,True]&&messages,
		If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
			Message[Error::InvalidBlankContainer,"a container holding the assay samples",PickList[blanks,blankContainerErrors,True]],
			Message[Error::InvalidBlankContainer,"a container compatible with the plate reader",PickList[blanks,blankContainerErrors,True]]
		]
	];

	(* If we have to aliquot must throw an error if we're missing volume information about how to do that aliquot for the blanks *)
	blankAliquotError=blankAbsorbance&&blankAliquotRequired&&MemberQ[blankVolumes,Null]&&!MemberQ[blankContainerErrors,True]&&!tooManySamplesError&&MatchQ[myType,Object[Protocol,AbsorbanceKinetics]]&&MatchQ[resolvedPreparation, Manual];

	(* Throw message *)
	If[messages&&blankAliquotError,
		If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
			Message[Error::BlankAliquotRequired,"into a single supported plate",PickList[blanks,blankVolumes,Null]],
			Message[Error::BlankAliquotRequired,"in order to generate replicate blanks",PickList[blanks,blankVolumes,Null]]
		]
	];

	(* Create test *)
	blankContainerErrorTest=If[gatherTests,
		Test["BlankVolume is specified for any blank samples which must be moved from their current containers in order to perform the blank measurement on the instrument:",MemberQ[blankContainerErrors,True],False]
	];

	(* Track invalid option *)
	incompatibleBlankVolumesInvalidOptions=If[MemberQ[blankContainerErrors,True]||blankAliquotError,BlankVolumes];

	(* - Verify BlankVolumes is not specified if Blanks don't need to be moved  - *)

	(* Throw message *)
	If[MemberQ[blankContainerWarnings,True]&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::UnnecessaryBlankTransfer,PickList[blanks,blankContainerWarnings,True]]
	];

	(* Create test *)
	blankContainerWarningTest=If[gatherTests,
		Warning["BlankVolume is not specified for any samples which could be left in their current containers:",MemberQ[blankContainerWarnings,True],False]
	];

	(* Check for incompatible blank options errors *)
	incompatibleBlankInvalidOptions=If[MemberQ[incompatibleBlankOptionsErrors,True]&&messages,
		(
			Message[Error::IncompatibleBlankOptions];
			{BlankAbsorbance,Blanks,BlankVolumes}
		),
		{}
	];

	(* Generate the incompatible blank options tests *)
	incompatibleBlankOptionTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples=PickList[simulatedSamples,incompatibleBlankOptionsErrors];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples=PickList[simulatedSamples,incompatibleBlankOptionsErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["The Blanks and BlankVolumes options are compatible with each other for the following samples: "<>ObjectToString[failingSamples,Cache->cacheBall]<>" when BlankAbsorbance -> "<>ObjectToString[blankAbsorbance]<>":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["The Blanks and BlankVolumes options are compatible with each other for the following samples: "<>ObjectToString[passingSamples,Cache->cacheBall]<>" when BlankAbsorbance -> "<>ObjectToString[blankAbsorbance]<>":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		]
	];

	(* - Verify the state of Blanks if there is no incompatibleBlankOptionsError - *)
	(* find object or model in blanks *)
	selectedBlanks=Select[blanks,ObjectQ];

	(* if there are blank objects, track the invalid ones that are not Liquid *)
	nonLiquidBlanksBoolean=If[!MatchQ[selectedBlanks,{}],
		(!MatchQ[#,Liquid])&/@Download[selectedBlanks, State, Cache ->inheritedCache, Simulation->updatedSimulation],
		{}
	];

	(* Track the invalid ones that are not liquid *)
	nonLiquidBlanks=PickList[selectedBlanks,nonLiquidBlanksBoolean];

	blankStateWarning=Length[nonLiquidBlanks]>0;

	(* Throw message *)
	If[blankStateWarning&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::BlankStateWarning,nonLiquidBlanks]
	];

	(* Create test *)
	blankStateWarningTest=If[gatherTests,
		Warning["The states of the blanks are Liquid:",blankStateWarning,False]
	];

	(* - Throw an error if the order of the injections are not correct. e.g. error out if it has a secondary injection without a primary injection. - *)

	(* Do the check only if we have any injection *)
	skippedInjectionError=If[Or[primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ],
		!((primaryInjectionsQ&&!secondaryInjectionQ&&!tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&!tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&tertiaryInjectionQ&&quaternaryInjectionQ)),
		False
	];

	(* Track invalid options *)
	injectionQList={primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ};

	injectionOptionList={PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume};

	skippedInjectionIndex=If[skippedInjectionError,
		Module[{lastTrueInjection},
			lastTrueInjection=First[Last[Position[injectionQList,True]]];
			Flatten[Position[injectionQList[[1;;lastTrueInjection]],False]]
		]
	];

	invalidSkippedInjection=If[skippedInjectionError,
		injectionOptionList[[#]]&/@skippedInjectionIndex
	];

	(* Throw message *)
	If[skippedInjectionError&&messages,
		Message[Error::SkippedInjectionError,invalidSkippedInjection,injectionOptionList[[Last[skippedInjectionIndex]+1]]]
	];

	(* Create test *)
	skippedInjectionErrorTest=If[gatherTests,
		Test["Primary, Secondary, Tertiary or Quaternary injections are specified in order without skipping:",skippedInjectionError,False]
	];

	(* check to ensure that the wrong volume wasn't provided *)
	blankVolumeNotAllowedInvalidOptions=If[MemberQ[blankVolumeNotAllowedErrors,True]&&messages,
		(
			Message[Error::BlankVolumeNotRecommended,Select[blankVolumes,#!=2.1*Microliter&],2.1*Microliter,instrument];
			{BlankVolumes,Instrument}
		),
		{}
	];

	(* generate the blankVolumeNotAllowed tests *)
	blankVolumeNotAllowedTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingBlankVolumes,
			passingBlankVolumes},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples=PickList[simulatedSamples,blankVolumeNotAllowedErrors];
			failingBlankVolumes=PickList[blankVolumes,blankVolumeNotAllowedErrors];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples=PickList[simulatedSamples,blankVolumeNotAllowedErrors,False];
			passingBlankVolumes=PickList[blankVolumes,blankVolumeNotAllowedErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
			(* deliberately NOT doing InputForm of the transposed list because InputForm doesn't play nicely with units *)
				Test["The following BlankVolumes for the corresponding samples:"<>ObjectToString[Transpose[{failingSamples,failingBlankVolumes}],Cache->cacheBall]<>" match the recommended volume for using "<>ObjectToString[instrument,Cache->cacheBall]<>":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
			(* deliberately NOT doing InputForm of the transposed list because InputForm doesn't play nicely with units *)
				Test["The following BlankVolumes for the corresponding samples:"<>ObjectToString[Transpose[{passingSamples,passingBlankVolumes}],Cache->cacheBall]<>" match the recommended volume for using "<>ObjectToString[instrument,Cache->cacheBall]<>":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		]
	];

	(* check to ensure that if QuantifyConcentration -> True, BlankAbsorbance is also True *)
	quantRequiresBlankingInvalidOptions=If[MemberQ[quantifyConcentrations,True]&&Not[blankAbsorbance]&&messages,
		(
			Message[Error::QuantificationRequiresBlanking];
			{QuantifyConcentration,BlankAbsorbance}
		),
		{}
	];

	(* generate tests for when quantification requires blanking *)
	(* Skip the test for AbsKinetics since it doesn't quantify *)
	quantRequiresBlankingTest=If[gatherTests&&!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Test["If QuantifyConcentration -> True for any sample, BlankAbsorbance is not False:",
			If[MemberQ[quantifyConcentrations,True],
				Not[MatchQ[blankAbsorbance,False]],
				True
			],
			True
		],
		Null
	];

	(* check to ensure that if QuantifyConcentration is True, QuantificationWavelength cannot be Null, and if it is False, it must be Null *)
	concInvalidOptions=If[MemberQ[concInvalidOptionsErrors,True]&&messages,
		(
			Message[Error::ConcentrationWavelengthMismatch,ToString[wavelengthOptionName],ObjectToString[PickList[simulatedSamples,concInvalidOptionsErrors],Cache->cacheBall]];
			{wavelengthOptionName,QuantifyConcentration}
		),
		{}
	];

	(* make the tests for the above error *)
	(* Skip the test for AbsKinetics since it doesn't quantify *)
	concInvalidOptionsTests=If[gatherTests&&!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,concInvalidOptionsErrors];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,concInvalidOptionsErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["The following sample(s):" <> ObjectToString[failingSamples, Cache -> cacheBall] <> " do not have either QuantifyConcentration -> False and " <> ToString[wavelengthOptionName] <> " or QuantificationAnalyte set, or QuantifyConcentration -> True and " <> ToString[wavelengthOptionName] <> " or QuantificationAnalyte -> Null:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["The following model(s) of the following sample(s):" <> ObjectToString[passingSamples, Cache -> cacheBall] <> "The following sample(s):" <> ObjectToString[failingSamples, Cache -> cacheBall] <> " do not have either QuantifyConcentration -> False and " <> ToString[wavelengthOptionName] <> " or QuantificationAnalyte set, or QuantifyConcentration -> True and " <> ToString[wavelengthOptionName] <> " or QuantificationAnalyte -> Null:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests; this can't come up at all if we are doing AbsorbanceIntensity so then just return {} always *)
			If[MatchQ[myType,Object[Protocol,AbsorbanceIntensity]],
				{},
				{passingSampleTests,failingSampleTests}
			]

		]
	];

	(* if we are quantifying but no wavelength was set and the ExtinctionCoefficients field is not populated, throw a warning *)
	If[MemberQ[extCoefficientNotFoundWarnings,True]&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::ExtCoeffNotFound,ObjectToString[PickList[simulatedSamples,extCoefficientNotFoundWarnings],Cache->cacheBall]]
	];

	(* make the warning tests *)
	(* Skip the test for AbsKinetics since it doesn't quantify *)
	extCoefficientNotFoundTests=If[gatherTests&&!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

		(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,extCoefficientNotFoundWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,extCoefficientNotFoundWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Warning["The following model(s) of the following sample(s):"<>ObjectToString[failingSamples,Cache->cacheBall]<>" have their ExtinctionCoefficients field populated:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Warning["The following model(s) of the following sample(s):"<>ObjectToString[passingSamples,Cache->cacheBall]<>" have their ExtinctionCoefficients field populated:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		]
	];

	(* throw an error if we need an extinction coefficient but one is missing *)
	missingExtinctionCoefficientOptions=If[MemberQ[missingExtCoefficientErrors,True]&&messages,
		(
			Message[Error::ExtinctionCoefficientMissing,ObjectToString[PickList[simulatedSamples,missingExtCoefficientErrors],Cache->cacheBall],ObjectToString[PickList[quantificationWavelengths,missingExtCoefficientErrors]]];
			{QuantifyConcentration,wavelengthOptionName}
		),
		{}
	];

	(* make a test for if we need to have the extinction coefficient populated *)
	missingExtinctionCoefficientOptionTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

		(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,missingExtCoefficientErrors];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,missingExtCoefficientErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["If quantifying concentration, ExtinctionCoefficients is populated for the desired wavelength, or can be calculated for the following sample(s)"<>ObjectToString[failingSamples,Cache->cacheBall]<>":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["If quantifying concentration, ExtinctionCoefficients is populated for the desired wavelength, or can be calculated for the following sample(s)" <> ObjectToString[passingSamples, Cache -> cacheBall] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		],
		Null
	];

	(* throw an error if the QuantificationAnalyte option isn't in the corresponding sample's composition *)
	sampleContainsAnalyteOptions = If[MemberQ[sampleContainsAnalyteErrors, True] && messages,
		(
			Message[Error::SampleMustContainQuantificationAnalyte, ObjectToString[PickList[simulatedSamples, sampleContainsAnalyteErrors], Cache -> cacheBall]];
			{QuantificationAnalyte}
		),
		{}
	];

	(* make a test for if we need to have the extinction coefficient populated *)
	sampleContainsAnalyteOptionTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, sampleContainsAnalyteErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, sampleContainsAnalyteErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["If QuantificationAnalyte is specified, it is contained in the Composition field of the following sample(s):" <> ObjectToString[failingSamples, Cache -> cacheBall] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["If QuantificationAnalyte is specified, it is contained in the Composition field of the following sample(s):" <> ObjectToString[passingSamples, Cache -> cacheBall] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		],
		Null
	];


	(* - Validate Moat options - *)
	(* We must first know total number of samples *)


	(* Figure out how many wells will be occupied by assay samples *)

	(* Do all the checks to make sure our moat options are valid *)
	{invalidMoatOptions,moatTests} = If[gatherTests,
		validMoat[totalNumSamples,aliquotContainerModelPacket,Join[absSpecOptionsAssoc,Association[samplePrepOptions]],Output->{Options,Tests}],
		{validMoat[totalNumSamples,aliquotContainerModelPacket,Join[absSpecOptionsAssoc,Association[samplePrepOptions]],Output->Options],{}}
	];

	(* No moat options for the Lunatic since it doesn't read samples in an SBS plate *)
	moatError=lunaticQ&&MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]];

	(* Throw a message if Moat is invalid *)
	If[moatError&&messages,Message[Error::PlateReaderMoatUnsupported,instrument]];

	(* Create test *)
	moatInstrumentTest=Test["If Moat is set the specified instrument is capable of controlling it",moatError,False];

	(* Track invalid options *)
	moatInstrumentInvalidOptions=If[moatError,
		Append[
			PickList[{MoatSize,MoatBuffer,MoatVolume},{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]],
			Instrument
		],
		{}
	];

	(* - Resolve Moat Options - *)

	impliedMoat=MatchQ[invalidMoatOptions,{}]&&MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]];

	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize} = resolveMoatOptions[
		myType,
		aliquotContainerModelPacket,
		specifiedMoatBuffer,
		specifiedMoatVolume,
		specifiedMoatSize
	];

	(* --- Resolve the rest of the Aliquot options --- *)

	(* - Resolve DestinationWells - *)

	suppliedDestinationWells=Lookup[samplePrepOptions,DestinationWell];

	(* Get all wells in the plate *)
	plateWells=AllWells[aliquotContainerModelPacket];

	(* Get wells that will be taken up by the moat *)
	moatWells=If[impliedMoat,
		getMoatWells[plateWells,resolvedMoatSize],
		{}
	];

	(* - Validate DestinationWell Option - *)
	(* Check whether the supplied DestinationWell have duplicated members. PlateReader experiment only allows one plate so we should not aliquot two samples into the same well. *)
	suppliedDestinationWellsNoAutomatic = DeleteCases[ToList[suppliedDestinationWells], Automatic | NullP];
	duplicateDestinationWells = Cases[Tally[suppliedDestinationWellsNoAutomatic], {well_, GreaterP[1]} :> well];

	duplicateDestinationWellError = !MatchQ[duplicateDestinationWells, {}] && MatchQ[resolvedMethods, PlateReader];
	duplicateDestinationWellOption = If[duplicateDestinationWellError && !gatherTests,
		Message[Error::PlateReaderDuplicateDestinationWell, ToString[DeleteDuplicates[duplicateDestinationWells]]];{DestinationWell},
		{}
	];
	duplicateDestinationWellTest=If[gatherTests,
		Test["The specified DestinationWell should not have duplicated members:",!duplicateDestinationWellError,True],
		{}
	];

	(* Check whether the supplied DestinationWell is the same length as samples with replicates. We cannot aliquot to the same well for duplicates. *)
	invalidDestinationWellLengthQ=If[!MatchQ[suppliedDestinationWells,{Automatic..}]&&MatchQ[preresolvedAliquot,{True..}],
		TrueQ[Length[suppliedDestinationWells]!=(intNumReplicates*Length[simulatedSamples])],
		False
	];
	invalidDestinationWellLengthOption=If[invalidDestinationWellLengthQ,
		Message[Error::InvalidDestinationWellLength,ToString[(intNumReplicates*Length[simulatedSamples])]];{DestinationWell},
		{}
	];
	invalidDestinationWellLengthTest=If[gatherTests,
		Test["The specified DestinationWell must be the same length as the number of all aliquots (the number of input samples multiplied by the specified NumberOfReplicates.",invalidDestinationWellLengthQ,False],
		{}
	];

	(* Try to resolve destination wells unless we know there's not enough room or we've detected overlap *)
	resolvedDestinationWells=If[MatchQ[suppliedDestinationWells,{Automatic..}]&&MatchQ[preresolvedAliquot,{True..}]&&!lunaticQ&&!cuvetteQ,
		Module[{readDirection,orderedWells,availableAssayWells},

			(* Re-order the wells based on read direction *)
			(* NOTE: changed to resolvedReadDirection from readDirection=Lookup[absSpecOptionsAssoc,ReadDirection] *)
			readDirection = resolvedReadDirection;
			orderedWells=Which[
				MatchQ[readDirection,Row],
				Flatten[plateWells],
				MatchQ[readDirection,Column],
				Flatten[Transpose[plateWells]],
				MatchQ[readDirection,SerpentineRow],
				Flatten[MapThread[
					If[OddQ[#2],#1,Reverse[#1]]&,
					{plateWells,Range[Length[plateWells]]}
				]],
				MatchQ[readDirection,SerpentineColumn],
				Flatten[MapThread[
					If[OddQ[#2],#1,Reverse[#1]]&,
					{Transpose[plateWells],Range[Length[Transpose[plateWells]]]}
				]]
			];


			(* Remove any moat wells from our possible wells - use DeleteCases to avoid rearranging *)
			availableAssayWells=DeleteCases[orderedWells,Alternatives@@moatWells];

			(* Use the first n wells *)
			If[Length[availableAssayWells]>=(intNumReplicates*Length[simulatedSamples]),
				Take[availableAssayWells,(intNumReplicates*Length[simulatedSamples])],
				suppliedDestinationWells
			]
		],
		suppliedDestinationWells
	];

	(* get the RequiredAliquotAmount. Note that this is different depending on if we're using the Lunatic or the BMG plate reader; part of the point of the Lunatic is using smaller amounts *)
	(* round to 0.1 Microliter precision to avoid rounding error when resolving aliquot options *)
	requiredAliquotAmounts=SafeRound[
		If[lunaticQ,
			ConstantArray[20*Microliter,Length[simulatedSamples]],

			Module[{injectionVolumesOption,injectionVolumesOptionTuples,totalInjectionVolume},
				injectionVolumesOption=Lookup[myOptions,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume},Null];
				(* in case we don't have some options, change the return to an appropriately sized list *)
				injectionVolumesOptionTuples=Transpose@Replace[injectionVolumesOption,Null->ConstantArray[Null,Length[simulatedSamples]],{1}];
				totalInjectionVolume=Total[# /. Null -> 0 Microliter] & /@injectionVolumesOptionTuples;
			MapThread[
				Module[{sampleVolume,containerMaxVolume,containerRecommendedFillVolume,defaultVolume},
					sampleVolume=Lookup[#1,Volume];
					containerMaxVolume=Lookup[
						FirstCase[
							Flatten[listedAliquotContainerPackets],
							ObjectP[Download[#2,Object]],
							<||>
						],
						MaxVolume,
						If[MatchQ[#2,ObjectReferenceP[{Object[Container],Model[Container]}]],
							Lookup[fetchPacketFromCache[#2,cacheBall],MaxVolume],
							300 Microliter
						]
					];
					containerRecommendedFillVolume=Lookup[
						FirstCase[
							Flatten[listedAliquotContainerPackets],
							ObjectP[Download[#2,Object]],
							<||>
						],
						RecommendedFillVolume,
						If[MatchQ[#2,ObjectReferenceP[{Object[Container],Model[Container]}]],
							Lookup[fetchPacketFromCache[#2,cacheBall],RecommendedFillVolume],
							Null
						]
					];
					(* if we have RecommendedFillVolume - use it, otherwise use MaxVolume *)
					defaultVolume=If[VolumeQ[containerRecommendedFillVolume],
						containerRecommendedFillVolume,
						containerMaxVolume
					];

					Min[Cases[{
						sampleVolume,
						defaultVolume
					},VolumeP]]
				]&,
				{samplePackets,requiredAliquotContainers,totalInjectionVolume}
			]]
		],
		0.1Microliter];

	(* make the AliquotWarningMessage value.  This sends the message indicating why we need to use specific kinds of containers *)
	aliquotWarningMessage=Which[
		lunaticQ,"because the given samples are in containers that are not compatible with the liquid handling method required to load the Lunatic chips.  You may set how much volume you wish to be aliquoted using the AliquotAmount option.",
		cuvetteQ,"because the given samples are in containers that are not compatible with the Spectrophotometer. You may set how much volume you wish to be aliquoted using the AliquotAmount option.",
		True,"because the given samples are in containers that are not compatible with the BMG plate readers. You may set how much volume you wish to be aliquoted using the AliquotAmount option."
	];

	(* resolve ConsolidateAliquots to True if using the lunatic, or False if using the BMGs *)
	resolvedConsolidateAliquots = Which[
		BooleanQ[suppliedConsolidateAliquots], suppliedConsolidateAliquots,
		lunaticQ, True,
		True, False
	];

	preresolvedAliquotOptions=ReplaceRule[myOptions,
		Join[
			{
				Aliquot->preresolvedAliquot,
				DestinationWell->resolvedDestinationWells,
				NumberOfReplicates->resolvedNumberOfReplicates,
				ConsolidateAliquots -> resolvedConsolidateAliquots
			},
			resolvedSamplePrepOptions
		]
	];

	(* resolve the aliquot options *)
	{resolvedAliquotOptions,resolveAliquotOptionsTests}=Quiet[If[gatherTests,
		resolveAliquotOptions[
			experimentFunction,
			Download[mySamples,Object],
			simulatedSamples,
			preresolvedAliquotOptions,
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->aliquotWarningMessage,
			Output->{Result,Tests}
		],
		{resolveAliquotOptions[
			experimentFunction,
			Download[mySamples,Object],
			simulatedSamples,
			preresolvedAliquotOptions,
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->aliquotWarningMessage,
			Output->Result],{}
		}
	],{Error::SolidSamplesUnsupported,Error::InvalidInput}];

	(* - Verify the sample volume and blank volume - *)
	(* Note: We will throw a warning, if a BlankVolume is not equal to the sample volume. *)
	(* Obtain all sample volumes: if the samples are aliquoted, take the aliquot amount *)
	sampleVolumes=If[MemberQ[Flatten[{Lookup[resolvedAliquotOptions,Aliquot]}],False],
		Lookup[samplePackets,Volume],
		Lookup[resolvedAliquotOptions,AssayVolume]
	];

	(* If we aren't aliquoting, samples are all required to be in one container *)
	assayContainerModelPacket=If[MatchQ[Lookup[resolvedAliquotOptions,Aliquot],{True..}],
		aliquotContainerModelPacket,
		FirstCase[sampleContainerModelPackets,PacketP[],<||>]
	];

	(* check that the specified sample volumes are sufficient *)
	sampleVolumesTooSmallQ = If[lunaticQ,
		Map[(# < 2 Microliter)&, sampleVolumes],
		Map[(# < Lookup[assayContainerModelPacket,RecommendedFillVolume,Null]/.{Null->50 Microliter})&, sampleVolumes]
	];

	tooSmallSampleVolumes=PickList[sampleVolumes,sampleVolumesTooSmallQ,True];

	tooSmallSamples=PickList[mySamples,Transpose[{Lookup[resolvedAliquotOptions,Aliquot],sampleVolumesTooSmallQ}],{False,True}];

	If[(Or@@sampleVolumesTooSmallQ)&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::AbsSpecInsufficientSampleVolume,
			tooSmallSampleVolumes,
			If[
				lunaticQ,
				2 Microliter,
				Lookup[assayContainerModelPacket,RecommendedFillVolume,Null]
			]
		]
	];

	(* create sample volume tests *)
	sampleVolumesTest=If[gatherTests,
		Warning["The specified input sample volumes (or AssayVolumes specified) are greater than the minimum required sample volume for the resolved instrument type.",Or@@sampleVolumesTooSmallQ,False],
		{}
	];

	sampleObjs=Lookup[samplePackets,Object];

	(* Track the invalid blank volumes *)
	(* Do this only if blankVolumes is not {}|Null and not a Lunatic*)
	{notEqualBlankVolumes,notEqualSamples}=Module[{notEqualVolumeQ},
		If[!MatchQ[blankVolumes,Null|{}]&&(!blankSpaceError)&&(!tooManySamplesError)&&(!lunaticQ),
			notEqualVolumeQ=Map[
				And[
					Not[Equal[sampleVolumes[[#]],blankVolumes[[#]]]],
					!MatchQ[Lookup[mapThreadFriendlyOptions,BlankVolumes][[#]],Automatic]
				]&,
				Range[Length[blankVolumes]]
			];
			{PickList[blankVolumes, notEqualVolumeQ],PickList[sampleObjs, notEqualVolumeQ]},
			{{},{}}
		]
	];

	notEqualBlankVolumesWarning=Length[notEqualBlankVolumes]>0;

	(* Throw message *)
	If[notEqualBlankVolumesWarning&&messages&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::NotEqualBlankVolumes,notEqualBlankVolumes,notEqualSamples]
	];

	(* Create test *)
	notEqualBlankVolumesWarningTest=If[gatherTests,
		Warning["The blank volume is equivalent to the index-matched sample volume:",notEqualBlankVolumesWarning,False]
	];

	(* - Validate the injection samples - *)
	(* These checks must be done after aliquot options are resolved because we need to know AssayVolume *)
	(* Run a series of tests to make sure our injection options are properly specified *)
	{invalidInjectionOptions,validInjectionTests}=Which[
		(* if we have the wrong instrument for the injections, don't check the rest of the injection issues since we assume that we do NOT want to inject in this protocol *)
		injectionInstrumentError, {{},{}},

		gatherTests,
		validPlateReaderInjections[myType,samplePackets,injectionSamplePackets,assayContainerModelPacket,ReplaceRule[Normal[absSpecOptionsAssoc],resolvedAliquotOptions],Output->{Result,Tests},Cache->cacheBall],

		True,
		{
			validPlateReaderInjections[myType,samplePackets,injectionSamplePackets,assayContainerModelPacket,ReplaceRule[Normal[absSpecOptionsAssoc],resolvedAliquotOptions],Cache->cacheBall],
			{}
		}
	];


	(* - Resolve MicrofluidicChipLoading - *)

	(* Resolve the MicrofluidicChipLoading based on which instrument we're using *)
	resolvedMicrofluidicChipLoading = If[lunaticQ,
		(* if using lunatic, we resolve to Robotic *)
		If[MatchQ[specifiedMicrofluidicChipLoading, Automatic],
			Robotic,
			specifiedMicrofluidicChipLoading
		],
		(* if not using lunatic, we resolve to Null *)
		If[MatchQ[specifiedMicrofluidicChipLoading, Automatic],
			Null,
			specifiedMicrofluidicChipLoading
		]
	];

	microfluidicChipLoadingErrorQ = Or[
		(* If Lunatic is being used but a number is provided *)
		And[lunaticQ,MatchQ[resolvedMicrofluidicChipLoading,Null]],
		(* Or we're not using the lunatic and Null is specified *)
		And[!lunaticQ,MatchQ[resolvedMicrofluidicChipLoading,Except[Null]]]
	];

	If[microfluidicChipLoadingErrorQ&&messages,
		Message[Error::MicrofluidicChipLoading,resolvedMicrofluidicChipLoading]
	];

	(* Create test *)
	microfluidicChipLoadingErrorTest = If[gatherTests,
		Test["The MicrofluidicChipLoading option setting complies with the plate reader used in this experiment:",{lunaticQ,microfluidicChipLoadingErrorQ},Except[{True,Null}|{False,Alternatives[Robotic,Manual]}]]
	];

	(* Track invalid option *)
	microfluidicChipLoadingInvalidOptions = If[microfluidicChipLoadingErrorQ,MicrofluidicChipLoading];

	(* -- Resolve label options -- *)
	resolvedSampleLabels=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[mySamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["absorbance sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[roundedOptionsAssoc, SampleLabel]}
		]
	];

	resolvedSampleContainerLabels=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["absorbance sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[roundedOptionsAssoc, SampleContainerLabel]}
		]
	];

	resolvedBlankLabels = Module[{suppliedBlankObjects, uniqueBlankVolumeTuples, preResolvedUniqueBlankLabels, preResolvedBlankLabelRules},
		suppliedBlankObjects = Download[blanks,Object];
		(* take volume into consideration when identifying if a blank is unique or not, blankVolumes here is always index matched to blanks so we should be good *)
		(* this is the same logic as in blankVolumeLabelTuples and blankVolumeTuples *)
		uniqueBlankVolumeTuples = DeleteDuplicates[Cases[Transpose[{suppliedBlankObjects, blankVolumes}], {ObjectP[], _}]];
		preResolvedUniqueBlankLabels = Table[CreateUniqueLabel["blank sample"], Length[uniqueBlankVolumeTuples]];
		preResolvedBlankLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueBlankVolumeTuples, preResolvedUniqueBlankLabels}
		];

		MapThread[
			Function[{blankObject, blankVolume, blankLabel},
				Which[
					MatchQ[blankLabel, Except[Automatic]],
						blankLabel,
					MatchQ[blankObject, Null],
						Null,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[blankObject, Object]], _String],
						LookupObjectLabel[simulation, Download[blankObject, Object]],
					True,
						Replace[{blankObject, blankVolume}, preResolvedBlankLabelRules]
				]
			],
			{suppliedBlankObjects, blankVolumes, Lookup[roundedOptionsAssoc, BlankLabel]}
		]
	];

	(* --- Throw error if user is trying to set more than one blank types for cuvette --- *)
	{tooManyBlanksError, tooManyBlanksOptions} = If[Length[DeleteDuplicates[resolvedBlankLabels]] > 1 && cuvetteQ,
		{True, {Blanks, BlankVolumes}},
		{False, {}}
	];

	(* throw messages *)
	If[tooManyBlanksError && messages,
		Message[Error::TooManyBlanks, blanks]
	];

	(* make test *)
	tooManyBlanksTest = If[gatherTests,
		Test["Number of blanks do not exceed 1 when using Cuvette method:", tooManyBlanksError, False]
	];

	(* --- pull out all the shared options from the input options --- *)

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* get the resolved Email option; for this experiment, the default is True *)
	email=If[MatchQ[Lookup[myOptions,Email],Automatic],
		True,
		Lookup[myOptions,Email]
	];

	(* Invalid input checks *)
	(* combine all the invalid options together *)
	invalidOptions=DeleteCases[
		DeleteDuplicates[Flatten[{
			validInstrumentOption,
			compatibleMaterialsInvalidOption,
			nameInvalidOptions,
			blanksInvalidOptions,
			readDirectionInvalidOptions,
			injectionInstrumentInvalidOptions,
			invalidCoverOption,
			invalidOrderOption,
			invalidWavelengthOption,
			methodsInstrumentIncompatibleOptions,
			spectralBandwidthIncompatibleInvalidOptions,
			acquisitionMixIncompatibleInvalidOptions,
			acquisitionMixDependentOptionsInvalidOptions,
			mismatchingAcquisitionMixRateOptions,
			mismatchCuvettePlateReaderOptions,
			mismatchCuvetteMoatOptions,
			mismatchCuvettePlateSamplingOptions,
			plateReaderMixOptionInvalidities,
			badAliquotContainerOptions,
			badTotalVolumeOptions,
			invalidLunaticMixOptions,
			moatInstrumentInvalidOptions,
			invalidMoatOptions,
			badContainerOutOptions,
			plateReaderNumberOfReadingsInvalidOptions,
			temperatureIncompatibleInvalidOptions,
			tooManySamplesOptions,
			tooManyBlanksOptions,
			incompatibleBlankVolumesInvalidOptions,
			incompatibleBlankInvalidOptions,
			invalidSkippedInjection,
			blankVolumeNotAllowedInvalidOptions,
			quantRequiresBlankingInvalidOptions,
			missingExtinctionCoefficientOptions,
			concInvalidOptions,
			microfluidicChipLoadingInvalidOptions,
			missingExtinctionCoefficientOptions,
			duplicateDestinationWellOption,
			invalidDestinationWellLengthOption,
			invalidAliquotOption,
			invalidInjectionOptions,
			invalidSamplingOptions,
			If[MatchQ[preparationResult, $Failed],
				{Preparation},
				{}
			],
			resolvedACUInvalidOptions
		}]],
		Null
	];

	(* if there are any invalid options, throw Error::InvalidOption *)
	If[Not[MatchQ[invalidOptions,{}]]&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* combine all the invalid inputs together *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,nonLiquidSampleInvalidInputs}]];

	(* if there are any invalid inputs, throw Error::InvalidInput *)
	If[Not[MatchQ[invalidInputs,{}]]&&messages,
		Message[Error::InvalidInput,invalidInputs]
	];

	(* - Resolve Remaining Sampling Options - *)

	(* SamplingDistance *)

	(* Figure out the container that will go into the plate reader to determine well diameter *)
	(* If we aren't aliquoting, samples are all required to be in one container *)
	assayContainerModelPacket=If[MatchQ[Lookup[resolvedAliquotOptions,Aliquot],{True..}],
		aliquotContainerModelPacket,
		FirstCase[sampleContainerModelPackets,PacketP[],<||>]
	];

	(* Resolve to Null if SamplingPattern->Center, else to 80% of the well diameter *)
	resolvedSamplingDistance=Switch[{resolvedSamplingPattern,suppliedSamplingDistance},
		{Null,_},Null,
		{_,Except[Automatic]},suppliedSamplingDistance,
		{Center,_},Null,
		(* Use 80% of the well diameter, but make sure that's within the bounds allowed by BMG *)
		_,Clip[SafeRound[Lookup[assayContainerModelPacket,WellDiameter]*.8,1 Millimeter],{1 Millimeter,6 Millimeter}]
	];

	(* Use BMG's default if we're doing Matrix scanning otherwise this should be Null *)
	resolvedSamplingDimension=Switch[{resolvedSamplingPattern,suppliedSamplingDimension},
		{_,Except[Automatic]},suppliedSamplingDimension,
		{Matrix,_},3,
		_,Null
	];

	(* --- Combine the resolved options and tests together --- *)

	(* Get wavelength specification after rounding *)
	roundedWavelengths=Lookup[roundedOptionsAssoc,Wavelength];

	(* Finalize wavelength resolution *)
	resolvedWavelengths=Which[
		(* AbsSpec/AbsIntensity have already resolved *)
		!MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],quantificationWavelengths,

		(* Use user value *)
		(* TODO the default of the AbsorbanceKinetics is All. Why do we even bother doing this? *)
		!MatchQ[roundedWavelengths,Automatic],roundedWavelengths,

		(* Read the full spectrum whenever possible *)
		MatchQ[specifiedReadOrder,Parallel]&&!MatchQ[resolvedSamplingPattern,Matrix],All,

		(* In Serial mode, can only read one wavelength so pick one of the extinction coefficient wavelengths *)
		MatchQ[specifiedReadOrder,Serial],FirstOrDefault[preferredWavelengths]/.{Null->260*Nanometer},

		(* In Matrix SamplingPattern, can only read up to 8 discrete wavelengths *)
		MatchQ[resolvedSamplingPattern,Matrix],PadRight[Sort[DeleteDuplicates[preferredWavelengths]],8,Nothing],

		(* We should never get here but just in case we do, give a default *)
		True,260*Nanometer
	];

	(* get the final resolved options, pre-collapsed (that is only happening outside this function) *)
	resolvedOptions=ReplaceRule[
		(* Recreate full set of options - necessary since we're using Append->False *)
		Join[Normal[roundedOptionsAssoc],samplePrepOptions],
		Join[
			{
				Methods -> resolvedMethods,
				Instrument->instrument,
				Temperature->temperature,
				TemperatureMonitor -> resolvedTemperatureMonitor,
				SpectralBandwidth->resolvedSpectralbandwidth,
				AcquisitionMix->resolvedAcquisitionMix,
				StirBar->resolvedCuvetteStirBars,
				AcquisitionMixRate->resolvedAcquisitionMixRate,
				MinAcquisitionMixRate->resolvedMinAcquisitionMixRate,
				MaxAcquisitionMixRate->resolvedMaxAcquisitionMixRate,
				AcquisitionMixRateIncrements->resolvedAcquisitionMixRateIncrements,
				MaxStirAttempts->resolvedMaxStirAttempts,
				AdjustMixRate->resolvedAdjustMixRate,
				RetainCover->resolvedRetainCover,
				EquilibrationTime->temperatureEquilibriumTime,
				ReadDirection->resolvedReadDirection,
				PrimaryInjectionFlowRate->resolvedPrimaryFlowRate,
				SecondaryInjectionFlowRate->resolvedSecondaryFlowRate,
				TertiaryInjectionFlowRate->resolvedTertiaryFlowRate,
				QuaternaryInjectionFlowRate->resolvedQuaternaryFlowRate,
				MoatBuffer->resolvedMoatBuffer,
				MoatVolume->resolvedMoatVolume,
				MoatSize->resolvedMoatSize,
				QuantifyConcentration->quantifyConcentrations,
				wavelengthOptionName->resolvedWavelengths,
				QuantificationAnalyte -> quantificationAnalytes,
				BlankAbsorbance->blankAbsorbance,
				Blanks->blanks,
				BlankVolumes->blankVolumes,
				ContainerOut -> resolvedContainersOut,
				RecoupSample -> resolvedRecoupSamples,
				SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
				NumberOfReplicates->resolvedNumberOfReplicates,
				PlateReaderMix->resolvedPlateReaderMix,
				PlateReaderMixRate->resolvedPlateReaderMixRate,
				PlateReaderMixTime->resolvedPlateReaderMixTime,
				PlateReaderMixMode->resolvedPlateReaderMixMode,
				PlateReaderMixSchedule->resolvedPlateReaderMixSchedule,
				SamplingDistance -> resolvedSamplingDistance,
				SamplingPattern -> resolvedSamplingPattern,
				SamplingDimension -> resolvedSamplingDimension,
				NumberOfReadings -> resolvedNumberOfReadings,
				MicrofluidicChipLoading -> resolvedMicrofluidicChipLoading,
				SampleLabel->resolvedSampleLabels,
				SampleContainerLabel->resolvedSampleContainerLabels,
				BlankLabel->resolvedBlankLabels,
				Preparation->resolvedPreparation,
				WorkCell->resolvedWorkCell,
				Name->name,
				Email->email
			},
			resolvedACUOptions,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		],
		(* If one of our replacements isn't in our original set of options, this means it's experiment specific, so just drop it here by using Append->False *)
		Append->False
	];

	(* combine all the tests together  *)
	allTests=Cases[
		Flatten[{
			validSamplingComboTest,
			validSamplingInstrumentTest,
			validSamplingModeTest,
			discardedTest,
			supportedInstrumentTests,
			precisionTests,
			preparationTest,
			validNameTest,
			blanksInvalidTest,
			aliquotContainerTest,
			replicatesAliquotTest,
			sampleRepeatTest,
			blankSpaceTest,
			readDirectionTest,
			injectionInstrumentTest,
			retainCoverTest,
			injectionSampleStateErrorTest,
			invalidCoverInstrumentTest,
			orderTest,
			wavelengthTest,
			methodsInstrumentIncompatibleTest,
			spectralBandwidthIncompatibleTest,
			acquisitionMixIncompatibleTest,
			acquisitionMixDependentOptionsIncompatibleTest,
			mismatchingAcquisitionMixRateTests,
			mismatchCuvettePlateReaderTest,
			mismatchCuvetteMoatTest,
			mismatchCuvettePlateSamplingTest,
			badAliquotContainerTests,
			badTotalVolumeTests,
			nonLiquidSampleTest,
			plateReaderMixTests,
			moatInstrumentTest,
			lunaticMixTest,
			moatTests,
			tooFewReplicatesTest,
			tooManySamplesTest,
			tooManyBlanksTest,
			badContainerOutTests,
			plateReaderTemperatureNoEquilibrationTest,
			plateReaderNumberOfReadingsErrorTest,
			blankContainerErrorTest,
			temperatureIncompatibleTest,
			incompatibleBlankOptionTests,
			skippedInjectionErrorTest,
			blankVolumeNotAllowedTests,
			quantRequiresBlankingTest,
			resolveSamplePrepTests,
			resolveAliquotOptionsTests,
			compatibleMaterialsTests,
			missingExtinctionCoefficientOptionTests,
			extCoefficientNotFoundTests,
			concInvalidOptionsTests,
			duplicateDestinationWellTest,
			invalidDestinationWellLengthTest,
			sampleContainsAnalyteOptionTests,
			potentialAnalyteTests,
			validInjectionTests,
			sampleVolumesTest,
			microfluidicChipLoadingErrorTest,
			resolvedACUTests
		}],
		_EmeraldTest
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}

];



(* ::Subsubsection:: *)
(*selectAnalyteFromSample (private helper)*)


DefineOptions[selectAnalyteFromSample,
	Options :> {
		{Analyte -> Automatic, Automatic | {(ObjectP[List @@ IdentityModelTypeP] | Null | Automatic)..},"The substance already specified as the analyte for this sample."},
		{DetectionMethod -> Automatic, Automatic | Absorbance,"The method used to detect the analyte, the program will try to find a molecule in the sample that has information populated to be used with this detection method"},
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

Warning::AmbiguousAnalyte="The desired analyte for sample(s) `1` is ambiguous because its Analytes or Composition fields contain multiple identity models that could be the desired analyte. Setting to `2`.";

(* if Analytes field is populated, pick the first value there *)
(* if Analytes field is not populated, pick the first analyte-like identity model in the Composition field *)
(* if there is no analyte-like identity model in the Composition field, pick the first identity model of any kind in the Composition field *)
(* otherwise, pick Null *)
selectAnalyteFromSample[mySample:ObjectP[{Object[Sample], Model[Sample]}], ops:OptionsPattern[]]:=selectAnalyteFromSample[{mySample}, ops];
selectAnalyteFromSample[mySamples:{ObjectP[{Object[Sample], Model[Sample]}]..}, ops:OptionsPattern[]]:=Module[
	{
		safeOps,cache,allPackets,analyteP,analytesToUse,analyteObjs,compositionObjs,ambiguousQ,output,nonWaterP,
		outputSpecification,gatherTests,messages,ambiguousResultWarning,specifiedAnalytes,expandedSpecifiedAnalytes,
		detectionMethod,extinctionCoefficientsPerComposition,componentToExtinctionCoefficient},

	(* get the Cache and Output options *)
	safeOps = SafeOptions[selectAnalyteFromSample, ToList[ops]];
	{cache, outputSpecification, specifiedAnalytes, detectionMethod, simulation} = Lookup[safeOps, {Cache, Output, Analyte, DetectionMethod, Simulation}];

	(* expand specifiedAnalytes to be the same length as mySamples if it is not already *)
	expandedSpecifiedAnalytes = If[MatchQ[specifiedAnalytes, Automatic],
		ConstantArray[Automatic, Length[mySamples]],
		specifiedAnalytes
	];

	(* figure out whether to gather the tests and throw messages *)
	output = ToList[outputSpecification];
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get the composition and analytes fields from all the input samples or models *)
	{allPackets,extinctionCoefficientsPerComposition} = Transpose@Quiet[
		Download[
			mySamples,
			{
				Packet[Analytes,Composition,Solvent],
				Composition[[All,2]][ExtinctionCoefficients]
			},
			Cache->cache,
			Simulation->simulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::MissingField,Download::MissingCacheField}
	];

	(* get the analyte objects and the composition objects *)
	analyteObjs = Download[Lookup[#, Analytes], Object]& /@ allPackets;
	compositionObjs = Download[Lookup[#, Composition][[All, 2]], Object]& /@ allPackets;
	(* build an association of the Model[Molecule]->ExtinctionCoefficients *)
	componentToExtinctionCoefficient = Association[Rule@@@Transpose[{Flatten[compositionObjs,1],Flatten[extinctionCoefficientsPerComposition,1]}]];

	(* hard-coded list of types that are analyte-like *)
	analyteP = ObjectP[{Model[Molecule, cDNA], Model[Molecule, Oligomer], Model[Molecule, Transcript], Model[Molecule, Protein], Model[Molecule, Protein, Antibody], Model[Molecule, Carbohydrate], Model[Lysate], Model[Cell]}];

	(* pattern for non-water identity model *)
	(* note that this id is Model[Molecule, "Water"] *)
	nonWaterP = Except[ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]], IdentityModelP];

	(* decide whether the analyte choices are ambiguous (i.e., more than one object in Analytes, or more than one analyte-like object, or more than one non-analyte-object *)
	(* if it was already specified then just skip everything *)
	ambiguousQ = MapThread[
		Function[{composition, analytes, specifiedAnalyte},
			And[
				MatchQ[specifiedAnalyte, Automatic],
				Or[
					MatchQ[analytes, {IdentityModelP..}] && Length[DeleteDuplicates[analytes]] > 1,
					MatchQ[analytes, {}] && Length[Cases[composition, analyteP]] > 1,
					MatchQ[analytes, {}] && Length[Cases[composition, analyteP]] == 0 && Length[Cases[composition, nonWaterP]] > 1
				]
			]
		],
		{compositionObjs, analyteObjs, expandedSpecifiedAnalytes}
	];

	(* parse the Analytes and Composition fields to find the correct analytes to use *)
	analytesToUse = MapThread[
		Function[{composition, analytes, specifiedAnalyte, samplePacket},
			Module[{noSolventWaterComposition,extinctionCoefficientBools},

				noSolventWaterComposition = DeleteCases[
					Cases[compositionObjs,nonWaterP],
					Download[Lookup[samplePacket,Solvent,Null],Object]
				];
				extinctionCoefficientBools=Map[
					MatchQ[Lookup[componentToExtinctionCoefficient,#,Null],Except[{}|$Failed|Null]]&,
					noSolventWaterComposition];

				Which[
					Not[MatchQ[specifiedAnalyte,Automatic]],specifiedAnalyte,
					MatchQ[analytes,{IdentityModelP..}],First[analytes],

					(* for absorbance, go through composition, pull out their ExtinctionCoefficients and pick the first one that is not water/Solvent *)
					And[
						MatchQ[detectionMethod,Absorbance],
						MemberQ[extinctionCoefficientBools,True]
					],
					First@PickList[noSolventWaterComposition,extinctionCoefficientBools],

					MemberQ[composition,analyteP],FirstCase[composition,analyteP,Null],
					(* basically saying pick any identity model except for water if you can *)
					MemberQ[composition,nonWaterP],FirstCase[composition,nonWaterP],
					True,FirstCase[composition,IdentityModelP,Null]
				]
		]],
		{compositionObjs, analyteObjs, expandedSpecifiedAnalytes, allPackets}
	];

	(* throw a warning if analyte selection is ambiguous *)
	If[MemberQ[ambiguousQ, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AmbiguousAnalyte, ObjectToString[PickList[mySamples, ambiguousQ], Cache -> cache, Simulation -> simulation], ObjectToString[PickList[analytesToUse, ambiguousQ], Cache -> cache, Simulation -> simulation]]
	];

	(* If we are gathering tests, create a passing and/or failing warning test with the appropriate result. *)
	ambiguousResultWarning = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[MemberQ[ambiguousQ, True],
				Warning["Provided sample(s) " <> ObjectToString[PickList[mySamples, ambiguousQ], Cache -> cache, Simulation -> simulation] <> " contains only one identity model in its Analyte or Composition fields:", True, False],
				Nothing
			];

			passingTest = If[MemberQ[ambiguousQ, False],
				Warning["Provided sample(s) " <> ObjectToString[Complement[mySamples, PickList[mySamples, ambiguousQ]], Cache -> cache, Simulation -> simulation] <> " contains only one identity model in its Analyte or Composition fields:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	outputSpecification /. {Result -> analytesToUse, Tests -> ambiguousResultWarning}

];



(* ::Subsubsection:: *)
(*absorbanceResourcePackets (private helper) *)


(* private function to generate the list of protocol packets containing resource blobs *)
absorbanceResourcePackets[myType : (Object[Protocol, AbsorbanceSpectroscopy] | Object[Protocol, AbsorbanceIntensity] | Object[Protocol, AbsorbanceKinetics]), mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}] := Module[
	{expandedResolvedOptions,outputSpecification,output,gatherTests,messages,numReplicates,samplesInWithReplicates,
	lunaticQ,instrumentOpt,injectionObjects,uniqueInjectionSamples,resolvedBlanks,blanksWithReplicates,blankVolumesWithReplicates, blankPackets,
	resolvedBlankVolumesFinal,resolvedBlankLabels,blankAbsorbance,maxNumBlankPlates,blankContainerModel,blankContainersResources,
	microfluidicChipRackResource,manualLoadingPipetteResource,manualLoadingTipsResource,
	listedInstrumentPackets,instrumentModelPacket,instrumentModel,wavelengths,wavelengthsWithReplicates,quantConcsWithReplicates,
	resolvedOptionsNoHidden,previewRule,optionsRule,testsRule,resultRule,allResourceBlobs,fulfillable,frqTests,
	expandedInputs,containerPackets,plateModels,injectionContainers,injectionContainerModels,
	quantAnalytesWithReplicates,injectionContainerLookup,containerModelLookup,aliquotQ,sampleVolumes,
	cache,sampleVolumeRules,sampleResourceReplaceRules,samplesInResources,maxVolumeContainerModelPackets,downloadedInjectionValues,
	blankContainerModelPackets,blankContainerModelPacket,numOccupiedWells,
	cuvetteQ,acquisitionMixQ,cuvettes,containerObjsWithReplicates,cuvetteMaxVolumes,cuvetteModelMaxVolumes,cuvetteResources,cuvetteRackResource,
	cuvetteWasherResource,blowGunResource,referenceCuvetteResource,temperatureMonitor,temperatureProbeResource,stirBarResource,stirBarRetrieverResource,
	recoupSampleBoolean,containersOut,containersOutWithReplicates,containersOutResources, samplesOutWithNumReplicates,
	microfluidicChipResources,magnifyingGlassResource,containersIn,estimatedReadingTime,controlResource,allBlankResources,
	numReplicatesNoNull,expandReplicatesFunction,finalizedPacket,pairedSamplesInAndVolumes,
	aliquotQWithReplicates,aliquotVolumeWithReplicates,simulatedSamples,updatedSimulation,
	listedSimulatedContainerPackets,listedSampleContainers,simulatedContainerPackets,containerObjs,
	expandedSamplesInStorage,populateInjectionFieldFunction,primaryInjections,
	secondaryInjections,tertiaryInjections,quaternaryInjections,injectionSampleVolumeAssociation,allowedInjectionContainers,
	injectionSampleToResourceLookup,primaryInjectionWithResources,secondaryInjectionsWithResources,tertiaryInjectionsWithResources,
	quaternaryInjectionsWithResources,anyInjectionsQ,numberOfInjectionContainers,washVolume,
	line1PrimaryPurgingSolvent,line2PrimaryPurgingSolvent, line1SecondaryPurgingSolvent,line2SecondaryPurgingSolvent, injectorCleaningFields,
	wavelengthOptionName,wavelengthFieldName,experimentFunction,primitiveHead,simulation,
	resolvedPreparation,nonHiddenOptions,sampleLabelsWithReplicates,blankLabelsWithReplicates,unitOperationPackets,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,resourcesOk,resourceTests},

	(* get the experiment function that we care about *)
	{experimentFunction,primitiveHead} = Switch[myType,
		Object[Protocol, AbsorbanceSpectroscopy], {ExperimentAbsorbanceSpectroscopy,AbsorbanceSpectroscopy},
		Object[Protocol, AbsorbanceIntensity], {ExperimentAbsorbanceIntensity,AbsorbanceIntensity},
		Object[Protocol, AbsorbanceKinetics], {ExperimentAbsorbanceKinetics,AbsorbanceKinetics}
	];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[experimentFunction, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		experimentFunction,
		RemoveHiddenOptions[experimentFunction, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list (and also the cache) *)
	{outputSpecification, cache, simulation} = Lookup[expandedResolvedOptions, {Output, Cache, Simulation}];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Instrument option *)
	instrumentOpt = Lookup[expandedResolvedOptions, Instrument];

	(* Get unique list of all samples to be injected *)
	injectionObjects=DeleteCases[Flatten[Lookup[expandedResolvedOptions,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null],1],Null];
	uniqueInjectionSamples=Download[Cases[injectionObjects,ObjectP[Object]],Object];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[experimentFunction, mySamples, myResolvedOptions, Cache -> cache, Simulation->simulation];

	(* pull out the resolved BlankAbsorbance, Blanks, and BlankVolumes options *)
	{blankAbsorbance, resolvedBlanks, resolvedBlankVolumesFinal, resolvedBlankLabels} = Lookup[expandedResolvedOptions, {BlankAbsorbance, Blanks, BlankVolumes, BlankLabel}];

	(* make a Download call to get the sample, container, and instrument packets *)
	{listedSimulatedContainerPackets, listedSampleContainers, listedInstrumentPackets, maxVolumeContainerModelPackets,downloadedInjectionValues, blankPackets} = Quiet[
		Download[
			{
				simulatedSamples,
				mySamples,
				{instrumentOpt},
				Flatten[{validModelsForLunaticLoading[], BMGCompatiblePlates[Absorbance], absorbanceAllowedCuvettes}],
				uniqueInjectionSamples,
				resolvedBlanks
			},
			{
				{Packet[Container[Model]]},
				{Container[Object]},
				{Packet[Model]},
				{Packet[MaxVolume]},
				{Container[Object],Container[Model][Object]},
				{Packet[Volume, Container]}
			},
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* extract out the packets *)
	simulatedContainerPackets = Flatten[listedSimulatedContainerPackets];
	containerObjs = Flatten[listedSampleContainers];
	instrumentModelPacket = listedInstrumentPackets[[1, 1]];

	(* Get the instrument model *)
	instrumentModel = If[MatchQ[instrumentOpt, ObjectP[{Model[Instrument, PlateReader],Model[Instrument, Spectrophotometer]}]],
		instrumentOpt,
		Lookup[instrumentModelPacket, Model]
	];

	(* get the blank container model packets *)
	blankContainerModelPackets = Flatten[maxVolumeContainerModelPackets];

	(* get the plate models that we are currently in; don't need to check for validity because that already happened in the options function *)
	plateModels = Map[
		If[MatchQ[#, PacketP[]],
			Lookup[#, Model],
			Null
		]&,
		containerPackets
	];

	(* Get the injection containers and their models *)
	{injectionContainers,injectionContainerModels}={downloadedInjectionValues[[All,1]],downloadedInjectionValues[[All,2]]};

	(* Create lookups that will give container for each injection sample, model for each injection container *)
	injectionContainerLookup=AssociationThread[uniqueInjectionSamples,injectionContainers];
	containerModelLookup=AssociationThread[injectionContainers,injectionContainerModels];

	(* figure out if we are using the Lunatic or not *)
	lunaticQ = MatchQ[instrumentModel,ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)]];

	(* figure out if we are using the Cary 3500 or not *)
	cuvetteQ = MatchQ[instrumentModel,ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"](* Cary 3500 *)]];

	(* figure out if we are mixing with the Cary 3500 or not *)
	acquisitionMixQ = If[cuvetteQ,
		TrueQ[#]& /@ Lookup[expandedResolvedOptions, AcquisitionMix],
		Null
		];

	(* figure out if we are aliquoting or not *)
	aliquotQ = TrueQ[#]& /@ Lookup[expandedResolvedOptions, Aliquot];

	(* --- Make resources for SamplesIn --- *)

	(* get the number of replicates *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates];
	numReplicatesNoNull = numReplicates /. {Null -> 1};

	expandReplicatesFunction[value_]:=Flatten[
		ConstantArray[#,numReplicatesNoNull]&/@value
	];

	(* get the SamplesIn accounting for the number of replicates *)
	samplesInWithReplicates = expandReplicatesFunction[Download[mySamples, Object]];

	(* get aliquotQ index matched with the SamplesIn with replicates *)
	aliquotQWithReplicates = expandReplicatesFunction[aliquotQ];

	(* get the aliquotVolume with replicates *)
	aliquotVolumeWithReplicates = expandReplicatesFunction[Lookup[expandedResolvedOptions, AliquotAmount]];

	(* get the sample volumes we need to reserve with each sample, accounting for the number of replicates, whether we're aliquoting, and whether we're using the lunatic *)
	sampleVolumes = MapThread[
		Function[{aliquot, volume},
			Which[
				aliquot, volume,
				lunaticQ, 2.1 * Microliter,
				True, Null
			]
		],
		{aliquotQWithReplicates, aliquotVolumeWithReplicates}
	];

	(* make rules correlating the volumes with each sample in *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, sampleVolumes}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the samples and its resources *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
			]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesInWithReplicates, sampleResourceReplaceRules, {1}];

	(* expand the containerObjs according to the NumberOfReplicates *)
	containerObjsWithReplicates=If[cuvetteQ,
		Flatten[Map[
			ConstantArray[#, numReplicatesNoNull]&,
			containerObjs
			],1],
		Null
	];


	(* extract the containers we're going to aliquot into from the AliquotContainer option *)
	(* if we're not aliquotting, then the cuvette is the container that the sample is currently in *)
	cuvettes=If[cuvetteQ,
		MapThread[
			If[NullQ[#1],
				First[Flatten[{#2}]],
				#1[[2]]
			]&,
			{Lookup[expandedResolvedOptions, AliquotContainer],containerObjsWithReplicates}
		],
		Null
	];

	{cuvetteMaxVolumes, cuvetteModelMaxVolumes} = If[cuvetteQ,
		Transpose[Quiet[Download[cuvettes, {MaxVolume, Model[MaxVolume]},Simulation->updatedSimulation,Cache->cache], {Download::FieldDoesntExist, Download::NotLinkField}]],
		{Null, Null}
	];

	(*

	blankVolumes = MapThread[
		If[VolumeQ[#1],
			#1,
			#2
		]&,
		{cuvetteMaxVolumes, cuvetteModelMaxVolumes}
	];

	*)

	(* Make the resources for the cuvettes *)
	cuvetteResources = If[cuvetteQ,
		MapThread[
			Which[
				NullQ[#1],
				Null,
				!NullQ[#2],
				(* Note that we don't give Cuvettes resources if they are Aliquot containers as they will be picked in the subprotocol. We will update the protocol field properly at compiler time. *)
				Link[#1],
				True,
				Link[Resource[Sample->#1, Name->ToString[Unique[]], Rent->True]]
			]&,
			{cuvettes,Lookup[expandedResolvedOptions, AliquotContainer]}
		],
		Null
	];

	(* Set up resource object for cuvette rack *)
	cuvetteRackResource = If[cuvetteQ,
		Resource[Sample -> Model[Container, Rack, "12-position Bel-Art Cuvette rack"], Rent -> True],
		Null
	];

	(* get the containers in from the sample's containers *)
	containersIn = DeleteDuplicates[containerObjs];

	(* Set up resource object for the instrument we will be using (spectrophotometer, cuvette washer and blowgun for drying) *)
	cuvetteWasherResource = If[cuvetteQ,
		Resource[Instrument->Model[Instrument, CuvetteWasher, "Cuvette washer"], Time-> 1 Minute * Length[mySamples]],
		Null
	];

	blowGunResource = If[cuvetteQ,
		Resource[Instrument -> Model[Instrument, BlowGun, "id:rea9jl1GaVeB"], Time -> 0.5 Minute * Length[mySamples]],
		Null
	];

	(* make resources for the reference cuvette and the temperature probe (if we are using a temperature probe) *)
	referenceCuvetteResource = If[cuvetteQ,
		Resource[Sample -> Model[Container, Cuvette, "Standard Scale Cappless Frosted UV Quartz Cuvette"], Rent -> True],
		Null
	];

	(* lookup temperature monitor *)
	temperatureMonitor = If[cuvetteQ,
		Lookup[myResolvedOptions, TemperatureMonitor],
		Null
	];

	temperatureProbeResource = If[cuvetteQ,
		If[MatchQ[temperatureMonitor, ImmersionProbe],
			Resource[Sample -> Model[Part, TemperatureProbe, "Cary 3500 Temperature Probe"]],
			Null
		],
		Null
	];

	(* make resources for the stir bars if we are using the cary 3500  *)
	stirBarResource = If[MemberQ[acquisitionMixQ,True],
		Map[
			If[NullQ[#],
				Null,
				Resource[Sample->#, Name->ToString[Unique[]], Rent->True]
			]&,
			Lookup[expandedResolvedOptions, StirBar]
		],
		Null
	];

	(* make resources for the stir bars retriever if we   *)
	stirBarRetrieverResource = If[MemberQ[acquisitionMixQ,True],
		Link[Resource[Sample->Model[Part, StirBarRetriever, "id:eGakldJlXP1o"],Rent->True]],
		Null
	];

	(* Generate ContainerOut resources *)

	(* get resolved RecoupSample *)
	recoupSampleBoolean = If[cuvetteQ, Lookup[expandedResolvedOptions, RecoupSample]];

	(* get resolved ContainerOut *)
	containersOut = If[cuvetteQ, Lookup[expandedResolvedOptions, ContainerOut]];

	containersOutWithReplicates = If[cuvetteQ,
		Flatten[Map[
			ConstantArray[#, numReplicatesNoNull]&,
			containersOut
		],1],
		Null
	];

		(* 1way or 2way link depending on whether the user provide a model or an object *)
	containersOutResources = If[cuvetteQ,
		Map[
			If[NullQ[#],
				Null,
				If[MatchQ[#,ObjectP[Model]],
					Link[Resource[Name->ToString[Unique[]], Sample-> #, Rent->True]],
					Link[Resource[Name->ToString[Unique[]], Sample-> #, Rent->True],Protocols]
				]
			]&,
			containersOutWithReplicates
		]
	];

	(* get SamplesOutStorage *)
	samplesOutWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, SamplesOutStorageCondition]
	]];

	(* --- Generate the fields for blanks --- *)

	(* get the Blanks accounting for the number of replicates *)
	(* need to Download Object as well *)
	blanksWithReplicates = If[NullQ[resolvedBlanks],
		{},
		expandReplicatesFunction[Download[resolvedBlanks, Object]]
	];

	(* get the blank volumes with the number of replicates *)
	blankVolumesWithReplicates = expandReplicatesFunction[resolvedBlankVolumesFinal];

	(* get the wavelength option we care about *)
	wavelengthOptionName = If[MatchQ[myType, Object[Protocol, AbsorbanceSpectroscopy]], QuantificationWavelength, Wavelength];
	wavelengthFieldName = If[MatchQ[myType, Object[Protocol, AbsorbanceSpectroscopy]], QuantificationWavelengths, Wavelengths];
	wavelengths = Lookup[expandedResolvedOptions, wavelengthOptionName];

	(* expand the (quantification)wavelengths and quantify concentration booleans expanded to number of replicates. This applies only to AbsSpec and AbsIntensity *)
	wavelengthsWithReplicates = If[MatchQ[myType,Object[Protocol, AbsorbanceSpectroscopy]|Object[Protocol, AbsorbanceIntensity]],
		expandReplicatesFunction[wavelengths],
		wavelengths
	];

	quantConcsWithReplicates = expandReplicatesFunction[Lookup[expandedResolvedOptions, QuantifyConcentration]];
	quantAnalytesWithReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, QuantificationAnalyte]
	]];

	(* --- Make resources for the chips + the rack + blank plate --- *)

	(* get the number of blank plates I need; at most, will need one plate for every 96 blanks, though we could need less if there are empty wells in the plate once we get to run time *)
	(* only need these if we are not using the lunatic and also we are blanking *)
	(* All blanks must be in a single plate for absorbance kinetics *)
	maxNumBlankPlates = If[Not[lunaticQ] && !MatchQ[myType, Object[Protocol,AbsorbanceKinetics]] && blankAbsorbance,
		Ceiling[Length[samplesInWithReplicates] / 96],
		0
	];

	(* get the blank container model *)
	(* if using the lunatic or not blanking, just Null *)
	(* otherwise use whatever the simulated sample's container model is *)
	blankContainerModel = If[lunaticQ || Not[blankAbsorbance],
		Null,
		Download[Lookup[First[simulatedContainerPackets], Model], Object]
	];

	(* get the blank container model packet *)
	blankContainerModelPacket = If[NullQ[blankContainerModel],
		Null,
		FirstCase[blankContainerModelPackets, ObjectP[blankContainerModel], Null]
	];

	(* make resources for the BlankContainers if we are using BMG; use whatever plate model we were already using *)
	blankContainersResources = If[maxNumBlankPlates == 0,
		{},
		ConstantArray[Resource[Sample -> blankContainerModel, Rent -> False], maxNumBlankPlates]
	];

	(* make resources for the MicrofluidicChipRack if we are using the lunatic *)
	microfluidicChipRackResource = If[lunaticQ,
		Resource[Sample -> Model[Container, Plate, "Lunatic Chip Plate"], Rent -> True],
		Null
	];

	(* get the number of wells occupied; if using the Lunatic, always have to reserve two wells due to instrument *)
	numOccupiedWells = If[lunaticQ,
		Length[samplesInResources] + Length[DeleteDuplicates[blanksWithReplicates]] + 2,
		Length[samplesInResources] + Length[blanksWithReplicates]
	];

	(* make resources for the MicrofluidicChips if we are using the Lunatic; we can fit 16 samples on each one, and so Ceiling of the total occupied wells per protocol / 16 gives the sufficient number of chips in all cases*)
	microfluidicChipResources = If[lunaticQ,
		(* need to do Table here because ConstantArray duplicates the Unique call and I don't want that *)
		Table[Resource[Sample -> Model[Container, MicrofluidicChip, "Lunatic Chip"], Rent -> False, Name -> ToString[Unique[]]], Ceiling[numOccupiedWells / 16]],
		{}
	];

	(* - ManualLoadingPipette - only if we are loading manual. I am not a huge fan of this solution, but until we can do it in MSP this will suffice*)
	manualLoadingPipetteResource=If[lunaticQ&&MatchQ[Lookup[expandedResolvedOptions,MicrofluidicChipLoading], Manual],
		Resource[
			Instrument->Model[Instrument, Pipette, "Eppendorf Research Plus P2.5"]
		],
		Null
	];

	(* - ManualLoadingTips - only if we are loading manual. I am not a huge fan of this solution, but until we can do it in MSP this will suffice *)
	manualLoadingTipsResource=If[lunaticQ&&MatchQ[Lookup[expandedResolvedOptions,MicrofluidicChipLoading], Manual],
		Resource[
			Sample->Model[Item, Tips, "0.1 - 10 uL Tips, Low Retention, Non-Sterile"],
			Amount->numOccupiedWells
		],
		Null
	];

	(* Make a resource for a magnifying glass to help inspect the lunatic chips *)
	magnifyingGlassResource = If[lunaticQ,
		Resource[Sample -> Model[Item, MagnifyingGlass, "30X Magnifying glass with Light"], Rent -> True],
		Null
	];


	(* get the estimated reading time *)
	(* note that if we are using the Lunatic, it is faster, and we can only use one plate anyway so it won't increase that way*)
	estimatedReadingTime = If[lunaticQ,
		10 * Minute,
		(5 * Minute * Length[containersIn]) + 10 * Minute
	];

	(* --- Make resources for the control and blanks --- *)

	(* generate the control water resource for each split protocol *)
	(* need a for-real blank that will make the Lunatic happy *)
	(* if we are not using the Lunatic, then this is just Null *)
	(* if we are loading 96 wells and each is 4 microliters, still way under 1.9 mL; less is fine too *)
	controlResource = If[lunaticQ,
		Resource[
			Sample -> Model[Sample, "id:8qZ1VWNmdLBD"], (* milliQ water *)
			(* 1.9*Milliliter because that is the MaxVolume of the 2mL Tube *)
			Amount -> 1.9 * Milliliter,
			Container -> Model[Container, Vessel, "2mL Tube"], (*2mL tube*)
			Name -> "Control water sample for Lunatic "
		],
		Null
	];

	(* make resources for the blanks; this could be different depending on if we are using the Lunatic or not *)
	allBlankResources = If[lunaticQ,

		(* Lunatic *)
		Module[
			{talliedBlanks, blanksNoDupes, talliedBlankResources, blankPositions, blankResourceReplaceRules},

			(* tally how many of each given blank we will be using *)
			talliedBlanks = Tally[blanksWithReplicates];

			(* get the blanks without the duplicates *)
			blanksNoDupes = talliedBlanks[[All, 1]];

			(* make a resource for each blank with the appropriate amount *)
			talliedBlankResources = Map[
				(* using the ID for Milli-Q water rather than the name because we already Downloaded object above in blanksWithReplicates *)
				If[MatchQ[#[[1]], ObjectReferenceP[Model[Sample, "id:8qZ1VWNmdLBD"]]],
					controlResource,
					Resource[
						Sample -> #[[1]],
						(* removed AchievableResolution[#[[2]] * 2.1*Microliter * 1.1, Messages -> False], and hardcoded to 50uL since there is only 1 blank spotted and 50 microliter will work for all containers validModelsForLunaticLoading[] *)
						Amount -> 50 Microliter,
						Container -> validModelsForLunaticLoading[],
						Name -> ToString[Unique[]]
					]
				]&,
				talliedBlanks
			];

			(* get the position of each of the models in the list of blanks *)
			blankPositions = Map[
				Position[blanksWithReplicates, #]&,
				blanksNoDupes
			];

			(* make replace rules converting the blank models to their resources to be used in ReplacePart below *)
			blankResourceReplaceRules = MapThread[
				#1 -> #2&,
				{blankPositions, talliedBlankResources}
			];

			(* use ReplacePart to return the blank resources *)
			ReplacePart[blanksWithReplicates, blankResourceReplaceRules]

		],

		(* Plate Reader*)
		Module[
			{blankVolumeRules, mergedBlankVolumes, blanksNoDupes, talliedBlankResources, blankPositions,
				blankResourceReplaceRules},

			(* need to combine the blanks and how much volume we need for each of them together *)
			(* Remove any duplicate sample-volume pairs since we only need one instance for blanking *)
			blankVolumeRules = DeleteDuplicates[
				MapThread[
					#1 -> #2&,
					{Download[resolvedBlanks,Object],resolvedBlankVolumesFinal}
				]
			];

			(* group and sum the volumes where the blank model is the same *)
			(* oh man Hayley look I used Merge all by myself*)
			mergedBlankVolumes = Merge[blankVolumeRules, Total];

			(* get the blanks without dupes *)
			blanksNoDupes = Keys[mergedBlankVolumes];

			(* create a resource for each of the different kinds of blanks for each split protocol *)
			talliedBlankResources = KeyValueMap[
				(* doing this With call to ensure that I only have to call AchievableResolution once per loop since it is kind of slow *)
				(* we're going to make as many blanks as replicates so must multiply volume by this amount *)
				With[{achievableResolution = AchievableResolution[#2 * 1.1 * numReplicatesNoNull, Messages -> False]},
					If[MatchQ[#1,Null],
						#1,
						Resource@@{
							Sample -> #1,
							(* For plate reader, we cannot simply request 1.1 x resolved blank volumes, because it is possible that we just resolve to use an existing sample on the same sample plate as our blank . We resolve the blank volume using sample volume, and it is a perfectly reasonable setup to have blank sample volume the same as the sample volume. In this case we request the whole sample. *)
							Which[
								And[
									MatchQ[#1,ObjectP[Object[Sample]]],
									MatchQ[#2, VolumeP],
									MatchQ[Lookup[fetchPacketFromCache[#1, Flatten[blankPackets]], {Container, Volume}, Null], {ObjectP[Object[Container, Plate]], EqualP[#2]}]
								],
									Nothing,
								MatchQ[achievableResolution,VolumeP],
									Amount -> achievableResolution,
								True,
									Nothing
							],
							If[MatchQ[#1,ObjectP[Model]],
								Container -> PreferredContainer[achievableResolution],
								Nothing
							],
							Name -> ToString[Unique[]]
						}
					]
				]&,
				mergedBlankVolumes
			];

			(* get the position of each of the models in the list of blanks *)
			blankPositions = Map[
				Position[blanksWithReplicates, #]&,
				blanksNoDupes
			];

			(* make replace rules converting the blank models to their resources to be used in ReplacePart below *)
			blankResourceReplaceRules = MapThread[
				#1 -> #2&,
				{blankPositions, talliedBlankResources}
			];

			(* use ReplacePart to return the blank resources *)
			ReplacePart[blanksWithReplicates, blankResourceReplaceRules]

		]

	];

	(* expand SamplesInStorage with NumberOfReplicates *)
	expandedSamplesInStorage=expandReplicatesFunction[Lookup[expandedResolvedOptions, SamplesInStorageCondition]];

	(* == Define Function: populateInjectionFieldFunction == *)
	(* Format a set of injection options into the structure used for the corresponding injection field *)
	(* Fluorescence Kinetics overload - field formatted as {{time, sample, volume}..}*)
	populateInjectionFieldFunction[Object[Protocol,AbsorbanceKinetics],injectionVolumesNoReplicates_,injectionSamplesNoReplicates_,injectionTime_]:=Module[
		{injectionVolumes,injectionSamples,injectionSampleObjects,injectionSample,injectionTuples,injectionFieldValue},

		injectionVolumes=expandReplicatesFunction[injectionVolumesNoReplicates];
		injectionSamples=expandReplicatesFunction[injectionSamplesNoReplicates];

		injectionSampleObjects=Download[injectionSamples,Object];

		(* Sample we're injecting (injectionSampleObjects will be a mix of Nulls and repeated object) *)
		injectionSample=FirstCase[injectionSampleObjects,ObjectP[]];

		injectionTuples=Prepend[#,injectionTime]&/@Transpose[{injectionSampleObjects,injectionVolumes}];

		injectionFieldValue=If[MemberQ[injectionVolumes,VolumeP],
		(* Replace {Null,Null,Null} with {time, sample, 0 Microliter} as a placeholder to keep index-matching *)
			Replace[injectionTuples, {TimeP,Null, Null} :> {injectionTime, Null, 0 Microliter}, {1}],
			{}
		]
	];

	(* == Define Function: populateInjectionFieldFunction == *)
	(* Format a set of injection options into the structure used for the corresponding injection field *)
	(* Fluorescence Intensity overload - field formatted as {{sample, volume}..} *)
	populateInjectionFieldFunction[Object[Protocol,AbsorbanceIntensity]|Object[Protocol,AbsorbanceSpectroscopy],injectionVolumesNoReplicates_,injectionSamplesNoReplicates_,injectionTimeNoReplicates_]:=Module[
		{injectionVolumes,injectionSamples,injectionTime,injectionSampleObjects,injectionSample,injectionFieldValue},

		injectionVolumes=expandReplicatesFunction[injectionVolumesNoReplicates];
		injectionSamples=expandReplicatesFunction[injectionSamplesNoReplicates];
		injectionTime=expandReplicatesFunction[injectionTimeNoReplicates];

		injectionSampleObjects=Download[injectionSamples,Object];

		injectionSample=FirstCase[injectionSampleObjects,ObjectP[]];

		injectionFieldValue=If[MemberQ[injectionVolumes,VolumeP],
			(* Replace {Null,Null} with {sample, 0 Microliter} as a placeholder to keep index-matching *)
			Replace[Transpose[{injectionSampleObjects,injectionVolumes}], {Null, Null} :> {Null, 0 Microliter}, {1}],
			{}
		]
	];

	(* Format injections as tuples index-matched to samples in. These will look different depending on the experiment:
		AI,AS is in the form {{time, sample, volume}..}
		AK is in the form {{sample, volume}..}
	*)
	(* Note: wells which aren't receiving injections will have sample=Null, volume=0 Microliter *)
	primaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,PrimaryInjectionVolume],Lookup[expandedResolvedOptions,PrimaryInjectionSample],Lookup[expandedResolvedOptions,PrimaryInjectionTime]];
	secondaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,SecondaryInjectionVolume],Lookup[expandedResolvedOptions,SecondaryInjectionSample],Lookup[expandedResolvedOptions,SecondaryInjectionTime]];
	tertiaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,TertiaryInjectionVolume],Lookup[expandedResolvedOptions,TertiaryInjectionSample],Lookup[expandedResolvedOptions,TertiaryInjectionTime]];
	quaternaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,QuaternaryInjectionVolume],Lookup[expandedResolvedOptions,QuaternaryInjectionSample],Lookup[expandedResolvedOptions,QuaternaryInjectionTime]];

	(* Get assoc in the form <|(sample -> total volume needed)..|> *)
	(* Note: regardless of experiment, second to last entry will be sample, last entry will be volume *)
	injectionSampleVolumeAssociation=KeyDrop[GroupBy[Join[primaryInjections,secondaryInjections,tertiaryInjections,quaternaryInjections],(#[[-2]]&)->(#[[-1]]&), Total],Null];

	(* Track containers which can be used to hold injection samples - plate readers have spots for 2mL, 15mL and 50mL tubes *)
	allowedInjectionContainers=Search[Model[Container, Vessel],Footprint==(Conical50mLTube|Conical15mLTube|MicrocentrifugeTube)&&Deprecated!=True];

	(* Create a single resource for each unique injection sample *)
	injectionSampleToResourceLookup=KeyValueMap[
		Module[{sample,volume,injectionContainer,injectionContainerModel,resource},
			{sample,volume}={#1,#2};

			(* Lookup sample's container model *)
			injectionContainer=Lookup[injectionContainerLookup,sample];
			injectionContainerModel=Lookup[containerModelLookup,injectionContainer,Null];

			(* Create a resource for the sample *)
			resource=If[MatchQ[sample,Null],
				Null,
				Resource@@{
					Sample->sample,
					(* Include volume lost due to priming lines (compiler sets to 1mL)
					- prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
					Amount->(volume + $BMGPrimeVolume),

					(* Specify a container if we're working with a moodel or if current container isn't workable *)
					If[MatchQ[injectionContainerModel,ObjectP[allowedInjectionContainers]],
						Nothing,
						Container -> PreferredContainer[(volume + $BMGPrimeVolume),Type->Vessel]
					],
					Name->ToString[sample]
				}
			];
			sample->resource
		]&,
		injectionSampleVolumeAssociation
	];

	(* Replace injection samples with resources for those samples *)
	{primaryInjectionWithResources,secondaryInjectionsWithResources,tertiaryInjectionsWithResources,quaternaryInjectionsWithResources}=Map[
		Function[{injectionEntries},
			If[MatchQ[injectionEntries,{}],
				{},
				Module[{injectionSample,injectionResource},
				(* Get injection sample for the group  - regardless of experiment, second to last entry will be sample, last entry will be volume *)
					injectionSample=FirstCase[injectionEntries[[All,-2]],ObjectP[]];

					(* Find resource created for that sample *)
					injectionResource=Lookup[injectionSampleToResourceLookup,injectionSample];

					(* Replace any injection objects with corresponding resource *)
					Replace[injectionEntries,{time___,ObjectP[],volume___}:>{time,injectionResource,volume},{1}]
				]
			]
		],
		{primaryInjections,secondaryInjections,tertiaryInjections,quaternaryInjections}
	];

	(*  --- Create resources to clean the injectors and lines --- *)

	(* Track whether or not we're injecting anything *)
	anyInjectionsQ=MemberQ[Flatten[Lookup[expandedResolvedOptions,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}]],VolumeP];

	(* injectionSampleVolumeAssociation gives unique injection samples *)
	numberOfInjectionContainers = Length[injectionSampleVolumeAssociation];

	(* Wash each line being used with the flush volume - request a little extra to avoid air in the lines *)
	(* Always multiply by 2 - either we'll use same resource for prepping and flushing or we have two lines to flush *)
	washVolume=($BMGFlushVolume + 2.5 Milliliter) * 2;

	(* Create solvent resources to clean the lines *)
	line1PrimaryPurgingSolvent=Resource@@{
		Sample->Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
		Amount->washVolume,
		Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
		Name->"Line1 Primary Purging Solvent"
	};
	line2PrimaryPurgingSolvent = If[numberOfInjectionContainers==2,
		Resource@@{
			Sample->Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"] (* 70% Ethanol *),
			Amount->washVolume,
			Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
			Name->"Line2 Primary Purging Solvent"
		},
		Null
	];

	line1SecondaryPurgingSolvent=Resource@@{
		Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
		Amount->washVolume,
		Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
		Name->"Line1 Secondary Purging Solvent"
	};
	line2SecondaryPurgingSolvent = If[numberOfInjectionContainers==2,
		Resource@@{
			Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
			Amount->washVolume,
			Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
			Name->"Line2 Secondary Purging Solvent"
		},
		Null
	];

	(* Populate fields needed to clean the lines before/after the run *)
	injectorCleaningFields=If[anyInjectionsQ,
		<|
			Line1PrimaryPurgingSolvent->line1PrimaryPurgingSolvent,
			Line2PrimaryPurgingSolvent->line2PrimaryPurgingSolvent,
			Line1SecondaryPurgingSolvent->line1SecondaryPurgingSolvent,
			Line2SecondaryPurgingSolvent ->line2SecondaryPurgingSolvent
		|>,
		<||>
	];


	(* -- Generate our unit operation packet -- *)
	resolvedPreparation = Lookup[myResolvedOptions,Preparation];

	(* expand sample labels for replicates *)
	sampleLabelsWithReplicates = expandReplicatesFunction[Lookup[myResolvedOptions, SampleLabel]];

	blankLabelsWithReplicates = If[cuvetteQ,
		(* for cuvette, all sample and sample replicates share one blank (in exportCary) so we simply duplicate the labels here b/c maximum number of blanks to make is 1 *)
		expandReplicatesFunction[resolvedBlankLabels],
		(* for plate reader, each sample and sample replicates have their own blank, so we need to create a new sample label for marking *)
		Module[{uniqueBlankLabels, newBlankLabels, oldToNewLabelRules},
			(* get all unique blank sample labels *)
			uniqueBlankLabels = DeleteDuplicates[resolvedBlankLabels];

			(* make another set of blank labels (according to number of replicates) ready to use *)
			newBlankLabels = Table[
				Table[CreateUniqueLabel["blank sample"], numReplicatesNoNull - 1],
				Length[uniqueBlankLabels]
			];

			(* make replacement rules *)
			oldToNewLabelRules = Rule @@@ Transpose[{uniqueBlankLabels, newBlankLabels}];

			(* what we want here is that if user gives us a prepared blank sample (with blank volume being Null), all replicates will share the same blank sample, so we simply duplicate blank labels *)
			(* if user gives us a blank volume indicating preparing new blanks in our procedure, then we will make a new blank for each of the duplicate, therefore requiring a new blank label for each of the replicates *)
			(* for example, for the following input
			input: {sample1, sample2}
			NumberOfReplicates -> 2,
			Blanks: {Object[Sample, "id:1234"], Model[Sample, "Milli-Q water"]},
			BlankVolumes: {Null, 200uL}
			the resolved expanded BlankLabels will be:
			{"blank sample 1", "blank sample 1", "blank sample 2", "blank sample 3"}
			indicating:
			2 replicates of sample1 will share the same prepared blank Object[Sample, "id:1234"], therefore only need one blank label "blank sample 1",
			2 replicates of sample2, each of them will get a fresh blank prepared from 200uL of Model[Sample, "Milli-Q water"], so we need different blank labels ("blank sample 2", "blank sample 3")
			*)
			Flatten[MapThread[
				If[NullQ[#1],
					(* if we can use the blank directly, no need to create new labels for it since the blank is already prepared *)
					ConstantArray[#2, numReplicatesNoNull],
					(* otherwise combine the new labels with old labels *)
					Prepend[#2 /. oldToNewLabelRules, #2]
				]&,
				{resolvedBlankVolumesFinal, resolvedBlankLabels}
			]]
		]
	];

	(* get the non hidden options *)
	nonHiddenOptions=Lookup[
		Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category"->Except["Hidden"]]],
		"OptionSymbol"
	];

	(* --- Generate our protocol packet --- *)
	(* NOTE: We only include our *)
	{finalizedPacket, unitOperationPackets}=If[MatchQ[resolvedPreparation, Manual],
		Module[{standardFields, intensityAndSpectroscopyFields, kineticsFields, protocolPacket, sharedFieldPacket},
			(* fill in the protocol packet with all the resources *)
			standardFields = <|
				Object -> CreateID[myType],
				Type -> myType,
				Template -> If[MatchQ[Lookup[resolvedOptionsNoHidden, Template], FieldReferenceP[]],
					Link[Most[Lookup[resolvedOptionsNoHidden, Template]], ProtocolsTemplated],
					Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated]
				],
				UnresolvedOptions -> myUnresolvedOptions,
				ResolvedOptions -> resolvedOptionsNoHidden,
				Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
				Replace[Checkpoints] -> {
					{"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
					{"Preparing Samples", 1 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Minute]]},
					{"Reading Absorbance", estimatedReadingTime, "Sample absorbance is measured.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 * Minute]]},
					{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 5 * Minute]]},
					{"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 * Minute]]}
				},
				Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ containersIn,
				NumberOfReplicates -> numReplicates,
				Instrument -> Link[Resource[Instrument -> instrumentOpt, Time -> estimatedReadingTime]],
				Temperature -> If[MatchQ[Lookup[expandedResolvedOptions, Temperature], Ambient],
					Null,
					Lookup[expandedResolvedOptions, Temperature]
				],
				ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
				EquilibrationTime -> Lookup[expandedResolvedOptions, EquilibrationTime],
				TargetCarbonDioxideLevel -> Lookup[expandedResolvedOptions, TargetCarbonDioxideLevel],
				TargetOxygenLevel -> Lookup[expandedResolvedOptions, TargetOxygenLevel],
				AtmosphereEquilibrationTime -> Lookup[expandedResolvedOptions, AtmosphereEquilibrationTime],
				Replace[BlankVolumes] -> If[NullQ[blankVolumesWithReplicates], {}, blankVolumesWithReplicates],
				Replace[Blanks] -> (Link[#] & /@ allBlankResources),
				Replace[BlankLabels] -> If[NullQ[blankLabelsWithReplicates], {}, blankLabelsWithReplicates],
				Replace[SamplesInStorage] -> expandedSamplesInStorage,
				PlateReaderMix -> Lookup[expandedResolvedOptions, PlateReaderMix],
				PlateReaderMixRate -> Lookup[expandedResolvedOptions, PlateReaderMixRate],
				PlateReaderMixTime -> Lookup[expandedResolvedOptions, PlateReaderMixTime],
				PlateReaderMixMode -> Lookup[expandedResolvedOptions, PlateReaderMixMode],
				InjectionStorageCondition->Lookup[expandedResolvedOptions,InjectionSampleStorageCondition],
				MoatBuffer->Link[Lookup[expandedResolvedOptions, MoatBuffer]],
				MoatSize->Lookup[expandedResolvedOptions, MoatSize],
				MoatVolume->Lookup[expandedResolvedOptions, MoatVolume],
				SamplingPattern->Lookup[expandedResolvedOptions,SamplingPattern],
				SamplingDistance->Lookup[expandedResolvedOptions,SamplingDistance],
				SamplingDimension->Lookup[expandedResolvedOptions,SamplingDimension],
				PrimaryInjectionFlowRate->Lookup[expandedResolvedOptions,PrimaryInjectionFlowRate],
				SecondaryInjectionFlowRate->Lookup[expandedResolvedOptions,SecondaryInjectionFlowRate],
				NumberOfReadings->Lookup[expandedResolvedOptions,NumberOfReadings],
				ReadDirection->Lookup[expandedResolvedOptions,ReadDirection],
				RetainCover->Lookup[expandedResolvedOptions,RetainCover],
				Replace[PrimaryInjections]->primaryInjectionWithResources,
				Replace[SecondaryInjections]->secondaryInjectionsWithResources,
				If[MatchQ[resolvedPreparation,Robotic],
					Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@ToList[Lookup[unitOperationPackets, Object]],
					Nothing
				]
			|>;

			intensityAndSpectroscopyFields=<|
				Replace[QuantifyConcentrations] -> quantConcsWithReplicates,
				Replace[QuantificationAnalytes] -> Link[quantAnalytesWithReplicates],
				Methods->Lookup[expandedResolvedOptions,Methods],
				SpectralBandwidth-> Lookup[expandedResolvedOptions,SpectralBandwidth],
				Replace[AcquisitionMix]-> Lookup[expandedResolvedOptions,AcquisitionMix],
				NominalAcquisitionMixRate-> Lookup[expandedResolvedOptions,AcquisitionMixRate],
				MinAcquisitionMixRate-> Lookup[expandedResolvedOptions,MinAcquisitionMixRate],
				MaxAcquisitionMixRate-> Lookup[expandedResolvedOptions,MaxAcquisitionMixRate],
				AcquisitionMixRateIncrements-> Lookup[expandedResolvedOptions,AcquisitionMixRateIncrements],
				MaxStirAttempts-> Lookup[expandedResolvedOptions,MaxStirAttempts],
				AdjustMixRate-> Lookup[expandedResolvedOptions,AdjustMixRate],
				Replace[StirBar]-> stirBarResource,
				StirAttemptsCounter -> 1,
				StirBarRetriever -> stirBarRetrieverResource,
				Replace[Cuvettes]-> cuvetteResources,
				Replace[ContainersOut] -> containersOutResources,
				Replace[RecoupSample] -> recoupSampleBoolean,
				Replace[SamplesOutStorage] -> samplesOutWithNumReplicates,
				BlankMeasurement -> blankAbsorbance,
				TemperatureMonitor -> temperatureMonitor,
				TemperatureProbe -> Link[temperatureProbeResource],
				CuvetteRack -> cuvetteRackResource,
				CuvetteWasher -> cuvetteWasherResource,
				BlowGun -> blowGunResource,
				Replace[MicrofluidicChips] -> (Link[#]& /@ microfluidicChipResources),
		        MicrofluidicChipRack -> Link[microfluidicChipRackResource],
		        MicrofluidicChipLoading->Lookup[expandedResolvedOptions,MicrofluidicChipLoading],
		        MicrofluidicChipManualLoadingPipette -> Link[manualLoadingPipetteResource],
		        MicrofluidicChipManualLoadingTips -> Link[manualLoadingTipsResource],
				MagnifyingGlass -> Link[magnifyingGlassResource],
				EquilibrationSample -> Link[controlResource],
				Replace[wavelengthFieldName] -> wavelengthsWithReplicates,
				(* AbsorbanceKinetics doesn't use BlankContainers - all samples must be in the same container which is read over time *)
				Replace[BlankContainers] -> (Link[#]& /@ blankContainersResources)
			|>;

			kineticsFields=<|
				RunTime->Lookup[expandedResolvedOptions,RunTime],
				ReadOrder->Lookup[expandedResolvedOptions,ReadOrder],
				PlateReaderMixSchedule->Lookup[expandedResolvedOptions,PlateReaderMixSchedule],
				(* Abs Kinetics allows a list of multiple wavelengths (not index-matched) or the keyword All to indicate full range should be used *)
				Which[
					MatchQ[wavelengths,All], Sequence@@{MinWavelength->220 Nanometer,MaxWavelength->1000 Nanometer},
					MatchQ[wavelengths,_Span], Sequence@@{MinWavelength->Min[{First[wavelengths],Last[wavelengths]}],MaxWavelength->Max[{First[wavelengths],Last[wavelengths]}]},
					True,Replace[Wavelengths]->ToList[wavelengths]
				],
				Replace[TertiaryInjections]->tertiaryInjectionsWithResources,
				Replace[QuaternaryInjections]->quaternaryInjectionsWithResources,
				TertiaryInjectionFlowRate->Lookup[expandedResolvedOptions,TertiaryInjectionFlowRate],
				QuaternaryInjectionFlowRate->Lookup[expandedResolvedOptions,QuaternaryInjectionFlowRate]
			|>;

			protocolPacket=If[MatchQ[myType,Object[Protocol,AbsorbanceKinetics]],
				Join[standardFields,injectorCleaningFields,kineticsFields],
				Join[standardFields,injectorCleaningFields,intensityAndSpectroscopyFields]
			];

			(* generate a packet with the shared fields *)
			sharedFieldPacket = populateSamplePrepFields[mySamples, expandedResolvedOptions, Cache -> cache, Simulation -> updatedSimulation];

			(* Merge the shared fields with the specific fields *)
			{
				Join[sharedFieldPacket, protocolPacket],
				{}
			}
		],
		Module[{unitOpPacket,unitOperationPacketWithLabeledObjects},
			unitOpPacket = UploadUnitOperation[
				primitiveHead@@Join[
					{
						Sample->samplesInResources
					},
					ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
						{
							Instrument -> Resource[Instrument -> instrumentOpt, Time -> estimatedReadingTime],
							Blanks -> allBlankResources,
							(* injection sample resources are always in second to last position for all experiments *)
							PrimaryInjectionSample->If[Length[primaryInjectionWithResources[[All,-2]]]==0,
								ConstantArray[Null, Length[mySamples]],
								primaryInjectionWithResources[[All,-2]]
							],
							SecondaryInjectionSample->If[Length[secondaryInjectionsWithResources[[All,-2]]]==0,
								ConstantArray[Null, Length[mySamples]],
								secondaryInjectionsWithResources[[All,-2]]
							],
							(* kinetics only *)
							If[MatchQ[experimentFunction,ExperimentAbsorbanceKinetics],
								TertiaryInjectionSample->If[Length[tertiaryInjectionsWithResources[[All,-2]]]==0,
									ConstantArray[Null, Length[mySamples]],
									tertiaryInjectionsWithResources[[All,-2]]
								],
								Nothing
							],
							If[MatchQ[experimentFunction,ExperimentAbsorbanceKinetics],
								QuaternaryInjectionSample->If[Length[quaternaryInjectionsWithResources[[All,-2]]]==0,
									ConstantArray[Null, Length[mySamples]],
									quaternaryInjectionsWithResources[[All,-2]]
								],
								Nothing
							],
							(* NOTE: Don't pass Name down. *)
							Name->Null
						}
					],
					{
						SampleLabel->sampleLabelsWithReplicates,
						BlankLabel->blankLabelsWithReplicates
					}
				],
				Preparation->Robotic,
				UnitOperationType->Output,
				FastTrack->True,
				Upload->False
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			unitOperationPacketWithLabeledObjects=Append[
				unitOpPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{sampleLabelsWithReplicates, samplesInResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{DeleteDuplicates@Lookup[myResolvedOptions, SampleContainerLabel], (Resource[Sample -> #]& /@ containersIn)}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					],

					If[!MatchQ[allBlankResources,ListableP[Null]|{}],
						Cases[
							Transpose[{blankLabelsWithReplicates, allBlankResources}],
							{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
						],
						{}
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
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[finalizedPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];
	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
			(* When Preparation->Robotic, the framework will call FRQ for us. *)
			MatchQ[resolvedPreparation, Robotic],
		{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->updatedSimulation,Cache->cache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->updatedSimulation,Cache->cache],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		nonHiddenOptions,
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
		{finalizedPacket, unitOperationPackets} /. resourceToNameReplaceRules,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* get the tips that will be used to load the Lunatic chip *)
(* currently this is for sure the 50uL hamiltion tips TODO had to change to sterile tip because of worldwide tip shortage; can change this back once we have more*)
(* need to use this guy because lunatic chip loading needs an especially good precision that the bigger tips don't have *)
requiredLunaticChipTip = Model[Item, Tips, "50 uL Hamilton tips, non-sterile"];

(* get the valid container models that can be used with this experiment; it depends on whether we're using the Lunatic or not *)
(* using a private function for Lunatic case *)
(* need to make sure the requiredLunaticChipTip can fit in the container, and need to make sure your source container isn't too small *)
validModelsForLunaticLoading[] := validModelsForLunaticLoading[] = Module[
	{liquidHandlerContainers, chipTip, containerModelPackets, tipModelPackets, reachableContainerBools,
		flatTipModelPackets, chipTipObj, reachableContainerModelPackets, bigEnoughContainerModelPackets,
		regularPlateModelPackets},

	(* get all the liquid handler-compatible containers *)
	liquidHandlerContainers = compatibleSampleManipulationContainers[MicroLiquidHandling];

	(* get the chip tip we are going to be comparing against *)
	chipTip = requiredLunaticChipTip;

	(* Download the relevant fields*)
	(* for the containers, we want Aperture/InternalDepth (Vessels/Cuvettes) and WellDimensions/WellDiameter/WellDepth (Plates)*)
	(* for the tips, we need AspirationDepth *)
	{
		containerModelPackets,
		tipModelPackets
	} = Quiet[Download[
		{
			liquidHandlerContainers,
			{chipTip}
		},
		{
			{Packet[Aperture, InternalDepth, WellDimensions, WellDiameter, WellDepth, MaxVolume]},
			{Packet[AspirationDepth]}
		},
		Date -> Now
	], Download::FieldDoesntExist];

	(* get the chip tip in non-name form *)
	flatTipModelPackets = Flatten[tipModelPackets];
	chipTipObj = Lookup[First[flatTipModelPackets], Object];

	(* irregular plates are causing errors to get thrown in tipsReachContainerBottomQ so for now just get rid of them *)
	regularPlateModelPackets = DeleteCases[Flatten[containerModelPackets], ObjectP[Model[Container, Plate, Irregular]]];

	(* get rid of the containers that the tips can't reach into *)
	reachableContainerBools = Map[
		tipsReachContainerBottomQ[chipTipObj, #, flatTipModelPackets]&,
		regularPlateModelPackets
	];

	(* get the reachable container packets *)
	reachableContainerModelPackets = PickList[regularPlateModelPackets, reachableContainerBools];

	(* somewhat arbitrarily remove the containers whose MaxVolume is below 110 uL, which sounds weird but will also include PCR plates and 384-well plates.	*)
	bigEnoughContainerModelPackets = Select[reachableContainerModelPackets, Lookup[#, MaxVolume] >= 110 Microliter&];

	Lookup[bigEnoughContainerModelPackets, Object, {}]

];



(* ::Subsection::Closed:: *)
(*ValidExperimentAbsorbanceSpectroscopyQ*)


DefineOptions[ValidExperimentAbsorbanceSpectroscopyQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentAbsorbanceSpectroscopy}
];


(* samples overloads *)
ValidExperimentAbsorbanceSpectroscopyQ[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ValidExperimentAbsorbanceSpectroscopyQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedSamples},

	(* get the options as a list *)
	(* also get the samples as a list *)
	listedOptions = ToList[myOptions];
	listedSamples = ToList[mySamples];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentAbsorbanceSpectroscopy *)
	absSpecTests = ExperimentAbsorbanceSpectroscopy[listedSamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedSamples, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedSamples, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAbsorbanceSpectroscopyQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests  *)
	Lookup[RunUnitTest[<|"ValidExperimentAbsorbanceSpectroscopyQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentAbsorbanceSpectroscopyQ"]

];


(* plates overloads *)
ValidExperimentAbsorbanceSpectroscopyQ[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentAbsorbanceSpectroscopyQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedContainers},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentAbsorbanceSpectroscopy *)
	absSpecTests = ExperimentAbsorbanceSpectroscopy[listedContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedContainers, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedContainers, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAbsorbanceSpectroscopyQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests *)
	Lookup[RunUnitTest[<|"ValidExperimentAbsorbanceSpectroscopyQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentAbsorbanceSpectroscopyQ"]

];


(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopyOptions*)


DefineOptions[ExperimentAbsorbanceSpectroscopyOptions,
	SharedOptions :> {ExperimentAbsorbanceSpectroscopy},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* samples overloads *)
ExperimentAbsorbanceSpectroscopyOptions[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopyOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentAbsorbanceSpectroscopy *)
	options = ExperimentAbsorbanceSpectroscopy[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentAbsorbanceSpectroscopy],
		options
	]
];


(* containers overloads *)
ExperimentAbsorbanceSpectroscopyOptions[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopyOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentAbsorbanceSpectroscopy *)
	options = ExperimentAbsorbanceSpectroscopy[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentAbsorbanceSpectroscopy],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopyPreview*)


DefineOptions[ExperimentAbsorbanceSpectroscopyPreview,
	SharedOptions :> {ExperimentAbsorbanceSpectroscopy}
];


(* samples overloads *)
ExperimentAbsorbanceSpectroscopyPreview[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopyPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentAbsorbanceSpectroscopy[mySamples, Append[noOutputOptions, Output -> Preview]]
];


(* container overloads *)
ExperimentAbsorbanceSpectroscopyPreview[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentAbsorbanceSpectroscopyPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentAbsorbanceSpectroscopy[myContainers, Append[noOutputOptions, Output -> Preview]]
];