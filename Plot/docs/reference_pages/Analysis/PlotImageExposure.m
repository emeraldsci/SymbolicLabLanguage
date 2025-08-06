(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotImageExposure*)

DefineUsage[PlotImageExposure,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotImageExposure[ExposureAnalysis]", "plot"},
				Description -> "generates a graphical representation of the reference images from 'ExposureAnalysis'.",
				Inputs :> {
					{
						InputName -> "ExposureAnalysis",
						Description -> "One Object[Analysis,ImageExposure] object.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, ImageExposure]]]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of reference from 'ExposureAnalysis' with different exposure times.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotImageExposure[ColoniesAppearanceData]", "plot"},
				Description -> "generates a graphical representation of the images used in ImageExposureAnalyses field from 'ColoniesAppearanceData'.",
				Inputs :> {
					{
						InputName -> "ColoniesAppearanceData",
						Description -> "One Object[Data,Appearance,Colonies] object.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, Appearance, Colonies]]]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of 'ColoniesAppearanceData' with different exposure times.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotMicroscope",
			"PlotImage",
			"AnalyzeImageExposurePreview"
		},
		Author -> {"lige.tonggu", "harrison.gronlund"},
		Preview -> True
	}
];