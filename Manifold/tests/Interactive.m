(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*LaunchManifoldKernel*)


(* For these tests, we don't need manifold to run anything, we just need to verify that the Notebook, Job looks correct *)
DefineTests[LaunchManifoldKernel,
	{
		Example[{Basic, "Launching a single kernel returns a kernel with a correctly configured manifold job:"},
			Download[LaunchManifoldKernel[], ManifoldJob],
			{ObjectP[Object[Notebook, Job]]},
			TearDown :> AbortManifoldKernel[$ManifoldKernelPool]
		],
		Example[{Basic, "Launching multiple kernels returns multiple kernels with correctly configured manifold jobs:"},
			Download[LaunchManifoldKernel[2], ManifoldJob],
			{ObjectP[Object[Notebook, Job]], ObjectP[Object[Notebook, Job]]},
			TearDown :> AbortManifoldKernel[$ManifoldKernelPool]
		],
		Test["Can use the RunAsUser option to specify financing team:",
			Download[LaunchManifoldKernel[RunAsUser->$PersonID], ManifoldJob[RunAsUser][Object]],
			{$PersonID},
			TearDown :> AbortManifoldKernel[$ManifoldKernelPool]
		],
		Example[{Options, HardwareConfiguration, "Request the HighRAM (30GB) hardware configuration for memory intensive computations:"},
			Download[LaunchManifoldKernel[HardwareConfiguration -> HighRAM], ManifoldJob[HardwareConfiguration]],
			{HighRAM},
			TearDown :> AbortManifoldKernel[$ManifoldKernelPool]
		],
		Example[{Messages, "PublicKernelsNotAllowed", "A $Notebook is required to launch an interactive kernel:"},
			Block[{$Notebook = Null},
				LaunchManifoldKernel[]
			],
			$Failed,
			Messages :> {LaunchManifoldKernel::PublicKernelsNotAllowed}
		],
		Example[{Messages, "NotLoggedIn", "Must be logged in to launch an interactive kernel:"},
			LaunchManifoldKernel[],
			$Failed,
			Stubs :> {Constellation`Private`loggedInQ[] = False},
			Messages :> {LaunchManifoldKernel::NotLoggedIn}
		],
		Example[{Messages, "NoComputationThreads", "Must have computation threads to launch an interactive kernel:"},
			LaunchManifoldKernel[],
			$Failed,
			Stubs :> {Total[Download[$PersonID, FinancingTeams[MaxComputationThreads]]] = 0},
			Messages :> {LaunchManifoldKernel::NoComputationThreads}
		],
		Example[{Messages, "InsufficientComputationThreads", "Must have available computation threads to launch an interactive kernel:"},
			LaunchManifoldKernel[2],
			$Failed,
			Stubs :> {Total[Download[$PersonID, FinancingTeams[MaxComputationThreads]]] = 1},
			Messages :> {LaunchManifoldKernel::InsufficientComputationThreads}
		]
	},
	SymbolSetUp :> {$CreatedObjects = {}; $ManifoldKernelPool = {}; $Notebook = Upload[<|Type -> Object[LaboratoryNotebook]|>]},
	SymbolTearDown :> Module[{},
		(* Need to pause to wait for the computation objects to generate *)
		Pause[30];
		AbortManifoldKernel[Cases[$CreatedObjects, ObjectP[Object[Software, ManifoldKernel]]]];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		$Notebook = Null;
	]
];

DefineTests[executeKernelCommand,
	{
		Test["Basic kernel command:",
			Module[{kernelCommand, kernel},
				kernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>];
				kernelCommand = Upload[
					<|Type->Object[Software, ManifoldKernelCommand], Command -> "1+1", ManifoldKernel -> Link[kernel, Commands]|>
				];
				Upload[<|Object -> kernel, CurrentCommand -> Link[kernelCommand]|>];
				executeKernelCommand[kernelCommand];
				Download[kernelCommand, {Result, Status}]
			],
			{"2",Completed}
		],
		Test["Command with Error:",
			Module[{kernelCommand, kernel},
				kernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>];
				kernelCommand = Upload[
					<|Type->Object[Software, ManifoldKernelCommand], Command -> "1/0", ManifoldKernel -> Link[kernel, Commands]|>
				];
				Upload[<|Object -> kernel, CurrentCommand -> Link[kernelCommand]|>];
				executeKernelCommand[kernelCommand];
				Download[kernelCommand, {Result, Status, Messages[[All,1]], Messages[[All,3]]}]
			],
			(* in MM 13.3 we quiet 1/0 on first evaluation which changes the message here, so we put in the wildcard (_), but the idea is the same *)
			{"ComplexInfinity",Completed,_, {"Hold[Message[Power::infy, HoldForm[0^(-1)]]]"}},
			Messages :> {Power::infy}
		],
		Test["TerminateManifoldKernel:",
			Module[{kernelCommand, kernel},
				kernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>];
				kernelCommand = Upload[
					<|Type->Object[Software, ManifoldKernelCommand], Command -> "\"TerminateManifoldKernel\"", ManifoldKernel -> Link[kernel, Commands]|>
				];
				Upload[<|Object -> kernel, CurrentCommand -> Link[kernelCommand]|>];
				executeKernelCommand[kernelCommand]
			],
			True
		],
		Test["Clear the CurrentCommand at the end:",
			Module[{kernelCommand, kernel},
				kernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>];
				kernelCommand = Upload[
					<|Type->Object[Software, ManifoldKernelCommand], Command -> "1+1", ManifoldKernel -> Link[kernel, Commands]|>
				];
				Upload[<|Object -> kernel, CurrentCommand -> Link[kernelCommand]|>];
				executeKernelCommand[kernelCommand];
				Download[kernel, CurrentCommand]
			],
			Null
		]
	}
];

