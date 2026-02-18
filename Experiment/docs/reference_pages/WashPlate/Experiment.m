(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentWashPlate*)

DefineUsage[ExperimentWashPlate,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWashPlate[Containers]", "Protocol"},
				Description -> "creates a 'Protocol' object that robotically aspirates from and then dispenses buffer to 'Containers' to wash their liquid contents.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Containers",
							Description -> "The samples or containers that should be washed.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "The protocol object(s) describing how to perform the requested washing.",
						Pattern :> ObjectP[Object[Protocol, RoboticSamplePreparation]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentWashPlateOptions",
			"ValidExperimentWashPlateOptions",
			"ExperimentRoboticSamplePreparation",
			"ExperimentELISA"
		},
		Author -> {"lige.tonggu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentWashPlateQ*)

DefineUsage[ValidExperimentWashPlateQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentWashPlateQ[Containers]", "Boolean"},
				Description -> "checks whether the provided 'Containers' and options are valid for calling ExperimentWashPlate.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Containers",
							Description -> "The samples or containers that should be washed.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "valid",
						Description -> "A boolean indicating if the washing is properly specified and can be performed",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentWashPlateOptions",
			"ExperimentWashPlate",
			"ExperimentRoboticSamplePreparation"
		},
		Author -> {"lige.tonggu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentWashPlateOptions*)
DefineUsage[ExperimentWashPlateOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWashPlateOptions[Containers]", "ResolvedOptions"},
				Description -> "calculates the full set of options which determine how the washing will be performed.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Containers",
							Description -> "The samples or containers that should be washed.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The full set of options which determine how the covering will be performed.",
						Pattern :> {Rule[_Symbol, Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ValidExperimentWashPlateQ",
			"ExperimentWashPlate",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentWashPlatePreview*)

DefineUsage[ExperimentWashPlatePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWashPlatePreview[Containers]", "Preview"},
				Description -> "returns the preview for ExperimentWashPlate when it is called on 'Containers'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Containers",
							Description -> "The samples or containers that should be washed.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentWashPlate.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentWashPlate",
			"ValidExperimentWashPlateQ",
			"ExperimentRoboticSamplePreparation"
		},
		Author -> {"lige.tonggu", "harrison.gronlund", "steven"}
	}
];

