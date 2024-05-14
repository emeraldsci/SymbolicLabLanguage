(* ::Package:: *)
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[IntensiveProperty,pHAdjustment], {
	Description->"Information about adjusting pH of a mixture of compounds at room temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NominalpHs ->{
			Format->Multiple,
			Class->Real,
			Pattern:>pHP,
			Relation->Null,
			Units->None,
			Description->"For each member of Compositions, the nominal pH of the mixture of components.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		},
		FinalpHs ->{
			Format->Multiple,
			Class->Real,
			Pattern:>pHP,
			Relation->Null,
			Units->None,
			Description->"For each member of Compositions, the pH reached after all the additions.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		},
		Additions ->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterP[0 Milliliter] | GreaterP[0 Gram]| GreaterP[0], ObjectP[{Model[Sample], Object[Sample]}]}..},
			Units->None,
			Description->"For each member of Compositions, the total amount added to achieve the desired pH.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];