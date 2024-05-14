(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGradient*)


DefineUsage[PlotGradient,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotGradient[gradientObject]", "plot"},
			Description->"plots the buffer compositions as a function of time for a 'gradientObject'.",
			Inputs:>{
				{
					InputName->"gradientObject",
					Description->"A Object[Method,Gradient] object.",
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Method,Gradient]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A ListLinePlot of buffer composition.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"PlotChromatography",
		"EmeraldListLinePlot"
	},
	Author -> {"hayley", "mohamad.zandian", "brad", "robert", "qijue.wang"},
	Preview -> True
}];