(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HeatExchanger], {
	Description->"A heat exchanging pump used to control the temperature of a sample-holding chamber.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		IntegratedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Spectrophotometer][IntegratedHeatExchanger],
				Object[Instrument, Diffractometer][Chiller]
			],
			Description ->"The instrument for which this heat exchanger helps to regulate temperature by circulation of chilled or heated transfer fluid.",
			Category -> "Instrument Specifications"
		},
		FluidVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],FluidVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Amount of heat transfer fluid needed to fill the pump.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature the heat exchanger can provide to its connected instrument.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature the heat exchanger can provide to its connected instrument.",
			Category -> "Operating Limits"
		},
		MaxTemperatureRamp -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperatureRamp]],
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Description -> "Maximum rate at which the heat exchanger can change temperature.",
			Category -> "Operating Limits"
		}
	}
}];
