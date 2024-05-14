(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Help Files*)


(* ::Subsubsection:: *)
(*DefineUsage*)


DefineUsage[DefineUsage,{
	BasicDefinitions->{
		{"DefineUsage[f,usageRules]","out","sets the Usage for 'f' from 'usageRules'.  Also writes Information for 'f'."}
	},
	Input:>{
		{"f",_,"Name of function whose Usage fields are being set."},
		{"usageRules",UsageP,"List of rules defining Usage fields for 'f'."}
	},
	Output:>{
		{"out",Null,"Returns Null."}
	},
	Tutorials->{},
	SeeAlso->{"SyncDocumentation","DefineOptions"},
	Author->{"platform","thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*Authors*)


DefineUsage[Authors,
	{
		BasicDefinitions -> {
			{"Authors[f]", "out", "returns a list of Authors listed in either the Usage rules or help file text for 'f'."},
			{"Authors[obj]", "out", "returns a list of Authors in charge of the SLL object 'obj'."}
		},
		Input :> {
			{"f", _Symbol, "A function to pull the Authors of."}
		},
		Output :> {
			{"out", {_String...}, "A list of Authors assigned to the given function or type."}
		},
		SeeAlso -> {
			"Examples",
			"DefineUsage"
		},
		Author -> {"brad"}
	}];


(* ::Subsubsection::Closed:: *)
(*PacletMapping*)


DefineUsage[PacletMapping,
	{
		BasicDefinitions -> {
			{"PacletMapping[]", "mapping", "returns the 'mapping' from ECL paclet URIs to files in S3."}
		},
		MoreInformation -> {
			"A mapping will only be present in a pre-built distro. In development this will always return Null",
			"This mapping should be used to open help files in the command center. \
			The S3 key should be downloaded as an EmeraldCloudFile so it can be opened as a documentation notebook",
			"The mapping is loaded from a local file at $EmeraldPath/documentation.json (if it exists)."
		},
		Output :> {
			{"mapping", Null|_Association, "A mapping from paclet URI strings to S3 key + bucket information."}
		},
		SeeAlso -> {
			"DefineUsage",
			"BuildDistroArchives"
		},
		Author -> {"platform"}
	}];

(* ::Subsubsection:: *)
(*Usage*)


DefineUsage[Usage,{
	BasicDefinitions->{
		{"Usage[function]","usage","returns the usage for the given function in an association."}
	},
	Input:>{
		{"function",_,"Name of function whose Usage is being returned."}
	},
	Output:>{
		{"out",_Association,"The usage of the function."}
	},
	Tutorials->{},
	SeeAlso->{"DefineUsage"},
	Author->{"platform","thomas","steven"}
}];
