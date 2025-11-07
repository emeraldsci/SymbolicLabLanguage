(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentIncubateCells : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentIncubateCells*)


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCells*)


DefineTests[
	ExperimentIncubateCells,
	{
		(*-- BASIC TESTS --*)
		Example[{Basic, "Incubate a single bacterial sample in a flask:"},
			ExperimentIncubateCells[Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]],
			ObjectP[Object[Protocol, IncubateCells]]
		],
		Example[{Basic, "Incubate a single mammalian sample in a plate at 37 Celsius:"},
			ExperimentIncubateCells[Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID], Temperature -> 37 Celsius],
			ObjectP[Object[Protocol, IncubateCells]]
		],
		Example[{Basic, "Incubate a single mammalian sample in a plate on a liquid handler:"},
			ExperimentIncubateCells[Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID], Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Example[{Basic, "Incubate multiple samples:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Incubate a single model severed sample:"},
			ExperimentIncubateCells[Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]],
			ObjectP[Object[Protocol]]
		],
		Example[{Additional, "If specifying custom conditions for one sample when incubating multiple samples in a container, then propagate those conditions to the other samples in the same container:"},
			options = ExperimentIncubateCells[
				{
					Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Temperature -> {30 Celsius, Automatic},
				Output -> Options,
				OptionsResolverOnly -> True
			];
			Lookup[options, Temperature],
			{30 Celsius, 30 Celsius},
			Variables :> {options}
		],
		Test["If protocol does not have a parent protocol and we're in a Manual protocol, populate Overclock -> True in the protocol object:",
			Download[
				ExperimentIncubateCells[Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]],
				Overclock
			],
			True
		],
		Test["If protocol does have a parent protocol and we're in a Manual protocol, populate Overclock -> True in the root protocol object:",
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				ParentProtocol -> Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID]
			];
			Download[Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID], Overclock],
			True
		],
		Test["If the protocol does not have a parent protocol and we're in a Robotic protocol, RoboticCellPreparation populates Overclock -> True in the protocol object:",
			Download[
				ExperimentIncubateCells[Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID], Preparation -> Robotic],
				Overclock
			],
			True
		],
		Test["If the protocol does have a parent protocol and we're in a Robotic protocol, RoboticCellPreparation populates Overclock -> True in the root protocol object:",
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic,
				ParentProtocol -> Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID]
			];
			Download[Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID], Overclock],
			True
		],
		Test["Properly batch custom and default incubation conditions together:",
			protocol = ExperimentIncubateCells[
				{
					Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Temperature -> {30 Celsius, 30 Celsius, Automatic, Automatic}
			];
			{
				protocol,
				Download[protocol, BatchedUnitOperations[{Object, SampleLink, Temperature, IncubationConditionExpression}]]
			},
			{
				ObjectP[Object[Protocol, IncubateCells]],
				{
					{
						ObjectP[Object[UnitOperation, IncubateCells]],
						{ObjectP[Object[Container, Plate, "Test plate with stowaways (for ExperimentIncubateCells)" <> $SessionUUID]]},
						{EqualP[30 Celsius]},
						{Custom}
					}
				}
			},
			Variables :> {protocol}
		],
		Test["Make sure RequiredResources gets populated properly for both the protocol and BatchedUnitOperations:",
			protocol = ExperimentIncubateCells[
				{
					Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Temperature -> {30 Celsius, 30 Celsius, Automatic, Automatic, Automatic},
				SamplesOutStorageCondition -> {Automatic, Automatic, Automatic, Automatic, Refrigerator}
			];
			protRequiredResources = Download[protocol, RequiredResources];
			unitOpRequiredResources = Join @@ Download[protocol, BatchedUnitOperations[RequiredResources]];

			unitOpSampleResources = Cases[unitOpRequiredResources, {resource_, SampleLink, _, _} :> Download[resource, Object]];

			containersInResources = Cases[protRequiredResources, {resource_, ContainersIn, _, _} :> Download[resource, Object]];
			defaultIncubationContainerResources = Cases[protRequiredResources, {resource_, DefaultIncubationContainers, _, _} :> Download[resource, Object]];
			nonIncubationStorageContainers = Cases[protRequiredResources, {resource_, NonIncubationStorageContainers, _, _} :> Download[resource, Object]];
			{
				(* make sure the sample resources in the BatchedUnitOperations are also in the protocol object *)
				MemberQ[containersInResources, #]& /@ unitOpSampleResources,
				(* make sure the DefaultIncubationContainers are also ContainersIn resources *)
				MemberQ[containersInResources, #]& /@ defaultIncubationContainerResources,
				(* make sure the PostDefaultIncubationContainers are also ContainersIn resources *)
				MemberQ[containersInResources, #]& /@ nonIncubationStorageContainers
			},
			{
				{True..},
				{True..},
				{True..}
			},
			Variables :> {
				protocol, protRequiredResources, unitOpRequiredResources, unitOpSampleResources,
				containersInResources, defaultIncubationContainerResources, nonIncubationStorageContainers
			}
		],
		Test["If putting samples into storage conditions that are different from their incubation conditions (but still incubators), populate PostDefaultIncubationContainers:",
			protocol = ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> SolidMedia,
				SamplesOutStorageCondition -> BacterialShakingIncubation
			];
			{
				protocol,
				Download[
					protocol,
					{DefaultIncubationContainers, PostDefaultIncubationContainers}
				]
			},
			{
				ObjectP[Object[Protocol, IncubateCells]],
				{
					{ObjectP[Download[Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Container]]},
					{ObjectP[Download[Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Container]]}
				}
			},
			Variables :> {protocol}
		],
		Test["If samples are not going to end up in an Incubator after the experiment, populate NonIncubationStorageContainers and NonIncubationStorageContainerConditions:",
			protocol = ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				SamplesOutStorageCondition -> Refrigerator
			];
			{
				protocol,
				Download[
					protocol,
					{NonIncubationStorageContainers,NonIncubationStorageContainerConditions}
				]
			},
			{
				ObjectP[Object[Protocol, IncubateCells]],
				{
					{ObjectP[Download[Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Container]]},
					{Refrigerator}
				}
			}
		],
		Test["Samples in flasks are allowed to be stored in Refridgerator after the experiment. NonIncubationStorageContainers and NonIncubationStorageContainerConditions are populated:",
			protocol = ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				SamplesOutStorageCondition -> Refrigerator
			];
			{
				protocol,
				Download[
					protocol,
					{NonIncubationStorageContainers,NonIncubationStorageContainerConditions}
				]
			},
			{
				ObjectP[Object[Protocol, IncubateCells]],
				{
					{ObjectP[Download[Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID], Container]]},
					{Refrigerator}
				}
			}
		],
		Test["If performing a robotic incubation on an uncovered container, cover the container before it goes into the incubator:",
			protocol = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations],
			{
				ObjectP[Object[UnitOperation, Cover]],
				ObjectP[Object[UnitOperation, IncubateCells]]
			},
			Variables :> {protocol}
		],
		Test["If performing a robotic incubation on a covered container, don't need to cover it before the IncubateCells call:",
			protocol = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations],
			{
				ObjectP[Object[UnitOperation, IncubateCells]]
			},
			Variables :> {protocol}
		],
		Example[{Additional, "Incubate a specific cell on a plate:"},
			ExperimentIncubateCells[{"A1", Object[Container, Plate, "Test mammalian plate 1 (for ExperimentIncubateCells)" <> $SessionUUID]}],
			ObjectP[Object[Protocol]]
		],
		Example[{Additional, "Incubate a mixture of different kinds of inputs:"},
			ExperimentIncubateCells[
				{Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],{"A1", Object[Container, Plate, "Test mammalian plate 1 (for ExperimentIncubateCells)" <> $SessionUUID]}},
				Temperature -> 37 Celsius
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Additional, "Incubate a single bacterial sample in a flask with custom conditions:"},
			ExperimentIncubateCells[Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Temperature -> 50 Celsius,
				CarbonDioxide -> 7 Percent,
				RelativeHumidity -> 85 Percent
			],
			ObjectP[Object[Protocol]]
		],

		(*-- INVALID INPUT TESTS --*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentIncubateCells[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentIncubateCells[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentIncubateCells[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentIncubateCells[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, coverPackets, coverID, sampleID, samplePackets, simulationToPassIn, coverUpdatePacket},
				containerPackets = UploadSample[
					Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				coverPackets = UploadSample[
					Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverPackets]];
				coverID = Lookup[First[coverPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				coverUpdatePacket = UploadCover[containerID, Cover -> coverID, Simulation -> simulationToPassIn, Upload -> False];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverUpdatePacket]];

				ExperimentIncubateCells[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, coverPackets, coverID, sampleID, samplePackets, simulationToPassIn, coverUpdatePacket},
				containerPackets = UploadSample[
					Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				coverPackets = UploadSample[
					Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverPackets]];
				coverID = Lookup[First[coverPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				coverUpdatePacket = UploadCover[containerID, Cover -> coverID, Simulation -> simulationToPassIn, Upload -> False];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[coverUpdatePacket]];

				ExperimentIncubateCells[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "DiscardedSample", "If the given samples are discarded, they cannot be incubated:"},
			ExperimentIncubateCells[Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSample,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModel", "If the given samples have deprecated models, they cannot be incubated:"},
			ExperimentIncubateCells[Object[Sample, "Test deprecated sample (for ExperimentIncubateCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModel,
				Error::InvalidInput
			}
		],
		Example[{Messages, "GaseousSamples", "If the given samples are gaseous, they cannot be incubated:"},
			ExperimentIncubateCells[Object[Sample, "Test gas sample in plate (for ExperimentIncubateCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::GaseousSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidCellIncubationContainers", "If a sample is provided in a container incompatible with all incubators, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)"<> $SessionUUID],
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator -> ObjectP[Model[Instrument, Incubator]]]},
			Messages :> {
				Error::InvalidCellIncubationContainers,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidCellIncubationContainers", "If a sample is provided in a container incompatible with all incubators, throws an error and returns $Failed:"},
			(* Multiple samples, some triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in incompatible container 2 (for ExperimentIncubateCells)"<> $SessionUUID],
					Object[Sample, "Test bacterial sample in incompatible container 3 (for ExperimentIncubateCells)"<> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator ->  {ObjectP[Model[Instrument, Incubator]]..}]},
			Messages :> {
				Error::InvalidCellIncubationContainers,
				Error::InvalidInput
			}
		],
		Example[{Messages, "IncubatorIsIncompatible", "If a sample's container is incompatible with the incubator model specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "id:AEqRl954Gpjw"] (*Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"]*)
			],
			$Failed,
			Messages :> {
				Error::IncubatorIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubatorIsIncompatible", "If CellType is Mammalian, a Bacterial incubator cannot be specified:"},
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				Incubator -> Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"]
			],
			$Failed,
			Messages :> {
				Error::IncubatorIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubatorIsIncompatible", "If the samples' container, celltype, and/or culture adhesion is not supported by the incubator model specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				(* Multiple samples some triggered *)
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> Model[Instrument, Incubator, "id:AEqRl954Gpjw"] (*Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"]*)
			],
			$Failed,
			Messages :> {
				Error::IncubatorIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubatorWithSettings", "If the incubation setting options are not supported by the specified incubator, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "id:D8KAEvdqzXok"], (*"Innova 44 for Bacterial Flasks"*)
				CarbonDioxide -> Ambient,
				Temperature -> 35 Celsius
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubatorWithSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubatorWithSettings", "If the incubation setting options are not supported by the specified incubators, throws an error and returns $Failed:"},
			(* Multiple samples all triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					(*"Bactomat HERAcell 240i TT 10 for Bacteria"*)
					Model[Instrument, Incubator, "id:xRO9n3vk1JbO"],
					(*"Cytomat HERAcell 240i TT 10"*)
					Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"],
					(*"Innova 44 for Bacterial Flasks"*)
					Model[Instrument, Incubator, "id:D8KAEvdqzXok"],
					(*"Innova 44 for Bacterial Plates"*)
					Model[Instrument, Incubator, "id:AEqRl954Gpjw"]
				},
				ShakingRate -> {200 RPM, Automatic, Automatic, 250 RPM},
				CarbonDioxide -> Ambient,
				Temperature -> {Automatic, Automatic, 35 Celsius, Automatic}
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubatorWithSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoIncubatorForSettings", "If no incubator can be found to support both the sample (container, cell type, culture adhesion) and the specified incubation settings, throws an error to recommend either changing options or alternatively transferring the samples (if applicable) and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Temperature -> 35 Celsius,
				ShakingRate -> 200 RPM,
				ShakingRadius -> 25.4 Millimeter,
				RelativeHumidity -> Ambient,
				CarbonDioxide -> Automatic
			],
			$Failed,
			Messages :> {
				Error::NoIncubatorForSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoIncubatorForSettings", "If no incubator can be found to support both the sample (container, cell type, culture adhesion) and the specified incubation settings, throws an error to recommend either changing options or alternatively transferring the samples (if applicable) and returns $Failed:"},
			(* Multiple samples all triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Temperature -> {35 Celsius, Automatic, 31 Celsius, 37 Celsius, 30 Celsius},
				ShakingRate -> 200 RPM,
				ShakingRadius -> 25.4 Millimeter,
				RelativeHumidity -> {Ambient, Ambient, Ambient, 10 Percent, Automatic},
				CarbonDioxide -> {Automatic, 10 Percent, Automatic, Automatic, Ambient}],
			$Failed,
			Messages :> {
				Error::InvalidPlateSamples,
				Error::NoIncubatorForSettings,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoIncubatorForContainersAndSettings", "If no incubator can be found to support either the sample (container, cell type, culture adhesion) or the specified incubation settings, throws an error to recommend both transferring the samples and changing options, and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRate -> 200 RPM,
				ShakingRadius -> 25.4 Millimeter,
				RelativeHumidity -> 10 Percent
			],
			$Failed,
			Messages :> {
				Error::NoIncubatorForContainersAndSettings,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NoIncubatorForContainersAndSettings", "If no incubator can be found to support either the sample (container, cell type, culture adhesion) or the specified incubation settings for multiple samples, throws an error to recommend both transferring the samples and changing options, and returns $Failed:"},
			(* Multiple samples all triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID], 
					Object[Sample, "Test bacterial sample in incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				ShakingRate -> 200 RPM,
				ShakingRadius -> 25.4 Millimeter,
				RelativeHumidity -> 10 Percent
			],
			$Failed,
			Messages :> {
				Error::NoIncubatorForContainersAndSettings,
				Error::InvalidInput
			}
		],
		Example[{Messages, "IncubationConditionIsIncompatible", "If the sample container is not supported by the incubation condition specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> BacterialIncubation
			],
			$Failed,
			Messages :> {
				Error::IncubationConditionIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubationConditionIsIncompatible", "If the sample cell type is not supported by the incubation condition specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> Model[StorageCondition, "Mammalian Incubation"]
			],
			$Failed,
			Messages :> {
				Error::IncubationConditionIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubationConditionIsIncompatible", "If the specified cell type is not supported by the incubation condition specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				CultureAdhesion -> Adherent,
				IncubationCondition -> BacterialIncubation
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellType,
				Error::ConflictingCultureAdhesion,
				Error::IncubationConditionIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubationConditionIsIncompatible", "If multiple samples have the container and/or cell type not supported by the incubation conditions specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				IncubationCondition -> {
					Model[StorageCondition, "Bacterial Incubation"],
					Model[StorageCondition, "Bacterial Incubation"],
					Model[StorageCondition, "Mammalian Incubation"]
				}
			],
			$Failed,
			Messages :> {
				Error::IncubationConditionIsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubationConditionWithSettings", "If the incubation setting options are not supported by the specified incubation condition, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> Model[StorageCondition, "Bacterial Incubation with Shaking"],
				Shake -> False
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationConditionWithSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubationConditionWithSettings", "If the incubation setting options are not supported by the specified incubators, throws an error and returns $Failed:"},
			(* Multiple samples all triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				IncubationCondition -> {
					BacterialIncubation,
					MammalianIncubation,
					Model[StorageCondition, "Bacterial Incubation with Shaking"],
					Model[StorageCondition, "Bacterial Incubation with Shaking"]
				},
				ShakingRate -> {200 RPM, Automatic, Automatic, 250 RPM},
				CarbonDioxide -> Ambient,
				Temperature -> {Automatic, Automatic, 35 Celsius, Automatic}
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationConditionWithSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubatorIncubationCondition", "If the specified IncubationCondiction is conflicting with the specified incubator, throw an error and return $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "Innova 44 for Bacterial Flasks"],
				IncubationCondition -> BacterialIncubation
			],
			$Failed,
			Messages :> {
				Error::IncubationConditionIsIncompatible,
				Error::ConflictingIncubatorIncubationCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsealedCellCultureVessels", "If a manual incubation is specified with an open container, a warning is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test sample in an open flask (for ExperimentIncubateCells)" <> $SessionUUID], Preparation -> Manual
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::UnsealedCellCultureVessels
			}
		],
		Example[{Messages, "UnsupportedCellTypes", "If an unsupported cell type is provided (not Bacterial, Mammalian, or Yeast), an error is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test insect cell (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedCellTypes,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidPlateSamples", "If a sample is provided that contains other unspecified samples in its own container, an error is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::InvalidPlateSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If incubator specified is a mix of robotic incubator and manual incubator, throw an error:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					Model[Instrument, Incubator, "Innova 44 for Bacterial Flasks"],
					Model[Instrument, Incubator, "STX44-ICBT with Shaking"]
				}
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic but CultureAdhesion is SolidMedia, throw an error:"},
			ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> SolidMedia,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic but IncubationCondition is specified as non-Custom, throw an error:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> BacterialShakingIncubation,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If the QuantificationMethod is ColonyCount while the preparation is Robotic, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				IncubationStrategy -> QuantificationTarget,
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If the QuantificationInstrument is a colony handler while the preparation is Robotic, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				IncubationStrategy -> QuantificationTarget,
				QuantificationInstrument -> Model[Instrument, ColonyHandler, "QPix 420 HT"],
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::ConflictingWorkCellWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If the CultureAdhesion is detected or specified to be SolidMedia, the preparation is not allowed to be Robotic:"},
			ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingIncubationWorkCells", "If WorkCell is specified, it must not disagree with the sample type or the specified incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"],
				Preparation -> Robotic,
				(* sample requires microbioSTAR because it's Bacterial *)
				WorkCell -> bioSTAR
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationWorkCells,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyCustomIncubationConditions", "Can only use one custom incubator per protocol:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					Model[Instrument, Incubator, "Multitron Pro with 3mm Orbit"],
					Model[Instrument, Incubator, "Multitron Pro with 25mm Orbit"]
				}
			],
			$Failed,
			Messages :> {
				Error::TooManyCustomIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyCustomIncubationConditions", "If one sample can only be done on the bioSTAR and another on the microbioSTAR, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					Model[Instrument, Incubator, "STX44-ICBT with Humidity Control"],
					Model[Instrument, Incubator, "STX44-ICBT with Shaking"]
				}
			],
			$Failed,
			Messages :> {
				Error::TooManyCustomIncubationConditions,
				Error::ConflictingIncubationWorkCells,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWorkCellWithPreparation", "If Preparation is set to Manual, WorkCell must not be set. If Preparation is set to Robotic, it must be set to the correct work cell, otherwise an error will be thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"],
				Preparation -> Robotic,
				WorkCell -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingWorkCellWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWorkCellWithPreparation", "If Preparation is set to Manual, WorkCell must not be set. If Preparation is set to Robotic, it must be set to the correct work cell, otherwise an error will be thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Manual,
				WorkCell -> microbioSTAR
			],
			$Failed,
			Messages :> {
				Error::ConflictingWorkCellWithPreparation,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If Preparation is set to Robotic, then Time must not be greater than 3 hours:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"],
				Preparation -> Robotic,
				Time -> 4 Hour
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CellTypeNotSpecified", "If a sample is provided with no CellType, throws a warning and creates a protocol:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> Suspension,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			Messages :> {
				Warning::CellTypeNotSpecified
			}
		],
		Example[{Messages, "CultureAdhesionNotSpecified", "If a sample is provided with no CultureAdhesion, throws a warning and creates a protocol:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			Messages :> {
				Warning::CultureAdhesionNotSpecified
			}
		],
		Example[{Messages, "CustomIncubationConditionNotSpecified", "If a sample has IncubationCondition set to Custom, a warning will be thrown for all options not specified:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> Custom,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			Messages :> {
				Warning::CustomIncubationConditionNotSpecified
			}
		],
		Example[{Messages, "InvalidIncubationConditions", "If storage condition object is specified, an error is thrown if it is not a supported cellular incubation storage condition:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				IncubationCondition -> Model[StorageCondition, "Ambient Storage"]
			],
			$Failed,
			Messages :> {
				Error::InvalidIncubationConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellType", "If CellType option is specified as Mammalian but the CellType of the sample(s) specified as microbial, throws an error:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellType,
				Error::UnsupportedCellCultureType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellType", "If CellType options are provided, and they conflict with the CellType of the sample(s) specified, throws a warning if both types are microbial:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Yeast
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellType
			}
		],
		Example[{Messages, "ConflictingCultureAdhesion", "If CultureAdhesion options are provided, and they conflict with the CultureAdhesion of the sample(s) specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> SolidMedia
			],
			$Failed,
			Messages :> {
				Error::ConflictingCultureAdhesion,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCultureAdhesion", "If a sample's state is Liquid but CultureAdhesion is specified as SolidMedia, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				CultureAdhesion -> SolidMedia
			],
			$Failed,
			Messages :> {
				Error::ConflictingCultureAdhesion,
				Error::InvalidOption
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], State -> Null|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], State -> Solid|>])
		],
		Example[{Messages, "ConflictingShakingConditions", "If shaking options are provided, but Shake is set to False, throws an error, returns $Failed, and only uses the provided shaking option values to resolve incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Shake -> False,
				ShakingRate -> 200 RPM,
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator-> ObjectP[Model[Instrument, Incubator, "id:D8KAEvdqzXok"]]]},(*"Innova 44 for Bacterial Flasks"*)
			Messages :> {
				Error::ConflictingShakingConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingShakingConditions", "If shaking options are specified to be Null but Shake is set to True, throws an error, returns $Failed, and only uses Shake->True to resolve incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Shake -> True,
				ShakingRate -> Null,
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator-> ObjectP[Model[Instrument, Incubator, "id:D8KAEvdqzXok"]]]},(*"Innova 44 for Bacterial Flasks"*)
			Messages :> {
				Error::ConflictingShakingConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingShakingConditions", "If the two shaking options are specified to be conflicting with each other, throws an error, returns $Failed, and only uses non-null values to resolve incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRate -> Null,
				ShakingRadius -> 25 Millimeter,
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator -> ObjectP[Model[Instrument, Incubator, "id:AEqRl954GG0l"]]]}, (*"Multitron Pro with 25mm Orbit"*)
			Messages :> {
				Error::ConflictingShakingConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingShakingConditions", "If using a mammalian sample, and any shaking options are specified to be conflicting, throws an error, returns $Failed, and only uses null values or Shake -> False to resolve incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRate -> Null,
				ShakingRadius -> 25 Millimeter,
				IncubationCondition -> MammalianIncubation,
				Output -> {Result, Options}
			],
			{$Failed, KeyValuePattern[Incubator -> ObjectP[Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"]]]}, (*"Cytomat HERAcell 240i TT 10"*)
			Messages :> {
				Error::ConflictingShakingConditions,
				Error::ConflictingIncubationConditionWithSettings,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellTypeWithCultureAdhesion", "If using a mammalian sample, CultureAdhesion cannot be SolidMedia:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				CultureAdhesion -> SolidMedia
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellTypeWithCultureAdhesion,
				Error::ConflictingCultureAdhesion,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellTypeWithCultureAdhesion", "If using a bacterial or yeast sample, CultureAdhesion cannot be Adherent:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				CultureAdhesion -> Adherent
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellTypeWithCultureAdhesion,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnsupportedCellCultureType", "If using a mammalian sample, suspension cell culture cannot be currently supported:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				CultureAdhesion -> Suspension
			],
			$Failed,
			Messages :> {
				Error::UnsupportedCellCultureType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCultureAdhesionWithContainer", "If samples are in a flask, CultureAdhesion can't be SolidMedia:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				CultureAdhesion -> Adherent
			],
			$Failed,
			Messages :> {
				Error::ConflictingCultureAdhesionWithContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCultureAdhesionWithContainer", "A discarded Adherent sample that no longer has a container does not further trigger ConflictingCultureAdhesionWithContainer, or complain about container footprint if thats is the only conflict with the specified Incubator/IncubationCondition, throws DiscardedSample error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				CultureAdhesion -> Adherent,
				Incubator -> Model[Instrument, Incubator, "id:Z1lqpMGjeKN9"],(*"Cytomat HERAcell 240i TT 10"*)
				IncubationCondition -> MammalianIncubation
			],
			$Failed,
			Messages :> {
				Error::DiscardedSample,
				Error::ConflictingCellType,
				Error::ConflictingCultureAdhesion,
				Error::InvalidOption,
				Error::InvalidInput
			},
			SetUp :> (
				UploadLocation[Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID], Waste, FastTrack -> True]
			),
			TearDown :> (
				UploadLocation[
					Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
					{"A1", Object[Container, Vessel, "Test Erlenmeyer flask 1 (for ExperimentIncubateCells)" <> $SessionUUID]},
					FastTrack -> True
				]
			)
		],
		Example[{Messages, "ConflictingCellTypeWithStorageCondition", "If samples are Mammalian, can't specify a Bacterial or Yeast SamplesOutStorageCondition (and vice versa):"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				SamplesOutStorageCondition -> MammalianIncubation
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellTypeWithStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ShakingRecommendedForStorageCondition", "If samples are Suspension, throw a warning if SamplesOutStorageCondition is an incubation condition without shaking:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				(* wants to be BacterialShakingIncubation *)
				SamplesOutStorageCondition -> BacterialIncubation
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ShakingRecommendedForStorageCondition
			}
		],
		Example[{Messages, "ShakingRecommendedForStorageCondition", "Note that solid media in refrigerator is allowed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> SolidMedia,
				SamplesOutStorageCondition -> Refrigerator,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule}
		],
		Example[{Messages, "ConflictingIncubationConditionsForSameContainer", "If two samples are in the same container, they cannot have different incubation conditions:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Temperature -> {30 Celsius, 37 Celsius}
			],
			$Failed,
			Messages :> {
				Error::ConflictingIncubationConditionsForSameContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncubationMaxTemperature", "If a sample is provided in a container incompatible with the temperature requested, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Temperature -> 70 Celsius
			],
			$Failed,
			Messages :> {
				Error::IncubationMaxTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicatedSamples", "A sample cannot be specified more than one time in a given experiment call:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "EmptySamples", "If a sample is liquid but Volume is not populated, throws a warning:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::EmptySamples
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> Null|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 100 Milliliter|>])
		],
		Example[{Messages, "EmptySamples", "If a sample is liquid but Volume is less than 1% of MaxVolume of container, throws a warning:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::EmptySamples
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 1 Milliliter|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 100 Milliliter|>])
		],
		Example[{Messages, "EmptySamples", "If a sample is solid but Mass is not populated, throws a warning:"},
			ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::EmptySamples
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Mass -> Null|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Mass -> 2 Gram|>])
		],
		Example[{Messages, "EmptySamples", "If a sample is solid but Mass is less than 1% of MaxVolume of container, throws a warning:"},
			ExperimentIncubateCells[
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::EmptySamples
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Mass -> 0.2 Gram|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID], Mass -> 2 Gram|>])
		],
		Example[{Messages, "TooManyIncubationSamples", "If more samples are specified than can fit in an incubator, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test sample in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"]
			],
			$Failed,
			Messages :> {
				Error::TooManyIncubationSamples,
				Error::InvalidInput
			}
		],
		(* Soft warning tests for Yeast vs Bacterial conflicts *)
		Example[{Messages, "ConflictingCellTypeWithIncubationCondition", "If CellType for samples and SamplesOutStorageCondition are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				IncubationCondition -> YeastShakingIncubation
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithIncubationCondition
			}
		],
		Example[{Messages, "ConflictingCellTypeWithStorageCondition", "If CellType for samples and SamplesOutStorageCondition are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			(* One of multiple samples triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				CellType -> Bacterial,
				SamplesOutStorageCondition -> {YeastShakingIncubation, BacterialShakingIncubation}
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithStorageCondition
			}
		],
		Example[{Messages, "ConflictingCellTypeWithIncubator", "If CellType for samples and Incubator are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			(* All of multiple samples triggered*)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					Model[Instrument, Incubator, "Innova 44 for Yeast Flasks"],
					Model[Instrument, Incubator, "Innova 44 for Yeast Plates"]
				}
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithIncubator
			}
		],
		(* Options tests *)
		Example[{Options, Preparation, "If the time exceeds $MaxRoboticIncubationTime, the Preparation option defaults to Manual:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Time -> 4 Hour,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, WorkCell, "STAR is not allowed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				WorkCell -> STAR
			],
			$Failed,
			Messages :> {Error::Pattern}
		],
		Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Incubate and IncubationCondition is Custom for any sample, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				FailureResponse -> Incubate,
				IncubationCondition -> Custom,
				Incubator -> Model[Instrument, Incubator, "Multitron Pro with 25mm Orbit"],
				CellType -> Bacterial,
				CultureAdhesion -> Suspension,
				Temperature -> 37 Celsius,
				CarbonDioxide -> Ambient,
				RelativeHumidity -> Ambient,
				Shake -> True,
				ShakingRadius -> 25 Millimeter,
				ShakingRate -> 250 RPM,
				QuantificationAliquot -> True,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
			],
			$Failed,
			Messages :> {
				Error::FailureResponseNotSupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Freeze and any samples have a CultureAdhesion other than Suspension, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				FailureResponse -> Freeze,
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony
			],
			$Failed,
			Messages :> {
				Error::FailureResponseNotSupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Freeze and the total volume to be frozen exceeds the capacity of a single instance of Model[Container, Rack, InsulatedCooler, \"5mL Mr. Frosty Rack\"], an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				FailureResponse -> Freeze,
				QuantificationMethod -> Absorbance,
				QuantificationAliquot -> True,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
			],
			$Failed,
			Messages :> {
				Error::FailureResponseNotSupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationOptions", "If QuantificationTolerance is Null while MinQuantificationTarget is specified, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationTolerance -> Null,
				FailureResponse -> Discard,
				QuantificationAliquot -> True,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationOptions", "If MinQuantificationTarget is Null while QuantificationTolerance is specified, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationTolerance -> 10 Percent,
				QuantificationAliquot -> True,
				MinQuantificationTarget -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationOptions", "If MinQuantificationTarget is None while QuantificationTolerance is specified, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationTolerance -> 10 Percent,
				QuantificationAliquot -> True,
				MinQuantificationTarget -> None
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is Nephelometry and the QuantificationInstrument is not a Nephelometer, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Time -> 3 Hour,
				QuantificationMethod -> Nephelometry,
				QuantificationInstrument -> Model[Instrument, ColonyHandler, "QPix 420 HT"],
				MinQuantificationTarget -> (1000000 Cell)/Milliliter,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationMethodAndInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is ColonyCount and the QuantificationInstrument is not a ColonyHandler, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Time -> 3 Hour,
				QuantificationMethod -> ColonyCount,
				QuantificationInstrument -> Model[Instrument, Nephelometer, "NEPHELOstar Plus"],
				MinQuantificationTarget -> (1000000 Cell)/Milliliter,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationMethodAndInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is Absorbance and the QuantificationInstrument is not a Spectrophotometer or PlateReader, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Time -> 3 Hour,
				QuantificationMethod -> Absorbance,
				QuantificationInstrument -> Model[Instrument, Nephelometer, "NEPHELOstar Plus"],
				MinQuantificationTarget -> (1000000 Cell)/Milliliter,
				QuantificationAliquot -> True,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ConflictingQuantificationMethodAndInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExcessiveQuantificationAliquotVolumeRequired", "If the quantification schedule and aliquoting parameters would result in depletion of the input sample if the maximum number of quantifications was to occur, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationAliquot -> True,
				QuantificationAliquotVolume -> 150 Microliter,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
				QuantificationInterval -> 1 Hour,
				Time -> 36 Hour,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ExcessiveQuantificationAliquotVolumeRequired,
				Error::InvalidOption
			},
			SetUp :> (Upload[<|Object -> Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 5 Milliliter|>]),
			TearDown :> (Upload[<|Object -> Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 30 Milliliter|>])
		],
		Example[{Messages, "QuantificationTargetUnitsMismatch", "If MinQuantificationTarget and QuantificationTolerance are quantities with different units and QuantificationTolerance is not a Percent, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationAliquot -> True,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
				FailureResponse -> Discard,
				QuantificationTolerance -> 25 OD600
			],
			$Failed,
			Messages :> {
				Error::QuantificationTargetUnitsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If any aliquoting options are specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationAliquot -> True,
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ExtraneousQuantifyColoniesOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationWavelength is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationWavelength -> 600 Nanometer,
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ExtraneousQuantifyColoniesOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationStandardCurve is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationStandardCurve -> Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ExtraneousQuantifyColoniesOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationBlank is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				QuantificationBlank -> Model[Sample, "Milli-Q water"],
				QuantificationMethod -> ColonyCount,
				MinQuantificationTarget -> 500 Colony,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::ExtraneousQuantifyColoniesOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AliquotRecoupMismatch", "If QuantificationRecoupSample iss set to True while QuantificationAliquot is False, an error is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				QuantificationRecoupSample -> True,
				MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
				QuantificationAliquot -> False,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::AliquotRecoupMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MixedQuantificationAliquotRequirements", "If QuantificationAliquot is Automatic and the conditions of the experiment necessitate aliquoting for quantification of a subset (but not all) of the samples, an error is thrown:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID], (* in a UV-star plate - BMG compatible *)
					Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]  (* in a standard 96 DWP - not BMG compatible *)
				},
				MinQuantificationTarget -> 0.5 OD600,
				QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				QuantificationAliquot -> Automatic,
				FailureResponse -> Discard
			],
			$Failed,
			Messages :> {
				Error::MixedQuantificationAliquotRequirements,
				Warning::GeneralFailureResponse,
				Error::InvalidOption
			}
		],
		(* Soft warning tests for Yeast vs Bacterial conflicts *)
		Example[{Messages, "ConflictingCellTypeWithIncubationCondition", "If CellType for samples and SamplesOutStorageCondition are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				IncubationCondition -> YeastShakingIncubation
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithIncubationCondition
			}
		],
		Example[{Messages, "ConflictingCellTypeWithStorageCondition", "If CellType for samples and SamplesOutStorageCondition are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			(* One of multiple samples triggered *)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				CellType -> Bacterial,
				SamplesOutStorageCondition -> {YeastShakingIncubation, BacterialShakingIncubation}
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithStorageCondition
			}
		],
		Example[{Messages, "ConflictingCellTypeWithIncubator", "If CellType for samples and Incubator are both microbial but one is Bacterial and the other is Yeast, throw a soft warning and allows for protocol generation:"},
			(* All of multiple samples triggered*)
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID]
				},
				Incubator -> {
					Model[Instrument, Incubator, "Innova 44 for Yeast Flasks"],
					Model[Instrument, Incubator, "Innova 44 for Yeast Plates"]
				}
			],
			ObjectP[Object[Protocol, IncubateCells]],
			Messages :> {
				Warning::ConflictingCellTypeWithIncubator
			}
		],
		(* Options tests *)
		Example[{Options, Preparation, "If the time exceeds $MaxRoboticIncubationTime, the Preparation option defaults to Manual:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Time -> 4 Hour,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, WorkCell, "STAR is not allowed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				WorkCell -> STAR
			],
			$Failed,
			Messages :> {Error::Pattern}
		],
		Example[{Options, WorkCell, "WorkCell is resolved to bioSTAR if Prepartion->Robotic and sample contains mammalian cells:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, WorkCell],
			bioSTAR,
			Variables :> {options}
		],
		Example[{Options, WorkCell, "WorkCell is resolved to microbioSTAR if Prepartion->Robotic and sample contains bacterial cells:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Preparation -> Robotic,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, WorkCell],
			microbioSTAR,
			Variables :> {options}
		],
		Example[{Options, Time, "Incubate a single mammalian sample in a plate with a given Time:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Time -> 1 Hour,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Time],
			EqualP[1 Hour],
			Variables :> {options}
		],
		Example[{Options, Temperature, "Incubate a single mammalian sample in a plate with a given Temperature:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Temperature -> 37 Celsius,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Temperature],
			EqualP[37 Celsius],
			Variables :> {options}
		],
		Example[{Options, Incubator, "Incubate a single mammalian sample in a plate with a given Instrument:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "Cytomat HERAcell 240i TT 10"],
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Incubator],
			ObjectP[Model[Instrument, Incubator, "Cytomat HERAcell 240i TT 10"]],
			Variables :> {options}
		],
		Example[{Options, CellType, "Incubate a single bacterial sample in a plate with a specified CellType:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, CellType],
			Bacterial,
			Variables :> {options}
		],
		Example[{Options, CultureAdhesion, "Incubate a single bacterial sample in a plate with a specified CultureAdhesion:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> Suspension,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, CultureAdhesion],
			Suspension,
			Variables :> {options}
		],
		Example[{Options, IncubationCondition}, "Select under what conditions the cells should be incubated:",
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				CultureAdhesion -> Suspension,
				IncubationCondition -> BacterialShakingIncubation,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, IncubationCondition],
			BacterialShakingIncubation,
			Variables :> {options}
		],
		Example[{Options, CarbonDioxide, "Incubate a single mammalian sample in a plate with a given CarbonDioxide percentage:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CarbonDioxide -> 5 Percent,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, CarbonDioxide],
			EqualP[5 Percent],
			Variables :> {options}
		],
		Example[{Options, RelativeHumidity, "Incubate a single mammalian sample in a plate with a given RelativeHumidity percentage:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				RelativeHumidity -> 93 Percent,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, RelativeHumidity],
			EqualP[93 Percent],
			Variables :> {options}
		],
		Example[{Options, Shake, "Incubate a single bacterial sample in a plate with shaking:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Shake -> True,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, Shake],
			True,
			Variables :> {options}
		],
		Example[{Options, ShakingRate, "Incubate a single bacterial sample in a plate with a given shaking rate:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRate -> 180 RPM,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, ShakingRate],
			EqualP[180 RPM],
			Variables :> {options}
		],
		Example[{Options, {Shake, ShakingRate, ShakingRadius}, "Incubate a sample with Shake ->False when given Null for either ShakingRate or ShakingRadius:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRate -> Null,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, {Shake, ShakingRate, ShakingRadius}],
			{False, Null, Null},
			Variables :> {options}
		],
		Example[{Options, ShakingRadius, "Incubate a single bacterial sample in a plate with a given shaking radius:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				ShakingRadius -> 25.4 Millimeter,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, ShakingRadius],
			EqualP[25.4 Millimeter],
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "SamplesOutStorageCondition indicates how the cells should be stored after the protocol is completed:"},
			options = ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				SamplesOutStorageCondition -> BacterialShakingIncubation,
				Output -> Options,
				OptionsResolverOnly -> True
			];
			Lookup[options, SamplesOutStorageCondition],
			BacterialShakingIncubation,
			Variables :> {options}
		],
		Example[{Options, Name, "Incubate a single bacterial sample in a plate with a specified Name for the protocol:"},
			Download[
				ExperimentIncubateCells[
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Name -> "my bacteria incubation" <> $SessionUUID
				],
				Name
			],
			"my bacteria incubation" <> $SessionUUID
		],
		Example[{Options, Template, "Incubate a single bacterial sample in a plate with a specified Template:"},
			Module[{protocol, newProt},
				protocol = ExperimentIncubateCells[
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Name -> "my template bacteria incubation" <> $SessionUUID,
					Temperature -> 33 Celsius
				];
				newProt = ExperimentIncubateCells[
					Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
					Template -> protocol
				];

				Download[newProt, Temperatures]
			],
			{EqualP[33 Celsius]}
		],
		If[TrueQ[$IncubateCellsTestIncubateOnly],
			Nothing,
			Sequence @@ {
				Example[{Additional, "Incubate a suspension bacterial sample for 12 hours, quantifying the cell concentration every two hours using an absorbance intensity measurement to generate a growth curve:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> None,
						Time -> 12 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationMethod -> Absorbance,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						Output -> Result
					],
					ObjectP[Object[Protocol, IncubateCells]]
				],
				Example[{Additional, "Incubate a solid media bacterial sample for 12 hours, quantifying the colony count every two hours until a colony count of at least 500 colonies is obtained:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 500 Colony,
						Time -> 12 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationMethod -> ColonyCount,
						FailureResponse -> Discard,
						Output -> Result
					],
					ObjectP[Object[Protocol, IncubateCells]]
				],
				Example[{Additional, "Incubate a suspension bacterial sample for 3 hours using a robotic liquid handler and its integrations, quantifying the cell concentration every 1 hour using an absorbance measurement until an OD600 of at least 0.8 is obtained:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 3 Hour,
						QuantificationInterval -> 1 Hour,
						QuantificationMethod -> Absorbance,
						QuantificationBlankMeasurement -> False,
						FailureResponse -> Discard,
						Preparation -> Robotic,
						Output -> Result
					],
					ObjectP[Object[Protocol, RoboticCellPreparation]]
				],
				Test["If FailureResponse is Freeze, upload a FreezeCells unit operation to the FailureResponseUnitOperation field:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Freeze
					];
					{
						protocol,
						Download[protocol, FailureResponseUnitOperation]
					},
					{
						ObjectP[Object[Protocol, IncubateCells]],
						_FreezeCells
					},
					Variables :> {protocol}
				],
				Test["If FailureResponse is Freeze and any sample has a volume in excess of 3 Milliliter, partition the samples into the minimum required number of cryogenic vials:",
					Module[
						{protocol, freezeCellsPrimitiveAssociation},
						protocol = ExperimentIncubateCells[
							{Object[Sample, "Test sample for quantification tests 5 (for ExperimentIncubateCells)" <> $SessionUUID]},
							FailureResponse -> Freeze,
							QuantificationMethod -> Absorbance,
							QuantificationAliquot -> True,
							MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
						];
						freezeCellsPrimitiveAssociation = Download[protocol, FailureResponseUnitOperation][[1]];
						Lookup[freezeCellsPrimitiveAssociation, NumberOfReplicates]
					],
					8
				],
				Test["If FailureResponse is Discard, no unit operation is uploaded to the FailureResponseUnitOperation field:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard
					];
					{
						protocol,
						Download[protocol, FailureResponseUnitOperation]
					},
					{
						ObjectP[Object[Protocol, IncubateCells]],
						Null
					},
					Variables :> {protocol}
				],
				Test["If FailureResponse is Incubate, no unit operation is uploaded to the FailureResponseUnitOperation field:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Incubate
					];
					{
						protocol,
						Download[protocol, FailureResponseUnitOperation]
					},
					{
						ObjectP[Object[Protocol, IncubateCells]],
						Null
					},
					Variables :> {protocol}
				],
				Test["If QuantificationAliquot is True for any sample, a Transfer primitive is uploaded to the QuantificationAliquotUnitOperation field:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard
					];
					{
						protocol,
						Download[protocol, QuantificationAliquotUnitOperation]
					},
					{
						ObjectP[Object[Protocol, IncubateCells]],
						_Transfer
					},
					Variables :> {protocol}
				],
				Test["If IncubationStrategy is QuantificationTarget, a constant array of QuantificationInterval with length equal to the maximum number of quantification cycles is uploaded to the QuantificationProcessingTimes field:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> True,
						QuantificationInterval -> 3 Hour,
						Time -> 12 Hour,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard
					];
					{
						protocol,
						Download[protocol, QuantificationProcessingTimes]
					},
					{
						ObjectP[Object[Protocol, IncubateCells]],
						{EqualP[3 Hour], EqualP[3 Hour], EqualP[3 Hour], EqualP[3 Hour]}
					},
					Variables :> {protocol}
				],
				Test["If Preparation is Robotic and we are quantifying, the RoboticUnitOperations with type Object[UnitOperation, IncubateCells] have Time set to the specified QuantificationInterval rather than the total Time:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard,
						IncubationStrategy -> QuantificationTarget,
						QuantificationBlankMeasurement -> False,
						Time -> 3 Hour,
						QuantificationInterval -> 1 Hour,
						MinQuantificationTarget -> 1 OD600,
						Preparation -> Robotic
					];
					incubateCellsRoboticUnitOperations = Cases[
						Flatten@Download[protocol, OutputUnitOperations[RoboticUnitOperations]],
						ObjectP[Object[UnitOperation, IncubateCells]]
					];
					Download[incubateCellsRoboticUnitOperations, Time],
					ConstantArray[EqualP[1 Hour], 3],
					Variables :> {protocol, incubateCellsRoboticUnitOperations}
				],
				Test["If Preparation is Robotic and we are quantifying, an IncubateCells, QuantifyCells, and child quantification RoboticUnitOperation is generated for each incubation/quantification cycle:",
					protocol = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard,
						IncubationStrategy -> QuantificationTarget,
						QuantificationBlankMeasurement -> False,
						Time -> 3 Hour,
						QuantificationInterval -> 1 Hour,
						MinQuantificationTarget -> 1 OD600,
						Preparation -> Robotic
					];
					Cases[
						Flatten @ Download[protocol, OutputUnitOperations[RoboticUnitOperations]],
						Except[ObjectP[Object[UnitOperation, LabelSample]]]
					],
					{
						ObjectP[Object[UnitOperation, IncubateCells]], ObjectP[Object[UnitOperation, QuantifyCells]], ObjectP[Object[UnitOperation, AbsorbanceIntensity]],
						ObjectP[Object[UnitOperation, IncubateCells]], ObjectP[Object[UnitOperation, QuantifyCells]], ObjectP[Object[UnitOperation, AbsorbanceIntensity]],
						ObjectP[Object[UnitOperation, IncubateCells]], ObjectP[Object[UnitOperation, QuantifyCells]], ObjectP[Object[UnitOperation, AbsorbanceIntensity]]
					},
					Variables :> {protocol, roboticUnitOperationsWithoutLabelSample}
				],
				Example[{Options, Time, "If Preparation is Manual and IncubationStrategy is QuantificationTarget, automatically set to 12 Hour:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard,
						MinQuantificationTarget -> None,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, Time],
					EqualP[12 Hour],
					Variables :> {options}
				],
				Example[{Options, Time, "If Preparation is Manual, IncubationStrategy is Time, and the cell's doubling time is known, automatically set to 36x the doubling time if it falls below $MaxCellIncubationTime:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> Time,
						Output -> Options
					];
					cellDoublingTime = Download[
						Model[Cell, Bacteria, "id:54n6evLm7m0L"],(*"E.coli MG1655"*)
						DoublingTime
					];
					EqualQ[Lookup[options, Time], 36 * cellDoublingTime],
					True,
					Variables :> {options, cellDoublingTime}
				],
				Example[{Messages, "ConflictingIncubationStrategy", "If any of the quantification options are specified while IncubationStrategy is Time, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> Time,
						QuantificationWavelength -> 540 Nanometer
					],
					$Failed,
					Messages :> {
						Error::ConflictingIncubationStrategy,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingIncubationStrategy", "If QuantificationMethod is Null while IncubationStrategy is QuantificationTarget, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						QuantificationAliquot -> True,
						QuantificationAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
						FailureResponse -> Discard,
						QuantificationMethod -> Null
					],
					$Failed,
					Messages :> {
						Error::ConflictingIncubationStrategy,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingIncubationStrategy", "If QuantificationInstrument is Null while IncubationStrategy is QuantificationTarget, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						QuantificationAliquot -> True,
						QuantificationAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
						QuantificationAliquotVolume -> 50 Microliter,
						FailureResponse -> Discard,
						QuantificationInstrument -> Null
					],
					$Failed,
					Messages :> {
						Error::ConflictingIncubationStrategy,
						Error::ConflictingQuantificationMethodAndInstrument,
						Error::InvalidOption
					}
				],
				Example[{Messages, "UnsuitableQuantificationInterval", "If the QuantificationInterval is longer than the Time, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						QuantificationInterval -> 30 Hour,
						Time -> 24 Hour
					],
					$Failed,
					Messages :> {
						Error::UnsuitableQuantificationInterval,
						Error::InvalidOption
					}
				],
				Example[{Messages, "UnsuitableQuantificationInterval", "If QuantificationInterval is Null while IncubationStrategy is QuantificationTarget, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						QuantificationAliquot -> True,
						QuantificationInterval -> Null,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::UnsuitableQuantificationInterval,
						Error::InvalidOption
					}
				],
				Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Incubate and IncubationCondition is Custom for any sample, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						FailureResponse -> Incubate,
						IncubationCondition -> Custom,
						Incubator -> Model[Instrument, Incubator, "Multitron Pro with 25mm Orbit"],
						CellType -> Bacterial,
						CultureAdhesion -> Suspension,
						Temperature -> 37 Celsius,
						CarbonDioxide -> Ambient,
						RelativeHumidity -> Ambient,
						Shake -> True,
						ShakingRadius -> 25 Millimeter,
						ShakingRate -> 250 RPM,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
					],
					$Failed,
					Messages :> {
						Error::FailureResponseNotSupported,
						Error::InvalidOption
					}
				],
				Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Freeze and any samples have a CultureAdhesion other than Suspension, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						FailureResponse -> Freeze,
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 500 Colony
					],
					$Failed,
					Messages :> {
						Error::FailureResponseNotSupported,
						Error::InvalidOption
					}
				],
				Example[{Messages, "FailureResponseNotSupported", "If FailureResponse is Freeze and the total volume to be frozen exceeds the capacity of a single instance of Model[Container, Rack, InsulatedCooler, \"5mL Mr. Frosty Rack\"], an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						FailureResponse -> Freeze,
						QuantificationMethod -> Absorbance,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
					],
					$Failed,
					Messages :> {
						Error::FailureResponseNotSupported,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationOptions", "If QuantificationTolerance is Null while MinQuantificationTarget is specified, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationTolerance -> Null,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationOptions", "If MinQuantificationTarget is Null while QuantificationTolerance is specified, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationTolerance -> 10 Percent,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> Null
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationOptions", "If MinQuantificationTarget is None while QuantificationTolerance is specified, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationTolerance -> 10 Percent,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> None
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is Nephelometry and the QuantificationInstrument is not a Nephelometer, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						Time -> 3 Hour,
						QuantificationMethod -> Nephelometry,
						QuantificationInstrument -> Model[Instrument, ColonyHandler, "QPix 420 HT"],
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationMethodAndInstrument,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is ColonyCount and the QuantificationInstrument is not a ColonyHandler, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						Time -> 3 Hour,
						QuantificationMethod -> ColonyCount,
						QuantificationInstrument -> Model[Instrument, Nephelometer, "NEPHELOstar Plus"],
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationMethodAndInstrument,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ConflictingQuantificationMethodAndInstrument", "If the QuantificationMethod is Absorbance and the QuantificationInstrument is not a Spectrophotometer or PlateReader, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						Time -> 3 Hour,
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Model[Instrument, Nephelometer, "NEPHELOstar Plus"],
						MinQuantificationTarget -> (1000000 Cell)/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationMethodAndInstrument,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ExcessiveQuantificationAliquotVolumeRequired", "If the quantification schedule and aliquoting parameters would result in depletion of the input sample if the maximum number of quantifications was to occur, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquot -> True,
						QuantificationAliquotVolume -> 150 Microliter,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationInterval -> 1 Hour,
						Time -> 36 Hour,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ExcessiveQuantificationAliquotVolumeRequired,
						Error::InvalidOption
					},
					SetUp :> (Upload[<|Object -> Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 5 Milliliter|>]),
					TearDown :> (Upload[<|Object -> Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID], Volume -> 30 Milliliter|>])
				],
				Example[{Messages, "QuantificationTargetUnitsMismatch", "If MinQuantificationTarget and QuantificationTolerance are quantities with different units and QuantificationTolerance is not a Percent, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationTolerance -> 25 OD600
					],
					$Failed,
					Messages :> {
						Error::QuantificationTargetUnitsMismatch,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If any aliquoting options are specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquot -> True,
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 500 Colony,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ExtraneousQuantifyColoniesOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationWavelength is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationWavelength -> 600 Nanometer,
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 500 Colony,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ExtraneousQuantifyColoniesOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationStandardCurve is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationStandardCurve -> Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 500 Colony,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ExtraneousQuantifyColoniesOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "ExtraneousQuantifyColoniesOptions", "If a QuantificationBlank is specified while the QuantificationMethod is ColonyCount, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationBlank -> Model[Sample, "Milli-Q water"],
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 500 Colony,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ExtraneousQuantifyColoniesOptions,
						Error::InvalidOption
					}
				],
				Example[{Messages, "AliquotRecoupMismatch", "If FailureResponse is not Null and there are multiple input samples, a warning is thrown to tell the user that the response will be carried out for all samples if any one of them fails:"},
					ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationRecoupSample -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> False,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::AliquotRecoupMismatch,
						Error::InvalidOption
					}
				],
				Example[{Messages, "MixedQuantificationAliquotRequirements", "If QuantificationAliquot is Automatic and the conditions of the experiment necessitate aliquoting for quantification of a subset (but not all) of the samples, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID], (* in a UV-star plate - BMG compatible *)
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]  (* in a standard 96 DWP - not BMG compatible *)
						},
						MinQuantificationTarget -> 0.5 OD600,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 2 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> Automatic,
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::MixedQuantificationAliquotRequirements,
						Warning::GeneralFailureResponse,
						Error::InvalidOption
					}
				],
				Example[{Messages, "QuantificationAliquotRecommended", "If QuantificationMethod is Absorbance or Nephelometry, Preparation is Manual, and QuantificationAliquot is False, a warning is thrown to recommend setting QuantificationAliquot to True to minimize the time that cells spend outside of the incubator(s):"},
					ExperimentIncubateCells[{Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID]},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 1 Hour,
						QuantificationInterval -> 1 Hour,
						QuantificationMethod -> Absorbance,
						QuantificationBlankMeasurement -> False,
						QuantificationAliquot -> False,
						FailureResponse -> Discard,
						Preparation -> Manual,
						Output -> Options
					],
					{__Rule},
					Messages :> {
						Warning::QuantificationAliquotRecommended
					}
				],
				Example[{Messages, "ConflictingQuantificationAliquotOptions", "If QuantificationAliquotVolume is set to Null for any samples when QuantificationAliquot is True, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 4 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationAliquot -> True,
						QuantificationAliquotVolume -> {150 Microliter, Null},
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationAliquotOptions,
						Error::InvalidOption,
						Warning::GeneralFailureResponse
					}
				],
				Example[{Messages, "ConflictingQuantificationAliquotOptions", "If QuantificationAliquotVolume is specified for any samples when QuantificationAliquot is False, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 4 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationAliquot -> False,
						QuantificationAliquotVolume -> {150 Microliter, Null},
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationAliquotOptions,
						Error::InvalidOption,
						Warning::GeneralFailureResponse
					}
				],
				Example[{Messages, "ConflictingQuantificationAliquotOptions", "If QuantificationAliquotContainer is set to Null for any samples when QuantificationAliquot is True, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 4 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationAliquot -> True,
						QuantificationAliquotContainer -> {Null, Model[Container, Plate, "96-well UV-Star Plate"]},
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationAliquotOptions,
						Error::InvalidOption,
						Warning::GeneralFailureResponse
					}
				],
				Example[{Messages, "ConflictingQuantificationAliquotOptions", "If QuantificationAliquotContainer is specified for any samples when QuantificationAliquot is False, an error is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 4 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationAliquot -> False,
						QuantificationAliquotContainer -> {Null, Model[Container, Plate, "96-well UV-Star Plate"]},
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard
					],
					$Failed,
					Messages :> {
						Error::ConflictingQuantificationAliquotOptions,
						Error::InvalidOption,
						Warning::GeneralFailureResponse
					}
				],
				Example[{Messages, "QuantificationAliquotRequired",  "If QuantificationAliquot is Automatic and any of the input samples are not in containers compatible with the QuantificationInstrument, QuantificationAliquot is automatically set to True and a warning is thrown:"},
					options = ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]  (* in a standard 96 DWP - not BMG compatible *)
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 2 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationMethod -> Absorbance,
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquot],
					True,
					Variables :> {options},
					Messages :> {Warning::QuantificationAliquotRequired}
				],
				Example[{Messages, "QuantificationAliquotRequired",  "If QuantificationAliquot is Automatic and the QuantificationAliquotVolume is specified for any sample, QuantificationAliquot is automatically set to True and a warning is thrown:"},
					options = ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquotVolume -> {150 Microliter, Automatic},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 6 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationMethod -> Absorbance,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquot],
					True,
					Variables :> {options},
					Messages :> {Warning::GeneralFailureResponse, Warning::QuantificationAliquotRequired}
				],
				Example[{Messages, "QuantificationAliquotRequired",  "If QuantificationAliquot is Automatic and a QuantificationAliquotContainer is specified for any sample, QuantificationAliquot is automatically set to True and a warning is thrown:"},
					options = ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquotContainer -> {Automatic, Model[Container, Plate, "96-well UV-Star Plate"]},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 0.8 OD600,
						Time -> 6 Hour,
						QuantificationInterval -> 2 Hour,
						QuantificationMethod -> Absorbance,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquot],
					True,
					Variables :> {options},
					Messages :> {Warning::GeneralFailureResponse, Warning::QuantificationAliquotRequired}
				],
				Example[{Messages, "DiscardUponFailure", "If FailureResponse is unspecified, it is automatically set to Discard and a warning is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						Output -> Options,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						OptionsResolverOnly -> True
					],
					KeyValuePattern[{
						FailureResponse -> Discard
					}],
					Messages :> {
						Warning::DiscardUponFailure
					}
				],
				Example[{Messages, "NoQuantificationTarget", "If MinQuantificationTarget is unspecified, it is automatically set to None and a warning is thrown:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						Output -> Options,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True
					],
					KeyValuePattern[{
						MinQuantificationTarget -> None
					}],
					Messages :> {
						Warning::NoQuantificationTarget
					}
				],
				Example[{Messages, "GeneralFailureResponse", "If FailureResponse is not Null and there are multiple input samples, a warning is thrown to tell the user that the response will be carried out for all samples if any one of them fails:"},
					ExperimentIncubateCells[
						{
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
							Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						Output -> Options,
						OptionsResolverOnly -> True
					],
					KeyValuePattern[{
						QuantificationAliquot -> True
					}],
					Messages :> {
						Warning::GeneralFailureResponse
					}
				],
				(* Quantification Options *)
				Example[{Options, IncubationStrategy, "The IncubationStrategy option can be used to specify whether cells are incubated until the Time has passed or until a predetermined quantification target has been met:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, IncubationStrategy],
					QuantificationTarget,
					Variables :> {options}
				],
				Example[{Options, IncubationStrategy, "If any quantification options are specified, the IncubationStrategy is automatically set to QuantificationTarget:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationTolerance -> 15 Percent,
						Time -> 9 Hour,
						QuantificationAliquot -> True,
						QuantificationInterval -> 3 Hour,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, IncubationStrategy],
					QuantificationTarget,
					Variables :> {options}
				],
				Example[{Options, QuantificationMethod, "Specify the analytical method used to quantify the cells using the QuantificationMethod option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationMethod -> Absorbance,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationMethod],
					Absorbance,
					Variables :> {options}
				],
				Example[{Options, QuantificationMethod, "If the specified QuantificationInstrument restricts the possible QuantificationMethod to a particular method of analysis, QuantificationMethod is automatically set to that method:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationInstrument -> Model[Instrument, PlateReader, "CLARIOstar"],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationMethod],
					Absorbance,
					Variables :> {options}
				],
				Example[{Options, QuantificationMethod, "If the sample(s) are in a Solid State and IncubationStrategy is QuantificationTarget, QuantificationMethod is automatically set to ColonyCount:"},
					options = ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 1000 Colony,
						Time -> 10 Hour,
						QuantificationInterval -> 2 Hour,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationMethod],
					ColonyCount,
					Variables :> {options}
				],
				Example[{Options, QuantificationMethod, "If the sample(s) have a CultureAdhesion other than Suspension and IncubationStrategy is QuantificationTarget, QuantificationMethod is automatically set to ColonyCount:"},
					options = ExperimentIncubateCells[
						{
							Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID]
						},
						IncubationStrategy -> QuantificationTarget,
						CultureAdhesion -> SolidMedia,
						MinQuantificationTarget -> 1000 Colony,
						Time -> 10 Hour,
						QuantificationInterval -> 2 Hour,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationMethod],
					ColonyCount,
					Variables :> {options}
				],
				Example[{Options, MinQuantificationTarget, "Specify the cell concentration at which cell incubation is to cease using the MinQuantificationTarget option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, MinQuantificationTarget],
					EqualP[1000000 EmeraldCell/Milliliter],
					Variables :> {options}
				],
				Example[{Options, MinQuantificationTarget, "If IncubationStrategy is QuantificationMethod and MinQuantificationTarget is Automatic, MinQuantificationTarget is automatically set to None, indicating that incubation will proceed until the Time has elapsed, but quantifications will occur at each QuantificationInterval:"},
					options = Quiet[
						ExperimentIncubateCells[
							Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
							IncubationStrategy -> QuantificationTarget,
							QuantificationAliquot -> True,
							FailureResponse -> Discard,
							OptionsResolverOnly -> True,
							Output -> Options
						],
						Warning::NoQuantificationTarget
					];
					Lookup[options, MinQuantificationTarget],
					None,
					Variables :> {options}
				],
				Example[{Options, QuantificationTolerance, "Specify the QuantificationTolerance as a cell concentration:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationTolerance -> 50000 EmeraldCell/Milliliter,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationTolerance],
					EqualP[50000 EmeraldCell/Milliliter],
					Variables :> {options}
				],
				Example[{Options, QuantificationTolerance, "Specify the QuantificationTolerance as a percentage of the MinQualificationTarget:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationTolerance -> 15 Percent,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationTolerance],
					EqualP[15 Percent],
					Variables :> {options}
				],
				Example[{Options, QuantificationTolerance, "If MinQuantificationTarget is not Null or None and QuantificationTolerance is Automatic, QuantificationTolerance is automatically set to 10 Percent:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationTolerance],
					EqualP[10 Percent],
					Variables :> {options}
				],
				Example[{Options, QuantificationInterval, "Specify the QuantificationInterval option to set the time interval between quantifications:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationInterval -> 1 Hour,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationInterval],
					EqualP[1 Hour],
					Variables :> {options}
				],
				Example[{Options, QuantificationInterval, "If IncubationStrategy is QuantificationTarget, QuantificationInterval is not specified, and one fifth of the Time is less than 1 Hour, QuantificationInterval is automatically set to 1 Hour:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						Time -> 3 Hour,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationInterval],
					EqualP[1 Hour],
					Variables :> {options}
				],
				Example[{Options, QuantificationInterval, "If IncubationStrategy is QuantificationTarget, QuantificationInterval is not specified, and one fifth of the Time is greater than 1 Hour, QuantificationInterval is automatically set to one fifth of the Time:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> QuantificationTarget,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						QuantificationAliquot -> True,
						Time -> 20 Hour,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationInterval],
					EqualP[4 Hour],
					Variables :> {options}
				],
				Example[{Options, FailureResponse, "Specify the FailureResponse option to determine the fate of a cell sample in the event that the MinQuantificationTarget is not obtained before the Time elapses:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, FailureResponse],
					Discard,
					Variables :> {options}
				],
				Example[{Options, QuantificationAliquot, "Specify whether quantification should be performed on an aliquoted portion of the sample (rather than directly on the source sample) with the QuantificationAliquot option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquot],
					True,
					Variables :> {options}
				],
				Example[{Options, QuantificationAliquotVolume, "Specify the amount of sample to be aliquoted for quantification with the QuantificationAliquotVolume option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquotVolume -> 150 Microliter,
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquotVolume],
					EqualP[150 Microliter],
					Variables :> {options}
				],
				Example[{Options, QuantificationAliquotContainer, "Specify the container model into which a portion of the cell sample will be aliquoted for quantification with the QuantificationAliquotContainer option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquotContainer],
					ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]],
					Variables :> {options}
				],
				Example[{Options, QuantificationAliquotContainer, "If QuantificationAliquot is True and QuantificationAliquotContainer is Automatic, QuantificationAliquotContainer is automatically set to a container model which is compatible with the QuantificationInstrument and QuantificationAliquotVolume:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> True,
						QuantificationAliquotVolume -> 150 Microliter,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationAliquotContainer],
					ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]],
					Variables :> {options}
				],
				Example[{Options, QuantificationRecoupSample, "Specify whether each aliquoted portion of the source sample should be recombined with the source sample following quantification with the QuantificationRecoupSample option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationRecoupSample -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationRecoupSample],
					True,
					Variables :> {options},
					Messages :> {Warning::RecoupContamination}
				],
				Example[{Options, QuantificationRecoupSample, "If QuantificationAliquot is True, QuantificationRecoupSample defaults to False unless specified otherwise:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationAliquot -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationRecoupSample],
					False,
					Variables :> {options}
				],
				Example[{Options, QuantificationInstrument, "Specify the instrument object or model to be used for quantification with the QuantificationInstrument option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationInstrument -> Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationInstrument],
					ObjectP[Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID]],
					Variables :> {options}
				],
				Example[{Options, QuantificationInstrument, "If QuantificationMethod is specified and the QuantificationInstrument is automatic, QuantificationInstrument is automatically set to an instrument capable of the method:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationMethod -> Absorbance,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationInstrument],
					ObjectP[Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID]],
					Variables :> {options}
				],
				Example[{Options, QuantificationBlankMeasurement, "Specify whether a blank measurement should be recorded to account for background noise in quantification with the QuantificationBlankMeasurement option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationBlankMeasurement -> True,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationBlankMeasurement],
					True,
					Variables :> {options}
				],
				Example[{Options, QuantificationBlankMeasurement, "If IncubationStrategy is QuantificationTarget and QuantificationMethod is Absorbance or Nephelometry, QuantificationBlankMeasurement is set to True:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> QuantificationTarget,
						QuantificationMethod -> Absorbance,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationBlankMeasurement],
					True,
					Variables :> {options}
				],
				Example[{Options, QuantificationBlankMeasurement, "If IncubationStrategy is QuantificationTarget and QuantificationMethod is ColonyCount, QuantificationBlankMeasurement is set to False:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						IncubationStrategy -> QuantificationTarget,
						QuantificationMethod -> ColonyCount,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationBlankMeasurement],
					False,
					Variables :> {options}
				],
				Example[{Options, QuantificationBlank, "Specify the sample object or model to be used as the blank sample in quantification with the QuantificationBlank option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationBlank -> Model[Sample, "Milli-Q water"],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationBlank],
					ObjectP[Model[Sample, "Milli-Q water"]],
					Variables :> {options}
				],
				Example[{Options, QuantificationBlank, "If QuantificationBlankMeasurement is True, QuantificationBlank defaults to a solution with identical composition to the media in which the cell sample is being incubated unless specified otherwise:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationBlankMeasurement -> True,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationBlank],
					ObjectP[Model[Sample, "Milli-Q water"]],
					Variables :> {options}
				],
				Example[{Options, QuantificationWavelength, "Specify the wavelength to be detected by the quantification measurement with the QuantificationWavelength option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationWavelength -> 600 Nanometer,
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationWavelength],
					EqualP[600 Nanometer],
					Variables :> {options}
				],
				Example[{Options, QuantificationStandardCurve, "Specify a standard curve used to convert raw data to cell concentration units with the QuantificationStandardCurve option:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						QuantificationStandardCurve -> Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationStandardCurve],
					ObjectP[Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID]],
					Variables :> {options}
				],
				Example[{Options, QuantificationStandardCurve, "If any existing standard curve is compatible with the sample, required cell unit conversion and instrument used in the experiment, the QuantificationStandardCurve option will automatically resolve to one such standard curve:"},
					options = ExperimentIncubateCells[
						Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
						MinQuantificationTarget -> 1000000 EmeraldCell/Milliliter,
						QuantificationAliquot -> True,
						FailureResponse -> Discard,
						OptionsResolverOnly -> True,
						Output -> Options
					];
					Lookup[options, QuantificationStandardCurve],
					ObjectP[Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID]],
					Variables :> {options}
				]
			}
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True]; Unset[$CreatedObjects]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{
				existsFilter, allObjs
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentIncubateCells tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test water sample flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test tall mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 5 (open) (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test insect plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate with stowaways (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test Omni tray 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate with water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test uncovered plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test gas plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test 14mL Falcon Tube (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test 2nd bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in tall plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in short plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test deprecated sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in an open flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test insect cell (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test gas sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Deprecated Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, Incubator, "Test incubator instrument object (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Cover 1 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 2 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 3 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 4 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 5 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 6 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 7 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8b for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8c for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID],
				(* note I skipped 13 on purpose here because it is for the uncovered container *)
				Object[Item, Lid, "Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 19 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 20 for ExperimentIncubateCells tests " <> $SessionUUID],

				Object[Sample, "Test sample in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],

				Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID],
				Model[Cell, "Test cell model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Test cell sample model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, PlateReader, "Test PlateReader 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Instrument, PlateReader, "Test non-BMG Plate Reader model (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Protocol, AbsorbanceIntensity, "Test AbsorbanceIntensity protocol 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test flask for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test flask for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test flask for quantification 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Test cover for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Test cover for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test cover for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, PlateSeal, "Test cover for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Test cover for quantification tests 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 5 (for ExperimentIncubateCells)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[
				PickList[
					allObjs,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];
		];
		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench,
					bacteriaModel, mammalianModel, solidMediaBacteriaModel,
					emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5,
					emptyContainer6, emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11,
					emptyContainer12, emptyContainer13, emptyContainer14,
					discardedBacteriaSample1, bacteriaSample2, bacteriaModelSeveredSample3, mammalianSample1, mammalianSample2,
					bacteriaSample4, bacteriaSample4b, bacteriaSample5, bacteriaSample6, waterSample1, mammalianSample3,
					mammalianSample4, openSample, insectSample,
					cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8, cover9, cover10, cover11,
					cover12, cover14, cover16, cover17, cover19,
					deprecatedBacteriaModel, deprecatedBacteriaSample, solidMediaSample1, emptyContainer16,

					emptyContainer15, cover15, sampleInSamePlate1, sampleInSamePlate2, emptyContainer17, waterSample2,
					emptyContainer18, emptyContainer19, bacteriaSample7,
					emptyContainer8b, emptyContainer8c, cover8b, cover8c, bacteriaSample5b, bacteriaSample5c, gasSample,

					emptyContainer20, cover20, bacterialSample20,

					tooManySamplesCover1, tooManySamplesCover2, tooManySamplesCover3, tooManySamplesCover4, tooManySamplesCover5,
					tooManySamplesCover6, tooManySamplesCover7, tooManySamplesCover8, tooManySamplesCover9, tooManySamplesCover10,
					tooManySamplesCover11, tooManySamplesCover12, tooManySamplesCover13, tooManySamplesCover14, tooManySamplesCover15,
					tooManySamplesCover16, tooManySamplesCover17,

					tooManySamplesContainer1, tooManySamplesContainer2, tooManySamplesContainer3, tooManySamplesContainer4,
					tooManySamplesContainer5, tooManySamplesContainer6, tooManySamplesContainer7, tooManySamplesContainer8,
					tooManySamplesContainer9, tooManySamplesContainer10, tooManySamplesContainer11, tooManySamplesContainer12,
					tooManySamplesContainer13, tooManySamplesContainer14, tooManySamplesContainer15, tooManySamplesContainer16,
					tooManySamplesContainer17,

					tooManySamplesSample1, tooManySamplesSample2, tooManySamplesSample3, tooManySamplesSample4, tooManySamplesSample5,
					tooManySamplesSample6, tooManySamplesSample7, tooManySamplesSample8, tooManySamplesSample9, tooManySamplesSample10,
					tooManySamplesSample11, tooManySamplesSample12, tooManySamplesSample13, tooManySamplesSample14, tooManySamplesSample15,
					tooManySamplesSample16, tooManySamplesSample17,

					mcpParentProt1,

					cellModelWithCurve, bacterialSampleModelWithCurve, plateReader1, plateReader2, nonBMGPlateReaderModel, absCurve, absProtocol,
					quantContainer1, quantContainer2, quantContainer3, quantContainer4, quantContainer5,
					quantCover1, quantCover2, quantCover3, quantCover4, quantCover5,
					quantSample1, quantSample2, quantSample3, quantSample4, quantSample5
				},

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentIncubateCells tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(*Upload a fake instrument object*)
				Upload[
					<|
						Type -> Object[Instrument, Incubator],
						Model -> Link[Model[Instrument, Incubator, "Innova 44 for Bacterial Flasks"], Objects],
						Name -> "Test incubator instrument object (for ExperimentIncubateCells)" <> $SessionUUID,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>
				];

				(* Generate IDs for some test objects related to quantification. *)
				{cellModelWithCurve, bacterialSampleModelWithCurve, plateReader1, plateReader2, nonBMGPlateReaderModel, absCurve, absProtocol} = CreateID[{
					Model[Cell],
					Model[Sample],
					Object[Instrument, PlateReader],
					Object[Instrument, PlateReader],
					Model[Instrument, PlateReader],
					Object[Analysis, StandardCurve],
					Object[Protocol, AbsorbanceIntensity]
				}];

				(* Upload objects for quantification tests. *)
				Upload[{
					<|
						Object -> cellModelWithCurve,
						Name -> "Test cell model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID,
						CellType -> Bacterial,
						Replace[StandardCurves] -> {Link[absCurve]},
						Replace[StandardCurveProtocols] -> {Link[absProtocol]}
					|>,
					<|
						Object -> bacterialSampleModelWithCurve,
						Name -> "Test cell sample model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID,
						Replace[Composition] -> {
							{1000 * EmeraldCell/Milliliter, Link[cellModelWithCurve]},
							{100 * VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]}
						},
						Expires -> False,
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						State -> Liquid,
						BiosafetyLevel -> "BSL-1",
						Flammable -> False,
						MSDSRequired -> False,
						CellType -> Bacterial,
						CultureAdhesion -> Suspension,
						Living -> True
					|>,
					Append[
						Quiet[DoppelgangerObject[Model[Instrument, PlateReader, "CLARIOstar"]]],
						<|
							Object -> nonBMGPlateReaderModel,
							(* The resolver checks the manufacturer of the plate reader to determine whether to run BMGCompatiblePlates, *)
							(* so I can pick any other supplier in the database for the manufacturer of this test model. *)
							Manufacturer -> Link[Object[Company, Supplier, "Hofbrauhaus"], InstrumentsManufactured],
							Name -> "Test non-BMG Plate Reader model (for ExperimentIncubateCells)" <> $SessionUUID,
							Replace[PlateReaderMode] -> {AbsorbanceIntensity, AbsorbanceKinetics}
						|>
					],
					<|
						Object -> plateReader1,
						Name -> "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						Model -> Link[Model[Instrument, PlateReader, "CLARIOstar"], Objects],
						Site -> Link[$Site]
					|>,
					<|
						Object -> plateReader2,
						Name -> "Test PlateReader 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						Model -> Link[nonBMGPlateReaderModel, Objects],
						Site -> Link[$Site]
					|>,
					<|
						Object -> absProtocol,
						Name -> "Test AbsorbanceIntensity protocol 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						Instrument -> Link[plateReader1]
					|>,
					<|
						Object -> absCurve,
						Name -> "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID,
						BestFitFunction -> QuantityFunction[#^2&, OD600, EmeraldCell/Milliliter],
						Replace[StandardDataUnits] -> {OD600, EmeraldCell/Milliliter},
						Protocol -> Link[absProtocol]
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
					emptyContainer8b,
					emptyContainer8c,
					emptyContainer9,
					emptyContainer10,
					emptyContainer11,
					emptyContainer12,
					emptyContainer13,
					emptyContainer14,
					emptyContainer15,
					emptyContainer16,
					emptyContainer17,
					emptyContainer18,
					emptyContainer19,
					emptyContainer20,

					tooManySamplesContainer1,
					tooManySamplesContainer2,
					tooManySamplesContainer3,
					tooManySamplesContainer4,
					tooManySamplesContainer5,
					tooManySamplesContainer6,
					tooManySamplesContainer7,
					tooManySamplesContainer8,
					tooManySamplesContainer9,
					tooManySamplesContainer10,
					tooManySamplesContainer11,
					tooManySamplesContainer12,
					tooManySamplesContainer13,
					tooManySamplesContainer14,
					tooManySamplesContainer15,
					tooManySamplesContainer16,
					tooManySamplesContainer17,
					
					quantContainer1,
					quantContainer2,
					quantContainer3,
					quantContainer4,
					quantContainer5
				} = UploadSample[
					{
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "1L Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(* 50mL Tube *)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(* 50mL Tube *)
						Model[Container, Vessel, "id:aXRlGnZmOOB9"], (* 10L Carboy*)
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "384-well Optical Reaction Plate"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
						Model[Container, Vessel, "id:AEqRl9KXBDoW"],(*"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"*)

						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],

						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Erlenmeyer flask 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test Erlenmeyer flask 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test Erlenmeyer flask 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test mammalian plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test mammalian plate 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial plate 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test incubator incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test incubator incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test incubator incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test water sample flask (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test tall mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test short mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test Erlenmeyer flask 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test Erlenmeyer flask 5 (open) (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test insect plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate with stowaways (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test Omni tray 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate with water sample (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test uncovered plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test gas plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test 14mL Falcon Tube (for ExperimentIncubateCells)" <> $SessionUUID,

						"Test plate in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID,

						"Test flask for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test flask for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test plate for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test flask for quantification 3 (for ExperimentIncubateCells)" <> $SessionUUID
					},
					FastTrack -> True
				];
				{
					cover1,
					cover2,
					cover3,
					cover4,
					cover5,
					cover6,
					cover7,
					cover8,
					cover8b,
					cover8c,
					cover9,
					cover10,
					cover11,
					cover12,
					(* note that 13 is skipped on purpose because that corresponds to the uncovered emptyContainer13 *)
					cover14,
					cover15,
					cover16,
					cover17,
					cover19,
					cover20,
					(* note that 18 is skipped on purpose because that corresponds to the uncovered emptyContainer18 *)

					tooManySamplesCover1,
					tooManySamplesCover2,
					tooManySamplesCover3,
					tooManySamplesCover4,
					tooManySamplesCover5,
					tooManySamplesCover6,
					tooManySamplesCover7,
					tooManySamplesCover8,
					tooManySamplesCover9,
					tooManySamplesCover10,
					tooManySamplesCover11,
					tooManySamplesCover12,
					tooManySamplesCover13,
					tooManySamplesCover14,
					tooManySamplesCover15,
					tooManySamplesCover16,
					tooManySamplesCover17,

					quantCover1,
					quantCover2,
					quantCover3,
					quantCover4,
					quantCover5
				} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Cap, "50 mL tube cap"],
						Model[Item, Cap, "50 mL tube cap"],
						Model[Item, Cap, "Nalgene carboy cap, 83 mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, PlateSeal, "Plate Seal, 96-Well Square"],
						Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Cap, "id:AEqRl954GGOd"],(*15 mL tube cap*)

						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],

						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, PlateSeal, "Plate Seal, 96-Well Square"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Cover 1 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 2 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 3 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 4 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 5 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 6 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 7 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 8 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 8b for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 8c for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID,
						(* see comment above for why 13 was skipped*)
						"Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 19 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 20 for ExperimentIncubateCells tests " <> $SessionUUID,
						(* see comment above for why 18 was skipped*)

						"Test lid in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test lid in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID,

						"Test cover for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test cover for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test cover for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test cover for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test cover for quantification tests 5 (for ExperimentIncubateCells)" <> $SessionUUID
					}
				];
				UploadCover[
					{
						emptyContainer1,
						emptyContainer2,
						emptyContainer3,
						emptyContainer4,
						emptyContainer5,
						emptyContainer6,
						emptyContainer7,
						emptyContainer8, 
						emptyContainer8b, 
						emptyContainer8c,
						emptyContainer9,
						emptyContainer10,
						emptyContainer11,
						emptyContainer12,
						emptyContainer14,
						emptyContainer15,
						emptyContainer16,
						emptyContainer17,
						emptyContainer19,
						emptyContainer20,
						tooManySamplesContainer1,
						tooManySamplesContainer2,
						tooManySamplesContainer3,
						tooManySamplesContainer4,
						tooManySamplesContainer5,
						tooManySamplesContainer6,
						tooManySamplesContainer7,
						tooManySamplesContainer8,
						tooManySamplesContainer9,
						tooManySamplesContainer10,
						tooManySamplesContainer11,
						tooManySamplesContainer12,
						tooManySamplesContainer13,
						tooManySamplesContainer14,
						tooManySamplesContainer15,
						tooManySamplesContainer16,
						tooManySamplesContainer17,
						quantContainer1,
						quantContainer2,
						quantContainer3,
						quantContainer4,
						quantContainer5
					},
					Cover -> {
						cover1,
						cover2,
						cover3,
						cover4,
						cover5,
						cover6,
						cover7,
						cover8, 
						cover8b, 
						cover8c,
						cover9,
						cover10,
						cover11,
						cover12,
						cover14,
						cover15,
						cover16,
						cover17,
						cover19,
						cover20,
						tooManySamplesCover1,
						tooManySamplesCover2,
						tooManySamplesCover3,
						tooManySamplesCover4,
						tooManySamplesCover5,
						tooManySamplesCover6,
						tooManySamplesCover7,
						tooManySamplesCover8,
						tooManySamplesCover9,
						tooManySamplesCover10,
						tooManySamplesCover11,
						tooManySamplesCover12,
						tooManySamplesCover13,
						tooManySamplesCover14,
						tooManySamplesCover15,
						tooManySamplesCover16,
						tooManySamplesCover17,
						quantCover1,
						quantCover2,
						quantCover3,
						quantCover4,
						quantCover5
					}
				];
				(* Create some bacteria and mammalian models *)
				bacteriaModel = UploadSampleModel[
					"Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];
				(* Create some bacteria and mammalian models *)
				deprecatedBacteriaModel = UploadSampleModel[
					"Bacterial cells Deprecated Model (for ExperimentIncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];
				mammalianModel = UploadSampleModel[
					"Mammalian cells Model (for ExperimentIncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Mammalian,
					CultureAdhesion -> Adherent,
					Living -> True
				];
				solidMediaBacteriaModel = UploadSampleModel[
					"Solid Media Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> SolidMedia,
					Living -> True
				];
				(* Create some bacteria and mammalian samples *)
				{
					discardedBacteriaSample1,
					bacteriaSample2,
					bacteriaModelSeveredSample3,
					mammalianSample1,
					mammalianSample2,
					bacteriaSample4,
					bacteriaSample4b,
					bacteriaSample5,
					bacteriaSample5b,
					bacteriaSample5c,
					bacteriaSample6,
					waterSample1,
					mammalianSample3,
					mammalianSample4,
					deprecatedBacteriaSample,
					openSample,
					insectSample,
					sampleInSamePlate1,
					sampleInSamePlate2,
					solidMediaSample1,
					waterSample2,
					bacteriaSample7,
					gasSample,
					bacterialSample20,

					tooManySamplesSample1,
					tooManySamplesSample2,
					tooManySamplesSample3,
					tooManySamplesSample4,
					tooManySamplesSample5,
					tooManySamplesSample6,
					tooManySamplesSample7,
					tooManySamplesSample8,
					tooManySamplesSample9,
					tooManySamplesSample10,
					tooManySamplesSample11,
					tooManySamplesSample12,
					tooManySamplesSample13,
					tooManySamplesSample14,
					tooManySamplesSample15,
					tooManySamplesSample16,
					tooManySamplesSample17,

					quantSample1,
					quantSample2,
					quantSample3,
					quantSample4,
					quantSample5
				} = ECL`InternalUpload`UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						mammalianModel,
						mammalianModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						Model[Sample, "Milli-Q water"],
						mammalianModel,
						mammalianModel,
						deprecatedBacteriaModel,
						bacteriaModel,
						(* I'd prefer to use a better model here but for now we don't have any; feel free to change this in the future *)
						Model[Sample, "Insect cell membrane pellet"],
						bacteriaModel,
						bacteriaModel,
						solidMediaBacteriaModel,
						Model[Sample, "Milli-Q water"],
						bacteriaModel,
						Model[Sample, "Methane gas (Research grade)"],
						bacteriaModel,

						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						bacterialSampleModelWithCurve,
						bacterialSampleModelWithCurve,
						bacterialSampleModelWithCurve,
						bacterialSampleModelWithCurve,
						bacterialSampleModelWithCurve
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", emptyContainer3},
						{"A1", emptyContainer4},
						{"A1", emptyContainer5},
						{"A1", emptyContainer6},
						{"B1", emptyContainer6},
						{"A1", emptyContainer7},
						{"A1", emptyContainer8},
						{"A1", emptyContainer8b},
						{"A1", emptyContainer8c},
						{"A1", emptyContainer9},
						{"A1", emptyContainer10},
						{"A1", emptyContainer11},
						{"A1", emptyContainer12},
						{"A1", emptyContainer13},
						{"A1", emptyContainer14},
						{"A1", emptyContainer15},
						{"A2", emptyContainer15},
						{"A1", emptyContainer16},
						{"A1", emptyContainer17},
						{"A1", emptyContainer18},
						{"A1", emptyContainer19},
						{"A1", emptyContainer20},

						{"A1", tooManySamplesContainer1},
						{"A1", tooManySamplesContainer2},
						{"A1", tooManySamplesContainer3},
						{"A1", tooManySamplesContainer4},
						{"A1", tooManySamplesContainer5},
						{"A1", tooManySamplesContainer6},
						{"A1", tooManySamplesContainer7},
						{"A1", tooManySamplesContainer8},
						{"A1", tooManySamplesContainer9},
						{"A1", tooManySamplesContainer10},
						{"A1", tooManySamplesContainer11},
						{"A1", tooManySamplesContainer12},
						{"A1", tooManySamplesContainer13},
						{"A1", tooManySamplesContainer14},
						{"A1", tooManySamplesContainer15},
						{"A1", tooManySamplesContainer16},
						{"A1", tooManySamplesContainer17},

						{"A1", quantContainer1},
						{"A1", quantContainer2},
						{"A1", quantContainer3},
						{"A1", quantContainer4},
						{"A1", quantContainer5}
					},
					InitialAmount -> {
						10 Milliliter,
						100 Milliliter,
						100 Milliliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						10 Milliliter,
						10 Milliliter,
						30 Milliliter,
						100 Milliliter,
						100 Milliliter,
						1.5 Milliliter,
						50 Microliter,
						100 Milliliter,
						100 Milliliter,
						1 Gram,
						100 Microliter,
						100 Microliter,
						2 Gram,
						100 Microliter,
						100 Microliter,
						Null,
						10 Milliliter,

						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,

						30 Milliliter,
						100 Milliliter,
						0.3 Milliliter,
						1 Milliliter,
						20 Milliliter
					},
					Name -> {
						"Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test tissue culture sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test 2nd bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test water sample (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test tissue culture sample in tall plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test tissue culture sample in short plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test deprecated sample (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in an open flask (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test insect cell (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test gas sample in plate (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID,

						"Test sample in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID,

						"Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID,
						"Test sample for quantification tests 5 (for ExperimentIncubateCells)" <> $SessionUUID
					}
				];

				(* Make all of our samples and models DeveloperObjects, give them their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
				Upload[{
					<|Object -> discardedBacteriaSample1, CellType -> Bacterial, CultureAdhesion -> Suspension, Status -> Discarded|>,
					<|Object -> bacteriaSample2, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaModelSeveredSample3, CellType -> Bacterial, CultureAdhesion -> Suspension, Model -> Null|>,
					<|Object -> mammalianSample1, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> mammalianSample2, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> bacteriaSample4, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample4b, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample5, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample5b, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample5c, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample6, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> mammalianSample3, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> mammalianSample4, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> deprecatedBacteriaModel, CellType -> Bacterial, CultureAdhesion -> Suspension, Deprecated -> True|>,
					<|Object -> insectSample, CultureAdhesion -> Suspension|>,
					<|Object -> solidMediaSample1, CultureAdhesion -> SolidMedia, State -> Solid, CellType -> Bacterial|>,
					<|Object -> bacterialSample20, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> quantSample1, CultureAdhesion -> Suspension, CellType -> Bacterial, Solvent -> Link[Model[Sample, "Milli-Q water"]]|>,
					<|Object -> quantSample2, CultureAdhesion -> Suspension, CellType -> Bacterial, Solvent -> Link[Model[Sample, "Milli-Q water"]]|>,
					<|Object -> quantSample3, CultureAdhesion -> Suspension, CellType -> Bacterial, Solvent -> Link[Model[Sample, "Milli-Q water"]]|>,
					<|Object -> quantSample4, CultureAdhesion -> Suspension, CellType -> Bacterial, Solvent -> Link[Model[Sample, "Milli-Q water"]]|>,
					<|Object -> quantSample5, CultureAdhesion -> Suspension, CellType -> Bacterial, Solvent -> Link[Model[Sample, "Milli-Q water"]]|>
				}];

				mcpParentProt1 = ExperimentManualCellPreparation[
					{
						IncubateCells[Sample -> Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]]
					},
					Name -> "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID
				]

			]
		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[
			{
				existsFilter, allObjs
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentIncubateCells tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test incubator incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test water sample flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test tall mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 5 (open) (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test insect plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate with stowaways (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test Omni tray 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate with water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test uncovered plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test gas plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test 14mL Falcon Tube (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test 2nd bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test water sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in tall plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in short plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test deprecated sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in an open flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test insect cell (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample 1 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample 2 sharing a plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test solid media bacteria sample 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test gas sample in plate (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in falcon tube (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Deprecated Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Solid Media Bacterial cells Model (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, Incubator, "Test incubator instrument object (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Cover 1 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 2 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 3 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 4 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 5 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 6 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 7 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8b for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 8c for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID],
				(* note I skipped 13 on purpose here because it is for the uncovered container *)
				Object[Item, Lid, "Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 19 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 20 for ExperimentIncubateCells tests " <> $SessionUUID],

				Object[Sample, "Test sample in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 5 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 6 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 7 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 8 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 9 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 10 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 11 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 12 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 13 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 14 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 15 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 16 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test lid in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID],

				Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID],
				Model[Cell, "Test cell model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Sample, "Test cell sample model 1 with absorbance standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, PlateReader, "Test PlateReader 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Instrument, PlateReader, "Test PlateReader 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Model[Instrument, PlateReader, "Test non-BMG Plate Reader model (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Analysis, StandardCurve, "Test OD600 to Cell/mL standard curve (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Protocol, AbsorbanceIntensity, "Test AbsorbanceIntensity protocol 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test flask for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Vessel, "Test flask for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate for quantification 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Container, Plate, "Test plate for quantification 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Test cover for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Cap, "Test cover for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, Lid, "Test cover for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Item, PlateSeal, "Test cover for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 3 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test sample for quantification tests 4 (for ExperimentIncubateCells)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[PickList[allObjs, existsFilter], Force -> True, Verbose -> False];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];


(* ::Subsubsection::Closed:: *)

(* ::Section:: *)
(* Sister functions *)


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCellsOptions*)

DefineTests[ExperimentIncubateCellsOptions,
	{
		Example[{Basic, "Return the resolved options:"},
			ExperimentIncubateCellsOptions[{
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID],
				Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID]
			}],
			Graphics_
		],
		Example[{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentIncubateCellsOptions[{
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID]
			}],
			Graphics_,
			Messages :> {Error::InvalidPlateSamples, Error::InvalidInput}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentIncubateCellsOptions[
				{
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID]
				},
				OutputFormat -> List
			],
			Rule___
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True]; Unset[$CreatedObjects]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{
				existsFilter, allObjs
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentIncubateCellsOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsOptions)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[PickList[allObjs, existsFilter], Force -> True, Verbose -> False];
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, bacteriaModel, mammalianModel, emptyContainer1, emptyContainer2, emptyContainer3,
					cover1, cover2, cover3
				},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentIncubateCellsOptions tests" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* Create some empty containers *)
				{
					emptyContainer1,
					emptyContainer2,
					emptyContainer3
				} = UploadSample[
					{
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test 250mL flask 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test short bacterial plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID
					}
				];

				(* Create test covers *)
				{
					cover1,
					cover2,
					cover3
				} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Cover 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test Cover 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test Cover 3 for ExperimentIncubateCellsOptions tests " <> $SessionUUID
					}
				];

				(* Cover the containers *)
				UploadCover[
					{
						emptyContainer1,
						emptyContainer2,
						emptyContainer3
					},
					Cover -> {
						cover1,
						cover2,
						cover3
					}
				];

				(* Create some bacteria and mammalian models *)
				bacteriaModel = UploadSampleModel[
					"Bacterial cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];
				mammalianModel = UploadSampleModel["Mammalian cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Mammalian,
					CultureAdhesion -> Adherent,
					Living -> True
				];
				(* Create some bacteria and mammalian samples *)
				ECL`InternalUpload`UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						mammalianModel,
						mammalianModel
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", emptyContainer3},
						{"B1", emptyContainer3}

					},
					InitialAmount -> {
						100 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID,
						"Test bacterial sample in plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID,
						"Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID,
						"Test tissue culture sample 2 (for ExperimentIncubateCellsOptions)" <> $SessionUUID
					}
				];
			]
		];
	),
	SymbolTearDown :> (
		Module[
			{namedObjects, allObjects, existingObjs},

			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentIncubateCellsOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsOptions)" <> $SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];

			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCellsPreview*)

DefineTests[ExperimentIncubateCellsPreview,
	{
		Example[{Basic, "Returns Null:"},
			ExperimentIncubateCellsPreview[{
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
				Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID]
			}],
			Null
		],
		Example[{Basic, "Even if an input is invalid, returns Null:"},
			ExperimentIncubateCellsPreview[{
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID]
			}],
			Null,
			Messages :> {Error::InvalidPlateSamples, Error::InvalidInput}
		],
		Example[{Basic, "Even if an option is invalid, returns Null:"},
			ExperimentIncubateCellsPreview[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID]
				},
				CellType -> {Mammalian, Bacterial}
			],
			Null,
			Messages :> {
				Error::ConflictingCellType,
				Error::UnsupportedCellCultureType,
				Error::InvalidOption
			}
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True]; Unset[$CreatedObjects]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{
				existsFilter, allObjs
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentIncubateCellsPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsPreview)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[PickList[allObjs, existsFilter], Force -> True, Verbose -> False];
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, bacteriaModel, mammalianModel, emptyContainer1, emptyContainer2, emptyContainer3,
					cover1, cover2, cover3
				},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentIncubateCellsPreview tests" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* Create some empty containers *)
				{
					emptyContainer1,
					emptyContainer2,
					emptyContainer3
				} = UploadSample[
					{
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test 250mL flask 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test short bacterial plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID
					}
				];

				(* Create test covers *)
				{
					cover1,
					cover2,
					cover3
				} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Cover 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test Cover 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test Cover 3 for ExperimentIncubateCellsPreview tests " <> $SessionUUID
					}
				];

				(* Cover the containers *)
				UploadCover[
					{
						emptyContainer1,
						emptyContainer2,
						emptyContainer3
					},
					Cover -> {
						cover1,
						cover2,
						cover3
					}
				];

				(* Create some bacteria and mammalian models *)
				bacteriaModel = UploadSampleModel[
					"Bacterial cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];
				mammalianModel = UploadSampleModel["Mammalian cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Mammalian,
					CultureAdhesion -> Adherent,
					Living -> True
				];
				(* Create some bacteria and mammalian samples *)
				ECL`InternalUpload`UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						mammalianModel,
						mammalianModel
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", emptyContainer3},
						{"B1", emptyContainer3}

					},
					InitialAmount -> {
						100 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID,
						"Test bacterial sample in plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID,
						"Test tissue culture sample 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID,
						"Test tissue culture sample 2 (for ExperimentIncubateCellsPreview)" <> $SessionUUID
					}
				];
			]
		];
	),
	SymbolTearDown :> (
		Module[
			{namedObjects, allObjects, existingObjs},

			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentIncubateCellsPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Container, Plate, "Test short bacterial plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsPreview)" <> $SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];

			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			Unset[$CreatedObjects];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentIncubateCellsQ*)

DefineTests[ValidExperimentIncubateCellsQ,
	{
		Example[{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidExperimentIncubateCellsQ[
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
				}
			],
			True
		],
		Example[{Basic, "If an input is invalid, returns False:"},
			ValidExperimentIncubateCellsQ[
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test empty plate (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
				}
			],
			False
		],
		Example[{Basic, "If an option is invalid, returns False:"},
			ValidExperimentIncubateCellsQ[
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
				},
				CellType -> {Mammalian, Bacterial},
				Name -> "Existing ValidExperimentIncubateCellsQ protocol"
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidExperimentIncubateCellsQ[
				{
					Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
				},
				Name -> "Existing ValidExperimentIncubateCellsQ protocol",
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentIncubateCellsQ[{
				Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
			},
				Name -> "Existing ValidExperimentIncubateCellsQ protocol",
				Verbose -> True
			],
			BooleanP
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		$CreatedObjects = {};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[
			{
				allObjects, existsFilter, testBench, bacteriaModel, mammalianModel, emptyContainer1, emptyContainer2, emptyContainer3,
				emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, cover1, cover2, cover3, cover4,
				cover5, cover6, cover7, cover8, discardedBacteriaSample1, bacteriaSample2, bacteriaModelSeveredSample3, mammalianSample1,
				mammalianSample2, bacteriaSample4, bacteriaSample5
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjects = Quiet[Cases[{
				Object[Container, Bench, "Test bench (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test bacterial plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Container, Plate, "Test empty plate (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Cap, "Test cover 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Cap, "Test cover 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Cap, "Test cover 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 4 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 5 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 6 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 7 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 8 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test discarded sample (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test model severed sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
			}, ObjectP[]]];

			existsFilter = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existsFilter, Force -> True, Verbose -> False];

			Block[{$DeveloperUpload = True, $AllowPublicObjects = True},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				(* Create some empty containers *)
				{
					emptyContainer1,
					emptyContainer2,
					emptyContainer3,
					emptyContainer4,
					emptyContainer5,
					emptyContainer6,
					emptyContainer7,
					emptyContainer8
				} = UploadSample[
					{
						Model[Container, Vessel, "250mL Erlenmeyer Flask"],
						Model[Container, Vessel, "250mL Erlenmeyer Flask"],
						Model[Container, Vessel, "1000mL Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "384-well Optical Reaction Plate"]
					},
					ConstantArray[{"Work Surface", testBench}, 8],
					Name -> {
						"Test Erlenmeyer flask 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test Erlenmeyer flask 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test Erlenmeyer flask 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test mammalian plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test bacterial plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test bacterial plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test empty plate (for ValidExperimentIncubateCellsQ)" <> $SessionUUID
					}
				];

				(* Create some covers *)
				{cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "Universal Clear Lid"]
					},
					ConstantArray[{"Work Surface", testBench}, 8],
					Name -> {
						"Test cover 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 4 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 5 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 6 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 7 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test cover 8 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID
					}
				];

				(* Create some bacteria and mammalian models *)
				{bacteriaModel, mammalianModel} = UploadSampleModel[
					{
						"Bacterial cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Mammalian cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID
					},
					Composition -> {
         		{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Mammalian},
					CultureAdhesion -> {Suspension, Adherent},
					Living -> True
				];

				(* Create some bacteria and mammalian samples *)
				{
					discardedBacteriaSample1,
					bacteriaSample2,
					bacteriaModelSeveredSample3,
					mammalianSample1,
					mammalianSample2,
					bacteriaSample4,
					bacteriaSample5
				} = UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						bacteriaModel,
						mammalianModel,
						mammalianModel,
						bacteriaModel,
						bacteriaModel
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", emptyContainer3},
						{"A1", emptyContainer4},
						{"A1", emptyContainer5},
						{"A1", emptyContainer6},
						{"A1", emptyContainer7}
					},
					InitialAmount -> {
						1 Milliliter,
						100 Milliliter,
						100 Milliliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter
					},
					Name -> {
						"Test discarded sample (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test bacteria sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test model severed sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test tissue culture sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test bacterial sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID,
						"Test bacterial sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID
					}
				];

				(* Make all of our samples  their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
				Upload[{
					<|Object -> discardedBacteriaSample1, CellType -> Bacterial, CultureAdhesion -> Suspension, Status -> Discarded|>,
					<|Object -> bacteriaSample2, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaModelSeveredSample3, CellType->Bacterial, CultureAdhesion -> Suspension, Model -> Null|>,
					<|Object -> mammalianSample1, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> mammalianSample2, CellType -> Mammalian, CultureAdhesion -> Adherent|>,
					<|Object -> bacteriaSample4, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> bacteriaSample5, CellType -> Bacterial, CultureAdhesion -> Suspension|>
				}];

				UploadCover[
					{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8},
					Cover -> {cover1, cover2, cover3, cover4, cover5, cover6, cover7, cover8}
				]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjs},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					Object[Container, Bench, "Test bench (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Vessel, "Test Erlenmeyer flask 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Vessel, "Test Erlenmeyer flask 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Vessel, "Test Erlenmeyer flask 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test mammalian plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test bacterial plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Container, Plate, "Test empty plate (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Cap, "Test cover 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Cap, "Test cover 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Cap, "Test cover 3 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 4 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 5 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 6 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 7 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 8 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test discarded sample (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test model severed sample in flask (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 1 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 2 (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for ValidExperimentIncubateCellsQ)" <> $SessionUUID]
			}], ObjectP[]]];

			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices*)

DefineTests[IncubateCellsDevices,
	{
		Example[{Basic, "Find all incubators that can be used to incubate input model container with the desired settings:"},
			IncubateCellsDevices[Model[Container, Vessel, "250mL Erlenmeyer Flask"]],
			{
				Model[Instrument, Incubator, "id:AEqRl954GG0l"],
				Model[Instrument, Incubator, "id:D8KAEvdqzXok"],
				Model[Instrument, Incubator, "id:rea9jl1orkAx"]
			}
		],
		Example[{Basic, "Find all incubators that can be used to incubate input sample with the desired settings:"},
			IncubateCellsDevices[
				{
					Object[Sample, "Test bacteria sample in flask (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Container, Plate, "Test tall mammalian plate (for IncubateCellsDevices)" <> $SessionUUID]
				}
			],
			{{ObjectP[Model[Instrument, Incubator]]...}...}
		],
		Example[{Basic, "Accept no input:"},
			IncubateCellsDevices[Temperature -> 37 Celsius],
			{{ObjectP[Model[Instrument, Incubator]], {ObjectP[{Model[Container]}]..}}..}
		],
		Example[{Basic, "Find all incubators and corresponding containers for specified IncubationCondition:"},
			IncubateCellsDevices[Model[StorageCondition, "Mammalian Incubation"]],
			{{ObjectP[Model[Instrument, Incubator]], {ObjectP[Model[Container]]..}}..}
		],
		Example[{Basic, "Find all incubators and corresponding containers:"},
			IncubateCellsDevices[All],
			{{ObjectP[Model[Instrument, Incubator]], {ObjectP[Model[Container]]..}}..}
		],
		Example[{Additional, "Find all incubators that can be used to incubate mixed inputs with the desired settings:"},
			IncubateCellsDevices[
				{
				Model[Container, Vessel, "1000mL Erlenmeyer Flask"],
				Object[Sample, "Test bacteria sample in flask (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Container, Plate, "Test tall mammalian plate (for IncubateCellsDevices)" <> $SessionUUID],
				Model[StorageCondition, "Mammalian Incubation"]
			}
			],
			{
				{ObjectP[Model[Instrument, Incubator]]...},
				{ObjectP[Model[Instrument, Incubator]]...},
				{ObjectP[Model[Instrument, Incubator]]...},
				{{ObjectP[Model[Instrument, Incubator]], {ObjectP[Model[Container]]..}}..}
			}
		],
		Example[{Additional, "Find an incubator that can accept a Falcon tube in one of multiple racks on its deck:"},
			IncubateCellsDevices[Model[Container, Vessel, "id:AEqRl9KXBDoW"]],(*"Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap"*)
			{ObjectP[Model[Instrument, Incubator]]..}
		],
		Example[{Additional, "If no incubators can be found to incubate the given container model, returns an empty list:"},
			IncubateCellsDevices[Model[Container, Vessel, VolumetricFlask, "Volumetric flask, 500 ml"]],
			{}
		],
		Example[{Additional, "If no incubators can be found to incubate the given input at the desired settings, returns an empty list:"},
			IncubateCellsDevices[Model[Container, Vessel, "50mL Tube"], Temperature -> 75 Celsius, Shake -> True],
			{}
		],
		Example[{Additional, "If no incubators can be found to incubate at the desired settings, returns an empty list:"},
			IncubateCellsDevices[Temperature -> 75 Celsius, Shake -> True, ShakingRate -> 3200 RPM, CarbonDioxide -> 15 Percent, CellType -> Mammalian],
			{}
		],
		Example[{Additional, "If a list of settings is specified, provides the incubators and associated containers that can meet each setting in the list:"},
			IncubateCellsDevices[Temperature -> {40 Celsius, 30 Celsius}],
			{
				{{ObjectP[Model[Instrument, Incubator]], {ObjectP[{Model[Container]}]..}}..}..
			}
		],
		Example[{Additional, "If CultureAdhesion is specified as SolidMedia, do not include the robotic plate incubator and default shaking ones as they cannot handle inverted agar plates:"},
			IncubateCellsDevices[Model[Container, Plate, "Omni Tray Sterile Media Plate"], CellType -> Bacterial, CultureAdhesion -> SolidMedia],
			(* Check that the output does not have the shaking one and the robotic one *)
			{Except[ObjectP[{Model[Instrument, Incubator, "id:N80DNjlYwELl"], Model[Instrument, Incubator, "id:AEqRl954Gpjw"]}]]..}
			(*{"STX44-ICBT with Shaking", "Innova 44 for Bacterial Plates"}*)
		],
		Example[{Messages, "OptionLengthDisagreement", "If options don't match in length, return $Failed:"},
			IncubateCellsDevices[ShakingRate -> {600 RPM, 180 RPM, 2000 RPM}, Temperature -> {40 Celsius, 30 Celsius}],
			$Failed,
			Messages :> {Error::OptionLengthDisagreement}
		],
		Example[{Messages, "ConflictingIncubationConditionWithOptions", "If options don't match Value in specified IncubationCondition, return $Failed:"},
			IncubateCellsDevices[Model[StorageCondition, "Mammalian Incubation"], Temperature -> 30 Celsius],
			$Failed,
			Messages :> {Error::ConflictingIncubationConditionWithOptions}
		],
		Example[{Options, Temperature, "Find incubators that will work with the desired temperatures:"},
			IncubateCellsDevices[
				{
					Model[Container, Vessel, "1000mL Erlenmeyer Flask"],
					Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]
				},
				Temperature -> {30 Celsius, Automatic}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, ShakingRate, "Find incubators that will work with the desired rate or radius:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				ShakingRate -> {400 RPM, 180 RPM, 2000 RPM}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, ShakingRadius, "Find incubators that will work with the desired shaking radius:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				ShakingRadius -> {3 Millimeter, 25 Millimeter, 25.4 Millimeter}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, Shake, "Find incubators that will work with the desired shaking:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				Shake -> {True, False}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, CellType, "Find incubators that will work with the desired cell type options:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				CellType -> {Mammalian, Bacterial, Yeast}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, CultureAdhesion, "Find incubators that will work with the desired cell culture type options:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				CultureAdhesion -> {Suspension, Adherent, SolidMedia}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, CarbonDioxide, "Find incubators that will work with the desired carbon dioxide options:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				CarbonDioxide -> {5 Percent, Ambient, 10 Percent}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, RelativeHumidity, "Find incubators that will work with the desired relative humidity options:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				RelativeHumidity -> {50 Percent, 93 Percent, Ambient}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		$CreatedObjects = {};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[
			{
				allObjects, existsFilter, testBench, bacteriaModel, mammalianModel, emptyContainer1, emptyContainer2, cover1,
				cover2, mammalianSample, bacteriaSample
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjects = Quiet[Cases[{
				Object[Container, Bench, "Test bench (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Container, Vessel, "Test Erlenmeyer flask (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Container, Plate, "Test tall mammalian plate (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Item, Cap, "Test cover 2 (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Item, Lid, "Test cover 1 (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in tall plate (for IncubateCellsDevices)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for IncubateCellsDevices)" <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for IncubateCellsDevices)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for IncubateCellsDevices)" <> $SessionUUID]
			}, ObjectP[]]];

			existsFilter = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existsFilter, Force -> True, Verbose -> False];

			Block[{$DeveloperUpload = True, $AllowPublicObjects = True},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench (for IncubateCellsDevices)" <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				(* Create some empty containers *)
				{
					emptyContainer1,
					emptyContainer2
				} = UploadSample[
					{
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "250mL Erlenmeyer Flask"]
					},
					ConstantArray[{"Work Surface", testBench}, 2],
					Name -> {
						"Test tall mammalian plate (for IncubateCellsDevices)" <> $SessionUUID,
						"Test Erlenmeyer flask (for IncubateCellsDevices)" <> $SessionUUID
					}
				];

				(* Create some covers *)
				{cover1, cover2} = UploadSample[
					{
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"]
					},
					ConstantArray[{"Work Surface", testBench}, 2],
					Name -> {
						"Test cover 1 (for IncubateCellsDevices)" <> $SessionUUID,
						"Test cover 2 (for IncubateCellsDevices)" <> $SessionUUID
					}
				];

				(* Create some bacteria and mammalian models *)
				{bacteriaModel, mammalianModel} = UploadSampleModel[
					{
						"Bacterial cells Model (for IncubateCellsDevices)" <> $SessionUUID,
						"Mammalian cells Model (for IncubateCellsDevices)" <> $SessionUUID
					},
					Composition -> {
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
						{{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}}
					},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> {Bacterial, Mammalian},
					CultureAdhesion -> {Suspension, Adherent},
					Living -> True
				];

				(* Create some bacteria and mammalian samples *)
				{
					mammalianSample,
					bacteriaSample
				} = UploadSample[
					{
						mammalianModel,
						bacteriaModel
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2}
					},
					InitialAmount -> {
						1 Milliliter,
						100 Milliliter
					},
					Name -> {
						"Test tissue culture sample in tall plate (for IncubateCellsDevices)" <> $SessionUUID,
						"Test bacteria sample in flask (for IncubateCellsDevices)" <> $SessionUUID
					}
				];

				(* Make all of our samples  their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
				Upload[{
					<|Object -> bacteriaSample, CellType -> Bacterial, CultureAdhesion -> Suspension|>,
					<|Object -> mammalianSample, CellType -> Mammalian, CultureAdhesion -> Adherent|>
				}];

				UploadCover[{emptyContainer1, emptyContainer2}, Cover -> {cover1, cover2}]
			]
		];
	),
	SymbolTearDown :> (
		Module[{allObjects, existingObjs},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					Object[Container, Bench, "Test bench (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Container, Vessel, "Test Erlenmeyer flask (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Container, Plate, "Test tall mammalian plate (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Item, Cap, "Test cover 2 (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Item, Lid, "Test cover 1 (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample in tall plate (for IncubateCellsDevices)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for IncubateCellsDevices)" <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for IncubateCellsDevices)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for IncubateCellsDevices)" <> $SessionUUID]
				}], ObjectP[]]];

			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsubsection::Closed:: *)
(*IncubateCells*)
DefineTests[IncubateCells,
	{
		Example[
			{Basic,"Incubate a single bacterial sample in a flask:"},
			Experiment[{
				IncubateCells[Sample -> Object[Sample, "Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID]]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Incubate a single mammalian sample in a plate at 37 Celsius:"},
			Experiment[{
				IncubateCells[
					Sample -> Object[Sample, "Test tissue culture sample 1 (for IncubateCells)" <> $SessionUUID],
					Temperature -> 37 Celsius
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Incubate multiple samples:"},
			Experiment[{
				IncubateCells[
					Sample -> {
						Object[Sample, "Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID],
						Object[Sample, "Test bacterial sample in plate 1 (for IncubateCells)" <> $SessionUUID],
						Object[Sample, "Test tissue culture sample 2 (for IncubateCells)" <> $SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic,"Incubate a single bacterial sample in a flask with custom conditions:"},
			Experiment[{
				IncubateCells[
					Sample -> Object[Sample, "Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID],
					Temperature -> 41 Celsius,
					ShakingRate -> 350 RPM
				]
			}],
			ObjectP[Object[Protocol]]
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[$CreatedObjects, Force -> True]; Unset[$CreatedObjects]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{
				existsFilter, allObjs
			},
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			allObjs = {
				Object[Container, Bench, "Test bench for IncubateCells tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 250mL flask 1 for IncubateCells tests " <> $SessionUUID],
				Object[Container, Plate, "Test DWP 1 for IncubateCells tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 1 for IncubateCells tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 2 for IncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Test Cover 1 for IncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 2 for IncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 3 for IncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 4 for IncubateCells tests " <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for IncubateCells)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for IncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for IncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for IncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 2 (for IncubateCells)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[
				PickList[
					allObjs,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			];
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, bacteriaModel, mammalianModel,
					emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4,
					cover1, cover2, cover3, cover4
				},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for IncubateCells tests" <> $SessionUUID,
					Site -> Link[$Site],
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* Create some empty containers *)
				{
					emptyContainer1,
					emptyContainer2,
					emptyContainer3,
					emptyContainer4
				} = UploadSample[
					{
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test 250mL flask 1 for IncubateCells tests " <> $SessionUUID,
						"Test DWP 1 for IncubateCells tests " <> $SessionUUID,
						"Test short mammalian plate 1 for IncubateCells tests " <> $SessionUUID,
						"Test short mammalian plate 2 for IncubateCells tests " <> $SessionUUID
					}
				];

				(* Create test covers *)
				{
					cover1,
					cover2,
					cover3,
					cover4
				} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "Universal Clear Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Cover 1 for IncubateCells tests " <> $SessionUUID,
						"Test Cover 2 for IncubateCells tests " <> $SessionUUID,
						"Test Cover 3 for IncubateCells tests " <> $SessionUUID,
						"Test Cover 4 for IncubateCells tests " <> $SessionUUID
					}
				];

				(* Cover the containers *)
				UploadCover[
					{
						Object[Container, Vessel, "Test 250mL flask 1 for IncubateCells tests " <> $SessionUUID],
						Object[Container, Plate, "Test DWP 1 for IncubateCells tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 1 for IncubateCells tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 2 for IncubateCells tests " <> $SessionUUID]
					},
					Cover -> {
						cover1,
						cover2,
						cover3,
						cover4
					}
				];

				(* Create some bacteria and mammalian models *)
				bacteriaModel = UploadSampleModel[
					"Bacterial cells Model (for IncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];
				mammalianModel = UploadSampleModel["Mammalian cells Model (for IncubateCells)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Mammalian, "HeLa"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Mammalian,
					CultureAdhesion -> Adherent,
					Living -> True
				];
				(* Create some bacteria and mammalian samples *)
				ECL`InternalUpload`UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						mammalianModel,
						mammalianModel
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", emptyContainer3},
						{"A1", emptyContainer4}

					},
					InitialAmount -> {
						100 Milliliter,
						1 Milliliter,
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID,
						"Test bacterial sample in plate 1 (for IncubateCells)" <> $SessionUUID,
						"Test tissue culture sample 1 (for IncubateCells)" <> $SessionUUID,
						"Test tissue culture sample 2 (for IncubateCells)" <> $SessionUUID
					}
				];
			]
		];
	),
	SymbolTearDown :> (
		Module[
			{namedObjects,allObjects,existingObjs},

			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for IncubateCells tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 250mL flask 1 for IncubateCells tests " <> $SessionUUID],
					Object[Container, Plate, "Test DWP 1 for IncubateCells tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 1 for IncubateCells tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for IncubateCells tests " <> $SessionUUID],
					Object[Item, Cap, "Test Cover 1 for IncubateCells tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 2 for IncubateCells tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for IncubateCells tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for IncubateCells tests " <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for IncubateCells)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for IncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for IncubateCells) " <> $SessionUUID],
					Object[Sample, "Test bacterial sample in plate 1 (for IncubateCells)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 1 (for IncubateCells)" <> $SessionUUID],
					Object[Sample, "Test tissue culture sample 2 (for IncubateCells)" <> $SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];

			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			Unset[$CreatedObjects];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];
