(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, DensityMeter], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a density meter.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ExpectedDensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Gram / Milliliter],
			Units -> Gram / Milliliter,
			Description -> "The expected mean density of the sample measured by this model of qualification.",
			Category -> "Passing Criteria"
		},
		DensityTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Gram / Milliliter],
			Units -> Gram / Milliliter,
			Description -> "The allowed deviation from the expected mean density of the sample measured by this model of qualification.",
			Category -> "Passing Criteria"
		}
	}
}];
