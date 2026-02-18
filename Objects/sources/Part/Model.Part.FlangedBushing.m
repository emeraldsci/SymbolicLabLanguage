(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, FlangedBushing], {
	Description->"Model information for a cylindrical sleeve with a flange (rim) on one end, used as a spacer, guide, or bearing component in mechanical assemblies.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The internal diameter of the bushing bore.",
			Category -> "Dimensions & Positions"
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The external diameter of the bushing body.",
			Category -> "Dimensions & Positions"
		},
		FlangeDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The outer diameter of the projecting rim.",
			Category -> "Dimensions & Positions"
		},
		BushingLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The overall length of the bushing including the flange.",
			Category -> "Dimensions & Positions"
		},
		FlangeThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance the flange extends along the axis of the bushing.",
			Category -> "Dimensions & Positions"
		}
	}
}];
