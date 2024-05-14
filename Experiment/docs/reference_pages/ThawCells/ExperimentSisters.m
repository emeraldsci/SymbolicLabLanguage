(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*ExperimentThawCellsOptions*)

DefineUsage[ExperimentThawCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentThawCellsOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentThawCells for the requested 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be thawed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentThawCells is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentThawCells if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentThawCells",
			"ValidExperimentThawCellsQ"
		},
		Author -> {
			"tim.pierpont",
			"thomas"
		}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentThawCellsQ*)

DefineUsage[ValidExperimentThawCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentThawCellsQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentThawCells.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be thawed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentThawCells call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentThawCells",
			"ExperimentThawCellsOptions"

		},
		Author -> {
			"tim.pierpont",
			"thomas"
		}
	}
];