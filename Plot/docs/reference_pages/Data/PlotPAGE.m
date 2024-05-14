(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPAGE*)


DefineUsage[PlotPAGE,
	{
		BasicDefinitions ->{
			{
				Definition->{"PlotPAGE[pageData]","plot"},
				Description->"returns a pixel intensity plot of the LaneImage of the given 'pageData', with LaneImage across top of plot.",
				Inputs:>{
					{
						InputName->"pageData",
						Description->"An image or graphic to plot pixel intensity from.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,PAGE]]]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plot of the luminescence trajectory.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"lanes","PlotWestern","PlotAgarose"
		},
		Author -> {"hayley", "mohamad.zandian", "brad"},
		Preview->True
	}
];