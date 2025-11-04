(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentDifferentialScanningCalorimetry: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentDifferentialScanningCalorimetry*)

DefineTests[
	ExperimentDifferentialScanningCalorimetry,
	{
		Example[{Basic, "Obtain a DSC read of a given sample:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]],
			ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
		],
		Example[{Basic, "Obtain a DSC read when pooling multiple samples together:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}],
			ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
		],
		Example[{Basic, "Obtain a DSC read of a a mixture of containers and samples:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID]}}],
			ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
		],

		(* --- Messages --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentDifferentialScanningCalorimetry[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentDifferentialScanningCalorimetry[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentDifferentialScanningCalorimetry[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentDifferentialScanningCalorimetry[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentDifferentialScanningCalorimetry[Link[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, DifferentialScanningCalorimetry]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "RescanCoolingRateIncompatible", "If RescanCoolingRate is specified, NumberOfScans must be greater than 1:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], NumberOfScans -> 1, RescanCoolingRate -> 300 Celsius / Hour],
			$Failed,
			Messages :> {
				Error::RescanCoolingRateIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RescanCoolingRateIncompatible", "If RescanCoolingRate is Null, NumberOfScans must not be greater than 1:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], NumberOfScans -> 2, RescanCoolingRate -> Null],
			$Failed,
			Messages :> {
				Error::RescanCoolingRateIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DestinationWellInvalid", "If the DestinationWell option is specified, limitations of the DSC instrument dictate that it must only choose even wells and only use the first n wells of the plate:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, DestinationWell -> {"A2", "A3"}],
			$Failed,
			Messages :> {
				Error::DestinationWellInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AliquotContainerOccupied", "If the AliquotContainer option is specified as a plate object, the plate must be empty:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, AliquotContainer -> {Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID], Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID]}],
			$Failed,
			Messages :> {
				Error::AliquotContainerOccupied,
				Error::AliquotContainers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledMixMismatch", "If NestedIndexMatchingMix -> False, NestedIndexMatchingMixTime and PooledMixRate cannot be specified:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> False, NestedIndexMatchingMixTime -> 5 Minute, PooledMixRate -> 2000 RPM],
			$Failed,
			Messages :> {
				Error::PooledMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledMixMismatch", "If NestedIndexMatchingMix -> True, NestedIndexMatchingMixTime and PooledMixRate cannot be Null:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> True, NestedIndexMatchingMixTime -> Null, PooledMixRate -> Null],
			$Failed,
			Messages :> {
				Error::PooledMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledCentrifugeMismatch", "If NestedIndexMatchingCentrifuge -> False, NestedIndexMatchingCentrifugeTime and NestedIndexMatchingCentrifugeForce cannot be specified:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifuge -> False, NestedIndexMatchingCentrifugeTime -> 5 Minute, NestedIndexMatchingCentrifugeForce -> 850 GravitationalAcceleration],
			$Failed,
			Messages :> {
				Error::PooledCentrifugeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledCentrifugeMismatch", "If NestedIndexMatchingCentrifuge -> True, NestedIndexMatchingCentrifugeTime and NestedIndexMatchingCentrifugeForce cannot be Null:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifuge -> True, NestedIndexMatchingCentrifugeTime -> Null, NestedIndexMatchingCentrifugeForce -> Null],
			$Failed,
			Messages :> {
				Error::PooledCentrifugeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledIncubateMismatch", "If NestedIndexMatchingIncubate -> False, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime cannot be specified:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingIncubate -> False, PooledIncubationTime -> 5 Minute, NestedIndexMatchingIncubationTemperature -> 40 Celsius, NestedIndexMatchingAnnealingTime -> 5 Minute],
			$Failed,
			Messages :> {
				Error::PooledIncubateMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PooledIncubateMismatch", "If NestedIndexMatchingIncubate -> True, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime cannot be Null:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingIncubate -> True, PooledIncubationTime -> Null, NestedIndexMatchingIncubationTemperature -> Null, NestedIndexMatchingAnnealingTime -> Null],
			$Failed,
			Messages :> {
				Error::PooledIncubateMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DuplicateName", "The Name option must not be the name of an already-existing DSC protocol:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, Name -> "Already existing name"<> $SessionUUID],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiscardedSamples", "Samples that are discarded cannot be provided:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing (Discarded)"<> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "Samples whose models are deprecated cannot be provided:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetry testing (Deprecated)"<> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "StartTemperatureAboveEndTemperature", "StartTemperature may not be above EndTemperature:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], StartTemperature -> 50 Celsius, EndTemperature -> 40 Celsius],
			$Failed,
			Messages :> {
				Error::StartTemperatureAboveEndTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DSCTooManySamples", "An error is thrown if too many samples are run in a single protocol:"},
			ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], NumberOfReplicates -> 43],
			$Failed,
			Messages :> {
				Error::DSCTooManySamples,
				Warning::TotalAliquotVolumeTooLarge,
				Error::InvalidInput
			}
		],
		Example[{Messages, "CleaningFrequencyTooHigh", "Specify when to clean with detergent before or between sample runs:"},
			ExperimentDifferentialScanningCalorimetry[{Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, CleaningFrequency -> 3],
			$Failed,
			Messages :> {
				Error::CleaningFrequencyTooHigh,
				Error::InvalidOption
			}

		],

		(* --- Options --- *)
		Example[{Options, Name, "The Name option sets the Name field of the output protocol object:"},
			ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, Name -> "Protocol A63412B"],
			Object[Protocol, DifferentialScanningCalorimetry, "Protocol A63412B"]
		],
		Example[{Options, SamplesInStorageCondition, "The SamplesInStorageCondition option sets the storage parameters of the SamplesIn once they are stored after the protocol runs:"},
			options = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, Template, "Use the Template option to inherit specified options from the parent protocol:"},
			options = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, Template -> Object[Protocol, DifferentialScanningCalorimetry, "Template protocol with 4 scans"<> $SessionUUID, UnresolvedOptions], Output -> Options];
			Lookup[options, NumberOfScans],
			4,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to repeat a DSC sample preparation and reading of a provided sample.  This is functionally equivalent to listing the same sample n times in the input:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], NumberOfReplicates -> 2, Output -> Options];
			Lookup[options, NumberOfReplicates],
			2,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AutosamplerTemperature, "Specify the temperature the injection plate should be held at prior to injection:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AutosamplerTemperature -> 4 Celsius, Output -> Options];
			Lookup[options, AutosamplerTemperature],
			4 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AutosamplerTemperature, "AutosamplerTemperature may only be specified in increments of 0.1 degrees Celsius:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AutosamplerTemperature -> 4.023 Celsius, Output -> Options];
			Lookup[options, AutosamplerTemperature],
			4 Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, InjectionVolume, "Specify the amount of sample that is injected onto the DSC instrument:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], InjectionVolume -> 260 Microliter, Output -> Options];
			Lookup[options, InjectionVolume],
			260 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, InjectionVolume, "InjectionVolume may only be specified in increments of 10 microliters:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], InjectionVolume -> 262 Microliter, Output -> Options];
			Lookup[options, InjectionVolume],
			260 Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, InjectionRate, "Specify the rate each sample is injected onto the DSC instrument:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], InjectionRate -> 110 Microliter / Second, Output -> Options];
			Lookup[options, InjectionRate],
			110 Microliter / Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, InjectionRate, "InjectionRate may only be specified in increments of 10 microliters / second:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], InjectionRate -> 111 Microliter / Second, Output -> Options];
			Lookup[options, InjectionRate],
			110 Microliter / Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, CleaningFrequency, "Specify when to clean with detergent before or between sample runs:"},
			protocol = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CleaningFrequency -> First];
			Download[protocol, CleaningFrequency],
			First,
			Variables :> {protocol}
		],
		Example[{Options, Blanks, "Specify the samples or models that will be used to blank the sample's DSC readings:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Blanks -> Model[Sample, StockSolution, "1X UV buffer"], Output -> Options];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "1X UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, StartTemperature, "Specify the temperature at which each heating cycle starts:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], StartTemperature -> 1 Celsius, Output -> Options];
			Lookup[options, StartTemperature],
			1 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, StartTemperature, "StartTemperature must be specified to the closest 0.1 Celsius:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], StartTemperature -> 1.21 Celsius, Output -> Options];
			Lookup[options, StartTemperature],
			1.2 Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, EndTemperature, "Specify the temperature at which each heating cycle ends:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], EndTemperature -> 100 Celsius, Output -> Options];
			Lookup[options, EndTemperature],
			100 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, EndTemperature, "EndTemperature must be specified to the closest 0.1 Celsius:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], EndTemperature -> 100.21 Celsius, Output -> Options];
			Lookup[options, EndTemperature],
			100.2 Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, TemperatureRampRate, "Specify the rate at which the temperature increases during each heating cycle ends:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], TemperatureRampRate -> 50 Celsius / Hour, Output -> Options];
			Lookup[options, TemperatureRampRate],
			50 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TemperatureRampRate, "EndTemperature must be specified to the closest 0.1 Celsius / Hour:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], TemperatureRampRate -> 50.22 Celsius / Hour, Output -> Options];
			Lookup[options, TemperatureRampRate],
			50.2 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "Specify the number of heating cycles to apply to each sample:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], NumberOfScans -> 3, Output -> Options];
			Lookup[options, NumberOfScans],
			3,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RescanCoolingRate, "Specify the rate at which the sample is cooled between heating cycles.  Note that NumberOfScans must be specified with RescanCoolingRate:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], RescanCoolingRate -> 250 Celsius / Hour, NumberOfScans -> 3, Output -> Options];
			Lookup[options, RescanCoolingRate],
			250 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RescanCoolingRate, "RescanCoolingRate must be specified to the closest 0.1 Celsius / Hour:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], RescanCoolingRate -> 250.21 Celsius / Hour, NumberOfScans -> 3, Output -> Options];
			Lookup[options, RescanCoolingRate],
			250.2 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options, Instrument, "Specify the DSC instrument on which this experiment will be run:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Instrument -> Object[Instrument, DifferentialScanningCalorimeter, "Mr. Fantastic"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, DifferentialScanningCalorimeter, "Mr. Fantastic"]],
			Variables :> {options}
		],
		(* post-pooling options *)
		Example[{Options, NestedIndexMatchingMix, "Indicates if the samples should be mixed after aliquoting or pooling:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> True];
			Download[prot, NestedIndexMatchingMixSamplePreparation[[All, Mix]]],
			{True, True},
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingMix, "NestedIndexMatchingMix is automatically set to True if PooledMixRate or NestedIndexMatchingMixTime are specified:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, PooledMixRate -> 2000 RPM, NestedIndexMatchingMixTime -> 5 Minute];
			Download[prot, NestedIndexMatchingMixSamplePreparation[[All, Mix]]],
			{True, True},
			Variables :> {prot}
		],
		Example[{Options, PooledMixRate, "Indicates the rate of mixing after aliquoting or pooling:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, PooledMixRate -> 2000 RPM];
			Download[prot, NestedIndexMatchingMixSamplePreparation[[All, MixRate]]],
			{2000 RPM, 2000 RPM},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingMixTime, "Indicates the duration of mixing after aliquoting or pooling:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingMixTime -> 5 Minute];
			Download[prot, NestedIndexMatchingMixSamplePreparation[[All, MixTime]]],
			{5 Minute, 5 Minute},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingCentrifuge, "Indicates if the samples should be centrifuged after aliquoting or pooling and pooled-mixing:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifuge -> True];
			Download[prot, NestedIndexMatchingCentrifugeSamplePreparation[[All, Centrifuge]]],
			{True, True},
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingCentrifuge, "NestedIndexMatchingCentrifuge is automatically set to True if NestedIndexMatchingMix is True:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> True];
			Download[prot, NestedIndexMatchingCentrifugeSamplePreparation[[All, Centrifuge]]],
			{True, True},
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingCentrifugeForce, "Indicates the force of centrifuging of after aliquoting or pooling and pooled-mixing:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifugeForce -> 850 GravitationalAcceleration];
			Download[prot, NestedIndexMatchingCentrifugeSamplePreparation[[All, CentrifugeIntensity]]],
			{850 GravitationalAcceleration, 850 GravitationalAcceleration},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingCentrifugeTime, "Indicates the duration of mixing after aliquoting or pooling and pooled-mixing:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifugeTime -> 5 Minute];
			Download[prot, NestedIndexMatchingCentrifugeSamplePreparation[[All, CentrifugeTime]]],
			{5 Minute, 5 Minute},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingIncubate, "Indicates if the samples should be incubated after aliquoting or pooling, pooled-mixing, and pooled-centrifuging:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingIncubate -> True];
			Download[prot, NestedIndexMatchingIncubateSamplePreparation[[All, Incubate]]],
			{True..},
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingIncubate, "NestedIndexMatchingIncubate is automatically set to True if PooledIncubationTime, NestedIndexMatchingIncubationTemperature, or NestedIndexMatchingAnnealingTime are specified:"},
			options = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, PooledIncubationTime -> 5 Minute, NestedIndexMatchingIncubationTemperature -> 40 Celsius, Output -> Options];
			Lookup[options, NestedIndexMatchingIncubate],
			True,
			Variables :> {options}
		],
		Example[{Options, PooledIncubationTime, "Indicates the duration of incubation after aliquoting or pooling, pooled-mixing, and pooled-centrifuging:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, PooledIncubationTime -> 5 Minute];
			Download[prot, NestedIndexMatchingIncubateSamplePreparation[[All, IncubationTime]]],
			{5 Minute, 5 Minute},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingIncubationTemperature, "Indicates the temperature of incubation after aliquoting or pooling, pooled-mixing, and pooled-centrifuging:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, NestedIndexMatchingIncubationTemperature -> 40 Celsius];
			Download[prot, NestedIndexMatchingIncubateSamplePreparation[[All, IncubationTemperature]]],
			{40 Celsius, 40 Celsius},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],
		Example[{Options, NestedIndexMatchingAnnealingTime, "Indicates the duration for which the samples remain in the thermal incubation instrument before being removed after aliquoting or pooling, pooled-mixing, and pooled-centrifuging:"},
			prot = ExperimentDifferentialScanningCalorimetry[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]}}, PooledIncubationTime -> 5 Minute, NestedIndexMatchingAnnealingTime -> 5 Minute];
			Download[prot, NestedIndexMatchingIncubateSamplePreparation[[All, AnnealingTime]]],
			{5 Minute, 5 Minute},
			EquivalenceFunction -> Equal,
			Variables :> {prot}
		],

    (* --- Additional option tests --- *)

    Example[{Additional, "Obtain a DSC read of a given DNA sample with no subtype:"},
      ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]],
      ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
    ],
    Example[{Additional, "Obtain a DSC read of a given PNA sample with no subtype:"},
      ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]],
      ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
    ],
    Example[{Additional, "Obtain a DSC read of a given PNA sample with no Model linked:"},
      ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 7 with no model in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]],
      ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
    ],

		(* --- Sample prep option tests --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentDifferentialScanningCalorimetry[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentDifferentialScanningCalorimetry[
				{"oligomer sample 1", "oligomer sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "oligomer sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "oligomer sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "oligomer sample 1", Amount -> 500 Microliter],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "oligomer sample 2", Amount -> 500 Microliter]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}

		],

		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubateAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Centrifuge -> True, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 400*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, AliquotAmount],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentDifferentialScanningCalorimetry[
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayVolume],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, Oligomer, "Test DNA oligomer identity model for DSC 1"], AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Test DNA oligomer identity model for DSC 1"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 400*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			{"A2"},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Destination well is automatically set differently if CleaningFrequency -> First:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], CleaningFrequency -> First, Output -> Options];
			Lookup[options, DestinationWell],
			{"A4"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentDifferentialScanningCalorimetry[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, DifferentialScanningCalorimetry]]
		],

		(* Tests *)
		Test["Populate the InjectionPlateSeal, RefillSample, and RunTime fields:",
			prot = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID]];
			Download[prot, {InjectionPlateSeal, RefillSample, RunTime}],
			{ObjectP[Model[Item, PlateSeal]], ObjectP[Model[Sample]], TimeP},
			Variables :> {prot}
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Model[Molecule, Oligomer, "Test DNA IM for DSC"<> $SessionUUID],
				Model[Molecule, Oligomer, "Test PNA IM for DSC"<> $SessionUUID],
				Model[Sample, "Test DNA oligomer model for DSC"<> $SessionUUID],
				Model[Sample, "Test PNA oligomer model for DSC"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetry testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 7 with no model in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 5 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 6 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 7 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Protocol, DifferentialScanningCalorimetry, "Already existing name"<> $SessionUUID],
				Object[Protocol, DifferentialScanningCalorimetry, "Protocol A63412B"],
				
				(* if it is NOT in the database then we can't Download from it so do this check here *)
				If[DatabaseMemberQ[Object[Protocol, DifferentialScanningCalorimetry, "Template protocol with 4 scans"<> $SessionUUID]],
					Download[Object[Protocol, DifferentialScanningCalorimetry, "Template protocol with 4 scans"<> $SessionUUID], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}],
					Nothing
				]
			}];
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					dnaIdentityModelPacket, pnaIdentityModelPacket, dnaIdentityModel, pnaIdentityModel, fakeBench, fakeProtocol,

					dnaModelPacket, pnaModelPacket,containerPackets, dnaModel, pnaModel,

					vessel1, vessel2, vessel3, vessel4, vessel5, vessel6, vessel7, vessel8, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,sample11, sample12, sample13,

					templateProtocol,

					allObjs

				},

				(*create the new identity models for the PNA and DNA used for the test models*)
				(* create some oligomer identity models*)
				dnaIdentityModelPacket = UploadOligomer["Test DNA IM for DSC"<> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA, Upload -> False];

				pnaIdentityModelPacket = UploadOligomer["Test PNA IM for DSC"<> $SessionUUID, Molecule -> ToStructure[Strand[Modification["Acetylated"], PNA["ACTATCGGATCA", "H'"], Modification["3'-6-azido-L-norleucine"]]], PolymerType -> PNA, Upload -> False];

				(*perform the fist upload*)
				{fakeProtocol,fakeBench,dnaIdentityModel,pnaIdentityModel}=Upload[{
					<|Type -> Object[Protocol, DifferentialScanningCalorimetry], Name -> "Already existing name"<> $SessionUUID, DeveloperObject -> True|>,
					<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID, DeveloperObject -> True|>,
					dnaIdentityModelPacket[[1]],
					pnaIdentityModelPacket[[1]]
				}];

				(*create all of the models*)
				dnaModelPacket = UploadSampleModel["Test DNA oligomer model for DSC"<> $SessionUUID,
					Composition -> {
						{0.1 Milli * Molar, Model[Molecule, Oligomer, "Test DNA IM for DSC"<> $SessionUUID]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					MSDSFile -> NotApplicable,
					DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				pnaModelPacket = UploadSampleModel["Test PNA oligomer model for DSC"<> $SessionUUID,
					Composition -> {
						{0.1 Milli * Molar, Model[Molecule, Oligomer, "Test PNA IM for DSC"<> $SessionUUID]},
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					MSDSFile -> NotApplicable,
					DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				containerPackets = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 2 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 3 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 4 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 5 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 6 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"2mL tube 7 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"Deep well plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID,
						"DSC plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID
					},
					Upload->False
				];

				(*upload everything*)
				{
					vessel1,
					vessel2,
					vessel3,
					vessel4,
					vessel5,
					vessel6,
					vessel7,
					vessel8,
					plate1,
					plate2,
					dnaModel,
					pnaModel
				}=Upload[Join[containerPackets,dnaModelPacket,pnaModelPacket]][[;;12]];

				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11,
					sample12,
					sample13
				} = UploadSample[
					{
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 2 (Deprecated)"],
						Model[Sample, "Test PNA oligomer model for DSC"<> $SessionUUID],
						Model[Sample, "Test PNA oligomer model for DSC"<> $SessionUUID],
						Model[Sample, "Test DNA oligomer model for DSC"<> $SessionUUID],
						Model[Sample, "Test DNA oligomer for DSC 1"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3},
						{"A1", vessel4},
						{"A1", plate1},
						{"A2", plate1},
						{"A1", plate2},
						{"A2", plate2},
						{"A3", plate2},
						{"A1", vessel5},
						{"A1", vessel6},
						{"A1", vessel7},
						{"A1", vessel8}
					},
					Name -> {
						"PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing (Discarded)"<> $SessionUUID,
						"PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetry testing (Deprecated)"<> $SessionUUID,
						"PNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"PNA sample 7 with no model in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID,
						"DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID
					},
					InitialAmount -> {
						200*Microliter,
						200*Microliter,
						400*Microliter,
						400*Microliter,
						1.8*Milliliter,
						1.8*Milliliter,
						400*Microliter,
						400*Microliter,
						400*Microliter,
						800*Microliter,
						800*Microliter,
						800*Microliter,
						5*Milliliter
					}
				];

				templateProtocol = ExperimentDifferentialScanningCalorimetry[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID], InjectionRate -> 70 Microliter / Second, NumberOfScans -> 4, Name -> "Template protocol with 4 scans"<> $SessionUUID];

				allObjs = Flatten[{
					vessel1, vessel2, vessel3, vessel4, vessel5, vessel6, vessel7, vessel8, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,sample11, sample12, sample13,
					Download[templateProtocol, {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}]
				}];

				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
					<|
						Object -> Object[Sample, "PNA sample 7 with no model in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
						Model -> Null
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Model[Molecule, Oligomer, "Test DNA IM for DSC"<> $SessionUUID],
				Model[Molecule, Oligomer, "Test PNA IM for DSC"<> $SessionUUID],
				Model[Sample, "Test DNA oligomer model for DSC"<> $SessionUUID],
				Model[Sample, "Test PNA oligomer model for DSC"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetry testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "DNA sample 6 in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],
				Object[Sample, "PNA sample 7 with no model in 2mL tube for ExperimentDifferentialScanningCalorimetry testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 5 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 6 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 7 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ExperimentDifferentialScanningCalorimetry tests"<> $SessionUUID],

				Object[Protocol, DifferentialScanningCalorimetry, "Already existing name"<> $SessionUUID],
        		(* if it is NOT in the database then we can't Download from it so do this check here *)
       			If[DatabaseMemberQ[Object[Protocol, DifferentialScanningCalorimetry, "Template protocol with 4 scans"<> $SessionUUID]],
					Download[Object[Protocol, DifferentialScanningCalorimetry, "Template protocol with 4 scans"<> $SessionUUID], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}],
					Nothing
				]
     		}];
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetryOptions*)

