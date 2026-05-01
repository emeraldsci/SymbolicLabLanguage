(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVibration*)


DefineUsage[PlotVibration,
	{
		BasicDefinitions -> {
		{
			Definition-> {"PlotVibration[vibrationCheckData]", "plot"},
			Description->"provides a graphical plot of the provided vibration data's distributions.",
			Inputs :> {
				{
					InputName -> "vibrationCheckData",
					Description -> "The vibration data objects containing the readings you wish to plot.",
					Widget -> Adder[Widget[Type->Object, Pattern:>ObjectP[Object[Data,Vibration]]]]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "A graphical representation of the distribution(s) of vibrations provided.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition-> {"PlotVibration[readings]", "plot"},
			Description->"provides a graphical plot of the provided vibration data's distributions.",
			Inputs :> {
				{
					InputName -> "readings",
					Description -> "Vibration readings you wish to plot.",
					Widget -> Alternatives[
						Adder[Widget[Type -> Number, Pattern :> GreaterEqualP[0]]],
						Adder[
							Widget[
								Type -> Quantity,
								Pattern :> Alternatives[GreaterEqualP[0 Meter/Second],GreaterEqualP[0 Meter/Second^2]],
								Units->Alternatives[{1,{Meter/Second, {Meter/Second,Millimeter/Second, Centimeter/Second}}}, {1,{Meter/Second^2, {Meter/Second^2,Millimeter/Second^2, Centimeter/Second^2}}}]
							]
						]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "A graphical representation of the distribution(s) of vibrations provided.",
					Pattern :> ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
    	"PlotObject"
    },
	Author -> {"urvee.chitrao"},
	Preview->True
}];