DefineTests[notifyKernelInError,
	{
		Test["Create an Asana ticket for kernels that are in Error:",
			notifyKernelInError[],
			{kernel},
			Stubs :> {
				Search[Object[Software, ManifoldKernel], ManifoldJob[Computations][Status] == Error && AsanaTaskID == Null] = {kernel},
				CreateAsanaTask[_] = 123
			}
		],
		Test["Sanity Check for no matching kernels:",
			notifyKernelInError[],
			{},
			Stubs :> {
				Search[Object[Software, ManifoldKernel], ManifoldJob[Computations][Status] == Error && AsanaTaskID == Null] = {},
				CreateAsanaTask[_] = 123
			}
		]
	},
	Variables  :> {computation, job, kernel},
	SymbolSetUp :> (
		computation = Upload[<|Type -> Object[Notebook, Computation], Status -> Error|>];
		job = Upload[<|Type -> Object[Notebook, Job], Append[Computations] -> Link[computation, Job]|>];
		kernel = Upload[<|Type -> Object[Software, ManifoldKernel], ManifoldJob -> Link[job]|>];
	)
];

DefineTests[notifyKernelsWithIncompleteCommands,
	{
	Test["Create an Asana ticket for commands where kernels that are in Error:",
		Module[{notifiedKernels},
			notifiedKernels = notifyKernelsWithIncompleteCommands[];
			Download[notifiedKernels, AsanaTaskID]
		],
		{_Integer, _Integer},
		Stubs :> {
			Search[Object[Software, ManifoldKernelCommand],
				Status != Completed && ManifoldKernel[AsanaTaskID] == Null] = {commandForCompleted, commandForError},
			CreateAsanaTask[_] = 123
		}
	],
	Test["Sanity Check for no matching kernels:",
		notifyKernelsWithIncompleteCommands[],
		{},
		Stubs :> {Search[Object[Software, ManifoldKernelCommand],
			Status != Completed && ManifoldKernel[AsanaTaskID] == Null] = {},
			CreateAsanaTask[_] = 123
		}
	]},
	Variables  :> {completedComputation, jobForCompleted, kernelForCompleted, commandForCompleted, errorComputation, jobForError, kernelForError, commandForError},
	SymbolSetUp :> (
		commandForCompleted = Upload[<|Type -> Object[Software, ManifoldKernelCommand], Status -> Pending|>];
		completedComputation = Upload[<|Type -> Object[Notebook, Computation], Status -> Completed|>];
		jobForCompleted = Upload[<|Type -> Object[Notebook, Job], Append[Computations] -> Link[completedComputation, Job]|>];
		kernelForCompleted = Upload[<|Type -> Object[Software, ManifoldKernel], ManifoldJob -> Link[jobForCompleted], Append[Commands] -> Link[commandForCompleted, ManifoldKernel]|>];
		commandForError = Upload[<|Type -> Object[Software, ManifoldKernelCommand], Status -> Running|>];
		errorComputation = Upload[<|Type -> Object[Notebook, Computation], Status -> Error|>];
		jobForError = Upload[<|Type -> Object[Notebook, Job], Append[Computations] -> Link[errorComputation, Job]|>];
		kernelForError = Upload[<|Type -> Object[Software, ManifoldKernel], ManifoldJob -> Link[jobForError], Append[Commands] -> Link[commandForError, ManifoldKernel]|>];
	)
];

