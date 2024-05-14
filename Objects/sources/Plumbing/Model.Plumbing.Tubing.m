(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing,Tubing], {
	Description->"Model information for a flexible, hollow, cylindrical length of material for channeling liquids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinBentRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The minimum radius this tubing can be bent as per the manufacturer's specifications.",
			Category -> "Plumbing Information"
		},
		Opacity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Transparent|Opaque,
			Description -> "The extent to which light may pass through the exterior walls of this tubing.",
			Category -> "Plumbing Information"
		},
		TubingColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _RGBColor,
			Description -> "The color of the exterior of this tubing.",
			Category -> "Plumbing Information"
		},
		CutToSize -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the tubing can be cut by a cutting jig to fulfill a resource for a specified size of tubing.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
