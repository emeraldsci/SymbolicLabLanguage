(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentGrind*)


DefineTests[ExperimentGrind,
	{
		(* --- Basic --- *)
		Example[
			{Basic, "Creates a protocol to grind a solid sample:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Grind]]
		],

		Example[
			{Basic, "Accepts an input container containing a solid sample:"},
			ExperimentGrind[
				Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Grind]]
		],

		Example[
			{Basic, "Grinds a list of inputs (samples or containers) containing solid samples:"},
			ExperimentGrind[{
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, Grind]]
		],

		Example[
			{Basic, "Successfully generates a grind protocol for a solid sample that does not have a model:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 15 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Grind]],
			SetUp :> Upload[<|Object -> Object[Sample, "Test sample for ExperimentGrind 15 " <> $SessionUUID], Model -> Null|>],
			TearDown :> Upload[<|Object -> Object[Sample, "Test sample for ExperimentGrind 15 " <> $SessionUUID], Model -> Link[Model[Sample, "Sodium Chloride"], Objects]|>]
		],

		(* Output Options *)
		Example[
			{Basic, "Generates a list of tests if Output is set to Tests:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Output -> Tests
			],
			{_EmeraldTest..}
		],

		Example[
			{Basic, "Generates a simulation if output is set to Simulation:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		],

		(* --- Grind Options --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentGrind[
				{Model[Sample, "Sodium Chloride"], Model[Sample, "Sodium Chloride"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 100 Milligram,
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
				{ObjectP[Model[Sample, "id:BYDOjv1VA88z"]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[100 Milligram]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Ensure that PreparedSamples is populated properly if doing model input:"},
			prot = ExperimentGrind[
				{Model[Sample, "Sodium Chloride"], Model[Sample, "Sodium Chloride"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 100 Milligram
			];
			Download[prot, PreparedSamples],
			{{_String, _Symbol, __}..},
			Variables :> {prot},
			TimeConstraint -> 600
		],
		Example[
			{Options, GrinderType, "Determine the type of the grinder to grind the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				Output -> Options
			];
			Lookup[options, GrinderType],
			KnifeMill,
			Variables :> {options}
		],

		Example[
			{Options, Instrument, "Determine the instrument to grind the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Instrument -> Model[Instrument, Grinder, "Tube Mill Control"],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, Grinder, "Tube Mill Control"]],
			Variables :> {options}
		],

		Example[
			{Options, Amount, "Determine the amount of the sample for grinding:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Output -> Options,
				Amount -> 1 Gram
			];
			Lookup[options, Amount],
			1 Gram,
			Variables :> {options},
			EquivalenceFunction -> EqualQ
		],

		Example[
			{Options, Fineness, "Determine the Fineness of the sample (the largest size of the particles of the sample):"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Fineness -> 0.5 Millimeter,
				Output -> Options
			];
			Lookup[options, Fineness],
			0.5 Millimeter,
			Variables :> {options}
		],

		Example[
			{Options, BulkDensity, "Determine the bulk density of the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				BulkDensity -> 0.5 Gram / Milliliter,
				Output -> Options
			];
			Lookup[options, BulkDensity],
			0.5 Gram / Milliliter,
			Variables :> {options}
		],

		Example[
			{Options, GrindingContainer, "Determine the container that the sample is transferred into to be ground:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingContainer -> PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter],
				Output -> Options
			];
			Lookup[options, GrindingContainer],
			ObjectP[PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter]],
			Variables :> {options}
		],

		Example[
			{Options, GrindingBead, "Determine the beads that are used in ball mills to grind the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingBead -> Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingBead],
			ObjectP[Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID]],
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingBeads, "Determine the beads that are used in ball mills to grind the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				NumberOfGrindingBeads -> 2,
				Output -> Options
			];
			Lookup[options, NumberOfGrindingBeads],
			2,
			Variables :> {options}
		],

		Example[
			{Options, GrindingRate, "Determine the grinding rate of the grinder:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingRate -> 3000 RPM,
				Output -> Options
			];
			Lookup[options, GrindingRate],
			3000 RPM,
			Variables :> {options}
		],

		Example[
			{Options, Time, "Determine the duration that the sample is being ground inside the grinder:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Time -> 1 Minute,
				Output -> Options
			];
			Lookup[options, Time],
			1 Minute,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingSteps, "Determine the number of times that the sample is being ground in the grinder:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				NumberOfGrindingSteps -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfGrindingSteps],
			3,
			Variables :> {options}
		],

		Example[
			{Options, CoolingTime, "Determine the duration of the cooling step between each grinding step:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				CoolingTime -> 1 Minute,
				NumberOfGrindingSteps -> 3,
				Output -> Options
			];
			Lookup[options, CoolingTime],
			1 Minute,
			Variables :> {options}
		],

		Example[
			{Options, GrindingProfile, "Determine a paired list of time and activities of the grinding process in the form of Activity (Grinding or Cooling), Duration, and GrindingRate:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingProfile -> {{2900 RPM, 10 Second}, {50 Second}, {4000 RPM, 10 Second}},
				Output -> Options
			];
			Lookup[options, GrindingProfile],
			{{2900 RPM, 10 Second}, {50 Second}, {4000 RPM, 10 Second}},
			Variables :> {options}
		],

		Example[
			{Options, SampleLabel, "Determine a value for labeling the sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				SampleLabel -> "My awesome sample to be ground",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"My awesome sample to be ground",
			Variables :> {options}
		],

		Example[
			{Options, SampleOutLabel, "Determines a value for labeling the grinding output sample:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				SampleOutLabel -> "My awesome ground sample",
				Output -> Options
			];
			Lookup[options, SampleOutLabel],
			"My awesome ground sample",
			Variables :> {options}
		],

		Example[
			{Options, ContainerOut, "Determine the container that the output samples (SamplesOut) are transferred into:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				ContainerOut -> Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ContainerOut],
			ObjectP[Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID]],
			Variables :> {options}
		],

		Example[
			{Options, ContainerOutLabel, "Determines a value for labeling the grinding output container:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				ContainerOutLabel -> "The container of my awesome ground sample",
				Output -> Options
			];
			Lookup[options, ContainerOutLabel],
			"The container of my awesome ground sample",
			Variables :> {options}
		],

		Example[
			{Options, SamplesOutStorageCondition, "Determine the storage condition of the output samples (SampleOut):"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				SamplesOutStorageCondition -> Model[StorageCondition, "Ambient Storage, Desiccated"],
				Output -> Options
			];
			Lookup[options, SamplesOutStorageCondition],
			ObjectP[Model[StorageCondition, "Ambient Storage, Desiccated"]],
			Variables :> {options}
		],

		(* --- Shared Options --- *)
		Example[{Options, PreparatoryUnitOperations, "Specifies prepared samples for ExperimentGrind (PreparatoryUnitOperations):"},
			Lookup[ExperimentGrind["My Grind Sample",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Grind Sample",
						Container -> PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter]
					],
					Transfer[
						Source -> {
							Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
							Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID]
						},
						Destination -> "My Grind Sample",
						Amount -> {0.1 Gram, 0.2 Gram}
					]
				},
				Output -> Options
			], PreparatoryUnitOperations],
			{SamplePreparationP..}
		],

		Example[
			{Options, Name, "Uses an object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			Lookup[
				ExperimentGrind[
					Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
					Name -> "Max E. Mumm's Grind Sample",
					Output -> Options
				],
				Name
			],
			"Max E. Mumm's Grind Sample"
		],

		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Lookup[
				ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
					MeasureWeight -> True,
					Output -> Options],
				MeasureWeight
			],
			True
		],

		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Lookup[
				ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
					MeasureWeight -> True,
					Output -> Options],
				MeasureVolume
			],
			True
		],

		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
			options = ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				ImageSample -> True,
				Output -> Options
			];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],

		Example[{Options, Template, "Inherits options from a previously run grind protocol:"},
			options = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Template -> Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Time],
			2 Minute,
			Variables :> {options}
		],

		(* ---  Messages --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentGrind[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentGrind[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentGrind[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentGrind[Object[Container, Vessel, "id:12345678"]],
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
					Model[Sample, "Sodium Chloride"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 100 Milligram
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentGrind[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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
					Model[Sample, "Sodium Chloride"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 100 Milligram
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentGrind[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "NonSolidSample", "All samples have mass information:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::MissingMassInformation]
			}
		],

		Example[{Messages, "InsufficientAmount", "The amount of the sample might be too small for efficient grinding of the sample:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Amount -> 0.05 Gram
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::InsufficientAmount]
			}
		],

		Example[{Messages, "ExcessiveAmount", "The specified Amount might be too much to be ground by the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Amount -> 200 Gram
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::ExcessiveAmount]
			}
		],

		Example[{Messages, "LargeParticles", "The Fineness of the sample (the size of the largest particles in the sample) is too large to be ground by the available grinders:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Fineness -> 15 Millimeter,
				Amount -> 20 Gram
			],
			$Failed,
			Messages :> {
				Message[Error::LargeParticles],
				Message[Error::LargeParticles],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "HighGrindingRate", "The specified GrindingRate(s) are not greater than the maximum grinding rate of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingRate -> 5000 RPM
			],
			$Failed,
			Messages :> {
				Message[Error::HighGrindingRate],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "HighGrindingRate", "The specified grinding rates in GrindingProfile are not greater than the maximum grinding rate of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingProfile -> {{10000 RPM, 10 Second}, {20 Second}, {40 Minute}}
			],
			$Failed,
			Messages :> {
				Message[Error::HighGrindingRate],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "LowGrindingRate", "The specified GrindingRate(s) are not smaller than the minimum grinding rate of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingRate -> 500 RPM
			],
			$Failed,
			Messages :> {
				Message[Error::LowGrindingRate],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "LowGrindingRate", "The specified grinding rates in GrindingProfile are not smaller than the minimum grinding rate of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingProfile -> {{100 RPM, 10 Second}, {20 Second}, {40 Minute}}
			],
			$Failed,
			Messages :> {
				Message[Error::LowGrindingRate],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "HighGrindingTime", "The specified grinding Time(s) are not greater than the maximum grinding time that the timer of the specified instrument measures:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Time -> $MaxExperimentTime
			],
			$Failed,
			Messages :> {
				Message[Error::HighGrindingTime],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "HighGrindingTime", "The specified grinding times in GrindingProfile are not greater than the maximum grinding time of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingProfile -> {{3000 RPM, 10 Hour}, {$MaxExperimentTime}, {40 Minute}}
			],
			$Failed,
			Messages :> {
				Message[Error::HighGrindingTime],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "LowGrindingTime", "The specified grinding Time(s) are not smaller than the minimum grinding time that the timer of the specified instrument measures:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Time -> 1 Second
			],
			$Failed,
			Messages :> {
				Message[Error::LowGrindingTime],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "LowGrindingTime", "The specified grinding times in GrindingProfile are not smaller than the minimum grinding time of the specified grinder:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingProfile -> {{3000 RPM, 10 Hour}, {$MaxExperimentTime}, {40 Minute}}
			],
			$Failed,
			Messages :> {
				Message[Error::HighGrindingTime],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "ModifiedNumberOfGrindingSteps", "The NumberOfGrindingSteps change due to the specified parameters in GrindingProfile:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				NumberOfGrindingSteps -> 5,
				GrindingProfile -> {{3000 RPM, 5 Second}, {30 Second}, {3000 RPM, 10 Second}}
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::ModifiedNumberOfGrindingSteps]
			}
		],

		Example[{Messages, "ModifiedGrindingRates", "The specified GrindingRate(s) change due to specifying different parameters in GrindingProfile:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				GrindingRate -> 2800 RPM,
				GrindingProfile -> {{2800 RPM, 5 Second}, {30 Second}, {3000 RPM, 10 Second}}
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::ModifiedGrindingRates]
			}
		],

		Example[{Messages, "ModifiedGrindingTimes", "The specified grinding Time(s) change due to specifying different parameters in GrindingProfile:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Time -> 10 Second,
				GrindingProfile -> {{2800 RPM, 5 Second}, {30 Second}, {3000 RPM, 10 Second}}
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::ModifiedGrindingTimes]
			}
		],

		Example[{Messages, "ModifiedCoolingTimes", "The specified cooling time in GrindingProfile is different from the specified CoolingTime option:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				CoolingTime -> 1 Minute,
				GrindingProfile -> {{2800 RPM, 5 Second}, {30 Second}, {3000 RPM, 10 Second}}
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::ModifiedCoolingTimes]
			}
		],

		Example[{Messages, "CoolingTimeMismatch", "Throw an error if NumberOfGrindingSteps is greater than 1 but CoolingTime is Null."},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				CoolingTime -> Null,
				NumberOfGrindingSteps -> 2
			],
			$Failed,
			Messages :> {
				Message[Error::CoolingTimeMismatch],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidSamplesOutStorageCondition", "Throw an error if SamplesOutStorageCondition is not informed for samples that their StorageCondition or their model's DefaultStorageCondition is not populated:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Message[Error::InvalidSamplesOutStorageCondition],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "MissingMassInformation", "The Mass of the sample is informed:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, Grind]],
			Messages :> {
				Message[Warning::MissingMassInformation]
			}
		],
		Example[{Messages, "GrindingContainerMismatch", "The Mass of the sample is informed:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingContainer -> Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages :> {
				Message[Error::GrindingContainerMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "GrinderTypeOptionMismatch", "Throw an error if the specified grinder and grinder type do not match:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Instrument -> Model[Instrument, Grinder, "BeadBug3"],
				GrinderType -> KnifeMill
			],
			$Failed,
			Messages :> {
				Message[Error::GrinderTypeOptionMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "GrindingBeadMismatch", "Throw an error if GrinderType is not BalMill but GrindingBead is specified:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				GrindingBead -> Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"]
			],
			$Failed,
			Messages :> {
				Message[Error::GrindingBeadMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "GrindingBeadMismatch", "Throw an error if GrinderType is BalMill but GrindingBead is set to Null:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrinderType -> BallMill,
				GrindingBead -> Null
			],
			$Failed,
			Messages :> {
				Message[Error::GrindingBeadMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "NumberOfGrindingBeadsMismatch", "Throw an error if GrindingBead is set to Null but NumberOfGrindingBeads is not Null or Automatic:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				GrindingBead -> Null,
				NumberOfGrindingBeads -> 10
			],
			$Failed,
			Messages :> {
				Message[Error::NumberOfGrindingBeadsMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "NumberOfGrindingBeadsMismatch", "Throw an error if GrindingBead is set to a model but NumberOfGrindingBeads is set to Null:"},
			ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				GrindingBead -> Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"],
				NumberOfGrindingBeads -> Null
			],
			$Failed,
			Messages :> {
				Message[Error::NumberOfGrindingBeadsMismatch],
				Message[Error::InvalidOption]
			}
		],
		Example[{Additional, "When called to grind a tablet sample, relevant fields are updated in simulation:"},
			{options, simulation} = ExperimentGrind[
				Object[Sample, "Test sample for ExperimentGrind 16 " <> $SessionUUID],
				Output-> {Options, Simulation}
			];
			Download[
				{
					Object[Sample, "Test sample for ExperimentGrind 16 " <> $SessionUUID],
					LookupLabeledObject[simulation, Lookup[options, SampleOutLabel]]
				},
				{Tablet, SampleHandling, Count},
				Simulation -> simulation
			],
			{{True, Itemized, EqualP[5]}, {Null, Null, Null}},
			Variables :> {options, simulation}
		]
	},

	SetUp :> (ClearMemoization[]),

	TurnOffMessages :> {
		Warning::SamplesOutOfStock,
		Warning::InstrumentUndergoingMaintenance,
		Warning::DeprecatedProduct,
		Warning::SampleMustBeMoved
	},

	SymbolSetUp :> (

		$CreatedObjects = {};

		Module[
			{allObjects},

			(* list of test objects*)
			allObjects = {
				Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID],
				Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 15 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 16 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 17 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 18 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 19 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 20 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 21 " <> $SessionUUID],

				(* sample models *)
				Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
				Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
				Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],

				(* sample objects *)
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 6 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 7 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 8 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 9 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 10 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 13 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 15 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 16 " <> $SessionUUID],

				(* Protocol Object *)
				Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[
				{
					testBench, noStateSampleModelPacket, noStorageConditionModelPacket,
					liquidSampleModelPacket, testSampleModels, testSampleLocations,
					testSampleAmounts, testSampleNames, createdSamples
				},

				(* create all the containers and identity models, and Cartridges *)

				Upload[
					(* Test bench to upload samples *)
					testBench = <|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Testing bench for ExperimentGrind Tests" <> $SessionUUID,
						Site -> Link[$Site]
					|>];

				UploadSample[
					Flatten[{
						Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"],
						ConstantArray[PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter], 21]
					}],
					ConstantArray[{"Work Surface", Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID]}, 22],
					Name -> {
						"Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID,
						"Test container for ExperimentGrind 1 " <> $SessionUUID,
						"Test container for ExperimentGrind 2 " <> $SessionUUID,
						"Test container for ExperimentGrind 3 " <> $SessionUUID,
						"Test container for ExperimentGrind 4 " <> $SessionUUID,
						"Test container for ExperimentGrind 5 " <> $SessionUUID,
						"Test container for ExperimentGrind 6 " <> $SessionUUID,
						"Test container for ExperimentGrind 7 " <> $SessionUUID,
						"Test container for ExperimentGrind 8 " <> $SessionUUID,
						"Test container for ExperimentGrind 9 " <> $SessionUUID,
						"Test container for ExperimentGrind 10 " <> $SessionUUID,
						"Test container for ExperimentGrind 11 " <> $SessionUUID,
						"Test container for ExperimentGrind 12 " <> $SessionUUID,
						"Test container for ExperimentGrind 13 " <> $SessionUUID,
						"Test container for ExperimentGrind 14 " <> $SessionUUID,
						"Test container for ExperimentGrind 15 " <> $SessionUUID,
						"Test container for ExperimentGrind 16 " <> $SessionUUID,
						"Test container for ExperimentGrind 17 " <> $SessionUUID,
						"Test container for ExperimentGrind 18 " <> $SessionUUID,
						"Test container for ExperimentGrind 19 " <> $SessionUUID,
						"Test container for ExperimentGrind 20 " <> $SessionUUID,
						"Test container for ExperimentGrind 21 " <> $SessionUUID}
				];

				noStateSampleModelPacket = <|
					BiosafetyLevel -> "BSL-1",
					Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DOTHazardClass -> "Class 0",
					Expires -> False,
					Flammable -> False,
					Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
					MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
					NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
					Type -> Model[Sample],
					Name -> "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
					Replace[Synonyms] -> {"Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID}
				|>;

				noStorageConditionModelPacket = <|
					BiosafetyLevel -> "BSL-1",
					Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
					DOTHazardClass -> "Class 0",
					Expires -> False,
					Flammable -> False,
					Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
					MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
					NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
					State -> Solid,
					Type -> Model[Sample],
					Name -> "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
					Replace[Synonyms] -> {"Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID}
				|>;

				liquidSampleModelPacket = <|
					BiosafetyLevel -> "BSL-1",
					Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DOTHazardClass -> "Class 0",
					Expires -> False,
					Flammable -> False,
					Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
					MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
					NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
					State -> Liquid,
					Type -> Model[Sample],
					Name -> "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
					Replace[Synonyms] -> {"Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID}
				|>;

				(* Upload all models plus a template protocol*)
				Upload[Flatten[{
					noStateSampleModelPacket,
					liquidSampleModelPacket,
					noStorageConditionModelPacket,
					<|
						Type -> Object[Protocol, Grind],
						Name -> "Test Grind option template protocol" <> $SessionUUID,
						ResolvedOptions -> {Time -> 2 Minute}
					|>,
					<|
						Object -> Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
						Count -> 1000
					|>
				}]];

				testSampleModels = {
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
					Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],
					Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "Sodium Chloride"],
					Model[Sample, "id:zGj91a7RJ5mL"] (* "Ibuprofen tablets 500 Count" *)
				};

				testSampleLocations = {
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 15 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "Test container for ExperimentGrind 21 " <> $SessionUUID]}
				};

				testSampleAmounts = {
					250 Gram,
					1.25 Gram,
					1.25 Gram,
					1.7 Gram,
					1.6 Gram,
					1.5 Gram,
					.3 Gram,
					.4 Gram,
					.5 Gram,
					.95 Gram,
					10 Milliliter,
					1.95 Gram,
					Null,
					Null,
					1 Gram,
					5
				};

				testSampleNames = {
					"Test sample for ExperimentGrind 1 " <> $SessionUUID,
					"Test sample for ExperimentGrind 2 " <> $SessionUUID,
					"Test sample for ExperimentGrind 3 " <> $SessionUUID,
					"Test sample for ExperimentGrind 4 " <> $SessionUUID,
					"Test sample for ExperimentGrind 5 " <> $SessionUUID,
					"Test sample for ExperimentGrind 6 " <> $SessionUUID,
					"Test sample for ExperimentGrind 7 " <> $SessionUUID,
					"Test sample for ExperimentGrind 8 " <> $SessionUUID,
					"Test sample for ExperimentGrind 9 " <> $SessionUUID,
					"Test sample for ExperimentGrind 10 " <> $SessionUUID,
					"Test sample for ExperimentGrind 11 " <> $SessionUUID,
					"Test sample for ExperimentGrind 12 " <> $SessionUUID,
					"Test sample for ExperimentGrind 13 " <> $SessionUUID,
					"Test sample for ExperimentGrind 14 " <> $SessionUUID,
					"Test sample for ExperimentGrind 15 " <> $SessionUUID,
					"Test sample for ExperimentGrind 16 " <> $SessionUUID
				};


				(* create some samples in the above containers*)
				createdSamples = UploadSample[
					testSampleModels,
					testSampleLocations,
					InitialAmount -> testSampleAmounts,
					Name -> testSampleNames,
					FastTrack -> True
				];

				(* Reomve StorageCondition of sample 12 *)
				Upload[<|
					Object -> Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID],
					StorageCondition -> Null
				|>];
			]]
	),

	SymbolTearDown :> (
		Module[{allObjects},

			(* list of test objects*)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID],
				Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 15 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 16 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 17 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 18 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 19 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 20 " <> $SessionUUID],
				Object[Container, Vessel, "Test container for ExperimentGrind 21 " <> $SessionUUID],

				(* sample models *)
				Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
				Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
				Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],

				(* sample objects *)
				Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 6 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 7 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 8 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 9 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 10 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 13 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 15 " <> $SessionUUID],
				Object[Sample, "Test sample for ExperimentGrind 16 " <> $SessionUUID],

				(* Protocol Object *)
				Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];

			Unset[$CreatedObjects];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
