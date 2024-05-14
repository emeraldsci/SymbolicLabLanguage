(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification, Training, WasteHandling],{
	Description->"A protocol that verifies an operator's ability to discard chemical waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		WasteHandlingSafetyEquipment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Model[Part],Object[Container],Object[Instrument]],
			Description -> "The waste handling safety equipment (scan resperators, scan face sheild) the user will be asked to find in order (optimized by the QualificationUserFunction).",
			Category -> "General"
		},
		WasteHandlingSafetyEquipmentInstructions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of WasteHandlingSafetyEquipment, the special information conveyed to the operator regarding the waste handling safety equipment.",
			Category -> "General",
			IndexMatching->WasteHandlingSafetyEquipment
		},
		DrumEmptyWasteSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample that will be used to test the user's ability to empty waste into the waste handling drums.",
			Category -> "General"
		},
		LiquidWasteSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample that will be used to test the user's ability to empty waste into the liquid waste in the fumehood.",
			Category -> "General"
		}
	}
}]