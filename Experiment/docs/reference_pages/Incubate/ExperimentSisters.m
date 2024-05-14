(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMixOptions*)

DefineUsage[ExperimentMixOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMixOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMix for the requested 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be mixed.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentMix is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMix if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMix",
			"ExperimentMixPreview",
			"ValidExperimentMixQ"
		},
		Author -> {"Yahya.Benslimane", "steven", "thomas", "lige.tonggu", "josh.kenchel"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMixPreview*)

DefineUsage[ExperimentMixPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMixPreview[Samples]","Preview"},
				Description -> "returns the preview for ExperimentMix for the requested 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be mixed.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentMix. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMix",
			"ExperimentMixOptions",
			"ValidExperimentMixQ"
		},
		Author -> {"Yahya.Benslimane", "dima", "thomas", "lige.tonggu", "josh.kenchel"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMixQ*)

DefineUsage[ValidExperimentMixQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMixQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentMix.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be mixed.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMix call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMix",
			"ExperimentMixOptions",
			"ExperimentMixPreview"

		},
		Author -> {"Yahya.Benslimane", "dima", "thomas", "lige.tonggu", "josh.kenchel"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateOptions*)

DefineUsage[ExperimentIncubateOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentIncubateOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentIncubate for the requested 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be incubated.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentIncubate is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentIncubate if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentIncubate",
			"ExperimentIncubatePreview",
			"ValidExperimentIncubateQ"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "thomas"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentIncubatePreview*)

DefineUsage[ExperimentIncubatePreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentIncubatePreview[Samples]","Preview"},
				Description -> "returns the preview for ExperimentIncubate for the requested 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be incubated.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentIncubate. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentIncubate",
			"ExperimentIncubateOptions",
			"ValidExperimentIncubateQ"
		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "thomas"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentIncubateQ*)

DefineUsage[ValidExperimentIncubateQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentIncubateQ[Samples]","Booleans"},
				Description -> "checks whether the requested 'Samples' and specified options are valid for calling ExperimentIncubate.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers to be incubated.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentIncubate call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentIncubate",
			"ExperimentIncubateOptions",
			"ExperimentIncubatePreview"

		},
		Author -> {"melanie.reschke", "yanzhe.zhu", "thomas"}
	}
];