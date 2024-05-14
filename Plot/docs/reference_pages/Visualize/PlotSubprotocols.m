(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotSubprotocols*)


DefineUsage[PlotSubprotocols,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotSubprotocols[protocol]","graphic"},
				Description->"returns a graph, table, and/or list of subprotocols for 'protocol'.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"A sub or parent protocol.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"graphic",
						Description->"The graph showing the subprotocol connectivity.",
						Pattern:>Alternatives[_Graph|_List|_Pane]
					}
				}
			}
		},

		SeeAlso->{
			"PlotObject",
			"PlotProtocolTimeline",
			"DownstreamSampleUsage",
			"UpstreamSampleUsage"
		},
		Author->{"alou", "robert"}
	}
];