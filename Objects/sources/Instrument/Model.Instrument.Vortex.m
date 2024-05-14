(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Vortex], {
	Description->"Model information for a Vortex instrument, used for mixing liquid samples in tubes or plates by rotating at high speed.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Format -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> VortexTypeP,
			Description -> "Format of labware the vortex can mix.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Second],
			Units -> Revolution/Second,
			Description -> "Maximum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Second],
			Units -> Revolution/Second,
			Description -> "Minimum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the vortex can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the vortex can incubate.",
			Category -> "Operating Limits"
		}
	}
}];
