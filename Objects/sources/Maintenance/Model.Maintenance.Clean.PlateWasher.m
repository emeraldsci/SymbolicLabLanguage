(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,Clean,PlateWasher], {
	Description->"Definition of a set of parameters for a maintenance protocol that flushes and cleans the plate washer instrument to ensure there is no carry over of reagents between syntheses.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		WashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of liquid used to flush and clean all the liquid handling lines in the plate washer.",
			Category -> "General"
		},
		MaintenancePlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate]
			],
			Description -> "The type of microplate that is used to collect liquid being flushed into and drained from the plate washer.",
			Category -> "General"
		},
		WashVolume->{
			Format->Single,
			Description->"The volume of WashSolvent added in each well during the flushing of the plate washer.",
			Pattern:>RangeP[25 Microliter,300 Microliter],
			Class->Real,
			Units->Microliter,
			Category -> "General"
		},
		NumberOfWashes->{
			Format->Single,
			Description->"The number of washes performed during the flushing of the plate washer.",
			Pattern:>GreaterP[0],
			Class->Real,
			Category -> "General"
		}
	}
}];
