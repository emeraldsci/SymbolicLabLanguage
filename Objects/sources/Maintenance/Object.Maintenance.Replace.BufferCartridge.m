(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, Replace, BufferCartridge], {
	Description->"A protocol that replaces the buffer cartridge on the SeqStudio Genetic Analyzer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CathodeSequencingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[Sample]|Model[Sample],
			Description -> "The pH resistant solution contained in the buffer cartridge container.",
			Category -> "General",
			Abstract -> True
		},
		BufferCartridgeSepta->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item]|Object[Item],
			Description->"The partition covering the Buffer Cartridge once the plastic seal is removed.",
			Category->"General"
		},
		CartridgePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP}},
			Relation -> {Object[Container] | Model[Container] | Object[Item] | Model[Item], Null},
			Description -> "A list of placements used to place the buffer cartridge into the buffer cartridge slot of the genetic analyzer.",
			Category -> "Sample Loading",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		}
	}
}];