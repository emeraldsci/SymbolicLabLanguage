(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Messages*)


Warning::ComputationNotFound="The computation(s) `1` could not be found in Constellation. Please ensure these objects exist, and that you have permissions to access them.";
Warning::ComputationNotAborted="The computation(s) `1` have status `2` and could not be aborted. Computations must have a status of Queued, Ready, Staged, WaitingForDistro, or Running to be Stopped.";
Warning::ComputationNotStopped="The computation(s) `1` have status `2` and could not be stopped. Computations must have a status of Queued, Ready, Staged, WaitingForDistro, or Running to be Stopped.";
Warning::JobNotFound="The job(s), `1`, could not be found in Constellation. Please ensure these objects exist, and that you have permissions to access them.";
Warning::JobNotAborted="The job(s) `1` have status `2` and could not be aborted. Jobs must have a status of Inactive or Active to be aborted.";

(* ::Subsection:: *)
(*StopComputation*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[StopComputation,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function is listable *)
StopComputation[
	comps:ListableP[ObjectP[Object[Notebook,Computation]]],
	ops:OptionsPattern[StopComputation]
]:=Module[
	{
		listedComps,listedOps,compsInDatabase,compsNotInDatabase,validComps,
		compStatus,invalidStatuses,missingComputationRules,invalidComputationRules,
		updatePackets,updates,updateRules
	},

	(* Convert inputs and options to lists if they are not already *)
	listedComps=ToList[comps];
	listedOps=ToList[ops];

	(* Extract comps from the database *)
	compsInDatabase=PickList[listedComps,DatabaseMemberQ[listedComps]];
	compsNotInDatabase=Complement[listedComps,compsInDatabase];

	(* Warn user if any of the comps could not be found *)
	If[Length[compsNotInDatabase]>0,
		Message[Warning::ComputationNotFound,compsNotInDatabase]
	];

	(* Get the status of all computations in the database *)
	compStatus=Download[compsInDatabase,Status];

	(* Select any computations with a status which cannot be stopped *)
	invalidStatuses=PickList[
		compsInDatabase,
		MatchQ[#,Completed|Stopping|Stopped|Aborting|Aborted|TimedOut|Error|Null]&/@compStatus
	];

	(* Warn user if any of the comps could not be updated *)
	If[Length[invalidStatuses]>0,
		Message[Warning::ComputationNotStopped,invalidStatuses,Download[invalidStatuses,Status]];
	];

	(* Create rules for the missing comps to massage the output *)
	missingComputationRules=Rule[#,$Failed]&/@compsNotInDatabase;
	invalidComputationRules=Rule[#,$Failed]&/@invalidStatuses;

	(* Remove invalid computations from the database list *)
	validComps=compsInDatabase/.(Rule[#,Nothing]&/@invalidStatuses);

	(* Create a list of status updates *)
	updatePackets=MapThread[
		Switch[#2,
			Queued,<|Object->#1,Status->Stopped,ComputationFinancingTeam->Null|>,
			Ready|Staged|Running|WaitingForDistro,<|Object->#1,Status->Stopping|>,
			_,Nothing
		]&,
		{Download[compsInDatabase,Object],compStatus}
	];

	(* Upload the updates *)
	updates=Upload[updatePackets];

	(* Replacement rules for updated comps for massaging the output *)
	updateRules=MapThread[#1->#2&,{validComps,updates}];

	(* Return a list of updated comps *)
	comps/.Join[missingComputationRules,invalidComputationRules,updateRules]
];



(* ::Subsection:: *)
(*AbortComputation*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[AbortComputation,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)

(* Main function is listable *)
AbortComputation[
	comps:ListableP[ObjectP[Object[Notebook,Computation]]],
	ops:OptionsPattern[StopComputation]
]:=Module[
	{
		listedComps,listedOps,compsInDatabase,compsNotInDatabase,validComps,
		compStatus,invalidStatuses,missingComputationRules,invalidComputationRules,
		updatePackets,updates,updateRules
	},

	(* Convert inputs and options to lists if they are not already *)
	listedComps=ToList[comps];
	listedOps=ToList[ops];

	(* Extract comps from the database *)
	compsInDatabase=PickList[listedComps,DatabaseMemberQ[listedComps]];
	compsNotInDatabase=Complement[listedComps,compsInDatabase];

	(* Warn user if any of the comps could not be found *)
	If[Length[compsNotInDatabase]>0,
		Message[Warning::ComputationNotFound,compsNotInDatabase]
	];

	(* Get the status of all computations in the database *)
	compStatus=Download[compsInDatabase,Status];

	(* Select any computations with a status which cannot be stopped *)
	invalidStatuses=PickList[
		compsInDatabase,
		MatchQ[#,Completed|Stopping|Stopped|Aborting|Aborted|TimedOut|Error|Null]&/@compStatus
	];

	(* Warn user if any of the comps could not be updated *)
	If[Length[invalidStatuses]>0,
		Message[Warning::ComputationNotAborted,invalidStatuses,Download[invalidStatuses,Status]];
	];

	(* Create rules for the missing comps to massage the output *)
	missingComputationRules=Rule[#,$Failed]&/@compsNotInDatabase;
	invalidComputationRules=Rule[#,$Failed]&/@invalidStatuses;

	(* Remove invalid computations from the database list *)
	validComps=compsInDatabase/.(Rule[#,Nothing]&/@invalidStatuses);

	(* Create a list of status updates *)
	updatePackets=MapThread[
		Switch[#2,
			Queued,<|Object->#1,Status->Aborted,ComputationFinancingTeam->Null|>,
			Ready|Staged|Running|WaitingForDistro,<|Object->#1,Status->Aborting|>,
			_,Nothing
		]&,
		{Download[compsInDatabase,Object],compStatus}
	];

	(* Upload the updates *)
	updates=Upload[updatePackets];

	(* Replacement rules for updated comps for massaging the output *)
	updateRules=MapThread[#1->#2&,{validComps,updates}];

	(* Return a list of updated comps *)
	comps/.Join[missingComputationRules,invalidComputationRules,updateRules]
];



(* ::Subsection:: *)
(*AvailableComputationThreads*)


(* ::Subsubsection:: *)
(*DefineOptions*)

DefineOptions[AvailableComputationThreads,
	Options:>{}
];


(* ::Subsubsection:: *)
(*Implementation*)


(* User overloads pass to primary team overload *)
AvailableComputationThreads[]:=AvailableComputationThreads[$PersonID];
AvailableComputationThreads[{}]:={0};
AvailableComputationThreads[users:ListableP[ObjectP[Object[User]]]]:=Module[
	{teamsPerUser,threadsPerUser},

	(* A list of financing teams for each provided user *)
	teamsPerUser=Download[ToList[users], FinancingTeams];

	(* For each list of teams per user, the number of available threads *)
	threadsPerUser=AvailableComputationThreads/@teamsPerUser;

	(* Delist the output if needed *)
	If[MatchQ[users,_List],
		threadsPerUser,
		First[threadsPerUser]
	]
];

(* Primary overload is listable on teams *)
AvailableComputationThreads[teams:ListableP[ObjectP[Object[Team,Financing]]]]:=Module[
	{listedTeams, maxThreadsCurrentCompsPerTeam, threadsPerTeam},

	(* Ensure the input is listed *)
	listedTeams=ToList[teams];

	(* For each financing team, get the max computational threads and running computation list *)
	maxThreadsCurrentCompsPerTeam=Quiet[
		Download[listedTeams, {MaxComputationThreads, RunningComputations}],
		{Download::FieldDoesntExist}
	]/.{Null|{}->0};

	(* Available threads = max threads - # of running computations *)
	threadsPerTeam=Map[
		(First[#]/.{Null->0}) - Length[Last[#]/.{$Failed->{}}]&,
		maxThreadsCurrentCompsPerTeam
	];

	(* Delist the output if needed *)
	If[MatchQ[teams,_List],
		threadsPerTeam,
		First[threadsPerTeam]
	]
];


(* PlotComputationQueue *)

(* If no team is provided, use the users first team *)
PlotComputationQueue[]:=PlotComputationQueue[FirstOrDefault[$PersonID[FinancingTeams]]];

(* Combine results for multiple teams *)
PlotComputationQueue[teams_List]:=Column[Map[PlotComputationQueue][teams]];


(* This is a private helper function intended to give developers a quick view of the computation queue of a financing team *)
PlotComputationQueue[team : ObjectP[Object[Team, Financing]]] := Module[
	{
		maxThreads, queuedIDs, queuedOwners, runningIDs, runningOwners, runningStatuses,
		usageGraphic, runningGraphic, queueGraphic, queuedRunAsUsers, runningRunAsUsers, threadsInUse,
		queuedOwnersWithRunAsUser, runningOwnersWithRunAsUser, queuedUnitTests, runningUnitTests,
		queuedUnitTestFunctions, runningUnitTestFunctions, queuedParallelParentUnitTests,
		queuedParallelParentUnitTestFunctions, runningParallelParentUnitTests,
		runningParallelParentUnitTestFunctions, actualRunningUnitTests, actualRunningUnitTestFunctions,
		actualQueuedUnitTests, actualQueuedUnitTestFunctions
	},

	(* Download computational queue info from the financing team object *)
	{
		maxThreads,
		queuedIDs,
		queuedOwners,
		queuedRunAsUsers,
		queuedUnitTests,
		queuedUnitTestFunctions,
		queuedParallelParentUnitTests,
		queuedParallelParentUnitTestFunctions,
		runningIDs,
		runningStatuses,
		runningOwners,
		runningRunAsUsers,
		runningUnitTests,
		runningUnitTestFunctions,
		runningParallelParentUnitTests,
		runningParallelParentUnitTestFunctions
	} = Download[team,
		{
			MaxComputationThreads,
			ComputationQueue,
			ComputationQueue[Job][CreatedBy][Name],
			ComputationQueue[Job][RunAsUser][Name],
			ComputationQueue[Job][UnitTest],
			ComputationQueue[Job][UnitTest][Function],
			ComputationQueue[Job][ParallelParentUnitTest],
			ComputationQueue[Job][ParallelParentUnitTest][Function],
			RunningComputations,
			RunningComputations[Status],
			RunningComputations[Job][CreatedBy][Name],
			RunningComputations[Job][RunAsUser][Name],
			RunningComputations[Job][UnitTest],
			RunningComputations[Job][UnitTest][Function],
			RunningComputations[Job][ParallelParentUnitTest],
			RunningComputations[Job][ParallelParentUnitTest][Function]
		}
	];

	(* Handle empty queue *)
	If[MatchQ[queuedIDs, {} | Null],
		queuedIDs = {" - "};
		queuedOwners = {" - "};
	];

	(* get all the queued/running owners, but RunAsUser supersedes the CreatedBy (because if you RunAsUser and have a suite of tests, the CreatedBy will just alwasy be unit-testing+launching-jobs which is not informative) *)
	queuedOwnersWithRunAsUser = If[MatchQ[queuedOwners, {" - "}],
		queuedOwners,
		MapThread[
			If[MatchQ[#1, "unit-testing+launching-jobs"] && Not[NullQ[#2]],
				#2,
				#1
			]&,
			{queuedOwners, queuedRunAsUsers}
		]
	];
	runningOwnersWithRunAsUser = MapThread[
		If[MatchQ[#1, "unit-testing+launching-jobs"] && Not[NullQ[#2]],
			#2,
			#1
		]&,
		{runningOwners, runningRunAsUsers}
	];


	(* Get the number of threads in use *)
	threadsInUse = Length[runningIDs];

	(* A graphic showing current thread usage *)
	usageGraphic = If[maxThreads == 0,
		Column[{
			Style["Your Financing Team has no computational threads. ", 15],
			Style["Please purchase or request computational threads.", 15]
		}],
		Grid[
			{
				{Style["Threads Used", 15]},
				{Style[ToString[threadsInUse] <> "/" <> ToString[maxThreads], 36]}
			},
			Spacings -> {Automatic, 1},
			Alignment -> Center
		]
	];

	(* get the actual running unit test and function because it could be Parallel or not *)
	actualRunningUnitTests = MapThread[
		If[NullQ[#1],
			#2,
			#1
		]&,
		{runningUnitTests, runningParallelParentUnitTests}
	];
	actualRunningUnitTestFunctions = MapThread[
		If[NullQ[#1] && Not[NullQ[#2]],
			ToString[#2] <> " (parallel)",
			#1
		]&,
		{runningUnitTestFunctions, runningParallelParentUnitTestFunctions}
	];

	(* get the actual queued unit test and function because it could be Parallel or not *)
	actualQueuedUnitTests = MapThread[
		If[NullQ[#1],
			#2,
			#1
		]&,
		{queuedUnitTests, queuedParallelParentUnitTests}
	];
	actualQueuedUnitTestFunctions = MapThread[
		If[NullQ[#1] && Not[NullQ[#2]],
			ToString[#2] <> " (parallel)",
			#1
		]&,
		{queuedUnitTestFunctions, queuedParallelParentUnitTestFunctions}
	];


	(* Create tables for running computations and the queue *)
	runningGraphic = If[maxThreads == 0,
		"",
		PlotTable[
			Transpose@{
				PadRight[runningOwnersWithRunAsUser, Max[Length[runningIDs], Min[maxThreads, 10]], " - "],
				PadRight[runningStatuses, Max[Length[runningIDs], Min[maxThreads, 10]], " - "],
				PadRight[actualRunningUnitTestFunctions /. {Null -> ""}, Max[Length[runningIDs], Min[maxThreads, 10]], " - "],
				PadRight[runningIDs, Max[Length[runningIDs], Min[maxThreads, 10]], " - "],
				PadRight[actualRunningUnitTests /. {Null -> ""}, Max[Length[runningIDs], Min[maxThreads, 10]], " - "]
			},
			ShowNamedObjects -> False,
			TableHeadings -> {None, {"Submitter", "Status", "Function", "Computation", "Unit Test"}},
			Title -> "RunningComputations"
		]
	];
	queueGraphic = PlotTable[
		Transpose@{
			Range[Length[queuedIDs]],
			queuedOwnersWithRunAsUser,
			actualQueuedUnitTestFunctions /. {Null -> "", {} -> {" - "}},
			queuedIDs,
			actualQueuedUnitTests /. {Null -> "", {} -> {" - "}}
		},
		ShowNamedObjects -> False,
		TableHeadings -> {None, {"Position", "Submitter", "Function", "Computation", "Unit Test"}},
		Title -> "ComputationQueue"
	];

	(* Combine the graphics *)
	Grid[
		{
			{Style["Object[Team, Financing, \"" <> team[Name] <> "\"]", 18, FontFamily -> Arial]},
			{usageGraphic},
			{runningGraphic},
			{queueGraphic}
		}
	]
];
