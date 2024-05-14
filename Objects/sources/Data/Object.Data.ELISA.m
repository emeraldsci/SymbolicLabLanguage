(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, ELISA], {
	Description->"Experimental results from an Enzyme-Linked Immunosorbent Assay (ELISA) experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(*Method Information*)
		AssayType->{
			Format->Single,
			Class->Expression,
			Pattern:>ELISATypeP,
			Description->"The type of Enzyme-Linked Immunosorbent Assay (ELISA) experiment which this data is generated from.",
			Category -> "General"
		},
		DataType->{
			Format->Single,
			Class->Expression,
			Pattern:>ELISASampleTypeP,
			Description->"The type of the sample - Unknown, Standard (sample with known concentrations of analytes) Spike (unknown sample plus a standard sample to increase the concentrations of analytes), or Blank.",
			Category -> "General"
		},
		Preread->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicate if this data object if for the preread data.",
			Category -> "General"
		},
		PrereadTimepoint->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"Indicate which timepoint during the SubstrateIncubationTime was this data collected.",
			Category -> "General"
		},
		Cartridge->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Container,Plate,Irregular,CapillaryELISA]],
			Relation->Object[Container,Plate,Irregular,CapillaryELISA],
			Description->"The capillary ELISA cartridge plate used to quantify the analytes (such as peptides, proteins, antibodies and hormones) in the sample.",
			Category -> "General"
		},
		Multiplex->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if multiple analytes were quantified in the sample.",
			Category -> "General"
		},
		Analyte->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Molecule]],
			Relation->Model[Molecule],
			Description->"The target (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the sample through ELISA experiment.",
			Category -> "General"
		},
		MultiplexAnalytes->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Model[Molecule]],
			Relation->Model[Molecule],
			Description->"The multiplex analytes that are detected and quantified simultaneously in the sample through ELISA experiment.",
			Category -> "General"
		},
		NumberOfReplicates->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of internal replicated measurements for each loaded sample provided by the ELISA experiment. The final data is averaged from the replicates.",
			Category -> "General"
		},
		CoatingAntibody->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample containing the antibody that is used in for coating ELISA Plates in FastELISA.",
			Category -> "General"
		},
		CoatingAntibodyDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The ratio of dilution of CoatingAntibody.",
			Category -> "General"
		},

		CaptureAntibody->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The capture antibody sample used in the Sandwich ELISA and Fast ELISA methods to immobilize the analytes in the sample through specific antigen-antibody interaction.",
			Category -> "General"
		},
		CaptureAntibodyDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The ratio of dilution of CaptureAntibody.",
			Category -> "General"
		},
		ReferenceAntigen->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The Sample containing the antigen that is used in Competitive ELISAs.",
			Category -> "General"
		},
		ReferenceAntigenDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The ratio of dilution of ReferenceAntigen.",
			Category -> "General"
		},
		PrimaryAntibody->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The antibody that directly binds with the TargetAntigen (Analyte).",
			Category -> "General"
		},
		PrimaryAntibodyDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The ratio of dilution of PrimaryAntibody.",
			Category -> "General"
		},
		SecondaryAntibody->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The antibody that binds to the primary antibody.",
			Category -> "General"
		},
		SecondaryAntibodyDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The ratio of dilution of SecondaryAntibody.",
			Category -> "General"
		},
		CoatingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of sample or antibody solution used in each ELISA Plate well to cover the well surface with analyte or antibody protein.",
			Category -> "General"
		},
		BlockingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of BlockingBuffer that is aliquoted into the appropriate wells of the assay plate, in order to prevent non-specific binding of molecules to the assay plate.",
			Category -> "General"
		},
		SampleAntibodyComplexImmunosorbentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the SampleAntibodyComplex to be loaded on each well of the ELISA Plate.",
			Category -> "General"
		},
		SampleImmunosorbentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Sample to be loaded on the ELISA Plate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
			Category -> "General"
		},
		PrimaryAntibodyImmunosorbentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Primary Antibody to be loaded on the ELISA Plate for immunosordent assay.",
			Category -> "General"
		},
		SecondaryAntibodyImmunosorbentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the Secondary Antibody to be loaded on the ELISA Plate for immunosordent assay.",
			Category -> "General"
		},
		SubstrateSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"Defines the substrate solution to the enzyme conjugated to the antibody.",
			Category -> "General"
		},
		SubstrateSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of substrate to be added to the corresponding well.",
			Category -> "General"
		},
		StopSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The reagent that is used to stop the reaction between the enzyme and its substrate.",
			Category -> "General"
		},
		StopSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of StopSolution to be added to the corresponding well.",
			Category -> "General"
		},
		DetectionAntibody->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The detection antibody sample used to incubate with analytes through specific antigen-antibody interaction after their binding with capture antibody to provide detection attachment sites for signal generation.",
			Category -> "General"
		},
		Diluent->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is used to mix with the sample to make the dilution series.",
			Category -> "General"
		},
		DilutionFactors->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The dilution factors of all the dilutions made on the sample to prepare the loading samples for ELISA experiment. Each dilution factor indicates one diluted sample analyzed in the ELISA experiment, with a concentration ratio of the dilution factor compared to the initial sample (plus SpikeSample, if applicable). For example, a dilution factor of 0.5 means that the sample is diluted to half concentration of the original sample.",
			Category -> "General"
		},
		SpikeSample->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The spike sample with known concentration(s) of analyte(s) mixed with the unknown sample to increase the concentration of the analyte(s) before any further dilution is performed.",
			Category->"Sample Preparation"
		},
		InitialSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The starting volume of the input sample taken out of the original container. If SpikeSample is added, InitialSampleVolume of the input sample is mixed with SpikeVolume of SpikeSample before further dilution is performed.",
			Category->"Sample Preparation"
		},
		SpikeVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The volume of the SpikeSample mixed with the InitialSampleVolume of the input sample before further dilution is performed.",
			Category->"Sample Preparation"
		},
		SpikeDilutionFactor->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,1],
			Description->"The rate of dilution of spike in samples.",
			Category->"Sample Preparation"
		},
		StandardData->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Data,ELISA]],
			Relation->Object[Data,ELISA][SampleData],
			Description->"The ELISA data of standard sample(s) with known concentration(s) of the analyte(s) associated with this sample data.",
			Category->"Experimental Results"
		},
		SampleData->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Data,ELISA]],
			Relation-> Alternatives[
				Object[Data,ELISA][StandardData]
			],
			Description->"Any ELISA data for unknown samples associated with this standard data.",
			Category->"Experimental Results"
		},
		PrereadData->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Data,ELISA]],
			Relation->Object[Data,ELISA][FinalData],
			Description->"Any preread ELISA data for unknown samples associated with this data.",
			Category->"Experimental Results"
		},
		FinalData->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Data,ELISA]],
			Relation->Object[Data,ELISA][PrereadData],
			Description->"Any final (after quenched by StopSolution) ELISA data for unknown samples associated with this data.",
			Category->"Experimental Results"
		},
		BackgroundIntensities->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*RFU],
			Units->RFU,
			Description->"For each member of DilutionFactors, the baseline signal detected by the instrument when no sample is presented. The BackgroundIntensities is subtracted from the measured sample signals to calculate Intensities.",
			Category->"Data Processing",
			IndexMatching->DilutionFactors
		},
		MultiplexBackgroundIntensities->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{ObjectP[Model[Molecule]],{GreaterEqualP[0*RFU]..}},
			Relation->{Model[Molecule],Null},
			Description->"For each analyte and each diluted sample, the baseline signal detected by the instrument when no sample is presented. The MultiplexBackgroundIntensities is subtracted from the measured sample signals to calculate MultiplexIntensities.",
			Headers->{"Analyte","Background Intensities"},
			Category->"Data Processing"
		},
		DetectorRangeExceeded->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of DilutionFactors, indicates if the measured intensity of the sample is out of the detector's detection range.",
			Category->"Data Processing",
			IndexMatching->DilutionFactors
		},
		MultiplexDetectorRangeExceeded->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{ObjectP[Model[Molecule]],{BooleanP..}},
			Relation->{Model[Molecule],Null},
			Description->"For each analyte and each diluted sample, indicates if the measured intensities of the sample is out of the detector's detection range.",
			Headers->{"Analyte","Detector Range Exceeded?"},
			Category->"Data Processing"
		},
		Intensities->{
			Format->Multiple,
			Class->Expression,
			Pattern:>DistributionP[RFU],
			Description->"For each member of DilutionFactors, the signal detected for the sample in its internal replicate runs. BackgroundIntensities is subtracted from the raw measurements to get Intensities.",
			Category->"Experimental Results",
			IndexMatching->DilutionFactors
		},
		MultiplexIntensities->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{ObjectP[Model[Molecule]],{DistributionP[RFU]..}},
			Relation->{Model[Molecule],Null},
			Description->"For each analyte and each diluted sample, the signal detected for the sample in its internal replicate runs. MultiplexBackgroundIntensities is subtracted from the raw measurements to get MultiplexIntensities.",
			Headers->{"Analyte","Intensities"},
			Category->"Experimental Results"
		},
		AbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Primary monochromator or filter wavelength used to filter lamp light before passing through the ELISA plates.",
			Category -> "General"
		},
		SecondaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Secondary monochromator or filter wavelength used to filter lamp light before passing through the ELISA plates.",
			Category -> "General"
		},
		TertiaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Tertiary monochromotor or filter wavelength used to filter lamp light before passing through the ELISA plates.",
			Category -> "General"
		},
		QuaternaryAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "Quaternary monochromotor or filter wavelength used to filter lamp light before passing through the ELISA plates.",
			Category -> "General"
		},
		Absorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at AbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		SecondaryAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at SecondaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		TertiaryAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at TertiaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		QuaternaryAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at QuaternaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		ReferenceAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at 605 nm together with AbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		SecondaryReferenceAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at at 605 nm together with SecondaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		TertiaryReferenceAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at at 605 nm together with QuaternaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		QuaternaryReferenceAbsorbances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[-1.0],
			Description -> "The absorbance measured at at 605 nm together with TertiaryAbsorbanceWavelength.",
			Category -> "Experimental Results"
		},
		StandardCompositions->{
			Format->Multiple,
			Class->{Link,Real},
			Pattern:>{ObjectP[Model[Molecule]],GreaterEqualP[0Picogram/Milliliter]},
			Relation->{Model[Molecule],Null},
			Units->{None,Picogram/Milliliter},
			Description->"For a standard sample, the known concentration(s) of the analyte(s) before dilution.",
			Headers->{"Analyte","Concentration"},
			Category->"Data Processing"
		},
		SpikeConcentrations->{
			Format->Multiple,
			Class->{Link,Real},
			Pattern:>{ObjectP[Model[Molecule]],GreaterEqualP[0Picogram/Milliliter]},
			Relation->{Model[Molecule],Null},
			Units->{None,Picogram/Milliliter},
			Description->"The known concentration(s) of analyte(s) in the SpikeSample mixed with the input sample before any dilution.",
			Headers->{"Analyte","Concentration"},
			Category->"Data Processing"
		},
		StandardCurveFunctions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>_QuantityFunction,
			Description->"For each analyte, the standard curve functions used to convert measured Intensities or MultiplexIntensities in RFU into AssayConcentrations or MultiplexAssayConcentrations in Picogram/Milliliter.",
			Category->"Data Processing"
		},

		(* TODO Fill in Analysis subtype when the function is ready! *)
		(*
		CompositionAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Composition analyses conducted on this ELISA data to quantify the concentrations of analytes in the input sample.",
			Category->"Analysis & Reports"
		},
		*)

		AssayConcentrations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>DistributionP[Picogram/Milliliter],
			Description->"For each member of DilutionFactors, the concentration of the diluted sample calculated using StandardCurve.",
			Category->"Analysis & Reports",
			IndexMatching->DilutionFactors
		},
		MultiplexAssayConcentrations->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{ObjectP[Model[Molecule]],{DistributionP[Picogram/Milliliter]..}},
			Relation->{Model[Molecule],Null},
			Description->"For each analyte and each diluted sample, the concentration of the sample calculated using MultiplexStandardCurves.",
			Headers->{"Analyte","Assay Concentrations"},
			Category->"Analysis & Reports"
		},
		Concentrations->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{ObjectP[Model[Molecule]],DistributionP[Picogram/Milliliter]},
			Relation->{Model[Molecule],Null},
			Description->"The concentration of the target analytes in the original sample. This value is calculated by linear fitting of data from AssayConcentrations or MultiplexAssayConcentrations of the diluted samples, minus SpikeConcentrations.",
			Headers->{"Analyte","Concentration"},
			Category->"Analysis & Reports"
		}

	}
}];