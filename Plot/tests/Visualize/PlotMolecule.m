(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotMolecule*)


DefineTests[PlotMolecule,{	
	Example[{Basic,"Plot a molecule:"},
		PlotMolecule[Molecule["Caffeine"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Plot a molecule with stereochemistry:"},
		PlotMolecule[Molecule["Adenosine"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"PlotMolecule is listable:"},
		PlotMolecule[{
			Molecule["COC(C)(C)C"],
			Molecule["O=P(O)(O)O"],
  		Molecule["COc1ccc(C(OC(COCCCNC(=O)OCC2[C@H]3CCC#CCC[C@@H]23)COP(\\OCCC#N)N(C(C)C)C(C)C)(c2ccccc2)c2ccc(OC)cc2)cc1"]
		}],
		{ValidGraphicsP[]..}
	],
	Example[{Options,PlotLabel,"Add a plot label to the molecule plot:"},
		PlotMolecule[Molecule["Tyrosine"],PlotLabel->Style["Tyrosine", Directive[24, Black]]],
		(* in 13.2 the location of the PlotLabel changes *)
		x:ValidGraphicsP[]/;Or[MatchQ[Part[x,-2],Rule[PlotLabel,_Style]], MatchQ[x[[-1, -2]], PlotLabel -> _Style]]
	],
	Example[{Options,AtomFontSize,"Change the font size of non-carbon atoms in the molecule:"},
		Table[
			PlotMolecule[Molecule["Caffeine"],
				AtomFontSize->sz
			],
			{sz,{3,6,12}}
		],
		{ValidGraphicsP[]..}
	],
	Example[{Options,BondSpacing,"Set the spacing between bonds in double and triple bonds as a fraction of the bond length:"},
		Table[
			PlotMolecule[Molecule["c1ccccc1C/C=C\\CC#N"],
				BondSpacing->sp
			],
			{sp,{0.10,0.20,0.35}}
		],
		{ValidGraphicsP[]..}
	],
	Example[{Options,LineWidth,"Set the width of bond lines in units of points:"},
		Table[
			PlotMolecule[Molecule["coronene"],
				LineWidth->th
			],
			{th,{0.1,0.6,1.2}}
		],
		{ValidGraphicsP[]..}
	],
	Example[{Options,MarginWidth,"Set the amount of whitespace between atom letters and bond lines in units of points:"},
		Table[
			PlotMolecule[Molecule["COC(C)(C)(C)"],
				MarginWidth->m
			],
			{m,{0.05,1.6,3.0}}
		],
		{ValidGraphicsP[]..}
	],
	Example[{Messages,"nintrp","Return $Failed if an invalid Molecule[] is provided:"},
		PlotMolecule[Molecule["taco"]],
		$Failed,
		Messages:>{Molecule::nintrp}
	],
	Example[{Issues,"Disconnected structures cannot be modified by styling options:"},
		{
			PlotMolecule[Molecule["O=P([O-])([O-])O.[Na+].[Na+]"]],
			PlotMolecule[Molecule["O=P([O-])([O-])O.[Na+].[Na+]"],
				AtomFontSize->15,
				MarginWidth->20.0
			]
		},
		{ValidGraphicsP[]..}
	],
	Example[{Issues,"Non-standard isotopes cannot be modified by styling options:"},
		{
			PlotMolecule[Molecule["[2H]C([2H])([2H])S(=O)C([2H])([2H])[2H]"]],
			PlotMolecule[Molecule["[2H]C([2H])([2H])S(=O)C([2H])([2H])[2H]"],
				AtomFontSize->15,
				MarginWidth->20.0
			]
		},
		{ValidGraphicsP[]..}
	],
	Example[{Issues,"Bond lines may render incorrectly if styling options are set to extremes, e.g. very large font sizes and margins:"},
		PlotMolecule[Molecule["Caffeine"],AtomFontSize->15,MarginWidth->5],
		ValidGraphicsP[]
	],

	Test["Make sure Molecule[] typesets to ECL's PlotMolecule instead of something else",
		ToBoxes[Molecule["CCCC"]],
		InterpretationBox[GraphicsBox[___],_Molecule]
	]
}];
