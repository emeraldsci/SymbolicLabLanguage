(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, VacuumPump], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces a vacuum pump.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VacuumPump-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, VacuumPump],
			Description -> "The model of vacuum pump to install.",
			Category -> "General"
		},
		HPLCStackTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Screwdriver],
			Description -> "The tool required to disassemble and reassemble the HPLC stack to remove the degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCStackToolBit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, ScrewdriverBit],
			Description -> "The tool required to disassemble and reassemble the HPLC stack to remove the degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCDegasserTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Screwdriver],
			Description -> "The tool required to disassemble and reassemble the HPLC degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCVacuumPumpTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Screwdriver],
			Description -> "The tool required to prepare the HPLC vacuum pump for installation into the degasser solvent rack.",
			Category -> "General",
			Developer->True
		}
	}
}];
