(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Sequence Manipulation*)


(* ::Subsubsection:: *)
(*sequenceResolution*)
OnLoad[
	General::unknownPolymer="Provided sequence `1` has an unknown polymer type.";
	General::missMatchPolymer="Provided sequence `1` does not match provided polymer type `2`.";
	General::unConsensus="Provided sequence has unconsensus polymer types.";
	General::unResolved="Cannot get polymer type from `1` since FastTrack is set to True. Try to set FastTrack to False.";
	General::invalidSpan = "Cannot take positions `1` through `2`.";
	General::unmMatchLength = "Input sequence list length `1` doesn't match index list length `2`.";
	General::invalidStrand = "Input strand `1` is not valid.";
]

Options[allAlphabet]:={
	Polymer -> Automatic,
	FastTrack -> False,
	Degeneracy -> True,
	AlternativeEncodings -> False
};

(* get possible alphabets for a certain polymer type *)
allAlphabet[polymer:PolymerP, ops: OptionsPattern[]]:= allAlphabet[polymer, ops] = Module[
	{bases, degenerateBases, altEncodings, out},

	bases=(Physics`Private`lookupModelOligomer[polymer,Alphabet]);

	(* return empty alphabet if we don't have any bases for it *)
	If[bases===$Failed,
		Return[{}];
	];

	degenerateBases=Physics`Private`lookupModelOligomer[polymer,DegenerateAlphabet][[All,1]];
	altEncodings=Join[
		Flatten@Map[#[[All,1]]&,Physics`Private`lookupModelOligomer[polymer,AlternativeEncodings]],
		Flatten@Map[#[[All,1]]&,Physics`Private`lookupModelOligomer[polymer,AlternativeDegenerateEncodings]]
	];

	out=Switch[{OptionValue[Degeneracy], OptionValue[AlternativeEncodings]},
		{True,True}, Union[bases, degenerateBases, altEncodings],
		{True,False}, Union[bases, degenerateBases],
		{False,True}, Union[bases, altEncodings],
		{False,False}, bases
	];

	(* sort with longest first to avoid getting substrings when names overlap *)
	Reverse[SortBy[out,StringLength]]

];

allAlphabet[_, ops: OptionsPattern[]]:= {"/$#@"}; (* other cases, assign some random charactors which typically do not appear together *)


Options[polymerStringPattern]:={
	Polymer -> Automatic,
	FastTrack -> False,
	Degeneracy -> True,
	AlternativeEncodings -> False
};

polymerStringPattern[polymer:PolymerP, ops: OptionsPattern[]]:= polymerStringPattern[polymer, ops] = Core`Private`toRegularExpression[allAlphabet[polymer, ops]..];


Options[firstMatchingPolymer]:={
	Polymer -> Automatic,
	FastTrack -> False,
	Degeneracy -> True,
	AlternativeEncodings -> False
};

firstMatchingPolymer[str_String, ops: OptionsPattern[]]:= With[
	{order = DeleteDuplicates[Join[{DNA, Modification, Peptide, RNA}, AllPolymersP]]},

	Scan[
		If[StringMatchQ[str, polymerStringPattern[#, ops]],
			Return[#]
		]&,
		order
	]
];


Options[resolveSequence]:={
	Polymer -> Automatic,
	FastTrack -> False,
	Degeneracy -> True,
	AlternativeEncodings -> False
};

Authors[resolveSequence]:={"scicomp", "brad"};

resolveSequence[str_String, f_, ops: OptionsPattern[]]:= Module[
	{polymer},

	polymer = OptionValue[Polymer];

	(* if FastTrack set to be True, ignore all checkings; if a polymer type is provided, just head it *)
	(*If[OptionValue[FastTrack],
		If[!MatchQ[polymer, Automatic],
			Return[polymer[str]],
			Return[str]
		]
	];*)

	(* FastTrack = False *)
	Switch[polymer,
		Automatic, With[{res = firstMatchingPolymer[str, ops]},
						If[!MatchQ[res, Null],
							res[str],
							(Message[f::unknownPolymer, str];
							Return[$Failed])
						]
					],

		_, If[StringMatchQ[str, polymerStringPattern[polymer, ops]],
				polymer[str],
				Message[f::missMatchPolymer, str, ToString[polymer]];
				Return[$Failed]
				]
		]
];


resolveSequence[seq: PolymerP[(_String|_Integer), name___], f_, ops: OptionsPattern[]]:= Module[
	{type, str, polymer},

	(* if FastTrack set to be True, ignore all checkings *)
	(*If[OptionValue[FastTrack], Return[seq]];*)

	(* FastTrack = False *)
	type = Head[seq];
	str = UnTypeSequence[seq]; (* UnTypeSequence doesn't call other sequence functions, thus call it here should be fine *)

	polymer = OptionValue[Polymer];

	Switch[polymer,
		(* check if the head is the corrrect polymer type *)
		Automatic, If[StringMatchQ[str, polymerStringPattern[type, ops]],
						type[str, name],
						Message[f::missMatchPolymer, ToString[seq], ToString[type]];
						Return[$Failed]
					],

		_, If[MatchQ[type, polymer], (* check if the head is consistant with the provided polymer type *)
				If[StringMatchQ[str, polymerStringPattern[type, ops]], (* also, check if the wrapped string is consistant with the head *)
					type[str, name],
					Message[f::missMatchPolymer, ToString[seq], ToString[type]];
					Return[$Failed]
					],
				Message[f::missMatchPolymer, ToString[seq], ToString[polymer]];
				Return[$Failed]
			]
		]
];


resolveSequence[seq:Except[_List], f_, ops: OptionsPattern[]]:=
	If[OptionValue[FastTrack],
		Return[$Failed],
		(Message[f::unknownPolymer, seq];
		Return[$Failed])
];


resolveSequence[seqs_List, f_, ops: OptionsPattern[]]:= resolveSequence[#, f, ops]&/@seqs;


validSpanQ[L_Integer,m_Integer,n_Integer] := Max[Abs[m],Abs[n]]<=L && ((m<=n&&Sign[m]==Sign[n]) || (m>n&&Sign[m]!=Sign[n]));


(* ::Subsubsection:: *)
(*SequenceQ*)


DefineOptions[SequenceQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Exclude -> {}, PolymerP | {SequenceP...}, "Monomers not to be included in alphabet when considering if a sequence is valid."},
		{Degeneracy -> True, BooleanP, "If set to True, the degenerate alphabet will be considered valid."},
		{Map -> True, BooleanP, "If set to True, listable works as normal, if set to False check to see that all sequences are valid and of the same polymer type."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


SequenceQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, untyped, tmpRes},

	safeOps = SafeOptions[SequenceQ, ToList[ops]];

	(* if FastTrack is set to True, return True *)
	If[FastTrack/.safeOps, Return[True]];

	(* FastTrack = False, resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[seqs, SequenceQ, PassOptions[SequenceQ, resolveSequence, safeOps]]];

	(* "Exclude" option *)
	untyped = UnTypeSequence[reSeqs]; (* because reSeqs are all typed format,  UnTypeSequence takes instant time*)

	tmpRes = Map[!(MatchQ[#,$Failed]||StringContainsQ[#, Alternatives@@(Exclude/.safeOps)])&, untyped];

	If[Map/.safeOps,
		tmpRes,
		(And@@tmpRes) && (SameQ@@PolymerType[reSeqs, FastTrack->True])
	]

];


SequenceQ[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = SequenceQ[{seq}, ops]}, If[ListQ[res], First[res], res]];


(* All other cases are false *)
SequenceQ[Except[_List], ops:OptionsPattern[]]:= False;


(* ::Subsubsection:: *)
(*SameSequenceQ*)


DefineOptions[SameSequenceQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];

sameSequenceCore[seqs:{SequenceP..}]:= Module[
	{
		degenerateRules, monos, intersects, polymer,

		degenerateAlphabet,groupedDegenerates,degenerateRulesBase
	},

	polymer = Head[First[seqs]];

	(* DegenerateAlphabet associated with the type of polymer *)
	degenerateRules=Physics`Private`lookupModelOligomer[polymer,DegenerateAlphabet];

	monos = Monomers[seqs, FastTrack->True, ExplicitlyTyped->False]/.degenerateRules;

	(* See where the degeneracy intersects for each monomer *)
	intersects = Map[Intersection@@#&, Transpose[monos]];

	MatchQ[intersects,{{_String..}..}]
];


SameSequenceQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, untyped},

	safeOps = SafeOptions[SameSequenceQ, ToList[ops]];

	(* if FastTrack is set to True, return True *)
	If[FastTrack/.safeOps, Return[True]];

	(* FastTrack = False, resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[seqs, SameSequenceQ, PassOptions[SameSequenceQ, resolveSequence, safeOps]]];

	(* if resolving failed, return False *)
	If[MemberQ[reSeqs, $Failed], Return[False]];

	(* if polymer types don't match, return False *)
	If[!SameQ@@PolymerType[reSeqs, FastTrack->True], Return[False]];

	untyped = UnTypeSequence[reSeqs];

	(* Check to see if degeneracy is allowed *)
	If[Degeneracy/.safeOps,
		(* Degeneracy on -> check same length, and degeneracy matches *)
		SameQ@@StringLength[untyped] && sameSequenceCore[reSeqs],

		(* Degeneracy off \[Rule] simply check if match *)
		SameQ@@untyped
	]

];


SameSequenceQ[seqA: SequenceP, seqB: SequenceP, ops:OptionsPattern[]]:= SameSequenceQ[{seqA, seqB}, ops];


(* ::Subsubsection:: *)
(*DNAQ*)


DefineOptions[DNAQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
DNAQ[seqs:{SequenceP..},ops:OptionsPattern[]]:= SequenceQ[seqs, Polymer->DNA, Exclude->{}, PassOptions[DNAQ, SequenceQ, ops]];
DNAQ[seq:SequenceP,ops:OptionsPattern[]]:= SequenceQ[seq, Polymer->DNA, Exclude->{}, PassOptions[DNAQ, SequenceQ, ops]];

(* --- Strand Version --- *)
DNAQ[strs:{StrandP..},ops:OptionsPattern[]]:= StrandQ[strs, Polymer->DNA,PassOptions[DNAQ, StrandQ, ops]];
DNAQ[str:StrandP, ops:OptionsPattern[]]:= StrandQ[str, Polymer->DNA,PassOptions[DNAQ, StrandQ, ops]];

(* --- FastTrack versions --- *)
DNAQ[sequence_String,ops:OptionsPattern[]]:= True /;OptionValue[FastTrack];
DNAQ[sequence:DNA[(_String|_Integer),___],ops:OptionsPattern[]]:=True /;OptionValue[FastTrack];
DNAQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:= False /;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
DNAQ[input:Except[_List]]:= False;


(* ::Subsubsection:: *)
(*RNAQ*)


DefineOptions[RNAQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
RNAQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->RNA,Exclude->{},PassOptions[RNAQ,SequenceQ,ops]];
RNAQ[seq:SequenceP, ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->RNA,Exclude->{},PassOptions[RNAQ,SequenceQ,ops]];

(* --- Strand Version --- *)
RNAQ[strs:{StrandP..}, ops:OptionsPattern[]]:= StrandQ[strs,Polymer->RNA,PassOptions[RNAQ,StrandQ,ops]];
RNAQ[str:StrandP, ops:OptionsPattern[]]:= StrandQ[str,Polymer->RNA,PassOptions[RNAQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
RNAQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
RNAQ[sequence:RNA[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
RNAQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
RNAQ[input:Except[_List]]:=False;


(* ::Subsubsection:: *)
(*PNAQ*)


DefineOptions[PNAQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
PNAQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->PNA,Exclude->{},PassOptions[PNAQ,SequenceQ,ops]];
PNAQ[seq:SequenceP, ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->PNA,Exclude->{},PassOptions[PNAQ,SequenceQ,ops]];

(* --- Strand Version --- *)
PNAQ[strs:{StrandP..},ops:OptionsPattern[]]:= StrandQ[strs,Polymer->PNA,PassOptions[PNAQ,StrandQ,ops]];
PNAQ[str:StrandP,ops:OptionsPattern[]]:= StrandQ[str,Polymer->PNA,PassOptions[PNAQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
PNAQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
PNAQ[sequence:PNA[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
PNAQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
PNAQ[input:Except[_List]]:=False;


(* ::Subsubsection:: *)
(*GammaRightPNAQ*)


DefineOptions[GammaRightPNAQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
GammaRightPNAQ[seqs:{SequenceP..},ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->GammaRightPNA,Exclude->{},PassOptions[GammaRightPNAQ,SequenceQ,ops]];
GammaRightPNAQ[seq:SequenceP,ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->GammaRightPNA,Exclude->{},PassOptions[GammaRightPNAQ,SequenceQ,ops]];

(* --- Strand Version --- *)
GammaRightPNAQ[strs:{StrandP..},ops:OptionsPattern[]]:= StrandQ[strs,Polymer->GammaRightPNA,PassOptions[GammaRightPNAQ,StrandQ,ops]];
GammaRightPNAQ[str:StrandP,ops:OptionsPattern[]]:= StrandQ[str,Polymer->GammaRightPNA,PassOptions[GammaRightPNAQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
GammaRightPNAQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
GammaRightPNAQ[sequence:PNA[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
GammaRightPNAQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
GammaRightPNAQ[input:Except[_List]]:=False;


(* ::Subsubsection:: *)
(*GammaLeftPNAQ*)


DefineOptions[GammaLeftPNAQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.",Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
GammaLeftPNAQ[seqs:{SequenceP..},ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->GammaLeftPNA,Exclude->{},PassOptions[GammaLeftPNAQ,SequenceQ,ops]];
GammaLeftPNAQ[seq:SequenceP,ops:OptionsPattern[]]:=SequenceQ[seq,Polymer->GammaLeftPNA,Exclude->{},PassOptions[GammaLeftPNAQ,SequenceQ,ops]];

(* --- Strand Version --- *)
GammaLeftPNAQ[str:StrandP,ops:OptionsPattern[]]:=StrandQ[str,Polymer->GammaLeftPNA,PassOptions[GammaLeftPNAQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
GammaLeftPNAQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
GammaLeftPNAQ[sequence:PNA[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
GammaLeftPNAQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
GammaLeftPNAQ[input:Except[_List]]:=False;


(* ::Subsubsection:: *)
(*PeptideQ*)


DefineOptions[PeptideQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* --- Sequence Version --- *)
PeptideQ[seqs:{SequenceP..},ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->Peptide,Exclude->{},PassOptions[PeptideQ,SequenceQ,ops]];
PeptideQ[seq:SequenceP,ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->Peptide,Exclude->{},PassOptions[PeptideQ,SequenceQ,ops]];

(* --- Strand Version --- *)
PeptideQ[strs:{StrandP..},ops:OptionsPattern[]]:= StrandQ[strs,Polymer->Peptide,PassOptions[PeptideQ,StrandQ,ops]];
PeptideQ[str:StrandP,ops:OptionsPattern[]]:= StrandQ[str,Polymer->Peptide,PassOptions[PeptideQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
PeptideQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
PeptideQ[sequence:Peptide[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
PeptideQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
PeptideQ[input:Except[_List]]:=False;



(* ::Subsubsection:: *)
(*LNAChimeraQ*)


DefineOptions[LNAChimeraQ,
	Options :> {
		{Exclude -> Modification, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}
];


(* --- Sequence Version --- *)
LNAChimeraQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->LNAChimera,Exclude->{},PassOptions[LNAChimeraQ,SequenceQ,ops]];
LNAChimeraQ[seq:SequenceP, ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->LNAChimera,Exclude->{},PassOptions[LNAChimeraQ,SequenceQ,ops]];

(* --- Strand Version --- *)
LNAChimeraQ[strs:{StrandP..}, ops:OptionsPattern[]]:= StrandQ[strs,Polymer->LNAChimera,PassOptions[LNAChimeraQ,StrandQ,ops]];
LNAChimeraQ[str:StrandP, ops:OptionsPattern[]]:= StrandQ[str,Polymer->LNAChimera,PassOptions[LNAChimeraQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
LNAChimeraQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
LNAChimeraQ[sequence:LNAChimera[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
LNAChimeraQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
LNAChimeraQ[input:Except[_List]]:=False;



(* ::Subsubsection:: *)
(*ModificationQ*)


DefineOptions[ModificationQ,
	Options :> {
		{Exclude -> {}, PolymerP | {SequenceP...}, "When examining sequences, will exclude the provided Monomers from the valid set of Monomers; When examining strands, will count the provided polymer types as valid."},
		{Degeneracy -> True, BooleanP, "If set to true, the degenrate alphabet will be considered valid."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."}
	}
];


(* --- Sequence Version --- *)
ModificationQ[seqs:{SequenceP..},ops:OptionsPattern[]]:= SequenceQ[seqs,Polymer->Modification,Exclude->{},PassOptions[ModificationQ,SequenceQ,ops]];
ModificationQ[seq:SequenceP,ops:OptionsPattern[]]:= SequenceQ[seq,Polymer->Modification,Exclude->{},PassOptions[ModificationQ,SequenceQ,ops]];

(* --- Strand Version --- *)
ModificationQ[strs:{StrandP..},ops:OptionsPattern[]]:= StrandQ[strs,Polymer->Modification,PassOptions[ModificationQ,StrandQ,ops]];
ModificationQ[str:StrandP,ops:OptionsPattern[]]:= StrandQ[str,Polymer->Modification,PassOptions[ModificationQ,StrandQ,ops]];

(* --- FastTrack versions --- *)
ModificationQ[sequence_String,ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
ModificationQ[sequence:Modification[(_String|_Integer),___],ops:OptionsPattern[]]:=True/;OptionValue[FastTrack];
ModificationQ[sequence:PolymerP[(_String|_Integer),___],ops:OptionsPattern[]]:=False/;OptionValue[FastTrack];

(* --- Catch all Definition --- *)
ModificationQ[input:Except[_List]]:=False;


(* ::Subsubsection:: *)
(*PolymerType*)


DefineOptions[PolymerType,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "If provided, will Set to automatic will attempt to automatically determine the polymer type."},
		{Map -> True, BooleanP, "If set to True, listable defintion maps across the seuences, if set to False check what type of polymer all of the sequences in the list could be."},
		{Consolidate -> True, BooleanP, "If True, consolidates adjacent same polymer types in output list 'types' into a single value.  If False, return a list whose length matches the number of motifs in the strand."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


PolymerType::missMatchPolymer="Provided sequence `1` does not match provided Polymer type `2`";


polymerTypeCore[head_[__]]/;MatchQ[head, PolymerP]:= head;
polymerTypeCore[heads_List]:= polymerTypeCore/@heads;
polymerTypeCore[_]:= $Failed;


(* Sequence version *)
PolymerType[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, map, types, reSeqs, tmpRes, Res},

	safeOps = SafeOptions[PolymerType, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, PolymerType, PassOptions[PolymerType, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[reSeqs]];


	(* if resolving succeeds, then proceed *)
	types = polymerTypeCore[reSeqs];

	If[Map/.safeOps,
		types,
		If[SameQ@@types,
			First[types],
			Message[PolymerType::unConsensus];
			Return[$Failed]
		]
	]

];


PolymerType[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = PolymerType[{seq}, ops]}, If[ListQ[res], First[res], res]];


(* Strand version *)
PolymerType[strd:StrandP, ops:OptionsPattern[]]:= Module[
	{safeOps, polys},

	safeOps = SafeOptions[PolymerType, ToList[ops]];

	(* Pull out the polymers from the strand *)
	polys = PolymerType[strd[Motifs]];

	(* If consolidation is on, then consolidate any repeated polymers *)
	If[Consolidate/.safeOps,
		Split[polys][[All,1]],
		polys
	]

]/;OptionValue[FastTrack];


(* --- Core function: Strands --- *)
PolymerType[str:StrandP,ops:OptionsPattern[]]:= PolymerType[str,FastTrack->True,PassOptions[PolymerType,ops]]/;StrandQ[str,PassOptions[PolymerType,StrandQ,ops]];

(* --- Listable definition --- *)
PolymerType[sequences:{StrandP..}, ops:OptionsPattern[]]:= PolymerType[#,ops]&/@sequences /;OptionValue[Map];


(* ::Subsubsection:: *)
(*UnTypeSequence*)

UnTypeSequence[sequence:PolymerP[length_Integer,___]]:=Module[
	{type,wilds},

	(* Determine the type *)
	type = Head[sequence];

	wilds=Table[Physics`Private`lookupModelOligomer[type,WildcardMonomer],{length}];

	(* Join the result and return untyped *)
	StringJoin[wilds]
];

UnTypeSequence[PolymerP[seq_String,___]]:= seq;

UnTypeSequence[sequence_String]:= sequence;

UnTypeSequence[$Failed]:= $Failed;

SetAttributes[UnTypeSequence,Listable];


(* ::Subsubsection:: *)
(*ExplicitlyTypedQ*)


ExplicitlyTypedQ[PolymerP[(_String|_Integer),___]]:=True;
ExplicitlyTypedQ[Except[_List]]:=False;

SetAttributes[ExplicitlyTypedQ,Listable];


(* ::Subsubsection:: *)
(*ExplicitlyType*)


DefineOptions[ExplicitlyType,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types to the input or given sequence."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output sequence in its type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input or sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


explicitlTypeCore[seq_, reSeq_, explicitlyTypedQ:BooleanP | Automatic]:=
	Switch[explicitlyTypedQ,
		Automatic, If[MatchQ[seq, MotifP], reSeq, UnTypeSequence[reSeq]],
		True, reSeq,
		False, UnTypeSequence[reSeq]
	];

explicitlTypeCore[_, $Failed, ___]:= $Failed;


(*
	Must put this definition first, otherwise mathematica thinks the empty sequence list is
	an empty options list and wrongly hits the other definition
*)
ExplicitlyType[refSeq: _?SequenceQ, seqs:{SequenceP...}, ops:OptionsPattern[]]:= Module[
	{safeOps, type, expType},

	safeOps = SafeOptions[ExplicitlyType, ToList[ops]];

	type = Switch[Polymer/.safeOps,
			Automatic, PolymerType[refSeq, PassOptions[ExplicitlyType, PolymerType, ops]],
			_, Polymer/.safeOps
		];

	expType = Switch[ExplicitlyTyped/.safeOps,
				Automatic, MatchQ[refSeq, MotifP],
				_, ExplicitlyTyped/.safeOps
			];

	ExplicitlyType[seqs,PassOptions[ExplicitlyType,Polymer->type, ExplicitlyTyped->expType,ops]]

];


ExplicitlyType[refSeq: _?SequenceQ, seq:SequenceP, ops:OptionsPattern[]]:= First[ExplicitlyType[refSeq, {seq}, ops]];


ExplicitlyType[seqs:{SequenceP...}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs},

	safeOps = SafeOptions[ExplicitlyType, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ExplicitlyType, PassOptions[ExplicitlyType, resolveSequence, safeOps]];

	MapThread[explicitlTypeCore[#1, #2, ExplicitlyTyped/.safeOps]&, {seqs, reSeqs}]

];


ExplicitlyType[seq:SequenceP, ops:OptionsPattern[]]:= First[ExplicitlyType[{seq}, ops]];


(* ::Subsubsection:: *)
(*ToDNA*)


DefineOptions[ToDNA,
	Options :> {
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{Consolidate -> True, BooleanP, "If True, consolidates sequences in a strand into a single sequence, loosing any motif information.  If False, leaves the sequences and motif information in place."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


toDNACore[seq:(Peptide | Modification)[_, ___]]:= "";
(* For LNAChimera, LDNA, and LRNA remove +, f, and m - in addition replace U with T *)
toDNACore[seq:PolymerP[str_String, name___]]:= DNA[StringReplace[StringDelete[str,{"*","+","f","m"}],"U"->"T"], name];

toDNACore[$Failed] := $Failed;
toDNACore[in_]:= (Message[ToDNA::unResolved, in]; Return[$Failed]);


ToDNA[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes, consldRes},

	safeOps = SafeOptions[ToDNA, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ToDNA, PassOptions[ToDNA, resolveSequence, safeOps]];

	tmpRes = toDNACore/@reSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ToDNA[seq:SequenceP, ops:OptionsPattern[]]:= First[ToDNA[{seq}, ops]];


ToDNA[{}, ops:OptionsPattern[]]:= {};


ToDNA[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{safeOps, seqs, tmpRes, consld, expType, expRes},

	safeOps = SafeOptions[ToDNA, ToList[ops]];

	(* get the sequence level outputs *)
	seqs = strd[Motifs]; (* this dereference does the resolution job *)
	tmpRes = ToDNA[seqs, FastTrack->True, ops];

	(* Join the results into a shared sequence if consolidate is on or we're going to remove the typing (and thus must consolidate) *)
	consld = Consolidate/.safeOps;
	expType = ExplicitlyTyped/.safeOps;

	expRes = Switch[expType,
				False, UnTypeSequence[tmpRes],
				_, tmpRes
			];

	Switch[{consld, expType},
		{_, False}, StringJoin[expRes],
		{True, True | Automatic}, Strand@@sequenceJoinCore[expRes],
		_, Strand@@expRes
	]

];


ToDNA[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= ToDNA[#, ops]&/@strds;


(* ::Subsubsection:: *)
(*ToPeptide*)


DefineOptions[ToPeptide,
	Options :> {
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (Peptide)."},
		{Consolidate -> True, BooleanP, "If True, consolidates sequences in a strand into a single sequence, loosing any motif information.  If False, leaves the sequences and motif information in place."},
		{AlternativeEncodings -> True, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}];

ToPeptide::missMatchPolymer="Provided sequence `1` does not match provided polymer type `2`.";

(* Helper Function: download the packet and memoize results *)
toPeptideCoreParameters:=toPeptideCoreParameters=Module[{},
	Flatten@Download[Model[Physics,Oligomer,"Peptide"],{AlternativeEncodings,AlternativeDegenerateEncodings}]
];

toPeptideCore[Peptide[str_String, name___]]:= Module[
	{pepPatt, split, replaced},

	(* full form peptide pattern *)
	pepPatt = _?UpperCaseQ~~_?LowerCaseQ~~_?LowerCaseQ;
	split = StringSplit[str, x:pepPatt :> x];

	(* replace alternative encoding *)
	replaced = If[!StringMatchQ[#, pepPatt], StringReplace[#, toPeptideCoreParameters], #]&/@split;

	Peptide[StringJoin[replaced], name]

];

toPeptideCore[PolymerP[_, ___]]:= "";
toPeptideCore[$Failed] := $Failed;


ToPeptide[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes, consldRes},

	safeOps = SafeOptions[ToPeptide, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ToPeptide, Polymer->Peptide, AlternativeEncodings->(AlternativeEncodings/.safeOps), PassOptions[ToPeptide, resolveSequence, safeOps]];

	tmpRes = toPeptideCore/@reSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ToPeptide[seq:SequenceP, ops:OptionsPattern[]]:= First[ToPeptide[{seq}, ops]];


ToPeptide[{}, ops:OptionsPattern[]]:= {};


ToPeptide[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{safeOps, seqs, tmpRes, consld, expType, expRes},

	safeOps = SafeOptions[ToPeptide, ToList[ops]];

	(* get the sequence level outputs *)
	seqs = strd[Motifs]; (* this dereference does the resolution job *)
	tmpRes = ToPeptide[seqs, FastTrack->True, ops];

	(* Join the results into a shared sequence if consolidate is on or we're going to remove the typing (and thus must consolidate) *)
	consld = Consolidate/.safeOps;
	expType = ExplicitlyTyped/.safeOps;

	expRes = Switch[expType,
				False, UnTypeSequence[tmpRes],
				_, tmpRes
			];

	Switch[{consld, expType},
		{_, False}, StringJoin[expRes],
		{True, True | Automatic}, Strand@@sequenceJoinCore[expRes],
		_, Strand@@expRes
	]

];


ToPeptide[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= ToPeptide[#, ops]&/@strds;


(* ::Subsubsection:: *)
(*ToRNA*)


DefineOptions[ToRNA,
	Options :> {
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{Consolidate -> True, BooleanP, "If True, consolidates sequences in a strand into a single sequence, loosing any motif information.  If False, leaves the sequences and motif information in place."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


toRNACore[seq:(Peptide | Modification)[_, ___]]:= "";
(* For LNAChimera, LDNA, and LRNA remove +, f, and m - in addition replace T with U *)
toRNACore[seq:PolymerP[str_String, name___]]:= RNA[StringReplace[StringDelete[str,{"*","+","f","m"}],"T"->"U"], name];

toRNACore[$Failed] := $Failed;
toRNACore[in_]:= (Message[ToRNA::unResolved, in]; Return[$Failed]);


ToRNA[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes, consldRes},

	safeOps = SafeOptions[ToRNA, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ToRNA, PassOptions[ToRNA, resolveSequence, safeOps]];

	tmpRes = toRNACore/@reSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ToRNA[seq:SequenceP, ops:OptionsPattern[]]:= First[ToRNA[{seq}, ops]];


ToRNA[{}, ops:OptionsPattern[]]:= {};


ToRNA[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{safeOps, seqs, tmpRes, consld, expType, expRes},

	safeOps = SafeOptions[ToRNA, ToList[ops]];

	(* get the sequence level outputs *)
	seqs = strd[Motifs]; (* this dereference does the resolution job *)
	tmpRes = ToRNA[seqs, FastTrack->True, ops];

	(* Join the results into a shared sequence if consolidate is on or we're going to remove the typing (and thus must consolidate) *)
	consld = Consolidate/.safeOps;
	expType = ExplicitlyTyped/.safeOps;

	expRes = Switch[expType,
				False, UnTypeSequence[tmpRes],
				_, tmpRes
			];

	Switch[{consld, expType},
		{_, False}, StringJoin[expRes],
		{True, True | Automatic}, Strand@@sequenceJoinCore[expRes],
		_, Strand@@expRes
	]

];


ToRNA[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= ToRNA[#, ops]&/@strds;



(* ::Subsubsection:: *)
(*ToLRNA*)


DefineOptions[ToLRNA,
	Options :> {
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{Consolidate -> True, BooleanP, "If True, consolidates sequences in a strand into a single sequence, loosing any motif information.  If False, leaves the sequences and motif information in place."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


toLRNACore[seq:(Peptide | Modification)[_, ___]]:= "";
(* For LNAChimera, LDNA, and LRNA remove +, f, and m - in addition replace T with U *)
toLRNACore[seq:PolymerP[str_String, name___]]:= LRNA[StringReplace[StringDelete[str,{"*","f","m"}],"T"->"U"], name];

toLRNACore[$Failed] := $Failed;
toLRNACore[in_]:= (Message[ToLRNA::unResolved, in]; Return[$Failed]);


ToLRNA[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes, consldRes},

	safeOps = SafeOptions[ToLRNA, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ToLRNA, PassOptions[ToLRNA, resolveSequence, safeOps]];

	tmpRes = toLRNACore/@reSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ToLRNA[seq:SequenceP, ops:OptionsPattern[]]:= First[ToLRNA[{seq}, ops]];


ToLRNA[{}, ops:OptionsPattern[]]:= {};


ToLRNA[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{safeOps, seqs, tmpRes, consld, expType, expRes},

	safeOps = SafeOptions[ToLRNA, ToList[ops]];

	(* get the sequence level outputs *)
	seqs = strd[Motifs]; (* this dereference does the resolution job *)

	tmpRes = ToLRNA[seqs, FastTrack->True, ops];

	(* Join the results into a shared sequence if consolidate is on or we're going to remove the typing (and thus must consolidate) *)
	consld = Consolidate/.safeOps;
	expType = ExplicitlyTyped/.safeOps;

	expRes = Switch[expType,
				False, UnTypeSequence[tmpRes],
				_, tmpRes
			];

	(* Needs a fix here for LRNA converts it to RNA or DNA *)
	Switch[{consld, expType},
		{_, False},
		StringJoin[expRes],

		(* Strand@@ will convert motif to the default polymer for the alphabet which doesn't work well for LRNA *)
		{True, True | Automatic},
		If[MatchQ[sequenceJoinCore[expRes],PolymerP[_String]],
			Strand[sequenceJoinCore[expRes]],
			Strand@@sequenceJoinCore[expRes]
		],

		_,
		Strand@@expRes
	]

];


ToLRNA[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= ToLRNA[#, ops]&/@strds;




(* ::Subsubsection:: *)
(*Monomers*)


DefineOptions[Monomers,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];
Monomers::unknownPolymer="Provided sequence `1` has an unknown polymer type.";
Monomers::missMatchPolymer="Provided sequence `1` does not match provided polymer type `2`.";

monomersCore[seq:MotifP, expType:BooleanP]:=
	With[
		{split = StringCases[UnTypeSequence[seq], allAlphabet[Head[seq], AlternativeEncodings->False]]},
		If[expType, Head[seq]/@split, split]
	];

monomersCore[$Failed, _]:= $Failed;
monomersCore[in_, ___]:= (Message[Monomers::unResolved, in]; Return[$Failed]);


Monomers[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, expType},

	safeOps = SafeOptions[Monomers, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, Monomers, PassOptions[Monomers, resolveSequence, safeOps]];

	expType = ExplicitlyTyped/.safeOps;

	Switch[expType,
		Automatic, MapThread[monomersCore[#1, MatchQ[#2, MotifP]]&, {reSeqs, seqs}],
		_, Map[monomersCore[#, expType]&, reSeqs]
	]

];


Monomers[seq:SequenceP, ops:OptionsPattern[]]:= First[Monomers[{seq}, ops]];


(* --- Oligo version --- *)
(*Monomers[oligo:ListableP[ObjectP[{Object[Sample], Model[Sample]}], ops:OptionsPattern[Monomers]] := Monomers[Strand/.Info[oligo], ops];*)

(* --- Strand version --- *)
Monomers[str:StrandP,ops:OptionsPattern[]]:=Module[
	{sequences, monos},

	(* Extract the sequences *)
	sequences = str[Motifs];

	(* Pull out the Monomers from the sequences *)
	monos = Monomers[sequences,ops];

	(* Return the Monomers in one long list *)
	Flatten[monos]

]/;OptionValue[FastTrack];

(* --- Core Strand Function --- *)
Monomers[str:StrandP, ops:OptionsPattern[]]:= Monomers[str,FastTrack->True,ops]/;StrandQ[str,PassOptions[Monomers,StrandQ,ops]];
Monomers[strs:{StrandP..}, ops:OptionsPattern[]]:= Map[Monomers[#,FastTrack->True,ops]&, strs] /;And@@StrandQ[strs,PassOptions[Monomers,StrandQ,ops]];


Monomers[$Failed, ___]:= $Failed;
Monomers[seqs:{($Failed | SequenceP)..}, ops:OptionsPattern[]]:= Monomers[#, ops]&/@seqs;


Monomers[NestedStrds:{{_?StrandQ..}..}, ops:OptionsPattern[]]:= Monomers[#, ops]&/@NestedStrds;


(* ::Subsubsection:: *)
(*Dimers*)


DefineOptions[Dimers,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potential alphabet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, True | False | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume True if passed an explicitly typed input sequence and False if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


monosJoin[{seqA:PolymerP[strA_String, ___], seqB:PolymerP[strB_String, ___]}]:= Head[seqA][StringJoin[strA, strB]];


dimersCore[monos:{MotifP..}]:= monosJoin/@Partition[monos, 2, 1];
dimersCore[$Failed]:= $Failed;


Dimers[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, monos, groups, joined, expType},

	safeOps = SafeOptions[Dimers, ToList[ops]];

	(* Determine the list of Monomers in the sequence *)
	monos = Monomers[seqs, ExplicitlyTyped->True, PassOptions[Dimers, Monomers, safeOps]];

	joined = dimersCore/@monos;

	(* Restablish explicit typing if requested *)
	expType = ExplicitlyTyped/.safeOps;

	Switch[expType,
		Automatic, MapThread[If[MatchQ[#1, MotifP],
								#2,
								UnTypeSequence[#2]
							]&, {seqs, joined}
					],

		True, joined,
		False, UnTypeSequence[joined]
	]

];


Dimers[seq:SequenceP, ops:OptionsPattern[]]:= First[Dimers[{seq}, ops]];


Dimers[$Failed, ___]:= $Failed;
Dimers[seqs:{($Failed | SequenceP)..}, ops:OptionsPattern[]]:= Dimers[#, ops]&/@seqs;


(* ::Subsubsection:: *)
(*ReverseSequence*)


DefineOptions[ReverseSequence,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


(* For an arbitrary type of polymer, the alphabet is not necessarily a single letter and the entire monomer letter needs to be replaced *)
revCore[seq:PolymerP[str_String, ___]]:= sequenceJoinCore[Reverse[Monomers[seq, FastTrack->True]]];

revCore[$Failed] := $Failed;
revCore[in_String]:= in;
revCore[in_]:= (Message[ReverseSequence::unResolved, in]; Return[$Failed]);


ReverseSequence[seqs:{(SequenceP | $Failed)..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes},

	safeOps = SafeOptions[ReverseSequence, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ReverseSequence, PassOptions[ReverseSequence, resolveSequence, safeOps]];

	tmpRes = revCore/@reSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ReverseSequence[seq:SequenceP | $Failed, ops:OptionsPattern[]]:= First[ReverseSequence[{seq}, ops]];


ReverseSequence[strd:_?StrandQ, ops:OptionsPattern[]]:= Strand@@Reverse[ReverseSequence[strd[Motifs],
	Sequence@@ReplaceRule[{ops},{ExplicitlyTyped->True, FastTrack->True}]]];


ReverseSequence[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= Map[ReverseSequence[#,Sequence@@ReplaceRule[{ops},{ FastTrack->True}]]&, strds];


(* ::Subsubsection:: *)
(*ReverseSequenceQ*)


DefineOptions[ReverseSequenceQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true any possible varients of the degenercy match the reverse will be considered acceptable."},
		{CanonicalPairing -> True, BooleanP, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


revQCore[seqA:MotifP, seqB:MotifP, degenQ:BooleanP, canonQ:BooleanP]:= Module[
	{canonA, canonB},

	(* turn into canonical sequences or not *)
	{canonA, canonB} = If[canonQ,
						{toDNACore[seqA], toDNACore[seqB]},
						{seqA, seqB}
					];

	Or[
		SameSequenceQ[{
			canonA,
			revCore[canonB]
		}, Degeneracy->degenQ],

		(* if they are Peptides or Modifications *)
		MatchQ[{canonA, canonB}, {"", ""}]

	]

];

revQCore[$Failed, ___]:= False;
revQCore[_, $Failed, ___]:= False;


ReverseSequenceQ[seqsA:{SequenceP..}, seqsB:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{lenA, lenB, safeOps, reSeqs, reSeqsA, reSeqsB},

	(* if input mutiple sequences and rotation numbers, check if lengths match *)
	lenA = Length[seqsA];
	lenB = Length[seqsB];

	If[lenA!=lenB,
		Message[ReverseSequenceQ::unmMatchLength, lenA, lenB];
		Return[$Failed]
	];

	safeOps = SafeOptions[ReverseSequenceQ, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[Join[seqsA, seqsB], ReverseSequenceQ, PassOptions[ReverseSequenceQ, resolveSequence, safeOps]]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[{False}]];

	{reSeqsA, reSeqsB} = FoldPairList[TakeDrop, reSeqs, {lenA, lenB}];

	MapThread[revQCore[#1, #2, Degeneracy/.safeOps, CanonicalPairing/.safeOps]&, {reSeqsA, reSeqsB}]

];


ReverseSequenceQ[seqsA:{SequenceP..}, seqB:SequenceP, ops: OptionsPattern[]]:= ReverseSequenceQ[seqsA, ConstantArray[seqB, Length[seqsA]], ops];


ReverseSequenceQ[seqA:SequenceP, seqsB:{SequenceP..}, ops: OptionsPattern[]]:= ReverseSequenceQ[ConstantArray[seqA, Length[seqsB]], seqsB, ops];


ReverseSequenceQ[seqA:SequenceP, seqB:SequenceP, ops:OptionsPattern[]]:= First[ReverseSequenceQ[{seqA}, {seqB}, ops]];


ReverseSequenceQ[strdA:_?StrandQ, strdB:_?StrandQ, ops:OptionsPattern[]]:= And@@ReverseSequenceQ[strdA[Motifs], Reverse[strdB[Motifs]], FastTrack->True, ops];


(* ::Subsubsection:: *)
(*ComplementSequence*)


DefineOptions[ComplementSequence,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{IncludeModification -> True, True | False, "If False, removes modifications from the returned complement sequence or strand."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


ComplementSequence::RemoveModification="No ComplementSequence exists for the given sequence and it cannot be removed. Returning Null";

(* Helper Function: download the packet and memoize results *)
compCorePairs[polymerType:PolymerP]:=compCorePairs[polymerType]=
	Physics`Private`lookupModelOligomer[polymerType,Complements];

compCore[seq:MotifP]:= If[MatchQ[Head[seq], Peptide | Modification],
							seq,
							Head[seq][StringReplace[UnTypeSequence[seq], compCorePairs[Head[seq]]]]
					];

compCore[$Failed] := $Failed;
compCore[in_String]:= in;
compCore[in_]:= (Message[ComplementSequence::unResolved, in]; Return[$Failed]);


filterModifPep[resolved_, original_, IncludeModificationQ:BooleanP]:= If[IncludeModificationQ,
																		{resolved, original},
																		With[{tmp = Select[Transpose[{resolved, original}], !MatchQ[Head[First[#]], Peptide | Modification]&]},
																			If[MatchQ[tmp, {}],
																				{{}, {}},
																				Transpose[tmp]
																			]
																		]
																	];


ComplementSequence[seqs:{(SequenceP | $Failed)..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, seqsPost, reSeqsPost, tmpRes},

	safeOps = SafeOptions[ComplementSequence, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, ComplementSequence, PassOptions[ComplementSequence, resolveSequence, safeOps]];

	(* whether to include modification *)
	{reSeqsPost, seqsPost} = filterModifPep[reSeqs, seqs, IncludeModification/.safeOps];

	If[MatchQ[reSeqsPost, {}],
		Message[ComplementSequence::RemoveModification];
		Return[ConstantArray[Null, Length[seqs]]]
	];

	tmpRes = compCore/@reSeqsPost;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqsPost, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ComplementSequence[seq:SequenceP | $Failed, ops:OptionsPattern[]]:= First[ComplementSequence[{seq}, ops]];


ComplementSequence[{}, ops:OptionsPattern[]]:= {};


ComplementSequence[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{strdPost},

	strdPost = If[OptionDefault[OptionValue[IncludeModification]],
		strd,
		DeleteCases[strd, _Modification|_Peptide]
	];

	(* need to do this wacky DeleteDuplicatesBy because ReplaceRule doesn't see this high in the hierarchy (it should probably live in WLExtension but whatever *)
	Strand@@ComplementSequence[strdPost[Motifs], DeleteDuplicatesBy[Join[{ExplicitlyTyped->True, FastTrack->True}, ToList[ops]], #[[1]]&]]

];


ComplementSequence[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= Map[ComplementSequence[#, FastTrack->True, ops]&, strds];


(* ::Subsubsection:: *)
(*ComplementSequenceQ*)


DefineOptions[ComplementSequenceQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true any possible varients of the degenercy match the complement will be considered acceptable."},
		{CanonicalPairing -> True, BooleanP, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


compQCore[seqA:(_Peptide | _Modification), seqB:(_Peptide | _Modification), _, _]:= False;

compQCore[seqA:MotifP, seqB:MotifP, degenQ:BooleanP, canonQ:BooleanP]:= Module[
	{canonA, canonB},

	(* turn into canonical sequences or not *)
	{canonA, canonB} = If[canonQ,
						{toDNACore[seqA], toDNACore[seqB]},
						{seqA, seqB}
					];

	SameSequenceQ[{
			canonA,
			compCore[canonB]
		}, Degeneracy->degenQ
	]

];

compQCore[$Failed, ___]:= False;
compQCore[_, $Failed, ___]:= False;


ComplementSequenceQ[seqsA:{SequenceP..}, seqsB:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{lenA, lenB, safeOps, reSeqs, reSeqsA, reSeqsB},

	(* if input mutiple sequences and rotation numbers, check if lengths match *)
	lenA = Length[seqsA];
	lenB = Length[seqsB];

	If[lenA!=lenB,
		Message[ComplementSequenceQ::unmMatchLength, lenA, lenB];
		Return[$Failed]
	];

	safeOps = SafeOptions[ComplementSequenceQ, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[Join[seqsA, seqsB], ComplementSequenceQ, PassOptions[ComplementSequenceQ, resolveSequence, safeOps]]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[{False}]];

	{reSeqsA, reSeqsB} = FoldPairList[TakeDrop, reSeqs, {lenA, lenB}];

	MapThread[compQCore[#1, #2, Degeneracy/.safeOps, CanonicalPairing/.safeOps]&, {reSeqsA, reSeqsB}]

];


ComplementSequenceQ[seqsA:{SequenceP..}, seqB:SequenceP, ops: OptionsPattern[]]:= ComplementSequenceQ[seqsA, ConstantArray[seqB, Length[seqsA]], ops];


ComplementSequenceQ[seqA:SequenceP, seqsB:{SequenceP..}, ops: OptionsPattern[]]:= ComplementSequenceQ[ConstantArray[seqA, Length[seqsB]], seqsB, ops];


ComplementSequenceQ[seqA:SequenceP, seqB:SequenceP, ops:OptionsPattern[]]:= First[ComplementSequenceQ[{seqA}, {seqB}, ops]];


ComplementSequenceQ[strdA:_?StrandQ, strdB:_?StrandQ, ops:OptionsPattern[]]:= And@@ComplementSequenceQ[strdA[Motifs], strdB[Motifs], FastTrack->True, ops];


(* ::Subsubsection:: *)
(*ReverseComplementSequence*)


DefineOptions[ReverseComplementSequence,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potential alphabet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not.  If a strand is provided and ExplicitlyTyped is set to false, will strip off all strand and polymer wrappers and return only a raw sequence."},
		{Motif -> Automatic, BooleanP | Automatic, "If set to true, assumes you're dealing with a motif name you want the ReverseComplementSequence of, if set to false, assumes you want the sequence.  Automatic will attempt to guess but assumes sequences in the ambiguous case: e.g. ReverseComplementSequence[\"A\"]."},
		{IncludeModification -> True, True | False, "If False, removes modifications from the returned complement sequence or strand."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


restoreMotif[before_String, after_, motifQ:BooleanP | Automatic]:= Switch[motifQ,
																	Automatic, If[MatchQ[after, MotifP], after, before],
																	True, before,
																	False, If[MatchQ[after, MotifP], after, $Failed]
																];
restoreMotif[before:MotifP, $Failed, _]:= $Failed;
restoreMotif[before:PolymerP[_, motif_String], after:PolymerP[seq_String], _]:= Head[after][seq, motif];
restoreMotif[before_, after_, _]:= after;


revCompMotif[typed:PolymerP[seq_, motif_String]]:= Head[typed][seq, revCompMotif[motif]];
revCompMotif[typed:PolymerP[seq_]]:= typed;
revCompMotif[motif_String]:= StringReplace[motif, {head___~~"'":>head, head___~~tl:Except["'"]:>head<>tl<>"'"}];
revCompMotif[$Failed]:= $Failed;


ReverseComplementSequence[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, reSeqsPost, seqsPost, revSeqs, revCompSeqs, restoredSeqs, tmpRes},

	safeOps = SafeOptions[ReverseComplementSequence, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[seqs, ReverseComplementSequence, PassOptions[ReverseComplementSequence, resolveSequence, safeOps]]];

	(* whether to include modification *)
	{reSeqsPost, seqsPost} = filterModifPep[reSeqs, seqs, IncludeModification/.safeOps];

	If[MatchQ[reSeqsPost, {}],
		Message[ComplementSequence::RemoveModification];
		Return[ConstantArray[Null, Length[seqs]]]
	];

	(* rev and comp *)
	revSeqs = ReverseSequence[reSeqsPost, FastTrack->True, PassOptions[ReverseComplementSequence, ReverseSequence, safeOps]];
	revCompSeqs = ComplementSequence[revSeqs, FastTrack->True, ExplicitlyTyped->True, PassOptions[ReverseComplementSequence, ComplementSequence, safeOps]];

	(* postprocessing resulting sequences, add motif name back if any and restore strings if there was any *)
	restoredSeqs = MapThread[restoreMotif[#1, #2, Motif/.safeOps]&, {seqsPost, revCompSeqs}];

	tmpRes = revCompMotif/@restoredSeqs;

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqsPost, tmpRes}],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


ReverseComplementSequence[seq:SequenceP, ops:OptionsPattern[]]:= First[ReverseComplementSequence[{seq}, ops]];


ReverseComplementSequence[nestedSeqs:{{SequenceP..}..}, ops:OptionsPattern[]]:= ReverseComplementSequence[#, ops]&/@nestedSeqs;


ReverseComplementSequence[{}, ops:OptionsPattern[]]:= {};


ReverseComplementSequence[strd:_?StrandQ, ops:OptionsPattern[]]:= Module[
	{strdPost},

	strdPost = If[OptionDefault[OptionValue[IncludeModification]],
		strd,
		DeleteCases[strd, _Modification|_Peptide]
	];

	(* need to do this wacky DeleteDuplicatesBy because ReplaceRule doesn't see this high in the hierarchy (it should probably live in WLExtension but whatever *)
	Strand@@Reverse[ReverseComplementSequence[strdPost[Motifs], DeleteDuplicatesBy[Join[{ExplicitlyTyped->True, FastTrack->True}, ToList[ops]], #[[1]]&]]]

];


ReverseComplementSequence[strds:{_?StrandQ..}, ops:OptionsPattern[]]:= Map[ReverseComplementSequence[#, FastTrack->True, ops]&, strds];


(* ::Subsubsection:: *)
(*ReverseComplementSequenceQ*)


DefineOptions[ReverseComplementSequenceQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potential alphabet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to True any possible varients of the degenercy match the reverse complement will be considered acceptable."},
		{Motif -> Automatic, BooleanP | Automatic, "If set to True, assumes you're dealing with a motif name you want the ReverseComplementSequenceQ of, if set to false, assumes you are asking about sequences.  Automatic will attempt to guess but assumes sequences in the ambigous case: e.g. ReverseComplementSequenceQ[\"AT\",\"AT\"]."},
		{CanonicalPairing -> True, BooleanP, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


revcompQCore[seqA:(_Peptide | _Modification), seqB:(_Peptide | _Modification), ___]:= False;

revcompQCore[seqA:(MotifP | $Failed), seqB:(MotifP | $Failed), origA:(MotifP | _String), origB:(MotifP | _String), degenQ:BooleanP, canonQ:BooleanP, motifQ:(BooleanP | Automatic)]:= Module[
	{canonA, canonB, restoredA, restoredB},

	(* turn into canonical sequences or not *)
	{canonA, canonB} = If[canonQ,
						{toDNACore[seqA], toDNACore[seqB]},
						{seqA, seqB}
					];

	restoredA = restoreMotif[origA, canonA, motifQ];
	restoredB = revCompMotif[restoreMotif[origB, compCore[revCore[canonB]], motifQ]];

	(* if cannot even restore *)
	If[MatchQ[{restoredA, restoredB}, {$Failed, $Failed}], Return[False]];

	Or[
		SameSequenceQ[{
				restoredA,
				restoredB
			}, Degeneracy->degenQ],

		(* if both are motif names (strings) *)
		MatchQ[restoredA, restoredB]
	]

];


ReverseComplementSequenceQ[seqsA:{SequenceP..}, seqsB:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{lenA, lenB, safeOps, reSeqs, reSeqsA, reSeqsB},

	(* if input mutiple sequences and rotation numbers, check if lengths match *)
	lenA = Length[seqsA];
	lenB = Length[seqsB];

	If[lenA!=lenB,
		Message[ReverseComplementSequenceQ::unmMatchLength, lenA, lenB];
		Return[$Failed]
	];

	safeOps = SafeOptions[ReverseComplementSequenceQ, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[Join[seqsA, seqsB], ReverseComplementSequenceQ, PassOptions[ReverseComplementSequenceQ, resolveSequence, safeOps]]];

	{reSeqsA, reSeqsB} = FoldPairList[TakeDrop, reSeqs, {lenA, lenB}];

	MapThread[revcompQCore[#1, #2, #3, #4, Degeneracy/.safeOps, CanonicalPairing/.safeOps, Motif/.safeOps]&, {reSeqsA, reSeqsB, seqsA, seqsB}]

];


ReverseComplementSequenceQ[seqsA:{SequenceP..}, seqB:SequenceP, ops: OptionsPattern[]]:= ReverseComplementSequenceQ[seqsA, ConstantArray[seqB, Length[seqsA]], ops];


ReverseComplementSequenceQ[seqA:SequenceP, seqsB:{SequenceP..}, ops: OptionsPattern[]]:= ReverseComplementSequenceQ[ConstantArray[seqA, Length[seqsB]], seqsB, ops];


ReverseComplementSequenceQ[seqA:SequenceP, seqB:SequenceP, ops:OptionsPattern[]]:= First[ReverseComplementSequenceQ[{seqA}, {seqB}, ops]];


ReverseComplementSequenceQ[strdA:_?StrandQ, strdB:_?StrandQ, ops:OptionsPattern[]]:= And@@ReverseComplementSequenceQ[strdA[Motifs], Reverse[strdB[Motifs]], FastTrack->True, ops];


ReverseComplementSequenceQ[{}, {}, ops:OptionsPattern[]]:= True;


(* ::Subsubsection:: *)
(*SequencePalindromeQ*)


DefineOptions[SequencePalindromeQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to true, the integer based polymers of length n are joined by including the widcard monomer n times."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


toPeptideCore[seq:MotifP, degenQ:BooleanP]:= If[OddQ[SequenceLength[seq, FastTrack->True]],
												False,
												ReverseComplementSequenceQ[seq, seq, FastTrack->True, Degeneracy->degenQ]
											];

toPeptideCore[$Failed, ___]:= False;


SequencePalindromeQ[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes, consldRes},

	safeOps = SafeOptions[SequencePalindromeQ, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = Quiet[resolveSequence[seqs, SequencePalindromeQ, PassOptions[SequencePalindromeQ, resolveSequence, safeOps]]];

	toPeptideCore[#, Degeneracy/.safeOps]&/@reSeqs

];


SequencePalindromeQ[seq:SequenceP, ops:OptionsPattern[]]:= First[SequencePalindromeQ[{seq}, ops]];


(* ::Subsubsection:: *)
(*SequenceLength*)


DefineOptions[SequenceLength,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];

(* Only for DNA RNA and PNA we have a single letter alphabets *)
sequenceLengthCore[seq:MotifP]:= If[MatchQ[Head[seq],PolymerP],
	If[!MatchQ[Head[seq],DNA|RNA|PNA],
		StringCount[UnTypeSequence[seq], allAlphabet[Head[seq], AlternativeEncodings->False]],
		StringLength[UnTypeSequence[seq]]
	]
];

sequenceLengthCore[$Failed] := $Failed;
sequenceLengthCore[in_]:= (Message[SequenceLength::unResolved, in]; Return[$Failed]);


SequenceLength["" | PolymerP["", ___], ops:OptionsPattern[]]:= 0;


SequenceLength[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs},

	safeOps = SafeOptions[SequenceLength, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceLength, PassOptions[SequenceLength, resolveSequence, safeOps]];

	sequenceLengthCore/@reSeqs

];


SequenceLength[seq:SequenceP, ops:OptionsPattern[]]:= First[SequenceLength[{seq}, ops]];


(* ::Subsubsection:: *)
(*SequenceJoin*)


DefineOptions[SequenceJoin,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the Monomers in their polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{Degeneracy -> True, BooleanP, "If set to true, the integer based polymers of length n are joined by including the widcard monomer n times."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


sequenceJoinCore[seqs:{MotifP..}]:= Head[First[seqs]][StringJoin[UnTypeSequence[seqs]]];
sequenceJoinCore[seqs:{_String..}]:= StringJoin[seqs];
sequenceJoinCore[in_]:= (Message[SequenceJoin::unResolved, in]; Return[$Failed]);


SequenceJoin[seqs:{SequenceP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, type, untyped, joined, firstTyped, matchNot},

	safeOps = SafeOptions[SequenceJoin, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceJoin, PassOptions[SequenceJoin, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MemberQ[reSeqs, $Failed], Return[$Failed]];

	(* check consensus *)
	If[!SameQ@@PolymerType[reSeqs, FastTrack->True],
		Message[SequenceJoin::unConsensus];
		Return[$Failed]
	];

	(* if resolving succeeds, then proceed *)
	joined = sequenceJoinCore[reSeqs];

	(* if unresolved due to FastTrack and cannot be joined, return Failed *)
	If[MatchQ[joined, $Failed], Return[$Failed]];

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, If[MatchQ[seqs, {_String..}],
					(* if only untyped strings, then output a string *)
					UnTypeSequence[joined],
					joined
				],
		True, joined,
		False, UnTypeSequence[joined]
	]

];


(* handle the edge case an empty list is passed to the function *)
SequenceJoin[{}, ops:OptionsPattern[]]:= {};

(* sequence (rather than list) version of sequence join *)
SequenceJoin[sequences__?SequenceQ, ops:OptionsPattern[]]:= SequenceJoin[{sequences},ops];
(* WARNING: This version of the function is crazy slow, thanks to Pattern Matching rules for Options !!! *)


(* ::Subsubsection:: *)
(*SequenceFirst*)


DefineOptions[SequenceFirst,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


SequenceFirst[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceTake[seqs, 1, ops];


SequenceFirst[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = SequenceFirst[{seq}, ops]}, If[!MatchQ[res, $Failed], First[res], $Failed]];


SequenceFirst[{}, ops:OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceLast*)


DefineOptions[SequenceLast,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


SequenceLast[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceTake[seqs, -1, ops];


SequenceLast[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = SequenceLast[{seq}, ops]}, If[!MatchQ[res, $Failed], First[res], $Failed]];


SequenceLast[{}, ops:OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceRest*)


DefineOptions[SequenceRest,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


SequenceRest[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceDrop[seqs, 1, ops];


SequenceRest[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = SequenceRest[{seq}, ops]}, If[!MatchQ[res, $Failed], First[res], $Failed]];


SequenceRest[{}, ops:OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceMost*)


DefineOptions[SequenceMost,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


SequenceMost[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceDrop[seqs, -1, ops];


SequenceMost[seq:SequenceP, ops:OptionsPattern[]]:= With[{res = SequenceMost[{seq}, ops]}, If[!MatchQ[res, $Failed], First[res], $Failed]];


SequenceMost[{}, ops:OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceTake*)


DefineOptions[SequenceTake,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


sequenceTakeCore[seqs:{MotifP..}, Span[m_Integer, n_Integer]]:= If[validSpanQ[Length[seqs], m, n],
																	SequenceJoin[Take[seqs, {m, n}], FastTrack->True],
																	(Message[SequenceTake::invalidSpan, ToString[m], ToString[n]];
																	Return[$Failed])
																];

sequenceTakeCore[seqs:{MotifP..}, n_Integer]:= sequenceTakeCore[seqs, If[n > 0, Span[1, n], Span[n, -1]]];

sequenceTakeCore[$Failed, ___]:= $Failed;
sequenceTakeCore[in_]:= (Message[SequenceTake::unResolved, in]; Return[$Failed]);


SequenceTake[seqs:{SequenceP..}, indx: {(_Integer | _Span)..}, ops: OptionsPattern[]]:= Module[
	{seqLen, idxLen, safeOps, reSeqs, monos, tmpRes},

	(* if input mutiple sequences and indices, check if lengths match *)
	seqLen = Length[seqs];
	idxLen = Length[indx];

	If[seqLen!=idxLen && seqLen!=1,
		Message[SequenceTake::unmMatchLength, seqLen, idxLen];
		Return[$Failed]
	];


	safeOps = SafeOptions[SequenceTake, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceTake, PassOptions[SequenceTake, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[reSeqs]];

	(* get monomers and then pass into the core function *)
	monos = Monomers[reSeqs, FastTrack->True];

	tmpRes = Switch[seqLen,
				1, sequenceTakeCore[First[monos], #]&/@indx,
				_, MapThread[sequenceTakeCore[#1, #2]&, {monos, indx}]
			];

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, Switch[seqLen,
					1, If[MatchQ[First[seqs], MotifP], tmpRes, UnTypeSequence[tmpRes]],
					_, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}]
				],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


SequenceTake[seqs:{SequenceP..}, indx: (_Integer | _Span), ops: OptionsPattern[]]:= SequenceTake[seqs, ConstantArray[indx, Length[seqs]], ops];


SequenceTake[seq:SequenceP, indx: {(_Integer | _Span)..}, ops: OptionsPattern[]]:= SequenceTake[{seq}, indx, ops];


SequenceTake[seq:SequenceP, indx: (_Integer | _Span), ops: OptionsPattern[]]:= First[SequenceTake[{seq}, {indx}, ops]];


SequenceTake[{}, _, ops: OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceDrop*)


DefineOptions[SequenceDrop,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


sequenceDropCore[seqs:{MotifP..}, Span[m_Integer, n_Integer]]:= If[validSpanQ[Length[seqs], m, n],
																	SequenceJoin[Drop[seqs, {m, n}], FastTrack->True],
																	(Message[SequenceDrop::invalidSpan, ToString[m], ToString[n]];
																	Return[$Failed])
																];

sequenceDropCore[seqs:{MotifP..}, n_Integer]:= sequenceDropCore[seqs, If[n > 0, Span[1, n], Span[n, -1]]];

sequenceDropCore[$Failed, ___]:= $Failed;
sequenceDropCore[in_]:= (Message[SequenceDrop::unResolved, in]; Return[$Failed]);


SequenceDrop[seqs:{SequenceP..}, indx: {(_Integer | _Span)..}, ops: OptionsPattern[]]:= Module[
	{seqLen, idxLen, safeOps, reSeqs, monos, tmpRes},

	(* if input mutiple sequences and indices, check if lengths match *)
	seqLen = Length[seqs];
	idxLen = Length[indx];

	If[seqLen!=idxLen && seqLen!=1,
		Message[SequenceDrop::unmMatchLength, seqLen, idxLen];
		Return[$Failed]
	];


	safeOps = SafeOptions[SequenceDrop, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceDrop, PassOptions[SequenceDrop, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[reSeqs]];

	(* get monomers and then pass into the core function *)
	monos = Monomers[reSeqs, FastTrack->True];

	tmpRes = Switch[seqLen,
				1, sequenceDropCore[First[monos], #]&/@indx,
				_, MapThread[sequenceDropCore[#1, #2]&, {monos, indx}]
			];

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, Switch[seqLen,
					1, If[MatchQ[First[seqs], MotifP], tmpRes, UnTypeSequence[tmpRes]],
					_, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}]
				],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


SequenceDrop[seqs:{SequenceP..}, indx: (_Integer | _Span), ops: OptionsPattern[]]:= SequenceDrop[seqs, ConstantArray[indx, Length[seqs]], ops];


SequenceDrop[seq:SequenceP, indx: {(_Integer | _Span)..}, ops: OptionsPattern[]]:= SequenceDrop[{seq}, indx, ops];


SequenceDrop[seq:SequenceP, indx: (_Integer | _Span), ops: OptionsPattern[]]:= First[SequenceDrop[{seq}, {indx}, ops]];


SequenceDrop[{}, _, ops: OptionsPattern[]]:= {};


(* ::Subsubsection:: *)
(*SequenceRotateRight*)


DefineOptions[SequenceRotateRight,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


seqRotateRightCore[seq:(Peptide | Modification | LNAChimera)[str_String, ___], n_Integer]:= With[
	{monos = Monomers[seq, FastTrack->True]},

	If[Mod[n, Length[monos]]==0,
		seq,
		sequenceJoinCore[RotateRight[monos, n]]
	]
];

seqRotateRightCore[seq:PolymerP[str_String, ___], n_Integer]:= If[Mod[n, StringLength[str]]==0, seq, Head[seq][StringRotateRight[str, n]]];

seqRotateRightCore[$Failed] := $Failed;
seqRotateRightCore[in_]:= (Message[SequenceRotateRight::unResolved, in]; Return[$Failed]);


SequenceRotateRight[seqs:{SequenceP..}, n:{_Integer..}, ops:OptionsPattern[]]:= Module[
	{seqLen, nLen, safeOps, reSeqs, tmpRes},

	(* if input mutiple sequences and rotation numbers, check if lengths match *)
	seqLen = Length[seqs];
	nLen = Length[n];

	If[seqLen!=nLen && seqLen!=1,
		Message[SequenceRotateRight::unmMatchLength, seqLen, nLen];
		Return[$Failed]
	];

	safeOps = SafeOptions[SequenceRotateRight, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceRotateRight, PassOptions[SequenceRotateRight, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[reSeqs]];

	tmpRes = Switch[seqLen,
				1, seqRotateRightCore[First[reSeqs], #]&/@n,
				_, MapThread[seqRotateRightCore[#1, #2]&, {reSeqs, n}]
			];

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, Switch[seqLen,
					1, If[MatchQ[First[seqs], MotifP], tmpRes, UnTypeSequence[tmpRes]],
					_, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}]
				],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


SequenceRotateRight[seqs:{SequenceP..}, n_Integer, ops: OptionsPattern[]]:= SequenceRotateRight[seqs, ConstantArray[n, Length[seqs]], ops];


SequenceRotateRight[seq:SequenceP, n:{_Integer..}, ops: OptionsPattern[]]:= SequenceRotateRight[{seq}, n, ops];


SequenceRotateRight[seq:SequenceP, n_Integer, ops:OptionsPattern[]]:= First[SequenceRotateRight[{seq}, {n}, ops]];


SequenceRotateRight[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceRotateRight[seqs, 1, ops];


SequenceRotateRight[seq:SequenceP, ops:OptionsPattern[]]:= SequenceRotateRight[seq, 1, ops];


(* ::Subsubsection:: *)
(*SequenceRotateLeft*)


DefineOptions[SequenceRotateLeft,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{ExplicitlyTyped -> Automatic, BooleanP | Automatic, "If true, wraps the output in its polymer type (eg. DNA[\"A\"]).  Automatic will assume true if passed an explicitly typed input sequence and false if not."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


seqRotateLeftCore[seq:(Peptide | Modification | LNAChimera)[str_String, ___], n_Integer]:= With[
	{monos = Monomers[seq, FastTrack->True]},

	If[Mod[n, Length[monos]]==0,
		seq,
		sequenceJoinCore[RotateLeft[monos, n]]
	]
];

seqRotateLeftCore[seq:PolymerP[str_String, ___], n_Integer]:= If[Mod[n, StringLength[str]]==0, seq, Head[seq][StringRotateLeft[str, n]]];

seqRotateLeftCore[$Failed] := $Failed;
seqRotateLeftCore[in_]:= (Message[SequenceRotateLeft::unResolved, in]; Return[$Failed]);


SequenceRotateLeft[seqs:{SequenceP..}, n:{_Integer..}, ops:OptionsPattern[]]:= Module[
	{seqLen, nLen, safeOps, reSeqs, tmpRes},

	(* if input mutiple sequences and rotation numbers, check if lengths match *)
	seqLen = Length[seqs];
	nLen = Length[n];

	If[seqLen!=nLen && seqLen!=1,
		Message[SequenceRotateLeft::unmMatchLength, seqLen, nLen];
		Return[$Failed]
	];

	safeOps = SafeOptions[SequenceRotateLeft, ToList[ops]];

	(* resolve to typed sequences *)
	reSeqs = resolveSequence[seqs, SequenceRotateLeft, PassOptions[SequenceRotateLeft, resolveSequence, safeOps]];

	(* if resolving failed, return failed *)
	If[MatchQ[reSeqs, {$Failed..}], Return[reSeqs]];

	tmpRes = Switch[seqLen,
				1, seqRotateLeftCore[First[reSeqs], #]&/@n,
				_, MapThread[seqRotateLeftCore[#1, #2]&, {reSeqs, n}]
			];

	Switch[ExplicitlyTyped/.safeOps,
		Automatic, Switch[seqLen,
					1, If[MatchQ[First[seqs], MotifP], tmpRes, UnTypeSequence[tmpRes]],
					_, MapThread[If[MatchQ[#1, MotifP], #2, UnTypeSequence[#2]]&, {seqs, tmpRes}]
				],
		True, tmpRes,
		False, UnTypeSequence[tmpRes]
	]

];


SequenceRotateLeft[seqs:{SequenceP..}, n_Integer, ops: OptionsPattern[]]:= SequenceRotateLeft[seqs, ConstantArray[n, Length[seqs]], ops];


SequenceRotateLeft[seq:SequenceP, n:{_Integer..}, ops: OptionsPattern[]]:= SequenceRotateLeft[{seq}, n, ops];


SequenceRotateLeft[seq:SequenceP, n_Integer, ops:OptionsPattern[]]:= First[SequenceRotateLeft[{seq}, {n}, ops]];


SequenceRotateLeft[seqs:{SequenceP..}, ops:OptionsPattern[]]:= SequenceRotateLeft[seqs, 1, ops];


SequenceRotateLeft[seq:SequenceP, ops:OptionsPattern[]]:= SequenceRotateLeft[seq, 1, ops];


(* ::Subsubsection:: *)
(*Truncate*)


DefineOptions[Truncate,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potential alphabet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Cap -> Modification["Acetylated"], _?SequenceQ, "Synthetic monomer that will be placed on the left hand side of the sequence after truncation in a capping step."}
	}];

Truncate::TooShort="Cannot produce `2` truncations of a strand that is `1` Monomers long.";


(* --- Strand based --- *)
Truncate[str_?StrandQ,0,ops:OptionsPattern[Truncate]]:=str;

Truncate[str_?StrandQ,n_Integer,ops:OptionsPattern[Truncate]]:=Message[Truncate::TooShort,StrandLength[str],n]/;StrandLength[str]<=n;

Truncate[str_?StrandQ,n_Integer,ops:OptionsPattern[Truncate]]:=Module[{safeOps},

	(* Safely extract the options *)
	safeOps=SafeOptions[Truncate, ToList[ops]];

	Table[truncateHelper[str,x,Sequence@@safeOps],{x,0,n}]
];

(* --- Sequence Based --- *)
Truncate[str:SequenceP,n_Integer,ops:OptionsPattern[Truncate]]:=Module[{safeOps,strd},

	(* Safely extract the options *)
	safeOps=SafeOptions[Truncate, ToList[ops]];

	(* Generate a strand version of the sequence *)
	strd=ToStrand[str,PassOptions[Truncate,ToStrand,safeOps]];

	(* Truncate that SOB *)
	Truncate[strd,n,Sequence@@safeOps]

]/;SequenceQ[str,PassOptions[Truncate,SequenceQ,ops]];

(* --- Structures with only one strand --- *)
Truncate[struct:StructureP,n_Integer,ops:OptionsPattern[Truncate]]:=Module[
	{strands,truncsPerStrand},

	(* List of strands in the input structure *)
	strands=struct[Strands];

	(* Truncations for each strand *)
	truncsPerStrand=Map[
		Truncate[#,n,ops]&,
		strands
	];

	(* Flatten the list before returning *)
	Flatten[truncsPerStrand]
];

SetAttributes[Truncate,Listable];


truncateHelper[str_Strand,0,ops:OptionsPattern[Truncate]]:=str;
truncateHelper[str_Strand,n_Integer,ops:OptionsPattern[Truncate]]:=Module[{chop},
	chop=If[MatchQ[StrandFirst[str],Strand[OptionValue[Cap]]],n+1,n];
	If[chop<StrandLength[str],
		Prepend[StrandDrop[str,chop],OptionValue[Cap]],
		Strand[""]
	]
]/;StrandQ[str];


(* ::Subsection:: *)
(*P's & Q's*)


(* ::Subsubsection::Closed:: *)
(*ValidStrandQ*)


DefineOptions[ValidStrandQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Degeneracy -> True, BooleanP, "If set to true any possible variants of the degenercy match the complement will be considered acceptable."},
		{Exclude -> Modification, PolymerP | {PolymerP...}, "List of polymer types to ignore when checking the type of the strand."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."}
	}];

ValidStrandQ[str:StrandP,ops:OptionsPattern[]]:=Module[
	{safeOps,allowedPolymers,strPols,motifs},

	safeOps=SafeOptions[ValidStrandQ, ToList[ops]];

	(* Determine which polymer types are allowed *)
	allowedPolymers = resolveValidStrandPolymers[Lookup[safeOps,{Polymer,Exclude}]];

	strPols = strandPolymers[str];

	(* Make sure all of the polymers appear in the allowed Types list *)
	If[Not[ContainsAll[allowedPolymers,strPols]],
		Return[False]
	];

	motifs=StrandMotifs[str];

	(* Make sure each sequence is valid: passing along only the degeneracy option (since Polymer and exclude options are different) *)
	If[Not[ContainsAll[allowedPolymers,strPols]],
		Return[False]
	];

	(* make sure each motif/sequence in the strand is valid *)
	If[Not[AllTrue[motifs,ValidMotifQ[#,Sequence@@ExtractRule[safeOps,{Degeneracy}]]&]], (* only pass Degeneracy here.. other options (Polymer & Exclude) mess up b/c they have different meanings *)
		Return[False]
	];

	(* if not checking motif names, then we are done here *)
	If[Not[TrueQ[Lookup[safeOps,CheckMotifs]]],
		Return[True]
	];

	(* Make sure motif names are all valid with respect to their rev-comp counterparts *)
	validMotifNames[str]

];


ValidStrandQ[_,ops:OptionsPattern[]]:=False;



SetAttributes[ValidStrandQ,Listable];



resolveValidStrandPolymers[{Automatic,exclude_}]:=resolveValidStrandPolymers[{AllPolymersP,exclude}];
resolveValidStrandPolymers[{s_Symbol,exclude_}]:=resolveValidStrandPolymers[{{s},exclude}];
resolveValidStrandPolymers[{pols:{_Symbol..},exclude_Symbol}]:=resolveValidStrandPolymers[{pols,{exclude}}];
resolveValidStrandPolymers[{pols:{_Symbol..},exclude:{_Symbol..}}]:=DeleteDuplicates[Join[pols,exclude]];



validMotifNames[strand_Strand]:=validMotifNames[{strand}];
validMotifNames[strands:{_Strand..}]:=Module[{parsed,motifsAndSeqs,gatheredByName},

	parsed = Join@@Map[ParseStrand,strands];
	motifsAndSeqs = Replace[
		parsed,
		{
			{name_,False,seq_,pol_}:>{name,pol[seq]},
			{name_,True,seq_,pol_}:>{name,ReverseComplementSequence[pol[seq]]}
		},
		{1}
	];
	gatheredByName = GatherBy[motifsAndSeqs,First];
	AllTrue[
		Map[
			SameQ@@#[[;;,2]]&,
			gatheredByName
		],
		#&
	]
];



(* ::Subsection:: *)
(*Strand parsing*)


(* ::Subsubsection::Closed:: *)
(*ParseStrand*)


ParseStrand[list:{StrandP..}]:= ParseStrand/@list;
ParseStrand[Strand[mot:MotifP]]:= {parseMotif[mot]};
ParseStrand[str:StrandP]:= List@@Map[parseMotif,str];


parseMotif[(pol_Symbol)[s:(_String|_Integer),l_String]]:=
	Which[
		l==="",	{l,False,s,pol},
		StringLast[l]==="'",{StringMost[l],True,s,pol},
		True,	{l,False,s,pol}
	];

parseMotif[(pol_Symbol)[s:(_String|_Integer)]]:={"",False,s,pol};


(* ::Subsubsection::Closed:: *)
(*unparseStrand*)


"
DEFINITIONS
	unparseStrand[{ {name_String, rc:(True|False), seq:(_String|_Integer), type_Symbol}.. }]  ==>  str_?StrandQ
		Constructs a properly formatted strand from its component parts (name, reverse complement?, sequence, type).

MORE INFORMATION
	Inverse of ParseStrand function
	unparseStrand[ParseStrand[str]] ==> str

INPUTS
	name - the name/label of the motif
	rc - whether this motif is the reverse complement of the name
	seq - either the sequence or length of the motif
	type - the polymer type of the motif

OUTPUTS
	str - a strand constructed from the input components

ATTRIBUTES
	Listable

EXAMPLES
	unparseStrand[{{\"X\",False,\"ATCG\",DNA},{\"Y\",False,\"AUUUU\",RNA}}]

AUTHORS
	Brad

";

Authors[unparseStrand]:={"scicomp", "brad"};

unparseStrand[listlist:{{{_String,True|False,_String|_Integer,_Symbol}..}..}]:=unparseStrand/@listlist;
unparseStrand[list:{{_String,True|False,_String|_Integer,_Symbol}..}]:=Strand@@Map[unparseMotif,list];
unparseMotif[{""|Null,bool_,seq:(_String|_Integer),pol_Symbol}]:=pol[seq];
unparseMotif[{label_String,bool_,seq:(_String|_Integer),pol_Symbol}]:=pol[seq,If[bool===True,label<>"'",label]];
unparseMotif[{"",bool_,seq:(_String|_Integer),pol_Symbol}]:=pol[seq];



(* ::Subsubsection::Closed:: *)
(*strandRCs*)


(* used heavinly in mechanism generation *)
strandRCs[str:StrandP]:=ParseStrand[str][[;;,2]];
strandRCs[list:{StrandP..}]:=strandRCs/@list;


(* ::Subsubsection::Closed:: *)
(*motifPositionToStrandPosition*)


(*
 * Takes in a Strand, the index of a motif in that strand, and an interval in that motif.
 * Converts that motif interval into an absolute interval, using the beginning of the strand instead of the beginning of the motif as a 0 index.
 *)
Authors[motifPositionToStrandPosition]:={"scicomp", "brad"};

motifPositionToStrandPosition[str_Strand,motifInd_Integer,interval:(Span|List)[_Integer,_Integer]]:=
	Span@@(List@@interval+Total[StringLength/@ParseStrand[str][[1;;motifInd-1,3]]]);



(* ::Subsubsection:: *)
(*strandPolymers*)


strandPolymers[strand_Strand]:=ParseStrand[strand][[;;,4]];



(* ::Subsection:: *)
(*Strand Manipulation*)


(* ::Subsubsection:: *)
(*strandResolution*)


resolveStrand[strd:StrandP, f_, needed_List, fastTrack:BooleanP]:=
	If[(!fastTrack) && (!StrandQ[strd]),
		(* if FastTrack set to be True and input strand failed StrandQ, throw a message and return $Failed *)
		(Message[f::invalidStrand, strd]; $Failed),
		AssociationThread[needed -> strd[needed]]
	];


resolveStrand[strds_List, f_, needed_List, fastTrack:BooleanP]:= resolveStrand[#, f, needed, fastTrack]&/@strds;


(* ::Subsubsection:: *)
(*Strand*)


Strand[s_Strand]:=s;

Strand[seqs:((_String|MotifP)..)]/;MemberQ[{seqs},_String]:= Module[
	{motifs},

	motifs = ExplicitlyType[{seqs}, ExplicitlyTyped->True];
	Strand@@motifs
];


(* ::Subsubsection:: *)
(*StrandQ*)


DefineOptions[StrandQ,
	Options :> {
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that each sequence in the strand must be composed of to return True.  Automatic will accept any polymer type."},
		{Degeneracy -> True, BooleanP, "If set to true any possible variants of the degenercy match the complement will be considered acceptable."},
		{Exclude -> Modification, PolymerP | {PolymerP...}, "List of polymer types to ignore when checking the type of the strand."},
		{CheckMotifs -> False, BooleanP, "If on, checks to see that all motifs are uniquely named and sequences properly match as reverse complements."},
		{CanonicalPairing -> True, BooleanP, "If set to true, Polymer types are ignored and only Watson-Crick pairings are comsodered, otherwise matches must be of the same polymer type."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}];


restoreMotifName[before:PolymerP[strb_String, name_String], after:PolymerP[stra_String]]:= Head[after][stra, name];
restoreMotifName[before_, after_]:= after;


resolveRevComp[seq:PolymerP[str_String, name_]]/;StringMatchQ[name, __~~"'"]:= ReverseComplementSequence[Head[seq][str], FastTrack->True];
resolveRevComp[seq:PolymerP[str_String, _]]:= Head[seq][str];


StrandQ[strd:StrandP, ops:OptionsPattern[]]:= Module[
	{safeOps, origSeqs, excludeSeqs, reSeqs, reSeqsExclude, reSeqsPost, named, grouped, tmpRes},

	safeOps = SafeOptions[StrandQ, ToList[ops]];

	(* if FastTrack is set to True, return True *)
	If[FastTrack/.safeOps, Return[True]];

	origSeqs = strd[Motifs];

	(* check sequenceQ first *)
	If[!And@@SequenceQ[origSeqs], Return[False]];

	(* resolve to typed sequences while excluding certain provided polymer types *)
	excludeSeqs = DeleteCases[origSeqs, (Alternatives@@(Exclude/.safeOps))[_, ___]];
	reSeqs = With[{tmp = Quiet[resolveSequence[excludeSeqs, StrandQ, PassOptions[StrandQ, resolveSequence, safeOps]]]},
				If[CanonicalPairing/.safeOps,
					toDNACore/@tmp,
					tmp
				]
			];

	(* if resolving failed for any sequence, return False *)
	If[MemberQ[reSeqs, $Failed], Return[False]];

	(* if CheckMotifs is off, just return True*)
	If[!CheckMotifs/.safeOps, Return[True]];

	(* if CheckMotifs is on, check revcomp *)
	(* if there are motif names, add them back *)
	reSeqsPost = MapThread[restoreMotifName[#1, #2]&, {excludeSeqs, reSeqs}];

	(* filter out the motifs without a name *)
	named = Cases[reSeqsPost, PolymerP[_, _String]];
	If[MatchQ[named, {}], Return[True]];

	(* gather by revcomp names and verify if truely revcomp for the sequences *)
	grouped = Select[GatherBy[DeleteDuplicates[named], StringTrim[Last[#], "'"]&], Length[#]>1&];

	(* turn revcomp sequence back to original format *)
	tmpRes = Map[resolveRevComp, grouped, {2}];

	And@@(SameSequenceQ/@tmpRes)

];


StrandQ[strds:{StrandP..}, ops:OptionsPattern[]]:= StrandQ[#, ops]&/@strds;


StrandQ[_, ops:OptionsPattern[]]:= False;


(* ::Subsubsection:: *)
(*strandNames*)

Authors[strandNames]:={"scicomp", "brad"};

strandNames[str_?StrandQ]:= ParseStrand[str][[;;,1]];
strandNames[list:{_?StrandQ..}]:= strandNames/@list;


(* ::Subsubsection:: *)
(*StrandTake*)

StrandTake::invalidSpan="Cannot take positions `1` through `2`.";

strandTakeCore[motifs:{MotifP..}, Span[m0_Integer, n0_Integer]]:= Module[
	{allLen, start, end, m, n},

	allLen = SequenceLength[motifs, FastTrack->True];

	m = If[m0>0, m0, Total[allLen]+m0+1];
	n = If[n0>0, n0, Total[allLen]+n0+1];

	(* check if the input span is valid *)
	If[!validSpanQ[Total[allLen], m, n], (Message[StrandTake::invalidSpan, ToString[m], ToString[n]]; Return[$Failed])];

	(* find the break point *)
	start = FirstPosition[Accumulate[allLen], _?(#>=m &)]//First;
	end = FirstPosition[Accumulate[allLen], _?(#>=n &)]//First;

	Switch[end-start,
		0,
			With[{onlyMotif = motifs[[start]], accumLen = Prepend[Accumulate[allLen], 0]},
				Strand[SequenceTake[onlyMotif, m-accumLen[[start]];;n-accumLen[[start]], FastTrack->True]]
			],
		1,
			With[{startMotif = motifs[[start]], endMotif = motifs[[end]], accumLen = Accumulate[allLen]},
				Strand[SequenceTake[startMotif, m-accumLen[[start]]-1, FastTrack->True],
				       SequenceTake[endMotif, n-accumLen[[end-1]], FastTrack->True]]
			],
		_,
			With[{startMotif = motifs[[start]], endMotif = motifs[[end]], accumLen = Accumulate[allLen]},
				Strand[SequenceTake[startMotif, m-accumLen[[start]]-1, FastTrack->True],
					   Sequence@@motifs[[start+1;;end-1]],
				       SequenceTake[endMotif, n-accumLen[[end-1]], FastTrack->True]]
			]
	]

];

strandTakeCore[motifs:{MotifP..}, n_Integer]:= strandTakeCore[motifs, If[n > 0, Span[1, n], Span[n, -1]]];

strandTakeCore[$Failed, ___]:= $Failed;


StrandTake[strds:{StrandP..}, indx: (_Integer | _Span)]:= Module[
	{reSeqs},

	(* resolve strands to Motifs *)
	reSeqs = resolveStrand[strds, StrandTake, {Motifs}, False];

	If[MatchQ[#, $Failed], $Failed, strandTakeCore[#[Motifs], indx]]&/@reSeqs

];


StrandTake[strd:StrandP, indx: (_Integer | _Span)]:= First[StrandTake[{strd}, indx]];


StrandTake[strd:StrandP,{a_Integer, int: (_Integer | _Span)}]:= Strand[SequenceTake[strd[Motifs][[a]], int]];


(* ::Subsubsection:: *)
(*StrandDrop*)

StrandDrop::invalidSpan="Cannot take positions `1` through `2`.";

dealEmptyList[in_]:= If[MatchQ[in, {}], Sequence@@{}, in];


strandDropCore[motifs:{MotifP..}, Span[m0_Integer, n0_Integer]]:= Module[
	{allLen, start, end, m, n},

	allLen = SequenceLength[motifs, FastTrack->True];

	m = If[m0>0, m0, Total[allLen]+m0+1];
	n = If[n0>0, n0, Total[allLen]+n0+1];

	(* check if the input span is valid *)
	If[!validSpanQ[Total[allLen], m, n], (Message[StrandDrop::invalidSpan, ToString[m], ToString[n]]; Return[$Failed])];

	(* find the break point *)
	start = FirstPosition[Accumulate[allLen], _?(#>=m &)]//First;
	end = FirstPosition[Accumulate[allLen], _?(#>=n &)]//First;

	Switch[end-start,
		0,
			With[{onlyMotif = motifs[[start]], accumLen = Prepend[Accumulate[allLen], 0]},
				Strand[Sequence@@motifs[[1;;start-1]],
					   dealEmptyList[SequenceDrop[motifs[[start]], m-accumLen[[start]];;n-accumLen[[start]], FastTrack->True]],
					   Sequence@@motifs[[end+1;;]]]
			],
		_,
			With[{startMotif = motifs[[start]], endMotif = motifs[[end]], accumLen = Accumulate[allLen]},
				Strand[Sequence@@motifs[[1;;start-1]],
					   dealEmptyList[SequenceDrop[startMotif, m-accumLen[[start]]-1, FastTrack->True]],
				       dealEmptyList[SequenceDrop[endMotif, n-accumLen[[end-1]], FastTrack->True]],
				       Sequence@@motifs[[end+1;;]]]
			]
	]

];

strandDropCore[motifs:{MotifP..}, n_Integer]:= strandDropCore[motifs, If[n > 0, Span[1, n], Span[n, -1]]];

strandDropCore[$Failed, ___]:= $Failed;


StrandDrop[strds:{StrandP..}, indx: (_Integer | _Span)]:= Module[
	{reSeqs},

	(* resolve strands to Motifs *)
	reSeqs = resolveStrand[strds, StrandDrop, {Motifs}, False];

	If[MatchQ[#, $Failed], $Failed, strandDropCore[#[Motifs], indx]]&/@reSeqs

];


StrandDrop[strd:StrandP, indx: (_Integer | _Span)]:= First[StrandDrop[{strd}, indx]];


StrandDrop[strd:StrandP,{a_Integer, int: (_Integer | _Span)}]:= Strand[SequenceDrop[strd[Motifs][[a]], int]];


(* ::Subsubsection:: *)
(*StrandFlatten*)


DefineOptions[StrandFlatten,
	Options :> {
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
}];


strandFlatten[motifs:{MotifP..}]:= Module[
	{split, merged},

	(* Split the list of sequences up by like type *)
	split = SplitBy[motifs, PolymerType];

	(* Sequence join the split list to merge *)
	merged = sequenceJoinCore/@split;

	(* Wrap the result in a strand again and return *)
	Strand@@merged

];

strandFlatten[$Failed]:= $Failed;


StrandFlatten[strds:{StrandP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs,split,merged},

	safeOps = SafeOptions[StrandFlatten, ToList[ops]];

	(* resolve strands to Motifs *)
	reSeqs = resolveStrand[strds, StrandFlatten, {Motifs}, FastTrack/.safeOps];

	If[MatchQ[#, $Failed], $Failed, strandFlatten[#[Motifs]]]&/@reSeqs

];


StrandFlatten[strd:StrandP, ops:OptionsPattern[]]:= First[StrandFlatten[{strd}, ops]];


(* ::Subsubsection:: *)
(*StrandLength*)


DefineOptions[StrandLength,
	Options :> {
		{Total -> True, True | False, "If True, return number of Monomers in entire strand.  If False, return list of lengths of each motif."},
		{FastTrack -> False, BooleanP, "Skip strict checks.", Category->Hidden}
	}
];


StrandLength[strds:{StrandP..}, ops:OptionsPattern[]]:= Module[
	{safeOps, reSeqs, tmpRes},

	safeOps = SafeOptions[StrandLength, ToList[ops]];

	(* resolve strands to Motifs *)
	reSeqs = resolveStrand[strds, StrandLength, {Motifs}, FastTrack/.safeOps];

	tmpRes = If[MatchQ[#, $Failed], $Failed, SequenceLength[#[Motifs], FastTrack->True]]&/@reSeqs;

	If[Total/.safeOps,
		Total[tmpRes, {2}],
		tmpRes
	]

];


StrandLength[strd:StrandP, ops:OptionsPattern[]]:= First[StrandLength[{strd}, ops]];


(* ::Subsubsection:: *)
(*StrandFirst*)


StrandFirst[strd:StrandP]:= StrandTake[strd, 1];


(* ::Subsubsection:: *)
(*StrandLast*)


StrandLast[strd:StrandP]:= StrandTake[strd, -1];


(* ::Subsubsection:: *)
(*StrandRest*)


StrandRest[strd:StrandP]:= StrandDrop[strd, 1];


(* ::Subsubsection:: *)
(*StrandMost*)


StrandMost[strd:StrandP]:= StrandDrop[strd, -1];


(* ::Subsubsection::Closed:: *)
(*DefineMotifs*)


DefineMotifs::MissingMotifs="No replacement rules given for the motifs:  `1`.  These motifs were replaced with 'N'";
DefineMotifs::NonPairingMotifs="Resulting Structure does not satisfy validMotifsQ";


DefineMotifs[st_Strand,rules:{Rule[_String,_String]..}]:=Module[{parsed,stMotifs,ruleMotifs,motifToSequence,missing},
	motifToSequence[in:{label_,False,_Integer,pol_}]:={label,False,label/.rules,pol}/;MemberQ[ruleMotifs,label] ;
	motifToSequence[in:{label_,True,_Integer,pol_}]:={label<>"p",False,ReverseComplementSequence[label/.rules],pol}/;MemberQ[ruleMotifs,label] ;
	motifToSequence[in:{label_,flag_,int_Integer,pol_}]:={label,flag,StringJoin@@ConstantArray["N",int],pol}/;!MemberQ[ruleMotifs,label] ;
	motifToSequence[in:{_,_,_,_}]:=in;
	ruleMotifs=rules[[;;,1]];
	parsed=ParseStrand[st]/.(x:PolymerP)[y_String?(StringMatchQ[#,"N"..]&),z_]:>x[StringLength[y],z];
	stMotifs=Union[parsed[[;;,1]]];
	missing=Complement[stMotifs,ruleMotifs];
	If[missing=!={},Message[DefineMotifs::MissingMotifs,missing]];
	unparseStrand[motifToSequence/@parsed]];

DefineMotifs[thing_,rules:{Rule[_String,_String]..}]:=Module[{newthing},
	newthing=thing/.{st_Strand:>DefineMotifs[st,rules]};
	Table[
		If[validMotifsQ[cc]===False,Message[DefineMotifs::NonPairingMotifs]],
		{cc,Join[Cases[newthing,_Structure,Infinity],Cases[newthing,_Structure,{0}]]}
	];
	newthing
	];


(* ::Subsubsection:: *)
(*StrandJoin*)


StrandJoin[strds:{StrandP..}]:= Module[
	{reSeqs},

	(* resolve strands to Motifs *)
	reSeqs = resolveStrand[strds, StrandJoin, {Motifs}, False];

	(* if any resolution failed, return $Failed *)
	If[MemberQ[reSeqs, $Failed], Return[$Failed]];

	Strand@@Flatten[Values[reSeqs]]

];


StrandJoin[{}]:= {};

(* strand (rather than list) version of strand join *)
StrandJoin[strds__?StrandQ]:= Join@strds;


(* ::Subsubsection::Closed:: *)
(*StrandSequences*)


StrandSequences[strand_Strand]:=Map[MotifSequence,StrandMotifs[strand]];


(* ::Subsubsection::Closed:: *)
(*StrandMotifs*)


StrandMotifs[strand_Strand]:=List@@strand;


(* ::Subsection:: *)
(*SubValues*)


(* ::Subsubsection:: *)
(*SubValues*)


OnLoad[

	Unprotect[Strand];

	Strand /: Keys[Strand] := {Sequences,Motifs,Polymers,Names,RevComps};
	Strand /: Keys[_Strand] := Keys[Strand];

	(strand_Strand)[Sequences]:=ParseStrand[strand][[;;,3]];
	Sequences/:(strands:{_Strand..})[x:Sequences]:=Map[#[x]&,strands];

	(strand_Strand)[Motifs]:=List@@strand;
	Motifs/:(strands:{_Strand..})[x:Motifs]:=Map[#[x]&,strands];

	(strand_Strand)[Polymers]:=strandPolymers[strand];
	Polymers/:(strands:{_Strand..})[x:Polymers]:=Map[#[x]&,strands];

	(strand_Strand)[RevComps]:=strandRCs[strand];
	RevComps/:(strands:{_Strand..})[x:RevComps]:=Map[#[x]&,strands];

	Unprotect[Names];
	(strand_Strand)[Names]:=strandNames[strand];
	Names/:(strands:{_Strand..})[x:Names]:=Map[#[x]&,strands];
	Protect[Names];

	(* dereference list of fields *)
	With[
		{strandFieldP = Alternatives@@Keys[Strand]},
		(strand_Strand)[vals:{strandFieldP..}]:=Map[strand,vals]
	];

];