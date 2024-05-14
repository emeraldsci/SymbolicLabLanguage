(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,Viscosity], {
	Description->"Information about the viscosity of a mixture of compounds at room temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Viscosity->{
			Format->Multiple,
			Class->Expression,
			Pattern:>GreaterEqualP[0*(Milli*Pascal)*Second],
			Relation->Null,
			Description->"For each member of Compositions, the viscosity of the mixture of components.",
			Category->"Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
