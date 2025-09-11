(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentGrowCrystal*)

DefineUsage[ExperimentGrowCrystal,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrowCrystal[Samples]", "Protocol"},
				Description -> "creates a 'Protocol' object to prepare crystallization plate designed to grow crystals of the provided input 'Samples'. Once the crystallization plate is constructed by pipetting, it is placed in crystal incubator which takes daily images of 'Samples' using visible light, ultraviolet light and polarized light. The best crystals which grow can be passed along to ExperimentXRD to obtain diffraction patterns.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample solutions containing target proteins, peptides, nucleic acids or water soluble small molecules which will be plated in order to grow crystals.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size -> Line
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object to prepare a crystallization plate to grow crystals and to set up imaging scheduling to monitor the growth of crystals during the incubation.",
						Pattern :> ObjectP[Object[Protocol, GrowCrystal]]
					}
				}
			}
		},
		MoreInformation -> {
			"If the input samples are not in compatible containers, aliquots will automatically be transferred to the appropriate containers. Reagents may be optionally premixed as a means of optimizing the aliquoting process and reducing the time required for sample preparation."
		},
		SeeAlso -> {
			"ExperimentGrowCrystalOptions",
			"ValidExperimentGrowCrystalQ",
			"ExperimentAcousticLiquidHandling",
			"ExperimentRoboticSamplePreparation",
			"ExperimentTransfer",
			"PlotCrystallizationImagingLog"
		},
		Author -> {"lige.tonggu", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentGrowCrystalOptions*)


DefineUsage[ExperimentGrowCrystalOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrowCrystalOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentGrowCrystal when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample solutions containing target proteins, peptides, nucleic acids or water soluble small molecules which will be plated in order to grow crystals.",
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size -> Line
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options when ExperimentGrowCrystal is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentGrowCrystal",
			"ValidExperimentGrowCrystalQ"
		},
		Author -> {"lige.tonggu", "thomas"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentGrowCrystalPreview*)

DefineUsage[ExperimentGrowCrystalPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrowCrystalPreview[Samples]", "Preview"},
				Description -> "returns the preview for ExperimentGrowCrystal when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample solutions containing target proteins, peptides, nucleic acids or water soluble small molecules which will be plated in order to grow crystals.",
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size -> Line
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentGrowCrystal.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentGrowCrystal",
			"ExperimentGrowCrystalOptions",
			"ValidExperimentGrowCrystalQ"
		},
		Author -> {"lige.tonggu", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentGrowCrystalQ*)


DefineUsage[ValidExperimentGrowCrystalQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentGrowCrystalQ[Samples]", "Boolean"},
				Description -> "checks whether the provided 'Samples' and options are valid for calling ExperimentGrowCrystal.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The sample solutions containing target proteins, peptides, nucleic acids or water soluble small molecules which will be plated in order to grow crystals.",
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
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size -> Line
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "The value indicating whether the ExperimentGrowCrystal call is valid. The return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentGrowCrystal proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentGrowCrystal",
			"ExperimentGrowCrystalOptions"
		},
		Author -> {"lige.tonggu", "thomas"}
	}
];