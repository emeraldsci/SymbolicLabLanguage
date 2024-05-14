

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,Clean,DifferentialScanningCalorimeter],{
	Description->"Definition of a set of parameters for a maintenance protocol that cleans the flow cell of a differential scanning calorimeter instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CleaningSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The solution that will be used to flush the flow cell.",
			Category -> "General",
			Abstract->True
		}
	}
}];
