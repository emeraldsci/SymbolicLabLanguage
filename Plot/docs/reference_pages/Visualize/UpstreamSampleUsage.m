(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*UpstreamSampleUsage*)


DefineUsage[UpstreamSampleUsage,
	{
		BasicDefinitions->{
			{
				Definition->{"UpstreamSampleUsage[sample]","graphic"},
				Description->"returns a graph, and/or list of samples that were used directly or indirectly to transfer into a parent 'sample'.",
				Inputs:>{
					{
						InputName->"sample",
						Description->"The parent sample.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Sample]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"graphic",
						Description->"The graph showing samples which were transferred into the parent sample.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},

		SeeAlso->{
			"PlotObject",
			"DownstreamSampleUsage"
		},
		Author->{"alou", "robert"}
	}
];