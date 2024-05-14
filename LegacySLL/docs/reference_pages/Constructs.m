(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*fitFieldToFitSourceField*)


DefineUsage[fitFieldToFitSourceField,
{
	BasicDefinitions -> {
		{"fitFieldToFitSourceField[type, fitField]", "fitSourceField", "returns the FitSource field ('fitSourceField') that corresponds to the 'fitField' for the given 'type'."},
		{"fitFieldToFitSourceField[type, fitField]", "$Failed", "returns $Failed if there is no 'fitField' for the given 'type'."}
	},
	Input :> {
		{"type", TypeP[], "An SLL Type."},
		{"fitField", FieldP[Output->Short], "An SLL Fit Field."}
	},
	Output :> {
		{"fitSourceField", FieldP[Output->Short], "An SLL FitSource Field."}
	},
	SeeAlso -> {
		"TypeP",
		"FieldP"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*peaksFieldToPeaksSourceField*)


DefineUsage[peaksFieldToPeaksSourceField,
{
	BasicDefinitions -> {
		{"peaksFieldToPeaksSourceField[type, peaksField]", "peaksSourceField", "returns the PeaksSource field ('peaksSourceField') that corresponds to the 'peaksField' for the given 'type'."},
		{"peaksFieldToPeaksSourceField[type, peaksField]", "$Failed", "returns $Failed if there is no 'peaksField' for the given 'type'."}
	},
	Input :> {
		{"type", TypeP[], "An SLL Type."},
		{"peaksField", FieldP[Output->Short], "An SLL Peaks Field."}
	},
	Output :> {
		{"peaksSourceField", FieldP[Output->Short], "An SLL PeaksSource Field."}
	},
	SeeAlso -> {
		"TypeP",
		"FieldP"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*typeToPeaksFields*)


DefineUsage[typeToPeaksFields,
{
	BasicDefinitions -> {
		{"typeToPeaksFields[type]", "fields", "returns a list of Peaks 'fields' for the given 'type'."}
	},
	Input :> {
		{"type", TypeP[], "An SLL Type."}
	},
	Output :> {
		{"fields", {FieldP[Output->Short]...}, "A list of SLL Fields."}
	},
	SeeAlso -> {
		"TypeP",
		"FieldP"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*typeToPeaksSourceFields*)


DefineUsage[typeToPeaksSourceFields,
{
	BasicDefinitions -> {
		{"typeToPeaksSourceFields[type]", "fields", "returns a list of PeaksSource 'fields' for the given 'type'."}
	},
	Input :> {
		{"type", TypeP[], "An SLL Type."}
	},
	Output :> {
		{"fields", {FieldP[Output->Short]...}, "A list of SLL Fields."}
	},
	SeeAlso -> {
		"TypeP",
		"FieldP"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "thomas"}
}];