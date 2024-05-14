(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim*)

DefineObjectType[Object[Qualification,Training,SafeStorage], {
	Description -> "A protocol that verifies an operator's ability to locate safe storage equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SafeStorageEquipment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The storage containers, including flammable cabinets, acid cabinets and base cabinets, that operators will be asked to find on their ECL site.",
			Category -> "General"
		},
		SafeStorageEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SafeStorageEquipment, the special information conveyed to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching->SafeStorageEquipment
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