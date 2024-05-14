(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Patterns.m*)


(* ::Subtitle:: *)
(*All of our exported patterns*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Generic patterns*)


(* ::Subsubsection::Closed:: *)
(*BooleanP*)


BooleanP=True|False;
BooleanP::usage="True | False.";



(* ::Subsubsection::Closed:: *)
(*RulesP*)


RulesP:=(_Rule|_RuleDelayed);
RulesP::usage="Helpful shorthand for the kinds of rules oftentime used together.";



(* ::Subsection:: *)
(*Null Checking*)


NullP=_?(MatchQ[Flatten[ToList[#]],{Null..}]&);

NullQ[input_]:=MatchQ[input,NullP];


(* ::Subsubsection:: *)
(*InfiniteNumericP*)


InfiniteNumericP = _?NumericQ | Infinity | -Infinity;


(* ::Subsubsection:: *)
(*InfiniteNumericQ*)


InfiniteNumericQ[valueToTest_]:=MatchQ[valueToTest,InfiniteNumericP];
SetAttributes[InfiniteNumericQ,Listable];


(* given a sequence of patterns, return a single pattern which matches all *)
PatternUnion[patterns__] := _?(Function[{expr}, AllTrue[List[patterns], MatchQ[expr, #]&]]);
