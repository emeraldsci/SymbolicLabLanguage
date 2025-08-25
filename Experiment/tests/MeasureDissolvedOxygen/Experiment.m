(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureDissolvedOxygen : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureDissolvedOxygen*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDissolvedOxygen*)


DefineTests[
	ExperimentMeasureDissolvedOxygen,
	{
		Example[{Basic,"Measure the dissolved oxygen of a single sample:"},
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Measure the dissolved oxygen of a multiple samples:"},
			ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]}],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		(*Experiment Specific Options*)
		Example[{Options,Instrument,"Measure the dissolved oxygen of a single liquid sample by specifying a specific instrument object or model:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Instrument->Model[Instrument, DissolvedOxygenMeter, "id:01G6nvw1qEPd"],Output->Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, DissolvedOxygenMeter, "id:01G6nvw1qEPd"]],
			Variables :> {options}
		],
		Example[{Options,DissolvedOxygenCalibrationType,"The type of calibration to performed on the dissolved oxygen meter prior to experiment:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},DissolvedOxygenCalibrationType->TwoPoint,Output->Options];
			Lookup[options, DissolvedOxygenCalibrationType],
			TwoPoint,
			Variables :> {options}
		],
		Example[{Options,DissolvedOxygenCalibrationType,"Resolve the type of calibration to performed on the dissolved oxygen meter prior to experiment to OnePoint:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				Output->Options];
			Lookup[options, DissolvedOxygenCalibrationType],
			OnePoint,
			Variables :> {options}
		],
		Example[{Options,DissolvedOxygenCalibrationType,"Resolve the type of calibration to performed on the dissolved oxygen meter prior to experiment to TwoPoint:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				ZeroOxygenCalibrant->Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Output->Options];
			Lookup[options, DissolvedOxygenCalibrationType],
			TwoPoint,
			Variables :> {options}
		],
		Example[{Options,OxygenSaturatedCalibrant,"The buffer with 100% oxygen saturation that should be used to calibrate the dissolved oxygen meter:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},OxygenSaturatedCalibrant->Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Output->Options];
			Lookup[options, OxygenSaturatedCalibrant],
			ObjectP[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,OxygenSaturatedCalibrant,"The buffer with 100% oxygen saturation that should be used to calibrate the dissolved oxygen meter:"},
			protocol=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},OxygenSaturatedCalibrant->Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]];
			Download[protocol, OxygenSaturatedCalibrant],
			ObjectP[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options,ZeroOxygenCalibrant,"Set the buffer with 0% oxygen saturation solution that should be used to calibrate the dissolved oxygen meter:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				ZeroOxygenCalibrant->Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Output->Options];
			Lookup[options, ZeroOxygenCalibrant],
			ObjectP[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,ZeroOxygenCalibrant,"Resolve the buffer with 0% oxygen saturation solution that should be used to calibrate the dissolved oxygen meter:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				DissolvedOxygenCalibrationType->TwoPoint,Output->Options];
			Lookup[options, ZeroOxygenCalibrant],
			ObjectP[Model[Sample,"Zero Oxygen Solution"]],
			Variables :> {options}
		],
		Example[{Options,ZeroOxygenCalibrant,"Set the buffer with 0% oxygen saturation solution that should be used to calibrate the dissolved oxygen meter:"},
			protocol=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				ZeroOxygenCalibrant->Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]];
			Download[protocol, ZeroOxygenCalibrant],
			ObjectP[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options,ZeroOxygenCalibrant,"Resolve the buffer with 0% oxygen saturation to Null:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},DissolvedOxygenCalibrationType->OnePoint,Output->Options];
			Lookup[options, ZeroOxygenCalibrant],
			Null,
			Variables :> {options}
		],
		Example[{Options,NumberOfReadings,"Measure the dissolved oxygen of multiple liquid samples by taking a specific number of readings:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},NumberOfReadings->{1,4},Output->Options];
			Lookup[options, NumberOfReadings],
			{1,4},
			Variables :> {options}
		],
		Example[{Options,NumberOfReadings,"Measure the dissolved oxygen of multiple liquid samples by taking a specific number of readings:"},
			protocol=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},NumberOfReadings->{1,5}];
			Download[protocol, NumberOfReadings],
			{1,5},
			Variables :> {protocol}
		],
		Example[{Options,Stir,"Measure the dissolved oxygen of multiple liquid samples by taking a specific number of readings:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},Stir->{False,True},Output->Options];
			Lookup[options, Stir],
			{False,True},
			Variables :> {options}
		],
		Example[{Options,Stir,"Measure the dissolved oxygen of multiple liquid samples by taking a specific number of readings:"},
			protocol=ExperimentMeasureDissolvedOxygen[{Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},Stir->{False,True}];
			Download[protocol, Stir],
			{False,True},
			Variables :> {protocol}
		],
		(*---General options---*)
		Example[{Options,Name,"Measure the dissolved oxygen of a single liquid sample with a Name specified for the protocol:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Name->"Measure dissolved oxygen test Name.",Output->Options];
			Lookup[options,{Name}],
			{"Measure dissolved oxygen test Name."},
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for dissolved oxygen measurement:"},
			packet=First@ExperimentMeasureDissolvedOxygen[{"WaterSample Container 1", "WaterSample Container 2", "WaterSample Container 3","WaterSample Container 4"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label->"WaterSample Container 1",Container->Model[Container, Vessel, "50mL Tube"]],
					LabelContainer[Label->"WaterSample Container 2",Container->Model[Container, Vessel, "50mL Tube"]],
					LabelContainer[Label->"WaterSample Container 3",Container->Model[Container, Vessel, "50mL Tube"]],
					LabelContainer[Label->"WaterSample Container 4",Container->Model[Container, Vessel, "50mL Tube"]],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->40 Milliliter, Destination->"WaterSample Container 1"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->40 Milliliter, Destination->"WaterSample Container 2"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->40 Milliliter, Destination->"WaterSample Container 3"],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->40 Milliliter,Destination->"WaterSample Container 4"]
				},
				ImageSample -> False, MeasureVolume -> False, Upload -> False];
			Length[Lookup[packet,Replace[SamplesIn]]],
			4,
			Variables :> {packet}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for the calibrant:"},
			protocol=ExperimentMeasureDissolvedOxygen[
				Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				ZeroOxygenCalibrant -> "wash",
				PreparatoryUnitOperations -> {
					LabelSample[Label -> "wash", Sample -> Model[Sample, "Milli-Q water"], Amount->40 Milliliter, Container -> Model[Container, Vessel, "50mL Tube"]]
				}
			];
			Download[protocol,ZeroOxygenCalibrant],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {protocol}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasureDissolvedOxygen[
				Model[Sample, "Milli-Q water"],
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 45 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasureDissolvedOxygen[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 40 Milliliter,
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
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..},
				{EqualP[40 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],

		Example[{Basic,"Setting Aliquot->True will take an aliquot of your sample for dissolved oxygen measurement - this is often used to prevent sample contamination:"},
			ExperimentMeasureDissolvedOxygen[Object[Container,Vessel,"Test container 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Aliquot->True,AliquotAmount->25Milliliter],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Options,NumberOfReplicates,"Measure the dissolved oxygen of a single liquid sample by specifying a NumberOfReplicates, in this case, repeatedly measuring the sample:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],NumberOfReplicates->2,Output->Options];
			Lookup[options, NumberOfReplicates],
			2,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], SamplesInStorageCondition->Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		(*---Post Processing options---*)
		Example[{Options,ImageSample,"Measure the dissolved oxygen of a single liquid sample and do not take an image afterwards:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables :> {options}
		],
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		(*---incubate options---*)
		Example[{Options,Incubate,"Measure the dissolved oxygen of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Measure the dissolved oxygen of a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Measure the dissolved oxygen of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
		  options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
		  Lookup[options,MaxIncubationTime],
		  1 Hour,
		  Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Measure the dissolved oxygen of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature -> 30 Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Measure the dissolved oxygen of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],

		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				IncubateAliquot->45Milliliter,
				IncubateAliquotContainer->Model[Container, Vessel, "50mL Tube"],Output->Options];
			Lookup[options,IncubateAliquot],
			45 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				IncubateAliquot->45 Milliliter,
				IncubateAliquotContainer->Model[Container, Vessel, "50mL Tube"],
				Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables:>{options}
		],
		(*---Mix options---*)
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],
		(*---centrifuge options---*)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				CentrifugeAliquot -> 25*Milliliter,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquot],
			25*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeAliquot -> 25*Milliliter,CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(*---filter options---*)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],PrefilterMaterial -> GxF,FilterMaterial->PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Large test water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				FilterAliquot -> 25 Milliliter,
				FiltrationType -> Centrifuge,
				FilterIntensity -> 1000*RPM,
				Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterAliquot ->25 Milliliter,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				FilterAliquot -> 25 Milliliter,
				FiltrationType -> Centrifuge,
				FilterTemperature -> 22*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Large test water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterAliquot -> 25*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			25*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(*---Aliquot options---*)
		Example[{Options,Aliquot,"Measure the dissolved oxygen of a single liquid sample by first aliquoting the sample:"},
			options=ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				AliquotAmount -> 45*Milliliter,
				AliquotContainer -> Model[Container, Vessel, "150 mL Glass Bottle"], Output -> Options];
			Lookup[options, AliquotAmount],
			45*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentMeasureDissolvedOxygen[
				Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], AssayVolume -> 45*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			45*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDissolvedOxygen[
				Object[Sample,"Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				TargetConcentration -> 1*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Template->Null];
			Download[protocol,Template],
			Null,
			Variables:>{protocol}
		],
		Example[{Options, TargetConcentrationAnalyte,  "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				TargetConcentration -> 1 Micromolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Uracil"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->5*Milliliter,
				AssayVolume->45*Milliliter,
				AliquotContainer -> Model[Container, Vessel, "150 mL Glass Bottle"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->4.5*Milliliter,
				AssayVolume->45*Milliliter,
				AliquotContainer -> Model[Container, Vessel, "150 mL Glass Bottle"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->5*Milliliter,AssayVolume->45*Milliliter,
				AliquotContainer -> Model[Container, Vessel, "150 mL Glass Bottle"],
				Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->5*Milliliter,
				AssayVolume->45*Milliliter,
				AliquotContainer ->Model[Container, Vessel, "150 mL Glass Bottle"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "150 mL Glass Bottle"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "150 mL Glass Bottle"]]}},
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDissolvedOxygen[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		(*---Error Messages---*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureDissolvedOxygen[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureDissolvedOxygen[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureDissolvedOxygen[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureDissolvedOxygen[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","Return an error for a discarded sample:"},
			ExperimentMeasureDissolvedOxygen[Object[Sample, "Test discarded sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NoVolume","Return an error for samples that do not have a volume:"},
			ExperimentMeasureDissolvedOxygen[Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::NoVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InsufficientVolume","Return an error for too low sample volume, thereby incapable of measurement:"},
			ExperimentMeasureDissolvedOxygen[Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InsufficientVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"EmptyContainers","Return an error for a container without a sample:"},
			ExperimentMeasureDissolvedOxygen[Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::EmptyContainers
			}
		],
		Example[{Messages,"MustSpecifyZeroOxygenCalibrant","If DissolvedOxygenCalibrationType is TwoPoint and the ZeroOxygenCalibrant is Null, throw an error:"},
			ExperimentMeasureDissolvedOxygen[{Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				DissolvedOxygenCalibrationType->TwoPoint,
				ZeroOxygenCalibrant->Null
			],
			$Failed,
			Messages:>{
				Error::MustSpecifyZeroOxygenCalibrant,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConfictingZeroOxygenCalibrant","If DissolvedOxygenCalibrationType is OnePoint and the ZeroOxygenCalibrant is given, throw an error:"},
			options=ExperimentMeasureDissolvedOxygen[{Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]},
				DissolvedOxygenCalibrationType->OnePoint,
				ZeroOxygenCalibrant->Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,DissolvedOxygenCalibrationType],
			OnePoint,
			Variables :>{options},
			Messages:>{
				Error::ConfictingZeroOxygenCalibrant,
				Error::InvalidOption
			}
		],
		Test["If the sample is in a container that has too for the stir paddle, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Stir->True
			],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the sample is in a container that has too small aperture, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container with small aperture for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the sample is in a uncalibrated container that has a liquid level below detection height, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the sample is in a calibrated container that has a liquid level below detection height, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container that is too low for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the sample is in an uncalibrated container that the probe cannot reach, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container with no calibration for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the sample is in an uncalibrated container that the probe can reach, no aliquot will be performed:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]]
		],
		Test["If the sample is in an calibrated container that the probe cannot reach, it will be aliquotted:",
			ExperimentMeasureDissolvedOxygen[Object[Sample,"Test sample in container that cannot be reached for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDissolvedOxygen]],
			Messages :> {Warning::AliquotRequired}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Vessel, "Test container 1 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 2 with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 3 with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container,Vessel,"Test container 16 for solid sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container,Vessel,"Test container with small aperture for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Container,Vessel,"Test container with for low sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],

				Object[Sample, "Test discarded sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test calibration standard with no dissolved oxygen for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample, "Test solid sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container with small aperture for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container that cannot be reached for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Object[Sample,"Test sample in container that is too low for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],

				Model[Sample, "Test chemical model incompatible for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Sample, "Test chemical model incompatible with Sapphire for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Sample, "Test calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedOxygen"<> $SessionUUID],
				Model[Sample,"Test solid model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID](*,

				Object[Protocol, MeasureDissolvedOxygen, "Dissolved oxygen Test Template Protocol for ExperimentMeasureDissolvedOxygen"<> $SessionUUID]*)
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[testObjList];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					testObjList,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];

		Module[
			{ tooAcidicModel, containerNoCalModel1, containerNoCalModel2,
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer10, emptyContainer11, emptyContainer12,dropletModel,
				emptyContainer13, emptyContainer14, emptyContainer15,emptyContainer16,discardedSample, waterSample, lowVolSample,
			 tooAcidicSample, noVolumeSample,conductivitySample,emptyContainer18,noCalSample2,noCalSample,
				largeSample, milliQSample,modelLessSample,emptyContainer17, solidModel, solidSample,emptyContainer19,
				emptyContainer20,noCalSample3,containerNoCalModel3,smallAptSample,emptyContainer21,reachSample,lowSample},

			{
				containerNoCalModel1,
				containerNoCalModel2,
				containerNoCalModel3,
				solidModel
			} = Upload[{
				(*Create container model with no calibration data*)
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.28575`, "Meters"],
						Quantity[0.28575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.28575`, "Meters"],
						MaxDepth -> Quantity[0.28575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 2 with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.9143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.9143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 3 with no calibration data for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				(*Create a solid sample*)
				<|
					Type -> Model[Sample],
					Name -> "Test solid model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
					State -> Solid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True
				|>
			}];


		(* Create some empty containers *)
		{
			emptyContainer1,
			emptyContainer2,
			emptyContainer3,
			emptyContainer4,
			emptyContainer5,
			emptyContainer6,
			emptyContainer8,
			emptyContainer11,
			emptyContainer12,
			emptyContainer13,
			emptyContainer14,
			emptyContainer16,
			emptyContainer17,
			emptyContainer18,
			emptyContainer19,
			emptyContainer20,
			emptyContainer21
		}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
				Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],Objects],
				Name->"Test container 4 invalid for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 5 with no sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container, Vessel],
				Model->Link[Model[Container,Vessel,"10L Polypropylene Carboy"],Objects],
				Name->"Test container 6 that is too big for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 8 with incompatible sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 11 for No Volume sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[containerNoCalModel1,Objects],
				Name->"Test container 12 for no calibration for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container 13 for large sample volume for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"100 mL Glass Bottle"],Objects],
				Name->"Test container 14 for MilliQ water for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 16 for solid sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 17 for solution without a model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[containerNoCalModel2,Objects],
				Name->"Test container no calibration 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[containerNoCalModel3,Objects],
				Name->"Test container no calibration 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "250mg small glass amber bottle"],Objects],
				Name->"Test container with small aperture for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "500mL Glass Bottle"],Objects],
				Name->"Test container with for low sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				DeveloperObject->True,
				Site-> Link[$Site]
			|>
		}];

		(* Create some samples *)
		{
			discardedSample,
			waterSample,
			lowVolSample,
			conductivitySample,
			noVolumeSample,
			largeSample,
			milliQSample,
			modelLessSample,
			solidSample,
			noCalSample,
			noCalSample2,
			noCalSample3,
			smallAptSample,
			reachSample,
			lowSample
		}=UploadSample[
			{
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, StockSolution, "500mM NaCl"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				solidModel,
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2},
				{"A1",emptyContainer3},
				{"A1",emptyContainer4},(*{"A1",emptyContainer6},{"A1",emptyContainer7},{"A1",emptyContainer8},{"A1",emptyContainer10},*)
				{"A1",emptyContainer11},
				{"A1",emptyContainer13},
				{"A1",emptyContainer14},
				{"A1",emptyContainer17},
				{"A1",emptyContainer16},
				{"A1",emptyContainer18},
				{"A1",emptyContainer12},
				{"A1",emptyContainer19},
				{"A1",emptyContainer20},
				{"A1",emptyContainer6},
				{"A1",emptyContainer21}
			},
			InitialAmount->{
				50 Milliliter,
				50 Milliliter,
				0.009 Milliliter,
				50 Milliliter,
				Null,
				350 Milliliter,
				50 Milliliter,
				20 Milliliter,
				Null,
				45 Milliliter,
				45 Milliliter,
				200 Milliliter,
				200 Milliliter,
				200 Milliliter,
				45 Milliliter},
			Name->{
				"Test discarded sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test salt water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample with volume too low for measurement ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test water sample with Volume=Null for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Large test water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test MilliQ water sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test solid sample for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container with no calibration for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container with small aperture for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container that cannot be reached for ExperimentMeasureDissolvedOxygen"<> $SessionUUID,
				"Test sample in container that is too low for ExperimentMeasureDissolvedOxygen"<> $SessionUUID
			},
			StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]]
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedSample,Status->Discarded,DeveloperObject->True|>,
			<|
				Object->conductivitySample,
				Conductivity->QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {1424.4, 1429.2, 1429.9}, False}, 1, 3], "Microsiemens"/"Centimeters"],
				Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
				DeveloperObject->True
			|>,
			<|Object->lowVolSample,DeveloperObject->True|>,
			<|Object->noVolumeSample,DeveloperObject->True|>,
			<|Object->largeSample,DeveloperObject->True|>,
			<|Object->milliQSample,DeveloperObject->True|>,
			<|Object->modelLessSample,Model -> Null,DeveloperObject->True|>,
			<|Object->solidSample,DeveloperObject->True|>
		}];

		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	Parallel->True
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDissolvedOxygenOptions*)

