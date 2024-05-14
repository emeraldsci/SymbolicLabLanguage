(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentUncover*)

DefineUsage[ExperimentUncover,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentUncover[Containers]","Protocol"},
				Description->"creates a 'Protocol' object that will remove caps, lids, or plate seals to the tops of 'Containers' in order to expose their contents.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Containers",
							Description-> "The samples or containers that should be uncovered.",
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
						Description->"The protocol object(s) describing how to perform the requested uncovering.",
						Pattern:>ListableP[ObjectP[Object[Protocol,Uncover]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentUncoverOptions",
			"ValidExperimentUncoverOptions",
			"ExperimentSampleManipulation"
		},
		Tutorials -> {},
		Author -> {"waseem.vali", "malav.desai"}
	}
]