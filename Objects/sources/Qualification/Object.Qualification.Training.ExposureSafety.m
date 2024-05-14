(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Object[Qualification,Training,ExposureSafety], {
	Description -> "A protocol that verifies an operator's ability to locate exposure safety equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ExposureSafetyEquipment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
			Description -> "The exposure safety equipment, which include the spill kit, in the specific order.",
			Category -> "General"
		},
		ExposureSafetyEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of ExposureSafetyEquipment, the special information conveyed to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching -> ExposureSafetyEquipment
		},
		ObjectsFound -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The list of safety equipment that the user found during the training.",
			Category -> "General"
		}
	}
}
]