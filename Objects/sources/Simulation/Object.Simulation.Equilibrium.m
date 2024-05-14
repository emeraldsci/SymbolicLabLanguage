(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, Equilibrium], {
	Description->"A simulation to predict the equilibrium state of an initial set of reaction species given a certain ReactionMechanism.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ReactionMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "The ReactionMechanism, or set of reactions, for which the steady-state equilibrium was simulated.",
			Category -> "General",
			Abstract -> True
		},
		InitialState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The initial state of the reaction species, from which the simulation proceeded.",
			Category -> "General",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the simulation was run.",
			Category -> "General",
			Abstract -> True
		},
		Species -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "The full list of species involved in any reaction in the ReactionMechanism.",
			Category -> "General"
		},
		EquilibriumState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The steady-state distribution of the reaction species after simulation of the provided ReactionMechanism.",
			Category -> "Simulation Results",
			Abstract -> True
		}
	}
}];
