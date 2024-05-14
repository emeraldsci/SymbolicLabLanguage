(* ::Package:: *)

DefineObjectType[Model[Qualification,Dewar], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a dewar.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		MaxFreezingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The maximum amount of time allowed for flash freezing the sample for the qualification to pass.",
			Category -> "General"
		}
	}
}];
