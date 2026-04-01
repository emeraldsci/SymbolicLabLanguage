(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, AuditInventory], {
	Description->"Definition of a set of parameters for a maintenance protocol that audits a storage location or product.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AuditType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Container, Product],
			Description -> "Indicates if the audit target is product or container/instrument.",
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
        }
	}
}];
