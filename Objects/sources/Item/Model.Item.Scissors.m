(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Scissors], {
	Description->"Model information for a pivoted pair of sharpened metal blades that is used for cutting various thin materials.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the scissors are made out of.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
