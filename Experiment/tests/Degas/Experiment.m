(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentDegas *)


DefineTests[
	ExperimentDegas,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Degas a sample:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,Degas]]
		],
		Example[{Basic,"Degas multiple samples:"},
			ExperimentDegas[{Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Object[Sample,"Degas Test Water Sample2"<> $SessionUUID]},Upload->True],
			ObjectP[Object[Protocol,Degas]]
		],
		Example[{Basic,"Degas samples in the specified input container:"},
			ExperimentDegas[Object[Container,Vessel,"Degas 2mL Tube Container1"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,Degas]]
		],
		Test["Degas a sample with a severed model:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample Severed Model"<> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,Degas]]
		],
		Test["Degas a model:",
			ExperimentDegas[Model[Sample,"Milli-Q water"],Upload->True],
			ObjectP[Object[Protocol,Degas]]
		],


		(* Messages: errors and warnings *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentDegas[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentDegas[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentDegas[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentDegas[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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
					Model[Sample,"Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				
				ExperimentDegas[sampleID, Aliquot->True,Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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
					Model[Sample,"Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				
				ExperimentDegas[containerID, Aliquot->True,Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Test discarded sample for ExperimentDegas"<> $SessionUUID],DegasType->VacuumDegas],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"DegasNoVolume","Return $Failed if Sample contains Null in the Volume field:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample3 for no volume"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DegasNoVolume}
		],
		Example[{Messages,"DegasNotLiquid","Return $Failed if the Sample State is not liquid:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample4 for not liquid"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DegasNotLiquid,Error::DegasNoVolume,Error::SolidSamplesUnsupported}
		],

		(*option precision tests*)
		Example[
			{Messages,"InstrumentPrecision","If a ThawTemperature with a greater precision than 1 Celsius is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],ThawTemperature->27.5 Celsius],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a FreezeTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FreezeTime->62.5 Second],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a PumpTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],PumpTime->62.5 Second],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a ThawTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],ThawTime->62.5 Second],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a VacuumTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],VacuumTime->15.375 Minute],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(*TODO: check the below*)
		Example[
			{Messages,"InstrumentPrecision","If a MaxVacuumTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],MaxVacuumTime->15.357 Minute,VacuumUntilBubbleless->True],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a SpargingTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],SpargingTime->1802.5 Second],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a HeadspaceGasFlushTime with a greater precision than 1 Second is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],HeadspaceGasFlushTime->62.5 Second,HeadspaceGasFlush->Argon],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[
			{Messages,"InstrumentPrecision","If a VacuumPressure with a greater precision than 1 Milli*Bar is given, it is rounded:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],VacuumPressure->1.5 Milli*Bar],
			_,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],

		(*Conflicting options*)
		Example[{Messages,"DegasTypeInstrumentMismatch","If the DegasType and Instrument do not agree, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,Instrument->Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DegasTypeInstrumentMismatch,Error::SpargingInstrument,Error::InvalidOption}
		],
		Example[{Messages,"FreezePumpThawOnlyMismatch","If the DegasType provided is not FreezePumpThaw but FreezePumpThaw-specific options are given, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,FreezeTime->1 Minute],
			$Failed,
			Messages:>{Error::FreezePumpThawOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"VacuumDegasOnlyMismatch","If the DegasType provided is not VacuumDegas but VacuumDegas-specific options are given, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,VacuumUntilBubbleless->True],
			$Failed,
			Messages:>{Error::VacuumDegasOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasMaxVacuumUntilBubbleless","If MaxVacuumTime is set but VacuumUntilBubbleless is False, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],MaxVacuumTime->5 Minute,VacuumUntilBubbleless->False],
			$Failed,
			Messages:>{Error::DegasMaxVacuumUntilBubbleless,Error::InvalidOption}
		],
		Example[{Messages,"SpargingOnlyMismatch","If the DegasType provided is not Sparging but Sparging-specific options are given, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,SpargingGas->Nitrogen],
			$Failed,
			Messages:>{Error::SpargingOnlyMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasHeadspaceGasFlushOptions","If HeadspaceGasFlushTime is set but HeadspaceGasFlush is None, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],HeadspaceGasFlushTime->5 Minute,HeadspaceGasFlush->None],
			$Failed,
			Messages:>{Error::DegasHeadspaceGasFlushOptions,Error::InvalidOption}
		],
		Example[{Messages,"DegasHeadspaceGasFlushTimeOptions","If HeadspaceGasFlushTime is Null but HeadspaceGasFlush is set, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],HeadspaceGasFlushTime->Null,HeadspaceGasFlush->Nitrogen],
			$Failed,
			Messages:>{Error::DegasHeadspaceGasFlushTimeOptions,Error::InvalidOption}
		],
		Example[{Messages,"DegasGeneralOptionMismatch","If options specific to more than one DegasType are specified simultaneously, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				FreezeTime->5 Minute,SpargingTime->5 Minute,VacuumUntilBubbleless->True],
			$Failed,
			Messages:>{Error::DegasGeneralOptionMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasHeadspaceGasFlushTypeMismatch","If the DegasType provided is not VacuumDegas or FreezePumpThaw but HeadspaceGasFlush-related options are given, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,HeadspaceGasFlush->Helium],
			$Failed,
			Messages:>{Error::DegasHeadspaceGasFlushTypeMismatch,Error::HeadspaceGasFlushSpargingError,Error::InvalidOption}
		],
		Example[{Messages,"DegasSpargingNullMismatch","If the DegasType provided is Sparging but Sparging-related options are Null, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,SpargingGas->Null],
			$Failed,
			Messages:>{Error::DegasSpargingNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is Sparging but SpargingTime is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,SpargingTime->Null],
			$Failed,
			Messages:>{Error::DegasSpargingNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasVacuumDegasNullMismatch","If the DegasType provided is VacuumDegas but VacuumDegas-related options are Null, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumTime->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is VacuumDegas but VacuumPressure is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumPressure->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is VacuumDegas but VacuumSonicate is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumSonicate->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is VacuumDegas but VacuumSonicate is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumSonicate->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is VacuumDegas but VacuumUntilBubbleless is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumUntilBubbleless->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is VacuumDegas but MaxVacuumTime is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,MaxVacuumTime->Null],
			$Failed,
			Messages:>{Error::DegasVacuumDegasNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasFreezePumpThawNullMismatch","If the DegasType provided is FreezePumpThaw but FreezePumpThaw-related options are Null, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,FreezeTime->Null],
			$Failed,
			Messages:>{Error::DegasFreezePumpThawNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is FreezePumpThaw but PumpTime is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,PumpTime->Null],
			$Failed,
			Messages:>{Error::DegasFreezePumpThawNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is FreezePumpThaw but ThawTime is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,ThawTime->Null],
			$Failed,
			Messages:>{Error::DegasFreezePumpThawNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is FreezePumpThaw but ThawTemperature is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,ThawTemperature->Null],
			$Failed,
			Messages:>{Error::DegasFreezePumpThawNullMismatch,Error::InvalidOption}
		],
		Test["If DegasType provided is FreezePumpThaw but NumberOfCycles is Null, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,NumberOfCycles->Null],
			$Failed,
			Messages:>{Error::DegasFreezePumpThawNullMismatch,Error::InvalidOption}
		],
		Example[{Messages,"DegasInstrumentOptionMismatch","If an option for a degas type is specified and options from a conflicting degas type are also specified, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID],SpargingGas->Helium],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a object VacuumDegasser and options from a conflicting degas type (freeze pump thaw) are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID],PumpTime->5 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a model VacuumDegasser and options from a conflicting degas type are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID],PumpTime->5 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a model FreezePumpThawApparatus and options from a conflicting degas type (vacuum degas) are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Instrument->Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID],VacuumTime->15 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a model FreezePumpThawApparatus and options from a conflicting degas type (sparging) are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Instrument->Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID],SpargingTime->15 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a model SpargingApparatus and options from a conflicting degas type (freeze pump thaw) are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],PumpTime->15 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Test["If the instrument type is specified as a model SpargingApparatus and options from a conflicting degas type (vacuum degas) are also specified, an error will be thrown:",
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],VacuumTime->15 Minute],
			$Failed,
			Messages:>{Error::DegasInstrumentOptionMismatch,Error::InvalidOption}
		],
		Example[{Messages,"VacuumDegasInstrument","If the degas type is specified as vacuum degas and options from a conflicting degas instrument type are also specified, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],Instrument->Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],DegasType->VacuumDegas],
			$Failed,
			Messages:>{Error::VacuumDegasInstrument,Error::DegasTypeInstrumentMismatch,Error::InvalidOption}
		],
		Example[{Messages,"SpargingInstrument","If the degas type is specified as sparging and options from a conflicting degas instrument type are also specified, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,Instrument->Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::SpargingInstrument,Error::DegasTypeInstrumentMismatch,Error::InvalidOption}
		],
		Example[{Messages,"FreezePumpThawInstrument","If the degas type is specified as freeze pump thaw and options from a conflicting degas instrument type are also specified, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Instrument->Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],DegasType->FreezePumpThaw],
			$Failed,
			Messages:>{Error::FreezePumpThawInstrument,Error::DegasTypeInstrumentMismatch,Error::InvalidOption}
		],

		(*Errors from MapThread*)
		Example[{Messages,"FreezePumpThawVolumeError","Return $Failed if the Sample Volume is >50 mL and the DegasType is FreezePumpThaw:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->FreezePumpThaw],
			$Failed,
			Messages:>{Error::InvalidOption,Error::FreezePumpThawVolumeError}
		],
		Example[{Messages,"VacuumDegasVolumeError","Return $Failed if the Sample Volume is >1 L or <10 mL and the DegasType is VacuumDegas:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->VacuumDegas],
			$Failed,
			Messages:>{Error::InvalidOption,Error::VacuumDegasVolumeError}
		],
		Example[{Messages,"SpargingVolumeError","Return $Failed if the Sample Volume is <50 mL or >4L and the DegasType is Sparging:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->Sparging],
			$Failed,
			Messages:>{Error::InvalidOption,Error::SpargingVolumeError,Warning::AliquotRequired}
		],
		Example[{Messages,"FreezePumpThawContainerError","Return $Failed if the FreezePumpThawContainer specified is not a suitable Schlenk flask or does not have a max volume of at least double the sample volume:"},
			ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],FreezePumpThawContainer -> Model[Container, Vessel, "50mL Tube"]],
			$Failed,
			Messages:>{Error::InvalidOption,Error::FreezePumpThawContainerError}
		],
		Example[{Messages,"DegasDissolvedOxygenError","Return $Failed if the DissolvedOxygen specified is True for a non-aqueous sample:"},
			ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],DissolvedOxygen->True],
			$Failed,
			Messages:>{Error::InvalidOption,Error::DegasDissolvedOxygenError}
		],
		Example[{Messages,"DegasVacuumTimeLow","Throw a warning if the VacuumTime is <15 minute:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				DegasType->VacuumDegas,VacuumTime->10 Minute,Output->Options];
			Lookup[options,VacuumTime],
			10 Minute,
			Messages:>{Warning::DegasVacuumTimeLow},
			Variables :> {options}
		],
		Example[{Messages,"DegasSpargingTimeLow","Throw a warning if the SpargingTime is <15 minute:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				DegasType->Sparging,SpargingTime->10 Minute,Output->Options];
			Lookup[options,SpargingTime],
			10 Minute,
			Messages:>{Warning::DegasSpargingTimeLow},
			Variables :> {options}
		],
		Example[{Messages,"HeadspaceGasFlushSpargingError","If the DegasType resolved is not VacuumDegas or FreezePumpThaw but HeadspaceGasFlush-related options are given, an error will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],SpargingGas->Helium,HeadspaceGasFlush->Helium],
			$Failed,
			Messages:>{Error::HeadspaceGasFlushSpargingError,Error::InvalidOption}
		],
		Example[{Messages,"SpargingVolumeContainerLow","For sparging, if the volume of the sample is less than half of the max volume of the container, the container will need to be transferred and a warning will be thrown:"},
			ExperimentDegas[Object[Container,Vessel,"Degas Test 5L Bottle2"<> $SessionUUID],DegasType->Sparging],
			_,
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 180
		],
		Example[{Messages,"VacuumDegassingSuitableContainer","If the container of the sample is not either a glass bottle or a 50mL tube, the container will need to be transferred and a warning will be thrown:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample9 10L carboy for vacuum degas error"<> $SessionUUID],DegasType->VacuumDegas],
			_,
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 180
		],
		Example[{Messages,"DegasDissolvedOxygenVolumeError","Return $Failed if the Sample Volume is <50 mL and DissolvedOxygen is set to True:"},
			ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DissolvedOxygen->True],
			$Failed,
			Messages:>{Error::InvalidOption,Error::DegasDissolvedOxygenVolumeError}
		],
		Example[{Messages,"DegasMaxVacuumTimeMismatch","Return $Failed if the MaxVacuumTime is less than the VacuumTime:"},
			ExperimentDegas[Object[Sample, "Degas Test Water Sample7 500mL Bottle"<> $SessionUUID], VacuumTime ->30 Minute, MaxVacuumTime -> 25 Minute],
			$Failed,
			Messages:>{Error::InvalidOption,Error::DegasMaxVacuumTimeMismatch}
		],

		(* Options specific to ExperimentDegas *)
		Example[{Options,DegasType,"Specify the DegasType to degas with:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				DegasType->FreezePumpThaw,Output->Options],DegasType],
			FreezePumpThaw
		],
		Example[{Options,Instrument,"Specify the instrument model to degas with:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				Instrument->Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID],Output->Options],Instrument],
			ObjectP[Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID]]
		],
		Example[{Options,Instrument,"Specify the instrument object to degas with:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				Instrument->Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID],Output->Options],Instrument],
			ObjectP[Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID]]
		],
		Example[{Options,DissolvedOxygen,"Specify whether to take a dissolved oxygen reading before and after the degas procedure:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				DissolvedOxygen->True,Output->Options],DissolvedOxygen],
			True
		],
		Example[{Options,FreezeTime,"Specify the FreezeTime of the run for a FreezePumpThaw cycle:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				FreezeTime->5 Minute,Output->Options],FreezeTime],
			5 Minute
		],
				Example[{Options,PumpTime,"Specify the PumpTime of the run for a FreezePumpThaw cycle:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				PumpTime->23 Minute,Output->Options],PumpTime],
			23 Minute
		],
		Example[{Options,ThawTemperature,"Specify the ThawTemperature of the run for a FreezePumpThaw cycle:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				ThawTemperature->33 Celsius,Output->Options],ThawTemperature],
			33 Celsius
		],
		Example[{Options,ThawTime,"Specify the ThawTime of the run for a FreezePumpThaw cycle:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				ThawTime->8 Minute,Output->Options],ThawTime],
			8 Minute
		],
		Example[{Options,NumberOfCycles,"Specify the NumberOfCycles of freeze-pump-thaw to do for a FreezePumpThaw experiment:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				NumberOfCycles->5,Output->Options],NumberOfCycles],
			5
		],
		Example[{Options, FreezePumpThawContainer, "Specify the Schlenk flask container to be used for a FreezePumpThaw experiment:"},
			Lookup[ExperimentDegas[Object[Sample, "Degas Test Water Sample1" <> $SessionUUID],
				FreezePumpThawContainer -> Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options], FreezePumpThawContainer],
			ObjectP[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)]
		],
		(*TODO: modify with appropriate precision and units in the future. Also allow for multiple units*)
		Example[{Options,VacuumPressure,"Specify the VacuumPressure of the run for a VacuumDegas experiment:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				VacuumPressure->7 Milli*Bar,Output->Options],VacuumPressure],
			7 Milli*Bar
		],
		Example[{Options,VacuumTime,"Specify the VacuumTime of the run for a VacuumDegas experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				VacuumTime->30 Minute,Output->Options];
			Lookup[options,VacuumTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options,VacuumUntilBubbleless,"Specify whether the sample will be vacuumed until it appears bubbleless during the run for a VacuumDegas experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				VacuumUntilBubbleless->True,Output->Options];
			Lookup[options,VacuumUntilBubbleless],
			True,
			Variables :> {options}
		],
		Example[{Options,MaxVacuumTime,"Specify the MaxVacuumTime of the run for a VacuumDegas experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],
				MaxVacuumTime->70 Minute,Output->Options];
			Lookup[options,MaxVacuumTime],
			70 Minute,
			Variables :> {options}
		],
		Example[{Options,SpargingGas,"Specify the SpargingGas of the run for a Sparging experiment:"},
			options = ExperimentDegas[
				Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],
				DegasType -> Sparging,
				SpargingGas -> Helium,
				Output -> Options
			];
			Lookup[options, SpargingGas],
			Helium,
			Variables :> {options}
		],
		Example[{Options,SpargingTime,"Specify the SpargingTime of the run for a Sparging experiment:"},
			options = ExperimentDegas[
				Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],
				DegasType -> Sparging,
				SpargingTime->15 Minute,
				Output->Options
			];
			Lookup[options, SpargingTime],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, SpargingMix, "Specify the SpargingMix of the run for a Sparging experiment"},
			options = ExperimentDegas[
				Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],
				DegasType -> Sparging,
				SpargingMix -> True,
				Output -> Options
			];
			Lookup[options, SpargingMix],
			True,
			Variables :> {options}
		],
		Example[{Options,HeadspaceGasFlush,"Specify which gas (or None) will be used to swap out the head space of the container at the end of the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlush->Helium,Output->Options];
			Lookup[options,HeadspaceGasFlush],
			Helium,
			Variables :> {options}
		],
		Example[{Options,HeadspaceGasFlushTime,"Specify how long the gas in the headspace will be flushed at the end of the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlushTime->5 Minute,Output->Options];
			Lookup[options,HeadspaceGasFlushTime],
			5 Minute,
			Variables :> {options}
		],

		(* resolving automatic *)
		Example[{Options,Instrument,"Instrument will default to the appropriate one for the resolved DegasType if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,Instrument->Automatic,Output->Options],Instrument],
			Model[Instrument,FreezePumpThawApparatus,"High Tech FreezePumpThaw Apparatus"]
		],
		Example[{Options,DissolvedOxygen,"DissolvedOxygen will default to False for aqueous samples:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,Output->Options],DissolvedOxygen],
			False
		],
		Example[{Options,DissolvedOxygen,"DissolvedOxygen will default to False for non-aqueous samples:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,Output->Options],DissolvedOxygen],
			False
		],
		Example[{Options,DissolvedOxygen,"DissolvedOxygen will default to False for samples with volume <50mL:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,Output->Options],DissolvedOxygen],
			False
		],
		Example[{Options,FreezeTime,"FreezeTime for FreezePumpThaw will default to 3 minutes if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],FreezeTime->Automatic,Output->Options],FreezeTime],
			3 Minute
		],
		Example[{Options,PumpTime,"PumpTime for FreezePumpThaw will default to 2 minutes if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,PumpTime->Automatic,Output->Options],PumpTime],
			2 Minute
		],
		Example[{Options,ThawTemperature,"ThawTemperature for FreezePumpThaw will default to ambient temperature if it is set to automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,ThawTemperature->Automatic,Output->Options],ThawTemperature],
			$AmbientTemperature
		],
		Example[{Options,ThawTime,"ThawTime for FreezePumpThaw will default based on the sample volume if it is left as Automatic. If Sample Volume<10mL, ThawTime will default to 30 minute:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],ThawTime->Automatic,Output->Options],ThawTime],
			45 Minute
		],
		Example[{Options,ThawTime,"ThawTime for FreezePumpThaw will default based on the sample volume if it is left as Automatic. If Sample Volume>=10mL, ThawTime will default to 45 minutes:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],ThawTime->Automatic,Output->Options],ThawTime],
			30 Minute
		],
		Example[{Options,NumberOfCycles,"NumberOfCycles for FreezePumpThaw will default to 3 if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],DegasType->FreezePumpThaw,NumberOfCycles->Automatic,Output->Options],NumberOfCycles],
			3
		],
		Example[{Options,FreezePumpThawContainer,"FreezePumpThawContainer for FreezePumpThaw will default to smallest Schlenk flask that has a maximum volume of at least 2x the sample volume, if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],DegasType->FreezePumpThaw,FreezePumpThawContainer->Automatic,Output->Options],FreezePumpThawContainer],
			ObjectP[Model[Container, Vessel, "id:54n6evnwBGBq"]] (*Model[Container, Vessel, "id:54n6evnwBGBq"]*)
		],
		Example[{Options,VacuumPressure,"VacuumPressure for VacuumDegas will default to the max of the pump if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumPressure->Automatic,Output->Options],VacuumPressure],
			150 Milli*Bar
		],
		Example[{Options,VacuumSonicate,"VacuumSonicate for VacuumDegas will default to True if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumSonicate->Automatic,Output->Options],VacuumSonicate],
			True
		],
		Example[{Options,VacuumUntilBubbleless,"VacuumUntilBubbleless for VacuumDegas will default to True if it is left as Automatic and MaxVacuumTime is specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumSonicate->Automatic,MaxVacuumTime->5*Hour,Output->Options],VacuumUntilBubbleless],
			True
		],
		Example[{Options,VacuumUntilBubbleless,"VacuumUntilBubbleless for VacuumDegas will default to False if it is left as Automatic and MaxVacuumTime is not specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumUntilBubbleless->Automatic,Output->Options],VacuumUntilBubbleless],
			False
		],
		Example[{Options,MaxVacuumTime,"MaxVacuumTime for VacuumDegas will default to the max possible experiment time if it is left as Automatic and VacuumUntilBubbleless is specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumUntilBubbleless->True,MaxVacuumTime->Automatic,Output->Options],MaxVacuumTime],
			$MaxExperimentTime
		],
		Example[{Options,MaxVacuumTime,"MaxVacuumTime for VacuumDegas will default to Null if it is left as Automatic and VacuumUntilBubbleless is not specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumUntilBubbleless->False,MaxVacuumTime->Automatic,Output->Options],MaxVacuumTime],
			Null
		],
		Example[{Options,VacuumTime,"VacuumTime for VacuumDegas will default to 1 Hour if it is left as Automatic and MaxVacuumTime is not specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumTime->Automatic,MaxVacuumTime->Automatic,Output->Options],VacuumTime],
			1 Hour
		],
		Example[{Options,VacuumTime,"VacuumTime for VacuumDegas will default to smaller of either 1 Hour or MaxVacuumTime, if it is left as Automatic and MaxVacuumTime is specified:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas,VacuumTime->Automatic,MaxVacuumTime->0.5 Hour,Output->Options],VacuumTime],
			0.5 Hour
		],
		Example[{Options,SpargingGas,"SpargingGas for Sparging will default to Argon if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,SpargingGas->Automatic,Output->Options],SpargingGas],
			Nitrogen
		],
		Example[{Options,SpargingTime,"SpargingTime for Sparging will default to 30 Minute if it is left as Automatic:"},
			Lookup[ExperimentDegas[Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],DegasType->Sparging,SpargingTime->Automatic,Output->Options],SpargingTime],
			30 Minute
		],
		Example[{Options, SpargingMix, "Automatically resolve SpargingMix to False if DegasType is set to Sparging:"},
			Lookup[
				ExperimentDegas[
					Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],
					DegasType -> Sparging,
					SpargingMix -> Automatic,
					Output -> Options],
				SpargingMix
			],
			False
		],
		Example[{Options,HeadspaceGasFlushTime,"HeadspaceGasFlushTime will default to 10 minutes if HeadspaceGasFlush is set:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlush->Nitrogen,Output->Options];
			Lookup[options,HeadspaceGasFlushTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options,HeadspaceGasFlushTime,"HeadspaceGasFlushTime will default to Null if HeadspaceGasFlush is None:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlush->None,Output->Options];
			Lookup[options,HeadspaceGasFlushTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,HeadspaceGasFlush,"HeadspaceGasFlush will default to None if HeadspaceGasFlushTime is Null:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlushTime->Null,Output->Options];
			Lookup[options,HeadspaceGasFlush],
			None
		],
		Example[{Options,HeadspaceGasFlush,"HeadspaceGasFlush will default to Nitrogen if HeadspaceGasFlushTime is set:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				HeadspaceGasFlushTime->2 Minute,Output->Options];
			Lookup[options,HeadspaceGasFlush],
			Nitrogen,
			Variables :> {options}
		],
		Test["If DegasType is VacuumDegas automatically populate TeflonTape:",
			Download[ExperimentDegas[Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],DegasType->VacuumDegas], TeflonTape],
			ObjectP[],
			SubCategory->TeflonTape
		],

		(*testing batching*)
		Test["If the experiment is a Sparging experiment, Impeller is informed:",
			batch=Download[ExperimentDegas[Object[Sample, "Degas Test Water Sample8 5L Bottle"<> $SessionUUID],Upload->True],BatchedDegasParameters];
			Lookup[batch,Impeller],
			{LinkP[Model[Part,StirrerShaft]]}
		],

		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples to be degassed:"},
			protocol = ExperimentDegas[
				"Degas sample 1",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Degas sample 1",
						Container -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "Degas sample 1",
						Amount -> 4 Milliliter
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		(*incubate options*)
		Example[{Options,Incubate,"Degas a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Degas a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Degas a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Degas a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature->30 Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Degas a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],IncubateAliquot->50 Microliter,IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquot],
			50 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample2" <> $SessionUUID], IncubateAliquot -> 90 Microliter, IncubateAliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)]},
			Variables :> {options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired,Warning::ContainerCentrifugeIncompatible}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],CentrifugeAliquot->1.8 Milliliter,Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeIntensity->1000*RPM,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeTime->5*Minute,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeAliquot->1.5*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeAliquot->20*Microliter,CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->1.8 Milliliter,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterAliquot->1.8 Milliliter,FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterAliquot->1.9 Milliliter, FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test DCM Sample2"<> $SessionUUID],DegasType->VacuumDegas,PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterPoreSize->0.22*Micrometer,FilterAliquot->1.8 Milliliter,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test DCM Sample2"<> $SessionUUID],PrefilterPoreSize->1.*Micrometer,DegasType->VacuumDegas,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->2 Milliliter,FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes used in this experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test DCM Sample2"<> $SessionUUID],DegasType->VacuumDegas,FilterHousing->Null,Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterSterile->False,Output->Options];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],*)
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->95*Microliter,Output->Options];
			Lookup[options,FilterAliquot],
			95*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],FilterAliquot->1.7 Milliliter, FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Degas a single liquid sample by first aliquotting the sample:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample2" <> $SessionUUID], AliquotAmount -> 2 * Milliliter, AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, AliquotAmount],
			2 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],AssayVolume->95*Microliter,Output->Options];
			Lookup[options,AssayVolume],
			95*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentDegas[Object[Sample,"Test Sample for ExperimentDegas with concentration"<> $SessionUUID],TargetConcentration->4*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			4*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentDegas[Object[Sample,"Test Sample for ExperimentDegas with concentration"<> $SessionUUID],TargetConcentration->4*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Uracil"],Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Uracil"]],
			Variables:>{options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample2" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 20 * Microliter, AssayVolume -> 100 * Microliter, AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample2" <> $SessionUUID], BufferDilutionFactor -> 2, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 25 * Microliter, AssayVolume -> 100 * Microliter, AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, BufferDilutionFactor],
			2,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample2" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 2, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 25 * Microliter, AssayVolume -> 100 * Microliter, AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample1" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 25 * Microliter, AssayVolume -> 100 * Microliter, AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container, Vessel, "10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentDegas[Object[Sample, "Degas Test Water Sample1" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container,Vessel,"10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "id:pZx9joxev3k0"] (*Model[Container,Vessel,"10 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*)]}},
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],SamplesInStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition,"Indicates how any recouped samples from the experiment should be stored:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],SamplesOutStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Test["Indicates how any recouped samples from the experiment should be stored, and uploads it to the protocol:",
			Download[ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],SamplesOutStorageCondition->Refrigerator],SamplesOutStorage],
			{Refrigerator},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],IncubateAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Name->"My Exploratory Degas Test Protocol",Output->Options];
			Lookup[options,Name],
			"My Exploratory Degas Test Protocol",
			Variables :> {options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Template->Object[Protocol,Degas,"Parent Protocol for ExperimentDegas testing"<> $SessionUUID],Output->Options];
			Lookup[options,FreezeTime],
			55 Minute,
			Variables :> {options}
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentDegas[Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Messages:>{Warning::ContainerCentrifugeIncompatible},
			TimeConstraint->240,
			Variables :> {options}
		],
		Test["Use a Degas primitive to call ExperimentSamplePreparation and generate a protocol:",
			ExperimentSamplePreparation[{
				Degas[
					Sample -> Object[Sample,"Degas Test Water Sample1"<> $SessionUUID]
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Use a Degas primitive to call ExperimentManualSamplePreparation and generate a protocol:",
			ExperimentManualSamplePreparation[{
				Degas[
					Sample -> Object[Sample,"Degas Test Water Sample1"<> $SessionUUID]
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			TimeConstraint -> 1000
		],
		Test["Degas simulation with some labels:",
			ExperimentDegas[
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				SampleLabel -> "best sample ever",
				SampleContainerLabel -> "best container ever",
				Output -> {Simulation, Options}
			],
			{
				SimulationP,
				_List
			}
		],
		Test["Populate the BatchedUnitOperations field:",
			prot=ExperimentDegas[
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID]
			];
			Download[prot, BatchedUnitOperations],
			{
				ObjectP[Object[UnitOperation, Degas]]
			},
			Variables :> {prot}
		],
		Test["Populate the OutputUnitOperations field with options:",
			prot=ExperimentDegas[
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				DegasType->FreezePumpThaw
			];
			Download[prot, BatchedUnitOperations[[1]][DegasType]],
			{
				FreezePumpThaw
			},
			Variables :> {prot}
		],
		(* -- SampleLabel -- *)
		Example[{Options, SampleLabel, "Label of the samples that are being analyzed:"},
			options = ExperimentDegas[
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				SampleLabel -> "fancy sample",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"fancy sample",
			Variables :> {options}
		],

		(* -- SampleContainerLabel -- *)
		Example[{Options, SampleContainerLabel, "Label of the sample container that are being analyzed:"},
			options = ExperimentDegas[
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],
				SampleContainerLabel -> "This is where we store the fancy sample",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"This is where we store the fancy sample",
			Variables :> {options}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
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
	),
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Vessel,"Degas 2mL Tube Container1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container2"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container3 for no volume"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container4 for not liquid"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container5"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container6 for no model"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas Test 50mL 1"<> $SessionUUID],(*yes discarded sample*)
				Object[Container,Vessel,"Degas Test 500mL Bottle1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas Test 50mL 2"<> $SessionUUID],
				Object[Container,Vessel,"Degas Test 5L Bottle1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container7 for concentration"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 10L Carboy for vacuum degas error"<> $SessionUUID],
				Object[Container,Vessel,"Degas Test 5L Bottle2"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample3 for no volume"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample4 for not liquid"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test DCM Sample2"<> $SessionUUID],
				Object[Sample,"Test discarded sample for ExperimentDegas"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample Severed Model"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],(*yes*)
				Object[Sample,"Test Sample for ExperimentDegas with concentration"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample9 10L carboy for vacuum degas error"<> $SessionUUID],
				Object[Sample,"Degas Test Water Sample10 5L Bottle"<> $SessionUUID],(*yes*)
				Object[Protocol,Degas,"Parent Protocol for ExperimentDegas testing"<> $SessionUUID],
				Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus object for ExperimentDegas"<> $SessionUUID],
				Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID],
				Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,SpargingApparatus,"Test SpargingApparatus object for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,Sonicator,"Test Sonicator instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,OverheadStirrer,"Test OverheadStirrer instrument for ExperimentDegas"<> $SessionUUID],
				Object[Item,Consumable,"Test Teflon Tape object for ExperimentDegas"<> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[{instFreezePumpThawApparatusModel,instVacuumDegasserModel,instSpargingApparatusModel,fakeNewModelID,
			testTube1,testTube2,testTube3,testTube4,testTube5,testTube6,testTube7,fiftyMLtube1,fiftyMLtube2,fivehundredMLbottle1,fiveLbottle1,carboy,fiveLbottle2,
			waterSample1,waterSample2,waterSampleNoVol3,waterSampleNotLiq4,dcmSamp1,waterSample6,concentrationSample,dcmSamp2,waterSampleModelSevered,waterSample7,waterSample8,waterSample9,waterSample10},

			{instFreezePumpThawApparatusModel,instVacuumDegasserModel,instSpargingApparatusModel}=Upload[{
				(*Create FreezePumpThawApparatus model with a unique material for measurement*)
				<|
					Type->Model[Instrument,FreezePumpThawApparatus],
					Name->"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID,
					Deprecated->False,
					NumberOfChannels->1,
					Dewar->Link[Model[Instrument, Dewar, "id:eGakldJWnpxz"]], (*Model[Instrument, Dewar, "500mL Dewar Flask"]*)
					HeatBlock->Link[Model[Instrument, HeatBlock, "id:jLq9jXvLGv7q"]], (*Model[Instrument, HeatBlock, "IKA HB Digital"]*)
					DeveloperObject->True
				|>,
				(*Create VacuumDegasser model with a unique material for measurement*)
				<|
					Type->Model[Instrument,VacuumDegasser],
					Name->"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID,
					VacuumPump -> Link[Model[Instrument, VacuumPump, "id:N80DNj18E15W"]], (*Model[Instrument, VacuumPump, "VACSTAR Control"]*)
					Sonicator -> Link[Model[Instrument, Sonicator, "Branson MH 5800"]], (*Model[Instrument, Sonicator, "Branson MH 5800"]*)
					Deprecated->False,
					NumberOfChannels->1,
					DeveloperObject->True
				|>,
				(*Create SpargingApparatus model with a unique material for measurement*)
				<|
					Type->Model[Instrument,SpargingApparatus],
					Name->"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID,
					Deprecated->False,
					NumberOfChannels->4,
					DeveloperObject->True
				|>
			}];

			(*create test sonicator object*)
			Upload[{
				<|
					Type->Object[Instrument,Sonicator],
					Name->"Test Sonicator instrument for ExperimentDegas"<> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(*create test mixer object*)
			Upload[{
				<|
					Type->Object[Instrument,OverheadStirrer],
					Name->"Test OverheadStirrer instrument for ExperimentDegas"<> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(*Create corresponding objects from the new models*)
			Upload[{
				<|
					Type->Object[Instrument,FreezePumpThawApparatus],
					Model->Link[Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID],Objects],
					Name->"Test FreezePumpThawApparatus object for ExperimentDegas"<> $SessionUUID,
					Status->Available,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type->Object[Instrument,VacuumDegasser],
					Model->Link[Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID],Objects],
					Name->"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID,
					Status->Available,
					Sonicator->Link[Object[Instrument,Sonicator,"Test Sonicator instrument for ExperimentDegas"<> $SessionUUID]],
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type->Object[Instrument,SpargingApparatus],
					Model->Link[Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],Objects],
					Name->"Test SpargingApparatus object for ExperimentDegas"<> $SessionUUID,
					Status->Available,
					Mixer->Link[Object[Instrument,OverheadStirrer,"Test OverheadStirrer instrument for ExperimentDegas"<> $SessionUUID]],
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create some fake teflon tape *)
			Upload[{
				<|
					Type->Object[Item,Consumable],
					Model->Link[Model[Item, Consumable, "id:N80DNjlYwV3o"],Objects],
					Name->"Test Teflon Tape object for ExperimentDegas"<> $SessionUUID,
					Status->Available,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(*Create a protocol that we'll use for template testing*)
			Upload[
				<|
					Type->Object[Protocol,Degas],
					Name->"Parent Protocol for ExperimentDegas testing"<> $SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site],
					ResolvedOptions->{FreezeTime->{55 Minute}}
				|>
			];

			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			fakeNewModelID=CreateID[Model[Container,Vessel]];

			(* Create some containers *)
			{
				testTube1,
				testTube2,
				testTube3,
				testTube4,
				testTube5,
				testTube6,
				testTube7,
				fiftyMLtube1,
				fiftyMLtube2,
				fivehundredMLbottle1,
				fiveLbottle1,
				carboy,
				fiveLbottle2
			}=Upload[{
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container1" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container2" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container3 for no volume" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container4 for not liquid" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container5" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container6 for no model" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:54n6evnwBGBq"] (*Model[Container, Vessel, "25 mL Schlenk Flask, 14/20 Outer Joint with Chem-Cap High Vacuum Valve"]*), Objects], Name -> "Degas 2mL Tube Container7 for concentration" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"] (*Model[Container, Vessel, "50mL Tube"]*), Objects], Name -> "Degas Test 50mL 1" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"] (*Model[Container, Vessel, "50mL Tube"]*), Objects], Name -> "Degas Test 50mL 2" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:aXRlGnZmOONB"] (*Model[Container, Vessel, "500mL Glass Bottle"]*), Objects], Name -> "Degas Test 500mL Bottle1" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:dORYzZJpO79e"] (*Model[Container, Vessel, "5L Glass Bottle"]*), Objects], Name -> "Degas Test 5L Bottle1" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:aXRlGnZmOOB9"] (*Model[Container, Vessel, "500mL Glass Bottle"]*), Objects], Name -> "Degas 10L Carboy for vacuum degas error" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:dORYzZJpO79e"] (*Model[Container, Vessel, "5L Glass Bottle"]*), Objects], Name -> "Degas Test 5L Bottle2" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSampleNoVol3,
				waterSampleNotLiq4,
				dcmSamp1,
				waterSample6,
				concentrationSample,
				dcmSamp2,
				waterSampleModelSevered,
				waterSample7,
				waterSample8,
				waterSample9,
				waterSample10
			} = UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:wqW9BP7Le7AM"], (*Model[Sample, "Sodium Chloride-Certified ACS"]*)
					Model[Sample, "id:54n6evKx00PL"], (*Model[Sample, "Dichloromethane, Anhydrous"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, StockSolution, "id:1ZA60vLrOJl8"], (*Model[Sample, StockSolution, "Red Food Dye Test Solution"]*)
					Model[Sample, "id:54n6evKx00PL"], (*Model[Sample, "Dichloromethane, Anhydrous"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"], (*Model[Sample, "Milli-Q water"]*)
					Model[Sample, "id:8qZ1VWNmdLBD"] (*Model[Sample, "Milli-Q water"]*)
				},
				{
					{"A1", testTube1},
					{"A1", testTube2},
					{"A1", testTube3},
					{"A1", testTube4},
					{"A1", testTube5},
					{"A1", fiftyMLtube1},
					{"A1", testTube7},
					{"A1", fiftyMLtube2},
					{"A1", testTube6},
					{"A1", fivehundredMLbottle1},
					{"A1", fiveLbottle1},
					{"A1", carboy},
					{"A1", fiveLbottle2}
				},
				InitialAmount->{
					10 Milliliter,
					12 Milliliter,
					10 Milliliter,
					100 Milligram,
					9.9 Milliliter,
					10 Milliliter,
					10 Milliliter,
					50 Milliliter,
					1.7 Milliliter,
					400 Milliliter,
					4.1 Liter,
					2.9 Liter,
					2 Liter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1,Name->"Degas Test Water Sample1"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSample2,Name->"Degas Test Water Sample2"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSampleNoVol3,Name->"Degas Test Water Sample3 for no volume"<> $SessionUUID,Status->Available,Volume->Null,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSampleNotLiq4,Name->"Degas Test Water Sample4 for not liquid"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->dcmSamp1,Name->"Degas Test DCM Sample1"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSample6,Name->"Test discarded sample for ExperimentDegas"<> $SessionUUID,Status->Discarded,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->concentrationSample,Name->"Test Sample for ExperimentDegas with concentration"<> $SessionUUID,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{5 Micromolar,Link[Model[Molecule,"Uracil"]],Now}},Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->dcmSamp2,Name->"Degas Test DCM Sample2"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSampleModelSevered,Name->"Degas Test Water Sample Severed Model"<> $SessionUUID,Status->Available,DeveloperObject->True,Model->Null|>,
				<|Object->waterSample7,Name->"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSample8,Name->"Degas Test Water Sample8 5L Bottle"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSample9,Name->"Degas Test Water Sample9 10L carboy for vacuum degas error"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>,
				<|Object->waterSample10,Name->"Degas Test Water Sample10 5L Bottle"<> $SessionUUID,Status->Available,Site->Link[$Site],DeveloperObject->True|>
			}];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{namedObjects},
			namedObjects={
				Object[Container,Vessel,"Degas 2mL Tube Container1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container2"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container3 for no volume"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container4 for not liquid"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container5"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container6 for no model"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas Test 50mL 1"<> $SessionUUID],(*yes discarded sample*)
				Object[Container,Vessel,"Degas Test 500mL Bottle1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas Test 50mL 2"<> $SessionUUID],
				Object[Container,Vessel,"Degas Test 5L Bottle1"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 2mL Tube Container7 for concentration"<> $SessionUUID],(*yes*)
				Object[Container,Vessel,"Degas 10L Carboy for vacuum degas error"<> $SessionUUID],
				Object[Container,Vessel,"Degas Test 5L Bottle2"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample1"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample2"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample3 for no volume"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample4 for not liquid"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test DCM Sample1"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test DCM Sample2"<> $SessionUUID],
				Object[Sample,"Test discarded sample for ExperimentDegas"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample Severed Model"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample7 500mL Bottle"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample8 5L Bottle"<> $SessionUUID],(*yes*)
				Object[Sample,"Test Sample for ExperimentDegas with concentration"<> $SessionUUID],(*yes*)
				Object[Sample,"Degas Test Water Sample9 10L carboy for vacuum degas error"<> $SessionUUID],
				Object[Sample,"Degas Test Water Sample10 5L Bottle"<> $SessionUUID],(*yes*)
				Object[Protocol,Degas,"Parent Protocol for ExperimentDegas testing"<> $SessionUUID],
				Model[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,FreezePumpThawApparatus,"Test FreezePumpThawApparatus object for ExperimentDegas"<> $SessionUUID],
				Model[Instrument,VacuumDegasser,"Test VacuumDegasser model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,VacuumDegasser,"Test VacuumDegasser object for ExperimentDegas"<> $SessionUUID],
				Model[Instrument,SpargingApparatus,"Test SpargingApparatus model instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,SpargingApparatus,"Test SpargingApparatus object for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,Sonicator,"Test Sonicator instrument for ExperimentDegas"<> $SessionUUID],
				Object[Instrument,OverheadStirrer,"Test OverheadStirrer instrument for ExperimentDegas"<> $SessionUUID],
				Object[Item,Consumable,"Test Teflon Tape object for ExperimentDegas"<> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		]
	),
	Stubs :> {
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	}
];
