(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCoulterCount*)

DefineUsage[PlotCoulterCount,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotCoulterCount[coulterCountData]", "plot"},
				Description -> "displays the ParticleCount vs ParticleSize 'plot' for the supplied 'coulterCountData'.",
				Inputs :> {
					{
						InputName -> "coulterCountData",
						Description -> "CoulterCount data you wish to plot.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, CoulterCount]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data, CoulterCount]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The ParticleCount vs ParticleSize plot.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCoulterCount"
		},
		Author -> {"lei.tian"},
		Preview -> True
	}
];