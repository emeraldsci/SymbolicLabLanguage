(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Location Tracking",
	Abstract -> "Collection of functions of assessing physical locations of materials within an ECL facility.",
	Reference -> {

		"Physical Location Tracking" -> {
			{Location, "Generates a table describing a given sample or containers current location within an ECL facility or its location at a provided date."},
			{PlotLocation, "Generates an interactive plot of the location of an object or position within the ECL facility where it is presently located."},
			{PlotContents, "Generates an interactive plot of the current contents of a given container or position within an ECL facility."},
			{UploadSite, "Generates or edits address information for the given team."}
		},

		"Microplate Positions" -> {
			{AllWells, "Returns a matrix of all possible well positions in a microtiter plate."},
			{ConvertWell, "Converts microtiter plate well identifiers  between different index and position formats."}
		}

	},
	RelatedGuides -> {
		GuideLink["SampleStorage"],
		GuideLink["SampleShipments"]
	}
]
