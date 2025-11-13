(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*LaunchManifoldKernel*)

$ManifoldKernelPool = {};

LaunchManifoldKernel::NoComputationThreads = "You do not have a financing team configured with any computation threads.  Please contact ECL support to have computation threads added to your account.";
LaunchManifoldKernel::InsufficientComputationThreads = "You have `1` computational threads and `2` already running manifold kernels, so additional kernels cannot be created.  Please kill existing kernels or request fewer kernels.";
LaunchManifoldKernel::PublicKernelsNotAllowed = "$Notebook is currently set to None, which means the generated manifold kernel would be public.  For security reasons, this is not allowed.  Please make sure you are running this from a Notebook or manually set/block $Notebook and try again.";
LaunchManifoldKernel::NotLoggedIn = "You may not launch manifold kernels when you are not logged into constellation.  Please call Login[] and try again.";

(* Option Definitions *)
DefineOptions[LaunchManifoldKernel,
	Options :> {
		BaseComputationKernelOptions
	}
];

(* Launch a mathematica kernel - note that this will not wait for the kernel to be ready but instead will return basically immediately *)
LaunchManifoldKernel[opts : OptionsPattern[LaunchManifoldKernel]] := LaunchManifoldKernel[1, opts];

(* Launch multiple kernels at once *)
LaunchManifoldKernel[numKernels:GreaterP[0,1], opts:OptionsPattern[LaunchManifoldKernel]] := Module[
	{numNewKernels, kernelsToReuse, existingKernels},

	(* Validate that $Notebook is set, so this is not launched in a way that anyone can access it *)
	If[MatchQ[Null, $Notebook], Message[LaunchManifoldKernel::PublicKernelsNotAllowed]; Return[$Failed]];

	(* Make sure that you are logged in *)
	If[!Constellation`Private`loggedInQ[], Message[LaunchManifoldKernel::NotLoggedIn]; Return[$Failed]];

	(* Validate the number of computation threads *)
	If[MatchQ[$Failed, validateAvailableComputationThreads[numKernels]], Return[$Failed]];

	(* get any pre-existing kernels we can use, and remove any that have Available -> False; this could happen from a different kernel and so the local $ManifoldKernelPool cache would become out of date *)
	existingKernels = PickList[$ManifoldKernelPool, Download[$ManifoldKernelPool, Available], Except[False]];
	numNewKernels = If[Length[existingKernels] > 0,
		kernelsToReuse = Take[existingKernels, UpTo[numKernels]];
		$ManifoldKernelPool = kernelsToReuse;
		numKernels - Length@kernelsToReuse,
		numKernels
	];

	If[numNewKernels < 1, Return[$ManifoldKernelPool]];
	(* Launch the kernels *)
	Table[launchKernel[opts], numNewKernels];
	$ManifoldKernelPool
];

(* Validate that the caller has enough computation threads to launch the requested number of kernels *)
validateAvailableComputationThreads[numKernels_Integer] := Module[
	{computationThreads},

	(* Figure out the max number of computation threads a user can have access to *)
	computationThreads = Total[Download[$PersonID, FinancingTeams[MaxComputationThreads]]];

	(* Max sure the user has computation threads configured *)
	If[computationThreads == 0, Message[LaunchManifoldKernel::NoComputationThreads]; Return[$Failed]];

	(* Start by pruning any existing kernels that have terminated from the pool *)
	pruneTerminatedKernelsFromKernelPool[];

	(* Now check if the user has sufficient computation threads to run the kernel *)
	If[Length[$ManifoldKernelPool] + numKernels > computationThreads, Message[LaunchManifoldKernel::InsufficientComputationThreads, computationThreads, Length[$ManifoldKernelPool]]; Return[$Failed]];
];

(* Remove any timed out kernels from the available pool of kernels *)
pruneTerminatedKernelsFromKernelPool[] := Module[
	{},
	(* Update the kernel pool to include things that are not completed *)
	Return[];
];

