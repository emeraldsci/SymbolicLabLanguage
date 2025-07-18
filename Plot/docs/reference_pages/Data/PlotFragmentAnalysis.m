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
			},
			{
				Definition -> {"PlotFragmentAnalysis[protocol]", "plot"},
				Description -> "creates a 'plot' of the FragmentAnalysis data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing fragment analysis data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, FragmentAnalysis]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the fragment analysis protocol.",
						Pattern :> ValidGraphicsP[]
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