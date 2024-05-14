

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, DissolvedOxygenMeter], {
	Description->"A model of an instrument for measuring the concentration of dissolved oxygen inside a liquid sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinDissolvedOxygen -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0Milligram)/Liter],
			Units -> Milligram/Liter,
			Description -> "Minimum concentration of dissolved oxygen the instrument can measure.",
			Category -> "Operating Limits"
		},
		MaxDissolvedOxygen -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0Milligram)/Liter],
			Units -> Milligram/Liter,
			Description -> "Minimum concentration of dissolved oxygen the instrument can measure.",
			Category -> "Operating Limits"
		},
		DissolvedOxygenResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0Milligram)/Liter],
			Units -> Milligram/Liter,
			Description -> "The smallest magnitude between values of dissolved oxygen the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		DissolvedOxygenAccuracy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0Milligram)/Liter],
			Units -> Milligram/Liter,
			Description -> "Indicates the level of uncertainty of dissolved oxygen measurements as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits"
		}
	}
}];
