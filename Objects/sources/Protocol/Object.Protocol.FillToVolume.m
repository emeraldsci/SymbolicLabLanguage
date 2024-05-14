(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, FillToVolume], {
	Description -> "An experiment to fill a sample up to a specified volume.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
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
			IndexMatching -> Tolerance,
			Description -> "For each member of Tolerance, indicates if the final volume measured falls within the TotalVolume \[PlusMinus] the Tolerance fields.",
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
		}
	}
}];