DefineTests[
	ExperimentMeasureDissolvedOxygenOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentMeasureDissolvedOxygenOptions[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples together:"},
			ExperimentMeasureDissolvedOxygenOptions[{Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentMeasureDissolvedOxygenOptions[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID], OutputFormat -> List],
			{__Rule}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Vessel, "Test container 1 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 2 with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 3 with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container 16 for solid sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container with small aperture for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Container,Vessel,"Test container with for low sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],

				Object[Sample, "Test discarded sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test calibration standard with no dissolved oxygen for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample, "Test solid sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container with small aperture for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container that cannot be reached for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Object[Sample,"Test sample in container that is too low for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],

				Model[Sample, "Test chemical model incompatible for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Sample, "Test chemical model incompatible with Sapphire for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Sample, "Test calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID],
				Model[Sample,"Test solid model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID]
			};

			existsFilter = DatabaseMemberQ /@ testObjList;
			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		];

		Module[
			{ tooAcidicModel, containerNoCalModel1, containerNoCalModel2,
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer10, emptyContainer11, emptyContainer12,dropletModel,
				emptyContainer13, emptyContainer14, emptyContainer15,emptyContainer16,discardedSample, waterSample, lowVolSample,
				tooAcidicSample, noVolumeSample,conductivitySample,emptyContainer18,noCalSample2,noCalSample,
				largeSample, milliQSample,modelLessSample,emptyContainer17, solidModel, solidSample,emptyContainer19,
				emptyContainer20,noCalSample3,containerNoCalModel3,smallAptSample,emptyContainer21,reachSample,lowSample},

			{
				containerNoCalModel1,
				containerNoCalModel2,
				containerNoCalModel3,
				solidModel
			} = Upload[{
				(*Create container model with no calibration data*)
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.28575`, "Meters"],
						Quantity[0.28575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.28575`, "Meters"],
						MaxDepth -> Quantity[0.28575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 2 with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.9143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.9143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 3 with no calibration data for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				(*Create a solid sample*)
				<|
					Type -> Model[Sample],
					Name -> "Test solid model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					State -> Solid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True
				|>
			}];


			(* Create some empty containers *)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer8,
				emptyContainer11,
				emptyContainer12,
				emptyContainer13,
				emptyContainer14,
				emptyContainer16,
				emptyContainer17,
				emptyContainer18,
				emptyContainer19,
				emptyContainer20,
				emptyContainer21
			}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 1 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],Objects],
					Name->"Test container 4 invalid for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 5 with no sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container,Vessel,"10L Polypropylene Carboy"],Objects],
					Name->"Test container 6 that is too big for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 8 with incompatible sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 11 for No Volume sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel1,Objects],
					Name->"Test container 12 for no calibration for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
					Name->"Test container 13 for large sample volume for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 14 for MilliQ water for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 16 for solid sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 17 for solution without a model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel2,Objects],
					Name->"Test container no calibration 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel3,Objects],
					Name->"Test container no calibration 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "250mg small glass amber bottle"],Objects],
					Name->"Test container with small aperture for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "500mL Glass Bottle"],Objects],
					Name->"Test container with for low sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>
			}];

			(* Create some samples *)
			{
				discardedSample,
				waterSample,
				lowVolSample,
				conductivitySample,
				noVolumeSample,
				largeSample,
				milliQSample,
				modelLessSample,
				solidSample,
				noCalSample,
				noCalSample2,
				noCalSample3,
				smallAptSample,
				reachSample,
				lowSample
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					solidModel,
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3},
					{"A1",emptyContainer4},(*{"A1",emptyContainer6},{"A1",emptyContainer7},
				{"A1",emptyContainer8},{"A1",emptyContainer10},*)

					{"A1",emptyContainer11},{"A1",emptyContainer13},
					{"A1",emptyContainer14},{"A1",emptyContainer17},{"A1",emptyContainer16},{"A1",emptyContainer18},
					{"A1",emptyContainer12},{"A1",emptyContainer19},{"A1",emptyContainer20},{"A1",emptyContainer6},
					{"A1",emptyContainer21}
				},
				InitialAmount->{50 Milliliter,50 Milliliter,0.009 Milliliter,50 Milliliter,Null,350 Milliliter,50 Milliliter,20 Milliliter,Null,25 Milliliter,25 Milliliter,200 Milliliter,200 Milliliter,200 Milliliter,25 Milliliter},
				Name->{
					"Test discarded sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test salt water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample with volume too low for measurement ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test salt water sample with conductivity for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test water sample with Volume=Null for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Large test water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test MilliQ water sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test solid sample for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container with no calibration for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container with small aperture for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container that cannot be reached for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID,
					"Test sample in container that is too low for ExperimentMeasureDissolvedOxygenOptions"<> $SessionUUID
				}
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[{
				<|Object->discardedSample,Status->Discarded,DeveloperObject->True|>,
				<|
					Object->conductivitySample,
					Conductivity->QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {1424.4, 1429.2, 1429.9}, False}, 1, 3], "Microsiemens"/"Centimeters"],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
					DeveloperObject->True
				|>,
				<|Object->lowVolSample,DeveloperObject->True|>,
				<|Object->noVolumeSample,DeveloperObject->True|>,
				<|Object->largeSample,DeveloperObject->True|>,
				<|Object->milliQSample,DeveloperObject->True|>,
				<|Object->modelLessSample,Model -> Null,DeveloperObject->True|>,
				<|Object->solidSample,DeveloperObject->True|>
			}];

		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentMeasureDissolvedOxygenQ*)


