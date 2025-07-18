(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotWestern*)


DefineUsage[PlotWestern,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotWestern[data]", "spectralPlot"},
			Description->"plots the Western MassSpectrum 'data' as a list line plot.",
			Inputs:>{
				{
					InputName->"western",
					Description->"The Object[Data,Western] object to be plotted.",
					Widget->Alternatives[
						"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Western]]],
						"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Western]]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"spectralPlot",
					Description->"A graphical representation of the data as a list line plot.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition -> {"PlotWestern[protocol]", "plot"},
			Description -> "creates a 'plot' of the Western data found in the Data field of 'protocol'.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocol object containing Western data objects.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, Western]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "The figure generated from data found in the Western protocol.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotWestern[spectrum]", "spectralPlot"},
			Description->"plots the 'spectrum' as a list line plot.",
			Inputs:>{
				{
					InputName->"spectrum",
					Description->"A graphical representation of the data as a list line plot.",
					Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName->"spectralPlot",
					Description->"A graphical representation of the data as a list line plot.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotPeaks",
		"PeakEpilog",
		"plot"
	},
	Author -> {"hayley", "mohamad.zandian", "brad"},
	Preview->True
}];