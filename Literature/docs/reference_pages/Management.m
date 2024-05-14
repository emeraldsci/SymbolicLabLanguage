

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*FindJournal*)

DefineUsage[FindJournal,
{
	BasicDefinitions -> {
		{"FindJournal[jour]", "match", "returns a journal title, 'match', that is a member of JournalP, either by automatically matching an existing entry or having the user manually choose an existing or new entry."}
	},
	Input :> {
		{"jour", _String, "A journal title to be matched to an existing member of JournalP, or added to JournalP itself."}
	},
	Output :> {
		{"match", JournalP, "A journal title that matches JournalP, whether it already existed in JournalP or was added by the function."}
	},
	SeeAlso -> {
		"FindKeyword",
		"UploadLiterature"
	},
	Author -> {"ben", "olatunde.olademehin"},
	Guides -> {

	},
	Tutorials -> {

	}
}];

(* ::Subsubsection::Closed:: *)
(*FindKeyword*)

DefineUsage[FindKeyword,
{
	BasicDefinitions -> {
		{"FindKeyword[word]", "match", "returns a keyword, 'match', that is a member of JournalP, either by automatically matching an existing entry or having the user manually choose an existing or new entry."}
	},
	Input :> {
		{"word", _String, "A keyword to be matched to an existing member of KeywordP, or added to KeywordP itself."}
	},
	Output :> {
		{"match", KeywordP, "A keyword that matches KeywordP, whether it already existed in KeywordP or was added by the function."}
	},
	SeeAlso -> {
		"FindJournal",
		"UploadLiterature"
	},
	Author -> {"ben", "olatunde.olademehin"},
	Guides -> {

	},
	Tutorials -> {

	}
}];