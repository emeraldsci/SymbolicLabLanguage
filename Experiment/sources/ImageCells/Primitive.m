(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*resolveAcquireImagePrimitive*)


(* ::Subsubsection:: *)
(* resolveAcquireImagePrimitive Options *)


DefineOptions[resolveAcquireImagePrimitive,
	Options:>{
		(* AcquireImage primitive shared options *)
		IndexMatching[
			{
				(* FIXME: need to find a way to make it work without this option *)
				OptionName->FakeOption,
				Default->None,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Description->"This is a fake hidden option to allow IndexMatchingParent to work.",
				Category->"Hidden"
			},
			acquireImagePrimitiveOptions,
			IndexMatchingParent->DetectionLabels
		],

		(* ---resolveAcquireImagePrimitive unique options--- *)
		{
			OptionName->Primitive,
			Default->{},
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Widget[Type->Primitive,Pattern:>AcquireImagePrimitiveP],
				Adder[Widget[Type->Primitive,Pattern:>AcquireImagePrimitiveP]]
			],
			Description->"Used to pass in a list of AcquireImage primitives so that we can resolve the options.",
			Category->"Hidden"
		},
		OutputOption,
		CacheOption,
		SimulationOption
	},
	SharedOptions:>{
		{ExperimentImageCells,Instrument},

		ModifyOptions[ExperimentImageCells,{
			{
				OptionName->Timelapse,
				IndexMatching->Null,
				IndexMatchingInput->Null,
				IndexMatchingOptions->Null
			},
			{
				OptionName->NumberOfTimepoints,
				IndexMatching->Null,
				IndexMatchingInput->Null,
				IndexMatchingOptions->Null
			},
			{
				OptionName->ZStack,
				IndexMatching->Null,
				IndexMatchingInput->Null,
				IndexMatchingOptions->Null
			},
			{
				OptionName->ObjectiveMagnification,
				IndexMatching->Null,
				IndexMatchingInput->Null,
				IndexMatchingOptions->Null
			}
		}]
	}
];


(* ::Subsubsection:: *)
(* resolveAcquireImagePrimitive Messages *)


Error::ConflictingPrimitiveOptions="The following options cannot be specified when Primitive option is provided: `1`. Please leave these options to be set automatically.";
Error::MissingNumberOfTimepoints="If Timelapse option is set to True, NumberOfTimepoints must be specified.";
Error::AcquireImageUnsupportedMode="The specified Mode option at index `1` is not supported by the following instrument: `2`. Please correct the Mode option or select a different instrument. The supported imaging modes are listed in the Modes field of the instrument's model.";
Warning::AcquireImageOverlappingDetectionLabels="The following objects, `2` ,are specified multiple times as DetectionLabels option at index `1`. No action is needed if this is intentional.";
Warning::CannotImageFluorescentDetectionLabels="The instrument is not capable detecting fluorescent DetectionLabels contained by the following input samples: `1`. Please specify a new instrument that supports ConfocalFluorescence or Epifluorescence mode if detection of fluorescent DetectionLabels is desired.";
Warning::CannotImageNonFluorescentDetectionLabels="The instrument is not capable detecting non-fluorescent DetectionLabels contained by the following input samples: `1`. Please specify a new instrument that supports BrightField or PhaseContrast mode if detection of non-fluorescent DetectionLabels is desired.";
Error::UnresolvableMode="The Mode option cannot be determined because the DetectionLabels options at index `1` contain both fluorescent and non-fluorescent molecules. If detection of all molecules is desired, please specify the following fluorescent and non-fluorescent molecules as DetectionLabels in different AcquireImage primitives: `2`. Otherwise, please specify only the desired detection label(s).";
Warning::UndetectableNonFluorescentDetectionLabels="Mode `1` will not be able to detect emitted fluorescence from the following molecules specified in DetectionLabels option at index `2`: `3`. Please select the following Mode to allow detection of non-fluorescent DetectionLabels: `4`.";
Warning::DetectionLabelsNotSpecified="The DetectionLabel option at index `1` is not specified while the given Mode will perform fluorescence imaging. All related options will be automatically set to default values if not specified. No action is needed if this is intentional.";
Warning::UnresolvableExcitationWavelength="The ExcitationWavelength option at index `1` is set to `2`, which is the longest wavelength supported by the instrument because DetectionLabels option is Null. Please specify the ExcitationWavelength option if a different wavelength is preferred.";
Warning::MultipleExcitationWavelengths="The following molecules specified as DetectionLabels option at index `1` do not share a single excitation wavelength: `2`. ExcitationWavelength is automatically set to `3` based on the average of all molecules' excitation wavelengths. Please specify the ExcitationWavelength option if a different wavelength is preferred.";
Warning::ExcitationWavelengthOutOfRange="The excitation wavelength of the following DetectionLabels option at index `1` is outside of the instrument's range: `2`. ExcitationWavelength is automatically set to `3` which is the nearest excitation wavelength supported by the instrument. Please specify the ExcitationWavelength option if a different wavelength is preferred.";
Error::UnsupportedExcitationWavelength="The specified ExcitationWavelength option `1` at index `2` is not supported by the instrument. The instrument `3` supports the following excitation wavelengths: `4`. Please change ExcitationWavelength option accordingly.";
Error::UnspecifiedExcitationWavelength="The ExcitationWavelength option at index `1` cannot be Null when fluorescence imaging mode is selected. Please change the Mode option or leave the ExcitationWavelength option to be set automatically.";
Warning::MismatchedExcitationWavelength="The specified ExcitationWavelength option `1` at index `2` does not match the excitation wavelength of the following molecules in DetectionLabels option: `3`. No action is needed if this is intentional.";
Warning::UnresolvableEmissionWavelength="The EmissionWavelength option at index `1` is set to `2`, which is the longest wavelength supported by the instrument because DetectionLabels option is Null. Please specify the EmissionWavelength option if a different wavelength is preferred.";
Warning::MultipleEmissionWavelengths="The following molecules specified as DetectionLabels option at index `1` do not share a single emission wavelength: `2`. EmissionWavelength is automatically set to `3` based on the average of all molecules' emission wavelengths. Please specify the EmissionWavelength option if a different wavelength is preferred.";
Warning::EmissionWavelengthOutOfRange="The emission wavelength of the following DetectionLabels option at index `1` is outside of the instrument's range: `2`. EmissionWavelength is automatically set to `3` which is the nearest emission wavelength supported by the instrument. Please specify the EmissionWavelength option if a different wavelength is preferred.";
Error::UnsupportedEmissionWavelength="The specified EmissionWavelength option `1` at index `2` is not supported by the instrument. The instrument `3` supports the following emission wavelengths: `4`. Please re-specify EmissionWavelength option accordingly.";
Error::UnspecifiedEmissionWavelength="The EmissionWavelength option at index `1` cannot be Null when fluorescence imaging mode is selected. Please change the Mode option or leave the EmissionWavelength option to be set automatically.";
Warning::MismatchedEmissionWavelength="The specified EmissionWavelength option `1` at index `2` does not match the emission wavelength of the following molecules in DetectionLabels option: `3`. No action is needed if this is intentional.";
Error::UnsupportedWavelengthCombination="The following ExcitationWavelength and EmissionWavelength combination at index `1` does not match any combinations supported by the instrument: `2`. The instrument `3` supports the following {ExcitationWavelength,EmissionWavelength} combinations: `4`. Alternatively, ExcitationWavelength and EmissionWavelength can be set automatically to a supported combination when specifying ImagingChannel option as one of the following values: `5`.";
Error::UnspecifiedExcitationPower="The ExcitationPower option at index `1` cannot be Null when fluorescence imaging mode is selected. Please change the option value or leave the ExcitationPower option to be set automatically.";
Error::UnresolvableDichroicFilterWavelength="The DichroicFilterWavelength option at index `1` cannot be determined because the instrument does not support the following ExcitationWavelength and EmissionWavelength combinations: `2`. The instrument `3` supports the following {ExcitationWavelength,EmissionWavelength,DichroicFilterWavelength} combinations: `4`. Alternatively, DichroicFilterWavelengths can be set automatically to a supported value when specifying ImagingChannel option as one of the following values: `5`.";
Error::UnspecifiedDichroicFilterWavelength="The DichroicFilterWavelength option at index `1` cannot be Null when fluorescence imaging mode is selected. Please change the Mode option or leave the DichroicFilterWavelength option to be set automatically.";
Error::MismatchedDichroicFilterWavelength="The DichroicFilterWavelength option at index `1` does not match any of the ExcitationWavelngth/EmissionWavelength/DichroicFilterWavelength combinations supported by the instrument: `2`. The instrument `3` supports the following {ExcitationWavelength,EmissionWavelength,DichroicFilterWavelength} combinations: `4`. Alternatively, DichroicFilterWavelengths can be set automatically to a supported value when specifying ImagingChannel option as one of the following values: `5`.";
Error::UnsupportedDichroicFilterWavelength="The specified DichroicFilterWavelength option `1` at index `2` is not supported by the instrument. The instrument `3` supports the following dichroic filter wavelength: `4`. Please change DichroicFilterWavelength option accordingly.";
Error::TransmittedLightPowerNotAllowed="The TransmittedLightPower option at index `1` must be Null when the following Mode is used: `2`.";
Error::TransmittedLightColorCorrectionNotAllowed="The TransmittedLightColorCorrection option at index `1` must be Null when the following Mode is used: `2`.";
Warning::UndetectableFluorescentDetectionLabels="Mode `1` will not be able to detect the following fluorescent molecules specified in DetectionLabels option at index `2`: `3`. Please select the following Mode to allow detection of fluorescent DetectionLabels: `4`.";
Error::ExcitationWavelengthNotAllowed="The ExcitationWavelength option at index `1` must be Null when the following Mode is used: `2`.";
Error::EmissionWavelengthNotAllowed="The EmissionWavelength option at index `1` must be Null when the following Mode is used: `2`.";
Error::ExcitationPowerNotAllowed="The ExcitationPower option at index `1` must be Null when the following Mode is used: `2`.";
Error::DichroicFilterWavelengthNotAllowed="The DichroicFilterWavelength option at index `1` must be Null when the following Mode is used: `2`.";
Error::UnspecifiedTransmittedLightPower="The TransmittedLightPower option at index `1` cannot be Null when the following non-fluorescence imaging mode is selected: `2`. Please change the Mode option or leave the TransmittedLightPower option to be set automatically.";
Error::UnsupportedTransmittedLightColorCorrection="TransmittedLightColorCorrection option at index `1` cannot be set to True because the following instrument does not support this feature: `2`. Please select a new instrument or leave the TransmittedLightColorCorrection option to be set automatically.";
Error::UnsupportedImageCorrection="The following specified ImageCorrection option at index `1` is not supported by the instrument: `2`. Please correct the ImageCorrection option or select a different instrument. The instrument `3` supports the following image correction methods: `4`.";
Error::UnsupportedImageDeconvolution="ImageDeconvolution option at index `1` cannot be set to True because the following instrument does not support this feature: `2`. Please select a new instrument or leave the ImageDeconvolution option to be set automatically.";
Error::ConflictingImageDeconvolutionOptions="The ImageDeconvolution and ImageDeconvolutionKFactor options at index `1` are conflicting. ImageDeconvolutionKFactor must be specified when ImageDeconvolution is True, and must be Null when ImageDeconvolution is False. Please correct the options accordingly or leave ImageDeconvolutionKFactor option to be set automatically.";
Error::UnsupportedAutofocus="FocalHeight option at index `1` cannot be set to Autofocus because the following instrument cannot determine focal height automatically: `2`. Please select a new instrument, specify FocalHeight as a distance, or leave the FocalHeight option to be set automatically.";
Error::InvalidObjectiveMagnification="The specified FocalHeight option at index `1` cannot be verified because the instrument does not contain objective lenses with magnification `2`. The instrument `3` contains objective lenses with the following magnifications: `4`. Please change the ObjectiveMagnification option accordingly or leave the FocalHeight option to be set automatically.";
Error::InvalidFocalHeight="The following specified FocalHeight option at index `1` exceeds the maximum working distance of the selected instrument's objective: `2`. The objective `3` has a maximum working distance of `4`. Please change the option value accordingly or leave the FocalHeight option to be set automatically.";
Error::InvalidExposureTime="The following specified ExposureTime option at index `1` is not within range supported by the instrument: `2`. Please specify value between `3` and `4` or leave the ExposureTime option to be set automatically.";
Error::InvalidTargetMaxIntensity="The following specified TargetMaxIntensity option at index `1` is not within range supported by the instrument: `2`. Please specify value below `3` or leave the TargetMaxIntensity option to be set automatically.";
Error::TargetMaxIntensityNotAllowed="The following specified TargetMaxIntensity option at index `1` must be set to Null when ExposureTime is not AutoExpose: `2`. Please correct the option value accordingly or leave the TargetMaxIntensity to be set automatically.";
Error::UnspecifiedTimelapseImageCollection="The TimelapseImageCollection option at index `1` cannot be Null when Timelapse option is set to True. Please correct the option value or leave the TimelapseImageCollection option to be set automatically.";
Error::TimelapseImageCollectionNotAllowed="The TimelapseImageCollection option at index `1` must be Null when Timelapse option is set to False. Please correct the option value or leave the TimelapseImageCollection option to be set automatically.";
Error::InvalidTimelapseImageCollection="The following specified TimelapseImageCollection option at index `1` is higher than NumberOfTimepoints option: `2`. Please specify value below `3` or leave the TimelapseImageCollection to be set automatically.";
Error::ZStackImageCollectionNotAllowed="The ZStackImageCollection option at index `1` cannot be True when ZStack option is set to False. Please correct the option value or leave the ZStackImageCollection option to be set automatically.";
Error::ConflictingModeAndImagingChannel="The following Mode and ImagingChannel options at index `1` are conflicting: `2`. If fluorescent channel `3` is selected, only the following Mode can be used: `4`. If non-fluorescent channel `5` is selected, only the following Mode can be used: `6`. Please correct the ImagingChannel and Mode option value or leave either of the options to be set automatically.";
Error::CustomChannelNotAllowed="The ImagingChannel at index `1` cannot be set to CustomChannel. Please change the option value to any of the following channels or leave the ImagingChannel option to be set automatically: `2`.";
Error::ConflictingImagingChannelOptions="The following options at index `1` are conflicting with the ImagingChannel option: `2`. If the ImagingCannel option is specified, the following options must be Automatic: {ExcitationWavelength, EmissionWavelength, ExcitationPower, DichroicFilterWavelength, TransmittedLightPower}. Please correct the option values or leave the ImagingChannel option to be set automatically.";
Error::UnsupportedImagingChannel="The following specified ImagingChannel option at index `1` is not supported by the instrument: `2`. The instrument `3` supports the following imaging channels: `4`. Please correct the option value, select a different instrument, or leave the ImagingChannel option to be set automatically.";
Error::UnresolvableModeWithChannel="The Mode option at index `1` cannot be determined because the instrument's supported Mode cannot be used to acquire images with the specified ImagingChannel. Please select a different Instrument or leave the ImagingChannel option to be set automtically.";


(* ::Subsubsection:: *)
(* resolveAcquireImagePrimitive *)


