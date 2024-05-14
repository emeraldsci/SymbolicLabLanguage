(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,FlashChromatography],{
	Description->"A protocol that cleans the flow cell of a flash chromatography instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CleaningSolvent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The model of solvent to use to clean the flow cell of the flash chromatography instrument.",
			Category->"General"
		},
		Column->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Column],
			Description->"The model of column attached to the flash chromatography instrument as its flow cell is cleaned.",
			Category->"General"
		},
		FlushTime->{
			Format->Single,
			Class->Real,
			Pattern:>TimeP,
			Units->Minute,
			Description->"The amount of time to flush the CleaningSolvent through the Column in order to clean the flow cell of the flash chromatography instrument.",
			Category->"General"
		},
		CleaningProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,FlashChromatography],
			Description->"The flash chromatography protocol run to clean the flow cell of the flash chromatography instrument.",
			Category->"General"
		}
	}
}];
