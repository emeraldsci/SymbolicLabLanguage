(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


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
		Test["If the protocol does not have a parent protocol and we're in a Robotic protocol, RoboticCellPrepration populates Overclock -> True in the protocol object:",
			Download[
				ExperimentIncubateCells[Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID], Preparation -> Robotic],
				Overclock
			],
			True
		],
		Test["If the protocol does have a parent protocol and we're in a Robotic protocol, RoboticCellPrepration populates Overclock -> True in the root protocol object:",
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
				Download[
					protocol,
					BatchedUnitOperations[{Object, SampleLink, Temperature, IncubationConditionExpression}]
				]
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
		Example[{Messages, "DiscardedSamples", "If the given samples are discarded, they cannot be incubated:"},
			ExperimentIncubateCells[Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "If the given samples have deprecated models, they cannot be incubated:"},
			ExperimentIncubateCells[Object[Sample, "Test deprecated sample (for ExperimentIncubateCells)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NoCompatibleIncubator", "If a sample is provided in a container incompatible with all incubators, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)"<> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NoCompatibleIncubator,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnsealedCellCultureVessels", "If a manual incubation is specified with an open container, an error is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test sample in an open flask (for ExperimentIncubateCells)" <> $SessionUUID], Preparation -> Manual
			],
			$Failed,
			Messages :> {
				Error::UnsealedCellCultureVessels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnsupportedCellTypes", "If an unsupported cell type is provided (not Bacterial, Mammalian, or Yeast), an error is thrown:"},
			ExperimentIncubateCells[
				Object[Sample, "Test insect cell (for ExperimentIncubateCells)" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::UnsupportedCellTypes,
				Error::NoCompatibleIncubator,
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
		Example[{Messages, "ConflictingUnitOperationMethodRequirements", "If one sample can only be done manually and one sample can only be done robotically, throw an error:"},
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
		Example[{Messages, "ConflictingWorkCells", "If one sample can only be done on the bioSTAR and another on the microbioSTAR, an error is thrown:"},
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
				Error::ConflictingWorkCells,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWorkCells", "If WorkCell is specified, it must not disagree with the sample type or the specified incubator:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"],
				Preparation -> Robotic,
				(* sample requires microbioSTAR because it's Bacterial *)
				WorkCell -> bioSTAR
			],
			$Failed,
			Messages :> {
				Error::ConflictingWorkCells,
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
		Example[{Messages, "ConflictingPreparationWithIncubationTime", "If Preparation is set to Robotic, then Time must not be greater than 1 hour:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Incubator -> Model[Instrument, Incubator, "STX44-ICBT with Shaking"],
				Preparation -> Robotic,
				Time -> 2 Hour
			],
			$Failed,
			Messages :> {
				Error::ConflictingPreparationWithIncubationTime,
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
		Example[{Messages, "ConflictingCellType", "If CellType options are provided, and they conflict with the CellType of the sample(s) specified, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Yeast
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellType,
				Error::InvalidOption
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
		Example[{Messages, "ConflictingShakingConditions", "If shaking options are provided, and they conflict with each other, throws an error and returns $Failed:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Shake -> False,
				ShakingRate -> 200 RPM
			],
			$Failed,
			Messages :> {
				Error::ConflictingShakingConditions,
				Error::NoCompatibleIncubator,
				Error::InvalidInput,
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
				Error::NoCompatibleIncubator,
				Error::ConflictingCultureAdhesionWithStorageCondition,
				Error::InvalidOption,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConflictingCellTypeWithIncubator", "If CellType is Mammalian, a Bacterial incubator cannot be specified:"},
			ExperimentIncubateCells[
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Mammalian,
				Incubator -> Model[Instrument, Incubator, "Innova 44 for Bacterial Plates"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellTypeWithIncubator,
				Error::ConflictingCellTypeWithStorageCondition,
				Error::NoCompatibleIncubator,
				Error::InvalidOption,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ConflictingCultureAdhesionWithContainer", "If samples are in a flask, CultureAdhesion can't be SolidMedia:"},
			ExperimentIncubateCells[
				Object[Sample, "Test water sample (for ExperimentIncubateCells)" <> $SessionUUID],
				CellType -> Bacterial,
				CultureAdhesion -> SolidMedia,
				Shake -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingCultureAdhesionWithContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCellTypeWithStorageCondition", "If samples are Mammalian, can't specify a Bacterial or Yeast SamplesOutStorageCondition (and vice versa):"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				SamplesOutStorageCondition -> MammalianIncubation
			],
			$Failed,
			Messages :> {
				Error::ConflictingCellTypeWithStorageCondition,
				Error::ConflictingCultureAdhesionWithStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCultureAdhesionWithStorageCondition", "If samples are Suspension, SamplesOutStorageCondition must include shaking:"},
			ExperimentIncubateCells[
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				(* wants to be BacterialShakingIncubation *)
				SamplesOutStorageCondition -> BacterialIncubation
			],
			$Failed,
			Messages :> {
				Error::ConflictingCultureAdhesionWithStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCultureAdhesionWithStorageCondition", "Note that solid media in refrigerator is allowed:"},
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
		Example[{Messages, "DuplicateSamples", "A sample cannot be specified more than one time in a given experiment call:"},
			ExperimentIncubateCells[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicateSamples,
				Error::InvalidInput
			}
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
		(* Options tests *)
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
					Name -> "my bacteria incubation"
				],
				Name
			],
			"my bacteria incubation"
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
			{EqualP[33 Celsius]},
			Messages :> {Warning::CustomIncubationConditionNotSpecified}
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
				Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test 2nd bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
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
				Object[Item, Cap, "Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID],
				(* note I skipped 13 on purpose here because it is for the uncovered container *)
				Object[Item, Lid, "Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID],

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

				Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID]
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
					cover12, cover14,
					deprecatedBacteriaModel, deprecatedBacteriaSample, cover16, solidMediaSample1, emptyContainer16,

					emptyContainer15, cover15, sampleInSamePlate1, sampleInSamePlate2, emptyContainer17, cover17, waterSample2,
					emptyContainer18, bacteriaSample7,

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

					mcpParentProt1
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
					emptyContainer12,
					emptyContainer13,
					emptyContainer14,
					emptyContainer15,
					emptyContainer16,
					emptyContainer17,
					emptyContainer18,

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
					tooManySamplesContainer17
				} = UploadSample[
					{
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "1L Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "384-well Optical Reaction Plate"],
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container,Vessel,"Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "Omni Tray Sterile Media Plate"],
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
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
						Model[Container, Plate, "96-well Greiner Tissue Culture Plate"]
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
						"Test plate in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID
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
					cover9,
					cover10,
					cover11,
					cover12,
					(* note that 13 is skipped on purpose because that corresponds to the uncovered emptyContainer13 *)
					cover14,
					cover15,
					cover16,
					cover17,
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
					tooManySamplesCover17
				} = UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Cap, "15 mL tube cap"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, PlateSeal, "Plate Seal, 96-Well Square"],
						Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "96 Well Greiner Plate Lid"],
						Model[Item, Lid, "Universal Clear Lid"],
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
						Model[Item, Lid, "96 Well Greiner Plate Lid"]
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
						"Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID,
						(* see comment above for why 13 was skipped*)
						"Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID,
						"Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID,
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
						"Test lid in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID
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
						emptyContainer9,
						emptyContainer10,
						emptyContainer11,
						emptyContainer12,
						emptyContainer14,
						emptyContainer15,
						emptyContainer16,
						emptyContainer17,
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
						tooManySamplesContainer17
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
						cover9,
						cover10,
						cover11,
						cover12,
						cover14,
						cover15,
						cover16,
						cover17,
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
						tooManySamplesCover17
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
					tooManySamplesSample17
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
						bacteriaModel
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
						{"A1", tooManySamplesContainer17}
					},
					InitialAmount -> {
						1 Milliliter,
						100 Milliliter,
						100 Milliliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						10 Milliliter,
						100 Milliliter,
						1.5 Milliliter,
						50 Microliter,
						100 Milliliter,
						100 Milliliter,
						100 Microliter,
						100 Microliter,
						100 Microliter,
						2 Gram,
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
						100 Microliter,
						100 Microliter
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
						"Test sample in too many samples test 17 (for ExperimentIncubateCells)" <> $SessionUUID
					}
				];

				(* Make all of our samples and models DeveloperObjects, give them their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
				Upload[{
					<|Object -> discardedBacteriaSample1, CellType -> Bacterial, CultureAdhesion -> Suspension, Status -> Discarded, DeveloperObject -> True|>,
					<|Object -> bacteriaSample2, CellType -> Bacterial, CultureAdhesion -> Suspension, DeveloperObject -> True|>,
					<|Object -> bacteriaModelSeveredSample3, CellType -> Bacterial, CultureAdhesion -> Suspension, Model -> Null, DeveloperObject -> True|>,
					<|Object -> mammalianSample1, CellType -> Mammalian, CultureAdhesion -> Adherent, DeveloperObject -> True|>,
					<|Object -> mammalianSample2, CellType -> Mammalian, CultureAdhesion -> Adherent, DeveloperObject -> True|>,
					<|Object -> bacteriaSample4, CellType -> Bacterial, CultureAdhesion -> Suspension, DeveloperObject -> True|>,
					<|Object -> bacteriaSample4b, CellType -> Bacterial, CultureAdhesion -> Suspension, DeveloperObject -> True|>,
					<|Object -> bacteriaSample5, CellType -> Bacterial, CultureAdhesion -> Suspension, DeveloperObject -> True|>,
					<|Object -> bacteriaSample6, CellType -> Bacterial, CultureAdhesion -> Suspension, DeveloperObject -> True|>,
					<|Object -> waterSample1, DeveloperObject -> True|>,
					<|Object -> mammalianSample3, CellType -> Mammalian, CultureAdhesion -> Adherent, DeveloperObject -> True|>,
					<|Object -> mammalianSample4, CellType -> Mammalian, CultureAdhesion -> Adherent, DeveloperObject -> True|>,
					<|Object -> mammalianModel, DeveloperObject -> True|>,
					<|Object -> bacteriaModel, DeveloperObject -> True|>,
					<|Object -> deprecatedBacteriaModel, CellType -> Bacterial, CultureAdhesion -> Suspension, Deprecated -> True|>,
					<|Object -> insectSample, CultureAdhesion -> Suspension|>
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
				Object[Sample, "Test discarded sample (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test model severed sample in flask (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test 2nd bacterial sample in plate 1 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in plate 2 (for ExperimentIncubateCells)" <> $SessionUUID],
				Object[Sample, "Test bacterial sample in incompatible container 1 (for ExperimentIncubateCells)" <> $SessionUUID],
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
				Object[Item, Cap, "Cover 9 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 10 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, PlateSeal, "Cover 11 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Cap, "Cover 12 for ExperimentIncubateCells tests " <> $SessionUUID],
				(* note I skipped 13 on purpose here because it is for the uncovered container *)
				Object[Item, Lid, "Cover 14 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 15 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 16 for ExperimentIncubateCells tests " <> $SessionUUID],
				Object[Item, Lid, "Cover 17 for ExperimentIncubateCells tests " <> $SessionUUID],

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

				Object[Protocol, ManualCellPreparation, "Test MCP for ExperimentIncubateCells unit tests" <> $SessionUUID]
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
				Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID]
			}],
			Graphics_
		],
		Example[{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentIncubateCellsOptions[{
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID]
			}],
			Graphics_,
			Messages :> {Error::UnsealedCellCultureVessels,Error::InvalidInput}
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentIncubateCellsOptions[
				{
					Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
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
				Object[Container, Plate, "Test DWP 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID],
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsOptions)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[PickList[allObjs, existsFilter], Force -> True, Verbose -> False];
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, bacteriaModel,mammalianModel,
					emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,
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
					emptyContainer3,
					emptyContainer4
				} = UploadSample[
					{
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
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
						"Test 250mL flask 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test DWP 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
						"Test short mammalian plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID,
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
						Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID]
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
						"Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID,
						"Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID,
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
					Object[Container, Plate, "Test DWP 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsOptions tests " <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsOptions) " <> $SessionUUID],
					Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsOptions)" <> $SessionUUID],
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
				Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID]
			}],
			Null
		],
		Example[{Basic, "Even if an input is invalid, returns Null:"},
			ExperimentIncubateCellsPreview[{
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID]
			}],
			Null,
			Messages :> {Error::UnsealedCellCultureVessels, Error::InvalidInput}
		],
		Example[{Basic, "Even if an option is invalid, returns Null:"},
			ExperimentIncubateCellsPreview[
				{
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID]
				},
				CellType -> {Mammalian, Bacterial}
			],
			Null,
			Messages :> {
				Error::ConflictingCellType,
				Error::NoCompatibleIncubator,
				Error::ConflictingCellTypeWithCultureAdhesion,
				Error::UnsupportedCellCultureType,
				Error::ConflictingCultureAdhesionWithStorageCondition,
				Error::InvalidInput,
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
				Object[Container, Plate, "Test DWP 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
				Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
				Object[Sample, "Test tissue culture sample 2 (for ExperimentIncubateCellsPreview)" <> $SessionUUID]
			};
			existsFilter = DatabaseMemberQ[allObjs];
			EraseObject[PickList[allObjs, existsFilter], Force -> True, Verbose -> False];
		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, bacteriaModel,mammalianModel,
					emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,
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
						"Test 250mL flask 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test DWP 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
						"Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID,
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
						Object[Container, Vessel, "Test 250mL flask 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
						Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID]
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
						"Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID,
						"Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID,
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
					Object[Container, Plate, "Test DWP 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Container, Plate, "Test short mammalian plate 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Cap, "Test Cover 1 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 2 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Object[Item, Lid, "Test Cover 3 for ExperimentIncubateCellsPreview tests " <> $SessionUUID],
					Model[Sample, "Bacterial cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Model[Sample, "Mammalian cells Model (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
					Object[Sample, "Test bacteria sample in flask (for ExperimentIncubateCellsPreview) " <> $SessionUUID],
					Object[Sample, "Test bacterial sample in uncovered plate 1 (for ExperimentIncubateCellsPreview)" <> $SessionUUID],
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
					MSDSRequired -> False,
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
				CarbonDioxide -> {5 Percent, Null, 10 Percent}
			],
			{{(ObjectP[Model[Instrument, Incubator]] | {})...}...}
		],
		Example[{Options, RelativeHumidity, "Find incubators that will work with the desired relative humidity options:"},
			IncubateCellsDevices[
				Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],
				RelativeHumidity -> {50 Percent, 93 Percent, Null}
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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
					MSDSRequired -> False,
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