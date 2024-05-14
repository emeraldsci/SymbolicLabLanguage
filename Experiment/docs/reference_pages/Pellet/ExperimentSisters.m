(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ValidExperimentPelletQ*)


DefineUsage[ValidExperimentPelletQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentPelletQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentPellet call to concentrate the denser, insoluble contents of a solution to the bottom of a given container and to optionally aspirate the supernatant.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be spun via centrifugation in the attempt to form a pellet.",
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
										"A1 to H12" -> Widget[
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
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentPellet call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentPellet proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentPellet",
			"ExperimentPelletOptions",
			"ExperimentPelletPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
	}
];


(* ::Subsection:: *)
(*ExperimentPelletOptions*)


DefineUsage[ExperimentPelletOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPelletOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for a protocol to concentrate the denser, insoluble contents of a solution to the bottom of a given container and to optionally aspirate the supernatant.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be spun via centrifugation in the attempt to form a pellet.",
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
										"A1 to H12" -> Widget[
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
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentPelletOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentPellet."
		},
		SeeAlso -> {
			"ExperimentPellet",
			"ValidExperimentPelletQ",
			"ExperimentPelletPreview"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
	}
];

(* ::Subsection:: *)
(*ExperimentPelletPreview*)


DefineUsage[ExperimentPelletPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPelletPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for a protocol to concentrate the denser, insoluble contents of a solution to the bottom of a given container and to optionally aspirate the supernatant.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be spun via centrifugation in the attempt to form a pellet.",
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
										"A1 to H12" -> Widget[
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
							],
							Expandable -> False,
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided Pelleting experiment. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentPellet",
			"ValidExperimentPelletQ",
			"ExperimentPelletOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
	}
];