(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentCentrifuge*)


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifuge*)


DefineUsage[ExperimentCentrifuge,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCentrifuge[Samples]","Protocol"},
				Description->"generates a 'Protocol' to subject the provided 'Samples' to greater than gravitational force by rapid spinning.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers to be centrifuged.",
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol describing how to centrifuge the samples.",
						Pattern:>ObjectP[Object[Protocol,Centrifuge]]
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentCentrifugeQ",
			"ExperimentCentrifugeOptions",
			"ExperimentSampleManipulation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "tyler.pabst", "weiran.wang", "axu", "chi.zhao"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugeOptions*)


DefineUsage[ExperimentCentrifugeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCentrifugeOptions[Samples]","ResolvedOptions"},
				Description-> "generates the 'ResolvedOptions' for subjecting the provided 'Samples' to greater than gravitational force by rapid spinning.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers to be centrifuged.",
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentCentrifuge is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCentrifuge",
			"ValidExperimentCentrifugeQ",
			"ExperimentSampleManipulation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "tyler.pabst", "weiran.wang", "axu", "chi.zhao"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugePreview*)


DefineUsage[ExperimentCentrifugePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCentrifugePreview[Samples]","Preview"},
				Description -> "returns Null, as there is no graphical preview of the output of ExperimentCentrifuge.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers to be centrifuged.",
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentCentrifuge. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCentrifuge",
			"ValidExperimentCentrifugeQ",
			"ExperimentCentrifugeOptions",
			"ExperimentSampleManipulation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "tyler.pabst", "weiran.wang", "axu", "chi.zhao"}
	}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentCentrifugeQ*)


DefineUsage[ValidExperimentCentrifugeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentCentrifugeQ[Samples]","Boolean"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentCentrifuge.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers to be centrifuged.",
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentCentrifuge call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentCentrifuge",
			"ExperimentCentrifugeOptions",
			"ExperimentSampleManipulation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "daniel.shlian", "weiran.wang", "axu", "chi.zhao"}
	}
];


(* ::Subsubsection::Closed:: *)
(*CentrifugeDevices*)
DefineUsage[CentrifugeDevices,
	{
		BasicDefinitions->{
			{
				Definition->{"CentrifugeDevices[inputs]","centrifugeModels"},
				Description->"determines what centrifuge model(s) can be used to centrifuge the inputs with the specified option settings.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"inputs",
							Description->"The container models, containers, and/or samples for which centrifuges will be found.",
							Widget->Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container],Object[Container],Object[Sample]}]
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"centrifugeModels",
						Description->"Centrifuge model(s) that can be used to centrifuge the inputs with the specified option settings.",
						Pattern:>ListableP[{ObjectP[Model[Instrument, Centrifuge]] ...}]
					}
				}
			},
			{
				Definition->{"CentrifugeDevices[]","centrifugeModels"},
				Description->"determines what centrifuge model(s) can be used to centrifuge with the specified option settings.",
				Inputs:>{
				},
				Outputs:>{
					{
						OutputName->"centrifugeModels",
						Description->"Centrifuge model(s) and corresponding containers that can be used to centrifuge with the specified option settings.",
						Pattern:>ListableP[{{ObjectP[Model[Instrument, Centrifuge]], {ObjectP[Model[Container]] ..}} ..}]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCentrifuge",
			"MixDevices"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "tyler.pabst", "weiran.wang", "axu"}
	}];