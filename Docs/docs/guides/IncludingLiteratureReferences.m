(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Including Literature References",
	Abstract -> "Collection of functions for uploading literature references (such as journal articles, books, etc.) and linking them to Constellation objects where appropriate.",
	Reference -> {
		"Search and Upload literature" -> {
			{UploadLiterature, "Given a Pubmed ID or EndNote File, returns a packet for a Report Literature Constellation object so that this literature may be linked to other Constellation objects."},
			{FindJournal, "Returns the closest matching journal name based on a provided string."},
			{FindKeyword, "Returns the closest matching keyword based on a provided string."},
			{PDBIDExistsQ, "Checks to see if a given ID can be found in the Protein Data Bank."},
			{UploadJournal, "Given the journal name, returns a packet for a Report Literature Constellation object."}
		},
		"Validating" -> {
			{ValidUploadLiteratureQ, "Checks if the uploaded literature Constellation object is valid."}

		},
		"Calculate Options" -> {
			{UploadJournalOptions, "Computes and returns the resolved options when calling UploadJournal."},
			{UploadLiteratureOptions, "Returns the resolved options when uploading a literature Constellation object."}
		},
		"Preview" -> {

		}
	},
	RelatedGuides -> {
		GuideLink["WorkingWithConstellationObjects"],
		GuideLink["ObjectOntology"],
		GuideLink["EmeraldCloudFiles"],
		GuideLink["ConstellationUtilityFunctions"]
	}
]
