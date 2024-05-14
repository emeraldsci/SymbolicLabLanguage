(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotChromatographyMassSpectra*)


DefineUsage[PlotChromatographyMassSpectra,{
	BasicDefinitions->{
		{
			Definition->{"PlotChromatographyMassSpectra[dataObject]","plot"},
			Description->"displays either a 2D (sliced) or 3D (waterfall) plot of the LCMS data in the supplied 'dataObject'.",
			Inputs:>{
				{
					InputName->"dataObject",
					Description->"Object(s) containing the LCMS data to be plotted.",
					Widget->Alternatives[
						"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,ChromatographyMassSpectra]]],
						"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,ChromatographyMassSpectra]]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"Plot(s) of the LCMS data in the input data object(s).",
					Pattern:>ListableP[ValidGraphicsP[]]
				}
			}
		}
	},
	MoreInformation -> {
		"PlotChromatographyMassSpectra uses pre-computed, downsampled LCMS data linked to the input object(s) to generate plots.",
		"Downsampled data is linked through the DownsamplingAnalyses field of the input data object.",
		"By default, the most recent downsampling analysis is used in the plot. Use the DownsampledData option to plot data from a specific downsampling analysis.",
		"All LCMS data is downsampled to a time resolution of 1 second when uploaded. Data can be re-analyzed with different downsampling rates using AnalyzeDownsampling."
	},
	SeeAlso -> {
		"AnalyzeDownsampling",
		"PlotChromatography",
		"PlotMassSpectrometry"
	},
	Author -> {"scicomp", "brad", "kevin.hou"},
	Preview->True
}];