(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProtocolTimeline*)


DefineUsage[PlotProtocolTimeline,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotProtocolTimeline[protocol]","timeline"},
				Description->"plots the status timeline in 'protocol'.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"The protocol, maintenance or qualification object.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"timeline",
						Description->"The plot of the changing status.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}

		},

		SeeAlso->{
			"TimelinePlot",
			"PlotObject"
		},
		Author->{"hayley", "mohamad.zandian", "steven", "eqian"}
	}
];