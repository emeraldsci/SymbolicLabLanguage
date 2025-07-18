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
		},
		RespiratorVerified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a trainer has verified that the trainee is able to correctly put on a respirator.",
			Category -> "General"
		},
		Respirator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part, Respirator], Object[Part, Respirator]],
			Description -> "The respirator the user is asked to find and wear to demonstrate their ability to use the device to properly protect them from hazardous fumes.",
			Category -> "General"
		},
		RespiratorFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,RespiratorFilter], Object[Part, RespiratorFilter]],
			Description -> "The filter that the user is asked to install on the respirator.",
			Category -> "General"
		}
	}
}]