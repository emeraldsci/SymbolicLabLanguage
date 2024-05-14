(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDigitalPCR*)

DefineUsage[PlotDigitalPCR,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotDigitalPCR[data]","plot"},
				Description->"creates a 'plot' using fluorescence signal amplitude values for droplets in 'data'.",
				Inputs:>{
					{
						InputName->"data",
						Description->"The object(s) or packet(s) containing digital PCR raw droplet amplitudes.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Data,DigitalPCR]]],
							Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,DigitalPCR]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The figure generated from digital PCR data.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso->{
			"ListPlot",
			"DistributionChart"
		},
		Author->{"malav.desai", "waseem.vali"},
		Preview->True
	}
];