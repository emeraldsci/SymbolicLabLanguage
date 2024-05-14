(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,TotalProteinConcentration], {
	Description->"Information about the total protein concentration of a mixture of compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TotalProteinConcentration ->{
			Format->Multiple,
			Class->Real,
			Pattern:>MassConcentrationP,
			Relation->Null,
			Units->Milligram/Milliliter,
			Description->"For each member of Compositions, the mass of proteins present divided by the volume of the lysate.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
