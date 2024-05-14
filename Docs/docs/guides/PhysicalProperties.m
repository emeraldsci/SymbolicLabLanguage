(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Physical Properties",
	Abstract -> "Collection of functions for managing the physical properties of sample objects.",
	Reference -> {
		"Uploading Physical Parameters" -> {
			{UploadModification, "Creates a new Constellation object referring to a specified chemical modification."}
		},
		"Properties" -> {
			{ExactMass, "Computes the most probable exact mass of a given molecule."},
			{MolecularWeight, "Computes the molecular weight of a molecule, oligomer, or the average molecular weight of a polymer."},
			{ExtinctionCoefficient, "Computes the extinction coefficient at 260 nm of the provided sequence."},
			{Hyperchromicity260, "Computes the hyperchromicity correction of the provided sequence."}
		},
		"Parameterization" -> {
			{ValidPolymerQ, "Checks if the info contained in the provided input is of correct construction."},
			{DNAPhosphoramiditeMolecularWeights, "Returns a list of the molecular weights (in grams/mole) of the DNA phosphoramidite monomer as rules."},
			{PNAMolecularWeights, "Returns a list of the molecular weights for PNA reagents."},
			{ModifierPhosphoramiditeMolecularWeights, "Returns a list of the molecular weights (in grams/mole) of the modifier phosphoramidite monomer as rules."}
		}
	},
	RelatedGuides -> {
		GuideLink["Oligonucleotides"]
	}
]
