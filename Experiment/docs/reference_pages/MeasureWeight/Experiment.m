(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureWeight*)


DefineUsage[ExperimentMeasureWeight,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureWeight[Items]","Protocol"},
				Description->"generates a 'Protocol' to weigh the provided sample or container 'Items'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The objects to be weighed.",
							Widget -> Alternatives[
								"Sample, Container, and/or Cover" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Sequence @@ CoverObjectTypes}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the MeasureWeight experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MeasureWeight]]]
					}
				}
			}
		},
		MoreInformation -> {
			"Unless a specific instrument is requested, the protocol will automatically choose the optimal instrument (Balance), based on the size of the container(s) in the input 'Items' and the weight of its contents, if known.",
			"If the protocol is unable to automatically resolve which instrument to use, it will perform a two-step weigh process:\n\t\t\t\n\tIn the first step, the protocol will use a larger macro balance get a first estimate of the weight.\n\t\t\t\n\tBased on this result, the protocol will subsequently choose an optimal balance to weigh the 'Items'.",
			"The user must explicitly specify the Micro-Balance using the option Instrument -> Model[Instrument,Balance,\"id:54n6evKx08XN\"] if so desired.",
			"The user cannot specify a TransferContainer if CalibrateContainer option is set to True."
		},
		SeeAlso -> {
			"ValidExperimentMeasureWeightQ",
			"ExperimentMeasureWeightOptions",
			"ExperimentMeasureCount",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"xu.yi", "mohamad.zandian", "ti.wu", "axu", "waltraud.mair", "srikant", "guillaume"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureWeightOptions*)

 DefineUsage[ExperimentMeasureWeightOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureWeightOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMeasureWeight when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The objects to be weighed.",
							Widget -> Alternatives[
								"Sample, Container, and/or Cover" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Sequence @@ CoverObjectTypes}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureWeight is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasureWeight if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureWeight",
			"ValidExperimentMeasureWeightQ",
			"ExperimentMeasureCount",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"xu.yi", "mohamad.zandian", "ti.wu", "axu", "waltraud.mair"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureWeightPreview*)
 DefineUsage[ExperimentMeasureWeightPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentMeasureWeightPreview[Objects]","Preview"},
				Description -> "returns the preview for ExperimentMeasureWeight when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The objects to be weighed.",
							Widget -> Alternatives[
								"Sample, Container, and/or Cover" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Sequence @@ CoverObjectTypes}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureWeight. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureWeight",
			"ValidExperimentMeasureWeightQ",
			"ExperimentMeasureWeightOptions",
			"ExperimentMeasureCount",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"xu.yi", "mohamad.zandian", "ti.wu", "axu", "waltraud.mair"}
	}
];

 (* ::Subsubsection:: *)
(*ValidExperimentMeasureWeightQ*)

DefineUsage[ValidExperimentMeasureWeightQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentMeasureWeightQ[Objects]","Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentMeasureWeight.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The objects to be weighed.",
							Widget -> Alternatives[
								"Sample, Container, and/or Cover" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container], Sequence @@ CoverObjectTypes}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentMeasureWeight call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureWeight",
			"ExperimentMeasureWeightOptions",
			"ExperimentMeasureCount",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Author -> {"xu.yi", "mohamad.zandian", "ti.wu", "axu", "waltraud.mair"}
	}
];