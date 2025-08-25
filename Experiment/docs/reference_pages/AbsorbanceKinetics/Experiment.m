

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceKinetics*)

DefineUsage[ExperimentAbsorbanceKinetics,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAbsorbanceKinetics[Samples]","Protocol"},
				Description->"generates a 'Protocol' for measuring absorbance of the provided 'Samples' over a period of time.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure absorbance.",
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
								},
								"Model Sample"->Widget[
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
						Description->"The protocol generated to measure absorbance of the provided input.",
						Pattern:>ObjectP[Object[Protocol,AbsorbanceKinetics]]
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"ValidExperimentAbsorbanceKineticsQ",
			"ExperimentAbsorbanceKineticsOptions",
			"SimulateKinetics",
			"PlotAbsorbanceKinetics",
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentFluorescenceKinetics",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentUVMelting"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceKineticsOptions*)


DefineUsage[ExperimentAbsorbanceKineticsOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAbsorbanceKineticsOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentAbsorbanceKinetics when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure absorbance.",
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
								},
								"Model Sample"->Widget[
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
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentAbsorbanceKinetics is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAbsorbanceKinetics",
			"ExperimentAbsorbanceKineticsPreview",
			"ValidExperimentAbsorbanceKineticsQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceKineticsPreview*)


DefineUsage[ExperimentAbsorbanceKineticsPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAbsorbanceKineticsPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentAbsorbanceKinetics when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure absorbance.",
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
								},
								"Model Sample"->Widget[
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
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentAbsorbanceKinetics.  Currently this value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAbsorbanceKinetics",
			"ExperimentAbsorbanceKineticsOptions",
			"ValidExperimentAbsorbanceKineticsQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentAbsorbanceKineticsQ*)


DefineUsage[ValidExperimentAbsorbanceKineticsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentAbsorbanceKineticsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentAbsorbanceKinetics.",
				Inputs :> {
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure absorbance.",
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
								},
								"Model Sample"->Widget[
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
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentAbsorbanceKinetics call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceKinetics",
			"ExperimentAbsorbanceKineticsPreview",
			"ExperimentAbsorbanceKineticsOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven"}
	}
];

