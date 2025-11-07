(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureConductivity : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureConductivity*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureConductivity*)


DefineTests[ExperimentMeasureConductivity,
	{
		Example[{Basic,"Measure the conductivity of a single sample:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Measure the conductivity of a multiple samples:"},
			ExperimentMeasureConductivity[{Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureConductivity" <> $SessionUUID]}],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Basic,"Measure the conductivity of a single sample in replicates:"},
			protocol = ExperimentMeasureConductivity[{Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID]}];
			Transpose[Download[protocol,{SamplesIn, ContainersIn}]],
			ListableP[{LinkP[Object[Sample]], LinkP[Object[Container]]}],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			Variables :> {protocol}
		],
		(*Instrument option*)
		Example[{Options,Instrument,"Measure the conductivity of a single liquid sample by specifying a specific instrument object or model:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Instrument->Model[Instrument, ConductivityMeter, "SevenExcellence Conductivity"],Output->Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, ConductivityMeter, "SevenExcellence Conductivity"]],
			Variables :> {options}
		],
		Example[{Additional,"If the instrument option is specified, resolve to the Probes that are on that instrument:"},
			prot=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Instrument->Object[Instrument, ConductivityMeter, "Test Conductivity Meter for ExperimentMeasureConductivity Tests" <> $SessionUUID]];
			Download[prot, Probes],
			{ObjectP[Object[Part, ConductivityProbe, "Test 731-ISM Conductivity Probe for ExperimentMeasureConductivity Tests" <> $SessionUUID]]},
			Variables :> {prot}
		],
		(*Probe option*)
		Example[{Options,Probe,"Measure the conductivity of a single liquid sample by specifying a specific probe object or model:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Probe->Model[Part, ConductivityProbe, "InLab 751-4mm"],Output->Options];
			Lookup[options, Probe],
			ObjectP[Model[Part, ConductivityProbe, "InLab 751-4mm"]],
			Variables :> {options}
		],
		(*TODO: Update the three test below to include SecondaryCalibrationStandard in the option argument once SecondaryCalibrationStandard is added to ExperimentMeasureConductivity's options.*)
			(*Small Volume Probe Uses both a primary and secondary calibration standard.*)
			Example[{Additional,"Calibration of the small volume probe uses two calibration standards:"},
				prot=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Probe->Model[Part, ConductivityProbe, "InLab 751-4mm"],CalibrationStandard->Model[Sample, "Conductivity Standard 1413 \[Micro]S, Sachets"]];
				Download[prot, {CalibrationStandard, SecondaryCalibrationStandard}],
				{{ObjectP[Model[Sample, "id:eGakldJ6WqD4"]]},{ObjectP[Model[Sample,"id:4pO6dM5qa66o"]]}},
				Variables :> {prot}
			],
			(*Regular Probe Uses only a single calibration standard.*)
			Example[{Additional,"Calibration of the regular probe uses a single calibration standard:"},
				prot=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Probe->Model[Part, ConductivityProbe, "InLab 731-ISM"],CalibrationStandard->Model[Sample, "Conductivity Standard 1413 \[Micro]S, Sachets"]];
				Download[prot, {CalibrationStandard,SecondaryCalibrationStandard}],
				{{ObjectP[Model[Sample, "id:eGakldJ6WqD4"]]},{Null}},
				Variables :> {prot}
			],
			(*CalibrationStandard and SecondaryCalibrationStandard Index match to probes correctly.*)
			Example[{Additional,"CalibrationStandard and SecondaryCalibrationStandard Index match to probes correctly:"},
				prot=ExperimentMeasureConductivity[{Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID]},Probe->{Model[Part, ConductivityProbe, "InLab 731-ISM"],Model[Part, ConductivityProbe, "InLab 751-4mm"]},CalibrationStandard->Model[Sample, "Conductivity Standard 1413 \[Micro]S, Sachets"]];
				Download[prot, {CalibrationStandard,SecondaryCalibrationStandard}],
				{{ObjectP[Model[Sample, "id:eGakldJ6WqD4"]],ObjectP[Model[Sample, "id:eGakldJ6WqD4"]]}, {ObjectP[Model[Sample,"id:4pO6dM5qa66o"]], Null}},
				Variables :> {prot}
			],
		(*NumberOfReadings*)
		Example[{Options,NumberOfReadings,"Measure the conductivity of multiple liquid samples by taking a specific number of readings:"},
			options=ExperimentMeasureConductivity[{Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Object[Sample, "Test MilliQ water sample for ExperimentMeasureConductivity" <> $SessionUUID]},NumberOfReadings->{1,1},Output->Options];
			Lookup[options, NumberOfReadings],
			{1,1},
			Variables :> {options}
		],
		(*CalibrationStandard*)
		Example[{Options,CalibrationStandard,"Measure the conductivity of a single liquid sample by specifying a specific calibration standard solution:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],CalibrationStandard->Model[Sample, "Conductivity Standard 10 \[Mu]S"],Output->Options];
			Lookup[options, CalibrationStandard],
			ObjectP[Model[Sample, "Conductivity Standard 10 \[Mu]S"]],
			Variables :> {options}
		],
		(*CalibrationConductivity*)
		Example[{Options,CalibrationConductivity,"Measure the conductivity of a single liquid sample by specifying a specific calibration standard solution:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],CalibrationConductivity->10 Micro Siemens/Centimeter,Output->Options];
			Lookup[options, CalibrationConductivity],
			10 Micro Siemens/Centimeter,
			Variables :> {options}
		],
		(*VerificationStandard*)
		Example[{Options,VerificationStandard,"Measure the conductivity of a single liquid sample by specifying a specific verification standard solution:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],VerificationStandard->Model[Sample, "Conductivity Standard 1413 \[Micro]S, Sachets"],Output->Options];
			Lookup[options, VerificationStandard],
			ObjectP[Model[Sample, "Conductivity Standard 1413 \[Micro]S, Sachets"]],
			Variables :> {options}
		],
		(*VerificationConductivity*)
		Example[{Options,VerificationConductivity,"Measure the conductivity of a single liquid sample by specifying a specific verification standard solution:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],VerificationConductivity->1413 Micro Siemens/Centimeter,Output->Options];
			Lookup[options, VerificationConductivity],
			1413 Micro Siemens/Centimeter,
			Variables :> {options}
		],
		(* --- Temperature Compensation options--- *)
		Example[{Options,TemperatureCorrection,"Measure the conductivity of a single liquid sample with NonLinear TemperatureCorrection build-in algorithm:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],TemperatureCorrection->NonLinear,Output->Options];
			Lookup[options, {TemperatureCorrection,AlphaCoefficient}],
			{NonLinear, Null},
			Variables :> {options}
		],
		Example[{Options,TemperatureCorrection,"Measure the conductivity of a single liquid sample with Linear TemperatureCorrection build-in algorithm and a custom AlphaCoefficient:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],TemperatureCorrection->Linear,AlphaCoefficient->6,Output->Options];
			Lookup[options, {TemperatureCorrection,AlphaCoefficient}],
			{Linear, 6},
			Variables :> {options}
		],
		Example[{Options,AlphaCoefficient,"Measure the conductivity of a single liquid sample with a custom AlphaCoefficient should resolve TemperatureCorrection to Linear:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],AlphaCoefficient->10,Output->Options];
			Lookup[options, {TemperatureCorrection,AlphaCoefficient}],
			{Linear, 10},
			Variables :> {options}
		],

		(*SampleRinse*)
		Example[{Options,SampleRinse,"Rinse the probe before the conductivity measurements of a single liquid sample:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinse->True,Output->Options];
			Lookup[options, SampleRinse],
			True,
			Variables :> {options}
		],
		(*SampleRinseVolume*)
		Example[{Options,SampleRinseVolume,"Rinse the probe before with a specific volume the conductivity measurements of a single liquid sample:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinse -> True, SampleRinseVolume->1.5 Milli Liter,Output->Options];
			Lookup[options, SampleRinseVolume],
			1.5 Milli Liter,
			Variables :> {options}
		],
		Example[{Options,SampleRinseStorageCondition, "Indicates how the probe's rinse samples should be stored if SamplleRinse is True:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinse->True, SampleRinseStorageCondition->Refrigerator, Output -> Options];
			Lookup[options,{SampleRinse,SampleRinseStorageCondition}],
			{True,Refrigerator},
			Variables:>{options}
		],
		Example[{Options,SampleRinseStorageCondition, "Automatically set SampleRinseStorageCondition to Disposal if SamplleRinse is True:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinse->True, Output -> Options];
			Lookup[options,{SampleRinse,SampleRinseStorageCondition}],
			{True,Disposal},
			Variables:>{options}
		],
		(*RecoupSample*)
		Example[{Options,RecoupSample,"Recoup aliquoted sample after the conductivity measurements of a single liquid sample:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],RecoupSample -> True,Output->Options];
			Lookup[options, RecoupSample],
			True,
			Variables :> {options}
		],
		(*---General options---*)
    Example[{Options,Name,"Measure the conductivity of a single liquid sample with a Name specified for the protocol:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Name->"Measure conductivity without temperature correction.",TemperatureCorrection->None,Output->Options];
      Lookup[options,{Name,TemperatureCorrection}],
			{"Measure conductivity without temperature correction.",Off},
      Variables:>{options}
    ],
		Example[{Basic,"Setting Aliquot->True will take an aliquot of your sample for conductivity measurement - this is often used to prevent sample contamination. The option RecoupSample->True can be set if the aliquotted sample should be recouped after measurement:"},
			ExperimentMeasureConductivity[Object[Container,Vessel,"Test container 2 for ExperimentMeasureConductivity" <> $SessionUUID],Aliquot->True,AliquotAmount->25Milliliter,RecoupSample->True],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
		],
		Example[{Options,NumberOfReplicates,"Measure the conductivity of a single liquid sample by specifying a NumberOfReplicates, in this case, repeatedly measuring the sample:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],NumberOfReplicates->2,Output->Options];
			Lookup[options, NumberOfReplicates],
			2,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], SamplesInStorageCondition->Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,Template, "Use a previous MeasureConductivity protocol as a template for a new one:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				NumberOfReplicates->2,
				Template->Object[Protocol,MeasureConductivity,"Test Template Protocol for ExperimentMeasureConductivity" <> $SessionUUID],
				Output->Options];
			Lookup[options, VerificationConductivity],
			1413 Micro Siemens/Centimeter,
			Variables :> {options}
		],
		(* === Shared Options - PreparatoryUnitOperations === *)
		Example[
			{Options,PreparatoryUnitOperations,"Describe the preparation of a buffer before using it in a MeasureConductivity protocol:"},
			ExperimentMeasureConductivity[
				"My Buffer",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Buffer",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My Buffer",
						Amount -> 2 Liter
					],
					Transfer[
						Source -> Model[Sample, "Heptafluorobutyric acid"],
						Destination -> "My Buffer",
						Amount -> 1 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,MeasureConductivity]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasureConductivity[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container,Vessel,"id:3em6Zv9NjjN8"],(*2mL Tube*)
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Container,Vessel,"id:3em6Zv9NjjN8"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasureConductivity[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, MeasureConductivity]]
		],
		(*---Post Processing options---*)
		Example[{Options,ImageSample,"Measure the conductivity of a single liquid sample and do not take an image afterwards:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],ImageSample->False,Output->Options];
			Lookup[options,ImageSample],
			False,
			Variables :> {options}
		],
		Example[{Options,MeasureWeight,"Specify whether to weigh the sample after measurement in the post processing step:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],MeasureWeight->False,Output->Options];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Specify whether to measure the volume of the sample after measurement in the post processing step:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],MeasureVolume->False,Output->Options];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		(*---incubate options---*)
    Example[{Options,Incubate,"Measure the conductivity of a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Incubate->True,Output->Options];
      Lookup[options,Incubate],
      True,
      Variables:>{options}
    ],
    Example[{Options,IncubationTime,"Measure the conductivity of a single liquid sample with Incubation before measurement for 10 minutes:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,Output->Options];
      Lookup[options,IncubationTime],
      10 Minute,
      Variables:>{options}
    ],
    Example[{Options,MaxIncubationTime,"Measure the conductivity of a single liquid sample with MaxIncubation before measurement for 1 hour:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Incubate->True,MaxIncubationTime->1 Hour,Output->Options];
      Lookup[options,MaxIncubationTime],
      1 Hour,
      Variables:>{options}
    ],
    Example[{Options,IncubationTemperature,"Measure the conductivity of a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Incubate->True,IncubationTime->10 Minute,IncubationTemperature -> 30 Celsius,Output->Options];
      Lookup[options,IncubationTemperature],
      30 Celsius,
      Variables:>{options}
    ],
    Example[{Options,IncubationInstrument,"Measure the conductivity of a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options];
      Lookup[options,IncubationInstrument],
      ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
      Variables:>{options}
    ],

    Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],Output->Options];
      Lookup[options,IncubateAliquot],
      1 Milliliter,
			EquivalenceFunction->Equal,
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],IncubateAliquot->1 Milliliter,IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],Output->Options];
      Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables:>{options}
    ],
		(*---Mix options---*)
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Mix->True,MixType->Vortex,Output->Options];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],MixUntilDissolved->True,MixType->Vortex,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],AnnealingTime->40 Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],
		(*---centrifuge options---*)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeAliquot -> 10*Milliliter,CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquot],
			10*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeAliquot -> 10*Milliliter,CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(*---filter options---*)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],PrefilterMaterial -> GxF,FilterMaterial->PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Large test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTemperature -> 22*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquot -> 10*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			10*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(*---Aliquot options---*)
		Example[{Options,Aliquot,"Measure the conductivity of a single liquid sample by first aliquoting the sample:"},
			options=ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], AliquotAmount -> 15*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AliquotAmount],
			15*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], AssayVolume -> 15*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			15*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], TargetConcentration -> 5*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte,  "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],  TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Uracil"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->20*Milliliter, AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureConductivity[Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		(*---Error Messages---*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureConductivity[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureConductivity[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureConductivity[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureConductivity[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","Return an error for a discarded sample:"},
			ExperimentMeasureConductivity[Object[Sample, "Test discarded sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"VolumeUnknown","Return an error for samples that do not have a volume:"},
			ExperimentMeasureConductivity[Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::VolumeUnknown,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InsufficientVolume","Return an error for too low sample volume, thereby incapable of measurement:"},
			ExperimentMeasureConductivity[Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InsufficientVolume,Error::InvalidInput
			}
		],
		Example[{Messages,"EmptyContainers","Return an error for a container without a sample:"},
			ExperimentMeasureConductivity[Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::EmptyContainers
			}
		],
		Example[{Messages,"SolidSamples","Return an error for a solid sample:"},
			ExperimentMeasureConductivity[Object[Sample, "Test solid sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::SolidSamples,
				Error::VolumeUnknown,
				Error::InvalidInput,
				Error::SolidSamplesUnsupported
			}
		],
		Example[{Messages,"SampleRinseStorageConditionMismatch","Return an error for SampleRinseStorageCondition  specified when SampleRinse is turened off:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinseStorageCondition -> Refrigerator],
			$Failed,
			Messages:>{
				Error::SampleRinseStorageConditionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SampleRinseStorageConditionMismatch","Return an error for SampleRinseStorageCondition  specified when SampleRinse is turened off:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],SampleRinseStorageCondition -> Refrigerator],
			$Failed,
			Messages:>{
				Error::SampleRinseStorageConditionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleSampleConductivity","Return a warning if the sample has a conductivity value outside any available conductivity range:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample with extremely low conductivity for ExperimentMeasureConductivity" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Messages:>{
				Warning::IncompatibleSampleConductivity
			}
		],
		Example[{Messages,"NoSuitableProbe","Return a warning if the sample has a conductivity value outside any available conductivity range of the small volume probe:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample with extremely high conductivity for ExperimentMeasureConductivity" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Messages:>{
				Warning::NoSuitableProbe,
				Warning::IncompatibleSampleConductivityProbe
			}
		],
		Example[{Messages,"IncompatibleSampleConductivityProbe","Return a warning the conductivity of the sample is incompatible with any available probe:"},
			ExperimentMeasureConductivity[Object[Sample,"Test water sample with extremely high conductivity for ExperimentMeasureConductivity" <> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureConductivity]],
			Messages:>{
				Warning::NoSuitableProbe,
				Warning::IncompatibleSampleConductivityProbe
			}
		],
		Example[{Messages,"ConductivityStandardUnknowConductivity","Return an error the Conductivity of the given CalibrationStandard is unknown:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				CalibrationStandard -> Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ConductivityStandardUnknowConductivity,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConductivityVerificationStandardUnknowConductivity","Return an error if the Conductivity of the given VerificationStandard is unknown:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				VerificationStandard -> Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ConductivityVerificationStandardUnknowConductivity,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConflictingTemperatureCorrection","Return an error if the given TemperatureCorrection conflicts with teh AlphaCoefficient:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID], TemperatureCorrection -> NonLinear, AlphaCoefficient -> 2],
			$Failed,
			Messages:>{
				Error::ConflictingTemperatureCorrection,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InsufficientSampleRinseVolume","Return an error if InsufficientSampleRinseVolume is given:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				SampleRinse -> True,
				SampleRinseVolume -> 0.2 Liter
			],
			$Failed,
			Messages:>{
				Error::InsufficientSampleRinseVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConflictingCalibrantion","Return an error if the given CalibrationConductivity does not match with the Conductivity of CalibrationStandard:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				CalibrationStandard -> Model[Sample, "Conductivity Standard 10 \[Mu]S"],
				CalibrationConductivity -> 100 Micro Siemens/Centimeter],
			$Failed,
			Messages:>{
				Error::ConflictingCalibrantion,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingVerification","Return an error if the given VerificationConductivity does not match with the Conductivity of VerificationStandard:"},
			ExperimentMeasureConductivity[
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				VerificationStandard -> Model[Sample, "Conductivity Standard 10 \[Mu]S"],
				VerificationConductivity -> 100 Micro Siemens/Centimeter],
			$Failed,
			Messages:>{
				Error::ConflictingVerification,
				Error::InvalidOption
			}
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{
				allObjects,calibrationStandardNoConductivity,containerNoCalModel,
				emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,
				emptyContainer7,emptyContainer8,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,
				emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer19,discardedChemical,waterSample,waterSample2,
				waterSample3,lowVolSample,noVolumeSample,probe,templateHPLCProtocol,largeSample,milliQSample,
				calibrationStandardNoConductivityObject,modelLessSample,emptyContainer17,emptyContainer18,conductivityProbeModelWithSapphire,solidModel,solidSample
				,existingObjects},
			allObjects = {
				Object[Container, Vessel, "Test container 1 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for lil stick for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container,Vessel,"Test container 16 for solid sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Sample, "Test discarded sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample with extremely low conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample with extremely high conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test calibration standard with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test solid sample for ExperimentMeasureConductivity" <> $SessionUUID],

				Model[Sample, "Test calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Model[Sample,"Test solid model for ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Protocol,MeasureConductivity,"Test Template Protocol for ExperimentMeasureConductivity" <> $SessionUUID],

				Model[Part, ConductivityProbe, "Test conductivity probe model with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Part, ConductivityProbe, "Test conductivity probe Object with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Part, ConductivityProbe, "Test 731-ISM Conductivity Probe for ExperimentMeasureConductivity Tests" <> $SessionUUID],
				Object[Instrument, ConductivityMeter, "Test Conductivity Meter for ExperimentMeasureConductivity Tests" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];

			(*Create some chemicals too corrosive for measurement as well as instrument models*)
			{
				conductivityProbeModelWithSapphire,
				calibrationStandardNoConductivity,
				containerNoCalModel,
				solidModel
			} = Upload[{
				(*Create conductivity probe model with a unique material for measurement*)
				<|
					Type -> Model[Part, ConductivityProbe],
					Name -> "Test conductivity probe model with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID,
					MinSampleVolume -> 2 Milliliter,
					MinConductivity -> 0.01  Milli Siemens/(Centimeter),
					MaxConductivity -> 1000 Milli Siemens/(Centimeter),
					ProbeType -> Contacting,
					NumberOfElectrodes -> 4,
					Append[WettedMaterials] -> {Sapphire, Glass}
				|>,
				(*Create a calibration standard model with no conductivity value*)
				<|
					Type -> Model[Sample],
					Name -> "Test calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID,
					State -> Liquid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Conductivity -> Null,
					DeveloperObject -> True
				|>,
				(*Create container model with no calibration data*)
				<|
					Type -> Model[Container, Vessel],
					Name -> "Test container model with no calibration data for ExperimentMeasureConductivity" <> $SessionUUID,
					Deprecated -> False,
					Dimensions -> {Quantity[0.028575`, "Meters"],
						Quantity[0.028575`, "Meters"],
						Quantity[0.1143`, "Meters"]},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,
						MaxWidth -> Quantity[0.028575`, "Meters"],
						MaxDepth -> Quantity[0.028575`, "Meters"],
						MaxHeight -> Quantity[0.1143`, "Meters"]|>},
					DeveloperObject -> True|>,
				<|
					Type -> Model[Sample],
					Name -> "Test solid model for ExperimentMeasureConductivity" <> $SessionUUID,
					State -> Solid,
					Replace[Composition] -> {{Null,Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True
				|>
			}];

			(*Create conductivity probes from the new models*)
			Upload[{
				<|
					Type -> Object[Part, ConductivityProbe],
					Model -> Link[conductivityProbeModelWithSapphire, Objects],
					Name -> "Test conductivity probe Object with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID,
					Site->Link[$Site],
					Status -> Available
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
			emptyContainer7,
			emptyContainer8,
			emptyContainer10,
			emptyContainer11,
			emptyContainer12,
			emptyContainer13,
			emptyContainer14,
			emptyContainer15,
			emptyContainer16,
			emptyContainer17,
			emptyContainer18,
			emptyContainer19
		}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 3 for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,ReactionVessel,SolidPhaseSynthesis],
				Model->Link[Model[Container,ReactionVessel,SolidPhaseSynthesis,"NAP 10 Gravity Cartridge"],Objects],
				Name->"Test container 4 invalid for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 5 with no sample for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container, Vessel],
				Model->Link[Model[Container,Vessel,"10L Polypropylene Carboy"],Objects],
				Name->"Test container 6 that is too big for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container, Vessel],
				Model->Link[Model[Container,Vessel,"500mL Glass Bottle"],Objects],
				Name->"Test container 7 that is too large for lil stick for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 8 with incompatible sample for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 10 with anti-sapphire sample for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 11 for No Volume sample for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[containerNoCalModel,Objects],
				Name->"Test container 12 for no calibration for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container 13 for large sample volume for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 14 for MilliQ water for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 15 for calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 16 for solid sample for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 17 for solution without a model for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 18 for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 19 for ExperimentMeasureConductivity" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create some samples *)
		{
			discardedChemical,
			waterSample,
			waterSample2,
			waterSample3,
			lowVolSample,
			noVolumeSample,
			largeSample,
			milliQSample,
			calibrationStandardNoConductivityObject,
			modelLessSample,
			solidSample
		}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, StockSolution, "Red Food Dye Test Solution"],
				Model[Sample, "Milli-Q water"],
				calibrationStandardNoConductivity,
				Model[Sample, "Milli-Q water"],
				solidModel
			},
			{
				{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer18},{"A1", emptyContainer19},{"A1",emptyContainer3},
				(*{"A1",emptyContainer4},{"A1",emptyContainer6},{"A1",emptyContainer7},
				{"A1",emptyContainer8},{"A1",emptyContainer10},*)

				{"A1",emptyContainer11},(*{"A1",emptyContainer12},*){"A1",emptyContainer13},
				{"A1",emptyContainer14},{"A1",emptyContainer15},{"A1",emptyContainer17},{"A1",emptyContainer16}
			},
			InitialAmount->{50 Milliliter,50 Milliliter,50 Milliliter,3 Milliliter,0.009 Milliliter, Null,350 Milliliter,50 Milliliter,50 Milliliter,20 Milliliter,Null},
			Name->{
				"Test discarded sample for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test water sample with extremely low conductivity for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test water sample with extremely high conductivity for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test sample with volume too low for measurement ExperimentMeasureConductivity" <> $SessionUUID,
				"Test water sample with Volume=Null for ExperimentMeasureConductivity" <> $SessionUUID,
				"Large test water sample for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test MilliQ water sample for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test calibration standard with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test MilliQ water sample for sample without a model for ExperimentMeasureConductivity" <> $SessionUUID,
				"Test solid sample for ExperimentMeasureConductivity" <> $SessionUUID
			}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
			<|
				Object->waterSample,
				Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
				DeveloperObject->True
			|>,
			<|
				Object->waterSample2,
				Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
				Conductivity->QuantityDistribution[DataDistribution["Empirical", List[List[1.`], List[0.`], False], 1, 3], Times[Power["Centimeters", -1], "Microsiemens"]],
				DeveloperObject->True
			|>,
			<|
				Object->waterSample3,
				Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}},
				Conductivity->QuantityDistribution[DataDistribution["Empirical", List[List[0.333333, 0.333333, 0.333333], List[163944., 191844., 202514.], False], 1, 3], Times[Power["Centimeters", -1], "Microsiemens"]],
				DeveloperObject->True
			|>,
			<|Object->lowVolSample,DeveloperObject->True|>,
			<|Object->noVolumeSample,DeveloperObject->True|>,
			<|Object->largeSample,DeveloperObject->True|>,
			<|Object->milliQSample,DeveloperObject->True|>,
			<|Object->calibrationStandardNoConductivityObject,DeveloperObject->True|>,
			<|Object->modelLessSample,Model -> Null,DeveloperObject->True|>,
			<|Object->solidSample,DeveloperObject->True|>
		}];

			(*Create a new probe and conductivity meter instrument*)
			probe=CreateID[Object[Part, ConductivityProbe]];
			Upload[{
				<|
					Object -> probe,
					Model -> Link[Model[Part, ConductivityProbe, "InLab 731-ISM"], Objects],
					Name -> "Test 731-ISM Conductivity Probe for ExperimentMeasureConductivity Tests" <> $SessionUUID,
					Site->Link[$Site],
					Status -> Available
				|>,
				<|
					Type -> Object[Instrument, ConductivityMeter],
					Model -> Link[Model[Instrument, ConductivityMeter, "SevenExcellence Conductivity"], Objects],
					Name -> "Test Conductivity Meter for ExperimentMeasureConductivity Tests" <> $SessionUUID,
					Status -> Available,
					Replace[Probes]->Link[probe],
					Site -> Link[$Site],
					DeveloperObject->True
				|>
			}];

			(*Create a protocol that we'll use for template testing*)
			Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
				(*Create a protocol that we'll use for template testing*)
				templateHPLCProtocol = ExperimentMeasureConductivity[Object[Sample,"Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
					Name -> "Test Template Protocol for ExperimentMeasureConductivity" <> $SessionUUID,
					VerificationConductivity->1413 Micro Siemens/Centimeter
				]
			];
			(* Make all the test objects and models developer objects *)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
		]
	),
	SymbolTearDown:>(
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Vessel, "Test container 1 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, ReactionVessel, SolidPhaseSynthesis, "Test container 4 invalid for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 with no sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 that is too big for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 that is too large for lil stick for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 with incompatible sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 10 with anti-sapphire sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 11 for No Volume sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Model[Container, Vessel, "Test container model with no calibration data for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for no calibration for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for large sample volume for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for MilliQ water for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for solid sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 17 for solution without a model for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 18 for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Container, Vessel, "Test container 19 for ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Sample, "Test discarded sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample with extremely low conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test water sample with extremely high conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test sample with volume too low for measurement ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Sample, "Test water sample with Volume=Null for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Large test water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test MilliQ water sample for sample without a model for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test calibration standard with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Sample, "Test solid sample for ExperimentMeasureConductivity" <> $SessionUUID],

				Model[Sample, "Test calibration standard model with no conductivity for ExperimentMeasureConductivity" <> $SessionUUID],
				Model[Sample, "Test solid model for ExperimentMeasureConductivity" <> $SessionUUID],

				Object[Protocol, MeasureConductivity, "Test Template Protocol for ExperimentMeasureConductivity" <> $SessionUUID],

				Model[Part, ConductivityProbe, "Test conductivity probe model with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Part, ConductivityProbe, "Test conductivity probe Object with Sapphire for ExperimentMeasureConductivity" <> $SessionUUID],
				Object[Part, ConductivityProbe, "Test 731-ISM Conductivity Probe for ExperimentMeasureConductivity Tests" <> $SessionUUID],
				Object[Instrument, ConductivityMeter, "Test Conductivity Meter for ExperimentMeasureConductivity Tests" <> $SessionUUID]
			}],ObjectP[]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force->True, Verbose->False]];
			Unset[$CreatedObjects];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(*Sister functions*)

DefineTests[
	ExperimentMeasureConductivityOptions,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureConductivity call to measure density of a single sample:"},
				ExperimentMeasureConductivityOptions[sample],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureConductivity call to measure density of a multiple sample:"},
				ExperimentMeasureConductivityOptions[{sampleA,sampleB}],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureConductivity call to measure density of a sample in a container:"},
				ExperimentMeasureConductivityOptions[container],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Options, OutputFormat, "Generate a resolved list of options for an ExperimentMeasureConductivity call to measure density of a single sample:"},
				ExperimentMeasureConductivityOptions[sample,OutputFormat->List],
				_?(MatchQ[
					Check[SafeOptions[ExperimentMeasureConductivity, #], $Failed, {Error::Pattern}],
					{(_Rule|_RuleDelayed)..}
				]&)
				,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];


DefineTests[
	ExperimentMeasureConductivityPreview,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureConductivity call to measure density of a single sample (will always be Null):"},
				ExperimentMeasureConductivityPreview[sample],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureConductivity call to measure density of a multiple sample (will always be Null):"},
				ExperimentMeasureConductivityPreview[{sampleA,sampleB}],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureConductivity call to measure density of a sample in a container (will always be Null):"},
				ExperimentMeasureConductivityPreview[container],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True,Site->Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];


DefineTests[
	ValidExperimentMeasureConductivityQ,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureConductivity call to measure the density of a single sample:"},
				ValidExperimentMeasureConductivityQ[sample],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site->Link[$Site], DeveloperObject -> True]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Validate an ExperimentMeasureConductivity call to measure the density of multiple samples:"},
				ValidExperimentMeasureConductivityQ[{sampleA,sampleB}],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site -> Link[$Site], DeveloperObject -> True]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site -> Link[$Site], DeveloperObject -> True]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureConductivity call to filter to measure the density of a sample in a container:"},
				ValidExperimentMeasureConductivityQ[container],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site -> Link[$Site], DeveloperObject -> True]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Options, OutputFormat, "Validate an ExperimentMeasureConductivity call to measure the density a single sample, returning an ECL Test Summary:"},
				ValidExperimentMeasureConductivityQ[sample,OutputFormat->TestSummary],_EmeraldTestSummary,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site -> Link[$Site], DeveloperObject -> True]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Options, Verbose, "Validate an ExperimentMeasureConductivity call to measure the density a single sample, printing a verbose summary of tests as they are run:"},
				ValidExperimentMeasureConductivityQ[sample,Verbose->True],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], Site -> Link[$Site], DeveloperObject -> True]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

