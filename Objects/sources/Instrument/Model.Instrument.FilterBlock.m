

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, FilterBlock], {
	Description->"A model for housing for filter plates used in vacuum filtration.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "Minimum internal pressure in the filter block (as designated by its pressure gauge).",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
