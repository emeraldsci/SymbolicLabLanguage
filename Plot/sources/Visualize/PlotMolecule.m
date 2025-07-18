(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotMolecule*)


(* ::Subsection:: *)
(*Option Definitions*)

DefineOptions[PlotMolecule,
	Options:>{
		ModifyOptions[ListPlotOptions,{PlotLabel}],
		{
			OptionName->AtomFontSize,
			Default->10,
			Description->"The font size of letters representing atoms, in units of points.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->BondSpacing,
			Default->0.15,
			Description->"The amount of space between parallel lines in double/triple bonds, as a fraction of the bond length.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->LineWidth,
			Default->2,
			Description->"The thickness of bond lines, in units of points.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->MarginWidth,
			Default->1.6,
			Description->"The amount of space to leave between bonds and atom characters.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0.0]],
			Category->"General"
		}
	}
];

(* ::Subsection:: *)
(*Overloads*)

(* Listable overload *)
PlotMolecule[mols:{_Molecule..},ops:OptionsPattern[PlotMolecule]]:=PlotMolecule[#,ops]&/@mols;


(* ::Subsection:: *)
(*Main Function*)

PlotMolecule[mol_Molecule,ops:OptionsPattern[PlotMolecule]]:=Module[
	{validMol,safeOps,bondThick,fsize,spacing},

	(* False if molecule isn't valid *)
	validMol=Quiet[
		Check[MoleculeValue[mol],False,{MoleculeValue::mol,Molecule::nintrp}],
		{MoleculeValue::mol, MoleculeValue::argtu}
	];

	(* Quit early if the molecule is invalid *)
	If[validMol===False,
		Return[$Failed];
	];

	(* Sub in default values for options *)
	safeOps=SafeOptions[PlotMolecule,ToList[ops]];

	(* Extract values from options *)
	bondThick=Lookup[safeOps,LineWidth];
	fsize=Lookup[safeOps,AtomFontSize];
	spacing=Lookup[safeOps,BondSpacing];

	MoleculePlot[mol,
		IncludeHydrogens -> None,
		ColorRules -> {_ -> Black},
		Method -> {
			"DoubleBondOffset" -> spacing,
			"DoubleBondOffsetInRing"->spacing,
			"AtomLabelPadding" -> 0.3,
			"DashSpacing" -> 0.1,
			"FontScaleFactor" -> 1.50 * fsize/10,
			"ShowHydrogens" -> False
		},
		PlotLabel -> OptionValue[PlotLabel]
	] /. l_Line :> {AbsoluteThickness[bondThick], l}
];
