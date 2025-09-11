(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PrioritizeBacklog*)


DefineUsage[UploadProtocolPriority,
	{
		BasicDefinitions -> {
			{"UploadProtocolPriority[myProtocol]", "protocolObject", "modifies the priority of the given protocol that will run in the lab."}
		},
		Input :> {
			{"myProtocol", ObjectP[Object[Protocol]], "The protocol to modify."}
		},
		Output :> {
			{"protocolObject", ObjectP[Object[Protocol]], "The protocol whose priority was changed."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AvailableThreads",
			"UploadProtocolStatus"
		},
		Author -> {"xu.yi", "waseem.vali", "malav.desai", "thomas"}
	}];
	