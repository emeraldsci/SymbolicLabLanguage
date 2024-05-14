

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, SyringePump], {
	Description->"The model for a small pump, used to gradually drive a small amount of liquid through a syringe.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Maximum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "Minimum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
