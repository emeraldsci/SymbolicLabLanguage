(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, GasCylinder], {
	Description->"A vessel used to store gases at high pressure.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxCapacity]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The maximum storage capacity of this model gas cylinder.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum operating pressure of this model gas cylinder.",
			Category -> "Operating Limits"
		},
		LiquidLevelGauge -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], LiquidLevelGauge]],
			Pattern :> BooleanP,
			Description -> "Indicates if this gas cylinder model has a gauge that shows fill level of the cylinder.",
			Category -> "Container Specifications"
		},
		PlumbingImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], PlumbingImageFile]],
			Pattern :> ImageFileP,
			Description -> "A photo of the plumbing on top of this gas cylinder.",
			Category -> "Container Specifications",
			Developer->True
		},
		PressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used to monitor gas cylinder's internal pressure.",
			Category -> "Sensor Information"
		},
		GasFlowSwitch->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation-> Alternatives[
				Object[Instrument, GasFlowSwitch][RightCylinder],
				Object[Instrument, GasFlowSwitch][LeftCylinder]
			],
			Description->"Gas Flow Switch used to monitor, control, and switch the flow of gas depending on pressure.",
			Category->"Sensor Information"
		},
		GasType->{
			Format->Single,
			Class->Expression,
			Pattern:>GasP,
			Description->"The type of gas contained by this cylinder.",
			Category->"Container Specifications"
		},
		LiquidLevelSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Liquid level sensor used to monitor cryogenic freezer's liquid nitrogen level.",
			Category -> "Sensor Information"
		},
		CryogenicFreezer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> {
				Object[Instrument, CryogenicFreezer][Cylinder],
				Object[Instrument, PortableCooler][Cylinder]
			},
			Description -> "Cryogenic Freezer connected to the gas cylinder.",
			Category -> "Sensor Information"
		}
	}
}];
