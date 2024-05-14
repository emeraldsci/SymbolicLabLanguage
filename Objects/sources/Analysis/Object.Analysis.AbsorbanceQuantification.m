(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, AbsorbanceQuantification], {
	Description->"The calculation of sample concentration using Beer's Law along with absorbance and volume measurements and calculated extinction coefficients.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample][QuantificationAnalyses],
			Description -> "The samples that are being quantified by the analysis.",
			Category -> "General"
		},
		Analyte -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "The specific substance that is quantified by the analysis.",
			Category -> "Analysis & Reports"
		},
		SampleDilution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The amount of dilution (i.e. x-fold dilution) that aliquots of the SamplesIn underwent to generate the AbsorbanceSpectra.",
			Category -> "General",
			Abstract -> True
		},
		SampleDilutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The amount of dilution (i.e. x-fold dilution) that aliquots of the SamplesIn underwent to generate the AbsorbanceSpectra, with different dilution factors.",
			Category -> "General",
			Abstract -> True
		},
		MinRamanScattering -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The minimum raman scattering distance where the calibrations are being done.",
			Category -> "General"
		},
		MaxRamanScattering -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Nano,
			Description -> "The maximum raman scattering distance where the calibrations are being done.",
			Category -> "General"
		},
		Concentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?ConcentrationQ,
			Units -> Micromolar,
			Description -> "Concentration of the SamplesIn as calculated using beers law the ExtinctionCoefficent, and the AbsorbanceSpectra.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		ConcentrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "Unbiased standard deviation of concentration measurements of the SamplesIn.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		ConcentrationDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Micromolar],
			Description -> "Distribution of concentration measurements of the SamplesIn.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		MassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "The most recently calculated mass of the constituent(s) divided by the volume of the mixture.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		MassConcentrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "Unbiased standard deviation of mass concentration measurements of the SamplesIn.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		MassConcentrationDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram/Liter],
			Description -> "Distribution of mass concentration measurements of the SamplesIn.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?ConcentrationQ,
			Units -> Micromolar,
			Description -> "Calculated concentration of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedConcentrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "Unbiased standard deviation of concentration measurements of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedConcentrationDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Micromolar],
			Description -> "Distribution of concentration measurements of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedMassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "Calculated mass concentration of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedMassConcentrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "Unbiased standard deviation of mass concentration measurements of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		DilutedMassConcentrationDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram/Liter],
			Description -> "Distribution of mass concentration measurements of the sample after dilution.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		PathLength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The distance that the path of light from the plate reader had to travel to traverse through the sample in the plate.",
			Category -> "Analysis & Reports"
		},
		PathLengthMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PathLengthMethodP,
			Description -> "The method by which the path length from the plate reader to the sample in the read plate was determined.",
			Category -> "Analysis & Reports"
		},
		AbsorbanceSpectra -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, AbsorbanceSpectroscopy][QuantificationAnalyses],
				Object[Data, AbsorbanceIntensity][QuantificationAnalyses]
			],
			Description -> "Absorbance spectroscopy data for the samples after dilution.",
			Category -> "Data Processing"
		},
		AbsorbanceSpectraEmpty -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, AbsorbanceSpectroscopy][QuantificationAnalyses],
			Description -> "Absorbance spectroscopy data for the empty wells before sample transfer.",
			Category -> "Data Processing"
		},
		AbsorbanceSpectraBlank -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, AbsorbanceSpectroscopy][QuantificationAnalyses],
			Description -> "Absorbance spectroscopy data for the wells containing only buffer before sample transfer.",
			Category -> "Data Processing"
		},
		LinearRangeWarning -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if all the measured absorbance data are out of the recommended linear range. True means they are out of range, otherwise it's False.",
			Category -> "Analysis & Reports"
		},
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,AbsorbanceQuantification][QuantificationAnalyses],
				Object[Protocol,AbsorbanceSpectroscopy][QuantificationAnalyses],
				Object[Protocol,AbsorbanceIntensity][QuantificationAnalyses]
			],
			Description -> "The protocol associated with this analysis.",
			Category -> "Analysis & Reports"
		}
	}
}];
