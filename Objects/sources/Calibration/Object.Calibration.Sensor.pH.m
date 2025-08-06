(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, Sensor, pH], {
	Description->"A calibration for converting a Sensornet sensor's raw output to pH measurements.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CalibrationData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration,pH][SensorCalibration],
			Description -> "The pH calibration data (containing calibration buffer, pHSlope and pHOffset) generated from this sensor calibration when using sensornet pH Meter.",
			Category -> "Data Processing"
		}
	}
}];
