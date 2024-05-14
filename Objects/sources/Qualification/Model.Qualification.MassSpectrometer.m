(* ::Package:: *)

DefineObjectType[Model[Qualification, MassSpectrometer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a mass spectrometer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		(* mass spectrometry specs *)
		MALDIPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description ->"The model of MALDI plate employed to analyze samples in the mass spectrometer.",
			Category -> "General",
			Abstract -> True
		},
		TestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for this qualification.",
			Category -> "Analytes"
		},
		PeakPositionTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for this qualification's Peak Position Test.",
			Category -> "Analytes"
		},
		CalibrationTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for this qualification's Calibration Tests.",
			Category -> "Analytes"
		},
		CrossContaminationTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for this qualification's Peak Position Test.",
			Category -> "Analytes"
		},
		BlankSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input samples for empty wells in this qualification's Cross-Contamination Test.",
			Category -> "Analytes"
		},
		PeakPositionTestMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The positions at which peaks are expected for this test.",
			Category -> "General"
		},
		CalibrationTestMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The positions at which peaks are expected for this test.",
			Category -> "General"
		},
		CrossContaminationTestMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The positions at which peaks are expected for this test.",
			Category -> "General"
		},
		Replicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times each test sample will be read to determine measurement precision.",
			Category -> "General"
		},
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description->"The volume transferred to each well on the MALDI plate.",
			Category -> "General",
			Abstract -> True
		},
		Calibrants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "For each member of TestSamples, a sample with known mass-to-charge ratios used to calibrate the mass spectrometer.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},
		Matrices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "For each member of TestSamples, the model of matrix used to analyze samples on the mass spectrometer.",
			IndexMatching -> TestSamples,
			Category -> "General",
			Abstract -> True
		},
		MassRanges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[(0*Gram)/Mole];;GreaterP[(0*Gram)/Mole],
			Description -> "For each member of TestSamples, the span of low and high value in the mass range.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},
		ImageSample -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->"Option to take images of the samples after the mass spectrometry experiment.",
			Category -> "General"
		},
		SpottingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpottingMethodP,
			Description -> "The spotting method used to spot the MALDI plate with sample and calibrant.",
			Category -> "General"
		},
		SpottingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SpottingPatternP,
			Description -> "Indicates if all wells can be spotted (All) or if every other well should be spotted (Spaced) to avoid contamination.",
			Category -> "General"
		},
		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of TestSamples, whether the mass spectrometry data is to be acquired in positive or negative ion mode.",
			Category -> "General",
			Abstract -> True
		},
		LaserPowerRanges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RangeP[0*Percent, 100*Percent];;RangeP[0*Percent, 100*Percent],
			Description -> "For each member of TestSamples, the span of minimium and maximum laser power used to collect this mass spectrometry data.",
			IndexMatching -> TestSamples,
			Category -> "General"
		},
		ShotsPerRaster -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of repeated shots between each raster movement within a well.",
			Category -> "Ionization"
		},
		NumberOfShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times the mass spectrometer fires the laser to collect this mass spectrometry data.",
			Category -> "Ionization"
		},
		DelayTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Nano Second,
			Description -> "For each member of TestSamples, the delay between laser ablation and ion extraction accepted by the instrument.",
			IndexMatching -> TestSamples,
			Category -> "Ionization"
		},
		AccelerationVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of TestSamples, the voltage applied to the target plate to accelerate the ions.",
			IndexMatching -> TestSamples,
			Category -> "Mass Analysis"
		},
		GridVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of TestSamples, the voltage applied to the grid electrode.",
			IndexMatching -> TestSamples,
			Category -> "Mass Analysis"
		},
		LensVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt],
			Units -> Kilo Volt,
			Description -> "For each member of TestSamples, the voltage applied to the ion focusing lens located at the entrance of the mass analyser.",
			IndexMatching -> TestSamples,
			Category -> "Mass Analysis"
		},

		(* specs for passing test *)
		MassRangeTestCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum allowed percent offset from the expected mass range.",
			Category -> "Analysis & Reports"
		},
		PeakPositionTestCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum acceptable percent relative standard deviation in normalized peak area.",
			Category -> "Analysis & Reports"
		},
		CalibrationTestCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Percent],
			Units -> Percent,
			Description -> "The maximum allowed percent offset from the expected calibrant peak positions.",
			Category -> "Analysis & Reports"
		},
		(* ICP-MS specific fields *)
		(* Analytes and parameters related *)
		TuningStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The tuning standard used for ICP-MS qualification.",
			Category -> "General"
		},
		IntensityTestSamples -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input sample used to test intensity consistency and calibration curve.",
			Category -> "Analytes"
		},
		IntensityTestElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSNucleusP,
			Description -> "Elements which intensity will be measured in this qualification.",
			Category -> "Analytes"
		},
		PlasmaPower -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Low, Normal],
			IndexMatching -> IntensityTestElements,
			Description -> "For each member of IntensityTestElements, indicate the nominal plasma power setting.",
			Category -> "Analytes"
		},
		CollisionCellPressurization -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> IntensityTestElements,
			Description -> "For each member of IntensityTestElements, indicate whether collision cell should be pressurized or not.",
			Category -> "Analytes"
		},
		CollisionCellBias -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> IntensityTestElements,
			Description -> "For each member of IntensityTestElements, indicate whether collision cell bias should be turned on or not.",
			Category -> "Analytes"
		},
		CollisionCellGas -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Helium, Oxygen],
			IndexMatching -> IntensityTestElements,
			Description -> "For each member of IntensityTestElements, indicate which type of gas should be filled into collision cell.",
			Category -> "Analytes"
		},
		InternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Input sample that will serve as internal standard in qualification.",
			Category -> "Analytes"
		},
		InternalStandardElement -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of IntensityTestElements, indicate if it will be used as internal standard.",
			Category -> "Analytes",
			IndexMatching -> IntensityTestElements
		},
		InternalStandardMixRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "The ratio of internal standard : sample for all sample and standards.",
			Category -> "Analytes"
		},
		DilutionCurve -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Milliliter]},
			Units -> {Milliliter, Milliliter},
			Headers -> {"Standard volume", "Blank volume"},
			Description -> "The dilution curve indicating standard and blank volume for calibration test.",
			Category -> "Analytes"
		},
		ExternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The external standard used in the qualification to construct calibration curve.",
			Category -> "Analytes"
		},
		(* specs for passing test *)
		IntensityConsistencyCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "The maximum allowed percent standard deviation of element intensities from identical samples.",
			Category -> "Analysis & Reports"
		},
		IntensityCalibrationCriterion -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "The minimum allowed R^2 value for linear calibration curves of elements in the presence of internal standard.",
			Category -> "Analysis & Reports"
		}
	}
}];
