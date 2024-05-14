(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, ReactionMechanism], {
	Description->"A simulation to generate a putative reaction ReactionMechanism given a set of initial species.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		InitialState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StateP,
			Description -> "The specified initial state of the reaction system to be simulated.",
			Category -> "General",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature under which the simulation will be run.",
			Category -> "General"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Nanoliter,
			Description -> "The total volume of the reaction system to be simulated.",
			Category -> "General"
		},
		Species -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ReactionSpeciesP,
			Description -> "A full set of the molecules involved in the ReactionMechanism.",
			Category -> "General"
		},
		ReactionMechanism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionMechanismP,
			Description -> "A ReactionMechanism construct summarizing the series of reactions that are avaiable to the reactants from their initial state.",
			Category -> "Simulation Results",
			Abstract -> True
		}
	}
}];
