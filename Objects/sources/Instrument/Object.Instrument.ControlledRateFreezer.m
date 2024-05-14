(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,ControlledRateFreezer],{
	Description->"A freezer that cools at a controlled ramp rate to freeze cells for storage.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterP[0 Kelvin],
			Description->"The lowest temperature the instrument can cool samples placed within its rack.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinCoolingRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinCoolingRate]],
			Pattern:>GreaterP[0 Celsius/Minute],
			Description->"The slowest decrease in temperature that can be achieved per unit time.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxCoolingRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxCoolingRate]],
			Pattern:>GreaterP[0 Celsius/Minute],
			Description->"The fastest decrease in temperature that can be achieved per unit time.",
			Category->"Operating Limits",
			Abstract->True
		},
		InternalDimensions->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern:>{GreaterP[0 Millimeter],GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Description->"The size of the space inside the controlled rate freezer in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category->"Dimensions & Positions"
		},
		TemperatureSensor ->{
			Format -> Single,
			Class -> Link,
			Pattern:> _Link,
			Relation->Object[Sensor][DevicesMonitored],
			Description->"Sensornet temperature probe used by this controlled rate freezer to monitor its temperature.",
			Category -> "Sensor Information"
		}
	}
}];
