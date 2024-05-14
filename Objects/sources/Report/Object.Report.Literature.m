(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Report, Literature], {
	Description->"A report containing references from published scientific literature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LiteratureFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "PDFs containing the literature references represented in this report.",
			Category -> "Literature Information"
		},
		Keywords -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Key descriptive words about this literature that have been manually assigned.",
			Category -> "Literature Information",
			Abstract -> True
		},
		DocumentType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DocumentTypeP,
			Description -> "The category of document to which this literature belongs.",
			Category -> "Literature Information",
			Abstract -> True
		},
		Title -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The title of the piece of literature.",
			Category -> "Literature Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The list of names of the authors of the literature.",
			Category -> "Literature Information",
			Abstract -> True
		},
		ContactInformation -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Contact information for the corresponding author.",
			Category -> "Literature Information"
		},
		Journal -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the journal publishing the article.",
			Category -> "Literature Information"
		},
		PublicationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the literature was published.",
			Category -> "Literature Information"
		},
		Volume -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The journal volume in which this article appears.",
			Category -> "Literature Information"
		},
		StartPage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The page on which the article begins.",
			Category -> "Literature Information"
		},
		EndPage -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The page on which the article ends.",
			Category -> "Literature Information"
		},
		Issue -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The journal issue in which this document appears.",
			Category -> "Literature Information"
		},
		Edition -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The edition of this document.",
			Category -> "Literature Information"
		},
		ISSN -> {
			Format -> Single,
			Class -> String,
			Pattern :> ISSNP,
			Description -> "The international Standard Serial Number (ISSN) for this document.",
			Category -> "Literature Information"
		},
		ISSNType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ISSNTypeP,
			Description -> "The International Standard Serial Number (ISSN) type for this document.",
			Category -> "Literature Information"
		},
		DOI -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The digital Object Identifer (DOI) for this document.",
			Category -> "Literature Information"
		},
		URL -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The Uniform resource locator (URL) for where this document is published on the web.",
			Category -> "Literature Information"
		},
		Abstract -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The abstract written by the authors of the literature and summarizing its contents.",
			Category -> "Literature Information"
		},
		PubmedID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Pubmed Object for the document.",
			Category -> "Literature Information"
		},
		References -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Molecule][LiteratureReferences],
				Model[Virus][LiteratureReferences],
				Model[PrimerSet][LiteratureReferences],
				Model[Physics][LiteratureReferences],
				Model[Qualification][LiteratureReferences,2]
			],
			Description -> "Objects which this literature pertains to.",
			Category -> "Organizational Information"
		}
	}
}];
