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
			},
			{
				Definition -> {"PlotCoulterCount[protocol]", "plot"},
				Description -> "displays the ParticleCount vs ParticleSize 'plot' for the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing coulter count data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, CoulterCount]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the coulter count protocol.",
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