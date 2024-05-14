(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBarChart*)


DefineUsage[EmeraldBarChart,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldBarChart[dataset]", "chart"},
			Description->"creates a bar chart from the provided 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"Raw numerical data to plot with EmeraldBarChart.",
					Widget->Adder[
						Widget[Type->Expression,Pattern:>(UnitsP[] | Replicates[UnitsP[]..] | UnitsP[] \[PlusMinus] UnitsP[] | _?DistributionParameterQ | Null),Size->Word]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A bar chart showing 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldBarChart[datasets]", "chart"},
			Description->"creates a bar chart displaying each dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is raw numerical data to plot with EmeraldBarChart.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[ Widget[Type->Expression,Pattern:>(UnitsP[] | Replicates[UnitsP[]..] | UnitsP[] \[PlusMinus] UnitsP[] | _?DistributionParameterQ | Null),Size->Word] ]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A bar chart showing each dataset in the input 'datasets'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation -> {
		"Data points specified as Replicates are turned into a bar whose height is the mean of the replicates list, and an error bar whose size is the standard deviation of the replicates list.",
		"Data points specified as distributions are turned into a bar whose height is the mean of the distribution, and an error bar whose size is the standard deviation of the distriubtion.",
		"Data points specified as PlusMinus[m,s] are turned into a bar whose height is m, and an error bar whose size is s."
	},
	SeeAlso -> {
		"BarChart",
		"EmeraldListLinePlot",
		"PlotPeaks"
	},
	Author -> {"scicomp", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];