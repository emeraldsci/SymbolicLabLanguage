(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*Structure*)


DefineUsage[Structure,
	{
		BasicDefinitions -> {
			{"Structure[strands,bonds]", "structure", "represents a structure with one or more strands and zero or more bonds."}
		},
		MoreInformation-> {
			"Use Keys[structure] to see the properties that can be dereferenced from a structure.",
			"Dereference properties using structure[property], e.g. structure[Strands]."
		},
		Input :> {
			{"strands", {StrandP..}, "The strands in the structure."},
			{"bonds", {BondP...}, "The bonds in the structure."}
		},
		Output :> {
			{"structure", StructureP, "A properly formatted structure."}
		},
		SeeAlso -> {
			"Strand",
			"ReactionMechanism"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];



(* ::Subsubsection:: *)
(*consolidateBonds*)


DefineUsage[consolidateBonds,
{
	BasicDefinitions -> {
		{"consolidateBonds[structure]", "out", "consolidates adjacent bonds in 'structure' into single longer bonds."}
	},
	Input :> {
		{"structure", StructureP, "A structure whose bonds will be consolidated."}
	},
	Output :> {
		{"out", StructureP, "A structure whose adjacent bonds have all been consolidated into fewer longer bonds."}
	},
	SeeAlso -> {
		"StructureSort",
		"CountBonds"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*NumberOfBonds*)


DefineUsage[NumberOfBonds,
{
	BasicDefinitions -> {
		{"NumberOfBonds[structure]", "numberOfBonds", "counts the number of bonds in a structure."}
	},
	MoreInformation -> {
		"Handles both span and motif bond forms.",
		"Returns 0 if there are no bonds."
	},
	Input :> {
		{"structure", _?StructureQ, "The structure whose bonds you are counting."}
	},
	Output :> {
		{"numberOfBonds", _Integer, "The number of individual bonds between base pairs in the structure."}
	},
	SeeAlso -> {
		"ToStructure",
		"Structure",
		"Bond"
	},
	Author -> {
		"austin",
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection:: *)
(*reformatMotifs*)


DefineUsage[reformatMotifs,
{
	BasicDefinitions -> {
		{"reformatMotifs[c_]", "newStructure", "given a Structure with pairs defined at the base-level, split the motifs such that every motif is either completely paired or completely unpaired.  \n\t\t\tThe resulting Structure can then be plotted in MotifForm."}
	},
	Input :> {
		{"c", _, "A Structure with pairs defined at the base-level."}
	},
	Output :> {
		{"out", _, "A Structure with motifs that are either completely free or completely paired."}
	},
	SeeAlso -> {
		"MotifForm",
		"MotifSequence"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StructureJoin*)


DefineUsage[StructureJoin,
{
	BasicDefinitions -> {
		{"StructureJoin[comp1,comp2]", "comp", "combine two structures together into a single Structure, without adding any new pairs between them."}
	},
	MoreInformation -> {
		"The output Structure will be sorted",
		"If necessary, the indicies in pairs will be updated to account for the new strand numbering"
	},
	Input :> {
		{"comp1", _Structure, "Structure."},
		{"comp2", _Structure, "Structure."}
	},
	Output :> {
		{"comp", _Structure, "A single Structure containing all strands and pairs from 'comp1' and 'comp2'."}
	},
	SeeAlso -> {
		"StructureSort",
		"StructureTake"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StructureQ*)


DefineUsage[StructureQ,
{
	BasicDefinitions -> {
		{"StructureQ[item]", "bool", "returns True if 'item' is a properly formated Structure."}
	},
	MoreInformation -> {
		"Use Sequence option if you want only motifs with sequences or only motifs with number lengths"
	},
	Input :> {
		{"item", _, "Item that might be a structure."}
	},
	Output :> {
		{"bool", True | False, "True if the structure is properly formatted."}
	},
	SeeAlso -> {
		"ToStructure",
		"StrandQ",
		"StructureTake"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*StructureSort*)


DefineUsage[StructureSort,
{
	BasicDefinitions -> {
		{"StructureSort[struct]", "sortedStruct", "sorts a Structure into canonical form using alphabet and graph topology."}
	},
	Input :> {
		{"struct", StructureP, "A Structure to sort."}
	},
	Output :> {
		{"sortedStruct", StructureP, "A Structure sorted into canonical form."}
	},
	SeeAlso -> {
		"Sort",
		"SortBy",
		"Cycles",
		"GroupElements",
		"PermutationGroup",
		"PermutationReplace"
	},
	Author -> {
		"austin",
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*StructureTake*)


DefineUsage[StructureTake,
{
	BasicDefinitions -> {
		{"StructureTake[comp_Structure, strInt_Integer, interval:{_Integer,_Integer}]", "seq_String", "extract a sequence from a Structure."}
	},
	Input :> {
		{"comp", _, "Structure to pull a sequence from."},
		{"strInt", _, "Strand integer."},
		{"interval", _, "Base interval {_Integer,_Integer}."}
	},
	Output :> {
		{"seq", _, "The sequence at position[{strInt,interval} in 'comp'."}
	},
	SeeAlso -> {
		"StructureSort",
		"StructureJoin"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*SplitStructure*)


DefineUsage[SplitStructure,
	{
		BasicDefinitions -> {
			{"SplitStructure[structure]", "splitStructure", "splits a structure into separate structures that share no bonds between strands."}
		},
		Input :> {
			{"structure", StructureP, "A structure to split."}
		},
		Output :> {
			{"splitStructure", {StructureP..}, "A list of unconnected structures."}
		},
		SeeAlso -> {
			"Strand",
			"ReactionMechanism"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];


(* ::Subsubsection:: *)
(*reformatBonds*)


DefineUsage[reformatBonds,
	{
		BasicDefinitions -> {
			{"reformatBonds[structure,bondFormat]", "newStructure", "reformats any bonds in 'structure' to have the format specified by 'bondFormat'."}
		},
		Input :> {
			{"structure", StructureP, "A structure to reformat."},
			{"bondFormat", BondFormatP, "New format for the bonds."}
		},
		Output :> {
			{"newStructure", StructureP, "A structure whose bonds are formatted as 'bondFormat'."}
		},
		SeeAlso -> {
			"StructureSort",
			"Structure"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];