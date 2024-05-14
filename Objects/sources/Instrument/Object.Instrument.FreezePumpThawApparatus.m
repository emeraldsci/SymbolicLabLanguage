(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,FreezePumpThawApparatus],{
	Description->"A object for a freeze-pump-thaw degassing instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		DegasType->{
			Format->Computable,
			Expression:>
				SafeEvaluate[{Field[Model]},
					Download[Field[Model],DegasType]],
			Pattern:>DegasTypeP,
			Description->"The category of degassing type used by this degasser.",
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
			Description->"Minimum flow rate the flow regulator can manage for gas flowing through the Schlenk line, used when swapping headspace gas after degassing.",
			Category->"Operating Limits",
			Abstract->True
		},
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"Maximum flow rate the flow regulator can manage for gas flowing through the Schlenk line, used when swapping headspace gas after degassing.",
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
			Description->"The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Freeze-Pump-Thaw Apparatus. This indicates how many samples can be run with Freeze-Pump-Thaw simultaneously.",
			Category->"Instrument Specifications"
		},

		(*-Flash freezing-*)
		Dewar -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Dewar],
			Description -> "The dewar used to flash freeze the sample during the freeze step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},

		(*-Vacuum pump-*)
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,VacuumPump],
			Description -> "The pump used to pull vacuum on the sample during the pump step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},
		MinVacuumPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinVacuumPressure]],
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Description->"Minimum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for freeze-pump-thaw can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},

		(*Heat block*)
		HeatBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,HeatBlock],
			Description -> "The heat block used for thawing samples during the thaw step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},

		(*-Thawing in water bath-*)
		MaxThawTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxThawTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Maximum temperature at which the water bath can operate, used during the thaw step of freeze-pump-thaw.",
			Category->"Operating Limits"
		},
		MinThawTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinThawTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"Minimum temperature at which the water bath can operate, used during the thaw step of freeze-pump-thaw.",
			Category->"Operating Limits"
		},

		(*-Tubing and cap Compatibility-*)
		ConnectionType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ConnectionType]],
			Pattern:>ConnectorP,
			Description -> "Indicates the way that containers are connected to this instrument to be used for freeze-pump-thaw.",
			Category->"Dimensions & Positions"
		}
	}
}];