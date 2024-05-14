(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, MeasureRefractiveIndex], {
	Description -> "A detailed set of parameters for running a measurement of the refractive index on a set of samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Sample-related fields *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "Sample to be measured the refractive index.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "Sample to be measured the refractive index.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Integer|_String, ObjectP[{Model[Container], Object[Container]}]},
			Relation -> Null,
			Description -> "Sample to be measured the refractive index.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		(* MeasureRefractiveIndex options *)
		Refractometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Alternatives[
				Object[Instrument,Refractometer],
				Model[Instrument]
			],
			Description -> "The instrument to measure refractive index.",
			Category -> "General"
		},
		RefractiveIndexReadingMode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RefractiveIndexReadingModeP,
			Units -> None,
			Description -> "For each member of SampleLink, the refractometer can perform different measurement modes. FixedMeasurement mode measures the sample at fixed temperature. TemperatureScan mode measures samples over a temperature range with fixed intervals. TimeScan mode performs multiple measurements over a period of time by taking subsamples in fixed time intervals.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[100 Microliter, 200 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the amount of sample volume to measure the refractive index.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleFlowRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1 Microliter/Second, 1000 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "For each member of SampleLink, the rate of sample is drawn from the vial and injected into the refractometer.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleSyringe -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item]
			],
			Units -> None,
			Description -> "For each member of SampleLink, the syringe used to transfer samples into the instrument.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		NumberOfReads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "The number of consecutive measurements (up to 10) taken of each sample after the sample is injected in to the instrument.",
			Category -> "General"
		},
		TemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[4 Celsius, 125 Celsius],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the desired temperature used for the refractive index measurement with FixedMeasurement mode.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		TemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Span,
			Units -> None,
			Description -> "For each member of SampleLink, the desired temperature range used for the refractive index measurement with TemperatureScan mode.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		TemperatureStep -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1 Celsius, 120 Celsius],
			Units -> Celsius,
			Description -> "For each member of SampleLink, when Method is set to TemperatureScan mode, refractive index measurement starts at the initial temperature and is remeasured at each temperature step until final temperature is reached.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		TimeDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Hour, 3 Day],
			Units -> Hour,
			Description -> "For each member of SampleLink, when Method is set to TimeScan mode, the sample is measured every TimeStep until it reaches to the total length of time duration.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		TimeStep -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Hour, 24 Hour],
			Units -> Hour,
			Description -> "For each member of SampleLink, when Method is set to TimeScan mode, the sample is measured every TimeStep.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		MeasurementAccuracy -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[0.00001,0.00002,0.00006],
			Units -> None,
			Description -> "For each member of SampleLink, the accuracy of measurement.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		EquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Hour, 1 Hour],
			Units -> Second,
			Description -> "For each member of SampleLink, the amount of time the sample equilibrates after the temperature reaches to the desired value.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		PrimaryWashSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Units -> None,
			Description -> "A solution used to flush the instrument out between each sample.",
			Category -> "Washing"
		},
		SecondaryWashSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Units -> None,
			Description -> "A fast-evaporating solution used to flush the primary wash solution out.",
			Category -> "Washing"
		},
		TertiaryWashSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Units -> None,
			Description -> "An optional third fast-evaporating solution used to flush the secondary wash solution out.",
			Category -> "Washing"
		},
		WashSoakTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Second, 15 Minute],
			Units -> Second,
			Description -> "The length of time for each washing solution is allowed to sit in the instrument after injection in order to clean the sample effectively.",
			Category -> "Washing"
		},
		WashingVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[2 Milliliter, 10 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of each washing solution injected into the instrument to clean sample residue inside of the refractometer.",
			Category -> "Washing"
		},
		NumberOfWashes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1,10,1],
			Units -> None,
			Description -> "The number of time to wash with all solvents before and after each measurement.",
			Category -> "Washing"
		},
		DryTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Minute, 10 Minute],
			Units -> Minute,
			Description -> "In order to remove any trace of washing solution in the instrument, the length of drying time for which nitrogen is flushed through the instrument line after washing with each wash solution.",
			Category ->"Washing"
		},
		Calibration -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> None | BeforeRun | BetweenSamples,
			Units -> None,
			Description -> "The calibration process can be performed before the measurement once or after every measurement.",
			Category -> "Calibration"
		},
		CalibrantLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Units -> None,
			Description -> "The Calibrant of known refractive index used to adjust the instrument.",
			Category -> "Calibration",
			Migration -> SplitField
		},
		CalibrantExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
			Units -> None,
			Description -> "The Calibrant of known refractive index used to adjust the instrument.",
			Category -> "Calibration",
			Migration -> SplitField
		},
		CalibrantString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The Calibrant of known refractive index used to adjust the instrument.",
			Category -> "Calibration",
			Migration -> SplitField
		},
		CalibrationTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern:> RangeP[10 Celsius, 40 Celsius],
			Units -> Celsius,
			Description -> "The temperature where Calibrant refractive index measurement performs.",
			Category -> "Calibration"
		},
		CalibrantRefractiveIndex -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1.26, 1.72],
			Units -> None,
			Description -> "The known refractive index of the given Calibrant.",
			Category -> "Calibration"
		},
		CalibrantVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[100 Microliter, 200 Microliter],
			Units -> Microliter,
			Description -> "The amount of Calibrant volume is injected into the instrument.",
			Category -> "Calibration"
		},
		CalibrantStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Units -> None,
			Description -> "After calibration is completed, the Calibrant is stored with CalibrantStorageCondition.",
			Category -> "Calibration"
		},
		RecoupSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "For each member of SampleLink, if RecoupSample is True each sample is flushed back to the original container. Otherwise, the sample is flushed into the waste bottle.",
			Category -> "General",
			IndexMatching -> SampleLink
		}
	}
}];
