(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTADM*)


DefineUsage[PlotTADM,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotTADM[unitOperation]", "plot"},
				Description -> "generates a graphical plot of the pressure trace inside the robotic pipette tip during the transfers performed in the 'unitOperation'.",
				Inputs :> {
					{
						InputName -> "unitOperation",
						Description -> "UnitOperation object you wish to plot.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[UnitOperation, Aliquot], Object[UnitOperation, Transfer]}]]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the pressure trace in unitOperation.",
						Pattern :> _Graphics
					}
				}
			},
			{
				Definition -> {"PlotTADM[protocol]", "plot"},
				Description -> "generates a graphical plot of the pressure trace inside the robotic pipette tip during the transfers performed in the 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "Protocol object you wish to plot.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Protocol, SampleManipulation], Object[Protocol, RoboticSamplePreparation]}]]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the pressure trace in protocol.",
						Pattern :> _Graphics
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentTransfer"
		},
		Author -> {"alou", "robert"}
	}
];