

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Item, Screwdriver], {
	Description->"A linear tool used to turn screws, bolts, nuts and/or similar items.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Magnetized -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if the tip of this item is magnetized.",
			Category -> "Item Specifications"
		}
	}
}];
