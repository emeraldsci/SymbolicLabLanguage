(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Troubleshooting, Ticket], {
	Description->"An initial report that is filed whenever a protocol, maintenance, qualification, application, function, or the lab itself experiences an issue which needs adressing by Emerald's team.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		TroubleshootingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TroubleshootingTicketTypeP,
			Description -> "Describes the category of Troubleshooting that the Ticket is classified under: Protocol relates to the execution of a protocol and General is for any other laboratory/instrument issue.",
			Category -> "Troubleshooting",
			Abstract -> True
		},
		Blocked -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this issue is currently preventing the affected protocol from moving foward.",
			Category -> "Troubleshooting"
		},
		BlockedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the troubleshooting is preventing the affected protocol from moving forward.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Deciding","Blocked"}
		},
		Suspended -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the affected protocol type has been suspended as a result of this ticket and must be repaired before any further protocols of this type may proceed.",
			Category -> "Troubleshooting"
		},
		SuspendedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the affected protocol type has been suspended as a result of this ticket and must be repaired before any further protocols of this type may proceed.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Deciding","Suspended"}
		},
		Maintenance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this troubleshooting ticket will require instrument maintenance to be resolved.",
			Category -> "Troubleshooting"
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the troubleshooting will require instrument maintenance.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Deciding","Maintenance"}
		},	
		AffectedProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][TroubleshootingTickets],
				Object[Qualification][TroubleshootingTickets],
				Object[Maintenance][TroubleshootingTickets]
			],
			Description -> "The protocol, qualification or maintenance to which this troubleshooting applies.",
			Category -> "Troubleshooting"
		},
		AffectedProtocolLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Object[User],
				Alternatives[Object[Protocol],Object[Qualification],Object[Maintenance]]
			},
			Description -> "A log of the affected protocol, Qualification or maintenance to which this troubleshooting applies.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Reporting","Protocol"}, 
			Developer -> True
		},
		AffectedTransaction -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][TroubleshootingTickets],
			Description -> "The transaction to which this troubleshooting applies.",
			Category -> "Troubleshooting"
		},
		AffectedTransactionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Object[User],
				Object[Transaction]
			},
			Description -> "A log of the affected transaction to which this troubleshooting applies.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Reporting","Transaction"},
			Developer -> True
		},
		AffectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][TroubleshootingTickets],
			Description -> "Instrument which must undergo maintenance before this troubleshooting ticket can be resolved.",
			Category -> "Troubleshooting"
		},
		AffectedInstrumentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[User], Object[Instrument]},
			Description -> "A log of any instrument that must undergo maintenance before this troubleshooting can be resolved.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Reporting","Instrument"},
			Developer -> True
		},
		AffectedProcedure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program,ProcedureEvent],
			Description -> "The last procedure event logged prior to the filing of this ticket.",
			Category -> "Troubleshooting",
			Developer -> True
		},
		AffectedSubprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol],Object[Qualification],Object[Maintenance]],
			Description -> "The subprotocol that was processing when this ticket was filed.",
			Category -> "Troubleshooting",
			Developer -> True
		},
		Delayed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the report has been generated via automatic script due to the AffectedProtocol being substantially delayed beyond their checkpoint estimates.",
			Category -> "Troubleshooting"
		},		
		AssociatedReports -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[SupportTicket, UserCommunication][TaggedTickets]
			],
			Description -> "The troubleshooting report(s) associated with this ticket.",
			Category -> "Troubleshooting"
		}
	}
}];
