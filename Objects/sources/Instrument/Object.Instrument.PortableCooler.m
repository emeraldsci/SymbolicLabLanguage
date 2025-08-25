(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PortableCooler], {
	Description -> "Portable cold incubators used for sample storage when samples must be transported or manipulated at a specified temperature outside of a freezer or refrigerator.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature the portable cooler is currently set to maintain.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0 * Kelvin],
			Description -> "The minimum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 * Kelvin],
			Description -> "The maximum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalDimensions]],
			Pattern :> {GreaterP[0 * Meter], GreaterP[0 * Meter], GreaterP[0 * Meter]},
			Description -> "The size of space inside the Freezer interior in the  {X (width), Y (depth), Z (height)} directions.",
			Category -> "Dimensions & Positions"
		},
		DefaultTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The portable cooler's default temperature which is set to maintain during idle status.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		StoragePhase -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StoragePhase]],
			Pattern :> Liquid | Gas,
			Description -> "Indicates whether samples are stored in direct contact (Liquid) or indirect contact (Gas) with liquid nitrogen.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidNitrogenCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], LiquidNitrogenCapacity]],
			Pattern :> GreaterP[0 * Liter],
			Description -> "The maximum volume of liquid nitrogen that the freezer can be filled with.",
			Category -> "Operating Limits"
		},
		StaticEvaporationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StaticEvaporationRate]],
			Pattern :> GreaterP[(0 * Liter) / Day],
			Description -> "The rate of liquid nitrogen evaporation from from the freezer when closed.",
			Category -> "Operating Limits"
		},
		HighTemperatureAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The high temperature alarm setpoint on the unit. If the temperature rises above this threshold, an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
		},
		LowLevelAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Inch],
			Units -> Inch,
			Description -> "The low level setting for the liquid nitrogen level, below which an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
		},
		HighLevelAlarm -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Inch],
			Units -> Inch,
			Description -> "The high level setting for the liquid nitrogen level, above which an alarm on the instrument will be triggered.",
			Category -> "Operating Limits"
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
			Pattern :> GreaterP[0 * Inch],
			Units -> Inch,
			Description -> "The threshold liquid nitrogen level that a cryogenic freezer will open an inlet valve and refill the cryogenic freezer.",
			Category -> "Sensor Information"
		},
		Cylinder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder][CryogenicFreezer],
			Description -> "Gas cylinder connected to the inlet of Cryogenic Freezer.",
			Category -> "Instrument Specifications"
		},
		TemperatureControlledResources -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Object[Resource, Sample], Object[Sample], Object[Item], Object[Container], Model[Sample], Model[Item], Model[Container]],
				Alternatives[Object[Protocol], Object[Maintenance], Object[Qualification]]
			},
			Description -> "Resources whose samples are stored in this portable cooler during the execution of the given protocol (if there is no resource for a sample, points to the sample directly).",
			Headers -> {"Resource", "Responsible Protocol"},
			Category -> "Container Specifications"
		},
		TemperatureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Temperature sensor which records the internal temperature of the portable cooler.",
			Category -> "Sensor Information"
		}
	}
}];
