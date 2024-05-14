(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,pH], {
	Description->"Information about the pH of a mixture of compounds at room temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		pH ->{
			Format->Multiple,
			Class->Real,
			Pattern:>pHP,
			Relation->Null,
			Units->None,
			Description->"For each member of Compositions, the pH of the mixture of components at room temperature .",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
