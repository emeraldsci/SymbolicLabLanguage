(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVolume*)


DefineUsage[PlotVolume,
	{
		BasicDefinitions -> {
		{
			Definition-> {"PlotVolume[volumeCheckData]", "plot"},
			Description->"provides a graphical plot the provided Volume data's distributions either in the form of a histogram or a box and wisker plot.",
			Inputs :> {
				{
					InputName -> "volumeCheckData",
					Description -> "The Volume data objects containing the readings you wish to plot.",
					Widget -> Adder[Widget[Type->Object, Pattern:>ObjectP[Object[Data,Volume]]]]
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
			Definition-> {"PlotVolume[readings]", "plot"},
			Description->"provides a graphical plot the provided Volume data's distributions either in the form of a histogram or a box and wisker plot.",
			Inputs :> {
				{
					InputName -> "readings",
					Description -> "Volume readings you wish to plot.",
					Widget -> Alternatives[
						Adder[Widget[Type -> Number, Pattern :> GreaterEqualP[0]]],
						Adder[
							Widget[
								Type -> Quantity,
								Pattern :> Alternatives[GreaterEqualP[0 Milliliter],GreaterEqualP[0 Millimeter]],
								Units->Alternatives[{1,{Milliliter, {Microliter, Milliliter, Liter}}}, {1,{Millimeter, {Micrometer, Millimeter, Meter}}}]
							]
						]
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
	Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "fan.wu", "brad"},
	Preview->True
}];