(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Blade], {
	Description->"Model information for a cutting edge component used in mechanical cutting, scraping, or slicing assemblies.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BladeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The overall length of the cutting edge.",
			Category -> "Dimensions & Positions"
		},
		BladeWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The width of the blade from cutting edge to back edge.",
			Category -> "Dimensions & Positions"
		},
		BladeThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The widest part of the cutting edge.",
			Category -> "Dimensions & Positions"
		},
		BladeMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material from which the blade is constructed.",
			Category -> "Physical Properties"
		}
	}
}];
