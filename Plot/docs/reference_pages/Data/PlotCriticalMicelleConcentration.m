(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCriticalMicelleConcentration*)

DefineUsage[PlotCriticalMicelleConcentration,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotCriticalMicelleConcentration[criticalMicelleConcentrationAnalysis]", "plot"},
				Description -> "plots the surface tension points in 'criticalMicelleConcentrationAnalysis' with premicellar and postmicellar fits overlayed.",
				Inputs :> {
					{
						InputName -> "criticalMicelleConcentrationAnalysis",
						Description -> "The critical micelle concentration analysis objects.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, CriticalMicelleConcentration]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis, CriticalMicelleConcentration]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The surface tension plot.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeCriticalMicelleConcentration",
			"PlotSurfaceTension"
		},
		Author -> {"eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"},
		Preview->True
	}
];