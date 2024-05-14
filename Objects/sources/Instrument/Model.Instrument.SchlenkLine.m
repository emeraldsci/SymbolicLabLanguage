(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, SchlenkLine], {
	Description->"The model for a high tech digital Schlenk line that consists of multiple ports and allows for dual plumbing to gas and vacuum sources. The digital Schlenk line is built with solenoid valves controlling the actuation of the various lines, and allows for multiple gas sources and vacuum pump to be connected in to the same Schlenk manifold. Sensors and regulators are placed throughout the digital Schlenk line to provide detailed information on the vacuum and gas pressures within the manifold.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		HighVacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VacuumPump],
			Description -> "The high pressure vacuum pump alternative that connects into the vacuum line in the Schlenk line.",
			Category -> "Instrument Specifications"
		},
		LowVacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VacuumPump],
			Description -> "The low pressure vacuum pump alternative that connects into the vacuum line in the Schlenk line.",
			Category -> "Instrument Specifications"
		},
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of channels that the Schlenk line can be configured to connect with. All channels connect out from the same manifold source, and will have available to them the same gas/vacuum connections for the Schlenk line. The openings to each individual channel is controlled by solenoid valves.",
			Category -> "Instrument Specifications"
		},
		Gas-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SchlenkGasP,
			Description -> "The types of gases that will be available to the gas line in the Schlenk line.",
			Category -> "Instrument Specifications"
		},
		(*Connectors taken care of by Model[Instrument] fields*)

		(*Flow regulator*)
		MinDeliveryPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The minimum pressure at which the gas regulator delivers the gas from the gas source into the Schlenk manifold.",
			Category -> "Operating Limits",
			Units -> PSI,
			Abstract -> True
		},
		MaxDeliveryPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure at which the gas regulator delivers the gas from the gas source into the Schlenk manifold.",
			Category -> "Operating Limits",
			Units -> PSI,
			Abstract -> True
		},
		MinSourcePressure->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The minimum pressure at which the gas regulator delivers the gas out of the manifold into the channels.",
			Category -> "Instrument Specifications",
			Units -> PSI,
			Abstract -> True
		},
		MaxSourcePressure->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure at which the gas regulator delivers the gas out of the manifold into the channels.",
			Category -> "Instrument Specifications",
			Units -> PSI,
			Abstract -> True
		},
		(*Vapor trap*)
		VaporTrap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VaporTrap],
			Description -> "The vapor trap used by this instrument to ensure that no residual moisture can make its way into the vacuum gauge and vacuum pumps. This is done by using low temperature to condense moisture out of the gas flow.",
			Category -> "Instrument Specifications"
		}
		(*Note: PDU for the vacuum pumps are part of the Object[Instrument] whereas PDU for the valves are part of the Object[Plumbing]*)
	}
}];
