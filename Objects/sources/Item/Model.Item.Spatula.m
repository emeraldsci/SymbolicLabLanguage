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
		}
	}
}];
