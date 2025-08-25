(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, AuditInventory], {
	Description->"A protocol that audits the contents of a storage location.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AuditedObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any objects that were audited in this maintenance.",
			Category -> "General"
		},
		FoundObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that were found in this audit.",
			Category -> "General"
		},
		MissingObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that were not found in this audit.",
			Category -> "General"
		},
		PublicObjects -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the audit will include Public objects.",
			Category -> "General"
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of samples audited.",
			Category -> "Batching",
			Developer -> True
		},
		TargetContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "The container being audited for each batch.",
			Category -> "General"
		},
		MovedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "Audited racks which are moved to the cart in order to perform the audit. They are returned to Destinations when the audit is complete.",
			Category -> "General",
			Developer->True
		},
		Destinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description -> "The destinations in which MovedItems are placed when the audit is complete.",
			Category -> "General",
			Developer->True
		},
		RetryState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[True, False, Skip],
			Description -> "Indicate if operator needs to retry auditing of items from current iteration.",
			Category -> "General",
			Developer -> True
		},
		CurrentMissingObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Objects that were not found in the current iteration.",
			Category -> "General"
		}
	}
}];
