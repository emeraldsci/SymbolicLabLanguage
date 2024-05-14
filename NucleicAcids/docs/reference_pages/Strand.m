(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*Strand*)


DefineUsage[Strand,
	{
		BasicDefinitions -> {
			{"Strand[motif..]", "strand", "represents a strand with one or more motifs."}
		},
		MoreInformation-> {
			"Use Keys[strand] to see the properties that can be dereferenced from a strand.",
			"Dereference properties using strand[property], e.g. strand[Polymers]."
		},
		Input :> {
			{"motif", MotifP, "A motif."}
		},
		Output :> {
			{"strand", StrandP, "A properly formatted strand."}
		},
		SeeAlso -> {
			"Structure",
			"ReactionMechanism"
		},
		Author -> {"amir.saadat", "qian", "brad"}
	}];



(* ::Subsubsection:: *)
(*ComplementSequence*)


DefineUsage[ComplementSequence,
{
	BasicDefinitions -> {
		{"ComplementSequence[seq]", "complementSeq", "give the complement sequence to the provided 'seq'."},
		{"ComplementSequence[str]", "complementStrand", "gives the complement strand to the provided 'str'."}
	},
	MoreInformation -> {
		"Strips off any motif information when providing the complement."
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to complement."},
		{"str", _?StrandQ, "The strand you wish to complement."}
	},
	Output :> {
		{"complementSeq", _?SequenceQ, "The complement sequence to the provided sequence."},
		{"complementStrand", _?StrandQ, "The complement strand of the provided strand."}
	},
	SeeAlso -> {
		"ReverseSequence",
		"ReverseComplementSequence",
		"ComplementSequenceQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*ComplementSequenceQ*)


DefineUsage[ComplementSequenceQ,
{
	BasicDefinitions -> {
		{"ComplementSequenceQ[sequenceA,sequenceB]", "out", "returns true of sequenceA is the complement of sequenceB."},
		{"ComplementSequenceQ[strandA,strandB]", "out", "returns true of strandA is the complement of strandB."}
	},
	MoreInformation -> {
		"Works on any combination of explicitly typed or non explicitly typed sequences."
	},
	Input :> {
		{"sequenceA", _?SequenceQ, "The sequence that you wish to compare to sequenceB."},
		{"sequenceB", _?SequenceQ, "The sequence that you wish to compare to sequenceA."},
		{"strandA", _?StrandQ, "The strand that you wish to compare to strandB."},
		{"strandB", _?StrandQ, "The strand that you wish to compare to strandA."}
	},
	Output :> {
		{"out", BooleanP, "True if A is the complement of B."}
	},
	SeeAlso -> {
		"ReverseSequence",
		"ReverseComplementSequence",
		"ReverseSequenceQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*DefineMotifs*)


DefineUsage[DefineMotifs,
{
	BasicDefinitions -> {
		{"DefineMotifs[str, rules]", "out", "apply the replacement rules in 'rules' to all motifs in 'str'.  Any motifs not replaced by 'rules' will be replaced with the letter N."},
		{"DefineMotifs[expr, rules]", "out", "apply the replacement rules in 'rules' to every strand in the expression 'expr'."}
	},
	Input :> {
		{"str", StrandP, "Strand to add motif names to."},
		{"expr", _, "Expression whose strands will have motif names added."},
		{"rules", {(_String -> _String)..}, "A list of rules defining which sequences the motifs will be replaced with.  For example, {\"Xlabel\"->\"ATCGATCG\"}."}
	},
	Output :> {
		{"out", _, "Expression whose strand motifs have been replaced with sequences or the letter 'N'."}
	},
	SeeAlso -> {
		"ToStrand",
		"StrandLength"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection:: *)
(*Dimers*)


DefineUsage[Dimers,
{
	BasicDefinitions -> {
		{"Dimers[sequence]", "dimers", "breaks a provided sequence up into a list of its composite overlapping dimers in order of the sequence."}
	},
	MoreInformation -> {
		"Even if the sequence is explicitly typed (e.g. DNA[\"ATGATA\"], the function will strip the explicite type and any motif names when extracting the composite dimers."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The input sequence to be broken up into its dimer components."}
	},
	Output :> {
		{"dimers", {_?SequenceQ..}, "A list of the composite overlapping dimers in order of the sequence."}
	},
	SeeAlso -> {
		"Monomers",
		"SequenceFirst",
		"EmeraldSubsequences"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*DNAQ*)


DefineUsage[DNAQ,
{
	BasicDefinitions -> {
		{"DNAQ[sequence]", "isSequence", "returns true if the provided sequence is a valid DNA sequence."},
		{"DNAQ[str]", "isStrand", "returns true if the provided strand is composed of valid DNA sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid DNA sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid DNA sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"RNAQ",
		"PeptideQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ExplicitlyType*)


DefineUsage[ExplicitlyType,
{
	BasicDefinitions -> {
		{"ExplicitlyType[seq]", "typed", "either removes or adds explicit typing to the sequence on the basis of the options."},
		{"ExplicitlyType[typeTemplate,seq]", "typed", "either removes or adds explicit typing to the ouput on the basis of the typing of the input sequence and the options."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence to either add or remove explicit typing from/to."},
		{"typeTemplate", _?SequenceQ, "The form of a sequence before it has been modified by a function (used to resolve automatic options)."}
	},
	Output :> {
		{"typed", _?SequenceQ, "The sequence return either with explicit typing added to or stripped from the sequence."}
	},
	SeeAlso -> {
		"PolymerType",
		"ExplicitlyTypedQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ExplicitlyTypedQ*)


DefineUsage[ExplicitlyTypedQ,
{
	BasicDefinitions -> {
		{"ExplicitlyTypedQ[sequence_]", "typed:BooleanP", "returns true if a sequence is explicitly typed."}
	},
	Input :> {
		{"sequence", _, "The sequence you which to determine if its explicitlyTyped."}
	},
	Output :> {
		{"typed", _, "True if the sequence is explicitly typed."}
	},
	SeeAlso -> {
		"ExplicitlyType",
		"UnTypeSequence"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*GammaLeftPNAQ*)


DefineUsage[GammaLeftPNAQ,
{
	BasicDefinitions -> {
		{"GammaLeftPNAQ[sequence]", "isSequence", "returns true if the provided string is a valid GammaLeftPNA sequence."},
		{"GammaLeftPNAQ[str]", "isStrand", "returns true if the provided strand is composed of valid GammaLeftPNA sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid GammaLeftPNA sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid GammaLeftPNA sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*GammaRightPNAQ*)


DefineUsage[GammaRightPNAQ,
{
	BasicDefinitions -> {
		{"GammaRightPNAQ[sequence]", "isSequence", "returns true if the provided string is a valid GammaRightPNA sequence."},
		{"GammaRightPNAQ[str]", "isStrand", "returns true if the provided strand is composed of valid GammaRightPNA sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid GammaRightPNA sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid GammaRightPNA sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ModificationQ*)


DefineUsage[ModificationQ,
{
	BasicDefinitions -> {
		{"ModificationQ[sequence]", "isSequence", "returns true if the provided string is a valid sequence of modifications."},
		{"ModificationQ[str]", "isStrand", "returns true if the provided strand is composed of valid sequence of modifications."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid sequence of modifications."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid sequence of modifications."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*Monomers*)


DefineUsage[Monomers,
{
	BasicDefinitions -> {
		{"Monomers[sequence]", "monos", "breaks a provided sequence up into a list of its composite monomers in order of the sequence."},
		{"Monomers[strand]", "monos", "breaks up all of the sequences in a strand and returns a single list of these monomers."}
	},
	MoreInformation -> {
		"Even if the sequence is explicitly typed (e.g. DNA[\"ATGATA\"], the function will strip the explicite type and any motif names when extracting the composite monomers."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The input sequence you wish to break up into its monomer components."},
		{"strand", _?StrandQ, "The input strand you wish to break up into its monomer components."}
	},
	Output :> {
		{"monos", {_?SequenceQ..}, "A list of the composite Monomers in order of the sequence."}
	},
	SeeAlso -> {
		"Dimers",
		"SequenceFirst",
		"EmeraldSubsequences"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*PeptideQ*)


DefineUsage[PeptideQ,
{
	BasicDefinitions -> {
		{"PeptideQ[sequence]", "isSequence", "returns true if the provided string is a valid peptide sequence."},
		{"PeptideQ[str]", "isStrand", "returns true if the provided strand is composed of valid peptide sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid peptide sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid peptide sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*PNAQ*)


DefineUsage[PNAQ,
{
	BasicDefinitions -> {
		{"PNAQ[sequence]", "isSequence", "returns true if the provided string is a valid PNA sequence."},
		{"PNAQ[str]", "isStrand", "returns true if the provided strand is composed of valid PNA sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid PNA sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid PNA sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*PolymerType*)


DefineUsage[PolymerType,
{
	BasicDefinitions -> {
		{"PolymerType[seq]", "polymer", "determines the posible 'polymer' type that 'seq' could be composed of."}
	},
	MoreInformation -> {
		"Tries in the order DNAQ, then RNAQ, then PNAQ, then PeptideQ, then ModificationQ, so if multiple of these are true for the provide sequence returns only the first one in the list."
	},
	Input :> {
		{"seq", SequenceP, "A sequence whose polymer type you want to know."}
	},
	Output :> {
		{"polymer", PolymerP, "A polymer type 'seq' could be composed of."}
	},
	SeeAlso -> {
		"ExplicitlyType",
		"UnTypeSequence",
		"ExplicitlyTypedQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ReverseSequence*)


DefineUsage[ReverseSequence,
{
	BasicDefinitions -> {
		{"ReverseSequence[seq]", "reverseSequence", "gives the reverse sequence to the provided 'seq'."},
		{"ReverseSequence[str]", "reverseStrand", "gives the reverse strand to the provided 'str'."}
	},
	MoreInformation -> {
		"Strips off any motif information when providing the reverse."
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to reverse."},
		{"str", _?StrandQ, "The strand you wish to reverse."}
	},
	Output :> {
		{"reverseSequence", _?SequenceQ, "The reverse sequence to the provided sequence."},
		{"reverseStrand", _?StrandQ, "The reverse strand of the provided strand."}
	},
	SeeAlso -> {
		"ComplementSequence",
		"ReverseComplementSequence",
		"ReverseSequenceQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ReverseComplementSequence*)


DefineUsage[ReverseComplementSequence,
{
	BasicDefinitions -> {
		{"ReverseComplementSequence[seq]", "revCompSequence", "give the reverse complement sequence to the provided 'seq'."},
		{"ReverseComplementSequence[str]", "revCompStrand", "give the reverse complement sequence to the provided 'str'."},
		{"ReverseComplementSequence[motif]", "rcMotif", "given a motif name, will either add or remove the ' character to denote the reverse compliment motif name."}
	},
	MoreInformation -> {
		"ReverseComplementSequence works with the motif naming and the tick symbol \"'\" to denote reverse complements of given motifs."
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to get the reverse complement of."},
		{"str", _?StrandQ, "The strand you wish to get the reverse complement of."},
		{"motif", _String, "Name of a motif you wish to get the reverse compliment name of."}
	},
	Output :> {
		{"revCompSequence", _?SequenceQ, "The reverse complement of the provided sequence or strand."},
		{"revCompStrand", _?StrandQ, "The reverse complement of the provided sequence or strand."},
		{"rcMotif", _String, "Name of reverse complementary motif to the motif name provided."}
	},
	SeeAlso -> {
		"ComplementSequence",
		"ReverseSequence",
		"ReverseComplementSequenceQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*ReverseComplementSequenceQ*)


DefineUsage[ReverseComplementSequenceQ,
{
	BasicDefinitions -> {
		{"ReverseComplementSequenceQ[sequenceA,sequenceB]", "out", "returns true of sequenceA is the reverse complement of sequenceB."},
		{"ReverseComplementSequenceQ[strandA,strandB]", "out", "returns true of strandA is the reverse complement of strandB."},
		{"ReverseComplementSequenceQ[motifA,motifB]", "out", "returns true if motifA is the reverse complement of motifB (name motif with a ' after it)."}
	},
	MoreInformation -> {
		"Works on any combination of explicitly typed or non explicitly typed sequences."
	},
	Input :> {
		{"sequenceA", _?SequenceQ, "The sequence that you wish to compare to sequenceB."},
		{"sequenceB", _?SequenceQ, "The sequence that you wish to compare to sequenceA."},
		{"strandA", _?StrandQ, "The strand that you wish to compare to strandB."},
		{"strandB", _?StrandQ, "The strand that you wish to compare to strandA."},
		{"motifA", _String, "The motif you wish to compare to motifB."},
		{"motifB", _String, "The motif you wish to compare to motifA."}
	},
	Output :> {
		{"out", BooleanP, "True if A it the reverse complement of B."}
	},
	SeeAlso -> {
		"ReverseSequence",
		"ReverseComplementSequence",
		"ComplementSequenceQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*ReverseSequenceQ*)


DefineUsage[ReverseSequenceQ,
{
	BasicDefinitions -> {
		{"ReverseSequenceQ[sequenceA,sequenceB]", "out", "returns true of sequenceA is the reverse of sequenceB."},
		{"ReverseSequenceQ[strandA,strandB]", "out", "returns true of strandA is the reverse of strandB."}
	},
	MoreInformation -> {
		"works on any combination of explicitly typed or non explicitly typed sequences."
	},
	Input :> {
		{"sequenceA", _?SequenceQ, "The sequence that you wish to know if it is the reverse of sequenceB."},
		{"sequenceB", _?SequenceQ, "The sequence that you wish to know if it is the reverse of sequenceA."},
		{"strandA", _?StrandQ, "The sequence that you wish to know if it is the reverse of strandB."},
		{"strandB", _?StrandQ, "The sequence that you wish to know if it is the reverse of strandA."}
	},
	Output :> {
		{"out", BooleanP, "True if A is the complement of B."}
	},
	SeeAlso -> {
		"ReverseSequence",
		"ReverseComplementSequence",
		"ComplementSequenceQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*RNAQ*)


DefineUsage[RNAQ,
{
	BasicDefinitions -> {
		{"RNAQ[sequence]", "isSequence", "returns true if the provided string is a valid RNA sequence."},
		{"RNAQ[str]", "isStrand", "returns true if the provided strand is composed of valid RNA sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid DNA sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid DNA sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"PeptideQ"
	},
	Author -> {"scicomp", "brad"}
}];

(* ::Subsubsection:: *)
(*LNAChimeraQ*)


DefineUsage[LNAChimeraQ,
{
	BasicDefinitions -> {
		{"LNAChimeraQ[sequence]", "isSequence", "returns true if the provided string is a valid LNAChimera sequence."},
		{"LNAChimeraQ[str]", "isStrand", "returns true if the provided strand is composed of valid LNAChimera sequences."}
	},
	Input :> {
		{"sequence", SequenceP, "The sequence you wish to test."},
		{"str", StrandP, "The strand you wish to test."}
	},
	Output :> {
		{"isSequence", BooleanP, "True of the provided string is a valid LNAChimera sequence."},
		{"isStrand", BooleanP, "True of the provided strand is composed of valid LNAChimera sequences."}
	},
	SeeAlso -> {
		"SequenceQ",
		"DNAQ",
		"RNAQ",
		"PeptideQ"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];


(* ::Subsubsection:: *)
(*SameSequenceQ*)


DefineUsage[SameSequenceQ,
{
	BasicDefinitions -> {
		{"SameSequenceQ[seqs]", "out", "given a list of sequences, determines if each of them are or could represent the same sequence."},
		{"SameSequenceQ[seqA,seqB]", "out", "given two sequences, determines of they are or could represent the same sequence."}
	},
	Input :> {
		{"seqs", {_?SequenceQ..}, "A list of sequences you wish to determine."},
		{"seqA", _?SequenceQ, "A sequence you wisht to compare to 'seqB'."},
		{"seqB", _?SequenceQ, "A sequence you wisht to compare to 'seqA."}
	},
	Output :> {
		{"out", BooleanP, "True of the input sequences are or could represent the same sequence."}
	},
	SeeAlso -> {
		"SequenceQ",
		"possibleSubsequences"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceDrop*)


DefineUsage[SequenceDrop,
{
	BasicDefinitions -> {
		{"SequenceDrop[seq,n]", "out", "drops the first 'n' Monomers from the provided sequence."},
		{"SequenceDrop[seq,-n]", "out", "drops the last 'n' Monomers from the provided sequence."},
		{"SequenceDrop[seq,Span[n,m]]", "out", "drops the 'n'-th through 'm'-th monomer from the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to drop from to obtain a subsequence."},
		{"n", _Integer, "The number of monomer's you'd like to drop from the sequence (negative numbers take 'n' Monomers from the back of the sequence)."},
		{"m", _Integer, "The end position (inclusive) to drop a span of subsequence from."}
	},
	Output :> {
		{"out", _?SequenceQ, "A remaining subsequence after dropping the specified Monomers from the provided sequence."}
	},
	SeeAlso -> {
		"SequenceTake",
		"SequenceRest",
		"SequenceLast"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceFirst*)


DefineUsage[SequenceFirst,
{
	BasicDefinitions -> {
		{"SequenceFirst[seq]", "out", "returns only the first monomer of the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wisht to extract the first monomer of."}
	},
	Output :> {
		{"out", _?SequenceQ, "The first monomer in the sequence."}
	},
	SeeAlso -> {
		"SequenceLast",
		"SequenceMost",
		"SequenceRest"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceJoin*)


DefineUsage[SequenceJoin,
{
	BasicDefinitions -> {
		{"SequenceJoin[seqs]", "joined", "joins the provided sequences togeather into a single sequence."}
	},
	Input :> {
		{"seqs", {_?SequenceQ..} | __?SequenceQ, "A list of (or a Sequence of) sequences that you wish to join one after another into one final sequence."}
	},
	Output :> {
		{"joined", _?SequenceQ, "All of the input sequences concatinated into one sequence."}
	},
	SeeAlso -> {
		"StrandJoin",
		"SequenceFirst",
		"SequenceRest"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceLast*)


DefineUsage[SequenceLast,
{
	BasicDefinitions -> {
		{"SequenceLast[seq]", "out", "returns only the last monomer of the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wisht to extract the last monomer of."}
	},
	Output :> {
		{"out", _?sequenecQ, "The last monomer in the sequence."}
	},
	SeeAlso -> {
		"SequenceFirst",
		"SequenceMost",
		"SequenceRest"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceLength*)


DefineUsage[SequenceLength,
{
	BasicDefinitions -> {
		{"SequenceLength[seq]", "length", "returns the length of in terms of the number of Monomers in 'seq'."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to know the length of."}
	},
	Output :> {
		{"length", _Integer, "The length of the provided sequence."}
	},
	SeeAlso -> {
		"StrandLength",
		"StringLength",
		"Length"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceMost*)


DefineUsage[SequenceMost,
{
	BasicDefinitions -> {
		{"SequenceMost[seq]", "out", "returns all but the last monomer of the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wisht to extract all but the last monomer of."}
	},
	Output :> {
		{"out", {_?SequenceQ...}, "All but the last monomer of the provided sequence."}
	},
	SeeAlso -> {
		"SequenceFirst",
		"SequenceRest",
		"SequenceLast"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequencePalindromeQ*)


DefineUsage[SequencePalindromeQ,
{
	BasicDefinitions -> {
		{"SequencePalindromeQ[sequence_?SequenceQ]", "isPalindrome:BooleanP", "returns true if sequenceA is a palindrome (sequence is its own reverse complement)."}
	},
	MoreInformation -> {
		"Palindromes in biology are defined as sequences which are their own reverse complement such as ATGCGCAT.",
		"works on any combination of explicitly typed or non explicitly typed sequences."
	},
	Input :> {
		{"sequence", _, "The sequence that you wish to know if it is a palindrome."}
	},
	Output :> {
		{"isPalindrome", _, "True if the provided sequence is a palindrome."}
	},
	SeeAlso -> {
		"ReverseSequence",
		"ReverseComplementSequence",
		"ReverseComplementSequenceQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceQ*)


DefineUsage[SequenceQ,
{
	BasicDefinitions -> {
		{"SequenceQ[seq]", "out", "returns True if the provided sequence matches the given Polymer type."}
	},
	MoreInformation -> {
		"Automatic will attempt to match the provided string to any known polymer type."
	},
	Input :> {
		{"seq", SequenceP, "The input you wish to test to see if its a sequence."}
	},
	Output :> {
		{"out", BooleanP, "True of the provided string is a valid sequence."}
	},
	SeeAlso -> {
		"DNAQ",
		"RNAQ",
		"PeptideQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceRest*)


DefineUsage[SequenceRest,
{
	BasicDefinitions -> {
		{"SequenceRest[seq]", "out", "returns all but the first monomer of the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wisht to extract all but the first monomer of."}
	},
	Output :> {
		{"out", {_?SequenceQ...}, "All but the first monomer of the provided sequence."}
	},
	SeeAlso -> {
		"SequenceFirst",
		"SequenceMost",
		"SequenceLast"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceRotateLeft*)


DefineUsage[SequenceRotateLeft,
{
	BasicDefinitions -> {
		{"SequenceRotateLeft[seq,n]", "rotated", "moves the last 'n' Monomers from the rear of the 'seq' to the front of 'seq'."},
		{"SequenceRotateLeft[seq]", "rotated", "rotate 'seq' left by one monomer."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to rotate."},
		{"n", _Integer, "The number of bases you wish to rotate the sequence by."}
	},
	Output :> {
		{"rotated", _?SequenceQ, "The sequence after it has been rotated by 'n' bases."}
	},
	SeeAlso -> {
		"SequenceRotateRight",
		"SequenceTake",
		"SequenceDrop"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceRotateRight*)


DefineUsage[SequenceRotateRight,
{
	BasicDefinitions -> {
		{"SequenceRotateRight[seq,n]", "rotated", "moves the first 'n' Monomers from the front of the 'seq' to the rear of 'seq'."},
		{"SequenceRotateRight[seq]", "rotated", "rotate 'seq' right by one monomer."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to rotate."},
		{"n", _Integer, "The number of bases you wish to rotate the sequence by."}
	},
	Output :> {
		{"rotated", _?SequenceQ, "The sequence after it has been rotated by 'n' bases."}
	},
	SeeAlso -> {
		"SequenceRotateLeft",
		"SequenceTake",
		"SequenceDrop"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*SequenceTake*)


DefineUsage[SequenceTake,
{
	BasicDefinitions -> {
		{"SequenceTake[seq,n]", "out", "returns the first 'n' Monomers of the provided sequence."},
		{"SequenceTake[seq,-n]", "out", "returns the last 'n' Monomers of the provided sequence."},
		{"SequenceTake[seq,Span[n,m]]", "out", "returns from the 'n'-th to the 'm'-th monomer of the provided sequence."}
	},
	Input :> {
		{"seq", _?SequenceQ, "The sequence you wish to take take Monomers from."},
		{"n", _Integer, "The number of monomer's you'd like to take from the sequence (negative numbers take n Monomers from the back of the sequence)."},
		{"m", _Integer, "The end position (inclusive) to take a span of subsequence from."}
	},
	Output :> {
		{"out", _?SequenceQ, "A subsequence taken from the provided sequence."}
	},
	SeeAlso -> {
		"SequenceDrop",
		"SequenceRest",
		"SequenceLast"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandDrop*)


DefineUsage[StrandDrop,
{
	BasicDefinitions -> {
		{"StrandDrop[str,n]", "out", "returns a strand with the first n Monomers if n is positive, or the last n Monomers if n is negative, dropped from 'str'."}
	},
	Input :> {
		{"str", _Strand, "A strand to drop Monomers from."}
	},
	Output :> {
		{"out", _Strand, "A strand with dropped Monomers."}
	},
	SeeAlso -> {
		"StrandMost",
		"StrandTake"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandFirst*)


DefineUsage[StrandFirst,
{
	BasicDefinitions -> {
		{"StrandFirst[str]", "out", "return a strand containing only the first monomer from 'str'."}
	},
	Input :> {
		{"str", _Strand, "A strand to take the first monomer from."}
	},
	Output :> {
		{"out", _Strand, "A strand containing the first monomer from 'str'."}
	},
	SeeAlso -> {
		"StrandLast",
		"StrandMost"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandFlatten*)


DefineUsage[StrandFlatten,
{
	BasicDefinitions -> {
		{"StrandFlatten[str]", "consolidated", "takes a strand and joins consecutive stretches of like polymer types into single polymers."}
	},
	MoreInformation -> {
		"Looses motif information upon joining regions.",
		"Useful for conducting physical analysis where gaps in polymers lead to differences in calculations."
	},
	Input :> {
		{"str", _?StrandQ, "A valid strand that you wish to flatten out motifs of like polymer type."}
	},
	Output :> {
		{"consolidated", _?StrandQ, "A flattened strand where consecutive sequenes of like type have been merged togeather."}
	},
	SeeAlso -> {
		"SequenceJoin",
		"StrandJoin"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandJoin*)


DefineUsage[StrandJoin,
{
	BasicDefinitions -> {
		{"StrandJoin[str]", "joined", "join a sequence of strands into a single strand."}
	},
	Input :> {
		{"str", __Strand, "A Sequence of strands to be joined."}
	},
	Output :> {
		{"joined", _Strand, "A single strand containing all of the motifs in the Sequence of strands 'str'."}
	},
	SeeAlso -> {
		"StrandFlatten",
		"StrandDrop"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandLast*)


DefineUsage[StrandLast,
{
	BasicDefinitions -> {
		{"StrandLast[str]", "out", "return a strand containing only the last monomer from 'str'."}
	},
	Input :> {
		{"str", _Strand, "A strand to take the last monomer from."}
	},
	Output :> {
		{"out", _Strand, "A strand containing the last monomer from 'str'."}
	},
	SeeAlso -> {
		"StrandFirst",
		"StrandMost"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandLength*)


DefineUsage[StrandLength,
{
	BasicDefinitions -> {
		{"StrandLength[str]", "length", "returns the length of the strand as defined by the total number of Monomers.  Use Total option to return list of lengths of each motif."}
	},
	MoreInformation -> {
		"Listable over strand."
	},
	Input :> {
		{"str", StrandP, "Strand whose length is desired."}
	},
	Output :> {
		{"length", _Integer, "Total number of Monomers in the strand, or a list of the number of Monomers in each motif (if Total->False)."}
	},
	SeeAlso -> {
		"ToStrand",
		"Strand",
		"StrandJoin"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandMost*)


DefineUsage[StrandMost,
{
	BasicDefinitions -> {
		{"StrandMost[str]", "out", "returns a strand with of all but the last monomer in the strand."}
	},
	Input :> {
		{"str", _Strand, "A strand to take the most of."}
	},
	Output :> {
		{"out", _Strand, "A strand containing all but the last monomer of 'str'."}
	},
	SeeAlso -> {
		"StrandLast",
		"StrandRest"
	},
	Author -> {"scicomp", "brad"}
}];



(* ::Subsubsection:: *)
(*ParseStrand*)


DefineUsage[ParseStrand,
	{
		BasicDefinitions -> {
			{"ParseStrand[str]", "parsed", "parses strand motifs into their motif name, rev comp status, sequence, and polymer type."}
		},
		Input :> {
			{"str", StrandP, "A strand that will be parsed."}
		},
		Output :> {
			{"parsed", {{_String,True|False,_String,PolymerP}}, "Parsed information for each motif."}
		},
		SeeAlso -> {
			"Strand",
			"StrandQ"
		},
		Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
	}];



(* ::Subsubsection:: *)
(*StrandQ*)


DefineUsage[StrandQ,
{
	BasicDefinitions -> {
		{"StrandQ[str]", "isValid", "returns True if 'str' is a properly formated strand (each sequence is a properly formated seqeunce of the given polymer type)."},
		{"StrandQ[str,polymer]", "isValid", "returns True of 'str' is a properly formatted strand consisting of 'polymer' motifs."}
	},
	MoreInformation -> {
		"Listable over strand and polymer type.",
		"Use Exclude option to allow other polymer types, such as Modifications, in the strand."
	},
	Input :> {
		{"str", StrandP, "A strand you wish to check for validity."},
		{"polymer", PolymerP, "Checks to if the strand consists of only sequences composed of this type of polymer."}
	},
	Output :> {
		{"isValid", BooleanP, "True if the strand is properly formatted."}
	},
	SeeAlso -> {
		"SequenceQ",
		"StructureQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandRest*)


DefineUsage[StrandRest,
{
	BasicDefinitions -> {
		{"StrandRest[str]", "out", "returns a strand with of all but the first monomer in the strand."}
	},
	Input :> {
		{"str", _Strand, "A strand to take the rest of."}
	},
	Output :> {
		{"out", _Strand, "A strand containing all but the first monomer of 'str'."}
	},
	SeeAlso -> {
		"StrandLast",
		"StrandMost"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*StrandTake*)


DefineUsage[StrandTake,
{
	BasicDefinitions -> {
		{"StrandTake[str, p]", "out", "takes the first 'n' Monomers if 'p' is positive, and the last 'p' Monomers if 'p' is negative."},
		{"StrandTake[str, m ;; n]", "out", "takes Monomers from 'm' to 'n'."},
		{"StrandTake[str, {k, m ;; n}]", "out", "takes Monomers from 'm' to 'n' from motif 'k'."}
	},
	Input :> {
		{"str", StrandP, "Strand to take from."},
		{"p", _Integer, "Number of Monomers to take."},
		{"m", _Integer, "Start of Monomers to take."},
		{"n", _Integer, "End of Monomers to take."},
		{"k", _Integer, "Motif index."}
	},
	Output :> {
		{"out", StrandP, "Strand containing only the Monomers specified by 'p','m','n','k'."}
	},
	SeeAlso -> {
		"StrandLast",
		"StrandMost"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ToDNA*)


DefineUsage[ToDNA,
{
	BasicDefinitions -> {
		{"ToDNA[seq]", "DNASequence", "converts the provided sequence into a DNA sequence."},
		{"ToDNA[str]", "DNAStrand", "converts the provided strand into a strand of all DNA."}
	},
	MoreInformation -> {
		"If a non Watson Crick Pairing alphabet (such as Peptide) is provided, and empty string is returned."
	},
	Input :> {
		{"seq", _?SequenceQ, "The desired sequence you wish to Convert."},
		{"str", _?StrandQ, "The desired strand you wish to Convert."}
	},
	Output :> {
		{"DNASequence", _?SequenceQ, "DNA sequence version of the provided input after conversion."},
		{"DNAStrand", _?StrandQ, "DNA strand version of the provided input after conversion."}
	},
	SeeAlso -> {
		"ToRNA",
		"RNAQ",
		"DNAQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection:: *)
(*ToPeptide*)


DefineUsage[ToPeptide,
{
	BasicDefinitions -> {
		{"ToPeptide[proteinSeq]", "peptide", "converts the 'proteinSeq' in the single letter amino acid abbreviation format to the 'peptide' the triple letter format."}
	},
	MoreInformation -> {
		"The input in this case can match a version of _?PeptideQ that allows for the AlternativeEncodings, eg. the single letter amino acid abbreviations.",
		"The AlternativeEncodings can be found by evaluating the following code: AlternativeEncodings/.Parameters[Peptide]"
	},
	Input :> {
		{"proteinSeq", _?PeptideQ, "A protein sequence in single letter amino acid abbreviations or mixed single and triple letter abbreviations."}
	},
	Output :> {
		{"peptide", _?PeptideQ, "The protein sequence in triple letter amino acid abbreviations."}
	},
	SeeAlso -> {
		"ToDNA",
		"ToRNA"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*ToRNA*)


DefineUsage[ToRNA,
{
	BasicDefinitions -> {
		{"ToRNA[seq]", "RNASequence", "converts the provided sequence into a RNA sequence."},
		{"ToRNA[str]", "RNAStrand", "converts the provided strand into a strand of all RNA."}
	},
	MoreInformation -> {
		"If a non Watson Crick Pairing alphabet (such as Peptide) is provided, and empty string is returned."
	},
	Input :> {
		{"seq", _?SequenceQ, "The desired sequence you wish to Convert."},
		{"str", _?StrandQ, "The desired strand you wish to Convert."}
	},
	Output :> {
		{"RNASequence", _?SequenceQ, "RNA sequence version of the provided input after conversion."},
		{"RNAStrand", _?StrandQ, "RNA strand version of the provided input after conversion."}
	},
	SeeAlso -> {
		"ToDNA",
		"DNAQ",
		"RNAQ"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];




(* ::Subsubsection:: *)
(*ToLRNA*)


DefineUsage[ToLRNA,
{
	BasicDefinitions -> {
		{"ToLRNA[seq]", "LRNASequence", "converts the provided sequence into a LRNA sequence."},
		{"ToLRNA[str]", "LRNAStrand", "converts the provided strand into a strand of all LRNA."}
	},
	MoreInformation -> {
		"If a non Watson Crick Pairing alphabet (such as Peptide) is provided, and empty string is returned."
	},
	Input :> {
		{"seq", _?SequenceQ, "The desired sequence you wish to Convert."},
		{"str", _?StrandQ, "The desired strand you wish to Convert."}
	},
	Output :> {
		{"LRNASequence", _?SequenceQ, "LRNA sequence version of the provided input after conversion."},
		{"LRNAStrand", _?StrandQ, "LRNA strand version of the provided input after conversion."}
	},
	SeeAlso -> {
		"ToRNA",
		"ToDNA",
		"DNAQ",
		"RNAQ"
	},
	Author -> {"scicomp", "brad", "amir.saadat"}
}];


(* ::Subsubsection::Closed:: *)
(*Truncate*)


DefineUsage[Truncate,
{
	BasicDefinitions -> {
		{"Truncate[str,n]", "truncations", "provides a list of strands with 0 to n Monomers removed from 'str' and replaced with a single cap monomer."}
	},
	MoreInformation -> {
		"Truncate returns solid-phase synthesis truncations, and thus removes bases from the front (5' end, or N to C)), and replaces them with a single cap monomer (as defined in the options)."
	},
	Input :> {
		{"str", _?StrandQ | _?SequenceQ, "The strand or sequence you wish to obtain truncations of."},
		{"n", _Integer?Positive, "The number of truncations you want to return."}
	},
	Output :> {
		{"truncations", {_?StrandQ..}, "A list the strands which are truncations of 'str'."}
	},
	SeeAlso -> {
		"SequenceDrop",
		"StrandDrop"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*UnTypeSequence*)


DefineUsage[UnTypeSequence,
{
	BasicDefinitions -> {
		{"UnTypeSequence[sequence_?SequenceQ]", "untyped_Sequence", "removes the type and motif from a provided sequence."}
	},
	Input :> {
		{"sequence", _, "Sequence you wish to remove the type and motif from.  Can be typed or untyped."}
	},
	Output :> {
		{"untyped", _, "The sequence with any type or motif information removed."}
	},
	SeeAlso -> {
		"ExplicitlyType",
		"PolymerType"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidStrandQ*)


DefineUsage[ValidStrandQ,
{
	BasicDefinitions -> {
		{"ValidStrandQ[str]", "bool", "returns True if 'str' is a properly formated strand (each sequence is a properly formated seqeunce of the given polymer type)."}
	},
	MoreInformation -> {
		"Listable over strand and polymer type.",
		"Use Exclude option to allow other polymer types, such as Modifications, in the strand."
	},
	Input :> {
		{"str", _, "A strand you wish to check for validity."}
	},
	Output :> {
		{"isValid", BooleanP, "True if the strand is properly formatted."}
	},
	SeeAlso -> {
		"StrandQ",
		"StructureQ",
		"ValidSequenceQ"
	},
	Author -> {"scicomp", "brad"}
}];