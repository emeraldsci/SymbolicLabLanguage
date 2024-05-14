(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication], {
	Description -> "An object that has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Identifier -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A way to look up the object when the object is only accessible via private link.",
			Category -> "Organizational Information"
		},
		Assets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The assets (images, json files, etc.) required to render this object on the web.",
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
		LinkedObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[]|Object[],
			Description -> "Any objects or models that are referenced within this publication.  This information is used to determine whether or not to autolink the references based on whether the referenced objects and models are published.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
