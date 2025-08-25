(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram3D*)


DefineUsage[EmeraldSmoothHistogram3D,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldSmoothHistogram3D[dataset]","chart"},
			Description->"creates a SmoothHistogram3D from 'dataset'.",
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
					Description->"A 3D smooth histogram of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldSmoothHistogram3D[{datasets..}]","chart"},
			Description->"creates a SmoothHistogram3D displaying each input dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"A list of datasets, where each dataset is a list of paired x-y data points.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[ Widget[Type->Expression,Pattern:>({UnitsP[],UnitsP[]}|Null),Size->Word] ]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A 3D smooth histogram showing each dataset in 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"SmoothHistogram3D",
		"EmeraldSmoothHistogram",
		"PlotObject"
	},
	Author -> {"dirk.schild", "amir.saadat", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];