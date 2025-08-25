(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Converting between types*)


(* ::Subsubsection:: *)
(*SpeciesList*)


DefineOptions[SpeciesList,
	Options :> {
		{Sort -> True, True | False, "If True, sorts the output."},
		{Structures -> False, True | False, "If True, reformat any sequences or strands into structures."},
		{Attributes -> All, All | StrictlyIncreasing | StrictlyDecreasing | Complex, "Return only the species that satisfy Attributes."}
	}];


SpeciesList::BadFormat="Bad input format: `1`";

SpeciesList[in1:Except[_Rule],in2:Except[_Rule],OptionsPattern[]]:=Module[{allSpecs,uniqueSpecs,allSpecsStructures},

(*	allSpecs = Fold[Join[#1,speciesListUnsorted[#2]]&,speciesListUnsorted[First[{in}]],Rest[{in}]];*)
	allSpecs = Join[speciesListUnsorted[in1],speciesListUnsorted[in2]];
	allSpecsStructures = If[OptionDefault[OptionValue[Structures]],
		Replace[allSpecs,s:(_?SequenceQ|StrandP):>ToStructure[s],{1}],
		allSpecs
	];
	uniqueSpecs = DeleteDuplicates[sortAndReformatStructures[allSpecsStructures]];

	If[OptionDefault[OptionValue[Sort]],
		Sort[uniqueSpecs],
		uniqueSpecs
	]

]/;MatchQ[OptionValue[Attributes],All];

SpeciesList[in:Except[_Rule],OptionsPattern[]]:=Module[{allSpecs,allSpecsStructures},
	allSpecs = sortAndReformatStructures[speciesListUnsorted[in]];
	allSpecsStructures = If[OptionDefault[OptionValue[Structures]],
		Replace[allSpecs,s:(_?SequenceQ|StrandP):>ToStructure[s],{1}],
		allSpecs
	];
	If[OptionDefault[OptionValue[Sort]],
		Sort[allSpecsStructures],
		allSpecsStructures
	]
]/;MatchQ[OptionValue[Attributes],All];

speciesListUnsorted[eqns:ListableP[KineticsEquationP]]:=kineticsEquationsToSpecies[eqns];
speciesListUnsorted[tr:TrajectoryFormatP]:=trajectoryToSpecies[tr];
speciesListUnsorted[mech:MechanismFormatP]:=mechanismToSpecies[mech];
speciesListUnsorted[rxs:reactionsFormatP]:=reactionsToSpecies[rxs];
speciesListUnsorted[reacs:ImplicitReactionsFormatP]:=implicitReactionsToSpecies[reacs];
speciesListUnsorted[reacs:implicitReactionFormatP]:=implicitReactionsToSpecies[{reacs}];
speciesListUnsorted[st:StateFormatP]:=stateToSpecies[st];
speciesListUnsorted[mech:ObjectP[Model[ReactionMechanism]]]:=speciesListUnsorted[mech[ReactionMechanism]];
speciesListUnsorted[mech:ObjectP[Object[Simulation,ReactionMechanism]]]:=speciesListUnsorted[mech[ReactionMechanism]];
speciesListUnsorted[st:RuleListFormatP]:=rulesToSpecies[st];
speciesListUnsorted[st:pairedListFormatP]:=pairedToSpecies[st];
speciesListUnsorted[sl:{ReactionSpeciesP...}]:=DeleteDuplicates[sl];
speciesListUnsorted[interactions:interactionsFormatP]:=interactionToSpecies[interactions];
speciesListUnsorted[{_SparseArray,_SparseArray,{_?NumericQ...} | {_?QuantityQ...},specs_List}]:=specs;
speciesListUnsorted[{_SparseArray,_SparseArray,{{_Integer...},{_Integer...}},specs_List}]:=specs;
speciesListUnsorted[in:{interactionsFormatP...}]:=speciesListUnsorted[Flatten[in,1]];
speciesListUnsorted[in:{NumberP...}]:={};

speciesListUnsorted[in:{(ReactionSpeciesP|_Times|_Plus)...}]:=DeleteDuplicates[Cases[Flatten[in/.{Rule->List,Equilibrium->List,Times->List,Plus->List}],ReactionSpeciesP]];

speciesListUnsorted[other_]:=(Message[SpeciesList::BadFormat,other]);

kineticsEquationsTimeSymbol[eqns_] := FirstCase[eqns, Equal[Derivative[1][_Symbol][t_Symbol], _] :> t, Null, {1}];
kineticsEquationsToSpecies[eqns_]:= Module[{timeSymbol},
	timeSymbol = kineticsEquationsTimeSymbol[eqns];
	symbols = Cases[eqns, h_[timeSymbol] :> h, Infinity] /. Derivative[_][s_] :> s;
	DeleteCases[DeleteDuplicates[symbols],timeSymbol]
];



(* strictly increasing *)
SpeciesList[in_,OptionsPattern[]]:=strictlyIncreasingSpecies[in]/;OptionValue[Attributes]===StrictlyIncreasing;
strictlyIncreasingSpecies[reactions_] :=
    Module[ {R,species},
        R = generateReactantMatrix[reactions];
        species = SpeciesList[reactions,Attributes->All];
        species[[Flatten[Position[Total[Transpose[R]],0]]]]
    ];

(* strictly decreasing *)
SpeciesList[in_,OptionsPattern[]]:=strictlyDecreasingSpecies[in]/;OptionValue[Attributes]===StrictlyDecreasing;
strictlyDecreasingSpecies[reactions_] :=
    Module[ {P,species},
        P = generateProductMatrix[reactions];
        species = SpeciesList[reactions,Attributes->All];
        species[[Flatten[Position[Total[Transpose[P]],0]]]]
    ];

SpeciesList[reactionsGraph_Graph,OptionsPattern[]] :=    VertexList[reactionsGraph]/;OptionValue[Attributes]===Complex;
SpeciesList[reactions:{(_Rule|_Equilibrium)..},OptionsPattern[]] :=
    Union[
    Cases[reactions,Rule[a_,b_]->Sequence@@{a,b}],
    Cases[reactions,Equilibrium[a_,b_]->Sequence@@{a,b}]
    ]/;OptionValue[Attributes]===Complex;




(* ::Subsubsection::Closed:: *)
(*structureList*)


structureList[reactionsGraph_Graph] :=
    VertexList[reactionsGraph];
structureList[reactions:{(_Rule|_Equilibrium)..}] :=
    Union[
    Cases[reactions,Rule[a_,b_]->Sequence@@{a,b}],
    Cases[reactions,Equilibrium[a_,b_]->Sequence@@{a,b}]
    ];


(* ::Subsubsection:: *)
(*ToStrand*)


DefineOptions[ToStrand,
	Options :> {
		{Polymer -> Automatic, _Symbol | {_Symbol..}, "Specify polymer type of sequence.  If Automatic, polymer will be determined from sequence."},
		{Motif -> "", _String | {_String..}, "A label to give the strand if you are creating it from a sequence."},
		{Replace -> False, True | False, "If True, replace paired strand bases with \"X\" character that cannot be paired."},
		{Map -> False, True | False, "If True, map over input list instead of treating as multiple motifs for single strand."},
		{FastTrack -> False, BooleanP, "Skip Strict checks.", Category->Hidden}
	}
];


(* Map option *)
ToStrand[seqs:{(_String|_Integer)..},ops:OptionsPattern[ToStrand]]:=Map[ToStrand[#,ops]&,seqs]/;TrueQ[OptionValue[Map]];

(* super listable *)
ToStrand[seqs:{{(_String|_Integer)..}..},ops:OptionsPattern[ToStrand]]:=Module[{pols,labels,strandPieces},
	(* set up polymer list *)

	If[And[!OptionValue[FastTrack],MemberQ[SequenceQ[Cases[Flatten[seqs],_String]],False]],
		Return[{Message[ToStrand::InvalidSequence,Select[Cases[Flatten[seqs],_String],!SequenceQ[#]&]]}]
	];

	pols=ExpandDimensions[seqs,OptionValue[Polymer]];

	(* set up label list *)
	labels=ExpandDimensions[seqs,OptionValue[Motif]]/.{""->Null};

	(* make labels unique *)
	labels=Fold[ReplacePart[#1,Thread[Rule[Position[#1,#2[[1]]],Table[#2[[1]]<>ToString[ix],{ix,1,#2[[2]]}]]]]&,labels,Select[Tally[Flatten@labels],And[#[[1]]=!=Null,#[[2]]>1]&]];

	(* make the strands *)
	strandPieces = MapThread[toStrandFromSequence[#1,#2,#3,OptionValue[FastTrack]]&,{seqs,pols,labels}];

	(* any non-sequences come out as Null.  Exit if we see any *)
	If[MemberQ[strandPieces,Null,{2}], Return[{Null}]];

	StrandJoin@@@strandPieces
];


(* listable *)
ToStrand[seqs:{(_String|_Integer)..},ops:OptionsPattern[ToStrand]]:=
	First[ToStrand[{seqs},Polymer->{OptionValue[Polymer]},Motif->{OptionValue[Motif]},FastTrack->OptionValue[FastTrack]]];

(* single input *)
ToStrand[seq:(_String|_Integer),ops:OptionsPattern[ToStrand]]:=
	ToStrand[{seq},Polymer->{OptionValue[Polymer]},Motif->{OptionValue[Motif]},FastTrack->OptionValue[FastTrack]];

(* core internal function *)
toStrandFromSequence[seq_Integer,pol:PolymerP,label_,fastTrack_]:=
	If[MatchQ[label,""|Null],Strand[pol[seq]],Strand[pol[seq,label]]];
toStrandFromSequence[seq_Integer,Null|Automatic,label_,fastTrack_]:=
	Message[ToStrand::InvalidSequence,seq];
toStrandFromSequence[seq_String,pol0_,label_,fastTrack_]:=Module[{pol},
	pol=Which[
		MatchQ[seq,_Integer],
			pol0,
		And[fastTrack===True,pol0=!=Null],
			pol0,
		pol0===Automatic,
			Scan[If[TrueQ[SequenceQ[seq,Polymer->#]],Return[#]]&,AllPolymersP],
		MatchQ[pol0,PolymerP],
			If[And[!fastTrack,SequenceQ[seq,Polymer->pol0]], (* make sure specified polymer is correct *)
					pol0,
					Return[toStrandFromSequence[seq,Automatic,label,fastTrack]]],
		True, Return[Message[Generic::BadOptionValue,pol0,Polymer]]
	];
	If[pol===Null,Return[Message[ToStrand::InvalidSequence,seq]]];
	If[MatchQ[label,""|Null],Strand[pol[seq]],Strand[pol[seq,label]]]
];
SetAttributes[toStrandFromSequence,Listable];


(* from motifs *)
ToStrand[(head:PolymerP)[seq:(_String|_Integer),label_String],ops:OptionsPattern[]]:=ToStrand[seq,Polymer->head,Motif->label,ops];
ToStrand[(head:PolymerP)[seq:(_String|_Integer)],ops:OptionsPattern[]]:=ToStrand[seq,Polymer->head,ops];


(* from structures *)
ToStrand[struct:StructureP,ops:OptionsPattern[ToStrand]]:=Module[{},
	If[And[!OptionValue[FastTrack],!StructureQ[struct,PassOptions[ToStrand,StructureQ,ops]]],
		Return[Message[ToStrand::InvalidStructure,struct]]
	];
	Switch[OptionValue[Replace],
		False,	First[struct],
		True,	structureToStrandsX[reformatBonds[struct,StrandMotifBase]],
		_,	Message[Generic::BadOptionValue,OptionValue[Replace],Replace]
	]
];
(* listable *)
ToStrand[list_List,ops:OptionsPattern[ToStrand]]:= ToStrand[#,ops]&/@list;


(* no bonds, do nothing *)
structureToStrandsX[Structure[str:{_Strand..}]]:=str;
structureToStrandsX[Structure[str:{_Strand..},{}]]:=str;
(* turn a structure into a list of strands whose paired bases have been replaced by the character X *)
structureToStrandsX[Structure[str:{_Strand..},prs:{BondP..}]]:=Module[{flatPairs},
	(* replace Bond heads with List heads, and flatten b/c don't need them grouped *)
	flatPairs=Flatten[List@@@prs,1];
	(* loop over the strands *)
	Table[
		(* for this strand, work only with the pairs that touch this strand *)
		replaceStrandBasesWithX[str[[i]],Select[flatPairs,First[#]===i&]],
		{i,Length[str]}
	]
];

(* no bonds, do nothing *)
replaceStrandBasesWithX[in_Strand,{}]:= in;
(* Strip off strand index because we already pulled out the strand *)
replaceStrandBasesWithX[in_Strand,ints:{{_Integer,_Integer,Span[_Integer,_Integer]}..}]:= replaceStrandBasesWithX[in,ints[[;;,2;;]]];
(* Given list of pairs to replace on, Fold over the list *)
replaceStrandBasesWithX[in_Strand,ints:{{_Integer,Span[_Integer,_Integer]}..}]:= Fold[replaceStrandBasesWithX[#1,#2]&,in,ints];
(* update the corresponding motif and replace it into the strand *)
replaceStrandBasesWithX[originalStrand_Strand,{motifIndex_Integer,baseSpan:Span[_Integer,_Integer]}]:=Module[
	{label,seq,pol,junk,newStrand,newSequence,newMotif},
	{label,junk,seq,pol}=ParseStrand[originalStrand][[motifIndex]];
	newSequence = replaceStringBasesWithX[seq,baseSpan,pol];
(*
	newStrand=ToStrand[ {{newSequence}},Polymer->pol,Motif->label,FastTrack->True];
	ReplacePart[originalStrand,motifIndex->newStrand[[1,1]]]
*)
	newMotif = If[MatchQ[label,""],pol[newSequence],pol[newSequence,label]];
	ReplacePart[originalStrand,motifIndex->newMotif]
];


(*
	Given a STRING and a span of positions, replace the characters at those positions with the letter X
*)

replaceStringBasesWithX[seq_String,int:Span[_Integer,_Integer],pol_]:=With[{
		intList=List@@int,
		(* convert to single-char bases to use StringReplace directly with bond positions *)
		baseCharRules = Simulation`Private`uniqueBaseReplacementRules[pol]
		},
	StringReplace[
		StringReplacePart[
			StringReplace[seq,baseCharRules],
			StringJoin@@ConstantArray["X",intList.{-1,1}+1],
			intList
		],
		Reverse/@baseCharRules
	]
];




ToStrand[s:StrandP,ops:OptionsPattern[]]:=If[StrandQ[s],
	s,
	Message[ToStrand::InvalidStrand,s]
];


(* ::Subsubsection::Closed:: *)
(*ToStructure*)


DefineOptions[ToStructure,
	Options :> {
		{Map -> False, True | False, "If True, Map ToStructure over list of inputs."},
		{Polymer -> Automatic, _, "Polymer type."},
		{Motif -> "", _, "Motif."},
		{Replace -> False, _, "Replace.",Category->Hidden}
	}
];


ToStructure[seq:{_String..},ops:OptionsPattern[]]:=Map[ToStructure[#,ops]&,seq]/;TrueQ[OptionValue[Map]];
ToStructure[structure_Structure,OptionsPattern[]]:=If[StructureQ[structure],
	structure,
	Message[ToStructure::InvalidStructure,structure]
];
ToStructure[strand_Strand,OptionsPattern[]]:=If[StrandQ[strand],
	Structure[{strand},{}],
	Message[ToStructure::InvalidStrand,strand]
];
ToStructure[strands:{_Strand..},OptionsPattern[]]:=If[And@@Map[StrandQ,strands],
	Structure[strands,{}],
	Message[ToStructure::InvalidStrand,Select[strands,!StrandQ[#]&]]
];

ToStructure[seq_String,ops:OptionsPattern[]]:=With[
	{strand=ToStrand[seq,PassOptions[ToStructure,ToStrand,ops]]},
	If[MatchQ[strand,Null], Return[Null]];
	Structure[{strand},{}]
];

ToStructure[seq:{_String..},ops:OptionsPattern[]]:=With[
	{strand=ToStrand[seq,PassOptions[ToStructure,ToStrand,ops]]},
	If[MatchQ[strand,Null], Return[Null]];
	Structure[{strand},{}]
];

ToStructure[listlist:{_List..},ops:OptionsPattern[]]:=With[
	{strands=Map[ToStrand[#,PassOptions[ToStructure,ToStrand,ops]]&,listlist]},
	If[MemberQ[strands,Null], Return[Null]];
	Structure[strands,{}]
];

ToStructure[listlistlist:{{_List..}..},ops:OptionsPattern[]]:=ToStructure[#,ops]&/@listlistlist;

ToStructure[m:MotifP,ops:OptionsPattern[]]:=With[{strand=ToStrand[m,PassOptions[ToStructure,ToStrand,ops]]},
	If[MatchQ[strand,Null], Return[Null]];
	Structure[{strand},{}]
];



(* ::Subsubsection:: *)
(*sortAndReformatStructures*)


sortAndReformatStructures[s_Structure]:=Quiet[
	toStrandBasePairBonds[StructureSort[s]],
	{StructureSort::ambiguous}
];
sortAndReformatStructures[in_]:=Module[{oldStructs,newStructs},
	oldStructs = Union[Cases[in,_Structure,Infinity]];
	newStructs = Quiet[
		Map[toStrandBasePairBonds[StructureSort[#]]&,oldStructs],
		{StructureSort::ambiguous}
	];
	ReplaceAll[in,Thread[Rule[oldStructs,newStructs]]]
];



(* ::Subsubsection::Closed:: *)
(*ToSequence*)


DefineOptions[ToSequence,
	Options :> {
		{Consolidate -> False, BooleanP, "If True, concatenates adjacent motif sequences of same polymer type."},
		{Replace -> True, BooleanP, "If True, replaces motif lengths with character \"N\"."},
		{Output -> All, All | Paired, "If All return all sequences, if Paired return only paired seqeunces."},
		{Map -> False, BooleanP, "If True, Map ToSequence over list of inputs."}
	}];


(* from strand *)
ToSequence[strand_Strand,ops:OptionsPattern[]]:=Module[{parsed},

	If[!StrandQ[strand,PassOptions[ToSequence,StrandQ,ops]],
		Return[Message[ToSequence::InvalidStrand,strand]];
	];

	parsed=(ParseStrand[strand]);

	If[OptionValue[Replace]===True,
		parsed=parsed/.{n_Integer:>(StringJoin@@Table["N",{n}])};
		If[OptionValue[Consolidate]===True,
			StringJoin/@(SplitBy[parsed,Last][[;;,;;,3]]),
			parsed[[;;,3]]
		],
		parsed[[;;,3]]
	]

];


(* from Structure *)
ToSequence[structure:StructureP,ops:OptionsPattern[]]:=Module[{},

	If[!StructureQ[structure,PassOptions[ToSequence,StructureQ,ops]],
		Return[Message[ToSequence::InvalidStructure,structure]]
	];

	Switch[OptionValue[Output],
		All, First[structure]/.{s_Strand:>ToSequence[s,ops]},
		Paired, StructureTake[structure,#]&/@Last[structure][[;;,1]],
		_, Return[Message[Generic::BadOptionValue,OptionValue[Output],Output]]
	]
];


ToSequence[seq:SequenceP,ops:OptionsPattern[]]:=
	If[SequenceQ[seq,PassOptions[ToSequence,SequenceQ,ops]],
		seq,
		Message[ToSequence::InvalidSequence,seq]
	];


(* Mapping definition *)
ToSequence[list_List,ops:OptionsPattern[]]:=ToSequence[#,ops]&/@list;



(* ::Subsubsection::Closed:: *)
(*NameMotifs*)


(* Tack on unique motif names to any unnamed sequences in the Structure so we can sort them out later *)
NameMotifs[item:(StructureP|StrandP|PolymerP[__])]:=item/.(seq:PolymerP[_]:>Append[seq,ToString[Unique["motif$"]]]);

SetAttributes[NameMotifs,Listable];


(* ::Subsection:: *)
(*State / Rules / Paired*)


(* ::Subsubsection:: *)
(*ToState*)


ToState[st:StateP]:=formatStateVars[st];
ToState[st:StateP,specs:{ReactionSpeciesP...}]:=addDefaultsToState[formatStateVars[st],formatSpecList[specs],0*First[st["Units"]]];

ToState[in:InitialConditionP,ops:OptionsPattern[]]:=ToState[{in},ops];
ToState[in:{InitialConditionP...},ops:OptionsPattern[]]:=ToState[rulesToState[in],ops];
ToState[in:{InitialConditionP...},specs:{ReactionSpeciesP...},ops:OptionsPattern[]]:=ToState[rulesToState[in],specs,ops];

ToState[specs:{ReactionSpeciesP...},quants:{(NumericP|ConcentrationP|UnitsP[]|AmountP)...},ops:OptionsPattern[]]:=ToState[MapThread[Rule,{specs,quants}],ops];
ToState[quants:{(NumericP|ConcentrationP|AmountP)...},specs:{ReactionSpeciesP...},ops:OptionsPattern[]]:=ToState[specs,quants];

ToState[in:{Rule[ReactionSpeciesP,NumericP|ConcentrationP|UnitsP[]|AmountP]..},ops:OptionsPattern[]]:=
	toStateInternal[Replace[in,{s:(_?SequenceQ|StrandP):>ToStructure[s]},{2}],ops];

(*ToState[in:{Rule[_?StructureQ,_?NumericQ|_?ConcentrationQ]..}]:=State@@(List@@@in)*)

ToState[in:{ReactionSpeciesP..}]:=
	State@@(List[ToStructure[#]]&/@in);

toStateInternal[in:{Rule[ReactionSpeciesP,_?NumericQ|_?ConcentrationQ|_Quantity]..},OptionsPattern[ToState]]:=Module[{},
	State@@List@@@in
];

ToState[thing_,unit:UnitsP[]]:=addUnitToState[ToState[thing],unit];


formatStateVars[st_State]:=sortAndReformatStructures[Replace[st,{s:(_?SequenceQ|StrandP):>ToStructure[s]},{2}]];
formatSpecList[sl_List]:=sortAndReformatStructures[Replace[sl,{s:(_?SequenceQ|StrandP):>ToStructure[s]},{1}]];


(* ::Subsection::Closed:: *)
(*Reaction / ImplicitReaction / Interaction*)


(* ::Subsubsection::Closed:: *)
(*toReaction*)


DefineUsage[toReaction,
	{
		BasicDefinitions -> {
			{"toReaction[{irreversibleReaction,forwardRate}]", "out", "contrust a properly formatted Reaction from the irreversible reaction 'rx' and forward rate 'frate'."},
			{"toReaction[}reversibleReaction,forwardRate,reverseRate}]", "out", "contrusts a properly formatted Reaction from the reversible reaction 'eqrx', forward rate 'frate' and reverse rate 'brate'."}
		},
		Input :> {
			{"irreversibleReaction", _Rule, "Irreversible reaction."},
			{"reversibleReaction", _Equilibrium, "Reversible reaction."},
			{"forwardRate", Rate1P | Rate2P, "The forward rate."},
			{"reverseRate", Rate1P | Rate2P, "The reverse rate."}
		},
		Output :> {
			{"out", ReactionP, "A properly formatted Reaction."}
		},
		SeeAlso -> {
			"ToReactionMechanism",
			"ToStrand"
		},
		Author -> {
			"brad"
		}
	}];



(* first order, irreversible *)
toReaction[{Rule[a:ReactionSpeciesP,b:ReactionSpeciesP],fr:Rate1P}]:=Reaction[{a},{b},fr];
toReaction[{Rule[a:ReactionSpeciesP,Times[b:ReactionSpeciesP,2]],fr:Rate1P}]:=Reaction[{a},{b,b},fr];
toReaction[{Rule[a:ReactionSpeciesP,Plus[b:ReactionSpeciesP,c:ReactionSpeciesP]],fr:Rate1P}]:=Reaction[{a},{b,c},fr];

(* second order, irreversible *)
toReaction[{Rule[Times[a:ReactionSpeciesP,2],b:ReactionSpeciesP],fr:Rate2P}]:=Reaction[{a,a},{b},fr];
toReaction[{Rule[Times[a:ReactionSpeciesP,2],Times[b:ReactionSpeciesP,2]],fr:Rate2P}]:=Reaction[{a,a},{b,b},fr];
toReaction[{Rule[Times[a:ReactionSpeciesP,2],Plus[b:ReactionSpeciesP,c:ReactionSpeciesP]],fr:Rate2P}]:=Reaction[{a,a},{b,c},fr];
toReaction[{Rule[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],c:ReactionSpeciesP],fr:Rate2P}]:=Reaction[{a,b},{c},fr];
toReaction[{Rule[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],Times[c:ReactionSpeciesP,2]],fr:Rate2P}]:=Reaction[{a,b},{c,c},fr];
toReaction[{Rule[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],Plus[c:ReactionSpeciesP,d:ReactionSpeciesP]],fr:Rate2P}]:=Reaction[{a,b},{c,d},fr];

(* first order, reversible *)
toReaction[{Equilibrium[a:ReactionSpeciesP,b:ReactionSpeciesP],fr:Rate1P,br:Rate1P}]:=Reaction[{a},{b},fr,br];
toReaction[{Equilibrium[a:ReactionSpeciesP,Times[b:ReactionSpeciesP,2]],fr:Rate1P,br:Rate2P}]:=Reaction[{a},{b,b},fr,br];
toReaction[{Equilibrium[a:ReactionSpeciesP,Plus[b:ReactionSpeciesP,c:ReactionSpeciesP]],fr:Rate1P,br:Rate2P}]:=Reaction[{a},{b,c},fr,br];

(* second order, reversible *)
toReaction[{Equilibrium[Times[a:ReactionSpeciesP,2],b:ReactionSpeciesP],fr:Rate2P,br:Rate1P}]:=Reaction[{a,a},{b},fr,br];
toReaction[{Equilibrium[Times[a:ReactionSpeciesP,2],Times[b:ReactionSpeciesP,2]],fr:Rate2P,br:Rate2P}]:=Reaction[{a,a},{b,b},fr,br];
toReaction[{Equilibrium[Times[a:ReactionSpeciesP,2],Plus[b:ReactionSpeciesP,c:ReactionSpeciesP]],fr:Rate2P,br:Rate2P}]:=Reaction[{a,a},{b,c},fr,br];
toReaction[{Equilibrium[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],c:ReactionSpeciesP],fr:Rate2P,br:Rate1P}]:=Reaction[{a,b},{c},fr,br];
toReaction[{Equilibrium[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],Times[c:ReactionSpeciesP,2]],fr:Rate2P,br:Rate2P}]:=Reaction[{a,b},{c,c},fr,br];
toReaction[{Equilibrium[Plus[a:ReactionSpeciesP,b:ReactionSpeciesP],Plus[c:ReactionSpeciesP,d:ReactionSpeciesP]],fr:Rate2P,br:Rate2P}]:=Reaction[{a,b},{c,d},fr,br];

(* listable *)
toReaction[in:{_List..}]:=toReaction/@in;


(* ::Subsection:: *)
(*ReactionMechanism / Reactions*)


(* ::Subsubsection:: *)
(*ToReactionMechanism*)


ToReactionMechanism[in_ReactionMechanism]:=formatMechanismVars[in];
ToReactionMechanism[in:ImplicitReactionP]:=ToReactionMechanism[{in}];
ToReactionMechanism[mech:ObjectP[Model[ReactionMechanism]]]:=mech[ReactionMechanism];
ToReactionMechanism[mech:ObjectP[Object[Simulation,ReactionMechanism]]]:=mech[ReactionMechanism];
ToReactionMechanism[in:{ImplicitReactionP..}]:=ToReactionMechanism[implicitReactionsToMechanism[in]];
ToReactionMechanism[in:{_Reaction...}]:=ToReactionMechanism[reactionsToMechanism[in]];
ToReactionMechanism[in:{rr_SparseArray,pp_SparseArray,rts_List,spcs_List}]:=
	ToReactionMechanism[MapThread[{#1->#2,#3}&,{Transpose[rr].spcs,Transpose[pp].spcs,rts}]];

ToReactionMechanism[in_,specs:{Except[_Rule]...}]:=With[{mech=ToReactionMechanism[in]},
	addInitialConditionReactions[mech,specs]
];


(*
	Add "constant" reactions for any species that appear in initial condition but not in the model.
	This makes them appear as constant species in the solution Trajectory.
*)

addInitialConditionReactions[model_, initial:{_?NumericQ...}]:=model;

addInitialConditionReactions[model:{ImplicitReactionP...}, specs:{Except[_Rule]...}] :=
   Module[ {speciesToAdd},
      speciesToAdd = Complement[specs, SpeciesList[model]];
  	If[speciesToAdd === {}, model,
       Join[model, Map[{# \[Equilibrium] #, 0., 0.} &, speciesToAdd]]]
    ];

addInitialConditionReactions[model:{KineticsEquationP...}, specs:{Except[_Rule]...}] :=
   Module[ {speciesToAdd,timeSymbol},
      speciesToAdd = Complement[specs, SpeciesList[model]];
			timeSymbol = kineticsEquationsTimeSymbol[model];
  	If[speciesToAdd === {}, model,
       Join[model, Map[(#'[t]==0) &, speciesToAdd]]]
    ];


addInitialConditionReactions[mech_ReactionMechanism, specs:{Except[_Rule]...}] :=
   implicitReactionsToMechanism[
		addInitialConditionReactions[
			mechanismToImplicitReactions[mech],
			specs
		]
	];

addInitialConditionReactions[model_,initial_]:=(
	Message[addInitialConditionReactions::BadModelOrICFormat];
	Print[model];
	Print[initial];
	$Failed
);


formatMechanismVars[mech_ReactionMechanism]:=sortAndReformatStructures[Replace[mech,{s:(_?SequenceQ|StrandP):>ToStructure[s]},{3}]];


(* ::Subsection::Closed:: *)
(*Injections*)


(* ::Subsubsection::Closed:: *)
(*Formats*)


(* {TimeP,ReactionSpeciesP,VolumeP,ConcentrationP} *)
FastInjectionsFormatP = {{TimeP,ReactionSpeciesP,VolumeP,ConcentrationP}..} | {{TimeP,ReactionSpeciesP,VolumeP,Null,ConcentrationP}..};

(* {TimeP,ReactionSpeciesP,VolumeP,FlowRateP,ConcentrationP} *)
slowInjectionsFormatP = {{TimeP,ReactionSpeciesP,VolumeP,FlowRateP,ConcentrationP}..};


InjectionsFormatP = FastInjectionsFormatP | slowInjectionsFormatP;


(* ::Subsubsection:: *)
(*Conversions*)


(* ::Subsection::Closed:: *)
(*Networks*)


(* ::Subsubsection::Closed:: *)
(*canonicalImplicitReaction*)


canonicalImplicitReaction[reactions:{(_Rule|_Equilibrium)..}]:=With[
	{
		canonicalSpeciesList=interactionToSpecies[Flatten[implicitReactionTable[][[;;,3]]]],
		givenSpeciesList = interactionToSpecies[reactions]
	},
		reactions/.Thread[Rule[givenSpeciesList,Take[canonicalSpeciesList,Length[givenSpeciesList]]]]
];
canonicalImplicitReaction[{r_Rule,_}]:=canonicalImplicitReaction[{r}];
canonicalImplicitReaction[{r_Equilibrium,_,_}]:=canonicalImplicitReaction[{r}];
canonicalImplicitReaction[reaction:(_Rule|_Equilibrium)]:=canonicalImplicitReaction[{reaction}];
canonicalImplicitReaction[reactions:{{(_Rule|_Equilibrium),___}..}]:=canonicalImplicitReaction[reactions[[;;,1]]];


(* ::Subsubsection::Closed:: *)
(*implicitReactionTable*)


implicitReactionTable[]:={
	{
		"FirstOrderIrreversible",
		{"FirstOrder","Irreversible"},
		{A->B},
		{A,B},
		{
			A[0] E^(-k[1,F] t),
			E^(-k[1,F] t) (-A[0]+A[0] E^(k[1,F] t)+B[0] E^(k[1,F] t))
		}
	},
	{
		"FirstOrderReversible",
		{"FirstOrder","Reversible"},
		{A\[Equilibrium]B},
		{A,B},
		{
			(A[0] k[1,R]+B[0] k[1,R]-B[0] E^((-k[1,R]-k[1,F]) t) k[1,R]+A[0] E^((-k[1,R]-k[1,F]) t) k[1,F])/(k[1,R]+k[1,F]),
			(B[0] E^((-k[1,R]-k[1,F]) t) k[1,R]+A[0] k[1,F]+B[0] k[1,F]-A[0] E^((-k[1,R]-k[1,F]) t) k[1,F])/(k[1,R]+k[1,F])
		}
	},
	{
		"FirstOrderIrreversibleHeterogeneous",
		{"FirstOrder","Irreversible","Heterogeneous"},
		{A->B+C},
		{A,B,C},
		{
			A[0]/E^(k[1,F]*t),
			A[0] + B[0] - A[0]/E^(k[1,F]*t),
			A[0] + C[0] - A[0]/E^(k[1,F]*t)
		}
	},
	{
		"FirstOrderReversibleHeterogeneous",
		{"FirstOrder","Reversible","Heterogeneous"},
		{A\[Equilibrium]B+C},
		{A,B,C},
		{
			((2*A[0] + B[0] + C[0])*k[1,R] + k[1,F] + Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*    Tan[(Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*t)/2 -       ArcTan[((B[0] + C[0])*k[1,R] + k[1,F])/Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]]])/(2*k[1,R]),
			-(-(B[0]*k[1,R]) + C[0]*k[1,R] + k[1,F] + Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*     Tan[(Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*t)/2 -        ArcTan[((B[0] + C[0])*k[1,R] + k[1,F])/Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]]])/(2*k[1,R]),
			-(B[0]*k[1,R] - C[0]*k[1,R] + k[1,F] + Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*Tan[(Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]*t)/2 -        ArcTan[((B[0] + C[0])*k[1,R] + k[1,F])/Sqrt[-((B[0] - C[0])^2*k[1,R]^2) - 2*(2*A[0] + B[0] + C[0])*k[1,R]*k[1,F] - k[1,F]^2]]])/(2*k[1,R])
		}
	},
	{
		"FirstOrderIrreversibleHomogeneous",
		{},
		{A->2 B},
		{A,B},
		{
			A[0] E^(-k[1,F] t),
			E^(-k[1,F] t) (-2 A[0]+2 A[0] E^(k[1,F] t)+B[0] E^(k[1,F] t))
		}
	},
	{
		"FirstOrderReversibleHomogeneous",
		{"FirstOrder","Reversible","Homogeneous"},
		{A\[Equilibrium]2 B},
		{A,B},
		{
			(k[1,F] + 4*(2*A[0] + B[0])*k[1,R] - Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]]*Tanh[(Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]]*t)/2 +       ArcTanh[(k[1,F] + 4*B[0]*k[1,R])/(Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]])]])/(8*k[1,R]),
			(-k[1,F] + Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]]*Tanh[(Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]]*t)/2 + ArcTanh[(k[1,F] + 4*B[0]*k[1,R])/(Sqrt[k[1,F]]*Sqrt[k[1,F] + 8*(2*A[0] + B[0])*k[1,R]])]])/(4*k[1,R])
		}
	},
	{
		"SecondOrderHeterogeneousIrreversibleFirstOrder",
		{},
		{A+B->C},
		{A,B,C},
		{
			(A[0]*(A[0] - B[0]))/(A[0] - B[0]*E^((-A[0] + B[0])*k[1,F]*t)),
			((A[0] - B[0])*B[0])/(-B[0] + A[0]*E^((A[0] - B[0])*k[1,F]*t)),
			B[0] + C[0] + ((A[0] - B[0])*B[0])/(B[0] - A[0]*E^((A[0] - B[0])*k[1,F]*t))
		}
	},
	{
		"SecondOrderHeterogeneousReversibleFirstOrder",
		{"SecondOrder"},
		{A+B\[Equilibrium]C},
		{A,B,C},
		{
			A[0]+(2 (-C[0] k[1,R]+A[0] B[0] k[1,F]))/(-k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] t]),
			B[0]+(2 (-C[0] k[1,R]+A[0] B[0] k[1,F]))/(-k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] t]),
			C[0]-(2 (-C[0] k[1,R]+A[0] B[0] k[1,F]))/(-k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 k[1,F] (-C[0] k[1,R]+A[0] B[0] k[1,F])+(-k[1,R]-(A[0]+B[0]) k[1,F])^2] t])
		}
	},
	{
		"SecondOrderHeterogeneousReversibleSecondOrderHeterogeneous",
		{},
		{A+B\[Equilibrium]C+G},
		{A,B,C,G},
		{
			A[0]+(2 (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F]))/(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] t]),
			B[0]+(2 (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F]))/(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] t]),
			C[0]-(2 (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F]))/(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] t]),
			G[0]-(2 (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F]))/(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F]-Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] Coth[1/2 Sqrt[-4 (-k[1,R]+k[1,F]) (-C[0] G[0] k[1,R]+A[0] B[0] k[1,F])+(-(C[0]+G[0]) k[1,R]-(A[0]+B[0]) k[1,F])^2] t])
		}
	},
	{
		"SecondOrderHeterogeneousIrreversibleSecondOrderHeterogeneous",
		{},
		{A+B->C+G},
		{A,B,C,G},
		{
			(A[0]*(A[0] - B[0]))/(A[0] - B[0]*E^((-A[0] + B[0])*k[1,F]*t)),
			((A[0] - B[0])*B[0])/(-B[0] + A[0]*E^((A[0] - B[0])*k[1,F]*t)),
			B[0] + C[0] + ((A[0] - B[0])*B[0])/(B[0] - A[0]*E^((A[0] - B[0])*k[1,F]*t)),
			B[0] + G[0] + ((A[0] - B[0])*B[0])/(B[0] - A[0]*E^((A[0] - B[0])*k[1,F]*t))
		}
	},
	{
		"SecondOrderHeterogeneousIrreversibleSecondOrderHomogeneous",
		{},
		{A+B->2 C},
		{A,B,C},
		{
			(A[0]*(A[0] - B[0]))/(A[0] - B[0]*E^((-A[0] + B[0])*k[1,F]*t)),
			((A[0] - B[0])*B[0])/(-B[0] + A[0]*E^((A[0] - B[0])*k[1,F]*t)),
			2*B[0] + C[0] + (2*(A[0] - B[0])*B[0])/(B[0] - A[0]*E^((A[0] - B[0])*k[1,F]*t))
		}
	},
	{
		"SecondOrderHeterogeneousReversibleSecondOrderHomogeneous",
		{},
		{A+B\[Equilibrium]2 C},
		{A,B,C},
		{
			(8*A[0]*k[1,R] + 4*C[0]*k[1,R] - A[0]*k[1,F] + B[0]*k[1,F] - Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*    Tanh[(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*t)/2 +       ArcTanh[(4*C[0]*k[1,R] + (A[0] + B[0])*k[1,F])/(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]])]])/  (8*k[1,R] - 2*k[1,F]),
			(8*B[0]*k[1,R] + 4*C[0]*k[1,R] + A[0]*k[1,F] - B[0]*k[1,F] - Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*    Tanh[(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*t)/2 +       ArcTanh[(4*C[0]*k[1,R] + (A[0] + B[0])*k[1,F])/(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]])]])/  (8*k[1,R] - 2*k[1,F]),
			(-((A[0] + B[0] + C[0])*k[1,F]) + Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*    Tanh[(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]]*t)/2 +       ArcTanh[(4*C[0]*k[1,R] + (A[0] + B[0])*k[1,F])/(Sqrt[k[1,F]]*Sqrt[4*(2*A[0] + C[0])*(2*B[0] + C[0])*k[1,R] + (A[0] - B[0])^2*k[1,F]])]])/(4*k[1,R] - k[1,F])}
	},
	{
		"SecondOrderHomogeneousIrreversible",
		{},
		{2 A->B},
		{A,B},
		{
			A[0]/(1+2 A[0] k[1,F] t),
			(B[0]+A[0]^2 k[1,F] t+2 A[0] B[0] k[1,F] t)/(1+2 A[0] k[1,F] t)
		}
	},
	{
		"SecondOrderHomogeneousReversibleFirstOrder",
		{},
		{2 A\[Equilibrium]B},
		{A,B},
		{
			(-k[1,R]+Sqrt[k[1,R]] Sqrt[k[1,R]+8 A[0] k[1,F]+16 B[0] k[1,F]] Tanh[1/2 Sqrt[k[1,R]] Sqrt[k[1,R]+8 (A[0]+2 B[0]) k[1,F]] t+ArcTanh[(k[1,R]+4 A[0] k[1,F])/(Sqrt[k[1,R]] Sqrt[k[1,R]+8 (A[0]+2 B[0]) k[1,F]])]])/(4 k[1,F]),
			1/(8 k[1,F]) (k[1,R]+4 A[0] k[1,F]+8 B[0] k[1,F]-Sqrt[k[1,R]] Sqrt[k[1,R]+8 A[0] k[1,F]+16 B[0] k[1,F]] Tanh[1/2 Sqrt[k[1,R]] Sqrt[k[1,R]+8 (A[0]+2 B[0]) k[1,F]] t+ArcTanh[(k[1,R]+4 A[0] k[1,F])/(Sqrt[k[1,R]] Sqrt[k[1,R]+8 (A[0]+2 B[0]) k[1,F]])]])
		}
	},
	{
		"SecondOrderHomogeneousIrreversibleSecondOrderHeterogeneous",
		{},
		{2 A->B+C},
		{A,B,C},
		{A[0]/(1 + 2*A[0]*k[1,F]*t), (B[0] + A[0]*(A[0] + 2*B[0])*k[1,F]*t)/(1 + 2*A[0]*k[1,F]*t), (C[0] + A[0]*(A[0] + 2*C[0])*k[1,F]*t)/(1 + 2*A[0]*k[1,F]*t)}
	},
	{
		"SecondOrderHomogeneousReversibleSecondOrderHeterogeneous",
		{},
		{2 A\[Equilibrium]B+C},
		{A,B,C},
		{
			1/(k[1,R]-4 k[1,F]) (A[0] k[1,R]+B[0] k[1,R]+C[0] k[1,R]-Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] Tanh[1/2 Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] t+ArcTanh[((B[0]+C[0]) k[1,R]+4 A[0] k[1,F])/(Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]])]]),
			1/(2 (k[1,R]-4 k[1,F])) (B[0] k[1,R]-C[0] k[1,R]-4 A[0] k[1,F]-8 B[0] k[1,F]+Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] Tanh[1/2 Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] t+ArcTanh[((B[0]+C[0]) k[1,R]+4 A[0] k[1,F])/(Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]])]]),
			1/(2 (k[1,R]-4 k[1,F])) (-B[0] k[1,R]+C[0] k[1,R]-4 A[0] k[1,F]-8 C[0] k[1,F]+Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] Tanh[1/2 Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]] t+ArcTanh[((B[0]+C[0]) k[1,R]+4 A[0] k[1,F])/(Sqrt[k[1,R]] Sqrt[(B[0]-C[0])^2 k[1,R]+4 (A[0]+2 B[0]) (A[0]+2 C[0]) k[1,F]])]])
		}
	},
	{
		"SecondOrderHomogeneousIrreversibleSecondOrderHomogenous",
		{},
		{2 A->2 B},
		{A,B},
		{
			A[0]/(1 + 2*A[0]*k[1,F]*t),
			A[0] + B[0] - A[0]/(1 + 2*A[0]*k[1,F]*t)
		}
	},
	{
		"SecondOrderHomogeneousReversibleSecondOrderHomogeneous",
		{},
		{2A\[Equilibrium]2B},
		{A,B},
		$Failed
	},
	{
		"CompetitiveFirstOrderIrreversible",
		{"FirstOrder","Irreversible","Competitive"},
		{A->B,A->C},
		{A,B,C},
		{
			A[0]*E^((-k[1,F] - k[2,F])*t),
			B[0] - (A[0]*(-1 + E^((-k[1,F] - k[2,F])*t))*k[1,F])/(k[1,F] + k[2,F]),
			C[0] - (A[0]*(-1 + E^((-k[1,F] - k[2,F])*t))*k[2,F])/(k[1,F] + k[2,F])
		}
	},
	{
		"CompetitiveFirstOrderReversible",
		{},
		{A\[Equilibrium]B,A\[Equilibrium]C},
		{A,B,C},
		{
			A[0]+(2 E^(-(1/2) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (C[0] k[2,R] (-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t)) k[1,R]^3+k[1,R]^2 (-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (2 k[2,R]-3 k[1,F]+2 k[2,F])+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (2 k[2,R]-3 k[1,F]+2 k[2,F])+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])+k[1,F] (2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])+k[1,R] (2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]^2+3 k[1,F]^2+k[2,F]^2+2 k[2,R] (-2 k[1,F]+k[2,F]))-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]^2+3 k[1,F]^2+k[2,F]^2+2 k[2,R] (-2 k[1,F]+k[2,F]))-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))+k[2,F] (B[0] k[1,R] (-k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))))+A[0] (-k[1,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) k[1,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) k[1,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))))))/(((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))) (k[1,R]+k[2,R]+k[1,F]+k[2,F]-Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))+(2 E^(-(1/2) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (B[0] k[1,R] (-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t)) k[1,R]^2 (k[2,R]+k[2,F])+2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]+k[2,F]) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]+k[2,F]) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)+k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,F] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,F]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] (-4 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]+k[2,F]) (k[2,R]-k[1,F]+k[2,F])+2 (1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]+k[2,F]) (k[2,R]-k[1,F]+k[2,F])-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))+k[1,F] (C[0] k[2,R] (-k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))))+A[0] (k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) k[2,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) k[2,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))))))/(((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))) (k[1,R]+k[2,R]+k[1,F]+k[2,F]-Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])),
			B[0]-(2 E^(-(1/2) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (B[0] k[1,R] (-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t)) k[1,R]^2 (k[2,R]+k[2,F])+2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]+k[2,F]) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]+k[2,F]) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)+k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,F] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,F]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] (-4 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]+k[2,F]) (k[2,R]-k[1,F]+k[2,F])+2 (1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]+k[2,F]) (k[2,R]-k[1,F]+k[2,F])-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))+k[1,F] (C[0] k[2,R] (-k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))))+A[0] (k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) k[2,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) k[2,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))))))/(((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))) (k[1,R]+k[2,R]+k[1,F]+k[2,F]-Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])),
			C[0]-(2 E^(-(1/2) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (C[0] k[2,R] (-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t)) k[1,R]^3+k[1,R]^2 (-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (2 k[2,R]-3 k[1,F]+2 k[2,F])+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (2 k[2,R]-3 k[1,F]+2 k[2,F])+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])+k[1,F] (2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]^2+2 k[2,R] (-k[1,F]+k[2,F])+(k[1,F]+k[2,F])^2)-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))])+k[1,R] (2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) (k[2,R]^2+3 k[1,F]^2+k[2,F]^2+2 k[2,R] (-2 k[1,F]+k[2,F]))-(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) (k[2,R]^2+3 k[1,F]^2+k[2,F]^2+2 k[2,R] (-2 k[1,F]+k[2,F]))-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))+k[2,F] (B[0] k[1,R] (-k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))))+A[0] (-k[1,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R]^2 Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,R] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-k[1,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+2 k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[2,R] k[1,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]+k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t) k[1,R] k[2,F] Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]-2 E^(1/2 (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) t) k[1,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))+(1+E^(Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))] t)) k[1,R] ((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F])))))))/(((k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))) (k[1,R]+k[2,R]+k[1,F]+k[2,F]-Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]) (k[1,R]+k[2,R]+k[1,F]+k[2,F]+Sqrt[(k[1,R]+k[2,R]+k[1,F]+k[2,F])^2-4 (k[2,R] k[1,F]+k[1,R] (k[2,R]+k[2,F]))]))
		}
	},
	{
		"CompetitiveSecondOrderHeterogeneousIrreversible",
		{},
		{A+B->C,A+G->F},
		{A,B,C,G,F},
		$Failed
	},
	{
		"CompetitiveSecondOrderHomogeneousIrreversible",
		{},
		{2 A->B,2 A->C},
		{A,B,C},
		{
			A[0]/(1 + 2*A[0]*(k[1,F] + k[2,F])*t),
			(B[0] + A[0]*(A[0]*k[1,F] + 2*B[0]*(k[1,F] + k[2,F]))*t)/(1 + 2*A[0]*(k[1,F] + k[2,F])*t),
			(C[0] + A[0]*(A[0]*k[2,F] + 2*C[0]*(k[1,F] + k[2,F]))*t)/  (1 + 2*A[0]*(k[1,F] + k[2,F])*t)
		}
	},
	{
		"CompetitiveSecondOrderHeterogeneousReversibleFirstOrder",
		{},
		{A+B\[Equilibrium]C,A+G\[Equilibrium]F},
		{A,B,C,G,F},
		$Failed
	},
	{
		"ConsecutiveFirstOrderIrreversibleFirstOrderIrreversible",
		{},
		{A->B,B->C},
		{A,B,C},
		{
			A[0] E^(-k[1,F] t),
			-((E^(-k[1,F] t-k[2,F] t) (-A[0] E^(k[1,F] t) k[1,F]-B[0] E^(k[1,F] t) k[1,F]+A[0] E^(k[2,F] t) k[1,F]+B[0] E^(k[1,F] t) k[2,F]))/(k[1,F]-k[2,F])),
			C[0]+(B[0] E^(-k[2,F] t) (-1+E^(k[2,F] t)) (k[1,F]-k[2,F])+A[0] (k[1,F]-E^(-k[2,F] t) k[1,F]+(-1+E^(-k[1,F] t)) k[2,F]))/(k[1,F]-k[2,F])
		}
	},
	{
		"ConsecutiveFirstOrderIrreversibleFirstOrderIrreversibleFirstOrderIrreversible",
		{},
		{A->B,B->C,C->G},
		{A,B,C,G},
		{
			A[0] E^(-k[1,F] t),
			-((E^(-k[1,F] t-k[2,F] t) (-A[0] E^(k[1,F] t) k[1,F]-B[0] E^(k[1,F] t) k[1,F]+A[0] E^(k[2,F] t) k[1,F]+B[0] E^(k[1,F] t) k[2,F]))/(k[1,F]-k[2,F])),
			C[0]+(B[0] E^(-k[2,F] t) (-1+E^(k[2,F] t)) (k[1,F]-k[2,F])+A[0] (k[1,F]-E^(-k[2,F] t) k[1,F]+(-1+E^(-k[1,F] t)) k[2,F]))/(k[1,F]-k[2,F])-1/((k[1,F]-k[2,F]) (k[1,F]-k[3,F]) (k[2,F]-k[3,F])) E^(-(k[1,F]+k[2,F]+k[3,F]) t) (A[0] (E^((k[1,F]+k[2,F]) t) k[1,F] k[2,F] (-k[1,F]+k[2,F])+E^((k[1,F]+k[2,F]+k[3,F]) t) (k[1,F]-k[2,F]) (k[1,F]-k[3,F]) (k[2,F]-k[3,F])+E^((k[1,F]+k[3,F]) t) k[1,F] (k[1,F]-k[3,F]) k[3,F]+E^((k[2,F]+k[3,F]) t) k[2,F] k[3,F] (-k[2,F]+k[3,F]))+E^(k[1,F] t) (-k[1,F]+k[2,F]) ((B[0]+C[0]) E^((k[2,F]+k[3,F]) t) (k[2,F]-k[3,F]) (-k[1,F]+k[3,F])+(k[1,F]-k[3,F]) (-B[0] E^(k[3,F] t) k[3,F]+E^(k[2,F] t) ((B[0]+C[0]) k[2,F]-C[0] k[3,F])))),
			G[0]+1/((k[1,F]-k[2,F]) (k[1,F]-k[3,F]) (k[2,F]-k[3,F])) E^(-(k[1,F]+k[2,F]+k[3,F]) t) (A[0] (E^((k[1,F]+k[2,F]) t) k[1,F] k[2,F] (-k[1,F]+k[2,F])+E^((k[1,F]+k[2,F]+k[3,F]) t) (k[1,F]-k[2,F]) (k[1,F]-k[3,F]) (k[2,F]-k[3,F])+E^((k[1,F]+k[3,F]) t) k[1,F] (k[1,F]-k[3,F]) k[3,F]+E^((k[2,F]+k[3,F]) t) k[2,F] k[3,F] (-k[2,F]+k[3,F]))+E^(k[1,F] t) (-k[1,F]+k[2,F]) ((B[0]+C[0]) E^((k[2,F]+k[3,F]) t) (k[2,F]-k[3,F]) (-k[1,F]+k[3,F])+(k[1,F]-k[3,F]) (-B[0] E^(k[3,F] t) k[3,F]+E^(k[2,F] t) ((B[0]+C[0]) k[2,F]-C[0] k[3,F]))))
		}
	},
	{
		"ConsecutiveSecondOrderIrreversibleFirstOrder",
		{},
		{A+B->C,C->G},
		{A,B,C,G},
		$Failed
	}
};





