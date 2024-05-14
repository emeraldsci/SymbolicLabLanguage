(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*P's & Q's*)


SequenceSpanP = {Span[_Integer,_Integer]..};
StrandSpanP = {_Integer,SequenceSpanP};
StructureSpanP = {_Integer,_Integer,SequenceSpanP};


(* ::Subsubsection:: *)
(*Bond Patterns*)


MotifBasePairBondP=Bond[{_Integer,_Integer,_Integer;;_Integer},{_Integer,_Integer,_Integer;;_Integer}];
MotifBasePairBondsP = {MotifBasePairBondP..};

StrandBasePairBondP=Bond[{_Integer,_Integer;;_Integer},{_Integer,_Integer;;_Integer}];
StrandBasePairBondsP={StrandBasePairBondP..};

MotifBondsP={MotifBondP..};

NoBondsP={};

StrandListP={_Strand..};


(* ::Subsubsection:: *)
(*BondFormatP*)


BondFormatP = StrandMotif | StrandBase | StrandMotifBase;


(* ::Subsection::Closed:: *)
(*Structure definitions*)


(* If no bonds specified, add an empty list so that structures ALWAYS have two elements *)
Structure[s:StrandListP] := Structure[s,{}];

(* given single strand, put in list *)
Structure[s:StrandP] := Structure[{s}];

(* given sequence *)
Structure[seq_String?SequenceQ]:=Structure[{Strand[seq]},{}];

(* given motif *)
Structure[motif:MotifP]:=Structure[{Strand[motif]},{}];

(* given mixture of strands and sequences *)
Structure[seqs:{(_String?SequenceQ|StrandP|MotifP)..}]/;MemberQ[seqs,_String]:=
	Structure[Map[Strand,seqs]];


(* ::Subsection:: *)
(*Structure Bonds*)


(* ::Subsubsection:: *)
(*reformatBonds*)


(* No bonds, so just return the structure *)
reformatBonds[struct: Structure[strs: {_Strand..}, {}], newFormat:BondFormatP] := struct;

reformatBonds[struct: StructureP, StrandMotif] := toStrandMotifBonds[struct];
reformatBonds[struct: StructureP, StrandBase] := toStrandBasePairBonds[struct];
reformatBonds[struct: StructureP, StrandMotifBase] := toMotifBasePairBonds[struct];

