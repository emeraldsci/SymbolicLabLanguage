(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentWestern: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*ExperimentWestern*)

DefineTests[
	ExperimentWestern,
	{
		(* Basic Examples *)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			ObjectP[Object[Protocol,Western]]
		],
		Example[{Basic,"Accepts a non-empty container as the primary input:"},
			ExperimentWestern[Object[Container,Vessel,"Test 2mL Tube 1 containing lysate sample for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			ObjectP[Object[Protocol,Western]]
		],
		Example[{Basic,"The secondary input can be an Object or a Model:"},
			Lookup[ExperimentWestern[{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},
				{Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Model[Sample, "Simple Western Rabbit-AntiERK-1"]},Output->Options],
				MolecularWeightRange
			],
			MidMolecularWeight
		],
		Test["Expand the antibody to match the length of the input sample:",
			Length[
				Download[
					ExperimentWestern[
						{
							Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
							Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]
						},
						Model[Sample, "Simple Western Rabbit-AntiERK-1"]
					],
					PrimaryAntibodies
				]
			],
			2
		],
		(* Additional *)
		Example[{Additional,"Specify the Aliquot options to dilute an input sample with Model[Sample,StockSolution,\"Simple Western 0.1X Sample Buffer\"]:"},
			ExperimentWestern[
				{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},
				{Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID]},
				Aliquot->{True,False},AliquotAmount->{20*Microliter,Automatic},AssayVolume->{100*Microliter,Automatic},AssayBuffer -> {Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],Automatic}
			],
			ObjectP[Object[Protocol,Western]]
		],
		Example[{Additional,"Accepts a Model-less sample:"},
			ExperimentWestern[Object[Sample,"Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			ObjectP[Object[Protocol, Western]]
		],
		(* Error Messages before option resolution *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentWestern[Object[Sample, "Nonexistent sample"],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an antibody that does not exist (name form):"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Model[Sample, "Nonexistent antibody"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentWestern[Object[Container, Vessel, "Nonexistent container"],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentWestern[Object[Sample, "id:12345678"],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an antibody that does not exist (ID form):"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample, "id:123456678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentWestern[Object[Container, Vessel, "id:12345678"],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
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
					Model[Sample, "id:WNa4ZjKMrPeD"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				Quiet[ExperimentWestern[sampleID,Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Simulation -> simulationToPassIn, Output -> Options],{Warning::WesTotalProteinConcentrationNotInformed}]
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
					Model[Sample, "id:WNa4ZjKMrPeD"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				Quiet[ExperimentWestern[containerID,Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Simulation -> simulationToPassIn, Output -> Options],{Warning::WesTotalProteinConcentrationNotInformed}]
			],
			{__Rule}
		],
		Example[{Messages,"DiscardedSamples","The input sample cannot have a Status of Discarded:"},
			ExperimentWestern[Object[Sample,"Test discarded lysate sample for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSamples","The input antibody cannot have a Status of Discarded:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test discarded Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"TooManyInputsForWes","A maximum of 24 input samples can be run in one protocol:"},
			ExperimentWestern[{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},{Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]}],
			$Failed,
			Messages:>{
				Error::TooManyInputsForWes,
				Error::InvalidInput
			}
		],
		Example[{Messages,"WesTotalProteinConcentrationNotInformed","Lysate sample inputs should have TotalProteinConcentration informed:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Output->Options],SystemStandard],
			False,
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Messages,"NumberOfReplicatesTooHighForNumberOfWesInputSamples","The number of input samples times the NumberOfReplicates cannot be larger than 24:"},
			ExperimentWestern[{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},{Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]},NumberOfReplicates->13],
			$Failed,
			Messages:>{
				Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesOptionVolumeTooLow","The  PrimaryAntibodyDiluentVolume and StandardPrimaryAntibodyVolume options cannot be larger than 0 uL but smaller than 1 uL. The StandardSecondaryAntibodyVolume option cannot be larger tha 0 uL but smaller than 0.5 uL:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDiluentVolume->38*Microliter,SystemStandard->True,StandardPrimaryAntibodyVolume->0.4*Microliter
			],
			$Failed,
			Messages:>{
				Error::WesOptionVolumeTooLow,
				Warning::WesternStandardPrimaryAntibodyVolumeRatioNonIdeal,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingWesDenaturingOptions","The Denaturing, DenaturingTemperature, and DenaturingTime options must not conflict:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->True,DenaturingTemperature->Null],
			$Failed,
			Messages:>{
				Error::ConflictingWesDenaturingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingWesSystemStandardOptions","The SystemStandard-related options must not be in conflict:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SystemStandard->False,StandardSecondaryAntibodyVolume->0.5*Microliter],
			$Failed,
			Messages:>{
				Error::ConflictingWesSystemStandardOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingWesNullOptions","For the following option pairs, PrimaryAntibodyDiluent/PrimaryAntibodyDiluentVolume and StandardSecondaryAntibody/StandardSecondaryAntibodyVolume, one option cannot be Null if its partner is set to anything other than Null or Automatic:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDiluent->Null,PrimaryAntibodyDiluentVolume->10*Microliter],
			$Failed,
			Messages:>{
				Error::ConflictingWesNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesternLoadingVolumeTooLarge","For each input, the LoadingVolume must be smaller than the sum of the SampleVolume and the LoadingBufferVolume:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SampleVolume->7*Microliter,LoadingBufferVolume->1*Microliter,LoadingVolume->9*Microliter
			],
			$Failed,
			Messages:>{
				Error::WesternLoadingVolumeTooLarge,
				Error::InvalidOption
			}
		],
		(* Messages during option resolution *)
		Example[{Messages,"WesHighDynamicRangeImagingNotPossible","The supplied SignalDetectionTimes need to be the default values for High Dynamic Range (HDR) image processing to occur:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SignalDetectionTimes->{1,2,3,4,5,6,7,8,9}*Second,MolecularWeightRange->MidMolecularWeight,Output->Options],
				MolecularWeightRange
			],
			MidMolecularWeight,
			Messages:>{
				Warning::WesHighDynamicRangeImagingNotPossible
			}
		],
		Example[{Messages,"NonOptimalUserSuppliedWesMolecularWeightRange","The MolecularWeightRange should be optimal for the average ExpectedMolecularWeight of the input antibodies:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				MolecularWeightRange->LowMolecularWeight,Output->Options],
				MolecularWeightRange
			],
			LowMolecularWeight,
			Messages:>{
				Warning::NonOptimalUserSuppliedWesMolecularWeightRange
			}
		],
		Example[{Messages,"WesLadderNotOptimalForMolecularWeightRange","The supplied Ladder should be the default Ladder for the MolecularWeightRange:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Ladder->Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"],MolecularWeightRange->MidMolecularWeight,Output->Options],
				MolecularWeightRange
			],
			MidMolecularWeight,
			Messages:>{
				Warning::WesLadderNotOptimalForMolecularWeightRange
			}
		],
		Example[{Messages,"WesWashBufferNotOptimal","The supplied WashBuffer should be the default WashBuffer:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				WashBuffer->Model[Sample,"Simple Western Milk-Free Antibody Diluent"],Output->Options],
				WashBuffer
			],
			ObjectReferenceP[Model[Sample,"Simple Western Milk-Free Antibody Diluent"]],
			Messages:>{
				Warning::WesWashBufferNotOptimal
			}
		],
		Example[{Messages,"WesConcentratedLoadingBufferNotOptimal","The supplied ConcentratedLoadingBuffer should be the default ConcentratedLoadingBuffer for the MolecularWeightRange:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"],MolecularWeightRange->MidMolecularWeight,Output->Options],
				ConcentratedLoadingBuffer
			],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Messages:>{
				Warning::WesConcentratedLoadingBufferNotOptimal
			}
		],
		Example[{Messages,"NotEnoughWesLoadingBuffer","The sum of the ConcentratedLoadingBufferVolume and DenaturantVolume or WaterVolume options should be larger than the LoadingBuffer required for the experiment (all 24 potential sample capillaries):"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				ConcentratedLoadingBufferVolume->10*Microliter,DenaturantVolume->10*Microliter,LoadingBufferVolume->2*Microliter],
			$Failed,
			Messages:>{
				Error::NotEnoughWesLoadingBuffer,
				Error::InvalidOption
			}
		],
		(* Messages after option resolution *)
		Example[{Messages,"NonIdealWesternSecondaryAntibody","The SecondaryAntibody should detect the Organism of the input PrimaryAntibody:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SecondaryAntibody->Model[Sample,"Simple Western Goat-AntiMouse-HRP"],Output->Options],
				SecondaryAntibody
			],
			ObjectReferenceP[Model[Sample,"Simple Western Goat-AntiMouse-HRP"]],
			Messages:>{
				Warning::NonIdealWesternSecondaryAntibody
			}
		],
		Example[{Messages,"NonIdealWesternStandardPrimaryAntibody","If SystemStandard is set to True, the StandardPrimaryAntibody should be derived from a Mouse if the PrimaryAntibody is derived from a Mouse, or derived from a Rabbit if otherwise:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SystemStandard->True,StandardPrimaryAntibody->Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"],Output->Options],
				StandardPrimaryAntibody
			],
			ObjectReferenceP[Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"]],
			Messages:>{
				Warning::NonIdealWesternStandardPrimaryAntibody,
				Warning::NonIdealWesternStandardSecondaryAntibody
			}
		],
		Example[{Messages,"NonIdealWesternStandardSecondaryAntibody","If SystemStandard is set to True, the StandardSecondaryAntibody should only be set if the PrimaryAntibody is not derived from a Mouse or a Rabbit:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SystemStandard->True,StandardSecondaryAntibody->Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],Output->Options],
				StandardSecondaryAntibody
			],
			ObjectReferenceP[Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"]],
			Messages:>{
				Warning::NonIdealWesternStandardSecondaryAntibody
			}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentWestern[
				Link[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Now],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,Western]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages,"NonIdealWesternBlockingBuffer","Model[Sample,\"Simple Western Antibody Diluent 2\"] is the default BlockingBuffer for all PrimaryAntibodies except those derived from a Goat:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				BlockingBuffer->Model[Sample,"Simple Western Milk-Free Antibody Diluent"],Output->Options],
				BlockingBuffer
			],
			ObjectReferenceP[Model[Sample,"Simple Western Milk-Free Antibody Diluent"]],
			Messages:>{
				Warning::NonIdealWesternBlockingBuffer
			}
		],
		Example[{Messages,"NonIdealWesternPrimaryAntibodyDiluent","Model[Sample,\"Simple Western Antibody Diluent 2\"] is the default PrimaryAntibodyDiluent for all PrimaryAntibodies except those derived from a Goat:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDiluent->Model[Sample,"Simple Western Milk-Free Antibody Diluent"],Output->Options],
				PrimaryAntibodyDiluent
			],
			ObjectReferenceP[Model[Sample,"Simple Western Milk-Free Antibody Diluent"]],
			Messages:>{
				Warning::NonIdealWesternPrimaryAntibodyDiluent
			}
		],
		Example[{Messages,"WesternPrimaryAntibodyVolumeLarge","If any members of PrimaryAntibodyVolume corresponding to PrimaryAntibodies that are being diluted are 4 uL or larger, a warning will be thrown with suggestions on how to conserve PrimaryAntibody:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDilutionFactor->0.2,Output->Options
				],
				PrimaryAntibodyVolume
			],
			40.0*Microliter,
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"InvalidWesternDilutedPrimaryAntibodyVolume","The sub of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume options must be between 35 and 200 uL:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->20*Microliter
			],
			$Failed,
			Messages:>{
				Error::InvalidWesternDilutedPrimaryAntibodyVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesternSecondaryAntibodyVolumeLow","When SystemStandard is set to True, the sum of the SecondaryAntibodyVolume and the StandardSecondaryAntibodyVolume should be at least 10 uL:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SystemStandard->True,SecondaryAntibodyVolume->8*Microliter,StandardSecondaryAntibodyVolume->1*Microliter,Output->Options],
				SecondaryAntibodyVolume
			],
			8*Microliter,
			Messages:>{
				Warning::WesternSecondaryAntibodyVolumeLow
			}
		],
		Example[{Messages,"WesternStandardPrimaryAntibodyVolumeRatioNonIdeal","When SystemStandard is set to true, the StandardPrimaryAntibodyVolume should be 10% of the sum of the PrimaryAntibodyVolume, the PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume:"},
			Lookup[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SystemStandard->True,PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->96*Microliter,StandardPrimaryAntibodyVolume->3*Microliter,Output->Options],
				StandardPrimaryAntibodyVolume
			],
			3*Microliter,
			Messages:>{
				Warning::WesternStandardPrimaryAntibodyVolumeRatioNonIdeal
			}
		],
		Example[{Messages,"ConflictingWesternPrimaryAntibodyDilutionFactorOptions","If the PrimaryAntibodyDilutionFactor is set, it should match the ratio of the PrimaryAntibodyVolume to the sum of the PrimaryAntibodyVolume and the PrimaryAntibodyDiluentVolume:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDilutionFactor->0.1,PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->40*Microliter],
			$Failed,
			Messages:>{
				Error::ConflictingWesternPrimaryAntibodyDilutionFactorOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesInputsShouldBeDiluted","If a lysate input sample has a TotalProteinConcentration greater than 3 mg/mL, it should be diluted with Model[Sample,StockSolution,\"Simple Western 0.1X Sample Buffer\"] using the sample preparation aliquot options:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			1,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::WesInputsShouldBeDiluted
			}
		],
		Example[{Messages,"DuplicateName","If the Name option is specified, it cannot be identical to an existing Object[Protocol,Western] Name:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Name->"LegacyID:58"],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesConflictingStandardPrimaryAntibodyStorageOptions","If the StandardPrimaryAntibodyStorageCondition option is specified, the corresponding StandardPrimaryAntibody cannot be Null:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				StandardPrimaryAntibody->Null,
				StandardPrimaryAntibodyStorageCondition->AmbientStorage
			],
			$Failed,
			Messages:>{
				Error::WesConflictingStandardPrimaryAntibodyStorageOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"WesConflictingStandardSecondaryAntibodyStorageOptions","If the StandardSecondaryAntibodyStorageCondition option is specified, the corresponding StandardSecondaryAntibody cannot be Null:"},
			ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				StandardSecondaryAntibody->Null,
				StandardSecondaryAntibodyStorageCondition->AmbientStorage
			],
			$Failed,
			Messages:>{
				Error::WesConflictingStandardSecondaryAntibodyStorageOptions,
				Error::InvalidOption
			}
		],
		(* -- Option Unit Tests -- *)
		(* - Option Precision Tests - *)
		Example[{Options,DenaturingTemperature,"Rounds specified DenaturingTemperature to the nearest 1 Celsius:"},
			roundedDenaturingTemperatureOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				DenaturingTemperature->94.9*Celsius,Output->Options];
			Lookup[roundedDenaturingTemperatureOptions,DenaturingTemperature],
			95.0*Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,DenaturingTime,"Rounds specified DenaturingTime to the nearest 1 Second:"},
			roundedDenaturingTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				DenaturingTime->299.7*Second,Output->Options];
			Lookup[roundedDenaturingTimeOptions,DenaturingTime],
			300.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SeparatingMatrixLoadTime,"Rounds specified SeparatingMatrixLoadTime to the nearest 0.1 Second:"},
			roundedSeparatingMatrixLoadTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SeparatingMatrixLoadTime->200.01*Second,Output->Options];
			Lookup[roundedSeparatingMatrixLoadTimeOptions,SeparatingMatrixLoadTime],
			200.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,StackingMatrixLoadTime,"Rounds specified StackingMatrixLoadTime to the nearest 0.1 Second:"},
			roundedStackingMatrixLoadTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				StackingMatrixLoadTime->12.02*Second,Output->Options];
			Lookup[roundedStackingMatrixLoadTimeOptions,StackingMatrixLoadTime],
			12.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SampleVolume,"Rounds specified SampleVolume to the nearest 0.1 Microliter:"},
			roundedSampleVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SampleVolume->7.98*Microliter,Output->Options];
			Lookup[roundedSampleVolumeOptions,SampleVolume],
			8.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,ConcentratedLoadingBufferVolume,"Rounds specified ConcentratedLoadingBufferVolume to the nearest 0.1 Microliter:"},
			roundedConcentratedLoadingBufferVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				ConcentratedLoadingBufferVolume->39.99*Microliter,Output->Options];
			Lookup[roundedConcentratedLoadingBufferVolumeOptions,ConcentratedLoadingBufferVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,DenaturantVolume,"Rounds specified DenaturantVolume to the nearest 0.1 Microliter:"},
			roundedConcentratedDenaturantVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				DenaturantVolume->39.99*Microliter,Output->Options];
			Lookup[roundedConcentratedDenaturantVolumeOptions,DenaturantVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,WaterVolume,"Rounds specified WaterVolume to the nearest 0.1 Microliter:"},
			roundedWaterVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Denaturing->False,WaterVolume->39.99*Microliter,Output->Options];
			Lookup[roundedWaterVolumeOptions,WaterVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LoadingBufferVolume,"Rounds specified LoadingBufferVolume to the nearest 0.1 Microliter:"},
			roundedLoadingBufferVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				LoadingBufferVolume->1.98*Microliter,Output->Options];
			Lookup[roundedLoadingBufferVolumeOptions,LoadingBufferVolume],
			2.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LoadingVolume,"Rounds specified LoadingVolume to the nearest 0.1 Microliter:"},
			roundedLoadingVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Denaturing->False,LoadingVolume->5.97*Microliter,Output->Options];
			Lookup[roundedLoadingVolumeOptions,LoadingVolume],
			6.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LadderVolume,"Rounds specified LadderVolume to the nearest 0.1 Microliter:"},
			roundedLadderVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Denaturing->False,LadderVolume->5.01*Microliter,Output->Options];
			Lookup[roundedLadderVolumeOptions,LadderVolume],
			5.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SampleLoadTime,"Rounds specified SampleLoadTime to the nearest 0.1 Second:"},
			roundedSampleLoadTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SampleLoadTime->8.99*Second,Output->Options];
			Lookup[roundedSampleLoadTimeOptions,SampleLoadTime],
			9.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SeparationTime,"Rounds specified SeparationTime to the nearest 0.1 Second:"},
			roundedSeparationTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SeparationTime->1500.01*Second,Output->Options];
			Lookup[roundedSeparationTimeOptions,SeparationTime],
			1500.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,UVExposureTime,"Rounds specified UVExposureTime to the nearest 0.1 Second:"},
			roundedUVExposureTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				UVExposureTime->199.98*Second,Output->Options];
			Lookup[roundedUVExposureTimeOptions,UVExposureTime],
			200.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,WashBufferVolume,"Rounds specified WashBufferVolume to the nearest 0.1 Microliter:"},
			roundedWashBufferVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				WashBufferVolume->499.96*Microliter,Output->Options];
			Lookup[roundedWashBufferVolumeOptions,WashBufferVolume],
			500.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LuminescenceReagentVolume,"Rounds specified LuminescenceReagentVolume to the nearest 0.1 Microliter:"},
			roundedLuminescenceReagentVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				LuminescenceReagentVolume->14.99*Microliter,Output->Options];
			Lookup[roundedLuminescenceReagentVolumeOptions,LuminescenceReagentVolume],
			15.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SignalDetectionTimes,"Rounds specified SignalDetectionTimes to the nearest 0.1 Second:"},
			roundedSignalDetectionTimesOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SignalDetectionTimes->{1*Second,2*Second,4*Second,8*Second,16*Second,32.02*Second,64*Second,128*Second,512*Second},Output->Options];
			Lookup[roundedSignalDetectionTimesOptions,SignalDetectionTimes],
			{1*Second,2*Second,4*Second,8*Second,16*Second,32*Second,64*Second,128*Second,512*Second},
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,BlockingBufferVolume,"Rounds specified BlockingBufferVolume to the nearest 0.1 Microliter:"},
			roundedBlockingBufferVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				BlockingBufferVolume->9.97*Microliter,Output->Options];
			Lookup[roundedBlockingBufferVolumeOptions,BlockingBufferVolume],
			10.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,BlockingTime,"Rounds specified BlockingTime to the nearest 0.1 Second:"},
			roundedBlockingTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				BlockingTime->1800.01*Second,Output->Options];
			Lookup[roundedBlockingTimeOptions,BlockingTime],
			1800.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrimaryAntibodyVolume,"Rounds specified PrimaryAntibodyVolume to the nearest 0.1 Microliter:"},
			roundedPrimaryAntibodyVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyVolume->34.98*Microliter,Output->Options];
			Lookup[roundedPrimaryAntibodyVolumeOptions,PrimaryAntibodyVolume],
			35.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"Rounds specified PrimaryAntibodyDilutionFactor to the nearest 0.00001:"},
			roundedPrimaryAntibodyDilutionFactorOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDilutionFactor->0.0121,Output->Options];
			Lookup[roundedPrimaryAntibodyDilutionFactorOptions,PrimaryAntibodyDilutionFactor],
			0.012,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrimaryAntibodyDiluentVolume,"Rounds specified PrimaryAntibodyDiluentVolume to the nearest 0.1 Microliter:"},
			roundedPrimaryAntibodyDiluentVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyDiluentVolume->39.97*Microliter,Output->Options];
			Lookup[roundedPrimaryAntibodyDiluentVolumeOptions,PrimaryAntibodyDiluentVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,StandardPrimaryAntibodyVolume,"Rounds specified StandardPrimaryAntibodyVolume to the nearest 0.1 Microliter:"},
			roundedStandardPrimaryAntibodyVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				StandardPrimaryAntibodyVolume->3.99*Microliter,SystemStandard->True,Output->Options];
			Lookup[roundedStandardPrimaryAntibodyVolumeOptions,StandardPrimaryAntibodyVolume],
			4*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrimaryAntibodyLoadingVolume,"Rounds specified PrimaryAntibodyLoadingVolume to the nearest 0.1 Microliter:"},
			roundedPrimaryAntibodyLoadingVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryAntibodyLoadingVolume->9.98*Microliter,Output->Options];
			Lookup[roundedPrimaryAntibodyLoadingVolumeOptions,PrimaryAntibodyLoadingVolume],
			10.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrimaryIncubationTime,"Rounds specified PrimaryIncubationTime to the nearest 0.1 Second:"},
			roundedPrimaryIncubationTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				PrimaryIncubationTime->1800.01*Second,Output->Options];
			Lookup[roundedPrimaryIncubationTimeOptions,PrimaryIncubationTime],
			1800.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SecondaryAntibodyVolume,"Rounds specified SecondaryAntibodyVolume to the nearest 0.1 Microliter:"},
			roundedSecondaryAntibodyVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SecondaryAntibodyVolume->9.98*Microliter,Output->Options];
			Lookup[roundedSecondaryAntibodyVolumeOptions,SecondaryAntibodyVolume],
			10.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,StandardSecondaryAntibodyVolume,"Rounds specified StandardSecondaryAntibodyVolume to the nearest 0.1 Microliter:"},
			roundedStandardSecondaryAntibodyVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				StandardSecondaryAntibodyVolume->0.97*Microliter,SystemStandard->True,Output->Options];
			Lookup[roundedStandardSecondaryAntibodyVolumeOptions,StandardSecondaryAntibodyVolume],
			1*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SecondaryIncubationTime,"Rounds specified SecondaryIncubationTime to the nearest 0.1 Second:"},
			roundedSecondaryIncubationTimeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				SecondaryIncubationTime->1800.01*Second,Output->Options];
			Lookup[roundedSecondaryIncubationTimeOptions,SecondaryIncubationTime],
			1800.0*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LadderPeroxidaseReagentVolume,"Rounds specified LadderPeroxidaseReagentVolume to the nearest 0.1 Microliter:"},
			roundedLadderPeroxidaseReagentVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				LadderPeroxidaseReagentVolume->9.98*Microliter,Output->Options];
			Lookup[roundedLadderPeroxidaseReagentVolumeOptions,LadderPeroxidaseReagentVolume],
			10.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LadderBlockingBufferVolume,"Rounds specified LadderBlockingBufferVolume to the nearest 0.1 Microliter:"},
			roundedLadderBlockingBufferVolumeOptions=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				LadderPeroxidaseReagentVolume->9.98*Microliter,Output->Options];
			Lookup[roundedLadderBlockingBufferVolumeOptions,LadderBlockingBufferVolume],
			10.0*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(* - Options with Defaults Tests - *)
		Example[{Options,Instrument,"The Instrument option defaults to Model[Instrument,Western,\"Wes\"]:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument,Western,"Wes"]],
			Variables :> {options}
		],
		Example[{Options,Instrument,"The function accepts an appropriate Instrument Object:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Instrument->Object[Instrument,Western,"Test Wes Instrument for ExperimentWestern Tests"<>$SessionUUID],Output->Options];
			Lookup[options,Instrument],
			ObjectReferenceP[Object[Instrument,Western,"Test Wes Instrument for ExperimentWestern Tests"<>$SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,NumberOfReplicates,"The product of the NumberOfReplicates and the number of input samples cannot be greater than 24:"},
			ExperimentWestern[{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},{Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID]},NumberOfReplicates->19],
			$Failed,
			Messages:>{
				Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples,
				Error::InvalidOption
			}
		],
		Example[{Options,WashBuffer,"The WashBuffer option defaults to Model[Sample,\"Simple Western Wash Buffer\"]:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,WashBuffer],
			ObjectReferenceP[Model[Sample,"Simple Western Wash Buffer"]],
			Variables :> {options}
		],
		Example[{Options,LadderBlockingBuffer,"The LadderBlockingBuffer option defaults to Model[Sample,\"Simple Western Antibody Diluent 2\"]:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,LadderBlockingBuffer],
			ObjectReferenceP[Model[Sample,"Simple Western Antibody Diluent 2"]],
			Variables :> {options}
		],
		Example[{Options,SystemStandard,"The SystemStandard option defaults False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,SystemStandard],
			False,
			Variables :> {options}
		],
		Example[{Options,LadderPeroxidaseReagent,"The LadderPeroxidaseReagent option defaults Model[Sample,\"Simple Western Streptavidin-HRP\"]:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,LadderPeroxidaseReagent],
			ObjectReferenceP[Model[Sample,"Simple Western Streptavidin-HRP"]],
			Variables :> {options}
		],
		Example[{Options,LadderPeroxidaseReagentStorageCondition,"The LadderPeroxidaseReagentStorageCondition option is used to set the StorageCondition of the LadderPeroxidaseReagent after it is used in the experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				LadderPeroxidaseReagentStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options,LadderPeroxidaseReagentStorageCondition],
			AmbientStorage,
			Variables :> {options}
		],
		Example[{Options,LuminescenceReagent,"The LuminescenceReagent option defaults Model[Sample,StockSolution,\"SimpleWestern Luminescence Reagent\"]:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,LuminescenceReagent],
			ObjectReferenceP[Model[Sample,StockSolution,"SimpleWestern Luminescence Reagent"]],
			Variables :> {options}
		],
		(* - Option Resolution Tests - *)
		Example[{Options,MolecularWeightRange,"When MolecularWeightRange->Automatic, the option resolves based on the average MolecularWeight of the Targets of the Model[Molecule,Protein,Antibody]s present in the Composition field of the input PrimaryAntibodies:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,MolecularWeightRange],
			MidMolecularWeight,
			Variables :> {options}
		],
		Example[{Options,Denaturing,"When Denaturing->Automatic, the option resolves to True unless either DenaturingTemperature or DenaturingTime is set to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,Denaturing],
			True,
			Variables :> {options}
		],
		Example[{Options,Denaturing,"When Denaturing->Automatic, the option resolves to False if either DenaturingTemperature or DenaturingTime is set to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],DenaturingTime->Null,Output->Options];
			Lookup[options,Denaturing],
			False,
			Variables :> {options}
		],
		Example[{Options,Denaturing,"When Denaturing->Automatic, the option resolves to False if either DenaturingTemperature or DenaturingTime is set to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturant->Null,Output->Options];
			Lookup[options,Denaturing],
			False,
			Variables :> {options}
		],
		Example[{Options,DenaturingTemperature,"When DenaturingTemperature->Automatic, the option resolves to Null if Denaturing is False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->False,Output->Options];
			Lookup[options,DenaturingTemperature],
			Null,
			Variables :> {options}
		],
		Example[{Options,DenaturingTemperature,"When DenaturingTemperature->Automatic, the option resolves to 95 Celsius if Denaturing is True:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->True,Output->Options];
			Lookup[options,DenaturingTemperature],
			95*Celsius,
			Variables :> {options}
		],
		Example[{Options,DenaturingTime,"When DenaturingTime->Automatic, the option resolves to Null if Denaturing is False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->False,Output->Options];
			Lookup[options,DenaturingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,DenaturingTime,"When DenaturingTime->Automatic, the option resolves to 5 minutes if Denaturing is True:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->True,Output->Options];
			Lookup[options,DenaturingTime],
			5*Minute,
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"],Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 180 kDa System Control - EZ Standard Pack 2"],Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 2"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"],Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 200 kDa System Control - EZ Standard Pack 4"],Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 4"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"] ,Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],MolecularWeightRange->LowMolecularWeight,Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options,Ladder,"When Ladder->Automatic, the option resolves based on the MolecularWeightRange option if the ConcentratedLoadingBuffer is left as Automatic or is not one of the standard loading buffers:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,Ladder],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options,StackingMatrixLoadTime,"When StackingMatrixLoadTime->Automatic, the option resolves to 15 seconds when the MolecularWeightRange is set to MidMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,StackingMatrixLoadTime],
			15*Second,
			Variables :> {options}
		],
		Example[{Options,StackingMatrixLoadTime,"When StackingMatrixLoadTime->Automatic, the option resolves to 12 seconds when the MolecularWeightRange is set to anything other than MidMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],MolecularWeightRange->LowMolecularWeight,Output->Options];
			Lookup[options,StackingMatrixLoadTime],
			12*Second,
			Variables :> {options}
		],
		Example[{Options,SampleLoadTime,"When SampleLoadTime->Automatic, the option resolves to 8 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,SampleLoadTime],
			8*Second,
			Variables :> {options}
		],
		Example[{Options,SampleLoadTime,"When SampleLoadTime->Automatic, the option resolves to 9 seconds when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,SampleLoadTime],
			9*Second,
			Variables :> {options}
		],
		Example[{Options,Voltage,"When Voltage->Automatic, the option resolves to 475 volts when the MolecularWeightRange is set to HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,Voltage],
			475*Volt,
			Variables :> {options}
		],
		Example[{Options,Voltage,"When Voltage->Automatic, the option resolves to 375 volts when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,Voltage],
			375*Volt,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"When SeparationTime->Automatic, the option resolves to 1,800 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,SeparationTime],
			1800*Second,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"When SeparationTime->Automatic, the option resolves to 1,500 seconds when the MolecularWeightRange is set to MidMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,SeparationTime],
			1500*Second,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"When SeparationTime->Automatic, the option resolves to 1,620 seconds when the MolecularWeightRange is set to LowMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],MolecularWeightRange->LowMolecularWeight,Output->Options];
			Lookup[options,SeparationTime],
			1620*Second,
			Variables :> {options}
		],
		Example[{Options,UVExposureTime,"When UVExposureTime->Automatic, the option resolves to 150 seconds when the MolecularWeightRange is set to HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,UVExposureTime],
			150*Second,
			Variables :> {options}
		],
		Example[{Options,UVExposureTime,"When UVExposureTime->Automatic, the option resolves to 200 seconds when the MolecularWeightRange is set to anything other than HighMolecularWeight:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,UVExposureTime],
			200*Second,
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Ladder->Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"],Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Ladder->Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"],Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the Ladder:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],Ladder->Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"],Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],MolecularWeightRange->LowMolecularWeight,Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],MolecularWeightRange->MidMolecularWeight,Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedLoadingBuffer,"When ConcentratedLoadingBuffer->Automatic, the option resolves based on the MolecularWeightRange option if the Ladder option is left as Automatic or is not one of the standard ladders:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,ConcentratedLoadingBuffer],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options,Denaturant,"When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->True,ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"],Output->Options];
			Lookup[options,Denaturant],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 1"]],
			Variables :> {options}
		],
		Example[{Options,Denaturant,"When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the ConcentratedLoadingBuffer:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Denaturing->True,ConcentratedLoadingBuffer->Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 200 kDa System Control - EZ Standard Pack 4"],Output->Options];
			Lookup[options,Denaturant],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 4"]],
			Variables :> {options}
		],
		Example[{Options,Denaturant,"When Denaturant->Automatic, and Denaturaing is set to or has resolved to True, the option resolves based on the MolecularWeightRange if the ConcentratedLoadingBuffer is left as Automatic:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Denaturing->True,ConcentratedLoadingBuffer->Automatic,MolecularWeightRange->HighMolecularWeight,Output->Options];
			Lookup[options,Denaturant],
			ObjectReferenceP[Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 3"]],
			Variables :> {options}
		],
		Example[{Options,Denaturant,"When Denaturant->Automatic, the option resolves to Null if Denaturing is set to False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->False,Output->Options];
			Lookup[options,Denaturant],
			Null,
			Variables :> {options}
		],
		Example[{Options,DenaturantVolume,"When DenaturantVolume->Automatic, the option resolves to 40 uL when the Denaturant is not Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturant->Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 1"],NumberOfReplicates->14,Output->Options];
			Lookup[options,DenaturantVolume],
			40*Microliter,
			Variables :> {options}
		],
		Example[{Options,DenaturantVolume,"When DenaturantVolume->Automatic, the option resolves to Null when the Denaturant is set to or has resolved to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturant->Null,Output->Options];
			Lookup[options,DenaturantVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,WaterVolume,"When WaterVolume->Automatic, the option resolves to 20 uL when Denaturing is set to False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->False,Output->Options];
			Lookup[options,WaterVolume],
			40*Microliter,
			Variables :> {options}
		],
		Example[{Options,WaterVolume,"When WaterVolume->Automatic, the option resolves to Null when Denaturing is set to True:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Denaturing->True,Output->Options];
			Lookup[options,WaterVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option resolves based on the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Goat-AntiRabbit-HRP"]],
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option resolves based on the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Donkey-AntiGoat-HRP"]],
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option resolves based on the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Goat-AntiMouse-HRP"]],
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option resolves based on the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Goat-AntiHuman-IgG-HRP"]],
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option will resolve to Model[Sample,\"Simple Western Antibody Diluent 2\"] if the Organism of the PrimaryAntibody input is anything other than Rabbit, Mouse, Human, or Goat. If this is not desired, set the SecondaryAntibody option:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Antibody Diluent 2"]],
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,SecondaryAntibody,"When SecondaryAntibody->Automatic, the option will resolve to Model[Sample,\"Simple Western Antibody Diluent 2\"] if the PrimaryAntibody input is not of Model Model[Sample] (as a no primary antibody control, for example). If this is not desired, set the SecondaryAntibody option:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test antibody diluent 2 sample for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,SecondaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western Antibody Diluent 2"]],
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibody,"When StandardPrimaryAntibody->Automatic, the option resolves to Null if SystemStandard is set to False:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],SystemStandard->False,Output->Options];
			Lookup[options,StandardPrimaryAntibody],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibody,"When StandardPrimaryAntibody->Automatic and SystemStandard->True, the option resolves to Model[Sample,\"Simple Western 10X System Control Primary Antibody-Mouse\"] if the Organism of the input PrimaryAntibody is Mouse:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,Output->Options];
			Lookup[options,StandardPrimaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"]],
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibody,"When StandardPrimaryAntibody->Automatic and SystemStandard->True, the option resolves to Model[Sample,\"Simple Western 10X System Control Primary Antibody-Rabbit\"] if the Organism of the input PrimaryAntibody anything other than Mouse:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],SystemStandard->True,Output->Options];
			Lookup[options,StandardPrimaryAntibody],
			ObjectReferenceP[Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"]],
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,StandardPrimaryAntibodyStorageCondition,"The StandardPrimaryAntibodyStorageCondition option is used to set the StorageCondition of the StandardPrimaryAntibodies after they are used in the experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				SystemStandard->True,
				StandardPrimaryAntibody->Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"],
				StandardPrimaryAntibodyStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options,StandardPrimaryAntibodyStorageCondition],
			{AmbientStorage},
			Variables :> {options}
		],
		Example[{Options,StandardSecondaryAntibody,"When StandardSecondaryAntibody->Automatic and SystemStandard->False, the option resolves to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],SystemStandard->False,Output->Options];
			Lookup[options,StandardSecondaryAntibody],
			Null,
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,StandardSecondaryAntibody,"When StandardSecondaryAntibody->Automatic and SystemStandard->True, the option resolves to Null if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is either Rabbit or Mouse:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,Output->Options];
			Lookup[options,StandardSecondaryAntibody],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardSecondaryAntibody,"When StandardSecondaryAntibody->Automatic and SystemStandard->True, the option resolves to Model[Sample, \"Simple Western 20X Goat-AntiRabbit-HRP\"] if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is anything other than Rabbit or Mouse, so that the StandardSecondaryAntibody can detect the StandardPrimaryAntibody, whose Organism is Rabbit:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],SystemStandard->True,Output->Options];
			Lookup[options,{StandardSecondaryAntibody,StandardPrimaryAntibody}],
			{ObjectReferenceP[Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"]],ObjectReferenceP[Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"]]},
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,StandardSecondaryAntibodyStorageCondition,"The StandardSecondaryAntibodyStorageCondition option is used to set the StorageCondition of the StandardSecondaryAntibodies after they are used in the experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],
				SystemStandard->True,
				StandardSecondaryAntibody->Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],
				StandardSecondaryAntibodyStorageCondition->AmbientStorage,
				Output->Options];
			Lookup[options,StandardSecondaryAntibodyStorageCondition],
			{AmbientStorage},
			Variables :> {options},
			Messages:>{
				Warning::WesternPrimaryAntibodyVolumeLarge
			}
		],
		Example[{Options,BlockingBuffer,"When BlockingBuffer->Automatic, the option resolves to Model[Sample,\"Simple Western Milk-Free Antibody Diluent\"] if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is Goat:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,BlockingBuffer],
			ObjectReferenceP[Model[Sample,"Simple Western Milk-Free Antibody Diluent"]],
			Variables :> {options}
		],
		Example[{Options,BlockingBuffer,"When BlockingBuffer->Automatic, the option resolves to Model[Sample,\"Simple Western Antibody Diluent 2\"] if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is anything other than Goat:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,BlockingBuffer],
			ObjectReferenceP[Model[Sample,"Simple Western Antibody Diluent 2"]],
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibodyVolume,"When SecondaryAntibodyVolume->Automatic, the option resolves 10 uL if if the StandardSecondaryAntibody is set to or resolves to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],StandardSecondaryAntibody->Null,Output->Options];
			Lookup[options,SecondaryAntibodyVolume],
			10*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibodyVolume,"When SecondaryAntibodyVolume->Automatic and StandardSecondaryAntibodyVolume->Automatic, the option resolves 9.5 uL if the StandardSecondaryAntibody is set to or resolves to anything other than Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],SystemStandard->True,StandardSecondaryAntibody->Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],Output->Options];
			Lookup[options,SecondaryAntibodyVolume],
			9.5*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibodyVolume,"When SecondaryAntibodyVolume->Automatic and StandardSecondaryAntibodyVolume is set, the option resolves 19 times the StandardSecondaryAntibodyVolume if the StandardSecondaryAntibody is set to or resolves to anything other than Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],SystemStandard->True,StandardSecondaryAntibody->Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],StandardSecondaryAntibodyVolume->0.6*Microliter,Output->Options];
			Lookup[options,SecondaryAntibodyVolume],
			11.4*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,StandardSecondaryAntibodyVolume,"When StandardSecondaryAntibodyVolume->Automatic, the option resolves to Null if the StandardSecondaryAntibody is Null or has resolved to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],SystemStandard->False,Output->Options];
			Lookup[options,StandardSecondaryAntibodyVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardSecondaryAntibodyVolume,"When StandardSecondaryAntibodyVolume->Automatic, the option resolves to the SecondaryAntibodyVolume divided by 19 if the StandardSecondaryAntibody has not been set to or resolved to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],SystemStandard->True,SecondaryAntibodyVolume->9.5*Microliter,Output->Options];
			Lookup[options,StandardSecondaryAntibodyVolume],
			0.5*Microliter,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluent,"When PrimaryAntibodyDiluent->Automatic, the option resolves to the Null if the PrimaryAntibodyDilutionFactor is set to 1:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDilutionFactor->1,Output->Options];
			Lookup[options,PrimaryAntibodyDiluent],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluent,"When PrimaryAntibodyDiluent->Automatic, the option resolves to the Null if the PrimaryAntibodyDiluentVolume is set to Null or 0 uL:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDiluentVolume->0*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDiluent],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluent,"When PrimaryAntibodyDiluent->Automatic, the option resolves to the Null if the average of the RecommendedDilutions of the Model[Molecule,Protein,Antibody]s present in the Composition field of the PrimaryAntibody is 1 and the PrimaryAntibodyDilutionFactor and PrimaryAntibodyDiluentVolume are left as Automatic:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDiluent],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluent,"When PrimaryAntibodyDiluent->Automatic and the average of the RecommendedDilutions of the Model[Molecule,Protein,Antibody]s present in the Composition field of the PrimaryAntibody is not 1, the option resolves to the Model[Sample,\"Simple Western Milk-Free Antibody Diluent\"] if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is Goat:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDiluent],
			Model[Sample,"Simple Western Milk-Free Antibody Diluent"],
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluent,"When PrimaryAntibodyDiluent->Automatic and the average of the RecommendedDilutions of the Model[Molecule,Protein,Antibody]s present in the Composition field of the PrimaryAntibody is not 1, the option resolves to the Model[Sample,\"Simple Western Antibody Diluent 2\"] if the Organism of first Model[Molecule,Protein,Antibody] listed in the Components field of the PrimaryAntibody is anything other than Goat:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDiluent],
			Model[Sample,"Simple Western Antibody Diluent 2"],
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, the option resolves to the 1 if the PrimaryAntibodyDiluent resolves to or is set to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDiluent->Null,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			1,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic and both the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are set volumes, the option resolves based on the given volumes:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->40*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.02439,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, PrimaryAntibodyVolume->Automatic, and the PrimaryAntibodyDiluentVolume is a set volume, the option resolves based on the given volume and the assumption that the PrimaryAntibodyVolume will resolve to 1 uL:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyVolume->Automatic,PrimaryAntibodyDiluentVolume->99*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic and both the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are left as Automatic, the option resolves to the average of the RecommendedDilutions of the Model[Molecule,Protein,Antibody]s present in the Composition field of the PrimaryAntibody:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.005,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, the option resolves to 1 if the input PrimaryAntibody is not of Model Model[Sample] (in the case of a no primary antibody control, for example):"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test antibody diluent 2 sample for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			1,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, SystemStandard->True, and all of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume are set volumes, the option resolves based on the given volumes:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->35*Microliter,StandardPrimaryAntibodyVolume->4*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.025,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, SystemStandard->True, PrimaryAntibodyVolume->Automatic, and both the PrimaryAntibodyDiluentVolume and StandardPrimaryAntibodyVolume are set volumes, the option resolves based on the given volumes, with the assumption that the PrimaryAntibodyVolume will resolve to 1 uL:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyVolume->Automatic,PrimaryAntibodyDiluentVolume->35*Microliter,StandardPrimaryAntibodyVolume->4*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.025,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDilutionFactor,"When PrimaryAntibodyDilutionFactor->Automatic, SystemStandard->True, PrimaryAntibodyVolume->Automatic, StandardPrimaryAntibodyVolume->Automatic, and the PrimaryAntibodyDiluentVolume is a set volume, the option resolves based on the given volume, with the assumption that the PrimaryAntibodyVolume will resolve to 1 uL and the StandardPrimaryAntibodyVolume will resolve to ~10% of the total volume:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyVolume->Automatic,PrimaryAntibodyDiluentVolume->98*Microliter,StandardPrimaryAntibodyVolume->Automatic,Output->Options];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.00909,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic, the option resolves to 36 uL when the PrimaryAntibodyDiluent is set to or resolves to Null:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDiluent->Null,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			36*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic and PrimaryAntibodyDiluentVolume->Automatic, the option resolves based on the PrimaryAntibodyDilutionFactor, aiming for a total volume of 200 uL:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDilutionFactor->0.01,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			2*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic and PrimaryAntibodyDiluentVolume is a set volume, the option resolves based on the given volume and the PrimaryAntibodyDilutionFactor:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDilutionFactor->0.005,PrimaryAntibodyDiluentVolume->199*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			1*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic, SystemStandard->True, and both the PrimaryAntibodyDiluentVolume and the StandardPrimaryAntibodyVolume are set volumes, the option resolves based on the given volumes and the PrimaryAntibodyDilutionFactor:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyDiluentVolume->170*Microliter,StandardPrimaryAntibodyVolume->21*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			1.9*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic, SystemStandard->True, StandardPrimaryAntibodyVolume->Automatic, and the PrimaryAntibodyDiluentVolume is a set volume, the option resolves based on the given volume, the PrimaryAntibodyDilutionFactor, and the assumption that the StandardPrimaryAntibodyVolume will resolve to ~10% of the total volume:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyDiluentVolume->100*Microliter,StandardPrimaryAntibodyVolume->Automatic,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			1.1*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyVolume,"When PrimaryAntibodyVolume->Automatic, SystemStandard->True, PrimaryAntibodyDiluentVolume->Automatic, and the StandardPrimaryAntibodyVolume is a set volume, the option resolves based on the given volume, the PrimaryAntibodyDilutionFactor, and the assumption that the StandardPrimaryAntibodyVolume will make up ~10% of the total volume:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyDiluentVolume->Automatic,StandardPrimaryAntibodyVolume->10*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyVolume],
			1*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyStorageCondition,"The PrimaryAntibodyStorageCondition option is used to set the storage condition of the PrimaryAntibodies after they are used in the experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				PrimaryAntibodyStorageCondition->AmbientStorage,Output->Options];
			Lookup[options,PrimaryAntibodyStorageCondition],
			{AmbientStorage},
			Variables :> {options}
		],
		Example[{Options,SecondaryAntibodyStorageCondition,"The SecondaryAntibodyStorageCondition option is used to set the storage condition of the SecondaryAntibodies after they are used in the experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				SecondaryAntibodyStorageCondition->AmbientStorage,Output->Options];
			Lookup[options,SecondaryAntibodyStorageCondition],
			{AmbientStorage},
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluentVolume,"When PrimaryAntibodyDiluentVolume->Automatic, the option resolves to Null when the PrimaryAntibodyDilutionFactor is set to or resolves to 1:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],Output->Options];
			Lookup[options,PrimaryAntibodyDiluentVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluentVolume,"When PrimaryAntibodyDiluentVolume->Automatic, the option resolves based on the PrimaryAntibodyVolume and the PrimaryAntibodyDilutionFactor:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],PrimaryAntibodyDilutionFactor->0.05,PrimaryAntibodyVolume->2*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDiluentVolume],
			38*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluentVolume,"When PrimaryAntibodyDiluentVolume->Automatic, SystemStandard->True, and the StandardPrimaryAntibodyVolume is a set value,the option resolves based on the PrimaryAntibodyVolume, the PrimaryAntibodyDilutionFactor, and the StandardPrimaryAntibodyVolume :"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True, PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyVolume->1*Microliter,StandardPrimaryAntibodyVolume->10*Microliter,Output->Options];
			Lookup[options,PrimaryAntibodyDiluentVolume],
			89*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryAntibodyDiluentVolume,"When PrimaryAntibodyDiluentVolume->Automatic, SystemStandard->True, and the StandardPrimaryAntibodyVolume left as Automatic,the option resolves based on the PrimaryAntibodyVolume, the PrimaryAntibodyDilutionFactor, and the assumption that the StandardPrimaryAntibodyVolume will make up ~10% of the total volume :"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True, PrimaryAntibodyDilutionFactor->0.01,PrimaryAntibodyVolume->1.5*Microliter,StandardPrimaryAntibodyVolume->Automatic,Output->Options];
			Lookup[options,PrimaryAntibodyDiluentVolume],
			133.5*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibodyVolume,"When StandardPrimaryAntibodyVolume->Automatic, the option resolves to Null unless SystemStandard is set to True:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Output->Options];
			Lookup[options,StandardPrimaryAntibodyVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibodyVolume,"When StandardPrimaryAntibodyVolume->Automatic, SystemStandard->True, and the PrimaryAntibodyDilutionFactor has been set to or has resolved to 1, the option resolves to the PrimaryAntibodyVolume divided by 9:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyDilutionFactor->1,PrimaryAntibodyVolume->45*Microliter, Output->Options];
			Lookup[options,StandardPrimaryAntibodyVolume],
			5*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,StandardPrimaryAntibodyVolume,"When StandardPrimaryAntibodyVolume->Automatic, SystemStandard->True, and the PrimaryAntibodyDilutionFactor has been set to or has resolved to anything other than 1, the option resolves based on the set or resolved PrimaryAntibodyDilutionFactor, PrimaryAntibodyVolume, and PrimaryAntibodyDiluentVolume options:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],SystemStandard->True,PrimaryAntibodyDilutionFactor->0.018,PrimaryAntibodyVolume->1*Microliter,PrimaryAntibodyDiluentVolume->49.9*Microliter, Output->Options];
			Lookup[options,StandardPrimaryAntibodyVolume],
			4.7*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Name,"Name the protocol for Western:"},
			options=Quiet[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Name->"Super cool test protocol",Output->Options],Warning::InstrumentUndergoingMaintenance];
			Lookup[options,Name],
			"Super cool test protocol",
			Variables :> {options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=Quiet[ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],Template->Object[Protocol,Western,"Test Western option template protocol"<>$SessionUUID],Output->Options],Warning::InstrumentUndergoingMaintenance];
			Lookup[options,Instrument],
			Object[Instrument, Western, "id:Z1lqpMGje9p5"],
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		(* --- Sample Prep unit tests --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentWestern[
				(* Simple Western Control HeLa Lysate *)
				{Model[Sample, "id:WNa4ZjKMrPeD"], Model[Sample, "id:WNa4ZjKMrPeD"]},
				Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				PreparedModelAmount -> 1 Milliliter,
				(* 96-well 2mL Deep Well Plate *)
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				(* Simple Western Control HeLa Lysate *)
				{ObjectP[Model[Sample, "id:WNa4ZjKMrPeD"]]..},
				(* 96-well 2mL Deep Well Plate *)
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentWestern[
				(* Simple Western Control HeLa Lysate *)
				{Model[Sample, "id:WNa4ZjKMrPeD"], Model[Sample, "id:WNa4ZjKMrPeD"]},
				(* Simple Western Rabbit-AntiERK-1 *)
				Model[Sample, "id:54n6evLJxqqP"],
				PreparedModelAmount -> 0.2 Milliliter,
				(* 2mL Tube *)
				PreparedModelContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],
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
				(* Simple Western Control HeLa Lysate *)
				{ObjectP[Model[Sample, "id:WNa4ZjKMrPeD"]],ObjectP[Model[Sample, "id:WNa4ZjKMrPeD"]]},
				(* 2ml tube *)
				{ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
				{EqualP[0.2 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, PrimaryAntibodyVolume, "If a model is specified for the primary antibody, a resource will be generated for it with an appropriate volume to provide PrimaryAntibodyVolume for each sample:"},
			Download[
				DeleteDuplicates[
					Cases[
						Download[
							ExperimentWestern[
								(* Simple Western Control HeLa Lysate *)
								{Model[Sample, "id:WNa4ZjKMrPeD"], Model[Sample, "id:WNa4ZjKMrPeD"]},
								(* Simple Western Rabbit-AntiERK-1 *)
								{Model[Sample, "id:54n6evLJxqqP"], Model[Sample, "id:54n6evLJxqqP"]},
								PrimaryAntibodyVolume -> 50 Microliter
							],
							RequiredResources
						],
						{resource_, PrimaryAntibodies, ___} :> resource[Object]
					]
				],
				{Object, Models, Amount}
			],
			{
				{ObjectP[Object[Resource, Sample]], {ObjectP[Model[Sample, "id:54n6evLJxqqP"]]}, 111. Microliter}
			},
			Messages :> {
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentWestern[
				(* Simple Western Control HeLa Lysate *)
				{Model[Sample, "id:WNa4ZjKMrPeD"], Model[Sample, "id:WNa4ZjKMrPeD"]},
				(* Simple Western Rabbit-AntiERK-1 *)
				Model[Sample, "id:54n6evLJxqqP"],
				PreparedModelAmount -> 0.2 Milliliter,
				(* 2mL Tube and 50mL Tube *)
				PreparedModelContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],
				Mix -> True,
				Aliquot -> True
			],
			ObjectP[Object[Protocol, Western]],
			Messages :> {
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run on a capillary-based total protein detection assay:"},
			options=ExperimentWestern["Lysate Container",Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Lysate Container",
						Container->Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
						Amount->50*Microliter,
						Destination->"Lysate Container"
					]
				},
				Output->Options
			];
			Lookup[options,MolecularWeightRange],
			HighMolecularWeight,
			Variables:>{options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			},
			TimeConstraint->1000
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run on a capillary-based total protein detection assay - with Model PrimaryAntibody input:"},
			options=ExperimentWestern["Lysate Container",Model[Sample, "Simple Western Rabbit-AntiERK-1"],
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Lysate Container",
						Container->Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
						Amount->50*Microliter,
						Destination->"Lysate Container"
					]
				},
				Output->Options
			];
			Lookup[options,MolecularWeightRange],
			MidMolecularWeight,
			Variables:>{options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to pre-dilute PrimaryAntibody to reach PrimaryAntibodyDilutionFactors smaller than 0.005 (in this case, the final PrimaryAntibodyDilutionFactors are 0.004 and 0.0001):"},
			options=ExperimentWestern[{Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID]},{"Antibody Container","Antibody Container"},
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Antibody Container",
						Container->Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
						Amount->2*Microliter,
						Destination->"Antibody Container"
					],
					Transfer[
						Source->Model[Sample,"Simple Western Antibody Diluent 2"],
						Amount->248*Microliter,
						Destination->"Antibody Container"
					]
				},
				PrimaryAntibodyDilutionFactor->{1,0.025},
				PrimaryAntibodyVolume->{36,3}*Microliter,
				Output->Options
			];
			Lookup[options,MolecularWeightRange],
			HighMolecularWeight,
			Variables:>{options},
			TimeConstraint -> 1200
		],
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True,Output->Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->240
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], IncubateAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeTemperature -> 30*Celsius,CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"],AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> Syringe,Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterMaterial -> PES,FilterContainerOut->Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentWestern[Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentWestern[Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius,Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Aliquot->True,Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Specify a label for the aliquoted ExperimentWestern sample:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Aliquot->True,AliquotSampleLabel->"Test Label for ExperimentWesetern sample 1",Output -> Options];
			Lookup[options, AliquotSampleLabel],
			{"Test Label for ExperimentWesetern sample 1"},
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AliquotAmount -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AssayVolume -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentWestern[Object[Sample,"10 kDa test protein sample for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], TargetConcentration -> 5*Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentWestern[Object[Sample,"10 kDa test protein sample for ExperimentWestern"<>$SessionUUID], Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],TargetConcentration -> 5.5*Micromolar,TargetConcentrationAnalyte->Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectReferenceP[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID]],
			Variables :> {options},
			Messages:>{
				Warning::WesTotalProteinConcentrationNotInformed
			}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],
				BufferDilutionFactor->2,
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.5*Milliliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.1*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator,Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],IncubateAliquotDestinationWell -> "A1",AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentWestern[Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables :> {options}
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	Parallel->True,
	(* NOTE: We have to turn these messages off in our SetUp as well since our tests run in parallel on Manifold. *)
	SetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
	),
	SymbolSetUp:>{
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects= {
				Object[Container,Vessel,"Test 2mL Tube 1 containing lysate sample for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 2 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 3 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 4 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 5 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 6 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 7 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 8 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 9 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 10 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 11 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 12 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 13 for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentWestern"<>$SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 14 for ExperimentWestern"<>$SessionUUID],

				Object[Instrument,Western,"Test Wes Instrument for ExperimentWestern Tests"<>$SessionUUID],

				Model[Sample,"10 kDa test protein for ExperimentWestern"<>$SessionUUID],

				Model[Molecule,Protein,"Test 200 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],
				Model[Molecule,Protein,"Test 90 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],
				Model[Molecule,Protein,"Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],

				Model[Molecule,Protein,Antibody,"Test goat-derived Model[Molecule,Protein,Antibody] with 10 kDa target for ExperimentWestern Tests"<>$SessionUUID],
				Model[Molecule,Protein,Antibody,"Test mouse-derived Model[Molecule,Protein,Antibody] with 200 kDa target for ExperimentWestern Tests"<>$SessionUUID],
				Model[Molecule,Protein,Antibody,"Test human-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID],
				Model[Molecule,Protein,Antibody,"Test hamster-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID],

				Object[Sample,"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test discarded lysate sample for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test discarded Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentWestern"<>$SessionUUID],

				Model[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],
				Model[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				Model[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],
				Model[Sample,"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID],

				Object[Sample,"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],
				Object[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
				Object[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],
				Object[Sample,"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID],

				Object[Sample,"Test water sample for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test antibody diluent 2 sample for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"10 kDa test protein sample for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID],
				Object[Sample,"Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID],

				Object[Protocol,Western,"Test Western option template protocol"<>$SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[PickList[allObjects, existsFilter], Force->True, Verbose->False]]
		];

		Module[
			{
				emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
				emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,emptyContainer14,
				emptyContainer15,fakeInstrument,availableLysateSample,discardedLysateSample,availableERKAntibody,discardedERKAntibody,
				availableLysateSampleNoTotal,goatPrimary,mousePrimary,humanPrimary,hamsterPrimary,waterSample,diluentSample,
				lysateTooConc,proteinSample,biggerWaterSample,modellessSample},
			(* Create some empty containers and a fake instrument *)
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
				fakeInstrument
			}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 1 containing lysate sample for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 2 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 3 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 4 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 5 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 6 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 7 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 8 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 9 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 10 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 11 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 12 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 13 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"],Objects],
					Name->"Test 50mL Tube with 25mL water sample inside for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"],Objects],
					Name->"Test 2mL Tube 14 for ExperimentWestern"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Instrument,Western],
					Model->Link[Model[Instrument, Western, "Wes"],Objects],
					Name->"Test Wes Instrument for ExperimentWestern Tests"<>$SessionUUID,
					DeveloperObject->True,
					Site->Link[$Site]
				|>
			}];

			(* Create test Model[Molecule,Protein]s to populate the Targets field of test Model[Molecule,Protein,Antibody]s to be used for unit tests *)
			Upload[{
				<|
					Type->Model[Molecule,Protein],
					Name->"Test 200 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID,
					MolecularWeight->200*(Kilogram/Mole),
					DeveloperObject->True
				|>,
				<|
					Type->Model[Molecule,Protein],
					Name->"Test 90 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID,
					MolecularWeight->90*(Kilogram/Mole),
					DeveloperObject->True
				|>,
				<|
					Type->Model[Molecule,Protein],
					Name->"Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID,
					MolecularWeight->10*(Kilogram/Mole),
					DeveloperObject->True
				|>
			}];

			(* Create test protein Models *)
			Upload[{
				<|
					Type->Model[Sample],
					Name->"10 kDa test protein for ExperimentWestern"<>$SessionUUID,
					Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
					DeveloperObject->True,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
					Replace[Composition]->{
						{20*Micromolar,Link[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID]]},
						{100*VolumePercent,Link[Model[Molecule, "Water"]]}
					}
				|>
			}];

			(* Create test Model[Molecule,Protein,Antibody]s to populate the Targets field of test Model[Molecule,Protein,Antibody]s to be used for unit tests *)
			Upload[{
				<|
					Type->Model[Molecule,Protein,Antibody],
					Name->"Test goat-derived Model[Molecule,Protein,Antibody] with 10 kDa target for ExperimentWestern Tests"<>$SessionUUID,
					Organism->Goat,
					RecommendedDilution->0.01,
					Replace[Targets]->{Link[Model[Molecule,Protein,"Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],Antibodies]},
					DeveloperObject->True
				|>,
				<|
					Type->Model[Molecule,Protein,Antibody],
					Name->"Test mouse-derived Model[Molecule,Protein,Antibody] with 200 kDa target for ExperimentWestern Tests"<>$SessionUUID,
					Organism->Mouse,
					RecommendedDilution->0.005,
					Replace[Targets]->{Link[Model[Molecule,Protein,"Test 200 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],Antibodies]},
					DeveloperObject->True
				|>,
				<|
					Type->Model[Molecule,Protein,Antibody],
					Name->"Test human-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID,
					Organism->Human,
					RecommendedDilution->0.02,
					Replace[Targets]->{Link[Model[Molecule,Protein,"Test 90 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],Antibodies]},
					DeveloperObject->True
				|>,
				<|
					Type->Model[Molecule,Protein,Antibody],
					Name->"Test hamster-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID,
					Organism->Hamster,
					RecommendedDilution->0.02,
					Replace[Targets]->{Link[Model[Molecule,Protein,"Test 90 kDa Model[Molecule,Protein] for ExperimentWestern Tests"<>$SessionUUID],Antibodies]},
					DeveloperObject->True
				|>
			}];

			(* Upload some fake test PrimaryAntibody Models of different Organisms *)
			Upload[{
				<|
					Type->Model[Sample],
					Name->"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID,
					Replace[Composition]->{
						{5*Micromolar,Link[Model[Molecule,Protein,Antibody,"Test goat-derived Model[Molecule,Protein,Antibody] with 10 kDa target for ExperimentWestern Tests"<>$SessionUUID]]}
					},
					Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
					DeveloperObject->True,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]]
				|>,
				<|
					Type->Model[Sample],
					Name->"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID,
					Replace[Composition]->{
						{Null,Link[Model[Molecule,Protein,Antibody,"Test mouse-derived Model[Molecule,Protein,Antibody] with 200 kDa target for ExperimentWestern Tests"<>$SessionUUID]]},
						{Null,Null}
					},
					Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
					DeveloperObject->True,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]]
				|>,
				<|
					Type->Model[Sample],
					Name->"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID,
					Replace[Composition]->{
						{Null,Link[Model[Molecule,Protein,Antibody,"Test human-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID]]},
						{Null,Link[Model[Molecule, "Water"]]}
					},
					Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
					DeveloperObject->True,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]]
				|>,
				<|
					Type->Model[Sample],
					Name->"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID,
					Replace[Composition]->{
						{10*Micromolar,Link[Model[Molecule,Protein,Antibody,"Test hamster-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests"<>$SessionUUID]]},
						{100*VolumePercent,Link[Model[Molecule, "Water"]]}
					},
					Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
					DeveloperObject->True,
					DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]]
				|>
			}];

			(* Create some samples for testing purposes *)
			{
				availableLysateSample,
				discardedLysateSample,
				availableERKAntibody,
				discardedERKAntibody,
				availableLysateSampleNoTotal,
				goatPrimary,
				mousePrimary,
				humanPrimary,
				hamsterPrimary,
				waterSample,
				diluentSample,
				lysateTooConc,
				proteinSample,
				biggerWaterSample,
				modellessSample
			}=UploadSample[
				{
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "id:54n6evLJxqqP"],
					Model[Sample, "id:54n6evLJxqqP"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample, "Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID],
					Model[Sample,"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID],
					Model[Sample,"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID],
					Model[Sample,"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID],
					Model[Sample, "Milli-Q water"],
					Model[Sample,"Simple Western Antibody Diluent 2"],
					Model[Sample, "id:WNa4ZjKMrPeD"],
					Model[Sample,"10 kDa test protein for ExperimentWestern"<>$SessionUUID],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:WNa4ZjKMrPeD"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",emptyContainer4},
					{"A1",emptyContainer5},
					{"A1",emptyContainer6},
					{"A1",emptyContainer7},
					{"A1",emptyContainer8},
					{"A1",emptyContainer9},
					{"A1",emptyContainer10},
					{"A1",emptyContainer11},
					{"A1",emptyContainer12},
					{"A1",emptyContainer13},
					{"A1",emptyContainer14},
					{"A1",emptyContainer15}
				},
				Name->{
					"Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID,
					"Test discarded lysate sample for ExperimentWestern"<>$SessionUUID,
					"Test Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID,
					"Test discarded Rabbit-AntiERK-1 antibody for ExperimentWestern"<>$SessionUUID,
					"Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentWestern"<>$SessionUUID,
					"Test goat-derived primary antibody with 10 kDa target"<>$SessionUUID,
					"Test mouse-derived primary antibody with 200 kDa target"<>$SessionUUID,
					"Test human-derived primary antibody with 90 kDa target"<>$SessionUUID,
					"Test hamster-derived primary antibody with 90 kDa target"<>$SessionUUID,
					"Test water sample for ExperimentWestern"<>$SessionUUID,
					"Test antibody diluent 2 sample for ExperimentWestern"<>$SessionUUID,
					"Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentWestern"<>$SessionUUID,
					"10 kDa test protein sample for ExperimentWestern"<>$SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ExperimentWestern"<>$SessionUUID,
					"Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern"<>$SessionUUID
				}
			];

			(* Make a test protocol for the Template option unit test *)
			Upload[
				{
					<|
						Type->Object[Protocol,Western],
						DeveloperObject->True,
						Name->"Test Western option template protocol"<>$SessionUUID,
						ResolvedOptions->{Instrument->Object[Instrument, Western, "id:Z1lqpMGje9p5"]},
						Site->Link[$Site]
					|>
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->availableLysateSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
				<|Object->discardedLysateSample,Status->Discarded,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>,
				<|Object->availableERKAntibody,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->discardedERKAntibody,Status->Discarded,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->availableLysateSampleNoTotal,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->goatPrimary,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->mousePrimary,Status->Available,DeveloperObject->False,Volume->1*Milliliter|>,
				<|Object->humanPrimary,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->hamsterPrimary,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->waterSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->diluentSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter|>,
				<|Object->lysateTooConc,Status->Available,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->5*Milligram/Milliliter|>,
				<|Object->proteinSample,Status->Available,DeveloperObject->True,Volume->1*Milliliter,Concentration->11*Micromolar|>,
				<|Object->biggerWaterSample,Status->Available,DeveloperObject->True,Volume->25*Milliliter|>,
				<|Object->modellessSample,Status->Available,Model->Null,DeveloperObject->True,Volume->1*Milliliter,TotalProteinConcentration->0.25*Milligram/Milliliter|>
			}]
		];
	},

	SymbolTearDown:> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Vessel, "Test 2mL Tube 1 containing lysate sample for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 2 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 3 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 4 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 5 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 6 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 7 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 8 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 9 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 10 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 11 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 12 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 13 for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentWestern" <> $SessionUUID],
				Object[Container, Vessel, "Test 2mL Tube 14 for ExperimentWestern" <> $SessionUUID],

				Object[Instrument, Western, "Test Wes Instrument for ExperimentWestern Tests" <> $SessionUUID],

				Model[Sample, "10 kDa test protein for ExperimentWestern" <> $SessionUUID],

				Model[Molecule, Protein, "Test 200 kDa Model[Molecule,Protein] for ExperimentWestern Tests" <> $SessionUUID],
				Model[Molecule, Protein, "Test 90 kDa Model[Molecule,Protein] for ExperimentWestern Tests" <> $SessionUUID],
				Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentWestern Tests" <> $SessionUUID],

				Model[Molecule, Protein, Antibody, "Test goat-derived Model[Molecule,Protein,Antibody] with 10 kDa target for ExperimentWestern Tests" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "Test mouse-derived Model[Molecule,Protein,Antibody] with 200 kDa target for ExperimentWestern Tests" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "Test human-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests" <> $SessionUUID],
				Model[Molecule, Protein, Antibody, "Test hamster-derived Model[Molecule,Protein,Antibody] with 90 kDa target for ExperimentWestern Tests" <> $SessionUUID],

				Object[Sample, "Test 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, 5 mg/mL total protein for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test discarded lysate sample for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test Rabbit-AntiERK-1 antibody for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test discarded Rabbit-AntiERK-1 antibody for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test 1 mL lysate sample, TotalProteinConcentration not informed for ExperimentWestern" <> $SessionUUID],

				Model[Sample, "Test goat-derived primary antibody with 10 kDa target" <> $SessionUUID],
				Model[Sample, "Test mouse-derived primary antibody with 200 kDa target" <> $SessionUUID],
				Model[Sample, "Test human-derived primary antibody with 90 kDa target" <> $SessionUUID],
				Model[Sample, "Test hamster-derived primary antibody with 90 kDa target" <> $SessionUUID],

				Object[Sample, "Test goat-derived primary antibody with 10 kDa target" <> $SessionUUID],
				Object[Sample, "Test mouse-derived primary antibody with 200 kDa target" <> $SessionUUID],
				Object[Sample, "Test human-derived primary antibody with 90 kDa target" <> $SessionUUID],
				Object[Sample, "Test hamster-derived primary antibody with 90 kDa target" <> $SessionUUID],

				Object[Sample, "Test water sample for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test antibody diluent 2 sample for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "10 kDa test protein sample for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentWestern" <> $SessionUUID],
				Object[Sample, "Test Modelless 1 mL lysate sample, 0.25 mg/mL total protein for ExperimentWestern" <> $SessionUUID],

				Object[Protocol, Western, "Test Western option template protocol" <> $SessionUUID]
			};
			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force -> True, Verbose -> False]]
		];
	)
];
