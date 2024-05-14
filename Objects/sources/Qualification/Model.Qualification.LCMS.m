(* ::Package:: *)

DefineObjectType[Model[Qualification,LCMS], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of an LCMS.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* Method Information *)
		Column ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The stationary phase device(s) employed in this LCMS separation.",
			Category -> "General",
			Abstract -> True
		},
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The default wavelength to measure the absorbance of in the absorbance detector's flow cell.",
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
			Description -> "The sample model that will be injected when testing the instrument's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The gradients to run when testing the instrument's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the instrument's pump.",
			Category -> "Flow Linearity Test"
		},
		FlowLinearityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the instrument's pump.",
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
			Description -> "The sample model that will be injected when testing the instrument's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the instrument's autosampler.",
			Category -> "Autosampler Test"
		},
		AutosamplerInjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volumes of sample to inject when testing the instrument's autosampler.",
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

		(* Wavelength Accuracy *)
		WavelengthAccuracyTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the accuracy of the instrument's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the accuracy of the instrument's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the accuracy of the instrument's absorbance detector.",
			Category -> "Wavelength Accuracy Test"
		},
		WavelengthAccuracyReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the accuracy of the instrument's absorbance detector.",
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

		(*Mass accuracy tests for positive mode injection*)
		MassAccuracyTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The sample model that will be injected when testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "Mass Accuracy Test"
		},
		MassAccuracyGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "Mass Accuracy Test"
		},
		MassAccuracyAcquisitionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,MassAcquisition],
			Description -> "The mass spec parameters to run when testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "Mass Accuracy Test"
		},
		MassAccuracyInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "Mass Accuracy Test"
		},
		MassAccuracyReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the accuracy of the instrument's mass spectrometry detector.",
			Category -> "Mass Accuracy Test"
		},
		ExpectedMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "The expected m/z to measure within in the MassAccuracyTestSample.",
			Category -> "Mass Accuracy Test"
		},
		MaxMassDifference -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "The maximum allowable difference between measured max absorbance wavelengths and expected max absorbance wavelengths.",
			Category -> "Mass Accuracy Test"
		},
		MinMassArea -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The minimum area expected for each expected peak in the sample.",
			Category -> "Mass Accuracy Test"
		},

		(* Detector Linearity -- note these are for the PDA detector*)
		DetectorLinearityTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the most concentrated sample that will be injected when testing the linearity of the instrument's PDA detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,Gradient],
			Description -> "The gradient to run when testing the linearity of the instrument's PDA detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the linearity of the instrument's PDA detector.",
			Category -> "Detector Linearity Test"
		},
		DetectorLinearityReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the linearity of the instrument's PDA detector.",
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
			Description -> "The gradients to run when testing the instrument's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		GradientProportioningInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume of sample to inject when testing the instrument's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		GradientProportioningReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of replicate injections that will be performed when testing the instrument's gradient proportioning valves.",
			Category -> "Gradient Proportioning Test"
		},
		MaxGradientProportioningPeakRetentionRSD -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Percent,
			Description -> "When testing the proportioning valves, the maximum percent relative standard deviation of peak retention times.",
			Category -> "Gradient Proportioning Test"
		}
	}
}];
