(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureRefractiveIndex : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureRefractiveIndex*)

(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureRefractiveIndex*)

DefineTests[
	ExperimentMeasureRefractiveIndex,
	{
		(* Positive cases and examples *)
		Example[{Basic, "Measure the refractive index of a single sample:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,MeasureRefractiveIndex]]
		],
		Example[{Basic, "Measure the refractive index of a list of samples:"},
			ExperimentMeasureRefractiveIndex[
				{
					Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test water sample 2 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,MeasureRefractiveIndex]]
		],
		Example[{Basic, "Measure the refractive index of a sample in a container:"},
			ExperimentMeasureRefractiveIndex[
				Object[Container,Vessel, "Test container 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,MeasureRefractiveIndex]]
		],

		(* Sample preparation tests *)
		Test["MeasureRefractiveIndex primitive can be used as part of ExperimentSamplePreparation:",
			ExperimentSamplePreparation[{
				MeasureRefractiveIndex[
					Sample ->  Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can be used as part of ExperimentSamplePreparation with sample labels:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> Model[Sample,"Milli-Q water"],
					Container -> Model[Container,Vessel,"50mL Tube"],
					Amount -> (200*Microliter),
					Label -> "my sample"
				],
				Transfer[
					Source -> "my sample",
					Destination -> Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
					Amount -> 50 Microliter,
					DestinationLabel -> "my destination"
				],
				MeasureRefractiveIndex[
				 Sample -> "my sample"
				],
				Incubate[
					Sample -> "my sample",
					Time -> (5 * Minute)
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples with different reading modes:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					},
					RefractiveIndexReadingMode -> {
						FixedMeasurement,
						TemperatureScan
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples and calibrant:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter,
						1 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2",
						"calibrant"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					},
					Calibration -> BeforeRun,
					Calibrant -> "calibrant"
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Incubate->True,
				Centrifuge->True,
				Filtration->True,
				Aliquot->True,
				Output->Options
			];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options}
		],
		(* Make sure it can generate simulation when asked *)
		Example[
			{Additional, "Generates a simulation if output is set to Simulation:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Simulation
			],
			SimulationP
		],
		Example[
			{Additional, "Generates a simulation if output is set to Simulation for multiple input samples:"},
			ExperimentMeasureRefractiveIndex[
				{
					Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test water sample 2 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
				},
				Output -> Simulation
			],
			SimulationP
		],

		(* Messages *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureRefractiveIndex[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureRefractiveIndex[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureRefractiveIndex[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureRefractiveIndex[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel,"50mL Tube"],
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
					InitialAmount -> 50 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMeasureRefractiveIndex[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel,"50mL Tube"],
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
					InitialAmount -> 50 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMeasureRefractiveIndex[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		(* Invalid inputs checks *)
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test discarded sample for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"SolidSamples","If the provided sample is solid, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test solid sample for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::RefractiveIndexNoVolume,Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		Example[{Messages,"SamplesNotInContainers","If the provided sample is not in a container, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test sample without a container for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::SamplesNotInContainers,Error::InvalidInput}
		],
		Example[{Messages,"RefractiveIndexNoVolume","If the provided sample's volume is not populated, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test sample without volume populated for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::RefractiveIndexNoVolume,Error::InvalidInput}
		],
		Example[{Messages,"InsufficientSampleVolume","If the provided sample doesn't have enough volume, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test sample with not enough volume for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::InsufficientVolumeRefractiveIndex,Error::InvalidInput}
		],

		Example[{Messages,"TemperatureStepValueError","If the remainder on division of temperature range by temperature step is not zero, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test sample with a wrong temperature step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20 Celsius, 50 Celsius],
				TemperatureStep -> 7 Celsius
			],
			$Failed,
			Messages :> {Error::TemperatureStepValueError,Error::InvalidOption}
		],
		Example[{Messages,"TimeStepValueError", "If the remainder on division of duration by time step is not zero, an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test sample with a wrong time step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 30 Minute,
				TimeStep -> 7 Minute
			],
			$Failed,
			Messages :> {Error::TimeStepValueError,Error::InvalidOption}
		],
		Example[{Messages,"InvalidRefractiveIndexReadingMode","If NumberOfReads is greater than 1 and RefractiveIndexReadingMode is not FixedMeasurement, then an error will be thrown:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test sample with a wrong time step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				NumberOfReads -> 3
			],
			$Failed,
			Messages :> {Error::InvalidRefractiveIndexReadingMode,Error::InvalidOption}
		],
		Example[{Messages,"CalibrantRefractiveIndexDoesntExist","If provided calibrant doesn't have refactive index value, it throws an error:"},
			ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test sample with a wrong time step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Calibrant -> Model[Sample, "id:Y0lXejGKdEDW"]
			],
			$Failed,
			Messages :> {Error::CalibrantRefractiveIndexDoesntExist,Error::InvalidOption}
		],

			(* Option precision checks *)
		Example[{Options, Temperature, "Rounds specified Temperature to the nearest 0.01 Celsius:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Temperature -> 20.0001 Celsius,
				Output -> Options
			];
			Lookup[options,Temperature],
			20.00 Celsius,
			Messages :> {Warning::InstrumentPrecision},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TemperatureStep, "Rounds specified TemperatureStep to the nearest 0.01 Celsius:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20 Celsius, 30 Celsius],
				TemperatureStep -> 2.0001 Celsius,
				Output -> Options
			];
			Lookup[options, TemperatureStep],
			2.00 Celsius,
			Messages :> {Warning::InstrumentPrecision},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SampleVolume, "Rounds specified SampleVolume to the nearest 1 Microliter:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleVolume -> 130.01 Microliter,
				Output -> Options
			];
			Lookup[options, SampleVolume],
			130 Microliter,
			Messages:> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, SampleFlowRate, "Rounds specified SampleFlowRate to the nearest 1 Microliter/Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleFlowRate -> 2.1 Microliter/Second,
				Output -> Options
			];
			Lookup[options, SampleFlowRate],
			2 Microliter/Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, TimeDuration, "Rounds specified TimeDuration to the nearest 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 180.2 Second,
				Output -> Options
			];
			Lookup[options, TimeDuration],
			180 Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, TimeStep, "Rounds specified TimeStep to the nearest 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 180 Second,
				TimeStep -> 10.2 Second,
				Output -> Options
			];
			Lookup[options, TimeStep],
			10 Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, EquilibrationTime, "Rounds specified EquilibrationTime to the nearest 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				EquilibrationTime -> 10.02 Second,
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			10 Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, WashingVolume, "Rounds specified WashingVolume to the nearest 1 Microliter:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				WashingVolume -> 2000.02 Microliter,
				Output -> Options
			];
			Lookup[options, WashingVolume],
			2000 Microliter,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, WashSoakTime, "Rounds specified WashSoakTime to the nearest 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				WashSoakTime -> 10.02 Second,
				Output -> Options
			];
			Lookup[options, WashSoakTime],
			10 Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, DryTime, "Rounds specified DryTime to the nearest 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				DryTime -> 60.02 Second,
				Output -> Options
			];
			Lookup[options, DryTime],
			60 Second,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, CalibrantVolume, "Rounds specified CalibrantVolume to the nearest 1 Microliter:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Calibration -> BeforeRun,
				CalibrantVolume -> 130.01 Microliter,
				CalibrantStorageCondition -> Disposal,
				Output -> Options
			];
			Lookup[options, CalibrantVolume],
			130 Microliter,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],

		(*Options *)
		(* Label options *)
		Example[{Options, SampleLabel, "Label of the samples that are used to measure refractive index:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleLabel -> "test sample",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"test sample",
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Label of the sample containers that are used to measure refractive index:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleContainerLabel -> "test container",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"test container",
			Variables :> {options}
		],
		Example[{Options,Refractometer,"Specify the instrument used to perform the experiment:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Refractometer -> Model[Instrument,Refractometer,"id:WNa4ZjKl9pq4"],
				Output -> Options
			];
			Lookup[options,Refractometer],
			Model[Instrument,Refractometer,"id:WNa4ZjKl9pq4"],
			Variables :> {options}
		],
		Example[{Options,RefractiveIndexReadingMode,"RefractiveIndexReadingMode option is automatically set to FixedMeasurement if the option is not defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, RefractiveIndexReadingMode],
			FixedMeasurement,
			Variables :> {options}
		],
		Example[{Options,RefractiveIndexReadingMode,"RefractiveIndexReadingMode option is set to the user specified reading mode if the option is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode->TemperatureScan,
				Output -> Options
			];
			Lookup[options, RefractiveIndexReadingMode],
			TemperatureScan,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"SampleVolume option is automatically set to 120 Microliters if the option is not defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, SampleVolume],
			120 Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"SampleVolume option is set to the user specified volume if the option is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleVolume -> 100 Microliter,
				Output -> Options
			];
			Lookup[options, SampleVolume],
			100 Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleFlowRate,"SampleFlowRate option is automatically set to 20% of SampleVolume/Second if the option is set to Automatic:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleVolume -> 120 Microliter,
				Output -> Options
			];
			Lookup[options,SampleFlowRate],
			24.0 Microliter/Second,
			Variables :> {options}
		],
		Example[{Options, SampleFlowRate, "SampleFlowRate option is set to the user specified rate if the option is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SampleFlowRate -> 10 Microliter/Second,
				SampleVolume -> 120 Microliter,
				Output -> Options
			];
			Lookup[options, SampleFlowRate],
			10 Microliter/Second,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates,"NumberOfReplicates option is set to 1 by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			1,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "NumberOfReplicates option is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				NumberOfReplicates -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			3,
			Variables :> {options}
		],
		Example[{Options, NumberOfReads, "NumberOfReads option is set to 1 by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample,"Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfReads],
			1,
			Variables :> {options}
		],
		Example[{Options, Temperature,"With FixedMeasurement mode, Temperature option is set to 20 Celsius by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, Temperature],
			20.00 Celsius,
			Variables :> {options}
		],
		Example[{Options, Temperature, "With FixedMeasurement mode, Temperature option is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Temperature -> 50.00 Celsius,
				Output -> Options
			];
			Lookup[options, Temperature],
			50 Celsius,
			Variables :> {options}
		],
		Example[{Options, Temperature, "With TemperatureScan mode, Temperature option is set to [20, 50] Celsius and TemperatureStep is set to 3 Celsius (temperature range / 10) by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Output -> Options
			];
			Lookup[options, {Temperature,TemperatureStep}],
			{Span[20.00 Celsius, 50.00 Celsius],3.00 Celsius},
			Variables :> {options}
		],
		Example[{Options, Temperature, "With TemperatureScan mode, Temperature option is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[10.00 Celsius,100.00 Celsius],
				Output -> Options
			];
			Lookup[options, {Temperature,TemperatureStep}],
			{Span[10 Celsius, 100 Celsius], 9.00 Celsius},
			Variables :> {options}
		],
		Example[{Options, TemperatureStep, "With TemperatureScan mode, TemperatureStep is automatically set to (temperature range)/10 Celsius:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20.00 Celsius, 70.00 Celsius],
				Output -> Options
			];
			Lookup[options, TemperatureStep],
			5.00 Celsius,
			Variables :> {options}
		],
		Example[{Options, TemperatureStep, "With TemperatureScan mode, TemperatureStep is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20.00 Celsius, 70.00 Celsius],
				TemperatureStep -> 10.00 Celsius,
				Output -> Options
			];
			Lookup[options, TemperatureStep],
			10 Celsius,
			Variables :> {options}
		],
		Example[{Options, TimeDuration, "With TimeScan mode, TimeDuration is automatically set to 2 hours:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				Output -> Options
			];
			Lookup[options, TimeDuration],
			2 Hour,
			Variables :> {options}
		],
		Example[{Options, TimeDuration, "With TimeScan mode, TimeDuration is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 24 Hour,
				Output -> Options
			];
			Lookup[options, TimeDuration],
			24 Hour,
			Variables :> {options}
		],
		Example[{Options, TimeStep, "With TimeScan mode, TimeStep is automatically set to (TimeDuration/10):"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 20 Hour,
				Output -> Options
			];
			Lookup[options, TimeStep],
			2 Hour,
			Variables :> {options}
		],
		Example[{Options, TimeStep, "With TimeScan mode, TimeStep is set to the user specified value if it is defined:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TimeScan,
				TimeDuration -> 30 Hour,
				TimeStep ->  30 Minute,
				Output -> Options
			];
			Lookup[options, TimeStep],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, EquilibrationTime, "With TemperatureScan mode, EquilibrationTime is automatically set to 10 seconds:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20 Celsius, 70 Celsius],
				TemperatureStep -> 10 Celsius,
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			10 Second,
			Variables :> {options}
		],
		Example[{Options, EquilibrationTime, "With FixedMeasurement or TimeScan mode, EquilibrationTime is automatically set to 1 Second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Temperature -> 20 Celsius,
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			1 Second,
			Variables :> {options}
		],
		Example[{Options, EquilibrationTime, "If a user defined EquilibrationTime, then it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> TemperatureScan,
				Temperature -> Span[20 Celsius, 70 Celsius],
				TemperatureStep -> 10 Celsius,
				EquilibrationTime -> 30 Second,
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			30 Second,
			Variables :> {options}
		],
		Example[{Options, MeasurementAccuracy, "MeasurementAccuracy is automatically set to the highest accuracy 0.00001:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, MeasurementAccuracy],
			0.00001,
			Variables :> {options}
		],
		Example[{Options, MeasurementAccuracy, "If a user define MeasurementAccuracy, then it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				MeasurementAccuracy -> 0.00006,
				Output -> Options
			];
			Lookup[options, MeasurementAccuracy],
			0.00006,
			Variables :> {options}
		],
		Example[{Options, PrimaryWashSolution, "PrimaryWashSolution is automatically set to Milli-Q water:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, PrimaryWashSolution],
			Model[Sample, "Milli-Q water"][Object],
			Variables :> {options}
		],
		Example[{Options, PrimaryWashSolution, "If a user provides PrimaryWashSolution, it is set to the user specified model:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				PrimaryWashSolution -> Model[Sample, "Ethanol, Reagent Grade"],
				Output -> Options
			];
			Lookup[options, PrimaryWashSolution],
			Model[Sample, "Ethanol, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, SecondaryWashSolution, "SecondaryWashSolution is automatically set to Ethanol:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, SecondaryWashSolution],
			Model[Sample, "Ethanol, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, SecondaryWashSolution, "If a user provides SecondaryWashSolution, it is set to the user specified model:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				SecondaryWashSolution -> Model[Sample, "Acetone, Reagent Grade"],
				Output -> Options
			];
			Lookup[options, SecondaryWashSolution],
			Model[Sample, "Acetone, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, TertiaryWashSolution, "TertiaryWashSolution is automatically set to Acetone:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, TertiaryWashSolution],
			Model[Sample, "Acetone, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, TertiaryWashSolution, "If a user provides TertiaryWashSolution, it is set to the user specified model:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				TertiaryWashSolution -> Model[Sample, "Ethanol, Reagent Grade"],
				Output -> Options
			];
			Lookup[options, TertiaryWashSolution],
			Model[Sample, "Ethanol, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, WashingVolume, "WashingVolume is automatically set to 2 milliliters:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, WashingVolume],
			2 Milliliter,
			Variables :> {options}
		],
		Example[{Options, WashingVolume, "If a user provides WashingVolume, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				WashingVolume -> 5 Milliliter,
				Output -> Options
			];
			Lookup[options, WashingVolume],
			5 Milliliter,
			Variables :> {options}
		],

		Example[{Options, WashSoakTime, "WashSoakTime is automatically set to 0 second:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, WashSoakTime],
			0 Second,
			Variables :> {options}
		],
		Example[{Options, WashSoakTime, "If a user provides WashSoakTime, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				WashSoakTime -> 5 Minute ,
				Output -> Options
			];
			Lookup[options, WashSoakTime],
			5 Minute,
			Variables :> {options}
		],
		Example[{Options, NumberOfWashes, "NumberOfWashes is automatically set to 2:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, NumberOfWashes],
			2,
			Variables :> {options}
		],
		Example[{Options, NumberOfWashes, "If a user provides NumberOfWashes, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				NumberOfWashes -> 5,
				Output -> Options
			];
			Lookup[options, NumberOfWashes],
			5,
			Variables :> {options}
		],
		Example[{Options, DryTime, "DryTime is automatically set to 5 Minute:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, DryTime],
			5 Minute,
			Variables :> {options}
		],
		Example[{Options, DryTime, "If a user provides DryTime, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				DryTime -> 10 Minute,
				Output -> Options
			];
			Lookup[options, DryTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, Calibration, "Calibration is automatically set to None:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Output -> Options
			];
			Lookup[options, Calibration],
			None,
			Variables :> {options}
		],
		Example[{Options, Calibration, "If a user sets Calibration to BeforeRun, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, Calibration],
			BeforeRun,
			Variables :> {options}
		],
		Example[{Options, Calibration, "If a user sets Calibration to BetweenSamples, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BetweenSamples,
				Output -> Options
			];
			Lookup[options, Calibration],
			BetweenSamples,
			Variables :> {options}
		],
		Example[{Options, Calibrant, "If Calibration is set to BeforeRun or BetweenSamples, Calibrant is automatically set to Milli-Q water:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, Calibrant],
			Model[Sample, "Milli-Q water"],
			Variables :> {options}
		],
		Example[{Options, Calibrant, "If a user provides Calibrant, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Calibrant -> Model[Sample, "Ethanol, Reagent Grade"],
				CalibrantRefractiveIndex -> 1.3614,
				Output -> Options
			];
			Lookup[options, Calibrant],
			Model[Sample, "Ethanol, Reagent Grade"][Object],
			Variables :> {options}
		],
		Example[{Options, CalibrationTemperature, "If Calibration is set to BeforeRun or BetweenSamples, CalibrationTemperature is automatically set to 20 Celsius:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, CalibrationTemperature],
			20.00 Celsius,
			Variables :> {options}
		],
		Example[{Options, CalibrationTemperature, "If a user provides CalibrationTemperature, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				CalibrationTemperature -> 25 Celsius,
				Output -> Options
			];
			Lookup[options, CalibrationTemperature],
			25 Celsius,
			Variables :> {options}
		],
		Example[{Options, CalibrantRefractiveIndex, "If Calibration is set to BeforeRun or BetweenSamples and Calibrant is automatically set to Milli-Q water, CalibrantRefractiveIndex is automatically set to the refractive index of water at 20 Celsius, 1.332987:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, CalibrantRefractiveIndex],
			1.332987,
			Variables :> {options}
		],
		Example[{Options, CalibrantRefractiveIndex,"If a user provides WashingVolume, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				CalibrantRefractiveIndex -> 1.444444,
				Output -> Options
			];
			Lookup[options, CalibrantRefractiveIndex],
			1.444444,
			Variables :> {options}
		],
		Example[{Options, CalibrantVolume, "If Calibration is not None, CalibrantVolume is automatically set to 120 Microliter:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, CalibrantVolume],
			120 Microliter,
			Variables :> {options}
		],
		Example[{Options, CalibrantVolume, "If Calibration is not None and a user provides CalibrantVolume, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				CalibrantVolume -> 150 Microliter,
				Output -> Options
			];
			Lookup[options, CalibrantVolume],
			150 Microliter,
			Variables :> {options}
		],
		Example[{Options, CalibrantStorageCondition, "If Calibration is not None, CalibrantStorageCondition is set to Disposal by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				Output -> Options
			];
			Lookup[options, CalibrantStorageCondition],
			Disposal,
			Variables :> {options}
		],
		Example[{Options, CalibrantStorageCondition,"If a user provides CalibrantStorageCondition, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RefractiveIndexReadingMode -> FixedMeasurement,
				Calibration -> BeforeRun,
				CalibrantStorageCondition -> AmbientStorage,
				Output -> Options
			];
			Lookup[options, CalibrantStorageCondition],
			AmbientStorage,
			Variables :> {options}
		],
		Example[{Options, RecoupSample, "RecoupSample is automatically set to False:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, RecoupSample],
			False,
			Variables :> {options}
		],
		Example[{Options, RecoupSample, "If a user sets RecoupSample, it is set to the user specified value:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, RecoupSample],
			True,
			Variables :> {options}
		],
		Example[{Options, Preparation, "Preparation is set to Manual by default:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],

(*		*)(* Additional option tests *)
(*		*)(* Sample Prep option tests *)
		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Template -> Null
			];
			Download[protocol, Template],
			Null,
			Variables :> {protocol}
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Name->"My particular RI protocol name"<>$SessionUUID];
			Download[protocol,Name],
			"My particular RI protocol name"<>$SessionUUID,
			Variables :> {protocol}
		],
		Example[
			{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentMeasureRefractiveIndex[
				{"salty sample 1", "salty sample 2"},
				PreparatoryUnitOperations -> {
					LabelSample[
						Label -> "salty sample 1",
						Sample -> Model[Sample, StockSolution, "NaCl Solution in Water"],
						Container -> Model[Container, Vessel, "2mL Tube"],
						Amount->1 Milliliter
					],
					LabelSample[
						Label -> "salty sample 2",
						Sample -> Model[Sample, StockSolution, "NaCl Solution in Water"],
						Container -> Model[Container, Vessel, "2mL Tube"],
						Amount->1 Milliliter
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{ManualSamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMeasureRefractiveIndex[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				PreparedModelAmount -> 20 Milliliter,
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
				{EqualP[20 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				IncubateAliquotDestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				CentrifugeAliquotDestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				FilterAliquotDestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"Test Label for ExperimentMeasureRefractiveIndex 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label for ExperimentMeasureRefractiveIndex 1"},
			Variables:>{options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				AliquotAmount -> 400 Microliter,
				Output -> Options
			];
			Lookup[options, AliquotAmount],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				TargetConcentration -> 5 Micromolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Uracil"],
				Output -> Options
			];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				AliquotContainer -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"],
				DestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, DestinationWell],
			{"A2"},
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentMeasureRefractiveIndex[
				{
					Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test water sample 2 for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
				},
				Aliquot -> True,
				AliquotPreparation -> Manual,
				Output -> Options
			];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentMeasureRefractiveIndex[
				Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
				SamplesOutStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

(*		 ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],


(*		 Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle.*)

		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
(*		 Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle.*)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], IncubateAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
(*		*)(**)(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

(*		*)(**)(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
(*		 Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeInstrument ->Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
(*		Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeAliquot -> 0.5Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

(*		 filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], PrefilterMaterial -> GxF,FilterMaterial->PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],  PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterAliquot -> 1 Milliliter, FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],  FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],  FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTemperature -> 22*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],

(*		 aliquot options*)
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AliquotAmount -> 150 Microliter, Output -> Options];
			Lookup[options, AliquotAmount],
			150 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AssayVolume -> 0.12*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.12*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], TargetConcentration -> 5*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount->5*Milliliter, AssayVolume->20*Milliliter, AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],MeasureVolume->True],
				MeasureVolume
			],
			True
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentMeasureRefractiveIndex[Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex"<>$SessionUUID],MeasureWeight->True],
				MeasureWeight
			],
			True
		]
	},
	SymbolSetUp:> {
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{numContainer,testObjList, existsFilter},
			numContainer = 11;
			testObjList = Join[
				Flatten[{Object[Container, Vessel, "Test container "<>ToString[#]<>" for ExperimentMeasureRefractiveIndex" <> $SessionUUID]}&/@Range[numContainer]],
				List[
					Object[Container, Vessel, "Test calibrant container for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test water sample 1 for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test water sample 2 for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test water sample 3 for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test calibrant for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test discarded sample for ExperimentMeasureRefractiveIndex" <> $SessionUUID],
					Object[Sample, "Test solid sample for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test sample without a container for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test sample without volume populated for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test sample with not enough volume for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample,"Test sample with missing temperature step option for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample,"Test sample with a wrong temperature step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID],
					Object[Sample, "Test sample with a wrong time step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID]
				]
			];

			existsFilter = DatabaseMemberQ[testObjList];
			EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		];

		Module[
			{numContainer, emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, calibrantContainer,
				waterSample1, waterSample2, waterSample3, calibrantSample, discardedSample, solidSample, sampleWithoutContainer,
				sampleWithoutVolumePopulated, sampleNotEnoughVolume,
				sampleMissingTempStep, sampleWrongTempStep, sampleWrongTimeStep},

			numContainer = 11;
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
				emptyContainer9,
				emptyContainer10,
				emptyContainer11,
				calibrantContainer
			} = Upload[Join[
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel,"50mL Tube"], Objects],
          Name -> "Test container "<>ToString[#]<>" for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>&/@Range[numContainer],
				{<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel,"50mL Tube"], Objects],
					Name -> "Test calibrant container for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>}
			]];

			(* Create some samples *)
			{
				(*1*)waterSample1,
				(*2*)waterSample2,
				(*3*)waterSample3,
				(*4*)discardedSample,
				(*5*)solidSample,
				(*6*)sampleWithoutContainer,
				(*7*)sampleWithoutVolumePopulated,
				(*8*)sampleNotEnoughVolume,
				(*9*)sampleMissingTempStep,
				(*10*)sampleWrongTempStep,
				(*11*)sampleWrongTimeStep,
				(*12*)calibrantSample
			} = UploadSample[
				{
					(*1*)Model[Sample, "Milli-Q water"],
					(*2*)Model[Sample, "Milli-Q water"],
					(*3*)Model[Sample, "Milli-Q water"],
					(*4*)Model[Sample, "Milli-Q water"],
					(*5*)Model[Sample, "Fluorescein, sodium salt"],
					(*6*)Model[Sample, "Milli-Q water"],
					(*7*)Model[Sample, "Milli-Q water"],
					(*8*)Model[Sample, "Milli-Q water"],
					(*9*)Model[Sample, "Milli-Q water"],
					(*10*)Model[Sample, "Milli-Q water"],
					(*11*)Model[Sample, "Milli-Q water"],
					(*12*)Model[Sample, "Milli-Q water"]
				},
				{
					(*1*){"A1", emptyContainer1},
					(*2*){"A1", emptyContainer2},
					(*3*){"A1", emptyContainer3},
					(*4*){"A1", emptyContainer4},
					(*5*){"A1", emptyContainer5},
					(*6*){"A1", emptyContainer6},
					(*7*){"A1", emptyContainer7},
					(*8*){"A1", emptyContainer8},
					(*9*){"A1", emptyContainer9},
					(*10*){"A1", emptyContainer10},
					(*11*){"A1", emptyContainer11},
					(*12*){"A1", calibrantContainer}
				},
				InitialAmount -> {
					(*1*)50 Milliliter,
					(*2*)1 Milliliter,
					(*3*)1 Milliliter,
					(*4*)1 Milliliter,
					(*5*)100 Milligram,
					(*6*)1 Milliliter,
					(*7*)Null,
					(*8*)1 Microliter,
					(*9*)1 Milliliter,
					(*10*)1 Milliliter,
					(*11*)1 Milliliter,
					(*12*)5 Milliliter
				},
				Name -> {
					(*1*)"Test water sample 1 for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					(*2*)"Test water sample 2 for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					(*3*)"Test water sample 3 for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					(*4*)"Test discarded sample for ExperimentMeasureRefractiveIndex" <> $SessionUUID,
					(*5*)"Test solid sample for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*6*)"Test sample without a container for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*7*)"Test sample without volume populated for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*8*)"Test sample with not enough volume for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*9*)"Test sample with missing temperature step option for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*10*)"Test sample with a wrong temperature step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*11*)"Test sample with a wrong time step value for ExperimentMeasureRefractiveIndex"<>$SessionUUID,
					(*12*)"Test calibrant for ExperimentMeasureRefractiveIndex" <> $SessionUUID
				}
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[{
				<|
					Object -> waterSample1,
					Status -> Available,
					DeveloperObject -> True,
					Replace[Composition] ->  {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {10 Micromolar, Link[Model[Molecule, "Uracil"]], Now}}
				|>,
				<|
					Object -> waterSample2,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> waterSample3,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> discardedSample,
					Status -> Discarded,
					DeveloperObject -> True
				|>,
				<|
					Object -> solidSample,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleWithoutContainer,
					Status -> Available,
					Container -> Null,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleWithoutVolumePopulated,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleNotEnoughVolume,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleMissingTempStep,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleWrongTempStep,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> sampleWrongTimeStep,
					Status -> Available,
					DeveloperObject -> True
				|>,
				<|
					Object -> calibrantSample,
					Status -> Available,
					DeveloperObject -> True
				|>
			}];
		]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		$Notebook=Null
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(* MeasureRefractiveIndex *)


DefineTests[
	MeasureRefractiveIndex,
	{
		Test["MeasureRefractiveIndex primitive can be used as part of ExperimentSamplePreparation with sample labels:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> Model[Sample,"Milli-Q water"],
					Container -> Model[Container,Vessel,"50mL Tube"],
					Amount -> (200*Microliter),
					Label -> "my sample"
				],
				Transfer[
					Source -> "my sample",
					Destination -> Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
					Amount -> 50 Microliter,
					DestinationLabel -> "my destination"
				],
				MeasureRefractiveIndex[
					Sample -> "my sample"
				],
				Incubate[
					Sample -> "my sample",
					Time -> (5 * Minute)
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples with different reading modes:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					},
					RefractiveIndexReadingMode -> {
						FixedMeasurement,
						TemperatureScan
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["MeasureRefractiveIndex primitive can accept a list of samples and calibrant:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample -> {
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount -> {
						5 Milliliter,
						5 Milliliter,
						1 Milliliter
					},
					Label -> {
						"sample 1",
						"sample 2",
						"calibrant"
					}
				],
				MeasureRefractiveIndex[
					Sample -> {
						"sample 1",
						"sample 2"
					},
					Calibration -> BeforeRun,
					Calibrant -> "calibrant"
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
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


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureRefractiveIndexOptions*)


DefineTests[
	ExperimentMeasureRefractiveIndexOptions,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureRefractiveIndex with a single sample:"},
				ExperimentMeasureRefractiveIndexOptions[sample],
				_Grid,
				SetUp :> {
					model = Upload[<|
							Type -> Model[Sample],
							DeveloperObject -> True,
							State -> Liquid
						|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]
						|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]}
			]
		],
		
		Module[{model,modelContainer,sampleA,sampleB,containerA,containerB},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureRefractiveIndex with a multiple sample:"},
				ExperimentMeasureRefractiveIndexOptions[{sampleA,sampleB}],
				_Grid,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]
						|>}
					|>];
					
					containerA = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]
					|>];
					
					containerB = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]
					|>];
					
					sampleA = UploadSample[
						model,
						{"A1",containerA},
						StorageCondition -> AmbientStorage,
						InitialAmount -> 10 Milliliter
					];
					
					sampleB = UploadSample[
						model,
						{"A1",containerB},
						StorageCondition -> AmbientStorage,
						InitialAmount -> 10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureRefractiveIndex with a sample in a container:"},
				ExperimentMeasureRefractiveIndexOptions[container],
				_Grid,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]
						|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel]
						,Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
			]
		],
		
		(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Options, OutputFormat, "Generate a resolved list of options for an ExperimentMeasureRefractiveIndex with a single sample:"},
				ExperimentMeasureRefractiveIndexOptions[
					Object[Sample,"ExperimentMeasureRefractiveIndexOptions sample"<>$SessionUUID],
					OutputFormat -> List
				],
				{_Rule..},
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						Name->"ExperimentMeasureRefractiveIndexOptions sample"<>$SessionUUID,
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
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

(* ::Subsubsection::Closed:: *)
(* ExperimentMeasureRefractiveIndexPreview *)

DefineTests[
	ExperimentMeasureRefractiveIndexPreview,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureRefractiveIndex with a single sample (will always be Null):"},
				ExperimentMeasureRefractiveIndexPreview[sample],
				Null,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureRefractiveIndex with a multiple sample (will always be Null):"},
				ExperimentMeasureRefractiveIndexPreview[{sampleA,sampleB}],
				Null,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					containerA = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					containerB = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sampleA = UploadSample[
						model,
						{"A1",containerA},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
					
					sampleB = UploadSample[
						model,
						{"A1",containerB},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureRefractiveIndex with a sample in a container (will always be Null):"},
				ExperimentMeasureRefractiveIndexPreview[container],
				Null,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
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

(* ::Subsubsection::Closed:: *)
(* ValidExperimentMeasureRefractiveIndexQ *)

DefineTests[
	ValidExperimentMeasureRefractiveIndexQ,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureRefractiveIndex call with a single sample:"},
				ValidExperimentMeasureRefractiveIndexQ[sample],
				True,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Validate an ExperimentMeasureRefractiveIndex with a multiple samples:"},
				ValidExperimentMeasureRefractiveIndexQ[{sampleA,sampleB}],
				True,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					containerA = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					containerB = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sampleA = UploadSample[
						model,
						{"A1",containerA},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
					
					sampleB = UploadSample[
						model,
						{"A1",containerB},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureRefractiveIndex with a sample in a container:"},
				ValidExperimentMeasureRefractiveIndexQ[container],
				True,
				SetUp :> {
					model=Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown :> {
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
			]
		],
		
		(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Options, OutputFormat, "Validate an ExperimentMeasureRefractiveIndex with a single sample, returning an ECL Test Summary:"},
				ValidExperimentMeasureRefractiveIndexQ[sample, OutputFormat -> TestSummary],
				_EmeraldTestSummary,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown:>{
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
			]
		],
		
		Module[{model,modelContainer,container,sample},
			Example[
				{Options, Verbose, "Validate an ExperimentMeasureRefractiveIndex with a single sample, printing a verbose summary of tests as they are run:"},
				ValidExperimentMeasureRefractiveIndexQ[sample, Verbose->True],
				True,
				SetUp :> {
					model = Upload[<|
						Type -> Model[Sample],
						DeveloperObject -> True,
						State -> Liquid|>];
					
					modelContainer = Upload[<|
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|
							Name -> "A1",
							Footprint -> Null,
							MaxWidth -> Quantity[0.028575`, "Meters"],
							MaxDepth -> Quantity[0.028575`, "Meters"],
							MaxHeight -> Quantity[0.1143`, "Meters"]|>}
					|>];
					
					container = Upload[<|
						Type -> Object[Container, Vessel],
						Model -> Link[modelContainer, Objects],
						DeveloperObject -> True,
						Site->Link[$Site]|>];
					
					sample = UploadSample[
						model,
						{"A1",container},
						StorageCondition -> AmbientStorage,
						InitialAmount->10 Milliliter
					];
				},
				TearDown:>{
					EraseObject[{model,modelContainer,container,sample},Force->True,Verbose->False]
				}
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
