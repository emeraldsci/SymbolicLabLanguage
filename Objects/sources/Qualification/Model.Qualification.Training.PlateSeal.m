(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: joonyeup.lee*)
(* :Date: 2023-6-16 *)

DefineObjectType[Model[Qualification,Training,PlateSeal], {
	Description->"The qualification test to test the user's understanding of Plate Sealing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		UserQualificationFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserQualificationFrequencyP,
			Relation -> Null,
			Description -> "The intended frequency that the user qualification that this model defines should be performed.",
			Category -> "General"
		},
		PlateSealModel -> {
			Units -> None,
			Relation -> Model[Item],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The plate seal that will be used to test the user's ability to place the seal on the containers.",
			Category -> "General"
		},
		PlateContainerModel -> {
			Units -> None,
			Relation -> Model[Container],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			IndexMatching -> PlateSealModel,
			Description -> "For each member of PlateSealModel, the model of the container that will be used for this Qualification.",
			Category -> "General"
		}
	}
}]