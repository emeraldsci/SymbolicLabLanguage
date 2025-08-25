

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, Decontaminate, WaterPurifier],  {
	Description -> "Definition of a set of parameters for a maintenance protocol that decontaminates the membrane of a water purifier.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		MembraneCleaningSlot -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The instrument's slot for inserting the decontaminating Reagent.",
			Category -> "Decontaminating"
		},
		(* Decontaminating *)
		DecontaminatingReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of sample used for decontaminating the water purifier's membrane.",
			Category -> "Decontaminating"
		},
		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Tweezer],
			Description -> "The model of tweezers used for handling the decontaminating reagent.",
			Category -> "Decontaminating"
		}
	}
}];