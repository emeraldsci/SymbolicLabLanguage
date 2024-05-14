(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Sequence Composition*)


(* ::Subsubsection::Closed:: *)
(*FractionMono*)


DefineOptions[FractionMono,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];

(* Find all degenerate alphabets that "Any" represents *)
degenFractionPeptideAny:=degenFractionPeptideAny=Module[{},
	Select[Download[Model[Physics,Oligomer,"Peptide"],DegenerateAlphabet],First[#]==="Any"&][[;;,2]]
];

degenFraction["N", monoToCnt_, RNA]:= degenFraction["N", monoToCnt] = Count[{"A", "U", "G", "C"}, Alternatives@@monoToCnt]/4;

(* The monomers for LNAChimera are different than those of DNA and RNA *)
degenFraction["N", monoToCnt_, LNAChimera]:= degenFraction["N", monoToCnt] = Count[{"mU*","mC*","mG*","mA*","+T*","+U*","+A*","+C*","+G*","fU*","fC*""fG*","fA*","mU","mC","mG","mA","+T","+U","+A","+C","+G","fU","fC""fG","fA"}, Alternatives@@monoToCnt]/13;

(* For any other oligomer type *)
degenFraction["N", monoToCnt_, _]:= degenFraction["N", monoToCnt] = Count[{"A", "T", "G", "C"}, Alternatives@@monoToCnt]/4;

degenFraction["Any", monoToCnt_, Peptide]:= degenFraction["Any", monoToCnt] = Count[degenFractionPeptideAny, Alternatives@@monoToCnt]/21;
degenFraction[other_, monoToCnt_, _]:= If[MemberQ[monoToCnt, other], 1, 0];


fractionMonoCore[$Failed, ___]:= $Failed;

fractionMonoCore[monos_, monoToCnt_, degenQ_]:=
	If[degenQ,
		Total[degenFraction[#, monoToCnt, Head[First[monos]]]&/@UnTypeSequence[monos]]/Length[monos],
		Count[UnTypeSequence[monos], Alternatives@@monoToCnt]/Length[monos]
	];


FractionMono[seqs:{SequenceP..}, monoToCnt:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, monosList, untypedMonoToCnt},

	safeOps = SafeOptions[FractionMono, ToList[ops]];

	(* obtain the monomers *)
	monosList = Monomers[seqs, ExplicitlyTyped->True, PassOptions[FractionMono, Monomers, safeOps]];

	untypedMonoToCnt = UnTypeSequence[monoToCnt];

	fractionMonoCore[#, untypedMonoToCnt, Degeneracy/.safeOps]&/@monosList

];


FractionMono[seq:SequenceP, monoToCnt:{SequenceP..}, ops:OptionsPattern[]]:= First[FractionMono[{seq}, monoToCnt, ops]];


FractionMono[seqs:{SequenceP..},monoToCnts:{{SequenceP..}..}, ops:OptionsPattern[]]:= MapThread[FractionMono[#1, #2, ops]&,{seqs,monoToCnts}]/;SameLengthQ[seqs,monoToCnts]


(* ::Subsubsection::Closed:: *)
(*FractionGC*)


DefineOptions[FractionGC,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Core Function --- *)
FractionGC[sequence:(_?DNAQ|_?RNAQ|_?PNAQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"G","C"}, PassOptions[FractionGC, FractionMono, ops]];

(* For LNAChimera, count the number of all variants of G and C *)
FractionGC[sequence:(_?LNAChimeraQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"mG*","fG*","+G*","mC*","fC*","+C*","mG","fG","+G","mC","fC","+C"}, PassOptions[FractionGC, FractionMono, ops]];

(* This should in principle work for any polymer type *)
FractionGC[sequence:PolymerP, ops:OptionsPattern[]]:= FractionMono[sequence,{"G","C"}, PassOptions[FractionGC, FractionMono, ops]];

(* --- FastTrack version --- *)
FractionGC[sequence_String, ops:OptionsPattern[]]:= StringCount[sequence,{"G","C"}]/StringLength[sequence]/;OptionValue[FastTrack]

SetAttributes[FractionGC,{Listable}];


(* ::Subsubsection::Closed:: *)
(*FractionAT*)


DefineOptions[FractionAT,
	Options :> {
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Core Function --- *)
FractionAT[sequence:(_?DNAQ|_?PNAQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"A","T"}, PassOptions[FractionAT, FractionMono, ops]];

(* For LNAChimera, count the number of all variants of A and T *)
FractionAT[sequence:(_?LNAChimeraQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"mA*","fA*","+A*","+T*","mA","fA","+A","+T"}, PassOptions[FractionAT, FractionMono, ops]];

(* This should in principle work for any type of polymer *)
FractionAT[sequence:PolymerP, ops:OptionsPattern[]]:= FractionMono[sequence,{"A","T"}, PassOptions[FractionAT, FractionMono, ops]];

(* --- FastTrack version --- *)
FractionAT[sequence_String, ops:OptionsPattern[]]:= StringCount[sequence,{"A","T"}]/StringLength[sequence]/;OptionValue[FastTrack]

SetAttributes[FractionAT,{Listable}];


(* ::Subsubsection:: *)
(*FractionAU*)


DefineOptions[FractionAU,
	Options :> {
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Core Function --- *)
FractionAU[sequence_?RNAQ, ops:OptionsPattern[]]:= FractionMono[sequence,{"A","U"}, PassOptions[FractionAU, FractionMono, ops]];

(* For LNAChimera, count the number of all variants of A and T *)
FractionAU[sequence:(_?LNAChimeraQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"mA","fA","+A","mU","fU","+U"}, PassOptions[FractionAU, FractionMono, ops]];

(* This should in principle work for any type of polymer *)
FractionAU[sequence:PolymerP, ops:OptionsPattern[]]:= FractionMono[sequence,{"A","U"}, PassOptions[FractionAU, FractionMono, ops]];

(* --- FastTrack version --- *)
FractionAU[sequence_String, ops:OptionsPattern[]]:= StringCount[sequence,{"A","U"}]/StringLength[sequence]/;OptionValue[FastTrack]

SetAttributes[FractionAU,{Listable}];


(* ::Subsubsection:: *)
(*FractionPyrimidine*)


DefineOptions[FractionPyrimidine,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Core Function --- *)
FractionPyrimidine[sequence:(_?DNAQ|_?RNAQ|_?PNAQ), ops:OptionsPattern[]]:= FractionMono[sequence, {"T","C","U"}, PassOptions[FractionPyrimidine, FractionMono, ops]];

(* --- FastTrack version --- *)
FractionPyrimidine[sequence_String, ops:OptionsPattern[]]:= StringCount[sequence, {"T","C","U"}]/StringLength[sequence]/;OptionValue[FastTrack]

SetAttributes[FractionPyrimidine,{Listable}];


(* ::Subsubsection:: *)
(*FractionPurine*)


DefineOptions[FractionPurine,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Core Function --- *)
FractionPurine[sequence:(_?DNAQ|_?RNAQ|_?PNAQ), ops:OptionsPattern[]]:= FractionMono[sequence,{"A","G"}, PassOptions[FractionPurine, FractionMono, ops]];

(* --- FastTrack version --- *)
FractionPurine[sequence_String, ops:OptionsPattern[]]:= StringCount[sequence,{"A","G"}]/StringLength[sequence]/;OptionValue[FastTrack]

SetAttributes[FractionPurine,{Listable}];


(* ::Subsection:: *)
(*Sequence Properties*)


(* ::Subsubsection:: *)
(*FoldingMatrix*)


DefineOptions[FoldingMatrix,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, True | False, "If set to true, will count any degenerate posibilties that could match as valid (eg. DNA[\"N \"] will count against anything)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Verions --- *)
FoldingMatrix[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
	{type,fragments,rcFragments},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[FoldingMatrix,PolymerType,ops]];

	(* Determine the explicitly typed subsequences of the sequence *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[FoldingMatrix,EmeraldSubsequences,ops]];

	(* determine the revcom of all of the fragments *)
	rcFragments=Quiet[
		ReverseComplementSequence[fragments,Polymer->type,IncludeModification->False,ExplicitlyTyped->False,PassOptions[FoldingMatrix,ReverseComplementSequence,ops]],
		{ComplementSequence::RemoveModification}
	];

	(* Generate a matrix of the subsequences vs. themselves, 1 where the subsequences could bind and 0 where they don't *)
	Table[
		If[MatchQ[fragments[[x]],rcFragments[[y]]],1,0],
		{x,Length[fragments]},
		{y,Length[rcFragments]}
	]

]/;OptionValue[FastTrack]


(* --- Spans --- *)
FoldingMatrix[sequence:SequenceP,k:GreaterP[0,1],Span[minIndex:GreaterP[0,1],maxIndex:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length,probeSubSequences,rcProbes,targetSubSequences},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[FoldingMatrix,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,PassOptions[FoldingMatrix,SequenceLength,ops]];

	(* Determine the explicitly typed subsequences of the entire sequence *)
	targetSubSequences=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[FoldingMatrix,EmeraldSubsequences,ops]];

	(* Determine the explicitly typed subsequences of the only in the spesified span *)
	probeSubSequences=Take[targetSubSequences,Span[Max[minIndex-(k-1),1],Min[maxIndex,length-(k-1)]]];

	(* Obtain the reverse compliment of the probes *)
	rcProbes=Quiet[
		ReverseComplementSequence[probeSubSequences,Polymer->type,IncludeModification->False,ExplicitlyTyped->False,PassOptions[FoldingMatrix,ReverseComplementSequence,ops]],
		{ComplementSequence::RemoveModification}
	];

	(* Generate a matrix of the probe subsequences vs. the target subsequences, 1 where the subsequences could bind and 0 where they don't *)
	Table[
		If[MatchQ[rcProbes[[x]],targetSubSequences[[y]]],1,0],
		{x,Length[rcProbes]},
		{y,Length[targetSubSequences]}
	]

]/;OptionValue[FastTrack]


(* --- Core Functions --- *)
FoldingMatrix[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldingMatrix[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[FoldingMatrix,SequenceQ,ops]]
FoldingMatrix[sequence:SequenceP,k:GreaterP[0,1],range:Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[FoldingMatrix,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[FoldingMatrix,SequenceLength,ops]];

	(* Be sure to buffer the span values to make sure they are in the valid range *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call folding sequence in the apprate range(s) *)
			FoldingMatrix[sequence,k,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

];

SetAttributes[FoldingMatrix,Listable];


(* ::Subsubsection::Closed:: *)
(*FoldingSequences*)


DefineOptions[FoldingSequences,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, True | False, "If set to true, will count any degenerate posibilties that could match as valid (eg. DNA[\"N \"] will count against anything)."},
		{MinLevel -> 1, _Integer, "If no length 'k' is provided returns only the subsequence of length MinLevel or higher."},
		{Consolidate -> True, True | False, "If no length 'k' is provided counts only the largest occurance of a subsequence (e.g. if a folding subsequence of length 6 exists, and consolidate is true, does not return the composite 5,4,3,2,1-mer folds that exist entirely within the 6mer fold)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output sequence in its type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input or sequence and false if not.", Category->Hidden}
	}
];


(* --- FastTrack Versions --- *)
FoldingSequences[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:= Module[
	{type,fragments,rcFragments,repeatedFolds,folds},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* Break the sequence into all relivent subsequences at level k *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[FoldingSequences,EmeraldSubsequences,ops]];

	(* generate a list of all ReverseComplementSequence sequences *)
	rcFragments=Quiet[
		ReverseComplementSequence[fragments,Polymer->type,IncludeModification->False,ExplicitlyTyped->False,PassOptions[FoldingSequences,ReverseComplementSequence,ops]],
		{ComplementSequence::RemoveModification}
	];

	(* pan though the sequences, for each time a sequence's ReverseComplementSequence is found, include the sequence that many times*)
	repeatedFolds=Flatten[Table[#,{Count[rcFragments,#]}]&/@fragments];

	(* Since each sequence is reapated n number of times (for each redundent match found), flatten out the list *)
	folds=Flatten[repeatedFolds];

	(* explicitly type the output as requested *)
	ExplicitlyType[sequence,folds,PassOptions[FoldingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


FoldingSequences[sequence:SequenceP,k:GreaterP[0,1],Span[min:GreaterP[0,1],max:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
{type,fragments,rcFragments,length,probeFragments,repeatedFolds,folds},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* determine the lenght of the sequence *)
	length=SequenceLength[sequence,Polymer->type,PassOptions[FoldingSequences,SequenceLength,ops]];

	(* Break the sequence into all relivent subsequences at level k *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[FoldingSequences,EmeraldSubsequences,ops]];

	(* generate a list of all ReverseComplementSequence sequences *)
	rcFragments=Quiet[
		ReverseComplementSequence[fragments,Polymer->type,IncludeModification->False,ExplicitlyTyped->False,PassOptions[FoldingSequences,ReverseComplementSequence,ops]],
		{ComplementSequence::RemoveModification}
	];

	(* Grabe the relevent subsequence fragments from the provided range *)
	probeFragments=Take[fragments,Span[Max[min-(k-1),1],Min[max,length-(k-1)]]];

	(* pan though the sequences, for each time a sequence's ReverseComplementSequence is found, include the sequence that many times*)
	repeatedFolds=Flatten[Table[#,{Count[rcFragments,#]}]&/@probeFragments];

	(* Since each sequence is reapated n number of times (for each redundent match found), flatten out the list *)
	folds=Flatten[repeatedFolds];

	(* explicitly type the output as requested *)
	ExplicitlyType[sequence,folds,PassOptions[FoldingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- folding at every level --- *)
FoldingSequences[sequence:SequenceP,ops:OptionsPattern[]]:=Module[{type,length,folds},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,PassOptions[FoldingSequences,SequenceLength,ops]];

	(* now return the folding sequences from the full span *)
	FoldingSequences[sequence,Span[1,length],Polymer->type,ops]

]/;OptionValue[FastTrack]

FoldingSequences[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,untyped,recursiveFolds,folds,consolidated},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* String any type information from the sequence *)
	untyped=UnTypeSequence[sequence];

	(* recursively determine the folds with k going from the minlevel upwards until no further folds are found *)
	recursiveFolds=recursiveFolding[untyped,OptionValue[MinLevel],range,{},Polymer->type,PassOptions[FoldingSequences,recursiveFolding,ops]];
	(* this works becuase you can not have a fold at level k without having folds at all levels less than k *)

	(* If consolidate is on, remove all redundent subsequence fragments leaving only the largest for each fold *)
	folds=If[OptionValue[Consolidate],
		consolidateSequence[recursiveFolds,type],
		Flatten[recursiveFolds]
	];

	(* now return teh folding sequence typed as requested *)
	ExplicitlyType[sequence,folds,PassOptions[FoldingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- Core Function --- *)
FoldingSequences[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldingSequences[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[FoldingSequences,SequenceQ,ops]]
FoldingSequences[sequence:SequenceP,k:GreaterP[0,1],Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length,min,max},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[FoldingSequences,SequenceLength,ops]];

	(* Buffer the selection range to whats allowed *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call folding sequence in the apprate range(s) *)
			FoldingSequences[sequence,k,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

]/;SequenceQ[sequence,PassOptions[FoldingSequences,SequenceQ,ops]]


FoldingSequences[sequence:SequenceP,ops:OptionsPattern[]]:=FoldingSequences[sequence,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[FoldingSequences,SequenceQ,ops]]
FoldingSequences[sequence:SequenceP,Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[{type,length,min,max},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[FoldingSequences,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[FoldingSequences,SequenceLength,ops]];

	(* Buffer the selection range to whats allowed *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call folding sequence in the apprate range(s) *)
			FoldingSequences[sequence,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

]/;SequenceQ[sequence,PassOptions[FoldingSequences,SequenceQ,ops]]

SetAttributes[FoldingSequences,Listable];


(* --- Recursive folding helper function --- *)
(* Calculates the folding sequence starting at the bottom level and increasing recursively to stop only when no more folds are found *)
Options[recursiveFolding]={
	Polymer->Automatic,
	MinLevel->1,
	FastTrack->False
};
recursiveFolding[sequence_,level:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],folds_List,ops:OptionsPattern[]]:=Module[{levelFolds},

	(* Obtain all the folds at level n *)
	levelFolds=FoldingSequences[sequence,level,range,PassOptions[recursiveFolding,FoldingSequences,ops]];

	(* if there are no folds at this level, or we've reach the maximum size, just return the accumlated resuls
	Otherwise continue to the next level upwards *)
	If[Length[levelFolds]>0&&level<=StringLength[sequence],
		recursiveFolding[sequence,level+1,range,Prepend[folds,levelFolds],ops],
		folds
	]
]

(* --- consolidate sequenece helper function --- *)
(* Takes redeundent folds at  *)
consolidateSequence[{},PolymerP]:={}
consolidateSequence[items_List,type:PolymerP]:=Block[{$RecursionLimit=\[Infinity],$ItterationLimit=\[Infinity]},consolidateSequence[items,{},type]]
consolidateSequence[items_List,final_List,type:PolymerP]:=Flatten[Append[final,First[items]]]/;Length[items]<=1
consolidateSequence[items_List,final_List,type:PolymerP]:=Module[{exclude,newItems},

	(* generate the list of smaller fragments to be removed from the list *)
	exclude=Flatten[EmeraldSubsequences[First[items],Polymer->type,FastTrack->True,ExplicitlyTyped->False]];

	(* remove the generated fragments from the list *)
	newItems=removeList[#,exclude]&/@Rest[items];

	(* recursively continue consolidation *)
	consolidateSequence[newItems,Append[final,First[items]],type]

]/;Length[items]>1


(* ::Subsubsection::Closed:: *)
(*NumberOfFolds*)


DefineOptions[NumberOfFolds,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{MinLevel -> 1, _Integer, "If no length 'k' is provided returns only the subsequence of length MinLevel or higher."},
		{Consolidate -> True, True | False, "If no length 'k' is provided counts only the largest occurance of a subsequence (e.g. if a folding subsequence of length 6 exists, and consolidate is true, does not return the composite 5,4,3,2,1-mer folds that exist entirely within the 6mer fold)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Version ---- *)
NumberOfFolds[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Length[FoldingSequences[sequence,k,PassOptions[NumberOfFolds,FoldingSequences,ops]]]/;OptionValue[FastTrack]
NumberOfFolds[sequence:SequenceP,k:GreaterP[0,1],range:Span[_Integer,_Integer],ops:OptionsPattern[]]:=Length[FoldingSequences[sequence,k,range,PassOptions[NumberOfFolds,FoldingSequences,ops]]]/;OptionValue[FastTrack]
NumberOfFolds[sequence:SequenceP,ops:OptionsPattern[]]:=Module[
	{type,folds,grouped},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[NumberOfFolds,PolymerType]];

	(* calculate the folding *)
	folds=Reverse@FoldingSequences[sequence,Polymer->type,PassOptions[NumberOfFolds,FoldingSequences,ops]];

	(* Group the folds by their length *)
	grouped=GatherBy[folds,SequenceLength[#,Polymer->type,PassOptions[NumberOfFolds,SequenceLength,ops]]&];

	(* Determine the number of folds at each length level *)
	Length/@grouped

]/;OptionValue[FastTrack]

NumberOfFolds[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,folds,grouped},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[NumberOfFolds,PolymerType]];

	(* calculate the folding *)
	folds=Reverse@FoldingSequences[sequence,range,Polymer->type,PassOptions[NumberOfFolds,FoldingSequences,ops]];

	(* Group the folds by their length *)
	grouped=GatherBy[folds,SequenceLength[#,Polymer->type,PassOptions[NumberOfFolds,SequenceLength,ops]]&];

	(* Determine the number of folds at each length level *)
	Length/@grouped

]/;OptionValue[FastTrack]


(*--- Core Function --- *)
NumberOfFolds[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=NumberOfFolds[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfFolds,SequenceQ,ops]]
NumberOfFolds[sequence:SequenceP,k:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=NumberOfFolds[sequence,k,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfFolds,SequenceQ,ops]]
NumberOfFolds[sequence:SequenceP,ops:OptionsPattern[]]:=NumberOfFolds[sequence,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfFolds,SequenceQ,ops]]
NumberOfFolds[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=NumberOfFolds[sequence,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfFolds,SequenceQ,ops]]

SetAttributes[NumberOfFolds,Listable];


(* ::Subsubsection::Closed:: *)
(*FoldsQ*)


DefineOptions[FoldsQ,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{CanonicalPairing -> True, True | False, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Version with entire sequence --- *)
FoldsQ[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
{type,fragments,rawfragments,rawRevCompFragments,revCompFragments,folds},

	(* determine the type *)
	type=PolymerType[sequence,PassOptions[FoldsQ,PolymerType,ops]];

	(* Break the sequence into its composit fragments *)
	rawfragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* Generate a list of the revComps of the fragments*)
	rawRevCompFragments=ReverseComplementSequence[rawfragments,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* Convert the fragments to DNA if Canonical Pairing is on *)
	fragments=If[OptionValue[CanonicalPairing],
		ToDNA[rawfragments,FastTrack->True],
		rawfragments
	];

	(* Convert the rc-fragments to DNA if Canonical Pairing is on *)
	revCompFragments=If[OptionValue[CanonicalPairing],
		ToDNA[rawRevCompFragments,FastTrack->True],
		rawRevCompFragments
	];

	(* See if any of the fragments have a ReverseComplementSequence member of the group *)
	folds=Intersection[fragments,revCompFragments];

	(* If there are no folds, then it doesn't fold (duh) *)
	!MatchQ[folds,{}]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with spans --- *)
FoldsQ[sequence:SequenceP,k:GreaterP[0,1],range:Span[min:GreaterP[0,1],max:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
{type,fragments,rawfragments,rawRevCompFragments,revCompFragments,folds},

	(* determine the type *)
	type=PolymerType[sequence,PassOptions[FoldsQ,PolymerType,ops]];

	(* Break the sequence into its composit fragments *)
	rawfragments=EmeraldSubsequences[sequence,k,range,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* Generate a list of the revComps of the fragments*)
	rawRevCompFragments=ReverseComplementSequence[rawfragments,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* Convert the fragments to DNA if Canonical Pairing is on *)
	fragments=If[OptionValue[CanonicalPairing],
		ToDNA[rawfragments,FastTrack->True],
		rawfragments
	];

	(* Convert the rc-fragments to DNA if Canonical Pairing is on *)
	revCompFragments=If[OptionValue[CanonicalPairing],
		ToDNA[rawRevCompFragments,FastTrack->True],
		rawRevCompFragments
	];

	(* See if any of the fragments have a ReverseComplementSequence member of the group *)
	folds=Intersection[fragments,revCompFragments];

	(* If there are no folds, then it doesn't fold (duh) *)
	!MatchQ[folds,{}]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with Subsequence --- *)
FoldsQ[subseqs:{SequenceP..},ops:OptionsPattern[]]:=Module[
{fragments,rawRevCompFragments,revCompFragments,folds},

	(* Generate a list of the revComps of the fragments*)
	rawRevCompFragments=ReverseComplementSequence[subseqs,FastTrack->True];

	(* Convert the fragments to DNA if Canonical Pairing is on *)
	fragments=If[OptionValue[CanonicalPairing],
		ToDNA[subseqs,FastTrack->True],
		subseqs
	];

	(* Convert the rc-fragments to DNA if Canonical Pairing is on *)
	revCompFragments=If[OptionValue[CanonicalPairing],
		ToDNA[rawRevCompFragments,FastTrack->True],
		rawRevCompFragments
	];

	(* See if any of the fragments have a ReverseComplementSequence member of the group *)
	folds=Intersection[fragments,revCompFragments];

	(* If there are no folds, then it doesn't fold (duh) *)
	!MatchQ[folds,{}]

]/;OptionValue[FastTrack]

FoldsQ[subseqs:{SequenceP..},testSeq:SequenceP,ops:OptionsPattern[]]:=Module[{type,revTest,untyped},

	(* determine the type *)
	type=PolymerType[subseqs,Map->False,PassOptions[FoldsQ,PolymerType,ops]];

	(* Determine the reverse compliments of the test sequence *)
	revTest=ReverseComplementSequence[testSeq,ExplicitlyTyped->False,Polymer->type,FastTrack->True];

	(* Stripe the type from the sub sequences *)
	untyped=UnTypeSequence[subseqs];

	(* Check to see if the ReverseComplementSequence of teh testSeq shows up anywhere in the subsequence list *)
	MemberQ[untyped,revTest]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with strands --- *)
FoldsQ[rawStrands:{StrandP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
{motifMap,juncs,junctionSubs,strands,allSubs},

	(* Before we get started, name all of the motifs *)
	strands=NameMotifs[rawStrands];

	(* Pull up the motif map *)
	motifMap=EmeraldSubsequences[strands,k,ExplicitlyTyped->True,PassOptions[FoldsQ,EmeraldSubsequences,ops]];

	(* Determine the junction subsequences *)
	(*junctionSubs=junctionSubsequences[strands,k,FastTrack->True,ExplicitlyTyped->True];*)

	(* Gather togeather ALL OF THE SUBSEQUENCES: WE'RE MISSING THE JUNCTION SUBSEQUENCES *)
	allSubs=Flatten[{Values[motifMap]}];

	(* See if any of these subs fold *)
	FoldsQ[allSubs,ops]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with structures --- *)
FoldsQ[cplexs:{StructureP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
{strands},

	(* Extract the strands from every Structure *)
	strands=Flatten[cplexs[Strands]];

	(* Now run subsequences on the list of strands *)
	FoldsQ[strands,k,ops]

]/;OptionValue[FastTrack]


(* --- Core Function --- *)
FoldsQ[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldsQ[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[FoldsQ,SequenceQ,ops]]
FoldsQ[sequence:SequenceP,k:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=FoldsQ[sequence,k,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[FoldsQ,SequenceQ,ops]]
FoldsQ[subseqs:{SequenceP..},ops:OptionsPattern[]]:=FoldsQ[subseqs,FastTrack->True,ops]/;SequenceQ[subseqs,Map->False,PassOptions[FoldsQ,SequenceQ,ops]]
FoldsQ[subseqs:{SequenceP..},testSeq:SequenceP,ops:OptionsPattern[]]:=FoldsQ[subseqs,testSeq,FastTrack->True,ops]/;SequenceQ[subseqs,Map->False,PassOptions[FoldsQ,SequenceQ,ops]]&&SequenceQ[testSeq,PassOptions[FoldsQ,SequenceQ,ops]]
FoldsQ[strs:{StrandP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldsQ[strs,k,FastTrack->True,ops]/;And@@StrandQ[strs,PassOptions[FoldsQ,StrandQ,ops]]
FoldsQ[cplexs:{StructureP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldsQ[cplexs,k,FastTrack->True,ops]/;And@@StructureQ[cplexs,PassOptions[FoldsQ,StructureQ,ops]]

(* --- Reverse Listable --- *)
FoldsQ[str:StrandP,k:(GreaterP[0,1]|{GreaterP[0,1]..}),ops:OptionsPattern[]]:=FoldsQ[{str},k,ops]
FoldsQ[str:{StrandP..}|StrandP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=FoldsQ[str,#,ops]&/@ks
FoldsQ[cmplx:StructureP,k:(GreaterP[0,1]|{GreaterP[0,1]..}),ops:OptionsPattern[]]:=FoldsQ[{cmplx},k,ops]
FoldsQ[cmplx:{StructureP..}|StructureP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=FoldsQ[cmplx,#,ops]&/@ks

(* --- Listable --- *)
FoldsQ[sequences:{SequenceP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=FoldsQ[#,k,ops]&/@sequences
FoldsQ[sequence:SequenceP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=FoldsQ[sequence,#,ops]&/@ks
FoldsQ[sequences:{SequenceP..},ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=MapThread[FoldsQ[#1,#2,ops]&,{sequences,ks}]/;SameLengthQ[sequences,ks]
FoldsQ[sequences:{SequenceP..},k:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=FoldsQ[#,k,range,ops]&/@sequences
FoldsQ[sequence:SequenceP,ks:{GreaterP[0,1]..},range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=FoldsQ[sequence,#,range,ops]&/@ks
FoldsQ[sequence:SequenceP,k:GreaterP[0,1],ranges:{Span[GreaterP[0,1],GreaterP[0,1]]..},ops:OptionsPattern[]]:=FoldsQ[sequence,k,#,ops]&/@ranges
FoldsQ[sequences:{SequenceP..},ks:{GreaterP[0,1]..},ranges:{Span[GreaterP[0,1],GreaterP[0,1]]..},ops:OptionsPattern[]]:=MapThread[FoldsQ[#1,#2,#3,ops]&,{sequences,ks,ranges}]/;SameLengthQ[sequences,ks,ranges]
FoldsQ[subseqs:{{SequenceP..}..},ops:OptionsPattern[]]:=FoldsQ[#,ops]&/@subseqs

FoldsQ[subseqs:{{SequenceP..}..},testSeqs:SequenceP,ops:OptionsPattern[]]:=FoldsQ[#,testSeqs,ops]&/@subseqs
FoldsQ[subseqs:{SequenceP..},testSeqs:{SequenceP..},ops:OptionsPattern[]]:=FoldsQ[subseqs,#,ops]&/@testSeqs
FoldsQ[subseqs:{{SequenceP..}..},testSeqs:{SequenceP..},ops:OptionsPattern[]]:=MapThread[FoldsQ[#1,#2,ops]&,{subseqs,testSeqs}]/;SameLengthQ[subseqs,testSeqs]


(* ::Subsubsection:: *)
(*RepeatingMatrix*)


DefineOptions[RepeatingMatrix,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, True | False, "If set to true, will count any degenerate posibilties that could match as valid (eg. DNA[\"N\"] will count against anything)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Versions --- *)
RepeatingMatrix[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
	{type,subs},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[RepeatingMatrix,PolymerType,ops]];

	(* Determine the explicitly typed subsequences of the sequence *)
	subs=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[RepeatingMatrix,EmeraldSubsequences,ops]];

	(* Generate a matrix of the subsequences vs. themselves, 1 where the subsequences could bind and 0 where they don't *)
	Table[
		If[MatchQ[subs[[x]],subs[[y]]],1,0],
		{x,Length[subs]},
		{y,Length[subs]}
	]

]/;OptionValue[FastTrack]

(* --- Spans --- *)
RepeatingMatrix[sequence:SequenceP,k:GreaterP[0,1],Span[minIndex:GreaterP[0,1],maxIndex:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,probeSubSequences,targetSubSequences},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[RepeatingMatrix,PolymerType,ops]];

	(* Determine the explicitly typed subsequences of the entire sequence *)
	targetSubSequences=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[RepeatingMatrix,EmeraldSubsequences,ops]];

	(* Determine the explicitly typed subsequences of the only in the spesified span *)
	probeSubSequences=Take[targetSubSequences,Span[Max[minIndex-(k-1),1],maxIndex]];

	(* Generate a matrix of the probe subsequences vs. the target subsequences, 1 where the subsequences could bind and 0 where they don't *)
	Table[
		If[MatchQ[probeSubSequences[[x]],targetSubSequences[[y]]],1,0],
		{x,Length[probeSubSequences]},
		{y,Length[targetSubSequences]}
	]

]/;OptionValue[FastTrack]


(* --- Core Functions --- *)
RepeatingMatrix[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatingMatrix[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[RepeatingMatrix,SequenceQ,ops]]
RepeatingMatrix[sequence:SequenceP,k:GreaterP[0,1],range:Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length},

	(* extract the type of the sequence *)
	type=PolymerType[sequence,PassOptions[RepeatingMatrix,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[RepeatingMatrix,SequenceLength,ops]];

	(* Be sure to buffer the span values to make sure they are in the valid range *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call folding sequence in the apprate range(s) *)
			RepeatingMatrix[sequence,k,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

];

SetAttributes[RepeatingMatrix,Listable];


(* ::Subsubsection::Closed:: *)
(*RepeatingSequences*)


DefineOptions[RepeatingSequences,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, True | False, "If set to true, will count any degenerate posibilties that could match as valid (eg. DNA[\"N \"] will count against anything)."},
		{MinLevel -> 1, _Integer, "If no length 'k' is provided returns only the subsequence of length MinLevel or higher."},
		{Consolidate -> True, True | False, "If no length 'k' is provided counts only the largest occurance of a subsequence (e.g. if a repeating subsequence of length 6 exists, and consolidate is true, does not return the composite 5,4,3,2,1-mer repeats that exist entirely within the 6mer repeat)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Versions --- *)
RepeatingSequences[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
{type,fragments,rcFragments,repeatedReps,reps},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* Break the sequence into all relivent subsequences at level k *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[RepeatingSequences,EmeraldSubsequences,ops]];

	(* pan though the sequences, for each time a sequence is found more than once, include the sequence that many times*)
	repeatedReps=Flatten[Table[#,{Count[fragments,#]-1}]&/@fragments];

	(* Since each sequence is reapated n number of times (for each redundent match found), flatten out the list *)
	reps=Flatten[repeatedReps];

	(* explicitly type the output as requested *)
	ExplicitlyType[sequence,reps,PassOptions[RepeatingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

RepeatingSequences[sequence:SequenceP,k:GreaterP[0,1],Span[min:GreaterP[0,1],max:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
{type,fragments,rcFragments,length,probeFragments,repeatedReps,reps},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* determine the lenght of the sequence *)
	length=SequenceLength[sequence,Polymer->type,PassOptions[RepeatingSequences,SequenceLength,ops]];

	(* Break the sequence into all relivent subsequences at level k *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,PassOptions[RepeatingSequences,EmeraldSubsequences,ops]];

	(* Grabe the relevent subsequence fragments from the provided range *)
	probeFragments=Take[fragments,Span[Max[min-(k-1),1],Min[max,length-(k-1)]]];

	(* pan though the sequences, for each time a sequence's is found more than once, include the sequence that many times*)
	repeatedReps=Flatten[Table[#,{Count[fragments,#]-1}]&/@probeFragments];

	(* Since each sequence is reapated n number of times (for each redundent match found), flatten out the list *)
	reps=Flatten[repeatedReps];

	(* explicitly type the output as requested *)
	ExplicitlyType[sequence,reps,PassOptions[RepeatingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- Repeating at every level --- *)
RepeatingSequences[sequence:SequenceP,ops:OptionsPattern[]]:=Module[{type,length,folds},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,PassOptions[RepeatingSequences,SequenceLength,ops]];

	(* now return the repeating sequences from the full span *)
	RepeatingSequences[sequence,Span[1,length],Polymer->type,ops]

]/;OptionValue[FastTrack]

RepeatingSequences[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=Module[{type,untyped,recursiveReps,reps,consolidated},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* String any type information from the sequence *)
	untyped=UnTypeSequence[sequence];

	(* recursively determine the repeats with k going from the minlevel upwards until no further folds are found *)
	recursiveReps=recursiveRepeating[untyped,OptionValue[MinLevel],range,{},Polymer->type,PassOptions[RepeatingSequences,recursiveRepeating,ops]];
	(* this works becuase you can not have a repeat at level k without having repeats at all levels less than k *)

	(* If consolidate is on, remove all redundent subsequence fragments leaving only the largest for each repeat *)
	reps=If[OptionValue[Consolidate],
		consolidateSequence[recursiveReps,type],
		Flatten[recursiveReps]
	];

	(* now return the repeating sequence typed as requested *)
	ExplicitlyType[sequence,reps,PassOptions[RepeatingSequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- Core Function --- *)
RepeatingSequences[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatingSequences[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[RepeatingSequences,SequenceQ,ops]]
RepeatingSequences[sequence:SequenceP,k:GreaterP[0,1],Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length,min,max},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[RepeatingSequences,SequenceLength,ops]];

	(* Buffer the selection range to whats allowed *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call repeating sequence in the apprate range(s) *)
			RepeatingSequences[sequence,k,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

]/;SequenceQ[sequence,PassOptions[RepeatingSequences,SequenceQ,ops]]

RepeatingSequences[sequence:SequenceP,ops:OptionsPattern[]]:=RepeatingSequences[sequence,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[RepeatingSequences,SequenceQ,ops]]
RepeatingSequences[sequence:SequenceP,Span[m:GreaterP[0,1],n:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,length,min,max},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[RepeatingSequences,PolymerType,ops]];

	(* Determine the length of the sequence *)
	length=SequenceLength[sequence,Polymer->type,FastTrack->True,PassOptions[RepeatingSequences,SequenceLength,ops]];

	(* Buffer the selection range to whats allowed *)
	If[n>=m&&m<=length,
		Module[{maxPos,minPos},

			(* Determine the maximum possible end point *)
			maxPos=If[n>0,
				Min[n,length],
				-Min[Abs[n],length]
			];

			(* Determine the maximum possible start point *)
			minPos=If[m>0,
				Min[m,maxPos],
				-Min[Abs[m],length]
			];

			(* Call repeating sequence in the apprate range(s) *)
			RepeatingSequences[sequence,Span[minPos,maxPos],Polymer->type,FastTrack->True,ops]
		],
		{}
	]

]/;SequenceQ[sequence,PassOptions[RepeatingSequences,SequenceQ,ops]]

SetAttributes[RepeatingSequences,Listable];


(* --- Recursive folding helper function --- *)
(* Calculates the folding sequence starting at the bottom level and increasing recursively to stop only when no more folds are found *)
Options[recursiveRepeating]={
	Polymer->Automatic,
	MinLevel->1,
	FastTrack->False
};
recursiveRepeating[sequence_,level:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],folds_List,ops:OptionsPattern[]]:=Module[{levelFolds},

	(* Obtain all the repeats at level n *)
	levelFolds=RepeatingSequences[sequence,level,range,PassOptions[recursiveRepeating,RepeatingSequences,ops]];

	(* if there are no repeats at this level, or we've reach the maximum size, just return the accumlated resuls
	Otherwise continue to the next level upwards *)
	If[Length[levelFolds]>0&&level<=StringLength[sequence],
		recursiveRepeating[sequence,level+1,range,Prepend[folds,levelFolds],ops],
		folds
	]
];


(* ::Subsubsection:: *)
(*NumberOfRepeats*)


DefineOptions[NumberOfRepeats,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{MinLevel -> 1, _Integer, "If no length 'k' is provided returns only the subsequence of length MinLevel or higher."},
		{Consolidate -> True, True | False, "If no length 'k' is provided counts only the largest occurance of a subsequence (e.g. if a repeating subsequence of length 6 exists, and consolidate is true, does not return the composite 5,4,3,2,1-mer repeats that exist entirely within the 6mer repeat)."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Version ---- *)
NumberOfRepeats[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Length[RepeatingSequences[sequence,k,PassOptions[NumberOfRepeats,RepeatingSequences,ops]]]/;OptionValue[FastTrack]
NumberOfRepeats[sequence:SequenceP,k:GreaterP[0,1],range:Span[_Integer,_Integer],ops:OptionsPattern[]]:=Length[RepeatingSequences[sequence,k,range,PassOptions[NumberOfRepeats,RepeatingSequences,ops]]]/;OptionValue[FastTrack]
NumberOfRepeats[sequence:SequenceP,ops:OptionsPattern[]]:=Module[
	{type,folds,grouped},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[NumberOfFolds,PolymerType]];

	(* calculate the folding *)
	folds=Reverse@RepeatingSequences[sequence,Polymer->type,PassOptions[NumberOfRepeats,RepeatingSequences,ops]];

	(* Group the folds by their length *)
	grouped=GatherBy[folds,SequenceLength[#,Polymer->type,PassOptions[NumberOfRepeats,SequenceLength,ops]]&];

	(* Determine the number of folds at each length level *)
	Length/@grouped

]/;OptionValue[FastTrack]

NumberOfRepeats[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,folds,grouped},

	(* Determine the polymer type *)
	type=PolymerType[sequence,PassOptions[NumberOfFolds,PolymerType]];

	(* calculate the folding *)
	folds=Reverse@RepeatingSequences[sequence,range,Polymer->type,PassOptions[NumberOfRepeats,RepeatingSequences,ops]];

	(* Group the folds by their length *)
	grouped=GatherBy[folds,SequenceLength[#,Polymer->type,PassOptions[NumberOfRepeats,SequenceLength,ops]]&];

	(* Determine the number of folds at each length level *)
	Length/@grouped

]/;OptionValue[FastTrack]


(*--- Core Function --- *)
NumberOfRepeats[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=NumberOfRepeats[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfRepeats,SequenceQ,ops]]
NumberOfRepeats[sequence:SequenceP,k:GreaterP[0,1],range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=NumberOfRepeats[sequence,k,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfRepeats,SequenceQ,ops]]
NumberOfRepeats[sequence:SequenceP,ops:OptionsPattern[]]:=NumberOfRepeats[sequence,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfRepeats,SequenceQ,ops]]
NumberOfRepeats[sequence:SequenceP,range:Span[GreaterP[0,1],GreaterP[0,1]],ops:OptionsPattern[]]:=NumberOfRepeats[sequence,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[NumberOfRepeats,SequenceQ,ops]]

SetAttributes[NumberOfRepeats,Listable];


(* ::Subsubsection::Closed:: *)
(*RepeatsQ*)


DefineOptions[RepeatsQ,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{CanonicalPairing -> True, True | False, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Version: sequences --- *)
RepeatsQ[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
	{type,fragments,foldingIndex},

	(* determine the type *)
	type=PolymerType[sequence,PassOptions[RepeatsQ,PolymerType,ops]];

	(* Break the sequence into its composit fragments *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* See if any of the fragments appear more than once *)
	foldingIndex=Count[fragments,#]>1&/@fragments;

	(* Return true if any of the foliding guys are included *)
	Or@@foldingIndex

]/;OptionValue[FastTrack]


(* --- FastTrack Version: sequence ranges --- *)
RepeatsQ[sequence:SequenceP,k:GreaterP[0,1],range:Span[min:GreaterP[0,1],max:GreaterP[0,1]],ops:OptionsPattern[]]:=Module[
	{type,fragments,subsequenceFragments,foldingIndex},

	(* determine the type *)
	type=PolymerType[sequence,PassOptions[RepeatsQ,PolymerType,ops]];

	(* Break the sequence into its composit fragments *)
	fragments=EmeraldSubsequences[sequence,k,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* Grabe the relevent subsequence fragments from the provided range *)
	subsequenceFragments=Take[fragments,Span[Max[min-k,1],max]];

	(* See if any of the fragments have a ReverseComplementSequence member of the group *)
	foldingIndex=Count[fragments,#]>1&/@subsequenceFragments;

	(* Return true if any of the foliding guys are included *)
	Or@@foldingIndex

]/;OptionValue[FastTrack]


(* --- FastTrack Version: subsequences --- *)
RepeatsQ[subsequences:{SequenceP..},ops:OptionsPattern[]]:=Module[{untyped,counts},

	(* Strip the type of the subsequences *)
	untyped=UnTypeSequence[subsequences];

	(* Determine if any untyped sequences show up more than once *)
	counts=Count[untyped,#]>1&/@untyped;

	(* Return true if any of the untyped sequences showed up more than once *)
	Or@@counts

]/;OptionValue[FastTrack]


(* --- FastTrack Version: subsequence test--- *)
RepeatsQ[subsequences:{SequenceP..},testSequence:SequenceP,ops:OptionsPattern[]]:=Module[{untyped,untypedTest},

	(* Strip the type of the subsequences *)
	untyped=UnTypeSequence[subsequences];

	(* strip the type of teh test sequences *)
	untypedTest=UnTypeSequence[testSequence];

	(* Return true if the test sequences shows up *)
	MemberQ[untyped,untypedTest]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with strands --- *)
RepeatsQ[rawStrands:{StrandP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
	{motifMap,juncs,junctionSubs,strands,allSubs},

	(* Before we get started, name all of the motifs *)
	strands=NameMotifs[rawStrands];

	(* Pull up the motif map *)
	motifMap=EmeraldSubsequences[strands,k,PassOptions[FoldsQ,EmeraldSubsequences,ops]];

	(* Determine the junction subsequences *)
	junctionSubs=junctionSubsequences[strands,k,FastTrack->True,ExplicitlyTyped->False];

	(* Gather togeather ALL OF THE SUBSEQUENCES: WE'RE MISSING THE JUNCTION SUBSEQUENCES !?!?! *)
	allSubs=Flatten[{Values[motifMap]}];

	(* See if any of these subs fold *)
	RepeatsQ[allSubs,ops]

]/;OptionValue[FastTrack]


(* --- FastTrack Version with structures --- *)
RepeatsQ[cplexs:{StructureP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=Module[
{strands},

	(* Extract the strands from every Structure *)
	strands=Flatten[cplexs[Strands]];

	(* Now run subsequences on the list of strands *)
	RepeatsQ[strands,k,ops]

]/;OptionValue[FastTrack]


(* --- Core Function --- *)
RepeatsQ[sequence:SequenceP,k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatsQ[sequence,k,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[RepeatsQ,SequenceQ,ops]]
RepeatsQ[sequence:SequenceP,k:GreaterP[0,1],range:Span[min_Integer,max_Integer],ops:OptionsPattern[]]:=RepeatsQ[sequence,k,range,FastTrack->True,ops]/;SequenceQ[sequence,PassOptions[RepeatsQ,SequenceQ,ops]]
RepeatsQ[subsequences:{SequenceP..},ops:OptionsPattern[]]:=RepeatsQ[subsequences,FastTrack->True,ops]/;SequenceQ[subsequences,Map->False,PassOptions[RepeatsQ,SequenceQ,ops]]
RepeatsQ[subsequences:{SequenceP..},testSequence:SequenceP,ops:OptionsPattern[]]:=RepeatsQ[subsequences,testSequence,FastTrack->True,ops]/;SequenceQ[subsequences,Map->False,PassOptions[RepeatsQ,SequenceQ,ops]]&&SequenceQ[testSequence,PassOptions[RepeatsQ,SequenceQ,ops]]
RepeatsQ[strs:{StrandP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatsQ[strs,k,FastTrack->True,ops]/;And@@StrandQ[strs,PassOptions[RepeatsQ,StrandQ,ops]]
RepeatsQ[cplexs:{StructureP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatsQ[cplexs,k,FastTrack->True,ops]/;And@@StructureQ[cplexs,PassOptions[RepeatsQ,StructureQ,ops]]

(* --- Reverse Listable --- *)
RepeatsQ[str:StrandP,k:(GreaterP[0,1]|{GreaterP[0,1]..}),ops:OptionsPattern[]]:=RepeatsQ[{str},k,ops]
RepeatsQ[str:{StrandP..}|StrandP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=RepeatsQ[str,#,ops]&/@ks
RepeatsQ[cmplx:StructureP,k:(GreaterP[0,1]|{GreaterP[0,1]..}),ops:OptionsPattern[]]:=RepeatsQ[{cmplx},k,ops]
RepeatsQ[cmplx:{StructureP..}|StructureP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=RepeatsQ[cmplx,#,ops]&/@ks

(* --- Listable --- *)
RepeatsQ[sequences:{SequenceP..},k:GreaterP[0,1],ops:OptionsPattern[]]:=RepeatsQ[#,k,ops]&/@sequences
RepeatsQ[sequence:SequenceP,ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=RepeatsQ[sequence,#,ops]&/@ks
RepeatsQ[sequences:{SequenceP..},ks:{GreaterP[0,1]..},ops:OptionsPattern[]]:=MapThread[RepeatsQ[#1,#2,ops]&,{sequences,ks}]/;SameLengthQ[sequences,ks]
RepeatsQ[sequences:{SequenceP..},k:GreaterP[0,1],range:Span[_Integer,_Integer],ops:OptionsPattern[]]:=RepeatsQ[#,k,range]&/@sequences
RepeatsQ[sequence:SequenceP,ks:{GreaterP[0,1]..},range:Span[_Integer,_Integer],ops:OptionsPattern[]]:=RepeatsQ[sequence,#,range]&/@ks
RepeatsQ[sequence:SequenceP,k:GreaterP[0,1],ranges:{Span[_Integer,_Integer]..},ops:OptionsPattern[]]:=RepeatsQ[sequence,k,#]&/@ranges
RepeatsQ[sequences:{SequenceP..},ks:{GreaterP[0,1]..},ranges:{Span[_Integer,_Integer]..},ops:OptionsPattern[]]:=MapThread[RepeatsQ[#1,#2,#3,ops]&,{sequences,ks,ranges}]/;SameLengthQ[sequences,ks,ranges]

RepeatsQ[subsequences:{{SequenceP..}..},ops:OptionsPattern[]]:=RepeatsQ[#,ops]&/@subsequences
RepeatsQ[subsequences:{{SequenceP..}..},testSequence:SequenceP,ops:OptionsPattern[]]:=RepeatsQ[#,testSequence,ops]&/@subsequences
RepeatsQ[subsequences:{SequenceP..},testSequences:{SequenceP..},ops:OptionsPattern[]]:=RepeatsQ[subsequences,#,ops]&/@testSequences
RepeatsQ[subsequences:{{SequenceP..}..},testSequences:{SequenceP..},ops:OptionsPattern[]]:=MapThread[RepeatsQ[#1,#2,ops]&,{subsequences,testSequences}]/;SameLengthQ[subsequences,testSequences]


(* ::Subsection:: *)
(*subsequences*)


(* ::Subsubsection::Closed:: *)
(*removeOnce*)


DefineUsage[removeOnce,
{
	BasicDefinitions -> {
		{"removeOnce[list_List,item_]", "removed_List", "Returns the list with the only the first occurance of item removed.  If item is not in the list, returns the list unaltered."}
	},
	Input :> {
		{"'list'", _, "the base list you wish to remove the item from"},
		{"'item'", _, "the item you wish to remove from the list"}
	},
	Output :> {
		{"'removed'", _, "the list with the first occurance of item removed."}
	},
	SeeAlso -> {
		"removeList"
	},
	Author -> {
		"Frezza"
	}
}];

Authors[removeOnce]:={"scicomp", "brad"};
removeOnce[list_List,item_]:=Module[{pos},

	(* Find all the positiosn of the item in the list *)
	pos=Position[list,item];

	(* If its at any position, delete only the first occurance *)
	If[Length[pos]>0,
		Delete[list,First[pos]],
		list
	]
]


(* ::Subsubsection::Closed:: *)
(*removeList*)


removeList[source_List,remove_List]:=Block[{$RecursionLimit=\[Infinity],$IterationLimit=\[Infinity]},RemoveListHelper[source,remove]]

RemoveListHelper[source_List,{}]:=source
RemoveListHelper[source_List,remove_List]:=Module[{locations},
	RemoveListHelper[removeOnce[source,First[remove]],Rest[remove]]
]


(* ::Subsubsection:: *)
(*EmeraldSubsequences*)


DefineOptions[EmeraldSubsequences,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A \"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{MinLevel -> 1, _Integer, "The minimum level of subsequences to consider when deconstructing."},
		{Complete -> False, True | False, "When processing structures, if set to falase, will returnly only a minimal set of unique subsequences present in the Structure, if set to true returns the unique set in addition to all of the reverse compliment subsequences."},
		{CanonicalPairing -> False, BooleanP, "If set to true, all polymer types are converted to DNA."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


emeraldSubseqCore[seqs_List, l_Integer, u_Integer, range_Span]:= Module[
	{chopped, subseqs},

	(* take parts based on given range *)
	chopped = Check[Take[seqs, range], $Failed];
	If[MatchQ[chopped, $Failed], Return[$Failed]];

	(* generate subsequences *)
	subseqs = Subsequences[chopped, {l, u}];

	(* join the seqs *)
	NucleicAcids`Private`sequenceJoinCore/@subseqs

];

emeraldSubseqCore[seqs_List, l_Integer, u_Integer]:= Module[
	{subseqs},

	(* generate subsequences *)
	subseqs = Subsequences[seqs, {l, u}];

	(* join the seqs *)
	NucleicAcids`Private`sequenceJoinCore/@subseqs

];

emeraldSubseqCore[$Failed, ___]:= $Failed;


EmeraldSubsequences[seqs:{SequenceP..}, k:GreaterP[0,1], range_Span, ops:OptionsPattern[]]:= Module[
	{safeOps, monos, tmpRes},

	safeOps = SafeOptions[EmeraldSubsequences, ToList[ops]];

	(* obtain the monomers *)
	monos = Monomers[seqs, PassOptions[EmeraldSubsequences, Monomers, safeOps]];

	tmpRes = emeraldSubseqCore[#, k, k, range]&/@monos;

	If[CanonicalPairing/.safeOps,
		ToDNA/@tmpRes,
		tmpRes
	]

];


EmeraldSubsequences[seq:SequenceP, k:GreaterP[0,1], range_Span, ops:OptionsPattern[]]:= First[EmeraldSubsequences[{seq}, k, range, ops]];


EmeraldSubsequences[seqs:{SequenceP..}, k:GreaterP[0,1], ops:OptionsPattern[]]:= Module[
	{safeOps, monos, tmpRes},

	safeOps = SafeOptions[EmeraldSubsequences, ToList[ops]];

	(* obtain the monomers *)
	monos = Monomers[seqs, PassOptions[EmeraldSubsequences, Monomers, safeOps]];

	tmpRes = emeraldSubseqCore[#, k, k]&/@monos;

	If[CanonicalPairing/.safeOps,
		ToDNA/@tmpRes,
		tmpRes
	]

];


EmeraldSubsequences[seq:SequenceP, k:GreaterP[0,1], ops:OptionsPattern[]]:= First[EmeraldSubsequences[{seq}, k, ops]];


EmeraldSubsequences[seqs:{SequenceP..}, range_Span, ops:OptionsPattern[]]:= Module[
	{safeOps, monos, tmpRes},

	safeOps = SafeOptions[EmeraldSubsequences, ToList[ops]];

	(* obtain the monomers *)
	monos = Monomers[seqs, PassOptions[EmeraldSubsequences, Monomers, safeOps]];

	tmpRes = emeraldSubseqCore[#, MinLevel/.safeOps, Length[#], range]&/@monos;

	If[CanonicalPairing/.safeOps,
		ToDNA/@tmpRes,
		tmpRes
	]

];


EmeraldSubsequences[seq:SequenceP, range_Span, ops:OptionsPattern[]]:= First[EmeraldSubsequences[{seq}, range, ops]];


EmeraldSubsequences[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, monos, tmpRes},

	safeOps = SafeOptions[EmeraldSubsequences, ToList[ops]];

	(* obtain the monomers *)
	monos = Monomers[seqs, PassOptions[EmeraldSubsequences, Monomers, safeOps]];

	tmpRes = emeraldSubseqCore[#, MinLevel/.safeOps, Length[#]]&/@monos;

	If[CanonicalPairing/.safeOps,
		ToDNA/@tmpRes,
		tmpRes
	]

];


EmeraldSubsequences[seq:SequenceP, ops:OptionsPattern[]]:= First[EmeraldSubsequences[{seq}, ops]];


EmeraldSubsequences[strds:{StrandP..}, k:GreaterP[0,1], ops:OptionsPattern[]]:= Module[
	{safeOps, seqs, uniqueSeqs, uniqueKmers},

	safeOps = SafeOptions[EmeraldSubsequences, ToList[ops]];

	(* get all motifs *)
	seqs = Flatten[strds[Motifs]];

	(* remove any duplicates or ReverseSequence comps as we'll replace them back in later *)
	uniqueSeqs = Gather[seqs, StringMatchQ[StringTrim[Last[#1],"'"], StringTrim[Last[#2],"'"]]&][[;;,1]];

	(* break into unique kmers of the provided length k *)
	uniqueKmers = Thread[Last/@uniqueSeqs -> EmeraldSubsequences[uniqueSeqs, k, ops]];

	(* If complete is on, return the map of all possible motifs (rev comp incldued), if its off return only the unique subsets *)
	If[Complete/.safeOps,
		revCompMotifMap[uniqueKmers],
		uniqueKmers
	]

];


EmeraldSubsequences[strd:StrandP, k:GreaterP[0,1], ops:OptionsPattern[]]:= EmeraldSubsequences[{strd}, k, ops];


EmeraldSubsequences[structs:{StructureP..}, k:GreaterP[0,1], ops:OptionsPattern[]]:=Module[
	{strands},

	(* Extract the strands from every Structure *)
	strands = Flatten[structs[[All,1]]];

	(* Now run subsequences on the list of strands *)
	EmeraldSubsequences[strands, k, ops]

];


EmeraldSubsequences[struct:StructureP, k:GreaterP[0,1], ops:OptionsPattern[]]:= EmeraldSubsequences[{struct}, k, ops];


EmeraldSubsequences["", ___]:= {};
EmeraldSubsequences[{}, ___]:= {};


(* ::Subsubsection::Closed:: *)
(*junctions*)


DefineOptions[junctions,
	Options :> {
		{FastTrack -> False,_,""}
	}];


(* --- FastTrack version: Strands --- *)
junctions[strands:{StrandP..},ops:OptionsPattern[junctions]]:=Module[{neighbors},

	(* Break the strands into nearest neighors *)
	neighbors=Flatten[Partition[List@@#,2,1]&/@strands,1];

	(* Pull out only the motif names *)
	neighbors[[All,All,2]]

]/;OptionValue[FastTrack]

(* --- FastTrack version: Structures --- *)
junctions[cplex:{StructureP..},ops:OptionsPattern[junctions]]:=Module[{strands},

	(* Extract the strands from the structures *)
	strands=Flatten[cplex[[All,1]]];

	(* Now call junctions on the list of strands extracted *)
	junctions[strands,ops]

]/;OptionValue[FastTrack]

(* --- Core Functions --- *)
junctions[cplexs:{StructureP..},ops:OptionsPattern[junctions]]:=junctions[cplexs,FastTrack->True,ops]/;And@@StructureQ[cplexs,CheckMotifs->True,CheckPairs->True,PassOptions[junctions,StructureQ,ops]]
junctions[strands:{StrandP..},ops:OptionsPattern[junctions]]:=junctions[strands,FastTrack->True,ops]/;And@@StrandQ[strands,CheckMotifs->True,PassOptions[junctions,StrandQ,ops]]

(* --- Reverse listable ---- *)
junctions[str:StrandP,ops:OptionsPattern[junctions]]:=junctions[{str},ops]
junctions[cplx:StructureP,ops:OptionsPattern[junctions]]:=junctions[{cplx},ops]


(* ::Subsubsection::Closed:: *)
(*buildSequence*)


DefineOptions[buildSequence,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False,_,""}
	}];


buildSequence::NonOverlapping="The provided subsequences do not overlap.";


(* --- FastTrack Version --- *)
buildSequence[subsequences:{SequenceP..},ops:OptionsPattern[buildSequence]]:=Module[
{type,firstMonomers,lastSubsequence,finalsequence},

	(* Determine the type by taking all sequences into acount *)
	type=PolymerType[subsequences,Map->False,PassOptions[buildSequence,PolymerType,ops]];

	(* Extract all the first Monomers in all but the last subsequence *)
	firstMonomers=SequenceFirst[Most[subsequences],Polymer->type,ExplicitlyTyped->False,PassOptions[buildSequence,SequenceFirst,ops]];

	(* Extrat the last subsequence sans type*)
	lastSubsequence=UnTypeSequence[Last[subsequences]];

	(* combine all Monomers with the last subsequence *)
	finalsequence=StringJoin[firstMonomers,lastSubsequence];

	(* Explicitly type as requesated *)
	ExplicitlyType[First[subsequences],finalsequence,PassOptions[buildSequence,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

(* --- Core Function --- *)
buildSequence[subsequences:{SequenceP..},ops:OptionsPattern[buildSequence]]:=Module[{},
	If[!subsequencesQ[subsequences,PassOptions[buildSequence,subsequencesQ,ops]],
		Message[buildSequence::NonOverlapping];
		Return[Null]
	];
	buildSequence[subsequences,FastTrack->True,ops]/;SequenceQ[subsequences,Map->False,PassOptions[buildSequence,SequenceQ,ops]]
]

(* --- Listable --- *)
buildSequence[subsequences:{{_?SequenceQ..}..},ops:OptionsPattern[buildSequence]]:=buildSequence[#,ops]&/@subsequences


(* ::Subsubsection::Closed:: *)
(*subsequencesQ*)


DefineUsage[subsequencesQ,
{
	BasicDefinitions -> {
		{"subsequencesQ[sequences:{_?SequenceQ..}]", "isConstructible:BooleanP", "Returns true if the provided sequences are overlapping by an offset of one and are of the same polymer type and thus sequence will work on them."}
	},
	Input :> {
		{"sequences", _, "the list of sequences you wish to test for constructibility"}
	},
	Output :> {
		{"isConstructible", _, "True if the list of sequences can be combined through construction"}
	},
	SeeAlso -> {
		"buildSequence",
		"EmeraldSubsequences"
	},
	Author -> {
		"Frezza"
	}
}];


DefineOptions[subsequencesQ,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, True | False, "If set to true, degenerate Monomers are considered valid and will attempt to be included."},
		{Assembled -> True,_,""},
		{FastTrack -> False,_,""}
	}];


(*--- FastTrack Versions--- *)

(* --- subsequences need not be assmbled --- *)
subsequencesQ[subSequences:{SequenceP..},ops:OptionsPattern[subsequencesQ]]:=Module[
{type,lengths},

	(* Extract the type of the subsequences *)
	type=PolymerType[subSequences,Map->False,PassOptions[subsequencesQ,PolymerType,ops]];

	(* Determine the lenght of all the subsequences *)
	lengths=SequenceLength[subSequences,Polymer->type,PassOptions[subsequencesQ,SequenceLength,ops]];

	(* Return true if all lengths are the same number *)
	MatchQ[lengths,{x_Integer..}]

]/;OptionValue[FastTrack]&&!OptionValue[Assembled]

(* --- subsequences should be assembled such that sequence can be run on them --- *)
subsequencesQ[subSequences:{SequenceP..},ops:OptionsPattern[subsequencesQ]]:=Module[
{type,rests,mosts},

	(* Extract the type of the subsequences *)
	type=PolymerType[subSequences,Map->False,PassOptions[subsequencesQ,PolymerType,ops]];

	(* Grab all but the last monomer of each sequence *)
	rests=SequenceRest[subSequences,Polymer->type,ExplicitlyTyped->False,PassOptions[subsequencesQ,SequenceRest,ops]];

	(* grab all but the first monomer of each sequence *)
	mosts=SequenceMost[subSequences,Polymer->type,ExplicitlyTyped->False,PassOptions[subsequencesQ,SequenceMost,ops]];

	(* See if the sequences are all of the same polymer annd if all but the last mosts matches all but the first rests *)
	MatchQ[Most[rests],Rest[mosts]]

]/;OptionValue[FastTrack]&&OptionValue[Assembled]

(* --- Core Function --- *)
subsequencesQ[subSequences:{SequenceP..},ops:OptionsPattern[subsequencesQ]]:=subsequencesQ[subSequences,FastTrack->True,ops]/;SequenceQ[subSequences,Map->False,PassOptions[subsequencesQ,SequenceQ,ops]]
subsequencesQ[subSequences:{SequenceP..},ops:OptionsPattern[subsequencesQ]]:=False

(* --- Listable --- *)
subsequencesQ[subSequences:{{SequenceP..}..},ops:OptionsPattern[subsequencesQ]]:=subsequencesQ[#,ops]&/@subSequences


(* ::Subsubsection::Closed:: *)
(*NextSubsequences*)


DefineOptions[NextSubsequences,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types of the provided sequence."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{Exclude -> {}, {_?SequenceQ...}, "List of sequences that will not be included in the output."},
		{Degeneracy -> False, True | False, "If true, will accept subsequences that could, in any of their possible incarnations, be a match. If false, then it must be an exact match."},
		{FastTrack -> False,_,""}
	}];

(* --- Empty List Version --- *)
NextSubsequences[sequence:SequenceP,{},ops:OptionsPattern[NextSubsequences]]:={}

(* --- FastTrack Versions --- *)

(* Open Version where any subsequence not in exclude list is considered valid *)
NextSubsequences[sequence:SequenceP,ops:OptionsPattern[NextSubsequences]]:=Module[
{type,alphabet,node,candidates,next},

	(* Extract the type of the polymer *)
	type=PolymerType[sequence,PassOptions[NextSubsequences,PolymerType,ops]];

	(* Determine the next possible Monomers *)
	alphabet=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Extract the node the last sequence leads into *)
	node=SequenceRest[sequence,Polymer->type,ExplicitlyTyped->False,PassOptions[NextSubsequences,SequenceRest,ops]];

	(* Generate a list of all possible canidates *)
	candidates=node<>#&/@alphabet;

	(* Remove any of the canidates included in the exclude list *)
	next=Select[candidates,!MemberQ[OptionValue[Exclude],#]&];

	(* Explicitly type the ouput as requested *)
	ExplicitlyType[sequence,next,PassOptions[NextSubsequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

(* Closed Version: When an edge or node is provided *)
NextSubsequences[sequence:SequenceP,subsequences:{SequenceP..},ops:OptionsPattern[NextSubsequences]]:=Module[
{type,candidates,next},

	(* Extract the type of the polymer *)
	type=PolymerType[Append[subsequences,sequence],Map->False,PassOptions[NextSubsequences,PolymerType,ops]];

	(* Select canidates from the subsequence list that might come next *)
	candidates=Select[subsequences,nextSubsequencesQ[sequence,#,Polymer->type,PassOptions[NextSubsequences,nextSubsequencesQ,ops]]&];

	(* Remove any of the canidates included in the exclude list *)
	next=Select[candidates,!MemberQ[OptionValue[Exclude],#]&];

	(* Explicitly type the ouput as requested *)
	ExplicitlyType[sequence,next,PassOptions[NextSubsequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

(* --- Core Functions ---*)

(*--- Open version --- *)
NextSubsequences[sequence:SequenceP,ops:OptionsPattern[NextSubsequences]]:=NextSubsequences[sequence,FastTrack->True,ops]/;SequenceQ[sequence,Degeneracy->True,Exclude->{},PassOptions[NextSubsequences,SequenceQ,ops]]

(* --- Closed version --- *)
NextSubsequences[sequence:SequenceP,subsequences:{SequenceP..},ops:OptionsPattern[NextSubsequences]]:=NextSubsequences[sequence,subsequences,FastTrack->True,ops]/;And[subsequencesQ[subsequences,Assembled->False,Degeneracy->True,PassOptions[NextSubsequences,subsequencesQ,ops]],
	Module[{type,seedLength,subLength},

		(* Extract the type of the polymer *)
		type=PolymerType[sequence,PassOptions[NextSubsequences,PolymerType,ops]];

		(* Determine the lenght of the starting sequence *)
		seedLength=SequenceLength[sequence,Polymer->type,PassOptions[NextSubsequences,SequenceLength,ops]];

		(* Determine teh length of the subsequences *)
		subLength=SequenceLength[First[subsequences],Polymer->type,PassOptions[NextSubsequences,SequenceLength,ops]];

		(* OK to continue if either the sequence is an edge (same length) or a node (one less than length) *)
		Or[seedLength==subLength,seedLength==(subLength-1)]

	]
];

(* --- Listable --- *)
NextSubsequences[sequences:{SequenceP..},ops:OptionsPattern[NextSubsequences]]:=NextSubsequences[#,ops]&/@sequences
NextSubsequences[sequences:{SequenceP..},subsequences:{SequenceP...},ops:OptionsPattern[NextSubsequences]]:=NextSubsequences[#,subsequences,ops]&/@sequences
NextSubsequences[sequence:SequenceP,subsequences:{{SequenceP...}..},ops:OptionsPattern[NextSubsequences]]:=NextSubsequences[sequence,#,ops]&/@subsequences
NextSubsequences[sequences:{SequenceP..},subsequences:{{SequenceP...}..},ops:OptionsPattern[NextSubsequences]]:=MapThread[NextSubsequences[#1,#2,ops]&,{sequences,subsequences}]/;SameLengthQ[sequences,subsequences]


(* ::Subsubsection::Closed:: *)
(*nextSubsequencesQ*)


DefineOptions[nextSubsequencesQ,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types of the provided sequence."},
		{Degeneracy -> False, True | False, "If true, will accept subseuences that could in any of their possible incarnations, be a match. If false, then it must be an exact match."},
		{FastTrack -> False,_,""}
	}];

(* --- FastTrack Version: No degeneracy --- *)
nextSubsequencesQ[sequenceA:SequenceP,sequenceB:SequenceP,ops:OptionsPattern[nextSubsequencesQ]]:=Module[

	{typeA,typeB},

	(* Determine the type of the polymer in A *)
	typeA=PolymerType[sequenceA,PassOptions[nextSubsequencesQ,PolymerType,ops]];

	(* Determine the type of polymer in B *)
	typeB=PolymerType[sequenceB,PassOptions[nextSubsequencesQ,PolymerType,ops]];

	(* Short circuit evaluation: if the types dont match that nextSubsequencesQ should be false *)
	If[MatchQ[typeA,typeB],
		Module[{nodeA,nodeB},

			(* determine the node that sequence A feeds into *)
			nodeA=SequenceRest[sequenceA,Polymer->typeA,ExplicitlyTyped->False,FastTrack->True];

			(* determine the node that sequence B comes from *)
			nodeB=SequenceMost[sequenceB,Polymer->typeB,ExplicitlyTyped->False,FastTrack->True];

			(* see if the nodes match explicitly if degeneracy is off, or could match if degeneracy is on *)
			If[OptionValue[Degeneracy],
				Module[{useA,monoA,monoB,degenerateA,degenerateB,matching},

					(* Since we can receive either a node or a sequence as an origin point, take whichever is teh same length: the sequence or the node to compare to the landing node *)
					useA=Which[
						SequenceLength[sequenceA]==SequenceLength[nodeB],UnTypeSequence[sequenceA],
						SequenceLength[nodeA]==SequenceLength[nodeB],nodeA,
						True,{}
					];
					(* If neither length is correct, its a totaly mismatch, so return an empty list to pass foward such that it won't match *)

					(* Obtain the Monomers of sequenceA *)
					monoA=Monomers[useA,Polymer->typeA,FastTrack->True,ExplicitlyTyped->False];

					(* Obtain the Monomers of nodeB *)
					monoB=Monomers[nodeB,Polymer->typeB,FastTrack->True,ExplicitlyTyped->False];


					(* Substitute in the degeneracy rules for A *)
					degenerateA=monoA /. Physics`Private`lookupModelOligomer[typeA,DegenerateAlphabet];

					(* Substitute in the degeneracy rules for A *)
					degenerateB=monoB /. Physics`Private`lookupModelOligomer[typeB,DegenerateAlphabet];

					(* See if each monomer could match by checking the bases that intersect *)
					matching=MapThread[MatchQ[Intersection[#1,#2],{_String..}]&,{degenerateA,degenerateB}];

					(* Only if all Monomers could match could subsequenceB come after subsequenceA *)
					And@@matching

				],
				MatchQ[nodeA,nodeB]||MatchQ[UnTypeSequence[sequenceA],nodeB]
			]
		],
		False
	]

]/;OptionValue[FastTrack]

(* --- Core Functions --- *)
nextSubsequencesQ[sequenceA:SequenceP,sequenceB:SequenceP,ops:OptionsPattern[nextSubsequencesQ]]:=nextSubsequencesQ[sequenceA,sequenceB,FastTrack->True,ops]/;SequenceQ[sequenceA,Degeneracy->True,PassOptions[nextSubsequencesQ,SequenceQ,ops]]&&SequenceQ[sequenceB,Degeneracy->True,PassOptions[nextSubsequencesQ,SequenceQ,ops]]

SetAttributes[nextSubsequencesQ,Listable];


(* ::Subsubsection::Closed:: *)
(*previousSubsequences*)


DefineOptions[previousSubsequences,
	Options :> {
		{Polymer -> Automatic, (DNA | RNA | PNA | GammaLeftPNA | GammaRightPNA | Peptide | Modification) | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types of the provided sequence."},
		{ExplicitlyTyped -> Automatic, (True | False) | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{Exclude -> {}, {_?SequenceQ...}, "List of sequence that will not be included in the output."},
		{Degeneracy -> False, True | False, "If true, will accept subseuences that could in any of their possible incarnations, be a match. If false, then it must be an exact match."},
		{FastTrack -> False,_,""}
	}];


(* --- Empty List Version --- *)
previousSubsequences[sequence:SequenceP,{},ops:OptionsPattern[previousSubsequences]]:={}

(* --- FastTrack Version --- *)
(* Open version where everything not included in the exclude list is fair game *)
previousSubsequences[sequence:SequenceP,ops:OptionsPattern[previousSubsequences]]:=Module[
	{type,alphabet,node,candidates,prev},

	(* Extract the type of the polymer *)
	type=PolymerType[sequence,PassOptions[previousSubsequences,PolymerType,ops]];

	(* Determine the next possible Monomers *)
	alphabet=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Extract the node the last sequence came from *)
	node=SequenceMost[sequence,Polymer->type,ExplicitlyTyped->False,PassOptions[previousSubsequences,SequenceMost,ops]];

	(* Generate a list of all possible canidates *)
	candidates=#<>node&/@alphabet;

	(* Remove any of the canidates included in the exclude list *)
	prev=Select[candidates,!MemberQ[OptionValue[Exclude],#]&];

	(* Explicitly type the ouput as requested *)
	ExplicitlyType[sequence,prev,PassOptions[previousSubsequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

(* Closed version where the previous sequence needs to come from a supplied list *)
previousSubsequences[sequence:SequenceP,subsequences:{SequenceP..},ops:OptionsPattern[previousSubsequences]]:=Module[
	{type,candidates,prev},

	(* Extract the type of the polymer *)
	type=PolymerType[Append[subsequences,sequence],Map->False,PassOptions[previousSubsequences,PolymerType,ops]];

	(* Select out any subsequences that could be previous sequences *)
	candidates=Select[subsequences,previousSubsequencesQ[sequence,#,Polymer->type,PassOptions[previousSubsequences,previousSubsequencesQ,ops]]&];

	(* Remove any of the canidates included in the exclude list *)
	prev=Select[candidates,!MemberQ[OptionValue[Exclude],#]&];

	(* Explicitly type the ouput as requested *)
	ExplicitlyType[sequence,prev,PassOptions[previousSubsequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]

(* --- Core Functions --- *)

(* --- Open Version --- *)
previousSubsequences[sequence:SequenceP,ops:OptionsPattern[previousSubsequences]]:=previousSubsequences[sequence,FastTrack->True,ops]/;SequenceQ[sequence,Degeneracy->True,Exclude->{},PassOptions[previousSubsequences,SequenceQ,ops]]

(* --- Closed Version --- *)
previousSubsequences[sequence:SequenceP,subsequences:{SequenceP..},ops:OptionsPattern[previousSubsequences]]:=previousSubsequences[sequence,subsequences,FastTrack->True,ops]/;And[subsequencesQ[subsequences,Assembled->False,Degeneracy->True,PassOptions[previousSubsequences,subsequencesQ,ops]],
	Module[{type,seedLength,subLength},

		(* Extract the type of the polymer *)
		type=PolymerType[sequence,PassOptions[previousSubsequences,PolymerType,ops]];

		(* Determine the lenght of the starting sequence *)
		seedLength=SequenceLength[sequence,Polymer->type,PassOptions[previousSubsequences,SequenceLength,ops]];

		(* Determine teh length of the subsequences *)
		subLength=SequenceLength[First[subsequences],Polymer->type,PassOptions[previousSubsequences,SequenceLength,ops]];

		(* OK to continue if either the sequence is an edge (same length) or a node (one less than length) *)
		Or[seedLength==subLength,seedLength==(subLength-1)]

	]
]
(* --- Listable --- *)
previousSubsequences[sequences:{SequenceP..},ops:OptionsPattern[previousSubsequences]]:=previousSubsequences[#,ops]&/@sequences
previousSubsequences[sequences:{SequenceP..},subsequences:{SequenceP..},ops:OptionsPattern[previousSubsequences]]:=previousSubsequences[#,subsequences,ops]&/@sequences
previousSubsequences[sequence:SequenceP,subsequences:{{SequenceP..}..},ops:OptionsPattern[previousSubsequences]]:=previousSubsequences[sequence,#,ops]&/@subsequences
previousSubsequences[sequences:{SequenceP..},subsequences:{{SequenceP..}..},ops:OptionsPattern[previousSubsequences]]:=MapThread[previousSubsequences[#1,#2,ops]&,{sequences,subsequences}]/;SameLengthQ[sequences,subsequences]


(* ::Subsubsection::Closed:: *)
(*previousSubsequencesQ*)


DefineOptions[previousSubsequencesQ,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types of the provided sequence."},
		{Degeneracy -> False, True | False, "If true, will accept subseuences that could in any of their possible incarnations, be a match. If false, then it must be an exact match."},
		{FastTrack -> False,_,""}
	}];

(* --- FastTrack Version --- *)
previousSubsequencesQ[sequenceA:SequenceP,sequenceB:SequenceP,ops:OptionsPattern[previousSubsequencesQ]]:=Module[{typeA,typeB},

	(* Determine the type of the polymer in A *)
	typeA=PolymerType[sequenceA,PassOptions[previousSubsequencesQ,PolymerType,ops]];

	(* Determine the type of polymer in B *)
	typeB=PolymerType[sequenceB,PassOptions[previousSubsequencesQ,PolymerType,ops]];

	(* Short circuit evaluation: if the types dont match that nextSubsequencesQ should be false *)
	If[MatchQ[typeA,typeB],
		Module[{nodeA,nodeB},

			(* determine the node that sequence A feeds into *)
			nodeA=SequenceMost[sequenceA,Polymer->typeA,ExplicitlyTyped->False,FastTrack->True];

			(* determine the node that sequence B comes from *)
			nodeB=SequenceRest[sequenceB,Polymer->typeB,ExplicitlyTyped->False,FastTrack->True];

			(* see if the nodes match *)
			If[OptionValue[Degeneracy],
				Module[{useA,monoA,monoB,degenerateA,degenerateB,matching},

					(* Since we can receive either a node or a sequence as an origin point, take whichever is teh same length: the sequence or the node to compare to the landing node *)
					useA=Which[
						SequenceLength[sequenceA]==SequenceLength[nodeB],UnTypeSequence[sequenceA],
						SequenceLength[nodeA]==SequenceLength[nodeB],nodeA,
						True,{}
					];
					(* If neither length is correct, its a totaly mismatch, so return an empty list to pass foward such that it won't match *)

					(* Obtain the Monomers of sequenceA *)
					monoA=Monomers[useA,Polymer->typeA,FastTrack->True,ExplicitlyTyped->False];

					(* Obtain the Monomers of nodeB *)
					monoB=Monomers[nodeB,Polymer->typeB,FastTrack->True,ExplicitlyTyped->False];

					(* Substitute in the degeneracy rules for A *)
					degenerateA=monoA /. Physics`Private`lookupModelOligomer[typeA,DegenerateAlphabet];

					(* Substitute in the degeneracy rules for A *)
					degenerateB=monoB /. Physics`Private`lookupModelOligomer[typeB,DegenerateAlphabet];

					(* See if each monomer could match by checking the bases that intersect *)
					matching=MapThread[MatchQ[Intersection[#1,#2],{_String..}]&,{degenerateA,degenerateB}];

					(* Only if all Monomers could match could subsequenceB come before subsequenceA *)
					And@@matching

				],
				MatchQ[nodeA,nodeB]||MatchQ[UnTypeSequence[sequenceA],nodeB]
			]
		],
		False
	]

]/;OptionValue[FastTrack]

(* --- Core Functions --- *)
previousSubsequencesQ[sequenceA:SequenceP,sequenceB:SequenceP,ops:OptionsPattern[previousSubsequencesQ]]:=previousSubsequencesQ[sequenceA,sequenceB,FastTrack->True,ops]/;SequenceQ[sequenceA,Degeneracy->True,PassOptions[previousSubsequencesQ,SequenceQ,ops]]&&SequenceQ[sequenceB,Degeneracy->True,PassOptions[previousSubsequencesQ,SequenceQ,ops]]

SetAttributes[previousSubsequencesQ,Listable];


(* ::Subsubsection::Closed:: *)
(*possibleSubsequences*)


DefineOptions[possibleSubsequences,
	Options :> {
		{Polymer -> Automatic, DNA | RNA | PNA | Peptide | Modification | Automatic, "The polymer type that defines the potential alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types of the provided sequence."},
		{ExplicitlyTyped -> Automatic, (True | False) | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{Exclude -> {}, {(_String | (DNA | RNA | PNA | GammaLeftPNA | GammaRightPNA | Peptide | Modification)[_Integer | _String, ___])...}, "subsequences to be excluded from the output."},
		{Previous -> Null, (_String | (DNA | RNA | PNA | GammaLeftPNA | GammaRightPNA | Peptide | Modification)[_Integer | _String, ___]) | Null, "Subsequence (with degneracy) that must be capable of being the previous subsequence to the output sequences."},
		{Next -> Null, (_String | (DNA | RNA | PNA | GammaLeftPNA | GammaRightPNA | Peptide | Modification)[_Integer | _String, ___]) | Null, "Subsequence (with degneracy) that must be capable of being the next subsequence after the output sequences."},
		{FastTrack -> False,_,""}
	}];


(* --- FastTrack: Open Version --- *)
possibleSubsequences[template:SequenceP,included:({SequenceP...}|Null),ops:OptionsPattern[possibleSubsequences]]:=Module[

	{
		type,k,degenerateRules,templateMonos,previousMonos,nextMonos,templateConstraints,previousConstraints,nextConstraints,consensus,possible,valid,

		alphabet
	},

	(* Determine the type we are working with *)
	type=PolymerType[template,PassOptions[possibleSubsequences,PolymerType,ops]];

	(* determine the length of each subsequene *)
	k=SequenceLength[template,Polymer->type,FastTrack->True];

	(* extract the degenrate alphabets as a set of rules *)
	degenerateRules=Physics`Private`lookupModelOligomer[type,DegenerateAlphabet];

	(* generate the Monomers of the template *)
	templateMonos=Monomers[template,Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* generate the Monomers of what came before *)
	previousMonos=Monomers[If[MatchQ[OptionValue[Previous],Null],type[k],OptionValue[Previous]],Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* generate the Monomers of what came after *)
	nextMonos=Monomers[If[MatchQ[OptionValue[Next],Null],type[k],OptionValue[Next]],Polymer->type,ExplicitlyTyped->False,FastTrack->True];

	(* substitute in to generate the constraints on the template *)
	templateConstraints=templateMonos/.degenerateRules;


	(* Determine the alphabet *)
	alphabet=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* substitute in to generate the constraints from the previous sequence *)
	previousConstraints=Append[Rest[previousMonos]/.degenerateRules,alphabet];

	(* substitute in to generate the constraints from the next sequence *)
	nextConstraints=Prepend[Most[nextMonos]/.degenerateRules,alphabet];

	(* Generate the consensus constraints on each base *)
	consensus=MapThread[Intersection[#1,#2,#3]&,{previousConstraints,templateConstraints,nextConstraints}];

	(* Generate all options by examining the combination (tuples) of each possible monomer *)
	possible=StringJoin/@Tuples[consensus];

	(* Return only thoes included on the included list and not on the excluded list *)
	valid=Complement[
		If[MatchQ[included,Null],possible,Intersection[possible,included]],
		Flatten[{OptionValue[Exclude]}]
	];

	(* Explicitly type the ouput as requested *)
	ExplicitlyType[template,valid,PassOptions[possibleSubsequences,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- Core Functions --- *)
possibleSubsequences[template:SequenceP,included:({SequenceP...}|Null),ops:OptionsPattern[possibleSubsequences]]:=possibleSubsequences[template,included,FastTrack->True,ops]/;And[
	SequenceQ[Cases[Join[included,{template,OptionValue[Previous],OptionValue[Next]}],Except[Null]],Map->False,Exclude->{},PassOptions[possibleSubsequences,SequenceQ,ops]],
	(* If Previous is not null, check to make sure the sequence length is the same as the template *)
	If[MatchQ[OptionValue[Previous],Null],
		True,
		SequenceLength[OptionValue[Previous],PassOptions[possibleSubsequences,SequenceLength,ops]]==SequenceLength[template,PassOptions[possibleSubsequences,SequenceLength,ops]]
	],
	(* If Next is not null, check to make sure the sequence length is the same as the template *)
	If[MatchQ[OptionValue[Next],Null],
		True,
		SequenceLength[OptionValue[Next],PassOptions[possibleSubsequences,SequenceLength,ops]]==SequenceLength[template,PassOptions[possibleSubsequences,SequenceLength,ops]]
	],
	(* If included is not null, check to make sure the lengths are all the same (and the same as the template *)
	If[MatchQ[included,Null],
		True,
		RepeatedQ[SequenceLength[Append[included,template],PassOptions[possibleSubsequences,SequenceLength,ops]]]
	]
]


possibleSubsequences[template:SequenceP,ops:OptionsPattern[possibleSubsequences]]:=possibleSubsequences[template,Null,FastTrack->True,ops]/;And[
	SequenceQ[Cases[{template,OptionValue[Previous],OptionValue[Next]},Except[Null]],Map->False,Exclude->{},PassOptions[possibleSubsequences,SequenceQ,ops]],
	(* If Previous is not null, check to make sure the sequence length is the same as the template *)
	If[MatchQ[OptionValue[Previous],Null],
		True,
		SequenceLength[OptionValue[Previous],PassOptions[possibleSubsequences,SequenceLength,ops]]==SequenceLength[template,PassOptions[possibleSubsequences,SequenceLength,ops]]
	],
	(* If Next is not null, check to make sure the sequence length is the same as the template *)
	If[MatchQ[OptionValue[Next],Null],
		True,
		SequenceLength[OptionValue[Next],PassOptions[possibleSubsequences,SequenceLength,ops]]==SequenceLength[template,PassOptions[possibleSubsequences,SequenceLength,ops]]
	]
]


(* ::Subsection:: *)
(*Sequence Generation*)


(* ::Subsubsection:: *)
(*AllSequences*)


DefineOptions[AllSequences,
	Options :> {
		{Polymer -> DNA, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic defaults to DNA."},
		{Exclude -> {}, {_?SequenceQ...}, "Monomers or subsequences not to be included in the sequences generated."},
		{ExplicitlyTyped -> False, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


AllSequences::TooMany="The length of the output would generate `1` items.  The maximum is number of items is set to `2` by $MaximumSequences.";


(* --- Core Function --- *)
AllSequences[k:GreaterP[-1,1],ops:OptionsPattern[]]:=Module[
	{safeOps,type,alphabet,numberOfSequences,alphabetBase},

	(* Safely extract the options *)
	safeOps=SafeOptions[AllSequences, ToList[ops]];

	(* If the type is set to automatic, switch to DNA *)
	type=Switch[Polymer/.safeOps,
		Automatic,DNA,
		_,Polymer/.safeOps
	];


	(* Determine the base alphabet before exclusion of certain ones *)
	alphabetBase=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Exclude from the full list of potential alphabet members anything included in the provided exclude option*)
	alphabet=Cases[alphabetBase,Except[Alternatives@@(Exclude/.safeOps)]];

	(* Compute the total number of sequences that must be created *)
	numberOfSequences=Length[alphabet]^k;

	(* If the requested number results in a list longer then the maximum allowed, throw an error message *)
	If[numberOfSequences>$MaximumSequences,
		Message[AllSequences::TooMany,numberOfSequences,$MaximumSequences],
		Module[{combinations,candidates,seqs},

			(* Generate lists of all possible monomer combinations length k *)
			combinations=Tuples[alphabet,k];

			(* Flatten the conbination lists into sequences, remove any empty items *)
			candidates=Cases[StringJoin/@combinations,Except[""]];

			(* Select only the sequences not in the exlcude list *)
			seqs=Select[candidates,!StringMatchQ[#,___~~Alternatives@@(Exclude/.safeOps)~~___]&];

			(* Explicitly type the result if requested *)
			ExplicitlyType[seqs,FastTrack->True,PassOptions[AllSequences,ExplicitlyType,Polymer->type,Sequence@@safeOps]]
		]
	]

];


(* listable version *)
AllSequences[ks:{GreaterP[-1,1]..}, ops:OptionsPattern[]]:= AllSequences[#, ops]&/@ks;


(* ::Subsubsection::Closed:: *)
(*AllPalindromes*)


DefineOptions[AllPalindromes,
	Options :> {
		{Polymer -> DNA, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of."},
		{Exclude -> {}, {_?SequenceQ...}, "Monomers or subsequences not to be included in the sequences generated."},
		{ExplicitlyTyped -> False, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"])."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


AllPalindromes::TooMany="The length of the output would generate `1` items.  The maximum is number of items is set to `2` by $MaximumSequences.";


AllPalindromes[0,ops:OptionsPattern[]]:={};


AllPalindromes[1,ops:OptionsPattern[]]:=Module[
	{safeOps,type,pairs,selfPairs},

	(* Safely extract the options *)
	safeOps=SafeOptions[AllPalindromes, ToList[ops]];

	(* Determine the desired type.  DNA defaults *)
	type=Switch[Polymer/.safeOps,
		Automatic,DNA,
		_,Polymer/.safeOps
	];

	(* Determine the base alphabet before exclusion of certain ones *)
	pairs=Physics`Private`lookupModelOligomer[type,Complements];

	(* Select out only thoes pairs that self pair *)
	selfPairs=Select[pairs,First[#]==Last[#]&];

	(* Return only the Monomers involved in self Pairing typed as requested *)
	ExplicitlyType[selfPairs[[All,1]],PassOptions[AllPalindromes,ExplicitlyType,Polymer->type,Sequence@@safeOps]]

];


(* --- Odd length palindromes --- *)
AllPalindromes[length:GreaterP[-1,1],ops:OptionsPattern[]]:=Module[
	{type,safeOps,numberOfSequences,selfPairs,alphabet,alphabetBase},

	(* Safely extract the options *)
	safeOps=SafeOptions[AllPalindromes, ToList[ops]];

	(* Determine the desired type.  DNA defaults *)
	type=Switch[Polymer/.safeOps,
		Automatic,DNA,
		_,Polymer/.safeOps
	];

	(* Determine the base alphabet before exclusion of certain ones *)
	alphabetBase=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Exclude from the full list of potential alphabet members anything included in the provided exclude option*)
	alphabet=Cases[alphabetBase,Except[Alternatives@@(Exclude/.safeOps)]];

	(* Obtain all the self Pairing Monomers by requesting all palindromes a single monomer long *)
	selfPairs=AllPalindromes[1,Polymer->type,ExplicitlyTyped->False,PassOptions[AllPalindromes,safeOps]];

	(* Compute the total number of sequences that must be created *)
	numberOfSequences=Length[alphabet]^Floor[length/2]*Length[selfPairs];

	(* If we need to generate more sequences then we can, throw an error, if there are no palindromes return an empty list, otherwise continue *)
	Which[
		numberOfSequences==0,{},
		numberOfSequences>$MaximumSequences,Return[Message[AllPalindromes::TooMany,numberOfSequences,$MaximumSequences]],
		numberOfSequences<=$MaximumSequences,Module[{seqs,revComps,palindromes,candidates},

			(* generate all flanking sequences around the palindrome's self Pairing cores *)
			seqs=AllSequences[Floor[length/2],Polymer->type,ExplicitlyTyped->False,FastTrack->True,PassOptions[AllPalindromes,AllSequences,safeOps]];

			(* generate all revComps *)
			revComps=ReverseComplementSequence[seqs,Polymer->type,ExplicitlyTyped->False,FastTrack->True,PassOptions[AllPalindromes,ReverseComplementSequence,safeOps]];

			(* Generate every possible palindrome by taking each self Pairing sequence as a core and wrapping the sequences and their revComps around it *)
			palindromes=Function[core,MapThread[#1<>core<>#2&,{seqs,revComps}]]/@selfPairs;

			(* Select out any results on the exclude list *)
			candidates=Select[Flatten[palindromes],!StringMatchQ[#,___~~Alternatives@@(Exclude/.safeOps)~~___]&];

			(* Explicitly type the output as requested *)
			ExplicitlyType[candidates,FastTrack->True,PassOptions[AllPalindromes,ExplicitlyType,Polymer->type,Sequence@@safeOps]]

		]
	]

]/;OddQ[length]&&length>0


(* --- Even length palindromes --- *)
AllPalindromes[length:GreaterP[-1,1],ops:OptionsPattern[]]:=Module[
	{safeOps,numberOfSequences,type,alphabet,seqs,revComps,palindromes,candidates,alphabetBase},

	(* Safely extract the options *)
	safeOps=SafeOptions[AllPalindromes, ToList[ops]];

	(* Determine the desired type.  DNA defaults *)
	type=Switch[Polymer/.safeOps,
		Automatic,DNA,
		_,Polymer/.safeOps
	];

	(* Determine the base alphabet before exclusion of certain ones *)
	alphabetBase=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Exclude from the full list of potential alphabet members anything included in the provided exclude option*)
	alphabet=Cases[alphabetBase,Except[Alternatives@@(Exclude/.safeOps)]];

	(* Compute the total number of sequences that must be created *)
	numberOfSequences=Length[alphabet]^(length/2);

	(* If we need to generate more sequences then we can, throw an error *)
	If[numberOfSequences>$MaximumSequences,Return[Message[AllPalindromes::TooMany,numberOfSequences,$MaximumSequences]]];

	(* Generate all sequence's half the size of the palindromes reuested. *)
	seqs=AllSequences[length/2,Polymer->type,ExplicitlyTyped->False,FastTrack->True,PassOptions[AllPalindromes,AllSequences,safeOps]];

	(* Generate ReverseSequence comps of all teh sequences *)
	revComps=ReverseComplementSequence[seqs,Polymer->type,ExplicitlyTyped->False,FastTrack->True,PassOptions[AllPalindromes,ReverseComplementSequence,safeOps]];

	(* Fuse the ReverseSequence comps and the sequences togeather *)
	palindromes=MapThread[#1<>#2&,{seqs,revComps}];

	(* Select out any results on the exclude list *)
	candidates=Select[Flatten[palindromes],!StringMatchQ[#,___~~Alternatives@@(Exclude/.safeOps)~~___]&];

	(* Explciitly type as requested *)
	ExplicitlyType[candidates,PassOptions[AllPalindromes,ExplicitlyType,Polymer->type,FastTrack->True,Sequence@@safeOps]]

]/;EvenQ[length]&&length>0


(* listable version *)
AllPalindromes[lengths:{GreaterP[-1,1]..}, ops:OptionsPattern[]]:= AllPalindromes[#, ops]&/@lengths;


(* ::Subsubsection::Closed:: *)
(*RandomSequence*)


DefineOptions[RandomSequence,
	Options :> {
		{Polymer -> DNA, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of."},
		{Exclude -> {}, _List, "Monomers not to be included in alphabet when building all sequences."},
		{ExplicitlyTyped -> False, BooleanP, "If true, wraps the output in its polymer type (eg. DNA[\"A\"])."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- FastTrack Versions --- *)
RandomSequence[0,ops:OptionsPattern[]]:="";

RandomSequence[length:GreaterP[-1,1],ops:OptionsPattern[]]:=Module[
	{safeOps,type,alphabet,choices,sequence,result},

	safeOps = SafeOptions[RandomSequence, ToList[ops]];

	(* Determine the type of the sequence to be generated *)
	type=Polymer/.safeOps;


	(* Determine the base alphabet before exclusion of certain ones *)
	alphabet=Physics`Private`lookupModelOligomer[type,Alphabet];

	(* Generate a random sequence by choising random members of the alpabet *)
	choices=Table[RandomChoice[alphabet],{length}];

	(* now compress thoes choices into a single sequence *)
	sequence=StringJoin[choices];

	(* Type return value as requsted *)
	ExplicitlyType[sequence,PassOptions[RandomSequence,ExplicitlyType,Polymer->type,ops]]

]/;OptionValue[FastTrack]


(* --- Core Function -- *)
RandomSequence[length:GreaterP[-1,1],ops:OptionsPattern[]]:=Module[{candidate},

	(* Generate a canidate sequence *)
	candidate=RandomSequence[length,FastTrack->True,ops];

	(* If the canidate is in the exclude list, go fish and try again *)
	If[MemberQ[OptionValue[Exclude],candidate],
		RandomSequence[length,ops],
		candidate
	]

]/;length>0

RandomSequence[length:GreaterP[-1,1],n:GreaterP[0,1],ops:OptionsPattern[]]:=Table[RandomSequence[length,ops],{n}]/;length>=0&&n>=0


(* listable version *)
RandomSequence[lengths:{GreaterP[-1,1]..}, ops:OptionsPattern[]]:= RandomSequence[#, ops]&/@lengths;
RandomSequence[lengths:{GreaterP[-1,1]..}, n:GreaterP[0,1], ops:OptionsPattern[]]:= RandomSequence[#, n, ops]&/@lengths;
RandomSequence[length:GreaterP[-1,1], ns:{GreaterP[0,1]..}, ops:OptionsPattern[]]:= RandomSequence[length, #, ops]&/@ns;
RandomSequence[lengths:{GreaterP[-1,1]..}, ns:{GreaterP[0,1]..}, ops:OptionsPattern[]]:= MapThread[RandomSequence[#1, #2, ops]&, {lengths, ns}]/;SameLengthQ[lengths,ns]


(* ::Subsection:: *)
(*Dynamic Generation*)


(* ::Subsubsection::Closed:: *)
(*junctionSubsequences*)


DefineOptions[junctionSubsequences,
	Options :> {
		{CanonicalPairing -> True, True | False, "If set to true, all polymer types are converted to DNA."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A \"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False,_,""}
	}];


(* --- FastTrack: Motif Map version --- *)
junctionSubsequences[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},junct:{{_String,_String}...},k_Integer,ops:OptionsPattern[junctionSubsequences]]:=Module[
{flatMotifMap,borderingSubs,rule,borders},

	(* Smooth over any options by looking at only the last option selected in the list for the motif map *)
	flatMotifMap=Function[rule,First[rule]->(If[MatchQ[#,_List],First[#],#]&/@Last[rule])]/@motifMap;

	(* Now for each junction pull out the bordering subsequences *)
	borderingSubs={Last[First[#]/.flatMotifMap],First[Last[#]/.flatMotifMap]}&/@junct;

	(* Now table though the junctions to generate the subsequenes at the junction *)
	borders=Table[ToDNA[SequenceDrop[First[#],i],ExplicitlyTyped->False]<>ToDNA[SequenceTake[Last[#],i],ExplicitlyTyped->False],{i,1,k-1}]&/@borderingSubs;

	(* return all of the borders in a flat list *)
	Flatten[borders]

]/;OptionValue[FastTrack]

(* --- FastTrack: Strand(s) and Structures version --- *)
junctionSubsequences[strands:({StrandP...}|{StructureP...}),k_Integer,ops:OptionsPattern[junctionSubsequences]]:=Module[{motifMap,junct},

	(* Extract the motif's subsequences *)
	motifMap=EmeraldSubsequences[strands,k,CanonicalPairing->True,Complete->True,PassOptions[junctionSubsequences,EmeraldSubsequences,ops]];

	(* Determine the junctions *)
	junct=junctions[strands,PassOptions[junctionSubsequences,junctions,ops]];

	(* now get the junctions *)
	junctionSubsequences[motifMap,junct,k,ops]

]/;OptionValue[FastTrack]

(* --- Core Function --- *)
junctionSubsequences[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},junct:{{_String,_String}...},k_Integer,ops:OptionsPattern[junctionSubsequences]]:=junctionSubsequences[motifMap,junct,k,FastTrack->True,ops]/;And[

	(* Check to see that all of the junctions have provided motif maps *)
	And@@(MemberQ[motifMap[[All,1]],#]&/@Flatten[junct]),

	(* check to see that all of the stuff in the motif maps passes SequenceQ *)
	And@@(SequenceQ/@Flatten[motifMap[[All,2]]])
]
junctionSubsequences[strands:{StrandP...},k_Integer,ops:OptionsPattern[junctionSubsequences]]:=junctionSubsequences[strands,k,FastTrack->True,ops]/;And@@(StrandQ[#,CheckMotifs->True,PassOptions[junctionSubsequences,StrandQ,ops]]&/@strands)
junctionSubsequences[structures:{StructureP...},k_Integer,ops:OptionsPattern[junctionSubsequences]]:=junctionSubsequences[structures,k,FastTrack->True,ops]/;And@@(StructureQ[structures,CheckMotifs->True,PassOptions[junctionSubsequences,StructureQ,ops]])

(* --- Reverse Listable --- *)
junctionSubsequences[imp:(StructureP|StrandP),k_Integer,ops:OptionsPattern[junctionSubsequences]]:=junctionSubsequences[{imp},k,ops]
junctionSubsequences[imp:(StrandP|StructureP)|{StrandP...}|{StructureP...},ks:{_Integer..},ops:OptionsPattern[junctionSubsequences]]:=junctionSubsequences[imp,#,ops]&/@ks


(* ::Subsubsection::Closed:: *)
(*helper functions*)


incrementPosition[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},position:{_Integer,_Integer}]:=Module[{newPosition},

	(* Increment by one unless at the end of a motif, then jump to the next motif *)
	newPosition=If[Last[position]<Length[motifMap[[First[position],2]]],
			{First[position],Last[position]+1},
			{First[position]+1,1}
	];

	(* If we're not off the end of the map, and there's a fixed sequence at the new position, keep incrimenting.  Otherwise return what we have now *)
	If[First[newPosition]<Length[motifMap]&&MatchQ[motifMap[[First[newPosition],2,Last[newPosition]]],_String],
		incrementPosition[motifMap,newPosition],
		newPosition
	]

]

decrementPosition[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},position:{_Integer,_Integer}]:=Module[{oldPosition},

	oldPosition=If[Last[position]<=1,
		{First[position]-1,If[First[position]>1,Length[motifMap[[First[position]-1,2]]],0]},
		{First[position],Last[position]-1}
	];

	(* If we're off not off the end of the map, and there's a fixed sequence at old position, keep decrementing.  Otherwise return what we have now *)
	If[First[oldPosition]>=1&&MatchQ[motifMap[[First[oldPosition],2,Last[oldPosition]]],_String],
		decrementPosition[motifMap,oldPosition],
		oldPosition
	]
]

junctionSiteQ[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},junct:{{_String,_String}...},position:{_Integer,_Integer}]:=Which[

	(* if we're at the fist subsequemce, check to see if any subsequences proceed us in a junction *)
	Last[position]==1,MemberQ[junct[[All,2]],First[motifMap[[First[position]]]]],

	(* If we're at the last subsequence, check to see if any subsequences come after us in a junction *)
	Last[position]==Length[motifMap[[First[position],2]]],MemberQ[junct[[All,1]],First[motifMap[[First[position]]]]],

	(* Otherwise we're not at a junction *)
	True,False
]

revCompMotifMap[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..}]:=Module[{recipricles},

	(* Generate the recipricles of all of the motif rules we currently know *)
	recipricles=ReverseComplementSequence[First[#],Motif->True]->Reverse[ReverseComplementSequence[Last[#],Motif->False]]&/@motifMap;

	(* Join togeather the existing motif map and its rev comp map *)
	Join[motifMap,recipricles]

]

screenOptions[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},junct:{{_String,_String}...},position:{_Integer,_Integer},exclude:{SequenceP...},options:{SequenceP...}]:=Module[
{frontQ,motif,fullMotifMap,relevantJunctions,borderingSubs},

	(* Determine if the junction we're building is at the front or the back  *)
	frontQ=MatchQ[First[position],1];

	(* figure out what motif we're dealing with on the junction *)
	motif=motifMap[[First[position],1]];

	(* expand the motif map to cover the revComps of all motifs *)
	fullMotifMap=revCompMotifMap[motifMap];

	(* screen out only the junctions relevent to the motif we're working on *)
	relevantJunctions=If[frontQ,
		Cases[junct,{a_,motif}:>a],
		Cases[junct,{motif,a_}:>a]
	];

	(* go grab any bordering junction subs *)
	borderingSubs=If[frontQ,
		Last[Flatten[{Last[(#/.fullMotifMap)]}]]&/@relevantJunctions,
		Last[Flatten[{First[(#/.fullMotifMap)]}]]&/@relevantJunctions
	];

	(* Select out the options that conflict with the exclude list *)
	Select[options,MatchQ[Intersection[exclude,junctionSubs[#,borderingSubs,frontQ]],{}]&]

]

junctionSubs[option:SequenceP,borderingSubs:{SequenceP...},True]:=Module[{borders},

	(* for each bordering subsequence, generate the list of junction seuences involved *)
	borders=Table[StringDrop[#,i]<>StringTake[option,i],{i,1,StringLength[option]-1}]&/@borderingSubs;

	(* Return all the subsequences this junction would generate *)
	Flatten[borders]

]

junctionSubs[option:SequenceP,borderingSubs:{SequenceP...},False]:=Module[{borders},

	(* for each bordering subsequence, generate the list of junction seuences involved *)
	borders=Table[StringDrop[option,i]<>StringTake[#,i],{i,1,StringLength[option]-1}]&/@borderingSubs;

	(* Return all the subsequences this junction would generate *)
	Flatten[borders]

]

replaceSequence[cmplx:StructureP,map:{(_String->_String)..},orignalStructure:StructureP]:=Module[
{strands,pairs,newStrands,orignalMotifs},

	(* isolate the strands *)
	strands=First[cmplx];

	(* isolate the pairs *)
	pairs=Last[cmplx];

	(* Determine which motifs existed in the orignal Structure *)
	orignalMotifs=Cases[orignalStructure,PolymerP[_,motif_String]:>motif,3];

	(* For each strand, replace the motifs as requested *)
	newStrands=replaceSequence[#,map,orignalMotifs]&/@strands;

	(* Reconstrct the final sequence with the pairs in place *)
	Structure[newStrands,pairs]

]

replaceSequence[str:StrandP,map:{(_String->_String)..},motifs:{_String...}]:=Module[{seqList,finalList},

	(* pull ou thte sequence list *)
	seqList=List@@str;

	(* replace all of the sequences in the list *)
	finalList=If[MemberQ[motifs,Last[#]],
		Head[#][Last[#]/.map,Last[#]],
		Head[#][Last[#]/.map]
	]&/@seqList;

	(* turn the final list back into a strand *)
	Strand@@finalList

]

flattenMap[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..}]:=Function[motifRule,First[motifRule]->(If[MatchQ[#,_String],#,Last[#]]&/@Last[motifRule])]/@motifMap


(* ::Subsubsection::Closed:: *)
(*GenerateSequence*)


DefineOptions[GenerateSequence,
	Options :> {
		{Verbose -> False, True | False, "If True, displays the status of the dynamic generation while its in progress."},
		{CombinatoricsBuffer -> 1., _Real, "Multiplier on how strictly optimal the algorithm will attempt to be. 1.0 will demand perfectly optimial sequences, higher numbers will allow for suboptimality."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the output in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{Exclude -> {}, {_?SequenceQ...}, "List of subsequences that will not be included in the output."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{EvaluationMonitor -> NucleicAcids`Private`$100, NucleicAcids`Private`$100, "Evaluation Monitor.", Category->Hidden},
		{Polymer -> DNA, DNA, "Polymer type.", Category->Hidden}
	}
];


GenerateSequence::NoSolution="Exhausted all possible solutions give constraint level `1`.";


(* --- Initial Definition: Determing the approprate k-level --- *)
GenerateSequence[cmplx:StructureP,ops:OptionsPattern[GenerateSequence]]:=Module[{uniqueNucleotides,k},

	(* Determine the total number of unique nucleotides that the Structure contains *)
	uniqueNucleotides=Length[Flatten[EmeraldSubsequences[NameMotifs[cmplx],1,ExplicitlyTyped->False][[All,2]]]];

	(* Determin k by evaulating the debruijn function (allowing for some play in a provided buffer) *)
	k=debruijnFunction[uniqueNucleotides*OptionValue[CombinatoricsBuffer]];

	(* run generation with the selected k level constraint *)
	GenerateSequence[cmplx,k,ops]

]/;OptionValue[FastTrack]

(* --- Initial Definition: Preparing the motif map and junctions --- *)
GenerateSequence[cmplx:StructureP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=Module[{named,motifMap,junct,solution,motifSequences},

	(* Make sure the Structure is fully named *)
	named=NameMotifs[cmplx];

	(* Prepare the motif map *)
	motifMap=EmeraldSubsequences[named,k,ExplicitlyTyped->False];

	(* Prepare the junctions *)
	junct=junctions[named];

	(* go generate the sequence *)
	solution=GenerateSequence[motifMap,junct,k,ops];

	(*  Take each motif rule and generate the sequences for it *)
	motifSequences=First[#]->buildSequence[Last[#]]&/@solution;

	(* go ahead and swap out the sequence definitions with the motif map we just generated *)
	replaceSequence[named,motifSequences,cmplx]

]/;OptionValue[FastTrack]

(* --- Initial Definition: Preparing the exclude list and initial positions --- *)
GenerateSequence[motifMap:{(_String->{SequenceP..})..},junct:{{_String,_String}...},k_Integer,ops:OptionsPattern[GenerateSequence]]:=Module[
{preparedMap,initialExclude,included,initialPosition,finishedMap,fullMap,finalMap},

	(* Start by wrapping all the options in a list *)
	preparedMap=Function[motif,First[motif]->(If[SequenceQ[#,Degeneracy->False],#,{#}]&/@Last[motif])]/@motifMap;

	(* subsequences already included in the design *)
	included=Select[Flatten[motifMap[[All,2]]],SequenceQ[#,Degeneracy->False]&];

	(* Develop the initial exclude list as a combination of anything fully spesified and any palindromes of length k *)
	initialExclude=Join[OptionValue[Exclude],AllPalindromes[k],included,ReverseComplementSequence[included]];

	(* Develop the initial position where we can start generating *)
	initialPosition={1,1};

	(* If Verbose is on set up the evaluation monitor for viewing as it progresses *)
	If[OptionValue[Verbose],PrintTemporary[Dynamic[Evaluate[OptionValue[EvaluationMonitor]][]]]];

	(* Get started on genration *)
	finishedMap=Block[{$RecursionLimit=\[Infinity],$IterationLimit=\[Infinity]},
		GenerateSequence[preparedMap,junct,k,initialPosition,Exclude->initialExclude,ops]
	];

	(* Generate the full map by providing the ReverseSequence Comps*)
	fullMap=revCompMotifMap[finishedMap];

	(* Go through the map and return only the options selected not the entire trace *)
	flattenMap[fullMap]

]/;OptionValue[FastTrack]

(* --- Recursive Definition --- *)
GenerateSequence[motifMap:{(_String->{(SequenceP|{SequenceP..})..})..},junct:{{_String,_String}...},k_Integer,position:{_Integer,_Integer},ops:OptionsPattern[GenerateSequence]]:=Module[{current,monitor},

	(* If verbose is active, display our current progress *)
	If[OptionValue[Verbose],
		Evaluate[OptionValue[EvaluationMonitor]][]=Grid[
			{
				{"Map: ",Column[flattenMap[motifMap]]}
			},Alignment->{{Right,Left}}
		]
	];

	(* Extract the monomer we're currently examining *)
	current=motifMap[[First[position],2,Last[position]]];

	(* Check to see if we're starting at a fixed sequence or a degenerate one *)
	If[MatchQ[current,_String],

		(* Current position is a fixed sequence *)
		Module[{newPosition},

			(* Determine the next position: if we are before the end of a motif, just increment the index, if not, increment the motif *)
			newPosition=incrementPosition[motifMap,position];

			(* If our new position is off the end of the map, just return (we are finished), otherwise keep generateing *)
			If[First[newPosition]>Length[motifMap],
				motifMap,
				GenerateSequence[motifMap,junct,k,newPosition,ops]
			]
		],

		(* Current position is undefined *)
		Module[{rawPrevious,previous,rawNext,next,currentExclude,optionsSansJunctionCheck,options},

			(* Pull out whatever's at the previous slot *)
			rawPrevious=If[Last[position]>1,motifMap[[First[position],2,Last[position]-1]],{Null}];

			(* if its a constant, take it as is, if its a variable, pull out the last option *)
			previous=If[MatchQ[rawPrevious,_String],rawPrevious,Last[rawPrevious]];

			(* Pull out whatever's at the previous slot *)
			rawNext=If[Last[position]<Length[motifMap[[First[position],2]]],motifMap[[First[position],2,Last[position]+1]],{Null}];

			(* Extract the next monomer if there is one *)
			next=If[MatchQ[rawNext,_String],rawNext,Last[rawNext]];

			(* include in the exclude list any options we've already tried at this position *)
			currentExclude=Join[OptionValue[Exclude],motifMap[[First[position],2,Last[position]]]];

			(* See whats avaiable bsed on the exclude list *)
			optionsSansJunctionCheck=possibleSubsequences[Last[current],Previous->previous,Next->next,Exclude->currentExclude];

			(* Check to see if we're at a junction site.  If we are, screen out options that would lead to conflicts after connecting the junction *)
			options=If[junctionSiteQ[motifMap,junct,position],
				screenOptions[motifMap,junct,position,OptionValue[Exclude],optionsSansJunctionCheck],
				optionsSansJunctionCheck
			];

			(* See how many options are avaible *)
			If[Length[options]>0,

				(* options are avaible, pick one and move foward: if its the last position, pick one and return *)
				Module[{newMap,choice,newExclude,newPosition,newOptions},

					(* choose any valid option at random *)
					choice=RandomChoice[options];

					(* generate a new map to mess with *)
					newMap=motifMap;

					(* Generate the new set of options by stripping off any duplicates (repeated first options) and tacking on our choice *)
					newOptions=Append[DeleteDuplicates[motifMap[[First[position],2,Last[position]]]],choice];

					(* modify the motif map to include this choice *)
					newMap[[First[position],2,Last[position]]]=newOptions;
					(* Warning: this is a nasty imperative line that includes concept of state.  motifMap's value changes as a result of running this line *)

					(* Generate a new exclude list that includes this choice and its ReverseComplementSequence *)
					newExclude=Join[OptionValue[Exclude],{choice,ReverseComplementSequence[choice]}];

					(* increment the position *)
					newPosition=incrementPosition[motifMap,position];

					(* If our new position is off the end of the map, just return (we are finished), otherwise keep generateing *)
					If[First[newPosition]>Length[motifMap],
						newMap,
						GenerateSequence[newMap,junct,k,newPosition,Exclude->newExclude,ops]
					]
				],

				(* There are no options avaible, return to last position and make a different decision.  If we're at the front of the map, *)
				Module[{oldPosition,oldChoice,oldExclude,oldMap},

					(* Decrement the position *)
					oldPosition=decrementPosition[motifMap,position];

					(* If we're totally stuck and all previous options are unworkable, exit with an error *)
					If[First[oldPosition]<1,(Message[GenerateSequence::NoSolution,k];Return[Null])];

					(* Pull out the last choice we made *)
					oldChoice=Last[motifMap[[First[oldPosition],2,Last[oldPosition]]]];

					(* Restore the old choice and its ReverseComplementSequence to the pool by removing them from the exlcude list *)
					oldExclude=Complement[OptionValue[Exclude],{oldChoice,ReverseComplementSequence[oldChoice]}];

					(* generate another map to mess with *)
					oldMap=motifMap;

					(* reset our previous position's options to their ground state *)
					oldMap[[First[position],2,Last[position]]]=Take[motifMap[[First[position],2,Last[position]]],1];

					(* signal that the old choice is not defined by tacking on another stating option *)
					oldMap[[First[oldPosition],2,Last[oldPosition]]]=Append[motifMap[[First[oldPosition],2,Last[oldPosition]]],First[motifMap[[First[oldPosition],2,Last[oldPosition]]]]];

					(* Recursively continue the run *)
					GenerateSequence[oldMap,junct,k,oldPosition,Exclude->oldExclude,ops]

				]
			]
		]
	]
]/;OptionValue[FastTrack]

(* --- Core Function: structures --- *)
GenerateSequence[cmplx:StructureP,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[cmplx,FastTrack->True,ops]/;StructureQ[NameMotifs[cmplx],CheckMotifs->True,CheckPairs->True]
GenerateSequence[cmplx:StructureP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[cmplx,k,FastTrack->True,ops]/;StructureQ[NameMotifs[cmplx],CheckMotifs->True,CheckPairs->True]

(* --- Strands --- *)
GenerateSequence[str:StrandP,ops:OptionsPattern[GenerateSequence]]:=Module[{cmplx,solution},

	(* Promote the strand to be a Structure *)
	cmplx=Structure[{str},{}];

	(* Generate a solution using the Structure *)
	solution=GenerateSequence[cmplx,FastTrack->True,ops];

	(* Extract the strand back out of the solution Structure *)
	First[First[solution]]

]/;OptionValue[FastTrack]
GenerateSequence[str:StrandP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=Module[{cmplx,solution},

	(* Promote the strand to be a Structure *)
	cmplx=Structure[{str},{}];

	(* Generate a solution using the Structure *)
	solution=GenerateSequence[cmplx,k,FastTrack->True,ops];

	(* Extract the strand back out of the solution Structure *)
	First[First[solution]]

]/;OptionValue[FastTrack]

GenerateSequence[str:StrandP,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[str,FastTrack->True,ops]/;StrandQ[NameMotifs[str],CheckMotifs->True]
GenerateSequence[str:StrandP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[str,k,FastTrack->True,ops]/;StrandQ[NameMotifs[str],CheckMotifs->True]

(* --- Sequences --- *)
GenerateSequence[seq:SequenceP,ops:OptionsPattern[GenerateSequence]]:=Module[{str,cmplx,solution},

	(* generate the strand for the seqeunce *)
	str=Strand[ExplicitlyType[seq,ExplicitlyTyped->True]];

	(* Promote the strand to be a Structure *)
	cmplx=Structure[{str},{}];

	(* Generate a solution using the Structure *)
	solution=GenerateSequence[cmplx,FastTrack->True,ops];

	(* Extract the strand back out of the solution Structure *)
	ExplicitlyType[seq,First[First[First[solution]]],PassOptions[GenerateSequence,ExplicitlyType,ops]]

]/;OptionValue[FastTrack]
GenerateSequence[seq:SequenceP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=Module[{str,cmplx,solution},

	(* generate the strand for the sequence *)
	str=Strand[ExplicitlyType[seq,ExplicitlyTyped->True]];

	(* Promote the strand to be a Structure *)
	cmplx=Structure[{str},{}];

	(* Generate a solution using the Structure *)
	solution=GenerateSequence[cmplx,k,FastTrack->True,ops];

	(* Extract the strand back out of the solution Structure *)
	ExplicitlyType[seq,First[First[First[solution]]],PassOptions[GenerateSequence,ExplicitlyType,ops]]

]/;OptionValue[FastTrack]

GenerateSequence[seq:SequenceP,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[seq,FastTrack->True,ops]/;SequenceQ[seq]
GenerateSequence[seq:SequenceP,k_Integer,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[seq,k,FastTrack->True,ops]/;SequenceQ[seq]

(* --- Integer versions --- *)
GenerateSequence[length_Integer,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[OptionValue[Polymer][length],ops]
GenerateSequence[length_Integer,k_Integer,ops:OptionsPattern[GenerateSequence]]:=GenerateSequence[OptionValue[Polymer][length],k,ops]