(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validObjectTrainingModuleQTests*)

validObjectTrainingModuleQTests[packet:PacketP[Object[TrainingModule]]]:=Module[{trainingMaterialsPacket},

	{
		(* General fields filled in *)
		NotNullFieldTest[packet,
			{
				Operator,
				TrainingMaterials,
				Quizzes
			}
		]
	}

];

(* ::Subsection:: *)
(*Test Registration *)

registerValidQTestFunction[Object[TrainingModule],validObjectTrainingModuleQTests];
