(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Training], {
	Description->"Definition of a set of parameters for a maintenance that allows a user to practice their ability to perform different lab skills.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfDrills -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The default number of times to include practicing of the trained skill in instances of this maintenance.",
			Category -> "General"
		},
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TrainingModule][PracticeDrills],
			Description->"All the training modules that use this in-lab practice to work on understanding of the material in those modules.",
			Category->"General"
		}
	}
}];
