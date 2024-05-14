(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Model[Qualification,Training,SafeStorage], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate safe storage equipment.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SafeStorageEquipment -> {
			Units -> None,
			Relation -> Model[Container],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The equipment models, which include an ambient flammable cabinets, acid cabinets and base cabinets, that operators will be asked to find on their ECL site.",
			Category -> "General"
		},
		ProvidedStorageCondition -> {
			Units -> None,
			Relation -> Model[StorageCondition],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The storage condition models, which include flammable condition, acid and base, will be used to create an instruction rule in qualification protocol.",
			Category -> "General"
		},
		StorageConditionInstructions -> {
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of ProvidedStorageCondition, the instruction to convey to the operator regarding how the equipment should be found and scanned.",
			Category -> "General",
			IndexMatching -> ProvidedStorageCondition
		}
	}
}
]