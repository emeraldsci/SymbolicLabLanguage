(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, cDNA], {
	Description->"Model information for a complementary DNA (cDNA) strand that is created by reverse transcription of RNA and extracted from a cell sample.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Enthalpy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> EnergyP,
			Units -> KilocaloriePerMole,
			Description -> "The expected binding enthalpy for the binding of this nucleic acid. If Watson-Crick paring is not present in this structure, the Enthalpy is calculated with the structure bound to its reverse complement.",
			Category -> "Physical Properties"
		},
		Entropy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> EntropyP,
			Units -> CaloriePerMoleKelvin,
			Description -> "The expected binding entropy for the binding of this nucleic acid. If Watson-Crick paring is not present in this structure, the Entropy is calculated with the structure bound to its reverse complement.",
			Category -> "Physical Properties"
		},
		FreeEnergy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> EnergyP,
			Units -> KilocaloriePerMole,
			Description -> "The expected Gibbs Free Energy for the binding of nucleic acid at 37 Celsius. If Watson-Crick paring is not present in this structure, the Gibbs Free Energy is calculated with the structure bound to its reverse complement.",
			Category -> "Physical Properties"
		},
		Simulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Simulation, Enthalpy][ReactantModels],
				Object[Simulation, Enthalpy][ProductModels],
				Object[Simulation, Entropy][ReactantModels],
				Object[Simulation, Entropy][ProductModels],
				Object[Simulation, EquilibriumConstant][ReactantModels],
				Object[Simulation, EquilibriumConstant][ProductModels],
				Object[Simulation, FreeEnergy][ReactantModels],
				Object[Simulation, FreeEnergy][ProductModels],
				Object[Simulation, MeltingTemperature][ReactantModels],
				Object[Simulation, MeltingTemperature][ProductModels],
				Object[Simulation, Folding][StartingMaterial],
				Object[Simulation, Hybridization][StartingMaterials]
			],
			Description -> "Simulations of molecular interactions which use this nucleic acid molecule.",
			Category -> "Model Information"
		},
		ReactionMechanisms -> { (* TODO: Right now our reaction mechanisms only support nucleic acids, but in the future this field should go into Model[Molecule] and the other base identity model types. *)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[ReactionMechanism][Species],
			Description -> "Reaction mechanisms in which this nucleic acid is involved.",
			Category -> "Model Information"
		},
		Reactions -> { (* TODO: Right now our reactions only support nucleic acids, but in the future this field should go into Model[Molecule] and the other base identity model types. *)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Reaction][ProductModels],
				Model[Reaction][ReactantModels]
			],
			Description -> "Reactions in which this nucleic acid is involved.",
			Category -> "Model Information"
		},
		PrimerSets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[PrimerSet][ForwardPrimer],
				Model[PrimerSet][ReversePrimer],
				Model[PrimerSet][Beacon],
				Model[PrimerSet][BeaconTarget],
				Model[PrimerSet][SenseAmplicon],
				Model[PrimerSet][AntisenseAmplicon],
				Model[PrimerSet][Target]
			],
			Description -> "PCR (polymerase chain reaction) primer sets that contain this nucleic acid.",
			Category -> "Model Information"
		},
		Cells -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Cell][cDNAs],
			Description -> "The cell lines that synthesize this sequence of cDNA.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ReverseTranscriptaseBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model for the reverse transcriptase buffer that is used to synthesize this sequence of cDNA.",
			Category -> "Organizational Information"
		},
		ReverseTranscriptaseEnzyme -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model for the reverse transcriptase enzyme that is used to synthesize this sequence of cDNA.",
			Category -> "Organizational Information"
		}
	}
}];
