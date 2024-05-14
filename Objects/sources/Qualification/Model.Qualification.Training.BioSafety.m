(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Model[Qualification,Training,BioSafety], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate and identify biosafety cabinets and related equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		BioSafetyEquipment->{
			Units -> None,
			Relation -> Alternatives[Model[Item],Model[Part],Model[Container],Model[Instrument]],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The equipment models, which include biosafety cabinets and biohazard waste containers, that operators will be asked to find on their ECL site.",
			Category -> "General"
		},
		BioSafetyEquipmentInstructions->{
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of BioSafetyEquipment, the instruction to convey to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching -> BioSafetyEquipment
		}
	}
}
]