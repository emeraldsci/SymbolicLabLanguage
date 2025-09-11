(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTADM*)


DefineUsage[PlotTADM,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotTADM[protocol]", "plot"},
				Description -> "generates a graphical plot of the pressure trace inside the robotic pipette tip during the transfers performed in the 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "Protocol object you wish to plot.",
						Widget -> Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Protocol, SampleManipulation], Object[Protocol, RoboticSamplePreparation]}]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the pressure trace in protocol.",
						Pattern :> Alternatives[_Graphics, _TabView]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRoboticSamplePreparation",
			"ExperimentTransfer"
		},
		Author -> {"malav.desai", "alou", "robert"}
	}
];