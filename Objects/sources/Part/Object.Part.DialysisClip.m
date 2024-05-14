(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, DialysisClip], {
	Description->"A closure used to seal an end of dialysis tubing.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {		
		WettedMaterials -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],WettedMaterials]],
			Pattern :> MaterialP,
			Description -> "The materials in contact with the liquid.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		MaxWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxWidth]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The maximum width of dialysis tubing the clip can seal.",
			Category -> "Dimensions & Positions"
		},
		LengthOffset -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],LengthOffset]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The amount of length that each clip consumes of the dialysis tubing when it is closed in order to make a seal. This includes an extra overhang of the dialysis membrane for ease of sealing and handling.",
			Category -> "Dimensions & Positions"
		},
		MembraneTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MembraneTypes]],
			Pattern :>RegeneratedCellulose|Universal,
			Description -> "The types of dialysis membranes the clip is designed to seal.",
			Category -> "Physical Properties"
		},
		Weighted -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Weighted]],
			Pattern :>BooleanP,
			Description -> "Indicates if the clip has an added weight to keep the dialysis tubing upright.",
			Category -> "Physical Properties"
		},
		ClipColor -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ClipColor]],
			Pattern :> PartColorP,
			Description -> "The color of this clip.",
			Category -> "Physical Properties"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which this clip can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which this clip can handle.",
			Category -> "Compatibility"
		}
	}
}];
