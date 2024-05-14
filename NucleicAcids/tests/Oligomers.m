(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Oligomers: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*Converting between types*)


(* ::Subsubsection:: *)
(*SpeciesList*)


DefineTests[
	SpeciesList,
	{
		Example[{Basic,"Species list from rules:"},
			SpeciesList[{a->c,a->b+c,a->2h,2e->a,e+f->g,h\[Equilibrium]c,h+d->c+a}],
			{a,b,c,d,e,f,g,h}
		],
		Example[{Basic,"Species list from rules in other format:"},
			SpeciesList[{{a->c,1},{a->b+c,2},{a->2h,3},{2e->a,4},{e+f->g,5},{h\[Equilibrium]c,6,7},{h+d->c+a,8}}],
			{a,b,c,d,e,f,g,h}
		],
		Example[{Basic,"Structures from a ReactionMechanism:"},
			SpeciesList[ReactionMechanism[
				Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},1],
				Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"B"]],Strand[DNA[6,"C"]]},{}]},2],
				Reaction[{Structure[{Strand[DNA[5,"A"]]},{}]},{Structure[{Strand[DNA[5,"H"]]},{}],Structure[{Strand[DNA[4,"H"]]},{}]},3],
				Reaction[{Structure[{Strand[DNA[5,"E"]]},{}],Structure[{Strand[DNA[5,"E"]]},{}]},{Structure[{Strand[DNA[3,"A"]]},{}]},4],
				Reaction[{Structure[{Strand[DNA[5,"E"]],Strand[DNA[5,"F"]]},{}]},{Structure[{Strand[DNA[5,"G"]]},{}]},5],
				Reaction[{Structure[{Strand[DNA[5,"H"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}]},6,7],
				Reaction[{Structure[{Strand[DNA[5,"H"]]},{}],Structure[{Strand[DNA[5,"D"]]},{}]},{Structure[{Strand[DNA[5,"C"]]},{}],Structure[{Strand[DNA[5,"A"]]},{}]},8]]],
			{Structure[{Strand[DNA[3,"A"]]},{}],Structure[{Strand[DNA[4,"H"]]},{}],Structure[{Strand[DNA[5,"A"]]},{}],Structure[{Strand[DNA[5,"C"]]},{}],Structure[{Strand[DNA[5,"D"]]},{}],Structure[{Strand[DNA[5,"E"]]},{}],Structure[{Strand[DNA[5,"G"]]},{}],Structure[{Strand[DNA[5,"H"]]},{}],Structure[{Strand[DNA[5,"B"]],Strand[DNA[6,"C"]]},{}],Structure[{Strand[DNA[5,"E"]],Strand[DNA[5,"F"]]},{}]}
		],
		Example[{Basic,"Combined list from multiple things:"},
			SpeciesList[ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d,a},2,1]],State[{c,3},{g,4}]],
			{a,b,c,d,g}
		],
		Test["Combined list from multiple other things:",
			SpeciesList[{a->1,b->2,c->3},{c,d,g}],
			{a,b,c,d,g}
		],
		Test["From interactions:",
			SpeciesList[{a+b->c,2c\[Equilibrium]d+a}],
			{a,b,c,d}
		],
		Test["From sides of interactions:",
			SpeciesList[{a+b,2c,d,a}],
			{a,b,c,d}
		],
		Example[{Options,Sort,"Do not sort species:"},
			SpeciesList[{a->c,a->b+c,a->2h,2e->a,e+f->g,h\[Equilibrium]c,h+d->c+a},Sort->False],
			{a,c,b,h,e,f,g,d}
		],
		Example[{Options,Sort,"Sort species:"},
			SpeciesList[{a,g,f,e,b},Sort->True],
			{a,b,e,f,g}
		],
		Example[{Options,Sort,"Do not sort species:"},
			SpeciesList[{a,g,f,e,b},Sort->False],
			{a,g,f,e,b}
		],
		Example[{Options,Structures,"Reformat sequences into structures:"},
			SpeciesList[{Sequence["ACTG"]},Structures->True],
			List[Structure[List[Strand[DNA["ACTG"]]],List[]]]
		],
		Example[{Options,Attributes,"Return complexes:"},
			SpeciesList[{a->c,a->b+c,a->2h,2e->a,e+f->g,h\[Equilibrium]c,h+d->c+a},Attributes->Complex],
			{a,c,a+c,b+c,2e,e+f,g,h,2h,d+h}
		],
		Example[{Messages,"BadFormat","Invalid input formats return an error:"},
			SpeciesList["Hello!"],
			Sort[Null],
			Messages:>{SpeciesList::BadFormat, Sort::normal}
		],
		Test["Single complexes:",
			SpeciesList[{a->b},Attributes->Complex],
			{a,b}
		],
		Test["Compound complexes:",
			SpeciesList[{a+b\[Equilibrium]d+f},Attributes->Complex],
			{a+b,d+f}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ToStrand*)


