(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Math: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Calculus*)


(* ::Subsubsection:: *)
(*ND*)


DefineTests[ND,{
	Example[{Basic,"Take numerical derivative of data:"},
		ND[Transpose[{Range[10],N@{1,4,6,4,3,6,34,3,7,2}}]],
		{{3,-0.18518518518518517`},{4,-2.4074074074074074`},{5,-1.1111111111111112`},{6,23.055555555555554`},{7,-2.5925925925925926`}}
	],
	Example[{Basic,"Take numerical second derivative of data:"},
		ND[Transpose[{Range[10],N@{1,4,6,4,3,6,34,3,7,2}}],2],
		{{3,-5.761316872427984`},{4,1.440329218106996`},{5,3.0864197530864197`},{6,41.66666666666667`},{7,-91.1522633744856`}}
	],
	Example[{Basic,"Take numerical third derivative of data:"},
		ND[Transpose[{Range[10],N@{1,4,6,4,3,6,34,3,7,2}}],3],
		{{3,1.3717421124828533`},{4,5.486968449931413`},{5,16.46090534979424`},{6,-43.20987654320988`},{7,6.858710562414267`}}
	]
}];


(* ::Section:: *)
(*End Test Package*)
