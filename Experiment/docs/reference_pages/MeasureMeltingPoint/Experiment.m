(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureMeltingPoint*)

DefineUsage[ExperimentMeasureMeltingPoint,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureMeltingPoint[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object to measure the melting points of the input 'Samples' using a melting point apparatus. An increasing temperature gradient is applied to melting point capillary tubes containing a small amount of the input samples. The instrument records videos and transmittance data to detect the transition point at which the solid sample becomes liquid. This experiment can be performed on samples that were previously packed into melting point capillary tubes or fresh samples that need to be packed.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples whose melting temperatures are measured. The input samples can be solid substances, such as powders or substances that can be easily ground into powders, that will be packed into melting point capillary tubes before measuring their melting points or melting point capillary tubes that were previously packed with powders.",
							Widget ->
								Alternatives[
									"Solid Sample"->Widget[
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
									"Model Solid Sample"->Widget[
										Type -> Object,
										Pattern :> ObjectP[Model[Sample]],
										ObjectTypes -> {Model[Sample]}
									],
									"Prepacked melting point capillary tube" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container, Capillary]}],
										ObjectTypes -> {Object[Container,Capillary]}
									]
								],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object that describes the experiment to measure the melting points of the input samples.",
						Pattern :> ObjectP[Object[Protocol, MeasureMeltingPoint]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureMeltingPointOptions",
			"ValidExperimentMeasureMeltingPointQ",
			"ExperimentGrind",
			"ExperimentDesiccate",
			"ExperimentUVMelting",
			"ExperimentDifferentialScanningCalorimetry"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentMeasureMeltingPointQ*)


DefineUsage[ValidExperimentMeasureMeltingPointQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureMeltingPointQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentMeasureMeltingPoint call for measuring the melting points of the input 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples whose melting temperatures should be measured. The input samples can be solid substances that will be packed into melting point capillary tubes before measuring their melting points or melting point capillary tubes that were previously packed by solid substances.",
							Widget ->
									Alternatives[
										"Solid Sample"->Widget[
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
										"Model Solid Sample"->Widget[
											Type -> Object,
											Pattern :> ObjectP[Model[Sample]],
											ObjectTypes -> {Model[Sample]}
										],
										"Prepacked melting point capillary tube" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container, Capillary]}],
											ObjectTypes -> {Object[Container,Capillary]}
											(* ??? PatternTooltip -> "Enumeration must be any well from A1 to H12."*)
										]
									],
							Expandable -> False (*???*)
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentMeasureMeltingPoint call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentMeasureMeltingPoint, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentMeasureMeltingPointOptions",
			"ExperimentMeasureMeltingPoint",
			"ExperimentGrind",
			"ExperimentDesiccate",
			"ExperimentUVMelting",
			"ExperimentDifferentialScanningCalorimetry"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ExperimentMeasureMeltingPointOptions*)


DefineUsage[ExperimentMeasureMeltingPointOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureMeltingPointOptions[Samples]", "ResolvedOptions"},
				Description -> "generates a 'ResolvedOptions' object to measure the melting points of the input 'Samples' using a melting point apparatus.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples whose melting temperatures should be measured. The input samples can be solid substances that will be packed into melting point capillary tubes before measuring their melting points or melting point capillary tubes that were previously packed by solid substances.",
							Widget ->
									Alternatives[
										"Solid Sample"->Widget[
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
										"Model Solid Sample"->Widget[
											Type -> Object,
											Pattern :> ObjectP[Model[Sample]],
											ObjectTypes -> {Model[Sample]}
										],
										"Prepacked melting point capillary tube" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container, Capillary]}],
											ObjectTypes -> {Object[Container,Capillary]}
										]
									],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentMeasureMeltingPointOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentMeasureMeltingPoint."
		},
		SeeAlso -> {
			"ExperimentMeasureMeltingPoint",
			"ValidExperimentMeasureMeltingPointQ",
			"ExperimentGrind",
			"ExperimentDesiccate",
			"ExperimentUVMelting",
			"ExperimentDifferentialScanningCalorimetry"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];

(* ::Subsection:: *)
(*ExperimentMeasureMeltingPointPreview*)


DefineUsage[ExperimentMeasureMeltingPointPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureMeltingPointPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the melting points of the input 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples whose melting temperatures should be measured. The input samples can be solid substances that will be packed into melting point capillary tubes before measuring their melting points or melting point capillary tubes that were previously packed by solid substances.",
							Widget ->
									Alternatives[
										"Solid Sample"->Widget[
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
										"Model Solid Sample"->Widget[
											Type -> Object,
											Pattern :> ObjectP[Model[Sample]],
											ObjectTypes -> {Model[Sample]}
										],
										"Prepacked melting point capillary tube" -> Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Container, Capillary]}],
											ObjectTypes -> {Object[Container,Capillary]}
										]
									],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided MeasureMeltingPoint experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureMeltingPoint",
			"ExperimentMeasureMeltingPointOptions",
			"ValidExperimentMeasureMeltingPointQ",
			"ExperimentGrind",
			"ExperimentDesiccate",
			"ExperimentUVMelting",
			"ExperimentDifferentialScanningCalorimetry"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];