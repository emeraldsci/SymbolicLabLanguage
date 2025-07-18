(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Folder], {
	Description->"A categorization of objects into folders for use in Command Center.",
	CreatePrivileges->Developer,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Name of the object which can be used as shorthand when downloading from or uploading to Constellation object.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		Label->{
			Format->Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The label of the folder indicating the content of the objects within this folder to be displayed in Command Center.",
			Category->"Organizational Information",
			Abstract->True
		},
		Description->{
			Format->Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A short sentence or two description of the kind of things contained within this folder.",
			Category->"Organizational Information",
			Abstract->False
		},
		ParentFolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Folder][Contents],
			Description -> "The Parent folder of the current folder.",
			Category -> "Organizational Information"
		},
		Contents-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook][ParentFolder] | Object[Folder][ParentFolder],
			Description -> "The objects or further folders that belong in this folder during object selection.",
			Category -> "Organizational Information",
			Abstract->False
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
