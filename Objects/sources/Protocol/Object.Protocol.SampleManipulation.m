(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, SampleManipulation], {
	Description->"A protocol for moving liquid between samples in the form of transfers, consolidations, aliquots, mixes, and dilutions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LiquidHandlingScale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LiquidHandlingScaleP,
			Description -> "The state and scale of the liquid handling operations performed in this protocol.",
			Category -> "General",
			Abstract -> True
		},
		Manipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A list of transfers, consolidations, aliquots, mixes and dilutions in the order they are to be performed.",
			Category -> "General",
			Abstract -> True
		},
		ResolvedManipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A list of manipulations in the order they are performed with all models resolved to samples.",
			Category -> "General"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The robotic instrument used to transfer liquid between the samples.",
			Category -> "General",
			Abstract -> True
		},
		WaterPurifiers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Model[Instrument]],
			Description -> "The instruments used in this protocol to generate water samples.",
			Category -> "General",
			Developer -> True
		},
		PreFlush -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if source lines on the macro liquid handling robot are flushed with source samples prior to dispensing.",
			Category -> "General",
			Developer -> True
		},
		VesselRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),(Object[Container]|Model[Container]),Null},
			Description -> "List of placements of vials into automation-friendly vial racks.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		PlateAdapterPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),(Object[Container]|Model[Container]),Null},
			Description -> "List of placements of plates one automation-friendly adapter racks.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		RackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]| Model[Container], Null},
			Description -> "A list of non-standard rack placements used to set-up the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		LidPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP...}},
			Relation -> {Object[Item,Lid]| Model[Item,Lid], Null},
			Description -> "A list of placements used to place lids on the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		LidSpacerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP...}},
			Relation -> {Object[Item, LidSpacer]| Model[Item, LidSpacer], Null},
			Description -> "A list of placements used to place lid spacers on the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		ValidationPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of standard rack placements used to verify the rack positions on the liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Object[Item], Null},
			Description -> "A list of deck placements used to set-up the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		FilterPlacements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "A list of deck placements used to move any required filter plates (specifically phytip racks) to their positions on the liquid handler.",
			Category -> "Placements",
			Developer -> True
		},
		ActiveTubeCarriers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack],
			Description -> "A list of tube racks on the liquid handler deck that are loaded with tubes and used in this protocol.",
			Category -> "Placements",
			Developer -> True
		},
		TaredContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]|Model[Container],
			Description -> "Containers that are tare-weighed prior to serving as manipulation destinations.",
			Category -> "General",
			Developer -> True
		},
		RequiredObjects -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {_String | _Symbol | ObjectReferenceP[] | _List | (_Symbol[_Integer,_Symbol]), _Link},
			Relation -> {Null, Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Object[Item] | Model[Item]},
			Headers -> {"Unique Identifier","Required Object"},
			Description -> "Objects required for the protocol. The first element corresponds to an identifier for the object. The second element is fulfilled to the object used.",
			Category -> "General",
			Developer -> True
		},
		InsufficientTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item]
			],
			Description -> "Tips that were originally picked for this protocol that had fewer tips than we needed for the robotic run.",
			Category -> "General",
			Developer -> True
		},
		AdditionalTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Additional tip resources that are picked to replace InsufficientTips. This field is index matched to InsufficientTips.",
			Category -> "General",
			Developer -> True
		},
		ProtocolKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The protocol key.",
			Category -> "General",
			Developer -> True
		},
		RunTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated time for completion of the liquid handling portion of the protocol.",
			Category -> "General",
			Developer -> True
		},
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item],
				Model[Item] (* TODO: Remove after item migration *)
			],
			Description -> "Pipette tips used for the protocol.",
			Category -> "General"
		},
		MacroTransfers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Program objects describing the large volume manipulations executed to complete this protocol.",
			Category -> "General"
		},
		Solvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The list of all unique solvents that were used to fill to volume.",
			Category -> "General",
			Developer->True
		},
		SolventDensityMeasurements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "The solvent samples which will have their density measured during a volumetric preparation.",
			Category -> "General",
			Developer->True
		},
		SolventTransfers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Program objects describing the large volume manipulations of solvent to bring the volumes of the solutions to the target volumes described by any FillToVolume primitives that are part of this protocol.",
			Category -> "General",
			Developer->True
		},
		CompletedSolventTransfers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Program objects describing the large volume manipulations of solvent that have been completed to bring the volumes of the solutions to the target volumes described by any FillToVolume primitives that are part of this protocol.",
			Category -> "General",
			Developer->True
		},
		InSituSolventTransfer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Program object describing a stepwise addition of solvent to bring the volume of a solution to the target volume described by a FillToVolume primitive while on a volume measuring device.",
			Category -> "General",
			Developer->True
		},
		FillToVolumeMeasurements-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description -> "Any samples that will need to have their volumes measured during a fill to volume sample manipulation.",
			Category -> "Organizational Information",
			Developer->True
		},
		FillToVolumeMethods->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FillToVolumeMethodP|Automatic,
			IndexMatching -> FillToVolumeMeasurements,
			Description -> "For each member of FillToVolumeMeasurements, the method by which to add the Solvent to the bring the stock solution up to the TotalVolume.",
			Category -> "Organizational Information",
			Developer->True
		},
		FillToVolumeVolumetricBooleans->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> FillToVolumeMeasurements,
			Description -> "For each member of FillToVolumeMeasurements, indicates if the sample is being made by a non-Volumetric method. Used as a boolean filter mask in engine since we don't want to measure the volume of samples in volumetric flasks.",
			Category -> "Organizational Information",
			Developer->True
		},
		DispensingPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "Program objects describing the large volume manipulations executed to complete this protocol.",
			Category -> "General"
		},
		PlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the fluorescence, absorbance, and luminescence measurements.",
			Category -> "General",
			Developer -> True
		},
		PlateReaderMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths for the executable files that configure the plate reader to run the experiments described in the ReadPlate primitives.",
			Category -> "General",
			Developer -> True
		},
		MinCycleTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of PlateReaderMethodFilePaths, The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			IndexMatching -> PlateReaderMethodFilePaths,
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
			Description -> "The sample to be injected first into any ReadPlate primitive assay plates.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample to be injected in any subsequent injections into any ReadPlate primitive assay plates.",
			Category -> "Injection",
			Developer -> True
		},
		InjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
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
			Description -> "The primary solvent with which to wash the injectors prior to running the experiment.",
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
			Description -> "The secondary solvent with which to wash the injectors prior to running the experiment.",
			Category -> "Injector Cleaning"
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
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which performs the pump priming of the PlateReader pumps when executed.",
			Category -> "Injection",
			Developer -> True
		},
		InjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which includes instructions to turn the syringe pumps on and off as needed and to run the cleaning solvents through the PlateReader injectors.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		OrdersFulfilled -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction, Order][Fulfillment],
			Description -> "Automatic inventory orders fulfilled by samples generated by this protocol.",
			Category -> "Inventory"
		},
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Resource, Sample][Preparation],
				Object[Resource, Sample]
			],
			IndexMatching -> Manipulations,
			Description -> "For each member of Manipulations, the resource in the parent protocol that is fulfilled by performing the requested manipulation to generate a new sample.",
			Category -> "Resources",
			Developer -> True
		},
		PreferredSampleImageOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ImagingDirectionP,
			Description -> "Indicates the preferred orientation of the images n the SamplesOut that are modified in the course of the experiment are imaged after running the experiment.",
			Category-> "Sample Post-Processing"
		},
		HamiltonDeckFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The archive containing labware and deck file used in this method.",
			Category -> "General",
			Developer->True
		},
		HamiltonManipulationsFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method file used to perform the robotic manipulations on the Hamilton liquid handler.",
			Category -> "General",
			Developer->True
		},
		LiquidHandlingPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The instrumentation trace file that monitored and recorded the pressure curves during aspiration and dispense of this robotic liquid handling.",
			Category -> "General"
		},
		LiquidHandlingPressureLogPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the instrumentation trace file that monitored and recorded the pressure curves during aspiration and dispense of this robotic liquid handling.",
			Category -> "General",
			Developer -> True
		},
		DefinedObjects -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {Null,Object[Sample]|Object[Container]},
			Description -> "Relates a Define primitive's name to the sample or container which fulfilled its reference during execution.",
			Category -> "General",
			Headers -> {"Defined Name","Object"},
			Developer -> True
		},
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Video recordings taken during the entire robotic execution of this protocol.",
			Category -> "Instrument Specifications"
		},
		InitializationStartTime->{
			Format->Single,
			Class->Expression,
			Pattern:>_?DateObjectQ,
			Description->"The time we start to initialize the liquid handler at the beginning of the method. We wait a maximum of 20 minutes after this time for a success or failure message from the instrument before further troubleshooting steps are performed.",
			Category->"Instrument Processing",
			Developer->True
		},
		VerificationCode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The object used to verify that the run was completed on the instrument.",
			Category -> "Instrument Processing",
			Developer -> True
		}
	}
}];