resolveAcquireImagePrimitive[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		cache,outputSpecification,output,gatherTests,messages,listedSamples,safeOps,safeOpsTests,validLengths,
		validLengthTests,expandedSafeOps,simulation,instrument,resolvedInstrument,cacheBall,resolvedOptions,resolvedAcquireImagePrimitives,
		optionsToPackage,modelInstrumentFields,modelObjectiveFields,detectionLabelFields,instrumentDownloadPacket,objectiveDownloadPacket,
		samplePackets,sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets,detectionLabelOptionPackets,instrumentModelPacket,
		objectiveModelPackets,uniquePrimitiveDetectionLabels,resolvedOptionsTests,primitiveOption,acquireImagePrimitiveOptionNames,
		conflictingPrimitiveOptions,conflictingPrimitiveOptionsTest,optionsFromPrimitives,updatedOptions,allSampleDetectionLabelPackets,
		detectionLabelsSpecifiedQ,preResolvedDetectionLabels,optionsToExpand,resolvedAcquireImageAssociations,updatedAcquireImageAssociations,
		timelapseOption,numOfTimepointsOption,missingNumOfTimepointsQ,missingNumOfTimepointsTest, safeOpsNamed
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* ---check for conflicting Primitive option---*)

	(* get the primitive option value *)
	primitiveOption=Lookup[ToList[myOptions],Primitive,{}];

	(* get the option names for acquireImagePrimitiveOptions *)
	acquireImagePrimitiveOptionNames=ToExpression@Keys[Options[acquireImagePrimitiveOptions]];

	(* if Primitive option is not {}, get the acquireImagePrimitiveOptions option names that are specified *)
	conflictingPrimitiveOptions=If[!MatchQ[primitiveOption,{}],
		(* get any acquireImagePrimitiveOptions option names that are specified *)
		Intersection[Keys@ToList[myOptions],acquireImagePrimitiveOptionNames],
		(* else: return an empty list *)
		{}
	];

	(* if we are throwing messages, throw an error message *)
	If[!MatchQ[conflictingPrimitiveOptions,{}]&&!gatherTests,
		Message[Error::ConflictingPrimitiveOptions,conflictingPrimitiveOptions]
	];

	(* create a test if we are gathering tests *)
	conflictingPrimitiveOptionsTest=If[gatherTests,
		Test["If Primitive options is provided, the following options must not be specified "<>ToString[acquireImagePrimitiveOptionNames]<>":",
			MatchQ[conflictingPrimitiveOptions,{}],
			True
		],
		{}
	];

	(* If the any of acquireImagePrimitiveOptions are specified when Primitive option is given, return $Failed *)
	If[!MatchQ[conflictingPrimitiveOptions,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->{conflictingPrimitiveOptionsTest},
			Options->$Failed,
			Preview->Null
		}]
	];

	(* ---check conflicting timelapse options--- *)
	(* if Timelapse is True, NumberOfTimepoints must be specified and cannot be Null *)

	(* get the Timelapse and NumberOfTimepoints option values from raw options *)
	{timelapseOption,numOfTimepointsOption}=Lookup[ToList[myOptions],{Timelapse,NumberOfTimepoints}];

	(* check if NumberOfTimepoints is specified if Timelapse is True *)
	missingNumOfTimepointsQ=TrueQ[timelapseOption]&&MatchQ[numOfTimepointsOption,Null|_Missing];

	(* if we are throwing messages, throw an error message *)
	If[missingNumOfTimepointsQ&&!gatherTests,
		Message[Error::MissingNumberOfTimepoints,conflictingPrimitiveOptions]
	];

	(* create a test if we are gathering tests *)
	missingNumOfTimepointsTest=If[gatherTests,
		Test["If Timelapse option is True, NumberOfTimepoints must be specified:",
			missingNumOfTimepointsQ,
			False
		],
		{}
	];

	(* if missingNumOfTimepointsQ is True, return $Failed *)
	If[missingNumOfTimepointsQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->{conflictingPrimitiveOptionsTest,missingNumOfTimepointsTest},
			Options->$Failed,
			Preview->Null
		}]
	];

	(* extract all keys values from the specified primitive and put them in a listed option format *)
	optionsFromPrimitives=If[!MatchQ[primitiveOption,{}],
		Module[{primitiveAssociations,mergedPrimitiveAssociation},
			(* convert all primitives to Association for easy handling *)
			primitiveAssociations=Apply[Association,#]&/@primitiveOption;
			(* merge all associations while keeping the index. unspecified key will show up as Missing *)
			mergedPrimitiveAssociation=Merge[KeyUnion[primitiveAssociations],Join];
			(* replace all Missing value with default option value *)
			KeyValueMap[
				With[{defaultValue=OptionDefault[OptionValue[acquireImagePrimitiveOptions,#1]]},
					#1->(#2/._Missing->defaultValue)
				]&,
				mergedPrimitiveAssociation
			]
		],
		(* else: return empty list *)
		{}
	];

	(* update our specified options *)
	updatedOptions=ReplaceRule[ToList[myOptions],optionsFromPrimitives];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[resolveAcquireImagePrimitive,updatedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[resolveAcquireImagePrimitive,updatedOptions,AutoCorrect->False],{}}
	];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples,safeOps}=sanitizeInputs[ToList[mySamples],safeOpsNamed,Simulation->Lookup[safeOpsNamed,Simulation]];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,conflictingPrimitiveOptionsTest,missingNumOfTimepointsTest}],
			Options->$Failed,
			Preview->Null
		}]
	];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[resolveAcquireImagePrimitive,{listedSamples},safeOps,Output->{Result,Tests}],
		{ValidInputLengthsQ[resolveAcquireImagePrimitive,{listedSamples},safeOps],{}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,conflictingPrimitiveOptionsTest,missingNumOfTimepointsTest}],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Lookup our cache *)
	cache=Lookup[safeOps,Cache];

	(* Lookup our given simulation. *)
	simulation=Lookup[safeOps,Simulation];

	(* ---GATHER ALL OBJECTS TO DOWNLOAD--- *)

	(* get the instrument option *)
	instrument=Lookup[safeOps,Instrument];

	(* resolve Instrument option *)
	(* note: we share this option with ExperimentImageCells so we need to resolve it if it's Automatic *)
	resolvedInstrument=If[!MatchQ[instrument,Automatic],
		instrument,
		(* TODO: make sure this is correct when primitive resolver is finished. include Modes as our search condition *)
		First@Search[Model[Instrument,Microscope],HighContentImaging==True]
	];

	(* get the objects specified as DetectionLabels key in Primitive option *)
	uniquePrimitiveDetectionLabels=DeleteDuplicates@Cases[Lookup[safeOps,DetectionLabels],ObjectP[],Infinity];

	(* ---GATHER ALL FIELDS TO DOWNLOAD--- *)

	(* create a sequence of fields to download from model instrument *)
	modelInstrumentFields=Sequence[Name,Objects,Autofocus,CustomizableImagingChannel,DefaultExcitationPowers,
		DefaultImageCorrections,DefaultTransmittedLightPower,DichroicFilterWavelengths,FluorescenceEmissionWavelengths,
		FluorescenceExcitationWavelengths,ImageCorrectionMethods,ImageDeconvolution,ImagingChannels,Modes,Objectives,
		MaxImagingChannels,TransmittedLightColorCorrection,MinExposureTime,MaxExposureTime,DefaultTargetMaxIntensity,MaxGrayLevel];

	(* create a sequence of fields to download from objective model *)
	modelObjectiveFields=Sequence[Name,Magnification,MaxWorkingDistance];

	(* create a sequence of fields to download from detection labels (Model[Molecule]) *)
	detectionLabelFields=Sequence[Name,DetectionLabel,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums];

	(* get the instrument and objective packets to download based on object type *)
	{instrumentDownloadPacket,objectiveDownloadPacket}=If[MatchQ[Lookup[safeOps,Instrument],ObjectP[Model[Instrument]]],
		(* if specified as a model, download from model fields *)
		{
			Packet[modelInstrumentFields],
			Packet[Objectives[{modelObjectiveFields}]]
		},
		(* else: specified as object, link to model and download from model fields *)
		{
			Packet[Model[{modelInstrumentFields}]],
			Packet[Model[Objectives][{modelObjectiveFields}]]
		}
	];

	(* download the necessary information about our samples and instrument *)
	{
		samplePackets,
		sampleDetectionLabelPackets,
		sampleIdentityModelDetectionLabelPackets,
		detectionLabelOptionPackets,
		objectiveModelPackets,
		{{instrumentModelPacket}}
	}=Quiet[
		Download[
			{
				listedSamples,
				listedSamples,
				listedSamples,
				uniquePrimitiveDetectionLabels,
				{resolvedInstrument},
				{resolvedInstrument}
			},
			Evaluate[{
				{
					Packet[Name,Model,Composition]
				},
				{
					Packet[Field[Composition[[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[Field[Model[Composition][[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[detectionLabelFields]
				},
				{
					objectiveDownloadPacket
				},
				{
					instrumentDownloadPacket
				}
			}],
			Cache->cache,
			Simulation->simulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* combine all downloaded packages into cacheBall *)
	cacheBall=FlattenCachePackets[{samplePackets,sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets,detectionLabelOptionPackets,objectiveModelPackets,instrumentModelPacket}];

	(* combine detection label packets downloaded from our samples *)
	allSampleDetectionLabelPackets=FlattenCachePackets[{sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets}];

	(* pre-resolve DetectionLabels by setting it to a list of DetectionLabel objects found *)
	(* in sample's identity model and sample's model if the following criteria are met: *)
	(* 1. Primitive options is {} *)
	(* 2. DetectionLabels option is not specified by the user *)

	(* check if DetectionLabels option is specified *)
	detectionLabelsSpecifiedQ=MemberQ[Keys@updatedOptions,DetectionLabels];

	(* pre-resolve our DetectionLabels option *)
	preResolvedDetectionLabels=If[MatchQ[primitiveOption,{}]&&!detectionLabelsSpecifiedQ,
		Module[{detectionLabelsFluorescentQs,nestedDetectionLabelObjects},
			(* check if samples' detection labels are fluorescent *)
			detectionLabelsFluorescentQs=If[MatchQ[allSampleDetectionLabelPackets,{}],
				(* default to False since we don't have any detection labels *)
				{False},
				(* else: check if detectionLabelsToUse are fluorescent *)
				TrueQ/@Lookup[allSampleDetectionLabelPackets,Fluorescent]
			];

			(* lookup detection label objects from packet and put in in a nested list format *)
			nestedDetectionLabelObjects=List/@Flatten[Lookup[allSampleDetectionLabelPackets,Object,{}]];

			(* do we have any non-fluorescent label? *)
			If[And@@detectionLabelsFluorescentQs,
				(* all our labels are fluorescent, append a Null to a list to create a non-fluorescent imaging channel *)
				Append[nestedDetectionLabelObjects,Null],
				(* else: return all detection labels found in our samples *)
				nestedDetectionLabelObjects
			]
		],
		(* else: DetectionLabels is specified, don't pre-resolve *)
		{}
	];

	(* replace DetectionaLabels option if preResolvedDetectionLabels is not an empty list and none of acquireImagePrimitiveOptions are specified *)
	optionsToExpand=If[!MatchQ[preResolvedDetectionLabels,{}]&&MatchQ[Intersection[Keys@ToList[myOptions],acquireImagePrimitiveOptionNames],{}],
		ReplaceRule[safeOps,DetectionLabels->preResolvedDetectionLabels],
		(* else: return safeOps unchanged *)
		safeOps
	];

	(* Expand index-matching options *)
	(* note: we expand our safe options here because we may need to pre-resolve our index-matching parent, DetectionLabels, and replace it prior to expanding *)
	expandedSafeOps=Last@ExpandIndexMatchedInputs[
		resolveAcquireImagePrimitive,
		{listedSamples},
		optionsToExpand
	];

	(* Build the resolved options *)
	{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
		resolveAcquireImagePrimitiveOptions[listedSamples,ReplaceRule[expandedSafeOps,Instrument->resolvedInstrument],Cache->cacheBall,Simulation->simulation,Output->{Result,Tests}],
		{resolveAcquireImagePrimitiveOptions[listedSamples,ReplaceRule[expandedSafeOps,Instrument->resolvedInstrument],Cache->cacheBall,Simulation->simulation,Output->Result],{}}
	];

	(* get only the options that will be packaged into AcquireImage primitive *)
	optionsToPackage=KeyTake[resolvedOptions,acquireImagePrimitiveOptionNames];

	(* package our resolved options into individual AcquireImage primitives *)
	resolvedAcquireImageAssociations=Map[
		AssociationThread[Keys[optionsToPackage],#]&,
		Transpose@Values[optionsToPackage]
	];

	(* if Primitive option is not supplied, we will check if there are any identical channels we can combine into a single primitive *)
	(* we do this so that we don't resolve to multiple channels that will be imaged with the exact same parameters *)
	(* note: identical channels share the exact same values for all keys except DetectionLabels *)
	updatedAcquireImageAssociations=If[MatchQ[primitiveOption,{}],
		Module[{gatheredIdenticalAssociations,mergeFunction},
			(* gather identical associations by similar values except for DetectionLabels key *)
			gatheredIdenticalAssociations=GatherBy[resolvedAcquireImageAssociations,KeyDrop[#,DetectionLabels]&];

			(* create a function to use when merging identical associations *)
			mergeFunction=Function[mergedKeyValues,Module[{valueNoDupes},
				(* remove duplicates members *)
				valueNoDupes=DeleteDuplicates[mergedKeyValues];
				(* are there multiple values in the merged key value list? *)
				If[Length[valueNoDupes]>1,
					(* this is the case for DetectionLabels only since other keys have identical values, return all members except Null *)
					DeleteCases[valueNoDupes,Null],
					(* else: all other keys with identical values, return only the value *)
					First@valueNoDupes
				]
			]];

			(* merge the gathered associations using our merge function *)
			Merge[#,mergeFunction]&/@gatheredIdenticalAssociations
		],
		(* else: the user specified primitives, we leave resolved primitives untouched *)
		resolvedAcquireImageAssociations
	];

	(* convert all associations into AcquireImage primitives *)
	(* FIXIME: temp fix to exclude ImagingChannel key because we decided not to use it *)
	resolvedAcquireImagePrimitives=AcquireImage[KeyDrop[#,ImagingChannel]]&/@updatedAcquireImageAssociations;

	(* Return requested output *)
	outputSpecification/.{
		Result->resolvedAcquireImagePrimitives,
		Options->RemoveHiddenOptions[resolveAcquireImagePrimitive,resolvedOptions],
		Tests->Flatten[{
			safeOpsTests,
			validLengthTests,
			resolvedOptionsTests,
			conflictingPrimitiveOptionsTest,
			missingNumOfTimepointsTest
		}],
		Preview->Null
	}
];


(* ::Subsubsection:: *)
(* resolveAcquireImagePrimitiveOptions *)


DefineOptions[
	resolveAcquireImagePrimitiveOptions,
	Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

resolveAcquireImagePrimitiveOptions[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[]
]:=Module[
	{
		outputSpecification,output,listedSamples,gatherTests,messages,notInEngine,cache,simulation,acquireImageOptionsAssociation,
		modelObjectiveFields,mapFriendlyOptions,instrument,uniquePrimitiveDetectionLabels,modelInstrumentFields,detectionLabelFields,
		objectiveModelPackets,instrumentDownloadPacket,samplePackets,sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets,
		detectionLabelOptionPackets,instrumentModelPacket,newCache,detectionLabelFromSamplePackets,samplesDetectionLabels,
		optionsForRounding,valuesToRoundTo,roundedAcquireImageOptions,optionsToResolve,detectionLabelsTracking,objectiveDownloadPacket,
		objectiveMagnification,objectiveModelPacketToUse,invalidOptions,resolvedOptions,allTests,

		(* map variables *)
		overlappingDetectionLabels,undetectableNonFluorescentLabels,unresolvevableDetectionLabels,undetectableFluorescentLabels,
		conflictingImagingChannelOptionNames,

		(* error-tracking variables *)
		unsupportedModeErrors,detectionLabelInUseWarnings,fluorescenceImagingNotSupportedWarnings,brightFieldImagingNotSupportedWarnings,
		unresolvableModeErrors,undetectableNonFluorescentLabelWarnings,unresolvableExcitationWavelengthWarnings,
		multipleExcitationWavelengthsWarnings,excitationOutOfRangeWarnings,unsupportedExcitationWavelengthErrors,
		mismatchedExcitationWavelengthWarnings,unresolvableEmissionWavelengthWarnings,multipleEmissionWavelengthsWarnings,
		emissionOutOfRangeWarnings,unsupportedEmissionWavelengthErrors,mismatchedEmissionWavelengthWarnings,
		invalidEmissionWavelengthChannelErrors,unresolvableDichroicFilterWavelengthErrors,mistmatchDichroicFilterWavelengthErrors,
		unsupportedDichroicFilterWavelengthErrors,notAllowedTransmittedLightPowerErrors,notAllowedTransmittedLightColorCorrectionErrors,
		undetectableFluorescentLabelWarnings,notAllowedExcitationWavelengthErrors,notAllowedEmissionWavelengthErrors,
		notAllowedExcitationPowerErrors,notAllowedDichroicFilterWavelengthErrors,colorCorrectionNotSupportedErrors,
		detectionLabelsNotSpecifiedWarnings,transmittedLightPowerNotSpecifiedErrors,excitationWavelengthNotSpecifiedErrors,
		emissionWavelengthNotSpecifiedErrors,excitationPowerNotSpecifiedErrors,dichroicFilterWavelengthNotSpecifiedErrors,
		unsupportedImageCorrectionErrors,unsupportedImageDeconvolutionErrors,mismatchedImageDeconvolutionOptionsErrors,
		unsupportedAutofocusErrors,invalidFocalHeightErrors,maxWorkingDistanceNotFoundErrors,invalidExposureTimeErrors,
		invalidTargetMaxIntensityErrors,notAllowedTargetMaxIntensityErrors,unspecifiedTimelapseImageCollectionErrors,
		notAllowedTimelapseImageCollectionErrors,invalidTimelapseImageCollectionErrors,notAllowedZStackImageCollectionErrors,
		conflictingModeAndChannelErrors,customChannelNotAllowedErrors,conflictingImagingChannelsAndOptionsErrors,
		unsupportedImagingChannelErrors,unresolvableModeWithChannelErrors,

		(* resolved options variables *)
		resolvedModes,resolvedDetectionLabels,resolvedExcitationWavelengths,resolvedEmissionWavelengths,resolvedExcitationPowers,
		resolvedDichroicFilterWavelengths,resolvedTransmittedLightPowers,resolvedTransmittedLightColorCorrections,
		resolvedImageCorrections,resolvedImageDeconvolutionKFactors,resolvedFocalHeights,resolvedTargetMaxIntensities,
		resolvedTimelapseImageCollections,resolvedZStackImageCollections,resolvedImagingChannels,

		(* invalid options variables *)
		modeInvalidOptions,unresolvableModeOptions,unsupportedExcitationWavelengthOptions,unspecifiedExcitationWavelengthOptions,
		unsupportedEmissionWavelengthOptions,unspecifiedEmissionWavelengthOptions,invalidEmissionWavelengthChannelOptions,
		unspecifiedExcitationPowerOptions,unresolvableDichroicFilterWavelengthOptions,unspecifiedDichroicFilterWavelengthOptions,
		mismatchedDichroicFilterWavelengthOptions,unsupportedDichroicFilterWavelengthOptions,notAllowedTransmittedLightPowerOptions,
		notAllowedTransmittedLightColorCorrectionOptions,notAllowedExcitationWavelengthOptions,notAllowedEmissionWavelengthOptions,
		notAllowedExcitationPowerOptions,notAllowedDichroicFilterWavelengthOptions,unspecifiedTransmittedLightPowerOptions,
		unsupportedTransmittedLightColorCorrectionOptions,unsupportedImageCorrectionOptions,unsupportedImageDeconvolutionOptions,
		conflictingImageDeconvolutionOptions,unsupportedAutofocusOptions,invalidObjectiveMagnificationOptions,invalidFocalHeightOptions,
		invalidExposureTimeOptions,invalidTargetMaxIntensityOptions,notAllowedTargetMaxIntensityOptions,unspecifiedTimelapseImageCollectionOptions,
		notAllowedTimelapseImageCollectionOptions,invalidTimelapseImageCollectionOptions,notAllowedZStackImageCollectionOptions,
		conflictingModeAndImagingChannelOptions,notAllowedCustomChannelOptions,conflictingImagingChannelOptions,
		unsupportedImagingChannelOptions,unresolvableModeWithChannelOptions,

		(* tests variables *)
		precisionTests,unsupportedModeTest,overlappingDetectionLabelsTest,cannotImageFluorescenceTest,cannotImageNonFluorescentTest,
		unresolvableModeTest,undetectableNonFluorescentLabelTest,detectionLabelsNotSpecifiedTest,unresolvableExcitationWavelengthTest,
		multipleExcitationWavelengthsTest,excitationOutOfRangeTest,unsupportedExcitationWavelengthTest,unspecifiedExcitationWavelengthTest,
		mismatchedExcitationTest,unresolvableEmissionWavelengthTest,multipleEmissionWavelengthsTest,emissionOutOfRangeTest,
		unsupportedEmissionWavelengthTest,unspecifiedEmissionWavelengthTest,mismatchedEmissionTest,invalidEmissionWavelengthChannelTest,
		unspecifiedExcitationPowerTest,unresolvableDichroicFilterWavelengthTest,unspecifiedDichroicFilterWavelengthTest,
		mismatchedDichroicFilterWavelengthTest,unsupportedDichroicFilterWavelengthTest,notAllowedTransmittedLightPowerTest,
		notAllowedTransmittedLightColorCorrectionTest,undetectableFluorescentLabelTest,notAllowedExcitationWavelengthTest,
		notAllowedEmissionWavelengthTest,notAllowedExcitationPowerTest,notAllowedDichroicFilterWavelengthTest,
		unspecifiedTransmittedLightPowerTest,unsupportedTransmittedLightColorCorrectionTest,unsupportedImageCorrectionTest,
		unsupportedImageDeconvolutionTest,conflictingImageDeconvolutionOptionsTest,unsupportedAutofocusTest,invalidObjectiveMagnificationTest,
		invalidFocalHeightTest,invalidExposureTimeTest,invalidTargetMaxIntensityTest,notAllowedTargetMaxIntensityTest,
		unspecifiedTimelapseImageCollectionTest,notAllowedTimelapseImageCollectionTest,invalidTimelapseImageCollectionTest,
		notAllowedZStackImageCollectionTest,conflictingModeAndImagingChannelOptionsTest,notAllowedCustomChannelTest,
		conflictingImagingChannelTest,unsupportedImagingChannelTest,unresolvableModeWithChannelTest
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* make sure we are working with a list of samples *)
	listedSamples=ToList[mySamples];

	(* Determine if we should keep a running list of tests to return to the user *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=!MatchQ[$ECLApplication,Engine];

	(* Fetch our cache and simulation from the parent function. *)
	{cache,simulation}=Lookup[ToList[myResolutionOptions],{Cache,Simulation}];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	acquireImageOptionsAssociation=Association[myOptions];

	(* --------------- *)
	(* --- DOWNLOAD--- *)
	(* --------------- *)

	(* ---GATHER ALL OBJECTS TO DOWNLOAD--- *)

	(* get the instrument option *)
	instrument=Lookup[acquireImageOptionsAssociation,Instrument];

	(* get the objects specified as DetectionLabels key in Primitive option *)
	uniquePrimitiveDetectionLabels=DeleteDuplicates@Cases[ToList@Lookup[acquireImageOptionsAssociation,DetectionLabels],ObjectP[],Infinity];

	(* ---GATHER ALL FIELDS TO DOWNLOAD--- *)

	(* create a sequence of fields to download from model instrument *)
	modelInstrumentFields=Sequence[Name,Objects,Autofocus,CustomizableImagingChannel,DefaultExcitationPowers,
		DefaultImageCorrections,DefaultTransmittedLightPower,DichroicFilterWavelengths,FluorescenceEmissionWavelengths,
		FluorescenceExcitationWavelengths,ImageCorrectionMethods,ImageDeconvolution,ImagingChannels,Modes,Objectives,
		MaxImagingChannels,TransmittedLightColorCorrection,MinExposureTime,MaxExposureTime,DefaultTargetMaxIntensity,MaxGrayLevel];

	(* create a sequence of fields to download from objective model *)
	modelObjectiveFields=Sequence[Name,Magnification,MaxWorkingDistance];

	(* create a sequence of fields to download from detection labels (Model[Molecule]) *)
	detectionLabelFields=Sequence[Name,DetectionLabel,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums];

	(* get the instrument packets to download based on object type *)
	{instrumentDownloadPacket,objectiveDownloadPacket}=If[MatchQ[instrument,ObjectReferenceP[Model[Instrument]]],
		(* if specified as a model, download from model fields *)
		{
			Packet[modelInstrumentFields],
			Packet[Objectives[{modelObjectiveFields}]]
		},
		(* else: specified as object, link to model and download from model fields *)
		{
			Packet[Model[{modelInstrumentFields}]],
			Packet[Model[Objectives][{modelObjectiveFields}]]
		}
	];

	(* download the necessary information about our samples and instrument *)
	{
		samplePackets,
		sampleDetectionLabelPackets,
		sampleIdentityModelDetectionLabelPackets,
		detectionLabelOptionPackets,
		objectiveModelPackets,
		{{instrumentModelPacket}}
	}=Quiet[
		Download[
			{
				listedSamples,
				listedSamples,
				listedSamples,
				uniquePrimitiveDetectionLabels,
				{instrument},
				{instrument}
			},
			Evaluate[{
				{
					Packet[Name,Model,Composition]
				},
				{
					Packet[Field[Composition[[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[Field[Model[Composition][[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[detectionLabelFields]
				},
				{
					objectiveDownloadPacket
				},
				{
					instrumentDownloadPacket
				}
			}],
			Cache->cache,
			Simulation->simulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* combine packets into cache ball *)
	newCache=FlattenCachePackets[{samplePackets,sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets,detectionLabelOptionPackets,instrumentModelPacket}];

	(* combine all detection label packets from samples *)
	detectionLabelFromSamplePackets=FlattenCachePackets[{sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets}];

	(* get the detection label objects we downloaded from our samples *)
	samplesDetectionLabels=Flatten@Lookup[detectionLabelFromSamplePackets,Object,{}];

	(* get the ObjectiveMagnification option *)
	objectiveMagnification=If[MatchQ[Lookup[acquireImageOptionsAssociation,ObjectiveMagnification],Automatic],
		(* if Automatic, set to the instrument's lowest magnification *)
		Min@Lookup[Flatten@objectiveModelPackets,Magnification],
		(* else: return the specified value *)
		Lookup[acquireImageOptionsAssociation,ObjectiveMagnification]
	];

	(* get the objective model packet based on our ObjectiveMagnification option *)
	objectiveModelPacketToUse=FirstCase[Flatten@objectiveModelPackets,KeyValuePattern[Magnification->N@objectiveMagnification]];

	(* ----------------------------- *)
	(* ---OPTION PRECISION CHECKS--- *)
	(* ----------------------------- *)

	(* make a list of options to round *)
	optionsForRounding={
		(*01*)FocalHeight,
		(*02*)ExposureTime,
		(*03*)TargetMaxIntensity,
		(*04*)ExcitationWavelength,
		(*05*)EmissionWavelength,
		(*06*)ExcitationPower,
		(*07*)DichroicFilterWavelength,
		(*08*)ImageDeconvolutionKFactor,
		(*09*)TransmittedLightPower,
		(*10*)NumberOfTimepoints
	};

	(* make list of values to round to, index matched to option list *)
	valuesToRoundTo={
		(*01*)1 Micrometer,
		(*02*)1 Millisecond,
		(*03*)1,
		(*04*)1 Nanometer,
		(*05*)1 Nanometer,
		(*06*)1 Nanometer,
		(*07*)1 Nanometer,
		(*08*)10^-3,
		(*09*)1 Percent,
		(*10*)1
	};

	{roundedAcquireImageOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[acquireImageOptionsAssociation,optionsForRounding,valuesToRoundTo,Output->{Result,Tests}],
		{RoundOptionPrecision[acquireImageOptionsAssociation,optionsForRounding,valuesToRoundTo],{}}
	];

	(* get only the shared options we want to resolve *)
	optionsToResolve=KeyTake[roundedAcquireImageOptions,ToExpression@Keys[Options[acquireImagePrimitiveOptions]]];

	(* convert our options into a Map friendly version. *)
	mapFriendlyOptions=Transpose@KeyValueMap[
		Function[{optionName,optionValues},
			If[MatchQ[optionName,DetectionLabels]&&!MatchQ[optionValues,{_List...}]&&!MemberQ[optionValues,Null|Automatic],
				{DetectionLabels->optionValues},
				(* expand key to match the length of values, transpose, and make rules *)
				Rule@@@Transpose[{
					ConstantArray[optionName,Length[ToList[optionValues]]],
					ToList[optionValues]
				}]
			]
		],
		optionsToResolve
	];

	(* ------------------------------------ *)
	(* ---resolve index-matching options--- *)
	(* ------------------------------------ *)

	(* create a list of DetectionLabels option values that we can manipulate while mapping over the options *)
	detectionLabelsTracking=Lookup[mapFriendlyOptions,DetectionLabels];

	(* map over our options and resolve each one *)
	{
		(* error tracking variables *)
		unsupportedModeErrors,
		detectionLabelInUseWarnings,
		fluorescenceImagingNotSupportedWarnings,
		brightFieldImagingNotSupportedWarnings,
		unresolvableModeErrors,
		undetectableNonFluorescentLabelWarnings,
		detectionLabelsNotSpecifiedWarnings,
		unresolvableExcitationWavelengthWarnings,
		multipleExcitationWavelengthsWarnings,
		excitationOutOfRangeWarnings,
		unsupportedExcitationWavelengthErrors,
		excitationWavelengthNotSpecifiedErrors,
		mismatchedExcitationWavelengthWarnings,
		unresolvableEmissionWavelengthWarnings,
		multipleEmissionWavelengthsWarnings,
		emissionOutOfRangeWarnings,
		unsupportedEmissionWavelengthErrors,
		emissionWavelengthNotSpecifiedErrors,
		mismatchedEmissionWavelengthWarnings,
		invalidEmissionWavelengthChannelErrors,
		excitationPowerNotSpecifiedErrors,
		unresolvableDichroicFilterWavelengthErrors,
		dichroicFilterWavelengthNotSpecifiedErrors,
		mistmatchDichroicFilterWavelengthErrors,
		unsupportedDichroicFilterWavelengthErrors,
		notAllowedTransmittedLightPowerErrors,
		notAllowedTransmittedLightColorCorrectionErrors,
		undetectableFluorescentLabelWarnings,
		notAllowedExcitationWavelengthErrors,
		notAllowedEmissionWavelengthErrors,
		notAllowedExcitationPowerErrors,
		notAllowedDichroicFilterWavelengthErrors,
		transmittedLightPowerNotSpecifiedErrors,
		colorCorrectionNotSupportedErrors,
		unsupportedImageCorrectionErrors,
		unsupportedImageDeconvolutionErrors,
		mismatchedImageDeconvolutionOptionsErrors,
		unsupportedAutofocusErrors,
		maxWorkingDistanceNotFoundErrors,
		invalidFocalHeightErrors,
		invalidExposureTimeErrors,
		invalidTargetMaxIntensityErrors,
		notAllowedTargetMaxIntensityErrors,
		unspecifiedTimelapseImageCollectionErrors,
		notAllowedTimelapseImageCollectionErrors,
		invalidTimelapseImageCollectionErrors,
		notAllowedZStackImageCollectionErrors,
		conflictingModeAndChannelErrors,
		customChannelNotAllowedErrors,
		conflictingImagingChannelsAndOptionsErrors,
		unsupportedImagingChannelErrors,
		unresolvableModeWithChannelErrors,

		(* error objects variable *)
		overlappingDetectionLabels,
		undetectableNonFluorescentLabels,
		unresolvevableDetectionLabels,
		undetectableFluorescentLabels,
		conflictingImagingChannelOptionNames,

		(*Resolved option values*)
		resolvedModes,
		resolvedDetectionLabels,
		resolvedExcitationWavelengths,
		resolvedEmissionWavelengths,
		resolvedExcitationPowers,
		resolvedDichroicFilterWavelengths,
		resolvedTransmittedLightPowers,
		resolvedTransmittedLightColorCorrections,
		resolvedImageCorrections,
		resolvedImageDeconvolutionKFactors,
		resolvedFocalHeights,
		resolvedTargetMaxIntensities,
		resolvedTimelapseImageCollections,
		resolvedZStackImageCollections,
		resolvedImagingChannels
	}=Transpose[MapIndexed[
		Function[{myMapOptions,index},
			Module[
				{
					supportedModes,inUseDetectionLabels,overlappingDetectionLabel,undetectableNonFluorescentLabel,
					undetectableFluorescentLabel,supportedCorrectionMethods,imageDeconvolutionSupportedQ,autofocusQ,
					timelapseQ,zStackQ,instrumentImagingChannelTuples,optionValuesToCheckLookup,supportedImagingChannels,
					unresolvevableDetectionLabel,fluorescenceOptionValues,fluorescenceOptionsSpecifiedQ,conflictingImagingChannelOptionName,

					(* Error-tracking variables *)
					unsupportedModeError,detectionLabelInUseWarning,fluorescenceImagingNotSupportedWarning,
					brightFieldImagingNotSupportedWarning,unresolvableModeError,undetectableNonFluorescentLabelWarning,
					unresolvableExcitationWavelengthWarning,multipleExcitationWavelengthsWarning,excitationOutOfRangeWarning,
					unsupportedExcitationWavelengthError,mismatchedExcitationWavelengthWarning,unresolvableEmissionWavelengthWarning,
					multipleEmissionWavelengthsWarning,emissionOutOfRangeWarning,unsupportedEmissionWavelengthError,
					mismatchedEmissionWavelengthWarning,invalidEmissionWavelengthChannelError,unresolvableDichroicFilterWavelengthError,mistmatchDichroicFilterWavelengthError,
					unsupportedDichroicFilterWavelengthError,notAllowedTransmittedLightPowerError,notAllowedTransmittedLightColorCorrectionError,
					undetectableFluorescentLabelWarning,notAllowedExcitationWavelengthError,notAllowedEmissionWavelengthError,
					notAllowedExcitationPowerError,notAllowedDichroicFilterWavelengthError,colorCorrectionNotSupportedError,
					detectionLabelsNotSpecifiedWarning,transmittedLightPowerNotSpecifiedError,
					excitationWavelengthNotSpecifiedError,emissionWavelengthNotSpecifiedError,excitationPowerNotSpecifiedError,
					dichroicFilterWavelengthNotSpecifiedError,unsupportedImageCorrectionError,unsupportedImageDeconvolutionError,
					mismatchedImageDeconvolutionOptionsError,unsupportedAutofocusError,maxWorkingDistanceNotFoundError,
					invalidFocalHeightError,invalidExposureTimeError,invalidTargetMaxIntensityError,notAllowedTargetMaxIntensityError,
					unspecifiedTimelapseImageCollectionError,notAllowedTimelapseImageCollectionError,invalidTimelapseImageCollectionError,
					notAllowedZStackImageCollectionError,conflictingModeAndChannelError,customChannelNotAllowedError,
					conflictingImagingChannelsAndOptionsError,unsupportedImagingChannelError,unresolvableModeWithChannelError,

					(* Specified option values *)
					mode,detectionLabels,focalHeight,exposureTime,
					targetMaxIntensity,timelapseImageCollection,excitationWavelength,emissionWavelength,excitationPower,
					dichroicFilterWavelength,imageCorrection,imageDeconvolution,imageDeconvolutionKFactor,
					transmittedLightPower,transmittedLightColorCorrection,zStackImageCollection,imagingChannel,
					preResolvedExcitationWavelength,preResolvedEmissionWavelength,preResolvedDichroicFilterWavelength,

					(* Resolved option values *)
					resolvedMode,resolvedDetectionLabel,resolvedExcitationWavelength,resolvedEmissionWavelength,
					resolvedExcitationPower,resolvedDichroicFilterWavelength,resolvedTransmittedLightPower,
					resolvedTransmittedLightColorCorrection,resolvedImageCorrection,resolvedImageDeconvolutionKFactor,
					resolvedFocalHeight,resolvedTargetMaxIntensity,resolvedTimelapseImageCollection,resolvedZStackImageCollection,
					resolvedImagingChannel
				},
				(*Initialize the error-tracking variables*)
				{
					unsupportedModeError,
					detectionLabelInUseWarning,
					fluorescenceImagingNotSupportedWarning,
					brightFieldImagingNotSupportedWarning,
					unresolvableModeError,
					undetectableNonFluorescentLabelWarning,
					detectionLabelsNotSpecifiedWarning,
					unresolvableExcitationWavelengthWarning,
					multipleExcitationWavelengthsWarning,
					excitationOutOfRangeWarning,
					unsupportedExcitationWavelengthError,
					excitationWavelengthNotSpecifiedError,
					mismatchedExcitationWavelengthWarning,
					unresolvableEmissionWavelengthWarning,
					multipleEmissionWavelengthsWarning,
					emissionOutOfRangeWarning,
					unsupportedEmissionWavelengthError,
					emissionWavelengthNotSpecifiedError,
					mismatchedEmissionWavelengthWarning,
					invalidEmissionWavelengthChannelError,
					excitationPowerNotSpecifiedError,
					unresolvableDichroicFilterWavelengthError,
					dichroicFilterWavelengthNotSpecifiedError,
					mistmatchDichroicFilterWavelengthError,
					unsupportedDichroicFilterWavelengthError,
					notAllowedTransmittedLightPowerError,
					notAllowedTransmittedLightColorCorrectionError,
					undetectableFluorescentLabelWarning,
					notAllowedExcitationWavelengthError,
					notAllowedEmissionWavelengthError,
					notAllowedExcitationPowerError,
					notAllowedDichroicFilterWavelengthError,
					transmittedLightPowerNotSpecifiedError,
					colorCorrectionNotSupportedError,
					unsupportedImageCorrectionError,
					unsupportedImageDeconvolutionError,
					mismatchedImageDeconvolutionOptionsError,
					unsupportedAutofocusError,
					maxWorkingDistanceNotFoundError,
					invalidFocalHeightError,
					invalidExposureTimeError,
					invalidTargetMaxIntensityError,
					notAllowedTargetMaxIntensityError,
					unspecifiedTimelapseImageCollectionError,
					notAllowedTimelapseImageCollectionError,
					invalidTimelapseImageCollectionError,
					notAllowedZStackImageCollectionError,
					customChannelNotAllowedError,
					unresolvableModeWithChannelError
				}=ConstantArray[False,49];

				(*Look up the option values*)
				{
					mode,detectionLabels,focalHeight,exposureTime,targetMaxIntensity,timelapseImageCollection,
					excitationWavelength,emissionWavelength,excitationPower,dichroicFilterWavelength,imageCorrection,
					imageDeconvolution,imageDeconvolutionKFactor,transmittedLightPower,transmittedLightColorCorrection,
					zStackImageCollection,imagingChannel
				}=Lookup[myMapOptions,
					{
						Mode,DetectionLabels,FocalHeight,ExposureTime,TargetMaxIntensity,TimelapseImageCollection,
						ExcitationWavelength,EmissionWavelength,ExcitationPower,DichroicFilterWavelength,ImageCorrection,
						ImageDeconvolution,ImageDeconvolutionKFactor,TransmittedLightPower,TransmittedLightColorCorrection,
						ZStackImageCollection,ImagingChannel
					}
				];

				(* ---setup--- *)

				(* get all the imaging modes that our instrument supports *)
				supportedModes=Lookup[instrumentModelPacket,Modes];

				(* get all detection labels OBJECTS specified in other primitive EXCEPT the current one *)
				inUseDetectionLabels=Cases[Drop[detectionLabelsTracking,index],ObjectP[],Infinity];

				(* initialize a list to track detection labels objects overlapping with other primitives *)
				overlappingDetectionLabel={};

				(* initialize a list to track specified NON-FLUORESCENT detection labels when Epifluorescence/ConfocalFluorescence Mode is selected *)
				undetectableNonFluorescentLabel={};

				(* initialize a list to track specified FLUORESCENT detection labels when BrightField/PhaseConstrast Mode is selected *)
				undetectableFluorescentLabel={};

				(* initialize a list to track detection labels objects that we cannot resolve Mode for *)
				unresolvevableDetectionLabel={};

				(* initialize a list to track conflicting imaging channel options *)
				conflictingImagingChannelOptionName={};

				(* ---conflicting options checks--- *)

				(* 1. conflicting Mode and ImagingChannel *)
				conflictingModeAndChannelError=Switch[{mode,imagingChannel},
					(* we don't allow user to specify CustomChannel. catch this first since error and flip the error switch *)
					{_,CustomChannel},customChannelNotAllowedError=True;False,
					(* if Mode is a fluorescent mode but imaging channel is non-fluorescent. flip the error switch *)
					{MicroscopeFluorescentModeP,Complement[MicroscopeImagingChannelP,MicroscopeFluorescentImagingChannelP]},True,
					(* if Mode is a non-fluorescent mode but imaging channel is fluorescent. flip the error switch *)
					{Complement[MicroscopeModeP,MicroscopeFluorescentModeP],MicroscopeFluorescentImagingChannelP},True,
					(* all other cases are fine *)
					_,False
				];

				(* 2. conflicting ImagingChannel and excitation/emission/dichroic wavelength*)
				(* ImagingChannel is a shorthand option that lets the user conveniently skip specifying high-level imaging options *)
				(* if ImagingChannel is specified, the following options must be Automatic: *)
				(* ExcitationWavelength, EmissionWavelength, ExcitationPower, DichroicFilterWavelength, TransmittedLightPower *)
				optionValuesToCheckLookup={
					ExcitationWavelength->excitationWavelength,
					EmissionWavelength->emissionWavelength,
					ExcitationPower->excitationPower,
					DichroicFilterWavelength->dichroicFilterWavelength,
					TransmittedLightPower->transmittedLightPower
				};
				conflictingImagingChannelsAndOptionsError=If[MatchQ[imagingChannel,Automatic],
					False,
					(* are all options Automatic? *)
					If[ContainsExactly[Values[optionValuesToCheckLookup],{Automatic}],
						(* yes: return False *)
						False,
						(* no: pick the non-Automatic options and return True *)
						(
							conflictingImagingChannelOptionName=PickList[Keys[optionValuesToCheckLookup],Values[optionValuesToCheckLookup],Except[Automatic]];
							True
						)
					]
				];

				(* 3. does our instrument support the specified ImagingChannel? *)

				(* create tuples from instrument's info in the form {imagingChannel,excitationWavelength,emissionWavelength,dichroicFilterWavelength} *)
				instrumentImagingChannelTuples=Transpose@Lookup[instrumentModelPacket,{ImagingChannels,FluorescenceExcitationWavelengths,FluorescenceEmissionWavelengths,DichroicFilterWavelengths}];

				(* get the supported channel names *)
				supportedImagingChannels=instrumentImagingChannelTuples[[All,1]];

				(* does our instrument support the specified ImagingChannel? *)
				(* note: if CustomChannel is specified, error would have been thrown already *)
				unsupportedImagingChannelError=If[MatchQ[imagingChannel,Automatic]||MatchQ[imagingChannel,CustomChannel],
					False,
					!MemberQ[supportedImagingChannels,imagingChannel]
				];

				(* ---pre-resolve options based on specified ImagingChannel--- *)

				(* if ImagingChannel is specified, pre-resolve excitation/emission/dichroic wavelength *)
				{
					preResolvedExcitationWavelength,
					preResolvedEmissionWavelength,
					preResolvedDichroicFilterWavelength
				}=If[MatchQ[imagingChannel,Automatic|CustomChannel]||TrueQ[unsupportedImagingChannelError],
					(* if Automatic or unsupportedImagingChannelError is True, set to specified values *)
					{excitationWavelength,emissionWavelength,dichroicFilterWavelength},
					(* else: pre-resolve to values that match existing channel supported by the instrument *)
					Rest@FirstCase[instrumentImagingChannelTuples,{imagingChannel,__}]
				];

				(* ---1. resolve Mode--- *)

				(* is Mode specified? *)
				resolvedMode=If[MatchQ[mode,Automatic],
					(* is ImagingChannel specified? *)
					If[MatchQ[imagingChannel,Automatic],
						(* resolve Mode based on specified DetectionLabels *)
						Module[{canUseDetectionLabels,detectionLabelsToUse,detectionLabelsToUsePackets,fluorescentQs},
							(* is DetectionLabels option specified? *)
							(* the goal here is to know which detection label objects we can use to resolve Mode *)
							If[MatchQ[detectionLabels,Automatic],
								(
									(* get the detection label objects that we can use *)
									(* these objects are downloaded from our samples and must not be be included in other primitives *)
									canUseDetectionLabels=Complement[samplesDetectionLabels,inUseDetectionLabels];
									(* select the first unused detection label object *)
									detectionLabelsToUse=ToList[FirstOrDefault[canUseDetectionLabels,Nothing]];

								),
								(* else: use the specified values and check if any of them overlap with other primitives *)
								(
									(* assign specified values to a new variable to use when resolving other related options *)
									detectionLabelsToUse=ToList[detectionLabels];
									(* get the detection labels that overlap with other primitives *)
									overlappingDetectionLabel=Intersection[inUseDetectionLabels,detectionLabelsToUse];
									(* is any member of detectionLabelsToUse included as DetectionLabels option in other primitive? *)
									If[!MatchQ[overlappingDetectionLabel,{}],
										(* flip the warning switch *)
										detectionLabelInUseWarning=True;
									]
								)
							];

							(* get the packets for detection labels to use *)
							detectionLabelsToUsePackets=fetchPacketFromCache[#,newCache]&/@detectionLabelsToUse;

							(* do we have any detection label to use for resolving Mode? *)
							(* make sure we catch the case where DetectionLabel is specified as Null *)
							fluorescentQs=If[MatchQ[detectionLabelsToUse,{}]||NullQ[detectionLabelsToUsePackets],
								(* default to False since we don't have any detection labels *)
								{False},
								(* else: check if detectionLabelsToUse are fluorescent *)
								TrueQ/@Lookup[detectionLabelsToUsePackets,Fluorescent]
							];

							(* create a list of fluorescence-related option values *)
							fluorescenceOptionValues={preResolvedExcitationWavelength,preResolvedEmissionWavelength,excitationPower,preResolvedDichroicFilterWavelength};

							(* is any fluorescence-related option specified and not Null? *)
							(* note: none is specified if all values are Automatic *)
							fluorescenceOptionsSpecifiedQ=!MatchQ[Complement[fluorescenceOptionValues,{Automatic,Null}],{}];

							(* are all detectionLabelsToUse Fluorescent or any fluorescence-related option specified? *)
							If[(And@@fluorescentQs||fluorescenceOptionsSpecifiedQ),
								(* does our instrument support Epifluorescence Mode? *)
								If[MemberQ[supportedModes,Epifluorescence],
									(* return it *)
									Epifluorescence,
									(* else: does our instrument support confocal? *)
									If[MemberQ[supportedModes,ConfocalFluorescence],
										(* return it *)
										ConfocalFluorescence,
										(* else: flip the warning switch and return the first mode found *)
										(
											fluorescenceImagingNotSupportedWarning=True;
											First[supportedModes]
										)
									]
								],
								(* else: are all detectionLabelsToUse non-fluorescent? *)
								If[!Or@@fluorescentQs,
									(* does our instrument support PhaseContrast imaging? *)
									If[MemberQ[supportedModes,PhaseContrast],
										(* return it *)
										PhaseContrast,
										(* else: does our instrument support BrightField? *)
										If[MemberQ[supportedModes,BrightField],
											(* return it *)
											BrightField,
											(* else: flip the warning switch and return the first mode found *)
											(
												brightFieldImagingNotSupportedWarning=True;
												First[supportedModes]
											)
										]
									],
									(* else: flip the error switch since we cannot resolve suitable Mode and assign the DetectionLabels to a variable *)
									(
										unresolvableModeError=True;
										unresolvevableDetectionLabel=detectionLabelsToUse;
										(* return Epifluorescence if our instrument supports it so that we can resolve other related options *)
										If[MemberQ[supportedModes,Epifluorescence],
											Epifluorescence,
											(* otherwise, return first mode found *)
											First[supportedModes]
										]
									)
								]
							]
						],
						(* else: resolve based on ImagingChannel *)
						Module[{fluorescentChannelQ,supportedFluorescentModes,supportedNonFluorescentModes},
							(* determine if ImagingChannel is a flurescent channel *)
							fluorescentChannelQ=MatchQ[imagingChannel,MicroscopeFluorescentImagingChannelP];

							(* is ImagingChannel a flurescent channel? *)
							If[fluorescentChannelQ,
								(* does our instrument support Epifluorescence Mode? *)
								If[MemberQ[supportedModes,Epifluorescence],
									(* return it *)
									Epifluorescence,
									(* else: select the first supported fluorescent mode if any *)
									(
										supportedFluorescentModes=Intersection[supportedModes,List@@MicroscopeFluorescentModeP];
										If[MatchQ[supportedFluorescentModes,{}],
											(* flip the error switch and return Epifluorescence because we need a valid value to resolve other options *)
											unresolvableModeWithChannelError=True;Epifluorescence,
											(* else: return the first mode *)
											First@supportedFluorescentModes
										]
									)
								],
								(* else: find a suitable non-fluorescent mode *)
								(* does our instrument support BrightField Mode? *)
								If[MemberQ[supportedModes,BrightField],
									(* return it *)
									BrightField,
									(* else: select the first supported non-fluorescent mode if any *)
									(
										supportedNonFluorescentModes=Complement[supportedModes,List@@MicroscopeFluorescentModeP];
										If[MatchQ[supportedNonFluorescentModes,{}],
											(* flip the error switch and return BrightField because we need a valid value to resolve other options *)
											unresolvableModeWithChannelError=True;BrightField,
											(* else: return the first mode *)
											First@supportedNonFluorescentModes
										]
									)
								]
							]
						]
					],
					(* ELSE: is the specified Mode supported by the instrument *)
					If[MemberQ[Lookup[instrumentModelPacket,Modes],mode],
						(* if supported, accept the specified value *)
						mode,
						(* else: flip the error switch and return the specified value *)
						(
							unsupportedModeError=True;
							mode
						)
					]
				];

				(* ===resolve Mode/DetectionLabels dependent options=== *)

				(* Switch based off of our resolved Mode to resolve mode-related options *)
				(* note: we will need to update this section if we introduce more imaging modes in the future *)
				Switch[resolvedMode,
					(* ===Epifluorescence or ConfocalFluorescence=== *)
					Alternatives[Epifluorescence,ConfocalFluorescence],
					Module[{canUseDetectionLabels,canUseDetectionLabelPackets,fluorescentDetectionLabels,detectionLabelToUse,
						specifiedDetectionLabelsPackets,nonFluorescentDetectionLabels,listedResolvedDetectionLabel,
						resolvedDetectionLabelPackets,supportedExcitationWavelengths,listedFluorescenceExcitationMaximums,
						multiExcitationWavelengthsQs,excitationWavelengthQuantities,sameExcitationWavelengthsQ,meanExcitation,
						nearestSupportedExcitation,detectionLabelsExcitations,matchingExcitations,listedFluorescenceEmissionMaximums,
						supportedEmissionWavelengths,customizableChannelQ,multiEmissionWavelengthsQs,emissionWavelengthQuantities,
						sameEmissionWavelengthsQ,meanEmission,nearestSupportedEmission,detectionLabelsEmissions,matchingEmissions,
						indexMatchingEmissionWavelengths,nearestIndexMatchingEmission,instrumentsChannelPairs,
						resolvedExcitationEmissionPair,instrumentsDefaultExcitationPowers,instrumentsDichroicFilterWavelengths,
						expectedDichroicFilterWavelengths},

						(* ---2. resolve DetectionLabels--- *)

						(* is DetectionLabels specified? *)
						resolvedDetectionLabel=If[MatchQ[detectionLabels,Automatic],
							(
								(* get the detection label objects that we can use *)
								(* these objects are downloaded from our samples and must not be be included in other primitives *)
								canUseDetectionLabels=Complement[samplesDetectionLabels,inUseDetectionLabels];

								(* get the packets of the detection labels we can use *)
								canUseDetectionLabelPackets=fetchPacketFromCache[#,newCache]&/@canUseDetectionLabels;

								(* get the detection labels that are fluorescent *)
								fluorescentDetectionLabels=Cases[canUseDetectionLabelPackets,KeyValuePattern[{Object->obj_,Fluorescent->True}]:>obj];

								(* select the first unused fluorescent detection label object *)
								(* detectionLabelToUse is ALWAYS a singleton *)
								detectionLabelToUse=FirstOrDefault[fluorescentDetectionLabels,Null];

								(* did we find any fluorescent detection label to use? *)
								If[NullQ[detectionLabelToUse],
									(* no: return Null since we allow the channel to be setup despite having no detection label *)
									Null,
									(* yes: update detectionLabelsTracking, and return the value in a list *)
									(
										detectionLabelsTracking=ReplacePart[detectionLabelsTracking,index->detectionLabelToUse];
										ToList[detectionLabelToUse]
									)
								]
							),

							(* else: is DetectionLabels specified as Null? *)
							(* note: we warn the user when DetectionLabels is Null and fluorescence Mode is selected *)
							If[NullQ[detectionLabels],
								(* flip the warning switch and return the specified value *)
								(
									detectionLabelsNotSpecifiedWarning=True;
									detectionLabels
								),
								(
									(* get the packets of the specified detection labels *)
									specifiedDetectionLabelsPackets=fetchPacketFromCache[#,newCache]&/@ToList[detectionLabels];

									(* get the detection label objects that are not fluorescent *)
									nonFluorescentDetectionLabels=Cases[specifiedDetectionLabelsPackets,KeyValuePattern[{Object->obj_,Fluorescent->Except[True]}]:>obj];

									(* do we have any non-fluorescent detection label? *)
									If[!MatchQ[nonFluorescentDetectionLabels,{}],
										(* flip the warning switch, and assign undetectable labels to outer scope variable *)
										undetectableNonFluorescentLabelWarning=True;
										undetectableNonFluorescentLabel=nonFluorescentDetectionLabels;
									];

									(* return specified value *)
									detectionLabels
								)
							]
						];

						(* make sure resolvedDetectionLabel is in a list form for ease of use *)
						listedResolvedDetectionLabel=ToList[resolvedDetectionLabel];

						(* get the packets for all resolved detection label objects *)
						(* note: make sure we get just the packets since some of resolvedDetectionLabels can be Null *)
						resolvedDetectionLabelPackets=Cases[fetchPacketFromCache[#,newCache]&/@listedResolvedDetectionLabel,PacketP[]];

						(* ---3. resolve ExcitationWavelength--- *)

						(* lookup FluorescenceExcitationMaximums field from each detection label *)
						listedFluorescenceExcitationMaximums=Flatten@Lookup[resolvedDetectionLabelPackets,FluorescenceExcitationMaximums,{}];

						(* get the excitation wavelengths that our instrument supports *)
						supportedExcitationWavelengths=Lookup[instrumentModelPacket,FluorescenceExcitationWavelengths];

						(* is ExcitationWavelength specified? *)
						resolvedExcitationWavelength=If[MatchQ[preResolvedExcitationWavelength,Automatic],
							(* is resolvedDetectionLabel Null? *)
							If[NullQ[listedResolvedDetectionLabel],
								(* flip the error switch and return resolved value *)
								(
									unresolvableExcitationWavelengthWarning=True;
									(* return the longest wavelength as this is more likely to prevent sample bleaching *)
									Max[supportedExcitationWavelengths]
								),
								(
									(* check if each object has >1 excitation wavelengths *)
									multiExcitationWavelengthsQs=(Length[#]>1)&/@listedFluorescenceExcitationMaximums;
									(* get only the quantity out of the excitation wavelength list *)
									excitationWavelengthQuantities=Cases[listedFluorescenceExcitationMaximums,_Quantity,Infinity];
									(* do all detection label have the same excitation wavelengths? *)
									sameExcitationWavelengthsQ=SameQ[Sequence@@excitationWavelengthQuantities];
									(* if we are dealing with multiple excitation wavelengths, are they all the same? *)
									If[And@@multiExcitationWavelengthsQs&&!sameExcitationWavelengthsQ,
										multipleExcitationWavelengthsWarning=True;
									];
									(* find the mean of our excitation wavelengths *)
									meanExcitation=Mean[excitationWavelengthQuantities];
									(* resolve excitation wavelength *)
									If[MatchQ[meanExcitation,_Quantity],
										(
											(* get the nearest excitation wavelengths that our instrument supports within 100 Nanometer radius *)
											(* TODO: check if 50 nm tolerance below or above instrument's min and max is acceptable *)
											nearestSupportedExcitation=Nearest[supportedExcitationWavelengths,meanExcitation,{1,50 Nanometer}];

											(* did we find any supported excitation wavelength? *)
											If[MatchQ[nearestSupportedExcitation,{}],
												(* no, flip the warning switch and return the nearest we can find *)
												(
													excitationOutOfRangeWarning=True;
													If[MatchQ[meanExcitation,GreaterP[Max[supportedExcitationWavelengths]]],
														Max@Nearest[supportedExcitationWavelengths,meanExcitation],
														Min@Nearest[supportedExcitationWavelengths,meanExcitation]
													]
												),
												(* yes, return the value we found *)
												First[nearestSupportedExcitation]
											]
										),
										(* else: none of our detection label have FluorescenceExcitationMaximums *)
										(* return the longest wavelength as this is more likely to prevent sample bleaching *)
										Max[supportedExcitationWavelengths]
									]
								)
							],
							(* else: is ExcitationWavelength Null? *)
							If[NullQ[preResolvedExcitationWavelength],
								(* yes, flip the error switch as we don't allow Null if fluorescence Mode is selected *)
								excitationWavelengthNotSpecifiedError=True;preResolvedExcitationWavelength,
								(* else: accept the specified value and check if it's supported by the instrument and matches.. *)
								(* ..one of detection labels excitation wavelength  *)
								(
									(* --does the instrument support the specified excitation wavelength?-- *)
									If[!MemberQ[supportedExcitationWavelengths,N[preResolvedExcitationWavelength]],
										(* no, flip the error switch and return specified value *)
										unsupportedExcitationWavelengthError=True;
									];
									(* --does the specified value match one of the detection labels excitation wavelengths?-- *)
									(* get the excitation wavelengths of our resolvedDetectionLables *)
									detectionLabelsExcitations=Cases[listedFluorescenceExcitationMaximums,_Quantity,Infinity];
									(* find matching excitation wavelength within tolerance *)
									(* TODO: is 50 nm tolerance acceptable? *)
									matchingExcitations=If[!MatchQ[detectionLabelsExcitations,{}],
										FirstOrDefault[Nearest[detectionLabelsExcitations,preResolvedExcitationWavelength,{1,50 Nanometer}]]
									];
									(* did we find any matching excitation wavelength? *)
									(* note: don't flip the warning switch if there's no detection label *)
									If[NullQ[matchingExcitations]&&!MatchQ[resolvedDetectionLabelPackets,{}],
										(* no, flip the warning switch and return specified value *)
										mismatchedExcitationWavelengthWarning=True;
									];
									(* return specified ExcitationWavelength *)
									preResolvedExcitationWavelength
								)
							]
						];

						(* ---4. resolve EmissionWavelength--- *)

						(* lookup FluorescenceEmissionMaximums field from each detection label *)
						listedFluorescenceEmissionMaximums=Flatten@Lookup[resolvedDetectionLabelPackets,FluorescenceEmissionMaximums,{}];

						(* get the emission wavelengths that our instrument supports *)
						supportedEmissionWavelengths=Lookup[instrumentModelPacket,FluorescenceEmissionWavelengths];

						(* get the boolean indicating if our instrument supports customizable imaging channels with novel.. *)
						(* ..combination of exciation and emission wavelengths *)
						customizableChannelQ=TrueQ@Lookup[instrumentModelPacket,CustomizableImagingChannel];

						(* is EmissionWavelength specified? *)
						resolvedEmissionWavelength=If[MatchQ[preResolvedEmissionWavelength,Automatic],
							(* is resolvedDetectionLabel Null? *)
							If[NullQ[listedResolvedDetectionLabel],
								(* flip the error switch and return resolved value *)
								(
									unresolvableEmissionWavelengthWarning=True;
									(* return the emission wavelength *)
									If[MemberQ[supportedExcitationWavelengths,N@resolvedExcitationWavelength],
										(* return supported emission wavelength that is index-matched to resolved ExcitationWavelength *)
										(* this will ensure that we don't need to create a new custom imaging channel *)
										Max@Extract[supportedEmissionWavelengths,Position[supportedExcitationWavelengths,N@resolvedExcitationWavelength]],
										(* else: return longest emission wavelength that our instrument supports *)
										Max[supportedEmissionWavelengths]
									]
								),
								(
									(* check if each object has >1 emission wavelengths *)
									multiEmissionWavelengthsQs=(Length[#]>1)&/@listedFluorescenceEmissionMaximums;
									(* get only the quantity our of the emission wavelength list *)
									emissionWavelengthQuantities=Cases[listedFluorescenceEmissionMaximums,_Quantity,Infinity];
									(* do all detection label have the same emission wavelengths? *)
									sameEmissionWavelengthsQ=SameQ[Sequence@@emissionWavelengthQuantities];
									(* if we are dealing with multiple emission wavelengths, are they all the same? *)
									If[And@@multiEmissionWavelengthsQs&&!sameEmissionWavelengthsQ,
										multipleEmissionWavelengthsWarning=True;
									];
									(* find the mean of our emission wavelengths *)
									meanEmission=Mean[emissionWavelengthQuantities];
									(* resolve emission wavelength *)
									If[MatchQ[meanEmission,_Quantity],
										(* does our instrument support customizable imaging channel? *)
										(* customizableChannelQ is True when we can mix and match any excitation and emission wavelengths *)
										If[customizableChannelQ,
											(* get the nearest emission wavelengths that our instrument supports within 100 Nanometer radius *)
											(* TODO: check if 50 nm tolerance below or above instrument's min and max is acceptable *)
											nearestSupportedEmission=Nearest[supportedEmissionWavelengths,meanEmission,{1,50 Nanometer}];
											(* did we find any supported emission wavelength? *)
											If[MatchQ[nearestSupportedEmission,{}],
												(* no, flip the warning switch and return the nearest and longest emission wavelength we can find *)
												(
													emissionOutOfRangeWarning=True;
													Max@Nearest[supportedEmissionWavelengths,meanEmission]
												),
												(* yes, return the value we found *)
												First[nearestSupportedEmission]
											],
											(* else: imaging channels are not customizable. we have to get the matching emission wavelength with our resolved excitation wavelength *)
											(* does our resolved ExcitationWavelength match with any instrument supported value? *)
											If[MemberQ[supportedExcitationWavelengths,N@resolvedExcitationWavelength],
												(* yes, we need to find the instrument's index-matching emission wavelength *)
												(* note: it is possible that we have multiple emission wavelengths index-matched to similar excitation wavelength *)
												(
													(* get index-matching emission wavelength of our instrument based on the resolved excitation wavelength *)
													indexMatchingEmissionWavelengths=Extract[supportedEmissionWavelengths,Position[supportedExcitationWavelengths,N@resolvedExcitationWavelength]];
													(* get the nearest index-matching emission wavelengths that our instrument supports within 100 Nanometer radius *)
													(* TODO: check if 50 nm tolerance below or above instrument's min and max is acceptable *)
													nearestIndexMatchingEmission=Nearest[indexMatchingEmissionWavelengths,meanEmission,{1,50 Nanometer}];
													(* did we find any supported emission wavelength? *)
													If[MatchQ[nearestIndexMatchingEmission,{}],
														(* no: return the nearest and nearest emission wavelength we can find *)
														Max@Nearest[indexMatchingEmissionWavelengths,meanEmission],
														(* yes, return the value we found *)
														First[nearestIndexMatchingEmission]
													]
												),
												(* else: return longest emission wavelength that our instrument supports *)
												Max[supportedEmissionWavelengths]
											]
										],
										(* else: none of our detection label have FluorescenceEmissionWavelengths *)
										If[MemberQ[supportedExcitationWavelengths,N@resolvedExcitationWavelength],
											(* return supported emission wavelength that is index-matched to resolved ExcitationWavelength *)
											(* this will ensure that we don't need to create a new custom imaging channel *)
											Max@Extract[supportedEmissionWavelengths,Position[supportedExcitationWavelengths,N@resolvedExcitationWavelength]],
											(* else: return longest emission wavelength that our instrument supports *)
											Max[supportedEmissionWavelengths]
										]
									]
								)
							],
							(* else: is EmissionWavelength Null? *)
							If[NullQ[preResolvedEmissionWavelength],
								(* yes, flip the error switch as we don't allow Null if fluorescence Mode is selected *)
								emissionWavelengthNotSpecifiedError=True;preResolvedEmissionWavelength,
								(* else: accept the specified value and check if it's supported by the instrument and matches.. *)
								(* ..one of detection labels emission wavelength  *)
								(
									(* --does the instrument support the specified emission wavelength?-- *)
									If[!MemberQ[supportedEmissionWavelengths,N[preResolvedEmissionWavelength]],
										(* no, flip the error switch and return specified value *)
										unsupportedEmissionWavelengthError=True;
									];
									(* --does the specified value match one of the detection labels emission wavelengths?-- *)
									(* get the emission wavelengths of our resolvedDetectionLables *)
									detectionLabelsEmissions=Cases[listedFluorescenceEmissionMaximums,_Quantity,Infinity];
									(* find matching emission wavelength within tolerance *)
									(* TODO: is 50 nm tolerance acceptable? *)
									matchingEmissions=If[!MatchQ[detectionLabelsEmissions,{}],
										FirstOrDefault[Nearest[detectionLabelsEmissions,preResolvedEmissionWavelength,{1,50 Nanometer}]]
									];

									(* did we find any matching emission wavelength? *)
									(* note: don't flip the warning switch if there's no detection label *)
									If[NullQ[matchingEmissions]&&!MatchQ[resolvedDetectionLabelPackets,{}],
										(* no, flip the warning switch and return specified value *)
										mismatchedEmissionWavelengthWarning=True;
									];
									(* does our instrument support customizable imaging channel? *)
									(* customizableChannelQ is True when we can mix and match any excitation and emission wavelengths *)
									If[!customizableChannelQ,
										(* check if our excitation/emission combination makes sense with our instrument *)
										(* does our resolved ExcitationWavelength match with any supported channel? *)
										If[MemberQ[supportedExcitationWavelengths,N@resolvedExcitationWavelength],
											(* get the index-matching instrument's emission wavelength(s) *)
											indexMatchingEmissionWavelengths=Extract[supportedEmissionWavelengths,Position[supportedExcitationWavelengths,N@resolvedExcitationWavelength]];
											(* flip the error switch if our resolved EmissionWavelength doesn't match any emission in supported channel *)
											If[!MemberQ[indexMatchingEmissionWavelengths,N[preResolvedEmissionWavelength]],
												invalidEmissionWavelengthChannelError=True;
											]
										]
									];
									(* return the specified value *)
									preResolvedEmissionWavelength
								)
							]
						];

						(* ---5. resolve ExcitationPower--- *)

						(* get excitation/emission wavelengths pair that are available channels on our instrument *)
						instrumentsChannelPairs=Transpose[{supportedExcitationWavelengths,supportedEmissionWavelengths}];
						(* get our resolve excitation/emission wavelengths pair *)
						resolvedExcitationEmissionPair=N[{resolvedExcitationWavelength,resolvedEmissionWavelength}];

						(* is ExcitationPower specified *)
						resolvedExcitationPower=If[MatchQ[excitationPower,Automatic],
							(* return the default value of our instrument *)
							(
								(* lookup default excitation powers from our instrument *)
								(* note: values in the field index-matched to excitation and emission wavelengths *)
								instrumentsDefaultExcitationPowers=Lookup[instrumentModelPacket,DefaultExcitationPowers];
								(* does our excitation/emission wavelengths pair matches any available channels on our instrument? *)
								If[MemberQ[instrumentsChannelPairs,resolvedExcitationEmissionPair],
									(* return default ExcitationPower of that channel *)
									Extract[instrumentsDefaultExcitationPowers,FirstPosition[instrumentsChannelPairs,resolvedExcitationEmissionPair]],
									(* default to 20% *)
									20. Percent
								]
							),
							(* else: is ExcitationPower Null? *)
							If[NullQ[excitationPower],
								(* flip the error switch and return specified value *)
								excitationPowerNotSpecifiedError=True;excitationPower,
								(* no, accept the specified value *)
								excitationPower
							]
						];

						(* ---6. resolve DichroicFilterWavelength--- *)

						(* lookup DichroicFilterWavelengths from our instrument *)
						(* note: values in the field index-matched to excitation and emission wavelengths *)
						instrumentsDichroicFilterWavelengths=Lookup[instrumentModelPacket,DichroicFilterWavelengths];

						(* is DichroicFilterWavelength specified? *)
						resolvedDichroicFilterWavelength=If[MatchQ[preResolvedDichroicFilterWavelength,Automatic],
							(* does our excitation/emission wavelengths pair matches any available channels on our instrument? *)
							If[MemberQ[instrumentsChannelPairs,resolvedExcitationEmissionPair],
								(* return default ExcitationPower of that channel *)
								Extract[instrumentsDichroicFilterWavelengths,FirstPosition[instrumentsChannelPairs,resolvedExcitationEmissionPair]],
								(* else: is resolvedExcitationWavelength Null? *)
								If[NullQ[resolvedExcitationWavelength],
									(* yes: return Null since we cannot resolve DichroicFilterWavelength *)
									Null,
									(* else: does our instrument support customization channel? *)
									(* this means we can mix and match our excitation/emission wavelengths pair with any DichroicFilterWavelength *)
									If[customizableChannelQ,
										(* yes: return the nearest value to our resolved excitation wavelength *)
										FirstOrDefault@Nearest[instrumentsDichroicFilterWavelengths,resolvedExcitationWavelength],
										(* no: flip the warning switch and return Null *)
										unresolvableDichroicFilterWavelengthError=True;Null
									]
								]
							],
							(* else: is DichroicFilterWavelength Null? *)
							If[NullQ[preResolvedDichroicFilterWavelength],
								(* yes, flip the error switch as we don't allow Null if fluorescence Mode is selected *)
								dichroicFilterWavelengthNotSpecifiedError=True;preResolvedDichroicFilterWavelength,
								(* else: is the specified DichroicFilterWavelength supported by our instrument? *)
								If[MemberQ[instrumentsDichroicFilterWavelengths,N@preResolvedDichroicFilterWavelength],
									(
										(* yes, check if we allow customizable channel *)
										If[!customizableChannelQ,
											(* does our specified value match any DichroicFilterWavelength of excitation/emission wavelengths pair available on our instrument? *)
											If[MemberQ[instrumentsChannelPairs,resolvedExcitationEmissionPair],
												(* get the expected values of DichroicFilterWavelength *)
												expectedDichroicFilterWavelengths=Extract[instrumentsDichroicFilterWavelengths,Position[instrumentsChannelPairs,resolvedExcitationEmissionPair]];
												(* does our specified value match any of the expected values? *)
												If[!MemberQ[expectedDichroicFilterWavelengths,N@preResolvedDichroicFilterWavelength],
													(* no, flip the error switch *)
													mistmatchDichroicFilterWavelengthError=True;
												]
											]
										];
										(* return the specified value *)
										preResolvedDichroicFilterWavelength
									),
									(* no, flip the error switch and accept the value *)
									(
										unsupportedDichroicFilterWavelengthError=True;
										preResolvedDichroicFilterWavelength
									)
								]
							]
						];

						(* ---7. resolve TransmittedLightPower--- *)

						(* is TransmittedLightPower specified? *)
						resolvedTransmittedLightPower=If[MatchQ[transmittedLightPower,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedTransmittedLightPowerError=True;
								transmittedLightPower
							)
						];

						(* ---8. resolve TransmittedLightColorCorrection--- *)

						(* is TransmittedLightPower specified? *)
						resolvedTransmittedLightColorCorrection=If[MatchQ[transmittedLightColorCorrection,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedTransmittedLightColorCorrectionError=True;
								transmittedLightColorCorrection
							)
						];
					],

					(* ===PhaseConstrast or BrightField=== *)
					Alternatives[PhaseContrast,BrightField],
					Module[{canUseDetectionLabels,canUseDetectionLabelPackets,nonFluorescentDetectionLabels,detectionLabelToUse,
						specifiedDetectionLabelsPackets,fluorescentDetectionLabels,colorCorrectionQ},

						(* ---2. resolve DetectionLabels--- *)

						(* is DetectionLabels specified? *)
						resolvedDetectionLabel=If[MatchQ[detectionLabels,Automatic],
							(
								(* get the detection label objects that we can use *)
								(* these objects are downloaded from our samples and must not be be included in other primitives *)
								canUseDetectionLabels=Complement[samplesDetectionLabels,inUseDetectionLabels];

								(* get the packets of the detection labels we can use *)
								canUseDetectionLabelPackets=fetchPacketFromCache[#,newCache]&/@canUseDetectionLabels;

								(* get the detection labels that are NOT fluorescent *)
								nonFluorescentDetectionLabels=Cases[canUseDetectionLabelPackets,KeyValuePattern[{Object->obj_,Fluorescent->Except[True]}]:>obj];

								(* select the first unused non-fluorescent detection label object *)
								(* detectionLabelToUse is ALWAYS a singleton *)
								detectionLabelToUse=FirstOrDefault[nonFluorescentDetectionLabels,Null];

								(* did we find any non-fluorescent detection label to use? *)
								If[NullQ[detectionLabelToUse],
									(* return Null since we throw a warning here since we allow creating a non-fluorescent channel without any detection label *)
									Null,
									(* yes, update detectionLabelsTracking, and return the value in a list *)
									(
										detectionLabelsTracking=ReplacePart[detectionLabelsTracking,index->detectionLabelToUse];
										ToList[detectionLabelToUse]
									)
								]
							),

							(* else: is our specified value Null? *)
							If[NullQ[detectionLabels],
								(* yes, return as is *)
								detectionLabels,
								(* else: check if the specified detection labels are NOT fluorescent *)
								(
									(* get the packets of the specified detection labels *)
									specifiedDetectionLabelsPackets=fetchPacketFromCache[#,newCache]&/@ToList[detectionLabels];

									(* get the detection label objects that ARE fluorescent *)
									fluorescentDetectionLabels=Cases[specifiedDetectionLabelsPackets,KeyValuePattern[{Object->obj_,Fluorescent->True}]:>obj];

									(* do we have any fluorescent detection label? *)
									If[!MatchQ[fluorescentDetectionLabels,{}],
										(* flip the warning switch, and assign undetectable labels to outer scope variable *)
										undetectableFluorescentLabelWarning=True;
										undetectableFluorescentLabel=fluorescentDetectionLabels;
									];

									(* return specified value *)
									detectionLabels
								)
							];
						];

						(* ---3. resolve ExcitationWavelength--- *)

						(* is ExcitationWavelength specified? *)
						resolvedExcitationWavelength=If[MatchQ[preResolvedExcitationWavelength,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedExcitationWavelengthError=True;
								preResolvedExcitationWavelength
							)
						];

						(* ---4. resolve EmissionWavelength--- *)

						(* is EmissionWavelength specified? *)
						resolvedEmissionWavelength=If[MatchQ[preResolvedEmissionWavelength,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedEmissionWavelengthError=True;
								preResolvedEmissionWavelength
							)
						];

						(* ---5. resolve ExcitationPower--- *)

						(* is ExcitationPower specified? *)
						resolvedExcitationPower=If[MatchQ[excitationPower,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedExcitationPowerError=True;
								excitationPower
							)
						];

						(* ---6. resolve DichroicFilterWavelength--- *)

						(* is DichroicFilterWavelength specified? *)
						resolvedDichroicFilterWavelength=If[MatchQ[preResolvedDichroicFilterWavelength,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedDichroicFilterWavelengthError=True;
								preResolvedDichroicFilterWavelength
							)
						];

						(* ---7. resolve TransmittedLightPower--- *)

						(* is TransmittedLightPower specified *)
						resolvedTransmittedLightPower=If[MatchQ[transmittedLightPower,Automatic],
							(* lookup instrument's default value *)
							Lookup[instrumentModelPacket,DefaultTransmittedLightPower],
							(* no, is it Null? *)
							If[NullQ[transmittedLightPower],
								(* flip the error switch and return specified value *)
								transmittedLightPowerNotSpecifiedError=True;transmittedLightPower,
								(* no, accept it *)
								transmittedLightPower
							]
						];

						(* ---8. resolve TransmittedLightColorCorrection--- *)

						(* check if our instrument supports TransmittedLightColorCorrection *)
						colorCorrectionQ=TrueQ@Lookup[instrumentModelPacket,TransmittedLightColorCorrection];

						(* is TransmittedLightColorCorrection specified *)
						resolvedTransmittedLightColorCorrection=If[MatchQ[transmittedLightColorCorrection,Automatic],
							(* does our instrument support ColorCorrection? *)
							If[colorCorrectionQ,True,Null],
							(* else: value is specified *)
							(* does our instrument support ColorCorrection? *)
							If[colorCorrectionQ,
								(* yes, accept the specified value *)
								transmittedLightColorCorrection,
								(* no, is it specified as True *)
								(
									(* if True, flip the error switch *)
									If[TrueQ[transmittedLightColorCorrection],colorCorrectionNotSupportedError=True;];
									(* return the specified value *)
									transmittedLightColorCorrection
								)
							]
						];
					]
				];

				(* ===RESOLVE INDEPENDENT OPTIONS=== *)

				(* ---9. resolve ImageCorrection--- *)

				(* lookup all image correction method that our instrument supports *)
				supportedCorrectionMethods=Lookup[instrumentModelPacket,ImageCorrectionMethods,{}];

				(* is ImageCorrection specified? *)
				resolvedImageCorrection=If[MatchQ[imageCorrection,Automatic],
					(* does our instrument support image correction? *)
					(* also set to Null if unsupportedModeError is True *)
					If[MatchQ[supportedCorrectionMethods,({}|Null)]||unsupportedModeError,
						(* no, set to Null *)
						Null,
						(* yes, *)
						Module[{instrumentsDefaultImageCorrections,modeIndex},
							(* get the instrument's DefaultImageCorrections. this list index-matches to instrument's Modes  *)
							instrumentsDefaultImageCorrections=Lookup[instrumentModelPacket,DefaultImageCorrections];
							(* get the position of resolvedMode in supportedModes list *)
							modeIndex=FirstPosition[supportedModes,resolvedMode];
							(* get the default correction method according to our resolved Mode *)
							If[MissingQ[modeIndex],
								(* return Null if we cannot find index-matching correction method*)
								(* note: this is the case where Mode is unresolvable which an error would have been thrown above *)
								Null,
								(* else: extract instrument's default value and return *)
								Extract[instrumentsDefaultImageCorrections,FirstPosition[supportedModes,resolvedMode]]
							]
						]
					],
					(* else: is it Null? *)
					If[NullQ[imageCorrection],
						(* return as is *)
						imageCorrection,
						(* else: check if the specified correction method is supported by out instrument *)
						If[MemberQ[supportedCorrectionMethods,imageCorrection],
							(* yes, return as is *)
							imageCorrection,
							(* no, flip the error switch and return the specified value *)
							unsupportedImageCorrectionError=True;imageCorrection
						]
					]
				];

				(* ---10. check ImageDeconvolution--- *)

				(* check if our instrument supports image deconvolution *)
				imageDeconvolutionSupportedQ=Lookup[instrumentModelPacket,ImageDeconvolution];

				(* is ImageDeconvolution True? *)
				If[TrueQ[imageDeconvolution],
					(* does our instrument support image deconvolution? *)
					If[!TrueQ[imageDeconvolutionSupportedQ],
						(* no, flip the error switch *)
						unsupportedImageDeconvolutionError=True;
					]
				];

				(* ---11. resolve ImageDeconvolutionKFactor--- *)

				(* is ImageDeconvolutionKFactor specified? *)
				resolvedImageDeconvolutionKFactor=If[MatchQ[imageDeconvolutionKFactor,Automatic],
					(* is ImageDeconvolution True? and does our instrument support image deconvolution? *)
					If[TrueQ[imageDeconvolutionSupportedQ]&&TrueQ[imageDeconvolution],
						(* set to 1. *)
						1.,
						(* no, return Null *)
						Null
					],
					(* else: check for conflicting options *)
					Switch[{imageDeconvolution,imageDeconvolutionKFactor},
						(* conflicting options, flip the error switch and return specified value *)
						Alternatives[{True,Null},{False,Except[Null]}],mismatchedImageDeconvolutionOptionsError=True;imageDeconvolutionKFactor,
						(* no conflict, return the specified value *)
						_,imageDeconvolutionKFactor
					]
				];

				(* ---12. resolve FocalHeight--- *)

				(* check if our instrument supports autofocusing *)
				autofocusQ=Lookup[instrumentModelPacket,Autofocus];

				(* is FocalHeight specified? *)
				resolvedFocalHeight=If[MatchQ[focalHeight,Automatic],
					(* does our instrument support autofocusing. yes: set to Autofocus, no: set to Manual *)
					If[TrueQ[autofocusQ],Autofocus,Manual],
					(* else: FocalHeight is specified *)
					Switch[focalHeight,
						(* if Manual, accept it *)
						Manual,focalHeight,
						(* if Autofocus: *)
						Autofocus,
						(* does our instrument support autofocusing? *)
						If[TrueQ[autofocusQ],
							(* yes, accept the specified value *)
							focalHeight,
							(* no, flip the error switch and return the specified value *)
							unsupportedAutofocusError=True;focalHeight
						],
						(* specified as distance. check if compatible with objective's working distance? *)
						_,
						(
							(* did we find an objective that matches our ObjectiveMagnification? *)
							If[MissingQ[objectiveModelPacketToUse],
								(* flip the error switch *)
								maxWorkingDistanceNotFoundError=True;,
								(* else: does the specified value exceeds max working distance? *)
								If[MatchQ[focalHeight,GreaterP[Lookup[objectiveModelPacketToUse,MaxWorkingDistance]]],
									(* yes, flip the error switch *)
									invalidFocalHeightError=True;
								]
							];
							(* return the specified value *)
							focalHeight
						)
					]
				];

				(* ---13. check ExposureTime--- *)

				(* is ExposureTime set to AutoExpose? *)
				If[!MatchQ[exposureTime,AutoExpose],
					(* no: check if it's withing instrument's range *)
					Module[{minExposureTime,maxExposureTime},
						(* get the min and max ExposureTime from our instrument model's packet *)
						{minExposureTime,maxExposureTime}=Lookup[instrumentModelPacket,{MinExposureTime,MaxExposureTime}];
						(* is the specified value within instrument's range? *)
						If[MatchQ[exposureTime,LessP[minExposureTime]]||MatchQ[exposureTime,GreaterP[maxExposureTime]],
							(* no: flip the error switch *)
							invalidExposureTimeError=True;
						]
					]
				];

				(* ---14. resolve TargetMaxIntensity--- *)
				(* the instrument will have MaxGrayLevel stored in the model. we simply need to calculate 75% of that if TargetMaxIntensity is Automatic *)
				(* lowest target max intensity will always be 1. only max gray level matters which is always 65536 for 16-bit image *)

				(* is TargetMaxIntensity specified? *)
				resolvedTargetMaxIntensity=If[MatchQ[targetMaxIntensity,Automatic],
					(* no. is ExposureTime set to AutoExpose? *)
					If[MatchQ[exposureTime,AutoExpose],
						(* yes, set to instrument's default value *)
						If[NullQ[Lookup[instrumentModelPacket,DefaultTargetMaxIntensity]],
							(* if DefaultTargetMaxIntensity is not populated in our instrument model, default 75% of MaxGrayLevel *)
							0.75*Lookup[instrumentModelPacket,MaxGrayLevel],
							(* otherwise, return it *)
							Lookup[instrumentModelPacket,DefaultTargetMaxIntensity]
						],
						(* no, set to Null *)
						Null
					],
					(* else: is ExposureTime set to AutoExpose? *)
					If[MatchQ[exposureTime,AutoExpose],
						Module[{maxGrayLevel},
							(* get the max gray level from our instrument *)
							maxGrayLevel=Lookup[instrumentModelPacket,MaxGrayLevel];
							(* is the specified value within instrument's range? *)
							If[MatchQ[targetMaxIntensity,GreaterP[maxGrayLevel]]||NullQ[targetMaxIntensity],
								(* no, flip the error switch *)
								invalidTargetMaxIntensityError=True;
							];
							(* return the specified value *)
							targetMaxIntensity
						],
						(* else: is TargetMaxIntensity set to Null? *)
						If[NullQ[targetMaxIntensity],
							(* yes, return as is *)
							targetMaxIntensity,
							(* no, flip the error switch and return value since we don't allow TargetMaxIntensity to be set when we AutoExpose *)
							notAllowedTargetMaxIntensityError=True;targetMaxIntensity
						]
					]
				];

				(* ---15. resolve TimelapseImageCollection--- *)

				(* get the Timelapse option *)
				(* note: this is a boolean that determines if we allow timelapse imaging for our imaging run *)
				(* we allow each imaging channel to be turned on/off for timelapse imaging individually *)
				timelapseQ=TrueQ@Lookup[roundedAcquireImageOptions,Timelapse];

				(* does TimelapseImageCollection agree with timelapseQ? *)
				resolvedTimelapseImageCollection=Switch[{timelapseQ,timelapseImageCollection},
					(* TimelapseImageCollection is Automatic and Timelapse is True, resolve to All *)
					{True,Automatic},All,
					(* TimelapseImageCollection is Automatic and Timelapse is False, resolve to Null *)
					{False,Automatic},Null,
					(* if Timelapse is True, TimelapseImageCollection cannot be Null *)
					{True,Null},unspecifiedTimelapseImageCollectionError=True;timelapseImageCollection,
					(* if Timelapse is False, TimelapseImageCollection must be Null *)
					{False,Except[Null]},notAllowedTimelapseImageCollectionError=True;timelapseImageCollection,
					(* if specified as a number, flip the error switch if it exceeds NumberOfTimepoints we resolved in the main resolver *)
					{_,NumericP},
					If[MatchQ[timelapseImageCollection,GreaterP[Lookup[roundedAcquireImageOptions,NumberOfTimepoints]]],
						invalidTimelapseImageCollectionError=True;timelapseImageCollection,
						timelapseImageCollection
					],
					(* all other cases are valid, accept the specified value *)
					_,timelapseImageCollection
				];

				(* ---16. resolve ZStackImageCollection--- *)
				(* ZStackImageCollection must agree with ZStack option *)

				(* get the ZStack option *)
				(* note: this is a boolean that determines if we allow z-stack imaging for our imaging run *)
				(* we allow each imaging channel to be turned on/off for z-stack imaging individually *)
				zStackQ=TrueQ@Lookup[roundedAcquireImageOptions,ZStack];

				(* resolve ZStackImageCollection *)
				resolvedZStackImageCollection=Switch[{zStackQ,zStackImageCollection},
					(* if ZStack is False, ZStackImageCollection cannot be True *)
					{False,True},notAllowedZStackImageCollectionError=True;zStackImageCollection,
					(* if Automatic, set to zStackQ *)
					{_,Automatic},zStackQ,
					(* all other cases, set to specified value *)
					_,zStackImageCollection
				];

				(* 17. resolve ImagingChannel *)
				(* after resolving all options, if ImagingChannel is Automatic, set to proper value based on resolved options *)
				resolvedImagingChannel=If[MatchQ[imagingChannel,Automatic],
					(* does Mode match any fluorescent imaging mode? *)
					If[MatchQ[resolvedMode,MicroscopeFluorescentModeP],
						(* find if our parameters match any pre-defined channel on the instrument. if not return CustomChannel *)
						FirstCase[
							instrumentImagingChannelTuples,
							{channel_,Sequence@@N[{resolvedExcitationWavelength,resolvedEmissionWavelength,resolvedDichroicFilterWavelength}]}:>channel,
							CustomChannel
						],
						(* else: set to TransmittedLight *)
						TransmittedLight
					],
					(* else: return the specified value. error check already performed upfront *)
					imagingChannel
				];

				(* ---return the error-tracking variables and resolved option values--- *)
				{
					(* error-tracking variables*)
					(*1*)unsupportedModeError,
					(*2*)detectionLabelInUseWarning,
					(*3*)fluorescenceImagingNotSupportedWarning,
					(*4*)brightFieldImagingNotSupportedWarning,
					(*5*)unresolvableModeError,
					(*6*)undetectableNonFluorescentLabelWarning,
					(*7*)detectionLabelsNotSpecifiedWarning,
					(*8*)unresolvableExcitationWavelengthWarning,
					(*9*)multipleExcitationWavelengthsWarning,
					(*10*)excitationOutOfRangeWarning,
					(*11*)unsupportedExcitationWavelengthError,
					(*12*)excitationWavelengthNotSpecifiedError,
					(*13*)mismatchedExcitationWavelengthWarning,
					(*14*)unresolvableEmissionWavelengthWarning,
					(*15*)multipleEmissionWavelengthsWarning,
					(*16*)emissionOutOfRangeWarning,
					(*17*)unsupportedEmissionWavelengthError,
					(*18*)emissionWavelengthNotSpecifiedError,
					(*19*)mismatchedEmissionWavelengthWarning,
					(*20*)invalidEmissionWavelengthChannelError,
					(*21*)excitationPowerNotSpecifiedError,
					(*22*)unresolvableDichroicFilterWavelengthError,
					(*23*)dichroicFilterWavelengthNotSpecifiedError,
					(*24*)mistmatchDichroicFilterWavelengthError,
					(*25*)unsupportedDichroicFilterWavelengthError,
					(*26*)notAllowedTransmittedLightPowerError,
					(*27*)notAllowedTransmittedLightColorCorrectionError,
					(*28*)undetectableFluorescentLabelWarning,
					(*29*)notAllowedExcitationWavelengthError,
					(*30*)notAllowedEmissionWavelengthError,
					(*31*)notAllowedExcitationPowerError,
					(*32*)notAllowedDichroicFilterWavelengthError,
					(*33*)transmittedLightPowerNotSpecifiedError,
					(*34*)colorCorrectionNotSupportedError,
					(*35*)unsupportedImageCorrectionError,
					(*36*)unsupportedImageDeconvolutionError,
					(*37*)mismatchedImageDeconvolutionOptionsError,
					(*38*)unsupportedAutofocusError,
					(*39*)maxWorkingDistanceNotFoundError,
					(*40*)invalidFocalHeightError,
					(*41*)invalidExposureTimeError,
					(*42*)invalidTargetMaxIntensityError,
					(*43*)notAllowedTargetMaxIntensityError,
					(*44*)unspecifiedTimelapseImageCollectionError,
					(*45*)notAllowedTimelapseImageCollectionError,
					(*46*)invalidTimelapseImageCollectionError,
					(*47*)notAllowedZStackImageCollectionError,
					(*48*)conflictingModeAndChannelError,
					(*49*)customChannelNotAllowedError,
					(*50*)conflictingImagingChannelsAndOptionsError,
					(*51*)unsupportedImagingChannelError,
					(*52*)unresolvableModeWithChannelError,

					(* error objects variable *)
					overlappingDetectionLabel,
					undetectableNonFluorescentLabel,
					unresolvevableDetectionLabel,
					undetectableFluorescentLabel,
					conflictingImagingChannelOptionName,

					(* resolved option values*)
					resolvedMode,
					resolvedDetectionLabel,
					resolvedExcitationWavelength,
					resolvedEmissionWavelength,
					resolvedExcitationPower,
					resolvedDichroicFilterWavelength,
					resolvedTransmittedLightPower,
					resolvedTransmittedLightColorCorrection,
					resolvedImageCorrection,
					resolvedImageDeconvolutionKFactor,
					resolvedFocalHeight,
					resolvedTargetMaxIntensity,
					resolvedTimelapseImageCollection,
					resolvedZStackImageCollection,
					resolvedImagingChannel
				}
			]
		],
		mapFriendlyOptions
	]];

	(* -------------------------------- *)
	(* ---UNRESOLVABLE OPTIONS CHECK--- *)
	(* -------------------------------- *)

	(* 1. Mode check *)

	(* if there are unsupportedModeErrors and we are throwing messages, throw an error message*)
	modeInvalidOptions=If[Or@@unsupportedModeErrors&&messages,
		Module[{invalidIndices},
			(* check for Mode not supported by our instrument *)
			invalidIndices=Flatten@Position[unsupportedModeErrors,True];

			(* throw the corresponding error *)
			Message[Error::AcquireImageUnsupportedMode,invalidIndices,ObjectToString[instrument,Cache->newCache]];

			(* return our invalid option names *)
			{Mode}
		],
		{}
	];

	(* create the corresponding test for the unsupported Mode error *)
	unsupportedModeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedModeErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedModeErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified Mode option at index "<>ToString[failingIndices]<>", is supported by the selected instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified Mode option at index "<>ToString[passingIndices]<>", is supported by the selected instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 2. overlapping DetectionLabels check *)

	(* if there are detectionLabelInUseWarnings and we are throwing messages, throw a warning message*)
	If[Or@@detectionLabelInUseWarnings&&messages&&notInEngine,
		Module[{invalidIndices,overlappingLabels},
			(* check for overlapping DetectionLabels *)
			invalidIndices=Flatten@Position[detectionLabelInUseWarnings,True];

			(* get the labels that overlap with other primitives *)
			overlappingLabels=PickList[overlappingDetectionLabels,detectionLabelInUseWarnings];

			(* throw the corresponding warning *)
			Message[Warning::AcquireImageOverlappingDetectionLabels,invalidIndices,ObjectToString[overlappingLabels,Cache->newCache]];
		]
	];

	(* create the corresponding test for the overlapping DetectionLabels warning *)
	overlappingDetectionLabelsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[detectionLabelInUseWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[detectionLabelInUseWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[failingIndices]<>", does not include any object that overlaps with other primitives:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[passingIndices]<>", does not include any object that overlaps with other primitives:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 3. does the instrument support fluorescence imaging when all detection labels are fluorescent?  *)

	(* if there are fluorescenceImagingNotSupportedWarning and we are throwing messages, throw a warning message*)
	If[Or@@fluorescenceImagingNotSupportedWarnings&&messages&&notInEngine,
		Message[Warning::CannotImageFluorescentDetectionLabels,ObjectToString[mySamples,Cache->newCache]]
	];

	(* create the corresponding test for the unsupported fluorescence imaging warning *)
	cannotImageFluorescenceTest=If[gatherTests,
		Warning["The instrument supports fluorescence imaging when all sample's DetectionLabels are fluorescent:",
			Or@@fluorescenceImagingNotSupportedWarnings,
			False
		],
		{}
	];

	(* 4. does the instrument support bright-field or phase-contrast when all detection labels are non-fluorescent?  *)

	(* if there are brightFieldImagingNotSupportedWarnings and we are throwing messages, throw a warning message*)
	If[Or@@brightFieldImagingNotSupportedWarnings&&messages&&notInEngine,
		Message[Warning::CannotImageNonFluorescentDetectionLabels,ObjectToString[mySamples,Cache->newCache]]
	];

	(* create the corresponding test for the unsupported non-fluorescent imaging warning *)
	cannotImageNonFluorescentTest=If[gatherTests,
		Warning["The instrument supports bright-field or phase-contrast imaging when all sample's DetectionLabels are non-fluorescent:",
			Or@@brightFieldImagingNotSupportedWarnings,
			False
		],
		{}
	];

	(* 5. unresolvable Mode due to mixed fluorecent/non-fluorecent detection label *)

	(* if there are unresolvableModeError and we are throwing messages, throw an error message*)
	unresolvableModeOptions=If[Or@@unresolvableModeErrors&&messages,
		Module[{invalidIndices,invalidDetectionLabels},
			(* check for Mode not supported by our instrument *)
			invalidIndices=Flatten@Position[unresolvableModeErrors,True];

			(* get the detection label we cannot resolve Mode for *)
			invalidDetectionLabels=PickList[unresolvevableDetectionLabels,unresolvableModeErrors];

			(* throw the corresponding error *)
			Message[Error::UnresolvableMode,invalidIndices,ObjectToString[invalidDetectionLabels,Cache->newCache]];

			(* return our invalid option names *)
			{Mode,DetectionLabels}
		],
		{}
	];

	(* create the corresponding test for the unresolvable Mode error *)
	unresolvableModeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unresolvableModeErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unresolvableModeErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["Mode for specified DetectionLabels option at index "<>ToString[failingIndices]<>" can be resolved:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["Mode for specified DetectionLabels option at index "<>ToString[passingIndices]<>" can be resolved:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 6. undetectable non-fluorescent label check *)

	(* if there are undetectableNonFluorescentLabelWarnings and we are throwing messages, throw a warning message*)
	If[Or@@undetectableNonFluorescentLabelWarnings&&messages&&notInEngine,
		Module[{invalidIndices,undetectableLabels,undetectableModes},
			(* check for undetectable labels *)
			invalidIndices=Flatten@Position[undetectableNonFluorescentLabelWarnings,True];

			(* get the undetectable labels *)
			undetectableLabels=PickList[undetectableNonFluorescentLabels,undetectableNonFluorescentLabelWarnings];

			(* get the index-matching Mode option *)
			undetectableModes=PickList[resolvedModes,undetectableNonFluorescentLabelWarnings];

			(* throw the corresponding warning *)
			Message[Warning::UndetectableNonFluorescentDetectionLabels,undetectableModes,invalidIndices,ObjectToString[undetectableLabels,Cache->newCache],List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];
		]
	];

	(* create the corresponding test for undetectable non-fluorescent label warning *)
	undetectableNonFluorescentLabelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[undetectableNonFluorescentLabelWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[undetectableNonFluorescentLabelWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[failingIndices]<>", does not include any non-fluorescent molecule when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[passingIndices]<>", does not include any non-fluorescent molecule when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 7. detection label not specified check *)

	(* if there are detectionLabelsNotSpecifiedWarning and we are throwing messages, throw a warning message*)
	If[Or@@detectionLabelsNotSpecifiedWarnings&&messages&&notInEngine,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[detectionLabelsNotSpecifiedWarnings,True];

			(* throw the corresponding warning *)
			Message[Warning::DetectionLabelsNotSpecified,invalidIndices];
		]
	];

	(* create the corresponding test for detection label not specified warning *)
	detectionLabelsNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[detectionLabelsNotSpecifiedWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[detectionLabelsNotSpecifiedWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The DetectionLabels option at index "<>ToString[failingIndices]<>" is not specified as Null:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The DetectionLabels option at index "<>ToString[passingIndices]<>" is not specified as Null:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 8. unresolvable excitation wavelength check *)

	(* if there are unresolvableExcitationWavelengthWarnings and we are throwing messages, throw a warning message*)
	If[Or@@unresolvableExcitationWavelengthWarnings&&messages&&notInEngine,
		Module[{invalidIndices,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unresolvableExcitationWavelengthWarnings,True];

			(* get the index-matching ExcitationWavelength option *)
			defaultedWavelengths=PickList[resolvedExcitationWavelengths,unresolvableExcitationWavelengthWarnings];

			(* throw the corresponding warning *)
			Message[Warning::UnresolvableExcitationWavelength,invalidIndices,defaultedWavelengths];
		]
	];

	(* create the corresponding test for unresolvable excitation wavelength warning *)
	unresolvableExcitationWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unresolvableExcitationWavelengthWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unresolvableExcitationWavelengthWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The ExcitationWavelength at index "<>ToString[failingIndices]<>" can be determined based on DetectionLabels option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The ExcitationWavelength at index "<>ToString[passingIndices]<>" can be determined based on DetectionLabels option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 9. detection label's multiple excitation wavelengths check *)

	(* if there are multipleExcitationWavelengthsWarnings and we are throwing messages, throw a warning message*)
	If[Or@@multipleExcitationWavelengthsWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[multipleExcitationWavelengthsWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,multipleExcitationWavelengthsWarnings];

			(* get the index-matching ExcitationWavelength option *)
			defaultedWavelengths=PickList[resolvedExcitationWavelengths,multipleExcitationWavelengthsWarnings];

			(* throw the corresponding warning *)
			Message[Warning::MultipleExcitationWavelengths,invalidIndices,ObjectToString[detectionLabels,Cache->newCache],defaultedWavelengths];
		]
	];

	(* create the corresponding test for unresolvable excitation wavelength warning *)
	multipleExcitationWavelengthsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[multipleExcitationWavelengthsWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[multipleExcitationWavelengthsWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The molecules specified as DetectionLabels option at index "<>ToString[failingIndices]<>" share a single excitation wavelength:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The molecules specified as DetectionLabels option at index "<>ToString[passingIndices]<>" share a single excitation wavelength:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 10. detection label's excitation wavelengths out of range check *)

	(* if there are excitationOutOfRangeWarnings and we are throwing messages, throw a warning message*)
	If[Or@@excitationOutOfRangeWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[excitationOutOfRangeWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,excitationOutOfRangeWarnings];

			(* get the index-matching ExcitationWavelength option *)
			defaultedWavelengths=PickList[resolvedExcitationWavelengths,excitationOutOfRangeWarnings];

			(* throw the corresponding warning *)
			Message[Warning::ExcitationWavelengthOutOfRange,invalidIndices,detectionLabels,defaultedWavelengths];
		]
	];

	(* create the corresponding test for excitation wavelengths out of range warning *)
	excitationOutOfRangeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[excitationOutOfRangeWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[excitationOutOfRangeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The excitation wavelength of DetectionLabels option at index "<>ToString[failingIndices]<>" is within the instrument's range:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The excitation wavelength of DetectionLabels option at index "<>ToString[passingIndices]<>" is within the instrument's range:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 11. unsupported specified ExcitationWavelength check *)

	(* if there are unsupportedExcitationWavelengthErrors and we are throwing messages, throw an error message*)
	unsupportedExcitationWavelengthOptions=If[Or@@unsupportedExcitationWavelengthErrors&&messages,
		Module[{invalidIndices,invalidExcitationWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedExcitationWavelengthErrors,True];

			(* get the invalid option value *)
			invalidExcitationWavelengths=PickList[resolvedExcitationWavelengths,unsupportedExcitationWavelengthErrors];

			(* throw the corresponding error *)
			Message[Error::UnsupportedExcitationWavelength,invalidExcitationWavelengths,invalidIndices,ObjectToString[instrument,Cache->newCache],Lookup[instrumentModelPacket,FluorescenceExcitationWavelengths]];

			(* return our invalid option names *)
			{ExcitationWavelength}
		],
		{}
	];

	(* create the corresponding test for unsupported specified ExcitationWavelength error *)
	unsupportedExcitationWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedExcitationWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedExcitationWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ExcitationWavelength option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ExcitationWavelength option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 12.  unspecified ExcitationWavelength check *)

	(* if there are excitationWavelengthNotSpecifiedErrors and we are throwing messages, throw an error message*)
	unspecifiedExcitationWavelengthOptions=If[Or@@excitationWavelengthNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[excitationWavelengthNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedExcitationWavelength,invalidIndices];

			(* return our invalid option names *)
			{ExcitationWavelength}
		],
		{}
	];

	(* create the corresponding test for unspecified ExcitationWavelength error *)
	unspecifiedExcitationWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[excitationWavelengthNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[excitationWavelengthNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ExcitationWavelength option at index "<>ToString[failingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ExcitationWavelength option at index "<>ToString[passingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 13. mismatched excitation wavelength check *)

	(* if there are mismatchedExcitationWavelengthWarnings and we are throwing messages, throw a warning message*)
	If[Or@@mismatchedExcitationWavelengthWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,invalidWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[mismatchedExcitationWavelengthWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,mismatchedExcitationWavelengthWarnings];

			(* get the index-matching ExcitationWavelength option *)
			invalidWavelengths=PickList[resolvedExcitationWavelengths,mismatchedExcitationWavelengthWarnings];

			(* throw the corresponding warning *)
			Message[Warning::MismatchedExcitationWavelength,invalidWavelengths,invalidIndices,detectionLabels];
		]
	];

	(* create the corresponding test for mismatched excitation wavelength warning *)
	mismatchedExcitationTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[mismatchedExcitationWavelengthWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[mismatchedExcitationWavelengthWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The specified ExcitationWavelength option at index "<>ToString[failingIndices]<>" matches the Detectionlabels excitation wavelength:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The specified ExcitationWavelength option at index "<>ToString[passingIndices]<>" matches the Detectionlabels excitation wavelength:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 14. unresolvable emission wavelength check *)

	(* if there are unresolvableEmissionWavelengthWarnings and we are throwing messages, throw a warning message*)
	If[Or@@unresolvableEmissionWavelengthWarnings&&messages&&notInEngine,
		Module[{invalidIndices,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unresolvableEmissionWavelengthWarnings,True];

			(* get the index-matching EmissionWavelength option *)
			defaultedWavelengths=PickList[resolvedEmissionWavelengths,unresolvableEmissionWavelengthWarnings];

			(* throw the corresponding warning *)
			Message[Warning::UnresolvableEmissionWavelength,invalidIndices,defaultedWavelengths];
		]
	];

	(* create the corresponding test for unresolvable emission wavelength warning *)
	unresolvableEmissionWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unresolvableEmissionWavelengthWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unresolvableEmissionWavelengthWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The EmissionWavelength at index "<>ToString[failingIndices]<>" can be determined based on DetectionLabels option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The EmissionWavelength at index "<>ToString[passingIndices]<>" can be determined based on DetectionLabels option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 15. detection label's emission wavelengths out of range check *)

	(* if there are multipleEmissionWavelengthsWarnings and we are throwing messages, throw a warning message*)
	If[Or@@multipleEmissionWavelengthsWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[multipleEmissionWavelengthsWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,multipleEmissionWavelengthsWarnings];

			(* get the index-matching EmissionWavelength option *)
			defaultedWavelengths=PickList[resolvedEmissionWavelengths,multipleEmissionWavelengthsWarnings];

			(* throw the corresponding warning *)
			Message[Warning::MultipleEmissionWavelengths,invalidIndices,ObjectToString[detectionLabels,Cache->newCache],defaultedWavelengths];
		]
	];

	(* create the corresponding test for unresolvable emission wavelength warning *)
	multipleEmissionWavelengthsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[multipleEmissionWavelengthsWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[multipleEmissionWavelengthsWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The molecules specified as DetectionLabels option at index "<>ToString[failingIndices]<>" share a single emission wavelength:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The molecules specified as DetectionLabels option at index "<>ToString[passingIndices]<>" share a single emission wavelength:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 16. detection label's emission wavelengths out of range check *)

	(* if there are emissionOutOfRangeWarnings and we are throwing messages, throw a warning message*)
	If[Or@@emissionOutOfRangeWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,defaultedWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[emissionOutOfRangeWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,emissionOutOfRangeWarnings];

			(* get the index-matching EmissionWavelength option *)
			defaultedWavelengths=PickList[resolvedExcitationWavelengths,emissionOutOfRangeWarnings];

			(* throw the corresponding warning *)
			Message[Warning::EmissionWavelengthOutOfRange,invalidIndices,detectionLabels,defaultedWavelengths];
		]
	];

	(* create the corresponding test for emission wavelengths out of range warning *)
	emissionOutOfRangeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[emissionOutOfRangeWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[emissionOutOfRangeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The emission wavelength of DetectionLabels option at index "<>ToString[failingIndices]<>" is within the instrument's range:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The emission wavelength of DetectionLabels option at index "<>ToString[passingIndices]<>" is within the instrument's range:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 17. unsupported specified EmissionWavelength check *)

	(* if there are unsupportedEmissionWavelengthErrors and we are throwing messages, throw an error message*)
	unsupportedEmissionWavelengthOptions=If[Or@@unsupportedEmissionWavelengthErrors&&messages,
		Module[{invalidIndices,invalidEmissionWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedEmissionWavelengthErrors,True];

			(* get the invalid option value *)
			invalidEmissionWavelengths=PickList[resolvedEmissionWavelengths,unsupportedEmissionWavelengthErrors];

			(* throw the corresponding error *)
			Message[Error::UnsupportedEmissionWavelength,invalidEmissionWavelengths,invalidIndices,ObjectToString[instrument,Cache->newCache],Lookup[instrumentModelPacket,FluorescenceEmissionWavelengths]];

			(* return our invalid option names *)
			{EmissionWavelength}
		],
		{}
	];

	(* create the corresponding test for unsupported specified EmissionWavelength error *)
	unsupportedEmissionWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedEmissionWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedEmissionWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified EmissionWavelength option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified EmissionWavelength option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 18.  unspecified EmissionWavelength check *)

	(* if there are emissionWavelengthNotSpecifiedErrors and we are throwing messages, throw an error message*)
	unspecifiedEmissionWavelengthOptions=If[Or@@emissionWavelengthNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[emissionWavelengthNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedEmissionWavelength,invalidIndices];

			(* return our invalid option names *)
			{EmissionWavelength}
		],
		{}
	];

	(* create the corresponding test for unspecified EmissionWavelength error *)
	unspecifiedEmissionWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[emissionWavelengthNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[emissionWavelengthNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The EmissionWavelength option at index "<>ToString[failingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The EmissionWavelength option at index "<>ToString[passingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 19. mismatched emission wavelength check *)

	(* if there are mismatchedEmissionWavelengthWarnings and we are throwing messages, throw a warning message*)
	If[Or@@mismatchedEmissionWavelengthWarnings&&messages&&notInEngine,
		Module[{invalidIndices,detectionLabels,invalidWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[mismatchedEmissionWavelengthWarnings,True];

			(* get the index-matching DetectionLabels option *)
			detectionLabels=PickList[resolvedDetectionLabels,mismatchedEmissionWavelengthWarnings];

			(* get the index-matching ExcitationWavelength option *)
			invalidWavelengths=PickList[resolvedEmissionWavelengths,mismatchedEmissionWavelengthWarnings];

			(* throw the corresponding warning *)
			Message[Warning::MismatchedEmissionWavelength,invalidWavelengths,invalidIndices,detectionLabels];
		]
	];

	(* create the corresponding test for mismatched excitation wavelength warning *)
	mismatchedEmissionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[mismatchedEmissionWavelengthWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[mismatchedEmissionWavelengthWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The specified EmissionWavelength option at index "<>ToString[failingIndices]<>" matches the Detectionlabels emission wavelength:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The specified EmissionWavelength option at index "<>ToString[passingIndices]<>" matches the Detectionlabels emission wavelength:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 20. does emission wavelength matches value of instrument's imaging channel if custom channel is not allowed? *)

	(* if there are invalidEmissionWavelengthChannelErrors and we are throwing messages, throw an error message*)
	invalidEmissionWavelengthChannelOptions=If[Or@@invalidEmissionWavelengthChannelErrors&&messages,
		Module[{invalidIndices,invalidEmissionWavelengths,invalidExcitationWavelengths,wavelengthCombinations,supportedChannels},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidEmissionWavelengthChannelErrors,True];

			(* get the invalid option value *)
			invalidEmissionWavelengths=PickList[resolvedEmissionWavelengths,invalidEmissionWavelengthChannelErrors];

			(* get the invalid option value *)
			invalidExcitationWavelengths=PickList[resolvedExcitationWavelengths,invalidEmissionWavelengthChannelErrors];

			(* get the available wavelength combinationa *)
			wavelengthCombinations=Transpose@Lookup[instrumentModelPacket,{FluorescenceExcitationWavelengths,FluorescenceEmissionWavelengths}];

			(* get the supported imaging channels *)
			supportedChannels=Lookup[instrumentModelPacket,ImagingChannels];

			(* throw the corresponding error *)
			Message[Error::UnsupportedWavelengthCombination,invalidIndices,Transpose[{invalidExcitationWavelengths,invalidEmissionWavelengths}],ObjectToString[instrument,Cache->newCache],wavelengthCombinations,supportedChannels];

			(* return our invalid option names *)
			{ExcitationWavelength,EmissionWavelength}
		],
		{}
	];

	(* create the corresponding test for invalid wavelength combination error *)
	invalidEmissionWavelengthChannelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidEmissionWavelengthChannelErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidEmissionWavelengthChannelErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ExcitationWavelength and EmissionWavelength option at index "<>ToString[failingIndices]<>" matches excitation/emission wavelength combination supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ExcitationWavelength and EmissionWavelength option at index "<>ToString[passingIndices]<>" matches excitation/emission wavelength combination supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 21. unspecified ExcitationPower check *)

	(* if there are excitationPowerNotSpecifiedErrors and we are throwing messages, throw an error message*)
	unspecifiedExcitationPowerOptions=If[Or@@excitationPowerNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[excitationPowerNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedExcitationPower,invalidIndices];

			(* return our invalid option names *)
			{ExcitationPower}
		],
		{}
	];

	(* create the corresponding test for unspecified ExcitationPower error *)
	unspecifiedExcitationPowerTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[excitationPowerNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[excitationPowerNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ExcitationPower option at index "<>ToString[failingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ExcitationPower option at index "<>ToString[passingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 22. unresolvable DichroicFilterWavelength check *)

	(* if there are unresolvableDichroicFilterWavelengthErrors and we are throwing messages, throw an error message*)
	unresolvableDichroicFilterWavelengthOptions=If[Or@@unresolvableDichroicFilterWavelengthErrors&&messages,
		Module[{invalidIndices,invalidEmissionWavelengths,invalidExcitationWavelengths,wavelengthCombinations,supportedChannels},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unresolvableDichroicFilterWavelengthErrors,True];

			(* get the invalid option value *)
			invalidEmissionWavelengths=PickList[resolvedEmissionWavelengths,unresolvableDichroicFilterWavelengthErrors];

			(* get the invalid option value *)
			invalidExcitationWavelengths=PickList[resolvedExcitationWavelengths,unresolvableDichroicFilterWavelengthErrors];

			(* get the available wavelength combination *)
			wavelengthCombinations=Transpose@Lookup[instrumentModelPacket,{FluorescenceExcitationWavelengths,FluorescenceEmissionWavelengths,DichroicFilterWavelengths}];

			(* get the supported imaging channels *)
			supportedChannels=Lookup[instrumentModelPacket,ImagingChannels];

			(* throw the corresponding error *)
			Message[Error::UnresolvableDichroicFilterWavelength,invalidIndices,Transpose[{invalidExcitationWavelengths,invalidEmissionWavelengths}],ObjectToString[instrument,Cache->newCache],wavelengthCombinations,supportedChannels];

			(* return our invalid option names *)
			{DichroicFilterWavelength}
		],
		{}
	];

	(* create the corresponding test for unresolvable DichroicFilterWavelength error *)
	unresolvableDichroicFilterWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unresolvableDichroicFilterWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unresolvableDichroicFilterWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["DichroicFilterWavelength option at index "<>ToString[failingIndices]<>" can be resolved from ExcitationWavelength and EmissionWavelength options:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["DichroicFilterWavelength option at index "<>ToString[passingIndices]<>" can be resolved from ExcitationWavelength and EmissionWavelength options:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 23. unspecified DichroicFilterWavelength check *)

	(* if there are dichroicFilterWavelengthNotSpecifiedErrors and we are throwing messages, throw an error message*)
	unspecifiedDichroicFilterWavelengthOptions=If[Or@@dichroicFilterWavelengthNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[dichroicFilterWavelengthNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedDichroicFilterWavelength,invalidIndices];

			(* return our invalid option names *)
			{DichroicFilterWavelength}
		],
		{}
	];

	(* create the corresponding test for unspecified DichroicFilterWavelength error *)
	unspecifiedDichroicFilterWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[dichroicFilterWavelengthNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[dichroicFilterWavelengthNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The DichroicFilterWavelength option at index "<>ToString[failingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The DichroicFilterWavelength option at index "<>ToString[passingIndices]<>" is not Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 24. mismatched DichroicFilterWavelength check *)

	(* if there are mistmatchDichroicFilterWavelengthErrors and we are throwing messages, throw an error message*)
	mismatchedDichroicFilterWavelengthOptions=If[Or@@mistmatchDichroicFilterWavelengthErrors&&messages,
		Module[{invalidIndices,invalidEmissionWavelengths,invalidExcitationWavelengths,wavelengthCombinations,supportedChannels},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[mistmatchDichroicFilterWavelengthErrors,True];

			(* get the invalid option value *)
			invalidEmissionWavelengths=PickList[resolvedEmissionWavelengths,mistmatchDichroicFilterWavelengthErrors];

			(* get the invalid option value *)
			invalidExcitationWavelengths=PickList[resolvedExcitationWavelengths,mistmatchDichroicFilterWavelengthErrors];

			(* get the available wavelength combination *)
			wavelengthCombinations=Transpose@Lookup[instrumentModelPacket,{FluorescenceExcitationWavelengths,FluorescenceEmissionWavelengths,DichroicFilterWavelengths}];

			(* get the supported imaging channels *)
			supportedChannels=Lookup[instrumentModelPacket,ImagingChannels];

			(* throw the corresponding error *)
			Message[Error::MismatchedDichroicFilterWavelength,invalidIndices,Transpose[{invalidExcitationWavelengths,invalidEmissionWavelengths}],ObjectToString[instrument,Cache->newCache],wavelengthCombinations,supportedChannels];

			(* return our invalid option names *)
			{DichroicFilterWavelength}
		],
		{}
	];

	(* create the corresponding test for mismatched DichroicFilterWavelength error *)
	mismatchedDichroicFilterWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[mistmatchDichroicFilterWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[mistmatchDichroicFilterWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified DichroicFilterWavelength option at index "<>ToString[failingIndices]<>" matches Excitation/Emission/Dichroic wavelength combination supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified DichroicFilterWavelength option at index "<>ToString[passingIndices]<>" matches Excitation/Emission/Dichroic wavelength combination supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 25. unsupported specified DichroicFilterWavelength check *)

	(* if there are unsupportedDichroicFilterWavelengthErrors and we are throwing messages, throw an error message*)
	unsupportedDichroicFilterWavelengthOptions=If[Or@@unsupportedDichroicFilterWavelengthErrors&&messages,
		Module[{invalidIndices,invalidWavelengths},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedDichroicFilterWavelengthErrors,True];

			(* get the invalid option value *)
			invalidWavelengths=PickList[resolvedDichroicFilterWavelengths,unsupportedDichroicFilterWavelengthErrors];

			(* throw the corresponding error *)
			Message[Error::UnsupportedDichroicFilterWavelength,invalidWavelengths,invalidIndices,ObjectToString[instrument,Cache->newCache],Lookup[instrumentModelPacket,DichroicFilterWavelengths]];

			(* return our invalid option names *)
			{DichroicFilterWavelength}
		],
		{}
	];

	(* create the corresponding test for unsupported specified DichroicFilterWavelength error *)
	unsupportedDichroicFilterWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedDichroicFilterWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedDichroicFilterWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified DichroicFilterWavelength option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified DichroicFilterWavelength option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 26. not allowed TransmittedLightPower check *)

	(* if there are notAllowedTransmittedLightPowerErrors and we are throwing messages, throw an error message*)
	notAllowedTransmittedLightPowerOptions=If[Or@@notAllowedTransmittedLightPowerErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTransmittedLightPowerErrors,True];

			(* throw the corresponding error *)
			Message[Error::TransmittedLightPowerNotAllowed,invalidIndices,List@@MicroscopeFluorescentModeP];

			(* return our invalid option names *)
			{TransmittedLightPower}
		],
		{}
	];

	(* create the corresponding test for not allowed TransmittedLightPower error *)
	notAllowedTransmittedLightPowerTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTransmittedLightPowerErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTransmittedLightPowerErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TransmittedLightPower option at index "<>ToString[failingIndices]<>" is Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TransmittedLightPower option at index "<>ToString[passingIndices]<>" is Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 27. not allowed TransmittedLightColorCorrection check *)

	(* if there are notAllowedTransmittedLightColorCorrectionErrors and we are throwing messages, throw an error message*)
	notAllowedTransmittedLightColorCorrectionOptions=If[Or@@notAllowedTransmittedLightColorCorrectionErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTransmittedLightColorCorrectionErrors,True];

			(* throw the corresponding error *)
			Message[Error::TransmittedLightColorCorrectionNotAllowed,invalidIndices,List@@MicroscopeFluorescentModeP];

			(* return our invalid option names *)
			{TransmittedLightColorCorrection}
		],
		{}
	];

	(* create the corresponding test for not allowed TransmittedLightColorCorrection error *)
	notAllowedTransmittedLightColorCorrectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTransmittedLightColorCorrectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTransmittedLightColorCorrectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TransmittedLightColorCorrection option at index "<>ToString[failingIndices]<>" is Null when fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TransmittedLightColorCorrection option at index "<>ToString[passingIndices]<>" is Null when fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 28. undetectable fluorescent label check *)

	(* if there are undetectableFluorescentLabelWarnings and we are throwing messages, throw a warning message*)
	If[Or@@undetectableFluorescentLabelWarnings&&messages&&notInEngine,
		Module[{invalidIndices,undetectableLabels,undetectableModes},
			(* check for undetectable labels *)
			invalidIndices=Flatten@Position[undetectableFluorescentLabelWarnings,True];

			(* get the undetectable labels *)
			undetectableLabels=PickList[undetectableFluorescentLabels,undetectableFluorescentLabelWarnings];

			(* get the index-matching Mode option *)
			undetectableModes=PickList[resolvedModes,undetectableFluorescentLabelWarnings];

			(* throw the corresponding warning *)
			Message[Warning::UndetectableFluorescentDetectionLabels,undetectableModes,invalidIndices,ObjectToString[undetectableLabels,Cache->newCache],List@@MicroscopeFluorescentModeP];
		]
	];

	(* create the corresponding test for undetectable fluorescent label warning *)
	undetectableFluorescentLabelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[undetectableFluorescentLabelWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[undetectableFluorescentLabelWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[failingIndices]<>", does not include any fluorescent molecule when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The specified DetectionLabels option at index "<>ToString[passingIndices]<>", does not include any fluorescent molecule when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 29. not allowed ExcitationWavelength check *)

	(* if there are notAllowedExcitationWavelengthErrors and we are throwing messages, throw an error message*)
	notAllowedExcitationWavelengthOptions=If[Or@@notAllowedExcitationWavelengthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedExcitationWavelengthErrors,True];

			(* throw the corresponding error *)
			Message[Error::ExcitationWavelengthNotAllowed,invalidIndices,List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];

			(* return our invalid option names *)
			{ExcitationWavelength}
		],
		{}
	];

	(* create the corresponding test for not allowed ExcitationWavelength error *)
	notAllowedExcitationWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedExcitationWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedExcitationWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ExcitationWavelength option at index "<>ToString[failingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ExcitationWavelength option at index "<>ToString[passingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 30. not allowed EmissionWavelength check *)

	(* if there are notAllowedEmissionWavelengthErrors and we are throwing messages, throw an error message*)
	notAllowedEmissionWavelengthOptions=If[Or@@notAllowedEmissionWavelengthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedEmissionWavelengthErrors,True];

			(* throw the corresponding error *)
			Message[Error::EmissionWavelengthNotAllowed,invalidIndices,List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];

			(* return our invalid option names *)
			{EmissionWavelength}
		],
		{}
	];

	(* create the corresponding test for not allowed EmissionWavelength error *)
	notAllowedEmissionWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedEmissionWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedEmissionWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The EmissionWavelength option at index "<>ToString[failingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The EmissionWavelength option at index "<>ToString[passingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 31. not allowed ExcitationPower check *)

	(* if there are notAllowedExcitationPowerErrors and we are throwing messages, throw an error message*)
	notAllowedExcitationPowerOptions=If[Or@@notAllowedExcitationPowerErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedExcitationPowerErrors,True];

			(* throw the corresponding error *)
			Message[Error::ExcitationPowerNotAllowed,invalidIndices,List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];

			(* return our invalid option names *)
			{ExcitationPower}
		],
		{}
	];

	(* create the corresponding test for not allowed ExcitationPower error *)
	notAllowedExcitationPowerTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedExcitationPowerErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedExcitationPowerErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ExcitationPower option at index "<>ToString[failingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ExcitationPower option at index "<>ToString[passingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 32. not allowed DichroicFilterWavelength check *)

	(* if there are notAllowedDichroicFilterWavelengthErrors and we are throwing messages, throw an error message*)
	notAllowedDichroicFilterWavelengthOptions=If[Or@@notAllowedDichroicFilterWavelengthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedDichroicFilterWavelengthErrors,True];

			(* throw the corresponding error *)
			Message[Error::DichroicFilterWavelengthNotAllowed,invalidIndices,List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];

			(* return our invalid option names *)
			{DichroicFilterWavelength}
		],
		{}
	];

	(* create the corresponding test for not allowed DichroicFilterWavelength error *)
	notAllowedDichroicFilterWavelengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedDichroicFilterWavelengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedDichroicFilterWavelengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The DichroicFilterWavelength option at index "<>ToString[failingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The DichroicFilterWavelength option at index "<>ToString[passingIndices]<>" is Null when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 33. unspecified TransmittedLightPower check *)

	(* if there are transmittedLightPowerNotSpecifiedErrors and we are throwing messages, throw an error message*)
	unspecifiedTransmittedLightPowerOptions=If[Or@@transmittedLightPowerNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[transmittedLightPowerNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedTransmittedLightPower,invalidIndices,List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]];

			(* return our invalid option names *)
			{TransmittedLightPower}
		],
		{}
	];

	(* create the corresponding test for unspecified TransmittedLightPower error *)
	unspecifiedTransmittedLightPowerTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[transmittedLightPowerNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[transmittedLightPowerNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TransmittedLightPower option at index "<>ToString[failingIndices]<>" is not Null when non-fluorescence imaging mode is selected:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TransmittedLightPower option at index "<>ToString[passingIndices]<>" is not Null when non-fluorescence imaging mode is selected:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 34. unsupported specified TransmittedLightColorCorrection check *)

	(* if there are colorCorrectionNotSupportedErrors and we are throwing messages, throw an error message*)
	unsupportedTransmittedLightColorCorrectionOptions=If[Or@@colorCorrectionNotSupportedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[colorCorrectionNotSupportedErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnsupportedTransmittedLightColorCorrection,invalidIndices,ObjectToString[instrument,Cache->newCache]];

			(* return our invalid option names *)
			{TransmittedLightColorCorrection}
		],
		{}
	];

	(* create the corresponding test for unsupported specified TransmittedLightColorCorrection error *)
	unsupportedTransmittedLightColorCorrectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[colorCorrectionNotSupportedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[colorCorrectionNotSupportedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified TransmittedLightColorCorrection option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified TransmittedLightColorCorrection option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 35. unsupported specified ImageCorrection check *)

	(* if there are unsupportedImageCorrectionErrors and we are throwing messages, throw an error message*)
	unsupportedImageCorrectionOptions=If[Or@@unsupportedImageCorrectionErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedImageCorrectionErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedImageCorrections,unsupportedImageCorrectionErrors];

			(* throw the corresponding error *)
			Message[Error::UnsupportedImageCorrection,invalidIndices,invalidValues,ObjectToString[instrument,Cache->newCache],Lookup[instrumentModelPacket,ImageCorrectionMethods]];

			(* return our invalid option names *)
			{ImageCorrection}
		],
		{}
	];

	(* create the corresponding test for unsupported specified ImageCorrection error *)
	unsupportedImageCorrectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedImageCorrectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedImageCorrectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ImageCorrection option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ImageCorrection option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 36. unsupported specified ImageDeconvolution check *)

	(* if there are unsupportedImageDeconvolutionErrors and we are throwing messages, throw an error message*)
	unsupportedImageDeconvolutionOptions=If[Or@@unsupportedImageDeconvolutionErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedImageDeconvolutionErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnsupportedImageDeconvolution,invalidIndices,ObjectToString[instrument,Cache->newCache]];

			(* return our invalid option names *)
			{ImageDeconvolution}
		],
		{}
	];

	(* create the corresponding test for unsupported specified ImageDeconvolution error *)
	unsupportedImageDeconvolutionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedImageDeconvolutionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedImageDeconvolutionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ImageDeconvolution option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ImageDeconvolution option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 37. conflicting ImageDeconvolution and ImageDeconvolutionKFactor check *)

	(* if there are mismatchedImageDeconvolutionOptionsErrors and we are throwing messages, throw an error message*)
	conflictingImageDeconvolutionOptions=If[Or@@mismatchedImageDeconvolutionOptionsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[mismatchedImageDeconvolutionOptionsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ConflictingImageDeconvolutionOptions,invalidIndices];

			(* return our invalid option names *)
			{ImageDeconvolution,ImageDeconvolutionKFactor}
		],
		{}
	];

	(* create the corresponding test for conflicting deconvolution options error *)
	conflictingImageDeconvolutionOptionsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[mismatchedImageDeconvolutionOptionsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[mismatchedImageDeconvolutionOptionsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ImageDeconvolution and ImageDeconvolutionKFactor options at index "<>ToString[failingIndices]<>" are not conflicting:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ImageDeconvolution and ImageDeconvolutionKFactor options at index "<>ToString[passingIndices]<>" are not conflicting:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 38. unsupported autofocus check *)

	(* if there are unsupportedAutofocusErrors and we are throwing messages, throw an error message*)
	unsupportedAutofocusOptions=If[Or@@unsupportedAutofocusErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedAutofocusErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnsupportedAutofocus,invalidIndices,ObjectToString[instrument,Cache->newCache]];

			(* return our invalid option names *)
			{FocalHeight}
		],
		{}
	];

	(* create the corresponding test for unsupported autofocus error *)
	unsupportedAutofocusTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedAutofocusErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedAutofocusErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If FocalHeight option at index "<>ToString[failingIndices]<>" is Autofocus the instrument can perform auto focusing:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If FocalHeight option at index "<>ToString[passingIndices]<>" is Autofocus the instrument can perform auto focusing:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 39. objective lens not found check *)

	(* if there are maxWorkingDistanceNotFoundErrors and we are throwing messages, throw an error message*)
	invalidObjectiveMagnificationOptions=If[Or@@maxWorkingDistanceNotFoundErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[maxWorkingDistanceNotFoundErrors,True];

			(* throw the corresponding error *)
			Message[Error::InvalidObjectiveMagnification,invalidIndices,objectiveMagnification,ObjectToString[instrument,Cache->newCache],Lookup[Flatten@objectiveModelPackets,Magnification]];

			(* return our invalid option names *)
			{FocalHeight,ObjectiveMagnification}
		],
		{}
	];

	(* create the corresponding test for objective lens not found error *)
	invalidObjectiveMagnificationTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[maxWorkingDistanceNotFoundErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[maxWorkingDistanceNotFoundErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If FocalHeight option at index "<>ToString[failingIndices]<>" is Autofocus, the instrument can perform auto focusing:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If FocalHeight option at index "<>ToString[passingIndices]<>" is Autofocus, the instrument can perform auto focusing:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 40. FocalHeight validation check *)

	(* if there are invalidFocalHeightErrors and we are throwing messages, throw an error message*)
	invalidFocalHeightOptions=If[Or@@invalidFocalHeightErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidFocalHeightErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedFocalHeights,invalidFocalHeightErrors];

			(* throw the corresponding error *)
			Message[
				Error::InvalidFocalHeight,
				invalidIndices,
				invalidValues,
				ObjectToString[Lookup[objectiveModelPacketToUse,Object],Cache->newCache],
				Lookup[objectiveModelPacketToUse,MaxWorkingDistance]
			];

			(* return our invalid option names *)
			{FocalHeight}
		],
		{}
	];

	(* create the corresponding test for invalid FocalHeight error *)
	invalidFocalHeightTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidFocalHeightErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidFocalHeightErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified FocalHeight option at index "<>ToString[failingIndices]<>" does not exceed the objective's maximum working distance:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified FocalHeight option at index "<>ToString[passingIndices]<>" does not exceed the objective's maximum working distance:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 41. ExposureTime validation check *)

	(* if there are invalidExposureTimeErrors and we are throwing messages, throw an error message*)
	invalidExposureTimeOptions=If[Or@@invalidExposureTimeErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidExposureTimeErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[Lookup[mapFriendlyOptions,ExposureTime],invalidExposureTimeErrors];

			(* throw the corresponding error *)
			Message[
				Error::InvalidExposureTime,
				invalidIndices,
				invalidValues,
				Lookup[instrumentModelPacket,MinExposureTime],
				Lookup[instrumentModelPacket,MaxExposureTime]
			];

			(* return our invalid option names *)
			{ExposureTime}
		],
		{}
	];

	(* create the corresponding test for invalid ExposureTime error *)
	invalidExposureTimeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidExposureTimeErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidExposureTimeErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ExposureTime option at index "<>ToString[failingIndices]<>" is within the instrument's supported range:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ExposureTime option at index "<>ToString[passingIndices]<>" is within the instrument's supported range:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 42. TargetMaxIntensity validation check *)

	(* if there are invalidTargetMaxIntensityErrors and we are throwing messages, throw an error message*)
	invalidTargetMaxIntensityOptions=If[Or@@invalidTargetMaxIntensityErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidTargetMaxIntensityErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedTargetMaxIntensities,invalidTargetMaxIntensityErrors];

			(* throw the corresponding error *)
			Message[Error::InvalidTargetMaxIntensity,invalidIndices,invalidValues,Lookup[instrumentModelPacket,MaxGrayLevel]];

			(* return our invalid option names *)
			{TargetMaxIntensity}
		],
		{}
	];

	(* create the corresponding test for invalid TargetMaxIntensity error *)
	invalidTargetMaxIntensityTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidTargetMaxIntensityErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidTargetMaxIntensityErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified TargetMaxIntensity option at index "<>ToString[failingIndices]<>" is within the instrument's supported range:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified TargetMaxIntensity option at index "<>ToString[passingIndices]<>" is within the instrument's supported range:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 43. not allowed TargetMaxIntensity check *)

	(* if there are notAllowedTargetMaxIntensityErrors and we are throwing messages, throw an error message*)
	notAllowedTargetMaxIntensityOptions=If[Or@@notAllowedTargetMaxIntensityErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTargetMaxIntensityErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedTargetMaxIntensities,notAllowedTargetMaxIntensityErrors];

			(* throw the corresponding error *)
			Message[Error::TargetMaxIntensityNotAllowed,invalidIndices,invalidValues];

			(* return our invalid option names *)
			{TargetMaxIntensity,ExposureTime}
		],
		{}
	];

	(* create the corresponding test for not allowed TargetMaxIntensity error *)
	notAllowedTargetMaxIntensityTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTargetMaxIntensityErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTargetMaxIntensityErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TargetMaxIntensity option at index "<>ToString[failingIndices]<>" is Null when ExposureTime is not AutoExpose:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TargetMaxIntensity option at index "<>ToString[passingIndices]<>" is Null when ExposureTime is not AutoExpose:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 44. unspecified TimelapseImageCollection check *)

	(* if there are unspecifiedTimelapseImageCollectionErrors and we are throwing messages, throw an error message*)
	unspecifiedTimelapseImageCollectionOptions=If[Or@@unspecifiedTimelapseImageCollectionErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedTimelapseImageCollectionErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnspecifiedTimelapseImageCollection,invalidIndices];

			(* return our invalid option names *)
			{TimelapseImageCollection,Timelapse}
		],
		{}
	];

	(* create the corresponding test for unspecified TimelapseImageCollection error *)
	unspecifiedTimelapseImageCollectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedTimelapseImageCollectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedTimelapseImageCollectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TimelapseImageCollection option at index "<>ToString[failingIndices]<>" is not Null when Timelapse option is True:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TimelapseImageCollection option at index "<>ToString[passingIndices]<>" is not Null when Timelapse option is True:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 45. not allowed TimelapseImageCollection check *)

	(* if there are notAllowedTimelapseImageCollectionErrors and we are throwing messages, throw an error message*)
	notAllowedTimelapseImageCollectionOptions=If[Or@@notAllowedTimelapseImageCollectionErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTimelapseImageCollectionErrors,True];

			(* throw the corresponding error *)
			Message[Error::TimelapseImageCollectionNotAllowed,invalidIndices];

			(* return our invalid option names *)
			{TimelapseImageCollection,Timelapse}
		],
		{}
	];

	(* create the corresponding test for not allowed TimelapseImageCollection error *)
	notAllowedTimelapseImageCollectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTimelapseImageCollectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTimelapseImageCollectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TimelapseImageCollection option at index "<>ToString[failingIndices]<>" is Null when Timelapse option is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TimelapseImageCollection option at index "<>ToString[passingIndices]<>" is Null when Timelapse option is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 46. TimelapseImageCollection validation check *)

	(* if there are invalidTimelapseImageCollectionErrors and we are throwing messages, throw an error message*)
	invalidTimelapseImageCollectionOptions=If[Or@@invalidTimelapseImageCollectionErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidTimelapseImageCollectionErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedTimelapseImageCollections,invalidTimelapseImageCollectionErrors];

			(* throw the corresponding error *)
			Message[Error::InvalidTimelapseImageCollection,invalidIndices,invalidValues,Lookup[roundedAcquireImageOptions,NumberOfTimepoints]];

			(* return our invalid option names *)
			{TimelapseImageCollection,NumberOfTimepoints}
		],
		{}
	];

	(* create the corresponding test for invalid TimelapseImageCollection error *)
	invalidTimelapseImageCollectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidTimelapseImageCollectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidTimelapseImageCollectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified TimelapseImageCollection option at index "<>ToString[failingIndices]<>" is less than NumberOfTimepoints when specified as a number:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified TimelapseImageCollection option at index "<>ToString[passingIndices]<>" is less than NumberOfTimepoints when specified as a number:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 47. not allowed ZStackImageCollection check *)

	(* if there are notAllowedZStackImageCollectionErrors and we are throwing messages, throw an error message*)
	notAllowedZStackImageCollectionOptions=If[Or@@notAllowedZStackImageCollectionErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedZStackImageCollectionErrors,True];

			(* throw the corresponding error *)
			Message[Error::ZStackImageCollectionNotAllowed,invalidIndices];

			(* return our invalid option names *)
			{ZStackImageCollection,ZStack}
		],
		{}
	];

	(* create the corresponding test for not allowed ZStackImageCollection error *)
	notAllowedZStackImageCollectionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedZStackImageCollectionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedZStackImageCollectionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ZStackImageCollection option at index "<>ToString[failingIndices]<>" is False when ZStack option is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ZStackImageCollection option at index "<>ToString[passingIndices]<>" is False when ZStack option is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 48. conflicting Mode and ImagingChannel check *)

	(* if there are conflictingModeAndChannelErrors and we are throwing messages, throw an error message*)
	conflictingModeAndImagingChannelOptions=If[Or@@conflictingModeAndChannelErrors&&messages,
		Module[{invalidIndices,invalidModes,invalidImagingChannel},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[conflictingModeAndChannelErrors,True];

			(* get the invalid Mode *)
			invalidModes=PickList[resolvedModes,conflictingModeAndChannelErrors];

			(* get the invalid ImagingChannel *)
			invalidImagingChannel=PickList[resolvedImagingChannels,conflictingModeAndChannelErrors];

			(* throw the corresponding error *)
			Message[Error::ConflictingModeAndImagingChannel,
				invalidIndices,
				Transpose[{invalidModes,invalidImagingChannel}],
				List@@MicroscopeFluorescentModeP,
				List@@MicroscopeFluorescentImagingChannelP,
				DeleteCases[List@@Complement[MicroscopeImagingChannelP,MicroscopeFluorescentImagingChannelP],CustomChannel],
				List@@Complement[MicroscopeModeP,MicroscopeFluorescentModeP]
			];

			(* return our invalid option names *)
			{Mode,ImagingChannel}
		],
		{}
	];

	(* create the corresponding test for conflicting  Mode and ImagingChannel options error *)
	conflictingModeAndImagingChannelOptionsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[conflictingModeAndChannelErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[conflictingModeAndChannelErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified Mode and ImagingChannel options at index "<>ToString[failingIndices]<>" are not conflicting:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified Mode and ImagingChannel options at index "<>ToString[passingIndices]<>" are not conflicting:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 49. not allowed CustomChannel check *)

	(* if there are customChannelNotAllowedErrors and we are throwing messages, throw an error message*)
	notAllowedCustomChannelOptions=If[Or@@customChannelNotAllowedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[customChannelNotAllowedErrors,True];

			(* throw the corresponding error *)
			Message[Error::CustomChannelNotAllowed,invalidIndices,DeleteCases[List@@MicroscopeImagingChannelP,CustomChannel]];

			(* return our invalid option names *)
			{ImagingChannel}
		],
		{}
	];

	(* create the corresponding test for not allowed CustomChannel error *)
	notAllowedCustomChannelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[customChannelNotAllowedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[customChannelNotAllowedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[failingIndices]<>", the value is not CustomChannel:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[passingIndices]<>", the value is not CustomChannel:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 50. conflicting ImagingChannel and related options check *)

	(* if there are conflictingImagingChannelsAndOptionsErrors and we are throwing messages, throw an error message*)
	conflictingImagingChannelOptions=If[Or@@conflictingImagingChannelsAndOptionsErrors&&messages,
		Module[{invalidIndices,conflictingOptions},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[conflictingImagingChannelsAndOptionsErrors,True];

			(* get conflicting options *)
			conflictingOptions=PickList[conflictingImagingChannelOptionNames,conflictingImagingChannelsAndOptionsErrors];

			(* throw the corresponding error *)
			Message[Error::ConflictingImagingChannelOptions,invalidIndices,conflictingOptions];

			(* return our invalid option names *)
			Union[{ImagingChannel},Flatten@conflictingImagingChannelOptionNames]
		],
		{}
	];

	(* create the corresponding test for conflicting ImagingChannel options error *)
	conflictingImagingChannelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[conflictingImagingChannelsAndOptionsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[conflictingImagingChannelsAndOptionsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[failingIndices]<>", the following options are Automatic: {ExcitationWavelength, EmissionWavelength, ExcitationPower, DichroicFilterWavelength, TransmittedLightPower}:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[passingIndices]<>", the following options are Automatic: {ExcitationWavelength, EmissionWavelength, ExcitationPower, DichroicFilterWavelength, TransmittedLightPower}:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 51. unsupported ImagingChannel check *)

	(* if there are unsupportedImagingChannelErrors and we are throwing messages, throw an error message*)
	unsupportedImagingChannelOptions=If[Or@@unsupportedImagingChannelErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedImagingChannelErrors,True];

			(* get the invalid option value *)
			invalidValues=PickList[resolvedImagingChannels,unsupportedImagingChannelErrors];

			(* throw the corresponding error *)
			Message[Error::UnsupportedImagingChannel,invalidIndices,invalidValues,ObjectToString[instrument,Cache->newCache],Lookup[instrumentModelPacket,ImagingChannels]];

			(* return our invalid option names *)
			{ImagingChannel}
		],
		{}
	];

	(* create the corresponding test for unsupported ImagingChannel error *)
	unsupportedImagingChannelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unsupportedImagingChannelErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unsupportedImagingChannelErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified ImagingChannel option at index "<>ToString[failingIndices]<>" is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified ImagingChannel option at index "<>ToString[passingIndices]<>" is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 51. check for unresolvable Mode when ImagingChannel is specified *)

	(* if there are unresolvableModeWithChannelErrors and we are throwing messages, throw an error message*)
	unresolvableModeWithChannelOptions=If[Or@@unresolvableModeWithChannelErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unresolvableModeWithChannelErrors,True];

			(* throw the corresponding error *)
			Message[Error::UnresolvableModeWithChannel,invalidIndices];

			(* return our invalid option names *)
			{ImagingChannel}
		],
		{}
	];

	(* create the corresponding test *)
	unresolvableModeWithChannelTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unresolvableModeWithChannelErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unresolvableModeWithChannelErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[failingIndices]<>", Mode option can be determined:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ImagingChannel is specified at index "<>ToString[passingIndices]<>", Mode option can be determined:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* ------------------------ *)
	(* ---FINAL PREPARATIONS--- *)
	(* ------------------------ *)

	(* check our invalid option variables and Error::InvalidOption if necessary. *)
	invalidOptions=DeleteDuplicates[Flatten[{
		modeInvalidOptions,unresolvableModeOptions,unsupportedExcitationWavelengthOptions,unspecifiedExcitationWavelengthOptions,
		unsupportedEmissionWavelengthOptions,unspecifiedEmissionWavelengthOptions,invalidEmissionWavelengthChannelOptions,
		unspecifiedExcitationPowerOptions,unresolvableDichroicFilterWavelengthOptions,unspecifiedDichroicFilterWavelengthOptions,
		mismatchedDichroicFilterWavelengthOptions,unsupportedDichroicFilterWavelengthOptions,notAllowedTransmittedLightPowerOptions,
		notAllowedTransmittedLightColorCorrectionOptions,notAllowedExcitationWavelengthOptions,notAllowedEmissionWavelengthOptions,
		notAllowedExcitationPowerOptions,notAllowedDichroicFilterWavelengthOptions,unspecifiedTransmittedLightPowerOptions,
		unsupportedTransmittedLightColorCorrectionOptions,unsupportedImageCorrectionOptions,unsupportedImageDeconvolutionOptions,
		conflictingImageDeconvolutionOptions,unsupportedAutofocusOptions,invalidObjectiveMagnificationOptions,invalidFocalHeightOptions,
		invalidExposureTimeOptions,invalidTargetMaxIntensityOptions,notAllowedTargetMaxIntensityOptions,unspecifiedTimelapseImageCollectionOptions,
		notAllowedTimelapseImageCollectionOptions,invalidTimelapseImageCollectionOptions,notAllowedZStackImageCollectionOptions,
		conflictingModeAndImagingChannelOptions,notAllowedCustomChannelOptions,conflictingImagingChannelOptions,
		unsupportedImagingChannelOptions,unresolvableModeWithChannelOptions
	}]];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* gather all the tests together *)
	allTests=Cases[Flatten[{
		precisionTests,unsupportedModeTest,overlappingDetectionLabelsTest,cannotImageFluorescenceTest,cannotImageNonFluorescentTest,
		unresolvableModeTest,undetectableNonFluorescentLabelTest,detectionLabelsNotSpecifiedTest,unresolvableExcitationWavelengthTest,
		multipleExcitationWavelengthsTest,excitationOutOfRangeTest,unsupportedExcitationWavelengthTest,unspecifiedExcitationWavelengthTest,
		mismatchedExcitationTest,unresolvableEmissionWavelengthTest,multipleEmissionWavelengthsTest,emissionOutOfRangeTest,
		unsupportedEmissionWavelengthTest,unspecifiedEmissionWavelengthTest,mismatchedEmissionTest,invalidEmissionWavelengthChannelTest,
		unspecifiedExcitationPowerTest,unresolvableDichroicFilterWavelengthTest,unspecifiedDichroicFilterWavelengthTest,
		mismatchedDichroicFilterWavelengthTest,unsupportedDichroicFilterWavelengthTest,notAllowedTransmittedLightPowerTest,
		notAllowedTransmittedLightColorCorrectionTest,undetectableFluorescentLabelTest,notAllowedExcitationWavelengthTest,
		notAllowedEmissionWavelengthTest,notAllowedExcitationPowerTest,notAllowedDichroicFilterWavelengthTest,
		unspecifiedTransmittedLightPowerTest,unsupportedTransmittedLightColorCorrectionTest,unsupportedImageCorrectionTest,
		unsupportedImageDeconvolutionTest,conflictingImageDeconvolutionOptionsTest,unsupportedAutofocusTest,invalidObjectiveMagnificationTest,
		invalidFocalHeightTest,invalidExposureTimeTest,invalidTargetMaxIntensityTest,notAllowedTargetMaxIntensityTest,
		unspecifiedTimelapseImageCollectionTest,notAllowedTimelapseImageCollectionTest,invalidTimelapseImageCollectionTest,
		notAllowedZStackImageCollectionTest,conflictingModeAndImagingChannelOptionsTest,notAllowedCustomChannelTest,
		conflictingImagingChannelTest,unsupportedImagingChannelTest,unresolvableModeWithChannelTest
	}],_EmeraldTest];

	(* all resolved options *)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			Mode->resolvedModes,
			DetectionLabels->resolvedDetectionLabels,
			FocalHeight->resolvedFocalHeights,
			ExposureTime->Lookup[mapFriendlyOptions,ExposureTime],
			TargetMaxIntensity->resolvedTargetMaxIntensities,
			TimelapseImageCollection->resolvedTimelapseImageCollections,
			ZStackImageCollection->resolvedZStackImageCollections,
			ImagingChannel->resolvedImagingChannels,
			ExcitationWavelength->resolvedExcitationWavelengths,
			EmissionWavelength->resolvedEmissionWavelengths,
			ExcitationPower->resolvedExcitationPowers,
			DichroicFilterWavelength->resolvedDichroicFilterWavelengths,
			ImageCorrection->resolvedImageCorrections,
			ImageDeconvolution->Lookup[mapFriendlyOptions,ImageDeconvolution],
			ImageDeconvolutionKFactor->resolvedImageDeconvolutionKFactors,
			TransmittedLightPower->resolvedTransmittedLightPowers,
			TransmittedLightColorCorrection->resolvedTransmittedLightColorCorrections
		},
		Append->False
	];

	(* Return back our result. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}
];