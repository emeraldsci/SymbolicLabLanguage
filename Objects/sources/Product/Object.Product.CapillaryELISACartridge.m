(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Product,CapillaryELISACartridge],{
	Description->"A capillary ELISA cartridge product ordered by ECL from the supplier to be used for capillary ELISA experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
        CartridgeType->{
            Format->Single,
            Class->Expression,
            Pattern:>ELISACartridgeTypeP,
            Description->"The format of capillary ELISA cartridge(s) of this product. The pre-loaded CartridgeType (SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4 and MultiPlex32X8) are pre-loaded with validated ELISA assay.",
            Category->"Product Specifications",
            Abstract->True
        },
		AnalyteNames->{
			Format->Multiple,
			Class->String,
			Pattern:>CapillaryELISAAnalyteP,
			Description->"The manufacturer's listed name(s) of the ELISA analyte(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using the capillary ELISA cartridge model in this product.",
			Category->"Product Specifications",
			Abstract->True
		},
		AnalyteMolecules->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Model[Molecule]],
			Relation->Model[Molecule],
			Description->"For each member of AnalyteNames, the identity model(s) of the molecule(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using the capillary ELISA cartridge model in this product.",
			Category->"Product Specifications",
			IndexMatching->AnalyteNames,
			Abstract->True
		},
		ManufacturingSpecifications->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[ManufacturingSpecification]],
			Relation->Object[ManufacturingSpecification][Products],
			Description->"For each member of AnalyteNames, the manufacturing specification with the detailed information about this analyte.",
			Category->"Product Specifications",
			IndexMatching->AnalyteNames
		}
	}
}];

(* The SubType Object[Product,CapillaryELISACartridge] should never be uploaded by an external user through an upload function. The external user can use UploadCapillaryELISACartridge to create a new Model[Container,Plate,Irregular,CapillaryELISA] and the corresponding Object[Product,CapillaryELISACartridge] is created automatically. *)
