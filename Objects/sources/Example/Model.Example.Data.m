(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Example,Data],
{
	Description->"Sample model for unit testing purposes",
	CreatePrivileges->Developer,
	Fields -> {
		Number -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A number.",
			Category -> "Experiments & Simulations",
			Required -> True,
			Abstract -> False
		},
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A string field for uniqueness for delete unit test.",
			Category -> "Experiments & Simulations",
			Required -> False,
			Abstract -> False
		}
	}
}];
