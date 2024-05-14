(* ::Package:: *)

DefineObjectType[Model[Qualification,Ventilation], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a ventilation system.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		Anemometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Anemometer]
			],
			Description -> "The instrument used to measure air velocity.",
			Category -> "General"
		}
	}
}];
