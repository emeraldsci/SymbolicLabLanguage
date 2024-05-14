(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, FilterAdapter], {
	Description -> "Model information for an interchangeable part used at the interface of a filter flask and filter funnel (such as a Buchner funnel).",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		OuterDiameter -> {
			Format -> Single,
			Class -> {
				Top -> Real,
				Bottom -> Real
			},
			Pattern :> {
				Top -> GreaterP[0 Millimeter],
				Bottom -> GreaterP[0 Millimeter]
			},
			Units -> {
				Top -> Millimeter,
				Bottom -> Millimeter
			},
			Description -> "The distance across exterior of this adapter, for both the top and bottom openings.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> {
				Top -> Real,
				Bottom -> Real
			},
			Pattern :> {
				Top -> GreaterP[0 Millimeter],
				Bottom -> GreaterP[0 Millimeter]
			},
			Units -> {
				Top -> Millimeter,
				Bottom -> Millimeter
			},
			Description -> "The distance across interior of this adapter, for both the top and bottom openings.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Thickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Millimeter],
			Description -> "The width of the wall of this filter adapter.",
			Units -> Millimeter,
			Category -> "Physical Properties"
		}
	}
}];