DefineTests[runInteractiveManifoldKernel,
	{
		Test["Function terminates correctly:",
			Module[{mockCommand, mockKernel},
				{mockKernel, mockCommand} = Upload[{<|Type -> Object[Software, ManifoldKernel]|>, <|
					Type -> Object[Software, ManifoldKernelCommand],
					Status -> Pending, Command -> "\"TerminateManifoldKernel\""|>}];
				(*link up things*)
				Upload[<|Object -> mockCommand, ManifoldKernel -> Link[mockKernel, Commands]|>];
				runInteractiveManifoldKernel[mockKernel]
			],
			"Kernel Received Termination Command!"
		]
	}
];

DefineTests[RunManifoldKernelCommand,
	{
		Example[{Basic, "Sends any Mathematica expression to be run asynchronously on a cloud kernel:"},
			RunManifoldKernelCommand[1 + 1],
			ObjectP@Object[Software, ManifoldKernelCommand]
		],
		Example[{Basic, "Any valid expression works, including combined expressions:"},
			RunManifoldKernelCommand[(1 + 1; 1 + 2;)],
			ObjectP@Object[Software, ManifoldKernelCommand]
		],
		Example[{Basic, "Can call any function from SLL:"},
			RunManifoldKernelCommand[Download[$PersonID, Name]],
			ObjectP@Object[Software, ManifoldKernelCommand]
		],
		Example[{Options, WaitForComputation, "Optionally can wait for the result to finish before returning to user:"},
			RunManifoldKernelCommand[1 + 1, WaitForComputation -> True],
			2,
			Stubs :> {testingValue = 2}
		],
		Example[{Options, HardwareConfiguration, "Can request a separate kernel configuration:"},
			RunManifoldKernelCommand[1 + 1, HardwareConfiguration -> HighRAM],
			$Failed,
			Messages :> RunManifoldKernelCommand::KernelDoesNotExist
		],
		Example[{Attributes, HoldFirst, "The initial expression is held in order to get sent off to the cloud:"},
			RunManifoldKernelCommand[1 + 1],
			ObjectP@Object[Software, ManifoldKernelCommand]
		],
		Example[{Messages, "KernelDoesNotExist", "Throws a message if there are no kernels to run the command on:"},
			Block[{$ManifoldKernelPool = {}},
				RunManifoldKernelCommand[1 + 1]
			],
			$Failed,
			Messages :> RunManifoldKernelCommand::KernelDoesNotExist
		]
	},
	Stubs :> {$Notebook = fakeNotebook},
	Variables  :> {fakeNotebook},
	SymbolSetUp :> ($CreatedObjects = {}; $ManifoldKernelPool = {};
		fakeNotebook = Upload[<|Type -> Object[LaboratoryNotebook]|>];
		Block[{$Notebook = fakeNotebook}, LaunchManifoldKernel[]]),
	SymbolTearDown :> Module[{},
		AbortManifoldKernel[$ManifoldKernelPool];
	]
];

DefineTests[AbortManifoldKernel,
	{
		Example[{Basic, "Forefully quits the Manifold Kernel process, aborting any currently running commands:"},
			With[{interactiveKernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>]},
				AbortManifoldKernel[interactiveKernel] == {interactiveKernel}
			],
			True
		],
		Example[{Basic, "Removes the kernel from the available kernel pools:"},
			With[{interactiveKernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>]},
				$ManifoldKernelPool = {interactiveKernel};
				AbortManifoldKernel[interactiveKernel];
				$ManifoldKernelPool
			],
			{}
		],
		Example[{Messages, "KernelDoesNotExist", "Fails if no kernels are provided:"},
			AbortManifoldKernel[{}],
			$Failed,
			Messages :> AbortManifoldKernel::KernelDoesNotExist
		]
	}
];

