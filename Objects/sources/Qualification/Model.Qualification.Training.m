(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to perform different lab skills.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TrainingModule][Practical],
			Description->"All the training modules that use this in-lab qualification to test understanding of the material in those modules.",
			Category->"General"
		}
  }
}];
