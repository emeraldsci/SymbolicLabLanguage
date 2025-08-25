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
];

OperationsStatisticsTrendsOutputP=Dataset|Plot|Export;
OperationsStatisticsTrendsP=Alternatives[
	Summary,
	QueueTime,
	TotalOperatorTime,
	TotalInstrumentTime,
	CycleTime,
	WaitingTime,
	TotalLeadTime,
	TotalTurnaroundTime,
	TotalCompletionTime,
	EffectiveTurnaroundTime,
	EffectiveCompletionTime,
	QueueTimesBreakdown,
	WaitingTimesBreakdown
];

WaitingTimeBreakdownStatisticsP=Alternatives[
	ShippingMaterials,
	InstrumentRepairs,
	ScientificSupport,
	OperatorReturn
];

QueueTimesBreakdownStatisticsP=OperatorStart;

SharedBreakdownStatisticsP=Alternatives[
	ResourceAvailability,
	MaterialsAvailability,
	ECLMaterialsAvailability,
	UserMaterialsAvailability,
	InstrumentAvailability
];

BreakdownStatisticsP=Alternatives[
	QueueTimesBreakdownStatisticsP,
	SharedBreakdownStatisticsP,
	WaitingTimeBreakdownStatisticsP
];

DefineOptions[OperationsStatisticsTrends,
	Options:>{
		{Site->$Site,ObjectP[Object[Container,Site]],"Indicate the ECL facility for which statistics are pulled."},
		{FinancingTeam->All,All|ObjectP[Object[Team,Financing]],"Indicate the customer or internal team for whom statistics are pulled."},
		{Radius->Automatic,Automatic|None|GreaterEqualP[0 Day],"The radius of time over which each protocol should find protocols to group with for smoothing. When radius is not specified and data is shown for a 1 week interval or smaller, radius is set to 1 day; for 1 month or smaller, radius is set to 3 days; otherwise radius is set to 1 week. Use Radius->None to display data with no smoothing done."},
		{OutputFormat->Plot,ListableP[OperationsStatisticsTrendsOutputP],"Indicates how results are returned. Dataset will provide the calculated values, Plot will display all values, Export will return a file with the calculated values."},
		{OperationsStatistics->Summary,ListableP[OperationsStatisticsTrendsP|BreakdownStatisticsP],"Indicates the specific calculations shown."},
		{ColumnDisplay->True,BooleanP,"Indicates if the outputs are displayed vertically rather than simply being returned in a list."}
	}
];

(*	Quantile[times,{0.5,0.68,0.95,0.997}];*)

OperationsStatisticsTrends::NoExperimentsFound="No `1` were completed in the provided time range. Please consider specifying a wider time range";
OperationsStatisticsTrends::NoDataFound="No data was found for `1`. This indicates that these values have not yet been calculated for the requested experiments or that there was an error determining these values.";

