(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*Domains*)


DefineUsage[Domains,
{
	BasicDefinitions -> {
		{"Domains[plotData,ranges]", "rangedData", "domains cuts the plot data into subsections based on the provided ranges."},
		{"Domains[plotData]", "rangedData", "if given just the plot data, uses the PlotRange Option to determine where to section the data."}
	},
	Input :> {
		{"plotData", _, "The orignal plot data."},
		{"ranges", _, "The set of x-ranges to break up the plot data into."}
	},
	Output :> {
		{"rangedData", _, "The plotData broken up into subsections specified by the ranges."}
	},
	SeeAlso -> {
		"Range",
		"MinMax"
	},
	Author -> {"scicomp", "brad", "Frezza"}
}];


(* ::Subsubsection:: *)
(*ND*)


DefineUsage[ND,
{
	BasicDefinitions -> {
		{"ND[xy]", "out", "compute numerical derivative of xy."}
	},
	Input :> {
		{"xy", {{_?NumericQ,_?NumericQ}..}, "List of points to differentiate."}
	},
	Output :> {
		{"out", {{_?NumericQ,_?NumericQ}..}, "Derivative data."}
	},
	SeeAlso -> {
		"N",
		"D",
		"Derivative"
	},
	Author -> {"scicomp", "brad"}
}];

