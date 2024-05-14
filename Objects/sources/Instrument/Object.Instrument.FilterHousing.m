

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, FilterHousing], {
	Description->"An instrument that holds a disk membrane during filtration of solution in order to remove particles above a certain size from the sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MembraneDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MembraneDiameter]],
			Pattern:>GreaterP[0*Meter],
			Description -> "The diameter of the filter membrane compatible with this housing.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		DeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],DeadVolume]],
			Pattern :> GreaterEqualP[0*Milliliter],
			Description -> "Dead volume needed to fill the instrument lines.",
			Category -> "Instrument Specifications"
		}
	}
}];
