(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ReactionMechanism: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ReactionMechanism*)


(* ::Subsubsection:: *)
(*ReactionMechanism*)


DefineTests[ReactionMechanism,{
	Example[{Basic,"A ReactionMechanism with a single reaction:"},
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]],
		ReactionMechanismP
	],
	Example[{Basic,"A ReactionMechanism with several reactions:"},
		ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],
			Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],
			Reaction[{a,b},{c,d},2.1`,4.4`]
		],
		ReactionMechanismP
	],
	Example[{Basic,"Reformat a list of implicit reactions into a proper ReactionMechanism:"},
		ReactionMechanism[{{a + b -> c, 1}, {c \[Equilibrium] d, 2, 3}}],
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]]
	],
	Example[{Basic,"Reformat a mixed sequence of reaction types:"},
		ReactionMechanism[Reaction[{a, b}, {c}, kf], {c \[Equilibrium] d, kf2, kb2}],
		ReactionMechanism[Reaction[{a, b}, {c}, kf], Reaction[{c},{d},kf2,kb2]]
	],


	Example[{Additional,"Properties","See the list of properties that can be dereferenced from a ReactionMechanism:"},
		Keys[ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]]],
		{_Symbol..}
	],
	Example[{Additional,"Properties","Get a list of the species in the ReactionMechanism:"},
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]][Species],
		{a,b,c,d}
	],
	Example[{Additional,"Properties","Extract the reactions:"},
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]][Reactions],
		{Reaction[{a, b}, {c}, 1], Reaction[{c}, {d}, 2, 3]}
	],
	Example[{Additional,"Properties","Extract the rates of each reaction:"},
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{c},{d},2,3]][Rates],
		{{1}, {2, 3}}
	]



}];


(* ::Subsection:: *)
(*Formats*)


(* ::Subsubsection:: *)
(*ReactionMechanismQ*)


DefineTests[ReactionMechanismQ,
{
		Example[
			{Basic,"Check if a ReactionMechanism is properly formatted:"},
			ReactionMechanismQ[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AAATTT","X"]]},{}]},{Structure[{Strand[DNA["AAATTT","X"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},Folding]]],
			True
		],
		Example[
			{Basic,"Empty mechaism is valid:"},
			ReactionMechanismQ[ReactionMechanism[]],
			True
		],
		Example[
			{Basic,"Returns False for anything else:"},
			ReactionMechanismQ["Hello"],
			False
		]
}];


(* ::Subsection::Closed:: *)
(*ReactionMechanism / Reactions / Reactions*)


(* ::Subsubsection::Closed:: *)
(*toFullImplicitReactions*)


DefineTests[toFullImplicitReactions,{
	Test["",toFullImplicitReactions[A->B],{{A->B,kf1}}],
	Test["",toFullImplicitReactions[{A->B}],{{A->B,kf1}}],
	Test["",toFullImplicitReactions[{{A->B}}],{{A->B,kf1}}],
	Test["",toFullImplicitReactions[{A->B,k}],{{A->B,k}}],
	Test["",toFullImplicitReactions[{A->B,1.}],{{A->B,1.}}],
	
	Test["",toFullImplicitReactions[A\[Equilibrium]B],{{A\[Equilibrium]B,kf1,kb1}}],
	Test["",toFullImplicitReactions[{A\[Equilibrium]B}],{{A\[Equilibrium]B,kf1,kb1}}],
	Test["",toFullImplicitReactions[{{A\[Equilibrium]B}}],{{A\[Equilibrium]B,kf1,kb1}}],
	Test["",toFullImplicitReactions[{A\[Equilibrium]B,k1,k2}],{{A\[Equilibrium]B,k1,k2}}],
	Test["",toFullImplicitReactions[{A\[Equilibrium]B,k1,k2}],{{A\[Equilibrium]B,k1,k2}}],
	Test["",toFullImplicitReactions[{A\[Equilibrium]B,1.,k2}],{{A\[Equilibrium]B,1.,k2}}],
	Test["",toFullImplicitReactions[{A\[Equilibrium]B,k1,2.}],{{A\[Equilibrium]B,k1,2.}}]
	
},
Stubs:>{
	Unique[kf1]=kf1,
	Unique[kb1]=kb1
}
];



(* ::Subsection:: *)
(*Manipulation*)


(* ::Subsubsection:: *)
(*MechanismJoin*)


DefineTests[MechanismJoin,
{
	Example[
		{Basic,"Join two mechanisms:"},
		MechanismJoin[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]],ReactionMechanism[Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 30 ;; 33}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 15 ;; 18}, {1, 1, 26 ;; 29}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 17 ;; 19}, {1, 1, 31 ;; 33}]}]}, Folding, Melting]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding],Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 30 ;; 33}]}]}, Folding], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 3 ;; 6}, {1, 1, 30 ;; 33}]}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 15 ;; 18}, {1, 1, 26 ;; 29}]}]}, Folding], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 15 ;; 18}, {1, 1, 26 ;; 29}]}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 17 ;; 19}, {1, 1, 31 ;; 33}]}]}, Folding], Reaction[{Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {Bond[{1, 1, 17 ;; 19}, {1, 1, 31 ;; 33}]}]}, {Structure[{Strand[DNA["CACAGGTTTGGGTAAGCAGATTCTATGCTCCTGAC"]]}, {}]}, Melting]]
	],
	Example[
		{Basic,"Join two mechanisms:"},
		MechanismJoin[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]],ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting]]
	],
	Example[
		{Basic,"Join two mechanisms:"},
		MechanismJoin[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]],ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1, 1 ;; 10}, {3, 2, 1 ;; 10}], Bond[{2, 1, 1 ;; 20}, {3, 1, 1 ;; 20}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1, 1 ;; 10}, {2, 2, 1 ;; 10}], Bond[{1, 2, 1 ;; 20}, {2, 1, 1 ;; 20}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1, 1 ;; 20}, {2, 1, 1 ;; 20}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1, 1 ;; 10}, {3, 2, 1 ;; 10}], Bond[{2, 1, 1 ;; 20}, {3, 1, 1 ;; 20}]}]}, 1.*^6], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, Melting]]
	]
}];


