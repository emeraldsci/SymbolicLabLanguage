(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicFoamAnalysis*)


DefineUsage[PlotDynamicFoamAnalysis,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotDynamicFoamAnalysis[dataObject]", "plot"},
				Description->"displays plot of the collected foam data from the supplied 'dataObject', including the foam/liquid height and volume over time, the bubble count and bubble size over time, and the foam liquid content over time at each liquid conductivity module sensor.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"Dynamic foam analysis data that will be plotted.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicFoamAnalysis]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plots of the dynamic foam analysis data.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			},
			{
				Definition -> {"PlotDynamicFoamAnalysis[protocol]", "plot"},
				Description -> "displays a 'plot' of the dynamic foam analysis data found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing dynamic foam analysis data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, DynamicFoamAnalysis]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the dynamic foam analysis protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDynamicFoamAnalysis",
			"ValidExperimentDynamicFoamAnalysisQ",
			"EmeraldListLinePlot"
		},
		Author -> {"scicomp", "brad", "marie.wu"},
		Preview->True
	}
];