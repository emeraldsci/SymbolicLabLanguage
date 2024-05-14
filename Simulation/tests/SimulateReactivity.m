(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*SimulateReactivity: Tests*)


(* ::Subsection:: *)
(*Interactions at the Motif level*)



(* ::Subsubsection::Closed:: *)
(*firstOrder*)

DefineTests[firstOrder,
{
		Example[
			{Basic,"zipping"},
			firstOrder[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}]}]],
			{Reaction[{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}]}]},{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},Zipping]}
		],

		Example[
			{Basic,"first-order Pairing"},
			firstOrder[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}]}]],
			{Reaction[{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}]}]},{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]}, Zipping]}
		],

		Example[
			{Basic,"displacement with spacer"},
			firstOrder[Structure[{Strand[DNA[20,"A"],DNA[20,"X"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]],Strand[DNA[20,"B'"]]},{Bond[{1,1},{2,2}],Bond[{1,3},{3,1}]}]],
			{}
		]
}];



(* ::Subsubsection::Closed:: *)
(*secondOrder*)

DefineTests[secondOrder,
{
		Example[
			{Basic,"Second order interactions:"},
			secondOrder[Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"]]},{}]],
			{Reaction[{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"]]},{}]},{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2},{2,2}]}]},_]}
		],

		Example[
			{Basic,"Second order interactions:"},
			secondOrder[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2},{2,2}]}],Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"]]},{}]],
			{{}}
		],

		Example[
			{Basic,"Second order interactions:"},
			secondOrder[Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"]]},{Bond[{1,2},{2,1}]}],Structure[{Strand[DNA[20,"B'"],DNA[20,"A'"]]},{}]],
			{Reaction[{Structure[{Strand[DNA[20,"B'"],DNA[20,"A'"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"]]},{Bond[{1,2},{2,1}]}]},{Structure[{Strand[DNA[20,"B'"]],Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"A'"]]},{Bond[{1,1},{2,2}],Bond[{2,1},{3,2}]}]},_],{}}
		]
}];



(* ::Subsubsection::Closed:: *)
(*Hybridize*)

DefineTests[Hybridize,
{
	Example[{Basic,"Hybridize two strands:"},
		Hybridize[Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"C'"]]],
		{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B'"],DNA[20,"C'"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[20,"C'"]]},{Bond[{1,2},{2,1}]}]}
	],

	Example[{Basic,"Hybridize two strands:"},
		Hybridize[Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]]],
		{Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]]},{Bond[{1,2},{2,2}]}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]]},{Bond[{1,3},{2,2}]}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]],Strand[DNA[20,"C'"],DNA[20,"B'"],DNA[20,"C'"]]},{Bond[{1,2},{2,2}],Bond[{1,3},{3,2}]}]}
	],

	Example[{Options, Depth, "Specify depth in hybridyzation:"},
		Hybridize[Strand[DNA[20,"A"],DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[20,"C'"]], Depth->2],
		{Structure[{Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[20, "B'"], DNA[20, "C'"]]}, {}], Structure[{Strand[DNA[20, "B'"], DNA[20, "C'"]], Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]]}, {Bond[{1, 1}, {2, 2}]}], Structure[{Strand[DNA[20, "B'"], DNA[20, "C'"]], Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]]}, {Bond[{1, 2}, {2, 3}]}], Structure[{Strand[DNA[20, "B'"], DNA[20, "C'"]], Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {3, 3}]}], Structure[{Strand[DNA[20, "B'"], DNA[20, "C'"]], Strand[DNA[20, "B'"], DNA[20, "C'"]], Strand[DNA[20, "A"], DNA[20, "B"], DNA[20, "C"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 2}, {3, 3}]}]}
	]
}];



(* ::Subsubsection::Closed:: *)
(*pairAndSplit*)

DefineTests[pairAndSplit,{
Test[pairAndSplit[Structure[{Strand[DNA[20,"C'"],DNA[20,"B'"]]},{}],Structure[{Strand[DNA[20,"A"],DNA[20,"B"]]},{}],{Bond[{1,2},{1,2}]}],
	{Structure[{Strand[DNA[20,"A"],DNA[20,"B"]],Strand[DNA[20,"C'"],DNA[20,"B'"]]},{Bond[{1,2},{2,2}]}]}]
}];



