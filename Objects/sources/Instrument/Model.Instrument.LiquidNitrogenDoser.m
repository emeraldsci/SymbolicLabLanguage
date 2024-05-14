

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, LiquidNitrogenDoser], {
	Description->"A model for a delivery system used dispense a precisely measured dose of liquid nitrogen.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NozzleDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The width of the tube where the liquid nitrogen exists the doser.",
			Category -> "Instrument Specifications"
		},
		FlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter/Second],
			Units -> Milliliter/Second,
			Description -> "The volume of liquid nitrogen that is dispensed per unit of time.",
			Category -> "Instrument Specifications"
		},
		FlowRatePrecision -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter/Second],
			Units -> Milliliter/Second,
			Description -> "The standard deviation of the volume of liquid nitrogen that is dispensed per unit of time.",
			Category -> "Instrument Specifications"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The smallest volume of liquid nitrogen that can be dispensed.",
			Category -> "Instrument Specifications"
		}
	}
}];
