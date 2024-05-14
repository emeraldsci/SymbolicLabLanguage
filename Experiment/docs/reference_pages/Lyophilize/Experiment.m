(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentLyophilize*)


DefineUsage[ExperimentLyophilize,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentLyophilize[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for freeze drying the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be freeze-dried.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes -> {Object[Sample],Object[Container]}
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
						OutputName -> "Protocol",
						Description -> "A protocol object for freeze-drying samples.",
						Pattern :> ObjectP[Object[Protocol, Lyophilize]]
					}
				}
			}
		},
		MoreInformation -> {
			"The primary method of drying is the controlled sublimation of solvent. This is enacted by freezing the samples, decreasing the pressure in the chamber, and then slowly increasing temperature to accelerate the rate of sublimation.",
			"Current container types supported are SBS format plates, 50mL tubes, scintillation vials, and 2mL tubes."
		},
		SeeAlso -> {
			"ExperimentEvaporate",
			"ExperimentLyophilizeOptions",
			"ValidExperimentLyophilizeQ",
			"ExperimentLyophilizePreview",
			"ExperimentHPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {
			"clayton.schwarz",
			"axu",
			"wyatt"
		}
	}
];


(* ::Subsection:: *)
(*ValidExperimentLyophilizeQ*)


DefineUsage[ValidExperimentLyophilizeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentLyophilizeQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentLyophilize call for freeze drying the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be freeze-dried.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes -> {Object[Sample],Object[Container]}
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
						Description -> "A True/False value indicating the validity of the provided ExperimentLyophilize call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentLyophilize proper, will return a valid experiment.",
			"The primary method of drying is the controlled sublimation of solvent. This is enacted by freezing the samples, decreasing the pressure in the chamber, and then slowly increasing temperature to accelerate the rate of sublimation."
		},
		SeeAlso -> {
			"ExperimentLyophilize",
			"ExperimentLyophilizePreview",
			"ExperimentLyophilizeOptions",
			"ExperimentEvaporate"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"axu", "ryan.bisbey"}
	}
];


(* ::Subsection:: *)
(*ExperimentLyophilizeOptions*)


DefineUsage[ExperimentLyophilizeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentLyophilizeOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for freeze-drying the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be freeze-dried.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes -> {Object[Sample],Object[Container]}
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
						Description -> "Resolved options when ExperimentLyophilizeOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentLyophilize.",
			"The primary method of drying is the controlled sublimation of solvent. This is enacted by freezing the samples, decreasing the pressure in the chamber, and then slowly increasing temperature to accelerate the rate of sublimation."
		},
		SeeAlso -> {
			"ExperimentLyophilize",
			"ExperimentLyophilizePreview",
			"ValidExperimentLyophilizeQ",
			"ExperimentEvaporate"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"axu", "ryan.bisbey"}
	}
];

(* ::Subsection:: *)
(*ExperimentLyophilizePreview*)


DefineUsage[ExperimentLyophilizePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentLyophilizePreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that will be freeze-dried.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes -> {Object[Sample],Object[Container]}
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
						Description->"A graphical representation of the provided lyophilization experiment.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {
			"The primary method of drying is the controlled sublimation of solvent. This is enacted by freezing the samples, decreasing the pressure in the chamber, and then slowly increasing temperature to accelerate the rate of sublimation."
		},
		SeeAlso -> {
			"ExperimentLyophilize",
			"ExperimentLyophilizeOptions",
			"ValidExperimentLyophilizeQ",
			"ExperimentEvaporate"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"axu", "ryan.bisbey"}
	}
];
