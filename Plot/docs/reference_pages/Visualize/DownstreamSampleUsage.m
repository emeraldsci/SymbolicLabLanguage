(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*DownstreamSampleUsage*)


DefineUsage[DownstreamSampleUsage,
	{
		BasicDefinitions->{
			{
				Definition->{"DownstreamSampleUsage[sample]","graphic"},
				Description->"returns a graph, and/or list of samples that were generated directly or indirectly by transfers out of a parent 'sample'.",
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
						Description->"The graph showing samples which were generated using the parent sample.",
						Pattern:>Alternatives[_Graph|_List]
					}
				}
			}
		},

		SeeAlso->{
			"PlotObject",
			"UpstreamSampleUsage"
		},
		Author->{"alou", "robert"}
	}
];