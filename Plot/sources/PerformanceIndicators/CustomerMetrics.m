(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Customer Metrics*)


(* ::Subsubsection::Closed:: *)
(*ReportCustomerMetrics*)
DefineOptions[ReportCustomerMetrics,
	Options:>{
		(* TODO add NameOption?*)
		UploadOption,
		CacheOption,
		{
			OptionName -> ActivityLimit,
			Default -> 25 Minute,
			Description -> "Indicates the maximum time interval between user activities in Command Center to qualify as logged user hours.",
			Pattern:> _?TimeQ,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> InactivityBuffer,
			Default -> 5 Minute,
			Description -> "Indicates the time added to user's logged activity intervals to act as buffer time after the last logged activity.",
			Pattern:> _?TimeQ,
			Category -> "General",
			AllowNull -> False
		}
	}
];

(*Error Messages*)
Error::TeamNotFound="The following financing team(s) `1` cannot be found. Please verify existence of input team(s) in the database.";
Error::InvalidDateRange="The date range specified {`1` to `2`} is invalid. Date range cannot be days in the future, and must have an end date of no later than yesterday. Please specify an appropriate Start Date and End Date.";
Error::NoProtocolsCompleted="No parent protocols have been completed for the date range specified. Rerun with a different date range.";

(* Overloads *)
(* only one date is supplied - generate report from date up to Today-1 Day *)
ReportCustomerMetrics[myFinancingTeams:{ObjectP[Object[Team, Financing]]..}|ObjectP[Object[Team,Financing]],date_?DayObjectQ,ops:OptionsPattern[]]:=Module[
	{startDate,endDate},
	
	(* The most recent `endDate` that can be included in a report is that of Today - 1 day since a full 24 hours of the day must be covered in any report log. *)
	startDate = date;
	endDate = Today-1 Day;
	
	ReportCustomerMetrics[myFinancingTeams,startDate,endDate]
];

(* no date is supplied - generate the report for the latest week from Today *)
ReportCustomerMetrics[myFinancingTeams:{ObjectP[Object[Team, Financing]]..}|ObjectP[Object[Team,Financing]],ops:OptionsPattern[]]:=Module[
	{startDate,endDate},
	
	(* The most recent `endDate` that can be included in a report is that of Today - 1 day since a full 24 hours of the day must be covered in any report log. *)
	startDate = Today - 8 Day;
	endDate = Today - 1 Day;
	
	ReportCustomerMetrics[myFinancingTeams,startDate,endDate]
];

