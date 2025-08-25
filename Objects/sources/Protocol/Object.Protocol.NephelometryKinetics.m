(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, NephelometryKinetics], {
	Description->"A protocol for measuring the intensity of scattered light from solutions over time with a nephelometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* ------Method Information------ *)
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if the samples are prepared already in the assay plate and the plate is read directly without further sample preparation.",
			Category -> "General"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NephelometryMethodTypeP,
			Description -> "The type of experiment nephelometric measurements are collected for. CellCount involves measuring the amount of scattered light from cells suspended in solution in order to quantify the number of cells in solution. CellCountParameterizaton involves measuring the amount of scattered light from a series of diluted samples from a cell culture, and quantifying the cells by another method, such as making titers, plating, incubating, and counting colonies, or by counting with a microscope. A standard curve is then created with the data to relate cell count to nephelometry readings for future cell count quantification. For the method Solubility, scattered light from suspended particles in solution will be measured, at a single time point or over a time period. Reagents can be injected into the samples to study their effects on solubility, and dilutions can be performed to determine the point of saturation.",
			Category -> "General",
			Abstract -> True
		},
		DataCollectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The estimated total time for the collection of nephelometry data.",
			Category -> "General",
			Developer -> True
		},

		(* ------Sample Prep------ *)
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

		(* ------Dilutions------ *)
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "For each member of SamplesIn, the compound or cell of interest for which solubility or cell count is determined.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SampleAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter] | GreaterEqualP[0*Milligram],
			Units->Microliter,
			Description -> "For each member of SamplesIn, the amount of sample or aliquot that will be taken to make the dilutions.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		InputConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Molar],
			Units->Micromolar,
			Description -> "For each member of SamplesIn, the concentration of the Analytes before any dilutions are performed recorded at the time the experiment was enqueued.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Dilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
			Description -> "For each member of SamplesIn, the collection of dilutions performed on the sample before measuring scattered light. This is the volume of the sample and the volume of the diluent that were mixed together for each concentration in the dilution series.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		SerialDilutions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
			Description -> "For each member of SamplesIn, the collection of the volume of the sample transferred in a serial dilution and the volume of the Diluent it is mixed with at each step.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		Diluents->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
			IndexMatching -> SamplesIn,
			Category->"Sample Preparation"
		},
		TotalVolumes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 Microliter]...},
			Description -> "For each member of SamplesIn, the collection of the total volumes of sample-diluent mixture in each well after performing dilutions.",
			Category -> "Sample Preparation"
		},
		DilutionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description->"The container or containers in which each sample is diluted with the Diluent to make the concentration series.",
			Category->"Sample Preparation",
			Developer->True
		},
		AssayPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ObjectP[{Model[Container], Object[Container]}], WellPositionP}..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the well positions in the measurement plate occupied by the sample dilution.",
			Category -> "Sample Preparation"
		},
		DilutionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the aliquoting of Diluent into samples and mixing in order to create the dilution series.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BlankContainerPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of blanks into the plates used to house samples for nephelometry measurement.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BlankContainerUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the transfers of blanks into the plates used to house samples for nephelometry measurement.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BlankContainerManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,SampleManipulation],
				Object[Protocol,RoboticCellPreparation],
				Object[Protocol,ManualCellPreparation],
				Object[Protocol,RoboticSamplePreparation],
				Object[Protocol,ManualSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "The protocol used to transfer blanks into the plates used to house sample for measurement.",
			Category -> "General"
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
		AssayPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the aliquoting of MoatBuffer into MoatWells in order to create the moat and transfer of samples and diluents into the assay plate to create the dilution curves if specified.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		AssayPlateUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of MoatBuffer into MoatWells in order to create the moat and transfer of samples and diluents into the assay plate to create the dilution curves if specified.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		AssayPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,SampleManipulation],
				Object[Protocol,RoboticCellPreparation],
				Object[Protocol,ManualCellPreparation],
				Object[Protocol,RoboticSamplePreparation],
				Object[Protocol,ManualSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "The protocol used to transfer buffer into the moat wells and create the dilution series if specified.",
			Category -> "Sample Preparation"
		},
		AssayPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move assay plates into the plate reader.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Sample Preparation",
			Developer -> True
		},

		(*------Optics------*)
		BeamAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the opening allowing the source laser light to pass through to the samples.",
			Category -> "Optics"
		},
		BeamIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of the total amount of the laser source light passed through to hit the samples.",
			Category -> "Optics"
		},


		(* ------Measurement------ *)
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the plate reader incubator is set for reading the plate.",
			Category -> "Measurement",
			Abstract -> True
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the plate is incubated in the plate reader at the specified Temperature before nephelometry measurements begin.",
			Category -> "Measurement"
		},
		TargetCarbonDioxideLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			Category -> "Measurement"
		},
		TargetOxygenLevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Percent],
			Units -> Percent,
			Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			Category -> "Measurement"
		},
		AtmosphereEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
			Category -> "Measurement"
		},
		EstimatedACUEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The estimated length of time for the gas level inside the chamber to reach the TargetOxygenLevel and TargetCarbonDioxideLevel.",
			Developer -> True,
			Category -> "Measurement"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,Nephelometer],
				Model[Instrument,Nephelometer]
			],
			Description -> "The instrument used to measure scattered light from samples.",
			Category -> "Measurement",
			Abstract -> True
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "Measurement"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures turbidity in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "Measurement"
		},
		ReadOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if all measurements and injections are done for one well before advancing to the next (serial) or in cycles in which each well is read once per cycle (parallel).",
			Category -> "Measurement"
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The total length of time for which nephelometry measurements are made.",
			Category -> "Measurement"
		},
		SamplingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ring,Spiral,Center],
			Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well.",
			Category -> "Measurement"
		},
		SamplingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Indicates the diameter of the region over which sampling measurements are taken.",
			Category -> "Measurement"
		},
		UniqueBlanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			Description -> "The duplicate-free set of models or samples used to generate blanks whose scattered light will be subtracted as background.",
			Category -> "Measurement",
			Developer->True
		},
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the model or sample used to generate a blank sample whose scattered light will be subtracted as background.",
			Category -> "Measurement",
			IndexMatching -> SamplesIn
		},
		UniqueBlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Microliter,
			Description -> "For each member of UniqueBlanks, the volume of that sample that should be used for blank measurements.",
			Category -> "Measurement",
			IndexMatching -> UniqueBlanks,
			Developer->True
		},
		BlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of Blanks, the volume of that sample that should be used for blank measurements.",
			Category -> "Measurement",
			IndexMatching -> Blanks
		},
		BlankContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "The containers that may be used to hold blank samples if the assay containers do not have enough empty wells for every blank.",
			Category -> "Measurement"
		},
		SettlingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
			Category -> "Measurement"
		},
		ReadStartTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time at which nephelometry measurement readings will begin, after the plate is in position and the SettlingTime has passed.",
			Category -> "Measurement"
		},
		IntegrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The amount of time that light is measured for each reading. Higher IntegrationTime leads to higher measures of light intensity.",
			Category -> "Measurement"
		},



		(* -------Kinetic cycling-------*)
		KineticWindowDurations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{GreaterEqualP[0*Second]..},
				All
			],
			Description -> "The length of time to study different areas of the kinetic curve. Separate NumberOfCycles and CycleTime can be set for each window, in order to increase the density of measurements for areas of particular interest.",
			Category -> "Cycling"
		},
		NumberOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "For each member of KineticWindowDurations, the number of times all selected wells in the plate are read.",
			IndexMatching -> KineticWindowDurations,
			Category -> "Cycling"
		},
		CycleTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of KineticWindowDurations, the duration of time between each measurement.",
			IndexMatching -> KineticWindowDurations,
			Category -> "Cycling"
		},
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Omega software.",
			Category -> "Cycling",
			Developer -> True
		},
		



		(* -------Injections------ *)
		PrimaryInjections -> {
			Format -> Multiple,
			Class -> {Real, Link, Real},
			Pattern :> {GreaterEqualP[0*Minute], _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Null, Object[Sample]|Model[Sample], Null},
			Units -> {Minute, None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the first group of injections into the assay plate.",
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
			Description -> "For each member of SamplesIn, a description of the second group of injections into the assay plate.",
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
			Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the second round of injection.",
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
		PrimaryInjectionSample -> {
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
		InjectionRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the injection containers during sample priming and injection.",
			Category -> "Injections",
			Developer -> True
		},




		(* ------Mixing------ *)
		PlateReaderMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to nephelometry measurements.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to nephelometry measurements.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to nephelometry measurements.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The shape of the mechanical shaking motion which should be used to mix the plate.",
			Category -> "Mixing"
		},
		PlateReaderMixSchedule -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixingScheduleP,
			Description -> "Indicates the points during the experiment at which the assay plate is mixed.",
			Category -> "Mixing"
		},




		(* ------Experimental Results------ *)
		BlankMeasurement -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The turbidity data collected from the well with buffer or media alone.",
			Category -> "Experimental Results"
		},


		(* ------Analysis & Reports------ *)
		QuantifyCellCount -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the number of cells in the samples is determined.",
			Category -> "Analysis & Reports"
		},
		QuantificationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, StandardCurve][Protocol],
			Description -> "Analyses performed to determine the cell count of samples in this protocol.",
			Category -> "Analysis & Reports"
		},




		(* ------Data Processing------- *)
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file names of the exported raw data files from plate reader for nephelometry measurements.",
			Category -> "Data Processing",
			Developer -> True
		},
		RunFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths to start the run on the plate reader after settings have been configured and the cycle time has been determined.",
			Category -> "Data Processing",
			Developer -> True
		},
		SettingsFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths for the executable files that set the measurement parameters and run the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which performs the pump priming when executed.",
			Category -> "Data Processing",
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
			Description -> "The primary solvent with which the injectors are washed prior to running the experiment.",
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
			Description -> "The secondary solvent with which the injectors are washed prior to running the experiment.",
			Category -> "Injector Cleaning"
		},
		Line2PrimaryPurgingSolvent -> {
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
		Line2SecondaryPurgingSolvent -> {
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
		CleaningRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the cleaning solvent containers when the lines are prepped and flushed.",
			Category -> "Injector Cleaning",
			Developer -> True
		},


		(* ------Sample Storage------ *)
		PrimaryInjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which the first injection sample used in this experiment should be stored after its usage in this experiment.",
			Category -> "Sample Storage"
		},
		SecondaryInjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which second injection sample used in this experiment should be stored after its usage in this experiment.",
			Category -> "Sample Storage"
		}
	}
}];