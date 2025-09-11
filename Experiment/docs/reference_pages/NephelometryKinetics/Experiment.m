

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometryKinetics*)

DefineUsage[ExperimentNephelometryKinetics,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentNephelometryKinetics[Samples]","Protocol"},
				Description->"generates a 'Protocol' for measuring scattered light from the provided 'Samples' over a period of time. Injections into the samples can be specified in order to develop kinetic assays and study solubility. Long term growth curves can be measured for cell cultures.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure scattered light.",
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
								},
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol generated to measure scattered light from the provided input.",
						Pattern:>ObjectP[Object[Protocol,NephelometryKinetics]]
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"ValidExperimentNephelometryKineticsQ",
			"ExperimentNephelometryKineticsOptions",
			"ExperimentNephelometryKineticsPreview",
			"ExperimentNephelometry"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "hailey.hibbard"}
	}
];

