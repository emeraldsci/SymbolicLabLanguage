(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, TotalProteinQuantification], {
	Description->"Analysis of absorbance data from a total protein quantification assay conducted on lysate samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples for which the total protein concentration is being quantified.",
			Category -> "General"
		},
		AssaySamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of SamplesIn, the samples (SamplesIn or diluted input samples) which are mixed with the QuantificationReagent in the QuantificationPlate.",
			IndexMatching->SamplesIn,
			Category -> "General"
		},
		AssaySamplesDilutionFactors->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0,1],
			IndexMatching->AssaySamples,
			Description->"For each member of AssaySamples, a measure of the portion of the AssaySample that is comprised of the SampleIn (the ratio of AliquotVolume to the AssayVolume of the SamplePrep Aliquot step). For example, an AssaySampleDilutionFactor of 0.02 indicates that the SampleIn was diluted 50-fold to create the AssaySample.",
			Category -> "General"
		},
		LoadingVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of each AssaySample, ProteinStandard, or diluted ConcentratedProteinStandard that is mixed with the QuantificationReagent in the QuantificationPlate before the absorbance or fluorescence of the mixture at the QuantificationWavelength is determined.",
			Category -> "General"
		},
		QuantificationReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The sample that is added to the ProteinStandards (or diluted ConcentratedProteinStandard) and AssaySamples in the QuantificationPlate. The QuantificationReagent undergoes a change in absorbance and/or fluorescence in the presence of proteins. This change in absorbance or fluorescence is used to quantify the amount of protein present in the input samples and ProteinStandards.",
			Category -> "General"
		},
		QuantificationReagentVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Microliter],
			Units->Microliter,
			Description->"The amount of the QuantificationReagent that is added to each appropriate well of the QuantificationPlate. The QuantificationReagent is mixed with either the AssaySamples or the ProteinStandards (or diluted ConcentratedProteinStandard) in the QuantificationPlate.",
			Category -> "General"
		},
		StandardCurveConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Milligram)/Milliliter],
			Units->Milligram/Milliliter,
			Description->"The mass concentrations of the standard samples used to create the standard curve. The standard concentration curve plotting Absorbance or Fluorescence versus mass concentration is used to determine the protein concentration of the input samples.",
			Category -> "General"
		},
		StandardCurveReplicates->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Description->"The number of wells that each concentration of ProteinStandards (or diluted ConcentratedProteinStandard) and the StandardCurveBlank is added to in the QuantificationPlate. The StandardCurve is calculated by averaging the absorbance or fluorescence values of the protein standards at each concentration and plotting that average value versus the MassConcentration.",
			Category -> "General"
		},
		ExcitationWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The wavelength of light at which the protein-bound QuantificationReagent is excited.",
			Category -> "General"
		},
		QuantificationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"The wavelength(s) at which quantification analysis is performed to determine concentration.",
			Category -> "General"
		},
		QuantificationStandards->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The mixtures of QuantificationReagent and StandardCurveBlank and ProteinStandards (or dilute ConcentratedProteinStandard) in the QuantificationPlate whose absorbance or fluorescence values are used to create the StandardCurve.",
			Category -> "General"
		},
		QuantificationSamples->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of AssaySamples, the mixture of AssaySample and QuantificationReagent in the QuantificationPlate whose absorbance or fluorescence value is used to calculate the AssaySamplesProteinConcentrations and the SamplesInProteinConcentrations from the StandardCurve.",
			Category -> "General",
			IndexMatching->AssaySamples
		},
		StandardCurve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Fit][PredictedValues],
			Description -> "Standard curve fitting analysis characterizing the relationship between concentration and either absorbance or fluorescence.",
			Category -> "Analysis & Reports"
		},
		QuantifiableOnStandardCurve -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the absorbance or fluorescence measurement is inside of the quantifiable range of the Standard Curve, and therefore the total protein quantification analysis can be performed.",
			IndexMatching->SamplesIn,
			Category -> "Analysis & Reports"
		},
		AssaySamplesProteinConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Milligram)/Milliliter],
			Units->Milligram/Milliliter,
			Description->"For each member of AssaySamples, if the absorbance or fluorescence measurement is inside the quantifiable range of the Standard Curve, the protein concentration calculated from the corresponding absorbance or fluorescence value, and the StandardCurve.",
			IndexMatching->AssaySamples,
			Category -> "Analysis & Reports"
		},
		SamplesInConcentrationDistributions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>DistributionP[(Milligram/Milliliter)],
			Description->"For each member of SamplesIn, if the absorbance or fluorescence measurement is inside the quantifiable range of the Standard Curve, the statistical distribution of the protein concentrations calculated by this analysis.",
			IndexMatching->SamplesIn,
			Category -> "Analysis & Reports"
		},
		SamplesInProteinConcentrations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Milligram)/Milliliter],
			Units->Milligram/Milliliter,
			Description->"For each member of SamplesIn, if the absorbance or fluorescence measurement is inside the quantifiable range of the Standard Curve, the protein concentration of the corresponding AssaySample divided by the AssaySampleDilutionFactor.",
			IndexMatching->SamplesIn,
			Category -> "Analysis & Reports"
		},
		StandardsSpectroscopyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The spectroscopy data obtained from the mixtures of QuantificationReagent and standard samples (StandardCurveBlank and either ProteinStandards or diluted ConcentratedProteinStandard).",
			Category -> "Analysis & Reports"
		},
		InputSamplesSpectroscopyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of QuantificationSamples, the spectroscopy data obtained from the mixtures of QuantificationReagent and AssaySamples.",
			IndexMatching->QuantificationSamples,
			Category -> "Analysis & Reports"
		}
	}
}];
