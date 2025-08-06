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
		PumpSealWashContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample] | Model[Container], Null},
			Description -> "A list of deck placements used for installing pump seal wash containers on the instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		StorageBufferContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The containers that hold the liquid for the storage buffer solutions and will be installed in the instrument.",
			Category->"Refilling"
		},
		ReservoirContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The container that holds reservoir liquid.",
			Category->"Refilling"
		},
		StorageBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing instrument storage buffers onto the instrument buffer deck at the end of the protocol. The instrument storage buffers are used to store the buffer lines while the instrument is not in use.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		StorageBufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions attaching the inlet lines to the instrument buffer caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "Placements",
			Developer -> True
		},
		BufferLineDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected buffer lines.",
			Headers -> {"Container", "Position"},
			Category -> "Placements",
			Developer -> True
		}
	}
}];
