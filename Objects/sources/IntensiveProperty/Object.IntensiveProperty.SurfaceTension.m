(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,SurfaceTension], {
	Description->"Information about the surface tension at room temperature of a mixture of compounds.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SurfaceTension ->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli *Newton/Meter],
			Relation->Null,
			Units->Milli Newton/Meter,
			Description->"For each member of Compositions, the surface tension of the mixture of components at room temperature.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
