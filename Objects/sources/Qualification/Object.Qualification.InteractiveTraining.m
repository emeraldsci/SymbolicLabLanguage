(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,InteractiveTraining],{
	Description->"Model information for an interactive training qualification used to request information from a subject.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* --- Organizational Information --- *)
		(* Quizzing *)
		TrainingTasks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Question][InteractiveTrainings],
			Description->"An ordered list of the questions to be used for this assessment.",
			Category->"Question Information",
			Abstract->True
		},
		Responses->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[_String],
			Description->"The response{s} given by the candidate to each question.",
			Category->"Answer Information",
			Abstract->True
		},
		QuestionResults->{
			Format->Multiple,
			Class->Expression,
			Pattern:>QuestionResultP,
			Description->"For each member of Responses, indicates the outcome of the question.",
			Category->"Answer Information",
			Abstract->False
		},
		GradingNotebook->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A notebook containing details of any responses for manual grading.",
			Category->"Analysis & Reports",
			Developer->True
		},
		TrainingModule->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingModule][Quizzes],
			Description->"The training module that this interactive training is a part of.",
			Category->"General"
		}
	}
}];
