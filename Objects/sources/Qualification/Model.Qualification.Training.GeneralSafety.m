(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: adam.abushaer, jihan.kim *)
(* :Date: 2023-6-18 *)

DefineObjectType[Model[Qualification,Training,GeneralSafety], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate the general safety equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		GeneralSafetyEquipment -> {
				Units -> None,
				Relation -> Model[Item] | Model[Part] | Model[Container] | Model[Instrument],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The general safety equipment model, which includes fire extinguishers and alarms, will be utilized for searching objects based on the ECL site.",
				Category -> "General"
				},
		GeneralSafetyEquipmentInstructions -> {
				Units -> None,
				Relation -> Null,
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of GeneralSafetyEquipment, the instrction to convey to the operator regarding how the equipment should be found and scanned.",
				Category -> "General",
				IndexMatching -> GeneralSafetyEquipment
				}
	}
}
]