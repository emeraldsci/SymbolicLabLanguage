(* ::Package:: *)

DefineObjectType[Model[Qualification, Shaker], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a shaker.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the shaker during the qualification.",
			Category -> "General"
		}
	}
}];
