(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*$MinThreadRelease*)


OnLoad[$MinThreadRelease=5 Minute];


(* ::Section::Closed:: *)
(*BacklogTime*)


(* ::Subsection::Closed:: *)
(*BacklogTime Options*)


DefineOptions[BacklogTime, Options :> {CacheOption}];


(* ::Subsection::Closed:: *)
(*BacklogTime*)


(*  --- Overload 1: Single Protocol --- *)


(* Authors definition for BacklogTime *)
Authors[BacklogTime]:={"hayley"};

BacklogTime[prot:ObjectP[Object[Protocol]], ops:OptionsPattern[]]:=Module[
	{returnValue},

	(* pass the listed protocol to the core overload *)
	returnValue=BacklogTime[{prot}, ops];

	(* return the first value unless the return value is a failure *)
	If[FailureQ[returnValue], returnValue, First[returnValue]]
];


(* --- Overload 2: Empty List --- *)
BacklogTime[{}, ops:OptionsPattern[]]:={};


Experiment::NonBackloggedProtocols="The input protocols `1` are not backlogged; backlog time can only be estimated for protocols that are currently in the backlog. Please check the status of the input protocols.";


(* --- CORE FUNCTION: Multiple Protocols --- *)
BacklogTime[myProtocols:{ObjectP[Object[Protocol]]..}, myOptions:OptionsPattern[]]:=Module[
	{safeOptions, inCache, now, protocolDownloadTuples, teamPackets, maybeBackloggedPacketsByTeam, inputProtocolPackets, nonBackloggedInputPackets,
		backloggedPacketsByTeam, notebooksByTeam, notebookSearchConditionsByTeam, potentiallyMissingFromBacklogByTeam, actuallyMissingFromBacklogByTeam,
		allBacklogProtocolsByTeam, openThreadProtocolsByTeam, maxThreadsByTeam, activeProtocolPacketsByTeam, allBacklogPacketsByTeam,
		completedProtocolPacketsByTeam, nonCompletedProtocolPacketsByTeam, operatorStartPacketsByTeam, processingPacketsByTeam,
		flatNonCompletedProtocolPackets, runTimeLookup, packetsNeedingQueueTime, queueTimeLookup, flatAllProtocolPackets,
		delayTimeLookup, runningAndBackloggedProtocolsByTeam, notRunningAndBackloggedProtocolsByTeam, runningBackloggedCompleted},

	(* pull out some options from safe ops*)
	safeOptions=SafeOptions[BacklogTime, ToList[myOptions]];
	inCache=Lookup[safeOptions, Cache];
	now=Now;

	(* Determine the teamPackets these protocols belongs*)
	protocolDownloadTuples=Download[myProtocols,
		{
			Packet[Notebook[Financers][[1]][{MaxThreads, NotebooksFinanced, Queue}]],
			Packet[Notebook[Financers][[1]][Backlog][{DateStarted, DateConfirmed, DateEnqueued, Status, OperationStatus, Checkpoints, CheckpointProgress}]],
			Packet[Status]
		},
		Cache -> inCache
	];

	(* separate out the download values; we have team packets (one per input protocol) and lists of backlogged protocols (one LIST per input protoclol) *)
	teamPackets=protocolDownloadTuples[[All, 1]];
	maybeBackloggedPacketsByTeam=protocolDownloadTuples[[All, 2]];
	inputProtocolPackets=protocolDownloadTuples[[All, 3]];

	(* make sure all of the INPUT protocol packets actually have status of Backlogged *)
	nonBackloggedInputPackets=Select[inputProtocolPackets, MatchQ[Lookup[#, Status], Except[Backlogged]]&];
	If[MatchQ[nonBackloggedInputPackets, {PacketP[]..}],
		Message[Experiment::NonBackloggedProtocols, Lookup[nonBackloggedInputPackets, Object]];
		Return[$Failed]
	];

	(* TEMP HACK: actually get the backlogged packets since the Backlog field is currently unreliable (can have Canceled prots for example);
	 	future person reading this, please delete this if you are at all confident that the Backlog field is behaving properly *)
	backloggedPacketsByTeam=Function[backlogPacketList, Select[backlogPacketList, MatchQ[Lookup[#, Status], Backlogged]&]] /@ maybeBackloggedPacketsByTeam;

	(* get all the notebooks for the team for the protocols for which we want backlog time *)
	notebooksByTeam=Map[Download[Lookup[#, NotebooksFinanced], Object]&, teamPackets];

	(* search for protocols that might potentially be missing from the backlog *)
	notebookSearchConditionsByTeam=(ParentProtocol == Null && Status == Backlogged && Notebook == Alternatives @@ #)& /@ notebooksByTeam;
	potentiallyMissingFromBacklogByTeam=With[{conds=notebookSearchConditionsByTeam}, Search[ConstantArray[Object[Protocol], Length[notebookSearchConditionsByTeam]], conds]];
	actuallyMissingFromBacklogByTeam=MapThread[
		Complement[#1, Lookup[#2, Object, {}]]&,
		{potentiallyMissingFromBacklogByTeam, backloggedPacketsByTeam}
	];

	(* rebuild the whole list, doing all this because this preservers the order of the backlog and adds on any new protocols found to the end *)
	allBacklogProtocolsByTeam=MapThread[
		Join[Lookup[#1, Object, {}], #2]&,
		{backloggedPacketsByTeam, actuallyMissingFromBacklogByTeam}
	];

	(* Run OpenThreads to determine all the protocols currently occuping threads (processing, tsr, completed [within $MinThreadRelease]), and add in any backlogged protocols found by search *)
	openThreadProtocolsByTeam=OpenThreads[teamPackets];
	runningBackloggedCompleted=MapThread[Join, {openThreadProtocolsByTeam, actuallyMissingFromBacklogByTeam}];

	(* get the max number of threads for each team*)
	(* the current number of available threads should be zero, or we would not be doing this so don't need available threads*)
	maxThreadsByTeam=Lookup[teamPackets, MaxThreads];

	(* Download info about the current protocols now that we know what they are plus any completed protocols that might affect the delay timer *)
	activeProtocolPacketsByTeam=Download[runningBackloggedCompleted,
		Packet[DateStarted, DateConfirmed, DateEnqueued, Status, OperationStatus, Checkpoints, CheckpointProgress, Notebook],
		Cache -> inCache
	];

	(* get the packets for the "true" backlog (i.e. both from the Backlog field in input protocols' team, and from a paranoid Search) *)
	allBacklogPacketsByTeam=Map[
		Function[teamBacklog,
			Map[
				Function[protocol,
					SelectFirst[Flatten[{backloggedPacketsByTeam, activeProtocolPacketsByTeam}], MatchQ[Lookup[#, Object], protocol]&]
				],
				teamBacklog
			]
		],
		allBacklogProtocolsByTeam
	];

	(* create a list of completed and not compelted protocols index matched to input protocols *)
	completedProtocolPacketsByTeam=Map[
		Function[protocolPackets, Select[protocolPackets, MatchQ[Lookup[#, Status], Completed]&]],
		activeProtocolPacketsByTeam
	];
	nonCompletedProtocolPacketsByTeam=Map[
		Function[protocolPackets, Select[protocolPackets, MatchQ[Lookup[#, Status], Except[Completed]]&]],
		activeProtocolPacketsByTeam
	];

	(* collect timing info for all of the protocol in question:
		- openThreadProtocols that are being executed: look at RunTime (time left to finish) + whatever delay time there is left
		- openThreadProtocols that haven't started yet: look a RunTime (which should be everything since it hasn't started) + QueueTime (time it needs to wait before it starts) + whatever delay time there is left
		- backloggedProtocols: look at RunTime + QueueTime + whatever delay time there is left

		delay time -> time until we get the thread back that was taken up by this protocol
	*)

	(* split up all the protocols into groups based on where they are in their processing*)
	(* protocols that are in processing and are waiting to be started by an operator*)
	operatorStartPacketsByTeam=Map[
		Function[protocolPackets, Select[protocolPackets, MatchQ[Lookup[#, OperationStatus], OperatorStart]&]],
		nonCompletedProtocolPacketsByTeam
	];

	(* protocols that are in processing and are currently being ran in the lab*)
	processingPacketsByTeam=Map[
		Function[protocolPackets, Select[protocolPackets, MatchQ[{Lookup[#, Status], Lookup[#, OperationStatus]}, {Processing, Except[OperatorStart]}]&]],
		nonCompletedProtocolPacketsByTeam
	];

	(* put them all together*)
	flatNonCompletedProtocolPackets=DeleteDuplicatesBy[Flatten[{nonCompletedProtocolPacketsByTeam, allBacklogPacketsByTeam}], Lookup[#, Object]&];

	(* determine the run time for all the unfinished protocols *)
	runTimeLookup=Map[
		Lookup[#, Object] -> runTime[#, now]&,
		flatNonCompletedProtocolPackets
	];

	(* determine the queue time for all protocool that are not currently running *)
	packetsNeedingQueueTime=DeleteDuplicatesBy[Flatten[{operatorStartPacketsByTeam, allBacklogPacketsByTeam}], Lookup[#, Object]&];
	queueTimeLookup=Normal@AssociationThread[Lookup[packetsNeedingQueueTime, Object, {}], QueueTime[packetsNeedingQueueTime]];

	(* determine the delay time to free up a thread for all protocols (well get 0 back for any irrelevant things) *)
	flatAllProtocolPackets=DeleteDuplicates[Flatten[{activeProtocolPacketsByTeam, allBacklogPacketsByTeam}]];
	delayTimeLookup=DeleteCases[MapThread[
		{Lookup[#1, Object], #2}&,
		{flatAllProtocolPackets, threadReleaseTime[flatAllProtocolPackets, now]}
	], Except[{_, GreaterP[0 Minute]}]];

	(* prep timing info:
		we'll need the run time for protocols that are currently: processing, enqueued or in backlog
		we'll need the queue time for protocls that are: enqueud or in a backlog
		we'll need the delay time for protocols that are currently: processing, enqueued, backlogged OR completed in the time period we're working with
	 *)
	runningAndBackloggedProtocolsByTeam=MapThread[Lookup[Join[#1, #2, #3], Object, {}]&, {processingPacketsByTeam, operatorStartPacketsByTeam, allBacklogPacketsByTeam}];
	notRunningAndBackloggedProtocolsByTeam=MapThread[Lookup[Join[#1, #2], Object, {}]&, {operatorStartPacketsByTeam, allBacklogPacketsByTeam}];
	runningBackloggedCompleted=MapThread[Lookup[Join[#1, #2, #3], Object, {}]&, {processingPacketsByTeam, allBacklogPacketsByTeam, completedProtocolPacketsByTeam}];

	(* start the recursion here, individually for each protocol under consideration, this will break once the target protocol exits the backlog *)
	MapThread[
		timeTravel[#1, #2, #3, #4, #5, #6, #7, 0 Hour, #8]&,
		{
			Lookup[#, Object, {}]& /@ processingPacketsByTeam,
			Lookup[#, Object, {}]& /@ operatorStartPacketsByTeam,
			allBacklogProtocolsByTeam,
			Map[Function[{in}, Map[{#, Lookup[runTimeLookup, #]}&, DeleteDuplicates[in]]], runningAndBackloggedProtocolsByTeam],
			Map[Function[{in}, Map[{#, Lookup[queueTimeLookup, #]}&, DeleteDuplicates[in]]], notRunningAndBackloggedProtocolsByTeam],
			Table[delayTimeLookup, Length[myProtocols]],
			maxThreadsByTeam,
			myProtocols
		}
	]
];


(* ::Subsection::Closed:: *)
(*BacklogTime Helpers*)


(* ::Subsubsection::Closed:: *)
(*timeTravel*)


(*recursive function that steps through time increments until the target protocol is out of the backlog, return an approximate time to get to that point*)
(*
	first 3 inputs are the protocol that are
		a) processing,
		b) processing but not yet running,
		c) in backlog
	next 3 inputs are the timing information:
		d) how long each protocols will take to process (for a+b+c),
		e) how long each protocol will spend in the queue (for b+c)
		f) the delay time left on each protocol effect the thread count (for a+b+c PLUS any protocol that might have already finished but it's delay time is still running out)
	last 3:
		g) max number of threads usauble (so we don't go over)
		h) the total amount of time passed so far (starts at 0 Hour)
		i) the target protocol we're trying to push into processing
*)

(* base case that exits out of the function if the target is no longer there and returns the accrurued  time *)
timeTravel[_, _, _, _, _, _, _, total_, Null]:=Round[total, Minute];

(* recursive case *)
timeTravel[processing_, queue_, backlog_, processingTimes_, queueTimes_, delayTimes_, maxThreads_, total_, target:ObjectP[]]:=Module[{shortestProcessing, shortestProcessingProtocol, shortestProcessingTime, shortestQueue, shortestQueueProtocol, shortestQueueTime, shortestDelay, shortestDelayProtocol, shortestDelayTime, updateTimes, newProcessingTimes, newQueueTimes, newDelayTimes, newProcessing, newQueue, timeTravelTime, newBacklog, threadCount, finalThreadCount},

	(*first thing first, figure how how much time into the future we're going to be moving forward (and number of jiggawatts of power needed) *)
	(*this can happen for several reasons, and have different results, find the ones with the shortest time and resolve that one in this iteration (could be more then one per iteration)
		- a protocol finishes processing
			- if the delay timer on that protocol is also out, then we gain back a thread, which means a backlogged protocol can be promoted to queue
			- if the delay timer did not run out, then nothing else happens since there are no free threads
			- decrement appropriate timers
		- a protocol in delayTimes runs out (either a protocol that is still running at the time of this function being called OR one that has finished before this function call)
			- if the delay timer ran out on a protocol that is processing/in queue or backlogged, nothing else happens
			- if the delay timer ran out on a protocol that has been compleated, then we get back a thread
			- decrement appropriate timers
		- a protocol in queueuTimes runs out, that means it can be promoted to processing, but a thread is not freeded up
			- decrement appropriate timers
	*)

	(* find the protocol with the shortest processing time, shortest queue time and shortest delay time, if we get a null, then use a really really big number *)
	shortestProcessing=FirstOrDefault[SortBy[Cases[processingTimes, {Alternatives @@ processing, _}], Last]];
	shortestProcessingProtocol=If[NullQ[shortestProcessing], Null, shortestProcessing[[1]]];
	shortestProcessingTime=If[NullQ[shortestProcessing], Millennium, shortestProcessing[[2]]];

	shortestQueue=FirstOrDefault[SortBy[Cases[queueTimes, {Alternatives @@ queue, _}], Last]];
	shortestQueueProtocol=If[NullQ[shortestQueue], Null, shortestQueue[[1]]];
	shortestQueueTime=If[NullQ[shortestQueue], Millennium, shortestQueue[[2]]];

	shortestDelay=FirstOrDefault[SortBy[delayTimes, Last]];
	shortestDelayProtocol=If[NullQ[shortestDelay], Null, shortestDelay[[1]]];
	shortestDelayTime=If[NullQ[shortestDelay], Millennium, shortestDelay[[2]]];

	(* the time by which this iteration will fast forward, which is the shortest of the three *)
	timeTravelTime=Min[{shortestProcessingTime, shortestQueueTime, shortestDelayTime}];

	(* first check if any of the queued protocols can be promoted to processing, this will only happen if the shortest queue is not greater then the other two *)
	(* this will never free up a thread *)
	{newProcessing, newQueue}=If[
		And[shortestQueueTime <= shortestProcessingTime, shortestQueueTime <= shortestDelayTime],
		{Join[processing, {shortestQueueProtocol}], DeleteCases[queue, shortestQueueProtocol]},
		{processing, queue}
	];

	(* next check if any of the delay timers have run out on any of the protocols, this will only happen is the shortest delay is less or equal to the other two*)
	(* if it did, then remove that protocol from the list of delay timers *)
	(* if associated protocol does not appear in processing or queue, also give back a thread since the protocol has already finished and this was just running down the delay timer before giving back the thread *)
	(* assume we have zero free threads to begin with (why would you have a protocol in the backlog in the first place if you have threads) *)
	{newDelayTimes, threadCount}=If[And[shortestDelayTime <= shortestProcessingTime, shortestDelayTime <= shortestQueueTime],
		{
			DeleteCases[delayTimes, shortestDelay],
			If[!MemberQ[Flatten[{processing, queue}], shortestDelayProtocol], 1, 0]
		},
		{delayTimes, 0}
	];

	(* next check if any of the protocols can be completed, this will only happen if the shortest processing time is less or equal to the other two *)
	(* if the delay timer on this protocol has already ran down, then give back the thread (else it will be freed up in some future iteration when the delay timer for it runs down as well *)
	finalThreadCount=If[
		And[shortestProcessingTime <= shortestQueueTime, shortestProcessingTime <= shortestDelayTime],
		Module[{},
			(* remove the protocol from the processing timers since we're done with it *)
			newProcessing=DeleteCases[newProcessing, shortestProcessingProtocol];
			(*check if this protocol still has as delay timer, if it doesn't then give us back a thread, else do not*)
			If[!MemberQ[newDelayTimes[[All, 1]], shortestProcessingProtocol],
				threadCount + 1, threadCount
			]
		], threadCount
	];

	(* next check to see if there are any free threads, if yes then use them to promote protocols from the backlog to the queue *)
	{newQueue, newBacklog}=If[And[finalThreadCount > 0, Length[backlog] > 0],
		{
			Join[newQueue, First[PartitionRemainder[backlog, Min[{finalThreadCount, maxThreads}]]]],
			Flatten[Rest[PartitionRemainder[backlog, Min[{finalThreadCount, maxThreads}]]]]
		},
		{newQueue, backlog}
	];

	(* lastly update all the times by the amount traveled into the FUTURE!!!:
		- things in processing move forward (but not backlogged protocols (since they haven't started), or protocols in the queue (since they not started yet))
		- things in queue move forward (but not backlogged protocols since haven't started running)
		- things in delay move forward no matter what
		*)
	updateTimes[in_, excludeBacklog_, excludeQueue_]:=Map[
		If[Or[
			And[MemberQ[backlog, #[[1]]], excludeBacklog],
			And[MemberQ[queue, #[[1]]], excludeQueue]
		],
			{#[[1]], #[[2]]},
			If[(#[[2]] - timeTravelTime) <= 1 Minute,
				Nothing,
				{#[[1]], #[[2]] - timeTravelTime}]
		]&, in
	];

	(* back to the top with the updated values *)
	timeTravel[
		newProcessing,
		newQueue,
		newBacklog,
		updateTimes[processingTimes, True, True],
		updateTimes[queueTimes, True, False],
		updateTimes[newDelayTimes, False, False],
		maxThreads,
		total + timeTravelTime,
		(* change the target to Null if target has been removed from the backlog *)
		If[Not[MemberQ[newBacklog, target]], Null, target]
	]
];


(* ::Subsubsection::Closed:: *)
(*runTime*)


(* this helper takes in a protocol packet and estimates how much time there is left to finish running the protocol by looking the checkpointestimates and checkpointprogress*)
runTime[myProtocol:PacketP[], myNow:(_?DateObjectQ)]:=Module[
	{estimates, estimateTime, progress, progressTime, currentCheckpoint, currentCheckpointExpectedTime, currentCheckpointSpentTime, idealTimeToCurrentCheckpoint, currentCheckpointPosition, protocolStatus},

	protocolStatus=Lookup[myProtocol, Status];
	If[MatchQ[protocolStatus, Completed], Return[0 Hour]];

	(* pull out the checkpoint fields from the packet*)
	{estimates, progress}=Lookup[myProtocol, {Checkpoints, CheckpointProgress}];

	(*add up all the time to get the expected time for the protocol to run*)
	estimateTime=Total[estimates[[All, 2]]];

	(*if there are progress checkpoints, then grab the current checkpoint this is on, and if there aren't then just return the total expected time since it hasn't even started yet*)
	currentCheckpoint=If[MatchQ[progress, {}],
		Return[estimateTime],
		First[FirstCase[progress, {_, _, Null}]]
	];

	(* figure the position of the current checkpoint *)
	currentCheckpointPosition=Position[estimates, currentCheckpoint][[1]][[1]];

	(* figure out what would the expected time for that checkpoint be *)
	currentCheckpointExpectedTime=estimates[[currentCheckpointPosition]][[2]];

	(* get the expected time to finish all of the protocol to this checkpoint (NOT including itself) *)
	(* not sure if this is a ligit way of doing this, not including the current checkpoint because if this is stalled on the last step, you would get 0 so by not including it we're being more convervative*)
	idealTimeToCurrentCheckpoint=Total[Take[estimates, currentCheckpointPosition - 1][[All, 2]]];

	(* how much time has actually been spend on the current checkpoint*)
	currentCheckpointSpentTime=myNow - Last[progress][[2]];

	(* for the current checkpoint, check if it went over its alloted time, set it to time it would have taken to do the protocol up to the checkpoint prior, but if it's still processing and has not went over the its estimate, then take the difference of allotted time and how much time it has already spent on that checkpoint*)
	progressTime=If[currentCheckpointSpentTime > currentCheckpointExpectedTime,
		idealTimeToCurrentCheckpoint, currentCheckpointExpectedTime - currentCheckpointSpentTime
	];

	(* the time left on the protocol will be the total estimated time to run the protocol minus all time already spent on it *)
	estimateTime - progressTime
];


(* ::Subsubsection::Closed:: *)
(*threadReleaseTime*)


(* this helper determines how much time has to passed before the thread consumed by this protocol can be released *)
(* takes protocol(s) and returns time(s) *)
threadReleaseTime[{}, _]:={};

(* when given a single protocol, call the core listable version and return a single value*)
threadReleaseTime[myProtocol:PacketP[], myNow:(_?DateObjectQ)]:=First[threadReleaseTime[{myProtocol}, myNow]];

(* the core listable version*)
threadReleaseTime[myProtocols:{PacketP[]..}, myNow:(_?DateObjectQ)]:=With[
	(* pull out the confirmed date from all the protocol packets*)
	{startTimes=(Lookup[myProtocols, DateConfirmed])},

	(*map over all the DateConfirmed and:
		- if there is no DateConfirmed, then return $MinThreadRelease
		- if DateConfirmed-$MinThreadRelease is negative, then return 0 Hour
		- in all other cases, return DateConfirmed-$MinThreadRelease*)
	Map[
		If[NullQ[#], $MinThreadRelease, If[(myNow - #) > $MinThreadRelease, 0 Hour, $MinThreadRelease - (myNow - #)]]&,
		startTimes
	]
];


(* ::Section::Closed:: *)
(*syncBacklog*)


(* ::Subsection::Closed:: *)
(*syncBacklog Options and Messages*)


DefineOptions[syncBacklog,
	Options:>{
		{UpdatedBy:>$PersonID,ObjectP[{Object[User],Object[Protocol],Object[Qualification],Object[Maintenance]}],"Person or protocol responsible for setting the status of the protocols."},
		UploadOption,
		CacheOption,
		EmailOption
	}
];


(* ::Subsection::Closed:: *)
(*syncBacklog*)


(* Empty list case returns an empty list *)


(* Authors definition for ExperimentUtilities`Private`syncBacklog *)
Authors[ExperimentUtilities`Private`syncBacklog]:={"robert"};

syncBacklog[{},OptionsPattern[]]:={};


(* Singleton case returns singleton value *)
syncBacklog[myTeam:ObjectP[Object[Team,Financing]],myOptions:OptionsPattern[]]:=syncBacklog[{myTeam},myOptions];


(* List case *)
syncBacklog[myTeams : {ObjectP[Object[Team, Financing]]..}, myOptions : OptionsPattern[]] := Module[
	{
		safeOptions, upload, cache, updatedBy, emailOption, resolvedEmail, recentlyCompletedScriptProtocols, uploadProtocolStatusFields, allDownloads, recentlyCompletedScriptProtocolPackets, teamPackets, protocolPackets, queuePackets, newCache, availableThreads, scriptsStillProcessingPackets, nonBackloggedProtocols, notebooks, potentiallyMissingProtocolsFromBacklog, potentiallyMissingFromBacklogNotebooks, teamSortedPotentiallyMissingFromBacklog, missingProtocols, releasedProtocols, backlogUpdates, statusUpdateProtocols, statusUpdatePackets, allPackets
	},

	(* Get the safe options *)
	safeOptions = SafeOptions[syncBacklog, ToList[myOptions]];

	(* Extract out the option values *)
	{upload, cache, updatedBy, emailOption} = Lookup[safeOptions, {Upload, Cache, UpdatedBy, Email}];

	(* Resolve the email option *)
	resolvedEmail = If[
		MatchQ[emailOption, Automatic],
		upload,
		emailOption
	];

	(* Search for protocols that were recently completed and were part of a script *)
	recentlyCompletedScriptProtocols = Search[Object[Protocol], Status == Completed && DateCompleted > Now - 2Hour && Script != Null && Notebook != Null];

	(* These are fields we are caching for UploadProtocolStatus *)
	uploadProtocolStatusFields = {ShippingMaterials, OperationStatus, DeveloperObject, Author, Notebook, UserCommunications, DateEnqueued, DateStarted, SubprotocolRequiredResources, StartDate, Overclock};
	(* Download the financing teams of the user and the status of any backlogged protocols -- since is it important to have the newest cache, we are forcing its download *)
	allDownloads = Download[
		{
			myTeams,
			recentlyCompletedScriptProtocols
		},
		{
			{
				Packet[MaxThreads, NotebooksFinanced, Backlog],
				Evaluate[Packet[Backlog[Union[{Status, DateConfirmed, ParentProtocol}, uploadProtocolStatusFields]]]],
				Packet[Queue[{OperationStatus, Status, Overclock}]]
			},
			{Evaluate[Packet[DateCompleted, Script, Notebook, Sequence @@ uploadProtocolStatusFields]], Packet[Script[{CurrentProtocols, TimeConstraint, Notebook}]], Packet[Script[CurrentProtocols][{Status}]]}
		}
	];

	(* Split up the download packets for teams *)
	{teamPackets, protocolPackets, queuePackets} = Transpose[allDownloads[[1]]];
	recentlyCompletedScriptProtocolPackets = Flatten[allDownloads[[2]]];

	(* Prepare an updated cache *)
	newCache = Experiment`Private`FlattenCachePackets[{cache, allDownloads}];

	(* Find out how many threads there are available *)
	availableThreads = AvailableThreads[Lookup[teamPackets, Object], Cache -> newCache];

	(* Figure out which recently completed protocols from scripts still have their scripts processing. *)
	(* A script will still be processing if the CurrentProtocols field isn't filled out with non-completed protocols and *)
	(* we're still within our TimeConstraint. *)
	scriptsStillProcessingPackets = Function[recentlyCompletedScriptProtocol,
		Module[{recentlyCompletedScriptProtocolPacket, correspondingScript, correspondingScriptPacket, correspondingScriptCurrentProtocols, correspondingScriptCurrentProtocolPackets},

			(* Find the script protocol packet. Adding the Script -> _ to ensure the packet we found has Script key. *)
			(* Doing so because it's possible that we get duplicated protocol packets from Packet[DateCompleted, Script, Notebook, Sequence @@ uploadProtocolStatusFields] download and Packet[Script[CurrentProtocols][{Status}]] download, if any Script's CurrentProtocols is the same as the recently completed one *)
			recentlyCompletedScriptProtocolPacket = FirstCase[recentlyCompletedScriptProtocolPackets, KeyValuePattern[{Object -> ObjectP[recentlyCompletedScriptProtocol], Script -> _}]];

			(* Find the protocol's script *)
			correspondingScript = Lookup[recentlyCompletedScriptProtocolPacket, Script];

			(* Find the script packet *)
			correspondingScriptPacket = FirstCase[recentlyCompletedScriptProtocolPackets, KeyValuePattern[Object -> ObjectP[correspondingScript]]];

			(* Find the current protocols of the script *)
			correspondingScriptCurrentProtocols = Lookup[correspondingScriptPacket, CurrentProtocols];

			(* Find the packets of the current protocols *)
			correspondingScriptCurrentProtocolPackets = (FirstCase[recentlyCompletedScriptProtocolPackets, KeyValuePattern[Object -> ObjectP[#]]]&) /@ correspondingScriptCurrentProtocols;

			(* Determine if the script is still processing *)
			If[
				Or[
					(* One of the script's CurrentProtocols is still running. *)
					Length[Cases[correspondingScriptCurrentProtocolPackets, KeyValuePattern[Status -> Except[Completed]]]] > 0,
					MatchQ[
						Lookup[recentlyCompletedScriptProtocolPacket, DateCompleted] + ((Lookup[correspondingScriptPacket, TimeConstraint, Null] /. {Null -> 15Minute}) * 1.5),
						GreaterP[Now]
					]
				],
				correspondingScriptPacket,
				Nothing
			]
		]
	] /@ recentlyCompletedScriptProtocols;

	(* Check to see if there are any protocols in the backlog that are no longer backlogged, we'll remove those*)
	nonBackloggedProtocols = Lookup[Cases[Flatten[protocolPackets], KeyValuePattern[{Status -> Except[Backlogged]}]], Object, {}];

	(* Get the notebooks for each team *)
	notebooks = Download[Lookup[teamPackets, NotebooksFinanced], Object];

	(* Search for protocols that might potentially be missing from the backlog *)
	potentiallyMissingProtocolsFromBacklog = If[
		MatchQ[Flatten[notebooks], {}],
		{},
		Search[Object[Protocol], ParentProtocol == Null && Status == Backlogged, Notebooks -> Flatten[notebooks], PublicObjects -> False]
	];

	(* Download the notebooks of the protocols that are potentially missing from the backlogs *)
	potentiallyMissingFromBacklogNotebooks = Download[potentiallyMissingProtocolsFromBacklog, Notebook];

	(* Sort the missing backlogged protocols into teams *)
	teamSortedPotentiallyMissingFromBacklog = Map[First, Function[teamNotebooks, Select[Transpose[{potentiallyMissingProtocolsFromBacklog, potentiallyMissingFromBacklogNotebooks}], MemberQ[teamNotebooks, ObjectP[Last[#]]]&]] /@ notebooks, {2}];

	(* Check if any of the found protocols are missing from the downloaded backlog*)
	missingProtocols = MapThread[
		UnsortedComplement[#2, Lookup[#1, Object, {}]]&,
		{protocolPackets, teamSortedPotentiallyMissingFromBacklog}
	];

	(* If there is a backlog, and there are free thread, then grab as many protocols from the backlog as there are threads after removing any non backlogged protocol from the backlog treat each entry in a financing team's ScriptsProcessing field as a non-available thread because if the script creates a protocol we don't want its place in the queue taken*)
	releasedProtocols = MapThread[
		With[
			{
				backlog = DeleteCases[Lookup[#1, Backlog], ObjectP[nonBackloggedProtocols]],
				scriptsProcessing = Length[Cases[scriptsStillProcessingPackets, KeyValuePattern[Notebook -> ObjectP[Lookup[#1, NotebooksFinanced]]]]]
			},
			If[
				Or[
					MatchQ[backlog, {}],
					!MatchQ[#2 - scriptsProcessing, GreaterP[0]]
				],
				{},
				First[PartitionRemainder[backlog, #2 - scriptsProcessing]]]
		]&,
		{teamPackets, availableThreads}
	];

	(* Prepare updates to the backlog, remove any protocols from the backlog that are going to go into processing, but add in any found protocols that have backlogged status already not in the backlog *)
	{backlogUpdates, statusUpdateProtocols} = Transpose[
		MapThread[
			If[
				And[
					MatchQ[#2, {}],
					MatchQ[#3, {}]
				],
				{{}, {}},
				{
					<|
						Object -> Lookup[#1, Object],
						Replace[Backlog] -> Link[Flatten[{UnsortedComplement[DeleteCases[Lookup[#1, Backlog], ObjectP[nonBackloggedProtocols]], #2], #3}]]
					|>,
					#2
				}
			]&,
			{teamPackets, releasedProtocols, missingProtocols}
		]
	];

	(* Generate update packets for protocols that we are removing from the backlog *)
	statusUpdatePackets = ECL`InternalUpload`UploadProtocolStatus[Flatten[statusUpdateProtocols], OperatorStart, Upload -> False, UpdatedBy -> updatedBy, Email -> resolvedEmail];

	(* Combine all upload packets *)
	allPackets = Flatten[{backlogUpdates, statusUpdatePackets}];

	(* Upload if requested *)
	If[
		upload,
		DeleteDuplicates[Cases[Upload[allPackets], ObjectP[Object[Protocol]]]],
		allPackets
	]
];


(* ::Section::Closed:: *)
(*syncShippingMaterials*)


(* ::Subsection::Closed:: *)
(*syncShippingMaterials Options and Messages*)


DefineOptions[syncShippingMaterials,
	Options:>{
		{UpdatedBy:>$PersonID,ObjectP[{Object[User],Object[Protocol],Object[Qualification],Object[Maintenance]}],"Person or protocol responsible for setting the status of the protocols."},
		UploadOption,
		CacheOption,
		EmailOption
	}
];


Authors[syncShippingMaterials]:={"david.ascough", "dirk.schild", "steven"}; (*was paul*)

(* ::Subsection::Closed:: *)
(*syncShippingMaterials*)


(* Empty list case returns an empty list *)
syncShippingMaterials[{},OptionsPattern[]]:={};


(* Singleton case returns singleton value *)
syncShippingMaterials[myTeam:ObjectP[Object[Team,Financing]],myOptions:OptionsPattern[]]:=syncShippingMaterials[{myTeam},myOptions];


syncShippingMaterials[myTeams:{ObjectP[Object[Team,Financing]]..},myOptions:OptionsPattern[]]:=Module[
	{safeOptions,upload,cache,updatedBy,emailOption,resolvedEmail,notebooks,awaitingMaterialProtocols,uploadProtocolStatusFields,rawDownloads,downloads,newCache,updateTuples,protocolStatusPackets},
	
	(* Get the safe options *)
	safeOptions=SafeOptions[syncShippingMaterials,ToList[myOptions]];
	
	(* Extract out the option values *)
	{upload,cache,updatedBy,emailOption}=Lookup[safeOptions,{Upload,Cache,UpdatedBy,Email}];
	
	(* Resolve the email option *)
	resolvedEmail=If[
		MatchQ[emailOption,Automatic],
		upload,
		emailOption
	];
	
	(* Get all the notebooks for the team*)
	notebooks=Download[myTeams,NotebooksFinanced[Object]];

	(* Find all protocols with ShippingMaterials status	*)
	awaitingMaterialProtocols=If[
		MatchQ[Flatten[notebooks],{}],
		{},
		Search[Object[Protocol],ParentProtocol==Null&&Status==ShippingMaterials,Notebooks->Flatten[notebooks],PublicObjects->False]
	];
	
	(* These are fields we are caching for UploadProtocolStatus *)
	uploadProtocolStatusFields={Status,ParentProtocol,DateConfirmed,ShippingMaterials,OperationStatus,DeveloperObject,Author,Notebook,UserCommunications,DateEnqueued,DateStarted,SubprotocolRequiredResources,Subprotocols,StartDate,RequiredResources,Overclock};
	
	(* Download the status log and notebook of the protocols, and the status of the outstanding transactions -- since is it important to have the newest cache, we are forcing its download *)
	rawDownloads=Download[
		awaitingMaterialProtocols,
		{
			Evaluate[Packet[StatusLog,Notebook,Sequence@@uploadProtocolStatusFields]],
			Packet[ShippingMaterials[[All,1]][{Object,Status}]],
			(* Additional fields required for UploadProtocolStatus *)
			Packet[Repeated[Subprotocols][{ShippingMaterials,Status,OperationStatus,ParentProtocol,DeveloperObject,DateConfirmed,DateEnqueued,DateStarted,StartDate,RequiredResources}]]
		}
	];

	(* Separate key packets from those only needed for cache *)
	downloads=rawDownloads[[All,;;-2]];
	
	(* Prepare an updated cache *)
	newCache=Experiment`Private`FlattenCachePackets[{cache,rawDownloads}];
	
	(* Determine what status we need for each protocol *)
	updateTuples=Function[{protocolMaterialsTuple},
		Module[{protocolPacket,transactionPackets,protocol,statusLog,hasRan,allTransactionsReceived},
			
			(* Split up our tuple *)
			{protocolPacket,transactionPackets}=protocolMaterialsTuple;
			
			(* Lookup the protocol object and the status log *)
			{protocol,statusLog}=Lookup[protocolPacket,{Object,StatusLog}];
			
			(* Check if the protocol was started *)
			hasRan=MemberQ[statusLog[[All,2]],OperatorStart];
			
			(* Check if all the transactions have been received *)
			allTransactionsReceived=ContainsOnly[Lookup[transactionPackets,Status,{"Blocker"}],{Received}];
			
			(* Create {protocol,newStatus} tuples for each protocol we are removing from ShippingMaterials *)
			Which[
				
				(* If we cannot resume the protocol, skip *)
				!allTransactionsReceived,Nothing,
				
				(* If the transactions have been received but the protocol never ran, set it to OperatorStart *)
				!hasRan,{protocol,OperatorStart},
				
				(* If all transaction have been received and the protocol ran before, set it to OperatorReady *)
				True,{protocol,OperatorReady}
			]
		]
	]/@downloads;

	(* Create the upload packets for each protocol *)
	protocolStatusPackets=If[
		MatchQ[updateTuples,{}],
		{},
		ECL`InternalUpload`UploadProtocolStatus[Sequence@@Transpose[updateTuples],Upload->upload,Email->resolvedEmail,Cache->newCache]
	];
	
	(* Return our result *)
	If[
		upload,
		DeleteDuplicates[Cases[Upload[protocolStatusPackets],ObjectP[Object[Protocol]]]],
		protocolStatusPackets
	]
];


(* ::Section::Closed:: *)
(*PrioritizeBacklog*)


(* ::Subsection::Closed:: *)
(*PrioritizeBacklog Options and Messages*)


PrioritizeBacklog::InvalidProtocolStatuses="The protocols `1` do not have a Status of Backlogged. Backlog priority can only be set for Backlogged protocols. Please remove these protocols from the input.";
PrioritizeBacklog::MultipleFinancers="The input protocols have multiple financing teams. Please specify the backlog priority of protocols with the same financing team.";


(* ::Subsection::Closed:: *)
(*PrioritizeBacklog*)


(* Singleton overload *)


(* Authors definition for PrioritizeBacklog *)
Authors[PrioritizeBacklog]:={"robert"};

PrioritizeBacklog[myProtocol:ObjectP[ProtocolTypes[]]]:=PrioritizeBacklog[{myProtocol}];

(* Core listable overload *)
PrioritizeBacklog[myProtocols:{ObjectP[ProtocolTypes[]]...}]:=Module[
	{downloadTuples, statuses, financerPackets, nonBackloggedProtocols, uniqueFinancerPackets,
		financer, oldBacklog, newBacklog},

	(* Fetch status and financers for input protocols *)
	downloadTuples=Download[
		myProtocols,
		{
			Status,
			Packet[Notebook[Financers][Backlog]]
		},
		Cache -> Download
	];

	(* Extract statuses *)
	statuses=downloadTuples[[All, 1]];

	(* Extract financers packets *)
	financerPackets=downloadTuples[[All, 2]];

	(* Find any protocols that are not Backlogged *)
	nonBackloggedProtocols=PickList[myProtocols, statuses, Except[Backlogged]];

	(* Backlog priority cannot be set for protocols that are not backlogged.
	If an input protocol is not Backlogged, throw error. *)
	If[Length[nonBackloggedProtocols] > 0,
		Message[PrioritizeBacklog::InvalidProtocolStatuses, nonBackloggedProtocols];
		Return[$Failed]
	];

	(* Delete any duplicate financer packets *)
	uniqueFinancerPackets=DeleteDuplicates[Flatten[financerPackets], SameQ];

	(* All protocols to re-prioritize should have the same financer
	(otherwise the input list - prioritization - order would not make sense).
	Throw error and fail if there are multiple financers. *)
	If[Length[uniqueFinancerPackets] > 1,
		Message[PrioritizeBacklog::MultipleFinancers];
		Return[$Failed]
	];

	(* At this point, we know there is only a single financer. *)
	financer=Lookup[First[uniqueFinancerPackets], Object];

	(* Extract financer's backlog *)
	oldBacklog=Download[Lookup[First[uniqueFinancerPackets], Backlog], Object];

	(* Construct new backlog order by prepending myProtocols and removing them from existing backlog list *)
	newBacklog=Link[Join[myProtocols, DeleteCases[oldBacklog, ObjectP[myProtocols]]]];

	(* Create change packet to replace Backlog and Upload *)
	Upload[
		Association[
			Object -> financer,
			Replace[Backlog] -> newBacklog
		]
	]
];


(* ::Section::Closed:: *)
(*UploadProtocolPriority*)


DefineOptions[UploadProtocolPriority,
	Options :> {
		(* Note: We can't use the shared options here because we have to have Null defaults. *)
		{
			OptionName -> HoldOrder,
			Default -> Null,
			Description -> "Indicates if the queue position of this protocol should be strictly enforced, regardless of the available resources in the lab.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		{
			OptionName -> Priority,
			Default -> Null,
			Description -> "Indicates if (for an additional cost) this protocol will have first rights to shared lab resources before any standard protocols.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		{
			OptionName -> StartDate,
			Default -> Null,
			Description -> "The date at which the protocol will be targeted to start running in the lab. If StartDate->Null, the protocol will start as soon as possible.",
			AllowNull -> True,
			Category -> "General",
			Widget -> With[{now=Now},
				Widget[Type -> Date, Pattern :> GreaterP[now], TimeSelector -> True]
			]
		},
		{
			OptionName -> QueuePosition,
			Default -> Null,
			Description -> "The position that this protocol will be inserted in the Financing Team's experiment queue.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> Alternatives[First, Last]],
				Widget[Type -> Number, Pattern :> GreaterP[0]]
			]
		},
		UploadOption
	}
];

UploadProtocolPriority::ProtocolAlreadyStarted="The options Priority, StartDate, and HoldOrder cannot be changed once a protocol has already started running. Please only include protocols that have not started running.";

UploadProtocolPriority[myProtocol:ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}], myOptions:OptionsPattern[]]:=Block[{ECL`Web`$ECLTracing:=!MatchQ[ECL`$UnitTestObject, _ECL`Object]},ECL`Web`TraceExpression["UploadProtocolPriority",Module[
	{downloadSource, financingTeam, queue, protocolUpdatePacket, listedOptions, queueUpdatePacket, protocolStatus, operationStatus},

	(* due to a bug in $FastDownload we need to be safe here and drop potentially heavy fields like ResolvedOptions, UnresolvedOptions, Cache, Simulation *)
	downloadSource = If[MatchQ[myProtocol, PacketP[]],
		KeyDrop[myProtocol, {ResolvedOptions, UnresolvedOptions, Cache, Simulation}],
		myProtocol
	];

	(* Download the (first) financing team of the author and that team's current Queue. *)
	(* need to quiet Download::Part because if there is no FinancingTeam, then taking [[1]] is going to cause an error *)
	{financingTeam, queue, protocolStatus, operationStatus}=Quiet[
		Download[downloadSource,
			{
				Notebook[Financers][[1]],
				Notebook[Financers][[1]][Queue][Object],
				Status,
				OperationStatus
			}
		],
		{Download::MissingField, Download::Part}
	];

	listedOptions=SafeOptions[UploadProtocolPriority, ToList[myOptions]];

	(* The user cannot change the priority related fields once a protocol has started. *)
	If[(MatchQ[protocolStatus, Completed] || !MatchQ[operationStatus, Null | None | OperatorStart | $Failed]) && (!MatchQ[Lookup[listedOptions, Priority, Null], Null] || !MatchQ[Lookup[listedOptions, StartDate, Null], Null] || !MatchQ[Lookup[listedOptions, HoldOrder, Null], Null]),
		Message[UploadProtocolPriority::ProtocolAlreadyStarted];
		If[MatchQ[Lookup[listedOptions, Upload, True], True],
			Return[$Failed],
			Return[<|Object -> Download[myProtocol, Object]|>]
		];
	];

	(* Note: We don't upload a update packet if Priority\[Rule]Null. *)
	protocolUpdatePacket=<|
		Object -> Download[myProtocol, Object],

		If[!MatchQ[Lookup[listedOptions, Priority, Null], Null],
			Priority -> Lookup[listedOptions, Priority],
			Nothing
		],

		If[!MatchQ[Lookup[listedOptions, StartDate, Null], Null],
			StartDate -> Lookup[listedOptions, StartDate],
			Nothing
		],

		If[!MatchQ[Lookup[listedOptions, HoldOrder, Null], Null],
			HoldOrder -> Lookup[listedOptions, HoldOrder],
			Nothing
		]
	|>;

	(* If we weren't able to find a financing team, just return the protocol update packet. *)
	(* This is important for subprotocols because they shouldn't be added to the financing team's queue. *)
	If[!MatchQ[financingTeam, ObjectP[Object[Team, Financing]]],
		If[MatchQ[Lookup[listedOptions, Upload, True], True],
			Return[Upload[protocolUpdatePacket]],
			Return[protocolUpdatePacket]
		]
	];

	(* Note: We don't upload a update packet if QueuePosition\[Rule]Null. *)
	queueUpdatePacket=If[MatchQ[Lookup[listedOptions, QueuePosition, Null], Null],
		Nothing,
		Module[{filteredQueue, positionAsInteger, positionWithMax},
			(* Filter out our protocol object from the already existing queue. *)
			filteredQueue=Cases[
				(* Just in case protocol objects get erased. Without this, we'll get an object does not exist error when reuploading to the field since there's no backlink. *)
				PickList[queue, DatabaseMemberQ[queue]],
				Except[ObjectP[myProtocol]]
			];

			(* If our protocol object was in our previous queue, decrement the position. *)
			positionAsInteger=(Lookup[listedOptions, QueuePosition] /. {First -> 1, Null | Last -> (Length[filteredQueue] + 1)});
			positionWithMax=Clip[positionAsInteger, {1, Length[filteredQueue] + 1}];

			<|
				Object -> Download[financingTeam, Object],
				Replace[Queue] -> Link /@ Insert[
					filteredQueue,
					myProtocol,
					positionWithMax
				]
			|>
		]
	];

	If[MatchQ[Lookup[listedOptions, Upload, True], True],
		Upload[{protocolUpdatePacket, queueUpdatePacket}];

		myProtocol,
		{protocolUpdatePacket, queueUpdatePacket}
	]
]]];