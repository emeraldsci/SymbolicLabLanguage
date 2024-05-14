(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProtocolTimeline*)

(* Constant for the acceptable amount of time a protocol can remain in OperatorReady or waiting for a check in *)
$OperatorGracePeriod = 3 Hour;

PlotProtocolTimelineDisplayP=(All|ReadyCheck|OperatorInterrupts|Tasks|Tickets|InstrumentCheckIns|Subprotocols);

DefineOptions[PlotProtocolTimeline,
	Options:>{
		{
			OptionName->DeveloperDisplay,
			Default->Null,
			Description->"Indicates what additional information, such as the task completion dates and resource availability, should be displayed on the plot. Subprotocols will plot the intervals of the subprotocol start/end dates, tasks will do the same but with the individual tasks that get completed in the protocol.",
			AllowNull->True,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>PlotProtocolTimelineDisplayP]],
				Widget[Type->Enumeration,Pattern:>PlotProtocolTimelineDisplayP]
			],
			Category->"Hidden"
		},
		OutputOption
	}
];

Error::NoStatusLog="The provided protocol doesn't have a status log. Please check that you've provided a protocol with DateCreated and StatusLog populated.";

PlotProtocolTimeline[
	obj:ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance]}],
	ops:OptionsPattern[PlotProtocolTimeline]
]:=Module[
	{safeOps,interruptMarkersQ,readyCheck, statusLog,dateEnqueued,author,priority,scriptProtocols,ticketDisplay,taskDisplay,subprotocolDisplay,instrumentCheckIns,
		readyLog,initialStartDates,initialEndDates,
		initialStatuses,initialResponsibleParties,currentReadyLog,readyLogParents,pickUpTimeLog,
		rootProcedureEvents,subProcedureEvents,parentTickets,currentTickets,
		startDates,endDates,statusesForColor,statuses,responsibleParties,unavailableObjects, shortOperatorReady,
		shortTroubleshooting,errorEvents,errorDates,errorMessages,interruptEvents,interruptDates,
		emerald,lightEmerald,yellow,blue,statusPlotStyles,plotStyles,labelingFunction,
		outputSpecification,developerDisplay,plot,finalResolvedOps, checkInOverTimes, pickUpOverTimes, checkInSpacings, pickUpSpacings,
		taskStartPackets,parentProtocolPacket,subprotocolPackets,allEventPackets,allTicketPackets,ticketPacketsInRange,ticketStartDates,ticketsInRange,timePoints,
		taskIntervals,subprotocolIntervals,ticketButtons
	},

	safeOps=SafeOptions[TimelinePlot,{Filling->True,ImageSize->1800}];

	(* Pull out the options the user specified *)
	outputSpecification=OptionValue[Output];
	developerDisplay=ToList[OptionValue[DeveloperDisplay]];
	interruptMarkersQ=MemberQ[developerDisplay,All|OperatorInterrupts];
	readyCheck=MemberQ[developerDisplay,All|ReadyCheck];
	ticketDisplay=MemberQ[developerDisplay,All|Tickets];
	taskDisplay=MemberQ[developerDisplay,All|Tasks];
	subprotocolDisplay=MemberQ[developerDisplay,All|Subprotocols];
	instrumentCheckIns=MemberQ[developerDisplay,All|InstrumentCheckIns];


	(*Download information from the protocol*)
	{
		statusLog,dateEnqueued,author,priority,scriptProtocols,currentReadyLog,readyLogParents,pickUpTimeLog,
		rootProcedureEvents,subProcedureEvents,parentTickets,currentTickets,
		parentProtocolPacket, subprotocolPackets
	}=Download[obj,
		{
			StatusLog,DateEnqueued,Author,Priority,Script[Protocols],ReadyCheckLog,Repeated[ParentProtocol][ReadyCheckLog],PickUpTimeLog,
			ProcedureLog[Packet[EventType,DateCreated,CreatedBy,TaskType,TaskID]],Packet[Subprotocols..[ProcedureLog[EventType,DateCreated,CreatedBy,TaskType,TaskID]]],
			Packet[Repeated[ParentProtocol][OperationsSupportTickets[DateCreated]]],Packet[OperationsSupportTickets[DateCreated]],
			Packet[DateCreated,DateCompleted], Packet[Subprotocols..[DateCreated,DateCompleted]]
		}
	]/.x:LinkP[IncludeTemporalLinks->True]:>Download[x,Object];

	(* Only root protocol has ReadyLog. We could be root, in which case log is in currentReadyLog, otherwise it's the last entry in our parents (i.e. the root) *)
	readyLog = FirstCase[Reverse[Join[{currentReadyLog},readyLogParents]],{__},{}];

	If[MatchQ[statusLog,{}],
		Message[Error::NoStatusLog];Return[$Failed]
	];

	(*===Parse information===*)

	(*Parse StatusLog*)
	initialStartDates=CurrentDate[#,"Minute"]&/@statusLog[[All,1]];
	initialEndDates=CurrentDate[#,"Minute"]&/@Append[Drop[RotateLeft[initialStartDates],-1],
		If[MatchQ[Last[statusLog[[All,2]]],Completed|Aborted|Canceled],
			Last[initialStartDates],
			Now
		]
	];
	initialStatuses=statusLog[[All,2]]/.{
		(*If given a priority protocol or a non-first protocol within a script, keep the OperatorStart status, otherwise replace the status with QueueTime*)
		If[TrueQ[priority]||If[!NullQ[scriptProtocols],!SameObjectQ[obj,scriptProtocols[[1]]],False],
			OperatorStart->OperatorStart,
			OperatorStart->QueueTime
		]
	};
	initialResponsibleParties=Download[statusLog[[All,3]],Object];

	{startDates,endDates,statuses,responsibleParties,unavailableObjects} = If[readyCheck&&MatchQ[readyLog,{__}],
		addReadyCheckStatuses[readyLog,initialStartDates,initialEndDates,initialStatuses,initialResponsibleParties],
		{initialStartDates,initialEndDates,initialStatuses,initialResponsibleParties, ConstantArray[Null, Length[initialStartDates]]}
	];

	(*Find the error events about unavailable resources and download their dates and error messages*)
	errorEvents=Search[Object[Program,ProcedureEvent],Protocol==obj&&EventType==Error&&StringContainsQ[ErrorMessage,"available",IgnoreCase->True]];
	{errorDates,errorMessages}=If[!MatchQ[errorEvents,{}],
		Transpose[Download[errorEvents,{DateCreated,ErrorMessage}]],
		{{},{}}
	];

	(*Find the dates of operator interrupts*)
	interruptEvents=If[TrueQ[interruptMarkersQ],
		Module[
			{priorityProtocolLogPackets,processingStatusLog,processingUsers,processingStartDates,processingEndDates,processingIntervals},

			(*Download the PriorityProtocolLog of unique users working on the protocol*)
			priorityProtocolLogPackets=Download[DeleteDuplicates[Cases[responsibleParties,ObjectP[Object[User,Emerald]]]],Packet[PriorityProtocolLog]];

			(*Get the processing statuses with user RPs*)
			processingStatusLog=Select[statusLog,MatchQ[#[[2]],(OperatorProcessing|InstrumentProcessing)]&&MatchQ[#[[3]],ObjectP[Object[User,Emerald]]]&];
			(*Get the users in the processing statuses*)
			processingUsers=processingStatusLog[[All,3]];
			(*Get the start and end dates of the processing statuses and pair them up*)
			processingStartDates=processingStatusLog[[All,1]];
			processingEndDates=If[MatchQ[processingStartDates,{}],
				{},
				Append[Drop[RotateLeft[processingStartDates],-1],
					statusLog[[All,1]][[First@@Position[statusLog[[All,1]],Last[processingStartDates]]+1]]
				]
			];
			processingIntervals=Transpose[{processingStartDates,processingEndDates}];
			(*Find the Fulfilled interrupt events that happened during the processing status intervals*)
			MapThread[
				Function[{processingUser,processingInterval},
					Module[{priorityProtocolLogPacket,priorityProtocolLog},
						priorityProtocolLogPacket=First@Cases[priorityProtocolLogPackets,KeyValuePattern[Object->processingUser]];
						priorityProtocolLog=Lookup[priorityProtocolLogPacket,PriorityProtocolLog];
						Select[priorityProtocolLog,MatchQ[#[[2]],Fulfilled]&&processingInterval[[1]]<#[[1]]&&processingInterval[[2]]>#[[1]]&]
					]
				],
				{processingUsers,processingIntervals}
			]
		],
		{}
	];
	interruptDates=Cases[Flatten[interruptEvents],_?DateObjectQ];

	(* -- Format tasks -- *)
	(* Get dates of all task start events in parent or sub *)
	allEventPackets=Flatten[Join[rootProcedureEvents,subProcedureEvents]];
	taskStartPackets=If[taskDisplay,
		SortBy[Select[allEventPackets,MatchQ[Lookup[#,EventType],TaskStart]&], (Lookup[#, DateCreated]&)],
		{}
	];

	(* -- Format tickets -- *)
	(* Get dates of all ticket events in parent or sub *)
	allTicketPackets=Flatten[Join[parentTickets,currentTickets]];
	ticketPacketsInRange=If[ticketDisplay,
		Select[allTicketPackets,Min[initialStartDates]<=Lookup[#,DateCreated]<=Max[initialEndDates]&],
		{}
	];
	ticketStartDates=Lookup[ticketPacketsInRange,DateCreated,{}];
	ticketsInRange=Lookup[ticketPacketsInRange,Object,{}];

	(* Parse Check-In and Pickup Delays*)
	{
		checkInOverTimes,
		checkInSpacings,
		pickUpOverTimes,
		pickUpSpacings
	} = If[TrueQ[instrumentCheckIns],
		Module[{pickUpStarts, pickUpEstimates, pickUpStartAndEstimatedTimes, initialInstrumentProcessingStartAndEndDates, initialBinnedPickUpDates,
		binnedPickUpDates, instrumentProcessingStartAndEndDates, checkInTimings, endPickUpDates, overTimeCheckIns,timesBetweenPickUps,
		initialOverTimeDurations, overTimeDurations, finalInstrumentProcessingStartAndEndDates, finalOverTimeDurations,
		intermediateOverTimeDurations, spacingIndices, initialInstrumentSpacingIndices, instrumentSpacingIndices, intermediateDurationCounts, intermediateDurationCountUnits,
		intermediateSpacingStarts, intermediateSpacings, finalDurationCounts, finalDurationCountUnits, finalSpacingStarts, finalSpacings, dateBinningFunction,dateComparison,findL},

			(* Gather the pick up time starts, the estimated next pick up times, and start and end dates of the InstrumentProcessing statuses *)
			pickUpStarts = CurrentDate[#,"Minute"]&/@pickUpTimeLog[[All,1]];
			pickUpEstimates = CurrentDate[#,"Minute"]&/@pickUpTimeLog[[All,2]];
			pickUpStartAndEstimatedTimes = Transpose[{pickUpStarts, pickUpEstimates}];
			initialInstrumentProcessingStartAndEndDates = PickList[Transpose[{startDates, endDates}], statuses, InstrumentProcessing];

			(* Helper function to determine during which InstrumentProcessing time range that the pick up time start and estimate fall into*)
			dateBinningFunction[processingDates_List, pickUpDates_List] := Select[
				pickUpDates,
				GreaterEqualDateQ[#[[1]], processingDates[[1]]]&&LessEqualDateQ[#[[1]], processingDates[[2]]]&
			];

			(* Helper function to compare a pair of two time points and select the pair if the latter is greater than the first*)
			dateComparison[times_List] := Select[
				times,
				#[[2]]-#[[1]] > 0 Minute&
			];

			(* Helper function to find the largest value in a list less than the specified val *)
			(* Max of an empty list returns -Infinity, but since we are dealing with the non-negative range, we replace any -Infinity with 0 *)
			findL[x_, val_] := Max[Select[x, # < val &]] /. {-Infinity -> 0};

			(* Separate the pick up time start and estimate pairs based on which instrument processing range they fall into*)
			(* This list can contain empty lists, which will mess up our date comparisons later in the function. *)
			initialBinnedPickUpDates = dateBinningFunction[#, pickUpStartAndEstimatedTimes]&/@initialInstrumentProcessingStartAndEndDates;

			(* Remove empty lists by finding cases of lists of date pairs *)
			binnedPickUpDates = Cases[initialBinnedPickUpDates, {{_?DateObjectQ, _?DateObjectQ} ..}];

			(* Get the instrument processing start and end dates that correspond to our non-empty bins *)
			instrumentProcessingStartAndEndDates = PickList[initialInstrumentProcessingStartAndEndDates, initialBinnedPickUpDates, Except[{}]];

			(* Calculate the amount of time the subsequent pick up start occurred after the estimated pick up time *)
			(* Positive timings means we picked up the protocol after the estimated time. Negative timings mean we were early in picking up the protocol *)
			checkInTimings = MapThread[Append[Rest[#1[[All, 1]]], Last[#2]] - #1[[All, 2]]&,{binnedPickUpDates, instrumentProcessingStartAndEndDates}];

			(* Gather the estimated pick up times from our binned dates *)
			endPickUpDates = Map[Last, binnedPickUpDates, {2}];

			(* Calculate how long we went over the estimated time by adding the check in timings from the estimated pick up dates *)
			overTimeCheckIns = MapThread[#1 + #2&, {endPickUpDates, checkInTimings}];

			(* Create the durations of time between our estimated pick up dates (plus grace period) and our actual pick up times *)
			timesBetweenPickUps = MapThread[Transpose[{#1, #2}]&, {endPickUpDates, overTimeCheckIns}];

			(* Parse out the durations that actually had a positive time difference, since we will be plotting these on our timeline *)
			initialOverTimeDurations = dateComparison[#]& /@ timesBetweenPickUps;

			(* Remove any empty lists from our list of durations *)
			overTimeDurations = Cases[initialOverTimeDurations, {{_?DateObjectQ, _?DateObjectQ} ..}];

			(* Make the final list of instrument processing start and end dates since we only care about plotting over time durations in instrument processing sections that actually contain them *)
			finalInstrumentProcessingStartAndEndDates = PickList[instrumentProcessingStartAndEndDates, initialOverTimeDurations, Except[{}]];

			(* If we have a check in that is delayed and was 10 minutes within the instrument processing stage ending, we consider that a check in that ends the instrument processing stage, or a "pick up" *)
			finalOverTimeDurations = MapThread[
				If[Last[#2] - Last[Last[#1]] > 10 Minute,
					{},
					{Last[#1]}]&,
				{overTimeDurations, finalInstrumentProcessingStartAndEndDates}
			];

			(* Using our list of pick up durations, we can determine if the rest of overtime durations we find during an instrument processing section are just check ins *)
			intermediateOverTimeDurations = MapThread[
				If[MatchQ[#2, {}],
					#1,
					Most[#1]]&,
				{overTimeDurations, finalOverTimeDurations}
			];

			(* Create a list of the spacings that are used to display each status on the time line plot *)
			spacingIndices = Table[x, {x, 1, Length[statuses]}];

			(* We get the spacings of the instrument processing stage *)
			initialInstrumentSpacingIndices = PickList[spacingIndices, statuses, InstrumentProcessing];

			(* We remove spacings where no pick up dates were binned and then remove spacings where no check ins went overtime *)
			instrumentSpacingIndices = PickList[
				PickList[initialInstrumentSpacingIndices, initialBinnedPickUpDates, Except[{}]],
				initialOverTimeDurations,
				Except[{}]
			];

			(* We would like to know how many check ins went over time per instrument processing section so that we can pad our spacings *)
			intermediateDurationCounts = Length/@intermediateOverTimeDurations;

			(* We unitize the intermediate duration counts and multiply it with the spacing indices to get instrument spacing indices that contain check in overtimes *)
			(* For example, if we have 3 instrument processing sections at indices {5, 10, and 15} with 1, 0, and 2 intermediate overtime durations respectively, intermediateDurationCounts
			 look like {1, 0, 2}. We unitize {1, 0, 2} to get {1, 0, 1}, which we multiply with instrumentSpacingIndices to get {5, 0, and 15}, which will be the spacings we care
			 about when displaying intermediate overtime durations *)
			intermediateDurationCountUnits = instrumentSpacingIndices*Unitize[intermediateDurationCounts];

			(* To find when we start our new spacing, we subtract the second largest value from each specific element.
			For example, if we have intermediateDurationCountUnits as {5, 0, 0, 13, 14, 0, 30}, intermediateSpacingStarts will be {5, 0, 0, 8, 1, 0, 16}*)
			intermediateSpacingStarts = intermediateDurationCountUnits - (findL[intermediateDurationCountUnits, #]&/@intermediateDurationCountUnits);

			(* Create our spacings for our check in over time durations per each instrument processing section. We pad with 0's since we want durations that occur
			during the same instrument processing section to stay on the same horizontal line *)
			intermediateSpacings = MapThread[
				If[#2==0,
					{},
					PadRight[{#1}, #2]]&,
				{intermediateSpacingStarts, intermediateDurationCounts}];

			(* Find how many pick ups went over time per instrument processing *)
			finalDurationCounts = Length/@finalOverTimeDurations;

			(* Get the indices of instrument processing sections that have pick up overtimes *)
			finalDurationCountUnits = instrumentSpacingIndices*Unitize[finalDurationCounts];

			(* Get the start of our spacings for our pick up overtimes *)
			finalSpacingStarts = finalDurationCountUnits - (findL[finalDurationCountUnits, #]&/@finalDurationCountUnits);

			(* Create our spacings for pick up overtime durations *)
			finalSpacings = MapThread[
				If[#2==0,
					{},
					PadRight[{#1}, #2]]&,
				{finalSpacingStarts, finalDurationCounts}];

				{intermediateOverTimeDurations, intermediateSpacings, finalOverTimeDurations, finalSpacings}
		],
		{{}, {}, {}, {}}
];

	(* We also need to distinguish sections when
		-OperatorReady stages are longer than 3 hours
		-TS stages are longer than 1 hour
	*)
	(*
		For each OpStart and OpReady status, we will look at the duration and convert it to short or long so
		we can color them differently
		We will do the same for each TS status
	*)

	statusesForColor = MapThread[
		Function[{singleStatus, singleStartDate, singleEndDate},
			Which[
				MatchQ[singleStatus, OperatorStart|OperatorReady] && GreaterQ[singleEndDate-singleStartDate, $OperatorGracePeriod], OperatorReady,
				MatchQ[singleStatus, OperatorStart|OperatorReady] && LessEqualQ[singleEndDate-singleStartDate, $OperatorGracePeriod], shortOperatorReady,
				MatchQ[singleStatus, Troubleshooting] && LessEqualQ[singleEndDate-singleStartDate, 1 Hour], shortTroubleshooting,
				True, singleStatus
			]
		],
		{
			statuses,
			startDates,
			endDates
		}
	];

	(*===Color===*)

	(*For status intervals, color based on the status*)
	emerald = RGBColor[{34,184,147}/256];
	lightEmerald = Lighter[Lighter[emerald]];
	yellow = RGBColor[{252,188,69}/256];
	blue = RGBColor[{23,120,238}/256];

	(*We apply the a specific color to each type of status. We append a final White to color the filler interval so we can keep correct spacing on the timeline*)
	statusPlotStyles=Append[Switch[#,
		OperatorProcessing,emerald,
		InstrumentProcessing,blue,
		shortOperatorReady,lightEmerald,
		OperatorReady,yellow,
		ResourceLimitation,Orange,
		shortTroubleshooting,lightEmerald,
		Troubleshooting,Red,
		Completed,emerald,
		_,Gray
	]&/@statusesForColor, White];

	(*If we are showing delays on the timeline, we need to adjust the plot styles to include the colors of the delays in terms of their severity*)
	plotStyles = If[!MatchQ[developerDisplay,{Null}],
		Module[{overTimes, overTimePeriods, scaledOverTimePeriods, fillerColors, coloredPeriods},

			(* Get all the overtimes in order of how we are going to display them *)
			overTimes = Join[Flatten[checkInOverTimes,1], Flatten[pickUpOverTimes, 1]];

			(* Calculate the length of time for these durations *)
			overTimePeriods = #[[2]]-#[[1]]&/@overTimes;

			(* Set the color for late check-ins and standard check-ins *)
			coloredPeriods = If[#>=$OperatorGracePeriod,
				Darker[Darker[blue]],
				Lighter[blue]
			]&/@overTimePeriods;

			(* PlotStyle loops over the given colors, so to ensure that our colors are applied to our overtime durations, include colors for
			any non status events *)
			fillerColors = Table[Gray, Total[Length/@{errorEvents, interruptEvents}]];

			(* Return the origin status colors, filler colors, and two instances of the colored periods since we display overtimes twice *)
			Join[statusPlotStyles, fillerColors, coloredPeriods]
		],
		statusPlotStyles
	];

	(*===Label===*)

	(*Label the start and end of each status with a tooltip*)
	labelingFunction[{start_,end_},pos_,label_]:=Row[
		DateString[#,{"MonthNameShort"," ","Day"," ","Hour12Short",":","Minute"," ","AMPM"}]&/@{start,end},
		" ~ "
	];

	(*Label each checkpoint/error event with a tooltip*)
	labelingFunction[time_,pos_,label_]:=Module[
		{statusLength,index},

		(* Statuses have their own labeling function overload *)
		(* We need to label points starting after all the status intervals and one filler interval  *)
		statusLength=Length[statuses]+1;

		Which[
			(*error events*)
			First[pos]<=Length[errorEvents]+statusLength,
				(index=First[pos]-statusLength;errorMessages[[index]]),

			(*interrupt events*)
			First[pos]<=Length[Join[errorEvents,interruptEvents]]+statusLength,
				"Operator Interrupt"
		]
	];

	(*===Plot===*)

	timePoints=Join[
		(*status intervals*)
		MapThread[
			{
				Labeled[
					Labeled[
						Interval[{#1,#2}],
						Which[
							MatchQ[#3,ResourceLimitation],
								Tooltip[Style["ResourceLimitation", Underlined],#5],
							MatchQ[#4,ObjectP[Object[User]]],
								ToString[#3] <> " ("<>#4[FirstName]<>")",
							True,ToString[#3]
						],
						Before
					],
					SafeRound[UnitScale[#2-#1],0.1]/.{0 Minute->""},
					Below
				]
			}&,
			{startDates,endDates,statuses,responsibleParties,unavailableObjects}
		],
		(*A filler interval is inserted here so that the spacing can be reset for error events, interrupt dates, late check-ins, etc.*)
		{Interval[{endDates[[-1]],endDates[[-1]]}]},

		(*error event dates*)
		If[!MatchQ[errorEvents,{}],
			Partition[errorDates,1],
			{}
		],

		(*interrupt dates*)
		If[!MatchQ[interruptEvents,{}],
			Partition[interruptDates,1],
			{}
		],

		(*labeled late operator check-in durations on the axis*)
		If[TrueQ[instrumentCheckIns],
			{Labeled[#, "Check In", Above]}&/@(Interval[#]&/@Flatten[checkInOverTimes,1]),
			{}
		],
		(*labeled late operator pick up durations on the axis*)
		If[TrueQ[instrumentCheckIns],
			{Labeled[#, "Pick Up", Above]}&/@(Interval[#]&/@Flatten[pickUpOverTimes,1]),
			{}
		],
		(*late operator check-in intervals*)
		If[TrueQ[instrumentCheckIns],
			Interval[#]&/@Flatten[checkInOverTimes,1],
			{}
		],
		(*late operator pick up intervals*)
		If[TrueQ[instrumentCheckIns],
			Interval[#]&/@Flatten[pickUpOverTimes,1],
			{}
		]
	];

	printValue[input_]:=CellPrint[ExpressionCell[input, "Output"]];

	(* Create buttons with {type,operator} as tooltip, CopyToClipboard as action*)
	taskIntervals=If[taskDisplay,
		Module[{totalTime},
			totalTime=(endDates[[-1]]-startDates[[1]]);

			MapThread[
				Function[{taskPacket, intervalDates},
					EventHandler[
						Labeled[Interval[intervalDates], Lookup[taskPacket, TaskType], Above],
						With[{insertMe={Lookup[taskPacket, TaskType], Lookup[taskPacket, TaskID], Lookup[taskPacket,Object]}},
							"MouseClicked" :> printValue[insertMe]
						]
					]
				],
				{taskStartPackets, Append[Partition[Lookup[taskStartPackets, DateCreated], 2, 1], {Lookup[Last[taskStartPackets], DateCreated], Lookup[Last[taskStartPackets], DateCreated]}]}
			]
		],
		{}
	];

	subprotocolIntervals=Map[
		EventHandler[
			(* NOTE: Aborted protocols that don't have DateCompleted mess up our plot, so replace any Nulls with the parent protocol's DateCompleted. *)
			Labeled[Interval[{Lookup[#, DateCreated], Lookup[#, DateCompleted]}], Lookup[#, Object], Above] /. {Null -> Lookup[parentProtocolPacket, DateCompleted]},
			With[{insertMe=Lookup[#,Object]},
				"MouseClicked" :> printValue[insertMe]
			]
		]&,
		Flatten[{parentProtocolPacket, subprotocolPackets}]
	];

	(* Create buttons with ticket as tooltip, CopyToClipboard as action*)
	ticketButtons=MapThread[plotProtocolTimelineButton[#1,#2,printValue[#2]]&,{ticketStartDates,ticketsInRange}];

	(*Make a timeline plot*)
	plot=Which[
		subprotocolDisplay,
			TimelinePlot[subprotocolIntervals, PlotRange->{startDates[[1]]-30 Minute,endDates[[-1]]+30 Minute}],
		taskDisplay,
			TimelinePlot[taskIntervals, PlotRange->{startDates[[1]]-30 Minute,endDates[[-1]]+30 Minute}, PlotLayout -> "Stacked"],
		True,
			TimelinePlot[
				timePoints,
				PassOptions[
					TimelinePlot,
					Sequence@@ReplaceRule[safeOps,{
						LabelingFunction->labelingFunction,
						PlotStyle->plotStyles,
						PlotMarkers->Join[
							(*disks for status intervals*)
							Table[\[FilledCircle],Length[statuses]],
							(*No markers for the filler interval*)
							{None},
							(*disks for error events*)
							Table[Style[\[FilledCircle],blue],Length[errorEvents]],
							(*rectangles for interrupt events *)
							Table[Style[\[FilledCircle],yellow],Length[interruptEvents]],
							(*line markers for labeled late check-in intervals*)
							Table[Style[\[FilledSquare],Darker[Blue]],Length[Flatten[checkInOverTimes,1]]],
							(*line markers for late pick-up intervals*)
							Table[Style[\[FilledSquare],Darker[Blue]],Length[Flatten[pickUpOverTimes,1]]],
							(*disks for unlabeled check-in intervals*)
							Table[Style[\[FilledSquare],Darker[Blue]],Length[Flatten[checkInOverTimes,1]]],
							(*disks for unlabeled pick-up intervals*)
							Table[Style[\[FilledSquare],Darker[Blue]],Length[Flatten[pickUpOverTimes,1]]]
						],
						Spacings->Join[
							(*disks for status intervals growing upward*)
							Table[1,Length[statuses]],
							(*because of how spacing works, we need to reset back to the axis*)
							{-Length[statuses]},
							(*disks for error events on the axis*)
							Table[0,Length[errorEvents]],
							(*rectangles for interrupt events on the axis*)
							Table[0,Length[interruptEvents]],
							(*lines for late check in durations on the axis*)
							Table[0, Length[Flatten[checkInOverTimes,1]]],
							(*lines for late pick up durations on the axis*)
							Table[0, Length[Flatten[pickUpOverTimes,1]]],
							(*disks for late check ins growing at each instrument processing status*)
							Flatten[checkInSpacings],
							(*reset back at the first instance we encounter an late pick up time*)
							{-Total[Flatten[checkInSpacings]]+First[Flatten[pickUpSpacings], 0]},
							(*disks for late pick ups growing at each instrument processing status*)
							RestOrDefault[Flatten[pickUpSpacings], {}]
						],
						PlotRange->{startDates[[1]]-30 Minute,endDates[[-1]]+30 Minute},
						Epilog->{
							Darker[Red],
							ticketButtons
						}
					}]
				]
			]
	];

	(* Pull out the resolved options *)
	finalResolvedOps={InterruptMarkers->Lookup[SafeOptions[PlotProtocolTimeline],InterruptMarkers],Output->Lookup[SafeOptions[PlotProtocolTimeline],Output]};

	(* Return the requested outputs *)
	outputSpecification/.{
		Result->zoomableWorkaround[plot],
		Options->finalResolvedOps,
		Preview->Show[plot,ImageSize->Full],
		Tests->{}
	}
];


(* This function takes in the ReadyCheckLog of a function along with the initial start dates, end dates, statuses, and responsible parties of a protocol's StatusLog *)
(* And interweaves the statuses in the ready check log into the status log. These new start dates, end dates, statuses, and responsible parties are returned *)
addReadyCheckStatuses[readyLog_,startDates_,endDates_,statuses_,responsibleParties_]:=Module[{uniqueUnavailableObjects,unavailableNames,unavailableObjectLookup,
	namedObject,notReadyTimePeriods,availableObjects, amendedLog},

	(* Get any objects that were available at anytime *)
	uniqueUnavailableObjects=DeleteDuplicates[Lookup[Flatten[Lookup[readyLog[[All,3]], {UnavailableInstruments, UnavailableMaterials},<||>]],Object,Nothing]];

	(* We have to do a Download here because ReadyCheckLog has to be stored as an expression since we need a nested named multiple *)
	unavailableNames=Download[uniqueUnavailableObjects,Name];

	(* Make a lookup we can use to get the name of the objects *)
	unavailableObjectLookup=AssociationThread[uniqueUnavailableObjects,unavailableNames];

	(* == Define Function: namedObject == *)
	(* Make a tiny version of NamedObject to convert to named form is we have names *)
	namedObject[objs:{ObjectP[]...}]:=namedObject/@objs;
	namedObject[obj:ObjectP[]]:=If[NullQ[Lookup[unavailableObjectLookup,obj]],
		obj,
		Append[obj[Type],Lookup[unavailableObjectLookup,obj]]
	];

	(* Parse out relevant ReadyCheck states - we only care about the case where the protocol was not ready *)
	notReadyTimePeriods=If[MatchQ[readyLog,{}],
		{},

		(* The input readyLog is split by True or False depending on if the protocol passed ReadyCheck in the log*)
		Module[{consolidatedReadyLog},
			consolidatedReadyLog = Map[
				{First[#][[1]], First[#][[2]], First[#][[3]]} &,
				SplitBy[readyLog, #[[2]] &]
			];

			(* Append 'Now' because we're assuming the log hasn't been updated because it hasn't changed - i.e it's still in the same state *)
			MapThread[
				If[MatchQ[#1[[2]],False],
					{#1[[2]], #1[[1]], #2[[1]], #1[[3]]},
					Nothing
				]&,
				{consolidatedReadyLog, Append[Drop[consolidatedReadyLog, 1], {Now, consolidatedReadyLog[[-1, 2]]}]}
			]
		]
	];

	amendedLog=MapThread[
		Function[{statusStartTime,statusEndTime,status,rp},
			If[MatchQ[status,OperatorReady],
				Module[{rcFalsePeriods, innerOperatorReadyPeriods, beginningOperatorReadyEntry, endOperatorReadyEntry},
					rcFalsePeriods = Map[
						Function[readyFalsePeriod,
							Module[{beginningTime, endTime, readyCheckReport,materialsOwnerString,materialsString,instrumentString,
								fullString,unavailables,beginningWithin,endWithin,fullyContains},

								(* Get the beginning and end of our current Ready->False period *)
								beginningTime = readyFalsePeriod[[2]];
								endTime = readyFalsePeriod[[3]];

								(* Get the restricting *)
								readyCheckReport = readyFalsePeriod[[4]];

								materialsOwnerString = StringRiffle[
									{
										Lookup[readyCheckReport, ECLMaterialsAvailable, False] /. {False -> "ECL", True -> Nothing},
										Lookup[readyCheckReport, UserMaterialsAvailable, False] /. {False -> "User", True -> Nothing}
									},
									" and "
								];

								(* List out the unavailable objects, if not set because object is older *)
								materialsString = Which[
									Lookup[readyCheckReport, ECLMaterialsAvailable, False] && Lookup[readyCheckReport, UserMaterialsAvailable, False], Nothing,
									MatchQ[Lookup[readyCheckReport, UnavailableMaterials],{}], materialsOwnerString<>" "<>"Materials Unavailable",
									True, StringRiffle[namedObject[Lookup[Lookup[readyCheckReport, UnavailableMaterials, <||>],Object,{}]], ", "]<> " (" <> materialsOwnerString <> ")"
								];

								instrumentString = If[!Lookup[readyCheckReport, InstrumentsAvailable, False],
									StringRiffle[namedObject[Lookup[Lookup[readyCheckReport, UnavailableInstruments, <||>],Object,{}]], ", "],
									Nothing
								];

								fullString = StringRiffle[{materialsString, instrumentString},"; "];

								(* Determine how our Ready period overlaps with status period and act accordingly:
									can be fully contained within OperatorReady time
									can overlap with start or end of OperatorReady time
									can fully contain OperatorReady time
								*)
								beginningWithin = MatchQ[beginningTime, RangeP[statusStartTime, statusEndTime]];
								endWithin = MatchQ[endTime, RangeP[statusStartTime, statusEndTime]];
								fullyContains = LessDateQ[beginningTime, statusStartTime] && GreaterDateQ[endTime, statusEndTime];

								Which[
									beginningWithin&&endWithin,{beginningTime,endTime,ResourceLimitation,rp, fullString},
									beginningWithin,{beginningTime,statusEndTime,ResourceLimitation,rp, fullString},
									endWithin,{statusStartTime,endTime,ResourceLimitation,rp, fullString},
									fullyContains,{statusStartTime,statusEndTime,ResourceLimitation,rp, fullString},
									True,Nothing
								]
							]
						],
						notReadyTimePeriods
					];

					innerOperatorReadyPeriods = MapIndexed[
						Module[{},
							entry = #1;
							index = First[#2];
							If[(LessEqualDateQ[entry[[2]],statusEndTime] && index < Length[rcFalsePeriods]),
								{entry[[2]], First[rcFalsePeriods[[index + 1]]],OperatorReady,rp, Null},
								Nothing
							]
						]&,
						rcFalsePeriods
					];

					beginningOperatorReadyEntry = Which[
						MatchQ[rcFalsePeriods,{}],{{statusStartTime,statusEndTime,OperatorReady,rp, Null}},
						GreaterDateQ[rcFalsePeriods[[1,1]],statusStartTime],{{statusStartTime,rcFalsePeriods[[1,1]],OperatorReady,rp, Null}},
						True,{}
					];

					endOperatorReadyEntry = If[MatchQ[rcFalsePeriods,{__}]&&LessDateQ[rcFalsePeriods[[-1,2]],statusEndTime],
						{{rcFalsePeriods[[-1,2]],statusEndTime,OperatorReady,rp, Null}},
						{}
					];

					SortBy[Join[beginningOperatorReadyEntry,innerOperatorReadyPeriods,rcFalsePeriods,endOperatorReadyEntry],First]

				],

				{{statusStartTime,statusEndTime,status,rp, Null}}
			]
		],
		{startDates,endDates,statuses,responsibleParties}
	];

	Transpose[DeleteDuplicates[Apply[Join,amendedLog]]]
];


(* Directly use EventHandler rather than Button as it's much faster *)
SetAttributes[plotProtocolTimelineButton, HoldRest];
plotProtocolTimelineButton[time_DateObject, label_, buttonFunction_]:=EventHandler[
	Tooltip[Point[{AbsoluteTime@time, 0}],label],
	"MouseClicked" :> buttonFunction
];

(*This is a workaround for the problem with ECL's standard Zoomable wrapper
preventing any mouse events from passing through to the buttons on the plot making them
unclickable when zoomed in.  This workaround contains pieces of much larger
code belonging to SciComp's new interactive framework.  This workaround is guaranteed to work
on PlotProtocolTimeline, and nothing else.  Do not use this function anywhere else.*)
zoomableWorkaround[in : Graphics[primitives_, options___]] :=
	With[
		{fullPlotRange = Options[in, PlotRange][[1, 2]]},
		{xMinFull = fullPlotRange[[1, 1]], xMaxFull = fullPlotRange[[1, 2]],
			yMinFull = fullPlotRange[[2, 1]],
			yMaxFull = fullPlotRange[[2, 2]]},
		DynamicModule[
			{
				xMin = xMinFull, xMax = xMaxFull,
				yMin = yMinFull, yMax = yMaxFull
			},
			Replace[
				MapAt[Append[
					DynamicModule[{isMakingZoomBox = False, p1 = Scaled[{0, 0}], p2 = Scaled[{0, 0}]},
						{EventHandler[
							Style[Rectangle[Scaled[{0, 0}], Scaled[{1, 1}]],ShowContents -> False],
							{{"MouseDown", 1} :>
								(FEPrivate`Set[isMakingZoomBox, True];
								FEPrivate`Set[p1,
									FrontEnd`CurrentValue[{"MousePosition", "Graphics"}]];
								FEPrivate`Set[p2, p1]),
								{"MouseDragged", 1} :>
									If[isMakingZoomBox,FEPrivate`Set[p2,
										FrontEnd`CurrentValue[{"MousePosition","Graphics"}]]],
								{"MouseUp",1} :>
									(Set[isMakingZoomBox, False];
									If[Or[Equal[p1[[1]], p2[[1]]], Equal[p1[[2]], p2[[2]]]],
										Set[{{xMin, xMax}, {yMin, yMax}}, fullPlotRange];,
										Set[{xMin, xMax, yMin, yMax}, {Min[p1[[1]], p2[[1]]],
											Max[p1[[1]], p2[[1]]], Min[p1[[2]], p2[[2]]],
											Max[p1[[2]], p2[[2]]]}];
										Set[p1, p2];])}, PassEventsDown -> False,
							PassEventsUp ->False],
							{
								EdgeForm[{Thin, Dashing[Small], Opacity[0.7]}],
								FaceForm[RGBColor[0.89`, 0.83`, 0.76`, 0.45]],
								Rectangle[Dynamic[p1], Dynamic[p2]]}
						}]],
					in, {1, 2}],
				HoldPattern[
					PlotRange -> _] -> (PlotRange ->
					Dynamic[{{xMin, xMax}, {yMin, yMax}}]),
				{1}
			]
		]
	];