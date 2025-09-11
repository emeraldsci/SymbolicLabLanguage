(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentPrecipitation*)

DefineUsage[ExperimentPrecipitate,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPrecipitate[Samples]", "Protocol"},
				Description -> "Generates a 'Protocol' object to add a precipitation reagent that alters the solubility of 'Samples' and then concentrate the denser, insoluble contents of the solution to the bottom of a given container in order to optionally collect the supernatant or pellet dependant on which phase the target molecules are expected to be located in.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be exposed to a precipitation reagent and spun via centrifugation in the attempt to form a pellet.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Container with Well Position"->{
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
						Description -> "A protocol object to add a precipitation reagent that alters the solubility a solution's contents and then concentrate the denser, insoluble contents of the solution to the bottom of a given container in order to optionally collect the supernatant or pellet dependant on which phase the target molecules are expected to be located in.",
						Pattern :> ObjectP[Object[Protocol, Precipitate]](*TODO, in ExpPellet, it also has NMR*)
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentPrecipitateQ",
			"ExperimentPrecipitateOptions",
			"ExperimentRoboticSamplePreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {
			"taylor.hochuli"
		}
	}
];