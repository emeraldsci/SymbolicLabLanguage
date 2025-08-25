(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notebook], {
	Description -> "An asset in a lab notebook.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A short title indicating this notebook asset's purpose and contents.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The investigator who created this notebook.",
			Category -> "Organizational Information"
		},
		DisplayName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A short title which is displayed for this asset in the user interface.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		AssetFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloud file storing the asset.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		AssetFileLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[EmeraldCloudFile], Object[User]},
			Headers -> {"Date Changed", "New Asset Cloud File", "Updating User"},
			Description -> "The history of files for this asset, oldest to newest.",
			Category -> "Organizational Information"
		},
		Protocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol] | Object[Qualification][Script] | Object[Maintenance][Script] | Object[Protocol][Script] | Object[Notebook,Script][Script],
			Description -> "All parent protocols in this notebook.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ParentFolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Folder][Contents],
			Description -> "The folder in which the notebook is organized within.",
			Category -> "General"
		}
	}
}];
