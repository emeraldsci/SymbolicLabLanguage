(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotPeaks*)


DefineUsage[PlotPeaks,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotPeaks[peaksData]", "plot"},
			Description->"produces either a piechart or barchart of the peak areas, widths, heights, or purities contained in the provided 'peaksData' object.",
			Inputs:>{
				{
					InputName->"peaksData",
					Description->"A data or peaks analysis object to be plotted.",
					Widget->Alternatives[
						"Analysis Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Peaks]],PatternTooltip->"Object must be of type Object[Analysis,Peaks]"],
						"Data Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data]],PatternTooltip->"Object must be of type Object[Data]"]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.",
					Pattern:>_Graphics
				}
			}
		},
		{
			Definition->{"PlotPeaks[peaksDataA,peaksDataB]", "plot"},
			Description->"produces a normalized barchart of the peak areas, widths, heights, or purities of 'peaksDataA' normalized against 'peaksDataB'.",
			Inputs:>{
				{
					InputName->"peaksDataA",
					Description->"A data or peaks analysis object to be plotted.",
					Widget->Alternatives[
						"Analysis Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Peaks]],PatternTooltip->"Object must be of type Object[Analysis,Peaks]"],
						"Data Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data]],PatternTooltip->"Object must be of type Object[Data]"]
					]
				},
				{
					InputName->"peaksDataB",
					Description->"The data or peaks analysis object that 'peaksDataA' will be normalized to.",
					Widget->Alternatives[
						"Analysis Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Peaks]],PatternTooltip->"Object must be of type Object[Analysis,Peaks]"],
						"Data Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data]],PatternTooltip->"Object must be of type Object[Data]"]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.",
					Pattern:>_Graphics
				}
			}
		},
		{
			Definition->{"PlotPeaks[purity]","plot"},
			Description->"produces either a piechart or barchart showing the 'purity' (relative areas) of a set of peaks.",
			Inputs:>{
				{
					InputName->"purity",
					Description->"The 'purity' --- index-matched lists of areas, relative areas, and peak labels --- of the peaks you wish to plot.",
					Widget->Widget[Type->Expression,Pattern:>PurityP,Size->Paragraph,PatternTooltip->"Input must match PurityP."]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A graphical representation of peak areas, widths, heights, or purity as either a pie chart or a bar chart.",
					Pattern:>_Graphics
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"PlotLadder",
		"EmeraldBarChart",
		"EmeraldPieChart"
	},
	Author -> {
		"kevin.hou",
		"brad",
		"Catherine",
		"Frezza"
	},
	Preview->True
}];
