(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCover*)

DefineUsage[ExperimentCover,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCover[Containers]","Protocol"},
				Description->"creates a 'Protocol' object that will secure caps, lids, or plate seals to the tops of 'Containers' in order to secure their contents.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Containers",
							Description-> "The samples or containers that should be covered.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to perform the requested covering.",
						Pattern:>ListableP[ObjectP[Object[Protocol,Cover]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCoverOptions",
			"ValidExperimentCoverOptions",
			"ExperimentSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
]