(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureSurfaceTension*)


DefineUsage[ExperimentMeasureSurfaceTension,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureSurfaceTension[Samples]","Protocol"},
				Description->"generates a 'Protocol' object for determining the surface tensions of input 'Samples' at varying concentrations.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples to be diluted to varying concentrations and have their surface tensions determined.",
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
						OutputName->"Protocol",
						Description->"The protocol object for measuring the surface tension of input samples at varying concentrations.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MeasureSurfaceTension]]]
					}
				}
			}
		},
		MoreInformation -> {
			"The samples are loaded onto assay plates with 12 columns and 8 rows. The surface tension of each sample is determined by pulling a probe out of sample and measuring the
			force on the probe. Each row is measured with a separate probe starting with the 12th column of the plate containing a calibrant with a known surface tension. This information
			can be used to calculate the Critical Micelle Concentration of a sample. The Critical Micelle Concentration is the concentration of surfactants above which micelles form
			and all additional surfactants added to the system go to micelles. This can be determined with a Surface Tension vs. Log[Concentration] plot."
		},
		SeeAlso -> {
			"ValidExperimentMeasureSurfaceTensionQ",
			"ExperimentMeasureSurfaceTensionOptions",
			"ExperimentMeasureSurfaceTensionPreview",
			"AnalyzeCriticalMicelleConcentration",
			"PlotCriticalMicelleConcentration",
			"PlotSurfaceTension",
			"ExperimentMeasureDensity",
			"ExperimentMeasurepH"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureSurfaceTensionOptions*)


DefineUsage[ExperimentMeasureSurfaceTensionOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureSurfaceTensionOptions[Objects]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentMeasureSurfaceTension when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
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
						Description -> "Resolved options when ExperimentMeasureSurfaceTension is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasureSurfaceTension if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureSurfaceTensionPreview",
			"ValidExperimentMeasureSurfaceTensionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureSurfaceTensionPreview*)


DefineUsage[ExperimentMeasureSurfaceTensionPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureSurfaceTensionPreview[Objects]", "Preview"},
				Description -> "returns the preview for ExperimentMeasureSurfaceTension when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
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
						Description -> "Graphical preview representing the output of ExperimentMeasureSurfaceTension.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureSurfaceTensionOptions",
			"ValidExperimentMeasureSurfaceTensionQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMeasureSurfaceTensionQ*)


DefineUsage[ValidExperimentMeasureSurfaceTensionQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureSurfaceTensionQ[Objects]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentMeasureSurfaceTension.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
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
						Description -> "Whether or not the ExperimentMeasureSurfaceTension call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureSurfaceTensionPreview",
			"ExperimentMeasureSurfaceTensionOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"waseem.vali", "malav.desai", "cgullekson"}
	}
];