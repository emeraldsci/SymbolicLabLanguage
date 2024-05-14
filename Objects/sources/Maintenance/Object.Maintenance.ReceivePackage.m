(* ::Package:: *)

(**)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, ReceivePackage], {
	Description->"A protocol that processes receiving packages.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SupplierName-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Supplier that the package was sent from.",
			Category -> "Receiving Information"
		},
		PackageQuantity -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "Tracking numbers provided by the shipping company on the package.",
			Category -> "Sender Information"
		},
		StorageLocation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The location used to store packages.",
			Category -> "Receiving Information"
		},
		Packages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Package][Receiving],
			Description -> "The Packages which are actively being used by this protocols.",
			Category -> "Resources",
			Developer -> True
		},
		ReceivingBench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Bench], Object[Container, Shelf]],
			Description -> "The bench to which newly-created items are moved before they are stored in a receiving protocol.",
			Category -> "Operations Information"
		}
	}
}];