DefineTests[
	ValidExperimentMeasureDissolvedOxygenQ,
	{
		Example[{Basic, "Determine the validity of a Measure dissolved oxygen call on one sample:"},
			ValidExperimentMeasureDissolvedOxygenQ[
				Object[Sample, "Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Determine the validity of a Measure dissolved oxygen call on multiple samples:"},
			ValidExperimentMeasureDissolvedOxygenQ[
				{
					Object[Sample, "Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
					Object[Sample, "Test MilliQ water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID]
				}
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentMeasureDissolvedOxygenQ[
				{
					Object[Sample, "Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
					Object[Sample, "Test MilliQ water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID]
				},
				OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentMeasureDissolvedOxygenQ[
				Object[Sample, "Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				DissolvedOxygenCalibrationType->TwoPoint,
				ZeroOxygenCalibrant->Null,
				Verbose -> Failures
			],
			False
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Vessel, "Test container 1 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 2 with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 3 with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no dissolved oxygen for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container,Vessel,"Test container 16 for solid sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container,Vessel,"Test container with small aperture for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Container,Vessel,"Test container with for low sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],

				Object[Sample, "Test discarded sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test salt water sample with conductivity for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Large test water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test calibration standard with no dissolved oxygen for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample, "Test solid sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container with small aperture for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container that cannot be reached for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Object[Sample,"Test sample in container that is too low for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],

				Model[Sample, "Test chemical model incompatible for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Sample, "Test chemical model incompatible with Sapphire for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Sample, "Test calibration standard model with no dissolved oxygen for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID],
				Model[Sample,"Test solid model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID]
			};

			existsFilter = DatabaseMemberQ /@ testObjList;
			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		];

		Module[
			{ tooAcidicModel, containerNoCalModel1, containerNoCalModel2,
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer10, emptyContainer11, emptyContainer12,dropletModel,
				emptyContainer13, emptyContainer14, emptyContainer15,emptyContainer16,discardedSample, waterSample, lowVolSample,
				tooAcidicSample, noVolumeSample,conductivitySample,emptyContainer18,noCalSample2,noCalSample,
				largeSample, milliQSample,modelLessSample,emptyContainer17, solidModel, solidSample,emptyContainer19,
				emptyContainer20,noCalSample3,containerNoCalModel3,smallAptSample,emptyContainer21,reachSample,lowSample},

			{
				containerNoCalModel1,
				containerNoCalModel2,
				containerNoCalModel3,
				solidModel
			} = Upload[{
				(*Create container model with no calibration data*)
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.28575`, "Meters"],
						Quantity[0.28575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.28575`, "Meters"],
						MaxDepth -> Quantity[0.28575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 2 with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.9143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.9143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 3 with no calibration data for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				(*Create a solid sample*)
				<|
					Type -> Model[Sample],
					Name -> "Test solid model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					State -> Solid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True
				|>
			}];


			(* Create some empty containers *)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer8,
				emptyContainer11,
				emptyContainer12,
				emptyContainer13,
				emptyContainer14,
				emptyContainer16,
				emptyContainer17,
				emptyContainer18,
				emptyContainer19,
				emptyContainer20,
				emptyContainer21
			}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 1 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],Objects],
					Name->"Test container 4 invalid for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 5 with no sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container,Vessel,"10L Polypropylene Carboy"],Objects],
					Name->"Test container 6 that is too big for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 8 with incompatible sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 11 for No Volume sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel1,Objects],
					Name->"Test container 12 for no calibration for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
					Name->"Test container 13 for large sample volume for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 14 for MilliQ water for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 16 for solid sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 17 for solution without a model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel2,Objects],
					Name->"Test container no calibration 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel3,Objects],
					Name->"Test container no calibration 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "250mg small glass amber bottle"],Objects],
					Name->"Test container with small aperture for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "500mL Glass Bottle"],Objects],
					Name->"Test container with for low sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>
			}];

			(* Create some samples *)
			{
				discardedSample,
				waterSample,
				lowVolSample,
				conductivitySample,
				noVolumeSample,
				largeSample,
				milliQSample,
				modelLessSample,
				solidSample,
				noCalSample,
				noCalSample2,
				noCalSample3,
				smallAptSample,
				reachSample,
				lowSample
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					solidModel,
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3},
					{"A1",emptyContainer4},(*{"A1",emptyContainer6},{"A1",emptyContainer7},
				{"A1",emptyContainer8},{"A1",emptyContainer10},*)

					{"A1",emptyContainer11},{"A1",emptyContainer13},
					{"A1",emptyContainer14},{"A1",emptyContainer17},{"A1",emptyContainer16},{"A1",emptyContainer18},
					{"A1",emptyContainer12},{"A1",emptyContainer19},{"A1",emptyContainer20},{"A1",emptyContainer6},
					{"A1",emptyContainer21}
				},
				InitialAmount->{50 Milliliter,50 Milliliter,0.009 Milliliter,50 Milliliter,Null,350 Milliliter,50 Milliliter,20 Milliliter,Null,25 Milliliter,25 Milliliter,200 Milliliter,200 Milliliter,200 Milliliter,25 Milliliter},
				Name->{
					"Test discarded sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test salt water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample with volume too low for measurement ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test salt water sample with conductivity for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test water sample with Volume=Null for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Large test water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test MilliQ water sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test MilliQ water sample for sample without a model for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test solid sample for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container with no calibration for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container with no calibration 2 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container with no calibration 3 for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container with small aperture for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container that cannot be reached for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID,
					"Test sample in container that is too low for ValidExperimentMeasureDissolvedOxygenQ"<> $SessionUUID
				}
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[{
				<|Object->discardedSample,Status->Discarded,DeveloperObject->True|>,
				<|
					Object->conductivitySample,
					Conductivity->QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {1424.4, 1429.2, 1429.9}, False}, 1, 3], "Microsiemens"/"Centimeters"],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
					DeveloperObject->True
				|>,
				<|Object->lowVolSample,DeveloperObject->True|>,
				<|Object->noVolumeSample,DeveloperObject->True|>,
				<|Object->largeSample,DeveloperObject->True|>,
				<|Object->milliQSample,DeveloperObject->True|>,
				<|Object->modelLessSample,Model -> Null,DeveloperObject->True|>,
				<|Object->solidSample,DeveloperObject->True|>
			}];

		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDissolvedOxygenPreview*)


DefineTests[
	ExperimentMeasureDissolvedOxygenPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentMeasureDissolvedOxygenPreview[Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentMeasureDissolvedOxygenPreview[{Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID], Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID]}],
			Null
		],
		Example[{Basic, "Return Null for a container:"},
			ExperimentMeasureDissolvedOxygenPreview[Object[Container, Vessel, "Test container 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{testObjList,existsFilter},

			testObjList = {
				Object[Container, Vessel, "Test container 1 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 2 with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Container, Vessel, "Test container model 3 with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test container 16 for solid sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test container no calibration 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test container with small aperture for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Container,Vessel,"Test container with for low sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],

				Object[Sample, "Test discarded sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test salt water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test salt water sample with conductivity for ExperimentMeasureDissolvedPreview"<> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test calibration standard with no dissolved oxygen for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample, "Test solid sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container with small aperture for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container that cannot be reached for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Object[Sample,"Test sample in container that is too low for ExperimentMeasureDissolvedPreview"<> $SessionUUID],

				Model[Sample, "Test chemical model incompatible for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Sample, "Test chemical model incompatible with Sapphire for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Sample, "Test calibration standard model with no dissolved oxygen for ExperimentMeasureDissolvedPreview"<> $SessionUUID],
				Model[Sample,"Test solid model for ExperimentMeasureDissolvedPreview"<> $SessionUUID]
			};

			existsFilter = DatabaseMemberQ /@ testObjList;
			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		];

		Module[
			{ tooAcidicModel, containerNoCalModel1, containerNoCalModel2,
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer10, emptyContainer11, emptyContainer12,dropletModel,
				emptyContainer13, emptyContainer14, emptyContainer15,emptyContainer16,discardedSample, waterSample, lowVolSample,
				tooAcidicSample, noVolumeSample,conductivitySample,emptyContainer18,noCalSample2,noCalSample,
				largeSample, milliQSample,modelLessSample,emptyContainer17, solidModel, solidSample,emptyContainer19,
				emptyContainer20,noCalSample3,containerNoCalModel3,smallAptSample,emptyContainer21,reachSample,lowSample},

			{
				containerNoCalModel1,
				containerNoCalModel2,
				containerNoCalModel3,
				solidModel
			} = Upload[{
				(*Create container model with no calibration data*)
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.28575`, "Meters"],
						Quantity[0.28575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.28575`, "Meters"],
						MaxDepth -> Quantity[0.28575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 2 with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.9143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.9143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|Type -> Model[Container, Vessel],
					Name -> "Test container model 3 with no calibration data for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				(*Create a solid sample*)
				<|
					Type -> Model[Sample],
					Name -> "Test solid model for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					State -> Solid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True
				|>
			}];


			(* Create some empty containers *)
			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer8,
				emptyContainer11,
				emptyContainer12,
				emptyContainer13,
				emptyContainer14,
				emptyContainer16,
				emptyContainer17,
				emptyContainer18,
				emptyContainer19,
				emptyContainer20,
				emptyContainer21
			}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 1 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
					Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],Objects],
					Name->"Test container 4 invalid for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 5 with no sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container, Vessel],
					Model->Link[Model[Container,Vessel,"10L Polypropylene Carboy"],Objects],
					Name->"Test container 6 that is too big for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 8 with incompatible sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 11 for No Volume sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel1,Objects],
					Name->"Test container 12 for no calibration for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
					Name->"Test container 13 for large sample volume for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 14 for MilliQ water for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 16 for solid sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 17 for solution without a model for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel2,Objects],
					Name->"Test container no calibration 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[containerNoCalModel3,Objects],
					Name->"Test container no calibration 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "250mg small glass amber bottle"],Objects],
					Name->"Test container with small aperture for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "500mL Glass Bottle"],Objects],
					Name->"Test container with for low sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					DeveloperObject->True,
					Site-> Link[$Site]
				|>
			}];

			(* Create some samples *)
			{
				discardedSample,
				waterSample,
				lowVolSample,
				conductivitySample,
				noVolumeSample,
				largeSample,
				milliQSample,
				modelLessSample,
				solidSample,
				noCalSample,
				noCalSample2,
				noCalSample3,
				smallAptSample,
				reachSample,
				lowSample
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, StockSolution, "500mM NaCl"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					solidModel,
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer3},
					{"A1",emptyContainer4},(*{"A1",emptyContainer6},{"A1",emptyContainer7},
				{"A1",emptyContainer8},{"A1",emptyContainer10},*)

					{"A1",emptyContainer11},{"A1",emptyContainer13},
					{"A1",emptyContainer14},{"A1",emptyContainer17},{"A1",emptyContainer16},{"A1",emptyContainer18},
					{"A1",emptyContainer12},{"A1",emptyContainer19},{"A1",emptyContainer20},{"A1",emptyContainer6},
					{"A1",emptyContainer21}
				},
				InitialAmount->{50 Milliliter,50 Milliliter,0.009 Milliliter,50 Milliliter,Null,350 Milliliter,50 Milliliter,20 Milliliter,Null,25 Milliliter,25 Milliliter,200 Milliliter,200 Milliliter,200 Milliliter,25 Milliliter},
				Name->{
					"Test discarded sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test salt water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample with volume too low for measurement ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test salt water sample with conductivity for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test water sample with Volume=Null for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Large test water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test MilliQ water sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test MilliQ water sample for sample without a model for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test solid sample for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container with no calibration for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container with no calibration 2 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container with no calibration 3 for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container with small aperture for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container that cannot be reached for ExperimentMeasureDissolvedPreview"<> $SessionUUID,
					"Test sample in container that is too low for ExperimentMeasureDissolvedPreview"<> $SessionUUID
				}
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[{
				<|Object->discardedSample,Status->Discarded,DeveloperObject->True|>,
				<|
					Object->conductivitySample,
					Conductivity->QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {1424.4, 1429.2, 1429.9}, False}, 1, 3], "Microsiemens"/"Centimeters"],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
					DeveloperObject->True
				|>,
				<|Object->lowVolSample,DeveloperObject->True|>,
				<|Object->noVolumeSample,DeveloperObject->True|>,
				<|Object->largeSample,DeveloperObject->True|>,
				<|Object->milliQSample,DeveloperObject->True|>,
				<|Object->modelLessSample,Model -> Null,DeveloperObject->True|>,
				<|Object->solidSample,DeveloperObject->True|>
			}];

		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
