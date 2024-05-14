(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Software,Distro], {
	Description->"A packaged version of the SLL Mathematica code with a specific set of packages.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(*Cannot use Name since this is not unique across ALL distros but within a Commit*)
		DistroName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name for this distro.",
			Category -> "Organizational Information"
		}
	}
}];
