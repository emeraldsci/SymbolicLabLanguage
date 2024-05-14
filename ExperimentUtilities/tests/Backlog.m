(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*BacklogTime*)


DefineTests[BacklogTime,
	{
		Module[{name, report, notebook, protocol, team, processingProtocol},
			Example[{Basic, "Estimate the time for which a protocol will remain in the backlog:"},
				BacklogTime[protocol],
				1440 Minute,
				SetUp :> {
					name="BacklogTime--Estimate the time for which a protocol will remain in the backlog";
					report=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Report, QueueTimes],
						DateCreated -> Now,
						MinQueueTime -> 4 Hour,
						AverageQueueTime -> 3Hour,
						Replace[ProtocolQueueTimes] -> {
							{Object[Protocol, StockSolution], 2 Hour}
						}
					]];
					notebook=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[LaboratoryNotebook]
					]];
					Block[{$Notebook=notebook},
						protocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							Status -> Backlogged,
							Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}}
						]];
						processingProtocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							DateEnqueued -> Now - 6 Hour,
							Status -> Processing,
							OperationStatus -> OperatorStart,
							Replace[StatusLog] -> {{Now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}},
							Replace[CheckpointProgress] -> {{"Step 1", Now - 240 Minute, Now - 200 Minute}, {"Step 2", Now - 200 Minute, Null}}
						]];
					];
					team=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Team, Financing],
						MaxThreads -> 1,
						Replace[NotebooksFinanced] -> {Link[notebook, Financers]},
						Replace[Backlog] -> Link[{protocol}]
					]];
					ECL`InternalUpload`UploadNotebook[{protocol, processingProtocol}, notebook];
				},
				TearDown :> {EraseObject[{report, notebook, team, protocol, processingProtocol}, Force -> True, Verbose -> False]},
				Stubs :> {$MinThreadRelease=24Hour}]
		],

		Module[{name, report, notebook, protocol1, protocol2, team, processingProtocol1, processingProtocol2},
			(* Sometimes we round slightly differently but since this is just an estimate we're okay to be a little different *)
			Example[{Basic, "The backlog time for several protocols belong can be estimated:"},
				BacklogTime[{protocol1, protocol2}],
				{RangeP[1078 Minute,1082 Minute], RangeP[1198 Minute,1202 Minute]},
				SetUp :> {
					name="BacklogTime--The backlog time for several protocols belong to the same team can be estimated";
					report=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Report, QueueTimes],
						DateCreated -> Now,
						MinQueueTime -> 5 Hour,
						AverageQueueTime -> 4Hour,
						Replace[ProtocolQueueTimes] -> {
							{Object[Protocol, StockSolution], 6.5 Hour}
						}
					]];
					notebook=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[LaboratoryNotebook]
					]];
					Block[{$Notebook=notebook},
						protocol1=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							Status -> Backlogged,
							Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text1.", Null}, {"Step 2", 300 Minute, "Text2.", Null}}
						]];
						protocol2=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							Status -> Backlogged,
							Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 20 Minute, "Text1.", Null}, {"Step 2", 200 Minute, "Text2.", Null}}
						]];
						processingProtocol1=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							DateEnqueued -> Now - 6 Hour,
							DateConfirmed -> Now - 6 Hour,
							Status -> Processing,
							OperationStatus -> OperatorStart,
							Replace[StatusLog] -> {{Now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text1.", Null}, {"Step 2", 300 Minute, "Text2.", Null}},
							Replace[CheckpointProgress] -> {{"Step 1", Now - 240 Minute, Now - 180 Minute}, {"Step 2", Now - 180 Minute, Null}}
						]];
						processingProtocol2=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							DateEnqueued -> Now - 4 Hour,
							DateConfirmed -> Now - 4 Hour,
							Status -> Processing,
							OperationStatus -> OperatorReady,
							Replace[StatusLog] -> {{Now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 40 Minute, "Text1.", Null}, {"Step 2", 400 Minute, "Text2.", Null}},
							Replace[CheckpointProgress] -> {{"Step 1", Now - 240 Minute, Now - 200 Minute}, {"Step 2", Now - 300 Minute, Null}}
						]]
					];
					team=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Team, Financing],
						MaxThreads -> 2,
						Replace[NotebooksFinanced] -> {Link[notebook, Financers]},
						Replace[Backlog] -> Link[{protocol1, protocol2}]
					]];
					ECL`InternalUpload`UploadNotebook[{protocol1, protocol2, processingProtocol1, processingProtocol2}, notebook];
				},
				TearDown :> {EraseObject[{report, notebook, team, protocol1, protocol2, processingProtocol1, processingProtocol2}, Force -> True, Verbose -> False]},
				Stubs :> {
					$MinThreadRelease=24Hour,
					OpenThreads[_] := {{processingProtocol1},{processingProtocol2}}
				}
				]
		],

		Module[{name, report, notebook, protocol, team, processingProtocol, completedProtocol},
			Example[{Additional, "Already completed protocols could still affect the backlog time due to delay in a release of a thread for a both recently created and completed protocol:"},
				BacklogTime[protocol],
				30 Minute,
				SetUp :> {
					name="BacklogTime--Already completed protocols could still affect the backlog time due to delay in a release of a thread for a both recently created and completed protocol";
					report=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Report, QueueTimes],
						DateCreated -> Now,
						MinQueueTime -> 6 Hour,
						AverageQueueTime -> 5Hour,
						Replace[ProtocolQueueTimes] -> {
							{Object[Protocol, StockSolution], 5.75 Hour}
						}
					]];
					notebook=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[LaboratoryNotebook]
					]];
					Block[{$Notebook=notebook},
						protocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							Status -> Backlogged,
							Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}}
						]];
						processingProtocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							DateEnqueued -> Now - 6 Hour,
							DateConfirmed -> Now - 6 Hour,
							Status -> Processing,
							OperationStatus -> OperatorStart,
							Replace[StatusLog] -> {{Now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}},
							Replace[CheckpointProgress] -> {{"Step 1", Now - 240 Minute, Now - 200 Minute}, {"Step 2", Now - 200 Minute, Null}}
						]];
						completedProtocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							DateEnqueued -> Now - 23.5 Hour,
							DateConfirmed -> Now - 23.5 Hour,
							Status -> Completed,
							OperationStatus -> None,
							Replace[StatusLog] -> {{Now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}},
							Replace[CheckpointProgress] -> {{"Step 1", Now - 240 Minute, Now - 200 Minute}, {"Step 2", Now - 200 Minute, Now}}
						]]
					];
					team=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Team, Financing],
						MaxThreads -> 2,
						Replace[NotebooksFinanced] -> {Link[notebook, Financers]},
						Replace[Backlog] -> Link[{protocol}]
					]];
					ECL`InternalUpload`UploadNotebook[{protocol, processingProtocol, completedProtocol}, notebook];
				},
				TearDown :> {EraseObject[{report, notebook, team, protocol, processingProtocol, completedProtocol}, Force -> True, Verbose -> False]},
				Stubs :> {
					$MinThreadRelease=24Hour,
					OpenThreads[_] := {{completedProtocol}}
				}
				]
		],

		Module[{name, report, notebook, protocol, protocolNotInBacklog, team, processingProtocol, now},
			Example[{Additional, "Backlogged protocols not listed in the team's Backlog team are included in the estimate:"},
				BacklogTime[protocolNotInBacklog],
				2580 Minute,
				SetUp :> {
					now=Now;
					name="BacklogTime--Backlogged protocols not listed in the team's Backlog team are included in the estimate";
					report=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Report, QueueTimes],
						DateCreated -> now,
						MinQueueTime -> 7 Hour,
						AverageQueueTime -> 6Hour,
						Replace[ProtocolQueueTimes] -> {
							{Object[Protocol, StockSolution], 13.5 Hour}
						}
					]];
					notebook=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[LaboratoryNotebook]
					]];
					Block[{$Notebook=notebook},
						protocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>" (in backlog) "<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> now,
							Status -> Backlogged,
							Replace[StatusLog] -> {{now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}}
						]];
						protocolNotInBacklog=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>" (not in backlog) "<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> now + 1Hour,
							Status -> Backlogged,
							Replace[StatusLog] -> {{now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 310 Minute, "Text.", Null}}
						]];
						processingProtocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>" (starts processing) "<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> now,
							DateEnqueued -> now - 6 Hour,
							DateConfirmed -> now - 6 Hour,
							Status -> Processing,
							OperationStatus -> OperatorStart,
							Replace[StatusLog] -> {{now, Processing, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 600 Minute, "Text.", Null}}
						]];
						team=Upload[Association[
							Name -> name<>CreateUUID[],
							Type -> Object[Team, Financing],
							MaxThreads -> 1,
							Replace[NotebooksFinanced] -> {Link[notebook, Financers]},
							Replace[Backlog] -> Link[{protocol}]
						]]
					];
					ECL`InternalUpload`UploadNotebook[{protocol, processingProtocol, protocolNotInBacklog}, notebook];
				},
				TearDown :> {EraseObject[{report, notebook, team, protocol, protocolNotInBacklog, processingProtocol}, Force -> True, Verbose -> False]},
				Stubs :> {$MinThreadRelease=24Hour}
				]
		],

		Module[{name, report, notebook, runningProtocol, team},
			Example[{Messages, "NonBackloggedProtocols", "Print a message and returns $Failed if any of the input protocols do not actually have a status of Backlogged:"},
				BacklogTime[runningProtocol],
				$Failed,
				SetUp :> {
					name="BacklogTime--Print a message and returns $Failed if any of the input protocols do not actually have a status of Backlogged";
					report=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[Report, QueueTimes],
						DateCreated -> Now,
						MinQueueTime -> 7 Hour,
						AverageQueueTime -> 6Hour,
						Replace[ProtocolQueueTimes] -> {
							{Object[Protocol, StockSolution], 13.5 Hour}
						}
					]];
					notebook=Upload[Association[
						Name -> name<>CreateUUID[],
						Type -> Object[LaboratoryNotebook]
					]];
					Block[{$Notebook=notebook},
						runningProtocol=Upload[Association[
							Type -> Object[Protocol, StockSolution],
							Name -> name<>CreateUUID[],
							Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored],
							DateCreated -> Now,
							Status -> Processing,
							Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}},
							Replace[Checkpoints] -> {{"Step 1", 30 Minute, "Text.", Null}, {"Step 2", 300 Minute, "Text.", Null}}
						]];
						team=Upload[Association[
							Name -> name<>CreateUUID[],
							Type -> Object[Team, Financing],
							MaxThreads -> 1,
							Replace[NotebooksFinanced] -> {Link[notebook, Financers]},
							Replace[Backlog] -> Link[{runningProtocol}]
						]]
					];
					ECL`InternalUpload`UploadNotebook[{runningProtocol}, notebook];
				},
				TearDown :> {EraseObject[{report, notebook, team, runningProtocol}, Force -> True, Verbose -> False]},
				Messages :> {Experiment::NonBackloggedProtocols},
				Stubs :> {$MinThreadRelease=24Hour}
			]
		]
	}
];

