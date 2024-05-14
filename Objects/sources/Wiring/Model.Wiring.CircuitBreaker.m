(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring, CircuitBreaker], {
	Description -> "Model information for an electrical switch used to prevent excess current from damaging a circuit.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		CircuitBreakerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CircuitBreakerTypeP,
			Description -> "The number of poles in the circuit breaker.",
			Category -> "Wiring Information"
		},
	
		BreakingCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere],
			Units -> Ampere,
			Description -> "Maximum current that can be interrupted by the circuit breaker without being damaged.",
			Category -> "Operating Limits"
		},
	
		NumberOfSpaces -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of slots that this circuit breaker occupies in an electrical panel.",
			Category -> "Wiring Information"
		}

	}
}];
