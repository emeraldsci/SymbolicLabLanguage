(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeColonyGrowth*)


(* Updated definition to Command Center *)
DefineUsageWithCompanions[AnalyzeColonyGrowth,
	{
		BasicDefinitions -> {
			(* definition 1: Basic definition, a list of input colony analysis objects *)
			{
				Definition -> {"AnalyzeColonyGrowth[ColoniesAnalysis]", "ColoniesGrowthAnalysis"},
				Description -> "filters the colonies of a single plate in 'ColoniesAnalysis' based on morphology properties (diameter, separation, regularity and circularity), and then tracks the number and morphology changes of colonies. The colony growth analysis may be used to determine the termination of incubation for solid media samples.",
				Inputs :> {
					{
						InputName -> "ColoniesAnalysis",
						Description -> "ColoniesAnalysis data objects that contain colony locations and colony properties.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Analysis, Colonies]}]
							],
							Adder[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Analysis, Colonies]}]
								]
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "ColoniesGrowthAnalysis",
						Description -> "Analysis object with the count and properties of all colonies over time, including the location, boundary, fluorescence, absorbance, diameter, regularity, circularity, and isolation.",
						Pattern :> ListableP[ObjectP[Object[Analysis, ColonyGrowth]]]
					}
				}
			},
			(* definition 2: Basic definition, a list of appearance data object *)
			{
				Definition -> {"AnalyzeColonyGrowth[AppearanceColoniesImages]", "Object"},
				Description -> "examines 'AppearanceColoniesImages' of a single plate to tracks the number and morphology properties (diameter, separation, regularity and circularity). If no colonies analysis is found, AnalyzeColonies are run automatically.",
				Inputs :> {
					{
						InputName -> "AppearanceColoniesImages",
						Description -> "A list of appearance data objects to be analyzed.",
						Widget -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Data, Appearance, Colonies]]
							],
							Adder[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[Object[Data, Appearance, Colonies]]
								]
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "ColoniesGrowthAnalysis",
						Description -> "Analysis object with the count and properties of all colonies over time, including the location, boundary, fluorescence, absorbance, diameter, regularity, circularity, and isolation.",
						Pattern :> ListableP[ObjectP[Object[Analysis, ColonyGrowth]]]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotColonies",
			"AnalyzeColonies",
			"ExperimentPickColonies",
			"ExperimentQuantifyColonies"
		},
		Author -> {
			"lige.tonggu",
			"harrison.gronlund"
		},
		MoreInformation -> {},
		Preview -> True
	}
];