(* ::Subsection:: *)
(*syncBacklog*)

DefineTests[
	UploadProtocolPriority,
	{
		Example[{Basic, "Turn a regular protocol into a priority protocol:"},
			UploadProtocolPriority[myProtocol, Priority -> True],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Basic, "Change the Queue position of a protocol:"},
			UploadProtocolPriority[myProtocol, QueuePosition -> First],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Basic, "Change the time at which a priority protocol is targeted to start:"},
			UploadProtocolPriority[myProtocol, Priority -> True, StartDate -> Now + 5 Hour],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Options, HoldOrder, "Indicate if the queue position of this protocol should be strictly enforced, regardless of the available resources in the lab:"},
			UploadProtocolPriority[myProtocol, HoldOrder -> False],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Options, Priority, "Indicate if (for an additional cost) this protocol will have first rights to shared lab resources before any standard protocols:"},
			UploadProtocolPriority[myProtocol, Priority -> True],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Options, StartDate, "Indicate the date at which the protocol will be targeted to start running in the lab. If StartDate->Null, the protocol will start as soon as possible:"},
			UploadProtocolPriority[myProtocol, StartDate -> Now + 5 Hour],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Options, QueuePosition, "Indicate the position that this protocol will be inserted in the Financing Team's experiment queue:"},
			UploadProtocolPriority[myProtocol, QueuePosition -> First],
			ObjectP[myProtocol],
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			}
		],
		Example[{Messages, "UploadProtocolPriority::ProtocolAlreadyStarted", "Protocol that have already started cannot have their priorities changed:"},
			UploadProtocolPriority[myProtocol, Priority -> False],
			$Failed,
			SetUp :> {
				myProtocol=Upload[<|Type -> Object[Protocol, Incubate], OperationStatus -> OperatorProcessing, Author -> Link[Object[User, Emerald, Developer, "thomas"], ProtocolsAuthored]|>];
			},
			TearDown :> {
				EraseObject[myProtocol, Force -> True, Verbose -> False];
			},
			Messages :> {
				UploadProtocolPriority::ProtocolAlreadyStarted
			}
		]
	}
];

