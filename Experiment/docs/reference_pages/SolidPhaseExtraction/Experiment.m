(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsage[ExperimentSolidPhaseExtraction,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentSolidPhaseExtraction[Samples]","Protocol"},
				Description->"generates a 'Protocol' for separating dissolved compounds from 'Samples' according to their physical and chemical properties.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the SolidPhaseExtraction experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,SolidPhaseExtraction]]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentSolidPhaseExtractionQ",
			"ExperimentSolidPhaseExtractionOptions",
			"ExperimentHPLC",
			"ExperimentFPLC"
		},
		Author->{"steven","dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSolidPhaseExtractionOptions*)

DefineUsage[ExperimentSolidPhaseExtractionOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentSolidPhaseExtractionOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentSolidPhaseExtraction when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentSolidPhaseExtraction is called on the input Samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentSolidPhaseExtraction if it were called on these input Samples."
		},
		SeeAlso -> {
			"ExperimentSolidPhaseExtraction",
			"ExperimentSolidPhaseExtractionPreview",
			"ValidExperimentSolidPhaseExtractionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven","dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSolidPhaseExtractionPreview*)
DefineUsage[ExperimentSolidPhaseExtractionPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentSolidPhaseExtractionPreview[Samples]", "Preview"},
				Description -> "returns the preview for ExperimentSolidPhaseExtraction when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentSolidPhaseExtraction.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSolidPhaseExtraction",
			"ExperimentSolidPhaseExtractionOptions",
			"ValidExperimentSolidPhaseExtractionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven","dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentSolidPhaseExtractionQ*)

DefineUsage[ValidExperimentSolidPhaseExtractionQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentSolidPhaseExtractionQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentSolidPhaseExtraction.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples on which the experiment should act.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentSolidPhaseExtraction call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSolidPhaseExtraction",
			"ExperimentSolidPhaseExtractionPreview",
			"ExperimentSolidPhaseExtractionOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven","dima"}
	}
];