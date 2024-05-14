(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ExperimentFilter,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentFilter[Objects]","Protocol"},
				Description->"creates a filter 'Protocol' which can use a variety of different techniques to purify 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be filtered during the protocol.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
						Description->"The protocol object(s) describing how to run the Filter experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,Filter]]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentFilterQ",
			"ExperimentFilterOptions",
			"ExperimentMix",
			"ExperimentIncubate",
			"ExperimentCentrifuge",
			"ExperimentAliquot"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"steven", "dima"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentFilterOptions*)


DefineUsage[ExperimentFilterOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFilterOptions[Objects]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentFilter when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be filtered during the protocol.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentFilter is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentFilter if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentFilter",
			"ExperimentFilterPreview",
			"ValidExperimentFilterQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven", "dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentFilterPreview*)


DefineUsage[ExperimentFilterPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFilterPreview[Objects]", "Preview"},
				Description -> "returns the preview for ExperimentFilter when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be filtered during the protocol.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentFilter.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFilter",
			"ExperimentFilterOptions",
			"ValidExperimentFilterQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven", "dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentFilterQ*)


DefineUsage[ValidExperimentFilterQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentFilterQ[Objects]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentFilter.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose contents are to be filtered during the protocol.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentFilter call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFilter",
			"ExperimentFilterPreview",
			"ExperimentFilterOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"steven", "dima"}
	}
];