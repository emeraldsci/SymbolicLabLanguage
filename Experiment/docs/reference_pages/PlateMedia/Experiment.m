(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ExperimentPlateMedia,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPlateMedia[Media]","Protocol"},
				Description->"generates a 'Protocol' for transferring the 'Media' that consists of sterile liquid or heated solid media containing gelling agents to plates for cell culture incubation and growth.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Media",
							Description->"The media sample to be transferred to plates while heating with magnetic stirring in this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample,Media],Object[Sample],Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName->"media"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"Protocol specifying instructions for transferring the requested 'Media' from its source container to plates.",
						Pattern:>ObjectP[Object[Protocol,PlateMedia]]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentPlateMediaOptions",
			"ValidExperimentPlateMediaQ",
			"ExperimentMedia",
			"ExperimentStockSolution"
		},
		Author->{"eunbin.go"}
	}
]