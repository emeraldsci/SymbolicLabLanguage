(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentTransfer*)

DefineUsage[ExperimentTransfer,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentTransfer[Sources, Destinations, Amounts]","Protocol"},
				Description -> "creates a 'Protocol' object that will transfer 'Amounts' of each of the 'Sources' to 'Destinations'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sources",
							Description-> "The samples or locations from which liquid or solid is transferred.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Sample]}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"New Container with Index"->{
									"Index" -> Widget[
										Type -> Number,
										Pattern :> GreaterEqualP[1, 1]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Container]}],
										PreparedSample -> False,
										PreparedContainer -> False
									]
								},
								"Existing Container with Well Position" -> {
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
											Size -> Line
										]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable -> True
						},
						{
							InputName -> "Destinations",
							Description-> "The sample or location to which the liquids/solids are transferred.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Item], Object[Container], Model[Container]}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"New Container with Index" -> {
									"Index" -> Widget[
										Type -> Number,
										Pattern :> GreaterEqualP[1, 1]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Container]}],
										PreparedSample -> False,
										PreparedContainer -> False
									]
								},
								"Existing Container with Well Position" -> {
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
											Size -> Line
										]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								},
								"Waste" -> Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Waste]
								]
							],
							Expandable -> True
						},
						{
							InputName -> "Amounts",
							Description -> "The volumes, masses, or counts of the samples to be transferred.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[0.1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								],
								"Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Milligram, 20 Kilogram],
									Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
								],
								"Count" -> Widget[
									Type -> Number,
									Pattern :> GreaterP[0., 1.]
								],
								"All" -> Widget[
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
						OutputName -> "Protocol",
						Description -> "The protocol object(s) describing how to perform the requested transfer.",
						Pattern :> ListableP[ObjectP[Object[Protocol, Transfer]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentTransferOptions",
			"ValidExperimentTransferQ",
			"ExperimentSamplePreparation"
		},
		Author -> {"steven", "lige.tonggu", "thomas"}
	}
]