DefineTests[StopManifoldKernel,
	{
		Example[{Basic, "Notifies the Manifold Kernel process to quit once finishes executing the queued commands commands:"},
			With[{interactiveKernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>]},
				StopManifoldKernel[interactiveKernel] == {interactiveKernel}
			],
			True
		],
		Example[{Basic, "Removes the kernel from the available kernel pools:"},
			With[{interactiveKernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>]},
				$ManifoldKernelPool = {interactiveKernel};
				StopManifoldKernel[interactiveKernel];
				$ManifoldKernelPool
			],
			{},
			SetUp :> ($ManifoldKernelPool = {interactiveKernel})
		],
		Example[{Messages, "KernelDoesNotExist", "Fails if no kernels are provided:"},
			StopManifoldKernel[{}],
			$Failed,
			Messages :> StopManifoldKernel::KernelDoesNotExist
		],
		Test["StopManifoldKernel uploads the given string command onto the interactive kernel:",
			With[{interactiveKernel = Upload[<|Type -> Object[Software, ManifoldKernel]|>]},
				StopManifoldKernel[interactiveKernel];
				Last@Flatten@Download[interactiveKernel, Commands[Command]]
			],
			"\"TerminateManifoldKernel\""
		]
	}
];

DefineTests[ManifoldKernelStatus,
	{
		Example[{Basic, "Checks the status a manifold kernel:"},
			ManifoldKernelStatus[Object[Software, ManifoldKernel, "id:abc"]],
			Ready,
			Stubs :> {Download[Object[Software, ManifoldKernel, "id:abc"], {CurrentCommand, ManifoldJob[Status], ManifoldJob[Computations[Status]]}] = {Null, Inactive, {Running}}}

		],
		Example[{Basic, "If there is an active running command, we're in a running state:"},
			ManifoldKernelStatus[Object[Software, ManifoldKernel, "id:abc"]],
			Running,
			Stubs :> {Download[Object[Software, ManifoldKernel, "id:abc"], {CurrentCommand, ManifoldJob[Status], ManifoldJob[Computations[Status]]}] = {Object[Software, ManifoldKernelCommand, "id:def"], Inactive, {Running}}}
		],
		Example[{Basic, "If the kernel has not started running, return whether in a Staged or Queued state:"},
			ManifoldKernelStatus[Object[Software, ManifoldKernel, "id:abc"]],
			Staged,
			Stubs :> {Download[Object[Software, ManifoldKernel, "id:abc"], {CurrentCommand, ManifoldJob[Status], ManifoldJob[Computations[Status]]}] = {Null, Inactive, {Staged}}}
		],
		Example[{Basic, "If the computation has not been created, return a Queued state:"},
			ManifoldKernelStatus[Object[Software, ManifoldKernel, "id:abc"]],
			Queued,
			Stubs :> {Download[Object[Software, ManifoldKernel, "id:abc"], {CurrentCommand, ManifoldJob[Status], ManifoldJob[Computations[Status]]}] = {Null, Active, {}}}
		]
	}
];

DefineTests[WaitForManifoldKernelCommand,
	{
		Example[{Basic, "Waits for the command to finish running on the cloud before returning:"},
			WaitForManifoldKernelCommand[Object[Software, ManifoldKernelCommand, "id:def"]],
			2,
			Stubs :> {
				waitForFieldValueOnObject[Object[Software, ManifoldKernelCommand, "id:def"], Status, Completed] = True,
				resultOfCompletedKernelCommand[Object[Software, ManifoldKernelCommand, "id:def"]] = 2
			}
		],
		Example[{Basic, "If the command never finishes, time out:"},
			TimeConstrained[WaitForManifoldKernelCommand[Object[Software, ManifoldKernelCommand, "id:def"]], 10],
			$Aborted,
			Stubs :> {Download[Object[Software, ManifoldKernelCommand, "id:def"], Status] = Running,
				waitForObjectChange[Object[Software, ManifoldKernelCommand, "id:def"], ""] = ""
			}
		],
		Example[{Basic, "If the command never starts, time out:"},
			TimeConstrained[WaitForManifoldKernelCommand[Object[Software, ManifoldKernelCommand, "id:def"]], 10],
			$Aborted,
			Stubs :> {Download[Object[Software, ManifoldKernelCommand, "id:def"], Status] = Pending,
				waitForObjectChange[Object[Software, ManifoldKernelCommand, "id:def"], ""] = ""
			}
		]
	}
];