(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ReactionMechanism*)


DefineUsage[ReactionMechanism,
	{
		BasicDefinitions -> {
			{"ReactionMechanism[reaction..]", "reactionMechanism", "represents a ReactionMechanism containing a set of reactions."}
		},
		MoreInformation-> {
			"Use Keys[state] to see the properties that can be dereferenced from a ReactionMechanism.",
			"Dereference properties using reactionMechanism[property], e.g. reactionMechanism[Species]."
		},
		Input :> {
			{"reaction", ReactionP, "A reaction."}
		},
		Output :> {
			{"reactionMechanism", ReactionMechanismP, "A ReactionMechanism."}
		},
		SeeAlso -> {
			"SimulateReactivity",
			"State",
			"MechanismFirst",
			"ReactionMechanismQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection:: *)
(*MechanismFirst*)


DefineUsage[MechanismFirst,
{
	BasicDefinitions -> {
		{"MechanismFirst[in]", "out", "returns the first reaction from 'in'."}
	},
	Input :> {
		{"in", ReactionMechanismP, "A ReactionMechanism."}
	},
	Output :> {
		{"out", ReactionP, "The first reaction from 'in'."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"ReactionMechanismQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*MechanismJoin*)


DefineUsage[MechanismJoin,
{
	BasicDefinitions -> {
		{"MechanismJoin[mech1,mech2]", "mech", "join two mechanisms together and delete redundant reactions."},
		{"MechanismJoin[mechs]", "mech", "join multiple of mechanisms together, deleting redundant reactions."}
	},
	MoreInformation -> {
		"Splits reactions and sorts structures before deleting duplicates."
	},
	Input :> {
		{"mech1", ReactionMechanismP, "A ReactionMechanism."},
		{"mech2", ReactionMechanismP, "A ReactionMechanism."},
		{"mechs", ReactionMechanismP..., "A sequence of mechanisms."}
	},
	Output :> {
		{"mech", ReactionMechanismP, "A ReactionMechanism containing all the reactions from 'mech1' and 'mech2', with duplicates deleted."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"ReactionMechanismQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*MechanismLast*)


DefineUsage[MechanismLast,
{
	BasicDefinitions -> {
		{"MechanismLast[in]", "out", "returns the last reaction from 'in'."}
	},
	Input :> {
		{"in", ReactionMechanismP, "A ReactionMechanism."}
	},
	Output :> {
		{"out", ReactionP, "The last reaction from 'in'."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"ReactionMechanismQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*MechanismMost*)


DefineUsage[MechanismMost,
{
	BasicDefinitions -> {
		{"MechanismMost[in:ReactionMechanismP]", "out:ReactionMechanismP", "returns a ReactionMechanism containing the Most of the reactions from 'in'."}
	},
	Input :> {
		{"in", ReactionMechanismP, "A ReactionMechanism."}
	},
	Output :> {
		{"out", ReactionMechanismP, "A ReactionMechanism containing the Most of the reactions from 'in'."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"ReactionMechanismQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*ReactionMechanismQ*)


DefineUsage[ReactionMechanismQ,
{
	BasicDefinitions -> {
		{"ReactionMechanismQ[in]", "bool", "checks if 'in' is a properly formatted ReactionMechanism."}
	},
	Input :> {
		{"in", _, "Something that might be a ReactionMechanism."}
	},
	Output :> {
		{"bool", BooleanP, "True if 'in' is a properly formatted ReactionMechanism."}
	},
	SeeAlso -> {
		"ToReactionMechanism",
		"MechanismJoin"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*MechanismRest*)


DefineUsage[MechanismRest,
{
	BasicDefinitions -> {
		{"MechanismRest[in:ReactionMechanismP]", "out:ReactionMechanismP", "returns a ReactionMechanism containing the Rest of the reactions from 'in'."}
	},
	Input :> {
		{"in", _, "A ReactionMechanism."}
	},
	Output :> {
		{"out", _, "A ReactionMechanism containing the Rest of the reactions from 'in'."}
	},
	SeeAlso -> {
		"ReactionMechanismQ",
		"MechanismJoin"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];