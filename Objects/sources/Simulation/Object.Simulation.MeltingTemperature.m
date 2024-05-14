(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, MeltingTemperature], {
	Description->"A simulation to predict the melting temperature of a hybridization reaction between nucleic acid oligomers using nearest-neighbor parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
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
			Description -> "The reactants in the binding reaction for which the melting temperature is computed.",
			Category -> "General",
			Abstract -> True
		},
		Products -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StructureP,
			Description -> "The products in the binding reaction for which the melting temperature is computed.",
			Category -> "General",
			Abstract -> True
		},
		Concentration -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {StructureP, GreaterEqualP[0*Nanomolar]},
			Units -> {None, Nanomolar},
			Description -> "Concentration(s) of reactants for which melting temperature was computed.",
			Category -> "General",
			Abstract -> True,
			Headers->{"Structure","Concentration"}
		},
		ConcentrationStandardDeviation -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {StructureP, UnitsP[Nanomolar]},
			Units -> {None, Nanomolar},
			Description -> "Uncertainty in concentration(s) of reactants for which melting temperature was computed.",
			Category -> "Simulation Results",
			Headers->{"Structure","Concentration Standard Deviation"}
		},
		ConcentrationDistribution -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {StructureP, DistributionP[Nanomolar]},
			Description -> "The probability for the concentration(s) of reactants for which melting temperature was computed..",
			Category -> "Simulation Results",
			Headers->{"Structure","Concentration Distribution"}
		},
		ReactionModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Reaction][MeltingTemperatureSimulations],
			Description -> "Link to a model reaction describing this hybridization reaction.",
			Category -> "General"
		},
		ReactantModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Oligomer][Simulations]|Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "Link to any model oligomer used as a reactant in the hybridization reaction.",
			Category -> "General"
		},
		ProductModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule,Oligomer][Simulations]|Model[Molecule, Oligomer][Simulations]|Model[Molecule, cDNA][Simulations]|Model[Molecule, Transcript][Simulations],
			Description -> "Link to any model oligomer used as a product in the hybridization reaction.",
			Category -> "General"
		},
		MeltingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "Melting temperature of a hybridization reaction between the oligomer and its reverse complement.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		MeltingTemperatureStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Celsius],
			Units -> Celsius,
			Description -> "Uncertainty in melting temperature of a hybridization reaction between the oligomer and its reverse complement.",
			Category -> "Simulation Results"
		},
		MeltingTemperatureDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description -> "The probability for the melting temperature of a hybridization reaction between the oligomer and its reverse complement.",
			Category -> "Simulation Results"
		}
	}
}];
