(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotFractions*)


DefineUsage[PlotFractions,
{
	BasicDefinitions->{
		{
			Definition->{"PlotFractions[Analysis]", "plot"},
			Description->"plots a Chromatogram with fraction epilogs.",
			Inputs:>{
				{
					InputName->"Analysis",
					Description->"An Object[Analysis,Fractions] associated with the chromatogram and fractions to plot.",
					Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fractions]]]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A chromatograph plot with fractions highlighted.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation->{
		"PlotFractions[fracsCollected, fracksPicked, fig]->plot may be used to generate and plot ladder epilogs on any figure.",
		"Both fracsCollected and fracksPicked must match {FractionP...}",
		"FractionP has the format {left bound, right bound, string label}."
	},
	SeeAlso -> {
		"PlotChromatography",
		"EmeraldListLinePlot"
	},
	Author -> {
		"kevin.hou",
		"brad",
		"robert",
		"Ruben"
	},
	Preview->True
}];
