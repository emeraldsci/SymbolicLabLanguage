

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDensity*)

DefineUsage[ExperimentMeasureDensity,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureDensity[Objects]","Protocol"},
				Description->"creates a MeasureDensity 'Protocol' which determine the density of 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents density will be measured.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the MeasureDensity experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MeasureDensity]]]
					}
				}
			}
		},
		MoreInformation -> {
			"Based on the input volume given, fixed volume weight or U-tube oscillation measurement methods will be used to measure the density of the given sample(s)."
		},
		SeeAlso -> {
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMeasurepH",
			"ExperimentImageSample"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"waseem.vali", "malav.desai", "cgullekson", "awixtrom", "wyatt", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDensityOptions*)


DefineUsage[ExperimentMeasureDensityOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureDensityOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMeasureDensity when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents density will be measured.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureDensity is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasureDensity if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureDensity",
			"ExperimentMeasureDensityPreview",
			"ValidExperimentMeasureDensityQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"waseem.vali", "malav.desai", "cgullekson", "awixtrom", "wyatt", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDensityPreview*)


DefineUsage[ExperimentMeasureDensityPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureDensityPreview[Objects]", "Preview"},
				Description -> "returns the preview for ExperimentMeasureDensity when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents density will be measured.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureDensity.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureDensity",
			"ExperimentMeasureDensityOptions",
			"ValidExperimentMeasureDensityQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson", "awixtrom", "wyatt", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMeasureDensityQ*)


DefineUsage[ValidExperimentMeasureDensityQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureDensityQ[Objects]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentMeasureDensity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents density will be measured.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentMeasureDensity call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureDensity",
			"ExperimentMeasureDensityPreview",
			"ExperimentMeasureDensityOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson", "awixtrom", "wyatt", "paul"}
	}
];