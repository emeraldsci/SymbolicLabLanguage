(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, Enthalpy], {
	Description->"A simulation to predict the binding of a hybridization reaction between two nucleic acid oligomers using nearest-neighbor parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ReactionModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Reaction][EnthalpySimulations],
			Description -> "Link to a model reaction describing this hybridization reaction.",
			Category -> "General"
		},
		ReactantModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "Link to any model oligomer used as a reactant in the hybridization reaction.",
			Category -> "General"
		},
		ProductModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "Link to any model oligomer used as a product in the hybridization reaction.",
			Category -> "General"
		},
		Reaction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionP,
			Description -> "The hybridization reaction whose binding enthalpy is being computed.",
			Category -> "General"
		},
		Reactants -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The reactants in the binding reaction for which the enthalpy is computed.",
			Category -> "General",
			Abstract -> True
		},
		Products -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The products in the binding reaction for which the enthalpy is computed.",
			Category -> "General",
			Abstract -> True
		},
		Enthalpy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[KilocaloriePerMole],
			Units -> KilocaloriePerMole,
			Description -> "Predicted binding enthalpy of a hybridization reaction between two nucleic acid oligomers.  For a strand, the reaction considered is the strand binding to its reverse complement.  For a structure, the reaction considered is the creation of all bonds in the structure.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		EnthalpyStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[KilocaloriePerMole],
			Units -> KilocaloriePerMole,
			Description -> "Uncertainty in predicted enthalpy of a hybridization reaction between two nucleic acid oligomers.  For a strand, the reaction considered is the strand binding to its reverse complement.  For a structure, the reaction considered is the creation of all bonds in the structure.",
			Category -> "Simulation Results"
		},
		EnthalpyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[KilocaloriePerMole],
			Description -> "Distribution of predicted enthalpy of a hybridization reaction between two nucleic acid oligomers.  For a strand, the reaction considered is the strand binding to its reverse complement.  For a structure, the reaction considered is the creation of all bonds in the structure.",
			Category -> "Simulation Results"
		}		
	}
}];
