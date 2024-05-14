(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListLinePlot*)


DefineUsage[EmeraldListLinePlot,{
	BasicDefinitions->{
		{
			Definition->{"EmeraldListLinePlot[primaryData]","fig"},
			Description->"creates a ListLinePlot of 'primaryData'.",
			Inputs:>{
				{
					InputName->"primaryData",
					Description->"Data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.",
					Widget->Alternatives[
						Adder[
							{
								"x"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
								"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
							}
						],
						Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A ListLinePlot of 'primaryData', which could have a legend and/or could be zoomable.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldListLinePlot[datasets]","fig"},
			Description->"overlays each dataset in 'datasets' onto a single figure.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A ListLinePlot showing each dataset in 'datasets' overlaid in a single figure, which could have a legend and/or could be zoomable.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldListLinePlot[{{nestedData..}..}]","fig"},
			Description->"overlays all 'primaryData' onto one figure, while associating the innermost data sets to one another through color.",
			Inputs:>{
				{
					InputName->"nestedData",
					Description->"Data to plot on primary (left) axis.  Data can have units associated as a QuantityArray, or be raw numerical values.",
					Widget->Adder[Adder[Alternatives[
						"Single Dataset"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph]
					]]]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A ListLinePlot showing each 'nestedData' overlaid in a single figure, where the innermost grouped datasets share the same color.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso->{
		"ListLinePlot",
		"PeakEpilog",
		"PlotChromatography"
	},
	Author->{"scicomp", "brad", "hayley"},
	Preview->True
}];