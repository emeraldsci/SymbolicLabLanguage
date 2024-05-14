(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, DialysisClip], {
	Description->"A closure that can be used to seal an end of dialysis tubing.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MaxWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The maximum width of dialysis tubing the clip can seal.",
			Category -> "Dimensions & Positions"
		},
		LengthOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The amount of length that each clip consumes of the dialysis tubing when it is closed in order to make a seal. This includes an extra overhang of the dialysis membrane for ease of sealing and handling.",
			Category -> "Dimensions & Positions"
		},
		MembraneTypes -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RegeneratedCellulose|Universal,
			Description -> "The types of dialysis membranes the clip is designed to seal.",
			Category -> "Item Specifications"
		},
		Weighted -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the clip has an added weight to keep the dialysis tubing upright.",
			Category -> "Item Specifications"
		},
		Hanging -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the clip has is designed to hang over the side of the container the dialysis is performed in.",
			Category -> "Item Specifications"
		},
		Magnetic-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the clip is magnetic to allow the dialysis tubing to rotate if put on a magnetic stirrer.",
			Category -> "Item Specifications"
		},
		ClipColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PartColorP,
			Description -> "The color of this clip.",
			Category -> "Physical Properties"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this clip can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this clip can handle.",
			Category -> "Compatibility"
		}
	}
}];
