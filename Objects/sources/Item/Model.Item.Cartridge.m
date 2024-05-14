(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Cartridge], {
	Description-> "Model information for Parent Model cartridge associated with various instruments and applications.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CartridgeImageFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A photo of this cartridge.",
			Category->"Organizational Information",
			Abstract->True
		},
		CartridgeType->{
			Format->Single,
			Class->Expression,
			Pattern:>CartridgeTypeP,(* Column|DNASequencing|ProteinCapillaryElectrophoresis|Osmolality *)
			Description->"The instrument this cartridge is compatible with.",
			Category->"Organizational Information",
			Abstract->True
		}
	}
}];