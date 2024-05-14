(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*State: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*State*)


(* ::Subsubsection::Closed:: *)
(*State*)


DefineTests[State,{
	Example[{Basic,"A state containing species and their concentrations:"},
		State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}],
		StateP
	],
	Example[{Basic,"A state containing species and their amounts:"},
		State[{a,10Micromole},{b,20Micromole},{c,30Micromole}],
		StateP
	],
	Example[{Basic,"Plot the species concentrations:"},
		PlotState[State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Extract the conentration of a species:"},
		State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}][b],
		20Micromolar
	],

	Example[{Additional,"Properties","See the list of properties that can be dereferenced from a state:"},
		Keys[State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}]],
		{(_Symbol|_String)..}
	],
	Example[{Additional,"Properties","Get a list of the species in the state:"},
		State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}][Species],
		{a,b,c}
	],
	Example[{Additional,"Properties","Convert the state to a list of rules of the form species->concentration:"},
		State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}][Rules],
		{a->10Micromolar,b->20Micromolar,c->30Micromolar}
	],
	Example[{Additional,"Properties","Extract the unit of each species:"},
		State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}][Units],
		{1 Micromolar,1 Micromolar,1 Micromolar}
	],


	Example[{Applications,"Pull species from a state:"},
		SpeciesList[State[{a,10Micromolar},{b,20Micromolar},{c,30Micromolar}]],
		{a,b,c}
	]

}];


(* ::Subsection::Closed:: *)
(*Formats*)


(* ::Subsubsection::Closed:: *)
(*StateQ*)


