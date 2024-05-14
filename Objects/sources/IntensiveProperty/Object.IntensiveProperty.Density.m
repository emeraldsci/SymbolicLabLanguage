(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,Density], {
	Description->"Information about the density of a mixture of compounds at room temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Density ->{
			Format->Multiple,
			Class->Real,
			Pattern:>DensityP,
			Relation->Null,
			Units->Gram/(Liter Milli),
			Description->"For each member of Compositions, the density of the mixture of components at room temperature .",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
