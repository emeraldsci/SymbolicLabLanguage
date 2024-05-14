

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Polymer stuff*)


(* ::Subsubsection:: *)
(*polymerBases*)

(* All overloads for polymerBases *)

polymerBases[pol_Symbol,field:(DegenerateAlphabet|AlternativeEncodings)]:=
	Flatten@Switch[field,
		DegenerateAlphabet,
		With[
			{result=Physics`Private`lookupModelOligomer[pol,DegenerateAlphabet]},
			(* If for any reason lookupModelOligomer returns failed (like not logged in or download failed, then gracefully return failed )*)
			If[result===$Failed,
				$Failed,
				result[[;;,1]]
			]
		],

		(* There are AlternativeEncodings and AlternativeDegenerateEncodings lists associated with Alphabet and DegenerateAlphabet *)
		AlternativeEncodings,
		With[
			{
				result=Join[
					{
						Physics`Private`lookupModelOligomer[pol,AlternativeEncodings],
						Physics`Private`lookupModelOligomer[pol,AlternativeDegenerateEncodings]
					}
				]
			},
			(* If for any reason lookupModelOligomer returns failed (like not logged in or download failed, then gracefully return failed )*)
			If[MemberQ[result, $Failed|head_[$Failed]],
				$Failed,
				result[[;;,;;,;;,1]]
			]
		]
	];

polymerBases[pol_Symbol,field:Alphabet]:=
	Physics`Private`lookupModelOligomer[pol,field];

polymerBases[pol_Symbol,fields:{_Symbol..}]:=
	Map[polymerBases[pol,#]&,fields];

polymerBases[pols:{_Symbol..},field_]:=
	Map[polymerBases[#,field]&,pols];


(* ::Subsection:: *)
(*P's & Q's*)


(* ::Subsubsection:: *)
(*IntegerMotifP*)


IntegerMotifP = PolymerP[_Integer?Positive,Repeated[_String,{0,1}]];


(* ::Subsubsection:: *)
(*StringMotifP*)


StringMotifP = PolymerP[_String,Repeated[_String,{0,1}]];


(* ::Subsubsection:: *)
(*SequenceQ*)


(*
SequenceQ[seq_String]:=True;
SequenceQ[mot:MotifP]:=True;
SequenceQ[_]:=False;
SetAttrbitues[SequenceQ,Listable];
*)


(* ::Subsubsection:: *)
(*ValidSequenceQ*)


DefineOptions[ValidSequenceQ,
	Options :> {
		{Exclude -> {}, PolymerP | {SequenceP...}, "Monomers not to be included in alphabet when considering if a sequence is valid."},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to True, the degenerate alphabet will be considered valid."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}];

ValidSequenceQ[seq_String,ops:OptionsPattern[]]:=Module[
	{safeOps,pol,alphabet,fullAlphabet,regExPatt,alphabetFields},
	safeOps = SafeOptions[ValidSequenceQ, ToList[ops]];
	pol = resolveValidSequencePolymers[Lookup[safeOps,Polymer]];
	alphabetFields = resolvePolymerAlphabetFields[{Degeneracy,AlternativeEncodings}/.safeOps];
	fullAlphabet = DeleteDuplicates[Flatten[polymerBases[pol,alphabetFields]]];
	(* Return with failed if full alphabet is not found. The error message should have been thrown prior to this within lookupModelOligomer *)
	If[MemberQ[fullAlphabet, $Failed|head_[$Failed]],
		Return[$Failed]
	];
	alphabet = Cases[fullAlphabet,Except[Alternatives@@Lookup[safeOps,Exclude]]];
	regExPatt = Core`Private`toRegularExpression[alphabet..];
	(* regExPatt = RegularExpression[First[StringPattern`PatternConvert[alphabet ..]]]; *)
	StringMatchQ[seq,regExPatt]
];

ValidSequenceQ[mot:MotifP,ops:OptionsPattern[]]:=ValidMotifQ[mot,ops];

ValidSequenceQ[_,OptionsPattern[]]:=False;

SetAttributes[ValidSequenceQ,Listable];


resolveValidSequencePolymers[s_Symbol]:={s};
resolveValidSequencePolymers[Automatic]:=AllPolymersP;


resolvePolymerAlphabetFields[{degen_,altEnc_}]:=Pick[{Alphabet,DegenerateAlphabet,AlternativeEncodings},{True,degen,altEnc}];


(* ::Subsection:: *)
(*Motif*)


(* ::Subsubsection::Closed:: *)
(*MotifPolymer*)


MotifPolymer[pol_[seq_,label_]]:=pol;
MotifPolymer[pol_[seq_]]:=pol;



(* ::Subsubsection::Closed:: *)
(*MotifSequence*)


MotifSequence[pol_[seq_,label_]]:=seq;
MotifSequence[pol_[seq_]]:=seq;



(* ::Subsubsection::Closed:: *)
(*MotifLabel*)


MotifLabel[pol_[seq_,label_]]:=label;
MotifLabel[pol_[seq_]]:="";



(* ::Subsubsection:: *)
(*ValidMotifQ*)


DefineOptions[ValidMotifQ,
	Options :> {
		{Exclude -> {}, PolymerP | {SequenceP...}, "Monomers not to be included in alphabet when considering if a sequence is valid."},
		{Polymer -> Automatic, PolymerP | Automatic, "The polymer type that defines the potnetial alphabaet a valid sequence should be composed of.  Automatic will attempt to match all known polymer types."},
		{Degeneracy -> True, BooleanP, "If set to True, the degenerate alphabet will be considered valid."},
		{AlternativeEncodings -> False, BooleanP, "If set to True, the function will allow the alternative coding alphabets specified in the Parameters.  If False, alternative coding alphabets will not be allowed."}
	}];


ValidMotifQ[mot:IntegerMotifP,ops:OptionsPattern[]]:=Module[{safeOps},
	safeOps = SafeOptions[ValidSequenceQ, ToList[ops]];
	If[TrueQ[Lookup[safeOps,Degeneracy]],
		True,
		False
	]
];

ValidMotifQ[mot:StringMotifP,ops:OptionsPattern[]]:=Module[
	{safeOps,validPols,seq,polHead},
	safeOps = SafeOptions[ValidSequenceQ, ToList[ops]];
	validPols = resolveValidSequencePolymers[Lookup[safeOps,Polymer]];
	seq=MotifSequence[mot];
	polHead=MotifPolymer[mot];
	And[
		MemberQ[validPols,polHead],
		ValidSequenceQ[seq,Sequence@@ReplaceRule[safeOps,{Polymer->polHead}]]
	]
];

ValidMotifQ[_,OptionsPattern[]]:=False;

SetAttributes[ValidMotifQ,Listable];
