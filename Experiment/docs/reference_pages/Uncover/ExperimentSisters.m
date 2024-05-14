(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentUncover*)

DefineUsage[ValidExperimentUncoverQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentUncoverQ[containers]","valid"},
				Description->"determines if the uncovering is properly specified and can be performed.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "containers",
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
						OutputName->"valid",
						Description->"A boolean indicating if the uncovering is properly specified and can be performed",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentUncoverOptions",
			"ExperimentUncover",
			"ExperimentManualSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"waseem.vali", "malav.desai"}
	}
];


DefineUsage[ExperimentUncoverOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentUncoverOptions[containers]","ResolvedOptions"},
				Description->"calculates the full set of options which determine how the uncovering will be performed.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "containers",
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
						OutputName->"ResolvedOptions",
						Description->"The full set of options which determine how the uncovering will be performed.",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentUncoverOptions",
			"ExperimentUncover",
			"ExperimentManualSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"waseem.vali", "malav.desai"}
	}
];