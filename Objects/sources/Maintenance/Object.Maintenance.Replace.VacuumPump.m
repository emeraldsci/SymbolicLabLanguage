(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Replace, VacuumPump], {
	Description->"A protocol that replaces a vacuum pump.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VacuumPump-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, VacuumPump]|Model[Part, VacuumPump],
			Description -> "The new vacuum pump to install.",
			Category -> "General"
		},
		HPLCStackTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Screwdriver]|Model[Item, Screwdriver],
			Description -> "The tool required to disassemble and reassemble the HPLC stack to remove the degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCStackToolBit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, ScrewdriverBit]|Model[Item, ScrewdriverBit],
			Description -> "The tool required to disassemble and reassemble the HPLC stack to remove the degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCDegasserTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Screwdriver]|Model[Item, Screwdriver],
			Description -> "The tool required to disassemble and reassemble the HPLC degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		HPLCVacuumPumpTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Screwdriver]|Model[Item, Screwdriver],
			Description -> "The tool required to prepare the HPLC vacuum pump for installation into the degasser solvent rack.",
			Category -> "General",
			Developer->True
		},
		TubingConnections -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A record of the tubing that is connected to degasser solvent rack at the beginning of the maintenance.",
			Category -> "General",
			Developer->True
		}
	}
}];
