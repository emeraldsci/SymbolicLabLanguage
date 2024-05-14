

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentNephelometry*)

DefineUsage[ExperimentNephelometry,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNephelometry[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring scattered light from the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which to measure scattered light.",
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
						Description -> "The protocol generated to measure scattered light from the provided input.",
						Pattern :> ObjectP[Object[Protocol, Nephelometry]]
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ValidExperimentNephelometryQ",
			"ExperimentNephelometryOptions",
			"ExperimentNephelometryPreview",
			"ExperimentNephelometryKinetics"
		},
		Author -> {"dima", "steven", "simon.vu", "hailey.hibbard"}
	}
];