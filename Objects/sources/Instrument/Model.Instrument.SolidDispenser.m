

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, SolidDispenser], {
	Description->"Model of an instrument that automatically doses a set amount of solid from a dosing head using an integrated balance.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "This is the smallest change in mass that corresponds to a change in displayed value on the integrated balance.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "This is the model of dispenser's ability to show consistent results under the same conditions according to the manufacturer.",
			Category -> "Instrument Specifications"
		},
		MinWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The minimum mass that can be measured and dispensed by this model of instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum mass that can be measured and dispensed by this model of instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
