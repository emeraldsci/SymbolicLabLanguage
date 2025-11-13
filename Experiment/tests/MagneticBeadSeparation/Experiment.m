(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMagneticBeadSeparation: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentMagneticBeadSeparation*)

DefineTests[ExperimentMagneticBeadSeparation,
	{
		(*===Basic examples===*)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],
		Example[{Basic,"Accepts multiple sample objects:"},
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],
		Example[{Basic,"Accepts nested sample objects:"},
			ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			ExperimentMagneticBeadSeparation[
				Object[Container,Vessel,"ExperimentMagneticBeadSeparation test 2mL tube 1" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],
		Example[{Basic,"Accepts different nesting patterns:"},
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],
		Example[{Basic,"Accepts nesting patterns combining samples and containers:"},
			ExperimentMagneticBeadSeparation[
				{
					Object[Container,Vessel,"ExperimentMagneticBeadSeparation test 2mL tube 1" <> $SessionUUID],
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]]
		],

		(*===Error messages tests===*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMagneticBeadSeparation[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMagneticBeadSeparation[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMagneticBeadSeparation[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMagneticBeadSeparation[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "2mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{100 VolumePercent, Model[Molecule, "Water"]}},
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 1 Milliliter,
					State -> Liquid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMagneticBeadSeparation[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "2mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					{{100 VolumePercent, Model[Molecule, "Water"]}},
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 1 Milliliter,
					State -> Liquid
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMagneticBeadSeparation[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Messages,"DiscardedSamples","The sample cannot have a Status of Discarded:"},
			ExperimentMagneticBeadSeparation[
				Object[Container,Vessel,"ExperimentMagneticBeadSeparation"<>" test discarded 2mL tube" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"SolidSamplesNotAllowed","The sample cannot have a State of Solid:"},
			ExperimentMagneticBeadSeparation[
				Object[Container,Vessel,"ExperimentMagneticBeadSeparation"<>" test solid 2mL tube" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::SolidSamplesUnsupported,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DuplicateName","The specified Name cannot already exist for another MagneticBeadSeparation protocol:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Name->"ExperimentMagneticBeadSeparation template test protocol" <> $SessionUUID
			],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingMagneticBeadSeparationMethodRequirements","If Preparation is Robotic, LoadingCollectionContainer, WashCollectionContainer, and ElutionCollectionContainer must be compatible with the liquid handler:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionContainer->Model[Container,Vessel,"15mL Tube"],
				Preparation->Robotic
			],
			$Failed,
			Messages:>{
				Error::ConflictingMagneticBeadSeparationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleMagnetizationRack","If Preparation is Robotic, MagnetizationRack must be a Model[Item,Magnetization]:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagnetizationRack->Model[Container,Rack,"DynaMag Magnet 96-well Skirted Plate Rack"],
				Preparation->Robotic
			],
			$Failed,
			Messages:>{
				Error::ConflictingMagneticBeadSeparationMethodRequirements,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixTypeIncompatibleWithPreparation","If Preparation is Robotic, PreWashMixType, EquilibrationMixType, LoadingMixType, WashMixType, SecondaryWashMixType, TertiaryWashMixType, QuaternaryWashMixType, QuinaryWashMixType, SenaryWashMixType, SeptenaryWashMixType, and ElutionMixType must be either Shake or Pipette:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixType->Vortex,
				Preparation->Robotic
			],
			$Failed,
			Messages:>{
				Error::ConflictingMagneticBeadSeparationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeparationModeMismatch","If SeparationMode is not Affinity, AnalyteAffinityLabel and MagneticBeadAffinityLabel must not be specified:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SeparationMode->IonExchange,
				AnalyteAffinityLabel->Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::SeparationModeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MultipleAnalytes","If there are multiple analytes in a sample, the first analyte will be used:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 3" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages:>{
				Warning::MultipleAnalytes
			}
		],
		Example[{Messages,"GeneralResolvedMagneticBeads","The option MagneticBeads is resolved to a generic model due to the lack of magnetic bead recommendation based on the Target and SeparationMode:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube no analyte sample" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Messages,"MultipleTargets","If there are multiple targets in an analyte, the first target will be used:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 2" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages:>{
				Warning::MultipleTargets
			}
		],
		Example[{Messages,"MultipleTargetTypes","If there are multiple molecule types in Analytes of the sample, the first member of Analytes will be used as Target:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube multiple target type sample" <> $SessionUUID],
				SeparationMode->ReversePhase
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages:>{
				Warning::MultipleTargetTypes
			}
		],
		Example[{Messages,"MaxTimeParallelProcessing","If within a single batch, different processing time/temperature/mix rate options are set, the max will be chosen for the entire batch:"},
			ExperimentMagneticBeadSeparation[
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				PreWashAirDryTime -> {3 Minute, 5 Minute}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::MaxTimeParallelProcessing}
		],
		Example[{Messages,"InvalidProcessingOrder","Parallel and Serial ProcessingOrder can only be specified for a flat input sample list:"},
			ExperimentMagneticBeadSeparation[
				{{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID], Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]}},
				ProcessingOrder->Parallel
			],
			$Failed,
			Messages :> {Error::InvalidProcessingOrder,Error::InvalidOption}
		],
		Example[{Messages,"InvalidDestinationWells","When specifying DestinationWell options, that well must exist in the corresponding collection container:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionContainer->{"B1",Model[Container, Vessel, "id:3em6Zv9NjjN8"]} (* "2mL Tube" *)
			],
			$Failed,
			Messages :> {Error::InvalidDestinationWells,Error::InvalidOption}
		],
		Example[{Messages,"NoAvailablePositionsInContainer","If a specified collection container has no more available wells the DestinationWell will default to A1:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionContainer->Object[Container,Vessel,"ExperimentMagneticBeadSeparation"<>" test filled 2mL tube" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::NoAvailablePositionsInContainer}
		],
		Example[{Messages,"InvalidBufferVolume","The buffer volume for any stage cannot be greater than the MaxVolume of the AssayContainer:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashBufferVolume->3 Milliliter,
				Preparation->Robotic
			],
			$Failed,
			Messages :> {Error::InvalidBufferVolume,Error::InvalidOption}
		],
		
		(*==PreWash==*)
		Example[{Messages,"PreWashMismatch","The PreWash options cannot be in conflict with PreWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWash->True,
				PreWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::PreWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreWashMixMismatch","The PreWashMix options cannot be in conflict with PreWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				PreWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::PreWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreWashAirDryMismatch","PreWashAirDryTime cannot be in conflict with PreWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashAirDry->True,
				PreWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::PreWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreWashMixStowaways","The PreWashMixType chosen could potentially mix samples not intended:"},
		    ExperimentMagneticBeadSeparation[
					{
						{
							Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
							Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
						}
					},
					PreWashMixType-> {{Shake, Pipette}}
				],
				ObjectP[Object[Protocol,MagneticBeadSeparation]],
		    Messages :> {
					Warning::PreWashMixStowaways
				}
		],
		Example[{Messages,"PreWashAirDryStowaways","Within a batch, if a sample is air dried during the PreWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				PreWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::PreWashAirDryStowaways}
		],
		Example[{Messages,"InvalidPreWashMixTipType","The PreWashMixTipType is WideBore if the PreWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				PreWashMixVolume->900 Microliter,
				PreWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidPreWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreWashMixNoTip","There is no tips found by the function TransferDevices for the PreWashMixVolume given the PreWashMixTipType and PreWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				PreWashMixTipType->WideBore,
				PreWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::PreWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreWashMixNoInstrument","There is no instrument found by the function MixDevices given the PreWashMixType, PreWashMixTemperature, and PreWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				PreWashMixType->Vortex,
				PreWashMixTemperature->80 Celsius,
				PreWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::PreWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfPreWashesMismatch","The dimensions of the PreWashCollectionContainer, PreWashDestinationWell, or PreWashCollectionContainerLabel options do not agree with NumberOfPreWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				NumberOfPreWashes->{{2,3}},
				PreWashCollectionContainerLabel->{{{"batch 1 sample 1 prewash collection","batch 2 sample 1 prewash collection"},{"batch 1 sample 1 prewash collection","batch 2 sample 1 prewash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfPreWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"PreWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in PreWashAspirationPosition and PreWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				PreWashAspirationPosition -> Top,
				PreWashAspirationPositionOffset ->Null
			],
			$Failed,
			Messages :> {Error::PreWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==Equilibration==*)
		Example[{Messages,"EquilibrationMismatch","The Equilibration options cannot be in conflict with Equilibration:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Equilibration->True,
				EquilibrationBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::EquilibrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EquilibrationMixMismatch","The EquilibrationMix options cannot be in conflict with EquilibrationMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				EquilibrationMixType->Null
			],
			$Failed,
			Messages:>{
				Error::EquilibrationMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EquilibrationAirDryMismatch","EquilibrationAirDryTime cannot be in conflict with EquilibrationAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationAirDry->True,
				EquilibrationAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::EquilibrationAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EquilibrationMixStowaways","The EquilibrationMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				EquilibrationMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::EquilibrationMixStowaways
			}
		],
		Example[{Messages,"EquilibrationAirDryStowaways","Within a batch, if a sample is air dried during the Equilibration stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				EquilibrationAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::EquilibrationAirDryStowaways}
		],
		Example[{Messages,"InvalidEquilibrationMixTipType","The EquilibrationMixTipType is WideBore if the EquilibrationMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				EquilibrationMixVolume->900 Microliter,
				EquilibrationMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidEquilibrationMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EquilibrationMixNoTip","There is no tips found by the function TransferDevices for the EquilibrationMixVolume given the EquilibrationMixTipType and EquilibrationMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				EquilibrationMixTipType->WideBore,
				EquilibrationMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::EquilibrationMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EquilibrationMixNoInstrument","There is no instrument found by the function MixDevices given the EquilibrationMixType, EquilibrationMixTemperature, and EquilibrationMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				EquilibrationMixType->Vortex,
				EquilibrationMixTemperature->80 Celsius,
				EquilibrationMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::EquilibrationMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfEquilibrationsMismatch","The dimensions of the EquilibrationCollectionContainer, or EquilibrationCollectionContainerLabel options do not agree with NumberOfEquilibrations:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				EquilibrationCollectionContainerLabel->{{{"batch 1 sample 1 equilibration collection","batch 2 sample 1 equilibration collection"},{"batch 1 sample 1 equilibration collection","batch 2 sample 1 equilibration collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfEquilibrationsMismatch,Error::InvalidOption}
		],
		Example[{Messages,"EquilibrationAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in EquilibrationAspirationPosition and EquilibrationAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				EquilibrationAspirationPosition -> Null,
				EquilibrationAspirationPositionOffset -> 5 Millimeter
			],
			$Failed,
			Messages :> {Error::EquilibrationAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==Loading==*)

		Example[{Messages,"LoadingMixMismatch","The LoadingMix options cannot be in conflict with LoadingMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				LoadingMixType->Null
			],
			$Failed,
			Messages:>{
				Error::LoadingMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"LoadingAirDryMismatch","LoadingAirDryTime cannot be in conflict with LoadingAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingAirDry->True,
				LoadingAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::LoadingAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"LoadingMixStowaways","The LoadingMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				LoadingMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::LoadingMixStowaways
			}
		],
		Example[{Messages,"LoadingAirDryStowaways","Within a batch, if a sample is air dried during the Loading stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				LoadingAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::LoadingAirDryStowaways}
		],
		Example[{Messages,"InvalidLoadingMixTipType","The LoadingMixTipType is WideBore if the LoadingMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				LoadingMixVolume->900 Microliter,
				LoadingMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidLoadingMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"LoadingMixNoTip","There is no tips found by the function TransferDevices for the LoadingMixVolume given the LoadingMixTipType and LoadingMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				LoadingMixTipType->WideBore,
				LoadingMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::LoadingMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"LoadingMixNoInstrument","There is no instrument found by the function MixDevices given the LoadingMixType, LoadingMixTemperature, and LoadingMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				LoadingMixType->Vortex,
				LoadingMixTemperature->80 Celsius,
				LoadingMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::LoadingMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfLoadingsMismatch","The dimensions of the LoadingCollectionContainer, LoadingDestinationWell, or LoadingCollectionContainerLabel options do not agree with NumberOfLoadings:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				LoadingCollectionContainerLabel->{{{"batch 1 sample 1 loading collection","batch 2 sample 1 loading collection"},{"batch 1 sample 1 loading collection","batch 2 sample 1 loading collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfLoadingsMismatch,Error::InvalidOption}
		],
		Example[{Messages,"LoadingAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in LoadingAspirationPosition and LoadingAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				LoadingAspirationPosition -> Bottom,
				LoadingAspirationPositionOffset -> Null
			],
			$Failed,
			Messages :> {Error::LoadingAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==Wash==*)
		Example[{Messages,"WashMismatch","The Wash options cannot be in conflict with Wash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				WashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::WashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WashMixMismatch","The WashMix options cannot be in conflict with WashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				WashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::WashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WashAirDryMismatch","WashAirDryTime cannot be in conflict with WashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashAirDry->True,
				WashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::WashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WashMixStowaways","The WashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				WashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::WashMixStowaways
			}
		],
		Example[{Messages,"WashAirDryStowaways","Within a batch, if a sample is air dried during the Wash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				WashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::WashAirDryStowaways}
		],
		Example[{Messages,"InvalidWashMixTipType","The WashMixTipType is WideBore if the WashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				WashMixVolume->900 Microliter,
				WashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WashMixNoTip","There is no tips found by the function TransferDevices for the WashMixVolume given the WashMixTipType and WashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				WashMixTipType->WideBore,
				WashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::WashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WashMixNoInstrument","There is no instrument found by the function MixDevices given the WashMixType, WashMixTemperature, and WashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				WashMixType->Vortex,
				WashMixTemperature->80 Celsius,
				WashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::WashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfWashesMismatch","The dimensions of the WashCollectionContainer, WashDestinationWell, or WashCollectionContainerLabel options do not agree with NumberOfWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				NumberOfWashes->{{2,3}},
				WashCollectionContainerLabel->{{{"batch 1 sample 1 wash collection","batch 2 sample 1 wash collection"},{"batch 1 sample 1 wash collection","batch 2 sample 1 wash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"WashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in WashAspirationPosition and WashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				WashAspirationPosition -> Bottom,
				WashAspirationPositionOffset -> Null
			],
			$Failed,
			Messages :> {Error::WashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],


		(*==SecondaryWash==*)
		Example[{Messages,"SecondaryWashMismatch","The SecondaryWash options cannot be in conflict with SecondaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				SecondaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::SecondaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashMixMismatch","The SecondaryWashMix options cannot be in conflict with SecondaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				SecondaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::SecondaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashAirDryMismatch","SecondaryWashAirDryTime cannot be in conflict with SecondaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashAirDry->True,
				SecondaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::SecondaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashMixStowaways","The SecondaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::SecondaryWashMixStowaways
			}
		],
		Example[{Messages,"SecondaryWashAirDryStowaways","Within a batch, if a sample is air dried during the SecondaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::SecondaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidSecondaryWashMixTipType","The SecondaryWashMixTipType is WideBore if the SecondaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				SecondaryWashMixVolume->900 Microliter,
				SecondaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidSecondaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashMixNoTip","There is no tips found by the function TransferDevices for the SecondaryWashMixVolume given the SecondaryWashMixTipType and SecondaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				SecondaryWashMixTipType->WideBore,
				SecondaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::SecondaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the SecondaryWashMixType, SecondaryWashMixTemperature, and SecondaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				SecondaryWashMixType->Vortex,
				SecondaryWashMixTemperature->80 Celsius,
				SecondaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::SecondaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfSecondaryWashesMismatch","The dimensions of the SecondaryWashCollectionContainer, SecondaryWashDestinationWell, or SecondaryWashCollectionContainerLabel options do not agree with NumberOfSecondaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				NumberOfSecondaryWashes->{{2,3}},
				SecondaryWashCollectionContainerLabel->{{{"batch 1 sample 1 secondaryWash collection","batch 2 sample 1 secondaryWash collection"},{"batch 1 sample 1 secondaryWash collection","batch 2 sample 1 secondaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfSecondaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSecondaryWash","SecondaryWash is True either as specified by SecondaryWash or resolved to True because there is other option in SecondaryWash specified, while Wash is False either as specified by Wash or because of the absence of other specified Wash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SecondaryWash->True,
				Wash->False
			],
			$Failed,
			Messages:>{
				Error::InvalidSecondaryWash,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in SecondaryWashAspirationPosition and SecondaryWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWashAspirationPosition -> Null,
				SecondaryWashAspirationPositionOffset -> 2 Millimeter
			],
			$Failed,
			Messages :> {Error::SecondaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==TertiaryWash==*)
		Example[{Messages,"TertiaryWashMismatch","The TertiaryWash options cannot be in conflict with TertiaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWash->True,
				TertiaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::TertiaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashMixMismatch","The TertiaryWashMix options cannot be in conflict with TertiaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWashMix->True,
				TertiaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::TertiaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashAirDryMismatch","TertiaryWashAirDryTime cannot be in conflict with TertiaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWashAirDry->True,
				TertiaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::TertiaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashMixStowaways","The TertiaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWash->True,
				TertiaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::TertiaryWashMixStowaways
			}
		],
		Example[{Messages,"TertiaryWashAirDryStowaways","Within a batch, if a sample is air dried during the TertiaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWash->True,
				TertiaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::TertiaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidTertiaryWashMixTipType","The TertiaryWashMixTipType is WideBore if the TertiaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWashMix->True,
				TertiaryWashMixVolume->900 Microliter,
				TertiaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidTertiaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashMixNoTip","There is no tips found by the function TransferDevices for the TertiaryWashMixVolume given the TertiaryWashMixTipType and TertiaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWashMix->True,
				TertiaryWashMixTipType->WideBore,
				TertiaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::TertiaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the TertiaryWashMixType, TertiaryWashMixTemperature, and TertiaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWashMix->True,
				TertiaryWashMixType->Vortex,
				TertiaryWashMixTemperature->80 Celsius,
				TertiaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::TertiaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfTertiaryWashesMismatch","The dimensions of the TertiaryWashCollectionContainer, TertiaryWashDestinationWell, or TertiaryWashCollectionContainerLabel options do not agree with NumberOfTertiaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWash->True,
				NumberOfTertiaryWashes->{{2,3}},
				TertiaryWashCollectionContainerLabel->{{{"batch 1 sample 1 tertiaryWash collection","batch 2 sample 1 tertiaryWash collection"},{"batch 1 sample 1 tertiaryWash collection","batch 2 sample 1 tertiaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfTertiaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTertiaryWash","TertiaryWash is True either as specified by TertiaryWash or resolved to True because there is other option in TertiaryWash specified, while SecondaryWash is False either as specified by SecondaryWash or because of the absence of other specified SecondaryWash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				TertiaryWash->True
			],
			$Failed,
			Messages:>{
				Error::InvalidTertiaryWash,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TertiaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in TertiaryWashAspirationPosition and TertiaryWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,SecondaryWash->True,
				TertiaryWashAspirationPosition -> Bottom,
				TertiaryWashAspirationPositionOffset -> Null
			],
			$Failed,
			Messages :> {Error::TertiaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==QuaternaryWash==*)
		Example[{Messages,"QuaternaryWashMismatch","The QuaternaryWash options cannot be in conflict with QuaternaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				TertiaryWash->True,
				QuaternaryWash->True,
				QuaternaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::QuaternaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashMixMismatch","The QuaternaryWashMix options cannot be in conflict with QuaternaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				QuaternaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::QuaternaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashAirDryMismatch","QuaternaryWashAirDryTime cannot be in conflict with QuaternaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAirDry->True,
				QuaternaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::QuaternaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashMixStowaways","The QuaternaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::QuaternaryWashMixStowaways
			}
		],
		Example[{Messages,"QuaternaryWashAirDryStowaways","Within a batch, if a sample is air dried during the QuaternaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::QuaternaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidQuaternaryWashMixTipType","The QuaternaryWashMixTipType is WideBore if the QuaternaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				QuaternaryWashMixVolume->900 Microliter,
				QuaternaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidQuaternaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashMixNoTip","There is no tips found by the function TransferDevices for the QuaternaryWashMixVolume given the QuaternaryWashMixTipType and QuaternaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				QuaternaryWashMixTipType->WideBore,
				QuaternaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::QuaternaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the QuaternaryWashMixType, QuaternaryWashMixTemperature, and QuaternaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				QuaternaryWashMixType->Vortex,
				QuaternaryWashMixTemperature->80 Celsius,
				QuaternaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::QuaternaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfQuaternaryWashesMismatch","The dimensions of the QuaternaryWashCollectionContainer, QuaternaryWashDestinationWell, or QuaternaryWashCollectionContainerLabel options do not agree with NumberOfQuaternaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,
				NumberOfQuaternaryWashes->{{2,3}},
				QuaternaryWashCollectionContainerLabel->{{{"batch 1 sample 1 quaternaryWash collection","batch 2 sample 1 quaternaryWash collection"},{"batch 1 sample 1 quaternaryWash collection","batch 2 sample 1 quaternaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfQuaternaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidQuaternaryWash","QuaternaryWash is True either as specified by QuaternaryWash or resolved to True because there is other option in QuaternaryWash specified, while TertiaryWash is False either as specified by TertiaryWash or because of the absence of other specified TertiaryWash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				QuaternaryWash->True
			],
			$Failed,
			Messages:>{
				Error::InvalidQuaternaryWash,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuaternaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in QuaternaryWashAspirationPosition and QuaternaryWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAspirationPosition -> Null,
				QuaternaryWashAspirationPositionOffset -> 3 Millimeter
			],
			$Failed,
			Messages :> {Error::QuaternaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==QuinaryWash==*)
		Example[{Messages,"QuinaryWashMismatch","The QuinaryWash options cannot be in conflict with QuinaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWash->True,
				QuinaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::QuinaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashMixMismatch","The QuinaryWashMix options cannot be in conflict with QuinaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				QuinaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::QuinaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashAirDryMismatch","QuinaryWashAirDryTime cannot be in conflict with QuinaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAirDry->True,
				QuinaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::QuinaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashMixStowaways","The QuinaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::QuinaryWashMixStowaways
			}
		],
		Example[{Messages,"QuinaryWashAirDryStowaways","Within a batch, if a sample is air dried during the QuinaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::QuinaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidQuinaryWashMixTipType","The QuinaryWashMixTipType is WideBore if the QuinaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				QuinaryWashMixVolume->900 Microliter,
				QuinaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidQuinaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashMixNoTip","There is no tips found by the function TransferDevices for the QuinaryWashMixVolume given the QuinaryWashMixTipType and QuinaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				QuinaryWashMixTipType->WideBore,
				QuinaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::QuinaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the QuinaryWashMixType, QuinaryWashMixTemperature, and QuinaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				QuinaryWashMixType->Vortex,
				QuinaryWashMixTemperature->80 Celsius,
				QuinaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::QuinaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfQuinaryWashesMismatch","The dimensions of the QuinaryWashCollectionContainer, QuinaryWashDestinationWell, or QuinaryWashCollectionContainerLabel options do not agree with NumberOfQuinaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				NumberOfQuinaryWashes->{{2,3}},
				QuinaryWashCollectionContainerLabel->{{{"batch 1 sample 1 quinaryWash collection","batch 2 sample 1 quinaryWash collection"},{"batch 1 sample 1 quinaryWash collection","batch 2 sample 1 quinaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfQuinaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidQuinaryWash","QuinaryWash is True either as specified by QuinaryWash or resolved to True because there is other option in QuinaryWash specified, while QuaternaryWash is False either as specified by QuaternaryWash or because of the absence of other specified QuaternaryWash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				QuinaryWash->True
			],
			$Failed,
			Messages:>{
				Error::InvalidQuinaryWash,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuinaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in QuinaryWashAspirationPosition and QuinaryWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAspirationPosition -> Null,
				QuinaryWashAspirationPositionOffset -> 3 Millimeter
			],
			$Failed,
			Messages :> {Error::QuinaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==SenaryWash==*)
		Example[{Messages,"SenaryWashMismatch","The SenaryWash options cannot be in conflict with SenaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWash->True,
				SenaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::SenaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashMixMismatch","The SenaryWashMix options cannot be in conflict with SenaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				SenaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::SenaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashAirDryMismatch","SenaryWashAirDryTime cannot be in conflict with SenaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashAirDry->True,
				SenaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::SenaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashMixStowaways","The SenaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::SenaryWashMixStowaways
			}
		],
		Example[{Messages,"SenaryWashAirDryStowaways","Within a batch, if a sample is air dried during the SenaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::SenaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidSenaryWashMixTipType","The SenaryWashMixTipType is WideBore if the SenaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				SenaryWashMixVolume->900 Microliter,
				SenaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidSenaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashMixNoTip","There is no tips found by the function TransferDevices for the SenaryWashMixVolume given the SenaryWashMixTipType and SenaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				SenaryWashMixTipType->WideBore,
				SenaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::SenaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the SenaryWashMixType, SenaryWashMixTemperature, and SenaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				SenaryWashMixType->Vortex,
				SenaryWashMixTemperature->80 Celsius,
				SenaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::SenaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfSenaryWashesMismatch","The dimensions of the SenaryWashCollectionContainer, SenaryWashDestinationWell, or SenaryWashCollectionContainerLabel options do not agree with NumberOfSenaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				NumberOfSenaryWashes->{{2,3}},
				SenaryWashCollectionContainerLabel->{{{"batch 1 sample 1 senaryWash collection","batch 2 sample 1 senaryWash collection"},{"batch 1 sample 1 senaryWash collection","batch 2 sample 1 senaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfSenaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSenaryWash","SenaryWash is True either as specified by SenaryWash or resolved to True because there is other option in SenaryWash specified, while QuinaryWash is False either as specified by QuinaryWash or because of the absence of other specified QuinaryWash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SenaryWash->True
			],
			$Failed,
			Messages:>{
				Error::InvalidSenaryWash,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SenaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in SenaryWashAspirationPosition and SenaryWashAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,				SenaryWashAspirationPosition -> Null,
				SenaryWashAspirationPositionOffset -> 3 Millimeter
			],
			$Failed,
			Messages :> {Error::SenaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*==SeptenaryWash==*)
		Example[{Messages,"SeptenaryWashMismatch","The SeptenaryWash options cannot be in conflict with SeptenaryWash:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWash->True,
				SeptenaryWashBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::SeptenaryWashMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeptenaryWashMixMismatch","The SeptenaryWashMix options cannot be in conflict with SeptenaryWashMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				SeptenaryWashMixType->Null
			],
			$Failed,
			Messages:>{
				Error::SeptenaryWashMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeptenaryWashAirDryMismatch","SeptenaryWashAirDryTime cannot be in conflict with SeptenaryWashAirDry:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashAirDry->True,
				SeptenaryWashAirDryTime->Null
			],
			$Failed,
			Messages:>{
				Error::SeptenaryWashAirDryMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeptenaryWashMixStowaways","The SeptenaryWashMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::SeptenaryWashMixStowaways
			}
		],
		Example[{Messages,"SeptenaryWashAirDryStowaways","Within a batch, if a sample is air dried during the SeptenaryWash stage, all samples in that batch will be air dried:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashAirDry-> {{True, False}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {Warning::SeptenaryWashAirDryStowaways}
		],
		Example[{Messages,"InvalidSeptenaryWashMixTipType","The SeptenaryWashMixTipType is WideBore if the SeptenaryWashMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				SeptenaryWashMixVolume->900 Microliter,
				SeptenaryWashMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidSeptenaryWashMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeptenaryWashMixNoTip","There is no tips found by the function TransferDevices for the SeptenaryWashMixVolume given the SeptenaryWashMixTipType and SeptenaryWashMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				SeptenaryWashMixTipType->WideBore,
				SeptenaryWashMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::SeptenaryWashMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SeptenaryWashMixNoInstrument","There is no instrument found by the function MixDevices given the SeptenaryWashMixType, SeptenaryWashMixTemperature, and SeptenaryWashMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				SeptenaryWashMixType->Vortex,
				SeptenaryWashMixTemperature->80 Celsius,
				SeptenaryWashMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::SeptenaryWashMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfSeptenaryWashesMismatch","The dimensions of the SeptenaryWashCollectionContainer, SeptenaryWashDestinationWell, or SeptenaryWashCollectionContainerLabel options do not agree with NumberOfSeptenaryWashes:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True, SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				NumberOfSeptenaryWashes->{{2,3}},
				SeptenaryWashCollectionContainerLabel->{{{"batch 1 sample 1 septenaryWash collection","batch 2 sample 1 septenaryWash collection"},{"batch 1 sample 1 septenaryWash collection","batch 2 sample 1 septenaryWash collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfSeptenaryWashesMismatch,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSeptenaryWash","SeptenaryWash is True either as specified by SeptenaryWash or resolved to True because there is other option in SeptenaryWash specified, while SenaryWash is False either as specified by SenaryWash or because of the absence of other specified SenaryWash options:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SeptenaryWash->True
			],
			$Failed,
			Messages:>{
				Error::InvalidSeptenaryWash,
				Error::InvalidOption
			}
		],	
		Example[{Messages,"SeptenaryWashAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in SeptenaryWashAspirationPosition and SeptenaryWashAspirationPositionOffset options:"},
		ExperimentMagneticBeadSeparation[
			{
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				}
			},
			Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,	SenaryWash->True,			SeptenaryWashAspirationPosition -> Null,
			SeptenaryWashAspirationPositionOffset -> 3 Millimeter
		],
		$Failed,
		Messages :> {Error::SeptenaryWashAspirationPipettingOptionsMismatch,Error::InvalidOption}
	],
		(*==Elution==*)
		Example[{Messages,"ElutionMismatch","The Elution options cannot be in conflict with Elution:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Elution->True,
				ElutionBuffer->Null
			],
			$Failed,
			Messages:>{
				Error::ElutionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElutionMixMismatch","The ElutionMix options cannot be in conflict with ElutionMix:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMix->True,
				ElutionMixType->Null
			],
			$Failed,
			Messages:>{
				Error::ElutionMixMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElutionMixStowaways","The ElutionMixType chosen could potentially mix samples not intended:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 96-well plate sample 4" <> $SessionUUID]
					}
				},
				ElutionMixType-> {{Shake, Pipette}}
			],
			ObjectP[Object[Protocol,MagneticBeadSeparation]],
			Messages :> {
				Warning::ElutionMixStowaways
			}
		],
		Example[{Messages,"InvalidElutionMixTipType","The ElutionMixTipType is WideBore if the ElutionMixVolume is less or equal to 970 Microliter:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMix->True,
				ElutionMixVolume->900 Microliter,
				ElutionMixTipType->Normal
			],
			$Failed,
			Messages:>{
				Error::InvalidElutionMixTipType,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElutionMixNoTip","There is no tips found by the function TransferDevices for the ElutionMixVolume given the ElutionMixTipType and ElutionMixTipMaterial:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMix->True,
				ElutionMixTipType->WideBore,
				ElutionMixTipMaterial->Glass
			],
			$Failed,
			Messages:>{
				Error::ElutionMixNoTip,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElutionMixNoInstrument","There is no instrument found by the function MixDevices given the ElutionMixType, ElutionMixTemperature, and ElutionMixRate:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMix->True,
				ElutionMixType->Vortex,
				ElutionMixTemperature->80 Celsius,
				ElutionMixRate->3000 RPM
			],
			$Failed,
			Messages:>{
				Error::ElutionMixNoInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NumberOfElutionsMismatch","The dimensions of the ElutionCollectionContainer, ElutionDestinationWell, or ElutionCollectionContainerLabel options do not agree with NumberOfElutions:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				NumberOfElutions->{{2,3}},
				ElutionCollectionContainerLabel->{{{"batch 1 sample 1 elution collection","batch 2 sample 1 elution collection"},{"batch 1 sample 1 elution collection","batch 2 sample 1 elution collection"}}}
			],
			$Failed,
			Messages :> {Error::NumberOfElutionsMismatch,Error::InvalidOption}
		],

		Example[{Messages,"CollectionContainerConflictingStorageCondition","A collection container has multiple storage conditions:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				PreWashCollectionContainer->Object[Container,Plate,"ExperimentMagneticBeadSeparation"<>" test 96-well plate" <> $SessionUUID],
				PreWashCollectionStorageCondition->{{AmbientStorage,Refrigerator}}
			],
			$Failed,
			Messages :> {Error::CollectionContainerConflictingStorageCondition,Error::InvalidOption}
		],
		Example[{Messages,"ElutionAspirationPipettingOptionsMismatch","An error is thrown if there is mismatch in ElutionAspirationPosition and ElutionAspirationPositionOffset options:"},
			ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,	SenaryWash->True,			ElutionAspirationPosition -> Null,
				ElutionAspirationPositionOffset -> 3 Millimeter
			],
			$Failed,
			Messages :> {Error::ElutionAspirationPipettingOptionsMismatch,Error::InvalidOption}
		],

		(*===Options tests===*)


		(*---Shared options---*)
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol=ExperimentMagneticBeadSeparation[
				"ExperimentMagneticBeadSeparation PreparatoryUnitOperations test vessel 1",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"ExperimentMagneticBeadSeparation PreparatoryUnitOperations test vessel 1",Container->Model[Container,Vessel,"2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"ExperimentMagneticBeadSeparation PreparatoryUnitOperations test vessel 1",Amount->100 Microliter]
				}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol},
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMagneticBeadSeparation[
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
			Variables :> {options, prepUOs},
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared, even if Preparation -> Robotic:"},
			output = ExperimentMagneticBeadSeparation[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Robotic,
				Output -> Result
			];
			Quiet@Download[
				output[OutputUnitOperations][[1]],
				{
					RoboticUnitOperations[[2]][SampleLink],
					RoboticUnitOperations[[2]][Label],
					RoboticUnitOperations[[1]][ContainerLink],
					RoboticUnitOperations[[1]][Label]
				}
			],
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],__},(*LabelSample primitive might combined labeling input samples along with other reagents e.g. buffer or magnetic beads*)
				{(_String)..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{_String, _String}
			},
			Variables :> {output},
			Messages:>{
				Warning::GeneralResolvedMagneticBeads
			}
		],
		Example[{Options,Name,"Name of the output protocol object can be specified:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Name->"ExperimentMagneticBeadSeparation name test protocol"<> $SessionUUID
			],
			Object[Protocol,MagneticBeadSeparation,"ExperimentMagneticBeadSeparation name test protocol"<> $SessionUUID],
			SetUp:> {
				Module[{myTestProt,objects},
					myTestProt = Object[Protocol,MagneticBeadSeparation,"ExperimentMagneticBeadSeparation name test protocol" <> $SessionUUID];
					objects = If[DatabaseMemberQ[myTestProt],
						Download[myTestProt,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}],
						{}
					];
					(*Erase the protocol object with the same name if it exists*)
					Quiet[EraseObject[Cases[Flatten[objects],ObjectP[]],Force->True,Verbose->False]]
				]
			}
		],
		Example[{Options,Template,"Template can be specified to inherit specified options from the parent protocol:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Template->Object[Protocol,MagneticBeadSeparation,"ExperimentMagneticBeadSeparation template test protocol" <> $SessionUUID,UnresolvedOptions],
				Output->Options
			];
			Lookup[options,PreWashMix],
			False,
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],


		(*---Experiment options---*)
		Example[{Options,SelectionStrategy,"SelectionStrategy can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SelectionStrategy->Positive,
				Output->Options
			];
			Lookup[options,SelectionStrategy],
			Positive,
			Variables:>{options}
		],
		Example[{Options,SeparationMode,"SeparationMode can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SeparationMode->Affinity,
				Output->Options
			];
			Lookup[options,SeparationMode],
			Affinity,
			Variables:>{options}
		],
		Example[{Options,SeparationMode,"SeparationMode can be specified as non-Affinity:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SeparationMode->IonExchange,
				Output->Options
			];
			Lookup[options,SeparationMode],
			IonExchange,
			Variables:>{options}
		],
		Example[{Options,Preparation,"Preparation can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Preparation->Manual,
				Output->Options
			];
			Lookup[options,Preparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,ProcessingOrder,"ProcessingOrder can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ProcessingOrder->Parallel,
				Output->Options
			];
			Lookup[options,ProcessingOrder],
			Parallel,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"NumberOfReplicates can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfReplicates->2,
				Volume->300 Microliter,
				Output->Options
			];
			Lookup[options,NumberOfReplicates],
			2,
			Variables:>{options}
		],
		Example[{Options,Volume,"Volume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Volume->22 Microliter,
				Output->Options
			];
			Lookup[options,Volume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,Volume,"Volume can be specified as All, and buffer volumes are reasonably set accordingly:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Volume -> All,
				PreWash->True,
				Output->Options
			];
			Lookup[options, {Volume, PreWashBufferVolume}],
			{All, EqualP[1 Milliliter]},
			Variables:>{options}
		],
		Example[{Options,Volume,"Volume can be specified as All for robotic prep:"},
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Volume -> All,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Options,AnalyteAffinityLabel,"AnalyteAffinityLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				AnalyteAffinityLabel->Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,AnalyteAffinityLabel],
				ObjectP[Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,MagneticBeadAffinityLabel,"MagneticBeadAffinityLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeadAffinityLabel->Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test target 1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,MagneticBeadAffinityLabel],
			ObjectP[Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test target 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,Target,"Target can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Target->Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,Target],
			ObjectP[Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,MagneticBeads,"MagneticBeads can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeads->Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,MagneticBeads],
			ObjectP[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,MagneticBeadVolume,"MagneticBeadVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeadVolume->2 Microliter,
				Output->Options
			];
			Lookup[options,MagneticBeadVolume],
			2 Microliter,
			Variables:>{options}
		],
		Example[{Options,MagneticBeadCollectionStorageCondition,"MagneticBeadCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeadCollectionStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,MagneticBeadCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,MagnetizationRack,"MagnetizationRack can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagnetizationRack->Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"],(*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"*)
				Output->Options
			];
			Lookup[options,MagnetizationRack],
			ObjectP[Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"](*Model[Item,MagnetizationRack,"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"*)],
			Variables:>{options}
		],
		(*==PreWash==*)
		Example[{Options,PreWash,"PreWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWash->True,
				Output->Options
			];
			Lookup[options,PreWash],
			True,
			Variables:>{options}
		],
		Example[{Options,PreWashBuffer,"PreWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,PreWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,PreWashBufferVolume,"PreWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,PreWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,PreWashMagnetizationTime,"PreWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,PreWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,PreWashAspirationVolume,"PreWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,PreWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,PreWashMix,"PreWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				Output->Options
			];
			Lookup[options,PreWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,PreWashMixType,"PreWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixType->Shake,
				Output->Options
			];
			Lookup[options,PreWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,PreWashMixTime,"PreWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,PreWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,PreWashMixRate,"PreWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,PreWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfPreWashMixes, "NumberOfPreWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfPreWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfPreWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,PreWashMixVolume, "PreWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixVolume->10 Microliter,
				PreWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,PreWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,PreWashMixTemperature,"PreWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,PreWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,PreWashMixTipType, "PreWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,PreWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,PreWashMixTipMaterial, "PreWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,PreWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,PreWashCollectionContainer,"PreWashCollectionContainer can be specified. If only one container with specified well is given for multiple samples, the collected prewash sample will be pooled:"},
			options=ExperimentMagneticBeadSeparation[{
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <>$SessionUUID],
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
			},
				PreWashCollectionContainer -> {"A1", Model[Container, Vessel, "2mL Tube"]},
				Output->Options
			];
			Lookup[options,PreWashCollectionContainer],
			{"A1", ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,PreWashCollectionContainer,"PreWashCollectionContainer can be specified. If the given PreWashCollectionContainer is nested index-matching with the samples while NumberOfPrewashes > 1, collections from multiple prewash rounds will be pooled for each sample:"},
			options=ExperimentMagneticBeadSeparation[{
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <>$SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
			},
				NumberOfPreWashes -> 2,
				PreWashCollectionContainer -> {
					{{"A1", Model[Container, Vessel, "2mL Tube"]}, {"A1", Model[Container, Vessel, "2mL Tube"]}},
					{{"A1", Model[Container, Vessel, "2mL Tube"]}}
				},
				Output->Options
			];
			Lookup[options,PreWashCollectionContainer],
			{{{"A1", ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {"A1", ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
				{{"A1", ObjectP[Model[Container, Vessel, "2mL Tube"]]}}},
			Variables:>{options}
		],
		Example[{Options,PreWashCollectionContainerLabel,"PreWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				PreWashCollectionContainerLabel-> {"my test PreWash container"},
				Output->Options
			];
			Lookup[options,PreWashCollectionContainerLabel],
			{"my test PreWash container"},
			Variables:>{options}
		],
		Example[{Options,PreWashCollectionStorageCondition,"PreWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashCollectionStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,PreWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfPreWashes,"NumberOfPreWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfPreWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfPreWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,PreWashAirDry,"PreWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashAirDry->True,
				Output->Options
			];
			Lookup[options,PreWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,PreWashAirDryTime,"PreWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashAirDry->True,
				PreWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,PreWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{PreWashAspirationPosition, PreWashAspirationPositionOffset},"PreWashAspirationPosition and PreWashAspirationPositionOffset are set to Bottom and 0 Millimeter if PreWash is performed using the default magnet Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"] :"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWash->True, 
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{PreWashAspirationPosition, PreWashAspirationPositionOffset}],
			{Bottom, EqualP[0 Millimeter]},
			Variables:>{options}
		],

		(*==Equilibration==*)

		Example[{Options,Equilibration,"Equilibration can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Equilibration->True,
				Output->Options
			];
			Lookup[options,Equilibration],
			True,
			Variables:>{options}
		],
		Example[{Options,EquilibrationBuffer,"EquilibrationBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,EquilibrationBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,EquilibrationBufferVolume,"EquilibrationBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,EquilibrationBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,EquilibrationMix,"EquilibrationMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				Output->Options
			];
			Lookup[options,EquilibrationMix],
			True,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMixType,"EquilibrationMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixType->Shake,
				Output->Options
			];
			Lookup[options,EquilibrationMixType],
			Shake,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMixTime,"EquilibrationMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,EquilibrationMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,EquilibrationMixRate,"EquilibrationMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,EquilibrationMixRate],
			168 RPM,
			Variables:>{options}
		],

		Example[{Options,NumberOfEquilibrationMixes, "NumberOfEquilibrationMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfEquilibrationMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfEquilibrationMixes],
			15,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMixVolume, "EquilibrationMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixVolume->10 Microliter,
				EquilibrationMixType->Pipette,
				Output->Options
			];
			Lookup[options,EquilibrationMixVolume],
			10 Microliter,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMixTemperature,"EquilibrationMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,EquilibrationMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,EquilibrationMixTipType, "EquilibrationMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,EquilibrationMixTipType],
			WideBore,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMixTipMaterial, "EquilibrationMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,EquilibrationMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],

		Example[{Options,EquilibrationMagnetizationTime,"EquilibrationMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,EquilibrationMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,EquilibrationAspirationVolume,"EquilibrationAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationAspirationVolume->All,
				Output->Options
			];
			Lookup[options,EquilibrationAspirationVolume],
			All,
			Variables:>{options}
		],

		Example[{Options,EquilibrationCollectionContainer,"EquilibrationCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationCollectionContainer->{"A1",Model[Container,Vessel,"2mL Tube"]},
				Output->Options
			];
			Lookup[options,EquilibrationCollectionContainer],
			{{"A1",ObjectP[Model[Container,Vessel,"2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,EquilibrationCollectionContainer,"EquilibrationCollectionContainer can be specified. If only one container with specified well is given for multiple samples, the collected equilibration samples will be pooled:"},
			options=ExperimentMagneticBeadSeparation[
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <>$SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				EquilibrationCollectionContainer->{"A1",{1,Model[Container,Vessel,"2mL Tube"]}},
				Output->Options
			];
			Lookup[options,EquilibrationCollectionContainer],
			{{"A1",{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]}}},
			Variables:>{options}
		],
		Example[{Options,EquilibrationCollectionContainerLabel,"EquilibrationCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				EquilibrationCollectionContainerLabel-> {"my test Equilibration container"},
				Output->Options
			];
			Lookup[options,EquilibrationCollectionContainerLabel],
			{"my test Equilibration container"},
			Variables:>{options}
		],
		Example[{Options,EquilibrationCollectionStorageCondition,"EquilibrationCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationCollectionStorageCondition->Model[StorageCondition, "Freezer"],
				Output->Options
			];
			Lookup[options,EquilibrationCollectionStorageCondition],
			ObjectP[Model[StorageCondition, "Freezer"]],
			Variables:>{options}
		],
		Example[{Options,EquilibrationAirDry,"EquilibrationAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationAirDry->True,
				Output->Options
			];
			Lookup[options,EquilibrationAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,EquilibrationAirDryTime,"EquilibrationAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationAirDry->True,
				EquilibrationAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,EquilibrationAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{EquilibrationAspirationPosition, EquilibrationAspirationPositionOffset},"EquilibrationAspirationPosition and EquilibrationAspirationPositionOffset are set to Bottom and 0 Millimeter if Equilibration is performed using the default magnet Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Equilibration->True,
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{EquilibrationAspirationPosition, EquilibrationAspirationPositionOffset}],
			{Bottom, EqualP[0 Millimeter]},
			Variables:>{options}
		],

		(*==Loading==*)

		Example[{Options,LoadingMix,"LoadingMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				Output->Options
			];
			Lookup[options,LoadingMix],
			True,
			Variables:>{options}
		],

		Example[{Options,LoadingMixType,"LoadingMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixType->Shake,
				Output->Options
			];
			Lookup[options,LoadingMixType],
			Shake,
			Variables:>{options}
		],

		Example[{Options,LoadingMixTime,"LoadingMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,LoadingMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,LoadingMixRate,"LoadingMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,LoadingMixRate],
			168 RPM,
			Variables:>{options}
		],

		Example[{Options,NumberOfLoadingMixes, "NumberOfLoadingMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfLoadingMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfLoadingMixes],
			15,
			Variables:>{options}
		],

		Example[{Options,LoadingMixVolume, "LoadingMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixVolume->10 Microliter,
				LoadingMixType->Pipette,
				Output->Options
			];
			Lookup[options,LoadingMixVolume],
			10 Microliter,
			Variables:>{options}
		],

		Example[{Options,LoadingMixTemperature,"LoadingMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,LoadingMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,LoadingMixTipType, "LoadingMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,LoadingMixTipType],
			WideBore,
			Variables:>{options}
		],

		Example[{Options,LoadingMixTipMaterial, "LoadingMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,LoadingMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],

		Example[{Options,LoadingMagnetizationTime,"LoadingMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,LoadingMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,LoadingAspirationVolume,"LoadingAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingAspirationVolume->All,
				Output->Options
			];
			Lookup[options,LoadingAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,LoadingCollectionContainer,"LoadingCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionContainer-> {"A1",{1,Model[Container, Vessel, "2mL Tube"]}},
				Output->Options
			];
			Lookup[options,LoadingCollectionContainer],
			{{"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}},
			Variables:>{options}
		],
		Example[{Options,LoadingCollectionContainer,"LoadingCollectionContainer can be specified. If only one container with specified well is given for multiple samples, the collected prewash sample will be pooled::"},
			options=ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <>$SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				LoadingCollectionContainer-> {"A1",{1,Model[Container, Vessel, "2mL Tube"]}},
				Output->Options
			];
			Lookup[options,LoadingCollectionContainer], {"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,LoadingCollectionContainerLabel,"LoadingCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				LoadingCollectionContainerLabel-> {"my test loading container"},
				Output->Options
			];
			Lookup[options,LoadingCollectionContainerLabel],
			{"my test loading container"},
			Variables:>{options}
		],

		Example[{Options,LoadingCollectionStorageCondition,"LoadingCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingCollectionStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,LoadingCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,LoadingAirDry,"LoadingAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingAirDry->True,
				Output->Options
			];
			Lookup[options,LoadingAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,LoadingAirDryTime,"LoadingAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingAirDry->True,
				LoadingAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,LoadingAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{LoadingAspirationPosition, LoadingAspirationPositionOffset},"LoadingAspirationPosition and LoadingAspirationPositionOffset can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Preparation -> Robotic,
				LoadingAspirationPosition -> Bottom,
				LoadingAspirationPositionOffset -> 5 Millimeter,
				Output->Options
			];
			Lookup[options,{LoadingAspirationPosition, LoadingAspirationPositionOffset}],
			{Bottom, EqualP[5 Millimeter]},
			Variables:>{options}
		],

		(*==Wash==*)

		Example[{Options,Wash,"Wash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				Output->Options
			];
			Lookup[options,Wash],
			True,
			Variables:>{options}
		],
		Example[{Options,WashBuffer,"WashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,WashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,WashBufferVolume,"WashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,WashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,WashMagnetizationTime,"WashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,WashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,WashAspirationVolume,"WashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,WashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,WashMix,"WashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				Output->Options
			];
			Lookup[options,WashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,WashMixType,"WashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixType->Shake,
				Output->Options
			];
			Lookup[options,WashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,WashMixTime,"WashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,WashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,WashMixRate,"WashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,WashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfWashMixes, "NumberOfWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,WashMixVolume, "WashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixVolume->10 Microliter,
				WashMixType->Pipette,
				Output->Options
			];
			Lookup[options,WashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,WashMixTemperature,"WashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,WashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,WashMixTipType, "WashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,WashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,WashMixTipMaterial, "WashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,WashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,WashCollectionContainer,"WashCollectionContainer can be specified. If given only Model[Container], the collection from different samples will not be pooled:"},
			protocol=ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				WashCollectionContainer->{Model[Container, Plate, "96-well 2mL Deep Well Plate"],Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
			];
			Download[protocol,{WashCollectionContainers,WashDestinationWells}],
			{
				{ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{"A3","A4"}
			},
			Variables:>{protocol}
		],
		Example[{Options,WashCollectionContainerLabel,"WashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				WashCollectionContainerLabel-> {"my test Wash container"},
				Output->Options
			];
			Lookup[options,WashCollectionContainerLabel],
			{"my test Wash container"},
			Variables:>{options}
		],
		Example[{Options,WashCollectionStorageCondition,"WashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashCollectionStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,WashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfWashes,"NumberOfWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,WashAirDry,"WashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashAirDry->True,
				Output->Options
			];
			Lookup[options,WashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,WashAirDryTime,"WashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashAirDry->True,
				WashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,WashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{WashAspirationPosition, WashAspirationPositionOffset},"WashAspirationPosition is set to Bottom if WashAspirationPositionOffset is specified if Wash is performed:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				WashAspirationPositionOffset -> 4 Millimeter,
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{WashAspirationPosition, WashAspirationPositionOffset}],
			{Bottom, EqualP[4 Millimeter]},
			Variables:>{options}
		],


		(*==SecondaryWash==*)

		Example[{Options,SecondaryWash,"SecondaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				Output->Options
			];
			Lookup[options,SecondaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashBuffer,"SecondaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,SecondaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,SecondaryWashBufferVolume,"SecondaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,SecondaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMagnetizationTime,"SecondaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,SecondaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashAspirationVolume,"SecondaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,SecondaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMix,"SecondaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				Output->Options
			];
			Lookup[options,SecondaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixType,"SecondaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,SecondaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixTime,"SecondaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,SecondaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixRate,"SecondaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,SecondaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfSecondaryWashMixes, "NumberOfSecondaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				NumberOfSecondaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfSecondaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixVolume, "SecondaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixVolume->10 Microliter,
				SecondaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,SecondaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixTemperature,"SecondaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,SecondaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixTipType, "SecondaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,SecondaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashMixTipMaterial, "SecondaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,SecondaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashCollectionContainer,"SecondaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID], Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Wash->True,
				SecondaryWashCollectionContainer -> {
					{{"A1", {1, Model[Container, Vessel, "2mL Tube"]}},{"A1", {2, Model[Container, Vessel, "2mL Tube"]}}},
					{{"A1", {1, Model[Container, Vessel, "2mL Tube"]}}}
				},
				Output->Options
			];
			Lookup[options,SecondaryWashCollectionContainer],
			{
				{{"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},{"A1", {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}},
				{{"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}}
			},
			Variables:>{options}
		],
		Example[{Options,SecondaryWashCollectionContainer,"SecondaryWashCollectionContainer can be specified. If only one container with specific well is given, the collection can be pooled for different batches:"},
			options=ExperimentMagneticBeadSeparation[
				{
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID], Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Wash->True,
				SecondaryWashCollectionContainer -> {
					{"A1", {1, Model[Container, Vessel, "2mL Tube"]}}
				},
				Output->Options
			];
			Lookup[options,SecondaryWashCollectionContainer],
			{
				{"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
			},
			Variables:>{options}
		],

		Example[{Options,SecondaryWashCollectionContainerLabel,"SecondaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				SecondaryWashCollectionContainerLabel-> {"my test SecondaryWash container"},
				Output->Options
			];
			Lookup[options,SecondaryWashCollectionContainerLabel],
			{"my test SecondaryWash container"},
			Variables:>{options}
		],
		Example[{Options,SecondaryWashCollectionStorageCondition,"SecondaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				Wash->True,
				SecondaryWashCollectionStorageCondition -> {Model[StorageCondition,"Freezer"],
					Model[StorageCondition, "Freezer"]},
				Output->Options
			];
			Lookup[options,SecondaryWashCollectionStorageCondition],
			{ObjectP[Model[StorageCondition, "Freezer"]],ObjectP[Model[StorageCondition, "Freezer"]]},
			Variables:>{options}
		],
		Example[{Options,NumberOfSecondaryWashes,"NumberOfSecondaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				NumberOfSecondaryWashes->3,
				Output->Options
			];
			Lookup[options,NumberOfSecondaryWashes],
			3,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashAirDry,"SecondaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,SecondaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,SecondaryWashAirDryTime,"SecondaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashAirDry->True,
				SecondaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,SecondaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{SecondaryWashAspirationPosition, SecondaryWashAspirationPositionOffset},"SecondaryWashAspirationPosition and SecondaryWashAspirationPositionOffset are set to Bottom and 0 Millimeter if SecondaryWash is performed using the default magnet Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWash->True,
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{SecondaryWashAspirationPosition, SecondaryWashAspirationPositionOffset}],
			{Bottom, EqualP[0 Millimeter]},
			Variables:>{options}
		],


		(*==TertiaryWash==*)

		Example[{Options,TertiaryWash,"TertiaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWash->True,
				Output->Options
			];
			Lookup[options,TertiaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashBuffer,"TertiaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,TertiaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,TertiaryWashBufferVolume,"TertiaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,TertiaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMagnetizationTime,"TertiaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,TertiaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashAspirationVolume,"TertiaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,TertiaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMix,"TertiaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMix->True,
				Output->Options
			];
			Lookup[options,TertiaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixType,"TertiaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,TertiaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixTime,"TertiaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,TertiaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixRate,"TertiaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,TertiaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfTertiaryWashMixes, "NumberOfTertiaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				NumberOfTertiaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfTertiaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixVolume, "TertiaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixVolume->10 Microliter,
				TertiaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,TertiaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixTemperature,"TertiaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,TertiaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixTipType, "TertiaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,TertiaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashMixTipMaterial, "TertiaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,TertiaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashCollectionContainer,"TertiaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID], Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
					{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Wash->True,SecondaryWash->True,
				TertiaryWashCollectionContainer->{
					{{1, Model[Container, Vessel, "2mL Tube"]},{2, Model[Container, Vessel, "2mL Tube"]}},
					{{1, Model[Container, Vessel, "2mL Tube"]}}
				},
				Output->Options
			];
			Lookup[options,TertiaryWashCollectionContainer],
			{
				{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
				{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
			},
			Variables:>{options}
		],
		Example[{Options,TertiaryWashCollectionContainerLabel,"TertiaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				TertiaryWashCollectionContainerLabel-> {"my test TertiaryWash container"},
				Output->Options
			];
			Lookup[options,TertiaryWashCollectionContainerLabel],
			{"my test TertiaryWash container"},
			Variables:>{options}
		],
		Example[{Options,TertiaryWashCollectionStorageCondition,"TertiaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}},
				Wash->True,SecondaryWash->True,
				TertiaryWashCollectionStorageCondition -> Disposal,
				Output->Options
			];
			Lookup[options,TertiaryWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfTertiaryWashes,"NumberOfTertiaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				NumberOfTertiaryWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfTertiaryWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashAirDry,"TertiaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,TertiaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,TertiaryWashAirDryTime,"TertiaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashAirDry->True,
				TertiaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,TertiaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{TertiaryWashAspirationPosition, TertiaryWashAspirationPositionOffset},"TertiaryWashAspirationPosition and TertiaryWashAspirationPositionOffset are set to Bottom and 0 Millimeter if TertiaryWash is performed using the default magnet Model[Item, MagnetizationRack, \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWash->True,
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{TertiaryWashAspirationPosition, TertiaryWashAspirationPositionOffset}],
			{Bottom, EqualP[0 Millimeter]},
			Variables:>{options}
		],


		(*==QuaternaryWash==*)

		Example[{Options,QuaternaryWash,"QuaternaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWash->True,
				Output->Options
			];
			Lookup[options,QuaternaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashBuffer,"QuaternaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,QuaternaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashBufferVolume,"QuaternaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,QuaternaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMagnetizationTime,"QuaternaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,QuaternaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashAspirationVolume,"QuaternaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,QuaternaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMix,"QuaternaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				Output->Options
			];
			Lookup[options,QuaternaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixType,"QuaternaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixTime,"QuaternaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixRate,"QuaternaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfQuaternaryWashMixes, "NumberOfQuaternaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				NumberOfQuaternaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfQuaternaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixVolume, "QuaternaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixVolume->10 Microliter,
				QuaternaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixTemperature,"QuaternaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixTipType, "QuaternaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashMixTipMaterial, "QuaternaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashCollectionContainer,"QuaternaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Output->Options
			];
			Lookup[options,QuaternaryWashCollectionContainer],
			{ObjectP[Model[Container,Vessel,"2mL Tube"]],ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashCollectionContainerLabel,"QuaternaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				QuaternaryWashCollectionContainerLabel-> {"my test QuaternaryWash container"},
				Output->Options
			];
			Lookup[options,QuaternaryWashCollectionContainerLabel],
			{"my test QuaternaryWash container"},
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashCollectionStorageCondition,"QuaternaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}},
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashCollectionStorageCondition -> Disposal,
				Output->Options
			];
			Lookup[options,QuaternaryWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfQuaternaryWashes,"NumberOfQuaternaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				NumberOfQuaternaryWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfQuaternaryWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashAirDry,"QuaternaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,QuaternaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,QuaternaryWashAirDryTime,"QuaternaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashAirDry->True,
				QuaternaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,QuaternaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{QuaternaryWashAspirationPosition, QuaternaryWashAspirationPositionOffset},"QuaternaryWashAspirationPosition and QuaternaryWashAspirationPositionOffset are set to Bottom and 2 Millimeter if QuaternaryWash is performed using Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWash->True,
				Preparation -> Robotic,
				MagnetizationRack -> Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],
				Output->Options
			];
			Lookup[options,{QuaternaryWashAspirationPosition, QuaternaryWashAspirationPositionOffset}],
			{Bottom, EqualP[2 Millimeter]},
			Variables:>{options}
		],

		(*==QuinaryWash==*)

		Example[{Options,QuinaryWash,"QuinaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWash->True,
				Output->Options
			];
			Lookup[options,QuinaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashBuffer,"QuinaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,QuinaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,QuinaryWashBufferVolume,"QuinaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,QuinaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMagnetizationTime,"QuinaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,QuinaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashAspirationVolume,"QuinaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,QuinaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMix,"QuinaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				Output->Options
			];
			Lookup[options,QuinaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixType,"QuinaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,QuinaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixTime,"QuinaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,QuinaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixRate,"QuinaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,QuinaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfQuinaryWashMixes, "NumberOfQuinaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				NumberOfQuinaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfQuinaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixVolume, "QuinaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixVolume->10 Microliter,
				QuinaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,QuinaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixTemperature,"QuinaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,QuinaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixTipType, "QuinaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,QuinaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashMixTipMaterial, "QuinaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,QuinaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashCollectionContainer,"QuinaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Output->Options
			];
			Lookup[options,QuinaryWashCollectionContainer],
			{ObjectP[Model[Container,Vessel,"2mL Tube"]],ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,QuinaryWashCollectionContainerLabel,"QuinaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				QuinaryWashCollectionContainerLabel-> {"my test QuinaryWash container"},
				Output->Options
			];
			Lookup[options,QuinaryWashCollectionContainerLabel],
			{"my test QuinaryWash container"},
			Variables:>{options}
		],
		Example[{Options,QuinaryWashCollectionStorageCondition,"QuinaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashCollectionStorageCondition -> Disposal,
				Output->Options
			];
			Lookup[options,QuinaryWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfQuinaryWashes,"NumberOfQuinaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				NumberOfQuinaryWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfQuinaryWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashAirDry,"QuinaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,QuinaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,QuinaryWashAirDryTime,"QuinaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashAirDry->True,
				QuinaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,QuinaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{QuinaryWashAspirationPosition, QuinaryWashAspirationPositionOffset},"QuinaryAspirationPosition and QuinaryAspirationPositionOffset are set to Bottom and 2 Millimeter if QuinaryWash is performed using Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWash->True,
				Preparation -> Robotic,
				MagnetizationRack -> Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],
				Output->Options
			];
			Lookup[options,{QuinaryWashAspirationPosition, QuinaryWashAspirationPositionOffset}],
			{Bottom, EqualP[2 Millimeter]},
			Variables:>{options}
		],


		(*==SenaryWash==*)

		Example[{Options,SenaryWash,"SenaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWash->True,
				Output->Options
			];
			Lookup[options,SenaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,SenaryWashBuffer,"SenaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,SenaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,SenaryWashBufferVolume,"SenaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,SenaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMagnetizationTime,"SenaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,SenaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,SenaryWashAspirationVolume,"SenaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,SenaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMix,"SenaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				Output->Options
			];
			Lookup[options,SenaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixType,"SenaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,SenaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixTime,"SenaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,SenaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixRate,"SenaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,SenaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfSenaryWashMixes, "NumberOfSenaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				NumberOfSenaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfSenaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixVolume, "SenaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixVolume->10 Microliter,
				SenaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,SenaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixTemperature,"SenaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,SenaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixTipType, "SenaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,SenaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,SenaryWashMixTipMaterial, "SenaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,SenaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,SenaryWashCollectionContainer,"SenaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"]},
				Output->Options
			];
			Lookup[options,SenaryWashCollectionContainer],
			{ObjectP[Model[Container,Vessel,"2mL Tube"]],ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,SenaryWashCollectionContainerLabel,"SenaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				SenaryWashCollectionContainerLabel-> {"my test SenaryWash container"},
				Output->Options
			];
			Lookup[options,SenaryWashCollectionContainerLabel],
			{"my test SenaryWash container"},
			Variables:>{options}
		],
		Example[{Options,SenaryWashCollectionStorageCondition,"SenaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashCollectionStorageCondition -> Disposal,
				Output->Options
			];
			Lookup[options,SenaryWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfSenaryWashes,"NumberOfSenaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				NumberOfSenaryWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfSenaryWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,SenaryWashAirDry,"SenaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,SenaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,SenaryWashAirDryTime,"SenaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashAirDry->True,
				SenaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,SenaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{SenaryWashAspirationPosition, SenaryWashAspirationPositionOffset},"SenaryWashAspirationPosition and SenaryWashAspirationPositionOffset are set to Bottom and 2 Millimeter if SenaryWash is performed using Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWash->True,
				Preparation -> Robotic,
				MagnetizationRack -> Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],
				Output->Options
			];
			Lookup[options,{SenaryWashAspirationPosition, SenaryWashAspirationPositionOffset}],
			{Bottom, EqualP[2 Millimeter]},
			Variables:>{options}
		],


		(*==SeptenaryWash==*)

		Example[{Options,SeptenaryWash,"SeptenaryWash can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWash->True,
				Output->Options
			];
			Lookup[options,SeptenaryWash],
			True,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashBuffer,"SeptenaryWashBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,SeptenaryWashBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashBufferVolume,"SeptenaryWashBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,SeptenaryWashBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMagnetizationTime,"SeptenaryWashMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,SeptenaryWashMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashAspirationVolume,"SeptenaryWashAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashAspirationVolume->All,
				Output->Options
			];
			Lookup[options,SeptenaryWashAspirationVolume],
			All,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMix,"SeptenaryWashMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				Output->Options
			];
			Lookup[options,SeptenaryWashMix],
			True,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixType,"SeptenaryWashMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixType->Shake,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixTime,"SeptenaryWashMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixRate,"SeptenaryWashMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixRate],
			168 RPM,
			Variables:>{options}
		],
		Example[{Options,NumberOfSeptenaryWashMixes, "NumberOfSeptenaryWashMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				NumberOfSeptenaryWashMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfSeptenaryWashMixes],
			15,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixVolume, "SeptenaryWashMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixVolume->10 Microliter,
				SeptenaryWashMixType->Pipette,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixTemperature,"SeptenaryWashMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixTipType, "SeptenaryWashMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixTipType],
			WideBore,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashMixTipMaterial, "SeptenaryWashMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashCollectionContainer,"SeptenaryWashCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashCollectionContainer->{{"A1",{1,Model[Container,Vessel,"2mL Tube"]}},{"A1",{2,Model[Container,Vessel,"2mL Tube"]}}},
				Output->Options
			];
			Lookup[options,SeptenaryWashCollectionContainer],
			{{"A1",{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]}},{"A1",{2,ObjectP[Model[Container,Vessel,"2mL Tube"]]}}},
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashCollectionContainerLabel,"SeptenaryWashCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				SeptenaryWashCollectionContainerLabel-> {"my test SeptenaryWash container"},
				Output->Options
			];
			Lookup[options,SeptenaryWashCollectionContainerLabel],
			{"my test SeptenaryWash container"},
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashCollectionStorageCondition,"SeptenaryWashCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				{{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}},
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashCollectionStorageCondition -> Disposal,
				Output->Options
			];
			Lookup[options,SeptenaryWashCollectionStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,NumberOfSeptenaryWashes,"NumberOfSeptenaryWashes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				NumberOfSeptenaryWashes->1,
				Output->Options
			];
			Lookup[options,NumberOfSeptenaryWashes],
			1,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashAirDry,"SeptenaryWashAirDry can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashAirDry->True,
				Output->Options
			];
			Lookup[options,SeptenaryWashAirDry],
			True,
			Variables:>{options}
		],
		Example[{Options,SeptenaryWashAirDryTime,"SeptenaryWashAirDryTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashAirDry->True,
				SeptenaryWashAirDryTime->1 Minute,
				Output->Options
			];
			Lookup[options,SeptenaryWashAirDryTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,{SeptenaryWashAspirationPosition, SeptenaryWashAspirationPositionOffset},"SeptenaryWashAspirationPosition and SeptenaryWashAspirationPositionOffset are set to Bottom and 2 Millimeter if SeptenaryWash is performed using Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWash->True,
				Preparation -> Robotic,
				MagnetizationRack ->  Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],
				Output->Options
			];
			Lookup[options,{SeptenaryWashAspirationPosition, SeptenaryWashAspirationPositionOffset}],
			{Bottom, EqualP[2 Millimeter]},
			Variables:>{options}
		],


		(*==Elution==*)

		Example[{Options,Elution,"Elution can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Elution->True,
				Output->Options
			];
			Lookup[options,Elution],
			True,
			Variables:>{options}
		],
		Example[{Options,ElutionBuffer,"ElutionBuffer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,ElutionBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,ElutionBufferVolume,"ElutionBufferVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionBufferVolume->22 Microliter,
				Output->Options
			];
			Lookup[options,ElutionBufferVolume],
			22 Microliter,
			Variables:>{options}
		],
		Example[{Options,ElutionMix,"ElutionMix can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMix->True,
				Output->Options
			];
			Lookup[options,ElutionMix],
			True,
			Variables:>{options}
		],

		Example[{Options,ElutionMixType,"ElutionMixType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixType->Shake,
				Output->Options
			];
			Lookup[options,ElutionMixType],
			Shake,
			Variables:>{options}
		],

		Example[{Options,ElutionMixTime,"ElutionMixTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixTime->10 Minute,
				Output->Options
			];
			Lookup[options,ElutionMixTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,ElutionMixRate,"ElutionMixRate can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixRate->168 RPM,
				Output->Options
			];
			Lookup[options,ElutionMixRate],
			168 RPM,
			Variables:>{options}
		],

		Example[{Options,NumberOfElutionMixes, "NumberOfElutionMixes can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfElutionMixes->15,
				Output->Options
			];
			Lookup[options,NumberOfElutionMixes],
			15,
			Variables:>{options}
		],

		Example[{Options,ElutionMixVolume, "ElutionMixVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixVolume->10 Microliter,
				ElutionMixType->Pipette,
				Output->Options
			];
			Lookup[options,ElutionMixVolume],
			10 Microliter,
			Variables:>{options}
		],

		Example[{Options,ElutionMixTemperature,"ElutionMixTemperature can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixTemperature->30 Celsius,
				Output->Options
			];
			Lookup[options,ElutionMixTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,ElutionMixTipType, "ElutionMixTipType can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixTipType->WideBore,
				Output->Options
			];
			Lookup[options,ElutionMixTipType],
			WideBore,
			Variables:>{options}
		],

		Example[{Options,ElutionMixTipMaterial, "ElutionMixTipMaterial can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMixTipMaterial->Polypropylene,
				Output->Options
			];
			Lookup[options,ElutionMixTipMaterial],
			Polypropylene,
			Variables:>{options}
		],

		Example[{Options,ElutionMagnetizationTime,"ElutionMagnetizationTime can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionMagnetizationTime->1 Minute,
				Output->Options
			];
			Lookup[options,ElutionMagnetizationTime],
			1 Minute,
			Variables:>{options}
		],
		Example[{Options,ElutionAspirationVolume,"ElutionAspirationVolume can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionAspirationVolume->All,
				Output->Options
			];
			Lookup[options,ElutionAspirationVolume],
			All,
			Variables:>{options}
		],

		Example[{Options,ElutionCollectionContainer,"ElutionCollectionContainer can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionCollectionContainer->{"A1",Model[Container,Vessel,"2mL Tube"]},
				Output->Options
			];
			Lookup[options,ElutionCollectionContainer],
			{{"A1",ObjectP[Model[Container,Vessel,"2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,ElutionCollectionContainer,"ElutionCollectionContainer can be specified to pool collection of samples within each batch:"},
			options=ExperimentMagneticBeadSeparation[{
				{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
			},
				ElutionCollectionContainer->{{1,Model[Container,Vessel,"2mL Tube"]}, {2,Model[Container,Vessel,"2mL Tube"]}},
				Output->Options
			];
			Lookup[options,ElutionCollectionContainer],
			{
				{
					{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
					{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
				{
					{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}
				}
			},
			Variables:>{options}
		],
		Example[{Options,ElutionCollectionContainer,"ElutionCollectionContainer can be specified to pool collection of samples within each batch with multiple number of elutions:"},
			options=ExperimentMagneticBeadSeparation[{
				{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]},
				{Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
			},
				ElutionCollectionContainer->{{"A1",{1,Model[Container,Vessel,"2mL Tube"]}}, {"A1",{2,Model[Container,Vessel,"2mL Tube"]}}},
				NumberOfElutions ->{{3,1},{2}},
				Output->Options
			];
			Lookup[options,{ElutionCollectionContainer,ContainerOutLabel}],
			{
				{
					{
						{"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}, {"A1", {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
					},
					{
						{"A1", {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}
					}
				},
				{
					{
						{_String, _String, _String},
						{_String}
					},
					{
						{_String, _String}
					}
				}
			},
			Variables:>{options}
		],
		Example[{Options,ElutionCollectionContainerLabel,"ElutionCollectionContainerLabel can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionCollectionContainer->{Model[Container,Vessel,"2mL Tube"]},
				ElutionCollectionContainerLabel-> {"my test Elution container"},
				Output->Options
			];
			Lookup[options,ElutionCollectionContainerLabel],
			{"my test Elution container"},
			Variables:>{options}
		],
		Example[{Options,ElutionCollectionStorageCondition,"ElutionCollectionStorageCondition can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ElutionCollectionStorageCondition->Model[StorageCondition, "Freezer"],
				Output->Options
			];
			Lookup[options,ElutionCollectionStorageCondition],
			ObjectP[Model[StorageCondition, "Freezer"]],
			Variables:>{options}
		],
		Example[{Options,NumberOfElutions,"NumberOfElutions can be specified:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfElutions->1,
				Output->Options
			];
			Lookup[options,NumberOfElutions],
			1,
			Variables:>{options}
		],
		Example[{Options,{ElutionAspirationPosition, ElutionAspirationPositionOffset},"ElutionAspirationPositionOffset is set to 2 Millimeter if ElutionAspirationPosition is specified to be not Bottom:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Elution->True,
				ElutionAspirationPosition -> LiquidLevel,
				Preparation -> Robotic,
				Output->Options
			];
			Lookup[options,{ElutionAspirationPosition, ElutionAspirationPositionOffset}],
			{LiquidLevel, EqualP[2 Millimeter]},
			Variables:>{options}
		],

		(* Other Label options *)
		Example[{Options,SampleLabel,"Specify a SampleLabel:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SampleLabel->"My Test Sample Label",
				Output->Options
			];
			Lookup[options,SampleLabel],
			"My Test Sample Label",
			Variables:>{options}
		],
		Example[{Options,SampleContainerLabel,"Specify a SampleContainerLabel:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SampleContainerLabel->"My Test Sample Container Label",
				Output->Options
			];
			Lookup[options,SampleContainerLabel],
			"My Test Sample Container Label",
			Variables:>{options}
		],

		Example[{Options,SampleOutLabel,"Specify a SampleOutLabel:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SampleOutLabel->"My Test Sample Out Label",
				Output->Options
			];
			Lookup[options,SampleOutLabel],
			{"My Test Sample Out Label"},
			Variables:>{options}
		],

		Example[{Options,ContainerOutLabel,"Specify a ContainerOutLabel:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				ContainerOutLabel->"My Test Container Out Label",
				Output->Options
			];
			Lookup[options,ContainerOutLabel],
			{"My Test Container Out Label"},
			Variables:>{options}
		],


		(*===Shared sample prep options tests===*)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],

		(*Incubate options tests*)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle*)
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubateAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		(*Note: You CANNOT be in a plate for the following test*)
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],MixType->Shake,Output->Options];
			Lookup[options,MixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

		(*Centrifuge options tests*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		(*Note: CentrifugeTime cannot go above 5 minutes without restricting the types of centrifuges that can be used*)
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: Put your sample in a 2mL tube for the following test*)
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		(*Filter options tests*)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FiltrationType->Syringe,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterMaterial->PES,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 50mL tube 1 sample" <> $SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 50mL tube 1 sample" <> $SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 50mL tube 1 sample" <> $SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterSterile->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],*)
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],

		(*Aliquot options tests*)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AliquotAmount->0.5*Milliliter,Output->Options];
			Lookup[options,AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],TargetConcentration->1*Micromolar,TargetConcentrationAnalyte->Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1" <> $SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Protein,"ExperimentMagneticBeadSeparation test analyte 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.1*Milliliter,AssayVolume->0.2*Milliliter,Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"Test Label for ExperimentMagneticBeadSeparation 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label for ExperimentMagneticBeadSeparation 1"},
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Aliquot->True,ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],

		(*Post-processing options tests*)
		Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],MeasureWeight->True,Output->Options];
			Lookup[options,MeasureWeight],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],MeasureVolume->True,Output->Options];
			Lookup[options,MeasureVolume],
			True,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Set the ImageSample option:"},
			options=ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],

		(* General extra functionality tests *)
		Test["If PreWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMix->True,
				Output->Options
			];
			Lookup[options,PreWashMixType],
				Pipette,
			Variables :> {options}
		],
		Test["If PreWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				PreWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,PreWashMixRate],
				1000 RPM,
			Variables :> {options}
		],

		Test["If EquilibrationMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMix->True,
				Output->Options
			];
			Lookup[options,EquilibrationMixTipType],
			WideBore,
			Variables :> {options}
		],
		Test["If EquilibrationMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				EquilibrationMixType->Swirl,
				Output->Options
			];
			Lookup[options,NumberOfEquilibrationMixes],
			20,
			Variables :> {options}
		],

		Test["If LoadingMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMix->True,
				Output->Options
			];
			Lookup[options,LoadingMixTipMaterial],
			Polypropylene,
			Variables :> {options}
		],
		Test["If LoadingMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				LoadingMixType->Vortex,
				Output->Options
			];
			Lookup[options,LoadingMixTemperature],
			Ambient,
			Variables :> {options}
		],
		Test["If WashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMix->True,
				Output->Options
			];
			Lookup[options,WashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If WashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				WashMixType->Vortex,
				Output->Options
			];
			Lookup[options,WashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If SecondaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMix->True,
				Output->Options
			];
			Lookup[options,SecondaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If SecondaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,
				SecondaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,SecondaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If TertiaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMix->True,
				Output->Options
			];
			Lookup[options,TertiaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If TertiaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,
				TertiaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,TertiaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If QuaternaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMix->True,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If QuaternaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,
				QuaternaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,QuaternaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If QuinaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMix->True,
				Output->Options
			];
			Lookup[options,QuinaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If QuinaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,
				QuinaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,QuinaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If SenaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMix->True,
				Output->Options
			];
			Lookup[options,SenaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If SenaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,
				SenaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,SenaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],
		Test["If SeptenaryWashMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMix->True,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If SeptenaryWashMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				SeptenaryWashMixType->Vortex,
				Output->Options
			];
			Lookup[options,SeptenaryWashMixRate],
			1000 RPM,
			Variables :> {options}
		],

		Test["If ElutionMix is set to true, but no other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				ElutionMix->True,
				Output->Options
			];
			Lookup[options,ElutionMixType],
			Pipette,
			Variables :> {options}
		],
		Test["If ElutionMix is set to true, and other mix options for that stage are set, the helper function is called to resolve all mix options:",
			options=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Wash->True,SecondaryWash->True,TertiaryWash->True,QuaternaryWash->True,QuinaryWash->True,SenaryWash->True,
				ElutionMixType->Vortex,
				Output->Options
			];
			Lookup[options,ElutionMixRate],
			1000 RPM,
			Variables :> {options}
		],

		(*More tests on pre-resolver. Within a batch when assay container is plate, airdry options, magnetization time, and some mix options (mix-type if full-coontainer mix, temp, time, rate) setting needs to propogage in the batch before the mapthread independent resolver.*)
		Test["If AirDry is set to True for one sample in a batch, pre-resolver is called to set AirDry to True for other samples in the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				PreWashAirDry->{{Automatic,True}},
				MagnetizationRack->Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],(*Alpaqua 96S Super Magnet 96-well Plate Rack*)
				Output->Options
			];
			Lookup[options,PreWashAirDry],
			{{True,True}},
			Variables :> {options}
		],
		Test["If AirDryTime is set to Null for one sample in a batch, pre-resolver is called to set AirDryTime to the same for other samples in the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				LoadingAirDryTime->{{Automatic,Null}},
				MagnetizationRack->Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],(*Alpaqua 96S Super Magnet 96-well Plate Rack*)
				Output->Options
			];
			Lookup[options,LoadingAirDryTime],
			{{Null,Null}},
			Variables :> {options}
		],
		Test["If MagnetizationTime is set for one sample in a batch, pre-resolver is called to set MagnetizationTime to the same for other samples in the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				EquilibrationMagnetizationTime->{{Automatic,2 Minute}},
				MagnetizationRack->Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],(*Alpaqua 96S Super Magnet 96-well Plate Rack*)
				Output->Options
			];
			Lookup[options,EquilibrationMagnetizationTime],
			{{2 Minute,2 Minute}},
			Variables :> {options}
		],
		Test["If MixType is set to a full-container mix type for one sample in a batch and the assay container is a plate, pre-resolver is called to set MixType to the same for other samples in the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				WashMixType->{{Automatic,Shake}},
				MagnetizationRack->Model[Item,MagnetizationRack,"Alpaqua 96S Super Magnet 96-well Plate Rack"],(*Alpaqua 96S Super Magnet 96-well Plate Rack*)
				Output->Options
			];
			Lookup[options,WashMixType],
			{{Shake,Shake}},
			Variables :> {options}
		],
		Test["If MixType is set to a full-container mix type for one sample in a batch but the assay container is not a plate, the mix options will resolve normally allowing different mix types and options within the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				Wash->True,
				SecondaryWashMixType->{{Automatic,Shake}},
				MagnetizationRack->Model[Container,Rack,"id:n0k9mG8D1x36"],(*DynaMag Magnet 2mL Tube Rack*)
				Output->Options
			];
			Lookup[options,SecondaryWashMixType],
			{{Null,Shake}},
			Variables :> {options}
		],
		Test["If a mix option that affects the whole container (i.e. mix temperature, mix rate, and mix time) is set for one sample in a batch and the assay container is a plate, pre-resolver is called to set that option to the same for other samples in the batch:",
			options=ExperimentMagneticBeadSeparation[
				{
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
					}
				},
				ElutionMixTemperature->{{Automatic,4 Celsius}},
				MagnetizationRack->Model[Container,Rack,"id:xRO9n3BDjjZw"],(*DynaMag Magnet 96-well Skirted Plate Rack*)
				Output->Options
			];
			Lookup[options,ElutionMixTemperature],
			{{4 Celsius,4 Celsius}},
			Variables :> {options}
		],

		(* Basic tests, but with Preparation->Robotic *)
		Test["Accepts a sample object with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts multiple sample objects with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID]
				},
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts mixed sample and container inputs with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentMagneticBeadSeparation test 2mL tube 2"<> $SessionUUID]
				},
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts mixed sample and container (with multiple samples) inputs with Robotic Preparation:",
			Quiet[
				ExperimentMagneticBeadSeparation[
					{
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
						Object[Container, Plate, "ExperimentMagneticBeadSeparation test 96-well plate" <> $SessionUUID]
					},
					Volume->50Microliter,
					Preparation->Robotic
				],
				{Warning::MultipleAnalytes, Warning::MultipleTargets}
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts nested sample objects with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts a non-empty container object with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				Object[Container,Vessel,"ExperimentMagneticBeadSeparation test 2mL tube 1" <> $SessionUUID],
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts different nesting patterns with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Accepts nesting patterns combining samples and containers with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					Object[Container,Vessel,"ExperimentMagneticBeadSeparation test 2mL tube 1" <> $SessionUUID],
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["NumberOfPreWashes can be specified with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				Object[Sample, "ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				NumberOfPreWashes -> 3,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["NumberOfElutions can be specified when accepting nested SamplesIn with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				NumberOfElutions -> 2, Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["NumberOfWashes can be specified when accepting nested SamplesIn and {well,{index,container}} formatted WashCollectionContainer with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				WashBufferVolume -> 20 Microliter,
				WashCollectionContainer -> {
					{
						{
							{"A1", {1, Model[Container, Vessel, "2mL Tube"]}},
							{"A1", {1,Model[Container, Vessel, "2mL Tube"]}}
						}
					},
					{
						{
							{"A1", {2, Model[Container, Vessel, "2mL Tube"]}},
							{"A1", {2, Model[Container, Vessel, "2mL Tube"]}}
						},
						{
							{"A1", {3, Model[Container, Vessel, "2mL Tube"]}},
							{"A1", {3, Model[Container, Vessel, "2mL Tube"]}}
						}
					}
				},
				NumberOfWashes -> 2,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["NumberOfSecondaryWashes can be specified when accepting nested SamplesIn and {well,container} formatted SecondaryWashCollectionContainer with Robotic Preparation:",
			ExperimentMagneticBeadSeparation[
				{
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID]},
					{Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 2 sample" <> $SessionUUID],
						Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 3 sample" <> $SessionUUID]}
				},
				Wash->True,
				SecondaryWashCollectionContainer -> {
					{
						{
							{"A1", Model[Container, Vessel, "2mL Tube"]},
							{"A1", Model[Container, Vessel, "2mL Tube"]}
						}
					},
					{
						{
							{"A1", Model[Container, Vessel, "2mL Tube"]},
							{"A1", Model[Container, Vessel, "2mL Tube"]}
						},
						{
							{"A1", Model[Container, Vessel, "2mL Tube"]},
							{"A1", Model[Container, Vessel, "2mL Tube"]}
						}
					}
				},
				NumberOfSecondaryWashes -> 2,
				Preparation -> Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["The correct amount of resources are made per input sample when the sample has to be aliquoted into a new container for the liquid handler",
			protocol=ExperimentMagneticBeadSeparation[
				Object[Sample,"ExperimentMagneticBeadSeparation test 50mL tube 4 sample" <> $SessionUUID],
				Volume->1 Milliliter,
				Preparation->Robotic
			];
			Length[Search[Object[Resource,Sample],Sample==Object[Sample,"ExperimentMagneticBeadSeparation test 50mL tube 4 sample" <> $SessionUUID]&& DeveloperObject != True]],
			2,
			Variables :> {protocol}
		],
		Test["When the SamplesIn are in a container that is not LiquidHandlerCompatible and Preparation->Robotic, throw an error.",
			ExperimentMagneticBeadSeparation[Object[Sample,"ExperimentMagneticBeadSeparation"<>" test falcon tube sample" <> $SessionUUID],Preparation->Robotic],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictingMagneticBeadSeparationMethodRequirements}
		],
		Test["Accepts sample object as an option value for MagneticBeads:",
			ExperimentMagneticBeadSeparation[
				{
					Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					Object[Container, Vessel, "ExperimentMagneticBeadSeparation test 2mL tube 2"<> $SessionUUID]
				},
				MagneticBeads -> Object[Sample,"ExperimentMagneticBeadSeparation test 2mL tube magnetic bead sample" <> $SessionUUID],
				Preparation->Robotic
			],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True,
		$DeveloperSearch = True
	},
	Parallel->True,
	(* NOTE: We have to turn these messages off in our SetUp as well since our tests run in parallel on Manifold. *)
	SetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Error::NoLaboratoryNotebook];
		Off[Warning::SampleMustBeMoved];
		ClearMemoization[];
	),
	SymbolSetUp:>(
		setUpMagneticBeadTestObjects["ExperimentMagneticBeadSeparation"]
	),
	SymbolTearDown:>(
		tearDownMagneticBeadTestObjects["ExperimentMagneticBeadSeparation"]
	)
];

(* ::Subsubsection::Closed:: *)
(*setUpSimpleMagneticBeadTestObjects*)
setUpSimpleMagneticBeadTestObjects[functionName_String]:=Module[{},
	Module[{allObjects,existingObjects},

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Error::NoLaboratoryNotebook];
		Off[Warning::SampleMustBeMoved];

		(*Gather all the objects created in SymbolSetUp*)
		allObjects=Cases[Flatten[{
			(*containers*)
			Object[Container,Vessel,functionName<>" test 2mL tube 1"<> $SessionUUID],
			(*samples*)
			Object[Sample,functionName<>" test 2mL tube 1 sample"<> $SessionUUID]
		}],ObjectP[]];

		(*Check whether the names we want to give below already exist in the database*)
		existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

		(*Erase any test objects that we failed to erase in the last unit test*)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
	];

	Block[{$AllowSystemsProtocols=True},
		(*Make test containers*)
		Upload[
			<|Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
				Name->functionName<>" test 2mL tube 1" <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True|>
		];

		(*Make test samples*)
		UploadSample[
			{{100 VolumePercent,Model[Molecule,"Water"]}},
			{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 1"<> $SessionUUID]},
			Name -> functionName<>" test 2mL tube 1 sample"<> $SessionUUID,
			InitialAmount->1 Milliliter,
			State->Liquid
		];

		Upload[<|
			Object->Object[Sample,functionName<>" test 2mL tube 1 sample"<> $SessionUUID],
			DeveloperObject->True
		|>];

	];
];


(* ::Subsubsection::Closed:: *)
(*tearDownSimpleMagneticBeadTestObjects*)

tearDownSimpleMagneticBeadTestObjects[functionName_String]:=Module[{allObjects,existingObjects},

	On[Warning::SamplesOutOfStock];
	On[Warning::InstrumentUndergoingMaintenance];
	On[Error::NoLaboratoryNotebook];
	On[Warning::SampleMustBeMoved];

	(*Gather all the objects created in SymbolSetUp*)
	allObjects=Cases[Flatten[{
		(*containers*)
		Object[Container,Vessel,functionName<>" test 2mL tube 1"<> $SessionUUID],
		(*samples*)
		Object[Sample,functionName<>" test 2mL tube 1 sample"<> $SessionUUID]
	}],ObjectP[]];

	(*Check whether the created objects exist in the database*)
	existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

	(*Erase all the created objects*)
	Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
];


(* ::Subsubsection::Closed:: *)
(*setUpMagneticBeadTestObjects*)


setUpMagneticBeadTestObjects[functionName_String]:=Module[{},
	Module[{allObjects,existingObjects},

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Error::NoLaboratoryNotebook];
		Off[Warning::SampleMustBeMoved];
		Off[Warning::GeneralResolvedMagneticBeads];

		(*Gather all the objects created in SymbolSetUp*)
		allObjects=Cases[Flatten[{
			(*containers*)
			Object[Container,Plate,functionName<>" test 96-well plate" <> $SessionUUID],
			Table[Object[Container,Vessel,functionName<>" test 2mL tube "<>ToString[x]<> $SessionUUID],{x,5}],
			Table[Object[Container,Vessel,functionName<>" test 50mL tube "<>ToString[x]<> $SessionUUID],{x,4}],
			Object[Container,Vessel,functionName<>" test filled 2mL tube" <> $SessionUUID],
			Object[Container,Vessel,functionName<>" test 2mL tube for magnetic beads" <> $SessionUUID],
			Object[Container,Vessel,functionName<>" test discarded 2mL tube" <> $SessionUUID],
			Object[Container,Vessel,functionName<>" test solid 2mL tube" <> $SessionUUID],
			Object[Container,Vessel,functionName<>" test 14mL falcon tube" <> $SessionUUID],
			(*molecules*)
			Table[Model[Molecule,Protein,functionName<>" test analyte "<>ToString[x]<> $SessionUUID],{x,2}],
			Table[Model[Molecule,Protein,functionName<>" test target "<>ToString[x]<> $SessionUUID],{x,2}],
			Model[Molecule,Oligomer,functionName<>" test analyte 3" <> $SessionUUID],
			(*samples*)
			Table[Object[Sample,functionName<>" test 96-well plate sample "<>ToString[x]<> $SessionUUID],{x,4}],
			Table[Object[Sample,functionName<>" test 2mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,3}],
			Table[Object[Sample,functionName<>" test 50mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,4}],
			Object[Sample,functionName<>" test filled 2mL tube sample" <> $SessionUUID],
			Model[Sample,functionName<>" test Magnetic Bead sample model" <> $SessionUUID],
			Model[Resin,functionName<> "test Magnetic bead resin model" <> $SessionUUID],
			Object[Sample,functionName<>" test 2mL tube magnetic bead sample" <> $SessionUUID],
			Object[Sample,functionName<>" test discarded 2mL tube sample" <> $SessionUUID],
			Object[Sample,functionName<>" test solid 2mL tube sample" <> $SessionUUID],
			Object[Sample,functionName<>" test falcon tube sample" <> $SessionUUID],
			Object[Sample,functionName<>" test 2mL tube no analyte sample" <> $SessionUUID],
			Object[Sample,functionName<>" test 2mL tube multiple target type sample" <> $SessionUUID],
			(*protocols*)
			If[DatabaseMemberQ[#],Download[#,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]]&/@{Object[Protocol,MagneticBeadSeparation,functionName<>" template test protocol" <> $SessionUUID],Object[Protocol,MagneticBeadSeparation,functionName<>" name test protocol" <> $SessionUUID]}
		}],ObjectP[]];

		(*Check whether the names we want to give below already exist in the database*)
		existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

		(*Erase any test objects that we failed to erase in the last unit test*)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
	];

	Block[{$AllowSystemsProtocols=True},
		Module[{containerSampleObjects,templateTestProtocol,protocolObjects,allObjects},

			(*Gather all the created objects*)
			containerSampleObjects=Flatten[{
				(*containers*)
				Object[Container,Plate,functionName<>" test 96-well plate"<> $SessionUUID],
				Table[Object[Container,Vessel,functionName<>" test 2mL tube "<>ToString[x]<> $SessionUUID],{x,5}],
				Table[Object[Container,Vessel,functionName<>" test 50mL tube "<>ToString[x]<> $SessionUUID],{x,4}],
				Object[Container,Vessel,functionName<>" test filled 2mL tube" <> $SessionUUID],
				Object[Container,Vessel,functionName<>" test 2mL tube for magnetic beads" <> $SessionUUID],
				Object[Container,Vessel,functionName<>" test discarded 2mL tube" <> $SessionUUID],
				Object[Container,Vessel,functionName<>" test solid 2mL tube" <> $SessionUUID],
				Object[Container,Vessel,functionName<>" test 14mL falcon tube" <> $SessionUUID],
				(*molecules*)
				Table[Model[Molecule,Protein,functionName<>" test analyte "<>ToString[x]<> $SessionUUID],{x,2}],
				Table[Model[Molecule,Protein,functionName<>" test target "<>ToString[x]<> $SessionUUID],{x,2}],
				Model[Molecule,Oligomer,functionName<>" test analyte 3" <> $SessionUUID],
				(*samples*)
				Table[Object[Sample,functionName<>" test 96-well plate sample "<>ToString[x]<> $SessionUUID],{x,4}],
				Table[Object[Sample,functionName<>" test 2mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,3}],
				Table[Object[Sample,functionName<>" test 50mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,4}],
				Model[Sample,functionName<>" test Magnetic Bead sample model" <> $SessionUUID],
				Model[Resin,functionName<> "test Magnetic bead resin model" <> $SessionUUID],
				Object[Sample,functionName<>" test 2mL tube magnetic bead sample" <> $SessionUUID],
				Table[Object[Sample,functionName<>" test 50mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,3}],
				Object[Sample,functionName<>" test filled 2mL tube sample" <> $SessionUUID],
				Object[Sample,functionName<>" test discarded 2mL tube sample" <> $SessionUUID],
				Object[Sample,functionName<>" test solid 2mL tube sample" <> $SessionUUID],
				Object[Sample,functionName<>" test falcon tube sample" <> $SessionUUID],
				Object[Sample,functionName<>" test 2mL tube multiple target type sample" <> $SessionUUID],
				Object[Sample,functionName<>" test 2mL tube no analyte sample" <> $SessionUUID]
			}];

			(*Make test containers*)
			Upload[
				Flatten[{
					<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],Name->functionName<>" test 96-well plate" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
					Table[<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->functionName<>" test 2mL tube "<>ToString[x] <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,{x,5}],
					Table[<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Name->functionName<>" test 50mL tube "<>ToString[x] <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,{x,4}],
					<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],Name->functionName<>" test filled 2mL tube" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],Name->functionName<>" test 2mL tube for magnetic beads" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],Name->functionName<>" test discarded 2mL tube" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],Name->functionName<>" test solid 2mL tube" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:AEqRl9KXBDoW"],Objects],Name->functionName<>" test 14mL falcon tube" <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>
				}]
			];

			(*Make test molecules*)
			UploadProtein[
				Flatten[{Table[functionName<>" test analyte "<>ToString[x] <> $SessionUUID,{x,2}],Table[functionName<>" test target "<>ToString[x] <> $SessionUUID,{x,2}]}],
				State->Table[Solid,4],
				MSDSFile->Table[NotApplicable,4],
				BiosafetyLevel->Table["BSL-1",4],
				IncompatibleMaterials->Table[{None},4]
			];

			UploadOligomer[
				functionName<>" test analyte 3" <> $SessionUUID,
				Molecule -> Strand[DNA["ATGATCTACGCAT"]],
				PolymerType -> DNA,
				State->Solid
			];


			(*Populate Targets*)
			Upload[{
				<|Object->Model[Molecule,Protein,functionName<>" test analyte 1" <> $SessionUUID],Replace[Targets]->Link[Model[Molecule,Protein,functionName<>" test target 1" <> $SessionUUID]]|>,
				<|Object->Model[Molecule,Protein,functionName<>" test analyte 2" <> $SessionUUID],Replace[Targets]->{Link[Model[Molecule,Protein,functionName<>" test target 1" <> $SessionUUID]],Link[Model[Molecule,Protein,functionName<>" test target 2" <> $SessionUUID]]}|>
			}];

			(* Make test magnetic bead resin *)
			Upload[<|
				Type -> Model[Resin],
				Name -> functionName<> "test Magnetic bead resin model" <> $SessionUUID,
				BiosafetyLevel -> "BSL-1",
				Magnetic -> True,
				MSDSRequired -> False,
				State -> Solid,
				Replace[IncompatibleMaterials] -> {None},
				Replace[Loading] -> {Quantity[0., ("Moles")/("Grams")]},
				Replace[Synonyms] -> {Null},
				DeveloperObject -> True,
				Replace[AffinityLabels]->{Link[Model[Molecule,Protein,functionName<>" test target 1" <> $SessionUUID]]}
			|>];

			(* Make the test Magnetic Bead Model *)
			Upload[
				<|Type -> Model[Sample],
					Name -> functionName<>" test Magnetic Bead sample model" <> $SessionUUID,
					BiosafetyLevel -> "BSL-1",
					DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
					DOTHazardClass -> "Class 0",
					Expires -> True,
					Flammable -> False,
					NFPA -> {Health -> 0, Flammability -> 0, Reactivity -> 0, Special -> {}},
					SampleHandling -> Slurry,
					State -> Liquid,
					Replace[Composition] -> {
						{Quantity[0.05,IndependentUnit["MassPercent"]],Link[Model[Molecule, "id:Y0lXejMq5qAa"]]},
						{Null,Link[Model[Resin, functionName<> "test Magnetic bead resin model" <> $SessionUUID]]},
						{Null,Link[Model[Molecule, "id:vXl9j57PmP5D"]]}
					},
					Replace[IncompatibleMaterials] -> {None},
					Solvent -> Link[Model[Sample, "Milli-Q water"]],
					DeveloperObject -> True
				|>
			];

			(* Add the DefaultSampleModel to the test resin *)
			Upload[
				<|Object->Model[Resin,functionName<> "test Magnetic bead resin model" <> $SessionUUID],DefaultSampleModel->Link[Model[Sample,functionName<>" test Magnetic Bead sample model" <> $SessionUUID]]|>
			];

			(*Make test samples*)
			UploadSample[
				Flatten[Join[

					Table[
						{
							{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
							{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 2"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
							{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 2"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
						3
					],

					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{Model[Sample,functionName<>" test Magnetic Bead sample model" <> $SessionUUID]},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]},{10 Micromolar,Model[Molecule,Oligomer,functionName<>" test analyte 3" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}},
					{{{{10 Micromolar,Model[Molecule,Oligomer,functionName<>" test analyte 3" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}}}
					]
					,1],
				{

					{"A1",Object[Container,Plate,functionName<>" test 96-well plate"<> $SessionUUID]},
					{"B1",Object[Container,Plate,functionName<>" test 96-well plate"<> $SessionUUID]},
					{"C1",Object[Container,Plate,functionName<>" test 96-well plate"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 1"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 2"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 3"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 50mL tube 1"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 50mL tube 2"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 50mL tube 3"<> $SessionUUID]},


					{"A1",Object[Container,Vessel,functionName<>" test 50mL tube 4"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test filled 2mL tube" <> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube for magnetic beads" <> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test discarded 2mL tube" <> $SessionUUID]},
					{"D1",Object[Container,Plate,functionName<>" test 96-well plate"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test solid 2mL tube" <> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 14mL falcon tube" <> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 4"<> $SessionUUID]},
					{"A1",Object[Container,Vessel,functionName<>" test 2mL tube 5"<> $SessionUUID]}
				},
				Name->Flatten[{
					Table[functionName<>" test 96-well plate sample "<>ToString[x]<> $SessionUUID,{x,3}],
					Table[functionName<>" test 2mL tube "<>ToString[x]<>" sample"<> $SessionUUID,{x,3}],
					Table[functionName<>" test 50mL tube "<>ToString[x]<>" sample"<> $SessionUUID,{x,4}],
					functionName<>" test filled 2mL tube sample" <> $SessionUUID,
					functionName<>" test 2mL tube magnetic bead sample" <> $SessionUUID,
					functionName<>" test discarded 2mL tube sample" <> $SessionUUID,
					functionName<>" test 96-well plate sample 4" <> $SessionUUID,
					functionName<>" test solid 2mL tube sample" <> $SessionUUID,
					functionName<>" test falcon tube sample" <> $SessionUUID,
					functionName<>" test 2mL tube multiple target type sample" <> $SessionUUID,
					functionName<>" test 2mL tube no analyte sample" <> $SessionUUID
				}],
				InitialAmount->Flatten[{
					Table[0.1 Milliliter,3],
					Table[1 Milliliter,3],
					Table[15 Milliliter,4],
					10 Milliliter,
					1.8 Milliliter,
					1 Milliliter,
					0.1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter
				}],
				State->Join[Table[Liquid,14],{Solid},{Liquid},{Liquid},{Liquid}]
			];


			(* Populate Analytes and Solvents *)
			Upload[{
				<|Object->Object[Sample,functionName<>" test 96-well plate sample 1"<> $SessionUUID],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 96-well plate sample 2"<> $SessionUUID],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 2"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 96-well plate sample 3"<> $SessionUUID],Replace[Analytes]->{Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]],Link[Model[Molecule,Protein,functionName<>" test analyte 2"<> $SessionUUID]]}|>,
				<|Object->Object[Sample,functionName<>" test 96-well plate sample 4"<> $SessionUUID],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 2mL tube 1 sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 2mL tube 2 sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 2mL tube 3 sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test discarded 2mL tube sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test solid 2mL tube sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test falcon tube sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 2mL tube multiple target type sample" <> $SessionUUID],Replace[Analytes]->{Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]],Link[Model[Molecule,Oligomer,functionName<>" test analyte 3" <> $SessionUUID]]}|>,
				<|Object->Object[Sample,functionName<>" test 50mL tube 1 sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>,
				<|Object->Object[Sample,functionName<>" test 50mL tube 4 sample" <> $SessionUUID], Solvent->Link[Model[Sample, "Milli-Q water"]],Replace[Analytes]->Link[Model[Molecule,Protein,functionName<>" test analyte 1"<> $SessionUUID]]|>
			}];

			(*Generate a test protocol for the template test*)
			templateTestProtocol=ExperimentMagneticBeadSeparation[
				Object[Sample,functionName<>" test 2mL tube 1 sample"<> $SessionUUID],
				Name->functionName<>" template test protocol"<> $SessionUUID,
				PreWashMix->False
			];

			(*Get the objects generated in the test protocol*)
			protocolObjects=Download[templateTestProtocol,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}];

			(*Gather all the test objects created in SymbolSetUp*)
			allObjects=Flatten[{containerSampleObjects,protocolObjects}];

			(* Discard one sample for testing *)
			Upload[<|Object->Object[Sample,functionName<>" test discarded 2mL tube sample" <> $SessionUUID],Status->Discarded|>];

			(* Update the default storage condition for testing *)
			Upload[{
				<|Object -> Model[Sample, functionName <> " test Magnetic Bead sample model" <> $SessionUUID], DefaultStorageCondition -> Link[Model[StorageCondition, "id:N80DNj1r04jW"]]|>,
				<|Object -> Object[Sample, functionName <> " test 96-well plate sample 4" <> $SessionUUID], StorageCondition -> Link[Model[StorageCondition, "id:N80DNj1r04jW"]]|>
			}];

			(*Make all the test objects developer objects*)
			Upload[<|Object->#,DeveloperObject->True|>&/@allObjects];

			(*Turn back on then general beads warning*)
			On[Warning::GeneralResolvedMagneticBeads];
		]
	];
];


(* ::Subsubsection::Closed:: *)
(*tearDownMagneticBeadTestObjects*)


tearDownMagneticBeadTestObjects[functionName_String]:=Module[{allObjects,existingObjects},

	On[Warning::SamplesOutOfStock];
	On[Warning::InstrumentUndergoingMaintenance];
	On[Error::NoLaboratoryNotebook];
	On[Warning::SampleMustBeMoved];

	(*Gather all the objects created in SymbolSetUp*)
	allObjects=Cases[Flatten[{
		(*containers*)
		Object[Container,Plate,functionName<>" test 96-well plate" <> $SessionUUID],
		Table[Object[Container,Vessel,functionName<>" test 2mL tube "<>ToString[x]<> $SessionUUID],{x,5}],
		Table[Object[Container,Vessel,functionName<>" test 50mL tube "<>ToString[x]<> $SessionUUID],{x,4}],
		Object[Container,Vessel,functionName<>" test filled 2mL tube" <> $SessionUUID],
		Object[Container,Vessel,functionName<>" test 2mL tube for magnetic beads" <> $SessionUUID],
		Object[Container,Vessel,functionName<>" test discarded 2mL tube" <> $SessionUUID],
		Object[Container,Vessel,functionName<>" test solid 2mL tube" <> $SessionUUID],
		Object[Container,Vessel,functionName<>" test 14mL falcon tube" <> $SessionUUID],
		(*molecules*)
		Table[Model[Molecule,Protein,functionName<>" test analyte "<>ToString[x]<> $SessionUUID],{x,2}],
		Table[Model[Molecule,Protein,functionName<>" test target "<>ToString[x]<> $SessionUUID],{x,2}],
		Model[Molecule, Oligomer,functionName <> " test analyte 3" <> $SessionUUID],
		(*samples*)
		Table[Object[Sample,functionName<>" test 96-well plate sample "<>ToString[x]<> $SessionUUID],{x,4}],
		Table[Object[Sample,functionName<>" test 2mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,3}],
		Table[Object[Sample,functionName<>" test 50mL tube "<>ToString[x]<>" sample"<> $SessionUUID],{x,4}],
		Object[Sample,functionName<>" test filled 2mL tube sample" <> $SessionUUID],
		Model[Sample,functionName<>" test Magnetic Bead sample model" <> $SessionUUID],
		Model[Resin,functionName<> "test Magnetic bead resin model" <> $SessionUUID],
		Object[Sample,functionName<>" test 2mL tube magnetic bead sample" <> $SessionUUID],
		Object[Sample,functionName<>" test discarded 2mL tube sample" <> $SessionUUID],
		Object[Sample,functionName<>" test solid 2mL tube sample" <> $SessionUUID],
		Object[Sample,functionName<>" test falcon tube sample" <> $SessionUUID],
		Object[Sample,functionName<>" test 2mL tube multiple target type sample" <> $SessionUUID],
		Object[Sample,functionName<>" test 2mL tube no analyte sample" <> $SessionUUID],


		(*protocols*)
		If[DatabaseMemberQ[#],Download[#,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]]&/@{Object[Protocol,MagneticBeadSeparation,functionName<>" template test protocol" <> $SessionUUID],Object[Protocol,MagneticBeadSeparation,functionName<>" name test protocol" <> $SessionUUID]}
	}],ObjectP[]];

	(*Check whether the created objects exist in the database*)
	existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

	(*Erase all the created objects*)
	Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
];


(* ::Subsection::Closed:: *)
(*ExperimentMagneticBeadSeparationOptions*)


DefineTests[ExperimentMagneticBeadSeparationOptions,
	{
		Example[{Basic,"Returns the options in table form given a sample:"},
			ExperimentMagneticBeadSeparationOptions[
				Object[Sample,"ExperimentMagneticBeadSeparationOptions test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat -> Table, returns the options in table form:"},
			ExperimentMagneticBeadSeparationOptions[
				Object[Sample,"ExperimentMagneticBeadSeparationOptions test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"],
				OutputFormat->Table
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			ExperimentMagneticBeadSeparationOptions[
				Object[Sample,"ExperimentMagneticBeadSeparationOptions test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"],
				OutputFormat->List
			],
			{_Rule..}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch = True,
		$AllowPublicObjects = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpSimpleMagneticBeadTestObjects["ExperimentMagneticBeadSeparationOptions"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownSimpleMagneticBeadTestObjects["ExperimentMagneticBeadSeparationOptions"]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentMagneticBeadSeparationPreview*)


DefineTests[ExperimentMagneticBeadSeparationPreview,
	{
		Example[{Basic,"No preview is currently available for the experiment:"},
			ExperimentMagneticBeadSeparationPreview[
				Object[Sample,"ExperimentMagneticBeadSeparationPreview test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
			],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentMagneticBeadSeparationOptions:"},
			ExperimentMagneticBeadSeparationOptions[
				Object[Sample,"ExperimentMagneticBeadSeparationPreview test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
			],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentMagneticBeadSeparationQ:"},
			ValidExperimentMagneticBeadSeparationQ[
				Object[Sample,"ExperimentMagneticBeadSeparationPreview test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
			],
			True
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch = True,
		$AllowPublicObjects = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpSimpleMagneticBeadTestObjects["ExperimentMagneticBeadSeparationPreview"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownSimpleMagneticBeadTestObjects["ExperimentMagneticBeadSeparationPreview"]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentMagneticBeadSeparationQ*)


DefineTests[ValidExperimentMagneticBeadSeparationQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a MBS experimental setup on a sample:"},
			ValidExperimentMagneticBeadSeparationQ[
				Object[Sample,"ValidExperimentMagneticBeadSeparationQ test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
			],
			True
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentMagneticBeadSeparationQ[
				Object[Sample,"ValidExperimentMagneticBeadSeparationQ test 2mL tube 1 sample"<> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentMagneticBeadSeparationQ[
				Object[Sample,"ValidExperimentMagneticBeadSeparationQ test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperSearch = True,
		$AllowPublicObjects = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpSimpleMagneticBeadTestObjects["ValidExperimentMagneticBeadSeparationQ"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownSimpleMagneticBeadTestObjects["ValidExperimentMagneticBeadSeparationQ"]
	)
];
(* ::Subsection::Closed:: *)
(*MagneticBeadSeparation*)
DefineTests[MagneticBeadSeparation,
	{
		Example[{Basic,"Generate a MagneticBeadSeparation unit operation from a sample:"},
		    MagneticBeadSeparation[
					Sample -> Object[Sample,"MagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
					MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"]
				],
		    _MagneticBeadSeparation
		],
		Example[{Basic,"Generate a MagneticBeadSeparation unit operation from a sample and prewash options:"},
			MagneticBeadSeparation[
				Sample -> Object[Sample,"MagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				MagneticBeads-> Model[Sample, "Dynabeads MyOne SILANE Sample"],
				PreWash->True,
				PreWashMix->True,
				SelectionStrategy->Negative
			],
			_MagneticBeadSeparation
		],
		Example[{Basic,"Generate a MagneticBeadSeparation unit operation from a sample and affinity options:"},
			MagneticBeadSeparation[
				Sample -> Object[Sample,"MagneticBeadSeparation test 2mL tube 1 sample" <> $SessionUUID],
				SeparationMode->Affinity
			],
			_MagneticBeadSeparation
		]
	},
	Stubs:>{
		$DeveloperSearch = True,
		$AllowPublicObjects = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpSimpleMagneticBeadTestObjects["MagneticBeadSeparation"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownSimpleMagneticBeadTestObjects["MagneticBeadSeparation"]
	)
]
