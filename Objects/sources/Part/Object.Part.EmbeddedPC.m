(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, EmbeddedPC], {
	Description->"Embedded PC used as programmable logic controller (PLC) for Sensornet.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		TCPort -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Port Number in PLC Configuration.",
			Category -> "Part Specifications"
		},
		ADSAMSNetID -> {
			Format -> Single,
			Class -> String,
			Pattern :> ADSRouteP,
			Description -> "Address of Twincat ADS Route (e.g. 5.29.24.317.1.1).",
			Category -> "Part Specifications"
		},
		ADSRouteName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Name of Twincat ADS Route Route.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP of the embedded PC on the network.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		WebServiceIP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP of the twincat ADS web service host that is connected to, and is exchanging data with, this embedded PC.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ConnectedDevices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sensor][EmbeddedPC],
				Object[Instrument, LiquidHandler][EmbeddedPC],
				Object[Part, Camera][EmbeddedPC]
			],
			Description -> "Sensor or Instruments connected to this Sensornet Embedded PC.",
			Category -> "Sensor Information"
		}
	}
}];
