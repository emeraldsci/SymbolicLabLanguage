(* ::Subsubsection::Closed:: *)
(*ValidExperimentNephelometryKineticsQ*)

DefineUsage[ValidExperimentNephelometryKineticsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentNephelometryKineticsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentNephelometryKinetics.",
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
						Description -> "Whether or not the ExperimentNephelometryKinetics call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometryKinetics",
			"ExperimentNephelometryKineticsOptions",
			"ExperimentNephelometryKineticsPreview",
			"ExperimentNephelometry"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometryKineticsOptions*)

DefineUsage[ExperimentNephelometryKineticsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNephelometryKineticsOptions[Samples]", "Booleans"},
				Description -> "returns the resolved options for ExperimentNephelometryKinetics when it is called on 'Samples'.",
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
						Description -> "Resolved options when ExperimentNephelometryKinetics is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometryKinetics",
			"ValidExperimentNephelometryKineticsQ",
			"ExperimentNephelometryKineticsPreview",
			"ExperimentNephelometry"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometryKineticsPreview*)

DefineUsage[ExperimentNephelometryKineticsPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNephelometryKineticsPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentNephelometryKinetics when it is called on 'Samples'.  This output is always Null.",
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
						Description -> "Graphical preview representing the output of ExperimentNephelometryKinetics.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentNephelometryKinetics",
			"ValidExperimentNephelometryKineticsQ",
			"ExperimentNephelometryKineticsOptions",
			"ExperimentNephelometry"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];