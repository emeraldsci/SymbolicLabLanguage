(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Glycan",
	Abstract -> "Collection of functions for the manipulation and analysis of glycan molecules.",
	Reference -> {
		"Structures" -> {
			{Glycan, "Makes the symbolic represents for single glycan subunits (a carbohydrate modification to a protein/peptide sequence)."},
			{GlycanStructure, "Makes the symbolic branched structure represents for linear sequences of glycan subunits."},
			{AvailableGlycans, "Returns the list of supported glycans that can be used in the Glycan/GlycanSequence/GlycanStructure functions."},
			{Glycan, "Checks if a given input corresponds to a glycan subunit."},
			{GlycanQ, "Makes the symbolic representations for single glycan subunits (a carbohydrate modification to a protein/peptide sequence)."},
			{GlycanStructure, "Makes the symbolic branched structure representations for linear sequences of glycan subunits."},
			{GlycanSequence, "Returns a list of symbolic represents of a linear sequence of glycan subunits."},
			{GlycanSequenceQ, "Checks if the specified glycan sequence is a valid structure."}
		}
	},
	RelatedGuides -> {
		GuideLink["Biomolecules"],
		GuideLink["Oligonucleotides"]
	}
]