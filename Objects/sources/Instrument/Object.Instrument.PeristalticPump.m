

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, PeristalticPump], {
	Description->"Low pressure, low volume liquid pumping device for continuous liquid transfers.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		TubingType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingType]],
			Pattern :> TubingTypeP,
			Description -> "Material type the peristaltic pump is composed of.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DeadVolume]],
			Pattern :> GreaterP[0*Liter*Milli],
			Description -> "Dead volume needed to fill the instrument lines.",
			Category -> "Instrument Specifications"
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "Maximum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "Minimum flow rate the pump can deliver.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		OperationalSpeed -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[0, 100],
			Units -> None,
			Description -> "The instrument speed in the percent mode in which the instrument operates.",
			Category -> "Operating Limits"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter*Milli],
			Description -> "Internal diameter of the tubing in the pump.",
			Category -> "Dimensions & Positions"
		},
		DissolutionApparatus -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, DissolutionApparatus][WastePump],
			Description -> "The dissolution apparatus that the pump is used in.",
			Category -> "Instrument Specifications"
		}
	}
}];
