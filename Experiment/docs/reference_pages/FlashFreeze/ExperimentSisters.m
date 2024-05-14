(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ValidExperimentFlashFreezeQ*)


DefineUsage[ValidExperimentFlashFreezeQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentFlashFreezeQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentFlashFreeze.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers that will be flash frozen.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Returns whether the ExperimentFlashFreeze call is valid or not.  Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentFlashFreeze",
			"ExperimentFlashFreezeOptions",
			"ValidExperimentFlashFreezeQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"ryan.bisbey", "axu", "steven", "marie.wu"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentFlashFreezePreview*)


DefineUsage[ExperimentFlashFreezePreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFlashFreezePreview[Samples]","Preview"},
				Description->"returns Null, as there is no graphical preview of the output of ExperimentFlashFreeze.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing samples that will be flash frozen.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentFlashFreeze.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentFlashFreeze",
			"ExperimentFlashFreezeOptions",
			"ValidExperimentFlashFreezeQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"ryan.bisbey", "axu", "steven", "marie.wu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentFlashFreezePreview*)


DefineUsage[ExperimentFlashFreezeOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentFlashFreezeOptions[Samples]","ResolvedOptions"},
				Description->"checks whether the provided samples and specified options are valid for calling ExperimentFlashFreeze.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing the samples that will be flash frozen.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentFlashFreeze is called on the input sample(s).",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentFlashFreeze",
			"ValidExperimentFlashFreezeQ",
			"ExperimentFlashFreezeOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"ryan.bisbey", "axu", "steven", "marie.wu"}
	}
];