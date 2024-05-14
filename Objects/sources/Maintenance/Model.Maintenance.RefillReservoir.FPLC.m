(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,RefillReservoir,FPLC],{
	Description->"Definition of a set of parameters for a maintenance protocol that refills an FPLC's seal wash reservoirs.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Capacities->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Liter,
			Description->"The maximum volumes that the reservoirs can be filled to.",
			Category->"General"
		},
		FillVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Liter,
			Description->"The volumes to which the reservoirs should be filled.",
			Category->"General",
			Abstract->True
		},
		ReservoirContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The type of reservoir containers used for the seal wash.",
			Category->"General"
		},
		ReservoirDeckSlotNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"Slot names of where reservoir containers are stored in the reservoir decks or racks.",
			Category->"General"
		}
	}
}];
