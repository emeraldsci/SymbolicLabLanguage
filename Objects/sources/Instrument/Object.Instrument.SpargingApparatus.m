(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,SpargingApparatus],{
	Description->"A protocol for a sparging degassing instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		DegasType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DegasType]],
			Pattern:>DegasTypeP,
			Description->"The category of degassing type used by this degasser.",
			Category->"Instrument Specifications"
		},

		(*-Gas flow-*)
		GasType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GasType]],
			Pattern:>DegasGasP,
			Description->"The type of gas used in the sparging degasser.",
			Category->"Instrument Specifications"
		},
		MinFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"Minimum flow rate the flow regulator can manage that controls the amount of gas flowing through the SchlenkLine, which in turn controls the pressure of gas that can be used for sparging.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"Maximum flow rate the flow regulator can manage that controls the amount of gas flowing through the SchlenkLine, which in turn controls the pressure of gas that can be used for sparging.",
			Category->"Operating Limits",
			Abstract->True
		},

		(*Manifold*)
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,SchlenkLine],
			Description -> "The Schlenk line used as the vacuum and inert gas source during degassing.",
			Category -> "Instrument Specifications"
		},
		NumberOfChannels->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfChannels]],
			Pattern:>GreaterP[0, 1],
			Description->"The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Sparging Apparatus. This indicates how many samples can be run with sparging simultaneously.",
			Category->"Instrument Specifications"
		},

		Mixer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Object[Instrument, OverheadStirrer],
			Description -> "The mixer used to stir the solution as it is being degassed via the sparging method.",
			Category -> "General"
		},

		(*Tubing and cap compatibility*)
		ConnectionType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ConnectionType]],
			Pattern:>ConnectorP,
			Description -> "Indicates the way that containers are connected to this instrument to be used for sparging.",
			Category->"Instrument Specifications"
		}
	}
}];