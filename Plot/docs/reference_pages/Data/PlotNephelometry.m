(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometry*)


DefineUsage[PlotNephelometry,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotNephelometry[dataObject]", "plot"},
				Description->"displays a plot of the raw relative nephelometric measurement values versus concentration from the supplied 'dataObject'.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"Nephelometry data that will be plotted.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Nephelometry]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Nephelometry]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plots of the nephelometry data.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			},
			{
				Definition->{"PlotNephelometry[protocolObject]","plots"},
				Description->"plots of the data collected during an ExperimentNephelometry protocol.",
				Inputs:>{
					{
						InputName->"protocolObject",
						Description->"Protocol object from a completed ExperimentNephelometry.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,Nephelometry]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,Nephelometry]]]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the turbidity data collected during ExperimentNephelometry.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometry",
			"ValidExperimentNephelometryQ",
			"EmeraldListLinePlot"
		},
		Author -> {"scicomp", "brad", "hailey.hibbard"},
		Preview->True
	}
];