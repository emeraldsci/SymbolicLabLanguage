(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Reaction: Tests*)


(* ::Subsection::Closed:: *)
(*Reaction*)


(* ::Subsubsection:: *)
(*Reaction*)


DefineTests[Reaction,{
	Example[{Basic,"A second order reversible reaction, A+B \[Equilibrium] C+D:"},
		Reaction[{"A","B"},{"C","D"},10^3,10^-6],
		ReactionP
	],
	Example[{Basic,"A second order irreversible reaction, A+B -> C+D:"},
		Reaction[{"A","B"},{"C","D"},10^3],
		ReactionP
	],
	Example[{Basic,"A first order reversible reaction, A \[Equilibrium] C:"},
		Reaction[{"A"},{"C"},10^3,10^-6],
		ReactionP
	],
	Example[{Basic,"A first order irreversible reaction, A -> C:"},
		Reaction[{"A"},{"C"},10^3],
		ReactionP
	],
	Example[{Basic,"Reformat a rule reaction into proper format:"},
		Reaction[a + b -> c, kf],
		Reaction[{a, b}, {c}, kf]
	],
	Test["Reformat a equilibrium reaction in list into proper format:",
		Reaction[a + b \[Equilibrium] c, kf, kb],
		Reaction[{a, b}, {c}, kf, kb]
	],


	Example[{Additional,"Properties","See the list of properties that can be dereferenced from a reaction:"},
		Keys[Reaction[{"A","B"},{"C","D"},10^3]],
		{_Symbol..}
	],
	Example[{Additional,"Properties","Get a list of the reactants in the reaction:"},
		Reaction[{"A","B"},{"C","D"},10^3][Reactants],
		{"A","B"}
	],
	Example[{Additional,"Properties","Get a list of the reactants in the reaction:"},
		Reaction[{"A","B"},{"C","D"},10^3][Products],
		{"C","D"}
	],
	Example[{Additional,"Properties","Extract the interaction:"},
		Reaction[{"A","B"},{"C","D"},10^3][Interaction],
		Rule["A"+"B","C"+"D"]
	],
	Example[{Additional,"Properties","Extract the rates from the reaction:"},
		Reaction[{"A","B"},{"C","D"},10^3][Rates],
		{10^3}
	],



	Example[{Additional,"The reversible reaction, A+B \[Equilibrium] C:"},
		Reaction[{"A","B"},{"C"},10^3,10^-6],
		ReactionP
	],
	Example[{Additional,"The reversible reaction, A \[Equilibrium] C+D:"},
		Reaction[{"A"},{"C","D"},10^3],
		ReactionP
	],
	Example[{Additional,"The irreversible reaction, A+B -> C:"},
		Reaction[{"A","B"},{"C"},10^3],
		ReactionP
	],
	Example[{Additional,"The irreversible reaction, A -> C+D:"},
		Reaction[{"A"},{"C","D"},10^3],
		ReactionP
	],
	Example[{Additional, "Reformat and add rate type to an irreversible reaction specified as rule:"},
		Reaction[a + b -> c],
		Reaction[{a, b}, {c}, Unknown]
	],
	Example[{Additional, "Reformat and add rate type to an irreversible reaction specified as rule:"},
		Reaction[Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{}] -> Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,8;;10},{1,16;;18}]}]],
		Reaction[{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{}]},{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,8;;10},{1,16;;18}]}]},Folding]
	],
	Example[{Additional, "Reformat and add rate type to an reversible reaction specified as equilibrium:"},
		Reaction[a \[Equilibrium] b + c],
		Reaction[{a}, {b, c}, Unknown, Unknown]
	],
	Example[{Additional, "Reformat and add rate type to an reversible reaction specified as equilibrium:"},
		Reaction[Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}] \[Equilibrium] Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 7;;10}, {2,8;;11}]}]],
		Reaction[{Structure[{Strand[DNA["GGGGGATTAAT"]],Strand[DNA["GGGGTAATTAATGGC"]]},{Bond[{1,6;;11},{2,7;;12}]}]},{Structure[{Strand[DNA["GGGGGATTAAT"]],Strand[DNA["GGGGTAATTAATGGC"]]},{Bond[{1,7;;10},{2,8;;11}]}]},Unzipping,Zipping]
	]

}];


(* ::Subsection::Closed:: *)
(*Validity*)


(* ::Subsubsection::Closed:: *)
(*ReactionQ*)


