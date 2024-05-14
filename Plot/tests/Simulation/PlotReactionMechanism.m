(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotReactionMechanism*)


DefineTests[PlotReactionMechanism,{

	Example[{Basic,"Plot a ReactionMechanism:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},{Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}],Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},1],Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]},{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},1.`*^6]]]],
		_Graphics
	],
	Example[{Basic,"Plot a ReactionMechanism model:"},
		Show[PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"]]],
		_Graphics
	],
	Example[{Basic,"Plot a ReactionMechanism link:"},
		Show[PlotReactionMechanism[Link[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Reference]]],
		_Graphics
	],
	Test["Plot a ReactionMechanism packet:",
		Show[PlotReactionMechanism[Download[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"]]]],
		_Graphics
	],
	Example[{Basic,"Plot a ReactionMechanism with reversible reactions:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]]}, {}], Structure[{Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]}, {Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]], Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {Bond[{1, 1, 1 ;; 25}, {2, 1, 1 ;; 25}]}]},   Hybridization, Dissociation], Reaction[{Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]]}, {}]},   {Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]]}, {Bond[{1, 1, 8 ;; 10}, {1, 1, 23 ;; 25}]}]}, Folding, Melting],  Reaction[{Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]]}, {}]},   {Structure[{Strand[DNA["CCATACATAGGCGACGACAACGCTA"]]}, {Bond[{1, 1, 11 ;; 13}, {1, 1, 21 ;; 23}]}]}, Folding, Melting],  Reaction[{Structure[{Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]},   {Structure[{Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 1, 16 ;; 18}]}]}, Folding, Melting],  Reaction[{Structure[{Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {}]},   {Structure[{Strand[DNA["TAGCGTTGTCGTCGCCTATGTATGG"]]}, {Bond[{1, 1, 3 ;; 5}, {1, 1, 13 ;; 15}]}]}, Folding, Melting]]]],
		_Graphics
	],


	Example[{Options,Tooltip,"Do not show mouseover reactions:"},
		Show[PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Tooltip->False]],
		_Graphics
	],
	Example[{Options,Style,"Display as Vopert graph:"},
		PlotReactionMechanism[
			ReactionMechanism[Reaction[{a, b}, {c}, kf1],
				Reaction[{b}, {e, f}, kf2, kb2], Reaction[{f, a}, {r}, kf3, kb3]],
			Style -> Volpert],
		_Graphics
	],

	Example[{Options,Display,"Resolve each strand and structure separately as either MotifForm or StructureForm:"},
		Show[PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Display->Automatic]],
		_Graphics
	],

	Example[{Options,Disks,"Display disks instead of structures.  Useful for large mechanisms:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},{Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}],Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},1],Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]},{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},1.`*^6]],Disks->True]],
		_Graphics
	],
	(* Example[{Options,ImageSize,"Specify image size:"},
		PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],ImageSize->1000],
		_Graph
	], *)
	Example[{Options,NetworkInput,"Specify input to network, which will be highlighted in the plot:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},{Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}],Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},1],Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]},{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},1.`*^6]],NetworkInput->Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}]]],
		_Graphics
	],
	Example[{Options,NetworkOutput,"Specify output of network, which will be highlighted in the plot:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},{Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}],Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},1],Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]},{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},1.`*^6]],NetworkOutput->Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}]]],
		_Graphics
	],

	Example[{Options,DirectedEdges,"Remove the direction of the edges:"},
		PlotReactionMechanism[
			ReactionMechanism[Reaction[{a, b}, {c}, kf1],
				Reaction[{b}, {e, f}, kf2, kb2], Reaction[{f, a}, {r}, kf3, kb3]],
			Style -> Complex,DirectedEdges->False
		],
		_Graphics
	],

	Example[{Additional,"If you specify both Input and Output species, a path between the two will be highlighted in the plot:"},
		Show[PlotReactionMechanism[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},{Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}],Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,2}],Bond[{1,2},{2,1}]}]},1],Reaction[{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],Structure[{Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{2,1}]}]},{Structure[{Strand[DNA[10,"A"],DNA[20,"B"]],Strand[DNA[20,"B"],DNA[20,"C"]],Strand[DNA[20,"B'"],DNA[10,"A'"]]},{Bond[{1,1},{3,2}],Bond[{2,1},{3,1}]}]},1.`*^6]],NetworkInput->Structure[{Strand[DNA[10,"A"],DNA[20,"B"]]},{}],NetworkOutput->Structure[{Strand[DNA[20,"B"],DNA[20,"C"]]},{}]]],
		_Graphics
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		Show[PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->Result]],
		_Graphics
	],

	Test["Setting Output to Preview returns the plot:",
		Show[PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->Preview]],
		_Graphics
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotReactionMechanism]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
		PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->{Result,Options}]/.{u_,v_}:>{Show[u],v},
		output_List/;MatchQ[First@output,_Graphics]&&MatchQ[Last@output,OptionsPattern[PlotReactionMechanism]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotReactionMechanism[Model[ReactionMechanism, "Tail-mediated one motif control translation simple mechanism, 5nt toeholds"],Output->Options],
		Sort@Keys@SafeOptions@PlotReactionMechanism
	]

}];
