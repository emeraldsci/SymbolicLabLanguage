(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCells*)

DefineUsage[ExperimentIncubateCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIncubateCells[Samples]", "Protocol"},
				Description -> "creates a 'Protocol' object to grow or maintain the provided 'Samples' containing mammalian, yeast, or bacterial cells, with desired incubation conditions.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples containing target cells which are held at desired incubation condition.",
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
						Description -> "A protocol object for placing cell culture samples into cell culture incubators and growing cells at desired conditions during the incubation.",
						Pattern :> ListableP[ObjectP[Object[Protocol, IncubateCells]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentIncubateCellsQ",
			"ExperimentIncubateCellsOptions",
			"IncubateCellsDevices",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation",
			"ExperimentCellPreparation"
		},
		Tutorials -> {},
		Author -> {"harrison.gronlund", "lige.tonggu", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*IncubateCellsDevices*)

DefineUsage[IncubateCellsDevices,
	{
		BasicDefinitions -> {
			{
				Definition -> {"IncubateCellsDevices[inputs]", "incubatorModels"},
				Description -> "returns a list of cell incubator model(s) can be used to incubate with the specified option settings.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "inputs",
							Description -> "The container models, containers, and/or samples that should be incubated or the desired incubation conditions.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container], Object[Sample]}]
								],
								"IncubationCondition" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[StorageCondition]}]
								],
								"All" -> 	Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[All]
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "incubatorModels",
						Description -> "The list of incubator models that can be used to incubate the inputs with the specified option settings.",
						Pattern :> ListableP[{ObjectP[Model[Instrument, Incubator]]|{ObjectP[Model[Instrument, Incubator]], {ObjectP[Model[Container]]..}}..}]
					}
				}
			},
			{
				Definition -> {"IncubateCellsDevices[]", "incubatorModels"},
				Description -> "returns a list of cell incubator model(s) can be used to incubate with the specified option settings.",
				Inputs :> {},
				Outputs :> {
					{
						OutputName -> "incubatorModels",
						Description -> "The list of incubator models that can be used to incubate with the specified option settings.",
						Pattern :> ListableP[{{ObjectP[Model[Instrument, Incubator]], {ObjectP[Model[Container]]..}}..}]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentIncubateCells"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"harrison.gronlund", "lige.tonggu", "steven"}
	}];

(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCellsOptions*)

DefineUsage[ExperimentIncubateCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIncubateCellsOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved incubation options for provided sample or container 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples containing target cells which are held at desired incubation condition.",
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
						Description -> "Resolved options when ExperimentIncubateCells is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol, Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentIncubateCellsQ",
			"ExperimentIncubateCells"
		},
		Tutorials -> {},
		Author -> {"harrison.gronlund", "lige.tonggu", "steven"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExperimentIncubateCellsPreview*)

DefineUsage[ExperimentIncubateCellsPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIncubateCellsPreview[Samples]", "Preview"},
				Description -> "returns the preview for ExperimentIncubateCells when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples containing target cells which are held at desired incubation condition.",
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
						Description -> "Graphical preview representing the output of ExperimentIncubateCells. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentIncubateCellsQ",
			"ExperimentIncubateCells",
			"ExperimentIncubateCellsOptions"
		},
		Tutorials -> {},
		Author -> {"harrison.gronlund", "lige.tonggu", "steven"}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentIncubateCellsQ*)

DefineUsage[ValidExperimentIncubateCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentIncubateCellsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentIncubateCells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples containing target cells which are held at desired incubation condition.",
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
						Description -> "Whether or not the ExperimentIncubateCells call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentIncubateCells",
			"ExperimentIncubateCellsOptions"
		},
		Tutorials -> {},
		Author -> {"harrison.gronlund", "lige.tonggu", "steven"}
	}];