DefineTests[ReactionQ, {

	Example[{Basic,"A reversible folding reaction classified as Folding and Melting is valid:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Folding,Melting]],
		True
	],
	Example[{Basic,"A folding reaction classified as Hybridization is not valid:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Hybridization]],
		False
	],
	Example[{Basic,"A hybridization reaction with a numeric rate with correct units is valid:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]],Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{Bond[{1,1,1;;3},{2,3,1;;3}],Bond[{1,2,1;;6},{2,2,1;;6}],Bond[{1,3,1;;2},{2,1,1;;2}]}]},
			10^5/Molar/Second]],
		True
	],
	Example[{Basic,"A reversible hybridization reaction with inccorect units is not valid:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
				Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]],Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{Bond[{1,1,1;;3},{2,3,1;;3}],Bond[{1,2,1;;6},{2,2,1;;6}],Bond[{1,3,1;;2},{2,1,1;;2}]}]},
			10^5/Second, 1/Second]],
		False
	],
	Example[{Basic,"Any non-reaction input is also not valid:"},
		ReactionQ[Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}]],
		False
	],


	Example[{Additional,"A reaction with non-structure reactants and products cannot have symoblic rates:"},
		ReactionQ[Reaction[
			{a,b},
			{c,d},
			ToeholdMediatedStrandExchange]],
		False
	],
	Example[{Additional,"A reaction with non-structure reactants and products can have numeric rates:"},
		ReactionQ[Reaction[
			{a,b},
			{c,d},
			10^3/Second/Molar]],
		True
	],


	Example[{Options, "Verbose", "Print the results of each test:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Folding,Melting],Verbose->True],
		True
	],
	Example[{Options, "Verbose", "Print the results of the failing tests:"},
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			1/Molar/Second],Verbose->Failures],
		False
	],

	Test["Units of rate must be consistent with the number of reactants:",
		ReactionQ[Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}]],
		False
	],
	Test["Symbolic rate type must be consistent with the reactants and products:",
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Melting]],
		False
	],

	
	(* Reversible reactions *)
	Test["Specify a hybridization/dissociation reactions to validate units:",
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
			Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]],Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{Bond[{1,1,1;;3},{2,3,1;;3}],Bond[{1,2,1;;6},{2,2,1;;6}],Bond[{1,3,1;;2},{2,1,1;;2}]}]},
			1/Molar/Second,
			1/Second]],
		True
	],
	Test["Specify a folding/unfolding reactions to validate symbolic reaction name and units:",
		ReactionQ[Reaction[{
			Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Folding,
			1/Second]],
		True
	],
	Test["Specify a folding/unfolding reactions to validate units and symbolic reaction name:",
		ReactionQ[Reaction[{
			Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			1/Second,
			Melting]],
		True
	],
	Test["Specify a folding/unfolding reactions to validate units:",
		ReactionQ[Reaction[{
			Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Folding,
			Melting]],
		True
	],
	Test["Specify a folding/unfolding reactions to validate symbolic reaction name:",
		ReactionQ[Reaction[{
			Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{}]},
			{Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"],DNA["CCCCCCGGGG"],DNA["TTTTT"]]},{Bond[{1,1,1;;4},{1,3,2;;5}]}]},
			Folding,
			Melting]],
		True
	],
	Test["Specify a hybridization/dissociation reactions to validate symbolic reaction name:",
		ReactionQ[Reaction[
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]]},{}],
			Structure[{Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{}]},
			{Structure[{Strand[DNA["AAA"],DNA["CCCCCC"],DNA["AA"]],Strand[DNA["TT"],DNA["GGGGGG"],DNA["TTT"]]},{Bond[{1,1,1;;3},{2,3,1;;3}],Bond[{1,2,1;;6},{2,2,1;;6}],Bond[{1,3,1;;2},{2,1,1;;2}]}]},
			Hybridization,
			Dissociation]],
		True
	]
},
	Stubs:> {
		NotebookWrite[___] := Null,
		Print[___] := Null,
		PrintTemporary[___] := Null
	}
];


(* ::Subsection::Closed:: *)
(*Manipulation*)


(* ::Subsubsection::Closed:: *)
(*SplitReaction*)


