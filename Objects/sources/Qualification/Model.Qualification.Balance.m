(* ::Package:: *)

DefineObjectType[Model[Qualification,Balance], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a balance.",
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
			Description -> "The calibration weights used to qualify the balance.",
			Category -> "General"
		}
	}
}];
