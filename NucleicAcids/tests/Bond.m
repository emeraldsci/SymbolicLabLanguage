

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*Bond: Tests*)








(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Bond*)


(* ::Subsubsection::Closed:: *)
(*Bond*)


DefineTests[Bond,{
	Example[{Basic,"A bond between the third motif in the first strand, and the fourth motif in the second strand:"},
		Bond[{1,3},{2,4}],
		BondP
	],
	Example[{Basic,"A bond between based 5 through 8 in the third motif in the first strand, and based 16 through 19 in the fourth motif in the second strand:"},
		Bond[{1,3,5;;8},{2,4,16;;19}],
		BondP
	],
	Example[{Basic,"Motif bonds in a structure:"},
		Structure[{Strand[DNA[15,"A"],DNA["ATATAGCATAG","B"],DNA[15,"C"],Modification["Fluorescein"]],Strand[DNA[15,"C'"],RNA["AUAUAGCAUAG","D"],DNA[15,"A'"],RNA[7,"E"]]},{Bond[{1,1},{2,3}],Bond[{1,3},{2,1}]}],
		StructureP
	],
	Example[{Basic,"Base bonds in a structure:"},
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},
			{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],
		StructureP
	]


}]


(* ::Section::Closed:: *)
(*End Test Package*)
