(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Symbol], {
	Description -> "A symbol whose helpfile has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceSymbol -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The symbol that was published.",
			Category -> "Organizational Information"
		}
	}
}];
