(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing,PrecutTubing], {
	Description->"Model information for a flexible, hollow, fixed-length, cylindrical length of material for channeling liquids.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Gauge -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The standard measure of thickness as per the manufacturer's specifications.",
			Category -> "Plumbing Information"
		},
		
		ParentTubing->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Plumbing,Tubing],
			Description->"The type of tubing that this model of precut tubing was prepared from.",
			Category->"Plumbing Information"
		}
	}
}];
