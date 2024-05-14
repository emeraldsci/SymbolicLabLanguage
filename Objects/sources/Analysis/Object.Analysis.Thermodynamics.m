(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Thermodynamics], {
	Description->"Calculation of the thermodynamic properties of a reaction using van't Hoff analysis of melting point data.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AffinityConstants -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> CoordinatesP,
			Units -> {Kelvin^(-1), None},
			Description -> "The melting points data used for van't Hoff fitting, in the form of the inverse of the melting temeprature and the log of the affinity constant.",
			Category -> "General"
		},
		Exclude -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, MeltingPoint][Thermodynamics],
			Description -> "The data objects that were excluded in the analysis.",
			Category -> "General"
		},
		EquilibriumType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BimolecularHomogenous | BimolecularHeterogenous,
			Description -> "The equilibrium type exhibited by the melting reactions.",
			Category -> "General"
		},
		Fit -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The van't Hoff fit on the data to generate the enthalpy and entropy.",
			Category -> "Analysis & Reports"
		},
		Enthalpy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EnergyQ,
			Units -> KilocaloriePerMole,
			Description -> "The change in enthalpy as determined from the melting curve fit.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		EnthalpyStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EnergyQ,
			Units -> KilocaloriePerMole,
			Description -> "Uncertainty in the computed enthalpy, defined as the standard deviation of the enthalpy distribution.",
			Category -> "Analysis & Reports"
		},
		EnthalpyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[KilocaloriePerMole],
			Description -> "The probability distribution for the computed enthalpy value.",
			Category -> "Analysis & Reports"
		},
		Entropy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EntropyQ,
			Units -> CaloriePerMoleKelvin,
			Description -> "The change in entropy as determined from the melting curve fit.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		EntropyStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EntropyQ,
			Units -> CaloriePerMoleKelvin,
			Description -> "Uncertainty in the computed entropy, defined as the standard deviation of the entropy distribution.",
			Category -> "Analysis & Reports"
		},
		EntropyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[CaloriePerMoleKelvin],
			Description -> "The probability distribution for the computed entropy value.",
			Category -> "Analysis & Reports"
		},
		FreeEnergy -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EnergyQ,
			Units -> KilocaloriePerMole,
			Description -> "The gibbs free energy at 37 Celsius, computed from the BindingEnthalpy and BindingEntropy.",
			Category -> "Analysis & Reports",
			Abstract -> True
		},
		FreeEnergyStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?EnergyQ,
			Units -> KilocaloriePerMole,
			Description -> "Uncertainty in the computed free energy, defined as the standard deviation of the binding free energy distribution.",
			Category -> "Analysis & Reports"
		},
		FreeEnergyDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[KilocaloriePerMole],
			Description -> "The probability distribution for the computed free energy value.",
			Category -> "Analysis & Reports"
		}
	}
}];
