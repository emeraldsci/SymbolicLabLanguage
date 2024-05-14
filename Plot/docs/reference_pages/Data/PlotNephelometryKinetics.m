(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometryKinetics*)


DefineUsage[PlotNephelometryKinetics,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotNephelometryKinetics[dataObject]", "plot"},
				Description->"displays a plot of the raw relative nephelometric measurement values versus time from the supplied 'dataObject'. If samples were diluted, a 3D plot can be plotted to display raw relative nephelometric measurement values versus time versus concentration.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"NephelometryKinetics data that will be plotted.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,NephelometryKinetics]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,NephelometryKinetics]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plots of the NephelometryKinetics data.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			},
			{
				Definition->{"PlotNephelometryKinetics[protocolObject]","plots"},
				Description->"plots of the data collected during an ExperimentNephelometryKinetics.",
				Inputs:>{
					{
						InputName->"protocolObject",
						Description->"Protocol object from a completed ExperimentNephelometryKinetics.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,NephelometryKinetics]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,NephelometryKinetics]]]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the turbidity data collected during ExperimentNephelometryKinetics.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometryKinetics",
			"ValidExperimentNephelometryKineticsQ",
			"EmeraldListLinePlot"
		},
		Author -> {"scicomp", "brad", "hailey.hibbard"},
		Preview->True
	}
];