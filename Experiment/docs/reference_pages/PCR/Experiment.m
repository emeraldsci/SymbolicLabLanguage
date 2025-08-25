(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPCR*)


DefineUsage[ExperimentPCR,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPCR[Samples]","Protocol"},
				Description->"creates a 'Protocol' object for running a polymerase chain reaction (PCR) experiment, which uses a thermocycler to amplify target sequences from the 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the polymerase chain reaction (PCR) experiment.",
						Pattern:>ObjectP[Object[Protocol,PCR]]
					}
				}
			},
			{
				Definition->{"ExperimentPCR[Samples,PrimerPairs]","Protocol"},
				Description->"creates a 'Protocol' object for running a polymerase chain reaction (PCR) experiment, which uses a thermocycler to amplify target sequences from the 'Samples' using the 'PrimerPairs'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable->False
						},
						{
							InputName -> "PrimerPairs",
							Description -> "The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
							Widget -> Adder[{
								"Forward Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								],
								"Reverse Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								]
							}],
							Expandable -> False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the polymerase chain reaction (PCR) experiment.",
						Pattern:>ObjectP[Object[Protocol,PCR]]
					}
				}
			}
		},
		MoreInformation->{
			"If the input samples are not in compatible containers, aliquots will automatically be transferred to the appropriate containers."
		},
		SeeAlso->{
			"ExperimentPCROptions",
			"ValidExperimentPCRQ",
			"ExperimentqPCR"
		},
		Author->{"xu.yi", "mohamad.zandian", "weiran.wang", "lige.tonggu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentPCROptions*)


DefineUsage[ExperimentPCROptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPCROptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentPCR when it is called on the 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentPCR is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"ExperimentPCROptions[Samples,PrimerPairs]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentPCR when it is called on the 'Samples' and 'PrimerPairs'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
							Widget -> Adder[{
								"Forward Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								],
								"Reverse Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentPCR is called on the input samples and primer pairs.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentPCR",
			"ExperimentqPCR",
			"ValidExperimentPCRQ"
		},
		Author->{"lige.tonggu", "thomas", "weiran.wang", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentPCRPreview*)


DefineUsage[ExperimentPCRPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPCRPreview[Samples]","Preview"},
				Description->"returns a graphical preview for ExperimentPCR when it is called on the 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentPCR. This value is always Null.",
						Pattern:>Null
					}
				}
			},
			{
				Definition->{"ExperimentPCRPreview[Samples,PrimerPairs]","Preview"},
				Description->"returns a graphical preview for ExperimentPCR when it is called on the 'Samples' and 'PrimerPairs'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
							Widget -> Adder[{
								"Forward Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								],
								"Reverse Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentPCR. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentPCR",
			"ExperimentPCROptions",
			"ValidExperimentPCRQ"
		},
		Author->{"lige.tonggu", "thomas", "weiran.wang", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentPCRQ*)


DefineUsage[ValidExperimentPCRQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentPCRQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and options are valid for calling ExperimentPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates and primer pairs for the amplification of the target sequences.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentPCR call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			},
			{
				Definition->{"ValidExperimentPCRQ[Samples,PrimerPairs]","Boolean"},
				Description->"checks whether the provided 'Samples' and 'PrimerPairs' and options are valid for calling ExperimentPCR.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples containing nucleic acid templates from which the target sequences will be amplified.",
							Widget->Alternatives[
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
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						{
							InputName->"PrimerPairs",
							Description->"The samples containing pairs of oligomer strands designed to bind to the templates and serve as anchors for the polymerase.",
							Widget -> Adder[{
								"Forward Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								],
								"Reverse Primer" -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
									Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
								]
							}],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentPCR call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentPCR",
			"ExperimentPCROptions"
		},
		Author->{"lige.tonggu", "thomas", "weiran.wang", "eqian"}
	}
];