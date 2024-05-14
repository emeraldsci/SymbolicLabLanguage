

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,FreezePumpThawApparatus],{
	Description->"A model for a freeze-pump-thaw degassing instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DegasType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DegasTypeP,
			Description ->"The category of degassing type used by this degasser.",
			Category -> "Instrument Specifications"
		},
		GasType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DegasGasP,
			Description ->"The type of gas used in the degasser for swapping headspace gas after degassing.",
			Category -> "Instrument Specifications"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description ->  "Minimum flow rate the flow regulator can manage for gas flowing through the Schlenk line, used when swapping headspace gas after degassing.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate the flow regulator can manage for gas flowing through the Schlenk line, used when swapping headspace gas after degassing.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(*-Manifold-*)
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,SchlenkLine],
			Description -> "The Schlenk line used as the vacuum and inert gas source during degassing.",
			Category -> "Instrument Specifications"
		},
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Freeze-Pump-Thaw Apparatus. This indicates how many samples can be run with Freeze-Pump-Thaw simultaneously.",
			Category -> "Instrument Specifications"
		},

		(*-Flash freezing-*)
		Dewar -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,Dewar],
			Description -> "The dewar used to flash freeze the sample during the freeze step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},

		(*-Vacuum pump-*)
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VacuumPump],
			Description -> "The pump used to pull vacuum on the sample during the pump step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},
		MinVacuumPressure->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Units->Torr,
			Description->"Minimum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for freeze pump thaw can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},

		(*Heat block*)
		HeatBlock -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,HeatBlock],
			Description -> "The heat block used for thawing samples during the thaw step of freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		},

		(*-Thawing in water bath-*)
		MaxThawTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Maximum temperature at which the water bath can operate, used during the thaw step of freeze-pump-thaw.",
			Category->"Operating Limits",
			Abstract->True
		},
		MinThawTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"Minimum temperature at which the water bath can operate, used during the thaw step of freeze-pump-thaw.",
			Category->"Operating Limits",
			Abstract->True
		},

		(*-Tubing and cap compatibility-*)
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "Indicates the way that containers are connected to this instrument to be used for freeze-pump-thaw.",
			Category -> "Instrument Specifications"
		}
	}
}];