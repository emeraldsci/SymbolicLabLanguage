(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Structure: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Structure*)


(* ::Subsubsection::Closed:: *)
(*Structure*)


DefineTests[Structure,{
	Example[{Basic,"A structure with one strand and no bonds:"},
		Structure[{Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]},{}],
		StructureP
	],
	Example[{Basic,"A structure with bonds between motifs:"},
		Structure[{Strand[DNA[15,"A"],DNA["ATATAGCATAG","B"],DNA[15,"C"],Modification["Fluorescein"]],Strand[DNA[15,"C'"],RNA["AUAUAGCAUAG","D"],DNA[15,"A'"],RNA[7,"E"]]},{Bond[{1,1},{2,3}],Bond[{1,3},{2,1}]}],
		StructureP
	],
	Example[{Basic,"A structure with bonds between bases:"},
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},
			{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],
		StructureP
	],

	Example[{Additional,"Properties","See the list of properties that can be dereferenced from a structure:"},
		Keys[Structure[{Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]},{}]],
		{_Symbol..}
	],
	Example[{Additional,"Properties","Extract the list of strands:"},
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},
			{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}][Strands],
		{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]}
	],
	Example[{Additional,"Properties","Extract the list of bonds:"},
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},
			{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}][Bonds],
		{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}
	],



	Example[{Additional,"Given strand list, format it properly:"},
		Structure[{Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]}],
		Structure[{Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]},{}]
	],
	Example[{Additional,"Given single strand, format it properly:"},
		Structure[Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]],
		Structure[{Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]},{}]
	],
	Example[{Additional,"Given list of sequences, format properly:"},
		Structure[{"ATCG",Strand[DNA["ATCG","X"],RNA["AUUU","Y"],Modification["Fluorescein"]]}],
		Structure[{Strand[DNA["ATCG"]], Strand[DNA["ATCG", "X"], RNA["AUUU", "Y"], Modification["Fluorescein"]]}, {}]
	],
	Example[{Additional,"Given single sequence, format properly:"},
		Structure["ATCG"],
		Structure[{Strand[DNA["ATCG"]]},{}]
	],

	Example[{Additional,"Given mixed list of sequences and strands, format properly:"},
		Structure[{"ATCG","UUU"}],
		Structure[{Strand[DNA["ATCG"]],Strand[RNA["UUU"]]},{}]
	],

	Example[{Additional,"MotifForm representation of a strand:"},
		MotifForm[Structure[{Strand[DNA[15,"A"],DNA["ATATAGCATAG","B"],DNA[15,"C"],Modification["Fluorescein"]],Strand[DNA[15,"C"],RNA["AUAUAGCAUAG","D"],DNA[15,"A'"],RNA[7,"E"]]},{Bond[{1,1},{2,3}],Bond[{1,3},{2,1}]}]],
		_Interpretation
	]


}];


(* ::Subsection:: *)
(*Structure*)


(* ::Subsubsection::Closed:: *)
(*toMotifBasePairBonds*)


DefineTests[toMotifBasePairBonds,{
	Test["No bond list present:",
		toMotifBasePairBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]}]],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]}]
	],
	Test["",
		toMotifBasePairBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}]],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}]
	],
	Test["Original bond spans two motifs on top and one on bottom; result has two separate bonds:",
		toMotifBasePairBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["CCCC"],DNA["TTTT"]]},{Bond[{1,1;;4},{1,9;;12}]}]],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["CCCC"],DNA["TTTT"]]},{Bond[{1,1,1;;2},{1,4,3;;4}],Bond[{1,2,1;;2},{1,4,1;;2}]}]
	],
	Test["Original bond spans three motifs on top and two on bottom; result has four separate bonds:",
		toMotifBasePairBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;5},{1,10;;13}]}]],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,1,2;;2},{1,6,2;;2}],Bond[{1,2,1;;1},{1,6,1;;1}],Bond[{1,2,2;;2},{1,5,2;;2}],Bond[{1,3,1;;1},{1,5,1;;1}]}]
	]

}];



(* ::Subsubsection::Closed:: *)
(*ToStrandBasePairBonds*)


DefineTests[toStrandBasePairBonds,{
	Test["",
		toStrandBasePairBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}]],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}]
	],
	Test["Split a bunch of bonds without consolidating result:",
		toStrandBasePairBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,1,2;;2},{1,6,2;;2}],Bond[{1,2,1;;1},{1,6,1;;1}],Bond[{1,2,2;;2},{1,5,2;;2}],Bond[{1,3,1;;1},{1,5,1;;1}]}]],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;2},{1,13;;13}],Bond[{1,3;;3},{1,12;;12}],Bond[{1,4;;4},{1,11;;11}],Bond[{1,5;;5},{1,10;;10}]}]
	]


}];



(* ::Subsubsection::Closed:: *)
(*alignStrandBaseBonds*)


DefineTests[alignStrandBaseBonds,{

	Test["",
		alignStrandBaseBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;5},{1,10;;13}]}]],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;2},{1,13;;13}],Bond[{1,3;;3},{1,12;;12}],Bond[{1,4;;4},{1,11;;11}],Bond[{1,5;;5},{1,10;;10}]}]
	]

}];


(* ::Subsubsection::Closed:: *)
(*consolidateBonds*)


