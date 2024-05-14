(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Manifold Computation Functions*)


(* ::Subsubsection::Closed:: *)
(*StopComputation*)


DefineUsage[StopComputation,{
	BasicDefinitions->{
		{"StopComputation[computations]","stoppedComputations","sets the Status of one or more 'computations' to Stopping, which will stop the computation(s) after the currently evaluating cell has completed."}
	},
	Input:>{
		{"computations",ListableP[ObjectP[Object[Notebook,Computation]]],"One or more Manifold Computation objects."}
	},
	Output:>{
		{"stoppedComputations",ListableP[ObjectP[Object[Notebook,Computation]]],"Object[Notebook,Computations] objects which have been stopped."}
	},
	MoreInformation->{
		"Computations can only be stopped if they have a current status of Queued, Ready, Staged, or Running.",
		"Queued, Ready, and Staged jobs will be Stopped immediately.",
		"Running jobs will be Stopped after the currently evaluating cell has completed."
	},
	SeeAlso->{
		"Compute",
		"AbortComputation",
		"ActivateJob",
		"DeactivateJob"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*AbortComputation*)


DefineUsage[AbortComputation,{
	BasicDefinitions->{
		{"AbortComputation[computations]","abortedComputations","sets the Status of one or more 'computations' to Aborting, which will stop the computation(s) immediately by terminating the currently evaluating cell."}
	},
	Input:>{
		{"computations",ListableP[ObjectP[Object[Notebook,Computation]]],"One or more Manifold Computation objects."}
	},
	Output:>{
		{"abortedComputations",ListableP[ObjectP[Object[Notebook,Computation]]],"Object[Notebook,Computations] objects which have been aborted."}
	},
	MoreInformation->{
		"Computations can only be aborted if they have a current status of Queued, Ready, Staged, or Running.",
		"Queued, Ready, and Staged jobs will be Aborted immediately.",
		"Running jobs will be aborted immediately by terminating the currently evaluating cell. It may take up to an additional two minutes for the Manifold server to shut down this computation."
	},
	SeeAlso->{
		"Compute",
		"StopComputation",
		"ActivateJob",
		"DeactivateJob"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*AvailableComputationThreads*)


DefineUsage[AvailableComputationThreads,{
	BasicDefinitions->{
		{"AvailableComputationThreads[teams]", "computationThreads", "returns the number of unused computation threads for 'teams' to indicate how many simulataneous computations that 'teams' may run at their current subscription level. The number of computation threads available is the team's MaxComputationalThreads minus the number of RunningComputations."},
		{"AvailableComputationThreads[user]", "computationThreads", "returns the number of unused computation threads for each of the financing teams of which 'user' is a member."},
		{"AvailableComputationThreads[]", "computationThreads", "returns the number of unused computation threads for each of the financing teams of which the currently logged in user is a member."}
	},
	Input:>{
		{"teams", ListableP[ObjectP[Object[Team, Financing]]]|{}, "The team(s) for which to calculate available computation threads."},
		{"user", ObjectP[Object[User]], "The user for which to calculate available computation threads."}
	},
	Output:>{
		{"computationThreads", ListableP[_Integer]|{}, "The available computation threads for each input team or input user's team(s)."}
	},
	SeeAlso->{
		"Compute"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*PlotComputationQueue*)


DefineUsage[PlotComputationQueue,{
	BasicDefinitions->{
		{"PlotComputationQueue[team]", "computationThreads", "is a private helper function intended to give developers a quick view of the computation queue of a financing team."}
	},
	Input:>{
		{"team", ObjectP[Object[Team, Financing]]|{}, "The team for which to display computation queue."},
		{"", ObjectP[Object[User]], "If no team is provided, the user's first team is used."}
	},
	Output:>{
		{"computationThreads", Grid[_,_]|{}, "Threads use, running computations, and queued computations."}
	},
	SeeAlso->{
		"Compute",
		"AvailableComputationThreads",
		"DebugManifoldJob"
	},
	Author->{"platform"}
}];