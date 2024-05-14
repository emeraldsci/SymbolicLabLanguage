

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, BottleTopDispenser], {
	Description->"The model for a liquid dispenser that screws onto the top of a bottle.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Minimum volume this model of bottle top dispenser can dispense.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Maximum volume this model of bottle top dispenser can dispense.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Resolution of the bottle top dispenser's volume-indicating markings, determining the increments at which volume can be dispensed.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
