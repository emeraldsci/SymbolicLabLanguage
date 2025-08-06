(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotState*)


DefineUsage[PlotState,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotState[equilibriumObject]","plot"},
				Description->"constructs a PieChart describing the relative concentrations of each species in 'equilibriumObject'.",
				Inputs:>{
					{
						InputName->"equilibriumObject",
						Description->"An Object[Simulation,Equilibrium] object containing multiple chemical species.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object:"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Simulation,Equilibrium]]],Size->Paragraph],
								"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Equilibrium]],ObjectTypes->{Object[Simulation,Equilibrium]}]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Equilibrium]],ObjectTypes->{Object[Simulation,Equilibrium]}],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Equilibrium]],ObjectTypes->{Object[Simulation,Equilibrium]}]]
							]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A PieChart of the equilibrium distribution of species concentrations.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotState[state]","plot"},
				Description->"constructs a PieChart describing the relative concentrations of each species in 'state'.",
				Inputs:>{
					{
						InputName->"state",
						Description->"A snapshot of species molecular abundances at a single point in time.",
						Widget->Alternatives[
							"Enter state:"->Widget[Type->Expression,Pattern:>ListableP[StateP],Size->Paragraph]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A PieChart of the distribution of concentrations of each species in the state.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},

			{
				Definition->{"PlotState[concentrations,species]","plot"},
				Description->"constructs the PieChart given lists of 'concentrations' and 'species'.",
				Inputs:>{
					{
						InputName->"concentrations",
						Description->"A list of molecular abundances.",
						Widget->Alternatives[
							"Enter each concentration:"->Adder[Widget[Type->Expression,Pattern:>(ConcentrationP|NumericP|AmountP),Size->Word]],
							"Enter a list of concentrations:"->Widget[Type->Expression,Pattern:>{(ConcentrationP|NumericP|AmountP)..},Size->Paragraph]
						]
					},
					{
						InputName->"species",
						Description->"A list of molecular components.",
						Widget->Alternatives[
							"Enter each species:"->Adder[Widget[Type->Expression,Pattern:>ReactionSpeciesP,Size->Word]],
							"Enter a list of species:"->Widget[Type->Expression,Pattern:>{ReactionSpeciesP..},Size->Paragraph]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A PieChart of the distribution of concentrations of each species in the state.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotTrajectory",
			"PlotReactionMechanism",
			"MotifForm"
		},
		Author -> {"dirk.schild", "sebastian.bernasek", "brad"},
		Preview->True
	}
];