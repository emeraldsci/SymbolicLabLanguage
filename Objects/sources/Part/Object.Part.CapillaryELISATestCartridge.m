(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,CapillaryELISATestCartridge],{
	Description->"A verification cartridge plate that is used by a capillary ELISA instrument to perform a series of diagnostic tests to verify the functionality of laser, motion and temperature components and ensure the instrument is running properly.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		SupportedInstrument->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Instrument, CapillaryELISA]],
			Relation->Object[Instrument, CapillaryELISA][TestCartridge],
			Description->"The capillary ELISA instrument(s) that this verification cartridge can be used in to perform diagnostic tests.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
