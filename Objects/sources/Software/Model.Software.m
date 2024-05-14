(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Software], {
	Description->"A collection of related software builds.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Branch -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The git branch name (SLL repository) for the commit this distro was built on.",
			Category -> "Organizational Information"
		},
		Latest -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Software],
			Description -> "The most recent software build for this model.",
			Category -> "Organizational Information"
		},
		WolframVersion -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The version of the Wolfram Language this software was built for.",
			Category -> "Organizational Information"
		},
		OperatingSystem -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The operating system this software was built to work on.",
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
