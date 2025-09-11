(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentDynamicFoamAnalysis*)


DefineTests[
	ExperimentDynamicFoamAnalysis,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Run a DynamicFoamAnalysis experiment on a sample:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],
		Example[{Basic,"Run a DynamicFoamAnalysis experiment on multiple samples:"},
			ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},Upload->True],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],
		Example[{Basic,"Run a DynamicFoamAnalysis experiment on samples in the specified input container:"},
			ExperimentDynamicFoamAnalysis[Object[Container,Vessel,"DynamicFoamAnalysis 100mL Bottle Container1"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],

		Example[{Additional,"Specify the input as {Position,Container}:"},
			ExperimentDynamicFoamAnalysis[{"A1",Object[Container, Vessel, "DynamicFoamAnalysis 100mL Bottle Container1"<> $SessionUUID]}],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Additional,"Specify inputs as a mixture of {Position,Container} and sample:"},
			ExperimentDynamicFoamAnalysis[{{"A1",Object[Container, Vessel, "DynamicFoamAnalysis 100mL Bottle Container1"<> $SessionUUID]},Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]}],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Test["Run a DynamicFoamAnalysis experiment on a sample with a severed model:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample5 for no model"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],
		Example[{Basic,"Run a DynamicFoamAnalysis experiment on a model:"},
			ExperimentDynamicFoamAnalysis[Model[Sample,"Milli-Q water"],Upload->True],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],

		(*-- Messages: errors and warnings --*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentDynamicFoamAnalysis[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentDynamicFoamAnalysis[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentDynamicFoamAnalysis[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentDynamicFoamAnalysis[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentDynamicFoamAnalysis[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
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

				ExperimentDynamicFoamAnalysis[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		(*- invalid inputs -*)
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample6 for discarded"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"DynamicFoamAnalysisNoVolume","Return $Failed if Sample contains Null in the Volume field:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample3 for no volume"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DynamicFoamAnalysisNoVolume}
		],
		(*Example[{Messages,"DynamicFoamAnalysisNotLiquid","Return $Failed if the Sample State is not liquid:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample4 for not liquid"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DynamicFoamAnalysisNotLiquid}
		],*)
		(*- conflicting options -*)
		Example[{Messages,"DFAHeightMethodRequiredMismatch","If the DetectionMethod provided does not contain HeightMethod, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{ImagingMethod}],
			$Failed,
			Messages:>{Error::DFAHeightMethodRequiredMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAImagingMethodOnlyMismatch","If the DetectionMethod provided does not contain ImagingMethod but ImagingMethod-specific options are given, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{HeightMethod},StructureIlluminationIntensity->30 Percent],
			$Failed,
			Messages:>{Error::DFAImagingMethodOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAstirLiquidConductivityMismatch","If Stir-specific options are given and LiquidConductivityMethod-specific options are also given, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{HeightMethod,LiquidConductivityMethod},Agitation->Stir],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Test["If Agitation is Stir and LiquidConductivityModule is also given, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Agitation->Stir,LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Test["If StirRate is given and LiquidConductivityModule is also given, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],StirRate->1000 RPM,LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Test["If StirRate is given and DetectionMethod contains LiquidConductivityMethod, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],StirRate->1000 RPM,DetectionMethod->{HeightMethod,LiquidConductivityMethod}],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Test["If StirOscillationPeriod is given and LiquidConductivityModule is also given, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],StirOscillationPeriod->0 Second,LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Test["If StirBlade is given and DetectionMethod contains LiquidConductivityMethod, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],StirBlade->Model[Part,StirBlade,"Test DFA stir blade for ExperimentDynamicFoamAnalysis"<> $SessionUUID],DetectionMethod->{HeightMethod,LiquidConductivityMethod}],
			$Failed,
			Messages:>{Error::DFAstirLiquidConductivityMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFALiquidConductivityOnlyMismatch","If the DetectionMethod provided does not contain LiquidConductivityMethod but LiquidConductivityMethod-specific options are given, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{HeightMethod,ImagingMethod},LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFALiquidConductivityOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAStirOnlyMismatch","If the Agitation is not Stir but Stir-specific options are given, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Agitation->Sparge,StirOscillationPeriod->0 Second],
			$Failed,
			Messages:>{Error::DFAStirOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFASpargeOnlyMismatch","If the Agitation is not Sparge but Sparge-specific options are given, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Agitation->Stir,SpargeGas->Nitrogen],
			$Failed,
			Messages:>{Error::DFASpargeOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAAgitationMethodsMismatch","If options specific to Stir and Sparge are simultaneously selected, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],SpargeGas->Nitrogen,StirOscillationPeriod->0 Second],
			$Failed,
			Messages:>{Error::DFAAgitationMethodsMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAImagingMethodNullMismatch","If the DetectionMethod selected contains ImagingMethod and ImagingMethod-specific options are Null, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{HeightMethod,ImagingMethod},CameraHeight->Null],
			$Failed,
			Messages:>{Error::DFAImagingMethodNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFALiquidConductivityMethodNullMismatch","If the DetectionMethod selected contains LiquidConductivityMethod and LiquidConductivityMethod-specific options are Null, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{HeightMethod,LiquidConductivityMethod},LiquidConductivityModule->Null],
			$Failed,
			Messages:>{Error::DFALiquidConductivityMethodNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFAStirNullMismatch","If the Agitation selected is Stir and Stir-specific options are Null, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Agitation->Stir,StirRate->Null],
			$Failed,
			Messages:>{Error::DFAStirNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DFASpargeNullMismatch","If the Agitation selected is Sparge and Sparge-specific options are Null, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Agitation->Sparge,SpargeGas->Null],
			$Failed,
			Messages:>{Error::DFASpargeNullMismatch,Error::InvalidOption}
		],

		(*Options precision checks*)
		Example[{Options,Temperature,"If the specified Temperature has precision less than 1 Celsius, it will be rounded to the nearest Celsius:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Temperature->28.7 Celsius,Output->Options],Temperature],
			29 Celsius,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,AgitationSamplingFrequency,"If the specified AgitationSamplingFrequency has precision less than 0.1 Hertz, it will be rounded to the nearest 0.1 Hertz:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				AgitationSamplingFrequency->7.88 Hertz,Output->Options],AgitationSamplingFrequency],
			7.9 Hertz,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,DecaySamplingFrequency,"If the specified DecaySamplingFrequency has precision less than 0.1 Hertz, it will be rounded to the nearest 0.1 Hertz:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DecaySamplingFrequency->7.88 Hertz,Output->Options],DecaySamplingFrequency],
			7.9 Hertz,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,CameraHeight,"If the specified CameraHeight has precision less than 1 millimeter, it will be rounded to the nearest millimeter:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				CameraHeight->75.6 Millimeter,Output->Options],CameraHeight],
			76 Millimeter,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,StructureIlluminationIntensity,"If the specified StructureIlluminationIntensity has precision less than 1 percent, it will be rounded to the nearest percent:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StructureIlluminationIntensity->38.7 Percent,Output->Options],StructureIlluminationIntensity],
			39 Percent,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,SampleVolume,"If the specified SampleVolume has precision less than 1 milliliter, it will be rounded to the nearest milliliter:"},
			Lookup[ExperimentDynamicFoamAnalysis[ Object[Sample, "DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],SampleVolume -> 65.3 Milliliter, Output -> Options],SampleVolume],
			65 Milliliter,
			Messages:>{Warning::InstrumentPrecision}
		],
		(*Example[{Options,AgitationSamplingFrequency,"If the specified AgitationSamplingFrequency has precision less than 1 Hertz, it will be rounded to the nearest Hertz:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				AgitationSamplingFrequency->8.000007 Hertz,Output->Options],AgitationSamplingFrequency],
			8. Hertz,
			Messages:>{Warning::InstrumentPrecision}
		],*)
		Example[{Options,SpargeFlowRate,"If the specified SpargeFlowRate has precision less than 1 liter/minute, it will be rounded to the nearest liter/minute:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeFlowRate->0.503 Liter/Minute,Output->Options],SpargeFlowRate],
			0.5 Liter/Minute,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,StirRate,"If the specified StirRate has precision less than 1 RPM, it will be rounded to the nearest RPM:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirRate->504.3 RPM,Output->Options],StirRate],
			504 RPM,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,StirOscillationPeriod,"If the specified StirOscillationPeriod has precision less than 1 second, it will be rounded to the nearest second:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirOscillationPeriod->3.9 Second,Output->Options],StirOscillationPeriod],
			4 Second,
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Options,DecayTime,"If the specified DecayTime has precision less than 1 second, it will be rounded to the nearest selsius:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DecayTime->28.7 Second,Output->Options],DecayTime],
			29 Second,
			Messages:>{Warning::InstrumentPrecision}
		],
		(*Example[{Options,DecaySamplingFrequency,"If the specified DecaySamplingFrequency has precision less than 1 Hertz, it will be rounded to the nearest Hertz:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DecaySamplingFrequency->8.00007 Hertz,Output->Options],DecaySamplingFrequency],
			8. Hertz,
			Messages:>{Warning::InstrumentPrecision}
		],*)
		Example[{Options,HeightIlluminationIntensity,"If the specified HeightIlluminationIntensity has precision less than 1 percent, it will be rounded to the nearest percent:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				HeightIlluminationIntensity->38.7 Percent,Output->Options],HeightIlluminationIntensity],
			39 Percent,
			Messages:>{Warning::InstrumentPrecision}
		],

		(*Errors from MapThread*)
		Example[{Messages,"DFASampleVolumeFoamColumnError","If the sample has a volume requested from SampleVolume and NumberOfReplicates less than the minimum volume required for the foam column, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],SampleVolume->40 Milliliter,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFASampleVolumeFoamColumnError,Error::InvalidOption}
		],
		Test["If the sample has a volume requested from SampleVolume and NumberOfReplicates less than the minimum volume required for the foam column, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],NumberOfReplicates->5,SampleVolume->40 Milliliter,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFASampleVolumeFoamColumnError,Error::InvalidOption}
		],
(*		Example[{Messages,"DFASampleVolumeLowError","If the sample has a volume requested from SampleVolume and NumberOfReplicates larger than is available for the sample, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample8 for low volume"<> $SessionUUID],SampleVolume->50 Milliliter],
			$Failed,
			Messages:>{Error::DFASampleVolumeLowError,Error::InvalidOption}
		],*)
		Test["If the sample has a volume requested from SampleVolume and NumberOfReplicates larger than is available for the sample, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample8 for low volume"<> $SessionUUID],SampleVolume->50 Milliliter],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Messages:>{Warning::InsufficientVolume}
		],
		Test["If the sample has a volume requested from SampleVolume and NumberOfReplicates larger than is available for the sample, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],SampleVolume->50 Milliliter,NumberOfReplicates->6],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Messages:>{Warning::InsufficientVolume}
		],
		Test["If the sample has a volume requested from SampleVolume and NumberOfReplicates larger than is available for the sample, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],SampleVolume->90 Milliliter,NumberOfReplicates->3],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]],
			Messages:>{Warning::InsufficientVolume}
		],
		Test["If options specific to the Liquid Conductivity Method are selected and TemperatureMonitoring is True, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],TemperatureMonitoring->True,DetectionMethod->{HeightMethod,LiquidConductivityMethod}],
			$Failed,
			Messages:>{Error::DFATemperatureMonitoringError,Error::InvalidOption}
		],
		Example[{Messages,"DFATemperatureMonitoringError","If options specific to the Liquid Conductivity Method are selected and TemperatureMonitoring is True, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],TemperatureMonitoring->True,LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFATemperatureMonitoringError,Error::InvalidOption}
		],
		Test["If options specific to the Imaging Method are selected but an Imaging Method-compatible foam column (has a prism) is not, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DetectionMethod->{ImagingMethod,HeightMethod},FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAImagingColumnError,Error::InvalidOption}
		],
		Example[{Messages,"DFAImagingColumnError","If options specific to the Imaging Method are selected but an Imaging Method-compatible foam column (has a prism) is not, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FoamImagingModule->Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAImagingColumnError,Error::InvalidOption}
		],
		Test["If options specific to the Imaging Method are selected but an Imaging Method-compatible foam column (has a prism) is not, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],CameraHeight->100 Millimeter,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAImagingColumnError,Error::InvalidOption}
		],
		Test["If options specific to the Imaging Method are selected but an Imaging Method-compatible foam column (has a prism) is not, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],StructureIlluminationIntensity->70 Percent,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAImagingColumnError,Error::InvalidOption}
		],
		Test["If options specific to the Imaging Method are selected but an Imaging Method-compatible foam column (has a prism) is not, an error will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FieldOfView->140 Millimeter^2,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFAImagingColumnError,Error::InvalidOption}
		],
		Example[{Messages,"DFATemperatureColumnError","If a non-Ambient Temperature is selected for operating the experiment but a temperature-controllable double jacketed column is not, an error will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Temperature->36 Celsius,FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DFATemperatureColumnError,Error::InvalidOption}
		],
		Test["If the AgitationTime selected is <2 second or >1 minute, a warning will be thrown:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AgitationTime->15 Minute],
			_,
			Messages:>{	Warning::DFAAgitationTime}
		],
		Example[{Messages,"DFAAgitationTime","If the AgitationTime selected is <2 second or >1 minute, a warning will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AgitationTime->1 Second],
			_,
			Messages:>{	Warning::DFAAgitationTime}
		],
		Example[{Messages,"DFAAgitationSamplingFrequencyLow","If the AgitationSamplingFrequency is greater than would allow for data sampling to occur more than once in the AgitationTime, a warning will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AgitationSamplingFrequency->1 Hertz,AgitationTime->1 Second],
			_,
			Messages:>{	Warning::DFAAgitationSamplingFrequencyLow,Warning::DFAAgitationTime}
		],
		Example[{Messages,"DFADecayTime","If the DecayTime selected is <5 second, a warning will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DecayTime->3 Second],
			_,
			Messages:>{	Warning::DFADecayTime}
		],
		Example[{Messages,"DFADecaySamplingFrequencyLow","If the DecaySamplingFrequency is greater than would allow for data sampling to occur more than once in the DecayTime, a warning will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],DecaySamplingFrequency->1 Hertz,DecayTime->1 Second],
			_,
			Messages:>{	Warning::DFADecaySamplingFrequencyLow,Warning::DFADecayTime,Warning::DFADecayTime}
		],
		Example[{Messages,"DFANumberOfWashesLow","If the NumberOfWashes is less than 3 and may cause the FoamColumn to be inadequately rinsed between samples, a warning will be thrown:"},
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],NumberOfWashes->1],
			_,
			Messages:>{	Warning::DFANumberOfWashesLow}
		],

		(* Options specific to ExperimentDynamicFoamAnalysis *)
		Example[{Options,Instrument,"Specify the Dynamic Foam Analyzer instrument to perform a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Instrument->Model[Instrument,DynamicFoamAnalyzer,"Test DFA model instrument for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],Instrument],
			ObjectP[Model[Instrument,DynamicFoamAnalyzer,"Test DFA model instrument for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Test["Specify the Dynamic Foam Analyzer instrument object to perform a dynamic foam analysis experiment with:",
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Instrument->Object[Instrument,DynamicFoamAnalyzer,"Test DFA object for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],Instrument],
			ObjectP[Object[Instrument,DynamicFoamAnalyzer,"Test DFA object for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Example[{Options,SampleVolume,"Specify the SampleVolume of the sample that will be run in the dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SampleVolume->65 Milliliter,Output->Options],SampleVolume],
			65 Milliliter
		],
		Example[{Options,NumberOfReplicates,"Specify the NumberOfReplicates of the sample that will be run in the dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],
				NumberOfReplicates->3,SampleVolume->50 Milliliter,Output->Options],NumberOfReplicates],
			3
		],
		Test["If the NumberOfReplicates for the dynamic foam analysis experiment is set, then the batched sample indexes is set accordingly:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],
				NumberOfReplicates->3,SampleVolume->50 Milliliter][BatchedSampleIndexes],
			{1,2,3}
		],
		Test["If the NumberOfReplicates for the dynamic foam analysis experiment is set, then the foam column resource is set accordingly:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],
				NumberOfReplicates->3,SampleVolume->50 Milliliter][FoamColumn],
			{LinkP[Model[Container,FoamColumn]],LinkP[Model[Container,FoamColumn]],LinkP[Model[Container,FoamColumn]]}
		],
		Test["If the NumberOfReplicates for the dynamic foam analysis experiment is set, then the experiment parameters should be expanded to accommodate the total replicates:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],
				NumberOfReplicates->3,SampleVolume->50 Milliliter][Agitation],
			{Stir,Stir,Stir}
		],
		Test["If the NumberOfReplicates for the dynamic foam analysis experiment is set, then the experiment parameters should be expanded to accommodate the total replicates:",
			ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID]},
				NumberOfReplicates->2,SampleVolume->50 Milliliter][Agitation],
			{Stir,Stir,Stir,Stir}
		],
		Test["If the NumberOfReplicates for the dynamic foam analysis experiment is set, then the experiment parameters should be expanded to accommodate the total replicates:",
			ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID]},
				NumberOfReplicates->2,SampleVolume->50 Milliliter,Agitation->{Stir,Sparge}][Agitation],
			{Stir,Stir,Sparge,Sparge}
		],
		Test["Grab the correct sample resource amount, dependent on aliquot amounts:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Aliquot->True,AliquotAmount->5 Milliliter,AssayVolume->55 Milliliter,
				SampleVolume->50 Milliliter,AssayBuffer->Model[Sample,"Milli-Q water"],AliquotSampleStorageCondition->Disposal,NumberOfReplicates->20],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],
		Example[{Options,Temperature,"Specify the temperature that the sample should be kept at during the dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Temperature->36 Celsius,Output->Options],Temperature],
			36 Celsius
		],
		Example[{Options,Agitation,"Specify the form of agitation used to induce foam production during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Sparge,Output->Options],Agitation],
			Sparge
		],
		Example[{Options,AgitationTime,"Specify the amount of time that agitation will be performed to induce foam production during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				AgitationTime->15 Second,Output->Options],AgitationTime],
			15 Second
		],
		Example[{Options,AgitationSamplingFrequency,"Specify the frequency of data sampling during foam production in a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				AgitationSamplingFrequency->15 Hertz,Output->Options],AgitationSamplingFrequency],
			15 Hertz
		],
		Example[{Options,DecayTime,"Specify the amount of time that foam decay will be monitored during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DecayTime->15 Minute,Output->Options],DecayTime],
			15 Minute
		],
		Example[{Options,DecaySamplingFrequency,"Specify the frequency of data sampling during foam decay in a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DecaySamplingFrequency->15 Hertz,Output->Options],DecaySamplingFrequency],
			15 Hertz
		],
		Example[{Options,TemperatureMonitoring,"Specify whether the temperature of the sample will be directly measured by a probe during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Sparge,TemperatureMonitoring->False,Output->Options],TemperatureMonitoring],
			False
		],
		Test["If TemperatureMonitoring is True, then Agitation should resolve to Sparge:",
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				TemperatureMonitoring->True,Output->Options],Agitation],
			Sparge
		],
		Example[{Options,DetectionMethod,"Specify the methods of foam detection that will be used during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],DetectionMethod],
			{HeightMethod,ImagingMethod}
		],
		Example[{Options,FoamColumn,"Specify the foam column that will be used to perform a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],FoamColumn],
			ObjectP[Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Test["Specify the foam column object that will be used to perform a dynamic foam analysis experiment with:",
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamColumn->Object[Container,FoamColumn,"Test foam column object for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],FoamColumn],
			ObjectP[Object[Container,FoamColumn,"Test foam column object for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Test["Specify the foam column object that will be used to perform a dynamic foam analysis experiment with:",
			ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamColumn->Object[Container,FoamColumn,"Test foam column object for ExperimentDynamicFoamAnalysis"<> $SessionUUID]],
			ObjectP[Object[Protocol,DynamicFoamAnalysis]]
		],
		Example[{Options,FoamColumnLoading,"Specify the foam column loading that will be used to perform a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamColumnLoading->Wet,Output->Options],FoamColumnLoading],
			Wet
		],
		Example[{Options,LiquidConductivityModule,"Specify the Liquid Conductivity Module that will be used to perform a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],LiquidConductivityModule],
			ObjectP[Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Example[{Options,FoamImagingModule,"Specify the Foam Imaging Module that will be used to perform a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamImagingModule->Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],FoamImagingModule],
			ObjectP[Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Example[{Options,Wavelength,"Specify the wavelength of light that will be used to illuminate the sample for the Height Method of detection during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Wavelength->469 Nanometer,Output->Options],Wavelength],
			469 Nanometer
		],
		Example[{Options,HeightIlluminationIntensity,"Specify the illumination intensity of the light that will be used to illuminate the sample for the Height Method of detection during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				HeightIlluminationIntensity->60 Percent,Output->Options],HeightIlluminationIntensity],
			60 Percent
		],
		Example[{Options,CameraHeight,"Specify the height of the camera along the foam column, used to record the sample for the Imaging Method of detection during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				CameraHeight->200 Millimeter,Output->Options],CameraHeight],
			200 Millimeter
		],
		Example[{Options,StructureIlluminationIntensity,"Specify the illumination intensity of the light that will be used to illuminate the sample for the Imaging Method of detection during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StructureIlluminationIntensity->60 Percent,Output->Options],StructureIlluminationIntensity],
			60 Percent
		],
		Example[{Options,FieldOfView,"Specify the field of view of the camera used to record the sample for the Imaging Method of detection during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FieldOfView->140 Millimeter^2,Output->Options],FieldOfView],
			140 Millimeter^2
		],
		Example[{Options,SpargeFilter,"Specify the sparge filter used to agitation the sample for foam generation during a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeFilter->Model[Part,SpargeFilter,"Test DFA sparge filter for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],SpargeFilter],
			ObjectP[Model[Part,SpargeFilter,"Test DFA sparge filter for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Example[{Options,SpargeGas,"Specify the type of gas used to sparge the sample for foam generation during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeGas->Air,Output->Options],SpargeGas],
			Air
		],
		Example[{Options,SpargeFlowRate,"Specify the flow rate of the gas used to sparge the sample for foam generation during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeFlowRate->0.8 Liter/Minute,Output->Options],SpargeFlowRate],
			0.8 Liter/Minute
		],
		Example[{Options,StirBlade,"Specify the sparge filter used to agitation the sample for foam generation during a dynamic foam analysis experiment with:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirBlade->Model[Part,StirBlade,"Test DFA stir blade for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],StirBlade],
			ObjectP[Model[Part,StirBlade,"Test DFA stir blade for ExperimentDynamicFoamAnalysis"<> $SessionUUID]]
		],
		Example[{Options,StirRate,"Specify the stir rate of the stir blade used to agitate the sample for foam generation during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirRate->3000 RPM,Output->Options],StirRate],
			3000 RPM
		],
		Example[{Options,StirOscillationPeriod,"Specify the oscillation period of the stir blade used to agitate the sample for foam generation during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirOscillationPeriod->5 Second,Output->Options],StirOscillationPeriod],
			5 Second
		],
		Example[{Options,NumberOfWashes,"Specify the number of washes of the foam column in between samples during a dynamic foam analysis experiment:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				NumberOfWashes->6,Output->Options],NumberOfWashes],
			6
		],

		(*testing option resolving from MapThread*)
		Example[{Options,DetectionMethod,"Resolve the DetectionMethod for dynamic foam analysis experiment based on the LiquidConductivityMethod-specific options selected:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				LiquidConductivityModule->Model[Part,LiquidConductivityModule,"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],DetectionMethod],
			{HeightMethod,LiquidConductivityMethod}
		],
		Example[{Options,DetectionMethod,"Resolve the DetectionMethod for dynamic foam analysis experiment based on the ImagingMethod-specific options selected:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamImagingModule->Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],DetectionMethod],
			{HeightMethod,ImagingMethod}
		],
		Example[{Options,DetectionMethod,"Resolve the DetectionMethod for dynamic foam analysis experiment based on the HeightMethod-specific options selected:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				HeightIlluminationIntensity->50 Percent,FoamImagingModule->Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],DetectionMethod],
			{HeightMethod,ImagingMethod}
		],
		Example[{Options,LiquidConductivityModule,"Null out Automatic for the detector-specific options that are not needed in the experiment, based on the resolved DetectorMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamImagingModule->Model[Part,FoamImagingModule,"Test FoamImagingModule for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],LiquidConductivityModule],
			Null
		],
		Example[{Options,DetectionMethod,"Resolve the DetectionMethod for a dynamic foam analysis experiment by excluding methods with method-specific options set to Null:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StructureIlluminationIntensity->Null,LiquidConductivityModule->Null,Output->Options],DetectionMethod],
			{HeightMethod}
		],
		Example[{Options,Wavelength,"Resolve the Wavelength for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Output->Options],Wavelength],
			469 Nanometer
		],
		Example[{Options,HeightIlluminationIntensity,"Resolve the HeightIlluminationIntensity for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Output->Options],HeightIlluminationIntensity],
			100 Percent
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with Agitation is Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Stir,Output->Options],TemperatureMonitoring],
			False
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod and Agitation is Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Agitation->Sparge,Output->Options],TemperatureMonitoring],
			True
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod and Agitation is Stir:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Agitation->Stir,Output->Options],TemperatureMonitoring],
			False
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod and LiquidConductivityMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,LiquidConductivityMethod},Output->Options],TemperatureMonitoring],
			False
		],
		Example[{Options,LiquidConductivityModule,"Resolve the LiquidConductivityModule for a dynamic foam analysis experiment with DetectionMethod set to LiquidConductivityMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,LiquidConductivityMethod},Output->Options],LiquidConductivityModule],
			ObjectP[Model[Part,LiquidConductivityModule,"DFA100 LCM"]]
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with DetectionMethod set to LiquidConductivityMethod and Agitation is Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,LiquidConductivityMethod},Agitation->Sparge,Output->Options],TemperatureMonitoring],
			False
		],
		Example[{Options,FoamImagingModule,"Resolve the FoamImagingModule for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],FoamImagingModule],
			ObjectP[Model[Part,FoamImagingModule,"DFA100 FSM"]]
		],
		Example[{Options,CameraHeight,"Resolve the CameraHeight for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],CameraHeight],
			150 Millimeter
		],
		Example[{Options,StructureIlluminationIntensity,"Resolve the StructureIlluminationIntensity for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],StructureIlluminationIntensity],
			20 Percent
		],
		Example[{Options,FieldOfView,"Resolve the FieldOfView for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],FieldOfView],
			140 Millimeter^2
		],
		Example[{Options,TemperatureMonitoring,"Resolve the TemperatureMonitoring for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod and Agitation to sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Agitation->Sparge,Output->Options],TemperatureMonitoring],
			True
		],
		Example[{Options,FoamColumn,"Resolve the FoamColumn for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Output->Options],FoamColumn],
			ObjectP[Model[Container,FoamColumn,"CY4572 Prism Column"]]
		],
		Example[{Options,FoamColumn,"Resolve the FoamColumn for a dynamic foam analysis experiment with DetectionMethod set to ImagingMethod and Temperature not Ambient:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod,ImagingMethod},Temperature->30 Celsius,Output->Options],FoamColumn],
			ObjectP[Model[Container,FoamColumn,"CY4575 Temperature Prism Column"]]
		],
		Example[{Options,FoamColumn,"Resolve the FoamColumn for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Output->Options],FoamColumn],
			ObjectP[Model[Container,FoamColumn,"CY4501 Basic Column"]]
		],
		Example[{Options,FoamColumn,"Resolve the FoamColumn for a dynamic foam analysis experiment with DetectionMethod set to HeightMethod and Temperature not Ambient:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				DetectionMethod->{HeightMethod},Temperature->30 Celsius,Output->Options],FoamColumn],
			ObjectP[Model[Container,FoamColumn,"CY4575 Temperature Prism Column"]]
		],
		Example[{Options,Agitation,"Resolve the Agitation for a dynamic foam analysis experiment with Stir-specific options set:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirRate->900 RPM,Output->Options],Agitation],
			Stir
		],
		Example[{Options,Agitation,"Resolve the Agitation for a dynamic foam analysis experiment with Sparge-specific options set:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeGas->Nitrogen,Output->Options],Agitation],
			Sparge
		],
		Example[{Options,Agitation,"Resolve the Agitation for a dynamic foam analysis experiment with Sparge-specific options Null:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SpargeGas->Null,Output->Options],Agitation],
			Stir
		],
		Example[{Options,Agitation,"Resolve the Agitation for a dynamic foam analysis experiment with Stir-specific options Null:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				StirRate->Null,Output->Options],Agitation],
			Sparge
		],
		Example[{Options,StirBlade,"Resolve the StirBlade for a dynamic foam analysis experiment with Agitation set to Stir:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Stir,Output->Options],StirBlade],
			ObjectP[Model[Part,StirBlade,"SR4501 Standard Agitator Blade"]]
		],
		Example[{Options,StirRate,"Resolve the StirRate for a dynamic foam analysis experiment with Agitation set to Stir:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Stir,Output->Options],StirRate],
			5000 RPM
		],
		Example[{Options,StirOscillationPeriod,"Resolve the StirOscillationPeriod for a dynamic foam analysis experiment with Agitation set to Stir:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Stir,Output->Options],StirOscillationPeriod],
			0 Second
		],
		Example[{Options,SpargeFilter,"Resolve the SpargeFilter for a dynamic foam analysis experiment with Agitation set to Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Sparge,Output->Options],SpargeFilter],
			ObjectP[Model[Part,SpargeFilter,"FL4533"]]
		],
		Example[{Options,SpargeGas,"Resolve the SpargeGas for a dynamic foam analysis experiment with Agitation set to Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Sparge,Output->Options],SpargeGas],
			Air
		],
		Example[{Options,SpargeFlowRate,"Resolve the SpargeFlowRate for a dynamic foam analysis experiment with Agitation set to Sparge:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Sparge,Output->Options],SpargeFlowRate],
			1 Liter/Minute
		],
		Example[{Options,SpargeFlowRate,"Null out the sparge-related options for a dynamic foam analysis experiment with Agitation set to Stir:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Agitation->Stir,Output->Options],SpargeFlowRate],
			Null
		],
		Example[{Options,NumberOfWashes,"Resolve NumberOfWashes for a dynamic foam analysis experiment with the FoamColumn set:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				FoamColumn->Model[Container,FoamColumn,"Test DFA FoamColumn jacketed prism for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Output->Options],NumberOfWashes],
			5
		],

		(* Resource packet tests *)
		Test["A foam agitation module resource corresponding to each SamplesIn will be generated in the resource packets based on the Agitation used:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,FoamAgitationModule],
			{ObjectP[Model[Container,FoamAgitationModule,"DFA100 Stir"]],ObjectP[Model[Container,FoamAgitationModule,"DFA100 Sparge"]]}
		],
		Test["A SpargeFilterCleaner resource will generated in the resource packets if Agitation contains Sparge:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,SpargeFilterCleaner],
			ObjectP[Model[Instrument,SpargeFilterCleaner,"TO4511 Filter Cleaner"]]
		],
		Test["A SpargeFilterCleaner resource will not be generated in the resource packets if Agitation does not contain Sparge:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Stir}];
			Download[protocol,SpargeFilterCleaner],
			Null
		],
		Test["A WasteContainer resource will be generated in the resource packets:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Stir}];
			Download[protocol,WasteContainer],
			ObjectP[Model[Container,Vessel,"1000mL Glass Beaker"]]
		],
		Test["A Syringe resource corresponding to each SamplesIn will be generated in the resource packets:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,Syringes],
			{ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]]}
		],
		Test["A Needle resource corresponding to each SamplesIn will be generated in the resource packets:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,Needles],
			{ObjectP[Model[Item, Needle, "id:O81aEBZaXOBx"]],ObjectP[Model[Item, Needle, "id:O81aEBZaXOBx"]]}
		],
		Test["The primary O-ring resources will be generated in the resource packets:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,ORing],
			{ObjectP[Model[Part,ORing]],ObjectP[Model[Part,ORing]]}
		],
		Test["The secondary O-ring resources will be generated in the resource packets:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				Agitation->{Stir,Sparge}];
			Download[protocol,SecondaryORing],
			{Null,ObjectP[Model[Part,ORing]]}
		],
		Test["Unit operations for batching will be generated in the resource packets.:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID]},
				FoamColumn->{Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedUnitOperations],
			{LinkP[Object[UnitOperation,DynamicFoamAnalysis]]}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into 2 batches:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedUnitOperations],
			{LinkP[Object[UnitOperation,DynamicFoamAnalysis]],LinkP[Object[UnitOperation,DynamicFoamAnalysis]]}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into 2 batches and the batched sample lengths will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleLengths],
			{2,1}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into 2 batches and the batched sample indexes will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleIndexes],
			{1,2,3}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into 2 batches and the batched sample lengths will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleLengths],
			{2,1}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into 2 batches and the batched sample indexes will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleIndexes],
			{1,3,2}
		],
		Test["Unit operations for batching will be generated in the resource packets. If there are more samples than can fit in one batch, the samples will be grouped into a batch together and the batched sample indexes will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleIndexes],
			{1,3,2}
		],
		Test["Unit operations for batching will be generated in the resource packets. If the foam columns are unique, the samples will be grouped into a batch together and the batched sample lengths will be stored:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]},
				FoamColumn->{Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis"<> $SessionUUID],Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<> $SessionUUID]}];
			Download[protocol,BatchedSampleLengths],
			{3}
		],
		Test["Unit operations for batching will be generated in the resource packets. Function handles having identical samples as an input:",
			Quiet[ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume"<> $SessionUUID]}],{Warning::InsufficientVolume}],
			ObjectP[],
			SubCategory->"Batching1"
		],
		Test["Total measurement times are populated in the protocol and the unit operations:",
			protocol=ExperimentDynamicFoamAnalysis[{Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<>$SessionUUID],Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<>$SessionUUID]},
				FoamColumn->{Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<>$SessionUUID],Model[Container,FoamColumn,"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis"<>$SessionUUID]}];
			Download[
				protocol,
				{
					AgitationTime,
					DecayTime,
					MeasurementTime,
					BatchedUnitOperations[AgitationTime],
					BatchedUnitOperations[DecayTime],
					BatchedUnitOperations[MeasurementTime]
				}
			],
			{
				{EqualP[5 Second],EqualP[5 Second]},
				{EqualP[100 Second],EqualP[100 Second]},
				{EqualP[105 Second],EqualP[105 Second]},
				{{EqualP[5 Second],EqualP[5 Second]}},
				{{EqualP[100 Second],EqualP[100 Second]}},
				{{EqualP[105 Second],EqualP[105 Second]}}
			},
			Variables:>{protocol}
		],

		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run with a dynamic foam analysis experiment:"},
			protocol=ExperimentDynamicFoamAnalysis["DFA sample 1",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"DFA sample 1",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"DFA sample 1",
						Amount->50*Milliliter
					]
				}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		(*incubate options*)
		Example[{Options,Incubate,"Perform a dynamic foam analysis experiment on a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Perform a dynamic foam analysis experiment on a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Perform a dynamic foam analysis experiment on a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Perform a dynamic foam analysis experiment on a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature->30 Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Perform a dynamic foam analysis experiment on a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			Lookup[ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options],IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],IncubateAliquot->50 Milliliter,IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,IncubateAliquot],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],IncubateAliquot->50 Milliliter,IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Mix->True,MixType->Stir,Output->Options];
			Lookup[options,MixType],
			Stir,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],MixUntilDissolved->True,MixType->Stir,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],CentrifugeTemperature->30*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],CentrifugeAliquot->50*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquot],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],CentrifugeAliquot->50*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],

		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterPoreSize->0.22*Micrometer,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],

		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],PrefilterPoreSize->1.*Micrometer,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes we would use in this experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterHousing->Null,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterSterile->False,Output->Options];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],*)
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->50*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			50*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Perform a dynamic foam analysis experiment on a single liquid sample by first aliquotting the sample:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AliquotAmount->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotAmount],
			50*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentDynamicFoamAnalysis[
				Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options}
		],
		Example[{Options,SampleContainerLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentDynamicFoamAnalysis[
				Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SampleContainerLabel->"mySample2",
				Output->Options
			];
			Lookup[options,SampleContainerLabel],
			"mySample2",
			Variables:>{options}
		],
		Example[{Options,SampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentDynamicFoamAnalysis[
				Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				SampleLabel->"mySample3",
				Output->Options
			];
			Lookup[options,SampleLabel],
			"mySample3",
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AssayVolume->80*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			80*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample7 for concentration"<> $SessionUUID],TargetConcentration->8*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			8*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample7 for concentration"<> $SessionUUID],TargetConcentration->9*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Sodium n-Dodecyl Sulfate"],Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Sodium n-Dodecyl Sulfate"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->50*Microliter,AssayVolume->50*Milliliter,AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],AliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],SamplesInStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"100 mL Glass Bottle"],IncubateAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Name->"My Exploratory DynamicFoamAnalysis Test Protocol",Output->Options];
			Lookup[options,Name],
			"My Exploratory DynamicFoamAnalysis Test Protocol"
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],Template->Object[Protocol,DynamicFoamAnalysis,"Parent Protocol for ExperimentDynamicFoamAnalysis testing"<> $SessionUUID],Output->Options];
			Lookup[options,AgitationTime],
			6 Second
		],
		Example[{Options, Output, "Simulation is returned when Output-> Simulation is specified:"},
			simulation = ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample1"<> $SessionUUID],
				Output -> Simulation];
			simulation,
			SimulationP,
			Variables:>{simulation}
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentDynamicFoamAnalysis[Object[Sample,"DynamicFoamAnalysis Test Water Sample2"<> $SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			TimeConstraint->240
		]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		ClearMemoization[];
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "DynamicFoamAnalysis 100mL Bottle Container1" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container2" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container3 for no volume" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container4 for not liquid" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container5 for no model" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container6 for discarded sample" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container7 for concentration" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 50mL Tube Container8 for low volume" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysis 250mL Bottle Container9 for high volume" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample1" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample2" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample3 for no volume" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample4 for not liquid" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample5 for no model" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample6 for discarded" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample7 for concentration" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample8 for low volume" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysis Test Water Sample9 for high volume" <> $SessionUUID],
				Object[Protocol, DynamicFoamAnalysis, "Parent Protocol for ExperimentDynamicFoamAnalysis testing" <> $SessionUUID],
				Model[Instrument, DynamicFoamAnalyzer, "Test DFA model instrument for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Object[Instrument, DynamicFoamAnalyzer, "Test DFA object for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Part, LiquidConductivityModule, "Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Part, FoamImagingModule, "Test FoamImagingModule for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Part, SpargeFilter, "Test DFA sparge filter for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Part, StirBlade, "Test DFA stir blade for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Container, FoamColumn, "Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Container, FoamColumn, "Test DFA FoamColumn jacketed prism for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Object[Container, FoamColumn, "Test foam column object for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Object[Container, FoamColumn, "Test foam column object 2 for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Object[Container, FoamColumn, "Test foam column object 3 for ExperimentDynamicFoamAnalysis" <> $SessionUUID],
				Object[Container, FoamColumn, "Test foam column object 4 for ExperimentDynamicFoamAnalysis" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		{instModel} = Upload[{
			(*Create instrument model*)
			<|
				Type->Model[Instrument, DynamicFoamAnalyzer],
				Name->"Test DFA model instrument for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(*Create a instrument object from the new models*)
		Upload[{
			<|
				Type->Object[Instrument, DynamicFoamAnalyzer],
				Model->Link[Model[Instrument, DynamicFoamAnalyzer, "Test DFA model instrument for ExperimentDynamicFoamAnalysis" <> $SessionUUID], Objects],
				Name->"Test DFA object for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Status->Available,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(*Create a liquid conductivity module model*)
		Upload[{
			<|
				Type->Model[Part, LiquidConductivityModule],
				Name->"Test LiquidConductivityModule for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(*Create a foam imaging module model*)
		Upload[{
			<|
				Type->Model[Part, FoamImagingModule],
				Name->"Test FoamImagingModule for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(*Create a sparging filter model*)
		Upload[{
			<|
				Type->Model[Part, SpargeFilter],
				Name->"Test DFA sparge filter for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(*Create a stir blade model*)
		Upload[{
			<|
				Type->Model[Part, StirBlade],
				Name->"Test DFA stir blade for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(*Create foam column modes*)
		Upload[{
			<|
				Type->Model[Container, FoamColumn],
				Name->"Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Replace[ContainerMaterials]->Glass,
				Replace[PreferredNumberOfWashes]->5,
				Replace[PreferredWashSolvent]->Link[Model[Sample, "Milli-Q water"]],
				Replace[PreferredWipes]->Link[Model[Item, Consumable, "Kimwipes, 38 cm x 43 cm"]],
				Replace[MinSampleVolume]->50 Milliliter,
				Jacketed->True,
				Prism->False,
				Deprecated->False,
				DeveloperObject->True
			|>,
			<|
				Type->Model[Container, FoamColumn],
				Name->"Test DFA FoamColumn jacketed prism for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Replace[ContainerMaterials]->Glass,
				Replace[PreferredNumberOfWashes]->5,
				Replace[PreferredWashSolvent]->Link[Model[Sample, "Milli-Q water"]],
				Replace[PreferredWipes]->Link[Model[Item, Consumable, "Kimwipes, 38 cm x 43 cm"]],
				Replace[MinSampleVolume]->50 Milliliter,
				Prism->True,
				Jacketed->True,
				Deprecated->False,
				DeveloperObject->True
			|>,
			<|
				Type->Model[Container, FoamColumn],
				Name->"Test DFA FoamColumn for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Replace[ContainerMaterials]->Glass,
				Replace[PreferredNumberOfWashes]->5,
				Replace[PreferredWashSolvent]->Link[Model[Sample, "Milli-Q water"]],
				Replace[PreferredWipes]->Link[Model[Item, Consumable, "Kimwipes, 38 cm x 43 cm"]],
				Replace[MinSampleVolume]->50 Milliliter,
				Jacketed->False,
				Prism->False,
				Deprecated->False,
				DeveloperObject->True
			|>
		}];

		(* create foam column objects *)
		Upload[{
			<|
				Type->Object[Container, FoamColumn],
				Name->"Test foam column object for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Model->Link[Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis" <> $SessionUUID], Objects],
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container, FoamColumn],
				Name->"Test foam column object 2 for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Model->Link[Model[Container, FoamColumn, "Test DFA FoamColumn for ExperimentDynamicFoamAnalysis" <> $SessionUUID], Objects],
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container, FoamColumn],
				Name->"Test foam column object 3 for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Model->Link[Model[Container, FoamColumn, "Test DFA FoamColumn jacketed for ExperimentDynamicFoamAnalysis" <> $SessionUUID], Objects],
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container, FoamColumn],
				Name->"Test foam column object 4 for ExperimentDynamicFoamAnalysis" <> $SessionUUID,
				Model->Link[Model[Container, FoamColumn, "Test DFA FoamColumn jacketed prism for ExperimentDynamicFoamAnalysis" <> $SessionUUID], Objects],
				Site->Link[$Site],
				DeveloperObject->True
			|>}
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		fakeNewModelID = CreateID[Model[Container, Vessel]];

		(* Create some containers *)
		{
			testTube1,
			testTube2,
			testTube3,
			testTube4,
			testTube5,
			testTube6,
			testTube7,
			testTube8,
			testTube9
		} = Upload[{
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysis 100mL Bottle Container1" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container2" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container3 for no volume" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container4 for not liquid" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container5 for no model" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container6 for discarded sample" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container7 for concentration" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "50mL Tube"], Objects], Name->"DynamicFoamAnalysis 50mL Tube Container8 for low volume" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
			<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysis 250mL Bottle Container9 for high volume" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>
		}];

		(* Create some samples *)
		{
			waterSample1,
			waterSample2,
			waterSampleNoVol3,
			waterSampleNotLiq4,
			waterSampleModelSevered5,
			waterSampleDiscarded6,
			concentrationSample7,
			waterSampleLowVol8,
			waterSampleHighVol9
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"]
			},
			{
				{"A1", testTube1},
				{"A1", testTube2},
				{"A1", testTube3},
				{"A1", testTube4},
				{"A1", testTube5},
				{"A1", testTube6},
				{"A1", testTube7},
				{"A1", testTube8},
				{"A1", testTube9}
			},
			InitialAmount->{
				100 Milliliter,
				50 Milliliter,
				50 Milliliter,
				50 Milliliter,
				50 Milliliter,
				50 Milliliter,
				50 Milliliter,
				15 Milliliter,
				250 Milliliter
			},
			StorageCondition->AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample1, Name->"DynamicFoamAnalysis Test Water Sample1" <> $SessionUUID, Status->Available, DeveloperObject->True|>,
			<|Object->waterSample2, Name->"DynamicFoamAnalysis Test Water Sample2" <> $SessionUUID, Status->Available, DeveloperObject->True|>,
			<|Object->waterSampleNoVol3, Name->"DynamicFoamAnalysis Test Water Sample3 for no volume" <> $SessionUUID, Status->Available, Volume->Null, DeveloperObject->True|>,
			<|Object->waterSampleNotLiq4, Name->"DynamicFoamAnalysis Test Water Sample4 for not liquid" <> $SessionUUID, Status->Available, State->Null, DeveloperObject->True|>,
			<|Object->waterSampleModelSevered5, Name->"DynamicFoamAnalysis Test Water Sample5 for no model" <> $SessionUUID, Status->Available, DeveloperObject->True, Model->Null|>,
			<|Object->waterSampleDiscarded6, Name->"DynamicFoamAnalysis Test Water Sample6 for discarded" <> $SessionUUID, Status->Discarded, DeveloperObject->True|>,
			<|Object->concentrationSample7, Name->"DynamicFoamAnalysis Test Water Sample7 for concentration" <> $SessionUUID, Replace[Composition]->{{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Sodium n-Dodecyl Sulfate"]], Now}}, Status->Available, DeveloperObject->True|>,
			<|Object->waterSampleLowVol8, Name->"DynamicFoamAnalysis Test Water Sample8 for low volume" <> $SessionUUID, Status->Available, DeveloperObject->True|>,
			<|Object->waterSampleHighVol9, Name->"DynamicFoamAnalysis Test Water Sample9 for high volume" <> $SessionUUID, Status->Available, DeveloperObject->True|>
		}];

		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol, DynamicFoamAnalysis],
				Name->"Parent Protocol for ExperimentDynamicFoamAnalysis testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{
					AgitationTime->6 Second (*TODO: add more*)
				}
			|>
		];
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];


(* ::Subsection:: *)
(*ExperimentDynamicFoamAnalysisPreview*)


DefineTests[
	ExperimentDynamicFoamAnalysisPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentDynamicFoamAnalysis:"},
			ExperimentDynamicFoamAnalysisPreview[{Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample2"<> $SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentDynamicFoamAnalysisOptions:"},
			ExperimentDynamicFoamAnalysisOptions[{Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample3"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample1"<> $SessionUUID]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentDynamicFoamAnalysisQ:"},
			ValidExperimentDynamicFoamAnalysisQ[{Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysisPreview Test Water Sample2"<> $SessionUUID]},Verbose->Failures],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "DynamicFoamAnalysisPreview Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisPreview Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisPreview Test Tube 3" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisPreview Test Water Sample1" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisPreview Test Water Sample2" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisPreview Test Water Sample3" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisPreview Test Tube 1" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisPreview Test Tube 2" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisPreview Test Tube 3" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"DynamicFoamAnalysisPreview Test Water Sample1" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"DynamicFoamAnalysisPreview Test Water Sample2" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"DynamicFoamAnalysisPreview Test Water Sample3" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];




(* ::Subsection:: *)
(*ExperimentDynamicFoamAnalysisOptions*)


DefineTests[
	ExperimentDynamicFoamAnalysisOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentDynamicFoamAnalysisOptions[{Object[Sample,"DynamicFoamAnalysisOptions Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysisOptions Test Water Sample2"<> $SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentDynamicFoamAnalysisOptions[{Object[Sample,"DynamicFoamAnalysisOptions Test Water Sample3"<> $SessionUUID]},DetectionMethod->{HeightMethod,LiquidConductivityMethod},Agitation->Stir],
			_Grid,
			Messages:>{Error::InvalidOption,Error::DFAstirLiquidConductivityMismatch}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentDynamicFoamAnalysisOptions[{Object[Sample,"DynamicFoamAnalysisOptions Test Water Sample1"<> $SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "DynamicFoamAnalysisOptions Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisOptions Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisOptions Test Tube 3" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisOptions Test Water Sample1" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisOptions Test Water Sample2" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisOptions Test Water Sample3" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisOptions Test Tube 1" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisOptions Test Tube 2" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisOptions Test Tube 3" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"DynamicFoamAnalysisOptions Test Water Sample1" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"DynamicFoamAnalysisOptions Test Water Sample2" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"DynamicFoamAnalysisOptions Test Water Sample3" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];


(* ::Subsection:: *)
(*ValidExperimentDynamicFoamAnalysisQ*)


DefineTests[
	ValidExperimentDynamicFoamAnalysisQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentDynamicFoamAnalysisQ[{Object[Sample,"DynamicFoamAnalysisValid Test Water Sample1"<> $SessionUUID],Object[Sample,"DynamicFoamAnalysisValid Test Water Sample3"<> $SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentDynamicFoamAnalysisQ[Object[Sample,"DynamicFoamAnalysisValid Test Water Sample2"<> $SessionUUID],DetectionMethod->{HeightMethod,LiquidConductivityMethod},Agitation->Stir],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentDynamicFoamAnalysisQ[Object[Sample,"DynamicFoamAnalysisValid Test Water Sample1"<> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentDynamicFoamAnalysisQ[Object[Sample,"DynamicFoamAnalysisValid Test Water Sample1"<> $SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "DynamicFoamAnalysisValid Test Tube 1" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisValid Test Tube 2" <> $SessionUUID],
				Object[Container, Vessel, "DynamicFoamAnalysisValid Test Tube 3" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisValid Test Water Sample1" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisValid Test Water Sample2" <> $SessionUUID],
				Object[Sample, "DynamicFoamAnalysisValid Test Water Sample3" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisValid Test Tube 1" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisValid Test Tube 2" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name->"DynamicFoamAnalysisValid Test Tube 3" <> $SessionUUID, Site->Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"DynamicFoamAnalysisValid Test Water Sample1" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"DynamicFoamAnalysisValid Test Water Sample2" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"DynamicFoamAnalysisValid Test Water Sample3" <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];

