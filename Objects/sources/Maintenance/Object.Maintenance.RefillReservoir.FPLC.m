(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,RefillReservoir,FPLC],{
	Description->"A protocol that refills the seal wash reservoirs of an FPLC.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		FillVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Liter],
			Units->Liter,
			Description->"The volumes to which the reservoirs should be filled.",
			Category->"General",
			Abstract->True
		},
		PurgeWasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The container used to collect purged seal wash liquid.",
			Category->"General",
			Developer->True
		},
		PurgeSyringe->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description->"The syringe used to pull air and seal wash from the seal wash lines to clear them of air bubbles.",
			Category->"General",
			Developer->True
		},
		PumpSealWashContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The containers that hold the liquid for the pump seal wash and will be installed in the instrument.",
			Category->"Refilling"
		},
		ReservoirContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The container that holds reservoir liquid.",
			Category->"Refilling"
		}
	}
}];
