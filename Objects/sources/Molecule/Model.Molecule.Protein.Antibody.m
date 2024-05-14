(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, Protein, Antibody], {
	Description->"Model information for a Y-shaped immune component that targets a specific antigen.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SecondaryAntibodies -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule][Targets],
				Model[Molecule, Protein, Antibody][Targets]
			],
			Description -> "Secondary antibody models that bind to this antibody and can be used for labeling.",
			Category -> "Organizational Information"
		},
		Organism -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AntibodyOrganismP,
			Description -> "The organism in which the antibody was raised. Determines the type of secondary antibody required for labeling.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Isotype -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AntibodyIsotypeP,
			Description -> "The subgroup of immunoglobulin this antibody belongs to, based on variations within the constant regions of its heavy and/or light chains.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Clonality -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AntibodyClonalityP,
			Description -> "Specifies whether the antibody is produced by one type of cells to recognize a single epitope (monoclonal) or several types of immune cells to recognize multiple epitopes (polyclonal).",
			Category -> "Physical Properties",
			Abstract -> True
		},
		AssayTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AntibodyAssayCompatibilityP,
			Description -> "Types of experiments in which this antibody is known to perform well.",
			Category -> "General"
		},
		RecommendedDilution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1, Inclusive -> Right],
			Units -> None,
			Description -> "The dilution that is recommended for use of this antibody in a capillary electrophoresis western blot assay.",
			Category -> "General"
		},
		Epitopes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{_Strand,GreaterP[0],GreaterP[0]}..},
			Description -> "For each member of Targets, the part of the target antigen that this antibody attaches itself to, with the sequence information of the protein segment and its binding position range.",
			IndexMatching -> Targets,
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
