

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, TotalProteinQuantification], {
	Description->"A protocol for quantifying aggregate cellular protein samples using a colorimetric assay.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AssayType->{
			Format->Single,
			Class->Expression,
			Pattern:>ProteinQuantificationAssayTypeP,
			Description->"The style of protein quantification assay that is run in this experiment. The Bradford assay is an absorbance-based assay that relates changes in Coomassie Brilliant Blue G-250 absorbance at the QuantificationWavelength to protein concentration. The BCA (Smith bicinchoninic acid) assay is an absorbance-based assay which relates changes in the absorbance of a copper-BCA complex at the QuantificationWavelength to protein concentration. The FluorescenceQuantification assay relates increase in fluorescence of the QuantificationReagent at the QuantificationWavelength to protein concentration.",
			Category -> "General",
			Abstract->True
		},
		DetectionMode->{
			Format->Single,
			Class->Expression,
			Pattern:>ProteinQuantificationDetectionModeP,
			Description->"The physical phenomenon that is observed as the source of the signal for protein quantification in this experiment.",
			Category -> "General",
			Abstract->True
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,PlateReader]|Model[Instrument,PlateReader],
			Description->"The plate reader used to measure the absorbance or fluorescence of the mixture of QuantificationReagent and either the input samples or ProteinStandards (or diluted ConcentratedProteinStandard) present in the QuantificationPlate.",
			Category -> "General"
		},
		ProteinStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The solutions of standard protein that are mixed with the QuantificationReagent in lieu of the input samples to create the standard curve. The standard concentration curve plotting Absorbance or Fluorescence versus mass concentration is used to determine the protein concentration of the input samples.",
			Category->"Standard Curve"
		},
		ConcentratedProteinStandard->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The concentrated solution of standard protein that is diluted with the ProteinStandardDiluent to the StandardCurveConcentrations to create the standard curve.",
			Category->"Standard Curve"
		},
		StandardCurveConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Milligram)/Milliliter],
			Units->Milligram/Milliliter,
			Description->"Either the mass concentrations of the StandardCurveBlank and the ProteinStandards, or the mass concentrations of the StandardCurveBlank and the mass concentrations that the ConcentratedProteinStandard is diluted to with the ProteinStandardDiluent to create the standard curve. The standard concentration curve plotting Absorbance or Fluorescence versus mass concentration is used to determine the protein concentration of the input samples.",
			Category->"Standard Curve"
		},
		ConcentratedProteinStandardVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of ConcentratedProteinStandard that is transferred to each appropriate well of the StandardDilutionPlate and mixed with the ProteinStandardDiluent.",
			Category->"Standard Curve"
		},
		ProteinStandardDiluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is used to dilute the ConcentratedProteinStandard to the StandardCurveConcentrations in the StandardDilutionPlate.",
			Category->"Standard Curve"
		},
		ProteinStandardDiluentVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"For each member of ConcentratedProteinStandardVolumes, the amount of ProteinStandardDiluent that is transferred to each appropriate well of the StandardDilutionPlate and mixed with the ConcentratedProteinStandard.",
			IndexMatching->ConcentratedProteinStandardVolumes,
			Category->"Standard Curve"
		},
		StandardCurveBlank->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that is used for the required 0 mg/mL point on the standard curve.",
			Category->"Standard Curve"
		},
		StandardDilutionPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate] | Model[Container,Plate],
			Description->"The plate in which the ConcentratedProteinStandard is diluted with the ProteinStandardDiluent to the StandardCurveConcentrations.",
			Category->"Standard Curve"
		},
		StandardDilutionPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description -> "A set of instructions specifying the loading and mixing of the ConcentratedProteinStandard and the ProteinStandardDiluent in the StandardDilutionPlate.",
			Category -> "Standard Curve"
		},
		StandardDilutionPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"A sample manipulation protocol used to load the StandardDilutionPlate and mix its contents.",
			Category->"Standard Curve"
		},
		StandardCurveReplicates->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of wells that each concentration of ProteinStandards (or diluted ConcentratedProteinStandard) is added to in the QuantificationPlate. The StandardCurve is calculated by averaging the absorbance or fluorescence values of the protein standards at each concentration and plotting that average value versus the MassConcentration.",
			Category->"Standard Curve"
		},
		LoadingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of each input sample, ProteinStandard, or diluted ConcentratedProteinStandard that is mixed with the QuantificationReagent in the QuantificationPlate before the absorbance or fluorescence of the mixture at the QuantificationWavelength is determined.",
			Category->"Quantification"
		},
		QuantificationReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The sample that is added to the ProteinStandards (or diluted ConcentratedProteinStandard) and input samples in the QuantificationPlate. The QuantificationReagent undergoes a change in absorbance and/or fluorescence in the presence of proteins. This change in absorbance or fluorescence is used to quantify the amount of protein present in the input samples and ProteinStandards.",
			Category -> "Quantification"
		},
		QuantificationReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of the QuantificationReagent that is added to each appropriate well of the QuantificationPlate. The QuantificationReagent is mixed with either the input samples or the ProteinStandards (or diluted ConcentratedProteinStandard) in the QuantificationPlate.",
			Category->"Quantification"
		},
		QuantificationPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]|Model[Container],
			Description -> "The plate in which the QuantificationReagent is mixed with the ProteinStandards (or diluted ConcentratedProteinStandard) and the input samples. The absorbance or fluorescence of these mixtures is then read on the Instrument.",
			Category -> "Quantification"
		},
		QuantificationPlatePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleManipulationP,SamplePreparationP],
			Description -> "A set of instructions specifying the loading and mixing of the ProteinStandards (or diluted ConcentratedProteinStandard), input samples, and QuantificationReagent in the QuantificationPlate.",
			Category -> "Quantification"
		},
		QuantificationPlateManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol],Object[Notebook, Script]],
			Description->"The sample preparation used to load the QuantificationPlate and mix its contents.",
			Category->"Quantification"
		},
		QuantificationReactionTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration which the mixtures of QuantificationReagent and input samples or ProteinStandards (or diluted ConcentratedProteinStandard) are heated to QuantificationReactionTemperature before the absorbance or fluorescence of the mixture is measured.",
			Category->"Quantification"
		},
		QuantificationReactionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The temperature which the mixtures of QuantificationReagent and input samples or ProteinStandards (or diluted ConcentratedProteinStandard) are heated to before the absorbance or fluorescence of the mixture is measured.",
			Category->"Quantification"
		},
		QuantificationPlateIncubation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description->"An incubation protocol that performs the QuantificationReaction after the QuantificationPlate has been loaded in the QuantificationPlateManipulation and centrifuged.",
			Category->"Quantification"
		},
		ExcitationWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light at which the protein-bound QuantificationReagent is excited when DetectionMode is set to Fluorescence.",
			Category -> "Quantification"
		},
		EmissionWavelengthRange->{
			Format->Single,
			Class->Expression,
			Pattern:>_Span,
			Description->"Defines the wavelengths at which fluorescence emitted from the sample should be measured after the sample has been excited at 'ExcitationWavelength' when DetectionMode is set to Fluorescence.",
			Category -> "Quantification"
		},
		EmissionAdjustmentSample -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ObjectP[{Object[Sample],Model[Sample]}], FullPlate, HighestConcentration],
			Description -> "The sample used to determine the Gain percentage and focal height adjustments.",
			Category -> "Quantification"
		},
		QuantificationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The wavelength(s) at which quantification analysis is performed to determine concentration.",
			Category -> "Quantification"
		},
		QuantificationTemperature->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature of the sample chamber during the absorbance or fluorescence spectra measurement.",
			Category -> "Quantification"
		},
		QuantificationEquilibrationTime->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which the plates are incubated in the plate reader at QuantificationTemperature before absorbance or fluorescence measurements are made.",
			Category -> "Quantification"
		},
		NumberOfEmissionReadings->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of redundant readings which should be taken by the detector to determine a single averaged fluorescence intensity reading for each wavelength.",
			Category -> "Quantification"
		},
		EmissionReadLocation->{
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "Indicates if fluorescence is measured using an optic above the plate or one below the plate.",
			Category -> "Quantification"
		},
		EmissionGain->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The gain which is applied to the signal reaching the primary detector during the emission scan when DetectionMode is Fluorescence, measured as a percentage of the strongest signal in the QuantificationPlate.",
			Category -> "Quantification"
		},
		AdjustmentEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The emission wavelength within the QuantificationWavelengths used to determine the gain percentage, when DetectionMode is Fluorescence.",
			Category -> "Quantification",
			Abstract -> True
		},
		QuantificationSpectroscopyProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol, AbsorbanceSpectroscopy],Object[Protocol, FluorescenceSpectroscopy],Object[Protocol, RoboticSamplePreparation]],
			Description->"The Absorbance- or Fluorescence-Spectroscopy protocol performed on the QuantificationPlate.",
			Category->"Quantification"
		},
		SpectroscopyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Any primary data generated by the QuantificationSpectroscopyProtocol.",
			Category -> "Quantification"
		},
		StandardsSpectroscopyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The QuantificationSpectroscopyProtocol data obtained from the mixtures of QuantificationReagent and standard samples (StandardCurveBlank and either ProteinStandards or diluted ConcentratedProteinStandard).",
			Category -> "Quantification"
		},
		InputSamplesSpectroscopyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The QuantificationSpectroscopyProtocol data obtained from the mixtures of QuantificationReagent and input samples.",
			Category -> "Quantification"
		},
		QuantificationAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis][Reference],
			Description->"Analyses conducted to determine the protein concentration of the SamplesIn.",
			Category->"Analysis & Reports"
		},
		ProteinStandardsStorage -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of ProteinStandards, the storage conditions under which any protein standard samples used in this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		},
		ConcentratedProteinStandardStorage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which the concentrated protein standard sample used in this experiment should be stored after usage in this experiment.",
			Category -> "Sample Storage"
		}
	}
}];