(* list input of financing teams*)
ReportCustomerMetrics[myFinancingTeams:{ObjectP[Object[Team, Financing]]..},startDate_?DayObjectQ,endDate_?DayObjectQ,ops:OptionsPattern[]]:=Module[
	{validDateRange,validTeamBools,invalidTeams},
	
	(* Error Check *)
	
	(* The most recent `endDate` that can be included in a report is that of Today - 1 day since a full 24 hours of the day must be covered in any report log. *)
	validDateRange =GreaterEqualDateQ[endDate,startDate]&&GreaterDateQ[Today,endDate];
	
	If[validDateRange,
		Null,
		Message[Error::InvalidDateRange,DateString[startDate, {"MonthNameShort", " ", "Day", ", ", "Year"}],DateString[endDate, {"MonthNameShort", " ", "Day", ", ", "Year"}]];
		Return[$Failed]
	];

	validTeamBools = DatabaseMemberQ[myFinancingTeams];
	
	invalidTeams = PickList[myFinancingTeams,validTeamBools,False];
	
	(* Check if all teams are valid members of the database*)
	If[MatchQ[Length[invalidTeams],GreaterP[0]],
		Message[Error::TeamNotFound,invalidTeams];
		Return[$Failed],
		
		Map[
			ReportCustomerMetrics[#,startDate,endDate]&,
			myFinancingTeams
		]
	]
];

ReportCustomerMetrics[myFinancingTeam:ObjectP[Object[Team, Financing]],startDate_?DayObjectQ,endDate_?DayObjectQ,ops:OptionsPattern[]]:=Module[
	{
		safeOps,
		upload,
		cache,
		activityLimit,
		inactivityBuffer,
		validDateRange,
		allPackets,
		cacheBall,
		fastAssoc,
		
		financingTeamNotebook,
		days,
		startDateEndOfDay,
		endDateEndOfDay,
		endOfDayRange,
		startDateStartOfDay,
		endDateStartOfDay,
		startOfDayRange,
		convertedStartTime,
		convertedEndTime,
		parentProtocolsCompleted,
		parentProtocolSubprotocolAssoc,
		allSubprotocols,
		subprotocolCriteria,
		subprotocolsCompleted,
		allCompletedProtocols,
		protocolDayAssoc,
		protocolClassificationAssoc,
		protocolUserAssoc,
		parentProtocolFields,
		subprotocolFields,
		
		(*Protocol Metrics*)
		parentProtocolPackets,
		subprotocolPackets,
		parentProtocolLog,
		subprotocolLog,
		protocolLog,
		parentProtocolDataLog,
		subprotocolDataLog,
		dataLog,
		samplesLog,
		protocolSummaryLog,
		dayToThreadsAndQueuePackets,
		dayToAuthorStatusPackets,
		dayToMemberPackets,
		uniqueMemberPackets,
		threadsPacket,
		teamThreadUtilizationLog,
		allUniqueMembers,
		userThreadUtilizationLog,
		allUserActivityPackets,
		userHourLog,
		userUtilizationSummary,
		
		instrumentResources,
		instrumentResourcePackets,
		instrumentPackets,
		instrumentLog,
		queueTimesSummary,
		
		
		
		
		
		parentProtocolData,
		subprotocolData,
		parentProtocolSamples,
		subProtocolSamples,
		
		
		finalCustomerMetricsPacket
	},
	
	(* get the safe options *)
	safeOps = SafeOptions[ReportCustomerMetrics, ToList[ops]];
	
	(* tease out the Upload and Cache options *)
	{upload, cache,activityLimit,inactivityBuffer} = Lookup[safeOps, {Upload, Cache,ActivityLimit,InactivityBuffer}];
	
	(* Error Checks *)
	(* Check if date range specificied valid *)
	validDateRange =GreaterEqualDateQ[endDate,startDate]&&GreaterDateQ[Today,endDate];
	
	If[validDateRange,
		Null,
		Message[Error::InvalidDateRange,DateString[startDate, {"MonthNameShort", " ", "Day", ", ", "Year"}],DateString[endDate, {"MonthNameShort", " ", "Day", ", ", "Year"}]];
		Return[$Failed]
	];
	
	(* Check if team is a valid member of the database*)
	If[DatabaseMemberQ[myFinancingTeam],
		Null,
		Message[Error::TeamNotFound,{myFinancingTeam}];
		Return[$Failed]
	];
	
	
	
	(* Convert the day inputs to time that starts and ends at midnight CDT so each day in the logs belong to the same 24 hour range *)
	
	(* Convert the start date to a time object at the starting second of that date in the "America/Chicago" TimeZone *)
	convertedStartTime=DateObject[
		Join[startDate[[1]],{00,00,00.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	(* Convert the end date to a time object at the starting second of day next the end date in the "America/Chicago" TimeZone - this is to cover the full day of the end date *)
	convertedEndTime=DateObject[
		Join[endDate[[1]],{23,59,59.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	(* get the times for the the start of day and end of day for both the startDate and the endDate *)
	startDateStartOfDay = convertedStartTime;
	
	startDateEndOfDay = DateObject[
		Join[startDate[[1]],{23,59,59.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	endDateStartOfDay =DateObject[
		Join[endDate[[1]],{00,00,00.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	endDateEndOfDay = convertedEndTime;
	
	
	(* create a list of days in the form of DateObject[{YYYY,MM,DD,23,59,59.},...] *)
	endOfDayRange = DateRange[startDateEndOfDay,endDateEndOfDay];
	
	(* create a list of days in the form of DateObject[{YYYY,MM,DD,00,00,00.},...] *)
	startOfDayRange = DateRange[startDateStartOfDay,endDateStartOfDay];
	
	(* create a list of days included in the report *)
	days=DateRange[convertedStartTime,convertedEndTime,Day];
	
	(* Download *)
	(* get a list of all completed protocols within the desired report time frame - protocols that have a DateCompleted between startDate and endDate *)
	(* remove all Cover/Uncover protocols - these are not included in the analysis *)
	allCompletedProtocols = DeleteDuplicates[DeleteCases[Search[
		Object[Protocol],
		Status==Completed
			&& DateCompleted>convertedStartTime
			&& DateCompleted<convertedEndTime
			&& Notebook[Financers]==myFinancingTeam
	],ObjectP[Object[Protocol,Cover]]|ObjectP[Object[Protocol,Uncover]]]];
	
	instrumentResources = Search[Object[Resource,Instrument],
		Notebook[Financers]==myFinancingTeam
			&& DateFulfilled>convertedStartTime
			&& DateFulfilled<convertedEndTime
	];
	
	(* create packet of relevant information for all completed protocols *)
	allPackets=Quiet[Download[
		{
			ToList[allCompletedProtocols],
			ToList[instrumentResources],
			ToList[myFinancingTeam]
		},
		{
			{
				Packet[
					DateEnqueued,
					DateStarted,
					DateCompleted,
					Author,
					ParentProtocol,
					RootProtocol,
					Subprotocols,
					Data,
					SamplesIn,
					SamplesOut
				],
				Packet[Data[{DateCreated}]]
			},
			{
				Packet[Instrument, DateInUse,DateFulfilled, RootProtocol, Time, EstimatedTime],
				Packet[RootProtocol[{StatusLog}]],
				Packet[Instrument[{QualificationLog,MaintenanceLog,Model,Cost,Dimensions}]]
			},
			{
				Packet[Name,DefaultNotebook]
			}
		},
		Cache -> cache,
		Date -> Now
	],{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];
	
	(* Create fastAssoc from cacheBall *)
	cacheBall= Experiment`Private`FlattenCachePackets[{cache,Cases[Flatten[allPackets], PacketP[]]}];
	fastAssoc= Experiment`Private`makeFastAssocFromCache[cacheBall];
	
	(* Protocol Metrics*)
	
	(* get a list of subprotocols (eg any protocol that has a Parent Protocol) *)
	allSubprotocols = Select[allCompletedProtocols,MatchQ[Experiment`Private`fastAssocLookup[fastAssoc,#,ParentProtocol],ObjectP[Object[Protocol]]]&];
	
	(* create an association of any subprotocol with its root protocol *)
	parentProtocolSubprotocolAssoc = Association[
		(* assign each gathered group to the shared Root Protocol *)
		Map[
			(#->Download[Experiment`Private`fastAssocLookup[fastAssoc,#,RootProtocol],Object])&,
			allSubprotocols
		]
	];
	
	(* Create a protocol->dayCompleted - each log requires the day completed of each protocol *)
	protocolDayAssoc = If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Association[Map[
			Module[
				{dateCompleted, logDate},
				dateCompleted = TimeZoneConvert[Experiment`Private`fastAssocLookup[fastAssoc,#,DateCompleted],"America/Chicago"];
				
				(* For the logDate, convert the dateCompleted to the midnight of the equivalent date in "America/Chicago" timezone *)
				logDate=DateObject[
					Join[dateCompleted[[1]][[1;;3]],{00,00,00.}],
					"Instant", "Gregorian", "America/Chicago"
				];
				
				#->logDate
			]&,
			allCompletedProtocols
		]],
		<||>
	];
	
	(* Create a protocol->protocolClassification association - identifies whether a protocol is a ParentProtocol or a Subprotocol *)
	protocolClassificationAssoc = If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Association[Map[
			Module[
				{parentProtocol,protocolClassification},
				
				parentProtocol=Experiment`Private`fastAssocLookup[fastAssoc,#,ParentProtocol];

				(* If it has no ParentProtocol, it is considered a Subprotocol *)
				protocolClassification=If[MatchQ[parentProtocol,Null],
					ParentProtocol,
					Subprotocol
				];
				#->protocolClassification
			]&,
			allCompletedProtocols
		]],
		<||>
	];
	
	(* Create a protocol->user association - subprotocols that have no Author are assigned the Author of their associated parent protocol *)
	protocolUserAssoc = If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Association[Map[
			Function[
				{protocol},
				Module[
					{protocolUser,parentProtocol},
					
					parentProtocol=Lookup[parentProtocolSubprotocolAssoc,protocol,Null];
					
					protocolUser=Which[
						(* If protocol has an Author, set protocolAuthor to field value.*)
						MatchQ[Experiment`Private`fastAssocLookup[fastAssoc,protocol,Author],ObjectP[Object[User]]],
						Download[Experiment`Private`fastAssocLookup[fastAssoc,protocol,Author],Object],
						
						(* If protocol has no Author but has a ParentProtocol, use the Author field of the parentProtocol for the User assignment *)
						MatchQ[parentProtocol,ObjectP[Object[Protocol]]],
						
						If[
							(* account for cases that even the parent protocol has no Author *)
							MatchQ[Experiment`Private`fastAssocLookup[fastAssoc,parentProtocol,Author],ObjectP[Object[User]]],
							Download[Experiment`Private`fastAssocLookup[fastAssoc,parentProtocol,Author],Object],
							Null
						],
						
						True,
						Null
					];
					protocol->protocolUser
				]
			],
			allCompletedProtocols
		]],
		<||>
	];
	
	
	(* ProtocolLog *)
	(* Create a log for the protocols with the following information: {"Date", "Protocol", "Protocol Classification", "Date Enqueued", "Date Started","Date Completed","Queue Time", "User"}*)
	protocolLog = If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Map[
			Module[
				{logDate,protocolClassification,dateEnqueued,dateStarted,dateCompleted,queueTime, protocolUser,protocolType},
				
				logDate = Lookup[protocolDayAssoc,#];
				
				dateCompleted = Experiment`Private`fastAssocLookup[fastAssoc,#,DateCompleted];
				dateEnqueued = Experiment`Private`fastAssocLookup[fastAssoc,#,DateEnqueued];
				dateStarted = Experiment`Private`fastAssocLookup[fastAssoc,#,DateStarted];
				
				(* Queue Time is the difference between DateEnqueued and DateStarted *)
				queueTime = If[MatchQ[dateEnqueued,_?DateObjectQ] && MatchQ[dateStarted,_?DateObjectQ] && GreaterDateQ[dateStarted,dateEnqueued],
					DateDifference[dateEnqueued,dateStarted,Hour],
					Null
				];
				
				(* Parent or Sub *)
				protocolClassification = Lookup[protocolClassificationAssoc,#];
				
				(* get the associated User *)
				protocolUser=Lookup[protocolUserAssoc,#];
				
				(* get Type *)
				protocolType = Experiment`Private`fastAssocLookup[fastAssoc,#,Type];
				
				{logDate,Link[#],protocolClassification,dateEnqueued,dateStarted,dateCompleted,queueTime,Link[protocolUser],protocolType}
			]&,
			allCompletedProtocols
		],
		{}
	];
	
	(* DataLog *)
	(* Create a log of data objects with the following information: {"Date", "Data", "Protocol", "Protocol Classification", "Date Created", "User"} *)
	dataLog = If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Flatten[Map[
			Function[{protocol},
				(* For each protocol, create a log for each data object created for the protocol *)
				Module[
					{logDate,dataObjects, protocolClassification,protocolUser},
					
					(* date the protocol associated with the data log is completed *)
					logDate = Lookup[protocolDayAssoc,protocol];
					
					(* identify if the data is associated with a parent or sub protocol *)
					protocolClassification = Lookup[protocolClassificationAssoc,protocol];
					
					(* identify the user that generated the data based on the autor of the protocol *)
					protocolUser=Lookup[protocolUserAssoc,protocol];
					
					(* get the data objects associated with the protocol *)
					dataObjects = Download
						[ToList[Experiment`Private`fastAssocLookup[fastAssoc,protocol,Data]],
						Object
					];
					
					(* create a log for each data object; account for protocols that do not have data objects to have an empty list *)
					If[MatchQ[dataObjects,{ObjectP[Object[Data]]..}],
						Map[
							Module[{dateCreated, dataType},
								
								dateCreated=Experiment`Private`fastAssocLookup[fastAssoc,#,DateCreated];
								
								dataType=Experiment`Private`fastAssocLookup[fastAssoc,#,Type];
								
								{logDate, Link[#], Link[protocol], protocolClassification, dateCreated, Link[protocolUser],dataType}
							]&,
							dataObjects
						],
						{}
					]
				]
			],
			allCompletedProtocols
		],1],
		{}
	];
	
	(* SamplesLog *)
	(* Create a log of sample objects with the following information: {"Date", "Sample", "Protocol", "Protocol Classification", "User"} *)
	samplesLog =If[MatchQ[allCompletedProtocols,{ObjectP[Object[Protocol]]..}],
		Flatten[Map[
			Function[{protocol},
				(* For each protocol, create a log for each sample object associated with protocols (SamplesIn and SamplesOut) *)
				Module[
					{logDate, protocolClassification,protocolUser, samplesInObjects,samplesOutObjects, allSamples},
					
					(* get the date the protocol associated with the sample object is completed *)
					logDate = Lookup[protocolDayAssoc,protocol];
					
					(* identify if the sample is associated with a parent or sub protocol *)
					protocolClassification = Lookup[protocolClassificationAssoc,protocol];
					
					(* identify the user based on the author of the protocol associated with the sample *)
					protocolUser=Lookup[protocolUserAssoc,protocol];
					
					samplesInObjects = ToList[Experiment`Private`fastAssocLookup[fastAssoc,protocol,SamplesIn]];
					samplesOutObjects = ToList[Experiment`Private`fastAssocLookup[fastAssoc,protocol,SamplesOut]];
					
					(* we count SamplesIn and SamplesOut individually *)
					allSamples=Cases[Join[samplesInObjects,samplesOutObjects],ObjectP[Object[Sample]]];
					
					(* create a log for each sample object; protocols that have no associated sample object will return an empty list *)
					If[MatchQ[allSamples,{ObjectP[Object[Sample]]..}],
						Map[
							{logDate, Link[#], Link[protocol], protocolClassification, Link[protocolUser]}&,
							allSamples
						],
						{}
					]
				]
			],
			allCompletedProtocols
		],1],
		{}
	];
	
	(* ProtocolSummaryLog *)
	(* Create a summary of protocol metrics per day with the following information: {"Date", "Parent Protocols", "Subprotocols", "Data Objects (Parent Protocols)", "Data Objects (Subprotocols)","Samples (Parent Protocols)", "Samples (Subprotocols)" }*)
	protocolSummaryLog=Map[
		Module[
			{logDate, numberOfParentProtocols,numberOfSubprotocols,numberOfParentProtocolData,numberOfSubprotocolData,numberOfParentProtocolSamples,numberOfSubprotocolSamples},
			
			logDate = #;
			
			(* Count cases for protocol,data, sample that are associated with Parent vs Sub *)
			numberOfParentProtocols = Length[Select[protocolLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[3]],ParentProtocol]&]];
			numberOfSubprotocols = Length[Select[protocolLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[3]],Subprotocol]&]];
			
			numberOfParentProtocolData = Length[Select[dataLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],ParentProtocol]&]];
			numberOfSubprotocolData = Length[Select[dataLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],Subprotocol]&]];
			
			numberOfParentProtocolSamples = Length[Select[samplesLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],ParentProtocol]&]];
			numberOfSubprotocolSamples = Length[Select[samplesLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],Subprotocol]&]];
			
			{logDate,numberOfParentProtocols,numberOfSubprotocols,numberOfParentProtocolData,numberOfSubprotocolData,numberOfParentProtocolSamples,numberOfSubprotocolSamples}
		]&,
		startOfDayRange
	];
	
	(* QueueTimesSummary *)
	
	(* If no protocols are found, this returns an empty list *)
	queueTimesSummary = If[MatchQ[protocolLog,Except[{}|Null]],
		Module[{dailyProtocolLog,groupedDailyLogsByQueueTimes},
			(* Gather protocol log list by date *)
			dailyProtocolLog=GatherBy[protocolLog,First];
			
			(* group each protocol log list by QueueTimes range *)
			groupedDailyLogsByQueueTimes = Map[
				Function[{logsPerDay},
					Module[{date,lessThan5H,fiveTo10H,tenTo24H,moreThan24H},
						
						(* each logsPerDay set list shares the same first element which is the date associated with the protocolLog *)
						date = logsPerDay[[1]][[1]];
						
						(* for each protocolLog in the logsPerDay, get number of protocolLogs that fall within a particular range of QueueTimes - QueueTime *)
						lessThan5H = Length[Select[logsPerDay,LessEqualQ[#[[7]],5 Hour]&]];
						fiveTo10H = Length[Select[logsPerDay,LessEqualQ[#[[7]],10 Hour]&&GreaterQ[#[[7]],5 Hour]&]];
						tenTo24H = Length[Select[logsPerDay,LessEqualQ[#[[7]],24 Hour]&&GreaterQ[#[[7]],10 Hour]&]];
						moreThan24H = Length[Select[logsPerDay,GreaterQ[#[[7]],24 Hour]&]];
						
						{date,lessThan5H,fiveTo10H,tenTo24H,moreThan24H}
					]
				],
				dailyProtocolLog
			]
		],
		{}
	];
	
	(* TeamThreadUtilizationLog *)
	(*Thread Utilization Log*)
	
	(* MaxThreads, Queue and Queue[Status,Author] values are used to generate logs for the team thread utilization and individual user thread utilization*)
	
	(* Download all neccessary information (thread and queue related field values) from the Team Financing object and create an association of packets per day - use the values of fields at the end of day - DateObject[{YYYY,MM,DD,23,59,59},"America/Chicago"]*)
	(* TODO transform this to be looking at values via ObjectLog to avoid mapped Download per day - get ObjectLog for necessary fields and populate daily log based on date of changes on ObjectLog *)
	{
		dayToThreadsAndQueuePackets,
		dayToAuthorStatusPackets,
		dayToMemberPackets
	}=Module[
		{},
		Transpose[Map[
			Module[
				{financingTeamPackets,threadsAndQueue,statusAuthor,members},
				
				financingTeamPackets = Download[myFinancingTeam,
					{
						Packet[MaxThreads,Queue,Members],
						Packet[Queue[Status,Author]],
						Packet[Members[Name]]
					},
					Date->#
				];
				
				threadsAndQueue=financingTeamPackets[[1]];
				statusAuthor=financingTeamPackets[[2]];
				members=financingTeamPackets[[3]];
				
				{#->threadsAndQueue,#->statusAuthor,#->members}
			]&,
			endOfDayRange
		]]
	];
	
	uniqueMemberPackets = DeleteDuplicates[Flatten[Values[dayToMemberPackets]]];
	
	(* Create a log for threads available and threads utilized per day for the entire team {"Date", "User", "InUse Thread Count"} - log date to be used is start of day since that is used in selection criteria for PlotCustomerMetrics *)
	teamThreadUtilizationLog = MapThread[
		Module[
			{logDate,threadsAndQueuePacket, statusAuthorPacket, maxThreadCount, inUseThreadCount},
			
			logDate = #1;
			
			(* Get the packet for the day *)
			threadsAndQueuePacket=Lookup[dayToThreadsAndQueuePackets,#2];
			statusAuthorPacket=Lookup[dayToAuthorStatusPackets,#2];
			
			(* get the MaxThreads for the day *)
			maxThreadCount = Lookup[threadsAndQueuePacket,MaxThreads];
			
			(* get the number of threads in use by counting protocols that are Processing in that period *)
			inUseThreadCount=Length[Cases[statusAuthorPacket, KeyValuePattern[Status->Processing]]];
			
			{logDate, maxThreadCount, inUseThreadCount}
		]&,
		{
			startOfDayRange,
			endOfDayRange
		}
	];
	
	(* UserThreadUtilizationLog *)
	(* Create a log for threads available and threads utilized per day for a given user {"Date", "User", "InUse Thread Count"} *)
	
	(* get a list of all members of the financing team *)
	allUniqueMembers =DeleteDuplicates[Cases[
		Download[Flatten[Lookup[Values[dayToThreadsAndQueuePackets],Members]],Object],
		Except[ObjectP[Object[User,Emerald,Developer]]]
	]];
	
	userThreadUtilizationLog = Flatten[Map[
		Function[
			{day},
			Module[
				{logDate,threadsAndQueuePacket, statusAuthorPacket},
				
				logDate = DateObject[
					Join[day[[1]][[1;;3]],{00,00,00.}],
					"Instant", "Gregorian", "America/Chicago"
				];
				
				threadsAndQueuePacket=Lookup[dayToThreadsAndQueuePackets,day];
				statusAuthorPacket=Lookup[dayToAuthorStatusPackets,day];
				
				Map[
					Module[
						{user,userName, numberOfInUseThreads},
						
						user=#;
						
						userName = Lookup[FirstCase[uniqueMemberPackets,KeyValuePattern[{Object->ObjectP[#]}]],Name];
						
						numberOfInUseThreads=Length[Cases[statusAuthorPacket, KeyValuePattern[{Status->Processing,Author->ObjectP[#]}]]];
						
						{logDate, Link[user],userName, numberOfInUseThreads}
					]&,
					allUniqueMembers
				]
			]
		],
		endOfDayRange
	],1];
	
	(* UserHourLog *)
	(* Create a log for user activity for a given user {"Date", "User", "Hours of Activity"} *)
	
	(* Download all CommandCenterActivityHistory for each member up until the specified end of the date range *)
	allUserActivityPackets = Download[
		allUniqueMembers,
		Packet[CommandCenterActivityHistory],
		Date->convertedEndTime
	];
	
	(* Create a log for user activity per day for a given user based on CommandCenterActivityHistory {"Date", "User", "Hours of Activity"} *)
	userHourLog = Flatten[MapThread[
		Function[{startOfDay,endOfDay},
			If[MatchQ[allUniqueMembers,{ObjectP[Object[User]]..}],
				Map[
					Module[
						{logDate, user,userName,userActivityPacket,userCommandCenterActivityHistory, dailyUserCommandCenterActivityHistory, dailyUserActivityDates, workIntervals,hoursOfLaborPerWorkInterval, hoursOfLabor},
						
						logDate = startOfDay;
						
						user = #;
						
						userName = Lookup[FirstCase[uniqueMemberPackets,KeyValuePattern[{Object->ObjectP[user]}]],Name];
						
						(* get the most recent activity packet per User *)
						userActivityPacket = FirstCase[allUserActivityPackets,KeyValuePattern[Object->ObjectP[#]]];
						
						(* get the list of activity of the user - <|ActivityDate->XX, ActivityType-> YY|> *)
						userCommandCenterActivityHistory = Lookup[userActivityPacket,CommandCenterActivityHistory];
						
						(* select the list of packets that are within range of the specified date from midnight to midnight *)
						dailyUserCommandCenterActivityHistory=Cases[userCommandCenterActivityHistory, KeyValuePattern[ActivityDate -> _?(GreaterDateQ[#, startOfDay] &&
									LessDateQ[#, endOfDay] &)]];
						
						(* get the ActivityDates for the in-range history - these are the time points when user is interacting with Command Center *)
						dailyUserActivityDates = If[MatchQ[dailyUserCommandCenterActivityHistory,{_Association..}],
							Sort[Lookup[dailyUserCommandCenterActivityHistory, ActivityDate]],
							{}
						];
						
						(* create groupings of activity dates that does not have a gap of greater than the activityLimit option (25 Minute default) - this is a baseline of considered consistent activity and will be counted hours of labor *)
						workIntervals = Split[dailyUserActivityDates,(#2-#1) < activityLimit&];
						
						(* get the time gap between the time of the first activity and the last activity per work interval plus an inactivity buffer (default 10 minute) and add up *)
						hoursOfLaborPerWorkInterval = Cases[Map[
							(Last[#]-First[#])+inactivityBuffer&,
							workIntervals
						],_?TimeQ];
						
						(* get the total hours of labor per user per day *)
						hoursOfLabor = If[MatchQ[hoursOfLaborPerWorkInterval,{_?TimeQ..}],
							Total[hoursOfLaborPerWorkInterval],
							0 Hour
						];
						
						{logDate, Link[user],userName, hoursOfLabor}
					]&,
					allUniqueMembers
				],
				{}
			]
		],
		{startOfDayRange,endOfDayRange}
	],1];
	
	(* UserUtilizationSummary *)
	(*{"Date", "User", "Number of Protocols", "Number of Data Objects", "Number of Samples", "Labor Hours" }*)
	
	userUtilizationSummary = If[MatchQ[allUniqueMembers,{ObjectP[Object[User]]..}],
		Flatten[Map[
			Function[{startOfDay},
				Map[
					Function[{member},
						Module[{logDate, userName, numberOfParentProtocolsPerUserPerDay, numberOfParentDataPerUserPerDay,numberOfParentSamplesPerUserPerDay, numberOfTotalProtocolsPerUserPerDay, numberOfTotalDataPerUserPerDay,numberOfTotalSamplesPerUserPerDay,numberOfLaborHoursPerUserPerDay},
							
							logDate = startOfDay;
							
							userName = Lookup[FirstCase[uniqueMemberPackets,KeyValuePattern[{Object->ObjectP[member]}]],Name];
							
							(* count protocols, data, samples, hours of Labor per User per Day *)
							numberOfParentProtocolsPerUserPerDay =Length[Select[protocolLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[3]],ParentProtocol]&&MatchQ[#[[8]],ObjectP[member]]&]];
							
							numberOfParentDataPerUserPerDay = Length[Select[dataLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],ParentProtocol]&&MatchQ[#[[6]],ObjectP[member]]&]];
							
							numberOfParentSamplesPerUserPerDay = Length[Select[samplesLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[4]],ParentProtocol]&&MatchQ[#[[5]],ObjectP[member]]&]];
							
							numberOfTotalProtocolsPerUserPerDay =Length[Select[protocolLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[8]],ObjectP[member]]&]];
							
							numberOfTotalDataPerUserPerDay = Length[Select[dataLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[6]],ObjectP[member]]&]];
							
							numberOfTotalSamplesPerUserPerDay = Length[Select[samplesLog,MatchQ[#[[1]],logDate]&&MatchQ[#[[5]],ObjectP[member]]&]];
							
							numberOfLaborHoursPerUserPerDay = FirstCase[userHourLog,{logDate,Link[member],__}][[4]];
							
							{logDate,Link[member], userName,numberOfParentProtocolsPerUserPerDay, numberOfParentDataPerUserPerDay,numberOfParentSamplesPerUserPerDay,numberOfTotalProtocolsPerUserPerDay, numberOfTotalDataPerUserPerDay, numberOfTotalSamplesPerUserPerDay,numberOfLaborHoursPerUserPerDay}
						]
					],
					allUniqueMembers
				]
			],
			startOfDayRange
		],1],
		{}
	];
	
	(* InstrumentLog *)
	(*Create an InstrumentLog with the following information : {"Date", "Instrument", "Protocol", "Time InUse", "Number of Maintenances", "Number Of Qualifications"} *)
	instrumentLog = If[MatchQ[instrumentResources,{}],
		{},
		Map[
			Function[
				{instrumentResource},
				
				Module[{resource, dateInUse,dateFulfilled,time, logDate, instrument,instrumentModel, rootProtocol, rootProtocolStatusLog,protocolStatusTimeAssociation,timeInUse, inRangeSciSupportAssoc,
					inRangeRepairAssoc,
					inRangeShippingAssoc,sciSupportTime,
					instrRepairTime,
					shippingMatTime,qualificationLog, numberOfQualificationsToDate, maintenanceLog, numberOfMaintenancesToDate,instrumentCost,instrumentDimensions},
					
					(* per instrument resource *)
					resource = Download[instrumentResource, Object];
					
					(* we need to convert to America/Chicago for consistency *)
					dateFulfilled =  TimeZoneConvert[Experiment`Private`fastAssocLookup[fastAssoc, instrumentResource, DateFulfilled],"America/Chicago"];
					dateInUse =  TimeZoneConvert[Experiment`Private`fastAssocLookup[fastAssoc, instrumentResource, DateInUse],"America/Chicago"];
					
					(* get time before applying any corrections from protocol status *)
					time=Which[
						(* use Time field in resource if available *)
						MatchQ[Experiment`Private`fastAssocLookup[fastAssoc,resource,Time],_?QuantityQ],
						Experiment`Private`fastAssocLookup[fastAssoc,resource,Time],
						
						(* if Time field is not populated, use the time between DateInUse and DateFulfilled *)
						DateObjectQ[dateFulfilled]&&DateObjectQ[dateInUse],
						DateDifference[dateFulfilled,dateInUse,"Minute"],
						
						(* Otherwise, set to 0 Hour *)
						True,
						0 Hour
					];
					
					logDate = DateObject[
						Join[dateFulfilled[[1]][[1;;3]],{00,00,00.}],
						"Instant", "Gregorian", "America/Chicago"
					];
					
					instrument = Experiment`Private`fastAssocLookup[fastAssoc, instrumentResource, Instrument];
					instrumentModel = Experiment`Private`fastAssocLookup[fastAssoc, instrument, Model];
					
					rootProtocol = Experiment`Private`fastAssocLookup[fastAssoc, instrumentResource, RootProtocol];
					
					(* identify timeInUse for each instrument resource by getting DateFulfilled-DateInUse (Time) then subtract overlapping times that are in ScientificSupport, RepairingInstrumentation and ShippingMaterials *)
					
					(*get the StatusLog of the protocol*)
					rootProtocolStatusLog = Experiment`Private`fastAssocLookup[fastAssoc,rootProtocol,StatusLog];
					
					(*create protocolStatusTimeTuple: {Status, date Status starts, date Status ends}*)
					protocolStatusTimeAssociation=Cases[
						If[MatchQ[rootProtocolStatusLog,Except[Null]],
							MapThread[
								<|Status->#1[[2]],StartDate->#1[[1]],EndDate->#2[[1]]|>&,
								{Most[rootProtocolStatusLog],Rest[rootProtocolStatusLog]}
							],
							{}
						],
						KeyValuePattern[{Status->(ScientificSupport|RepairingInstrumentation|ShippingMaterials)}]
					];
					
					(*get status time associations that have some overlap with period between dateInUse and dateFulfilled of the resource by excluding any tuple that ends before dateInUse or starts after dateFulfilled*)
					{
						inRangeSciSupportAssoc,
						inRangeRepairAssoc,
						inRangeShippingAssoc
					}=Map[
						Function[{status},
							Select[
								protocolStatusTimeAssociation,
								Not[
									LessDateQ[Lookup[#,EndDate],dateInUse]||GreaterDateQ[Lookup[#,StartDate],dateFulfilled]
								]
									&&MatchQ[Lookup[#,Status],status]&
							]
						],
						{
							ScientificSupport,
							RepairingInstrumentation,
							ShippingMaterials
						}
					];
					
					(* get the amount of time overlap for each status with the resource time *)
					{
						sciSupportTime,
						instrRepairTime,
						shippingMatTime
					} = Map[
						Function[{assocList},
							If[MatchQ[assocList,{}],
								(*if inRangeBLAHAssoc is empty, time overlap is just 0 Hour*)
								0 Hour,
								(*if there is overlap, calculate based on nature of overlap per assoc then add together*)
								Map[
									Which[
										(*StartDate before dateInUse and EndDate before dateFulfilled - get dateInUse up to EndDate range*)
										LessDateQ[Lookup[#,StartDate],dateInUse]&&LessDateQ[Lookup[#,EndDate],dateFulfilled],
										(Lookup[#,EndDate]-dateInUse),
										
										(*StartDate after dateInUse and EndDate before dateFulfilled - get StartDate up to EndDate range*)
										GreaterDateQ[Lookup[#,StartDate],dateInUse]&&LessDateQ[Lookup[#,EndDate],dateFulfilled],
										(Lookup[#,EndDate]-Lookup[#,StartDate]),
										
										(*StartDate after dateInUse and EndDate after dateFulfilled - get StartDate up to datefulfilled range*)
										GreaterDateQ[Lookup[#,StartDate],dateInUse]&&GreaterDateQ[Lookup[#,EndDate],dateFulfilled],
										(dateFulfilled-Lookup[#,StartDate]),
										
										(*StartDate before dateInUse and EndDate after dateFulfilled - get dateInUse up to datefulfilled range*)
										LessDateQ[Lookup[#,StartDate],dateInUse]&&GreaterDateQ[Lookup[#,EndDate],dateFulfilled],
										(dateFulfilled-dateInUse),
										
										True,
										0 Hour
									]&,
									assocList
								]//Total
							]
						],
						{
							inRangeSciSupportAssoc,
							inRangeRepairAssoc,
							inRangeShippingAssoc
						}
					];
					
					(* UploadResourceStatus has been updated to include corrections as of {2024,11,11,00,00,00} *)
					timeInUse = If[GreaterDateQ[dateFulfilled,DateObject[{2024,11,11,00,00,00}]],
						time,
						(time-Total[Cases[{sciSupportTime,instrRepairTime,shippingMatTime},_?QuantityQ]])
					];
					
					(* count number of qualifications done to end date of fulfillment *)
					qualificationLog = Experiment`Private`fastAssocLookup[fastAssoc, instrument, QualificationLog];
					numberOfQualificationsToDate = If[MatchQ[qualificationLog,{_List..}],
						Length[Select[qualificationLog,LessDateQ[#[[1]],dateFulfilled]&]],
						0
					];
					
					(* count number of maintenances done to end date of fulfillment *)
					maintenanceLog = Experiment`Private`fastAssocLookup[fastAssoc, instrument, MaintenanceLog];
					numberOfMaintenancesToDate = If[MatchQ[maintenanceLog,{_List..}],
						Length[Select[maintenanceLog,LessDateQ[#[[1]],dateFulfilled]&]],
						0
					];
					
					instrumentCost = Experiment`Private`fastAssocLookup[fastAssoc, instrument, Cost];
					
					instrumentDimensions = Experiment`Private`fastAssocLookup[fastAssoc, instrument, Dimensions];
					
					{logDate, Link[instrument],Link[instrumentModel], Link[resource], Link[rootProtocol], timeInUse, numberOfQualificationsToDate, numberOfMaintenancesToDate,instrumentCost,instrumentDimensions}
				]
			],
			instrumentResources
		]
	];
	
	(* Create the Customer Metrics Report Packet *)
	
	(* get the financingTeam Notebook to attach to report in order to avoid making the report public *)
	financingTeamNotebook = Experiment`Private`fastAssocLookup[fastAssoc,myFinancingTeam,DefaultNotebook];
	
	finalCustomerMetricsPacket=<|
		Type-> Object[Report, CustomerMetrics],
		FinancingTeam-> Link[myFinancingTeam,CustomerMetrics],
		StartDate-> convertedStartTime,
		EndDate-> convertedEndTime,
		Replace[ProtocolLog]->protocolLog,
		Replace[DataLog]->dataLog,
		Replace[SamplesLog]->samplesLog,
		Replace[ProtocolSummaryLog]->protocolSummaryLog,
		Replace[TeamThreadUtilizationLog] -> teamThreadUtilizationLog,
		Replace[UserThreadUtilizationLog] -> userThreadUtilizationLog,
		Replace[UserHourLog] -> userHourLog,
		Replace[InstrumentLog] -> instrumentLog,
		Replace[QueueTimesSummary] -> queueTimesSummary,
		Replace[UserUtilizationSummary] -> userUtilizationSummary,
		Notebook-> Link[financingTeamNotebook,Objects]
	|>;
	
	If[TrueQ[upload],
		Upload[finalCustomerMetricsPacket],
		Return[finalCustomerMetricsPacket]
	]
	
];

(* ::Subsubsection::Closed:: *)
(*PlotCustomerMetrics*)
DefineOptions[PlotCustomerMetrics,
	Options:>{
		UploadOption,
		CacheOption,
		EmailOption,
		{
			OptionName -> Target,
			Default -> User,
			Description -> "Indicates the designated target type to receive the generated report where User is for the Financing Team Members that use Command Center, and Company is for Financing Team Leadership. The information, as well as style choice for the report document is dependent on the Target.",
			Pattern:> User|Company,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> EmailRecipients,
			Default -> Author,
			Description -> "Indicates the designated target type to receive the email as email recipent of the generated report where Author is the function author, Customer is for the Financing Team Members that use Command Center, Solutions is for the relevant members of the Solutions team, Sales is for relevant members of Sales Team. Relevant members is decided by the teams.",
			Pattern:> Author|Customer|Solutions|Sales|All|ListableP[Author|Customer|Solutions|Sales|ObjectP[Object[User]]|EmailP],
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> EmailBcc,
			Default -> {},
			Description -> "Indicates the designated target type to receive the email as email Bcc of the generated report where Author is the function author, Customer is for the Financing Team Members that use Command Center, Solutions is for the relevant members of the Solutions team, Sales is for relevant members of Sales Team. Relevant members is decided by the teams.",
			Pattern:> Author|Customer|Solutions|Sales|All|ListableP[Author|Customer|Solutions|Sales|ObjectP[Object[User]]|EmailP],
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> Bin,
			Default -> Day,
			Description -> "Indicates the bin (per day/week/month/year) that is used for plots and analysis of metrics.",
			Pattern:> Day|Week|Month|Year,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> ThreadUtilization,
			Default -> Percent,
			Description -> "Indicates if the Thread Utilization Plot is in the form of Percent of total available threads or absolute Number of of total available threads.",
			Pattern:> Number|Percent,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> ChartStyle,
			Default -> Total,
			Description -> "Indicates if bar charts will show stack of identifiable parent and subprotocol, or show a single bar for parent and subprotocol.",
			Pattern:> Stack|Total,
			Category -> "General",
			AllowNull -> True
		},
		{
			OptionName -> MaxThreads,
			Default -> Max,
			Description -> "Indicates the number of threads used as maximum limit in the calculation of percent utilization.",
			Pattern:> Max|Paid|_Integer|{_Integer...},
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> QueueTimesRange,
			Default -> Delta,
			Description -> "Indicates if the Queue Times range is presented as Cumulative or as Delta between ranges.",
			Pattern:> Delta|Cumulative,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> QueueTimesProtocol,
			Default -> Experiment,
			Description -> "Indicates if the Queue Times data include that for Experiments, Protocols or both.",
			Pattern:> Experiment|Protocol|Both,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> TurnaroundTimes,
			Default -> False,
			Description -> "Indicates if the Turnaround Times Summary for the report period is evaluated. If more than 30% of parent protocols take greater than 3 days to complete, turnaroundTimes table is not shown.",
			Pattern:> BooleanP,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> TurnaroundTimeLimit,
			Default -> 20 Percent,
			Description -> "Indicates the percent limit of protocols completed in 3 days or more that is used as cutoff for determining whether to show the table for Frequency Distribution of Turnaround Times.",
			Pattern:> GreaterEqualP[(20 Percent)],
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> IncludedTurnaroundStatus,
			Default -> {OperatorStart, OperatorReady, OperatorProcessing, InstrumentProcessing, ScientificSupport},
			Description -> "Indicates the types of Status (ProtocolStatusP or OperationStatusP) included in calculation of TurnaroundTime.",
			Pattern:> ListableP[ProtocolStatusP|OperationStatusP],
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> UserUtilizationProtocol,
			Default -> Protocol,
			Description -> "Indicates if the User Utilization data include that for Experiments or Protocols.",
			Pattern:> Experiment|Protocol,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> InstrumentWorkingHours,
			Default -> False,
			Description -> "Indicates if the Instrument Processing times is included in calculations of scientist working hours.",
			Pattern:> BooleanP,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> InstrumentSavings,
			Default -> Purchase,
			Description -> "Indicates if the basis for calculating instrument savings is the total purchase price of the yearly financing cost.",
			Pattern:> Purchase|Finance,
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> RealEstateRate,
			Default -> 71.84 (USD/Power["Feet", 2]), (* as of 2nd Qt of 2024 according to CBRE - https://www.cbre.com/insights/figures/q2-2024-us-life-sciences-figures *)
			Description -> "Indicates the Real Estate Rate (NNN) used in the calculates of Real Estate Savings.",
			Pattern:> GreaterEqualP[0 (USD/Power["Feet", 2])],
			Category -> "General",
			AllowNull -> False
		}
	}
];

(*Error Messages*)
Error::TooManyDays = "The requested report covers too many days (`1` days). Please limit the date range to 365 days.";
Error::MissingReports ="No customer metrics report object(s) were found for `1` for part or all of the specified date range. Please run ReportCustomerMetrics for dates `2` before running `3`.";
(* single team overload *)
PlotCustomerMetrics[myFinancingTeam:ObjectP[Object[Team,Financing]],startDate_?DateObjectQ,endDate_?DateObjectQ,ops:OptionsPattern[]]:=PlotCustomerMetrics[ToList[myFinancingTeam],startDate,endDate,ops];

(* Site overload *)
PlotCustomerMetrics[mySite:ObjectP[Object[Container,Site]],startDate_?DateObjectQ,endDate_?DateObjectQ,ops:OptionsPattern[]]:=Module[
	{siteTeams},
	
	(* get the list of teams that has DefaultExperimentSite set to mySite *)
	siteTeams = Search[
		Object[Team,Financing],
		DefaultExperimentSite == mySite
		&& Status==Active
	];
	
	PlotCustomerMetrics[ToList[siteTeams],startDate,endDate,ops]
	
];

(* core function takes in list of teams combined in a single report *)
PlotCustomerMetrics[myFinancingTeams:{ObjectP[Object[Team,Financing]]..},startDate_?DateObjectQ,endDate_?DateObjectQ,ops:OptionsPattern[]]:=Module[
	{
		safeOps,
		upload,
		cache,
		email,
		emailRecipient,
		emailBcc,
		target,
		threadUtilization,
		chartStyle,
		journeyTeams,
		maxThreads,
		queueTimesRange,
		queueTimesProtocol,
		turnaroundTimes,
		turnaroundTimeLimit,
		includedTurnaroundStatus,
		userUtilizationProtocol,
		instrumentWorkingHours,
		instrumentSavings,
		
		convertedStartTime,
		convertedEndTime,
		fullDateRange,
		totalNumberOfDays,
		bin,
		dateTicks,
		dateTicksComplete,
		
		dateBins,
		numberOfBins,
		numberOfDaysPerBin,
		
		binLabels,
		
		dividers,
		background,
		tableFigureNumbersFootnoteStyle,
		italicFootnoteStyle,
		regularFootnoteStyle,
		
		allReportPackets,
		allBillPackets,
		allFinancingTeamPackets,
		reportFastAssoc,
		billFastAssoc,
		financingTeamsFastAssoc,
		allReports,
		reportDateTuples,
		includedReportTuples,
		includedReports,
		includedBills,
		includedReportDateRange,
		daysNeeded,
		missingReportDates,
		missingReportDateRange,
		sortedReportPackets,
		reportPacketsPerTeam,
		sortedBillPackets,
		billPacketsPerTeam,
		financingTeamNotebooks,
		
		allProtocolLog,
		allSamplesLog,
		allDataLog,
		allInstrumentLog,
		
		uniqueProtocolLogs,
		uniqueProtocolSummaryLogs,
		uniqueSamplesLogs,
		uniqueDataLogs,
		uniqueQueueTimesSummaryLogs,
		uniqueInstrumentLogs,
		
		inRangeProtocolSummaryLogs,
		inRangeProtocolLogs,
		inRangeQueueTimesSummaryLogs,
		inRangeInstrumentLogs,
		inRangeDataLogs,
		inRangeSampleLogs,
		
		binnedProtocolSummaryLogs,
		
		parentProtocolsPerDay,
		subprotocolsPerDay,
		parentSamplesPerDay,
		subprotocolSamplesPerDay,
		parentDataPerDay,
		subprotocolDataPerDay,
		
		numberOfParentProtocols,
		numberOfSubprotocols,
		totalNumberOfProtocols,
		numberOfParentSamples,
		numberOfSubprotocolSamples,
		totalNumberOfSamples,
		numberOfParentData,
		numberOfSubprotocolData,
		totalNumberOfData,
		
		
		protocolBarTicks,
		dailyProtocolBarChartStacked,
		dailyProtocolCountsTotal,
		dailyProtocolBarChartTotal,
		protocolBarChartFigureNumberText,
		dailyProtocolBarChartTitle,
		protocolBarChartNote,
		dailyProtocolBarChartSectionStacked,
		dailyProtocolBarChartSectionTotal,
		
		protocolCountPerBin,
		protocolBinBarChartStacked,
		protocolBinBarChartTotal,
		protocolBinBarChartTitle,
		protocolBinBarChartSectionStacked,
		protocolBinBarChartSectionTotal,
		protocolBarChartSection,
		wordCloudParentProtocols,
		wordCloudProtocolFigureText,
		wordCloudProtocolTitle,
		wordCloudProtocolTitleNote,
		wordCloudProtocolSection,
		
		
		dailySampleCountsStacked,
		dailySampleCountsTotal,
		dailySamplesBarChartStacked,
		dailySamplesBarChartTotal,
		samplesBarChartFigureNumberText,
		dailySamplesBarChartTitle,
		samplesBarChartNote,
		dailySamplesBarChartSectionStacked,
		dailySamplesBarChartSectionTotal,
		sampleCountPerBin,
		protocolSamplesBinBarChartSectionTitle,
		protocolSamplesBinBarChartStacked,
		protocolSamplesBinBarChartTotal,
		protocolSamplesBinBarChartTitle,
		protocolSamplesBinBarChartSectionStacked,
		protocolSamplesBinBarChartSectionTotal,
		samplesBarChartSection,
		
		
		dailyDataCountsStacked,
		dailyDataCountsTotal,
		dailyDataBarChartStacked,
		dailyDataBarChartTotal,
		dataBarChartFigureNumberText,
		dailyDataBarChartTitle,
		dataBarChartNote,
		dailyDataBarChartSectionStacked,
		dailyDataBarChartSectionTotal,
		dataCountPerBin,
		protocolDataBinBarChartStacked,
		protocolDataBinBarChartTotal,
		protocolDataBinBarChartTitle,
		protocolDataBinBarChartSectionStacked,
		protocolDataBinBarChartSectionTotal,
		dataBarChartSection,
		wordCloudParentData,
		wordCloudDataFigureText,
		wordCloudDataTitle,
		wordCloudDataTitleNote,
		wordCloudDataSection,
		
		
		protocolSummaryData,
		protocolSummaryTableColumnLabels,
		protocolSummaryTableRowLabels,
		protocolSummaryTableContents,
		protocolSummaryTable,
		protocolSummaryTableNumber,
		protocolSummaryTableTitle,
		protocolSummaryTableNote,
		protocolSummaryTableSection,
		
		inRangeTeamThreadUtilizationLogs,
		uniqueTeamThreadUtilizationLogs,
		finalTeamThreadUtilizationLogs,
		
		protocolTypePerDataList,
		protocolTypePerSampleList,
		protocolTypeSummary,
		groupedProtocolTypeSummary,
		protocolTypeSummaryTableContents,
		protocolTypeSummaryTables,
		protocolTypeSummaryTableNumber,
		protocolTypeSummaryTableTitle,
		protocolTypeSummaryTableNote,
		protocolTypeSummaryTableSection,
		
		queueTimesParentList,
		queueTimesTotalList,
		queueLessThan5HParentCumulative,
		queueLessThan10HParentCumulative,
		queueLessThan24HParentCumulative,
		queueAbove1DParentCumulative,
		queueLessThan5HParentDelta,
		queueLessThan10HParentDelta,
		queueLessThan24HParentDelta,
		queueAbove1DParentDelta,
		queueLessThan5HTotalCumulative,
		queueLessThan10HTotalCumulative,
		queueLessThan24HTotalCumulative,
		queueAbove1DTotalCumulative,
		queueLessThan5HTotalDelta,
		queueLessThan10HTotalDelta,
		queueLessThan24HTotalDelta,
		queueAbove1DTotalDelta,
		queueTimes1stColumn,
		queueTimes2ndColumn,
		queueTimesSummaryTableColumnLabels,
		queueTimesSummaryTableRowLabels,
		queueTimesSummaryTableContents,
		queueTimesSummaryTable,
		
		
		queueTimeSummaryTableNumber,
		queueTimeSummaryTableTitle,
		totalProtocolQueueTime,
		parentProtocolQueueTime,
		averageProtocolQueueTime,
		averageParentQueueTime,
		averageProtocolQueueTimeString,
		averageParentQueueTimeString,
		meanProtocolQueueTimeNote1,
		averageProtocolQueueTimeCaption1,
		averageProtocolQueueTimeCaption2,
		
		allParentProtocolLogs,
		parseLogParent,
		includedStatusTimesParent,
		turnaroundTimesParent,
		parseLogTotal,
		includedStatusTimesTotal,
		turnaroundTimesTotal,
		turnaroundLessThan1DParent,
		turnaroundLessThan2DParent,
		turnaroundLessThan3DParent,
		turnaroundLessThan5DParent,
		turnaroundAbove3DParent,
		turnaroundAbove5DParent,
		turnaroundLessThan1DTotal,
		turnaroundLessThan2DTotal,
		turnaroundLessThan3DTotal,
		turnaroundLessThan5DTotal,
		turnaroundAbove3DTotal,
		turnaroundAbove5DTotal,
		turnaroundTimesParentText,
		turnaroundTimesTotalText,
		turnaroundTimesSummaryTableColumnLabels,
		turnaroundTimesSummaryTableRowLabels,
		turnaroundTimesSummaryTableContents,
		turnaroundTimesSummaryTableNumber,
		turnaroundTimesSummaryTable,
		turnaroundTimesSummaryTableTitle,
		averageParentTurnaroundTime,
		averageTotalTurnaroundTime,
		turnaroundTimesSummaryCaption1,
		turnaroundTimesSummaryCaption2,
		turnaroundTimesSummaryNote1,
		executionSummaryTableNote1,
		protocolExecutionSummarySection,
		
		protocolMetricsSection,
		protocolMetricsBoolean,
		
		numberTeamThreadUtilizationPlot,
		numberTeamThreadUtilizationTitle,
		numberTeamThreadUtilizationPlotCaption,
		percentUtilizationList,
		maxPercentUtilizationList,
		percentTeamThreadUtilizationPlot,
		percentTeamThreadUtilizationPlotCaption,
		teamThreadUtilizationNumber,
		percentTeamThreadUtilizationTitle,
		threadUtilizationFigure,
		teamEfficiencyMetricsSection,
		teamEfficiencyMetricsBoolean,
		
		allUserUtilizationSummaryLogs,
		uniqueUserUtilizationSummaryLogs,
		inRangeUserUtilizationSummaryLogs,
		groupedUserUtilizationSummaryLogsPerUser,
		userUtilizationData,
		userUtilizationDataString,
		groupedUserUtilizationDataString,
		userUtilizationTableContents,
		userUtilizationTables,
		userUtilizationTableNumber,
		userUtilizationTableTitle,
		totalTeamUserHours,
		averageTeamUserHoursPerDay,
		averageTeamUserHoursPerWeek,
		averageTeamUserHourPerProtocol,
		averageTeamUserHourPerParent,
		averageTeamUserHourPerData,
		averageTeamUserHourPerSample,
		userUtilizationTableCaption3,
		userUtilizationTableFootnote,
		userUtilizationTableCaption1,
		userUtilizationTableCaption2,
		scientistLaborProductivitySummaryText,
		scientistLaborProductivitySection,
		scientistLaborProductivityBoolean,
		numberOfTraditionalWorkers,
		
		totalMaxThreads,
		averageMaxThreadsPerDay,
		maxThreadHours,
		threadUtilizationPercent,
		estAdditionalParentProtocols,
		estAdditionalTotalProtocols,
		totalNumberOfProtocolHours,
		labAccessFeePerDay,
		totalLabAccessFees,
		aveCostPerThreadHour,
		aveCostPerParentProtocol,
		fullUtilizationCostPerParentProtocol,
		aveCostPerProtocol,
		fullUtilizationCostPerProtocol,
		costSavingsPerParentProtocol,
		costSavingsPerProtocol,
		productivityTableData,
		productivityTableColumnLabels,
		productivityTableRowLabels,
		productivityTableContents,
		productivityTable,
		productivityTableNumber,
		productivityTableTitle,
		productivityTableFootnote2,
		productivityTableFigure,
		productivityTableSummaryText,
		productivityTableFootnote1,
		numberOfWeeks,
		allUniqueMembers,
		
		groupedInstrumentUsageSummaryData,
		instrumentSummaryTables,
		instrumentUsageSummaryTableContents,
		totalInstrumentHours,
		groupedInstrumentLogsByInstrumentModel,
		instrumentUsageSummaryByModelData,
		instrumentSummaryTableNumber,
		instrumentSummaryTableNote,
		instrumentSummaryTableTitle,
		instrumentSummaryTableSequence,
		maxInstrumentHours,
		instrumentHoursToImageAssociation,
		instrumentCollage,
		polygon,
		instrumentCollageWithOverlay,
		instrumentCollageFigureText,
		instrumentCollageTitle,
		instrumentCollageNote,
		instrumentCollageFigure,
		instrumentMetricsSection,
		instrumentMetricsBoolean,
		
		
		instrumentTotalCost,
		purchasingInterestRate,
		financingYears,
		instrumentFinancingCostPerYear,
		instrumentDimensions,
		instrumentAreaRequired,
		numberOfBenches,
		realEstateSpace,
		realEstateRate,
		realEstateCostPerYear,
		realEstateCost,
		realEstateUtilitiesMultiplier,
		estimatedUtilitiesCostPerYear,
		estimatedUtilitiesCost,
		estimatedMaintenanceCostPerYear,
		estimatedMaintenanceCost,
		totalInstrumentOwnershipCost,
		numberOfQualificationProtocols,
		numberOfMaintenanceProtocols,
		instrumentTimeChargeAmounts,
		instrumentTimeChargeTotal,
		averageInstrumentTimeChargePerYear,
		instrumentTimeChargePerDay,
		instrumentCostTable,
		instrumentCostTableNumber,
		instrumentCostTableTitle,
		instrumentCostTableCaption,
		instrumentCostTableSection,
		
		laborCostTableNumber,
		laborCostTableTitle,
		threadHoursPerYear,
		estimatedAnnualInstrumentHours,
		laborHoursFullUtilization,
		numberOfWorkersFullUtilization,
		numberOfWorkersActualUtilization,
		numberOfECLUsersFullUtilization,
		averageUserHoursPerWeekActual,
		averageUserHoursPerWeekFull,
		estimatedProtocolHoursPerYear,
		laborHoursActualUtilization,
		annualScientistMeanWage,
		totalScientistSalaryFullUtilization,
		totalScientistSalaryActualUtilization,
		numberOfECLUsersActualUtilization,
		totalECLUserSalaryActualUtilization,
		totalECLUserSalaryFullUtilization,
		laborSavingsActualUtilization,
		laborSavingsFullUtilization,
		laborSavingsFullBoolean,
		laborSavingsTable,
		laborCostTableCaption,
		laborCostTableSection,
		traditionalLabTotalCost,
		eclLabTotalCost,
		totalSavingsTableNumber,
		totalSavingsTableTitle,
		totalSavingsTable,
		totalSavingsTableCaption,
		totalSavingsTableSection,
		
		valuePropositionSection,
		valuePropositionBoolean,
		
		
		reportTitle,
		financingTeamNames,
		docName,
		docNotebookExtension,
		docPDFExtension,
		docPath,
		reportContents,
		expandedContentsWithStyles,
		notebookCells,
		report,
		exportedNb,
		exportedPDF,
		notebookPackets,
		pdfPackets,
		updatedFinancingTeamPackets,
		emailSubject,
		emailContents,
		emailAttachments,
		emailAddressAssociation,
		emailRecipientList,
		emailBccList
		
	},
	
	safeOps=SafeOptions[PlotCustomerMetrics,ToList[ops]];
	
	{upload,cache,email,emailRecipient,emailBcc,target,bin,threadUtilization,maxThreads,queueTimesRange,queueTimesProtocol,turnaroundTimes,turnaroundTimeLimit,includedTurnaroundStatus,userUtilizationProtocol,instrumentWorkingHours,instrumentSavings,realEstateRate,chartStyle}=Lookup[
		safeOps,
		{Upload,Cache,Email,EmailRecipients,EmailBcc,Target,Bin,ThreadUtilization,MaxThreads,QueueTimesRange,QueueTimesProtocol,TurnaroundTimes,TurnaroundTimeLimit,IncludedTurnaroundStatus,UserUtilizationProtocol,InstrumentWorkingHours,InstrumentSavings,RealEstateRate,ChartStyle}
	];
	(* Hard-coding it here until we can finalize how to set apart Journey customers from other Subcription based customers *)
	journeyTeams = {Object[Team, Financing, "id:P5ZnEjZePZ9l"]};(*{Object[Team,Financing,"Bristol Myers Squibb"]}*)
	
	(* set Date related variables *)
	(* Convert the start date to starting second of that date in the "America/Chicago" TimeZone *)
	convertedStartTime=DateObject[
		Join[startDate[[1]],{00,00,00.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	(* Convert the end date to last second of the day in the "America/Chicago" TimeZone - this is to cover the full day of the end date *)
	convertedEndTime=DateObject[
		Join[endDate[[1]],{23,59,59.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	(* get a list of days included between startDate and endDate *)
	fullDateRange = DateRange[convertedStartTime,convertedEndTime,Day];
	
	totalNumberOfDays = Length[fullDateRange];
	
	numberOfWeeks = totalNumberOfDays/(Week/Day);
	
	(* Throw an error if the date range input is more than a year *)
	If[MatchQ[totalNumberOfDays,GreaterP[Year/Day]],
		Message[Error::TooManyDays,totalNumberOfDays];
		Return[$Failed]
	];
	
	(* Search for all report objects for the financing team and select only the report objects that include logged dates between startDate and endDate inputs *)
	allReports=ToList[Search[Object[Report,CustomerMetrics],FinancingTeam==(Alternatives@@myFinancingTeams)]];
	
	(* Verify the there are report objects that covers all the dates requested for the report *)
	
	(* We have to do an initial download of dates before we do the full download to verify date range *)
	(* get the StartDate and EndDate of each included report object - the form will come in the form of the $TimeZone (eg -4 for ET)*)
	(* TODO check individual dates for each team to check if each team has all dates convered - throw a Warning otherwise *)
	reportDateTuples = Download[allReports,{Object,StartDate,EndDate}];
	
	(* Select report tuples that fall within the desired date range - StartDate should not be after the desired convertedEndTime and EndDate should not be before the desired convertedStartTime*)
	includedReportTuples = Select[
		reportDateTuples,
		!(GreaterDateQ[#[[2]],convertedEndTime]||LessDateQ[#[[3]],convertedStartTime])&
	];
	
	(* get all report objects that fall within the initial date range criteria *)
	includedReports = includedReportTuples[[All,1]];
	
	(* the dates need to be converted to "America/Chicago" then manually converted to the form DateObject[{YYYY,MM,DD}] - DayRound will not work since it will first convert to the $TimeZone and mess up the logic of the search dates; followed by creating a list of dates via DateRange and creating a sorted list of all  unique dates included in the reports *)
	includedReportDateRange = Sort[DeleteDuplicates[Join[Sequence@@Map[
		DateRange[
			DateObject[TimeZoneConvert[#[[2]],"America/Chicago"][[1]][[1;;3]]],
			DateObject[TimeZoneConvert[#[[3]],"America/Chicago"][[1]][[1;;3]]]
		]&,
		includedReportTuples
	]]]];
	
	(* create the list of dates needed for the report and check for missing days from the includedReportDateRange *)
	daysNeeded = DateRange[startDate,endDate];
	
	(* get the list of dates needed that are not covered by the exsiting report objects, if any *)
	missingReportDates = Sort[Complement[daysNeeded,includedReportDateRange]];
	
	(* throw an error if there are dates not covered by exisiting report objects *)
	(* TODO redo this to throw Warning instead if not all teams on the list has report objects for the dates requested *)
	If[MatchQ[missingReportDates,{_?DateObjectQ ..}],
		missingReportDateRange = DateString[First[missingReportDates],{"MonthNameShort", " ", "Day", " ", "Year"}]<>" to "<>DateString[Last[missingReportDates],{"MonthNameShort", " ", "Day", " ", "Year"}];
		Message[Error::MissingReports,myFinancingTeams,missingReportDateRange,"PlotCustomerMetrics"];
		Return[$Failed]
	];
	
	(* Search for all included bills - add 2 Day buffer for edge cases of DateCompleted for bills *)
	includedBills = Search[
		Object[Bill],
		Organization == (Alternatives@@myFinancingTeams) &&
			DateCompleted > (convertedStartTime-2 Day) &&
			DateStarted < (convertedEndTime+ 2 Day)
	];
	
	(* Downloads and Packets *)
	{
		allReportPackets,
		allBillPackets,
		allFinancingTeamPackets
	} = Quiet[Download[
		{
			ToList[includedReports],
			ToList[includedBills],
			ToList[myFinancingTeams]
		},
		{
			{
				Packet[DataLog, EndDate, FinancingTeam, InstrumentLog, ProtocolLog, ProtocolSummaryLog, QueueTimesSummary, SamplesLog, StartDate, TeamThreadUtilizationLog, UserHourLog, UserThreadUtilizationLog, UserUtilizationSummary, DateCreated],
				Packet[ProtocolLog[[All,2]][{StatusLog}]],
				Packet[InstrumentLog[[All,3]][{ImageFile}]],
				Packet[UserUtilizationSummary[[All,2]][{FirstName,LastName}]]
			},
			{Packet[InstrumentTimeCharges,DateCreated, DateStarted, DateCompleted, LabAccessFee,Organization]},
			{
				Packet[Name,DefaultNotebook],
				Packet[Members[{Email}]]
			}
		},
		Cache->cache
	],{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];
	
	(* ReverseSortBy packets by date created so when DeleteDuplicatesBy are called, the most recent data is retained *)
	sortedReportPackets=ReverseSortBy[
		Flatten[allReportPackets[[All,1]]],
		Lookup[#,DateCreated]&
	];
	
	(* group all reportPackets of a given team *)
	reportPacketsPerTeam = GatherBy[sortedReportPackets,ObjectP[Lookup[#, FinancingTeam]] &];
	
	sortedBillPackets = ReverseSortBy[
		Flatten[allBillPackets],
		Lookup[#,DateCreated]&
	];
	
	(* group all billPackets of a given team *)
	billPacketsPerTeam = GatherBy[Flatten[sortedBillPackets, 1], ObjectP[Lookup[#, Organization]] &];
	
	(* create FastAssocs for packets for easier look-ups of related fields *)
	reportFastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{cache,Cases[Flatten[allReportPackets], PacketP[]]}]];
	billFastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{cache,Cases[Flatten[allBillPackets], PacketP[]]}]];
	financingTeamsFastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[{cache,Cases[Flatten[allFinancingTeamPackets], PacketP[]]}]];
	
	
	(* Dates and Bin *)
	(* Generate bins of dates that will be used for plotting *)
	(* For Day: list of days; Week: every 7 days since day of convertedStartTime; Month: convertedStartTime day of each month; *)
	dateTicks= DateRange[convertedStartTime,convertedEndTime,bin];
	
	(* If the last day for dateTicks do not included the day of convertedEndTime, it needs to be appended in order to be included in the tick range *)
	dateTicksComplete = If[MatchQ[DateObject[Last[dateTicks],"Day"],DateObject[convertedEndTime,"Day"]],
		dateTicks,
		Append[dateTicks,convertedEndTime]
	];
	
	(* create a list of {first day, last day} of each bin *)
	dateBins = If[MatchQ[bin, Day],
		(* list of {day,day} - eg {{Jun 01, Jun 01}, {Jun 02, Jun 02}..} *)
		Drop[Map[{#,#}&, dateTicks],-1],
		
		(* creates a list of {first day, last day} of each bin - eg {{Jun 8, Jun 14},{Jun 15, Jun 21}..}*)
		MapThread[{#1,#2}&, {Most[dateTicksComplete],Rest[dateTicksComplete]-(23 Hour+59 Minute+59 Second)}]
	];
	
	numberOfBins = Length[dateBins];
	numberOfDaysPerBin = Map[Length[DateRange[#[[1]],#[[2]],Day]]&,dateBins];
	
	(* bin labels depend on the bin in order to display properly on the plots *)
	binLabels = Map[
		Which[
			MatchQ[bin,Month|Week],
			DateString[#[[1]],{"MonthNameShort"," ","Day"}]<>"-"<>DateString[#[[2]],{"MonthNameShort"," ","Day"}],
			
			MatchQ[bin,Day],
			DateString[#[[1]],{"DayNameInitial"," – ","MonthNameShort"," ","Day"}]
		]&,
		dateBins
	];
	
	(* get all relevant field values from the download packets *)
	allProtocolLog = Flatten[Lookup[sortedReportPackets,ProtocolLog],1];
	allSamplesLog=Flatten[Lookup[sortedReportPackets,SamplesLog],1];
	allDataLog=Flatten[Lookup[sortedReportPackets,DataLog],1];
	allInstrumentLog = Flatten[Lookup[sortedReportPackets,InstrumentLog],1];
	allUserUtilizationSummaryLogs = Flatten[Lookup[sortedReportPackets,UserUtilizationSummary],1];
	
	(* delete all redundant logs (with same Log Dates) that may be picked up from reports with overlapping dates *)
	(* delete duplciates with same date completed and same protocol([[2]]) *)
	uniqueProtocolLogs = DeleteDuplicatesBy[allProtocolLog,First&&ObjectP[#[[2]]]&];
	
	(* get ProtocolSummaryLogs for each team, delete duplicates of log date per team, then combine *)
	uniqueProtocolSummaryLogs = Module[{uniqueProtocolSummaryLogsPerTeam,combinedProtocolSummaryLogs},
		(* For each team, get all of the unique ProtocolSummaryLogs (based on LogDate) since multiple reports may include logs for the same date *)
		uniqueProtocolSummaryLogsPerTeam = Map[
			Function[{reportPacket},
				Module[{allprotocolSummaryLogPerTeam},
					(* Lookup the ProtocolSummaryLog from all of the included report packets per Team *)
					allprotocolSummaryLogPerTeam=Flatten[Lookup[Flatten[reportPacket],ProtocolSummaryLog],1];
					
					(* Delete duplicate logs pertaining to the same log date *)
					DeleteDuplicatesBy[allprotocolSummaryLogPerTeam,#[[1]]&]
				]
			],
			reportPacketsPerTeam
		];
		
		(* combined all uniqueProtocolSummaryLogsPerTeam into one big list *)
		combinedProtocolSummaryLogs = Flatten[uniqueProtocolSummaryLogsPerTeam,1];
		
		(* for logs of the same log date, add the elements of each index to get a total for all teams per log date *)
		(* Gather logs of the same date first, then add the elements per grouped logs *)
		Map[
			Function[{groupedLogsByDate},
				
				If[Length[groupedLogsByDate]>1,
					Join[{groupedLogsByDate[[1,1]]},Total[(Rest/@groupedLogsByDate)]],
					First[groupedLogsByDate]
				]
			],
			GatherBy[combinedProtocolSummaryLogs,#[[1]]&]
		]
	];
	
	(* delete duplicates with same date, same sample object([[2]]), same protocol([[3]]) *)
	uniqueSamplesLogs = DeleteDuplicatesBy[allSamplesLog,First&&ObjectP[#[[2]]]&&ObjectP[#[[3]]]&];
	
	(* delete duplicates with same date, same data object([[2]]) *)
	uniqueDataLogs = DeleteDuplicatesBy[allDataLog,First&&ObjectP[#[[2]]]&];
	
	(* get QueueTimesSummary for each team, delete duplicates of log date per team, then combine *)
	uniqueQueueTimesSummaryLogs = Module[{uniqueQueueTimesSummaryPerTeam,combinedQueueTimesSummaryPerTeam},
		(* For each team, get all of the unique QueueTimesSummary (based on LogDate) since multiple reports may include logs for the same date *)
		uniqueQueueTimesSummaryPerTeam = Map[
			Function[{reportPacket},
				Module[{allQueueTimesSummaryPerTeam},
					(* Lookup the QueueTimesSummary from all of the included report packets per Team *)
					allQueueTimesSummaryPerTeam=Flatten[Lookup[Flatten[reportPacket],QueueTimesSummary],1];
					
					(* Delete duplicate logs pertaining to the same log date *)
					DeleteDuplicatesBy[allQueueTimesSummaryPerTeam,#[[1]]&]
				]
			],
			reportPacketsPerTeam
		];
		
		(* combined all uniqueQueueTimesSummaryPerTeam into one big list *)
		combinedQueueTimesSummaryPerTeam = Flatten[uniqueQueueTimesSummaryPerTeam,1];
		
		(* for logs of the same log date, add the elements of each index to get a total for all teams per log date *)
		(* Gather logs of the same date first, then add the elements per grouped logs *)
		Map[
			Function[{groupedLogsByDate},
				If[Length[groupedLogsByDate]>1,
					Join[{groupedLogsByDate[[1,1]]},Total[(Rest/@groupedLogsByDate)]],
					First[groupedLogsByDate]
				]
			],
			GatherBy[combinedQueueTimesSummaryPerTeam,#[[1]]&]
		]
	];
	
	(* delete duplicates with same date, same instrument object([[2]]), same resource([[4]]) *)
	uniqueInstrumentLogs = DeleteDuplicatesBy[allInstrumentLog,First&&ObjectP[#[[2]]]&&ObjectP[#[[4]]]&];
	
	(* get TeamThreadUtilizationLogs for each team, delete duplicates of log date per team, then combine *)
	uniqueTeamThreadUtilizationLogs = Module[{uniqueTeamThreadUtilizationLogPerTeam,combinedTeamThreadUtilizationLogTeam},
		(* For each team, get all of the unique QueueTimesSummary (based on LogDate) since multiple reports may include logs for the same date *)
		uniqueTeamThreadUtilizationLogPerTeam = Map[
			Function[{reportPacket},
				Module[{allTeamThreadUtilizationLogPerTeam},
					(* Lookup the QueueTimesSummary from all of the included report packets per Team *)
					allTeamThreadUtilizationLogPerTeam=Flatten[Lookup[Flatten[reportPacket],TeamThreadUtilizationLog],1];
					
					(* Delete duplicate logs pertaining to the same log date *)
					DeleteDuplicatesBy[allTeamThreadUtilizationLogPerTeam,#[[1]]&]
				]
			],
			reportPacketsPerTeam
		];
		
		(* combined all uniqueQueueTimesSummaryPerTeam into one big list *)
		combinedTeamThreadUtilizationLogTeam = Flatten[uniqueTeamThreadUtilizationLogPerTeam,1];
		
		(* for logs of the same log date, add the elements of each index to get a total for all teams per log date *)
		(* Gather logs of the same date first, then add the elements per grouped logs *)
		Map[
			Function[{groupedLogsByDate},
				If[Length[groupedLogsByDate]>1,
					Join[{groupedLogsByDate[[1,1]]},Total[(Rest/@groupedLogsByDate)]],
					First[groupedLogsByDate]
				]
			],
			GatherBy[combinedTeamThreadUtilizationLogTeam,#[[1]]&]
		]
	];
	
	(* delete duplicates with same date - unique user utilization summary log per date per user([[2]]) *)
	uniqueUserUtilizationSummaryLogs = DeleteDuplicatesBy[allUserUtilizationSummaryLogs,#[[1]]&&ObjectP[#[[2]]]&];
	
	(* get all logs that are in range within start date and end date of report then sort by log date *)
	{
		inRangeProtocolSummaryLogs,
		inRangeProtocolLogs,
		inRangeQueueTimesSummaryLogs,
		inRangeInstrumentLogs,
		inRangeDataLogs,
		inRangeSampleLogs,
		inRangeUserUtilizationSummaryLogs
	}=Map[
		Function[{log},
			SortBy[
				Select[
					log,
					GreaterEqualDateQ[#[[1]],convertedStartTime]&&LessEqualDateQ[#[[1]],convertedEndTime]&
				],
				#[[1]]&
			]
		],
		{
			uniqueProtocolSummaryLogs,
			uniqueProtocolLogs,
			uniqueQueueTimesSummaryLogs,
			uniqueInstrumentLogs,
			uniqueDataLogs,
			uniqueSamplesLogs,
			uniqueUserUtilizationSummaryLogs
		}
	];
	
	(* Grid Options *)
	
	(* set-up general style for Dividers of Grids *)
	dividers = {
		{
			Directive[GrayLevel[0.8],Thickness[2]],
			Directive[GrayLevel[0.8],Thickness[2]],
			{Directive[GrayLevel[0.8]]},
			Directive[GrayLevel[0.8],Thickness[2]]
		},
		{
			Directive[GrayLevel[0.8],Thickness[2]],
			Directive[GrayLevel[0.8],Thickness[2]],
			{Directive[GrayLevel[0.8]]},
			Directive[GrayLevel[0.8],Thickness[2]]
		}
	};
	
	background={{RGBColor[0.5,0.5,0.5,0.15],{None}},{RGBColor[0.5,0.5,0.5,0.15],{None}}};
	
	tableFigureNumbersFootnoteStyle = Sequence@@{FontSize -> 10, FontWeight->Bold,FontFamily -> "Helvetica", FontColor->RGBColor[0.3,0.3,0.3]};
	
	italicFootnoteStyle = Sequence@@{FontSize->10,FontSlant->Italic, FontFamily->"Helvetica", FontColor->RGBColor[0.3,0.3,0.3]};
	regularFootnoteStyle = Sequence@@{FontSize->10, FontFamily->"Helvetica", FontColor->RGBColor[0.3,0.3,0.3]};
	
	(* PROTOCOL METRICS *)
	
	(* get all logs that are for parent protocols *)
	allParentProtocolLogs = Select[inRangeProtocolLogs,MatchQ[#[[3]],ParentProtocol]&];
	
	(* Protocol Summary per Day *)
	(*{"Date", "Parent Protocols", "Subprotocols", "Data Objects (Parent Protocols)", "Data Objects (Subprotocols)","Samples (Parent Protocols)", "Samples (Subprotocols)" }*)
	parentProtocolsPerDay = inRangeProtocolSummaryLogs[[All,2]];
	subprotocolsPerDay = inRangeProtocolSummaryLogs[[All,3]];
	parentDataPerDay = inRangeProtocolSummaryLogs[[All,4]];
	subprotocolDataPerDay = inRangeProtocolSummaryLogs[[All,5]];
	parentSamplesPerDay = inRangeProtocolSummaryLogs[[All,6]];
	subprotocolSamplesPerDay = inRangeProtocolSummaryLogs[[All,7]];
	
	(* Number of Protocols, Data and Samples from ProtocolSummaryLog *)
	(* Protocol *)
	numberOfParentProtocols = Total[Cases[parentProtocolsPerDay,_Integer]];
	numberOfSubprotocols = Total[Cases[subprotocolsPerDay,_Integer]];
	totalNumberOfProtocols = Total[{numberOfParentProtocols,numberOfSubprotocols}];
	
	(* Data *)
	numberOfParentData = Total[Cases[parentDataPerDay,_Integer]];
	numberOfSubprotocolData = Total[Cases[subprotocolDataPerDay,_Integer]];
	totalNumberOfData = Total[{numberOfParentData,numberOfSubprotocolData}];
	
	(* Samples *)
	numberOfParentSamples = Total[Cases[parentSamplesPerDay,_Integer]];
	numberOfSubprotocolSamples = Total[Cases[subprotocolSamplesPerDay,_Integer]];
	totalNumberOfSamples = Total[{numberOfParentSamples,numberOfSubprotocolSamples}];
	
	(* Protocol Summary Metrics *)
	protocolSummaryData = {
		{numberOfParentProtocols, totalNumberOfProtocols},
		{numberOfParentSamples, totalNumberOfSamples},
		{numberOfParentData, totalNumberOfData}
	};
	
	(* Experiments are Parent Protocols, Protocols include Parent Protocols and Subprotocols *)
	protocolSummaryTableColumnLabels={"Experiments", "Protocols"};
	protocolSummaryTableRowLabels={"","Numbers Completed", "Samples Processed", "Data Generated"};
	
	protocolSummaryTableContents=MapThread[
		Prepend[#1,#2]&,
		{
			Prepend[protocolSummaryData,protocolSummaryTableColumnLabels], (* add the Column Label to the columns of data*)
			Style[#,FontFamily->"Arial"]&/@protocolSummaryTableRowLabels (* add Row label to rows of data*)
		}
	];
	
	protocolSummaryTableNumber= Which[
		MatchQ[target,User],
		"TABLE 4",
		
		MatchQ[target,Company],
		"TABLE 6"
	];
	
	(*TODO consolidate Style *)
	protocolSummaryTableTitle= TextCell[Row[{
		Style[protocolSummaryTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["  Summary of Laboratory Productivity between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolSummaryTable = Grid[
		protocolSummaryTableContents,
		Alignment->{{Left,Center},{Left,Center}},
		Frame->All,
		Spacings->{3,1.25},
		Dividers->dividers,
		ItemStyle->{
			{{Directive[FontFamily->"Arial",FontSize->12],FontWeight->Bold},{Directive[FontFamily->"Arial",FontSize->12]}},
			{Directive[FontFamily->"Arial",FontWeight->Bold,FontSize->12]}
		},
		Background->background,
		ItemSize->All
	];
	
	(*TODO consolidate Style *)
	protocolSummaryTableNote = TextCell[Row[{
		Style[protocolSummaryTableNumber<>": ",tableFigureNumbersFootnoteStyle],
		Style["Experiments ",FontSize->10,italicFootnoteStyle],
		Style["include all protocols that are generated by experiment function calls. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Samples Processed ",italicFootnoteStyle],
		Style["include all samples that are key inputs and outputs in the course of an experiment and supporting protocols. These include starting reagents, prepared solutions and analyzed samples. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Data Generated ",italicFootnoteStyle],
		Style["include all data objects that are logged or generated in the course of an experiment including images, measurement values, plots, characterization, analysis results etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	protocolSummaryTableSection = Column[
		{
			protocolSummaryTableTitle,
			protocolSummaryTable,
			protocolSummaryTableNote
		},
		Spacings->{1,0.6}
	];
	
	(* Protocol Execution Summary *)
	(* Queue Times *)
	
	(* get the list of queue time for each parent protocol - time between DateEnqueued and DateCompleted *)
	queueTimesParentList = Cases[allParentProtocolLogs[[All,7]],_?QuantityQ];
	
	(* get the list of queue time for all protocols (parent and sub) - time between DateEnqueued and DateCompleted *)
	queueTimesTotalList = Cases[inRangeProtocolLogs[[All,7]],_?QuantityQ];
	
	(* Mean Protocol Queue Times *)
	
	(* add up queue times *)
	totalProtocolQueueTime = Total[queueTimesTotalList];
	parentProtocolQueueTime = Total[queueTimesParentList];
	
	(* get average queue times *)
	averageProtocolQueueTime = If[MatchQ[Length[queueTimesTotalList],GreaterP[0]],
		Round[UnitScale[totalProtocolQueueTime/Length[queueTimesTotalList]],0.1],
		Null
	];
	averageParentQueueTime = If[MatchQ[Length[queueTimesParentList],GreaterP[0]],
		Round[UnitScale[parentProtocolQueueTime/Length[queueTimesParentList]],0.1],
		Null
	];
	
	(* convert queue time value to string; use N/A if no average queue time is calculated *)
	averageProtocolQueueTimeString = If[MatchQ[averageProtocolQueueTime,_?QuantityQ],
		ToString[averageProtocolQueueTime],
		"N/A"
	];
	averageParentQueueTimeString = If[MatchQ[averageParentQueueTime,_?QuantityQ],
		ToString[averageParentQueueTime],
		"N/A"
	];
	
	(* Parent Queue Times *)
	(* get a list of the number and percentage of parent protocols that fall within a certain queue time range - {number of protocols, percent of protocols} *)
	(* calculate both Delta and Cumulative values *)
	{
		queueLessThan5HParentCumulative,
		queueLessThan10HParentCumulative,
		queueLessThan24HParentCumulative,
		queueAbove1DParentCumulative,
		queueLessThan5HParentDelta,
		queueLessThan10HParentDelta,
		queueLessThan24HParentDelta,
		queueAbove1DParentDelta
	} = Map[
		Function[{rangeCriteria},
			Module[{numberOfProtocols,percentProtocols},
				
				(* get the numebr of protocols that fit the criteria *)
				numberOfProtocols = Select[queueTimesParentList,rangeCriteria]//Length;
				
				(* get the corresponding percentage over total *)
				percentProtocols = If[MatchQ[Length[queueTimesParentList],GreaterP[0]],
					Round[numberOfProtocols/Length[queueTimesParentList]*100,0.1],
					0.0
				];
				
				{numberOfProtocols,percentProtocols}
			]
		],
		{
			MatchQ[#,LessEqualP[5 Hour]]&,
			MatchQ[#,LessEqualP[10 Hour]]&,
			MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,GreaterP[1 Day]]&,
			MatchQ[#,LessEqualP[5 Hour]]&,
			MatchQ[#,GreaterP[5 Hour]]&&MatchQ[#,LessEqualP[10 Hour]]&,
			MatchQ[#,GreaterP[10 Hour]]&&MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,GreaterP[1 Day]]&
		}
	];
	
	(* Total Queue Times *)
	(* get the number and percentage of all protocols that fall within a certain queue time range - {number of protocols, percent of protocols} *)
	{
		queueLessThan5HTotalCumulative,
		queueLessThan10HTotalCumulative,
		queueLessThan24HTotalCumulative,
		queueAbove1DTotalCumulative,
		queueLessThan5HTotalDelta,
		queueLessThan10HTotalDelta,
		queueLessThan24HTotalDelta,
		queueAbove1DTotalDelta
	} = Map[
		Function[{rangeCriteria},
			Module[{numberOfProtocols,percentProtocols},
				
				numberOfProtocols = Select[queueTimesTotalList,rangeCriteria]//Length;
				
				percentProtocols = If[MatchQ[Length[queueTimesTotalList],GreaterP[0]],
					Round[numberOfProtocols/Length[queueTimesTotalList]*100,0.1],
					0.0
				];
				
				{numberOfProtocols,percentProtocols}
			]
		],
		{
			MatchQ[#,LessEqualP[5 Hour]]&,
			MatchQ[#,LessEqualP[10 Hour]]&,
			MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,GreaterP[1 Day]]&,
			MatchQ[#,LessEqualP[5 Hour]]&,
			MatchQ[#,GreaterP[5 Hour]]&&MatchQ[#,LessEqualP[10 Hour]]&,
			MatchQ[#,GreaterP[10 Hour]]&&MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,GreaterP[1 Day]]&
		}
	];
	
	(* we organize the queue times data into two column sets and this is dependent on the Options QueueTimesRange (Cumulative vs Delta) and QueueTimesProtocol (Experiment, Protocol or Both) *)
	
	(* QueueTimesRange Cumulative eg Less than 5 Hours, Less than 10 Hours, Less than 24 Hours etc *)
	(* QueueTimesRange Delta eg Less than 5 Hours, 5-10 Hours, 10-24 Hours etc *)
	
	(* When QueueTimesProtocol is Both - the 1st column depicts data (both Number and Percentage) for the Experiments (Parents only) and the 2nd column depicts the data (both Number and Percentage) for the Protocols (Parent and Sub)*)
	(* When QueueTimesProtocol is either Experiment or Protocol - the 1st Column depicts the Number of Protocols in a given range, and the 2nd column depicts the % of protocols in a given range *)
	
	(* transform data to string with appropriate style *)
	queueTimes1stColumn = Which[
		(* Table depicts cumulative range and includes both Experiment and Protocol values *)
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Both],
		Append[
			Map[
				TextCell[
					Column[
						{
							Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12], (* Number of Experiments *)
							Style["( "<>ToString[#[[2]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"] (* Percent of Experiments *)
						},
						Alignment->Center
					],
					TextAlignment->Center]&,
				{
					queueLessThan5HParentCumulative,
					queueLessThan10HParentCumulative,
					queueLessThan24HParentCumulative,
					queueAbove1DParentCumulative
				}
			],
			Style[averageParentQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		(* Table depicts delta range and includes both Experiment and Protocol values *)
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Both],
		Append[
			Map[
				TextCell[
					Column[
						{
							Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12], (* Number of Experiments *)
							Style["( "<>ToString[#[[2]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"] (* Percent of Experiments *)
						},
						Alignment->Center
					],
					TextAlignment->Center]&,
				{
					queueLessThan5HParentDelta,
					queueLessThan10HParentDelta,
					queueLessThan24HParentDelta,
					queueAbove1DParentDelta
				}
			],
			Style[averageParentQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		(* Table depicts delta range and includes only Experiment values *)
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Experiment],
		Append[
			Map[
				Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12]&, (* Number of Experiments *)
				{
					queueLessThan5HParentDelta,
					queueLessThan10HParentDelta,
					queueLessThan24HParentDelta,
					queueAbove1DParentDelta
				}
			],
			Style[averageParentQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		(* Table depicts cumulative range and includes only Experiment values *)
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Experiment],
		Append[
			Map[
				Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12]&, (* Number of Experiments *)
				{
					queueLessThan5HParentCumulative,
					queueLessThan10HParentCumulative,
					queueLessThan24HParentCumulative,
					queueAbove1DParentCumulative
				}
			],
			Style[averageParentQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		(* Table depicts delta range and includes only Protocol values *)
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Protocol],
		Append[
			Map[
				Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12]&, (* Number of Protocols *)
				{
					queueLessThan5HTotalDelta,
					queueLessThan10HTotalDelta,
					queueLessThan24HTotalDelta,
					queueAbove1DTotalDelta
				}
			],
			Style[averageProtocolQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		(* Table depicts cumulative range and includes only Protocol values *)
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Protocol],
		Append[
			Map[
				Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12]&, (* Number of Protocols *)
				{
					queueLessThan5HTotalCumulative,
					queueLessThan10HTotalCumulative,
					queueLessThan24HTotalCumulative,
					queueAbove1DTotalCumulative
				}
			],
			Style[averageProtocolQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		]
	];
	
	(* transform data to string with appropriate style *)
	queueTimes2ndColumn = Which[
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Both],
		Append[
			Map[
				TextCell[
					Column[
						{
							Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12], (* Number of Protocols *)
							Style["( "<>ToString[#[[2]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"] (* Percent of Protocols *)
						},
						Alignment->Center
					],
					TextAlignment->Center]&,
				{
					queueLessThan5HTotalCumulative,
					queueLessThan10HTotalCumulative,
					queueLessThan24HTotalCumulative,
					queueAbove1DTotalCumulative
				}
			],
			Style[averageProtocolQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Both],
		Append[
			Map[
				TextCell[
					Column[
						{
							Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12], (* Number of Protocols *)
							Style["( "<>ToString[#[[2]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"] (* Percent of Protocols *)
						},
						Alignment->Center
					],
					TextAlignment->Center]&,
				{
					queueLessThan5HTotalDelta,
					queueLessThan10HTotalDelta,
					queueLessThan24HTotalDelta,
					queueAbove1DTotalDelta
				}
			],
			Style[averageProtocolQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic]
		],
		
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Experiment],
		Append[
			Map[
				Style[ToString[#[[2]]]<>"%",FontFamily->"Arial",FontSize->12]&, (* Percentage of Experiments *)
				{
					queueLessThan5HParentDelta,
					queueLessThan10HParentDelta,
					queueLessThan24HParentDelta,
					queueAbove1DParentDelta
				}
			],
			SpanFromLeft
		],
		
		MatchQ[queueTimesRange,Delta]&&MatchQ[queueTimesProtocol,Protocol],
		Append[
			Map[
				Style[ToString[#[[2]]]<>"%",FontFamily->"Arial",FontSize->12]&, (* Percentage of Protocols *)
				{
					queueLessThan5HTotalDelta,
					queueLessThan10HTotalDelta,
					queueLessThan24HTotalDelta,
					queueAbove1DTotalDelta
				}
			],
			SpanFromLeft
		],
		
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Experiment],
		Append[
			Map[
				Style[ToString[#[[2]]]<>"%",FontFamily->"Arial",FontSize->12]&, (* Percentage of Experiments *)
				{
					queueLessThan5HParentCumulative,
					queueLessThan10HParentCumulative,
					queueLessThan24HParentCumulative,
					queueAbove1DParentCumulative
				}
			],
			SpanFromLeft
		],
		
		MatchQ[queueTimesRange,Cumulative]&&MatchQ[queueTimesProtocol,Protocol],
		Append[
			Map[
				Style[ToString[#[[2]]]<>"%",FontFamily->"Arial",FontSize->12]&, (* Percentage of Protocols *)
				{
					queueLessThan5HTotalCumulative,
					queueLessThan10HTotalCumulative,
					queueLessThan24HTotalCumulative,
					queueAbove1DTotalCumulative
				}
			],
			SpanFromLeft
		]
	];
	
	queueTimesSummaryTableColumnLabels=Which[
		(* If both Experiments and Protocols are presented, each column label will have the format Number Started (% Started) *)
		MatchQ[queueTimesProtocol,Both],
		{
			TextCell[
				Column[
					{
						Style["Number of Experiments Started",FontFamily->"Arial",FontSize->12],
						Style["(% of Total Experiments)",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center
			],
			TextCell[
				Column[
					{
						Style["Number of Protocols Started",FontFamily->"Arial",FontSize->12],
						Style["(% of Total Protocols)",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center
			]
		},
		
		(* If only either Experiments OR Protocols is presented, 1st column label is for the Number and the 2nd column label is for percentage *)
		MatchQ[queueTimesProtocol,Experiment],
		{
			Style["Number of Experiments Started",FontFamily->"Arial",FontSize->12],
			Style["% Experiments Started",FontFamily->"Arial",FontSize->12]
		},
		
		MatchQ[queueTimesProtocol,Protocol],
		{
			Style["Number of Protocols Started",FontFamily->"Arial",FontSize->12],
			Style["% Protocols Started",FontFamily->"Arial",FontSize->12]
		}
	];
	
	queueTimesSummaryTableRowLabels=Which[
		MatchQ[queueTimesRange,Delta],
		Style[#,FontFamily->"Arial"]&/@{"Queue Time","Less than 5 Hours","5 - 10 Hours","10 - 24 Hours","Greater than 24 Hours", "Mean Queue Time"},
		
		MatchQ[queueTimesRange,Cumulative],
		Style[#,FontFamily->"Arial"]&/@{"Queue Time","Less than 5 Hours","Less than 10 Hours","Less than 24 Hours","Greater than 24 Hours", "Mean Queue Time"}
	];
	
	(* assemble contents for Grid of Queue Times *)
	queueTimesSummaryTableContents=MapThread[
		Prepend[#1,#2]&,
		{
			Prepend[Transpose[{queueTimes1stColumn,queueTimes2ndColumn}],queueTimesSummaryTableColumnLabels], (* stack each row *)
			queueTimesSummaryTableRowLabels (* prepend this column *)
		}
	];
	
	queueTimeSummaryTableNumber = Which[
		MatchQ[target,User],
		"TABLE 5",
		
		MatchQ[target,Company],
		"TABLE 7"
	];
	
	queueTimeSummaryTableTitle= TextCell[Row[{
		Style[queueTimeSummaryTableNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Frequency Distribution of Queue Times for Shared Instruments for ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	queueTimesSummaryTable = Grid[
		queueTimesSummaryTableContents,
		Alignment->{{Left,Center},{Left,Center}},
		Frame->All,
		Spacings->{1.5,1.5},
		Dividers->
			{
				{
					Directive[GrayLevel[0.8],Thickness[2]],
					Directive[GrayLevel[0.8],Thickness[2]],
					{Directive[GrayLevel[0.8]]},
					Directive[GrayLevel[0.8],Thickness[2]]
				},
				{
					Directive[GrayLevel[0.8],Thickness[2]],
					Directive[GrayLevel[0.8],Thickness[2]],
					{Directive[GrayLevel[0.8]]},
					Directive[GrayLevel[0.8],Thickness[2]],
					Directive[GrayLevel[0.8],Thickness[2]]
				}
			},
		ItemStyle->{
			{{Directive[FontFamily->"Arial",FontSize->12],FontWeight->Bold},{Directive[FontFamily->"Arial",FontSize->12]}},
			{Directive[FontFamily->"Arial",FontWeight->Bold,FontSize->12]}
		},
		Background->background
	];
	
	meanProtocolQueueTimeNote1=TextCell[Row[{
		Style[queueTimeSummaryTableNumber<>": ",tableFigureNumbersFootnoteStyle],
		Style["Queue Time ",italicFootnoteStyle],
		Style["indicates the range of time from the moment an experiment or supporting protocol is enqueued up until the protocol starts running in the lab and does not include time intervals when protocols are in Backlogged status when maximum thread capacity is reached. These only include queue times for protocols that require shared public instruments.",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	averageProtocolQueueTimeCaption1 = TextCell[Row[{
		Style["The ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Experiment Mean Queue Time ",FontSize->14,FontFamily->"Helvetica", FontWeight->Bold,FontColor->RGBColor[0.13,0.13,0.13]],
		Style["for all experiments completed for this report is ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[averageParentQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic],
		Style[".",FontSize->15,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}]];
	
	averageProtocolQueueTimeCaption2 = TextCell[Row[{
		Style["The ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Protocol Mean Queue Time ",FontSize->14,FontFamily->"Helvetica", FontWeight->Bold,FontColor->RGBColor[0.13,0.13,0.13]],
		Style["for all protocols (experiments and supporting protocols) completed for this report is ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[averageProtocolQueueTimeString,FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic],
		Style[".",FontSize->15,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}]];
	
	(* Turnaround Times *)
	(* get the turnaround time for each protocol *)
	(* get time per status in each protocol using ParseLog *)
	parseLogParent = ParseLog[allParentProtocolLogs[[All,2]],StatusLog,Cache->cache];
	parseLogTotal = ParseLog[inRangeProtocolLogs[[All,2]],StatusLog,Cache->cache];
	
	(* get the time included for each includedTurnaroundStatus *)
	includedStatusTimesParent = Lookup[parseLogParent,includedTurnaroundStatus,0 Hour];
	includedStatusTimesTotal = Lookup[parseLogTotal,includedTurnaroundStatus,0 Hour];
	
	(* add up all the times for each protocol *)
	turnaroundTimesParent = Total[includedStatusTimesParent,{2}];
	turnaroundTimesTotal = Total[includedStatusTimesTotal,{2}];
	
	(* get average turnaroundTimes *)
	averageParentTurnaroundTime = If[MatchQ[Length[turnaroundTimesParent],GreaterP[0]],
		Round[UnitScale[Total[turnaroundTimesParent]/Length[turnaroundTimesParent]],0.1],
		0 Second
	];
	averageTotalTurnaroundTime = If[MatchQ[Length[turnaroundTimesTotal],GreaterP[0]],
		Round[UnitScale[Total[turnaroundTimesTotal]/Length[turnaroundTimesTotal]],0.1],
		0 Second
	];
	
	(* get a list of the number and percentage of parent protocols that fall within a certain turnaround time range - {number of protocols, percent of protocols} *)
	{
		turnaroundLessThan1DParent,
		turnaroundLessThan2DParent,
		turnaroundLessThan3DParent,
		turnaroundLessThan5DParent,
		turnaroundAbove3DParent,
		turnaroundAbove5DParent
	} = Map[
		Function[{rangeCriteria},
			Module[{numberOfProtocols,percentProtocols},
				
				numberOfProtocols = Select[turnaroundTimesParent,rangeCriteria]//Length;
				
				percentProtocols = If[MatchQ[Length[turnaroundTimesParent],GreaterP[0]],
					Round[(numberOfProtocols/Length[turnaroundTimesParent])*(100 Percent),0.1],
					0.0 Percent
				];
				
				{numberOfProtocols,percentProtocols}
			]
		],
		{
			MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,LessEqualP[2 Day]]&,
			MatchQ[#,LessEqualP[3 Day]]&,
			MatchQ[#,LessEqualP[5 Day]]&,
			MatchQ[#,GreaterP[3 Day]]&,
			MatchQ[#,GreaterP[5 Day]]&
		}
	];
	
	(* get the number and percentage of all protocols that fall within a certain turnaround time range - {number of protocols, percent of protocols} *)
	{
		turnaroundLessThan1DTotal,
		turnaroundLessThan2DTotal,
		turnaroundLessThan3DTotal,
		turnaroundLessThan5DTotal,
		turnaroundAbove3DTotal,
		turnaroundAbove5DTotal
	} = Map[
		Function[{rangeCriteria},
			Module[{numberOfProtocols,percentProtocols},
				
				numberOfProtocols = Select[turnaroundTimesTotal,rangeCriteria]//Length;
				
				percentProtocols = If[MatchQ[Length[turnaroundTimesTotal],GreaterP[0]],
					Round[(numberOfProtocols/Length[turnaroundTimesTotal])*(100 Percent),0.1],
					0.0 Percent
				];
				
				{numberOfProtocols,percentProtocols}
			]
		],
		{
			MatchQ[#,LessEqualP[1 Day]]&,
			MatchQ[#,LessEqualP[2 Day]]&,
			MatchQ[#,LessEqualP[3 Day]]&,
			MatchQ[#,LessEqualP[5 Day]]&,
			MatchQ[#,GreaterP[3 Day]]&,
			MatchQ[#,GreaterP[5 Day]]&
		}
	];
	
	(* transform data to string with appropriate style *)
	turnaroundTimesParentText = Which[
		(* If parent protocols completed greater than 5 days is less than 5% AND completed greater than 3 days is less than turnaroundTimeLimit, show 3-5 and >5 range *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],LessP[5]],
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DParent,
				turnaroundLessThan2DParent,
				turnaroundLessThan3DParent,
				turnaroundLessThan5DParent,
				turnaroundAbove5DParent
			}
		],
		
		(* If parent protocols completed greater than 5 days is greater than 5% AND completed greater than 3 days is less than turnaroundTimeLimit, show >3 range only *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],GreaterP[5]],
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DParent,
				turnaroundLessThan2DParent,
				turnaroundLessThan3DParent,
				turnaroundAbove3DParent
			}
		],
		
		(* Default show most detail *)
		True,
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DParent,
				turnaroundLessThan2DParent,
				turnaroundLessThan3DParent,
				turnaroundLessThan5DParent,
				turnaroundAbove5DParent
			}
		]
	];
	
	(* transform data to string with appropriate style *)
	turnaroundTimesTotalText = Which[
		(* If parent protocols completed greater than 5 days is less than 5% AND completed greater than 3 days is less than turnaroundTimeLimit, show 3-5 and >5 range *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],LessP[5]],
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DTotal,
				turnaroundLessThan2DTotal,
				turnaroundLessThan3DTotal,
				turnaroundLessThan5DTotal,
				turnaroundAbove5DTotal
			}
		],
		
		(* If parent protocols completed greater than 5 days is greater than 5% AND completed greater than 3 days is less than turnaroundTimeLimit, show >3 range only *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],GreaterP[5]],
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DTotal,
				turnaroundLessThan2DTotal,
				turnaroundLessThan3DTotal,
				turnaroundAbove3DTotal
			}
		],
		
		True,
		Map[
			TextCell[
				Column[
					{
						Style[ToString[#[[1]]],FontFamily->"Arial",FontSize->12],
						Style["( "<>ToString[Unitless[#[[2]]]]<>"% )",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
					},
					Alignment->Center
				],
				TextAlignment->Center]&,
			{
				turnaroundLessThan1DTotal,
				turnaroundLessThan2DTotal,
				turnaroundLessThan3DTotal,
				turnaroundLessThan5DTotal,
				turnaroundAbove5DTotal
			}
		]
	];
	
	turnaroundTimesSummaryTableColumnLabels={
		TextCell[
			Column[
				{
					Style["Number of Experiments Completed",FontFamily->"Arial",FontSize->12],
					Style["(% of Total Experiments)",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
				},
				Alignment->Center
			],
			TextAlignment->Center
		],
		TextCell[
			Column[
				{
					Style["Number of Protocols Completed",FontFamily->"Arial",FontSize->12],
					Style["(% of Total Protocols)",FontFamily->"Arial",FontSize->9,FontSlant->"Italic"]
				},
				Alignment->Center
			],
			TextAlignment->Center
		]
	};
	
	turnaroundTimesSummaryTableRowLabels=Which[
		(* If parent protocols completed greater than 5 days is less than 5% AND completed greater than 3 days is less than 20%, show 3-5 and >5 range *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],LessP[5]],
		Style[#,FontFamily->"Arial"]&/@{"Turnaround Time","Less than 1 Day","Less than 2 Days","Less than 3 Days","Less than 5 Days","Greater than 5 Days"},
		
		(* If parent protocols completed greater than 5 days is greater than 5% AND completed greater than 3 days is less than 20%, show >3 range only *)
		MatchQ[turnaroundAbove3DParent[[2]],LessP[turnaroundTimeLimit]]&&MatchQ[turnaroundAbove5DParent[[2]],GreaterP[5]],
		Style[#,FontFamily->"Arial"]&/@{"Turnaround Time","Less than 1 Day","Less than 2 Days","Less than 3 Days","Greater than 3 Days"},
		
		True,
		Style[#,FontFamily->"Arial"]&/@{"Turnaround Time","Less than 1 Day","Less than 2 Days","Less than 3 Days","Less than 5 Days","Greater than 5 Days"}
	];
	
	(* assemble contents for Grid of Turnaround Times *)
	turnaroundTimesSummaryTableContents=MapThread[
		Prepend[#1,#2]&,
		{
			Prepend[Transpose[{turnaroundTimesParentText,turnaroundTimesTotalText}],turnaroundTimesSummaryTableColumnLabels], (* stack each row *)
			turnaroundTimesSummaryTableRowLabels (* add column for labels *)
		}
	];
	
	turnaroundTimesSummaryTableNumber = Which[
		MatchQ[target,User],
		"TABLE 6",
		
		MatchQ[target,Company],
		"TABLE 8"
	];
	
	turnaroundTimesSummaryTableTitle= TextCell[Row[{
		Style[turnaroundTimesSummaryTableNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Frequency Distribution of Turnaround Times for ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	turnaroundTimesSummaryTable = Grid[
		turnaroundTimesSummaryTableContents,
		Alignment->{{Left,Center},{Left,Center}},
		Frame->All,
		Spacings->{1,1},
		Dividers->dividers,
		ItemStyle->{
			{{Directive[FontFamily->"Arial",FontSize->12],FontWeight->Bold},{Directive[FontFamily->"Arial",FontSize->12]}},
			{Directive[FontFamily->"Arial",FontWeight->Bold,FontSize->12]}
		},
		Background->background
	];
	
	turnaroundTimesSummaryNote1=TextCell[Row[{
		Style[turnaroundTimesSummaryTableNumber<>". ",tableFigureNumbersFootnoteStyle],
		Style["Turnaround Time ",italicFootnoteStyle],
		Style["indicates the range of time an experiment or supporting protocol is running in the lab until its completion, excluding times when protocols are awaiting shipping of materials or times when instruments are awaiting or undergoing vendor repairs.",italicFootnoteStyle]
	}],TextJustification->1];
	
	turnaroundTimesSummaryCaption1 = TextCell[Row[{
		Style["The ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Experiment Mean Turnaround Time ",FontSize->14,FontFamily->"Helvetica", FontWeight->Bold,FontColor->RGBColor[0.13,0.13,0.13]],
		Style["for all experiments completed for this report is ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[averageParentTurnaroundTime],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic],
		Style[".",FontSize->15,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}]];
	
	turnaroundTimesSummaryCaption2 = TextCell[Row[{
		Style["The ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Protocol Mean Turnaround Time ",FontSize->14,FontFamily->"Helvetica", FontWeight->Bold,FontColor->RGBColor[0.13,0.13,0.13]],
		Style["for all protocols (experiments and supporting protocols) completed for this report is ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[averageTotalTurnaroundTime],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontSlant->Italic],
		Style[".",FontSize->15,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}]];
	
	executionSummaryTableNote1=TextCell[Row[{
		Style["Experiments ",italicFootnoteStyle],
		Style["include all protocols that are generated by experiment function calls. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Samples Processed ",italicFootnoteStyle],
		Style["include all samples that are key inputs and outputs in the course of an experiment and supporting protocols. These include starting reagents, prepared solutions and analyzed samples. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Data Generated ",italicFootnoteStyle],
		Style["include all data objects that are logged or generated in the course of an experiment including images, measurement values, plots, characterization, analysis results etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	(* TurnaroundTimes Option, if set to True, can still end up not showing the TurnaroundTimes table if the values are low *)
	(*If more than 30% of parent protocols take greater than 3 days to complete, turnaroundTimes table is not shown *)
	protocolExecutionSummarySection = Which[
		(* TurnaroundTime option is True and mean turnaround times and queue times are reasonable - 3 day, 10 Hour limit, respectively *)
		MatchQ[turnaroundTimes,True]&&MatchQ[averageParentTurnaroundTime,LessEqualP[3 Day]]&&MatchQ[averageTotalTurnaroundTime,LessEqualP[3 Day]]&&MatchQ[averageProtocolQueueTime,LessEqualP[10 Hour]]&&MatchQ[averageParentQueueTime,LessEqualP[10 Hour]],
		Column[
			{
				queueTimeSummaryTableTitle,
				queueTimesSummaryTable,
				meanProtocolQueueTimeNote1,
				"\n",
				turnaroundTimesSummaryCaption1,
				turnaroundTimesSummaryCaption2,
				"\n",
				turnaroundTimesSummaryTableTitle,
				turnaroundTimesSummaryTable,
				turnaroundTimesSummaryNote1,
				executionSummaryTableNote1
			},
			Spacings->{1,0.25}
		],
		(* only Queue Times if mean is reasonable - 10 hour limit *)
		MatchQ[averageProtocolQueueTime,LessEqualP[10 Hour]]&&MatchQ[averageParentQueueTime,LessEqualP[10 Hour]],
		Column[
			{
				queueTimeSummaryTableTitle,
				queueTimesSummaryTable,
				meanProtocolQueueTimeNote1
			},
			Spacings->{1,0.25}
		],
		(* if both criteria don't pass, no execution summary is presented *)
		True,
		Null
	];
	
	(* Completed Protocols *)
	(* Plot Style depends on the number of days included in the report to accommodate the labels properly *)
	
	(* Daily Protocol Bar Chart *)
	protocolBarTicks = Module[{allProtocolDateStrings,allTickLabels,selectedTickLabels},
		
		(*create a list of dates in strings and rotate to fit axis*)
		allProtocolDateStrings = DateString[#, {"DayNameShort", " - ", "MonthNameShort", " ", "Day"}] & /@ fullDateRange;
		
		(*create a list of {position, tick label, {innertick,outertick}}*)
		allTickLabels =Transpose[{Range[Length[allProtocolDateStrings]], allProtocolDateStrings, ConstantArray[{0, -0.005}, Length[allProtocolDateStrings]]}];
		
		(* only selected tick positions are included for wider date range to fit text *)
		selectedTickLabels = Which[
			(* If less than 31 days, all ticks are labeled *)
			MatchQ[totalNumberOfDays,LessEqualP[31]],
			allTickLabels,
			
			(* If between 1-3 months, all Mondays and Fridays are labeled *)
			MatchQ[totalNumberOfDays,GreaterP[31]]&&MatchQ[totalNumberOfDays,LessEqualP[93]],
			Select[allTickLabels, StringContainsQ[#[[2]], "Mon -" | "Fri -"] &],
			
			(* If more than 3 months, 1st and 15th day of the month are labeled *)
			MatchQ[totalNumberOfDays,GreaterP[93]],
			Select[allTickLabels, StringContainsQ[#[[2]], "01" | "15"] &]
		];
		
		(*Rotate the text to appear readable on the axis*)
		MapAt[Rotate[#, Pi/2.25] &, selectedTickLabels, {All, -2}]
		
	];
	
	(* ChartStyle can either be Stacked (parent protocol bar on top of subprotocol) or Total (a single bar to depct parent and sub) *)
	
	(* TODO Consolidate Stack/Total in a single Module *)
	(* Stack must be a list of {parent, sub} *)
	dailyProtocolBarChartStacked = Transpose[{subprotocolsPerDay,parentProtocolsPerDay}];
	
	(* Total: sum of parent and sub *)
	dailyProtocolCountsTotal = MapThread[
		#1+#2&,
		{subprotocolsPerDay,parentProtocolsPerDay}
	];
	
	dailyProtocolBarChartStacked = BarChart[
		dailyProtocolBarChartStacked,
		ChartLayout->"Stacked",
		ChartLegends->Placed[{"Support Protocols","Experiments"}, {Right,Above}],
		LegendAppearance->"Column",
		BarSpacing->None,
		ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Protocols",FontSize->14,FontWeight->Bold]}
	];
	
	dailyProtocolBarChartTotal = BarChart[
		dailyProtocolCountsTotal,
		BarSpacing->None,
		ChartStyle->RGBColor["#0CBD96"],
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Protocols",FontSize->14,FontWeight->Bold]}
	];
	
	(* TODO we keep this as a Which until we finalize the order of the different figures based on the different Target values we would like to apply *)
	protocolBarChartFigureNumberText = Which[
		MatchQ[target,Company],
		"FIGURE 1a",
		MatchQ[target,User],
		"FIGURE 2a",
		True,
		"FIGURE 1a"
	];
	
	dailyProtocolBarChartTitle=TextCell[Row[{
		Style[protocolBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Number of Protocols Completed Daily between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolBarChartNote = TextCell[Row[{
		Style[protocolBarChartFigureNumberText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style[" Experiments ",italicFootnoteStyle],
		Style["include all protocols that are generated by experiment function calls. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	dailyProtocolBarChartSectionStacked = Column[
		{
			dailyProtocolBarChartStacked,
			dailyProtocolBarChartTitle,
			protocolBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	dailyProtocolBarChartSectionTotal = Column[
		{
			dailyProtocolBarChartTotal,
			dailyProtocolBarChartTitle,
			protocolBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	(* Binned Protocol Bar Chart - Weekly or Monthly *)
	(* sort protocol summary logs into Weekly/Monthly bins - this is treated separately from the Daily version because of the layout of the plot labels *)
	binnedProtocolSummaryLogs=Function[singleBin,Select[inRangeProtocolSummaryLogs,GreaterEqualDateQ[#[[1]],First[singleBin]]&&LessEqualDateQ[#[[1]],Last[singleBin]]&]]/@dateBins;
	
	(* get list of counts per bin {{number of subprotocols, number of parent protocols}, total protocols} - to accommodate both Stack and Total forms *)
	(*  {"Date", "Parent Protocols", "Subprotocols", "Data Objects (Parent Protocols)", "Data Objects (Subprotocols)","Samples (Parent Protocols)", "Samples (Subprotocols)" } *)
	protocolCountPerBin = Map[
		Module[{parentProtocolsPerDay,subprotocolsPerDay, numberOfParentProtocols, numberOfSubprotocols},
			
			parentProtocolsPerDay = #[[All,2]];
			
			subprotocolsPerDay = #[[All,3]];
			
			numberOfParentProtocols = Total[Cases[parentProtocolsPerDay,_Integer]];
			
			numberOfSubprotocols = Total[Cases[subprotocolsPerDay,_Integer]];
			
			{
				{numberOfSubprotocols,numberOfParentProtocols},
				numberOfSubprotocols+numberOfParentProtocols
			}
		]&,
		binnedProtocolSummaryLogs
	];
	
	(* TODO Consolidate Stack/Total in a single Module *)
	protocolBinBarChartStacked = Which[
		MatchQ[bin,Month|Week],
		BarChart[
			protocolCountPerBin[[All,1]],
			ChartLayout->"Stacked",
			ChartLabels->{Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],None},
			ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
			ImageSize-> {Automatic,250},
			Frame->{{True,False},{True,False}},
			FrameLabel->{None,Style["Number of Protocols",FontSize->14,FontWeight->Bold]},
			ChartLegends->{"Support Protocols","Experiments"},
			LegendAppearance->"Column"
		],
		
		MatchQ[bin,Day],
		Null
	];
	
	protocolBinBarChartTotal = Which[
		MatchQ[bin,Month|Week],
		BarChart[
			protocolCountPerBin[[All,2]],
			ChartLabels->Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],
			ChartStyle->RGBColor["#0CBD96"],
			ImageSize-> {Automatic,250},
			Frame->{{True,False},{True,False}},
			FrameLabel->{None,Style["Number of Protocols",FontSize->14,FontWeight->Bold]}
		],
		
		MatchQ[bin,Day],
		Null
	];
	
	protocolBinBarChartTitle=TextCell[Row[{
		Style[protocolBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Number of Protocols Completed per",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[Capitalize[StringDelete[ToString[bin],"1"]],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[" between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolBinBarChartSectionStacked = Column[
		{
			protocolBinBarChartStacked,
			protocolBinBarChartTitle,
			protocolBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	protocolBinBarChartSectionTotal = Column[
		{
			protocolBinBarChartTotal,
			protocolBinBarChartTitle,
			protocolBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	protocolBarChartSection = Which[
		MatchQ[bin,Day]&&MatchQ[chartStyle,Total],
		dailyProtocolBarChartSectionTotal,
		
		MatchQ[bin,Day]&&MatchQ[chartStyle,Stack],
		dailyProtocolBarChartSectionStacked,
		
		(* for Weekly/Monthly bins *)
		MatchQ[chartStyle,Total],
		protocolBinBarChartSectionTotal,
		
		MatchQ[chartStyle,Stack],
		protocolBinBarChartSectionStacked,
		
		True,
		dailyProtocolBarChartSectionTotal
		
	];
	
	(* WordCloud for Protocol Types *)
	wordCloudParentProtocols = Module[
		{
			parentProtocolLogs,
			selectParentProtocolLog,
			groupedParentProtocolLogByType,
			protocolAssociation
		},
		(* get all logs for Parent Protocols *)
		parentProtocolLogs = Select[inRangeProtocolLogs,MatchQ[#[[3]],ParentProtocol]&];
		
		(*get a list of all post processing logs from parent protocol logs *)
		selectParentProtocolLog = Select[parentProtocolLogs,!MatchQ[#[[9]],Object[Protocol,ImageSample]|Object[Protocol,MeasureVolume]|Object[Protocol,MeasureWeight]]&];
		
		(* group logs of the same protocol type *)
		groupedParentProtocolLogByType = GatherBy[selectParentProtocolLog, ObjectP[#[[9]]] &];
		
		(* count number of protocol objects per type and create an association with the descriptive text of the protocol type *)
		protocolAssociation = Map[
			Length[#] -> StringDelete[StringDelete[ToString[#[[1]][[9]]], "Object[Protocol, "], "]"] &,
			groupedParentProtocolLogByType
		] /. {"ManualSamplePreparation" -> "MSP", "SampleManipulation" -> "SM", "RoboticSamplePreparation" -> "RSP", "SamplePreparation" -> "SP"};
		
		WordCloud[protocolAssociation, ImageSize -> 500]
	];
	
	wordCloudProtocolFigureText = Which[
		MatchQ[target,Company],
		"FIGURE 1b",
		MatchQ[target,User],
		"FIGURE 2b",
		True,
		"FIGURE 1b"
	];
	
	wordCloudProtocolTitle=TextCell[Row[{
		Style[wordCloudProtocolFigureText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Distribution of Experiment Types Completed between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	wordCloudProtocolTitleNote = TextCell[Row[{
		Style[wordCloudProtocolFigureText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style["The ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[" Relative Number of Hours per Experiment Type ",italicFootnoteStyle],
		Style["is represented by the ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Relative Font Sizes ",italicFootnoteStyle],
		Style["in the figure. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	wordCloudProtocolSection = Column[
		{
			wordCloudParentProtocols,
			wordCloudProtocolTitle,
			wordCloudProtocolTitleNote
		},
		Left,
		Spacings -> 1
	];
	
	
	(* Protocol Samples *)
	(* TODO Consolidate Stack/Total in a single Module *)
	dailySampleCountsStacked = Transpose[{subprotocolSamplesPerDay,parentSamplesPerDay}];
	
	dailySampleCountsTotal = MapThread[
		#1+#2&,
		{subprotocolSamplesPerDay,parentSamplesPerDay}
	];
	
	dailySamplesBarChartStacked = BarChart[
		dailySampleCountsStacked,
		ChartLayout->"Stacked",
		ChartLegends->Placed[{"Support Protocols","Experiments"}, {Right,Above}],
		LegendAppearance->"Column",
		BarSpacing->None,
		ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Samples",FontSize->14,FontWeight->Bold]}
	];
	
	dailySamplesBarChartTotal = BarChart[
		dailySampleCountsTotal,
		LegendAppearance->"Column",
		BarSpacing->None,
		ChartStyle->RGBColor["#0CBD96"],
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Samples",FontSize->14,FontWeight->Bold]}
	];
	
	(* TODO we keep this as a Which until we finalize the order of the different figures based on the different Target values we would like to apply *)
	samplesBarChartFigureNumberText = Which[
		MatchQ[target,Company],
		"FIGURE 2a",
		MatchQ[target,User],
		"FIGURE 3a",
		True,
		"FIGURE 2a"
	];
	
	dailySamplesBarChartTitle=TextCell[Row[{
		Style[samplesBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Number of Samples Processed between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	samplesBarChartNote=TextCell[Row[{
		Style[samplesBarChartFigureNumberText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style["Samples Processed ",italicFootnoteStyle],
		Style["include all samples that are key inputs and outputs in the course of an experiment and supporting protocols. These include starting reagents, prepared solutions and analyzed samples.",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	dailySamplesBarChartSectionStacked = Column[
		{
			dailySamplesBarChartStacked,
			dailySamplesBarChartTitle,
			samplesBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	dailySamplesBarChartSectionTotal = Column[
		{
			dailySamplesBarChartTotal,
			dailySamplesBarChartTitle,
			samplesBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	sampleCountPerBin = Map[
		Module[{parentProtocolSamplesPerDay,subprotocolSamplesPerDay, numberOfParentProtocolSamples, numberOfSubprotocolSamples},
			
			parentProtocolSamplesPerDay = #[[All,6]];
			
			subprotocolSamplesPerDay = #[[All,7]];
			
			numberOfParentProtocolSamples = Total[Cases[parentProtocolSamplesPerDay,_Integer]];
			
			numberOfSubprotocolSamples = Total[Cases[subprotocolSamplesPerDay,_Integer]];
			
			{
				{numberOfSubprotocolSamples,numberOfParentProtocolSamples},
				numberOfSubprotocolSamples+numberOfParentProtocolSamples
			}
		
		]&,
		binnedProtocolSummaryLogs
	];
	
	protocolSamplesBinBarChartSectionTitle = Which[
		MatchQ[bin,Week],
		"Samples Processed per Week",
		
		MatchQ[bin,Month],
		"Samples Processed per Month"
	];
	
	protocolSamplesBinBarChartStacked = BarChart[
		sampleCountPerBin[[All,1]],
		ChartLayout->"Stacked",
		ChartLabels->{Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],None},
		ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
		ImageSize-> {Automatic,250},
		Frame->{{True,False},{True,False}},
		FrameLabel->{None,Style["Number of Samples",FontSize->14,FontWeight->Bold]},
		ChartLegends->{"Support Protocols","Experiments"},
		LegendAppearance->"Column"
	];
	
	protocolSamplesBinBarChartTotal = Which[
		MatchQ[bin,Month|Week],
		BarChart[
			sampleCountPerBin[[All,2]],
			ChartLabels->Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],
			ChartStyle->RGBColor["#0CBD96"],
			ImageSize-> {Automatic,250},
			Frame->{{True,False},{True,False}},
			FrameLabel->{None,Style["Number of Samples",FontSize->14,FontWeight->Bold]}
		],
		
		MatchQ[bin,Day],
		Null
	];
	
	protocolSamplesBinBarChartTitle=TextCell[Row[{
		Style[samplesBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Number of Samples Processed per",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[Capitalize[StringDelete[ToString[bin],"1"]],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[" between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolSamplesBinBarChartSectionStacked = Column[
		{
			protocolSamplesBinBarChartStacked,
			protocolSamplesBinBarChartTitle,
			samplesBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	protocolSamplesBinBarChartSectionTotal = Column[
		{
			protocolSamplesBinBarChartTotal,
			protocolSamplesBinBarChartTitle,
			samplesBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	samplesBarChartSection = Which[
		MatchQ[bin,Day]&&MatchQ[chartStyle,Total],
		dailySamplesBarChartSectionTotal,
		
		MatchQ[bin,Day]&&MatchQ[chartStyle,Stack],
		dailySamplesBarChartSectionStacked,
		
		(* for Weekly/Monthly bins *)
		MatchQ[chartStyle,Total],
		protocolSamplesBinBarChartSectionTotal,
		
		MatchQ[chartStyle,Stack],
		protocolSamplesBinBarChartSectionStacked,
		
		True,
		dailySamplesBarChartSectionTotal
	];
	
	(* Protocol Data *)
	(* TODO Consolidate Stack/Total in a single Module *)
	dailyDataCountsStacked = Transpose[{subprotocolDataPerDay,parentDataPerDay}];
	
	dailyDataCountsTotal = MapThread[
		#1+#2&,
		{subprotocolDataPerDay,parentDataPerDay}
	];
	
	dailyDataBarChartStacked = BarChart[
		dailyDataCountsStacked,
		ChartLayout->"Stacked",
		ChartLegends->Placed[{"Support Protocols","Experiments"}, {Right,Above}],
		LegendAppearance->"Column",
		BarSpacing->None,
		ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Data Object(s)",FontSize->14,FontWeight->Bold]}
	];
	
	dailyDataBarChartTotal = BarChart[
		dailyDataCountsTotal,
		LegendAppearance->"Column",
		BarSpacing->None,
		ChartStyle->RGBColor["#0CBD96"],
		ImageSize-> {Automatic,375},
		Frame->{{True,False},{True,False}},
		FrameTicks -> {{Automatic,None},{protocolBarTicks,None}},
		FrameLabel->{None,Style["Number of Data Object(s)",FontSize->14,FontWeight->Bold]}
	];
	
	(* TODO we keep this as a Which until we finalize the order of the different figures based on the different Target values we would like to apply *)
	dataBarChartFigureNumberText = Which[
		MatchQ[target,Company],
		"FIGURE 3a",
		MatchQ[target,User],
		"FIGURE 4a",
		True,
		"FIGURE 3a"
	];
	
	dailyDataBarChartTitle=TextCell[Row[{
		Style[dataBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Number of Data Object(s) Generated between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	dataBarChartNote=TextCell[Row[{
		Style[dataBarChartFigureNumberText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style["Data Generated ",italicFootnoteStyle],
		Style["include all data objects that are logged or generated in the course of an experiment including images, measurement values, plots, characterization, analysis results etc.",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	dailyDataBarChartSectionStacked = Column[
		{
			dailyDataBarChartStacked,
			dailyDataBarChartTitle,
			dataBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	dailyDataBarChartSectionTotal = Column[
		{
			dailyDataBarChartTotal,
			dailyDataBarChartTitle,
			dataBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	dataCountPerBin = Map[
		Module[{parentProtocolDataPerDay,subprotocolDataPerDay, numberOfParentProtocolData, numberOfSubprotocolData},
			
			parentProtocolDataPerDay = #[[All,4]];
			
			subprotocolDataPerDay = #[[All,5]];
			
			numberOfParentProtocolData = Total[Cases[parentProtocolDataPerDay,_Integer]];
			
			numberOfSubprotocolData = Total[Cases[subprotocolDataPerDay,_Integer]];
			
			{
				{numberOfSubprotocolData,numberOfParentProtocolData},
				numberOfSubprotocolData+numberOfParentProtocolData
			}
		
		]&,
		binnedProtocolSummaryLogs
	];
	
	protocolDataBinBarChartStacked = BarChart[
		dataCountPerBin[[All,1]],
		ChartLayout->"Stacked",
		ChartLabels->{Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],None},
		ChartStyle->{RGBColor["#C2EBE7"],RGBColor["#0CBD96"]},
		ImageSize-> {Automatic,250},
		Frame->{{True,False},{True,False}},
		FrameLabel->{None,Style["Number of Data Object(s)",FontSize->14,FontWeight->Bold]},
		ChartLegends->{"Support Protocols","Experiments"},
		LegendAppearance->"Column"
	];
	
	protocolDataBinBarChartTotal = Which[
		MatchQ[bin,Month|Week],
		BarChart[
			dataCountPerBin[[All,2]],
			ChartLabels->Placed[binLabels,Axis,Rotate[#,Pi/2.5]&],
			
			ChartStyle->RGBColor["#0CBD96"],
			ImageSize-> {Automatic,250},
			Frame->{{True,False},{True,False}},
			FrameLabel->{None,Style["Number of Samples",FontSize->14,FontWeight->Bold]}
		],
		
		MatchQ[bin,Day],
		Null
	];
	
	protocolDataBinBarChartTitle=TextCell[Row[{
		Style[dataBarChartFigureNumberText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Number of Data Object(s) Generated per",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[Capitalize[StringDelete[ToString[bin],"1"]],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[" between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolDataBinBarChartSectionStacked = Column[
		{
			protocolDataBinBarChartStacked,
			protocolDataBinBarChartTitle,
			dataBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	protocolDataBinBarChartSectionTotal = Column[
		{
			protocolDataBinBarChartTotal,
			protocolDataBinBarChartTitle,
			dataBarChartNote
		},
		Left,
		Spacings -> 1
	];
	
	dataBarChartSection = Which[
		MatchQ[bin,Day]&&MatchQ[chartStyle,Total],
		dailyDataBarChartSectionTotal,
		
		MatchQ[bin,Day]&&MatchQ[chartStyle,Stack],
		dailyDataBarChartSectionStacked,
		
		(* for Weekly/Monthly bins *)
		MatchQ[chartStyle,Total],
		protocolDataBinBarChartSectionTotal,
		
		MatchQ[chartStyle,Stack],
		protocolDataBinBarChartSectionStacked,
		
		True,
		dailyDataBarChartSectionTotal
	];
	
	(* WordCloud for Data Types *)
	wordCloudParentData = Module[
		{
			parentDataLogs,
			selectParentDataLog,
			groupedParentDataLogByType,
			dataAssociation
		},
		(* get all logs for Parent Protocols *)
		parentDataLogs = Select[inRangeDataLogs,MatchQ[#[[4]],ParentProtocol]&];
		
		(*get a list of all post processing logs from parent protocol logs *)
		selectParentDataLog = Select[parentDataLogs,!MatchQ[#[[7]],Object[Data,Appearance]|Object[Data,Volume]|Object[Data,Weight]]&];
		
		(* group logs of the same protocol type *)
		groupedParentDataLogByType = GatherBy[selectParentDataLog, ObjectP[#[[7]]] &];
		
		(* count number of protocol objects per type and create an association with the descriptive text of the protocol type *)
		dataAssociation = Map[
			Length[#] -> StringDelete[StringDelete[ToString[#[[1]][[7]]], "Object[Data, "], "]"] &,
			groupedParentDataLogByType
		];
			
		WordCloud[dataAssociation, ImageSize -> 500]
	];
	
	wordCloudDataFigureText = Which[
		MatchQ[target,Company],
		"FIGURE 3b",
		MatchQ[target,User],
		"FIGURE 4b",
		True,
		"FIGURE 3b"
	];
	
	wordCloudDataTitle=TextCell[Row[{
		Style[wordCloudDataFigureText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Distribution of Data Types for Experiments Completed between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	wordCloudDataTitleNote = TextCell[Row[{
		Style[wordCloudDataFigureText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style["The ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[" Relative Number of Data Object(s) per Data Type ",italicFootnoteStyle],
		Style["is represented by the ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Relative Font Sizes ",italicFootnoteStyle],
		Style["in the figure. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	wordCloudDataSection = Column[
		{
			wordCloudParentData,
			wordCloudDataTitle,
			wordCloudDataTitleNote
		},
		Left,
		Spacings -> 1
	];
	
	(* Protocol Type Summary *)
	protocolTypeSummaryTableNumber = Which[
		MatchQ[target,User]&&MatchQ[turnaroundTimes,True],
		"TABLE 7",
		MatchQ[target,User]&&MatchQ[turnaroundTimes,False],
		"TABLE 6",
		MatchQ[target,Company]&&MatchQ[turnaroundTimes,True],
		"TABLE 9",
		MatchQ[target,Company]&&MatchQ[turnaroundTimes,False],
		"TABLE 8"
	];
	
	protocolTypeSummaryTableTitle= TextCell[Row[{
		Style[protocolTypeSummaryTableNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Summary of Laboratory Productivity by Protocol Type Completed between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	protocolTypeSummaryTableNote=TextCell[Row[{
		Style[protocolTypeSummaryTableNumber<>": ",tableFigureNumbersFootnoteStyle],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Samples Processed ",italicFootnoteStyle],
		Style["include all samples that are key inputs and outputs in the course of an experiment and supporting protocols. These include starting reagents, prepared solutions and analyzed samples. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Data Generated ",italicFootnoteStyle],
		Style["include all data objects that are logged or generated in the course of an experiment including images, measurement values, plots, characterization, analysis results etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	(* get the Protocol Type associated with each Data log *)
	protocolTypePerDataList = Download[inRangeDataLogs[[All, 3]], Type];
	
	(* get the Protocol Type associated with each Sample log *)
	protocolTypePerSampleList = Download[inRangeSampleLogs[[All, 3]], Type];
	
	protocolTypeSummary = Module[{groupedProtocolsByType, protocolTypeAndCountTuple},
		
		(*Gather protocols by type then sort based on number of protocols per type - highest number of protocols first *)
		groupedProtocolsByType = ReverseSortBy[GatherBy[inRangeProtocolLogs,#[[9]]&],Length&];
		
		protocolTypeAndCountTuple = Map[
			Module[{protocolType,protocolTypeString,numberOfProtocols,numOfDataObjects,numOfSampleObjects},
				
				(* each group will share the same protocol type so just get the type of the first element*)
				protocolType = #[[1]][[9]];
				
				protocolTypeString = StringDelete[
					StringDelete[
						ToString[protocolType],
						"Object[Protocol, "
					],
					"]"
				];
				
				(* get the number of protocols of the type *)
				numberOfProtocols = Length[#];
				
				(* get the number of data objects from teh data log associated with the protocolType *)
				numOfDataObjects = Length[Select[protocolTypePerDataList, MatchQ[#,protocolType]&]];
				
				(* get the number of sample objects from the sample log associated with the protocolType *)
				numOfSampleObjects = Length[Select[protocolTypePerSampleList, MatchQ[#,protocolType]&]];
				
				(* if no Data objects are generated from the protocol type, replace 0 with "N/A" *)
				{protocolTypeString,{numberOfProtocols,numOfSampleObjects,numOfDataObjects/.EqualP[0]->"N/A"}}
			
			]&,
			groupedProtocolsByType
		]
	];
	
	(* We need to divide the full list of protocolTypeSummary into groups of 15 so the tables generated do not get cut off when converted to PDF *)
	groupedProtocolTypeSummary = Partition[protocolTypeSummary,UpTo[15]];
	
	(* The data is arranged with the appropriate row and column labels to work with the Grid call for the table design layout where row and column headers have gray background *)
	protocolTypeSummaryTableContents = Map[
		Function[{protocolTypeSummaryData},
			Module[{protocolSummaryTypeTableColumnLabels,protocolSummaryTypeTableRowLabels},
				
				protocolSummaryTypeTableColumnLabels={"Protocols Completed","Samples Processed","Data Generated"};
				protocolSummaryTypeTableRowLabels=Prepend[protocolTypeSummaryData[[All,1]],"Protocol Type"];
				
				MapThread[
					Prepend[#1,#2]&,
					{
						Prepend[protocolTypeSummaryData[[All,2]],protocolSummaryTypeTableColumnLabels], (* stack each row *)
						Style[#,FontFamily->"Arial"]&/@protocolSummaryTypeTableRowLabels (* add the column that has teh row labels *)
					}
				]
			
			]
		],
		groupedProtocolTypeSummary
	];
	
	(* since the contents are subdivided into a certain length in order to limit table size per page, create a table for each set of contents with a Note at the bottom *)
	protocolTypeSummaryTables=Map[
		Column[{
			Grid[
				#,
				Alignment->{{Left,Center},{Left,Center}},
				Frame->All,
				Spacings->{1.5,1.5},
				Dividers->dividers,
				ItemStyle->{
					{{Directive[FontFamily->"Arial",FontSize->12],FontWeight->Bold},{Directive[FontFamily->"Arial",FontSize->12]}},
					{Directive[FontFamily->"Arial",FontWeight->Bold,FontSize->12]}
				},
				Background->background
			],
			protocolTypeSummaryTableNote
		},Alignment->Left,Spacings->1]&,
		protocolTypeSummaryTableContents
	];
	
	(* Each table must be inside a list and the tables turned into a Sequence in order for ExportReport to interpret it properly *)
	protocolTypeSummaryTableSection = Sequence@@MapIndexed[
		If[MatchQ[#2,{1}],
			{#,None},
			{#,PageBreakAbove->True}
		]&,
		protocolTypeSummaryTables
	];
	
	protocolMetricsSection=If[MatchQ[protocolExecutionSummarySection,Null],
		{
			{Section,"PROTOCOL METRICS",PageBreakAbove->True},
			{Subsubsection,"Protocol Metrics Summary",None},
			{protocolSummaryTableSection,None},
			{Subsubsection,"Protocols Completed",PageBreakAbove->True},
			{protocolBarChartSection,None},
			{Text," ",None},
			{wordCloudProtocolSection,None},
			{Subsubsection,"Samples Processed",PageBreakAbove->True},
			{samplesBarChartSection,None},
			{Subsubsection,"Data Generated",PageBreakAbove->True},
			{dataBarChartSection,None},
			{Text," ",None},
			{wordCloudDataSection,None},
			{Subsubsection,"Protocol Type Summary",PageBreakAbove->True},
			{protocolTypeSummaryTableTitle,None},
			protocolTypeSummaryTableSection
		},
		{
			{Section,"PROTOCOL METRICS",PageBreakAbove->True},
			{Subsubsection,"Protocol Metrics Summary",None},
			{protocolSummaryTableSection,None},
			{Subsubsection,"Protocol Execution Summary",None},
			{protocolExecutionSummarySection,None},
			{Subsubsection,"Protocols Completed",PageBreakAbove->True},
			{protocolBarChartSection,None},
			{Text," ",None},
			{wordCloudProtocolSection,None},
			{Subsubsection,"Samples Processed",PageBreakAbove->True},
			{samplesBarChartSection,None},
			{Subsubsection,"Data Generated",PageBreakAbove->True},
			{dataBarChartSection,None},
			{Text," ",None},
			{wordCloudDataSection,None},
			{Subsubsection,"Protocol Type Summary",PageBreakAbove->True},
			{protocolTypeSummaryTableTitle,None},
			protocolTypeSummaryTableSection
		}
	];
	
	(* TEAM EFFICIENCY METRICS *)
	
	inRangeTeamThreadUtilizationLogs = Select[uniqueTeamThreadUtilizationLogs,GreaterEqualDateQ[#[[1]],convertedStartTime]&&LessEqualDateQ[#[[1]],convertedEndTime-1 Second]&];
	
	finalTeamThreadUtilizationLogs = Which[
		(* Max uses actual MaxThreads indicated in the financing team accounts *)
		MatchQ[maxThreads,Max],
		inRangeTeamThreadUtilizationLogs,
		
		(* TODO uncomment this once we have values of PaidThreads from Finance
		(* Paid uses PaidThreads indicated in the financing team accounts, which can be different from MaxThreads *)
		MatchQ[maxThreads,Paid],
		Module[{paidThreads},
			paidThreads = Map[
				Download[
					myFinancingTeam,
					PaidThreads,
					Date->#[[1]]
				]&,
				inRangeTeamThreadUtilizationLogs
			];
			MapThread[
				{#1[[1]],#2,#1[[3]]}&,
				{inRangeTeamThreadUtilizationLogs,paidThreads}
			]
		],
		*)
		
		(* If MaxThreads option is given an integer input, replace the 3 element in each log with the given option *)
		MatchQ[maxThreads,_Integer],
		{#[[1]], #[[2]] /. _-> maxThreads, #[[3]]} & /@inRangeTeamThreadUtilizationLogs
	];
	(* Productivity Table and Utilization Analysis *)
	
	(* Utilization Analysis - results are shown in take-away bullet points and texts before the Productivity Table *)
	
	(* get the total number of max threads available for the duration of the report *)
	(* add all MaxThreads ([[2]]) per day *)
	totalMaxThreads = Total[Map[
		If[MatchQ[#[[2]],_Integer],
			#[[2]],
			0
		]&,
		finalTeamThreadUtilizationLogs
	]];
	
	(* get the average maxThreads per day by dividing total by number of days *)
	averageMaxThreadsPerDay = Round[totalMaxThreads/totalNumberOfDays];
	
	(* multiply total number of threads by 24 hours to get total number of hours available for protocol runs *)
	maxThreadHours = totalMaxThreads*24 Hour;
	
	(* get the total number of hours utilized for protocol runs - we use this in calculation of utilization percentage *)
	totalNumberOfProtocolHours = If[MatchQ[inRangeProtocolLogs,Except[{}]],
		Total[Map[
			Module[{protocolClassification,dateEnqueued,dateCompleted},
				
				(* parent or sub *)
				protocolClassification=#[[3]];
				
				dateEnqueued=#[[4]];
				dateCompleted=#[[6]];
				
				Which[
					(* don't count any subprotocol time since it is already included in parent protocol time *)
					MatchQ[protocolClassification,Subprotocol],
					0 Hour,
					
					(* for any dates that are not in DateObjectQ form *)
					!MatchQ[dateCompleted,_?DateObjectQ]||!MatchQ[dateEnqueued,_?DateObjectQ],
					0 Hour,
					
					(*if the DateStarted of the protocol is before the date range of this report, we count only the protocol hours inside the report to avoid redundancies*)
					GreaterDateQ[dateCompleted,dateEnqueued]&&GreaterDateQ[convertedStartTime,dateEnqueued]&&GreaterDateQ[convertedEndTime,dateCompleted],
					((AbsoluteTime[dateCompleted]-AbsoluteTime[convertedStartTime])/3600)*Hour,
					
					(*if the DateStarted and DateCompleted of the protocol falls within the date range of this report, we count the entire protocol run duration*)
					GreaterDateQ[dateCompleted,dateEnqueued]&&GreaterDateQ[dateEnqueued,convertedStartTime]&&GreaterDateQ[convertedEndTime,dateCompleted],
					((AbsoluteTime[dateCompleted]-AbsoluteTime[dateEnqueued])/3600)*Hour,
					
					(*if there are erroneous values, such as Null dates, we set to 0 Hour duration*)
					True,
					0 Hour
				]
			]&,
			inRangeProtocolLogs
		]],
		0 Hour
	];
	
	(* Cost Analysis based on Threads *)
	(* pro-rate the lab access fee per bill per team and add all the fees *)
	totalLabAccessFees = Total[Cases[Map[
		Module[{allBillDays,numberOfDaysIncluded,labAccessFeePerDay},
			(* get the days included in each bill *)
			allBillDays=DateRange[
				DateObject[TimeZoneConvert[Lookup[#,DateStarted],"America/Chicago"][[1]][[1;;3]]],
				DateObject[TimeZoneConvert[Lookup[#,DateCompleted],"America/Chicago"][[1]][[1;;3]]]
			];
			
			(* get the LabAccessFee per day for each bill *)
			labAccessFeePerDay = Lookup[#,LabAccessFee]/Length[allBillDays];
			
			(* identify the number of days to be included in the report that is accounted for in the bill *)
			numberOfDaysIncluded=Length[Intersection[allBillDays,daysNeeded]];
			
			(* get the lab access fee to be accounted for in the report from the bill by multiplying the fee per day to number of days included in the report *)
			labAccessFeePerDay*numberOfDaysIncluded
		]&,
		sortedBillPackets
	],_?QuantityQ]];
	
	(* get the average lab access fee per day by dividing the totalLabAccessFees by the days included in the report *)
	labAccessFeePerDay = totalLabAccessFees/Length[daysNeeded];
	
	(* get the estimated number of additional parent protocols that could run with 100% utilization *)
	(* sometimes hyperthreading can occur or 100% utilization can occur- in which case, no additional protocols can be performed and set to 0*)
	estAdditionalParentProtocols = If[MatchQ[maxThreadHours,GreaterP[totalNumberOfProtocolHours]&&MatchQ[totalNumberOfProtocolHours,GreaterP[0 Hour]]],
		Round[(numberOfParentProtocols/totalNumberOfProtocolHours)*(maxThreadHours-totalNumberOfProtocolHours),1],
		0
	];
	
	(* get the estimated number of additional protocols that could run with 100% utilization: number of protocols per hour * unused hours *)
	(* sometimes hyperthreading can occur or 100% utilization can occur- in which case, no additional protocols can be performed and set to 0*)
	estAdditionalTotalProtocols = If[MatchQ[maxThreadHours,GreaterP[totalNumberOfProtocolHours]&&MatchQ[totalNumberOfProtocolHours,GreaterP[0 Hour]]],
		Round[(totalNumberOfProtocols/totalNumberOfProtocolHours)*(maxThreadHours-totalNumberOfProtocolHours),1],
		0
	];
	
	(* cost per thread hour available to customers based on lab access fee and pro-rated to the number of days included in the report *)
	aveCostPerThreadHour = If[MatchQ[maxThreadHours,GreaterP[0 Hour]],
		Unitless[Round[totalLabAccessFees/maxThreadHours,0.01]],
		0 USD/Hour
	];
	
	(* cost per parent protocol based on lab access fee *)
	aveCostPerParentProtocol = If[MatchQ[numberOfParentProtocols,GreaterP[0]],
		Unitless[Round[totalLabAccessFees/numberOfParentProtocols,0.01]],
		0 USD
	];
	
	(* cost per parent protocol based on lab access fee if utilization is maximized *)
	fullUtilizationCostPerParentProtocol = If[MatchQ[numberOfParentProtocols+estAdditionalParentProtocols,GreaterP[0]],
		Unitless[Round[totalLabAccessFees/(numberOfParentProtocols+estAdditionalParentProtocols),0.01]],
		0 USD
	];
	
	(* cost per protocol based on lab access fee *)
	aveCostPerProtocol = If[MatchQ[totalNumberOfProtocols,GreaterP[0]],
		Unitless[Round[totalLabAccessFees/totalNumberOfProtocols,0.01]],
		0 USD
	];
	
	(* cost per protocol based on lab access fee if utilization is maximized *)
	fullUtilizationCostPerProtocol = If[MatchQ[totalNumberOfProtocols+estAdditionalTotalProtocols,GreaterP[0]],
		Unitless[Round[totalLabAccessFees/(totalNumberOfProtocols+estAdditionalTotalProtocols),0.01]],
		0 USD
	];
	
	(* percent savings per parent protocol with full utilization *)
	costSavingsPerParentProtocol = If[MatchQ[aveCostPerProtocol,GreaterP[0 USD]],
		((aveCostPerParentProtocol-fullUtilizationCostPerParentProtocol)/aveCostPerParentProtocol)*100,
		0 USD
	];
	
	(* percent savings per protocol with full utilization *)
	costSavingsPerProtocol = If[MatchQ[aveCostPerProtocol,GreaterP[0 USD]],
		((aveCostPerProtocol-fullUtilizationCostPerProtocol)/aveCostPerProtocol)*100,
		0 USD
	];
	
	(* get the utilization percentage by dividing the number of hours used for protocol runs over maximum number of hours available to use *)
	threadUtilizationPercent = If[MatchQ[maxThreadHours,GreaterP[0 Hour]],
		Round[(totalNumberOfProtocolHours/maxThreadHours)*100,1],
		0
	];
	
	(* A summary of of costs per protocol/experiment run, time used and projection at full utilization is added before the table *)
	productivityTableSummaryText = Column[{
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["It costs an average of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["$"<>ToString[aveCostPerThreadHour],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
			Style[" per available hour to run a protocol.",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
		}],TextJustification->1],
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["It costs an average of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["$"<>ToString[aveCostPerProtocol],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
			Style[" per protocol ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[" and an average of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["$"<>ToString[aveCostPerParentProtocol],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
			Style[" per experiment.",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
		}],TextJustification->1],
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style["The team utilized ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[Round[totalNumberOfProtocolHours,1]],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
			Style[" out of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[Round[maxThreadHours,1]],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[" available to run ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[numberOfParentProtocols]<>" experiments.",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black]
		}]],
		If[MatchQ[threadUtilizationPercent,GreaterEqualP[100]],
			TextCell[Row[{
				Style[" If you'd like assistance in increasing capacity and bringing online more workflows, please contact our ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
				Style["Solutions Team",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic],
				Style[" at ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
				Style["solutions@emeraldcloudlab.com",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic],
				Style[".",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic]
			}],TextJustification->1],
			TextCell[Row[{
				Style["The team could run ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontWeight->Bold],
				Style[ToString[estAdditionalParentProtocols]<>" additional experiments",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor["#299984"],FontWeight->Bold],
				Style[" with the same cost at full utilization ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontWeight->Bold],
				Style["with an average of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style["$"<>ToString[fullUtilizationCostPerProtocol],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
				Style[" per protocol ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[" and an average of ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style["$"<>ToString[fullUtilizationCostPerParentProtocol],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->Black],
				Style[" per experiment.",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[" If you'd like assistance bringing online new workflows to run with your available capacity, please contact our ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
				Style["Solutions Team",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic],
				Style[" at ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
				Style["solutions@emeraldcloudlab.com",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic],
				Style[".",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic]
			}],TextJustification->1]
		]
	}];
	
	(* Productivity Table - Summary of Protocols and Experiments Completed (Current vs Actual)*)
	productivityTableData = If[MatchQ[threadUtilizationPercent,GreaterEqualP[100]],
		(* If full utilization has already been reached, only actual values are included in the table - one column *)
		{
			{numberOfParentProtocols},
			{totalNumberOfProtocols}
		},
		
		(* If full utilization is not reached, actual values and full utilization estimated are included in the table - two columns *)
		{
			{numberOfParentProtocols,Style[ToString[numberOfParentProtocols+estAdditionalParentProtocols],FontColor->RGBColor["#299984"],FontWeight->Bold]},
			{totalNumberOfProtocols,Style[ToString[totalNumberOfProtocols+estAdditionalTotalProtocols],FontColor->RGBColor["#299984"],FontWeight->Bold]}
		}
	
	];
	
	productivityTableColumnLabels=If[MatchQ[threadUtilizationPercent,GreaterEqualP[100]],
		(* If full utilization has already been reached, only actual values are included in the table - one column *)
		{
			Column[{"Current Utilization",Style["(actual)",FontSlant->Italic]},Alignment->Center]
		},
		
		(* If full utilization is not reached, actual values and full utilization estimated are included in the table - two columns *)
		{
			Column[{"Current Utilization",Style["(actual)",FontSlant->Italic]},Alignment->Center],
			Column[{"100 % Utilization",Style["(potential)",FontSlant->Italic]},Alignment->Center]
		}
	];
	
	productivityTableRowLabels={" ","Experiments Completed", "Protocols Completed"};
	
	productivityTableContents=MapThread[
		Prepend[#1,#2]&,
		{
			Prepend[productivityTableData,productivityTableColumnLabels], (* stack each row *)
			Style[#,FontFamily->"Arial"]&/@productivityTableRowLabels (* add the column of row labels *)
		}
	];
	
	productivityTable = Grid[
		productivityTableContents,
		Alignment->{{Left,Center},{Left,Center}},
		Frame->All,
		Spacings->{2,2},
		Dividers->dividers,
		ItemStyle->{
			{{Directive[FontFamily->"Arial",FontSize->12],FontWeight->Bold},{Directive[FontFamily->"Arial",FontSize->12]}},
			{Directive[FontFamily->"Arial",FontWeight->Bold,FontSize->12]}
		},
		Background->background
	];
	
	productivityTableNumber = Which[
		MatchQ[target,User],
		"TABLE 2",
		MatchQ[target,Company],
		"TABLE 9"
	];
	
	productivityTableTitle=If[MatchQ[threadUtilizationPercent,GreaterEqualP[100]],
		(* If full utilization has already been reached, only actual values are included in the table *)
		TextCell[Row[{
			Style[productivityTableNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
			Style["Productivity with Current Utilization for ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.2,0.2,0.2]],
			Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
			Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
		}],TextJustification->1],
		
		(* If full utilization is not reached, actual values and full utilization estimated are included in the table *)
		TextCell[Row[{
			Style[productivityTableNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
			Style["Comparison of Productivity between Current Utilization and Potential Full Utilization for ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.2,0.2,0.2]],
			Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
			Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
		}],TextJustification->1]
	];
	
	(* Footnote describing how costs and projections are calculated *)
	productivityTableFootnote1 = TextCell[Row[{
		Style[productivityTableNumber<>": ",tableFigureNumbersFootnoteStyle],
		Style["The ",regularFootnoteStyle],
		Style["average cost per available hour ",italicFootnoteStyle],
		Style["is calculated from the monthly cost of lab services pro-rated to the available hours based on paid threads included in this report period. The ",regularFootnoteStyle],
		Style["average cost per protocol/per sample ",italicFootnoteStyle],
		Style["is the calculated pro-rated cost of lab services for the report period over number of protocols completed/number of samples processed.  ",regularFootnoteStyle],
		Style["Lab services ",italicFootnoteStyle],
		Style["include the overall usage of ECL laboratory and operator resources but does not include materials, shipping, storage, waste disposal, cleaning and instrument use outside of subscription inclusions. The projections for full utilization are calculated assuming the additional protocols require the same average run times per protocol.",regularFootnoteStyle]
	}],TextJustification->1];
	
	(* Footnote of defintions for relevant terminologies *)
	productivityTableFootnote2=TextCell[Row[{
		Style["Experiments ",italicFootnoteStyle],
		Style["include all protocols that are generated by experiment function calls. ",regularFootnoteStyle],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",regularFootnoteStyle]
	}],TextJustification->1];
	
	productivityTableFigure = Column[
		{
			productivityTableTitle,
			productivityTable,
			productivityTableFootnote1,
			productivityTableFootnote2
		},
		Spacings->0.5
	];
	
	(* Thread Utilization - A figure representating the team's daily thread usage is presented *)
	
	(* create a list of {date, percent utilization per date = inUseThreads/maxThreads*100}*)
	(* if maxThreads specified is not greater than 0, set to 0 utilization *)
	percentUtilizationList = Map[
		If[MatchQ[#[[2]],GreaterP[0]],
			{#[[1]],#[[3]]/#[[2]]*100},
			{#[[1]],0}
		]&,
		finalTeamThreadUtilizationLogs
	];
	
	(* create a list {date, 100} to depict line of 100% utilization *)
	maxPercentUtilizationList = Map[
		{#[[1]],100}&,
		finalTeamThreadUtilizationLogs
	];
	
	(* Utilization plots can be either showing Thread Numbers or Percentage of Threads Used *)
	
	(* Figure label number for Team Thread Utilization *)
	teamThreadUtilizationNumber = Which[
		MatchQ[target,User],
		"FIGURE 1",
		MatchQ[target,Company],
		"FIGURE 4"
	];
	
	(* Based on Thread Numbers *)
	(* Create a DateListStepPlot that shows the plot of MaxThreads, and plot InUse threads (by NUmber) with shaded region under the intersection to signify utilization *)
	numberTeamThreadUtilizationPlot = DateListStepPlot[
		{Drop[#, {3}] & /@ finalTeamThreadUtilizationLogs, Drop[#, {2}] & /@ finalTeamThreadUtilizationLogs},
		Filling -> {2->Axis},
		FrameLabel->{Style["Date",FontSize->14,FontWeight->Bold],Style["Number Of Threads",FontSize->14,FontWeight->Bold]},
		PlotLegends -> {Style["Max Number Of Threads",FontSize->14],Style["Protocols in Queue",FontSize->14]},
		ImageSize->Medium,
		PlotStyle->{RGBColor["#595C5B"],RGBColor["#299984"]}
	];
	
	numberTeamThreadUtilizationTitle=TextCell[Row[{
		Style[teamThreadUtilizationNumber<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Daily Thread Utilization between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	numberTeamThreadUtilizationPlotCaption = TextCell[Row[{
		Style["Count for ",FontSize->10,FontSlant->Italic,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Protocols in Queue",italicFootnoteStyle],
		Style[" and ",FontSize->10,FontSlant->Italic,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style["Max Number of Threads",italicFootnoteStyle],
		Style[" are taken at 11:59:59 pm of each date.",FontSize->10,FontSlant->Italic,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}],TextJustification->1];
	
	(* Based on Percentage of Threads Used *)
	(* Create a DateListStepPlot that shows the plot of 100% utilization, and plot of actual utilization, with shaded region under the intersection to signify utilization *)
	percentTeamThreadUtilizationPlot = DateListStepPlot[
		{maxPercentUtilizationList, percentUtilizationList },
		Filling -> {2->Axis},
		FrameLabel->{Style["Date",FontSize->14,FontWeight->Bold],Style["% Utilization",FontSize->14,FontWeight->Bold]},
		PlotLegends -> {Style["100 % Utilization",FontSize->14],Style["Daily Percent Utilization",FontSize->14]},
		ImageSize->Medium,
		PlotStyle->{RGBColor["#595C5B"],RGBColor["#299984"]}
	];
	
	percentTeamThreadUtilizationTitle=TextCell[Row[{
		Style[teamThreadUtilizationNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["  Daily Percent Utilization between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	percentTeamThreadUtilizationPlotCaption = TextCell[Row[{
		Style[teamThreadUtilizationNumber<>": ",FontSize->10,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica", FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Daily Percent Utilization ",italicFootnoteStyle],
		Style["is calculated based on number of queued protocols versus number of available protocol slots taken at 11:59:59 pm of each date.",FontSize->10,FontFamily->"Helvetica", FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	threadUtilizationFigure = Which[
		MatchQ[threadUtilization,Percent],
		Column[
			{
				percentTeamThreadUtilizationPlot,
				percentTeamThreadUtilizationTitle,
				percentTeamThreadUtilizationPlotCaption
			},
			Left,
			Spacings->0.5
		],
		
		MatchQ[threadUtilization,Number],
		Column[
			{
				numberTeamThreadUtilizationPlot,
				numberTeamThreadUtilizationTitle,
				numberTeamThreadUtilizationPlotCaption
			},
			Left,
			Spacings->0.5
		]
	];
	
	(* Team Efficiency Metrics section includes the productivityTableSummaryText, productivityTableFigure and threadUtilizationFigure*)
	teamEfficiencyMetricsSection=If[ContainsAny[Download[myFinancingTeams,Object],journeyTeams],
		{
			{Section,"TEAM EFFICIENCY METRICS",PageBreakAbove->True},
			{Subsubsection,"Lab Services Utilization",None},
			{
				Column[{
					productivityTableFigure,
					threadUtilizationFigure
				},Spacings->1.75],
				None
			}
		},
		{
			{Section,"TEAM EFFICIENCY METRICS",PageBreakAbove->True},
			{Subsubsection,"Lab Services Utilization",None},
			{
				Column[{
					productivityTableSummaryText,
					productivityTableFigure,
					threadUtilizationFigure
				},Spacings->1.75],
				None
			}
		}
	];
	
	(* SCIENTIST PRODUCTIVITY METRICS *)
	(* This section of the report presents the activity and productivity of all members of the team financing for the report period *)
	
	(* get a list of all unique members of the team that shows up in the UserUtilizationSummary logs *)
	allUniqueMembers = DeleteDuplicatesBy[inRangeUserUtilizationSummaryLogs[[All,2]],ObjectP[#]&];
	
	(* UserUtilizationSummaryLog: {"Date", "User", "User Name", "Number of Parent Protocols", "Number of Parent Data Objects", "Number of Parent Samples","Number of Total Protocols", "Number of Total Data Objects", "Number of Total Samples", "Labor Hours" } *)
	(* group UserUtilizationSummaryLogs by User *)
	groupedUserUtilizationSummaryLogsPerUser = GatherBy[inRangeUserUtilizationSummaryLogs,ObjectP[#[[2]]]&];
	
	(* calculate the number of ECL users that generate an average of at least 1 completed parent protocol per week - this is needed later for take-away productivity as well as for the Value Proposition section *)
	numberOfECLUsersActualUtilization = Length[Select[groupedUserUtilizationSummaryLogsPerUser,MatchQ[Round[Total[#[[All,4]]]/numberOfWeeks],GreaterP[0]]&]];
	
	(* Table for Summary of Scientist Labor and Productivity - userUtilizationTables *)
	(* set up the Table Number for Summary of Scientist Labor and Productivity Table *)
	userUtilizationTableNumber = Which[
		MatchQ[target,User],
		"TABLE 1",
		MatchQ[target,Company],
		"TABLE 1"
	];
	
	(* set up the Title for the Summary of Scientist Labor and Productivity Table *)
	userUtilizationTableTitle= Row[{
		Style[userUtilizationTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["  Summary of Scientist Labor and Productivity between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}];
	
	(* summarize data from the UserUtilizationSummary field *)
	userUtilizationData = ReverseSortBy[Map[
		Module[
			{
				userFirstName,
				userLastName,
				userName,
				totalLaborHours,
				parentProtocolsCompleted,
				parentDataGenerated,
				parentSamplesProcessed,
				totalProtocolsCompleted,
				totalDataGenerated,
				totalSamplesProcessed,
				userLaborPerProtocol,
				userLaborPerParentSample,
				userLaborPerParentData,
				userLaborPerParentProtocol,
				userLaborPerSample,
				userLaborPerData
			},
			
			userFirstName = Experiment`Private`fastAssocLookup[reportFastAssoc,#[[1]][[2]],FirstName];
			userLastName = Experiment`Private`fastAssocLookup[reportFastAssoc,#[[1]][[2]],LastName];
			userName = If[MatchQ[Length[Cases[{userFirstName,userLastName},_String]],GreaterP[0]],
				(* get the userName of the first element by combining FirstName and LastName, if available. *)
				StringJoin[Cases[{userFirstName," ",userLastName},_String]],
				(* use Name of user object if FirstName or LastName is not available*)
				#[[1]][[3]]
			];
			
			(* get all labor hours logged for each user *)
			totalLaborHours = If[MatchQ[Cases[#[[All,10]],_?TimeQ],{}],
				0 Hour,
				Total[Cases[#[[All,10]],_?TimeQ]]
			];
			
			(* get all protocols,data,samples logged for each user *)
			parentProtocolsCompleted = Total[Cases[#[[All,4]],_Integer]];
			parentDataGenerated = Total[Cases[#[[All,5]],_Integer]];
			parentSamplesProcessed = Total[Cases[#[[All,6]],_Integer]];
			totalProtocolsCompleted = Total[Cases[#[[All,7]],_Integer]];
			totalDataGenerated = Total[Cases[#[[All,8]],_Integer]];
			totalSamplesProcessed = Total[Cases[#[[All,9]],_Integer]];
			
			userLaborPerParentProtocol = If[MatchQ[parentProtocolsCompleted,GreaterP[0]],
				totalLaborHours/parentProtocolsCompleted,
				"N/A"
			];
			userLaborPerParentSample = If[MatchQ[parentSamplesProcessed,GreaterP[0]],
				totalLaborHours/parentSamplesProcessed,
				"N/A"
			];
			userLaborPerParentData = If[MatchQ[parentDataGenerated,GreaterP[0]],
				totalLaborHours/parentDataGenerated,
				"N/A"
			];
			userLaborPerProtocol = If[MatchQ[totalProtocolsCompleted,GreaterP[0]],
				totalLaborHours/totalProtocolsCompleted,
				"N/A"
			];
			userLaborPerSample = If[MatchQ[totalSamplesProcessed,GreaterP[0]],
				totalLaborHours/totalSamplesProcessed,
				"N/A"
			];
			userLaborPerData = If[MatchQ[totalDataGenerated,GreaterP[0]],
				totalLaborHours/totalDataGenerated,
				"N/A"
			];
			
			Which[
				MatchQ[userUtilizationProtocol,Protocol],
				{userName,totalLaborHours,totalProtocolsCompleted,userLaborPerProtocol,totalSamplesProcessed,userLaborPerSample,totalDataGenerated,userLaborPerData},
				
				MatchQ[userUtilizationProtocol,Experiment],
				{userName,totalLaborHours,parentProtocolsCompleted,userLaborPerParentProtocol,parentSamplesProcessed,userLaborPerParentSample,parentDataGenerated,userLaborPerParentData}
			]
		]&,
		groupedUserUtilizationSummaryLogsPerUser
	],#[[2]]&];
	
	(* turn data into text that works with the Grid presentation *)
	userUtilizationDataString = Map[
		Function[{singleUserUtilizationList},
			Module[{userName,totalLaborHours,totalLaborHoursPerWeek, scaledLaborHoursPerWeekText,numberOfProtocolsCompleted,numberOfProtocolsCompletedPerWeek,protocolsCompletedPerWeekText,scaledUserLaborPerProtocolText,protocolColumn,numberOfSamplesProcessed,numberOfSamplesProcessedPerWeek,samplesProcessedPerWeekText,scaledUserLaborPerSampleText,sampleColumn,numberOfDataGenerated,numberOfDataGeneratedPerWeek,dataGeneratedPerWeekText,scaledUserLaborPerDataText,dataColumn},
				
				userName = Style[singleUserUtilizationList[[1]],FontFamily->"Helvetica"];
				
				(* protocols here can refer to either only Parent Protocols or Parent and Subprotocols - this is established from userUtilizationData and based off of UserUtilizationProtocol option *)
				(* present  scaled labor hours, protocols, samples, data as per week: total for the report period / number of weeks *)
				totalLaborHours=singleUserUtilizationList[[2]];
				numberOfProtocolsCompleted = singleUserUtilizationList[[3]];
				numberOfSamplesProcessed = singleUserUtilizationList[[5]];
				numberOfDataGenerated = singleUserUtilizationList[[7]];
				
				totalLaborHoursPerWeek = totalLaborHours/numberOfWeeks;
				numberOfProtocolsCompletedPerWeek = numberOfProtocolsCompleted/numberOfWeeks;
				numberOfSamplesProcessedPerWeek = numberOfSamplesProcessed/numberOfWeeks;
				numberOfDataGeneratedPerWeek = numberOfDataGenerated/numberOfWeeks;
				
				scaledLaborHoursPerWeekText = Column[{
					TextCell[Style[ToString[Round[UnitScale[totalLaborHoursPerWeek],0.1]],FontFamily->"Helvetica",FontSize->12,FontWeight->Bold],TextAlignment->Center],
					TextCell[Style["per week",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic],TextAlignment->Center]
				},Alignment->Center];
				
				protocolsCompletedPerWeekText = Which[
					MatchQ[userUtilizationProtocol,Experiment],
					Column[{
						TextCell[Style[ToString[Round[numberOfProtocolsCompletedPerWeek]]<>" experiments",FontFamily->"Helvetica",FontSize->12,FontWeight->Bold],TextAlignment->Center],
						TextCell[Style["per week",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic],TextAlignment->Center]
					},Alignment->Center],
					
					MatchQ[userUtilizationProtocol,Protocol],
					Column[{
						TextCell[Style[ToString[Round[numberOfProtocolsCompletedPerWeek]]<>" protocols",FontFamily->"Helvetica",FontSize->12,FontWeight->Bold],TextAlignment->Center],
						TextCell[Style["per week",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic],TextAlignment->Center]
					},Alignment->Center]
				];
				
				scaledUserLaborPerProtocolText = If[MatchQ[singleUserUtilizationList[[4]],_?TimeQ],
					Which[
						MatchQ[userUtilizationProtocol,Experiment],
						Column[{
							TextCell[Style[ToString[Round[UnitScale[singleUserUtilizationList[[4]]],0.1]],FontFamily->"Helvetica",FontSize->12,FontWeight->Bold,FontColor->RGBColor["#299984"]],TextAlignment->Center],
							TextCell[Style["per experiment",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic,FontColor->RGBColor["#299984"]],TextAlignment->Center]
						},Alignment->Center],
						
						MatchQ[userUtilizationProtocol,Protocol],
						Column[{
							TextCell[Style[ToString[Round[UnitScale[singleUserUtilizationList[[4]]],0.1]],FontFamily->"Helvetica",FontSize->12,FontWeight->Bold,FontColor->RGBColor["#299984"]],TextAlignment->Center],
							TextCell[Style["per protocol",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic,FontColor->RGBColor["#299984"]],TextAlignment->Center]
						},Alignment->Center]
					],
					"N/A"
				];
				
				protocolColumn = Column[
					{
						protocolsCompletedPerWeekText,
						scaledUserLaborPerProtocolText
					},
					Alignment->Center,
					Spacings->1.25
				];
				
				samplesProcessedPerWeekText = Column[{
					TextCell[Style[ToString[Round[numberOfSamplesProcessedPerWeek]]<>" samples",FontFamily->"Helvetica",FontSize->12,FontWeight->Bold],TextAlignment->Center],
					TextCell[Style["per week",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic],TextAlignment->Center]
				},Alignment->Center];
				
				scaledUserLaborPerSampleText = If[MatchQ[singleUserUtilizationList[[6]],_?TimeQ],
					Column[{
						TextCell[Style[ToString[Round[UnitScale[singleUserUtilizationList[[6]]],0.1]],FontFamily->"Helvetica",FontSize->12,FontWeight->Bold,FontColor->RGBColor["#299984"]],TextAlignment->Center],
						TextCell[Style["per sample",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic,FontColor->RGBColor["#299984"]],TextAlignment->Center]
					},Alignment->Center],
					"N/A"
				];
				
				sampleColumn = Column[
					{
						samplesProcessedPerWeekText,
						scaledUserLaborPerSampleText
					},
					Alignment->Center,
					Spacings->1.25
				];
				
				dataGeneratedPerWeekText = Column[{
					TextCell[Style[ToString[Round[numberOfDataGeneratedPerWeek]]<>" data object(s)",FontFamily->"Helvetica",FontSize->12,FontWeight->Bold],TextAlignment->Center],
					TextCell[Style["per week",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic],TextAlignment->Center]
				},Alignment->Center];
				
				scaledUserLaborPerDataText = If[MatchQ[singleUserUtilizationList[[8]],_?TimeQ],
					Column[{
						TextCell[Style[ToString[Round[UnitScale[singleUserUtilizationList[[8]]],0.1]],FontFamily->"Helvetica",FontSize->12,FontWeight->Bold,FontColor->RGBColor["#299984"]],TextAlignment->Center],
						TextCell[Style["per data",FontFamily->"Helvetica",FontSize->10,FontSlant->Italic,FontColor->RGBColor["#299984"]],TextAlignment->Center]
					},Alignment->Center],
					"N/A"
				];
				
				dataColumn = Column[
					{
						dataGeneratedPerWeekText,
						scaledUserLaborPerDataText
					},
					Alignment->Center,
					Spacings->1.25
				];
				
				{userName,scaledLaborHoursPerWeekText,protocolColumn,sampleColumn,dataColumn}
			]
		],
		userUtilizationData
	];
	
	(* separate contents into multiple tables in order to fit properly in a page - the first page can only contain 2 *)
	groupedUserUtilizationDataString = If[MatchQ[Length[userUtilizationDataString],GreaterP[2]],
		Prepend[Partition[TakeDrop[userUtilizationDataString, 2][[2]], UpTo[8]], TakeDrop[userUtilizationDataString, 2][[1]]],
		{userUtilizationDataString}
	];
	
	(* add Column and Row labels to contents *)
	userUtilizationTableContents = Map[
		Function[{userUtilizationData},
			Module[{userUtilizationTableColumnLabels,userUtilizationTableRowLabels},
				
				userUtilizationTableColumnLabels=Which[
					MatchQ[userUtilizationProtocol,Experiment],
					Style[#,FontFamily->"Helvetica",FontWeight->Bold]&/@{"User \nActivity", "Experiments \nCompleted","Samples \nProcessed","Data \nGenerated"},
					
					MatchQ[userUtilizationProtocol,Protocol],
					Style[#,FontFamily->"Helvetica",FontWeight->Bold]&/@{"User \nActivity", "Protocols \nCompleted","Samples \nProcessed","Data \nGenerated"}
					
				];
				
				userUtilizationTableRowLabels=Prepend[Style[#,FontFamily->"Helvetica",FontWeight->Bold]&/@userUtilizationData[[All,1]],Style["User",FontFamily->"Helvetica",FontWeight->Bold]];
				
				MapThread[
					Prepend[#1,#2]&,
					{
						Prepend[Drop[#, 1] & /@userUtilizationData,userUtilizationTableColumnLabels],
						userUtilizationTableRowLabels
					}
				]
			]
		],
		groupedUserUtilizationDataString
	];
	
	(* each Table has an added Footnote to define headers *)
	userUtilizationTableFootnote = TextCell[Row[{
		Style[userUtilizationTableNumber<>": ", tableFigureNumbersFootnoteStyle],
		Style["User Activity ",italicFootnoteStyle],
		Style["is based on recorded Command Center activity of each user. Interactions within 25 minutes of each other are considered within active times. Users are assumed to be active at least 5 minutes after their last interaction with the software. ",FontSize->10,FontFamily->"Helvetica", FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Protocols ",italicFootnoteStyle],
		Style["include all Experiments plus supporting protocols that are generated by experiments to support their execution, including but not limited to sample preparations, transfers, weight and volume measurements etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Samples Processed ",italicFootnoteStyle],
		Style["include all samples that are key inputs and outputs in the course of an experiment and supporting protocols. These include starting reagents, prepared solutions and analyzed samples. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Data Generated ",italicFootnoteStyle],
		Style["include all data objects that are logged or generated in the course of an experiment including images, measurement values, plots, characterization, analysis results etc. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	(* set up the individual tables for userUtilizationTableContents adding a PageBreakAbove->True to all tables except the first one *)
	userUtilizationTables = Sequence@@MapIndexed[
		{
			Column[
				{
					Grid[
						#,
						Alignment->{{Left,Center},{Left,Center}},
						Frame->All,
						Spacings->{3,1.2},
						Dividers->dividers,
						Background->background
					],
					userUtilizationTableFootnote
				},
				Alignment->Left,Spacings->1
			],
			If[MatchQ[#2,{1}],
				None,
				PageBreakAbove->True
			]
		}&,
		userUtilizationTableContents
	];
	
	totalTeamUserHours = Total[Cases[userUtilizationData[[All,2]],_Quantity]];
	
	averageTeamUserHoursPerDay = totalTeamUserHours/totalNumberOfDays;
	
	averageTeamUserHoursPerWeek = averageTeamUserHoursPerDay*7;
	
	averageTeamUserHourPerProtocol = If[MatchQ[totalNumberOfProtocols,GreaterP[0]],
		Round[UnitScale[(totalTeamUserHours/totalNumberOfProtocols)],0.01],
		0 Hour
	];
	
	averageTeamUserHourPerParent = If[MatchQ[numberOfParentProtocols,GreaterP[0]],
		Round[UnitScale[(totalTeamUserHours/numberOfParentProtocols)],0.01],
		0 Hour
	];
	
	averageTeamUserHourPerData = If[MatchQ[totalNumberOfData,GreaterP[0]],
		Round[UnitScale[(totalTeamUserHours/totalNumberOfData)],0.01],
		0 Hour
	];
	
	averageTeamUserHourPerSample = If[MatchQ[totalNumberOfSamples,GreaterP[0]],
		Round[UnitScale[(totalTeamUserHours/totalNumberOfSamples)],0.01],
		0 Hour
	];
	
	(* Add a takeaway text to the Scientist Productivity Metrics to summarize labor and productivity *)
	userUtilizationTableCaption1 = TextCell[Row[{
		Style["From ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
		Style[" to ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
		Style[", the team has performed ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[Round[totalNumberOfProtocolHours]]<>" of laboratory work ",FontSlant->Italic, FontSize->13,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style["(",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[totalNumberOfProtocols]<>" protocol(s) completed, ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
		Style[ToString[totalNumberOfData]<>" data object(s) generated, ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
		Style[ToString[totalNumberOfSamples]<>" sample(s) processed",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
		Style[")",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[" with ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[Round[totalTeamUserHours]]<>" of Command Center Activity.",FontSlant->Italic, FontSize->13,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]]
	}],TextAlignment->Left];
	
	(* get the number of equivalent workers required to accomplished the hours of work assuming a 40-hour work week per person *)
	numberOfTraditionalWorkers = Round[(totalNumberOfProtocolHours/(40 Hour*numberOfWeeks))];
	
	(* Add a takeaway text with projection of number of laboratory workers needed to perform equivalent laboratory hours *)
	userUtilizationTableCaption2 = TextCell[Row[{
		Style["To complete the same amount of laboratory work hours in the same timeframe would require an estimated number of ",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
		Style[ToString[numberOfTraditionalWorkers]<>" laboratory workers ",FontSlant->Italic, FontSize->13,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style["working 40-hour weeks, assuming similar required operation hours to complete the protocols.",FontSize->13,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
	}],TextAlignment->Left];
	
	(* summarize in bullet points the user activity as well as correponding results in protocols, samples and data *)
	userUtilizationTableCaption3 = Column[{
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->16,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[Round[averageTeamUserHoursPerWeek,0.1]]<>" of user activity per week",FontSlant->Italic, FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style["  on Command Center",FontSize->12,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]](*,
			Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic],
			Style[" to ",FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13],FontSlant->Italic]
			*)
		}],TextAlignment->Left],
		
		Which[
			MatchQ[userUtilizationProtocol,Experiment],
			TextCell[Row[{
				Style["\[CenterDot]  ",FontSize->16,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[ToString[Round[averageTeamUserHourPerParent,0.1]]<>" of user activity",FontSlant->Italic, FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
				Style[" per",FontSize->12,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[" experiment completed",FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
			}],TextAlignment->Left],
			
			MatchQ[userUtilizationProtocol,Protocol],
			TextCell[Row[{
				Style["\[CenterDot]  ",FontSize->16,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[ToString[Round[averageTeamUserHourPerProtocol,0.1]]<>" of user activity",FontSlant->Italic, FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
				Style[" per",FontSize->12,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
				Style[" protocol completed",FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
			}],TextAlignment->Left]
		],
		
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->16,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[Round[averageTeamUserHourPerSample,0.1]]<>" of user activity",FontSlant->Italic,FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[" per",FontSize->12,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[" sample processed",FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
		}],TextAlignment->Left],
		
		TextCell[Row[{
			Style["\[CenterDot]  ",FontSize->16,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[ToString[Round[averageTeamUserHourPerData,0.1]]<>" of user activity",FontSlant->Italic,FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
			Style[" per",FontSize->12,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]],
			Style[" data object generated",FontSize->12,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor[0.13,0.13,0.13]]
		}],TextAlignment->Left]
	},
		Alignment->Left,Spacings->0
	];
	
	(* If equivalent numberOfTraditionalWorkers is greater tha 2x of numberOfECLUsersActualUtilization, userUtilizationTableCaption2 is shown as takeaway *)
	scientistLaborProductivitySummaryText = If[MatchQ[numberOfTraditionalWorkers,GreaterEqualP[(2*numberOfECLUsersActualUtilization)]],
		Sequence@@{
			{userUtilizationTableCaption1,None},
			{userUtilizationTableCaption2,None},
			{userUtilizationTableCaption3,None}
		},
		Sequence@@{
			{userUtilizationTableCaption1,None},
			{userUtilizationTableCaption3,None}
		}
	];
	
	(* Assemble the section to be included in the report document *)
	scientistLaborProductivitySection = {
		{Section,"SCIENTIST PRODUCTIVITY METRICS",None},
		scientistLaborProductivitySummaryText,
		{userUtilizationTableTitle,None},
		userUtilizationTables
	};
	
	(* Instrument Usage Metrics *)
	
	(* group all instrument logs by Instrument Model *)
	groupedInstrumentLogsByInstrumentModel = GatherBy[inRangeInstrumentLogs, ObjectP[#[[3]]] &];
	
	(* put together data needed for Instrument Usage Table*)
	instrumentUsageSummaryByModelData = ReverseSortBy[Map[
		Function[{instrumentModelGroup},
			Module[{instrumentModel, numberOfInstrumentObjects,numberOfProtocols,instrumentHours,sortedUniqueInstrumentObjectLogs, numberOfQualifications,numberOfMaintenances,instrumentCost,instrumentImage },
				(* since all elements of a group share the same model, get the model ([[3]]) of the first log *)
				instrumentModel = NamedObject[Download[instrumentModelGroup[[1]][[3]],Object]];
				
				(* count the number of unique instrument objects of the model included in the log *)
				numberOfInstrumentObjects = Length[DeleteDuplicates[Download[instrumentModelGroup[[All,2]],Object]]];
				
				(* count the number of unique protocol objects that used the model included in the log *)
				numberOfProtocols = Length[DeleteDuplicates[Download[instrumentModelGroup[[All,5]],Object]]];
				
				(* add up all the time instruments of the model group is in use *)
				instrumentHours = Round[UnitScale[Total[Cases[Cases[instrumentModelGroup[[All,6]],_?QuantityQ],LessP[90 Day]]]],0.1];
				
				(* order the list of logs by date to get most recent logged instrument first, then delete logs based on unique instrument object*)
				(* this is needed in order to get the most recent number of qualifications/maintenances performed per unique instrument object *)
				sortedUniqueInstrumentObjectLogs = DeleteDuplicatesBy[
					ReverseSortBy[instrumentModelGroup,#[[1]]&],
					ObjectP[#[[2]]]&
				];
				
				(* get the total number of qualifications and maintenances per Model instrument by adding up the number of qualifications or maintenances of instrument objects under the model *)
				numberOfQualifications = Total[Cases[sortedUniqueInstrumentObjectLogs[[All,7]],_Integer]];
				numberOfMaintenances = Total[Cases[sortedUniqueInstrumentObjectLogs[[All,8]],_Integer]];
				
				(* get the highest priced instrument per Model *)
				instrumentCost = Max[Cases[sortedUniqueInstrumentObjectLogs[[All,9]],_?QuantityQ]];
				
				instrumentImage = ImportCloudFile[Experiment`Private`fastAssocLookup[reportFastAssoc,instrumentModel,ImageFile]];
				
				{instrumentModel, numberOfInstrumentObjects,numberOfProtocols,instrumentHours,numberOfQualifications,numberOfMaintenances,instrumentCost,instrumentImage}
			]
		],
		groupedInstrumentLogsByInstrumentModel
	],#[[4]]&];
	
	(* add up all the hours any instrument is in use; if no instrument usage is recorded, set to 0 Hour *)
	totalInstrumentHours = If[MatchQ[instrumentUsageSummaryByModelData,Except[{}]],
		Convert[Total[instrumentUsageSummaryByModelData[[All,4]]],Hour],
		0 Hour
	];
	
	(* the list of instruments need to be partition into sets of only up to a certain number in order to ensure each table can fit in one page *)
	groupedInstrumentUsageSummaryData = Partition[Most/@instrumentUsageSummaryByModelData,UpTo[17]];
	
	(* Instrument Usage Table *)
	(* set up the data into a contents format that works with teh Grid - add the labels as the first column of the data set *)
	instrumentUsageSummaryTableContents = Map[
		Prepend[
			#,
			{"Instrument Model",Column[{"Instrument","Count"},Alignment->Center], "Protocols", Column[{"Time","Used"},Alignment->Center], "Qualifications", "Maintenances", "Instrument Value"}
		]&,
		groupedInstrumentUsageSummaryData
	];
	
	instrumentSummaryTableNumber = Which[
		MatchQ[target,User],
		"TABLE 3",
		MatchQ[target,Company],
		"TABLE 5a"
	];
	
	instrumentSummaryTableNote=TextCell[Row[{
		Style[instrumentSummaryTableNumber<>": ",tableFigureNumbersFootnoteStyle],
		Style["For instrument models of multiple objects, the ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Instrument Value ",italicFootnoteStyle],
		Style["presented is that of the instrument with the most recent maximum purchase price. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	instrumentSummaryTables = Map[
		Column[
			{
				Grid[
					#,
					Alignment->{{Left,Center},{Left,Center}},
					Frame->All,
					Spacings->1,
					Dividers->dividers,
					ItemStyle->{{{Directive[FontFamily->"Helvetica",FontSize->10]},{Directive[FontFamily->"Arial",FontSize->10]}},{Directive[FontWeight->Bold,FontSize->10]}},
					(*Background->{{LightGray,{None}},{LightGray,{None}}}*)
					Background->background
				],
				instrumentSummaryTableNote
			},
			Spacings->1
		]&,
		instrumentUsageSummaryTableContents
	];
	
	instrumentSummaryTableTitle= TextCell[Row[{
		Style[instrumentSummaryTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Summary of Instrument Usage for instruments used between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	(* Each table must be inside a list and the tables turned into a Sequence in order for ExportReport to interpret it properly *)
	(* We add a PageBreakAbove->True for succeeding tables in order to force it into a different page *)
	instrumentSummaryTableSequence = Sequence@@MapIndexed[
		If[MatchQ[#2,{1}],
			{#,None},
			{#,PageBreakAbove->True}
		]&,
		instrumentSummaryTables
	];
	
	(* Instrument Usage Collage *)
	
	(* get the maximum instrument hours used for all models *)
	maxInstrumentHours = If[MatchQ[instrumentUsageSummaryByModelData,Except[{}]],
		Max[instrumentUsageSummaryByModelData[[All,4]]],
		Null
	];
	
	(* create an association per Model of time Used for the Model to the Image *)
	instrumentHoursToImageAssociation = If[MatchQ[instrumentUsageSummaryByModelData,Except[{}]],
		Map[
			(* get the ratio of hours to the maximum instrument hours and replace all ratios less than 0.05 with 0.05 to avoid having images that are too small *)
			(#[[4]]/maxInstrumentHours)->#[[8]]&,
			Cases[instrumentUsageSummaryByModelData,{_,_,_,_?QuantityQ,_,_,_,Except[Null]}]
		]/.{LessP[0.05] :> 0.05},
		{}
	];
	
	(* create a Collage of all Instrument Model Images with image size relative to number of hours a model is used *)
	(* we need to Rasterize the resulting image in order to remove shadow borders that come up when the nb is printed into a PDF *)
	instrumentCollage=If[MatchQ[instrumentUsageSummaryByModelData,Except[{}]],
		SetAlphaChannel[Rasterize[ImageCollage[
			instrumentHoursToImageAssociation,
			Method -> "ClosestPacking",
			Padding->Transparent,
			ImagePadding->2,
			Background -> Transparent
		],ImageSize -> {UpTo[600], UpTo[800]}],0.7],
		Null
	];
	
	(* create a polygon overlay for the collage *)
	polygon = ImageCompose[
		Graphics[
			ImportCloudFile[Object[EmeraldCloudFile, "ECL Hexagon Design"]],
			Background -> Transparent,
			ImageSize -> UpTo[800]
		],
		Column[{
			Row[{
				Style[ToString[Length[instrumentUsageSummaryByModelData]], FontSize -> 80, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]],
				Style[" instrument models", FontSize -> 40, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]]
			},BaselinePosition->Center],
			Row[{
				Style[ToString[Round[Unitless[totalInstrumentHours]]], FontSize -> 80, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]],
				Style[" instrument hours", FontSize -> 40, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]]
			},BaselinePosition->Center],
			Row[{
				Style[ToString[numberOfParentProtocols], FontSize -> 80, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]],
				Style[" experiments", FontSize -> 40, FontWeight -> Bold, FontSlant -> Italic, FontFamily -> "Helvetica", FontColor -> RGBColor[0.13, 0.13, 0.13]]
			},BaselinePosition->Center]
		},Spacings->3]
	];
	
	instrumentCollageWithOverlay = If[MatchQ[instrumentUsageSummaryByModelData,Except[{}]],
		ImageCompose[instrumentCollage,polygon],
		Null
	];
	
	instrumentCollageFigureText = Which[
		MatchQ[target,User],
		"TABLE 3b",
		MatchQ[target,Company],
		"TABLE 5b"
	];
	
	instrumentCollageTitle=TextCell[Row[{
		Style[instrumentCollageFigureText<>". ",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style["Graphical Representation of Instrument Models utilized between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	instrumentCollageNote = TextCell[Row[{
		Style[instrumentCollageFigureText<>": ",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3],FontWeight->Bold],
		Style["The ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["relative image size ",italicFootnoteStyle],
		Style["represents the ratio of instrument usage time  with the maximum instrument usage time logged for the report period. ",FontWeight->"Medium",FontSize->10,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style["Any image with a ratio of less than 0.05 has been scaled up to size for proper visualization.",italicFootnoteStyle]
	}],TextJustification->1];
	
	instrumentCollageFigure = Column[
		{
			instrumentCollageWithOverlay,
			instrumentCollageTitle,
			instrumentCollageNote
		},
		Left,
		Spacings -> 1
	];
	
	instrumentMetricsSection={
		{Section,"INSTRUMENT METRICS",PageBreakAbove->True},
		{Subsubsection,"Instrument Usage Metrics",None},
		{instrumentSummaryTableTitle,None},
		instrumentSummaryTableSequence,
		{instrumentCollageFigure,PageBreakAbove->True}
	};
	
	(* Value Proposition *)
	
	(* Instrument Savings *)
	(* Total cost is calculated based on maximum price from all object instances of instrument models multiplied by the number of objects utilized *)
	instrumentTotalCost = Total[Cases[Map[
		(#[[7]]*#[[2]])&,
		instrumentUsageSummaryByModelData
	],_?QuantityQ]];
	
	(* Assuming an interest rate of 8% - suggested by Business Development 2024-08-01*)
	purchasingInterestRate = 0.08;
	
	(* Assuming a 5-year financing - suggested by Business Development 2024-08-01*)
	financingYears = 5;
	
	(* Solves for the yearly cost assuming the financing terms of purchasingInterestRate and financingYears for the instrumentTotalCost *)
	instrumentFinancingCostPerYear = Quiet[First[Flatten[Values[Solve[TimeValue[Annuity[pmt,financingYears,1],EffectiveInterest[purchasingInterestRate,1],0]==instrumentTotalCost,pmt]]]]];
	
	instrumentDimensions = If[MatchQ[inRangeInstrumentLogs,Except[{}]],
		DeleteCases[Map[
			UnitConvert[#,"Feet"]&,
			DeleteCases[DeleteDuplicatesBy[inRangeInstrumentLogs,ObjectP[#[[2]]]&][[All,10]],Null|{}],
			{2}
		],Null],
		{}
	];
	
	(* only get X and Y dimenions and multiply to get square footage then total *)
	instrumentAreaRequired = If[MatchQ[instrumentDimensions,Except[{}]],
		Total[Times@@@instrumentDimensions[[All,{1,2}]]],
		Quantity[0,Power["Feet", 2]]
	];
	
	(* assuming a standard 3 ft x 6 ft bench, calculate the number of benches required *)
	numberOfBenches = If[MatchQ[instrumentDimensions,Except[{}]],
		instrumentAreaRequired/Quantity[18,Power["Feet", 2]],
		0
	];
	
	(* calculate Real Estate Area sqaure footage required assuming each bench will require 53.75 square feet of space (10 benches, 5 on each side with Utility Manifold in between inside a 12.5 ft x 43 ft space)*)
	realEstateSpace = numberOfBenches*Quantity[53.75,Power["Feet", 2]];
	
	(* get real estate cost per year by multiplying rate to calculated required space *)
	realEstateCostPerYear=realEstateRate*realEstateSpace;
	
	(* get the pro-rated amount to be reported by getting the real estate cost per day then multiplying to number of days included in the report *)
	realEstateCost=(realEstateCostPerYear*(Day/Year))*totalNumberOfDays;
	
	(* estimated utilities cost is  based on a real estate cost * multiplier (default is 10% as average industry standard)*)
	realEstateUtilitiesMultiplier = 0.1;
	estimatedUtilitiesCostPerYear=realEstateCostPerYear*realEstateUtilitiesMultiplier;
	estimatedUtilitiesCost=realEstateCost*realEstateUtilitiesMultiplier;
	
	(* yearly maintenance is estimated to 10% of instrument total cost, then pro-rated to report period *)
	estimatedMaintenanceCostPerYear=instrumentTotalCost*0.1;
	estimatedMaintenanceCost = (instrumentTotalCost*0.1*(Day/Year))*totalNumberOfDays;
	
	(* get the total cost for instrument ownership *)
	totalInstrumentOwnershipCost = Which[
		MatchQ[instrumentSavings,Purchase],
		instrumentTotalCost+estimatedMaintenanceCostPerYear+estimatedUtilitiesCostPerYear+realEstateCostPerYear,
		
		MatchQ[instrumentSavings,Finance],
		instrumentFinancingCostPerYear+estimatedMaintenanceCostPerYear+estimatedUtilitiesCostPerYear+realEstateCostPerYear
	];
		
	(* get the total qualifications log per instrument - 4th column *)
	numberOfQualificationProtocols = Total[Cases[instrumentUsageSummaryByModelData[[All,5]],_Integer]];
	
	(* get the total qualifications log per instrument - 5th column *)
	numberOfMaintenanceProtocols = Total[Cases[instrumentUsageSummaryByModelData[[All,6]],_Integer]];
	
	(* get total instrument time charge; set to $0 if no bill packet is found *)
	instrumentTimeChargeTotal=If[MatchQ[sortedBillPackets,{}],
		0 USD,
		Module[{allInstrumentTimeCharges,inRangeInstrumentTimeCharges},
			(* get all the InstrumentTimeCharge logs from Bills included in the report *)
			allInstrumentTimeCharges = Flatten[Lookup[sortedBillPackets,InstrumentTimeCharges,{}],1];
			
			(* select all logs that are in range for the report period *)
			inRangeInstrumentTimeCharges = Select[allInstrumentTimeCharges,GreaterEqualDateQ[#[[1]],convertedStartTime]&&LessEqualDateQ[#[[1]],convertedEndTime]&];
			
			(* get a list of charges for the financing team included in the report period *)
			(* the amount charged is the last value in the list *)
			instrumentTimeChargeAmounts=Cases[inRangeInstrumentTimeCharges[[All,-1]],_?QuantityQ];
			
			(* add all the amounts charged to get total for the report period *)
			Total[instrumentTimeChargeAmounts]
		]
	];
	
	(* get the amount charged per day t be used for estimation of annual instrument time charge cost *)
	instrumentTimeChargePerDay = If[MatchQ[totalNumberOfDays,GreaterP[0]],
		instrumentTimeChargeTotal/totalNumberOfDays,
		0 USD
	];
	
	(* multiply the charge per day to 365*)
	averageInstrumentTimeChargePerYear = instrumentTimeChargePerDay*(Year/Day);
	
	instrumentCostTable=Grid[{
		{
			" ",
			Item[Column[{
				TextCell[Style["Instrument Ownership Savings",FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Center](*,
				TextCell[Style["Customer purchases instruments and builds out lab",FontSize->10,FontSlant->Italic,FontFamily->"Helvetica"],TextJustification->1],
				" "
				*)
			}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
			TextCell[Style["ECL Instrument Usage Cost",FontWeight->Bold,FontColor->RGBColor["#299984"],FontFamily->"Helvetica"],TextAlignment->Center]
		},
		Which[
			MatchQ[instrumentSavings,Purchase],
			{
				Item[Style["Purchase Savings", FontWeight -> Bold], Frame -> Directive[GrayLevel[0.8]]],
				Item[Column[{
					Style["$" <> ToString[NumberForm[Round[Unitless[instrumentTotalCost]], DigitBlock -> 3]], FontSize -> 16],
					TextCell[Row[{
						Style["calculated from the total purchase price of all utilized instruments from ", FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[DateString[convertedStartTime, {"Day", "-", "MonthNameShort", "-", "Year"}], FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[" to ", FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[DateString[endDate, {"Day", "-", "MonthNameShort", "-", "Year"}], FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic]
					}], TextAlignment -> Center]
				},
					Alignment -> Center, Spacings -> 1], Frame -> Directive[GrayLevel[0.8]]
				]
			},
			
			MatchQ[instrumentSavings,Finance],
			{
				Item[Style["Annual Financing Savings", FontWeight -> Bold], Frame -> Directive[GrayLevel[0.8]]],
				Item[Column[{
					Style["$" <> ToString[NumberForm[Round[Unitless[instrumentFinancingCostPerYear]], DigitBlock -> 3]], FontSize -> 16],
					TextCell[Row[{
						Style["calculated assuming the financing of the total purchase price of all utilized instruments from ", FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[DateString[convertedStartTime, {"Day", "-", "MonthNameShort", "-", "Year"}], FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[" to ", FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[DateString[endDate, {"Day", "-", "MonthNameShort", "-", "Year"}], FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic],
						Style[" on a "<>ToString[financingYears]<>" yr, "<>ToString[purchasingInterestRate*100]<>"% terms ", FontFamily -> "Helvetica", FontSize -> 10, FontSlant -> Italic]
					}], TextAlignment -> Center]
				},
					Alignment -> Center, Spacings -> 1], Frame -> Directive[GrayLevel[0.8]]
				]
			}
		],
		{
			Item[Style["Annual Real Estate Savings",FontWeight->Bold],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[realEstateCostPerYear]],DigitBlock->3]],FontSize->16],
				TextCell[Row[{
					Style["estimated cost for "<>ToString[Round[Unitless[realEstateSpace]]]<>" sqft of real estate space to house all instruments utilized, assuming an average real estate rate of $"<>ToString[Unitless[realEstateRate]]<>" /sqft/yr NNN", FontSize -> 10,FontSlant->Italic,FontFamily->"Helvetica"]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			Column[
				{
					TextCell[Style["\[Checkmark] "<>ToString[Length[instrumentUsageSummaryByModelData]-1]<>" instrument models utilized", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->1],
					TextCell[Style["\[Checkmark] "<>ToString[numberOfQualificationProtocols]<>" qualifications performed", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->1],
					TextCell[Style["\[Checkmark] "<>ToString[numberOfMaintenanceProtocols]<>" preventative", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->0.8],
					TextCell[Style["    maintenances performed", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->1],
					TextCell[Style["\[Checkmark] 24 hours/day, 365 days/year", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->1],
					TextCell[Style["    labor performed", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"],FontWeight->Bold],TextJustification->1]
				},
				Alignment->Left,
				Spacings->0.5
			]
		},
		{
			Item[Style["Annual Utilities Savings",FontWeight->Bold],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[
				{
					Style["$"<>ToString[NumberForm[Round[Unitless[estimatedUtilitiesCostPerYear]],DigitBlock->3]],FontSize->16],
					TextCell[Row[{
						Style["estimated as 10% of real estate costs as an average industry standard",FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic]
					}],TextAlignment->Center]
				},
				Alignment -> Center,Spacings->1
			],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[Style["Annual Maintenance Savings",FontWeight->Bold],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[estimatedMaintenanceCostPerYear]],DigitBlock->3]],FontSize->16],
				TextCell[Row[{
					Style["estimated as 10% of instrument purchase costs per year as average industry standard", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[Style["Annual Costs",FontWeight->Bold,FontSlant->Italic],Frame->Directive[GrayLevel[0.8]]],
			Which[
				MatchQ[instrumentSavings,Purchase],
				Item[Column[{
					Style["$"<>ToString[NumberForm[Round[Unitless[totalInstrumentOwnershipCost]],DigitBlock->3]],FontSlant->Italic,FontSize->16],
					TextCell[Row[{
						Style["(costs including instrument purchase, maintenance, real estate, and utilities)", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic]
					}],TextAlignment->Center]
				}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
				
				MatchQ[instrumentSavings,Finance],
				Item[Column[{
					Style["$"<>ToString[NumberForm[Round[Unitless[totalInstrumentOwnershipCost]],DigitBlock->3]],FontSlant->Italic,FontSize->16],
					TextCell[Row[{
						Style["(costs including instrument financing, maintenance, real estate, and utilities)", FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic]
					}],TextAlignment->Center]
				}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]]
			],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[averageInstrumentTimeChargePerYear]],DigitBlock->3]],FontSize->20,FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic],
				TextCell[Style["(estimated annual instrument charges",FontSize->10,FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic,FontFamily->"Helvetica",FontSlant->Italic],TextAlignment->Center],
				TextCell[Style["based on inclusive bills)",FontSize->10,FontColor->RGBColor["#299984"],FontWeight->Bold,FontSlant->Italic,FontFamily->"Helvetica"],TextAlignment->Center]
			}, Alignment->Center],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[TextCell[Style["Annual Instrument Savings",FontFamily->"Helvetica",FontWeight->Bold,FontSize->18],TextAlignment->Center],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[totalInstrumentOwnershipCost-averageInstrumentTimeChargePerYear]],DigitBlock->3]],FontSize->20,FontWeight->Bold]}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			SpanFromLeft
		}
	},
		Alignment -> {{Left},{Center}},
		Dividers -> {{2 -> Directive[GrayLevel[0.8]]}, {2 -> Directive[GrayLevel[0.8]]}},
		Frame -> Directive[GrayLevel[0.8],Thickness[2]],
		Spacings->{2,1.2},
		ItemStyle->{FontFamily->"Helvetica"}
	];
	
	instrumentCostTableNumber = Which[
		MatchQ[target,User],
		"TABLE 3",
		MatchQ[target,Company],
		"TABLE 2"
	];
	
	instrumentCostTableTitle= TextCell[Row[{
		Style[instrumentCostTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Comparison of Traditional Laboratory Instrument Ownership vs ECL Instrument Service based on Instrument Usage between ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]],
		Style[DateString[convertedStartTime,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[" to ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica"],
		Style[DateString[endDate,{"Day","-","MonthNameShort","-","Year"}],FontSize->14,FontWeight->Bold,FontFamily->"Helvetica", FontColor->RGBColor["#299984"]],
		Style[".",FontSize->14,FontWeight->"Medium",FontFamily->"Helvetica"]
	}],TextJustification->1];
	
	instrumentCostTableCaption = TextCell[Row[{
		Style[instrumentCostTableNumber<>": ", tableFigureNumbersFootnoteStyle],
		Style["Real Estate Space is estimated as space required to house benches that can hold all the instruments utilized according to their dimensions. A standard 3 ft x 6 ft bench is estimated to require 87 sqft of usable real estate space to account for aisle width, spacing between benches, distance from walls etc. Real Estate Rate used in the calculation of cost is the reported Average NNN Asking Rent for Q2 2024 according to Coldwell Banker Richard Ellis (CBRE) Research. Annual ECL Instrument Charges is calculated from the average instrument charge per day from included bills and pro-rated to 365 days.",italicFootnoteStyle]
	}],TextJustification->1];
	
	instrumentCostTableSection = Column[
		{
			instrumentCostTableTitle,
			instrumentCostTable,
			instrumentCostTableCaption
		},
		Left,
		Spacings->1.5
	];
	
	(* Labor Savings *)
	laborCostTableNumber = Which[
		MatchQ[target,User],
		"TABLE 3",
		MatchQ[target,Company],
		"TABLE 3"
	];
	
	laborCostTableTitle= TextCell[Row[{
		Style[laborCostTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Comparison of Traditional Laboratory Labor Cost vs ECL Labor Cost ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	(* calculate the annual instrument hours by getting the instrument hours per day and multiplying to 365 days *)
	estimatedAnnualInstrumentHours = (totalInstrumentHours/totalNumberOfDays)*(Year/Day);
	
	(* Full Utilization *)
	(* calculate annual number of hours available for lab work based on Average MaxThreads available for the entire report period - full utilization *)
	threadHoursPerYear = averageMaxThreadsPerDay*(Day/Hour)*(Year/Day)*Hour;
	
	(* laborHoursFullUtilization is based on estimated annual thread hours and can either include or not include Instrument Hours *)
	laborHoursFullUtilization= If[MatchQ[instrumentWorkingHours,True],
		threadHoursPerYear-estimatedAnnualInstrumentHours,
		threadHoursPerYear
	];
	
	(* Actual Utilization *)
	(* calculate estimated annual number of hours to be uased based on actual usage during the report period by getting the average protocol hours per day and multiplying to 365 days *)
	estimatedProtocolHoursPerYear = (totalNumberOfProtocolHours/totalNumberOfDays)*(Year/Day);
	
	(* laborHoursActualUtilization is based on estimated annual protocol hours and can either include or not include Instrument Hours *)
	laborHoursActualUtilization= If[MatchQ[instrumentWorkingHours,True],
		estimatedProtocolHoursPerYear-estimatedAnnualInstrumentHours,
		estimatedProtocolHoursPerYear
	];
	
	(* calculate the number of scientists needed to fulfill laborHoursActualUtilization and laborHoursActualUtilization assuming each scientist works 40-hr work weeks for 48 weeks/year (1920 hours/year/scientist) to account for 4-week vacation/holiday/sick days *)
	numberOfWorkersFullUtilization = Unitless[Round[laborHoursFullUtilization/Convert[((40 Hour/Week)*48 Week),Hour]]];
	numberOfWorkersActualUtilization = Unitless[Round[laborHoursActualUtilization/Convert[((40 Hour/Week)*48 Week),Hour]]];
	
	(* to get the equivalent ECL Users at full utilization, use ratio laborHoursFullUtilization/laborHoursActualUtilization *)
	numberOfECLUsersFullUtilization = If[MatchQ[laborHoursActualUtilization,GreaterP[0 Hour]],
		Round[numberOfECLUsersActualUtilization*(laborHoursFullUtilization/laborHoursActualUtilization)],
		0
	];
	
	(* get the average hours per person *)
	averageUserHoursPerWeekActual=If[MatchQ[numberOfECLUsersActualUtilization,GreaterP[0]],
		averageTeamUserHoursPerWeek/numberOfECLUsersActualUtilization,
		0 Hour
	];
	averageUserHoursPerWeekFull=If[MatchQ[numberOfECLUsersFullUtilization,GreaterP[0]]&&MatchQ[laborHoursActualUtilization,GreaterP[0 Hour]],
		(averageTeamUserHoursPerWeek*(laborHoursFullUtilization/laborHoursActualUtilization)/numberOfECLUsersFullUtilization),
		0 Hour
	];
	
	(* calculate the total salary for the numberOfWorkersFullUtilization - average annual mean wage for Life Scientists in Scientific, Research and Developmental Studies is $123,410 and multiplies by 1.3 to account for other benefits *)
	annualScientistMeanWage = 123410 USD;
	
	(* calculate total salaries (labor cost) for scientist/user for actual/full utilization *)
	totalScientistSalaryFullUtilization = numberOfWorkersFullUtilization*annualScientistMeanWage*1.3;
	totalScientistSalaryActualUtilization = numberOfWorkersActualUtilization*annualScientistMeanWage*1.3;
	totalECLUserSalaryActualUtilization = numberOfECLUsersActualUtilization*annualScientistMeanWage*1.3;
	totalECLUserSalaryFullUtilization = numberOfECLUsersFullUtilization*annualScientistMeanWage*1.3;
	
	(* calculate for labor savings with actual and full utilization *)
	laborSavingsActualUtilization=Unitless[totalScientistSalaryActualUtilization]-Unitless[totalECLUserSalaryActualUtilization];
	laborSavingsFullUtilization=Unitless[totalScientistSalaryFullUtilization]-Unitless[totalECLUserSalaryFullUtilization];
	
	(* check if we are to include the Full Utilization section in the Labor Savings Table *)
	laborSavingsFullBoolean=MatchQ[laborSavingsFullUtilization,GreaterEqualP[laborSavingsActualUtilization*1.5]];
	
	traditionalLabTotalCost = totalScientistSalaryActualUtilization+totalInstrumentOwnershipCost;
	eclLabTotalCost=totalECLUserSalaryActualUtilization+averageInstrumentTimeChargePerYear+(labAccessFeePerDay*365);
	
	laborSavingsTable=Grid[
		If[laborSavingsFullBoolean,
			(* Contents if including Full Utilization *)
			{
				{
					" ",
					Item[Column[{
						TextCell[Style["Current Utilization",FontWeight->Bold,FontFamily->"Helvetica",FontSize->18],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					SpanFromLeft,
					Item[Column[{
						TextCell[Style["Full Utilization",FontWeight->Bold,FontFamily->"Helvetica",FontSize->18],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					SpanFromLeft
				},
				{
					" ",
					Item[Column[{
						TextCell[Style["Traditional Laboratory",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					Item[Column[{
						TextCell[Style["ECL Services",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13,FontColor->RGBColor["#299984"]],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					Item[Column[{
						TextCell[Style["Traditional Laboratory",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					Item[Column[{
						TextCell[Style["ECL Services",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13,FontColor->RGBColor["#299984"]],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]]
				},
				{
					Item[TextCell[Style[Superscript["Operational Hours"," a"],FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Right], Frame -> Directive[GrayLevel[0.8]],Alignment-> {Right,Center}],
					Item[Column[{
						Style[ToString[NumberForm[Round[Unitless[laborHoursActualUtilization]],DigitBlock->3]]<>" hours",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style["calculated based on ",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]],
							Style["current average daily hours utilized to run protocols",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]]
						}], TextAlignment->Center]
					},
						Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					SpanFromLeft,
					Item[Column[{
						Style[ToString[NumberForm[Round[Unitless[laborHoursFullUtilization]],DigitBlock->3]]<>" hours",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style["calculated based on ",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]],
							Style["full utilization running an average of "<>ToString[averageMaxThreadsPerDay]<>" experiments in parallel at all times",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]]
							
						}], TextAlignment->Center]
					},
						Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					SpanFromLeft
				},
				{
					Item[TextCell[Style[Superscript["Scientists on Staff"," b"],FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style[ToString[numberOfWorkersActualUtilization]<>" scientist(s)",FontSize->16],
						TextCell[Row[{
							Style["40 hours/week ",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic],
							Style["in the laboratory",FontFamily->"Helvetica", FontSize -> 10]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style[ToString[numberOfECLUsersActualUtilization]<>" ECL user(s)",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[Round[averageUserHoursPerWeekActual]]<>"/week",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style[" on Command Center",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style[ToString[numberOfWorkersFullUtilization]<>" scientist(s)",FontSize->16],
						TextCell[Row[{
							Style["40 hours/week ",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic],
							Style["in the laboratory",FontFamily->"Helvetica", FontSize -> 10]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style[ToString[numberOfECLUsersFullUtilization]<>" ECL user(s)",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[Round[averageUserHoursPerWeekFull]]<>"/week",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style[" on Command Center",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}]
				},
				{
					Item[TextCell[Style[Superscript["Labor Cost"," c"],FontWeight->Bold,FontFamily->"Helvetica",FontSlant->Italic],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalScientistSalaryActualUtilization]],DigitBlock->3]],FontSize->16],
						TextCell[Row[{
							Style[ToString[numberOfWorkersActualUtilization]<>" scientist(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalECLUserSalaryActualUtilization]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[numberOfECLUsersActualUtilization]<>" ECL user(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10,FontColor->RGBColor["#299984"]]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalScientistSalaryFullUtilization]],DigitBlock->3]],FontSize->16],
						TextCell[Row[{
							Style[ToString[numberOfWorkersFullUtilization]<>" scientist(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalECLUserSalaryFullUtilization]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[numberOfECLUsersFullUtilization]<>" ECL user(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10,FontColor->RGBColor["#299984"]]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}]
				},
				{
					Item[TextCell[Style["Labor Savings",FontFamily->"Helvetica",FontWeight->Bold],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[laborSavingsActualUtilization]],DigitBlock->3]],FontSize->20,FontWeight->Bold]}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]],Alignment->{Center,Center}],
					SpanFromLeft,
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[laborSavingsFullUtilization]],DigitBlock->3]],FontSize->20,FontWeight->Bold]}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]],Alignment->{Center,Center}],
					SpanFromLeft
				}
			},
			(* Contents if NOT including Full Utilization *)
			{
				{
					Item[Column[{
						TextCell[Style["Current Utilization",FontWeight->Bold,FontFamily->"Helvetica",FontSize->18],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					SpanFromLeft,
					SpanFromLeft
				},
				{
					" ",
					Item[Column[{
						TextCell[Style["Traditional Laboratory",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
					Item[Column[{
						TextCell[Style["ECL Services",FontWeight->Bold,FontFamily->"Helvetica",FontSize->13,FontColor->RGBColor["#299984"]],TextAlignment->Center]
					}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]]
				},
				{
					Item[TextCell[Style[Superscript["Operational Hours"," a"],FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Right], Frame -> Directive[GrayLevel[0.8]],Alignment-> {Right,Center}],
					Item[Column[{
						Style[ToString[NumberForm[Round[Unitless[laborHoursActualUtilization]],DigitBlock->3]]<>" hours",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style["calculated based on ",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]],
							Style["current average daily hours utilized to run protocols",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]]
						}], TextAlignment->Center]
					},
						Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					SpanFromLeft
				},
				{
					Item[TextCell[Style[Superscript["Scientists on Staff"," b"],FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style[ToString[numberOfWorkersActualUtilization]<>" scientist(s)",FontSize->16],
						TextCell[Row[{
							Style["40 hours/week ",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic],
							Style["in the laboratory",FontFamily->"Helvetica", FontSize -> 10]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style[ToString[numberOfECLUsersActualUtilization]<>" ECL user(s)",FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[Round[averageUserHoursPerWeekActual]]<>"/week",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style[" on Command Center",FontFamily->"Helvetica", FontSize -> 10,FontColor->RGBColor["#299984"]]
						}], TextAlignment->Center]
					}, Alignment->Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}]
				},
				{
					Item[TextCell[Style[Superscript["Labor Cost"," c"],FontWeight->Bold,FontFamily->"Helvetica",FontSlant->Italic],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalScientistSalaryActualUtilization]],DigitBlock->3]],FontSize->16],
						TextCell[Row[{
							Style[ToString[numberOfWorkersActualUtilization]<>" scientist(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[totalECLUserSalaryActualUtilization]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
						TextCell[Row[{
							Style[ToString[numberOfECLUsersActualUtilization]<>" ECL user(s) " , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]],
							Style["* renumeration" , FontFamily->"Helvetica",FontSize -> 10,FontColor->RGBColor["#299984"]]
						}],TextAlignment->Center]
					}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]],Alignment-> {Center,Center}]
				},
				{
					Item[TextCell[Style["Labor Savings",FontFamily->"Helvetica",FontWeight->Bold],TextAlignment->Right],Frame->Directive[GrayLevel[0.8]],Alignment->{Right,Center}],
					Item[Column[{
						Style["$"<>ToString[NumberForm[Round[Unitless[laborSavingsActualUtilization]],DigitBlock->3]],FontSize->20,FontWeight->Bold]}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]],Alignment->{Center,Center}],
					SpanFromLeft
				}
			}
		],
		Alignment -> {{Center},{Center}},
		Dividers -> {{2 -> Directive[GrayLevel[0.8]]}, {2 -> Directive[GrayLevel[0.8]]}},
		Frame -> Directive[GrayLevel[0.8],Thickness[2]],
		(*Background->{{{None},RGBColor[0.5,0.5,0.5,0.15]},{None}},*)
		Spacings->{2,2},
		ItemStyle->{FontFamily->"Helvetica"}
	];
	
	laborCostTableCaption = Column[
		If[laborSavingsFullBoolean,
			(* Caption if including Full Utilization *)
			{
				TextCell[Row[{
					Style[Superscript[" ","a"], tableFigureNumbersFootnoteStyle],
					Style["Annual Operational Hours (Current Utilization) ",italicFootnoteStyle],
					Style["is estimated as ",regularFootnoteStyle],
					Style["average daily hours utilized ",italicFootnoteStyle],
					Style["* 365. ",regularFootnoteStyle],
					Style["Annual Operational Hours (Full Utilization) ",italicFootnoteStyle],
					Style["is estimated as ",regularFootnoteStyle],
					Style["average number of experiments available to run at any given time ",italicFootnoteStyle],
					Style["* 24 hours * 365. ",regularFootnoteStyle]
				}],TextJustification->1],
				TextCell[Row[{
					Style[Superscript[" ","b"], tableFigureNumbersFootnoteStyle],
					Style["Number of Scientists (Current Utilization) ",italicFootnoteStyle],
					Style["is the number of scientists needed to complete the operational hours at current utilization assuming a 40-hour work week per scientist for 48 weeks annually. ",regularFootnoteStyle],
					Style["Number of ECL Users (Current Utilization) ",italicFootnoteStyle],
					Style["is the number of users completing at least 1 protocol per week working "<>ToString[Round[averageUserHoursPerWeekActual]]<>"/week per user on CCD. ",regularFootnoteStyle],
					Style["Number of Scientists (Full utilization) ",italicFootnoteStyle],
					Style["is the number of scientists needed to complete the operational hours at full utilization assuming a 40-hour work week for 48 weeks annually. ",regularFootnoteStyle],
					Style["Number of ECL Users (Full Utilization) ",italicFootnoteStyle],
					Style["is the Number of ECL Users (Current Utilization) * (Full Utilization Hours/Current Utilization Hours) working "<>ToString[Round[averageUserHoursPerWeekFull]]<>"/week per user on CCD. ",regularFootnoteStyle]
				}],TextJustification->1],
				TextCell[Row[{
					Style[Superscript[" ","c"], tableFigureNumbersFootnoteStyle],
					Style["Renumeration Cost ",italicFootnoteStyle],
					Style["is calculated as Scientist Mean Annual Wage * 1.3 to account for benefits and other compensation. The Mean Wage of "<>"$"<>ToString[NumberForm[Round[Unitless[annualScientistMeanWage]],DigitBlock->3]]<>" is based on the Mean Annual Wage of Life Science Scientists in Scientific Research and Developmental Services according to US Bureau of Labor Statistics as of May 2023",regularFootnoteStyle]
				}],TextJustification->1]
			},
			(* Caption if NOT including Full Utilization *)
			{
				TextCell[Row[{
					Style[Superscript[" ","a"], tableFigureNumbersFootnoteStyle],
					Style["Annual Operational Hours (Current Utilization) ",italicFootnoteStyle],
					Style["is estimated as ",regularFootnoteStyle],
					Style["average daily hours utilized ",italicFootnoteStyle],
					Style["* 365. ",regularFootnoteStyle]
				}],TextJustification->1],
				TextCell[Row[{
					Style[Superscript[" ","b"], tableFigureNumbersFootnoteStyle],
					Style["Number of Scientists (Current Utilization) ",italicFootnoteStyle],
					Style["is the number of scientists needed to complete the operational hours at current utilization assuming a 40-hour work week per scientist for 48 weeks annually. ",regularFootnoteStyle],
					Style["Number of ECL Users (Current Utilization) ",italicFootnoteStyle],
					Style["is the number of users completing at least 1 protocol per week working "<>ToString[Round[averageUserHoursPerWeekActual]]<>"/week per user on CCD. ",regularFootnoteStyle]
				}],TextJustification->1],
				TextCell[Row[{
					Style[Superscript[" ","c"], tableFigureNumbersFootnoteStyle],
					Style["Renumeration Cost ",italicFootnoteStyle],
					Style["is calculated as Scientist Mean Annual Wage * 1.3 to account for benefits and other compensation. The Mean Wage of "<>"$"<>ToString[NumberForm[Round[Unitless[annualScientistMeanWage]],DigitBlock->3]]<>" is based on the Mean Annual Wage of Life Science Scientists in Scientific Research and Developmental Services according to US Bureau of Labor Statistics as of May 2023",regularFootnoteStyle]
				}],TextJustification->1]
			}
		],
		Alignment->Right
	];
	
	laborCostTableSection = Column[
		{
			laborCostTableTitle,
			laborSavingsTable,
			laborCostTableCaption
		},
		Left,
		Spacings->1.5
	];
	
	totalSavingsTableNumber = Which[
		MatchQ[target,User],
		"TABLE 3",
		MatchQ[target,Company],
		"TABLE 4"
	];
	
	totalSavingsTableTitle= TextCell[Row[{
		Style[totalSavingsTableNumber<>".",FontSize->14,FontWeight->"Bold",FontTracking->"Extended",FontFamily->"Helvetica",FontColor->Black],
		Style[" Cost Comparison of Instruments and Labor for Traditional Laboratory vs ECL Service ",FontSize->14,FontWeight->Bold,FontFamily->"Helvetica",FontColor->RGBColor[0.3,0.3,0.3]]
	}],TextJustification->1];
	
	totalSavingsTable = Grid[{
		{
			" ",
			Item[Column[{
				TextCell[Style["Traditional Laboratory Costs",FontWeight->Bold,FontFamily->"Helvetica"],TextAlignment->Center]
			}, Alignment -> Center],Frame->Directive[GrayLevel[0.8]]],
			TextCell[Style["ECL Service Costs",FontWeight->Bold,FontColor->RGBColor["#299984"],FontFamily->"Helvetica"],TextAlignment->Center]
		},
		{
			Item[Style["Instrument Costs",FontWeight->Bold], Frame -> Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[totalInstrumentOwnershipCost]],DigitBlock->3]],FontSize->16],
				Column[{TextCell[Row[{
					Style["estimated cost includes instrument purchase price, real estate costs, utilities costs, and maintenance costs",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic]
				}], TextAlignment->Center]
				},Alignment->Left,Spacings->0.5]
			},
				Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]
			],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[averageInstrumentTimeChargePerYear]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
				Column[{
					TextCell[Row[{Style["estimated annual cost based on instrument charges on inclusive bills for the report period; inclusive of instrument usage, qualifications and maintenances performed",FontFamily->"Helvetica", FontSize -> 10,FontSlant->Italic,FontColor->RGBColor["#299984"]]
					}], TextAlignment->Center]
				},Alignment->Left,Spacings->0.5]
			},
				Alignment -> Center,Spacings->0.5],Frame->Directive[GrayLevel[0.8]]
			]
		},
		{
			Item[Style["Labor Costs",FontWeight->Bold,FontSlant->Italic],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[totalScientistSalaryActualUtilization]],DigitBlock->3]],FontSize->16],
				TextCell[Row[{
					Style["total salary for "<>ToString[numberOfWorkersActualUtilization]<>" staff scientists with an average salary of $"<>ToString[NumberForm[Unitless[annualScientistMeanWage],DigitBlock->3]]<>" per year multiplied by a factor of 1.3 to include benefits and other compensation" , FontFamily->"Helvetica",FontSize -> 10,FontSlant->Italic]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[totalECLUserSalaryActualUtilization]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
				TextCell[Row[{
					Style["total salary for "<>ToString[numberOfECLUsersActualUtilization]<>" ECL Scientist Users with an average salary of $"<>ToString[NumberForm[Unitless[annualScientistMeanWage],DigitBlock->3]]<>" per year multiplied by a factor of 1.3 to include benefits and other compensation" , FontFamily->"Helvetica",FontColor->RGBColor["#299984"],FontSize -> 10,FontSlant->Italic]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[Style["ECL Service Cost",FontWeight->Bold],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				TextCell[Row[{
					Style["N/A" , FontFamily->"Helvetica",FontSize -> 16,FontSlant->Italic]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[labAccessFeePerDay*365]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"]],
				TextCell[Row[{
					Style["(inclusive of lab access, operator labor, and discounts for instrument usage, waste disposal, stocking and cleaning depending on subscription)" , FontFamily->"Helvetica",FontColor->RGBColor["#299984"],FontSize -> 10,FontSlant->Italic]
				}],TextAlignment->Center]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[Style["Total Costs",FontWeight->Bold,FontSlant->Italic],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[traditionalLabTotalCost]],DigitBlock->3]],FontSize->16,FontSlant->Italic]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[eclLabTotalCost]],DigitBlock->3]],FontSize->16,FontColor->RGBColor["#299984"],FontSlant->Italic]
			}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]]
		},
		{
			Item[Style["Annual Total Savings",FontWeight->Bold,FontSize->18],Frame->Directive[GrayLevel[0.8]]],
			Item[Column[{
				Style["$"<>ToString[NumberForm[Round[Unitless[Unitless[traditionalLabTotalCost]-Unitless[eclLabTotalCost]]],DigitBlock->3]],FontSize->18,FontWeight->Bold]}, Alignment -> Center,Spacings->1],Frame->Directive[GrayLevel[0.8]]],
			SpanFromLeft
		}
	},
		Alignment -> {{Left},{Center}},
		Dividers -> {{2 -> Directive[GrayLevel[0.8]]}, {2 -> Directive[GrayLevel[0.8]]}},
		Frame -> Directive[GrayLevel[0.8],Thickness[2]],
		Spacings->{2,2},
		ItemStyle->{FontFamily->"Helvetica"}
	];
	
	totalSavingsTableCaption = TextCell[Row[{
		Style[totalSavingsTableNumber<>": ", tableFigureNumbersFootnoteStyle],
		Style["Calculated savings is based on numbers pulled from actual utilization within the report period and does not yet include potential additional savings for shipping, storage, cleaning, and software services included in ECL services",italicFootnoteStyle]
	}],TextJustification->1];
	
	totalSavingsTableSection = Column[
		{
			totalSavingsTableTitle,
			totalSavingsTable,
			totalSavingsTableCaption
		},
		Left,
		Spacings->1.5
	];
	
	valuePropositionSection = {
		{Section,"VALUE PROPOSITION",PageBreakAbove->True},
		{Subsubsection,"Instrument Savings",None},
		{instrumentCostTableSection,None},
		{Subsubsection,"Labor Savings",PageBreakAbove->True},
		{laborCostTableSection,None},
		{Subsubsection,"Total Instrument and Labor Savings",PageBreakAbove->True},
		{totalSavingsTableSection,None}
	};
	
	
	(* Generate Report *)
	
	financingTeamNames=Experiment`Private`fastAssocLookup[financingTeamsFastAssoc,#,Name]&/@myFinancingTeams;
	
	docName=StringJoin[Riffle[financingTeamNames,"&"]," - Customer Report - ",DateString[Now,{"Year","Month","Day","Hour","Minute","Second"}]];
	docNotebookExtension =".nb";
	docPDFExtension =".pdf";
	
	docPath = FileNameJoin[{$TemporaryDirectory,docName}];
	
	reportTitle = TextCell[Column[
		{
			Graphics[
				ImportCloudFile[Object[EmeraldCloudFile, "Hexagon Emerald Cloud Lab Horizontal Logo"]],
				Background -> Transparent
			],
			If[MatchQ[Length[financingTeamNames],GreaterP[1]],
				Row[
					MapIndexed[
						If[MatchQ[#2,{Length[financingTeamNames]}],
							Style[
								ToUpperCase[#],
								FontSize -> 40,
								FontWeight -> Bold,
								FontFamily -> "Helvetica",
								FontColor -> RGBColor["#333333"]
							],
							Style[
								ToUpperCase[#]<>", ",
								FontSize -> 40,
								FontWeight -> Bold,
								FontFamily -> "Helvetica",
								FontColor -> RGBColor["#333333"]
							]
						]&,
						financingTeamNames
					]
				],
				Row[{
					Style[
						ToUpperCase[First[financingTeamNames]],
						FontSize -> 40,
						FontWeight -> Bold,
						FontFamily -> "Helvetica",
						FontColor -> RGBColor["#333333"]
					]
				}]
			],
			Style[
				"CUSTOMER REPORT",
				FontWeight -> "Medium",
				FontSize -> 25,
				FontTracking -> "Narrowed",
				FontFamily -> "Helvetica",
				FontColor -> RGBColor["#299984"]
			],
			Row[{
				Style[
					DateString[startDate, {"Day", " ", "MonthName", " ", "Year"}],
					FontWeight -> Bold,
					FontSize -> 17,
					FontTracking -> "Narrowed", FontFamily -> "Helvetica",
					FontColor -> RGBColor["#595C5B"], FontSlant -> Italic
				],
				Style[
					"  to  ",
					FontSize -> 15,
					FontTracking -> "Narrowed",
					FontFamily -> "Helvetica",
					FontColor -> RGBColor["#595C5B"],
					FontSlant -> Italic
				],
				Style[
					DateString[endDate, {"Day", " ", "MonthName", " ", "Year"}],
					FontWeight -> Bold,
					FontSize -> 17,
					FontTracking -> "Narrowed",
					FontFamily -> "Helvetica",
					FontColor -> RGBColor["#595C5B"],
					FontSlant -> Italic
				]
			}]
		},
		Spacings -> 1,
		Alignment->Left
	],TextJustification->1];
	
	(* assign booleans to indicate whether a section is included in the report *)
	
	(* scientistLaborProductivitySection is always included in the reports and the boolean is always True *)
	scientistLaborProductivityBoolean = True;
	
	(* protocolMetricsSection is included if there are inRangeProtocolLogs *)
	teamEfficiencyMetricsBoolean = MatchQ[inRangeProtocolLogs,Except[{}]];
	
	(* If no InstrumentLogs are found for the report period, instrumentMetricsSection is not included in the reports *)
	instrumentMetricsBoolean = MatchQ[instrumentUsageSummaryByModelData,Except[{}]];
	
	(* protocolMetricsSection is included if there are inRangeProtocolLogs *)
	protocolMetricsBoolean = MatchQ[inRangeProtocolLogs,Except[{}]];
	
	(* if values comparative values fail criteria (mostly 2X), do not show Value Proposition table *)
	valuePropositionBoolean = MatchQ[totalInstrumentOwnershipCost,GreaterEqualP[(averageInstrumentTimeChargePerYear*2)]]
		&& MatchQ[numberOfWorkersActualUtilization,GreaterEqualP[numberOfECLUsersActualUtilization*2]]
		&& MatchQ[numberOfWorkersFullUtilization,GreaterEqualP[numberOfECLUsersFullUtilization*2]]
		&& MatchQ[traditionalLabTotalCost,GreaterP[eclLabTotalCost*2]];
	
	(* put together the contents based on Target and booleans for the different sections *)
	(* each section is converted into a Sequence to properly work with the Export function *)
	reportContents=Which[
		MatchQ[target,User],
		{
			{reportTitle,None},
			Sequence@@Map[
				Sequence@@#&,
				PickList[
					{scientistLaborProductivitySection, teamEfficiencyMetricsSection, instrumentMetricsSection, protocolMetricsSection},
					{scientistLaborProductivityBoolean, teamEfficiencyMetricsBoolean, instrumentMetricsBoolean, protocolMetricsBoolean}
				]
			]
		},
		MatchQ[target,Company],
		{
			{reportTitle,None},
			Sequence@@Map[
				Sequence@@#&,
				PickList[
					{scientistLaborProductivitySection, valuePropositionSection, instrumentMetricsSection, protocolMetricsSection, teamEfficiencyMetricsSection},
					{scientistLaborProductivityBoolean, valuePropositionBoolean, instrumentMetricsBoolean, protocolMetricsBoolean, teamEfficiencyMetricsBoolean}
				]
			]
		}
	];
	
	(* format reportContents as appropriate input for Cells, including the option PageAboveBreak which is not originally included in ExportReport *)
	expandedContentsWithStyles = Flatten[Map[
		Function[section,
			If[MatchQ[section, {ReportStyleP, ___}],
				{{ToString[section[[1]]],section[[2]],section[[3]] }},
				{{If[MatchQ[section[[1]], _String], "Text", "Output"], section[[1]],section[[2]]}}
			]
		],
		reportContents
	], 1];
	
	notebookCells=Map[Function[section,
		Cell[
			(* If the contents are not text, put them in a box *)
			If[MatchQ[section[[2]], _String],
				section[[2]],
				BoxData[ToBoxes[section[[2]]]]
			],
			(* Use the specified style *)
			ToString[section[[1]]],
			section[[3]]
		]
	], expandedContentsWithStyles];
	
	(* Export as a notebook *)
	
	(* get team notebooks to attcah the new objects to *)
	financingTeamNotebooks = Experiment`Private`fastAssocLookup[financingTeamsFastAssoc,#,DefaultNotebook]&/@myFinancingTeams;
	
	report = Export[
		docPath<>docNotebookExtension,
		Notebook[notebookCells,StyleDefinitions->"CommandCenter.nb"]
	];
	
	(* A notebook version of the pdf must first be made before it can successfully created (filename.pdf.nb) *)
	exportedNb= NotebookOpen[docPath<>docNotebookExtension];
	
	(* NotebookPrint to essentially export the pdf *)
	exportedPDF=Export[
		docPath<>docPDFExtension,
		Notebook[
			notebookCells,
			WindowSize -> {792,800},
			WindowMargins -> {{0, Automatic}, {Automatic, 0}},
			PrintingOptions -> {
				"PaperSize" -> {612, 792}
			},
			StyleDefinitions->"CommandCenter.nb"]
	];
	
	(* Close the notebook *)
	NotebookClose[exportedNb];
	
	(* Create cloudfile packet for notebook - file is uploaded to AWS even if Upload->False*)
	notebookPackets = UploadCloudFile[docPath<>docNotebookExtension,Notebook->#,Upload->False]&/@financingTeamNotebooks;
	
	(* Create cloudfile packet for pdf - file is uploaded to AWS even if Upload->False*)
	pdfPackets = UploadCloudFile[docPath<>docPDFExtension,Notebook->#,Upload->False]&/@financingTeamNotebooks;
	
	(* update the financing team object to log the generated notebook and pdf report *)
	updatedFinancingTeamPackets=MapThread[
		<|
			Object->#1,
			Append[CustomerMetricsNotebooks]->Link[Lookup[#2,Object]],
			Append[CustomerMetricsPDFs]->Link[Lookup[#3,Object]]
		|>&,
		{
			myFinancingTeams,
			notebookPackets,
			pdfPackets
			
		}
	];
	
	(* set up Email details *)
	emailSubject = "Customer Metrics Automated Report";
	
	emailContents = StringJoin["Attached is the Customer Metrics Report for ",Riffle[financingTeamNames,"&"]," from ",DateString[startDate,{"MonthName", " ","Day",", ", "Year"}]," to ",DateString[endDate,{"MonthName", " ","Day",", ", "Year"}]];
	
	emailAttachments = {docPath<>docPDFExtension};
	
	emailAddressAssociation = {
		Author -> {"jireh.sacramento@emeraldcloudlab.com"},
		Sales -> {"jon.clark@emeraldcloudlab.com","andrew.heywood@emeraldcloudlab.com","frezza@emeraldcloudlab.com"},
		Solutions->{"malav.desai@emeraldcloudlab.com","ben@emeraldcloudlab.com","melanie.reschke@emeraldcloudlab.com","taylor.hochuli@emeraldcloudlab.com","dirk.schild@emeraldcloudlab.com"},
		Customer -> (Experiment`Private`fastAssocLookup[financingTeamsFastAssoc,#,Email]&/@allUniqueMembers)
	};
	
	emailRecipientList = DeleteDuplicates[Flatten[ToList[emailRecipient/.emailAddressAssociation]]];
	emailBccList = DeleteDuplicates[Flatten[ToList[emailBcc/.emailAddressAssociation]]];
	
	(* If Email option is True, set-up email before uploading and deleting the created files on local *)
	If[email,
		Email[
			emailRecipientList,
			Bcc->emailBccList,
			Subject->emailSubject,
			Message->emailContents,
			Attachments->emailAttachments
		]
	];
	
	If[upload,
		(* If Upload -> True, upload the packets, delete the exported files, then return the objects *)
		Module[{notebookObjects,pdfObjects,updatedFinancingTeams},
			
			(* upload the packets*)
			{notebookObjects,pdfObjects,updatedFinancingTeams}=Upload[#]&/@{notebookPackets,pdfPackets,updatedFinancingTeamPackets};
			
			(* Delete the nb and pdf files that we exported after uploading *)
			Quiet[DeleteFile[docPath<>docPDFExtension<>docNotebookExtension]];
			Quiet[DeleteFile[docPath<>docPDFExtension]];
			
			(* return the objects *)
			{notebookObjects,pdfObjects,updatedFinancingTeams}
		],
		
		(* If Upload -> False, Delete the nb and pdf files that we exported then return the packets *)
		Quiet[DeleteFile[docPath<>docPDFExtension<>docNotebookExtension]];
		Quiet[DeleteFile[docPath<>docPDFExtension]];
		
		(* return the packets - cloudfiles are uploaded to AWS even if Upload->False so they still show up in the packet *)
		{notebookPackets,pdfPackets,updatedFinancingTeamPackets}
	]
	
];


(* ::Subsection::Closed:: *)
(* PlotCommandCenterActivity *)

DefineOptions[PlotCommandCenterActivity,
	Options :> {
		{UserDepartments->{},{___Rule}, "A list of replacement rules indicating which user belongs to which department orfunctional group."},
		{HideInactiveUsers->True, BooleanP, "Determines whether users with very little Command Center activity will be hidden to declutter plots."},
		{InactiveUserThreshold->3 Hour, TimeP|PercentP, "The amount of Command Center activity below which a user will not be included in plots if HideInactiveUsers->True. If specified as a time, users with cumulative activity less than that time will be omitted. If specified as a Percent, users with cumulative activity less than that percentage of the most active user in their functional group will be omitted."},
		{OutputFormat->Plot, Plot|Table, "The type of output desired, either Plot or Table."}
	}
]

Error::DateRangeTooShort = "The requested date range is too short (`1`) to generate a meaningful plot. Please specify a date range of at least 3 days.";
Error::DateRangeInvalid = "The start date (`1`) is after the end date (`2`). Please ensure the start date is before the end date.";
(* Also reuses Error::MissingReports from PlotCustomerMetrics above *)

(* Default to the start date up to yesterday if no end date is provided *)
PlotCommandCenterActivity[team:ObjectP[Object[Team, Financing]], startDate_?DayObjectQ, ops:OptionsPattern[]] := PlotCommandCenterActivity[team, startDate, Yesterday, ops]

(* Default to the last month if no start/end date are provided *)
PlotCommandCenterActivity[team:ObjectP[Object[Team, Financing]], ops:OptionsPattern[]] := PlotCommandCenterActivity[team, Yesterday-Month, Yesterday, ops]

(* Main function: takes team, start date, and end date *)
PlotCommandCenterActivity[team:ObjectP[Object[Team, Financing]], startDate_?DayObjectQ, endDate_?DayObjectQ, ops:OptionsPattern[]] := Module[
	{safeOps, userDepartmentLookup, hideInactiveUsersQ, inactiveUserThreshold, outputFormat, 
		userDepartmentLookupWithDefault, convertedStartTime, convertedEndTime, allMetricsReports, allExperiments, downloadResult, allStartDates,allEndDates,allUtilizationSummaries, 
		reportDateRangeTuples, datesCoveredByReports, daysNeeded, missingReportDates, missingReportDateRange, allExperimentPackets, experimentPacketsFilteredByDate, 
		combinedUtilizationSummaries, dateFilteredUtilizationSummaries, objectToNamedObject, namedActivityLogs, culledNamedActivityLogs, activityLogsByUser, ccActivityByUser, datesByUser,
		cumulativeActivityByUser, namedUserObjects, objectToName, userNames, userDepartments, packetCreatorObjects, experimentPacketsByUser, activityPointsByUser, ccActivityTuplesByUser, 
		protocolEpilogPointsByUser, ccActivityInfoGatheredByDepartment, ccActivityTuplesGatheredAndTrimmed},

	(* Fail with error immediately if the provided financing team does not exist *)
	If[!DatabaseMemberQ[team],
		(
			Message[Error::TeamNotFound,team];
			Return[$Failed]
		)
	];

	(* Get those sweet safe options *)
	safeOps = SafeOptions[PlotCommandCenterActivity, ToList[ops]];

	(* Extract defaulted option values for use below *)
	{userDepartmentLookup, hideInactiveUsersQ, inactiveUserThreshold, outputFormat} = Lookup[safeOps, {UserDepartments, HideInactiveUsers, InactiveUserThreshold, OutputFormat}];

	(* Add on the default case to the user department lookup *)
	userDepartmentLookupWithDefault = Append[userDepartmentLookup, ObjectP[Object[User]]->"Department not specified"];

	(* from PlotCustomerMetrics *)
	(* Convert the start date to starting second of that date in the "America/Chicago" TimeZone *)
	convertedStartTime=DateObject[
		Join[startDate[[1]],{00,00,00.}],
		"Instant", "Gregorian", "America/Chicago"
	];
	
	(* Convert the end date to last second of the day in the "America/Chicago" TimeZone - this is to cover the full day of the end date *)
	convertedEndTime=DateObject[
		Join[endDate[[1]],{23,59,59.}],
		"Instant", "Gregorian", "America/Chicago"
	];

	(* Check if the start date is before the end date *)
	If[convertedStartTime>convertedEndTime,
		(
			Message[Error::DateRangeInvalid, DateString[convertedStartTime], DateString[convertedEndTime]];
			Return[$Failed]
		)
	];

	(* Plots won't be meaningful for less than 3 days of data; throw an error and return $Failed if that is the case *)
	If[DateDifference[convertedStartTime,convertedEndTime]<3 Day,
		(
			Message[Error::DateRangeTooShort, ToString[Round[DateDifference[convertedStartTime,convertedEndTime], 0.1]]];
			Return[$Failed]
		)
	];


	(* Find all metrics reports for the provided team that end on or after the provided date, as well as all experiments run by the provided team within the relevant time frame *)
	(* We still want reports that started before the provided start date because we may need a subset of their entries to assemble a complete record *)
	{allMetricsReports, allExperiments} = Search[
		{
			Object[Report, CustomerMetrics],
			Object[Protocol]
		}, 
		{
			And[
				(* Report pertains to the specified financing team *)
				FinancingTeam==team,
				(* Report overlaps with the specified date range on one end or the other, or fully spans the specified date range *)
				Or[
					(* StartDate is before the beginning of the date range and end date is after the beginning of the date range *)
					(StartDate <= convertedStartTime && EndDate >= convertedStartTime),
					(* StartDate is between the beginning of the date range and the end of the date range *)
					(StartDate >= convertedStartTime && StartDate <= convertedEndTime)
				]
			],
			ParentProtocol==Null && Notebook[Financers]==team && Status!=(InCart|Canceled) && DateEnqueued>=convertedStartTime && DateEnqueued<=convertedEndTime
		}	
	];

	(* Download all required information *)
	downloadResult = Flatten/@Download[
		{
			allMetricsReports,
			{team},
			allExperiments
		},
		{
			{Packet[StartDate, EndDate, UserUtilizationSummary]},
			{Members[Packet[{Name, FirstName, LastName}]]},
			{Packet[DateEnqueued, DateCompleted, Author]}
		}
	];

	{allStartDates, allEndDates, allUtilizationSummaries} = Transpose[Lookup[downloadResult[[1]], {StartDate, EndDate, UserUtilizationSummary}]];

	(* === Verify the there are report objects that covers all the dates requested for the report === *)

	(* create the list of dates needed for the report and check for missing days from the dates covered by the above utilization summaries *)
	daysNeeded = DateRange[startDate,endDate];

	(* If there are no reports at all, throw an error to that effect to short-circuit the logic below that will break with no reports *)
	If[Length[downloadResult[[1]]]==0, 
		(
			missingReportDateRange = DateString[convertedStartTime,{"MonthNameShort", " ", "Day", " ", "Year"}]<>" to "<>DateString[convertedEndTime,{"MonthNameShort", " ", "Day", " ", "Year"}];
			Message[Error::MissingReports,team,missingReportDateRange,"PlotCommandCenterActivity"];
			Return[$Failed]
		)
	];

	(* Pair up start and end dates *)
	reportDateRangeTuples = Transpose[{allStartDates, allEndDates}];

	(* the dates need to be converted to "America/Chicago" then manually converted to the form DateObject[{YYYY,MM,DD}] - DayRound will not work since it will first convert to the $TimeZone and mess up the logic of the search dates; followed by creating a list of dates via DateRange and creating a sorted list of all  unique dates included in the reports *)
	datesCoveredByReports = Sort[DeleteDuplicates[Join[Sequence@@Map[
		DateRange[
			DateObject[TimeZoneConvert[#[[1]],"America/Chicago"][[1]][[1;;3]]],
			DateObject[TimeZoneConvert[#[[2]],"America/Chicago"][[1]][[1;;3]]]
		]&,
		reportDateRangeTuples
	]]]];

	(* get the list of dates needed that are not covered by the exsiting report objects, if any *)
	missingReportDates = Sort[Complement[daysNeeded,datesCoveredByReports]];

	(* throw an error if there are dates not covered by exisiting report objects *)
	If[MatchQ[missingReportDates,{_?DateObjectQ ..}],
		(
			missingReportDateRange = DateString[First[missingReportDates],{"MonthNameShort", " ", "Day", " ", "Year"}]<>" to "<>DateString[Last[missingReportDates],{"MonthNameShort", " ", "Day", " ", "Year"}];
			Message[Error::MissingReports,team,missingReportDateRange,"PlotCommandCenterActivity"];
			Return[$Failed]
		)
	];


	(* === Parse apart the download result and filter protocols and activity reports to only the requested dates === *)

	(* Extract experiment packets from the download above and filter to remove any that are too recent to be included *)
	allExperimentPackets = downloadResult[[3]];
	experimentPacketsFilteredByDate = PickList[allExperimentPackets, Lookup[allExperimentPackets, DateEnqueued], LessEqualP[convertedEndTime]];

	(* Multiple overlapping utilization summaries may exist, but any entry for a given user on a given date should be identical between reports *)
	(* Combine the UserUtilizationSummary entries from all relevant CustomerMetrics reports and dedupe all entries for the same user on the same date *)
	combinedUtilizationSummaries = DeleteDuplicatesBy[Join@@allUtilizationSummaries, #[[{1,3}]]&];

	(* Remove any entries before the provided StartDate or after the provided EndDate *)
	dateFilteredUtilizationSummaries = DeleteCases[combinedUtilizationSummaries, {LessP[convertedStartTime]|GreaterP[convertedEndTime], __}];


	(* === Process activity logs and assemble data to be plotted or tabularized === *)

	(* Replace objects with named objects in activity logs *)
	(* Doing it this way to avoid the additional Download of calling NamedObject *)
	objectToNamedObject = Map[
		With[{obj = Lookup[#, Object], name = Lookup[#, Name]},
			Link[obj, _]->ReplacePart[obj, {-1->name}]
		]&,
		downloadResult[[2]]
	];
	namedActivityLogs = ReplaceAll[dateFilteredUtilizationSummaries, objectToNamedObject];

	(* Remove any entries for users that are no longer members of the financing team *)
	culledNamedActivityLogs = DeleteCases[namedActivityLogs, {_, Except[Alternatives@@NamedObject[downloadResult[[2]]]], __}];

	(* Gather activity logs by user and sort *)
	activityLogsByUser = SortBy[#,First]& /@ GatherBy[culledNamedActivityLogs, #[[2]]&];

	(* Extract total CC activity time and associated dates for each user *)
	ccActivityByUser = activityLogsByUser[[All, All, -1]];
	datesByUser = activityLogsByUser[[All, All, 1]];

	(* Accumulate the CC activity time for each user *)
	cumulativeActivityByUser = Accumulate/@ccActivityByUser;

	(* Extract the user objects *)
	(* These will already have all user objects in named form so the lookup below will work as expected *)
	namedUserObjects = activityLogsByUser[[All,1,2]];

	(* Assemble first and last names into full names for each user*)
	objectToName = Map[
		With[{obj = Lookup[#, Object], name = Lookup[#, Name], firstName = Lookup[#, FirstName], lastName = Lookup[#, LastName]},
			ReplacePart[obj, {-1->name}]->StringRiffle[{firstName, lastName}]
		]&,
		downloadResult[[2]]
	];
	userNames = ReplaceAll[namedUserObjects, objectToName];

	(* Look up each user's department / function *)	
	(* Assumes the userDepartmentLookup input contains named objects as opposed to IDs *)
	userDepartments = namedUserObjects /. userDepartmentLookupWithDefault;

	(* Assemble a list of the authors of every experiment, then use that to gather up the packets authored by each individual user *)
	(* This ends up being much faster than something like Cases with KeyValuePattern *)
	packetCreatorObjects = Download[Lookup[experimentPacketsFilteredByDate, Author], Object];
	experimentPacketsByUser = Function[singleUser, PickList[experimentPacketsFilteredByDate, packetCreatorObjects, singleUser]] /@ namedUserObjects[Object];

	(* Assemble date/activity plot points for each user *)
	activityPointsByUser = MapThread[Transpose[{#1, #2}]&, {datesByUser,cumulativeActivityByUser}];

	(* Generate all experiment epilogs for their experiments *)
	protocolEpilogPointsByUser = MapThread[
		Function[{datePlotPoints, experimentEndDates},
			If[Length[datePlotPoints]>1,
				Module[
					{absoluteDatePlotPoints, plotInterpolatingFunction, experimentDatesAbsolute, experimentYValues, dateEpilogPoints},

					absoluteDatePlotPoints = Transpose[{AbsoluteTime/@datePlotPoints[[All,1]], datePlotPoints[[All,2]]}];

					plotInterpolatingFunction = Interpolation[absoluteDatePlotPoints];

					experimentDatesAbsolute = AbsoluteTime /@ experimentEndDates;

					experimentYValues = Quiet[plotInterpolatingFunction /@ experimentDatesAbsolute, InterpolatingFunction::dmval];

					dateEpilogPoints = DeleteCases[Transpose[{experimentEndDates, experimentYValues}], {GreaterP[endDate], _}]

				],
				{}
			]
		],
		{activityPointsByUser, Lookup[#, DateEnqueued, {}]&/@experimentPacketsByUser}
	];

	(* Transpose together the above information to create a tuple for each user *)
	ccActivityTuplesByUser = Transpose[{
		namedUserObjects,				(* 1: Named object *)
		activityPointsByUser,			(* 2: {x,y} pairs of daily cumulative CC activity *)
		experimentPacketsByUser,		(* 3: Packets for all experiments (parent protocols) run by this user *)
		protocolEpilogPointsByUser,		(* 4: {x,y} points for experiment epilogs to be drawn on the plot for this user *)
		userDepartments,					(* 5: Functional group or department this user belongs to in their parent organization *)
		userNames						(* 6: Full name of the user in the form "FirstName LastName" *)
	}];

	(* Gather per-user tuples into functional / departmental groups *)
	ccActivityInfoGatheredByDepartment = GatherBy[
		ccActivityTuplesByUser,
		#[[5]]&
	];

	(* Cull low-activity users after gathering by department to allow for culling by percent of max within each group if desired *)
	(* If culling is being performed, delete any department groups (at level 1) that end up empty after culling *)
	ccActivityTuplesGatheredAndTrimmed = If[hideInactiveUsersQ,
		DeleteCases[
			Switch[inactiveUserThreshold,
				(* If the threshold is a time, cull all users whose cumulative CC activity is below that total time *)
				TimeP,
					Map[
						Function[singleDepartmentTuples,
							PickList[
								singleDepartmentTuples, 
								singleDepartmentTuples[[All,2,-1,-1]], 
								GreaterEqualP[inactiveUserThreshold]
							]
						],
						ccActivityInfoGatheredByDepartment
					],
				(* If the threshold is a percentage, cull all users whose cumulative CC activity is less than that percentage of the highest cumulative activity in this group*)
				PercentP,
					Map[
						Function[singleDepartmentTuples,
							Module[{maxGroupActivity},
								maxGroupActivity = Max[singleDepartmentTuples[[All,2,-1,-1]]];
								PickList[
									singleDepartmentTuples, 
									singleDepartmentTuples[[All,2,-1,-1]], 
									GreaterEqualP[Unitless[inactiveUserThreshold]/100 * maxGroupActivity]
								]
							]
						],
						ccActivityInfoGatheredByDepartment
					]
				(* No default case because SafeOptions should ensure that inactiveUserThreshold is in one of the two expected forms *)
			],
			{},
			{1}
		],
		ccActivityInfoGatheredByDepartment
	];


	(* === Generate plots or table depending on options === *)

	(* Generate output as requested *)
	Switch[outputFormat,
		Plot,
		TabView[
			Normal[AssociationThread[
				(* Team names for tab labels *)
				ccActivityTuplesGatheredAndTrimmed[[All, 1, 5]],
				(* Plots *)
				Map[
					Function[singleTeamInfo,
						Pane[Quiet[Zoomable[EmeraldDateListPlot[
							singleTeamInfo[[All,2]], (* {Date, Cumulative CC time} points *)
							(* Extract the Function / Department from the first member of the group *)
							PlotLabel->Column[
								{
									"Cumulative Command Center usage by user",
									Style[DateString[convertedStartTime,"ISODate"]<>" through "<>DateString[convertedEndTime,"ISODate"],12]
								}, 
								Alignment->Center
							],
							(* Assemble user names and total CC times to use as plot labels *)
							PlotLabels->MapThread[StringJoin[#1, " (", #2,")"]&, {singleTeamInfo[[All,6]], ToString/@Round[Convert[singleTeamInfo[[All,2,-1,-1]], Hour],0.1 Hour]}],
								Epilog->{
									(* TODO: Add back epilog to show dates of training for various users once this info is available in Constellation *)		
									(* Experiment ticks *)
									Thin,Opacity[0.5],Arrowheads[0.02],
									Flatten[MapIndexed[
										Function[{singleUserArrowCoords, userIndex},
											Prepend[
												Arrow[{Scaled[{0,0.01},Unitless[#]], Unitless[#]}]& /@ singleUserArrowCoords,
												ColorData[97][userIndex[[1]]]
											]	
										],
										singleTeamInfo[[All,4]]
									]]
								},
							ImageSize->800
						]]]]
					],
					ccActivityTuplesGatheredAndTrimmed
				]
			]]
		],
		Table,
		With[{flatTableData = Flatten[ccActivityTuplesGatheredAndTrimmed, 1]},
			PlotTable[
				ReverseSortBy[
					Transpose[{flatTableData[[All,6]], flatTableData[[All,5]], Round[Convert[flatTableData[[All,2,-1,-1]], Hour], 0.1]}],
					Last
				],
				TableHeadings->{None, {"User", "Department", "Cumulative Command Center time"}},
				Title->StringJoin["Time spent in Command Center per user (through ",DateString[DayRound[endDate]],")"],
				UnitForm->False
			]
		]
	]

]