(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentAcousticLiquidHandlingPreview *)


DefineUsage[ExperimentAcousticLiquidHandlingPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandlingPreview[Primitives]","Preview"},
				Description->"returns the graphical preview for ExperimentAcousticLiquidHandling when it is called on 'primitives'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Primitives",
							Description->"The transfer of samples to be performed by an acoustic liquid handler.",
							Widget->acousticLiquidHandlingInputPatternWidget,
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment primitives"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview of the protocol object to be uploaded when calling ExperimentAcousticLiquidHandling on 'primitives'.",
						Pattern:>ListableP[ObjectP[Object[Protocol,AcousticLiquidHandling]]]
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingOptions",
			"ValidExperimentAcousticLiquidHandlingOptionsQ"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(* ExperimentAcousticLiquidHandlingOptions *)


DefineUsage[ExperimentAcousticLiquidHandlingOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandlingOptions[Primitives]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentAcousticLiquidHandling when it is called on 'primitives'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Primitives",
							Description->"The transfer of samples to be performed by an acoustic liquid handler.",
							Widget->acousticLiquidHandlingInputPatternWidget,
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment primitives"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentAcousticLiquidHandling is called on 'primitives'.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"This function returns the resolved options that would be fed to ExperimentAcousticLiquidHandling if it were called on 'primitives'."
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingPreview",
			"ValidExperimentAcousticLiquidHandlingQ"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(* ValidExperimentAcousticLiquidHandlingQ *)


DefineUsage[ValidExperimentAcousticLiquidHandlingQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentAcousticLiquidHandlingQ[Primitives]","Booleans"},
				Description->"checks whether the provided 'primitives' and the specified options are valid for calling ExperimentAcousticLiquidHandling.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Primitives",
							Description->"The transfer of samples to be performed by an acoustic liquid handler.",
							Widget->acousticLiquidHandlingInputPatternWidget,
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment primitives"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description->"Returns a boolean for whether or not the ExperimentAcousticLiquidHandling call is valid.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingOptions",
			"ExperimentAcousticLiquidHandlingPreview"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(*resolveAcousticLiquidHandlingSamplePrepOptions*)


DefineUsage[resolveAcousticLiquidHandlingSamplePrepOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"resolveAcousticLiquidHandlingSamplePrepOptions[Samples]","resolvedSamplePrepOptions"},
				Description->"checks whether the provided samples and specified sample prep options are valid for calling ExperimentAcousticLiquidHandling.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing the samples that will be transferred by acoustic liquid handling.",
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
						OutputName->"resolvedSamplePrepOptions",
						Description->"Resolved sample prep options when ExperimentAcousticLiquidHandling is called on the input sample(s).",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];