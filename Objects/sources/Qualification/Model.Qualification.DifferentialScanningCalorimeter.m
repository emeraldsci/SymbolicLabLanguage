(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, DifferentialScanningCalorimeter], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a differential scanning calorimeter.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		StartTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the samples are held prior to heating.",
			Category -> "Thermocycling"
		},
		EndTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature to which the samples are heated in the course of the experiment.",
			Category -> "Thermocycling"
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The rate at which the temperature is increased in the course of one heating cycle.",
			Category -> "Thermocycling"
		}
	}
}];
