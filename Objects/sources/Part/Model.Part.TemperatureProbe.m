

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, TemperatureProbe], {
	Description -> "Model information for a sensor immersed in a sample to measure that sample's temperature over time.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature that can be reliably read by this model of probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature that can be reliably read by this model of probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		TemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The expected standard deviation of the temperature measurements as described by the probe manufacturer.",
			Category -> "Part Specifications"
		}
	}
}];
