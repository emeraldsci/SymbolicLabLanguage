(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Rod], {
	Description->"Model information for a cylindrical bar or shaft used as a structural, support, or mechanical component.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The outer diameter of the bar.",
			Category -> "Dimensions & Positions"
		},
		RodLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The full length of the bar.",
			Category -> "Dimensions & Positions"
		},
		Threaded -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the rod has external threading along its length or at the ends.",
			Category -> "Physical Properties"
		}
	}
}];
