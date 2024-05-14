(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Species], {
	Description->"Model information for an animal, plant, fungi, or unicellular microorganism.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this model goes by.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The people who created this model.",
			Category -> "Organizational Information"
		},
		Cells -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Cell][Species],
			Description -> "The cells that comprise this specices.",
			Category -> "Organizational Information"
		},
		Bacteria -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Cell,Bacteria][Hosts],
			Description -> "The strains of bacteria that this species carries.",
			Category -> "Organizational Information"
		},
		Tissues -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Tissue][Species],
			Description -> "The tissues that are found in this species.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* --- Inventory ---*)
		DefaultSampleModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
			Category -> "Inventory"
		},

		ReferenceImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Reference images exemplifying the typical appearance of this organism.",
			Category -> "Experimental Results"
		}
	}
}];