DefineTests[StateQ,
{
		Example[
			{Basic,"Check if input is a properly formatted state:"},
			StateQ[State[{Structure[{Strand[DNA[5]]}],Micro Molar},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
			True
		],
		Example[
			{Basic,"States can be with or without concentrations:"},
			StateQ[State[{Structure[{Strand[DNA[5]]}]},{Structure[{Strand[DNA[5]]}]},{Structure[{Strand[DNA[5]]}]}]],
			True
		],
		Example[
			{Basic,"Improperly formatted:"},
			StateQ[State[{Structure[Strand[DNA[5]]]},Structure[Strand[DNA[5]]],{Structure[Strand[DNA[5]]]}]],
			False
		],
		Example[
			{Basic,"Bad concentration Units:"},
			StateQ[State[{Structure[{Strand[DNA[5]]}],Liter},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
			False
		]
}];


(* ::Subsection::Closed:: *)
(*Parsing*)


(* ::Subsubsection:: *)
(*stateToQuantities*)


DefineTests[stateToQuantities,{
	Test["",stateToQuantities[State[{"A",1.},{"B",2.5},{"C",3}]],{1.,2.5,3}],
	Test["",stateToQuantities[State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],{Molar,2.5Micromolar,3Nanomolar}]
}];


(* ::Subsubsection:: *)
(*stateToSpecies*)


DefineTests[stateToSpecies,{
	Test["",stateToSpecies[State[{"A",1.},{"B",2.5},{"C",3}]],{"A","B","C"}],
	Test["",stateToSpecies[State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],{"A","B","C"}]
}];



(* ::Subsection::Closed:: *)
(*Transforming*)


(* ::Subsubsection:: *)
(*rulesToState*)


DefineTests[rulesToState,{
	Test["",rulesToState[{"A"->1.,"B"->2.5,"C"->3}],State[{"A",1.},{"B",2.5},{"C",3}]],
	Test["",rulesToState[{"A"->Molar,"B"->2.5Micromolar,"C"->3Nanomolar}],State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],
	Test["",rulesToState[{"B"->2.5},{"A","B","C"}],State[{"A",0.},{"B",2.5},{"C",0.}]],
	Test["",rulesToState[{"B"->2.5Micromolar},{"A","B","C"},0.*Molar],State[{"A",0.*Molar},{"B",2.5Micromolar},{"C",0.*Molar}]]
}];


(* ::Subsubsection:: *)
(*pairedToState*)


DefineTests[pairedToState,{
	Test["",pairedToState[{{"A",1.},{"B",2.5},{"C",3}}],State[{"A",1.},{"B",2.5},{"C",3}]],
	Test["",pairedToState[{{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}}],State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],
	Test["",pairedToState[{{"B",2.5}},{"A","B","C"}],State[{"A",0.},{"B",2.5},{"C",0.}]],
	Test["",pairedToState[{{"B",2.5Micromolar}},{"A","B","C"},0.*Molar],State[{"A",0.*Molar},{"B",2.5Micromolar},{"C",0.*Molar}]]
}];


(* ::Subsubsection:: *)
(*stateToRules*)


DefineTests[stateToRules,{
	Test["",stateToRules[State[{"A",1.},{"B",2.5},{"C",3}]],{"A"->1.,"B"->2.5,"C"->3}],
	Test["",stateToRules[State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],{"A"->Molar,"B"->2.5Micromolar,"C"->3Nanomolar}]
}];


(* ::Subsubsection:: *)
(*stateToPaired*)


DefineTests[stateToPaired,{
	Test["",stateToPaired[State[{"A",1.},{"B",2.5},{"C",3}]],{{"A",1.},{"B",2.5},{"C",3}}],
	Test["",stateToPaired[State[{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}]],{{"A",Molar},{"B",2.5Micromolar},{"C",3Nanomolar}}]
}];


(* ::Subsection::Closed:: *)
(*Manipulation*)


(* ::Subsubsection::Closed:: *)
(*StateFirst*)


DefineTests[StateFirst,{
	Example[
		{Basic,"Pull first species from state:"},
		StateFirst[State[{a, (Micro*Mole)/Liter}, {b, (2*Milli*Mole)/Liter}, {c, 3}, {d, (3*Mole)/Liter}]],
		{a, (Micro*Mole)/Liter}
	],
	Example[
		{Basic,"Pull first species from state:"},
		StateFirst[State[{Structure[{Strand[DNA[5]]}],Micro Molar},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
		{Structure[{Strand[DNA[5]]}, {}], Quantity[1, "Micromolar"]}
	],
	Example[
		{Basic,"Pull first species from state:"},
		StateFirst[State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}]],
		{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StateLast*)


DefineTests[StateLast,{
	Example[
		{Basic,"Pull last species from state:"},
		StateLast[State[{a, (Micro*Mole)/Liter}, {b, (2*Milli*Mole)/Liter}, {c, 3}, {d, (3*Mole)/Liter}]],
		{d, (3*Mole)/Liter}
	],
	Example[
		{Basic,"Pull last species from state:"},
		StateLast[State[{Structure[{Strand[DNA[5]]}],Micro Molar},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
		{Structure[{Strand[DNA[5]]}, {}], Quantity[3, "Micromolar"]}
	],
	Example[
		{Basic,"Pull last species from state:"},
		StateLast[State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}]],
		{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}
	]
}];


(* ::Subsubsection::Closed:: *)
(*StateMost*)


DefineTests[StateMost,{
	Example[
		{Basic,"Drop last species from state:"},
		StateMost[State[{a, (Micro*Mole)/Liter}, {b, (2*Milli*Mole)/Liter}, {c, 3}, {d, (3*Mole)/Liter}]],
		State[{a, (Micro*Mole)/Liter}, {b, (2*Milli*Mole)/Liter}, {c, 3}]
	],
	Example[
		{Basic,"Drop last species from state:"},
		StateMost[State[{Structure[{Strand[DNA[5]]}],Micro Molar},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
		State[{Structure[{Strand[DNA[5]]}, {}], Quantity[1, "Micromolar"]}, {Structure[{Strand[DNA[5]]}, {}], Quantity[2, "Micromolar"]}]
	],
	Example[
		{Basic,"Drop last species from state:"},
		StateMost[State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}]],
		State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}]
	]
}];


(* ::Subsubsection::Closed:: *)
(*StateRest*)


DefineTests[StateRest,{
	Example[
		{Basic,"Drop first species from state:"},
		StateRest[State[{a, (Micro*Mole)/Liter}, {b, (2*Milli*Mole)/Liter}, {c, 3}, {d, (3*Mole)/Liter}]],
		State[{b, (2*Milli*Mole)/Liter}, {c, 3}, {d, (3*Mole)/Liter}]
	],
	Example[
		{Basic,"Drop first species from state:"},
		StateRest[State[{Structure[{Strand[DNA[5]]}],Micro Molar},{Structure[{Strand[DNA[5]]}],2 Micro Molar},{Structure[{Strand[DNA[5]]}],3 Micro Molar}]],
		State[{Structure[{Strand[DNA[5]]}, {}], Quantity[2, "Micromolar"]}, {Structure[{Strand[DNA[5]]}, {}], Quantity[3, "Micromolar"]}]
	],
	Example[
		{Basic,"Drop first species from state:"},
		StateRest[State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Quantity[1.9660377602016115*^-9, "Molar"]}, {Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}]],
		State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]], Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {Bond[{1, 1, 1 ;; 6}, {2, 1, 17 ;; 22}]}], Quantity[1.340828040423456*^-15, "Molar"]}]
	]
}];


(* ::Section:: *)
(*End Test Package*)
