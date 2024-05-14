(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Pricing Functions",
	Abstract -> "Collection of functions uses to estimate charges generated through the conduct of experimentation in an ECL facility.",
	Reference -> {
		"Experiment Pricing" -> {
			{PriceExperiment, "Generates a summary table of all the charges associated with the conduct of a given experimental protocol or all of the protocols in a given notebook."},
			{PriceMaterials, "Generates a table of the materials ordered or purchased in order to conduct a given experimental protocol or all of the protocols in a given notebook."},
			{PriceInstrumentTime, "Generates a table of the instrument time purchased in order to conduct a given experimental protocol or all of the protocols in a given notebook."},
			{PriceWaste, "Generates a table of the generated waste and disposal charges in order to conduct a given experimental protocol or all of the protocols in a given notebook."}
		},
		"Sample Management" -> {
			{PriceTransactions, "Generates a table of the transactional charges associated with a given transaction or protocol, or all of the transactions and protocols in a given notebook."},
			{PriceCleaning, "Generates a table of the charges associated with the cleaning of all the containers associated with a given notebook or all the notebooks of a given team."},
			{PriceStorage, "Generates a table of the ongoing storage costs for storing all the samples associated with a given notebook or all the notebooks of a given team."},
			{PriceStocking, "Generates a table of the pricing information for the restocking of public samples generated during a protocol or associated with a given notebook or all the notebooks of a given team."}
		},
		"Resource Requests" -> {
			{Resource, "Wrapper for defining a resource request within the ECL facility for use in conducting experiments."},
			{ValidResourceQ, "Checks if a give Resource request is properly formatted for its given type of resource."}
		}
	},
	RelatedGuides -> {
		GuideLink["RunningExperiments"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"]
	}
]
