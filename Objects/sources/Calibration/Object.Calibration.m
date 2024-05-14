(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Calibration], {
	Description->"A calibration performed on an instrument or model",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A unique name for this calibration.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who generated this calibration.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Maintenance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Maintenance, CalibrateVolume][VolumeCalibration],
				Object[Maintenance, CalibratePathLength][PathLengthCalibration],
				Object[Maintenance, CalibrateLLD][SensorCalibration],
				Object[Protocol]
			],
			Description -> "The recurring maintenance that generated this calibration.",
			Category -> "Organizational Information"
		},
		ManufacturerCalibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this calibration's fit function was provided by a manufacturer.",
			Category -> "Qualifications & Maintenance"
		},
		Reference -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {NumericP..}|_?QuantityVectorQ,
			Units -> None,
			Description -> "The set of known data to which the response data points are calibrated.",
			Category -> "Qualifications & Maintenance"
		},
		Response -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {NumericP..}|_?QuantityVectorQ,
			Units -> None,
			Description -> "The set of unknown, measured data points that are calibrated to the reference data points.",
			Category -> "Qualifications & Maintenance"
		},
		Anomalous -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this calibration fell substantially out of historic values and must be investigated before being put into use in calculating measurements.",
			Category -> "Qualifications & Maintenance"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this calibration object is historical and would generate invalid data if used in the lab.",
			Category -> "Organizational Information"
		},
		CalibrationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "The pure function that represents the raw calibration fit between the reference and response data points.",
			Category -> "Analysis & Reports"
		},
		CalibrationStandardDeviationFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes single prediction error from a given x-value.  Single prediction error is the expected error between a predicted y-value and a single obersvation of that value.",
			Category -> "Analysis & Reports"
		},
		CalibrationDistributionFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "A function that computes single prediction distribution from a given x-value.",
			Category -> "Analysis & Reports"
		},
		FitAnalysis -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Fit],
			Description -> "The fit analysis performed on this calibration data to generate the calibration function.",
			Category -> "Analysis & Reports"
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
