(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*HelperFunctions*)


(* ::Subsubsection:: *)
(*GreaterDateQ*)
GreaterDateQ[x_?DateObjectQ,y_?DateObjectQ]:=AbsoluteTime[x]>AbsoluteTime[y];

(* ::Subsubsection:: *)
(*GreaterEqualDateQ*)
GreaterEqualDateQ[x_?DateObjectQ,y_?DateObjectQ]:=AbsoluteTime[x]>=AbsoluteTime[y];

(* ::Subsubsection:: *)
(*LessDateQ*)
LessDateQ[x_?DateObjectQ,y_?DateObjectQ]:=AbsoluteTime[x]<AbsoluteTime[y];

(* ::Subsubsection:: *)
(*LessEqualDateQ*)
LessEqualDateQ[x_?DateObjectQ,y_?DateObjectQ]:=AbsoluteTime[x]<=AbsoluteTime[y];

(* ::Subsubsection:: *)
(*EqualDateQ*)
EqualDateQ[x_?DateObjectQ,y_?DateObjectQ]:=AbsoluteTime[x]==AbsoluteTime[y];

(* ::Subsubsection:: *)
(*minTime*)
minTime[x:ListableP[_?DateObjectQ]]:=Module[{dateList,absTimes},

	(* Convert to a list if its not already *)
	dateList=If[MatchQ[x,_List],x,{x}];

	(* Convert to a list of absolute times *)
	absTimes=AbsoluteTime/@dateList;

	(* Take the smallest item in the list and return the date object from of it *)
	DateObject[First[TakeSmallest[absTimes,1]]]

];

(* ::Subsubsection:: *)
(*maxTime*)
maxTime[x:ListableP[_?DateObjectQ]]:=Module[{dateList,absTimes},

	(* Convert to a list if its not already *)
	dateList=If[MatchQ[x,_List],x,{x}];

	(* Convert to a list of absolute times *)
	absTimes=AbsoluteTime/@dateList;

	(* Take the smallest item in the list and return the date object from of it *)
	DateObject[First[TakeLargest[absTimes,1]]]

];

(* ::Subsubsection:: *)
(*MonitoringTicketTypes*)
MonitoringTicketTypes:={LongTask,QueueReordering,ForceQuit};


