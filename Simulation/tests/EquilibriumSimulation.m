(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*EquilibriumSimulation: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*SimulateEquilibrium*)


(* ::Subsubsection:: *)
(*SimulateEquilibrium*)


DefineTestsWithCompanions[SimulateEquilibrium,{

	Example[{Basic,"Model can be specified as list of reactions:"},
		PlotState[SimulateEquilibrium[{{a+b\[Equilibrium]c,1 / ( Second* Molar),3 / Second}},{a->1 Molar,b->0.6 Molar}]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[{{a+b\[Equilibrium]c,1 / ( Second* Molar),3 / Second}},{a->1 Molar,b->0.6 Molar}]
			=
			SimulateEquilibrium[{{a+b\[Equilibrium]c,1 / ( Second* Molar),3 / Second}},{a->1 Molar,b->0.6 Molar}, Upload -> False]
		}
	],

	Test["Model can be specified as list of reactions:",
		SimulateEquilibrium[{{a+b\[Equilibrium]c,1 / ( Second* Molar),3 / Second}},{a->1 Molar,b->0.6 Molar},Upload->False],
		validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				Temperature -> Quantity[37, "DegreesCelsius"],
				EquilibriumState -> State[{a, Quantity[0.8656407827707711, "Molar"]}, {b, Quantity[0.4656407827707715, "Molar"]}, {c, Quantity[0.1343592172292284, "Molar"]}]
			},
			Round->8
		],
		TimeConstraint->120
	],

	Example[{Basic,"Compute the equilibrium of a ReactionMechanism from an initial state:"},
		PlotState[SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}]
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}]
			]
			=
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Upload->False
			]
		}
	],

	Test["Compute the equilibrium of a ReactionMechanism from an initial state:",
		SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Upload->False
		],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				Temperature -> Quantity[37, "DegreesCelsius"],
				EquilibriumState -> StateP
			},
			Round->5
		],
		TimeConstraint->120
	],

	Example[{Basic,"Compute the equilibrium of a ReactionMechanism from a list of initial condition(s):"},
		PlotState[SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}] -> Micro Molar}
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}] -> Micro Molar}
			]
			=
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}] -> Micro Molar},
				Upload->False
			]
		}
	],

	(* ------ Additional -------*)

	Example[{Additional, "Input a ReactionMechanism model and a list of initial conditions:"},
		PlotState[SimulateEquilibrium[Model[ReactionMechanism,"id:E8zoYveXBOlm"],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[Model[ReactionMechanism,"id:E8zoYveXBOlm"],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}]
			=
			SimulateEquilibrium[Model[ReactionMechanism,"id:E8zoYveXBOlm"],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}, Upload -> False]
		}
	],

	Test["Input a ReactionMechanism model and a list of initial conditions:",
		SimulateEquilibrium[Model[ReactionMechanism,"id:E8zoYveXBOlm"],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}, Upload -> False],
		validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				EquilibriumState -> State[{Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]}, {}], Quantity[0.5232928049865333, "Molar"]}, {Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {}], Quantity[0.32329280498653373, "Molar"]}, {Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 17 ;; 22}, {2, 4 ;; 9}]}], Quantity[0.1903238985975385, "Molar"]}, {Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 5 ;; 11}, {2, 15 ;; 21}]}], Quantity[0.2326180982858804, "Molar"]}, {Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 5 ;; 11}, {2, 15 ;; 21}], Bond[{1, 14 ;; 22}, {2, 4 ;; 12}]}], Quantity[0.25376519813005133, "Molar"]}],
				Append[Species] -> {Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]}, {}], Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {}], Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 17 ;; 22}, {2, 4 ;; 9}]}], Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 5 ;; 11}, {2, 15 ;; 21}]}], Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]], Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]}, {Bond[{1, 5 ;; 11}, {2, 15 ;; 21}], Bond[{1, 14 ;; 22}, {2, 4 ;; 12}]}]}
			},
			Round->8
		],
		TimeConstraint->120
	],

	Test["ReactionMechanism model Link:",
		SimulateEquilibrium[Link[Model[ReactionMechanism,"id:E8zoYveXBOlm"]],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}, Upload -> False],
		validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
			},
			Round->8
		],
		TimeConstraint->120
	],

	Test["ReactionMechanism model Packet:",
		SimulateEquilibrium[Download[Model[ReactionMechanism,"id:E8zoYveXBOlm"]],{Structure[{Strand[DNA["CTGGAAATGCCGGCGTAGGCTT"]]},{}] -> 1 Molar, Structure[{Strand[DNA["CATAAGCCTATTTCGGCATTTC"]]},{}] -> 1.2 Molar}, Upload -> False],
		validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
			},
			Round->8
		],
		TimeConstraint->120
	],

	Example[{Additional, "Construct a ReactionMechanism from folding results under two-state assumption then calculate equilibrium:"},
		PlotState[SimulateEquilibrium[Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}]
			=
			SimulateEquilibrium[Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False]
		}
	],

	Test["Construct a ReactionMechanism from folding results under two-state assumption then calculate equilibrium:",
		SimulateEquilibrium[Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				Temperature -> Quantity[37, "DegreesCelsius"],
				Append[Species] -> {StructureP..}
			},
			Round->6
		],
		TimeConstraint->120
	],

	Test["Folding Packet:",
		SimulateEquilibrium[Download@Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
			},
			Round->6
		],
		TimeConstraint->120
	],

	Test["Folding Link:",
		SimulateEquilibrium[Link[Object[Simulation,Folding,"id:4pO6dMWLBWbX"]],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
			},
			Round->6
		],
		TimeConstraint->120
	],

	Example[{Additional, "Construct a ReactionMechanism on a list of structures folded from the same sequence under two-state assumption then calculate equilibrium:"},
		PlotState[SimulateEquilibrium[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 3, 1 ;; 3}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 4 ;; 4}, {1, 4, 3 ;; 3}], Bond[{1, 3, 1 ;; 2}, {1, 4, 1 ;; 2}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 3 ;; 4}, {1, 4, 2 ;; 3}], Bond[{1, 3, 1 ;; 1}, {1, 4, 1 ;; 1}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 2 ;; 4}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 4, 1 ;; 3}]}]},{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 3, 1 ;; 3}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 4 ;; 4}, {1, 4, 3 ;; 3}], Bond[{1, 3, 1 ;; 2}, {1, 4, 1 ;; 2}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 3 ;; 4}, {1, 4, 2 ;; 3}], Bond[{1, 3, 1 ;; 1}, {1, 4, 1 ;; 1}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 2 ;; 4}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 4, 1 ;; 3}]}]},{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}]
			=
			SimulateEquilibrium[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 3, 1 ;; 3}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 4 ;; 4}, {1, 4, 3 ;; 3}], Bond[{1, 3, 1 ;; 2}, {1, 4, 1 ;; 2}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 3 ;; 4}, {1, 4, 2 ;; 3}], Bond[{1, 3, 1 ;; 1}, {1, 4, 1 ;; 1}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 2 ;; 4}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 4, 1 ;; 3}]}]},{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False]
		}
	],

	Test["Construct a ReactionMechanism from folding results under two-state assumption then calculate equilibrium:",
		SimulateEquilibrium[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 3, 1 ;; 3}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 4 ;; 4}, {1, 4, 3 ;; 3}], Bond[{1, 3, 1 ;; 2}, {1, 4, 1 ;; 2}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 3 ;; 4}, {1, 4, 2 ;; 3}], Bond[{1, 3, 1 ;; 1}, {1, 4, 1 ;; 1}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 2, 2 ;; 4}, {1, 4, 1 ;; 3}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1, 1 ;; 3}, {1, 4, 1 ;; 3}]}]},{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Upload -> False],
		Simulation`Private`validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				Temperature -> Quantity[37, "DegreesCelsius"],
				EquilibriumState -> State[{Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {}], Quantity[0.062217815800034056, "Molar"]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Quantity[0.5838810613407756, "Molar"]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Quantity[0.13556394438648395, "Molar"]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}], Quantity[0.09799756057307743, "Molar"]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}], Quantity[0.08332029506446056, "Molar"]}, {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}]}], Quantity[0.03701932283516787, "Molar"]}],
				Append[Species] -> {Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 8 ;; 10}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 7 ;; 9}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 6 ;; 8}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 5 ;; 7}, {1, 16 ;; 18}]}], Structure[{Strand[DNA["CCC"], DNA["ACCC"], DNA["CCCAAAAA"], DNA["GGG"]]}, {Bond[{1, 1 ;; 3}, {1, 16 ;; 18}]}]}
			},
			Round->6
		],
		TimeConstraint->120
	],

	Example[{Additional, "If input is a single reaction, it will be treated as a ReactionMechanism with only one reaction:"},
		PlotState[SimulateEquilibrium[{a+b\[Equilibrium]c,1/(Second Molar),3/Second},{a->1 Molar,b->0.6 Molar}]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[{a+b\[Equilibrium]c,1/(Second Molar),3/Second},{a->1 Molar,b->0.6 Molar}]
			=
			SimulateEquilibrium[{a+b\[Equilibrium]c,1/(Second Molar),3/Second},{a->1 Molar,b->0.6 Molar}, Upload -> False]
		}
	],

	Example[{Additional, "Return all species in the reaction system:"},
		SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Temperature->80Celsius
		][Species],
		{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 6}, {2, 17 ;; 22}]}], Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 10}, {2, 1 ;; 10}]}], Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 5}, {1, 6 ;; 10}]}], Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 6}, {1, 17 ;; 22}]}], Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 6 ;; 9}, {1, 18 ;; 21}]}]},
		TimeConstraint->120
	],

	Example[{Additional, "Return both initial and equilibrium states:"},
		SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Temperature->80Celsius
		][{InitialState, EquilibriumState}],
		{StateP, StateP},
		TimeConstraint->120
	],

	(* ------ Options ------ *)
	Example[{Options,Temperature,"Use Temperature option to specify temperature of the system:"},
		PlotState[SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Temperature->37Celsius
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Temperature->37Celsius
			]
			=
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Temperature->37Celsius,
				Upload->False
			]
		}
	],

	Example[{Options,Temperature,"Higher temperature results in more unbound state:"},
		PlotState[SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Temperature->80Celsius
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Temperature->80Celsius
			]
			=
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Temperature->80Celsius,
				Upload -> False
			]
		}
	],

	Test["Higher temperature results in more unbound state:",
		SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Temperature->80Celsius,
			Upload->False
		],
		validSimulationPacketP[
			Object[Simulation, Equilibrium],
			{
				Temperature -> Quantity[80, "DegreesCelsius"],
				EquilibriumState -> State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[2.2500753537851695*^-8, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 6}, {2, 17 ;; 22}]}], Quantity[5.402987054514442*^-15, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 10}, {2, 1 ;; 10}]}], Quantity[6.781174860652673*^-14, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 5}, {1, 6 ;; 10}]}], Quantity[9.756482854486837*^-7, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1 ;; 6}, {1, 17 ;; 22}]}], Quantity[1.0233780974009032*^-9, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 6 ;; 9}, {1, 18 ;; 21}]}], Quantity[8.274370256789667*^-10, "Molar"]}]
			},
			Round->5
		],
		TimeConstraint->120
	],

	Example[{Options, Template, "Inherit options from existing Object[Simulation,Equilibrium] field reference:"},
		PlotState[SimulateEquilibrium[ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Template->Object[Simulation, Equilibrium, theTemplateObjectID, ResolvedOptions]
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Template->Object[Simulation, Equilibrium, theTemplateObjectID, ResolvedOptions]
			]
				=
				SimulateEquilibrium[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
					State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
					Template->Object[Simulation, Equilibrium, theTemplateObjectID, ResolvedOptions], Upload -> False
				]
		},
		SetUp :> (
			theTemplateObject =
				Upload[<|Type->Object[Simulation, Equilibrium], UnresolvedOptions->{}, ResolvedOptions->{Temperature->Quantity[80, "Celsius"], Template->Null, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],
	Example[{Options, Template, "Inherit options from existing Object[Simulation,Equilibrium] object:"},
		PlotState[SimulateEquilibrium[ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Template->Object[Simulation, Equilibrium, theTemplateObjectID]
		]],
		ValidGraphicsP[],
		TimeConstraint->120,
		Stubs :> {
			SimulateEquilibrium[
				ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
				State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
				Template->Object[Simulation, Equilibrium, theTemplateObjectID]
			]
				=
				SimulateEquilibrium[
					ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
					State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
					Template->Object[Simulation, Equilibrium, theTemplateObjectID], Upload -> False
				]
		},
		SetUp :> (
			theTemplateObject =
				Upload[<|Type->Object[Simulation, Equilibrium], UnresolvedOptions->{}, ResolvedOptions->{Temperature->Quantity[80, "Celsius"], Template->Null, Upload->True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Test["Output option preview shows plot:",
		SimulateEquilibrium[Object[Simulation,Folding,"id:4pO6dMWLBWbX"],{Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,3,1;;3},{1,4,1;;3}]}] -> 1 Molar}, Output->Preview],
		ValidGraphicsP[],
		TimeConstraint->120
	],


(* ------ Messages ------ *)
	Example[{Messages, "InvalidMechanism", "Input ReactionMechanism should contain at least one reaction:"},
		SimulateEquilibrium[ReactionMechanism[], {a -> 1 Molar}],
		$Failed,
		Messages :> {Error::InvalidMechanism,Error::InvalidInput}
	],

	Example[{Messages, "InvalidStructureList", "The equilibrium state contains speices with substantial negative concentrations:"},
		SimulateEquilibrium[{Structure[{Strand[DNA["CCA"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,2,2;;4},{1,4,1;;3}]}],Structure[{Strand[DNA["CCC"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,1,1;;3},{1,4,1;;3}]}]}, {Structure[{Strand[DNA["CCA"],DNA["ACCC"],DNA["CCCAAAAA"],DNA["GGG"]]},{Bond[{1,2,2;;4},{1,4,1;;3}]}] -> 1 Molar}],
		$Failed,
		Messages :> {Error::InvalidStructureList,Error::InvalidInput}
	],

	Example[{Messages, "NegativeConcentration", "Input ReactionMechanism should contain at least one reaction:"},
 		PlotState[SimulateEquilibrium[{{a + b \[Equilibrium] c, 1/(Second*Molar), 3/Second}}, {a -> -1 Molar, b -> 0.6 Molar}]], ValidGraphicsP[],
 		Messages :> {Warning::NegativeConcentration},
		Stubs :> {
			SimulateEquilibrium[{{a + b \[Equilibrium] c, 1/(Second*Molar), 3/Second}}, {a -> -1 Molar, b -> 0.6 Molar}]
			=
			SimulateEquilibrium[{{a + b \[Equilibrium] c, 1/(Second*Molar), 3/Second}}, {a -> -1 Molar, b -> 0.6 Molar}, Upload->False]
		}],

	(* ------ Other tests ------ *)
	Test["Insert new object:",
		SimulateEquilibrium[
			ReactionMechanism[Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}]},Hybridization,Dissociation],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}]},Folding,Melting],Reaction[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}]},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}]},Folding,Melting]],
			State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],Micro Molar}],
			Upload->True
		],
		ObjectReferenceP[Object[Simulation, Equilibrium]],
		Stubs :> {Print[_] := Null}
	],

	Test["First order reversible:",
		SimulateEquilibrium[{{a\[Equilibrium]b,1,3}},{a->1}, Upload-> False][EquilibriumState],
		State[{a,0.7499999999999998`*Molar},{b,0.24999999999999992`*Molar}],
		EquivalenceFunction->RoundMatchQ[10],
		TimeConstraint->120
	],

		Test["First order irreversible:",
		SimulateEquilibrium[{{a->b,1}},{a->1}, Upload-> False][EquilibriumState],
		If[$VersionNumber===11.1,
			State[{a, Quantity[2.710505431213761*^-20, "Molar"]}, {b, Quantity[1.0000000000000002, "Molar"]}],
			State[{a, Quantity[3.3881317890172014*^-20, "Molar"]}, {b, Quantity[1., "Molar"]}]
		],
		EquivalenceFunction->RoundMatchQ[5],
		TimeConstraint->120
	],

	Test["Second order reversible:",
		SimulateEquilibrium[{{a+b\[Equilibrium]c,1,3}},{a->1,b->0.6}, Upload-> False][EquilibriumState],
		State[{a,0.8656407827707714`*Molar},{b,0.46564078277077137`*Molar},{c,0.13435921722922842`*Molar}],
		EquivalenceFunction->RoundMatchQ[10],
		TimeConstraint->120
	],

	Test["Second order irreversible:",
		SimulateEquilibrium[{{a+b->c,1}},{a->1,b->0.6}, Upload-> False][EquilibriumState],
		State[{a, Quantity[0.4000000000000002, "Molar"]}, {b, Quantity[0., "Molar"]}, {c, Quantity[0.6, "Molar"]}],
		EquivalenceFunction->RoundMatchQ[10],
		TimeConstraint->120
	],

	Test["UnresolvedOptions with missing or invalid options causes failure:",
		SimulateEquilibrium[{{a+b\[Equilibrium]c,1,3}},{a->1,b->0.6},Upload->False,Temperature->abc,Plus->True],
		$Failed,
		Messages:>{OptionValue::nodef,Error::UnknownOption,Error::Pattern}
	]
},

	SetUp :> ($CreatedObjects = {};),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	)
];


(* ::Section:: *)
(*End Test Package*)
