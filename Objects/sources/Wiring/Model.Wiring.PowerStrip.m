(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring, PowerStrip], {
  Description -> "Model information regarding a power strip that draws power from a receptacle directly wired to a circuit breaker.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

		NumberOfOutlets-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of outlets the power strip has for plugs to connect to.",
			Category -> "Wiring Information"
		},
		
		SurgeProtection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this power strip is designed to protect connected components from voltage spikes.",
			Category -> "Wiring Information"
		}

  }
}];
