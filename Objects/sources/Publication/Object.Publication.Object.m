(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Object], {
	Description -> "An object whose helpfile has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceObject -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[]|Object[],
			Description -> "The object that was published.",
			Category -> "Organizational Information"
		}
	}
}];
