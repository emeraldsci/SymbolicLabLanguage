(* ::Subsubsection::Closed:: *)
(*ValidExperimentNephelometryQ*)

DefineUsage[ValidExperimentNephelometryQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentNephelometryQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentNephelometry.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to H12" -> Widget[
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
								},
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentNephelometry call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometry",
			"ExperimentNephelometryOptions",
			"ExperimentNephelometryPreview",
			"ExperimentNephelometryKinetics"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometryOptions*)

DefineUsage[ExperimentNephelometryOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNephelometryOptions[Samples]", "Booleans"},
				Description -> "returns the resolved options for ExperimentNephelometry when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to H12" -> Widget[
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
								},
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentNephelometry is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometry",
			"ValidExperimentNephelometryQ",
			"ExperimentNephelometryPreview",
			"ExperimentNephelometryKinetics"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometryPreview*)

DefineUsage[ExperimentNephelometryPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNephelometryPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentNephelometry when it is called on 'Samples'. This output is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
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
										"A1 to H12" -> Widget[
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
								},
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentNephelometry.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometry",
			"ValidExperimentNephelometryQ",
			"ExperimentNephelometryOptions",
			"ExperimentNephelometryKinetics"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];