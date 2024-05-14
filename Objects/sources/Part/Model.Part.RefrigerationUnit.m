(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, RefrigerationUnit], {
	Description->"Model information for a refrigeration unit used to help control the temperature of a sample-holding chamber.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature the refrigeration unit can provide to its connected instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the refrigeration unit can provide to its connected instrument.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperatureRamp -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Celsius)/Minute],
			Units -> Celsius/Minute,
			Description -> "Maximum rate at which the refrigeration unit can change temperature.",
			Category -> "Operating Limits"
		}
	}
}];
