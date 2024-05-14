(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelTrainingMaterialQTests*)

validModelTrainingMaterialQTests[packet:PacketP[Model[TrainingMaterial]]]:={

	(* General fields filled in *)
	NotNullFieldTest[packet,
		{
			Title,
			TrainingFormat,
			Hyperlink,
			TrainingModules
		}
	],
	
	{
		(*Checks if the Site, when informed, is a company site*)
		Test["If Site is specified, it must be either be Object[Container, Site, \"ECL-2\"] or Object[Container, Site, \"CMU\"]:",
			Lookup[packet, Site],
			Alternatives[Null, ObjectP[{Object[Container, Site, "id:kEJ9mqJxOl63"], Object[Container, Site, "id:P5ZnEjZpRlK4"]}]]
		]
	}
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Model[TrainingMaterial],validModelTrainingMaterialQTests];