DefineTests[ToStrand,List[
	Example[{Basic,"Format a sequence as a Strand:"},
		ToStrand["ATGATA"],
		Strand[DNA["ATGATA"]]
	],
	Example[{Basic,"Pull strands out of a Structure:"},
		ToStrand[Structure[{Strand[DNA["ACGTACGT","X"]]},{}]],
		{Strand[DNA["ACGTACGT","X"]]}
	],
	Example[{Basic,"Create Strand of given length:"},
		ToStrand[5,Polymer->DNA],
		Strand[DNA[5]]
	],
	Example[{Basic,"Turn a list of sequences into a Strand with multiple motifs.  Use Map option to return list of strands:"},
		ToStrand[{"AUGUAUG","ATGATGAC","LysHisArg","Dabcyl"}],
		Strand[RNA["AUGUAUG"],DNA["ATGATGAC"],Peptide["LysHisArg"],Modification["Dabcyl"]]
	],
	Example[{Basic,"Specify polymer type and motif name:"},
		ToStrand["ATCG",Polymer->DNA,Motif->"X"],
		Strand[DNA["ATCG","X"]]
	],

	Example[{Additional,"Peptide input:"},
		ToStrand["LysHisArgLys"],
		Strand[Peptide["LysHisArgLys"]]
	],

	Example[{Options,Polymer,"Specify polymer type:"},
		ToStrand["AAAA",Polymer->RNA],
		Strand[RNA["AAAA"]]
	],
	Example[{Options,Motif,"Specify motif name:"},
		ToStrand["AAAA",Motif->"Brad"],
		Strand[DNA["AAAA","Brad"]]
	],
	Example[{Additional,"Mixed list of inputs:"},
		ToStrand[{3,"ATCG"},Polymer->PNA],
		Strand[PNA[3],PNA["ATCG"]]
	],
	Example[{Additional,"Determines polymer type when sequence is non-ambiguous:"},
		ToStrand["AUCG",Polymer->RNA,Motif->"X"],
		Strand[RNA["AUCG","X"]]
	],

	Example[{Options,Map,"Given a list of strands, use Map->True to return a list of strands instead of a single Strand with multiple motifs:"},
		ToStrand[{"ATCG","AUUU","LysHisArg"},Map->True],
		{Strand[DNA["ATCG"]],Strand[RNA["AUUU"]],Strand[Peptide["LysHisArg"]]}
	],
	Example[{Options,Replace,"Use Replace option to replace paired bases with \"X\":"},
		ToStrand[Structure[{Strand[Modification["Fluorescein"],DNA["TGATCGGTGCTGGTTCCCGATCA"],Modification["Bhqtwo"]]},{Bond[{1,2,17;;23},{1,2,1;;7}]}],Replace->True],
		{Strand[Modification["Fluorescein"],DNA["XXXXXXXTGCTGGTTCXXXXXXX"],Modification["Bhqtwo"]]}
	],
	Example[{Options,Replace,"Given bonds in StrandSpan form:"},
		ToStrand[Structure[{Strand[Modification["Fluorescein"],DNA["TGATCGGTGCTGGTTCCCGATCA"],Modification["Bhqtwo"]]},{Bond[{1,18;;24},{1,2;;8}]}],Replace->True],
		{Strand[Modification["Fluorescein"],DNA["XXXXXXXTGCTGGTTCXXXXXXX"],Modification["Bhqtwo"]]}
	],
	Example[{Options,Replace,"Nothing gets replaced if no paired bases present:"},
		ToStrand[Structure[{Strand[DNA["ACGTACGT","Z"]]},{}],Replace->True],
		{Strand[DNA["ACGTACGT","Z"]]}
	],

	Test["Motif name not confused with paired base \"X\":",
		ToStrand[Structure[{Strand[DNA["ACGTACGT","X"]]},{}],Replace->True],
		{Strand[DNA["ACGTACGT","X"]]}
	],
	Test["Structure with multiple strands and no pairs and Replace:",
		ToStrand[Structure[{Strand[DNA["ACGTACGT","X"]],Strand[DNA["ACGTACGT","Y"]]},{}],Replace->True],
		{Strand[DNA["ACGTACGT","X"]],Strand[DNA["ACGTACGT","Y"]]}
	],
	Test["Structure with multiple strands and pairs and Replace:",
		ToStrand[Structure[{Strand[DNA["ACGTACGT","X"]],Strand[DNA["ACGTACGT","Y"]]},{Bond[{1,1,4;;7},{2,1,2;;5}]}],Replace->True],
		{Strand[DNA["ACGXXXXT","X"]],Strand[DNA["AXXXXCGT","Y"]]}
	],
	Test["With mystery base:",
		ToStrand[DNA["ATCGNN"]],
		Strand[DNA["ATCGNN"]]
	],

	Example[{Messages,"InvalidSequence","Given invalid sequence:"},
		ToStrand["ABCDEFGH"],
		Null,
		Messages:>{ToStrand::InvalidSequence}
	],
	Example[{Messages,"InvalidSequence","Given invalid strand:"},
		ToStrand[Strand[DNA["ABCDEFGH"]]],
		Null,
		Messages:>{ToStrand::InvalidStrand}
	],
	Example[{Messages,"InvalidSequence","Given invalid structure:"},
		ToStrand[Structure[{Strand[DNA["ABCDEFGH"]]},{}]],
		Null,
		Messages:>{ToStrand::InvalidStructure}
	],

	Test["From structure to strands:",
		ToStrand[Structure[{Strand[DNA["ATCG"], DNA["GCGCG"]]}, {}]],
		{Strand[DNA["ATCG"], DNA["GCGCG"]]}
	],
	Example[{Additional,"Given a structure with multiple strands:"},
		ToStrand[Structure[{Strand[DNA["ATCG"],RNA["UUU"]], Strand[DNA["GCGCG"]]}, {}]],
		{Strand[DNA["ATCG"],RNA["UUU"]], Strand[DNA["GCGCG"]]}
	],
	Example[{Additional,"Given list of structures:"},
		ToStrand[{Structure[{Strand[DNA["ATCG"],RNA["UUU"]], Strand[DNA["GCGCG"]]}, {}],Structure[{Strand[DNA["ATCG"], DNA["GCGCG"]]}, {}]}],
		{{Strand[DNA["ATCG"], RNA["UUU"]], Strand[DNA["GCGCG"]]},
			{Strand[DNA["ATCG"], DNA["GCGCG"]]}}
	]


]];


(* ::Subsubsection::Closed:: *)
(*ToStructure*)


DefineTests[ToStructure,List[
	Example[{Basic,"Turn sequence into Structure:"},
		ToStructure["ATGATAGATA"],
		Structure[{Strand[DNA["ATGATAGATA"]]},{}]
	],
	Example[{Basic,"Turn Strand into Structure:"},
		ToStructure[Strand[DNA["ATGATAGATA"]]],
		Structure[{Strand[DNA["ATGATAGATA"]]},{}]
	],
	Example[{Basic,"Given list of sequences, creates a single Structure with a single Strand:"},
		ToStructure[{"ATGATA","TGATA","LysHisArg","AUGUCAUG","DabcylDabcyl"}],
		Structure[{Strand[DNA["ATGATA"],DNA["TGATA"],Peptide["LysHisArg"],RNA["AUGUCAUG"],Modification["DabcylDabcyl"]]},{}]
	],
	Example[{Additional,"Given list of strands, creates single Structure with multiple strands:"},
		ToStructure[{Strand[DNA["ATGATAGATA"]],Strand[RNA["AUGUAUCA"]],Strand[Peptide["HisArgHis"]]}],
		Structure[{Strand[DNA["ATGATAGATA"]],Strand[RNA["AUGUAUCA"]],Strand[Peptide["HisArgHis"]]},{}]
	],
	Example[{Additional,"Figures out polymer type when sequence is non-ambiguous:"},
		ToStructure["AUGUCA"],
		Structure[{Strand[RNA["AUGUCA"]]},{}]
	],
	Example[{Options,Map,"Use Map option to create multiple complexes:"},
		ToStructure[{"ATCG","AUUU","LysHisArg"},Map->True],
		{Structure[{Strand[DNA["ATCG"]]},{}],Structure[{Strand[RNA["AUUU"]]},{}],Structure[{Strand[Peptide["LysHisArg"]]},{}]}
	],
	Example[{Options,Polymer,"Modify polymer type:"},
		ToStructure["ACGACGACGACG",Polymer->RNA],
		Structure[{Strand[RNA["ACGACGACGACG"]]}, {}]
	],
	Example[{Options,Motif,"Specify motif:"},
		ToStructure["ATGATAGATA",Motif->"Name"],
		Structure[{Strand[DNA["ATGATAGATA", "Name"]]}, {}]
	],
	Example[{Messages,"InvalidSequence","Given invalid sequence:"},
		ToStructure["ABCDEFGH"],
		Null,
		Messages:>{ToStrand::InvalidSequence}
	],
	Example[{Messages,"InvalidSequence","Given invalid strand:"},
		ToStructure[Strand[DNA["ABCDEFGH"]]],
		Null,
		Messages:>{ToStructure::InvalidStrand}
	],
	Example[{Messages,"InvalidSequence","Given invalid structure:"},
		ToStructure[Structure[{Strand[DNA["ABCDEFGH"]]},{}]],
		Null,
		Messages:>{ToStructure::InvalidStructure}
	]



]];


(* ::Subsubsection::Closed:: *)
(*ToSequence*)


