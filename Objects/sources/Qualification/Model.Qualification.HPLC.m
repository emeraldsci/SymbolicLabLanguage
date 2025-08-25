(* ::Package:: *)

DefineObjectType[Model[Qualification,HPLC], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an HPLC.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* Method Information *)
		Column ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The stationary phase column employed in this HPLC separation.",
			Category -> "General",
			Abstract -> True
		},
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The default wavelength to measure the absorbance of in the detector's flow cell.",
			Category -> "General"
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The Buffer A model used to generate the buffer gradient for the protocol.",
			Category -> "General",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The Buffer B model used to generate the buffer gradient for the protocol.",
			Category -> "General",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The Buffer C model used to generate the buffer gradient for the protocol.",
			Category -> "General",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The Buffer D model used to generate the buffer gradient for the protocol.",
			Category -> "General",
			Abstract -> True
		},
		ColumnPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used for column primes.",
			Category -> "General"
		},
		ColumnFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The buffer gradient used for column flushes.",
			Category -> "General"
		},

		(* Flow linearity *)
		FlowLinearityTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the HPLC's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradients to run when testing the HPLC's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the HPLC's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the HPLC's pump.",
			Category -> "Flow Linearity Test"
		},
		MinFlowLinearityCorrelation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "When testing flow rate linearity, the minimum acceptable correlation coefficient for the fit of 1/retention time vs. flow rate.",
			Category -> "Flow Linearity Test"
		},
		MaxFlowRateError -> {
			Format -> Single,
			Class -> Real,
			Units -> Milliliter/Minute,
			Pattern :> GreaterP[0],
			Description -> "When determining flow rate accuracy, the maximum acceptable absolute value of the x-intercept for the fit of 1/retention time vs. flow rate.",
			Category -> "Flow Linearity Test"
		},

		(* Autosampler *)
		AutosamplerTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the HPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the HPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerInjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volumes of sample to inject when testing the HPLC's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerReplicates -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "For each member of AutosamplerInjectionVolumes, the number of replicate injections to run.",
			Category -> "Autosampler Test"
		},
		MaxInjectionPrecisionPeakAreaRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "When testing autosampler injection precision, the maximum acceptable percent relative standard deviation of peak areas for replicate injections.",
			Category -> "Autosampler Test"
		},
		MaxFlowPrecisionRetentionRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing flow rate precision, the maximum acceptable percent relative standard deviation of peak retention times for replicate injections.",
			Category -> "Autosampler Test"
		},
		MinInjectionLinearityCorrelation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "When testing injection volume linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. injection volume.",
			Category -> "Autosampler Test"
		},
		MaxInjectionVolumeError -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Microliter,
			Description -> "When testing the injection volume accuracy of the autosampler, the maximum acceptable absolute value of the x-intercept for the fit of peak area vs. injection volume.",
			Category -> "Autosampler Test"
		},

		(* Fraction Collection *)
		FractionCollectionTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the HPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the HPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the HPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method, FractionCollection],
			Description -> "The fraction collection methods to use when testing the HPLC's fraction collector.",
			Category -> "Fraction Collection Test"
		},
		MinAbsorbance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 AbsorbanceUnit],
			Units -> AbsorbanceUnit,
			Description -> "The minimum allowable absorbance of HPLC fractions to be considered successfully collected.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionTestSampleFitFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Description -> "Fit function that calculates the expected concentration (mg/ml) of the analyte in FractionCollectionTestSample as a function of measured absorbance at the desired Wavelength, stored as a pure function.",
			Category -> "Fraction Collection Test"
		},
		FractionCollectionConcentrationRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Milligram/Liter], GreaterEqualP[0*Milligram/Liter]},
			Units -> {Milligram/Liter, Milligram/Liter},
			Description -> "The accepted concentration range of the analyte in FractionCollectionTestSample that is collected during the HPLC run.",
			Headers -> {"Lower Limit of Accepted Concentration", "Higher Limit of Accepted Concentration"},
			Category -> "Fraction Collection Test"
		},

		(* Wavelength Accuracy *)
		WavelengthAccuracyTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the accuracy of the HPLC's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the accuracy of the HPLC's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the accuracy of the HPLC's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the accuracy of the HPLC's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		ReferenceAbsorbanceSpectrum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectrum of the wavelength accuracy analyte.",
			Category -> "Wavelength Accuracy Test"
		},
		LambdaMaxes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nano Meter],
			Units -> Nano Meter,
			Description -> "The wavelengths at which the sample being used to test wavelength accuracy has local maxima in its absorption spectrum.",
			Category -> "Wavelength Accuracy Test"
		},
		MaxPeakWavelengthDifference -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The maximum allowable difference between measured max absorbance wavelengths and expected max absorbance wavelengths.",
			Category -> "Wavelength Accuracy Test"
		},
		MinOffPeakAreaFactor -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "Peak areas measured away from max absorbance wavelengths must be smaller than this value multiplied by the peak area at the expected max absorbance.",
			Category -> "Wavelength Accuracy Test"
		},

		(* Detector Linearity *)
		DetectorLinearityTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the most concentrated sample that will be injected when testing the linearity of the HPLC's detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the linearity of the HPLC's detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the linearity of the HPLC's detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the linearity of the HPLC's detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityDilutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1,Inclusive->Right],
			Units -> None,
			Description -> "The factors to dilute the DetectorLinearityTestSample by prior to injection.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution to use to dilute the detector linearity test samples.",
			Category -> "Detector Linearity Test"
		},
		MaxDetectorResponseFactorRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing detector response, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
			Category -> "Detector Linearity Test"
		},
		MinDetectorLinearityCorrelation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "When testing detector linearity, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
			Category -> "Detector Linearity Test"
		},

		(* Additional Detector Linearity *)
		SecondaryDetectorLinearityTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the most concentrated sample that will be injected when testing the linearity of the HPLC's additional detectors in a second HPLC run.",
			Category -> "Detector Linearity Test"
		},
		SecondaryDetectorLinearityGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the linearity of the HPLC's additional detectors in a second HPLC run.",
			Category -> "Detector Linearity Test"
		},
		SecondaryDetectorLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the linearity of the HPLC's additional detectors in a second HPLC run.",
			Category -> "Detector Linearity Test"
		},
		SecondaryDetectorLinearityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the linearity of the HPLC's additional detectors in a second HPLC run.",
			Category -> "Detector Linearity Test"
		},
		HydrodynamicRadiusRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Nanometer], GreaterEqualP[0*Nanometer]},
			Units -> {Nanometer, Nanometer},
			Description -> "The accepted hydrodynamic radius(Q) range of the analyte in SecondaryDetectorLinearityTestSample that is collected during the HPLC run.",
			Headers -> {"Lower Limit of Accepted Hydrodynamic Radius", "Higher Limit of Accepted Hydrodynamic Radius"},
			Category -> "Detector Linearity Test"
		},
		NumberAverageMolarMassRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Dalton], GreaterEqualP[0*Dalton]},
			Units -> {Dalton, Dalton},
			Description -> "The accepted number-average molar mass (Mn) range range of the analyte in SecondaryDetectorLinearityTestSample that is collected during the HPLC run.",
			Headers -> {"Lower Limit of Accepted Number Average Molar Mass", "Higher Limit of Accepted Number Average Molar Mass"},
			Category -> "Detector Linearity Test"
		},
		WeightAverageMolarMassRange -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Dalton], GreaterEqualP[0*Dalton]},
			Units -> {Dalton, Dalton},
			Description -> "The accepted weight-average molar mass (Mw) range of the analyte in SecondaryDetectorLinearityTestSample that is collected during the HPLC run.",
			Headers -> {"Lower Limit of Accepted Weight Average Molar Mass", "Higher Limit of Accepted Weight Average Molar Mass"},
			Category -> "Detector Linearity Test"
		},
		SecondaryDetectorLinearityDilutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1,Inclusive->Right],
			Units -> None,
			Description -> "The factors to dilute the SecondaryDetectorLinearityTestSample by prior to injection.",
			Category -> "Detector Linearity Test"
		},
		SecondaryDetectorLinearityDiluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solution to use to dilute the SecondaryDetectorLinearityTestSample.",
			Category -> "Detector Linearity Test"
		},
		SecondaryMaxDetectorResponseFactorRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing detector response of the HPLC's additional detectors in a second HPLC run, the maximum acceptable percent relative standard deviation of peak area to dilution ratios.",
			Category -> "Detector Linearity Test"
		},
		SecondaryMinDetectorLinearityCorrelation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "When testing detector linearity of the HPLC's additional detectors in a second HPLC run, the minimum acceptable correlation coefficient for the fit of peak area vs. dilution factor.",
			Category -> "Detector Linearity Test"
		},
		FluorescenceGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "The signal amplification of fluorescence measurement for the sample to be used on the Fluorescence detector.",
			Category -> "Detector Linearity Test"
		},

		(* Gradient Proportioning *)
		GradientProportioningTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		GradientProportioningGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradients to run when testing the HPLC's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		GradientProportioningInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the HPLC's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		GradientProportioningReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the HPLC's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		MaxGradientProportioningPeakRetentionRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing the proportioning valves, the maximum percent relative standard deviation of peak retention times.",
			Category -> "Gradient Proportioning Test"
		},
		MaxpHDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "When testing the proportioning valves, the maximum accepted variance in the extrapolated pH value.",
			Category -> "Gradient Proportioning Test"
		}
	}
}];
