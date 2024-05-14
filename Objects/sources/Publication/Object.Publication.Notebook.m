(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Notebook], {
	Description -> "A notebook that has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[LaboratoryNotebook]],
			Relation -> Object[LaboratoryNotebook],
			Description -> "The laboratory notebook that was published.",
			Category -> "Organizational Information"
		}
	}
}];
