(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelTrainingModuleQTests*)

validModelTrainingModuleQTests[packet:PacketP[Model[TrainingModule]]]:=Module[{trainingMaterialsPacket},

	{
		(* General fields filled in *)
		NotNullFieldTest[packet,
			{
				Category,
				Skill,
				Operator,
				Quiz
			}
		],
		
		trainingMaterialsPacket = Download[packet, Packet[TrainingMaterials[TrainingFormat]]];
		
		{
			(*Checks if TrainingMaterials has at least one video and one slides file*)
			Test["TrainingMaterials must have at least two Model[TrainingMaterial] objects, with both Slides and TrainingVideo formats required:",
				Length[Tally[Lookup[trainingMaterialsPacket,TrainingFormat,{}]]],
				GreaterEqualP[2]
			],
			
			(*Checks if the Site, when informed, is a company site*)
			Test["If Site is specified, it must be either be Object[Container, Site, \"ECL-2\"] or Object[Container, Site, \"CMU\"]:",
				Lookup[packet, Site],
				Alternatives[Null, ObjectP[{Object[Container, Site, "id:kEJ9mqJxOl63"], Object[Container, Site, "id:P5ZnEjZpRlK4"]}]]
			]
		}
	}

];

(* ::Subsection:: *)
(*Test Registration *)

registerValidQTestFunction[Model[TrainingModule],validModelTrainingModuleQTests];
