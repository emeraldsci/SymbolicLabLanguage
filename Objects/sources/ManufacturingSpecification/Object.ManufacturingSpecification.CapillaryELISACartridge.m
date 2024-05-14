(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[ManufacturingSpecification,CapillaryELISACartridge],{
	Description->"Detailed information provided by the manufacturer concerning the constraints on the capillary ELISA cartridges they can produce upon demand. Each manufacturing specification provided information about an available ELISA analyte. Analytes sharing similarities in certain fields can be combined to manufacture multiplex capillary ELISA cartridges.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Product Information --- *)
		AnalyteName->{
			Format->Single,
			Class->String,
			Pattern:>CapillaryELISAAnalyteP,
			Description->"The name of the ELISA analyte (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay which this manufacturing specification is for.",
			Category->"Product Specifications",
			Abstract->True
		},
		AnalyteMolecule->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Molecule]],
			Relation->Model[Molecule],
			Description->"The identity model of the molecule (e.g., peptides, proteins, antibodies, hormones) detected in the ELISA assay which this manufacturing specification is for.",
			Category->"Product Specifications",
			Abstract->True
		},
		CartridgeType->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ELISACartridgeTypeP,
			Description->"The format of capillary ELISA cartridge(s) that this analyte can work with, in terms of the numbers of analytes, samples and internal replicates.",
			Category->"Product Specifications"
		},
		Species->{
			Format->Single,
			Class->Expression,
			Pattern:>ELISASpeciesP,
			Description->"The organism (human, mouse or rat) that the samples (containing this analyte) are derived from. The analytes must share the same Species to be combined into a multiplex capillary ELISA cartridge assay.",
			Category->"Product Specifications"
		},
		EstimatedLeadTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Day],
			Units->Day,
			Description->"For each member of CartridgeType, the company's estimated lead time between ordering and receiving a capillary ELISA cartridge product with this analyte.",
			IndexMatching->CartridgeType,
			Category->"Product Specifications"
		},
		MinOrderQuantity->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"For each member of CartridgeType, the minimum quantity of capillary ELISA cartridge with this analyte required to order at one time.",
			IndexMatching->CartridgeType,
			Category->"Product Specifications"
		},
		RecommendedMinDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>_Real,
			Description->"The minimum dilution required for the samples with this analyte before loading into capillary ELISA cartridge. A RecommendedMinDilutionFactor of 0.5 means that the samples are recommended to go through at least a 2-fold dilution. This minimum required dilution factor is determined by the assay developer using the histological concentration(s) of analyte(s) in the origin species and the Upper Limit of Quantitation (ULOQ) concentrations of the assay. It is used to ensure the concentration(s) of analyte(s) in the samples is lower than ULOQ for the best quantification results. Different analytes should share the same RecommendedMinDilutionFactor for the best analysis results on the combined capillary ELISA cartridge assay.",
			Category->"Product Specifications"
		},
		RecommendedDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Sample]],
			Relation->Model[Sample],
			Description->"The default buffer used to mix with the samples with this analyte to reduce its concentration. Diluent is determined by the type of samples containing this analyte (e.g., plasma serum, cell supernatant, ...) to provide the best analysis result on the capillary ELISA cartridge. Analytes should share the same Diluent for the best analysis results on the combined capillary ELISA cartridge assay.",
			Category->"Product Specifications"
		},
		IncompatibleAnalytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[ManufacturingSpecification,CapillaryELISACartridge]],
			Relation->Object[ManufacturingSpecification,CapillaryELISACartridge][IncompatibleAnalytes],
			Description->"The special list of analytes (presented by their manufacturing specifications) that are not be allowed by the manufacturer to be combined into the same multiplex cartridge with this analyte due to undisclosed reasons even if they share the same Species, RecommendedMinDilutionFactor and RecommendedDiluent.",
			Category->"Product Specifications"
		},
		UpperQuantitationLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Picogram/Milliliter],
			Units->Picogram/Milliliter,
			Description->"The average Upper Limit of Quantitation (ULOQ) concentrations of the Analyte in a capillary ELISA experiment. The value is determined by the assay developer through analysis of repeated ELISA experiments using multiple capillary ELISA cartridges. The concentration of the sample loaded into the capillary ELISA cartridge is expected to fall below ULOQ for the best quantifiaction result.",
			Category->"Product Specifications"
		},
		LowerQuantitationLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Picogram/Milliliter],
			Units->Picogram/Milliliter,
			Description->"The average Lower Limit of Quantitation (LLOQ) concentrations of the Analyte in a capillary ELISA experiment. The value is determined by the assay developer through analysis of repeated ELISA experiments using multiple capillary ELISA cartridges. The concentration of the sample loaded into the capillary ELISA cartridge is expected to fall above LLOQ for the best quantifiaction result.",
			Category->"Product Specifications"
		}
	}
}];
