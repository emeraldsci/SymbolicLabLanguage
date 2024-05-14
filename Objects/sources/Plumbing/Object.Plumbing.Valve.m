(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing,Valve], {
	Description->"A plumbing component that can direct the flow of liquids/gases through a plumbing system.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ConnectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][CO2Valve],
				Object[Instrument][NitrogenValve],
				Object[Instrument][ArgonValve],
				Object[Instrument][HeliumValve],
				Object[Instrument,SchlenkLine][VacuumGasDiverterValve],
				Object[Instrument,SchlenkLine][VacuumDiverterValve],
				Object[Instrument,SchlenkLine][ChannelAValve],
				Object[Instrument,SchlenkLine][ChannelBValve],
				Object[Instrument,SchlenkLine][ChannelCValve],
				Object[Instrument,SchlenkLine][ChannelDValve],
				Object[Instrument,LiquidNitrogenDoser][LiquidNitrogenValve],
				Object[Instrument,CrossFlowFiltration][PermeateValve]
			],
			Description -> "Instrument for which this valve controls the flow of gas/liquid.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		GasType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GasP,
			Description -> "The type gas whose flow this valve controls.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		PDU -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that controls power flow to this valve.",
			Category -> "Part Specifications"
		},
		PDUIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU]},Download[Field[PDU],IP]],
			Pattern :> IpP,
			Description -> "The IP address of the PDU that controls power flow to this valve.",
			Category -> "Part Specifications"
		},
		PDUPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUPart]],
			Pattern :> PDUPortP,
			Description -> "The specific PDU port to which this valve is connected.",
			Category -> "Part Specifications"
		},
		ValvePosition -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The current state of flow to which this valve is set.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		ValvePositionLog -> {
			Format -> Multiple,
			Class -> {Date, String, Link},
			Pattern :> {_?DateObjectQ, _String, _Link},
			Relation -> {Null, Null, Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Description -> "A historical record of the valve position changes made by protocols and individuals.",
			Headers -> {"Date","New Valve Position","Changed Made By"},
			Category -> "Plumbing Information"
		}
	}
}];
