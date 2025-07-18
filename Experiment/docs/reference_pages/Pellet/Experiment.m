(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentPellet*)


DefineUsage[ExperimentPellet,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPellet[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object to concentrate the denser, insoluble contents of a solution to the bottom of a given container via centrifugation, aspirate off the supernatant, optionally apply a wash solution that can be fed into multiple rounds of pelleting, and optionally add a resuspension solution to rehydrate the pellet.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that are spun via centrifugation in the attempt to form a pellet.",
							Widget -> Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]],
									ObjectTypes->{Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
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
						Description -> "A protocol object to concentrate the denser, insoluble contents of a solution to the bottom of a given container and to optionally aspirate the supernatant.",
						Pattern :> ObjectP[Object[Protocol, Pellet]]
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentPelletQ",
			"ExperimentPelletOptions",
			"ExperimentSamplePreparation",
			"ExperimentCentrifuge",
			"ExperimentFilter"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
	}
];