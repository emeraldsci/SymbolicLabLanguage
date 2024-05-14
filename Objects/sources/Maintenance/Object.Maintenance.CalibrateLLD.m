(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibrateLLD], {
	Description->"A protocol that generates a new calibration function for an ultrasonic liquid level detector.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Distances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distances at which to set the sensor arm height of the LLD in order to calibrate the instrument.",
			Category -> "General"
		},
		Readings -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of distances, the raw readings from the liquid level detector.",
			Category -> "General"
		},
		RawReadings -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of distances, the data containing the raw ultrasonic distance measurements. Readings in mm do not correspond to real distances as a test calibration is used.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SensorCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration][Maintenance],
			Description -> "The sensor reading to distance calibration generated using the data created by this maintenance.",
			Category -> "Experimental Results"
		},
		Qualification -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,LiquidLevelDetector],
			Description -> "The qualification protocol run after calibration to verify it.",
			Category -> "Experimental Results"
		},
		TareDistance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The data containing the ultrasonic distance measurement with no gage blocks underneath the sensor, for calibrations that use gage blocks only.",
			Category -> "Experimental Results"
		},
		SensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Millimeter],
			Units -> Millimeter,
			Description -> "The height to raise or lower the ultrasonic sensor to prior to taking any measurements, for calibrations that use gage blocks only.",
			Category -> "General"
		},
		HeightGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part,HeightGauge]|Object[Part,HeightGauge]),
			Description -> "The digital height gauge used to set known distances from the sensor.",
			Category -> "General"
		}
	}
}];
