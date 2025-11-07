(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, Protein], {
	Description->"Model information for a biological macromolecule composed of one or more amino acids chains.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Species -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Species],
			Description -> "The source species that this protein is found in.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		PDBIDs -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> PDBIDP,
			Description -> "The list of Protein Data Bank IDs for any structures of this protein that have been previously reported in literature or are publically available.",
			Category -> "Molecular Identifiers",
			Abstract -> True
		},
		Antibodies -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule][Targets],
				Model[Molecule, Protein, Antibody][Targets]
			],
			Description -> "Antibodies that are known to bind to this protein.",
			Category -> "Organizational Information"
		},
		Transcripts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Transcript][Proteins],
			Description -> "RNA templates that synthesize this protein inside of a cell.",
			Category -> "Organizational Information"
		}
	}
}];
