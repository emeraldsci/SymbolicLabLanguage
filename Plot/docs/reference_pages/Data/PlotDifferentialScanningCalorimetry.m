(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDifferentialScanningCalorimetry*)

DefineUsage[PlotDifferentialScanningCalorimetry,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotDifferentialScanningCalorimetry[DSCData]", "plot"},
				Description -> "provides a graphical plot the provided 'DSCData' -- differential scanning calorimetry (DSC) spectra.",
				Inputs :> {
					{
						InputName -> "DSCData",
						Description -> "Differential scanning calorimetry data you wish to plot.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, DifferentialScanningCalorimetry]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data, DifferentialScanningCalorimetry]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The plot of the heating and cooling curves obtained from the provided data.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotDifferentialScanningCalorimetry[HeatingData]", "plot"},
				Description -> "provides a graphical plot the provided 'heatingCurves'.",
				Inputs :> {
					{
						InputName -> "HeatingData",
						Description -> "Raw heating or cooling curves to be plotted.",
						Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP, Size -> Paragraph]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The plot of the heating and cooling curves obtained from the provided data.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotChromatography",
			"PlotAbsorbanceSpectroscopy"
		},
		Author -> {"waseem.vali", "ryan.bisbey", "boris.brenerman", "steven"},
		Preview -> True
	}
];