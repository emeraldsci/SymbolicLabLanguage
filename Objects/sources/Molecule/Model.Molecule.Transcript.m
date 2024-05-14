(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, Transcript], {
	Description->"Model information for a specific ribonuleic acid (RNA) transcript that is produced inside a cell.",
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
		TranscriptType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellularRNAP,
			Description -> "The role that this RNA transcript serves in the cell.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Cells -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Cell][Transcripts],
			Description -> "Cell lines that express this RNA transcript.",
			Category -> "Organizational Information"
		},
		Proteins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Protein][Transcripts],
			Description -> "Proteins or peptides that are translated from this RNA transcript.",
			Category -> "Organizational Information"
		},
		siRNAs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Transcript][TargetTranscripts],
			Description -> "Any siRNAs that are directed against this RNA transcript.",
			Category -> "Organizational Information"
		},
		TargetTranscripts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Transcript][siRNAs],
			Description -> "Transcripts for which this strand is designed to serve as the siRNA knockdown sequence.",
			Category -> "Organizational Information"
		},
		PrimerSimulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Simulation, PrimerSet][Target],
			Description -> "Simulations which were run in order to find PCR primer sets for the transcript.",
			Category -> "Simulation Results"
		},
		SimulatedStructure -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?ECL`StructureQ,
			Description -> "Stored structures for simulated foldings of this transcript.",
			Category -> "Simulation Results"
		}
	}
}];
