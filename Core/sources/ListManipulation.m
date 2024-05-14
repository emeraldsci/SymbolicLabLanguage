(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*FirstOrDefault*)


(* ::Subsubsection::Closed:: *)
(*FirstOrDefault*)


FirstOrDefault[expr_]:=FirstOrDefault[expr, Null];

FirstOrDefault[expr_, default_]:=If[Length[expr] > 0,
	First[expr],
	default
];



(* ::Subsection::Closed:: *)
(*LastOrDefault*)


(* ::Subsubsection::Closed:: *)
(*LastOrDefault*)


LastOrDefault[expr_]:=LastOrDefault[expr, Null];

LastOrDefault[expr_, default_]:=If[Length[expr] > 0,
	Last[expr],
	default
];



(* ::Subsection::Closed:: *)
(*MostOrDefault*)


(* ::Subsubsection::Closed:: *)
(*MostOrDefault*)


MostOrDefault[expr_]:=MostOrDefault[expr, Null];

MostOrDefault[expr_, default_]:=If[Length[expr] > 0,
	Most[expr],
	default
];



(* ::Subsection::Closed:: *)
(*RestOrDefault*)


(* ::Subsubsection::Closed:: *)
(*RestOrDefault*)


RestOrDefault[expr_]:=RestOrDefault[expr, Null];

RestOrDefault[expr_, default_]:=If[Length[expr] > 0,
	Rest[expr],
	default
];



(* ::Subsection::Closed:: *)
(*DeleteNestedDuplicates*)


(* ::Subsubsection::Closed:: *)
(*DeleteNestedDuplicates*)


DeleteNestedDuplicates[nestedList_List]:=Module[
	{members, tallies, dupMembers},

	(* Generate a list of only the (non-list) elements that appear more than once *)
	tallies=Tally[Flatten[nestedList]];
	dupMembers=Cases[tallies, {_, Except[1]}][[All, 1]];

	(* For each duplicate element, find and remove all but the first instance.
	 	Empirically, it is faster in most cases to Fold than it is to find and delete 
		all duplicates at once (presumably thanks to decreasing list size on each iteration). 
		This is particularly pronounced for lists containing many sets of duplicates. *)
	Fold[
		Function[
			{culledList, member},
			Module[
				{memberPositions},
				(* Determine where 'member' appears in 'culledList' *)
				memberPositions=Position[culledList, member];
				(* Delete all but the first instance of 'member' in 'culledList' and pass to next iteration *)
				Delete[culledList, Rest[memberPositions]]
			]
		],
		nestedList,
		dupMembers
	]
]


(* ::Subsection::Closed:: *)
(*ParseLog*)


(* ::Subsubsection::Closed:: *)
(*ParseLog*)

