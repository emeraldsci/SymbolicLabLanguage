(* ::Package:: *)

DefineObjectType[Model[Qualification, HeatBlock], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a heat block.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :>TemperatureP,
			Units -> Celsius,
			Description -> "The temperatures at which the Target instrument should be qualified.",
			Category -> "General"
		}
	}
}];
