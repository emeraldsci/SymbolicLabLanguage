(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Beta Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotBetaTesting*)
DefineOptions[PlotBetaTesting,Options:>{
	{StartDate->(Now - 3 Month),_DateObject,"The first time to consider protocols."},
	{SearchCriteria->True,_And|_Or|_Equal|_Unequal|_,"Additional elements to be included in the And used to find protocols to assess during beta testing (for instance specify protocols run on only certain instrument models)."},
	{Name->Null,Null|_String,"A short description of the change being beta tested."},
	{OutputFormat->Notebook,ListableP[(Notebook|SummaryTable|SummaryData)],"Indicates how the beta testing plots should be displayed."}
}];

PlotBetaTesting::TypeLookup="You must add your experiment to Experiment'Private'experimentFunctionTypeLookup (for experiments) or to ProcedureFramework'Private'experimentFunctionTypeLookup (for qualifications and maintenances) in order to use this function.";
PlotBetaTesting::MissingProcedureDefinitions="Procedure Definitions are missing. Please make sure ProcedureDefinitions package is correctly loaded. You can call ReloadPackage[\"ProcedureDefinitions'\"] to load this separately or load all of SLL'Dev' before using this function.";


PlotBetaTesting[experimentFunction_Symbol,ops:OptionsPattern[PlotBetaTesting]]:=Module[
	{namedObject, checkpointPercentage, safeOps, rawStartDate, outputFormat, userSearchCriteria, name, startDate, operatorData, stableSuites, unitTestPackets, protocols,
	rawProtocolType, protocolType, protocolQ, protocolOrQualQ, helpFileOptions, instrumentModels, instrumentKnown, searchResults,
	operatorModels, tickets, quals, maintenances, protocolDownload, listedTicketPackets, instrumentDownload, ticketPackets,
	rawTicketPackets, protocolQualMaintenancePackets, allSubprotocolPackets, protocolPackets, qualPackets, maintenancePackets, resourcePackets,
	resourceModelPackets, resourceProductInventoryPackets, resourceStockSolutionInventoryPackets, encounteredProcedures,
	encounteredSubprotocolProcedures, protocolTargetModelPackets, instrumentModelPackets, qualModelTypes, qualObjectTypes,
	allTypes, maintenanceTypes, qualTypes, allProtocolProcedures, allQualProcedures, allMaintenanceProcedures, allProcedures,
	allProcedureEventsEncountered, allProceduresEncountered, allUntestedProcedures,
	untestedProtocolProcedures, untestedQualProcedures, untestedMaintenanceProcedures, procedureCoverage, procedureCoverageTable,
	untestedProcedureTable, parserFunction, functionSet, executeFunctions, executeTasks, maxTestTime, unitTestCountsForFunctions,
	timePerTest, unitTestSummaryPlot, unitTestSummaries, unitTestTimesForFunctions, unitTestPassingPercentage, unitTestsPassingForFunctionsQ,
	unitTestPacketsForFunctions, stableSuite, passingFunctions, protocolData, meanProtocolStatusTimes, meanQualStatusTimes,
	meanMaintenanceStatusTimes, meanProtocolStatusTable, meanQualStatusTable,meanMaintenanceStatusTable, protocolsCreated,
	protocolCreationPlot, protocolStatusTallies,qualStatusTallies,maintenanceStatusTallies, currentProtocolStatusTable,currentQualStatusTable,
	currentMaintenanceStatusTable, completedProtocolPackets,numberOfCompletedProtocols,actualCheckpointsPerProtocol,estimatedCheckpointsPerProtocol,
	trueCheckpointTime, checkPointSummaryTuples,checkPointGroups,checkpointComparisons,checkpointComparisonTables, longTaskPackets,longTaskInfo,
	groupedLongTasks,longTaskTableData, longTaskTable, operatorPackets,protocolPermissionsLists,hasPermissionsQ,operatorPermissions,operatorCanRun,
	typesMissingPermissions, operatorPermissionsSummaryText,inventoryTuples, noInventories,inventoryData,noInventoryTable,inventoryTable,
	protocolVOQBooleans,dataVOQBooleans,allVOQPassing,voqSummaryTable,validDocsPercentage, validDocumentationTable,websiteAddress,
	statusCode,websiteLine,lastProtocols,directTickets,directTicketPackets,nonMonitoringPackets,currentTroubleshootingPercentage,
	unresolvedTicketTable,resolvedTicketTable,relevantTargetModelPackets, qualificationRequired, qualificationFrequency,qualScheduled,
	qualScheduleTable, maintenanceScheduled,maintenanceScheduleTable,qualResultPackets, sortedQualResultPackets,qualPassing, qualResultsTable,
	subprotocolTasks,subprotocolFunctions,subprotocolTroubleshooting,statusCaption,passingOverall, safeRound, summaryData,
	summaryTable,outputForms,statusFollowUpString,cloudFile,outputRules,experimentTestPacket,
	previewTestPacket, passingOptionsTestPacket, passingValidTestPacket, passingExperimentTests, passingPreviewTests, allData,
	voqBooleans, validDocumentationBooleans, passingOptionsTests, passingValidTests, previewExperiment, optionsExperiment,
	validExperiment, compilerFunction, experimentDefined, previewDefined, optionsDefined, validDefined, troubleshootingTimeline,
	titleName,fileName},

	Echo["Creating Beta Testing Notebook for "<>ToString[experimentFunction]ProgressIndicator[Appearance -> "Ellipsis"]];

	(* Make our own little NamedObject - since we know exactly what to expect it's faster *)
	namedObject[packet:PacketP[]]:=If[!MatchQ[Lookup[packet,Name],Null],
		Append[Lookup[packet,Type],Lookup[packet,Name]],
		Lookup[packet,Object]
	];

	(* Define constant indicating how close checkpoint estimates should be to actual checkpoints *)
	checkpointPercentage=20;

	(* Pull out our specified options *)
	safeOps=SafeOptions[PlotBetaTesting,ToList[ops]];
	{rawStartDate,outputFormat,userSearchCriteria,name}=Lookup[safeOps,{StartDate,OutputFormat,SearchCriteria,Name}];

	(* If given a day convert to an exact time to avoid comparison issues *)
	startDate=CurrentDate[rawStartDate,"Instant"];

	(* Find the protocol type associated with this experiment function so that we can search for existing options *)
	rawProtocolType=Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,experimentFunction,$Failed];

	(* Some protocols can return MSP or RSP. We don't want to consider these here since we are expecting the direct protocols to be tested *)
	protocolType=FirstCase[
		ToList[rawProtocolType],
		Except[Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]]],
		Object[Protocol, RoboticSamplePreparation]
	];

	(* If we're running on a protocol, qual or maintenance we'll show some different information/need to pull info from different sources *)
	protocolQ=MatchQ[protocolType,TypeP[Object[Protocol]]];
	protocolOrQualQ=MatchQ[protocolType,TypeP[{Object[Protocol],Object[Qualification]}]];

	(* Return early if we don't know the type of protocol created by this experiment since we don't be able to find associated protocols *)
	If[!MatchQ[protocolType,TypeP[]],
		Message[PlotBetaTesting::TypeLookup];
		Return[$Failed]
	];

	(* Look-up instruments from the help file *)
	(* Keep in mind that quals and maintenances won't have help files in this format *)
	helpFileOptions=Lookup[ECL`$HelpFileOptions,experimentFunction,{}];
	instrumentModels=Cases[Flatten[Lookup[helpFileOptions,InstrumentModels,{}],1],ObjectP[Model[Instrument]]];
	instrumentKnown=!MatchQ[instrumentModels,{}];

	Echo["Searching for related objects.."];
	(* Search for:
		- last unit test suite to find if experiment tests and co. are passing
		- recent protocols of type to find operations statistics, etc.
		- operator models to make sure protocol is listed in operator permissions
		- troubleshooting tickets associated with protocol
		- quals run on associated instrument (if relevant)
		- maintenance run on associated instrument (if relevant)
	*)
	searchResults=With[
		{
			(* Assemble criteria, not this is not being held as it would be directly inside search*)
			searchCriteria=Join[
				{
					(* Unit test suite: Get a full, completed run - we're assuming no one is running partial test runs of more than 3000 tests *)
					SLLVersion=="stable"&& Field[Length[UnitTests]] > 3000 && DateCreated>(startDate) && Status==Completed,
					(* Protocol *)
					DateCreated>(startDate) && userSearchCriteria,
					(* Operator Models *)
					ProtocolPermissions!=Null,
					(* Tickets *)
					SourceProtocol[Type]==protocolType && DateCreated>(startDate)
				},
				If[instrumentKnown,
					{
						Target[Model]==Alternatives@@instrumentModels && DateCreated>(startDate),
						Target[Model]==Alternatives@@instrumentModels && DateCreated>(startDate)
					},
					{}
				]
			]
		},
		Search[
			Join[
				{Object[UnitTest,Suite],protocolType,Model[User,Emerald,Operator],Object[SupportTicket,Operations]},
				If[instrumentKnown,{Object[Qualification],Object[Maintenance]},{}]
			],
			searchCriteria
		]
	];

	(* Assign names to our search results *)
	{stableSuites,protocols,operatorModels,tickets,quals,maintenances}=If[instrumentKnown,
		searchResults,
		Join[searchResults,{{},{}}]
	];

	(* Find the most recent stable run *)
	stableSuite = Last[stableSuites,Null];

	Echo["Downloading related objects.."];
	(* Download test suite data, protocol data, op data, ticket data and qual/maintenance data *)
	{{{unitTestPackets}},protocolDownload,operatorData,listedTicketPackets,instrumentDownload}=Quiet[Download[
		{
			{stableSuite},
			Join[protocols,quals,maintenances],
			operatorModels,
			tickets,
			instrumentModels
		},
		{
			{Packet[UnitTests[Function,Status,EmeraldTestSummary]]},
			{
				Packet[Data,DateCreated,DateCompleted,Status,Checkpoints,CheckpointProgress,Result,Subprotocols,ProtocolSpecificTickets],
				Packet[Subprotocols[DateStarted,DateCompleted]],

				(* Resource checking *)
				Packet[SubprotocolRequiredResources[Rent]],
				Packet[SubprotocolRequiredResources[Models][[1]][Name]],
				Packet[SubprotocolRequiredResources[Models][[1]][Products][Inventories][{Status,ReorderAmount,ReorderThreshold}]],
				Packet[SubprotocolRequiredResources[Models][[1]][Inventories][{Status,ReorderAmount,ReorderThreshold}]],

				(* Procedure Logs *)
				(* Download for test coverage information. Get subprotocols to find when our type as run as a sub in one of its quals *)
				(* This assumes we don't have any relevant deeper subs *)
				Packet[ProcedureLog[Protocol,Procedure,BranchObjects,ProtocolStatus]],
				Packet[Subprotocols[ProcedureLog][Protocol,Procedure,BranchObjects,ProtocolStatus]],

				(* For quals and maintenances, see if they're scheduled *)
				Packet[Target[Model][Name,QualificationFrequency,MaintenanceFrequency,QualificationRequired]]
			},
			{Packet[ProtocolPermissions,QualificationLevel,Name]},
			{Packet[Resolved,Headline,Description,SupportTicketSource,SourceProtocol]},
			{
				Packet[Name,QualificationFrequency,MaintenanceFrequency,QualificationRequired]
			}
		}
	],{Download::NotLinkField,Download::FieldDoesntExist,Download::Part}];

	(* Flatten out our ticket and protocol data *)
	rawTicketPackets=listedTicketPackets[[All,1]];
	protocolQualMaintenancePackets=protocolDownload[[All,1]];
	allSubprotocolPackets=protocolDownload[[All,2]];

	(* We're going to call our type associated with the input function the protocol *)
	(* Technically this could be a qualification or a maintenance *)
	protocolPackets=Cases[protocolQualMaintenancePackets,ObjectP[protocolType]];

	(* Get associated quals and maintenances that have run on the instruments listed in the help file *)
	qualPackets=Cases[protocolQualMaintenancePackets,ObjectP[Object[Qualification]],{}];
	maintenancePackets=Cases[protocolQualMaintenancePackets,ObjectP[Object[Maintenance]],{}];

	(* Pull out resource information from all protocols, quals and maintenance *)
	resourcePackets=protocolDownload[[All,3]];
	resourceModelPackets=protocolDownload[[All,4]];
	resourceProductInventoryPackets=protocolDownload[[All,5]];
	resourceStockSolutionInventoryPackets=protocolDownload[[All,6]];

	(* Extract all procedures we went down *)
	encounteredProcedures=Flatten[protocolDownload[[All,7]],1];
	encounteredSubprotocolProcedures=Flatten[protocolDownload[[All,8]],2];

	protocolTargetModelPackets=protocolDownload[[All,9]];

	(* Grab our data objects *)
	protocolData=Lookup[protocolPackets,Data,{}];

	(* Get instrument model packets with qual and maintenance frequency *)
	instrumentModelPackets=instrumentDownload[[All,1]];

	ticketPackets=Select[rawTicketPackets, MemberQ[Lookup[protocolQualMaintenancePackets,Object], Lookup[#, SourceProtocol][Object]] &];

	(* Get models of quals and maintenances we're set to run periodically *)
	qualModelTypes=Download[
		Flatten[Lookup[instrumentModelPackets,{MaintenanceFrequency,QualificationFrequency},{}],2][[All,1]],
		Type
	];

	(* Convert qual/maintenance model types to object types *)
	qualObjectTypes=Object@@#&/@qualModelTypes;

	(* Get a flat list of all qual and maintenance types *)
	(* 'quals' and 'maintenances' come from finding Object[Qualification/Maintenance] which have their Target set to one our known instrument models *)
	qualTypes=DeleteDuplicates[Join[Download[quals,Type],Cases[qualObjectTypes,TypeP[Object[Qualification]],{}]]];
	maintenanceTypes=DeleteDuplicates[Join[Download[maintenances,Type],Cases[qualObjectTypes,TypeP[Object[Maintenance]],{}]]];

	allTypes=Join[{protocolType},qualTypes,maintenanceTypes];

	(* -- Procedure Log Parsing -- *)

	Echo["Checking Procedure Coverage.."];

	(* For each type find all procedures it could encounter will running in Engine *)
	allProtocolProcedures=procedureTree[protocolType];
	allQualProcedures=Flatten[procedureTree[#]&/@DeleteDuplicates[qualTypes],1];
	allMaintenanceProcedures=Flatten[procedureTree[#]&/@DeleteDuplicates[maintenanceTypes],1];
	allProcedures=DeleteDuplicates[Join[allProtocolProcedures,allQualProcedures,allMaintenanceProcedures]];

	(* Get all procedures we've actually tested in Engine *)
	allProcedureEventsEncountered=Join[encounteredProcedures,Flatten[encounteredSubprotocolProcedures,1]];

	(* Not every event has an associated procedure, get only those that do *)
	allProceduresEncountered=DeleteCases[DeleteDuplicates[Lookup[allProcedureEventsEncountered, Procedure, Nothing]],Null];

	(* Figure out this procedures haven't been tested in Engine *)
	{untestedProtocolProcedures,untestedQualProcedures,untestedMaintenanceProcedures}=Map[
		Complement[#,allProceduresEncountered]&,
		{allProtocolProcedures,allQualProcedures,allMaintenanceProcedures}
	];

	allUntestedProcedures = DeleteDuplicates[Join[untestedProtocolProcedures, untestedQualProcedures, untestedMaintenanceProcedures]];

	(* Calculate coverage *)
	procedureCoverage = If[SameQ[allProcedures, {}],
		"N/A",
		100 Percent * N[1 - Length[allUntestedProcedures] / Length[allProcedures]]
	];

	(* Make our plots, showing information differently if we are a qual *)
	{procedureCoverageTable,untestedProcedureTable}=If[protocolQ,
		{
			PlotTable[
				{{
					Length[allProtocolProcedures],
					Length[allQualProcedures],
					Length[allMaintenanceProcedures],
					Length[allProcedures],
					Length[allProcedures] - Length[allUntestedProcedures],
					procedureCoverage
				}},
				Round->1,
				TableHeadings->{Automatic,{"Protocol Subprocedures","Qualification Subprocedures","Maintenance Subprocedures","All Subprocedures","Subprocedures Tested","Coverage Percentage"}},
				Title->"Subprocedure Testing Coverage"
			],
			PlotTable[
				Transpose[PadRight[{untestedProtocolProcedures,untestedQualProcedures,untestedMaintenanceProcedures},Automatic,""]],
				TableHeadings->{Automatic,{"Protocol Subprocedures","Qualification Subprocedures","Maintenance Subprocedures"}},
				Title->"Untested Subprocedures"
			]
		},
		{
			PlotTable[
				{{
					Length[allProtocolProcedures],
					Length[allProcedures] - Length[allUntestedProcedures],
					procedureCoverage
				}},
				Round->1,
				TableHeadings->{Automatic,{"Subprocedures","Subprocedures Tested","Coverage Percentage"}},
				Title->"Subprocedure Testing Coverage"
			],
			PlotTable[
				Transpose[{untestedProtocolProcedures}],
				TableHeadings->{Automatic,{"Subprocedures"}},
				Title->"Untested Subprocedures"
			]
		}
	];

	(* -- Unit Testing -- *)

	Echo["Checking Unit Test results.."];

	(* Expected Sister Functions Defined *)
	previewExperiment=ToExpression[ToString[experimentFunction]<>"Preview"];
	optionsExperiment=ToExpression[ToString[experimentFunction]<>"Options"];
	validExperiment=ToExpression["Valid"<>ToString[experimentFunction]<>"Q"];

	(* Get compiler and parser if we have them *)
	compilerFunction=Lookup[ECL`CompilerLookup,protocolType,Nothing];
	parserFunction=Lookup[ECL`ParserLookup,protocolType,Nothing];

	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	executeTasks=Flatten[findTasks[#,TaskType->"Execute"]&/@allProcedures,1];
	executeFunctions=ReleaseHold/@Lookup[Lookup[executeTasks,"Args",{}],"Function",{}];

	(* Make our master list of expected functions - quals and maintenances don't have sister functions *)
	functionSet=DeleteDuplicates[
		Join[
			{experimentFunction,compilerFunction,parserFunction},
			executeFunctions,
			If[protocolQ,
				{previewExperiment,optionsExperiment,validExperiment},
				{}
			]
		]
	];

	(* Individual tests shouldn't take more than this to run *)
	maxTestTime=2 Minute;

	(* Find Unit Test Packets for our functions *)
	unitTestPacketsForFunctions=Map[
		Function[func,SelectFirst[unitTestPackets,MatchQ[Lookup[#,Function],func]&,<||>]],
		functionSet
	];

	(* Passing Unit Tests? *)
	unitTestsPassingForFunctionsQ=Map[
		(!NullQ[#] && MatchQ[stableSuites,{ObjectP[]..}] && MatchQ[Lookup[#,Status],Passed])&,
		unitTestPacketsForFunctions
	];

	(* Get percent of functions with all tests passing *)
	unitTestPassingPercentage=100Percent*Count[unitTestsPassingForFunctionsQ,True]/Length[unitTestsPassingForFunctionsQ];

	(* Lookup test summaries for our functions *)
	unitTestSummaries=ImportCloudFile/@Lookup[unitTestPacketsForFunctions,EmeraldTestSummary,Null];

	(* Overall time to run each functions tests *)
	unitTestTimesForFunctions=If[!NullQ[#],#[RunTime],"N/A"]&/@unitTestSummaries;

	(* Number of tests for each function *)
	unitTestCountsForFunctions=If[!NullQ[#],#[TotalTests],"N/A"]&/@unitTestSummaries;

	(* Average to run a single test for each function *)
	timePerTest=MapThread[
		If[MatchQ[#1,"N/A"],"N/A",#1/#2]&,
		{unitTestTimesForFunctions,unitTestCountsForFunctions}
	];

	(* Summary table *)
	unitTestSummaryPlot=PlotTable[
		failedSymbolStyle[Transpose[{functionSet,unitTestsPassingForFunctionsQ,unitTestTimesForFunctions,unitTestCountsForFunctions,timePerTest,Lookup[unitTestPacketsForFunctions,Object,"No Test Found"]}]],
		Round->True,
		ShowNamedObjects->False,
		TableHeadings->{Automatic,{"Function","Tests Passing?","Total Test Time","# of Tests","Time per Test","Unit Test Run"}},
		Title->"Unit Test Summary"
	];

	(* -- Protocol Statuses -- *)

	Echo["Checking protocols run.."];

	(* Determine how much time our protocols have spent in different states during operation *)
	(* Remove statuses that aren't related to actual operation of the protocol *)
	{meanProtocolStatusTimes,meanQualStatusTimes,meanMaintenanceStatusTimes}=Map[
		Merge[KeyDrop[ParseLog[#,StatusLog],{InCart,Canceled,Aborted}],Mean]&,
		{protocols,quals,maintenances}
	];

	(* Make a separate summary table for protocols, quals and maintenances in these operation statuses *)
	{meanProtocolStatusTable,meanQualStatusTable,meanMaintenanceStatusTable}=MapThread[
		If[MatchQ[#1,<||>],
			Style["No processing/completed "<>#2<>" found",Bold,Red],
			PlotTable[
				{Values[#1]},
				TableHeadings->{Automatic,Keys[#1]},
				Round->True,
				Title->"Average Time in Status (for "<>Capitalize[#2]<>")"
			]
		]&,
		{
			{meanProtocolStatusTimes,meanQualStatusTimes,meanMaintenanceStatusTimes},
			{"protocols","qualifications","maintenances"}
		}
	];

	(* Check when protocols are getting created *)
	protocolsCreated=Lookup[protocolPackets,DateCreated,{}];
	protocolCreationPlot=DateHistogram[protocolsCreated,PlotLabel->"# Created"];

	(* Tally the current Status for our protocols *)
	(* This lets us see # of protocols completed, enqueued, etc. *)
	{protocolStatusTallies,qualStatusTallies,maintenanceStatusTallies}=Map[
		Tally[Lookup[#,Status,{}]]&,
		{protocolPackets,qualPackets,maintenancePackets}
	];

	(* Make a separate summary table for current states of protocols, quals and maintenances *)
	{currentProtocolStatusTable,currentQualStatusTable,currentMaintenanceStatusTable}=MapThread[
		If[MatchQ[#1,{}],
			Style["No "<>#2<>" found",Bold,Red],
			PlotTable[
				#1,
				Title->Capitalize[#2]<>" in a given state:",
				TableHeadings -> {Automatic,{"Status","Number in Status"}}
			]
		]&,
		{
			{protocolStatusTallies,qualStatusTallies,maintenanceStatusTallies},
			{"protocols","qualifications","maintenance"}
		}
	];

	(* - Checkpoint Comparisons - *)

	(* Get our completed protocols *)
	completedProtocolPackets=Select[protocolPackets,MatchQ[Lookup[#,Status],Completed]&];
	numberOfCompletedProtocols=Length[completedProtocolPackets];

	(* Get actual checkpoint times and expected checkpoint times *)
	actualCheckpointsPerProtocol=Lookup[completedProtocolPackets,CheckpointProgress,{}];
	estimatedCheckpointsPerProtocol=Lookup[completedProtocolPackets,Checkpoints,{}];

	(* Define helper: trueCheckpointTime, remove time in subprotocols from checkpoint time *)
	trueCheckpointTime[packet:PacketP[ProtocolTypes[]],checkpointStart_,checkpointEnd_]:=Module[
		{subprotocols,subprotocolPackets,subsInCheckpoint,subEnds},

		(* Get info for any subprotocols for this protocol *)
		subprotocols=Lookup[packet,Subprotocols];
		subprotocolPackets=Experiment`Private`fetchPacketFromCache[#,Flatten[allSubprotocolPackets]]&/@subprotocols;

		(* Find any subs that started within our current checkpoint *)
		subsInCheckpoint=Select[subprotocolPackets,(checkpointStart < Lookup[#,DateStarted] < checkpointEnd)&];

		(* We expected all subs end in this checkpoint, but just in case they don't use checkpoint end *)
		subEnds=Min[#,checkpointEnd]&/@Lookup[subsInCheckpoint,DateCompleted,{}];

		checkpointEnd-checkpointStart-Total[subEnds-Lookup[subsInCheckpoint,DateStarted,{}]]
	];

	(* See how closely our checkpoint estimates match with what actually happened *)
	checkPointSummaryTuples=MapThread[
		Function[{actualTimes,expectedTimes,completedProtocolPacket},
			(* Actual stored as: {Name, Start, End}; Estimates as {Name, Time, Description, Operator} *)
			If[MatchQ[actualTimes[[All,1]],expectedTimes[[All,1]]],
				{
					(* Checkpoint Name *)
					expectedTimes[[All,1]],
					(* Estimated Time *)
					expectedTimes[[All,2]],
					(* Time over estimate: (actual end - actual start)* - estimated time *)
					(* We correct for any subs that happened since these shouldn't count against our estimates *)
					trueCheckpointTime[completedProtocolPacket, actualTimes[[All,2]], actualTimes[[All,3]]] - expectedTimes[[All,2]],
					(* Protocol Object *)
					Lookup[completedProtocolPacket,Object]
				},
				(* It's possible checkpoints changed during run but this should only be if we're under active development *)
				{$Failed,$Failed,$Failed,Lookup[completedProtocolPacket,Object]}
			]
		],
		{actualCheckpointsPerProtocol,estimatedCheckpointsPerProtocol,completedProtocolPackets}
	];

	(* Gather up our found checkpoint tuples which have the same name - e.g. all instances of 'Picking Resources' *)
	checkPointGroups=GatherBy[checkPointSummaryTuples,First];

	(* Get our average estimated times and our average actual times *)
	checkpointComparisons=Map[
		If[!MatchQ[#,{{$Failed..,ObjectP[]}..}],
			{
				(* All checkpoints in this group have the same name, pull them out from out first tuple *)
				#[[1,1]],
				Convert[Mean/@Transpose[#[[All,2]]],Minute],
				Convert[Mean/@Transpose[#[[All,3]]],Minute]
			},
			Nothing
		]&,
		checkPointGroups
	];

	(* Compare checkpoint accuracy *)
	(* Each checkpointComparision in our mapped list has {checkpoint names, expected times, times above/below} *)
	checkpointComparisonTables=Map[
		PlotTable[
			Rest[#],
			TableHeadings->{{"Avg. Expected Time","Time Above Estimate"},First[#]},
			Round->True,Title->"Checkpoint Comparisons"
		]&,
		checkpointComparisons
	];

	(* - Long tasks - *)

	Echo["Checking for long tasks.."];

	(* Pull any tickets marked as long tasks out *)
	longTaskPackets=Select[ticketPackets,MatchQ[Lookup[#,SupportTicketSource],LongTask]&];

	(* Parse out info about the long task from the ticket description - ultimately will move this to fields *)
	(* In the form: {{task type, procedure, task ID}..}*)
	longTaskInfo=MapThread[
		{
			StringReplace[#2,___~~"\"TaskType\" -> \""~~type:WordCharacter..~~___:>type],
			StringReplace[#2,___~~"\"Procedure\" -> \""~~procedure:(WordCharacter|WhitespaceCharacter|DigitCharacter|"-"|"_")..~~___:>procedure],
			(* ID may be Null, need to remove leading quotation mark *)
			StringReplace[#2,___ ~~ "\"ID\" -> " ~~ id : ("\"" | WordCharacter | "-") .. ~~ ___ :> StringTrim[id, "\""]],
			#1
		}&,
		{Lookup[longTaskPackets,Object,{}],Lookup[longTaskPackets,Description,{}]}
	];

	(* Gather up by task ID and type (for ID null case) so we can see if we're having a repeated issue with a particular task *)
	groupedLongTasks=GatherBy[longTaskInfo,#[[{1,3}]]&];

	(* Convert our long task data into one line per task ID - since we've grouped by ID lots of info will be the same and we can just take first entry *)
	longTaskTableData=Map[
		{
			(* Number of times we've seen this task ID show up as a long task *)
			Length[#],
			(* Task Type *)
			#[[1,1]],
			(* Procedure *)
			#[[1,2]],
			(* Task ID, with tooltip to see full task *)
			tooltipStyle[Tooltip[#[[1,3]],findTasks[allProcedures,ID->#[[1,3]]]]],
			(* Long task tickets *)
			#[[All,4]]
		}&,
		groupedLongTasks
	];

	(* Final long task summary table *)
	longTaskTable=If[MatchQ[longTaskTableData,{}],
		Style["No long tasks found",Bold],
		PlotTable[
			longTaskTableData,
			TableHeadings->{Automatic,{"# of Occurances","Task Type","Procedure","ID","Long Task Tickets"}},
			Title->"Long Tasks"
		]
	];

	(* -- Operator Permissions -- *)

	Echo["Checking operator permissions.."];

	(* Sort operator models by their level *)
	operatorPackets=SortBy[operatorData[[All,1]],Lookup[#,QualificationLevel]&];

	(* Lookup the protocols each operator model can do *)
	protocolPermissionsLists=Lookup[operatorPackets,ProtocolPermissions];

	(* See which operators have permissions for all types of interest *)
	hasPermissionsQ=Map[
		Function[
			type,
			MemberQ[#,type]&/@protocolPermissionsLists
		],
		allTypes
	];

	(* Operator Permission summary table *)
	operatorPermissions=MapThread[
		PlotTable[
			Transpose[{namedObject/@operatorPackets,#2}],
			TableHeadings->{Automatic,{"Operator Level","Able to Run Protocol?"}},
			Title->ToString[#1]<>" Permissions"
		]&,
		{allTypes,hasPermissionsQ}
	];

	operatorCanRun=MemberQ[#,True]&/@hasPermissionsQ;

	typesMissingPermissions=PickList[allTypes,operatorCanRun,False];

	operatorPermissionsSummaryText=If[MatchQ[typesMissingPermissions,{}],
		Style["At least one operator level has permissions to run all types:",Bold],
		Style["Not all types can be run in the lab because no operator levels have permission to run them. Check: "<>StringRiffle[typesMissingPermissions,", "],Bold,Red]
	];

	(* -- Inventory Tracking -- *)

	Echo["Checking for standing orders.."];

	(* Pull out correct inventory object - stock solution or product - based on resource model and form into tuples *)
	(* In the form {{requested model, inventory packet, rent bool}..} *)
	inventoryTuples=MapThread[
		Function[{resourcePacket,modelPacket,productInventoryPackets,ssInventoryPacket},
			(* We have operator, instrument, etc. resources in our source list resulting in $Failed *)
			If[MatchQ[modelPacket,$Failed],
				Nothing,
				{
					namedObject[modelPacket],
					(* Get our first real inventory object - we might have multiple products *)
					Module[{packets},
						packets=Cases[Flatten[{productInventoryPackets,ssInventoryPacket},2],PacketP[]];
						FirstCase[packets, KeyValuePattern[{Status -> Active}], First[packets,Null]]
					],
					Lookup[resourcePacket,Rent]
				}
			]
		],
		{Join@@resourcePackets,Join@@resourceModelPackets,Join@@resourceProductInventoryPackets,Join@@resourceStockSolutionInventoryPackets}
	];

	(* Get models which don't have associated inventory objects, keep our name and rent boolean, dropping the non-existent inventory *)
	(* Remove water resources since we don't need inventory for them *)
	noInventories=DeleteDuplicates[Cases[inventoryTuples,{Except[WaterModelP],Null,_}][[All,{1,3}]]];

	(* For models which do have inventory requests, look up key info from the inventory *)
	inventoryData=Map[
		{#[[1]],Lookup[#[[2]],Status],Lookup[#[[2]],ReorderAmount],Lookup[#[[2]],ReorderThreshold],Lookup[#[[2]],Object]}&,
		DeleteDuplicates[Cases[inventoryTuples,{_,Except[Null],_}]]
	];

	(* Summary table for requested models which don't have associated inventory (likely bad) *)
	noInventoryTable = If[MatchQ[noInventories,{}],
		Style["No resources without standing orders were found",Bold],
		PlotTable[
			failedSymbolStyle[DeleteDuplicates[SortBy[noInventories/.Null->False,Last]]],
			TableHeadings->{Automatic,{"Model Used","Rented?"}},
			Title->"Objects With No Standing Orders"
		]
	];

	(* Summary table for requested models that do have inventory set-up (good!) *)
	inventoryTable = If[MatchQ[inventoryData,{}],
		Style["No resources with standing orders were found",Red,Bold],
		PlotTable[
			failedSymbolStyle[SortBy[inventoryData,#[[2]]&],Inactive],
			Title->"Objects With Standing Orders",
			TableHeadings->{Automatic,{"Model Used","Standing Order Status","Reorder Amount","Reorder Threshold","Inventory Object"}}
		]
	];

	(* -- VOQ -- *)

	Echo["Checking object validity.."];

	(* Check VOQ for our protocol type - quiet any errors and consider the check $Failed since VOQ should never throw errors *)
	protocolVOQBooleans=Quiet[
		Check[
			ValidObjectQ[protocols,OutputFormat->SingleBoolean],
			$Failed
		]
	];

	(* Check VOQ for our protocols' data. Again we don't expect any errors and consider this $Failed *)
	allData=Flatten[protocolData,2];
	dataVOQBooleans=Quiet[
		Check[
			ValidObjectQ[allData,OutputFormat->SingleBoolean],
			$Failed
		]
	];

	(* See if all VOQ are passing for global summary *)
	allVOQPassing=MatchQ[{protocolVOQBooleans,dataVOQBooleans},{True..}];

	(* General VOQ summary table *)
	voqSummaryTable=PlotTable[
		failedSymbolStyle[{{protocolVOQBooleans,dataVOQBooleans},{Length[protocols],Length[allData]}},False|$Failed],
		Title->"ValidObjectQ Results",
		TableHeadings->{{"Result","Number of Objects"},{ToString[protocolType],"Data"}}
	];

	(* -- ValidDocumentationQ -- *)

	Echo["Checking documentation.."];

	(* Check if all our identified functions have valid docs *)
	validDocumentationBooleans=ECL`ValidDocumentationQ[functionSet,OutputFormat->Boolean];

	(* See what percent of docs are passing for global summary *)
	validDocsPercentage=100 Percent * N[Count[validDocumentationBooleans,True]/Length[validDocumentationBooleans]];

	(* Make VDQ summary table *)
	validDocumentationTable=PlotTable[
		Transpose[{functionSet,failedSymbolStyle[validDocumentationBooleans]}],
		TableHeadings->{Automatic,{"Function","Docs Valid?"}},
		Title->"Documentation Passing?"
	];

	(*Check if the docs can be found at the standard web address *)
	websiteAddress="https://www.emeraldcloudlab.com/helpfiles/"<>ToLowerCase[ToString[experimentFunction]];

	statusCode=URLRead[HTTPRequest[websiteAddress]]["StatusCode"];

	websiteLine=If[MatchQ[statusCode,404],
		Style["Website documentation is not synced.",Red,Bold],
		Button["Web Help File", SystemOpen[websiteAddress]]
	];

	(* -- Troubleshooting -- *)

	Echo["Checking troubleshooting.."];

	(* Calculate troubleshooting percentage for the last 3 completed protocols, excluding monitoring tickets *)
	lastProtocols=Take[Reverse[completedProtocolPackets],UpTo[3]];
	directTickets=Flatten[Lookup[lastProtocols,ProtocolSpecificTickets],1];
	directTicketPackets=Cases[ticketPackets,ObjectP[directTickets]];
	nonMonitoringPackets=Select[directTicketPackets,!MatchQ[Lookup[#,SupportTicketSource],Alternatives@@MonitoringTicketTypes]&];
	currentTroubleshootingPercentage=If[Length[lastProtocols]==0,
		"N/A",
		100 Percent * N[Length[nonMonitoringPackets]/Length[lastProtocols]]
	];

	(* Plot # of troubleshooting tickets per protocol over time *)
	troubleshootingTimeline=Quiet[
		Check[
			PlotSupportTimeline[protocolType,startDate,Now,SearchCriteria->userSearchCriteria,Display->Both],
			Style["No recent protocols found",Bold]
		],
		PlotSupportTimeline::NoProtocols
	];

	(* Create tables of resolved and unresolved TS tickets *)
	unresolvedTicketTable=Quiet[
		Replace[TroubleshootingTable[protocols,startDate,Now,Resolved->False],{}->Style["No tickets found",Bold]],
		TroubleshootingTable::NoTicketsFound
	];

	unresolvedTicketDisplay=If[MatchQ[unresolvedTicketTable,Null],
		Style["No unresolved tickets found",Bold],
		unresolvedTicketTable
	];

	resolvedTicketTable=Quiet[
		Replace[TroubleshootingTable[protocols,startDate,Now,Resolved->True],{}->Style["No tickets found",Bold]],
		TroubleshootingTable::NoTicketsFound
	];

	resolvedTicketDisplay=If[MatchQ[resolvedTicketTable,Null],
		Style["No resolved tickets found",Bold],
		resolvedTicketTable
	];

	(* -- Qualification and Maintenance -- *)

	Echo["Checking associated qualifications and maintenances.."];

	(* Not we won't have any of this information if we are running PlotBetaTesting for a qual or maintenance type or if we couldn't find instruments in the experiment help file *)
	relevantTargetModelPackets=If[protocolQ,
		instrumentModelPackets,
		DeleteDuplicates[Cases[protocolTargetModelPackets,PacketP[Model]]]
	];

	qualificationRequired=Lookup[relevantTargetModelPackets,QualificationRequired,{}];
	qualificationFrequency=Lookup[relevantTargetModelPackets,QualificationFrequency,{}];

	(* See if we have any quals scheduled for our master summary table *)
	(* We're assuming each instrument needs only one call scheduled *)
	qualScheduled=And@@MapThread[
		(MatchQ[#1,False]||MemberQ[#2[[All,2]],TimeP])&,
		{qualificationRequired,qualificationFrequency}
	];

	(* Plot the scheduling info for quals if we have any *)
	qualScheduleTable=If[MatchQ[relevantTargetModelPackets,{}],
		Style["No linked instruments found", Bold],
		PlotTable[
			Transpose@{
				Lookup[relevantTargetModelPackets,Object],
				qualificationRequired,
				If[MatchQ[#,{}],None,PlotTable[#,Round->True]]&/@Replace[qualificationFrequency,{},{1}]
			},
			TableHeadings->{Automatic,{"Object","QualificationRequired","Qualifications"}},
			Title->"Scheduled Qualifications"
		]
	];

	(* See if we have any maintenance scheduled for our master summary table *)
	(* We only care if this is running for a Maintenance since we otherwise can't say if maintenance is required *)
	maintenanceScheduled=MatchQ[Flatten[Lookup[relevantTargetModelPackets,MaintenanceFrequency,{}][[All,All,2]],1],{TimeP..}];

	(* Plot the scheduling info for maintenances if we have any *)
	maintenanceScheduleTable=If[MatchQ[relevantTargetModelPackets,{}],
		Style["No linked instruments found", Bold],
		PlotTable[
			Transpose@{
				Lookup[relevantTargetModelPackets,Object],
				failedSymbolStyle[If[MatchQ[#,{}],None,PlotTable[#,Round->True]],None]&/@Replace[Lookup[relevantTargetModelPackets,MaintenanceFrequency],{},{1}]
			},
			TableHeadings->{Automatic,{"Object","Maintenances"}},
			Title->"Scheduled Maintenance"
		]
	];

	(* If we're running this for an experiment find its associated qual, otherwise act directly on our protocol packets *)
	qualResultPackets=If[protocolQ,
		Select[qualPackets,MatchQ[Lookup[#,DateCompleted],GreaterP[startDate]]&],
		completedProtocolPackets
	];

	(* Order by date completed *)
	sortedQualResultPackets=SortBy[qualResultPackets,Lookup[#,DateCompleted]&];

	(* Qual is either not required or last qual must be marked as a Pass *)
	qualPassing=MatchQ[qualificationRequired,False]||MatchQ[Lookup[Last[sortedQualResultPackets,<||>],Result],Pass];

	(* Summary table of qual results *)
	qualResultsTable=If[MatchQ[sortedQualResultPackets,{}],
		failedSymbolStyle["No Qualification Results",_],
		PlotTable[
			failedSymbolStyle[Lookup[sortedQualResultPackets,{DateCompleted,Object,Result}],Fail],
			TableHeadings->{Automatic,{"Date Completed","Qualification","Result"}},
			Title->"Qualification Results"
		]
	];

	(* -- Base Protocol TS Rates -- *)

	Echo["Checking subprotocol troubleshooting.."];

	(* For quals and maintenances we want to understand if there are key subprotocols with TS problems *)
	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	subprotocolTasks=Flatten[findTasks[#,TaskType->"Subprotocol"]&/@allProtocolProcedures,1];
	subprotocolFunctions=DeleteDuplicates[ReleaseHold/@Lookup[Lookup[subprotocolTasks,"Args",{}],"ExperimentFunction",{}]];

	subprotocolTroubleshooting=If[protocolQ,
		Null,
		PlotSupportTimeline[Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,#,$Failed],Display->Both]&/@subprotocolFunctions
	];

	(*  -- Results -- *)

	passingOverall=And[
		EqualQ[validDocsPercentage,100Percent],
		EqualQ[unitTestPassingPercentage,100Percent],
		allVOQPassing,
		numberOfCompletedProtocols>=10,
		procedureCoverage>70Percent,
		If[protocolOrQualQ,qualScheduled,True],
		If[protocolOrQualQ,qualPassing,True],
		If[!protocolOrQualQ,maintenanceScheduled,True],
		EqualQ[currentTroubleshootingPercentage,0 Percent]
	];

	(* Define Helper: safeRound - Ignore any non unit values *)
	(* We may end up with the occasional N/A that we want to ignore *)
	safeRound[value:UnitsP[]]:=Round[value];
	safeRound[value:UnitsP[],increment_]:=Round[value,increment];
	safeRound[value_]:=value;
	safeRound[value_,increment_]:=value;

	summaryData=Transpose@{
		{failedSymbolStyle[safeRound[validDocsPercentage],LessP[100 Percent]],100 Percent},
		{failedSymbolStyle[safeRound[unitTestPassingPercentage],LessP[100 Percent]],100 Percent},
		{failedSymbolStyle[allVOQPassing],True},
		{failedSymbolStyle[numberOfCompletedProtocols,LessP[10]],">=10"},
		{failedSymbolStyle[safeRound[procedureCoverage],LessP[70 Percent]],">=70%"},
		If[protocolOrQualQ, {failedSymbolStyle[qualScheduled],True}, Nothing],
		If[protocolOrQualQ, {failedSymbolStyle[qualPassing],True},Nothing],
		If[!protocolOrQualQ, {failedSymbolStyle[maintenanceScheduled],True}, Nothing],
		{failedSymbolStyle[safeRound[currentTroubleshootingPercentage],GreaterP[0 Percent]],"0%"},
		{resultSymbolStyle[passingOverall],True}
	};

	summaryTable=betaTestSummaryTable[{summaryData},{experimentFunction},{name}];

	outputForms=ToList[outputFormat];

	statusCaption="Consider the average time the relevant protocols, qualifications or maintenances spent in different processing states. OperatorProcessing represents the time operators were directly working on the protocol. If this time exceeds 24 hours verify that the procedure does not have any unnecessary steps or subprotocol calls, tasks that effectively map download, long running executes or repeated long tasks. OperatorStart and OperatorReady represent time when operators are either unavailable or unable to enter the protocol due to resource constraints.";

	statusFollowUpString="A high number of protocols aborted or in shipping materials suggests there may be problems suggest a closer look at the troubleshooting tickets or the inventory objects may be required.";

	cloudFile=If[MemberQ[outputForms,Notebook],
		Module[{},
			fileName=ToString[experimentFunction]<>" Beta Testing Report "<>StringReplace[DateString[],":"->"_"];

			ExportReport[fileName,{
				{Title,"Beta Testing Report for "<>functionWithName[experimentFunction,name]},
				(* Include the search criteria if something was actually specified (defaults to True - i.e. no additional conditions) *)
				If[!MatchQ[userSearchCriteria,True],
					{Subsubsection,"Protocol Search Criteria: "<>ToString[userSearchCriteria]},
					Nothing
				],
				summaryTable,
				{Section,"Function Validity Checks"},
					{Subsection,"Documentation Checks"},
						validDocumentationTable,
						captionStyle["ValidDocumentationQ is run on the experiment, its sister functions and functions used in the procedure. Run ValidDocumentationQ with Verbose->Failures on any failing functions to learn the causes of the failures."],
					{Subsection,"Help File"},
						websiteLine,
						captionStyle["Documentation should be synced to the website by calling RebuildDocs. The helpfile is expected to be located at "<>websiteAddress],
				{Subsection,"Unit Testing and Function Speed"},
						unitTestSummaryPlot,
						captionStyle["Unit test results are from the latest stable test summary. Individual tests should take no longer than "<>UnitForm[maxTestTime]<>" to run."],
				{Section,"Operator Permissions"},
					operatorPermissionsSummaryText,
					Sequence@@operatorPermissions,
					captionStyle["At least one operator level must have permissions to run the protocol. Unless there are explict reasons to restrict an operator level that level should be given permissions to run the protocol. Qualifications which call an experiment should have permissions as strict or more strict than those of the experiment. To make updates here you can directly upload to the ProtocolPermissions field in the operator models listed. Your type should be directly added to each model which should have permissions (permissions are not inherited)."],
				{Section,"Object Validity Checks"},
					voqSummaryTable,
					captionStyle["All protocols and associated data must pass ValidObjectQ. If errors are thrown while calling ValidObjectQ, $Failed will be returned in place of a result. ValidObjectQ was run on "<>ToString[Download[Join[allData,protocols],Object],InputForm]],

				Sequence@@Which[
					protocolQ, {
						{Section,"Qualifications and Maintenance"},
						{Subsection,"Scheduling"},
							qualScheduleTable,
							captionStyle["The QualificationFrequency field in the instrument model must point to the qualification and have a time interval set. An exception is made if the Director of Instrumentation indicates QualificationRequired can be set to False."],
							maintenanceScheduleTable,
							captionStyle["Instruments aren't explicitly required to have associated maintenance, but all maintenance recommended in the instrument manual, by the manufacturer, etc. should be considered."],
						{Subsection,"Results"},
							qualResultsTable,
							captionStyle["Instruments associated with experiment must have a passing qualification."],
						{Subsection,"Execution"},
							{Subsubsection,"Status Checks"},
								currentQualStatusTable,
								currentMaintenanceStatusTable,
								captionStyle["Check the current statuses of all maintenance and qualifications to see testing progression. "<>statusFollowUpString],
							{Subsubsection,"Processing Times"},
								meanQualStatusTable,
								meanMaintenanceStatusTable,
								captionStyle[statusCaption]
					},

					(* Running on qual function *)
					MatchQ[protocolType,TypeP[Object[Qualification]]], {
						{Subsection,"Scheduling"},
							qualScheduleTable,
							captionStyle["The QualificationFrequency field in the instrument model must point to the qualification and have a time interval set."],
						{Subsection,"Results"},
							qualResultsTable,
							captionStyle["The qualification under consideration should be passing before it leaves beta testing. The developer should receieve Asana tasks to evaluate their qualifications. These tasks include instructions on how to do so."]
					},

					(* Running on maintenance function *)
					MatchQ[protocolType,TypeP[Object[Maintenance]]], {
						{Section,"Scheduling"},
						maintenanceScheduleTable,
						captionStyle["The MaintenanceFrequency field in the instrument model must point to the qualification and have a time interval set."]
					}
				],

				Sequence@@If[MatchQ[protocolType,TypeP[{Object[Qualification],Object[Maintenance]}]],
					{
						{Section,"Dependent Subprotocols"},
						Sequence@@subprotocolTroubleshooting,
						captionStyle["Check the subprotocols used by "<>ToString[experimentFunction]<>" to see what the qualification/maintenance is reliant on."]
					},
					{}
				],

				{Section,"Inventory"},
					inventoryTable,
					noInventoryTable,
					captionStyle["All samples, containers, etc. should be kept in stock if they are routinely consumed during qualifications or standard experiments. For instance, reagents and qualification input samples must be kept in stock unless they can be rented or have very short shelf lives. To rent reusable samples sent Rent->True in the resource object. To create standing orders call UploadInventory."],

				{Section,"Running Protocols"},
					{Subsection,"Protocols Created Over Time"},
						protocolCreationPlot,
					{Subsection,"Status Checks"},
						currentProtocolStatusTable,
						captionStyle["Check the current statuses of all protocols to see testing progression. "<>statusFollowUpString],
					{Subsection,"Checkpoint Accuracy"},
						Sequence@@checkpointComparisonTables,
						captionStyle["Checkpoint estimates should be within "<>ToString[checkpointPercentage]<>"% of the actual value. Checkpoint estimates should not include subprotocols. Subprotocol times have been removed from the actual checkpoint times recordered in CheckpointProgress."],
					{Subsection,"Long Tasks"},
						longTaskTable,
						captionStyle["Long tasks are tasks that took an operator more than 1 hour to complete. This is usually indicative of a poorly designed task (perhaps operators are confused by the instruction, multiple attempts are required a step goes through, operators have to contact their shift manager for help, etc.). Unless the task is a ResourcePicking or Storage task with a large number of involved samples try splitting apart the task, rephrasing, adding error handling or otherwise updating the instructions/images."],
					{Subsection,"Processing Times"},
						meanProtocolStatusTable,
						captionStyle[statusCaption],
					{Subsection,"Procedure Coverage"},
						procedureCoverageTable,
						untestedProcedureTable,
						captionStyle["All procedures that can be entered (for instance every procedure in a branch task) are found. These are compared to the procedures that have actually been entered according to the ProcedureLog of protocols, qualifications and maintenance found since the provided StartDate. All procedures should be tested with the exception of troubleshooting procedures which are only expected to be entered when a given error occurs."],
				{Section,"Troubleshooting Rates"},
					troubleshootingTimeline,
					captionStyle["In order to pass beta testing at least 10 protocols must be run with the last 3 protocols having no associated troubleshooting. Monitoring tickets, such as those tracking long tasks are excluded from the tickets shown here."],
					{Subsection,"Unresolved Tickets"},
						unresolvedTicketTable,
						captionStyle["Unresolved tickets still need a root cause fix. Monitoring tickets, such as those tracking long tasks are excluded from this list."],
					{Subsection,"Resolved Tickets"},
						resolvedTicketTable,
						captionStyle["Resolved tickets have been closed and should have their root cause fixed. Again monitoring tickets are excluded from this list."]
			}]
		]
	];

	outputRules={
		Notebook -> (SystemOpen[fileName];cloudFile),
		SummaryTable -> summaryTable,
		SummaryData -> summaryData
	};

	outputFormat/.outputRules
];

(* PlotBetaTesting helper: Convert False, $Failed or provided pattern into a red string for highlighting in tables *)
failedSymbolStyle[input_] := failedSymbolStyle[input, False | $Failed];
failedSymbolStyle[input_?QuantityQ, baddie_] := input /. baddie :> Style[UnitForm[input], Bold, Red];
failedSymbolStyle[input_, baddie_] := ReplaceAll[input, bad : baddie :> Style[ToString[bad], Bold, Red]];
resultSymbolStyle[input_] := ReplaceAll[input, {False|$Failed:>Style[ToString[input],Bold,Red],True:>Style[ToString[input],Bold,RGBColor[0.32, 0.69, 0.53]]}];

(* PlotBetaTesting helpers: Format text for notebook display *)
captionStyle[input_]:=Style[input,Italic,FontSize->12];
tooltipStyle[input_]:=Style[input,Italic,Darker[Blue]];

(* Tiny helper so we always format function 'Name' option in the same way *)
functionWithName[function_,name_]:=If[MatchQ[name,Null],
	ToString[function],
	ToString[function]<>" ("<>name<>")"
];


(* procedureTree: Find all procedures called by a another procedure by recursively following references *)
procedureTree[protocol:TypeP[]]:=procedureTree[protocol,{protocol}];
procedureTree[protocol:(TypeP[]|_String),trackedSubs_]:=Module[{procedureDefinition, tasks, procedures},

	(* Don't recurse if we've already encountered our current protocol (this suggests we have a loop with a procedure pointing to itself *)
	If[Count[trackedSubs,protocol]>1,
		Return[trackedSubs]
	];

	(* Find the association containing all the tasks for our current protocol/procedure, then grab those tasks *)
	If[SameQ[ProcedureFramework`Private`procedures,<||>],
		Message[PlotBetaTesting::MissingProcedureDefinitions];
	];
	procedureDefinition=SelectFirst[ProcedureFramework`Private`procedures,MatchQ[Lookup[#,"Name"], ToString[protocol]]&];

	If[MatchQ[procedureDefinition,_Missing],
		Return[{}]
	];

	tasks=Lookup[procedureDefinition,"Tasks"];

	(* Recursively find all procedures referenced in other procedures *)
	procedures=Map[
		Function[task,
			Module[{taskArgs,sub,subs},
				taskArgs=Lookup[task,"Args"];
				Which[
					(* "LoopInsertion" and "ProcedureInsertion" tasks store a subprocedure in Procedure key *)
					MatchQ[Lookup[task,"TaskType"],"LoopInsertion"|"ProcedureInsertion"],
					sub=ReleaseHold[Lookup[taskArgs,"Procedure"]];
					procedureTree[sub,Join[trackedSubs,{sub}]],

					(* "Branch" and "MultipleChoiceBranch" tasks store subprocedures in Rules key *)
					MatchQ[Lookup[task,"TaskType"],"Branch"|"MultipleChoiceBranch"],
					subs=DeleteCases[ReleaseHold[Lookup[taskArgs,"Rules"]][[All,2]],None|Continue];
					procedureTree[#,Join[trackedSubs,subs]]&/@subs,

					(* All other tasks have no procedures to consider *)
					True,
					Nothing
				]
			]
		],
		tasks
	];

	ToString/@DeleteDuplicates[Join[Flatten[procedures,2],trackedSubs]]
];

(*findTasks: Given a procedure name or type, recursively find tasks within *)
DefineOptions[findTasks,Options:>{
	{TaskType->All,All|_String,"Indicates the Engine task being selected for."},
	{ID->All,All|_String,"Indicates the ID of the Engine task being selected for."}
}];

(* findTask: Listable overload *)
findTasks[procedure:{(TypeP[]|_String)..},ops_]:=Flatten[findTasks[#,ops]&/@procedure,1];

(* findTasks: Main overload *)
findTasks[procedure:(TypeP[]|_String),ops_]:=Module[{safeOps,taskType,id,procedureDefinition,tasks,tasksByType,tasksByID},
	safeOps=SafeOptions[findTasks,ToList[ops]];
	{taskType,id}=Lookup[safeOps,{TaskType,ID}];

	procedureDefinition=SelectFirst[ProcedureFramework`Private`procedures,MatchQ[Lookup[#,"Name"], ToString[procedure]]&];

	tasks=Lookup[procedureDefinition,"Tasks"];

	tasksByType=If[MatchQ[taskType,All],
		tasks,
		Select[tasks,MatchQ[Lookup[#,"TaskType"],taskType]&]
	];

	tasksByID=If[MatchQ[id,All],
		tasksByType,
		Select[tasksByType,MatchQ[Lookup[#,"ID"],id]&]
	]
];

(* betaTestSummaryTable: Empty overload *)
betaTestSummaryTable[data:{},function:{},name:{}]:=Null;

(* betaTestSummaryTable: Main overload *)
(* Convert beta summary values for a protocol (list) or series of protocols (list of lists) into a display *)
(* This is a funny helper because we can't just return a table from within the body of PlotBetaTesting -
 we need to merge the table for the case where we're looking at multiple protocols *)
betaTestSummaryTable[rawData_,rawFunctions:{___},rawNames:{___}]:=Module[{data,functions,names,functionDescriptions,failedFunctions,
	failedNames,failedDescriptions,failedPlot,mergedData,columnHeaders,successPlot},

	(* Split out into $Failed and successful runs *)
	data=DeleteCases[rawData,$Failed];
	functions=PickList[rawFunctions,rawData,Except[$Failed]];
	names=PickList[rawNames,rawData,Except[$Failed]];
	functionDescriptions=MapThread[functionWithName,{functions,names}];

	failedFunctions=PickList[rawFunctions,rawData,$Failed];
	failedNames=PickList[rawNames,rawData,$Failed];
	failedDescriptions=MapThread[functionWithName,{failedFunctions,failedNames}];

	(* Plot types where we PlotBetaTesting didn't return expected values or returned $Failed *)
	failedPlot=If[MatchQ[failedFunctions,{}],
		Nothing,
		PlotTable[{failedSymbolStyle[#,_Symbol]}&/@failedDescriptions, Title -> "Unable to Generate Beta Testing Reports for:"]
	];

	(* Return early if we only have failed plots *)
	If[MatchQ[data,{}],
		Return[failedPlot]
	];

	(* We're joining multiple summary tables and want only the actual data and not the required values after every entry *)
	(* Add the required values as our very last entry *)
	mergedData=Append[data[[All,1]],data[[1,2]]];

	(* Column headers match up with the data values returned by PlotBetaTesting and these two must be kept in sync *)
	(* Maintenance don't have all the same values and thus also have different headers *)
	columnHeaders = Join[
		{"Documentation Passing (%)","Unit Tests Passing (%)","VOQ Passing?","Completed Protocols","Procedure Coverage"},
		If[MatchQ[With[{func = First[functions]},FunctionPackage[func]],"Maintenance`"],
			{"Maintenance Scheduled?"},
			{"Qualification Scheduled?","Qualification Passing?"}
		],
		{"Current Troubleshooting Rate","Beta Testing Passing?"}
	];

	(* Plot types for which we have results (doesn't need beta testing is passing) *)
	successPlot=PlotTable[
		mergedData,
		TableHeadings->{
			(* Label the lest row to indicate it's just showing the expected numbers *)
			Append[functionDescriptions,"Required Values"],
			columnHeaders
		},
		Round->True,
		HorizontalScrollBar->False,
		Title->"Summary Table"
	];

	Grid[{{successPlot},{failedPlot}}]
];


PlotBetaTesting[]:=Module[{rawBetaResults, betaResults, functions, functionOptions, failedFunctions,
	notebooks, summaryDataSets, protocolTypes, authorNames, authors, dataTuples, maintenanceTuples,
	qualificationTuples, protocolTuples, maintenanceSummary, qualificationSummary, protocolSummary, protocolAuthors, qualificationAuthors,
	maintenanceAuthors, maintenancePNG, qualPNG, protocolPNG, instrumentationPeople, sciDevPeople, allInstrumentPeople, allProtocolPeople,
	downloadedEmails, downloadedInstrumentEmails, downloadedProtocolEmails, defaultProtocolEmails, defaultEmails,
	finalProtocolEmails, finalInstrumentEmails, formatMessage, protocolMessage, qualMessage},

	(* Pull out our functions being tested *)
	functions=ToExpression/@Keys[$BetaExperimentFunctions];
	functionOptions=Values[$BetaExperimentFunctions];

	(* $BetaExperimentFunctions is structured as <|"ExperimentName" -> {testing options} ... |> *)
	(* Call PlotBetaTesting on all listed functions *)
	rawBetaResults=KeyValueMap[
		PlotBetaTesting[ToExpression[#1],ReplaceRule[#2,OutputFormat->{Notebook,SummaryData}]]&,
		$BetaExperimentFunctions
	];

	(* Pull out our successful calls and associated functions *)
	betaResults=Replace[rawBetaResults, {Except[{ObjectP[], _}] -> {$Failed, $Failed}}, {1}];
	failedFunctions=PickList[functions,rawBetaResults,Except[{ObjectP[],_}]];

	(* OutputFormat asked for notebook, summary data - extract them now *)
	notebooks=betaResults[[All,1]];
	summaryDataSets=betaResults[[All,2]];

	(* Lookup types associated with our functions *)
	protocolTypes=Lookup[ProcedureFramework`Private`experimentFunctionTypeLookup,#,$Failed]&/@functions;

	(* Lookup function author objects *)
	authorNames=First[Authors[#],Null]&/@functions;
	authors=If[MatchQ[#,Null],Null,Object[User, Emerald, Developer, #]]&/@authorNames;

	(* Make result tuples *)
	dataTuples=Transpose[{protocolTypes,summaryDataSets,functions,functionOptions,notebooks,authors}];

	(* Split into maintenance, qual and protocol results since we want to present separately *)
	maintenanceTuples = Cases[dataTuples,{TypeP[Object[Maintenance]],___}];
	qualificationTuples = Cases[dataTuples,{TypeP[Object[Qualification]],___}];
	protocolTuples = Cases[dataTuples,{TypeP[Object[Protocol]],___}];

	(* Join up the results from each experiment into a single table *)
	maintenanceSummary = betaTestSummaryTable[maintenanceTuples[[All,2]], maintenanceTuples[[All,3]], Lookup[maintenanceTuples[[All,-3]],Name,Null]];
	qualificationSummary = betaTestSummaryTable[qualificationTuples[[All,2]], qualificationTuples[[All,3]], Lookup[qualificationTuples[[All,-3]],Name,Null]];
	protocolSummary = betaTestSummaryTable[protocolTuples[[All,2]], protocolTuples[[All,3]], Lookup[protocolTuples[[All,-3]],Name,Null]];

	(* Grab our authors so we can email them *)
	protocolAuthors=protocolTuples[[All,-1]];
	qualificationAuthors=qualificationTuples[[All,-1]];
	maintenanceAuthors=maintenanceTuples[[All,-1]];

	(* Convert summary tables into pngs - leave as null if we don't have any protocols of the type *)
	{maintenancePNG,qualPNG,protocolPNG}=MapThread[
		If[!NullQ[#2],Export[#1<>".png",#2]]&,
		{
			{"Maintenance Beta Testing","Qualification Beta Testing","Protocol Beta Testing"},
			{maintenanceSummary,qualificationSummary,protocolSummary}
		}
	];

	(* Lookup folks who should always receive these reports *)
	{instrumentationPeople, sciDevPeople} = Search[{Object[User, Emerald], Object[User, Emerald]}, {
		Status == Active && (Department == (ScientificInstrumentation) || Position == "Director of Operations"),
		Status == Active && Position == ("Director of Scientific Development"|"Sales Leader"|"Director of Operations")
	}];

	(* Get full list of report recipient objects *)
	allInstrumentPeople=DeleteDuplicates[DeleteCases[Join[instrumentationPeople,maintenanceAuthors,qualificationAuthors],Null]];
	allProtocolPeople=DeleteDuplicates[DeleteCases[Join[sciDevPeople,protocolAuthors],Null]];

	(* Get emails for report recipients *)
	downloadedEmails=Download[Join[allInstrumentPeople,allProtocolPeople],Email];
	{downloadedInstrumentEmails,downloadedProtocolEmails}=TakeList[downloadedEmails,{Length[allInstrumentPeople],Length[allProtocolPeople]}];

	(* Hardcode a list of people who always want to receive emails *)
	defaultProtocolEmails = {
		"ben@emeraldcloudlab.com",
		"malav.desai@emeraldcloudlab.com",
		"andrew.heywood@emeraldcloudlab.com",
		"aldelberto.cordova@emeraldcloudlab.com"
	};

	defaultEmails = {
		"hayley@emeraldcloudlab.com",
		"frezza@emeraldcloudlab.com"
	};

	(* Final email lists *)
	finalProtocolEmails=DeleteDuplicates[Join[downloadedProtocolEmails,defaultProtocolEmails,defaultEmails]];
	finalInstrumentEmails=DeleteDuplicates[Join[downloadedInstrumentEmails,defaultEmails]];

	(* Helper function: formatMessage - create email body *)
	formatMessage[messageData:{},header_String]:="There are no "<>header<>" currently in beta testing";
	formatMessage[messageData_,header_String]:=Module[{innerStrings,experiments,cloudFiles,names,experimentLines},

		experiments=messageData[[All,-4]];
		cloudFiles=messageData[[All,-2]];

		(* Lookup name option from options sent to PlotBetaTesting *)
		names=Lookup[#,Name,Null]&/@messageData[[All,-3]];

		experimentLines=MapThread[
			(functionWithName[#1,#2]<>"\n"<>ToString[#3,InputForm])&,
			{experiments,names,cloudFiles}
		];

		"Beta Functions with their Full Notebooks\n\n"<>StringRiffle[experimentLines, "\n\n"]
	];

	(* Create our email bodies *)
	protocolMessage=formatMessage[protocolTuples,"protocols"];
	qualMessage=formatMessage[Join[maintenanceTuples,qualificationTuples],"qualifications or maintenance"];

	(* Send Protocol Email *)
	If[!MatchQ[protocolMessage,Null],
		Email[
			finalProtocolEmails,
			Subject -> "Protocol Beta Testing",
			Message -> protocolMessage,
			Attachments -> Cases[{protocolPNG}, FilePathP]
		]
	];

	(* Send Maintenance and Quals Email *)
	If[!MatchQ[qualMessage,Null],
		Email[
			finalInstrumentEmails,
			Subject -> "Qualification and Maintenance Beta Testing",
			Message -> qualMessage,
			Attachments -> Cases[{maintenancePNG,qualPNG}, FilePathP]
		]
	];

	(* Return results for all the protocols, quals and maintenance tested *)
	dataTuples
];