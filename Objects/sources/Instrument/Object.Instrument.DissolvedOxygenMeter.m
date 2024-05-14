

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, DissolvedOxygenMeter], {
	Description->"An instrument for measuring the concentration of dissolved oxygen inside a liquid sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MinDissolvedOxygen -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterEqualP[(0Milligram)/Liter],
			Description -> "Minimum concentration of dissolved oxygen the instrument can measure.",
			Category -> "Operating Limits"
		},
		MaxDissolvedOxygen -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterP[(0Milligram)/Liter],
			Description -> "Minimum concentration of dissolved oxygen the instrument can measure.",
			Category -> "Operating Limits"
		},
		DissolvedOxygenResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterP[(0Milligram)/Liter],
			Description -> "The smallest magnitude between values of dissolved oxygen the instrument is capable of reporting as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		DissolvedOxygenAccuracy -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterP[(0Milligram)/Liter],
			Description -> "Indicates the level of uncertainty of dissolved oxygen measurements as described by the instrument manufacturer in its product documentation.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerLaserModeUncertainty]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the instrument can perform a measurement at.",
			Category -> "Operating Limits"
		}
	}
}];
