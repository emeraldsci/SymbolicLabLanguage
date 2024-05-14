(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Backdrop], {
	Description->"A backdrop used to change the background color in instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		BackgroundColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BackdropColorP,
			Description -> "The color of the backdrop board.",
			Category -> "Part Specifications"
		}
	}
}];
