

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*NetworkAnalysis: Tests*)






(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Network Analysis*)


(* ::Subsubsection:: *)
(*reactionsToGraphU*)


DefineTests[reactionsToGraphU,{
	Test[reactionsToGraphU[{"a"+"b"\[Equilibrium]"c","c"->"a"}],_Graph,TestTags->{Display}],
	Test[reactionsToGraphU[{"a"\[Equilibrium]"b","b"\[Equilibrium]"c","d"\[Equilibrium]"a"+"d","d"\[Equilibrium]"b"}],_Graph,TestTags->{Display}]
}];


(* ::Subsubsection:: *)
(*reactionsToGraphD*)


DefineTests[reactionsToGraphD,{
	Test[reactionsToGraphD[{"a"+"b"\[Equilibrium]"c","c"->"a"}],_Graph,TestTags->{Display}],
	Test[reactionsToGraphD[{"a"+"b"\[Equilibrium]"c","c"->"a"}],_Graph,TestTags->{Display}]
}];


(* ::Section:: *)
(*End Test Package*)
