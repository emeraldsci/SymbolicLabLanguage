(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*SimulateEquilibrium*)

DefineUsageWithCompanions[SimulateEquilibrium,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateEquilibrium[reactionModel, initialCondition]", "simulateEquilibriumObject"},
			Description->"computes the equilibrium of the ReactionMechanism 'reactionModel' starting from initialCondition condition 'initialCondition'.",
			Inputs:> {
				{
					InputName -> "reactionModel",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[{Model[ReactionMechanism], Object[Simulation, ReactionMechanism]}]],
						Widget[Type -> Expression, Pattern :> ObjectP[{Model[ReactionMechanism], Object[Simulation, ReactionMechanism]}] | ListableP[ImplicitReactionP] | ReactionMechanismP | {_?ArrayQ, _?ArrayQ, _?ListQ, _?ListQ} , PatternTooltip -> "A reaction mechanism like ReactionMechanism[Reaction[{\"a\"+\"b\"\[Equilibrium]\"c\",10^5,10^-5}]], or one or a list of implicit reactions like {\"a\"+\"b\"\[Equilibrium]\"c\",10^5,10^-5}..", Size -> Line]
					],
					Expandable -> False,
					Description -> "A ReactionMechanism or a list of reactions, where each reaction is a rule with a forward rate, or an equilibrium with forward and backward rates."
				},
				{
					InputName -> "initialCondition",
					Widget -> Alternatives[
						Adder[{
							"Species" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word],
							"Concentration" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Picomolar], Units -> Picomolar | Nanomolar | Micromolar | Millimolar | Molar]
						}, Orientation -> Vertical],
						Widget[Type -> Expression, Pattern :> StateP | ListableP[InitialConditionP, 2], PatternTooltip -> "A state like State[{Structure[...],concentration}..]}] or one or a list of initial conditions like {\"a\"->4 Micromolar,\"b\"->3 Micromolar}.", Size -> Line],
						Adder[
							Widget[Type -> Number, Pattern :> GreaterEqualP[0], PatternTooltip -> "Concentration in Molar for each species in order like 4 10^-6"]
						]
					],
					Expandable -> False,
					Description -> "Initial state of the system. All species in 'reactionModel' not specified in 'initialCondition' will be defaulted to 0."
				}
			},
			Outputs :> {
				{
					OutputName -> "simulateEquilibriumObject",
					Pattern :> Packet | ObjectP[Object[Simulation, Equilibrium]],
					Description -> "Equilibrium simulation object or packet."
				}
			}
		},
		{
			Definition->{"SimulateEquilibrium[structures, initialCondition]", "simulateEquilibriumObject"},
			Description->"constructs a ReactionMechanism from 'structures' under two-state assumption then calculate equilibrium state.",
			Inputs:> {
				{
					InputName -> "structures",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[{Object[Simulation, Folding]}]],
						Widget[Type -> Expression, Pattern :> ObjectP[{Object[Simulation, Folding]}] | ListableP[StructureP], PatternTooltip -> "One or a list of structures like TODO ????", Size -> Line]
					],
					Expandable -> False,
					Description -> "List of structures folded from the same sequence or results from SimulateFolding."
				},
				{
					InputName -> "initialCondition",
					Widget -> Alternatives[
						Adder[{
							"Species" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word],
							"Concentration" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Picomolar], Units -> Picomolar | Nanomolar | Micromolar | Millimolar | Molar]
						}, Orientation -> Vertical],
						Widget[Type -> Expression, Pattern :> StateP | ListableP[InitialConditionP, 2], PatternTooltip -> "A state like State[{Structure[...],concentration}..]}] or one or a list of initial conditions like {\"a\"->4 Micromolar,\"b\"->3 Micromolar}.", Size -> Line],
						Adder[
							Widget[Type -> Number, Pattern :> GreaterEqualP[0], PatternTooltip -> "Concentration in Molar for each species in order like 4 10^-6"]
						]
					],
					Expandable -> False,
					Description -> "Initial state of the system. All species in 'reactionModel' not specified in 'initialCondition' will be defaulted to 0."
				}
			},
			Outputs :> {
				{
					OutputName -> "simulateEquilibriumObject",
					Pattern :> Packet | ObjectP[Object[Simulation, Equilibrium]],
					Description -> "Equilibrium simulation object or packet."
				}
			}
		}
	},
	MoreInformation -> {
		"Given a set of reactions and their associated rate constants, and an initial concentration of each species, SimulateEquilibrium solves the system of equations to determine concentrations of the species after all of the reactions have proceeded to equilibrium.",
		"When a list of nucleic acid structures is provided as input, SimulateEquilibrium assumes that the ReactionMechanism is two-state, i.e. each structure is generated only from fully unfolded structure, and there's no cross talk between the structures or any intermediate states.",
		"When input is a list of nucleic acid structures or a reactionModel without explicit reaction rates, assumes binding rate constant for binding at 5*10^5 (Molar*Second)^-1 and calculates the melting rate based on the detailed balance (Keq = kf / kb) along with the nearest-neighbor thermodynamics simulation of equilibrium constant for binding (see SimulateEquilibriumConstant)."
	},
	Tutorials -> {

	},
	Guides -> {
		"Simulation"
	},
	SeeAlso -> {
		"SimulateFolding",
		"SimulateKinetics",
		"SimulateReactivity"
	},
	Author -> {
		"brad",
		"david.hattery",
		"alice"
	},
	Preview -> True
}];
