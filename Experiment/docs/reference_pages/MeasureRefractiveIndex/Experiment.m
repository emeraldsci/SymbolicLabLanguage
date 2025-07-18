(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureRefractiveIndex*)

DefineUsage[ExperimentMeasureRefractiveIndex,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureRefractiveIndex[Samples]", "protocol"},
				Description -> "generate a 'protocol' object for measuring the refractive index of input 'sampleIn' at defined temperature.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose contents will be measured.",
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "protocol",
						Description -> "The protocol object(s) for measuring the refractive index of input 'Samples'.",
						Pattern :> ListableP[ObjectP[Object[Protocol, MeasureRefractiveIndex]]]
					}
				}
			}
		},
		MoreInformation -> {
			"The minimum 100-microliter of sample is loaded onto the refractometer. The instrument will stabilize temperature of the sample at given temperature. Once the temperature reaches the desired point, the refractometer will measure the refractive index which is calculated from the inverse of Sine of critical angle where the angle of refraction is 90-degree. The refractive index can be used in the quality monitoring of chemicals, beverage and pharmaceuticals."
		},
		SeeAlso -> {
			"ExperimentMeasureDensity",
			"ExperimentMeasureConductivity",
			"ExperimentMeasureSurfaceTension",
			"ExperimentMeasureViscosity",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"axu", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureRefractiveIndexOptions*)


DefineUsage[ExperimentMeasureRefractiveIndexOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureRefractiveIndexOptions[Samples]", "Options"},
				Description -> "returns the automatically calculated options for ExperimentMeasureRefractiveIndex when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose refractive index will be measured.",
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "resolvedOptions",
						Description -> "Automatically calculated options when ExperimentMeasureRefractiveIndex is called on 'Samples'.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the automatically calculated options that would be fed to ExperimentMeasureRefractiveIndex if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureRefractiveIndex",
			"ExperimentMeasureRefractiveIndexPreview",
			"ValidExperimentMeasureRefractiveIndexQ"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"axu", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureRefractiveIndexPreview*)


DefineUsage[ExperimentMeasureRefractiveIndexPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureRefractiveIndexPreview[Samples]", "preview"},
				Description -> "returns the preview for ExperimentMeasureRefractiveIndex when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose refractive index will be measured.",
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureRefractiveIndex.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureRefractiveIndex",
			"ExperimentMeasureRefractiveIndexOptions",
			"ValidExperimentMeasureRefractiveIndexQ"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"axu", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMeasureRefractiveIndexQ*)


DefineUsage[ValidExperimentMeasureRefractiveIndexQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureRefractiveIndexQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentMeasureRefractiveIndex.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples or containers whose refractive index will be measured.",
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
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Indicates if the ExperimentMeasureRefractiveIndex call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureRefractiveIndex",
			"ExperimentMeasureRefractiveIndexPreview",
			"ExperimentMeasureRefractiveIndexOptions"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"axu", "andrey.shur", "lei.tian", "jihan.kim"}
	}
];