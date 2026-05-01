(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibrateThermocycler], {
	Description -> "A protocol that calibrates a thermocycler.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		CalibrationPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the plate(s) used to calibrate the target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		CalibrationResults ->{
			Format->Multiple,
			Class->{Expression,Link,Expression},
			Pattern:>{qPCRCalibrationTypeP,_Link,QualificationResultP},
			Relation->{Null,Object[Calibration][Maintenance],Null},
			Headers->{"Calibration Type","Calibration Report","Result"},
			Description->"The results of all calibrations performed by this maintenance on the instrument.",
			Category->"Calibration"
		},
		BackgroundCalibrationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the Background calibration plate used to calibrate the target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		BackgroundCalibrationReportFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path where the background calibration report is located.",
			Category -> "General",
			Developer -> True
		},
		ROICalibrationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the ROI plate used to calibrate the target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		ROICalibrationReportFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the Region of Interest (ROI) calibration report is located.",
			Category -> "General",
			Developer -> True
		},
		UniformityCalibrationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the Uniformity plate used to calibrate the target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		UniformityCalibrationReportFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the background calibration report is located.",
			Category -> "General",
			Developer -> True
		},
		DyeCalibrationPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the plate(s) used to calibrate the spectral wavelengths the dyes used with target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		DyeCalibrationReportFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the dye calibration reports are located.",
			Category -> "General",
			Developer -> True
		},
		NormalizationCalibrationPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the plate(s) used to calibrate the normalization wavelengths when using multiple dyes on the target thermocycler.",
			Category -> "General",
			Abstract -> True
		},
		NormalizationCalibrationReportFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the normalization calibration reports are located.",
			Category -> "General",
			Developer -> True
		},
		RetryCalibrationReportFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the retry calibration reports are located.",
			Category -> "General",
			Developer -> True
		},
		CalibrationResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the result of the instrument calibration.",
			Category -> "General",
			Abstract -> True
		},
		CalibrationReportFolderPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "Address of the folder used to store the calibration report files.",
			Category -> "Organizational Information",
			Developer -> True
		},
		CalibrationReportFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths where the calibration reports are located.",
			Category -> "General",
			Developer -> True
		},
		CalibrationReportFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The calibration report files from the instrument software.",
			Category -> "General",
			Developer -> True
		},
		AssayPlateThermalBlock->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part],Object[Part]],
			Description->"The thermal cycling block for the 384-well plate.",
			Category->"Sample Loading",
			Developer->True
		},
		AssayPlateTray->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The thermal cycling tray that holds the 384-well plate.",
			Category->"Sample Loading",
			Developer->True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "A field designating the instrument that should be used for protocol sub-procedures that require the Instrument field to be populated.",
			Category -> "General",
			Abstract -> True
		},
		CurrentLampHours -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0*Hour],
			Description -> "The number of hours that the instrument's lamp's has been used.",
			Category -> "Instrument Parameters"
		},
		RetryBackgroundCalibrationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "Indicates the retry background calibration plate used to calibrate the target thermocycler.",
			Category -> "Retry",
			Abstract -> True
		}
	}
}];
