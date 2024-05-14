(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[ReactionMechanism], {
	Description->"Model information describing the species and reactions which constitute a reaction pathway.",
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
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model is historical and no longer used in the ECL.",
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
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* --- Model Information --- *)
		Species -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][ReactionMechanisms]|Model[Molecule, Transcript][ReactionMechanisms]|Model[Molecule, cDNA][ReactionMechanisms],
			Description -> "Models describing all of the reagents involved in the chemical reactions of this ReactionMechanism.",
			Category -> "Model Information",
			Abstract -> True
		},
		ReactionMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "A ReactionMechanism construct summarizing the series of reactions that are avaiable to a system of reactants.",
			Category -> "Model Information"
		},
		Reactants -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "All of the reactant species consumed in the reactions making up this ReactionMechanism.",
			Category -> "Model Information",
			Abstract -> True
		},
		Intermediates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "All of the species that exist as both reactants and products in any of the reactions making up this ReactionMechanism.",
			Category -> "Model Information"
		},
		ReactionProducts -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "All of the product species generated in the reactions making up this ReactionMechanism.",
			Category -> "Model Information",
			Abstract -> True
		},
		Reactions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionP,
			Description -> "The list of all the component reactions that make up this ReactionMechanism.",
			Category -> "Model Information"
		},
		ReactionType -> {
			Format -> Single,
			Class -> String,
			Pattern :> ReactionTypeP,
			Description -> "A general short hand descriptor of the reactions involved in this ReactionMechanism.",
			Category -> "Model Information",
			Abstract -> True
		},
		Structures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The secondary structures of all nucleic acid species involved in this ReactionMechanism.",
			Category -> "Model Information"
		},
		Strands -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StrandP,
			Description -> "Nucleic acid strands involved in this ReactionMechanism.",
			Category -> "Model Information"
		},

		(* --- Migration Support --- *)
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
