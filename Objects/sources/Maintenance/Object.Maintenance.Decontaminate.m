(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Decontaminate], {
	Description -> "A protocol that decontaminates a target to ensure a sterile environment is maintained.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the lab section in which this maintenance occurs.",
			Category -> "General"
		}
	}
}];
