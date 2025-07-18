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
		_?(Not[FreeQ[#, PlotLabel -> Style["Tyrosine", Directive[24, GrayLevel[0]]]]] &)
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
			{th,{1.5,2.0,2.5}}
		],
		{ValidGraphicsP[]..}
	],
	Example[{Messages,"nintrp","Return $Failed if an invalid Molecule[] is provided:"},
		PlotMolecule[Molecule["taco"]],
		$Failed,
		Messages:>{Molecule::nintrp}
	],

	Test["Make sure Molecule[] typesets to ECL's PlotMolecule instead of something else",
		ToBoxes[Molecule["CCCC"]],
		InterpretationBox[GraphicsBox[___],_Molecule]
	]
}];
