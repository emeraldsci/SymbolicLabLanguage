(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Debug*)


(* ::Subsection::Closed:: *)
(*DebugManifoldJob*)

Authors[DebugManifoldJob]:= {"platform"};

DefineOptions[DebugManifoldJob,
	Options:>{
		{OutputFormat->Automatic,Automatic|Simplified|Table|Association,"Returns the information in different forms. If Automatic, will return Simplified if the job completed successfully or if it failed due to a common error. Otherwise it will default to Table."},
		{BuildLambdaURL->False,True|False,"Indicates if the Lambda URL should be included in the output results (time-intensive!)."}
	}
];

(* ::Subsubsection::Closed:: *)
(* messages *)

Warning::ComputationIsRunning="Computation is running.";
Warning::ComputationInUndisputedStatus="Computation is in status [`1`].";
Warning::ComputationIsQueued="Computation is queued, currently in position `1`.";
Warning::ComputationErrorMessage="Computation has reported the following error message: `1`.";
Warning::MissingFinancingTeam="Expected job to have a computation financing team.";
Warning::MultipleAWSComputations="The computation has several DateStarted which indicates that there were several AWS computations performed. Please search for the fargate logs for this computations manually to get all possible fargate logs.";
Error::UnexpectedNull="Expected `1` to not be Null.";
Error::UnableToDetermineComputationFailure="`1`";
Error::ExpectedValidObject="Expected a valid `1`. Please check your input object and try again.";

(* ::Subsubsection::Closed:: *)
(*computation core overload*)

