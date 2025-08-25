(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, FreezeCells], {
	Description -> "A protocol for the freezing of cells for long-term storage cryogenic storage.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* ---------- General Fields ---------- *)
		CellTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "For each member of SamplesIn, the taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, and Yeast.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		CultureAdhesions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "For each member of SamplesIn, indicates how the input cell sample physically interacts with its container.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		CryoprotectionStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[ChangeMedia, AddCryoprotectant, None],
			Description -> "For each member of SamplesIn, the manner in which the cell sample is processed prior to freezing in order to protect the cells from detrimental ice formation.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "The estimated amount of time remaining until when the current round of instrument processing is projected to finish.",
			Category -> "General",
			Units -> Minute,
			Developer -> True
		},
		(* ---------- ChangeMedia Fields ---------- *)
		CellPelletCentrifuges -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "For each member of SamplesIn, the centrifuge used to pellet the cell sample in order to remove the existing media and replace with cryoprotectant media.",
			Category -> "Pelleting",
			IndexMatching -> SamplesIn
		},
		CellPelletTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the duration of time for which the sample is centrifuged in order to pellet the cells, enabling removal of existing media.",
			Category -> "Pelleting",
			IndexMatching -> SamplesIn
		},
		CellPelletIntensities -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 RPM], GreaterP[0 GravitationalAcceleration]],
			Units -> None,
			Description -> "For each member of SamplesIn, the rotational speed or force applied to the cell sample by centrifugation in order to create a pellet, enabling removal of existing media.",
			Category -> "Pelleting",
			IndexMatching -> SamplesIn
		},
		CellPelletSupernatantVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of supernatant to be removed from the cell sample following pelleting.",
			Category -> "Pelleting",
			IndexMatching -> SamplesIn
		},
		FreezeCellsPelletUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the pelleting of the cell sample(s) to remove existing media prior to freezing.",
			Category -> "Pelleting",
			Developer -> True
		},
		FreezeCellsPelletProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The protocol used to pellet the cell sample(s) to remove existing media in a cell freezing experiment.",
			Category -> "Pelleting",
			Developer -> True
		},
		(* ---------- Cryoprotection Fields ---------- *)
		CryoprotectantSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SamplesIn, the solution to be added to the cell sample to reduce ice formation during freezing.",
			Category -> "Cryoprotection",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		CryoprotectantSolutionsToAutoclave -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SamplesIn, the solution to be autoclaved prior to addition to the cell sample to reduce ice formation during freezing.",
			Category -> "Cryoprotection",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CryoprotectantSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of CryoprotectantSolution is added to the cell sample.",
			Category -> "Cryoprotection",
			IndexMatching -> SamplesIn
		},
		CryoprotectantSolutionTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, Chilled],
			Description -> "The temperature of the CryoprotectantSolution(s) prior to their addition to the cell sample(s).",
			Category -> "Cryoprotection"
		},
		CryoprotectantSolutionChillingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the CryoprotectantSolution is chilled prior to its addition to the cell sample.",
			Category -> "Cryoprotection",
			Developer -> True
		},
		CryoprotectantAutoclaveProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Autoclave]],
			Description -> "The protocol used to autoclave CryoprotectantSolutions before adding to the input cell sample(s) prior to freezing in a cell freezing experiment.",
			Category -> "Cryoprotection",
			Developer -> True
		},
		FreezeCellsTransferUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of the input cell sample(s) to CryogenicSampleContainers, resuspending the cells, and transferring of CryoprotectantSolutions to CryogenicSampleContainers prior to freezing.",
			Category -> "Cryoprotection",
			Developer -> True
		},
		FreezeCellsTransferProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The protocol specifying the aliquoting of the input cell sample(s) to CryogenicSampleContainers, resuspending the cells, and transferring of CryoprotectantSolutions to CryogenicSampleContainers prior to freezing.",
			Category -> "Cryoprotection",
			Developer -> True
		},
		(* ---------- General Cell Freezing Fields ---------- *)
		CryogenicSampleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			Description -> "For each member of SamplesIn, the container in which the cell sample is frozen and subsequently stored under cryogenic conditions.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn
		},
		CryogenicSampleContainerLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the container label in which the cell sample is frozen and subsequently stored under cryogenic conditions used in FreezeCellsTransferUnitOperations.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		FreezingRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "For each member of SamplesIn, the insulated cooler rack or controlled rate freezer-compatible sample rack used to freeze the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn
		},
		Freezers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, ControlledRateFreezer],
				Object[Instrument, ControlledRateFreezer],
				Model[Instrument, Freezer],
				Object[Instrument, Freezer]
			],
			Description -> "For each member of SamplesIn, the device used to cool the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		FreezingStartTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the recording of environmental data inside the freezer begins.",
			Category -> "Cell Freezing"
		},
		FreezingEndTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the recording of environmental data inside the freezer ceases.",
			Category -> "Cell Freezing"
		},
		FreezerSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sensor, Temperature]],
			Description -> "The temperature sensor object(s) inside Freezers whose data are recorded while the cell samples are being frozen.",
			Category -> "Cell Freezing",
			Developer -> True
		},
		FreezerEnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data, Temperature]],
			Description -> "For each member of FreezerSensors, the temperature data recorded from the sensor during freezing.",
			Category -> "Cell Freezing",
			IndexMatching -> FreezerSensors
		},
		(* ---------- ControlledRateFreezer Fields ---------- *)
		TemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The series of cooling steps applied to the cell sample.",
			Category -> "Cell Freezing"
		},
		VIAFreezeTemperatureProfile -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "A list of instruction strings describing the construction of a temperature profile on the VIA Freeze Research controlled rate freezer.",
			Category -> "Cell Freezing",
			Developer -> True
		},
		VIAFreezeHoldSegment -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "A list of Booleans indicating whether or not a particular segment of a temperature profile on the VIA Freeze Research controlled rate freezer is to be held at its final temperature until the operator advances the profile using the instrument touchscreen.",
			Category -> "Cell Freezing",
			Developer -> True
		},
		(* ---------- InsulatedCooler Fields ---------- *)
		Coolants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, the liquid that fills the chamber of the insulated cooler in which the sample rack is immersed to achieve gradual cooling of the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn
		},
		CoolantVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of liquid that fills the chamber of the insulated cooler in which the sample rack is immersed to achieve gradual cooling of the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		FreezeCellsCoolantTransferUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the transfer of Coolants to the InsulatedCoolerContainers for to a cell freezing experiment.",
			Category -> "Cell Freezing",
			Developer -> True
		},
		FreezeCellsCoolantTransferProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The transfer protocol used to fill InsulatedCoolerContainers with Coolants in a cell freezing experiment.",
			Category -> "Cell Freezing",
			Developer -> True
		},
		InsulatedCoolerFreezingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the cell sample within an insulated cooler is kept within the Freezer to freeze the cells prior to being transported to SamplesOutStorageCondition.",
			Category -> "Cell Freezing"
		},
		InsulatedCoolerFreezingConditions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SamplesIn, the conditions under which the cell sample is frozen for InsulatedCooler protocols.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		InsulatedCoolerContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			Description -> "For each member of SamplesIn, the container into which the Coolant and FreezerRack (for InsulatedCooler strategies) used to freeze the cell sample is placed.",
			Category -> "Cell Freezing",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		(* ---------- Storage Fields ---------- *)
		SamplesOutStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellStorageTypeP,
			Description -> "For each member of SamplesIn, the long-term storage condition for the cell sample after freezing.",
			Category -> "Sample Storage",
			IndexMatching -> SamplesIn
		},
		SamplesOutStorageConditionObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SamplesIn, the long-term storage condition for the cell sample after freezing.",
			Category -> "Sample Storage",
			IndexMatching -> SamplesIn
		},
		CryogenicGloves -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Glove], Object[Item, Glove]],
			Description -> "The gloves used to safely store samples in CryogenicStorage during this protocol.",
			Category -> "Sample Storage",
			Developer -> True
		},
		CryogenicSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "The cell samples to be stored in cryogenic storage at the conclusion of the protocol.",
			Category -> "Sample Storage",
			Developer -> True
		},
		NonCryogenicSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
			Description -> "The cell samples to be stored in non-cryogenic storage at the conclusion of the protocol.",
			Category -> "Sample Storage",
			Developer -> True
		}

	}
}];




