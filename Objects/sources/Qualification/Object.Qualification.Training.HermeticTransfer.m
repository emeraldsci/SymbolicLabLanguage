(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Training ,HermeticTransfer], {
	Description->"A protocol that verifies an operator's ability to perform hermetic transfer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DestinationContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container into which a hermetic sample is transferred.",
			Category -> "General"
		},
		HermeticPreparatoryUnitOperations -> {
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The list of sample preparation unit operations performed to test the user's ability in hermetic transfer.",
			Category -> "Hermetic Sealed Transfer Skills"
		},
		HermeticSamplePreparationProtocol -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,ManualSamplePreparation],
			Description->"The Manual Sample Preparation sub protocol that tests the user's hermetic transfer skills.",
			Category->"Hermetic Sealed Transfer Skills"
		},
		WeightVerification -> {
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,MeasureWeight],
			Description->"The measured weight of the container being transferred into after receiving sample.",
			Category->"Hermetic Sealed Transfer Skills"
		}
	}
}
]