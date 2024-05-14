(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Sonicator], {
	Description->"A device that applies sound energy to agitate particles in a sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		BathFluid -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BathFluid]],
			Pattern :> Water | Oil,
			Description -> "Fluid type (Water or Oil) that is allowed to be in the sonicator reservoir.",
			Category -> "Instrument Specifications"
		},
		
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the sonicator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the sonicator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TemperatureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet temperature probe used by this sonication instrument to measure the temperature of the bath.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		BathVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BathVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Volume of bath fluid required to fill the sonicator reservoir.",
			Category -> "Dimensions & Positions"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the sonicator reservoir in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		}
	}
}];
