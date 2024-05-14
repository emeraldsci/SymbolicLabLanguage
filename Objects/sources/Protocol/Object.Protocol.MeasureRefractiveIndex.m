(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, MeasureRefractiveIndex], {
	Description -> "A protocol to measure the refractive index of samples using the refractometer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Refractometer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,Refractometer],
				Model[Instrument,Refractometer]
			],
			Description -> "The instrument used to measure the refractive index of a sample.",
			Category -> "General"
		},
		DensityMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, DensityMeter],
				Model[Instrument, DensityMeter]
			],
			Description -> "The main instrument used to operate refractometer and LIMS software.",
			Category -> "General"
		},
		DryingCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, DryingCartridge],
				Model[Part, DryingCartridge]
			],
			Description -> "A replaceable drying cartridge used in the refractometer maintenance task.",
			Category -> "Qualifications & Maintenance"
		},
		RefractometerTool -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, RefractometerTool],
				Model[Part, RefractometerTool]
			],
			Description -> "A flat driver to screw/unscrew a drying cartridge from the refractometer.",
			Category -> "Qualifications & Maintenance"
		},
		ORing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, ORing],
				Model[Part, ORing]
			],
			Description -> "A replaceable chemical resisting O-Ring used to the refractometer maintenance task.",
			Category -> "Qualifications & Maintenance"
		},
		NumberOfReads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of consecutive measurements (up to 10) taken of each sample after the sample is injected into the instrument.",
			Category -> "General"
		},
		(* Index matched to SamplesIn *)
		RefractiveIndexReadingModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RefractiveIndexReadingModeP,
			Units -> None,
			Description -> "For each member of SamplesIn, different measurement modes (FixedMeasurement, TemperatureScan, TimeScan) can be performed.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		MeasurementAccuracies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of SamplesIn, different measurement accuracy (0.000001, 0.00002, 0.00006) can be performed.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the amount of the input sample that is placed into the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SampleFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "For each member of SamplesIn, sample is injected into the instrument with given flow rate.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Temperature-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[0 Celsius]|Span[GreaterP[0 Celsius],GreaterP[0 Celsius]],
			Description -> "For each member of SamplesIn, the flow cell of the instrument is set to given temperature or temperature range.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		TemperatureSteps -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, refractive index measurement starts at the initial temperature and is remeasured at each temperature step until final temperature is reached.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		TimeDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Hour,
			Description -> "For each member of SamplesIn, the sample is measured every TimeStep until it reaches to the total length of time duration.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		TimeSteps ->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the sample is measured every TimeStep until it reaches to the duration.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the amount of time that the sample is allowed to equilibrate after the temperature reaches to the desired value before recording the refractive index.",
			IndexMatching -> SamplesIn,
			Category -> "General"
		},

		SampleSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item],
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the syringe used to transfer samples into the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SampleNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item],
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the needle used with the sample syringe to transfer the sample into the syringe.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		RecoupSamples -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the measured sample will be transferred back into the source container or disposed after measurement.",
			IndexMatching -> SamplesIn,
			Category-> "General"
		},
		(* Washing *)
		PrimaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The first wash solution used to flush out the remaining sample in the flow cell.",
			Category -> "Washing"
		},
		SecondaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The second wash solution used to flush out the primary wash solution in the flow cell.",
			Category -> "Washing"
		},
		TertiaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The third wash solution used to flush out the secondary wash solution in the flow cell.",
			Category -> "Washing"
		},
		WashingVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of each wash solution used to clean the flow cell.",
			Category -> "Washing"
		},
		NumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of repeated washing process with each solution.",
			Category -> "Washing"
		},
		WashSoakTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The length of time each washing solution is allowed to sit in the flow cell in order to allow any residue to dissolve.",
			Category -> "Washing"
		},
		DryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The length of time air is flushed through the instrument flow cell after the washing process is completed.",
			Category -> "Washing"
		},
		(* Container and resources *)
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "The container used to collect wash solutions.",
			Category -> "General",
			Developer -> True
		},
		PrimaryWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container],Object[Item],Model[Item]],
			Description -> "The syringe used to transfer the primary wash solution from the primary wash container to the instrument flow cell.",
			Category -> "General"
		},
		SecondaryWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container],Object[Item],Model[Item]],
			Description -> "The syringe used to transfer the secondary wash solution from the secondary wash container to the instrument flow cell.",
			Category -> "General"
		},
		TertiaryWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container],Object[Item],Model[Item]],
			Description -> "The syringe used to transfer the tertiary wash solution from the tertiary wash container to the instrument flow cell.",
			Category -> "General"
		},
		CalibrantSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "The syringe used to transfer the calibrant from calibrant container to the instrument flow cell.",
			Category -> "General"
		},
		PrimaryWashNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The needles used with the syringe to transfer wash solutions from wash solution container to the instrument flow cell.",
			Category -> "General"
		},
		SecondaryWashNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The needles used with the syringe to transfer wash solutions from wash solution container to the instrument flow cell.",
			Category -> "General"
		},
		TertiaryWashNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The needles used with the syringe to transfer wash solutions from wash solution container to the instrument flow cell.",
			Category -> "General"
		},
		CalibrantNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The needles used with the syringe to transfer calibrant from calibrant container to the instrument flow cell.",
			Category -> "General"
		},

		(* Water check / adjustment *)
		WaterResource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The ultra pure water, Milli-Q water, used to check and adjust the refractometer.",
			Category -> "General"
		},
		WaterSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "The syringe used to transfer the water from container to the instrument flow cell.",
			Category -> "General"
		},
		WaterNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description ->  "The needles used with the syringe to transfer water from container to the instrument flow cell.",
			Category -> "General"
		},

		(* Calibration *)
		Calibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[None,BeforeRun,BetweenSamples],
			Description -> "Indicates when the calibration process is performed. The instrument can be calibrated once before any measurement or once between each sample. Calibration process involves measuring the refractive index of Calibrant and comparing it to the known literature value.",
			Category -> "Calibration"
		},
		Calibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution with the known refractive index used to calibrate before and between sample measurement.",
			Category -> "Calibration"
		},
		CalibrantRefractiveIndex ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "Refractive index of calibrant obtained from calibrant model or provided value.",
			Category -> "Calibration"
		},
		CalibrationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The temperature where Calibrant refractive index measurement is performed.",
			Category -> "Calibration"
		},
		CalibrantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of Calibrant is injected into the flow cell before adjusting the calibration function to match the known CalibrantRefractiveIndex.",
			Category -> "Calibration"
		},
		CalibrantStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				SampleStorageTypeP,
				Disposal
			],
			Description -> "After calibration is completed, any remaining Calibrant which has not been injected is stored under the CalibrantStorageCondition.",
			Category -> "Calibration"
		},

		(* Experiment method *)
		MethodFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP|{FilePathP..},
			Description -> "For each member of SamplesIn, the full method file path with the run parameters.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CalibrationBeforeRunMethodFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP|{FilePathP..},
			Description -> "The file path containing the calibration method file with the run parameters.",
			Category -> "General",
			Developer -> True
		},
		CalibrationBetweenSamplesMethodFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP|{FilePathP..},
			Description -> "For each member of SamplesIn, the full method file path containing the calibration method file with the run parameters.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		(* Experiment data*)
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the name to use for the datafiles when generated by the instrument.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		DataFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of SamplesIn, the file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CalibrationDataFilePath -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the calibration data file.",
			Category -> "Experimental Results",
			Developer -> True
		}
	}
}];

