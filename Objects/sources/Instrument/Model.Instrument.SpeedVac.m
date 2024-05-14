

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, SpeedVac], {
	Description->"A model for a device used to concentrate samples by removing solvent through lowering pressure, increased temperature, and centrifuging the vessel to avoid bumping.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the Speed-Vac can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the Speed-Vac can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxImbalance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "Maximum weight imbalance the rotor can tolerate in the Speed-Vac.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
