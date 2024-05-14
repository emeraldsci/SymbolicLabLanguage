(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Sample Storage",
	Abstract -> "Collection of functions for managing the storage of the team's inventory within an ECL facility.",
	Reference -> {

		"Inventory Management" -> {
			{ClearSampleStorageSchedule, "Erases any pending storage changes of the indicated sample and sets the storage condition such that the sample stays where it is currently."},
			{StoreSamples, "Changes the conditions under which a given sample should be stored between experiments."},
			{DiscardSamples, "Indicates that a given sample for should be discarded at the facilities next regular maintenance cycle."},
			{CancelDiscardSamples, "Cancels the request to discard a sample in the next maintenance cycle if it has not yet been discarded."},
			{RestrictSamples, "Marks a given sample as unavailable for satisfying resource requests of the team's experiments without explicitly referring to the sample ID in the experiment function."},
			{UnrestrictSamples, "Indicates that a given sample should be made available to satisfy any resource requests made by the team's experiments."},
			{PriceStorage, "Generates a table of the ongoing storage costs for storing all the samples associated with a given notebook or all the notebook of a given team."},
			{ValidRestrictSamplesQ, "Checks whether the given sample and specified options are valid for calling RestrictSamples function."},
			{ExpiredSamples, "Generates a list of expired samples the related information for those sample based on the threshold date specified."}
		},

		"Physical Location Tracking" -> {
			{Location, "Generates a table describing a given sample or containers current location within an ECL facility or its location at a provided date."},
			{PlotLocation, "Generates an interactive plot of the location of an object or position within the ECL facility where it is presently located."},
			{PlotContents, "Generates an interactive plot of the current contents of a given container or position within an ECL facility."}
		},

		"Validating"-> {
			{ValidDiscardSamplesQ, "Checks if the input object is not in use by any protocol and can thus be marked for disposal."},
			{ValidUnrestrictSamplesQ, "Checks if the input sample can be made available to satisfy any resource request made by the team's experiments."},
			{ValidStorageConditionQ, "Checks if the input object can be stored in the input storage condition."},
			{ValidStoreSamplesQ, "Checks if the provided samples can be stored under the provided condition or the DefaultStorageCondition is conditions is not provided."}
		},
		"Calculate Options" -> {
			{CancelDiscardSamplesOptions, "Returns a list of options for canceling the request to discard a sample in the next maintenance cycle if it still needs to be discarded."},
			{UnrestrictSamplesOptions, "Returns the resolved options for calling UnrestrictSamples on input samples."}
		}

	},
	RelatedGuides -> {
		GuideLink["SampleShipments"],
		GuideLink["LocationTracking"]
	}
]
