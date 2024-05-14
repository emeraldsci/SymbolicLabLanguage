(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotInstrumentTimeline*)


DefineUsage[PlotInstrumentTimeline,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotInstrumentTimeline[instrument]","timeline"},
				Description->"Plots the Status timeline of 'instrument' and displays a pie chart of the statuses for the past week.",
				Inputs:>{
					{
						InputName->"instrument",
						Description->"The instrument model or object.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Instrument],Object[Instrument]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"timeline",
						Description->"The Status timeline plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotInstrumentTimeline[instrument,timeSpan]","timeline"},
				Description->"Plots the Status timeline of 'instrument' and displays a pie chart of the statuses for the requested 'timeSpan'.",
				Inputs:>{
					{
						InputName->"instrument",
						Description->"The instrument model or object.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Instrument],Object[Instrument]}]
						]
					},
					{
						InputName->"timeSpan",
						Description->"The span of time over which the instrument's status breakdown should be displayed in a pie chart.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Instrument],Object[Instrument]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"timeline",
						Description->"The Status timeline plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}

		},

		SeeAlso->{
			"TimelinePlot",
			"PlotObject"
		},
		Author->{"pnafisi", "kelmen.low"}
	}
];