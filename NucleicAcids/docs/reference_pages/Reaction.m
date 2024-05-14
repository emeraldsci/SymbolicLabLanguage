(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*Reaction*)


DefineUsage[Reaction,
	{
		BasicDefinitions -> {
			{"Reaction[reactants -> products]", "reaction", "represents an irreversible reaction."},
			{"Reaction[reactants \[Equilibrium] products]", "reaction", "represents a reversible reaction."},
			{"Reaction[reactants,products,forwardRate]", "reaction", "represents an irreversible reaction."},
			{"Reaction[reactants,products,forwardRate,reverseRate]", "reaction", "represents a reversible reaction."}
		},
		Input :> {
			{"reactants", {SpeciesP..}, "The reactants in the reaction."},
			{"products", {SpeciesP...}, "The products in the reaction."},
			{"forwardRate", RateP, "The rate of the forward reaction."},
			{"reverseRate", RateP, "The rate of the reverse reaction."}
		},
		Output :> {
			{"reaction", ReactionP, "A properly formatted reaction."}
		},
		SeeAlso -> {
			"Structure",
			"ReactionMechanism"
		},
		Author -> {"scicomp", "brad", "alice", "qian"}
	}];



(* ::Subsubsection::Closed:: *)
(*SplitReaction*)


DefineUsage[SplitReaction,
	{
		BasicDefinitions -> {
			{"SplitReaction[reversibleReaction]", "{forwardReaction,reverseReaction}", "splits a reversible reaction into separate forward and reverse reactions."},
			{"SplitReaction[irreversibleReaction]", "{irreversibleReaction}", "leaves irreversible reactions alone."}
		},
		MoreInformation-> {
			"This function always returns a list of reactions."
		},
		Input :> {
			{"reversibleReaction", ReactionP, "A reversible reaction."},
			{"irreversibleReaction", ReactionP, "An irreversible reaction."}
		},
		Output :> {
			{"forwardReaction",ReactionP, "The forward reaction in 'reversibleReaction'."},
			{"reverseReaction",ReactionP, "The reverse reaction in 'reversibleReaction'."},
			{"irreversibleReaction",ReactionP, "An irreversible reaction."}
		},
		SeeAlso -> {
			"Reaction",
			"ReactionMechanismQ",
			"StateQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian"}
	}];


(* ::Subsection::Closed:: *)
(*Validity*)


(* ::Subsubsection::Closed:: *)
(*ReactionQ*)


DefineUsage[ReactionQ, {
	BasicDefinitions -> {
		{"ReactionQ[nucleicAcidsReaction]", "bool", "tests that 'nucleicAcidsReaction' is properly formatted, that numeric rates have units consistent with the number of reactants, and that symbolic rates are consistent with the nucleic acid reaction type based on the reactant and product structures."}
	},
	MoreInformation-> {
		"For reactions with numeric rates, the rate units must be consistent with the number of reactants in the reaction.",
		"For reactions with symbolic rates, the rates must be consistent with the reactant and product structures."
	},
	Input :> {
		{"nucleicAcidsReaction", ReactionP, "Nucleic acids reaction to validate."}
	},
	Output :> {
		{"bool", BooleanP, "True if reaction is valid.  Otherwise, False."}
	},
	SeeAlso -> {
		"Reaction",
		"ClassifyReaction",
		"SimulateReactivity",
		"ReactionMechanism"
	},
	Author -> {
		"alice",
		"brad",
		"qian"
	}
}];


(* ::Subsection::Closed:: *)
(*Classification*)


(* ::Subsubsection::Closed:: *)
(*ClassifyReaction*)


DefineUsage[ClassifyReaction, {
	BasicDefinitions -> {
		{"ClassifyReaction[reactants, products]", "reactionType", "given a set of nucleic acid reactants and products, determines the classical type of a nucleic acid secondary structure transformation involved in parameterizing its kinetic behavior."}
	},
	MoreInformation -> {
		"Definitions of reaction classifications can be found in Object[Report, Literature, \"id:XnlV5jmalqMZ\"]: Frezza. \"Orchestration of Molecular Information through Higher Order Chemical Recognition.\""
	},
	Input :> {
		{"reactants", {StructureP..}, "Nucleic acids reactant structures."},
		{"products", {StructureP..}, "Nucleic acids product structures."}
	},
	Output :> {
		{"reactionType", NucleicAcidReactionTypeP, "The type of nucleic acids reaction."}
	},
	SeeAlso -> {
		"ReactionQ",
		"Reaction"
	},
	Tutorials -> {
		"Reactions and Rates"
	},
	Author -> {
		"alice",
		"brad"
	}
}];