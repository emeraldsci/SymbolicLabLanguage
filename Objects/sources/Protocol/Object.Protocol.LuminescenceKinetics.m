

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, LuminescenceKinetics], {
	Description->"Protocol for luminescence monitoring of kinetic reactions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* -- Luminescence Measurement -- *)
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time over which luminescence measurements are repeatedly made.",
			Category -> "Luminescence Measurement"
		},
		ReadOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if all measurements and injections are done serially, completing all actions for one well before moving on to the next, or in parallel.",
			Category -> "Luminescence Measurement"
		},
		WavelengthSelection->{
			Format->Single,
			Class->Expression,
			Pattern:>LuminescenceWavelengthSelectionP,
			Description->"The method used to filter out light in order to provide the requested emission wavelengths.",
			Category->"Luminescence Measurement"
		},
		EmissionWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The wavelengths at which luminescence emitted from the samples is measured.",
			Category->"Luminescence Measurement",
			Abstract->True
		},
		Gains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of EmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
			IndexMatching -> EmissionWavelengths,
			Category -> "Luminescence Measurement"
		},
		GainPercentages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "For each member of EmissionWavelengths, the value used to adjust the gain such that the initial reading of the AdjustmentSample is this percentage of the primary detector's dynamic range.",
			IndexMatching -> EmissionWavelengths,
			Category -> "Luminescence Measurement"
		},
		DualEmission->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if both emission detectors are used to record emissions at the primary and secondary wavelengths.",
			Category->"Luminescence Measurement"
		},
		DualEmissionWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Meter*Nano],
			Units->Meter Nano,
			Description->"For each member of EmissionWavelengths, the corresponding wavelength at which luminescence emitted from the sample is measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
			IndexMatching->EmissionWavelengths,
			Category->"Luminescence Measurement",
			Abstract->True
		},
		DualEmissionGains->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Volt],
			Units->Volt,
			Description->"For each member of DualEmissionWavelengths, the voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the luminescence measurement at this wavelength.",
			IndexMatching->DualEmissionWavelengths,
			Category->"Luminescence Measurement"
		},
		DualEmissionGainPercentages->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units->Percent,
			Description->"For each member of DualEmissionWavelengths, the value used to adjust the gain such that the initial intensity reading of the AdjustmentSample is this percentage of the secondary detector's dynamic range at this wavelength.",
			IndexMatching->DualEmissionWavelengths,
			Category->"Luminescence Measurement"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument which performs the luminescence measurements.",
			Category -> "Luminescence Measurement",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The desired temperature of the sample chamber during the experimental run.",
			Category -> "Luminescence Measurement"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which the plates are incubated in the plate reader at Temperature before readings are taken.",
			Category -> "Luminescence Measurement"
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Second,
			Description -> "The amount of time over which luminescence measurements should be integrated.",
			Category -> "Luminescence Measurement"
		},
		ReadLocation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadLocationP,
			Description -> "The position of the optic used to measure luminescence (above the plate or one below the plate).",
			Category -> "Luminescence Measurement"
		},
		PositioningDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The amount of time the system waits before taking measurements in order to allow for the sample to settle after it has moved into the measurement position.",
			Category -> "Luminescence Measurement"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures luminescence in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "Luminescence Measurement"
		},
		FocalHeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "For each member of EmissionWavelengths, indicate the distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector.",
			Category -> "Luminescence Measurement",
			IndexMatching -> EmissionWavelengths
		},
		AutoFocalHeights -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of EmissionWavelengths, indicates if the FocalHeight is determined by reading the AdjustmentSample at different heights and selecting the height which gives the highest luminescence reading.",
			Category -> "Luminescence Measurement",
			IndexMatching -> EmissionWavelengths
		},
		AdjustmentSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "For each member of EmissionWavelengths, indicate the sample used to make gain and/or focal height adjustments. If FocalHeight is not explicitly provided and instead AutoFocalHeight is set to True, the adjustment sample is used to determine what height gives the highest luminescence readings. If GainPercentage is provided, the adjustment sample is measured to determine the voltage to apply to the PMT such that the measurement is at the specified percentage of the primary detector's dynamic range.",
			Category -> "Luminescence Measurement",
			IndexMatching -> EmissionWavelengths
		},
		AdjustmentSampleWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of EmissionWavelengths, when multiple aliquots are created of the AdjustmentSample, the well of the aliquot used to perform gain and focal height auto adjustment.",
			Category -> "Luminescence Measurement",
			IndexMatching -> EmissionWavelengths
		},
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
			Category -> "Luminescence Measurement"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Luminescence Measurement"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Luminescence Measurement"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "Luminescence Measurement"
		},
		OpticModules -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,OpticModule],
				Object[Part,OpticModule]
			],
			Description -> "The optic modules which house the filters used to achieve the emission wavelengths.",
			Category -> "Luminescence Measurement"
		},
		SamplingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderSamplingP,
			Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well. Matrix reads a grid of points within a circle whose diameter is the SamplingDistance.",
			Category -> "Luminescence Measurement"
		},
		SamplingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the length of the region over which sampling measurements are taken.",
			Category -> "Luminescence Measurement"
		},
		SamplingDimension -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->3 scans a 3 x 3 grid.",
			Category -> "Luminescence Measurement"
		},

	(* -- Injections -- *)
		PrimaryInjections -> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the first injection into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Time of Injection", "Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		SecondaryInjections -> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the second injection into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Time of Injection", "Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		TertiaryInjections -> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the third injection into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Time of Injection", "Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		QuaternaryInjections-> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the fourth group of injections into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Time of Injection", "Injected Sample", "Amount Injected"},
			Category -> "Injection"
		},
		PrimaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
			Category -> "Injections"
		},
		SecondaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
			Category -> "Injections"
		},
		TertiaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the third round of injection.",
			Category -> "Injections"
		},
		QuaternaryInjectionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the fourth round of injection.",
			Category -> "Injections"
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
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			Category -> "Cycling",
			Developer -> True
		},

		(* -- Method Information -- *)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which sets the measurement parameters and begins the experimental run.",
			Category -> "General",
			Developer -> True
		},
		RunFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which starts the run on the plate reader after settings have been configured and the cycle time has been determined.",
			Category -> "General",
			Developer -> True
		},
		MoatPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the aliquoting of MoatBuffer into MoatWells in order to create the moat to slow evaporation of inner assay samples.",
			Category -> "General",
			Developer -> True
		},
		MoatManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulations protocol used to transfer buffer into the moat wells.",
			Category -> "Sample Preparation"
		},
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which performs the pump priming when executed.",
			Category -> "General",
			Developer -> True
		},

		(* -- Mixing -- *)
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber during luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber during luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber during luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixSchedule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixingScheduleP,
			Description -> "Indicates the points during the experiment at which the assay plate is mixed.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The mode of shaking used to mix the plate. Options include Orbital, DoubleOrbital, Linear.",
			Category -> "Mixing"
		},

		(* -- Placements -- *)
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

		(* -- Injector Cleaning -- *)
		InjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which pumps cleaning solvents through the injectors.",
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
		PrimaryPreppingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the injectors are washed prior to running the experiment.",
			Category -> "Injector Cleaning"
		},
		SecondaryPreppingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the injectors are washed prior to running the experiment.",
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
		PrimaryFlushingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which to wash the injectors after running the experiment.",
			Category -> "Injector Cleaning"
		},
		SecondaryFlushingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which to wash the injectors after running the experiment.",
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
		InjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which any injections samples used in this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		}
	}
}];
