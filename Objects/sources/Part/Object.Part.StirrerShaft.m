(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, StirrerShaft], {
	Description->"A shaft/impeller assembly used to mix solutions using an overhead stirrer.",
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
		StirrerLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirrerLength]],
			Pattern :> GreaterP[0 Milli Meter],
			Description -> "The overall length of the stirrer.",
			Category -> "Dimensions & Positions"
		},		
		ShaftDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ShaftDiameter]],
			Pattern :>GreaterP[0 Milli Meter],
			Description -> "The outside diameter of the stirrer stem.",
			Category -> "Dimensions & Positions"
		},	
		ImpellerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ImpellerDiameter]],
			Pattern :> GreaterP[0 Milli Meter],
			Description -> "Diameter swept by the impeller blades when mixing.",
			Category -> "Dimensions & Positions"
		}
	}
}];
