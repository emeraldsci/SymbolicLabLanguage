(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldPieChart*)


DefineUsage[EmeraldPieChart,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldPieChart[dataset]","chart"},
			Description->"creates a PieChart of 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data points corresponding to pie slice sizes. Each data point can be a number or quantity.",
					Widget->Adder[
						Widget[Type->Expression,Pattern:>(UnitsP[]|Null|_Tooltip),Size->Word]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A pie chart of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldPieChart[datasets]","chart"},
			Description->"creates a PieChart displaying each dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"A list of datasets, where each dataset is a list of data points corresponding to pie slice sizes. Each data point can be a number or quantity.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[ Widget[Type->Expression,Pattern:>(UnitsP[]|Null|_Tooltip),Size->Word] ]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"Pie chart showing each dataset in 'datasets'.",
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