(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Spatula], {
	Description->"Model information for an item that is used to transfer and weigh out solids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material of which the spatula is composed.",
			Category -> "Physical Properties"
		},
		TransferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume that this spatula will transfer with one scoop.",
			Category -> "Physical Properties"
		},
		WideEndWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The width of the end section of the spatula that is wider, often with spoon shape, and is used to compare with container aperture to determine if it is suitable for use.",
			Category -> "Physical Properties"
		},
		NarrowEndWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The width of the end section of the spatula that is narrower, often with micro-tip shape, and is used to compare with container aperture to determine if it is suitable for use.",
			Category -> "Physical Properties"
		}
	}
}];
