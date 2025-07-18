(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentThermalShift: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentThermalShift*)

DefineTests[ExperimentThermalShift,
	{
		(*===Basic examples===*)
		Example[{Basic, "Generate a thermal shift protocol to analyze a list of singleton oligomer sample inputs:"},
			ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Basic, "Generate a thermal shift protocol to analyze a list of singleton protein sample inputs:"},
			ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]}],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Basic, "Generates a thermal shift protocol from a nested list of inputs by pooling inputs within the same nested list:"},
			ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				{Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]}}, AliquotAmount -> {{50 * Microliter, 50 * Microliter}, {50 * Microliter, 50 * Microliter}}, AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Basic, "Generates a thermal shift protocol from a list of singleton containers by treating each well inside the container as an independent input sample:"},
			ExperimentThermalShift[{Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]}],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Basic, "Generates a thermal shift protocol from a nested list of containers by pooling all the samples in the container:"},
			ExperimentThermalShift[{{Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]}}, AliquotAmount -> 50 * Microliter, AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Basic, "Generates a thermal shift protocol from a sample model:"},
			ExperimentThermalShift[Model[Sample,"Milli-Q water"]],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::UnknownAnalytes
			}
		],

		(*===Additional examples===*)
		Example[{Additional, "Generates a thermal shift protocol from a mixed list of inputs by pooling any inputs within a nested list and keeping all other inputs independent:"},
			ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}}, AliquotAmount -> {50 * Microliter, 50 * Microliter, {50 * Microliter, 50 * Microliter}}, AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			ObjectP[Object[Protocol, ThermalShift]]
		],
		Example[{Additional, "Generates a thermal shift protocol from a model-less sample:"},
			ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID]],
			ObjectP[Object[Protocol, ThermalShift]]
		],

		(*===Messages tests===*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentThermalShift[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentThermalShift[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentThermalShift[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentThermalShift[Object[Container, Vessel, "id:12345678"]],
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
					Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentThermalShift[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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
					Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentThermalShift[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "TooManyTemperatureRampOptions", "Temperature ramp options for both linear and step ramps cannot be specified:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfReplicates -> Null,
				TemperatureResolution -> 1 * Celsius,
				NumberOfTemperatureRampSteps -> 10
			],
			$Failed,
			Messages :> {
				Error::TooManyTemperatureRampOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleTemperatureRamp", "If TemperatureRamping is Linear, step ramp options cannot be specified:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Linear,
				NumberOfTemperatureRampSteps -> 10
			],
			$Failed,
			Messages :> {
				Error::IncompatibleTemperatureRamp,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooFewTemperatureRampOptions", "If TemperatureRamping is Automatic, both linear and step options cannot be Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureResolution -> Null,
				NumberOfTemperatureRampSteps -> Null
			],
			$Failed,
			Messages :> {
				Error::TooFewTemperatureRampOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidNullTemperatureRampOptions", "If TemperatureRamping is Linear, the TemperatureResolution cannot be Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Linear,
				TemperatureResolution -> Null
			],
			$Failed,
			Messages :> {
				Error::InvalidNullTemperatureRampOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidNullTemperatureRampOptions", "If TemperatureRamping is Step, the NumberOfTemperatureRampSteps or StepHoldTime cannot be Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Step,
				NumberOfTemperatureRampSteps -> Null
			],
			$Failed,
			Messages :> {
				Error::InvalidNullTemperatureRampOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidNestedIndexMatchingMixOptions", "NestedIndexMatchingMix and mixing options cannot conflict:"},
			ExperimentThermalShift[
				{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]},
				NestedIndexMatchingMix -> False,
				NestedIndexMatchingMixType -> Pipette
			],
			$Failed,
			Messages :> {
				Error::InvalidNestedIndexMatchingMixOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleMixOptions", "NestedIndexMatchingMix Options cannot be in conflict:"},
			ExperimentThermalShift[
				{{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]}},
				NestedIndexMatchingMix -> True,
				NestedIndexMatchingMixType -> Invert,
				NestedIndexMatchingMixVolume -> 10 * Microliter
			],
			$Failed,
			Messages :> {
				Error::IncompatibleMixOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidNestedIndexMatchingIncubateOptions", "NestedIndexMatchingIncubate and incubation options cannot conflict:"},
			ExperimentThermalShift[
				{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]},
				NestedIndexMatchingIncubate -> False,
				NestedIndexMatchingIncubationTemperature -> 50 * Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidNestedIndexMatchingIncubateOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleSampleStorageOptions", "ContainerOut and SamplesOutStorageCondition cannot conflict:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				ContainerOut -> Null,
				SamplesOutStorageCondition -> Freezer
			],
			$Failed,
			Messages :> {
				Error::IncompatibleSampleStorageOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidEmissionOptions", "EmissionWavelength, MinEmissionWavelength, and MaxEmissionWavelength cannot conflict:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				EmissionWavelength -> 500 * Nanometer,
				MinEmissionWavelength -> 450 * Nanometer,
				MaxEmissionWavelength -> 600 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::InvalidEmissionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleEmissionRangeOptions", "MinEmissionWavelength and MaxEmissionWavelength cannot conflict:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinEmissionWavelength -> 650 * Nanometer,
				MaxEmissionWavelength -> 400 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::IncompatibleEmissionRangeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidPassiveReferenceOptions", "PassiveReference and PassiveReferenceVolume cannot conflict:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				PassiveReference -> Null,
				PassiveReferenceVolume -> 5 * Microliter
			],
			$Failed,
			Messages :> {
				Error::InvalidPassiveReferenceOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleDetectionReagentOptions", "DetectionReagent and DetectionReagentVolume cannot conflict:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DetectionReagent -> Null,
				DetectionReagentVolume -> 5 * Microliter
			],
			$Failed,
			Messages :> {
				Error::IncompatibleDetectionReagentOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyDilutionCurveOptions", "Both SerialDilutionCurve and DilutionCurve options cannot be specified for a given sample:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionCurve -> {{{20 * Microliter, 40 * Microliter}, {20 * Microliter, 20 * Microliter}}}
			],
			$Failed,
			Messages :> {
				Error::TooManyDilutionCurveOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleDilutionCurveOptions", "SerialDilutionCurve and DilutionCurve cannot conflict with dilution options:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{Null}},
				DilutionCurve -> {{Null}},
				DilutionMixVolume -> {{5 * Microliter}}
			],
			$Failed,
			Messages :> {
				Error::IncompatibleDilutionCurveOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidTemperatureRamp", "MinTemperature cannot be less than MaxTemperature:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinTemperature -> 50 * Celsius,
				MaxTemperature -> 25 * Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidTemperatureRamp,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleAnalytes", "Analytes types must be compatible with this assay, either nucleotide or protein analytes:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test polymer sample" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::IncompatibleAnalytes
			}
		],
		Example[{Messages, "UnknownAnalytes", "Give a warning if analytes cannot be identified:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test water sample" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::UnknownAnalytes
			}
		],
		Example[{Messages, "MoreThanOneTypeOfAnalyte", "Give a warning if more than one type of analyte present:"},
			ExperimentThermalShift[
				{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::MoreThanOneTypeOfAnalyte
			}
		],
		Example[{Messages, "RecommendedInstrument", "Give a warning if the specified instrument is not recommended for the type of analyte:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"]
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::RecommendedInstrument
			}
		],
		Example[{Messages, "InvalidPoolMixVolumes", "Return an error if the specified pool mix volume is greater than the available pool volume:"},
			ExperimentThermalShift[
				{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{10 * Microliter, 10 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMixVolume -> 100 * Microliter
			],
			$Failed,
			Messages :> {
				Error::InvalidPoolMixVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDetectionReagentVolumes", "Return an error if the specified detection reagent volume cannot be resolved:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				DetectionReagent -> Model[Sample, "Milli-Q water"],
				ExcitationWavelength -> 470 * Nanometer,
				EmissionWavelength -> 520 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::InvalidDetectionReagentVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidSampleVolumes", "Return an error if the resolved sample volume is negative:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ReactionVolume -> 10 * Microliter,
				BufferVolume -> 20 * Microliter
			],
			$Failed,
			Messages :> {
				Error::InvalidSampleVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidBufferVolumes", "Return an error if the resolved buffer volume is negative:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ReactionVolume -> 10 * Microliter,
				SampleVolume -> 20 * Microliter
			],
			$Failed,
			Messages :> {
				Error::InvalidBufferVolumes ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDilutionMixVolumes", "Return an error if the resolved dilution mix volume is greater than the smallest dilution volume:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				SerialDilutionCurve -> {{{10 * Microliter, 10 * Microliter, 3}}},
				DilutionMixVolume -> {{100 * Microliter}}
			],
			$Failed,
			Messages :> {
				Error::InvalidDilutionMixVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidDilutionContainers", "Return an error if the resolved dilution container fill volume is less than the largest dilution volume:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				SerialDilutionCurve -> {{{1.5 * Milliliter, 1.5 * Milliliter, 3}}},
				DilutionContainer -> {{{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}}
			],
			$Failed,
			Messages :> {
				Error::InvalidDilutionContainers,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidThermocyclerOptions", "Return an error if detection parameters are specified that are not compatible with the Thermocycler:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				StaticLightScatteringExcitationWavelength -> {{266 * Nanometer}}
			],
			$Failed,
			Messages :> {
				Error::InvalidThermocyclerOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidEmissionRange", "Return an error if an emission range is specified and the instrument is a Thermocycler:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				MinEmissionWavelength -> 250 * Nanometer,
				MaxEmissionWavelength -> 400 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::InvalidEmissionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidMultiModeSpectrometerOptions", "Return an error if the instrument is a MultimodeSpectrophotometer and any of the laser power or static light scatter options are Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				StaticLightScatteringLaserPower -> Null
			],
			$Failed,
			Messages :> {
				Error::InvalidMultiModeSpectrometerOptions ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidLaserOptimization", "Return a warning if the instrument is a Thermocycler and OptimizeFluorescenceLaserPower is True:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::InvalidLaserOptimization
			}
		],
		Example[{Messages, "InvalidLaserOptimization", "Return a warning if the instrument is a Thermocycler and LaserOptimizationEmissionWavelengthRange is not Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				LaserOptimizationEmissionWavelengthRange -> 250 Nanometer ;; 700 Nanometer
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::InvalidLaserOptimization
			}
		],
		Example[{Messages, "InvalidLaserOptimization", "Return a warning if the instrument is a Thermocycler and LaserOptimizationTargetEmissionIntensityRange is not Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				LaserOptimizationTargetEmissionIntensityRange -> 10 Percent ;; 90 Percent
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::InvalidLaserOptimization
			}
		],
		Example[{Messages, "UnusedOptimizationParameters", "Return a warning if the OptimizeFluorescenceLaserPower is False but OptimizeStaticLightScatteringLaserPower is True:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> False,
				OptimizeStaticLightScatteringLaserPower -> True
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::UnusedOptimizationParameters
			}
		],
		Example[{Messages, "UnusedOptimizationParameters", "Return a warning if the OptimizeFluorescenceLaserPower is False but LaserOptimizationEmissionWavelengthRange is not Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> False,
				LaserOptimizationEmissionWavelengthRange -> 250 Nanometer ;; 700 Nanometer
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::UnusedOptimizationParameters
			}
		],
		Example[{Messages, "UnusedOptimizationParameters", "Return a warning if the OptimizeFluorescenceLaserPower is False but LaserOptimizationTargetEmissionIntensityRange is not Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> False,
				LaserOptimizationTargetEmissionIntensityRange -> 10 Percent ;; 90 Percent
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {
				Warning::UnusedOptimizationParameters
			}
		],
		Example[{Messages, "IncompatibleExcitationWavelength", "Return an error if the specified excitation wavelength is not within the operating range of the resolved instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				ExcitationWavelength -> 305 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::IncompatibleExcitationWavelength ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleEmissionOptions", "Return an error if the specified emission options are not within the operating range of the resolved instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				EmissionWavelength -> 305 * Nanometer
			],
			$Failed,
			Messages :> {
				Error::IncompatibleEmissionOptions ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidTemperatureResolution", "Return an error if the specified temperature resolution option is specified but the resolved instrument in a thermocycler:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				TemperatureResolution -> 1 * Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidTemperatureResolution ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleTemperatureResolution", "Return an error if the specified temperature resolution option is not within the operating limits of the instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureResolution -> 0.01 * Celsius
			],
			$Failed,
			Messages :> {
				Error::IncompatibleTemperatureResolution ,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidRampRate", "Return an error if the specified temperature ramp rate is not within the operating limits of the instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRampRate -> 11 * Celsius / Minute
			],
			$Failed,
			Messages :> {
				Warning::InstrumentPrecision,
				Error::InvalidRampRate,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidMinTemperature", "Return an error if the specified minimum temperature is not within the operating limits of the instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinTemperature -> 10 * Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidMinTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidMaxTemperature", "Return an error if the specified maximum temperature is not within the operating limits of the instrument:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MaxTemperature -> 100 * Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidMaxTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManySamples", "Return an error if the total number of samples exceeds the instrument container capacity:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfReplicates -> 100
			],
			$Failed,
			Messages :> {
				Error::TooManySamples,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidContainerOut", "Return an error if a ContainerOut is specified but the resolved instrument is a multimodespectrophotometer:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				ContainerOut -> Model[Container, Vessel, "2mL Tube"],
				SamplesOutStorageCondition -> Refrigerator
			],
			$Failed,
			Messages :> {
				Error::InvalidContainerOut,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidNumberOfCycles", "Return an error if the number of cycles is greater than 0.5 but the resolved instrument is a thermocycler:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				NumberOfCycles -> 2
			],
			$Failed,
			Messages :> {
				Error::InvalidNumberOfCycles,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingThermalShiftDLSOptions", "If DynamicLightScattering is False, none of the DLS-related options can be specified:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> False,
				NumberOfDynamicLightScatteringAcquisitions -> 4
			],
			$Failed,
			Messages :> {
				Error::ConflictingThermalShiftDLSOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingThermalShiftNullDLSOptions", "If DynamicLightScattering is True, none of the DynamicLightScatteringMeasurements, NumberOfDynamicLightScatteringAcquisitions, or DynamicLightScatteringAcquisitionTime options can be Null:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				NumberOfDynamicLightScatteringAcquisitions -> Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingThermalShiftNullDLSOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingThermalShiftDynamicLightScatteringInstrument", "If DynamicLightScattering is True, the Instrument must be a MultimodeSpectrophotometer:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				DynamicLightScattering -> True,
				Instrument -> Model[Instrument, Thermocycler, "ViiA 7"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingThermalShiftDynamicLightScatteringInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingThermalShiftAutomaticDLSLaserOptions", "If AutomaticDynamicLightScatteringLaserSettings is True, neither the DynamicLightScatteringLaserPower nor the DynamicLightScatteringDiodeAttenuation options can be specified:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				AutomaticDynamicLightScatteringLaserSettings -> True,
				DynamicLightScatteringLaserPower -> 50 * Percent
			],
			$Failed,
			Messages :> {
				Error::ConflictingThermalShiftAutomaticDLSLaserOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDLSMeasurementRequestedTemperatures", "DynamicLightScatteringMeasurementTemperatures must be defined for each DynamicLightScatteringMeasurements:"},
			ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringMeasurements -> {Before, After},
				DynamicLightScatteringMeasurementTemperatures -> 25 * Celsius
			],
			$Failed,
			Messages :> {
				Error::ConflictingDLSMeasurementRequestedTemperatures,
				Error::InvalidOption
			}
		],
		(* - Option precisions - *)
		Example[{Options, DynamicLightScatteringAcquisitionTime, "Rounds specified DynamicLightScatteringAcquisitionTime to the nearest 1 second:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringAcquisitionTime -> 4.03 * Second,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringAcquisitionTime],
			4 * Second,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, DynamicLightScatteringLaserPower, "Rounds specified DynamicLightScatteringLaserPower to the nearest 1%:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringLaserPower -> 45.483 * Percent,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringLaserPower],
			45 * Percent,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, DynamicLightScatteringDiodeAttenuation, "Rounds specified DynamicLightScatteringDiodeAttenuation to the nearest 1%:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringDiodeAttenuation -> 5.67 * Percent,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringDiodeAttenuation],
			6 * Percent,
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Options, DynamicLightScatteringCapillaryLoading, "The CapillaryLoading option defaults to Manual:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringCapillaryLoading],
			Manual,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringCapillaryLoading, "The CapillaryLoading option can be set to Manual:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringCapillaryLoading -> Manual,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringCapillaryLoading],
			Manual,
			Variables :> {options}
		],
		(*===Options tests===*)
		Example[{Options, Name, "Give a Name to the generated thermal shift protocol:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Name -> "my protocol",
				Output -> Options
			];
			Lookup[options, Name],
			"my protocol",
			Variables :> {options}
		],
		Example[{Options, Template, "Use a template protocol whose methodology should be reproduced in running this experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Template -> Object[Protocol, ThermalShift, "Test ThermalShift option template protocol" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, MultimodeSpectrophotometer, "Uncle"]],
			EquivalenceFunction -> MatchQ,
			Variables :> {options}
		],
		Example[{Options, Instrument, "Generates a thermal shift protocol utilizing a multimode spectrophotometer:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, MultimodeSpectrophotometer, "Uncle"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "Generates a thermal shift protocol utilizing a thermocycler:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Instrument -> Model[Instrument, Thermocycler, "ViiA 7"],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, Thermocycler, "ViiA 7"]],
			Variables :> {options}
		],
		Example[{Options, ReactionVolume, "Specify the final reaction volume of the assay:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], ReactionVolume -> 15 * Microliter,
				Output -> Options
			];
			Lookup[options, ReactionVolume],
			15 * Microliter,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Specify the number of replicates of each sample:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], NumberOfReplicates -> 3,
				Output -> Options
			];
			{Lookup[options, NumberOfReplicates]},
			{3},
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "NumberOfReplicates is automatically set to 2 if using a MultimodeSpectrophotometer:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			2,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "NumberOfReplicates is automatically set to Null if using a Thermocycler:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Instrument -> Model[Instrument, Thermocycler, "ViiA 7"],
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			Null,
			Variables :> {options}
		],
		Example[{Options, AnalyteType, "Specify the type of analyte of interest in each pool:"},
			Lookup[ExperimentThermalShift[
				{
					{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
					{Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]}
				},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}, {50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				AnalyteType -> {Oligomer, Oligomer},
				Output -> Options],
				{AnalyteType}],
			{{Oligomer, Oligomer}}
		],
		Example[{Options, AliquotContainer, "Specify the aliquot container that hold the samples for measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options],
				AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
		],
		Example[{Options, ConsolidateAliquots, "Use ConsolidateAliquots options to indicate if identical aliquots should be prepared in the same position:"},
			Lookup[ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				AliquotAmount -> {50 * Microliter, 50 * Microliter},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				ConsolidateAliquots -> True,
				Output -> Options],
				ConsolidateAliquots],
			True
		],
		Example[{Options, NestedIndexMatchingMix, "Indicate that the pooled samples should be mixed prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMix -> True, Output -> Options],
				{NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingMixVolume, NestedIndexMatchingNumberOfMixes}],
			{True, Pipette, 50.` Microliter, 5}
		],
		Example[{Options, NestedIndexMatchingMixType, "Indicate the type of mixing that the pooled samples should be mixed prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMix -> True, Output -> Options],
				{NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingMixVolume, NestedIndexMatchingNumberOfMixes}],
			{True, Pipette, 50.` Microliter, 5}
		],
		Example[{Options, NestedIndexMatchingMixVolume, "Indicate volume that the pooled samples should be pipetted up and down for mixing prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMix -> True, Output -> Options],
				{NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingMixVolume, NestedIndexMatchingNumberOfMixes}],
			{True, Pipette, 50.` Microliter, 5}
		],
		Example[{Options, NestedIndexMatchingNumberOfMixes, "Indicate the number of times that the pooled samples should be mixed by pipetting or inversion prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMix -> True, Output -> Options],
				{NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingMixVolume, NestedIndexMatchingNumberOfMixes}],
			{True, Pipette, 50.` Microliter, 5}
		],
		Example[{Options, NestedIndexMatchingMix, "Indicate that some of the pools should be mixed prior to measurement, but not all:"},
			Lookup[ExperimentThermalShift[
				{
					{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
					{Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]}
				},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}, {50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingMix -> {False, True},
				Output -> Options],
				{NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingMixVolume, NestedIndexMatchingNumberOfMixes}],
			{{False, True}, {Null, Pipette}, {Null, 50.` Microliter}, {Null, 5}}
		],
		Example[{Options, NestedIndexMatchingIncubate, "Indicate that the pooled samples should be incubated prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingIncubate -> True, Output -> Options],
				{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}],
			{True, 5 * Minute, 85 * Celsius, 3 * Hour}
		],
		Example[{Options, PooledIncubationTime, "Indicate the time that the pooled samples should be incubated prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingIncubate -> True, Output -> Options],
				{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}],
			{True, 5 * Minute, 85 * Celsius, 3 * Hour}
		],
		Example[{Options, NestedIndexMatchingIncubationTemperature, "Indicate the temperature at which the pooled samples should be incubated prior to measurement:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingIncubate -> True, Output -> Options],
				{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}],
			{True, 5 * Minute, 85 * Celsius, 3 * Hour}
		],
		Example[{Options, NestedIndexMatchingAnnealingTime, "Indicate the time that the pooled samples should be kept in the incubation instrument before being removed, allowing the system to settle to room temperature:"},
			Lookup[ExperimentThermalShift[{{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]}},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingIncubate -> True, Output -> Options],
				{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}],
			{True, 5 * Minute, 85 * Celsius, 3 * Hour}
		],
		Example[{Options, NestedIndexMatchingIncubate, "Indicate that some of the pools should be incubated prior to measurement, but not all:"},
			Lookup[ExperimentThermalShift[
				{
					{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
					{Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]}
				},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}, {50 * Microliter, 50 * Microliter}},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				NestedIndexMatchingIncubate -> {False, True},
				Output -> Options],
				{NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime}],
			{{False, True}, {Null, 5 * Minute}, {Null, 85 * Celsius}, {Null, 3 * Hour}}
		],
		Example[{Options, SampleVolume, "Indicate the volume of the input samples in the final reaction:"},
			Lookup[ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]
				},
				SampleVolume -> {10 * Microliter, 15 * Microliter},
				Output -> Options],
				SampleVolume
			],
			{10 * Microliter, 15 * Microliter}
		],
		Example[{Options, Buffer, "Indicate a buffer to add to the final reaction for each sample:"},
			Lookup[ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]
				},
				Buffer -> Model[Sample, "Nuclease-free Water"],
				BufferVolume -> {5 * Microliter, 10 * Microliter},
				Output -> Options],
				Buffer
			],
			ObjectP[Model[Sample, "Nuclease-free Water"]]
		],
		Example[{Options, BufferVolume, "Indicate a buffer volume to add to the final reaction for each sample:"},
			Lookup[ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]
				},
				Buffer -> Model[Sample, "Nuclease-free Water"],
				BufferVolume -> {5 * Microliter, 10 * Microliter},
				Output -> Options],
				BufferVolume
			],
			{5 * Microliter, 10 * Microliter}
		],

		(*Dilution curve tests for a variety of different types of curves*)
		Example[{Options, SerialDilutionCurve, "Indicate the type and number of serial dilutions of a single sample:"},
			Download[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfReplicates -> Null,
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}}
			],
				SerialDilutions],
			{{{45 * Microliter, 0 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}}}
		],
		Example[{Options, DilutionCurve, "Indicate the type and number of dilutions of a single sample:"},
			Download[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfReplicates -> Null,
				DilutionCurve -> {{25 * Microliter, 25 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 100 * Microliter}}
			],
				Dilutions],
			{{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 100 * Microliter}}}
		],
		Example[{Options, SerialDilutionCurve, "Indicate the type and number of serial dilutions of each sample within a pooled sample:"},
			Download[ExperimentThermalShift[
				{{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]}},
				NumberOfReplicates -> Null,
				SerialDilutionCurve -> {
					{{25 * Microliter, 25 * Microliter, 5}, {25 * Microliter, 50 * Microliter, 5}}
				},
				AliquotAmount -> {{20 * Microliter, 20 * Microliter}}
			],
				SerialDilutions],
			{
				{{45 * Microliter, 0 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}},
				{{45 * Microliter, 0 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 50 * Microliter}}
			}
		],
		Example[{Options, DilutionCurve, "Indicate the type and number of dilutions of each sample within a pooled sample:"},
			Download[ExperimentThermalShift[
				{{Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID]}},
				NumberOfReplicates -> Null,
				DilutionCurve -> {
					{{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 100 * Microliter}},
						{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}}}
				},
				AliquotAmount -> {{50 * Microliter, 50 * Microliter}}
			],
				Dilutions],
			{
				{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 100 * Microliter}},
				{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}, {25 * Microliter, 25 * Microliter}}
			}
		],
		Example[{Options, Diluent, "Indicate the diluent to use for a sample serial dilution curve:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				Diluent -> {Model[Sample, StockSolution, "1x PBS from 10x stock, pH 7"]},
				Output -> Options
			],
				Diluent],
			{{ObjectP[Model[Sample, StockSolution, "1x PBS from 10x stock, pH 7"]]}}
		],
		Example[{Options, Diluent, "Indicate the diluent to use for a sample dilution curve:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DilutionCurve -> {{{25 * Microliter, 25 * Microliter}, {25 * Microliter, 50 * Microliter}, {25 * Microliter, 100 * Microliter}}},
				Diluent -> {Model[Sample, StockSolution, "1x PBS from 10x stock, pH 7"]},
				Output -> Options
			],
				Diluent],
			{{ObjectP[Model[Sample, StockSolution, "1x PBS from 10x stock, pH 7"]]}}
		],
		Example[{Options, DilutionContainer, "Indicate the dilution container to use for a sample serial dilution curve:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionContainer -> {{{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}},
				Output -> Options
			],
				DilutionContainer],
			{{{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}}
		],
		Example[{Options, DilutionStorageCondition, "Indicate the storage condition for the any left over samples in the dilution container:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionStorageCondition -> {{Freezer}},
				Output -> Options
			],
				DilutionStorageCondition],
			{{Freezer}}
		],
		Example[{Options, DilutionMixVolume, "Indicate the dilution mix volume:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionMixVolume -> {{10 * Microliter}},
				Output -> Options
			],
				DilutionMixVolume],
			{{10 * Microliter}},
			EquivalenceFunction -> Equal
		],
		Example[{Options, DilutionNumberOfMixes, "Indicate the number dilution of mixes:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionNumberOfMixes -> {{2}},
				Output -> Options
			],
				DilutionNumberOfMixes],
			{{2}},
			EquivalenceFunction -> Equal
		],
		Example[{Options, DilutionMixRate, "Indicate the dilution of mix rate:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				SerialDilutionCurve -> {{{25 * Microliter, 25 * Microliter, 5}}},
				DilutionMixRate -> {{10 * Microliter / Second}},
				Output -> Options
			],
				DilutionMixRate],
			{{10 * Microliter / Second}},
			EquivalenceFunction -> Equal
		],
		(* PassiveReference optons *)
		Example[{Options, PassiveReference, "Use PassiveReference to select the reference sample to normalize melting curves:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				PassiveReference -> Model[Sample, "Milli-Q water"],
				PassiveReferenceVolume -> 5 * Microliter,
				Output -> Options
			],
				PassiveReference],
			ObjectP[Model[Sample, "Milli-Q water"]],
			EquivalenceFunction -> MatchQ
		],
		Example[{Options, PassiveReferenceVolume, "Use PassiveReferenceVolume to indicate the volume of the reference sample to normalize melting curves:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				PassiveReference -> Model[Sample, "Milli-Q water"],
				PassiveReferenceVolume -> 5 * Microliter,
				Output -> Options
			],
				PassiveReferenceVolume],
			5 Microliter,
			EquivalenceFunction -> Equal
		],

		(*Detection options*)
		Example[{Options, DetectionReagent, "Indicate a fluorescent detection reagent to use in the assay:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DetectionReagent -> Model[Sample, StockSolution, "10X SYPRO Orange"],
				DetectionReagentVolume -> 0.9 * Microliter,
				Output -> Options
			],
				DetectionReagent],
			ObjectP[Model[Sample, StockSolution, "10X SYPRO Orange"]]
		],
		Example[{Options, DetectionReagentVolume, "Indicate a volume of fluorescent detection reagent to use in the assay:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DetectionReagent -> Model[Sample, StockSolution, "10X SYPRO Orange"],
				DetectionReagentVolume -> 0.9 * Microliter,
				Output -> Options
			],
				DetectionReagentVolume],
			0.9 * Microliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FluorescenceLaserPower, "Indicate the power of the fluorescence excitation laser on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				FluorescenceLaserPower -> {13 * Percent},
				Output -> Options
			],
				FluorescenceLaserPower],
			{13 * Percent},
			EquivalenceFunction -> Equal
		],
		Example[{Options, StaticLightScatteringLaserPower, "Indicate the power of the static light scattering light source on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				StaticLightScatteringLaserPower -> {25 * Percent},
				Output -> Options
			],
				StaticLightScatteringLaserPower],
			{25 * Percent},
			EquivalenceFunction -> Equal
		],
		Example[{Options, OptimizeFluorescenceLaserPower, "Indicate the fluorescence laser power should be optimized prior to experimentation on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				Output -> Options
			],
				OptimizeFluorescenceLaserPower],
			True
		],
		Example[{Options, OptimizeStaticLightScatteringLaserPower, "Indicate the static light scattering laser power should be matched to the optimized fluorescence laser power prior to experimentation on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				OptimizeStaticLightScatteringLaserPower -> True,
				Output -> Options
			],
				OptimizeStaticLightScatteringLaserPower],
			True
		],
		Example[{Options, LaserOptimizationEmissionWavelengthRange, "Indicate the wavelength range for fluorescence laser power optimization prior to experimentation on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				LaserOptimizationEmissionWavelengthRange -> 250 Nanometer ;; 700 Nanometer,
				Output -> Options
			],
				LaserOptimizationEmissionWavelengthRange],
			250 Nanometer ;; 700 Nanometer
		],
		Example[{Options, LaserOptimizationTargetEmissionIntensityRange, "Indicate the emission intensity range for fluorescence laser power optimization prior to experimentation on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				OptimizeFluorescenceLaserPower -> True,
				LaserOptimizationTargetEmissionIntensityRange -> 50 Percent ;; 60 Percent,
				Output -> Options
			],
				LaserOptimizationTargetEmissionIntensityRange],
			50 Percent ;; 60 Percent
		],
		Example[{Options, ExcitationWavelength, "Indicate the wavelength of the fluorescence excitation laser:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ExcitationWavelength -> 580 * Nanometer,
				Output -> Options
			],
				ExcitationWavelength],
			580 * Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, EmissionWavelength, "Indicate the wavelength of the fluorescence emission detection:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				EmissionWavelength -> 520 * Nanometer,
				Output -> Options
			],
				EmissionWavelength],
			520 * Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MinEmissionWavelength, "Indicate the wavelength range of the fluorescence emission detection on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinEmissionWavelength -> 350 * Nanometer,
				MaxEmissionWavelength -> 550 * Nanometer,
				Output -> Options
			],
				MinEmissionWavelength],
			350 * Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxEmissionWavelength, "Indicate the wavelength range of the fluorescence emission detection on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinEmissionWavelength -> 350 * Nanometer,
				MaxEmissionWavelength -> 550 * Nanometer,
				Output -> Options
			],
				MaxEmissionWavelength],
			550 * Nanometer,
			EquivalenceFunction -> Equal
		],
		Example[{Options, StaticLightScatteringExcitationWavelength, "Indicate the wavelength(s) of the static light scattering laser source on the Uncle:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				StaticLightScatteringExcitationWavelength -> {473 * Nanometer},
				Output -> Options
			],
				StaticLightScatteringExcitationWavelength],
			{473 * Nanometer},
			EquivalenceFunction -> Equal
		],

		(*Melting curve options*)

		Example[{Options, MinTemperature, "Indicate the minimum temperature of the thermal profile:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MinTemperature -> 30 * Celsius,
				Output -> Options
			],
				MinTemperature],
			30 * Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxTemperature, "Indicate the maximum temperature of the thermal profile:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				MaxTemperature -> 80 * Celsius,
				Output -> Options
			],
				MaxTemperature],
			80 * Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TemperatureRampOrder, "Indicate the order of the heating and cooling ramps:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfCycles -> 1,
				TemperatureRampOrder -> {Cooling, Heating},
				Output -> Options
			],
				TemperatureRampOrder],
			{Cooling, Heating}
		],
		Example[{Options, NumberOfCycles, "Indicate the number of alternating heating and cooling ramps:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				NumberOfCycles -> 3,
				Output -> Options
			],
				NumberOfCycles],
			3,
			EquivalenceFunction -> Equal
		],
		Example[{Options, EquilibrationTime, "Indicate the length of time to incubate the samples at the starting temperature of each heating or cooling ramp:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				EquilibrationTime -> 10 * Second,
				Output -> Options
			],
				EquilibrationTime],
			10 * Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TemperatureRampRate, "Indicate the rate of temperature change during the thermal profile:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRampRate -> 0.1 * Celsius / Second,
				Output -> Options
			],
				TemperatureRampRate],
			0.1 * Celsius / Second,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TemperatureRamping, "Indicate a linear temperature ramp:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Linear,
				Output -> Options
			],
				TemperatureRamping],
			Linear
		],
		Example[{Options, TemperatureResolution, "Indicate a linear temperature ramp with a 2 degree Celsius interval between consecutive data points of each sample:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Linear,
				TemperatureResolution -> 2 * Celsius,
				Output -> Options
			],
				TemperatureResolution],
			2 * Celsius,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TemperatureRamping, "Indicate a stepped temperature ramp:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Step,
				Output -> Options
			],
				TemperatureRamping],
			Step
		],
		Example[{Options, NumberOfTemperatureRampSteps, "Indicate the number of temperature ramp steps for a stepped thermal profile:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Step,
				NumberOfTemperatureRampSteps -> 10,
				Output -> Options
			],
				NumberOfTemperatureRampSteps],
			10,
			EquivalenceFunction -> Equal
		],
		Example[{Options, StepHoldTime, "Indicate the time to hold at each step temperature prior to measurement for a stepped thermal profile:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				TemperatureRamping -> Step,
				StepHoldTime -> 10 * Second,
				Output -> Options
			],
				StepHoldTime],
			10 * Second,
			EquivalenceFunction -> Equal
		],

		(* DLS option resolution *)
		Example[{Options, DynamicLightScattering, "The DynamicLightScatteringMeasurements is used to specify if at least one DLS measurement is made during the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScattering],
			True,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurements, "The DynamicLightScatteringMeasurements option defaults to Null if DynamicLightScattering is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> False,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringMeasurements],
			Null,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurements, "The DynamicLightScatteringMeasurements option defaults to {Before,After} if DynamicLightScattering is True:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringMeasurements],
			{Before, After},
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurementTemperatures, "The DynamicLightScatteringMeasurementTemperatures option defaults to MinTemperature if DynamicLightScatteringMeasurements is Before and the ramp is Heating:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringMeasurements -> {Before},
				MinTemperature -> 30Celsius,
				Output -> Options
			];
			Lookup[options, {DynamicLightScatteringMeasurementTemperatures, MinTemperature}],
			{30Celsius, 30Celsius},
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurementTemperatures, "The DynamicLightScatteringMeasurementTemperatures option defaults to MaxTemperature if DynamicLightScatteringMeasurements is After and the ramp is Heating:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringMeasurements -> {After},
				MaxTemperature -> 80Celsius,
				Output -> Options
			];
			Lookup[options, {DynamicLightScatteringMeasurementTemperatures, MaxTemperature}],
			{80Celsius, 80Celsius},
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurementTemperatures, "The DynamicLightScatteringMeasurementTemperatures option defaults to {MinTemperature,MaxTemperature} if DynamicLightScatteringMeasurements is {Before,After} and the ramp is Heating:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringMeasurements -> {Before, After},
				MaxTemperature -> 80Celsius,
				MinTemperature -> 30Celsius,
				Output -> Options
			];
			Lookup[options, {DynamicLightScatteringMeasurementTemperatures, MinTemperature, MaxTemperature}],
			{{30Celsius, 80Celsius}, 30Celsius, 80Celsius},
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringMeasurementTemperatures, "Specify the DynamicLightScatteringMeasurementTemperatures option:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> True,
				DynamicLightScatteringMeasurements -> {Before},
				DynamicLightScatteringMeasurementTemperatures -> 50Celsius,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringMeasurementTemperatures],
			50Celsius,
			Variables :> {options}
		],
		Example[{Options, NumberOfDynamicLightScatteringAcquisitions, "The NumberOfDynamicLightScatteringAcquisitions option defaults to Null if DynamicLightScattering is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> False,
				Output -> Options
			];
			Lookup[options, NumberOfDynamicLightScatteringAcquisitions],
			Null,
			Variables :> {options}
		],
		Example[{Options, NumberOfDynamicLightScatteringAcquisitions, "The NumberOfDynamicLightScatteringAcquisitions option defaults to 4 if DynamicLightScattering is True:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, NumberOfDynamicLightScatteringAcquisitions],
			4,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringAcquisitionTime, "The DynamicLightScatteringAcquisitionTime option defaults to Null if DynamicLightScattering is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> False,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringAcquisitionTime],
			Null,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringAcquisitionTime, "The DynamicLightScatteringAcquisitionTime option defaults to 5 seconds if DynamicLightScattering is True:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringAcquisitionTime],
			5 * Second,
			Variables :> {options}
		],
		Example[{Options, AutomaticDynamicLightScatteringLaserSettings, "The AutomaticDynamicLightScatteringLaserSettings option defaults to Null if DynamicLightScattering is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				DynamicLightScattering -> False,
				Output -> Options
			];
			Lookup[options, AutomaticDynamicLightScatteringLaserSettings],
			Null,
			Variables :> {options}
		],
		Example[{Options, AutomaticDynamicLightScatteringLaserSettings, "The AutomaticDynamicLightScatteringLaserSettings option defaults to True if DynamicLightScattering is True and neither the DynamicLightScatteringLaserPower nor the DynamicLightScatteringDiodeAttenuation have been specified:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				Output -> Options
			];
			Lookup[options, AutomaticDynamicLightScatteringLaserSettings],
			True,
			Variables :> {options}
		],
		Example[{Options, AutomaticDynamicLightScatteringLaserSettings, "The AutomaticDynamicLightScatteringLaserSettings option defaults to False if DynamicLightScattering is True and either the DynamicLightScatteringLaserPower or the DynamicLightScatteringDiodeAttenuation have been specified:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				DynamicLightScatteringLaserPower -> 78 * Percent,
				Output -> Options
			];
			Lookup[options, AutomaticDynamicLightScatteringLaserSettings],
			False,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringLaserPower, "The DynamicLightScatteringLaserPower option defaults to Null if the AutomaticDynamicLightScatteringLaserSettings option is True:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				AutomaticDynamicLightScatteringLaserSettings -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringLaserPower],
			Null,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringLaserPower, "The DynamicLightScatteringLaserPower option defaults to 100% if the AutomaticDynamicLightScatteringLaserSettings option is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				AutomaticDynamicLightScatteringLaserSettings -> False,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringLaserPower],
			100 * Percent,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringDiodeAttenuation, "The DynamicLightScatteringDiodeAttenuation option defaults to Null if the AutomaticDynamicLightScatteringLaserSettings option is True:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				AutomaticDynamicLightScatteringLaserSettings -> True,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringDiodeAttenuation],
			Null,
			Variables :> {options}
		],
		Example[{Options, DynamicLightScatteringDiodeAttenuation, "The DynamicLightScatteringDiodeAttenuation option defaults to 100% if the AutomaticDynamicLightScatteringLaserSettings option is False:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"],
				DynamicLightScattering -> True,
				AutomaticDynamicLightScatteringLaserSettings -> False,
				Output -> Options
			];
			Lookup[options, DynamicLightScatteringDiodeAttenuation],
			100 * Percent,
			Variables :> {options}
		],


		(*Samples out options*)
		Example[{Options, ContainerOut, "Indicate the container that the samples should be transferred to after the experiment:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				SamplesOutStorageCondition -> Freezer,
				Output -> Options
			],
				ContainerOut],
			ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]
		],
		Example[{Options, SamplesOutStorageCondition, "Indicate the storage condition for the samples out:"},
			Lookup[ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				SamplesOutStorageCondition -> Freezer,
				Output -> Options
			],
				SamplesOutStorageCondition],
			Freezer
		],

		(*Sample prep*)
		Example[{Additional, "Generates a thermal shift protocol for the Uncle with a prepared plate:"},
			Download[
				ExperimentThermalShift[
					Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID],
					NumberOfReplicates -> Null
				],
				{PreparedPlate, CapillaryStripPreparationPlate}
			],
			{True, ObjectP[Object[Container, Plate]]}
		],
		Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				Incubate -> True, Centrifuge -> True, Filtration -> True,
				Aliquot -> True,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			{Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True, True, True, True}, Variables :> {options},
			TimeConstraint -> 600
		],
		Example[{Additional, "Sample preparation options can be indicated for each individual input sample:"},
			options = ExperimentThermalShift[                {
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
			},
				Incubate -> {True, True, False, False},
				Output -> Options];
			Lookup[options, Incubate],
			{{True}, {True}, {False}, {False}},
			Variables :> {options},
			TimeConstraint -> 600
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentThermalShift[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, ThermalShift]],
			Messages :> {Warning::UnknownAnalytes}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared"},
			options = ExperimentThermalShift[
				{{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}},
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
			Variables :> {options, prepUOs},
			Messages:>{Warning::UnknownAnalytes}
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples for ExperimentThermalShift (new):"},
			protocol = Quiet[ExperimentThermalShift["My Pooled Sample",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Isopropanol"],
						Amount -> 500 * Microliter,
						Destination -> {"My Pooled Sample"}
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 30 * Microliter,
						Destination -> {"My Pooled Sample"}
					]
				}
			], {Warning::UnknownAnalytes}];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				Incubate -> True,
				Output -> Options
			];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Indicates the temperature the SamplesIn should be incubated at prior to starting the experiment or any aliquoting:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubationTemperature -> 40 * Celsius,
				Output -> Options
			];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubationTime -> 30 * Minute,
				Output -> Options
			];
			Lookup[options, IncubationTime],
			30 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				MaxIncubationTime -> 60 * Minute,
				Output -> Options
			];
			Lookup[options, MaxIncubationTime],
			60 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				Output -> Options
			];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				AnnealingTime -> 1 * Hour,
				Output -> Options
			];
			Lookup[options, AnnealingTime],
			1 * Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubateAliquot -> 250 * Microliter,
				Output -> Options
			];
			Lookup[options, IncubateAliquot],
			250 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubateAliquotContainer -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Output -> Options
			];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				IncubateAliquotContainer -> {1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				IncubateAliquotDestinationWell -> {"A1", "B1", "C1", "D1"},
				Output -> Options
			];
			Lookup[options, IncubateAliquotDestinationWell],
			{{"A1"}, {"B1"}, {"C1"}, {"D1"}},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				CentrifugeAliquotDestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				FilterAliquotDestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding DestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				DestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Mix -> True,
				Output -> Options
			];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				MixType -> Pipette,
				Output -> Options
			];
			Lookup[options, MixType],
			Pipette,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				MixUntilDissolved -> True,
				Output -> Options
			];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				Centrifuge -> True,
				Output -> Options
			];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output -> Options
			];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeIntensity -> 3000 * RPM,
				Output -> Options
			];
			Lookup[options, CentrifugeIntensity],
			3000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeTime -> 1 * Minute,
				Output -> Options
			];
			Lookup[options, CentrifugeTime],
			1 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeTemperature -> 4 * Celsius,
				Output -> Options
			];
			Lookup[options, CentrifugeTemperature],
			4 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				CentrifugeAliquot -> 250 * Microliter,
				Output -> Options
			];
			Lookup[options, CentrifugeAliquot],
			250 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 360
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				CentrifugeAliquot -> 250 * Microliter,
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options},
			TimeConstraint -> 300
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				Filtration -> True,
				Output -> Options
			];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				FiltrationType -> Syringe,
				Output -> Options
			];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options
			];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"],
				Output -> Options
			];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			TimeConstraint -> 800
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentThermalShift[
				{
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID]
				},
				FilterMaterial -> PES,
				Output -> Options
			];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		(* this test requires a 50ml tube and a larger volume and FilterMaterial HAS to be set to PTFE, and the volume needs to be between 1.5 and 50ml *)
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				FilterMaterial -> PTFE,
				PrefilterMaterial -> GxF,
				AliquotAmount -> 0.7 Milliliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				FilterPoreSize -> 0.22 * Micrometer,
				AliquotAmount -> 0.7 Milliliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				PrefilterPoreSize -> 1. * Micrometer,
				FilterMaterial -> PTFE,
				AliquotAmount -> 0.7 Milliliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Indicate the syringe used to force that sample through a filter:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				FiltrationType -> Syringe,
				FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		(* This test needs Volume 50ml *)
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
				FiltrationType -> PeristalticPump,
				FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],
				AliquotAmount -> 0.7 Milliliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterIntensity -> 1000 * RPM,
				Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTime -> 5 * Minute,
				Output -> Options];
			Lookup[options, FilterTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTemperature -> 4 * Celsius,
				Output -> Options];
			Lookup[options, FilterTemperature],
			4 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* note that FilterSterile needs to be run with a sample of a volume above 50mL (Jan 2019) *)
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
				FilterSterile -> True,
				Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				FilterAliquot -> 250 * Microliter,
				Output -> Options];
			Lookup[options, FilterAliquot],
			250 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				FilterAliquot -> 250 * Microliter,
				FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				FilterContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentThermalShift[{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID]},
				Aliquot -> True,
				AliquotAmount -> {100 * Microliter, 100 * Microliter},
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Aliquot -> True,
				AliquotAmount -> 100 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, AliquotAmount],
			100 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				AssayVolume -> 500 * Microliter,
				AliquotAmount -> 100 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options
			];
			Lookup[options, AssayVolume],
			500 * Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				TargetConcentration -> 0.5 * Milligram / Milliliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, TargetConcentration],
			0.5 * Milligram / Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"],
				AssayVolume -> 1300 * Microliter,
				AliquotAmount -> 400 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which is diluted with BufferDiluent by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"],
				AssayVolume -> 1300 * Microliter,
				AliquotAmount -> 400 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the ConcentratedBuffer is diluted with BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"],
				AssayVolume -> 1300 * Microliter,
				AliquotAmount -> 400 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"],
				AssayVolume -> 1.2 * Milliliter,
				AliquotAmount -> 500 * Microliter,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10X SYBR Gold in filtered 1X TBE Alternative Preparation"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				AliquotSampleStorageCondition -> Refrigerator,
				Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Aliquot -> True,
				AliquotPreparation -> Manual,
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentThermalShift[Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID], TargetConcentration -> 0.25 Milligram / Milliliter, TargetConcentrationAnalyte -> Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID], AssayVolume -> 100 * Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates the samples should be imaged after the experiment:"},
			options = ExperimentThermalShift[
				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				ImageSample -> True,
				Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicate that sample volumes should be measured after the experiment:"},
			Download[
				ExperimentThermalShift[
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
					MeasureVolume -> True],
				MeasureVolume
			],
			True
		],
		Example[{Options, MeasureWeight, "Indicate that sample weight should be measured after the experiment:"},
			Download[
				ExperimentThermalShift[
					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID]
					, MeasureWeight -> True],
				MeasureWeight
			],
			True
		]
	},

	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},
	(* without this, telescolpe crashes and the tests fail *)
	HardwareConfiguration->HighRAM,

	SetUp :> ($CreatedObjects = {}),
	TearDown :> (EraseObject[$CreatedObjects, Force -> True]),
	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Upload::Warning];
		Block[
			{$Notebook=Null},
			Module[{allObjects, existingObjects},

				(*Gather all the objects and models created in SymbolSetUp*)
				allObjects = Cases[Flatten[{
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 3" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 4" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID],
					Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 3" <> $SessionUUID],
					Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 4" <> $SessionUUID],

					Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 2" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 3" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 4" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 5" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 6" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 7" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 8" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test water sample" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test polymer sample" <> $SessionUUID],

					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 7" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 8" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test water sample" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test polymer sample" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID],

					Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 3" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentThermalShift test container 4" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentThermalShift test container 5" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 6" <> $SessionUUID],

					Object[Protocol, ThermalShift, "Test ThermalShift option template protocol" <> $SessionUUID]

				}], ObjectP[]];

				(*Check whether the names we want to give below already exist in the database*)
				existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

				(*Erase any test objects and models that we failed to erase in the last unit test*)
				Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

			];

			Module[{allObjects},

				(*Upload empty containers*)
				Upload[{
					<|
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Name -> "ExperimentThermalShift test container 1" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>,
					<|
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Name -> "ExperimentThermalShift test container 2" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>,
					<|
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Name -> "ExperimentThermalShift test container 3" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>,
					<|
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "ExperimentThermalShift test container 4" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>,
					<|
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Name -> "ExperimentThermalShift test container 5" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>,
					<|
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Name -> "ExperimentThermalShift test container 6" <> $SessionUUID,
						DeveloperObject -> True,
						Site->Link[$Site],
						Status -> Available
					|>
				}];

				(*Upload protein identity models. For variety make two proteins and two antibodies*)
				UploadProtein[
					{
						"ExperimentThermalShift test protein 1" <> $SessionUUID,
						"ExperimentThermalShift test protein 2" <> $SessionUUID
					},
					Species -> Model[Species, "Human"],
					Synonyms -> {
						{"TestProtein1"},
						{"TestProtein2"}
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None}
				];

				UploadAntibody[
					{
						"ExperimentThermalShift test protein 3" <> $SessionUUID,
						"ExperimentThermalShift test protein 4" <> $SessionUUID
					},
					Species -> Model[Species, "Human"],
					Targets -> {
						{Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID]},
						{Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID]}
					},
					Synonyms -> {
						{"TestProtein3"},
						{"TestProtein4"}
					},
					Clonality -> Monoclonal,
					Isotype -> IgG1,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None}
				];

				(*Upload oligomer identity models.*)
				UploadOligomer[
					{
						"ExperimentThermalShift test oligomer 1" <> $SessionUUID,
						"ExperimentThermalShift test oligomer 2" <> $SessionUUID,
						"ExperimentThermalShift test oligomer 3" <> $SessionUUID,
						"ExperimentThermalShift test oligomer 4" <> $SessionUUID
					},
					Molecule -> {
						Strand[DNA["CATTAG"]],
						Strand[DNA["CATTAG"]],
						Strand[DNA["GGGGGG"]],
						Strand[DNA["CCCCCCC"]]
					},
					Synonyms -> {
						{"TestOligomer1"},
						{"TestOligomer2"},
						{"TestOligomer3"},
						{"Test oligomer 4"}
					},
					PolymerType -> {DNA, RNA, DNA, DNA}
				];

				(*Upload Model samples so we can upload new sample objects later.*)
				UploadSampleModel[
					{
						"ExperimentThermalShift model test sample 1" <> $SessionUUID,
						"ExperimentThermalShift model test sample 2" <> $SessionUUID,
						"ExperimentThermalShift model test sample 3" <> $SessionUUID,
						"ExperimentThermalShift model test sample 4" <> $SessionUUID,
						"ExperimentThermalShift model test sample 5" <> $SessionUUID,
						"ExperimentThermalShift model test sample 6" <> $SessionUUID,
						"ExperimentThermalShift model test sample 7" <> $SessionUUID,
						"ExperimentThermalShift model test sample 8" <> $SessionUUID,
						"ExperimentThermalShift model test water sample" <> $SessionUUID,
						"ExperimentThermalShift model test polymer sample" <> $SessionUUID
					},
					Composition -> {
						{{1 Milligram / Milliliter, Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 3" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 4" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 3" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{1 Milligram / Milliliter, Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 4" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
						{{100 VolumePercent, Model[Molecule, "Water"]}},
						{{100 VolumePercent, Model[Molecule, Polymer, "Poly(Ethylene Glycol)"]}}
					},
					IncompatibleMaterials -> {{None}, {None}, {None}, {None}, {None}, {None}, {None}, {None}, {None}, {None}},
					Expires -> {True, True, True, True, True, True, True, True, True, True},
					ShelfLife -> {1 Year, 1 Year, 1 Year, 1 Year, 1 Year, 1 Year, 1 Year, 1 Year, 1 Year, 1 Year},
					UnsealedShelfLife -> {2 Week, 2 Week, 2 Week, 2 Week, 2 Week, 2 Week, 2 Week, 2 Week, 2 Week, 2 Week},
					DefaultStorageCondition -> {Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"],
						Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"]},
					MSDSRequired -> {False, False, False, False, False, False, False, False, False, False},
					BiosafetyLevel -> {"BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1", "BSL-1"},
					State -> {Liquid, Liquid, Liquid, Liquid, Liquid, Liquid, Liquid, Liquid, Liquid, Liquid}
				];

				(*Upload test sample objects. Place test objects in the specified test container objects*)
				UploadSample[
					{
						Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 2" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 3" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 4" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 5" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 6" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 7" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 8" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test water sample" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test polymer sample" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
						Model[Sample, "ExperimentThermalShift model test sample 2" <> $SessionUUID]

					},
					{
						{"A1", Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]},
						{"A4", Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID]},

						{"A1", Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID]},
						{"A4", Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID]},

						{"A1", Object[Container, Plate, "ExperimentThermalShift test container 3" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "ExperimentThermalShift test container 3" <> $SessionUUID]},

						{"A1", Object[Container, Vessel, "ExperimentThermalShift test container 4" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "ExperimentThermalShift test container 5" <> $SessionUUID]},

						{"A1", Object[Container, Plate, "ExperimentThermalShift test container 6" <> $SessionUUID]}
					},
					Name ->
						{
							"ExperimentThermalShift test sample 1" <> $SessionUUID,
							"ExperimentThermalShift test sample 2" <> $SessionUUID,
							"ExperimentThermalShift test sample 3" <> $SessionUUID,
							"ExperimentThermalShift test sample 4" <> $SessionUUID,
							"ExperimentThermalShift test sample 5" <> $SessionUUID,
							"ExperimentThermalShift test sample 6" <> $SessionUUID,
							"ExperimentThermalShift test sample 7" <> $SessionUUID,
							"ExperimentThermalShift test sample 8" <> $SessionUUID,
							"ExperimentThermalShift test water sample" <> $SessionUUID,
							"ExperimentThermalShift test polymer sample" <> $SessionUUID,
							"ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID,
							"ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID,
							"ExperimentThermalShift test sample 2 model-less" <> $SessionUUID
						},
					InitialAmount -> Join[ConstantArray[0.5 Milliliter, 10], {15 * Milliliter, 50 * Milliliter, 0.5 Milliliter}]
				];

				(*Upload analytes to the test objects*)
				MapThread[
					Upload[<|Object -> #1, Replace[Analytes] -> Link[#2]|>]&,
					{
						{Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 7" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 8" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test polymer sample" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
							Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID]
						},

						{Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 3" <> $SessionUUID],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 4" <> $SessionUUID],
							Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID],
							Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID],
							Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 3" <> $SessionUUID],
							Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 4" <> $SessionUUID],
							Model[Molecule, Polymer, "Poly(Ethylene Glycol)"],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
							Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID]
						}
					}
				];

				(*Make a test model-less sample object*)
				Upload[<|
					Object -> Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID],
					Model -> Null
				|>];

				(* Make a test protocol for the Template option unit test *)
				Upload[
					{
						<|
							Type -> Object[Protocol, ThermalShift],
							Name -> "Test ThermalShift option template protocol" <> $SessionUUID,
							Site->Link[$Site],
							ResolvedOptions -> {Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Uncle"]}
						|>
					}
				];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects = Flatten[{
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 3" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 4" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID],
					Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID],
					Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 3" <> $SessionUUID],
					Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 4" <> $SessionUUID],

					Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 2" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 3" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 4" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 5" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 6" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 7" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test sample 8" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test water sample" <> $SessionUUID],
					Model[Sample, "ExperimentThermalShift model test polymer sample" <> $SessionUUID],

					Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 7" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 8" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test water sample" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test polymer sample" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
					Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID],

					Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 3" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentThermalShift test container 4" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentThermalShift test container 5" <> $SessionUUID],
					Object[Container, Plate, "ExperimentThermalShift test container 6" <> $SessionUUID],

					Object[Protocol, ThermalShift, "Test ThermalShift option template protocol" <> $SessionUUID]

				}];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects];

			]
		]
	),

	SymbolTearDown :> (

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Upload::Warning];

		Module[{allObjects, existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = Flatten[{
				Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 1" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 2" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 3" <> $SessionUUID],
				Model[Molecule, Oligomer, "ExperimentThermalShift test oligomer 4" <> $SessionUUID],
				Model[Molecule, Protein, "ExperimentThermalShift test protein 1" <> $SessionUUID],
				Model[Molecule, Protein, "ExperimentThermalShift test protein 2" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 3" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "ExperimentThermalShift test protein 4" <> $SessionUUID],

				Model[Sample, "ExperimentThermalShift model test sample 1" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 2" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 3" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 4" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 5" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 6" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 7" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test sample 8" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test water sample" <> $SessionUUID],
				Model[Sample, "ExperimentThermalShift model test polymer sample" <> $SessionUUID],

				Object[Sample, "ExperimentThermalShift test sample 1" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 1 in 50mL tube" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 2" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 3" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 4" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 5" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 6" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 7" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 8" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test water sample" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test polymer sample" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift 50mL test sample 1 in 50mL tube" <> $SessionUUID],
				Object[Sample, "ExperimentThermalShift test sample 2 model-less" <> $SessionUUID],

				Object[Container, Plate, "ExperimentThermalShift test container 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentThermalShift test container 2" <> $SessionUUID],
				Object[Container, Plate, "ExperimentThermalShift test container 3" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentThermalShift test container 4" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentThermalShift test container 5" <> $SessionUUID],
				Object[Container, Plate, "ExperimentThermalShift test container 6" <> $SessionUUID],

				Object[Protocol, ThermalShift, "Test ThermalShift option template protocol" <> $SessionUUID]
			}];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		]
	)
];
