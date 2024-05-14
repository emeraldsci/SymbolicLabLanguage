

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,VacuumDegasser],{
	Description->"A model for a vacuum degassing instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DegasType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DegasTypeP,
			Description ->"The category of degassing type that can be performed by this degasser.",
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
			Description ->"Minimum flow rate the flow regulator can manage for gas flowing through the Schlenk line, used when swapping headspace gas after degassing.",
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
			Description -> "The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Vacuum Degasser. This indicates how many samples can be run with vacuum degassing simultaneously.",
			Category -> "Instrument Specifications"
		},

		(*-Vacuum pump-*)
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VacuumPump],
			Description -> "The pump used to generate a vacuum for the vacuum degasser instrument by removing air and evaporated solvent from the headspace of the sample container.",
			Category -> "Instrument Specifications"
		},
		MinVacuumPressure->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Units->Torr,
			Description->"Minimum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for vacuum degassing can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		MaxVacuumPressure->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0*Atmosphere,1*Atmosphere],
			Units->Torr,
			Description->"Minimum absolute pressure (zero-referenced against perfect vacuum) that the vacuum pump used for vacuum degassing can achieve.",
			Category->"Instrument Specifications",
			Abstract->True
		},

		(*-Sonicator-*)
		Sonicator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,Sonicator],
			Description -> "The sonicator used to agitate the sample in order to increase the liquid-gas interface surface area, to better allow dissolved gases to leave the sample during vacuum degassing.",
			Category -> "Instrument Specifications"
		},

		(*-Tubing and cap compatibility-*)
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description ->"Indicates the way that containers are connected to this instrument to be used for vacuum degassing.",
			Category -> "Instrument Specifications"
		}
	}
}];