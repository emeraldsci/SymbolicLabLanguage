
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
    Title -> "Biomolecules",
    Abstract -> "Collection of functions for performing physical calculations on biomolecule structures and sequences where applicable. See linked guides for functions specific to the main classes of biomolecules (Oligonucleotides, Peptides, Glycans, Lipids).",
    Reference -> {
        "Properties" -> {
            {ExactMass, "Computes the most probable exact mass of a given molecule."},
            {MolecularWeight, "Computes the molecular weight of a molecule, oligomer, or the average molecular weight of a polymer."},
            {MonoisotopicMass,"Returns the molecular mass of a given input molecule."},
            {ExtinctionCoefficient, "Computes the extinction coefficient at 260 nm of the provided sequence."}
        },
        "Sequence Generation" -> {
            {Monomers, "Splits a sequence into a list of its composite monomers."},
            {Dimers, "Splits a sequence into a list of its composite overlapping dimers in order of the sequence."},
            {ReverseSequence, "Returns the reverse sequence of the provided sequence."},
            {ComplementSequence, "Returns the complement sequence of the provided sequence."},
            {ReverseComplementSequence, "Returns the reverse complement of the provided sequence."},
            {ToDNA, "Converts a sequence into its equivalent DNA sequence."},
            {ToRNA, "Converts a sequence into its equivalent RNA sequence."},
            {ToPeptide, "Converts a protein sequence in the single letter amino acid form into an explicitly typed Peptide in the triple letter abbreviation form."},
            {GenerateSequence, "Generates an optimal sequence with degenerate bases filled in, given certain parameters and specific sequences."},
            {SequenceLength, "Computes the number of monomers in the provided polymer sequence."},
            {PolymerType, "Determines the possible polymer type that the provided sequence could be composed of."},
            {UploadModification, "Creates a new Constellation object referring to a specified chemical modification."}
        },
        "Uploading Identity Models" -> {
            {UploadOligomer, "Creates a Constellation object containing the given information about an oligomer."},
            {UploadProtein, "Creates or updates a protein model that contains information given about the specified protein."},
            {UploadAntibody, "Creates and uploads a protein molecule model that contains the information about the input antibody."}
        },
        "Model Visualization" -> {
            {PlotProtein, "Generates a ribbon diagram of the structure from the provided protein model."},
            {PlotTranscript, "Generates visualizations of any stored structures in the provided transcript model."},
            {PlotGlycanSequence, "Plots the graphical glycan sequence according to the input."}
        }
    },
    RelatedGuides -> {
        GuideLink["PhysicalSimulations"],
        GuideLink["Oligonucleotides"],
        GuideLink["Glycan"]
        (* Future guides that need to be created *)
        (*GuideLink["Peptides"],*)
        (*GuideLink["Lipids"]*)
    }
]