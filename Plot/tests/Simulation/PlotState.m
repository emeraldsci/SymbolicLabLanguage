(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotState*)


DefineTests[PlotState,{

	Example[{Basic,"The function can be used to display the relative concentrations of species in a state:"},
		PlotState[State[{A,1Micro Molar},{B,1.2 Micro Molar},{C,100 Nano Molar}]],
		_Legended
	],

	Example[{Basic,"Alternatively a list of concentrations and species can be provided to plot state:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}}],
		_Legended
	],

	Example[{Basic,"The plot has additional functionality when dealing with nucleic acid states:"},
		PlotState[State[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{}],(9.101253103404443`*^-9 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;5},{1,1,6;;10}]}],(4.029260902290325`*^-7 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{1,1,17;;22}]}],(5.347541444838851`*^-7 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,6;;9},{1,1,18;;21}]}],(5.3215081634904563`*^-8 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;6},{2,1,17;;22}]}],(5.5919707668416635`*^-15 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,1;;10},{2,1,1;;10}]}],(1.7040904459093204`*^-12 Mole)/Liter},{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]],Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]},{Bond[{1,1,17;;22},{2,1,1;;6}]}],(5.591970766841664`*^-15 Mole)/Liter}]],
		_Legended
	],

	Example[{Attributes,"Listable","The Function is listable by states:"},
		PlotState[{State[{A,1Micro Molar},{B,1.2 Micro Molar},{C,100 Nano Molar}],State[{A,0.7Micro Molar},{B,0.9 Micro Molar},{C,400 Nano Molar}],State[{A,0.5Micro Molar},{B,0.7 Micro Molar},{C,600 Nano Molar}]}],
		{_Legended..}
	],

	Example[{Basic,"Given simulation object:"},
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"]],
		_Legended
	],

	Test["Given link:",
		PlotState[Link[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Reference]],
		_Legended
	],

	Test["Given packet:",
		PlotState[Download[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"]]],
		_Legended
	],

	(* Options tests *)
	Example[{Options,ChartStyle,"Specify a color palette:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}},ChartStyle->"AlpineColors"],
		_?ValidGraphicsQ
	],

	Example[{Options,ChartElementFunction,"Set the style of chart elements:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}},ChartElementFunction->"BezelSector"],
		_?ValidGraphicsQ
	],

	Example[{Options,SectorOrigin,"Set the orientation of the pie chart:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}},SectorOrigin->Pi/2],
		_?ValidGraphicsQ
	],

	Example[{Options,ImageSize,"Specify the plot dimensions:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}},ImageSize->500],
		_?ValidGraphicsQ
	],

	(* Messages tests *)
	Example[{Messages,"InputLengthMismatch","Concentrations and species of differing lengths:"},
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B}}],
		ValidGraphicsP[],
		Messages:>{Warning::InputLengthMismatch}
	],

	Test["More species than concentrations:",
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C,D}}],
		ValidGraphicsP[],
		Messages:>{Warning::InputLengthMismatch}
	],

	(* Output tests *)
	Test["Setting Output to Result returns the plot:",
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->Result],
		_?ValidGraphicsQ
	],

	Test["Setting Output to Preview returns the plot within a frame:",
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->Preview],
		_Framed
	],

	Test["Setting Output to Options returns the resolved options:",
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotState]]
	],

	Test["Setting Output to Tests returns a list of tests:",
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->Tests],
		{(_EmeraldTest|_Example)...}
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for concentrations+species input:",
		PlotState[{{6 Micro Molar,4 Micro Molar,1200 Nano Molar},{A,B,C}},Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotState]]
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for state input:",
		PlotState[State[{A,1Micro Molar},{B,1.2 Micro Molar},{C,100 Nano Molar}],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotState]]
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for listed state input:",
		PlotState[
			{
				State[{A,1Micro Molar},{B,1.2 Micro Molar},{C,100 Nano Molar}],
				State[{A,1Micro Molar},{B,1.2 Micro Molar},{C,100 Nano Molar}]
			},
			Output->{Result,Options}
		],
		output_List/;MatchQ[First@output,{_?ValidGraphicsQ..}]&&MatchQ[Last@output,OptionsPattern[PlotState]]
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for object input:",
		PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->{Result,Options}],
		output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotState]]
	],

	Test["Setting Output to {Result,Options} returns the plot along with all resolved options for listed object input:",
		PlotState[{Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"]},Output->{Result,Options}],
		output_List/;MatchQ[First@output,{_?ValidGraphicsQ..}]&&MatchQ[Last@output,OptionsPattern[PlotState]]
	],

	Test["Setting Output to Options returns all of the defined options:",
		Sort@Keys@PlotState[Object[Simulation, Equilibrium, "id:Y0lXejGwmKBP"],Output->Options],
		Sort@Keys@SafeOptions@PlotState
	]

}];
