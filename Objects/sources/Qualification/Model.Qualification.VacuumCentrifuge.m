(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,VacuumCentrifuge], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a vacuum centrifuge.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		EvaporationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "The amount of time, after equilibration is achieved, that the samples continue to undergo evaporation and concentration at the specified Temperature and EvaporationPressure.",
			Category -> "Evaporation",
			Abstract -> True
		},
		EvaporationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the vacuum centrifuge's chamber inside which the samples will undergo evaporation.",
			Category -> "Evaporation",
			Abstract -> True
		},
		EvaporationWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The wells of the sample plates that must be fully evaporated for the qualification to pass.",
			Category -> "Evaporation",
			Abstract -> True
		}
	}
}];
