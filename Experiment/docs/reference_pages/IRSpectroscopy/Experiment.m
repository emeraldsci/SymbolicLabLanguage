(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentIRSpectroscopy*)

DefineUsage[ExperimentIRSpectroscopy,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIRSpectroscopy[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' to measure Infrared (IR) absorbance of the provided sample or container 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or container objects to be measured. Container objects must house samples, which are then measured separate from the container.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
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
						Description -> "The protocol object generated to measure the IR spectra of the input objects.",
						Pattern :> ObjectP[Object[Protocol, IRSpectroscopy]]
					}
				}
			}
		},
		MoreInformation -> {
			"Currently, all measurements occur via an Attenuated total reflectance (ATR) sample module. Samples are placed  on the ATR surface, through which IR absorbance is measured. For dry samples, a pressure applicator can be used to press the sample flush to the ATR surface."
		},
		SeeAlso -> {
			"ValidExperimentIRSpectroscopyQ",
			"ExperimentIRSpectroscopyOptions",
			"AnalyzePeaks",
			"PlotIRSpectroscopy",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentFluorescenceSpectroscopy"
		},
		Author -> {"malav.desai", "andrey.shur", "josh.kenchel"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentIRSpectroscopyOptions*)

DefineUsage[ExperimentIRSpectroscopyOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIRSpectroscopyOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentIRSpectroscopyOptions when it is called on 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose Infrared absorbance will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
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
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentIRSpectroscopyOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasurepHOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentIRSpectroscopy",
			"ExperimentIRSpectroscopyPreview",
			"ValidExperimentIRSpectroscopyQ"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"malav.desai", "andrey.shur", "josh.kenchel"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentIRSpectroscopyPreview*)

DefineUsage[ExperimentIRSpectroscopyPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentIRSpectroscopyPreview[Samples]", "Preview"},
				Description -> "returns the preview for ExperimentIRSpectroscopy when it is called on 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose Infrared absorbance will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
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
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentIRSpectroscopy. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentIRSpectroscopy",
			"ExperimentIRSpectroscopyOptions",
			"ValidExperimentIRSpectroscopyQ"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"malav.desai", "andrey.shur", "josh.kenchel"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentIRSpectroscopyQ*)

DefineUsage[ValidExperimentIRSpectroscopyQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentIRSpectroscopyQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentIRSpectroscopy.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose infrared absorbance will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
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
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentIRSpectroscopy call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentIRSpectroscopy",
			"ExperimentIRSpectroscopyOptions",
			"ExperimentIRSpectroscopyPreview"

		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"malav.desai", "andrey.shur", "josh.kenchel"}
	}
];