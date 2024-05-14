(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDialysis*)

DefineUsage[ExperimentDialysis,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentDialysis[Objects]","Protocol"},
				Description->"creates a dialysis 'Protocol' which removes small molecules 'objects' by diffusion.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
							Widget -> Alternatives[
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the Dialysis experiment.",
						Pattern:>ObjectP[Object[Protocol,Dialysis]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentDialysisQ",
			"ExperimentDialysisOptions",
			"ExperimentFilter"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"mohamad.zandian", "hayley", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDialysisOptions*)


DefineUsage[ExperimentDialysisOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDialysisOptions[Objects]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentDialysis when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
							Widget -> Alternatives[
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentDialysis is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentDialysis if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentDialysis",
			"ExperimentDialysisPreview",
			"ValidExperimentDialysisQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian", "hayley", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDialysisPreview*)


DefineUsage[ExperimentDialysisPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDialysisPreview[Objects]", "Preview"},
				Description -> "returns the preview for ExperimentDialysis when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
							Widget -> Alternatives[
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentDialysis.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDialysis",
			"ExperimentDialysisOptions",
			"ValidExperimentDialysisQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian", "hayley", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentDialysisQ*)


DefineUsage[ValidExperimentDialysisQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentDialysisQ[Objects]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentDialysis.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be dialyzed during the protocol.",
							Widget -> Alternatives[
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentDialysis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDialysis",
			"ExperimentDialysisPreview",
			"ExperimentDialysisOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian", "hayley", "cgullekson"}
	}
];