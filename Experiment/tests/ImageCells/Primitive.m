(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentImageCells: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentImageCells*)

DefineTests[
	resolveAcquireImagePrimitive,
	{
		(* basic tests *)
		Example[{Basic,"Automatically generate an AcquireImage primitive for a single input sample:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP}
		],
		Example[{Basic,"Resolve values for all keys of AcquireImage primitive when only one option is specified:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->ConfocalFluorescence
			];
			ContainsExactly[
				Keys[Association@@First[output]],
				DeleteCases[ToExpression@Keys[Options[acquireImagePrimitiveOptions]],ImagingChannel] (* we may decide to include ImagingChannel. leave in option as a place holder *)
			],
			True,
			Variables:>{output}
		],
		Test["Automatically generate an AcquireImage primitive with BrightField Mode for a single input sample without any detection label:",
			primitiveList=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			];
			First[primitiveList][Mode],
			BrightField,
			Variables:>{primitiveList}
		],
		Test["Automatically generate an AcquireImage primitive with Epifluorescence Mode for a single input sample with a fluorescent DetectionLabels:",
			primitiveList=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			];
			First[primitiveList][Mode],
			Epifluorescence,
			Variables:>{primitiveList}
		],
		Example[{Basic,"Automatically generate a set of AcquireImage primitives for a single input sample with multiple DetectionLabels:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP..}
		],
		Example[{Basic,"Automatically generate a set of AcquireImage primitives with Epifluorescence and BrightField Mode for a single input sample with multiple DetectionLabels:"},
			primitiveList=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			];
			ContainsExactly[#[Mode]&/@primitiveList,{BrightField,Epifluorescence}],
			True,
			Variables:>{primitiveList}
		],
		Example[{Basic,"Automatically generate a set of AcquireImage primitives for multiple input samples with multiple DetectionLabels:"},
			resolveAcquireImagePrimitive[{
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Object[Sample,"Test cell sample 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			}],
			{AcquireImagePrimitiveP..}
		],
		Test["Output results as a list of options instead of AcquireImage primitives when Output option is set to Options:",
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Output->Options
			],
			{_Rule..}
		],

		(* options *)
		Example[{Options,Mode,"Generate an AcquireImage primitive with specified Mode:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->ConfocalFluorescence
			];
			First[output][Mode],
			ConfocalFluorescence,
			Variables:>{output}
		],
		Example[{Options,Primitive,"Resolve values for all keys of AcquireImage primitive when a primitive with incomplete keys is specified:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Primitive->{
					AcquireImage[
						Mode->ConfocalFluorescence
					]
				}
			];
			ContainsExactly[
				Keys[Association@@First[output]],
				DeleteCases[ToExpression@Keys[Options[acquireImagePrimitiveOptions]],ImagingChannel] (* we may decide to include ImagingChannel. leave in option as a place holder *)
			],
			True,
			Variables:>{output}
		],
		Example[{Options,Primitive,"Return AcquireImage primitive with matching specified key(s):"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Primitive->{
					AcquireImage[
						Mode->ConfocalFluorescence,
						ExposureTime->10 Millisecond
					]
				}
			];
			{First[output][Mode],First[output][ExposureTime]},
			{ConfocalFluorescence,10 Millisecond},
			Variables:>{output}
		],
		Example[{Options,DetectionLabels,"Generate an AcquireImage primitive with specified DetectionLabels:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DetectionLabels->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			];
			First[output][DetectionLabels],
			ObjectP[Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]],
			Variables:>{output}
		],
		Example[{Options,FocalHeight,"Generate an AcquireImage primitive with specified FocalHeight:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				FocalHeight->8000 Micrometer
			];
			N@First[output][FocalHeight],
			8000. Micrometer,
			Variables:>{output}
		],
		Example[{Options,ExposureTime,"Generate an AcquireImage primitive with specified ExposureTime:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExposureTime->25 Millisecond
			];
			N@First[output][ExposureTime],
			25. Millisecond,
			Variables:>{output}
		],
		Example[{Options,TargetMaxIntensity,"Generate an AcquireImage primitive with specified TargetMaxIntensity:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				TargetMaxIntensity->40000
			];
			First[output][TargetMaxIntensity],
			40000,
			Variables:>{output}
		],
		Example[{Options,TimelapseImageCollection,"Generate an AcquireImage primitive with specified TimelapseImageCollection:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->5,
				TimelapseImageCollection->StartAndEnd
			];
			First[output][TimelapseImageCollection],
			StartAndEnd,
			Variables:>{output}
		],
		Example[{Options,ZStackImageCollection,"Generate an AcquireImage primitive with specified ZStackImageCollection:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ZStack->True,
				ZStackImageCollection->True
			];
			First[output][ZStackImageCollection],
			True,
			Variables:>{output}
		],
		(* keep this as a place holder in case we decide to include ImagingChannel as an option *)
		Example[{Options,ImagingChannel,"Generate an AcquireImage primitive with specified ImagingChannel:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->FITC
			];
			First[output][ImagingChannel],
			_Missing,
			Variables:>{output}
		],
		Example[{Options,ExcitationWavelength,"Generate an AcquireImage primitive with specified ExcitationWavelength:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExcitationWavelength->477 Nanometer
			];
			N@First[output][ExcitationWavelength],
			477. Nanometer,
			Variables:>{output}
		],
		Example[{Options,EmissionWavelength,"Generate an AcquireImage primitive with specified EmissionWavelength:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExcitationWavelength->520 Nanometer
			];
			N@First[output][EmissionWavelength],
			520. Nanometer,
			Variables:>{output}
		],
		Example[{Options,ExcitationPower,"Generate an AcquireImage primitive with specified ExcitationPower:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExcitationPower->30 Percent
			];
			N@First[output][ExcitationPower],
			30. Percent,
			Variables:>{output}
		],
		Example[{Options,DichroicFilterWavelength,"Generate an AcquireImage primitive with specified DichroicFilterWavelength:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DichroicFilterWavelength->488 Nanometer
			];
			N@First[output][DichroicFilterWavelength],
			488. Nanometer,
			Variables:>{output}
		],
		Example[{Options,ImageCorrection,"Generate an AcquireImage primitive with specified ImageCorrection:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageCorrection->ShadingCorrection
			];
			First[output][ImageCorrection],
			ShadingCorrection,
			Variables:>{output}
		],
		Example[{Options,ImageDeconvolution,"Generate an AcquireImage primitive with specified ImageDeconvolution:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageDeconvolution->True
			];
			First[output][ImageDeconvolution],
			True,
			Variables:>{output}
		],
		Example[{Options,ImageDeconvolutionKFactor,"Generate an AcquireImage primitive with specified ImageDeconvolutionKFactor:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageDeconvolution->True,
				ImageDeconvolutionKFactor->0.2
			];
			First[output][ImageDeconvolutionKFactor],
			0.2,
			Variables:>{output}
		],
		Example[{Options,TransmittedLightPower,"Generate an AcquireImage primitive with specified TransmittedLightPower:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				TransmittedLightPower->30 Percent
			];
			N@First[output][TransmittedLightPower],
			30. Percent,
			Variables:>{output}
		],
		Example[{Options,TransmittedLightColorCorrection,"Generate an AcquireImage primitive with specified TransmittedLightColorCorrection:"},
			output=resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				TransmittedLightColorCorrection->False
			];
			First[output][TransmittedLightColorCorrection],
			False,
			Variables:>{output}
		],

		(* shared options *)
		Example[{Options,ZStack,"Allow ZStackImageCollection to be set to True for each AcquireImage primitive:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ZStack->True,
				ZStackImageCollection->True
			],
			{AcquireImagePrimitiveP..}
		],
		Example[{Options,Timelapse,"Allow TimelapseImageCollection to be specified for each AcquireImage primitive:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->7,
				TimelapseImageCollection->StartAndEnd
			],
			{AcquireImagePrimitiveP..}
		],
		Example[{Options,NumberOfTimepoints,"Allow TimelapseImageCollection to specify image collection at every Nth timepoint:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->10,
				TimelapseImageCollection->2
			],
			{AcquireImagePrimitiveP..}
		],
		Example[{Options,ObjectiveMagnification,"Specify objective lens magnification to lookup working distance from the instrument's objective to set FocalHeight correctly:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ObjectiveMagnification->10,
				FocalHeight->3000 Micrometer
			],
			{AcquireImagePrimitiveP..}
		],
		Example[{Options,Instrument,"Specify instrument to be used with ExperimentImageCells to resolve options in AcquireImage primitive accordingly:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP..}
		],

		(* messages *)
		Example[{Messages,"ConflictingPrimitiveOptions","If Primitive option is given, all options in acquireImagePrimitiveOptions must not be specified:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Primitive->{
					AcquireImage[
						ImagingChannel->FITC
					]
				},
				Mode->ConfocalFluorescence
			],
			$Failed,
			Messages:>{Error::ConflictingPrimitiveOptions}
		],
		Example[{Messages,"MissingNumberOfTimepoints","If Timelapse option is True, NumberOfTimepoints must be specified:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True
			],
			$Failed,
			Messages:>{Error::MissingNumberOfTimepoints}
		],
		Example[{Messages,"AcquireImageUnsupportedMode","Throw an error message if the specified Mode option is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->PhaseContrast,
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::AcquireImageUnsupportedMode,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AcquireImageOverlappingDetectionLabels","Throw a warning message if the specified primitives contain overlapping DetectionLabels:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Primitive->{
					AcquireImage[
						DetectionLabels->{
							Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID]
						},
						ImageCorrection->BackgroundCorrection
					],
					AcquireImage[
						DetectionLabels->{
							Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID]
						},
						ImageCorrection->ShadingCorrection
					]
				}
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::AcquireImageOverlappingDetectionLabels}
		],
		Example[{Messages,"CannotImageFluorescentDetectionLabels","Throw a warning if the instrument does not support fluorescence imaging but all sample's DetectionLabels are fluorescent:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Warning::CannotImageFluorescentDetectionLabels,
				Warning::UndetectableFluorescentDetectionLabels
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[Modes]->BrightField|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[Modes]->{BrightField,ConfocalFluorescence,Epifluorescence}|>]
			)
		],
		Example[{Messages,"CannotImageNonFluorescentDetectionLabels","Throw a warning if the instrument does not support non-fluorescence imaging but all sample's DetectionLabels are non-fluorescent:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Warning::CannotImageNonFluorescentDetectionLabels,
				Warning::UndetectableNonFluorescentDetectionLabels
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[Modes]->ConfocalFluorescence|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[Modes]->{BrightField,ConfocalFluorescence,Epifluorescence}|>]
			)
		],
		Example[{Messages,"UnresolvableMode","Throw an error message if unable to resolve Mode option because DetectionLabels option contains both fluorescent and non-fluorescent molecules:"},
			resolveAcquireImagePrimitive[
				{
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				DetectionLabels->{
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test non-fluorescent detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				}
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnresolvableMode,
				Warning::UndetectableNonFluorescentDetectionLabels,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UndetectableNonFluorescentDetectionLabels","Throw a warning message if DetectionLabels option includes any non-fluorescent molecule when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DetectionLabels->Model[Molecule,Protein,"Test non-fluorescent detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->ConfocalFluorescence
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::UndetectableNonFluorescentDetectionLabels}
		],
		Example[{Messages,"DetectionLabelsNotSpecified","Throw a warning message if DetectionLabels option is specified as Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				{
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				DetectionLabels->{
					Null,
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				Mode->Epifluorescence
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Warning::DetectionLabelsNotSpecified,
				Warning::UnresolvableExcitationWavelength,
				Warning::UnresolvableEmissionWavelength
			}
		],
		Example[{Messages,"UnresolvableExcitationWavelength","Throw a warning message if ExcitationWavelength is set to default value because DetectionLabels option is specified as Null:"},
			resolveAcquireImagePrimitive[
				{
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				DetectionLabels->{
					Null,
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				Mode->Epifluorescence
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Warning::DetectionLabelsNotSpecified,
				Warning::UnresolvableExcitationWavelength,
				Warning::UnresolvableEmissionWavelength
			}
		],
		Example[{Messages,"MultipleExcitationWavelengths","Throw a warning message if all molecules specified as DetectionLabels do not share the same excitation wavelength:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DetectionLabels->{
					Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				}
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::MultipleExcitationWavelengths},
			SetUp:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceEmissionMaximums]->{510 Nanometer}
				|>]
			),
			TearDown:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceEmissionMaximums]->{583 Nanometer}
				|>]
			)
		],
		Example[{Messages,"ExcitationWavelengthOutOfRange","Throw a warning message if excitation wavelength of sample's detection label is outside of instrument's supported range:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 6 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::ExcitationWavelengthOutOfRange},
			SetUp:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceEmissionMaximums]->{421 Nanometer}
				|>]
			),
			TearDown:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceEmissionMaximums]->{400 Nanometer}
				|>]
			)
		],
		Example[{Messages,"UnsupportedExcitationWavelength","Throw an error message if the specified ExcitationWavelength is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExcitationWavelength->490 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedExcitationWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnspecifiedExcitationWavelength","Throw an error message if the specified ExcitationWavelength is Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				ExcitationWavelength->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedExcitationWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedExcitationWavelength","Throw a warning message if the specified ExcitationWavelength option does not match the excitation wavelength of the molecules in DetectionLabels option:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExcitationWavelength->546 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::MismatchedExcitationWavelength}
		],
		Example[{Messages,"UnresolvableEmissionWavelength","Throw a warning message if EmissionWavelength is set to default value because DetectionLabels option is specified as Null:"},
			resolveAcquireImagePrimitive[
				{
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				DetectionLabels->{
					Null,
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				},
				Mode->Epifluorescence
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Warning::DetectionLabelsNotSpecified,
				Warning::UnresolvableExcitationWavelength,
				Warning::UnresolvableEmissionWavelength
			}
		],
		Example[{Messages,"MultipleEmissionWavelengths","Throw a warning message if all molecules specified as DetectionLabels do not share the same emission wavelength:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DetectionLabels->{
					Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				}
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::MultipleEmissionWavelengths},
			SetUp:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceExcitationMaximums]->{488 Nanometer}
				|>]
			),
			TearDown:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceExcitationMaximums]->{558 Nanometer}
				|>]
			)
		],
		Example[{Messages,"EmissionWavelengthOutOfRange","Throw a warning message if emission wavelength of sample's detection label is outside of instrument's supported range:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 6 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID]
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::EmissionWavelengthOutOfRange},
			SetUp:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceExcitationMaximums]->{405 Nanometer}
				|>]
			),
			TearDown:>(
				Upload[<|
					Object->Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[FluorescenceExcitationMaximums]->{350 Nanometer}
				|>]
			)
		],
		Example[{Messages,"UnsupportedEmissionWavelength","Throw an error message if the specified EmissionWavelength is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				EmissionWavelength->555 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedEmissionWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnspecifiedEmissionWavelength","Throw an error message if the specified EmissionWavelength is Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				EmissionWavelength->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedEmissionWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedEmissionWavelength","Throw a warning message if the specified EmissionWavelength option does not match the excitation wavelength of the molecules in DetectionLabels option:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				EmissionWavelength->595 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::MismatchedEmissionWavelength}
		],
		Example[{Messages,"UnsupportedWavelengthCombination","Throw an error message if ExcitationWavelength and EmissionWavelength combination does not match any combinations supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				EmissionWavelength->624 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedWavelengthCombination,
				Error::UnresolvableDichroicFilterWavelength,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[{
					<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->Null|>,
					<|Object->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[FluorescenceEmissionMaximums]->{624 Nanometer}|>
				}]
			),
			TearDown:>(
				Upload[{
					<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->True|>,
					<|Object->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[FluorescenceEmissionMaximums]->{510 Nanometer}|>
				}]
			)
		],
		Example[{Messages,"UnspecifiedExcitationPower","Throw an error message if the specified ExcitationPower is Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				ExcitationPower->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedExcitationPower,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnresolvableDichroicFilterWavelength","Throw an error message if DichroicFilterWavelength cannot be determined from ExcitationWavelength and EmissionWavelength options:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				EmissionWavelength->624 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedWavelengthCombination,
				Error::UnresolvableDichroicFilterWavelength,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[{
					<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->Null|>,
					<|Object->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[FluorescenceEmissionMaximums]->{624 Nanometer}|>
				}]
			),
			TearDown:>(
				Upload[{
					<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->True|>,
					<|Object->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[FluorescenceEmissionMaximums]->{510 Nanometer}|>
				}]
			)
		],
		Example[{Messages,"UnspecifiedDichroicFilterWavelength","Throw an error message if the specified DichroicFilterWavelength is Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				DichroicFilterWavelength->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedDichroicFilterWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedDichroicFilterWavelength","Throw an error message if DichroicFilterWavelength does not match any of the ExcitationWavelngth/EmissionWavelength/DichroicFilterWavelength combinations supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DichroicFilterWavelength->656 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::MismatchedDichroicFilterWavelength,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->Null|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],CustomizableImagingChannel->True|>]
			)
		],
		Example[{Messages,"UnsupportedDichroicFilterWavelength","Throw an error message if the specified DichroicFilterWavelength is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DichroicFilterWavelength->555 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedDichroicFilterWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TransmittedLightPowerNotAllowed","Throw an error message if the specified TransmittedLightPower is not Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				TransmittedLightPower->10 Percent
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::TransmittedLightPowerNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TransmittedLightColorCorrectionNotAllowed","Throw an error message if the specified TransmittedLightColorCorrection is not Null when fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->Epifluorescence,
				TransmittedLightColorCorrection->True
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::TransmittedLightColorCorrectionNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UndetectableFluorescentDetectionLabels","Throw a warning message if DetectionLabels option includes any fluorescent molecule when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				DetectionLabels->Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField
			],
			{AcquireImagePrimitiveP...},
			Messages:>{Warning::UndetectableFluorescentDetectionLabels}
		],
		Example[{Messages,"ExcitationWavelengthNotAllowed","Throw an error message if the specified ExcitationWavelength is not Null when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				ExcitationWavelength->477 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ExcitationWavelengthNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EmissionWavelengthNotAllowed","Throw an error message if the specified EmissionWavelength is not Null when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				EmissionWavelength->520 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::EmissionWavelengthNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ExcitationPowerNotAllowed","Throw an error message if the specified ExcitationPower is not Null when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				ExcitationPower->50 Percent
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ExcitationPowerNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DichroicFilterWavelengthNotAllowed","Throw an error message if the specified DichroicFilterWavelength is not Null when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				DichroicFilterWavelength->488 Nanometer
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::DichroicFilterWavelengthNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnspecifiedTransmittedLightPower","Throw an error message if the specified TransmittedLightPower is Null when non-fluorescence imaging mode is selected:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				TransmittedLightPower->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedTransmittedLightPower,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedTransmittedLightColorCorrection","Throw an error message if the specified TransmittedLightColorCorrection is True when the instrument does not support color correction:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Mode->BrightField,
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				TransmittedLightColorCorrection->True
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedTransmittedLightColorCorrection,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedImageCorrection","Throw an error message if the specified ImageCorrection is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageCorrection->BackgroundCorrection
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedImageCorrection,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[ImageCorrectionMethods]->{ShadingCorrection,BackgroundAndShadingCorrection}|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Replace[ImageCorrectionMethods]->{BackgroundCorrection,ShadingCorrection,BackgroundAndShadingCorrection}|>]
			)
		],
		Example[{Messages,"UnsupportedImageDeconvolution","Throw an error message if the specified ImageDeconvolution is True when the instrument does not support image deconvolution:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageDeconvolution->True
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedImageDeconvolution,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],ImageDeconvolution->Null|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],ImageDeconvolution->True|>]
			)
		],
		Example[{Messages,"ConflictingImageDeconvolutionOptions","Throw an error message if ImageDeconvolution and ImageDeconvolutionKFactor options are conflicting:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImageDeconvolution->False,
				ImageDeconvolutionKFactor->0.2
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ConflictingImageDeconvolutionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedAutofocus","Throw an error message if the specified FocalHeight is set to Autofocus when the instrument does not support auto focusing:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				FocalHeight->Autofocus
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedAutofocus,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Autofocus->Null|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],Autofocus->True|>]
			)
		],
		Example[{Messages,"InvalidObjectiveMagnification","Throw an error message if FocalHeight is specified and none of the selected instrument's objective lenses have magnification that matches the ObjectiveMagnification option:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ObjectiveMagnification->5,
				FocalHeight->8 Millimeter
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::InvalidObjectiveMagnification,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidFocalHeight","Throw an error message if the specified FocalHeight exceeds maximum working distance of the objective lens:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ObjectiveMagnification->4,
				FocalHeight->25 Millimeter
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::InvalidFocalHeight,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidExposureTime","Throw an error message if the specified ExposureTime is not within the instrument's supported range:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExposureTime->10 Second
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::InvalidExposureTime,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTargetMaxIntensity","Throw an error message if the specified TargetMaxIntensity is not within the instrument's supported range:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				TargetMaxIntensity->50000
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::InvalidTargetMaxIntensity,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],MaxGrayLevel->30000|>]
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],MaxGrayLevel->65535|>]
			)
		],
		Example[{Messages,"TargetMaxIntensityNotAllowed","Throw an error message if the specified TargetMaxIntensity is not Null when ExposureTime option is set to AutoExpose:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ExposureTime->10 Millisecond,
				TargetMaxIntensity->50000
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::TargetMaxIntensityNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnspecifiedTimelapseImageCollection","Throw an error message if the specified TimelapseImageCollection is Null when Timelapse option is set to True:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->10,
				TimelapseImageCollection->Null
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnspecifiedTimelapseImageCollection,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TimelapseImageCollectionNotAllowed","Throw an error message if the specified TimelapseImageCollection is not Null when Timelapse option is set to False:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->False,
				TimelapseImageCollection->All
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::TimelapseImageCollectionNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTimelapseImageCollection","Throw an error message if TimelapseImageCollection is specified as a number and exceeds NumberOfTimepoints:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->10,
				TimelapseImageCollection->15
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::InvalidTimelapseImageCollection,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ZStackImageCollectionNotAllowed","Throw an error message if the specified ZStackImageCollection is True when ZStack option is set to False:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ZStack->False,
				ZStackImageCollection->True
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ZStackImageCollectionNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingModeAndImagingChannel","Throw an error message if ImagingChannel and Mode options are conflicting:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->TransmittedLight,
				Mode->Epifluorescence
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ConflictingModeAndImagingChannel,
				Error::UnsupportedImagingChannel,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CustomChannelNotAllowed","Throw an error message if ImagingChannel is specified as CustomChannel:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->CustomChannel
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::CustomChannelNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingImagingChannelOptions","Throw an error message if ImagingChannel and the following options are conflicting: {ExcitationWavelength, EmissionWavelength, ExcitationPower, DichroicFilterWavelength, TransmittedLightPower}:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->FITC,
				ExcitationPower->50 Percent
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::ConflictingImagingChannelOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedImagingChannel","Throw an error message if the specified ImagingChannel is not supported by the instrument:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->Cy7
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnsupportedImagingChannel,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnresolvableModeWithChannel","Throw an error if the instrument does not support fluorescence imaging but all sample's DetectionLabels are fluorescent:"},
			resolveAcquireImagePrimitive[
				Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
				ImagingChannel->FITC
			],
			{AcquireImagePrimitiveP...},
			Messages:>{
				Error::UnresolvableModeWithChannel,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|
					Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[Modes]->BrightField
				|>]
			),
			TearDown:>(
				Upload[<|
					Object->Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Replace[Modes]->{BrightField,ConfocalFluorescence,Epifluorescence}
				|>]
			)
		]
	},
	(*  create test objects *)
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					(*fake bench for creating containers*)
					Object[Container,Bench,"Test bench for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*test containers*)
					Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Vessel,"Test 2mL tube for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Hemocytometer,"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*identity models*)
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test non-fluorescent detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*sample models*)
					Model[Sample,"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*test samples*)
					Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 6 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 7 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 8 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 9 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Discarded sample for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Containerless sample for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Sample with incompatible container for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Hemocytometer sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Hemocytometer sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(* Instrument *)
					Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Instrument,Microscope,"Test instrument object for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				}],
				ObjectReferenceP[]
			]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			EraseObject[existingObjs,Force->True,Verbose->False]
		];

		$CreatedObjects={};

		Block[{$AllowSystemsProtocols=True,$DeveloperSearch=True},
			Module[
				{
					fakeBenchPacket,proteinPacket1,proteinPacket2,proteinPacket3,proteinPacket4,proteinPacket5,fakeBench,protein1,protein2,protein3,protein4,protein5,
					containerPackets,cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,cellIdentityModelPacket4,cellIdentityModelPacket5,cellIdentityModelPacket6,
					sampleModel1,sampleModel2,sampleModel3,sampleModel4,sampleModel5,sampleModel6,
					sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,sample13,sample14,
					sampleList,containerList,ixmModelPacket,ixmObjectPacket
				},

				(* set up fake bench as a location for the vessel *)
				fakeBenchPacket=<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Test bench for resolveAcquireImagePrimitive tests" <> $SessionUUID,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
				|>;

				(* create fluorescent protein identity models *)
				{proteinPacket1,proteinPacket2,proteinPacket3,proteinPacket4,proteinPacket5}=UploadProtein[
					{
						"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test non-fluorescent detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					DetectionLabel->True,
					Fluorescent->{True,True,True,Null,True},
					FluorescenceExcitationMaximums->{
						{488 Nanometer},
						{558 Nanometer},
						{643 Nanometer},
						Null,
						{350 Nanometer}
					},
					FluorescenceEmissionMaximums->{
						{510 Nanometer},
						{583 Nanometer},
						{670 Nanometer},
						Null,
						{400 Nanometer}
					},
					Upload->False
				];

				(* first upload call *)
				{fakeBench,protein1,protein2,protein3,protein4,protein5}=Upload[Append[#,DeveloperObject->True]&/@Flatten[{fakeBenchPacket,proteinPacket1,proteinPacket2,proteinPacket3,proteinPacket4,proteinPacket5}]];

				(* set up fake containers for our samples *)
				(* TODO: add a slide example *)
				containerPackets=UploadSample[
					{
						(*1*)Model[Container,Plate,"id:L8kPEjno5XoE"],(* 96-well clear bottom *)
						(*2*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
						(*3*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
						(*4*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
						(*5*)Model[Container,Vessel,"id:3em6Zv9NjjN8"],(* 2mL tube *)
						(*6*)Model[Container,Hemocytometer,"id:aXRlGn6wP7z9"],(* 2-chip hemocytometer *)
						(*7*)Model[Container,Plate,"id:L8kPEjno5XoE"] (* 96-well clear bottom *)
					},
					{
						(*1*){"Work Surface",fakeBench},
						(*2*){"Work Surface",fakeBench},
						(*3*){"Work Surface",fakeBench},
						(*4*){"Work Surface",fakeBench},
						(*5*){"Work Surface",fakeBench},
						(*6*){"Work Surface",fakeBench},
						(*7*){"Work Surface",fakeBench}
					},
					Status->{
						(*1*)Available,
						(*2*)Available,
						(*3*)Available,
						(*4*)Available,
						(*5*)Available,
						(*6*)Available,
						(*7*)Available
					},
					Name->{
						(*1*)"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*2*)"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*3*)"Test plate 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*4*)"Test plate 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*5*)"Test 2mL tube for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*6*)"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*7*)"Test plate 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID
					},
					FastTrack->True,
					Upload->False
				];

				(* create mammalian cell identity models *)
				{
					cellIdentityModelPacket1,
					cellIdentityModelPacket2,
					cellIdentityModelPacket3,
					cellIdentityModelPacket4,
					cellIdentityModelPacket5,
					cellIdentityModelPacket6
				}=UploadMammalianCell[
					{
						"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID
					},
					(*CellType->Adherent,*)
					Morphology->Epithelial,
					Diameter->15 Micrometer,
					BiosafetyLevel->"BSL-2",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					DetectionLabels->{
						Null,
						{protein1},
						{protein2},
						{protein1,protein2,protein3},
						{protein4},
						{protein5}
					},
					CellType->{
						Mammalian,
						Mammalian,
						Mammalian,
						Mammalian,
						Mammalian,
						Mammalian
					},
					CultureAdhesion->{
						Adherent,
						Adherent,
						Adherent,
						Adherent,
						Adherent,
						Adherent
					},
					Upload->False
				];

				(* second upload call *)
				Upload[Flatten[{containerPackets,cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,cellIdentityModelPacket4,cellIdentityModelPacket5,cellIdentityModelPacket6}]];

				(* create default sample models *)
				{sampleModel1,sampleModel2,sampleModel3,sampleModel4,sampleModel5,sampleModel6}=UploadSampleModel[
					{
						(*1*)"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*2*)"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*3*)"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*4*)"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*5*)"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*6*)"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID
					},
					Composition->{
						(*1*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID]}},
						(*2*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID]}},
						(*3*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID]}},
						(*4*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID]}},
						(*5*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID]}},
						(*6*){{100 MassPercent,Model[Cell,Mammalian,"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID]}}
					},
					Expires->False,
					DefaultStorageCondition->Model[StorageCondition,"id:BYDOjvGNDpvm"],(* Mammalian Incubation *)
					State->Liquid,
					BiosafetyLevel->"BSL-2",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					Living->True
				];

				(* set up fake samples to test *)
				{
					(*1*)sample1,
					(*2*)sample2,
					(*3*)sample3,
					(*4*)sample4,
					(*5*)sample5,
					(*6*)sample6,
					(*7*)sample7,
					(*8*)sample8,
					(*9*)sample9,
					(*10*)sample10,
					(*11*)sample11,
					(*12*)sample12,
					(*13*)sample13,
					(*14*)sample14
				}=UploadSample[
					{
						(*1*)sampleModel1,
						(*2*)sampleModel2,
						(*3*)sampleModel3,
						(*4*)sampleModel4,
						(*5*)sampleModel5,
						(*6*)sampleModel6,
						(*7*)sampleModel3,
						(*8*)sampleModel4,
						(*9*)sampleModel1,
						(*10*)sampleModel1,
						(*11*)sampleModel1,
						(*12*)sampleModel5,
						(*13*)sampleModel5,
						(*14*)sampleModel4
					},
					{
						(*1*){"A1",Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*2*){"B1",Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*3*){"C1",Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*4*){"D1",Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*5*){"A2",Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*6*){"B2",Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*7*){"C2",Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*8*){"D2",Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*9*){"A1",Object[Container,Plate,"Test plate 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*10*){"A1",Object[Container,Plate,"Test plate 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*11*){"A1",Object[Container,Vessel,"Test 2mL tube for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*12*){"A1",Object[Container,Hemocytometer,"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*13*){"A2",Object[Container,Hemocytometer,"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID]},
						(*14*){"A1",Object[Container,Plate,"Test plate 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]}
					},
					InitialAmount->{
						(*1*)200 Microliter,
						(*2*)200 Microliter,
						(*3*)200 Microliter,
						(*4*)200 Microliter,
						(*5*)500 Microliter,
						(*6*)500 Microliter,
						(*7*)500 Microliter,
						(*8*)500 Microliter,
						(*9*)500 Microliter,
						(*10*)500 Microliter,
						(*11*)500 Microliter,
						(*12*)10 Microliter,
						(*13*)10 Microliter,
						(*14*)200 Microliter
					},
					Name->{
						(*1*)"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*2*)"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*3*)"Test cell sample 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*4*)"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*5*)"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*6*)"Test cell sample 6 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*7*)"Test cell sample 7 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*8*)"Test cell sample 8 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*9*)"Discarded sample for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*10*)"Containerless sample for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*11*)"Sample with incompatible container for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*12*)"Hemocytometer sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*13*)"Hemocytometer sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID,
						(*14*)"Test cell sample 9 for resolveAcquireImagePrimitive tests" <> $SessionUUID
					},
					SampleHandling->{
						(*1*)Liquid,
						(*2*)Liquid,
						(*3*)Liquid,
						(*4*)Liquid,
						(*5*)Liquid,
						(*6*)Liquid,
						(*7*)Liquid,
						(*8*)Liquid,
						(*9*)Liquid,
						(*10*)Liquid,
						(*11*)Liquid,
						(*12*)Liquid,
						(*13*)Liquid,
						(*14*)Liquid
					},
					CellType->{
						(*1*)Mammalian,
						(*2*)Mammalian,
						(*3*)Mammalian,
						(*4*)Mammalian,
						(*5*)Mammalian,
						(*6*)Mammalian,
						(*7*)Mammalian,
						(*8*)Mammalian,
						(*9*)Mammalian,
						(*10*)Mammalian,
						(*11*)Mammalian,
						(*12*)Mammalian,
						(*13*)Mammalian,
						(*14*)Mammalian
					},
					CultureAdhesion->{
						(*1*)Adherent,
						(*2*)Adherent,
						(*3*)Adherent,
						(*4*)Adherent,
						(*5*)Adherent,
						(*6*)Adherent,
						(*7*)Adherent,
						(*8*)Adherent,
						(*9*)Adherent,
						(*10*)Adherent,
						(*11*)Adherent,
						(*12*)Suspension,
						(*13*)Suspension,
						(*14*)Adherent
					}
				];

				(* make lists of samples/containers *)
				sampleList={sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,sample13,sample14};
				containerList={
					Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Vessel,"Test 2mL tube for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Hemocytometer,"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				};

				(* create instrument model and object *)
				ixmModelPacket=<|
					Object->CreateID[Model[Instrument,Microscope]],
					Name->"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID,
					DeveloperObject->True,
					HighContentImaging->True,
					Autofocus->True,
					CustomizableImagingChannel->True,
					Replace[DefaultExcitationPowers]->ConstantArray[100 Percent,9],
					Replace[DefaultImageCorrections]->{ShadingCorrection,BackgroundAndShadingCorrection,BackgroundAndShadingCorrection},
					DefaultTransmittedLightPower->20 Percent,
					Replace[DichroicFilterWavelengths]->Quantity[{421,445,488,520,564,593,656,656},Nanometer],
					Replace[FluorescenceEmissionWavelengths]->Quantity[{452,483,520,562,595,624,692,692},Nanometer],
					Replace[FluorescenceExcitationWavelengths]->Quantity[{405,446,477,520,546,546,546,638},Nanometer],
					Replace[ImageCorrectionMethods]->{BackgroundCorrection,ShadingCorrection,BackgroundAndShadingCorrection},
					ImageDeconvolution->True,
					Replace[ImagingChannels]->{DAPI,CFP,FITC,YFP,TRITC,TexasRed,Cy3Cy5FRET,Cy5},
					Replace[Modes]->{BrightField,ConfocalFluorescence,Epifluorescence},
					Replace[Objectives]->Link[{
						Model[Part,Objective,"id:eGakldJm3kd4"],
						Model[Part,Objective,"id:D8KAEvGOaAvO"],
						Model[Part,Objective,"id:qdkmxzqXnmLp"],
						Model[Part,Objective,"id:L8kPEjnY7PX4"]
					}],
					MaxImagingChannels->8,
					MinExposureTime->0.01 Millisecond,
					MaxExposureTime->5 Second,
					DefaultTargetMaxIntensity->33000,
					MaxGrayLevel->65535
				|>;

				(* upload instrument object *)
				ixmObjectPacket=<|
					Type->Object[Instrument,Microscope],
					Model->Link[Lookup[ixmModelPacket,Object],Objects],
					Name->"Test instrument object for resolveAcquireImagePrimitive tests" <> $SessionUUID,
					DeveloperObject->True
				|>;

				(* final upload call *)
				Upload[Flatten[{
					(* upload DeveloperObject -> True for all test objects *)
					Map[
						<|Object->#,DeveloperObject->True|>&,
						Cases[Flatten[{$CreatedObjects,sampleList,containerList}],ObjectReferenceP[]]
					],
					(* update DefaultSampleModel of cell identity models *)
					MapThread[
						<|Object->#1,DefaultSampleModel->Link[#2]|>&,
						{
							Lookup[Flatten[{cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,cellIdentityModelPacket4,cellIdentityModelPacket5,cellIdentityModelPacket6}],Object],
							{sampleModel1,sampleModel2,sampleModel3,sampleModel4,sampleModel5,sampleModel6}
						}
					],
					(* upload status for discarded sample *)
					<|Object->sample9,Status->Discarded|>,
					(* remove container for containerless test sample *)
					<|Object->sample10,Container->Null|>,
					(* instrument model and object *)
					ixmModelPacket,
					ixmObjectPacket
				}]];
			]
		];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					(* also get rid of any other created objects *)
					$CreatedObjects,

					(*fake bench for creating containers*)
					Object[Container,Bench,"Test bench for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*test containers*)
					Object[Container,Plate,"Test plate 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Vessel,"Test 2mL tube for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Container,Hemocytometer,"Test Hemocytometer for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*identity models*)
					Model[Molecule,Protein,"Test GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test non-fluorescent detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Molecule,Protein,"Test out-of-range detection label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Cell,Mammalian,"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*sample models*)
					Model[Sample,"Test mammalian cell for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with GFP for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with dsRed for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with GFP/dsRed/iRFP670 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with non-fluorescent label for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Model[Sample,"Test mammalian cell with out-of-range label for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(*test samples*)
					Object[Sample,"Test cell sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 3 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 4 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 5 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 6 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 7 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 8 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Test cell sample 9 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Discarded sample for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Containerless sample for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Sample with incompatible container for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Hemocytometer sample 1 for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Sample,"Hemocytometer sample 2 for resolveAcquireImagePrimitive tests" <> $SessionUUID],

					(* Instrument *)
					Model[Instrument,Microscope,"Test instrument model for resolveAcquireImagePrimitive tests" <> $SessionUUID],
					Object[Instrument,Microscope,"Test instrument object for resolveAcquireImagePrimitive tests" <> $SessionUUID]
				}],
				ObjectReferenceP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False];

			(* clean $CreatedObjects *)
			Unset[$CreatedObjects]
		]
	)
];