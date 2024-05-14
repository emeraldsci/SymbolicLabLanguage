(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, WasteHandling],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to discard chemical waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		WasteHandlingSafetyEquipment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Model[Part],Object[Container],Object[Instrument]],
			Description -> "The waste handling safety equipment (scan resperators, scan face sheild) the user will be asked to find. Note that this list will be optimized by location such that operators take the shortest path between the objects, starting at the first object in the list.",
			Category -> "General"
		},
		WasteHandlingSafetyEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of WasteHandlingSafetyEquipment, the special information conveyed to the operator regarding the waste handling safety equipment.",
			Category -> "General",
			IndexMatching->WasteHandlingSafetyEquipment
		}
	}
}]