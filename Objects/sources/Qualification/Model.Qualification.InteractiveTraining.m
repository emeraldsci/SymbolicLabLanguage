(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,InteractiveTraining],{
	Description->"Model information for an interactive training qualification used to request information from a subject.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* --- Organizational Information --- *)
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TrainingModule][Quiz],
			Description->"All the training modules that use this quiz to test understanding of the material in those modules.",
			Category->"Quiz Information"
		},
		TrainingTasks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Question][InteractiveTrainingModels],
			Description->"A complete list of the questions that may be used for this assessment.",
			Category->"Quiz Information",
			Abstract->True
		},
		RandomizeQuestions->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the questions in this interactive training should be asked in a random order.",
			Category->"Quiz Information",
			Abstract->True
		},
		NumberOfQuestions->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of questions to select from Questions to ask in the interactive training, if not the whole list.",
			Category->"Quiz Information"
		},
		PassingPercentage->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"The percentage of correct answers that a candidate must equal, or exceed to pass this interactive training.",
			Category->"Quiz Information"
		},
		InteractiveTrainingFrequency->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Week],
			Units->Week,
			Description->"For each member of Targets, how often this interactive training is designed to be taken by the candidate.",
			Category->"Quiz Information",
			IndexMatching->Targets
		},
		(* This should trigger conditional procedures in the qualification to enter and exit a DZ *)
		Interruptible->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this interactive training is designed to be exited and re-entered once started.",
			Category->"Quiz Information"
		},
		OpenBook->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this interactive training is designed to be taken whilst a candidate has access to research materials.",
			Category->"Quiz Information"
		},
		TimeAllowed->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"The amount of time that a candidate is permitted to take to provide responses to all of the questions in this interactive training.",
			Category->"Quiz Information"
		},
		Evaluators->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User],
			Description->"The users qualified to grade this interactive training if manual grading is required.",
			Category->"Quiz Information"
		}
	}
}];