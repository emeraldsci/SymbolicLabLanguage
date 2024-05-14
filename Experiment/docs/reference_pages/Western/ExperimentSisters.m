(* ::Subsubsection::Closed:: *)
(*ExperimentWesternOptions*)

DefineUsage[ExperimentWesternOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentWesternOptions[Samples,Antibodies]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentWestern when it is called on 'Samples' and 'Antibodies'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based western blot. Western blot is an analytical method used to detect specific proteins in a tissue-derived mixture.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Antibodies",
							Description->"The PrimaryAntibody or PrimaryAntibodies which will be used along with the SecondaryAntibody to detect the input samples.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample], Model[Sample], Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentWestern is called on the input samples and Antibodies.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentWestern",
			"ExperimentWesternPreview",
			"ValidExperimentWesternQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"clayton.schwarz", "axu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentWesternPreview*)

DefineUsage[ExperimentWesternPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentWesternPreview[Samples,Antibodies]","Preview"},
				Description->"returns the graphical preview for ExperimentWestern when it is called on 'Samples' and 'Antibodies'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based western blot. Western blot is an analytical method used to detect specific proteins in a tissue-derived mixture.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Antibodies",
							Description->"The PrimaryAntibody or PrimaryAntibodies which will be used along with the SecondaryAntibody to detect the input samples.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample], Model[Sample], Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentWestern.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentWestern",
			"ExperimentWesternOptions",
			"ValidExperimentWesternQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"clayton.schwarz", "axu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentWesternQ*)

DefineUsage[ValidExperimentWesternQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentWesternQ[Samples,Antibodies]","Boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling ExperimentWestern.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based western blot. Western blot is an analytical method used to detect specific proteins in a tissue-derived mixture.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						{
							InputName->"Antibodies",
							Description->"The PrimaryAntibody or PrimaryAntibodies which will be used along with the SecondaryAntibody to detect the input samples.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample], Model[Sample], Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs->{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentWestern call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentWestern",
			"ExperimentWesternOptions",
			"ExperimentWesternPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"clayton.schwarz", "axu"}
	}
];