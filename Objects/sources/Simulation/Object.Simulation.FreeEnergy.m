(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, FreeEnergy], {
	Description->"A simulation to predict the free energy of a hybridization reaction between nucleic acid oligomers using nearest-neighbor parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Reaction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionP,
			Description -> "The hybridization reaction whose free energy is being computed.",
			Category -> "General"
		},
		Reactants -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The reactants in the binding reaction for which the free energy is computed.",
			Category -> "General",
			Abstract -> True
		},
		Products -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The products in the binding reaction for which the free energy is computed.",
			Category -> "General",
			Abstract -> True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which free energy was computed.",
			Category -> "General",
			Abstract -> True
		},
		TemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Kelvin],
			Units -> Celsius,
			Description -> "Standard deviation of temperature at which free energy was computed.",
			Category -> "General"
		},
		TemperatureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Kelvin],
			Description -> "Diatribution of temperature at which free energy was computed.",
			Category -> "General"
		},
		ReactionModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Reaction][FreeEnergySimulations],
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
		FreeEnergy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[KilocaloriePerMole],
			Units -> KilocaloriePerMole,
			Description -> "Binding free energy of a hybridization reaction between the Oligomer and its reverse complement.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		FreeEnergyStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[KilocaloriePerMole],
			Units -> KilocaloriePerMole,
			Description -> "Standard deviation of free energy of a hybridization reaction between the Oligomer and its reverse complement.",
			Category -> "Simulation Results"
		},
		FreeEnergyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[KilocaloriePerMole],
			Description -> "Distribution of free energy of a hybridization reaction between the Oligomer and its reverse complement.",
			Category -> "Simulation Results"
		}
	}
}];
