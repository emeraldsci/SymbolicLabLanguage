(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, ConsolidateInventory], {
	Description->"Definition of a set of parameters for a maintenance protocol that combines objects of the same kind which were stored at different places.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StorageConditions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The storage parameters of items that can be included in this type of ConsolidateInventory maintenances.",
			Category -> "General"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Site],
			Description -> "The site which this type of CondilidateInventory can take place.",
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
		StorageLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location which emptied bin and racks should be stored.",
			Category -> "General"
		}

	}
}];
