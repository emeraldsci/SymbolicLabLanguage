(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, TensiometerProbe], {
	Description->"A probe used to measure surface tension with a tensiometer.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Diameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Diameter]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The width of the probe's circular cross section.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ProbeLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ProbeLength]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The distance from the top hook to the bottom end of the probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		LifeTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],LifeTime]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times the probe can be cleaned before needing to be replaced.",
			Category -> "Operating Limits"
		},
		NumberOfCleanings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the probe has previously been burned with the probe cleaner.",
			Category -> "General"
		},
		CleaningLog -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Headers->{"Date","Use"},
			Description -> "The dates the probe has previously been burned with the probe cleaner.",
			Category -> "General"
		},
		UsageLog -> {
			Format -> Multiple,
			Class -> {Expression,Link,Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Protocol] | Object[Qualification] | Object[Maintenance],Object[Sample]},
			Headers->{"Date","Use","Sample"},
			Description -> "The dates the probe has previously been used to take measurements of samples.",
			Category -> "General"
		}
	}
}];
