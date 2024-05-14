(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Materials Handling",
	Abstract -> "Collection of functions for handling materials in ECL facility, including purchasing, management, shipping, tracking and pricing.",
	Reference -> {

		"Managing Inventory" -> {
			{ClearSampleStorageSchedule, "Erases any pending storage changes of the indicated sample and sets the storage condition such that the sample stays where it is currently."},
			{StoreSamples, "Changes the conditions under which a given sample should be stored between experiments."},
			{RestrictSamples, "Marks a given sample as unavailable for satisfying resource requests of the team's experiments without explicitly referring to the sample ID in the experiment function."},
			{UnrestrictSamples, "Indicates that a given sample should be made available to satisfy any resource requests made by the team's experiments."},
			{DiscardSamples, "Indicates that a given sample for should be discarded at the facilities next regular maintenance cycle."},
			{CancelDiscardSamples, "Cancels the request to discard a sample in the next maintenance cycle if it has not yet been discarded."}
		},

		"Purchasing Inventory" -> {
			{OrderSamples, "Places an order for the given materials to be purchased and added to the users inventory."},
			{DropShipSamples, "Generates a transaction to track a user-initiated shipment from a third party provider."},
			{CancelTransaction, "Cancels the given outstanding order or drop shipment if it has not already been fulfilled or received."},
			{ValidCancelTransactionQ, "Checks whether the provided transaction and specified options are valid for calling CancelTransaction function."}
		},

		"Shipping Materials" -> {
			{ShipToECL, "Generates a transaction to track a user-initiated shipment from their own lab to an ECL facility."},
			{ShipToUser, "Instructs the ECL to ship the given samples from an ECL facility to the users lab."},
			{CancelTransaction, "Cancels the given outstanding shipment transaction if it has not already shipped."}
		},

		(* TODO: consider nested guides *)
		"Sample Locations: Microplate Handling" -> {
			{AllWells, "Returns a matrix of all possible well positions in a microtiter plate."},
			{ConvertWell, "Converts microtiter plate well identifiers  between different index and position formats."}
		},
		"Sample Locations: Physical Locations" -> {
			{Location, "Generates a table describing a given sample or containers current location within an ECL facility or its location at a provided date."},
			{PlotLocation, "Generates an interactive plot of the location of an object or position within the ECL facility where it is presently located."},
			{PlotContents, "Generates an interactive plot of the current contents of a given container or position within an ECL facility."}
		},

		"Pricing Functions" -> {
			{PriceStorage, "Generates a table of the ongoing storage costs for storing all the samples associated with a given notebook or all the notebook of a given team."},
			{PriceTransactions, "Generates a table of the receiving charges associated with a given transaction or all of the transactions in a given notebook."},
			{PriceOperatorTime, "Generates a table of the pricing information for all operators who worked on the given protocol."}
		}

	},
	RelatedGuides -> {
	}
]
