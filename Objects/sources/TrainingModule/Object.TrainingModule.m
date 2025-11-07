(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[TrainingModule], {
	Description->"A module created for a specific user to track their training progress for a given skill.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TrainingStatusP,
			Description -> "Indicates the user's progress through the training module.",
			Category -> "General",
			Abstract -> True
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the last quiz or practical required for this module was completed and marked as passed.",
			Category -> "General",
			Abstract -> True
		},
		TrainingType->{
			Format->Single,
			Class->Expression,
			Pattern:>TrainingTypeP,
			Description->"Indicates the high level goal of this training, such as recertification or to reinforce concepts.",
			Category->"Organizational Information",
			Developer->True
		},
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		User->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User][TrainingModules],
			Description->"The user to whom this training module has been assigned.",
			Category->"General"
		},
		Certifications->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Certification][ActiveTrainingModules, 3],
			Description->"The broader skill sets earned by completing this training module.",
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
		},
		QuizOnly -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this training module was enqueued without a practical for higher-frequency concept reinforcement.",
			Category -> "Operations Information"
		}
	}
}];