(* ::Subsection::Closed:: *)
(*ExperimentGrindOptions*)

DefineTests[
	ExperimentGrindOptions,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a single sample:"},
			ExperimentGrindOptions[Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a single container:"},
			ExperimentGrindOptions[Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a sample and a container the same time:"},
			ExperimentGrindOptions[{
				Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
			}],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Generate a resolved list of options for an ExperimentGrind call to grind a single container:"},
			ExperimentGrindOptions[Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID], OutputFormat -> List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentGrind, #], $Failed, {Error::Pattern}],
				{(_Rule | _RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
				Object[Sample, "Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ExperimentGrindOptions" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ExperimentGrindOptions" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter],
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID,
						"Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID,
						"Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
			Object[Sample, "Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ExperimentGrindOptions" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];



(* ::Subsection::Closed:: *)
(*ExperimentGrindPreview*)


DefineTests[
	ExperimentGrindPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentGrind call to grind of a single container (will always be Null:"},
			ExperimentGrindPreview[Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentGrind call to grind of two containers at the same time:"},
			ExperimentGrindPreview[{
				Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentGrind call to grind of a single sample:"},
			ExperimentGrindPreview[Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
				Object[Sample, "Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ExperimentGrindPreview" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ExperimentGrindPreview" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter],
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID,
						"Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID,
						"Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
			Object[Sample, "Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ExperimentGrindPreview" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentGrindQ*)


DefineTests[
	ValidExperimentGrindQ,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Validate an ExperimentGrind call to Grind a single container:"},
			ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentGrind call to Grind two containers at the same time:"},
			ValidExperimentGrindQ[{
				Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "Validate an ExperimentGrind call to Grind a single sample:"},
			ValidExperimentGrindQ[Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID]],
			True
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Validate an ExperimentGrind call to Grind a single container, returning an ECL Test Summary:"},
			ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentGrind call to grind of a single container, printing a verbose summary of tests as they are run:"},
			ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
				Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ValidExperimentGrindQ" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID],
				Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ValidExperimentGrindQ" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter],
						PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 1 Gram / Milliliter]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID,
						"Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID,
						"Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
			Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ValidExperimentGrindQ" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID],
			Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];

(* ::Subsection::Closed:: *)
(*PreferredGrinder*)


DefineTests[PreferredGrinder,
	{
		(* --- Basic --- *)
		Example[
			{Basic, "Selects the preferred grinder for 1 g of a solid sample:"},
			PreferredGrinder[1 Gram],
			ObjectP[Model[Instrument, Grinder]]
		],

		(* --- PreferredGrinder Options --- *)
		Example[
			{Options, GrinderType, "Selects the preferred grinder for 10 g of a solid sample when GrinderType is KnifeMill:"},
			grinder = PreferredGrinder[10Gram, GrinderType -> KnifeMill];
			Download[grinder, GrinderType],
			KnifeMill,
			Variables :> {grinder}
		],
		Example[
			{Options, GrinderType, "Selects the preferred grinder for 50 g of a solid sample when GrinderType is MortarGrinder:"},
			grinder = PreferredGrinder[50Gram, GrinderType -> MortarGrinder];
			Download[grinder, GrinderType],
			MortarGrinder,
			Variables :> {grinder}
		],
		Example[
			{Options, GrinderType, "Selects the preferred grinder for 10 g of a solid sample when GrinderType is BallMill:"},
			grinder = PreferredGrinder[10Gram, GrinderType -> BallMill];
			Download[grinder, GrinderType],
			BallMill,
			Variables :> {grinder}
		],
		Example[
			{Options, Fineness, "Selects the preferred grinder for 10 g of a solid sample that has a fineness of 3 mm:"},
			grinder = PreferredGrinder[10Gram, Fineness -> 3Millimeter];
			Download[grinder, FeedFineness],
			3Millimeter,
			Variables :> {grinder},
			EquivalenceFunction :> GreaterEqual
		],
		Example[
			{Options, BulkDensity, "Selects the preferred grinder for 10 g of a solid sample that has a bulk density of of 0.5 g/mL:"},
			grinder = PreferredGrinder[10Gram, BulkDensity -> 0.5 Gram / Milliliter];
			Download[grinder, MaxAmount],
			20Milliliter,
			Variables :> {grinder},
			EquivalenceFunction :> GreaterEqual
		],

		(* ---  Messages --- *)
		Example[{Messages, "LargeParticles", "Throw a warning if the particle size is greater than 10 mm as 10 mm is currently the max feed fineness of the available grinders:"},
			PreferredGrinder[10Gram, Fineness -> 20Millimeter],
			ObjectP[Model[Instrument, Grinder]],
			Messages :> {
				Message[Error::LargeParticles]
			}
		],
		Example[{Messages, "InsufficientAmount", "Throw a warning if the amount of the sample is too small:"},
			PreferredGrinder[1Milligram],
			ObjectP[Model[Instrument, Grinder]],
			Messages :> {
				Message[Warning::InsufficientAmount]
			}
		],
		Example[{Messages, "ExcessiveAmount", "Throw a warning if the amount of the sample is too much:"},
			PreferredGrinder[300Gram],
			ObjectP[Model[Instrument, Grinder]],
			Messages :> {
				Message[Warning::ExcessiveAmount]
			}
		]
	}
];

(* ::Subsection::Closed:: *)
(* PreferredGrindingContainer *)


DefineTests[PreferredGrindingContainer,
	{
		(* --- Basic --- *)
		Example[
			{Basic, "Select the preferred grinding container using a grinder model as the input:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 0.8 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:pZx9joxq0ko9"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container using a grinder object as the input:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "BeadBug3"], 1 Gram, 0.8 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:pZx9joxq0ko9"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for Model[Instrument, Grinder, \"BeadGenie\"]:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "BeadGenie"], 0.5 Gram, 0.8 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:eGakld01zzpq"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for an object of Model[Instrument, Grinder, \"BeadGenie\"]:"},
			grinder = First[Model[Instrument, Grinder, "BeadGenie"][Objects]];
			PreferredGrindingContainer[grinder, 5 Gram, 1 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:xRO9n3vk11pw"]],
			Variables :> {grinder}
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for Model[Instrument, Grinder, \"BeadGenie\"] and higher amount:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "BeadGenie"], 15 Gram, 1 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for Model[Instrument, Grinder, \"Tube Mill Control\"]:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "Tube Mill Control"], 5 Gram, 0.8 Gram/Milliliter],
			ObjectP[Model[Container, GrindingContainer, "id:8qZ1VWZeG8mp"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for an object of Model[Instrument, Grinder, \"Automated Mortar Grinder\"]:"},
			grinder = First[Model[Instrument, Grinder, "Automated Mortar Grinder"][Objects]];
			PreferredGrindingContainer[grinder, 50 Gram, 1 Gram/Milliliter],
			ObjectP[Model[Container, GrindingContainer, "id:N80DNj09nGxk"]],
			Variables :> {grinder}
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for an object of Model[Instrument, Grinder, \"Mixer Mill MM400\"]:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "Mixer Mill MM400"], 0.5 Gram, 0.8 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for an object of Model[Instrument, Grinder, \"Mixer Mill MM400\"]:"},
			grinder = First[Model[Instrument, Grinder, "Mixer Mill MM400"][Objects]];
			PreferredGrindingContainer[grinder, 5 Gram, 1 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
			Variables :> {grinder}
		],

		Example[
			{Options, GrinderType, "Select the preferred grinding container for Model[Instrument, Grinder, \"Mixer Mill MM400\"] and higher amount:"},
			PreferredGrindingContainer[Model[Instrument, Grinder, "Mixer Mill MM400"], 15 Gram, 1 Gram/Milliliter],
			ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
		]
	}
];