DefineTests[ExperimentDifferentialScanningCalorimetryOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for pooling multiple samples together:"},
			ExperimentDifferentialScanningCalorimetryOptions[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID] Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID]}}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], OutputFormat -> List],
			{__Rule},
			Variables :> {options}
		],
		Example[{Options, AutosamplerTemperature, "Specify the temperature the injection plate should be held at prior to injection:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], AutosamplerTemperature -> 4 Celsius, OutputFormat -> List];
			Lookup[options, AutosamplerTemperature],
			4 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, InjectionVolume, "Specify the amount of sample that is injected onto the DSC instrument:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], InjectionVolume -> 260 Microliter, OutputFormat -> List];
			Lookup[options, InjectionVolume],
			260 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, InjectionRate, "Specify the rate each sample is injected onto the DSC instrument:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], InjectionRate -> 110 Microliter / Second, OutputFormat -> List];
			Lookup[options, InjectionRate],
			110 Microliter / Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CleaningFrequency, "Specify when to clean with detergent before or between sample runs:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], CleaningFrequency -> First, OutputFormat -> List];
			Lookup[options, CleaningFrequency],
			First,
			Variables :> {options}
		],
		Example[{Options, Blanks, "Specify the samples or models that will be used to blank the sample's DSC readings:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], Blanks -> Model[Sample, StockSolution, "1X UV buffer"], OutputFormat -> List];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "1X UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, StartTemperature, "Specify the temperature at which each heating cycle starts:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], StartTemperature -> 1 Celsius, OutputFormat -> List];
			Lookup[options, StartTemperature],
			1 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, EndTemperature, "Specify the temperature at which each heating cycle ends:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], EndTemperature -> 100 Celsius, OutputFormat -> List];
			Lookup[options, EndTemperature],
			100 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TemperatureRampRate, "Specify the rate at which the temperature increases during each heating cycle ends:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], TemperatureRampRate -> 50 Celsius / Hour, OutputFormat -> List];
			Lookup[options, TemperatureRampRate],
			50 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "Specify the number of heating cycles to apply to each sample:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], NumberOfScans -> 3, OutputFormat -> List];
			Lookup[options, NumberOfScans],
			3,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RescanCoolingRate, "Specify the rate at which the sample is cooled between heating cycles.  Note that NumberOfScans must be specified with RescanCoolingRate:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], RescanCoolingRate -> 250 Celsius / Hour, NumberOfScans -> 3, OutputFormat -> List];
			Lookup[options, RescanCoolingRate],
			250 Celsius / Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Instrument, "Specify the DSC instrument on which this experiment will be run:"},
			options = ExperimentDifferentialScanningCalorimetryOptions[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID], Instrument -> Object[Instrument, DifferentialScanningCalorimeter, "Mr. Fantastic"], OutputFormat -> List];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, DifferentialScanningCalorimeter, "Mr. Fantastic"]],
			Variables :> {options}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,

					vessel1, vessel2, vessel3, vessel4, vessel5, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,

					allObjs

				},
				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID, DeveloperObject -> True|>];

				{
					vessel1,
					vessel2,
					vessel3,
					vessel4,
					vessel5,
					plate1,
					plate2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"2mL tube 2 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"2mL tube 3 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"2mL tube 4 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"Deep well plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID,
						"DSC plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10
				} = UploadSample[
					{
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 2 (Deprecated)"],
						Model[Sample, "Test DNA oligomer for DSC 1"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3},
						{"A1", vessel4},
						{"A1", plate1},
						{"A2", plate1},
						{"A1", plate2},
						{"A2", plate2},
						{"A3", plate2},
						{"A1", vessel5}
					},
					Name -> {
						"PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing (Discarded)"<> $SessionUUID,
						"PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID,
						"PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing (Deprecated)"<> $SessionUUID,
						"DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID
					},
					InitialAmount -> {
						200*Microliter,
						200*Microliter,
						400*Microliter,
						400*Microliter,
						1.8*Milliliter,
						1.8*Milliliter,
						400*Microliter,
						400*Microliter,
						400*Microliter,
						5*Milliliter
					}
				];

				allObjs = {
					vessel1, vessel2, vessel3, vessel4, vessel5, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10
				};

				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
					<|
						Object -> Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
						Concentration -> 2 Millimolar,
						Replace[ConcentrationLog] -> {{Now, 2 Millimolar, Link[$PersonID]}}
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryOptions testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ExperimentDifferentialScanningCalorimetryOptions testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ExperimentDifferentialScanningCalorimetryOptions testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ExperimentDifferentialScanningCalorimetryOptions tests"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentDifferentialScanningCalorimetryPreview*)

