

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, FluorescenceSpectroscopy], {
	Description->"Protocol for measuring fluorescence at varying emission wavelengths after illuminating samples with light at a excitation wavelength and/or measuring fluorescence at a fixed emission wavelength after illumination with light at varying excitation wavelengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the fluorescence intensity experiment.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		SpectralScan -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FluorescenceScanTypeP,
			Description -> "Indicates if fluorescence is recorded using a fixed excitation wavelength and a range of emission wavelengths (Emission) or using a fixed emission wavelength and a range of excitation wavelengths (Excitation).",
			Category -> "Fluorescence Measurement"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the samples is measured.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the samples.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		MinExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The lowest wavelength used to excite fluorescence in the samples. Fluorescence is then measured at the emission wavelength.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		MaxExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The highest wavelength which should be used to excite fluorescence in the samples. Fluorescence is then measured at the emission wavelength.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The lowest wavelength at which fluorescence emitted from the sample is measured after the sample has been illuminated by the excitation wavelength.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The highest wavelength at which fluorescence emitted from the sample is measured after the sample has been illuminated by the excitation wavelength.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The desired temperature of the sample chamber during the experimental run.",
			Category -> "Fluorescence Measurement"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which the plates are incubated in the plate reader at Temperature before intensity readings are taken.",
			Category -> "Fluorescence Measurement"
		},
		TargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Fluorescence Measurement"
		},
		TargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Fluorescence Measurement"
		},
		AtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
			Category -> "Fluorescence Measurement"
		},
		EstimatedACUEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The estimated length of time for the gas level inside the chamber to reach the TargetOxygenLevel and TargetCarbonDioxideLevel.",
			Developer -> True,
			Category -> "Fluorescence Measurement"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "Indicates if the plate will be illuminated and read from top or bottom.",
			Category -> "Fluorescence Measurement"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The order in which wells are read.",
			Category -> "Fluorescence Measurement"
		},
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The height above the assay plates from which the fluorescence intensity readings are made.",
			Category -> "Fluorescence Measurement"
		},
		AutoFocalHeight -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the FocalHeight will be determined automatically using the AdjustmentSample to calibrate.",
			Category -> "Fluorescence Measurement"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of redundant readings taken by the detector and averaged over each sample.",
			Category -> "Fluorescence Measurement"
		},
		ExcitationScanGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage applied to the primary detector's PMT during the excitation scan.",
			Category -> "Optics"
		},
		ExcitationScanGainPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The percentage of the primary detector's dynamic range which the initial fluorescence reading of the AdjustmentSample should be during the excitation scan.",
			Category -> "Optics"
		},
		EmissionScanGain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage applied to the primary detector's PMT during the emission scan.",
			Category -> "Optics"
		},
		EmissionScanGainPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The percentage of the primary detector's dynamic range which the initial fluorescence reading of the AdjustmentSample should be during the emission scan.",
			Category -> "Optics"
		},
		AdjustmentSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The sample used to determine the gain percentage and focal height adjustments.",
			Category -> "Fluorescence Measurement"
		},
		AdjustmentSampleWell -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "When multiple aliquots are created of the AdjustmentSample, the well of the aliquot used to perform gain and focal height auto adjustment.",
			Category -> "Fluorescence Measurement"
		},

		AdjustmentEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The emission wavelength within the scan range used to determine the gain percentage and focal height adjustments.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		AdjustmentExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The excitation wavelength within the scan range used to determine the gain percentage and focal height adjustments.",
			Category -> "Fluorescence Measurement",
			Abstract -> True
		},
		PrimaryInjections -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the first group of injections into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		SecondaryInjections -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the second group of injections into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		PrimaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
			Category -> "Injection"
		},
		SecondaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
			Category -> "Injection"
		},
		InjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which any injections samples used in this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		},
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to fluorescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to fluorescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to fluorescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The mode of shaking which should be used to mix the plate.",
			Category -> "Mixing"
		},
		SamplingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderSamplingP,
			Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well. Matrix reads a grid of points within a circle whose diameter is the SamplingDistance.",
			Category -> "Fluorescence Measurement"
		},
		SamplingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the length of the region over which sampling measurements are taken.",
			Category -> "Fluorescence Measurement"
		},
		SamplingDimension -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->3 scans a 3 x 3 grid.",
			Category -> "Fluorescence Measurement"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Fluorescence Measurement"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Fluorescence Measurement"
		},
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The depth the moat extends into the assay plate.",
			Category -> "Fluorescence Measurement"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "Fluorescence Measurement"
		},
		MoatPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of MoatBuffer into MoatWells in order to create the moat to slow evaporation of inner assay samples.",
			Category -> "General",
			Developer -> True
		},
		MoatManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, SampleManipulation], Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation], Object[Notebook, Script]],
			Description -> "The sample preparation protocol used to transfer buffer into the moat wells.",
			Category -> "General"
		},
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which performs the pump priming when executed.",
			Category -> "Injection",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file that sets the measurement parameters and runs the experiment.",
			Category -> "General",
			Developer -> True
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name of the exported raw data file.",
			Category -> "General",
			Developer -> True
		},
		InjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample loaded into the first injector position on the instrument.",
			Category -> "Injections"
		},
		SecondaryInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample loaded into the second injector position on the instrument.",
			Category -> "Injections"
		},
		InjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		InjectionRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the injection containers during sample priming and injection.",
			Category -> "Placements",
			Developer -> True
		},
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			Category -> "Cycling",
			Developer -> True
		},

		(* Injector Cleaning *)
		InjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which includes instructions to turn the syringe pumps on and off as needed and to run the cleaning solvents through the injectors.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect waste during injector cleaning.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondarySolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "An additional container used to collect overflow waste during injector cleaning.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		CleaningRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the cleaning solvent containers when the lines are prepped and flushed.",
			Category -> "Placements",
			Developer -> True
		},
		WasteContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the waste container(s) into position.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		Line1PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 1 injector is washed before and after running the experiment.",
			Category -> "Injector Cleaning"
		},
		Line1SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 1 injector is washed before and after running the experiment.",
			Category -> "Injector Cleaning"
		},
		PreppingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position prior to running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		Line2PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 2 injector is washed before and after running the experiment.",
			Category -> "Injector Cleaning"
		},
		Line2SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 2 injector is washed before and after running the experiment.",
			Category -> "Injector Cleaning"
		},
		FlushingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move primary purging solvents into position for cleaning before and after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move secondary purging solvents into position for cleaning before and after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PurgingTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for cleaning before and after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		StorageTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for storage when experiment is not running.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		InjectionTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for sample injection when running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The predicted total time to complete readings of all samples based on requested run times, injections and mixing times.",
			Developer -> True,
			Category -> "Fluorescence Measurement"
		},

		(* -- DEPRECATE -- *)
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage applied to the primary detector's PMT.",
			Category -> "Optics"
		},
		GainPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The percentage of the primary detector's dynamic range which the initial fluorescence reading of the AdjustmentSample should be.",
			Category -> "Optics"
		},
		AdjustmentSampleIndex -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Indicates that the Nth aliquot of AdjustmentSample is used to determine gain and focal height auto adjustmen.",
			Category -> "Fluorescence Measurement",
			Developer -> True
		}
	}
}];
