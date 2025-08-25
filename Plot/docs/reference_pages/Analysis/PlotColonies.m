(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotColonies*)

DefineUsage[PlotColonies,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotColonies[ColonyAnalysis]", "plot"},
				Description -> "generates a graphical representation of the selected colony populations from 'ColonyAnalysis'.",
				Inputs :> {
					{
						InputName -> "ColonyAnalysis",
						Description -> "One or more Object[Analysis,Colonies] objects.",
						Widget -> If[TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object:" -> Widget[Type -> Expression, Pattern :> ListableP[ObjectP[Object[Analysis, Colonies], 1]], Size -> Paragraph],
								"Select object:" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, Colonies]], ObjectTypes -> {Object[Analysis, Colonies]}]
							],
							Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, Colonies]], ObjectTypes -> {Object[Analysis, Colonies]}]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of 'ColonyAnalysis'.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotCellCount",
			"PlotColonyGrowth",
			"PlotImage",
			"AnalyzeColoniesPreview"
		},
		Author -> {"lige.tonggu", "harrison.gronlund"},
		Preview -> True
	}
];