DefineTests[ExperimentDifferentialScanningCalorimetryPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentDifferentialScanningCalorimetryPreview[Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentDifferentialScanningCalorimetryPreview[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID]}}],
			Null
		],
		Example[{Basic, "Return Null for multiple pooled samples:"},
			ExperimentDifferentialScanningCalorimetryPreview[{{Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID]}}],
			Null
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,

					vessel1, vessel2, vessel3,
					sample1, sample2, sample3,

					allObjs

				},
				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID, DeveloperObject -> True|>];

				{
					vessel1,
					vessel2,
					vessel3
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID,
						"2mL tube 2 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID,
						"2mL tube 3 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3}
					},
					Name -> {
						"PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID,
						"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID,
						"PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID
					},
					InitialAmount -> {
						200*Microliter,
						200*Microliter,
						400*Microliter
					}
				];

				allObjs = {
					vessel1, vessel2, vessel3,
					sample1, sample2, sample3
				};

				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ allObjs
				}]]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ExperimentDifferentialScanningCalorimetryPreview testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ExperimentDifferentialScanningCalorimetryPreview tests"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDifferentialScanningCalorimetryQ*)

DefineTests[ValidExperimentDifferentialScanningCalorimetryQ,
	{
		Example[{Basic, "Determine the validity of a DSC call on one sample:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]],
			True
		],
		Example[{Basic, "Determine the validity of a DSC call on multiple pooled samples:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], NumberOfScans -> 1, RescanCoolingRate -> 300 Celsius / Hour, Verbose -> Failures],
			False
		],
		Example[{Messages, "RescanCoolingRateIncompatible", "If RescanCoolingRate is specified, NumberOfScans must be greater than 1:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], NumberOfScans -> 1, RescanCoolingRate -> 300 Celsius / Hour],
			False
		],
		Example[{Messages, "RescanCoolingRateIncompatible", "If RescanCoolingRate is Null, NumberOfScans must not be greater than 1:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], NumberOfScans -> 2, RescanCoolingRate -> Null],
			False
		],
		Example[{Messages, "DestinationWellInvalid", "If the DestinationWell option is specified, limitations of the DSC instrument dictate that it must only choose even wells and only use the first n wells of the plate:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, DestinationWell -> {"A2", "A3"}],
			False
		],
		Example[{Messages, "AliquotContainerOccupied", "If the AliquotContainer option is specified as a plate object, the plate must be empty:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, AliquotContainer -> {Object[Container, Plate, "DSC plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID], Object[Container, Plate, "DSC plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID]}],
			False
		],
		Example[{Messages, "PooledMixMismatch", "If NestedIndexMatchingMix -> False, NestedIndexMatchingMixTime and PooledMixRate cannot be specified:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> False, NestedIndexMatchingMixTime -> 5 Minute, PooledMixRate -> 2000 RPM],
			False
		],
		Example[{Messages, "PooledMixMismatch", "If NestedIndexMatchingMix -> True, NestedIndexMatchingMixTime and PooledMixRate cannot be Null:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingMix -> True, NestedIndexMatchingMixTime -> Null, PooledMixRate -> Null],
			False
		],
		Example[{Messages, "PooledCentrifugeMismatch", "If NestedIndexMatchingCentrifuge -> False, NestedIndexMatchingCentrifugeTime and NestedIndexMatchingCentrifugeForce cannot be specified:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifuge -> False, NestedIndexMatchingCentrifugeTime -> 5 Minute, NestedIndexMatchingCentrifugeForce -> 850 GravitationalAcceleration],
			False
		],
		Example[{Messages, "PooledCentrifugeMismatch", "If NestedIndexMatchingCentrifuge -> True, NestedIndexMatchingCentrifugeTime and NestedIndexMatchingCentrifugeForce cannot be Null:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingCentrifuge -> True, NestedIndexMatchingCentrifugeTime -> Null, NestedIndexMatchingCentrifugeForce -> Null],
			False
		],
		Example[{Messages, "PooledIncubateMismatch", "If NestedIndexMatchingIncubate -> False, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime cannot be specified:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingIncubate -> False, PooledIncubationTime -> 5 Minute, NestedIndexMatchingIncubationTemperature -> 40 Celsius, NestedIndexMatchingAnnealingTime -> 5 Minute],
			False
		],
		Example[{Messages, "PooledIncubateMismatch", "If NestedIndexMatchingIncubate -> True, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, and NestedIndexMatchingAnnealingTime cannot be Null:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, {Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}}, NestedIndexMatchingIncubate -> True, PooledIncubationTime -> Null, NestedIndexMatchingIncubationTemperature -> Null, NestedIndexMatchingAnnealingTime -> Null],
			False
		],
		Example[{Messages, "DuplicateName", "The Name option must not be the name of an already-existing DSC protocol:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, Name -> "Already existing name for ValidExperimentDifferentialScanningCalorimetryQ"<> $SessionUUID],
			False
		],
		Example[{Messages, "DiscardedSamples", "Samples that are discarded cannot be provided:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "DNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing (Discarded)"<> $SessionUUID]],
			False
		],
		Example[{Messages, "DeprecatedModels", "Samples whose models are deprecated cannot be provided:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 5 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing (Deprecated)"<> $SessionUUID]],
			False
		],
		Example[{Messages, "StartTemperatureAboveEndTemperature", "StartTemperature may not be above EndTemperature:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], StartTemperature -> 50 Celsius, EndTemperature -> 40 Celsius],
			False
		],
		Example[{Messages, "DSCTooManySamples", "An error is thrown if too many samples are run in a single protocol:"},
			ValidExperimentDifferentialScanningCalorimetryQ[Object[Sample, "PNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID], NumberOfReplicates -> 43],
			False
		],
		Example[{Messages, "CleaningFrequencyTooHigh", "Specify when to clean with detergent before or between sample runs:"},
			ValidExperimentDifferentialScanningCalorimetryQ[{Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID]}, CleaningFrequency -> 3],
			False
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Protocol, DifferentialScanningCalorimetry, "Already existing name for ValidExperimentDifferentialScanningCalorimetryQ"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench, fakeProtocol,

					vessel1, vessel2, vessel3, vessel4, vessel5, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,

					allObjs

				},
				fakeProtocol = Upload[<|Type -> Object[Protocol, DifferentialScanningCalorimetry], Name -> "Already existing name for ValidExperimentDifferentialScanningCalorimetryQ"<> $SessionUUID, DeveloperObject -> True|>];
				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID, DeveloperObject -> True|>];

				{
					vessel1,
					vessel2,
					vessel3,
					vessel4,
					vessel5,
					plate1,
					plate2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 500uL Round Bottom DSC Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"2mL tube 2 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"2mL tube 3 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"2mL tube 4 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"50mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"Deep well plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID,
						"DSC plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10
				} = UploadSample[
					{
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 1"],
						Model[Sample, "Test DNA oligomer for DSC 1"],
						Model[Sample, "Test PNA oligomer for DSC 2 (Deprecated)"],
						Model[Sample, "Test DNA oligomer for DSC 1"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3},
						{"A1", vessel4},
						{"A1", plate1},
						{"A2", plate1},
						{"A1", plate2},
						{"A2", plate2},
						{"A3", plate2},
						{"A1", vessel5}
					},
					Name -> {
						"PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"DNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing (Discarded)"<> $SessionUUID,
						"PNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"DNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"PNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"DNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID,
						"PNA sample 5 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing (Deprecated)"<> $SessionUUID,
						"DNA sample 5 in 50mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID
					},
					InitialAmount -> {
						200*Microliter,
						200*Microliter,
						400*Microliter,
						400*Microliter,
						1.8*Milliliter,
						1.8*Milliliter,
						400*Microliter,
						400*Microliter,
						400*Microliter,
						5*Milliliter
					}
				];

				allObjs = {
					vessel1, vessel2, vessel3, vessel4, vessel5, plate1, plate2,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10
				};

				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ allObjs,
					<|
						Object -> Object[Sample, "DNA sample 5 in 50mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
						Concentration -> 2 Millimolar,
						Replace[ConcentrationLog] -> {{Now, 2 Millimolar, Link[$PersonID]}}
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjects},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Sample, "PNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 1 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 2 in 2mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing (Discarded)"<> $SessionUUID],
				Object[Sample, "PNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 3 in deep well plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "DNA sample 4 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],
				Object[Sample, "PNA sample 5 in DSC plate for ValidExperimentDifferentialScanningCalorimetryQ testing (Deprecated)"<> $SessionUUID],
				Object[Sample, "DNA sample 5 in 50mL tube for ValidExperimentDifferentialScanningCalorimetryQ testing"<> $SessionUUID],

				Object[Container, Plate, "Deep well plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Plate, "DSC plate 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 2 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 3 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2mL tube 4 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Container, Vessel, "50mL tube 1 for ValidExperimentDifferentialScanningCalorimetryQ tests"<> $SessionUUID],

				Object[Protocol, DifferentialScanningCalorimetry, "Already existing name for ValidExperimentDifferentialScanningCalorimetryQ"<> $SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjs, DatabaseMemberQ[allObjs]];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];