DefineTests[consolidateBonds,{

	Test["Consolidate in StrandSpan form:",
		consolidateBonds[Structure[{Strand[DNA["AAATTT"]]},{Bond[{1,1;;1},{1,6;;6}],Bond[{1,2;;2},{1,5;;5}],Bond[{1,3;;3},{1,4;;4}]}]],
		Structure[{Strand[DNA["AAATTT"]]},{Bond[{1,1;;3},{1,4;;6}]}]
	],

	Test["Consolidate in MotifSpan form:",
		consolidateBonds[Structure[{Strand[DNA["AAATTT"]]},{Bond[{1,1,1;;1},{1,1,6;;6}],Bond[{1,1,2;;2},{1,1,5;;5}],Bond[{1,1,3;;3},{1,1,4;;4}]}]],
		Structure[{Strand[DNA["AAATTT"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]
	],

	Example[{Basic, "Consolidate a folded RNA strand with mutliple adjacent bonds:"},
		consolidateBonds[Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]},{Bond[{1,1,1;;1},{1,1,29;;29}],Bond[{1,1,2;;2},{1,1,28;;28}],Bond[{1,1,3;;3},{1,1,27;;27}],Bond[{1,1,5;;5},{1,1,23;;23}],Bond[{1,1,6;;6},{1,1,22;;22}],Bond[{1,1,7;;7},{1,1,21;;21}],Bond[{1,1,9;;9},{1,1,20;;20}],Bond[{1,1,10;;10},{1,1,19;;19}],Bond[{1,1,11;;11},{1,1,18;;18}],Bond[{1,1,12;;12},{1,1,17;;17}]}]],
		Structure[{Strand[RNA["CCCUUGGAUGGGGGUGCCCACCACCUGGG"]]},{Bond[{1,1,1;;3},{1,1,27;;29}],Bond[{1,1,5;;7},{1,1,21;;23}],Bond[{1,1,9;;12},{1,1,17;;20}]}]
	],

	Example[{Basic, "Consolidate a complex folded RNA strand with mutliple adjacent bonds:"},
		consolidateBonds[Structure[{Strand[RNA["UAACGGCGGAUUAUUAAAUUUCAAGCACGAGCAGAAAACUAAUCCGCGUUUAGACGGCUAGACUAAAUAUAGCCGGCAGGCACAUUUGUAUGAUACCCCG"]]},{Bond[{1,1,4;;4},{1,1,100;;100}],Bond[{1,1,5;;5},{1,1,99;;99}],Bond[{1,1,6;;6},{1,1,47;;47}],Bond[{1,1,7;;7},{1,1,46;;46}],Bond[{1,1,8;;8},{1,1,45;;45}],Bond[{1,1,9;;9},{1,1,44;;44}],Bond[{1,1,10;;10},{1,1,43;;43}],Bond[{1,1,11;;11},{1,1,42;;42}],Bond[{1,1,12;;12},{1,1,41;;41}],Bond[{1,1,13;;13},{1,1,40;;40}],Bond[{1,1,19;;19},{1,1,37;;37}],Bond[{1,1,20;;20},{1,1,36;;36}],Bond[{1,1,21;;21},{1,1,35;;35}],Bond[{1,1,22;;22},{1,1,34;;34}],Bond[{1,1,25;;25},{1,1,32;;32}],Bond[{1,1,26;;26},{1,1,31;;31}],Bond[{1,1,48;;48},{1,1,96;;96}],Bond[{1,1,49;;49},{1,1,95;;95}],Bond[{1,1,55;;55},{1,1,75;;75}],Bond[{1,1,56;;56},{1,1,74;;74}],Bond[{1,1,57;;57},{1,1,73;;73}],Bond[{1,1,58;;58},{1,1,72;;72}],Bond[{1,1,59;;59},{1,1,71;;71}],Bond[{1,1,60;;60},{1,1,70;;70}],Bond[{1,1,77;;77},{1,1,92;;92}],Bond[{1,1,78;;78},{1,1,91;;91}],Bond[{1,1,80;;80},{1,1,89;;89}],Bond[{1,1,81;;81},{1,1,88;;88}],Bond[{1,1,82;;82},{1,1,87;;87}]}]],
		Structure[{Strand[RNA["UAACGGCGGAUUAUUAAAUUUCAAGCACGAGCAGAAAACUAAUCCGCGUUUAGACGGCUAGACUAAAUAUAGCCGGCAGGCACAUUUGUAUGAUACCCCG"]]},{Bond[{1,1,4;;5},{1,1,99;;100}],Bond[{1,1,6;;13},{1,1,40;;47}],Bond[{1,1,19;;22},{1,1,34;;37}],Bond[{1,1,25;;26},{1,1,31;;32}],Bond[{1,1,48;;49},{1,1,95;;96}],Bond[{1,1,55;;60},{1,1,70;;75}],Bond[{1,1,77;;78},{1,1,91;;92}],Bond[{1,1,80;;82},{1,1,87;;89}]}]
	],

	Example[{Basic, "Consolidate bonds between different DNA motifs:"},
		consolidateBonds[Structure[{Strand[DNA[4,"A"],DNA[5,"B"],DNA[5,"B'"],DNA[4,"A'"]]},{Bond[{1,1},{1,4}],Bond[{1,2},{1,3}]}]],
		Structure[{Strand[DNA[4,"A"],DNA[5,"B"],DNA[5,"B'"],DNA[4,"A'"]]},{Bond[{1,1},{1,4}],Bond[{1,2},{1,3}]}]
	],

	Test["More Motif bonds:",
		consolidateBonds[Structure[{Strand[DNA[4,"A"],DNA[5,"B"]],Strand[DNA[5,"B'"],DNA[4,"A'"]]},{Bond[{1,1},{1,2}],Bond[{1,2},{2,1}]}]],
		Structure[{Strand[DNA[4,"A"],DNA[5,"B"]],Strand[DNA[5,"B'"],DNA[4,"A'"]]},{Bond[{1,1},{1,2}],Bond[{1,2},{2,1}]}]
	],

	Test["Consolidate bonds for two strands:",
		consolidateBonds[Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 1}, {2, 1, 3 ;; 3}], Bond[{1, 2, 2 ;; 3}, {2, 1, 1 ;; 2}]}]],
		Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]
	],
	Test["Consolidate bonds for two strands, another example:",
		consolidateBonds[Structure[{Strand[DNA["AAAAAAAAAA"]], Strand[DNA["TTTTTTTTTT"]]}, {Bond[{1,2;;4},{2,7;;9}],Bond[{1,5;;7},{2,4;;6}],Bond[{1,8;;9},{2,2;;3}]}]],
		Structure[{Strand[DNA["AAAAAAAAAA"]], Strand[DNA["TTTTTTTTTT"]]}, {Bond[{1, 2 ;; 9}, {2, 2 ;; 9}]}]
	],
	Test["Consolidate bonds for two strands, with one not being consolidated:",
		consolidateBonds[Structure[{Strand[DNA["AAAAAAAAAA"]], Strand[DNA["TTTTTTTTTT"]]}, {Bond[{1,2;;4},{2,7;;9}],Bond[{1,5;;7},{2,4;;6}],Bond[{1,10;;10},{2,1;;1}]}]],
		Structure[{Strand[DNA["AAAAAAAAAA"]], Strand[DNA["TTTTTTTTTT"]]}, {Bond[{1, 2 ;; 7}, {2, 4 ;; 9}], Bond[{1, 10 ;; 10}, {2, 1 ;; 1}]}]
	],
	Test["Weird out of order bonds not consolidated:",
		consolidateBonds[Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 1}, {2, 1, 1 ;; 1}], Bond[{1, 2, 2 ;; 3}, {2, 1, 2 ;; 3}]}]],
		Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 1}, {2, 1, 1 ;; 1}], Bond[{1, 2, 2 ;; 3}, {2, 1, 2 ;; 3}]}]
	]
}];


