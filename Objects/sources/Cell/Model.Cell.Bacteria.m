(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Cell, Bacteria], {
	Description->"Model information for a specific strain of bacterium.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Antibiotics -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "Antimicrobial substances that kill or inhibit the growth of this strain of bacteria.",
			Abstract -> True,
			Category->"Organizational Information"
		},
		Hosts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Units -> None,
			Relation -> Model[Species][Bacteria],
			Description -> "Species that are known to carry this strain of bacteria.",
			Abstract -> True,
			Category->"Organizational Information"
		},
		Morphology -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BacterialMorphologyP,
			Description -> "The morphological type of this strain of bacteria.",
			Category -> "Physical Properties"
		},
		GramStain -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Positive|Negative,
			Description -> "Indicates whether this strain of bacteria has a layer of peptidoglycan in its cell wall.",
			Category -> "Physical Properties"
		},
		Flagella -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BacterialFlagellaTypeP,
			Description -> "The type of flagella that protrude from this bacterium's cell wall.",
			Category -> "Physical Properties"
		},
		CellLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Micro],
			Units -> Meter Micro,
			Description -> "The length of a single bacterium's body along its longest dimension.",
			Category -> "Physical Properties",
			Abstract -> True
		}
	}
}];
