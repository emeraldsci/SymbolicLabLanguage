(* ::Package:: *)

DefineObjectType[Model[Maintenance,CalibrateBalance], {
	Description -> "Definition of a set of parameters for a maintenance protocol that calibrates a Balance.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		CalibrationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight]
			],
			Description -> "The weights used to calibrate the balance.",
			Category -> "General"
		},
		ValidationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight]
			],
			Description -> "The weights used to validate the balance calibration.",
			Category -> "General"
		}

	}
}];
