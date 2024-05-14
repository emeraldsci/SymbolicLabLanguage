(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Manifold Job Functions*)


(* ::Subsubsection::Closed:: *)
(*ActivateJob*)


DefineUsage[ActivateJob,{
	BasicDefinitions->{
		{"ActivateJob[jobs]","activatedJobs","sets the Status of one or more 'jobs' to Active, and returns a list of the successfully modified 'activatedJobs'."}
	},
	Input:>{
		{"jobs",ListableP[ObjectP[Object[Notebook,Job]]],"One or more Manifold Jobs."}
	},
	Output:>{
		{"activatedJobs",ListableP[ObjectP[Object[Notebook,Job]]],"Job notebooks which have been activated."}
	},
	SeeAlso->{
		"Compute",
		"AbortJob",
		"DeactivateJob",
		"StopComputation",
		"AbortComputation"
	},
	Author->{"platform"}
}];


(* ::Subsubsection::Closed:: *)
(*DeactivateJob*)


DefineUsage[DeactivateJob,{
	BasicDefinitions->{
		{"DeactivateJob[jobs]","deactivatedJobs","sets the Status of one or more 'jobs' to Inactive, and returns a list of the successfully modified 'deactivatedJobs'."}
	},
	Input:>{
		{"jobs",ListableP[ObjectP[Object[Notebook,Job]]],"One or more Manifold Jobs."}
	},
	Output:>{
		{"deactivatedJobs",ListableP[ObjectP[Object[Notebook,Job]]],"Job notebooks which were successfully deactivated."}
	},
	SeeAlso->{
		"Compute",
		"AbortJob",
		"ActivateJob",
		"StopComputation",
		"AbortComputation"
	},
	Author->{"platform"}
}];

(* ::Subsubsection::Closed:: *)
(*AbortJob*)


DefineUsage[AbortJob,{
	BasicDefinitions->{
		{"AbortJob[jobs]","abortedJobs","sets the Status of one or more 'jobs' to Aborted, which will deactivate the job(s) and abort any of the job's computations that are currently running or staging."}
	},
	Input:>{
		{"jobs",ListableP[ObjectP[Object[Notebook,Job]]],"One or more Manifold job objects."}
	},
	Output:>{
		{"abortedJobs",ListableP[ObjectP[Object[Notebook,Job]]],"Object[Notebook,Job] objects which have been aborted."}
	},
	MoreInformation->{
		"Aborting a job will ensure that no future computations can be spawned from the job until the job is reactivated via ActivateJob.",
		"The job's running computations will be aborted immediately by terminating the currently evaluating cell. It may take up to an additional two minutes for the Manifold server to shut down these computation."
	},
	SeeAlso->{
		"Compute",
		"StopComputation",
		"ActivateJob",
		"DeactivateJob"
	},
	Author->{"platform"}
}];