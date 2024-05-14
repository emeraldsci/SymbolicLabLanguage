(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Folding: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Interval Partitioning*)


(* ::Subsubsection::Closed:: *)
(*deconstructIntervalByLength*)


DefineTests[deconstructIntervalByLength,{
Test[deconstructIntervalByLength[{1,3},1],{{{1,1},{2,2},{3,3}},{{1,2},{2,3}}}],
Test[deconstructIntervalByLength[{1,3},2],{{{1,2},{2,3}}}],
Test[deconstructIntervalByLength[{3,6},1],{{{3,3},{4,4},{5,5},{6,6}},{{3,4},{4,5},{5,6}},{{3,5},{4,6}}}],
Test[deconstructIntervalByLength[{3,6},2],{{{3,4},{4,5},{5,6}},{{3,5},{4,6}}}]
}];


(* ::Subsection::Closed:: *)
(*Constructing Structures*)


(* ::Subsubsection::Closed:: *)
(*foldStructure*)


DefineTests[foldStructure,{
	Test[foldStructure[Structure[{Strand[DNA[20,"A"]]},{}],{{1,1,{1;;2}},{1,1,{4;;5}}}],Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,1;;2},{1,1,4;;5}]}]],
	Test[foldStructure[Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,9;;10},{1,1,14;;15}]}],{{1,1,{1;;2}},{1,1,{4;;5}}}],Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,9;;10},{1,1,14;;15}],Bond[{1,1,1;;2},{1,1,4;;5}]}]]
}];


(* ::Subsubsection::Closed:: *)
(*pairStructure*)


DefineTests[pairStructure,{
Test[pairStructure[Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}],{{1,1,1;;2},{2,1,4;;5}}],Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,1;;2},{2,1,4;;5}]}]],
Test[pairStructure[Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,9;;11},{1,1,14;;16}]}],Structure[{Strand[DNA[20,"B"]]},{}],{{1,1,1;;2},{2,1,4;;5}}],Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,9;;11},{1,1,14;;16}],Bond[{1,1,1;;2},{2,1,4;;5}]}]]
}];


(* ::Subsection::Closed:: *)
(*Sequence Interactions*)


(* ::Subsubsection::Closed:: *)
(*Pairing*)


DefineTests[Pairing,{

	Example[{Basic,"Pair two sequences:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA"],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}]}
	],
	Example[{Basic,"Specify interval for first Strand:"},
		Pairing[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]],{1,2}},Strand[DNA["TATGCATTGCAGCTAGCTAGC"]],MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 3}, {2, 8 ;; 10}]}]}
	],
	Example[{Additional,"Specify interval for both structures:"},
		Pairing[{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]]},{}],{1,2}},{Structure[{Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]},{}],{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}]}
	],


	(* -------------------------- ADDITIONAL ------------------------- *)

	Example[{Additional,"Pair two strands:"},
		Pairing[Structure[{Strand[DNA["ATCGTAGCGTA"]]},{}],Structure[{Strand[DNA["ATCGCGCGCTA","Z"],RNA["ACUAUACACUAG","Q"]]},{}],MinLevel->3],
		{Structure[{Strand[DNA["ATCGTAGCGTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["ATCGTAGCGTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 7 ;; 9}, {2, 5 ;; 7}]}], Structure[{Strand[DNA["ATCGTAGCGTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 7 ;; 11}]}]}
	],
	Example[{Additional,"Pair two structures:"},
		Pairing[Structure[{Strand[DNA["ATCGTAGCGTA"]]},{}],Structure[{Strand[DNA["ATCGCGCGCTA"]]},{}],MinLevel->3],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}
	],
	Example[{Additional,"Specify interval for second sequences:"},
		Pairing["GCATGCATGCAGTGAATGCATC",{"TATGCATTGCAGCTAGCTAGC",{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 3 ;; 8}, {2, 2 ;; 7}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 15 ;; 21}, {2, 2 ;; 8}]}]}
	],
	Example[{Additional,"Specify interval for both sequences:"},
		Pairing[{"GCATGCATGCAGTGAATGCATC",{1,2}},{"TATGCATTGCAGCTAGCTAGC",{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}]}
	],
	Example[{Additional,"Specify interval for second Strand:"},
		Pairing[Strand[DNA["GCATGCATGCAGTGAATGCATC"]],{Strand[DNA["TATGCATTGCAGCTAGCTAGC"]],{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 3 ;; 8}, {2, 2 ;; 7}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 15 ;; 21}, {2, 2 ;; 8}]}]}
	],
	Example[{Additional,"Specify interval for both strands:"},
		Pairing[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]],{1,2}},{Strand[DNA["TATGCATTGCAGCTAGCTAGC"]],{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}]}
	],
	Example[{Additional,"Specify interval for first Structure:"},
		Pairing[{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]]},{}],{1,2}},Structure[{Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]},{}],MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 3}, {2, 8 ;; 10}]}]}
	],
	Example[{Additional,"Specify interval for second Structure:"},
		Pairing[Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]]},{}],{Structure[{Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]},{}],{1,2}},MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 3 ;; 8}, {2, 2 ;; 7}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 15 ;; 21}, {2, 2 ;; 8}]}]}
	],


	(* -------------------------- OPTIONS ------------------------- *)

	Example[{Options,Polymer,"Specify polymer type:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",Polymer->DNA],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}]}
	],
	Example[{Options,MinLevel,"Specify minimum number of consecutve bases in each Pairing:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",MinLevel->3],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}
	],

	Example[{Options,Consolidate,"Do not consolidate subpairings:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",MinLevel->3,Consolidate->False],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 9 ;; 11}, {2, 5 ;; 7}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 8 ;; 11}, {2, 5 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 8 ;; 10}, {2, 6 ;; 8}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 10}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 9}, {2, 7 ;; 9}]}]}
	],

	Example[{Options,Depth,"Return things with up to 1 Pairing:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",MinLevel->3,Depth->1],
		{{Structure[{Strand[DNA["ATCGTAGCGTA"]]}, {}], Structure[{Strand[DNA["ATCGCGCGCTA"]]}, {}]}, {Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}}
	],

	Example[{Options,Depth,"Return things with exactly 1 Pairing:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",MinLevel->3,Depth->{1}],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}
	],

	Example[{Options,MaxMismatch,"Maximum number of mismatches allowed in a pair:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",Polymer->DNA,MaxMismatch->1],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 8}, {2, 3 ;; 4}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 9 ;; 9}, {2, 4 ;; 4}], Bond[{1, 11 ;; 11}, {2, 2 ;; 2}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 1 ;; 1}, {2, 5 ;; 5}], Bond[{1, 3 ;; 4}, {2, 3 ;; 4}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 2 ;; 2}, {2, 6 ;; 6}], Bond[{1, 3 ;; 4}, {2, 3 ;; 4}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 1 ;; 1}, {2, 10 ;; 10}], Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 2 ;; 2}, {2, 11 ;; 11}], Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}]}
	],

	Example[{Options,MinPieceSize,"Maximum number of mismatches allowed in a pair:"},
		Pairing["ATCGTAGCGTA","ATCGCGCGCTA",Polymer->DNA,MaxMismatch->1, MinPieceSize->2],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}]}
	],


	(* -------------------------- TESTS ------------------------- *)
	Test["Pair two strands:",
		Pairing[Strand[DNA["ATCGTAGCGTA"]],Strand[DNA["ATCGCGCGCTA"]],MinLevel->3],
		{Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 3 ;; 5}, {2, 7 ;; 9}]}], Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 5 ;; 7}, {2, 7 ;; 9}]}]}
	],
	Test["Pair two strands with multiple motifs:",
		Pairing[Strand[DNA["ATCGTAGCGTA"],DNA["ATCGCGCGCTA"]],Strand[DNA["ATCGCGCGCTA","Z"],RNA["ACUAUACACUAG","Q"]],MinLevel->3],
		{Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 7 ;; 9}, {2, 3 ;; 5}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 14 ;; 17}, {2, 3 ;; 6}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 14 ;; 19}, {2, 3 ;; 8}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 15 ;; 20}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 7 ;; 9}, {2, 5 ;; 7}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 17 ;; 20}, {2, 6 ;; 9}]}], Structure[{Strand[DNA["ATCGTAGCGTA"], DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGCGCGCTA", "Z"], RNA["ACUAUACACUAG", "Q"]]}, {Bond[{1, 5 ;; 9}, {2, 7 ;; 11}]}]}
	],
	Test["Pair two sequences:",
		Pairing["GCATGCATGCAGTGAATGCATC","TATGCATTGCAGCTAGCTAGC",MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 3}, {2, 8 ;; 10}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 3 ;; 8}, {2, 2 ;; 7}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 4 ;; 7}, {2, 8 ;; 11}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 7 ;; 11}, {2, 3 ;; 7}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 8 ;; 11}, {2, 8 ;; 11}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 15 ;; 21}, {2, 2 ;; 8}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 17 ;; 20}, {2, 8 ;; 11}]}]}
	],
	Test["Pairing with one sequence interval:",
		Pairing[{"GCATGCATGCAGTGAATGCATC",{1,2}},"TATGCATTGCAGCTAGCTAGC",MinLevel->3],
		{Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 4}, {2, 2 ;; 5}]}], Structure[{Strand[DNA["GCATGCATGCAGTGAATGCATC"]], Strand[DNA["TATGCATTGCAGCTAGCTAGC"]]}, {Bond[{1, 1 ;; 3}, {2, 8 ;; 10}]}]}
	]

}];



(* ::Subsubsection::Closed:: *)
(*mismatchPatterns*)