DefineTests[
	SplitReaction,
	{
		Example[{Basic,"Split a reversible reaction into separate forward and reverse reactions:"},
			SplitReaction[Reaction[{a,b},{c},kf,kb]],
			{Reaction[{a,b},{c},kf], Reaction[{c},{a,b},kb]}
		],
		Example[{Basic,"Irreversible reactions are left alone.  Note the function always returns a list:"},
			SplitReaction[Reaction[{a,b},{c},kf]],
			{Reaction[{a,b},{c},kf]}
		],
		Example[{Basic,"Split a reversible folding reaction:"},
			SplitReaction[Reaction[{Structure[{Strand[DNA["AAATTT","X"]]},{}]},{Structure[{Strand[DNA["AAATTT","X"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},Folding,Melting]],
			{
				Reaction[{Structure[{Strand[DNA["AAATTT","X"]]},{}]},{Structure[{Strand[DNA["AAATTT","X"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},Folding],
				Reaction[{Structure[{Strand[DNA["AAATTT","X"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},{Structure[{Strand[DNA["AAATTT","X"]]},{}]},Melting]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*irreversibleImplicitReactionFormatP*)


DefineTests["Patterns`Private`irreversibleReactionP",{
	Test["",MatchQ[{A+B->C,1.},irreversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B->C,1.,2.},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B->C,var},irreversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B->C,k[1]},irreversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B->C,A->D},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B->C},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{{A+B->C}},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{{A+B->C,1.}},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B\[Equilibrium]C,1.},irreversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B\[Equilibrium]C,1.,2.},irreversibleImplicitReactionFormatP],False]
}];


(* ::Subsubsection::Closed:: *)
(*reversibleImplicitReactionFormatP*)


DefineTests["Patterns`Private`reversibleReactionP",{
	Test["",MatchQ[{A+B\[Equilibrium]C,1.,2.},reversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B\[Equilibrium]C,1.},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B\[Equilibrium]C,var,2.},reversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B\[Equilibrium]C,k[1],var},reversibleImplicitReactionFormatP],True],
	Test["",MatchQ[{A+B\[Equilibrium]C,A->D},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B\[Equilibrium]C},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{{A+B\[Equilibrium]C}},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{{A+B\[Equilibrium]C,1.}},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B->C,1.},reversibleImplicitReactionFormatP],False],
	Test["",MatchQ[{A+B->C,1.,2.},reversibleImplicitReactionFormatP],False]
}];


(* ::Subsection::Closed:: *)
(*Classification*)


(* ::Subsubsection::Closed:: *)
(*ClassifyReaction*)


DefineTests[ClassifyReaction, {

	(* ------ Basic ------ *)
	Example[{Basic, "Classify a folding reaction by checking if new bond is formed within the reactant structure:"},
		ClassifyReaction[{Structure[{Strand[
			RNA["GGGGAACCCCAAAGGGGAAAACCCCAAAGGGGAAAACCCCAAAA"]]}, {}]}, {Structure[{Strand[
			RNA["GGGGAACCCCAAAGGGGAAAACCCCAAAGGGGAAAACCCCAAAA"]]}, {Bond[{1,
			1 ;; 4}, {1, 37 ;; 40}], Bond[{1, 7 ;; 10}, {1, 14 ;; 17}],
			Bond[{1, 22 ;; 25}, {1, 29 ;; 32}]}]}],
		Folding
	],
	
	Example[{Basic, "Classify a melting reaction by checking if at least one bond in the reactant structure does not exist in product structure:"},
		ClassifyReaction[
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]},{Bond[{1,1,1;;3},{1,1,22;;24}],Bond[{1,1,4;;6},{1,1,10;;12}],Bond[{1,1,13;;15},{1,1,19;;21}]}]},
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1, 4 ;; 6}, {1, 1, 10 ;; 12}], Bond[{1, 1, 13 ;; 15}, {1, 1, 19 ;; 21}]}]}
		],
		Melting
	],
	Example[{Basic, "Classify a hybridization reaction by checking if new bond is formed between reactant structures to form one new product structure:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;3}, {2, 7;;9}]}]},
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 2;;4}, {3, 6;;8}]}]}
		],
		Hybridization
	],	
	Example[{Basic, "Classify a dissociation reaction by checking if at least one bond in the reactant structure is melted and the reactant is dissociated into at least two product structures:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]},
			{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]}
		],
		Dissociation
	],
	(* ------ Messages ------ *)
	Example[{Messages, "UnknownStructure", "Both reactant(s) and product(s) must be valid Structures:"},
		ClassifyReaction[{Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}], Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {3, 6 ;; 11}]}]}, {Structure[{Strand[DNA["AAAAAAGGAAA"]], Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 7 ;; 11}, {2, 4 ;; 8}], Bond[{2, 9 ;; 14}, {3, 6 ;; 11}]}]}],
		$Failed,
		Messages :> {ClassifyReaction::UnknownStructure}
	],

	(* ------ Folding ------ *)
	Test["Folding one fold:",
		ClassifyReaction[{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {}]},{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}],
		Folding
	],
	Example[{Additional,"Folding","Classify as Folding reaction if new bonds are formed within the reactant structure::"},
		ClassifyReaction[{Structure[{Strand[Modification["Fluorescein"], DNA["CCCAGGCATGTGTCGTCTCGACCCT"]]}, {}]}, {Structure[{Strand[Modification["Fluorescein"],DNA["CCCAGGCATGTGTCGTCTCGACCCT"]]},{Bond[{1, 2, 4 ;; 6}, {1, 2, 23 ;; 25}], Bond[{1, 2, 12 ;; 15}, {1, 2, 19 ;; 22}]}]}],
		Folding
	],
	Test["Interstrand folding:",
		ClassifyReaction[{Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]}, {Structure[{Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["TTT"],DNA["CCCG"]]},{Bond[{1,1,1;;3},{2,2,1;;3}],Bond[{1,2,2;;4},{2,1,1;;3}]}]}],
		Folding
	],
	Test["Folding RNA closing:",
		ClassifyReaction[{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1, 4 ;; 6}, {1, 1, 10 ;; 12}], Bond[{1, 1, 13 ;; 15}, {1, 1, 19 ;; 21}]}]}, {Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]},{Bond[{1,1,1;;3},{1,1,22;;24}],Bond[{1,1,4;;6},{1,1,10;;12}],Bond[{1,1,13;;15},{1,1,19;;21}]}]}],
		Folding
	],
	Test["Folding, with a disconnected strand on both sides:",
		ClassifyReaction[
			{Structure[{Strand[DNA["CCCCTTTTGGGG"]], Strand[DNA["AAAAAAA"]]}, {}]},
			{Structure[{Strand[DNA["CCCCTTTTGGGG"]],Strand[DNA["AAAAAAA"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]}
		],
		Folding
	],
	Test["Need strand mapping:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["TTT"],DNA["CCCG"]]},{Bond[{1,1;;3},{3,4;;6}],Bond[{1,5;;7},{4,1;;3}],Bond[{2,1;;3},{4,4;;6}]}]},
			{Structure[{Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["TTT"],DNA["CCCG"]]},{Bond[{1,1;;3},{3,4;;6}],Bond[{1,4;;6},{4,1;;3}],Bond[{2,1;;3},{4,4;;6}],Bond[{2,5;;7},{3,1;;3}]}]}
		],
		Folding
	],

	Test["Folding5-Pseudo-OverlapStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;9}, {1,16;;19}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Unknown
	],
	Test["Folding6-Pseudo-InsideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;7}, {1,18;;19}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Unknown
	],
	Test["Folding7-Pseudo-OutSideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 8;;9}, {1,16;;17}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Unknown
	],
	
	(* ------ Melting ------ *)
	Test["Melting one fold:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {}]}
		],
		Melting
	],
	Test["Melting two folds:",
		ClassifyReaction[
			{Structure[{Strand[Modification["Fluorescein"], DNA["CCCAGGCATGTGTCGTCTCGACCCT"]]}, {Bond[{1, 2, 4 ;; 6}, {1, 2, 23 ;; 25}], Bond[{1, 2, 12 ;; 15}, {1, 2, 19 ;; 22}]}]},
			{Structure[{Strand[Modification["Fluorescein"],DNA["CCCAGGCATGTGTCGTCTCGACCCT"]]},{}]}
		],
		Melting
	],
	Example[{Additional,"Melting","Classify as Melting if at least one bond is melted from reactant structure:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["GGG"],DNA["AAAA"]],Strand[DNA["TTT"],DNA["CCCG"]]},{Bond[{1,1,1;;3},{2,2,1;;3}],Bond[{1,2,2;;4},{2,1,1;;3}]}]},
			{Structure[{Strand[DNA["TTT"],DNA["CCCG"]],Strand[DNA["GGG"],DNA["AAAA"]]},{Bond[{1,2,1;;3},{2,1,1;;3}]}]}
		],
		Melting
	],
	Test["Melting RNA closure:",
		ClassifyReaction[
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]},{Bond[{1,1,1;;3},{1,1,22;;24}],Bond[{1,1,4;;6},{1,1,10;;12}],Bond[{1,1,13;;15},{1,1,19;;21}]}]},
			{Structure[{Strand[RNA["AAACCCAAAGGGCCCAAAGGGUUU"]]}, {Bond[{1, 1, 4 ;; 6}, {1, 1, 10 ;; 12}], Bond[{1, 1, 13 ;; 15}, {1, 1, 19 ;; 21}]}]}
		],
		Melting
	],
	Test["Unfolding5-Pseudo-OverlapStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;9}, {1,16;;19}]}]}
		],
		Unknown
	],
	Test["Unfolding6-Pseudo-InsideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;7}, {1,18;;19}]}]}
		],
		Unknown
	],
	Test["Unfolding7-Pseudo-OutSideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 8;;9}, {1,16;;17}]}]}
		],
		Unknown
	],
	
	(* ------ Zipping ------ *)
	Test["Zipping to the right:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;8}, {2,10;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Zipping
	],
	Test["Zipping to the left:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 9;;11}, {2,7;;9}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Zipping
	],
	Example[{Additional,"Zipping","Classify as Zipping if a bond in reactant structure is extended on at least one side:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 7;;10}, {2,8;;11}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Zipping
	],
	Test["Zipping a hairpin loop:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;8}, {1,21;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Zipping
	],
	Test["Zipping a hairpin stem:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 9;;11}, {1,18;;20}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Zipping
	],
	Test["Zipping a hairpin in both directions:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 7;;10}, {1,19;;22}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]}
		],
		Zipping
	],
	Test["Zipping two separate bonded regions:",
		ClassifyReaction[
			{Structure[{Strand[DNA["CCCCCCCCCCCCCCCCCCCC"]],Strand[DNA["GGGGGGGGGGGGGGGGGGGG"]]}, {Bond[{1, 3 ;; 7}, {2,14 ;; 18}], Bond[{1, 14 ;; 18}, {2, 3 ;; 7}]}]},
			{Structure[{Strand[DNA["CCCCCCCCCCCCCCCCCCCC"]],Strand[DNA["GGGGGGGGGGGGGGGGGGGG"]]}, {Bond[{1, 1 ;; 7}, {2,14 ;; 20}], Bond[{1, 14 ;; 20}, {2, 1 ;; 7}]}]}
		],
		Zipping
	],
	Test["One side zips, the other side unzips:",
		ClassifyReaction[
			{Structure[{Strand[DNA["ACGT"]],Strand[DNA["ACGT"]]}, {Bond[{1, 2 ;; 3}, {2, 2 ;; 3}]}]},
			{Structure[{Strand[DNA["ACGT"]],Strand[DNA["ACGT"]]}, {Bond[{1, 1 ;; 2}, {2, 3 ;; 4}]}]}
		],
		Unknown
	],
	Test["Zipping closed an internal loop:",
		ClassifyReaction[
			{Structure[{Strand[DNA["CCCCCCCCCCCCCCCCCCCC"]],Strand[DNA["GGGGGGGGGGGGGGGGGGGG"]]}, {Bond[{1, 1 ;; 7}, {2,14 ;; 20}], Bond[{1, 14 ;; 20}, {2, 1 ;; 7}]}]},
			{Structure[{Strand[DNA["CCCCCCCCCCCCCCCCCCCC"]],Strand[DNA["GGGGGGGGGGGGGGGGGGGG"]]}, {Bond[{1, 1 ;; 20}, {2,	1 ;; 20}]}]}
		],
		Zipping
	],
	Test["Zipping7-Pseudo-OverlapStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;9}, {2,5;;8}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Unknown
	],
	Test["Zipping8-Pseudo-InsideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;7}, {2,7;;8}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Unknown
	],
	Test["Zipping9-Pseudo-OutSideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 8;;9}, {2,5;;6}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]}
		],
		Unknown
	],
	Test["Zip both sides towards the middle:",
		ClassifyReaction[
			{Structure[{Strand[DNA["NNNNNNNNNNN","A"],DNA["NNNNNNNNNNN","B"],DNA["NNNNNNNNNNN","C"]],Strand[DNA["NNNNNNNNNNN","C'"],DNA["NNNNNNNNNNN","B'"],DNA["NNNNNNNNNNN","A'"]]},{Bond[{1,1},{2,3}],Bond[{1,3},{2,1}]}]},
			{Structure[{Strand[DNA["NNNNNNNNNNN","A"],DNA["NNNNNNNNNNN","B"],DNA["NNNNNNNNNNN","C"]],Strand[DNA["NNNNNNNNNNN","C'"],DNA["NNNNNNNNNNN","B'"],DNA["NNNNNNNNNNN","A'"]]},{Bond[{1,1},{2,3}],Bond[{1,2},{2,2}],Bond[{1,3},{2,1}]}]}
		],
		Zipping
	],

	(* ------ Unzipping ------ *)
	Test["Unzipping right:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;8}, {2,10;;12}]}]}
		],
		Unzipping
	],
	Test["Unzipping left:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 9;;11}, {2,7;;9}]}]}
		],
		Unzipping
	],
	Test["Unzipping both sides:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 7;;10}, {2,8;;11}]}]}
		],
		Unzipping
	],
	Example[{Additional,"Unzipping","Classify as Unzipping if a bond in reactant structure is shortened on at least one side:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;8}, {1,21;;23}]}]}
		],
		Unzipping
	],
	Test["Unzipping hairpin stem:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 9;;11}, {1,18;;20}]}]}
		],
		Unzipping
	],
	Test["Unzipping hairpin both directions:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {1,18;;23}]}]},
			{Structure[{Strand[DNA["GGGGGATTAATGGGGTAATTAATGGC"]]}, {Bond[{1, 7;;10}, {1,19;;22}]}]}
		],
		Unzipping
	],
	Test["Unzipping7-Pseudo-OverlapStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;9}, {2,5;;8}]}]}
		],
		Unknown
	],
	Test["Unzipping8-Pseudo-InsideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;7}, {2,7;;8}]}]}
		],
		Unknown
	],
	Test["Unzipping9-Pseudo-OutSideStagger:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 6;;11}, {2,7;;12}]}]},
			{Structure[{Strand[DNA["GGGGGATTAAT"]], Strand[DNA["GGGGTAATTAATGGC"]]}, {Bond[{1, 8;;9}, {2,5;;6}]}]}
		],
		Unknown
	],
	
	(* ------ Hybridization ------ *)
	Test["Hybridization 2:",
		ClassifyReaction[
			{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}], Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 2, 1 ;; 3}, {2, 1, 1 ;; 3}]}]},
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {3, 4 ;; 6}], Bond[{1, 4 ;; 6}, {4, 1 ;; 3}], Bond[{2, 1 ;; 3}, {4, 4 ;; 6}]}]}
		],
		Hybridization
	],
	Example[{Additional,"Hybridization","Classify as Hybridization if two reactants react into one product by forming new bonds between them:"},
		ClassifyReaction[
			{
				Structure[{Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}]}],
				Structure[{Strand[DNA["AAAAATTTTT"]],	Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2,6 ;; 10}]}]
			},
			{
				Structure[{Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}],	Bond[{3, 1 ;; 5}, {4, 6 ;; 10}],Bond[{2, 1 ;; 5}, {3, 6 ;; 10}]}]
			}
		],
		Hybridization
	],
	
	(* ------ Dissociation ------ *)
	Test["Dissociation 1:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 2;;4}, {3, 6;;8}]}]},
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;5}, {2, 6;;10}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1;;3}, {2, 7;;9}]}]}
		],
		Dissociation
	],
	Test["Dissociating two identical structures, each with two identical strands:",
		ClassifyReaction[
			{
				Structure[{Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}],	Bond[{3, 1 ;; 5}, {4, 6 ;; 10}],Bond[{2, 1 ;; 5}, {3, 6 ;; 10}]}]
			},
			{
				Structure[{Strand[DNA["AAAAATTTTT"]],Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}]}],
				Structure[{Strand[DNA["AAAAATTTTT"]],	Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2,6 ;; 10}]}]
			}
		],
		Dissociation
	],
	Example[{Additional,"Dissociation","Classify as Dissociation if reactant structure is dissociated into at least two structures:"},
		ClassifyReaction[
			{
				Structure[{Strand[DNA["AAAAXXXXCCCC"]], Strand[DNA["GGGGXXXXTTTT"]],Strand[DNA["GGGGXXXXCCCC"]]}, {Bond[{1, 1 ;; 4}, {2, 9 ;; 12}],	Bond[{2, 1 ;; 4}, {3, 9 ;; 12}], Bond[{3, 1 ;; 4}, {1, 9 ;; 12}]}]
			},
			{
				Structure[{Strand[DNA["AAAAXXXXCCCC"]]}, {}],
				Structure[{Strand[DNA["GGGGXXXXCCCC"]]}, {}],
				Structure[{Strand[DNA["GGGGXXXXTTTT"]]}, {}]
			}
		],
		Dissociation
	],

	(* ------ ToeholdMediatedStrandExchange ------ *)
	Example[{Additional,"ToeholdMediatedStrandExchange","Classify as ToeholdMediatedStrandExchange if there is a valid toehold region on one of the reactant which initiates a strand invasion:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;5}, {2, 7;;11}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAATTT"]]}, {}]},
			{Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;6}, {2, 4;;9}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAAAATTTTT"]]}, {}]}
		],
		ToeholdMediatedStrandExchange
	],
	Test["ToeholdMediatedStrandExchange 2:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]], Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {Bond[{1, 11 ;; 16}, {2, 8 ;; 13}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]},
			{Structure[{Strand[DNA["AAAAAAGGAAA"]], Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]]}, {Bond[{1, 1 ;; 11}, {2, 12 ;; 22}]}], Structure[{Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {}]}
		],
		ToeholdMediatedStrandExchange
	],
	Test["ToeholdMediatedStrandExchange 3:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]], Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {Bond[{1, 11 ;; 16}, {2, 8 ;; 13}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]},
			{Structure[{Strand[DNA["AAAAAAGGAAA"]], Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]]}, {Bond[{1, 3 ;; 11}, {2, 6 ;; 14}]}], Structure[{Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {}]}
		],
		ToeholdMediatedStrandExchange
	],
	Test["ToeholdMediatedStrandExchange 4:",
		ClassifyReaction[
			{Structure[{Strand[DNA["GGTTTTCCTTTTAAAA"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 3 ;; 8}, {2, 8 ;; 13}]}], Structure[{Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]], Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {Bond[{1, 11 ;; 16}, {2, 8 ;; 13}]}]},
			{Structure[{Strand[DNA["AAAATTTTCCTTTTCCTTTTTT"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]], Strand[DNA["TTCCCCCGGAAAAAAAAATTTTTTT"]]}, {Bond[{1, 11 ;; 16}, {3, 8 ;; 13}], Bond[{1, 17 ;; 22}, {2, 10 ;; 15}]}], Structure[{Strand[DNA["GGTTTTCCTTTTAAAA"]]}, {}]}
		],
		ToeholdMediatedStrandExchange
	],
	
	(* ------ ToeholdMediatedDuplexExchange ------ *)
	Example[{Additional,"ToeholdMediatedDuplexExchange","Classify as ToeholdMediatedDuplexExchange if there is a valid toehold region on one of the reactant which initiates a duplex invasion:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTTAAAAAA"]], Strand[DNA["TTTTAAAA"]],Strand[DNA["TTTTAAAA"]]}, {Bond[{1, 7 ;; 11}, {2, 1 ;; 5}], Bond[{3,5;;8},{4,1;;4}], Bond[{2, 6;;9}, {3, 1;;4}]}]},
			{Structure[{Strand[DNA["TTTTAAAA"]],Strand[DNA["TTTTTAAAAAA"]]},{Bond[{1,1;;8},{2,2;;9}]}],Structure[{Strand[DNA["TTTTTAAAAAA"]],Strand[DNA["TTTTAAAA"]]},{Bond[{1,3;;10},{2,1;;8}]}]}
		],
		ToeholdMediatedDuplexExchange
	],
	Test["ToeholdMediatedDuplexExchange 1:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;5}, {2, 7;;11}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAATTT"]], Strand[DNA["TTT"]]}, {Bond[{1,1;;3}, {2, 1;;3}]}]},
			{Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;6}, {2, 4;;9}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTT"]]}, {Bond[{1,3;;5}, {2, 1;;3}]}]}
		],
		Unknown
	],
	Test["ToeholdMediatedDuplexExchange 2:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 5}, {2, 7 ;; 11}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAA"]]}, {Bond[{1, 4 ;; 6}, {2, 1 ;; 3}]}]},
			{Structure[{Strand[DNA["AAA"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1 ;; 3}, {2, 7 ;; 9}], Bond[{3, 1 ;; 3}, {4, 7 ;; 9}], Bond[{2, 1 ;; 3}, {3, 6 ;; 8}], Bond[{5, 1 ;; 5}, {4, 1 ;; 5}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAATTT"]]}, {Bond[{1, 3 ;; 8}, {2, 1 ;; 6}]}]}
		],
		Unknown
	],
	Test["Classify as ToeholdMediatedDuplexExchange if there is a valid toehold region on one of the reactant which initiates a duplex invasion:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAA"]], Strand[DNA["TTTTTAAAAAA"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}], Structure[{Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTT"]]}, {Bond[{1, 5 ;; 8}, {2, 1 ;; 4}]}]},
			{Structure[{Strand[DNA["TTTTAAAA"]], Strand[DNA["TTTTTAAAAAA"]]}, {Bond[{1, 1 ;; 8}, {2, 2 ;; 9}]}], Structure[{Strand[DNA["AAAAA"]], Strand[DNA["TTTT"]]}, {Bond[{1, 1 ;; 4}, {2, 1 ;; 4}]}]}
		],
		Unknown
	],
	
	(* ------ DualToeholdMediatedDuplexExchange ------ *)
	Test["DualToeholdMediatedDuplexExchange:",
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;5}, {2, 7;;11}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAATTT"]]}, {Bond[{1,4;;6}, {2, 1;;3}]}]},
			{Structure[{Strand[DNA["AAATTT"]], Strand[DNA["AAAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]], Strand[DNA["TTTTTCCCGCGCT"]]}, {Bond[{1, 1;;6}, {2, 4;;9}], Bond[{3, 1;;3}, {4, 7;;9}], Bond[{2, 1;;3}, {3, 6;;8}], Bond[{5, 1;;5}, {4, 1;;5}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAATTT"]]}, {Bond[{1,3;;8}, {2, 1;;6}]}]}
		],
		DualToeholdMediatedDuplexExchange
	],
	Example[{Additional,"DualToeholdMediatedDuplexExchange","Classify as DualToeholdMediatedDuplexExchange if there are valid dual toehold regions on both reactants which initiate a duplex invasion:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["AAAATTTTCCGGGG"]], Strand[DNA["GGGAAAAGGAAAAGGGG"]], Strand[DNA["TTTTGGAAAA"]]}, {Bond[{1, 5;;10}, {2, 8;;13}], Bond[{1, 1;;4}, {3, 1;;4}]}], Structure[{Strand[DNA["AAAATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 5;;10}, {2, 8;;13}]}]},
			{Structure[{Strand[DNA["AAAATTTTCCGGGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]], Strand[DNA["TTTTGGAAAA"]]}, {Bond[{1, 5;;14}, {2, 4;;13}], Bond[{1, 1;;4}, {3, 1;;4}]}], Structure[{Strand[DNA["GGGAAAAGGAAAAGGGG"]], Strand[DNA["AAAATTTTCCTTTTGG"]]}, {Bond[{1, 4;;13}, {2, 5;;14}]}]}
		],
		DualToeholdMediatedDuplexExchange
	],
	Test["Classify a dual toehold mediated duplex exchange reaction by checking if there are toehold regions on both strands:",
		ClassifyReaction[{Structure[{Strand[DNA["AAAAATTT"]], Strand[DNA["AAATTTTT"]]}, {Bond[{1, 6 ;; 8}, {2, 1 ;; 3}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 5}, {2, 6 ;; 10}]}]}, {Structure[{Strand[DNA["AAAAATTT"]], Strand[DNA["AAAAATTTTT"]]}, {Bond[{1, 1 ;; 8}, {2, 3 ;; 10}]}], Structure[{Strand[DNA["AAAAATTTTT"]], Strand[DNA["AAATTTTT"]]}, {Bond[{1, 1 ;; 8}, {2, 1 ;; 8}]}]}],
		DualToeholdMediatedDuplexExchange
	],
	
	(* ------ Unchanged ------ *)
	Test["Unchanging reaction:",
		ClassifyReaction[
			{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{2, 1 ;; 3}, {1, 4 ;; 6}], Bond[{2, 5 ;; 7}, {1, 1 ;; 3}]}]},
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {2, 4 ;; 6}], Bond[{1, 5 ;; 7}, {2, 1 ;; 3}]}]}
		],
		Unchanged
	],
	Example[{Additional,"Unchanged","Reaction is classified as Unchanged if reactant(s) and product(s) are exactly the same:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,2,4;;4},{1,4,3;;3}],Bond[{1,3,1;;2},{1,4,1;;2}]}]},
			{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}]}
		],
		Unchanged
	],
	
	
	(* ------ Branch Migration ------ *)
	(* these come back as Unknown right now *)
	Test["Branch Migration:",
		ClassifyReaction[
			{Structure[{Strand[DNA["NNNNNNNNNNNNNNNNNNNN","A"],DNA["NNNNNNNNNNNNNNNNNNNN","B"]],Strand[DNA["NNNNNNNNNNNNNNNNNNNN","A"],DNA["NNNNNNNNNNNNNNNNNNNN","B"],DNA["NNNNNNNNNNNNNNNNNNNN","C"]],Strand[DNA["NNNNNNNNNNNNNNNNNNNN","C'"],DNA["NNNNNNNNNNNNNNNNNNNN","B'"],DNA["NNNNNNNNNNNNNNNNNNNN","A'"]]},{Bond[{1,1},{3,3}],Bond[{2,2},{3,2}],Bond[{2,3},{3,1}]}]},
			{Structure[{Strand[DNA["NNNNNNNNNNNNNNNNNNNN","A"],DNA["NNNNNNNNNNNNNNNNNNNN","B"]],Strand[DNA["NNNNNNNNNNNNNNNNNNNN","A"],DNA["NNNNNNNNNNNNNNNNNNNN","B"],DNA["NNNNNNNNNNNNNNNNNNNN","C"]],Strand[DNA["NNNNNNNNNNNNNNNNNNNN","C'"],DNA["NNNNNNNNNNNNNNNNNNNN","B'"],DNA["NNNNNNNNNNNNNNNNNNNN","A'"]]},{Bond[{1,1},{3,3}],Bond[{1,2},{3,2}],Bond[{2,3},{3,1}]}]}
		],
		Unknown	
	],
	
	
	(* ------ Unknown ------ *)
	Example[{Additional,"Unknown","Reaction is classified as Unknown if strands in reactants and products are different:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{2, 1 ;; 3}, {1, 4 ;; 6}], Bond[{2, 5 ;; 7}, {1, 1 ;; 3}]}]},
			{Structure[{Strand[DNA["GGG"], DNA["GAAA"]], Strand[DNA["TTT"], DNA["CCCG"]]}, {Bond[{1, 1 ;; 3}, {2, 4 ;; 6}], Bond[{1, 5 ;; 7}, {2, 1 ;; 3}]}]}
		],
		Unknown
	],
	Test["UnsupportedReaction2:",
		ClassifyReaction[
			{Structure[{Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{2, 1 ;; 3}, {1, 4 ;; 6}], Bond[{2, 5 ;; 7}, {1, 1 ;; 3}]}]},
			{Structure[{Strand[DNA["GGG"], DNA["AAAA"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["TTTGAAA"]]}, {Bond[{1, 1 ;; 3}, {2, 4 ;; 6}], Bond[{1, 5 ;; 7}, {2, 1 ;; 3}]}]}
		],
		Unknown
	],
	Test["UnsupportedReaction3:",
		ClassifyReaction[
			{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAT"],DNA["GGG"]]},{Bond[{1,2,4;;4},{1,4,3;;3}],Bond[{1,3,1;;2},{1,4,1;;2}]}]},
			{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}]}
		],
		Unknown
	],
	Test["UnsupportedReaction4:",
		ClassifyReaction[
			{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,2,4;;4},{1,4,3;;3}],Bond[{1,3,1;;2},{1,4,1;;2}]}]},
			{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]], Strand[DNA["TTT"], DNA["CCCG"]], Strand[DNA["GGG"], DNA["AAAA"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}]}
		],
		Unknown
	],


	(* StrandInvasion *)
	Example[{Additional,"StrandInvasion","Classify as Strandinvasion if one side of the bonded region in one of the reactant structures get replaced by the exactly same segment in the other reactant structure:"},
		ClassifyReaction[
			{
				Structure[{Strand[DNA["CCCCCA"]]}, {}],
				Structure[{Strand[DNA["CCCCC"]],Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]
			},
			{
				Structure[{Strand[DNA["CCCCC"]]}, {}],
				Structure[{Strand[DNA["CCCCCA"]],Strand[DNA["GGGGG"]]}, {Bond[{1, 1 ;; 5}, {2, 1 ;; 5}]}]
			}
		],
		StrandInvasion
	],

	Test["Strand invasion with more changes in bonded reagion:",
		ClassifyReaction[
			{Structure[{Strand[DNA["TTTCCCCCAGGA"]]},{}],Structure[{Strand[DNA["GGGGGTCCCCCATT"]],Strand[DNA["TTTTTGGGGGAGG"]]},{Bond[{1,6;;12},{2,5;;11}]}]},
			{Structure[{Strand[DNA["GGGGGTCCCCCATT"]]},{}],Structure[{Strand[DNA["TTTCCCCCAGGA"]],Strand[DNA["TTTTTGGGGGAGG"]]},{Bond[{1,3;;9},{2,5;;11}]}]}
		],
		StrandInvasion
	],
	
	(* DuplexInvasion *)
	Example[{Additional,"DuplexInvasion","Classify as DuplexInvasion if two sides of the shared bonded regions in two reactant structures get switched:"},
		ClassifyReaction[
			{Structure[{Strand[DNA["CCCCCA"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCC"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]},
			{Structure[{Strand[DNA["CCCCC"]], Strand[DNA["GGGGGT"]]},{Bond[{1, 1;;5}, {2, 1;;5}]}],Structure[{Strand[DNA["CCCCCA"]],Strand[DNA["GGGGG"]]},{Bond[{1,1;;5},{2,1;;5}]}]}
		],
		DuplexInvasion
	]

}]
