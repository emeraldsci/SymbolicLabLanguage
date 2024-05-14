

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentFPLC*)

DefineUsage[ExperimentFPLC,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentFPLC[Samples]","Protocol"},
		Description -> "generates a 'Protocol' to separate 'Samples' via fast protein liquid chromatography.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description -> "The analyte samples which should be injected onto a column and analyzed and/or purified via FPLC.",
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
						"Container with Well Position" -> {
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
					]
				},
				IndexName -> "experiment samples"
			]
		},
		Outputs :> {
			{
				OutputName -> "Protocol",
				Description -> "A protocol object that describes the FPLC experiment to be run.",
				Pattern :> ObjectP[Object[Protocol, FPLC]]
			}
		}
	}},
	MoreInformation -> {
		"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers of Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]."
	},
	SeeAlso -> {
		"ExperimentFPLCOptions",
		"ValidExperimentFPLCQ",
		"AnalyzePeaks",
		"ExperimentHPLC",
		"ExperimentSupercriticalFluidChromatography",
		"ExperimentPAGE",
		"ExperimentWestern"
	},
	Author -> {"ryan.bisbey", "axu", "steven", "wyatt"}
}];


(* ::Subsubsection:: *)
(*ExperimentFPLCOptions*)

DefineUsage[ExperimentFPLCOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentFPLCOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentFPLCOptions when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via FPLC.",
							Widget-> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentFPLCOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentFPLCOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentFPLC",
			"ExperimentFPLCPreview",
			"ValidExperimentFPLCQ",
			"AnalyzePeaks",
			"ExperimentHPLC",
			"ExperimentSupercriticalFluidChromatography",
			"ExperimentPAGE",
			"ExperimentWestern"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "axu", "steven", "wyatt"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentFPLCPreview*)

DefineUsage[ExperimentFPLCPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentFPLCPreview[Objects]","Preview"},
				Description -> "returns the preview for ExperimentFPLC when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description -> "The analyte samples which should be injected onto a column and analyzed and/or purified via FPLC.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentFPLC. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFPLC",
			"ExperimentFPLCOptions",
			"ValidExperimentFPLCQ",
			"AnalyzePeaks",
			"ExperimentHPLC",
			"ExperimentSupercriticalFluidChromatography",
			"ExperimentPAGE",
			"ExperimentWestern"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "axu", "steven", "wyatt"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentFPLCQ*)

DefineUsage[ValidExperimentFPLCQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentFPLCQ[Objects]","Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentFPLC.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The analyte samples which should be injected onto a column and analyzed and/or purified via FPLC.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
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
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentFPLC call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFPLC",
			"ExperimentFPLCOptions",
			"ExperimentFPLCPreview",
			"AnalyzePeaks",
			"ExperimentHPLC",
			"ExperimentSupercriticalFluidChromatography",
			"ExperimentPAGE",
			"ExperimentWestern"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "axu", "steven", "wyatt"}
	}
];