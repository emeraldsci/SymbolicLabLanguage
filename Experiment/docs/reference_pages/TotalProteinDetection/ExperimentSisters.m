(* ::Subsubsection::Closed:: *)
(*ExperimentTotalProteinDetectionOptions*)

DefineUsage[ExperimentTotalProteinDetectionOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentTotalProteinDetectionOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentTotalProteinDetection when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based total protein labeling and detection assay. Proteins present in the input samples are separated by size, labeled with biotin, then treated with a streptavidin-HRP conjugate. The presence of this conjugate is detected by chemiluminescence.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
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
						Description->"Resolved options when ExperimentTotalProteinDetection is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentTotalProteinDetection",
			"ExperimentTotalProteinDetectionPreview",
			"ValidExperimentTotalProteinDetectionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"andrey.shur", "lei.tian", "jihan.kim", "axu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentTotalProteinDetectionPreview*)

DefineUsage[ExperimentTotalProteinDetectionPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentTotalProteinDetectionPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentTotalProteinDetection when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based total protein labeling and detection assay. Proteins present in the input samples are separated by size, labeled with biotin, then treated with a streptavidin-HRP conjugate. The presence of this conjugate is detected by chemiluminescence.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentTotalProteinDetection.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentTotalProteinDetection",
			"ExperimentTotalProteinDetectionOptions",
			"ValidExperimentTotalProteinDetectionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"andrey.shur", "lei.tian", "jihan.kim", "axu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentTotalProteinDetectionQ*)

DefineUsage[ValidExperimentTotalProteinDetectionQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentTotalProteinDetectionQ[Samples]","Boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling ExperimentTotalProteinDetection.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be run through a capillary electrophoresis-based total protein labeling and detection assay. Proteins present in the input samples are separated by size, labeled with biotin, then treated with a streptavidin-HRP conjugate. The presence of this conjugate is detected by chemiluminescence.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs->{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentTotalProteinDetection call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentTotalProteinDetection",
			"ExperimentTotalProteinDetectionOptions",
			"ExperimentTotalProteinDetectionPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"andrey.shur", "lei.tian", "jihan.kim", "axu"}
	}
];