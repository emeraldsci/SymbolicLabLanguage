(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
 

(* ::Subsubsection::Closed:: *)
(*DuplicateFreeListableP*)

DuplicateFreeListableP[pattern_]:=pattern | {(pattern)..}?DuplicateFreeQ;


(* ::Subsubsection::Closed:: *)
(*ListableP*)


(*No Level-Spec*)
ListableP[pattern_]:=ListableP[pattern,1];


(*Integer Level-Spec*)
ListableP[pattern_,level_Integer?NonNegative]:=ListableP[pattern,{0,level}];


(*Single Integer List Level-Spec*)
ListableP[pattern_,{level_Integer?NonNegative}]:=First[
	ListableP[pattern,{level,level}]
];

(*Span Level-Spec*)
ListableP[pattern_,{min_Integer?NonNegative,max_Integer?NonNegative}]:=With[
	{range=Span[min+1,max+1]},

	Alternatives@@Part[
		NestList[{#..}&,pattern,max],
		range
	]
]/;(min <= max);