(* Functions for parsing 'Log' fields of an object *)
DefineOptions[ParseLog,
	Options:>{
		{
			OutputFormat->Times,
			Alternatives[
				List,
				Times,
				Percent,
				Pattern,
				DateRange
			],
			"The format that the parsed log should be output in. By default, an association of Times in each status are returned. Percent returns these times converted to a percentage of the total analysis period. List returns a simple list of statuses/identifiers that were active at some point during the analysis period. DateRange returns an association with a list of times for each status during which they were active. Pattern returns the DateRange association converted to patterns using RangeP."
		},
		{
			StartDate->Null,
			_DateObject|Null,
			"The date marking the beginning of the time period to analyze the log contents over. If Null, the time of the first entry in the log will be used."
		},
		{
			EndDate->Null,
			_DateObject|Null,
			"The date marking the end of the time period to analyze the log contents over. If Null, the time of the final entry of the log will be used if ClosedLog->True, otherwise Now."
		},
		{
			Units->Automatic,
			UnitsP[]|Automatic,
			"The units to output results in, if applicable. If Automatic, uses UnitScale to determine a sensible unit."
		},
		(* Options for the friendly overload only *)
		{
			DateColumn->Automatic,
			GreaterP[0,1]|Automatic,
			"The number of the column that contains the dates at which each item in the log occurred. If Automatic, resolves to the correct column based on the log type, if the log type is known. Otherwise resolves to 1."
		},
		{
			StatusColumn->Automatic,
			GreaterP[0,1]|Automatic,
			"The number of the column that contains the status that is changed and recorded in each item in the log. For example containing Available, Running, In, Out, OperatorStart etc. If automatic, resolves to the correct column based on the log type, if the log type is known. Otherwise resolves to 2."
		},
		{
			IdentifierColumn->Automatic,
			GreaterP[0,1]|Automatic,
			"For logs that track multiple items, such as connection logs, the number of the column that contains the object reference or other identifier to separate the log by into separate sub-logs for analysis. For single status logs, this may be set to the StatusColumn to, by definition, treat all periods of each status the same. Or it may be set to the \"Responsible party\" or similar field to disambiguate periods with the same status, but different responsible party (such as Running for an instrument). If automatic, resolves to the most commonly used column based on the log type, if the log type is known. Otherwise resolves to 2."
		},
		{
			OutputColumn->Automatic,
			ListableP[GreaterP[0,1]]|Automatic,
			"The number(s) of the column(s) whose entries will be described by the output. The total amount of time spent associated with the items in these columns will be described in the output. If Automatic, resolves to the most commonly used column based on the log type, if the log type is known. Otherwise resolves to 2."
		},
		{
			SingleStatus->Automatic,
			BooleanP|Automatic,
			"Indicates if this log tracks only one status, where each line in the log supersedes the previous line (such as instrument status, restricted status etc) or if it tracks the status of multiple objects in parallel, such as a connection log. If Automatic, resolves to the correct value based on the log type, if the log type is known. Otherwise resolves to True."
		},
		{
			CountOverlap->Automatic,
			BooleanP|Automatic|Null,
			"Indicates if the periods of overlap in a multi-status log should be attributed to all active objects individually, or just the most recently activated. For example, if an operator is interrupted, two protocols will be active in their ProtocolLog - setting this option to True will return the total time a protocol is active (time between Enter and Exit) whereas False will return the time that a protocol is being actively worked on by the operator. If Automatic, resolves to the Null for single-status logs and True for multi-status logs, with the exception of ProtocolLogs where is resolves to False."
		},
		{
			ClosedLog->Automatic,
			BooleanP|Automatic,
			"Indicates if the final entry in this log indicates the end of the analysis period, or if the final entry continues to Now. If Automatic, resolved to False."
		},
		{
			InactiveStatuses->Automatic,
			ListableP[_Symbol] | Null | Automatic,
			"For multiple status fields, as list of statuses that should be disregarded from analysis, such as Disconnect for a connection log - if we know the time it was connected, we don't need to know all the time it wasn't. For single status, it can be used to sever the connection between the responsible party and the time period following. If Automatic, resolves to the correct value based on the log type, if the log type is known. Otherwise resolves to {}."
		},
		{
			Cache->{},
			{(ObjectP[] | Null)...},
			"List of pre-downloaded packets to be used before checking for session cached object or downloading any object information from the server.",
			Category -> Hidden
		}
	}
];


