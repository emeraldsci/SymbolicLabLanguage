(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotLadder*)


DefineUsage[PlotLadder,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotLadder[Analysis]", "plot"},
			Description->"plots the standard peak points in 'ladder' alongside a standard curve fit to either molecular weight (ExpectedSize) or position (ExpectedPosition).",
			Inputs:>{
				{
					InputName->"Analysis",
					Description->"An Object[Analysis,Ladder] of the ladder to plot.",
					Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Ladder]]]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A plot of the standard peak points with a fitted function overlayed, if specified.",
					Pattern:>_Graphics
				}
			}
		},
		{
			Definition->{"PlotLadder[Data]", "plot"},
			Description->"plots the standard peak points in 'ladder' alongside a standard curve fit to either molecular weight (ExpectedSize) or position (ExpectedPosition).",
			Inputs:>{
				{
					InputName->"Data",
					Description->"A list of pairs relating strand length to peak position.",
					Widget->Adder[{
						"Strand Length"->Widget[Type->Number,Pattern:>GreaterP[0,1]],
						"Peak Position"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					}]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A plot of the standard peak points with a fitted function overlayed, if specified.",
					Pattern:>_Graphics
				}
			}
		}
	},
	MoreInformation -> {
		"Given ExpectedSize, can display either ExpectedSize or ExpectedPosition",
		"Given ExpectedPosition, can display either ExpectedSize or ExpectedPosition",
		"If Display->Automatic and one function is specified, that function will be displayed",
		"If Display->Automatic and both functions are specified, ExpectedSize will be displayed",
		"If Axes are set to Automatic, the axes labels will be taken from data units"
	},
	SeeAlso -> {
		"AnalyzeLadder",
		"AnalyzePeaks"
	},
	Author -> {"dirk.schild", "kevin.hou", "brad", "alice", "qian", "thomas"},
	Preview->True
}];