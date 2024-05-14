(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,SupercriticalFluidChromatography], {
	Description->"A protocol that verifies the functionality of the SFC target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of QualificationSamples, the volume injected by the instrument.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,SupercriticalFluidGradient],
			Description -> "For each member of QualificationSamples, the gradient conditions used to run the sample on the instrument.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		TransitionedGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,SupercriticalFluidGradient],
			Description -> "For each member of QualificationSamples, the gradient conditions used to run the sample, including smooth transitions from one gradient to the next.",
			IndexMatching -> QualificationSamples,
			Developer -> True,
			Category -> "General"
		},
		AbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nano Meter],
			Units -> Nanometer,
			Description -> "For each member of QualificationSamples, the wavelength at which to detect absorbance in the instrument flow cell.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		MassSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Nano Meter]..},
			Description -> "For each member of QualificationSamples, the specific m/z list to measure via mass spectrometry.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		FractionCollectionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,FractionCollection],
			Description -> "For each member of QualificationSamples, the fraction collection parameters used for any samples that require fraction collection.",
			Category -> "General",
			IndexMatching -> QualificationSamples
		},
		FractionAbsorbanceProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol run to confirm the presence of analytes in collected fractions.",
			Category -> "General"
		},
		FlowLinearityTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, FlowRate -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, FlowRate -> GreaterEqualP[0*Milliliter/Minute], Data -> _Link},
			Units -> {Sample -> None, FlowRate -> Milliliter/Minute, Data -> None},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), FlowRate -> Null, Data -> Object[Data,ChromatographyMassSpectra]},
			Description -> "The samples, flow rates, and data used for testing the instrument's pump.",
			Category -> "General"
		},
		AutosamplerTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, InjectionVolume -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, InjectionVolume -> GreaterEqualP[0*Microliter], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), InjectionVolume -> Null, Data -> Object[Data,ChromatographyMassSpectra]},
			Units -> {Sample -> None, InjectionVolume -> Microliter, Data -> None},
			Description -> "The samples, injeciton volumes, and data used for testing the instrument's autosampler.",
			Category -> "General"
		},
		WavelengthAccuracyTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, Wavelength -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, Wavelength -> GreaterEqualP[0*Nanometer], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), Wavelength -> Null, Data -> Object[Data,ChromatographyMassSpectra]},
			Units -> {Sample -> None, Wavelength -> Nanometer, Data -> None},
			Description -> "The samples, detection wavelengths, and data used for testing the accuracy of the instrument's absorbance detector.",
			Category -> "General"
		},
		MassAccuracyTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, Mass -> Real, SecondaryMass -> Real, TertiaryMass -> Real, QuaternaryMass -> Real, QuinaryMass -> Real, Data -> Link},
			Pattern :> {Sample -> _Link, Mass -> GreaterEqualP[0*Dalton], SecondaryMass -> GreaterEqualP[0*Dalton], TertiaryMass -> GreaterEqualP[0*Dalton], QuaternaryMass -> GreaterEqualP[0*Dalton], QuinaryMass -> GreaterEqualP[0*Dalton], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), Mass -> Null, SecondaryMass -> Null, TertiaryMass -> Null, QuaternaryMass -> Null, QuinaryMass -> Null, Data -> Object[Data,ChromatographyMassSpectra]},
			Units -> {Sample -> None, Mass -> Dalton, SecondaryMass -> Dalton, TertiaryMass -> Dalton, QuaternaryMass -> Dalton, QuinaryMass -> Dalton, Data -> None},
			Description -> "The samples, detection m/z, and data used for testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "General"
		},
		GradientProportioningTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, CosolventA -> Real, CosolventB -> Real, CosolventC -> Real, CosolventD -> Real, Data -> Link},
			Pattern :> {Sample -> _Link,  CosolventA -> RangeP[0*Percent, 100*Percent], CosolventB -> RangeP[0*Percent, 100*Percent], CosolventC -> RangeP[0*Percent, 100*Percent], CosolventD -> RangeP[0*Percent, 100*Percent], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), CosolventA -> Null, CosolventB -> Null, CosolventC -> Null, CosolventD -> Null,  Data -> Object[Data,ChromatographyMassSpectra]},
			Units -> {Sample -> None, CosolventA -> Percent, CosolventB -> Percent, CosolventC -> Percent, CosolventD -> Percent, Data -> None},
			Description -> "The samples, Cosolvent composition {%A, %B, %C, %D}, and data used for testing the instrument's proportioning valves.",
			Category -> "General"
		},
		DetectorLinearityTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, DilutionFactor-> Real, Data -> Link},
			Pattern :> {Sample -> _Link, DilutionFactor -> RangeP[0,1], Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), DilutionFactor -> Null, Data -> Object[Data,ChromatographyMassSpectra]},
			Description -> "The samples, dilution factors, and data used for testing the linearity of the instrument's detector.",
			Category -> "General"
		},
		FractionCollectionTests -> {
			Format -> Multiple,
			Class -> {Sample -> Link, FractionCollectionMethod -> Link, Data -> Link},
			Pattern :> {Sample -> _Link,  FractionCollectionMethod -> _Link, Data -> _Link},
			Relation -> {Sample -> (Object[Sample]|Model[Sample]), FractionCollectionMethod -> Object[Method,FractionCollection], Data -> Object[Data,ChromatographyMassSpectra]},
			Description -> "The samples, fraction collection methods and data used for testing the linearity of the instrument's detector.",
			Category -> "General"
		},
		
		(* Sample Preparation *)
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the test samples.",
			Category -> "Sample Preparation"
		},
		SamplePreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to generate the test samples.",
			Category -> "Sample Preparation"
		},
		SampleWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The list of sample wells that will be injected from.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		
		(* Experimental Results *)
		DetectorResponsePeaksAnalyses -> {
			Format -> Multiple,
			Class -> {DilutionFactor -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, PeakAreaDistribution -> Expression},
			Pattern :> {DilutionFactor -> GreaterP[0], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], PeakAreaDistribution -> DistributionP[]},
			Description -> "The peak area distribution for each set of injections of a certain dilution.",
			Category -> "Experimental Results"
		},
		DetectorResponseFactorResults -> {
			Format -> Single,
			Class -> {Expression, Real, Real, Boolean},
			Pattern :> {DistributionP[], GreaterP[0 Percent], GreaterP[0 Percent],BooleanP},
			Units -> {None, Percent, Percent, None},
			Headers -> {"Detector Response Distribution","%RSD","Max %RSD","Passing"},
			Description -> "The distribution of response factors (peak area/dilution factor) from detector linearity tests and whether it's %RSD meets the passing criterion.",
			Category -> "Experimental Results"
		},
		DetectorLinearityResults -> {
			Format -> Single,
			Class -> {Real, Real, Boolean},
			Pattern :> {RangeP[0,1], RangeP[0,1], BooleanP},
			Headers -> {"Correlation Coefficient","Min Correlation Coefficient","Passing"},
			Description -> "The correlation coefficient for the fit of peak areas versus sample dilutions and whether it meets the passing criterion.",
			Category -> "Experimental Results"
		},
		WavelengthAccuracyPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {Wavelength -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, PeakAreaDistribution -> Expression},
			Pattern :> {Wavelength -> GreaterP[0*Nanometer], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], PeakAreaDistribution -> DistributionP[]},
			Units -> {Wavelength -> Nanometer, SamplesAnalyzed -> None, SamplesExcluded -> None, PeakAreaDistribution -> None},
			Description -> "The peak area distribution for each set of injections measured at varying wavelengths.",
			Category -> "Experimental Results"
		},
		WavelengthAccuracyTestResults -> {
			Format -> Multiple,
			Class -> {ExpectedPeakWavelength -> Real, MeasuredPeakWavelength -> Real, Passing -> Boolean},
			Pattern :> {ExpectedPeakWavelength -> GreaterP[0*Nanometer], MeasuredPeakWavelength -> GreaterP[0*Nanometer], Passing -> BooleanP},
			Units -> {ExpectedPeakWavelength -> Nanometer, MeasuredPeakWavelength -> Nanometer, Passing -> None},
			Description -> "Expected and measured peak absorbance wavelengths and whether the measured values are within passing criteria.",
			Category -> "Experimental Results"
		},
		MassAccuracyPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {Mass -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, PeakAreaDistribution -> Expression},
			Pattern :> {Mass -> GreaterP[0*Dalton], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], PeakAreaDistribution -> DistributionP[]},
			Units -> {Mass -> Dalton, SamplesAnalyzed -> None, SamplesExcluded -> None, PeakAreaDistribution -> None},
			Description -> "The peak area distribution for each set of injections measured at varying m/z.",
			Category -> "Experimental Results"
		},
		MassAccuracyTestResults -> {
			Format -> Multiple,
			Class -> {ExpectedPeakWavelength -> Real, MeasuredPeakMass -> Real, Passing -> Boolean},
			Pattern :> {ExpectedPeakWavelength -> GreaterP[0*Dalton], MeasuredPeakMass -> GreaterP[0*Dalton], Passing -> BooleanP},
			Units -> {ExpectedPeakWavelength -> Dalton, MeasuredPeakMass -> Dalton, Passing -> None},
			Description -> "Expected and measured peak m/z and whether the measured values are within passing criteria.",
			Category -> "Experimental Results"
		},
		InjectionPrecisionPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {InjectionVolume -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, PeakAreaDistribution -> Expression},
			Pattern :> {InjectionVolume -> GreaterP[0 Microliter], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], PeakAreaDistribution -> DistributionP[]},
			Units -> {InjectionVolume -> Microliter, SamplesAnalyzed -> None, SamplesExcluded -> None, PeakAreaDistribution -> None},
			Description -> "The peak area distributions for each set of injections of a certain injection volume.",
			Category -> "Experimental Results"
		},
		MaxInjectionPrecisionPeakAreaRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "When testing autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections.",
			Category -> "Experimental Results"
		},
		InjectionPrecisionPassing -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether or not the measured injection precision passes acceptance criteria.",
			Category -> "Experimental Results"
		},
		FlowRatePrecisionPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {InjectionVolume -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, RetentionTimeDistribution -> Expression},
			Pattern :> {InjectionVolume -> GreaterP[0 Microliter], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], RetentionTimeDistribution -> DistributionP[]},
			Units -> {InjectionVolume -> Microliter, SamplesAnalyzed -> None, SamplesExcluded -> None, RetentionTimeDistribution -> None},
			Description -> "The peak retention time distribution for each set of injections of a certain injection volume.",
			Category -> "Experimental Results"
		},
		MaxFlowPrecisionRetentionRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
			Category -> "Experimental Results"
		},
		FlowRatePrecisionPassing -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether or not the measured flow rate precision passes acceptance criteria.",
			Category -> "Experimental Results"
		},
		FlowLinearityPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {FlowRate -> Real, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, RetentionTimeDistribution -> Expression},
			Pattern :> {FlowRate -> GreaterP[0 Milliliter/Minute], SamplesAnalyzed -> GreaterEqualP[0,1], SamplesExcluded -> GreaterEqualP[0,1], RetentionTimeDistribution -> DistributionP[]},
			Units -> {FlowRate -> Milliliter/Minute, SamplesAnalyzed -> None, SamplesExcluded -> None, RetentionTimeDistribution -> None},
			Description -> "The peak retention time distributions for each set of injections at a certain flow rate.",
			Category -> "Experimental Results"
		},
		FlowLinearityTestResults -> {
			Format -> Single,
			Class -> {Real, Real, Boolean},
			Pattern :> {RangeP[0,1],RangeP[0,1],BooleanP},
			Description -> "The correlation coefficient for the fit of 1/retention time versus flow rate and whether it meets the passing criterion.",
			Headers -> {"Correlation Coefficient","Min Correlation Coefficient","Passing"},
			Category -> "Experimental Results"
		},
		FlowRateAccuracyTestResults -> {
			Format -> Single,
			Class -> {Real, Real, Boolean},
			Pattern :> {_?QuantityQ, GreaterP[0 Milliliter/Minute], BooleanP},
			Units -> {Milliliter/Minute, Milliliter/Minute, None},
			Description -> "The measured flow rate error and whether it meets the passing criterion.",
			Headers -> {"Flow Rate Error", "Max Flow Rate Error", "Passing"},
			Category -> "Experimental Results"
		},
		GradientProportioningPeaksAnalyses -> {
			Format -> Multiple,
			Class -> {BufferComposition -> Expression, SamplesAnalyzed -> Integer, SamplesExcluded -> Integer, RetentionTimeDistribution -> Expression},
			Pattern :> {
				BufferComposition -> {RangeP[0*Percent, 100*Percent], RangeP[0*Percent, 100*Percent], RangeP[0*Percent, 100*Percent], RangeP[0*Percent, 100*Percent]},
				SamplesAnalyzed -> GreaterEqualP[0,1],
				SamplesExcluded -> GreaterEqualP[0,1],
				RetentionTimeDistribution -> DistributionP[]
			},
			Description -> "The peak retention time distributions for each set of injections run with a certain buffer composition.",
			Category -> "Experimental Results"
		},
		GradientProportioningTestResults -> {
			Format -> Single,
			Class -> {Real, Real, Boolean},
			Pattern :> {GreaterEqualP[0 Percent],GreaterP[0 Percent], BooleanP},
			Description -> "The percent relative standard deviation of retention times and whether or not it meets the passing criterion.",
			Units -> {Percent, Percent, None},
			Headers -> {"Measured %RSD", "Max %RSD", "Passing"},
			Category -> "Experimental Results"
		},
		MinAbsorbance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 AbsorbanceUnit],
			Units -> AbsorbanceUnit,
			Description -> "The minimum allowable absorbance of fractions to be considered successfully collected.",
			Category -> "Experimental Results"
		},
		FractionCollectionTestResults -> {
			Format -> Multiple,
			Class -> {Chromatogram -> Link, AbsorbanceSpectrum -> Link, FractionCollectionMode -> Expression, Absorbance -> Real, Passing -> Boolean},
			Pattern :> {Chromatogram -> _Link, AbsorbanceSpectrum -> _Link, FractionCollectionMode -> FractionCollectionModeP, Absorbance -> AbsorbanceUnitP, Passing -> BooleanP},
			Units -> {Chromatogram -> None, AbsorbanceSpectrum -> None, FractionCollectionMode -> None, Absorbance -> AbsorbanceUnit, Passing -> None},
			Relation -> {Chromatogram -> Object[Data,ChromatographyMassSpectra], AbsorbanceSpectrum -> Object[Data,AbsorbanceSpectroscopy], FractionCollectionMode -> Null, Absorbance -> Null, Passing -> Null},
			Description -> "The fraction collection mode, fraction absorbance, and whether or not it meets the passing criterion.",
			Category -> "Experimental Results"
		}
	}
}];
