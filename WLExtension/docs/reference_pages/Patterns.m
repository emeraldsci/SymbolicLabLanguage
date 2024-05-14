(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Help Files*)


(* ::Subsection:: *)
(*Generic patterns*)


(* ::Subsubsection::Closed:: *)
(*NullQ*)


DefineUsage[NullQ,
{
	BasicDefinitions->{
		{"NullQ[expression]","bool","returns True if 'expression' matches NullP."}
	},
	MoreInformation->{},
	Input:>{
		{"expression",_,"Expression to check for nested list of Nulls."}
	},
	Output:>{
		{"bool",True|False,"True or False."}
	},
	SeeAlso->{"SafeEvaluate","ToList"},
	Author->{"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*InfiniteNumericQ*)


DefineUsage[InfiniteNumericQ,
{
	BasicDefinitions -> {
		{"InfiniteNumericQ[val]", "out", "returns true if the input is either numeric, \[Infinity], or -\[Infinity]."}
	},
	Input :> {
		{"val", _?NumericQ | Infinity | -Infinity, "Data to test."}
	},
	Output :> {
		{"out", True | False, "True if input is numeric or \[Infinity], False otherwise."}
	},
	SeeAlso -> {
		"NumericQ",
		"MatchQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(* PatternUnion *)


DefineUsage[PatternUnion,
{
	BasicDefinitions -> {
		{"PatternUnion[patterns]", "resultPattern", "given a sequence of patterns, return a single pattern which matches all of them."}
	},
	Input :> {
		{"patterns", __Pattern, "Patterns to combine."}
	},
	Output :> {
		{"resultPattern", _Pattern, "A pattern which matches expressions matching all input patterns."}
	},
	SeeAlso -> {
		"MatchQ",
		"Alternatives",
		"PatternTest"
	},
	Author -> {
		"platform"
	}
}];