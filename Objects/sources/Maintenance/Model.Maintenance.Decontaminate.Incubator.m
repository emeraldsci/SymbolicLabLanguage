(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Decontaminate, Incubator], {
	Description -> "Definition of a set of parameters for a maintenance protocol that decontaminates an incubator interior.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		DrainReservoir -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the reservoir container needs to be drained during the maintenance.",
			Category -> "General"
		},
		ReservoirDeckSlotName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Slot name of where reservoir container for the model of incubator.",
			Category -> "General"
		},
		RefillRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the reservoir container needs to be refilled during the maintenance.",
			Category -> "General"
		},
		RemovableIncubatorDeck -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the model of incubator storage deck can be removed from its location.",
			Category -> "General"
		},
		ContentsStorageLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "Location name of a position where plate containers are stored inside this model of incubator.",
			Category -> "General",
			Developer -> True
		},
		ProgrammedDecontaminateRoutine -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the model of incubator has programmed decontaminate and autostart routines.",
			Category -> "General"
		},
		(* --- Draining --- *)
		Aspirator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Aspirator]|Model[Part, HandPump],
			Description -> "Model of aspirator instrument used to drain this model of incubator.",
			Category -> "Draining"
		},
		AspiratorTip -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Tips],
			Description -> "Model of tip connected to the aspirator used to empty this model of incubator.",
			Category -> "Draining",
			Developer -> True
		},
		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Tweezer],
			Description -> "Model of tweezers to remove the cotton from the tip connected to the aspirator used to empty this model of incubator.",
			Category -> "Draining",
			Developer -> True
		},
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Model of container with the volume capacity to store waste liquid from this model of incubator for disposal.",
			Category -> "Draining"
		},
		Chemwipe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Consumable],
			Description -> "The wipe model (such as sterile cloth) that is used to remove excess liquid from this model of incubator.",
			Category -> "Draining"
		},
		(* --- Decontaminating --- *)
		DecontaminatingReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of decontaminating reagent used to decontaminate this model of incubator.",
			Category -> "Decontaminating"
		},
		DecontaminatingReagentVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of liquid used to decontaminate this model of incubator.",
			Category -> "Decontaminating"
		},
		DecontaminatingReagentContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that is used to transfer decontaminating reagent to decontaminate this model of incubator.",
			Category -> "Decontaminating"
		}
	}
}];
