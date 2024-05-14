(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, TensiometerProbe], {
	Description->"Model information for a probe used to measure surface tension with a tensiometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The width of the probe's circular cross section.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ProbeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the top hook to the bottom end of the probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		LifeTime -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of times the probe can be cleaned before needing to be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];
