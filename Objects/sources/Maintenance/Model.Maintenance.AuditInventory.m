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
		}
	}
}];
