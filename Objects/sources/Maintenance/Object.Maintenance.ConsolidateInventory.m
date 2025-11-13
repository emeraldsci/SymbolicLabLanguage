(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, ConsolidateInventory], {
	Description->"A maintenance protocol that combines objects of the same kind which were stored at different places.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StorageConditions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The storage parameters of items that can be included in this ConsolidateInventory maintenances.",
			Category -> "General"
		},
		ConsolidationThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "The threshold which racks below this should be emptied and have its contents consolidated.",
			Category -> "General"
		},
		RacksToEmpty -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The inventory rack or bins that should have their contents moved out computed at the start of this maintenance.",
			Category -> "Storage & Handling"
		},
		RackPositionsToEmpty -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP..},
			Description -> "For each member of RacksToEmpty, indicate the positions which should have their contents moved out.",
			Category -> "Storage & Handling",
			IndexMatching -> RacksToEmpty
		},
		ModelsToConsolidate -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Model[Item],
				Model[Part],
				Model[Plumbing],
				Model[Wiring]
			],
			Description -> "For each member of RacksToEmpty, indicate the Model of the contents that need to be moved out.",
			Category -> "General",
			IndexMatching -> RacksToEmpty
		},
		DestinationRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "For each member of RacksToEmpty, indicate the inventory rack or bins that which should receive the contents that were moved out.",
			Category -> "Storage & Handling",
			IndexMatching -> RacksToEmpty
		},
		DestinationPosition -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "For each member of RacksToEmpty, indicate the position of the DestinationRacks which the contents should be moved into.",
			Category -> "Storage & Handling",
			IndexMatching -> RacksToEmpty
		},
		ItemVerificationMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[None, Count, Object],
			Description -> "For each member of RacksToEmpty, indicate the method of verifying the contents to be moved out. None means no verification at all. Count means operator will be asked to count the number of contents and check if it's consistent with the count recorded in database. Object means operator will scan every single item to verify their IDs.",
			Category -> "Batching",
			IndexMatching -> RacksToEmpty
		},
		NumberOfItems -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of RacksToEmpty, indicate the number of items that need to be moved out.",
			Category -> "Batching",
			IndexMatching -> RacksToEmpty
		},
		BatchedItems -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectReferenceP[]|Null)..},
			Description -> "For each member of RacksToEmpty, indicate all items that need to be moved out.",
			Category -> "Batching",
			Developer -> True,
			IndexMatching -> RacksToEmpty
		},
		Items -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "All objects that need to be moved out.",
			Category -> "General"
		},
		ConsolidationComplete -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of RacksToEmpty, indicate if this movement will remove all the items of the piled model. This is usually always True if the contents from RacksToEmpty will be moved into one single DestinationRacks, but if contents from RacksToEmpty will be distributed into multiple DestinationRacks, only the last movement will have ConsolidationComplete -> True.",
			Developer -> True,
			IndexMatching -> RacksToEmpty,
			Category -> "Batching"
		},
		StoreRacks -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of RacksToEmpty, indicate if this rack will be stored away by the end of consolidation. This should only be True if the rack becomes empty and it's mobile.",
			IndexMatching -> RacksToEmpty,
			Category -> "Batching"
		},
		BatchedMovements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {Rule[(ObjectReferenceP[]| Null), ({LocationPositionP, ObjectReferenceP[]} | Null)]..},
			Description -> "For each member of RacksToEmpty, indicate the movements requested to consolidate items.",
			Category -> "Batching",
			Developer -> True,
			IndexMatching -> RacksToEmpty
		},
		NumberOfFoundItems -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of RacksToEmpty, indicate the number of items of the Model ModelsToConsolidate that were actually found by the operator.",
			Category -> "Batching",
			Developer -> True
		},
		FoundObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that were found in this maintenance.",
			Category -> "General"
		},
		MissingObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that were not found in this maintenance.",
			Category -> "General"
		},
		CurrentExcessItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that still present in the RackPositionsToEmpty position(s) of RacksToEmpty containers after consolidation are done.",
			Category -> "Storage Information",
			Developer -> True
		},
		ExcessItemsIDs -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The operator's scanned barcode IDs of objects that still present in the RackPositionsToEmpty position(s) of RacksToEmpty containers after consolidation are done.",
			Category -> "Storage Information",
			Developer -> True
		},
		CurrentExcessItemMovements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Rule[ObjectReferenceP[], {LocationPositionP, ObjectReferenceP[]}],
			Description -> "The movement rules of CurrentExcessItems to have them properly stored.",
			Category -> "Storage Information",
			Developer -> True
		},
		CurrentExcessItemsForStorage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that are part of CurrentExcessItems but not of the ModelsToConsolidate, therefore will be stored elsewhere.",
			Category -> "Storage Information",
			Developer -> True
		},
		Destinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description -> "For each member of RacksToEmpty, indicate the destination to move the rack to.",
			Category -> "General",
			Developer->True,
			IndexMatching -> RacksToEmpty
		},
		DestinationRackFull -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of DestinationRacks, indicate if the destination is full and can't accept any further items.",
			Category -> "General",
			Developer->True,
			IndexMatching -> DestinationRacks
		},
		ExpectedDestinationItemCounts -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of DestinationRacks, indicate the number of items of model ModelsToConsolidate in the rack before the consolidation movement.",
			Category -> "General",
			Developer->True,
			IndexMatching -> DestinationRacks
		},
		ExpectedDestinationAvailableCapacity -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of DestinationRacks, indicate the number of items of model ModelsToConsolidate it can fit before the consolidation movement.",
			Category -> "General",
			Developer->True,
			IndexMatching -> DestinationRacks
		}

	}
}];
