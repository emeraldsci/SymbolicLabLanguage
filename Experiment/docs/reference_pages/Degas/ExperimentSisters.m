(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ValidExperimentDegasQ*)


DefineUsage[ValidExperimentDegasQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentDegasQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentDegas.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers that will be degassed.",
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
						Description->"Returns whether the ExperimentDegas call is valid or not.  Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDegas",
			"ExperimentDegasOptions",
			"ValidExperimentDegasQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "axu", "boris.brenerman", "cgullekson", "marie.wu"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentDegasPreview*)


DefineUsage[ExperimentDegasPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDegasPreview[Samples]","Preview"},
				Description->"returns Null, as there is no graphical preview of the output of ExperimentDegas.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing samples that will be degassed.",
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
						Description->"Graphical preview representing the output of ExperimentDegas.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDegas",
			"ExperimentDegasOptions",
			"ValidExperimentDegasQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "axu", "boris.brenerman", "cgullekson", "marie.wu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentDegasPreview*)


DefineUsage[ExperimentDegasOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDegasOptions[Samples]","ResolvedOptions"},
				Description->"checks whether the provided samples and specified options are valid for calling ExperimentDegas.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing the samples that will be degassed.",
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
						Description->"Resolved options when ExperimentDegas is called on the input sample(s).",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDegas",
			"ValidExperimentDegasQ",
			"ExperimentDegasOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "axu", "boris.brenerman", "cgullekson", "marie.wu"}
	}
];