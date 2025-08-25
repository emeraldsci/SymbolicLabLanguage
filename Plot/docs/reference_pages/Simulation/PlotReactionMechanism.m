(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotReactionMechanism*)


DefineUsage[PlotReactionMechanism,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotReactionMechanism[network]", "plot"},
				Description->"converts a reaction 'network' into a 'plot' displaying all reactions and rates.",
				Inputs:>{
					{
						InputName->"network",
						Description->"A reaction mechanism to be visualized with a graph.",
						Widget->Alternatives[
							"Reaction Mechanism"->Widget[Type->Expression,Pattern:>ReactionMechanismP,Size->Paragraph],
							"Model Object"->Widget[Type->Object,Pattern:>ObjectP[{Model[ReactionMechanism]}],ObjectTypes->{Model[ReactionMechanism]}],
							"Simulation Object"->Widget[Type->Object,Pattern:>ObjectP[{Object[Simulation,ReactionMechanism]}]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"Rendition of the reaction network you input.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation->{
			"Second-order reactions are represented by black circles that multiple things go into and out of.",
			"Rate constants are included as tooltips on edges.",
			"If there are an unreasonably large number of reactions, PlotReactionMechanism will not render each Structure; instead it will draw a gray circle with the Structure as a tooltip"
		},
		SeeAlso -> {
			"ToReactionMechanism",
			"ReactionMechanismQ",
			"PlotTranscript",
			"PlotObject"
		},
		Author -> {"dirk.schild", "amir.saadat", "brad", "alice", "qian", "thomas"},
		Preview->True
	}
];