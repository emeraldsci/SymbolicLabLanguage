(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, StirBar], {
	Description->"A coated magnet used to stir liquids on a magnetic stirrer with a rotating magnetic field.",
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
		StirBarLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirBarLength]],
			Pattern :> GreaterP[0 Milli Meter],
			Description -> "The overall length of the stir bar.",
			Category -> "Dimensions & Positions"
		},
		StirBarWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirBarWidth]],
			Pattern :>GreaterP[0 Milli Meter],
			Description -> "The outside diameter of the stir bar.",
			Category -> "Dimensions & Positions"
		},
		StirBarShape -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirBarShape]],
			Pattern :> Circle | Octagon,
			Description -> "The shape of this model of stir bar in the Y-Z plane.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which this bar can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which this bar can handle.",
			Category -> "Compatibility"
		},
		MicrowaveSafe -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MicrowaveSafe]],
			Pattern :> BooleanP,
			Description -> "Indicates if this part can be safely used in a microwave or microwave reactor.",
			Category -> "Compatibility"
		}
	}
}];
