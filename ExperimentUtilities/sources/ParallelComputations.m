(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*updateParallelComputationFields*)

updateParallelComputationFields[] := Module[
	{shorterProtocolTypes, outstandingProts, outstandingProtocolPackets, protJobAndMKCPackets, protComputationPackets, allNewPackets},

	(* this is so we only do Object[Protocol], Object[Maintenance], and Object[Qualification] and not all the subtypings *)
	shorterProtocolTypes = Select[ProtocolTypes[], Length[#] == 1&];

	(* get all the outstanding protocols and download information from their jobs *)
	outstandingProts = Search[shorterProtocolTypes, ComputationsOutstanding == True];
	{
		outstandingProtocolPackets,
		protJobAndMKCPackets,
		protComputationPackets
	} = If[MatchQ[outstandingProts, {}],
		{{}, {}, {}},
		Quiet[
			Transpose[Download[
				outstandingProts,
				{
					Packet[ComputationsOutstanding, ErroneousComputations, ParallelComputations, Author],
					(* we are downloading necessary fields for Object[Notebook, Job], Object[Software, ManifoldKernelCommand] types both *)
					Packet[ParallelComputations[{Command, Messages, Status, DateCreated, DateStarted, DateCompleted, Computations}]],
					(* downloading fields necessary needed for Object[Notebook, Computation] as well *)
					Packet[ParallelComputations[Computations[{History, Status, ErrorMessage, DateCreated, DateStarted, DateCompleted}]]]
				}
			]],
			{Download::FieldDoesntExist, Download::NotLinkField}
		]
	];

	(* generate the new protocol packets for each one *)
	(* if all the jobs are complete then set ComputationsOutstanding back to Null *)
	(* also make packets for things that are going to be set to TimedOut*)
	allNewPackets = Flatten[MapThread[
		Function[{protocolPacket, jobAndMKCPackets, computationPackets},
			Module[
				{initialErroneousComputations, erroneousJobQs, jobCompletedQs, newlyTimedOutJobQs, computationsOutstanding,
					allErroneousComputations, erroneousComputationsToAppend, newProtPacket, protObject, newlyTimedOutJobs,
					newlyTimedOutComputationQs, newlyTimedOutJobPackets
				},

				(* pull out the protocol object *)
				protObject = Lookup[protocolPacket, Object];

				(* pull out the erroneous jobs that we have already accounted for *)
				initialErroneousComputations = Download[Lookup[protocolPacket, ErroneousComputations], Object];

				(* determine whether any of the manifoldKernelCommand packets are erroneous *)
				erroneousJobQs = MapThread[
					Function[{jobAndMKCPacket, computationPacketsPerJob},
						Module[{alreadyErroneousQ, computationBadQ, alreadyTimedOutQ},

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

							Or[
								alreadyErroneousQ,
								alreadyTimedOutQ,
								MemberQ[computationBadQ, True]
							]
						]
					],
					{jobAndMKCPackets, computationPackets}
				];

				(* get the ManifoldKernelCommand/Notebook Job/Computation objects that timed out; exclude those that we've already determined are erroneous *)
				{newlyTimedOutJobQs, newlyTimedOutComputationQs} = Transpose[MapThread[
					Function[{jobAndMKCPacket, computationPacketsPerJob, erroneousJobQ},
						Module[{datesStarted, datesCompleted, elapsedTimes, timeOutQ},

							(* get the total elapsed time if it's still running for each ManifoldKernelCommand job or all Notebook Computation objects per job *)
							{datesStarted, datesCompleted} = Transpose[If[MatchQ[Lookup[jobAndMKCPacket, Type], Object[Software, ManifoldKernelCommand]],
								Lookup[ToList[jobAndMKCPacket], {DateStarted, DateCompleted}],
								Lookup[computationPacketsPerJob, {DateStarted, DateCompleted}]
							]];
							elapsedTimes = MapThread[
								If[MatchQ[{#1, #2}, {_?DateObjectQ, Null}],
									Now - #1,
									Null
								]&,
								{datesStarted, datesCompleted}
							];

							(* somewhat arbitrarily saying 12 hours is the timeout; by this time the kernel/computation has been terminated anyway (I am pretty sure?) *)
							timeOutQ = MatchQ[#, GreaterP[12 Hour]]& /@ elapsedTimes;

							(* exclude those we've already determined as erroneous *)
							{
								MemberQ[timeOutQ, True] && Not[erroneousJobQ],
								timeOutQ
							}
						]
					],
					{jobAndMKCPackets, computationPackets, erroneousJobQs}
				]];

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

				(* get the job objects for the newly timed out jobs *)
				newlyTimedOutJobs = PickList[jobAndMKCPackets, newlyTimedOutJobQs];

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

				(* make a new protocol packet *)
				newProtPacket = <|
					Object -> protObject,
					Append[ErroneousComputations] -> Link[Lookup[erroneousComputationsToAppend, Object, {}]],
					ComputationsOutstanding -> computationsOutstanding
				|>;

				(* make an asana task in SciOps for any newly erroneous computations  *)
				If[Not[MatchQ[erroneousComputationsToAppend, {}]],
					CreateAsanaTask[<|
						Name -> "Parallel Executions did not complete for " <> ToString[protObject, InputForm],
						Completed -> False,
						Notes -> StringJoin[
							"Root Protocol: " <> ToString[protObject, InputForm], "\n",
							"Root Protocol Author: " <> ToString[NamedObject[Lookup[protocolPacket, Author]], InputForm] <> "\n\n",
							"The following computation jobs that were enqueued as part of a parallel task execution failed to complete successfully:\n",
							Sequence @@ Map[
								StringJoin[
									ToString[Lookup[#, Object], InputForm] <> "\n",
									"\tSTARTED: " <> DateString[TimeZoneConvert[Lookup[#, DateCreated], "America/Los_Angeles"]] <> "\n"
								]&,
								erroneousComputationsToAppend
							],
							"\n",
							"For any Object[Software, ManifoldKernelCommand] type, check Command field for the specific call(s) that this job performed. Also check the Messages and Result fields of these jobs in order to determine why these calls failed to complete or completed with errors.\n",
							"For any Object[Notebook, Job] type, check TemplateNotebookFile field for the specific call(s) that this job performed. Also check the Computations field of these jobs in order to determine why these calls failed to complete or completed with errors.\n",
							"Please rerun these calls as necessary in order to complete them."
						],
						Sections -> {"Parallel\ Execute\ Failures"},
						Tags -> {"P5"},
						DueDate -> (Now + 1 Day),
						Projects -> {"Scientific Operations"}
					|>]
				];

				(* make an asana task in SciOps for any newly timed out computations  *)
				If[Not[MatchQ[newlyTimedOutJobs, {}]],
					CreateAsanaTask[<|
						Name -> "Parallel Executions timed out for " <> ToString[protObject, InputForm],
						Completed -> False,
						Notes -> StringJoin[
							"Root Protocol: " <> ToString[protObject, InputForm], "\n",
							"Root Protocol Author: " <> ToString[NamedObject[Lookup[protocolPacket, Author]], InputForm] <> "\n\n",
							"The following computation jobs that were enqueued as part of a parallel task execution failed to complete successfully:\n",
							Sequence @@ Map[
								StringJoin[
									ToString[Lookup[#, Object], InputForm] <> "\n",
									"\tSTARTED: " <> DateString[TimeZoneConvert[Lookup[#, DateCreated], "America/Los_Angeles"]] <> "\n"
								]&,
								newlyTimedOutJobs
							],
							"\n",
							"For any Object[Software, ManifoldKernelCommand] type, check the ManifoldKernel field of these jobs to determine if any other ManifoldKernelCommand jobs on the same Kernel may have failed causing this one to also fail.  You may see all the ManifoldKernelCommand jobs on the same Kernel by doing Download[" <> ToString[Lookup[Cases[newlyTimedOutJobs, ObjectP[Object[Software, ManifoldKernelCommand]]], Object, {}], InputForm] <> ", ManifoldKernel[Commands]].\n",
							"Please rerun these calls as necessary in order to complete them."
						],
						Sections -> {"Parallel\ Execute\ Failures"},
						Tags -> {"P5"},
						DueDate -> (Now + 1 Day),
						Projects -> {"Scientific Operations"}
					|>]
				];

				Flatten[{newProtPacket, newlyTimedOutJobPackets}]
			]
		],
		{outstandingProtocolPackets, protJobAndMKCPackets, protComputationPackets}
	]];

	Upload[allNewPackets]
];