DefineTests[ToSequence,{
	Example[{Basic,"Pull sequences from a Strand:"},
		ToSequence[Strand[DNA["ATATACGCGG"],RNA["AUUUUUUUG"]]],
		{"ATATACGCGG","AUUUUUUUG"}
	],
	Example[{Basic,"Pull sequences from a Structure:"},
		ToSequence[Structure[{Strand[DNA["ATATACGCGG"],RNA["AUUUUUUUG"]],Strand[Peptide["LysHisArg"]]}]],
		{{"ATATACGCGG","AUUUUUUUG"},{"LysHisArg"}}
	],
	Example[{Additional,"Pull sequences from a Structure:"},
		ToSequence[Structure[{Strand[DNA["ATATACGCGG"],RNA["AUUUUUUUG"]]}]],
		{{"ATATACGCGG","AUUUUUUUG"}}
	],
	Example[{Options,Consolidate,"Consolidate adjacent motifs of same type:"},
		ToSequence[Strand[DNA["ATCG","X"],DNA["TTT","Y"],Modification["Tamra","Z"]],Consolidate->True],
		{"ATCGTTT","Tamra"}
	],
	Example[{Additional,"Strands with modifications:"},
		ToSequence[Strand[DNA["ATCG","X"],DNA["TTT","Y"],Modification["Tamra","Z"]]],
		{"ATCG","TTT","Tamra"}
	],
	Example[{Options,Consolidate,"Consolidate adjacent motifs of same type:"},
		ToSequence[{Strand[DNA["ATCG","X"],DNA["TTT","Y"]],Strand[RNA["AUUUU","Z"]]},Consolidate->True],
		{{"ATCGTTT"},{"AUUUU"}}
	],
	Example[{Options,Consolidate,"Do not consolidate adjacent motifs of same type:"},
		ToSequence[{Strand[DNA["ATCG","X"],DNA["TTT","Y"]],Strand[RNA["AUUUU","Z"]]},Consolidate->False],
		{{"ATCG","TTT"},{"AUUUU"}}
	],
	Example[{Options,Consolidate,"Consolidate:"},
		ToSequence[Strand[DNA["ATGCAGATGA","A"],DNA["GTCTG","C"],Peptide["LysArgHis",""],DNA["GGACAG",""],DNA["AGCAGACAG",""]],Consolidate->True],
		{"ATGCAGATGAGTCTG","LysArgHis","GGACAGAGCAGACAG"}
	],
	Example[{Options,Consolidate,"Consolidate:"},
		ToSequence[Strand[DNA["AGAGA","A'"],DNA["TCTCT","A"]],Consolidate->True],
		{"AGAGATCTCT"}
	],
	Example[{Additional,"Strand with PNA:"},
		ToSequence[Strand[DNA["AGAGA","A'"],PNA["TCTCT","A"]]],
		{"AGAGA", "TCTCT"}
	],
	Example[{Options,Consolidate,"Consolidate:"},
		ToSequence[{Strand[PNA["AGAGA","A'"],PNA["TCTCT","A"]],Strand[DNA["AGGA","A'"],PNA["TCTCT","A"]]},Consolidate->True],
		{{"AGAGATCTCT"}, {"AGGA", "TCTCT"}}
	],
	Example[{Options,Output,"Return all bases from motifs involved in Pairing:"},
		ToSequence[Structure[{Strand[DNA["ACGTACGTACGT"]]},{Bond[{1,1,5;;8},{1,1,9;;12}]}]],
		{{"ACGTACGTACGT"}}
	],
	Example[{Options,Output,"Return only bases involved in the Pairing:"},
		ToSequence[Structure[{Strand[DNA["ACGTACGTACGT"]]},{Bond[{1,1,5;;8},{1,1,9;;12}]}],Output->Paired],
		{Strand[DNA["ACGT"]]}
	],
	Example[{Options,Output,"Return only bases involved in the Pairing:"},
		ToSequence[Structure[{Strand[DNA["ATCGTAGCGTA"]],Strand[DNA["ATCGCGCGCTA"]]},{Bond[{1,1,5;;9},{2,1,7;;11}]}],Output->Paired],
		{Strand[DNA["TAGCG"]]}
	],
	Example[{Options,Replace,"If True, replaces motif lengths with character 'N':"},
		ToSequence[Strand[DNA[10],RNA[12]],Replace->True],
		{"NNNNNNNNNN","NNNNNNNNNNNN"}
	],
	Example[{Options,Map,"If True, Map ToSequence over list of inputs:"},
		ToSequence[Strand[PNA["AGAGA","A'"],PNA["TCTCT","A"]],Map->True],
		{"AGAGA","TCTCT"}
	],
	Example[{Messages,"InvalidSequence","Given invalid sequence:"},
		ToSequence["ABCDEFGH"],
		Null,
		Messages:>{ToSequence::InvalidSequence}
	],
	Example[{Messages,"InvalidStrand","Given invalid strand:"},
		ToSequence[Strand[DNA["ABCDEFGH"]]],
		Null,
		Messages:>{ToSequence::InvalidStrand}
	],
	Example[{Messages,"InvalidStructure","Given invalid structure:"},
		ToSequence[Structure[{Strand[DNA["ABCDEFGH"]]},{}]],
		Null,
		Messages:>{ToSequence::InvalidStructure}
	]
}];


(* ::Subsubsection:: *)
(*ToReactionMechanism*)


DefineTests[ToReactionMechanism,{

	Example[{Basic,"Format list of reactions into ReactionMechanism:"},
		ToReactionMechanism[{{a+b->c,1},{c\[Equilibrium]d,2,3}}],
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]]
	],

	Example[{Basic,"Format a list of Reactions as a ReactionMechanism:"},
		ToReactionMechanism[{Reaction[{a}, {b}, 1.1], Reaction[{a, b}, {c}, 1],
			Reaction[{a}, {b, c}, 1.2], Reaction[{a, b}, {c, d}, 2.1],
			Reaction[{a}, {b}, 1.1, 3.1], Reaction[{a, b}, {c}, 1, 3],
			Reaction[{a}, {b, c}, 1.2, 3.2], Reaction[{a, b}, {c, d}, 2.1, 4.4]}],
		ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]
	],

	Example[{Basic,"Format another list of reactions into ReactionMechanism:"},
		ToReactionMechanism[{{a->b,1.1},{a+b->c,1},{a->b+c,1.2},{a+b->c+d,2.1},{a\[Equilibrium]b,1.1,3.1},{a+b\[Equilibrium]c,1,3},{a\[Equilibrium]b+c,1.2,3.2},{a+b\[Equilibrium]c+d,2.1,4.4}}],
		ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]
	]

}];



(* ::Subsubsection::Closed:: *)
(*NameMotifs*)


DefineTests[
	NameMotifs,
	{
	Test[
		"Tests that the function can handle a string of DNA:",
		NameMotifs[DNA[20]],
		DNA[20,_String]
	],
	Test[
		"Tests that the function can handle a list of different types of strands:",
		NameMotifs[Strand[RNA["AUGUAUG"],DNA["ATGATGAC"],Peptide["LysHisArg"],Modification["Dabcyl"]]],
		Strand[RNA["AUGUAUG",_String],DNA["ATGATGAC",_String],Peptide["LysHisArg",_String],Modification["Dabcyl",_String]]
	],
	Test[
		"Tests that the function can handle wrapping with other functions and options:",
		NameMotifs[Structure[{Strand[DNA["ATCGATCG","Name"],DNA[3],RNA["AUUUU"]]},{}]],
		Structure[{Strand[DNA["ATCGATCG","Name"], DNA[3,_String],RNA["AUUUU",_String]]},{}]
	],
	Test[
		"Tests that the function can handle different tyeps of inputs and wrapping II:",
		NameMotifs[Structure[{Strand[DNA[20,"A"],DNA["ATCGATCGAT","B"],DNA[20,"C"]], Strand[DNA[20],DNA[20,"C"],DNA["ATCGATCGAT","B"]]},{Bond[{1,2,1;;10},{2,3,1;;10}],Bond[{1,3},{2,2}]}]],
		Structure[{Strand[DNA[20,"A"],DNA["ATCGATCGAT","B"],DNA[20,"C"]],Strand[DNA[20,_String],DNA[20,"C"],DNA["ATCGATCGAT","B"]]},{Bond[{1,2,1;;10},{2,3,1;;10}],Bond[{1,3},{2,2}]}]
	],
	Test[
		"Tests that the function can different types of input:",
		NameMotifs[Strand[DNA["ATGATATA","A"],DNA["TATATCAT","A"]]],
		Strand[DNA["ATGATATA","A"],DNA["TATATCAT","A"]]
	],
	Example[
		{Basic, "Given a strand of generic DNA, the function will return a string tag for the DNA:"},
		NameMotifs[DNA[20]],
		DNA[20,_String]
	],
	Example[
		{Basic, "Given a list of different types of strands, the function will return a string tag for each one:"},
		NameMotifs[Strand[RNA["AUGUAUG"],DNA["ATGATGAC"],Peptide["LysHisArg"],Modification["Dabcyl"]]],
		Strand[RNA["AUGUAUG",_String],DNA["ATGATGAC",_String],Peptide["LysHisArg",_String],Modification["Dabcyl",_String]]
	],
	Example[
		{Basic, "Given a list of different types of strands and specified names, the function will return those names associated with those strands:"},
		NameMotifs[Structure[{Strand[DNA["ATCGATCG","Name"],DNA[3],RNA["AUUUU"]]},{}]],
		Structure[{Strand[DNA["ATCGATCG","Name"], DNA[3,_String],RNA["AUUUU",_String]]},{}]
	],
	Example[
		{Attributes, Listable, "Given a list of different types of strands, the function will evaluate on each one independently:"},
		NameMotifs[Strand[DNA["ATGATATA","A"],DNA["TATATCAT","A"]]],
		Strand[DNA["ATGATATA","A"],DNA["TATATCAT","A"]]
	]
	}
];


