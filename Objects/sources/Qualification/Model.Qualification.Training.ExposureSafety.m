(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Model[Qualification,Training,ExposureSafety], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate exposure safety equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ExposureSafetyEquipment -> {
			Units -> None,
			Relation -> Alternatives[Model[Item],Model[Part],Model[Container],Model[Instrument]],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The exposure safety equipment, include the spill kit, that the user will be asked to find on their ECL site.",
			Category -> "General"
		},
		ExposureSafetyEquipmentInstructions -> {
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of ExposureSafetyEquipment, the instruction to convey to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching -> ExposureSafetyEquipment
		}
	}
}
]