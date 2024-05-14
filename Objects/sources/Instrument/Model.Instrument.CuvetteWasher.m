

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, CuvetteWasher], {
	Description->"A model for an instrument for washing cuvettes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		CuvetteCapacity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of cuvettes that can be washed simultaneously.",
			Category -> "Instrument Specifications"
		},
		TrapCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Units -> Liter Milli,
			Description -> "The volume of wash solution waste that the trap flask can hold before needing to be emptied.",
			Category -> "Instrument Specifications"
		}
	}
}];
