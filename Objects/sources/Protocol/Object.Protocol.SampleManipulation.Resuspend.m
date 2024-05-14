(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, SampleManipulation, Resuspend], {
	Description -> "A protocol for resuspending solid samples in a solvent.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ResuspensionOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if the samples were resuspended via mixing after liquid was added to each sample in serial, or only after liquid was added to all samples, in parallel.",
			Category -> "General"
		},
		ResuspensionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The samples to which liquid is added for resuspension.",
			Category -> "Sample Preparation"
		},
		ResuspensionAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0 * Milligram] | GreaterP[0 * Unit, 1 * Unit],
			Units -> None,
			Description -> "For each member of ResuspensionSamples, the amount of sample resuspended with the volume of diluent.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of ResuspensionSamples, the total volume of diluent used to resuspend the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionDiluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of ResuspensionSamples, the liquid used to resuspend the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionConcentratedBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of ResuspensionSamples, the concentrated buffer used to resuspend the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionBufferDiluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of ResuspensionSamples, the buffer diluent used to dilute the ConcentratedBuffer used to resuspend the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionBufferDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of ResuspensionSamples, the dilution factor by which the concentrated buffer is diluted to obtain a 1x buffer concentration after resuspension.",
			Category -> "Sample Preparation",
			IndexMatching -> ResuspensionSamples
		},
		ResuspensionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers in which the samples were resuspended.",
			Category -> "Sample Preparation"
		}
	}
}];
