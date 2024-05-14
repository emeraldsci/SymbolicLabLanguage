(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Publication, Guide], {
	Description -> "A guide which has been published externally for viewing on the web or elsewhere.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ReferenceGuide -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The guide that was published.",
			Category -> "Organizational Information"
		}
	}
}];
