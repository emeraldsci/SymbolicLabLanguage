(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Desiccate], {
	Description -> "A protocol for drying solid substances by absorbing water molecules from the samples through exposing them to a chemical desiccant in a bell jar desiccator under vacuum or non-vacuum conditions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(*General*)
		Amounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the mass of each sample to transfer from the sample's container into a desired container before drying via a desiccator (absorbing water molecules from the exposed sample by a chemical desiccant through the shared atmosphere around the sample in a desiccator).",
			Category -> "General"
		},
		SampleType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Open | Closed,
			Description -> "The type of sample that are desiccated by implementing this protocol. Open SampleType leaves the container of the sample open and isolated to actively dry the sample inside whereas Closed SampleType is for long term storage and leaves the containers closed while sharing the desiccator with many containers.",
			Category -> "General"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, DesiccantUnderVacuum, and Vacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			Category -> "General"
		},
		ValvePosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Open | Closed,
			Description -> "The state of the of vacuum valve of the desiccator. Open or Closed respectively indicate if the valve is open or closed to the vacuum pump.",
			Category -> "General"
		},
		Desiccator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Desiccator], Object[Instrument, Desiccator]],
			Description -> "The instrument that is used to dry the sample by exposing the sample with its container lid open in a bell jar which includes a chemical desiccant either at atmosphere or vacuum.",
			Category -> "General"
		},
		DesiccantPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Solid, Liquid],
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		Desiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "A hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		CheckDesiccant -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the desiccant color is examined prior to beginning the experiment. If the color indicates the desiccant is exhausted it is replaced.",
			Category -> "Desiccant"
		},
		PreparedDesiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The desiccant sample prepared from the specified Desiccant and used as the active desiccant during the experiment in this protocol.",
			Category -> "Desiccant"
		},
		DesiccantContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "The container that holds the desiccant in the desiccator during desiccation to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant",
			Developer -> True
		},
		DesiccantAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 Gram], GreaterEqualP[0 Milliliter]],
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccant"
		},
		DesiccantReplaced -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the desiccant was replaced with a new sample because the original sample was exhausted.",
			Category -> "Experimental Results"
		},
		SampleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation.",
			Category -> "Drying"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Duration of time that the sample is dried with the lid off via desiccation inside a desiccator.",
			Category -> "Drying"
		},
		DesiccationImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[EmeraldCloudFile]],
			Description -> "A link to image files from the desiccant and samples in the desiccator before and after desiccation.",
			Category -> "General"
		},

		(*Labels for simulation*)
		SampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the sample that is desiccated, for use in downstream unit operations.",
			Category -> "General"
		},
		SampleContainerLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify sample containers that are used during the desiccation step, for use in downstream unit operations.",
			Category -> "General"
		},
		ContainerOutLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the ContainerOut that the sample is transferred into after the desiccation step, for use in downstream unit operations.",
			Category -> "General"
		},
		(*Sensor Information*)
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor],
			Description -> "The pressure sensor this data was obtained using.",
			Category -> "Sensor Information"
		},
		Pressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data during desiccation process. Pressure data is recorded if the Method is Vacuum or DesiccantUnderVacuum.",
			Category -> "Sensor Information"
		},
		(*sample transfer*)
		TransferUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _List,
			Description -> "Transfer unit operations that contain the instructions for transferring samples from input containers into SampleContainer or from input containers or SampleContainer into ContainerOut.",
			Category -> "Sample Handling",
			Developer -> True
		},
		DesiccantStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			Description -> "Indicates the condition that the desiccant will be stored in when it is put away after desiccation.",
			Category -> "Storage Information"
		},
		DesiccantStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "The container that the desiccant is transferred into after desiccation for storage.",
			Category -> "Storage Information"
		},
		SamplesOutStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the non-default condition under which the desiccated sample is stored after the protocol is completed.",
			Category -> "Storage Information"
		}
	}
}];