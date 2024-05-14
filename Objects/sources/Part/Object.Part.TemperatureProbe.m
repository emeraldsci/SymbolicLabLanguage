

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, TemperatureProbe], {
	Description->"A probe used to measure temperature inside of a spectrophotometer cell.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "Minimum temperature that can be reliably read by this model of probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterEqualP[0*Kelvin],
			Description -> "Maximum temperature that can be reliably read by this model of probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		TemperatureStandardDeviation -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],TemperatureStandardDeviation]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The expected standard deviation of the temperature measurements as described by the probe manufacturer.",
			Category -> "Part Specifications"
		}
	}
}];
