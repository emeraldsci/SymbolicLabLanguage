(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[TrainingModule], {
	Description->"A module created for a specific operator to track their training progress for a given skill.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		Operator->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User,Emerald][TrainingModules],
			Description->"The operator to whom this training module has been assigned.",
			Category->"General"
		},
		Quizzes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Qualification,InteractiveTraining][TrainingModule],
			Description->"The interactive trainings that have been assigned to the operator. If an operator fails a quiz, another can be generated here.",
			Category->"General"
		},
		Practicals->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Qualification,Training][TrainingModule],
			Description->"The lab-based qualifications that have been assigned to the operator. If an operator fails a qualification, another can be generated here.",
			Category->"General"
		},
		TrainingMaterials->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingMaterial],
			Description->"A list of training materials that the operator has reviewed.",
			Category->"General"
		}
	}
}];