DebugManifoldJob[computation:ObjectP[Object[Notebook,Computation]],ops:OptionsPattern[]]:=Module[
	{safeOps,output,commonError,statusLog,simplifiedStatusLog,statusRunningRow,fargateStartTime,fargateLogEntry,lambdaLogEntries,logEntries,outputAssociation,statusLogTable,outputTable,includeLambdaURLQ,computationPacket,jobPacket,financingTeamPacket,dateStartedLogs,cleanedComputationLog},

	safeOps=SafeOptions[DebugManifoldJob,ToList[ops],AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps,$Failed],
		Return[$Failed]
	];

	If[!DatabaseMemberQ[computation],
		Message[Error::ExpectedValidObject, "Object[Notebook,Computation]"];
		Return[$Failed]
	];

	output=Lookup[safeOps,OutputFormat];
	includeLambdaURLQ=Lookup[safeOps,BuildLambdaURL];

	(* download all information we will need for the helper functions *)
	{computationPacket,jobPacket,financingTeamPacket}=Download[computation,
		{
			Packet[FargateClusterName,TaskID,DateCreated,Status,ErrorMessage,CompletedNotebookFile],
			Packet[Job[{HardwareConfiguration,MathematicaVersion,OriginalSLLCommit,SLLVersion}]],
			Packet[Job[ComputationFinancingTeam][{MaxComputationThreads,RunningComputations,ComputationQueue}]]
		}
	];

	(* Get the status log *)
	statusLog=ObjectLog[computation,Fields->{Status,ErrorMessage,DateStarted},OutputFormat->Association];

	If[!MatchQ[statusLog,{KeyValuePattern[{}]...}],
		statusLog={}
	];

	(* remove extra keys from the logs that we don't care about *)
	cleanedComputationLog=Map[KeyDrop[{Object,User,LogKind,ObjectName}],statusLog];
	(* Pick only a few helpful columns from the ObjectLog *)
	simplifiedStatusLog=Map[simplifyObjectLogStatusRow,cleanedComputationLog];
	dateStartedLogs=Map[extractDateStartedLogsRaw,cleanedComputationLog];

	commonError=determineCommonComputationFailure[computationPacket,jobPacket,financingTeamPacket,dateStartedLogs];

	Switch[{output,MatchQ[commonError,commonComputationFailure]},
		{Automatic,True},Return[commonError],
		{Simplified,True},Return[commonError],
		{Simplified,False},Return["There is no known source of failure for this Manifold Job! For additional information, please use the OutputFormat option with value Table or Association."]
	];

	(* try to get the start time for the Fargate log URL *)
	fargateStartTime=Null;
	statusRunningRow=FirstOrDefault[Select[simplifiedStatusLog,MatchQ[Lookup[#[[3]],Status,Null],Running] &]];
	If[!NullQ[statusRunningRow],
		fargateStartTime=First[statusRunningRow];
	];

	(* build the Fargate log entry *)
	(* TODO log group name is currently hard coded,dynamically get the name of the log group *)
	fargateLogEntry=<|"/aws/fargate/manifold-task-stage"-><|"start_time"->fargateStartTime,"url"->getFargateLogURL[computationPacket,jobPacket]|>|>;

	(* Get Lambda log URLs *)
	lambdaLogEntries=If[includeLambdaURLQ,
		getLambdaLogURLAssociation[computation],
		<||>
	];

	(* Combined log entries *)
	(* TODO order the logs by start_time *)
	logEntries=Join[fargateLogEntry,lambdaLogEntries];

	(* Build the association *)
	outputAssociation=With[
		{completedNotebookFile=Download[Lookup[computationPacket,CompletedNotebookFile],Object]},
		Association[
			"Summary"->commonError,
			"StatusLog"->simplifiedStatusLog,
			"LogURLs"->logEntries,
			"CompletedNotebookFile"->If[MatchQ[completedNotebookFile,Null|$Failed],Null,Button["Completed Notebook", OpenCloudFile[completedNotebookFile]]]
		]
	];

	If[MatchQ[output,Automatic|Table],
		(* Build the graphics *)
		statusLogTable=If[!MatchQ[simplifiedStatusLog,{}],
			PlotTable[Values[simplifiedStatusLog],TableHeadings->{Automatic,First[Keys[simplifiedStatusLog]]},HorizontalScrollBar->True],
			Null
		];

		outputTable=Grid[
			{
				{Style[ToString[computation],18,FontFamily->Arial],SpanFromLeft,SpanFromLeft},
				{statusLogTable},
				{plotLogURLTable[logEntries]}
			}
		];

		Return[outputTable];
	];
	Return[outputAssociation];
];

(* ::Subsubsection::Closed:: *)
(*job overload*)

DebugManifoldJob[job:ObjectP[Object[Notebook,Job]],ops:OptionsPattern[]]:=Module[
	{
		computations,latestComputation
	},
	If[!DatabaseMemberQ[job],
		Message[Error::ExpectedValidObject, "Object[Notebook,Job]"];
		Return[$Failed]
	];

	computations=Download[job,Computations];
	If[!MatchQ[computations,ListableP[ObjectP[Object[Notebook,Computation]]]],
		Message[Error::UnableToDetermineComputationFailure, "Failed to download the list of computations."];
		Return[$Failed]
	];

	latestComputation=computations[[-1]][Object];
	DebugManifoldJob[latestComputation,ops]
];

(* ::Subsubsection::Closed:: *)
(*unit testing object overload*)

DebugManifoldJob[function:ObjectP[Object[UnitTest,Function]],ops:OptionsPattern[]]:=Module[
	{
		job
	},
	If[!DatabaseMemberQ[function],
		Message[Error::ExpectedValidObject, "Object[UnitTest, Function]"];
		Return[$Failed]
	];

	job=Download[function,Job[Object]];
	If[!MatchQ[job,ObjectP[Object[Notebook,Job]]],
		Message[Error::UnableToDetermineComputationFailure, "Failed to download the related job object."];
		Return[$Failed]
	];
	DebugManifoldJob[job,ops]
];

(* ::Subsubsection::Closed:: *)
(*manifold kernel overload*)

DebugManifoldJob[manifoldKernel:ObjectP[Object[Software,ManifoldKernel]],ops:OptionsPattern[]]:=Module[
	{
		computations,latestComputation
	},

	If[!DatabaseMemberQ[manifoldKernel],
		Message[Error::ExpectedValidObject, "Object[Software,ManifoldKernel]"];
		Return[$Failed]
	];

	computations=Download[manifoldKernel,ManifoldJob[Computations]];

	If[!MatchQ[computations,ListableP[ObjectP[Object[Notebook,Computation]]]],
		Message[Error::UnableToDetermineComputationFailure, "Failed to download the list of computations."];
		Return[$Failed]
	];

	latestComputation=computations[[-1]][Object];
	DebugManifoldJob[latestComputation,ops]
];

(* ::Subsubsection::Closed:: *)
(*manifold command overload*)

DebugManifoldJob[manifoldCommand:ObjectP[Object[Software,ManifoldKernelCommand]],ops:OptionsPattern[]]:=Module[
	{
		computations,latestComputation
	},

	If[!DatabaseMemberQ[manifoldCommand],
		Message[Error::ExpectedValidObject,"Object[Software,ManifoldKernelCommand]"];
		Return[$Failed]
	];

	computations=Download[manifoldCommand,ManifoldKernel[ManifoldJob][Computations]];

	If[!MatchQ[computations,ListableP[ObjectP[Object[Notebook,Computation]]]],
		Message[Error::UnableToDetermineComputationFailure,"Failed to download the list of computations."];
		Return[$Failed]
	];

	latestComputation=computations[[-1]][Object];
	DebugManifoldJob[latestComputation,ops]
];

(* ::Subsubsection::Closed:: *)
(*unit testing suite overload*)

DebugManifoldJob[suite:ObjectP[Object[UnitTest,Suite]],ops:OptionsPattern[]]:=Module[
	{
		launchingJobs
	},
	If[!DatabaseMemberQ[suite],
		Message[Error::ExpectedValidObject, "Object[UnitTest, Suite]"];
		Return[$Failed]
	];

	launchingJobs=Download[suite,LaunchingJobs[Object]];
	If[!MatchQ[launchingJobs,{ObjectP[Object[Notebook,Job]]..}],
		Message[Error::UnableToDetermineComputationFailure, "The Object[UnitTest, Suite] did not have any launching jobs."];
		Return[$Failed]
	];
	DebugManifoldJob[#,ops]&/@launchingJobs
];

(* ::Subsubsection::Closed:: *)
(*simplifyObjectLogStatusRow*)

(* Helper function to grab only a few columns from a row of ObjectLog *)
simplifyObjectLogStatusRow[objectLogRow_]:=Association[
	Date->Lookup[objectLogRow,Date],
	Username->Lookup[objectLogRow,Username],
	Fields->KeySelect[Lookup[objectLogRow,Fields],MatchQ[Status]]
];

(* ::Subsubsection::Closed:: *)
(*extractDateStartedLogsRaw*)

(* Helper function to grab only a few columns from a row of ObjectLog *)
extractDateStartedLogsRaw[objectLogRow_]:=If[KeyExistsQ[Lookup[objectLogRow,Fields],DateStarted],
	Association[
	Date->Lookup[objectLogRow,Date],
	Username->Lookup[objectLogRow,Username],
	Fields->KeySelect[Lookup[objectLogRow,Fields],MatchQ[DateStarted]]
],
	Nothing
];

(* ::Subsubsection::Closed:: *)
(*mmVersionURLString*)

mmVersionURLString[version:(_String|Null)]:=If[MatchQ[version,Null],"13-3-1",StringReplace[version,"."->"-"]];

(* ::Subsubsection::Closed:: *)
(*getFargateLogURL*)

(* TODO write unit tests! *)
(* if we are calling this on the computation reference, get packets and call the core overload *)


(* Authors definition for Manifold`Private`getFargateLogURL *)
Authors[Manifold`Private`getFargateLogURL]:={"steven"};

getFargateLogURL[computation:ObjectP[Object[Notebook,Computation]]]:=getFargateLogURL[Sequence@@Download[computation,{
	Packet[FargateClusterName,TaskID,DateCreated],
	Packet[Job[{HardwareConfiguration,MathematicaVersion}]]
}]];
getFargateLogURL[computationPacket:PacketP[Object[Notebook,Computation]],jobPacket:Null]:=Null;

(* core overload *)
getFargateLogURL[computationPacket:PacketP[Object[Notebook,Computation]],jobPacket:PacketP[Object[Notebook,Job]]]:=Module[
	{hardwareConfiguration,version,fargateClusterName,taskID,dateCreated,isHighRam,isProd},

	(* pull out required data from the packets *)
	{hardwareConfiguration,version}=Lookup[jobPacket,{HardwareConfiguration,MathematicaVersion}];
	{fargateClusterName,taskID,dateCreated}=Lookup[computationPacket,{FargateClusterName,TaskID,DateCreated}];

	If[NullQ[taskID],
		Return[Null]
	];
	isProd=StringContainsQ[fargateClusterName,"prod"|"public"];
	isHighRam=MatchQ[hardwareConfiguration,HighRAM];

	With[
		{
			baseURL="https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#logsV2:log-groups/log-group/",
			logGroup="/aws/fargate/manifold-"<>If[isHighRam,"high-ram-",""]<>"task-"<>If[isProd,"prod","stage"],
			logEvent="ecs/manifold-mm-"<>mmVersionURLString[version]<>If[isHighRam,"-high-ram",""]<>If[isProd,"-prod/","-stage/"]<>taskID<>"$3Fstart$3D"<>ToString[1000*UnixTime@dateCreated]
		},
		Hyperlink[baseURL<>StringReplace[logGroup,"/"->"$252F"]<>"/log-events/"<>StringReplace[logEvent,"/"->"$252F"]]
	]
];

(* ::Subsubsection::Closed:: *)
(*getLambdaLogURLAssociation*)

getLambdaLogURLAssociation[computation:ObjectP[Object[Notebook,Computation]]]:=Module[
	{jobID,requestJson,constellationResponse,lambdaLogs},
	(* Get the lambda logs *)
	jobID=Download[computation,Job[ID]];
	If[MatchQ[jobID,$Failed],
		Return[<||>]
	];

	requestJson=ECL`Web`ExportJSON[Association["job_id"->jobID]];
	If[MatchQ[requestJson,$Failed],
		Return[<||>]
	];

	constellationResponse=ECL`Web`ConstellationRequest[
		<|"Path"->"logs/manifold-lambda-logs",
		"Body"->requestJson,
		"Method"->"POST",
		"Timeout"->360000|>,
		Retries->5,
		RetryMode->Read
	];

	(* Make sure that we got a well structured response from the endpoint *)
	(* TODO return error message if the response is malformed *)
	If[MatchQ[constellationResponse,KeyValuePattern[_->KeyValuePattern[_->KeyValuePattern[{}]]]],
	lambdaLogs=Lookup[constellationResponse,"lambda_logs",Null],
		Return[<||>]
	];

	If[NullQ[lambdaLogs],
		Return[<||>]
	];

	(* reformat AWS dates to DateObject *)
	lambdaLogs=AssociationMap[reformatDates,lambdaLogs];

	(* reformat link strings to Hyperlinks*)
	lambdaLogs=AssociationMap[reformatLinks,lambdaLogs];

	lambdaLogs
];

(* ::Subsubsection::Closed:: *)
(*plotLogURLTable*)

plotLogURLTable[logURLAssociation:KeyValuePattern[_->KeyValuePattern[{}]]]:=Module[{logNames,startTimes,URLs,logURLTableRows},
	logNames=Keys[logURLAssociation];
	startTimes=Values[Map[Lookup[#,"start_time",Null]&,logURLAssociation]];
	URLs=Values[Map[Lookup[#,"url",Null]&,logURLAssociation]];

	logURLTableRows=Transpose[{startTimes,logNames,URLs}];

	PlotTable[logURLTableRows,TableHeadings->{Automatic,{"Start Time","Log Group","URL"}},HorizontalScrollBar->True,Tooltips->False]
];

(* ::Subsubsection::Closed:: *)
(*reformatLinks*)

reformatLinks[logGroupName_String->logRow_]:=Module[{reformattedLogRow},
	reformattedLogRow=logRow;
	reformattedLogRow["url"]=Hyperlink[Lookup[reformattedLogRow,"url",Null]];
	logGroupName->reformattedLogRow
];

(* ::Subsubsection::Closed:: *)
(*reformatDates*)

reformatDates[logGroupName_String->logRow_]:=Module[{reformattedLogRow},
	reformattedLogRow=logRow;
	reformattedLogRow["start_time"]=Rfc3339ToDateObject[Lookup[reformattedLogRow,"start_time",Null]];
	logGroupName->reformattedLogRow
];

(* ::Subsubsection::Closed:: *)
(*determineCommonComputationFailure*)

Authors[determineCommonComputationFailure]:= {"platform"};

commonComputationFailure=Alternatives[
	ComputationNoLongerExists,
	JobNoLongerExists,
	DistroDoesNotExist,
	ComputationTimedOut,
	QueueIsFull,
	LaunchingJobFailure,
	ComputationNotQueued,
	VersionAndCommitDoNotMatch,
	(* we don't want to return on this error because we still want to see the logs for status and the fargate/labmda links *)
	(*MultipleAWSComputations,*)
	$Failed
];

determineCommonComputationFailure[computationPacket:PacketP[Object[Notebook,Computation]],
	jobPacket:(PacketP[Object[Notebook,Job]]|$Failed|Null),
	financingTeamPacket:(PacketP[Object[Team,Financing]]|$Failed|Null),
	computationDateStartedLogs_
]:=Module[
	{
		computation,
		job,
		computationFinancingTeam,
		maxComputationThreads,
		runningComputations,
		computationQueue,
		queuePosition,
		computationStatus,
		originalSLLCommit,
		sllVersion,
		computationErrorMessage
	},

	(* we have checked that the computation exists in the parent DebugManifoldJob, so no need to check it again*)

	(* extract the data from the packets *)
	{computation,computationStatus,computationErrorMessage}=Lookup[computationPacket,{Object,Status,ErrorMessage}];
	{job,originalSLLCommit,sllVersion}=Lookup[jobPacket/.Null-><||>,{Object,OriginalSLLCommit,SLLVersion},Null];
	computationFinancingTeam=Lookup[financingTeamPacket/.Null-><||>,Object,Null];

	If[MatchQ[jobPacket,$Failed],
		Message[Error::UnableToDetermineComputationFailure,"Could not download parent job."];
		Return[$Failed,Module]
	];
	If[NullQ[job],
		Return[JobNoLongerExists];
	];

	If[MatchQ[computationFinancingTeam,Null|$Failed],
		Message[Warning::MissingFinancingTeam];
		Return[Null,Module]
	];

	(* We have a parent job and a financing team. Let's check the queue. *)
	{maxComputationThreads,runningComputations,computationQueue}=Lookup[financingTeamPacket,{
		MaxComputationThreads,
		RunningComputations,
		ComputationQueue
	},
		$Failed
	];
	If[MatchQ[maxComputationThreads,$Failed],
		Message[Error::UnableToDetermineComputationFailure,"Unable to pull queue info."];
		Return[$Failed,Module]
	];

	If[NullQ[maxComputationThreads],
		Message[Error::UnexpectedNull,"MaxComputationThreads"];
		Return[$Failed,Module];
	];
	If[NullQ[runningComputations],
		Message[Error::UnexpectedNull,"RunningComputations"];
		Return[$Failed,Module];
	];
	If[NullQ[computationQueue],
		Message[Error::UnexpectedNull,"ComputationQueue"];
		Return[$Failed,Module];
	];

	(* If the computation is running,warn the user that there is no failure. *)
	If[MemberQ[Download[runningComputations,Object],computation],
		Message[Warning::ComputationIsRunning];
		Return[Null,Module]
	];

	(* If the computation is queued,warn the user that there is no failure. *)
	queuePosition=positionInQueue[Download[computationQueue,Object],computation];
	If[!NullQ[queuePosition],
		Message[Warning::ComputationIsQueued,queuePosition];
		Return[Null,Module]
	];

	(* 0. check if we ran several computations on the AWS for this one computation ID*)
	If[Length[computationDateStartedLogs]>1,
		Message[Warning::MultipleAWSComputations];
		Return[MultipleAWSComputations,Module]
	];

	(* Alright. If we got here,it means that the computation is not queued nor running. *)

	(* Maybe the computation has already completed? If so,warn the user that there is no failure. *)
	If[MatchQ[computationStatus,$Failed],
		Message[Error::UnableToDetermineComputationFailure,"Could not pull computation status."];
		Return[$Failed,Module]
	];
	If[MemberQ[{Aborted,Staged,Completed},computationStatus],
		Message[Warning::ComputationInUndisputedStatus,computationStatus];
		Return[Null,Module]
	];

	(* Something went wrong with this computation. We're in Debug city. *)

	(* 1. A Unit test was ran too long and was cut off by the time limit or was started too late in the day *)
	If[MatchQ[computationStatus,TimedOut],Return[ComputationTimedOut,Module]];

	(* 2. Is the queue full? *)
	If[Length[runningComputations]>=maxComputationThreads,Return[QueueIsFull,Module]];

	(* 3. Does the computation and job still exist? DB refresh might have cleared them... *)
	If[!DatabaseMemberQ[job],Return[JobNoLongerExists,Module]];

	(* x. The SLLVersion and SLLCommit provided to Compute do not match *)
	If[False,Return[VersionAndCommitDoNotMatch,Module]];

	(* x. In the case of Object[UnitTest,Suite],did any of the launching jobs fail *)
	If[False,Return[LaunchingJobFailure,Module]];

	(* 4. Does the computation have an ErrorMessage populated? *)
	If[!NullQ[computationErrorMessage],Message[Warning::ComputationErrorMessage,computationErrorMessage];];

	(* 5. Computation requires a distro. Does it exist? *)
	If[Length@Search[Object[Software,Distro],Commit==originalSLLCommit]==0,
		Return[DistroDoesNotExist, Module]
	];

	(* -1. If none of the above,return Null *)
	Return[Null, Module]
];

(* ::Subsubsection::Closed:: *)
(*positionInQueue*)

positionInQueue[list:{ObjectP[Object[Notebook,Computation]]...},computation:ObjectP[Object[Notebook,Computation]]]:=With[
	{positions=Flatten@Position[list,computation]},
	If[Length[positions]==0,Null,First[positions]]
];

(* ::Subsection:: *)
(* PlotTestSuiteTimeline *)

Authors[PlotTestSuiteTimeline]:= {"platform"};

neutrinoDatabaseP=0|1|2|3|4|5;

DefineOptions[PlotTestSuiteTimeline,
	Options:>{
		{Database->Any,Any|neutrinoDatabaseP|_Alternatives|Except[neutrinoDatabaseP],"Only show tests that run on a specific Neutrino database."},
		{Status->Any,Any|UnitTestFunctionStatusP|Except[UnitTestFunctionStatusP]|_Alternatives|Except[_Alternatives],"Only show tests that are in the given status."},
		{Where->(True&),_Function,"Advanced filtering. Pass in any predicate to filter the unit test functions."}
	}
];

PlotTestSuiteTimeline::UnableToDownloadSuiteData="Unable to download suite data";

PlotTestSuiteTimeline[suite:ObjectP[Object[UnitTest,Suite]],ops:OptionsPattern[]]:=Module[{safeOps,data},
	safeOps=SafeOptions[PlotTestSuiteTimeline,ToList[ops],AutoCorrect->False];

	(* Download all the required data *)
	data=Download[suite,Packet@UnitTests[{Name,DateCreated,DateEnqueued,DateStarted,DateCompleted,Database,Status}]];
	If[MatchQ[data,$Failed],
		Message[UnableToDownloadSuiteData];
		Return[$Failed]
	];
	With[
		{
			databasePattern=Lookup[safeOps,Database],
			statusPattern=Lookup[safeOps,Status],
			where=Lookup[safeOps,Where],
			match=Function[{key,pattern,value},If[MatchQ[pattern,Any],True,MatchQ[Lookup[value,key],pattern]]]
		},
		plotTestSuiteTimeline[
			Select[
				data,
				And[
					If[NullQ[where],True,where[#]],
					match[Status,statusPattern,#],
					match[Database,databasePattern,#]
				]&
			]
		]
	]
];

(* ::Subsubsection::Closed:: *)
(*plotTestSuiteTimeline*)

plotTestSuiteTimeline[data:{_Association...}]:=With[
	{
		(* Here we group the functions by the database that they run in *)
		plotData=GroupBy[
			data,
			(#[Database]&)->(
				Tooltip[
					toLabeledEvent[#],
					tooltipBody[#]
				]&
			)
		],
		aspectRatio=Min[{100,Max[{1,IntegerPart[Length@data/5]}]}],
		windowSize=CurrentValue["WindowSize"]
	},
	TimelinePlot[
		Values[plotData],
		PlotLayout->"Stacked",
		AspectRatio->aspectRatio/20,
		PlotLegends->Placed[
			LineLegend["Neutrino "<>ToString[#]&/@Flatten[Keys[plotData]]],
			Top
		],
		PlotTheme->"Detailed",
		ImageSize->{0.8*windowSize[[1]],Automatic},
		AxesOrigin->Top,
		PerformanceGoal->"Speed"
	]
];

(* ::Subsubsection::Closed:: *)
(*toLabel*)

toLabel[name_String,status:UnitTestFunctionStatusP]:=StringJoin[
	First@StringSplit[name],
	" ",
	status/.{
		Enqueued->"\[VerticalEllipsis]",
		Running->"\[FilledRightTriangle]\[FilledRightTriangle]\[FilledRightTriangle]",
		Passed->"\[Checkmark]",
		Failed->"x",
		Crashed->"(x)",
		TimedOut->"\:231b",
		Aborted->"\:2298",
		SuiteTimedOut->"\:231b",
		ManifoldBackendError->"(x)",
		MathematicaError->"(x)",
		s_:>ToString[s]
	}
];

(* ::Subsubsection::Closed:: *)
(*formatDate*)

formatDate[d:(_DateObject|Null)]:=If[NullQ[d],"N/A",DateString[d]];

(* ::Subsubsection::Closed:: *)
(*toLabeledEvent*)

toLabeledEvent[assoc_]:=Module[
	{dateStarted,dateCompleted},
	{dateStarted,dateCompleted}=Lookup[assoc,{DateStarted,DateCompleted}];
	Labeled[
		If[NullQ[dateStarted],
			(* If the function hasn't started, show a single event marking the time it was enqueued *)
			Lookup[assoc,DateEnqueued],
			If[$VersionNumber > 12.,
				DateInterval,
				Interval
			][{dateStarted,If[NullQ[dateCompleted],Now,dateCompleted]}]
		],
		toLabel[Lookup[assoc,Name],Lookup[assoc,Status]],
		After
	]
];

(* ::Subsubsection::Closed:: *)
(*tooltipBody*)

tooltipBody[assoc_Association]:=Labeled[
	StringRiffle[
		MapThread[
			StringJoin[#1,": ",#2[Lookup[assoc,#3]]]&,
			Transpose@{
				{"Created on",formatDate,DateCreated},
				{"Enqueued on",formatDate,DateEnqueued},
				{"Started on",formatDate,DateStarted},
				{"DateCompleted",formatDate,DateCompleted},
				{"Status",ToString,Status}
			}
		],
		"\n"
	],
	StringJoin["Unit test: ",ToString[Lookup[assoc,Name]]]
];

(* ::Subsection:: *)
(* PlotTestSuiteSummaries *)

Authors[PlotTestSuiteSummaries]:= {"dima", "steven", "mert"};

DefineOptions[PlotTestSuiteSummaries,
	Options:>{
		{Status->Any,Any|UnitTestFunctionStatusP|Except[UnitTestFunctionStatusP]|_Alternatives|Except[_Alternatives],"Only show tests that are in the given status."}
	}
];

(* Function to show test summaries for a collection of unit tests *)
PlotTestSuiteSummaries[testSuite:ObjectP[Object[UnitTest,Suite]],ops:OptionsPattern[]]:=Module[
	{safeOps,status,testData,totalTests,notPassed,notPassedLength,pending,pendingLength,passed,passedLength},
	safeOps=SafeOptions[PlotTestSuiteSummaries,ToList[ops],AutoCorrect->False];

	testData=Transpose@Download[testSuite,{UnitTests[Object],UnitTests[Status]}];
	totalTests=Length[testData];
	notPassed=Cases[testData,{_,Except[Passed]}][[;;,1]];
	passed=Cases[testData,{_,Passed}][[;;,1]];
	passedLength=Length[passed];
	pending=Cases[testData,{_,Running|Enqueued}][[;;,1]];
	pendingLength = Length[pending];
	notPassedLength=Length[notPassed];
	Print["Total tests: "<>ToString[totalTests]];
	Print["Pending/running: "<>ToString[pendingLength]];
	Print["Passed: "<>ToString[passedLength]];
	Print["Pass %: "<>ToString[Round[passedLength/totalTests*100,0.1]]];

	status=Lookup[safeOps, Status, Any];
	If[MatchQ[status,Any],
		PlotTestSuiteSummaries[testSuite[UnitTests]],
		With[{filteredFunctions=Cases[testData,{_,Lookup[safeOps,Status]}][[;;,1]]},
			If[MatchQ[filteredFunctions,{}],Print["There are no unit test functions matching the status: "<>ToString[status]]];
			PlotTestSuiteSummaries[filteredFunctions]
		]
	]
];

PlotTestSuiteSummaries[function:ObjectP[Object[UnitTest,Function]],ops:OptionsPattern[]]:=PlotTestSuiteSummaries[{function},ops];
PlotTestSuiteSummaries[functions:{ObjectP[Object[UnitTest,Function]]..},ops:OptionsPattern[]]:=Module[{safeOps,status},
	safeOps=SafeOptions[PlotTestSuiteSummaries,ToList[ops],AutoCorrect->False];
	status=Lookup[safeOps, Status, Any];
	If[MatchQ[status,Any],
		Return[PlotTestSuiteSummaries[functions]]
	];
	With[{filteredFunctions=Cases[Download[functions,{Object,Status}],{_,status}][[;;,1]]},
		If[MatchQ[filteredFunctions,{}],Print["There are no unit test functions matching the status: "<>ToString[status]]];
		PlotTestSuiteSummaries[filteredFunctions]
	]
];

PlotTestSuiteSummaries[functions:{ObjectP[Object[UnitTest,Function]]..}]:=Module[
	{downloadedInfo, allPossibleStatus, reSortedInfo, formattedInfo,sortedPotentialStatuses},
	downloadedInfo = Download[functions,{Function, Status, EmeraldTestSummary[Object], Database}];
	allPossibleStatus = List @@ UnitTestFunctionStatusP;
	(* we want Passed to be the last ones on the list since we will never look at them *)
	sortedPotentialStatuses=Join[DeleteCases[allPossibleStatus,Passed|Pending|Enqueued|Running],{Running,Enqueued,Passed}];
	reSortedInfo = Join@@Map[
		Function[{status},
			ToList@Select[downloadedInfo,MatchQ[#[[2]],status]&]
		],
		sortedPotentialStatuses
	];
	formattedInfo = Map[
		Flatten[{Switch[#[[2]],
			Running,
			{Item[#[[1]], Background->Yellow], Item[#[[2]], Background->Yellow], Item[#[[4]], Background->Yellow]},
			Failed|MathematicaError,
			{Item[#[[1]], Background->Pink], Item[#[[2]], Background->Pink], Item[#[[4]], Background->Pink]},
			Passed,
			{Item[#[[1]], Background->Green], Item[#[[2]], Background->Green], Item[#[[4]], Background->Green]},
			Enqueued,
			{Item[#[[1]], Background->LightGray], Item[#[[2]], Background->LightGray], Item[#[[4]], Background->LightGray]},
			SuiteTimedOut|TimedOut|Aborted|ManifoldBackendError|Crashed,
			{Item[#[[1]], Background->Orange], Item[#[[2]],Background->Orange], Item[#[[4]], Background->Orange]},
			_,
			{Item[#[[1]], Background->Lighter@Lighter@Purple], Item[#[[2]],Background->Lighter@Lighter@Purple], Item[#[[4]], Background->Purple]}
		],
			If[MatchQ[#[[3]],ObjectP[]],Button["TestFailures", TestFailureNotebook[Get[DownloadCloudFile[#[[3]],$TemporaryDirectory]]]],Item["No test summary"]],
			If[MatchQ[#[[3]],ObjectP[]],Button["SetUpMessages",Print[Lookup[Get[DownloadCloudFile[#[[3]],$TemporaryDirectory]][[1]],SymbolSetUpMessages,"No Messages"]]],Item["No test summary"]]
		}]&,
		reSortedInfo];
	Grid[Join[{{Function, Status, Database, Failures, SymbolSetUpMessages}},formattedInfo],Alignment->Left,Frame->All]
];

PlotTestSuiteSummaries[{}]:=Null