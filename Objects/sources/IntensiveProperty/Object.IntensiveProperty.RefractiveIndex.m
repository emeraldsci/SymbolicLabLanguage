(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,RefractiveIndex], {
	Description->"Information about the refractive index of a mixture of compounds under ambient condition.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		RefractiveIndex ->{
			Format->Multiple,
			Class->Expression,
			Pattern:>DistributionP[]|GreaterP[1],
			Relation->Null,
			Units->None,
			Description->"For each member of Compositions, the refractive index of the mixture of components under ambient condition.",
			Category -> "Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
