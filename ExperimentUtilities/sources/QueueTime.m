(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*QueueTime*)


(* ::Subsubsection:: *)
(*QueueTime Options*)


DefineOptions[
	QueueTime,
	Options :> {
		CacheOption,
		FastTrackOption
	}
];


Experiment::NonProcessingProtocols="The input protocols `1` have already started in the lab; time can only be estimated for protocols that have not yet started in the lab. Please check the status of the input protocols.";
Experiment::NoQueueTimesReportFound="A Search call did not return any Object[Report, QueueTimes] objects for the time period since: `1`. Using default values.";


(* ::Subsubsection:: *)
(*QueueTime*)


(*  --- Overload 1: Single Protocol --- *)
QueueTime[prot:ObjectP[Object[Protocol]], ops:OptionsPattern[]]:=Module[
	{returnValue},

	(* pass the listed protocol to the core overload *)
	returnValue=QueueTime[{prot}, ops];

	(* return the first value unless the return value is a failure *)
	If[FailureQ[returnValue],
		returnValue,
		First[returnValue]
	]
];


(* --- Overload 2: Empty List --- *)
QueueTime[{}, ops:OptionsPattern[]]:={};


(* --- CORE FUNCTION: Multiple Protocols --- *)
QueueTime[myProtocols:{ObjectP[Object[Protocol]]..}, ops:OptionsPattern[]]:=Module[
	{
		safeOps, cache, fastTrack, now,
		dayReportObjects, weekReportObjects, monthReportObjects, reportObject, listedProtocolPackets, reportPacketLists, protocolPackets,
		latestReportPacket, nonProcessingProtocols, queueTimeLookup, avgProtQueueTime, minProtQueueTime, startingQueueTimeEstimates,
		alreadyElapsedQueueTimes, remainingQueueTimeEstimates
	},

	(* default all unspecified or incorrectly-specified options *)
	safeOps=SafeOptions[QueueTime, ToList[ops]];

	(* look up the options and set to local variables *)
	{cache, fastTrack}=Lookup[safeOps, {Cache, FastTrack}];

	(* set the current time to a local variable so that it stays constant for duration of evaluation *)
	now=Now;

	(* search for Object[Report,QueueTimes] in the last day, week or Month. This is because sometimes the nightly scripts do not run due to network 2.0 changes etc *)
	{
		dayReportObjects,
		weekReportObjects,
		monthReportObjects
	}=Search[
		{
			Object[Report, QueueTimes],
			Object[Report, QueueTimes],
			Object[Report, QueueTimes]
		},
		{
			DateCreated > (now - 25 Hour),
			DateCreated > (now - 1 Week),
			DateCreated > (now - 1 Month)
		},
		MaxResults -> 1
	];

	(* dayReportObjects takes priority over weekReportObjects which takes priority over monthReportObjects *)
	reportObject=Which[
		!MatchQ[dayReportObjects, {}], LastOrDefault[dayReportObjects],
		!MatchQ[weekReportObjects, {}], LastOrDefault[weekReportObjects],
		!MatchQ[monthReportObjects, {}], LastOrDefault[monthReportObjects],
		True, Null
	];

	(* if we're not on the FastTrack and reportObject is Null, then no Object[Report, QueueTimes] was found in last month. Return error *)
	If[!fastTrack && NullQ[reportObject],
		Message[Experiment::NoQueueTimesReportFound, DateString[(now - 1 Month)]]
	];

	If[NullQ[reportObject],
		(* if no report object, default to 24 hours *)
		24 Hour& /@ myProtocols,
		(* else calculate based on report queue times object *)
		(
			(* download call: protocol packets & team packets & report packets *)
			{
				listedProtocolPackets,
				reportPacketLists
			}=Download[
				{
					myProtocols,
					{reportObject}
				},
				{
					{Packet[DateEnqueued, Status, OperationStatus]},
					{Packet[DateCreated, ProtocolQueueTimes, AverageQueueTime, MinQueueTime]}
				},
				Cache -> cache
			];

			(* remove extra list inserted by Map threaded Download *)
			protocolPackets=Flatten[listedProtocolPackets];
			latestReportPacket=LastOrDefault[Flatten[reportPacketLists]];

			(* queueTimes is only sensible for protocols which haven't been started or canceled - get a list of the bad protocols *)
			nonProcessingProtocols=Select[
				protocolPackets,
				!MatchQ[Lookup[#, {Status, OperationStatus}], {Processing, OperatorStart} | {Backlogged, _}]&
			];

			(* if we're not on the FastTrack return message and failure *)
			If[!fastTrack && MatchQ[nonProcessingProtocols, {PacketP[Object[Protocol]]..}],
				Message[Experiment::NonProcessingProtocols, Lookup[nonProcessingProtocols, Object]];
				Return[$Failed]
			];


			(* get the protocol queue time statistics in association form*)
			queueTimeLookup=Association[Rule[#[[1]], #[[2]]]& /@ Lookup[latestReportPacket, ProtocolQueueTimes]];

			(* get the average protocol queue time across all protocols *)
			avgProtQueueTime=Lookup[latestReportPacket, AverageQueueTime];

			(* get the min protocol queue time *)
			minProtQueueTime=Lookup[latestReportPacket, MinQueueTime];

			(* calculate queue times for each input protocol *)
			startingQueueTimeEstimates=Map[
				Lookup[queueTimeLookup, Lookup[#, Type], avgProtQueueTime]&,
				protocolPackets
			];


			(* time already elapsed waiting in queue *)
			(* *)
			alreadyElapsedQueueTimes=Map[
				If[MatchQ[#, Null],
					0 Minute,
					now - #
				]&,
				Lookup[protocolPackets, DateEnqueued]
			];

			(* calculate the remaining queue time after taking into account the already elapsed time *)
			remainingQueueTimeEstimates=startingQueueTimeEstimates - alreadyElapsedQueueTimes;

			(* if the calculated time is small/negative, hedge our bets and give the min time *)
			UnitScale[Max[#1, minProtQueueTime]& /@ remainingQueueTimeEstimates]
		)
	]

];




