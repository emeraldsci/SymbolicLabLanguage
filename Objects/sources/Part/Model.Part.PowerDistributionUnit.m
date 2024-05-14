

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, PowerDistributionUnit], {
	Description->"Model information for a power strip fitted with remote monitoring and control over Ethernet.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		NumberOfPorts -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> NumberOfPDUPortsP,
			Units -> None,
			Description -> "Number of ports on this PDU.",
			Category -> "Instrument Specifications"
		},
		PortIDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PDUPortP -> _String,
			Description -> "A list of rules representing the IDs of the port used by the activate and deactive PDU functions.",
			Category -> "Instrument Specifications"
		}
	}
}];
