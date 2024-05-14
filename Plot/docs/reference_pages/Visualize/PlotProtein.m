(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProtein*)


DefineUsage[PlotProtein,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotProtein[protein]", "structure"},
			Description->"generates a ribbon diagram showing the structure of a 'protein' model.",
			Inputs:>{
				{
					InputName->"protein",
					Description->"A Protein model or object to be visualized.",
					Widget->Alternatives[
						"Model[Molecule,Protein]"->Widget[Type->Object,Pattern:>ObjectP[{Model[Molecule,Protein]}]],
						"Model[Sample]"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample]}]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"structure",
					Description->"A ribbon diagram of the protein structure.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotProtein[pdbID]", "structure"},
			Description->"generates a ribbon diagram showing the protein structure associated with 'pdbID' in the PDB.",
			Inputs:>{
				{
					InputName->"pdbID",
					Description->"The PDB ID number of the protein in the PDB database.",
					Widget->Widget[Type->String,Pattern:>_String,PatternTooltip->"A valid PDB ID number.",Size->Word]
				}
			},
			Outputs:>{
				{
					OutputName->"structure",
					Description->"A ribbon diagram of the protein structure.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation -> {
		"When given a Model[Protein] object, the function will pull the PDBIDs out of the object and plot them."
	},
	SeeAlso -> {
		"PlotTranscript",
		"PlotObject"
	},
	Author -> {
		"kevin.hou",
		"brad",
		"Catherine",
		"thomas"
	},
	Preview->True
}];
