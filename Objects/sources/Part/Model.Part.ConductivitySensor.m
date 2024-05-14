(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, ConductivitySensor], {
	Description->"Model information for a conductivity/temperature sensor used for in-line electrical conductivity and temperature measurements of a solution.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* ----- Operating Limits ----- *)
		
		MinConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Siemens /(Centimeter)],
			Units-> Milli Siemens /(Centimeter),
			Description -> "Minimum conductivity this sensor can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		MaxConductivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milli Siemens/(Centimeter)],
			Units-> Milli Siemens /(Centimeter),
			Description -> "Maximum conductivity this sensor can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "Minimum temperature this sensor can measure.",
			Category -> "Operating Limits"
		},
		
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "Maximum temperature this sensor can measure.",
			Category -> "Operating Limits"
		}
	}
}];
