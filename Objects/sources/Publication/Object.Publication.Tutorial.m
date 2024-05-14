(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Tutorial], {
	Description -> "A tutorial whose notebook has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceTutorial -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The tutorial that was published.",
			Category -> "Organizational Information"
		}
	}
}];
