

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance,Clean,DifferentialScanningCalorimeter],{
	Description->"A protocol that cleans a differential scanning calorimeter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CleaningSolutions->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solutions that will be used to flush the flow cell.",
			Category -> "General",
			Abstract->True
		}
	}
}];
