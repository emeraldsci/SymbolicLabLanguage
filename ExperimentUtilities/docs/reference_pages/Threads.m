(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*AvailableThreads*)

DefineUsage[AvailableThreads,
	{
		BasicDefinitions -> {
			{"AvailableThreads[teams]", "threads", "returns the number of unused threads for 'teams' to indicate how many more protocols the 'teams' may run at their current subscription level. The number of threads available is the team's MaxThreads minus any processing protocols that are not blocked by resources and not using a default cell incubator."},
			{"AvailableThreads[user]", "threads", "returns the number of unused threads for each of the financing teams of which 'user' is a member."},
			{"AvailableThreads[]", "threads", "returns the number of unused threads for each of the financing teams of which the currently logged in user is a member."}
		},
		Input :> {
			{"teams", ListableP[ObjectP[Object[Team, Financing]]] | {}, "The team(s) for which to calculate the available threads."},
			{"user", ObjectP[Object[User]], "The user for which to calculate the available threads."}
		},
		Output :> {
			{"threads", ListableP[_Integer] | {}, "The available threads for each input team or input user's team(s)."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"OpenThreads",
			"UploadProtocolStatus",
			"UploadTroubleshooting",
			"UploadNotebook"
		},
		Author -> {"robert", "alou"}
	}];

(* ::Subsubsection::Closed:: *)
(*OpenThreads*)

DefineUsage[OpenThreads,
	{
		BasicDefinitions -> {
			{"OpenThreads[teams]", "protocols", "returns the protocols of 'teams' that are using threads (i.e., processing protocols that are not blocked by resources or by using a default cell incubator)."},
			{"OpenThreads[user]", "protocols", "returns the protocols that are using threads for each of the financing teams of which 'user' is a member."},
			{"OpenThreads[]", "protocols", "returns the protocols that are using threads for each of the financing teams of which the currently logged in user is a member."}
		},
		Input :> {
			{"teams", ListableP[ObjectP[Object[Team, Financing]]] | {}, "The team(s) for which to return the protocols."},
			{"user", ObjectP[Object[User]], "The user for whose teams to return the protocols."}
		},
		Output :> {
			{"protocols", ListableP[ObjectP[Object[Protocol]]] | {}, "For each input team or input user's team(s), the protocols that are using threads."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AvailableThreads",
			"UploadProtocolStatus",
			"UploadTroubleshooting",
			"UploadNotebook"
		},
		Author -> {"robert", "alou"}
	}];

DefineUsage[syncBacklog,
	{
		BasicDefinitions -> {
			{"syncBacklog[teams]", "protocols", "determines the current number of available threads and sets that many of 'teams' backlogged protocol to processing."}
		},
		MoreInformation -> {
			"A team's backlog is the set of protocols waiting to be processed in the lab.",
			"A protocol's status will move from Backlogged to Processing once threads are available.",
			"The order of a team's Backlog is the order that protocols will run in the lab.",
			"syncBacklog will determine the number of free threads available (if any) and move as many protocols from the front of the Backlog into Processing."
		},
		Input :> {
			{"teams", ListableP[ObjectP[Object[Team, Financing]]] | {}, "The team(s) for which protocols will be transfered from the backlog to processing."}
		},
		Output :> {
			{"protocols", ListableP[ObjectP[Object[Protocol]]] | {}, "For each input team, the protocols that are going to be moved from the team's backlog to processing."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AvailableThreads",
			"OpenThreads",
			"UploadProtocolStatus",
			"UploadTroubleshooting",
			"UploadNotebook"
		},
		Author -> {
			"robert", "alou"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*PrioritizeBacklog*)

DefineUsage[PrioritizeBacklog,
	{
		BasicDefinitions -> {
			{"PrioritizeBacklog[protocols]", "team", "modifies the order that a team's backlogged protocols will be run in the lab by moving the protocols to the front of the current backlog."}
		},
		MoreInformation -> {
			"A team's backlog is the set of protocols waiting to be processed in the lab.",
			"A protocol's status will move from Backlogged to Processing once threads are available.",
			"The order of a team's Backlog is the order that protocols will run in the lab.",
			"PrioritizeBacklog will move its input to the front of the backlog list."
		},
		Input :> {
			{"protocols", ListableP[ObjectP[Object[Protocol]]], "The backlog protocols to run in the lab first."}
		},
		Output :> {
			{"team", ObjectP[Object[Team, Financing]], "The team whose backlog was reprioritizated."}
		},
		Behaviors -> {"ReverseMapping"},
		Sync -> Automatic,
		SeeAlso -> {
			"AvailableThreads",
			"UploadProtocolStatus"
		},
		Author -> {"robert", "alou"}
	}];
	