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
		CalibrationResults -> {
			Format -> Multiple,
			Class -> {Expression, Link, Expression},
			Pattern :> {qPCRCalibrationTypeP, _Link, QualificationResultP},
			Relation -> {Null, Object[Calibration][Maintenance], Null},
			Headers -> {"Calibration Type", "Calibration Report", "Result"},
			Description -> "The results of all calibrations performed by this maintenance on the instrument.",
			Category -> "Calibration",
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
