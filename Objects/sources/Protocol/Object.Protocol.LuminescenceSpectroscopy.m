

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, LuminescenceSpectroscopy], {
	Description->"Protocol for measuring luminescence over a range of emission wavelengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* -- Luminescence Measurement -- *)
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The lowest wavelength at which luminescence emitted from the sample is measured.",
			Category -> "Luminescence Measurement",
			Abstract -> True
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The highest wavelength at which luminescence emitted from the sample is measured.",
			Category -> "Luminescence Measurement",
			Abstract -> True
		},
		AdjustmentEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The emission wavelength within the scan range used to perform the gain and focal height adjustments. If FocalHeight is not explicitly provided and instead AutoFocalHeight is set to True, measurements occur at this wavelength to determine what height gives the highest luminescence readings. If GainPercentage is provided, the measurements occur at this wavelength to determine the voltage to apply to the PMT such that the measurement is at the specified percentage of the primary detector's dynamic range.",
			Category -> "Luminescence Measurement",
			Abstract -> True
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage set on the PMT (photomultiplier tube) detector to amplify the detected signal during the emission scan.",
			Category -> "Luminescence Measurement"
		},
		GainPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "The value used to adjust the gain such that the initial reading of the AdjustmentSample is this percentage of the primary detector's dynamic range.",
			Category -> "Luminescence Measurement"
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
		FocalHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector.",
			Category -> "Luminescence Measurement"
		},
		AutoFocalHeight -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the FocalHeight is determined by reading the AdjustmentSample at different heights and selecting the height which gives the highest luminescence reading.",
			Category -> "Luminescence Measurement"
		},
		AdjustmentSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "The sample used to make gain and/or focal height adjustments. If FocalHeight is not explicitly provided and instead AutoFocalHeight is set to True, the adjustment sample is used to determine what height gives the highest luminescence readings. If GainPercentage is provided, the adjustment sample is measured to determine the voltage to apply to the PMT such that the measurement is at the specified percentage of the primary detector's dynamic range.",
			Category -> "Luminescence Measurement"
		},
		AdjustmentSampleWell -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "When multiple aliquots are created of the AdjustmentSample, the well of the aliquot used to perform gain and focal height auto adjustment.",
			Category -> "Luminescence Measurement"
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
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the sample and volume injected into the sample in the first round of injections.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
			Category -> "Injections"
		},
		SecondaryInjections -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, the sample and volume injected into the sample in the second round of injections.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
			Category -> "Injections"
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

		(* -- General -- *)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which sets the measurement parameters and begins the experimental run.",
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
		(* -- Mixing -- *)
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to luminescence reads.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description ->"The mode of shaking used to mix the plate prior to luminescence reads. Options include Orbital, DoubleOrbital, Linear.",
			Category -> "Mixing"
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
