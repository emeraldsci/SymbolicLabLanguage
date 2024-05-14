(* ::Package:: *)

DefineObjectType[Object[Qualification, MassSpectrometer],{
	Description -> "A protocol that verifies the functionality of the mass spectrometer target.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
	
		(* spec for mass spectrometry protocol *)
		ContainersIn ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Model[Container, Vessel],
				Object[Container,Plate],
				Object[Container,Vessel]
			],
			Description -> "The containers that hold test samples after aliquot.",
			Category -> "General"
		},
		MALDIPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Alternatives[ 
				Model[Container],
				Object[Container]
			],
			Description -> "The MALDI plate employed to analyze samples in the mass spectroemter.",
			Category -> "General",
			Abstract -> True
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The liquid handler instrument employed to transfer samples to MALDI plate.",
			Category -> "General",
			Abstract -> True
		},
		Calibrants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of QualificationSamples, a sample with known mass-to-charge ratios used to calibrate the mass spectrometer.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		Matrices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of QualificationSamples, the substance co-spotted with the sample to assist in ionization.",
			IndexMatching -> QualificationSamples,
			Category -> "General"
		},
		MassSpectrometryProtocol->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MassSpectrometry],
			Description -> "The mass spectrometry protocol used to collect system suitability data.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by Sample Manipulation to generate the Mass Spectrometry Blanks and Standards.",
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
		PeakPositionTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for this qualification's Peak Position Test.",
			Category -> "Analytes"
		},
		CalibrationTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for this qualification's Calibration Tests.",
			Category -> "Analytes"
		},
		CrossContaminationTestSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for this qualification's Peak Position Test.",
			Category -> "Analytes"
		},
		BlankSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples for empty wells in this qualification's Cross-Contamination Test.",
			Category -> "Analytes"
		},

		(* results *)
		MassSpectrometryData -> {
			Format -> Multiple,
			Class  -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data,MassSpectrometry], Object[Data, ICPMS]],
			Description -> "The data collected by the mass spectrometry protocol.",
			Category -> "Experimental Results"
		},
		MassRangeDistributions -> {
			Format->Multiple,
			Class->{Real,Real,Real,Real,Boolean},
			Pattern:>{UnitsP[Gram/Mole],UnitsP[Gram/Mole],GreaterEqualP[0*Percent],GreaterEqualP[0*Percent],BooleanP},
			Units->{Gram/Mole,Gram/Mole,Percent,Percent,None},
			Headers -> {"Requested Mass","Experimental Mass","Percent Deviation","Allowed Deviation","Passing"},
			Category->"Analysis & Reports",
			Description->"The positions calibrant mass ranges were calibrated to during the experiment in the form: {Requested Mass, Experimental Mass, Percent Deviation, Allowed Deviation, Passing}."
		},
		CalibrationPeaks -> {
			Format -> Multiple,
			Class ->{Real,Real,Link,Expression,Integer,Integer,Boolean},
			Pattern :> {GreaterEqualP[(0*Gram)/Mole],GreaterEqualP[(0*Gram)/Mole],_Link,IonModeP,GreaterEqualP[0],GreaterEqualP[0],BooleanP},
			Relation ->{Null,Null,Model[Sample,Matrix],Null,Null,Null,Null},
			Units->{Gram/Mole,Gram/Mole,None,None,None,None,None},
			Headers -> {"Min Mass","Max Mass","Matrix","Ion Mode","Peaks Within Range","Minimum Peaks within Range","Passing"},
			Category -> "Analysis & Reports",
			Description -> "The number of observed calibrant peaks for each range during the experiment in the form: {Min Mass, Max Mass, Matrix, Ion Mode, Peaks Within Range, Minimum Peaks within Range, Passing}."
		},
		PeakPositionDistributions -> {
			Format->Multiple,
			Class -> {Real,Expression,Real},
			Pattern :> {GreaterP[(0*Gram)/Mole],DistributionP[],GreaterEqualP[0*Percent]},
			Units ->{Gram/Mole,None,Percent},
			Headers -> {"Expected M/Z","Peak Position Distribution","% Relative Standard Deviation"},
			Description -> "For all wells spotted with the same sample model, the distributions of their peak positions in the form: {Expected M/Z,Peak Position Distribution}.",
			Category -> "Analysis & Reports"
		},
		CrossContaminationPeaks -> {
			Format -> Multiple,
			Class ->  {Expression,Integer},
			Pattern :> {_String,GreaterEqualP[0]},
			Headers -> {"Sample Well","Number of Observed Peaks"},
			Description -> "The number of peaks observed in the blank samples in the form: {Sample Well, Number of Observed Peaks}.",
			Category -> "Analysis & Reports"
		},

		(* Pass/Fail test results *)
		CalibrationTestResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the calibration test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		MassRangeTestResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the mass range test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		PeakPositionTestResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates the outcome of the peak position test after evaluation.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		CrossContaminationTestResult ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> QualificationResultP,
			Description -> "Indicates any cross contamination from the neighboring wells during sample spotting.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		(* ICP-MS specific fields *)
		(* Parameter and analytes *)
		TuningStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The tuning standard used for ICP-MS qualification.",
			Category -> "General"
		},
		IntensityTestSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Input sample used to test intensity consistency and calibration curve.",
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
		IntensityTestElements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ICPMSNucleusP,
			Description -> "Elements which intensity will be measured in this qualification.",
			Category -> "Analytes"
		},
		InternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
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
		ExternalStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The external standard used in the qualification to construct calibration curve.",
			Category -> "Analytes"
		},
		DilutionCurve -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Milliliter]},
			Units -> {Milliliter, Milliliter},
			Headers -> {"Sample volume", "Blank volume"},
			Description -> "The dilution curve indicating sample and blank volume for calibration test.",
			Category -> "Analytes"
		},
		(*results*)
		TuneReportFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The tuning and mass calibration report from this quantification.",
			Category -> "Analysis & Reports"
		},
		PerformanceTests -> {
			Format -> Multiple,
			Class -> {String, Real, Real, Real, Boolean},
			Pattern :> {_String, _?NumberQ, _?NumberQ, _?NumberQ, BooleanP},
			Headers -> {"Test item", "measured value", "Min allowed value", "Max allowed value", "Passing"},
			Description -> "The performance test results from tuning, formated in {Test item, Measured value, Min allowed value, Max allowed Value, Passing}.",
			Category -> "Analysis & Reports"
		}
	}
}];



