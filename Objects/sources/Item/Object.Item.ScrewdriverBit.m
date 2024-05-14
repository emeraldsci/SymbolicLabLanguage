(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, ScrewdriverBit], {
	Description->"A removable tip, or set of tips, of a linear tool used to turn screws, bolts, nuts and/or similar items.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Magnetized -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if this tip/tip kit is magnetized.",
			Category -> "Item Specifications"
		}
	}
}];