(* ::Subsection:: *)
(*Structure manipulation*)


(* ::Subsubsection:: *)
(*StructureQ*)


DefineTests[StructureQ,
{
		Test[
			"Identify invalid structures:",
			StructureQ["Fish"],
			False
		],
		Example[
			{Basic,"Returns false for things that aren't complexes:"},
			StructureQ[Strand[Modification["Fluorescein","F"],DNA["ATGCATGCAT","A"]]],
			False
		],
		Test[
			"Check good structures:",
			StructureQ[Structure[{Strand[DNA["ATGCATGCAT","A'"]],Strand[Modification["Fluorescein","F"],DNA["ATGCATGCAT","A"]]},{Bond[{1,1},{2,2}]}]],
			True
		],
		Test[
			"Check good structures:",
			StructureQ[Structure[{Strand[DNA[12,""]]}]],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			StructureQ[Structure[{Strand[DNA["ATGCATGCAT"]],Strand[Modification["Fluorescein"],DNA[4]]},{}]],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			!StructureQ[Structure[{Strand[DNA["ATGCATGCAT","A'"]],Strand[Modification["Fluorescein"],DNA[4]]},{}],Sequence->True],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			!StructureQ[Structure[{Strand[DNA["ATGCATGCAT"]],Strand[Modification["Fluorescein"],DNA[4]]},{}],Sequence->False],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			StructureQ[Structure[{Strand[DNA["ATGCATGCAT","A'"]],Strand[Modification["Fluorescein"]]},{}],Sequence->True],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			StructureQ[Structure[{Strand[DNA[5]],Strand[Modification[1],DNA[4]]},{}],Sequence->False],
			True
		],
		Test[
			"Structures must all contain explicit sequences:",
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},{Bond[{1,1},{2,1}]}]],
			True
		],
		Example[
			{Options,CheckMotifs,"Check that primed motifs are actually primes of their unprimed counterparts:"},
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},{Bond[{1,1},{2,1}]}],CheckMotifs->True],
			True
		],
		Test[
			"Check motifs can actually pair:",
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["ATGACAGAG","A"]]},{Bond[{1,1},{2,1}]}],CheckMotifs->True],
			False
		],
		Test[
			"Check pairs can actually pair:",
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},{Bond[{1,1},{2,1}]}],CheckPairs->True],
			True
		],
		Example[
			{Options,CheckPairs,"Check pairs can actually pair:"},
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GAGATACATA"]]},{Bond[{1,1},{2,1}]}],CheckPairs->True],
			False
		],
		Example[
			{Options,Sequence,"Check if a Structure is correctly formatted:"},
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GAGATACATA"]]},{Bond[{1,1},{2,1}]}],Sequence->True],
			True
		],
		Test[
			"Check if a Structure is correctly formatted:",
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GAGATACATA"]]},{Bond[{1,1},{2,1}]}],Sequence->True],
			True
		],
		Example[
			{Basic,"Return False if has bad motifs:"},
			StructureQ[Structure[{Strand[DNA["AUGCATGAC","A'"]],Strand[DNA["GTCATGCAT"]]},{Bond[{1,1},{2,1}]}],CheckPairs->True,CheckMotifs->True],
			False
		],
		Example[
			{Basic,"Can skip the check for motifs:"},
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT"]]},{Bond[{1,1},{2,1}]}],CheckPairs->True,CheckMotifs->False],
			True
		],
		Test[
			"Good:",
			StructureQ[Structure[{Strand[DNA["ATGCATGAC","A'"]],Strand[DNA["GTCATGCAT","A"]]},{Bond[{1,1},{2,1}]}],CheckPairs->True,CheckMotifs->True],
			True
		],
		Example[
			{Options,CanonicalPairing,"If CanonicalPairing is set to False, canonical pairing is allowed in the sequences:"},
			StructureQ[Structure[{Strand[RNA["AUGAUA","A"],DNA[20,"B"],DNA["TANNAT","A'"]],Strand[RNA["AUGAUA","A"],DNA[20,"B"],DNA["TANNAT","A'"]]},{}], CheckMotifs->True,CanonicalPairing->True],
			True
		],


		(* invalid bond specifications *)
		Test["Invalid strand in StrandMotif bond:",
			StructureQ[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{3,1},{1,2}]}]],
			False
		],
		Test["Invalid strand in StrandMotifSpan bond:",
			StructureQ[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1;;3},{3,1;;3}]}]],
			False
		],
		Test["Invalid span in StrandSpan bond:",
			StructureQ[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1;;3},{2,15;;20}]}]],
			False
		],
		Test["Invalid strand in StrandMotifSpan bond:",
			StructureQ[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,2,1;;3},{2,3,1;;3}]}]],
			False
		],
		Test["Invalid span in StrandMotifSpan bond:",
			StructureQ[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,2,1;;3},{2,1,31;;33}]}]],
			False
		],
		Test["Overlap and stagger bonds:",
			StructureQ[Structure[{Strand[DNA["TTTTTTTTTTTTAAAAAAAAAA"]]}, {Bond[{1,3;;6}, {1,13;;16}], Bond[{1,3;;5}, {1,13;;15}]}]],
			False
		]

}];



