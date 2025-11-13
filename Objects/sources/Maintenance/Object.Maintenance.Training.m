(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Training], {
	Description->"A maintenance that allows a user to practice their ability to perform different lab skills.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfDrills -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times to include practicing of the trained skill in instances of this maintenance.",
			Category -> "General"
		},
		Trainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[User] | Object[User],
			Description -> "The instructor providing live feedback to the user being trained in this skill.",
			Category -> "General"
		},
		TrainingModule->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingModule][PracticeDrills],
			Description->"All the training modules that use this in-lab practice to work on understanding of the material in those modules.",
			Category->"General"
		},
		AdditionalPracticeRecommended -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the user may want to repeat this practice material to strengthen the targeted skill.",
			Category -> "General",
			Developer -> True
		}
	}
}];
