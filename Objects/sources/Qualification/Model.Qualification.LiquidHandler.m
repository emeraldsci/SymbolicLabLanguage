(* ::Package:: *)

DefineObjectType[Model[Qualification,LiquidHandler], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a liquid handler.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(*--- Tests ---*)
		PipettingAccuracy -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to correctly transfer expected volumes.",
			Category -> "Qualification Parameters"
		},
		PipettingLinearity -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to transfer volumes linearly.",
			Category -> "Qualification Parameters"
		},
		Mix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to use the pipettes and/or shaker positions to mix a solid within a solution.",
			Category -> "Qualification Parameters"
		},
		PipettingMethod -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to adhere to the requested OverAspirationVolume, AspirationRate, CorrectionCurve, AspirationPosition, and DispensePosition options.",
			Category -> "Qualification Parameters"
		},
		Filter -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to perform pressure-based and/or centrifuge-based filtration.",
			Category -> "Qualification Parameters"
		},
		MagneticBeadSeparation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's ability to perform mangetic bead separation.",
			Category -> "Qualification Parameters"
		},
		VerifyHamiltonLabware -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test the instrument's labware deck definitions.",
			Category -> "Qualification Parameters"
		}
	}
}];
