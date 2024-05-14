(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Type], {
	Description -> "A type whose helpfile has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceType -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The type that was published.",
			Category -> "Organizational Information"
		}
	}
}];
