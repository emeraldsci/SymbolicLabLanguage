(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*State*)


DefineUsage[State,
	{
		BasicDefinitions -> {
			{"State[s]", "state", "represents a state containing species and their concentrations."}
		},
		MoreInformation-> {
			"Use Keys[state] to see the properties that can be dereferenced from a state.",
			"Dereference properties using state[property], e.g. state[Magnitudes].",
			"Extract species concentrations using state[species]"
		},
		Input :> {
			{"s", {{SpeciesP,UnitsP[]}..}, "Pairs of species and concentration."}
		},
		Output :> {
			{"state", StateP, "A state."}
		},
		SeeAlso -> {
			"StateRest",
			"ToState",
			"StateLast",
			"StateQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection::Closed:: *)
(*StateFirst*)


DefineUsage[StateFirst,
{
	BasicDefinitions -> {
		{"StateFirst[s]", "{var, conc}", "extracts the first {name,concentration} pair from the state 's'."}
	},
	Input :> {
		{"s", StateP, "State to pull the frist element of."}
	},
	Output :> {
		{"var", _, "Variable/Structure name."},
		{"conc", _, "Concentration of 'var'."}
	},
	SeeAlso -> {
		"StateRest",
		"ToState",
		"StateLast",
		"StateQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StateLast*)


DefineUsage[StateLast,
{
	BasicDefinitions -> {
		{"StateLast[s]", "{var, conc}", "extract the last {name,concentration} pair from the state 's'."}
	},
	Input :> {
		{"s", StateP, "A state."}
	},
	Output :> {
		{"var", _, "Variable/Structure name."},
		{"conc", _, "Concentration of 'var'."}
	},
	SeeAlso -> {
		"StateFirst",
		"ToState",
		"StateQ",
		"StateMost"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StateMost*)


DefineUsage[StateMost,
{
	BasicDefinitions -> {
		{"StateMost[s]", "out", "returns a state 'out' containing all but the last element of input state 's'."}
	},
	Input :> {
		{"s", StateP, "A state."}
	},
	Output :> {
		{"out", StateP, "A state containing the Most of the state 's'."}
	},
	SeeAlso -> {
		"StateFirst",
		"ToState",
		"StateQ",
		"StateRest"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StateQ*)


DefineUsage[StateQ,
{
	BasicDefinitions -> {
		{"StateQ[s]", "bool", "checks if 's' is a properly formatted state."}
	},
	Input :> {
		{"s", _, "A state."}
	},
	Output :> {
		{"bool", True | False, "True or False."}
	},
	SeeAlso -> {
		"StateFirst",
		"ToState",
		"StateRest",
		"StructureQ",
		"ReactionMechanismQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StateRest*)


DefineUsage[StateRest,
{
	BasicDefinitions -> {
		{"StateRest[s]", "out", "returns a state 'out' containing all but the first element of input state 's'."}
	},
	Input :> {
		{"s", StateP, "A state."}
	},
	Output :> {
		{"out", StateP, "A state containing the Rest of the state 's'."}
	},
	SeeAlso -> {
		"StateFirst",
		"StateQ",
		"ToState"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];