(* ::Subsection:: *)
(*syncBacklog*)


DefineTests[
	syncBacklog,
	{
		Module[{notebook, protocol, team, script, scriptCompletedProtocol},
			Example[{Basic, "Returns a list of protocols whose status was changed from Backlogged to Processing:"},
				syncBacklog[team],
				{protocol},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					team=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];
					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, team},
			Example[{Basic, "Will not promote a protocol from Backlogged to Processing if there was a recently completed script that may still be running:"},
				syncBacklog[team],
				{},
				SetUp :> {
					$MinThreadRelease=5 Minute;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Will not promote a protocol from Backlogged to Processing if there was a recently completed script that may still be running::"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					team=Upload[<|Name -> "syncBacklog--Will not promote a protocol from Backlogged to Processing if there was a recently completed script that may still be running::"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 1, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];

					script=Upload[<|
						Type -> Object[Notebook, Script],
						Status -> Running,
						TimeConstraint -> 15 Minute
					|>];

					scriptCompletedProtocol=Upload[<|
						Type -> Object[Protocol, StockSolution],
						Status -> Completed,
						DateCompleted -> Now,
						Script -> Link[script, Protocols]
					|>];

					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];

					ECL`InternalUpload`UploadNotebook[scriptCompletedProtocol, notebook, Force->True];

					ECL`InternalUpload`UploadNotebook[script, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, protocolB, team},
			Example[{Basic, "Protocols will be promoted from the Backlog based on the order they appear in the Backlog field:"},
				syncBacklog[team],
				{protocolB},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					protocolB=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					team=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 1, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{
						protocolB, protocol
					}]|>];
					ECL`InternalUpload`UploadNotebook[{protocol, protocolB}, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, protocolB, protocolC, team},
			Example[{Basic, "Protocols will be promoted from the Backlog based on the order they appear in the Backlog field, with any protocols found via a search considered to be at the end of the list:"},
				syncBacklog[team],
				{protocolB},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					protocolB=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					protocolC=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now - 2 Hour, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					team=Upload[<|Name -> "syncBacklog--Returns a list of protocols whose status was changed from Backlogged to Processing:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 1, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{
						protocolB, protocol
					}]|>];
					ECL`InternalUpload`UploadNotebook[{protocol, protocolB, protocolC}, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, team},
			Example[{Basic, "Protocols whose status was updated will be removed from the team's Backlog:"},
				syncBacklog[team];Download[team, Backlog],
				{},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Protocols whose status was updated will be removed from the team's Backlog:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					team=Upload[<|Name -> "syncBacklog--Protocols whose status was updated will be removed from the team's Backlog:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];
					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, team},
			Example[{Basic, "Any protocols with a non-Backlogged status in the teams backlog will be removed:"},
				syncBacklog[team],
				{},
				Variables :> {notebook, protocol, team},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--Protocols whose status was updated will be removed from the team's Backlog:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];

					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> InCart, Replace[StatusLog] -> {{Now, InCart, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];

					team=Upload[<|Name -> "syncBacklog--Protocols whose status was updated will be removed from the team's Backlog:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];

					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebookA, teamA, notebookB, teamB, protocol},
			Example[{Additional, "If the team has no protocols in the Backlog or no available threads, an empty list will be returned:"},
				syncBacklog[{teamA, teamB}],
				{},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebookA=Upload[<|Name -> "syncBacklog--If the team has no protocols in the Backlog or no available threads, an empty list will be returned 1:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					notebookB=Upload[<|Name -> "syncBacklog--If the team has no protocols in the Backlog or no available threads, an empty list will be returned 2:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];

					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];

					teamA=Upload[<|Name -> "syncBacklog--If the team has no protocols in the Backlog or no available threads, an empty list will be returned 1:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebookA, Financers]}|>];

					teamB=Upload[<|Name -> "syncBacklog--If the team has no protocols in the Backlog or no available threads, an empty list will be returned 2:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 0, Replace[NotebooksFinanced] -> {Link[notebookB, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];

					ECL`InternalUpload`UploadNotebook[protocol, notebookB, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, team, protocolA, protocolB, protocolC},
			Example[{Additional, "The syncBacklog function will search for protocols with Backlogged status, and add them to the team's Backlog if they're alraedy not listed there:"},
				syncBacklog[{team}];Download[team, Backlog],
				{ObjectP[protocolA], ObjectP[protocolC], ObjectP[protocolB]},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--syncBacklog will search for protocols with Backlogged status, and add them to the team's Backlog if they're alraedy not listed there:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];

					protocolA=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, DateConfirmed -> Now - 12 Hour, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];

					protocolB=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, DateConfirmed -> Now - 11 Hour, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];

					protocolC=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, DateConfirmed -> Now - 10 Hour, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];

					team=Upload[<|Name -> "syncBacklog--syncBacklog will search for protocols with Backlogged status, and add them to the team's Backlog if they're alraedy not listed there:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 0, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocolA, protocolC}]|>];

					ECL`InternalUpload`UploadNotebook[{protocolA, protocolB, protocolC}, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, team, protocol},
			Example[{Options, Upload, "When Upload is False, returns update packets instead of updating the database:"},
				syncBacklog[team, Upload -> False],
				{
					PacketP[Object[Team]],
					PacketP[Object[Protocol]],
					PacketP[Object[Program]],
					PacketP[Object[Notification, Experiment]],
					PacketP[Object[Protocol]]
				},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					notebook=Upload[<|Name -> "syncBacklog--When Upload is False, returns a update packets instead of updating the database:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution],Site->Link[$Site]|>];
					team=Upload[<|Name -> "syncBacklog--When Upload is False, returns a update packets instead of updating the database:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];
					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, team, protocol, user},
			Example[{Options, UpdatedBy, "Indicate what person or which protocol updated the protocol status:"},
				syncBacklog[team, Upload -> False, UpdatedBy -> user],
				{
					PacketP[Object[Team]],
					PacketP[Object[Protocol]],
					KeyValuePattern[{Creator -> ObjectP[user]}],
					PacketP[Object[Notification, Experiment]],
					PacketP[Object[Protocol]]
				},
				SetUp :> {
					$MinThreadRelease=24Hour;
					$CreatedObjects={};
					user=Upload[<|Type -> Object[User], Name -> "syncBacklog--Indicate what person or which protocol updated the protocol status:"<>CreateUUID[]|>];
					notebook=Upload[<|Name -> "syncBacklog--Indicate what person or which protocol updated the protocol status:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution],Site->Link[$Site]|>];
					team=Upload[<|Name -> "syncBacklog--Indicate what person or which protocol updated the protocol status:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];
					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];
				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		],

		Module[{notebook, protocol, teamA, teamB},
			Example[{Additional, "Ignores teams which do not have notebooks:"},
				syncBacklog[{teamA, teamB}],
				{protocol},
				SetUp :> {
					$CreatedObjects={};
					$MinThreadRelease=24Hour;

					notebook=Upload[<|Name -> "syncBacklog--Ignores teams which do not have notebooks A:"<>CreateUUID[], Type -> Object[LaboratoryNotebook]|>];
					protocol=Upload[<|Author -> Link[Object[User, "Test user for notebook-less test protocols"], ProtocolsAuthored], DateCreated -> Now, Status -> Backlogged, Replace[StatusLog] -> {{Now, Backlogged, Link[Object[User, "Test user for notebook-less test protocols"]]}}, Type -> Object[Protocol, StockSolution]|>];
					teamA=Upload[<|Name -> "syncBacklog--Ignores teams which do not have notebooks A:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 5, Replace[NotebooksFinanced] -> {Link[notebook, Financers]}, Replace[Backlog] -> Link[{protocol}]|>];
					ECL`InternalUpload`UploadNotebook[protocol, notebook, Force->True];


					(* team has 2 threads, but one will be ignored because of the completed protocol so only one will get pushed to processing*)
					teamB=Upload[<|Name -> "syncBacklog--Ignores teams which do not have notebooks B:"<>CreateUUID[], Type -> Object[Team, Financing], MaxThreads -> 2|>];

				},
				TearDown :> {
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects]
				}
			]
		]
	},
	Stubs :> {$PersonID=Object[User, "Test user for notebook-less test protocols"]},
	SymbolTearDown :> {
		(* Erase all Notification objects that were created in the course of these tests *)
		EraseObject[
			Search[Object[Notification], Recipients == (Object[User, "Test user for notebook-less test protocols"] | Object[User, Emerald, Developer, "hendrik"] | Object[User, Emerald, Developer, "service+lab-infrastructure"])],
			Force -> True
		]
	}
];


DefineTests[
	syncShippingMaterials,
	{

		Example[{Basic, "Returns a list of protocols whose status was changed from ShippingMaterials to OperatorStart:"},
			syncShippingMaterials[Object[Team,Financing,"Test team 1 for syncShippingMaterials "<>$SessionUUID]];
			Download[Object[Protocol,SampleManipulation,"Test protocol 1 for syncShippingMaterials "<>$SessionUUID], {Status, OperationStatus, DateCreated, DateConfirmed, DateEnqueued, DateStarted}],
			{Processing, OperatorStart, _?DateObjectQ, _?DateObjectQ, _?DateObjectQ, Null},
			Stubs :> {
				$Notebook = Object[LaboratoryNotebook, "Test notebook 1 for syncShippingMaterials " <> $SessionUUID]
			}
		],
		Example[{Additional, "Returns a list of protocols whose status was changed from ShippingMaterials to OperatorStart for a subprotocol:"},
			syncShippingMaterials[Object[Team,Financing,"Test team 2 for syncShippingMaterials "<>$SessionUUID]];
			Download[
				{Object[Protocol,SampleManipulation,"Test parent protocol 2 for syncShippingMaterials "<>$SessionUUID], Object[Protocol,SampleManipulation,"Test protocol 2 for syncShippingMaterials "<>$SessionUUID]},
				{Status, OperationStatus, DateCreated, DateConfirmed, DateEnqueued, DateStarted}
			],
			{
				{Processing, OperatorReady, _?DateObjectQ, _?DateObjectQ, _?DateObjectQ, _?DateObjectQ},
				{Processing, OperatorReady, _?DateObjectQ, _?DateObjectQ, _?DateObjectQ, _?DateObjectQ}
			},
			Stubs :> {
				$Notebook = Object[LaboratoryNotebook, "Test notebook 2 for syncShippingMaterials " <> $SessionUUID]
			}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs,existingObjs,notebookIDs,siteIDs,teamIDs,modelSampleIDs,supplierIDs,productIDs,protocol,protocol2,parentProtocol,orders},

			objs = {
				Object[LaboratoryNotebook,"Test notebook 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Container,Site,"Test site 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Team,Financing,"Test team 1 for syncShippingMaterials "<>$SessionUUID],
				Model[Sample,"Test model sample 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Company,Supplier,"Test supplier 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Product,"Test product 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test protocol 1 for syncShippingMaterials "<>$SessionUUID],
				Object[LaboratoryNotebook,"Test notebook 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Container,Site,"Test site 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Team,Financing,"Test team 2 for syncShippingMaterials "<>$SessionUUID],
				Model[Sample,"Test model sample 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Company,Supplier,"Test supplier 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Product,"Test product 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test parent protocol 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test protocol 2 for syncShippingMaterials "<>$SessionUUID]
			};
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False];

			notebookIDs=CreateID[{Object[LaboratoryNotebook],Object[LaboratoryNotebook]}];
			siteIDs=CreateID[{Object[Container,Site],Object[Container,Site]}];
			teamIDs=CreateID[{Object[Team,Financing],Object[Team,Financing]}];
			modelSampleIDs=CreateID[{Model[Sample],Model[Sample]}];
			supplierIDs=CreateID[{Object[Company,Supplier],Object[Company,Supplier]}];
			productIDs=CreateID[{Object[Product],Object[Product]}];

			(* Upload objects *)
			Block[{$Notebook=notebookIDs[[1]]},
				Upload[
					{
						<|
							Object->notebookIDs[[1]],
							Name->"Test notebook 1 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->siteIDs[[1]],
							Name->"Test site 1 for syncShippingMaterials "<>$SessionUUID,
							Model->Link[Model[Container,Site,"id:jLq9jXvlnLeZ"],Objects]
						|>,
						<|
							Object->teamIDs[[1]],
							Name->"Test team 1 for syncShippingMaterials "<>$SessionUUID,
							MaxThreads->3,
							Replace[NotebooksFinanced]->{Link[notebookIDs[[1]],Financers]},
							DefaultMailingAddress->Link[siteIDs[[1]]]
						|>,
						<|
							Object->modelSampleIDs[[1]],
							Name->"Test model sample 1 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->supplierIDs[[1]],
							Name->"Test supplier 1 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->productIDs[[1]],
							ProductModel->Link[modelSampleIDs[[1]],Products],
							Amount->500 Milliliter,
							Supplier->Link[supplierIDs[[1]],Products],
							Author->Link[$PersonID],
							CatalogNumber->"Test product 1 for syncShippingMaterials "<>$SessionUUID,
							CatalogDescription->"Test product 1 for syncShippingMaterials "<>$SessionUUID,
							Name->"Test product 1 for syncShippingMaterials "<>$SessionUUID,
							Replace[Synonyms]->{"Test product 1 for syncShippingMaterials "<>$SessionUUID},
							Packaging->Single,
							SampleType->Bottle,
							Price->123 USD,
							NumberOfItems->1
						|>
					}
				];

				(* Upload notebook to sample and product *)
				ECL`InternalUpload`UploadNotebook[{modelSampleIDs[[1]],productIDs[[1]]},notebookIDs[[1]]];

				(* Create SM protocol 1 *)
				protocol=ExperimentSampleManipulation[
					{
						Transfer[Source->modelSampleIDs[[1]],Destination->PreferredContainer[500 Milliliter],Amount->200 Milliliter]
					},
					Name->"Test protocol 1 for syncShippingMaterials "<>$SessionUUID
				];

				(* Process the protocol object *)
				ConfirmProtocol[protocol];
				orders=Download[protocol,ShippingMaterials[[All,1]][Object]];
				Upload[<|Object->#,Status->Received|>&/@orders];

			];

			(* Upload objects *)
			Block[{$Notebook=notebookIDs[[2]]},
				Upload[
					{
						<|
							Object->notebookIDs[[2]],
							Name->"Test notebook 2 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->siteIDs[[2]],
							Name->"Test site 2 for syncShippingMaterials "<>$SessionUUID,
							Model->Link[Model[Container,Site,"id:jLq9jXvlnLeZ"],Objects]
						|>,
						<|
							Object->teamIDs[[2]],
							Name->"Test team 2 for syncShippingMaterials "<>$SessionUUID,
							MaxThreads->10,
							Replace[NotebooksFinanced]->{Link[notebookIDs[[2]],Financers]},
							DefaultMailingAddress->Link[siteIDs[[2]]]
						|>,
						<|
							Object->modelSampleIDs[[2]],
							Name->"Test model sample 2 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->supplierIDs[[2]],
							Name->"Test supplier 2 for syncShippingMaterials "<>$SessionUUID
						|>,
						<|
							Object->productIDs[[2]],
							ProductModel->Link[modelSampleIDs[[2]],Products],
							Amount->500 Milliliter,
							Supplier->Link[supplierIDs[[2]],Products],
							Author->Link[$PersonID],
							CatalogNumber->"Test product 2 for syncShippingMaterials "<>$SessionUUID,
							CatalogDescription->"Test product 2 for syncShippingMaterials "<>$SessionUUID,
							Name->"Test product 2 for syncShippingMaterials "<>$SessionUUID,
							Replace[Synonyms]->{"Test product 2 for syncShippingMaterials "<>$SessionUUID},
							Packaging->Single,
							SampleType->Bottle,
							Price->123 USD,
							NumberOfItems->1
						|>
					}
				];

				(* Upload notebook to sample and product *)
				ECL`InternalUpload`UploadNotebook[{modelSampleIDs[[2]],productIDs[[2]]},notebookIDs[[2]]];

				(* Order samples where required *)
				OrderSamples[productIDs[[2]], 1];

				(* Process the second protocol object *)
				parentProtocol=ExperimentSampleManipulation[
					{
						Transfer[Source->Model[Sample,"Milli-Q water"],Destination->PreferredContainer[500 Milliliter],Amount->200 Milliliter]
					},
					Name->"Test parent protocol 2 for syncShippingMaterials "<>$SessionUUID,
					Confirm->True
				];

				ECL`InternalUpload`UploadProtocolStatus[parentProtocol,OperatorProcessing];

				protocol2=ExperimentSampleManipulation[
					{
						Transfer[Source->modelSampleIDs[[2]],Destination->PreferredContainer[500 Milliliter],Amount->200 Milliliter]
					},
					Name->"Test protocol 2 for syncShippingMaterials "<>$SessionUUID,
					ParentProtocol->parentProtocol,
					Confirm->True
				];
				orders=Download[parentProtocol,ShippingMaterials[[All,1]][Object]];
				Upload[<|Object->#,Status->Received|>&/@orders];

			];
		]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		(* Erase all Notification objects that were created in the course of these tests *)
		Notifications`Private`eraseTestNotifications[];
		Module[{objs,existingObjs},
			objs = {
				Object[LaboratoryNotebook,"Test notebook 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Container,Site,"Test site 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Team,Financing,"Test team 1 for syncShippingMaterials "<>$SessionUUID],
				Model[Sample,"Test model sample 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Company,Supplier,"Test supplier 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Product,"Test product 1 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test protocol 1 for syncShippingMaterials "<>$SessionUUID],
				Object[LaboratoryNotebook,"Test notebook 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Container,Site,"Test site 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Team,Financing,"Test team 2 for syncShippingMaterials "<>$SessionUUID],
				Model[Sample,"Test model sample 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Company,Supplier,"Test supplier 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Product,"Test product 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test parent protocol 2 for syncShippingMaterials "<>$SessionUUID],
				Object[Protocol,SampleManipulation,"Test protocol 2 for syncShippingMaterials "<>$SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
	}
];


(* ::Subsection::Closed:: *)
(*PrioritizeBacklog*)


DefineTests[
	PrioritizeBacklog,
	{
		Example[{Basic, "Indicate the protocol should be next to run in the lab from the backlog:"},
			Module[
				{oldBacklog, newBacklog},

				oldBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				PrioritizeBacklog[Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"]];

				newBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				{oldBacklog, newBacklog}
			],
			{
				{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]},
				{Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}
			},
			TearDown :> (
				Upload[
					Association[
						Object -> Object[Team, Financing, "id:wqW9BP7kP1ew"],
						Replace[Backlog] -> Link[{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}]
					]
				]
			)
		],
		Example[{Basic, "Set the backlog order for all backlogged protocols:"},
			Module[
				{oldBacklog, newBacklog},

				oldBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				PrioritizeBacklog[{Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}];

				newBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				{oldBacklog, newBacklog}
			],
			{
				{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]},
				{Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}
			},
			TearDown :> (
				Upload[
					Association[
						Object -> Object[Team, Financing, "id:wqW9BP7kP1ew"],
						Replace[Backlog] -> Link[{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}]
					]
				]
			)
		],
		Example[{Basic, "When provided an incomplete list of protocols in the backlog, the input protocols are shifted to the front of the backlog order:"},
			Module[
				{oldBacklog, newBacklog},

				oldBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				PrioritizeBacklog[{Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}];

				newBacklog=Download[Object[Team, Financing, "id:wqW9BP7kP1ew"], Backlog[Object]];

				{oldBacklog, newBacklog}
			],
			{
				{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]},
				{Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"], Object[Protocol, HPLC, "id:J8AY5jD1jr9K"]}
			},
			TearDown :> (
				Upload[
					Association[
						Object -> Object[Team, Financing, "id:wqW9BP7kP1ew"],
						Replace[Backlog] -> Link[{Object[Protocol, HPLC, "id:J8AY5jD1jr9K"], Object[Protocol, SampleManipulation, "id:8qZ1VW0MWRYR"], Object[Protocol, FluorescenceKinetics, "id:rea9jlRpl7nO"]}]
					]
				]
			)
		],
		Example[{Messages, "InvalidProtocolStatuses", "Only allow reprioritization of Backlogged protocols:"},
			PrioritizeBacklog[Object[Protocol, SampleManipulation, "id:qdkmxzqoLODV"]],
			$Failed,
			Messages :> {PrioritizeBacklog::InvalidProtocolStatuses}
		],
		Example[{Messages, "MultipleFinancers", "Protocols' notebooks must only have a single financer:"},
			PrioritizeBacklog[Object[Protocol, HPLC, "id:rea9jlRpEbeB"]],
			$Failed,
			Messages :> {PrioritizeBacklog::MultipleFinancers}
		]
	}
];
