(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Western], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a Western blot instrument.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		PrimaryAntibodies->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The antibodies that selectively binds to a specific protein in the input sample.",
			Category->"Sample Preparation"
		},
		QualificationSampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The preparatory unit operation-defined strings to provide as input to the ExperimentWestern experiment call.",
			Category -> "Sample Preparation"
		}
	}
}];
