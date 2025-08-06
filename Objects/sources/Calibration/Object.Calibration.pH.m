(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration, pH], {
	Description->"A calibration for converting raw electrical signal(amperometric/potentiomeric) into the pH signal.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,MeasurepH][CalibrationData],
				Object[Protocol,AdjustpH][CalibrationData],
				Object[Qualification,pHMeter][CalibrationData]
			],
			Description -> "The protocol that generated this data.",
			Category -> "General",
			Abstract -> True
		},
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,pHProbe],
			Description -> "The designated probe that this calibration is intended to service.",
			Category -> "Qualifications & Maintenance"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,pHMeter],
			Description -> "The designated conductivity device on which this was performed.",
			Category -> "Qualifications & Maintenance"
		},
		AnalyteData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, pH][CalibrationData],
			Description -> "All sample data associated with this calibration.",
			Category -> "General"
		},
		LowCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The pH 4 reference buffers used to calibrate the pH droplet probe used.",
			Category -> "General"
		},
		LowCalibrationTargetpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The desired pH for the lowest pH standard.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		LowCalibrationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The recorded temperature of the low pH calibration standard during the course of the calibration.",
			Category -> "Qualifications & Maintenance"
		},
		MediumCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The pH 7 reference buffers used to calibrate the pH probe used.",
			Category -> "General"
		},
		MediumCalibrationTargetpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The desired pH for the middle pH standard.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		MediumCalibrationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The recorded temperature of the low pH calibration standard during the course of the calibration.",
			Category -> "Qualifications & Maintenance"
		},
		HighCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The pH 10 reference buffers used to calibrate the pH probe used.",
			Category -> "General"
		},
		HighCalibrationTargetpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The desired pH for the high pH standard.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		HighCalibrationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The recorded temperature of the low pH calibration standard during the course of the calibration.",
			Category -> "Qualifications & Maintenance"
		},
		pHOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Milli*Volt],
			Units -> Milli*Volt,
			Description -> "The y-intercept of the fitted slope.",
			Category -> "Qualifications & Maintenance"
		},
		AbsolutepHSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The electrode response to the target ion displayed as a percentage of the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
			Category -> "Qualifications & Maintenance"
		},
		RelativepHSlope -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage difference between the AbsolutepHSlope and the theoretical value. When the temperature is 25 °C, the theoretical value is 59.16 mV per pH unit, as calculated using the Nernst equation.",
			Category -> "Qualifications & Maintenance"
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "The file containing data collected during the conductivity calibration.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		SensorCalibration -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Sensor, pH][CalibrationData],
			Description -> "The sensor calibration data (containing raw data and fit analysis) when calibrating sensornet pH Meter.",
			Category -> "General"
		}
	}
}];
