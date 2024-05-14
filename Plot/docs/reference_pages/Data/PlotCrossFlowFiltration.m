(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotCrossFlowFiltration *)


DefineUsage[PlotCrossFlowFiltration,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotCrossFlowFiltration[dataObject]","plots"},
				Description->"plots the data collected during ExperimentCrossFlowFiltration.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"Data object from ExperimentCrossFlowFiltration.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,CrossFlowFiltration]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the data collected during ExperimentCrossFlowFiltration.",
						Pattern:>{_Manipulate..}
					}
				}
			},
			{
				Definition->{"PlotCrossFlowFiltration[dataObjects]","plots"},
				Description->"plots the data collected during ExperimentCrossFlowFiltration.",
				Inputs:>{
					{
						InputName->"dataObjects",
						Description->"Data object from ExperimentCrossFlowFiltration.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,CrossFlowFiltration]]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the data collected during ExperimentCrossFlowFiltration.",
						Pattern:>{{_Manipulate..}..}
					}
				}
			},
			{
				Definition->{"PlotCrossFlowFiltration[protocolObject]","plots"},
				Description->"plots the data collected during ExperimentCrossFlowFiltration.",
				Inputs:>{
					{
						InputName->"protocolObject",
						Description->"Protocol object from a completed ExperimentCrossFlowFiltration.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,CrossFlowFiltration]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the data collected during ExperimentCrossFlowFiltration.",
						Pattern:>{_Manipulate..}
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ValidExperimentCrossFlowFiltrationQ",
			"ExperimentCrossFlowFiltrationOptions",
			"ExperimentFilter",
			"ExperimentDialysis"
		},
		Author->{"scicomp", "brad", "gokay.yamankurt"},
		Preview->True
	}
];