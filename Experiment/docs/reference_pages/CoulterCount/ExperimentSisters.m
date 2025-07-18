(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ValidExperimentCoulterCountQ*)

DefineUsage[ValidExperimentCoulterCountQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentCoulterCountQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentCoulterCount.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples (typically cells) to be counted and sized by the electrical resistance measurement.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
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
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentCoulterCount call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCoulterCount",
			"ExperimentCoulterCountOptions",
			"ExperimentCoulterCountPreview",
			"ExperimentCountLiquidParticles",
			"ExperimentDynamicLightScattering",
			"ExperimentNephelometry"
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
(*ExperimentCoulterCountOptions*)

DefineUsage[ExperimentCoulterCountOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCoulterCountOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the 'ResolvedOptions' for the electrical resistance measurement when ExperimentCoulterCount is called upon the provided 'Samples'." ,
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples (typically cells) to be counted and sized by the electrical resistance measurement.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
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
						Description -> "Resolved options when ExperimentCoulterCount is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCoulterCount",
			"ValidExperimentCoulterCountQ",
			"ExperimentCoulterCountPreview",
			"ExperimentCountLiquidParticles",
			"ExperimentDynamicLightScattering",
			"ExperimentNephelometry"
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
(*ExperimentCoulterCountPreview*)


DefineUsage[ExperimentCoulterCountPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCoulterCountPreview[Samples]", "Preview"},
				Description -> "returns Null, as there is no graphical preview of the output of ExperimentCoulterCount.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples (typically cells) to be counted and sized by the electrical resistance measurement.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
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
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentCoulterCount. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCoulterCount",
			"ExperimentCoulterCountOptions",
			"ValidExperimentCoulterCountQ",
			"ExperimentCountLiquidParticles",
			"ExperimentDynamicLightScattering",
			"ExperimentNephelometry"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {
			"lei.tian"
		}
	}
];