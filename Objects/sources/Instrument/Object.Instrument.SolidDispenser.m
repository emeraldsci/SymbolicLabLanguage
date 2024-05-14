

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, SolidDispenser], {
	Description->"An instrument that automatically doses a set amount of solid from a dosing head using an integrated balance.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Gram],
			Description -> "This is the smallest change in mass that corresponds to a change in displayed value on the integrated balance.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerRepeatability]],
			Pattern :> GreaterP[0*Gram],
			Description -> "This is the dispenser's ability to show consistent results under the same conditions acording to the manufacturer.",
			Category -> "Instrument Specifications"
		},
		MinWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinWeight]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The minimum mass that can be measured and dispensed by this instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWeight -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxWeight]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The maximum mass that can be measured and dispensed by this instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
