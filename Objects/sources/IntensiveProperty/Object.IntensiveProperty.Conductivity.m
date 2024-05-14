(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[IntensiveProperty,Conductivity], {
	Description->"Information about the conductivity of a mixture of compounds at room temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Conductivity->{
			Format->Multiple,
			Class->Expression,
			Pattern:>DistributionP[Micro Siemens/Centimeter],
			Relation->Null,
			Description->"For each member of Compositions, the conductivity of the mixture of components.",
			Category->"Organizational Information",
			IndexMatching->Compositions
		}
	}
}];
