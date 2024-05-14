(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Inventory Tracking",
	Abstract -> "Collection of functions for tracking and managing inventory within an ECL facility.",
	Reference -> {
		"Inventory Tracking" -> {
			{ClearSampleStorageSchedule, "Erases any pending storage changes of the indicated sample and sets the storage condition such that the sample stays where it is currently."},
			{PlotInventory, "Displays the inventory dashboard, filtered by name or notebook."}

		},

		"Validating" -> {
			{ValidContainerStorageConditionQ, "Checks if the given samples' storage conditions are compatible with other samples in the same container."},
			{ValidUploadInventoryQ, "Checks if it is valid to call UploadInventory function on given input product object."},
			{ValidUploadProductQ, "Checks if a valid product object can be generated from the input URL."},
			{ValidDiscardSamplesQ, "Checks if the input object is not in use by any protocol and can thus be marked for disposal."},
			{ValidContainerStorageConditionQ, "Checks if the given samples' storage conditions are compatible with other samples in the same container."}

		},

		"Calculate Options" -> {
			{DiscardSamplesOptions, "Returns the resolved options that would be used if the given samples were discarded."},
			{StoreSamplesOptions, "Returns the resolved options that would be used if the given samples were to be stored under the provided storage condition."},
			{UnrestrictSamplesOptions, "Returns the resolved options for calling UnrestrictSamples on input samples."},
			{UploadInventoryOptions, "Returns a list of resolved options when uploading an Inventory object to keep the specified Product in stock."},
			{UploadStockSolutionOptions, "Returns a list of resolved options when generating a new stock solution model with the given components, solvent and total volume."},
			{StoreSamplesOptions, "Returns the resolved options that would be used if the given samples were to be stored under the provided storage condition."},
			{UploadProductOptions, "Returns the resolved options that would be used by upload product when called on a product URL."}
		},

		"Preview" -> {
			{CancelDiscardSamplesPreview, "Returns a preciw to cancel the pending discard request for the objects to ensure they will not be discarded."}
		}
	},
	RelatedGuides -> {
		GuideLink["SampleStorage"],
		GuideLink["SampleShipments"],
		GuideLink["LocationTracking"]
	}
]