(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, SampleManipulation, Dilute], {
	Description -> "A protocol for diluting solid samples in a solvent.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		DilutionOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadOrderP,
			Description -> "Indicates if the samples were diluted via mixing after liquid was added to each sample in serial, or only after liquid was added to all samples, in parallel.",
			Category -> "General"
		},
		DilutionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The samples to which liquid is added for dilution.",
			Category -> "Sample Preparation"
		},
		DilutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Microliter,
			Description -> "For each member of DilutionSamples, the amount of sample diluted with the volume of diluent.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		DiluentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of DilutionSamples, the total volume of diluent used to dilute the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		Diluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of DilutionSamples, the liquid used to dilute the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		DilutionConcentratedBuffers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of DilutionSamples, the concentrated buffer that is itself diluted which ultimately dilutes the sample.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		DilutionBufferDiluents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of DilutionSamples, the buffer diluent used to dilute the ConcentratedBuffer used to dilute the samples.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		DilutionBufferDilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of DilutionSamples, the dilution factor by which the concentrated buffer is diluted to obtain a 1x buffer concentration after dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> DilutionSamples
		},
		DilutionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers in which the samples were diluted.",
			Category -> "Sample Preparation"
		}
	}
}];
