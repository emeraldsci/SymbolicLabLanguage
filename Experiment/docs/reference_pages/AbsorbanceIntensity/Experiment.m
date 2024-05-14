(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
 

(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceIntensity*)

DefineUsage[ExperimentAbsorbanceIntensity,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceIntensity[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring absorbance of the 'Samples' at a specific wavelength.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
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
						Description -> "A protocol object for measuring absorbance of samples at a specific wavelength.",
						Pattern :> ObjectP[Object[Protocol, AbsorbanceIntensity]]
					}
				}
			}
		},
		MoreInformation -> {
			"When using a Lunatic instrument, the most samples that can be run in one protocol (including blanks) is 94.  If you want to run on more than 94 samples, please manually group your samples into multiple protocols."
		},
		SeeAlso -> {
			"ValidExperimentAbsorbanceIntensityQ",
			"ExperimentAbsorbanceIntensityOptions",
			"ExperimentAbsorbanceIntensityPreview",
			"AnalyzeAbsorbanceQuantification",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"dima", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentAbsorbanceIntensityQ*)

DefineUsage[ValidExperimentAbsorbanceIntensityQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentAbsorbanceIntensityQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentAbsorbanceIntensity.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
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
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentAbsorbanceIntensity call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceIntensityOptions",
			"ExperimentAbsorbanceIntensityPreview",
			"AnalyzeAbsorbanceQuantification",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"dima", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceIntensityOptions*)

DefineUsage[ExperimentAbsorbanceIntensityOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceIntensityOptions[Samples]", "Booleans"},
				Description -> "returns the resolved options for ExperimentAbsorbanceIntensity when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
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
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentAbsorbanceIntensity is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceIntensity",
			"ValidExperimentAbsorbanceIntensityQ",
			"ExperimentAbsorbanceIntensityPreview",
			"AnalyzeAbsorbanceQuantification",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"dima", "steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceIntensityPreview*)

DefineUsage[ExperimentAbsorbanceIntensityPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceIntensityPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentAbsorbanceIntensity when it is called on 'Samples'.  This output is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
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
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentAbsorbanceIntensity.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceIntensity",
			"ValidExperimentAbsorbanceIntensityQ",
			"ExperimentAbsorbanceIntensityOptions",
			"AnalyzeAbsorbanceQuantification",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"dima", "steven"}
	}
];