(* ::Subsubsection:: *)
(*MechanismFirst*)


DefineTests[MechanismFirst,{
	Example[{Basic,"Extract first Reaction from ReactionMechanism:"},
		MechanismFirst[ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]],
		Reaction[{a},{b},1.1`]
	],
	Example[{Basic,"Extract first Reaction from ReactionMechanism:"},
		MechanismFirst[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting]
	],
	Example[{Basic,"Extract first Reaction from ReactionMechanism:"},
		MechanismFirst[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]],
		Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1]
	]
}];


(* ::Subsubsection:: *)
(*MechanismLast*)


DefineTests[MechanismLast,{
	Example[{Basic,"Extract last Reaction from ReactionMechanism:"},
		MechanismLast[ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]],
		Reaction[{a,b},{c,d},2.1`,4.4`]
	],
	Example[{Basic,"Extract last Reaction from ReactionMechanism:"},
		MechanismLast[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]
	],
	Example[{Basic,"Extract last Reaction from ReactionMechanism:"},
		MechanismLast[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]],
		Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]
	]
}];


(* ::Subsubsection:: *)
(*MechanismMost*)


DefineTests[MechanismMost,{
	Example[{Basic,"Drop last Reaction from ReactionMechanism:"},
		MechanismMost[ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]],
		ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`]]
	],
	Example[{Basic,"Drop last Reaction from ReactionMechanism:"},
		MechanismMost[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting]]
	],
	Example[{Basic,"Drop last Reaction from ReactionMechanism:"},
		MechanismMost[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1]]
	]
}];


(* ::Subsubsection:: *)
(*MechanismRest*)


DefineTests[MechanismRest,{
	Example[{Basic,"Drop first Reaction from ReactionMechanism:"},
		MechanismRest[ReactionMechanism[Reaction[{a},{b},1.1`],Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]],
		ReactionMechanism[Reaction[{a,b},{c},1],Reaction[{a},{b,c},1.2`],Reaction[{a,b},{c,d},2.1`],Reaction[{a},{b},1.1`,3.1`],Reaction[{a,b},{c},1,3],Reaction[{a},{b,c},1.2`,3.2`],Reaction[{a,b},{c,d},2.1`,4.4`]]
	],
	Example[{Basic,"Drop first Reaction from ReactionMechanism:"},
		MechanismRest[ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 9 ;; 12}, {1, 1, 21 ;; 24}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {}]}, {Structure[{Strand[DNA["AGCGTACATTTGCCCGAGACCAAACAGCAC"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 27 ;; 29}]}]}, Folding, Melting]]
	],
	Example[{Basic,"Drop first Reaction from ReactionMechanism:"},
		MechanismRest[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]
	]
}];




(* ::Section:: *)
(*End Test Package*)