DefineTests[mismatchPatterns,{
	Test[SetDifference[mismatchPatterns["A",1,1],{}],{}],
	Test[SetDifference[mismatchPatterns["A",2,1],{}],{}],
	Test[SetDifference[mismatchPatterns["A",1,3],{}],{}],
	Test[SetDifference[mismatchPatterns["ACGTA",2,1],{{"A"~~Except["C"]~~"GTA",{{1,3},{5,5}},{{1,1},{3,5}}},{"AC"~~Except["G"]~~"TA",{{1,2},{4,5}},{{1,2},{4,5}}},{"ACG"~~Except["T"]~~"A",{{1,1},{3,5}},{{1,3},{5,5}}},{"A"~~Except["C"]~~Except["G"]~~"TA",{{1,2},{5,5}},{{1,1},{4,5}}},{"A"~~Except["C"]~~"G"~~Except["T"]~~"A",{{1,1},{3,3},{5,5}},{{1,1},{3,3},{5,5}}},{"AC"~~Except["G"]~~Except["T"]~~"A",{{1,1},{4,5}},{{1,2},{5,5}}},{"AGTA",{{1,3},{5,5}},{{1,1},{2,4}}},{"ACTA",{{1,2},{4,5}},{{1,2},{3,4}}},{"ACGA",{{1,1},{3,5}},{{1,3},{4,4}}},{"ATA",{{1,2},{5,5}},{{1,1},{2,3}}},{"AGA",{{1,1},{3,3},{5,5}},{{1,1},{2,2},{3,3}}},{"ACA",{{1,1},{4,5}},{{1,2},{3,3}}},{"A"~~_~~"CGT",{{2,4},{5,5}},{{1,1},{3,5}}},{"AC"~~_~~"GT",{{2,3},{4,5}},{{1,2},{4,5}}},{"ACG"~~_~~"T",{{2,2},{3,5}},{{1,3},{5,5}}},{"C"~~_~~"GTA",{{1,3},{4,4}},{{1,1},{3,5}}},{"CG"~~_~~"TA",{{1,2},{3,4}},{{1,2},{4,5}}},{"CGT"~~_~~"A",{{1,1},{2,4}},{{1,3},{5,5}}},{"A"~~_~~_~~"CG",{{3,4},{5,5}},{{1,1},{4,5}}},{"A"~~_~~"C"~~_~~"G",{{3,3},{4,4},{5,5}},{{1,1},{3,3},{5,5}}},{"AC"~~_~~_~~"G",{{3,3},{4,5}},{{1,2},{5,5}}},{"C"~~_~~_~~"GT",{{2,3},{4,4}},{{1,1},{4,5}}},{"C"~~_~~"G"~~_~~"T",{{2,2},{3,3},{4,4}},{{1,1},{3,3},{5,5}}},{"CG"~~_~~_~~"T",{{2,2},{3,4}},{{1,2},{5,5}}},{"G"~~_~~_~~"TA",{{1,2},{3,3}},{{1,1},{4,5}}},{"G"~~_~~"T"~~_~~"A",{{1,1},{2,2},{3,3}},{{1,1},{3,3},{5,5}}},{"GT"~~_~~_~~"A",{{1,1},{2,3}},{{1,2},{5,5}}}}],{}],
	Test[SetDifference[mismatchPatterns["ABCDEFGH",1,1],{{"A"~~Except["B"]~~"CDEFGH",{{1,6},{8,8}},{{1,1},{3,8}}},{"AB"~~Except["C"]~~"DEFGH",{{1,5},{7,8}},{{1,2},{4,8}}},{"ABC"~~Except["D"]~~"EFGH",{{1,4},{6,8}},{{1,3},{5,8}}},{"ABCD"~~Except["E"]~~"FGH",{{1,3},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~Except["F"]~~"GH",{{1,2},{4,8}},{{1,5},{7,8}}},{"ABCDEF"~~Except["G"]~~"H",{{1,1},{3,8}},{{1,6},{8,8}}},{"ACDEFGH",{{1,6},{8,8}},{{1,1},{2,7}}},{"ABDEFGH",{{1,5},{7,8}},{{1,2},{3,7}}},{"ABCEFGH",{{1,4},{6,8}},{{1,3},{4,7}}},{"ABCDFGH",{{1,3},{5,8}},{{1,4},{5,7}}},{"ABCDEGH",{{1,2},{4,8}},{{1,5},{6,7}}},{"ABCDEFH",{{1,1},{3,8}},{{1,6},{7,7}}},{"A"~~_~~"BCDEFG",{{2,7},{8,8}},{{1,1},{3,8}}},{"AB"~~_~~"CDEFG",{{2,6},{7,8}},{{1,2},{4,8}}},{"ABC"~~_~~"DEFG",{{2,5},{6,8}},{{1,3},{5,8}}},{"ABCD"~~_~~"EFG",{{2,4},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~_~~"FG",{{2,3},{4,8}},{{1,5},{7,8}}},{"ABCDEF"~~_~~"G",{{2,2},{3,8}},{{1,6},{8,8}}},{"B"~~_~~"CDEFGH",{{1,6},{7,7}},{{1,1},{3,8}}},{"BC"~~_~~"DEFGH",{{1,5},{6,7}},{{1,2},{4,8}}},{"BCD"~~_~~"EFGH",{{1,4},{5,7}},{{1,3},{5,8}}},{"BCDE"~~_~~"FGH",{{1,3},{4,7}},{{1,4},{6,8}}},{"BCDEF"~~_~~"GH",{{1,2},{3,7}},{{1,5},{7,8}}},{"BCDEFG"~~_~~"H",{{1,1},{2,7}},{{1,6},{8,8}}}}],{}],
	Test[SetDifference[mismatchPatterns["ABCDEFGH",1,3],{{"ABC"~~Except["D"]~~"EFGH",{{1,4},{6,8}},{{1,3},{5,8}}},{"ABCD"~~Except["E"]~~"FGH",{{1,3},{5,8}},{{1,4},{6,8}}},{"ABCEFGH",{{1,4},{6,8}},{{1,3},{4,7}}},{"ABCDFGH",{{1,3},{5,8}},{{1,4},{5,7}}},{"ABC"~~_~~"DEFG",{{2,5},{6,8}},{{1,3},{5,8}}},{"ABCD"~~_~~"EFG",{{2,4},{5,8}},{{1,4},{6,8}}},{"BCD"~~_~~"EFGH",{{1,4},{5,7}},{{1,3},{5,8}}},{"BCDE"~~_~~"FGH",{{1,3},{4,7}},{{1,4},{6,8}}}}],{}],
	Test[SetDifference[mismatchPatterns["ABCDEFGH",2,1],{{"A"~~Except["B"]~~"CDEFGH",{{1,6},{8,8}},{{1,1},{3,8}}},{"AB"~~Except["C"]~~"DEFGH",{{1,5},{7,8}},{{1,2},{4,8}}},{"ABC"~~Except["D"]~~"EFGH",{{1,4},{6,8}},{{1,3},{5,8}}},{"ABCD"~~Except["E"]~~"FGH",{{1,3},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~Except["F"]~~"GH",{{1,2},{4,8}},{{1,5},{7,8}}},{"ABCDEF"~~Except["G"]~~"H",{{1,1},{3,8}},{{1,6},{8,8}}},{"A"~~Except["B"]~~Except["C"]~~"DEFGH",{{1,5},{8,8}},{{1,1},{4,8}}},{"A"~~Except["B"]~~"C"~~Except["D"]~~"EFGH",{{1,4},{6,6},{8,8}},{{1,1},{3,3},{5,8}}},{"A"~~Except["B"]~~"CD"~~Except["E"]~~"FGH",{{1,3},{5,6},{8,8}},{{1,1},{3,4},{6,8}}},{"A"~~Except["B"]~~"CDE"~~Except["F"]~~"GH",{{1,2},{4,6},{8,8}},{{1,1},{3,5},{7,8}}},{"A"~~Except["B"]~~"CDEF"~~Except["G"]~~"H",{{1,1},{3,6},{8,8}},{{1,1},{3,6},{8,8}}},{"AB"~~Except["C"]~~Except["D"]~~"EFGH",{{1,4},{7,8}},{{1,2},{5,8}}},{"AB"~~Except["C"]~~"D"~~Except["E"]~~"FGH",{{1,3},{5,5},{7,8}},{{1,2},{4,4},{6,8}}},{"AB"~~Except["C"]~~"DE"~~Except["F"]~~"GH",{{1,2},{4,5},{7,8}},{{1,2},{4,5},{7,8}}},{"AB"~~Except["C"]~~"DEF"~~Except["G"]~~"H",{{1,1},{3,5},{7,8}},{{1,2},{4,6},{8,8}}},{"ABC"~~Except["D"]~~Except["E"]~~"FGH",{{1,3},{6,8}},{{1,3},{6,8}}},{"ABC"~~Except["D"]~~"E"~~Except["F"]~~"GH",{{1,2},{4,4},{6,8}},{{1,3},{5,5},{7,8}}},{"ABC"~~Except["D"]~~"EF"~~Except["G"]~~"H",{{1,1},{3,4},{6,8}},{{1,3},{5,6},{8,8}}},{"ABCD"~~Except["E"]~~Except["F"]~~"GH",{{1,2},{5,8}},{{1,4},{7,8}}},{"ABCD"~~Except["E"]~~"F"~~Except["G"]~~"H",{{1,1},{3,3},{5,8}},{{1,4},{6,6},{8,8}}},{"ABCDE"~~Except["F"]~~Except["G"]~~"H",{{1,1},{4,8}},{{1,5},{8,8}}},{"ACDEFGH",{{1,6},{8,8}},{{1,1},{2,7}}},{"ABDEFGH",{{1,5},{7,8}},{{1,2},{3,7}}},{"ABCEFGH",{{1,4},{6,8}},{{1,3},{4,7}}},{"ABCDFGH",{{1,3},{5,8}},{{1,4},{5,7}}},{"ABCDEGH",{{1,2},{4,8}},{{1,5},{6,7}}},{"ABCDEFH",{{1,1},{3,8}},{{1,6},{7,7}}},{"ADEFGH",{{1,5},{8,8}},{{1,1},{2,6}}},{"ACEFGH",{{1,4},{6,6},{8,8}},{{1,1},{2,2},{3,6}}},{"ACDFGH",{{1,3},{5,6},{8,8}},{{1,1},{2,3},{4,6}}},{"ACDEGH",{{1,2},{4,6},{8,8}},{{1,1},{2,4},{5,6}}},{"ACDEFH",{{1,1},{3,6},{8,8}},{{1,1},{2,5},{6,6}}},{"ABEFGH",{{1,4},{7,8}},{{1,2},{3,6}}},{"ABDFGH",{{1,3},{5,5},{7,8}},{{1,2},{3,3},{4,6}}},{"ABDEGH",{{1,2},{4,5},{7,8}},{{1,2},{3,4},{5,6}}},{"ABDEFH",{{1,1},{3,5},{7,8}},{{1,2},{3,5},{6,6}}},{"ABCFGH",{{1,3},{6,8}},{{1,3},{4,6}}},{"ABCEGH",{{1,2},{4,4},{6,8}},{{1,3},{4,4},{5,6}}},{"ABCEFH",{{1,1},{3,4},{6,8}},{{1,3},{4,5},{6,6}}},{"ABCDGH",{{1,2},{5,8}},{{1,4},{5,6}}},{"ABCDFH",{{1,1},{3,3},{5,8}},{{1,4},{5,5},{6,6}}},{"ABCDEH",{{1,1},{4,8}},{{1,5},{6,6}}},{"A"~~_~~"BCDEFG",{{2,7},{8,8}},{{1,1},{3,8}}},{"AB"~~_~~"CDEFG",{{2,6},{7,8}},{{1,2},{4,8}}},{"ABC"~~_~~"DEFG",{{2,5},{6,8}},{{1,3},{5,8}}},{"ABCD"~~_~~"EFG",{{2,4},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~_~~"FG",{{2,3},{4,8}},{{1,5},{7,8}}},{"ABCDEF"~~_~~"G",{{2,2},{3,8}},{{1,6},{8,8}}},{"B"~~_~~"CDEFGH",{{1,6},{7,7}},{{1,1},{3,8}}},{"BC"~~_~~"DEFGH",{{1,5},{6,7}},{{1,2},{4,8}}},{"BCD"~~_~~"EFGH",{{1,4},{5,7}},{{1,3},{5,8}}},{"BCDE"~~_~~"FGH",{{1,3},{4,7}},{{1,4},{6,8}}},{"BCDEF"~~_~~"GH",{{1,2},{3,7}},{{1,5},{7,8}}},{"BCDEFG"~~_~~"H",{{1,1},{2,7}},{{1,6},{8,8}}},{"A"~~_~~_~~"BCDEF",{{3,7},{8,8}},{{1,1},{4,8}}},{"A"~~_~~"B"~~_~~"CDEF",{{3,6},{7,7},{8,8}},{{1,1},{3,3},{5,8}}},{"A"~~_~~"BC"~~_~~"DEF",{{3,5},{6,7},{8,8}},{{1,1},{3,4},{6,8}}},{"A"~~_~~"BCD"~~_~~"EF",{{3,4},{5,7},{8,8}},{{1,1},{3,5},{7,8}}},{"A"~~_~~"BCDE"~~_~~"F",{{3,3},{4,7},{8,8}},{{1,1},{3,6},{8,8}}},{"AB"~~_~~_~~"CDEF",{{3,6},{7,8}},{{1,2},{5,8}}},{"AB"~~_~~"C"~~_~~"DEF",{{3,5},{6,6},{7,8}},{{1,2},{4,4},{6,8}}},{"AB"~~_~~"CD"~~_~~"EF",{{3,4},{5,6},{7,8}},{{1,2},{4,5},{7,8}}},{"AB"~~_~~"CDE"~~_~~"F",{{3,3},{4,6},{7,8}},{{1,2},{4,6},{8,8}}},{"ABC"~~_~~_~~"DEF",{{3,5},{6,8}},{{1,3},{6,8}}},{"ABC"~~_~~"D"~~_~~"EF",{{3,4},{5,5},{6,8}},{{1,3},{5,5},{7,8}}},{"ABC"~~_~~"DE"~~_~~"F",{{3,3},{4,5},{6,8}},{{1,3},{5,6},{8,8}}},{"ABCD"~~_~~_~~"EF",{{3,4},{5,8}},{{1,4},{7,8}}},{"ABCD"~~_~~"E"~~_~~"F",{{3,3},{4,4},{5,8}},{{1,4},{6,6},{8,8}}},{"ABCDE"~~_~~_~~"F",{{3,3},{4,8}},{{1,5},{8,8}}},{"B"~~_~~_~~"CDEFG",{{2,6},{7,7}},{{1,1},{4,8}}},{"B"~~_~~"C"~~_~~"DEFG",{{2,5},{6,6},{7,7}},{{1,1},{3,3},{5,8}}},{"B"~~_~~"CD"~~_~~"EFG",{{2,4},{5,6},{7,7}},{{1,1},{3,4},{6,8}}},{"B"~~_~~"CDE"~~_~~"FG",{{2,3},{4,6},{7,7}},{{1,1},{3,5},{7,8}}},{"B"~~_~~"CDEF"~~_~~"G",{{2,2},{3,6},{7,7}},{{1,1},{3,6},{8,8}}},{"BC"~~_~~_~~"DEFG",{{2,5},{6,7}},{{1,2},{5,8}}},{"BC"~~_~~"D"~~_~~"EFG",{{2,4},{5,5},{6,7}},{{1,2},{4,4},{6,8}}},{"BC"~~_~~"DE"~~_~~"FG",{{2,3},{4,5},{6,7}},{{1,2},{4,5},{7,8}}},{"BC"~~_~~"DEF"~~_~~"G",{{2,2},{3,5},{6,7}},{{1,2},{4,6},{8,8}}},{"BCD"~~_~~_~~"EFG",{{2,4},{5,7}},{{1,3},{6,8}}},{"BCD"~~_~~"E"~~_~~"FG",{{2,3},{4,4},{5,7}},{{1,3},{5,5},{7,8}}},{"BCD"~~_~~"EF"~~_~~"G",{{2,2},{3,4},{5,7}},{{1,3},{5,6},{8,8}}},{"BCDE"~~_~~_~~"FG",{{2,3},{4,7}},{{1,4},{7,8}}},{"BCDE"~~_~~"F"~~_~~"G",{{2,2},{3,3},{4,7}},{{1,4},{6,6},{8,8}}},{"BCDEF"~~_~~_~~"G",{{2,2},{3,7}},{{1,5},{8,8}}},{"C"~~_~~_~~"DEFGH",{{1,5},{6,6}},{{1,1},{4,8}}},{"C"~~_~~"D"~~_~~"EFGH",{{1,4},{5,5},{6,6}},{{1,1},{3,3},{5,8}}},{"C"~~_~~"DE"~~_~~"FGH",{{1,3},{4,5},{6,6}},{{1,1},{3,4},{6,8}}},{"C"~~_~~"DEF"~~_~~"GH",{{1,2},{3,5},{6,6}},{{1,1},{3,5},{7,8}}},{"C"~~_~~"DEFG"~~_~~"H",{{1,1},{2,5},{6,6}},{{1,1},{3,6},{8,8}}},{"CD"~~_~~_~~"EFGH",{{1,4},{5,6}},{{1,2},{5,8}}},{"CD"~~_~~"E"~~_~~"FGH",{{1,3},{4,4},{5,6}},{{1,2},{4,4},{6,8}}},{"CD"~~_~~"EF"~~_~~"GH",{{1,2},{3,4},{5,6}},{{1,2},{4,5},{7,8}}},{"CD"~~_~~"EFG"~~_~~"H",{{1,1},{2,4},{5,6}},{{1,2},{4,6},{8,8}}},{"CDE"~~_~~_~~"FGH",{{1,3},{4,6}},{{1,3},{6,8}}},{"CDE"~~_~~"F"~~_~~"GH",{{1,2},{3,3},{4,6}},{{1,3},{5,5},{7,8}}},{"CDE"~~_~~"FG"~~_~~"H",{{1,1},{2,3},{4,6}},{{1,3},{5,6},{8,8}}},{"CDEF"~~_~~_~~"GH",{{1,2},{3,6}},{{1,4},{7,8}}},{"CDEF"~~_~~"G"~~_~~"H",{{1,1},{2,2},{3,6}},{{1,4},{6,6},{8,8}}},{"CDEFG"~~_~~_~~"H",{{1,1},{2,6}},{{1,5},{8,8}}}}],{}],
	Test[SetDifference[mismatchPatterns["ABCDEFGH",2,2],{{"AB"~~Except["C"]~~"DEFGH",{{1,5},{7,8}},{{1,2},{4,8}}},{"ABC"~~Except["D"]~~"EFGH",{{1,4},{6,8}},{{1,3},{5,8}}},{"ABCD"~~Except["E"]~~"FGH",{{1,3},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~Except["F"]~~"GH",{{1,2},{4,8}},{{1,5},{7,8}}},{"AB"~~Except["C"]~~Except["D"]~~"EFGH",{{1,4},{7,8}},{{1,2},{5,8}}},{"AB"~~Except["C"]~~"DE"~~Except["F"]~~"GH",{{1,2},{4,5},{7,8}},{{1,2},{4,5},{7,8}}},{"ABC"~~Except["D"]~~Except["E"]~~"FGH",{{1,3},{6,8}},{{1,3},{6,8}}},{"ABCD"~~Except["E"]~~Except["F"]~~"GH",{{1,2},{5,8}},{{1,4},{7,8}}},{"ABDEFGH",{{1,5},{7,8}},{{1,2},{3,7}}},{"ABCEFGH",{{1,4},{6,8}},{{1,3},{4,7}}},{"ABCDFGH",{{1,3},{5,8}},{{1,4},{5,7}}},{"ABCDEGH",{{1,2},{4,8}},{{1,5},{6,7}}},{"ABEFGH",{{1,4},{7,8}},{{1,2},{3,6}}},{"ABDEGH",{{1,2},{4,5},{7,8}},{{1,2},{3,4},{5,6}}},{"ABCFGH",{{1,3},{6,8}},{{1,3},{4,6}}},{"ABCDGH",{{1,2},{5,8}},{{1,4},{5,6}}},{"AB"~~_~~"CDEFG",{{2,6},{7,8}},{{1,2},{4,8}}},{"ABC"~~_~~"DEFG",{{2,5},{6,8}},{{1,3},{5,8}}},{"ABCD"~~_~~"EFG",{{2,4},{5,8}},{{1,4},{6,8}}},{"ABCDE"~~_~~"FG",{{2,3},{4,8}},{{1,5},{7,8}}},{"BC"~~_~~"DEFGH",{{1,5},{6,7}},{{1,2},{4,8}}},{"BCD"~~_~~"EFGH",{{1,4},{5,7}},{{1,3},{5,8}}},{"BCDE"~~_~~"FGH",{{1,3},{4,7}},{{1,4},{6,8}}},{"BCDEF"~~_~~"GH",{{1,2},{3,7}},{{1,5},{7,8}}},{"AB"~~_~~_~~"CDEF",{{3,6},{7,8}},{{1,2},{5,8}}},{"AB"~~_~~"CD"~~_~~"EF",{{3,4},{5,6},{7,8}},{{1,2},{4,5},{7,8}}},{"ABC"~~_~~_~~"DEF",{{3,5},{6,8}},{{1,3},{6,8}}},{"ABCD"~~_~~_~~"EF",{{3,4},{5,8}},{{1,4},{7,8}}},{"BC"~~_~~_~~"DEFG",{{2,5},{6,7}},{{1,2},{5,8}}},{"BC"~~_~~"DE"~~_~~"FG",{{2,3},{4,5},{6,7}},{{1,2},{4,5},{7,8}}},{"BCD"~~_~~_~~"EFG",{{2,4},{5,7}},{{1,3},{6,8}}},{"BCDE"~~_~~_~~"FG",{{2,3},{4,7}},{{1,4},{7,8}}},{"CD"~~_~~_~~"EFGH",{{1,4},{5,6}},{{1,2},{5,8}}},{"CD"~~_~~"EF"~~_~~"GH",{{1,2},{3,4},{5,6}},{{1,2},{4,5},{7,8}}},{"CDE"~~_~~_~~"FGH",{{1,3},{4,6}},{{1,3},{6,8}}},{"CDEF"~~_~~_~~"GH",{{1,2},{3,6}},{{1,4},{7,8}}}}],{}],
	Test[SetDifference[mismatchPatterns["ABCDEFGH",2,3],{{"ABC"~~Except["D"]~~"EFGH",{{1,4},{6,8}},{{1,3},{5,8}}},{"ABCD"~~Except["E"]~~"FGH",{{1,3},{5,8}},{{1,4},{6,8}}},{"ABC"~~Except["D"]~~Except["E"]~~"FGH",{{1,3},{6,8}},{{1,3},{6,8}}},{"ABCEFGH",{{1,4},{6,8}},{{1,3},{4,7}}},{"ABCDFGH",{{1,3},{5,8}},{{1,4},{5,7}}},{"ABCFGH",{{1,3},{6,8}},{{1,3},{4,6}}}}],{}]
}];


(* ::Subsection:: *)
(*Simulate*)


(* ::Subsubsection:: *)
(*SimulateFolding*)


DefineTestsWithCompanions[SimulateFolding,
	{

		Example[{Basic, "When provided with a sequence, SimulateFolding predicts potentially high energy secondary structures the sequence could fold into through Watson-Crick base pairing rules:"},
			SimulateFolding["ACGTACGTACGT"][FoldedStructures],
			{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["ACGTACGTACGT"][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGT", Upload->False]
			}
		],

		Test["When provided with a sequence, SimulateFolding predicts potentially high energy secondary structures the sequence could fold into through Watson-Crick base pairing rules:",
			Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGT", Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
			TimeConstraint->200
		],

		Example[{Basic, "In addition to accepting sequences, the function can handle strands with more than one sequence:"},
			SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]][FoldedStructures],
			{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Upload->False]
			}
		],

		Example[{Basic, "The function can also handled complicate structures where it considers the high energy structures that might further form through folding:"},
			SimulateFolding[Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]][FoldedStructures],
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {2, 4 ;; 6}], Bond[{1, 5 ;; 7}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 6}, {2, 1 ;; 6}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}], Upload->False]
			}
		],

		Example[{Basic, "The function can also be applied to oligomer samples:"},
			SimulateFolding[Object[Sample,"id:M8n3rxYAkL4P"]][FoldedStructures],
			{StructureP},
			TimeConstraint->300,
			Stubs :> {
				SimulateFolding[Object[Sample,"id:M8n3rxYAkL4P"]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Object[Sample,"id:M8n3rxYAkL4P"], Upload->False]
			}
		],

		Example[{Basic, "The function can also be applied to oligomer models:"},
			SimulateFolding[Model[Sample,"id:eGakld01zK4E"]][FoldedStructures],
			{StructureP, StructureP},
			TimeConstraint->120,
			Stubs :> {
				SimulateFolding[Model[Sample,"id:eGakld01zK4E"]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Model[Sample,"id:eGakld01zK4E"], Upload->False]
			}
		],

		(* ------ Additional ------ *)

		Example[{Additional,"Inter-strand bonds:","Options from a bonds will be created between strands that are not connected:"},
			SimulateFolding[Structure[{Strand[DNA["TTT"]],Strand[DNA["AAA"]]},{}]],
			$Failed,
			Messages:>{Error::UnboundStructure,Error::InvalidInput},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Structure[{Strand[DNA["TTT"]],Strand[DNA["AAA"]]},{}]] =
				SimulateFolding[Structure[{Strand[DNA["TTT"]],Strand[DNA["AAA"]]},{}], Upload->False]
			}
		],

		Example[{Additional,"Inter-strand bonds:","If two strands are already connected by bonds, then inter-strand bonds can be created:"},
			SimulateFolding[Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]][FoldedStructures],
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {2, 4 ;; 6}], Bond[{1, 5 ;; 7}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 6}, {2, 1 ;; 6}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}], Upload->False]
			}
		],

		Example[{Additional,"Pseudoknots","Kinetic folding method can return pseudoknots, which are excluded by the thermodynamic folding algorithm:"},
			{SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Kinetic,Breadth->1][FoldedStructures], SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Thermodynamic][FoldedStructures]},
			{{Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]}, {Bond[{1, 2 ;; 4}, {1, 12 ;; 14}], Bond[{1, 8 ;; 11}, {1, 21 ;; 24}]}]}, {Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]}, {Bond[{1, 2 ;; 5}, {1, 11 ;; 14}]}]}},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Kinetic,Breadth->1][FoldedStructures] = Append[FoldedStructures] /. SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Kinetic,Breadth->1, Upload->False],
				SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Thermodynamic][FoldedStructures] = Append[FoldedStructures] /. SimulateFolding["GATCTATGAAAGATTGTGAATTTCC", Method->Thermodynamic, Upload->False]
			}
		],

		Example[{Additional,"Pseudoknots","Long strands can be folded into a variety of structures with and without pseudoknots:"},
			SimulateFolding[Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]][FoldedStructures],
			{Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 14 ;; 16}, {1, 26 ;; 28}], Bond[{1, 33 ;; 35}, {1, 39 ;; 41}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 12 ;; 14}, {1, 26 ;; 28}], Bond[{1, 15 ;; 17}, {1, 42 ;; 44}], Bond[{1, 33 ;; 35}, {1, 39 ;; 41}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 12 ;; 14}, {1, 26 ;; 28}], Bond[{1, 15 ;; 17}, {1, 42 ;; 44}], Bond[{1, 20 ;; 22}, {1, 35 ;; 37}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 7 ;; 9}, {1, 24 ;; 26}], Bond[{1, 15 ;; 17}, {1, 42 ;; 44}], Bond[{1, 33 ;; 35}, {1, 39 ;; 41}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 7 ;; 9}, {1, 24 ;; 26}], Bond[{1, 15 ;; 17}, {1, 42 ;; 44}], Bond[{1, 20 ;; 22}, {1, 35 ;; 37}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 5 ;; 7}, {1, 40 ;; 42}], Bond[{1, 14 ;; 16}, {1, 26 ;; 28}], Bond[{1, 20 ;; 22}, {1, 35 ;; 37}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 12 ;; 14}, {1, 26 ;; 28}], Bond[{1, 33 ;; 35}, {1, 39 ;; 41}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 7 ;; 9}, {1, 24 ;; 26}], Bond[{1, 33 ;; 35}, {1, 39 ;; 41}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 7 ;; 9}, {1, 24 ;; 26}], Bond[{1, 20 ;; 22}, {1, 35 ;; 37}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 5 ;; 7}, {1, 40 ;; 42}], Bond[{1, 12 ;; 14}, {1, 26 ;; 28}], Bond[{1, 20 ;; 22}, {1, 35 ;; 37}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]]][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Strand[DNA["CTCAAGGCATAGTGT"], DNA["GACGTTCGTGCACCG"], DNA["GCGGGAATCCCTCAG"]], Upload->False]
			}
		],

		Example[{Additional, "Get FoldedEnergies and FoldedStructures:"},
			SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic][[{FoldedStructures, FoldedEnergies}]],
			{{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 2 ;; 4}, {1, 32 ;; 34}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]}, {Quantity[-11.82, "KilocaloriesThermochemical"/"Moles"], Quantity[-9.980000000000004, "KilocaloriesThermochemical"/"Moles"], Quantity[-9.700000000000003, "KilocaloriesThermochemical"/"Moles"]}},
			TimeConstraint->200
		],


		(* ------ Options ------ *)

		Example[{Options, FoldingInterval, "For sequences, specify interval as list of positions in the sequence:"},
			SimulateFolding["ACGTAGCTAGCTAGCGCATCG", FoldingInterval->{1,4}][FoldedStructures],
			{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["ACGTAGCTAGCTAGCGCATCG", FoldingInterval->{1,4}][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["ACGTAGCTAGCTAGCGCATCG", FoldingInterval->{1,4}, Upload->False]
			}
		],

		Example[{Options, FoldingInterval, "For strands, specify interval as motif position and sequence positions:"},
			SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], FoldingInterval->{3,{1,4}}][FoldedStructures],
			{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], FoldingInterval->{3,{1,4}}][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], FoldingInterval->{3,{1,4}}, Upload->False]
			}
		],

		Example[{Options, FoldingInterval, "For structures, specify interval as Strand position, motif position, and sequence positions:"},
			SimulateFolding[Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]},{}], FoldingInterval->{1,1,{4,8}}][FoldedStructures],
			{Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]}, {Bond[{1, 2 ;; 5}, {1, 11 ;; 14}], Bond[{1, 8 ;; 10}, {1, 22 ;; 24}]}], Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]}, {Bond[{1, 2 ;; 4}, {1, 12 ;; 14}], Bond[{1, 8 ;; 11}, {1, 21 ;; 24}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]},{}], FoldingInterval->{1,1,{4,8}}][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["GATCTATGAAAGATTGTGAATTTCC"]]},{}], FoldingInterval->{1,1,{4,8}}, Upload->False]
			}
		],

		Example[{Options, MinLevel,"Specify minimum number of bases required in each fold:"},
			SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], MinLevel->4][FoldedStructures],
			{Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 13 ;; 16}, {1, 23 ;; 26}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], MinLevel->4][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], MinLevel->4, Upload->False]
			}
		],

		Example[{Options, Depth, "Specify number of times to fold the input sequence:"},
			SimulateFolding["ACGTAGCTAGCTAGCGCATCG", Depth->3][FoldedStructures],
			{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 6 ;; 8}, {1, 13 ;; 15}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["ACGTAGCTAGCTAGCGCATCG", Depth->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["ACGTAGCTAGCTAGCGCATCG", Depth->3, Upload->False]
			}
		],

		Example[{Options, Breadth, "Specify the number of folds to propagate forward at each level of the folding tree:"},
			SimulateFolding["CCCCAACACCCCAAAGGTTTGTG", Breadth->3][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAACACCCCAAAGGTTTGTG"]]}, {Bond[{1, 7 ;; 9}, {1, 21 ;; 23}]}], Structure[{Strand[DNA["CCCCAACACCCCAAAGGTTTGTG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}], Bond[{1, 12 ;; 14}, {1, 19 ;; 21}]}], Structure[{Strand[DNA["CCCCAACACCCCAAAGGTTTGTG"]]}, {Bond[{1, 4 ;; 6}, {1, 19 ;; 21}], Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAACACCCCAAAGGTTTGTG", Breadth->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAACACCCCAAAGGTTTGTG", Breadth->3, Upload->False]
			}
		],

		Example[{Options, Consolidate, "Specify Consilidate to be False to return subfolds:"},
			SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Consolidate->False][FoldedStructures],
			{Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 13 ;; 16}, {1, 23 ;; 26}]}], Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 14 ;; 16}, {1, 23 ;; 25}]}], Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 13 ;; 15}, {1, 24 ;; 26}]}], Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 2 ;; 4}, {1, 25 ;; 27}], Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 14 ;; 16}, {1, 30 ;; 32}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Consolidate->False][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Consolidate->False, Upload->False]
			}
		],

		Example[{Options, MaxMismatch, "When you do not allow mismatch, sequence \"CCCACCAAAGG\" can not return a valid folded structure:"},
			SimulateFolding["CCCACCAAAGG", MaxMismatch->0][FoldedStructures],
			{},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCACCAAAGG", MaxMismatch->0][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCACCAAAGG", MaxMismatch->0, Upload->False]
			}
		],

		Example[{Options, MaxMismatch, "But by allowing mismatches of size 1, two structures with a bulge loop appears:"},
			SimulateFolding["CCCACCAAAGG", MaxMismatch->1][FoldedStructures],
			{Structure[{Strand[DNA["CCCACCAAAGG"]]}, {Bond[{1, 3 ;; 3}, {1, 11 ;; 11}], Bond[{1, 5 ;; 5}, {1, 10 ;; 10}]}], Structure[{Strand[DNA["CCCACCAAAGG"]]}, {Bond[{1, 1 ;; 1}, {1, 11 ;; 11}], Bond[{1, 3 ;; 3}, {1, 10 ;; 10}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCACCAAAGG", MaxMismatch->1][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCACCAAAGG", MaxMismatch->1, Upload->False]
			}
		],

		Example[{Options, MinPieceSize, "Specify minimum number of consecutive paired bases required in a fold containing mismatches:"},
			SimulateFolding["CCCACCAAAGGGGTCGGG", MinPieceSize->1][FoldedStructures],
			{Structure[{Strand[DNA["CCCACCAAAGGGGTCGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 11 ;; 13}]}], Structure[{Strand[DNA["CCCACCAAAGGGGTCGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}]}], Structure[{Strand[DNA["CCCACCAAAGGGGTCGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}], Bond[{1, 4 ;; 6}, {1, 12 ;; 14}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCACCAAAGGGGTCGGG", MinPieceSize->1][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCACCAAAGGGGTCGGG", MinPieceSize->1, Upload->False]
			}
		],

		Example[{Options, Temperature, "Specify temperature at which folding is simulated:"},
			SimulateFolding["AAAAACCCACCCCAAAGGGAAAGGG", Temperature->20 Celsius][FoldedStructures],
			{Structure[{Strand[DNA["AAAAACCCACCCCAAAGGGAAAGGG"]]}, {Bond[{1, 6 ;; 8}, {1, 23 ;; 25}], Bond[{1, 11 ;; 13}, {1, 17 ;; 19}]}], Structure[{Strand[DNA["AAAAACCCACCCCAAAGGGAAAGGG"]]}, {Bond[{1, 6 ;; 8}, {1, 23 ;; 25}], Bond[{1, 10 ;; 12}, {1, 17 ;; 19}]}], Structure[{Strand[DNA["AAAAACCCACCCCAAAGGGAAAGGG"]]}, {Bond[{1, 6 ;; 8}, {1, 17 ;; 19}], Bond[{1, 11 ;; 13}, {1, 23 ;; 25}]}], Structure[{Strand[DNA["AAAAACCCACCCCAAAGGGAAAGGG"]]}, {Bond[{1, 6 ;; 8}, {1, 17 ;; 19}], Bond[{1, 10 ;; 12}, {1, 23 ;; 25}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["AAAAACCCACCCCAAAGGGAAAGGG", Temperature->20 Celsius][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["AAAAACCCACCCCAAAGGGAAAGGG", Temperature->20 Celsius, Upload->False]
			}
		],

		Example[{Options, Template, "The options from a previous folding simulation can be used to create new foldings (object reference):"},
			SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Template->Object[Simulation,Folding,"id:dORYzZJJEOZb", ResolvedOptions]][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 2 ;; 4}, {1, 32 ;; 34}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]},
			TimeConstraint->200,
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Folding], UnresolvedOptions -> {Method->Thermodynamic, Heuristic->Energy, Polymer->DNA, Temperature->Quantity[37, "DegreesCelsius"], FoldingInterval->All, Depth->Infinity, Breadth->20, Consolidate->True, SubOptimalStructureTolerance->Quantity[25, "Percent"], MaxMismatch->0, MinPieceSize->1, MinLevel->3, ExcludedSubstructures -> {}, MinHairpinLoopSize->3, MaxHairpinLoopSize->Infinity, MinInternalLoopSize->2, MaxInternalLoopSize->Infinity, MinBulgeLoopSize->1, MaxBulgeLoopSize->Infinity, MinMultipleLoopSize->0, Upload->True}, ResolvedOptions -> {Method->Thermodynamic, Heuristic->Energy, Polymer->DNA, Temperature ->  Quantity[37, "DegreesCelsius"], Depth->Infinity, Breadth->20, Consolidate->True, SubOptimalStructureTolerance->Quantity[25, "Percent"], MaxMismatch->0, MinPieceSize->1, MinLevel->3, ExcludedSubstructures -> {}, MinHairpinLoopSize->3, MaxHairpinLoopSize->Infinity, MinInternalLoopSize->2, MaxInternalLoopSize->Infinity, MinBulgeLoopSize->1, MaxBulgeLoopSize->Infinity, MinMultipleLoopSize->0, Template->Null, Output->Result, Upload->True, FoldingInterval->All}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Template, "The options from a previous folding simulation can be used to create new foldings (object):"},
			SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Template->Object[Simulation,Folding,"id:dORYzZJJEOZb"]][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 2 ;; 4}, {1, 32 ;; 34}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}], Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]},
			TimeConstraint->200,
			SetUp :> (
				theTemplateObject = Upload[<|Type->Object[Simulation, Folding], UnresolvedOptions -> {Method->Thermodynamic, Heuristic->Energy, Polymer->DNA, Temperature->Quantity[37, "DegreesCelsius"], FoldingInterval->All, Depth->Infinity, Breadth->20, Consolidate->True, SubOptimalStructureTolerance->Quantity[25, "Percent"], MaxMismatch->0, MinPieceSize->1, MinLevel->3, ExcludedSubstructures -> {}, MinHairpinLoopSize->3, MaxHairpinLoopSize->Infinity, MinInternalLoopSize->2, MaxInternalLoopSize->Infinity, MinBulgeLoopSize->1, MaxBulgeLoopSize->Infinity, MinMultipleLoopSize->0, Upload->True}, ResolvedOptions -> {Method->Thermodynamic, Heuristic->Energy, Polymer->DNA, Temperature ->  Quantity[37, "DegreesCelsius"], Depth->Infinity, Breadth->20, Consolidate->True, SubOptimalStructureTolerance->Quantity[25, "Percent"], MaxMismatch->0, MinPieceSize->1, MinLevel->3, ExcludedSubstructures -> {}, MinHairpinLoopSize->3, MaxHairpinLoopSize->Infinity, MinInternalLoopSize->2, MaxInternalLoopSize->Infinity, MinBulgeLoopSize->1, MaxBulgeLoopSize->Infinity, MinMultipleLoopSize->0, Template->Null, Output->Result, Upload->True, FoldingInterval->All}, DeveloperObject->True|>];
				theTemplateObjectID = theTemplateObject[ID];
			),
			TearDown :> (
				If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
			)
		],

		Example[{Options, Polymer, "When the input sequence is ambiguous, Polymer is defaulted to DNA:"},
			SimulateFolding["CGCGCGCGCGC", Polymer->DNA][FoldedStructures],
			{Structure[{Strand[DNA["CGCGCGCGCGC"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}], Structure[{Strand[DNA["CGCGCGCGCGC"]]}, {Bond[{1, 1 ;; 3}, {1, 8 ;; 10}]}]},
			TimeConstraint->120,
			Stubs :> {
				SimulateFolding["CGCGCGCGCGC", Polymer->DNA][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CGCGCGCGCGC", Polymer->DNA, Upload->False]
			}
		],

		Example[{Options,Polymer, "But you can use Polymer option to specify the sequence to be RNA:"},
			SimulateFolding["CGCGCGCGCGC", Polymer->RNA][FoldedStructures],
			{Structure[{Strand[RNA["CGCGCGCGCGC"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}], Structure[{Strand[RNA["CGCGCGCGCGC"]]}, {Bond[{1, 1 ;; 3}, {1, 8 ;; 10}]}]},
			TimeConstraint->120,
			Stubs :> {
				SimulateFolding["CGCGCGCGCGC", Polymer->RNA][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CGCGCGCGCGC", Polymer->RNA, Upload->False]
			}
		],

		Example[{Options,MaxHairpinLoopSize,"When you allow any hairpin loop size in the folded structure, a hairpin loop of size 6 appears:"},
			SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->Infinity][FoldedStructures],
			{Structure[{Strand[DNA["CATCTGGTACGACAGAGTATAACTC"]]}, {Bond[{1, 3 ;; 6}, {1, 13 ;; 16}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->Infinity][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->Infinity, Upload->False]
			}
		],

		Example[{Options,MaxHairpinLoopSize,"But by only allowing hairpins where the number of loop bases is 3 or fewer, the above result will be excluded, and hairpin loop of size 3 appears:"},
			SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->3][FoldedStructures],
			{Structure[{Strand[DNA["CATCTGGTACGACAGAGTATAACTC"]]}, {Bond[{1, 15 ;; 18}, {1, 22 ;; 25}]}]},
			Stubs :> {
				SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CATCTGGTACGACAGAGTATAACTC", Method->Thermodynamic, MaxHairpinLoopSize->3, Upload->False]
			}
		],

		Example[{Options,MinHairpinLoopSize,"When you allow any hairpin loop size in the folded structure:"},
			SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->3][FoldedStructures],
			{Structure[{Strand[DNA["TGCATAGCACAGAGCTTGCTTAATT"]]}, {Bond[{1, 2 ;; 4}, {1, 17 ;; 19}], Bond[{1, 6 ;; 8}, {1, 14 ;; 16}]}], Structure[{Strand[DNA["TGCATAGCACAGAGCTTGCTTAATT"]]}, {Bond[{1, 6 ;; 8}, {1, 14 ;; 16}]}], Structure[{Strand[DNA["TGCATAGCACAGAGCTTGCTTAATT"]]}, {Bond[{1, 6 ;; 9}, {1, 17 ;; 20}]}]},
			Stubs :> {
				SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->3, Upload->False]
			}
		],

		Example[{Options,MinHairpinLoopSize,"But by only allowing hairpins that are 6 bases or larger, the above result will be excluded, and a hairpin loop of size 6 appears:"},
			SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->6][FoldedStructures],
			{Structure[{Strand[DNA["TGCATAGCACAGAGCTTGCTTAATT"]]}, {Bond[{1, 6 ;; 9}, {1, 17 ;; 20}]}]},
			Stubs :> {
				SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->6][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["TGCATAGCACAGAGCTTGCTTAATT", Method->Thermodynamic, MinHairpinLoopSize->6, Upload->False]
			}
		],

		Example[{Options,MaxBulgeLoopSize, "When you allow any bulge loop size in the folded structure, a bulge loop of size 5 appears:"},
			SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->Infinity][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 27 ;; 30}], Bond[{1, 10 ;; 16}, {1, 20 ;; 26}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->Infinity][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->Infinity, Upload->False]
			}
		],

		Example[{Options,MaxBulgeLoopSize, "But by only allowing bulges where the bulge is 3 bases or smaller, the above result will be excluded, and the next-most optimal result (a structure with an internal loop) will be returned instead:"},
			SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->3][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG"]]}, {Bond[{1, 2 ;; 4}, {1, 28 ;; 30}], Bond[{1, 10 ;; 16}, {1, 20 ;; 26}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCCCCCAAAGGGGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxBulgeLoopSize->3, Upload->False]
			}
		],

		Example[{Options,MinBulgeLoopSize,"When you allow the lowest minimum bulge loop size, a bulge loop of size 1 appears:"},
			SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->1][FoldedStructures],
			{Structure[{Strand[DNA["CCCCACCCCAAAGGGGGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 17 ;; 20}], Bond[{1, 6 ;; 9}, {1, 13 ;; 16}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->1][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->1, Upload->False]
			}
		],

		Example[{Options,MinBulgeLoopSize,"But by only allowing bulges larger than 1 base (so no single-base bulges allowed), the above result will be excluded and the next-most optimal result (a structure with a single mismatch) will be returned::"},
			SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->2][FoldedStructures],
			{Structure[{Strand[DNA["CCCCACCCCAAAGGGGGGGG"]]}, {Bond[{1, 2 ;; 4}, {1, 18 ;; 20}], Bond[{1, 6 ;; 9}, {1, 13 ;; 16}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->2][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCACCCCAAAGGGGGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinBulgeLoopSize->2, Upload->False]
			}
		],

		Example[{Options,MaxInternalLoopSize, "When you allow any internal loop size in the folded structure, an internal loop of size 8 appears:"},
			SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->Infinity][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->Infinity][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->Infinity, Upload->False]
			}
		],

		Example[{Options,MaxInternalLoopSize, "But by only allow internal loops where the size is 3 bases or smaller, the above result will be excluded, and the next-most optimal result will be returned:"},
			SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->3][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->3, Upload->False]
			}
		],

		Test["Only allow bulges where the bulge is 3 bases or smaller. The optimal result is thus not allowed, and the next-most optimal result (a structure with a bulge-like internal loop) is chosen:",
			Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MaxInternalLoopSize->3, Upload->False],
			{Structure[{Strand[DNA["CCCCAAAAACCCACCCCAAAGGGGAGGGAAAGGGG"]]}, {Bond[{1, 10 ;; 12}, {1, 26 ;; 28}], Bond[{1, 14 ;; 17}, {1, 21 ;; 24}]}]},
			TimeConstraint->200
		],

		Example[{Options,MinInternalLoopSize,"When you allow the lowest minimum internal loop size, an internal loop of size 2 appears:"},
			SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->2][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 14}, {1, 24 ;; 28}], Bond[{1, 16 ;; 17}, {1, 21 ;; 22}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->2][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->2, Upload->False]
			}
		],

		Example[{Options,MinInternalLoopSize,"But by only allowing internal loops of size 4 or greater. The smaller internal loop gets absorbed into the hairpin while the bigger internal loop stays:"},
			SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->4][FoldedStructures],
			{Structure[{Strand[DNA["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG"]]}, {Bond[{1, 1 ;; 4}, {1, 32 ;; 35}], Bond[{1, 10 ;; 14}, {1, 24 ;; 28}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->4][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCCAAAAACCCCCACCAAAGGAGGGGGAAAGGGG", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinInternalLoopSize->4, Upload->False]
			}
		],

		Example[{Options,MinMultipleLoopSize,"When you allow all multiple loops:"},
			SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->0][FoldedStructures],
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1 ;; 3}, {1, 22 ;; 24}], Bond[{1, 4 ;; 6}, {1, 10 ;; 12}], Bond[{1, 13 ;; 15}, {1, 19 ;; 21}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->0][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->0, Upload->False]
			}
		],

		Example[{Options,MinMultipleLoopSize,"But by only allowing multiple loops with at least one free base between each 'branch', the next most optimal structure satisfying this condition does not have a multiple loop:"},
			SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->1][FoldedStructures],
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1 ;; 6}, {1, 19 ;; 24}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->1][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->1, Upload->False]
			}
		],

		Test["But by only allowing multiple loops with at least one free base between each 'branch', the next most optimal structure satisfying this condition does not have a multiple loop:",
			Append[FoldedStructures] /. SimulateFolding["AAACCCAAAGGGCCCAAAGGGUUU", Method->Thermodynamic, SubOptimalStructureTolerance->0, MinMultipleLoopSize->1, Upload->False],
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1 ;; 6}, {1, 19 ;; 24}]}]},
			TimeConstraint->200
		],

		Example[{Options,Method,"Thermodynamic method uses planar folding algorithm which misses pseudoknots:"},
			SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Thermodynamic][FoldedStructures],
			{Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 10}, {1, 28 ;; 29}], Bond[{1, 13 ;; 16}, {1, 23 ;; 26}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Thermodynamic][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Thermodynamic, Upload->False]
			}
		],

		Test["Thermodynamic method uses planar folding algorithm which misses pseudoknots:",
			Append[FoldedStructures] /. SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Thermodynamic, Upload->False],
			{Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 10}, {1, 28 ;; 29}], Bond[{1, 13 ;; 16}, {1, 23 ;; 26}]}]},
			TimeConstraint->200
		],

		Example[{Options,Method, "Kinetic method can return structures with pseudoknots which cannot be found by Thermodynamic method:"},
			SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Kinetic][FoldedStructures],
			{Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 13 ;; 16}, {1, 23 ;; 26}]}], Structure[{Strand[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"]]}, {Bond[{1, 2 ;; 4}, {1, 25 ;; 27}], Bond[{1, 9 ;; 11}, {1, 33 ;; 35}], Bond[{1, 14 ;; 16}, {1, 30 ;; 32}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Kinetic][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding[RNA["UCCAAUGGCGGGCAGUGUGACGACUGGCGACUCCG"], Method->Kinetic, Upload->False]
			}
		],

		Example[{Options,Heuristic,"By default, thermodynamic folding attempts to optimize the energy of the folded structure (i.e. best structure has lowest Gibbs Free Energy):"},
			SimulateFolding["CCCUUGGGGAUGCCCACCUUGGG", Method->Thermodynamic, Heuristic->Energy][FoldedStructures],
			{Structure[{Strand[RNA["CCCUUGGGGAUGCCCACCUUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 7 ;; 9}], Bond[{1, 13 ;; 16}, {1, 20 ;; 23}]}], Structure[{Strand[RNA["CCCUUGGGGAUGCCCACCUUGGG"]]}, {Bond[{1, 13 ;; 16}, {1, 20 ;; 23}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUUGGGGAUGCCCACCUUGGG", Method->Thermodynamic, Heuristic->Energy][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUUGGGGAUGCCCACCUUGGG", Method->Thermodynamic, Heuristic->Energy, Upload->False]
			}
		],

		(*Example[{Options,Heuristic,"Using the Heuristic option, you can make thermodynamic folding optimize the bond-count of the folded structure (i.e. best structure has most bonds):"},
			SimulateFolding["AAGAUGGAAAGGUCUAGCCA", Method->Thermodynamic, Heuristic->Bonds],
			{Structure[{Strand[RNA["AAGAUGGAAAGGUCUAGCCA"]]}, {Bond[{1, 5 ;; 7}, {1, 18 ;; 20}], Bond[{1, 8 ;; 8}, {1, 15 ;; 15}], Bond[{1, 9 ;; 9}, {1, 13 ;; 13}]}], Structure[{Strand[RNA["AAGAUGGAAAGGUCUAGCCA"]]}, {Bond[{1, 6 ;; 7}, {1, 18 ;; 19}], Bond[{1, 8 ;; 8}, {1, 15 ;; 15}], Bond[{1, 9 ;; 9}, {1, 13 ;; 13}]}], Structure[{Strand[RNA["AAGAUGGAAAGGUCUAGCCA"]]}, {Bond[{1, 7 ;; 7}, {1, 18 ;; 18}], Bond[{1, 8 ;; 8}, {1, 15 ;; 15}], Bond[{1, 9 ;; 9}, {1, 13 ;; 13}]}], Structure[{Strand[RNA["AAGAUGGAAAGGUCUAGCCA"]]}, {Bond[{1, 8 ;; 8}, {1, 15 ;; 15}], Bond[{1, 9 ;; 9}, {1, 13 ;; 13}]}], Structure[{Strand[RNA["AAGAUGGAAAGGUCUAGCCA"]]}, {Bond[{1, 4 ;; 4}, {1, 13 ;; 13}], Bond[{1, 5 ;; 5}, {1, 9 ;; 9}]}]},
			Stubs :> {
				SimulateFolding["AAGAUGGAAAGGUCUAGCCA", Method->Thermodynamic, Heuristic->Bonds] =
				Append[FoldedStructures] /. SimulateFolding["AAGAUGGAAAGGUCUAGCCA", Method->Thermodynamic, Heuristic->Bonds, Upload->False]
			}
		],*)

		Test["Using the Heuristic option, you can make thermodynamic folding optimize the bond-count of the folded structure (i.e. best structure has most bonds):",
			SimulateFolding["CCCUUGGGGAUGCCCACCUUGGG", Method->Thermodynamic, Heuristic->Bonds, Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Folding], {}, ResolvedOptions -> {Method->Thermodynamic, Heuristic->Bonds, Polymer->RNA, Temperature->Quantity[37,"DegreesCelsius"], FoldingInterval->All, Depth->Infinity, Breadth->20, Consolidate->True, SubOptimalStructureTolerance->Quantity[25,"Percent"], MaxMismatch->0, MinPieceSize->1, MinLevel->3, ExcludedSubstructures->{}, MinHairpinLoopSize->3, MaxHairpinLoopSize->Infinity, MinInternalLoopSize->2, MaxInternalLoopSize->Infinity, MinBulgeLoopSize->1, MaxBulgeLoopSize->Infinity, MinMultipleLoopSize->0, Template->Null, Output->Result, Upload->False}],
			TimeConstraint->200
		],

		Example[{Options,SubOptimalStructureTolerance,"SubOptimalStructureTolerance is usally set to 25\%. Here, we use an energy value as tolerance:"},
			SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0.5 Kilo Calorie/Mole][FoldedStructures],
			{Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 17 ;; 20}, {1, 26 ;; 29}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0.5 Kilo Calorie/Mole][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0.5 Kilo Calorie/Mole, Upload->False]
			}
		],

		Example[{Options,SubOptimalStructureTolerance,"When you allow 0 tolerance (only the optimal structure is returned):"},
			SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0][FoldedStructures],
			{Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 17 ;; 20}, {1, 26 ;; 29}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic,SubOptimalStructureTolerance->0, Upload->False]
			}
		],

		Example[{Options,SubOptimalStructureTolerance,"You can use a bond-count tolerance to return all structures within a certain number of the optimal folded structure's bond count:"},
			SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->3][FoldedStructures],
			{Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 17 ;; 20}, {1, 26 ;; 29}]}], Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 17 ;; 20}, {1, 26 ;; 29}]}], Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 18 ;; 20}, {1, 26 ;; 28}]}], Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 5 ;; 6}, {1, 22 ;; 23}], Bond[{1, 9 ;; 10}, {1, 19 ;; 20}], Bond[{1, 12 ;; 12}, {1, 17 ;; 17}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->3][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->3, Upload->False]
			}
		],

		Example[{Options,SubOptimalStructureTolerance,"Use a percentage tolerance:"},
			SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->30 Percent][FoldedStructures],
			{Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 17 ;; 20}, {1, 26 ;; 29}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->30 Percent][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->30 Percent, Upload->False]
			}
		],

		Test["Use a percentage tolerance:",
			Append[FoldedStructures] /. SimulateFolding["CCCUUGGAUGGGGGUGCCCACCACCUGGG", Method->Thermodynamic, SubOptimalStructureTolerance->40 Percent, Upload->False],
			{Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, Span[1, 3]}, {1, Span[10, 12]}], Bond[{1,Span[17,20]}, {1, Span[26, 29]}]}], Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]}, {Bond[{1, Span[17, 20]}, {1, Span[26, 29]}]}]},
			TimeConstraint->200
		],

		Example[{Options,ExcludedSubstructures,"When you exclude no substructures (all are allowed):"},
			SimulateFolding["CCCUGGUGCCCACCAGCGCGCGCCUGGG", Method->Thermodynamic, ExcludedSubstructures->{}][FoldedStructures],
			{Structure[{Strand[RNA["CCCUGGUGCCCACCAGCGCGCGCCUGGG"]]}, {Bond[{1, 9 ;; 12}, {1, 25 ;; 28}], Bond[{1, 16 ;; 17}, {1, 22 ;; 23}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUGGUGCCCACCAGCGCGCGCCUGGG", Method->Thermodynamic, ExcludedSubstructures->{}][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUGGUGCCCACCAGCGCGCGCCUGGG", Method->Thermodynamic, ExcludedSubstructures->{}, Upload->False]
			}
		],

		Example[{Options,ExcludedSubstructures,"By excluding internal loops (this includes mismatches), we get the most optimal structure that does not have internal loops:"},
			SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->InternalLoop][FoldedStructures],
			{Structure[{Strand[RNA["CCCUGGUGCCCACCACCUGGG"]]}, {Bond[{1, 9 ;; 12}, {1, 18 ;; 21}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->InternalLoop][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->InternalLoop, Upload->False]
			}
		],

		(** TODO: A better model example should be formed. **)
		Example[{Options,ThermodynamicsModel,"Using ThermodynamicsModel to explicitly provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			{
				SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->InternalLoop, ThermodynamicsModel->Model[Physics,Thermodynamics,"RNA"]][FoldedStructures],
				SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->InternalLoop, ThermodynamicsModel->Model[Physics,Thermodynamics,"DNA"]][FoldedStructures]
			},
			{
				{Structure[{Strand[RNA["CCCUGGUGCCCACCACCUGGG"]]}, {Bond[{1, 9;;12}, {1, 18 ;; 21}]}]},
				{Structure[{Strand[RNA["CCCUGGUGCCCACCACCUGGG"]]}, {Bond[{1, 5;;8}, {1, 14;;17}]}]}
			},
			TimeConstraint->200
		],

		Example[{Options,AlternativeParameterization,"Using AlternativeParameterization to provide the thermodynamic parameters or to override the values taken from Thermodynamics field in the model oligomer:"},
			SimulateFolding["+A*fA*+A+C*+C*+C*+C*mU*mU*mU*+C*+C*+C*fAmAfA*+C*+C*+C*mU*mU*mU*", AlternativeParameterization -> True, Upload -> False][Append@FoldedStructures],
			{Structure[{Strand[LNAChimera["+A*fA*+A+C*+C*+C*+C*mU*mU*mU*+C*+C*+C*fAmAfA*+C*+C*+C*mU*mU*mU*"]]}, {Bond[{1, 1 ;; 3}, {1, 20 ;; 22}], Bond[{1, 8 ;; 10}, {1, 14 ;; 16}]}],
 			Structure[{Strand[LNAChimera["+A*fA*+A+C*+C*+C*+C*mU*mU*mU*+C*+C*+C*fAmAfA*+C*+C*+C*mU*mU*mU*"]]}, {Bond[{1, 1 ;; 3}, {1, 8 ;; 10}], Bond[{1, 14 ;; 16}, {1, 20 ;; 22}]}]},
			TimeConstraint->200
		],

		Example[{Options,ExcludedSubstructures,"By excluding bulge loops and internal loops, we get the new most optimal structure (no bulge/internal loops) and a structure whose energy is within 25% of the optimal structure's energy:"},
			SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->{BulgeLoop, InternalLoop}][FoldedStructures],
			{Structure[{Strand[RNA["CCCUGGUGCCCACCACCUGGG"]]}, {Bond[{1, 9 ;; 12}, {1, 18 ;; 21}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->{BulgeLoop, InternalLoop}][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->{BulgeLoop, InternalLoop}, Upload->False]
			}
		],

		Test["Exclude bulge loops and internal loops. We get the new most optimal structure (no bulge/internal loops) and a structure whose energy is within 25% of the optimal structure's energy:",
			Append[FoldedStructures] /. SimulateFolding["CCCUGGUGCCCACCACCUGGG", Method->Thermodynamic, ExcludedSubstructures->{BulgeLoop, InternalLoop}, Upload->False],
			{Structure[{Strand[RNA["CCCUGGUGCCCACCACCUGGG"]]}, {Bond[{1, 9 ;; 12}, {1, 18 ;; 21}]}]},
			TimeConstraint->200
		],

		Example[{Overloads,Maps,"Maps over input:"},
			SimulateFolding[{"ACGTACGTACGT", Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]}],
			{{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}]}]}, {Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 6 ;; 8}, {1, 13 ;; 15}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]}},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding[{"ACGTACGTACGT", Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]}] =
				Append[FoldedStructures] /. SimulateFolding[{"ACGTACGTACGT", Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]}, Upload->False]
			}
		],

		Test["Maps over input:",
			Append[FoldedStructures] /. SimulateFolding[{"ACGTACGTACGT", Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]},{}]}, Upload->False],
			{{Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}]}]}, {Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 6 ;; 8}, {1, 13 ;; 15}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 11 ;; 13}]}]}},
			TimeConstraint->200
		],

		Test["Insert new object:",
			SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Upload->True],
			ObjectReferenceP[Object[Simulation, Folding]],
			TimeConstraint->120,
			Stubs :> {Print[_] := Null}
		],

		(* ------ Messages ------ *)

		Example[{Messages, "InvalidThermodynamicsModel", "The option ThermodynamicsModel does not match the correct pattern:"},
		 SimulateFolding["AC", ThermodynamicsModel -> Null],
		 $Failed,
		 TimeConstraint->200,
		 Messages :> {Error::InvalidThermodynamicsModel, Error::InvalidOption}],

		Example[{Messages, "AlternativeParameterizationNotAvailable", "The AlternativeParameterization for the oligomer does not exist:"},
		 SimulateFolding["ACGTACGTACGT", AlternativeParameterization -> True][FoldedStructures],
		 {Structure[{Strand[DNA["ACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
		 TimeConstraint->200,
		 Messages :> {Warning::AlternativeParameterizationNotAvailable}],

		Example[{Messages,"InvalidSequence","Invalid sequence will fail:"},
			SimulateFolding["ABCDEFG"],
			$Failed,
			Messages:>{ToStrand::InvalidSequence}
		],

		Example[{Messages,"InvalidStrand","Invalid strand will fail:"},
			SimulateFolding[Strand[DNA["ABCDEFG"]]],
			$Failed,
			Messages:>{ToStructure::InvalidStrand}
		],

		Example[{Messages,"InvalidStructure","Invalid structure will fail:"},
			SimulateFolding[Structure[{Strand[DNA["ABCDEFG"]]},{}]],
			$Failed,
			Messages:>{ToStructure::InvalidStructure}
		],

		Example[{Messages,"UnboundStructure","Structure with unbounded strand will not be folded:"},
			SimulateFolding[Structure[{Strand[DNA["TTTTT"]],Strand[DNA["AAAAA"]]},{}]],
			$Failed,
			Messages:>{Error::UnboundStructure,Error::InvalidInput}
		],

		Example[{Messages,"MixPolymerType","Mix polymer type is currently unsupported:"},
			SimulateFolding[Strand[DNA["CCCCCCCCCCCCCCCC"],RNA["GGGGGGGGGGGG"]]],
			$Failed,
			Messages:>{Error::MixPolymerType,Error::InvalidInput}
		],

		Example[{Issues, "Folded structures are displayed using graph plotting algorithms, so occasionally the display structures can appear jumbled or overlapping:"},
			SimulateFolding["CTCAAGGCATAGTGTGACGTTCGTGCACCG"][FoldedStructures],
			{Structure[{Strand[DNA["CTCAAGGCATAGTGTGACGTTCGTGCACCG"]]}, {Bond[{1, 14 ;; 16}, {1, 26 ;; 28}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGTGACGTTCGTGCACCG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 12 ;; 14}, {1, 26 ;; 28}]}], Structure[{Strand[DNA["CTCAAGGCATAGTGTGACGTTCGTGCACCG"]]}, {Bond[{1, 2 ;; 4}, {1, 15 ;; 17}], Bond[{1, 7 ;; 9}, {1, 24 ;; 26}]}]},
			TimeConstraint->200,
			Stubs :> {
				SimulateFolding["CTCAAGGCATAGTGTGACGTTCGTGCACCG"][FoldedStructures] =
				Append[FoldedStructures] /. SimulateFolding["CTCAAGGCATAGTGTGACGTTCGTGCACCG", Upload->False]
			}
		],

		Test["UnresolvedOptions field populated correctly:",
			SimulateFolding[Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]], Horse->True, MinLevel->"string", Breadth->5],
			$Failed,
			Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern},
			TimeConstraint->120
		],

		Test["Sequence interval 1:",
			Append[FoldedStructures] /. SimulateFolding["ACGTAGCTAGCTAGCGCATCG", FoldingInterval->{1,4}, Polymer->DNA, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 8}, {1, 9 ;; 13}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG"]]}, {Bond[{1, 4 ;; 6}, {1, 7 ;; 9}]}]},
			TimeConstraint->200
		],

		Test["Sequence interval 2:",
			Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGTACGTACGT", MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 5 ;; 12}, {1, 13 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}], Bond[{1, 13 ;; 16}, {1, 17 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 14}, {1, 15 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 5 ;; 8}, {1, 9 ;; 12}], Bond[{1, 13 ;; 16}, {1, 17 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 13 ;; 16}, {1, 17 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}]}]},
			TimeConstraint->200
		],

		Test["Sequence interval 3:",
			Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGTACGTACGT", FoldingInterval->{1,4}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Sequence interval 4:",
			Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGTACGTACGT", FoldingInterval->{3,3}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Sequence interval 5:",
			Append[FoldedStructures] /. SimulateFolding["ACGTACGTACGTACGTACGT", FoldingInterval->{9,10}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 5 ;; 12}, {1, 13 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 9 ;; 14}, {1, 15 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Strand 1:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"]], MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]}
		],

		Test["Strand 2:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"]], MinLevel->5, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Strand 3:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"]], MinLevel->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 6}, {1, 7 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Strand 4:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"]], Consolidate->False, MinHairpinLoopSize->3, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Strand 5:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"]], MinLevel->2, Depth->{2}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 6}, {1, 7 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 6}, {1, 7 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Strand 6:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ATCGATTCTGATCG","X"]], MaxMismatch->1, MinPieceSize->1, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}], Bond[{1, 8 ;; 8}, {1, 10 ;; 10}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 5}, {1, 12 ;; 14}], Bond[{1, 7 ;; 8}, {1, 10 ;; 11}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 5}, {1, 7 ;; 8}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 5 ;; 5}, {1, 9 ;; 9}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 1}, {1, 7 ;; 7}], Bond[{1, 2 ;; 3}, {1, 4 ;; 5}], Bond[{1, 8 ;; 8}, {1, 14 ;; 14}], Bond[{1, 10 ;; 11}, {1, 12 ;; 13}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 4 ;; 6}], Bond[{1, 8 ;; 8}, {1, 14 ;; 14}], Bond[{1, 10 ;; 11}, {1, 12 ;; 13}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 1}, {1, 7 ;; 7}], Bond[{1, 2 ;; 3}, {1, 4 ;; 5}], Bond[{1, 6 ;; 6}, {1, 11 ;; 11}], Bond[{1, 8 ;; 8}, {1, 10 ;; 10}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 4}, {1, 8 ;; 8}], Bond[{1, 5 ;; 5}, {1, 6 ;; 6}]}]},
			TimeConstraint->200
		],

		Test["Strand 7:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ATCGATTCTGATCG","X"]], MaxMismatch->1, MinPieceSize->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 5}, {1, 12 ;; 14}], Bond[{1, 7 ;; 8}, {1, 10 ;; 11}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 5}, {1, 7 ;; 8}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 4 ;; 6}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 1:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTAGCTAGCTAGCGCATCG","X"]], FoldingInterval->{1,4}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG", "X"]]}, {Bond[{1, 4 ;; 8}, {1, 9 ;; 13}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG", "X"]]}, {Bond[{1, 4 ;; 6}, {1, 7 ;; 9}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 2:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGTACGTACGT","X"]], FoldingInterval->{1,4}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 3:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGTACGTACGT","X"]], FoldingInterval->{3,3}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 4:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGTACGTACGT","X"]], FoldingInterval->{9,10}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 12}, {1, 13 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 9 ;; 14}, {1, 15 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 5:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]], MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 5 ;; 10}, {1, 11 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}]}]},
			TimeConstraint->200
		],

		Test["Strand interval 6:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]], FoldingInterval->{1,4}, MinLevel->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 18 ;; 19}], Bond[{1, 3 ;; 8}, {1, 9 ;; 14}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 18 ;; 19}], Bond[{1, 3 ;; 6}, {1, 7 ;; 10}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 18 ;; 19}], Bond[{1, 3 ;; 4}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 18 ;; 19}], Bond[{1, 3 ;; 4}, {1, 5 ;; 6}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 15 ;; 16}], Bond[{1, 3 ;; 4}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 11 ;; 12}], Bond[{1, 3 ;; 4}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 7 ;; 8}], Bond[{1, 3 ;; 4}, {1, 21 ;; 22}]}]},
			TimeConstraint->120
		],

		Test["Strand interval 7:",
			Append[FoldedStructures] /. SimulateFolding[Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]], FoldingInterval->{2,{1,4}}, MinLevel->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 5 ;; 10}, {1, 11 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 9 ;; 12}, {1, 13 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 13 ;; 14}, {1, 15 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 3 ;; 8}, {1, 9 ;; 14}], Bond[{1, 15 ;; 16}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 7 ;; 10}, {1, 11 ;; 14}], Bond[{1, 15 ;; 16}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 13 ;; 14}, {1, 18 ;; 19}], Bond[{1, 15 ;; 16}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 11 ;; 12}, {1, 13 ;; 14}], Bond[{1, 15 ;; 16}, {1, 21 ;; 22}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 9 ;; 10}, {1, 15 ;; 16}], Bond[{1, 13 ;; 14}, {1, 18 ;; 19}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 5 ;; 6}, {1, 15 ;; 16}], Bond[{1, 13 ;; 14}, {1, 18 ;; 19}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 2}, {1, 15 ;; 16}], Bond[{1, 13 ;; 14}, {1, 18 ;; 19}]}]},
			TimeConstraint->200
		],

		Test["Structure 1:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"]]},{}], MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Structure 2:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"]]},{}], MinLevel->5, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Structure 3:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"]]},{}], MinLevel->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 6}, {1, 7 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Structure 4:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"]]},{}], Consolidate->False, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 2 ;; 6}, {1, 7 ;; 11}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 5}, {1, 8 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 7 ;; 10}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 2 ;; 5}, {1, 8 ;; 11}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 6 ;; 8}, {1, 9 ;; 11}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 7}, {1, 10 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 3 ;; 5}, {1, 8 ;; 10}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 2 ;; 4}, {1, 5 ;; 7}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 6 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Structure 5:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"]]},{}], MinLevel->2, Depth->{2}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 6}, {1, 7 ;; 8}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 9 ;; 10}, {1, 11 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 2}, {1, 3 ;; 4}], Bond[{1, 5 ;; 6}, {1, 7 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Structure 6:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ATCGATTCTGATCG","X"]]},{}], MaxMismatch->1, MinPieceSize->1, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}], Bond[{1, 8 ;; 8}, {1, 10 ;; 10}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 5}, {1, 12 ;; 14}], Bond[{1, 7 ;; 8}, {1, 10 ;; 11}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 5}, {1, 7 ;; 8}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 5 ;; 5}, {1, 9 ;; 9}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 1}, {1, 7 ;; 7}], Bond[{1, 2 ;; 3}, {1, 4 ;; 5}], Bond[{1, 8 ;; 8}, {1, 14 ;; 14}], Bond[{1, 10 ;; 11}, {1, 12 ;; 13}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 4 ;; 6}], Bond[{1, 8 ;; 8}, {1, 14 ;; 14}], Bond[{1, 10 ;; 11}, {1, 12 ;; 13}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 1}, {1, 7 ;; 7}], Bond[{1, 2 ;; 3}, {1, 4 ;; 5}], Bond[{1, 6 ;; 6}, {1, 11 ;; 11}], Bond[{1, 8 ;; 8}, {1, 10 ;; 10}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 4}, {1, 8 ;; 8}], Bond[{1, 5 ;; 5}, {1, 6 ;; 6}]}]},
			TimeConstraint->200
		],

		Test["Structure 7:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ATCGATTCTGATCG","X"]]},{}], MaxMismatch->1, MinPieceSize->2, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 5}, {1, 12 ;; 14}], Bond[{1, 7 ;; 8}, {1, 10 ;; 11}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}], Bond[{1, 4 ;; 5}, {1, 7 ;; 8}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 3 ;; 6}, {1, 11 ;; 14}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 10 ;; 12}]}], Structure[{Strand[DNA["ATCGATTCTGATCG", "X"]]}, {Bond[{1, 1 ;; 3}, {1, 4 ;; 6}]}]},
			TimeConstraint->200
		],

		Test["Structure 8:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG","X"]]},{}], FoldingInterval->{1,{1,4}}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG", "X"]]}, {Bond[{1, 4 ;; 8}, {1, 9 ;; 13}]}], Structure[{Strand[DNA["ACGTAGCTAGCTAGCGCATCG", "X"]]}, {Bond[{1, 4 ;; 6}, {1, 7 ;; 9}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 1:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGTACGTACGT","X"]]},{}], FoldingInterval->{1,{1,4}}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 2:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGTACGTACGT","X"]]},{}], FoldingInterval->{1,{3,3}}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 3:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGTACGTACGT","X"]]},{}], FoldingInterval->{1,{9,10}}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 10}, {1, 11 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 5 ;; 12}, {1, 13 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 9 ;; 14}, {1, 15 ;; 20}]}], Structure[{Strand[DNA["ACGTACGTACGTACGTACGT", "X"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 4:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]]},{}], MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 8}, {1, 9 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 5 ;; 10}, {1, 11 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 6}, {1, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 1 ;; 4}, {1, 5 ;; 8}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 5:",
			SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]],Strand[DNA["ACGTACGTACGT","V"],DNA["ACGTTGTCAC","W"]]},{}], MinHairpinLoopSize->0, Upload->False],
			$Failed,
			Messages:>{Error::UnboundStructure,Error::InvalidInput}
		],

		Test["Structure interval 6:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]],Strand[DNA["ACGTACGTACGT","V"],DNA["ACGTTGTCAC","W"]]},{Bond[{1,2,1;;3},{2,1,2;;4}]}], MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 16}, {2, 1 ;; 15}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 12}, {2, 1 ;; 8}], Bond[{1, 13 ;; 16}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 10}, {1, 11 ;; 16}], Bond[{2, 1 ;; 6}, {2, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {2, 1 ;; 4}], Bond[{1, 9 ;; 16}, {2, 5 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}], Bond[{2, 1 ;; 6}, {2, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 10}, {1, 11 ;; 16}], Bond[{2, 5 ;; 8}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 10}, {1, 11 ;; 16}], Bond[{2, 1 ;; 4}, {2, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}], Bond[{2, 1 ;; 6}, {2, 7 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 8}, {2, 9 ;; 15}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}], Bond[{2, 1 ;; 4}, {2, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {2, 5 ;; 8}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}], Bond[{2, 1 ;; 4}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {2, 1 ;; 4}], Bond[{1, 9 ;; 12}, {2, 5 ;; 8}], Bond[{1, 13 ;; 16}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {2, 1 ;; 4}], Bond[{1, 9 ;; 12}, {1, 13 ;; 16}], Bond[{2, 5 ;; 8}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 9 ;; 12}, {2, 9 ;; 12}], Bond[{1, 5 ;; 8}, {1, 13 ;; 16}], Bond[{2, 1 ;; 4}, {2, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 9 ;; 12}, {2, 1 ;; 4}], Bond[{1, 5 ;; 8}, {1, 13 ;; 16}], Bond[{2, 5 ;; 8}, {2, 9 ;; 12}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 13 ;; 16}, {2, 9 ;; 12}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}], Bond[{2, 1 ;; 4}, {2, 5 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 13 ;; 16}, {2, 1 ;; 4}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}], Bond[{2, 5 ;; 8}, {2, 9 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Structure interval 7:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]],Strand[DNA["ACGTACGTACGT","V"],DNA["ACGTTGTCAC","W"]]},{Bond[{1,2,1;;3},{2,1,2;;4}]}], FoldingInterval->{1,{1,3}}, MinHairpinLoopSize->0, Upload->False],
			{}
		],

		Test["Structure interval 8:",
			Append[FoldedStructures] /. SimulateFolding[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACGTTGTCAC"]],Strand[DNA["ACGTACGTACGT","V"],DNA["ACGTTGTCAC","W"]]},{Bond[{1,2,1;;3},{2,1,2;;4}]}], FoldingInterval->{1,{4,6}}, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 16}, {2, 1 ;; 15}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 12}, {2, 1 ;; 8}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 10}, {1, 11 ;; 16}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {2, 1 ;; 4}]}], Structure[{Strand[DNA["ACGTACGTACGT", "V"], DNA["ACGTTGTCAC", "W"]], Strand[DNA["ACGTACGTACGT", "X"], DNA["ACGTTGTCAC"]]}, {Bond[{1, 2 ;; 4}, {2, 13 ;; 15}], Bond[{1, 5 ;; 8}, {1, 9 ;; 12}]}]},
			TimeConstraint->200
		],

		Test["Other:",
			Append[FoldedStructures] /. SimulateFolding[Strand[Modification["Fluorescein"],DNA["TGATCGGTGCTGTTCCCGATCA"],Modification["Bhqtwo"]], Depth->Infinity, MinHairpinLoopSize->0, Upload->False],
			{Structure[{Strand[Modification["Fluorescein"], DNA["TGATCGGTGCTGTTCCCGATCA"], Modification["Bhqtwo"]]}, {Bond[{1, 2 ;; 8}, {1, 17 ;; 23}]}]},
			TimeConstraint->200
		],


	(* ADDITIONAL TESTS *)
		Test["No bonds created here because strands aren't connected:",
			SimulateFolding[Structure[{Strand[DNA["TTT"],DNA["CCC"]],Strand[DNA["GGG"],DNA["AAA"]]},{}]],
			$Failed,
			Messages:>{Error::UnboundStructure,Error::InvalidInput}
		],

		Test["Fold another sequence:",
			Append[FoldedStructures] /. SimulateFolding["AAATTTCCCAAATTT", Upload->False],
			{Structure[{Strand[DNA["AAATTTCCCAAATTT"]]}, {Bond[{1, 1 ;; 6}, {1, 10 ;; 15}]}]},
			TimeConstraint->200
		],

		Test["Illegal non-physical structures get filtered out and throws no messages:",
			SimulateFolding[Strand[DNA["CTGCCGGACTTTCCGTCTAAGTAGAACTAGACTTCTA"]],Upload->False],
			Simulation`Private`validSimulationPacketP[Object[Simulation, Folding], {}]
		],

		Test["Handles modification in middle of a loop without errors:",
			SimulateFolding[Structure[{Strand[DNA["AAAAAT"],  Modification["Tamra"], 	DNA["TTTTT"]]}, {}], Upload -> False],
			_Association
		]


	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{

		$CreatedObjects={};

		(** NOTE: The parameters that are not available will be set to zero **)
		stackingEnergy={{DNA["GC"],DNA["GC"],-2.24` KilocaloriePerMole}};
		stackingEnthalpy={{DNA["GC"],DNA["GC"],-9.8` KilocaloriePerMole}};
		stackingEntropy={{DNA["GC"],DNA["GC"],-24.4` CaloriePerMoleKelvin}};
		stackingEnergyRNA={{DNA["GC"],DNA["GC"],-2.7` KilocaloriePerMole}};
		stackingEnthalpyRNA={{DNA["GC"],DNA["GC"],-8.` KilocaloriePerMole}};
		stackingEntropyRNA={{DNA["GC"],DNA["GC"],-17.1` CaloriePerMoleKelvin}};

	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Stubs:>{
		getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
			invisibleTestNotebook=CreateNotebook[Visible->False],
			invisibleTestNotebook
		],
		Print[___]:=Null,
		NotebookWrite[___]:=Null
	}

];


(* ::Section:: *)
(*End Test Package*)