(* ::Subsubsection::Closed:: *)
(*validStructureBonds*)


DefineTests[validStructureBonds,{

	Test["Invalid strand number 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{3,1},{1,2}]}]],
		False
	],
	Test["Invalid strand number 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1},{3,2}]}]],
		False
	],

	Test["Valid strand number 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1},{1,2}]}]],
		True
	],
	Test["Valid strand number 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1},{2,2}]}]],
		True
	],

	Test["Valid StrandSpan 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1;;3},{2,1;;3}]}]],
		True
	],
	Test["Valid StrandSpan 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,9;;11},{2,9;;11}]}]],
		True
	],
	Test["Invalid StrandSpan 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,15;;20},{2,1;;3}]}]],
		False
	],
	Test["Invalid StrandSpan 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1;;3},{2,15;;20}]}]],
		False
	],
	Test["Invalid StrandSpan 3:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,20;;25},{2,9;;11}]}]],
		False
	],
	Test["Invalid StrandSpan 4:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1;;3},{2,20;;25}]}]],
		False
	],

	Test["Valid StrandMotifSpan 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1,1;;3},{2,1,1;;3}]}]],
		True
	],
	Test["Valid StrandMotifSpan 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,2,1;;3},{2,2,1;;3}]}]],
		True
	],
	Test["Invalid StrandMotifSpan 1:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,3,1;;3},{2,1,1;;3}]}]],
		False
	],
	Test["Invalid StrandMotifSpan 2:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,2,1;;3},{2,3,1;;3}]}]],
		False
	],
	Test["Invalid StrandMotifSpan 3:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,1,15;;30},{2,1,1;;3}]}]],
		False
	],
	Test["Invalid StrandMotifSpan 4:",
		validStructureBonds[Structure[{Strand[DNA["ATCGATCG","X"],RNA["CCC"]],Strand[DNA["ATCGATCG","X"],RNA["GGG"]]},{Bond[{1,2,1;;3},{2,1,15;;30}]}]],
		False
	]

}];


(* ::Subsubsection::Closed:: *)
(*StructureSort*)


