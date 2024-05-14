

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, SyringePump], {
	Description->"A small pump, used to gradually drive a small amount of liquid through a syringe.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "Maximum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "Minimum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
