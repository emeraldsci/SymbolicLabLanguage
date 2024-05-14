(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,VacuumDegasser],{
	Description->"A protocol for a vacuum degassing instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		DegasType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DegasType]],
			Pattern:>DegasTypeP,
			Description->"The category of degas type that can be performed by this degasser.",
			Category->"Instrument Specifications"
		},

		(*-Gas flow-*)
		GasType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],GasType]],
			Pattern:>DegasGasP,
			Description->"The type of gas used in the degasser for swapping headspace gas after degassing.",
			Category->"Instrument Specifications"
		},
		MinFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"Minimum flow rate the flow regulator can manage for gas flowing through the manifold, used when swapping headspace gas after degassing.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"Maximum flow rate the flow regulator can manage for gas flowing through the manifold, used when swapping headspace gas after degassing.",
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
			Description->"The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Vacuum Degasser. This indicates how many samples can be run with vacuum degassing simultaneously.",
			Category->"Instrument Specifications"
		},

		(*-Vacuum pump-*)
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,VacuumPump],
			Description -> "The pump used to generate a vacuum for the vacuum degasser instrument by removing air and evaporated solvent from the headspace of the sample container.",
			Category -> "Instrument Specifications"
		},
		MinVacuumPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinVacuumPressure]],
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Description->"Minimum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for vacuum degassing can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		MaxVacuumPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVacuumPressure]],
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Description->"Maximum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for vacuum degassing can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},

		(*Sonicator*)
		Sonicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Sonicator],
			Description -> "The sonicator used to agitate the sample in order to increase the liquid-gas interface surface area, to better allow dissolved gases to leave the sample during vacuum degassing.",
			Category -> "Instrument Specifications"
		},

		(*-Tubing Compatibility-*)
		ConnectionType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ConnectionType]],
			Pattern:>ConnectorP,
			Description->"Indicates the way that containers are connected to this instrument to be used for vacuum degassing.",
			Category->"Instrument Specifications"
		}
	}
}];