insertSllVersionAndCommitIntoOps[] := insertSllVersionAndCommitIntoOps[{}];
insertSllVersionAndCommitIntoOps[opts:OptionsPattern[LaunchManifoldKernel]] := Module[{sllCommit, sllVersion, updatedOpts},
	(* if not a super user, we cannot specify version and commit *)
	If[!MatchQ[$PersonID,ObjectP[Object[User,Emerald]]], Return[opts]];

	(* Figure out the sll version and commit to use - if we're in a git repo, use the current branch, if we're on a distro, use that branch, otherwise use stable*)
	{sllCommit, sllVersion} = localSllVersionAndCommit[];

	(* overwrite the default options, but keep the actual options if they were specified *)
	updatedOpts = Normal@Append[<|SLLCommit -> sllCommit, SLLVersion -> sllVersion|>, ToList[opts]];
	updatedOpts
];

(* Checks already existing kernels to see if we can reuse them *)
justInTimeKernels[opts: OptionsPattern[LaunchManifoldKernel]] := Module[{safeOps, resolvedOps, hardwareConfig,
	sllVersion, sllCommit, originalSLLCommit, sllPackage, potentialKernels, openKernels, unavailableKernelPositions,
	justInTimeKernels, userToRunAs},

	safeOps=Association[
		SafeOptions[LaunchManifoldKernel,ToList[insertSllVersionAndCommitIntoOps@opts], AutoCorrect->False]
	];
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	resolvedOps = Join[
		safeOps,
		Association[
			resolveDeveloperOnlyOptions[ToList[insertSllVersionAndCommitIntoOps@opts]]
		]
	];

	(* use {HardwareConfiguration, SLLVersion, SLLCommit, SLLPackage, OriginalSLLCommit} for matching as well as user id *)
	originalSLLCommit = getOriginalSLLCommit[];

	{hardwareConfig, sllVersion, sllCommit, sllPackage, userToRunAs} = Lookup[resolvedOps, {HardwareConfiguration, SLLVersion, SLLCommit, SLLPackage, RunAsUser}];
	sllVersion=If[!NullQ[sllVersion],
		"\""<>sllVersion<>"\""
	];

	(* if Search is too slow, just Download all with an Active Computation and filter the rest away.
	   I don't think the performance would be too bad *)
	potentialKernels = If[MatchQ[$Distro,ObjectP[Object[Software,Distro]]],
		Search[Object[Software, ManifoldKernel],
			CreatedBy == $PersonID && Distro == $Distro,
			Notebooks -> {$Notebook},
			PublicObjects -> False
		],
		Search[Object[Software, ManifoldKernel],
			CreatedBy == $PersonID &&
					ManifoldJob[HardwareConfiguration] == hardwareConfig &&
					ManifoldJob[SLLCommit] == sllCommit &&
					ManifoldJob[OriginalSLLCommit] == originalSLLCommit &&
					ManifoldJob[SLLPackage] == sllPackage &&
					ManifoldJob[SLLVersion] == sllVersion &&
					ManifoldJob[RunAsUser] == userToRunAs,
			Notebooks -> {$Notebook},
			PublicObjects -> False
		]
	];

	(* prune any kernels that are completed *)
	openKernels = Select[potentialKernels, Not@MatchQ[ManifoldKernelStatus[#], Completed] &];

	(* prune any kernels that are waiting to complete *)
	(* there are race conditions if more than one instance is sharing a kernel, otherwise this is fine*)
	unavailableKernelPositions = Position[Quiet[Download[openKernels, Commands[[-1]][Command]], Download::Part], "TerminateManifoldKernel"];

	justInTimeKernels = Delete[openKernels, unavailableKernelPositions];

	justInTimeKernels
];

(* launch a single manifold kernel *)
launchKernel[opts : OptionsPattern[LaunchManifoldKernel]] := Module[
	{kernel, manifoldJob, distro,updatedOpts},

	distro = If[MatchQ[$Distro, $Failed], Null, $Distro];

	(* Create the kernel *)
	kernel = Upload[<|Type -> Object[Software, ManifoldKernel], Distro->Link[distro]|>];

	updatedOpts = insertSllVersionAndCommitIntoOps[opts];

	(* when launching a new kernel, assume no existing kernel exists so we ensure a job actually gets created *)
	manifoldJob = Block[{$ManifoldKernelPool = {}},
		(* Create the manifold job - note the funky syntax so we can evaluate the variables here and not in the manifold job *)
		With[{insertableKernel = kernel, notebook = $Notebook}, Compute[Block[{$Notebook = notebook}, runInteractiveManifoldKernel[insertableKernel]], updatedOpts]]
	];
	
	(* Link the two up *)
	Upload[<|Object -> kernel, ManifoldJob -> Link[manifoldJob]|>];

	(* Add the kernel to the kernel pool *)
	AppendTo[$ManifoldKernelPool, kernel];

	(* Return the new kernel *)
	kernel
];

(* Returns all of the kernels in the pool that match the specified parameters *)
kernelsForConfiguration[opts: OptionsPattern[RunManifoldKernelCommand]] := Module[
	{safeOps, resolvedOps, kernelConfigurations, requestedConfiguration, matchingKernelPositions},

	safeOps=Association@SafeOptions[RunManifoldKernelCommand,ToList[opts],AutoCorrect->False];

	(* Prune timed out kernels *)
	pruneTerminatedKernelsFromKernelPool[];

	(* Download the status of all of the kernels *)
	kernelConfigurations = Download[
		ToList[$ManifoldKernelPool],
		{
			ManifoldJob[{HardwareConfiguration, SLLVersion, SLLCommit, SLLPackage}],
			Notebook[Object]
		}
	];

	resolvedOps = Join[safeOps, Association@resolveDeveloperOnlyOptions[ToList[opts]]];

	(* Object[LaboratoryNotebook, "id:kEJ9mqJXk0Pz"] is Object[LaboratoryNotebook, "Parallel Execute Notebook"]; $Notebook might be Null because this is public, but the Notebook of a public manifold kernel will always be the Parallel Execute Notebook, so we need to account for that here *)
	requestedConfiguration = {Lookup[resolvedOps, {HardwareConfiguration, SLLVersion, SLLCommit, SLLPackage}], $Notebook /. {Null -> Object[LaboratoryNotebook, "id:kEJ9mqJXk0Pz"]}};

	matchingKernelPositions = Position[kernelConfigurations, requestedConfiguration];

	(* Check for configurations that match what was requested *)
	Extract[$ManifoldKernelPool, matchingKernelPositions]
];

(* Return the best kernel to use for a configuration, assuming one exists *)
kernelForConfiguration[opts: OptionsPattern[RunManifoldKernelCommand]] := Module[
	{matchingKernels, readyKernels, updatedOpts},
	updatedOpts = insertSllVersionAndCommitIntoOps[opts];

	(* Grab all the kernels that match the spec *)
	matchingKernels = kernelsForConfiguration[updatedOpts];

	If[MatchQ[Length[matchingKernels], 0], Return[Null]];

	(* Grab the matching, ready kernels *)
	readyKernels = Select[matchingKernels, MatchQ[ManifoldKernelStatus[#], Ready] &];

	(* Preferentially return the ready kernels *)
	If[Length[readyKernels] > 0, RandomChoice[readyKernels], RandomChoice[matchingKernels]]
];

(* Note - Stop and Abort should stay in lock step with how Stop and AbortComputation work.  Abort is hard kill and Stop is die after pending commands are finished *)
StopManifoldKernel::KernelDoesNotExist = "There is not a currently running manifold kernel.  Please call LaunchManifoldKernel to launch one."
AbortManifoldKernel::KernelDoesNotExist = "There is not a currently running manifold kernel.  Please call LaunchManifoldKernel to launch one."

(* Abort the running manifold kernels *)
AbortManifoldKernel[] := AbortManifoldKernel[$ManifoldKernelPool];
AbortManifoldKernel[kernel : ObjectP[Object[Software, ManifoldKernel]]] := AbortManifoldKernel[{kernel}];
AbortManifoldKernel[kernels: {ObjectP[Object[Software, ManifoldKernel]]...}] := Module[
	{computations},

	(* Check if the list is empty *)
	If[Length[kernels] == 0, Message[AbortManifoldKernel::KernelDoesNotExist]; Return[$Failed]];

	(* Find all the computations associated with the kernels *)
	computations = Flatten[Download[kernels, ManifoldJob[Computations]]];

	(* Abort them all! *)
	AbortComputation[computations];

	(* Remove them from the current pool *)
	$ManifoldKernelPool = Select[$ManifoldKernelPool, ! MemberQ[kernels, #] &];

	markKernelsAsUnavailable[kernels];
	(* Return the aborted kernels *)
	kernels
];

(* Stop the running manifold kernels *)
StopManifoldKernel[] := StopManifoldKernel[$ManifoldKernelPool];
StopManifoldKernel[kernel : ObjectP[Object[Software, ManifoldKernel]]] := StopManifoldKernel[{kernel}];
StopManifoldKernel[kernels: {ObjectP[Object[Software, ManifoldKernel]]...}] := Module[
	{},

	(* Check if the list is empty *)
	If[Length[kernels] == 0, Message[StopManifoldKernel::KernelDoesNotExist]; Return[$Failed]];

	(* Send a stop command to them all *)
	Map[RunManifoldKernelCommand["TerminateManifoldKernel", #] &, kernels];

	(* Remove them from the current pool *)
	$ManifoldKernelPool = Select[$ManifoldKernelPool, ! MemberQ[kernels, #] &];

	markKernelsAsUnavailable[kernels];
	(* Return the stopped kernels *)
	kernels
];

markKernelsAsUnavailable[kernels: {ObjectP[Object[Software, ManifoldKernel]]...}] := Module[{uploadPackets},
	uploadPackets = <|Object -> #, Available -> False |> & /@ kernels;
	Upload[uploadPackets];
];

(* Run a command on the current kernel *)
RunManifoldKernelCommand::KernelDoesNotExist = "There is no current manifold kernel associated with this session matching the requested specs.  Please call LaunchManifoldKernel[] and then retry this command.";

(* Set the HoldFirst attribute so raw expressions can be passed *)
SetAttributes[RunManifoldKernelCommand, HoldFirst];

DefineOptions[RunManifoldKernelCommand,
	Options :> {
		{WaitForComputation -> False, True | False, "If true, wait for the command to finish and return the result.  Otherwise, return immediately."},
		ZDriveFilePathsOptions,
		ComputationKernelOptions
	}
];

(* hack because the option won't play nicely with the manifold unit test system *)
testingValue = "";

(* Run a kernel command on a supplied kernel - if none is supplied, one will be chosen automatically *)
RunManifoldKernelCommand[command_, opts : OptionsPattern[RunManifoldKernelCommand]] := RunManifoldKernelCommand[command, kernelForConfiguration[opts], opts];
RunManifoldKernelCommand[command_, kernel: ObjectP[Object[Software, ManifoldKernel]] | Null, opts : OptionsPattern[RunManifoldKernelCommand]] := Module[
	{kernelCommand, zdrivePaths},

	(* Check that a non-null kernel was supplied *)
	If[MatchQ[Null, kernel], Message[RunManifoldKernelCommand::KernelDoesNotExist]; Return[$Failed]];

	zdrivePaths = Lookup[OptionDefaults[RunManifoldKernelCommand, ToList[opts]], "ZDriveFilePaths"];

	(* Create the manifold kernel command *)
	kernelCommand = Upload[<|Type -> Object[Software, ManifoldKernelCommand],
		Status -> Pending,
		Append[ZDriveFilePaths] -> zdrivePaths, 
		Command -> ToString[Unevaluated@command, InputForm]|>];

	Upload[<|Object -> Download[kernel, Object], Append[Commands] -> {Link[kernelCommand, ManifoldKernel]}|>];
	(* Determine whether or not to wait for the result *)

	If[Not[MatchQ[testingValue, ""]], Return[testingValue]];

	If[
		Lookup[OptionDefaults[RunManifoldKernelCommand, ToList[opts]], "WaitForComputation"],
		WaitForManifoldKernelCommand[kernelCommand],
		kernelCommand
	]
];

(* Wait for a manifold kernel command to complete *)
WaitForManifoldKernelCommand[kernelCommand_] := Module[
	{},

	(* wait until the status is complete *)
	waitForFieldValueOnObject[kernelCommand, Status, Completed];

	(* Return the result! *)
	resultOfCompletedKernelCommand[kernelCommand]
];

waitForObjectChange[object : ObjectP[], currentCas_String] := Module[
	{objectWithLatestCas},
	(* Latest values, if any, will overwrite current values *)
	objectWithLatestCas = Join[<|object -> currentCas|>, Constellation`Private`waitForChange[<|object -> currentCas|>]];
	Lookup[objectWithLatestCas, object]
];

(* Calculate the local version of SLL and the commit *)
localSllVersionAndCommit[] := Module[
	{gitCommit, gitBranch},

	(* start by checking if we're in a git repo *)
	gitCommit = Quiet[GitCommitHash[$EmeraldPath]];
	gitBranch = Quiet[GitBranchName[$EmeraldPath]];

	Which[
		MatchQ[gitCommit, _String] && MatchQ[gitBranch, _String],
		{gitCommit, gitBranch},
		(* If we didn't get the git repo info, check if we can pull $Distro info *)
		!MatchQ[Null, $Distro] && !MatchQ[$Failed, $Distro],
		Download[$Distro,{Commit,Model[Branch]}],
		(* If we're not in a git repo or on a distro, just use stable *)
		True,
		{"HEAD", "stable"}
	]
];

waitForFieldValueOnObject[object_, fieldName_, fieldValue_] := Module[
	{cas, currentValue},

	(* Grab the cas and current value of the object *)
	(* Need to get IncludeCas to work without the full object *)
	{cas, currentValue} = {"", Download[object, fieldName]};

	(* Loop forever until you find the right value *)
	While[
		!MatchQ[currentValue, fieldValue],

		(* If you're not done, wait until there's a change on the object *)
		cas = waitForObjectChange[object, cas];

		(* Grab the cas and current value of the object *)
		(* Need to get IncludeCas to work without the full object *)
		currentValue = Download[object, fieldName];
	];
];

resultOfCompletedKernelCommand[object_] := Module[
	{result, messages},
	(* grab the result and the held message expressions *)
	{result, messages} = Download[object, {Result, Messages[[All, 3]]}];

	ReleaseHold[ToExpression[#]] & /@ messages;
	(* Return the result - update to handle large results *)
	ToExpression[result]
];

(* This runs on manifold to poll incoming commands until it is time to exit *)


(* Authors definition for Manifold`Private`runInteractiveManifoldKernel *)
Authors[Manifold`Private`runInteractiveManifoldKernel]:={"steven"};

runInteractiveManifoldKernel[kernel_] := Module[
	{timeoutDate = Now + 8 Hour, cas = "", receivedTermination = False, commands, pendingCommands},
	Echo[Now, "current time"];
	Echo[timeoutDate, "timeout time"];
	(* Loop until the timeout is reached - if its not, you'll get killed by an exit command or the kernel timing out *)
	While[
		Now < timeoutDate,
		(* Wait for changes and repeat! *)
		Echo[kernel, "Waiting for object changes on kernel: "];
		Echo[cas, "The current cas is: "];
		cas = waitForObjectChange[kernel, cas];
		Echo[cas, "The new cas is: "];

		(* grab the current CAS and commands *)
		commands = Download[kernel, Commands];

		(* filter out just the ones that are pending *)
		pendingCommands = Select[Download[commands, {Object, Status}], MatchQ[#[[2]], Pending] &];
		Echo[pendingCommands, "Have pending commands: "];

		(* execute each pending command in order, exiting if needed *)
		Map[If[executeKernelCommand[#], receivedTermination = True; Break[]] &, First /@ pendingCommands];

		(* Update the timeout if you found any pending commands.  Note we do this after execution, as we timeout 4 hours after the last command completed, not when it was submitted *)
		timeoutDate = If[Length[pendingCommands] == 0, timeoutDate, Now + 12 Hour];
		Echo[timeoutDate, "New timeout date"];
	];

	markKernelsAsUnavailable[{kernel}];
	If[receivedTermination,
		Return["Kernel Received Termination Command!"]
	];

	Echo["Interactive manifold kernel timed out."];
];

(* This executes the supplied kernel task.  It returns true if the kernel should die as a result of this task *)


(* Authors definition for Manifold`Private`executeKernelCommand *)
Authors[Manifold`Private`executeKernelCommand]:={"steven"};

executeKernelCommand[command_] := Module[
	{evaluationData, commandString, zdriveFiles, kernel},

	(* grab the string version of the command and other fields *)
	{zdriveFiles, commandString, kernel} = Download[command, {ZDriveFilePaths, Command, ManifoldKernel[Object]}];

	(* Mark the command as running and the command as current in the manifold kernel *)
	Upload[{<|Object -> command, DateStarted -> Now, Status -> Running|>, <|Object -> kernel, CurrentCommand -> Link[command]|>}];

	(* mount the necessary z-drive files *)
	If[Length[zdriveFiles] > 0,
		loadZDrivePaths[command, zdriveFiles];
		Echo["Starting Wait for files to load in Manifold."];
		waitForFieldValueOnObject[command, LoadedVolumes, True];
		Echo["Wait Complete."];
	];

	(* Evaluate the command *)
	Echo["Starting Evaluation of expression."];
	evaluationData = EvaluationData[ToExpression[commandString]];
	Echo["Evaluation complete."];

	Echo["Uploading evaluation results."];
	(* Store the result - TODO(bsmith): handle large results with the result cloud file field *)
	Upload[{
		<|
			Object -> command,
			Result -> ToString[InputForm[evaluationData["Result"]]],
			DateCompleted -> Now,
			Append[Messages] -> MapThread[
				{ToString[#1], #2, ToString[#3, InputForm]} &,
				{evaluationData["Messages"], evaluationData["MessagesText"], evaluationData["MessagesExpressions"]}
			],
			Status -> Completed
		|>,
		<|Object -> kernel, CurrentCommand -> Null|>
	}];
	Echo["Uploading complete."];

	If[Length[zdriveFiles] > 0,
		unloadZDrivePaths[zdriveFiles]
	];

	(* If the command was the string "TerminateManifoldKernel", then we should quit *)
	MatchQ[commandString, "\"TerminateManifoldKernel\""]
];

(* this launches a special message that notifies the manifold job to load the paths from the z-drive.*)
loadZDrivePaths[command_, paths : {_String..}] := Echo[command[ID] <> ":load-z-drive-strange-excitement-rapidly-explore:" <> ToString[paths]];
unloadZDrivePaths[paths : {_String..}] := Echo["unload-z-drive-strange-excitement-rapidly-explore:" <> ToString[paths]];


(* Returns the status of the manifold kernel job. *)
ManifoldKernelStatus[kernel_] := Module[
	{jobStatus, currentCommand, computationStatus},

	(* Download the status of each job and computation *)
	{currentCommand, jobStatus, computationStatus} = Download[kernel, {CurrentCommand, ManifoldJob[Status], ManifoldJob[Computations[Status]]}];

	(* There are three basic situations -
		1.  The job is active and no computations have been created yet, in which case we are Queued.
		2.  There is a non-completed computation, in which case we are in the state of that computation.
		3.  The job is inactive and there are no active computations, in which case the kernel has either timed out or was killed
	*)
	Which[
		(* if the underlying computation is not running the kernel is completed *)
		MemberQ[computationStatus, Aborting], Completed,
		MemberQ[computationStatus, Aborted], Completed,
		MemberQ[computationStatus, Error], Completed,
		(* If the job is still running, then we're bringing all the infrastructure up *)
		MatchQ[Active, jobStatus], Queued,
		(* If there's an actively running command, then we're in running state *)
		!MatchQ[Null, currentCommand], Running,
		(* If there are no computations, then we're in between when the job submitted and the first computation kicked off *)
		Length[computationStatus] == 0, Queued,
		(* If there's an active computation, we can run commands! *)
		MemberQ[computationStatus, Running], Ready,
		(* If there's a staging or waiting command, then we should wait a bit *)
		MemberQ[computationStatus, Queued], Queued,
		MemberQ[computationStatus, Staged], Staged,
		MemberQ[computationStatus, WaitingForDistro], WaitingForDistro,
		(* Otherwise, we're done and the kernel is no longer accessible *)
		True, Completed
	]
];

(* Find all commands that should have completed but have not *)
(* A kernel should never close without finishing its pending commands, so notify platform about these instances *)


(* Authors definition for Manifold`Private`notifyKernelsWithIncompleteCommands *)
Authors[Manifold`Private`notifyKernelsWithIncompleteCommands]:={"steven"};

notifyKernelsWithIncompleteCommands[] := Module[{incompleteCommands, commandKernels, kernelStatuses,
	completedKernels, allAsanaPackets, allAsanaIDs, uploadPackets},
	(* Find all Commands that have not completed. Also don't grab any commands whose kernels have already been tagged with an error *)
	incompleteCommands = Search[Object[Software, ManifoldKernelCommand],
		Status != Completed && ManifoldKernel[AsanaTaskID] == Null];
	commandKernels = DeleteDuplicates@Download[incompleteCommands, ManifoldKernel[Object]];
	kernelStatuses = ManifoldKernelStatus /@ commandKernels;
	completedKernels = PickList[commandKernels, kernelStatuses, Completed];
	allAsanaPackets = Map[<|Name -> "Error in Manifold Kernel: " <> ToString[#1], Notes -> "Kernel closed with incomplete commands. ", Assignee -> onCallPlatformEngineer[]|>&,
		completedKernels];

	allAsanaIDs = CreateAsanaTask[#]& /@ allAsanaPackets;
	uploadPackets = MapThread[<|Object->#1, AsanaTaskID -> #2|>&, {completedKernels, allAsanaIDs}];
	Upload[uploadPackets]
];

(* find's all kernels that are in Error and create an Asana task for them *)


(* Authors definition for Manifold`Private`notifyKernelInError *)
Authors[Manifold`Private`notifyKernelInError]:={"steven"};

notifyKernelInError[] := Module[{allErroredKernels, allErrorMessages, allAsanaPackets, allAsanaIDs, uploadPackets},
	allErroredKernels = Search[Object[Software, ManifoldKernel], ManifoldJob[Computations][Status] == Error && AsanaTaskID == Null];

	(* for all errored kernels create an an asana task notifying the error state *)
	allErrorMessages = Flatten@Download[allErroredKernels, ManifoldJob[Computations][ErrorMessage]];

	(* TODO: who should be actual assignee? Platform? *)
	allAsanaPackets = MapThread[<|Name -> "Error in Manifold Kernel: " <> ToString[#1], Notes -> ToString@#2, Assignee -> onCallPlatformEngineer[]|>&,
		{allErroredKernels, allErrorMessages}];

	allAsanaIDs = CreateAsanaTask[#]& /@ allAsanaPackets;

	uploadPackets = MapThread[<|Object->#1, AsanaTaskID -> #2|>&, {allErroredKernels, allAsanaIDs}];

	Upload[uploadPackets]
];

(* if some kernels close due to some crash, they wont get marked as unavailable. So a script will call this function for cleanup *)
markClosedKernelsAsUnavailable[] := Module[{supposedlyAvailableKernels, actuallyUnavailableKernels},
	supposedlyAvailableKernels = Search[Object[Software, ManifoldKernel], Available != False];
	actuallyUnavailableKernels = Select[supposedlyAvailableKernels, MatchQ[ManifoldKernelStatus[#], Completed] &];
	markKernelsAsUnavailable[actuallyUnavailableKernels];
];


(* a script that creates "always on" kernels so that they can be accessed outside of mathematica *)
alwaysOnNotebooks[] := {
	Object[LaboratoryNotebook, "Pavan Blah"],
	Object[LaboratoryNotebook, "id:xRO9n3OjqbJj"] (* Object[LaboratoryNotebook, "cmu+torus+integration User Training"]*)
};

createAlwaysOnKernels[] := Module[{notebooks, newKernels, updateToAvailablePackets},
	notebooks = alwaysOnNotebooks[];
	newKernels = createManifoldKernelsForNotebook /@ notebooks;
	updateToAvailablePackets = <|Object -> #, Available -> True |>& /@ Flatten[newKernels];
	Upload[updateToAvailablePackets];
];

createManifoldKernelsForNotebook[notebook:ObjectP[Object[LaboratoryNotebook]]] := Module[
	{availableKernels, maxComputations, withTimeInfo, sortedKernels, kernelsToStop, numberOfKernelsToLaunch, userObj, newKernels, pendingKernels, mathematicaVersion},
	availableKernels = Search[Object[Software, ManifoldKernel], Notebook == notebook && Available == True];

	mathematicaVersion = Null; (* This means the default version *)

	maxComputations = If[MatchQ[notebook, Object[LaboratoryNotebook, "Pavan Blah"]],
		2,
		(* Note: Can a notebook have multiple financing teams associated with it? *)
		(* You don't want to create computations up to the Max Amount because you want some buffer *)
		Floor[Download[notebook, Financers[[1]][MaxComputationThreads]] / 2]
	];

	(* Check results in case Download fails for non "Pavan Blah" notebooks *)
	If[!MatchQ[maxComputations, _Integer?Positive],
		Return[$Failed];
	];

	kernelsToStop = If[Length[availableKernels] > maxComputations,
		withTimeInfo = Download[availableKernels, {Object, DateCreated}];
		sortedKernels = Sort[withTimeInfo, #1[[2]] < #2[[2]] &][[All,1]];
		Take[sortedKernels, {1, -2}],
		{}
	];

	(*
		Need to assume identity in order to make sure that manifold super user does no control the manifold kernel and
		the stop command
	*)
	userObj = Download[notebook, CreatedBy];
	If[!MatchQ[userObj, ObjectP[Object[User]]],
		Return[$Failed];
	];
	Constellation`Private`AssumeIdentity[userObj, Constellation`Private`AllowRollback -> True];

	If[Length[kernelsToStop]>0,
		StopManifoldKernel[kernelsToStop];
	];

	pendingKernels = Download[notebook, Financers[[1]][ComputationQueue]];

	(* In case there aren't sufficient kernels, create the necessary amount *)
	(* count pending computations against the max computation limit to avoid a buildup in the computation queue queue *)
	numberOfKernelsToLaunch = maxComputations - (Length[availableKernels] + Length[pendingKernels]) ;

	If[!MatchQ[maxComputations, _Integer?Positive],
		Constellation`Private`RollbackAssumeIdentity[];
		Return[];
	];

	newKernels = Table[Block[{$Notebook = notebook},
		launchKernel[MathematicaVersion -> mathematicaVersion]
	], numberOfKernelsToLaunch];

	Constellation`Private`RollbackAssumeIdentity[];

	newKernels
];

onCallPlatformEngineer[]:=With[
	{onCallPlatformEngineer=Constellation`Private`OnCall["platform"]},
	Object[Lookup[onCallPlatformEngineer, "id", "id:eGakldJe6Vnq"]];
];