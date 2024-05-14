(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, LightObscurationSensor], {
	Description->"A light obscuration sensor that measures the reduction in light intensity and processes the signal to determine particle size and count.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		NominalFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter/ Minute],
			Units -> Milliliter/ Minute,
			Description -> "The speed at which the instrument sensor was calibrated. Once calibrated instrument must operate at this flow rate in order to properly read the signal.",
			Category -> "Instrument Specifications"
		},
		CurrentCalibration ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, LightObscuration],
			Description -> "The current sensor calibration fit into calibrations standard particle sizes used to calculate the samples particle count.",
			Category -> "Qualifications & Maintenance"
		},
		CalibrationLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation ->{Null, Object[Calibration, LightObscuration]},
			Description -> "A list of all the calibrations that were performed on this sensor.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date", "Calibration Object"}
		}
	}
}];
