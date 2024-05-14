(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, Scissors], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to work with scissors to cut samples into a requested weight.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Model[Item]],
			Description -> "The sample or consumable item model to use in this qualification.",
			Category -> "General"
		},
		SampleWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> MassP,
			Units -> Milligram,
			Description -> "For each member of SampleModels, The requested weight to cut during the transfer.",
			IndexMatching -> SampleModels,
			Category -> "General"
		}
	}
}]