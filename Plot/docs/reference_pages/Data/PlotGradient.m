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
					Description->"A Object[Method,Gradient], Object[Method, IonChromatographyGradient], or Object[Method, SupercriticalFluidGradient] object.",
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Method,Gradient], Object[Method, IonChromatographyGradient],Object[Method, SupercriticalFluidGradient]}]
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
	Author -> {"dirk.schild", "hayley", "mohamad.zandian", "brad", "robert", "qijue.wang"},
	Preview -> True
}];