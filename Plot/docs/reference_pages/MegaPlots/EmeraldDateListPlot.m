(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldDateListPlot*)


DefineUsage[EmeraldDateListPlot,{
	BasicDefinitions->{
		{
			Definition->{"EmeraldDateListPlot[primaryData]","fig"},
			Description->"creates a DateListPlot of 'primaryData'.",
			Inputs:>{
				{
					InputName->"primaryData",
					Description->"Data to plot on primary (left) axis. Data can have units associated as a QuantityArray, or be raw numerical values.",
					Widget->Alternatives[
						"Time-Y Values"->Adder[
							{
								"Time"->Widget[Type->Expression,Pattern:>(_?DateObjectQ|Null),Size->Word],
								"Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
							}
						],
						"Coordinate Set"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph],
						"Complex Input"->Widget[Type->Expression,Pattern:>_,Size->Paragraph]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A DateListPlot, which could have a legend and/or could be zoomable.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldDateListPlot[datasets]","fig"},
			Description->"overlays each dataset in 'datasets' onto a single figure.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is data to plot on primary (left) axis. Data can have units associated as a QuantityArray, or be raw numerical values.",
					Widget->Adder[
						Alternatives[
							"Time-Y Values"->Adder[
								{
									"Time"->Widget[Type->Expression,Pattern:>(_?DateObjectQ|Null),Size->Word],
									"Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
								}
							],
							"Coordinate Set"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph],
							"Complex Input"->Widget[Type->Expression,Pattern:>_,Size->Paragraph]
						]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"A DateListPlot, which could have a legend and/or could be zoomable.",
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