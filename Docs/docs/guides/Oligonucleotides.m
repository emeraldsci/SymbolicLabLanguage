(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Oligonucleotides",
	Abstract -> "Collection of functions for manipulating and looking up properties for oligonucleotides.",
	Reference -> {

		"Sequence Properties" -> {
			{SequenceQ, "Checks if a sequence is matching the given polymer type, such as DNA, RNA, or peptide."},
			{ValidSequenceQ, "Checks if a sequence is a valid DNA, RNA, or peptide sequence."},
			{SequenceLength, "Computes the number of monomers in the provided polymer sequence."},
			{PolymerType, "Determines the possible polymer type that the provided sequence could be composed of."},
			{DNAQ, "Checks if a sequence is a valid DNA sequence."},
			{RNAQ, "Checks if a sequence is a valid RNA sequence."},
			{PeptideQ, "Checks if a sequence is a valid peptide sequence."},
			{PNAQ, "Checks if a sequence is a valid peptide nucleic acid (PNA) sequence."},
			{GammaRightPNAQ, "Checks if a sequence is a valid right-handed gamma-modified PNA sequence."},
			{GammaLeftPNAQ, "Checks if a sequence is a valid left-handed gamma-modified PNA sequence."},
			{ModificationQ, "Checks if a sequence is a sequence of modifications."},
			{SameSequenceQ, "Checks that for the provided list of sequences, if each of them are or could represent the same sequence."},
			{ReverseSequenceQ, "Checks if two sequences are the reverse sequence of each other."},
			{ComplementSequenceQ, "Checks if two sequences are the Watson-Crick complement of each other."},
			{ReverseComplementSequenceQ, "Checks if two sequences are the reverse complement of each other."},
			{SequencePalindromeQ, "Checks if a sequence is palindromic, which means that the sequence is its own reverse complement."}
		},

		"Sequence Manipulation" -> {
			{SequenceFirst, "Returns the first monomer of the provided sequence."},
			{SequenceLast, "Returns the last monomer of the provided sequence."},
			{SequenceMost, "Returns all but the last monomer of the provided sequence."},
			{SequenceRest, "Returns all but the first monomer of the provided sequence."},
			{SequenceTake, "Returns the specified part of the provided sequence."},
			{SequenceDrop, "Returns a sequence with the specified part dropped from the provided sequence."},
			{SequenceJoin, "Joins the provided sequences together into a single sequence."},
			{SequenceRotateLeft, "Moves the first n monomers from the front (left hand side) of the sequence to the rear (right hand side) of sequence."},
			{SequenceRotateRight, "Moves the last n monomers from the rear (right hand side) of the sequence to the front (left hand side) of sequence."},
			{ExplicitlyTypedQ, "Checks if a sequence is explicitly typed."},
			{ExplicitlyType, "Removes or adds the explicit polymer type to a sequence."},
			{UnTypeSequence, "Removes the polymer type and motif from a sequence."}
		},

		"Sequence Generation" -> {
			{Monomers, "Splits a sequence into a list of its composite monomers."},
			{Dimers, "Splits a sequence into a list of its composite overlapping dimers in order of the sequence."},
			{AllSequences, "Returns a list of all possible sequences of the requested length."},
			{RandomSequence, "Returns a random sequence of the requested length."},
			{AllPalindromes, "Returns all palindromic sequences of the requested length."},
			{ReverseSequence, "Returns the reverse sequence of the provided sequence."},
			{ComplementSequence, "Returns the complement sequence of the provided sequence."},
			{ReverseComplementSequence, "Returns the reverse complement of the provided sequence."},
			{ToDNA, "Converts a sequence into its equivalent DNA sequence."},
			{ToRNA, "Converts a sequence into its equivalent RNA sequence."},
			{ToLRNA, "Converts a sequence into its equivalent L-form RNA sequence."},
			{ToPeptide, "Converts a protein sequence in the single letter amino acid form into an explicitly typed Peptide in the triple letter abbreviation form."},
			{ToSequence, "Returns a list of sequences in the strand or in the motifs."},
			{GenerateSequence, "Generates an optimal sequence with degenerate bases filled in, given certain parameters and specific sequences."},
			{UploadModification, "Creates a new Constellation object referring to a specified chemical modification."}
		},

		"Base Composition" -> {
			{FractionAT, "Computes the fraction of the provided DNA/PNA sequence that is composed of As or Ts."},
			{FractionAU, "Computes the fraction of the provided RNA sequence that is composed of As or Us."},
			{FractionGC, "Computes the fraction of the provided DNA/RNA/PNA sequence that is composed of As or Us."},
			{FractionMono, "Computes the fraction of the provided sequence that is composed of members of the provided list of monomers."},
			{FractionPurine, "Computes the fraction of the provided DNA/RNA/PNA sequence that is composed of purines (As and Gs)."},
			{FractionPyrimidine, "Computes the fraction of the provided DNA/RNA/PNA sequence that is composed of purines (Cs, Ts, and Us)."}
		},

		"Subsequence Analysis" -> {
			{EmeraldSubsequences, "Splits the provides sequence into a list of overlapping subsequences of length n."},
			{FoldsQ, "Checks if a fold of a specific length exists anywhere in the provided sequence."},
			{NumberOfFolds, "Computes the total number of overlapping subsequences of a specific length that could fold from the provided sequence."},
			{FoldingSequences, "Returns a list of subsequences of a specific length from the provided sequence that could potentially fold."},
			{FoldingMatrix, "Returns a matrix describing if the overlapping subsequences of a specific length from start to finish of the provided sequence could fold onto each other."},
			{RepeatsQ, "Checks if a repeated subsequence of a specific length exists anywhere in the provided sequence."},
			{NumberOfRepeats, "Computes the total number of overlapping subsequences of a specific length that are repeated from the provided sequence."},
			{RepeatingSequences, "Returns a list of subsequences of a specific length that are repeated from the provided sequence."},
			{RepeatingMatrix, "Returns a matrix describing if the overlapping subsequences of a specific length from start to finish the provided sequence are repeated."}
		},

		"Motifs" -> {
			{MotifForm, "Looks for anything in Structure form from the provided input and renders them as graph images at the motif level."},
			{ValidMotifQ, "Checks if a sequence is a valid motif, which mean an explicitly typed sequence."},
			{MotifSequence, "Returns the sequence of the provided motif."},
			{MotifPolymer, "Returns the polymer type of the provided motif."},
			{MotifLabel, "Returns the label of the provided motif."},
			{NameMotifs, "Names any unnamed motifs with a unique string in the provided structure, strand, or sequence."},
			{DefineMotifs, "Applies the replacement rules to all motifs to replace them with specified sequences."}
		},

		"Physical Properties" -> {
			{ExactMass, "Computes the most probable exact mass of a given molecule."},
			{MolecularWeight, "Computes the molecular weight of a molecule, oligomer, or the average molecular weight of a polymer."},
			{ExtinctionCoefficient, "Computes the extinction coefficient at 260 nm of the provided sequence."},
			{Hyperchromicity260, "Computes the hyperchromicity correction of the provided sequence."},
			{ValidPolymerQ, "Checks if the info contained in the provided input is of correct construction."},
			{DNAPhosphoramiditeMolecularWeights, "Returns a list of the molecular weights (in grams/mole) of the DNA phosphoramidite monomer as rules."},
			{PNAMolecularWeights, "Returns a list of the molecular weights for PNA reagents."},
			{ModifierPhosphoramiditeMolecularWeights, "Returns a list of the molecular weights (in grams/mole) of the modifier phosphoramidite monomer as rules."}
		},

		"Strand Properties" -> {
			{Strand, "Represents a strand with one or more motifs."},
			{StrandQ, "Checks if the provided input is a properly formatted strand (each sequence is a properly formatted sequence of the given polymer type)."},
			{ValidStrandQ, "Checks if the provided input is a properly formatted strand (each sequence is a properly formatted sequence of the given polymer type)."},
			{StrandLength, "Returns the length of the strand as defined by the total number of monomers."}
		},

		"SequenceManipulation" -> {
			{StrandFirst, "Returns a strand containing only the first monomer of the provided strand."},
			{StrandLast, "Returns a strand containing only the last monomer of the provided strand."},
			{StrandRest, "Returns a strand with of all but the first monomer of the provided strand."},
			{StrandMost, "Returns a strand with of all but the last monomer of the provided strand."},
			{StrandTake, "Returns the specified part of the provided strand."},
			{StrandDrop, "Returns a strand with the specified part dropped from the provided strand."},
			{StrandJoin, "Joins the provided strands together into a single strand."},
			{StrandFlatten, "Takes a strand and joins consecutive stretches of like polymer types into single polymers."},
			{Truncate, "Returns a list of strands by removing a specific number of monomers from the provided strand and replacing them with a single cap monomer."},
			{ToStrand, "Returns a single strand or a list of strands containing from the provided sequences or structures."},
			{ParseStrand, "Returns the motif name, reverse complement status, sequence, and polymer type of the provided strand."}
		},

		"Structures" -> {
			{Structure, "Represents a structure with one or more strands and zero or more bonds."},
			{StructureQ, "Checks if the provided input is a properly formatted structure."},
			{StructureFaces, "Returns a list of faces for the structure, which contains the corresponding loop type and start/end indices in the original structure."},
			{StructureJoin, "Joins the provided structures together into a single structure."},
			{StructureSort, "Sorts a structure into canonical form using alphabet and graph topology."},
			{StructureTake, "Returns the specified part of the provided structure."},
			{SplitStructure, "Splits a structure into separate structures that share no bonds between strands."},
			{ToStructure, "Returns a single structure containing a single strand or multiple strands from the provided sequences or strands."},
			{Hybridize, "Joins reverse-complementary sequences until no more are available."},
			{Pairing, "Returns all possible pairings of two provided sequences, strands, or structures."},
			{NumberOfBonds, "Computes the number of bonds in the provide structure."},
			{StructureForm, "Looks for anything in Structure form from the provided input and renders them as graph images at the nucleotide level."}
		},

		"State" -> {
			{State, "Represents a state containing species and their concentrations."},
			{StateQ, "Checks if the provided input is a properly formatted state."},
			{ToState, "Converts a list of rules, relating species name with concentration, to a properly formatted state."},
			{StateFirst, "Returns the first name and concentration pair of the provided state."},
			{StateLast, "Returns the last name and concentration pair of the provided state."},
			{StateRest, "Returns all but the first name and concentration pair of the provided state."},
			{StateMost, "Returns all but the last name and concentration pair of the provided state."}
		},

		"Reaction" -> {
			{Reaction, "Represents either an irreversible or a reversible chemical reaction."},
			{ReactionQ, "Checks that if the provided nucleic acid reaction is properly formatted."},
			{SplitReaction, "Splits a reversible reaction into forward and reverse reactions."},
			{ToReactionMechanism, "Constructs a properly formatted ReactionMechanism from the provided reactions and rates."},
			{ClassifyReaction, "Returns the classical type of a nucleic acid secondary structure transformation based on the provided nucleic acid reactants and products."},
			{KineticRates, "Returns an estimated kinetic rate parameterized from literature precedence for the nucleic acid reaction with a classified reaction type."}
		},

		"Mechanism" -> {
			{ReactionMechanism, "Represents a ReactionMechanism containing a set of reactions."},
			{ReactionMechanismQ, "Checks if the provided input is a properly formatted mechanism."},
			{MechanismFirst, "Returns the first reaction from the provided mechanism."},
			{MechanismLast, "Returns the last reaction from the provided mechanism."},
			{MechanismRest, "Returns all but the first reaction from the provided mechanism."},
			{MechanismMost, "Returns all but the last reaction from the provided mechanism."},
			{MechanismJoin, "Joins two or more mechanisms together and deletes redundant reactions."},
			{SpeciesList, "Returns a list of unique species present in the provided reactions."}
		},

		"Trajectory" -> {
			{Trajectory, "Represents a trajectory describing the behavior of reactions."},
			{ToTrajectory, "Transforms a list of data points and time points into a properly formatted Trajectory."},
			{PlotTrajectory, "Plots the concentration of all species in the provided trajectory against time."}
		}
	},
	RelatedGuides -> {
		GuideLink["Biomolecules"],
		GuideLink["Glycan"],
		GuideLink["PhysicalProperties"]
	}
]
