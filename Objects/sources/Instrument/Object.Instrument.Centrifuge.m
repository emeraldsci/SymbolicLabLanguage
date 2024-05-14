

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Centrifuge], {
	Description->"An instrument that uses rotation to exert centrifugal on vessels and plates.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		CentrifugeType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],CentrifugeType]],
			Pattern :> CentrifugeTypeP,
			Description -> "The type and sizing of this centrifuge.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature that the centrifuge can be set to maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature that the centrifuge can be set to maintain.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The minimum rotational speed at which the centrifuge can operate.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "The maximum rotational speed at which the centrifuge can operate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTime -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTime]],
			Pattern :> GreaterP[0*Minute],
			Description -> "The maximum duration for which the centrifuge can be continuously run.",
			Category -> "Operating Limits"
		},
		SpeedResolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],SpeedResolution]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The minimum increment by which this centrifuge's spin rate can be adjusted.",
			Category -> "Operating Limits"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedCentrifuge],
			Description -> "The liquid handler that is connected to this centrifuge such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		}
	}
}];
