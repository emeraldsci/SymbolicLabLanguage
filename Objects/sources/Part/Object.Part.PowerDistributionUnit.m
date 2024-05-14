(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, PowerDistributionUnit], {
	Description->"Information for a power strip fitted with remote monitoring and control over Ethernet.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		NumberOfPorts -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfPorts]],
			Pattern :> NumberOfPDUPortsP,
			Description -> "Number of ports on this PDU.",
			Category -> "Part Specifications"
		},
		PortIDs -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],PortIDs]],
			Pattern :> {(PDUPortP -> _String)..},
			Description -> "A list of rules representing the IDs of the port used by the activate and deactive PDU functions.",
			Category -> "Part Specifications"
		},
		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP for this power distribution unit.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ConnectedInstruments -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression},
			Pattern :> {_Link, PDUPortP, PDUFieldsP},
			Relation -> {
				Object[Instrument][PDU] | Object[Instrument, Evaporator][PDUHeatBlock] | Object[Instrument, RotaryEvaporator][PDUVacuumController] | Object[Instrument, RotaryEvaporator][PDURotationController] | Object[Instrument, RotaryEvaporator][PDUWaterBath] | Object[Part, HeatExchanger][PDU] | Object[Plumbing, Valve][PDU] | Object[Part, Lamp][PDU] | Object[Part, FanFilterUnit][PDU] | Object[Instrument,LiquidHandler][PDUUVLampController] | Object[Instrument,LiquidHandler][PDUFanFilterUnitController] | Object[Part, Spectrophotometer][PDU] | Object[Part,RefrigerationUnit][PDU],
				Null, 
				Null
			},
			Units -> {None, None, None},
			Description -> "Instruments controlled by this PDU.",
			Category -> "Part Specifications",
			Abstract -> True,
			Headers -> {"Connected Instrument", "Port Name", "Field Name on the Instrument Side"}
		},
		CommandLog->{
			Format->Multiple,
			Class->{
				Date->Date,
				Target->Link,
				PDUPort->Integer,
				Action->Expression,
				DateOn-> Date,
				DateOff->Date,
				ResponsibleParty->Link
			},
			Pattern:>{
				Date->_?DateObjectQ,
				Target->_Link,
				PDUPort->PDUPortP,
				Action->PDUActionP,
				DateOn->_?DateObjectQ,
				DateOff->_?DateObjectQ,
				ResponsibleParty->_Link
			},
			Relation->{
				Date->Null,
				Target->(Object[Instrument]|Object[Part]|Object[Plumbing]),
				PDUPort->Null,
				Action->Null,
				DateOn->Null,
				DateOff->Null,
				ResponsibleParty->(Object[Protocol]|Object[Maintenance]|Object[Qualification]|Object[User])
			},
			Description->"A historical record of commands sent to this PDU.",
			Category->"Organizational Information"
		}
	}
}];
