(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotMolecule*)


DefineUsage[PlotMolecule,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotMolecule[mol]", "structure"},
			Description->"generates a line structure showing the skeletal formula of 'mol'.",
			Inputs:>{
				{
					InputName->"mol",
					Description->"A Molecule to be visualized.",
					Widget->Widget[Type->Molecule,Pattern:>MoleculeP]
				}
			},
			Outputs:>{
				{
					OutputName->"structure",
					Description->"A line structure showing the skeletal formula of mol.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation -> {
		"PlotMolecule[] is an extension of the native Mathematica MoleculePlot[] function with additional styling options.",
		"The bond length between atom centers is fixed to be 0.2 inches (14.4pt), in accordance with ACS styling guidelines."
	},
	SeeAlso -> {
		"PlotObject",
		"MoleculePlot"
	},
	Author -> {"scicomp", "brad", "kevin.hou"}
}];