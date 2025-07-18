(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling Input Widget*)



(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling*)


DefineUsage[ExperimentAcousticLiquidHandling,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandling[Sources, Destinations, Volumes]","Protocol"},
				Description->"generates a liquid transfer 'Protocol' that will transfer 'Volumes' of each of the 'Sources' to 'Destinations' using sound waves.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sources",
							Description-> "The samples or locations from which liquid is transferred.",
							Widget -> Alternatives[
								"Object"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample], Object[Container]}],
									Dereference->{Object[Container]->Field[Contents[[All,2]]]}
								],
								"Position"->{
									"Well"->Widget[
										Type->String,
										Pattern:>WellPositionP,
										Size->Line,
										PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[Object[Container]]
									]
								}
							],
							Expandable -> True
						},
						{
							InputName -> "Destinations",
							Description-> "The sample or location to which the liquids are transferred.",
							Widget -> Alternatives[
								"Object"-> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Container]}],
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Containers"
										},
										{
											Object[Catalog, "Root"],
											"Materials",
											"Acoustic Liquid Handling",
											"Acoustic Liquid Handling Plates"
										}
									}
								],
								"New Container with Index" -> {
									"Index" -> Widget[
										Type -> Number,
										Pattern :> GreaterEqualP[1, 1]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Container, Plate]}],
										PreparedSample -> False,
										PreparedContainer -> False,
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Containers"
											},
											{
												Object[Catalog, "Root"],
												"Materials",
												"Acoustic Liquid Handling",
												"Acoustic Liquid Handling Plates"
											}
										}
									]
								},
								"Container with Well Position"->{
									"Well"->Widget[
										Type->String,
										Pattern:>WellPositionP,
										Size->Line,
										PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container, Plate], Model[Container, Plate]}],
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Containers"
											},
											{
												Object[Catalog, "Root"],
												"Materials",
												"Acoustic Liquid Handling",
												"Acoustic Liquid Handling Plates"
											}
										}
									]
								},
								"Container with Well Position and Index"->{
									"Well"->Widget[
										Type->String,
										Pattern:>WellPositionP,
										Size->Line,
										PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"
									],
									"Container with Index"->{
										"Index" -> Widget[
											Type -> Number,
											Pattern :> GreaterEqualP[1, 1]
										],
										"Container" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{Model[Container, Plate]}],
											PreparedSample -> False,
											PreparedContainer -> False,
											OpenPaths -> {
												{
													Object[Catalog, "Root"],
													"Containers"
												},
												{
													Object[Catalog, "Root"],
													"Materials",
													"Acoustic Liquid Handling",
													"Acoustic Liquid Handling Plates"
												}
											}
										]
									}
								}
							],
							Expandable -> True
						},
						{
							InputName -> "Volumes",
							Description -> "The volumes of the samples to be transferred.",
							Widget -> Widget[
								Type->Quantity,
								Pattern:>GreaterEqualP[0*Nanoliter],
								Units->{Nanoliter,{Nanoliter,Microliter}}
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions to perform the requested sample transfer with the acoustic liquid handler.",
						Pattern:>ListableP[ObjectP[Object[Protocol,AcousticLiquidHandling]]]
					}
				}
			}
		},
		MoreInformation->{
			"The acoustic liquid handler can transfer liquid sample between 2.5 Nanoliter and 5 Microliter."
		},
		SeeAlso->{
			"ExperimentTransfer",
			"ExperimentAcousticLiquidHandlingOptions",
			"ExperimentAcousticLiquidHandlingPreview",
			"ValidExperimentAcousticLiquidHandlingQ"
		},
		Author->{"yanzhe.zhu", "clayton.schwarz", "varoth.lilascharoen", "steven"}
	}
];