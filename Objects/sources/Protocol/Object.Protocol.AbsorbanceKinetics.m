

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, AbsorbanceKinetics], {
	Description->"Protocol for absorbance monitoring of kinetic reactions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	(* --- Sample Preparation --- *)
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the plate reader chamber is held.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the assay plates equilibrate at the requested temperature in the plate reader before being read.",
			Category -> "Sample Preparation"
		},
		TargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Sample Preparation"
		},
		TargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Sample Preparation"
		},
		AtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
			Category -> "Sample Preparation"
		},
		EstimatedACUEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The estimated length of time for the gas level inside the chamber to reach the TargetOxygenLevel and TargetCarbonDioxideLevel.",
			Developer -> True,
			Category -> "Sample Preparation"
		},
		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber during absorbance reads.",
			Category -> "Sample Preparation"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber during absorbance reads.",
			Category -> "Sample Preparation"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber during absorbance reads.",
			Category -> "Sample Preparation"
		},
		PlateReaderMixSchedule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixingScheduleP,
			Description -> "Indicates the points during the experiment at which the assay plate is mixed.",
			Category -> "Sample Preparation"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The mode of shaking used to mix the plate.",
			Category -> "Sample Preparation"
		},
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category -> "Sample Preparation"
		},

	(* --- Absorbance Measurement --- *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument used to measure the absorbance of samples.",
			Category -> "Absorbance Measurement",
			Abstract -> True
		},
		MinWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The lowest wavelength at which sample absorbance is measured.",
			Category->"Absorbance Measurement",
			Abstract->True
		},
		MaxWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The highest wavelength at which sample absorbance is measured.",
			Category->"Absorbance Measurement",
			Abstract->True
		},
		Wavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Nano*Meter],
			Units->Meter Nano,
			Description->"The wavelengths at which sample absorbance is measured.",
			Category->"Absorbance Measurement",
			Abstract->True
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which absorbance measurements are made.",
			Category -> "Absorbance Measurement"
		},
		ReadOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if all measurements and injections are done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
			Category -> "Absorbance Measurement"
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of redundant readings taken by the detector and averaged over per each well.",
			Category -> "Absorbance Measurement"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures absorbance in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "Absorbance Measurement"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "Absorbance Measurement"
		},
		SamplingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderSamplingP,
			Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well. Matrix reads a grid of points within a circle whose diameter is the SamplingDistance.",
			Category -> "Absorbance Measurement"
		},
		SamplingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the length of the region over which sampling measurements are taken.",
			Category -> "Absorbance Measurement"
		},
		SamplingDimension -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->3 scans a 3 x 3 grid.",
			Category -> "Absorbance Measurement"
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
			Category -> "Injections"
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
			Category -> "Injections"
		},
		TertiaryInjections -> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the third group of injections into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Time of Injection", "Injected Sample", "Amount Injected"},
			Category -> "Injections"
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
		InjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which any injections samples used in this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		},

	(* --- Data Processing --- *)
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the source used to generate a blank sample whose absorbance is subtracted as background from the absorbance readings of the input sample.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		BlankLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the label of the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SamplesIn.",
			Category -> "Data Processing",
			IndexMatching -> SamplesIn
		},
		BlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of Blanks, the volume of that sample that is used for blank measurements.",
			Category -> "Data Processing",
			IndexMatching -> Blanks
		},
		BlankAbsorbance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The absorbance data collected from the Blanks.",
			Category -> "Data Processing"
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
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			Category -> "Cycling",
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
		CleaningRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the cleaning solvent containers when the lines are prepped and flushed.",
			Category -> "Placements",
			Developer -> True
		},

	(* --- General --- *)
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
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which performs the pump priming when executed.",
			Category -> "General",
			Developer -> True
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
		MicrofluidicChipLoading -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Robotic, Manual],
			Description -> "The loading method for microfluidic chips.",
			Category -> "General"
		},
		BlankContainerPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of blanks into the plates used to house sample for absorbance measurement.",
			Category -> "General",
			Developer -> True
		},
		BlankContainerManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, ManualSamplePreparation] | Object[Protocol, RoboticSamplePreparation] | Object[Notebook, Script]  | Object[Protocol, RoboticCellPreparation] | Object[Protocol, ManualCellPreparation],
			Description -> "A sample preparation protocol used to transfer blanks into the plates used to house sample for absorbance measurement.",
			Category -> "General"
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The predicted total time to complete readings of all samples based on requested run times, injections and mixing times.",
			Developer -> True,
			Category -> "General"
		}
	}
}];
