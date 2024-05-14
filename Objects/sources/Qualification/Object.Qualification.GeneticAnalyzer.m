(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,GeneticAnalyzer],{
	Description->"A protocol that verifies the functionality of the genetic analyzer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SequencingStandard->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"A DNA strand with a known length and sequence which can sequenced on the genetic analyzer.",
			Category->"General",
			Abstract->True
		},
		Solvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample]|Object[Sample],
			Description->"The solvent used to resuspend the sequencing standard.",
			Category->"General",
			Abstract->True
		},
		PreparatoryUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description->"A list of transfers, consolidations, aliquiots, mixes and diutions that will be performed in the order listed to prepare samples for the qualification.",
			Category->"Sample Preparation"
		}
	}
}];