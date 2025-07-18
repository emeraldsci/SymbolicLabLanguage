(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentPowderXRD*)


DefineUsage[ExperimentPowderXRD,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPowderXRD[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring the X-ray diffraction of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The powder samples to be diffracted with X-rays.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								(* TODO Does this function work with "Container with Well Position"? *)
								"Model Sample" -> Widget[
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
						OutputName -> "Protocol",
						Description -> "A protocol object for measuring X-ray diffraction of powder samples.",
						Pattern :> ObjectP[Object[Protocol, PowderXRD]]
					}
				}
			}
		},
		MoreInformation -> {
			"All slurry samples will be measured into Model[Container, Plate, \"id:pZx9jo8x59oP\"], which are X-ray transparent cyclic olefin copolymer plates.",
			"All solid samples will be measured into Model[Container, Plate, \"id:AEqRl9xjk896\"], with capillary-shaped wells backed with a low-scattering biaxially-oriented polyethylene terephthalate film and sealed with a low-scattering polyimide tape.",
			"Omega and detector angles refer to the rotational angle of the sample and detector, respectively, in relation to the X-ray source, where 0 degrees indicates a plate or detector perpendicular to the X-ray source."
		},
		SeeAlso -> {
			"ValidExperimentPowderXRDQ",
			"ExperimentPowderXRDOptions",
			"ExperimentPowderXRDPreview",
			"PlotPowderXRD"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "adam.abushaer"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentPowderXRDQ*)


DefineUsage[ValidExperimentPowderXRDQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentPowderXRDQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentPowderXRD call for measuring the X-ray diffraction of all 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The powder samples to be diffracted with X-rays.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								(* TODO Does this function work with "Container with Well Position"? *)
								"Model Sample" -> Widget[
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
						Description -> "A True/False value indicating the validity of the provided ExperimentPowderXRD call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentPowderXRD proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentPowderXRD",
			"ExperimentPowderXRDOptions",
			"ExperimentPowderXRDPreview",
			"PlotPowderXRD"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "adam.abushaer"}
	}
];


(* ::Subsection:: *)
(*ExperimentPowderXRDOptions*)


DefineUsage[ExperimentPowderXRDOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPowderXRDOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for measuring the X-ray diffraction of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The powder samples to be diffracted with X-rays.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								(* TODO Does this function work with "Container with Well Position"? *)
								"Model Sample" -> Widget[
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
						Description -> "Resolved options when ExperimentPowderXRDOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentPowderXRD."
		},
		SeeAlso -> {
			"ExperimentPowderXRD",
			"ValidExperimentPowderXRDQ",
			"ExperimentPowderXRDPreview",
			"PlotPowderXRD"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "adam.abushaer"}
	}
];

(* ::Subsection:: *)
(*ExperimentPowderXRDPreview*)


DefineUsage[ExperimentPowderXRDPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPowderXRDPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the X-ray diffraction of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The powder samples to be diffracted with X-rays.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								(* TODO Does this function work with "Container with Well Position"? *)
								"Model Sample" -> Widget[
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
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided PowderXRD experiment. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentPowderXRD",
			"ValidExperimentPowderXRDQ",
			"ExperimentPowderXRDOptions",
			"PlotPowderXRD"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "adam.abushaer"}
	}
];