(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Plate,Irregular,CapillaryELISA],{
	Description->"A model for a capillary ELISA cartridge plate that accepts samples, reagents and buffers in individual wells. The cartridge plate contains capillaries and can be loaded into capillary ELISA instrument for the detection and quantification of certain analytes in the samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Operating Limits *)
		MaxNumberOfSamples->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"Maximum number of samples that can be tested on this capillary ELISA cartridge plate.",
			Category->"Operating Limits"
		},

		(* Container Specifications *)
		CartridgeType->{
			Format->Single,
			Class->Expression,
			Pattern:>ELISACartridgeTypeP,
			Description->"The format of this model of capillary ELISA cartridge plate (SinglePlex72X1, MultiAnalyte32X4, MultiAnalyte16X4, MultiPlex32X8 or Customizable). The pre-loaded CartridgeType (SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4 and MultiPlex32X8) are pre-loaded with validated ELISA assay.",
			Category->"Container Specifications"
		},
		AnalyteNames->{
			Format->Multiple,
			Class->String,
			Pattern:>CapillaryELISAAnalyteP,
			Description->"The manufacturer's listed name(s) of the ELISA analyte(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using this capillary ELISA cartridge model.",
			Category->"Container Specifications",
			Abstract->True
		},
		AnalyteMolecules->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Model[Molecule]],
			Relation->Model[Molecule],
			Description->"For each member of AnalyteNames, the identity model(s) of the molecule(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using this capillary ELISA cartridge model.",
			Category->"Container Specifications",
			IndexMatching->AnalyteNames,
			Abstract->True
		},
		NumberOfReplicates->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of internal replicated measurements for each loaded sample provided by multiple glass nano reactors in the microfluidics channels inside this model of capillary ELISA cartridge.",
			Category->"Container Specifications"
		},
		WellContents->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ELISAWellContentsP,
			Description->"For each member of Positions, indication of whether the position is intended to hold Sample, Buffer, CaptureAntibody or DetectionAntibody. CaptureAntibody and DetectionAntibody are only applicable for Customizable type of capillary ELISA cartridge.",
			IndexMatching->Positions,
			Category->"Container Specifications"
		},
		MinBufferVolume->{
			Format->Single,
			Class->Real,
			Pattern:>EllaCartridgeWashBufferVolumeP,
			Units->Milliliter,
			Description->"The minimum amount of wash buffer required for running capillary ELISA experiment on this cartridge model.",
			Category->"Container Specifications"
		}
	}
}];