(* ::Subsection::Closed:: *)
(*State / Rules / Paired*)


(* ::Subsubsection::Closed:: *)
(*ToState*)


DefineTests[ToState,{

	Example[{Basic,"Transform list of rules to state:"},
		ToState[{Structure[{Strand[DNA[5]]}]->Micromolar,Structure[{Strand[DNA[5]]}]->2*Micromolar}],
		State[{Structure[{Strand[DNA[5]]}], Micromolar},{Structure[{Strand[DNA[5]]}], 2*Micromolar}]
	],

	Example[{Basic,"Generate state without concentrations:"},
		ToState[{Structure[{Strand[DNA[5]]}],Structure[{Strand[DNA[5]]}]}],
		State[{Structure[{Strand[DNA[5]]}]},{Structure[{Strand[DNA[5]]}]}]
	],

	Example[{Basic,"Given species as symbols:"},
		ToState[{x->Micro Molar,y->2Micro Molar}],
		State[List[x,1*Micromolar],List[y,2*Micromolar]]
	],

	Example[{Additional,"Given species as sequences:"},
		ToState[{"ATCG"->Micro Molar,"GGCCC"->2Micro Molar}],
		State[List[Structure[List[Strand[DNA["ATCG"]]],List[]],1*Micromolar],List[Structure[List[Strand[DNA["GGCCC"]]],List[]],2*Micromolar]]
	],

	Example[{Additional,"Given species as motifs:"},
		ToState[{DNA["ATCG"]->Micro Molar,RNA["GGCCC"]->2Micro Molar}],
		State[List[Structure[List[Strand[DNA["ATCG"]]],List[]],1*Micromolar],List[Structure[List[Strand[RNA["GGCCC"]]],List[]],2*Micromolar]]
	],

	Example[{Additional,"Given species as strands:"},
		ToState[{Strand[DNA["ATCG"]]->Micro Molar,Strand[RNA["GGCCC"]]->2Micro Molar}],
		State[List[Structure[List[Strand[DNA["ATCG"]]],List[]],1*Micromolar],List[Structure[List[Strand[RNA["GGCCC"]]],List[]],2*Micromolar]]
	],

	Example[{Additional,"Add unit to a state:"},
		ToState[{Structure[{Strand[DNA[5]]}]->1,Structure[{Strand[DNA[5]]}]->2},Micromolar],
		State[{Structure[{Strand[DNA[5]]}], Micromolar},{Structure[{Strand[DNA[5]]}], 2*Micromolar}]
	]

}];


(* ::Subsection::Closed:: *)
(*Reaction / reaction*)


(* ::Subsubsection::Closed:: *)
(*toReaction*)


