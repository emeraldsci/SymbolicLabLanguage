(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training], {
	Description -> "A protocol that verifies an operator's ability to perform different lab skills.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TrainingModule->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingModule][Practicals],
			Description->"The training module that this practical test is embedded in.",
			Category->"General"
		},
		PrecisionScore -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The average deviation (%) from the expected values obtained by the user during their training qualification.",
			Category -> "Experimental Results"
		},
		LabwareToClean -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Object[Part, Funnel]],
			Description -> "All regular objects that need to be in the final CleanUp Task of this Training. This field is set by the parser.",
			Category -> "General"
		},
		TrainingLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Object[Part, Funnel]],
			Description -> "All training objects that need to be emptied and then stored as Stocked at the end of this Training. This field is set by the parser.",
			Category -> "General"
		}
	}
}];
