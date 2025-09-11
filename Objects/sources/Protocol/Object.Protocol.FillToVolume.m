(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, FillToVolume], {
	Description -> "An experiment to fill a sample up to a specified volume.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		MaxNumberOfOverfillingRepreparations -> {
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The maximum number of times the FillToVolume protocol can be repeated in the event of target volume overfilling. When a repreparation is triggered, the same inputs and options are used.",
			Category->"General"
		},
		OverfillingRepreparations -> {
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,FillToVolume]],
			Description->"The repeat FillToVolume protocol that is automatically enqueued when target volume overfilling occurs. The new protocol uses the same inputs and options as the original.",
			Category->"General"
		},
		TotalVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Liter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the total volume of the sample after Solvent is added.",
			Category -> "Fill to Volume",
			Abstract -> True
		},
		Solvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the solvent used to dilute the sample up to the requested total volume.",
			Category -> "Fill to Volume"
		},
		FillToVolumeMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FillToVolumeMethodP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the method by which to add the Solvent to the bring the solution up to the TotalVolume.",
			Category -> "Fill to Volume"
		},
		GraduationFillings -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the Solvent specified in the stock solution model is added to bring the stock solution model up to the TotalVolume based on the horizontal markings on the container indicating discrete volume levels, not necessarily in a volumetric flask.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		SolventStorage -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			IndexMatching -> Solvents,
			Description -> "For each member of Solvents, the storage conditions under which each solvent used by this experiment should be stored after the protocol is completed.",
			Category -> "Sample Storage"
		},
		Tolerance -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 Percent] | GreaterP[0 Milliliter],
			IndexMatching -> TotalVolumes,
			Description -> "For each member of TotalVolumes, the acceptable percent or volume variation of volume measurement for a given sample.",
			Category -> "Fill to Volume"
		},
		TargetVolumeToleranceAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the final measured volume of the sample falls within the specified TotalVolume +/- Tolerance range. If the sample volume is less than TotalVolume - Tolerance, additional solvent is transferred. At the end of the protocol, if TargetVolumeToleranceAchieved is False, it means that the final sample volume exceeds TotalVolume + Tolerance. In the case of a Volumetric FillToVolume operation, this corresponds to the liquid level in the volumetric flask being above the graduation line.",
			Category -> "Fill to Volume"
		},

		(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. *)
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
			Description -> "Objects required for the protocol.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		(* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Instruments required for the protocol.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		SampleImagingProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ImageSample],
			Description -> "The ImageSample protocol that asks the operator to image the filled volumetric flasks.",
			Category -> "Sample Post-Processing"
		},
		MeniscusImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the cloud file that stores the images of the filled volumetric flasks, if the sample is not fulfilled by Volumetric FillToVolume method, the corresponding value will be Null.",
			Category -> "Sample Post-Processing"
		}
	}
}];
