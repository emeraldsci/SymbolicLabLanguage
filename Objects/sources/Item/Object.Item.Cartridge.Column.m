(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Cartridge, Column], {
	Description->"A guard column cartridge for chromatography.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ColumnCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Column][ColumnCartridge],
			Description -> "The guard column in which this cartridge is loaded.",
			Category -> "Compatibility",
			Abstract -> True
		}
	}
}];
