(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillTransferEnvironment], {
	Description->"A protocol that refills any consumables stored in a given transfer environment (BSC or glove box).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfKimwipes ->{
			Format->Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of full boxes of kimwipes to place in this transfer environment.",
			Category -> "Qualifications & Maintenance"
		},
		NumberOfGloves ->{
			Format->Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of full boxes of gloves to place in this transfer environment.",
			Category -> "Qualifications & Maintenance"
		},
		Pipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette], Object[Instrument,Pipette]],
			Description -> "The pipettes to place in this transfer environment.",
			Category -> "Qualifications & Maintenance"
		},
		Tips-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Tips], Object[Item, Tips]],
			Description -> "The pipette tips to place in this transfer environment.",
			Category -> "Qualifications & Maintenance"
		},
		Gloves-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Consumable], Object[Item, Consumable]],
			Description -> "The gloves to place outside of this transfer environment.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];