DefineTests[
	StructureSort,
	{
		Example[
			{Basic,"Structure with one Strand:"},
			StructureSort[Structure[{Strand[DNA[20,"A"]]},{}]],
			Structure[{Strand[DNA[20,"A"]]},{}]
		],
		Example[
			{Basic,"Structure with two Strands:"},
			StructureSort[Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{}]
		],
		Example[
			{Basic,"Sort the strands in a Structure:"},
			StructureSort[Structure[{Strand[DNA[20,"B"]],Strand[DNA[20,"A"]]},{}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{}]
		],
		Example[
			{Basic,"Sort a Structure:"},
			StructureSort[Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,1;;5},{2,1,3;;7}]}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,1;;5},{2,1,3;;7}]}]
		],
		Example[
			{Basic,"Sort a Structure:"},
			StructureSort[Structure[{Strand[DNA[20,"B"]],Strand[DNA[20,"A"]]},{Bond[{1,1,1;;5},{2,1,3;;7}]}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,3;;7},{2,1,1;;5}]}]
		],
		Example[
			{Additional,"Pair indicies are adjusted to account for new Strand positions:"},
			StructureSort[Structure[{Strand[DNA[20,"B'"],DNA[20,"A'"]],Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"]]},{Bond[{2,1},{3,2}],Bond[{2,2},{1,2}]}]],
			Structure[{Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{3,2}]}]
		],
		Example[
			{Additional,"Make sure these all sort to the same thing:"},
			Union[StructureSort/@{Structure[{Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{3,3}]}],Structure[{Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]]},{Bond[{1,1},{3,2}],Bond[{1,2},{2,3}]}],Structure[{Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]]},{Bond[{2,1},{1,2}],Bond[{2,2},{3,3}]}],Structure[{Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]],Strand[DNA[20,"A"],DNA[20,"A"]]},{Bond[{3,1},{1,2}],Bond[{3,2},{2,3}]}],Structure[{Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]],Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]]},{Bond[{2,1},{3,2}],Bond[{2,2},{1,3}]}],Structure[{Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"A"],DNA[20,"A"]]},{Bond[{3,1},{2,2}],Bond[{3,2},{1,3}]}]}],
			{Structure[{Strand[DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A"]],Strand[DNA[20,"B'"],DNA[20,"A"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{3,3}]}]}
		],
		Example[
			{Additional,"An example of core form sorting:"},
			StructureSort[Structure[{Strand[DNA["ACGTACGTCTACGT","X"]],Strand[DNA["ACGTACGTCTACGT","X"]]},{Bond[{1,1,10;;14},{2,1,1;;5}]}]],
			Structure[{Strand[DNA["ACGTACGTCTACGT","X"]],Strand[DNA["ACGTACGTCTACGT","X"]]},{Bond[{1,1,1;;5},{2,1,10;;14}]}]
		],

		Test["These two should sort to the same thing:",
			SameQ[
				StructureSort[Structure[{Strand[DNA["A"],DNA["X"]],Strand[DNA["X"],DNA["T"]],Strand[RNA["U"]],Strand[RNA["A"]]},{Bond[{1,1},{2,2}]}]],
				StructureSort[Structure[{Strand[DNA["X"],DNA["T"]],Strand[DNA["A"],DNA["X"]],Strand[RNA["U"]],Strand[RNA["A"]]},{Bond[{1,2},{2,1}]}]]
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*StructureJoin*)


DefineTests[StructureJoin,
{
		Example[
			{Basic,"Join two complexes:"},
			StructureJoin[Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{}]
		],
		Example[
			{Basic,"Structure with pairs:"},
			StructureJoin[Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}],Structure[{Strand[DNA[20,"B"]]},{}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]
		],
		Test[
			"Join two complexes:",
			StructureJoin[Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"B"]]},{}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{}]
		],
		Test[
			"Structure with pairs:",
			StructureJoin[Structure[{Strand[DNA[20,"A"]]},{Bond[{1,1,2;;5},{1,1,6;;9}]}],Structure[{Strand[DNA[20,"B"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]],
			Structure[{Strand[DNA[20,"A"]],Strand[DNA[20,"B"]]},{Bond[{1,1,2;;5},{1,1,6;;9}],Bond[{2,1,1;;3},{2,1,4;;6}]}]
		],
		Example[
			{Basic,"Structures with sequences:"},
			StructureJoin[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACTGATCGTA","Y"]]},{Bond[{1,1,1;;4},{1,1,5;;8}]}],Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}]],
			Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACTGATCGTA","Y"]],Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;4},{1,1,5;;8}],Bond[{2,1,1;;5},{3,1,2;;6}]}]
		],
		Example[
			{Additional,"Given one structure, returns same structure:"},
			StructureJoin[Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}]],
			Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}]
		],
		Example[
			{Additional,"Join three structures:"},
			StructureJoin[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACTGATCGTA","Y"]]},{Bond[{1,1,1;;4},{1,1,5;;8}]}],Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}],Structure[{Strand[DNA["ATATATT"]]},{}]],
			Structure[{Strand[DNA["ACGTACGTACGT", "X"], DNA["ACTGATCGTA", "Y"]], Strand[DNA["ATCAACATGCAG", "B"]], Strand[DNA["ATCGATCGTCAG", "E"]], Strand[DNA["ATATATT"]]}, {Bond[{1, 1, 1 ;; 4}, {1, 1, 5 ;; 8}], Bond[{2, 1, 1 ;; 5}, {3, 1, 2 ;; 6}]}]
		],
		Example[
			{Applications,"View the result:"},
			StructureJoin[Structure[{Strand[DNA["ACGTACGTACGT","X"],DNA["ACTGATCGTA","Y"]]},{Bond[{1,1,1;;4},{1,1,5;;8}]}],Structure[{Strand[DNA["ATCAACATGCAG","B"]],Strand[DNA["ATCGATCGTCAG","E"]]},{Bond[{1,1,1;;5},{2,1,2;;6}]}]],
			_
		]
}];



(* ::Subsubsection::Closed:: *)
(*StructureTake*)


DefineTests[StructureTake,
{
		Example[
			{Basic,"Pull first motif from first Strand:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{1,1}],
			"ACGTACGT"
		],
		Example[
			{Basic,"Pull bases 1-4 from first motif in first Strand:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{1,1,1;;4}],
			Strand[DNA["ACGT"]]
		],
		Example[
			{Additional,"If not specifying motif index, starts counting from beginning of Strand:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{1,1;;4}],
			Strand[DNA["ACGT"]]
		],
		Example[
			{Additional,"If not specifying motif index, bases count from start of Strand and can cross motifs:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{1,9;;12}],
			Strand[DNA["CCGG"]]
		],
		Example[
			{Additional,"Pull from second motif:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{1,2,1;;4}],
			Strand[DNA["CCGG"]]
		],
		Test[
			"If not specifying motif index, starts counting from beginning of Strand (but there's only one motif here):",
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{2,1;;4}],
			Strand[DNA["AAAC"]]
		],
		Example[
			{Basic,"Pull from second Strand:"},
			StructureTake[Structure[{Strand[DNA["ACGTACGT","X"],DNA["CCGGTTAA","Z"]],Strand[DNA["AAACCC","Y"]]},{}],{2,1,1;;4}],
			Strand[DNA["AAAC"]]
		]
}];



(* ::Subsubsection:: *)
(*reformatMotifs*)


DefineTests[reformatMotifs,
{
		Example[
			{Basic,"Reformat motifs in a Structure so that all pairs contain full motifs:"},
			reformatMotifs[Structure[{Strand[DNA[20]]},{Bond[{1,1,1;;10},{1,1,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 1}, {1, 2}]}]
		],
		Example[
			{Additional,"Reformat Structure with single Strand and single Bond:"},
			reformatMotifs[Structure[{Strand[DNA[25]]},{Bond[{1,1,6;;15},{1,1,16;;25}]}]],
			Structure[{Strand[DNA["NNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 3}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[50]]},{Bond[{1,1,11;;20},{1,1,31;;40}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 4}]}]
		],
		Example[
			{Additional,"Reformat Structure with single Strand and multiple pairs:"},
			reformatMotifs[Structure[{Strand[DNA[100]]},{Bond[{1,1,11;;20},{1,1,31;;40}],Bond[{1,1,61;;70},{1,1,81;;90}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"],
   DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 4}], Bond[{1, 6}, {1, 8}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[100]]},{Bond[{1,1,6;;14},{1,1,32;;37}],Bond[{1,1,64;;71},{1,1,83;;88}]}]],
			Structure[{Strand[DNA["NNNNN"], DNA["NNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNN"], DNA["NNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNNNNNNNN"], DNA["NNNNNNNN"], DNA["NNNNNNNNNNN"],
   DNA["NNNNNN"], DNA["NNNNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 4}], Bond[{1, 6}, {1, 8}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[10],DNA[10]]},{Bond[{1,1,1;;10},{1,2,1;;10}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 1}, {1, 2}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[15],DNA[10]]},{Bond[{1,1,6;;15},{1,2,1;;10}]}]],
			Structure[{Strand[DNA["NNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 3}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[25],DNA[25]]},{Bond[{1,1,11;;20},{1,2,6;;15}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNN"], DNA["NNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 5}]}]
		],
		Test[
			"Test for basic structure input:",
			reformatMotifs[Structure[{Strand[DNA[20],DNA[30]]},{Bond[{1,1,11;;20},{1,2,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]]}, {Bond[{1, 2}, {1, 4}]}]
		],
		Test[
			"Test for advanced structure input:",
			reformatMotifs[Structure[{Strand[DNA[20],DNA[20],DNA[20],DNA[20],DNA[20]]},{Bond[{1,1,11;;20},{1,2,11;;20}],Bond[{1,3,11;;20},{1,4,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"],
   DNA["NNNNNNNNNN"], DNA[20]]}, {Bond[{1, 2}, {1, 4}], Bond[{1, 6}, {1, 8}]}]
		],
		Example[
			{Additional,"Strand with many motifs:"},
			reformatMotifs[Structure[{Strand[DNA[20],DNA[20],DNA[20],DNA[20],DNA[20]]},{Bond[{1,1,11;;20},{1,2,1;;10}],Bond[{1,3,1;;10},{1,4,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"],
   DNA["NNNNNNNNNN"], DNA[20]]}, {Bond[{1, 2}, {1, 3}], Bond[{1, 5}, {1, 8}]}]
		],
		Example[
			{Additional,"Reformat Structure with multiple strands and single pair:"},
			reformatMotifs[Structure[{Strand[DNA[30],DNA[35]],Strand[DNA[40],DNA[25]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNN"], DNA[35]], Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"], DNA[25]]},
 {Bond[{1, 1}, {2, 1}]}]
		],
		Test[
			"Test for advanced structure input:",
			reformatMotifs[Structure[{Strand[DNA[30],DNA[35]],Strand[DNA[40],DNA[25]]},{Bond[{1,1,11;;20},{2,1,1;;10}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA[35]], Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"], DNA[25]]},
 {Bond[{1, 2}, {2, 1}]}]
		],
		Test[
			"Test for advanced structure input:",
			reformatMotifs[Structure[{Strand[DNA[50]],Strand[DNA[50]]},{Bond[{1,1,11;;20},{1,1,21;;30}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNN"]], Strand[DNA[50]]}, {Bond[{1, 2}, {1, 3}]}]
		],
		Example[
			{Additional,"Given Structure with pair completely contained in one motif:"},
			reformatMotifs[Structure[{Strand[DNA[50]],Strand[DNA[50]]},{Bond[{1,1,21;;30},{1,1,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNNNNNNNNNNNN"]], Strand[DNA[50]]}, {Bond[{1, 3}, {1, 2}]}]
		],
		Test[
			"Test for advanced structure input:",
			reformatMotifs[Structure[{Strand[DNA[30]],Strand[DNA[50]]},{Bond[{1,1,21;;30},{1,1,11;;20}]}]],
			Structure[{Strand[DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"], DNA["NNNNNNNNNN"]], Strand[DNA[50]]}, {Bond[{1, 3}, {1, 2}]}]
		]
}];




(* ::Subsubsection:: *)
(*reformatBonds*)


DefineTests[reformatBonds,{

	Example[{Basic,"Reformat bonds from StrandMotifBase to StrandBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],StrandBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}]
	],
	Example[{Basic,"Reformat bonds from StrandBase to StrandMotifBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}],StrandMotifBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}]
	],
	Example[{Basic,"Reformat bonds from StrandMotif form to StrandMotifBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTT","X'"]]},{Bond[{1,1},{2,4}],Bond[{1,3},{2,2}]}],StrandMotifBase],
		Structure[{Strand[DNA["AAAAA", "X"], RNA["UUUU", "Y"],DNA["GGGGGG", "Z"], Modification["Fluorescein"]],	Strand[DNA["ATCG", "V"], DNA["CCCCCC", "Z'"], RNA["AUCG", "W"],	DNA["TTTTT", "X'"]]}, {Bond[{1, 1, 1 ;; 5}, {2, 4, 1 ;; 5}],Bond[{1, 3, 1 ;; 6}, {2, 2, 1 ;; 6}]}]
	],
	Example[{Basic,"Reformat bonds from StrandMotif form to StrandBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTT","X'"]]},{Bond[{1,1},{2,4}],Bond[{1,3},{2,2}]}],StrandBase],
		Structure[{Strand[DNA["AAAAA", "X"], RNA["UUUU", "Y"], DNA["GGGGGG", "Z"], Modification["Fluorescein"]], Strand[DNA["ATCG", "V"], DNA["CCCCCC", "Z'"], RNA["AUCG", "W"], DNA["TTTTT", "X'"]]}, {Bond[{1, 1 ;; 5}, {2, 15 ;; 19}], Bond[{1, 10 ;; 15}, {2, 5 ;; 10}]}]
	],


	Example[{Additional,"Reformat bonds from StrandMotifBase to StrandMotif form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],StrandMotif],
		Structure[{Strand[DNA["AAAAA"], DNA["A"], RNA["UUUU", "Y"], DNA["G"],			DNA["GGGG"], DNA["G"], Modification["Fluorescein"]],			Strand[DNA["ATCG", "V"], DNA["CCCC"], DNA["CC"], RNA["AUCG", "W"],				DNA["T"], DNA["TTTTT"]]}, {Bond[{1, 1}, {2, 6}],			Bond[{1, 5}, {2, 2}]}]
	],
	Example[{Additional,"Reformat bonds from StrandBase to StrandMotif form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}],StrandMotif],
		Structure[{Strand[DNA["AAAAA"], DNA["A"], RNA["UUUU", "Y"], DNA["G"],	DNA["GGGG"], DNA["G"], Modification["Fluorescein"]],	Strand[DNA["ATCG", "V"], DNA["CCCC"], DNA["CC"], RNA["AUCG", "W"],	DNA["T"], DNA["TTTTT"]]}, {Bond[{1, 1}, {2, 6}],	Bond[{1, 5}, {2, 2}]}]
	],
	Example[{Additional,"Reformat bonds from StrandMotif form to StrandMotif form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTT","X'"]]},{Bond[{1,1},{2,4}],Bond[{1,3},{2,2}]}],StrandMotif],
		Structure[{Strand[DNA["AAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTT","X'"]]},{Bond[{1,1},{2,4}],Bond[{1,3},{2,2}]}]
	],

	Example[{Additional,"Bonds that span motifs in StrandBase form will be split into multiple bonds when converted to StrandMotifBase form:"},
		reformatBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["CCCC"],DNA["TTTT"]]},{Bond[{1,1;;4},{1,9;;12}]}],StrandMotifBase],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["CCCC"],DNA["TTTT"]]},{Bond[{1,1,1;;2},{1,4,3;;4}],Bond[{1,2,1;;2},{1,4,1;;2}]}]
	],
	Test["Original bond spans three motifs on top and two on bottom; result has four separate bonds:",
		reformatBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;5},{1,10;;13}]}],StrandMotifBase],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,1,2;;2},{1,6,2;;2}],Bond[{1,2,1;;1},{1,6,1;;1}],Bond[{1,2,2;;2},{1,5,2;;2}],Bond[{1,3,1;;1},{1,5,1;;1}]}]
	],

	Example[{Additional,"Reformat bonds from StrandMotifBase to StrandMotifBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],StrandMotifBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}]
	],
	Example[{Additional,"Reformat bonds from StrandBase to StrandBase form:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}],StrandBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;5},{2,16;;20}],Bond[{1,12;;15},{2,5;;8}]}]
	],
	Example[{Additional,"No bonds, do nothing:"},
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]}],StrandBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]}]
	],
	Example[{Additional,"Reformat separate small bonds without combining them:"},
		reformatBonds[Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,1,2;;2},{1,6,2;;2}],Bond[{1,2,1;;1},{1,6,1;;1}],Bond[{1,2,2;;2},{1,5,2;;2}],Bond[{1,3,1;;1},{1,5,1;;1}]}],StrandBase],
		Structure[{Strand[DNA["AA"],DNA["AA"],DNA["AA"],DNA["CCC"],DNA["TT"],DNA["TT"]]},{Bond[{1,2;;2},{1,13;;13}],Bond[{1,3;;3},{1,12;;12}],Bond[{1,4;;4},{1,11;;11}],Bond[{1,5;;5},{1,10;;10}]}]
	],
	Test["Mix type to StrandMotifBase:",
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],DNA["CGCGCG", "AA"],Modification["Fluorescein"]],Strand[DNA["GCGCGC", "AA'"], DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1},{2,5}],Bond[{1,12;;15},{2,11;;14}], Bond[{1,4,1;;6},{2,1,1;;6}]}],StrandMotifBase],
		Structure[{Strand[DNA["AAAAAA", "X"], RNA["UUUU", "Y"], DNA["GGGGGG", "Z"], DNA["CGCGCG", "AA"], Modification["Fluorescein"]], Strand[DNA["GCGCGC", "AA'"], DNA["ATCG", "V"], DNA["CCCCCC", "Z'"], RNA["AUCG", "W"], DNA["TTTTTT", "X'"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 5, 1 ;; 6}], Bond[{1, 3, 2 ;; 5}, {2, 3, 1 ;; 4}], Bond[{1, 4, 1 ;; 6}, {2, 1, 1 ;; 6}]}]
	],
	Test["Mix type to StrandBase:",
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],DNA["CGCGCG", "AA"],Modification["Fluorescein"]],Strand[DNA["GCGCGC", "AA'"], DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1},{2,5}],Bond[{1,12;;15},{2,11;;14}], Bond[{1,4,1;;6},{2,1,1;;6}]}],StrandBase],
		Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],DNA["CGCGCG","AA"],Modification["Fluorescein"]],Strand[DNA["GCGCGC","AA'"],DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1;;6},{2,21;;26}],Bond[{1,12;;15},{2,11;;14}],Bond[{1,17;;22},{2,1;;6}]}]
	],
	Test["Mix type to StrandMotif:",
		reformatBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],DNA["CGCGCG", "AA"],Modification["Fluorescein"]],Strand[DNA["GCGCGC", "AA'"], DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1},{2,5}],Bond[{1,12;;15},{2,11;;14}], Bond[{1,4,1;;6},{2,1,1;;6}]}],StrandMotif],
		Structure[{Strand[DNA["AAAAAA"],RNA["UUUU","Y"],DNA["G"],DNA["GGGG"],DNA["G"],DNA["CGCGCG"],Modification["Fluorescein"]],Strand[DNA["GCGCGC"],DNA["ATCG","V"],DNA["CCCC"],DNA["CC"],RNA["AUCG","W"],DNA["TTTTTT"]]},{Bond[{1,1},{2,6}],Bond[{1,4},{2,3}],Bond[{1,6},{2,1}]}]
	]
}];




