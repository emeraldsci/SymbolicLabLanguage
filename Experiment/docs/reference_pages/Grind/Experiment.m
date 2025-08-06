(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentGrind*)

DefineUsage[ExperimentGrind,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrind[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object to break particles of solid input 'Samples' into smaller powder particles through mechanical actions.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are ground into fine powders.",
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
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
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
						Description -> "A protocol object that describes the experiment to grind samples into fine powders.",
						Pattern :> ObjectP[Object[Protocol, Grind]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentGrindOptions",
			"ValidExperimentGrindQ",
			"ExperimentDesiccate",
			"ExperimentMeasureMeltingPoint",
			"ExperimentMix",
			"ExperimentIncubate"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentGrindQ*)


DefineUsage[ValidExperimentGrindQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentGrindQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentGrind call for grinding the input 'Samples' into fine powders.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are ground into fine powders.",
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
						Description -> "A True/False value indicating the validity of the provided ExperimentGrind call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentGrind, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentGrind",
			"ExperimentGrindOptions",
			"ExperimentDesiccate",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];


(* ::Subsection:: *)
(*ExperimentGrindOptions*)


DefineUsage[ExperimentGrindOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrindOptions[Samples]", "ResolvedOptions"},
				Description -> "generates a 'ResolvedOptions' object to grind the input 'Samples' into fine powders using a Grinder.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are ground into fine powders.",
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
						Description -> "Resolved options when ExperimentGrindOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentGrind."
		},
		SeeAlso -> {
			"ExperimentGrind",
			"ValidExperimentGrindQ",
			"ExperimentDesiccate",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];

(* ::Subsection:: *)
(*ExperimentGrindPreview*)


DefineUsage[ExperimentGrindPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentGrindPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for grinding the input 'Samples' into fine powders.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input samples that are ground into fine powders.",
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
						Description -> "A graphical representation of the provided Grind experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentGrind",
			"ExperimentGrindOptions",
			"ValidExperimentGrindQ",
			"ExperimentDesiccate",
			"ExperimentMeasureMeltingPoint"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"mohamad.zandian"}
	}
];

(* ::Subsection:: *)
(*PreferredGrinder*)

DefineUsage[PreferredGrinder,
	{
		BasicDefinitions -> {
			{"PreferredGrinder[volume]", "grinder", "returns the preferred model of ECL 'grinder' which can efficiently grind the specified 'volume' of a sample."},
			{"PreferredGrinder[mass]", "grinder", "returns the preferred model of ECL 'grinder' which can efficiently grind the specified 'mass' of a sample."}
		},
		AdditionalDefinitions -> {},
		MoreInformation -> {},
		Input :> {
			{"volume", GreaterP[0 Milliliter], "The samples' volume to be ground by a preferred grinder."},
			{"mass", GreaterP[0 Gram], "The samples' mass to be ground by a preferred grinder."}
		},
		Output :> {
			{"grinder", Model[Instrument, Grinder], "The grinder model best suited to grind the input volume/mass."}
		},
		SeeAlso -> {
			"ExperimentGrind",
			"PreferredGrindingContainer",
			"ExperimentGrindOptions"
		},
		Author -> {"mohamad.zandian"}
	}
];

(* ::Subsection:: *)
(*PreferredGrindingContainer*)

DefineUsage[PreferredGrindingContainer,
	{
		BasicDefinitions -> {
			{"PreferredGrindingContainer[grinder, amount, bulk density]", "grinding container", "returns the preferred model of ECL 'grinding container' for the selected 'grinder' to efficiently grind the given sample 'amount'. If 'amount' is in mass units, 'bulk density' converts it to volume. 'bulk density' is the mass of a material divided by its total volume, including the space between particles."}
		},
		AdditionalDefinitions -> {},
		MoreInformation -> {},
		Input :> {
			{"grinder", ObjectP[{Model[Instrument, Grinder], Object[Instrument, Grinder]}], "The specified grinder to grind the sample."},
			{"amount", MassP | VolumeP, "The samples' amount (volume or mass) to be ground by the specified grinder."},
			{"bulk density", GreaterP[0 Gram/Milliliter], "The mass of a material divided by its total volume, including the space between particles. If amount is provided in mass units, bulk density converts it to volume."}
		},
		Output :> {
			{"grinding container", Model[Container, GrindingContainer] | Model[Container, Vessel], "The grinding container model best suited to grind the input volume/mass."}
		},
		SeeAlso -> {
			"ExperimentGrind",
			"PreferredGrinder",
			"ExperimentGrindOptions"
		},
		Author -> {"mohamad.zandian"}
	}
];