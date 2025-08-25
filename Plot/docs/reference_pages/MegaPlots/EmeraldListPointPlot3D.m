(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPointPlot3D*)


DefineUsage[EmeraldListPointPlot3D,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldListPointPlot3D[dataset]", "plot3D"},
			Description->"creates a ListPointPlot3D of 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data point triplets.",
					Widget->Alternatives[
						"XYZ Values"->Adder[
							{
								"x"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word],
								"y"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word],
								"z"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word]
							}
						],
						"Coordinate Set"->Widget[Type->Expression,Pattern:>CoordinatesP|QuantityCoordinatesP[]|Null,Size->Paragraph],
						"Complex Input"->Widget[Type->Expression,Pattern:>_,Size->Paragraph]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot3D",
					Description->"A 3D list plot of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldListPointPlot3D[datasets]", "plot3D"},
			Description->"creates a ListPointPlot3D displaying each dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is a list of data point triplets.",
					Widget->
						Adder[
							Alternatives[
								"XYZ Values"->Adder[
									{
										"x"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word],
										"y"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word],
										"z"->Widget[Type->Expression,Pattern:>(UnitsP[]|Null|Infinity|ComplexInfinity),Size->Word]
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
					OutputName->"plot3D",
					Description->"A 3D list plot showing each dataset in 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"ListPlot3D",
		"EmeraldListLinePlot",
		"EmeraldListPlot3D",
		"PlotObject"
	},
	Author -> {
		"scicomp",
		"brad",
		"hayley"
	},
	Sync -> Automatic,
	Preview->True
}];