reformatBonds[structList: {StructureP..}, newFormat: BondFormatP] := reformatBonds[#, newFormat] & /@ structList;


(* ::Subsubsection:: *)
(*toStrandMotifBonds*)


toStrandMotifBonds[struct:Structure[StrandListP,MotifBondsP]]:=struct;
toStrandMotifBonds[struct_]:=reformatMotifs[toMotifBasePairBonds[struct]];


(* ::Subsubsection::Closed:: *)
(*toMotifBasePairBonds*)
Authors[toMotifBasePairBonds]:={"scicomp", "brad"};


toMotifBasePairBonds[c:Structure[StrandListP]]:=c;
toMotifBasePairBonds[c:Structure[StrandListP,NoBondsP]]:=c;
toMotifBasePairBonds[c:Structure[StrandListP,MotifBasePairBondsP]]:=c;

(* if only single motif in all strands, give all pairs motif#1 *)
toMotifBasePairBonds[Structure[ss:{Strand[_]..},ps:StrandBasePairBondsP]]:=With[
	{newPairs = Map[Insert[#, 1, 2] &, ps, {2}]},
	Structure[ss,newPairs]
];

toMotifBasePairBonds[struct:Structure[ss:StrandListP,ps:StrandBasePairBondsP]]:=Module[{alignedStruct,newPairs},
	alignedStruct = alignStrandBaseBonds[struct];
	newPairs = Flatten[Map[strandBasePairBondToMotifBasePairBond[ss,#]&,alignedStruct[Bonds]]];
	Structure[ss,newPairs]
];

(* mixture of bond formats *)
toMotifBasePairBonds[struct:Structure[ss:StrandListP,ps:{BondP..}]]:=Module[{alignedStruct,newPairs},
	alignedStruct = alignStrandBaseBonds[struct];
	newPairs = Flatten[Map[bondToMotifBasePairBond[ss,#]&,alignedStruct[Bonds]]];
	Structure[ss,newPairs]
];


bondToMotifBasePairBond[strs:StrandListP,bond:StrandBasePairBondP]:=strandBasePairBondToMotifBasePairBond[strs,bond];
bondToMotifBasePairBond[strs:StrandListP,bond:MotifBondP]:=motifBondToMotifBasePairBond[strs,bond];
bondToMotifBasePairBond[strs:StrandListP,bond:MotifBasePairBondP]:=bond;

strandBasePairBondToMotifBasePairBond[strs:StrandListP,Bond[{s1_Integer,z1:Span[x1_,y1_]},{s2_Integer,z2:Span[x2_,y2_]}]]:=Module[
	{m1,m2,p1,p2},
	{m1,p1} = strandBasePairBondToMotifBasePairBond[strs[[s1]],z1];
	{m2,p2} = strandBasePairBondToMotifBasePairBond[strs[[s2]],z2];
	(* reverse m2 and p2 because other half of bonds go in backwards order *)
	MapThread[Bond[{s1,#1,#2},{s2,#3,#4}]&,{m1,p1,Reverse[m2],Reverse[p2]}]
];
strandBasePairBondToMotifBasePairBond[str_Strand,Span[x_,y_]]:=Module[
	{lengths,starts,ends,motifIndices,relativeSpans},
	lengths = StrandLength[str,Total->False];
	motifIndices = motifIndicesFromAbsolutePosition[lengths,x,y];
	relativeSpans = relativeSpansFromAbsoluteSpanAndMotifIndex[lengths,motifIndices,Span[x,y]];
	{motifIndices,relativeSpans}
];

toMotifBasePairBonds[c:Structure[ss:StrandListP,ps:MotifBondsP]]:=Module[{newPairs},
	newPairs = Map[motifBondToMotifBasePairBond[ss,#]&,ps];
	Structure[ss,newPairs]
];
motifBondToMotifBasePairBond[strs:StrandListP,Bond[{s1_Integer,m1_Integer},{s2_Integer,m2_Integer}]]:=Module[{x1,x2},
	x1=SequenceLength[strs[[s1,m1]]];
	x2=SequenceLength[strs[[s2,m2]]];
	Bond[{s1,m1,Span[1,x1]},{s2,m2,Span[1,x2]}]
];



(* ::Subsubsection::Closed:: *)
(*toStrandBasePairBonds*)

Authors[toStrandBasePairBonds]:={"scicomp", "brad"};

toStrandBasePairBonds[c:Structure[StrandListP,NoBondsP]]:=c;
toStrandBasePairBonds[c:Structure[StrandListP,StrandBasePairBondsP]]:=c;

(* if only single motif in all strands, remove motif # and don't change bases *)
toStrandBasePairBonds[c:Structure[ss:{Strand[_]..},ps:MotifBasePairBondsP]]:=With[
	{newPairs = Map[Delete[#,  2] &, ps, {2}]},

	Structure[ss,newPairs]
];

(*toStrandBasePairBonds[c:Structure[ss:StrandListP,ps:MotifBasePairBondsP]]:=Module[{newPairs},
	newPairs = Map[motifBasePairBondToStrandBasePairBond[ss,#]&,ps];
	Structure[ss,newPairs]
];*)
motifBasePairBondToStrandBasePairBond[strs:StrandListP,Bond[{s1_Integer,m1_Integer,Span[x1_,y1_]},{s2_Integer,m2_Integer,Span[x2_,y2_]}]]:=Module[
	{newPair1,newPair2},
	newPair1 = motifBasePairBondToStrandBasePairBond[strs,s1,m1,Span[x1,y1]];
	newPair2 = motifBasePairBondToStrandBasePairBond[strs,s2,m2,Span[x2,y2]];
	Bond[newPair1,newPair2]
];
motifBasePairBondToStrandBasePairBond[strs_,s_,m_,Span[x_,y_]]:=Module[
	{lengths,ends,offset},
	lengths = StrandLength[strs[[s]],Total->False];
	ends = Accumulate[lengths];
	offset = Total[lengths[[1;;m-1]]];
	{s,Span[offset+x,offset+y]}
];

(*toStrandBasePairBonds[c:Structure[ss:StrandListP,ps:MotifBondsP]]:=Module[{newPairs},
	newPairs = Map[motifBondToStrandBasePairBond[ss,#]&,ps];
	Structure[ss,newPairs]
];*)
motifBondToStrandBasePairBond[strs:StrandListP,Bond[{s1_Integer,m1_Integer},{s2_Integer,m2_Integer}]]:=Module[{newPair1,newPair2},
	newPair1 = motifBondToStrandBasePairBond[strs,s1,m1];
	newPair2 = motifBondToStrandBasePairBond[strs,s2,m2];
	Bond[newPair1,newPair2]
];
motifBondToStrandBasePairBond[strs_,s_,m_]:=Module[
	{lengths,ends,offset,x},
	lengths = StrandLength[strs[[s]],Total->False];
	ends = Accumulate[lengths];
(*	offset = Total[ends[[1;;m-1]]];*)
	offset = Total[lengths[[1;;m-1]]];
	x= SequenceLength[strs[[s,m]]];
	{s,Span[offset+1,offset+x]}
];

toStrandBasePairBonds[c: Structure[ss: StrandListP, ps: {(MotifBondP | MotifBasePairBondP | StrandBasePairBondP)..}]]:=Module[{newPairs},
	newPairs = Map[someBondToStrandBasePairBond[ss,#]&,ps];
	Structure[ss, newPairs]
];
someBondToStrandBasePairBond[strs_, bond: MotifBondP] := motifBondToStrandBasePairBond[strs, bond];
someBondToStrandBasePairBond[strs_, bond: MotifBasePairBondP] := motifBasePairBondToStrandBasePairBond[strs, bond];
someBondToStrandBasePairBond[strs_, bond: StrandBasePairBondP] := bond;


(* ::Subsubsection:: *)
(*consolidateBonds*)


consolidateBonds[structure:Structure[{_Strand..},{}]]:=structure;

consolidateBonds[structure:Structure[{_Strand..},StrandBasePairBondsP]]:=Module[
	{strands,bonds,gatheredBonds,consolidatedBonds},

	(* split & sort *)
	strands = structure[Strands];
	bonds = sortStructureBonds[structure[Bonds]];

	(* gather by strand indices *)
	gatheredBonds = GatherBy[bonds, {#[[1,1]],#[[2,1]]}&];

	(* consolidate *)
	consolidatedBonds = Flatten[Map[consolidateBondGroup,gatheredBonds]];

	Structure[strands,consolidatedBonds]

];

consolidateBonds[structure:Structure[{_Strand..},MotifBasePairBondsP]]:=
	toMotifBasePairBonds[consolidateBonds[toStrandBasePairBonds[structure]]];

consolidateBonds[structure:Structure[{_Strand..},MotifBondsP]]:=
	structure;




sortStructureBonds[structure_Structure]:=With[
	{bonds=structure[Bonds],strands=structure[Strands]},
	Structure[
		strands,
		SortBy[bonds,{#[[1,1]],#[[1,2,1]]}&]
	]
];
sortStructureBonds[bonds:{_Bond...}]:=SortBy[bonds,{#[[1,1]],#[[1,2,1]]}&];


consolidateBondGroup[bonds:{_Bond...}]:=
	Fold[Join[Most[#1],consolidateTwoBonds[Last[#1],#2]]&,{First[bonds]},Rest[bonds]];


(*
	This only consolidates if both sides of both bonds are adjacent
*)

(* absolute strand positions *)
consolidateTwoBonds[
	b1:Bond[{s1_,x1_;;x2_},{s2_,y3_;;y4_}],
	b2:Bond[{s1_,x3_;;x4_},{s2_,y1_;;y2_}]
]:=Which[
	And[MatchQ[x2+1,x3],MatchQ[y2+1,y3]],
		{Bond[{s1,x1;;x4},{s2,y1;;y4}]},
	True,
		{b1,b2}
];


(* ::Subsubsection::Closed:: *)
(*motifIndexFromAbsolutePosition*)


motifIndexFromAbsolutePosition[str_Strand,x_Integer]:=
	motifIndexFromAbsolutePosition[StrandLength[str,Total->False],x];
motifIndexFromAbsolutePosition[lengths:{_Integer..},x_Integer]:=Module[{ends},
	ends = Accumulate[lengths];
	First[First[Position[ends-x,_?(#>=0&),{1},1]]]
];


(* ::Subsubsection::Closed:: *)
(*motifIndicesFromAbsolutePosition*)


motifIndicesFromAbsolutePosition[str_Strand,x_Integer,y_Integer]:=
	Range[
		motifIndexFromAbsolutePosition[str,x],
		motifIndexFromAbsolutePosition[str,y]
	];
motifIndicesFromAbsolutePosition[lengths:{_Integer..},x_Integer,y_Integer]:=
	Range[
		motifIndexFromAbsolutePosition[lengths,x],
		motifIndexFromAbsolutePosition[lengths,y]
	];


(* ::Subsubsection::Closed:: *)
(*relativeSpanFromAbsoluteSpanAndMotifIndex*)


relativeSpanFromAbsoluteSpanAndMotifIndex[str_Strand,motifIndex_Integer,Span[x_,y_]]:=
	relativeSpanFromAbsoluteSpanAndMotifIndex[StrandLength[str,Total->False],motifIndex,Span[x,y]];
relativeSpanFromAbsoluteSpanAndMotifIndex[lengths:{_Integer..},motifIndex_Integer,Span[x_,y_]]:=Module[{offset},
	offset=Total[lengths[[1;;motifIndex-1]]];
	Span[x-offset,y-offset]
];



(* ::Subsubsection::Closed:: *)
(*relativeSpansFromAbsoluteSpanAndMotifIndex*)


relativeSpansFromAbsoluteSpanAndMotifIndex[str_Strand,motifIndices:{_Integer..},Span[x_,y_]]:=
	relativeSpansFromAbsoluteSpanAndMotifIndex[StrandLength[str,Total->False],motifIndices,Span[x,y]];
relativeSpansFromAbsoluteSpanAndMotifIndex[lengthList:{_Integer..},motifIndices:{_Integer..},bond:Span[x_,y_]]:=Module[{dl,motifRanges},
	dl = Most[Accumulate[Prepend[lengthList,0]]];
	motifRanges = Map[Range,lengthList]+dl;
	Map[rangeToSpan@(Intersection[Range@@bond,motifRanges[[#]]]-dl[[#]])&,motifIndices]
];

rangeToSpan[{n_Integer}]:=Span[n,n];
rangeToSpan[list:{_Integer..}]:=Span[First[list],Last[list]];

Authors[alignStrandBaseBonds]:={"scicomp", "brad"};

alignStrandBaseBonds[Structure[ss:StrandListP,ps_]]:=Module[{newBonds},
	newBonds = Flatten[Map[alignSingleStrandBaseBond[ss,#]&,ps]];
	Structure[ss,newBonds]
];

alignSingleStrandBaseBond[ss_,bond:Bond[{s1_,span1_Span},{s2_,span2_Span}]]:=Module[
	{lengths1,lengths2,ranges1,ranges2,intersectedRanges1,intersectedRanges2,
	dividingPoints,fixed1,fixed2,firstSpans,secondSpans},

	lengths1= StrandLength[ss[[s1]],Total->False];
	lengths2 = StrandLength[ss[[s2]],Total->False];

	ranges1=Map[Range,lengths1]+Most[Accumulate[Prepend[lengths1,0]]];
	ranges2=Reverse[Reverse/@Map[Range,lengths2]+Most[Accumulate[Prepend[lengths2,0]]]];

	intersectedRanges1=Map[Intersection[Range@@span1,#]&,ranges1];
	intersectedRanges2=Reverse/@Map[Intersection[Range@@span2,#]&,ranges2];

	dividingPoints = Union[
		Prepend[Accumulate[Length/@intersectedRanges1],0],
		Prepend[Accumulate[Length/@intersectedRanges2],0]
	];

	fixed1=MapThread[Flatten[intersectedRanges1][[#1;;#2]]&,{Most[dividingPoints]+1,Rest[dividingPoints]}];
	fixed2=MapThread[Flatten[intersectedRanges2][[#1;;#2]]&,{Most[dividingPoints]+1,Rest[dividingPoints]}];

	firstSpans=Map[rangeToSpan,fixed1];
	secondSpans=Map[rangeToSpan,Reverse/@fixed2];

	MapThread[Bond[{s1,#1},{s2,#2}]&,{firstSpans,secondSpans}]

];


alignSingleStrandBaseBond[ss_,bond_Bond]:={bond};


(* ::Subsection::Closed:: *)
(*Structure*)


(* ::Subsubsection::Closed:: *)
(*offsetPairs*)


(* For all Bond-chains: Offsets the Strand that each Bond chain occurs for by some integer argument. *)
offsetPairs[list_,off_] :=
	Replace[list, Bond[{a_,b__},{c_,d__}] :> Bond[{a+off,b},{c+off,d}], {1}];


(* For all Bond-chains Offsets the Strand of the first Bond-chain participant by some number, and the second Bond-chain participant by some second number *)
offsetPairs[list_,off1_,off2_] :=
	Replace[list, Bond[{a_,b__},{c_,d__}] :> Bond[{a+off1,b},{c+off2,d}], {1}];




(* ::Subsubsection::Closed:: *)
(*splitIndices*)


(* Given an adjacency matrix, divides the graph into unconnected segments *)
splitIndices[graph_Graph] :=
	With[{connected = GraphDistanceMatrix[graph]},
		Gather[VertexList[graph], connected[[#1,#2]]<Infinity&]
	];

splitIndices[A_?MatrixQ] := splitIndices[AdjacencyGraph[Simulation`Private`BoolOr[A,Transpose[A]]]];




(* ::Subsubsection::Closed:: *)
(*structureToBonds*)


structureToBonds[Structure[{_Strand...},bonds:{_Bond...}]]:=bonds;
structureToBonds[Structure[{_Strand...}]]:={};


(* ::Subsubsection::Closed:: *)
(*structureToBondsSorted*)


structureToBondsSorted[Structure[{_Strand...},bonds:{_Bond...}]]:=Sort[bonds];
structureToBondsSorted[Structure[{_Strand...}]]:={};


(* ::Subsubsection::Closed:: *)
(*structureToStrands*)


structureToStrands[Structure[strands:{_Strand...},bonds:{_Bond...}]]:=strands;
structureToStrands[Structure[strands:{_Strand...}]]:=strands;


(* ::Subsubsection::Closed:: *)
(*filterPairs*)


(* Selects only those pairs in the Strands listed in "group", and reindexes them according to the order of group *)
filterPairs[pairs:{BondP...}, group:{_Integer..}] :=
	Module[{options,newPairs},
		options = Alternatives@@group;
		newPairs = Cases[pairs, Bond[{options,__},{options,__}]];
		newPairs[[All,All,1]] = List @@@ Replace[ newPairs[[All,All,1]], Thread[group->Range[Length[group]]], {2} ];

		newPairs
	];




(* ::Subsubsection::Closed:: *)
(*structureBondsToStrands*)


(* Need to consolidate first!! *)


structureBondsToStrands[c:Structure[strands_,pairs_]]:=Map[{StructureBondsToStrandsOne[strands,#]}&,pairs];

StructureBondsToStrandsOne[strands_,Bond[{s_,span_Span},_List]]:=With[
	{monomers = monomersFast[strands[[s]]]},
	Strand@@ReplaceRepeated[
		monomers[[span]],
		{first___,f_[x_String],f_[y_String],last___}:>{first,fuseMonomers[f[x],f[y]],last}
	]
];
StructureBondsToStrandsOne[strands_,Bond[{s_,m_,span_Span},_List]]:=Strand[sequenceTakeFast[strands[[s,m]],span]];
StructureBondsToStrandsOne[strands_,Bond[{s_,m_},_List]]:=Strand[strands[[s,m]]];

fuseMonomers[f_[x_String],f_[y_String]]:=f[x<>y];
fuseMonomers[f_[x_Integer],f_[y_Integer]]:=f[x+y];

monomersFast[strand_Strand,ops___]:=Flatten[Map[monomersFast[#,ops]&,List@@strand],1];
monomersFast[(h:(DNA|RNA|PNA))[s_String],ops___]:=Map[h,Characters[s]];
monomersFast[(h:(DNA|RNA|PNA))[s_String,_],ops___]:=Map[h,Characters[s]];
monomersFast[other_,ops___]:=
	Monomers[other,PassOptions[Monomers,ops]];

sequenceTakeFast[(h:(DNA|RNA|PNA))[s_String],span_Span,ops___]:=h[StringTake[s,span]];
sequenceTakeFast[(h:(DNA|RNA|PNA))[s_String,_],span_Span,ops___]:=h[StringTake[s,span]];
sequenceTakeFast[other_,span_Span,ops___]:=
	SequenceTake[other,span,PassOptions[SequenceTake,ops]];



StructureBondsToStrandsBoth[structure_Structure]:=Module[{left,right},
	left = structureBondsToStrands[structure];
	right = structureBondsToStrands[ReplaceAll[structure,Bond[l_,r_]:>Bond[r,l]]];
	{Flatten[left],Flatten[right]}
];


(* ::Subsection:: *)
(*Structure manipulation*)


(* ::Subsubsection:: *)
(*structResolution*)


General::invalidStruct = "Input structure `1` is not valid.";


resolveStruct[struct:StructureP, f_, needed_List, fastTrack:BooleanP]:=
	If[(!fastTrack) && (!StructureQ[struct]),
		(* if FastTrack set to be True and input strand failed StrandQ, throw a message and return $Failed *)
		(Message[f::invalidStruct, struct]; $Failed),
		AssociationThread[needed -> struct[needed]]
	];


resolveStruct[structs_List, f_, needed_List, fastTrack:BooleanP]:= resolveStruct[#, f, needed, fastTrack]&/@structs;


(* ::Subsubsection:: *)
(*StructureQ*)


DefineOptions[StructureQ,
	Options :> {
		{Sequence -> All, All | True | False, "If True every motif must have defined sequences (no numbers), if False every motif must have numbers (no sequences), if All allow both."},
		{CheckMotifs -> False, True | False, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{CheckPairs -> False, True | False, "If set to true, will check to see that each pair references valid idexes in the strands, and check to see that the pairs sequences are reverse complimentary to eachother."},
		{CanonicalPairing -> True, BooleanP, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}];


motifsMatchQ[seqs_, canonicalQ:BooleanP]:= Module[
	{tmpSeqs, namedSeqs, grouped, tmpRes},

	tmpSeqs = If[canonicalQ,
				ToDNA[seqs],
				seqs
			];

	namedSeqs = Cases[tmpSeqs, PolymerP[_, _String]];
	If[MatchQ[namedSeqs, {}], Return[True]];

	(* gather by revcomp names and verify if truely revcomp for the sequences *)
	grouped = Select[GatherBy[DeleteDuplicates[namedSeqs], StringTrim[Last[#], "'"]&], Length[#]>1&];

	(* turn revcomp sequence back to original format *)
	tmpRes = Map[NucleicAcids`Private`resolveRevComp, grouped, {2}];

	And@@(SameSequenceQ/@tmpRes)

];


StructureQ[struct:StructureP, ops:OptionsPattern[]]:= Module[
	{safeOps, reStruct, seqs, flatSeqs, leftBonds, rightBonds},

	safeOps = SafeOptions[StructureQ, ToList[ops]];

	(* turn bonds format into MotifBasePairBonds *)
	reStruct = Quiet[Check[toMotifBasePairBonds[struct], $Failed]];
	If[MatchQ[reStruct], $Failed, Return[False]];

	seqs = reStruct[Motifs];
	flatSeqs = Flatten[seqs];
	leftBonds = First/@reStruct[Bonds];
	rightBonds = Last/@reStruct[Bonds];

	(* check SequenceQ first *)
	If[!And@@SequenceQ[flatSeqs], Return[False]];

	(* if Sequence is on, only take strings, no numbers.  If sequene is off, take only numbers.  If it's all, accept either *)
	If[!TrueQ@Switch[Sequence/.safeOps,
				All, True,
				True, MatchQ[flatSeqs, {PolymerP[_String,___]..}],
				False, MatchQ[flatSeqs, {PolymerP[_Integer,___]..}]
			],
		Return[False]
	];

	(* check bonds format *)
	If[!validStructureBonds[reStruct], Return[False]];

	(* check if named motifs are matching each other *)
	If[(CheckMotifs/.safeOps) && !motifsMatchQ[flatSeqs, CanonicalPairing/.safeOps], Return[False]];

	(* Check the pairs to see if they have matching sequence, if requested *)
	If[CheckPairs/.safeOps,
		And@@ReverseComplementSequenceQ[SequenceTake[seqs[[First[#]]][[#[[2]]]]&/@leftBonds, Last/@leftBonds, FastTrack->True],
				      SequenceTake[seqs[[First[#]]][[#[[2]]]]&/@rightBonds, Last/@rightBonds, FastTrack->True], Degeneracy->True],
		True
	]

];


StructureQ[structs:{StructureP..}, ops:OptionsPattern[]]:= StructureQ[#, ops]&/@structs;


StructureQ[_, ops:OptionsPattern[]]:= False;


(* ::Subsubsection:: *)
(*validStructureBonds*)

Authors[validStructureBonds]:={"scicomp", "brad"};

validStructureBonds[struct:Structure[strands_, NoBondsP]] := True;
validStructureBonds[struct:Structure[strands_, bonds:MotifBondsP]] := Module[
	{out=True},
	Scan[
		If[!validStructureBond[strands,#,Null],
			out=False; Return[False]]&,
			bonds
		];
	And[out, validStructureBondNonOverlapStagger[struct]]
];


validStructureBonds[struct:Structure[strands_, bonds_]] := Module[
	{strandMotifStruct,out=True,motifLengths},
	motifLengths = StrandLength[strands,Total->False];
	Scan[
		If[!validStructureBond[strands,#,motifLengths],
		out=False; Return[False]]&,
		bonds
	];
	And[out, validStructureBondNonOverlapStagger[struct]]
];

(* if strand ind isn't possible *)
validStructureBond[strands_List,Bond[{a_Integer,__},{b_Integer,__}],motifLengths_]:=False/;Or[a>Length[strands],b>Length[strands]];
(* if motif ind isn't possible *)
validStructureBond[strands_List,Bond[{a_Integer,c_Integer,___},{b_Integer,d_Integer,___}],motifLengths_]:=False/;Or[c>Length[strands[[a]]],d>Length[strands[[b]]]];
(* check spans *)
validStructureBond[strands_List,Bond[{a_Integer,Span[c1_,c2_]},{b_Integer,Span[d1_,d2_]}],motifLengths_]:=
	False/;Or[c2>Total[motifLengths[[a]]],d2>Total[motifLengths[[b]]]];
validStructureBond[strands_List,Bond[{a_Integer,c_Integer,Span[e1_,e2_]},{b_Integer,d_Integer,Span[f1_,f2_]}],motifLengths_]:=
	False/;Or[e2>motifLengths[[a,c]],f2>motifLengths[[b,d]]];
(* anything else is fine *)
validStructureBond[___]:=True;


validStructureBondNonOverlapStagger[struct_] := With[
	{temp = Flatten[Map[Thread, reformatBonds[struct, StrandBase][Bonds] /. {Bond -> Sequence, Span -> Range}], 1]},
	If[MatchQ[Length[temp], Length[DeleteDuplicates[temp]]], True, False]
];


(* ::Subsubsection::Closed:: *)
(*validStructurePairedBases*)


validStructurePairedBases[struct_Structure]:=Module[{left,right},
	{left,right} = StructureBondsToStrandsBoth[struct];
	And@@MapThread[SameQ[#1,ReverseComplementSequence[#2]]&,{left,right}]
];


(* ::Subsubsection::Closed:: *)
(*StructureSort*)


StructureSort[c:Structure[{_Strand},NoBondsP]]:=c;

StructureSort[Structure[strands:{_Strand},b:{BondP..}]]:=Structure[strands,Sort[b]];


StructureSort[Structure[strands:StrandListP,b:NoBondsP]]:=Structure[Sort[strands],b];

StructureSort[struct:StructureP] :=With[
	{strands=struct[Strands],bonds=struct[Bonds]},
	Module[{
			indexedStrands,sortedIndexedStrands,oldIndexNewIndexSortedStrands,permRules,reorgBonds,identicalStrandIndices,untangledBonds
		},

		(* indexedStrands will be in the form: {{strand, strandIndexInStructure}..} *)
		indexedStrands=MapIndexed[{#1,First[#2]}&, strands];

		(* Sort the strands in lexicographical order. For instance "ATCG" will come
		 * before "CTAG". *)
		sortedIndexedStrands=SortBy[indexedStrands, First];

		(* oldIndexNewIndexSortedStrands will be in the form:
		 *    {{{strand, originalStrandIndex}, strandIndexInSortedList}..} *)
		oldIndexNewIndexSortedStrands=MapIndexed[{#1,First[#2]}&,sortedIndexedStrands];

		permRules = Map[
			Rule[Last[First[#]],Last[#]]&,
			oldIndexNewIndexSortedStrands
		];

		reorgBonds=MapAt[Replace[#,permRules]&,bonds,{;;,;;,1}];

		(* Compile a list of lists, where each sublist includes the indices of all identical strands of
		 * a certain variety. For instance, if the sorted strand list is {A, B, A, B, C}, then identicalStrandsList
		 * will be {{1,3}, {2,4}}. *)
		identicalStrandIndices=
			Map[

				(* If the identicalStrandGroup has multiple members, get the index of each member in the sorted
				 * strands list. For example, if identicalStrandGroup is 3 copies of strand A, and those strands
				 * occupy indices 2, 3, and 4 in the sorted strands list, then this function will return {2, 3, 4}. *)
				Function[identicalStrandGroup,
					If[Length[identicalStrandGroup]>1,
						Last/@identicalStrandGroup,
						Nothing
					]
				],

				(* Group identical strands together into sublists.
				 * Example: 'strands' is {A, B, A, B, C}. After this call, we get {{A, A}, {B, B}, C} *)
				GatherBy[
					oldIndexNewIndexSortedStrands,
					First[First[#]]&
				]
			];

		(* 'untangledBonds' is the version of reorgBonds that satisfies a 'standard format' based
		 * on rearranging identical strands and their indices. *)
		untangledBonds=identicalStrandBondsToCoreForm[reorgBonds,identicalStrandIndices];

		(*  *)
		Structure[First/@sortedIndexedStrands,untangledBonds]
]];


(* ::Subsubsection::Closed:: *)
(*identicalStrandBondsToCoreForm*)


(* Function: identicalStrandBondsToCoreForm
 * -----------------------------------
 * Converts a set of bonds to a "standard format". In more precise terms,
 * this function tries all permutations for strand indices of Bonds where
 * at least one strand involved in the bond has a twin in the structure.
 *)
identicalStrandBondsToCoreForm[bonds_,identicalStrandIndices_]:=
	Module[{cycs,bondCasesList},

		(* Create a list of all unique possible Cycles that would switch indices of identical strands
		 * in the sorted strand list. For example, if the sorted strand list was {A, B, A, A}, cycs would
		 * be {Cycles[{{1,3,4}}], Cycles[{{1,4,3}}], Cycles[{{3,4}}], Cycles[{{1,3}}], Cycles[{{1,4}}], Cycles[{{}}]}.
		 * If B also had a twin at index 5, then we would also get the Cycles: Cycles[{{2,5}}], Cycles[{{1,3,4},{2,5}}],
		 * Cycles[{{1,4,3},{2,5}}], Cycles[{{3,4},{2,5}}], Cycles[{{1,3},{2,5}}], and Cycles[{{1,4},{2,5}}]. *)
		cycs=
			GroupElements[
				PermutationGroup[

					(* Create a Cycle for each group of identical Strands. For example: If the original
					 * sorted strands list was {A, B, A, B, A, C}, the result of this call will be
					 * {Cycles[{{1,3,5}}], Cycles[{{2,4}}]} *)
					Map[
						Function[indicesOfGroupOfIdenticalStrands,
							Cycles[{indicesOfGroupOfIdenticalStrands}]
						],
						identicalStrandIndices
					]
				]
			];

		(* Create a list where each member is what the Bond list would be if a particular identical strand Cycle was used
		 * to shift around groups of identical strands in the sorted strand list. Each resulting Bond list in bondCasesList
		 * will be effectively compared against the other Bond lists when bondCasesList is Sorted - the one that ranks first
		 * after the Sort is the "standard format" for rearranging the identical strands. *)
		bondCasesList=
			Map[
				Function[cyc,

					(* Replace the strand index of each bond with its strand's new index in the
					 * sorted strand list governed by the Cycle 'cyc'. Mapping at level 2 bypasses the Bond[] wrapper and
					 * acts directly on the two Lists that form each side of a Bond. *)
					Map[
						Function[bond,
							{
								PermutationReplace[First[bond], cyc],
								Sequence@@Rest[bond]
							}
						],
						bonds,
						{2}
					]
				],
				cycs
			];

		(* Sort each Bond list and each Bond in each Bond list.
		 * Sort the resulting list of Bond lists.
		 * The Bond list that ranks first is the "standard format" for the set of identical strands and their associated bonds
		 * that we were given. Return that Bond list as the official sorted Bond list for this structure *)
		First[
			Sort[
				Map[
					Function[bondCase,
						Sort[Sort/@bondCase]
					],
					bondCasesList
				]
			]
		]
	];




(* ::Subsubsection::Closed:: *)
(*randomizeStructure*)


(* Helpful for debugging StructureSort *)
randomizeStructure[c:Structure[strands:{_Strand..}, pairs:{BondP...}]] :=
	Module[{idx, rev},
		idx = RandomSample[Range[Length[strands]]];
		rev = InversePermutation[idx];

		Structure[
			strands[[idx]],
			Sort[
				pairs /. {str_Integer, part_Integer} :> {rev[[str]], part}
			]
		]
	];



(* ::Subsubsection::Closed:: *)
(*StructureJoin*)


(* add strands from two structures into the same Structure, without adding any new pairings *)
StructureJoin[comp:StructureP]:=comp;
StructureJoin[comp1:StructureP,comp2:StructureP]:= With[
	{strs1=comp1[Strands],strs2=comp2[Strands],pairs1=comp1[Bonds],pairs2=comp2[Bonds]},
	Structure[
		Join[strs1,strs2],
		Join[pairs1,offsetPairs[pairs2,Length[strs1]]]
	]	];
StructureJoin[comp1:StructureP,comp2:StructureP,rest__Structure]:=
	Fold[StructureJoin[#1,#2]&,comp1,{comp2,rest}];


(* ::Subsubsection::Closed:: *)
(*StructureTake*)


StructureTake[com_Structure,{a_Integer,b:Span[_Integer,_Integer]}]:= StrandTake[com[[1,a]],b];
StructureTake[com_Structure,a_Integer,b_Integer]:= ParseStrand[com[[1,a]]][[b,3]];
StructureTake[com_Structure,{a_Integer,b_Integer}]:= ParseStrand[com[[1,a]]][[b,3]];
StructureTake[com_Structure,{a_Integer,b:{Span[_Integer,_Integer]..}}]:= Table[StrandTake[com[[1,a]],bb],{bb,b}];
StructureTake[com_Structure,{a_Integer,b_Integer,c:Span[_Integer,_Integer]}]:= StrandTake[com[[1,a]],{b,c}];
StructureTake[com_Structure,{a_Integer,b_Integer,c:{Span[_Integer,_Integer]..}}]:= Table[StrandTake[com[[1,a]],{b,cc}],{cc,c}];


(* ::Subsubsection::Closed:: *)
(*findMotifIndex*)


(*Given a strand and interval, find the motif index corresponding to the motif on that interval*)
findMotifIndex[str_Strand,{a_Integer,b_Integer}]:=Module[{lengths,lengthsAcc,ind1,ind2,interval},
lengths=SequenceLength/@ParseStrand[str][[;;,3]];
lengthsAcc=Accumulate[lengths];
ind1=Range[Length[str]][[First[Flatten[Position[(#>=a)&/@lengthsAcc,True]]]]];
ind2=Range[Length[str]][[First[Flatten[Position[(#>=b)&/@lengthsAcc,True]]]]];
interval={a,b}-Prepend[lengthsAcc,0][[ind1]];
{ind1,interval}
];


(* ::Subsubsection::Closed:: *)
(*motifSplit*)


(* Given a pair span, split a motif into up to 3 motifs such that the paired stretch is its own motif *)
motifSplit[mot:MotifP,span_Span]:=With[{l=SequenceLength[mot]},
	Switch[span,
		1;;l,{"Whole",SequenceTake[mot,{1;;l}]},
		1;;_Integer,{"Start",SequenceTake[mot,{span,Last[span]+1;;l}]},
		_Integer;;l,{"End",SequenceTake[mot,{1;;First[span]-1,span}]},
		_Integer;;_Integer,{"Middle",SequenceTake[mot,{1;;First[span]-1,span,Last[span]+1;;l}]},
		True,{Null,Message[Generic::Generic,"Bad span.  Should not be able to reach this message."]}
	]
];


(* ::Subsubsection::Closed:: *)
(*strandSplit*)


(*  *)
strandSplit[str:StrandP,pp:{a_Integer,b_Span}]:=Module[{typeOfSplit,newMotifs,offset,diff,newStrand,newPair},
	{typeOfSplit,newMotifs}=motifSplit[str[[a]],b];
	offset=Switch[typeOfSplit,
		"Whole",0,
		"Start",0,
		"End",1,
		"Middle",1
	];
(*	diff=((List@@b).{-1,1});*)
	diff=If[True,((List@@b).{-1,1}),b[[2]]-1];
	{
		ReplacePart[str,a->Sequence@@newMotifs],
		{a+offset,1;;(diff+1)},
		typeOfSplit,
		diff
	}
];


(* ::Subsubsection::Closed:: *)
(*structureSplitHelper*)


structureSplitHelper[com:StructureP,n_Integer]:=structureSplitHelper[structureSplitHelper[com,n,1],n,2];
structureSplitHelper[Structure[strs:{StrandP..},prs:{MotifBaseBondP..}],n_Integer,m_Integer]:=Module[
	{pp,newStr,spanDiff,newStrs,newPairs,newPair,typeOfSplit},
	pp=List@@prs[[n,m]];
	{newStr,newPair,typeOfSplit,spanDiff}=strandSplit[strs[[pp[[1]]]],Rest[pp]];
	If[False,Print[{newStr,newPair,typeOfSplit,spanDiff}]];
	newStrs=ReplacePart[strs,{{pp[[1]]}->newStr}];
	newPairs=ReplaceAll[prs,{
		pp->Prepend[newPair,pp[[1]]],
		{pp[[1]],v_,c_Span}:>updatePair[typeOfSplit,{pp[[1]],v,c},pp[[2]],pp[[3]],spanDiff]
	}];
	Structure[newStrs,newPairs]
];


(* If the motif was before the one that was split, do nothing *)
updatePair[_String,{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:={a,b,Span[c1,c2]}/;b<motifIndex;

(* If pair was already entire motif, do nothing *)
updatePair["Whole",{a_,b_,c_},___]:={a,b,c};

(* if pair was at beginning of motif,  *)
updatePair["Start",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b,Span[c1,c2]})/;c1<d1;
updatePair["Start",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1-(d2-d1)-1,c2-(d2-d1)-1]})/;c1>=d1;
(*updatePair["Start",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=(Print[{Span[c1,c2],Span[d1,d2],Null}];{a,b+1,Span[c1-(d2-d1)-1,c2-(d2-d1)-1]});*)
updatePair["Start",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1,c2]});

(* if pair was at end of motif,  *)
updatePair["End",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b,Span[c1,c2]})/;And[c1<d1];
updatePair["End",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1,c2]})/;And[c1<d1];
updatePair["End",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b,Span[c1,c2]})/;And[b>=(motifIndex-1),c1<d1];
updatePair["End",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1,c2]})/;And[b>=(motifIndex-1),c1>=d1];
updatePair["End",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1,c2]})/;And[c1<d1];
updatePair["End",{a_,b_,Span[c1_,c2_]},motifIndex_,Span[d1_,d2_],spanDiff_]:=({a,b+2,Span[c1,c2]})/;And[c1>=d1];

(* if pair was in middle of motif, update things to the right of it *)
(*updatePair["Middle",{a_,b_,c_},b_,span_,spanDiff_]:={a,b+1,Span@@(List@@c-(spanDiff+1))};  (*  *)*)
(*updatePair["Middle",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b+1,Span[c1,c2]})/;c1<d1;*)
updatePair["Middle",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b+0,Span[c1,c2]})/;c1<d1;
updatePair["Middle",{a_,b_,Span[c1_,c2_]},b_,Span[d1_,d2_],spanDiff_]:=({a,b+2,Span[c1-d2,c2-d2](*Span[1,c2-c1+1]*)})/;c1>=d1;
updatePair["Middle",{a_,b_,c_},motifIndex_,span_,spanDiff_]:=({a,b+2,c});  (*  *)


(* ::Subsubsection:: *)
(*reformatMotifs*)


reformatMotifs[c:Structure[strs:{StrandP..},{}]]:=c;
reformatMotifs[c:Structure[strs:{StrandP..},prs:{MotifBaseBondP..}]]:=
	Fold[
		structureSplitHelper[#1,#2]&,
		adjustMotifPairs[c],
		Range[Length[prs]]
	]/.{Bond[{a1_,b1_,_Span},{a2_,b2_,_Span}]:>Bond[{a1,b1},{a2,b2}]};
reformatMotifs[c:StructureP]:=c;


(* ::Subsubsection::Closed:: *)
(*adjustMotifPairs*)


(* fix case where span indices are over strand and not over motif (offset motif index and span positions) *)
adjustMotifPairs[c:Structure[strs:{StrandP..},{}]]:=c;
adjustMotifPairs[c:Structure[strs:{StrandP..},prs:{_Bond..}]]:=
	Module[{newPairs},
		newPairs = Map[Bond[adjustMotifPair[c,#[[1]]],adjustMotifPair[c,#[[2]]]]&, prs];
		Structure[strs,newPairs]
	];
adjustMotifPair[c:Structure[strs:{StrandP..},prs:{_Bond..}],pr:{strInd_,motifInd_}]:=pr;
adjustMotifPair[c:Structure[strs:{StrandP..},prs:{_Bond..}],pr:{strInd_,motifInd_,Span[x1_,x2_]}]:=
	Module[{lengths,realInd},
		If[x2<=SequenceLength[strs[[strInd,motifInd]]],
			pr,
			lengths=Accumulate[StrandLength[strs[[strInd]],Total->False]];
			realInd=First[Flatten[Position[lengths,_?(#>=x2&),{1}]]];
			{strInd,realInd,Span[x1-lengths[[realInd-1]],x2-lengths[[realInd-1]]]}
		]
	];


(* ::Subsubsection::Closed:: *)
(*validMotifsQ*)

Authors[validMotifsQ]:={"scicomp", "brad"};

validMotifsQ[c:Structure[st:{_Strand..},pp:{_Bond...}]]:=And@@Table[
	ReverseComplementSequenceQ[StructureTake[c,p[[1]]],StructureTake[c,p[[2]]]],
	{p,pp}];


(* ::Subsubsection:: *)
(*NumberOfBonds*)


SetAttributes[NumberOfBonds,Listable];
NumberOfBonds[struct:StructureP]:=
	Module[{formattedStruct,bonds,count},

		(* Convert the bonds in 'struct' to StrandSpan form. *)
		formattedStruct=toStrandBasePairBonds[struct];

		(* Extract the bonds from the structure. *)
		bonds=formattedStruct[Bonds];

		(* Converts the first and last base indices for each helix (run of bonds) in to the number
		 * of individual hydrogen bonds involved in that helix. For instance, if there is a helix
		 * that goes from base index 5 to 8, then that helix is 8-5+1=4 hydrogen bonds long.
		 * Then, totals the number of hydrogen bonds. *)
		count=
			Total[
				ReplaceAll[
					bonds,
					Bond[{str1_, span1:Span[x_,y_]}, {str2_, span2_}]:>(y-x+1)
				]
			];

		(* Return the number of hydrogen bonds in 'struct'. *)
		count
	];


(* ::Subsubsection:: *)
(*structureToGraph*)


structureToGraph[struct0_]:=
	Module[{struct,strPieces,sequences,strs,strandOffsets,ll,motifConnections,pairing,seqs,seq,offsets,ends,nopairs,
			arrowpairs,covalent,allcovalent,labelpairs,covalentpairs,hydrogenpairs,motifpairs,nodes,edges,edgeGroupings,edgeWeightRules, g},

		struct = reformatBonds[struct0,StrandMotifBase];

		strPieces=ParseStrand/@struct[[1]];

		sequences=ReplaceAll[strPieces,{{_,_,seq_String,pol_}:>Monomers[seq,Polymer->pol],{_,_,n_Integer,pol_}:>Table["N",{n}]}];

		strs=struct[[1]];

		strandOffsets=
			MapIndexed[
				Rule[ToString[First[#2]],#1]&,
				Join[
					{0},
					Most[
						Accumulate[
							Table[
								Total[Length/@sequences[[s]]],
								{s,1,Length[strs]}
							]
						]
					]
				]
			];

		(* get connections between motifs in a strand *)
		motifConnections=
			Table[
				ll=Accumulate[Length/@sequences[[s]]];
				Table[
					{ll[[i-1]],ll[[i-1]]+1}+ToString[s],
					{i,2,Length[ll]}
				],
				{s,1,Length[strs]}
			];

		motifConnections=
			Map[
				Sort,
				Flatten[motifConnections,1]/.strandOffsets
			];

		pairing=
			DeleteDuplicates[
				Map[
					Sort,
					getGraphEdgesFromStructureName[struct,sequences]
				]
			];

		seqs = Join @@ sequences;

		seq = Join@@seqs;

		offsets=
			Join[
				{0},
				Most[Accumulate[Length /@ seqs]]
			];


		ends=Accumulate[Length /@ seqs];

		nopairs=
			Complement[
				Partition[Range[Length[seq]+1],2,1],
				Join[
					motifConnections,
					Flatten[
						Map[
							Partition[#,2,1]&,
							Range@@@Transpose[{1+Most@Prepend[ends,0],ends}]
						],
						1
					]
				]
			];

		arrowpairs=
			Complement[
				Select[
					Table[List[ee-1,ee],{ee,ends}],
					(#[[1]] > 0)&
				],
				nopairs,
				motifConnections-1
			];

		(* covalent edges *)
		covalent =
			Table[
				Plus[
					{
						Range[2, Length[seqs[[i]]] - 1],
						Range[3, Length[seqs[[i]]]]
					},
					offsets[[i]]
				],
				{i, 1, Length[seqs]}
			];

		covalent = Flatten[Transpose /@ covalent, 1];

		allcovalent = Complement[covalent,arrowpairs];

		labelpairs =
			Complement[
				Join[
					If[Length[seq]>1,
						{{1,2}},
						{}
					],
					Table[
						List[ee+1,ee+2],
						{ee,Most[ends]}
					]
				],
				nopairs
			];

		covalentpairs=Complement[allcovalent,pairing,motifConnections];

		hydrogenpairs = pairing;

		motifpairs=Complement[motifConnections,labelpairs];

		nodes = Range[Length[Flatten[sequences]]];

		edges=
			Sort[
				UndirectedEdge@@@DeleteDuplicates[
					Join[covalentpairs,hydrogenpairs,motifpairs,labelpairs,arrowpairs]
				]
			];

		(* this is not exactly correct.  Should have unfiltered lists here, allowing edges to have multiple properties *)

		edgeGroupings = {"Arrow"->arrowpairs, "Covalent"->allcovalent, "Hydrogen"->hydrogenpairs, "Motif"->motifpairs, "Label"->labelpairs};

		(*
			Put 'EdgeProperties' head on the list b/c edge weights cannot be lists
		*)

		edgeWeightRules=
			Map[
				UndirectedEdge@@#[[1,1]]->EdgeProperties@@#[[;;,2]]&,
				GatherBy[
					Map[
						Reverse,
						Flatten[Thread/@edgeGroupings]
					],
					First
				]
			];

		g=
			Graph[
				nodes,
				edges,
				EdgeWeight->ReplaceAll[edges,edgeWeightRules]
			];

		(* Return the graph. *)
		g
];




(* ::Subsubsection::Closed:: *)
(*getGraphEdgesFromStructureName (and other helpers)*)


getGraphEdgesFromStructureName[name:Structure[strs:{_Strand..},pp:{_Bond...}],seqChars_]:=
	Module[{sym,pairs,edges,offsetsStrand,offsetsMotif},

		offsetsStrand=
			Prepend[
				Most[
					Accumulate[
						Total/@Map[Length,seqChars,{2}]
					]
				],
				0
			];

		offsetsMotif=
			Table[
				Prepend[
					Most[
						Accumulate[Length/@seqChars[[s]]]
					],
					0
				],
				{s,1,Length[strs]}
			];

		pairs=
			Table[
				{
					Plus[
						Part[offsetsMotif,
							p[[1,1]], p[[1,2]]
						],
						Part[offsetsStrand,
							p[[1,1]]
						],
						List@@p[[1,3]]
					],
					Plus[
						Part[offsetsMotif,
							p[[2,1]], p[[2,2]]
						],
						Part[offsetsStrand,
							p[[2,1]]
						],
						List@@p[[2,3]]
					]
				},
				{p,pp}
			];

		getGraphEdgesFromPairsList[pairs]
	];


getGraphEdgesFromPairsList[li_]:=
	Transpose[
		{
			Join@@Map[
				intervalToRange,
				li[[;;,1]]
			],
			Join@@Map[
				Reverse[intervalToRange[#]]&,
				li[[;;, 2]]
			]
		}
	];


getGraphEdgesFromIntervalsList[list_]:=getGraphEdgesFromIntervalsList[list,0];

getGraphEdgesFromIntervalsList[list_,offset_Integer]:=
	Module[{first,second},

		{first,second}=
			Join@@@Transpose[
				Map[
					{Join@@#[[1]], Join@@#[[2]]}&,
					list /. {{a_Integer,b_Integer}:>If[a<=b,Range[a,b],Reverse[Range[b,a]]]}
				]
			];

		SortBy[
			Transpose[{first,Reverse[second]+offset}],
			First
		]
	];


intervalToRange[pos:(Span|List)[_Integer,_Integer]]:=Range[First[pos],Last[pos]];

intervalsToRange[poss:{(Span|List)[_Integer,_Integer]...}]:=Join@@(intervalToRange/@poss);


(* ::Subsubsection::Closed:: *)
(*SplitStructure*)


(*
 * Function: SplitStructure
 * -----------------
 * Splits unpaired strands into separate, 'minimal' structures. So a structure with strand1 paired to strand2 but
 * nothing paired to strand3 will become 2 structures: one with strand1 and strand2 and one with just strand3.
 *
 * Implementation:
 *  - Get a list of 'groups', which are groups of indices of strands involved in minimal structures.
 *  - Make a structure from each group of strands and their existing bonds.
 *  - Convert each of these 'minimal structures' into a standard structure format.
 *  - Sort the final list of formatted, minimal structures and return the resulting list.
 *)
SplitStructure[com:StructureP] :=

	(* Extract the strands and bonds from a structure. *)
	With[{strands=com[Strands], bonds=com[Bonds]},

		With[
			{

				(* Each group is a list of indexes of strands involved in a sub-structure. *)
				groups=
					splitIndices[
						SparseArray[
							Thread[List@@@bonds[[All,All,1]]->1],
							Length[strands]*{1,1}
						]
					]
			},

			(* Sort the structures resulting from the Map call below.
			 * Each structure will correspond to one group from 'groups' above. *)
			Sort[

				(* Each group is a list of indexes of strands involved in the sub-structure.
				 * This function creates a structure with the corresponding strands and only
				 * bonds that occur between those strands *)
				Function[group,

					(* Use StructureSort to convert the structure to a standard form *)
					StructureSort[
						Structure[

							(* Pick out the strands with indices dictated by group *)
							strands[[group]],

							(* Leave only those bonds that occur between strands whose indices are in group *)
							filterPairs[bonds, group]
						]
					]
				] /@ groups
			]
		]
	];





(* ::Subsection::Closed:: *)
(*SubValues*)


(* ::Subsubsection:: *)
(*SubValues*)


OnLoad[
	Unprotect[Structure];

	Structure /: Keys[Structure] := {Strands,Bonds,Motifs,Sequences,Polymers,Names,Graph};
	Structure /: Keys[_Structure] := Keys[Structure];

	(structure_Structure)["Strands"|Strands]:=structureToStrands[structure];
	Strands/:(structures:{_Structure..})[x:Strands]:=Map[#[x]&,structures];

	(structure_Structure)["Bonds"|Bonds]:=structureToBonds[structure];
	Bonds/:(structures:{_Structure..})[x:Bonds]:=Map[#[x]&,structures];

	(structure_Structure)["Motifs"|Motifs]:=Map[#[Motifs]&,structureToStrands[structure]];
	Motifs/:(structures:{_Structure..})[x:Motifs]:=Map[#[x]&,structures];

	(structure_Structure)["Sequences"|Sequences]:=Map[#[Sequences]&,structureToStrands[structure]];
	Sequences/:(structures:{_Structure..})[x:Sequences]:=Map[#[x]&,structures];

	(structure_Structure)["Polymers"|Polymers]:=Map[#[Polymers]&,structureToStrands[structure]];
	Polymers/:(structures:{_Structure..})[x:Polymers]:=Map[#[x]&,structures];

	Unprotect[Graph];
	(structure_Structure)["Polymers"|Graph]:=Map[#[Graph]&,structureToGraph[structure]];
	Graph/:(structures:{_Structure..})[x:Graph]:=Map[#[x]&,structures];

	Unprotect[Names];
	(structure_Structure)["Names"|Names]:=Map[#[Names]&,structureToStrands[structure]];
	Names/:(structures:{_Structure..})[x:Names]:=Map[#[x]&,structures];

	(* dereference list of fields *)
	With[
		{structFieldP = Alternatives@@Keys[Structure]},
		(structure_Structure)[vals:{structFieldP..}]:=Map[structure,vals]
	];

	Protect[Graph];
	Protect[Names];

];