(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,HeightGauge], {
	Description->"Model information for a device used to measure vertical distances.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MinDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0Millimeter],
			Units -> Millimeter,
			Description -> "The minimum height that can be measured between the ground and the gauge's probe.",
			Category -> "Organizational Information"
		},
		MaxDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Millimeter],
			Units -> Millimeter,
			Description -> "The maximum height that can be measured between the ground and the gauge's probe.",
			Category -> "Organizational Information"
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Millimeter],
			Units -> Millimeter,
			Description -> "The smallest difference in length that can be measured by the gauge.",
			Category -> "Organizational Information"
		}
	}
}];
