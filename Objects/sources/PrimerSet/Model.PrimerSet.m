(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[PrimerSet], {
	Description->"Model information for a set of oligomer primers design to amplify a particular target in PCR.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this model goes by.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The people who created this model.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Target -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The RNA transcript that is amplified by PCR using this primer set.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ForwardPrimer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The primer that binds to the antisense target strand (is a subsequence of the sense target strand) for this primer set.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ReversePrimer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The primer that binds to the sense target strand (is a subsequence of the antisense target strand) for this primer set.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Beacon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "A fluorescent beacon (possibly a molecular beacon) used to detect the amplicon for this primer set.",
			Category -> "Organizational Information"
		},
		BeaconTarget -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The reverse complement of the beacon's binding region for this primer set.",
			Category -> "Organizational Information"
		},
		SenseAmplicon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The sense amplicon oligo for this primer set.",
			Category -> "Organizational Information"
		},
		AntisenseAmplicon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][PrimerSets]|Model[Molecule, cDNA][PrimerSets]|Model[Molecule, Transcript][PrimerSets],
			Description -> "The antisense amplicon oligo for this primer set.",
			Category -> "Organizational Information"
		},

		(* -- Simulation Results -- *)
		DesignSimulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Simulation, PrimerSet][Models],
			Description -> "A simulation used to generate this primer set.",
			Category -> "Simulation Results"
		},
		BeaconSimulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Simulation, MeltingCurve],
			Description -> "A simulations used to test the molecular beacons that are part of this primer set.",
			Category -> "Simulation Results"
		},
		LiteratureReferences -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Report, Literature][References],
			Description -> "Literature references that discuss this primer set.",
			Category -> "Analysis & Reports"
		}
	}
}];
