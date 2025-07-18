(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram3D*)


DefineUsage[EmeraldHistogram3D,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldHistogram3D[dataset]","chart"},
			Description->"creates a Histogram3D from the provided 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of paired x-y data points.",
					Widget->Adder[
						{
							"x"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A 3D histogram of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldHistogram3D[datasets]","chart"},
			Description->"creates a Histogram3D displaying each input dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is a list of paired x-y data points.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[ Widget[Type->Expression,Pattern:>({UnitsP[],UnitsP[]}|Null),Size->Word] ]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A 3D histogram showing each dataset in 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"Histogram3D",
		"EmeraldHistogram",
		"PlotObject"
	},
	Author -> {"dirk.schild", "amir.saadat", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];