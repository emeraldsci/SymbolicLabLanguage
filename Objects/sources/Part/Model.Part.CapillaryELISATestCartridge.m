(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,CapillaryELISATestCartridge],{
	Description->"A model of a verification cartridge plate that is used by a capillary ELISA instrument to perform a series of diagnostic tests to verify the functionality of laser, motion and temperature components and ensure the instrument is running properly.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SupportedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Instrument,CapillaryELISA]],
			Relation->Model[Instrument,CapillaryELISA][TestCartridge],
			Description->"The capillary ELISA instrument model that this verification cartridge can be used in to perform diagnostic tests.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
