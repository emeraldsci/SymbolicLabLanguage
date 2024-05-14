(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[SupportTicket, Operations], {
	Description->"Tracking for a communication proccess used to discuss lab specific events such as protocol states, inventory statuses or procedure impovements.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		SupportTicketSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TroubleshootingTicketTypeP,
			Description -> "Describes the type of event which generated the support ticket.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Blocked -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this issue is currently preventing the affected protocol from moving foward.",
			Category -> "Organizational Information"
		},
		BlockedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the ticket is preventing the affected protocol from moving forward.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Blocked"}
		},
		Suspended -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the affected protocol type has been suspended as a result of this ticket and must be repaired before any further protocols of this type may proceed.",
			Category -> "Organizational Information"
		},
		SuspendedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the affected protocol type has been suspended as a result of this ticket and must be repaired before any further protocols of this type may proceed.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Suspended"}
		},
		Maintenance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this ticket will require instrument maintenance to be resolved.",
			Category -> "Organizational Information"
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Expression},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether the ticket will require instrument maintenance.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Deciding","Maintenance"}
		},	
		AffectedProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][OperationsSupportTickets],
				Object[Qualification][OperationsSupportTickets],
				Object[Maintenance][OperationsSupportTickets]
			],
			Description -> "The protocol, qualification or maintenance to which this ticket applies.",
			Category -> "Organizational Information"
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
			Description -> "A log of the affected protocol, Qualification or maintenance to which this ticket applies.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Protocol"}, 
			Developer -> True
		},
		AffectedTransaction -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][OperationsSupportTickets],
			Description -> "The transaction to which this ticket applies.",
			Category -> "Organizational Information"
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
			Description -> "A log of the affected transaction to which this ticket applies.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Transaction"},
			Developer -> True
		},
		AffectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][OperationsSupportTickets],
			Description -> "Instrument which must undergo maintenance before this ticket ticket can be resolved.",
			Category -> "Organizational Information"
		},
		AffectedInstrumentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[User], Object[Instrument]},
			Description -> "A log of any instrument that must undergo maintenance before this ticket can be resolved.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Instrument"},
			Developer -> True
		},
		AffectedProcedure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program,ProcedureEvent],
			Description -> "The last procedure event logged prior to the filing of this ticket.",
			Category -> "Organizational Information",
			Developer -> True
		},
		AffectedSubprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol],Object[Qualification],Object[Maintenance]],
			Description -> "The subprotocol that was processing when this ticket was filed.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Delayed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the report has been generated via automatic script due to the AffectedProtocol being substantially delayed beyond their checkpoint estimates.",
			Category -> "Organizational Information"
		},		
		AssociatedCommunications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[SupportTicket, UserCommunication][TaggedTickets]
			],
			Description -> "The user tickets associated with this operations ticket.",
			Category -> "Organizational Information"
		}
	}
}];
