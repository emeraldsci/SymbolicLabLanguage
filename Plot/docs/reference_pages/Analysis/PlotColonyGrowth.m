(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotColonyGrowth*)

DefineUsage[PlotColonyGrowth,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotColonyGrowth[ColonyGrowthAnalysis]", "plot"},
				Description -> "generates a graphical representation of the number and morphology changes of colonies from 'ColonyGrowthAnalysis'.",
				Inputs :> {
					{
						InputName -> "ColonyGrowthAnalysis",
						Description -> "One Object[Analysis,ColonyGrowth] object.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Analysis, ColonyGrowth]],
							ObjectTypes -> {Object[Analysis, ColonyGrowth]}
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of 'ColonyGrowthAnalysis'.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotColonies",
			"PlotCellCount",
			"PlotCellCountSummary",
			"PlotImage",
			"AnalyzeColonyGrowthPreview"
		},
		Author -> {"lige.tonggu", "harrison.gronlund"},
		Preview -> True
	}
];