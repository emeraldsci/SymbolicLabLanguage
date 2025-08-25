(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldSmoothHistogram*)


DefineUsage[EmeraldSmoothHistogram,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldSmoothHistogram[dataset]","chart"},
			Description->"creates a SmoothHistogram from 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data points used to construct the histogram. Each data point can be a number or quantity.",
					Widget->Adder[
						Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A smooth histogram plot of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldSmoothHistogram[datasets]","chart"},
			Description->"creates a SmoothHistogram displaying each input dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset contains data points used to construct histograms. Each data point can be a number or quantity.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A smooth histogram plot of each dataset in 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PieChart",
		"EmeraldListLinePlot",
		"PlotPeaks"
	},
	Author -> {"dirk.schild", "amir.saadat", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];