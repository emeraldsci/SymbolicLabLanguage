(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentFreezeCells*)


DefineUsage[ExperimentFreezeCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFreezeCells[Samples]", "Protocol"},
				Description -> "creates a 'Protocol' to generate frozen cells stocks from 'Samples' containing mammalian, yeast, or bacterial cells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples whose contents are to be frozen for long-term cryogenic storage.",
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
									"Well" -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
										PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
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
						Description -> "A protocol object for preparing and freezing cell stocks.",
						Pattern :> ObjectP[Object[Protocol, FreezeCells]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentFreezeCellsQ",
			"ExperimentFreezeCellsOptions",
			"PlotFreezeCells",
			"ExperimentCellPreparation",
			"ExperimentTransfer",
			"StoreSamples"
		},
		Author -> {"lige.tonggu", "tyler.pabst", "harrison.gronlund"}
	}
];

DefineUsage[ValidExperimentFreezeCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentFreezeCellsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentFreezeCells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples whose contents are to be frozen for long-term cryogenic storage.",
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
									"Well" -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
										PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentFreezeCells call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFreezeCells",
			"ExperimentFreezeCellsOptions"
		},
		Author -> {"lige.tonggu", "tyler.pabst", "harrison.gronlund"}
	}
];

DefineUsage[ExperimentFreezeCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFreezeCellsOptions[Samples]", "ResolvedOptions"},
				Description -> "outputs the resolved options of ExperimentFreezeCells with the provided inputs 'Samples' and specified options.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples whose contents are to be frozen for long-term cryogenic storage.",
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
									"Well" -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
										PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentFreezeCells is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol, Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFreezeCells",
			"ValidExperimentFreezeCellsQ"
		},
		Author -> {"lige.tonggu", "tyler.pabst", "harrison.gronlund"}
	}
];

DefineUsage[ExperimentFreezeCellsPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFreezeCellsPreview[Samples]", "Preview"},
				Description -> "returns the graphical 'Preview' for ExperimentIncubateCells when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples whose contents are to be frozen for long-term cryogenic storage.",
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
									"Well" -> Widget[
										Type -> Enumeration,
										Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
										PatternTooltip -> "Enumeration must be any well from A1 to " <> $MaxWellPosition <> "."
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentFreezeCells. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFreezeCells",
			"ValidExperimentFreezeCellsQ",
			"ExperimentFreezeCellsOptions",
			"PlotFreezeCells"
		},
		Author -> {"lige.tonggu", "tyler.pabst", "harrison.gronlund"}
	}
];