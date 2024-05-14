(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ProtocolDelayTime*)


DefineOptions[ProtocolDelayTime,
	Options:>{
		{IncludeQueueDelay->True,BooleanP,"Indicates if the time spent waiting in the queue beyond the goal queue time should be included in the reported delay."}
	}
];

ProtocolDelayTime[protocol:(Null|ObjectP[]),ops:OptionsPattern[]]:=First[ProtocolDelayTime[{protocol},ops]];
ProtocolDelayTime[protocols:{(Null|ObjectP[])...},ops:OptionsPattern[]]:=Module[{safeOps,packets,times},
	safeOps=SafeOptions[ProtocolDelayTime,ToList[ops]];

	packets=If[MatchQ[protocols,{(Null|PacketP[]..)}],
		protocols,
		Download[protocols,Packet[Checkpoints,CheckpointProgress,DateStarted,DateEnqueued]]
	];

	times=Map[
		If[MatchQ[#,PacketP[]],
			Module[{progress,checkpoints,processingDelayTime,timeToStart,startDelayTime},

				(* Assume we finish the current checkpoint right now *)
				progress = Replace[Lookup[#,CheckpointProgress], Null -> Now, {2}];

				checkpoints = Lookup[#,Checkpoints];

				(* If we've started the protocol see if we're on track with checkpoint estimates *)
				processingDelayTime=If[MatchQ[{progress,checkpoints},{{__},{__}}],
					Module[{actualTime,expectedTime},
						(* How long have the finished checkpoints taken us? *)
						actualTime = Unitless[Total[progress[[All, 3]] - progress[[All, 2]]],Minute];

						(* How long should they have taken?  *)
						(* Checkpoints should include all checkpoints, but if Progress somehow has more, account for that *)
						expectedTime = (Total[Unitless[Take[checkpoints,UpTo[Length[progress]]][[All, 2]],Minute]]);

						(* Make sure we had the checkpoint info, and if we do figure out how on track we are *)
						(* If we're moving faster than expected don't let negative subtract from start delay *)
						If[MatchQ[{actualTime,expectedTime},{NumericP,NumericP}],
							(actualTime-expectedTime)/.(LessP[0] -> 0),
							0
						]
					],
					0
				];

				(* How long did it take us to start after the user submitted? *)
				timeToStart=(Lookup[#,DateStarted]/.(Null->Now))-Lookup[#,DateEnqueued];

				(* If we started sooner than the goal, don't include any delay time, but don't let negative subtract from checkpoint delays*)
				startDelayTime=If[MatchQ[Lookup[#,DateEnqueued],_DateObject],
					Unitless[(timeToStart-24 Hour),Minute]/.(LessP[0] -> 0),
					0
				];

				If[Lookup[safeOps,IncludeQueueDelay],startDelayTime,0] + processingDelayTime
			],
			(* Delay factor isn't relevant. Set to zero  *)
			0
		]&,
		packets
	];
	UnitScale[times*Minute]
];

(*
	 - safeDivide: Calls Divide, quieting divide by 0 errors and replacing those results with 'default'
		Inputs:
			numerator:ListableP[NumericP] - The numerator (top), can also be a list of numbers
			denominator:ListableP[NumericP] - The denominator (bottom), can also be a list of numbers
		Outputs:
			result:ListableP[NumericP] - The result of the division
*)
safeDivide[numerator_,denominator_,default_]:=Quiet[numerator/denominator,{Power::infy,Infinity::indet}]/.{Indeterminate->default,ComplexInfinity->default};


internalProtocolFrequencyTable[type:All|ListableP[Object[Qualification]|Object[Maintenance]]] := Module[
	{cleanedType, frequencyFunction, qualificationFrq, maintenanceFrq, frqs, frqsNonNull, expandedFrqs,
		namedFrqs, instances, effectiveNumber, effectiveDailyTotal, tableData},

(* Convert All and make sure we have a list *)
	cleanedType=ToList[type/.All->{Object[Qualification],Object[Maintenance]}];

	(* == Define Function: frequencyFunction (downloads qualification frequency from all targets) == *)
	frequencyFunction[protocolType_,field_]:=Module[{modelQuals, targets},
		modelQuals = Search[protocolType, Deprecated != True];

		targets = DeleteDuplicates[Download[modelQuals, Targets[Object]]];

		Download[Flatten[targets], {Object, Evaluate[field]}]
	];

	qualificationFrq=If[MemberQ[cleanedType,Object[Qualification]],
		frequencyFunction[Model[Qualification],QualificationFrequency],
		{}
	];

	maintenanceFrq=If[MemberQ[cleanedType,Object[Maintenance]],
		frequencyFunction[Model[Maintenance],MaintenanceFrequency],
		{}
	];

	frqs=Join[qualificationFrq,maintenanceFrq];

	frqsNonNull = Cases[frqs, {_, {{_, TimeP} ..}}];

	expandedFrqs = SortBy[Flatten[Map[Function[group, {#[[1]], group[[1]], #[[2]]} & /@ group[[2]]], frqsNonNull], 1], Last];

	namedFrqs = MapAt[NamedObject[#[Object]] &, MapAt[NamedObject[#[Object]] &, expandedFrqs, {All, 1}], {All, 2}];

	instances = Length[Search[Object @@ Drop[#, -1], Model == #]] & /@ (namedFrqs[[All, 2]]);

	effectiveNumber = (instances/namedFrqs[[All, 3]]);

	effectiveDailyTotal = ToString[Unitless[Convert[Total[effectiveNumber],1/Day]]]<>" per day";

	(* Multiple by 1 Mo to get rid of the 1/Mo unit *)
	tableData=DeleteDuplicates[Transpose[{namedFrqs, instances, effectiveNumber*1 Month}]];

	{
		effectiveDailyTotal,
		PlotTable[
			SortBy[Flatten /@ tableData, -Last[#] &],
			TableHeadings -> {None, {"Model", "Target", "Frequency", "Instances", "Effective No./Month"}}
		]
	}
];

blockedTicketProgression[startDay_DateObject,endDay_DateObject,interval:TimeP]:=Module[{dates,absoluteDates,tickets,ticketPackets,blockedTickets,
	ticketsInRange,maxTickets},

	(* Generate list of dates for our given range in steps of timeUnit *)
	dates=DateRange[DateObject[DayRound[startDay], {12, 0, 0}],DateObject[DayRound[endDay], {12, 0, 0}],interval];

	absoluteDates = AbsoluteTime/@dates;

	tickets = Search[Object[SupportTicket, Operations], DateCreated >= (startDay - 2 Month) && DateCreated <= endDay];

	ticketPackets=Download[tickets,Packet[DateCreated,BlockedLog]];

	(* Select all tickets created before now that are still blocked *)
	(* Note: If blocked status is toggling we may falsely count, but this is too rare to worry about *)
	blockedTickets=Map[
		Function[
			currentDate,
			Select[
				ticketPackets,
				And[
					Length[Lookup[#,BlockedLog]]>0,

					AbsoluteTime[Lookup[#,DateCreated]]<currentDate,

					(* Protocol was blocked before now *)
					MatchQ[AbsoluteTime[Lookup[#,BlockedLog][[1,1]]],LessP[currentDate]],
					MatchQ[Lookup[#,BlockedLog][[1,3]],True],

					Or[
						(* Protocol is still blocked *)
						Length[Lookup[#,BlockedLog]]==1,
						(* Protocol was unblocked after our date of interest *)
						MatchQ[AbsoluteTime[Lookup[#,BlockedLog][[-1,1]]],GreaterP[currentDate]] && MatchQ[Lookup[#,BlockedLog][[-1,3]],False]
					]
				]&
			]
		],
		absoluteDates
	];

	ticketsInRange=Length/@blockedTickets;

	maxTickets=Max[ticketsInRange];

	EmeraldDateListPlot[
		Transpose[{dates,ticketsInRange}],
		GridLines -> {None, {{0,Black},{5, Directive[Green, Thick]},{10, Directive[Red, Thick]}}},
		PlotLabel -> "Number of Protocols Actively Blocked",
		PlotRange -> {Automatic, {0, maxTickets}},
		DateTicksFormat -> {"MonthShort", "/", "DayShort"}
	]
];


(* -- Threads -- *)

totalThreads[startDate_DateObject]:=Module[{dates,ignoredTeams,financingTeams,threadChangeLogs,byTeam,teamThreads},

	(* Get the thread count every week *)
	dates = DateRange[startDate, Now, 1 Day];

	ignoredTeams = {
		Object[Team, Financing, "id:xRO9n3BGk896"],

		Object[Team, Financing, "id:Vrbp1jKj1bkx"], (* "User Training" - we decided since the customers getting trained always have threads that they aren't using we're effectively double-counting *)
		Object[Team, Financing, "id:XnlV5jK996AN"] (* "demo" - internal notebook used for test protocols for tutorial videos *)
	};

	(* Search for customer teams (site does not match ECL) *)
	(* Filter out the training team since it has a crazy number of threads that don't really get used *)
	financingTeams = DeleteCases[
		Search[Object[Team,Financing]],
		Alternatives@@ignoredTeams
	];

	(* Get all the changes made to threads for the last 5 years *)
	(* This is somewhat questionable since there could be even older threads, switch to Date download when we can *)
	threadChangeLogs = threadPages[financingTeams, Now - 5 Year];

	(* Group our change list by team *)
	byTeam = GatherBy[threadChangeLogs, Lookup[#,Object]&];

	(* For each team:
		for each date determine the number of threads the team had at that time *)
	teamThreads = teamThreadChanges[#, dates]&/@byTeam;

	(* Return coordinates *)
	Transpose[{dates,Total[teamThreads]}]
];

teamThreadChanges[teamLog_,dates_] := Module[
	{changeDates,offsetDates,threadsPerDateRange,threadsPerRequestedDates},

	(* Find all the change dates *)
	changeDates = Lookup[teamLog, Date];

	(* Find all the change dates *)
	offsetDates = Append[Rest[changeDates], Now];

	(* Process the data into {start date, end date, current threads} *)
	threadsPerDateRange = MapThread[
		{#1, #2, Lookup[Lookup[#3, Fields], MaxThreads]} &,
		{changeDates, offsetDates, teamLog}
	];

	(* For each date, find the number of threads available at that time *)
	threadsPerRequestedDates = Map[
		Function[
			date,
			SelectFirst[threadsPerDateRange, MatchQ[date,RangeP@@#[[1;;2]]]&,{Null,Null,0}]
		],
		dates
	];

	(* Get just the thread number *)
	threadsPerRequestedDates[[All,3]]
];

(* threadPages: Recursive function that keeps calling ObjectLog until it gets results up to start date *)
threadPages[financingTeams_,startDate_]:=Module[{pageCount,log},

	(* This is the current max ObjectLog will allow *)
	pageCount = 5000;

	(* Make our ObjectLog call *)
	log = ECL`ObjectLog[
		financingTeams,
		Fields -> MaxThreads,
		OutputFormat -> Association,
		MaxResults -> pageCount,
		StartDate -> (startDate),
		Order -> OldToNew
	];

	(* If we hit our max number of results, then there are still more out there *)
	(* We're getting results from oldest to newest *)
	(* So if we've hit our max, get additional results starting from the last date we received *)
	If[Length[log]==pageCount,
		DeleteDuplicates[Join[log,threadPages[financingTeams,Lookup[Last[log], Date]]]],
		log
	]
];


(* Operator Processing Hours *)
(*
	operatorTimeByDay: For a given type return the hours operators worked in protocols of that type between the given dates
	(original code provide by Kathryn)
*)
operatorTimeByDay[type_,startDate_,endDate_]:=Module[
	{activeOperators,protocolLog,durationOperators,oneDayList,onlyRecentLogs,eachLogWithDateRange,relevantLogsByDay,deletingOperatorDaysOff,
		allDatesAndTimesAndTypes,dateListAllPMQ,allDatesAllTypesOperatorHours, typeHours},

	activeOperators =Search[Object[User, Emerald, Operator],
		LastWorkDate >= startDate || LastWorkDate == Null
	];

	protocolLog = activeOperators[ProtocolLog];
	(*protocolLog = Global`protocolLog;*)
	durationOperators = activeOperators[LastWorkDate];

	(*get 1 day ranges for each query*)
	oneDayList=Table[DateObject[DateObject[startDate+i Day,"Day"],TimeObject[{4,00,00}]],{i,0,(endDate-startDate)/Day}];

	(*truncate logs so they're not as long*)
	onlyRecentLogs=Cases[#,{x_/;x>=First[oneDayList],_,_}]&/@protocolLog;

	(*correlate logs with the date starts - huge list*)
	eachLogWithDateRange=Distribute[{onlyRecentLogs,oneDayList},List];

	(*cut apart 1 day ranges for each operators' logs*)
	relevantLogsByDay=Cases[Cases[#[[1]],{x_/;x>= #[[2]],_,_}],{x_/;x<#[[2]]+1Day,_,_}]&/@eachLogWithDateRange;

	(*delete any empty lists (op didn't work that day)*)
	deletingOperatorDaysOff=DeleteCases[relevantLogsByDay,{}];

	(*gather PMQ times for all operators*)
	allDatesAndTimesAndTypes=timeInStatusByType[#]&/@deletingOperatorDaysOff;

	(*gather together PMQ for each date*)
	dateListAllPMQ=Merge[allDatesAndTimesAndTypes,Identity];

	(*total up PMQ each date*)
	allDatesAllTypesOperatorHours=Merge[#,Total]&/@dateListAllPMQ;

	(*get values out of the association so we can plot them*)
	typeHours=Map[
		Function[date,
			Module[{selectedData,dateHours},
				selectedData=KeySelect[allDatesAllTypesOperatorHours,MatchQ[#,DayRound[date]]&];
				dateHours=First[Values[selectedData],<||>];
				date->KeySelect[dateHours, MatchQ[#,TypeP[type]]&]
			]
		],
		oneDayList
	];

	KeyValueMap[{#1, Total[Values[#2]]/.(0->0 Hour)}&, Association[typeHours]]
];


timeInStatusByType[statusLog_]:=Module[
	{beginningOfDay,withBeginning,endOfDay,timeWaiting,correctedStatus,
	pos,dur,extracted,startStatus,endStatus,typePMQ,datePMQHours},

	(*Check last entry to see if it's Enter, if so, protocol likely still operator processing so should
	add a end of day Exit to sum up that time entry*)
	If[MatchQ[Last[statusLog],{_,Enter,_}],
		endOfDay=DateObject[DateObject[statusLog[[1,1]],"Day"]+1 Day,TimeObject[{4,00,00}]];
		correctedStatus=Append[statusLog,{endOfDay,Exit,statusLog[[-1,3]]}],

		(*if not a night shifter and it's an exit last, just reassign variable*)
		correctedStatus=statusLog
	];

	If[MatchQ[First[correctedStatus],{_,Exit,_}],
		beginningOfDay=DateObject[DateObject[statusLog[[1,1]],"Day"],TimeObject[{4,00,00}]];
		withBeginning=Prepend[correctedStatus,{beginningOfDay,Enter,statusLog[[1,3]]}],

		(*if not a night shifter and it's an exit last, just reassign variable*)
		withBeginning=correctedStatus
	];

	(*collecting positions of enters and exits *)
	pos=Position[withBeginning,{_,Enter,_}];
	dur=Flatten[{{#},{#+1}}&/@pos,2];
	extracted=Extract[withBeginning,dur];
	startStatus=extracted[[1;;-1;;2]][[All,1]];
	typePMQ=Download[extracted[[1;;-1;;2]][[All,3,1]],Type];
	endStatus=extracted[[2;;-1;;2]][[All,1]];
	timeWaiting=If[Length[startStatus]===1,
		Association[First[typePMQ]->UnitConvert[First[endStatus]-First[startStatus],Hour]],
		Association[#]&/@MapThread[#1->UnitConvert[(#2-#3),Hour]&,{typePMQ,endStatus,startStatus}]
	];

	datePMQHours=Association[DateObject[statusLog[[1,1]],"Day"]->timeWaiting];

	If[Length[#]>1,Merge[#,Total],#]&/@datePMQHours
]


(* ::Section:: *)

(* ::Subsection::Closed:: *)