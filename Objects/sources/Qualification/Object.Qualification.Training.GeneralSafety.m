(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: adam.abushaer, jihan.kim *)
(* :Date: 2023-6-18 *)

DefineObjectType[Object[Qualification,Training,GeneralSafety], {
	Description -> "A protocol that verifies an operator's ability to locate the general safety equipment.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		GeneralSafetyEquipment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
			Description -> "The general safety equipment, which include fire extinguishers and alarms, that operators will be asked to find on their ECL site.",
			Category -> "General"
		},
		GeneralSafetyEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of GeneralSafetyEquipment, the special information conveyed to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching->GeneralSafetyEquipment
		},
		ObjectsFound -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The list of general safety equipment that the user found during the training.",
			Category -> "General"
		}
	}
}
]