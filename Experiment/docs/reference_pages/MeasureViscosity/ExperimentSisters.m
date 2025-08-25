(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ValidExperimentMeasureViscosityQ*)


DefineUsage[ValidExperimentMeasureViscosityQ,
	{
		BasicDefinitions-> {
			{
				Definition->{"ValidExperimentMeasureViscosityQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentMeasureViscosity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers that will be concentrated by evaporation.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]}
								]
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Boolean",
						Description -> "Returns whether the ExperimentMeasureViscosity call is valid or not.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMeasureViscosity",
			"ExperimentMeasureViscosityOptions",
			"ValidExperimentMeasureViscosityQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"daniel.shlian", "andrey.shur", "lei.tian", "jihan.kim", "axu", "stacey.lee"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentMeasureViscosityPreview*)


DefineUsage[ExperimentMeasureViscosityPreview,
	{
		BasicDefinitions-> {
			{
				Definition->{"ExperimentMeasureViscosityPreview[Samples]","Preview"},
				Description->"returns Null, as there is no graphical preview of the output of ExperimentMeasureViscosity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers containing samples that will have their viscosity measured.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]}
								]
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureViscosity.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMeasureViscosity",
			"ExperimentMeasureViscosityOptions",
			"ValidExperimentMeasureViscosityQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"daniel.shlian", "andrey.shur", "lei.tian", "jihan.kim", "axu", "stacey.lee"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentMeasureViscosityPreview*)


DefineUsage[ExperimentMeasureViscosityOptions,
	{
		BasicDefinitions-> {
			{
				Definition->{"ExperimentMeasureViscosityOptions[Samples]","ResolvedOptions"},
				Description->"checks whether the provided samples and specified options are valid for calling ExperimentMeasureViscosity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers containing the samples that will have their viscosity measured.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]}
								]
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureViscosity is called on the input sample(s).",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMeasureViscosity",
			"ValidExperimentMeasureViscosityQ",
			"ExperimentMeasureViscosityOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"daniel.shlian", "andrey.shur", "lei.tian", "jihan.kim", "axu", "stacey.lee"}
	}
];