(* Core function for parsing a log when we have all the data *)
ParseLog[myLog:Alternatives[{{__}..},{<|__|>..}],myDateColumn:_Integer,myStatusColumn:_Integer,myIdentifierColumn:_Integer,myOutputColumn:ListableP[_Integer],mySingleStatusQ:BooleanP,myClosedLogQ:BooleanP,myInactiveStatuses:ListableP[_Symbol]|{},myOptions:OptionsPattern[ParseLog]]:=Module[
	{
		(* Input and options *)
		safeOps,myLogListed,outputFormat,startDate,endDate,units,numberOfFields,sanitizedLog,startDateCorrectedLogs,
		timePeriod,logBeginsDate,logEndsDate,dateCorrectedLogs,listedInactiveStatuses,listedOutputColumn,countOverlap,
		listedInactiveStatusesWithOverlap,

		(* Do the thing *)
		statusDateSpans,statusDateSpansGrouped,perIdentifierLogs,resolvedStartDate,resolvedEndDate,output
	},

	(* get the options pass to this function *)
	safeOps=SafeOptions[ParseLog,ToList[myOptions]];

	(* Lookup some variables *)
	{outputFormat,startDate,endDate,units,countOverlap}=Lookup[safeOps,{OutputFormat,StartDate,EndDate,Units,CountOverlap}];

	(* Ensure inactive statuses are a list *)
	listedInactiveStatuses=ToList[myInactiveStatuses/.Null->{}];

	(* Create an inactive list with Overlap included, for easy use later if required *)
	listedInactiveStatusesWithOverlap=Append[listedInactiveStatuses,ECL`Overlap];

	(* Ensure the output column(s) are in list form *)
	listedOutputColumn=ToList[myOutputColumn];

	(* Convert any associations in the log to lists *)
	myLogListed=If[MatchQ[myLog, _Association | {__Association}], Values[myLog], myLog]; 	

	(* Sanitize the log - remove links and make sure it's in date order. Remove entries without a date *)
	sanitizedLog=Select[myLogListed,MatchQ[#[[myDateColumn]],_?DateObjectQ]&]/.{x:LinkP[]:>Download[x,Object]};

	(* Count the number of fields in the log *)
	numberOfFields=Length[sanitizedLog[[1]]];

	(* Determine when the log begins *)
	logBeginsDate=sanitizedLog[[1,myDateColumn]];

	(* Determine when the log ends *)
	logEndsDate=sanitizedLog[[-1,myDateColumn]];

	(* If a start date is not provided, use the date of the first entry of the log *)
	resolvedStartDate=startDate/.Null->logBeginsDate;

	(* Resolve the end date *)
	resolvedEndDate=Replace[
		{endDate,myClosedLogQ},
		{
			(* If no end date is provided and the log is not closed, we're ending now *)
			{Null,False}->Now,

			(* If no end date is provided and the log is closed, we're ending at the last entry in the log *)
			{Null,True}->logEndsDate,

			(* If we provide an end date, ues it, even if the log is closed *)
			{Except[Null],_}->endDate
		}
	];

	(* Get the total time period of interest *)
	timePeriod=resolvedEndDate-resolvedStartDate;

	(* Separate the logs based on the identifier field. For example, if looking at a contents log, split into a separate log for each object contained *)
	(* This converts multi-status logs into a list of single status logs for each identifier *)
	perIdentifierLogs=Switch[{mySingleStatusQ,countOverlap,MatchQ[myStatusColumn,myIdentifierColumn]},
		(* If the log only has a single status at a time, nothing to split by *)
		{True,_,_},
		{sanitizedLog},

		(* If it's a multi-status field but we're using the status field as the identifier to get high level information (reducing it effectively to a single status log), iterate over the log and remove duplicate activations/deactivations of a status *)
		{False,False,True},
		{First[Fold[Function[{counter,logLine},
			Module[
				{
					runningLog,overlapCounter,lineActiveQ,updatedNewAgumentedObjLog,updatedOverlapCounter
				},
				(* Split up the counter variable-each iteration we pass through the new log that we're building, and the number of protocols currently active/overlapping *)
				{runningLog,overlapCounter}=counter;

				(* Is the current line indicating an active status? *)
				lineActiveQ=!MemberQ[listedInactiveStatuses,logLine[[myStatusColumn]]];

				(* Update the overlap counter *)
				updatedOverlapCounter=If[lineActiveQ,
					(* If this line is an active status, add one to the status counter *)
					overlapCounter+1,
					(* Otherwise, subtract one from the status counter *)
					overlapCounter-1
				];

				(* Append the new line to the log if required *)
				updatedNewAgumentedObjLog=Switch[{overlapCounter,updatedOverlapCounter},
					(* If the overlap counter is switching from 0 to 1, append this new line *)
					{0,1},
					Append[runningLog,logLine],

					(* If the overlap counter is switching from 1 to 0, append this new line *)
					{1,0},
					Append[runningLog,logLine],

					(* Otherwise, ignore the line - it just duplicates the status of the previous  *)
					{_,_},
					runningLog
				];

				(* Return the updated variables *)
				{updatedNewAgumentedObjLog,updatedOverlapCounter}
			]
		],
			{{},0},
			sanitizedLog
		]]},

		(* If it's a multi-status field but we're using the status field as the identifier to get high level information, CounterOverlap can't be True *)
		{False,True,True},
		ParseLog::ParseLogCountOverlapConflict="Counting overlap conflicts with selecting the same status column as the identifier column. Please set CounterOverlap->False or set different values for StatusColumn and IdentifierColumn.";
		Message[ParseLog::ParseLogCountOverlapConflict];
		Return[$Failed],

		(* Otherwise, it's a multiple status field. If we're counting overlap periods, just split by the identifier field *)
		{False,Except[False],_},
		GatherBy[sanitizedLog,#[[myIdentifierColumn]]&],

		(* If we're not counting overlap periods, we'll add explicit lines to each individual sub-log indicating the overlap periods so that these are counted separately, for each unique object in the log *)
		{False,False,_},
		First[Fold[
			Function[{counter,logLine},
				Module[
					{
						objActiveQ,lastActivatingLine,runningLog,overlapCounter,lineObject,lineActiveQ,
						updatedNewAgumentedObjLog,updatedOverlapCounter
					},

					(* Split up the counter variable - each iteration we pass through the new log that we're building, and a list of any protocols that are currently active/overlapping *)
					{runningLog,overlapCounter}=counter;

					(* Check if the object of interest is currently active *)
					objActiveQ=MemberQ[overlapCounter,ObjectReferenceP[#]];

					(* Get the last activating line for the object of interest - we need this if this line terminates the final overlapping protocol, and we therefore want to re-activate the log *)
					lastActivatingLine=Last[Select[runningLog,!MemberQ[listedInactiveStatusesWithOverlap,#[[myStatusColumn]]]&],{}];

					(* What object does the current line refer to? *)
					lineObject=logLine[[myIdentifierColumn]];

					(* Is the current line indicating an active status? *)
					lineActiveQ=!MemberQ[listedInactiveStatuses,logLine[[myStatusColumn]]];

					(* Update the overlap counter *)
					updatedOverlapCounter=If[lineActiveQ,
						(* Is this line is an active status, add the line's object to the counter list, deleting duplicates *)
						Union[Append[overlapCounter,lineObject]],

						(* Otherwise, remove it if it's present *)
						DeleteCases[overlapCounter,lineObject]
					];

					(* Append any new lines to the running log for the object of interest *)
					updatedNewAgumentedObjLog=Switch[{objActiveQ,lineObject,lineActiveQ,updatedOverlapCounter},
						(* If this log line refers to our object of interest, simply append as is *)
						{_,#,_,_},
						Append[runningLog,logLine],

						(* If our object of interest is currently inactive, ignore this line of the log as there can be no overlap *)
						{False,_,_,_},
						runningLog,

						(* If our object is active, and this line is active, append an overlap line to the status log *)
						{True,_,True,_},
						Append[runningLog,
							ReplacePart[
								ConstantArray[Null,numberOfFields],
								{
									myDateColumn->logLine[[myDateColumn]],
									myStatusColumn->ECL`Overlap,
									myIdentifierColumn->#
								}
							]
						],

						(* Otherwise if this line is de-activating, and the updatedOverlapCounter is just the object of interest,
						add an explicit re-activation line for the object of interest *)
						{True,_,False,{ObjectReferenceP[#]}},
						Append[runningLog,ReplacePart[lastActivatingLine,{myDateColumn->logLine[[myDateColumn]]}]],

						(* Otherwise if the line is deactivating,but other overlapping protocols are still active,leave it be *)
						{True,_,False,_},
						runningLog
					];

					(* Return the updated variables *)
					{updatedNewAgumentedObjLog,updatedOverlapCounter}
				]
			],
			{{},{}},
			sanitizedLog
		]]&/@DeleteDuplicates[sanitizedLog[[All,myIdentifierColumn]]]
	];


	(* Edit the sub-logs so that we account for the start and end dates *)
	startDateCorrectedLogs=Function[{subLog},Switch[subLog[[1,myDateColumn]],
		(* If the first entry in the whole log is in this sub-log, leave it be *)
		EqualP[resolvedStartDate],
		subLog,

		(* If the start date begins before this sub-log begins, add an entry at the beginning with Null status. Add in the identifier if it's not the status column *)
		GreaterP[resolvedStartDate],
		Prepend[subLog,ReplacePart[ConstantArray[Null,numberOfFields],{myDateColumn->resolvedStartDate,If[!EqualQ[myIdentifierColumn,myStatusColumn],myIdentifierColumn->subLog[[1,myIdentifierColumn]],Nothing]}]],

		(* If the start date begins after the log begins, shift the prior entry to line up with our specified start date *)
		LessP[resolvedStartDate],
		Prepend[
			Select[subLog,GreaterQ[#[[myDateColumn]],resolvedStartDate]&],
			ReplacePart[Last[Select[subLog,LessEqualQ[#[[myDateColumn]],startDate]&]],myDateColumn->resolvedStartDate]
		]
	]]/@perIdentifierLogs;

	(* Account for the end dates *)
	dateCorrectedLogs=Function[{subLog},Switch[{subLog[[-1,myDateColumn]],mySingleStatusQ},
		(* If the last entry in the whole log is in this sub-log, leave it be *)
		{EqualP[resolvedEndDate],_},
		subLog,

		(* If the log is single status, select all of the log entries prior to our end date and extend the final status to the end *)
		{_,True},
		With[{entriesBeforeEnd=Select[subLog,LessQ[#[[myDateColumn]],resolvedEndDate]&]},
			Append[
				entriesBeforeEnd,
				ReplacePart[entriesBeforeEnd[[-1]],myDateColumn->resolvedEndDate]
			]
		],

		(* If the log is not single status, do the same as above, but only extend an active status, otherwise fill in with Null *)
		{_,False},
		Append[
			Select[subLog,LessQ[#[[myDateColumn]],resolvedEndDate]&],
			If[!MatchQ[Select[subLog,LessQ[#[[myDateColumn]],resolvedEndDate]&][[-1,myStatusColumn]],Alternatives@@listedInactiveStatusesWithOverlap],
				ReplacePart[Select[subLog,LessQ[#[[myDateColumn]],resolvedEndDate]&][[-1]],myDateColumn->resolvedEndDate],
				ReplacePart[ConstantArray[Null,numberOfFields],{myDateColumn->resolvedEndDate,myStatusColumn->Select[subLog,LessQ[#[[myDateColumn]],resolvedEndDate]&][[-1,myStatusColumn]]}]
			]]
	]]/@startDateCorrectedLogs;


	(* Now do the actual parsing of the output *)
	statusDateSpans=Map[
		MapThread[
			Function[
				{beginDate,endDate,status,field},
				Switch[{!MatchQ[status,Alternatives@@listedInactiveStatusesWithOverlap],MemberQ[field,status],status},
					(* If the status is Null, don't include it *)
					{_,_,NullP},
					Nothing,
					(* If we're in an active status, it's part of the output. If we're outputting the status field, just a single key for the output *)
					{True,True,_},
					{field/.{x:_}:>x,{beginDate,endDate}},

					(* If we're in an active status, it's part of the output. If we're not outputting the status field, output with a tuple key *)
					{True,False,_},
					{field/.{x:_}:>x,{beginDate,endDate}},

					(* If we're switching to an inactive status, we should only output it if we're outputting the statuses. *)
					{False,True,_},
					{field/.{x:_}:>x,{beginDate,endDate}},

					{False,False,_},
					Nothing
				]
			],
			{#[[;;-2,myDateColumn]],#[[2;;,myDateColumn]],#[[;;-2,myStatusColumn]],#[[;;-2,listedOutputColumn]]}
		]&,
		dateCorrectedLogs
	];


	(* Group date spans by field and/or status of interest *)
	statusDateSpansGrouped=GroupBy[#,First->Last]&/@statusDateSpans;

	output=Switch[outputFormat,

		(* If we just want a list of the statuses that were applicable during the time period *)
		List,
		DeleteDuplicates[DeleteDuplicates[Keys[#]],SameObjectQ],

		(* If we want the time in each status, sum them up *)
		Times,
		Function[{dateList},
			If[!MatchQ[units,Automatic],
				Convert[
					Total[(Last[#]-First[#])&/@dateList],
					units
				],
				UnitScale[
					Total[(Last[#]-First[#])&/@dateList]
				]
			]
		]/@#,

		(* If we want the percent time in each status, sum them up *)
		Percent,
		Function[{dateList},
			SafeRound[If[!MatchQ[units,Automatic],
				Convert[
					Total[(Last[#]-First[#])&/@dateList],
					units
				],
				UnitScale[
					Total[(Last[#]-First[#])&/@dateList]
				]
			]/timePeriod*100,0.01] Percent
		]/@#,

		(* If we want an association where status -> datePattern *)
		Pattern,
		Function[{dateList},
			Alternatives@@(RangeP[First[#],Last[#]]&/@dateList)
		]/@#,

		(* If we want the date ranges *)
		DateRange,
		#,

		_,
		$Failed
	]&/@statusDateSpansGrouped;

	(* Combine the output from the sub-logs *)
	Which[
		(* If the output is a list of associations, merge them *)
		GreaterQ[Length[output],1]&&MatchQ[output,{<|___|>..}],
		(* If we have multiple sub-logs, merge the associations *)
		Merge[output,
			Switch[#,
				(* If the outputs are lists, join them *)
				{{___} ..},
				Join@@#,

				(* If the outputs are quantities, sum them *)
				{_?QuantityQ ..},
				Total[#],

				(* Otherwise, return the alternatives *)
				_,
				Alternatives@@#
			]&
		],

		(* If it's a list of not associations, join them *)
		GreaterQ[Length[output],1],
		Join@@output,

		(* Otherwise, we have only one item, so return it *)
		True,
		First[output]
	]
];


ParseLog::InvalidField="`2` does not contain the field `1`.";
ParseLog::InvalidLogField="Field `1` for `2` does not match the pattern of a compatible log field.";

ParseLog[myObjects:ObjectP[],myField:_Symbol,myOptions:OptionsPattern[ParseLog]]:=FirstOrDefault[ParseLog[{myObjects},myField,myOptions],Null];

ParseLog[myObjects:{ObjectP[]..},myField:_Symbol,myOptions:OptionsPattern[ParseLog]]:=Module[
	{
		(* Input and options *)
		safeOps,cache,outputFormat,startDate,endDate,units,listedObjects,validFields,validFieldQ,
		specifiedDateColumn,specifiedStatusColumn,specifiedIdentifierColumn,specifiedOutputColumn,specifiedSingleStatus,specifiedClosedLog,
		specifiedInactiveStatuses,specifiedCountOverlap,

		resolvedDateColumn,resolvedStatusColumn,resolvedIdentifierColumn,resolvedOutputColumn,resolvedSingleStatus,resolvedClosedLog,
		resolvedInactiveStatuses,resolvedCountOverlap,

		(* Download *)
		fieldData,deadQ,deadDate,allData,

		(* Parsing info *)
		invalidFieldFormatQ,defaultInputs,resolvedEndDate
	},

	(* get the options pass to this function *)
	safeOps=SafeOptions[ParseLog,ToList[myOptions]];

	(* Lookup some variables *)
	{
		cache,outputFormat,startDate,endDate,units,
		specifiedDateColumn,specifiedStatusColumn,specifiedIdentifierColumn,specifiedOutputColumn,specifiedSingleStatus,specifiedClosedLog,
		specifiedInactiveStatuses,specifiedCountOverlap
	}=Lookup[safeOps,
		{
			Cache,OutputFormat,StartDate,EndDate,Units,
			DateColumn,StatusColumn,IdentifierColumn,OutputColumn,SingleStatus,ClosedLog,InactiveStatuses,CountOverlap
		}
	];

	(* Check the inputs we have *)
	listedObjects=ToList[myObjects];

	(* Get the valid fields for each object *)
	validFields=Fields[#[Type],Output->Short]&/@listedObjects;

	(* Throw error if we don't have the field *)
	validFieldQ=!MemberQ[#,myField]&/@validFields;

	If[Or@@validFieldQ,
		Message[ParseLog::InvalidField,myField,PickList[listedObjects,validFieldQ]];
		Return[$Failed]
	];

	(* Download the data *)
	fieldData=Quiet[Download[listedObjects,{myField,Status,Deprecated,DateRetired,DateDiscarded,DateCompleted},Cache->cache],{Download::FieldDoesntExist,Download::MissingCacheField}];

	(* Check if the object is dead *)
	deadQ=Switch[#,
		{Alternatives[Retired,Discarded,Completed],_},
		True,

		{_,True},
		True,

		{_,_},
		False
	]&/@fieldData[[All,2;;3]];

	(* Get the date it died if possible *)
	deadDate=Min[Cases[#,_?DateObjectQ]/.{}->Null]&/@fieldData[[All,4;;]];

	(* Get all the data together *)
	allData=Transpose[{listedObjects,fieldData[[All,1]],deadQ,deadDate}];

	(* Some hardcoded parameters so we know how to parse the log - this depends both on the object type and the field name. E.g. status log for a protocol is closed, whereas status log for instrument is continuous *)
	defaultInputs=Switch[{#,myField},
		(* If we have a status log, it always has the same form for the critical fields *)
		{_,StatusLog},
		{1,2,2,2,True,False,{},Null},

		{_,QualificationResultsLog},
		{1,3,3,3,True,False,{},Null},

		{_,RestrictedLog},
		{1,2,2,2,True,False,{},Null},

		(* Group the output by weight and measurement type *)
		{_,MassLog},
		{1,2,3,{2,4},True,False,{},Null},

		{_,CountLog},
		{1,2,2,2,True,False,{},Null},

		{_,VolumeLog},
		{1,2,3,{2,4},True,False,{},Null},

		{_,LocationLog},
		{1,2,3,{3,4},False,False,{Out},Null},

		{_,ConnectionLog},
		{1,2,3,{3,4},False,False,{Disconnect},True},

		{_,WiringConnectionsLog},
		{1,2,3,{3,4},False,False,{Disconnect},True},

		{_,ContentsLog},
		{1,2,3,{3,4},False,False,{Out},True},

		{_,ProtocolLog},
		{1,2,3,3,False,False,{Exit},False},

		(* Otherwise, let's just guess *)
		{_,_},
		{1,2,2,2,True,False,{},Null}

	]&/@allData[[All,1]];


	(* Override the defaults with our options *)
	resolvedDateColumn=Switch[specifiedDateColumn,
		(* If automatic, use the default *)
		Automatic,
		#[[1]],

		(* Otherwise, use the specified one *)
		_,
		specifiedDateColumn
	]&/@defaultInputs;

	resolvedStatusColumn=Switch[specifiedStatusColumn,
		(* If automatic, use the default *)
		Automatic,
		#[[2]],

		(* Otherwise, use the specified one *)
		_,
		specifiedStatusColumn
	]&/@defaultInputs;

	resolvedSingleStatus=Switch[specifiedSingleStatus,
		(* If automatic, use the default *)
		Automatic,
		#[[5]],

		(* Otherwise, use the specified one *)
		_,
		specifiedSingleStatus
	]&/@defaultInputs;

	resolvedClosedLog=Switch[specifiedClosedLog,
		(* If automatic, use the default *)
		Automatic,
		#[[6]],

		(* Otherwise, use the specified one *)
		_,
		specifiedClosedLog
	]&/@defaultInputs;

	{resolvedIdentifierColumn,resolvedOutputColumn}=Transpose[Switch[{specifiedIdentifierColumn,specifiedOutputColumn},
		{Automatic,Automatic},
		{#[[3]],#[[4]]},

		{Automatic,_},
		{First[ToList[specifiedOutputColumn]],specifiedOutputColumn},

		{_,Automatic},
		{specifiedIdentifierColumn,specifiedIdentifierColumn},

		{_,_},
		{specifiedIdentifierColumn,specifiedOutputColumn}

	]&/@defaultInputs];

	resolvedInactiveStatuses=Switch[specifiedInactiveStatuses,
		Automatic,
		#[[7]],

		_,
		specifiedInactiveStatuses

	]&/@defaultInputs;


	(* Resolve if we should be counting the overlaps in a multi-status log *)
	resolvedCountOverlap=Switch[specifiedCountOverlap,
		Automatic,
		#[[8]],

		_,
		specifiedCountOverlap

	]&/@defaultInputs;

	(* Resolve the end date based on user input and deprecation *)
	resolvedEndDate=MapThread[
		Which[
			(* If user supplied the date, use it *)
			DateObjectQ[endDate], endDate,

			(* If we have a dead date after our first log entry, use it *)
			(* In the case of a malformed log we don't want to resolved to use a date before entries start *)
			DateObjectQ[#1] && MatchQ[#2,{__}] && TrueQ[#1>First[#2][[#3]]], #1,

			(* Otherwise, Null - we will use Now or log end based on ClosedLog *)
			True, Null
		]&,
		{deadDate,allData[[All,2]],resolvedDateColumn}
	];

	(* Throw an error if the log is not of the right format *)
	invalidFieldFormatQ=!MatchQ[#,Alternatives[{{__}..},{<|__|>..},{}]]&/@allData[[All,2]];

	If[Or@@invalidFieldFormatQ,
		Message[ParseLog::InvalidLogField,myField,PickList[myObjects,invalidFieldFormatQ]];
		Return[$Failed]
	];

	(* Parse the log *)
	MapThread[
		ParseLog[
			#1,
			#2,#3,#4,#5,#6,#7,#8,
			OutputFormat->outputFormat,Units->units,StartDate->startDate,EndDate->#9,CountOverlap->#10]&,
		{allData[[All,2]],resolvedDateColumn,resolvedStatusColumn,resolvedIdentifierColumn,resolvedOutputColumn,resolvedSingleStatus,resolvedClosedLog,resolvedInactiveStatuses,resolvedEndDate,resolvedCountOverlap}
	]
];

(* Get out of jail free *)
ParseLog[myObjects:{},myField:_,myOptions:OptionsPattern[ParseLog]]:={};

ParseLog[myObjects:Null,myField:_,myOptions:OptionsPattern[ParseLog]]:=Null;

ParseLog[myLog:{},dateColumn:_Integer,statusColumn:_Integer,myIdentifierColumn:_Integer,myOutputColumn:ListableP[_Integer],mySingleStatusQ:BooleanP,myClosedLogQ:BooleanP,myInactiveStatuses:ListableP[_Symbol]|{},myOptions:OptionsPattern[ParseLog]]:={};