DefineTests[
	toReaction,
	{
		Example[{Basic,"Single irreversible first order reaction."},
			toReaction[{a->b,1.1}],
			Reaction[{a},{b},1.1`]
		],
		Example[{Basic,"Single reversible first order reaction."},
			toReaction[{a\[Equilibrium]b,2,3}],
			Reaction[{a},{b},2,3]
		],
		Example[{Basic,"Single reversible second order reaction."},
			toReaction[{a+b->c,2}],
			Reaction[{a,b},{c},2]
		],
		Example[{Basic,"Single reversible second order reaction."},
			toReaction[{a+b\[Equilibrium]c,2,3}],
			Reaction[{a,b},{c},2,3]
		],
		Example[{Attributes,"listable","List of reactions."},
			toReaction@{{a->b,1.1},{a+b->c,1},{a->b+c,1.2},{a+b->c+d,2.1},{a\[Equilibrium]b,1.1,3.1},{a+b\[Equilibrium]c,1,3},{a\[Equilibrium]b+c,1.2,3.2},{a+b\[Equilibrium]c+d,2.1,4.4}},
			{Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]}
		]
	},
	Variables:>{a,b,c,d}
];


(* ::Subsection:: *)
(*Structure*)


(* ::Subsubsection:: *)
(*sortAndReformatStructures*)


DefineTests[
	sortAndReformatStructures,
	{
		Example[{Basic,"Sorts the strands and bonds into canonical:"},
			sortAndReformatStructures[Structure[{Strand[DNA["TTTTT"]], Strand[DNA["AAAA"]]},{}]],
			Structure[{Strand[DNA["AAAA"]], Strand[DNA["TTTTT"]]}, {}]
		],
		Example[{Basic,"Reformat the bonds to motif basepair form:"},
			sortAndReformatStructures[Structure[{Strand[DNA["CCCCC"]],
				Strand[DNA["GGGGG"]]}, {Bond[{1, 1}, {2, 1}]}]],
			Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]
		],
		Example[{Basic,"Sort and reformat all structures in the expression:"},
			sortAndReformatStructures[{
				Structure[{Strand[DNA["TTTTT"]], Strand[DNA["AAAA"]]},{}],
				123,
				{"ABC",Structure[{Strand[DNA["CCCCC"]],
					Strand[DNA["GGGGG"]]}, {Bond[{1, 1}, {2, 1}]}]}
			}],
			{Structure[{Strand[DNA["AAAA"]], Strand[DNA["TTTTT"]]}, {}], 123, {"ABC", Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]}}
		]
	}
];


(* ::Subsection:: *)
(*Trajectory*)


(* ::Subsubsection:: *)
(*TrajectoryRegression*)


DefineTests[
	TrajectoryRegression,
	{
		Test["Extract concentrations of all species at single time:",
			TrajectoryRegression[sim1,0],
			{1.`,0.`,0.`}
		],
		Example[{Basic,"Extract concentrations at single time:"},
			TrajectoryRegression[sim1,30],
			{5.873607434229581`*^-8,1.310424218815479`*^-8,0.9999999281596837`},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Additional,"Specify time with Units:"},
			TrajectoryRegression[sim1,30Second],
			{5.873607434229581`*^-8,1.310424218815479`*^-8,0.9999999281596837`},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Additional,"Use End to extract concentrations at last time point:"},
			TrajectoryRegression[sim1,End],
			 {-3.943497072828197`*^-12,-8.86293180735748`*^-13,1.00000000000483`},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Attributes,"listable","List of times:"},
			TrajectoryRegression[sim1,{10,20}],
			{{0.003692798636398065`,0.0008299390970285466`,0.9954772622665737`},{0.000015016456045883474`,3.3847034304811002`*^-6,0.9999815988405242`}},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Basic,"Extract concentration of one species at all times:"},
			TrajectoryRegression[sim1,a],
			{1.`,0.9999945228671578`,0.9999890458243107`,0.9987270033127895`,0.9974697270576233`,0.9962171870425214`,0.990717818710747`,0.985308472910488`,0.9799866963950802`,0.9747500852109484`,0.9625303741178373`,0.9507562358759634`,0.939399306934572`,0.9284331542164221`,0.9178332058794278`,0.8921936973464055`,0.8684735616183151`,0.8463903059937226`,0.8257094056509315`,0.8062355646470345`,0.7878059780143845`,0.7632569195409862`,0.7402196099362471`,0.7184530386816216`,0.6977694691681717`,0.6780220054924938`,0.6590952475223859`,0.6352523890672439`,0.6125172418457672`,0.5907689127053273`,0.5699150111524084`,0.5498833695257968`,0.5306165725170063`,0.5094238432481608`,0.48911498494107924`,0.46964102756625664`,0.4509593215141822`,0.4330319873084936`,0.4120186035028595`,0.3920318634620277`,0.37301878415608936`,0.3549304343860769`,0.3381933391365165`,0.3222464328245947`,0.3070520483877997`,0.2925744601508731`,0.279278556559414`,0.26658700881224`,0.25447229728620585`,0.24290817456157113`,0.2178188612292416`,0.19532097062543502`,0.17514683230080527`,0.15705648094413086`,0.13440179265798913`,0.11501463448663082`,0.09842490442425963`,0.08422806458607497`,0.08101120877279529`,0.07791724456785802`,0.07494141754572087`,0.07207923385831254`,0.06932636693730612`,0.06596264283077888`,0.0627621257269119`,0.059716899070313974`,0.05681942655089964`,0.053926044344764786`,0.05117999926729772`,0.04857378931914375`,0.04610029365659531`,0.03980764950802676`,0.0343737617962802`,0.02968175725334593`,0.025630196892594468`,0.022131664695599438`,0.017750895636001643`,0.016798574326875985`,0.015897311250994303`,0.015044420620317207`,0.014237288259851849`,0.013473448135209721`,0.01275059813667406`,0.012225057322643514`,0.011721173444408919`,0.011238060145387967`,0.010774859891147036`,0.010330750645842126`,0.009775365554731186`,0.00924983991640434`,0.008752566261824074`,0.00828202606461547`,0.007762823293979681`,0.007276169281319753`,0.006820023713441492`,0.006392474083216819`,0.005431842381133564`,0.004615531367540451`,0.00392192962140166`,0.003332556531840225`,0.0028317520021016963`,0.0022231029256184866`,0.0017453267903757197`,0.0016428612136658075`,0.0015464249379580099`,0.001455642838063581`,0.0013701893428655961`,0.001289756575495292`,0.001214042363624778`,0.0011601082954513131`,0.0011085721070784524`,0.0010593247157542837`,0.0010122647661689379`,0.0009672958261854631`,0.000915074503117627`,0.0008656723756008349`,0.0008189374485731162`,0.0007747256391394354`,0.0007309684445594994`,0.0006896827512144276`,0.0006507289459882186`,0.0005741510199141174`,0.0005065617775928658`,0.00044692844980442176`,0.0003943159718725214`,0.00032644730206681226`,0.0002702581417956849`,0.00022374571425603783`,0.00018523737658154195`,0.00015335708846146283`,0.0001198155118718779`,0.00009360952883037862`,0.0000731293476250391`,0.00006875317351364372`,0.00006464309614045599`,0.000060776171484857166`,0.000057139020197081634`,0.0000537212952014948`,0.000050849107068267555`,0.000048129711360930095`,0.00004555603814843587`,0.000043120125833576334`,0.000040715123927605786`,0.000038444239358664155`,0.00003630003293361639`,0.000029145026774888834`,0.000023396195494686534`,0.00001877950313687673`,0.000015073298119996725`,0.00001337464230840994`,0.000011869425563176596`,0.000010533685480926255`,9.9018338531624`*^-6,9.307367739663821`*^-6,8.748717542163206`*^-6,8.218300782634771`*^-6,7.720093279298242`*^-6,7.252088781804946`*^-6,6.002484978139659`*^-6,4.968408276934229`*^-6,4.112568266741055`*^-6,2.8450440386704233`*^-6,1.9646589219934625`*^-6,1.7900181174761056`*^-6,1.6301220603927423`*^-6,1.4849022614300446`*^-6,1.3537107214723878`*^-6,1.2786202472950673`*^-6,1.2074649990899626`*^-6,1.140300271675127`*^-6,1.076916531563167`*^-6,1.0170733970268593`*^-6,9.605575323763239`*^-7,8.766442148353806`*^-7,8.000669720789782`*^-7,7.301816219081053`*^-7,4.277934588156156`*^-7,2.568114301165692`*^-7,2.264551956509313`*^-7,1.9711339912078398`*^-7,1.501179708701967`*^-7,1.144240246533165`*^-7,8.728701228723755`*^-8,4.595814479144415`*^-8,2.3229103256502705`*^-8,1.1287333469836352`*^-8,2.205487936074371`*^-9,-5.138343486781561`*^-10,-8.868015078852145`*^-10,-2.440171723684776`*^-10,-6.71462320838218`*^-11,-4.6942886816338905`*^-11,-1.9655644776697785`*^-11,-3.943497072828197`*^-12},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Basic,"Extract concentration of one species at one time:"},
			TrajectoryRegression[sim1,a,End],
			NumericP,
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Attributes,"listable","List of species, single time point:"},
			TrajectoryRegression[sim1,{a,b},End],
			{-3.943497072828197`*^-12,-8.86293180735748`*^-13},
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Attributes,"listable","List of species, list of time points:"},
			TrajectoryRegression[sim1,{a,b},{10,20}],
			{{0.003692798636398065`,0.0008299390970285466`},{0.000015016456045883474`,3.3847034304811002`*^-6}},
			EquivalenceFunction->RoundMatchQ[6]
		],

		Example[{Options,Output,"Return only time points:"},
			TrajectoryRegression[sim1,Output->Time],
			{_?NumberQ..}
		],
		Example[{Options,Output,"Return pairs of time and concentration:"},
			TrajectoryRegression[sim1,Output->{Time,Concentration}],
			{{{_?NumberQ,_?NumberQ}..}..}
		],
		Example[{Additional,"Return pairs of time and concentration:"},
			ListLinePlot[TrajectoryRegression[sim1,Output->{Time,Concentration}]],
			_Graphics
		],
		Test["Return pairs of time and concentration:",
			TrajectoryRegression[sim1,b,Output->{Time,Concentration}],
			{{_?NumberQ,_?NumberQ}..}
		],
		Test["Return pairs of time and concentration:",
			TrajectoryRegression[sim1,{b,c},Output->{Time,Concentration}],
			{{{_?NumberQ,_?NumberQ}..}..}
		],
		Test["Return pairs of time and concentration:",
			ListLinePlot[TrajectoryRegression[sim1,b,Output->{Time,Concentration}]],
			_Graphics
		],
		Test["Return only time points:",
			TrajectoryRegression[sim1,End,Output->{Time}],
			{{_?NumberQ}..}
		],
		Test["Specify time and species and return both:",
			TrajectoryRegression[sim1,{a,b,c},Range[20],Output->{Time,Concentration}],
			{{{_?NumberQ,_?NumberQ}..}..}
		],
		Test["Specify time and species and return both:",
			TrajectoryRegression[sim1,a,Range[20],Output->{Time,Concentration}],
			{{_?NumberQ,_?NumberQ}..}
		]

	},
	Variables:>{a,b,c,d,t,sim1},
	SetUp:>(sim1=Trajectory[{a, b, c}, {{1., 0., 0.}, {0.9999945228671578, 5.477042845230003*^-6, 8.999695240744103*^-11}, {0.9999890458243107, 0.0000109539057014842, 2.6998789979223815*^-10}, {0.9987270033127895, 0.0012705657433097213, 2.430943900860951*^-6}, {0.9974697270576233, 0.002520651151253266, 9.621791123534113*^-6}, {0.9962171870425214, 0.003761276158483978, 0.000021536798994713848}, {0.990717818710747, 0.009151719180542413, 0.00013046210871062234}, {0.985308472910488, 0.014362984350347566, 0.0003285427391646349}, {0.9799866963950802, 0.019400465082111268, 0.0006128385228086923}, {0.9747500852109484, 0.024269444711295735, 0.000980470077755947}, {0.9625303741178373, 0.03528508889743763, 0.002184536984725175}, {0.9507562358759634, 0.045428686104364825, 0.0038150780196719316}, {0.939399306934572, 0.05476245881559088, 0.005838234249837263}, {0.9284331542164221, 0.06334434105264294, 0.008222504730935087}, {0.9178332058794278, 0.07122813254156722, 0.010938661579005114}, {0.8921936973464055, 0.08857801037883052, 0.019228292274764115}, {0.8684735616183151, 0.10240329422519337, 0.029123144156491653}, {0.8463903059937226, 0.11331845511492453, 0.040291238891353075}, {0.8257094056509315, 0.12183151095847872, 0.05245908339058995}, {0.8062355646470345, 0.1283634634717588, 0.06540097188120692}, {0.7878059780143845, 0.13326328346405608, 0.07893073852155971}, {0.7632569195409862, 0.13795881896402462, 0.09878426149498938}, {0.7402196099362471, 0.14061245829448124, 0.11916793176927179}, {0.7184530386816216, 0.14172541249785414, 0.13982154882052442}, {0.6977694691681717, 0.1416812975559058, 0.16054923327592258}, {0.6780220054924938, 0.14077377059298884, 0.18120422391451743}, {0.6590952475223859, 0.13922729611350432, 0.20167745636410978}, {0.6352523890672439, 0.136496958339728, 0.22825065259302818}, {0.6125172418457672, 0.13323978438528597, 0.2542429737689469}, {0.5907689127053273, 0.12965742306635936, 0.2795736642283135}, {0.5699150111524084, 0.12589045022345136, 0.30419453862414036}, {0.5498833695257968, 0.12203670801193976, 0.3280799224622636}, {0.5306165725170063, 0.1181633969172245, 0.3512200305657692}, {0.5094238432481608, 0.11376044938898787, 0.37681570736285136}, {0.48911498494107924, 0.10943750114285515, 0.4014475139160657}, {0.46964102756625664, 0.10522226674944336, 0.42513670568430006}, {0.4509593215141822, 0.1011316218894509, 0.44790905659636693}, {0.4330319873084936, 0.09717492632073743, 0.469793086370769}, {0.4120186035028595, 0.09250915243219991, 0.49547224406494067}, {0.3920318634620277, 0.0880520158375123, 0.5199161207004601}, {0.37301878415608936, 0.08380045465618996, 0.5431807611877207}, {0.3549304343860769, 0.07974835089712297, 0.5653212147168002}, {0.3381933391365165, 0.0759945741113858, 0.5858120867520977}, {0.3222464328245947, 0.07241541092231847, 0.605338156253087}, {0.3070520483877997, 0.06900354096646819, 0.6239444106457321}, {0.2925744601508731, 0.06575162322871604, 0.641673916620411}, {0.279278556559414, 0.06276454365702497, 0.6579568997835611}, {0.26658700881224, 0.059912879275604264, 0.6735001119121559}, {0.25447229728620585, 0.05719059828032732, 0.688337104433467}, {0.24290817456157113, 0.05459189705704923, 0.7024999283813798}, {0.2178188612292416, 0.04895352345170433, 0.7332276153190542}, {0.19532097062543502, 0.04389742854092371, 0.7607816008336414}, {0.17514683230080527, 0.03936346742662975, 0.7854897002725652}, {0.15705648094413086, 0.0352976752891767, 0.8076458437666926}, {0.13440179265798913, 0.03020604951705268, 0.8353921578249583}, {0.11501463448663082, 0.025849158380841154, 0.8591362071325283}, {0.09842490442425963, 0.022121025316965776, 0.8794540702587749}, {0.08422806458607497, 0.01893023106928428, 0.896841704344641}, {0.08101120877279529, 0.018207227980736602, 0.9007815632464685}, {0.07791724456785802, 0.017511722462427475, 0.9045710329697149}, {0.07494141754572087, 0.016842853318130985, 0.9082157291361485}, {0.07207923385831254, 0.016199554086244072, 0.9117212120554437}, {0.06932636693730612, 0.015580817421794466, 0.9150928156408996}, {0.06596264283077888, 0.014824807612891469, 0.9192125495563298}, {0.0627621257269119, 0.014105497736667014, 0.9231323765364212}, {0.059716899070313974, 0.013421087012052304, 0.9268620139176339}, {0.05681942655089964, 0.012769885929159685, 0.9304106875199408}, {0.053926044344764786, 0.012119608797541473, 0.933954346857694}, {0.05117999926729772, 0.011502446758071497, 0.937317553974631}, {0.04857378931914375, 0.010916712544898054, 0.9405094981359584}, {0.04610029365659531, 0.01036080600780021, 0.9435389003356047}, {0.03980764950802676, 0.008946565808295375, 0.951245784683678}, {0.0343737617962802, 0.007725324114883669, 0.9579009140888363}, {0.02968175725334593, 0.006670814936097017, 0.9636474278105571}, {0.025630196892594468, 0.005760253293183566, 0.968609549814222}, {0.022131664695599438, 0.0049739891135450855, 0.9728943461908555}, {0.017750895636001643, 0.00398939142512633, 0.978259712938872}, {0.016798574326875985, 0.00377534779903088, 0.9794260778740932}, {0.015897311250994303, 0.0035728280027096213, 0.9805298607462962}, {0.015044420620317207, 0.00338114568715807, 0.981574433692525}, {0.014237288259851849, 0.003199740798265873, 0.9825629709418825}, {0.013473448135209721, 0.003028092253832525, 0.9834984596109579}, {0.01275059813667406, 0.002865630471656011, 0.9843837713916701}, {0.012225057322643514, 0.0027475124369795516, 0.9850274302403771}, {0.011721173444408919, 0.0026342724955238602, 0.9856445540600675}, {0.011238060145387967, 0.0025256956747228914, 0.9862362441798894}, {0.010774859891147036, 0.0024215929660517665, 0.9868035471428015}, {0.010330750645842126, 0.0023217828007735717, 0.9873474665533846}, {0.009775365554731186, 0.0021969632474564066, 0.9880276711978127}, {0.00924983991640434, 0.00207885331266229, 0.9886713067709336}, {0.008752566261824074, 0.0019670938028037268, 0.9892803399353725}, {0.00828202606461547, 0.0018613427097707253, 0.989856631225614}, {0.007762823293979681, 0.0017446545893613251, 0.9904925221166592}, {0.007276169281319753, 0.0016352815621221318, 0.9910885491565583}, {0.006820023713441492, 0.0015327652839265866, 0.9916472110026322}, {0.006392474083216819, 0.0014366757567206901, 0.9921708501600628}, {0.005431842381133564, 0.0012207784088500123, 0.9933473792100168}, {0.004615531367540451, 0.0010373164854750477, 0.9943471521469849}, {0.00392192962140166, 0.0008814344175877646, 0.9951966359610109}, {0.003332556531840225, 0.0007489771140860539, 0.9959184663540741}, {0.0028317520021016963, 0.0006364210803500168, 0.9965318269175486}, {0.0022231029256184866, 0.0004996210418611537, 0.9972772760325207}, {0.0017453267903757197, 0.00039225550517649297, 0.9978624177044481}, {0.0016428612136658075, 0.00036923363815327155, 0.9979879051481811}, {0.0015464249379580099, 0.00034755145193503083, 0.9981060236101073}, {0.001455642838063581, 0.00032714917272122105, 0.9982172079892155}, {0.0013701893428655961, 0.0003079477687963901, 0.9983218628883384}, {0.001289756575495292, 0.0002898640994168282, 0.9984203793250882}, {0.001214042363624778, 0.00027284896004365234, 0.9985131086763318}, {0.0011601082954513131, 0.0002607304208534789, 0.9985791612836955}, {0.0011085721070784524, 0.0002491459993175011, 0.9986422818936044}, {0.0010593247157542837, 0.00023807767378646171, 0.9987025976104597}, {0.0010122647661689379, 0.0002275017991776592, 0.9987602334346538}, {0.0009672958261854631, 0.00021739484493480922, 0.9988153093288802}, {0.000915074503117627, 0.0002056581941339229, 0.9988792673027489}, {0.0008656723756008349, 0.0001945556428762978, 0.9989397719815233}, {0.0008189374485731162, 0.0001840521760697784, 0.9989970103753576}, {0.0007747256391394354, 0.0001741156565268612, 0.9990511587043343}, {0.0007309684445594994, 0.00016428143402063113, 0.9991047501214205}, {0.0006896827512144276, 0.00015500269169475055, 0.9991553145570915}, {0.0006507289459882186, 0.00014624801361636937, 0.9992030230403961}, {0.0005741510199141174, 0.0001290374946271664, 0.9992968114854593}, {0.0005065617775928658, 0.000113847189738618, 0.9993795910326692}, {0.00044692844980442176, 0.0001004449337280344, 0.9994526266164682}, {0.0003943159718725214, 0.00008862050591226803, 0.9995170635222158}, {0.00032644730206681226, 0.0000733672586520302, 0.9996001854392818}, {0.0002702581417956849, 0.00006073920700756771, 0.9996690026511973}, {0.00022374571425603783, 0.000050286377887048793, 0.9997259679078575}, {0.00018523737658154195, 0.000041631875757279224, 0.9997731307476618}, {0.00015335708846146283, 0.000034465271589607455, 0.9998121776399496}, {0.0001198155118718779, 0.000026923902040109243, 0.9998532605860887}, {0.00009360952883037862, 0.00002103646683236982, 0.9998853540043379}, {0.0000731293476250391, 0.00001645013715967064, 0.9999104205152158}, {0.00006875317351364372, 0.000015467640186365517, 0.9999157791863005}, {0.00006464309614045599, 0.00001453357882691388, 0.9999208233250331}, {0.000060776171484857166, 0.000013661793415717024, 0.9999255620351}, {0.000057139020197081634, 0.000012845714571963454, 0.9999300152652314}, {0.0000537212952014948, 0.00001207446343768467, 0.9999342042413613}, {0.000050849107068267555, 0.00001142770308638648, 0.9999377231898458}, {0.000048129711360930095, 0.000010817310959882762, 0.9999410529776797}, {0.00004555603814843587, 0.000010238876327871846, 0.9999442050855242}, {0.000043120125833576334, 9.691067321495247*^-6, 0.9999471888068454}, {0.000040715123927605786, 9.150530002765903*^-6, 0.9999501343460702}, {0.000038444239358664155, 8.640195691252211*^-6, 0.9999529155649506}, {0.00003630003293361639, 8.15828369148192*^-6, 0.9999555416833754}, {0.000029145026774888834, 6.550292873443049*^-6, 0.9999643046803521}, {0.000023396195494686534, 5.2598631352306005*^-6, 0.9999713439413705}, {0.00001877950313687673, 4.226092203574198*^-6, 0.99997699440466}, {0.000015073298119996725, 3.397471816616656*^-6, 0.9999815292300639}, {0.00001337464230840994, 3.01421104699681*^-6, 0.9999836111466451}, {0.000011869425563176596, 2.670051915987509*^-6, 0.9999854605225214}, {0.000010533685480926255, 2.3650836807257583*^-6, 0.9999871012308389}, {9.9018338531624*^-6, 2.22301840047732*^-6, 0.9999878751477469}, {9.307367739663821*^-6, 2.0905916335078424*^-6, 0.9999886020406275}, {8.748717542163206*^-6, 1.9657701534875834*^-6, 0.9999892855123049}, {8.218300782634771*^-6, 1.8467847190914357*^-6, 0.999989934914499}, {7.720093279298242*^-6, 1.734887547645945*^-6, 0.9999905450191737}, {7.252088781804946*^-6, 1.6297684615974362*^-6, 0.9999911181427572}, {6.002484978139659*^-6, 1.349085617265592*^-6, 0.9999926484294052}, {4.968408276934229*^-6, 1.1167792526630925*^-6, 0.999993914812471}, {4.112568266741055*^-6, 9.244447436034516*^-7, 0.9999949629869902}, {2.8450440386704233*^-6, 6.390737350495472*^-7, 0.9999965158822268}, {1.9646589219934625*^-6, 4.3706012646634056*^-7, 0.9999975982809521}, {1.7900181174761056*^-6, 3.977371723881444*^-7, 0.9999978122447107}, {1.6301220603927423*^-6, 3.652775704283638*^-7, 0.9999980046003697}, {1.4849022614300446*^-6, 3.343931916227199*^-7, 0.9999981807045475}, {1.3537107214723878*^-6, 3.0367726050472485*^-7, 0.9999983426120186}, {1.2786202472950673*^-6, 2.8657289047222405*^-7, 0.9999984348068628}, {1.2074649990899626*^-6, 2.7094389832111545*^-7, 0.9999985215911031}, {1.140300271675127*^-6, 2.5609872017155073*^-7, 0.9999986036010087}, {1.076916531563167*^-6, 2.419366616953378*^-7, 0.9999986811468072}, {1.0170733970268593*^-6, 2.2851899757648088*^-7, 0.9999987544076059}, {9.605575323763239*^-7, 2.1584135305312394*^-7, 0.999998823601115}, {8.766442148353806*^-7, 1.9700702775398866*^-7, 0.9999989263487579}, {8.000669720789782*^-7, 1.7980553629959177*^-7, 0.999999020127492}, {7.301816219081053*^-7, 1.641004006535343*^-7, 0.9999991057179778}, {4.277934588156156*^-7, 9.58373928702592*^-8, 0.9999994763691487}, {2.568114301165692*^-7, 5.044513047902516*^-8, 0.9999996927434397}, {2.264551956509313*^-7, 4.3111097788146425*^-8, 0.9999997304337068}, {1.9711339912078398*^-7, 4.086215432350774*^-8, 0.9999997620244468}, {1.501179708701967*^-7, 3.304427395913269*^-8, 0.9999998168377555}, {1.144240246533165*^-7, 2.5796854574101196*^-8, 0.9999998597791211}, {8.728701228723755*^-8, 1.9741102711009386*^-8, 0.9999998929718853}, {4.595814479144415*^-8, 1.0427985729027213*^-8, 0.9999999436138698}, {2.3229103256502705*^-8, 5.239456872579397*^-9, 0.9999999715314403}, {1.1287333469836352*^-8, 2.5351273993987184*^-9, 0.9999999861775395}, {2.205487936074371*^-9, 4.926683425278232*^-10, 0.9999999973018441}, {-5.138343486781561*^-10, -1.1597884245478177*^-10, 1.0000000006298135}, {-8.868015078852145*^-10, -1.9925544531347164*^-10, 1.0000000010860572}, {-2.440171723684776*^-10, -5.483981027670181*^-11, 1.0000000002988572}, {-6.71462320838218*^-11, -1.5090704607870206*^-11, 1.000000000082237}, {-4.6942886816338905*^-11, -1.0549655880611549*^-11, 1.0000000000574927}, {-1.9655644776697785*^-11, -4.417286972647278*^-12, 1.000000000024073}, {-3.943497072828197*^-12, -8.86293180735748*^-13, 1.00000000000483}}, {0., 5.477222839627767*^-6, 0.000010954445679255534, 0.0012754291681976698, 0.002539903890716084, 0.0038043786132344985, 0.009413050576528352, 0.015021722539822206, 0.02063039450311606, 0.026239066466409913, 0.039683622864353854, 0.053128179262297806, 0.06657273566024174, 0.0800172920581857, 0.09346184845612963, 0.12790539568380582, 0.16234894291148202, 0.19679249013915823, 0.23123603736683443, 0.26567958459451063, 0.3001231318221868, 0.3488529094145724, 0.39758268700695804, 0.4463124645993437, 0.4950422421917293, 0.5437720197841149, 0.5925017973765005, 0.6567266816518368, 0.720951565927173, 0.7851764502025091, 0.8494013344778454, 0.9136262187531816, 0.9778511030285177, 1.0514292111236239, 1.1250073192187298, 1.1985854273138359, 1.272163535408942, 1.345741643504048, 1.436010551945137, 1.526279460386226, 1.616548368827315, 1.706817277268404, 1.7945468751164402, 1.8822764729644763, 1.9700060708125124, 2.0577356686605484, 2.142217797425532, 2.226699926190515, 2.311182054955498, 2.3956641837204815, 2.5937079265299166, 2.791751669339352, 2.9897954121487875, 3.1878391549582226, 3.4707832399903613, 3.7537273250224996, 4.036671410054638, 4.319615495086777, 4.390351516344811, 4.461087537602846, 4.53182355886088, 4.602559580118915, 4.6732956013769495, 4.763642832000247, 4.853990062623545, 4.944337293246842, 5.03468452387014, 5.129623849221191, 5.224563174572243, 5.319502499923294, 5.414441825274345, 5.681030466934603, 5.9476191085948615, 6.214207750255119, 6.480796391915377, 6.747385033575636, 7.148052696063827, 7.248219611685874, 7.348386527307922, 7.44855344292997, 7.548720358552018, 7.648887274174065, 7.749054189796113, 7.825511694814173, 7.901969199832234, 7.9784267048502935, 8.054884209868353, 8.131341714886414, 8.231720743259903, 8.332099771633393, 8.432478800006884, 8.532857828380372, 8.650462007057097, 8.768066185733822, 8.885670364410547, 9.003274543087272, 9.299075466365359, 9.594876389643446, 9.890677312921532, 10.18647823619962, 10.482279159477708, 10.921853360613447, 11.361427561749187, 11.471321112033122, 11.581214662317057, 11.691108212600993, 11.801001762884928, 11.910895313168862, 12.020788863452797, 12.1033327080057, 12.185876552558604, 12.268420397111505, 12.350964241664409, 12.433508086217312, 12.534322230039196, 12.63513637386108, 12.735950517682966, 12.83676466150485, 12.942343687999335, 13.047922714493819, 13.153501740988304, 13.381029012749805, 13.608556284511304, 13.836083556272804, 14.063610828034303, 14.406686797409423, 14.74976276678454, 15.09283873615966, 15.435914705534778, 15.778990674909897, 16.22730011478689, 16.67560955466388, 17.123918994540873, 17.235996354510117, 17.348073714479366, 17.460151074448614, 17.572228434417863, 17.68430579438711, 17.78413469075192, 17.883963587116728, 17.983792483481537, 18.083621379846345, 18.18784241303395, 18.292063446221558, 18.396284479409168, 18.795500139343424, 19.194715799277684, 19.59393145921194, 19.9931471191462, 20.21008536016919, 20.427023601192186, 20.64396184221518, 20.7563101179538, 20.868658393692414, 20.98100666943103, 21.09456285176967, 21.208119034108307, 21.32167521644695, 21.664207704821415, 22.006740193195885, 22.349272681570355, 23.02395566259732, 23.69863864362429, 23.86730938888103, 24.03598013413777, 24.204650879394514, 24.373321624651254, 24.47710752945931, 24.580893434267367, 24.684679339075426, 24.78848590066272, 24.892292462250015, 24.99609902383731, 25.16201775161099, 25.32793647938467, 25.49385520715835, 26.450183532401375, 27.406511857644404, 27.64559393895516, 27.884676020265918, 28.362840182887428, 28.841004345508942, 29.319168508130456, 30.372417845966392, 31.425667183802332, 32.47891652163827, 34.117715969233394, 35.75651541682852, 37.39531486442364, 42.18015994815272, 46.9650050318818, 52.9650050318818, 56.4825025159409, 60.}, {Quantity[1, "Seconds"], Quantity[1, "Molar"]}])
];


(* ::Subsubsection::Closed:: *)
(*ToTrajectory*)


DefineTests[ToTrajectory,{

	Example[{Basic,"Format list of concentrations as Trajectory:"},
		ToTrajectory[{"X","Y","Z"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}],
		Trajectory[{"X","Y","Z"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}]
	],

	Example[{Basic,"Parse interpolating function to create Trajectory:"},
		ToTrajectory[{"X","Y"},First[x/.NDSolve[{IdentityMatrix[2].x'[t]+IdentityMatrix[2].x[t]=={{0},{0}},x[0]=={{1},{2}}},x,{t,0,10}]],{Second,Molar}],
		TrajectoryP
	],

	Example[{Basic,"Plot result:"},
		PlotTrajectory[ToTrajectory[{"x","y","z"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}]],
		_?ValidGraphicsQ
	],

	Example[{Additional,"Assumes Units of {Second,Molar}:"},
		ToTrajectory[{"X","Y","Z"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5}],
		Trajectory[{"X","Y","Z"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}]
	],

	Example[{Additional,"Names species using alphabet:"},
		ToTrajectory[{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}],
		Trajectory[{"A","B","C"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}]
	],

	Example[{Additional,"Names species using alphabet and assumes Units of {Second,Molar}:"},
		ToTrajectory[{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5}],
		Trajectory[{"A","B","C"},{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},{Second,Molar}]
	],

	Example[{Additional,"Assumes Units of {Second,Molar}:"},
		ToTrajectory[{"X","Y"},First[x/.NDSolve[{IdentityMatrix[2].x'[t]+IdentityMatrix[2].x[t]=={{0},{0}},x[0]=={{1},{2}}},x,{t,0,10}]]],
		TrajectoryP
	],

	Example[{Additional,"Names species alphabetically:"},
		ToTrajectory[First[x/.NDSolve[{IdentityMatrix[2].x'[t]+IdentityMatrix[2].x[t]=={{0},{0}},x[0]=={{1},{2}}},x,{t,0,10}]],{Second,Molar}],
		TrajectoryP
	],

	Example[{Additional,"Names species alphabetically and assumes Units of {Second,Molar}:"},
		ToTrajectory[First[x/.NDSolve[{IdentityMatrix[2].x'[t]+IdentityMatrix[2].x[t]=={{0},{0}},x[0]=={{1},{2}}},x,{t,0,10}]]],
		TrajectoryP
	]

}];


(* ::Section:: *)
(*End Test Package*)
