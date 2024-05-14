(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, StirBarRetriever], {
	Description->"A magnet and handle used to remove stir bars from samples.",
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
		RetrieverLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],RetrieverLength]],
			Pattern :> GreaterP[0 Milli Meter],
			Description -> "The overall length of the stir bar retriever.",
			Category -> "Dimensions & Positions"
		},
		RetrieverDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],RetrieverDiameter]],
			Pattern :>GreaterP[0 Milli Meter],
			Description -> "The outside diameter of the retriever stem.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which this retriever can handle.",
			Category -> "Compatibility"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which this retriever can handle.",
			Category -> "Compatibility"
		}
	}
}];
