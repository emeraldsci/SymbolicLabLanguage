(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Troubleshooting, Report], {
	Description->"A report of an issue encountered encountered in the ECL and the steps taken to resolve the issue.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		TroubleshootingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TroubleshootingReportTypeP,
			Description -> "Describes the category of Troubleshooting that the Report is classified under: Protocol implies that the troubleshooting is related to the execution or result of a protocol, Application refers to a software bug in any of the ECL applications, and Function implies a bug in a Emerald libary function call.",
			Category -> "Troubleshooting",
			Abstract -> True
		},				
		AffectedProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][TroubleshootingReports],
				Object[Qualification][TroubleshootingReports],
				Object[Maintenance][TroubleshootingReports]
			],
			Description -> "The protocol, Qualification or maintenance to which this troubleshooting applies.",
			Category -> "Troubleshooting"
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
			Description -> "A log of the affected protocol, Qualification or maintenance to which this troubleshooting applies.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Reporting","Protocol"},
			Developer -> True
		},
		AffectedScript->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Notebook,Script][TroubleshootingReports],
			Description->"The script to which this troubleshooting applies.",
			Category->"Troubleshooting"
		},
		AffectedTransaction -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][TroubleshootingReports],
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
		Refund -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates a refund was issued for the AffectedProtocol as a result of this troubleshooting.",
			Category -> "Troubleshooting"
		},		
		RefundLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Boolean},
			Pattern :> {_?DateObjectQ, _Link, BooleanP},
			Relation -> {Null, Object[User], Null},
			Units -> {None, None, None},
			Description -> "A log of the refund issued as a result of this troubleshooting.",
			Category -> "Troubleshooting",
			Headers -> {"Date","Person Authorizing","Refund"}
		},		
		TaggedTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[SupportTicket, Operations][AssociatedReports]
			],
			Description -> "The list of troubleshooting tickets associated with this report.",
			Category -> "Troubleshooting"
		}
	}
}];
