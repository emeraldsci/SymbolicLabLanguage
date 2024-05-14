(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*StopComputation*)


DefineTests[StopComputation,
	{
		Example[{Basic,"Stop a Manifold computation by changing its status to Stopping. Stopping a computation will terminate it from the Manifold server after the currently evaluating cell has finished:"},
			StopComputation[Object[Notebook,Computation,"Running Computation 1 for SC"]],
			ObjectP[Object[Notebook,Computation]]
		],
		Example[{Basic,"Stop multiple Manifold computations by changing their Status fields to Stopping, and return all stopped computations:"},
			StopComputation[{
				Object[Notebook,Computation,"Running Computation 2 for SC"],
				Object[Notebook,Computation,"Running Computation 3 for SC"],
				Object[Notebook,Computation,"Running Computation 4 for SC"]
			}],
			{ObjectP[Object[Notebook,Computation]]..}
		],
		Example[{Basic,"Computations can only be Stopped if their current status is Running, Queued, Staged, or Ready:"},
			StopComputation[{
				Object[Notebook,Computation,"TimedOut Computation 2 for SC"],
				Object[Notebook,Computation,"Running Computation 5 for SC"]
			}],
			{$Failed,ObjectP[Object[Notebook,Computation]]},
			Messages:>{Warning::ComputationNotStopped}
		],
		Test["StopComputation outputs and sets status correctly for all initial statuses:",
			With[
				{
					testObjs={
						Object[Notebook,Computation,"Completed Computation for SC"],
						Object[Notebook,Computation,"Stopping Computation for SC"],
						Object[Notebook,Computation,"Queued Computation for SC"],
						Object[Notebook,Computation,"Staged Computation for SC"],
						Object[Notebook,Computation,"Stopped Computation for SC"],
						Object[Notebook,Computation,"Aborting Computation for SC"],
						Object[Notebook,Computation,"Ready Computation for SC"],
						Object[Notebook,Computation,"Running Computation for SC"],
						Object[Notebook,Computation,"Aborted Computation for SC"],
						Object[Notebook,Computation,"TimedOut Computation for SC"],
						Object[Notebook,Computation,"Error Computation for SC"]
					}
				},
				{StopComputation[testObjs],Download[testObjs,Status]}
			],
			{
				{
					$Failed,
					$Failed,
					ObjectP[Object[Notebook,Computation]],
					ObjectP[Object[Notebook,Computation]],
					$Failed,
					$Failed,
					ObjectP[Object[Notebook,Computation]],
					ObjectP[Object[Notebook,Computation]],
					$Failed,
					$Failed,
					$Failed
				},
				{
					Completed,
					Stopping,
					Stopped,
					Stopping,
					Stopped,
					Aborting,
					Stopping,
					Stopping,
					Aborted,
					TimedOut,
					Error
				}
			},
			Messages:>{Warning::ComputationNotStopped}
		],
		Example[{Messages,"ComputationNotFound","Warning is shown if one or more input objects cannot be found in the database. This can occur if the object does not exist, or if you do not have permissions to view/modify the input object:"},
			StopComputation[{Object[Notebook,Computation,"Running Computation 6 for SC"],Object[Notebook,Computation,"This computation does not exist"]}],
			{ObjectP[Object[Notebook,Computation]],$Failed},
			Messages:>{Warning::ComputationNotFound}
		],
		Example[{Messages,"ComputationNotStopped","Warning is shown if one or more computations has a status which cannot be Stopped. Only Running, Queued, Staged, and Ready computations can be stopped:"},
			StopComputation[{Object[Notebook,Computation,"TimedOut Computation 2 for SC"],Object[Notebook,Computation,"Running Computation 7 for SC"]}],
			{$Failed,ObjectP[Object[Notebook,Computation]]},
			Messages:>{Warning::ComputationNotStopped}
		]
	},

	(* Create Test Objects *)
	SymbolSetUp:>Module[{allTestObjects,existingObjects},
		(* Initiate object tracking *)
		$CreatedObjects={};

		(* All named objects used by these unit tests *)
		allTestObjects={
			Object[Notebook,Computation,"Running Computation 1 for SC"],
			Object[Notebook,Computation,"Running Computation 2 for SC"],
			Object[Notebook,Computation,"Running Computation 3 for SC"],
			Object[Notebook,Computation,"Running Computation 4 for SC"],
			Object[Notebook,Computation,"Running Computation 5 for SC"],
			Object[Notebook,Computation,"Running Computation 6 for SC"],
			Object[Notebook,Computation,"Running Computation 7 for SC"],
			Object[Notebook,Computation,"TimedOut Computation 1 for SC"],
			Object[Notebook,Computation,"TimedOut Computation 2 for SC"],
			Object[Notebook,Computation,"Queued Computation for SC"],
			Object[Notebook,Computation,"Staged Computation for SC"],
			Object[Notebook,Computation,"Ready Computation for SC"],
			Object[Notebook,Computation,"Running Computation for SC"],
			Object[Notebook,Computation,"Completed Computation for SC"],
			Object[Notebook,Computation,"Stopping Computation for SC"],
			Object[Notebook,Computation,"Stopped Computation for SC"],
			Object[Notebook,Computation,"Aborting Computation for SC"],
			Object[Notebook,Computation,"Aborted Computation for SC"],
			Object[Notebook,Computation,"TimedOut Computation for SC"],
			Object[Notebook,Computation,"Error Computation for SC"]
		};

		(* Grab any test objects which are already in database *)
		existingObjects=PickList[allTestObjects,DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(* Upload test objects *)
		Upload[{
			<|Type->Object[Notebook,Computation], Name->"Running Computation 1 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 2 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 3 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 4 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 5 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 6 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 7 for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation 1 for SC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation 2 for SC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Queued Computation for SC", Status->Queued, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Ready Computation for SC", Status->Ready, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Staged Computation for SC", Status->Staged, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation for SC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Completed Computation for SC", Status->Completed, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Stopping Computation for SC", Status->Stopping, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Stopped Computation for SC", Status->Stopped, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Aborting Computation for SC", Status->Aborting, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Aborted Computation for SC", Status->Aborted, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation for SC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Error Computation for SC", Status->Error, DeveloperObject->True|>
		}];
	],

	(* Erase all test objects created during these unit tests *)
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(*AbortComputation*)


DefineTests[AbortComputation,
	{
		Example[{Basic,"Abort a Manifold computation by changing its status to Aborting. Unlike StopComputation, AbortComputation will terminate a Manifold computation immediately, without allowing the currently evaluating cell to finish:"},
			AbortComputation[Object[Notebook,Computation,"Running Computation 1 for AC"]],
			ObjectP[Object[Notebook,Computation]]
		],
		Example[{Basic,"Abort multiple Manifold computations by changing their Status fields to Aborting, and return all aborted computations:"},
			AbortComputation[{
				Object[Notebook,Computation,"Running Computation 2 for AC"],
				Object[Notebook,Computation,"Running Computation 3 for AC"],
				Object[Notebook,Computation,"Running Computation 4 for AC"]
			}],
			{ObjectP[Object[Notebook,Computation]]..}
		],
		Example[{Basic,"Computations can only be Aborted if their current status is Running, Queued, Staged, or Ready:"},
			AbortComputation[{
				Object[Notebook,Computation,"TimedOut Computation 2 for AC"],
				Object[Notebook,Computation,"Running Computation 5 for AC"]
			}],
			{$Failed,ObjectP[Object[Notebook,Computation]]},
			Messages:>{Warning::ComputationNotAborted}
		],
		Test["AbortComputation outputs and sets status correctly for all initial statuses:",
			With[
				{
					testObjs={
						Object[Notebook,Computation,"Completed Computation for AC"],
						Object[Notebook,Computation,"Stopping Computation for AC"],
						Object[Notebook,Computation,"Queued Computation for AC"],
						Object[Notebook,Computation,"Staged Computation for AC"],
						Object[Notebook,Computation,"Stopped Computation for AC"],
						Object[Notebook,Computation,"Aborting Computation for AC"],
						Object[Notebook,Computation,"Ready Computation for AC"],
						Object[Notebook,Computation,"Running Computation for AC"],
						Object[Notebook,Computation,"Aborted Computation for AC"],
						Object[Notebook,Computation,"TimedOut Computation for AC"],
						Object[Notebook,Computation,"Error Computation for AC"]
					}
				},
				{AbortComputation[testObjs],Download[testObjs,Status]}
			],
			{
				{
					$Failed,
					$Failed,
					ObjectP[Object[Notebook,Computation]],
					ObjectP[Object[Notebook,Computation]],
					$Failed,
					$Failed,
					ObjectP[Object[Notebook,Computation]],
					ObjectP[Object[Notebook,Computation]],
					$Failed,
					$Failed,
					$Failed
				},
				{
					Completed,
					Stopping,
					Aborted,
					Aborting,
					Stopped,
					Aborting,
					Aborting,
					Aborting,
					Aborted,
					TimedOut,
					Error
				}
			},
			Messages:>{Warning::ComputationNotAborted}
		],
		Example[{Messages,"ComputationNotFound","Warning is shown if one or more input objects cannot be found in the database. This can occur if the object does not exist, or if you do not have permissions to view/modify the input object:"},
			AbortComputation[{Object[Notebook,Computation,"Running Computation 6 for AC"],Object[Notebook,Computation,"This computation does not exist"]}],
			{ObjectP[Object[Notebook,Computation]],$Failed},
			Messages:>{Warning::ComputationNotFound}
		],
		Example[{Messages,"ComputationNotAborted","Warning is shown if one or more computations has a status which cannot be aborted. Only Running, Queued, Staged, and Ready computations can be aborted:"},
			AbortComputation[{Object[Notebook,Computation,"TimedOut Computation 2 for AC"],Object[Notebook,Computation,"Running Computation 7 for AC"]}],
			{$Failed,ObjectP[Object[Notebook,Computation]]},
			Messages:>{Warning::ComputationNotAborted}
		]
	},

	(* Create Test Objects *)
	SymbolSetUp:>Module[{allTestObjects,existingObjects},
		(* Initiate object tracking *)
		$CreatedObjects={};

		(* All named objects used by these unit tests *)
		allTestObjects={
			Object[Notebook,Computation,"Running Computation 1 for AC"],
			Object[Notebook,Computation,"Running Computation 2 for AC"],
			Object[Notebook,Computation,"Running Computation 3 for AC"],
			Object[Notebook,Computation,"Running Computation 4 for AC"],
			Object[Notebook,Computation,"Running Computation 5 for AC"],
			Object[Notebook,Computation,"Running Computation 6 for AC"],
			Object[Notebook,Computation,"Running Computation 7 for AC"],
			Object[Notebook,Computation,"TimedOut Computation 1 for AC"],
			Object[Notebook,Computation,"TimedOut Computation 2 for AC"],
			Object[Notebook,Computation,"Queued Computation for AC"],
			Object[Notebook,Computation,"Staged Computation for AC"],
			Object[Notebook,Computation,"Ready Computation for AC"],
			Object[Notebook,Computation,"Running Computation for AC"],
			Object[Notebook,Computation,"Completed Computation for AC"],
			Object[Notebook,Computation,"Stopping Computation for AC"],
			Object[Notebook,Computation,"Stopped Computation for AC"],
			Object[Notebook,Computation,"Aborting Computation for AC"],
			Object[Notebook,Computation,"Aborted Computation for AC"],
			Object[Notebook,Computation,"TimedOut Computation for AC"],
			Object[Notebook,Computation,"Error Computation for AC"]
		};

		(* Grab any test objects which are already in database *)
		existingObjects=PickList[allTestObjects,DatabaseMemberQ[allTestObjects]];

		(* Erase any objects which we failed to erase from the last unit test *)
		Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

		(* Upload test objects *)
		Upload[{
			<|Type->Object[Notebook,Computation], Name->"Running Computation 1 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 2 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 3 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 4 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 5 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 6 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation 7 for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation 1 for AC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation 2 for AC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Queued Computation for AC", Status->Queued, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Ready Computation for AC", Status->Ready, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Staged Computation for AC", Status->Staged, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Running Computation for AC", Status->Running, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Completed Computation for AC", Status->Completed, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Stopping Computation for AC", Status->Stopping, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Stopped Computation for AC", Status->Stopped, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Aborting Computation for AC", Status->Aborting, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Aborted Computation for AC", Status->Aborted, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"TimedOut Computation for AC", Status->TimedOut, DeveloperObject->True|>,
			<|Type->Object[Notebook,Computation], Name->"Error Computation for AC", Status->Error, DeveloperObject->True|>
		}];
	],

	(* Erase all test objects created during these unit tests *)
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
];


(* ::Subsection::Closed:: *)
(*AvailableComputationThreads*)


DefineTests[AvailableComputationThreads,
	{
		Example[{Basic, "Return the available computational threads for a financing team the currently logged in user is a member of:"},
			AvailableComputationThreads[],
			{_Integer..}
		],
		Example[{Basic, "Return the available computation threads for a specific financing team:"},
			AvailableComputationThreads[Object[Team, Financing, "Emerald Therapeutics"]],
			_Integer
		],
		Example[{Basic, "Return the available computation threads for a list of financing teams:"},
			AvailableComputationThreads[{Object[Team, Financing, "Emerald Therapeutics"], Object[Team, Financing, "Development"]}],
			{_Integer..}
		],
		Example[{Basic, "Return the available computation threads for each team for each of a list of users:"},
			AvailableComputationThreads[{$PersonID, $PersonID}],
			{{_Integer..}, {_Integer..}}
		]
	}
];


(* ::Subsection::Closed:: *)
(*PlotComputationQueue*)


DefineTests[PlotComputationQueue,
	{
		Example[{Basic, "Display the computation queue of a given financing team:"},
			PlotComputationQueue[Object[Team, Financing, "Emerald Therapeutics"]],
			Grid[{_,_,_,_}]
		],
		Example[{Basic, "If no team is provided, use the user's first team:"},
			PlotComputationQueue[],
			Grid[{_,_,_,_}]
		],
		Example[{Basic, "Display the current computation queue of an entire financing team currently logged in:"},
			PlotComputationQueue[Object[Team, Financing, "Development"]],
			Grid[{_,_,_,_}]
		],
        Example[{Basic, "Display the current computation queues for a list of financing teams:"},
            PlotComputationQueue[{Object[Team, Financing, "Development"],Object[Team, Financing, "Emerald Therapeutics"]}],
            _Column
        ]
    }
];
