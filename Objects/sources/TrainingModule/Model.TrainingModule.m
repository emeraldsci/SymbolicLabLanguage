(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[TrainingModule], {
	Description->"A collection of training materials and qualification models that can be used to train operators on a particular skillset.",
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
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model is historical and no longer used to train operators in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Site->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Site],
			Description->"When specified, ties this training module to a specific ECL location where the training must occur.",
			Category->"General"
		},
		Category->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The general classification of the skill being tested in this module.",
			Category->"General"
		},
		Skill->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The skill that this training module is designed to assess.",
			Category->"General"
		},
		Operator->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[User,Emerald,Operator][TrainingModules],
			Description->"Determines the level requirement for operators to take this training module.",
			Category->"General"
		},
		Quiz->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Qualification,InteractiveTraining][TrainingModules],
			Description->"The interactive training that this training module uses to test general knowledge of the skill.",
			Category->"General",
			Required->True
		},
		Practical->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Qualification,Training][TrainingModules],
			Description->"A qualification that can be run in the lab that this training module uses to test an operator's ability to perform the skill.",
			Category->"General"
		},
		RecertificationFrequency-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Day,
			Description -> "Indicates how often training modules with this model are re-enqueued in order to review training material and ensure the operator's certification remains up-to-date.",
			Category -> "General"
		},
		TrainingMaterials->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TrainingMaterial][TrainingModules],
			Description->"A collection of supporting training materials, such as slides and videos, that operators should review before taking the quiz.",
			Category->"General"
		},
		ParentCertifications->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Certification][TrainingModules],
			Description->"Certifications that require this training module in order to be completed.",
			Category->"Operations Information"
		}
	}
}];
