(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureViscosity : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureViscosity*)


(* ::Subsubsection:: *)
(*ExperimentMeasureViscosity*)


DefineTests[
	ExperimentMeasureViscosity,
	{
		(*Positive cases and examples*)
		Example[{Basic,"Measure the viscosity of a single sample:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureViscosity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Measure the viscosity of two samples:"},
			ExperimentMeasureViscosity[{Object[Sample,"Test water sample in a plate 1 for ExperimentMeasureViscosity"<>$SessionUUID],Object[Sample,"Test water sample in a plate 2 for ExperimentMeasureViscosity"<>$SessionUUID]}],
			ObjectP[Object[Protocol,MeasureViscosity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Measure the viscosity of samples in the specified input container:"},
			ExperimentMeasureViscosity[Object[Container,Plate,"Test container plate 2 for ExperimentMeasureViscosity"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureViscosity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		(*Unit Test for Model-Less Object*)
		Example[{Basic,"Measure the viscosity of a single sample when the Object[Sample] does not have a Model:"},
			ExperimentMeasureViscosity[Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureViscosity"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureViscosity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		(* Messages *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureViscosity[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureViscosity[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureViscosity[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureViscosity[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentMeasureViscosity[Object[Sample,"Test discarded sample for ExperimentMeasureViscosity"<>$SessionUUID]],
			$Failed,
			Messages :> {Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"TooManyViscosityInputs","If the ViscometerChip specified is Model[Part, ViscometerChip, \"Rheosense VROC B05 Viscometer Chip\"] and the number of samples is greater than 72, an error is thrown:"},
			ExperimentMeasureViscosity[Table[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],73],ViscometerChip->Model[Part, ViscometerChip, "id:6V0npvmZXEAa"]],
			$Failed,
			Messages :> {Error::TooManyViscosityInputs,Error::InvalidInput}
		],
		Example[{Messages,"TooManyViscosityInputs","If the ViscometerChip specified is Model[Part, ViscometerChip, \"Rheosense VROC C05 Viscometer Chip\"] and the number of samples is greater than 48, an error is thrown:"},
			ExperimentMeasureViscosity[Table[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],49],ViscometerChip->Model[Part, ViscometerChip, "id:pZx9jo8LKz04"]],
			$Failed,
			Messages :> {Error::TooManyViscosityInputs,Error::InvalidInput}
		],
		Example[{Messages,"TooManyViscosityInputs","If the AssayType is LowViscosity, no ViscometerChip is specified, and the number of samples is greater than 72, an error is thrown:"},
			ExperimentMeasureViscosity[Table[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],73],AssayType->LowViscosity],
			$Failed,
			Messages :> {Error::TooManyViscosityInputs,Error::InvalidInput}
		],
		Example[{Messages,"TooManyViscosityInputs","If the AssayType is not LowViscosity, no ViscometerChip is specified, and the number of samples is greater than 48, an error is thrown:"},
			ExperimentMeasureViscosity[Table[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],49],AssayType->HighViscosity],
			$Failed,
			Messages :> {Error::TooManyViscosityInputs,Error::InvalidInput}
		],
		Example[{Messages,"ViscositySolidSampleUnsupported","Solid sample inputs return an error:"},
			ExperimentMeasureViscosity[Object[Sample,"Test Solid Sample for ExperimentMeasureViscosity"<>$SessionUUID]],
			$Failed,
			Messages :> {Error::ViscositySolidSampleUnsupported,Error::ViscosityNoVolume,Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		Example[{Messages,"ContainerlessSamples","Error if input samples are not in a container:"},
			ExperimentMeasureViscosity[containerlessSample],
			$Failed,
			Messages:>{Error::ContainerlessSamples,Error::InvalidInput},
			SetUp:>(
				$CreatedObjects = {};
				containerlessSample = Upload[
					Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "Milli-Q water"],Objects],
						Volume -> 100 Microliter
					]
				];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{containerlessSamples}
		],
		Example[{Messages,"ViscosityInsufficientVolume","Return $Failed if Sample contains an insufficient volume for measurements:"},
			ExperimentMeasureViscosity[Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureViscosity"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::ViscosityInsufficientVolume}
		],
		Example[{Messages,"ViscosityNoVolume","Return $Failed if Sample contains Null in the Volume field:"},
			ExperimentMeasureViscosity[Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureViscosity"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput, Error::ViscosityNoVolume}
		],
		Example[{Messages,"ViscosityIncompatibleSample","Return $Failed if Sample contains a component that is chemically incompatible with the viscometer:"},
			ExperimentMeasureViscosity[Object[Sample, "Test incompatible sample for ExperimentMeasureViscosity"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput, Error::ViscosityIncompatibleSample,Error::IncompatibleMaterials}
		],
		(* Conflicting options messages *)
		Example[{Messages,"ViscosityRemeasurementAllowedConflict","Return $Failed if the options for RemeasurementAllowed and RemeasurementReloadVolume conflict:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RemeasurementAllowed->True, RemeasurementReloadVolume->Null],
			$Failed,
			Messages:>{Error::InvalidOption, Error::ViscosityRemeasurementAllowedConflict}
		],
		Example[{Messages,"ViscosityRecoupSampleConflict","Return $Failed if the options for RecoupSample and RecoupSampleContainer conflict:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RecoupSample->True, RecoupSampleContainerSame->Null],
			$Failed,
			Messages:>{Error::InvalidOption, Error::ViscosityRecoupSampleConflict}
		],
		Example[{Messages,"ViscosityInjectionVolumeHigh","Return $Failed if the InjectionVolume exceeds the Sample volume:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample 30 uL for aliquot testing"<>$SessionUUID],
				InjectionVolume -> 90 Microliter],
			$Failed,
			Messages:>{Error::InvalidOption, Error::ViscosityInjectionVolumeHigh}
		],
		Example[{Messages,"ViscosityUnsupportedInjectionVolume","Return $Failed if InjectionVolume is specified as 26 uL but the sample is not in an autosampler vial and needs to be aliquoted, but there is not enough sample for aliquoting with a 10 uL dead Volume:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample 30 uL for aliquot testing"<>$SessionUUID],
				InjectionVolume -> 26 Microliter],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityUnsupportedInjectionVolume,Warning::AliquotRequired,Warning::TotalAliquotVolumeTooLarge}
		],
		Example[{Messages,"ViscosityPrimingFalse","Throw a Warning if Priming is set to False:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Priming->False,Output->Options];
				Lookup[options,Priming],
			False,
			Messages:>{Warning::ViscosityPrimingFalse},
			Variables:>{options}
		],
		Example[{Messages,"ViscosityCustomMeasurementMethodConflicts","Return $Failed if MeasurementMethodTable is specified along with one or more of the following options: MeasurementTemperature,FlowRate, EquilibrationTime,MeasurementTime,PauseTime,NumberOfReaadings:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethodTable -> {
					{25 Celsius, Null, Null, Null, Null, 0 Second, True, 1},
					{25 Celsius, Null, Null,Null, Null, 0 Second, False, 10}
				},
				MeasurementTemperature -> {40 Celsius}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityCustomMeasurementMethodConflicts}
		],
		Example[{Messages,"ViscosityCustomMeasurementTableNotProvided","Throw a warning if MeasurementMethod is specified as Custom but the MeasurementMethodTable is left as Automatic:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethod -> Custom, Output->Options];
				Lookup[options,MeasurementMethod],
				Custom,
			Messages:>{Warning::ViscosityCustomMeasurementTableNotProvided},
			Variables:>{options}
		],
		Example[{Messages,"ViscosityExploratoryTemperatureSweepParameterError","Throw an Error if MeasurementMethod is specified as TemperatureSweep or Optimize but one or more of the following options are specified: MeasurementMethodTable, FlowRate, MeasurementTime,EquilibrationTime, Priming (set as False):"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasurementMethod ->TemperatureSweep, FlowRate-> {100 Microliter/Minute}],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityExploratoryTemperatureSweepParameterError}
		],
		Example[{Messages,"ViscosityFlowRateEquilibrationTimeMeasurementTimeError","Throw an Error if there are mismatches in the values provided for FlowRate,EquilibrationTime, and MeasurementTime:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],FlowRate-> {200 Microliter/Minute,100 Microliter/Minute},EquilibrationTime->{1 Second}],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityFlowRateEquilibrationTimeMeasurementTimeError}
		],
		Example[{Messages,"ViscosityFlowRateSweepParameterError","Throw a warning if MeasurementMethod is specified as FlowRateSweep but the MeasurementMethodTable is specified and/or more than one MeasurementTemperature is specified:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasurementMethod ->FlowRateSweep, MeasurementTemperature-> {25 Celsius,30 Celsius}],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityFlowRateSweepParameterError}
		],
		Example[{Messages,"ViscosityPressureSweepParameterError","Throw a warning if MeasurementMethod is specified as RelativePressureSweep but the MeasurementMethodTable is specified and/or more than one MeasurementTemperature is specified:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasurementMethod ->RelativePressureSweep, EquilibrationTime-> {10 Second}],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityPressureSweepParameterError}
		],
		Example[{Messages,"ViscosityTemperatureSweepInsufficientInput","Throw an Error if MeasurementMethod is specified as TemperatureSweep but only one MeasurementTemperature is specified:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasurementMethod ->TemperatureSweep, MeasurementTemperature-> {30 Celsius}],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityTemperatureSweepInsufficientInput}
		],
		Example[{Messages,"ViscosityFlowRateSweepInsufficientInput","Throw a Warning if MeasurementMethod is specified as FlowRateSweep but only one FlowRate is specified:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasurementMethod ->FlowRateSweep, FlowRate-> {50 Microliter/Minute},Output->Options];
			Lookup[options,FlowRate],
			{50 Microliter/Minute},
			Messages:>{Warning::ViscosityFlowRateSweepInsufficientInput},
			Variables:>{options}
		],
		Example[{Messages,"ViscosityInvalidFlowRateMeasurementTable","Throw an Error if the provided MeasurementMethodTable contains entries where both FlowRate and RelativePressure are specified in the same measurement step:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethodTable ->{
					{25 Celsius, Null, 90 Percent, Null, Null, 0 Second, True, 6},
					{25 Celsius,Null, 50 Percent, Null, Null, 0 Second, False, 10},
					{25 Celsius, 200 Microliter/Minute, 75 Percent, Null, Null, 0 Second, False, 10}
				}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityInvalidFlowRateMeasurementTable}
		],
		Example[{Messages,"ViscosityInvalidPrimeMeasurementTable","Throw an Error if the provided MeasurementMethodTable contains measurements at a specified RelativePressure, but a priming step at 90% RelativePressure repeated 6 times is not provided (as required by the instrument to conduct measurements at RelativePressures):"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethodTable ->{
					{25 Celsius, Null, Null, Null, Null, 0 Second, True, 6},
					{25 Celsius,Null, 50 Percent, Null, Null, 0 Second, False, 10},
					{25 Celsius, Null, 75 Percent, Null, Null, 0 Second, False, 10}
				}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityInvalidPrimeMeasurementTable}
		],
		Example[{Messages,"ViscosityPressureMeasurementTimeConflict","Throw a Warning if the specified MeasurementMethodTable contains entries where RelativePressure and EquilibrationTIme and/or MeasurementTime are specified:"},
		options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
			MeasurementMethodTable ->{
				{25 Celsius, Null, 90 Percent, Null, Null, 0 Second, True, 6},
				{25 Celsius,Null, 50 Percent, Null, Null, 0 Second, False, 10},
				{25 Celsius, Null, 75 Percent, 1 Second, Null, 0 Second, False, 10}
			},
			Output->Options];
			Lookup[options,MeasurementMethodTable],
			{
				{25 Celsius, Null, 90 Percent, Null, Null, 0 Second, True, 6},
				{25 Celsius,Null, 50 Percent, Null, Null, 0 Second, False, 10},
				{25 Celsius, Null, 75 Percent, 1 Second, Null, 0 Second, False, 10}
			},
			Messages:>{Warning::ViscosityPressureMeasurementTimeConflict},
			Variables:>{options}
		],
		Example[{Messages,"ViscosityRemeasurementReloadVolumeHigh","Throw an Error if the RemeasurementReloadVolume is greater than the InjectionVolume:"},
			ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],InjectionVolume -> 35 Microliter, RemeasurementReloadVolume-> 50 Microliter],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityRemeasurementReloadVolumeHigh}
		],
		Example[{Messages,"ViscosityNotEnoughSampleInjected","Throw a warning if RemeasurementAllowed is set to False and there is not enough InjectionVolume to run all the measurement steps:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				InjectionVolume -> 90 Microliter,RemeasurementAllowed-> False,MeasurementTemperature->{25 Celsius, 30 Celsius,40 Celsius},NumberOfReadings->6,Output->Options];
				Lookup[options,InjectionVolume],
				90 Microliter,
			Messages:>{Warning::ViscosityNotEnoughSampleInjected},
			Variables:>{options}
		],
		
		Example[{Messages,"ViscosityTooManyRecoupContainers","Throw an Error if the total number of sample containers and the recoup sample containers is greater than allowed by the instrument:"},
			ExperimentMeasureViscosity[Table[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],49],
				RecoupSample-> Table[True,49],RecoupSampleContainerSame->Table[False,49]],
				$Failed,
			Messages:>{Error::InvalidOption,Error::ViscosityTooManyRecoupContainers}
		],
		
		(*Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentMeasureViscosity[Link[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Now]],
			ObjectP[Object[Protocol,MeasureViscosity]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],*)
		(* Options specific to ExperimentMeasureVisocsity*)
		Example[{Options,Instrument,"Specify the instrument to measure viscosity:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Instrument->Model[Instrument,Viscometer,"Rheosense VROC Initium"], Output->Options];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument,Viscometer,"Rheosense VROC Initium"]],
			Variables:>{options}
		],
		Example[{Options,AssayType,"Specify the AssayType of the measurement:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				AssayType->HighShearRate, Output->Options];
			Lookup[options,AssayType],
			HighShearRate,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"Specify the NumberOfReplicates (new injections for each sample):"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				NumberOfReplicates->2, Output->Options];
			Lookup[options,NumberOfReplicates],
			2,
			Variables:>{options}
		],
		Example[{Options,ResidualIncubation,"Turn off the temperature controller at the end of the measurements:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				ResidualIncubation->False, Output->Options];
			Lookup[options,ResidualIncubation],
			False,
			Variables:>{options}
		],
		Example[{Options,SampleTemperature,"Specify the SampleTemperature to hold samples at while enqueued for measurement:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				SampleTemperature->28 Celsius, Output->Options];
			Lookup[options,SampleTemperature],
			28 Celsius,
			Variables:>{options}
		],
		Example[{Options,ViscometerChip,"Specify a specific viscometer chip to use during measurements:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				ViscometerChip->Model[Part,ViscometerChip,"id:pZx9jo8LKz04"], Output->Options];
			Lookup[options,ViscometerChip],
			ObjectP[Model[Part,ViscometerChip,"id:pZx9jo8LKz04"]],
			Variables:>{options}
		],
		Example[{Options,InjectionVolume,"Specify the InjectionVolume of the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				InjectionVolume->50 Microliter,Output->Options];
			Lookup[options,InjectionVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[{Options,AutosamplerPrePressurization,"Specify whether the autosampler should inject air to pressurize the dead space of the sample vial to decrease air bubble formation during sample uptake:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				AutosamplerPrePressurization->True,Output->Options];
			Lookup[options,AutosamplerPrePressurization],
			True,
			Variables:>{options}
		],
		Example[{Options,TemperatureStabilityMargin,"Specify the TemperatureStabilityMargin of the run:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				TemperatureStabilityMargin->0.5 Celsius,Output->Options];
			Lookup[options,TemperatureStabilityMargin],
			0.5 Celsius,
			Variables:>{options}
		],
		Example[{Options,TemperatureStabilityTime,"Specify the TemperatureStabilityTime of the run:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				TemperatureStabilityTime->1 Minute,Output->Options];
			Lookup[options,TemperatureStabilityTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,MeasurementTemperature,"Specify the MeasurementTemperature of a sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementTemperature->{30 Celsius},Output->Options];
			Lookup[options,MeasurementTemperature],
			{30 Celsius},
			Variables:>{options}
		],
		Example[{Options,MeasurementMethodTable,"Specify the MeasurementMethodTable for the sample's measurement:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethodTable -> {
					{25 Celsius, Null, Null,Null, Null, 0 Second, True, 1},
					{25 Celsius, Null,Null,Null, Null, 0 Second, False, 10}
				},
				Output->Options
			];
			Lookup[options,MeasurementMethodTable],
			{
				{25 Celsius, Null, Null, Null, Null, 0 Second, True, 1},
				{25 Celsius, Null, Null, Null, Null, 0 Second, False, 10}
			},
			Variables:>{options}
		],
		Example[{Options,PrimaryBuffer,"Specify the PrimaryBuffer to use to flush the instrument between sample measurements:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				PrimaryBuffer->Model[Sample, "Milli-Q water"], Output->Options];
			Lookup[options,PrimaryBuffer],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,MeasurementMethod,"Specify the MeasurementMethod used to measure the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementMethod->TemperatureSweep, Output->Options];
			Lookup[options,MeasurementMethod],
			TemperatureSweep,
			Variables:>{options}
		],
		Example[{Options,MeasurementTemperature,"Specify the MeasurementTemperature used to measure the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementTemperature->{25 Celsius,30 Celsius}, Output->Options];
			Lookup[options,MeasurementTemperature],
			{25 Celsius,30 Celsius},
			Variables:>{options}
		],
		Example[{Options,FlowRate,"Specify the FlowRate used to measure the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				FlowRate->{50 Microliter/Minute,100 Microliter/Minute}, Output->Options];
			Lookup[options,FlowRate],
			{50 Microliter/Minute, 100 Microliter/Minute},
			Variables:>{options}
		],
		Example[{Options,RelativePressure,"Specify the RelativePressures used to measure the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RelativePressure->{10 Percent, 25 Percent, 50 Percent,75 Percent, 90 Percent}, Output->Options];
			Lookup[options,RelativePressure],
			{10 Percent, 25 Percent, 50 Percent,75 Percent, 90 Percent},
			Variables:>{options}
		],
		Example[{Options,Priming,"Specify whether a Priming step will be used to wet the measurement chip:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Priming->True, Output->Options];
			Lookup[options,Priming],
			True,
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"Specify the EquilibrationTime, the time during which the instrument does not actively collect measurements for the final viscosity calculations:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				EquilibrationTime->{5 Second}, Output->Options];
			Lookup[options,EquilibrationTime],
			{5 Second},
			Variables:>{options}
		],
		Example[{Options,MeasurementTime,"Specify the MeasurementTime, the time during which the instrument actively collects measurements for the final viscosity calculations:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				MeasurementTime -> {10 Second}, Output->Options];
			Lookup[options,MeasurementTime],
			{10 Second},
			Variables:>{options}
		],
		Example[{Options,PauseTime,"Specify the PauseTime, the time between each measurement step:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				PauseTime -> 1 Second, Output->Options];
			Lookup[options,PauseTime],
			1 Second,
			Variables:>{options}
		],
		Example[{Options,NumberOfReadings,"Specify the NumberOfReadings for each unique measurement step:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				NumberOfReadings -> 4, Output->Options];
			Lookup[options,NumberOfReadings],
			4,
			Variables:>{options}
		],
		Example[{Options,RemeasurementAllowed,"Specify the whether the sample can be recycled to allow for additional measurements:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RemeasurementAllowed-> True,Output->Options];
			Lookup[options,RemeasurementAllowed],
			True,
			Variables:>{options}
		],
		Example[{Options,RemeasurementReloadVolume,"Specify the volume of sample to reload for additional measurements:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RemeasurementAllowed-> True,RemeasurementReloadVolume->20 Microliter,Output->Options];
			Lookup[options,RemeasurementAllowed],
			True,
			Variables:>{options}
		],
		Example[{Options,RecoupSample,"Specify whether the sample will be recovered at the conclusion of all measurement steps:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RecoupSample -> False, Output->Options];
			Lookup[options,RecoupSample],
			False,
			Variables:>{options}
		],
		Example[{Options,RecoupSampleContainerSame,"Specify whether the container in which the recovered sample will be transferred to is the same as the original sample container:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				RecoupSample->True, RecoupSampleContainerSame ->True, Output->Options];
			Lookup[options,RecoupSampleContainerSame],
			True,
			Variables:>{options}
		],
		Example[{Options,PrimaryBufferStorageCondition,"Specify the storage condition of the Primary Buffer after the experiment run has completed:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				PrimaryBufferStorageCondition->AmbientStorage, Output->Options];
			Lookup[options,PrimaryBufferStorageCondition],
			AmbientStorage,
			Variables:>{options}
		],
		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasureViscosity[
				{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],
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
				{ObjectP[Model[Sample,"Milli-Q water"]]..},
				{ObjectP[Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasureViscosity[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, MeasureViscosity]]
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentMeasureViscosity:"},
				options=ExperimentMeasureViscosity["My Container for Viscosity Measurements",
					PreparatoryUnitOperations -> {
						LabelContainer[
							Label -> "My Container for Viscosity Measurements",
							Container -> Model[Container, Plate, "96-well PCR Plate"]
						],
						Transfer[
							Source -> Model[Sample, "Milli-Q water"],
							Amount -> 150 Microliter,
							Destination -> {"A2", "My Container for Viscosity Measurements"}
						]
					},
					Output->Options
				];
				Lookup[options,InjectionVolume],
				90`Microliter,
				Variables :> {options}
			],
		(*incubate options*)
    Example[{Options,Incubate,"Measure the viscosity of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Incubate->True,Output->Options];
      Lookup[options,Incubate],
      True,
      Variables:>{options}
    ],
    Example[{Options,IncubationTime,"Measure the viscosity of a single liquid sample with Incubation before measurement for 10 minutes:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
      Lookup[options,IncubationTime],
      10 Minute,
      Variables:>{options}
    ],
    Example[{Options,MaxIncubationTime,"Measure the viscosity of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
      Lookup[options,MaxIncubationTime],
      1 Hour,
      Variables:>{options}
    ],
    Example[{Options,IncubationTemperature,"Measure the viscosity of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature -> 30 Celsius,Output->Options];
      Lookup[options,IncubationTemperature],
      30 Celsius,
      Variables:>{options}
    ],
    Example[{Options,IncubationInstrument,"Measure the viscosity of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
      Lookup[options,IncubationInstrument],
      ObjectReferenceP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],IncubateAliquot->100 Microliter,IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],Output->Options];
      Lookup[options,IncubateAliquot],
      100 Microliter,
			EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],IncubateAliquot->90 Microliter,IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],Output->Options];
      Lookup[options,IncubateAliquotContainer],
			{1, ObjectReferenceP[Model[Container,Plate,"96-well PCR Plate"]]},
      Variables:>{options}
    ],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectReferenceP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeAliquot -> 100*Microliter,CentrifugeAliquotContainer -> Model[Container,Plate,"96-well PCR Plate"],Output -> Options];
			Lookup[options, CentrifugeAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeAliquot -> 100*Microliter,CentrifugeAliquotContainer -> Model[Container, Plate, "96-well PCR Plate"],Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well PCR Plate"]]},
			Variables :> {options}
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FiltrationType -> Syringe, FilterContainerOut -> Model[Container, Plate, "96-well PCR Plate"], Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], Filter -> Model[Container, Plate, Filter, "id:eGakld0955Lo"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Container, Plate, Filter, "id:eGakld0955Lo"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID],PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID], PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			SetUp :> (
				Upload[
					<|
						Object->Object[Sample,"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID],
						Volume->1.5Liter
					|>
				];
			),
			TearDown :> (
				Upload[
					<|
						Object->Object[Sample,"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID],
						Volume->50Milliliter
					|>
				];
			)
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],FilterAliquot -> 90 Microliter,FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],FilterAliquot -> 90 Microliter,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],FilterAliquot -> 90 Microliter,FiltrationType -> Centrifuge, FilterTemperature -> 22*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],FilterSterile -> False, Output -> Options];
			Lookup[options, FilterSterile],
			False,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],FilterAliquot -> 95*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			95*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterAliquotContainer -> Model[Container,Vessel,"2mL Tube"], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"],Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterContainerOut -> Model[Container,Plate,"96-well PCR Plate"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container,Plate,"96-well PCR Plate"]]},
			Variables :> {options}
		],

		(*Aliquot options*)
		Example[{Options,Aliquot,"Measure the viscosity of a single liquid sample by first aliquotting the sample:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], AliquotAmount -> 95*Microliter,AliquotContainer -> Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"], Output -> Options];
			Lookup[options, AliquotAmount],
			95*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], AssayVolume -> 95*Microliter, Output -> Options];
			Lookup[options, AssayVolume],
			95*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test Sample for ExperimentMeasureViscosity with concentration"<>$SessionUUID], TargetConcentration -> 5*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test Sample for ExperimentMeasureViscosity with concentration"<>$SessionUUID], TargetConcentration -> 5*Micromolar,TargetConcentrationAnalyte -> Model[Molecule,"Uracil"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Uracil"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->50*Microliter,AssayVolume->200*Microliter,AliquotContainer -> Model[Container, Plate, "96-well PCR Plate"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], BufferDilutionFactor -> 2, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->200*Microliter,AliquotContainer -> Model[Container, Plate, "96-well PCR Plate"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			2,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 2, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->200*Microliter,AliquotContainer -> Model[Container,Plate,"96-well PCR Plate"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->200*Microliter,AliquotContainer->Model[Container,Plate,"96-well PCR Plate"],Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], AliquotContainer ->Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectReferenceP[Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"]]}},
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition, "Indicates how any recouped samples from the experiment should be stored:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],IncubateAliquotContainer->Model[Container,Plate,"96-well PCR Plate"], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], CentrifugeAliquotDestinationWell -> "A1", CentrifugeAliquotContainer->Model[Container,Plate,"96-well PCR Plate"],Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], FilterAliquotDestinationWell -> "A1", FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"], FilterContainerOut->Model[Container,Plate,"96-well PCR Plate"], Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options,Name, "Specify the name of a protocol:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], Name -> "My Exploratory Viscosity Test Protocol", Output -> Options];
			Lookup[options,Name],
			"My Exploratory Viscosity Test Protocol",
			Variables:>{options}
		],
		Example[{Options,Template, "Inherit options from a previously run protocol:"},
			options = ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], Template -> Object[Protocol, MeasureViscosity, "Viscosity Test Template Protocol for ExperimentMeasureViscosity"<>$SessionUUID], Output -> Options];
			Lookup[options,FlowRate],
			{500 Microliter/Minute,250 Microliter/Minute,100 Microliter/Minute,50 Microliter/Minute},
			Variables:>{options}
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentMeasureViscosity[Object[Sample,"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output -> Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->240
		]
	},
	Stubs:>{
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Plate, "Test container plate 1 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container plate 2 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container plate 3 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container plate 4 with no sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Vessel, "Test container 5 autosampler with insert for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Vessel, "Test container 6 that does not fit on the instrument for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container 7 with incompatible sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container 8 for No Volume sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container 9 for MilliQ water for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Vessel, "Test container 10 for solution without a model for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Plate, "Test container 11 for 30 uL of MilliQ water for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test discarded sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test water sample in a plate 1 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test water sample in a plate 2 for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test sample with no volume for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test water sample in autosampler vial for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test incompatible sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Sample, "Test MilliQ water sample 30 uL for aliquot testing"<>$SessionUUID],
				Object[Sample, "Test Sample for ExperimentMeasureViscosity with concentration"<>$SessionUUID],
				Object[Sample, "Test Solid Sample for ExperimentMeasureViscosity"<>$SessionUUID],
				Model[Sample, "Test chemical model incompatible for ExperimentMeasureViscosity"<>$SessionUUID],
				Model[Instrument, Viscometer, "Test Viscometer model instrument for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Instrument, Viscometer, "Test Viscometer Object for ExperimentMeasureViscosity"<>$SessionUUID],
				Object[Protocol, MeasureViscosity, "Viscosity Test Template Protocol for ExperimentMeasureViscosity"<>$SessionUUID]
			};
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter = DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		];

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{modelIncompat,instModel, emptyPlate1,emptyPlate2,emptyPlate3,emptyPlate4,emptyContainer5,emptyContainer6,
			emptyPlate7,emptyPlate8,emptyPlate9,emptyPlate10,emptyPlate11,discardedChemical,waterSamplePlate,waterSamplePlate2,volTooLow,waterSample4,autoSamp,
			incompatContainer,incompatSample,volNull,milliQWater,waterNoModel,waterForAliquot,container12,redDye,container13,solidSample},

			(*Create some chemicals incompatible with the instrument as well as the instrument model*)
			{modelIncompat, instModel} = Upload[{
				<|
					Type -> Model[Sample],
					Name -> "Test chemical model incompatible for ExperimentMeasureViscosity"<>$SessionUUID,
					State -> Liquid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Append[IncompatibleMaterials] -> Glass,
					DeveloperObject -> True
				|>,

				(*Create viscometer model with a unique material for measurement*)
				<|
					Type -> Model[Instrument, Viscometer],
					Name -> "Test Viscometer model instrument for ExperimentMeasureViscosity"<>$SessionUUID,
					MinSampleVolume -> 26 Microliter,
					Deprecated -> False,
					Append[WettedMaterials] -> {Glass},
					DeveloperObject->True
				|>
			}];

			(*Create a viscometer object from the new models*)
			Upload[{
				<|
					Type -> Object[Instrument, Viscometer],
					Model -> Link[Model[Instrument,Viscometer,"Test Viscometer model instrument for ExperimentMeasureViscosity"<>$SessionUUID], Objects],
					Name -> "Test Viscometer Object for ExperimentMeasureViscosity"<>$SessionUUID,
					Status -> Available,
					Site->Link[$Site]
				|>
			}];

		(* Create some empty containers *)
		{emptyPlate1,emptyPlate2,emptyPlate3,emptyPlate4,emptyContainer5,emptyContainer6,
			emptyPlate7,emptyPlate8,emptyPlate9,emptyPlate10,emptyPlate11,container12,container13}=Upload[{
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container plate 1 for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container plate 2 for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container plate 3 for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container plate 4 with no sample for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container, Vessel],
				Model->Link[Model[Container, Vessel, "1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects], (*placeholder for now*)
				Name->"Test container 5 autosampler with insert for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container, Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 6 that does not fit on the instrument for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container 7 with incompatible sample for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container 8 for No Volume sample for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name->"Test container 9 for MilliQ water for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],
				Name->"Test container 10 for solution without a model for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well PCR Plate"],Objects],
				Name-> "Test container 11 for 30 uL of MilliQ water for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],
				Name->"Test container 12 for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],
				Name->"Test container 13 for ExperimentMeasureViscosity"<>$SessionUUID,
				DeveloperObject->True,
				Site->Link[$Site]
			|>
		}];


		(* Create some samples *)
		{
				(*1*)discardedChemical,
				(*2*)waterSamplePlate,
				(*3*)waterSamplePlate2,
				(*4*)volTooLow,
				(*5*)waterSample4,
				(*6*)autoSamp,
				(*7*)incompatContainer,
				(*8*)incompatSample,
				(*9*)volNull,
				(*10*)milliQWater,
				(*11*)waterNoModel,
				(*12*)waterForAliquot,
				(*13*)redDye,
				(*14*)solidSample
		}=ECL`InternalUpload`UploadSample[
			{
				(*1*)Model[Sample,"Milli-Q water"],
				(*2*)Model[Sample,"Milli-Q water"],
				(*3*)Model[Sample,"Milli-Q water"],
				(*4*)Model[Sample,"Milli-Q water"],
				(*5*)Model[Sample,"Milli-Q water"],
				(*6*)Model[Sample,"Milli-Q water"],
				(*7*)Model[Sample,"Milli-Q water"],
				(*8*)modelIncompat,
				(*9*)Model[Sample,"Milli-Q water"],
				(*10*)Model[Sample,"Milli-Q water"],
				(*11*)Model[Sample,"Milli-Q water"],
				(*12*)Model[Sample,"Milli-Q water"],
				(*13*)Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				(*14*)Model[Sample, "Dibasic Sodium Phosphate"]
			},
			{
				(*1*){"A1",emptyPlate1},
				(*2*){"A1",emptyPlate2},
				(*3*){"C5",emptyPlate2},
				(*4*){"A1",emptyPlate3},
				(*5*){"A1",emptyPlate4},
				(*6*){"A1",emptyContainer5},
				(*7*){"A1",emptyContainer6},
				(*8*){"A1",emptyPlate7},
				(*9*){"A1",emptyPlate8},
				(*10*){"A1",emptyPlate9},
				(*11*){"A1",emptyPlate10},
				(*12*){"A1",emptyPlate11},
				(*13*){"A1",container12},
				(*14*){"A1",container13}
			},
			InitialAmount->{
				(*1*)80 Milliliter,
				(*2*)100 Microliter,
				(*3*)104 Microliter,
				(*4*)10 Microliter,
				(*5*)0.1 Microliter,
				(*6*)200 Microliter,
				(*7*) 10 Milliliter,
				(*8*) 80 Microliter,
				(*9*) Null,
				(*10*)100 Microliter,
				(*11*)50 Microliter,
				(*12*)30 Microliter,
				(*13*)100 Microliter,
				(*14*)100 Milligram
			},
			Name->{
				(*1*)"Test discarded sample for ExperimentMeasureViscosity"<>$SessionUUID,
				(*2*)"Test water sample in a plate 1 for ExperimentMeasureViscosity"<>$SessionUUID,
				(*3*)"Test water sample in a plate 2 for ExperimentMeasureViscosity"<>$SessionUUID,
				(*4*)"Test sample with volume too low for measurement ExperimentMeasureViscosity"<>$SessionUUID,
				(*5*)"Test sample with no volume for ExperimentMeasureViscosity"<>$SessionUUID,
				(*6*)"Test water sample in autosampler vial for ExperimentMeasureViscosity"<>$SessionUUID,
				(*7*)"Test water sample for invalid container for ExperimentMeasureViscosity"<>$SessionUUID,
				(*8*)"Test incompatible sample for ExperimentMeasureViscosity"<>$SessionUUID,
				(*9*)"Test water sample with Volume=Null for ExperimentMeasureViscosity"<>$SessionUUID,
				(*10*)"Test MilliQ water sample for ExperimentMeasureViscosity"<>$SessionUUID,
				(*11*)"Test MilliQ water sample for sample without a model for ExperimentMeasureViscosity"<>$SessionUUID,
				(*12*)"Test MilliQ water sample 30 uL for aliquot testing"<>$SessionUUID,
				(*13*)"Test Sample for ExperimentMeasureViscosity with concentration"<>$SessionUUID,
				(*14*)"Test Solid Sample for ExperimentMeasureViscosity"<>$SessionUUID
			}
		];

			(* Make some changes to our samples to make them invalid. *)

		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSamplePlate,Status->Available,DeveloperObject->True|>,
			<|Object->waterSamplePlate2,Status->Available,DeveloperObject->True|>,
			<|Object->volTooLow,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample4,Status->Available,DeveloperObject->True|>,
			<|Object->autoSamp,Status->Available,DeveloperObject->True|>,
			<|Object->incompatContainer,Status->Available,DeveloperObject->True|>,
			<|Object->incompatSample,Status->Available,DeveloperObject->True|>,
			<|Object->volNull,Volume->Null,Status->Available,DeveloperObject->True|>,
			<|Object->milliQWater,Status->Available,DeveloperObject->True|>,
			<|Object->waterNoModel,Status->Available,Model -> Null, DeveloperObject->True|>,
			<|Object->waterForAliquot,Status->Available, DeveloperObject->True|>,
			<|Object->redDye,	Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}}, Status->Available, DeveloperObject->True|>,
			<|Object->solidSample,Status->Available, DeveloperObject->True|>
		}];

			(*Create a protocol that we'll use for template testing*)
			Upload[
				<|
					Type -> Object[Protocol,MeasureViscosity],
					Name->"Viscosity Test Template Protocol for ExperimentMeasureViscosity"<>$SessionUUID,
					DeveloperObject -> True,
					ResolvedOptions->{FlowRate->{500 Microliter/Minute,250 Microliter/Minute,100 Microliter/Minute,50 Microliter/Minute}}
				|>
			];
		]
	),
	SymbolTearDown:>(
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
		Force->True,
		Verbose->False
		];

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Unset[$CreatedObjects];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
