(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentGasChromatography*)


DefineUsage[ExperimentGasChromatography,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGasChromatography[Samples]","Protocol"},
		Description -> "generates a 'Protocol' to analyze 'Samples' using gas chromatography (GC).",
		Inputs:>{
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "Sample objects to be analyzed using gas chromatography.",
					Expandable -> False,
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
		Outputs:>{
			{
				OutputName -> "Protocol",
				Description -> "A protocol object that can be used to obtain the gas chromatograms corresponding to the input samples.",
				Pattern :> ObjectP[Object[Protocol, GasChromatography]]
			}
		}
	}},
	MoreInformation -> {
		"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
		"Compatible containers for protocols using Model[Instrument, GasChromatograph, \"Agilent 8890 Gas Chromatograph\"] must have either a CEVial or HeadspaceVial footprint, and be 9/425 or 18/425 threaded, respectively."
	},
	SeeAlso -> {
		"ValidExperimentGasChromatography",
		"ExperimentGasChromatographyOptions",
		"ExperimentGCMS",
		"AnalyzePeaks",
		"PlotChromatography",
		"ExperimentMassSpectrometry"
	},
	Tutorials -> {
		"Sample Preparation"
	},
	Author -> {"andrey.shur", "lei.tian", "jihan.kim", "james.kammert"}
}];
(* ::Subsubsection::Closed:: *)
(*ExperimentGCMS*)


DefineUsage[ExperimentGCMS,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGCMS[Samples]","Protocol"},
		Description -> "generates a 'Protocol' to analyze 'Samples' using gas chromatography with mass spectrometry (GC/MS).",
		Inputs:>{
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "Sample objects to be analyzed using gas chromatography with mass spectrometry.",
					Expandable -> False,
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
		Outputs:>{
			{
				OutputName -> "Protocol",
				Description -> "A protocol object that can be used to obtain the gas chromatograms corresponding to the input samples.",
				Pattern :> ObjectP[Object[Protocol, GasChromatography]]
			}
		}
	}},
	MoreInformation -> {
		"ExperimentGCMS takes the same options as ExperimentGasChromatography, but the only available detector is MassSpectrometer.",
		"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
		"Compatible containers for protocols using Model[Instrument, GasChromatograph, \"Agilent 8890 Gas Chromatograph\"] must have either a CEVial or HeadspaceVial footprint, and be 9/425 or 18/425 threaded, respectively."
	},
	SeeAlso -> {
		"ValidExperimentGCMS",
		"ExperimentGCMSOptions",
		"ExperimentGasChromatography",
		"AnalyzePeaks",
		"PlotChromatography",
		"ExperimentMassSpectrometry"
	},
	Tutorials -> {
		"Sample Preparation"
	},
	Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "james.kammert"}
}];

(* sister functions *)

(* ::Subsubsection::Closed:: *)
(*ExperimentGasChromatographyPreview*)

DefineUsage[ExperimentGasChromatographyPreview,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGasChromatographyPreview[Samples]","Preview"},
		Description -> "returns the graphical preview for ExperimentGasChromatography when it is called on 'Samples'.  This output is always Null.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Sample",
					Description-> "The objects to be separated via gas chromatography.",
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
				Description -> "Graphical preview representing the output of ExperimentGasChromatography.  This value is always Null.",
				Pattern :> Null
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"andrey.shur", "lei.tian", "jihan.kim", "james.kammert"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentGasChromatographyOptions*)

DefineUsage[ExperimentGasChromatographyOptions,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGasChromatographyOptions[Samples]","ResolvedOptions"},
		Description -> "returns the resolved options for ExperimentGasChromatography when it is called on 'Samples'.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "The objects to be separated via gas chromatography.",
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
				Description -> "Resolved options when ExperimentGasChromatography is called on the input samples.",
				Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"andrey.shur", "lei.tian", "jihan.kim", "james.kammert"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentGasChromatographyQ*)

DefineUsage[ValidExperimentGasChromatographyQ,{
	BasicDefinitions -> {{
		Definition -> {"ValidExperimentGasChromatographyQ[Samples]","Booleans"},
		Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentGasChromatography.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "The objects to be separated via gas chromatography.",
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
				Description -> "Whether or not the ExperimentGasChromatography call is valid.  Return value can be changed via the OutputFormat option.",
				Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"andrey.shur", "lei.tian", "jihan.kim", "james.kammert"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentGCMSPreview*)

DefineUsage[ExperimentGCMSPreview,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGCMSPreview[Samples]","Preview"},
		Description -> "returns the graphical preview for ExperimentGCMS when it is called on 'Samples'.  This output is always Null.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "The objects to be separated via gas chromatography and analyzed using mass spectrometry.",
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
				Description -> "Graphical preview representing the output of ExperimentGCMS.  This value is always Null.",
				Pattern :> Null
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "james.kammert"}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentGCMSOptions*)

DefineUsage[ExperimentGCMSOptions,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentGCMSOptions[Samples]","ResolvedOptions"},
		Description -> "returns the resolved options for ExperimentGCMS when it is called on 'Samples'.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "The objects to be separated via gas chromatography and analyzed using mass spectrometry.",
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
				Description -> "Resolved options when ExperimentGCMS is called on the input samples.",
				Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "james.kammert"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentGCMSQ*)

DefineUsage[ValidExperimentGCMSQ,{
	BasicDefinitions -> {{
		Definition -> {"ValidExperimentGCMSQ[Samples]","Booleans"},
		Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentGCMS.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description-> "The objects to be separated via gas chromatography and analyzed using mass spectrometry.",
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
				Description -> "Whether or not the ExperimentGCMS call is valid.  Return value can be changed via the OutputFormat option.",
				Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
			}
		}
	}},
	MoreInformation -> {
		""
	},
	SeeAlso -> {
		"ExperimentSampleManipulation",
		"ExperimentMassSpectrometry"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"lei.tian", "andrey.shur", "nont.kosaisawe", "james.kammert"}
}];