

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCircularDichroism*)

DefineUsage[ExperimentCircularDichroism,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCircularDichroism[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring the differential absorption of left and right circularly polarized light of the 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object for measuring circular dichroism of samples.",
						Pattern :> ObjectP[Object[Protocol, CircularDichroism]]
					}
				}
			}
		},
		MoreInformation -> {
			"For measurement below 300 nm, the sample needs to be loaded into quartz plate (Model[Container, Plate, \"Hellma Black Quartz Microplate\"]). Quartz plates have high birefringence in the outer ring of wells. So the circular dichroism data collected in the outer ring of wells have noise levels. With MoatSize == 2 (default value), the protocol will ignore the outer ring of wells in the plate."
		},
		SeeAlso -> {
			"ValidExperimentCircularDichroismQ",
			"ExperimentCircularDichroismOptions",
			"ExperimentCircularDichroismPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"jihan.kim", "lige.tonggu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentCircularDichroismQ*)

DefineUsage[ValidExperimentCircularDichroismQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentCircularDichroismQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentCircularDichroism.",
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
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentCircularDichroism call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCircularDichroism",
			"ExperimentCircularDichroismOptions",
			"ExperimentCircularDichroismPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"jihan.kim", "lige.tonggu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCircularDichroismOptions*)

DefineUsage[ExperimentCircularDichroismOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCircularDichroismOptions[Samples]", "Booleans"},
				Description -> "returns the resolved options for ExperimentCircularDichroism when it is called on 'Samples'.",
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
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentCircularDichroism is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCircularDichroism",
			"ValidExperimentCircularDichroismQ",
			"ExperimentCircularDichroismPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"jihan.kim", "lige.tonggu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentCircularDichroismPreview*)

DefineUsage[ExperimentCircularDichroismPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCircularDichroismPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentCircularDichroism when it is called on 'Samples'. This output is always Null.",
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
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentCircularDichroism.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCircularDichroism",
			"ValidExperimentCircularDichroismQ",
			"ExperimentCircularDichroismOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"jihan.kim", "lige.tonggu"}
	}
];