(* ::Subsubsection:: *)
(*reaction connectedness*)


interactionsToSpeciesConnectivityGraph[interacs_]:=Graph[Flatten[Map[threadInteraction,ReplaceAll[interacs,{Plus->List,Rule->UndirectedEdge,Equilibrium->UndirectedEdge}]]]];
connectedReactions[reacs:ImplicitReactionsFormatP]:=With[
	{
		connComp=ConnectedComponents[interactionsToSpeciesConnectivityGraph[implicitReactionsToInteractions[reacs]]],
		specLists = Map[implicitReactionToSpecies,reacs]
	},
	Map[reactionsConnectedToComponents[reacs,specLists,#]&,connComp]
];
reactionsConnectedToComponents[reactions_,specLists_,components_]:=Select[Transpose[{reactions,specLists}],Intersection[#[[2]],components]=!={}&][[;;,1]];


threadInteraction[UndirectedEdge[left_List,right_]]:=Map[threadInteraction[UndirectedEdge[#,right]]&,left];
threadInteraction[UndirectedEdge[left_,right_List]]:=Map[threadInteraction[UndirectedEdge[left,#]]&,right];
threadInteraction[UndirectedEdge[left_,right_]]:=UndirectedEdge[left,right];



(* ::Subsection:: *)
(*Trajectory*)


(* ::Subsubsection::Closed:: *)
(*Trajectory*)


Trajectory[qa:QuantityCoordinatesP[]]:=ToTrajectory[qa];
Trajectory[xy:CoordinatesP,un_]:=ToTrajectory[xy,un];
Trajectory[x:{{_?NumericQ..}..},t:{_?NumericQ..}]:=ToTrajectory[x,t,{Second,Molar}];
Trajectory[x:{{_?NumericQ..}..},t:{_?NumericQ..},un_]:=ToTrajectory[FromCharacterCode/@(64+Range[Length[x[[1]]]]),x,t,un];

Trajectory[traj:TrajectoryP]:=traj;
Trajectory[traj:TrajectoryP]:=traj;



Trajectory::BadSpecies="The requested species `1` does not exist in the Trajectory species list `2`.";

Trajectory[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],posList:{_Integer...}]:=
		Trajectory[specs[[posList]],concs[[;;,posList]],ts,uns];
Trajectory[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],posSpan_Integer?Positive]:=
		Trajectory[specs[[;;posSpan]],concs[[;;,;;posSpan]],ts,uns];
Trajectory[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],posSpan_Integer?Negative]:=
		Trajectory[specs[[posSpan;;]],concs[[;;,posSpan;;]],ts,uns];

Trajectory[tr:TrajectoryFormatP,subspecs_List]:=With[
	{posList = Map[trajectorySpeciesPosition[tr,#]&,subspecs]},
	If[MemberQ[posList,$Failed],
		$Failed,
		Trajectory[tr,posList]
	]
];
Trajectory[tr:Trajectory[specs_List,concs_List,ts_List,uns_List],subspec_]:=
		Trajectory[tr,{subspec}];



trajectorySpeciesPosition[Trajectory[specs_List,_List,_List,_List],spec_]:=
		If[MemberQ[specs,spec],
			Position[specs,spec,1][[1,1]],
			(
				Message[Trajectory::BadSpecies,spec,specs];
				$Failed
			)
		];




(* ::Subsubsection::Closed:: *)
(*ToTrajectory*)


ToTrajectory[x:{{_?NumericQ..}..},t:{_?NumericQ..}]:=ToTrajectory[x,t,{Second,Molar}];
ToTrajectory[x:{{_?NumericQ..}..},t:{_?NumericQ..},un_]:=ToTrajectory[FromCharacterCode/@(64+Range[Length[x[[1]]]]),x,t,un];
ToTrajectory[specs:{ReactionSpeciesP..},x:{{_?NumericQ..}..},t:{_?NumericQ..}]:=ToTrajectory[specs,x,t,{Second,Molar}];
ToTrajectory[specs:{ReactionSpeciesP..},x:{{_?NumericQ..}..},t:{_?NumericQ..},un_]:=Trajectory[specs,x,t,un];

ToTrajectory[xy:CoordinatesP,un_]:=ToTrajectory[Transpose[{xy[[;;,2]]}],xy[[;;,1]],un];
ToTrajectory[qa:QuantityCoordinatesP[]]:=ToTrajectory[{"A"},qa];
ToTrajectory[specs:{ReactionSpeciesP..},qa:(CoordinatesP|QuantityCoordinatesP[])]:=Module[{mags,uns},
	uns = Units[First[qa]];
	mags=QuantityMagnitude[qa,uns];
	ToTrajectory[specs,Transpose[{mags[[;;,2]]}],mags[[;;,1]],uns]
];
ToTrajectory[specs:{ReactionSpeciesP..},xy:CoordinatesP,un_]:=ToTrajectory[specs,Transpose[{xy[[;;,2]]}],xy[[;;,1]],un];


(* missing Units & species *)
ToTrajectory[f_InterpolatingFunction]:=ToTrajectory[f,{Second,Molar}];

(* missing Units *)
ToTrajectory[specs:{ReactionSpeciesP..},f_InterpolatingFunction]:=ToTrajectory[specs,f,{Second,Molar}];

(* missing species, with InterpolatingFunction *)
ToTrajectory[f_InterpolatingFunction,un_]:=Module[{t,x},
	{t,x}=parseIF[f];
	ToTrajectory[FromCharacterCode/@(64+Range[Length[x[[;;,1]]]]),Transpose[x],t,un]
];

(* given everything with InterpolatingFunctio *)
ToTrajectory[specs:{ReactionSpeciesP..},f_InterpolatingFunction,un_]:=Module[{t,x},
	{t,x}=parseIF[f];
	ToTrajectory[specs,Transpose[x],t,un]
];



(* already in Trajectory form *)
ToTrajectory[traj_Trajectory,rest___]:=	traj;



(* ::Subsubsection::Closed:: *)
(*parseIF*)


parseIF[sim_InterpolatingFunction] :=
    {
	sim[[3]][[1,All]], (* time *)
    Transpose[sim[[4]][[All,1,All,1]]] (* x(t) *)
	};

parseIF[sim:{_InterpolatingFunction,__}] :=  parseIF[First[sim]];  (* For output of NDSolve *)



(* ::Subsubsection:: *)
(*TrajectoryRegression*)


DefineOptions[TrajectoryRegression,
	Options :> {
		{Output -> Concentration, Time | Concentration | {Time, Concentration}, "Whether to return time values, concentrations, or concentrations paired with times."}
	},
	SharedOptions :> {
			{Interpolation, {InterpolationOrder}}
	}
];


SpeciesP = Except[End,ReactionSpeciesP];
convertToSecond[num:_?NumericQ]:=num;
convertToSecond[in_]:=Unitless[in,Second];


TrajectoryRegression[in:TrajectoryP, {}, ___]:= {};
(* listable *)
TrajectoryRegression[in:{_Trajectory..},rest___]:=Map[TrajectoryRegression[#,rest]&,in];

(* put inputs in correct format *)
TrajectoryRegression[in:TrajectoryP,ss:SpeciesP,tt:(_?NumericQ|_?TimeQ|End),ops:OptionsPattern[TrajectoryRegression]]:=First[First[TrajectoryRegression[in,{ss},{tt},ops]]];
TrajectoryRegression[in:TrajectoryP,ss:{SpeciesP...},tt:(_?NumericQ|_?TimeQ|End),ops:OptionsPattern[TrajectoryRegression]]:=First[TrajectoryRegression[in,ss,{tt},ops]];
TrajectoryRegression[in:TrajectoryP,ss:SpeciesP,tt:{(_?NumericQ|_?TimeQ|End)..},ops:OptionsPattern[TrajectoryRegression]]:=Flatten[TrajectoryRegression[in,{ss},tt,ops],1];
TrajectoryRegression[in:TrajectoryP,tt:{(_?NumericQ|_?TimeQ|End)..},ops:OptionsPattern[TrajectoryRegression]]:=TrajectoryRegression[in,trajectoryToSpecies[in],tt,ops];
TrajectoryRegression[in:TrajectoryP,tt:(_?NumericQ|_?TimeQ|End),ops:OptionsPattern[TrajectoryRegression]]:=First[TrajectoryRegression[in,trajectoryToSpecies[in],{tt},ops]];
TrajectoryRegression[in:TrajectoryP,ss:{SpeciesP...},ops:OptionsPattern[TrajectoryRegression]]:=TrajectoryRegression[in,ss,trajectoryToTimes[in],ops];
TrajectoryRegression[in:TrajectoryP,ss:SpeciesP,ops:OptionsPattern[TrajectoryRegression]]:=Flatten[TrajectoryRegression[in,{ss},trajectoryToTimes[in],ops],1];
TrajectoryRegression[in:TrajectoryP,ops:OptionsPattern[TrajectoryRegression]]:=TrajectoryRegression[in,trajectoryToSpecies[in],trajectoryToTimes[in],ops];



(* if tt are NOT in tvals, then interpolate *)
TrajectoryRegression[in:TrajectoryP,ss:{SpeciesP...},tt:{(_?NumericQ|_?TimeQ|End)..},OptionsPattern[]]:=Module[
	{species,xvals,tvals,un,concs,temps,n,tout,ipOrder},

	species=trajectoryToSpecies[in];
	tvals=trajectoryToTimes[in];
	xvals=trajectoryToConcentration[in];
	un=trajectoryToUnits[in];
	tout = Switch[tt,
		{_?NumericQ...},
			tt,
		{End},
			{Last[tvals]},
		{_?TimeQ..},
			Unitless[tt,Second]
	];

	n=Length[ss];

	(* pull out concentrations *)
	ipOrder = OptionValue[InterpolationOrder];

	concs=If[TrueQ[Complement[convertToSecond/@(tt/.{End:>Last[tvals]}),tvals]],
		(* select values out *)
		evalInterpolate[species,xvals,tvals,ss,tt,ipOrder],
		(* Interpolate *)
		evalInterpolate[species,xvals,tvals,ss,tt,ipOrder]
	];

	(* pull out temperatures *)
	temps=Null&/@tout;

	Switch[OptionValue[Output],
		_Symbol,OptionValue[Output]/.{Time->tout,Concentration->concs,Temperature->temps},
		{_Symbol..},MapThread[Transpose[{##}]&,(OptionValue[Output]/.{Time->Table[tout,{n}],Concentration->Transpose[concs],Temperature->Table[temps,{n}]})],
		_, Message[Generic::BadOptionValue,OptionValue[Output],Output]
	]
];

evalInterpolate[species_,xvals_,tvals_,ss_,tt_,ipOrder_]:= Module[{interps,tsecs,ypreds},
	(* raw time values, in seconds *)
	tsecs =convertToSecond/@(tt/.{End:>Last[tvals]});
	(* create an interpolation function for each species *)
	interps = Table[
		Quiet[Interpolation[Transpose[{perturbedTimes[tvals],First[Pick[Transpose[xvals],SameQ[s,#]&/@sortAndReformatStructures[species]]]}], InterpolationOrder -> ipOrder]],
		{s,sortAndReformatStructures[ss]}];
	(* evaluate the interpolation functions at every time *)
	ypreds = Map[#[tsecs]&,interps];
	(* transpose back they're grouped by time point instead of species *)
	Transpose[ypreds]
];

(* make sure all time points are unique, otherwise interpolation complains *)
perturbedTimes[times_]:= times + Prepend[Replace[Differences[times], {0. -> Mean[times]*10^-9, _ -> 0.}, {1}], 0.];

evalSelect[species_List,xvals:{{_?NumericQ..}..},tvals:{_?NumericQ..},ss:{SpeciesP..},tt:{_?NumericQ..}]:=Module[{tinds,sinds},
	tinds = Flatten[Table[Pick[Range[Length[tvals]],tvals,t],{t,tt}]];
	sinds = Flatten[Table[Pick[Range[Length[species]],species,s],{s,ss}]];
	xvals[[tinds,sinds]]
];

MakeMoleculeBoxes[]:=Module[{},
	$MoleculeBlobs=True;

	(* trigger loading of default boxing *)
	Molecule["Water"];

	Unprotect[Molecule];

	PrependTo[FormatValues[Molecule],
		HoldPattern[MakeBoxes[mol:Molecule[{(__Atom|__String)..},{___Bond},___],StandardForm]]/;TrueQ[$MoleculeBlobs]:>
			With[{boxes=ToBoxes[ECL`PlotMolecule[mol]]},
				InterpretationBox[boxes,mol]
			]
	];

	Protect[Molecule];
];


(* ::Subsection::Closed:: *)
(*Summary Blobs*)


installEmeraldNucleicAcidBlobs[]:=Module[{},

	MakeTrajectoryBoxes[];

	MakeStateBoxes[];

	MakeMechanismBoxes[];

	MakeMoleculeBoxes[];

];

OnLoad[installEmeraldNucleicAcidBlobs[]];
