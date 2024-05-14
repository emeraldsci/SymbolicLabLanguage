(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentCoulterCount*)

DefineUsage[ExperimentCoulterCount,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCoulterCount[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for counting and sizing particles (typically cells) of difference sizes in the provided 'Samples' by suspending them in a conductive electrolyte solution, pumping them through an aperture, and measuring the corresponding electrical resistance change caused by particles in place of the ions passing through the aperture. The electrical resistance change is measured by a voltage pulse recorded by the electronics such that the particle count is derived from the number of voltage pulses and the particle size is derived from the pulse shape and peak intensities.",
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
						Description -> "The protocol object that describes the electrical resistance measurement.",
						Pattern :> ListableP[ObjectP[Object[Protocol, CoulterCount]]]
					}
				}
			}
		},
		MoreInformation -> {}, (* shows up in Details And Options of the help file - does not need this for experiment functions FOR NOW *)
		SeeAlso -> {
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