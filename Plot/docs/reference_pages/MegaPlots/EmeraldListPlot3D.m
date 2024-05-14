(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListPlot3D*)


DefineUsage[EmeraldListPlot3D,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldListPlot3D[dataset]","3Dplot"},
			Description->"creates a 3D list plot of 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data point triplets with or without units.",
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
					OutputName->"3DPlot",
					Description->"A 3D plot of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldListPlot3D[datasets]","3Dplot"},
			Description->"creates a 3D list plot of 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"A list of datasets, where each dataset is a list of data point triplets with or without units.",
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
					OutputName->"3DPlot",
					Description->"A 3D plot of 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"ListPlot3D",
		"EmeraldListPointPlot3D",
		"PlotObject"
	},
	Author -> {
		"amir.saadat",
		"brad"
	},
	Sync -> Automatic,
	Preview->True
}];
