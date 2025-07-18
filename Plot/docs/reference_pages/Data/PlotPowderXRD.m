(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPowderXRD*)

DefineUsage[PlotPowderXRD,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotPowderXRD[powderXRDData]", "plot"},
				Description -> "returns a 'plot' of intensity vs 2\[Theta] from a supplied 'powderXRDData' object.",
				Inputs :> {
					{
						InputName -> "powderXRDData",
						Description -> "Powder X-ray diffraction data you wish to plot.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, XRayDiffraction]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data, XRayDiffraction]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The plot of the X-ray diffraction intensity as a function of 2\[Theta].",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotPowderXRD[protocol]", "plot"},
				Description -> "creates a 'plot' of intensity vs 2\[Theta] from data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing powder XRD data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, PowderXRD]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the powder XRD protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotPowderXRD[rawDiffractionData]", "plot"},
				Description -> "returns a plot of intensity vs 2\[Theta] from a supplied 'rawDiffractionData' value.",
				Inputs :> {
					{
						InputName -> "rawDiffractionData",
						Description -> "Raw powder X-ray diffraction data you wish to plot.",
						Widget -> Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The plot of the X-ray diffraction intensity as a function of 2\[Theta].",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPowderXRD",
			"EmeraldListLinePlot"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven"},
		Preview -> True
	}
];