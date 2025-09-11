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
		}
	}
}];
