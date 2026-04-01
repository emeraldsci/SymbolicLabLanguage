(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, AuditInventory], {
	Description->"A protocol that audits the contents of a storage location.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CryogenicGloves -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Glove], Object[Item, Glove]],
			Description -> "The gloves used to safely handle samples from storage conditions with temperature at or below -80 Celsius.",
			Category -> "General",
			Developer -> True
		},
		AuditedObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
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
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "Objects that were found in this audit.",
			Category -> "General"
		},
		MovedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "Items which the location needs to be updated or verified in this Audit.",
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
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
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
				Object[Container],
                Object[Instrument]
			],
			Description -> "The container being audited for each batch.",
			Category -> "General"
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
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "Objects that were not found in the current iteration.",
			Category -> "General"
		},
        AuditLocation -> {
            Format -> Single,
            Class -> Boolean,
            Pattern :> BooleanP,
            Description -> "Indicate if the location of contents should also be verified in the target container or instrument.",
            Category -> "General"
        },
        AuditNestedContainers -> {
            Format -> Single,
            Class -> Boolean,
            Pattern :> BooleanP,
            Description -> "Indicate if non-empty containers which are contents of the current Target should also be audited in an AuditInventory subprotocol.",
            Category -> "General"
        },
        MaxNestedContentsToAudit -> {
            Format -> Single,
            Class -> Integer,
            Pattern :> GreaterEqualP[1, 1],
            Description -> "Indicate the maximum number of nested contents that can be audited in subprotocols. Note this does not count the direct contents.",
            Category -> "General"
        },
        NextContainerToAudit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description -> "The next nested container to perform AuditInventory on if AuditNestedContainers -> True.",
			Category -> "General"
		},
        ExpectedObjects -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
            Description -> "Any objects that were expected to present as contents of Target according to database.",
            Category -> "General"
        },
        NestedExpectedObjects -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
            Description -> "Any objects that were indirect nested contents of Target according to database.",
            Category -> "General"
        },
        AuditType -> {
            Format -> Single,
            Class -> Expression,
            Pattern :> Alternatives[Container, Product],
            Description -> "Indicates if the audit target is product or container/instrument.",
            Category -> "General"
        },
		ObjectsToDiscard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "Items that were discarded by the end of this audit.",
			Category -> "General"
		},
		UnexpectedItemStorageMovements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Rule..},
			Description -> "The movements that were requested for operators to perform in order to verify or update the FoundObject's location.",
			Category -> "General",
			Developer -> True
		},
		MovementGlovingNote -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The string populated with notes to prompt wearing cryogenic gloves during various auditing Movement tasks when handling ultra-cold items, or otherwise empty.",
			Category -> "General",
			Developer -> True
		}
	}
}];
