(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HeatBlock], {
	Description->"Solid conductive heating blocks used to incubate samples at elevated temperatures.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the heat block can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the heat block can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TemperatureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet temperature probe used by this heatblock instrument to measure the temperature of the bead bath.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		IRProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The IR temperature probe that should be used to measure the temperature of any samples inside of the heat block.",
			Category -> "Instrument Specifications"
		},
		ImmersionProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The immersion probe that should be used to measure the temperature of any samples inside of the heat block.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter], GreaterP[0*Meter]},
			Description -> "The internal dimensions of the instrument in the form: {width,depth,height}.",
			Category -> "Dimensions & Positions"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedHeatBlocks],
			Description -> "The liquid handler that is connected to this heat block.",
			Category -> "Integrations"
		}
	}
}];
