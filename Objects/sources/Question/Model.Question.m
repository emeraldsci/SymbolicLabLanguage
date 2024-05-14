(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Question],{
	Description->"Model information for a quiz question used to request information from a subject.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* --- Organizational Information --- *)
		Name->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name of the question model object.",
			Category->"Organizational Information",
			Abstract->True
		},
		Authors->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User],
			Description->"The person(s) who created this Question model.",
			Category->"Organizational Information"
		},
		Deprecated->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this model Question is historical and no longer used in the lab.",
			Category->"Organizational Information",
			Abstract->True
		},
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		(* --- Question Information --- *)
		QuestionText->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The text to show to the user in order to elicit their response.",
			Category->"Question Information",
			Abstract->True
		},
		ImageFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The image file(s) that will be displayed along with your question.",
			Category->"Question Information"
		},
		Tags->{
			Format->Multiple,
			Class->Expression,
			Pattern:>QuestionTagsP,
			Description->"A list of keyword tags that are used to group questions with a common theme.",
			Category->"Question Information"
		},
		InteractiveTrainings->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Protocol,InteractiveTraining][TrainingTasks],
				Object[Qualification,InteractiveTraining][TrainingTasks]
			],
			Description->"The interactive training protocol or similar objects that have used this question model.",
			Category->"Question Information"
		},
		InteractiveTrainingModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Protocol,InteractiveTraining][TrainingTasks],
				Model[Qualification,InteractiveTraining][TrainingTasks]
			],
			Description->"The interactive training protocol or similar objects that have used this question model.",
			Category->"Question Information"
		},
		TimeAllowed->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"The amount of time that a candidate is permitted to take to provide a response to this question.",
			Category->"Question Information"
		},
		GradeAutomatically->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this question should be graded automatically by comparing the candidate's response with the correct answer. If not, the question must be graded manually by a human.",
			Category->"Question Information"
		},
		GraderGuidelines->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Information that a person manually grading this question should use to determine if a response is correct.",
			Category->"Question Information"
		}
	}
}];
