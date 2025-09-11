(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCover*)

DefineUsage[ValidExperimentCoverQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentCoverQ[Containers]","valid"},
				Description->"determines if the covering is properly specified and can be performed.",
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
						OutputName->"valid",
						Description->"A boolean indicating if the covering is properly specified and can be performed",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCoverOptions",
			"ExperimentCover",
			"ExperimentManualSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
];


DefineUsage[ExperimentCoverOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCoverOptions[Containers]","ResolvedOptions"},
				Description->"calculates the full set of options which determine how the covering will be performed.",
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
						OutputName->"ResolvedOptions",
						Description->"The full set of options which determine how the covering will be performed.",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCoverOptions",
			"ExperimentCover",
			"ExperimentManualSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
];