(* ::Subsection:: *)
(*SimulateReactivity*)

(* ::Subsubsection:: *)
(*SimulateReactivity*)

DefineTestsWithCompanions[SimulateReactivity,{
	Example[{Basic, "Initial state can be specified as a list of species without concentration:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["TTCAAGCAGATG"]]},{}], Structure[{Strand[DNA["TATTTCGGAAGCGAT"]]},{}]}]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["TTCAAGCAGATG"]]},{}], Structure[{Strand[DNA["TATTTCGGAAGCGAT"]]},{}]}] =
			SimulateReactivity[{Structure[{Strand[DNA["TTCAAGCAGATG"]]},{}], Structure[{Strand[DNA["TATTTCGGAAGCGAT"]]},{}]}, Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Basic, "Initial state can be specified as a list of rules:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["ACACAGGAATAATC"]]}, {}]->Quantity[1, "Micromoles"/"Liters"],  Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTATTCT"]], Strand[DNA["ACAAATCGACTCAGGACATC"]]}, {Bond[{1, 1,1;;20}, {2, 1,1;;20}]}]->Quantity[1, "Micromoles"/"Liters"]}]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["ACACAGGAATAATC"]]}, {}]->Quantity[1, "Micromoles"/"Liters"],  Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTATTCT"]], Strand[DNA["ACAAATCGACTCAGGACATC"]]}, {Bond[{1, 1,1;;20}, {2, 1,1;;20}]}]->Quantity[1, "Micromoles"/"Liters"]}] =
			SimulateReactivity[{Structure[{Strand[DNA["ACACAGGAATAATC"]]}, {}]->Quantity[1, "Micromoles"/"Liters"],  Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTATTCT"]], Strand[DNA["ACAAATCGACTCAGGACATC"]]}, {Bond[{1, 1,1;;20}, {2, 1,1;;20}]}]->Quantity[1, "Micromoles"/"Liters"]}, Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Basic, "Generate a ReactionMechanism from sequence interactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["CCGGTCGTAGTACCA"]]}, {}], Quantity[1, "Micromoles"/"Liters"]}, {Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTCCCGATTAGGCT"]], Strand[DNA["ACAAATCGACTCAGGACATCAAGGGATTTCCGTA"]]}, {Bond[{1, 1, 1 ;; 20}, {2, 1, 1 ;; 20}]}], Quantity[1, "Micromoles"/"Liters"]}]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["CCGGTCGTAGTACCA"]]}, {}], Quantity[1, "Micromoles"/"Liters"]}, {Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTCCCGATTAGGCT"]], Strand[DNA["ACAAATCGACTCAGGACATCAAGGGATTTCCGTA"]]}, {Bond[{1, 1, 1 ;; 20}, {2, 1, 1 ;; 20}]}], Quantity[1, "Micromoles"/"Liters"]}]] =
			SimulateReactivity[State[{Structure[{Strand[DNA["CCGGTCGTAGTACCA"]]}, {}], Quantity[1, "Micromoles"/"Liters"]}, {Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT"], DNA["TGATTCCCGATTAGGCT"]], Strand[DNA["ACAAATCGACTCAGGACATCAAGGGATTTCCGTA"]]}, {Bond[{1, 1, 1 ;; 20}, {2, 1, 1 ;; 20}]}], Quantity[1, "Micromoles"/"Liters"]}], Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Basic, "Generate a ReactionMechanism from motif interactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}]] =
			SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}], Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Basic, "Add reaction rates to the input ReactionMechanism:"},
		Show[PlotReactionMechanism[SimulateReactivity[ReactionMechanism[Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 6 ;; 10}, {2, 10 ;; 14}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 7}, {2, 12 ;; 17}]}]}, Hybridization, Dissociation]]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[ReactionMechanism[Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 6 ;; 10}, {2, 10 ;; 14}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 7}, {2, 12 ;; 17}]}]}, Hybridization, Dissociation]]] =
			SimulateReactivity[ReactionMechanism[Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 4}, {1, 9 ;; 11}]}]}, Folding, Melting], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 6 ;; 10}, {2, 10 ;; 14}]}]}, Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AAAATTTTCGCGATCG"]], Strand[DNA["ACGTACGTACGAAATTTAAGG"]]}, {Bond[{1, 2 ;; 7}, {2, 12 ;; 17}]}]}, Hybridization, Dissociation]], Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Test["Generate a ReactionMechanism from sequence interactions:",
		SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTT"],DNA["ACCCCCGA"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TTTTCCGATCGATA"]],Strand[DNA["TATGGGGGT"]]},{}],1Micro Molar}],Upload->False, Depth->2],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation,ReactionMechanism],
			{
				ReactionMechanism->ReactionMechanismP
			},
			ResolvedOptions->{
				Method->Base
			}
		],
		TimeConstraint->300
	],

	Test["Generate a ReactionMechanism from motif interactions:",
		SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}],Upload->False, Depth->2],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation,ReactionMechanism],
			{
				ReactionMechanism->ReactionMechanismP
			},
			ResolvedOptions->{
				Method->Motif
			}
		],
		TimeConstraint->300
	],

	Test["Initial state can be specified as a list of rules:",
		SimulateReactivity[{Structure[{Strand[DNA["AGAATAATCA", "A"], DNA["ACAAATCGACTCAGGACATC", "B"]]}, {}]->Quantity[1, "Micromoles"/"Liters"],  Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT", "Bp"], DNA["TGATTATTCT", "Ap"]], Strand[DNA["ACAAATCGACTCAGGACATC", "B"]]},    {Bond[{1, 1}, {2, 1}]}]->Quantity[1, "Micromoles"/"Liters"]},Upload->False, Depth->2],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation,ReactionMechanism],
			{
				ReactionMechanism->ReactionMechanismP
			},
			ResolvedOptions->{
				Method->Base
			}
		],
		TimeConstraint->300
	],

	(* ------ Options ------ *)
	Example[{Options, Depth, "By default Depth is 5, which first finds the products from input species then makes these products as reactants to find more reactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}]]],
		_Graphics,
		TimeConstraint->1000,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}] =
			SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Options, Depth, "Set Depth to 1 so that only the initial input structures are involved in reactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Depth->1]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Depth->1] =
			SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Depth->1, Output->Result, Upload->False][ReactionMechanism]
		}
	],
	Example[{Options, FoldingDepth, "Set FoldingDepth to 1 so that structures only fold once at each step:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Depth->1,FoldingDepth->1]]],
		_Graphics,
		TimeConstraint->300
	],
	Example[{Options, HybridizationDepth, "Set HybridizationDepth to 1 so that structures only hybridize once at each step:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["AATTTTCCTTTTCCTTTTTT"]], Strand[DNA["CCCCCGGAAAAAA"]]}, {Bond[{1, 9 ;; 14}, {2, 6 ;; 11}]}], Structure[{Strand[DNA["AAAAAAGGAAA"]]}, {}]}, Depth->1,HybridizationDepth->1]]],
		_Graphics,
		TimeConstraint->300
	],

	Example[{Options, InterStrandFolding, "Turn off InterStrandFolding so that hybridized structure does not further fold among strands:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["AAAAATTTCCCAAATTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], InterStrandFolding->False, Depth->1]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAAATTTCCCAAATTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], InterStrandFolding->False, Depth->1] =
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAAATTTCCCAAATTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], InterStrandFolding->False, Depth->1, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, IntraStrandFolding, "Turn off IntraStrandFolding so that hybridized structure does not further fold within strands:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["AAAATTCCCAAACCTTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], IntraStrandFolding->False, Depth->1]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAATTCCCAAACCTTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], IntraStrandFolding->False, Depth->1] =
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAATTCCCAAACCTTT"]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA["AAATTTAAATTTTT"]]}, {}], Quantity[1, "Micromolar"]}], IntraStrandFolding->False, Depth->1, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, MaxMismatch, "By default, MaxMismatch is set to 0, i.e. no mismatch in product sturcuture allowed:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], Depth->2, PrunePercentage->Quantity[0, Percent]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], Depth->2, PrunePercentage->Quantity[0, Percent]] =
			SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], Depth->2, PrunePercentage->Quantity[0, Percent], Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, MaxMismatch, "Allows 1 base mismatch to find more reactions with products having mismatch:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], MaxMismatch->1, Depth->2, PrunePercentage->Quantity[0, Percent]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], MaxMismatch->1, Depth->2, PrunePercentage->Quantity[0, Percent]] =
			SimulateReactivity[State[{Structure[{Strand[DNA["CCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], MaxMismatch->1, Depth->2, PrunePercentage->Quantity[0, Percent], Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, Method, "Default method is Base for explicit sequences to find reactions with respect to base pairing rules:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]},Method->Base, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]},Method->Base, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2] =
			SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]}, Method->Base, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, Method, "Use Motif method on explicit sequences to focus on motif level interactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]},Method->Motif, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]},Method->Motif, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2] =
			SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "A"], DNA["TCTGG", "B"]]}, {}], Structure[{Strand[DNA["TACGTACGACTACGCTCTGG", "A'"]]}, {}]}, Method->Motif, PrunePercentage->Quantity[0, "Percent"], MinFoldLevel->5, MinPairLevel->8, Depth->2, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, MinFoldLevel, "Use MinFoldLevel to specify minimum number of consecutive bases for folding:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[RNA["UUUUCGGUCGAUCGCGAAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinFoldLevel->5]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[RNA["UUUUCGGUCGAUCGCGAAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinFoldLevel->5] =
			SimulateReactivity[{Structure[{Strand[RNA["UUUUCGGUCGAUCGCGAAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinFoldLevel->5, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, MinPairLevel, "Use MinPairLevel to specify minimum number of consecutve bases for pairing:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[RNA["AUCGGUCGAUCGCGAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinPairLevel->7]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[RNA["AUCGGUCGAUCGCGAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinPairLevel->7] =
			SimulateReactivity[{Structure[{Strand[RNA["AUCGGUCGAUCGCGAA"]]}, {}], Structure[{Strand[RNA["UAUGAUUGCGAUCG"]]},{}]}, MinPairLevel->7, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, MinPieceSize, "Specify minimum number of consecutive paired bases required in a structure containing mismatches:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["CCCCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}],MaxMismatch->1, MinPieceSize ->2]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["CCCCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}],MaxMismatch->1, MinPieceSize ->2] =
			SimulateReactivity[State[{Structure[{Strand[DNA["CCCCTTTGGTGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["CCCACCAAAGG"]]},{}],1Micro Molar}], MaxMismatch->1, MinPieceSize ->2, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, PrunePercentage, "Turn PrunPercentage to 0 Percent so that all the reactions can be found:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["AAAGGTTGACCCAACTTT"]]},{}],10Micro Molar},{Structure[{Strand[DNA["CCCTTTGTAAGGA"]]},{}],10Micro Molar}], PrunePercentage->Quantity[0, "Percent"], Depth->1]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAGGTTGACCCAACTTT"]]},{}],10Micro Molar},{Structure[{Strand[DNA["CCCTTTGTAAGGA"]]},{}],10Micro Molar}], PrunePercentage->Quantity[0, "Percent"], Depth->1] =
			SimulateReactivity[State[{Structure[{Strand[DNA["AAAGGTTGACCCAACTTT"]]},{}],10Micro Molar},{Structure[{Strand[DNA["CCCTTTGTAAGGA"]]},{}],10Micro Molar}], PrunePercentage->Quantity[0, "Percent"], Depth->1, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options, Reactions, "Use Reactions option to find specific reactions instead of all possible reactions:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]}, Reactions->{MeltingReaction[Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]], ToeholdStrandExchangeReaction[Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]]}]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]}, Reactions->{MeltingReaction[Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]], ToeholdStrandExchangeReaction[Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]]}] =
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]}, Reactions->{MeltingReaction[Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]], ToeholdStrandExchangeReaction[Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]]}, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Options,Temperature,"Specify temperature as Null to keep reaction rate symbolic:"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTT"],DNA["CCCCCGA"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA["TTTTGATCGATCG"]],Strand[DNA["TATGGGGGT"]]},{}],Quantity[1,"Micromolar"]}], Temperature->Null]]],
		_Graphics,
		TimeConstraint->200,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTT"],DNA["CCCCCGA"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA["TTTTGATCGATCG"]],Strand[DNA["TATGGGGGT"]]},{}],Quantity[1,"Micromolar"]}], Temperature->Null] =
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTT"],DNA["CCCCCGA"]]},{}],Quantity[1,"Micromolar"]},{Structure[{Strand[DNA["TTTTGATCGATCG"]],Strand[DNA["TATGGGGGT"]]},{}],Quantity[1,"Micromolar"]}], Temperature->Null, Output->Result, Upload->False][ReactionMechanism]
		}
	],

	Example[{Options, Template, "Inherit options from existing Object[Simulation,ReactionMechanism] object reference:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID, ResolvedOptions]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]},{Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID, ResolvedOptions]] =
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]},{Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID, ResolvedOptions], Output->Result, Upload->False][ReactionMechanism]
		},
		SetUp :> (
			theTemplateObject =
			Upload[<|Type->Object[Simulation, ReactionMechanism], UnresolvedOptions->{Reactions->{MeltingReaction[ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]], ToeholdStrandExchangeReaction[ECL`Structure[{ECL`Strand[ECL`DNA["CCCCGGAAAA"]]}, {}], ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]]}}, ResolvedOptions->{Method->Base, Reactions->{MeltingReaction[ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]],  ToeholdStrandExchangeReaction[ECL`Structure[{ECL`Strand[ECL`DNA["CCCCGGAAAA"]]}, {}], ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]]}, Temperature->Quantity[37, "DegreesCelsius"], PrunePercentage-> Quantity[5, "Percent"], Time->Quantity[30, "Days"], MinFoldLevel->3, MinPairLevel->5, Depth->5, InterStrandFolding->True, IntraStrandFolding->True, MaxMismatch->0, MinPieceSize->1, Template->Null, Output->Results, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Template, "Inherit options from existing Object[Simulation,ReactionMechanism] object:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID]]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]},{Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID]] =
			SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]},{}], Structure[{Strand[DNA["ATTTTCCGGGGGG"]], Strand[DNA["TTCCCCCCCCCGGAAAAA"]]},{Bond[{1,6;;11},{2,8;;13}]}]}, Template->Object[Simulation, ReactionMechanism, theTemplateObjectID], Output->Result, Upload->False][ReactionMechanism]
		},
		SetUp :> (
			theTemplateObject =
			Upload[<|Type->Object[Simulation, ReactionMechanism], UnresolvedOptions->{Reactions->{MeltingReaction[ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]], ToeholdStrandExchangeReaction[ECL`Structure[{ECL`Strand[ECL`DNA["CCCCGGAAAA"]]}, {}], ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]]}}, ResolvedOptions->{Method->Base, Reactions->{MeltingReaction[ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]],  ToeholdStrandExchangeReaction[ECL`Structure[{ECL`Strand[ECL`DNA["CCCCGGAAAA"]]}, {}], ECL`Structure[{ECL`Strand[ECL`DNA["ATTTTCCGGGGGG"]], ECL`Strand[ECL`DNA["TTCCCCCCCCCGGAAAAA"]]}, {Bond[{1, Span[6, 11]}, {2, Span[8, 13]}]}]]}, Temperature->Quantity[37, "DegreesCelsius"], PrunePercentage-> Quantity[5, "Percent"], Time->Quantity[30, "Days"], MinFoldLevel->3, MinPairLevel->5, Depth->5, InterStrandFolding->True, IntraStrandFolding->True, MaxMismatch->0, MinPieceSize->1, Template->Null, Output->Results, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Time, "Set simulation time (only when using motif matching):"},
		Show[PlotReactionMechanism[SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}], Time->60 Second]]],
		_Graphics,
		TimeConstraint->300,
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}], Time->60 Second] =
			SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}], Time->60 Second, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Test["Specify temperature, which causes reaction rates to resolve to numerical values:",
		SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTCG"],DNA["ATCGCGAA"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TAGCTGATCGATCG"]]},{}],1Micro Molar}],Upload->False,Temperature->37*Celsius],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation,ReactionMechanism],
			{
				Temperature->Quantity[37, "DegreesCelsius"],
				ReactionMechanism->ReactionMechanismP
			},
			ResolvedOptions->{
				Method->Base
			},
			NullFields->{}
		],
		TimeConstraint->300
	],

	Test["Empty ReactionMechanism if use Motif method on sequences with no reverse compliment:",
		SimulateReactivity[{Structure[{Strand[DNA["CCAGAGCGTAGTCGTACGTA", "Probe"]]}, {}], Structure[{Strand[DNA["ATCATGCTACGTACGACTACGCTCTGG", "Target"]]}, {}]}, Method->Motif, Output->Result, Upload->False][ReactionMechanism],
		ReactionMechanism[],
		TimeConstraint->300
	],

	(* ------ Messages ------ *)
	Example[{Messages, "UnsupportedMethod", "Cannot use Base method on degenerate sequences:"},
		Show[PlotReactionMechanism[SimulateReactivity[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]}, Method->Base]]],
		_Graphics,
		Messages :> {Warning::UnsupportedMethod},
		TimeConstraint->500,
		Stubs :> {
			SimulateReactivity[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]}, Method->Base] =
			SimulateReactivity[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]}, Method->Base, Upload->False, Output->Result][ReactionMechanism]
		}
	],

	Example[{Messages, "InconsistentReactants", "Structures specified in Reactions option must exist in input:"},
		SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}],  Structure[{Strand[DNA["AAAATTTTCCGGGG"]], Strand[DNA["GGGAAAAGGAAAAGGGG"]], Strand[DNA["TTTTGGAAAA"]]}, {Bond[{1, 5 ;; 10}, {2, 8 ;; 13}], Bond[{1, 1 ;; 4}, {3, 1 ;; 4}]}]}, Reactions->{MeltingReaction[Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]]}],
		$Failed,
		Messages :> {Error::InconsistentReactants, Message[Error::InvalidInput]}
	],

	(* ------ Applications ------ *)
	Example[{Applications, "Generate a ReactionMechanism from initial state then call SimulateEquilibrium to simulate the equilibrium state of the ReactionMechanism:"},
		Module[{initialState, mech},
			initialState = State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}];
			mech = SimulateReactivity[initialState, MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"]][ReactionMechanism];
			PlotState[SimulateEquilibrium[mech, initialState]]
		],
		ValidGraphicsP[],
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"]] =
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"], Output->Result, Upload->False],
			SimulateEquilibrium[x_, State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}]] =
			SimulateEquilibrium[x, State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], Upload->False]
		},
		TimeConstraint->500
	],

	Example[{Applications, "Instead of simulate equilibrium state directly, you can also call SimulateKinetics to simulate the kinetic trajectory of the ReactionMechanism to see concentration changes with respect to time:"},
		Module[{initialState, mech},
			initialState = State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}];
			mech = SimulateReactivity[initialState, MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"], Output->Result, Upload->False][ReactionMechanism];
			PlotTrajectory[SimulateKinetics[mech, initialState, 60 Second]]
		],
		ValidGraphicsP[],
		Stubs :> {
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"]] =
			SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], MinFoldLevel->5, MinPairLevel->8, Depth->2, PrunePercentage->Quantity[0, "Percent"], Output->Result, Upload->False][ReactionMechanism],
			SimulateKinetics[x_, State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], 60 Second] =
			SimulateKinetics[x, State[{Structure[{Strand[DNA["ATCGGTTTTTT"],DNA["CCCCCGGGGGG"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TATGGGGGAAAAAA"]]},{}],1Micro Molar}], 60 Second, Upload->False]
		},
		TimeConstraint->500
	],

	(* ------ Tests ------ *)
	Test["UnresolvedOptions with missing or invalid options causes failure:",
		SimulateReactivity[State[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],1Micro Molar},{Structure[{Strand[DNA[20,"B'"],DNA[10,"A'"]],Strand[DNA[20,"B"],DNA[20,"C"]]},{Bond[{1,1},{2,1}]}],1Micro Molar}],Temperature->50*Celsius,Plus->True,Method->"string", Upload->False, Depth->1, PrunePercentage->Quantity[0, "Percent"]],
		$Failed,
		Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
	],

	Test["Generate two mechanisms containing forward and reverse reactions, and check consistency for reversible reaction kinetic rates:",
		{{kf,kr}}=SimulateReactivity[ReactionMechanism[Reaction[
			{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]},
			{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
			Folding, Melting]], Upload->False, Output->Result][ReactionMechanism][Rates];
		{{Kr,Kf}}=SimulateReactivity[ReactionMechanism[Reaction[
			{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}]}]},
			{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]},
			Melting,Folding]], Upload->False, Output->Result][ReactionMechanism][Rates];
		And[Kf==kf,Kr==kr],
		True
	],

	Test["Generate ReactionMechanism containing all possible interactions between given structures:",
		SimulateReactivity[{Structure[{Strand[DNA["ATCGATCG"]]},{}],Structure[{Strand[DNA["AAATTT"]]},{}]}, Depth->1, Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Given only one Structure:",
		SimulateReactivity[{Structure[{Strand[DNA["ACGTACCCGTACGT"]]},{}]}, Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Given two Structures:",
		SimulateReactivity[{Structure[{Strand[DNA["TTTGGTAAAAATGGG"]]},{}], Structure[{Strand[DNA["GCTGTTTTTCGAAAA"]]},{}]}, Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Generate ReactionMechanism considering only folds of specified Structure:",
		SimulateReactivity[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}]}, Reactions->{FoldingReaction[Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}]]}, Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Another Structure:",
		SimulateReactivity[{Structure[{Strand[RNA["ACGUACGUACGUACGU"]]},{}]}, Reactions->{FoldingReaction[Structure[{Strand[RNA["ACGUACGUACGUACGU"]]},{}]]}, Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Generate ReactionMechanism considering only Pairing of specified Structure with itself:",
		SimulateReactivity[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}]}, Reactions->{HybridizationReaction[Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}]]},MinPairLevel->3,  Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP
	],

	Test["Specify multiple types of interactions to include:",
		SimulateReactivity[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}],Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]},{}]}, Reactions->{FoldingReaction[Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}]], HybridizationReaction[Structure[{Strand[DNA["ACGTACGTACGTACGT"]]},{}],Structure[{Strand[DNA["AAAATTTTCGCGATCG"]]},{}]]},MinPairLevel->3,MinFoldLevel->2, Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 6}, {1, 11 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[1.263187150084189, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 4}, {1, 9 ;; 12}], Bond[{1, 5 ;; 8}, {1, 13 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[70.62955187792942, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 7 ;; 8}], Bond[{1, 3 ;; 4}, {1, 9 ;; 10}], Bond[{1, 5 ;; 6}, {1, 11 ;; 12}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[243389.945611835, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 7 ;; 8}], Bond[{1, 3 ;; 4}, {1, 9 ;; 10}], Bond[{1, 5 ;; 6}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[891288.6169762191, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 7 ;; 8}], Bond[{1, 3 ;; 6}, {1, 11 ;; 14}], Bond[{1, 9 ;; 10}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[309.18120789029217, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 7 ;; 8}], Bond[{1, 3 ;; 4}, {1, 13 ;; 14}], Bond[{1, 5 ;; 6}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[3468.4355575236114, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 11 ;; 12}], Bond[{1, 3 ;; 4}, {1, 13 ;; 14}], Bond[{1, 9 ;; 10}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[45763.4371974216, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 1 ;; 2}, {1, 11 ;; 12}], Bond[{1, 7 ;; 8}, {1, 13 ;; 14}], Bond[{1, 9 ;; 10}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[891288.6169762191, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {}]}, {Structure[{Strand[DNA["ACGTACGTACGTACGT"]]}, {Bond[{1, 5 ;; 6}, {1, 11 ;; 12}], Bond[{1, 7 ;; 8}, {1, 13 ;; 14}], Bond[{1, 9 ;; 10}, {1, 15 ;; 16}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[243389.945611835, "Seconds"^(-1)]]],
		EquivalenceFunction->RoundMatchQ[4]
	],

	Test["Specify multiple types of interactions to include:",
		SimulateReactivity[{Structure[{Strand[DNA["ATCGATCGATCG"]]},{}],Structure[{Strand[DNA["AATCGATCGAATT"]]},{}]}, Reactions->{HybridizationReaction[Structure[{Strand[DNA["ATCGATCGATCG"]]},{}],Structure[{Strand[DNA["AATCGATCGAATT"]]},{}]]}, Output->Result, Upload->False][ReactionMechanism],
		ReactionMechanism[Reaction[{Structure[{Strand[DNA["AATCGATCGAATT"]]}, {}], Structure[{Strand[DNA["ATCGATCGATCG"]]}, {}]}, {Structure[{Strand[DNA["AATCGATCGAATT"]], Strand[DNA["ATCGATCGATCG"]]}, {Bond[{1, 2 ;; 10}, {2, 2 ;; 10}]}]}, Quantity[350000.0000000007, 1/("Molar"*"Seconds")], Quantity[0.10793229333358256, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["AATCGATCGAATT"]], Strand[DNA["ATCGATCGATCG"]]}, {Bond[{1, 2 ;; 7}, {2, 1 ;; 6}]}]}, {Structure[{Strand[DNA["AATCGATCGAATT"]], Strand[DNA["ATCGATCGATCG"]]}, {Bond[{1, 2 ;; 7}, {2, 1 ;; 6}], Bond[{1, 8 ;; 10}, {2, 10 ;; 12}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[0.8839869920279745, "Seconds"^(-1)]], Reaction[{Structure[{Strand[DNA["AATCGATCGAATT"]], Strand[DNA["ATCGATCGATCG"]]}, {Bond[{1, 4 ;; 10}, {2, 6 ;; 12}]}]}, {Structure[{Strand[DNA["AATCGATCGAATT"]], Strand[DNA["ATCGATCGATCG"]]}, {Bond[{1, 1 ;; 3}, {1, 11 ;; 13}], Bond[{1, 4 ;; 10}, {2, 6 ;; 12}]}]}, Quantity[14000., "Seconds"^(-1)], Quantity[10285.977042388202, "Seconds"^(-1)]]],
		EquivalenceFunction->RoundMatchQ[4]
	],

	Test["Generate ReactionMechanism from state:",
		SimulateReactivity[State[{Structure[{Strand[DNA["AGAATAATCA","A"],DNA["ACAAATCGACTCAGGACATC","B"]]},{}],(Micro Mole)/Liter},{Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT","Bp"],DNA["TGATTATTCT","Ap"]],Strand[DNA["ACAAATCGACTCAGGACATC","B"],DNA["TTGAAAATGACCCGAGATGG","C"]]},{Bond[{1,1},{2,1}]}],(Micro Mole)/Liter}], Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP,
		TimeConstraint->300
	],

	Test["Another sequence ReactionMechanism test:",
		SimulateReactivity[State[{Structure[{Strand[DNA["AGAATAATCA","A"],DNA["ACAAATCGACTCAGGACATC","B"]]},{}],Micro Mole/Liter},{Structure[{Strand[DNA["GATGTCCTGAGTCGATTTGT","Bp"],DNA["TGATTATTCT","Ap"]],Strand[DNA["ACAAATCGACTCAGGACATC","B"],DNA["TTGAAAATGACCCGAGATGG","C"]]},{Bond[{1,1},{2,1}]}],Micro Mole / Liter}], Depth->1, PrunePercentage->Quantity[0, "Percent"], Upload->False, Output->Result][ReactionMechanism],
		ReactionMechanismP,
		TimeConstraint->300
	],

	Test["Create object from States:",
		SimulateReactivity[State[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], 1 Micro Molar}, {Structure[{Strand[DNA[20, "B'"], DNA[10, "A'"]], Strand[DNA[20, "B"], DNA[20, "C"]]}, {Bond[{1, 1}, {2, 1}]}], 1 Micro Molar}], Depth->1, PrunePercentage->Quantity[0, "Percent"]],
		ObjectReferenceP[Object[Simulation, ReactionMechanism]]
	],

	Test["Create object from Structures:",
		SimulateReactivity[{Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], 	Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 		8 ;; 13}]}]}, Reactions->{MeltingReaction[Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]], ToeholdStrandExchangeReaction[Structure[{Strand[DNA["CCCCGGAAAA"]]}, {}], Structure[{Strand[DNA["ATTTTCCTTTTGG"]], Strand[DNA["TTCCCCCGGAAAAAAAAA"]]}, {Bond[{1, 6 ;; 11}, {2, 8 ;; 13}]}]]}, Depth->1, PrunePercentage->Quantity[0, "Percent"]],
		ObjectReferenceP[Object[Simulation, ReactionMechanism]]
	],

	Test["Create object from single State:",
		SimulateReactivity[State[{Structure[{Strand[DNA["ATCGGTTT"],DNA["CCCCCGA"]]},{}],1Micro Molar},{Structure[{Strand[DNA["TTTTGATCGATCG"]],Strand[DNA["TATGGGGGT"]]},{}],1Micro Molar}], Depth->1, PrunePercentage->Quantity[0, "Percent"]],
		ObjectReferenceP[Object[Simulation, ReactionMechanism]]
	]

},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force->True, Verbose->False];
		Unset[$CreatedObjects];
	)
];
