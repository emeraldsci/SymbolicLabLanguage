(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceKinetics*)


DefineUsage[PlotFluorescenceKinetics,
{
	BasicDefinitions->{
		{
			Definition->{"PlotFluorescenceKinetics[fluorescenceKineticsData]", "plot"},
			Description->"displays fluorescence intensity vs time for the supplied 'fluorescenceKineticsData'.",
			Inputs:>{
				{
					InputName->"fluorescenceKineticsData",
					Description->"Fluorescence kinetics data you wish to plot.",
					Widget->Alternatives[
						"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceKinetics]]],
						"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceKinetics]]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"Plot of the Fluorescence trajectory.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotFluorescenceKinetics[trajectory]", "plot"},
			Description->"displays fluorescence intensity vs time when given a raw data 'trajectory'.",
			Inputs:>{
				{
					InputName->"trajectory",
					Description->"Raw trajectory data you wish to plot.",
					Widget->Widget[Type->Expression,Pattern:>rawPlotInputP,Size->Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"Plot of the Fluorescence trajectory.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotFluorescenceIntensity",
		"PlotFluorescenceSpectroscopy",
		"EmeraldListLinePlot"
	},
	Author -> {
		"kevin.hou",
		"hayley"
	},
	Preview->True
}];
