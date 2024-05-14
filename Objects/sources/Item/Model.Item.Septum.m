(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Septum], {
	Description->"A model of a barrier (typically made from a polymer material) that goes under a crimped cap and retains a liquid or solid in a container.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "The footprint of the cover that this septum should be used with.",
			Category -> "Physical Properties"
		},
		Pierceable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this septum can be pierced by a needle.",
			Category -> "Physical Properties"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature for which this septum is rated.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		Thickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The depth of the barrier formed by this septum on the orifice it is installed upon.",
			Units->Millimeter,
			Category -> "Physical Properties"
		},
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The diameter of the septum.",
			Units->Millimeter,
			Category -> "Physical Properties"
		},
		Barcode -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this cap type is big enough to have a barcode sticker. Septa should be barcoded if they are longer than 4.1 cm (the size of ECL identification stickers). If covers are too small to be stickered, they will be placed on a cover rack and will be identified by the sticker on the cover rack.",
			Category -> "Physical Properties"
		}
	}
}];
