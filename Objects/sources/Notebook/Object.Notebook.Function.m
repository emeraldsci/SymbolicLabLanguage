(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notebook, Function], {
	Description -> "A function asset in a lab notebook.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Enabled -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this function will be loaded into the current kernel.",
			Category -> "Organizational Information"
		},
		ExpressionCells -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Base64 encoded JSON object representing all input cells that will be inside the Function page.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateModified -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the Notebook Function was modified.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
