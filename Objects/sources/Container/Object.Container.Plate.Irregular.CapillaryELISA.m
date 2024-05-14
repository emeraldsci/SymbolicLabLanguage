(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container,Plate,Irregular,CapillaryELISA],{
	Description->"A capillary ELISA cartridge plate that accepts samples, reagents and buffers in individual wells. The cartridge plate contains capillaries and can be loaded into capillary ELISA instrument for the detection and quantification of certain analytes in the samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Operating Limits *)
		MaxNumberOfSamples->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxNumberOfSamples]],
			Pattern:>GreaterEqualP[0,1],
			Description->"Maximum number of samples that can be tested on this capillary ELISA cartridge plate.",
			Category->"Operating Limits"
		},

		(* Container Specifications *)
		CartridgeType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],CartridgeType]],
			Pattern:>ELISACartridgeTypeP,
			Description->"The format of this capillary ELISA cartridge plate (SinglePlex72X1, MultiAnalyte32X4, MultiAnalyte16X4, MultiPlex32X8 or Customizable). The pre-loaded CartridgeType (SinglePlex72X1, MultiAnalyte16X4, MultiAnalyte32X4 and MultiPlex32X8) are pre-loaded with validated ELISA assay.",
			Category->"Container Specifications"
		},
		AnalyteNames->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],AnalyteNames]],
			Pattern:>CapillaryELISAAnalyteP,
			Description->"The manufacturer's listed name(s) of the ELISA analyte(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using this capillary ELISA cartridge.",
			Category->"Container Specifications",
			Abstract->True
		},
		AnalyteMolecules->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],AnalyteMolecules]],
			Pattern:>ObjectP[Model[Molecule]],
			Description->"For each member of AnalyteNames, the identity model(s) of the molecule(s) (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay using this capillary ELISA cartridge.",
			Category->"Container Specifications",
			Abstract->True
		},
		NumberOfReplicates->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfReplicates]],
			Pattern:>GreaterP[0,1],
			Description->"The number of internal replicated measurements for each loaded sample provided by multiple glass nano reactors in the microfluidics channels inside this capillary ELISA cartridge.",
			Category->"Container Specifications"
		},
		WellContents->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],WellContents]],
			Pattern:>ELISAWellContentsP,
			Description->"For each member of Positions, indication of whether the position is intended to hold Sample, Buffer, CaptureAntibody or DetectionAntibody. CaptureAntibody and DetectionAntibody are only applicable for Customizable type of capillary ELISA cartridge.",
			Category->"Container Specifications"
		},
		MinBufferVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MinBufferVolume]],
			Pattern:>EllaCartridgeWashBufferVolumeP,
			Description->"The minimum amount of wash buffer required for running capillary ELISA experiment on this cartridge.",
			Category->"Container Specifications"
		}
	}
}];