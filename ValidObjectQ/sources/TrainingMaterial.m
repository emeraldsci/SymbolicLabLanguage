(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validObjectTrainingMaterialQTests*)

validObjectTrainingMaterialQTests[packet:PacketP[Object[TrainingMaterial]]]:={

	(* General fields filled in *)
	NotNullFieldTest[packet, {Model,Quizzes}]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[TrainingMaterial],validObjectTrainingMaterialQTests];
