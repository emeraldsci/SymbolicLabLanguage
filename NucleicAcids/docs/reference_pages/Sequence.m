

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*MotifLabel*)

DefineUsage[MotifLabel,
{
	BasicDefinitions -> {
		{"MotifLabel[motif]", "pol", "returns the label of 'motif'."}
	},
	Input :> {
		{"motif", MotifP, "A typed sequence, also known as a motif."}
	},
	Output :> {
		{"label", _String, "The label of 'motif'.  If 'motif' has no label, an empty string is returned."}
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	SeeAlso -> {
		"MotifSequence",
		"MotifPolymer"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*MotifPolymer*)

DefineUsage[MotifPolymer,
{
	BasicDefinitions -> {
		{"MotifPolymer[motif]", "pol", "returns the polymer type of 'motif'."}
	},
	Input :> {
		{"motif", MotifP, "A typed sequence, also known as a motif."}
	},
	Output :> {
		{"out", PolymerP, "The polymer type of 'motif'."}
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	SeeAlso -> {
		"MotifSequence",
		"MotifLabel"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*MotifSequence*)

DefineUsage[MotifSequence,
{
	BasicDefinitions -> {
		{"MotifSequence[motif]", "pol", "returns the sequence of 'motif'."}
	},
	Input :> {
		{"motif", MotifP, "A typed sequence, also known as a motif."}
	},
	Output :> {
		{"out", _String, "The sequence of 'motif'."}
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	SeeAlso -> {
		"MotifPolymer",
		"MotifLabel"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidMotifQ*)

DefineUsage[ValidMotifQ,
{
	BasicDefinitions -> {
		{"ValidMotifQ[motif]", "out", "returns True if 'motif' is a valid motif (explicitly typed sequence)."}
	},
	MoreInformation -> {
		""
	},
	Input :> {
		{"motif", _, "The input you wish to test to see if it's a motif."}
	},
	Output :> {
		{"out", BooleanP, "True if 'motif' is a valid motif."}
	},
	SeeAlso -> {
		"MotifQ",
		"ValidSequence",
		"MotifP"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidSequenceQ*)

DefineUsage[ValidSequenceQ,
{
	BasicDefinitions -> {
		{"ValidSequenceQ[seq]", "out", "returns True if 'seq' is a valid sequence."}
	},
	MoreInformation -> {
		""
	},
	Input :> {
		{"seq", _, "The input you wish to test to see if it's a sequence."}
	},
	Output :> {
		{"out", BooleanP, "True if 'seq' is a valid sequence."}
	},
	SeeAlso -> {
		"DNAQ",
		"RNAQ",
		"PeptideQ"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];