OperationsStatisticsTrends[inputTypes:(ListableP[TypeP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]]),startDate_DateObject,endDate_DateObject,ops:OptionsPattern[]]:=Module[
	{experimentTypes,safeOps,radiusRequest,radius,team,absoluteRadius,searchConditions,site,outputFormatRequest,outputFormat,columnDisplay,
	statToIncludeRequest,allStats,statisticsToInclude,statisticsFields,experimentInRadiusQ,secondsInDay,experimentPacketGroups,possiblePackets,
	allExperiments,experimentPackets,groupedPackets,completionDates,outputs,statisticsMissingData,finalStatsIncluded},

	experimentTypes=ToList[inputTypes];

	safeOps=SafeOptions[OperationsStatisticsTrends,ToList[ops]];
	{radiusRequest,site,team,statToIncludeRequest,outputFormatRequest,columnDisplay}=Lookup[
		safeOps,
		{Radius,Site,FinancingTeam,OperationsStatistics,OutputFormat,ColumnDisplay}
	];

	(* = Process/resolve options =*)

	outputFormat=ToList[outputFormatRequest];
	allStats=DeleteCases[ToList@@OperationsStatisticsTrendsP,Summary];

	statisticsToInclude=If[MatchQ[statToIncludeRequest,Summary],
		{QueueTime, TotalTurnaroundTime, EffectiveTurnaroundTime},
		ToList[statToIncludeRequest]
	];

	statisticsFields=Join[
		DeleteCases[statisticsToInclude,BreakdownStatisticsP],
		If[MemberQ[statisticsToInclude,BreakdownStatisticsP],{QueueTimesBreakdown,WaitingTimesBreakdown}, {}]
	];

	(* Resolve the radius to use for smoothing based on the total time period being plotted *)
	radius=Which[
		MatchQ[radiusRequest,None], 0 Minute,
		!MatchQ[radiusRequest,Automatic], radiusRequest,
		(endDate-startDate) < 1 Week, 1 Day,
		(endDate-startDate) < 1 Month, 3 Day,
		True, 1 Week
	];

	absoluteRadius=Unitless[radius,Second];

	(* Pull all the root experiments that are completed and completed during the provided span *)
	searchConditions=And[
		DateCompleted>=startDate,
		DateCompleted<=endDate,
		Status==Completed,
		Site==site,
		ParentProtocol==Null,
		If[MatchQ[team,All],
			True,
			Notebook[Financers]==team
		]
	];

	allExperiments=Search[experimentTypes, searchConditions];

	If[MatchQ[allExperiments,{}],
		Message[OperationsStatisticsTrends::NoExperimentsFound,StringRiffle[experimentTypes," or "]];Return[$Failed]
	];

	experimentPackets=Download[allExperiments,
		Evaluate@Packet[
			DateCompleted,
			QueueTime,
			Sequence@@statisticsFields
		]
	];

	(* == For each experiment, find all other experiments in its radius == *)
	(* If we did this naively we would be doing N^2 comparisons which is why we do all this complicated pregrouping *)

	(* = Define Function: experimentInRadiusQ = *)
	(*  For a given packet determine if it was completed within the same range as our currentPacket (within provided time radius) *)
	(* All calculations must be done using AbsoluteTime and we don't use patterns for speed *)
	experimentInRadiusQ[currentPacket_,comparisonPacket_]:=Module[{currentDateCompleted,currentMinDate,currentMaxDate,comparisonDate},
		currentDateCompleted=AbsoluteTime[Lookup[currentPacket,DateCompleted]];

		(* Get min and max dates in radius *)
		currentMinDate=currentDateCompleted-absoluteRadius;
		currentMaxDate=currentDateCompleted+absoluteRadius;

		comparisonDate=AbsoluteTime[Lookup[comparisonPacket,DateCompleted]];

		(* Check min <= comparison <= max. Use directly instead of RangeP for speed *)
		LessEqual[currentMinDate, comparisonDate] && GreaterEqual[currentMaxDate, comparisonDate]
	];

	(* Divide up packets so we can avoid doing too many comparisons when we are looking over a broad timescale *)
	secondsInDay = Unitless[1 Day, Second];
	experimentPacketGroups = GroupBy[experimentPackets, Floor[AbsoluteTime[Lookup[#,DateCompleted]], secondsInDay]&];

	(* For a given packet get experiment groups that are definitely in our radius and experiment groups that need checking *)
	possiblePackets[currentPacket_]:=Module[{currentDateCompleted,floorMinDate,floorMaxDate,middleValues},
		currentDateCompleted=AbsoluteTime[Lookup[currentPacket,DateCompleted]];

		(* Find the lowest and highest dates that are in the radius of our experiment *)
		(* Take Floor to figure out where these dates would fall in our experimentPacketGroups *)
		floorMinDate=Floor[currentDateCompleted-absoluteRadius,secondsInDay];
		floorMaxDate=Floor[currentDateCompleted+absoluteRadius,secondsInDay];

		(* Find any keys in our experimentPacketGroups that fall between our min and max groups *)
		(* Anything in these middle groups is already known to be within our currentPacket's radius *)
		(* When radius < secondsInDay then this will always be {} and we will need to check all values *)
		middleValues=If[Length[Range[floorMinDate,floorMaxDate,secondsInDay]]>2,
			Range[floorMinDate,floorMaxDate,secondsInDay][[2;;-2]],
			{}
		];

		{
			(* Packets known to be in group *)
			Flatten[Values[KeySelect[experimentPacketGroups,MatchQ[#,Alternatives@@middleValues]&]],1],

			(* Packets on the edges to check *)
			Flatten[Values[KeySelect[experimentPacketGroups,MatchQ[#,floorMinDate|floorMaxDate]&]],1]
		}
	];

	(* For every single protocol, we want to find all other protocols completed within its radius *)
	groupedPackets=Map[
		Function[
			packet,
			Module[{definitePackets,packetsToCheck},
				{definitePackets,packetsToCheck}=possiblePackets[packet];
				Join[
					definitePackets,
					Select[packetsToCheck, experimentInRadiusQ[packet,#]&]
				]
			]
		],
		experimentPackets
	];

	completionDates=Lookup[experimentPackets,DateCompleted];

	(* For each statistic (e.g. QueueTime, CycleTime, etc.) get requested outputs (plots, exported files, etc.) *)
	outputs = outputForStatistic[completionDates,groupedPackets,#,Null,experimentTypes,outputFormat]&/@statisticsToInclude;

	finalStatsIncluded = Flatten[
		Map[
			Switch[#,
				QueueTimesBreakdown|WaitingTimesBreakdown,
					Keys[FirstCase[Lookup[experimentPackets,#],_Association]],
				SharedBreakdownStatisticsP,
					{ToString[#]<>" before starting", ToString[#]<>" after starting"},
				_,
					#
			]&,
			statisticsToInclude
		],
		1
	];

	statisticsMissingData = PickList[finalStatsIncluded,outputs,{Null..}];

	Which[
		MatchQ[statisticsMissingData,{}],Null,
		MatchQ[statisticsMissingData,finalStatsIncluded],Return[(Message[OperationsStatisticsTrends::NoDataFound,"all statistics"];$Failed)],
		True,Return[(Message[OperationsStatisticsTrends::NoDataFound,StringRiffle[statisticsMissingData, ","]];$Failed)]
	];

	(* Group by output types (e.g. list of plots, list of files, etc.) *)
	If[columnDisplay,
		Column[Column/@Transpose[outputs]],
		Transpose[outputs]
	]
];

(* If we're fetching one our statistics that further breaks down the time it will be structured as a named single *)
(* We look-up this named single stat then call our main overload to pull out each individual time in the breakdown field *)
(* We may also have a request for a specific key inside the named single and so we lookup just that value *)
outputForStatistic[dates:{_DateObject..},groupedPackets:{{PacketP[]...}...},statistic:(QueueTimesBreakdown|WaitingTimesBreakdown|QueueTimesBreakdownStatisticsP|WaitingTimeBreakdownStatisticsP),Null,experimentTypes:{TypeP[]..},outputFormat:{OperationsStatisticsTrendsOutputP..}]:=Module[
	{parentStatistic,groupedValues,innerStatistics},

	(* Figure out the named multiple field we're interested in - may have been given a key in the named multiple *)
	parentStatistic=Switch[statistic,
		QueueTimesBreakdown|WaitingTimesBreakdown, statistic,
		QueueTimesBreakdownStatisticsP, QueueTimesBreakdown,
		WaitingTimeBreakdownStatisticsP, WaitingTimesBreakdown
	];

	(* Get the value of our statistic - e.g. {{queue times for group 1}, {queue times for group 2}, ...} *)
	groupedValues = Map[Lookup[#,parentStatistic,{}]&,groupedPackets];

	(* These breakdown fields are named-singles - get the names of all the keys if the entire breakdown was requested *)
	(* Otherwise we want just one key in the named-single *)
	innerStatistics = If[MatchQ[statistic,QueueTimesBreakdown|WaitingTimesBreakdown],
		Keys[FirstCase[groupedValues[[1]],_Association]],
		{statistic}
	];

	Sequence@@(outputForStatistic[dates,groupedValues,#,statistic,experimentTypes,outputFormat]&/@innerStatistics)
];

(* If we get a request for one of the keys that exists in QueueTimesBreakdown and WaitingTimesBreakdown then we will look up both named single fields *)
(* Then extract requested key and we will show for both *)
outputForStatistic[dates:{_DateObject..},groupedPackets:{{PacketP[]...}...},statistic:SharedBreakdownStatisticsP,Null,experimentTypes:{TypeP[]..},outputFormat:{OperationsStatisticsTrendsOutputP..}]:=Module[
	{groupedQueueValues,groupedWaitingValues},

	groupedQueueValues = Map[Lookup[#,QueueTimesBreakdown,{}]&,groupedPackets];
	groupedWaitingValues = Map[Lookup[#,WaitingTimesBreakdown,{}]&,groupedPackets];

	Sequence@@{
		outputForStatistic[dates, groupedQueueValues, statistic, QueueTimesBreakdown, experimentTypes, outputFormat],
		outputForStatistic[dates, groupedWaitingValues, statistic, WaitingTimesBreakdown, experimentTypes, outputFormat]
	}
];

outputForStatistic[dates:{_DateObject..},groupedPackets:{{(PacketP[]|_Association|Null)...}...},statistic_Symbol,breakdownField_Symbol,experimentTypes:{TypeP[]..},outputFormat:{OperationsStatisticsTrendsOutputP..}]:=Module[
	{groupedTimes,means,stds1,stds2,stds3,dataSets,cleanedDataSets,statisticName,sharedBreakdownFields,outputRules},

	(* Get the value of our statistic - e.g. {{queue times for group 1}, {queue times for group 2}, ...} *)
	groupedTimes = Map[
		Function[packets,
			Map[
				If[!MatchQ[#,Null],
					Lookup[#,statistic],
					Null
				]&,
				packets
			]
		],
		groupedPackets
	];

	(* Calculate mean and successive standard deviations for each individual group *)
	(* Reform into a list of all means, all standard deviations, etc. *)
	{means,stds1,stds2,stds3} = Transpose[trendOperationsData/@groupedTimes];

	(* Reformat as sets of coordinates *)
	dataSets = Sort[Transpose[{dates,#}]]&/@{means,stds1,stds2,stds3};

	(* Remove any cases where Mean/Std couldn't be calculated (no data available) *)
	cleanedDataSets = Map[DeleteCases[#,{_,Null}]&,dataSets];

	(* Return early if we didn't find any data *)
	If[MatchQ[cleanedDataSets,{{}..}],
		Return[ConstantArray[Null,Length[outputFormat]]]
	];

	(* breakdownField tells us if we are looking at values in one of our breakdown fields *)
	sharedBreakdownFields = (ResourceAvailability | MaterialsAvailability | ECLMaterialsAvailability | UserMaterialsAvailability | InstrumentAvailability);
	statisticName = Switch[{breakdownField,statistic},
		{Null, _}, ToString[statistic],
		{QueueTimesBreakdown, sharedBreakdownFields}, ToString[statistic] <> " before starting",
		{WaitingTimesBreakdown, sharedBreakdownFields}, ToString[statistic] <> " after starting",
		_, ToString[statistic]
	];

	outputRules = {
		Dataset -> cleanedDataSets[[1]],
		Plot :> Grid[
			{
				{Style[statisticName<>" for "<>StringRiffle[ToList[experimentTypes]," and "],Bold,Gray,FontFamily -> "Arial", FontSize -> 14]},
				{
					Grid[{{
						operationsStatisticsPlot[{cleanedDataSets[[1]]}],
						If[MatchQ[cleanedDataSets,{_,{}..}],
							Nothing,
							operationsStatisticsPlot[cleanedDataSets,Legend->{"Mean","+1std","+2std","+3std"}]
						]
					}}]
				}
			}
		],
		Export :> Module[{averagedData,formattedData,timeStampString,experimentTypesString,fileName},
			averagedData=cleanedDataSets[[1]];
			formattedData=Map[
				{DateString[#[[1]],{"Month", "/", "DayShort", "/", "Year", " ", "Hour24", ":", "Minute", ":", "Second"}],Round[Unitless[#[[2]],Hour],0.001]}&,
				averagedData
			];

			timeStampString=StringReplace[DateString[], {" " -> "_", ":" -> "_"}];
			experimentTypesString=StringRiffle[StringRiffle[List @@ #, "-"]&/@ToList[experimentTypes], "_"];

			fileName=StringReplace[statisticName<>"_"<>experimentTypesString<>"_"<>timeStampString<>".csv"," "->"_"];

			Export[fileName,Prepend[formattedData,{"Date","Time (hrs)"}]]
		]
	};

	outputFormat/.outputRules
];

trendOperationsData[dataSet:{(Null|TimeP)...}]:=Module[{cleanedData, mean,std},
	cleanedData=DeleteCases[dataSet,Null];

	If[MatchQ[cleanedData,{}],
		Return[{Null,Null,Null,Null}]
	];

	mean=Mean[cleanedData];

	If[Length[cleanedData]<2,
		Return[{mean,Null,Null,Null}]
	];

	std=StandardDeviation[cleanedData];

	{mean,mean+std,mean+2*std,mean+3*std}
];

DefineOptions[
	operationsStatisticsPlot,
	Options:>{
		{TargetValue -> None, None | TimeP, "Indicates the value of the horizontal goal to draw across the plot."},
		{StatisticName -> None, None | _Symbol,"Indicates the name of the statistic being plotted."},
		{ProtocolType -> None, None | ListableP[TypeP[]],"Indicates the protocol type for which data is plotted."},
		{Legend -> None, _, "Labels for each set of coordinates being plotted."}
	}
];

operationsStatisticsPlot[coordinates_,ops:OptionsPattern[]]:=Module[{safeOps,targetValue,statisticName,protocolType,
	legend,coordinateColors,dates},

	safeOps=SafeOptions[operationsStatisticsPlot,ToList[ops]];

	{targetValue,statisticName,protocolType,legend}=Lookup[safeOps,{TargetValue,StatisticName,ProtocolType,Legend}];

	coordinateColors=Take[{Blue,Lighter[Blue],Lighter[Lighter[Blue]],Lighter[Lighter[Lighter[Blue]]]},Length[coordinates]];

	dates=coordinates[[1,All,1]];

	EmeraldDateListPlot[
		coordinates,
		{
			PlotRange->{{Min[dates],Max[dates]},{0 Hour, Max[DeleteCases[coordinates[[-1,All,2]],Null]]}},
			ImageSize->Large,
			Frame->{True,True,False,False},
			Filling->Bottom,
			If[!MatchQ[statisticName,None] && !MatchQ[protocolType,None],
				PlotLabel->Style[statisticName<>"\nfor "<>StringRiffle[ToList[protocolType]," and "],Bold,Gray,14],
				Nothing
			],
			If[!MatchQ[statisticName,None],
				FrameLabel->{None,Style[statisticName,Bold,Gray,14]},
				Nothing
			],
			PlotStyle->coordinateColors,
			If[MatchQ[targetValue,TimeP],
				Prolog->{Red,Line[{{coordinates[[1,1,1]]-Year,Unitless[targetValue,Hour]},{coordinates[[1,-1,1]]+Year,Unitless[targetValue,Hour]}}]},
				Nothing
			],
			If[!MatchQ[legend,None],
				Legend -> legend,
				Nothing
			],
			TargetUnits->{Automatic,Hour}
		}
	]
];


DefineOptions[UploadOperationsStatistics,
	Options:>{
		{Upload->True,BooleanP,"Indicates if calculated operations statistics are populated or if change packets are returned."},
		{Debug->False,BooleanP,"Indicates if any errors during calculations are surfaced. When Debug->False, any nonsense values will not be calculated",Category->Hidden}
	}
];

UploadOperationsStatistics::UnexpectedCalculation="The `1` for `2` was calculated as `3` however this is expected to be a positive time. Please check to see if the StatusLog or Date fields have been manually changed.";
UploadOperationsStatistics::UnexpectedComparison="For `1`, the following conditions were not met\t\n`2`\n\nPlease check to see if the StatusLog or Date fields have been manually changed.";
UploadOperationsStatistics::ProtocolsIgnored="Operations statistics are only calculated for Completed RootProtocols with status logs. The following protocols will not be updated `1`. Please make sure you're providing a list of parent protocols that have run in the lab.";

UploadOperationsStatistics[ops:OptionsPattern[]]:=Module[{recentProtocols},
	(* Find recently completed protocols in need of updating (using CycleTime as a proxy since all stats are updated together) *)
	(* Currently this is in the 4 hr script. We look within the last 3 days just in case something when wrong with that script for a period *)
	recentProtocols = Search[{Object[Protocol],Object[Maintenance],Object[Qualification]},
		And[
			ParentProtocol == Null,
			CycleTime == Null,
			Status == Completed,
			DateCompleted > Now - 3 Day]
	];

	If[MatchQ[recentProtocols,{}],
		Return[{}]
	];

	UploadOperationsStatistics[recentProtocols,ops]
];

UploadOperationsStatistics[protocol:ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}],ops:OptionsPattern[]]:=UploadOperationsStatistics[{protocol},ops];

UploadOperationsStatistics[protocols:{ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]..},ops:OptionsPattern[]]:=Module[
	{safeOps,upload,debug,protocolPackets,ticketPackets, validProtocolBool, invalidProtocolPackets,validTicketPackets, validProtocolPackets,uploadPackets},

	safeOps=SafeOptions[UploadOperationsStatistics,ToList[ops]];
	{upload,debug}=Lookup[safeOps,{Upload,Debug}];

	{protocolPackets, ticketPackets} = Transpose[
		Quiet[
			Download[protocols,
				{
					Packet[
						Status,
						DateRequested,
						DateConfirmed,
						DateEnqueued,
						DateStarted,
						DateCompleted,
						StatusLog,
						ReadyCheckLog,
						ParentProtocol,

						(* Fields ParseLog will always try to download and complain about if not in packet *)
						Deprecated,
						DateRetired,
						DateDiscarded,

						(* Fields to support ticket timing *)
						CompletedTasks
					],
					Packet[InternalCommunications[CreatedBy, DateCreated, StatusLog]]
				}
			],
			Download::FieldDoesntExist
		]
	];

	(* Only operate on complete protocols - if any of these conditions are met, the protocol is invalid *)
	validProtocolBool=Map[
		Or[
			!MatchQ[Lookup[#, DateCompleted], _?DateObjectQ],
			!MatchQ[Lookup[#,Status],Completed],
			!MatchQ[Lookup[#,ParentProtocol],Null],
			MatchQ[Lookup[#,StatusLog], {}]
		]&,
		protocolPackets
	];
	validProtocolPackets=PickList[protocolPackets,validProtocolBool, False];
	validTicketPackets=PickList[ticketPackets, validProtocolBool, False];
	invalidProtocolPackets=Complement[protocolPackets,validProtocolPackets];

	If[!MatchQ[invalidProtocolPackets,{}] && debug,
		Message[UploadOperationsStatistics::ProtocolsIgnored,Lookup[invalidProtocolPackets,Object]]
	];

	uploadPackets=MapThread[calculateOperationsStatistics[#1,#2, safeOps]&, {validProtocolPackets, validTicketPackets}];

	If[upload,
		Upload[uploadPackets],
		uploadPackets
	]
];

DefineOptions[calculateOperationsStatistics,
	SharedOptions:>{UploadOperationsStatistics}
];

calculateOperationsStatistics[protocolPacket:PacketP[{Object[Protocol],Object[Maintenance],Object[Qualification]}], ticketPackets:{PacketP[Object[SupportTicket, Operations]]...},ops:OptionsPattern[]]:=Module[{
	debug,startDate,statusTimesAfterStarting,queueTime,operatorTime,
	cycleTime,waitingTime,initialQueueTimesBreakdown,queueTimesBreakdown,operationConstraintTime, waitingTimesBreakdown,
	totalLeadTime,totalTurnaroundTime,totalCompletionTime,nonProcessingTime,effectiveTurnaroundTime,effectiveCompletionTime,
	safeValue,orderedValues,comparisonDescriptions,roundTime,problematicComparisons,problematicMessage, instrumentTime},

	debug=Lookup[ops,Debug];

	(* We define waiting times to be times when protocol is out of operations hands _after_ it has started so consider only log for this period  *)
	startDate=Lookup[protocolPacket,DateStarted];
	statusTimesAfterStarting = ParseLog[protocolPacket,StatusLog,StartDate->startDate];

	queueTime = protocolQueueTime[protocolPacket];
	operatorTime = protocolOperatorTime[statusTimesAfterStarting];
	instrumentTime = protocolInstrumentTime[statusTimesAfterStarting];
	cycleTime = protocolCycleTime[statusTimesAfterStarting];
	waitingTime = protocolWaitingTime[statusTimesAfterStarting];

	initialQueueTimesBreakdown=readyCheckWaitingTimesStart[protocolPacket];
	queueTimesBreakdown=KeyDrop[initialQueueTimesBreakdown,ReadyCheckFalse];

	{operationConstraintTime, waitingTimesBreakdown} = protocolWaitingTimeBreakdown[protocolPacket,ticketPackets, statusTimesAfterStarting];

	totalLeadTime = protocolTotalLeadTime[protocolPacket];
	totalTurnaroundTime = protocolTotalTurnaroundTime[protocolPacket];
	totalCompletionTime = protocolTotalCompletionTime[protocolPacket];

	(* Calculate times where protocol was entirely out of operations queue after starting *)
	nonProcessingTime = Total[Values[KeyTake[statusTimesAfterStarting,$NonProcessingStatuses]]];

	effectiveTurnaroundTime = totalTurnaroundTime - nonProcessingTime;
	effectiveCompletionTime = totalCompletionTime - nonProcessingTime;

	(* ==== Error Checking Post Calculation ==== *)

	(* Define lists of times which should be increasing based on the definitions of the stats *)
	(* e.g. QueueTime is included in TotalTurnaroundTime so QueueTime should be less than TotalTurnaroundTime *)
	orderedValues =	{
		{queueTime,totalTurnaroundTime},
		{operatorTime,cycleTime,totalCompletionTime},
		{operationConstraintTime, waitingTime},
		{waitingTime,totalCompletionTime},
		{totalCompletionTime,totalTurnaroundTime,totalLeadTime},
		{effectiveCompletionTime, effectiveTurnaroundTime},
		{effectiveCompletionTime, totalCompletionTime},
		{effectiveTurnaroundTime, totalTurnaroundTime}
	};

	comparisonDescriptions = {
		"QueueTime < TotalTurnaroundTime",
		"OperatorTime <= CycleTime < TotalCompletionTime",
		"OperationConstraintTime <= WaitingTime",
		"WaitingTime < TotalCompletionTime",
		"TotalCompletionTime <= TotalTurnaroundTime <= TotalLeadTime",
		"EffectiveCompletionTime <= EffectiveTurnaroundTime",
		"EffectiveCompletionTime <= TotalCompletionTime",
		"EffectiveTurnaroundTime <= TotalTurnaroundTime"
	};

	(* Make sure our groups of time are all less than/equal to each other *)
	(* Things like {60 Minute, 1 Hour} confuse OrderedQ so remove units before comparison *)
	(* If we got any negative numbers we'll complain about those later, so remove for now *)
	roundTime = 0.001;
	problematicComparisons = MapThread[
		Function[{valueList,description},
			If[
				OrderedQ[Cases[Round[Unitless[#,Hour],roundTime]&/@valueList,GreaterEqualP[0]]],
				Nothing,
				description
			]
		],
		{orderedValues,comparisonDescriptions}
	];

	problematicMessage = StringRiffle[problematicComparisons,"\t\n"];

	(* It's possible to see errors if someone has manually messed with the Date fields or the StatusLog instead of using UploadProtocolStatus which updates both *)
	(* In this case we don't want to populate anything since things are pretty messed up *)
	If[!MatchQ[problematicComparisons,{}],
		(
			If[debug,
				Message[UploadOperationsStatistics::UnexpectedComparison,ToString[Lookup[protocolPacket,Object],InputForm],problematicMessage]
			];
			Return[Nothing]
		)
	];

	(* == Define Function: safeValues == *)
	(* Sanitize calculated values in case any of our calculations produced unexpected results *)
	(* Given a packet or named multiple check all values were calculated as positive numbers *)
	safeValues[packet_Association]:=Association@KeyValueMap[
		With[{roundedValue = safeValue[#1,#2]},
			(* Keep value to avoid messing up named single fields *)
			If[MatchQ[roundedValue,$Failed],
				#1->Null,
				#1->roundedValue
			]
		]&,
		packet
	];

	safeValue[symbol_,value_]:=Which[
		MatchQ[value,_Association], safeValues[value],
		MatchQ[value,0], 0 Hour,
		MatchQ[value,GreaterEqualP[0 Minute]],
			Round[value,roundTime Hour],
		MatchQ[value,ObjectP[]],
			value,
		True,
			(
				If[debug,
					Message[UploadOperationsStatistics::UnexpectedCalculation,symbol/.Replace[x_]:>x,ToString[Lookup[protocolPacket,Object],InputForm],value]
				];
				$Failed
			)
	];

	safeValues[<|
		Object->Lookup[protocolPacket,Object],
		QueueTime -> queueTime,
		Replace[QueueTimesBreakdown] -> queueTimesBreakdown,
		TotalOperatorTime -> operatorTime,
		TotalInstrumentTime -> instrumentTime,
		CycleTime -> cycleTime,
		WaitingTime -> waitingTime,
		Replace[WaitingTimesBreakdown] -> waitingTimesBreakdown,
		OperationConstraintTime -> operationConstraintTime,
		TotalLeadTime -> totalLeadTime,
		TotalTurnaroundTime -> totalTurnaroundTime,
		TotalCompletionTime -> totalCompletionTime,
		EffectiveTurnaroundTime -> effectiveTurnaroundTime,
		EffectiveCompletionTime -> effectiveCompletionTime
	|>]
];

(* Define out-of-operations queue statuses *)
$NonProcessingStatuses={RepairingInstrumentation, ShippingMaterials};



(* ::Subsection::Closed:: *)
(* queueTime *)


protocolQueueTime[protocol:PacketP[]]:=Module[{},
	protocolDateDifference[protocol,DateEnqueued,DateStarted]
];



(* ::Subsection::Closed:: *)
(* protocolOperatorTime *)


protocolOperatorTime[parsedLog_]:=Module[{},

	(* Account for unexpected case where protocol is not processed by an operator at all - might be true for automated freezer quals and the like  *)
	Lookup[parsedLog,OperatorProcessing,0 Hour]
];


(* ::Subsection::Closed:: *)
(* protocolInstrumentTime *)


protocolInstrumentTime[parsedLog_]:=Module[{},
	(* Account for unexpected case where protocol is not processed by an instrument at all  *)
	Lookup[parsedLog,InstrumentProcessing,0 Hour]
];


(* ::Subsection::Closed:: *)
(* cycleTime *)


protocolCycleTime[parsedLog_]:=Module[{},

	(* Account for unexpected case where protocol is not processed by an operator, instrument at all - might be true for automated freezer quals and the like  *)
	Replace[Total[Lookup[parsedLog,{InstrumentProcessing,OperatorProcessing},0 Hour]], {0->0 Hour}]
];



(* ::Subsection::Closed:: *)
(* waitingTime *)


protocolWaitingTime[parsedLog_]:=Module[{nonProcessingTimes},

	nonProcessingTimes = KeyTake[parsedLog,Join[$NonProcessingStatuses,{ScientificSupport,OperatorReady}]];

	(* If everything went perfectly and there was no waiting, we'll get Total[{}] which is 0 *)
	Replace[Total[Values[nonProcessingTimes]],{0->0 Hour}]
];


(* ::Subsection::Closed:: *)
(* waitingTime breakdown *)


protocolWaitingTimeBreakdown[protocolPacket:PacketP[],ticketPackets:{PacketP[Object[SupportTicket, Operations]]...},parsedLog_]:=Module[{initialReadyCheckWaitingTimesBreakdown,
	readyCheckWaitingTimesBreakdown,readyCheckOperationConstraint,sciSupportTime,shippingMaterialsTime,
	repairingInstrumentationTime,operationConstraintTime,waitingTimesBreakdown,supportTicketTime},

	initialReadyCheckWaitingTimesBreakdown=readyCheckWaitingTimesProcessing[protocolPacket];

	readyCheckWaitingTimesBreakdown=KeyDrop[initialReadyCheckWaitingTimesBreakdown,ReadyCheckFalse];

	readyCheckOperationConstraint=Lookup[initialReadyCheckWaitingTimesBreakdown,ReadyCheckFalse];

	(* compute the amount of time ops spent waiting for issue to be resolved that was not tracked by ScientificSupport (ie. the ticket was never blocked) *)
	supportTicketTime = supportTicketWaitingTime[protocolPacket, ticketPackets];

	sciSupportTime = Lookup[parsedLog,ScientificSupport,0 Hour];
	shippingMaterialsTime = Lookup[parsedLog,ShippingMaterials,0 Hour];
	repairingInstrumentationTime = Lookup[parsedLog,RepairingInstrumentation,0 Hour];

	(* compute the total constraint time here, but do NOT include the supportTicketTime as that is OperatorProcessing, not OperatorReady time  *)
	operationConstraintTime = sciSupportTime + shippingMaterialsTime + repairingInstrumentationTime + readyCheckOperationConstraint;

	waitingTimesBreakdown = Append[readyCheckWaitingTimesBreakdown,
		{
			ShippingMaterials -> shippingMaterialsTime,
			InstrumentRepairs -> repairingInstrumentationTime,
			ScientificSupport -> sciSupportTime,
			SupportTicketQueue -> supportTicketTime
		}
	];

	{operationConstraintTime, waitingTimesBreakdown}
];

(* ::Subsection::Closed:: *)
(* supportTicketWaitingTime *)

(* no ticket overload *)
supportTicketWaitingTime[protocol:PacketP[], ticketPackets:{}]:=0 Hour;

(*core*)
supportTicketWaitingTime[protocol:PacketP[], ticketPackets:{PacketP[Object[SupportTicket, Operations]]..}]:=Module[
	{datesCreated,resolutionTurnaroundTime, completedTaskStartTimes,nextActionFromLogs,timeToNextAction,validTicketPackets,protocolDateCompleted, statusLogs, endTimes,orderedDates,nextDatesCreated},

	protocolDateCompleted = Lookup[protocol, DateCompleted];

	(* only use tickets that were filed by operations during the course of the protocol. If there were no usable tickets, return early *)
	validTicketPackets = Select[ticketPackets, MatchQ[Lookup[#, {CreatedBy, DateCreated}], {ObjectP[Object[User, Emerald, Operator]], LessP[protocolDateCompleted]}]&];
	If[MatchQ[validTicketPackets, {}], Return[0 Hour]];

	(* -- establish "resolution" time -- *)

	(* we are either looking for the time at which the ticket is resolved or blocked, or the time at which the operator effectively resumed *)

	(* for each ticket - compute the naive turnaround time (DateResolved - DateCreated/date blocked). Get the information from the log to find the first instance in case it is reopened*)
	(* note that Null is the status for a Resolved ticket AND a blocked ticket. In either case, when the status changes to this, the operator is no longer waiting on anything *)
	{datesCreated, statusLogs}=Transpose@Lookup[validTicketPackets, {DateCreated, StatusLog}];
	orderedDates = Sort[datesCreated];

	(*to avoid double counting, we always cap the end time of the ticket as the start time of the next ticket*)
	nextDatesCreated = Map[FirstCase[orderedDates, GreaterP[#], protocolDateCompleted]&,datesCreated];
	endTimes = MapThread[Min[FirstCase[#1, {_, (BlockingRequested|Null), _}, {protocolDateCompleted}][[1]], #2]&,{statusLogs, nextDatesCreated}];

	(* Check the completed tasks for the next meaningful action following the ticket creation. Because its possible that we will reload or handoff as part of the ticket resolution, we really can only rely on a task with an ID as an indication of progress *)
	(* Empirical testing indicates that this is a very small difference for most cases (<5%), but in cases where a reload is performed, followed by a long delay, it significantly increases the accuracy of the calculation *)
	completedTaskStartTimes = Transpose[{AbsoluteTime/@Lookup[protocol, CompletedTasks][[All,1]], Lookup[protocol, CompletedTasks][[All,4]]}];

	(* again, if a second ticket was filed before the first was resolved, use that as the end point *)
	nextActionFromLogs = MapThread[
		Min[
			DateObject[
				FirstCase[completedTaskStartTimes,
					{GreaterP[AbsoluteTime[#1]], _String}, {AbsoluteTime@protocolDateCompleted}][[1]]
			],
			#2
		]&,
		{datesCreated, nextDatesCreated}
	];

	(* -- establish OperatorProcessing time cost -- *)

	(* this metric is intended to account for OperatorProcessing time that is spent waiting for issue resolution *)
	(* this helper function computes the amount of OperatorProcessing time that occurs in that span. If we were to exit the protocol due to a resource constraint, it leave the ticket unresolved but the status would be OperatorReady*)
	opProcessingTimeInSpan[protocolPacket_, startDate_?DateObjectQ, endDate_?DateObjectQ]:= Lookup[
			ParseLog[protocolPacket, StatusLog, StartDate -> startDate, EndDate -> endDate],
			OperatorProcessing,
			0 Hour
		];

	resolutionTurnaroundTime = MapThread[opProcessingTimeInSpan[protocol, #1, #2]&, {datesCreated, endTimes}];
	timeToNextAction = MapThread[opProcessingTimeInSpan[protocol, #1, #2]&, {datesCreated, nextActionFromLogs}];

	(* use the less of the two times *)
	UnitConvert[Total[Min/@Transpose[{resolutionTurnaroundTime, timeToNextAction}]], Hour]
];

(* ::Subsection::Closed:: *)
(* totalTurnaroundTime *)


protocolTotalTurnaroundTime[protocol:PacketP[]]:=Module[{},
	protocolDateDifference[protocol,DateEnqueued,DateCompleted]
];


(* ::Subsection::Closed:: *)
(* totalLeadTime *)


protocolTotalLeadTime[protocol:PacketP[]]:=Module[{},
	protocolDateDifference[protocol,DateConfirmed,DateCompleted]
];



(* ::Subsection::Closed:: *)
(* totalCompletionTime *)


protocolTotalCompletionTime[protocol:PacketP[]]:=Module[{},
	protocolDateDifference[protocol,DateStarted,DateCompleted]
];



(* ::Subsection::Closed:: *)
(* protocolDateDifference *)


protocolDateDifference[protocol:PacketP[],startingDateField_Symbol,endingDateField_Symbol]:=Module[
	{startDate,endDate},

	{startDate,endDate}=Lookup[protocol,{startingDateField,endingDateField},Null];

	If[MemberQ[{startDate,endDate},Null],
		Return[Null]
	];

	endDate-startDate
];


(* ::Subsection::Closed:: *)
(* readyCheckWaitingTimesProcessing/Start *)


readyCheckWaitingTimesProcessing[protocolPacket:PacketP[]]:=readyCheckWaitingTimesProcessing[protocolPacket,OperatorReady];

readyCheckWaitingTimesStart[protocolPacket:PacketP[]]:=readyCheckWaitingTimesProcessing[protocolPacket,OperatorStart];

readyCheckWaitingTimesProcessing[protocolPacket:PacketP[],protocolStatus:Alternatives[OperatorReady,OperatorStart]]:=Module[{
	newLogs,statusLog,spliceEvents,intersectsQ,intersectLogs,intersectLogsPre,fullList,rsFalseResources,
	rsFalseMaterials,operatorReturn,readyCheckLogWithEndDates,statusLogWithEndDates,statusEntriesToCheck,intervalsToCheck,rcLog,rcFalseTimes,cleanList,
	rcFalseReady,rcFalseInstrument,rcFalseUserMaterials,rcFalseECLMaterials,splitEvents,totalTime,dataSet,relevantRCFalseEntries},

	(*Helper function to check if our constructed ready check log event intersects with an interval where protocol had status of interest *)
	intersectsQ[rcLogEvent:{startDate_,rcInfo_,endDate_},operatingInterval_]:=Module[{rcInterval,intersectCheck},

		(*convert Ready Check log invent into interval *)
		rcInterval=DateInterval[{startDate,endDate}];
		
		(*check if there is any intersection between the readycheck interval and the operating interval*)
		intersectCheck=IntervalIntersection[rcInterval,operatingInterval];

		(*if we have an empty Interval then there's no intersection*)
		!MatchQ[intersectCheck[[1]],Interval[]]
	];

	(* Insert ready check events into the status log *)
	splitEvents[statusEntry:{start1_,status_,end1_},rcEntry:{start2_,rcInfo_,end2_}]:=Module[{newEvents},

		newEvents={};

		(*Condition: No overlap, return early *)
		If[end1<=start2||start1>=end2,Return[{statusEntry}]];

		(*Condition: Overlap, adjust timings*)
		If[start1<start2,AppendTo[newEvents,{start1,status,start2}]];

		AppendTo[newEvents,{Max[start1,start2],rcInfo,Min[end1,end2]}];

		If[end1>end2,AppendTo[newEvents,{end2,status,end1}]];

		newEvents
	];

	(*Helper function to split and replace event times based on overlap*)
	spliceEvents[{statusLogEvent_,rcLogEvents_}]:=Module[{result},

		result={statusLogEvent};

		(* Insert our ready check events into our status log, accumulating updates to status log as we go by resetting result *)
		Map[
			Function[
				rcEvent,
				result=Flatten[
					Map[
						splitEvents[#,rcEvent]&,
						result
					],
					1
				]
			],
			rcLogEvents
		];

		{statusLogEvent,result}
	];

	(*Ensure TimeZone is adjusted static, so no funky business happens with DateInterval*)
	statusLog=Lookup[protocolPacket,StatusLog]/. {date_DateObject,rest___}:>{DateObject[date,TimeZone->-5],rest};

	(* Reformat our StatusLog from {status start, status, updated by} to {status start, status, status end} *)
	statusLogWithEndDates=MapThread[
		Append[#1[[1;;2]],#2[[1]]]&,
		{Most[statusLog],Rest[statusLog]}
	];

	(*find all status log events that are OperatorReady or OperatorStart*)
	statusEntriesToCheck=Select[statusLogWithEndDates,MatchQ[#[[2]],protocolStatus]&];

	(*create selected log events into date intervals*)
	intervalsToCheck=DateInterval[{#[[1]],#[[3]]}]&/@statusEntriesToCheck;

	(*Ensure TimeZone of readychecklog is adjusted static, so once again no funky business with DateInterval*)
	rcLog=Lookup[protocolPacket,ReadyCheckLog]/. {date_DateObject,rest___}:>{DateObject[date,TimeZone->-5],rest};

	(* Reformat our RC Log from {entry start, rc T/F, rcInfo} to {entry start, <|ReadyCheck->T/F, ECLMaterialsAvailable -> T/F, ...|>, entryEnd} *)
	(* Filter out all RC True entries *)
	(* If we have 0 or 1 entries we don't have enough data to make any conclusions about state of ReadyCheck *)
	readyCheckLogWithEndDates=If[Length[rcLog]>1,
		MapThread[
			If[!TrueQ[#1[[2]]],
				{#1[[1]],Append[#1[[3]],ReadyCheck->#1[[2]]],#2[[1]]},
				Nothing
			]&,
			{Most[rcLog],Rest[rcLog]}
		],
		{}
	];

	(*select only those where rc is false*)
	rcFalseTimes=Select[readyCheckLogWithEndDates,MatchQ[Lookup[#[[2]],ReadyCheck],False]&];

	(*for each status entry return {status entry, overlapping rc entries} *)
	intersectLogsPre=MapThread[
		Function[{interval,statusEntry},
			{
				statusEntry,
				Select[rcFalseTimes,intersectsQ[#,interval]&]
			}
		],
		{intervalsToCheck,statusEntriesToCheck}
	];

	(*remove any cases where there's no overlap*)
	intersectLogs=DeleteCases[intersectLogsPre,{_,{}}];

	(*helper function will create new logs based on intersecting events*)
	newLogs=spliceEvents/@intersectLogs;

	(*delete original status events to now add broken down ones in next line*)
	cleanList=DeleteCases[statusLogWithEndDates,Alternatives@@newLogs[[All,1]]];

	(* Get a new log in the form {start date, status|rcInfo, end date} *)
	(* If our protocol was RC->False during our provided protocolStatus then we have rcInfo as second element, otherwise we keep status *)
	fullList=SortBy[Join[cleanList,Flatten[newLogs[[All,2]],1]],First];

	(* Make a tiny helper to count up the total time in our status log entries of interest *)
	totalTime[entries_]:=Total[entries[[All,3]]-entries[[All,1]]];

	(*Total time spent in provided operator status, either OperatorStart or OperatorReady, RC true only*)
	operatorReturn = totalTime[PickList[fullList,fullList[[All,2]],protocolStatus]];

	(* Our processing above means any entries formatted as {startTime, rcInfo, endTime} represent RC->False periods during status of interest *)
	relevantRCFalseEntries = Cases[fullList, {_,_Association,_}];

	(*total time spent in rcFalse during our status of interest *)
	rcFalseReady = totalTime[relevantRCFalseEntries];

	(*total time spent in rcFalse during our status of interest because of instruments*)
	rcFalseInstrument = totalTime[Cases[relevantRCFalseEntries,{_, KeyValuePattern[InstrumentsAvailable -> False], _}]];

	(*total time spent in rcFalse during our status of interest because of user samples*)
	rcFalseUserMaterials = totalTime[Cases[relevantRCFalseEntries,{_, KeyValuePattern[UserMaterialsAvailable -> False], _}]];

	(*total time spent in rcFalse during our status of interest because of ecl materials*)
	rcFalseECLMaterials = totalTime[Cases[relevantRCFalseEntries,{_, KeyValuePattern[ECLMaterialsAvailable -> False], _}]];

	(*total time spent in rcFalse during our status of interest because of any materials other than instruments*)
	rsFalseMaterials = totalTime[
		Select[
			relevantRCFalseEntries,
			MemberQ[Lookup[#[[2]],{UserMaterialsAvailable,ECLMaterialsAvailable}],False]&
		]
	];

	(*total time spent in rcFalse during our status of interest because of any availability issue *)
	rsFalseResources = totalTime[
		Select[
			relevantRCFalseEntries,
			MemberQ[Lookup[#[[2]],{UserMaterialsAvailable,ECLMaterialsAvailable,InstrumentsAvailable}],False]&
		]
	];

	dataSet=<|
		ReadyCheckFalse->rcFalseReady,
		ResourceAvailability->rsFalseResources,
		InstrumentAvailability->rcFalseInstrument,
		MaterialsAvailability->rsFalseMaterials,
		ECLMaterialsAvailability->rcFalseECLMaterials,
		UserMaterialsAvailability->rcFalseUserMaterials
	|>;

	(*rename for start time processes*)
	If[MatchQ[protocolStatus,OperatorReady],
		Append[dataSet,OperatorReturn->operatorReturn],
		Append[dataSet,OperatorStart->operatorReturn]
	]
];
