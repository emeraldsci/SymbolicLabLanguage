(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring, NetworkHub], {
  Description -> "Model information regarding a network device that connects Ethernet devices.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

		NumberOfPorts -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of Ethernet ports that this newtork hub has for devices to be plugged into.",
			Category -> "Wiring Information"
		},
		
		PowerOverEthernet -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this network hub is designed to transmit power as well as data through Ethernet cables.",
			Category -> "Wiring Information"
		}

	}
}];
