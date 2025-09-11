(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDesiccate*)

DefineUsage[ExperimentDesiccate,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDesiccate[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object to dry by removing water from the solid input 'Samples' using a Desiccator. The solid samples are exposed to a chemical desiccant in a bell jar desiccator (at atmospheric pressure or in Vacuum). Desiccant absorbs water molecules from the input samples. Unlike desiccated storage, ExperimentDesiccate leaves the container open to a dedicated bell jar with only the input samples present during the course of the experiment.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are dried in the desiccator via removing their lid and moving them into a bell jar with desiccant and/or vacuum for drying.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container],Model[Sample]}],
								ObjectTypes -> {Object[Sample], Object[Container], Model[Sample]},
								Dereference -> {Object[Container]->Field[Contents[[All,2]]]},
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials"
									}
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
						Description -> "A protocol object that describes the experiment to dry the input samples via a dedicated desiccator with only the input samples present.",
						Pattern :> ObjectP[Object[Protocol, Desiccate]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentDesiccateOptions",
			"ValidExperimentDesiccateQ",
			"ExperimentMeasureMeltingPoint",
			"ExperimentEvaporate",
			"ExperimentLyophilize"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentDesiccateQ*)


DefineUsage[ValidExperimentDesiccateQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentDesiccateQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentDesiccate call for measuring the melting points of the input 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are dried in the desiccator via losing water molecules to desiccant.",
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
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentDesiccate call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentDesiccate, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentDesiccate",
			"ExperimentDesiccateOptions",
			"ExperimentGrind",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ExperimentDesiccateOptions*)


DefineUsage[ExperimentDesiccateOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDesiccateOptions[Samples]", "ResolvedOptions"},
				Description -> "generates a 'ResolvedOptions' object to measure the melting points of the input 'Samples' using a melting point apparatus.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are dried in the desiccator via losing water molecules to desiccant.",
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
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentDesiccateOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentDesiccate."
		},
		SeeAlso -> {
			"ExperimentDesiccate",
			"ValidExperimentDesiccateQ",
			"ExperimentGrind",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];

(* ::Subsection:: *)
(*ExperimentDesiccatePreview*)


DefineUsage[ExperimentDesiccatePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDesiccatePreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for drying the input 'Samples' via a desiccator.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are dried in the desiccator via losing water molecules to desiccant.",
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
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided Desiccate experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentDesiccate",
			"ExperimentDesiccateOptions",
			"ValidExperimentDesiccateQ",
			"ExperimentGrind",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];