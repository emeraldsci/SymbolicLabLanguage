(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, ViscometerChip], {
	Description->"Model information for a rectangular slit microfluidic chip used to measure viscosity with a viscometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Pascal],
			Units -> Pascal,
			Description -> "The maximum pressure across the measurement channel that can be measured by the chip.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Micrometer,
			Description -> "The height of the chip's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Micrometer,
			Description -> "The width of the chip's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ChannelLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Micrometer,
			Description -> "The depth of the chips's measurement channel.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
