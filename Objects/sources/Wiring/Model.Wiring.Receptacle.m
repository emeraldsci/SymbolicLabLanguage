(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring, Receptacle], {
	Description -> "Model information regarding an electrical receptacle that supplies power to an electrical load via a plug.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		OutputVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Output voltage that is supplied when connected to an electrical load.",
			Category -> "Operating Limits"
		},

		NumberOfTerminals -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of wire terminals that this receptacle has for the purposes of properly getting power from its corresponding circuit breaker. Excludes terminals for grounding wires.",
			Category -> "Wiring Information"
		},

		NumberOfOutlets-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of outlets the receptacle has for plugs to connect to.",
			Category -> "Wiring Information"
		}

	}
}];
