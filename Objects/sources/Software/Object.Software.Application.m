(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Software,Application], {
	Description->"A packaged version of an application for a specific commit in histroy.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Installer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The link to the application installer file.",
			Category -> "Organizational Information"
		}
	}
}];
