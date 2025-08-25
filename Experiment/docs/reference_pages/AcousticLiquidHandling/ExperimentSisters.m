(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentAcousticLiquidHandlingPreview *)


DefineUsage[ExperimentAcousticLiquidHandlingPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandlingPreview[Sources, Destinations, Volumes]","Preview"},
				Description->"returns the graphical preview for ExperimentAcousticLiquidHandling when it is called on 'Sources', 'Destinations', 'Volumes'.",
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
								"Object"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample], Object[Container], Model[Container]}]
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
										PreparedContainer -> False
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
										Pattern:>ObjectP[{Object[Container, Plate], Model[Container, Plate]}]
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
											PreparedContainer -> False
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
						OutputName->"Preview",
						Description->"Graphical preview of the protocol object to be uploaded when calling ExperimentAcousticLiquidHandling on 'primitives'.",
						Pattern:>ListableP[ObjectP[Object[Protocol,AcousticLiquidHandling]]]
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingOptions",
			"ValidExperimentAcousticLiquidHandlingOptionsQ"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(* ExperimentAcousticLiquidHandlingOptions *)


DefineUsage[ExperimentAcousticLiquidHandlingOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAcousticLiquidHandlingOptions[Sources, Destinations, Volumes]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentAcousticLiquidHandling when it is called on 'Sources', 'Destinations', 'Volumes'.",
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
								"Object"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample], Object[Container], Model[Container]}]
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
										PreparedContainer -> False
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
										Pattern:>ObjectP[{Object[Container, Plate], Model[Container, Plate]}]
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
											PreparedContainer -> False
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
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentAcousticLiquidHandling is called on 'primitives'.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"This function returns the resolved options that would be fed to ExperimentAcousticLiquidHandling if it were called on 'primitives'."
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingPreview",
			"ValidExperimentAcousticLiquidHandlingQ"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(* ValidExperimentAcousticLiquidHandlingQ *)


DefineUsage[ValidExperimentAcousticLiquidHandlingQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentAcousticLiquidHandlingQ[Sources, Destinations, Volumes]","Booleans"},
				Description->"checks whether the provided 'Sources', 'Destinations', 'Volumes' and the specified options are valid for calling ExperimentAcousticLiquidHandling.",
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
								"Object"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample], Object[Container], Model[Container]}]
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
										PreparedContainer -> False
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
										Pattern:>ObjectP[{Object[Container, Plate], Model[Container, Plate]}]
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
											PreparedContainer -> False
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
						OutputName->"Booleans",
						Description->"Returns a boolean for whether or not the ExperimentAcousticLiquidHandling call is valid.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling",
			"ExperimentAcousticLiquidHandlingOptions",
			"ExperimentAcousticLiquidHandlingPreview"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];


(* ::Subsubsection:: *)
(*resolveAcousticLiquidHandlingSamplePrepOptions*)


DefineUsage[resolveAcousticLiquidHandlingSamplePrepOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"resolveAcousticLiquidHandlingSamplePrepOptions[Samples]","resolvedSamplePrepOptions"},
				Description->"checks whether the provided samples and specified sample prep options are valid for calling ExperimentAcousticLiquidHandling.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers containing the samples that will be transferred by acoustic liquid handling.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"resolvedSamplePrepOptions",
						Description->"Resolved sample prep options when ExperimentAcousticLiquidHandling is called on the input sample(s).",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAcousticLiquidHandling"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"mohamad.zandian", "hayley", "varoth.lilascharoen", "steven"}
	}
];