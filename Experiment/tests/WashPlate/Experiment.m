(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentWashPlate: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentWashPlate*)


DefineTests[ExperimentWashPlate,
	{
		(* Basic examples *)
		Example[{Basic, "Create a protocol object to wash a single sample which resides in a plate container without other samples:"},
			ExperimentWashPlate[Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Create a protocol object to wash an empty plate container:"},
			ExperimentWashPlate[Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Accepts a single sample which reside in a plate container without additional samples:"},
			ExperimentWashPlate[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID]],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Accepts multiple samples which reside in a single plate container:"},
			ExperimentWashPlate[
				{
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 4" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Accepts multiple plates:"},
			ExperimentWashPlate[
				{
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-2" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		(* Additional examples *)
		Example[{Additional, "At the end of the WashPlate experiment, the liquid sample is expected to have no volume when FinalAspiration is True:"},
			simulation = ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				Output -> Simulation
			];
			Download[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID], Volume, Simulation -> simulation],
			EqualP[0 Microliter],
			Variables :> {simulation}
		],
		Example[{Additional, "At the end of the WashPlate experiment, the liquid sample is expected to have WashVolume amount of Buffer when FinalAspiration is False:"},
			simulation = ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				FinalAspiration -> False,
				WashVolume -> 200 Microliter,
				Output -> Simulation
			];
			Download[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID], Volume, Simulation -> simulation],
			EqualP[200 Microliter],
			Variables :> {simulation}
		],
		Example[{Additional, "If Method is Custom, a new method object is uploaded at the time of protocol generation:"},
			protocol = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Custom,
				AspirateTravelRate -> 3,
				AspirationPositionOffset -> Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
				CrosswiseAspiration -> False,
				FinalAspiration -> False,
				DispenseFlowRate -> 5,
				DispensePositionOffset -> Coordinate[{0 Millimeter, 0 Millimeter, 15.24 Millimeter}],
				BottomWash -> False
			];
			outputUnitOperations = Download[protocol, OutputUnitOperations];
			Download[outputUnitOperations[[1]], {MethodExpression, WashPlateMethod, MethodFileName}],
			{Custom, ObjectP[Object[Method, WashPlate]], _?(StringMatchQ[#, "Customized WashPlate Method" ~~ __]&)},
			Variables :> {protocol, outputUnitOperations}
		],
		Example[{Additional, "If Method is specified to an existing file, WashPlateMethod and Method files are the same:"},
			protocol = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Object[Method, WashPlate, "BioTek 405LS Default"]
			];
			outputUnitOperations = Download[protocol, OutputUnitOperations];
			Download[outputUnitOperations[[1]], {MethodLink, WashPlateMethod, MethodFileName}],
			{ObjectP[Object[Method, WashPlate, "BioTek 405LS Default"]], ObjectP[Object[Method, WashPlate, "BioTek 405LS Default"]], _?(StringMatchQ[#, "BioTek 405LS Default" ~~ __]&)},
			Variables :> {protocol, outputUnitOperations}
		],
		Example[{Additional, "MethodFileName can be specified:"},
			protocol = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Object[Method, WashPlate, "BioTek 405LS Default"],
				MethodFileName -> "ExperimentWashPlate test" <> $SessionUUID
			];
			outputUnitOperations = Download[protocol, OutputUnitOperations];
			Download[outputUnitOperations[[1]], {MethodLink, WashPlateMethod, MethodFileName}],
			{ObjectP[Object[Method, WashPlate, "BioTek 405LS Default"]], ObjectP[Object[Method, WashPlate, "BioTek 405LS Default"]], _?(StringMatchQ[#, "ExperimentWashPlate test" <> $SessionUUID]&)},
			Variables :> {protocol, outputUnitOperations}
		],
		Example[{Additional, "When calling ExperimentWashPlate directly, BufferLine is automatically set to BufferA and Buffer resource is linked to the protocol's PlateWasherBufferA:"},
			protocol = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Buffer -> Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID],
				Priming -> True,
				PrimeVolume -> 300 Milliliter,
				WashVolume -> 100 Microliter,
				NumberOfWashes -> 2
			];
			outputUnitOperations = Download[protocol, OutputUnitOperations];
			{
				Download[Cases[Download[protocol, RequiredResources], {resource_, PlateWasherBufferA, ___}:> resource[Object]], {Sample, ContainerModels, Amount}],
				Download[protocol, PlateWasherBufferA],
				Download[outputUnitOperations[[1]], {BufferLine, BufferLink}]
			},
			{
				{{ObjectP[Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID]], {ObjectP[Model[Container, Vessel, "2L Glass Bottle"]]}, EqualP[571 Milliliter]}},
				ObjectP[Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID]],
				{BufferA, ObjectP[Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID]]}
			},
			Variables :> {protocol, outputUnitOperations}
		],
		(* Options examples *)
		Example[{Options, Instrument, "Instrument is default to BioTek 405LS Microplate Washer:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "Instrument can be specified:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Instrument -> Object[Instrument, PlateWasher, "ExperimentWashPlate PlateWasher1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, PlateWasher, "ExperimentWashPlate PlateWasher1" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, {Method, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, DispenseFlowRate, DispensePositionOffset, BottomWash}, "Method is automatically set to a method that meets the specified settings requirement if possible:"},
			method = Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID];
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				AspirateTravelRate -> 2,
				AspirationPositionOffset -> Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
				CrosswiseAspiration -> True,
				CrosswiseAspirationPositionOffset -> Coordinate[{0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
				FinalAspiration -> False,
				DispenseFlowRate -> 3,
				DispensePositionOffset -> Coordinate[{0 Millimeter, 0 Millimeter, 15.88 Millimeter}],
				BottomWash -> True,
				Output -> Options
			];
			{
				Download[method, {Instrument, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, DispenseFlowRate, DispensePositionOffset, BottomWash}],
				Lookup[options, {Method, Instrument, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, DispenseFlowRate, DispensePositionOffset, BottomWash}]
			},
			{
				{
					ObjectP[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
					2,
					<|XOffset -> -20, YOffset -> 0, ZOffset -> 29|>,
					True,
					<|XOffset -> 20, YOffset -> 0, ZOffset -> 29|>,
					False,
					3,
					<|XOffset -> 0, YOffset -> 0, ZOffset -> 125|>,
					True
				},
				{
					ObjectP[Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID]],
					ObjectP[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
					2,
					Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
					True,
					Coordinate[{0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
					False,
					3,
					Coordinate[{0 Millimeter, 0 Millimeter, 15.88 Millimeter}],
					True
				}
			},
			Variables :> {method, options}
		],
		Example[{Options, {Method, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash}, "When Method is set to a method file, all settings are set accordingly:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID],
				Output -> Options
			];
			{
				Download[Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID], {Instrument, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash}],
				Lookup[options, {Method, Instrument, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration,DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash}]
			},
			{
				{
					ObjectP[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
					2,
					<|XOffset -> -20, YOffset -> 0, ZOffset -> 29|>,
					True,
					<|XOffset -> 20, YOffset -> 0, ZOffset -> 29|>,
					False,
					3,
					<|XOffset -> 0, YOffset -> 0, ZOffset -> 125|>,
					EqualP[10 Microliter],
					True
				},
				{
					ObjectP[Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID]],
					ObjectP[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
					2,
					Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
					True,
					Coordinate[{0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
					False,
					3,
					Coordinate[{0 Millimeter, 0 Millimeter, 15.88 Millimeter}],
					EqualP[10 Microliter],
					True
				}
			},
			Variables :> {options}
		],
		Example[{Options, {Method, AspirationPositionOffset, CrosswiseAspiration, FinalAspiration, DispensePositionOffset, BottomWash}, "When no aspiration and dispense settings are specified, automatically set to Object[Method, WashPlate, \"BioTek 405LS Default\"] and set aspiration and dispense settings accordingly:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {Method, AspirationPositionOffset, CrosswiseAspiration, FinalAspiration, DispensePositionOffset, BottomWash}],
			{
				ObjectP[Object[Method, WashPlate, "BioTek 405LS Default"]],
				Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
				False,
				True,
				Coordinate[{0 Millimeter, 0 Millimeter, 15.24 Millimeter}],
				False
			},
			Variables :> {options}
		],
		Example[{Options, {Method, AspirateTravelRate, AspirateDelay, AspirationPositionOffset, CrosswiseAspiration, FinalAspiration, FinalAspirateDelay, DispenseFlowRate, DispensePositionOffset, BottomWash}, "Method can be set to Custom with specified aspiration and dispense settings:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Custom,
				AspirateTravelRate -> 3,
				AspirateDelay -> 60 Millisecond,
				AspirationPositionOffset -> Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.18 Millimeter}],
				CrosswiseAspiration -> False,
				FinalAspiration -> True,
				FinalAspirateDelay -> 60 Millisecond,
				DispenseFlowRate -> 3,
				DispensePositionOffset -> Coordinate[{0 Millimeter, 0 Millimeter, 15.37 Millimeter}],
				BottomWash -> False,
				Output -> Options
			];
			Lookup[options, {Method, AspirateTravelRate, AspirateDelay, AspirationPositionOffset, CrosswiseAspiration, FinalAspiration, FinalAspirateDelay, DispenseFlowRate, DispensePositionOffset, BottomWash}],
			{
				Custom,
				3,
				60 Millisecond,
				Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.18 Millimeter}],
				False,
				True,
				60 Millisecond,
				3,
				Coordinate[{0 Millimeter, 0 Millimeter, 15.37 Millimeter}],
				False
			},
			Variables :> {options}
		],
		Example[{Options, Buffer, "Buffer is default to PBS:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Buffer],
			ObjectP[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
			Variables :> {options}
		],
		Example[{Options, Buffer, "Buffer can be specified:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Buffer -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, Buffer],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, NumberOfWashes, "NumberOfWashes is default to 4:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfWashes],
			4,
			Variables :> {options}
		],
		Example[{Options, NumberOfWashes, "NumberOfWashes can be specified:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				NumberOfWashes -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfWashes],
			3,
			Variables :> {options}
		],
		Example[{Options, WashVolume, "WashVolume is default to 250 Microliters:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, WashVolume],
			250 Microliter,
			Variables :> {options}
		],
		Example[{Options, WashVolume, "WashVolume can be specified:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				WashVolume -> 200 Microliter,
				Output -> Options
			];
			Lookup[options, WashVolume],
			200 Microliter,
			Variables :> {options}
		],
		Example[{Options, {Priming, PrimeVolume}, "Default to perform Priming with 300 Milliliters of Buffer:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {Priming, PrimeVolume}],
			{True, 300 Milliliter},
			Variables :> {options}
		],
		Example[{Options, {Priming, PrimeVolume}, "Priming can be skipped:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Priming -> False,
				Output -> Options
			];
			Lookup[options, {Priming, PrimeVolume}],
			{False, Null},
			Variables :> {options}
		],
		Example[{Options, PrimeVolume, "PrimeVolume can be specified:"},
			options = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				PrimeVolume -> 50 Milliliter,
				Output -> Options
			];
			Lookup[options, {Priming, PrimeVolume}],
			{True, 50 Milliliter},
			Variables :> {options}
		],
		Example[{Options, SampleLabel, "Specify the SampleLabel:"},
			options = ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				SampleLabel -> "Test Label for SampleLabel",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"Test Label for SampleLabel",
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Specify the SampleContainerLabel:"},
			options = ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				SampleContainerLabel -> "Test Label for SampleContainerLabel",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"Test Label for SampleContainerLabel",
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentWashPlate[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentWashPlate[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentWashPlate[Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		(* Messages examples *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentWashPlate[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentWashPlate[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentWashPlate[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentWashPlate[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a container that does not exist but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Plate, "Coated Plate Model for ExperimentWashPlate tests" <> $SessionUUID],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				ExperimentWashPlate[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a sample that does not exist but a simulation is specified that indicates that it is simulated:"},
			Module[{samplePackets, sampleID, simulationToPassIn},
				samplePackets = UploadSample[
					Model[Sample, StockSolution, "ExperimentWashPlate test model sample 1" <> $SessionUUID],
					{"A1", Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					InitialAmount -> 250 Microliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = Simulation[samplePackets];
				ExperimentWashPlate[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "InstrumentPrecision", "If a Volume with a greater precision than 1 Microliter is given as WashVolume, it is rounded:"},
			Lookup[
				ExperimentWashPlate[
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
					WashVolume -> 100.5 Microliter,
					Output -> Options
				],
				WashVolume
			],
			EqualP[101 Microliter],
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[{Messages, "InstrumentPrecision", "If AspirateDelay is specified with a greater precision than 1 Milliseconds, it is rounded:"},
			Lookup[
				ExperimentWashPlate[
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
					AspirateDelay -> 3.3 Millisecond,
					Output -> Options
				],
				AspirateDelay
			],
			EqualP[3 Millisecond],
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[{Messages, "DiscardedSample", "If the given samples are discarded, they cannot be incubated:"},
			ExperimentWashPlate[Object[Container, Plate, "ExperimentWashPlate test 96-well plate with discarded sample" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSample,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModel", "If the given samples have deprecated models, they cannot be incubated:"},
			ExperimentWashPlate[Object[Container, Plate, "ExperimentWashPlate test 96-well plate with deprecated sample" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModel,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidWashPlateContainers", "If the given sample container is not a 96-well plate, they cannot be washed:"},
			ExperimentWashPlate[Object[Container, Plate, "ExperimentWashPlate test 24-well plate" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::InvalidWashPlateContainers,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnusedWashPlateSamples", "If the given sample container contains unspecified samples, a warning is thrown:"},
			ExperimentWashPlate[
				{
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID]
				},
				Output -> Options
			],
			_,
			Messages :> {
				Warning::UnusedWashPlateSamples
			}
		],
		Example[{Messages, "DuplicatedWashPlateSamples", "Throw an error if the same plate is specified multiple times as input:"},
			ExperimentWashPlate[
				{
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedWashPlateSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DuplicatedWashPlateSamples", "Throw an error if the same sample is specified multiple times as input:"},
			ExperimentWashPlate[
				{
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 4" <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {
				Error::DuplicatedWashPlateSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "InvalidPlateWasher", "Throw an error if the specified Instrument is not supported:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateWasher, "ELISA NIMBUS Microplate Washer"]
			],
			$Failed,
			Messages :> {
				Error::InvalidPlateWasher,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleMaterials", "Buffer must be compatible with the plate washer manifold tubing:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Buffer -> Model[Sample, "Chloroform"]
			],
			$Failed,
			Messages :> {
				Error::IncompatibleMaterials,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleMaterials", "Sample composition must be compatible with the plate washer manifold tubing:"},
			ExperimentWashPlate[
				Object[Sample, "ExperimentWashPlate test object sample incompatible" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::IncompatibleMaterials,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPrimingOptions", "PrimeVolume cannot be specified when Prime is False:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Priming -> False,
				PrimeVolume -> 50 Milliliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingPrimingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingCrosswiseAspirationOptions", "CrosswiseAspirationPositionOffset can not be specified if CrosswiseAspiration is set to False:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				CrosswiseAspiration -> False,
				CrosswiseAspirationPositionOffset -> Coordinate[{0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}]
			],
			$Failed,
			Messages :> {
				Error::ConflictingCrosswiseAspirationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingFinalAspirationOptions", "FinalAspirateTravelRate can not be specified if FinalAspiration is set to False:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				FinalAspiration -> False,
				FinalAspirateTravelRate -> 3
			],
			$Failed,
			Messages :> {
				Error::ConflictingFinalAspirationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWashPlateMethodWithAspirationOptions", "When Method is set to a method file but AspirateTravelRate is set to a different value than the method, an error is thrown:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID],
				AspirateTravelRate -> 5
			],
			$Failed,
			Messages :> {
				Error::ConflictingWashPlateMethodWithAspirationOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingWashPlateMethodWithDispenseOptions", "When Method is set to a method file but DispenseFlowRate is set to a different value than the method, an error is thrown:"},
			ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Method -> Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID],
				DispenseFlowRate -> 5
			],
			$Failed,
			Messages :> {
				Error::ConflictingWashPlateMethodWithDispenseOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientVolume", "When there isn't enough buffer in lab, a warning to thrown:"},
			protocol = ExperimentWashPlate[
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Buffer -> Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID],
				Priming -> True,
				PrimeVolume -> 300 Milliliter,
				WashVolume -> 300 Microliter,
				NumberOfWashes -> 10
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Messages :> {Warning::InsufficientVolume}
		],
		Example[{Messages, "ContainerTooSmall", "When the total required volume of Buffer exceeds 2 Liter, an error is thrown:"},
			ExperimentWashPlate[
				{
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-3" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-2" <> $SessionUUID]
				},
				Priming -> True,
				PrimeVolume -> 300 Milliliter,
				NumberOfWashes -> 10,
				WashVolume -> 300 Microliter
			],
			$Failed,
			Messages :> {
				Error::ContainerTooSmall,
				Error::InvalidInput
			}
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		allWashPlateMethodSearch["Memoization"] = {Object[Method, WashPlate, "BioTek 405LS Default"], Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID]}
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* Set $CreatedObjects to {} to catch all of objects created *)
		ClearMemoization[];
		$CreatedObjects = {};
		ClearDownload[];

		Module[{allObjects, existingObjects},
			allObjects = {
				(* Bench *)
				Object[Container, Bench, "Bench for ExperimentWashPlate tests" <> $SessionUUID],
				Object[Instrument, PlateWasher, "ExperimentWashPlate PlateWasher1" <> $SessionUUID],
				Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID],
				(* Containers *)
				Model[Container, Plate, "Coated Plate Model for ExperimentWashPlate tests" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentWashPlate test container 1" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentWashPlate test container 2" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-2" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-3" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-2" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test 24-well plate" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test 96-well plate with discarded sample" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test 96-well plate with deprecated sample" <> $SessionUUID],
				Object[Container, Plate, "ExperimentWashPlate test 96-well plate with incompatible material sample" <> $SessionUUID],
				(* Model samples *)
				Model[Sample, StockSolution, "ExperimentWashPlate test model sample 1" <> $SessionUUID],
				Model[Sample, "ExperimentWashPlate test deprecated model sample" <> $SessionUUID],
				(* Object samples *)
				Object[Sample, "ExperimentWashPlate test vessel container sample 1" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 4" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 5" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test 96-well plate container sample 6" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test sample 1 in 24-well plate" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test sample 2 in 24-well plate" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test object sample discarded" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test object sample deprecated" <> $SessionUUID],
				Object[Sample, "ExperimentWashPlate test object sample incompatible" <> $SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, testCoatedPlateModel, instrument1, container1, container2, plate1, plate2, plate3, plate4, plate5,
					plate6, plate7, plate8, plate9, sampleModel1, deprecatedModel, vesselSample, washBufferSample, plateSample1,
					plateSample2, plateSample3, plateSample4, plateSample5, plateSample6, plateSample7, plateSample8, discardedSample,
					deprecatedSample, incompatibleSample, testMethod
				},

				(* Test Bench Object *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"],Objects],
						Name -> "Bench for ExperimentWashPlate tests" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* Create a test plate model with Coating *)
				testCoatedPlateModel = Upload[<|
					Type -> Model[Container, Plate],
					Name -> "Coated Plate Model for ExperimentWashPlate tests" <> $SessionUUID,
					Replace[Synonyms] -> {"Coated Plate Model for ExperimentWashPlate tests" <> $SessionUUID},
					LiquidHandlerPrefix -> "ExperimentWashPlate tests" <> $SessionUUID,
					Coating -> Link[Model[Molecule, Protein, "Protein A"]],
					Opaque -> True,
					SelfStanding -> True,
					Treatment -> NonTreated,
					MinTemperature -> Quantity[-20., "DegreesCelsius"],
					MaxTemperature -> Quantity[65., "DegreesCelsius"],
					MinVolume -> 50 Microliter,
					MaxVolume -> 300 Microliter,
					Dimensions -> {127.5 Millimeter, 85.3 Millimeter, 14.4 Millimeter},
					CrossSectionalShape -> Rectangle,
					Footprint -> Plate,
					Replace[PositionPlotting] -> Download[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], PositionPlotting],
					Replace[Positions] -> Download[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], Positions],
					Reusable -> False,
					Expires -> False,
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
					Replace[CoverTypes] -> {Seal, Place},
					(*Plate*)
					PlateColor -> Clear,
					WellColor -> Clear,
					WellDiameter -> 6 Millimeter,
					HorizontalMargin -> 11.2 Millimeter,
					VerticalMargin -> 8.15 Millimeter,
					DepthMargin -> 11.8 Millimeter,
					HorizontalPitch -> 18 Millimeter,
					VerticalPitch -> 9 Millimeter,
					HorizontalOffset -> Quantity[0., "Millimeters"],
					VerticalOffset -> Quantity[0., "Millimeters"],
					WellBottomThickness -> 0.8 Millimeter,
					VerifiedContainerModel -> True,
					AspectRatio -> 4,
					Columns -> 4,
					Rows -> 1,
					NumberOfWells -> 96,
					RecommendedFillVolume -> Quantity[100., "Microliters"],
					WellBottom -> FlatBottom,
					WellDepth -> 1.8 Millimeter,
					FlangeWidth -> 1.8 Millimeter,
					FlangeHeight -> 4.2 Millimeter
				|>];

				(* Create new test instruments *)
				instrument1 = Upload[<|
					Type -> Object[Instrument, PlateWasher],
					Name -> "ExperimentWashPlate PlateWasher1" <> $SessionUUID,
					Model -> Link[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"], Objects],
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				(* Test Containers *)
				{
					plate1,
					plate2,
					plate3,
					plate4,
					plate5,
					plate6,
					plate7,
					plate8,
					plate9,
					container1,
					container2
				} = UploadSample[
					Join[
						ConstantArray[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], 3],
						ConstantArray[testCoatedPlateModel, 2],
						ConstantArray[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], 3],
						{
							Model[Container, Plate, "id:E8zoYveRlldX"],(* 24-well clear bottom *)
							Model[Container, Vessel, "2mL Tube"],
							Model[Container, Vessel, "2L Glass Bottle"]
						}
					],
					ConstantArray[{"Work Surface", testBench}, 11],
					Status -> Available,
					Name -> {
						"ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID,
						"ExperimentWashPlate test PS 96-well plate-2" <> $SessionUUID,
						"ExperimentWashPlate test PS 96-well plate-3" <> $SessionUUID,
						"ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID,
						"ExperimentWashPlate test coated 96-well plate-2" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate with discarded sample" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate with deprecated sample" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate with incompatible material sample" <> $SessionUUID,
						"ExperimentWashPlate test 24-well plate" <> $SessionUUID,
						"ExperimentWashPlate test container 1" <> $SessionUUID,
						"ExperimentWashPlate test container 2" <> $SessionUUID
					},
					StorageCondition -> AmbientStorage
				];

				sampleModel1 = UploadStockSolution[
					{{15 Gram, Model[Sample, "Sodium Chloride"]}},
					Model[Sample, "Milli-Q water"],
					1 Liter,
					Name -> "ExperimentWashPlate test model sample 1" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
						{15 Gram / Liter, Model[Molecule, "id:BYDOjvG676mq"]}
					}
				];

				deprecatedModel = Upload[<|
					Name -> "ExperimentWashPlate test deprecated model sample" <> $SessionUUID,
					Type -> Model[Sample],
					Deprecated -> True,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
					State -> Liquid
				|>];

				(* Object samples, Target Antigen Objects, Antibody Objects *)
				{
					vesselSample,
					washBufferSample,
					plateSample1,
					plateSample2,
					plateSample3,
					plateSample4,
					plateSample5,
					plateSample6,
					plateSample7,
					plateSample8,
					discardedSample,
					deprecatedSample,
					incompatibleSample
				} = UploadSample[
					Join[{sampleModel1, Model[Sample, StockSolution, "1x PBS from 10X stock"]}, ConstantArray[sampleModel1, 9], {deprecatedModel, Model[Sample, "Chloroform"]}],
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", plate1},
						{"A1", plate2},
						{"B1", plate2},
						{"C1", plate2},
						{"A1", plate3},
						{"B1", plate3},
						{"A1", plate9},
						{"B1", plate9},
						{"A1", plate6},
						{"A1", plate7},
						{"A1", plate8}
					},
					Name -> {
						"ExperimentWashPlate test vessel container sample 1" <> $SessionUUID,
						"ExperimentWashPlate test object wash buffer sample" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 4" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 5" <> $SessionUUID,
						"ExperimentWashPlate test 96-well plate container sample 6" <> $SessionUUID,
						"ExperimentWashPlate test sample 1 in 24-well plate" <> $SessionUUID,
						"ExperimentWashPlate test sample 2 in 24-well plate" <> $SessionUUID,
						"ExperimentWashPlate test object sample discarded" <> $SessionUUID,
						"ExperimentWashPlate test object sample deprecated" <> $SessionUUID,
						"ExperimentWashPlate test object sample incompatible" <> $SessionUUID
					},
					State -> Liquid,
					InitialAmount -> Join[{1.8 Milliliter, 650 Milliliter}, ConstantArray[100 Microliter, 6], {1 Milliliter, 1 Milliliter}, ConstantArray[100 Microliter, 3]],
					StorageCondition -> Refrigerator
				];
				Upload[<|Object -> discardedSample, Status -> Discarded|>];

				(* Create a public method file *)
				testMethod = Upload[<|
					Type -> Object[Method, WashPlate],
					Name -> "ExperimentWashPlate Customized Method1" <> $SessionUUID,
					Instrument -> Link[Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]],
					AspirateTravelRate -> 2,
					AspirationPositionOffset -> <|XOffset -> -20, YOffset -> 0 , ZOffset -> 29|>,
					CrosswiseAspiration -> True,
					CrosswiseAspirationPositionOffset -> <|XOffset -> 20, YOffset -> 0 , ZOffset -> 29|>,
					FinalAspiration -> False,
					DispenseFlowRate -> 3,
					DispensePositionOffset -> <|XOffset -> 0, YOffset -> 0 , ZOffset -> 125|>,
					DispenseVacuumDelay -> 10 Microliter,
					BottomWash -> True,
					Transfer[Notebook] -> Null
				|>];
			]
		]
	),
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					(* Bench *)
					Object[Container, Bench, "Bench for ExperimentWashPlate tests" <> $SessionUUID],
					Object[Instrument, PlateWasher, "ExperimentWashPlate PlateWasher1" <> $SessionUUID],
					Object[Method, WashPlate, "ExperimentWashPlate Customized Method1" <> $SessionUUID],
					(* Containers *)
					Model[Container, Plate, "Coated Plate Model for ExperimentWashPlate tests" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentWashPlate test container 1" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentWashPlate test container 2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test PS 96-well plate-3" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test coated 96-well plate-2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test 24-well plate" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test 96-well plate with discarded sample" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test 96-well plate with deprecated sample" <> $SessionUUID],
					Object[Container, Plate, "ExperimentWashPlate test 96-well plate with incompatible material sample" <> $SessionUUID],
					(* Model samples *)
					Model[Sample, StockSolution, "ExperimentWashPlate test model sample 1" <> $SessionUUID],
					Model[Sample, "ExperimentWashPlate test deprecated model sample" <> $SessionUUID],
					(* Object samples *)
					Object[Sample, "ExperimentWashPlate test vessel container sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test object wash buffer sample" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 4" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 5" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test 96-well plate container sample 6" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test sample 1 in 24-well plate" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test sample 2 in 24-well plate" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test object sample discarded" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test object sample deprecated" <> $SessionUUID],
					Object[Sample, "ExperimentWashPlate test object sample incompatible" <> $SessionUUID]
				}
			}], ObjectP[]];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	}
];

(* ::Subsection::Closed:: *)
(*ValidExperimentWashPlateQ*)


DefineTests[ValidExperimentWashPlateQ,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns a Boolean indicating the validity of a WashPlate experimental setup on a sample:"},
			ValidExperimentWashPlateQ[
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a WashPlate experimental setup on a sample:"},
			ValidExperimentWashPlateQ[
				Object[Sample, "ValidExperimentWashPlateQ test vessel container sample 1" <> $SessionUUID]
			],
			False
		],
		Example[{Basic, "Returns a Boolean indicating the validity of a WashPlate experimental setup on multiple samples:"},
			ValidExperimentWashPlateQ[
				{
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 3" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 4" <> $SessionUUID]
				}
			],
			True
		],
		(* ===Options=== *)
		Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentWashPlateQ[
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID],
				Verbose -> True
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentWashPlateQ[
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* Set $CreatedObjects to {} to catch all of objects created *)
		ClearMemoization[];
		$CreatedObjects = {};
		ClearDownload[];

		Module[{allObjects, existingObjects},
			allObjects = {
				(* Bench *)
				Object[Container, Bench, "Bench for ValidExperimentWashPlateQ tests" <> $SessionUUID],
				(* Containers *)
				Object[Container, Vessel, "ValidExperimentWashPlateQ test container 1" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentWashPlateQ test container 2" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentWashPlateQ test PS 96-well plate-1" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentWashPlateQ test PS 96-well plate-2" <> $SessionUUID],
				(* Model samples *)
				Model[Sample, StockSolution, "ValidExperimentWashPlateQ test model sample 1" <> $SessionUUID],
				(* Object samples *)
				Object[Sample, "ValidExperimentWashPlateQ test vessel container sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentWashPlateQ test object wash buffer sample" <> $SessionUUID],
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 3" <> $SessionUUID],
				Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 4" <> $SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, container1, container2, plate1, plate2, sampleModel1, vesselSample, washBufferSample, plateSample1,
					plateSample2, plateSample3, plateSample4
				},

				(* Test Bench Object *)
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"],Objects],
						Name -> "Bench for ValidExperimentWashPlateQ tests" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* Test Containers *)
				{
					plate1,
					plate2,
					container1,
					container2
				} = UploadSample[
					Join[
						ConstantArray[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], 2],
						{
							Model[Container, Vessel, "2mL Tube"],
							Model[Container, Vessel, "2L Glass Bottle"]
						}
					],
					ConstantArray[{"Work Surface", testBench}, 4],
					Status -> Available,
					Name -> {
						"ValidExperimentWashPlateQ test PS 96-well plate-1" <> $SessionUUID,
						"ValidExperimentWashPlateQ test PS 96-well plate-2" <> $SessionUUID,
						"ValidExperimentWashPlateQ test container 1" <> $SessionUUID,
						"ValidExperimentWashPlateQ test container 2" <> $SessionUUID
					},
					StorageCondition -> AmbientStorage
				];

				sampleModel1 = UploadStockSolution[
					{{15 Gram, Model[Sample, "Sodium Chloride"]}},
					Model[Sample, "Milli-Q water"],
					1 Liter,
					Name -> "ValidExperimentWashPlateQ test model sample 1" <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
						{15 Gram / Liter, Model[Molecule, "id:BYDOjvG676mq"]}
					}
				];

				(* Object samples, Target Antigen Objects, Antibody Objects *)
				{
					vesselSample,
					washBufferSample,
					plateSample1,
					plateSample2,
					plateSample3,
					plateSample4
				} = UploadSample[
					Join[{sampleModel1, Model[Sample, StockSolution, "1x PBS from 10X stock"]}, ConstantArray[sampleModel1, 4]],
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", plate1},
						{"A1", plate2},
						{"B1", plate2},
						{"C1", plate2}
					},
					Name -> {
						"ValidExperimentWashPlateQ test vessel container sample 1" <> $SessionUUID,
						"ValidExperimentWashPlateQ test object wash buffer sample" <> $SessionUUID,
						"ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID,
						"ValidExperimentWashPlateQ test 96-well plate container sample 2" <> $SessionUUID,
						"ValidExperimentWashPlateQ test 96-well plate container sample 3" <> $SessionUUID,
						"ValidExperimentWashPlateQ test 96-well plate container sample 4" <> $SessionUUID
					},
					State -> Liquid,
					InitialAmount -> Join[{1.8 Milliliter, 500 Milliliter}, ConstantArray[100 Microliter, 4]],
					StorageCondition -> Refrigerator
				];
			]
		]

	),
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					(* Bench *)
					Object[Container, Bench, "Bench for ValidExperimentWashPlateQ tests" <> $SessionUUID],
					(* Containers *)
					Object[Container, Vessel, "ValidExperimentWashPlateQ test container 1" <> $SessionUUID],
					Object[Container, Vessel, "ValidExperimentWashPlateQ test container 2" <> $SessionUUID],
					Object[Container, Plate, "ValidExperimentWashPlateQ test PS 96-well plate-1" <> $SessionUUID],
					Object[Container, Plate, "ValidExperimentWashPlateQ test PS 96-well plate-2" <> $SessionUUID],
					(* Model samples *)
					Model[Sample, StockSolution, "ValidExperimentWashPlateQ test model sample 1" <> $SessionUUID],
					(* Object samples *)
					Object[Sample, "ValidExperimentWashPlateQ test vessel container sample 1" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test object wash buffer sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 1" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 2" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 3" <> $SessionUUID],
					Object[Sample, "ValidExperimentWashPlateQ test 96-well plate container sample 4" <> $SessionUUID]
				}
			}], ObjectP[]];
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentWashPlateOptions*)

DefineTests[ExperimentWashPlateOptions,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns options for washing a plate in a WashPlate experiment:"},
			ExperimentWashPlateOptions[
				Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlateOptions" <> $SessionUUID]
			],
			_Grid
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentWashPlateOptions" <> $SessionUUID],
				Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlateOptions" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{testBench, testPlate1},

			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentWashPlateOptions" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"],
					{"Work Surface", testBench},
					Name -> "Test empty 96-well plate 1 for ExperimentWashPlateOptions" <> $SessionUUID
				];
			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentWashPlateOptions" <> $SessionUUID],
					Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlateOptions" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentWashPlatePreview*)

DefineTests[ExperimentWashPlatePreview,
	{
		(* ===Basic===*)
		Example[{Basic, "Returns nothing for washing a plate in a WashPlate experiment:"},
			ExperimentWashPlatePreview[
				Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlatePreview" <> $SessionUUID]
			],
			Null
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for ExperimentWashPlatePreview" <> $SessionUUID],
				Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlatePreview" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{testBench, testPlate1},

			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentWashPlatePreview" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				testPlate1 = UploadSample[
					Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"],
					{"Work Surface", testBench},
					Name -> "Test empty 96-well plate 1 for ExperimentWashPlatePreview" <> $SessionUUID
				];
			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for ExperimentWashPlatePreview" <> $SessionUUID],
					Object[Container, Plate, "Test empty 96-well plate 1 for ExperimentWashPlatePreview" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsection::Closed:: *)
(*WashPlate*)


DefineTests[WashPlate,
	{
		Example[{Basic, "Create a protocol object to wash an empty container:"},
			Experiment[{
				WashPlate[
					Sample -> Object[Container, Plate, "Test empty 96-well plate 1 for WashPlate" <> $SessionUUID]
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Basic, "Create a protocol object to wash samples in multiple container plates:"},
			Experiment[{
				WashPlate[
					Sample -> {
						Object[Sample, "Test sample 1 for WashPlate" <> $SessionUUID],
						Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Additional, "If there are multiple WashPlate unit operations and all have different buffers, assign different BufferLine to each of them:"},
			protocol = ExperimentRoboticSamplePreparation[{
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, "Milli-Q water"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "0.1% Triton X-100 in PBS"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "100 mM HEPES Buffer"]
				]
			}];
			washPlateUOs = Download[protocol, OutputUnitOperations][[1;;4]];
			Download[washPlateUOs, BufferLine],
			{BufferA, BufferB, BufferC, BufferD},
			Variables :> {protocol, washPlateUOs}
		],
		Example[{Additional, "If there are multiple WashPlate unit operations and all have the same buffer, assign the same BufferLine to all of them:"},
			protocol = ExperimentRoboticSamplePreparation[{
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Priming -> True,
					Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Priming -> False,
					Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"]
				]
			}];
			washPlateUOs = Download[protocol, OutputUnitOperations][[1;;2]];
			Download[washPlateUOs, BufferLine],
			{BufferA..},
			Variables :> {protocol, washPlateUOs}
		],
		Example[{Messages, "TooManyPlateWasherBuffers", "If there are more than 4 WashPlate unit operations and all have different buffers, throw an error:"},
			ExperimentRoboticSamplePreparation[{
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, "Milli-Q water"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "Filtered PBS, Sterile"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "0.1% Triton X-100 in PBS"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "100 mM HEPES Buffer"]
				],
				WashPlate[
					Sample -> Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID],
					Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"]
				]
			}],
			$Failed,
			Messages :> {
				Error::TooManyPlateWasherBuffers,
				Error::InvalidInput
			}
		],
		Example[{Messages, "ContainerTooSmall", "When the total required volume of Buffer exceeds 2 Liter, an error is thrown:"},
			ExperimentRoboticSamplePreparation[{
				WashPlate[
					Sample -> {
						Object[Container, Plate, "Test empty 96-well plate 1 for WashPlate" <> $SessionUUID],
						Object[Container, Plate, "Test non-empty 96-well plate 2 for WashPlate" <> $SessionUUID],
						Object[Container, Plate, "Test non-empty 96-well plate 3 for WashPlate" <> $SessionUUID]
					},
					Buffer -> Model[Sample, "Milli-Q water"],
					Priming -> True,
					WashVolume -> 300 Microliter,
					NumberOfWashes -> 10
				],
				WashPlate[
					Sample -> {
						Object[Container, Plate, "Test empty 96-well plate 1 for WashPlate" <> $SessionUUID],
						Object[Container, Plate, "Test non-empty 96-well plate 2 for WashPlate" <> $SessionUUID],
						Object[Container, Plate, "Test non-empty 96-well plate 3 for WashPlate" <> $SessionUUID]
					},
					Buffer -> Model[Sample, "Milli-Q water"],
					Priming -> False,
					WashVolume -> 300 Microliter,
					NumberOfWashes -> 10
				]
			}],
			$Failed,
			Messages :> {
				Error::ContainerTooSmall,
				Error::InvalidInput
			}
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects = {};
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Container, Bench, "Test bench for WashPlate" <> $SessionUUID],
				Object[Container, Plate, "Test empty 96-well plate 1 for WashPlate" <> $SessionUUID],
				Object[Container, Plate, "Test non-empty 96-well plate 2 for WashPlate" <> $SessionUUID],
				Object[Container, Plate, "Test non-empty 96-well plate 3 for WashPlate" <> $SessionUUID],
				Object[Sample, "Test sample 1 for WashPlate" <> $SessionUUID],
				Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Module[{testBench, testPlate1, testPlate2, testPlate3, testSamples},

			Block[{$DeveloperUpload = True},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for WashPlate" <> $SessionUUID,
					Site -> Link[$Site]
				|>];

				{testPlate1, testPlate2, testPlate3} = UploadSample[
					ConstantArray[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"], 3],
					ConstantArray[{"Work Surface", testBench}, 3],
					Name -> {
						"Test empty 96-well plate 1 for WashPlate" <> $SessionUUID,
						"Test non-empty 96-well plate 2 for WashPlate" <> $SessionUUID,
						"Test non-empty 96-well plate 3 for WashPlate" <> $SessionUUID
					}
				];
				testSamples = UploadSample[
					ConstantArray[Model[Sample, "Milli-Q water"], 2],
					{
						{"A1", testPlate2},
						{"A1", testPlate3}
					},
					InitialAmount -> {100 Microliter, 100 Microliter},
					State -> {Liquid, Liquid},
					Name -> {
						"Test sample 1 for WashPlate" <> $SessionUUID,
						"Test sample 2 for WashPlate" <> $SessionUUID
					}
				];
			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];

			(* Gather all the objects and models created in SymbolSetUp *)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				{
					Object[Container, Bench, "Test bench for WashPlate" <> $SessionUUID],
					Object[Container, Plate, "Test empty 96-well plate 1 for WashPlate" <> $SessionUUID],
					Object[Container, Plate, "Test non-empty 96-well plate 2 for WashPlate" <> $SessionUUID],
					Object[Container, Plate, "Test non-empty 96-well plate 3 for WashPlate" <> $SessionUUID],
					Object[Sample, "Test sample 1 for WashPlate" <> $SessionUUID],
					Object[Sample, "Test sample 2 for WashPlate" <> $SessionUUID]
				}
			}], ObjectP[]];


			(* Erase all the created objects and models *)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]];
			Unset[$CreatedObjects];
		];
	)
];
