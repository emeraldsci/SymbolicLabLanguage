
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Subsubsection::Closed:: *)
(*ExperimentLuminescenceKineticsOptions*)


DefineUsage[ExperimentLuminescenceKineticsOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentLuminescenceKineticsOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentLuminescenceKinetics when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure Luminescence Kinetics.",
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
							]
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentLuminescenceKinetics is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentLuminescenceKinetics",
			"ExperimentLuminescenceKineticsPreview",
			"ValidExperimentLuminescenceKineticsQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentLuminescenceKineticsPreview*)


DefineUsage[ExperimentLuminescenceKineticsPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentLuminescenceKineticsPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentLuminescenceKinetics when it is called on 'Samples'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure Luminescence Kinetics.",
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
							]
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentLuminescenceKinetics.  This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentLuminescenceKinetics",
			"ExperimentLuminescenceKineticsOptions",
			"ValidExperimentLuminescenceKineticsQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentLuminescenceKineticsQ*)


DefineUsage[ValidExperimentLuminescenceKineticsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentLuminescenceKineticsQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentLuminescenceKinetics.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which to measure Luminescence Kinetics.",
							Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Object[Container,Plate]}], ObjectTypes -> {Object[Sample], Object[Container,Plate]}]
						},
						IndexName->"experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentLuminescenceKinetics call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentLuminescenceKinetics",
			"ExperimentLuminescenceKineticsPreview",
			"ExperimentLuminescenceKineticsOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}
];
