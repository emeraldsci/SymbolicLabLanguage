(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentLuminescenceIntensity*)


DefineTests[
	ExperimentLuminescenceIntensity,
	{
		Example[{Basic,"Measure the luminescence intensity of a sample:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Basic,"Measure the luminescence intensity of all samples in a plate:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		
		Example[{Additional,"Input the sample as {Position,Container}:"},
			ExperimentLuminescenceIntensity[{"A4", Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]}],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Additional,"Input the sample as a mixture of different kinds of samples: "},
			ExperimentLuminescenceIntensity[{
				{"A4", Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				{"A3", Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]
			}],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		(* -- Messages -- *)
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentLuminescenceIntensity[
				Link[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Now]
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages,"EmptyContainers","All containers provided as input to the experiment must contain samples:"},
			ExperimentLuminescenceIntensity[{Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Container,Plate,"Empty plate for ExperimentLuminescenceIntensity "<>$SessionUUID]}],
			$Failed,
			Messages:>{Error::EmptyContainers}
		],
		Test["When running tests returns False if all containers provided as input to the experiment don't contain samples:",
			ValidExperimentLuminescenceIntensityQ[{Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Container,Plate,"Empty plate for ExperimentLuminescenceIntensity "<>$SessionUUID]}],
			False
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Throws an error if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:"},
			ExperimentLuminescenceIntensity[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
			},
				Aliquot->{False,False,False}
			],
			$Failed,
			Messages:>{
				Error::RepeatedPlateReaderSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Indicates that all samples will be aliquoted in order to multiple aliquots of the repeated sample:"},
			ExperimentLuminescenceIntensity[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
			}],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{
				Warning::RepeatedPlateReaderSamples
			}
		],
		Test["When running tests returns False if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:",
			ValidExperimentLuminescenceIntensityQ[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
			},
				Aliquot->{False,False,False}
			],
			False
		],
		Example[{Messages,"ReplicateAliquotsRequired","Throws an error if replicates are requested, but Aliquot has been set to False so replicate samples cannot be created for the read:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Aliquot->False,NumberOfReplicates->3],
			$Failed,
			Messages:>{
				Error::ReplicateAliquotsRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ReplicateAliquotsRequired","Indicates that aliquoting will occur in order to generate replicates:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],NumberOfReplicates->3],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{
				Warning::ReplicateAliquotsRequired
			}
		],
		Test["When running tests returns False if replicates are requested, but Aliquot has been set to False so replicate samples cannot be created for the read:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Aliquot->False,NumberOfReplicates->3],
			False
		],
		Example[{Messages,"PlateReaderStowaways","Indicates if there are additional samples which weren't sent as an inputs which will be heated while performing the experiment:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Temperature->30 Celsius],
			ObjectP[],
			Messages:>{Warning::PlateReaderStowaways}
		],
		Test["When running tests indicates if there are additional samples which weren't sent as an inputs which will be heated while performing the experiment:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Temperature->30 Celsius],
			True
		],
		Example[{Messages,"PlateReaderStowaways","The PlateReaderStowaways warning is only thrown if samples are set to be heated or mixed in the plate reader chamber:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
			ObjectP[]
		],
		Test["When running tests the PlateReaderStowaways warning is only given if samples are set to be heated or mixed in the plate reader chamber:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
			True
		],
		Example[{Messages,"InstrumentPrecision","If the specified option value is more precise than the instrument can support it will be rounded:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Temperature->28.99 Celsius],
			ObjectP[],
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Test["When running tests indicates if the specified option value is more precise than the instrument can support it will be rounded:",
			ValidExperimentLuminescenceIntensityQ[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Temperature->28.99 Celsius],
			True
		],
		Example[{Messages,"UnsupportedWavelengthSelection","The type of wavelength selection must be supported by the requested plate reader:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],WavelengthSelection->Monochromators,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::UnsupportedWavelengthSelection,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates the type of wavelength selection must be supported by the requested plate reader:",
			ValidExperimentLuminescenceIntensityQ[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],WavelengthSelection->Monochromators,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"EmissionWavelengthUnavailable","Throws an error if the specified plate reader does not support one of the requested emission wavelengths:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength->{458 Nanometer,590 Nanometer,690 Nanometer},Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::EmissionWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates returns False if the specified plate reader does not support one of the requested emission wavelengths:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength->{458 Nanometer,590 Nanometer,690 Nanometer},Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Example[{Messages,"DualEmissionUnavailable","DualEmissionWavelength and DualEmissionGain can only be set if the requested plate reader supports dual emission:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->590 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates DualEmissionWavelength and DualEmissionGain can only be set if the requested plate reader supports dual emission:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->590 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Test["The DualEmissionUnavailable and DualEmissionWavelengthUnavailable messages are not both thrown:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->390 Nanometer,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DualEmissionWavelengthUnavailable","Throws an error if there are no emission filters which can provide the requested wavelength:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->400 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			$Failed,
			Messages:>{
				Error::DualEmissionWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if there are no emission filters which can provide the requested wavelength:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->400 Nanometer,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]],
			False
		],
		Example[{Messages,"DualEmissionGainRequired","If a dual emission wavelength is set, the corresponding gain must also be provided:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->590 Nanometer,DualEmissionGain->Null],
			$Failed,
			Messages:>{
				Error::DualEmissionGainRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that if a dual emission wavelength is set, the corresponding gain must also be provided:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->590 Nanometer,DualEmissionGain->Null],
			False
		],
		Example[{Messages,"DualEmissionGainUnneeded","DualEmissionGain cannot be provided if no dual emission wavelength is provided:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionGain->70 Percent,DualEmissionWavelength->Null],
			$Failed,
			Messages:>{
				Error::DualEmissionGainUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that DualEmissionGain cannot be provided if no dual emission wavelength is provided:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionGain->70 Percent,DualEmissionWavelength->Null],
			False
		],
		Example[{Messages,"MaxWavelengthsExceeded","The number of requested emission wavelengths cannot exceed the max number of readings allowed by the instrument:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"CLARIOstar"],
				EmissionWavelength->{665 Nanometer,670 Nanometer,675 Nanometer,680 Nanometer,685 Nanometer,690 Nanometer}
			],
			False
		],
		Example[{Messages,"IncompatibleGains","Provided values for the Gain and DualEmissionGain must be in the same units:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				DualEmissionWavelength->520 Nanometer,
				Gain->85 Percent,
				DualEmissionGain->2500 Microvolt],
			$Failed,
			Messages:>{
				Error::IncompatibleGains,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that provided values for the Gain and DualEmissionGain must be in the same units:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->520 Nanometer,Gain->85 Percent,DualEmissionGain->2500 Microvolt],
			False
		],
		Example[{Messages,"FocalHeightUnavailable","Only certain plate readers support focal height adjustments:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],FocalHeight->12 Millimeter],
			$Failed,
			Messages:>{
				Error::FocalHeightUnavailable,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that only certain plate readers support focal height adjustments:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],FocalHeight->12 Millimeter],
			False
		],
		Example[{Messages,"FocalHeightAdjustmentSampleRequired","The adjustment sample must be supplied as an object if FocalHeight->Auto:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->FullPlate,FocalHeight->Auto],
			$Failed,
			Messages:>{Error::FocalHeightAdjustmentSampleRequired,Error::InvalidOption}
		],
		Example[{Messages,"MultipleFocalHeightsRequested","At most one FocalHeight can be set to Auto or any specific distance:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength -> {352 Nanometer, 400 Nanometer, 450 Nanometer},FocalHeight->{Auto, Auto, 3 Millimeter}],
			$Failed,
			Messages:>{Error::MultipleFocalHeightsRequested,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied as an object if FocalHeight->Auto:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->FullPlate,FocalHeight->Auto],
			False

		],
		Example[{Messages,"InvalidAdjustmentSample","AdjustmentSample must be located within one of the assay plates:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Fluorescent Assay Sample 6"]],
			$Failed,
			Messages:>{
				Error::InvalidAdjustmentSample,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that the AdjustmentSample must be located within one of the assay plates:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Fluorescent Assay Sample 6"]],
			False
		],
		Example[{Messages,"AmbiguousAdjustmentSample","If the adjustment sample appears in the input list multiple times, the first appearance of it will be used:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				DestinationWell->{"B1","B2","B3","B4"}
			][AdjustmentSampleWells],
			{"B1"},
			Messages:>{
				Warning::AmbiguousAdjustmentSample
			}
		],
		Test["When running tests, generates a warning test if the adjustment sample appears in the input list multiple times, the first appearance of it will be used:",
			ValidExperimentLuminescenceIntensityQ[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]
			],
			True
		],
		Example[{Messages,"AdjustmentSampleIndex","Throws an error if the index of the adjustment sample is higher than the number of times that sample appears:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{3,Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleIndex,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the index of the adjustment sample is higher than the number of times that sample appears:",
			ValidExperimentLuminescenceIntensityQ[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{3,Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]}
			],
			False
		],
		Example[{Messages,"AdjustmentSampleUnneeded","An error will be thrown if an AdjustmentSample was provided but the Gain was supplied as a raw voltage and FocalHeight was set to a distance:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				EmissionWavelength->{460 Nanometer, 590 Nanometer},
				Gain->{1500 Microvolt,2500 Microvolt},
				FocalHeight->12 Millimeter
			],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an AdjustmentSample was provided but the Gain was supplied as a raw voltage and FocalHeight was set to a distance:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				EmissionWavelength->{460 Nanometer, 590 Nanometer},
				Gain->{1500 Microvolt,2500 Microvolt},
				FocalHeight->12 Millimeter
			],
			False
		],
		Example[{Messages,"AdjustmentSampleUnneeded","If the Omega is being used, the AdjustmentSample should only be set if it is being used to determine the gain:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2500 Microvolt,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			$Failed,
			Messages:>{
				Error::AdjustmentSampleUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that if the Omega is being used, the AdjustmentSample should only be set if it is being used to determine the gain:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2500 Microvolt,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]],
			False
		],
		Test["No error is thrown if the AdjustmentSample can be used to set the focal height:",
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2500 Microvolt],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Test["When running tests no error is thrown if the AdjustmentSample can be used to set the focal height:",
			ValidExperimentLuminescenceIntensityQ[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2500 Microvolt],
			True
		],
		Test["If one of the gains is specified as a percent, don't throw the AdjustmentSampleUnneeded error:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2500 Microvolt,DualEmissionGain->12 Percent,FocalHeight->12 Millimeter],
			$Failed,
			Messages:>{
				Error::IncompatibleGains,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AdjustmentSampleRequired","The adjustment sample must be supplied if gain is specified as a percentage:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				AdjustmentSample->Null,
				Gain->85 Percent
			],
			$Failed,
			Messages:>{Error::AdjustmentSampleRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied if gain is specified as a percentage:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				AdjustmentSample->Null,
				Gain->85 Percent
			],
			False
		],
		Example[{Messages,"GainAdjustmentSampleRequired","The adjustment sample must be supplied as an object if gain is specified as a percentage and the plate reader being used cannot adjust by examining the full plate:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				AdjustmentSample->FullPlate,
				Gain->85 Percent
			],
			$Failed,
			Messages:>{Error::GainAdjustmentSampleRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that the adjustment sample must be supplied as an object if gain is specified as a percentage and the plate reader being used cannot adjust by examining the full plate:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				AdjustmentSample->FullPlate,
				Gain->85 Percent
			],
			False
		],
		Example[{Messages,"MixingParametersRequired","Throws an error if PlateReaderMix->True and PlateReaderMixTime has been set to Null:"},
			ExperimentLuminescenceIntensity[
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ValidExperimentLuminescenceIntensityQ[
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->Null
			],
			False
		],
		Example[{Messages,"MixingParametersUnneeded","Throws an error if PlateReaderMix->False and PlateReaderMixTime has been specified:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			False
		],
		Example[{Messages,"MixingParametersConflict","Throw an error if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:"},
			ExperimentLuminescenceIntensity[
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			False
		],
		Example[{Messages,"MoatParametersConflict","The moat options must all be set to Null or to specific values:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatVolume->Null,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			False
		],
		Example[{Messages,"MoatAliquotsRequired","Moats are created as part of sample aliquoting. As a result if a moat is requested Aliquot must then be set to True:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Aliquot->False,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::MoatAliquotsRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MoatAliquotsRequired","Indicates that all samples will be aliquoted into a new plate in order to set-up the moat:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{Warning::MoatAliquotsRequired}
		],
		Test["When running tests, indicates that a moat cannot be requested if Aliquot->False:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Aliquot->False,
				MoatBuffer->Model[Sample,"Milli-Q water"]
			],
			False
		],
		Example[{Messages,"MoatVolumeOverflow","The moat wells cannot be filled beyond the MaxVolume of the container:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Aliquot->True,
				MoatVolume->500 Microliter
			],
			$Failed,
			Messages:>{
				Error::MoatVolumeOverflow,
				Error::InvalidOption
			}
		],
		Test["When running tests, indicates that the moat wells cannot be filled beyond the MaxVolume of the container:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatVolume->500 Microliter
			],
			False
		],
		Example[{Messages,"TooManyMoatWells","Throws an error if more wells are required than are available in the plate. Here the moat requires 64 wells and the samples with replicates require 40 wells:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 5 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 6 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID]
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
			ValidExperimentLuminescenceIntensityQ[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 5 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 6 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				NumberOfReplicates->5,
				MoatSize->2
			],
			False
		],
		Test["Handles the case where 2*MoatSize is larger than the number of columns:",
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
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
			ExperimentLuminescenceIntensity[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
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
			ValidExperimentLuminescenceIntensityQ[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				DestinationWell->{"A1","B2"},
				MoatVolume->150 Microliter
			],
			False
		],
		Example[{Messages,"MissingInjectionInformation","Throws an error if an injection volume is specified without a corresponding sample:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->{1 Microliter,Null,2 Microliter,3 Microliter}
			],
			$Failed,
			Messages:>{
				Error::MissingInjectionInformation,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an injection volume is specified without a corresponding sample:",
			ValidExperimentLuminescenceIntensityQ[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->{1 Microliter,Null,2 Microliter,3 Microliter}
			],
			False
		],
		Example[{Messages,"MissingInjectionInformation","Throws an error if an injection sample is specified without a corresponding volume:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Null,Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->{1 Microliter,Null,Null, 1 Microliter}
			],
			$Failed,
			Messages:>{
				Error::MissingInjectionInformation,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if an injection sample is specified without a corresponding volume:",
			ValidExperimentLuminescenceIntensityQ[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Null,Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->{1 Microliter,Null,Null, 1 Microliter}
			],
			False
		],
		Example[{Messages,"SingleInjectionSampleRequired","Only one unique sample can be injected in an injection group:"},
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->3 Microliter
			],
			$Failed,
			Messages:>{
				Error::SingleInjectionSampleRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that only one unique sample can be injected in an injection group:",
			ValidExperimentLuminescenceIntensityQ[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->3 Microliter
			],
			False
		],
		Example[{Messages,"WellVolumeExceeded","Throws an error if the injections will fill the well past its max volume:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->150 Microliter,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SecondaryInjectionVolume->150 Microliter
			],
			$Failed,
			Messages:>{
				Error::WellVolumeExceeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the injections will fill the well past its max volume:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->150 Microliter,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SecondaryInjectionVolume->150 Microliter
			],
			False
		],
		Example[{Messages,"HighWellVolume","Throws a warning if the injection will fill the well nearly to the top:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->20 Microliter
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{
				Warning::HighWellVolume
			}
		],
		Test["When running tests returns True if the injection will fill the well nearly to the top:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->20 Microliter
			],
			True
		],
		Example[{Messages,"InjectionFlowRateUnneeded","Throws an error if PrimaryInjectionFlowRate is specified, but there are no injections:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionFlowRate->400 Microliter/Second
			],
			$Failed,
			Messages:>{
				Error::InjectionFlowRateUnneeded,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if PrimaryInjectionFlowRate is specified, but there are no injections:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionFlowRate->400 Microliter/Second
			],
			False
		],

		Example[{Messages,"InjectionFlowRateRequired","Throws an error if the corresponding InjectionFlowRate is set to Null when there are injections:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SecondaryInjectionVolume->2 Microliter,
				PrimaryInjectionFlowRate->Null,
				SecondaryInjectionFlowRate->400Microliter/Second
			],
			$Failed,
			Messages:>{
				Error::InjectionFlowRateRequired,
				Error::InvalidOption
			}
		],
		Test["When running tests returns False if the corresponding InjectionFlowRate is set to Null when there are injections:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->1 Microliter,
				SecondaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SecondaryInjectionVolume->2 Microliter,
				PrimaryInjectionFlowRate->Null,
				SecondaryInjectionFlowRate->Null
			],
			False
		],
		Example[{Messages,"NonUniqueName","The protocol must be given a unique name:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Name->"Existing LI Protocol "<>$SessionUUID],
			$Failed,
			Messages:>{
				Error::NonUniqueName,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that the protocol must be given a unique name:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Name->"Existing LI Protocol "<>$SessionUUID],
			False
		],
		Example[{Messages,"NoPlateReader","Indicates that none of the possible plate readers can provide the requested dual emission wavelength:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->512 Nanometer],
			$Failed,
			Messages:>{
				Error::NoPlateReader,
				Error::InvalidOption
			}
		],
		Test["When running tests indicates that none of the possible plate readers can provide the requested dual emission wavelength:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->512 Nanometer],
			False
		],
		Example[{Messages,"SinglePlateRequired","Prints a message and returns $Failed if all the samples will not be in a single plate before the read starts:"},
			ExperimentLuminescenceIntensity[{
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Aliquot->False
			],
			$Failed,
			Messages:>{Error::SinglePlateRequired,Error::InvalidOption}
		],
		Example[{Messages,"SinglePlateRequired","Indicates that all samples must be aliquoted into a single plate before starting the experiment:"},
			ExperimentLuminescenceIntensity[{
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{Warning::SinglePlateRequired}
		],
		Test["When running tests returns False if all the samples will not be in a single plate before the read starts:",
			ValidExperimentLuminescenceIntensityQ[{
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Aliquot->False
			],
			False
		],
		Example[{Messages,"SinglePlateRequired","Samples must be aliquoted into a container which is compatible with the plate reader:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]],
			$Failed,
			Messages:>{Error::InvalidAliquotContainer,Error::InvalidOption}
		],
		Test["When running tests indicates that samples must be aliquoted into a container which is compatible with the plate reader:",
			ValidExperimentLuminescenceIntensityQ[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]],
			False
		],
		Example[{Messages,"TooManyPlateReaderSamples","The total number of samples, with replicates included, cannot exceed the number of wells in the aliquot plate:"},
			ExperimentLuminescenceIntensity[{
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				NumberOfReplicates->50,
				Aliquot->True
			],
			$Failed,
			Messages:>{Error::TooManyPlateReaderSamples,Warning::TotalAliquotVolumeTooLarge,Error::InvalidInput}
		],
		Test["When running tests indicates that the total number of samples, with replicates included, cannot exceed the number of wells in the aliquot plate:",
			ValidExperimentLuminescenceIntensityQ[{
				Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				NumberOfReplicates->50,
				Aliquot->True
			],
			False
		],
		Example[{Messages,"InvalidAliquotContainer","The aliquot container must be supported by the plate reader:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Aliquot->True,
				AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages:>{Error::InvalidAliquotContainer,Error::InvalidOption}
		],
		Test["When running tests indicates that the aliquot container must be supported by the plate reader:",
			ValidExperimentLuminescenceIntensityQ[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Aliquot->True,
				AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			False
		],
		Example[{Messages,"SinglePlateRequired","Samples can only be aliquoted into a single plate:"},
			ExperimentLuminescenceIntensity[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Aliquot->True,
				AliquotContainer->{{1,Model[Container,Plate,"96-well Black Wall Plate"]},{2,Model[Container,Plate,"96-well Black Wall Plate"]}}
			],
			$Failed,
			Messages:>{Error::SinglePlateRequired,Error::InvalidOption}
		],
		Test["When running tests indicates that samples can only be aliquoted into a single plate:",
			ValidExperimentLuminescenceIntensityQ[{
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Aliquot->True,
				AliquotContainer->{{1,Model[Container,Plate,"96-well Black Wall Plate"]},{2,Model[Container,Plate,"96-well Black Wall Plate"]}}
			],
			False
		],
		Example[{Messages,"BottomReadingAliquotContainer","If ReadLocation is set to Bottom, the AliquotContainer must have a Clear bottom:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				AliquotContainer->Model[Container, Plate, "96-Well All Black Plate"],
				ReadLocation->Bottom
			],
			$Failed,
			Messages:>{Error::BottomReadingAliquotContainerRequired,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleMaterials","All injection samples must be compatible with the plate reader tubing:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 6 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter
			],
			$Failed,
			Messages:>{Error::IncompatibleMaterials,Error::InvalidOption}
		],
		Test["When running tests indicates that all injection samples must be compatible with the plate reader tubing:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 6 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->Object[Sample,"Injection test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter
			],
			False
		],
		Example[{Messages,"WavelengthSelectionRequired","Print a message and returns $Failed if WavelengthSelection is set to no filter but specific emission wavelengths are provided:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				WavelengthSelection->NoFilter,
				EmissionWavelength->{400 Nanometer,NoFilter}
			],
			$Failed,
			Messages:>{Error::WavelengthSelectionRequired,Error::InvalidOption}
		],
		Test["When running tests returns False if WavelengthSelection is set to no filter but specific emission wavelengths are provided:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				WavelengthSelection->NoFilter,
				EmissionWavelength->{400 Nanometer,NoFilter}
			],
			False
		],
		Example[{Messages,"WavelengthSelectionUnused","Print a message and returns $Failed if WavelengthSelection is set to Filters or Monochromators but no specific emission wavelengths are requested:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				WavelengthSelection->Filters,
				EmissionWavelength->NoFilter
			],
			$Failed,
			Messages:>{Error::WavelengthSelectionUnused,Error::InvalidOption}
		],
		Test["When running tests returns False if WavelengthSelection is set to Filters or Monochromators but no specific emission wavelengths are requested:",
			ValidExperimentLuminescenceIntensityQ[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				WavelengthSelection->Filters,
				EmissionWavelength->NoFilter
			],
			False
		],
		Example[{Messages,"CoveredTopRead","If the cover is being left on while data is collected bottom reads are recommended:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				RetainCover->True,
				ReadLocation->Top
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]],
			Messages:>{Warning::CoveredTopRead}
		],
		Example[{Messages,"CoveredInjections","The cover cannot be left on if any injections are being performed:"},
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter,
				RetainCover->True
			],
			$Failed,
			Messages:>{Error::CoveredInjections,Error::InvalidOption}
		],
		Example[{Messages,"SharedContainerStorageCondition","The specified storage condition cannot conflict with storage conditions of samples sharing the same container:"},
			ExperimentLuminescenceIntensity[
				Object[Container, Plate, "Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SamplesInStorageCondition -> {Freezer, Disposal, Freezer, Freezer}
			],
			$Failed,
			Messages:>{Error::SharedContainerStorageCondition,Error::InvalidOption}
		],
		(* -- OPTION RESOLUTION -- *)
		Example[{Options,Instrument,"Specify the plate reader model that should be used to measure luminescence intensity:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]][Instrument][Name],
			"FLUOstar Omega"
		],
		Example[{Options,Instrument,"Request a particular plate reader instrument be used:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Object[Instrument,PlateReader,"Test Omega for ExperimentLuminescenceIntensity "<>$SessionUUID]][Instrument][Name],
			"Test Omega for ExperimentLuminescenceIntensity "<>$SessionUUID
		],
		Example[{Options,Instrument,"A plate reader model will be automatically selected based on any provided wavelength options:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Automatic,EmissionWavelength->485 Nanometer][Instrument],
			ObjectP[Model[Instrument,PlateReader]]
		],
		Example[{Options,EmissionWavelength,"Request a wavelength at which luminescence emitted from the provided samples will be detected:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength->590 Nanometer][EmissionWavelengths],
			{590 Nanometer},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionWavelength,"Request a secondary wavelength at which luminescence emitted from the provided samples will be detected:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->520 Nanometer][DualEmissionWavelengths],
			{520 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Doesn't populate EmissionWavelengths if no filter is being used:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength->NoFilter,Instrument->Model[Instrument,PlateReader,"PHERAstar FS"]][EmissionWavelengths],
			{Null},
			EquivalenceFunction->Equal
		],
		Test["The order wavelengths are specified in the optic module does not have to match the user's requested wavelengths:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->586 Nanometer][EmissionWavelengths],
			{520 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Handles the case where the optic module has only one emission wavelength:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength->680 Nanometer,Instrument->Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]][DualEmissionWavelengths],
			{Null}
		],
		Test["Sets the DualEmissionGain if any dual emission wavelengths are set:",
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				EmissionWavelength->{590 Nanometer,680 Nanometer},
				DualEmissionWavelength->{520 Nanometer,Null}
			][DualEmissionGainPercentages],
			{90.` Percent,Null}
		],
		Example[{Options,WavelengthSelection,"Indicate how the emission wavelengths should be achieved :"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],WavelengthSelection->Monochromators][WavelengthSelection],
			Monochromators
		],
		Example[{Options,WavelengthSelection,"Resolves to a plate reader which supports the requested WavelengthSelection:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],WavelengthSelection->Monochromators][Instrument],
			ObjectP[Model[Instrument,PlateReader,"id:E8zoYvNkmwKw"]]
		],
		Example[{Options,WavelengthSelection,"If all the light is to be detected this can be indicated by setting WavelengthSelection to NoFilter:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],WavelengthSelection->NoFilter][EmissionWavelengths],
			{Null}
		],
		Example[{Options,ReadLocation,"Indicate the direction from which luminescence from sample wells in the provided plate should be read:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],ReadLocation->Bottom][ReadLocation],
			Bottom
		],
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],ReadDirection->SerpentineColumn][ReadDirection],
			SerpentineColumn
		],
		Example[{Options,Temperature,"Request that the assay plate be maintained at a particular temperature in the plate reader during luminescence intensity readings:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Temperature->37 Celsius][Temperature],
			37 Celsius,
			EquivalenceFunction->Equal
		],
		Example[{Options,EquilibrationTime,"Indicate the time for which to allow assay samples to equilibrate with the requested assay temperature. This equilibration will occur after the plate reader chamber reaches the requested Temperature, and before luminescence intensity readings are taken:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EquilibrationTime->4 Minute][EquilibrationTime],
			4 Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options, Instrument, "Instrument is automatically set to Model[Instrument, PlateReader, \"id:zGj91a7Ll0Rv\"] if TargetCarbonDioxideLevel/TargetOxygenLevel is set:"},
			Lookup[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID], TargetCarbonDioxideLevel -> 5 * Percent, Output -> Options],
				Instrument
			],
			ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]
		],
		Example[{Options, TargetCarbonDioxideLevel, "TargetCarbonDioxideLevel is automatically set to 5 Percent if sample contains Mammalian cells:"},
			Lookup[
				ExperimentLuminescenceIntensity[Object[Sample, "Test sample with mammalian cells for ExperimentLuminescenceIntensity "<>$SessionUUID], Instrument -> Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], Output -> Options],
				TargetCarbonDioxideLevel
			],
			5 * Percent
		],
		Example[{Options,AdjustmentSample,"Provide a sample to be used as a reference by which to adjust the gain in order to avoid saturating the detector:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]][AdjustmentSamples][Name],
			{"Test sample 1 for ExperimentLuminescenceIntensity " <> $SessionUUID}
		],
		Example[{Options,AdjustmentSample,"If a sample appears multiple times, indicate which aliquot of it should be used to adjust the gain. Here we indicate that the 20\[Micro]L aliquot of \"Test sample 1\" should be used:"},
			ExperimentLuminescenceIntensity[
				{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},
				AliquotAmount->{10 Microliter,10 Microliter,20 Microliter,20 Microliter},
				AssayVolume->150 Microliter,
				AdjustmentSample->{2,Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]}
			][AdjustmentSamples][Name],
			{"Test sample 1 for ExperimentLuminescenceIntensity " <> $SessionUUID}
		],
		Example[{Options,Gain,"Provide a raw voltage that will be used by the plate reader to amplify the raw signal from the primary emission detector:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->2000 Microvolt][Gains],
			{2000 Microvolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,Gain,"Provide the gain as a percentage to indicate that gain adjustments should be normalized to the provided adjustment sample at run time:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Gain->90 Percent][GainPercentages],
			{90 Percent},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionGain,"Provide a raw voltage that will be used by the plate reader to amplify the raw signal from the secondary emission detector:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->520 Nanometer,Gain->2000 Microvolt,DualEmissionGain->2000 Microvolt][DualEmissionGains],
			{2000 Microvolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,DualEmissionGain,"Provide the dual gain as a percentage to indicate that gain adjustments should be normalized to the provided adjustment sample at run time:"},
			ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionWavelength->520 Nanometer,AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],DualEmissionGain->90 Percent][DualEmissionGainPercentages],
			{90 Percent},
			EquivalenceFunction->Equal
		],
		Example[{Options,FocalHeight,"Set an explicit focal height at which to set the focusing element of the plate reader during luminescence intensity readings:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"PHERAstar FS"],FocalHeight->8 Millimeter][FocalHeights],
			{8 Millimeter},
			EquivalenceFunction->Equal
		],
		Example[{Options,FocalHeight,"Indicate that focal height adjustment should occur on-the-fly by determining the height which gives the highest luminescence reading for the specified sample:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"PHERAstar FS"],FocalHeight->Auto,AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]][AutoFocalHeights],
			{True}
		],
		Example[{Options,FocalHeight,"One can determine which excitation/emission wavelength pair the focal height should be adjusted, by setting the FocalHeight option for that pair to Auto:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength -> {352 Nanometer, 400 Nanometer, 450 Nanometer}, FocalHeight-> {Automatic, Auto, Automatic},AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]][AutoFocalHeights],
			{Null, True, Null}
		],
		Example[{Options,FocalHeight,"If FocalHeight option is set to a specific distance for one excitation/emission wavelength pair, this distance will also be set to other pairs:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],EmissionWavelength -> {352 Nanometer, 400 Nanometer, 450 Nanometer}, FocalHeight-> {Automatic, 3 Millimeter, Automatic},AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]][FocalHeights],
			{EqualP[3 Millimeter], EqualP[3 Millimeter], EqualP[3 Millimeter]}
		],
		Example[{Options,PrimaryInjectionSample,"Specify the sample you'd like to inject into every input sample:"},
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Test["PrimaryInjectionSample can be a model:",
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
				PrimaryInjectionVolume->3 Microliter
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,PrimaryInjectionVolume,"Specify the volume you'd like to inject into every input sample:"},
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionVolume->3 Microliter
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,PrimaryInjectionVolume,"If you'd like to skip the injection for a subset of you samples, use Null as a placeholder in the injection samples list and injection volumes list. Here \"Test sample 2 for ExperimentLuminescenceIntensity\" and \"Test sample 3 for ExperimentLuminescenceIntensity\" will not receive injections:"},
			Download[
				ExperimentLuminescenceIntensity[
					{
						Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 4 for ExperimentLuminescenceIntensity "<>$SessionUUID]
					},
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Null,Null,Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					PrimaryInjectionVolume->{3 Microliter,Null,Null,3 Microliter}
				],
				PrimaryInjections
			],
			{
				{LinkP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3.` Microliter},
				{Null,0.` Microliter},
				{Null,0.` Microliter},
				{LinkP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,SecondaryInjectionSample,"Specify the sample to inject in the second round of injections:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				PrimaryInjectionVolume->{1 Microliter},
				SecondaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				SecondaryInjectionVolume->{1 Microliter}
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Options,SecondaryInjectionVolume,"Specify that 2\[Micro]L of Object[Sample,\"Injection test sample 2 for ExperimentLuminescenceIntensity\"] should be injected into the input sample in the second injection round:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					PrimaryInjectionVolume->{1 Microliter},
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter}
				],
				SecondaryInjections
			],
			{{LinkP[Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]],2.` Microliter}}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Specify the flow rate at which the primary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentLuminescenceIntensity[
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					PrimaryInjectionVolume->{3 Microliter},
					PrimaryInjectionFlowRate->(100 Microliter/Second)
				],
				PrimaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,SecondaryInjectionFlowRate,"Specify the flow rate at which the secondary injections should be pumped into the receiving wells:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					PrimaryInjectionVolume->{1 Microliter},
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter},
					SecondaryInjectionFlowRate->(100 Microliter/Second)
				],
				SecondaryInjectionFlowRate
			],
			100 Microliter/Second,
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionSampleStorageCondition,"Indicate that the injection samples should be stored at room temperature after the experiment completes:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->1 Microliter,
					InjectionSampleStorageCondition->AmbientStorage
				],
				InjectionStorageCondition
			],
			AmbientStorage
		],
		Example[{Options,IntegrationTime,"Indicate the amount of time over which luminescence measurements should be integrated:"},
			options = ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID], IntegrationTime -> 10 Second, Output -> Options];
			Lookup[options, IntegrationTime],
			10 Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PlateReaderMix,"Set PlateReaderMix to True to shake the input plate in the reader before the assay begins:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMix->True],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM,30.` Second}
		],
		Example[{Options,PlateReaderMixTime,"Specify PlateReaderMixTime to automatically turn mixing on and resolve PlateReaderMixRate:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMixTime->1 Hour],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM,1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,PlateReaderMixRate,"If PlateReaderMixRate is specified, it will automatically turn mixing on and resolve PlateReaderMixTime:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMixRate->100 RPM],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,100.` RPM,30.` Second}
		],
		Example[{Options,PlateReaderMixMode,"Specify how the plate should be moved to perform the mixing:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMixMode->Orbital],
				PlateReaderMixMode
			],
			Orbital
		],
		Example[{Options,SamplesInStorageCondition,"Specify the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],SamplesInStorageCondition->Freezer],
				SamplesInStorage
			],
			{Freezer, Freezer, Freezer, Freezer}
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixTime->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMixTime->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixRate->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],PlateReaderMixRate->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Options,MoatSize,"Indicate the first two columns and rows and the last two columns and rows of the plate should be filled with water to decrease evaporation of the inner assay samples:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatSize->2,
				Aliquot->True
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,MoatVolume,"Indicate the volume which should be used to fill each moat well:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,MoatBuffer,"Indicate that each moat well should be filled with water:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"],
				Aliquot->True
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,ImageSample,"Indicate if assay samples should have their images re-taken after the luminescence intensity experiment:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],ImageSample->True][ImageSample],
			True
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],MeasureVolume->False],
				MeasureVolume
			],
			False
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],MeasureWeight->True],
				MeasureWeight
			],
			True
		],
		Example[{Options,Template,"Inherit unresolved options from a previously run Object[Protocol,LuminescenceIntensity]:"},
			Module[{pastProtocol},
				pastProtocol=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]];
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Template->pastProtocol]
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,Confirm,"Directly confirms a protocol into the operations queue:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Confirm->True][Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"][CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options,Name,"Name the protocol:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Name->"World's Best LI Protocol "<>$SessionUUID],
			Object[Protocol,LuminescenceIntensity,"World's Best LI Protocol "<>$SessionUUID]
		],
		Example[{Options,NumberOfReplicates,"When 3 replicates are requested, 3 aliquots will be generated from each sample and assayed to generate 3 luminescence trajectories:"},
			ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				NumberOfReplicates->3,
				Aliquot->True
			][SamplesIn],
			Join[
				ConstantArray[ObjectP[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3],
				ConstantArray[ObjectP[Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3]
			]
		],
		Example[{Options,RetainCover,"Indicate that the assay plate seal should be left on during the experiment:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				RetainCover->True
			][RetainCover],
			True
		],
		Test["Automatically sets Aliquot to True if replicates are requested:",
			Lookup[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],NumberOfReplicates->3,Output->Options],
				Aliquot
			],
			True,
			Messages:>{Warning::ReplicateAliquotsRequired}
		],
		Test["Does not change the user values when all wavelength and plate reader info is specified:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
					EmissionWavelength->620 Nanometer

				],
				EmissionWavelengths
			],
			{620 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Recognizes the Omega doesn't support dual emission:",
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				DualEmissionWavelength->535 Nanometer
			],
			$Failed,
			Messages:>{
				Error::DualEmissionUnavailable,
				Error::InvalidOption
			}
		],
		Test["Validates the specified emission wavelengths:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					EmissionWavelength->{670 Nanometer,620 Nanometer}
				],
				EmissionWavelengths
			],
			{670 Nanometer,620 Nanometer},
			EquivalenceFunction->Equal
		],
		Test["Handles duplicate inputs:",
			ExperimentLuminescenceIntensity[{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},Aliquot->True],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Test["Creates resources for the input samples, the plate reader and the operator:",
			Module[{protocol,resourceEntries,resourceObjects,samples,operators,instruments},
				protocol=ExperimentLuminescenceIntensity[{
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]
				},Aliquot->True];

				resourceEntries=Download[protocol,RequiredResources];
				resourceObjects=Download[resourceEntries[[All,1]],Object];
				operators=Cases[resourceObjects,ObjectP[Object[Resource,Operator]]];
				instruments=Cases[resourceObjects,ObjectP[Object[Resource,Instrument]]];
				samples=Download[Cases[resourceEntries,{_,SamplesIn,___}][[All,1]],Object];

				{
				(* Creates 2 unique resources *)
					MatchQ[samples,{x_,y_,x_}],
				(* Creates 5 unique operator resources - one for each checkpoint*)
					Length[operators]==5&&DuplicateFreeQ[operators],
				(* Creates 1 plate reader resource *)
					MatchQ[instruments,{ObjectP[Object[Resource,Instrument]]}]
				}
			],
			{True,True,True}
		],
		Test["Populates the cleaning fields when one unique sample is being injected:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->3 Microliter
				],
				{
					Line1PrimaryPurgingSolvent,
					Line2PrimaryPurgingSolvent,
					Line1SecondaryPurgingSolvent,
					Line2SecondaryPurgingSolvent,
					SolventWasteContainer,
					SecondarySolventWasteContainer
				}
			],
			{
				ObjectP@Model[Sample,StockSolution,"70% Ethanol"],
				Null,
				ObjectP@Model[Sample,"Milli-Q water"],
				Null,
				Null,
				Null
			}
		],
		Test["Populates the cleaning fields when two samples are being injected:",
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->2 Microliter,
					SecondaryInjectionSample->Object[Sample,"Injection test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					SecondaryInjectionVolume->2 Microliter
				],
				{
					Line1PrimaryPurgingSolvent,
					Line2PrimaryPurgingSolvent,
					Line1SecondaryPurgingSolvent,
					Line2SecondaryPurgingSolvent,
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
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
				{
					Line1PrimaryPurgingSolvent,
					Line2PrimaryPurgingSolvent,
					Line1SecondaryPurgingSolvent,
					Line2SecondaryPurgingSolvent,
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
				protocol=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->2 Microliter
				];

				resourceEntries=Download[protocol,RequiredResources];
				solventEntries=Cases[resourceEntries,{_,Line1PrimaryPurgingSolvent|Line2PrimaryPurgingSolvent|Line1SecondaryPurgingSolvent|Line2SecondaryPurgingSolvent,___}];
				solventResources=DeleteDuplicates[Download[solventEntries[[All,1]],Object]];
				uniqueSolventResources=Length[solventResources]
			],
			2
		],
		Test["Creates resources for the input samples - combining volumes as needed:",
			Module[{protocol,resourceEntries,samplesInResources},
				protocol=ExperimentLuminescenceIntensity[
					{
						Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]
					},
					AliquotAmount->{50 Microliter,50 Microliter,50 Microliter,50 Microliter},
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->2 Microliter
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
				protocol=ExperimentLuminescenceIntensity[
					{
						Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID]
					},
					EmissionWavelength->{670 Nanometer,620 Nanometer},
					AliquotAmount->{50 Microliter,50 Microliter,50 Microliter},
					NumberOfReplicates->2,
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->{1 Microliter,2 Microliter,3 Microliter}
				];
				Download[protocol,{SamplesIn,PrimaryInjections,EmissionWavelengths}]
			],
			{
				{
					ObjectP[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID]],
					ObjectP[Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID]]
				},
				{
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],1.` Microliter},
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],1.` Microliter},
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],2.` Microliter},
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],2.` Microliter},
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3.` Microliter},
					{ObjectP[Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]],3.` Microliter}
				},
				(* EmissionWavelengths is not index-matched to input, so it shouldn't get expanded *)
				{670.` Nanometer,620.` Nanometer}
			}
		],

		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				LuminescenceIntensity[
					Sample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate an LuminescenceIntensity protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				LuminescenceIntensity[
					Sample -> Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				LuminescenceIntensity[
					Sample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->4 Microliter
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				LuminescenceIntensity[
					Sample-> {
						Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],

		(* ExperimentIncubate tests. *)
		Example[{Options,Incubate,"Indicate if the SamplesIn should be incubated at a fixed temperature before starting the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Provide the temperature at which the SamplesIn should be incubated:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Indicate SamplesIn should be heated for 40 minutes before starting the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Indicate the SamplesIn should be mixed and heated for up to 2 hours or until any solids are fully dissolved:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],MixUntilDissolved->True,MaxIncubationTime->2*Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			2 Hour,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Indicate the instrument which should be used to heat SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Set the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when transferring the input sample to a new container before incubation:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubateAliquot->100*Microliter,Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"Indicate that the input samples should be transferred into 2mL tubes before they are incubated:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are incubated:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],IncubateAliquotDestinationWell->"A1",Aliquot->True,Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicate if the SamplesIn should be mixed during the incubation performed before beginning the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicate the style of motion used to mix the sample:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicate if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix type), in an attempt dissolve any solute:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

	(* ExperimentCentrifuge *)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged before starting the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeInstrument,"Set the centrifuge that should be used to spin the input samples:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeIntensity,"Indicate the rotational speed which should be applied to the input samples during centrifugation:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeTime,"Specify the SamplesIn should be centrifuged for 2 minutes:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeTime->2*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeTemperature,"Indicate the temperature at which the centrifuge chamber should be held while the samples are being centrifuged:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeTemperature->10*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquot,"Indicate the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeAliquot->100*Microliter,Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotContainer,"Indicate that the input samples should be transferred into 2mL tubes before they are centrifuged:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{2,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{3,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{4,ObjectP[Model[Container,Vessel,"2mL Tube"]]}},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are centrifuged:"},
			options=ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],CentrifugeAliquotDestinationWell->{"A1","A1","A1","A1"},Aliquot->True,Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			{"A1","A1","A1","A1"},
			Variables:>{options},
			TimeConstraint->240
		],
		(* ExperimentFilter *)
		Example[{Options,Filtration,"Indicate if the SamplesIn should be filtered prior to starting the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],Filtration->True,Aliquot->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"Specify the method by which the input samples should be filtered:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->Syringe,Aliquot->True,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"Indicate the instrument that should be used to perform the filtration:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],Aliquot->True,Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"Indicate that at a 0.22um PTFE filter should be used to remove impurities from the SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],Filter->Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"],Aliquot->True,Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterMaterial->PES,Aliquot->True,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[{Options,PrefilterMaterial,"Indicate the membrane material of the prefilter that should be used to remove impurities from the SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],PrefilterMaterial->GxF,Aliquot->True,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"Set the pore size of the filter that should be used when removing impurities from the SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Aliquot->True,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		Example[{Options,PrefilterPoreSize,"Specify the pore size of the prefilter that should be used when removing impurities from the SamplesIn:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],PrefilterPoreSize->1.`*Micrometer,Aliquot->True,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.`*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"Indicate the type of syringe which should be used to force that sample through a filter:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Aliquot->True,Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"Indicate the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->PeristalticPump,FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],Aliquot->True,Output->Options];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"Provide the rotational speed or force at which the samples should be centrifuged during filtration:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Aliquot->True,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"Specify the amount of time for which the samples should be centrifuged during filtration:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Aliquot->True,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"Set the temperature at which the centrifuge chamber should be held while the samples are being centrifuged during filtration:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->30*Celsius,Aliquot->True,Output->Options];
			Lookup[options,FilterTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicate if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterSterile->True,Aliquot->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterAliquot->200*Milliliter,Aliquot->True,Output->Options];
			Lookup[options,FilterAliquot],
			200*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"Indicate that the input samples should be transferred into a 50mL tube before they are filtered:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],Aliquot->True,Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicate the wells into which input samples should be transferred before they are filtered:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterAliquotDestinationWell->"A1",Aliquot->True,Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"Indicate the container into which samples should be filtered:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"250mL Glass Bottle"],Aliquot->True,Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"250mL Glass Bottle"]]},
			Variables:>{options}
		],
		(* aliquot options - ExperimentAliquot *)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"Indicate that a 100uL aliquot should be taken from the input sample and used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AliquotAmount->100 Microliter,Output->Options];
			Lookup[options,AliquotAmount],
			100 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"Specify the total volume of the aliquot. Here a 100uL aliquot containing 50uL of the input sample and 50uL of buffer will be generated:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->50 Microliter,Output->Options];
			Lookup[options,AssayVolume],
			100 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"Indicate that an aliquot should be prepared by diluting the input sample such that the final concentration of analyte in the aliquot is 5uM:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test 40mer DNA oligomer for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"The specific analyte to get to the specified target concentration:"},
			options=ExperimentLuminescenceKinetics[Object[Sample,"Test 40mer DNA oligomer for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Test 40mer DNA Model Molecule for ExperimentLuminescenceIntensity "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to the aliquot sample, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"Indicate the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"Set the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->20 Microliter,BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"Indicate the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotAmount->10 Microliter,AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"Set the non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AssayVolume->100 Microliter,AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicate that 2 50uL aliquots of Object[Sample,\"Oligomer 1 Sample for ExperimentLuminescenceIntensity\"] should be created. We cannot consolidate aliquots since we read each well only once - a repeated sample indicates multiple aliquots should be made to allow for multiple readings:"},
			options=ExperimentLuminescenceIntensity[{Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID]},AliquotAmount->50 Microliter,ConsolidateAliquots->False,Output->Options];
			Lookup[options,ConsolidateAliquots],
			False,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicate that the aliquots should be generated by using an automated liquid handling robot:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 8 for ExperimentLuminescenceIntensity "<>$SessionUUID],Aliquot->True,AliquotPreparation->Robotic,Output->Options];
			Lookup[options,AliquotPreparation],
			Robotic,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"Indicate that the aliquot should be prepared in a UV-Star Plate:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]}},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicate that the sample should be aliquoted into well D6:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],AliquotAmount->100 Microliter,DestinationWell->"D6",Output->Options];
			Lookup[options,DestinationWell],
			{"D6"},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Indicate if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
			options=ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicate the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed:"},
			options=ExperimentLuminescenceIntensity[Object[Container, Plate, "Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],SamplesInStorageCondition->Disposal,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentLuminescenceIntensity[
				(* Red food dye *)
				{Model[Sample, "id:BYDOjvG9z6Jl"], Model[Sample, "id:BYDOjvG9z6Jl"]},
				(* UV-Star Plate*)
				PreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
				PreparedModelAmount -> 200 Microliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:BYDOjvG9z6Jl"]]..},
				{ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared when Preparation is Robotic:"},
			roboticProtocol = ExperimentLuminescenceIntensity[
				(* Red food dye *)
				{Model[Sample, "id:BYDOjvG9z6Jl"], Model[Sample, "id:BYDOjvG9z6Jl"]},
				(* UV-Star Plate*)
				PreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
				PreparedModelAmount -> 200 Microliter,
				Preparation -> Robotic
			];
			labelSampleUO = Download[roboticProtocol, OutputUnitOperations][[1]];
			Download[
				labelSampleUO,
				{
					SampleLink,
					ContainerLink,
					AmountVariableUnit,
					Well,
					ContainerLabel
				}
			],
			{
				{ObjectP[Model[Sample, "id:BYDOjvG9z6Jl"]]..},
				{ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {roboticProtocol, labelSampleUO}
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to prepare a plate with control samples:"},
			ExperimentLuminescenceIntensity["test plate",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "test plate", Container -> Model[Container, Plate, "id:kEJ9mqR3XELE"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Amount -> 100*Microliter, Destination -> {"A1", "test plate"}],
					Transfer[Source -> Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID], Amount -> 100*Microliter, Destination -> {"A2", "test plate"}]
				}
			],
			ObjectP[Object[Protocol,LuminescenceIntensity]]
		],
		Example[{Options,SamplingPattern,"Indicate that a grid of readings should be taken for each well and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],SamplingPattern->Matrix],
				SamplingPattern
			],
			Matrix
		],
		Example[{Options,SamplingDimension,"Indicate that 16 readings (4x4) should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],SamplingDimension->4],
				SamplingDimension
			],
			4
		],
		Example[{Options,SamplingDistance,"Indicate the length of the region over which sampling measurements should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],SamplingPattern->Ring,SamplingDistance->5 Millimeter],
				SamplingDistance
			],
			5.` Millimeter
		],
		Example[{Messages,"SamplingCombinationUnavailable","SamplingDimension is only supported when SamplingPattern->Matrix:"},
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				SamplingPattern->Ring,
				SamplingDimension->4
			],
			$Failed,
			Messages:>{Error::SamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedInstrumentSamplingPattern","The Omega can't sample wells using a Matrix pattern:"},
			ExperimentLuminescenceIntensity[Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedInstrumentSamplingPattern,Error::InvalidOption}
		],
		Test["Resolves the destination wells based on the read order and the moat size:",
			options=ExperimentLuminescenceIntensity[
				{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 2 for ExperimentLuminescenceIntensity "<>$SessionUUID],Object[Sample,"Test sample 3 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				ReadDirection->Column,
				MoatSize->1,
				Aliquot->True,
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"B2","C2","D2"},
			Variables:>{options}
		],
		Test["Handles the case where an explicit wavelength is provided and monochromators are being used:",
			ExperimentLuminescenceIntensity[{Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				WavelengthSelection -> Monochromators,
				EmissionWavelength -> 520 Nanometer
			],
			ObjectP[Object[Protocol]]
		],
		Test["Set a different gain to use with each emission wavelength:",
			Download[
				ExperimentLuminescenceIntensity[Object[Container,Plate,"Test plate 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					AdjustmentSample->Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
					EmissionWavelength->{460 Nanometer,590 Nanometer},
					Gain->{2000 Microvolt,25 Percent}
				],
				{Gains,GainPercentages}
			],
			{
				{2000 Microvolt,Null},
				{Null,25 Percent}
			},
			EquivalenceFunction->Equal
		],
		Test["Throws a single error if an unsupported plate reader is supplied:",
			ExperimentLuminescenceIntensity[
				Object[Sample,"Test sample 1 for ExperimentLuminescenceIntensity "<>$SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages:>{
				Error::ModeUnavailable,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentLuminescenceIntensity[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentLuminescenceIntensity[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentLuminescenceIntensity[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentLuminescenceIntensity[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentLuminescenceIntensity[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Warning::SinglePlateRequired}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentLuminescenceIntensity[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Warning::SinglePlateRequired}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,plate3,plate4,plate5,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		incompatibleChemicalModel,numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples,idModel1,
		targetConcentrationSample},
		
		ClearDownload[]; ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		
		liBackUpCleanup[];

		$CreatedObjects={};

		platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],DeveloperObject->True, Site ->Link[$Site]|>;
		vesselPacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],DeveloperObject->True,Site ->Link[$Site]|>;
		bottlePacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"250mL Glass Bottle"],Objects],DeveloperObject->True,Site ->Link[$Site]|>;

		incompatibleChemicalPacket=<|Type->Model[Sample],DeveloperObject->True,Replace[IncompatibleMaterials]->{PTFE},DeveloperObject->True,DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]]|>;

		{plate1,plate2,plate3,plate4,plate5,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,incompatibleChemicalModel}=Upload[
			Join[
				Append[platePacket,Name->"Test plate "<>ToString[#]<>" for ExperimentLuminescenceIntensity "<>$SessionUUID]&/@Range[5],
				{Append[platePacket,Name->"Empty plate for ExperimentLuminescenceIntensity "<>$SessionUUID]},
				Append[vesselPacket,Name->"Test vessel "<>ToString[#]<>" for ExperimentLuminescenceIntensity "<>$SessionUUID]&/@Range[5],
				{bottlePacket,incompatibleChemicalPacket}
			]
		];

		numberOfInputSamples=9;
		sampleNames="Test sample "<>ToString[#]<>" for ExperimentLuminescenceIntensity "<>$SessionUUID&/@Range[numberOfInputSamples];

		numberOfInjectionSamples=4;
		injectionSampleNames="Injection test sample "<>ToString[#]<>" for ExperimentLuminescenceIntensity "<>$SessionUUID&/@Range[numberOfInjectionSamples];

		samples=UploadSample[
			Join[
				ConstantArray[Model[Sample,StockSolution,"0.2M FITC"],numberOfInputSamples-3],ConstantArray[Model[Sample, "Test Oligomer for ExperimentFluorescenceIntensity"],3],
				ConstantArray[Model[Sample,StockSolution,"0.2M FITC"],numberOfInjectionSamples-1],{incompatibleChemicalModel},
				{{{1000 * EmeraldCell / Milliliter, Model[Cell, Mammalian, "id:eGakldJvLvzq"]}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}}
			],
			{
				{"A1",plate1},{"A2",plate1},{"A3",plate1},{"A4",plate1},{"A1",plate2},{"A2",plate2},{"A1",bottle1},{"A1",vessel5},{"A1",plate3},
				{"A1",vessel1},{"A1",vessel2},{"A1",vessel3},{"A1",vessel4},{"A1",plate5}
			},
			Name->Join[sampleNames,injectionSampleNames,{"Test sample with mammalian cells for ExperimentLuminescenceIntensity "<>$SessionUUID}],
			InitialAmount->Join[
				ConstantArray[250 Microliter,numberOfInputSamples-3],{200 Milliliter, 2 Milliliter, 250 Microliter},
				ConstantArray[15 Milliliter,numberOfInjectionSamples],{200 Microliter}
			],
			State->Liquid,
			Living->False
		];

		(* Upload Test oligomer ID Model and Object[Sample] for the TargetConcentration test *)
		idModel1=Upload[
			<|
				Type->Model[Molecule,Oligomer],
				Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
				PolymerType-> DNA,
				Name-> "Test 40mer DNA Model Molecule for ExperimentLuminescenceIntensity "<>$SessionUUID,
				MolecularWeight->12295.9*(Gram/Mole),
				DeveloperObject->True
			|>
		];

		{targetConcentrationSample}=UploadSample[
			{
				{
					{20*Micromolar,Link[Model[Molecule, Oligomer, "Test 40mer DNA Model Molecule for ExperimentLuminescenceIntensity "<>$SessionUUID]]},
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
				"Test 40mer DNA oligomer for ExperimentLuminescenceIntensity "<>$SessionUUID
			}
		];

		Upload[
			Join[
				<|Object->#,DeveloperObject->True|>&/@Join[samples,{idModel1,targetConcentrationSample}],
				{
					<|Object->Object[Sample,"Test sample 7 for ExperimentLuminescenceIntensity "<>$SessionUUID],Concentration->10 Millimolar|>,
					<|Object->Object[Sample,"Test sample 9 for ExperimentLuminescenceIntensity "<>$SessionUUID],Model->Null|>,
					<|Type->Object[Protocol, LuminescenceIntensity],Name->"Existing LI Protocol "<>$SessionUUID|>,
					<|
						Type -> Object[Instrument, PlateReader],
						Model -> Link[Model[Instrument,PlateReader,"FLUOstar Omega"], Objects],
						Status -> Available,
						DeveloperObject -> True,
						Site->Link[$Site],
						Name -> "Test Omega for ExperimentLuminescenceIntensity "<>$SessionUUID
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
		liBackUpCleanup[];
	)
];

DefineTests[LuminescenceIntensity,
	{
		Example[{Basic, "Generate a RoboticSamplePreparation protocol object based on a single unit operation with Preparation->Robotic:"},
			ExperimentSamplePreparation[{
				LuminescenceIntensity[
					Sample->Object[Sample,"Test sample 1 for LuminescenceIntensity "<>$SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Example[{Basic, "Generate an LuminescenceIntensity protocol object based on a single unit operation with Preparation->Manual:"},
			ExperimentSamplePreparation[{
				LuminescenceIntensity[
					Sample -> Object[Sample,"Test sample 1 for LuminescenceIntensity "<>$SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Basic, "Generate a RoboticSamplePreparation protocol object based on a single unit operation with injection options specified:"},
			ExperimentSamplePreparation[{
				LuminescenceIntensity[
					Sample->Object[Sample,"Test sample 1 for LuminescenceIntensity "<>$SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for LuminescenceIntensity "<>$SessionUUID],
					PrimaryInjectionVolume->4 Microliter
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Example[{Basic, "Generate a RoboticSamplePreparation protocol object based on a unit operation with multiple samples and Preparation->Robotic:"},
			ExperimentSamplePreparation[{
				LuminescenceIntensity[
					Sample-> {
						Object[Sample,"Test sample 1 for LuminescenceIntensity "<>$SessionUUID],
						Object[Sample,"Test sample 2 for LuminescenceIntensity "<>$SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,plate1,plate2,vessel1,numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},

		ClearDownload[]; ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		liBackUpCleanup[];

		$CreatedObjects={};

		platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
		vesselPacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>;

		{plate1,plate2,vessel1}=Upload[
			Join[
				Append[platePacket,Name->"Test plate "<>ToString[#]<>" for LuminescenceIntensity "<>$SessionUUID]&/@Range[2],
				Append[vesselPacket,Name->"Test vessel "<>ToString[#]<>" for LuminescenceIntensity "<>$SessionUUID]&/@Range[1]
			]
		];

		numberOfInputSamples=2;
		sampleNames="Test sample "<>ToString[#]<>" for LuminescenceIntensity "<>$SessionUUID&/@Range[numberOfInputSamples];

		numberOfInjectionSamples=1;
		injectionSampleNames="Injection test sample "<>ToString[#]<>" for LuminescenceIntensity "<>$SessionUUID&/@Range[numberOfInjectionSamples];

		samples=UploadSample[
			Join[
				ConstantArray[Model[Sample,StockSolution,"0.2M FITC"],3]
			],
			{
				{"A1",plate1},{"A2",plate1},{"A1",vessel1}
			},
			Name->Join[sampleNames,injectionSampleNames],
			InitialAmount->Join[
				ConstantArray[250 Microliter,2],
				ConstantArray[15 Milliliter,1]
			],
			State->Liquid
		];
	],
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		liBackUpCleanup[];
	)
];

liBackUpCleanup[]:=Module[{namedObjects,lurkers},
	namedObjects={
		Object[Sample,"Test sample 1 for LuminescenceIntensity "<>$SessionUUID],
		Object[Sample,"Test sample 2 for LuminescenceIntensity "<>$SessionUUID],
		Object[Sample,"Injection test sample 1 for LuminescenceIntensity "<>$SessionUUID]
	};
	lurkers=PickList[namedObjects,DatabaseMemberQ[namedObjects],True];
	EraseObject[lurkers,Force->True,Verbose->False]
];
