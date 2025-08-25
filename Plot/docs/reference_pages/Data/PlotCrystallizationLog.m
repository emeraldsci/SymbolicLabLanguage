(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCrystallizationImagingLog*)

DefineUsage[PlotCrystallizationImagingLog,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotCrystallizationImagingLog[samples]", "plot"},
				Description -> "displays the crystallization images from the CrystallizationImagingLog field of the supplied 'samples' as 'plot'.",
				Inputs :> {
					{
						InputName -> "samples",
						Description -> "Samples with CrystallizationImagingLog to plot.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Sample]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Sample]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A display of crystallization images associated with each entry in CrystallizationImagingLog.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentGrowCrystal"
		},
		Author -> {"lige.tonggu"},
		Preview -> True
	}
];