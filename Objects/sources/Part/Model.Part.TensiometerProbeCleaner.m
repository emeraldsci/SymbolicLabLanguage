(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, TensiometerProbeCleaner], {
	Description->"Model information for a probe cleaning unit used to clean the tensiometer probes, by burning off contaminants, before taking a surface tension measurement.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Celsius],
			Units -> Celsius,
			Description -> "The maximal temperature the cleaner can heat up to.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		ProbesPerCleaning -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of probes that can be simultaneously cleaned by heating the probes, burning of contaminants.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		LifeTime -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times the probe cleaner can be used before needing to be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
