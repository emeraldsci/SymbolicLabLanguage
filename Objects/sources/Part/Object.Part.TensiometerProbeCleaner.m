(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, TensiometerProbeCleaner], {
	Description->"A probe cleaning unit used to clean the tensiometer probes, by burning off contaminants, before taking a surface tension measurement.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterEqualP[0*Celsius],
			Description -> "The maximal temperature the cleaner can heat up to.",
			Category -> "Operating Limits"
		},
		ProbesPerCleaning -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ProbesPerCleaning]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of probes that can be burned simultaneously.",
			Category -> "Operating Limits"
		},
		LifeTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],LifeTime]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times the probe cleaner can be used before needing to be replaced.",
			Category -> "Operating Limits"
		},
		NumberOfCleanings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the probe cleaner has previously been used.",
			Category -> "General"
		}
	}
}];
