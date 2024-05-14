(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Journal], {
	Description->"A scientific journal that regularly published research articles or review articles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* ---Journal Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of a journal.",
			Category -> "Journal Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names of this journal.",
			Category -> "Journal Information",
			Abstract -> True
		},
		Website -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The journal's website URL.",
			Category -> "Journal Information",
			Abstract -> True
		},
		SubjectAreas->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> JournalSubjectAreaP,
			Description -> "The main subject areas that this journal contains.",
			Category -> "Journal Information",
			Abstract -> True
		},
		OpenAccess -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the articles published in this journal can be accessed for free.",
			Category -> "Journal Information"
		},
		PublicationFrequency->{
			Format -> Single,
			Class -> Expression,
			Pattern :> PublicationFrequencyP,
			Description -> "Indicates how often this journal publish a new issue.",
			Category -> "Journal Information"
		},
		ISSN -> {
			Format -> Single,
			Class -> String,
			Pattern :> ISSNP,
			Description -> "The international Standard Serial Number (ISSN) for this journal.",
			Category -> "Journal Information"
		},
		OnlineISSN -> {
			Format -> Single,
			Class -> String,
			Pattern :> ISSNP,
			Description -> "The online international Standard Serial Number (ISSN-Online) for this journal.",
			Category -> "Journal Information"
		},
		Address->{
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The address of the journal's main offices.",
			Category -> "Journal Information"
		},
		Discontinued->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description ->"Indicates if the journal does no longer publish new issues.",
			Category -> "Journal Information"
		},

		(* ---Organizational Information --- *)
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
