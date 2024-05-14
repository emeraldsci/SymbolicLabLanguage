(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotqPCR*)


DefineUsage[PlotqPCR,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotqPCR[qPCRData]", "fig"},
				Description -> "plots the normalized and baseline-subtracted amplification curves from 'qPCRData'.",
				Inputs :> {
					{
						InputName -> "qPCRData",
						Description -> "The quantitative polymerase chain reaction (qPCR) data objects.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Data, qPCR]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "fig",
						Description -> "The quantitative polymerase chain reaction (qPCR) plot.",
						Pattern -> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotqPCR[meltingPointAnalysis]", "fig"},
				Description -> "plots the negative derivative of the melting curve data 'meltingPointAnalysis'.",
				Inputs :> {
					{
						InputName -> "meltingPointAnalysis",
						Description -> "The analysis of the melting curve of an Object[Data, qPCR].",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Analysis, MeltingPoint]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "fig",
						Description -> "The negative derivative of the melting curve in an Object[Data, qPCR].",
						Pattern -> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotqPCR[AmplificationCurveData]", "fig"},
				Description -> "plots raw 'AmplificationCurveData'.",
				Inputs :> {
					{
						InputName -> "AmplificationCurveData",
						Description -> "The raw data points.",
						Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP, Size -> Paragraph, PatternTooltip -> "Input must match CoordinatesP."]
					}
				},
				Outputs :> {
					{
						OutputName -> "fig",
						Description -> "The quantitative polymerase chain reaction (qPCR) plot.",
						Pattern -> ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"For each input quantitative polymerase chain reaction (qPCR) data object, if there are linked analysis objects, the quantification cycle/copy number information from the most recent analysis for each applicable wavelength pair is displayed as a tooltip."
		},
		SeeAlso -> {
			"PlotQuantificationCycle",
			"PlotCopyNumber"
		},
		Author -> {"andrey.shur", "robert", "weiran.wang", "eqian"},
		Preview -> True
	}
];