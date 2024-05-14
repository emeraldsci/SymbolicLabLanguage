(* ::Subsubsection::Closed:: *)
(*ExperimentELISAOptions*)
DefineUsage[ExperimentELISAOptions,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentELISAOptions[Samples]","ResolvedOptions"},
			Description->"returns the resolved options for ExperimentELISA when it is called on",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample], Object[Container]}],
							Dereference->{
								Object[Container]->Field[Contents[[All, 2]]]
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
					Description->"Resolved options when ExperimentELISA is called on the input samples and antibodies.",
					Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}
	},

	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSampleManipulation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentELISAPreview*)
DefineUsage[ExperimentELISAPreview,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentELISAPreview[Samples]","Preview"},
			Description->"returns the graphical preview for ExperimentELISA when it is called on 'Samples'.  This output is always Null.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample], Object[Container]}],
							Dereference->{
								Object[Container]->Field[Contents[[All, 2]]]
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
					Description->"Graphical preview representing the output of ExperimentELISA.  This value is always Null.",
					Pattern:>Null
				}
			}
		}
	},
	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSampleManipulation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentELISAQ*)
DefineUsage[ValidExperimentELISAQ,{

	BasicDefinitions->{
		{
			Definition->{"ValidExperimentELISAQ[Samples]","Boolean"},
			Description->"checks whether the provided inputs and specified options are valid for calling ExperimentELISA.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample], Object[Container]}],
							Dereference->{
								Object[Container]->Field[Contents[[All, 2]]]
							}
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Boolean",
					Description->"Whether or not the ExperimentELISA call is valid. Return value can be changed via the OutputFormat option.",
					Pattern:>_EmeraldTestSummary|BooleanP
				}
			}
		}
	},
	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSampleManipulation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];