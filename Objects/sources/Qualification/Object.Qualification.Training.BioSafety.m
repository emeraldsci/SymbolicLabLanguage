(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim*)

DefineObjectType[Object[Qualification,Training,BioSafety], {
	Description->"A protocol that verifies an operator's ability to locate and identify biosafety cabinets and related equipment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BioSafetyEquipment->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
			Description -> "The biosafety equipment, which include biosafety cabinet and biohazard waste container, that operators will be asked to find on their ECL site.",
			Category -> "General"
		},
		BioSafetyEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of BioSafetyEquipment, the special information conveyed to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching->BioSafetyEquipment
		},
		ObjectsFound->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The list of biosafety equipment that the user found during the training.",
			Category -> "General"
		}
	}
}
]