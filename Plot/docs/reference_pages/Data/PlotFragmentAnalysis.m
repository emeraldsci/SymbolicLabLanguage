(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFragmentAnalysis*)


DefineUsage[PlotFragmentAnalysis,
	{
		BasicDefinitions ->{
			{
				Definition->{"PlotFragmentAnalysis[fragmentAnalysisDataObject]","plot"},
				Description->"plots the 'fragmentAnalysisDataObject' Electropherogram as a list line plot.",
				Inputs:>{
					{
						InputName->"fragmentAnalysisDataObject",
						Description->"The Object[Data,FragmentAnalysis] object to be plotted.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,FragmentAnalysis]]]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the data as a list line plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"lanes","PlotAgarose","PlotPAGE"
		},
		Author -> {"jireh.sacramento"},
		Preview->True
	}
];