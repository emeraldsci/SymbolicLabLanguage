(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Decontaminate, WaterPurifier],{
	Description->"A protocol that decontaminates the membrane of a water purifier.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		MembraneCleaningSlot->{Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Slot name of where the decontaminating reagent is placed to clean the membrane.",
			Category->"General"
		},
		(*---Decontaminating---*)
		DecontaminatingReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"The decontaminating reagent used to decontaminate the water purifier.",
			Category->"Decontaminating"
		},
		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tweezer],
				Object[Item, Tweezer]
			],
			Description -> "The tweezers used for handling the decontaminating reagent.",
			Category -> "Decontaminating"
		}
	}
}
]