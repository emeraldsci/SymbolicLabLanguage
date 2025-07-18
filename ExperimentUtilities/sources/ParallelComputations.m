(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*updateParallelComputationFields*)

updateParallelComputationFields[] := Block[{ECL`Web`$ECLTracing:=!MatchQ[ECL`$UnitTestObject, _ECL`Object]},TraceExpression["updateParallelComputationFields", Module[
	{
		shorterProtocolTypes, outstandingProts, outstandingProtocolPackets, protJobAndMKCPackets, protComputationPackets,
		protMKCComputationPackets, protKernelPackets, protKernelJobPackets, allDownloadValues, fastAssoc, allNewPackets,
		retryNumberLimit
	},

	(* This variable defines the max limit of retries when computation fail *)
	retryNumberLimit = 4;

	(* this is so we only do Object[Protocol], Object[Maintenance], and Object[Qualification] and not all the subtypings *)
	shorterProtocolTypes = Select[ProtocolTypes[], Length[#] == 1&];

	(* get all the outstanding protocols and download information from their jobs *)
	outstandingProts = Search[shorterProtocolTypes, ComputationsOutstanding == True];
	allDownloadValues = Quiet[
		Download[
			outstandingProts,
			{
				Packet[ComputationsOutstanding, ErroneousComputations, ParallelComputations, Author],
				(* we are downloading necessary fields for Object[Notebook, Job], Object[Software, ManifoldKernelCommand] types both *)
				Packet[ParallelComputations[{Command, Messages, Status, DateCreated, DateStarted, DateCompleted, Computations, ManifoldKernel, Notebook, TemplateNotebookFile, ZDriveFilePaths, HardwareConfiguration, MathematicaVersion, Result}]],
				(* downloading fields necessary needed for Object[Notebook, Computation] as well *)
				Packet[ParallelComputations[Computations[{History, Status, ErrorMessage, DateCreated, DateStarted, DateCompleted}]]],
				(* downloading fields for the job that the ManifoldKernel is using *)
				Packet[ParallelComputations[ManifoldKernel][{Notebook, ManifoldJob, Distro, HardwareConfiguration}]],
				Packet[ParallelComputations[ManifoldKernel][ManifoldJob][{SLLVersion, SLLCommit, HardwareConfiguration, MathematicaVersion, RunAsUser}]],
				Packet[ParallelComputations[ManifoldKernel][ManifoldJob][Computations][{Status, ErrorMessage}]]
			}
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];
	{
		outstandingProtocolPackets,
		protJobAndMKCPackets,
		protComputationPackets,
		protKernelPackets,
		protKernelJobPackets,
		protMKCComputationPackets
	} = If[MatchQ[outstandingProts, {}],
		{{}, {}, {}, {}, {}, {}},
		Transpose[allDownloadValues]
	];

	(* make a fast association so we can look up these objects quickly below *)
	fastAssoc = Experiment`Private`makeFastAssocFromCache[Experiment`Private`FlattenCachePackets[allDownloadValues]];

	(* generate the new protocol packets for each one *)
	(* if all the jobs are complete then set ComputationsOutstanding back to Null *)
	(* also make packets for things that are going to be set to TimedOut*)
	allNewPackets = Flatten[MapThread[
		Function[{protocolPacket, jobAndMKCPackets, computationPackets, listyMKCComputationPackets, kernelPackets, kernelJobPackets},
			Module[
				{initialErroneousComputations, erroneousJobQs, jobCompletedQs, newlyTimedOutJobQs, computationsOutstanding,
					allErroneousComputations, erroneousComputationsToAppend, newProtPacket, protObject, newlyTimedOutJobs,
					newlyTimedOutComputationQs, newlyTimedOutJobPackets, mkcComputationPackets, neverGoingToStartQs,
					badKernelsToCommandsAssoc, newRetryComputations,
					protocolNotebook, newRetriedComputationsToAppend, canRetryErroneousJobQs, erroneousJobsToRetry,
					newRetryTimedOutJobs, newRetryErroneousJobs, newRetriedComputationsAssoc, allJobTemplateFiles, templateFileCounts,
					retriedComputationsFromBadMKCs, finalComputationsOutstanding, allRetriedComputations, jobsFailedToRetry,
					allFailedExpressions, allFailedOutputs, allFailedMessages, computationFailureMessages, ticketDescription,
					ticketObject
				},

				(* pull out the protocol object *)
				protObject = Lookup[protocolPacket, Object];
				protocolNotebook = Download[Lookup[protocolPacket, Notebook], Object];

				(* pull out the erroneous jobs that we have already accounted for *)
				initialErroneousComputations = Download[Lookup[protocolPacket, ErroneousComputations], Object];

				(* determine if the ManifoldKernelCommands never started and never will start because they're linked with a kernel that was throttled at the start *)
				mkcComputationPackets = LastOrDefault /@ listyMKCComputationPackets;
				neverGoingToStartQs = Map[
					And[
						MatchQ[#, PacketP[Object[Notebook, Computation]]],
						MatchQ[Lookup[#, Status], Error],
						StringStartsQ[ToString[Lookup[#, ErrorMessage]], "Computation failed to stage within 15 minutes of being ready"]
					]&,
					mkcComputationPackets
				];

				(* determine which commands we need to associate which which bad kernels we need to replace *)
				badKernelsToCommandsAssoc = Merge[
					MapThread[
						If[#1,
							Download[Lookup[#2, ManifoldKernel], Object] -> Lookup[#2, Object],
							Nothing
						]&,
						{neverGoingToStartQs, jobAndMKCPackets}
					],
					Join
				];

				(* abort the bad kernels; quiet the Warning::ComputationNotAborted because if the computation's status is Error it can't acutally get aborted *)
				(* however, aborting the kernel is more than just aborting the computation it's tied to (namely, saying Available -> False), so it is still useful to make this call *)
				If[Length[badKernelsToCommandsAssoc] > 0,
					Quiet[
						AbortManifoldKernel[Keys[badKernelsToCommandsAssoc]],
						Warning::ComputationNotAborted
					]
				];

				(* re-launch an Object[Notebook, Job] to replace the erroneous ManifoldKernelCommand object; *)
				retriedComputationsFromBadMKCs = KeyValueMap[
					Function[{badKernel, commandsToAdd},
						Module[{hardwareConfiguration, command, zDriveFilePaths, notebook},

							(* for sure the following options, though I'd prefer to keep using developerOptions so we don't get hard coding mismatches *)
							(* RunAsUser, HardwareConfiguration, MathematicaVersion, SLLVersion, SLLCommit *)
							hardwareConfiguration = Experiment`Private`fastAssocLookup[fastAssoc, badKernel, {ManifoldJob, HardwareConfiguration}];
							command = Experiment`Private`fastAssocLookup[fastAssoc, #, Command]& /@ commandsToAdd;
							zDriveFilePaths = Experiment`Private`fastAssocLookup[fastAssoc, #, ZDriveFilePaths]& /@ commandsToAdd;
							notebook = Download[Experiment`Private`fastAssocLookup[fastAssoc, badKernel, Notebook], Object];

							MapThread[
								If[NullQ[notebook],
									Block[{$Notebook = Object[LaboratoryNotebook, "id:kEJ9mqJXk0Pz"](* "Parallel Execute Notebook" *), $PersonID = Object[User, Emerald, Developer, "id:vXl9j57W0PqJ"](* Object[User, Emerald, Developer, "service+lab-infrastructure"] *)},
										With[{template = #1, zDrive = #2, config = hardwareConfiguration},
											Compute[ToExpression[template], ZDriveFilePaths -> zDrive, HardwareConfiguration -> config]
										]
									],
									Block[{$Notebook = notebook, $PersonID = Object[User, Emerald, Developer, "id:vXl9j57W0PqJ"](* Object[User, Emerald, Developer, "service+lab-infrastructure"] *)},
										With[{template = #1, zDrive = #2, config = hardwareConfiguration},
											Compute[ToExpression[template], ZDriveFilePaths -> zDrive,  HardwareConfiguration -> config]
										]
									]
								]&,
								{command, zDriveFilePaths}
							]
						]
					],
					badKernelsToCommandsAssoc
				];

				(* determine whether any of the manifoldKernelCommand packets are erroneous *)
				{erroneousJobQs, canRetryErroneousJobQs} = Transpose[MapThread[
					Function[{jobAndMKCPacket, computationPacketsPerJob},
						Module[{alreadyErroneousQ, computationBadQ, alreadyTimedOutQ, canRetryComputationBadQ},

							(* if we already determined that this is bad, then that's good enough *)
							alreadyErroneousQ = MemberQ[initialErroneousComputations, Lookup[jobAndMKCPacket, Object]];

							(* if we've already determined that this job has timed out, then we want to group it with erroneous here because it's a different behavior than below with newly timed out ones *)
							alreadyTimedOutQ = If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
								MatchQ[Lookup[jobAndMKCPacket, Status], TimedOut],
								MemberQ[Lookup[computationPacketsPerJob, Status], TimeOut]
							];

							(* determine if an individual computation is bad based on its type *)
							computationBadQ = If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
								(* for Object[Software, ManifoldKernelCommand] type, we look for messages to see if it is bad or not *)
								ToList[Not[MatchQ[Lookup[jobAndMKCPacket, Messages], {}]]],
								(* for Object[Notebook, Job] type, we look at the computation packet, if one of them is considered bad, it is bad overall *)
								Map[
									Function[{computationPacket},
										Or[
											Not[NullQ[Lookup[computationPacket, ErrorMessage]]],
											Not[MatchQ[Lookup[Lookup[computationPacket, History], Messages, {}], {{}...}]],
											MatchQ[Lookup[computationPacket, Status], Aborting | Aborted | Stopping | Stopped | Error]
										]
									],
									computationPacketsPerJob
								]
							];

							(* Also determine if the erroneous computation can be retried *)
							canRetryComputationBadQ = MapThread[
								And[#1, #2]&,
								{
									computationBadQ,
									If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
										(* Don't retry Object[Software, ManifoldKernelCommand] because it's already taken care of in previous code block *)
										ConstantArray[False, Length[computationBadQ]],
										Map[
											Function[{computationPacket},
												Or[
													StringStartsQ[ToString[Lookup[computationPacket, ErrorMessage]], "Computation failed to stage within 15 minutes of being ready"],
													MatchQ[Lookup[computationPacket, Status], Aborting | Aborted | Stopping | Stopped | Error]
												]
											],
											computationPacketsPerJob
										]
									]
								}
							];

							{
								Or[
									alreadyErroneousQ,
									alreadyTimedOutQ,
									MemberQ[computationBadQ, True]
								],
								(* For retrying computations, only retry the newly errored ones *)
								And[
									!alreadyErroneousQ,
									!alreadyTimedOutQ,
									MemberQ[canRetryComputationBadQ, True]
								]
							}
						]
					],
					{jobAndMKCPackets, computationPackets}
				]];

				erroneousJobsToRetry = PickList[jobAndMKCPackets, canRetryErroneousJobQs];

				(* get the ManifoldKernelCommand/Notebook Job/Computation objects that timed out; exclude those that we've already determined are erroneous *)
				{newlyTimedOutJobQs, newlyTimedOutComputationQs} = Transpose[MapThread[
					Function[{jobAndMKCPacket, computationPacketsPerJob, erroneousJobQ},
						Module[{datesStarted, datesCompleted, elapsedTimes, timeOutQ, missingComputationsQ, datesCreated, jobStartDate},

							(* get the total elapsed time if it's still running for each ManifoldKernelCommand job or all Notebook Computation objects per job *)
							{datesStarted, datesCompleted, datesCreated} = Transpose[If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
								Lookup[ToList[jobAndMKCPacket], {DateStarted, DateCompleted, DateCreated}],
								Lookup[computationPacketsPerJob, {DateStarted, DateCompleted, DateCreated}]
							]];

							jobStartDate = Lookup[jobAndMKCPacket, DateCreated, Null];

							(* Note: In some cases the Object[Notebook, Job] has no Computations, which will cause error. exclude these cases for now and will account later *)
							missingComputationsQ = Or[
								MatchQ[datesStarted, _Missing],
								MatchQ[datesCompleted, _Missing]
							];

							elapsedTimes = If[missingComputationsQ,
								{},
								MapThread[
									Which[
										(* If DateCompleted is informed, do not worry about elaspsed time; computation is completed *)
										MatchQ[#2, _?DateObjectQ],
											Null,
										(* Otherwise, Use DateStarted to calculate elapsed time *)
										MatchQ[#1, _?DateObjectQ],
											Now - #1,
										(* If computation never started, use DateCreated to calculate elapsed time *)
										MatchQ[#3, _?DateObjectQ],
											Now - #3,
										(* Finally, if for any reason even DateCreated is not informed, this object is very wrong and let's set a dummy long elapsed time, so that it will be marked as timed out *)
										True,
											24 Hour
									]&,
									{datesStarted, datesCompleted, datesCreated}
								]
							];

							(* somewhat arbitrarily saying 12 hours is the timeout; by this time the kernel/computation has been terminated anyway (I am pretty sure?) *)
							timeOutQ = MatchQ[#, GreaterP[12 Hour]]& /@ elapsedTimes;

							(* exclude those we've already determined as erroneous *)
							If[missingComputationsQ,
								(* If Object[Notebook, Job] is missing Computations, either it's just created so that Computations have not been generated, or it's very wrong and can't be saved *)
								(* Therefore, here if the job start date was within 12 hours, we assume it's scenario 1, otherwise it's scenario 2 *)
								If[TrueQ[jobStartDate < Now - 12 Hour],
									{
										Not[erroneousJobQ],
										{}
									},
									{
										False,
										{}
									}
								],
								{
									MemberQ[timeOutQ, True] && Not[erroneousJobQ],
									timeOutQ
								}
							]
						]
					],
					{jobAndMKCPackets, computationPackets, erroneousJobQs}
				]];

				(* get the job objects for the newly timed out jobs *)
				newlyTimedOutJobs = PickList[jobAndMKCPackets, newlyTimedOutJobQs];

				(* We'll attempt to restart timed-out jobs *)

				allJobTemplateFiles = Download[Lookup[#, TemplateNotebookFile, Null], Object]& /@ jobAndMKCPackets;
				templateFileCounts = Counts[allJobTemplateFiles];

				(* Now redo the Compute as needed *)
				newRetryComputations = Map[
					Function[{jobAndMKCPacket},
						Module[{failCount, templateNotebook, zDriveFilePaths, mathematicaVersion, hardwareConfiguration},

							(* extract the TemplateNotebookFile *)
							templateNotebook = Download[Lookup[jobAndMKCPacket, TemplateNotebookFile], Object];
							{zDriveFilePaths, mathematicaVersion, hardwareConfiguration} = Lookup[jobAndMKCPacket, {ZDriveFilePaths, MathematicaVersion, HardwareConfiguration}];

							(* If the same computation has failed twice or more already, don't try to restart *)
							failCount = Lookup[templateFileCounts, templateNotebook, 0];
							If[failCount >= retryNumberLimit,
								Return[Null]
							];

							If[MatchQ[templateNotebook, ObjectReferenceP[Object[EmeraldCloudFile]]],
								If[NullQ[protocolNotebook],
									Block[{$Notebook = Object[LaboratoryNotebook, "id:kEJ9mqJXk0Pz"](* "Parallel Execute Notebook" *), $PersonID = Object[User, Emerald, Developer, "id:vXl9j57W0PqJ"](* Object[User, Emerald, Developer, "service+lab-infrastructure"] *)},
										With[{template = templateNotebook, zDrive = zDriveFilePaths, mmVer = mathematicaVersion, config = hardwareConfiguration},
											Compute[template, ZDriveFilePaths -> zDrive, MathematicaVersion -> mmVer, HardwareConfiguration -> config]
										]
									],
									Block[{$Notebook = protocolNotebook, $PersonID = Object[User, Emerald, Developer, "id:vXl9j57W0PqJ"](* Object[User, Emerald, Developer, "service+lab-infrastructure"] *)},
										With[{template = templateNotebook, zDrive = zDriveFilePaths, mmVer = mathematicaVersion, config = hardwareConfiguration},
											Compute[template, ZDriveFilePaths -> zDrive, MathematicaVersion -> mmVer, HardwareConfiguration -> config]
										]
									]
								],
								Null
							]
						]
					],
					Join[newlyTimedOutJobs, erroneousJobsToRetry]
				];

				newRetriedComputationsToAppend = MapThread[
					If[MatchQ[#2, ObjectP[]],
						{Link[Lookup[#1, Object]], Link[#2]},
						Nothing
					]&,
					{Join[newlyTimedOutJobs, erroneousJobsToRetry], newRetryComputations}
				];

				newRetriedComputationsAssoc = AssociationThread[Download[newRetriedComputationsToAppend[[All,1]], Object], Download[newRetriedComputationsToAppend[[All,2]], Object]];

				newRetryTimedOutJobs = Take[newRetryComputations, Length[newlyTimedOutJobs]];

				(* determine whether the computation we're dealing with has already completed *)
				jobCompletedQs = MapThread[
					Function[{jobAndMKCPacket, computationPacketsPerJob},
						If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
							(* for Object[Software, ManifoldKernelCommand] type, we look for Status to see if it is completed or not *)
							MatchQ[Lookup[jobAndMKCPacket, Status], Completed],
							(* for Object[Notebook, Job] type, for one to be considered as completed, should satisfy the following three conditions simultaneously *)
							And[
								(* does have Computations field populated *)
								Not[MatchQ[computationPacketsPerJob, {}]],
								(* all of Object[Notebook, Computation] are completed *)
								MatchQ[Lookup[computationPacketsPerJob, Status], {Completed..}],
								(* status of the job is Inactive *)
								MatchQ[Lookup[jobAndMKCPacket, Status], Inactive]
							]

						]
					],
					{jobAndMKCPackets, computationPackets}
				];


				(* determine whether ComputationsOutstanding should be True or not *)
				(* basically if all your computations are erroneous or actually complete or timed out, then it can be False *)
				computationsOutstanding = Not[MatchQ[
					MapThread[
						#1 || #2 || #3 &,
						{erroneousJobQs, jobCompletedQs, newlyTimedOutJobQs}
					],
					{True..}
				]];

				(* make upload packets for setting the Status to TimedOut here *)
				newlyTimedOutJobPackets = MapThread[
					Function[{timedOutJobAndMKCPacket, timedOutComputationPacketsPerJob, computationTimeOutQs},
						If[MatchQ[Lookup[timedOutJobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
							(* for Object[Software, ManifoldKernelCommand] type, upload Status->TimeOut directly *)
							<|Object -> Lookup[timedOutJobAndMKCPacket, Object], Status -> TimedOut|>,
							(* for Object[Notebook, Job], we need to upload Status->TimeOut for each individual Object[Notebook, Computation] in Computations field that were timed out *)
							<|Object -> Lookup[#, Object], Status -> TimedOut|>& /@ PickList[timedOutComputationPacketsPerJob, computationTimeOutQs]
						]
					],
					{
						newlyTimedOutJobs,
						PickList[computationPackets, newlyTimedOutJobQs],
						PickList[newlyTimedOutComputationQs, newlyTimedOutJobQs]
					}
				];

				(* get the newly erroneous computations *)
				allErroneousComputations = DeleteDuplicates[Flatten[{
					PickList[jobAndMKCPackets, erroneousJobQs],
					newlyTimedOutJobs
				}]];
				erroneousComputationsToAppend = DeleteCases[allErroneousComputations, ObjectP[initialErroneousComputations]];

				newRetryErroneousJobs = Lookup[newRetriedComputationsAssoc, Download[#, Object], Null]& /@ erroneousComputationsToAppend;

				allRetriedComputations = Cases[Join[newRetryComputations, retriedComputationsFromBadMKCs], ObjectP[]];

				(* If we have at least one retried computations, we should say the ComputationsOutstanding -> True *)
				finalComputationsOutstanding = Or[
					computationsOutstanding,
					Length[allRetriedComputations] > 0
				];

				(* make a new protocol packet *)
				newProtPacket = <|
					Object -> protObject,
					Append[ErroneousComputations] -> Link[Flatten[{Lookup[erroneousComputationsToAppend, Object, {}], Values[badKernelsToCommandsAssoc]}]],
					ComputationsOutstanding -> finalComputationsOutstanding,
					Append[ParallelComputations] -> Link[allRetriedComputations]
				|>;

				jobsFailedToRetry = Join[
					PickList[erroneousComputationsToAppend, newRetryErroneousJobs, Except[ObjectP[]]],
					PickList[newlyTimedOutJobs, newRetryTimedOutJobs, Except[ObjectP[]]]
				];

				{allFailedExpressions, allFailedMessages, allFailedOutputs, computationFailureMessages} = If[Length[jobsFailedToRetry] > 0,
					Transpose[
						Map[
							Function[{jobOrMKC},
								If[MatchQ[jobOrMKC, ObjectP[Object[Notebook, Job]]],
									(* Go through following steps for Object[Notebook, Job] *)
									Module[{lastComputation, history, expression, messages, output, parsedExpression, parsedOutput, computationErrorMessage, parsedMessages},
										(* Find the failed computation *)
										lastComputation = Last[Download[Experiment`Private`fastAssocLookup[fastAssoc, jobOrMKC, Computations], Object]];
										computationErrorMessage = Experiment`Private`fastAssocLookup[fastAssoc, lastComputation, ErrorMessage];
										(* Extract History of the failed computation *)
										history = Experiment`Private`fastAssocLookup[fastAssoc, lastComputation, History];
										(* Extract the expression we evaluated, messages and output *)
										{expression, messages, output} = Lookup[history, #]& /@ {Expression, Messages, Output};
										(* Convert both expression and output to string, and remove the Hold[]. this makes it easier for sci ops to copy *)
										parsedExpression = If[MatchQ[expression, _Missing],
											{Null},
											StringTake[ToString[#, FormatType -> InputForm], 6;;-2]& /@ expression
										];
										parsedOutput = If[MatchQ[output, _Missing],
											{Null},
											StringTake[ToString[#, FormatType -> InputForm], 6;;-2]& /@ output
										];
										parsedMessages = If[MatchQ[messages, _Missing],
											{Null},
											messages
										];

										(* output expression, message and output *)
										{parsedExpression, parsedMessages, parsedOutput, computationErrorMessage}
									],
									(* Go through following steps for Object[Software, ManifoldKernelCommand] *)
									Module[{MKCpacket, expression, messages, output, parsedMessage},
										MKCpacket = Experiment`Private`fetchPacketFromFastAssoc[jobOrMKC, fastAssoc];
										(* Extract Command, Messages and Result field *)
										{expression, messages, output} = Lookup[MKCpacket, #]& /@{Command, Messages, Result};
										(* Take only the second column of the messages, which contains the full text *)
										parsedMessage = messages[[All, 2]];

										(* output expression, message and output *)
										{expression, parsedMessage, output, Null}
									]
								]
							],
							jobsFailedToRetry
						]
					],
					{{}, {}, {}, {}}
				];

				ticketDescription = StringJoin[
					"Parallel computation jobs for protocol ",
					ToString[protObject, FormatType -> InputForm],
					" failed and automatic re-computation cannot be enqueued. Please investigate.\n",
					" Listed below are the erroneous computations:\n\n",
					StringJoin @@ MapThread[
						Function[{jobPacket, expressionPerJob, messagePerJob, outputPerJob, manifoldMessage},
							If[NullQ[manifoldMessage],
								StringJoin[
									"Computation: ",
									ToString[Lookup[jobPacket, Object], FormatType -> InputForm],
									"\n",
									If[MatchQ[jobPacket, PacketP[Object[Notebook, Job]]],
										(* For Object[Notebook, Job] there could be multiple commands in one run. Will therefore construct another MapThread to format the message *)
										StringJoin @@ MapThread[
											Function[{expression, message, output, index},
												StringJoin[
													"Input ",
													ToString[index],
													": ",
													(expression /. {Null -> "Unable to find Input"}),
													"\n",
													"Messages ",
													ToString[index],
													": ",
													ToString[message /. {Null -> "Unable to find message"}],
													"\n",
													"Output ",
													ToString[index],
													": ",
													(output /. {Null -> "Unable to find Output"}),
													"\n\n"
												]
											],
											{expressionPerJob, messagePerJob, outputPerJob, Range[1, Length[expressionPerJob]]}
										],
										(* For Object[Software, ManifoldCommand] there's only one single command, do not try to map over *)
										StringJoin[
											"Input: ",
											ToString[expressionPerJob],
											"\n",
											"Messages: ",
											ToString[messagePerJob],
											"\n",
											"Output: ",
											ToString[outputPerJob],
											"\n\n"
										]
									],
									"\n"
								],
								StringJoin[
									"Computation: ",
									ToString[Lookup[jobPacket, Object], FormatType -> InputForm],
									"failed with following messages from manifold:\n",
									manifoldMessage,
									"\n"
								]
							]
						],
						{jobsFailedToRetry, allFailedExpressions, allFailedMessages, allFailedOutputs, computationFailureMessages}
					]
				];

				ticketObject = If[Length[jobsFailedToRetry] > 0,
					ECL`RequestSupport[Operations,
						ToString[protObject, FormatType -> InputForm] <> " failed to complete or relaunch parallel executions.",
						ticketDescription,
						Status -> SciOpsSupport,
						AffectedProtocol -> protObject
					]
				];

				ManifoldEcho[ticketObject, "ticketObject"];
				ManifoldEcho[jobsFailedToRetry, "jobsFailedToRetry"];
				TagTrace["protocol.object", ToString[protObject]];
				TagTrace["ticket.object", ToString[ticketObject]];
				TagTrace["failed.jobs", ToString[jobsFailedToRetry]];

				Flatten[{newProtPacket, newlyTimedOutJobPackets}]
			]
		],
		{outstandingProtocolPackets, protJobAndMKCPackets, protComputationPackets, protMKCComputationPackets, protKernelPackets, protKernelJobPackets}
	]];

	Upload[allNewPackets]
]]];

