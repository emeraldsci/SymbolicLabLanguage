(* ::Package:: *)

DefineObjectType[Model[Qualification, GeneticAnalyzer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a genetic analyzer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		SequencingStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "A DNA strand with a known length and sequence which can sequenced on the genetic analyzer.",
			Category -> "General",
			Abstract -> True
		},
		Solvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solvent used to resuspend the sequencing standard.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
