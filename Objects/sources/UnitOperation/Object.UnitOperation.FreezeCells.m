(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, FreezeCells], {
	Description -> "A detailed set of parameters that specifies a single cell freezing step in a larger protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* ---------- General Fields ---------- *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The cell sample(s) frozen for long-term storage during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The cell sample(s) frozen for long-term storage during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Description -> "The cell sample(s) frozen for long-term storage during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		CellType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "For each member of SampleLink, the taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, and Yeast.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CultureAdhesion -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "For each member of SampleLink, indicates how the input cell sample physically interacts with its container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CryogenicSampleContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			Description -> "For each member of SampleLink, the desired type of container in which the cell sample is frozen and subsequently stored under cryogenic conditions.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		CryogenicSampleContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the desired type of container in which the cell sample is frozen and subsequently stored under cryogenic conditions.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
		CryogenicSampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container(s) in which the cell sample is frozen and subsequently stored under cryogenic conditions, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},
		(* ---------- Master Switch Fields ---------- *)
		CryoprotectionStrategy -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[ChangeMedia, AddCryoprotectant, None],
			Description -> "For each member of SampleLink, the manner in which the cell sample is processed prior to freezing in order to protect the cells from detrimental ice formation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		FreezingStrategy -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FreezeCellMethodP, (* InsulatedCooler | ControlledRateFreezer *)
			Description -> "The manner in which the cell sample(s) are frozen.",
			Category -> "General"
		},
		(* ---------- ChangeMedia Fields ---------- *)
		CellPelletCentrifuge -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "For each member of SampleLink, the centrifuge used to pellet the cell sample in order to remove the existing media and replace with cryoprotectant media.",
			Category -> "Pelleting",
			IndexMatching -> SampleLink
		},
		CellPelletTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration of time for which the sample is centrifuged in order to pellet the cells, enabling removal of existing media.",
			Category -> "Pelleting",
			IndexMatching -> SampleLink
		},
		CellPelletIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 RPM], GreaterP[0 GravitationalAcceleration]],
			Units -> None,
			Description -> "For each member of SampleLink, the rotational speed or force applied to the cell sample by centrifugation in order to create a pellet, enabling removal of existing media.",
			Category -> "Pelleting",
			IndexMatching -> SampleLink
		},
		CellPelletSupernatantVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of supernatant to be removed from the cell sample following pelleting.",
			Category -> "Pelleting",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CellPelletSupernatantVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of supernatant to be removed from the cell sample following pelleting.",
			Category -> "Pelleting",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		(* ---------- Cryoprotection Fields ---------- *)
		CryoprotectantSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the solution to be mixed with the cell sample(s) to reduce ice formation during freezing.",
			Category -> "Cryoprotection",
			IndexMatching -> SampleLink
		},
		CryoprotectantSolutionVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of CryoprotectantSolution to be added to the cell sample.",
			Category -> "Cryoprotection",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CryoprotectantSolutionVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of CryoprotectantSolution to be added to the cell sample.",
			Category -> "Cryoprotection",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		CryoprotectantSolutionTemperature -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Ambient, Chilled],
			Description -> "The temperature of the CryoprotectantSolution(s) prior to their addition to the cell sample(s).",
			Category -> "Cryoprotection"
		},
		(* ---------- Aliquoting Fields ---------- *)
		AliquotVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of suspended cell sample that is transferred into the CryogenicSampleContainer.",
			Category -> "Aliquoting",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		AliquotVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of suspended cell sample that is transferred into the CryogenicSampleContainer.",
			Category -> "Aliquoting",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		(* ---------- General Cell Freezing Fields ---------- *)
		FreezingRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "For each member of SampleLink, the insulated cooler rack or controlled rate freezer-compatible sample rack used to freeze the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SampleLink
		},
		Freezer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, ControlledRateFreezer],
				Object[Instrument, ControlledRateFreezer],
				Model[Instrument, Freezer],
				Object[Instrument, Freezer]
			],
			Description -> "For each member of SampleLink, the device used to cool the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SampleLink
		},
		(* ---------- ControlledRateFreezer Fields ---------- *)
		TemperatureProfile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The series of cooling steps applied to the cell sample.",
			Category -> "Cell Freezing"
		},
		(* ---------- InsulatedCooler Fields ---------- *)
		Coolant -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SampleLink, the liquid that fills the chamber of the insulated cooler in which the sample rack is immersed to achieve gradual cooling of the cell sample.",
			Category -> "Cell Freezing",
			IndexMatching -> SampleLink
		},
		InsulatedCoolerFreezingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the cell sample within an insulated cooler is kept within the Freezer to freeze the cells prior to being transported to SamplesOutStorageCondition.",
			Category -> "Cell Freezing"
		},
		InsulatedCoolerContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			Description -> "For each member of SampleLink, the container into which the Coolant and FreezerRack (for InsulatedCooler strategies) used to freeze the cell sample is placed.",
			Category -> "Cell Freezing",
			IndexMatching -> SampleLink
		},
		InsulatedCoolerFreezingCondition -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "For each member of SampleLink, the conditions under which the cell sample is frozen for InsulatedCooler protocols.",
			Category -> "Cell Freezing",
			IndexMatching -> SampleLink
		},
		(* ---------- Storage Fields ---------- *)
		SamplesOutStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellStorageTypeP,
			Description -> "For each member of SampleLink, the long-term storage condition for the cell sample after freezing.",
			Category -> "Sample Storage",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		SamplesOutStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "For each member of SampleLink, the long-term storage condition for the cell sample after freezing.",
			Category -> "Sample Storage",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		}
	}
}];




