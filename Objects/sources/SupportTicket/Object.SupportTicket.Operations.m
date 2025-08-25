(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[SupportTicket, Operations], {
	Description->"Tracking for a communication process used to discuss lab specific events such as protocol states, inventory statuses or procedure improvements.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SupportTicketStatusP,
			Description -> "Indicates where a support ticket falls in its life cycle. Typically a support ticket will move from technical support statuses to lab ops request statuses.",
			Category -> "General",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, SupportTicketStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance] | Object[Repair]},
			Description -> "Log of the status changes for this support ticket.",
			Category -> "General",
			Headers -> {"Date", "Status", "Responsible Party"},
			Developer -> True
		},
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
			Description -> "Indicates if this issue is currently preventing the affected protocol from moving forward.",
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
				Object[Protocol][InternalCommunications],
				Object[Qualification][InternalCommunications],
				Object[Maintenance][InternalCommunications]
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
			Relation -> Alternatives[
				Object[Transaction][InternalCommunications]
			],
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
			Relation -> Alternatives[
				Object[Instrument][InternalCommunications]
			],
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
		},
		AssociatedRepairs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Repair][AssociatedInternalCommunications]
			],
			Description -> "Any problems reported with instruments related to this operations support ticket.",
			Category -> "Organizational Information"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Site],
			Description -> "The ECL site that this ticket originates from.",
			Category -> "Organizational Information"
		},
		BlockingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The estimated amount of operator time required to complete the tasks (blocking cover, blocking storage etc) required to put the protocol into Scientific Support.",
			Category -> "Protocol Support",
			Developer -> True
		},
		SupportQueueTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The estimated amount of wait time at the current level of escalation before the responder can begin to address this support ticket.",
			Category -> "Protocol Support",
			Developer -> True
		},
		SupportQueueTimeLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Real},
			Pattern :> {_?DateObjectQ, _Link, GreaterEqualP[0 Minute]},
			Relation -> {Null, Object[User], Null},
			Units -> {None, None, Minute},
			Description -> "A log of the estimates of the amount of wait time at the current level of escalation before the responder can begin to address this support ticket.",
			Category -> "Protocol Support",
			Headers -> {"Date", "Person Deciding", "Time Estimate"},
			Developer -> True
		},
		EstimatedFixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "An assessment of the amount of active advanced support time required at the current level of escalation to resolve this support ticket.",
			Category -> "Protocol Support",
			Developer -> True
		},
		EstimatedFixTimeLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Real},
			Pattern :> {_?DateObjectQ, _Link, GreaterEqualP[0 Minute]},
			Relation -> {Null, Object[User], Null},
			Units -> {None, None, Minute},
			Description -> "A log of the assessments of the amount of active advanced support time required at the current level of escalation to address this support ticket.",
			Category -> "Protocol Support",
			Headers -> {"Date", "Person Deciding", "Time Estimate"},
			Developer -> True
		},
		BlockRecommended -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if blocking this protocol is currently recommended as the estimated advanced support resolution time exceeds the blocking overhead.",
			Category -> "Protocol Support",
			Developer -> True
		},
		BlockRecommendedLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Boolean},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of whether blocking this protocol is recommended as the estimated advanced support resolution time exceeds the blocking overhead.",
			Category -> "Protocol Support",
			Headers -> {"Date", "Person Deciding", "Block Recommended?"},
			Developer -> True
		},
		ExternalDiscussions -> {
			Format -> Multiple,
			Class -> {
				ProjectID -> String,
				ProjectName -> String,
				ThreadID -> String
			},
			Pattern :> {
				ProjectID -> _String,
				ProjectName -> _String,
				ThreadID -> _String
			},
			Description -> "The projects and IDs of the message threads used for discussion of this support ticket.",
			Category -> "Protocol Support",
			Developer -> True
		},
		ErrorMessage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The message text of the Mathematica error responsible for this support ticket.",
			Category -> "Organizational Information"
		}
	}
}];
