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
			},
			{
				Definition -> {"PlotPAGE[protocol]", "plot"},
				Description -> "returns a pixel intensity 'plot' of the of the LaneImage of the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing PAGE data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, PAGE]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the PAGE protocol.",
						Pattern :> ValidGraphicsP[]
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