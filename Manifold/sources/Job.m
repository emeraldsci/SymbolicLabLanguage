(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Messages*)


Warning::JobNotFound="The job(s) `1` could not be found in Constellation. Please ensure these objects exist, and that you have permissions to access them.";
Warning::NoStatusChange="The job(s) `1` already had Status `2`, and their status has not been changed.";

(* ::Subsection:: *)
(*ActivateJob*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[ActivateJob,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function is listable *)
ActivateJob[
	jobs:ListableP[ObjectP[Object[Notebook,Job]]],
	ops:OptionsPattern[ActivateJob]
]:=Module[
	{
		listedJobs,listedOps,groupedJobs,jobsInDatabase,jobsNotInDatabase,
		missingJobRules,updatePackets,updates,updateRules,currentJobStatus,alreadyActiveJobs
	},

	(* Convert inputs and options to lists if they are not already *)
	listedJobs=ToList[jobs];
	listedOps=ToList[ops];

	(* Group jobs by whether they are in the database *)
	groupedJobs=GroupBy[listedJobs,DatabaseMemberQ];

	(* Extract jobs from the database *)
	jobsInDatabase=Lookup[groupedJobs,True,{}];
	jobsNotInDatabase=Complement[listedJobs,jobsInDatabase];

	(* Warn user if any of the jobs could not be found *)
	If[Length[jobsNotInDatabase]>0,
		Message[Warning::JobNotFound,jobsNotInDatabase]
	];

	(* Get a list of jobs which were already active *)
	currentJobStatus = Download[jobsInDatabase, {Object,Status}];
	alreadyActiveJobs = FirstOrDefault/@Select[currentJobStatus, (Last[#]==Active)&];

	(* Warn user if any jobs requested for activation were already active*)
	If[Length[alreadyActiveJobs] > 0,
		Message[Warning::NoStatusChange,alreadyActiveJobs,Active]
	];

	(* Create rules for the missing jobs to massage the output *)
	missingJobRules=Rule[#,$Failed]&/@jobsNotInDatabase;

	(* Create a list of status updates *)
	updatePackets=Map[
		<|
			Object->#,
			Status->Active
		|>&,
		jobsInDatabase
	];

	(* Upload the updates *)
	updates=Upload[updatePackets];

	(* Replacement rules for updated jobs for massaging the output *)
	updateRules=MapThread[#1->#2&,{jobsInDatabase,updates}];

	(* Return a list of updated jobs *)
	jobs/.Join[missingJobRules,updateRules]
];



(* ::Subsection:: *)
(*DeactivateJob*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[DeactivateJob,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function is listable *)
DeactivateJob[
	jobs:ListableP[ObjectP[Object[Notebook,Job]]],
	ops:OptionsPattern[ActivateJob]
]:=Module[
	{
		listedJobs,listedOps,groupedJobs,jobsInDatabase,jobsNotInDatabase,
		missingJobRules,updatePackets,updates,updateRules,currentJobStatus,alreadyInactiveJobs
	},

	(* Convert inputs and options to lists if they are not already *)
	listedJobs=ToList[jobs];
	listedOps=ToList[ops];

	(* Group jobs by whether they are in the database *)
	groupedJobs=GroupBy[listedJobs,DatabaseMemberQ];

	(* Extract jobs from the database *)
	jobsInDatabase=Lookup[groupedJobs,True,{}];
	jobsNotInDatabase=Complement[listedJobs,jobsInDatabase];

	(* Warn user if any of the jobs could not be found *)
	If[Length[jobsNotInDatabase]>0,
		Message[Warning::JobNotFound,jobsNotInDatabase]
	];

	(* Get a list of jobs which were already inactive *)
	currentJobStatus = Download[jobsInDatabase, {Object,Status}];
	alreadyInactiveJobs = FirstOrDefault/@Select[currentJobStatus, (Last[#]==Inactive)&];

	(* Warn user if any jobs requested for deactivation were already inactive*)
	If[Length[alreadyInactiveJobs] > 0,
		Message[Warning::NoStatusChange,alreadyInactiveJobs,Inactive]
	];

	(* Create rules for the missing jobs to massage the output *)
	missingJobRules=Rule[#,$Failed]&/@jobsNotInDatabase;

	(* Create a list of status updates *)
	updatePackets=Map[
		<|
			Object->#,
			Status->Inactive
		|>&,
		jobsInDatabase
	];

	(* Upload the updates *)
	updates=Upload[updatePackets];

	(* Replacement rules for updated jobs for massaging the output *)
	updateRules=MapThread[#1->#2&,{jobsInDatabase,updates}];

	(* Return a list of updated jobs *)
	jobs/.Join[missingJobRules,updateRules]
];


(* ::Subsection:: *)
(*AbortJob*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[AbortJob,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function is listable *)
AbortJob[
	jobs:ListableP[ObjectP[Object[Notebook,Job]]],
	ops:OptionsPattern[AbortJob]
]:=Module[
	{
		listedJobs,listedOps,jobsInDatabase,jobsNotInDatabase,
		jobStatus,jobComputations,allComputations,invalidStatuses,missingJobRules,invalidJobRules,
		updatePackets,updates
	},

	(* Convert inputs and options to lists if they are not already *)
	listedJobs=ToList[jobs];
	listedOps=ToList[ops];

	(* Extract comps from the database *)
	jobsInDatabase=PickList[listedJobs,DatabaseMemberQ[listedJobs]];
	jobsNotInDatabase=Complement[listedJobs,jobsInDatabase];

	(* Warn user if any of the jobs could not be found *)
	If[Length[jobsNotInDatabase]>0,
		Message[Warning::JobNotFound,jobsNotInDatabase]
	];

	(* Get the status of all jobs in the database *)
	{jobStatus, jobComputations}=If[Length[jobsInDatabase]>0,
		Transpose@Quiet[Download[jobsInDatabase,{Status, Computations}]],
		{{},{}}
	];
	allComputations=Cases[Flatten[jobComputations], ObjectP[Object[Notebook, Computation]]];

	(* Create a list of status updates *)
	updatePackets=MapThread[
		<|Object->#1,Status->Aborted,ComputationFinancingTeam->Null|>&,
		{Download[jobsInDatabase,Object],jobStatus}
	];

	(* Upload the updates *)
	updates=Upload[updatePackets];

	(* Abort any computations in our jobs. *)
	If[Length[allComputations]>0,
		Quiet[AbortComputation[allComputations]];
	];

	(* Select any jobs with a status which cannot be stopped *)
	invalidStatuses=PickList[
		jobsInDatabase,
		MatchQ[#,Aborted|Null]&/@jobStatus
	];

	(* Warn user if any of the jobs could not be updated *)
	If[Length[invalidStatuses]>0,
		Message[Warning::JobNotAborted,invalidStatuses,Download[invalidStatuses,Status]];
	];

	(* Create rules for the missing comps to massage the output *)
	missingJobRules=Rule[#,$Failed]&/@jobsNotInDatabase;
	invalidJobRules=Rule[#,$Failed]&/@invalidStatuses;

	(* Return a list of updated comps *)
	jobs/.Join[missingJobRules,invalidJobRules]
];
