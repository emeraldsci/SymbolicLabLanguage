(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, RoboticCellPreparation], {
	Description->"A protocol that prepares cell samples (ex. incubation, washing, splitting, imaging etc.) for further experimentation, robotically on a work cell.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InputUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The individual steps of the protocol that should be executed, as inputted by the user to the experiment function.",
			Category -> "General"
		},
		OptimizedUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The transformed steps of the protocol, re-arranged to be executed in the most efficient manner by the protocol.",
			Category -> "General"
		},
		CalculatedUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The optimized unit operations with fully specified options, in the order they will be executed in the laboratory.",
			Category -> "General"
		},
		OutputUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation][Protocol],
			Description -> "The unit operations, after they have been executed in the lab. These unit operations contain additional data about their execution (such as pressure traces, environmental data, etc.) as well as the specific samples, containers, and items that were used in the laboratory.",
			Category -> "General"
		},
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, LiquidHandler],
				Model[Instrument, LiquidHandler]
			],
			Description -> "The liquid handler work cell used to perform the protocol.",
			Category -> "General",
			Abstract -> True
		},
		ColonyHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,ColonyHandler],
				Model[Instrument,ColonyHandler]
			],
			Description -> "The colony handler work cell used to perform the protocol.",
			Category -> "General",
			Abstract -> True
		},
		HamiltonDeckFiles-> {
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
			Description -> "The method file used to perform the robotic manipulations on the Hamilton liquid handler as specified in the OutputUnitOperations.",
			Category -> "General",
			Developer -> True
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
		LabeledObjects -> {
			Format -> Multiple,
			Class -> {String,Link},
			Pattern :> {_String,_Link},
			Relation -> {
				Null,
				Alternatives[
					Model[Sample],
					Object[Sample],
					Model[Container],
					Object[Container],
					Model[Item],
					Object[Item],
					Model[Part],
					Object[Part],
					Model[Plumbing],
					Object[Plumbing]
				]
			},
			Description -> "Relates a LabelSample/LabelContainer's label to the sample or container which fulfilled the label during execution.",
			Category -> "General",
			Headers -> {"Label","Object"}
		},
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Integrated instruments required for the protocol.",
			Category -> "General"
		},
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item],
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description -> "Objects that are required for this protocol. This includes both labeled and non-labeled objects.",
			Category -> "General",
			Developer -> True
		},
		RequiredUnbaggingObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Item],
				Object[Part],
				Object[Plumbing]
			],
			Description -> "RequiredObjects that are currently in an aseptic barrier and required unbagging inside of biosafety cabinet for this protocol.",
			Category -> "General",
			Developer -> True
		},
		RequiredCoveringObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "RequiredUnbaggingObjects that are currently without any cover and required covering inside of biosafety cabinet for this protocol.",
			Category -> "General",
			Developer -> True
		},
		UnbaggingEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, BiosafetyCabinet],
				Object[Instrument, BiosafetyCabinet],
				Object[Instrument, HandlingStation, BiosafetyCabinet],
				Model[Instrument, HandlingStation, BiosafetyCabinet]
			],
			Description -> "The environment (Biosafety Cabinet) in which unbagging of RequiredUnbaggingObjects will be performed. RequiredObjects contained in aseptic barriers will first be moved into the UnbaggingEnvironment, taken out of aseptic barriers, put cover on if uncovered, before both the RequiredObjects and the aseptic barrier bags moved back onto the operator cart.",
			Category -> "General",
			Abstract -> True
		},
		RequiredTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The tips that are required for this robotic protocol.",
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
		FutureLabeledObjects -> {
			Format -> Multiple,
			Class -> Expression,
			(* futureLabel_String -> Alternatives[{existingLabel_String, relationToFutureLabel:(Container|LocationPositionP)}, labelField_LabelField] *)
			Pattern :> (_String -> Alternatives[{_String, Container|LocationPositionP}, _LabelField]),
			Relation -> Null,
			Units -> None,
			Description -> "LabeledObjects will not exist until the protocol has finished running in the lab (created at parse time). For example, destination samples that are given labels are only created by Transfer's parser and therefore can only be added to the LabeledObjects field after parse time.",
			Category -> "General",
			Developer -> True
		},
		NumberOfManipulations -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "For each member of OutputUnitOperations (expanded to include RoboticUnitOperations), the number of HSL manipulations used to perform the actions indicated in the unit operation.",
			Category -> "General"
		},
		RunTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The estimated time for completion of the liquid handling portion of the protocol.",
			Category -> "General"
		},

		(* -- DEVELOPER FIELDS FOR ENGINE DECK PLACEMENTS -- *)
		(* Fields to unbag sterile required objects in the biosafety cabinet *)
		BiosafetyCabinetPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container],
					Model[Container],
					Object[Sample],
					Model[Sample],
					Object[Instrument],
					Model[Instrument],
					Object[Item],
					Model[Item]
				],
				Alternatives[
					Object[Instrument, BiosafetyCabinet],
					Model[Instrument, BiosafetyCabinet],
					Object[Instrument, HandlingStation, BiosafetyCabinet],
					Model[Instrument, HandlingStation, BiosafetyCabinet],
					Object[Container, WasteBin],
					Model[Container, WasteBin]
				],
				Null
			},
			Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
			Description -> "The specific positions into which RequiredUnbaggingObjects are moved into the UnbaggingEnvironment.",
			Category -> "General",
			Developer -> True
		},
		CollectionObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Sample],
				Object[Instrument]
			],
			Description -> "The objects to remove from the UnbaggingEnvironment's work surface when before it is released.",
			Category -> "General",
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

		(* NOTE: Both the hamilton liquid handler and the integrated incubators have Object[Container, Deck]s so we need deck placement *)
		(* tasks to move items into them. *)
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			(* NOTE: This can be a Model[Container] if we have a liquid handler adapter that we need to use. *)
			Relation -> {Model[Container]|Object[Container]|Object[Sample]|Object[Item], Null},
			Description -> "A list of deck placements used to set-up the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		IncubatorPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container]|Object[Container]|Object[Sample]|Object[Item], Null},
			Description -> "A list of deck placements used to place cell containers into the integrated incubator in the biology work cell.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},

		(* NOTE: The off deck placements (aka the storage towers) are just shelves (not decks) and use a regular movement task. *)
		OffDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link,_Link, LocationPositionP},
			Relation -> {
				(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),
				(Object[Container]|Model[Container]|Object[Instrument]),
				Null
			},
			Description -> "A list of off-deck placements used to set-up the robotic liquid handler off-deck storage locations.",
			Headers ->  {"Object to Place","Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		OffDeckPlateSealPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {
				(Model[Item,PlateSeal]|Object[Item,PlateSeal]),
				(Object[Container,PlateSealMagazine]|Model[Container,PlateSealMagazine]),
				Null
			},
			Description -> "A list of off-deck placements used to load plate seals from off-deck storage locations to magazines.",
			Headers ->  {"Object to Place","Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		MagazinePlacements-> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				(Object[Container,PlateSealMagazine]|Model[Container,PlateSealMagazine]),
				(Object[Container,MagazineRack]|Model[Container,MagazineRack]),
				Null
			},
			Description -> "A list of off-deck placements used to place loaded plate seal magazines on magazine parking position.",
			Headers ->  {"Object to Place", "Destination Object","Destination Position"},
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
		NumberOfPreloadedFoilSeals-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units-> None,
			Description -> "The number of Hamilton foil plate seals loaded to the plate seal magazine already.",
			Category -> "General",
			Developer -> True
		},
		NumberOfPreloadedClearSeals-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units-> None,
			Description -> "The number of Hamilton clear plate seals loaded to the plate seal magazine already.",
			Category -> "General",
			Developer -> True
		},
		AdditionalFoilSealResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,PlateSeal]|Object[Item,PlateSeal],
			Description -> "The additional Hamilton foil plate seals need to pick for current repick step.",
			Category -> "General",
			Developer -> True
		},
		AdditionalClearSealResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,PlateSeal]|Object[Item,PlateSeal],
			Description -> "The additional Hamilton clear plate seals need to pick for current repick step.",
			Category -> "General",
			Developer -> True
		},
		AdditionalLidResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Lid]|Object[Item,Lid],
			Description -> "The additional sterile universal clear Lid need to cover RequiredUnbaggingObjects during unbagging task.",
			Category -> "General",
			Developer -> True
		},
		TipRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container] | Model[Container]),
			Description -> "Sterile hamilton tip transporters that will be used to transport tips from the VLM to the sterile Hamilton enclosure.",
			Category -> "General",
			Developer -> True
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
			Description -> "List of placements of plates on automation-friendly adapter racks.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
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
		TipPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			(* NOTE: We need to put Object[Container] here because we can place tip boxes onto the deck. *)
			Relation -> {Model[Item]|Object[Item]|Object[Container], Null},
			Description -> "A list of tip placements used to set-up the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		TipAdapter->{
			Format-> Single,
			Class-> Link,
			Pattern:> _Link,
			Relation->Alternatives[
				Model[Item],
				Object[Item]
			],
			Description->"Tips adapter used in this manipulation for offset tip pickup by the multiprobe head.",
			Category->"Placements",
			Developer->True
		},
		InitialContainerIdlingConditions -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, WorkCellIdlingConditionP},
			Relation -> {Model[Container]|Object[Container]|Model[Sample]|Object[Sample], Null},
			Description -> "A list of containers and their initial conditions they should be stored at when placed on the liquid handler.",
			Headers ->  {"Container", "Initial Idling Condition"},
			Category -> "Placements",
			Developer -> True
		},

		(* -- Primary Plate Reader Fields -- *)
		(* NOTE: These fields are ONLY filled out if the primary plate reader has injections. Otherwise, we don't fill out these fields. *)
		PrimaryPlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the fluorescence, absorbance, and luminescence measurements.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample to be injected first into any ReadPlate primitive assay plates on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderSecondaryInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample to be injected in any subsequent injections into any ReadPlate primitive assay plates on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderInjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderLine1PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 1 injector is washed before and after running the experiment on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderLine1SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 1 injector is washed before and after running the experiment on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderLine2PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 2 injector is washed before and after running the experiment on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderLine2SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 2 injector is washed before and after running the experiment on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderSolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect waste during injector cleaning on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderSecondarySolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "An additional container used to collect overflow waste during injector cleaning on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderPreppingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position prior to running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderFlushingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position after running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderWasteContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the waste container(s) into position on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderPrimaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move primary purging solvents into position for cleaning before and after running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPlateReaderSecondaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move secondary purging solvents into position for cleaning before and after running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPlateReaderPurgingTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for cleaning before and after running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPlateReaderStorageTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for storage when experiment is not running on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPlateReaderInjectionTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for sample injection when running the experiment on PrimaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPlateReaderPumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which performs the pump priming of the PlateReader pumps when executed on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		PrimaryPlateReaderInjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which includes instructions to turn the syringe pumps on and off as needed and to run the cleaning solvents through the PlateReader injectors on PrimaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},

		(* -- Secondary Plate Reader Fields -- *)
		(* NOTE: These fields are ONLY filled out if the secondary plate reader has injections. Otherwise, we don't fill out these fields. *)
		SecondaryPlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the fluorescence, absorbance, and luminescence measurements.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample to be injected first into any ReadPlate primitive assay plates on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderSecondaryInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample to be injected in any subsequent injections into any ReadPlate primitive assay plates on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderInjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderLine1PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 1 injector is washed before and after running the experiment on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderLine1SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 1 injector is washed before and after running the experiment on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderLine2PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 2 injector is washed before and after running the experiment on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderLine2SecondaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the line 2 injector is washed before and after running the experiment on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderSolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect waste during injector cleaning on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderSecondarySolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "An additional container used to collect overflow waste during injector cleaning on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderPreppingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position prior to running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderFlushingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position after running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderWasteContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the waste container(s) into position on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderPrimaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move primary purging solvents into position for cleaning before and after running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPlateReaderSecondaryPurgingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move secondary purging solvents into position for cleaning before and after running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPlateReaderPurgingTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for cleaning before and after running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPlateReaderStorageTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for storage when experiment is not running on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPlateReaderInjectionTubingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Plumbing, Tubing] | Object[Plumbing, Tubing] ,Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move tubing into magnetic standoff position for sample injection when running the experiment on SecondaryPlateReader.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondaryPlateReaderPumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which performs the pump priming of the PlateReader pumps when executed on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},
		SecondaryPlateReaderInjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file which includes instructions to turn the syringe pumps on and off as needed and to run the cleaning solvents through the PlateReader injectors on SecondaryPlateReader.",
			Category -> "Injection",
			Developer -> True
		},

		(* -- Temporary Plate Reader Fields -- *)
		(* NOTE: We use the helper functions copyOverPrimaryPlateReaderFields and copyOverSecondaryPlateReaderFields to *)
		(* populate these fields after compile and after the waste containers are resource picked so that we can reuse *)
		(* the plate reader procedures (they use these field names). We then clear these fields after we're finished. *)
		PlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to perform the fluorescence, absorbance, and luminescence measurements.",
			Category -> "Injection",
			Developer -> True
		},

		(* NOTE: These two fields aren't copied over and exist after compile. They're used to populate the min cycle time in the method files. *)
		PlateReaderMethodFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths for the executable files that configure the plate reader to run the experiments described in the ReadPlate primitives.",
			Category -> "Injection",
			Developer -> True
		},
		MinCycleTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of PlateReaderMethodFilePaths, The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			IndexMatching -> PlateReaderMethodFilePaths,
			Category -> "Injection",
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
		Line1PrimaryPurgingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the line 1 injector is washed before and after running the experiment.",
			Category -> "Injection",
			Developer -> True
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
			Category -> "Injection",
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
			Category -> "Injection",
			Developer -> True
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
			Category -> "Injection",
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
			Category -> "Injection",
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
			Category -> "Injection",
			Developer -> True
		},
		PreppingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position prior to running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		FlushingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injection",
			Developer -> True
		},
		WasteContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the waste container(s) into position.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Injection",
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
			Category -> "Injection",
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
		ProtocolKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The protocol key.",
			Category -> "General",
			Developer -> True
		},
		CellContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample]
			],
			Description -> "Containers with cell contents, that could be enqueued for regular post-processing process(MeasureWeight, MeasureVolume, ImageSample).",
			Developer->True,
			Category -> "Sample Post-Processing"
		},
		LivingCellContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample]
			],
			Description -> "Containers with living cell contents, which are stored in an incubator when not being used in a procedure.",
			Developer->True,
			Category -> "Sample Post-Processing"
		},
		PostProcessingContainers-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item],
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample]
			],
			Description -> "Containers without any cell contents in there, that could be enqueued for regular post-processing process(MeasureWeight, MeasureVolume, ImageSample).",
			Developer->True,
			Category -> "Sample Post-Processing"
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
				Object[Resource, Sample][Preparation]
			],
			Description -> "The resource in the parent protocol that is fulfilled by performing the requested sample preparation to generate a new sample.",
			Category -> "Resources",
			Developer -> True
		},

		(* integrated microscope temperature and CO2 settings *)
		MicroscopeTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature of the stage where the sample container is placed during imaging.",
			Category->"Instrument Setup"
		},
		MicroscopeCO2Percentage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"Indicates percentage of CO2 in the gas mixture that will be provided to the sample during imaging.",
			Category->"Instrument Setup"
		},
		(* NOTE: This field is deprecated in favor of the Streams field. *)
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A video recording taken during the entire robotic execution of this protocol.",
			Category -> "Instrument Specifications",
			Developer -> True
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
		},

		(* NOTE: These fields are for qpix protocols *)
		PrimaryWashSolutionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sanitization sample to be placed in wash bath 1 on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		SecondaryWashSolutionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sanitization sample to be placed in wash bath 2 on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		TertiaryWashSolutionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sanitization sample to be placed in wash bath 3 on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		PrimaryWashBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container,WashBath]],
			Description -> "The wash bath placed in the wash bath 1 slot on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		SecondaryWashBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container,WashBath]],
			Description -> "The wash bath placed in the wash bath 2 slot on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		TertiaryWashBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container,WashBath]],
			Description -> "The wash bath placed in the wash bath 3 slot on the qpix.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		WashBathWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel] | Object[Container, Vessel],
			Description -> "The container used to temporally store the waste generated from PrimaryWashBath, SecondaryWashBatch, and TertiaryWashBath.",
			Category -> "General",
			Developer -> True
		},
		WashBathWasteTransferFunnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Funnel],
				Object[Part,Funnel]
			],
			Description -> "The funnel used to transfer the waste generated from PrimaryWashBath, SecondaryWashBatch, and TertiaryWashBath to the WashBathWasteContainer.",
			Category -> "General",
			Developer -> True
		},
		LightTableHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container,Rack], Model[Container,Rack]],
			Description -> "The container that sits on top of the qpix light table to align any plates placed on top of it.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		LightTableHolderDeckPlacement -> {
			Format -> Single,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Alternatives[Object[Container,Rack],Model[Container,Rack]], Null},
			Headers -> {"Holder","Placement Location"},
			Description -> "The deck placement used to place the light table holder on the qpix deck at the beginning of the protocol.",
			Category -> "Instrument Setup",
			Developer -> True
		}
	}
}];
