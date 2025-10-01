(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentFlashFreeze*)


DefineTests[
	ExperimentFlashFreeze,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"FlashFreeze a sample:"},
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,FlashFreeze]]
		],
		Example[{Basic,"FlashFreeze multiple samples:"},
			ExperimentFlashFreeze[{Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID]},Upload->True],
			ObjectP[Object[Protocol,FlashFreeze]]
		],
		Example[{Basic,"FlashFreeze samples in the specified input container:"},
			ExperimentFlashFreeze[Object[Container,Vessel,"FlashFreeze 2mL Tube Container1" <> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,FlashFreeze]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Test["FlashFreeze a sample with a severed model:",
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample Severed Model" <> $SessionUUID],Upload->True],
			ObjectP[Object[Protocol,FlashFreeze]]
		],
		Test["Automatically aliquots plate samples into suitable containers:",
			ExperimentFlashFreeze[
				{
					Object[Sample,"FlashFreeze Test Water Sample in Plate1" <> $SessionUUID],
					Object[Sample,"FlashFreeze Test Water Sample in Plate2" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol,FlashFreeze]],
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentFlashFreeze[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentFlashFreeze[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentFlashFreeze[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentFlashFreeze[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentFlashFreeze[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentFlashFreeze[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		(* Messages: errors and warnings *)
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentFlashFreeze[Object[Sample,"Test discarded sample for ExperimentFlashFreeze" <> $SessionUUID]],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"FlashFreezeNoVolume","Return a warning if Sample contains Null in the Volume field:"},
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample3 for no volume" <> $SessionUUID]],
			ObjectP[Object[Protocol,FlashFreeze]],
			Messages:>{Warning::FlashFreezeNoVolume}
		],
		Example[{Messages,"MaxFreezeUntilFrozen","If MaxFreezingTime is set but FreezeUntilFrozen is False, an error will be thrown:"},
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],MaxFreezingTime->5 Hour,FreezeUntilFrozen->False],
			$Failed,
			Messages:>{Error::MaxFreezeUntilFrozen,Error::InvalidOption}
		],
		Example[{Messages,"MaxFreezingTimeMismatch","If FreezingTime is greater than MaxFreezingTime, an error will be thrown:"},
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],MaxFreezingTime->1 Minute,FreezingTime->2 Minute],
			$Failed,
			Messages:>{Error::MaxFreezingTimeMismatch,Error::InvalidOption}
		],
		Example[{Messages,"FlashFreezeSampleVolumeHighError","If the volume of the sample is greater than 50 Milliliter, an error will be thrown:"},
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample9 for high volume" <> $SessionUUID]],
			$Failed,
			Messages:>{Error::FlashFreezeSampleVolumeHighError,Error::InvalidOption,PreferredContainer::ContainerNotFound,Warning::OptionPattern}
		],
		Test["If the volume of the sample is greater than 50 Milliliter, an error will be thrown:",
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze large container sample" <> $SessionUUID]],
			ObjectP[Object[Protocol,FlashFreeze]],
			Messages:>{Warning::AliquotRequired}
		],
		(* set the options *)
		Example[{Messages,"FlashFreezeSampleInStorageWarnings","If the SamplesInStorageCondition is not CryogenicStorage, throw a warning:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],SamplesInStorageCondition->AmbientStorage,Output->Options],SamplesInStorageCondition],
			AmbientStorage,
			Messages:>{Warning::FlashFreezeSampleInStorageWarnings}
		],
		Example[{Messages,"FlashFreezeAliquotSampleStorageWarnings","If the AliquotSampleStorageCondition is not CryogenicStorage, throw a warning:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],AliquotSampleStorageCondition->AmbientStorage,Output->Options],AliquotSampleStorageCondition],
			AmbientStorage,
			Messages:>{Warning::FlashFreezeAliquotSampleStorageWarnings}
		],

		(* Options specific to ExperimentFlashFreeze *)
		Example[{Options,Instrument,"Specify the dewar instrument to flash freeze with:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				Instrument->Model[Instrument,Dewar,"Test Dewar model instrument for ExperimentFlashFreeze" <> $SessionUUID],Output->Options],Instrument],
			ObjectP[Model[Instrument,Dewar,"Test Dewar model instrument for ExperimentFlashFreeze" <> $SessionUUID]]
		],
		Test["Specify the dewar instrument to flash freeze with:",
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				Instrument->Object[Instrument,Dewar,"Test Dewar object for ExperimentFlashFreeze" <> $SessionUUID],Output->Options],Instrument],
			ObjectP[Object[Instrument,Dewar,"Test Dewar object for ExperimentFlashFreeze" <> $SessionUUID]]
		],
		Test["Specify the dewar instrument to flash freeze with and upload the experiment protocol:",
			ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				Instrument->Object[Instrument,Dewar,"Test Dewar object for ExperimentFlashFreeze" <> $SessionUUID]],
			ObjectP[Object[Protocol,FlashFreeze]]
		],
		Example[{Options,FreezingTime,"Specify the FreezingTime of the run:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				FreezingTime->50 Minute,Output->Options];
			Lookup[options,FreezingTime],
			50 Minute
		],
		Example[{Options,FreezeUntilFrozen,"Specify whether the sample should be flash frozen until it is fully frozen:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				FreezeUntilFrozen->True,Output->Options];
			Lookup[options,FreezeUntilFrozen],
			True
		],
		Example[{Options,MaxFreezingTime,"Specify the maximum freezing time for a sample that is set to be flash frozen until it is fully frozen:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],
				FreezeUntilFrozen->True,MaxFreezingTime->2 Hour,Output->Options];
			Lookup[options,MaxFreezingTime],
			2 Hour
		],

		(* resolving automatic *)
		Example[{Options,Instrument,"Instrument will default to \"Low Form Foam Dewar Flask\" if it is left as Automatic:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Instrument->Automatic,Output->Options],Instrument],
			Model[Instrument,Dewar,"Low Form Foam Dewar Flask"]
		],
		Example[{Options,FreezingTime,"FreezingTime will default based on the sample volume if it is left as Automatic. If Sample Volume<500uL, FreezingTime will default to 1 minute:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FreezingTime->Automatic,Output->Options],FreezingTime],
			30 Second
		],
		Example[{Options,FreezingTime,"FreezingTime will default based on the sample volume if it is left as Automatic. If Sample Volume<1mL, FreezingTime will default to 5 minutes:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FreezingTime->Automatic,Output->Options],FreezingTime],
			1 Minute
		],
		Example[{Options,FreezingTime,"FreezingTime will default based on the sample volume if it is left as Automatic. If Sample Volume>=1mL, FreezingTime will default to 30 minutes:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],FreezingTime->Automatic,Output->Options],FreezingTime],
			2 Minute
		],
		Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition will default to CryogenicStorage if it is left as Automatic:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],Output->Options],SamplesInStorageCondition],
			CryogenicStorage
		],
		Test["SamplesInStorageCondition will default to CryogenicStorage if it is left as Automatic, and this will be updated in the protocol object:",
			Download[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID]],SamplesInStorage],
			{CryogenicStorage}
		],
		Test["SamplesInStorageCondition can be set, and this will be updated in the protocol object:",
			Download[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],SamplesInStorageCondition->Refrigerator],SamplesInStorage],
			{Refrigerator},
			Messages:>{Warning::FlashFreezeSampleInStorageWarnings}
		],

		(* Other additional unit tests *)
		(*post processing options*)
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Specify whether to image the sample after measurement in the post processing step:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be flash frozen:"},
			protocol=ExperimentFlashFreeze["Flash Freeze sample 1",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Flash Freeze sample 1",
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"Flash Freeze sample 1",Amount->50*Microliter
					]
				}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		(*incubate options*)
		Example[{Options,Incubate,"Flash freeze a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Flash freeze a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Flash freeze a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Flash freeze a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature->30 Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Flash freeze a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			Lookup[ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options],IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],IncubateAliquot->50 Microliter,IncubateAliquotContainer->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,IncubateAliquot],
			50 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],IncubateAliquot->90 Microliter,IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeTemperature->30*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeAliquot->5*Microliter,CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquot],
			5*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeAliquot->20*Microliter,CentrifugeAliquotContainer->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"]]},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Filter->Model[Container, Plate, Filter, "id:eGakld0955Lo"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Container, Plate, Filter, "id:eGakld0955Lo"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],

		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test DCM Sample2" <> $SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterPoreSize->0.22*Micrometer,FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],

		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test DCM Sample2" <> $SessionUUID],PrefilterPoreSize->1.*Micrometer,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes we would use in this experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterHousing->Null,FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->90 Microliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],FilterSterile->False,Output->Options];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],*)
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],FilterAliquot->95*Microliter,Output->Options];
			Lookup[options,FilterAliquot],
			95*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Flash freeze a single liquid sample by first aliquotting the sample:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],Aliquot->True,AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotSampleLabel,"Flash freeze a single liquid sample by first aliquotting the sample with a label:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],Aliquot->True,AliquotSampleStorageCondition->CryogenicStorage,AliquotSampleLabel->"aliquot sample label 1",Output->Options];
			Lookup[options,AliquotSampleLabel],
			{"aliquot sample label 1"},
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],AliquotAmount->35*Microliter,AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,AliquotAmount],
			35*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],AssayVolume->95*Microliter,AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,AssayVolume],
			95*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"Test Sample for ExperimentFlashFreeze with concentration" <> $SessionUUID],TargetConcentration->5*Micromolar,AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentFlashFreeze[Object[Sample,"Test Sample for ExperimentFlashFreeze with concentration" <> $SessionUUID],TargetConcentration->5*Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Uracil"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Uracil"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->20*Microliter,AssayVolume->150*Microliter,AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->100*Microliter,AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,BufferDilutionFactor],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->100*Microliter,AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->25*Microliter,AssayVolume->100*Microliter,AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::FlashFreezeAliquotSampleStorageWarnings}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],AliquotContainer->Model[Container,Vessel,"2mL Tube"],AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],SamplesInStorageCondition->Refrigerator,Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::FlashFreezeSampleInStorageWarnings}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],IncubateAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],FilterContainerOut->Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],DestinationWell->"A1",AliquotSampleStorageCondition->CryogenicStorage,Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentFlashFreeze[
				{Model[Sample, "id:8qZ1VWNmdLBD"](* Milli-Q water *), Model[Sample, "id:8qZ1VWNmdLBD"](* Milli-Q water *)},
				PreparedModelContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"](* 50mL Tube *),
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentFlashFreeze[
				Model[Sample, "Milli-Q water"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, FlashFreeze]]
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Name->"My Exploratory FlashFreeze Test Protocol",Output->Options];
			Lookup[options,Name],
			"My Exploratory FlashFreeze Test Protocol"
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Template->Object[Protocol,FlashFreeze,"Parent Protocol for ExperimentFlashFreeze testing" <> $SessionUUID],Output->Options];
			Lookup[options,FreezingTime],
			55 Minute
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentFlashFreeze[Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options,AliquotSampleStorageCondition->CryogenicStorage];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			(*Variables :> {options},
			Messages:>{Warning::ContainerCentrifugeIncompatible},*)
			TimeConstraint->240
		]
	},
	(* un comment this out when Variables works the way we would expect it to*)
	(* Variables :> {$SessionUUID},*)
	SymbolSetUp:>{
		ClearMemoization[];
		$CreatedObjects={};

		(*Quieting any warnings thrown out for SamplesOutOfStock while running the unit tests*)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects,instModel,fakeNewModelID,testTube1, testTube2, testTube3, testTube4, testTube5, testTube6, testTube7, testTube8, fiftyMLtube2, testbottle9, largeContainer, plate, waterSample1, waterSample2, waterSampleNoVol3, waterSampleNotLiq4, waterSample5, waterSample6, dcmSamp2, waterSampleModelSevered, concentrationSample, waterSample9, largeContainerSample, plateSample1, plateSample2},
			namedObjects={
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container1" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container2" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container3 for no volume" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container4 for not liquid" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container5" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container6 for no model" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container7" <> $SessionUUID],(*yes discarded sample*)
				Object[Container,Vessel,"FlashFreeze 2mL Tube Container8 for concentration" <> $SessionUUID],(*yes*)
				Object[Container,Vessel,"FlashFreeze 100 mL Glass Bottle Container9 for high volume" <> $SessionUUID],
				Object[Container,Vessel,"FlashFreeze Test 50mL 2" <> $SessionUUID],
				Object[Container,Vessel,"FlashFreeze large container" <> $SessionUUID],
				Object[Container,Plate,"FlashFreeze plate container" <> $SessionUUID],
				Object[Sample,"FlashFreeze Test Water Sample1" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test Water Sample2" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test Water Sample3 for no volume" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test Water Sample4 for not liquid" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test Water Sample5" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test DCM Sample2" <> $SessionUUID],
				Object[Sample,"Test discarded sample for ExperimentFlashFreeze" <> $SessionUUID],(*yes*)
				Object[Sample,"Test Sample for ExperimentFlashFreeze with concentration" <> $SessionUUID],(*yes*)
				Object[Sample,"FlashFreeze Test Water Sample9 for high volume" <> $SessionUUID],
				Object[Sample,"FlashFreeze large container sample" <> $SessionUUID],
				Object[Sample,"FlashFreeze Test Water Sample in Plate1" <> $SessionUUID],
				Object[Sample,"FlashFreeze Test Water Sample in Plate2" <> $SessionUUID],
				Object[Protocol,FlashFreeze,"Parent Protocol for ExperimentFlashFreeze testing" <> $SessionUUID],
				Object[Sample,"FlashFreeze Test Water Sample Severed Model" <> $SessionUUID],(*yes*)
				Model[Instrument,Dewar,"Test Dewar model instrument for ExperimentFlashFreeze" <> $SessionUUID],
				Object[Instrument,Dewar,"Test Dewar object for ExperimentFlashFreeze" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			];


		{instModel}=Upload[{
			(*Create dewar model with a unique material for measurement*)
			<|
				Type -> Model[Instrument, Dewar],
				Name -> "Test Dewar model instrument for ExperimentFlashFreeze" <> $SessionUUID,
				LiquidNitrogenCapacity -> 500 Milliliter,
				Deprecated -> False,
				DeveloperObject -> True
			|>
		}];

		(*Create a dewar object from the new models*)
		Upload[{
			<|
				Type -> Object[Instrument, Dewar],
				Model -> Link[Model[Instrument, Dewar, "Test Dewar model instrument for ExperimentFlashFreeze" <> $SessionUUID], Objects],
				Name -> "Test Dewar object for ExperimentFlashFreeze" <> $SessionUUID,
				Status -> Available,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>
		}];


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
			testTube8,
			fiftyMLtube2,
			testbottle9,
			largeContainer,
			plate
		}=Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Objects],Name->"FlashFreeze 2mL Tube Container1" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"0.5mL Tube with 2mL Tube Skirt"],Objects],Name->"FlashFreeze 2mL Tube Container2" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container3 for no volume" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container4 for not liquid" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container5" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container6 for no model" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container7" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"FlashFreeze 2mL Tube Container8 for concentration" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"FlashFreeze Test 50mL 2" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "100 mL Glass Bottle"],Objects],Name->"FlashFreeze 100 mL Glass Bottle Container9 for high volume" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "1000mL Glass Beaker"],Objects],Name->"FlashFreeze large container" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			(* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
			<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "id:L8kPEjkmLbvW"],Objects],Name->"FlashFreeze plate container" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>
		}];

		(* Create some samples *)
		{
			waterSample1,
			waterSample2,
			waterSampleNoVol3,
			waterSampleNotLiq4,
			waterSample5,
			waterSample6,
			dcmSamp2,
			waterSampleModelSevered,
			concentrationSample,
			waterSample9,
			largeContainerSample,
			plateSample1,
			plateSample2
		} = UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Dichloromethane, Anhydrous"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Red Food Dye Test Solution"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",testTube1},
				{"A1",testTube2},
				{"A1",testTube3},
				{"A1",testTube4},
				{"A1",testTube5},
				{"A1",testTube7},
				{"A1",fiftyMLtube2},
				{"A1",testTube6},
				{"A1",testTube8},
				{"A1",testbottle9},
				{"A1",largeContainer},
				{"A1",plate},
				{"A2",plate}
			},
			InitialAmount->{
				40 Microliter,
				600 Microliter,
				1 Milliliter,
				1.5 Milliliter,
				1.5 Milliliter,
				1.5 Milliliter,
				5 Milliliter,
				1.7 Milliliter,
				100 Microliter,
				80 Milliliter,
				40 Milliliter,
				1.5 Milliliter,
				1.5 Milliliter
			},
			StorageCondition->AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample1,Name->"FlashFreeze Test Water Sample1" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample2,Name->"FlashFreeze Test Water Sample2" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSampleNoVol3,Name->"FlashFreeze Test Water Sample3 for no volume" <> $SessionUUID,Status->Available,Volume->Null,DeveloperObject->True|>,
			<|Object->waterSampleNotLiq4,Name->"FlashFreeze Test Water Sample4 for not liquid" <> $SessionUUID,Status->Available,State->Null,DeveloperObject->True|>,
			<|Object->waterSample5,Name->"FlashFreeze Test Water Sample5" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample6,Name->"Test discarded sample for ExperimentFlashFreeze" <> $SessionUUID,Status->Discarded,DeveloperObject->True|>,
			<|Object->dcmSamp2,Name->"FlashFreeze Test DCM Sample2" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSampleModelSevered,Name->"FlashFreeze Test Water Sample Severed Model" <> $SessionUUID,Status->Available,DeveloperObject->True,Model->Null|>,
			<|Object->concentrationSample,Name->"Test Sample for ExperimentFlashFreeze with concentration" <> $SessionUUID,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{10 Micromolar,Link[Model[Molecule,"Uracil"]],Now}},Status->Available,DeveloperObject->True|>,
			<|Object->waterSample9,Name->"FlashFreeze Test Water Sample9 for high volume" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->largeContainerSample,Name->"FlashFreeze large container sample" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->plateSample1,Name->"FlashFreeze Test Water Sample in Plate1" <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->plateSample2,Name->"FlashFreeze Test Water Sample in Plate2" <> $SessionUUID,Status->Available,DeveloperObject->True|>

		}];

		(*Create a protocol that we'll use for template testing*)
		Upload[
			<|
				Type->Object[Protocol,FlashFreeze],
				Name->"Parent Protocol for ExperimentFlashFreeze testing" <> $SessionUUID,
				DeveloperObject->True,
				ResolvedOptions->{FreezingTime->{55 Minute}}
			|>
		];
	]},
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},

	SymbolTearDown:>{
		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];

		(*Turning on the warnings after running unit tests*)
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];


		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
];
(* ::Subsection:: *)
(*uploadFlashFreezeFullyFrozen*)

