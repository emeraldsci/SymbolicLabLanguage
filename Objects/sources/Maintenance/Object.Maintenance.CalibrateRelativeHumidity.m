

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateRelativeHumidity], {
	Description->"A protocol that generates a calibration converting a sensor's raw output to relative humidity measurements.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CalibrationFitFunction -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> _Function,
			Units -> None,
			Description -> "Fit function that calculates the sensor output as a function of raw input.",
			Category -> "General"
		},
		ManufacturerCalibration -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ManufacturerCalibration]],
			Pattern :> BooleanP,
			Description -> "Indicates that the calibration function for this sensor is provided by sensor's manufacturer or a calibration service company.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
