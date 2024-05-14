(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Transaction], {
	Description->"A record of the purchase of one or more items of the same catalog number from an external supplier.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Creator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User][TransactionsCreated],
			Description -> "User who created this transaction.",
			Category -> "Organizational Information"
		},
		DateShipped -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date that the items were shipped from the Source to the Destination.",
			Category -> "Organizational Information"
		},
		DateExpected -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date that the items are expected to reach their destination.",
			Category -> "Organizational Information"
		},
		DateDelivered -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date that the items arrived at their destination.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateCanceled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date that the transaction was canceled.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateLastChecked -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "If this transaction has not arrived at the ECL site or shipped from the ECL site within the expected time frame, the date that a reminder was sent to check on this transaction.",
			Category -> "Organizational Information",
			Developer -> True
		},
		LockedFromReceiving -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this transaction is currently in the process of being received and thus another receiving cannot be created for it at the moment.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Destination -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The site where objects from this transaction will be shipped.",
			Category -> "Shipping Information"
		},
		Source -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The site or supplier where samples from this transaction are shipped from.",
			Category -> "Shipping Information"
		},
		Shipper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Shipper][Transactions],
			Description -> "The shipping company used to deliver the items of this transaction to their final destination.",
			Category -> "Shipping Information"
		},
		TrackingNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Tracking numbers provided by the shipping company for the transaction.",
			Category -> "Shipping Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Receipt -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Report, Receipt][Transactions],
			Description -> "The receipt report associated with the transaction containing paperwork including confirmation emails, packing slips, etc.",
			Category -> "Analysis & Reports"
		},
		UserCommunications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SupportTicket, UserCommunication][AffectedTransaction],
			Description -> "Discussions with users about the fulfillment of this transaction.",
			Category -> "Organizational Information"
		},
		OperationsSupportTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[SupportTicket, Operations][AffectedTransaction],
			Description -> "Support tickets associated with the fulfillment of this transaction.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* == Fields to Be Replaced, should be removed April 2024 post migration to SupportTicket ==*)
		TroubleshootingReports -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Troubleshooting, Report][AffectedTransaction],
			Description -> "Troubleshooting reports associated with the fulfillment of this transaction.",
			Category -> "Troubleshooting"
		},
		TroubleshootingTickets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Troubleshooting, Ticket][AffectedTransaction],
			Description -> "Troubleshooting tickets associated with the fulfillment of this transaction.",
			Category -> "Troubleshooting",
			Developer -> True
		},

		(* ===== *)

		Troubleshooting -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this transaction is currently in troubleshooting.",
			Category -> "Troubleshooting"
		},

		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		StoragePrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD/Month],
			Units -> USD/Month,
			Description -> "The total monthly price for warehousing all user owned items associated with this transaction in an ECL facility under the storage conditions specified by each item.",
			Category -> "Storage Information"
		},
		StoragePrices -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*USD/Month],
			Units -> USD/Month,
			Description -> "The running tally of the total monthly price for warehousing all user owned items associated with this transaction in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
			Category -> "Storage Information",
			Developer -> True
		},
		StoredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Item],
				Object[Sensor],
				Object[Wiring]
			],
			Description -> "List of all physical items associated with this transaction that are currently being warehoused in an ECL facility.",
			Category -> "Storage Information"
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date any physical items associated with this transaction were last handled in the lab.",
			Category -> "Storage Information"
		},
		ReceivingTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PercentP,
			Units -> Percent,
			Description -> "The allowable difference between the received amount of a received object and the expected amount that was ordered or shipped in the transaction. If the difference is outside the ReceivingTolerance, the object will not be received, and will be investigated by Systems Diagnostics.",
			Category -> "Analysis & Reports",
			Developer -> True
		},
		SupplierProvidedDocumentation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Digital scans of physical documents from an external supplier which arrive with received objects.",
			Category -> "Analysis & Reports"
		},
		ShippedRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Rack], Model[Container, Rack]],
			Description -> "A list of rack objects or models shipped as part of the transaction.",
			Category -> "Storage Information"
		},

	(* --- Option Handling --- *)
		ResolvedOptions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_Rule...},
			Units -> None,
			Description -> "The final options used as parameters for this protocol, after automatic options are resolved.",
			Category -> "Option Handling"
		},
		UnresolvedOptions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_Rule...},
			Units -> None,
			Description -> "The verbatim options originally input by the protocol author to generate this protocol, often with some options set to Automatic.",
			Category -> "Option Handling"
		},

		(* -- For V1 of Afterburner, we only want to display those transactions that were created from Afterburner in the dashboard. -- *)
		(*  This field will be False for any transaction that are created from CC/CCD, and True for those from Afterburner. *)
		FromAfterburner -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> True|False,
			Description -> "Indicates if this transaction was created from within Afterburner.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