(* ::Subsubsection::Closed:: *)
(*validMotifsQ*)


DefineTests[validMotifsQ,{
	Test[validMotifsQ[Structure[{Strand[DNA["AAA","X"],DNA["TTT","Y"]]},{}]]],
	Test[validMotifsQ[Structure[{Strand[DNA["AAA","X"],DNA["TTT","Y"]]},{Bond[{1,1},{1,2}]}]]],
	Test[validMotifsQ[Structure[{Strand[DNA["AAA","X"],DNA["TTT","Y"]]},{Bond[{1,1,1;;2},{1,2,2;;3}]}]]],
	Test[!validMotifsQ[Structure[{Strand[DNA["AAA","X"],DNA["TTT","Y"]]},{Bond[{1,1},{1,1}]}]]],
	Test[!validMotifsQ[Structure[{Strand[DNA["AAA","X"],DNA["TTT","Y"]]},{Bond[{1,1,1;;2},{1,1,2;;3}]}]]]
}];


(* ::Subsubsection:: *)
(*NumberOfBonds*)


DefineTests[NumberOfBonds,{
	Example[{Basic,"Count bonds of a simple structure with bonds in span form:"},
		NumberOfBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}]],
		9
	],
	Example[{Basic,"Count bonds of a simple structure with bonds in motif form:"},
		NumberOfBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1},{2,4}],Bond[{1,3},{2,2}]}]],
		12
	],
	Example[{Basic,"Count bonds of a simple structure with no bonds:"},
		NumberOfBonds[Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{}]],
		0
	],
	Example[{Attributes,Listable,"Count bonds of two simple structures with bonds in span form:"},
		NumberOfBonds[
			{Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;5},{2,4,2;;6}],Bond[{1,3,2;;5},{2,2,1;;4}]}],
			Structure[{Strand[DNA["AAAAAA","X"],RNA["UUUU","Y"],DNA["GGGGGG","Z"],Modification["Fluorescein"]],Strand[DNA["ATCG","V"],DNA["CCCCCC","Z'"],RNA["AUCG","W"],DNA["TTTTTT","X'"]]},{Bond[{1,1,1;;6},{2,4,1;;6}],Bond[{1,3,3;;7},{2,2,1;;5}]}]}
		],
		{9,11}
	]
}];