(* ::Subsubsection:: *)
(*Closure Date*)
eclCloseDate=DateObject[{2023, 4, 14, 23, 59, 59}, "Instant", "Gregorian", -7.`];
eclReopenDate=DateObject[{2023, 8, 1, 0, 0, 0}, "Instant", "Gregorian", -7.];

(* ::Subsection:: *)
(*PlotSupportRate*)
(* ::Subsubsection:: *)
(*DefineOptions*)
DefineOptions[PlotSupportRate,
	Options:>{}
];
(* ::Subsubsection:: *)
(*Implementation*)
PlotSupportRate[]:=PlotSupportRate[Month];
PlotSupportRate[timeSpan_?TimeQ]:=PlotSupportRate[Today-timeSpan,Today];
PlotSupportRate[startTime_?DateObjectQ,endTime_?DateObjectQ]:=Module[{allProtocols,packetInfo,packetSums,typeMap,plotKeys,plotPoints,labeledData},

	(* Find all the protocols completed inside the time range *)
	allProtocols=Search[Object[Protocol],DateCompleted>=startTime&&DateCompleted<=endTime];

	(* Download all the TS tickets causitively linked for each type for each protocol so we can process the counts by type for each entry *)
	packetInfo=Download[allProtocols,{Type,ProtocolSpecificTickets}];

	(* For each packet, count and sum the number of TS reports and tickets and leave the type at the front of the list *)
	packetSums={First[#],Length[Last[#]]}&/@packetInfo;

	(* Gather the results by Type and then strip the types off the counts on the right hand side of the rules *)
	typeMap=#[[All,2]]&/@GroupBy[packetSums,First];

	(* Get the means and number of protocols for each type, and keep a map of all the types each point is *)
	plotPoints={Length[#],N[100Percent*Mean[#],5]}&/@Values[typeMap];
	plotKeys=Keys[typeMap];

	(* Label the date for plotting *)
	labeledData=MapThread[Labeled[#1,#2]&,{plotPoints,plotKeys}];

	(* Return the final grid of plots of the data *)
	Grid[{
		{
			Zoomable@ListPlot[labeledData,
				ImageSize->Large,
				Frame->{True,True,False,False},
				FrameLabel->{Style["Number of Protocols Run",14,Gray],Style["Troubleshooting Rate (%)",14,Gray]},
				PlotRange->{Full,{0,Full}}
			],
			Zoomable@ListLogLinearPlot[labeledData,
				ImageSize->Large,
				Frame->{True,True,False,False},
				FrameLabel->{Style["Number of Protocols Run",14,Gray],Style["Troubleshooting Rate (%)",14,Gray]},
				PlotRange->{Full,{0,Full}}
			]
		},
		{
			Zoomable@ListLogPlot[labeledData,
				ImageSize->Large,
				Frame->{True,True,False,False},
				FrameLabel->{Style["Number of Protocols Run",14,Gray],Style["Troubleshooting Rate (%)",14,Gray]},
				PlotRange->{Full,{0,Full}}
			],
			Zoomable@ListLogLogPlot[labeledData,
				ImageSize->Large,
				Frame->{True,True,False,False},
				FrameLabel->{Style["Number of Protocols Run",14,Gray],Style["Troubleshooting Rate (%)",14,Gray]},
				PlotRange->{Full,{0,Full}}
			]
		}
	}]

];

(* ::Subsubsection::Closed:: *)
(*PlotSupportDistribution*)
(* ::Subsubsection:: *)
(*DefineOptions*)
DefineOptions[PlotSupportDistributions,
	Options:>{}
];
PlotSupportDistributions::NoProtocols="No protocols with specified protocol types could be found within the specified time period. If you aren't already doing so you may want to specify the exact protocol types and dates of interest using PlotSupportDistributions[protocolType, startDate, endDate].";
(* ::Subsubsection:: *)
(*Implementation*)
PlotSupportDistributions[]:=PlotSupportDistributions[{Object[Protocol]}];
PlotSupportDistributions[types:ListableP[TypeP[Object[Protocol]]]]:=PlotSupportDistributions[types,Year];
PlotSupportDistributions[types:ListableP[TypeP[Object[Protocol]]],timeSpan:TimeP]:=PlotSupportDistributions[types,Today-timeSpan,Today];
PlotSupportDistributions[types:ListableP[TypeP[Object[Protocol]]],startTime_?DateObjectQ,endTime_?DateObjectQ]:=Module[
	{allProtocols,allTS,allTSCounts,typeGroups,typeLabels,plotValues},

	(* Find all the protocols in the date range matching the selected types *)
	allProtocols=Search[types,DateCreated>=startTime&&DateCreated<=endTime];

	(* Throw message and return $Failed if no protocols exist *)
	If[MatchQ[allProtocols,{}],
		Message[PlotSupportDistributions::NoProtocols];Return[$Failed]
	];

	(* Download all the TS reports and tickets for all the protocols *)
	allTS=Download[allProtocols,{Type,ProtocolSpecificTickets}];

	(* Count all the TS reports / tickets for each of the type pairs *)
	allTSCounts={First[#],Length[Last[#]]}&/@allTS;

	(* Regroup by type *)
	typeGroups=#[[All,2]]&/@GroupBy[allTSCounts,First];

	(* Breakout the labels for plotting and the values for plotting *)
	typeLabels=Keys[typeGroups];
	plotValues=Values[typeGroups];

	(* Plot the histogram of the values *)
	Histogram[plotValues,Max[1,Flatten[plotValues]],
		ImageSize->Large,
		ChartLegends->typeLabels,
		Frame->{True,True,False,False},
		FrameLabel->{Style["Number of TS per Protocol",Bold,16,Gray],Style["Count",Bold,16,Gray]}
	]
];


(* ::Subsubsection::Closed:: *)
(*PlotSupportRate*)
(* ::Subsubsection:: *)
(*DefineOptions*)
DefineOptions[PlotTotalSupportRate,
	Options:>{}
];
(* ::Subsubsection:: *)
(*Implementation*)
PlotTotalSupportRate[]:=PlotTotalSupportRate[Month,Day];
PlotTotalSupportRate[timeSpan_?TimeQ]:=PlotTotalSupportRate[timeSpan,timelineBin[timeSpan]];
PlotTotalSupportRate[timeSpan_?TimeQ,bin_?TimeQ]:=PlotTotalSupportRate[Today-timeSpan,Today,bin];
PlotTotalSupportRate[startTime_?DateObjectQ,endTime_?DateObjectQ]:=PlotTotalSupportRate[startTime,endTime,timelineBin[endTime-startTime]];
PlotTotalSupportRate[startTime_?DateObjectQ,endTime_?DateObjectQ,bin_?TimeQ]:=Module[
	{dateTicks,dateBins,datePoints,allTS,allTSandProtocolTimes,allProtocols,allParentProtocols,allParentProtocolTimes,allTSTimes,allProtocolTimes,
		allTSBins,allProtocolBins,allParentProtocolBins,ratePoints,normalizedRatePoints,normalizedParentRatePoints,defaultBlue},

	(* Generate bins of dates for calculating the rates *)
	dateTicks=DateRange[startTime,endTime,bin];
	dateBins = MapThread[{#1,#2}&, {Most[dateTicks],Rest[dateTicks]}];

	(* Calculate the center of the date bins *)
	datePoints=DateObject[Mean[{AbsoluteTime[First[#]],AbsoluteTime[Last[#]]}]]&/@dateBins;

	(* Find all the troubleshooting reports and tickets Generated in the date range *)
	allTS=Search[Object[SupportTicket],DateCreated>=startTime&&DateCreated<=endTime];

	(* Also find all the protocols completed in this time range *)
	allProtocols=Search[ProtocolTypes[],DateCompleted>=startTime&&DateCompleted<=endTime];

	(* Also find all the protocols that are just parent protocols completed in this time range *)
	allParentProtocols=Search[ProtocolTypes[],ParentProtocol==Null&&DateCompleted>=startTime&&DateCompleted<=endTime];

	(* Download all the actual create dates for the TS reports/tickets and all of the complete dates for all the protocols in that time range in the time range *)
	allTSandProtocolTimes=Download[{allTS,allProtocols,allParentProtocols},{{DateCreated},{DateCompleted},{DateCompleted}}];

	(* Split out the TS times into their own varabile *)
	allTSTimes=Flatten[First[allTSandProtocolTimes]];

	(* Split out all the protocol times into their own variable *)
	allProtocolTimes=Flatten[allTSandProtocolTimes[[2]]];

	(* Split out the only protocols *)
	allParentProtocolTimes=Flatten[Last[allTSandProtocolTimes]];

	(* break up the TS times into the time bins *)
	allTSBins=Function[singleBin,Select[allTSTimes,GreaterEqualDateQ[#,First[singleBin]]&&LessEqualDateQ[#,Last[singleBin]]&]]/@dateBins;

	(* break up the protocol times into the time bins *)
	allProtocolBins=Function[singleBin,Select[allProtocolTimes,GreaterEqualDateQ[#,First[singleBin]]&&LessEqualDateQ[#,Last[singleBin]]&]]/@dateBins;

	(* Same thing for the parent protocols times now *)
	allParentProtocolBins=Function[singleBin,Select[allParentProtocolTimes,GreaterEqualDateQ[#,First[singleBin]]&&LessEqualDateQ[#,Last[singleBin]]&]]/@dateBins;

	(* Determine how many tickets are in each bin per unit of bin time and pair them with the date points *)
	ratePoints=Transpose[{datePoints,Convert[Length[#]/bin,1/Day]&/@allTSBins}];

	(* Determine how many tickets per how many protocols happened per day in each time bin and pair that with the date points *)
	(* If we don't have completed protocols for a given day then return -1 in our divide
		- this is a bit of a hack that let's us remove these points (we're doing lengths so we'll never get negative numbers otherwise) *)
	normalizedRatePoints=DeleteCases[
		Transpose[{datePoints,MapThread[safeDivide[Length[#1],Length[#2],-1]*100Percent&,{allTSBins,allProtocolBins}]}],
		{_,LessP[0 Percent]}
	];

	(* Determine how many tickets per how many protocols happened per day in each time bin and pair that with the date points *)
	(* If we don't have completed protocols for a given day then return -1 in our divide
		- this is a bit of a hack that let's us remove these points (we're doing lengths so we'll never get negative numbers otherwise) *)
	normalizedParentRatePoints=DeleteCases[
		Transpose[{datePoints,MapThread[safeDivide[Length[#1],Length[#2],-1]*100Percent&,{allTSBins,allParentProtocolBins}]}],
		{_,LessP[0 Percent]}
	];

	defaultBlue=ColorData[97, "ColorList"][[1]];

	(* Plot the results *)
	Grid[{{
		Zoomable@EmeraldDateListPlot[divideByLabClosure[ratePoints],
			ImageSize->Large,
			Frame->{True,True,False,False},
			FrameLabel->{None,Style["Total Troubleshooting Rate\n(Reports & Tickets per day)",Bold,16,Gray]},
			PlotRange->Automatic,
			PlotLabel->"Total TS Tickets"<>"\nPer "<>ToString[bin]<>" Averaging",
			PlotStyle->defaultBlue
		],
		Zoomable@EmeraldDateListPlot[divideByLabClosure[normalizedParentRatePoints],
			ImageSize->Large,
			Frame->{True,True,False,False},
			FrameLabel->{None,Style["Parent Protocol Troubleshooting Rate (%)",Bold,16,Gray]},
			PlotRange->Automatic,
			PlotLabel->"TS Tickets Per Parent Protocol (%)"<>"\nPer "<>ToString[bin]<>" Averaging",
			PlotStyle->defaultBlue
		],
		Zoomable@EmeraldDateListPlot[divideByLabClosure[normalizedRatePoints],
			ImageSize->Large,
			Frame->{True,True,False,False},
			FrameLabel->{None,Style["Total Protocol Troubleshooting Rate (%)",Bold,16,Gray]},
			PlotRange->Automatic,
			PlotLabel->"TS Tickets Per Protocol (%)"<>"\nPer "<>ToString[bin]<>" Averaging",
			PlotStyle->defaultBlue
		]
	}}]
];

divideByLabClosure[dataPoints_]:=Module[{preClosure, postOpen},
	preClosure=Cases[dataPoints,{LessP[eclCloseDate],_}];
	postOpen=Cases[dataPoints,{GreaterP[eclReopenDate],_}];

	(* If our data range is only pre or post get rid of the empty list *)
	DeleteCases[{preClosure, postOpen},{}]
];

(* ::Subsubsection::Closed:: *)
(*PlotSupportTimeline*)
(* ::Subsubsection:: *)
(*DefineOptions*)
DefineOptions[PlotSupportTimeline,
	Options:>{
		{Tags->{},{}|ListableP[_String],"Indicates which tags tracking different types of error sources are to have their troubleshooting rates displayed."},
		{Annotation->{},{}|ListableP[{_DateObject, _String}],"Indicates the vertical lines that are to be added to the plot to show certain key events."},
		{SampleManipulationSplit->False,BooleanP,"Indicates if SampleManipulation protocols are to be displayed as MicroLiquidHandling or MacroLiquidHandling."},
		{SearchCriteria->True,_And|_Or|_Equal|_Unequal|_,"Additional elements to be included in the And used to find protocols (for instance specify protocols run on only certain instrument models)."},
		{LiquidHandlerSplit->False,BooleanP,"Indicates if SampleManipulation/RoboticSamplePreparation protocols are to be displayed by the liquid handler that they ran on."},
		{Display->Relative,Relative|Absolute|Both,"Indicates if the number of tickets, the percentage of tickets per protocol or both metrics are to be displayed."},
		{RemoveMonitoringTickets->True,BooleanP,"Indicates if tickets used to track daily operations, such as long task tickets are to be shown."},
		{ExcludeCanaryProtocols->False,BooleanP,"Indicates if the tickets generated generated from a root canary protocol should be excluded from the plot."}
	},
	SharedOptions:>{EmeraldDateListPlot}
];

PlotSupportTimeline::NoProtocols="No completed protocols could be found within the specified time period. If you aren't already doing so you may want to specify the exact dates of interest using PlotSupportTimeline[(protocol), startDate, endDate, bin].";

(* ::Subsubsection:: *)
(*Implementation*)

(* No input: Show all protocols for the last month *)
PlotSupportTimeline[ops:OptionsPattern[]]:=PlotSupportTimeline[All,Month,Day,ops];
PlotSupportTimeline[specifiedProtocols:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),ops:OptionsPattern[]]:=PlotSupportTimeline[specifiedProtocols,Month,Day,ops];

(* Time Span Shortcut (no bin): Year shortcut : Specify just the 'time ago' (e.g. Month to ultimately mean one month ago to now, auto calculate bin *)
PlotSupportTimeline[timeSpan_?TimeQ,ops:OptionsPattern[]]:=PlotSupportTimeline[All,timeSpan,ops];
PlotSupportTimeline[specifiedProtocols:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),timeSpan_?TimeQ,ops:OptionsPattern[]]:=PlotSupportTimeline[specifiedProtocols,timeSpan,timelineBin[timeSpan],ops];

(* Time Span Shortcut (bin): Specify the 'time ago' and bin size *)
PlotSupportTimeline[timeSpan_?TimeQ,bin_?TimeQ,ops:OptionsPattern[]]:=PlotSupportTimeline[All,Today-timeSpan,Today,bin,ops];
PlotSupportTimeline[specifiedProtocols:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),timeSpan_?TimeQ,bin_?TimeQ,ops:OptionsPattern[]]:=PlotSupportTimeline[specifiedProtocols,Today-timeSpan,Today,bin,ops];

(* Start time, end time, no bin *)
PlotSupportTimeline[startTime_?DateObjectQ,endTime_?DateObjectQ,ops:OptionsPattern[]]:=PlotSupportTimeline[All,startTime,endTime,ops];
PlotSupportTimeline[specifiedProtocols:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),startTime_?DateObjectQ,endTime_?DateObjectQ,ops:OptionsPattern[]]:=PlotSupportTimeline[specifiedProtocols,startTime,endTime,timelineBin[endTime-startTime],ops];

(* Full specification: Indicate protocols, start time, end time and bin *)
PlotSupportTimeline[startTime_?DateObjectQ,endTime_?DateObjectQ,bin_?TimeQ,ops:OptionsPattern[]]:=PlotSupportTimeline[All,startTime,endTime,bin,ops];
PlotSupportTimeline[specifiedProtocols:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),startTime_?DateObjectQ,endTime_?DateObjectQ,bin_?TimeQ,ops:OptionsPattern[]]:=Module[
	{safeOps,splitSampleManips,splitLiquidHandlers,specifiedTags,specifiedAnnotation,display,removeMonitoringTickets,excludeCanaryProtocols,searchCriteria,plotStype,protocols,expandedProtocols,
	tags,allTypes,dateTicks,dateBins,datePoints,allProtocols,taggedTroubleshooting, annotations,taggedBins,summarizedBins,
	relativeCoordinates,minPercent,maxPercent,annotationEpilogs, packetInfo,packetInfoTSCounted,dateBinnedInfo,groupedBins,
	troubleshootingTypePattern,averagedBins,typeCounts,protocolCountCoordinates,absoluteCountCoordinates,typedData,legend,
	calculatedOptions,optionsToPass,primaryDataColor,absolutePlot,relativePlot,successPercent,betaSuccessEpilog},

	safeOps=SafeOptions[PlotSupportTimeline,ToList[ops]];

	(* Extract the protocols options *)
	{splitSampleManips,splitLiquidHandlers,specifiedTags,specifiedAnnotation,display,removeMonitoringTickets,excludeCanaryProtocols,searchCriteria,plotStype}=Lookup[
		safeOps,
		{SampleManipulationSplit,LiquidHandlerSplit,Tags,Annotation,Display,RemoveMonitoringTickets,ExcludeCanaryProtocols,SearchCriteria,PlotStype}
	];

	tags=ToList[specifiedTags];

	protocols=If[MatchQ[specifiedProtocols,TypeP[]],
		ToList[specifiedProtocols],
		specifiedProtocols
	];

	expandedProtocols=Which[
		splitSampleManips,
			protocols/.(Object[Protocol, SampleManipulation] -> Sequence[MicroLiquidHandling, MacroLiquidHandling]),
		splitLiquidHandlers,
			Module[{liquidHandlerNames},
				liquidHandlerNames=Download[
					Search[
						Object[Instrument, LiquidHandler],
						Model == Alternatives @@ {
							Model[Instrument, LiquidHandler, "id:kEJ9mqaW7xZP"],
							Model[Instrument, LiquidHandler, "id:7X104vnRbRXd"]
						}
					],
					Name
				];

				liquidHandlerNames
			],
		True,
			protocols
	];

	(* Generate a list of all the types we're tracking *)
	allTypes=If[MatchQ[protocols,All],
		Types[Object[Protocol]],
		protocols
	];

	(* Expand out our annotations *)
	annotations=If[MatchQ[specifiedAnnotation,{_DateObject, _String}],
		{specifiedAnnotation},
		specifiedAnnotation
	];

	(* Generate bins of dates for calculating the rates *)
	dateTicks=DateRange[startTime,endTime,bin];
	dateBins = MapThread[{#1,#2}&, {Most[dateTicks],Rest[dateTicks]}];

	(* Calculate the center of the date bins *)
	datePoints=DateObject[Mean[{AbsoluteTime[First[#]],AbsoluteTime[Last[#]]}]]&/@dateBins;

	(* Find all the protocols completed inside the time range *)
	allProtocols=If[MatchQ[protocols,All],
		Search[
			{Object[Protocol],Object[Qualification],Object[Maintenance]},
			DateCompleted>=startTime&&DateCompleted<=endTime&&searchCriteria
		],
		Search[allTypes,DateCompleted>=startTime&&DateCompleted<=endTime&&searchCriteria]
	];

	(* Download all the TS tickets/reports and type for each protocol so we can process the counts by type for each entry *)
	packetInfo=Quiet[
		Download[
			allProtocols,
			{Packet[DateCompleted,Type,LiquidHandlingScale,LiquidHandler,ParentProtocol,CanaryBranch],Packet[ProtocolSpecificTickets[ErrorSource,SupportTicketSource]]}
		],
		{Download::FieldDoesntExist}
	];

	If[MatchQ[packetInfo,{}],
		Message[PlotSupportTimeline::NoProtocols];Return[$Failed]
	];

	(* Create a list of protocols completed within each date bin *)
	dateBinnedInfo=Map[
		Select[packetInfo,
			Function[packetPair,
				And[
					GreaterEqualDateQ[Lookup[First[packetPair],DateCompleted],First[#]],
					LessEqualDateQ[Lookup[First[packetPair],DateCompleted],Last[#]],
					(* If excluding canary protocols, remove them here if a protocol has CanaryBranch and it is not a subprotocol *)
					If[TrueQ[excludeCanaryProtocols],
						!And[
							Null[Lookup[First[packetPair],ParentProtocol]],
							!NullQ[Lookup[First[packetPair],CanaryBranch]]
						],
						True
					]
				]
			]
		]&,
		dateBins
	];

	If[MatchQ[dateBinnedInfo,{{}..}],
		Message[PlotSupportTimeline::NoProtocols];Return[$Failed]
	];

	(* For each date bin, reformat to {date,tickets} *)
	groupedBins=Map[
		Function[
			datePoint,
			Map[
				(* {{date, tickets}..} for each type *)
				Transpose[{Lookup[#[[All,1]],DateCompleted],#[[All,2]]}]&,
				(* Group by type - or if SM is included and it's requested split by LiquidHandlingScale *)
				GroupBy[datePoint,
					Function[packetPair,
						Which[
							MatchQ[expandedProtocols,All],
								All,
							splitLiquidHandlers,
								If[MatchQ[First[packetPair],PacketP[{Object[Protocol,SampleManipulation], Object[Protocol,RoboticSamplePreparation]}]],
									Download[Lookup[First[packetPair],LiquidHandler], Name],
									Lookup[First[packetPair],Type]
								],
							splitSampleManips,
								If[MatchQ[First[packetPair],PacketP[Object[Protocol,SampleManipulation]]],
									Lookup[First[packetPair],LiquidHandlingScale],
									Lookup[First[packetPair],Type]
								],
							True,
								Lookup[First[packetPair],Type]
						]
					]
				]
			]
		],
		dateBinnedInfo
	];

	(* By default we remove 'monitoring' tickets that typically aren't directly tied to the protocol in question *)
	troubleshootingTypePattern=If[removeMonitoringTickets,Except[Alternatives@@MonitoringTicketTypes],_];

	taggedBins=Map[
		Function[
			typesPerDate,
			(* If there are no tags we just want to count up the total number of tickets *)
			(* Exclude 'monitoring' TS types which will be converted to a new object type in the future *)
			If[MatchQ[tags,{}],
				{Map[Function[ticketPackets,Count[Lookup[ticketPackets,SupportTicketSource,{}],troubleshootingTypePattern]]/@#[[All,2]]&,typesPerDate]},
				Map[
					Function[tag,
						Map[
							Function[
								dateBin,
								Count[Lookup[#[[2]],ErrorSource,{}],tag]&/@dateBin
							],
							typesPerDate
						]
					],
					tags
				]
			]
		],
		groupedBins
	];

	(* Now for each bin get the averages and totals for each protocol rule *)
	summarizedBins=Map[
		Function[datePoint,
			Map[
				Function[
					tagDatePoint,
					{
						Round[100Percent*Mean[#],0.01Percent]&/@tagDatePoint,
						Total[#]&/@tagDatePoint
					}
				],
				datePoint
			]
		],
		taggedBins
	];

	(* Reformat the data from the form {<|type->Percent..|>,..} for each member of datePoints to instead be {{percentTime1,percentTime2},...} *)
	typedData=(#/.summarizedBins)&/@ToList[expandedProtocols];

	(* Show normalized data as our primary data *)
	relativeCoordinates=Map[
		Function[
			tagsPerType,
			Cases[Transpose[{datePoints,#[[All,1]]}],{_DateObject,UnitsP[]}]&/@Transpose[tagsPerType]
		],
		typedData
	];

	typeCounts=Map[
		Function[
			type,
			Length[Cases[#, {ObjectP[type/.All->Object], _}]]&/@dateBinnedInfo
		],
		protocols
	];

	protocolCountCoordinates=Transpose[{datePoints,#}]&/@typeCounts;

	(* Show normalized data as our secondary data *)
	absoluteCountCoordinates=Map[
		Function[
			tagsPerType,
			Cases[Transpose[{datePoints,#[[All,2]]}],{_DateObject,UnitsP[]}]&/@Transpose[tagsPerType]
		],
		typedData
	];

	(* Create our legend showing types/tags or type-tag matrix *)
	(* No legend if we're doing all protocols or if we only have one *)
	legend=Switch[{expandedProtocols,tags},
		{All|{_},{}}, {Null},
		{All,_}, tags,
		{{(TypeP[]|LiquidHandlingScaleP)..},{}},ToString/@expandedProtocols,
		_,Flatten[
			Map[
				Function[type,(ToString[type]<>": "<>#)&/@tags],
				ToList[expandedProtocols]
			],
			1
		]
	];

	(* -- Annotations -- *)

	(* Get the y-range info so we can draw our line as the full length *)
	(* Seems like there's a MM plotting bug where lines just don't work with % but is fine with the number sans percent *)
	minPercent=Unitless[Min[Flatten@relativeCoordinates[[All,All,All,2]]]]*0.9;
	maxPercent=Unitless[Max[Flatten@relativeCoordinates[[All,All,All,2]]]]*1.1;

	(* Make Lines with tooltips *)
	annotationEpilogs=Map[
		Tooltip[Line[{{First[#],minPercent},{First[#],maxPercent}}],Last[#]]&,
		annotations
	];

	(*Show our current cut-off for*)
	successPercent=33;
	betaSuccessEpilog={Line[{{startTime,successPercent},{endTime,successPercent}}]};

	(* Options to use if the user didn't ask for anything more specific *)
	calculatedOptions={
		ImageSize->Large,
		PlotRange->{{startTime,endTime},Full},
		Legend->legend,
		Zoomable->True,
		(* We want our epilogs to stand out a bit more. MM handles this in an insane way where you just put random style words in front of the graphics you want *)
		Epilog->Join[{Darker[Green],Thick},annotationEpilogs,{Darker[Red],Thick},betaSuccessEpilog]
	};

	(* Anything the user directly specified should take preference over our calculated values *)
	optionsToPass=ReplaceRule[calculatedOptions,ToList[ops]];

	(* - Return the final plot of the data - *)

	primaryDataColor=Darker[Blue];

	(* Make plot with percentages if requested *)
	relativePlot=If[MatchQ[display,Both|Relative],
		EmeraldDateListPlot[relativeCoordinates,
			PassOptions[
				PlotSupportTimeline,
				EmeraldDateListPlot,
				ReplaceRule[optionsToPass,{
					PlotStyle->If[MatchQ[plotStype,Automatic],
						primaryDataColor,
						plotStype
					],
					FrameLabel->{Automatic, Style["# Tickets / # Completed Protocols (%)",primaryDataColor]},
					Title->"Troubleshooting Rate"
				}]
			]
		],
		Null
	];

	(* Make plot with counts if requested *)
	absolutePlot=If[MatchQ[display,Both|Absolute],
		EmeraldDateListPlot[absoluteCountCoordinates,
			PassOptions[
				PlotSupportTimeline,
				EmeraldDateListPlot,
				ReplaceRule[optionsToPass,{
					PlotStyle->If[MatchQ[plotStype,Automatic],
						primaryDataColor,
						plotStype
					],
					SecondYCoordinates->protocolCountCoordinates,
					SecondYColors -> {Gray},
					FrameLabel->{
						Automatic,
						Style["# of Troubleshooting Tickets (per "<>ToString[bin]<>")",primaryDataColor],
						Automatic,
						"# Protocols Completed (per "<>ToString[bin]<>")"
					},
					Title->"Troubleshooting Counts"
				}]
			]
		],
		Null
	];

	Switch[display,
		Both, PlotTable[{{relativePlot,absolutePlot}},Title->StringRiffle[expandedProtocols,", "],Background -> None],
		Relative, relativePlot,
		Absolute, absolutePlot
	]
];

(* timelineBin - Decides what a reasonable interval should be based on the time span *)
timelineBin[timeSpan:TimeP]:=Switch[timeSpan,
	GreaterEqualP[5 Year],1 Year,
	GreaterEqualP[2 Year],1 Month,
	GreaterEqualP[6 Month],1 Week,
	RangeP[1 Day,6 Month],1 Day,
	_,timeSpan/10
];

(* ::Subsubsection::Closed:: *)
(*PlotSampleManipulationSupportTimeline*)
(* ::Subsubsection:: *)
(*DefineOptions*)
DefineOptions[PlotSampleManipulationSupportTimeline,
	Options:>{}
];
(* ::Subsubsection:: *)
(*Implementation*)
PlotSampleManipulationSupportTimeline[]:=PlotSampleManipulationSupportTimeline[Month,Day];
PlotSampleManipulationSupportTimeline[timeSpan_?TimeQ]:=PlotSampleManipulationSupportTimeline[timeSpan,timelineBin[timeSpan]];
PlotSampleManipulationSupportTimeline[timeSpan_?TimeQ,bin_?TimeQ]:=PlotSampleManipulationSupportTimeline[Today-timeSpan,Today,bin];
PlotSampleManipulationSupportTimeline[startTime_?DateObjectQ,endTime_?DateObjectQ]:=PlotSampleManipulationSupportTimeline[startTime,endTime,timelineBin[endTime-startTime]];
PlotSampleManipulationSupportTimeline[startTime_?DateObjectQ,endTime_?DateObjectQ,bin_?TimeQ]:=Module[
	{dateTicks,dateBins,datePoints,allProtocols,packetInfo,packetInfoTSCounted,dateBinedInfo,groupedBins,averagedBins,typedData},

	(* Generate bins of dates for calculating the rates *)
	dateTicks=DateRange[startTime,endTime,bin];
	dateBins = MapThread[{#1,#2}&, {Most[dateTicks],Rest[dateTicks]}];

	(* Calculate the center of the date bins *)
	datePoints=DateObject[Mean[{AbsoluteTime[First[#]],AbsoluteTime[Last[#]]}]]&/@dateBins;

	(* Find all the protocols completed inside the time range *)
	allProtocols=Search[Object[Protocol,SampleManipulation],DateCompleted>=startTime&&DateCompleted<=endTime];

	(* Download all the TS tickets/reports and type for each protocol so we can process the counts by type for each entry *)
	packetInfo=Download[allProtocols,{DateCompleted,LiquidHandlingScale,ProtocolSpecificTickets}];

	(* Process the info to tally up the troubleshooting reports and tickets for each protocol *)
	packetInfoTSCounted={#[[1]],#[[2]],Length[#[[3]]]}&/@packetInfo;

	(* For each type, bin the protocols by date completed into the date bins to generate a line *)
	dateBinedInfo=Select[packetInfoTSCounted,Function[packet,GreaterEqualDateQ[First[packet],First[#]]&&LessEqualDateQ[First[packet],Last[#]]]]&/@dateBins;

	(* For each date bin, Group the packets by type of protocol it is and strip the type out so its just {date,count} *)
	groupedBins=Function[datePoint,#[[All,{1,3}]]&/@GroupBy[datePoint,#[[2]]&]]/@dateBinedInfo;

	(* Now for each bin get the averages for each protocol rule *)
	averagedBins=Function[datePoint,Round[N[100Percent*Mean[#[[All,2]]]],0.01Percent]&/@datePoint]/@groupedBins;

	(* Reformat the data from the form {<|type\[Rule]Percent..|>,..} for each member of datePoints to instead be {Type->{Date,percent}..} *)
	typedData=Transpose[{datePoints,#/.averagedBins}]&/@{MicroLiquidHandling,MacroLiquidHandling};

	(* Return the final plot of the data *)
	Zoomable@DateListPlot[typedData,
		ImageSize->Large,
		Frame->{True,True,False,False},
		FrameLabel->{None,Style["Troubleshooting Rate (%)",Bold,16,Gray]},
		PlotRange->Automatic,
		PlotLegends->{MicroLiquidHandling,MacroLiquidHandling}
	]

];

DefineOptions[TroubleshootingTable,
	Options:>{
		{
			OptionName -> Resolved,
			Default -> All,
			Description -> "Indicates how tickets should be filtered by the Resolved field showing complete, incomplete or both states.",
			Pattern:> (All|BooleanP),
			Category -> "General",
			AllowNull -> False
		},
		{
			OptionName -> SystematicChanges,
			Default -> All,
			AllowNull -> False,
			Pattern:>(All|BooleanP),
			Description -> "Indicates how tickets are filtered by the SystematicChanges field showing tickets with fixes pushed, without fixes or both states.",
			Category -> "General"
		},
		{
			OptionName -> ErrorSource,
			Default -> All,
			AllowNull -> True,
			Pattern:>(Null|All|ListableP[_String]),
			Description -> "Indicates if only tickets with a certain ErrorSource value (or with ErrorSource not populated) are displayed.",
			Category -> "General"
		},
		{
			OptionName -> RemoveMonitoringTickets,
			Default -> True,
			AllowNull -> False,
			Pattern:>(BooleanP),
			Description -> "Indicates if tickets used to track daily operations, such as long task tickets are shown.",
			Category -> "General"
		},
		{
			OptionName -> Blocker,
			Default -> All,
			AllowNull -> False,
			Pattern:>(All|BooleanP),
			Description -> "Indicates how tickets are to be filtered by the Blocked field - showing tickets that are or were once blocked, tickets that were never blocked or both states.",
			Category -> "General"
		},
		{
			OptionName -> Detailed,
			Default -> False,
			AllowNull -> False,
			Pattern:>BooleanP,
			Description -> "Indicates the level of information to show on the table.",
			Category -> "General"
		},
		{
			OptionName -> MicroLiquidHandling,
			Default -> False,
			AllowNull -> False,
			Pattern:>BooleanP,
			Description -> "Indicates if tickets for only Micro Object[Protocol, SampleManipulation] protocols should be displayed.",
			Category -> "General"
		}
	},
	SharedOptions:>{}
];

TroubleshootingTable::NoTicketsFound="No tickets were found. If you expect tickets please consider expanding your search criteria.";

(* No time input: Show all protocols for the last week *)
TroubleshootingTable[ops:OptionsPattern[]]:=TroubleshootingTable[All,Now - Week,Now,ops];
TroubleshootingTable[protocolTypes:(All|{}|ListableP[Alternatives@@ProtocolTypes[]]|ListableP[ObjectP[ProtocolTypes[]]]),ops:OptionsPattern[]]:=TroubleshootingTable[protocolTypes, Now-1Week, Now, ops];

(* Time period input: Show protocols from Now-time to Now *)
TroubleshootingTable[time:TimeP,ops:OptionsPattern[]]:=TroubleshootingTable[All,Now - time,Now,ops];
TroubleshootingTable[protocolTypes:(All|{}|ListableP[Alternatives@@ProtocolTypes[]]|ListableP[ObjectP[ProtocolTypes[]]]),time:TimeP,ops:OptionsPattern[]]:=TroubleshootingTable[protocolTypes,Now - time,Now,ops];

(* Full specification: Indicate protocols, start time, end time and bin *)
TroubleshootingTable[startTime_?DateObjectQ,endTime_?DateObjectQ,ops:OptionsPattern[]]:=TroubleshootingTable[All,startTime,endTime,ops];

(* List of types or list of objects *)
TroubleshootingTable[protocolRequest:(All|{}|ListableP[Alternatives@@ProtocolTypes[]]|ListableP[ObjectP[ProtocolTypes[]]]),startTime_?DateObjectQ,endTime_?DateObjectQ,ops:OptionsPattern[]]:=Module[
	{safeOps,resolved,systematicChanges,errorSource,blocker,detailed,criteria,tickets,microOnly,removeMonitoringTickets},

	If[MatchQ[protocolRequest,{}],
		Return[Null]
	];

	(* Grab our options *)
	safeOps=SafeOptions[TroubleshootingTable,ToList[ops]];
	{resolved,systematicChanges,errorSource,blocker,detailed,microOnly,removeMonitoringTickets}=Lookup[
		safeOps,
		{Resolved,SystematicChanges,ErrorSource,Blocker,Detailed,MicroLiquidHandling,RemoveMonitoringTickets}
	];

	(* Search for our requests - Trues will get auto simplified out *)
	criteria=And[
		DateCreated>=startTime,
		DateCreated<=endTime,
		Switch[protocolRequest,
			All, True,
			(* Get only tickets whose SourceProtocol is one of the provided protocol objects *)
			ListableP[ObjectP[ProtocolTypes[]]],SourceProtocol==(Alternatives@@ToList[protocolRequest]),
			(* This is a bit wild - we want to allow searching on just Object[Protocol] and the like but this causes search to error and we can't actually match on TypeP *)
			(* Instead search for all the possible subtypes and remove the top level Object[Protocol], etc. *)
			_,SourceProtocol[Type]==(Alternatives@@DeleteCases[Types[ToList[protocolRequest]],(Object[Protocol]|Object[Qualification]|Object[Maintenance])])
		],
		If[MatchQ[resolved,All],
			True,
			Resolved==resolved
		],
		If[MatchQ[systematicChanges,All],
			True,
			SystematicChanges==systematicChanges
		],
		If[MatchQ[errorSource,All],
			True,
			ErrorSource==(Alternatives@@ToList[errorSource])
		],
		If[removeMonitoringTickets,
			SupportTicketSource!=(Alternatives@@MonitoringTicketTypes),
			True
		],
		Switch[blocker,
			True, (Blocked==True || Length[BlockedLog] > 1),
			False, (Blocked==(False|Null) && Length[BlockedLog] <= 1),
			All, True
		]
	];

	(* Search for tickets using our criteria specified in our options *)
	tickets=Search[Object[SupportTicket,Operations],Evaluate[criteria]];

	If[MatchQ[tickets,{}],
		Message[TroubleshootingTable::NoTicketsFound];Return[]
	];

	If[MatchQ[protocolRequest,ListableP[ObjectP[]]],
		troubleshootingTable[tickets,protocolRequest,safeOps],
		troubleshootingTable[tickets,All,safeOps]
	]
];

(* core overload - take a list of tickets and plot their info *)
TroubleshootingTable[inputTickets:ListableP[ObjectP[Object[SupportTicket,Operations]]],ops:OptionsPattern[]]:=troubleshootingTable[inputTickets,All,ops];

troubleshootingTable[inputTickets:ListableP[ObjectP[Object[SupportTicket,Operations]]],specificProtocols:All|ListableP[ObjectP[ProtocolTypes[]]],ops:OptionsPattern[]]:=Module[
	{safeOps,resolved,systematicChanges,errorSource,blocker,detailed,tickets,protocolsToDownload,creationDates,microOnly,
	ticketTuples,protocolDownload,rootProtocol,rootProtocolPackets,statusLogTimes,totalTimeTroubleshooting,filteredTickets,filteredTuples,
	requestedProtocols,ticketTimeTroubleshooting,sources,errorSources,headlines,assignee,financingTeam,tableContent,tableHeaders},

	(* Grab our options *)
	safeOps=SafeOptions[TroubleshootingTable,ToList[ops]];
	{resolved,systematicChanges,errorSource,blocker,detailed,microOnly}=Lookup[safeOps,{Resolved,SystematicChanges,ErrorSource,Blocker,Detailed,MicroLiquidHandling}];

	(* Search for tickets using our criteria specified in our options *)
	tickets=ToList@inputTickets;

	(* Prepare to download from specifically requested protocols *)
	protocolsToDownload=If[MatchQ[specificProtocols, ListableP[ObjectP[]]],
		ToList[specificProtocols],
		{}
	];

	If[MatchQ[tickets,{}],
		Message[TroubleshootingTable::NoTicketsFound];Return[Null]
	];

	(* Download info from the tickets *)
	{ticketTuples,protocolDownload}=Quiet[
		Download[{tickets,protocolsToDownload},
			{
				{
					DateCreated,
					AffectedProtocol[Object],
					Packet[AffectedProtocol[StatusLog,Status,DateCompleted]],
					SourceProtocol[Object],
					Headline,
					Assignee[Name],
					Notebook[Financers][[1]][Name],
					ErrorSource,
					SourceProtocol[LiquidHandlingScale],
					Object
				},
				{Object}
			}
		],
		{Download::Part,Download::FieldDoesntExist}
	];

	(* Get the cleaned set of protocols whose tickets should be shown *)
	requestedProtocols=Flatten[protocolDownload,1];

	(*if we are looking only at Micro SM, filter Macro out*)
	filteredTuples=Which[
		(* pull out info from our download and filter SM protocols *)
		microOnly, Select[ticketTuples,
			Or[
				MatchQ[#[[4]],Except[ObjectReferenceP[Object[Protocol,SampleManipulation]]]],
				And[
					MatchQ[#[[4]],ObjectReferenceP[Object[Protocol,SampleManipulation]]],
					MatchQ[#[[9]],MicroLiquidHandling]
				]
			]&
		],
		MatchQ[specificProtocols, ListableP[ObjectP[]]], Select[ticketTuples,MemberQ[ToList[requestedProtocols], #[[4]]]&],
		True, ticketTuples
	];

	(* we have to repeat this since we might have filtered out all the protocols we had *)
	If[MatchQ[filteredTuples,{}],
		Message[TroubleshootingTable::NoTicketsFound];Return[Null]
	];

	(* Pull out the info from our download *)
	creationDates=filteredTuples[[All,1]];
	rootProtocol=filteredTuples[[All,2]];
	rootProtocolPackets=filteredTuples[[All,3]];
	sources=filteredTuples[[All,4]];
	headlines=filteredTuples[[All,5]];
	assignee=filteredTuples[[All,6]];
	financingTeam=filteredTuples[[All,7]]/.$Failed->Null;
	errorSources=filteredTuples[[All,8]];
	filteredTickets=filteredTuples[[;;,10]];

	(* Lookup the overall status times in the protocol logs *)
	(* We may not have an affected protocol so guard against that *)
	statusLogTimes=Map[
		If[MatchQ[#,PacketP[]],
			Quiet[ParseLog[#,StatusLog],{Download::MissingField}],
			<||>
		]&,
		rootProtocolPackets
	];

	(* Time spent in troubleshooting in all ts tickets *)
	totalTimeTroubleshooting=Lookup[statusLogTimes,Troubleshooting, 0 Minute];

	(* Time spent in troubleshooting for this specific ts ticket *)
	ticketTimeTroubleshooting=Now-creationDates;

	(* Put our table together - either detailed or not *)
	{tableContent,tableHeaders}=If[detailed,
		{
			Transpose[{filteredTickets,creationDates,ticketTimeTroubleshooting,totalTimeTroubleshooting,rootProtocol,sources,errorSources,financingTeam,assignee,headlines}],
			{"Ticket","Date Created","Specific TS Time","Overall TS Time","Root Protocol","Source Protocol","Error Source","Financer","Assignee","Headline"}
		},
		{
			Transpose[{filteredTickets,creationDates,ticketTimeTroubleshooting,totalTimeTroubleshooting,sources,errorSources,headlines}],
			{"Ticket","Date Created","Specific TS Time","Overall TS Time","Source Protocol","Error Source","Headline"}
		}
	];

	(* Plot our table *)
	PlotTable[tableContent,TableHeadings->{None,tableHeaders}]
];

TroubleshootingErrorSources[]:=TroubleshootingErrorSources["Memoize"];

TroubleshootingErrorSources[string_String]:=TroubleshootingErrorSources[string] =Module[{allTickets},
	(* Handle memoization *)
	If[!MemberQ[ECL`$Memoization, TroubleshootingErrorSources],
		AppendTo[ECL`$Memoization, TroubleshootingErrorSources]
	];

	allTickets=Search[Object[SupportTicket],ErrorSource!=Null];
	DeleteDuplicates[Download[allTickets,ErrorSource]]
];


(* No time input: Show all protocols for the last week *)
BlockerTable[ops:OptionsPattern[]]:=BlockerTable[All,Now - Week,Now,ops];
BlockerTable[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),ops:OptionsPattern[]]:=BlockerTable[protocolTypes, Now-1Week, Now, ops];

(* Time period input: Show protocols from Now-time to Now *)
BlockerTable[time:TimeP,ops:OptionsPattern[]]:=BlockerTable[All,Now - time,Now,ops];
BlockerTable[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),time:TimeP,ops:OptionsPattern[]]:=BlockerTable[protocolTypes,Now - time,Now,ops];

BlockerTable[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),ops:OptionsPattern[]]:=BlockerTable[protocolTypes, Now-1Week, Now, ops];
BlockerTable[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),startTime_?DateObjectQ,endTime_?DateObjectQ,ops:OptionsPattern[]]:=TroubleshootingTable[protocolTypes,
	ReplaceRule[{Resolved->False, Blocker->True, Detailed->True},ToList[ops]]
];


DefineOptions[PlotLongTaskTimeline,
	Options:>{
		{LongTaskTime->1 Hour,Null|TimeP,"The minimum time at which a task is considered suspect for taking an unexpectedly high amount of time."},
		{Display->Relative,ListableP[Relative|Absolute|AbsoluteTime|RelativeTime]|All,"Indicates if the number of long tasks, the percentage of long tasks compared to total tasks, both count based metrics, or all metrics should be displayed."},
		{OutputFormat->Plot,Plot|List,"Indicates if the desired output is a Plot or a list of the raw data."}
	}
];


(* No input: Show all protocols for the last month *)
PlotLongTaskTimeline[]:=PlotLongTaskTimeline[All,Month,Day];

(* Time Span Shortcut (no bin): Specify just the 'time ago' (e.g. Month to ultimately mean one month ago to now, auto calculate bin *)
PlotLongTaskTimeline[timeSpan:TimeP,ops:OptionsPattern[]]:=PlotLongTaskTimeline[All,timeSpan,ops];
PlotLongTaskTimeline[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),timeSpan_?TimeQ,ops:OptionsPattern[]]:=PlotLongTaskTimeline[protocolTypes,timeSpan,timelineBin[timeSpan],ops];

(* Time Span Shortcut (bin): Specify the 'time ago' and bin size *)
PlotLongTaskTimeline[timeSpan:TimeP,bin:TimeP,ops:OptionsPattern[]]:=PlotLongTaskTimeline[All,Now-timeSpan,Now,bin,ops];
PlotLongTaskTimeline[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),timeSpan_?TimeQ,bin_?TimeQ,ops:OptionsPattern[]]:=PlotLongTaskTimeline[protocolTypes,Now-timeSpan,Now,bin,ops];

(* Start time, end time, no bin *)
PlotLongTaskTimeline[startTime_DateObject,endTime_?DateObjectQ,ops:OptionsPattern[]]:=PlotLongTaskTimeline[All,startTime,endTime,ops];
PlotLongTaskTimeline[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),startTime_DateObject,endTime_DateObject,ops:OptionsPattern[]]=PlotLongTaskTimeline[protocolTypes,startTime,endTime,timelineBin[endTime-startTime],ops];

(* Full specification: Indicate protocols, start time, end time and bin *)
PlotLongTaskTimeline[startTime_DateObject,endTime_?DateObjectQ,bin:TimeP,ops:OptionsPattern[]]:=PlotLongTaskTimeline[All,startTime,endTime,bin,ops];
PlotLongTaskTimeline[protocolTypes:(All|ListableP[TypeP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]]),startTime_DateObject,endTime_DateObject,bin:TimeP,ops:OptionsPattern[]]:=Module[
	{safeOps,cutoffTime,display,rawdisplay,outputFormat, dates,absoluteDates,absoluteDateTuples,searchTypes,protocols,completedTaskLists,allCompletedTasks,nearestTrackedDate,completedTasksByDate,longTasksByDateRules,
	longTasksByDate,longTaskCounts,longTaskPercentages,absolutePlot,relativePlot, longTaskNetTimePercentages, longTaskNetTimes, plotsToDisplay, plots, lists, absoluteTimePlot, relativeTimePlot},

	(* ------------------------------- *)
	(* -- Setup Search and Download -- *)
	(* ------------------------------- *)

	(* Grab our safe ops *)
	safeOps = SafeOptions[PlotLongTaskTimeline,ToList[ops]];

	(* Lookup long task time definition (considered long if it's above this time) *)
	{cutoffTime,rawdisplay, outputFormat} = Lookup[safeOps,{LongTaskTime,Display, OutputFormat}];

	(* convert the display option to a list format *)
	display = ToList[rawdisplay/.All -> {Relative,Absolute,AbsoluteTime,RelativeTime}];

	(* Get the list of dates for which we want to show data *)
	(* Convert to absolute time for speed *)
	dates=DateRange[startTime,endTime,bin];
	absoluteDates=AbsoluteTime/@dates;

	(* Make date pairs {{startDate1,endDate1}, {startDate2, endDate2}..}*)
	absoluteDateTuples=Transpose[{Most[absoluteDates],Rest[absoluteDates]}];

	(* Based on input search everything or just certain types*)
	searchTypes=If[MatchQ[protocolTypes,All],
		{Object[Protocol],Object[Maintenance],Object[Qualification]},
		protocolTypes
	];

	(* Get protocols processing in our range *)
	(* Assume if something started 1 month a before start it could be processing now *)
	protocols = Search[
		searchTypes,
		And[
			ParentProtocol==Null,
			DateStarted>(startTime-1 Month),
			(DateCompleted<endTime || DateCompleted == Null),
			Length[CompletedTasks]>1
		]
	];

	(* Get all the completed tasks for these protocols *)
	(* In the form: {{task start, task end, operator, taskID, html}} *)
	completedTaskLists = Download[protocols,CompletedTasks];

	(* --------------------------------------- *)
	(* -- Group and Reformat CompletedTasks -- *)
	(* --------------------------------------- *)

	(* Merge all the completed tasks to make one mega list *)
	allCompletedTasks = Apply[Join, completedTaskLists];

	(* Make a little DateRound style function that will give us the starting date in each range we're interested in *)
	nearestTrackedDate[date_DateObject]:=SelectFirst[absoluteDateTuples,MatchQ[AbsoluteTime[date],RangeP@@#]&,{Null,Null}][[1]];

	(* For each completed task ask which pair of dates its start falls in and group accordingly *)
	completedTasksByDate = GroupBy[allCompletedTasks,nearestTrackedDate[First[#]]&];

	(* Select out the long tasks and return in the form {{{task time, task ID}..}..} - for each date a list of task time/task id tuples *)
	longTasksByDateRules = KeyValueMap[
		Function[{absoluteDate,tasksForDate},
			Module[{susTaskLines,longTaskTuples},
				susTaskLines = Select[tasksForDate,(#[[2]]-#[[1]]>cutoffTime)&];

				(* Return {time to complete, tasks completed, taskID} for each  *)
				longTaskTuples = {#[[2]]-#[[1]],Length[tasksForDate],#[[4]]}&/@susTaskLines;

				(* Return as a rule so we can look-up tuples for each date *)
				absoluteDate->longTaskTuples
			]
		],
		completedTasksByDate
	];

	(* Our grouping above may not find any tasks on a given date (if lab was closed or something and we did no tasks) *)
	(* For each date look-up the long tasks *)
	longTasksByDate = Lookup[longTasksByDateRules,absoluteDates,{}];

	(* ------------------- *)
	(* -- Generate data -- *)
	(* ------------------- *)

	(* Count up the number of long tasks on each day *)
	longTaskCounts = Map[
		Length[#[[All,1]]]&,
		longTasksByDate
	];

	(* Get the percentage of tasks which were long *)
	longTaskPercentages = Map[
		(* Each long task comes with same number of completed per day so just grab the first count *)
		If[MatchQ[#,{}],
			0,
			100*(Length[#[[All,1]]]/#[[1,2]])
		]&,
		longTasksByDate
	];

	(* Get the total amount of time spend in long tasks per day, absolute and as a percentage of total time *)
	longTaskNetTimes = Map[
		Total[#[[All,1]]]/.(0->0 Hour)&,
		longTasksByDate
	];

	(* dont do the calculation if there are now tasks in that range for some reason *)
	longTaskNetTimePercentages = MapThread[
		If[Or[MatchQ[#1, {}],MatchQ[#2, {}]],
			0,
			100*Total[#1[[All,1]]]/Total[#2[[All,2]]-#2[[All,1]]]
		]&,
		{longTasksByDate, Lookup[completedTasksByDate,absoluteDates,{}]}
	];

	(* ------------------- *)
	(* -- Format output -- *)
	(* ------------------- *)

	relativePlot=If[And[MemberQ[display,Relative], MatchQ[outputFormat, Plot]],
		EmeraldDateListPlot[
			Most[Transpose[{dates,longTaskPercentages}]],
			FrameLabel->{Automatic,"Long Tasks (> "<>ToString[cutoffTime]<>") per Completed Tasks"}
		],
		Null
	];

	absolutePlot=If[And[MemberQ[display,Absolute],MatchQ[outputFormat, Plot]],
		EmeraldDateListPlot[
			Most[Transpose[{dates,longTaskCounts}]],
			FrameLabel->{Automatic,"Number of Long Tasks (> "<>ToString[cutoffTime]<>") per "<>ToString[bin]}
		],
		Null
	];

	relativeTimePlot = If[And[MemberQ[display,RelativeTime],MatchQ[outputFormat, Plot]],
		EmeraldDateListPlot[
			Most[Transpose[{dates,longTaskNetTimePercentages}]],
			FrameLabel->{Automatic,"Percentage of time spent in Long Tasks (> "<>ToString[cutoffTime]<>")"}
		],
		Null
	];

	absoluteTimePlot = If[And[MemberQ[display,AbsoluteTime],MatchQ[outputFormat, Plot]],
		EmeraldDateListPlot[
			Most[Transpose[{dates,longTaskNetTimes}]],
			FrameLabel->{Automatic,"Time spent in Long Tasks (> "<>ToString[cutoffTime]<>") per "<>ToString[bin]}
		],
		Null
	];

	(* -- final output formatting -- *)

	(* collect the plots to display, remove Null elements *)
	plotsToDisplay = DeleteCases[{relativePlot,absolutePlot, relativeTimePlot, absoluteTimePlot}, Null];

	plots = If[MatchQ[Length[plotsToDisplay], 1],
		First[plotsToDisplay],
		Grid[{plotsToDisplay}]
	];

	(* return the non null elements *)
	lists = Select[
		{
			Relative -> Most[Transpose[{dates,longTaskPercentages}]],
			Absolute -> Most[Transpose[{dates,longTaskCounts}]],
			RelativeTime -> Most[Transpose[{dates,longTaskNetTimePercentages}]],
			AbsoluteTime -> Most[Transpose[{dates,longTaskNetTimes}]]
		},
		MatchQ[Keys[#],Alternatives@@display]&
	];

	If[MatchQ[outputFormat, Plot],
		plots,
		lists
	]
];