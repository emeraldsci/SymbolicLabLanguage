(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, DistanceGauge], {
	Description->"The model of a device for high precision measurement of distance.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistanceGaugeModeP, (*Caliper | Height | Depth | Laser *)
			Description -> "Type of measurements this distance gauge is capable of performing.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The smallest distance increment that this distance gauge is capable of discerning.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The variation in measurements taken under the same conditions as reported by the manufacturer.",
			Category -> "Instrument Specifications"
		},
		MinDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Minimum distance the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Maximum distance the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		}
	}
}];