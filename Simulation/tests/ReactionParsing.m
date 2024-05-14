

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ReactionParsing: Tests*)








(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Loading Matrices*)


(* ::Subsubsection::Closed:: *)
(*loadInitialConditions*)


DefineTests[
	loadInitialConditions,
	{
		Test[loadInitialConditions[{a,b,c,d,e,f,g},{a->1,d->2,e->3}],{1,0,0,2,3,0,0}],
		Test[loadInitialConditions[{a->b,c\[Equilibrium]d,d->a,2e->g+c,f->c},{a->1,d->2,e->3}],{1,0,0,2,3,0,0}]
	},
	Variables:>{a,b,c,d,e,f,g}
];


(* ::Section::Closed:: *)
(*End Test Package*)
