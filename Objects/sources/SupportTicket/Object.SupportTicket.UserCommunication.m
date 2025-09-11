(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[SupportTicket, UserCommunication], {
	Description->"A report of an issue encountered encountered in the ECL and the steps taken to resolve the issue.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		SupportTicketSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TroubleshootingReportTypeP,
			Description -> "Describes the type of event which generated the support ticket.",
			Category -> "Organizational Information",
			Abstract -> True
		},				
		AffectedProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][UserCommunications],
				Object[Qualification][UserCommunications],
				Object[Maintenance][UserCommunications]
			],
			Description -> "The protocol, qualification or maintenance being discussed in this ticket.",
			Category -> "Organizational Information"
		},
		AffectedProtocolLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Object[User],
				Object[Protocol]|Object[Qualification]|Object[Maintenance]
			},
			Description -> "A log of the affected protocol, qualification or maintenance which this ticket references.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Protocol"},
			Developer -> True
		},
		AffectedScript->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Notebook,Script][UserCommunications],
			Description->"The script which this ticket references.",
			Category->"Organizational Information"
		},
		AffectedTransaction -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][UserCommunications],
			Description -> "The transaction .",
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
			Description -> "A log of the affected transaction which this ticket references.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Reporting","Transaction"},
			Developer -> True
		},				
		Refund -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates a refund was issued for the AffectedProtocol.",
			Category -> "Organizational Information"
		},		
		RefundLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Boolean},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Units -> {None, None, None},
			Description -> "A record of when a refund was issued and by whom.",
			Category -> "Organizational Information",
			Headers -> {"Date","Person Authorizing","Refund"}
		},		
		TaggedTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[SupportTicket, Operations][AssociatedCommunications]
			],
			Description -> "The list of operations tickets associated with this user communication.",
			Category -> "Organizational Information"
		},
		UserResponseRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if information is needed before this ticket can be resolved and any associated protocols can continue.",
			Category -> "Organizational Information"
		}
	}
}];
