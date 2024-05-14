(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldHistogram*)


DefineUsage[EmeraldHistogram,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldHistogram[dataset]","chart"},
			Description->"creates a Histogram from the provided 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data points to construct a histogram from. Each data point can be a number or quantity.",
					Widget->Adder[
						Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A histogram plot of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldHistogram[datasets]","chart"},
			Description->"creates a Histogram displaying each dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset contains data points to construct histograms from. Each data point can be a number or quantity.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A histogram plot showing each dataset in 'datasets'.",
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
	Author -> {"scicomp", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];