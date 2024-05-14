(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Molecule, Polymer], {
	Description->"Model information for a macromolecule composed of repeating subunits whose sequence may be fully or semi-controlled, but whose overall length is not exact.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Interestingly InChI supports polymers https://www.inchi-trust.org/wp/wp-content/uploads/2017/11/23.-InChI-Polymer-Yerin-201708.pdf *)
		(* This field is inherited from Model[Molecule] *)

		Monomers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "The structural repeating units that this polymer is composed of.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DegreeOfPolymerization->{
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[],
			Description -> "The number of monomeric units in this given polymer (not the number of repeat units).",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Arrangement->{
			Format -> Single,
			Class -> Expression,
			Pattern :> PolymerArrangementP, 
			Description -> "The structural repeating units that this polymer is composed of.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Tacticity->{
			Format -> Single,
			Class -> Expression,
			Pattern :> PolymerTacticityP,
			Description -> "The relative stereochemistry of the chiral centers in adjacent repeating structural units within the polymer.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Copolymers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Polymer],
			Description -> "Other polymers that have the same arrangement of monomeric units, but different degrees of polymerization.",
			Category -> "Organizational Information",
			Abstract -> True
		}
	}
}];
