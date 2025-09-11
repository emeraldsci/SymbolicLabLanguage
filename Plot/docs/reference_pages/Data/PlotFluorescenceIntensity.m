(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceIntensity*)


DefineUsage[PlotFluorescenceIntensity,
{
	BasicDefinitions -> {
		{
			Definition -> {"PlotFluorescenceIntensity[fluorescenceData]", "plot"},
			Description -> "provides a graphical plot of the provided fluorescence intensities from the given data objects either in the form of a histogram or a box and whisker plot.",
			Inputs :> {
				{
					InputName -> "fluorescenceData",
					Description -> "Fluorescence intensity data you wish to plot.",
					Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Data, FluorescenceIntensity]]]]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "A graphical representation of the distribution(s) of intensities provided.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition -> {"PlotFluorescenceIntensity[protocol]", "plot"},
			Description -> "creates a 'plot' of fluorescence intensities in the data objects found in the Data field of 'protocol'.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocol object containing fluorescence intensity data objects.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, FluorescenceIntensity]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "The figure generated from data found in the fluorescence intensity protocol.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition -> {"PlotFluorescenceIntensity[intensities]", "plot"},
			Description -> "provides a graphical plot of the provided fluorescence intensities either in the form of a histogram or a box and whisker plot.",
			Inputs :> {
				{
					InputName -> "intensities",
					Description -> "Fluorescence intensity data you wish to plot.",
					Widget -> Alternatives[
						Adder[Widget[Type -> Quantity, Pattern :> GreaterP[0RFU], Units->RFU]],
						Adder[Widget[Type-> Number, Pattern:>GreaterP[0] ]]
						]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "A graphical representation of the distribution(s) of intensities provided.",
					Pattern :> ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotChromatography",
		"PlotNMR"
	},
	Author -> {"hayley", "mohamad.zandian"},
	Preview->True
}];