(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentFluorescenceKinetics : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Fluorescence Kinetics*)


(* ::Subsubsection:: *)
(*ExperimentFluorescenceKinetics*)

(* TODO tests for injection samples missing container *)

DefineTests[
	ExperimentFluorescenceKinetics,
	{
		Example[{Basic,"Measure the fluorescence kinetics of a sample:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Basic,"Measure the fluorescence kinetics of all samples in a plate:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Additional,"Measure the fluorescence kinetics of all samples in a plate:"},
			ExperimentFluorescenceKinetics[{"A2",Object[Container, Plate, "Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]}],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Additional,"Measure the fluorescence kinetics as ta mixtures of inputs:"},
			ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],{"A2", Object[Container, Plate, "Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]}}],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Additional,"Robotic test call:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		(* -- Additional -- *)
		Example[{Additional,"The correct optic module with required wavelength is resolved for the experiment:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength-> {485 Nanometer, 640 Nanometer},EmissionWavelength-> {590 Nanometer, 680 Nanometer},DualEmissionWavelength-> {520 Nanometer, Null},Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
				OpticModules
			],
			{ObjectP[Model[Part, OpticModule, "Fluorescence Intensity - Excitation: 485nm, EmissionPrimary: 590 nm, EmissionSecondary: 520nm"]], ObjectP[Model[Part, OpticModule, "Fluorescence Intensity - Excitation: 640nm, EmissionPrimary: 680 nm"]]}
		],
		(* -- Messages -- *)
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentFluorescenceKinetics[
				Link[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Now]
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages,"EmptyContainers","All containers provided as input to the experiment must contain samples:"},
			ExperimentFluorescenceKinetics[{Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Container,Plate,"Empty plate for ExperimentFluorescenceKinetics"<>$SessionUUID]}],
			$Failed,
			Messages:>{Error::EmptyContainers}
		],
		Test["When running tests returns False if all containers provided as input to the experiment don't contain samples:",
			ValidExperimentFluorescenceKineticsQ[{Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Container,Plate,"Empty plate for ExperimentFluorescenceKinetics"<>$SessionUUID]}],
			False
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Throws an error if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:"},
			ExperimentFluorescenceKinetics[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
			},
				Aliquot->{False,False,False}
			],
			$Failed,
			Messages:>{
				Error::RepeatedPlateReaderSamples,
				Error::InvalidInput
			}
		],
		Test["When running tests returns False if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:",
			ValidExperimentFluorescenceKineticsQ[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
			},
				Aliquot->{False,False,False}
			],
			False
		],
		Example[{Messages,"ReplicateAliquotsRequired","Throws an error if replicates are requested, but Aliquot has been set to False so replicate samples cannot be created for the read:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Aliquot->False,NumberOfReplicates->3],
			$Failed,
			Messages:>{
				Error::ReplicateAliquotsRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if replicates are requested, but Aliquot has been set to False so replicate samples cannot be created for the read:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Aliquot->False,NumberOfReplicates->3],
			False
		],
		Example[{Messages,"PlateReaderStowaways","Indicates if there are additional samples which weren't sent as an inputs which will be heated while performing the experiment:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Temperature->30 Celsius],
			ObjectP[],
			Messages:>{Warning::PlateReaderStowaways}
		],
		Test["When running tests indicates if there are additional samples which weren't sent as an inputs which will be heated while performing the experiment:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Temperature->30 Celsius],
			True
		],
		Example[{Messages,"PlateReaderStowaways","The PlateReaderStowaways warning is only thrown if samples are set to be heated or mixed in the plate reader chamber:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Temperature -> Ambient,
				PlateReaderMix -> False
			],
			ObjectP[]
		],
		Test["When running tests the PlateReaderStowaways warning is only given if samples are set to be heated or mixed in the plate reader chamber:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
			True
		],
		Example[{Messages,"InstrumentPrecision","If the specified option value is more precise than the instrument can support it will be rounded:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Temperature->28.99 Celsius],
			ObjectP[],
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Test["When running tests indicates if the specified option value is more precise than the instrument can support it will be rounded:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Temperature->28.99 Celsius],
			True
		],
		Example[{Messages,"ModeUnavailable","An error will be thrown and the function call will return $Failed if the PlateReader option cannot be used because the plate reader does not support fluorescence mode experimental readings:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],Mode->TimeResolvedFluorescence],
			$Failed,
			Messages:>{
				Error::ModeUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the PlateReader option cannot be used because the plate reader does not support fluorescence mode experimental readings:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],Mode->TimeResolvedFluorescence],
			False
		],
		Example[{Messages,"IntegrationTimesUnneeded","DelayTime and ReadTime only apply if Mode->TimeResolvedFluorescence and should not be specified otherwise:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->Fluorescence,DelayTime->30 Microsecond],
			$Failed,
			Messages:>{
				Error::IntegrationTimesUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DelayTime and ReadTime only apply if Mode->TimeResolvedFluorescence and should not be specified otherwise:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->Fluorescence,DelayTime->30 Microsecond],
			False
		],
		Example[{Messages,"IntegrationTimesRequired","DelayTime and ReadTime cannot be set to Null if Mode->TimeResolvedFluorescence:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->TimeResolvedFluorescence,DelayTime->Null,ReadTime->Null],
			$Failed,
			Messages:>{
				Error::IntegrationTimesRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DelayTime and ReadTime cannot be set to Null if Mode->TimeResolvedFluorescence:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->TimeResolvedFluorescence,DelayTime->Null,ReadTime->Null],
			False
		],
		Example[{Messages,"IntegrationTimesRequiredTogether","DelayTime and ReadTime cannot be set to Null if Mode->TimeResolvedFluorescence:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DelayTime->30 Microsecond,ReadTime->Null],
			$Failed,
			Messages:>{
				Error::IntegrationTimesRequiredTogether,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DelayTime and ReadTime cannot be set to Null if Mode->TimeResolvedFluorescence:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DelayTime->30 Microsecond,ReadTime->Null],
			False
		],
		Example[{Messages,"IntegrationTimesUnsupported","DelayTime and ReadTime cannot be set unless the plate reader is capable of providing time-resolved fluorescence:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DelayTime->30 Microsecond,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::IntegrationTimesUnsupported,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DelayTime and ReadTime cannot be set unless the plate reader is capable of providing time-resolved fluorescence:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DelayTime->30 Microsecond,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"UnsupportedWavelengthSelection","The type of wavelength selection must be supported by the requested plate reader:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::UnsupportedWavelengthSelection,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates the type of wavelength selection must be supported by the requested plate reader:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"InvalidWavelengthSelection","Only filter-based wavelength selection can be used with time-resolved fluorescence:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators,DelayTime->30 Microsecond],
			$Failed,
			Messages:>{
				Error::InvalidWavelengthSelection,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates only filter-based wavelength selection can be used with time-resolved fluorescence:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators,DelayTime->30 Microsecond],
			False
		],
		Example[{Messages,"EmissionWavelengthUnavailable","Throws an error if the specified plate reader does not support one of the requested emission wavelengths:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->{458 Nanometer,590 Nanometer,690 Nanometer},Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::EmissionWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates returns False if the specified plate reader does not support one of the requested emission wavelengths:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->{458 Nanometer,590 Nanometer,690 Nanometer},Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"ExcitationWavelengthUnavailable","Throws an error if the specified plate reader does not support one of the requested excitation wavelengths:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength->675 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::ExcitationWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates if the specified plate reader does not support one of the requested excitation wavelengths:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength->675 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"DualEmissionUnavailable","DualEmissionWavelength and DualEmissionGain can only be set if the requested plate reader supports dual emission:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->590 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DualEmissionWavelength and DualEmissionGain can only be set if the requested plate reader supports dual emission:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->590 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Test["The DualEmissionUnavailable and DualEmissionWavelengthUnavailable messages are not both thrown:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->390 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DualEmissionWavelengthUnavailable","Throws an error if there are no emission filters which can provide the requested wavelength:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->400 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			$Failed,
			Messages:>{
				Error::DualEmissionWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if there are no emission filters which can provide the requested wavelength:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->400 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			False
		],
		Example[{Messages,"DualEmissionGainRequired","If a dual emission wavelength is set, the corresponding gain must also be provided:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->590 Nanometer,DualEmissionGain->Null],
			$Failed,
			Messages:>{
				Error::DualEmissionGainRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that if a dual emission wavelength is set, the corresponding gain must also be provided:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->590 Nanometer,DualEmissionGain->Null],
			False
		],
		Example[{Messages,"DualEmissionGainUnneeded","DualEmissionGain cannot be provided if no dual emission wavelength is provided:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionGain->70 Percent,DualEmissionWavelength->Null],
			$Failed,
			Messages:>{
				Error::DualEmissionGainUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that DualEmissionGain cannot be provided if no dual emission wavelength is provided:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionGain->70 Percent,DualEmissionWavelength->Null],
			False
		],
		Example[{Messages,"WavelengthCombinationUnavailable","An error will be thrown if the requested plate reader cannot supply the combination of wavelengths:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength->640 Nanometer,EmissionWavelength->590 Nanometer,DualEmissionWavelength->520 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			$Failed,
			Messages:>{
				Error::WavelengthCombinationUnavailable,
				Warning::WavelengthsSwapped,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the requested plate reader cannot supply the combination of wavelengths:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength->640 Nanometer,EmissionWavelength->590 Nanometer,DualEmissionWavelength->520 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			False
		],
		Example[{Messages,"WavelengthsSwapped","Indicates an error has likely been made if an emission wavelength is lower than its corresponding excitation wavelength:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				ExcitationWavelength->{355 Nanometer,650 Nanometer},
				EmissionWavelength->{460 Nanometer,590 Nanometer}
			],
			ObjectP[],
			Messages:>{Warning::WavelengthsSwapped}
		],
		Test["When running tests indicates an error has likely been made if an emission wavelength is lower than its corresponding excitation wavelength:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				ExcitationWavelength->{355 Nanometer,650 Nanometer},
				EmissionWavelength->{460 Nanometer,590 Nanometer}
			],
			True
		],
		Example[{Messages,"MaxWavelengthsExceeded","The number of requested emission wavelengths cannot exceed the max number of readings allowed by the instrument:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
				EmissionWavelength->{665 Nanometer,670 Nanometer,675 Nanometer,680 Nanometer,685 Nanometer,690 Nanometer}
			],
			$Failed,
			Messages:>{
				Error::MaxWavelengthsExceeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that the number of requested emission wavelengths cannot exceed the max number of readings allowed by the instrument:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
				EmissionWavelength->{665 Nanometer,670 Nanometer,675 Nanometer,680 Nanometer,685 Nanometer,690 Nanometer}
			],
			False
		],
		Example[{Messages,"IncompatibleGains","Provided values for the Gain and DualEmissionGain must be in the same units:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->520 Nanometer,Gain->85 Percent,DualEmissionGain->2500 Microvolt],
			$Failed,
			Messages:>{
				Error::IncompatibleGains,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that provided values for the Gain and DualEmissionGain must be in the same units:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->520 Nanometer,Gain->85 Percent,DualEmissionGain->2500 Microvolt],
			False
		],
		Example[{Messages,"FocalHeightUnavailable","Only certain plate readers support focal height adjustments:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],FocalHeight->12 Millimeter],
			$Failed,
			Messages:>{
				Error::FocalHeightUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that only certain plate readers support focal height adjustments:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],FocalHeight->12 Millimeter],
			False
		],
		Example[{Messages,"FocalHeightAdjustmentSampleRequired","The adjustment sample must be supplied as an object if FocalHeight->Auto:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->FullPlate,FocalHeight->Auto],
			$Failed,
			Messages:>{Error::FocalHeightAdjustmentSampleRequired,Error::InvalidOption}
		],
		Example[{Messages,"MultipleFocalHeightsRequested","At most one FocalHeight can be set to Auto or any specific distance:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength -> {350 Nanometer, 400 Nanometer, 450 Nanometer},FocalHeight->{Auto, Auto, 3 Millimeter}],
			$Failed,
			Messages:>{Error::MultipleFocalHeightsRequested,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied as an object if FocalHeight->Auto:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->FullPlate,FocalHeight->Auto],
			False

		],
		Example[{Messages,"InvalidAdjustmentSample","AdjustmentSample must be located within one of the assay plates:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Fluorescent Assay Sample 6"]],
			$Failed,
			Messages:>{
				Error::InvalidAdjustmentSample,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that the AdjustmentSample must be located within one of the assay plates:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Fluorescent Assay Sample 6"]],
			False
		],
		Example[{Messages,"AmbiguousAdjustmentSample","If the adjustment sample appears in the input list multiple times, the first appearance of it will be used:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]
			][AdjustmentSampleWells],
			{"A1"},
			Messages:>{
				Warning::AmbiguousAdjustmentSample
			}
		],
		Test["When running tests, generates a warning test if the adjustment sample appears in the input list multiple times, the first appearance of it will be used:",
			ValidExperimentFluorescenceKineticsQ[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]
			],
			True
		],
		Example[{Messages,"AdjustmentSampleIndex","Throws an error if the index of the adjustment sample is higher than the number of times that sample appears:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{3,Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleIndex,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the index of the adjustment sample is higher than the number of times that sample appears:",
			ValidExperimentFluorescenceKineticsQ[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{3,Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]}
			],
			False
		],
		Example[{Messages,"AdjustmentSampleUnneeded","An error will be thrown if an AdjustmentSample was provided but the Gain was supplied as a raw voltage and FocalHeight was set to a distance:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt,FocalHeight->12 Millimeter],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an AdjustmentSample was provided but the Gain was supplied as a raw voltage and FocalHeight was set to a distance:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt,FocalHeight->12 Millimeter],
			False
		],
		Example[{Messages,"AdjustmentSampleUnneeded","If the Omega is being used, the AdjustmentSample should only be set if it is being used to determine the gain:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that if the Omega is being used, the AdjustmentSample should only be set if it is being used to determine the gain:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Test["No error is thrown if the AdjustmentSample can be used to set the focal height:",
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["When running tests no error is thrown if the AdjustmentSample can be used to set the focal height:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt],
			True
		],
		Test["If one of the gains is specified as a percent, don't throw the AdjustmentSampleUnneeded error:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2500 Microvolt,DualEmissionGain->12 Percent,FocalHeight->12 Millimeter],
			$Failed,
			Messages:>{
				Error::IncompatibleGains,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AdjustmentSampleRequired","The adjustment sample must be supplied if gain is specified as a percentage:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				AdjustmentSample->Null,
				Gain->85 Percent
			],
			$Failed,
			Messages:>{Error::AdjustmentSampleRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied if gain is specified as a percentage:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				AdjustmentSample->Null,
				Gain->85 Percent
			],
			False
		],
		Example[{Messages,"GainAdjustmentSampleRequired","The adjustment sample must be supplied as an object if gain is specified as a percentage and the plate reader being used cannot adjust by examining the full plate:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				AdjustmentSample->FullPlate,
				Gain->85 Percent
			],
			$Failed,
			Messages:>{Error::GainAdjustmentSampleRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied as an object if gain is specified as a percentage and the plate reader being used cannot adjust by examining the full plate:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				AdjustmentSample->FullPlate,
				Gain->85 Percent
			],
			False
		],
		Example[{Messages,"MixingParametersRequired","Throws an error if PlateReaderMix->True and PlateReaderMixTime has been set to Null:"},
			ExperimentFluorescenceKinetics[
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if PlateReaderMix->True and PlateReaderMixTime has been set to Null:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->Null
			],
			False
		],
		Example[{Messages,"MixingParametersUnneeded","Throws an error if PlateReaderMix->False and PlateReaderMixTime has been specified:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			$Failed,
			Messages:>{
				Error::MixingParametersUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if PlateReaderMix->False and PlateReaderMixTime has been specified:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			False
		],
		Example[{Messages,"MixingParametersConflict","Throw an error if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:"},
			ExperimentFluorescenceKinetics[
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersConflict,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			False
		],
		Example[{Messages,"MoatParametersConflict","The moat options must all be set to Null or to specific values:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatVolume->Null,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::MoatParametersConflict,
				Error::InvalidOption
			}
		],
		Test["When running tests, indicates that the moat options must all be set to Null or to specific values:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatVolume->Null,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			False
		],
		Example[{Messages,"MoatAliquotsRequired","Moats are created as part of sample aliquoting. As a result if a moat is requested Aliquot must then be set to True:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Aliquot->False,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::MoatAliquotsRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests, indicates that a moat cannot be requested if Aliquot->False:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Aliquot->False,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			False
		],
		Example[{Messages,"MoatVolumeOverflow","The moat wells cannot be filled beyond the MaxVolume of the container:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatVolume->500 Microliter,
				Aliquot->True
			],
			$Failed,
			Messages:>{
				Error::MoatVolumeOverflow,
				Error::InvalidOption
			}
		],
		Test["When running tests, indicates that the moat wells cannot be filled beyond the MaxVolume of the container:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatVolume->500 Microliter
			],
			False
		],
		Example[{Messages,"TooManyMoatWells","Throws an error if more wells are required than are available in the plate. Here the moat requires 64 wells and the samples with replicates require 40 wells:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 5 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 6 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				NumberOfReplicates->5,
				Aliquot->True,
				MoatSize->2
			],
			$Failed,
			Messages:>{
				Error::TooManyMoatWells,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if more wells are required than are available in the plate. Here the moat requires 64 wells and the samples with replicates require 40 wells:",
			ValidExperimentFluorescenceKineticsQ[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 5 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 6 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				NumberOfReplicates->5,
				MoatSize->2
			],
			False
		],
		Test["Handles the case where 2*MoatSize is larger than the number of columns:",
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatSize->5,
				Aliquot->True
			],
			$Failed,
			Messages:>{
				Error::TooManyMoatWells,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WellOverlap","The wells to be used for the moat cannot also be used to hold assay samples:"},
			ExperimentFluorescenceKinetics[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				DestinationWell->{"A1","B2"},
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			$Failed,
			Messages:>{
				Error::WellOverlap,
				Error::InvalidOption
			}
		],
		Test["When running tests, indicates that the wells to be used for the moat cannot also be used to hold assay samples:",
			ValidExperimentFluorescenceKineticsQ[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				DestinationWell->{"A1","B2"},
				MoatVolume->150 Microliter
			],
			False
		],
		Example[{Messages,"MissingInjectionInformation","Throws an error if an injection volume is specified without a corresponding sample:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->{4 Microliter,Null,3 Microliter,3 Microliter}
			],
			$Failed,
			Messages:>{
				Error::MissingInjectionInformation,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an injection volume is specified without a corresponding sample:",
			ValidExperimentFluorescenceKineticsQ[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->{4 Microliter,Null,3 Microliter,3 Microliter}
			],
			False
		],
		Example[{Messages,"MissingInjectionInformation","Throws an error if an injection sample is specified without a corresponding volume:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Null,Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->{4 Microliter,Null,Null, 3 Microliter}
			],
			$Failed,
			Messages:>{
				Error::MissingInjectionInformation,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an injection sample is specified without a corresponding volume:",
			ValidExperimentFluorescenceKineticsQ[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Null,Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->{4 Microliter,Null,Null, 3 Microliter}
			],
			False
		],
		Example[{Messages,"SingleInjectionSampleRequired","Only one unique sample can be injected in an injection group:"},
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			$Failed,
			Messages:>{
				Error::SingleInjectionSampleRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that only one unique sample can be injected in an injection group:",
			ValidExperimentFluorescenceKineticsQ[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			False
		],
		Example[{Messages,"WellVolumeExceeded","Throws an error if the injections will fill the well past its max volume:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->150 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->150 Microliter,
				SecondaryInjectionTime->20 Minute
			],
			$Failed,
			Messages:>{
				Error::WellVolumeExceeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the injections will fill the well past its max volume:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->150 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->150 Microliter,
				SecondaryInjectionTime->20 Minute
			],
			False
		],
		Example[{Messages,"HighWellVolume","Throws a warning if the injection will fill the well nearly to the top:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->20 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]],
			Messages:>{
				Warning::HighWellVolume
			}
		],
		Test["When running tests returns True if the injection will fill the well nearly to the top:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->20 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			True
		],
		Example[{Messages,"TooManyInjectionSamples","No more than 2 unique injection samples can be specified since there are only two syringe pumps on current plate reader hardware:"},
			ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->1 Microliter,
				SecondaryInjectionTime->20 Minute,
				TertiaryInjectionSample->Object[Sample,"Injection test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				TertiaryInjectionVolume->1 Microliter,
				TertiaryInjectionTime->30 Minute
			],
			$Failed,
			Messages:>{
				Error::TooManyInjectionSamples,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that no more than 2 unique injection samples can be specified since there are only two syringe pumps on current plate reader hardware:",
			ValidExperimentFluorescenceKineticsQ[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->1 Microliter,
				SecondaryInjectionTime->20 Minute,
				TertiaryInjectionSample->Object[Sample,"Injection test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				TertiaryInjectionVolume->1 Microliter,
				TertiaryInjectionTime->30 Minute
			],
			False
		],
		Example[{Messages,"InjectionFlowRateUnneeded","Throws an error if PrimaryInjectionFlowRate is specified, but there are no injections:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionFlowRate->400 Microliter/Second
			],
			$Failed,
			Messages:>{
				Error::InjectionFlowRateUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if PrimaryInjectionFlowRate is specified, but there are no injections:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionFlowRate->400 Microliter/Second
			],
			False
		],

		Example[{Messages,"InjectionFlowRateRequired","Throws an error if the corresponding InjectionFlowRate is set to Null when there are injections:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->2 Microliter,
				SecondaryInjectionTime->20 Minute,
				PrimaryInjectionFlowRate->Null,
				SecondaryInjectionFlowRate->400Microliter/Second
			],
			$Failed,
			Messages:>{
				Error::InjectionFlowRateRequired,
				Error::InvalidOption
			}
		],

		Example[{Messages,"InjectionFlowRateRequired","Throws an error if we are using the ClarioStar and the InjectionFlowRate is set too low:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				AssayVolume->150 Microliter,
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->5 Microliter,
				PrimaryInjectionTime->10 Minute,
				Instrument->Model[Instrument,PlateReader,"id:E8zoYvNkmwKw"],
				PrimaryInjectionFlowRate->85 Microliter/Second
			],
			$Failed,
			Messages:>{
				Error::InvalidClarioStarFlowRate,
				Error::InvalidOption
			}
		],

		Test["When running tests returns False if the corresponding InjectionFlowRate is set to Null when there are injections:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SecondaryInjectionVolume->2 Microliter,
				SecondaryInjectionTime->20 Minute,
				PrimaryInjectionFlowRate->Null,
				SecondaryInjectionFlowRate->Null
			],
			False
		],
		Example[{Messages,"NonUniqueName","The protocol must be given a unique name:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Name->"Existing FK Protocol"<>$SessionUUID],
			$Failed,
			Messages:>{
				Error::NonUniqueName,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that the protocol must be given a unique name:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Name->"Existing FK Protocol"<>$SessionUUID],
			False
		],
		Example[{Messages,"NoPlateReader","Indicates that none of the possible plate readers can provide the requested emission wavelength while in time-resolved fluorescence mode:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->512 Nanometer,Mode->TimeResolvedFluorescence],
			$Failed,
			Messages:>{
				Error::NoPlateReader,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that none of the possible plate readers can provide the requested emission wavelength while in time-resolved fluorescence mode:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->512 Nanometer,Mode->TimeResolvedFluorescence],
			False
		],
		Example[{Messages,"NoPlateReader","There is no plate reader which can provide both dual emission and time-resolved fluorescence:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionGain->90 Percent,Mode->TimeResolvedFluorescence],
			$Failed,
			Messages:>{
				Error::NoPlateReader,
				Error::InvalidOption
			}
		],
		Test["When running tests there is no plate reader which can provide both dual emission and time-resolved fluorescence:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionGain->90 Percent,Mode->TimeResolvedFluorescence],
			False
		],
		Example[{Messages,"SinglePlateRequired","Prints a message and returns $Failed if all the samples will not be in a single plate before the read starts:"},
			ExperimentFluorescenceKinetics[{
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				Aliquot->False
			],
			$Failed,
			Messages:>{Error::SinglePlateRequired,Error::InvalidOption}
		],
		Test["When running tests returns False if all the samples will not be in a single plate before the read starts:",
			ValidExperimentFluorescenceKineticsQ[{
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				Aliquot->False
			],
			False
		],
		Example[{Messages,"SinglePlateRequired","Samples must be aliquoted into a container which is compatible with the plate reader:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]],
			$Failed,
			Messages:>{Error::InvalidAliquotContainer,Error::InvalidOption}
		],
		Test["When running tests indicates that samples must be aliquoted into a container which is compatible with the plate reader:",
			ValidExperimentFluorescenceKineticsQ[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]],
			False
		],
		Example[{Messages,"TooManyPlateReaderSamples","The total number of samples, with replicates included, cannot exceed the number of wells in the aliquot plate:"},
			ExperimentFluorescenceKinetics[{
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				NumberOfReplicates->50,
				Aliquot->True
			],
			$Failed,
			Messages:>{Error::TooManyPlateReaderSamples,Warning::TotalAliquotVolumeTooLarge,Error::InvalidInput}
		],
		Test["When running tests indicates that the total number of samples, with replicates included, cannot exceed the number of wells in the aliquot plate:",
			ValidExperimentFluorescenceKineticsQ[{
				Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				NumberOfReplicates->50,
				Aliquot->True
			],
			False
		],
		Example[{Messages,"InvalidAliquotContainer","The aliquot container must be supported by the plate reader:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Aliquot->True,
				AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages:>{Error::InvalidAliquotContainer,Error::InvalidOption}
		],
		Test["When running tests indicates that the aliquot container must be supported by the plate reader:",
			ValidExperimentFluorescenceKineticsQ[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Aliquot->True,
				AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			False
		],
		Example[{Messages,"SinglePlateRequired","Samples can only be aliquoted into a single plate:"},
			ExperimentFluorescenceKinetics[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				Aliquot->True,
				AliquotContainer->{{1,Model[Container,Plate,"96-well Black Wall Plate"]},{2,Model[Container,Plate,"96-well Black Wall Plate"]}}
			],
			$Failed,
			Messages:>{Error::SinglePlateRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that samples can only be aliquoted into a single plate:",
			ValidExperimentFluorescenceKineticsQ[{
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				Aliquot->True,
				AliquotContainer->{{1,Model[Container,Plate,"96-well Black Wall Plate"]},{2,Model[Container,Plate,"96-well Black Wall Plate"]}}
			],
			False
		],
		Example[{Messages,"BottomReadingAliquotContainer","If ReadLocation is set to Bottom, the AliquotContainer must have a Clear bottom:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				AliquotContainer->Model[Container, Plate, "96-Well All Black Plate"],
				ReadLocation->Bottom
			],
			$Failed,
			Messages:>{Error::BottomReadingAliquotContainerRequired,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleMaterials","All injection samples must be compatible with the plate reader tubing:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			$Failed,
			Messages:>{Warning::IncompatibleMaterials,Error::InvalidOption}
		],
		Test["When running tests indicates that all injection samples must be compatible with the plate reader tubing:",
			ValidExperimentFluorescenceKineticsQ[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			False
		],
		Example[{Messages,"CoveredTopRead","If the cover is being left on while data is collected bottom reads are recommended:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				RetainCover->True,
				ReadLocation->Top
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]],
			Messages:>{Warning::CoveredTopRead}
		],
		Example[{Messages,"CoveredInjections","The cover cannot be left on if any injections are being performed:"},
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter,
				PrimaryInjectionTime->5 Minute,
				RetainCover->True
			],
			$Failed,
			Messages:>{Error::CoveredInjections,Error::InvalidOption}
		],
		Example[{Messages,"SharedContainerStorageCondition","The specified storage condition cannot conflict with storage conditions of samples sharing the same container:"},
			ExperimentFluorescenceKinetics[
				Object[Container, Plate, "Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SamplesInStorageCondition -> {Freezer, Disposal, Freezer, Freezer}
			],
			$Failed,
			Messages:>{Error::SharedContainerStorageCondition,Error::InvalidOption}
		],

		(* -- OPTION RESOLUTION -- *)
		Example[{Options,Instrument,"Specify the plate reader model that should be used to measure fluorescence intensity:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]][Instrument][Name],
			"FLUOstar Omega"
		],
		Example[{Options,Instrument,"Request a particular plate reader instrument be used:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Object[Instrument,PlateReader,"Test Omega for ExperimentFluorescenceKinetics "<>$SessionUUID]][Instrument][Name],
			"Test Omega for ExperimentFluorescenceKinetics "<>$SessionUUID
		],
		Example[{Options,Instrument,"A plate reader model will be automatically selected based on any provided wavelength options:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Automatic,ExcitationWavelength->485 Nanometer][Instrument],
			ObjectP[Model[Instrument,PlateReader]]
		],
		Example[{Options,Mode,"Indicate the type of fluorescence reading to perform:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->TimeResolvedFluorescence],
				Mode
			],
			TimeResolvedFluorescence
		],
		Example[{Options,ReadOrder,"For fast kinetics indicate that all measurements for one well should be done before moving onto the next well:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					ReadOrder->Serial,
					PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute],
				ReadOrder
			],
			Serial,
			EquivalenceFunction->Equal
		],
		Example[{Options,RunTime,"Indicate that readings should be taken for 3 hours:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],RunTime-> 3 Hour],
				RunTime
			],
			3 Hour,
			EquivalenceFunction->Equal
		],
		Example[{Options,ExcitationWavelength,"Request a wavelength at which the provided samples will be excited to stimulate fluorescence emission:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength->485 Nanometer][ExcitationWavelengths],
			{485 Nanometer},
			EquivalenceFunction->Equal
		],
		Example[{Options,EmissionWavelength,"Request a wavelength at which fluorescence emitted from the provided samples will be detected:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->590 Nanometer][EmissionWavelengths],
			{590 Nanometer},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionWavelength,"Request a secondary wavelength at which fluorescence emitted from the provided samples will be detected:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->520 Nanometer][DualEmissionWavelengths],
			{520 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["The order wavelengths are specified in the optic module does not have to match the user's requested wavelengths:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->586 Nanometer][EmissionWavelengths],
			{520 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Handles the case where the optic module has only one emission wavelength:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EmissionWavelength->680 Nanometer,Instrument->Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]][DualEmissionWavelengths],
			{Null}
		],
		Test["Sets the DualEmissionGain if any dual emission wavelengths are set:",
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				EmissionWavelength->{590 Nanometer,680 Nanometer},
				ExcitationWavelength->{485 Nanometer,640 Nanometer},
				DualEmissionWavelength->{520 Nanometer,Null}
			][DualEmissionGainPercentages],
			{90.` Percent,Null}
		],
		Example[{Options,WavelengthSelection,"Indicate how the emission and excitation wavelengths should be achieved :"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators][WavelengthSelection],
			Monochromators
		],
		Example[{Options,WavelengthSelection,"Resolves to a plate reader which supports the requested WavelengthSelection:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],WavelengthSelection->Monochromators][Instrument],
			ObjectP[Model[Instrument,PlateReader,"id:E8zoYvNkmwKw"]]
		],
		Example[{Options,ReadLocation,"Indicate the direction from which fluorescence from sample wells in the provided plate should be read:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ReadLocation->Bottom][ReadLocation],
			Bottom
		],
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ReadDirection->SerpentineColumn][ReadDirection],
			SerpentineColumn
		],
		Example[{Options,DelayTime,"Indicate the length of time to wait before starting the reading after excitation when using time resolved fluorescence:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->TimeResolvedFluorescence,DelayTime->25 Microsecond][DelayTime],
			25 Microsecond,
			EquivalenceFunction->Equal
		],
		Example[{Options,ReadTime,"Indicate how long the fluorescence measurement should occur when using time resolved fluorescence:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mode->TimeResolvedFluorescence,ReadTime->100 Microsecond][ReadTime],
			100 Microsecond,
			EquivalenceFunction->Equal
		],
		Example[{Options,Temperature,"Request that the assay plate be maintained at a particular temperature in the plate reader during fluorescence intensity readings:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Temperature->37 Celsius][Temperature],
			37 Celsius,
			EquivalenceFunction->Equal
		],
		Example[{Options,EquilibrationTime,"Indicate the time for which to allow assay samples to equilibrate with the requested assay temperature. This equilibration will occur after the plate reader chamber reaches the requested Temperature, and before fluorescence intensity readings are taken:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],EquilibrationTime->4 Minute][EquilibrationTime],
			4 Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options,NumberOfReadings,"Indicate the number of raw fluorescence readings that should be taken by the plate reader for each sample, and averaged to produce a single sample fluorescence intensity measurement:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],NumberOfReadings->50][NumberOfReadings],
			50
		],
		Example[{Options,AdjustmentSample,"Provide a sample to be used as a reference by which to adjust the gain in order to avoid saturating the detector:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]][AdjustmentSamples][Name],
			{"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID}
		],
		Example[{Options,AdjustmentSample,"If a sample appears multiple times, indicate which aliquot of it should be used to adjust the gain. Here we indicate that the 20\[Micro]L aliquot of \"Test sample 1\" should be used:"},
			ExperimentFluorescenceKinetics[
				{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{2,Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]}
			][AdjustmentSamples][Name],
			{"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID}
		],
		Example[{Options,Gain,"Provide a raw voltage that will be used by the plate reader to amplify the raw signal from the primary emission detector:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->2000 Microvolt][Gains],
			{2000 Microvolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,Gain,"Provide the gain as a percentage to indicate that gain adjustments should be normalized to the provided adjustment sample at run time:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Gain->90 Percent][GainPercentages],
			{90 Percent},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionGain,"Provide a raw voltage that will be used by the plate reader to amplify the raw signal from the secondary emission detector:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->520 Nanometer,Gain->2000 Microvolt,DualEmissionGain->2000 Microvolt][DualEmissionGains],
			{2000 Microvolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionGain,"Provide the gain as a percentage to indicate that gain adjustments should be normalized to the provided adjustment sample at run time:"},
			ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionWavelength->520 Nanometer,AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],DualEmissionGain->90 Percent][DualEmissionGainPercentages],
			{90 Percent},
			EquivalenceFunction->Equal
		],
		Example[{Options,FocalHeight,"Set an explicit focal height at which to set the focusing element of the plate reader during fluorescence intensity readings:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"PHERAstar FS"],FocalHeight->8 Millimeter][FocalHeights],
			{8 Millimeter},
			EquivalenceFunction->Equal
		],
		Example[{Options,FocalHeight,"Indicate that focal height adjustment should occur on-the-fly by determining the height which gives the highest fluorescence reading for the specified sample:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"PHERAstar FS"],FocalHeight->Auto,AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]][AutoFocalHeights],
			{True}
		],
		Example[{Options,FocalHeight,"One can determine which excitation/emission wavelength pair the focal height should be adjusted, by setting the FocalHeight option for that pair to Auto:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength -> {350 Nanometer, 400 Nanometer, 450 Nanometer}, FocalHeight-> {Automatic, Auto, Automatic},AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]][AutoFocalHeights],
			{Null, True, Null}
		],
		Example[{Options,FocalHeight,"If FocalHeight option is set to a specific distance for one excitation/emission wavelength pair, this distance will also be set to other pairs:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ExcitationWavelength -> {350 Nanometer, 400 Nanometer, 450 Nanometer}, FocalHeight-> {Automatic, 3 Millimeter, Automatic},AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]][FocalHeights],
			{EqualP[3 Millimeter], EqualP[3 Millimeter], EqualP[3 Millimeter]}
		],
		Example[{Options,PrimaryInjectionSample,"Specify the sample you'd like to inject into every input sample:"},
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["PrimaryInjectionSample can be a model:",
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,PrimaryInjectionVolume,"Specify the volume you'd like to inject into every input sample:"},
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,PrimaryInjectionVolume,"If you'd like to skip the injection for a subset of you samples, use Null as a placeholder in the injection samples list and injection volumes list. Here Test sample 2 and Test sample 3 will not receive injections:"},
			Download[
				ExperimentFluorescenceKinetics[
					{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionVolume->{4 Microliter,Null,Null,4 Microliter},
					PrimaryInjectionTime->10 Minute
				],
				PrimaryInjections
			],
			{
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter},
				{10.` Minute,Null,0.` Microliter},
				{10.` Minute,Null,0.` Microliter},
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionTime,"Indicate that injections should begin 10 minutes into the read:"},
			Download[
				ExperimentFluorescenceKinetics[
					{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute
				],
				PrimaryInjections
			],
			{
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter},
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter},
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter},
				{10.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],4.` Microliter}
			}
		],
		Example[{Options,SecondaryInjectionSample,"Specify the sample to inject in the second round of injections:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionVolume->{2 Microliter},
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				SecondaryInjectionVolume->{2 Microliter},
				SecondaryInjectionTime->20 Minute
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Options,SecondaryInjectionVolume,"Specify that 2\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the second injection round:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionVolume->{2 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter},
					SecondaryInjectionTime->20 Minute
				],
				SecondaryInjections
			],
			{{20.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],2.` Microliter}}
		],
		Example[{Options,SecondaryInjectionTime,"Indicate that the secondary injections should occur at the same time as the primary injections:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionVolume->{2 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter},
					SecondaryInjectionTime->10 Minute
				],
				SecondaryInjections
			],
			{{10.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],2.` Microliter}}
		],
		Example[{Options,TertiaryInjectionSample,"The third group of injections must use the same sample as the primary or secondary injections since only two unique injection sources are available:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->1 Microliter,
					TertiaryInjectionTime->30 Minute
				],
				TertiaryInjections
			],
			{
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter}
			}
		],
		Example[{Options,TertiaryInjectionVolume,"For the third group of injections, specify a different volume to inject into each well:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->{1 Microliter,2 Microliter},
					TertiaryInjectionTime->30 Minute
				],
				TertiaryInjections
			],
			{
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],2.` Microliter}
			}
		],
		Example[{Options,TertiaryInjectionTime,"Indicate that injections should occur every 10 minutes:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->{1 Microliter,1 Microliter},
					TertiaryInjectionTime->30 Minute
				],
				TertiaryInjections
			],
			{
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
				{30.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter}
			}
		],
		Example[{Options,QuaternaryInjectionSample,"Alternate injections of two different samples:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->1 Microliter,
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					QuaternaryInjectionVolume->1 Microliter,
					QuaternaryInjectionTime->40 Minute

				],
				QuaternaryInjections
			],
			{{40.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},{40.` Minute,LinkP[Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter}}
		],
		Example[{Options,QuaternaryInjectionVolume,"Sequentially inject the same sample:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->1 Microliter,
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					QuaternaryInjectionVolume->1 Microliter,
					QuaternaryInjectionTime->40 Minute
				],
				QuaternaryInjections
			],
			{
				{40.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
				{40.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter}
			}
		],
		Example[{Options,QuaternaryInjectionTime,"Indicate that the final set of injections should occur 40 minutes after readings have started:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->{1 Microliter,1 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->{1 Microliter,1 Microliter},
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->{1 Microliter,1 Microliter},
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					QuaternaryInjectionVolume->{1 Microliter,1 Microliter},
					QuaternaryInjectionTime->40 Minute
				],
				QuaternaryInjections
			],
			{
				{40.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
				{40.` Minute,LinkP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Specify the flow rate at which the primary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentFluorescenceKinetics[
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionVolume->{1 Microliter},
					PrimaryInjectionTime->10 Minute,
					PrimaryInjectionFlowRate->(100 Microliter/Second)
				],
				PrimaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,SecondaryInjectionFlowRate,"Specify the flow rate at which the secondary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionVolume->{2 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter},
					SecondaryInjectionTime->20 Minute,
					SecondaryInjectionFlowRate->(100 Microliter/Second)
				],
				SecondaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,TertiaryInjectionFlowRate,"Specify the flow rate at which the tertiary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->{1 Microliter,1 Microliter},
					TertiaryInjectionTime->30 Minute,
					TertiaryInjectionFlowRate->(100 Microliter/Second)
				],
				TertiaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,QuaternaryInjectionFlowRate,"Specify the flow rate at which the quaternary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->{1 Microliter,1 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->{1 Microliter,1 Microliter},
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					TertiaryInjectionVolume->{1 Microliter,1 Microliter},
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					QuaternaryInjectionVolume->{1 Microliter,1 Microliter},
					QuaternaryInjectionTime->40 Minute,
					QuaternaryInjectionFlowRate->(100 Microliter/Second)
				],
				QuaternaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionSampleStorageCondition,"Indicate that the injection samples should be stored at room temperature after the experiment completes:"},
			Download[
				ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->{1 Microliter,1 Microliter},
					PrimaryInjectionTime->10 Minute,
					InjectionSampleStorageCondition->AmbientStorage
				],
				InjectionStorageCondition
			],
			AmbientStorage
		],
		Example[{Options,PlateReaderMix,"Set PlateReaderMix to True to shake the input plate in the reader before the assay begins:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMix->True],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM,30.` Second}
		],
		Example[{Options,PlateReaderMixSchedule,"Indicate that the plate should be mixed after every read cycle:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixSchedule->BetweenReadings],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixSchedule}
			],
			{True,700.` RPM,30.` Second,BetweenReadings}
		],
		Example[{Options,PlateReaderMixTime,"Specify PlateReaderMixTime to automatically turn mixing on and resolve PlateReaderMixRate:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixTime->1 Hour],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM,1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,PlateReaderMixRate,"If PlateReaderMixRate is specified, it will automatically turn mixing on and resolve PlateReaderMixTime:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixRate->100 RPM],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,100.` RPM,30.` Second}
		],
		Example[{Options,PlateReaderMixMode,"Specify how the plate should be moved to perform the mixing:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixMode->Orbital],
				PlateReaderMixMode
			],
			Orbital
		],
		Example[{Options,SamplesInStorageCondition,"Specify the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],SamplesInStorageCondition->Freezer],
				SamplesInStorage
			],
			{Freezer, Freezer, Freezer, Freezer}
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixTime->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixTime->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixRate->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],PlateReaderMixRate->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Options,MoatSize,"Indicate the first two columns and rows and the last two columns and rows of the plate should be filled with water to decrease evaporation of the inner assay samples:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatSize->2,
				Aliquot->True
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,MoatVolume,"Indicate the volume which should be used to fill each moat well:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,MoatBuffer,"Indicate that each moat well should be filled with water:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"],
				Aliquot->True
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,ImageSample,"Indicate if assay samples should have their images re-taken after the fluorescence intensity experiment:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ImageSample->True][ImageSample],
			True
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],MeasureVolume->False],
				MeasureVolume
			],
			False
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],MeasureWeight->False],
				MeasureWeight
			],
			False
		],
		Example[{Options,Template,"Inherit unresolved options from a previously run Object[Protocol,FluorescenceKinetics]:"},
			Module[{pastProtocol},
				pastProtocol=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]];
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Template->pastProtocol]
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Populate the ParentProtocol field based on the option value:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ParentProtocol->Object[Qualification,PipettingLinearity,"Fluorescence Method Pipetting Control 2"]][ParentProtocol],
			LinkP[Object[Qualification,PipettingLinearity,"Fluorescence Method Pipetting Control 2"]]
		],
		Example[{Options,Confirm,"Directly confirms a protocol into the operations queue:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Confirm->True][Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options,Name,"Name the protocol:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Name->"World's Best FK Protocol"<>$SessionUUID],
			Object[Protocol,FluorescenceKinetics,"World's Best FK Protocol"<>$SessionUUID]
		],
		Example[{Options,NumberOfReplicates,"When 3 replicates are requested, 3 aliquots will be generated from each sample and assayed to generate 3 fluorescence trajectories:"},
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				NumberOfReplicates->3,
				Aliquot->True
			][SamplesIn],
			Join[
				ConstantArray[ObjectP[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],3],
				ConstantArray[ObjectP[Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],3]
			]
		],
		Example[{Options,RetainCover,"Indicate that the assay plate seal should be left on during the experiment:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				RetainCover->True
			][RetainCover],
			True
		],
		Test["Automatically sets Aliquot to True if replicates are requested:",
			Lookup[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],NumberOfReplicates->3,Output->Options],
				Aliquot
			],
			True,
			Messages:>{Warning::ReplicateAliquotsRequired}
		],
		Test["Does not change the user values when all wavelength and plate reader info is specified:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
					ExcitationWavelength->485 Nanometer,
					EmissionWavelength->620 Nanometer

				],
				{ExcitationWavelengths,EmissionWavelengths}
			],
			{{485 Nanometer},{620 Nanometer}},
			EquivalenceFunction->Equal
		],
		Test["Allows use of a CLARIOstar for TimeResolved readings:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
					Mode->TimeResolvedFluorescence,
					EmissionWavelength->665 Nanometer,
					ExcitationWavelength->340 Nanometer
				],
				{ExcitationWavelengths,EmissionWavelengths}
			],
			{{337 Nanometer},{665 Nanometer}},
			EquivalenceFunction->Equal
		],
		Test["Resolves the emission wavelength for the CLARIOstar:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
					Mode->TimeResolvedFluorescence,
					ExcitationWavelength->340 Nanometer
				],
				{ExcitationWavelengths,EmissionWavelengths}
			],
			{{337 Nanometer},{620 Nanometer}},
			EquivalenceFunction->Equal
		],
		Test["Resolves the excitation wavelength for the CLARIOstar:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
					EmissionWavelength->620 Nanometer,
					Mode->TimeResolvedFluorescence
				],
				{ExcitationWavelengths,EmissionWavelengths}
			],
			{{337 Nanometer},{620 Nanometer}},
			EquivalenceFunction->Equal
		],
		Test["Recognizes the Omega doesn't support dual emission:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				DualEmissionWavelength->535 Nanometer
			],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Test["Resolves the automatic emission wavelength:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Mode->TimeResolvedFluorescence,
					EmissionWavelength->{Automatic,665 Nanometer}
				],
				EmissionWavelengths
			],
			{620 Nanometer,665 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Resolves all automatic emission wavelengths:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Mode->TimeResolvedFluorescence,
					EmissionWavelength->{Automatic,Automatic}
				],
				EmissionWavelengths
			],
			{620 Nanometer,620 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Validates the specified emission wavelengths:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Mode->TimeResolvedFluorescence,
					EmissionWavelength->{665 Nanometer,620 Nanometer}
				],
				EmissionWavelengths
			],
			{665 Nanometer,620 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Handles duplicate inputs:",
			ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},Aliquot->True],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Creates resources for the input samples, the plate reader and the operator:",
			Module[{protocol,resourceEntries,resourceObjects,samples,operators,instruments},
				protocol=ExperimentFluorescenceKinetics[{
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]
				},Aliquot->True];

				resourceEntries=Download[protocol,RequiredResources];
				resourceObjects=Download[resourceEntries[[All,1]],Object];
				operators=Cases[resourceObjects,ObjectP[Object[Resource,Operator]]];
				instruments=Cases[resourceObjects,ObjectP[Object[Resource,Instrument]]];
				samples=Download[Cases[resourceEntries,{_,SamplesIn,___}][[All,1]],Object];

				{
					(* Creates 2 unique resources *)
					MatchQ[samples,{x_,y_,x_}],
					(* Creates 5 unique operator resources *)
					Length[operators]==5&&DuplicateFreeQ[operators],
					(* Creates 1 plate reader resource *)
					MatchQ[instruments,{ObjectP[Object[Resource,Instrument]]}]
				}
			],
			{True,True,True}
		],
		Test["Populates the cleaning fields when one unique sample is being injected:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute
				],
				{
					PrimaryPreppingSolvent,
					PrimaryFlushingSolvent,
					SecondaryPreppingSolvent,
					SecondaryFlushingSolvent,
					SolventWasteContainer,
					SecondarySolventWasteContainer
				}
			],
			{
				ObjectP@Model[Sample,StockSolution,"70% Ethanol"],
				ObjectP@Model[Sample,StockSolution,"70% Ethanol"],
				ObjectP@Model[Sample,"Milli-Q water"],
				ObjectP@Model[Sample,"Milli-Q water"],
				Null,
				Null
			}
		],
		Test["Populates the cleaning fields when two samples are being injected:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					SecondaryInjectionVolume->1 Microliter,
					SecondaryInjectionTime->20 Minute
				],
				{
					PrimaryPreppingSolvent,
					PrimaryFlushingSolvent,
					SecondaryPreppingSolvent,
					SecondaryFlushingSolvent,
					SolventWasteContainer,
					SecondarySolventWasteContainer
				}
			],
			{
				ObjectP@Model[Sample,StockSolution,"70% Ethanol"],
				ObjectP@Model[Sample,StockSolution,"70% Ethanol"],
				ObjectP@Model[Sample,"Milli-Q water"],
				ObjectP@Model[Sample,"Milli-Q water"],
				Null,
				Null
			}
		],
		Test["Doesn't populate the cleaning fields if there are no injections:",
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
				{
					PrimaryPreppingSolvent,
					PrimaryFlushingSolvent,
					SecondaryPreppingSolvent,
					SecondaryFlushingSolvent,
					SolventWasteContainer,
					SecondarySolventWasteContainer
				}
			],
			{
				Null,
				Null,
				Null,
				Null,
				Null,
				Null
			}
		],
		Test["Shares resources for the cleaning samples used during prepping and flushing when only one line is being cleaned:",
			Module[{protocol,resourceEntries,solventEntries,solventResources,uniqueSolventResources},
				protocol=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute
				];

				resourceEntries=Download[protocol,RequiredResources];
				solventEntries=Cases[resourceEntries,{_,PrimaryPreppingSolvent|PrimaryFlushingSolvent|SecondaryPreppingSolvent|SecondaryFlushingSolvent,___}];
				solventResources=DeleteDuplicates[Download[solventEntries[[All,1]],Object]];
				uniqueSolventResources=Length[solventResources]
			],
			2
		],
		Test["Creates resources for the input samples - combining volumes as needed:",
			Module[{protocol,resourceEntries,samplesInResources},
				protocol=ExperimentFluorescenceKinetics[
					{
						Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]
					},
					AliquotAmount->{50 Microliter,50 Microliter,50 Microliter,50 Microliter},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					PrimaryInjectionTime->10 Minute
				];

				resourceEntries=Download[protocol,RequiredResources];
				samplesInResources=Download[Cases[resourceEntries,{_,SamplesIn,___}][[All,1]],Object];

				{
					MatchQ[samplesInResources[[1]],samplesInResources[[4]]],
					!MatchQ[samplesInResources[[1]],samplesInResources[[2]]],
					Download[samplesInResources[[1]], Amount]==100 Microliter
				}
			],
			{True..}
		],
		Test["Expands SamplesIn and the fields index-matched to SamplesIn when replicates are requested:",
			Module[{protocol},
				protocol=ExperimentFluorescenceKinetics[
					{
						Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID]
					},
					EmissionWavelength->{670 Nanometer,620 Nanometer},
					AliquotAmount->{50 Microliter,50 Microliter,50 Microliter},
					NumberOfReplicates->2,
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->{1 Microliter,2 Microliter,3 Microliter},
					PrimaryInjectionTime->10 Minute
				];
				Download[protocol,{SamplesIn,PrimaryInjections,EmissionWavelengths}]
			],
			{
				{
					ObjectP[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID]]
				},
				{
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],1.` Microliter},
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],2.` Microliter},
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],2.` Microliter},
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],3.` Microliter},
					{10.` Minute,ObjectP[Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]],3.` Microliter}
				},
			(* EmissionWavelengths is not index-matched to input, so it shouldn't get expanded *)
				{670.` Nanometer,620.` Nanometer}
			}
		],


		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				FluorescenceKinetics[
					Sample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate an FluorescenceKinetics protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				FluorescenceKinetics[
					Sample -> Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				FluorescenceKinetics[
					Sample->Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				FluorescenceKinetics[
					Sample-> {
						Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		
		
	(* ExperimentIncubate tests. *)
		Example[{Options,Incubate,"Indicate if the SamplesIn should be incubated at a fixed temperature before starting the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Provide the temperature at which the SamplesIn should be incubated:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Indicate SamplesIn should be heated for 40 minutes before starting the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Indicate the SamplesIn should be mixed and heated for up to 2 hours or until any solids are fully dissolved:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],MixUntilDissolved->True,MaxIncubationTime->2*Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			2 Hour,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Indicate the instrument which should be used to heat SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubationInstrument->Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Set the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when transferring the input sample to a new container before incubation:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubateAliquot->100*Microliter,Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"Indicate that the input samples should be transferred into 2mL tubes before they are incubated:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are incubated:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],IncubateAliquotDestinationWell->"A1",Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicate if the SamplesIn should be mixed during the incubation performed before beginning the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicate the style of motion used to mix the sample:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicate if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix type), in an attempt dissolve any solute:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

	(* ExperimentCentrifuge *)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged before starting the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeInstrument,"Set the centrifuge that should be used to spin the input samples:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeIntensity,"Indicate the rotational speed which should be applied to the input samples during centrifugation:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeTime,"Specify the SamplesIn should be centrifuged for 2 minutes:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeTime->2*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeTemperature,"Indicate the temperature at which the centrifuge chamber should be held while the samples are being centrifuged:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeTemperature->10*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquot,"Indicate the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeAliquot->100*Microliter,Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotContainer,"Indicate that the input samples should be transferred into 2mL tubes before they are centrifuged:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{2,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{3,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{4,ObjectP[Model[Container,Vessel,"2mL Tube"]]}},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are centrifuged:"},
			options=ExperimentFluorescenceKinetics[Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],CentrifugeAliquotDestinationWell->{"A1","A1","A1","A1"},Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			{"A1","A1","A1","A1"},
			Variables:>{options},
			TimeConstraint->240
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicate if the SamplesIn should be filtered prior to starting the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],Filtration->True,Aliquot->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"Specify the method by which the input samples should be filtered:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->Syringe,Aliquot->True,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"Indicate the instrument that should be used to perform the filtration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],Aliquot->True,Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"Indicate that at a 0.22um PTFE filter should be used to remove impurities from the SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],Filter->Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"],Aliquot->True,Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterMaterial->PES,Aliquot->True,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[{Options,PrefilterMaterial,"Indicate the membrane material of the prefilter that should be used to remove impurities from the SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],PrefilterMaterial->GxF,Aliquot->True,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"Set the pore size of the filter that should be used when removing impurities from the SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Aliquot->True,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		Example[{Options,PrefilterPoreSize,"Specify the pore size of the prefilter that should be used when removing impurities from the SamplesIn:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],PrefilterPoreSize->1.`*Micrometer,Aliquot->True,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.`*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"Indicate the type of syringe which should be used to force that sample through a filter:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Aliquot->True,Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"Indicate the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->PeristalticPump,FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],Aliquot->True,Output->Options];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"Provide the rotational speed or force at which the samples should be centrifuged during filtration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Aliquot->True,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"Specify the amount of time for which the samples should be centrifuged during filtration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Aliquot->True,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"Set the temperature at which the centrifuge chamber should be held while the samples are being centrifuged during filtration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->30*Celsius,Aliquot->True,Output->Options];
			Lookup[options,FilterTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicate if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterSterile->True,Aliquot->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterAliquot->200*Milliliter,Aliquot->True,Output->Options];
			Lookup[options,FilterAliquot],
			200*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"Indicate that the input samples should be transferred into a 50mL tube before they are filtered:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are filtered:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterAliquotDestinationWell->"A1",Aliquot->True,Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"Indicate the container into which samples should be filtered:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"250mL Glass Bottle"],Aliquot->True,Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"250mL Glass Bottle"]]},
			Variables:>{options}
		],
	(* aliquot options *)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"Indicate that a 100uL aliquot should be taken from the input sample and used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AliquotAmount->100 Microliter,Output->Options];
			Lookup[options,AliquotAmount],
			100 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"Specify the total volume of the aliquot. Here a 100uL aliquot containing 50uL of the input sample and 50uL of buffer will be generated:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->50 Microliter,Output->Options];
			Lookup[options,AssayVolume],
			100 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"Indicate that an aliquot should be prepared by diluting the input sample such that the final concentration of analyte in the aliquot is 5uM:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Fake 40mer DNA oligomer for ExperimentFluorescenceKinetics tests"<>$SessionUUID],AssayVolume->100 Microliter,TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"The specific analyte to get to the specified target concentration:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Fake 40mer DNA oligomer for ExperimentFluorescenceKinetics tests"<>$SessionUUID],AssayVolume->100 Microliter,TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentFluorescenceKinetics tests"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to the aliquot sample, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"Indicate the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"Set the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"Indicate the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->10 Microliter,AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"Set the non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AssayVolume->100 Microliter,AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicate that two 50uL aliquot of Object[Sample,\"Test sample 7 for ExperimentFluorescenceKinetics\"] should be created. We cannot consolidate aliquots since we read each well only once - a repeated sample indicates multiple aliquots should be made to allow for multiple readings:"},
			options=ExperimentFluorescenceKinetics[{Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID]},AliquotAmount->50 Microliter,ConsolidateAliquots->False,Output->Options];
			Lookup[options,ConsolidateAliquots],
			False,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicate that the aliquots should be generated by using an automated liquid handling robot:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],Aliquot->True,AliquotPreparation->Robotic,Output->Options];
			Lookup[options,AliquotPreparation],
			Robotic,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"Indicate that the aliquot should be prepared in a UV-Star Plate:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],Output->Options];
			Lookup[options,AliquotContainer],
			{1,ObjectP[Model[Container,Plate,"96-well UV-Star Plate"]]},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicate that the sample should be aliquoted into well D6:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],AliquotAmount->100 Microliter,DestinationWell->"D6",Output->Options];
			Lookup[options,DestinationWell],
			"D6",
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Indicate if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
			options=ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicate the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed:"},
			options=ExperimentFluorescenceKinetics[Object[Container, Plate, "Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],SamplesInStorageCondition->Disposal,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options, PreparatoryPrimitives, "Use PreparatoryPrimitives option to prepare a plate with control samples:"},
			ExperimentFluorescenceKinetics["test plate",
				PreparatoryPrimitives -> {
					Define[Name -> "test plate", Container -> Model[Container, Plate, "id:kEJ9mqR3XELE"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Amount -> 100*Microliter, Destination -> {"test plate","A1"}],
					Transfer[Source -> Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID], Amount -> 100*Microliter, Destination -> {"test plate","A2"}]
				}
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to prepare a plate with control samples:"},
			ExperimentFluorescenceKinetics["test plate",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "test plate", Container -> Model[Container, Plate, "id:kEJ9mqR3XELE"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Amount -> 100*Microliter, Destination -> {"A1", "test plate"}],
					Transfer[Source -> Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID], Amount -> 100*Microliter, Destination -> {"A2", "test plate"}]
				}
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Example[{Options,SamplingPattern,"Indicate that a grid of readings should be taken for each well and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],SamplingPattern->Matrix],
				SamplingPattern
			],
			Matrix
		],
		Example[{Options,SamplingDimension,"Indicate that 16 readings (4x4) should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],SamplingDimension->4],
				SamplingDimension
			],
			4
		],
		Example[{Options,SamplingDistance,"Indicate the length of the region over which sampling measurements should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],SamplingPattern->Ring,SamplingDistance->5 Millimeter],
				SamplingDistance
			],
			5.` Millimeter
		],
		Example[{Messages,"SamplingCombinationUnavailable","SamplingDimension is only supported when SamplingPattern->Matrix:"},
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				SamplingPattern->Ring,
				SamplingDimension->4
			],
			$Failed,
			Messages:>{Error::SamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedInstrumentSamplingPattern","The Omega can't sample wells using a Matrix pattern:"},
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedInstrumentSamplingPattern,Error::InvalidOption}
		],
		Test["Resolves the destination wells based on the read order and the moat size:",
			options=ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				ReadDirection->Column,
				MoatSize->1,
				Aliquot->True,
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"B2","C2","D2"},
			Variables:>{options}
		],
		Test["Doesn't complain if well volume is already high, but we aren't injecting:",
			ExperimentFluorescenceKinetics[Object[Sample,"High volume sample for ExperimentFluorescenceKinetics testing"<>$SessionUUID]],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Creates a unique resource for each injection sample:",
			Module[{resourceEntries,primaryInjectionResourceEntries,secondaryInjectionResourceEntries,tertiaryInjectionResourceEntries,
				primaryInjectionResources,secondaryInjectionResources,tertiaryInjectionResources,primaryAmount,primaryModels,
				tertiaryAmount,tertiaryModels},

				resourceEntries=Download[
					ExperimentFluorescenceKinetics[
						{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
						PrimaryInjectionSample->{Model[Sample,"Milli-Q water"],Null,Null,Model[Sample,"Milli-Q water"]},
						PrimaryInjectionVolume->{1 Microliter,Null,Null,1 Microliter},
						PrimaryInjectionTime->2 Minute,
						SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
						SecondaryInjectionVolume->2 Microliter,
						SecondaryInjectionTime->5 Minute,
						TertiaryInjectionSample->Model[Sample, StockSolution, "id:8qZ1VWNmdLpR"],
						TertiaryInjectionVolume->1 Microliter,
						TertiaryInjectionTime->10 Minute
					],
					RequiredResources
				];

				primaryInjectionResourceEntries=Cases[resourceEntries, {_, PrimaryInjections, __}];
				secondaryInjectionResourceEntries=Cases[resourceEntries, {_, SecondaryInjections, __}];
				tertiaryInjectionResourceEntries=Cases[resourceEntries, {_, TertiaryInjections, __}];

				primaryInjectionResources=Download[primaryInjectionResourceEntries[[All,1]],Object];
				secondaryInjectionResources=Download[secondaryInjectionResourceEntries[[All,1]],Object];
				tertiaryInjectionResources=Download[tertiaryInjectionResourceEntries[[All,1]],Object];

				{primaryModels,primaryAmount}=Download[First[primaryInjectionResources],{Models[Object],Amount}];

				{tertiaryModels,tertiaryAmount}=Download[First[tertiaryInjectionResources],{Models[Object],Amount}];

				{
					MatchQ[primaryInjectionResourceEntries,{OrderlessPatternSequence[{_,_,1,2},{_,_,4,2}]}],
					MatchQ[secondaryInjectionResourceEntries,{OrderlessPatternSequence[{_,_,1,2},{_,_,2,2},{_,_,3,2},{_,_,4,2}]}],
					MatchQ[tertiaryInjectionResourceEntries,{OrderlessPatternSequence[{_,_,1,2},{_,_,2,2},{_,_,3,2},{_,_,4,2}]}],
					SameQ@@primaryInjectionResources,
					SameQ@@secondaryInjectionResources,
					SameQ@@tertiaryInjectionResources,
					SameQ@@Join[primaryInjectionResources,secondaryInjectionResources],
					!SameQ@@Join[primaryInjectionResources,tertiaryInjectionResources],
					Equal[primaryAmount,1010 Microliter],
					Equal[tertiaryAmount,1004 Microliter],
					MatchQ[primaryModels,{Model[Sample, "id:8qZ1VWNmdLBD"]}],
					MatchQ[tertiaryModels,{Model[Sample, StockSolution, "id:8qZ1VWNmdLpR"]}]
				}
			],
			{True..}
		],
		Test["Doesn't return $Failed if there's only one injection:",
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->20 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Doesn't return $Failed if the injection times are the same:",
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				PrimaryInjectionTime->20 Minute,
				SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
				SecondaryInjectionVolume->1 Microliter,
				SecondaryInjectionTime->20 Minute
			],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Instrument resources are generated correctly when a specific resource is supplied:",
			Module[{resources,instrumentResources},
				resources=Download[
					ExperimentFluorescenceKinetics[
						Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
						PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
						PrimaryInjectionTime->30 Minute,
						PrimaryInjectionVolume->{1 Microliter},
						Instrument->Object[Instrument,PlateReader,"Test Omega for ExperimentFluorescenceKinetics "<>$SessionUUID]
					],
					RequiredResources
				];

				instrumentResources=Cases[resources,{ObjectP[Object[Resource,Instrument]],___}][[All,1]];
				SameQ@@instrumentResources
			],
			True
		],
		Test["Throws a single error if an unsupported plate reader is supplied:",
			ExperimentFluorescenceKinetics[
				Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages:>{
				Error::ModeUnavailable,
				Error::InvalidOption
			}
		],
		Test["Handles a sample without a model:",
			ExperimentFluorescenceKinetics[Object[Sample,"Test sample 9 for ExperimentFluorescenceKinetics"<>$SessionUUID]],
			ObjectP[Object[Protocol,FluorescenceKinetics]]
		],
		Test["Produces a valid simulation",
			ExperimentFluorescenceKinetics[
				{Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				Output->Simulation
			],
			SimulationP
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,plate3,plate4,plate5,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		incompatibleChemicalModel,numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples,idModel1,targetConcentrationSample},
		ClearMemoization[];
		fkBackUpCleanup[];

		$CreatedObjects={};

		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
		vesselPacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>;
		bottlePacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"250mL Glass Bottle"],Objects],Site->Link[$Site],DeveloperObject->True|>;

		incompatibleChemicalPacket=<|Type->Model[Sample],DeveloperObject->True,Replace[IncompatibleMaterials]->{PTFE},DeveloperObject->True,DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]]|>;

		Upload[<| Type -> Model[Sample], Name -> "Test Oligomer for ExperimentFluorescenceKinetics"<>$SessionUUID<>$SessionUUID, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]], DeveloperObject -> True |>];

		{plate1,plate2,plate3,plate4,plate5,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,incompatibleChemicalModel}=Upload[
			Join[
				Append[platePacket,Name->"Test plate "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID]&/@Range[5],
				{Append[platePacket,Name->"Empty plate for ExperimentFluorescenceKinetics"<>$SessionUUID]},
				Append[vesselPacket,Name->"Test vessel "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID]&/@Range[5],
				{bottlePacket,incompatibleChemicalPacket}
			]
		];

		numberOfInputSamples=9;
		sampleNames="Test sample "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID&/@Range[numberOfInputSamples];

		numberOfInjectionSamples=4;
		injectionSampleNames="Injection test sample "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID&/@Range[numberOfInjectionSamples];

		samples=UploadSample[
			Join[
				ConstantArray[Model[Sample,StockSolution,"0.2M FITC"],numberOfInputSamples-3],
				ConstantArray[Model[Sample, "Test Oligomer for ExperimentFluorescenceKinetics"<>$SessionUUID<>$SessionUUID],3],
				ConstantArray[Model[Sample,StockSolution,"0.2M FITC"],numberOfInjectionSamples-1],
				{incompatibleChemicalModel},
				{Model[Sample,"Milli-Q water"]}
			],
			{
				{"A1",plate1},{"A2",plate1},{"A3",plate1},{"A4",plate1},{"A1",plate2},{"A2",plate2},{"A1",bottle1},{"A1",vessel5},{"A1",plate3},
				{"A1",vessel1},{"A1",vessel2},{"A1",vessel3},{"A1",vessel4},{"A1",plate5}
			},
			Name->Join[sampleNames,injectionSampleNames,{"High volume sample for ExperimentFluorescenceKinetics testing"<>$SessionUUID}],
			InitialAmount->Join[
				ConstantArray[250 Microliter,numberOfInputSamples-3],
				{200 Milliliter, 2 Milliliter,250 Microliter},
				ConstantArray[15 Milliliter,numberOfInjectionSamples],
				{300 Microliter}
			],
			State->Liquid
		];

		(* Upload fake oligomer ID Model and Object[Sample] for the TargetConcentration test *)
		idModel1=Upload[
			<|
				Type->Model[Molecule,Oligomer],
				Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
				PolymerType-> DNA,
				Name-> "Fake 40mer DNA Model Molecule for ExperimentFluorescenceKinetics tests"<>$SessionUUID,
				MolecularWeight->12295.9*(Gram/Mole),
				DeveloperObject->True
			|>
		];

		{targetConcentrationSample}=UploadSample[
			{
				{
					{20*Micromolar,Link[Model[Molecule, Oligomer, "Fake 40mer DNA Model Molecule for ExperimentFluorescenceKinetics tests"<>$SessionUUID]]},
					{100*VolumePercent,Link[Model[Molecule, "Water"]]}
				}
			},
			{
				{"A1",plate4}
			},
			StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
			State->Liquid,
			Status->Available,
			InitialAmount->{
				1*Milliliter
			},
			Name->{
				"Fake 40mer DNA oligomer for ExperimentFluorescenceKinetics tests"<>$SessionUUID
			}
		];

		Upload[
			Join[
				<|Object->#,DeveloperObject->True|>&/@Join[samples,{idModel1,targetConcentrationSample}],
				{
					<|Object->Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],Concentration->10 Millimolar|>,
					<|Object->Object[Sample,"Test sample 9 for ExperimentFluorescenceKinetics"<>$SessionUUID],Model->Null|>,
					<|Type->Object[Protocol, FluorescenceKinetics],Name->"Existing FK Protocol"<>$SessionUUID|>,
					<|
						Type -> Object[Instrument, PlateReader],
						Model -> Link[Model[Instrument,PlateReader,"FLUOstar Omega"], Objects],
						Status -> Available,
						DeveloperObject -> True,
						Site->Link[$Site],
						Name -> "Test Omega for ExperimentFluorescenceKinetics "<>$SessionUUID
					|>
				}
			]
		]
	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		fkBackUpCleanup[];
	)
];

fkBackUpCleanup[]:=Module[{namedObjects,lurkers},
	namedObjects=Flatten@{
		Object[Protocol,FluorescenceKinetics,"Existing FK Protocol"<>$SessionUUID],
		Object[Protocol,FluorescenceKinetics,"World's Best FK Protocol"<>$SessionUUID],
		Object[Sample,"Test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 5 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 6 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 7 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 8 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Test sample 9 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Fake 40mer DNA oligomer for ExperimentFluorescenceKinetics tests"<>$SessionUUID],
		Object[Sample,"Injection test sample 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Injection test sample 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Injection test sample 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"Injection test sample 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Model[Molecule,Oligomer,"Fake 40mer DNA Model Molecule for ExperimentFluorescenceKinetics tests"<>$SessionUUID],
		Object[Container,Plate,"Empty plate for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Plate,"Test plate 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Plate,"Test plate 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Plate,"Test plate 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Plate,"Test plate 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Vessel,"Test vessel 1 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Vessel,"Test vessel 2 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Vessel,"Test vessel 3 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Vessel,"Test vessel 4 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Container,Vessel,"Test vessel 5 for ExperimentFluorescenceKinetics"<>$SessionUUID],
		Object[Sample,"High volume sample for ExperimentFluorescenceKinetics testing"<>$SessionUUID],
		Model[Sample, "Test Oligomer for ExperimentFluorescenceKinetics"<>$SessionUUID<>$SessionUUID],
		(Object[Container, Plate, "Test plate "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID]&)/@Range[5],
		(Object[Container, Vessel, "Test vessel "<>ToString[#]<>" for ExperimentFluorescenceKinetics"<>$SessionUUID]&)/@Range[5]
	};
	lurkers=PickList[namedObjects,DatabaseMemberQ[namedObjects],True];
	EraseObject[lurkers,Force->True,Verbose->False]
];


DefineTests[
	FluorescenceKinetics,
	{
		Example[
			{Basic,"Generate an ExperimentManualSamplePreparation protocol based on a single FluorescenceKinetics unit operation with a single sample:"},
			ExperimentManualSamplePreparation[
				FluorescenceKinetics[
					Sample->{Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentManualSamplePreparation protocol based on a single FluorescenceKinetics unit operation with multiple samples:"},
			ExperimentManualSamplePreparation[
				FluorescenceKinetics[
					Sample->{Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID],Object[Sample,"Test sample 2 for FluorescenceKinetics" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentManualSamplePreparation protocol based on a single FluorescenceKinetics unit operation with a single sample using ExperimentSamplePreparation:"},
			ExperimentSamplePreparation[
				FluorescenceKinetics[
					Sample->{Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentRoboticSamplePreparation protocol based on a single FluorescenceKinetics unit operation a single samples:"},
			ExperimentRoboticSamplePreparation[
				FluorescenceKinetics[
					Sample->{Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID],Object[Sample,"Test sample 2 for FluorescenceKinetics" <> $SessionUUID]}
				]
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Example[
			{Basic,"Generate an ExperimentRoboticSamplePreparation protocol based on a single FluorescenceKinetics unit operation with a single sample using ExperimentSamplePreparation:"},
			ExperimentSamplePreparation[
				FluorescenceKinetics[
					Sample->{Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID]},
					Preparation->Robotic
				]
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Example[
			{Additional,"Label the sample and then perform the FluorescenceKinetics unit operation:"},
			ExperimentRoboticSamplePreparation[
				{
					LabelSample[
						Label -> "my FK sample",
						Sample -> Object[Sample, "Test sample 1 for FluorescenceKinetics" <> $SessionUUID]
					],
					FluorescenceKinetics[
						Sample -> {"my FK sample"}
					]
				}
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjects,existsFilter,plate1,plate2,sample1,sample2,sample3},
			(* Define a list of all of the objects that are created in the SymbolSetUp *)
			allObjects = {
				Object[Container,Plate,"Test 96-well UV-Star Plate 1 for FluorescenceKinetics" <> $SessionUUID],
				Object[Container,Plate,"Test 96-well UV-Star Plate 2 for FluorescenceKinetics" <> $SessionUUID],
				Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID],
				Object[Sample,"Test sample 2 for FluorescenceKinetics" <> $SessionUUID],
				Object[Sample,"Test sample 3, small volume, for FluorescenceKinetics" <> $SessionUUID]
			};

			(* Erase any Objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]];

			(* Create some empty containers. *)
			{plate1,plate2}=Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well UV-Star Plate"], Objects],
					Name -> "Test 96-well UV-Star Plate 1 for FluorescenceKinetics" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well UV-Star Plate"], Objects],
					Name -> "Test 96-well UV-Star Plate 2 for FluorescenceKinetics" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create some samples for testing purposes *)
			{sample1,sample2,sample3}=UploadSample[
				{
					Model[Sample,StockSolution,"0.2M FITC"],
					Model[Sample,StockSolution,"0.2M FITC"],
					Model[Sample,StockSolution,"0.2M FITC"]
				},
				{
					{"A1",plate1},
					{"B1",plate1},
					{"A1",plate2}
				},
				Name->{
					"Test sample 1 for FluorescenceKinetics" <> $SessionUUID,
					"Test sample 2 for FluorescenceKinetics" <> $SessionUUID,
					"Test sample 3, small volume, for FluorescenceKinetics" <> $SessionUUID
				},
				InitialAmount->{
					250 Microliter,
					250 Microliter,
					200 Microliter
				},
				SampleHandling->{
					Liquid,
					Liquid,
					Liquid
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->sample1,DeveloperObject->True|>,
				<|Object->sample2,DeveloperObject->True|>,
				<|Object->sample3,DeveloperObject->True|>
			}];
		];
	),
	SymbolTearDown :> (Module[{allObjects},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Make sure this is the same list as allObjects in the symbolSetUp *)
		allObjects = {
			Object[Container,Plate,"Test 96-well UV-Star Plate 1 for FluorescenceKinetics" <> $SessionUUID],
			Object[Container,Plate,"Test 96-well UV-Star Plate 2 for FluorescenceKinetics" <> $SessionUUID],
			Object[Sample,"Test sample 1 for FluorescenceKinetics" <> $SessionUUID],
			Object[Sample,"Test sample 2 for FluorescenceKinetics" <> $SessionUUID],
			Object[Sample,"Test sample 3, small volume, for FluorescenceKinetics" <> $SessionUUID]
		};

		Quiet[EraseObject[allObjects,Force->True,Verbose->False]];
	];)
]
(* ::Section:: *)
(*End Test Package*)
