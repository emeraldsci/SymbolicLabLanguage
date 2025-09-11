(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentQuantifyCellsQ*)

DefineUsage[ValidExperimentQuantifyCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentQuantifyCellsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentQuantifyCells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be quantified.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
											PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
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
						Description -> "Whether or not the ExperimentQuantifyCells call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentQuantifyCells",
			"ExperimentQuantifyCellsOptions",
			"ExperimentQuantifyCellsPreview",
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentNephelometry",
			"ExperimentCoulterCount",
			"ExperimentImageCells",
			"AnalyzeCellCount"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {
			"lei.tian"
		}
	}
];

(* ::Subsection:: *)
(*ExperimentQuantifyCellsOptions*)

DefineUsage[ExperimentQuantifyCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentQuantifyCellsOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the 'ResolvedOptions' for the electrical resistance measurement when ExperimentQuantifyCells is called upon the provided 'Samples'." ,
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be quantified.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
											PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
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
						Description -> "Resolved options when ExperimentQuantifyCells is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentQuantifyCells",
			"ValidExperimentQuantifyCellsQ",
			"ExperimentQuantifyCellsPreview",
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentNephelometry",
			"ExperimentCoulterCount",
			"ExperimentImageCells",
			"AnalyzeCellCount"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {
			"lei.tian"
		}
	}
];


(* ::Subsection:: *)
(*ExperimentQuantifyCellsPreview*)


DefineUsage[ExperimentQuantifyCellsPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentQuantifyCellsPreview[Samples]", "Preview"},
				Description -> "returns Null, as there is no graphical preview of the output of ExperimentQuantifyCells.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be quantified.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
											PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
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
						Description -> "Graphical preview representing the output of ExperimentQuantifyCells. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentQuantifyCells",
			"ExperimentQuantifyCellsOptions",
			"ValidExperimentQuantifyCellsQ",
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentNephelometry",
			"ExperimentCoulterCount",
			"ExperimentImageCells",
			"AnalyzeCellCount"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {
			"lei.tian"
		}
	}
];