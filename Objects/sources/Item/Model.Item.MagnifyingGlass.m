(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, MagnifyingGlass], {
	Description->"Model information for a tool to help view smaller objects with clarity.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Magnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0,1],
			Description -> "The factor by which this item enlarges the viewed object.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		Lighting -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicated whether this magnifying glass has an option to light the viewed object.",
			Category-> "Part Specifications",
			Abstract -> True
		},
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The diameter of the magnifying glass.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		HandHeld -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicated whether this magnifying glass is mounted onto a bench or can be held by an operator.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
