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
			},
			{
				Definition -> {"PlotCriticalMicelleConcentration[protocol]", "plot"},
				Description -> "creates a 'plot' of the surface tension data found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing surface tension data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, MeasureSurfaceTension]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the MeasureSurfaceTension protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeCriticalMicelleConcentration",
			"PlotSurfaceTension"
		},
		Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"},
		Preview->True
	}
];