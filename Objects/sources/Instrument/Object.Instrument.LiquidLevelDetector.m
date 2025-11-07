

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, LiquidLevelDetector], {
	Description->"An instrument which implements sonic based liquid level detection in multi-well plates.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		StageDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],StageDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Mean distance from the reading head to the stage.",
			Category -> "Instrument Specifications"
		},
		PedestalDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PedestalDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Mean distance from the reading head to the shallow well plate pedestal.",
			Category -> "Instrument Specifications"
		},
		MinDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The minimum liquid level distance that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		MaxDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDistance]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The maximum liquid level distance that can be measured by this model of instrument.",
			Category -> "Operating Limits"
		},
		MinSensorArmHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSensorArmHeight]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The minimum height that the sensor arm can physically be set to.",
			Category -> "Sensor Information"
		},
		MaxSensorArmHeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSensorArmHeight]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "The maximum height that the sensor arm can physically be set to.",
			Category -> "Sensor Information"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedLiquidLevelDetector],
			Description -> "The liquid handler that is connected to this liquid level detector such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		VolumeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet volume sensor used by this liquid level detector instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		EmptyDistances  -> {
			Format -> Multiple,
			Class -> {Container->Expression, Distance->Expression},
			Pattern :> {Container->_Link,Distance->GreaterP[0*Meter]},
			Relation -> {Container->Model[Container],Distance->Null},
			Description -> "The measured distances between the liquid level detectors sensor and the well-bottom for each compatible container.",
			Category -> "Instrument Specifications",
			Headers -> {Name->"Container", Distribution->"Empty Distance"}
		}
	}
}];
