

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, BottleRoller], {
	Description->"The model for a bottle roller instrument used to continuously mix reagent or stock solution bottles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The fastest rotational speed at which the instrument rollers can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The slowest rotational speed at which the instrument rollers can operate.",
			Category -> "Operating Limits"
		},
		MaxLoad -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilo*Gram],
			Units -> Gram Kilo,
			Description -> "The maximum mass of material the bottle roller can handle.",
			Category -> "Operating Limits"
		},
		RollerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The diameter of the rolling pins of the instrument.",
			Category -> "Dimensions & Positions"
		},
		RollerSpacing -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centi*Meter],
			Units -> Centi Meter,
			Description -> "The center-to-center distance between adjacent rolling pins of the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
