(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentDynamicFoamAnalysis*)


(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysis Usage*)

DefineUsage[ExperimentDynamicFoamAnalysis,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDynamicFoamAnalysis[Samples]","Protocol"},
				Description->"generates a 'Protocol' object for running an experiment to characterize foam generation and decay for 'Samples' over time.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers to be analyzed during the protocol.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
											PatternTooltip -> "Enumeration must be any well from A1 to H12."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size->Line
										]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
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
						Description->"The protocol object(s) describing how to run the dynamic foam analysis experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,DynamicFoamAnalysis]]]
					}
				}
			}
		},
		MoreInformation->{
			"'Samples' will be discarded at the end of the protocol."
		},
		SeeAlso->{
			"ValidExperimentDynamicFoamAnalysisQ",
			"ExperimentDynamicFoamAnalysisOptions",
			"ExperimentDynamicFoamAnalysisPreview",
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureViscosity"
		},
		Author->{"lei.tian", "andrey.shur", "cgullekson", "marie.wu"}
	}
];



(* ::Subsubsection:: *)
(*ValidExperimentDynamicFoamAnalysisQ*)


DefineUsage[ValidExperimentDynamicFoamAnalysisQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentDynamicFoamAnalysisQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentDynamicFoamAnalysis.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers that will be run in a dynamic foam analysis experiment.",
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
						Description->"Returns whether the ExperimentDynamicFoamAnalysis call is valid or not.  Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDynamicFoamAnalysis",
			"ExperimentDynamicFoamAnalysisOptions",
			"ValidExperimentDynamicFoamAnalysisQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"lei.tian", "andrey.shur", "cgullekson", "marie.wu"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysisPreview*)


DefineUsage[ExperimentDynamicFoamAnalysisPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDynamicFoamAnalysisPreview[Samples]","Preview"},
				Description->"returns Null, as there is no graphical preview of the output of ExperimentDynamicFoamAnalysis.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing samples that will be run in a dynamic foam analysis experiment.",
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
						Description->"Graphical preview representing the output of ExperimentDynamicFoamAnalysis.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDynamicFoamAnalysis",
			"ExperimentDynamicFoamAnalysisOptions",
			"ValidExperimentDynamicFoamAnalysisQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"lei.tian", "andrey.shur", "cgullekson", "marie.wu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysisPreview*)


DefineUsage[ExperimentDynamicFoamAnalysisOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDynamicFoamAnalysisOptions[Samples]","ResolvedOptions"},
				Description->"checks whether the provided samples and specified options are valid for calling ExperimentDynamicFoamAnalysis.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing the samples that will be run in a dynamic foam analysis experiment.",
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
						Description->"Resolved options when ExperimentDynamicFoamAnalysis is called on the input sample(s).",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentDynamicFoamAnalysis",
			"ValidExperimentDynamicFoamAnalysisQ",
			"ExperimentDynamicFoamAnalysisOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"lei.tian", "andrey.shur", "cgullekson", "marie.wu"}
	}
];