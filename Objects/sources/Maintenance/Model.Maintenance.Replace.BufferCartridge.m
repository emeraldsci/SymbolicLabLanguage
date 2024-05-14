(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, Replace, BufferCartridge], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces the cathode buffer cartridge on the SeqStudio Genetic Analyzer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CathodeSequencingBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample],
			Description -> "The pH resistant solution contained in the buffer cartridge container.",
			Category -> "General",
			Abstract -> True
		},
		BufferCartridgeSepta->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item],
			Description->"The partition covering the Buffer Cartridge once the plastic seal is removed.",
			Category->"General"
		}

	}
}];
