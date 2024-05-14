

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Sensor, Volume], {
	Description->"Device for measuring Volume.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "Maximum volume that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVolume]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "Minimum volume that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MaxDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDistance]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "In the case of volume sensors using UltrasonicDistance as measurement method, maximum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MonitoredLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][VolumeSensors, 2]
			],
			Description -> "The Instrument or Container that this sensor is currently monitoring.",
			Category -> "Sensor Information"
		},
		MinDistance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinDistance]],
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Description -> "In the case of volume sensors using UltrasonicDistance as measurement method, minimum distance that can be reliably read by this model of sensor.",
			Category -> "Sensor Information",
			Abstract -> True
		}
	}
}];
