(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Software,DocumentationBundle], {
	Description->"A complete bundle of the documentation for the Symbolic Laboratory Language (SLL).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DateDocumentationCreated -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date the artifacts that make up this bundle were generated.  For example, if the documentation is based off of the output of a test run, this would be the date the test run completed.  This can be different from the date created, which is the date the bundle was generated.",
			Category -> "Organizational Information"
		},
		IndexBundle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation -> Object[EmeraldCloudFile],
			Description -> "The archive containing all of the indexes required to search this documentation bundle.",
			Category -> "Organizational Information"
		},
		DocumentationArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation -> Object[EmeraldCloudFile],
			Description -> "The archive containing all of the SLL help documents.",
			Category -> "Organizational Information"
		},
		StorageBucketName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the storage bucket the full documentation is stored in.",
			Category -> "Organizational Information"
		},
		SymbolDocumentationPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The relative path within the AWS storage bucket to the symbol documentation.",
			Category -> "Organizational Information"
		},
		TutorialsPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The relative path within the AWS storage bucket to the tutorials.",
			Category -> "Organizational Information"
		},
		GuidesPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The relative path within the AWS storage bucket to the guides.",
			Category -> "Organizational Information"
		},
		OverriddenSymbols -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "A list of symbols whose docs have been updated after the documentation archive was built.  These docs should be pulled from documentation.json rather than relying on the documentation archive.",
			Category -> "Organizational Information"
		}
	}
}];
