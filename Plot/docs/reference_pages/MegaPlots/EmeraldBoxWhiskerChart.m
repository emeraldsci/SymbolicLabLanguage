(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldBoxWhiskerChart*)


DefineUsage[EmeraldBoxWhiskerChart,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldBoxWhiskerChart[dataset]","chart"},
			Description->"creates a BoxWhiskerChart from the provided 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data points corresponding to box-whisker points. Each data point can be a number or quantity.",
					Widget->Adder[
						Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A box-whisker chart showing 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldBoxWhiskerChart[datasets]","chart"},
			Description->"creates a BoxWhiskerChart displaying each dataset in 'datasets'.",
			Inputs:>{
				{
					InputName->"datasets",
					Description->"List of datasets, where each dataset is a list of data points corresponding to box-whisker points. Each data point can be a number or quantity.",
					Widget->Adder[Alternatives[
						"Single Dataset"->Adder[ Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word] ]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A box-whisker chart showing each 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldBoxWhiskerChart[groupedDatasets]","chart"},
			Description->"creates a BoxWhiskerChart displaying each group of datasets in 'groupedDatasets'.",
			Inputs:>{
				{
					InputName->"groupedDatasets",
					Description->"A nested list of datasets where each dataset is index-matched within each group, i.e. {{group1-dataset1,group1-dataset2,..},{group2,dataset1,group2-dataset2,..},..}. Each data point can be a number or quantity.",
					Widget->Adder[Alternatives[
						"Single Group"->Adder[Alternatives[
							"Single Dataset"->Adder[
								Widget[Type->Expression,Pattern:>(UnitsP[]|Null),Size->Word]
							]
						]]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A box-whisker chart showing each 'dataset'.",
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