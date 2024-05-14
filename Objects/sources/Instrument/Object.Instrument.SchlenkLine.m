(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, SchlenkLine], {
	Description->"A high tech digital Schlenk line that consists of multiple ports and allows for dual plumbing to gas and vacuum sources. The digital Schlenk line is built with solenoid valves controlling the actuation of the various lines, and allows for multiple gas sources and vacuum pump to be connected in to the same Schlenk manifold. Sensors and regulators are placed throughout the digital Schlenk line to provide detailed information on the vacuum and gas pressures within the manifold.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		HighVacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The high pressure vacuum pump alternative that connects into the vacuum line in the Schlenk line.",
			Category -> "Instrument Specifications"
		},
		LowVacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The low pressure vacuum pump alternative that connects into the vacuum line in the Schlenk line.",
			Category -> "Instrument Specifications"
		},
		(*Connections are part of Object[Instrument]*)

		(*Pressure sensors*)
		(*Nitrogen, Argon, and Helium pressure sensors are part of Object Instrument*)
		ChannelAGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure sensor used by this instrument to measure the gas pressure leading from the Schlenk manifold into Channel A.",
			Category -> "Sensor Information"
		},
		ChannelBGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure sensor used by this instrument to measure the gas pressure leading from the Schlenk manifold into Channel B.",
			Category -> "Sensor Information"
		},
		ChannelCGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure sensor used by this instrument to measure the gas pressure leading from the Schlenk manifold into Channel C.",
			Category -> "Sensor Information"
		},
		ChannelDGasPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure sensor used by this instrument to measure the gas pressure leading from the Schlenk manifold into Channel D.",
			Category -> "Sensor Information"
		},

		(*Solenoid valves*)
		ChannelAValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The valve that is used by this instrument to directly control the opening of Channel A out of the Schlenk manifold.",
			Category -> "Plumbing Information"
		},
		ChannelBValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The valve that is used by this instrument to directly control the opening of Channel B out of the Schlenk manifold.",
			Category -> "Plumbing Information"
		},
		ChannelCValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The valve that is used by this instrument to directly control the opening of Channel C out of the Schlenk manifold.",
			Category -> "Plumbing Information"
		},
		ChannelDValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The valve that is used by this instrument to directly control the opening of Channel D out of the Schlenk manifold.",
			Category -> "Plumbing Information"
		},

		VacuumGasDiverterValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The diverter valve that is used by this instrument to control whether the Schlenk manifold is open to the gas or vacuum lines.",
			Category -> "Plumbing Information"
		},
		VacuumDiverterValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing,Valve][ConnectedInstrument],
			Description -> "The diverter valve that is used by this instrument to control whether the vacuum line flows into the high or low vacuum pump.",
			Category -> "Plumbing Information"
		},
		(*Electronic manifold - we are treating this as individual valves within the object*)
		
		(*NitrogenValve, ArgonValve, and HeliumValve are part of the general Object[Instrument]*)
		(*Vacuum gauge*)
		VacuumSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The vacuum gauge used by this instrument to sense the amount of vacuum being pulled by the vacuum line into the Schlenk manifold, which is read by Sensornet.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		(*Vapor trap*)
		VaporTrap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,VaporTrap],
			Description -> "The vapor trap used by this instrument to ensure that no residual moisture can make its way into the vacuum gauge and vacuum pumps. This is done by using a low temperature to condense moisure out of the gas flow.",
			Category -> "Instrument Specifications"
		}
	}
}];
