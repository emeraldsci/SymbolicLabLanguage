(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, EquilibriumConstant], {
	Description->"A simulation to predict the equilibrium constant of a hybridization reaction between two nucleic acid oligomers using nearest-neighbor parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Reaction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionP,
			Description -> "The hybridization reaction whose binding equilibrium constant is being computed.",
			Category -> "General"
		},
		Reactants -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The reactants in the binding reaction for which the equilibrium constant is computed.",
			Category -> "General",
			Abstract -> True
		},
		Products -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The products in the binding reaction for which the equilibrium constant is computed.",
			Category -> "General",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which equilibrium constant was computed.",
			Category -> "General",
			Abstract -> True
		},
		TemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Kelvin],
			Units -> Celsius,
			Description -> "Standard deviation of temperature at which equilibrium constant was computed.",
			Category -> "General"
		},
		TemperatureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Kelvin],
			Description -> "Diatribution of temperature at which equilibrium constant was computed.",
			Category -> "General"
		},
		ReactionModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Reaction][EquilibriumConstantSimulations],
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
		EquilibriumConstant -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "Equilibrium constant of a hybridization reaction between Strand and its reverse complement.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		EquilibriumConstantStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Description -> "Standard deviation of equilibrium constant of a hybridization reaction between Strand and its reverse complement.",
			Category -> "Simulation Results"
		},
		EquilibriumConstantDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[],
			Description -> "Distribution of equilibrium constant of a hybridization reaction between Strand and its reverse complement.",
			Category -> "Simulation Results"
		}
	}
}];
