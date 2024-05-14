(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, NotebookPage], {
	Description -> "A notebook page that has been published externally for viewing on the web or elsewhere.  This includes all subtypes, such as scripts and functions.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceNotebookPage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Notebook],
			Relation -> Object[Notebook],
			Description -> "The notebook page that was published.",
			Category -> "Organizational Information"
		}
	}
}];
