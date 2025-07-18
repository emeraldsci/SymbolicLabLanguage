(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

DefineUsage[ExperimentPAGE,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPAGE[Samples]","Protocol"},
				Description->"generates a 'Protocol' object for running polyacrylamide gel electrophoresis on 'Samples'.",
				Inputs:> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be run through polyacrylamide gel electrophoresis.",
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
						OutputName->"Protocol",
						Description->"A protocol object for running polyacrylamide gel electrophoresis on samples.",
						Pattern:>ObjectP[Object[Protocol,PAGE]]
					}
				}
			}
		},
		MoreInformation->{
		(* Will need more stuff here about recommended SampleVolume for oligomers and proteins as well as ladder info and maybe loading buffer volumes, etc *)
			"A maximum of 72 samples across four gels can be run in one protocol, with two ladders automatically inserted into each gel.",
			"The optimal amount of oligomer samples is between 45 to 150 ng of total material in the SampleVolume. An input sample concentration between 15 and 50 ng/uL and a SampleVolume of 3 uL is recommended."
		},
		SeeAlso->{
			"ValidExperimentPAGEQ",
			"ExperimentPAGEOptions",
			"AnalyzePeaks",
			"ExperimentDNASynthesis"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"ryan.bisbey", "hanming.yang", "nont.kosaisawe", "xiwei.shan", "spencer.clark"}
	}
];