(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentFreezeCells*)


DefineUsage[ExperimentFreezeCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFreezeCells[Samples]","Protocol"},
				Description -> "creates a 'Protocol' to freeze the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The cell samples whose contents are to be frozen for long-term cryogenic storage.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Protocol",
						Description -> "Protocol generated to freeze the input samples.",
						Pattern :> ObjectP[Object[Protocol,FreezeCells]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentFreezeCellsQ",
			"ExperimentFreezeCellsOptions",
			"StoreSamples"
		},
		Author -> {"tyler.pabst", "eunbin.go", "jihan.kim", "gokay.yamankurt"}
	}
];

DefineUsage[ValidExperimentFreezeCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentFreezeCellsQ[Samples]","Boolean"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentFreezeCells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description ->"The cell samples whose contents are to be frozen for long-term cryogenic storage.",
							Widget -> Widget[
								Type -> Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								},
								PreparedSample->False
							],
							Expandable -> False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentFreezeCells call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFreezeCells",
			"ExperimentFreezeCellsOptions"
		},
		Author -> {"tyler.pabst", "eunbin.go", "jihan.kim", "gokay.yamankurt"}
	}
];

DefineUsage[ExperimentFreezeCellsOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFreezeCellsOptions[Samples]","ResolvedOptions"},
				Description->"outputs the resolved options of ExperimentFreezeCells with the provided inputs and specified options.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The cell samples whose contents are to be frozen for long-term cryogenic storage.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentFreezeCells is called on the input sample(s).",
						Pattern:>_List
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentFreezeCells",
			"ValidExperimentFreezeCellsQ"
		},
		Author -> {"tyler.pabst", "eunbin.go", "jihan.kim", "gokay.yamankurt"}
	}
];

DefineUsage[ExperimentFreezeCellsPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFreezeCellsPreview[Samples]","plots"},
				Description->"outputs temperature plots as a function of time for ExperimentFreezeCells with the provided inputs and specified options.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The cell samples whose contents are to be frozen for long-term cryogenic storage.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								},
								PreparedSample->False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Temperature vs time plots for each resolved batch when ExperimentFreezeCells is called on the input sample(s).",
						Pattern:>{_Graphics..}
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentFreezeCells",
			"ValidExperimentFreezeCellsQ",
			"ExperimentFreezeCellsOptions"
		},
		Author -> {"tyler.pabst", "eunbin.go", "jihan.kim", "gokay.yamankurt"}
	}
];