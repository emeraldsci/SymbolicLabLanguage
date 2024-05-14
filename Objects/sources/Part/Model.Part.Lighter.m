

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, Lighter], {
	Description -> "Model information for a tool that provides a continuous ignition source.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		LighterType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LighterTypeP,
			Description -> "Indicates the core distinguishing feature of the lighter.",
			Category -> "Model Information"
		},
		IgnitionSourceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IgnitionSourceP,
			Description -> "Indicates the type of ignition source the lighter provides, possible sources include flame, spark, and plasma.",
			Category -> "Model Information"
		},
		FuelType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FuelTypeP,
			Description -> "The fuel that is consumed to create the ignition source.",
			Category -> "Model Information"
		},
		Refillable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this lighter model can be reused once it's initial fuel source depletes.",
			Category -> "Model Information"
		},
		FuelCapacity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The maximum volume of fuel the lighter can hold.",
			Category -> "Model Information"
		}
	}
}];