DefineTests[
	uploadFlashFreezeFullyFrozen,
	{
		Example[{Basic,"Test with empty FlashFreeze protocol:"},
			uploadFlashFreezeFullyFrozen[Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID]];
			Download[Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID],FullyFrozen],
			{True}
		],
		Example[{Basic,"Test with non-empty FlashFreeze protocol:"},
			uploadFlashFreezeFullyFrozen[Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID]];
			Download[Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID],FullyFrozen],
			{True,True}
		]
	},

	SymbolSetUp:>{
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID],
					Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
		Module[{protIDs},
			protIDs = CreateID[{Object[Protocol,FlashFreeze],Object[Protocol,FlashFreeze]}];
			Upload[
				{
					<|
						Object->protIDs[[1]],
						Name->"Test protocol 1 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID
					|>,
					<|
						Object->protIDs[[2]],
						Name->"Test protocol 2 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID,
						Replace[FullyFrozen]->{True}
					|>
				}
			]
		];

	},


	SymbolTearDown:>{
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID],
					Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeFullyFrozen tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
	}
];


(* ::Subsection:: *)
(*uploadFlashFreezeNotFullyFrozen*)

DefineTests[
	uploadFlashFreezeNotFullyFrozen,
	{
		Example[{Basic,"Test with empty FlashFreeze protocol:"},
			uploadFlashFreezeNotFullyFrozen[Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID]];
			Download[Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID],FullyFrozen],
			{False}
		],
		Example[{Basic,"Test with non-empty FlashFreeze protocol:"},
			uploadFlashFreezeNotFullyFrozen[Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID]];
			Download[Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID],FullyFrozen],
			{True,False}
		]
	},

	SymbolSetUp:>{
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID],
					Object[Protocol,FlashFreeze,"Test protocol 2 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
		Module[{protIDs},
			protIDs = CreateID[{Object[Protocol,FlashFreeze],Object[Protocol,FlashFreeze]}];
			Upload[
				{
					<|
						Object->protIDs[[1]],
						Name->"Test protocol 1 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID
					|>,
					<|
						Object->protIDs[[2]],
						Name->"Test protocol 2 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID,
						Replace[FullyFrozen]->{True}
					|>
				}
			]
		];

	},


	SymbolTearDown:>{
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Protocol,FlashFreeze,"Test protocol 1 for uploadFlashFreezeNotFullyFrozen tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
	}
];


