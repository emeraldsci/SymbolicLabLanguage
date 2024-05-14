(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Software,Application], {
	Description->"A software application.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ApplicationName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this application.",
			Category -> "Organizational Information"
		}
	}
}];
