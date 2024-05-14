(* ::Package:: *)

DefineObjectType[Model[Qualification, PeptideSynthesizer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a peptide synthesizer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		Template -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,PeptideSynthesis]|Object[Protocol,PNASynthesis],
			Description -> "The qualification procedure will generate a new protocol using the same options as the protocol specified by this field.",
			Category -> "General"
		},
		StrandModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Oligomers that will be synthesized by this qualification.",
			Category -> "General",
			Abstract -> True
		}	
	}
}];
