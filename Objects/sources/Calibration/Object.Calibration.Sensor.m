(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, Sensor], {
	Description->"A calibration for converting a Sensornet sensor's raw output into meaningful physical quantities.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Target -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sensor][Calibration]	
			],
			Description -> "The designated object that this sensor calibration is intended to service.",
			Category -> "General"
		}
	}
}];
