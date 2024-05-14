(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateAutosampler], {
	Description->"A protocol that calibrates the grippers of the autosampler deck on a microwave instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CalibrationDevice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part]
			],
			Description -> "The device used to calibrate the gripper settings.",
			Category -> "General"
		}
	}
}];