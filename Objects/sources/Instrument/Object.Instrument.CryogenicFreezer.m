(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, CryogenicFreezer], {
	Description->"A cryogenic liquid nitrogen freezer for long term storage of frozen cell lines.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		StoragePhase -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StoragePhase]],
			Pattern :> Liquid | Gas,
			Description -> "Indicates whether samples are stored in direct contact (Liquid) or indirect contact (Gas) with liquid nitrogen.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidNitrogenCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],LiquidNitrogenCapacity]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The maximum volume of liquid nitrogen that the freezer can be filled with.",
			Category -> "Operating Limits"
		},
		StaticEvaporationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StaticEvaporationRate]],
			Pattern :> GreaterP[(0*Liter)/Day],
			Description -> "The rate of liquid nitrogen evaporation from from the freezer when closed.",
			Category -> "Operating Limits"
		},
		HighTemperatureAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The high temperature alarm setpoint on the unit. If the temperature rises above this threshold, an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
		},
		LowLevelAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The low level setting for the liquid nitrogen level, below which an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
		},
		HighLevelAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The high level setting for the liquid nitrogen level, above which an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Description -> "The size of the space inside the cryogenic freezer in the form of: {X Direction (Width),Y Direction (Depth),Z Direction (Height)}.",
			Category -> "Dimensions & Positions"
		},
		LiquidLevelSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, LiquidLevel],
			Description -> "The built-in sensor that monitors the level of liquid nitrogen in the tank.",
			Category -> "Sensor Information"
		},
		TriggerThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The threshold liquid nitrogen level that a cryogenic freezer will open an inlet valve and refill the cryogenic freezer.",
			Category -> "Sensor Information"
		},
		Cylinder->{
			Format->Single,
			Class-> Link,
			Pattern:> _Link,
			Relation-> Object[Container,GasCylinder][CryogenicFreezer],
			Description->"Gas cylinder connected to the inlet of Cryogenic Freezer.",
			Category->"Instrument Specifications"
		}
	}
}];
