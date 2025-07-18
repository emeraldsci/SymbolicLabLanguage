(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentPCR: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentPCR*)


DefineTests[ExperimentPCR,
	{
		(*===Basic examples===*)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			ExperimentPCR[
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Basic,"Accepts a sample object with one specified pair of primer objects:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Basic,"Accepts multiple sample objects with Null pair of primers specified:"},
			ExperimentPCR[{
				Object[Sample,"ExperimentPCR test sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentPCR test sample 2" <> $SessionUUID]
			},
				{{{Null,Null}}}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Basic,"Accepts a sample object with multiple specified pairs of primer objects:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{
					{
						Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
						Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
					},
					{
						Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
						Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]
					}
				}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Basic,"Accepts multiple sample objects, each with one or more pairs of primer objects:"},
			ExperimentPCR[
				{
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID]
				},
				{
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						}
					},
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						},
						{
							Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]
						}
					}
				}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Options, PreparedPlate,"Accepts a prepared assay plate without plate seal:"},
			protocol=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample in prepared plate"<>$SessionUUID],
				PreparedPlate -> True
			];
			{
				MemberQ[protocol[RequiredResources][[All,2]],AssayPlate],
				MemberQ[protocol[RequiredResources][[All,2]],PlateSeal],
				Download[protocol, PreparedPlate]
			},
			{False,True, True},
			Variables:>{protocol}
		],
		Example[{Options, PreparedPlate,"Accepts a prepared assay plate with plate seal:"},
			protocol=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID],
				PreparedPlate -> True
			];
			{MemberQ[protocol[RequiredResources][[All,2]],AssayPlate],MemberQ[protocol[RequiredResources][[All,2]],PlateSeal]},
			{False,True},
			Variables:>{protocol}
		],
		Example[{Options, PreparedPlate, "If PreparedPlate is set to True, then MasterMix and Buffer are set to Null, and SampleVolume is set to 0 Microliter:"},
			options = ExperimentPCR[
				Object[Sample, "ExperimentPCR test sample in prepared plate with cover" <> $SessionUUID],
				PreparedPlate -> True,
				Output -> Options,
				OptionsResolverOnly -> True
			];
			Lookup[options, {MasterMix, Buffer, SampleVolume}],
			{Null, Null, EqualP[0 Microliter]},
			Variables :> {options}
		],
		Example[{Basic, "Test Robotic version on a single sample object:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		],
		Example[{Basic, "Test Robotic version on a single sample object with a single primer pair:"},
			ExperimentPCR[
				Object[Sample, "ExperimentPCR test sample 1" <> $SessionUUID],
				{
					{
						Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID],
						Object[Sample, "ExperimentPCR test primer sample 1 reverse" <> $SessionUUID]
					}
				},
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		],
		Example[{Basic, "Test Robotic version on multiple sample objects with multiple primer pairs:"},
			ExperimentPCR[
				{
					Object[Sample, "ExperimentPCR test sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentPCR test sample 2" <> $SessionUUID]
				},
				{
					{
						{
							Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID],
							Object[Sample, "ExperimentPCR test primer sample 1 reverse" <> $SessionUUID]
						}
					},
					{
						{
							Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID],
							Object[Sample, "ExperimentPCR test primer sample 1 reverse" <> $SessionUUID]
						},
						{
							Object[Sample, "ExperimentPCR test primer sample 2 forward" <> $SessionUUID],
							Object[Sample, "ExperimentPCR test primer sample 2 reverse" <> $SessionUUID]
						}
					}
				},
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		],
		Example[{Basic,"Accepts a prepared assay plate without plate seal robotically:"},
			protocol=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample in prepared plate"<>$SessionUUID],
				MasterMix->Null,
				Buffer->Null,
				Preparation->Robotic
			];
			Download[First@protocol[OutputUnitOperations],AssayPlateUnitOperations],
			{LinkP[Object[UnitOperation,LabelContainer]], LinkP[Object[UnitOperation,Cover]], LinkP[Object[UnitOperation,LabelSample]]},
			Variables:>{protocol}
		],
		Example[{Basic,"Accepts a prepared assay plate with plate seal robotically:"},
			protocol=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID],
				MasterMix->Null,
				Buffer->Null,
				Preparation->Robotic
			];
			Download[First@protocol[OutputUnitOperations],AssayPlateUnitOperations],
			{LinkP[Object[UnitOperation,LabelContainer]], LinkP[Object[UnitOperation,Cover]], LinkP[Object[UnitOperation,LabelSample]]},
			Variables:>{protocol}
		],
		Example[{Basic, "Accepts a sample that has not been already prepared in PCR plate robotically:"},
			protocol=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Preparation -> Robotic
			];
			Download[First@protocol[OutputUnitOperations],AssayPlateUnitOperations],
			{
				LinkP[Object[UnitOperation,LabelContainer]],
				LinkP[Object[UnitOperation,LabelSample]],
				LinkP[Object[UnitOperation,Transfer]],
				LinkP[Object[UnitOperation,Cover]],
				LinkP[Object[UnitOperation,LabelSample]]
			},
			Variables:>{protocol}
		],
		Example[{Additional,"Input a sample as {Position, Plate}: "},
			ExperimentPCR[
				{"A1",Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Example[{Additional,"Input a sample and primers as {Position, Plate}: "},
			ExperimentPCR[
				{
					Object[Sample, "ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample, "ExperimentPCR test sample 2"<>$SessionUUID]
				},
				{
					{
						{
							{"A2", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID]},
							Object[Sample, "ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						}
					},
					{
						{
							{"A2", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID]},
							Object[Sample, "ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						},
						{
							Object[Sample, "ExperimentPCR test primer sample 2 forward"<>$SessionUUID], Object[Sample, "ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]
						}
					}
				}
			],
			ObjectP[Object[Protocol,PCR]]
		],

		(*===Error messages tests===*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentPCR[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentPCR[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentPCR[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentPCR[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentPCR[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentPCR[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer pair sample that does not exist (name form):"},
			ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], Object[Sample, "Nonexistent sample"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer pair container that does not exist (name form):"},
			ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], Object[Container, Vessel, "Nonexistent container"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer pair sample that does not exist (ID form):"},
			ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], Object[Sample, "id:12345678"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a primer pair container that does not exist (ID form):"},
			ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], Object[Container, Vessel, "id:12345678"]}}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated primer pair sample but a simulation is specified that indicates that it is simulated:"},
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

				ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], sampleID}}, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated primer pair container but a simulation is specified that indicates that it is simulated:"},
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

				ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID], {{Object[Sample, "ExperimentPCR test primer sample 1 forward" <> $SessionUUID], containerID}}, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"DiscardedSamples","The sample cannot have a Status of Discarded:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test discarded sample"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSamples","The primers cannot have a Status of Discarded:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test discarded primer sample forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test discarded primer sample reverse"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","The sample cannot have a Model that is Deprecated:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test deprecated model sample"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","The primers cannot have a Model that is Deprecated:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test deprecated model primer sample forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test deprecated model primer sample reverse"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"PCRTooManySamples","The total number of samples cannot exceed 96:"},
			ExperimentPCR[
				ConstantArray[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],97]
			],
			$Failed,
			Messages:>{
				Error::PCRTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidPreparedPlate","When trying to use a prepared plate, all the samples must be in a 96-well Full-Skirted PCR Plate:"},
			ExperimentPCR[
				"ExperimentPCR PreparatoryUnitOperations test plate 1",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"ExperimentPCR PreparatoryUnitOperations test plate 1",Container->Model[Container,Plate,"96-well 500uL Round Bottom DSC Plate"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->{"A1","ExperimentPCR PreparatoryUnitOperations test plate 1"},Amount->20 Microliter]
				},
				SampleVolume->0 Microliter,
				MasterMix->Null,
				Buffer->Null
			],
			$Failed,
			Messages:>{Error::InvalidPreparedPlate,Error::InvalidInput}
		],
		Example[{Messages,"DuplicateName","The specified Name cannot already exist for another PCR protocol:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Name->"ExperimentPCR test protocol New"<>$SessionUUID
			],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ForwardPrimerVolumeMismatch","ForwardPrimerVolume cannot have conflicts with the specified forward primers:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ForwardPrimerVolume->Null
			],
			$Failed,
			Messages:>{
				Error::ForwardPrimerVolumeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ReversePrimerVolumeMismatch","ReversePrimerVolume cannot have conflicts with the specified reverse primers:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ReversePrimerVolume->Null
			],
			$Failed,
			Messages:>{
				Error::ReversePrimerVolumeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"BufferVolumeMismatch","BufferVolume cannot have conflicts with Buffer:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Buffer->Model[Sample,"Nuclease-free Water"],
				BufferVolume->Null
			],
			$Failed,
			Messages:>{
				Error::PCRBufferVolumeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterMixVolumeMismatch","MasterMixVolume cannot have conflicts with MasterMix:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMix->Null,
				MasterMixVolume->2 Microliter
			],
			$Failed,
			Messages:>{
				Error::MasterMixVolumeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterMixStorageConditionMismatch","MasterMixStorageCondition cannot have conflicts with MasterMix:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMix->Null,
				MasterMixStorageCondition->Refrigerator
			],
			$Failed,
			Messages:>{
				Error::MasterMixStorageConditionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ActivationMismatch","Activation options cannot have conflicts:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Activation->False,
				ActivationTime->2 Minute
			],
			$Failed,
			Messages:>{
				Error::ActivationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PrimerAnnealingMismatch","PrimerAnnealing options cannot have conflicts:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealing->False,
				PrimerAnnealingTime->2 Minute
			],
			$Failed,
			Messages:>{
				Error::PrimerAnnealingMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FinalExtensionMismatch","FinalExtension options cannot have conflicts:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtension->False,
				FinalExtensionTime->2 Minute
			],
			$Failed,
			Messages:>{
				Error::FinalExtensionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ForwardPrimerStorageConditionMismatch","ForwardPrimerStorageCondition cannot have conflicts with the specified forward primers:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ForwardPrimerStorageCondition->Refrigerator
			],
			$Failed,
			Messages:>{
				Error::ForwardPrimerStorageConditionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ReversePrimerStorageConditionMismatch","ReversePrimerStorageCondition cannot have conflicts with the specified reverse primers:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ReversePrimerStorageCondition->Refrigerator
			],
			$Failed,
			Messages:>{
				Error::ReversePrimerStorageConditionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalVolumeOverReactionVolume","The total volume cannot exceed ReactionVolume:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				SampleVolume->50 Microliter
			],
			$Failed,
			Messages:>{
				Error::TotalVolumeOverReactionVolume,
				Error::InvalidOption
			}
		],


		(*===Options tests===*)


		(*---Shared options---*)
		Example[{Options,Preparation,"Manual preparation can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Preparation->Manual,
				Output->Options
			];
			Lookup[options,Preparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol=ExperimentPCR[
				"ExperimentPCR PreparatoryUnitOperations test vessel 1",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"ExperimentPCR PreparatoryUnitOperations test vessel 1",Container->Model[Container,Vessel,"2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"ExperimentPCR PreparatoryUnitOperations test vessel 1",Amount->2 Microliter]
				}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to prepare primer samples from models before the experiment is run:"},
			protocol=Quiet[
				ExperimentPCR[
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					{{"ExperimentPCR PreparatoryUnitOperations test vessel 1","ExperimentPCR PreparatoryUnitOperations test vessel 2"}},
					PreparatoryUnitOperations->{
						LabelContainer[Label->"ExperimentPCR PreparatoryUnitOperations test vessel 1",Container->Model[Container,Vessel,"2mL Tube"]],
						LabelContainer[Label->"ExperimentPCR PreparatoryUnitOperations test vessel 2",Container->Model[Container,Vessel,"2mL Tube"]],
						Transfer[
							Source->{Model[Sample,"Milli-Q water"], Model[Sample,"Milli-Q water"]},
							Destination->{"ExperimentPCR PreparatoryUnitOperations test vessel 1","ExperimentPCR PreparatoryUnitOperations test vessel 2"},
							Amount->{1 Microliter, 1 Microliter}
						]
					}
				],
				{Download::MissingCacheField}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared for only primer pair samples:"},
			options = ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}},
				PreparedModelContainer -> Model[Container, Plate, "id:01G6nvkKrrYm"],
				PreparedModelAmount -> 1 Microliter,
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
				{ObjectP[Model[Container, Plate, "id:01G6nvkKrrYm"]]..},
				{EqualP[1 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared for both input sample and primer pair samples:"},
			options = ExperimentPCR[
				Model[Sample, "DNA, Single-Stranded from Salmon Testes"],
				{{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}},
				PreparedModelContainer -> Model[Container, Plate, "id:01G6nvkKrrYm"],
				PreparedModelAmount -> 1 Microliter,
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
				{ObjectP[Model[Sample, "DNA, Single-Stranded from Salmon Testes"]], ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]], ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]},
				{ObjectP[Model[Container, Plate, "id:01G6nvkKrrYm"]]..},
				{EqualP[1 Microliter]..},
				{"A1", "B1", "C1"},
				{_String..}
			},
			Variables :> {options, prepUOs}
		],
		(* index matching here being wonky means the listy version of this test is actually rather different from the above version of this test *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared, this time when a list is specified for the prepared model options:"},
			options = ExperimentPCR[
				{Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID]},
				{{{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}}},
				PreparedModelContainer -> {Model[Container, Plate, "id:01G6nvkKrrYm"]},
				PreparedModelAmount -> {1 Microliter},
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
				{ObjectP[Model[Container, Plate, "id:01G6nvkKrrYm"]]..},
				{EqualP[1 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options,WorkCell,"WorkCell will be Null if Preparation is Manual:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Preparation-> Manual,
				Output->Options
			];
			Lookup[options,WorkCell],
			Null,
			Variables:>{options}
		],
		Example[{Options,WorkCell,"WorkCell will be resolved to an allowed WorkCell if Preparation is not Manual:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Preparation-> Robotic,
				Output->Options
			];
			Lookup[options,WorkCell],
			bioSTAR,
			Variables:>{options}
		],
		Example[{Options,Name,"Name of the output protocol object can be specified:"},
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Name->"ExperimentPCR name test protocol"<>$SessionUUID
			],
			Object[Protocol,PCR,"ExperimentPCR name test protocol"<>$SessionUUID]
		],
		Example[{Options,Template,"Template can be specified to inherit specified options from the parent protocol:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Template->Object[Protocol,PCR,"ExperimentPCR test protocol New"<>$SessionUUID,UnresolvedOptions],
				Output->Options
			];
			Lookup[options,LidTemperature],
			100 Celsius,
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition,"SamplesOutStorageCondition can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				SamplesOutStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],


		(*---Index-matched options---*)
		(* Label optiopns *)

		Example[{Options,SampleLabel,"Specify the SampleLabel"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				SampleLabel->"Test Label for SampleLabel",
				Output->Options
			];
			Lookup[options,SampleLabel],
			"Test Label for SampleLabel",
			Variables:>{options}
		],
		Example[{Options,SampleContainerLabel,"Specify the SampleContainerLabel"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				SampleContainerLabel->"Test Label for SampleContainerLabel",
				Output->Options
			];
			Lookup[options,SampleContainerLabel],
			"Test Label for SampleContainerLabel",
			Variables:>{options}
		],
		Example[{Options,PrimerPairLabel,"Specify the PrimerPairLabel"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				PrimerPairLabel->{{"Test Label for PrimerPairLabel1","Test Label for PrimerPairLabel2"}},
				Output->Options
			];
			Lookup[options,PrimerPairLabel],
			{{"Test Label for PrimerPairLabel1","Test Label for PrimerPairLabel2"}},
			Variables:>{options}
		],
		Example[{Options,PrimerPairContainerLabel,"Specify the PrimerPairContainerLabel"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				PrimerPairContainerLabel->{{"Test Label for PrimerPairContainerLabel1","Test Label for PrimerPairContainerLabel2"}},
				Output->Options
			];
			Lookup[options,PrimerPairContainerLabel],
			{{"Test Label for PrimerPairContainerLabel1","Test Label for PrimerPairContainerLabel2"}},
			Variables:>{options}
		],
		Example[{Options,SampleOutLabel,"Specify the SampleOutLabel"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				SampleOutLabel->"Test Label for SampleOutLabel",
				Output->Options
			];
			Lookup[options,SampleOutLabel],
			{"Test Label for SampleOutLabel"},
			Variables:>{options}
		],
		(*SampleVolume*)
		Example[{Options,SampleVolume,"SampleVolume can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				SampleVolume->2.2 Microliter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			2.2 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SampleVolume,"SampleVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				SampleVolume->2.22 Microliter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			2.2 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ForwardPrimerVolume*)
		Example[{Options,ForwardPrimerVolume,"ForwardPrimerVolume is automatically set to Null if no primers are specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,ForwardPrimerVolume],
			Null,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ForwardPrimerVolume,"ForwardPrimerVolume is automatically set to 1 microliter for each forward primer specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				Output->Options
			];
			Lookup[options,ForwardPrimerVolume],
			{1 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ForwardPrimerVolume,"ForwardPrimerVolume can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ForwardPrimerVolume->2.2 Microliter,
				Output->Options
			];
			Lookup[options,ForwardPrimerVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ForwardPrimerVolume,"ForwardPrimerVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ForwardPrimerVolume->2.22 Microliter,
				Output->Options
			];
			Lookup[options,ForwardPrimerVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ForwardPrimerStorageCondition*)
		Example[{Options,ForwardPrimerStorageCondition,"ForwardPrimerStorageCondition can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ForwardPrimerStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ForwardPrimerStorageCondition],
			{Refrigerator},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*ReversePrimerVolume*)
		Example[{Options,ReversePrimerVolume,"ReversePrimerVolume is automatically set to match ForwardPrimerVolume:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ForwardPrimerVolume->2.2 Microliter,
				Output->Options
			];
			Lookup[options,ReversePrimerVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ReversePrimerVolume,"ReversePrimerVolume can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ReversePrimerVolume->2.2 Microliter,
				Output->Options
			];
			Lookup[options,ReversePrimerVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ReversePrimerVolume,"ReversePrimerVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ReversePrimerVolume->2.22 Microliter,
				Output->Options
			];
			Lookup[options,ReversePrimerVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ReversePrimerStorageCondition*)
		Example[{Options,ReversePrimerStorageCondition,"ReversePrimerStorageCondition can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				ReversePrimerStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ReversePrimerStorageCondition],
			{Refrigerator},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*BufferVolume*)
		Example[{Options,BufferVolume,"BufferVolume is automatically set to Null if Buffer is set to Null:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				Buffer->Null,
				Output->Options
			];
			Lookup[options,BufferVolume],
			Null,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume is automatically set according to the equation BufferVolume=ReactionVolume-(SampleVolume+MasterMixVolume+ForwardPrimerVolume+ReversePrimerVolume):"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				Output->Options
			];
			Lookup[options,BufferVolume],
			{6 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume is automatically set when multiple samples and primer pairs are given:"},
			options=ExperimentPCR[
				{
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID]
				},
				{
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						}
					},
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						},
						{
							Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]
						}
					}
				},
				Output->Options
			];
			Lookup[options,BufferVolume],
			{{6 Microliter},{6 Microliter,6 Microliter}},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume can be specified when 1 primer pair is given:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				BufferVolume->2.2 Microliter,
				Output->Options
			];
			Lookup[options,BufferVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume can be specified when 2 primer pairs are given for the same sample:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{
					{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]},
					{Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]}
				},
				BufferVolume->{2.2 Microliter,2.2 Microliter},
				Output->Options
			];
			Lookup[options,BufferVolume],
			{2.2 Microliter,2.2 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume can be specified when multiple samples and primer pairs are given:"},
			options=ExperimentPCR[
				{
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID]
				},
				{
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						}
					},
					{
						{
							Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]
						},
						{
							Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
							Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID]
						}
					}
				},
				BufferVolume->{{2.2 Microliter},{2.2 Microliter,2.2 Microliter}},
				Output->Options
			];
			Lookup[options,BufferVolume],
			{{2.2 Microliter},{2.2 Microliter,2.2 Microliter}},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferVolume,"BufferVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}},
				BufferVolume->2.22 Microliter,
				Output->Options
			];
			Lookup[options,BufferVolume],
			{2.2 Microliter},
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*---Global options---*)
		Example[{Options,Instrument,"Instrument can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Instrument->Model[Instrument,Thermocycler,"Automated Thermal Cycler"],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument,Thermocycler,"Automated Thermal Cycler"]],
			Variables:>{options}
		],
		Example[{Options,LidTemperature,"LidTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				LidTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,LidTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,LidTemperature,"LidTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				LidTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,LidTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,ReactionVolume,"ReactionVolume can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ReactionVolume->12.2 Microliter,
				Output->Options
			];
			Lookup[options,ReactionVolume],
			12.2 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ReactionVolume,"ReactionVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ReactionVolume->12.22 Microliter,
				Output->Options
			];
			Lookup[options,ReactionVolume],
			12.2 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*MasterMix*)
		Example[{Options,MasterMix,"MasterMix can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMix->Model[Sample,"DreamTaq PCR Master Mix"],
				Output->Options
			];
			Lookup[options,MasterMix],
			ObjectP[Model[Sample,"DreamTaq PCR Master Mix"]],
			Variables:>{options}
		],
		(*MasterMixVolume*)
		Example[{Options,MasterMixVolume,"MasterMixVolume is automatically set to Null if MasterMix is set to Null:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMix->Null,
				Output->Options
			];
			Lookup[options,MasterMixVolume],
			Null,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MasterMixVolume,"MasterMixVolume is automatically set to 0.5*ReactionVolume if MasterMix is not set to Null:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,MasterMixVolume],
			10 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MasterMixVolume,"MasterMixVolume can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMixVolume->12.2 Microliter,
				Output->Options
			];
			Lookup[options,MasterMixVolume],
			12.2 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MasterMixVolume,"MasterMixVolume, if specified, is rounded to the nearest 0.1 microliter:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMixVolume->12.22 Microliter,
				Output->Options
			];
			Lookup[options,MasterMixVolume],
			12.2 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*MasterMixStorageCondition*)
		Example[{Options,MasterMixStorageCondition,"MasterMixStorageCondition can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				MasterMix->Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],
				MasterMixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,MasterMixStorageCondition],
			Refrigerator,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Buffer*)
		Example[{Options,Buffer,"Buffer can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Buffer->Model[Sample,"Nuclease-free Water"],
				Output->Options
			];
			Lookup[options,Buffer],
			ObjectP[Model[Sample,"Nuclease-free Water"]],
			Variables:>{options}
		],


		(*---Activation options---*)

		(*Activation*)
		Example[{Options,Activation,"Activation is automatically set to False if none of the other Activation options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Activation],
			False,
			Variables:>{options}
		],
		Example[{Options,Activation,"Activation is automatically set to True if any of the other Activation options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationTime->30 Second,
				Output->Options
			];
			Lookup[options,Activation],
			True,
			Variables:>{options}
		],
		(*ActivationTime*)
		Example[{Options,ActivationTime,"ActivationTime is automatically set to Null if Activation is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,ActivationTime],
			Null,
			Variables:>{options}
		],
		Example[{Options,ActivationTime,"ActivationTime is automatically set to 60 seconds if Activation is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Activation->True,
				Output->Options
			];
			Lookup[options,ActivationTime],
			60 Second,
			Variables:>{options}
		],
		Example[{Options,ActivationTime,"ActivationTime can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationTime->22 Second,
				Output->Options
			];
			Lookup[options,ActivationTime],
			22 Second,
			Variables:>{options}
		],
		Example[{Options,ActivationTime,"ActivationTime, if specified, is rounded to the nearest second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationTime->22.2 Second,
				Output->Options
			];
			Lookup[options,ActivationTime],
			22 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ActivationTemperature*)
		Example[{Options,ActivationTemperature,"ActivationTemperature is automatically set to Null if Activation is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,ActivationTemperature],
			Null,
			Variables:>{options}
		],
		Example[{Options,ActivationTemperature,"ActivationTemperature is automatically set to 95 degrees Celsius if Activation is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Activation->True,
				Output->Options
			];
			Lookup[options,ActivationTemperature],
			95 Celsius,
			Variables:>{options}
		],
		Example[{Options,ActivationTemperature,"ActivationTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,ActivationTemperature],
			102.2 Celsius,
			Variables:>{options}
		],
		Example[{Options,ActivationTemperature,"ActivationTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,ActivationTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ActivationRampRate*)
		Example[{Options,ActivationRampRate,"ActivationRampRate is automatically set to Null if Activation is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,ActivationRampRate],
			Null,
			Variables:>{options}
		],
		Example[{Options,ActivationRampRate,"ActivationRampRate is automatically set to 3.5 degrees Celsius per second if Activation is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Activation->True,
				Output->Options
			];
			Lookup[options,ActivationRampRate],
			3.5 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,ActivationRampRate,"ActivationRampRate can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationRampRate->1.2 (Celsius/Second),
				Output->Options
			];
			Lookup[options,ActivationRampRate],
			1.2 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,ActivationRampRate,"ActivationRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ActivationRampRate->1.22 (Celsius/Second),
				Output->Options
			];
			Lookup[options,ActivationRampRate],
			1.2 (Celsius/Second),
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*---Denaturation options---*)

		(*DenaturationTime*)
		Example[{Options,DenaturationTime,"DenaturationTime can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationTime->22 Second,
				Output->Options
			];
			Lookup[options,DenaturationTime],
			22 Second,
			Variables:>{options}
		],
		Example[{Options,DenaturationTime,"DenaturationTime, if specified, is rounded to the nearest second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationTime->22.2 Second,
				Output->Options
			];
			Lookup[options,DenaturationTime],
			22 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*DenaturationTemperature*)
		Example[{Options,DenaturationTemperature,"DenaturationTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,DenaturationTemperature],
			102.2 Celsius,
			Variables:>{options}
		],
		Example[{Options,DenaturationTemperature,"DenaturationTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,DenaturationTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*DenaturationRampRate*)
		Example[{Options,DenaturationRampRate,"DenaturationRampRate can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationRampRate->1.2 (Celsius/Second),
				Output->Options
			];
			Lookup[options,DenaturationRampRate],
			1.2 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,DenaturationRampRate,"DenaturationRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				DenaturationRampRate->1.22 (Celsius/Second),
				Output->Options
			];
			Lookup[options,DenaturationRampRate],
			1.2 (Celsius/Second),
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*---Primer annealing options---*)

		(*PrimerAnnealing*)
		Example[{Options,PrimerAnnealing,"PrimerAnnealing is automatically set to False if none of the other PrimerAnnealing options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PrimerAnnealing],
			False,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealing,"PrimerAnnealing is automatically set to True if any of the other PrimerAnnealing options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingTime->30 Second,
				Output->Options
			];
			Lookup[options,PrimerAnnealing],
			True,
			Variables:>{options}
		],
		(*PrimerAnnealingTime*)
		Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime is automatically set to Null if PrimerAnnealing is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PrimerAnnealingTime],
			Null,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime is automatically set to 30 seconds if PrimerAnnealing is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealing->True,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTime],
			30 Second,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingTime->22 Second,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTime],
			22 Second,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTime,"PrimerAnnealingTime, if specified, is rounded to the nearest second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingTime->22.2 Second,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTime],
			22 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*PrimerAnnealingTemperature*)
		Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature is automatically set to Null if PrimerAnnealing is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PrimerAnnealingTemperature],
			Null,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature is automatically set to 60 degrees Celsius if PrimerAnnealing is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealing->True,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTemperature],
			60 Celsius,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTemperature],
			102.2 Celsius,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingTemperature,"PrimerAnnealingTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,PrimerAnnealingTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*PrimerAnnealingRampRate*)
		Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate is automatically set to Null if PrimerAnnealing is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PrimerAnnealingRampRate],
			Null,
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate is automatically set to 3.5 degrees Celsius per second if PrimerAnnealing is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealing->True,
				Output->Options
			];
			Lookup[options,PrimerAnnealingRampRate],
			3.5 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingRampRate->1.2 (Celsius/Second),
				Output->Options
			];
			Lookup[options,PrimerAnnealingRampRate],
			1.2 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,PrimerAnnealingRampRate,"PrimerAnnealingRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				PrimerAnnealingRampRate->1.22 (Celsius/Second),
				Output->Options
			];
			Lookup[options,PrimerAnnealingRampRate],
			1.2 (Celsius/Second),
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*---Extension options---*)

		(*ExtensionTime*)
		Example[{Options,ExtensionTime,"ExtensionTime can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionTime->22 Second,
				Output->Options
			];
			Lookup[options,ExtensionTime],
			22 Second,
			Variables:>{options}
		],
		Example[{Options,ExtensionTime,"ExtensionTime, if specified, is rounded to the nearest second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionTime->22.2 Second,
				Output->Options
			];
			Lookup[options,ExtensionTime],
			22 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ExtensionTemperature*)
		Example[{Options,ExtensionTemperature,"ExtensionTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,ExtensionTemperature],
			102.2 Celsius,
			Variables:>{options}
		],
		Example[{Options,ExtensionTemperature,"ExtensionTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,ExtensionTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*ExtensionRampRate*)
		Example[{Options,ExtensionRampRate,"ExtensionRampRate can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionRampRate->1.2 (Celsius/Second),
				Output->Options
			];
			Lookup[options,ExtensionRampRate],
			1.2 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,ExtensionRampRate,"ExtensionRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionRampRate->1.22 (Celsius/Second),
				Output->Options
			];
			Lookup[options,ExtensionRampRate],
			1.2 (Celsius/Second),
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*---Final extension options---*)

		(*FinalExtension*)
		Example[{Options,FinalExtension,"FinalExtension is automatically set to False if none of the other FinalExtension options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,FinalExtension],
			False,
			Variables:>{options}
		],
		Example[{Options,FinalExtension,"FinalExtension is automatically set to True if any of the other FinalExtension options are set:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionTime->30 Second,
				Output->Options
			];
			Lookup[options,FinalExtension],
			True,
			Variables:>{options}
		],
		(*FinalExtensionTime*)
		Example[{Options,FinalExtensionTime,"FinalExtensionTime is automatically set to Null if FinalExtension is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,FinalExtensionTime],
			Null,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTime,"FinalExtensionTime is automatically set to 10 minutes if FinalExtension is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtension->True,
				Output->Options
			];
			Lookup[options,FinalExtensionTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTime,"FinalExtensionTime can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionTime->2.2 Minute,
				Output->Options
			];
			Lookup[options,FinalExtensionTime],
			2.2 Minute,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTime,"FinalExtensionTime, if specified, is rounded to the nearest second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionTime->2.22 Minute,
				Output->Options
			];
			Lookup[options,FinalExtensionTime],
			133 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*FinalExtensionTemperature*)
		Example[{Options,FinalExtensionTemperature,"FinalExtensionTemperature is automatically set to Null if FinalExtension is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,FinalExtensionTemperature],
			Null,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTemperature,"FinalExtensionTemperature is automatically set to ExtensionTemperature if FinalExtension is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				ExtensionTemperature->102.2 Celsius,
				FinalExtension->True,
				Output->Options
			];
			Lookup[options,FinalExtensionTemperature],
			Lookup[options,ExtensionTemperature],
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTemperature,"FinalExtensionTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionTemperature->102.2 Celsius,
				Output->Options
			];
			Lookup[options,FinalExtensionTemperature],
			102.2 Celsius,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionTemperature,"FinalExtensionTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionTemperature->102.22 Celsius,
				Output->Options
			];
			Lookup[options,FinalExtensionTemperature],
			102.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*FinalExtensionRampRate*)
		Example[{Options,FinalExtensionRampRate,"FinalExtensionRampRate is automatically set to Null if FinalExtension is set to False:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,FinalExtensionRampRate],
			Null,
			Variables:>{options}
		],
		Example[{Options,FinalExtensionRampRate,"FinalExtensionRampRate is automatically set to 3.5 degrees Celsius per second if FinalExtension is set to True:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtension->True,
				Output->Options
			];
			Lookup[options,FinalExtensionRampRate],
			3.5 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,FinalExtensionRampRate,"FinalExtensionRampRate can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionRampRate->1.2 (Celsius/Second),
				Output->Options
			];
			Lookup[options,FinalExtensionRampRate],
			1.2 (Celsius/Second),
			Variables:>{options}
		],
		Example[{Options,FinalExtensionRampRate,"FinalExtensionRampRate, if specified, is rounded to the nearest 0.1 degree Celsius/Second:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				FinalExtensionRampRate->1.22 (Celsius/Second),
				Output->Options
			];
			Lookup[options,FinalExtensionRampRate],
			1.2 (Celsius/Second),
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*Infinite hold option*)
		Example[{Options,HoldTemperature,"HoldTemperature can be specified:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				HoldTemperature->10.2 Celsius,
				Output->Options
			];
			Lookup[options,HoldTemperature],
			10.2 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,HoldTemperature,"HoldTemperature, if specified, is rounded to the nearest 0.1 degree Celsius:"},
			options=ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				HoldTemperature->10.22 Celsius,
				Output->Options
			];
			Lookup[options,HoldTemperature],
			10.2 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],


		(*===Tests===*)
		Test["Accepts a model-less sample object:",
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test model-less sample"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Test["Accepts multiple sample objects:",
			ExperimentPCR[
				{
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Test["Accepts multiple non-empty container objects:",
			ExperimentPCR[
				{
					Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID],
					Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,PCR]]
		],
		Test["Accepts non-empty container objects as primers:",
			ExperimentPCR[
				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				{{Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID],Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID]}}
			],
			ObjectP[Object[Protocol,PCR]]
		],


		(*===Shared sample prep options tests===*)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],

		(*Incubate options tests*)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle*)
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubateAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		(*Note: You CANNOT be in a plate for the following test*)
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],MixType->Shake,Output->Options];
			Lookup[options,MixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

		(*Centrifuge options tests*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		(*Note: CentrifugeTime cannot go above 5 minutes without restricting the types of centrifuges that can be used*)
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: Put your sample in a 2mL tube for the following test*)
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		(*Filter options tests*)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FiltrationType->Syringe,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterMaterial->PES,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterSterile->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],

		(*Aliquot options tests*)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AliquotAmount->0.5*Milliliter,Output->Options];
			Lookup[options,AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],TargetConcentration->1*Micromolar,TargetConcentrationAnalyte->Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.1*Milliliter,AssayVolume->0.2*Milliliter,Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],

		(*Post-processing options tests*)
		Example[{Options,MeasureWeight,"Set the MeasureWeight option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],MeasureWeight->True,Output->Options];
			Lookup[options,MeasureWeight],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Set the MeasureVolume option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],MeasureVolume->True,Output->Options];
			Lookup[options,MeasureVolume],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Set the ImageSample option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
			options=ExperimentPCR[Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Messages:> {Warning::PostProcessingSterileSamples},
			Variables:>{options}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},

	SetUp:>{ClearDownload[]; ClearMemoization[];},

	SymbolSetUp:>(
		ClearDownload[];
		ClearMemoization[];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentPCR test 2mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentPCR test 50mL tube"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCR test DNA sample"<>$SessionUUID],
				Model[Sample,"ExperimentPCR test DNA sample (Deprecated)"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test discarded sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test discarded primer sample forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test discarded primer sample reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test deprecated model sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test deprecated model primer sample forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test deprecated model primer sample reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test model-less sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in prepared plate"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID],
				Object[Item,PlateSeal,"ExperimentPCR test plate seal"<>$SessionUUID],

				If[DatabaseMemberQ[Object[Protocol,PCR,"ExperimentPCR test protocol New"<>$SessionUUID]],
					Download[Object[Protocol,PCR,"ExperimentPCR test protocol New"<>$SessionUUID],{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
				],

				If[DatabaseMemberQ[Object[Protocol,PCR,"ExperimentPCR name test protocol"<>$SessionUUID]],
					Download[Object[Protocol,PCR,"ExperimentPCR name test protocol"<>$SessionUUID],{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
				]
			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{containerSampleObjects,testProtocol,protocolObjects,allObjects},

				(*Gather all the created objects and models*)
				containerSampleObjects={
					Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID],
					Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID],
					Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID],
					Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate"<>$SessionUUID],
					Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID],
					Object[Container,Vessel,"ExperimentPCR test 2mL tube"<>$SessionUUID],
					Object[Container,Vessel,"ExperimentPCR test 50mL tube"<>$SessionUUID],

					Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID],

					Model[Sample,"ExperimentPCR test DNA sample"<>$SessionUUID],
					Model[Sample,"ExperimentPCR test DNA sample (Deprecated)"<>$SessionUUID],

					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID],

					Object[Sample,"ExperimentPCR test discarded sample"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test discarded primer sample forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test discarded primer sample reverse"<>$SessionUUID],

					Object[Sample,"ExperimentPCR test deprecated model sample"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test deprecated model primer sample forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test deprecated model primer sample reverse"<>$SessionUUID],

					Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],

					Object[Sample,"ExperimentPCR test model-less sample"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample in prepared plate"<>$SessionUUID],
					Object[Sample,"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID],
					Object[Item,PlateSeal,"ExperimentPCR test plate seal"<>$SessionUUID]
				};

				(*Make some empty test container objects*)
				Upload[{
					<|
						Type->Object[Container,Plate],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Plate],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Plate],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Plate],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test Prepared 96-well PCR plate"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Plate],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test 2mL tube"<>$SessionUUID
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
						Site->Link[$Site],
						Name->"ExperimentPCR test 50mL tube"<>$SessionUUID
					|>
				}];

				(*Make a test DNA identity model*)
				UploadOligomer["ExperimentPCR test DNA molecule"<>$SessionUUID,Molecule->Strand[DNA["AATTCCGG"]],PolymerType->DNA];
				Upload[<|Object->Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID],Transfer[Notebook]->Null,DeveloperObject->True|>];

				(*Make some test sample models*)
				UploadSampleModel[
					{
						"ExperimentPCR test DNA sample" <> $SessionUUID,
						"ExperimentPCR test DNA sample (Deprecated)" <> $SessionUUID
					},
					Composition ->
						{
							{{10 Micromolar, Model[Molecule, Oligomer, "ExperimentPCR test DNA molecule" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}},
							{{10 Micromolar, Model[Molecule, Oligomer, "ExperimentPCR test DNA molecule" <> $SessionUUID]}, {100 VolumePercent, Model[Molecule, "Water"]}}
						},
					IncompatibleMaterials -> {{None}, {None}},
					Expires -> {True, True},
					ShelfLife -> {2 Year, 2 Year},
					UnsealedShelfLife -> {90 Day, 90 Day},
					DefaultStorageCondition -> {Model[StorageCondition, "Refrigerator"], Model[StorageCondition, "Refrigerator"]},
					MSDSRequired -> {False, False},
					BiosafetyLevel -> {"BSL-1", "BSL-1"},
					State -> {Liquid, Liquid}
				];

				(*Make a deprecated test sample model*)
				Upload[
					<|
						Object->Model[Sample,"ExperimentPCR test DNA sample (Deprecated)"<>$SessionUUID],
						Deprecated->True
					|>
				];

				(*Make some test sample objects in the test container objects*)
				UploadSample[
					Join[
						ConstantArray[Model[Sample, "ExperimentPCR test DNA sample" <> $SessionUUID], 9],
						ConstantArray[Model[Sample, "ExperimentPCR test DNA sample (Deprecated)" <> $SessionUUID], 3],
						ConstantArray[Model[Sample, "ExperimentPCR test DNA sample" <> $SessionUUID], 2]
					],
					{
						{"A1", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 1" <> $SessionUUID]},
						{"A1", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"A2", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"A3", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"A4", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"A5", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},

						{"C1", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"C2", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"C3", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},

						{"B1", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"B2", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},
						{"B3", Object[Container, Plate, "ExperimentPCR test 96-well PCR plate 2" <> $SessionUUID]},

						{"A1", Object[Container, Vessel, "ExperimentPCR test 2mL tube" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "ExperimentPCR test 50mL tube" <> $SessionUUID]}
					},
					Name -> {
						"ExperimentPCR test sample 1" <> $SessionUUID,
						"ExperimentPCR test sample 2" <> $SessionUUID,
						"ExperimentPCR test primer sample 1 forward" <> $SessionUUID,
						"ExperimentPCR test primer sample 1 reverse" <> $SessionUUID,
						"ExperimentPCR test primer sample 2 forward" <> $SessionUUID,
						"ExperimentPCR test primer sample 2 reverse" <> $SessionUUID,

						"ExperimentPCR test discarded sample" <> $SessionUUID,
						"ExperimentPCR test discarded primer sample forward" <> $SessionUUID,
						"ExperimentPCR test discarded primer sample reverse" <> $SessionUUID,

						"ExperimentPCR test deprecated model sample" <> $SessionUUID,
						"ExperimentPCR test deprecated model primer sample forward" <> $SessionUUID,
						"ExperimentPCR test deprecated model primer sample reverse" <> $SessionUUID,

						"ExperimentPCR test sample in 2mL tube" <> $SessionUUID,
						"ExperimentPCR test sample in 50mL tube" <> $SessionUUID
					},
					InitialAmount -> Join[
						ConstantArray[0.5 Milliliter, 13],
						{5 Milliliter}
					]
				];

				(*Modify some properties of the test sample objects*)
				UploadSampleStatus[
					{
						Object[Sample,"ExperimentPCR test discarded sample"<>$SessionUUID],
						Object[Sample,"ExperimentPCR test discarded primer sample forward"<>$SessionUUID],
						Object[Sample,"ExperimentPCR test discarded primer sample reverse"<>$SessionUUID]
					},
					ConstantArray[Discarded,3]
				];

				(*Make a test model-less sample object*)
				UploadSample[
					{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					{"A1",Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID]},
					Name->"ExperimentPCR test model-less sample"<>$SessionUUID,
					InitialAmount->0.5 Milliliter
				];
				(*Make a test sample object in a prepared PCR plate without cover*)
				UploadSample[
					{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					{"A1",Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate"<>$SessionUUID]},
					Name->"ExperimentPCR test sample in prepared plate"<>$SessionUUID,
					InitialAmount->0.02 Milliliter
				];
				(*Make a test sample object in a prepared PCR plate with plate seal*)
				UploadSample[
					{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					{"A1",Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID]},
					Name->"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID,
					InitialAmount->0.02 Milliliter
				];
				(*Create a plate seal object*)
				Upload[<|
					Type->Object[Item,PlateSeal],
					Site->Link[$Site],
					Model->Link[Model[Item, PlateSeal, "96-Well Plate Seal, EZ-Pierce Zone-Free"],Objects],
					Name->"ExperimentPCR test plate seal"<>$SessionUUID
				|>];
				(*Cover the ExperimentPCR test Prepared 96-well PCR plate with cover after sample addition*)
				Upload[<|
					Object->Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID],
					Cover->Link[Object[Item,PlateSeal,"ExperimentPCR test plate seal"<>$SessionUUID],CoveredContainer]
				|>];

				(*Generate a test protocol*)
				testProtocol=ExperimentPCR[
					Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
					{
						{{Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID]}}
					},
					Name->"ExperimentPCR test protocol New"<>$SessionUUID,
					LidTemperature->100 Celsius
				];

				(*Get the objects generated in the test protocol*)
				protocolObjects=Download[testProtocol,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{containerSampleObjects,protocolObjects}];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects]
			]
		];
	),


	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		Module[{allObjects,existingObjects},
			On[Warning::DeprecatedProduct];
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				$CreatedObjects,
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 1"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 2"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test 96-well PCR plate 3"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate"<>$SessionUUID],
				Object[Container,Plate,"ExperimentPCR test Prepared 96-well PCR plate with cover"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentPCR test 2mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentPCR test 50mL tube"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCR test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCR test DNA sample"<>$SessionUUID],
				Model[Sample,"ExperimentPCR test DNA sample (Deprecated)"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample 2"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 1 reverse"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 2 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test primer sample 2 reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test discarded sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test discarded primer sample forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test discarded primer sample reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test deprecated model sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test deprecated model primer sample forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test deprecated model primer sample reverse"<>$SessionUUID],

				Object[Sample,"ExperimentPCR test model-less sample"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in prepared plate"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in prepared plate with cover"<>$SessionUUID],
				Object[Item,PlateSeal,"ExperimentPCR test plate seal"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in 2mL tube"<>$SessionUUID],
				Object[Sample,"ExperimentPCR test sample in 50mL tube"<>$SessionUUID],

				If[DatabaseMemberQ[Object[Protocol,PCR,"ExperimentPCR test protocol New"<>$SessionUUID]],
					Download[Object[Protocol,PCR,"ExperimentPCR test protocol New"<>$SessionUUID],{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
				],

				If[DatabaseMemberQ[Object[Protocol,PCR,"ExperimentPCR name test protocol"<>$SessionUUID]],
					Download[Object[Protocol,PCR,"ExperimentPCR name test protocol"<>$SessionUUID],{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
				]
			}],ObjectP[]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force->True, Verbose->False]];
			Unset[$CreatedObjects];
		];
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentPCROptions*)


