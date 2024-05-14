(* ::Package:: *)

DefineObjectType[Model[Qualification,FreezePumpThawApparatus], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a freeze pump thaw apparatus.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		DissolvedOxygenMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument]
			],
			Description -> "The instrument used to measure the dissolved oxygen concentration of the qualification sample.",
			Category -> "General"
		},
		DissolvedOxygenReduction -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The minimum percent by which the dissolved oxygen concentration of the qualification sample must decrease for the qualification to pass.",
			Category -> "General"
		}
	}
}];