(* ::Subsubsection:: *)
(*SplitStructure*)


DefineTests[SplitStructure,{
	Example[{Basic,"Split a structure into separate structures that do not share any bonds:"},
		SplitStructure[Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"]],Strand[DNA[20,"A"]],Strand[DNA[20,"A"],DNA[20,"B"]]},{Bond[{1,2},{3,2}]}]],
		{Structure[{Strand[DNA[20,"A"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2},{2,2}]}]}
	],
	Example[{Basic,"If there are unconnected substructres, the given structure is returned:"},
		SplitStructure[
			Structure[{Strand[DNA[20, "C'"], DNA[20, "B'"]],
				Strand[DNA[20, "A"], DNA[20, "B"]]}, {Bond[{1, 2}, {2, 2}]}]],
		{Structure[{Strand[DNA[20, "A"], DNA[20, "B"]], Strand[DNA[20, "C'"], DNA[20, "B'"]]}, {Bond[{1, 2}, {2, 2}]}]}
	],
	Example[{Basic,"Split a structure containing 3 unconncected substructures:"},
		SplitStructure[Structure[{Strand[DNA["AAAAAA", "X"], RNA["UUUU", "Y"], DNA["GGGGGG", "Z"], Modification["Fluorescein"]],
			Strand[DNA["ATCG", "V"], DNA["CCCCCC", "Z"], RNA["AUCG", "W"], DNA["TTTTTT", "X'"]],
			Strand[DNA["ATCG", "X"], RNA["AUUU", "Y"], Modification["Fluorescein"]], Strand[DNA["ATCGCGCGCTA"]],
			Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 1, 1 ;; 5}, {2, 4, 2 ;; 6}], Bond[{1, 3, 2 ;; 5}, {2, 2, 1 ;; 4}],
			Bond[{4, 7 ;; 11}, {5, 5 ;; 9}]}]],
		{Structure[{Strand[DNA["ATCG", "X"], RNA["AUUU", "Y"], Modification["Fluorescein"]]}, {}],
			Structure[{Strand[DNA["ATCGCGCGCTA"]], Strand[DNA["ATCGTAGCGTA"]]}, {Bond[{1, 7 ;; 11}, {2, 5 ;; 9}]}],
			Structure[{Strand[DNA["AAAAAA", "X"], RNA["UUUU", "Y"], DNA["GGGGGG", "Z"], Modification["Fluorescein"]],
				Strand[DNA["ATCG", "V"], DNA["CCCCCC", "Z"], RNA["AUCG", "W"], DNA["TTTTTT", "X'"]]},
				{Bond[{1, 1, 1 ;; 5}, {2, 4, 2 ;; 6}], Bond[{1, 3, 2 ;; 5}, {2, 2, 1 ;; 4}]}]}
	]
}];



(* ::Section:: *)
(*End Test Package*)
