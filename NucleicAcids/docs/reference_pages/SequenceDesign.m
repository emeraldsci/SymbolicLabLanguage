(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*possibleSubsequences*)


DefineUsage[possibleSubsequences,
{
	BasicDefinitions -> {
		{"possibleSubsequences[template : _?SequenceQ]", "subsequences:{SequenceP...}", "given a degenerate template (and optional previous and next subsequences) returns a list of possible sequences that meet the templates constraints."},
		{"possibleSubsequences[template : _?SequenceQ,included:{SequenceP..}]", "subsequences:{SequenceP...}", "given a degenerate template returns a list of possible sequences that meet the templates constraints from the included list."}
	},
	MoreInformation -> {
		"Requires the template, the included subsequences, the Next and Previous sequences to all be of the same type and the same length (or null)."
	},
	Input :> {
		{"template", _?SequenceQ, "The template sequence (with degenracy) that must be fuilled."},
		{"included", {SequenceP...}, "The sequences that are included in analysis."}
	},
	Output :> {
		{"subsequences", {SequenceP...}, "The potentially next subsequence."}
	},
	SeeAlso -> {
		"NextSubsequences",
		"previousSubsequences"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*junctionSubsequences*)


DefineUsage[junctionSubsequences,
{
	BasicDefinitions -> {
		{"junctionSubsequences[motifMap,junct,k]", "subs", "returns all the subsequences at the junction sites on the basis of a motif map."},
		{"junctionSubsequences[strands,k]", "subs", "returns all the subsequences at the junction sites on teh basis of a set of strands."}
	},
	MoreInformation -> {
		"Must Convert everything to canonocal form (DNA only) so that the junctions make sense."
	},
	Input :> {
		{"motifMap", {(_String -> {(SequenceP | {SequenceP..})..})..}, "List of rules from motif to the subsequences of that motif (matches the output produced by subsequences on strands or structures)."},
		{"junct", {{_String, _String}...}, "List of junctions between the motifs in the form {from,to} coutning from 5' to 3'."},
		{"strands", {StrandP...} | {StructureP...}, "List of strands or structures you wish to generate the junction subsequences for."},
		{"k", _Integer, "Subsequence level upon which you want to break down the subsequences."}
	},
	Output :> {
		{"subs", {SequenceP..}, "List of subsequences at the junction sites spanning between each motif."}
	},
	SeeAlso -> {
		"junctions",
		"EmeraldSubsequences"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*removeList*)


DefineUsage[removeList,
{
	BasicDefinitions -> {
		{"removeList[source_List,remove_list]", "removed_List", "return the source list with each element in the remove list removed once"}
	},
	MoreInformation -> {
		"Each element in 'remove' will remove at most one element from 'source'",
		"To remove multiple copies of an element from source, that element must be in 'remove' multiple times"
	},
	Input :> {
		{"'source'", _, "initial list to remove items from"},
		{"'remove'", _, "list of items to be removed from the source"}
	},
	Output :> {
		{"removed", _, "the source list with each item in the remove list removed once."}
	},
	SeeAlso -> {
		"removeOnce",
		"ArrayReshape"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*junctions*)


DefineUsage[junctions,
{
	BasicDefinitions -> {
		{"junctions[item:({StrandP..})]", "motifs:{{from_String,to_String}..}", "given a Structure or list of junctions between motifs as a list of the neighboring motifs."}
	},
	Input :> {
		{"item", _, "Structure or list of strands you wish to determine the junctions of."}
	},
	Output :> {
		{"motifs", _, "List of neighboring motifs."},
		{"to", _, "Starting motif."},
		{"from", _, "Ending motif."}
	},
	SeeAlso -> {
		"EmeraldSubsequences",
		"SubsequencesDistance"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*buildSequence*)


DefineUsage[buildSequence,
{
	BasicDefinitions -> {
		{"buildSequence[subsequences : {_?SequenceQ..}]", "sequence : _?SequenceQ", "builds a single sequence from an collection of overlapping subsequences."}
	},
	Input :> {
		{"subsequences", {_?SequenceQ..}, "List of overlapping subsequence that the final sequence should be composed of. Passes constructableQ."}
	},
	Output :> {
		{"sequence", _?SequenceQ, "The combined sequence constructed form the collection of overlapping subsequence fragments."}
	},
	SeeAlso -> {
		"EmeraldSubsequences",
		"subsequencesQ"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*NextSubsequences*)


DefineUsage[NextSubsequences,
{
	BasicDefinitions -> {
		{"NextSubsequences[sequence_?SequenceQ]", "next:{_?SequenceQ..}", "given a sequence, gives a list of all the possible subsequences of the same length that could have come after in a larger sequence assuming that any subsequence is valid."},
		{"NextSubsequences[sequence_?SequenceQ,subsequences:{_?SequenceQ..}]", "previous:{_?SequenceQ..}", "given a starting edge or node sequence and a list of possible subsequences to traverse to, returns the subsequences which could have come after in a larger sequence."}
	},
	Input :> {
		{"sequence", _, "The starting subsequence (either node or edge) from which the next subsequences must originate."}
	},
	Output :> {
		{"next", _, "A list of the possible next subsequences that could follow the provided sequence."},
		{"previous", _, "A list of subsequences that could follow the provided sequence, given a starting edge or node sequence and a list of possible subsequences to traverse to."}
	},
	SeeAlso -> {
		"previousSubsequences",
		"nextSubsequencesQ",
		"previousSubsequencesQ"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*nextSubsequencesQ*)


DefineUsage[nextSubsequencesQ,
{
	BasicDefinitions -> {
		{"nextSubsequencesQ[sequenceA_?SequenceQ,sequenceB_?SequenceQ]", "isNext:BooleanP", "returns true if sequenceA could have come directly before sequenceB as overlapping subsequences."}
	},
	MoreInformation -> {
		"sequenceA can either be an edge (same length as sequenceB) or a node (one shorter than sequence B"
	},
	Input :> {
		{"sequenceA", _, "The potentially previous subsequence."},
		{"sequenceB", _, "The potentially next subsequence."}
	},
	Output :> {
		{"isNext", _, "True if sequenceA overlaps sequenceB such that it could proceed sequenceB as a subsequence."}
	},
	SeeAlso -> {
		"previousSubsequencesQ",
		"NextSubsequences",
		"previousSubsequences"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*previousSubsequences*)


DefineUsage[previousSubsequences,
{
	BasicDefinitions -> {
		{"previousSubsequences[sequence_?SequenceQ]", "previous:{_?SequenceQ..}", "given a sequence, gives a list of all the possible subsequences of the same length that could have come before in a larger sequence assuming that any subsequence is valid."},
		{"previousSubsequences[sequence_?SequenceQ,subsequences:{_?SequenceQ..}]", "previous:{_?SequenceQ..}", "given a staring edge or node sequence and a list of possible subsequences to have traversed from, returns the subsequences which could have come before in a larger sequence."}
	},
	Input :> {
		{"sequence", _, "The starting subsequence (either node or edge) from which the previous subsequences must originate."}
	},
	Output :> {
		{"previous", _, "A list of the possible previous subsequences that could proceede the provided sequence."}
	},
	SeeAlso -> {
		"NextSubsequences",
		"nextSubsequencesQ",
		"previousSubsequencesQ"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*previousSubsequencesQ*)


DefineUsage[previousSubsequencesQ,
{
	BasicDefinitions -> {
		{"previousSubsequencesQ[sequenceA_?SequenceQ,sequenceB_?SequenceQ]", "isPrevious:BooleanP", "returns true if sequenceA could have come directly after sequenceB as overlapping subsequences."}
	},
	MoreInformation -> {
		"sequenceA can either be an edge (same length as sequenceB) or a node (one shorter than sequence B"
	},
	Input :> {
		{"sequenceA", _, "The potentially next subsequence."},
		{"sequenceB", _, "The potentially previous subsequence."}
	},
	Output :> {
		{"isPrevious", _, "True if sequenceA overlaps sequenceB such that sequenceB could proceed sequenceA as a subsequence."}
	},
	SeeAlso -> {
		"nextSubsequencesQ",
		"NextSubsequences",
		"previousSubsequences"
	},
	Author -> {"tommy.harrelson", "frezza"}
}];


(* ::Subsubsection:: *)
(*AllPalindromes*)


DefineUsage[AllPalindromes,
{
	BasicDefinitions -> {
		{"AllPalindromes[n]", "palindromes", "given a length n, returns all palindromic sequences of length n."}
	},
	MoreInformation -> {
		"Palindromic sequences are sequences which are their own reverse complement."
	},
	Input :> {
		{"n", GreaterP[-1,1], "The length of the palindromes you wish to generate."}
	},
	Output :> {
		{"palindromes", {_?SequenceQ..}, "List of all possible palindromes of length 'n'."}
	},
	SeeAlso -> {
		"AllSequences",
		"SequencePalindromeQ",
		"RandomSequence"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*AllSequences*)


DefineUsage[AllSequences,
{
	BasicDefinitions -> {
		{"AllSequences[n]", "sequences", "returns a list of all possible sequences of length n."}
	},
	Input :> {
		{"n", GreaterP[-1,1], "The lenght of the sequences to generate."}
	},
	Output :> {
		{"sequences", _?SequenceQ, "A list of all possible sequenes length n."}
	},
	SeeAlso -> {
		"AllPalindromes",
		"RandomSequence",
		"ReverseComplementSequence"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*buildSequence*)


(* ::Subsubsection::Closed:: *)
(*EmeraldSubsequences*)


DefineUsage[EmeraldSubsequences,
{
	BasicDefinitions -> {
		{"EmeraldSubsequences[sequence,n]", "subsequences", "breaks the provides sequence into a list of overlapping subsequences of length n."},
		{"EmeraldSubsequences[sequence,n,Span[minIndex,maxIndex]]", "subsequences", "breaks the provides sequence into a list of overlapping subsequences of length n from the minIndex to the maxIndex."},
		{"EmeraldSubsequences[sequence]", "subsequences", "breaks the provides sequence into a list of overlapping subsequences from length 1 to the length of the sequence."},
		{"EmeraldSubsequences[sequence,Span[minIndex,maxIndex]]", "subsequences", "breaks the provides sequence into a list of overlapping subsequences of length 1 to the length of the sequence from the minIndex to the maxIndex."},
		{"EmeraldSubsequences[cmplex,n]", "motifSubsequence", "given a Structure, and a level n, returns a list of rules for each subsequence of each unique motif in the set of strands of the Structure."},
		{"EmeraldSubsequences[strands,n]", "motifSubsequence", "given a list of strands, and a level n, returns a list of rules for each subsequence of each unique motif in the set of strands."}
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to deconstruct into subsequences."},
		{"strands", _?StrandQ, "A list of strands you wish to deconstruct into subsequences for each motif."},
		{"cmplex", _?StructureQ, "The Structure you wish to deconstruct into subsequences for each motif."},
		{"n", GreaterP[0,1], "The size of the overlapping fragments to generate."},
		{"minIndex", GreaterP[0,1], "The minimum index to be included in the list of subsequences (including all overlaps that intersect the minIndex)."},
		{"maxIndex", GreaterP[0,1], "The maximum index to be included in the list of subsequences (including all overlaps that intersect the maxIndex)."}
	},
	Output :> {
		{"subsequences", {_?SequenceQ..}, "List of overlapping subsequences."},
		{"motifSubsequence", {_?SequenceQ->{SequenceP..}}, "List of rules relating each motif to a list of subsequences in it."}
	},
	SeeAlso -> {
		"buildSequence",
		"AllSequences"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*FoldingMatrix*)


DefineUsage[FoldingMatrix,
{
	BasicDefinitions -> {
		{"FoldingMatrix[sequence,k]", "matrix", "this function takes a sequence and returns a matrix descirbing if the ovelapping subsequenes of length 'k' from start to finish could fold onto eachother where 1 specifies a posible fold, and 0 specifies no fold."},
		{"FoldingMatrix[sequence,k,Span[m,n]]", "matrix", "this function takes a sequence and returns a matrix descirbing if the ovelapping subsequenes of length 'k' in the range from position m to n could fold onto eachother where 1 specifies a posible fold, and 0 specifies no fold."}
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"matrix", {{1 | (0)..}..}, "A matrix of possibles folds between overlapping subsequences at their corresponding position in the matrix where 1 specifies a posible fold, and 0 specifies no fold."}
	},
	SeeAlso -> {
		"FoldingSequences",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingMatrix",
		"RepeatingSequences",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*FoldingSequences*)


DefineUsage[FoldingSequences,
{
	BasicDefinitions -> {
		{"FoldingSequences[sequence,k]", "sequences", "this function takes a sequence and returns a list of subsequences of length 'k' from the entire sequence that could potentially fold."},
		{"FoldingSequences[sequence,k,Span[m,n]]", "sequences", "this function takes a sequence and returns a list of subsequences of length 'k' from the position m to positon n in the sequence that could potentially fold."},
		{"FoldingSequences[sequence]", "sequences", "this function takes a sequence and returns a list of subsequences from length spesified by the MinLevel option to the largest fold length present from the entire sequence that could potentially fold."},
		{"FoldingSequences[sequence,Span[m,n]]", "sequences", "this function takes a sequence and returns a list of subsequences from length spesified by the MinLevel option to the largest fold length present from the position m to positon n in the sequence that could potentially fold."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"sequences", {_?SequenceQ...}, "List of folding subsequences."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"sequences", {_?SequenceQ..}, "List of subsequences within the parent sequence that can be folded."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingMatrix",
		"RepeatingSequences",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*FoldsQ*)


DefineUsage[FoldsQ,
{
	BasicDefinitions -> {
		{"FoldsQ[sequence,k]", "folds", "this function returns true if in the provided sequence a fold of lenght 'k' exists anywhere in the sequence."},
		{"FoldsQ[sequence,k,Span[m,n]]", "folds", "this function returns true if in the provided sequence a fold of lenght 'k' exists in the space from position m to n."},
		{"FoldsQ[str,k]", "folds", "this function returns true if in the provided strand a fold of lenght 'k' not designated by motif Pairing exists anywhere."},
		{"FoldsQ[cmplx,k]", "folds", "this function returns true if in the provided Structure a fold of length 'k' not designated by motif Pairing exists anywhere."},
		{"FoldsQ[subsequences]", "folds", "given a list of subsequences, determines if any one of the subsequences in that list can bind to another."},
		{"FoldsQ[subsequences,testSequence]", "folds", "given a list of subsequences and a test sequences, determines if the test sequence could bind to any sequences in the subsequences list."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region.",
		"If ReverseComplementSequence motifs are incldue (IE B and B') then they will not be included in the consideration of folding (only non-motif designated folds are to be considered)."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"str", _?StrandQ, "The strand you wish to Analyze."},
		{"cmplx", _?StructureQ, "The Structure you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."},
		{"subsequences", {_?SequenceQ..}, "List of subseuqences you with to analyse."},
		{"testSequence", _?SequenceQ, "The sequence you wish to compare to a list of subsequences."}
	},
	Output :> {
		{"folds", BooleanP, "True if a fold of lenght k exists in the sequence and in any provided range."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"NumberOfFolds",
		"RepeatingMatrix",
		"RepeatingSequences",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*FractionAT*)


DefineUsage[FractionAT,
{
	BasicDefinitions -> {
		{"FractionAT[sequence]", "fraction", "determines the fraction of a given sequence composed of As or Ts."}
	},
	Input :> {
		{"sequence", _?DNAQ | _?PNAQ, "The sequence which you wish to determine the fraction composed of As and Ts."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPurine"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*FractionAU*)


DefineUsage[FractionAU,
{
	BasicDefinitions -> {
		{"FractionAU[sequence]", "fraction", "determines the fraction of a given sequence composed of As or Us."}
	},
	Input :> {
		{"sequence", _?RNAQ, "The seqeunce which you wish to determine the fraction composed of As and Us."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPurine"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*FractionGC*)


DefineUsage[FractionGC,
{
	BasicDefinitions -> {
		{"FractionGC[sequence]", "fraction", "determines the fraction of a given sequence composed of Gs or Cs."}
	},
	Input :> {
		{"sequence", (_?DNAQ|_?RNAQ|_?PNAQ), "The seqeunce which you wish to determine the fraction composed of Gs and Cs."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPurine"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*FractionMono*)


DefineUsage[FractionMono,
{
	BasicDefinitions -> {
		{"FractionMono[sequence,monos]", "fraction", "determines the fraction of a given sequence composed of members of the provided list of Monomers."}
	},
	Input :> {
		{"sequence", _?SequenceQ, "The seqeunce which you wish to determine the fraction composed of the list of monos."},
		{"monos", {_?SequenceQ..}, "A list of the Monomers you wish to determine the fraction of within the provided sequence."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPurine"
	},
	Author -> {
		"amir.saadat",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*FractionPurine*)


DefineUsage[FractionPurine,
{
	BasicDefinitions -> {
		{"FractionPurine[sequence]", "fraction", "determines the fraction of a given sequence composed of purines (As and Gs)."}
	},
	Input :> {
		{"sequence", (_?DNAQ|_?RNAQ|_?PNAQ), "The seqeunce which you wish to determine the fraction composed of purines (As and Gs)."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPyrimidine"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*FractionPyrimidine*)


DefineUsage[FractionPyrimidine,
{
	BasicDefinitions -> {
		{"FractionPyrimidine[sequence]", "fraction", "determines the fraction of a given sequence composed of pyrimidines (Cs, T's, and Us)."}
	},
	Input :> {
		{"sequence", (_?DNAQ|_?RNAQ|_?PNAQ), "The seqeunce which you wish to determine the fraction composed of pyrimidines (Cs, T's, and Us)."}
	},
	Output :> {
		{"fraction", _Real, "The fraction of Monomers within the provided sequence."}
	},
	SeeAlso -> {
		"FractionGC",
		"FractionAT",
		"FractionPurine"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*GenerateSequence*)


DefineUsage[GenerateSequence,
{
	BasicDefinitions -> {
		{"GenerateSequence[cmplx:StructureP]", "fullStructure:StructureP", "given a Structure, will fill in the degenerate bases with optimal sequence."},
		{"GenerateSequence[str:StrandP]", "fullStrand:StrandP", "given a strand, will fill in the degenerate bases with optimal sequence."},
		{"GenerateSequence[seq:SequenceP]", "fullSequence:SequenceP", "given a sequence, will fill in the degenerate bases with optimal sequence."},
		{"GenerateSequence[length_Integer]", "fullSequence:SequenceP", "given a length, will generate an optimal sequence of the provided length."}
	},
	MoreInformation -> {
		""
	},
	Input :> {
		{"cmplx", _, "Structure you wish to fill in with sequence."},
		{"str", _, "Strand you wish to fill in with sequence."},
		{"seq", _, "Sequence you wish to fill in with sequence."},
		{"length", _, "Length of sequence you wish to develop."}
	},
	Output :> {
		{"fullStructure", _, "Structure with degenerate sequence filled in."},
		{"fullStrand", _, "Strand with degenerate sequence filled in."},
		{"fullSequence", _, "Sequence with degenerate sequence filled in."}
	},
	SeeAlso -> {
		"Junction subsequences",
		"RandomSequence"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*junctions*)


(* ::Subsubsection:: *)
(*nextSubsequencesQ*)


(* ::Subsubsection:: *)
(*NumberOfFolds*)


DefineUsage[NumberOfFolds,
{
	BasicDefinitions -> {
		{"NumberOfFolds[sequence,k]", "folds", "this function takes a sequence and returns the total number of ovelapping subsequenes of length 'k' from start to finish that could fold."},
		{"NumberOfFolds[sequence,k,Span[m,n]]", "folds", "this function takes a sequence and returns the total number of ovelapping subsequenes of length 'k' from position m to position n that could fold."},
		{"NumberOfFolds[sequence]", "folds", "this function takes a sequence and returns the total number of ovelapping subsequenes of length provided by the MinLevel option to the largest length fold present from start to finish that could fold."},
		{"NumberOfFolds[sequence,Span[m,n]]", "folds", "this function takes a sequence and returns the total number of ovelapping subsequenes of length provided by the MinLevel option to the largest length fold from position m to position n that could fold."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"folds", GreaterP[-1,1], "The number of folds in the provided sequence (and position span if provided) of length k that could fold."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"FoldsQ",
		"RepeatingMatrix",
		"RepeatingSequences",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*NumberOfRepeats*)


DefineUsage[NumberOfRepeats,
{
	BasicDefinitions -> {
		{"NumberOfRepeats[sequence,k]", "repeats", "this function takes a sequence and returns the total number of ovelapping subsequenes of length 'k' from start to finish that are repeated."},
		{"NumberOfRepeats[sequence,k,Span[m,n]]", "repeats", "this function takes a sequence and returns the total number of ovelapping subsequenes of length 'k' from position m to position n that are repeated."},
		{"NumberOfRepeats[sequence]", "repeats", "this function takes a sequence and returns the total number of ovelapping subsequenes of length provided by the MinLevel option to the largest length repeat present from start to finish that are repeated."},
		{"NumberOfRepeats[sequence,Span[m,n]]", "repeats", "this function takes a sequence and returns the total number of ovelapping subsequenes of length provided by the MinLevel option to the largest length repeat from position m to position n that are repeated."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"repeats", GreaterP[-1,1], "The number of repeated subsequences in the provided sequence (and position span if provided) of length k that could fold."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingMatrix",
		"RepeatingSequences",
		"RepeatsQ"
	},
	Author -> {"alou", "robert"}
}];


(* ::Subsubsection:: *)
(*possibleSubsequences*)


(* ::Subsubsection:: *)
(*previousSubsequences*)


(* ::Subsubsection:: *)
(*previousSubsequencesQ*)


(* ::Subsubsection:: *)
(*RandomSequence*)


DefineUsage[RandomSequence,
{
	BasicDefinitions -> {
		{"RandomSequence[length]", "seq", "returns a random sequence of the requested length."},
		{"RandomSequence[length,n]", "seqs", "returns n number of random sequences of the reuested length."}
	},
	Input :> {
		{"length", GreaterP[-1,1], "The length of the sequence you wish to generate."},
		{"n", GreaterP[0,1], "The number of sequences to generate."}
	},
	Output :> {
		{"seq", _?SequenceQ, "A random sequence of provided length."},
		{"seqs", {_?SequenceQ..}, "A number of random sequences of provided length n."}
	},
	SeeAlso -> {
		"AllSequences",
		"GenerateSequence"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*RepeatingMatrix*)


DefineUsage[RepeatingMatrix,
{
	BasicDefinitions -> {
		{"RepeatingMatrix[sequence,k]", "matrix", "this function takes a sequence and returns a matrix descirbing if the ovelapping subsequenes of length 'k' from start to finish that are repeated where 1 specifies a repeat, and 0 specifies a unique subsequence."},
		{"RepeatingMatrix[sequence,k,Span[m,n]]", "matrix", "this function takes a sequence and returns a matrix descirbing if the ovelapping subsequenes of length 'k' in the range from position m to n are repeated where 1 specifies a repeat, and 0 specifies a unique subsequence."}
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"matrix", {{(1|0)..}..}, "A matrix of possibles repeats of overlapping subsequences at their corresponding position in the matrix where 1 specifies a repeated subsequence, and 0 specifies a unique subsequence."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingSequences",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*RepeatingSequences*)


DefineUsage[RepeatingSequences,
{
	BasicDefinitions -> {
		{"RepeatingSequences[sequence,k]", "sequences", "this function takes a sequence and returns a list of subsequences of length 'k' from the entire sequence that are repeated."},
		{"RepeatingSequences[sequence,k,Span[m,n]]", "sequences", "this function takes a sequence and returns a list of subsequences of length 'k' from the position m to positon n in the sequence that are repeated."},
		{"RepeatingSequences[sequence]", "sequences", "this function takes a sequence and returns a list of subsequences from length spesified by the MinLevel option to the largest repeat length present from the entire sequence that are repeated."},
		{"RepeatingSequences[sequence,Span[m,n]]", "sequences", "this function takes a sequence and returns a list of subsequences from length spesified by the MinLevel option to the largest repeat length present from the position m to positon n in the sequence that are repeated."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."}
	},
	Output :> {
		{"sequences", {_?SequenceQ..}, "List of subsequences of lenght 'k' within the parent sequence that are repeated one or more times."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingMatrix",
		"NumberOfRepeats",
		"RepeatsQ"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*RepeatsQ*)


DefineUsage[RepeatsQ,
{
	BasicDefinitions -> {
		{"RepeatsQ[sequence,k]", "repeats", "the function returns true if in the provided sequence a repeated subseuqence of lenght 'k' exists anywhere in the sequence."},
		{"RepeatsQ[sequence,k,Span[m,n]]", "repeats", "the function returns true if in the provided sequence a repeate subsequence of lenght 'k' exists in the space from position m to n."},
		{"RepeatsQ[str,k]", "repeats", "the function returns true if in the provided strand a repeat of lenght 'k' not designated by motif Pairing exists anywhere."},
		{"RepeatsQ[cmplx,k]", "repeats", "the function returns true if in the provided Structure a repeat of length 'k' not designated by motif Pairing exists anywhere."},
		{"RepeatsQ[subsequences]", "repeats", "given a list of subsequences, determines if any one of the subsequences in that list repeates more than once."},
		{"RepeatsQ[subsequences,testSequence]", "repeats", "given a list of subsequences and a test sequences, determines if the test sequences appears in the subsequences anywhere."}
	},
	MoreInformation -> {
		"When spans are provided returns any sequences of length k which inclusively contact the provided region."
	},
	Input :> {
		{"sequence", _?SequenceQ, "The sequence you wish to Analyze."},
		{"str", _?StrandQ, "The strand you wish to Analyze."},
		{"cmplx", _?StructureQ, "The Structure you wish to Analyze."},
		{"k", GreaterP[0,1], "The lenght of overlapping subsequences to employ."},
		{"m", GreaterP[0,1], "The starting position for a provided span (inclusive)."},
		{"n", GreaterP[0,1], "The ending position for a provided span (inclusive)."},
		{"subsequences", {_?SequenceQ..}, "List of subseuqences you with to analyse."},
		{"testSequence", _?SequenceQ, "The sequence you wish to compare to a list of subsequences."}
	},
	Output :> {
		{"repeats", BooleanP, "True if a repeated subsequence of length k exists in the sequence and in any provided range."}
	},
	SeeAlso -> {
		"FoldingMatrix",
		"FoldingSequences",
		"NumberOfFolds",
		"FoldsQ",
		"RepeatingMatrix",
		"RepeatingSequences",
		"NumberOfRepeats"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection:: *)
(*subsequencesQ*)
Authors[subsequencesQ]:={"brad"};