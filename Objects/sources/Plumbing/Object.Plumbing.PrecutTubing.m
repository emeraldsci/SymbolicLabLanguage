(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing,PrecutTubing], {
	Description->"A flexible, hollow, fixed-length, cylindrical length of material for channeling liquids.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Gauge->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Gauge]],
			Pattern:>GreaterP[0],
			Description->"The standard measure of thickness as per the manufacturer's specifications.",
			Category->"Plumbing Information"
		},
		
		ParentTubing->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ParentTubing]],
			Pattern:>_Link,
			Relation->Model[Plumbing,Tubing],
			Description->"The type of tubing that this model of precut tubing was prepared from.",
			Category->"Plumbing Information"
		}
	}
}];
