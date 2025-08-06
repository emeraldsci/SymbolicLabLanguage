(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentNMR*)


DefineUsage[ExperimentNMR,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMR[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring the nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a nuclear magnetic resonance spectrum will be obtained.",
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
								"Model Sample"->Widget[
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
						Description -> "A protocol object for measuring the nuclear magnetic resonance of input samples.",
						Pattern :> ObjectP[Object[Protocol, NMR]]
					}
				}
			}
		},
		MoreInformation -> {
			"NMR uses the excitation and relaxation of nuclear spin to characterize the composition and structure of compounds.",
			"All provided samples will be dissolved in the specified NMR solvent automatically prior to data collection."
		},
		SeeAlso -> {
			"ValidExperimentNMRQ",
			"ExperimentNMROptions",
			"ExperimentNMRPreview",
			"PlotNMR",
			"ExperimentNMR2D"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentNMRQ*)


DefineUsage[ValidExperimentNMRQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentNMRQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentNMR call for measuring the nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a nuclear magnetic resonance spectrum will be obtained.",
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
								"Model Sample"->Widget[
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
						Description -> "A True/False value indicating the validity of the provided ExperimentNMR call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentNMR proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentNMR",
			"ExperimentNMROptions",
			"ExperimentNMRPreview",
			"PlotNMR"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];


(* ::Subsection:: *)
(*ExperimentNMROptions*)


DefineUsage[ExperimentNMROptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMROptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for measuring the nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a nuclear magnetic resonance spectrum will be obtained.",
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
								"Model Sample"->Widget[
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
						Description -> "Resolved options when ExperimentNMROptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentNMR."
		},
		SeeAlso -> {
			"ExperimentNMR",
			"ValidExperimentNMRQ",
			"ExperimentNMRPreview",
			"PlotNMR"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];

(* ::Subsection:: *)
(*ExperimentNMRPreview*)


DefineUsage[ExperimentNMRPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMRPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the nuclear magnetic resonance (NMR) spectrum of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a nuclear magnetic resonance spectrum will be obtained.",
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
								"Model Sample"->Widget[
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
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided NMR experiment. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentNMR",
			"ValidExperimentNMRQ",
			"ExperimentNMROptions",
			"PlotNMR"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];