(* ::Package:: *)

DefineObjectType[Model[Qualification, DNASynthesizer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a DNA synthesizer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		ModelDNASynthesisStrands->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample]
			],
			Description -> "Samples with known expected results that are run on the target instrument to test DNA Synthesis capabilites.",
			Category -> "General"
		}
	}
}];
