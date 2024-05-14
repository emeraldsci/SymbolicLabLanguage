(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, CableTie], {
	Description->"Model information for a fastener that threads into itself and locks tight to secure cables and tubing in place.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BreakingStrength->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Pound],
			Units -> Pound,
			Description -> "The amount of tensile force this model of cable tie can withstand before breaking.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		Material->{
			Format -> Single,
			Class -> Real,
			Pattern :> MaterialP,
			Description -> "The substance from which this model of cable tie is composed.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		Dimensions->{
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Milli Meter], GreaterP[0*Milli Meter]},
			Units -> {Milli Meter, Milli Meter},
			Description -> "The length and width of this cable tie.",
			Category -> "Part Specifications",
			Headers -> {"Width", "Length"}
		}
	}
}];
