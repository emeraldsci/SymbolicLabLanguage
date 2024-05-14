(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Catalog], {
	Description->"A categorization objects into folders for use in object selection.",
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
		Folder->{
			Format->Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The label of the catalog folder indicating the scientific content of the objects within to be displayed during object selection.",
			Category->"Organizational Information",
			Abstract->True
		},
		Description->{
			Format->Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A short sentence or two description of the kind of things contained within this catalog folder.",
			Category->"Organizational Information",
			Abstract->False
		},
		Contents-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Types[],
			Description -> "The objects or further catalog folders that belong in this catalog folder during object selection.",
			Category -> "Organizational Information",
			Abstract->False
		},
		Sites->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{LinkP[Object[Container,Site]]...},
			Units -> None,
			Description -> "For each member of Contents, specifies which Site the items are available at.",
			Category -> "Organizational Information",
			IndexMatching -> Contents,
			Developer->True
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