DefineTests[ExperimentPCROptions,
	{
		Example[{Basic,"Returns the options in table form given a sample:"},
			ExperimentPCROptions[
				Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"Returns the options in table form given a sample and a pair of primers:"},
			ExperimentPCROptions[
				Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCROptions test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCROptions test primer sample 1 reverse"<>$SessionUUID]}}
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			ExperimentPCROptions[
				Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID],
				OutputFormat->List
			],
			{_Rule..}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			Off[Warning::DeprecatedProduct];
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCROptions test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCROptions test DNA sample"<>$SessionUUID],

				Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCROptions test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCROptions test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{containerSampleObjects},

				(*Gather all the created objects and models*)
				containerSampleObjects={
					Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID],

					Model[Molecule,Oligomer,"ExperimentPCROptions test DNA molecule"<>$SessionUUID],

					Model[Sample,"ExperimentPCROptions test DNA sample"<>$SessionUUID],

					Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCROptions test primer sample 1 forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCROptions test primer sample 1 reverse"<>$SessionUUID]
				};

				(*Make an empty container object*)
				Upload[
					<|
						Type->Object[Container,Plate],
						Site->Link[$Site],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Name->"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID
					|>
				];

				(*Make a test DNA identity model*)
				UploadOligomer["ExperimentPCROptions test DNA molecule"<>$SessionUUID,Molecule->Strand[DNA["AATTCCGG"]],PolymerType->DNA];
				Upload[<|Object->Model[Molecule,Oligomer,"ExperimentPCROptions test DNA molecule"<>$SessionUUID],Transfer[Notebook]->Null,DeveloperObject->True|>];

				(*Make a test sample model*)
				UploadSampleModel[
					"ExperimentPCROptions test DNA sample"<>$SessionUUID,
					Composition->{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentPCROptions test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					IncompatibleMaterials->{None},
					Expires->True,
					ShelfLife->2 Year,
					UnsealedShelfLife->90 Day,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					MSDSRequired->False,
					BiosafetyLevel->"BSL-1",
					State->Liquid
				];

				(*Make some test sample objects in the test container objects*)
				UploadSample[
					ConstantArray[Model[Sample,"ExperimentPCROptions test DNA sample"<>$SessionUUID],3],
					{
						{"A1",Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID]},
						{"A3",Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID]}
					},
					Name->
							{
								"ExperimentPCROptions test sample 1"<>$SessionUUID,
								"ExperimentPCROptions test primer sample 1 forward"<>$SessionUUID,
								"ExperimentPCROptions test primer sample 1 reverse"<>$SessionUUID
							},
					InitialAmount->ConstantArray[0.2 Milliliter,3]
				];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@containerSampleObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::DeprecatedProduct];
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ExperimentPCROptions test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCROptions test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCROptions test DNA sample"<>$SessionUUID],

				Object[Sample,"ExperimentPCROptions test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCROptions test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCROptions test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentPCRPreview*)


DefineTests[ExperimentPCRPreview,
	{
		Example[{Basic,"Returns Null given a sample:"},
			ExperimentPCRPreview[
				Object[Sample,"ExperimentPCRPreview test sample 1"<>$SessionUUID]
			],
			Null
		],
		Example[{Basic,"Returns Null given a sample and a pair of primers:"},
			ExperimentPCRPreview[
				Object[Sample,"ExperimentPCRPreview test sample 1"<>$SessionUUID],
				{{Object[Sample,"ExperimentPCRPreview test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ExperimentPCRPreview test primer sample 1 reverse"<>$SessionUUID]}}
			],
			Null
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			Off[Warning::DeprecatedProduct];
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCRPreview test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCRPreview test DNA sample"<>$SessionUUID],

				Object[Sample,"ExperimentPCRPreview test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCRPreview test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCRPreview test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{containerSampleObjects},

				(*Gather all the created objects and models*)
				containerSampleObjects={
					Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID],

					Model[Molecule,Oligomer,"ExperimentPCRPreview test DNA molecule"<>$SessionUUID],

					Model[Sample,"ExperimentPCRPreview test DNA sample"<>$SessionUUID],

					Object[Sample,"ExperimentPCRPreview test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentPCRPreview test primer sample 1 forward"<>$SessionUUID],
					Object[Sample,"ExperimentPCRPreview test primer sample 1 reverse"<>$SessionUUID]
				};

				(*Make an empty container object*)
				Upload[
					<|
						Type->Object[Container,Plate],
						Site->Link[$Site],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Name->"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID
					|>
				];

				(*Make a test DNA identity model*)
				UploadOligomer["ExperimentPCRPreview test DNA molecule"<>$SessionUUID,Molecule->Strand[DNA["AATTCCGG"]],PolymerType->DNA];
				Upload[<|Object->Model[Molecule,Oligomer,"ExperimentPCRPreview test DNA molecule"<>$SessionUUID],Transfer[Notebook]->Null,DeveloperObject->True|>];

				(*Make a test sample model*)
				UploadSampleModel[
					"ExperimentPCRPreview test DNA sample"<>$SessionUUID,
					Composition->{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentPCRPreview test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					IncompatibleMaterials->{None},
					Expires->True,
					ShelfLife->2 Year,
					UnsealedShelfLife->90 Day,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					MSDSRequired->False,
					BiosafetyLevel->"BSL-1",
					State->Liquid
				];

				(*Make some test sample objects in the test container objects*)
				UploadSample[
					ConstantArray[Model[Sample,"ExperimentPCRPreview test DNA sample"<>$SessionUUID],3],
					{
						{"A1",Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID]},
						{"A3",Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID]}
					},
					Name ->
							{
								"ExperimentPCRPreview test sample 1"<>$SessionUUID,
								"ExperimentPCRPreview test primer sample 1 forward"<>$SessionUUID,
								"ExperimentPCRPreview test primer sample 1 reverse"<>$SessionUUID
							},
					InitialAmount->ConstantArray[0.2 Milliliter,3]
				];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@containerSampleObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::DeprecatedProduct];
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ExperimentPCRPreview test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ExperimentPCRPreview test DNA molecule"<>$SessionUUID],

				Model[Sample,"ExperimentPCRPreview test DNA sample"<>$SessionUUID],

				Object[Sample,"ExperimentPCRPreview test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentPCRPreview test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ExperimentPCRPreview test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentPCRQ*)


DefineTests[ValidExperimentPCRQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a PCR experimental setup on a sample:"},
			ValidExperimentPCRQ[
				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID]
			],
			True
		],
		Example[{Basic,"Returns a Boolean indicating the validity of a PCR experimental setup on a sample and a pair of primers:"},
			ValidExperimentPCRQ[
				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
				{{Object[Sample,"ValidExperimentPCRQ test primer sample 1 forward"<>$SessionUUID],Object[Sample,"ValidExperimentPCRQ test primer sample 1 reverse"<>$SessionUUID]}}
			],
			True
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentPCRQ[
				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentPCRQ[
				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ValidExperimentPCRQ test DNA molecule"<>$SessionUUID],

				Model[Sample,"ValidExperimentPCRQ test DNA sample"<>$SessionUUID],

				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
				Object[Sample,"ValidExperimentPCRQ test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ValidExperimentPCRQ test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{containerSampleObjects},

				(*Gather all the created objects and models*)
				containerSampleObjects={
					Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID],

					Model[Molecule,Oligomer,"ValidExperimentPCRQ test DNA molecule"<>$SessionUUID],

					Model[Sample,"ValidExperimentPCRQ test DNA sample"<>$SessionUUID],

					Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
					Object[Sample,"ValidExperimentPCRQ test primer sample 1 forward"<>$SessionUUID],
					Object[Sample,"ValidExperimentPCRQ test primer sample 1 reverse"<>$SessionUUID]
				};

				(*Make an empty container object*)
				Upload[
					<|
						Type->Object[Container,Plate],
						Site->Link[$Site],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Name->"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID
					|>
				];

				(*Make a test DNA identity model*)
				UploadOligomer["ValidExperimentPCRQ test DNA molecule"<>$SessionUUID,Molecule->Strand[DNA["AATTCCGG"]],PolymerType->DNA];
				Upload[<|Object->Model[Molecule,Oligomer,"ValidExperimentPCRQ test DNA molecule"<>$SessionUUID],Transfer[Notebook]->Null,DeveloperObject->True|>];

				(*Make a test sample model*)
				UploadSampleModel[
					"ValidExperimentPCRQ test DNA sample"<>$SessionUUID,
					Composition->{{10 Micromolar,Model[Molecule,Oligomer,"ValidExperimentPCRQ test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					IncompatibleMaterials->{None},
					Expires->True,
					ShelfLife->2 Year,
					UnsealedShelfLife->90 Day,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					MSDSRequired->False,
					BiosafetyLevel->"BSL-1",
					State->Liquid
				];

				(*Make some test sample objects in the test container objects*)
				UploadSample[
					ConstantArray[Model[Sample,"ValidExperimentPCRQ test DNA sample"<>$SessionUUID],3],
					{
						{"A1",Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID]},
						{"A3",Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID]}
					},
					Name->
							{
								"ValidExperimentPCRQ test sample 1"<>$SessionUUID,
								"ValidExperimentPCRQ test primer sample 1 forward"<>$SessionUUID,
								"ValidExperimentPCRQ test primer sample 1 reverse"<>$SessionUUID
							},
					InitialAmount->ConstantArray[0.2 Milliliter,3]
				];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@containerSampleObjects]
			]
		];
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"ValidExperimentPCRQ test 96-well PCR plate 1"<>$SessionUUID],

				Model[Molecule,Oligomer,"ValidExperimentPCRQ test DNA molecule"<>$SessionUUID],

				Model[Sample,"ValidExperimentPCRQ test DNA sample"<>$SessionUUID],

				Object[Sample,"ValidExperimentPCRQ test sample 1"<>$SessionUUID],
				Object[Sample,"ValidExperimentPCRQ test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"ValidExperimentPCRQ test primer sample 1 reverse"<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*PCR*)
(* This is the unit test for the primitive heads *)

DefineTests[PCR,
	{
		Example[{Basic,"Returns sample preparation protocols or scripts to run a polymerase chain reaction (PCR) experiment, which uses a thermocycler to amplify target sequences from the sample:"},
			ExperimentManualSamplePreparation[
				PCR[
					Sample->Object[Sample,"PCR primitive test sample 1"<>$SessionUUID]
				]
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic,"Can specified PrimerPair for this primitive:"},
			ExperimentManualSamplePreparation[
				PCR[
					Sample->Object[Sample,"PCR primitive test sample 1"<>$SessionUUID],
					PrimerPair->{{Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]}}
				]
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic,"Can specified PrimerPair for this primitive:"},
			ExperimentManualSamplePreparation[
				{
					LabelContainer[
						Label->"my container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Destination->"my container",
						Amount->10 Milliliter
					],
					PCR[
						Sample->"my container",
						PrimerPair->{{Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]}}
					],
					Incubate[
						Sample->"my container",
						Time->10 Minute
					]
				}
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional,"Can use ExperimentSamplePreparation to specified:"},
			ExperimentSamplePreparation[
				PCR[
					Sample->Object[Sample,"PCR primitive test sample 1"<>$SessionUUID],
					PrimerPair->{{Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]}}
				]
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional,"Can use Experiment for building the protocol from a set of primitives:"},
			Experiment[
				{
					LabelContainer[
						Label->"my container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Destination->"my container",
						Amount->10 Milliliter
					],
					PCR[
						Sample->"my container",
						PrimerPair->{{Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]}}
					],
					Incubate[
						Sample->"my container",
						Time->10 Minute
					]
				}
			],
			ObjectReferenceP[Object[Protocol, ManualSamplePreparation]]
		]
	},
	
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	
	
	SymbolSetUp:>(
		Module[{allObjects,existingObjects},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID],
				
				Model[Molecule,Oligomer,"PCR primitive test DNA molecule"<>$SessionUUID],
				
				Model[Sample,"PCR primitive test DNA sample"<>$SessionUUID],
				
				Object[Sample,"PCR primitive test sample 1"<>$SessionUUID],
				Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]
			};
			
			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			
			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
		
		
		Block[{$AllowSystemsProtocols=True},
			Module[{containerSampleObjects},
				
				(*Gather all the created objects and models*)
				containerSampleObjects={
					Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID],
					
					Model[Molecule,Oligomer,"PCR primitive test DNA molecule"<>$SessionUUID],
					
					Model[Sample,"PCR primitive test DNA sample"<>$SessionUUID],
					
					Object[Sample,"PCR primitive test sample 1"<>$SessionUUID],
					Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],
					Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]
				};
				
				(*Make an empty container object*)
				Upload[
					<|
						Type->Object[Container,Plate],
						Site->Link[$Site],
						Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
						Name->"PCR primitive test 96-well PCR plate 1"<>$SessionUUID
					|>
				];
				
				(*Make a test DNA identity model*)
				UploadOligomer["PCR primitive test DNA molecule"<>$SessionUUID,Molecule->Strand[DNA["AATTCCGG"]],PolymerType->DNA];
				Upload[<|Object->Model[Molecule,Oligomer,"PCR primitive test DNA molecule"<>$SessionUUID],Transfer[Notebook]->Null,DeveloperObject->True|>];
				
				(*Make a test sample model*)
				UploadSampleModel[
					"PCR primitive test DNA sample"<>$SessionUUID,
					Composition->{{10 Micromolar,Model[Molecule,Oligomer,"PCR primitive test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					IncompatibleMaterials->{None},
					Expires->True,
					ShelfLife->2 Year,
					UnsealedShelfLife->90 Day,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					MSDSRequired->False,
					BiosafetyLevel->"BSL-1",
					State->Liquid
				];
				
				(*Make some test sample objects in the test container objects*)
				UploadSample[
					ConstantArray[Model[Sample,"PCR primitive test DNA sample"<>$SessionUUID],3],
					{
						{"A1",Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID]},
						{"A3",Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID]}
					},
					Name->
						{
							"PCR primitive test sample 1"<>$SessionUUID,
							"PCR primitive test primer sample 1 forward"<>$SessionUUID,
							"PCR primitive test primer sample 1 reverse"<>$SessionUUID
						},
					InitialAmount->ConstantArray[0.2 Milliliter,3]
				];
				
				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@containerSampleObjects]
			]
		];
	),
	
	
	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Plate,"PCR primitive test 96-well PCR plate 1"<>$SessionUUID],
				
				Model[Molecule,Oligomer,"PCR primitive test DNA molecule"<>$SessionUUID],
				
				Model[Sample,"PCR primitive test DNA sample"<>$SessionUUID],
				
				Object[Sample,"PCR primitive test sample 1"<>$SessionUUID],
				Object[Sample,"PCR primitive test primer sample 1 forward"<>$SessionUUID],
				Object[Sample,"PCR primitive test primer sample 1 reverse"<>$SessionUUID]
			};
			
			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			
			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];
