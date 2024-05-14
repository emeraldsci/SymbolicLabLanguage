(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,Clean,PeptideSynthesizer], {
	Description->"Definition of a set of parameters for a maintenance protocol that flushes and cleans the Peptide Synthesizer instrument to ensure there is no carry over of reagents between syntheses.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PrimaryWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The wash solvent used to flush and clean all the liquid handling lines in the instrument.",
			Category -> "General"
		},
		SecondaryWashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "A secondary follow up wash solvent used to flush all the liquid handling lines after the primary solvent has been flushed through.",
			Category -> "General"
		},
		CleavageLineSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The wash solvent used to flush the lines that are used during Cleavage.",
			Category -> "General"
		},
		PrimaryWashSolventContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The type of containers that are used for the primary wash solvent.",
			Category -> "General"
		},
		SecondaryWashSolventContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The type of containers that are used for the secondary wash solvent.",
			Category -> "General"
		},
		CleavageLineSolventContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The type of containers that are used for the cleavage line solvent.",
			Category -> "General"
		},
		PrimaryWashSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the primary wash solvent used to flush all the liquid handling lines in the instrument.",
			Category -> "General"
		},
		SecondaryWashSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the secondary wash solvent used to flush all the liquid handling lines in the instrument.",
			Category -> "General"
		},
		CleavageLineSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Milliliter,
			Description -> "The volume of the wash solvent used to flush the lines that are used during Cleavage.",
			Category -> "General"
		},
		Frits -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The type of frit that are used in the bottle filters of the peptide synthesizer instrument.",
			Category -> "General"
		},
		CollectionVessels -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The type of vessels that are used to collect the cleaved strands after synthesis.",
			Category -> "General"
		}
	}
}];
