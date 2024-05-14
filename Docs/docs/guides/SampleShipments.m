(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Sample Shipments",
	Abstract -> "Collection of functions for handling shipping of materials into and out of an ECL facility as well as the purchase of materials to be used in an ECL facility.",
	Reference -> {

		"Purchasing Inventory" -> {
			{OrderSamples, "Places an order for the given materials to be purchased and added to the users inventory."},
			{DropShipSamples, "Generates a transaction to track a user-initiated shipment from a third party provider."},
			{CancelTransaction, "Cancels the given outstanding order or drop shipment if it has not already been fulfilled or received."},
			{PriceTransactions, "Generates a table of the receiving charges associated with a given transaction or all of the transactions in a given notebook."},
			{SyncOrders, "Process any pending orders which can be directly purchased from the ECL by transferring ownership of the samples in the database, and any DropShipToUser orders which can send to user's home site."},
			{UploadCompanyService, "Generates an object for the specified company that systhesizes custom made samples as a service."},
			{UploadCompanySupplier, "Generates a supplier object that contains the information about the supplier when called using the supplier name."}
		},

		"Shipping Materials" -> {
			{ShipToECL, "Generates a transaction to track a user-initiated shipment from their own lab to an ECL facility."},
			{ShipToUser, "Instructs the ECL to ship the given samples from an ECL facility to the users lab."},
			{CancelTransaction, "Cancels the given outstanding shipment transaction if it has not already shipped."},
			{PriceTransactions, "Generates a table of the shipping charges associated with a given transaction or all of the transactions in a given notebook."},
			{UploadTransportCondition, "Modifies the corresponding transport conditions for the specifed samples."}
		},

		"Validating" -> {
			{ValidUploadCompanyServiceQ, "Checks whether the provided company is valid."},
			{ValidOrderSamplesQ, "Checks if the provided samples and options are valid inputs for a purchasing order."},
			{ValidUploadTransportConditionQ, "Checks if the provided samples and transport conditions are valid for specifying those samples' transport conditions."},
			{ValidShipToUserQ, "Checks whether the provided samples and specified options are would lead to a valid ShipToUser call."},
			{ValidCancelTransactionQ, "Checks whether the provided transaction and specified options are valid for calling CancelTransaction function."},
			{ValidDropShipSamplesQ, "Checks the provided inputs and ordered items and order numbers, or transactions are valid for called them with DropShipSamples."}
		},

		"Preview" -> {
			{OrderSamplesOptions, "Generates the resolved options when the amount of sample is specified."},
			{ShipToECLPreview, "Returns the preview for ShipToECL function when trying to send samples and items to ECl."},
			{ShipToUserPreview, "Displays a graphical preview of the output that would happen if the given samples were to be shipped to a user."},
			{CancelTransactionPreview, "Displays a graphical preview of what would happen if a specified transaction was cancelled."},
			{UploadTransportConditionPreview, "Returns a preview for when the specific conditions for the transport of a sample is changed."}
		},
		
		"Calculate Options" ->{
			{ShipToECLOptions, "Returns a list of options that generates a transaction to track a user-initiated shipment from their own lab to an ECL facility."},
			{DropShipSamplesOptions, "Returns a list of options to track user initiated shipment from a third party or to add shipping information to an existing transaction."}
		},
		
		"Manage Suppliers" -> {
			{UploadCompanySupplierOptions, "Returns a list of options as they will be resolved by UploadCompanySupplier."}
		}

	},
	RelatedGuides -> {
		GuideLink["SampleStorage"],
		GuideLink["LocationTracking"],
		GuideLink["UploadingNewSamplesOrModels"]
	}
]
