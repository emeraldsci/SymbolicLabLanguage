(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, DispensingHead], {
	Description->"Interchangeable head used to dispense fluids into the destination container in a Bufferbot type liquid handler.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		VolumeSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensor used to measure liquid level in the destination container of a Bufferbot type liquid handler.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		AllowedTubingDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AllowedTubingDiameter]],
			Pattern :> GreaterP[0*Inch],
			Description -> "Outside diameter of tubing compatible with this dispensing head.",
			Category -> "Part Specifications"
		},
		MaxBottleDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxBottleDiameter]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "Maximum bottle neck inside diameter that can be used with this dispensing head.",
			Category -> "Part Specifications"
		},
		MinContainerDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinContainerDepth]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "Depth of the shortest container that can be used with this dispensing head.",
			Category -> "Part Specifications"
		},		
		MaxContainerDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxContainerDepth]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "Depth of the tallest container that can be used with this dispensing head.",
			Category -> "Part Specifications"
		}
	}
}];
