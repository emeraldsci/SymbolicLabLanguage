(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, AuditGasCylinders], {
	Description -> "Definition of a set of parameters for a maintenance protocol that audits the gas cylinders within the target room.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		BuildPressure -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the pressures of compatible new tanks are built to the pressures required for usage.",
			Category -> "General"
		}
	}
}];
