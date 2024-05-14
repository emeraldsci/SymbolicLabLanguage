(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software], {
	Description->"An instance of a piece of software at a specific commit in history.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Commit -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The git SHA1 hash for the commit this distro was built on.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> True|False,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information"
		}
	}
}];
