(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibratePlateReader], {
	Description -> "A protocol that calibrates a plate reader.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		CalibrationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack], Object[Container, Rack],
				Model[Container, Plate], Object[Container, Plate]
			],
			Description -> "Indicates the plate used to calibrate the target plate reader.",
			Category -> "General",
			Abstract -> True
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
			Category -> "General",
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
		}
	}
}];
