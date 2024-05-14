(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*DebugManifoldJob*)

(* TODO stub inputs with more believable and accurate data *)
DefineTests[DebugManifoldJob,
	{
		Example[{Basic, "Given an Object[Notebook,Computation] with a known failure source, returns the known failure source"},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID]],
			JobNoLongerExists
		],
		Example[{Options,BuildLambdaURL, "By default, do not include Lambda logs:"},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID]],
			_Grid,
			Stubs :> {
				determineCommonComputationFailure[___] = Null,
				ECL`Web`ConstellationRequest[KeyValuePattern["Path" -> "logs/manifold-lambda-logs"], ___] =
						<|
							"lambda_logs" ->
									<|
										"job_submission" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>,
										"fargate_recovery" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>
									|>
						|>,
				getFargateLogURL[___] = Hyperlink["mockURL"]
			}
		],
		Example[{Options,BuildLambdaURL, "If the failure source is not known, returns status and error log as well as links to the associated Lambda and Fargate logs"},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID],BuildLambdaURL->True],
			_Grid,
			Stubs :> {
				determineCommonComputationFailure[___] = Null,
				ECL`Web`ConstellationRequest[KeyValuePattern["Path" -> "logs/manifold-lambda-logs"], ___] =
					<|
						"lambda_logs" ->
							<|
								"job_submission" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>,
								"fargate_recovery" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>
							|>
					|>,
				getFargateLogURL[___] = Hyperlink["mockURL"]
			}
		],
		Example[{Basic, "If OutputFormat->Simplified and there is a known failure source, returns the known failure source and actionable tips."},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID], OutputFormat -> Simplified],
			_String,
			Stubs :> {
				determineCommonComputationFailure[___] = "known failure source and actionable tip"
			}
		],
		Example[{Basic, "If OutputFormat->Simplified but there is no known failure source, returns a helpful message."},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID], OutputFormat -> Simplified],
			"There is no known source of failure for this Manifold Job! For additional information, please use the OutputFormat option with value Table or Association.",
			Stubs :> {
				determineCommonComputationFailure[___] = Null
			}
		],
		Example[{Basic, "If OutputFormat->Table a table containing all known information on the Computation is returned."},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID], OutputFormat -> Table],
			_Grid,
			Stubs :> {
				ECL`Web`ConstellationRequest[KeyValuePattern["Path" -> "logs/manifold-lambda-logs"], ___] =
						<|
							"lambda_logs" ->
									<|
										"job_submission" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>,
										"fargate_recovery" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>
									|>
						|>,
				getFargateLogURL[___] = Hyperlink["mockURL"]
			}
		],
		Example[{Basic, "If OutputFormat->Association an association containing all known information on the Computation is returned."},
			DebugManifoldJob[Object[Notebook, Computation, "Test computation " <> $SessionUUID], OutputFormat -> Association],
			KeyValuePattern[{}],
			Stubs :> {
				ECL`Web`ConstellationRequest[KeyValuePattern["Path" -> "logs/manifold-lambda-logs"], ___] =
						<|
							"lambda_logs" ->
									<|
										"job_submission" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>,
										"fargate_recovery" -> <|"start_time" -> "2023-03-24T18:38:32.33Z", "url" -> "https://www.emeraldcloudlab.com/"|>
									|>
						|>,
				getFargateLogURL[___] = Hyperlink["mockURL"]
			}
		],
		Test["If a computation object does not exist, return $Failed:",
			DebugManifoldJob[Object[Notebook, Computation, "id:123"]],
			$Failed,
			Messages :> {Error::ExpectedValidObject}
		],
		Test["If a job object does not exist, return $Failed:",
			DebugManifoldJob[Object[Notebook, Job, "id:123"]],
			$Failed,
			Messages :> {Error::ExpectedValidObject}
		],
		Test["If a manifold kernel object does not exist, return $Failed:",
			DebugManifoldJob[Object[Software, ManifoldKernel, "id:123"]],
			$Failed,
			Messages :> {Error::ExpectedValidObject}
		],
		Test["If a manifold kernel command object does not exist, return $Failed:",
			DebugManifoldJob[Object[Software, ManifoldKernelCommand, "id:123"]],
			$Failed,
			Messages :> {Error::ExpectedValidObject}
		]
	},
	SymbolSetUp :> {
		Module[{computation},
			$CreatedObjects = {};
			computation = Upload[<|Type -> Object[Notebook, Computation], Name -> "Test computation " <> $SessionUUID, Status -> Staged|>];
			Upload[<|Object -> computation, Status -> Running|>];
			Upload[<|Object -> computation, Status -> Error, ErrorMessage -> "Error!"|>];
		];
	},
	SymbolTearDown :> Module[{},
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	]
];

(* ::Subsection::Closed:: *)
(*determineCommonComputationFailure*)

DefineTests[determineCommonComputationFailure,
	{
		Test["Detect running computation",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Running,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{
						Link[Object[Notebook,Computation,"id:-1"],ComputationFinancingTeam,"-1"],
						Link[Object[Notebook,Computation,"id:-2"],ComputationFinancingTeam,"-2"],
						Link[Object[Notebook,Computation,"id:-3"],ComputationFinancingTeam,"-3"]
					},
					ComputationQueue->{
						Link[Object[Notebook,Computation,"id:-4"],ComputationFinancingTeam,"-4"],
						Link[Object[Notebook,Computation,"id:-5"],ComputationFinancingTeam,"-5"]
					}
				|>,
				{}
			],
			Null,
			Messages:>{Warning::ComputationIsRunning}
		],
		Test["Detect queued computation",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Running,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{
						Link[Object[Notebook,Computation,"id:-2"],ComputationFinancingTeam,"-2"],
						Link[Object[Notebook,Computation,"id:-3"],ComputationFinancingTeam,"-3"]
					},
					ComputationQueue->{
						Link[Object[Notebook,Computation,"id:-4"],ComputationFinancingTeam,"-4"],
						Link[Object[Notebook,Computation,"id:-1"],ComputationFinancingTeam,"-1"],
						Link[Object[Notebook,Computation,"id:-4"],ComputationFinancingTeam,"-5"]
					}
				|>,
				{}
			],
			Null,
			Messages:>{Warning::ComputationIsQueued}
		],
		Test["Detect staged computation",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Staged,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			Null,
			Messages:>{Warning::ComputationInUndisputedStatus}
		],
		Test["Detect completed computation",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Completed,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			Null,
			Messages:>{Warning::ComputationInUndisputedStatus}
		],
		Test["Detect timed out computation",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->TimedOut,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			ComputationTimedOut,
			Stubs:>{DatabaseMemberQ[Object[Notebook,Job,"id:-1"]]=True}
		],
		Test["Detect full queue",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Null,ErrorMessage->Null|>,
				<|Object->Object[Notebook,Job,"id:-1"],OriginalSLLCommit->"",SLLVersion->""|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->3,
					RunningComputations->{
						Link[Object[Notebook,Computation,"id:-2"],ComputationFinancingTeam,"-2"],
						Link[Object[Notebook,Computation,"id:-3"],ComputationFinancingTeam,"-3"],
						Link[Object[Notebook,Computation,"id:-4"],ComputationFinancingTeam,"-4"]
					},
					ComputationQueue->{}
				|>,
				{}
			],
			QueueIsFull
		],
		Test["Detect distro does not exist",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Null,ErrorMessage->Null|>,
				<|
					Object->Object[Notebook,Job,"id:-1"],
					OriginalSLLCommit->"some_commit_that_doesnt_exist",
					SLLVersion->"some_sll_version_that_doesnt_exist"
				|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			DistroDoesNotExist,
			Stubs:>{
				DatabaseMemberQ[Object[Notebook,Computation,"id:-1"]]:=True,
				DatabaseMemberQ[Object[Notebook,Job,"id:-1"]]:=True
			}
		],
		Test["Detect deleted job",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Null,ErrorMessage->Null|>,
				<|
					Object->Object[Notebook,Job,"id:-1"],
					OriginalSLLCommit->"some_commit_that_doesnt_exist",
					SLLVersion->"some_sll_version_that_doesnt_exist"
				|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			JobNoLongerExists,
			Stubs:>{
				Search[Object[Software,Distro],___]:={1,2,3},
				DatabaseMemberQ[Object[Notebook,Job,"id:-1"]]:=False
			}
		],
		Test["Detect launching job failure",
			True,
			True
		],
		Test["Detect computation error messages are reported",
			determineCommonComputationFailure[
				<|Object->Object[Notebook,Computation,"id:-1"],Status->Null,ErrorMessage->"An error message"|>,
				<|
					Object->Object[Notebook,Job,"id:-1"],
					OriginalSLLCommit->"some_commit_that_doesnt_exist",
					SLLVersion->"some_sll_version_that_doesnt_exist"
				|>,
				<|
					Object->Object[Team,Financing,"id:-1"],
					MaxComputationThreads->10,
					RunningComputations->{},
					ComputationQueue->{}
				|>,
				{}
			],
			Null,
			Messages:>{Warning::ComputationErrorMessage},
			Stubs:>{
				Search[Object[Software,Distro],___]:={1,2,3},
				DatabaseMemberQ[Object[Notebook,Computation,"id:-1"]]:=True,
				DatabaseMemberQ[Object[Notebook,Job,"id:-1"]]:=True
			}
		]
	}
];

DefineTests[PlotTestSuiteTimeline,
	{
		Example[{Basic,"Basic suite timeline plot:"},
			PlotTestSuiteTimeline[Object[UnitTest,Suite,"PlotTestSuiteTimeline Unit Test Suite "<>$SessionUUID]],
			_Legended
		],
		Example[{Basic,"Suite timeline plot on specific database:"},
			PlotTestSuiteTimeline[Object[UnitTest,Suite,"PlotTestSuiteTimeline Unit Test Suite "<>$SessionUUID],Database->1],
			_Legended|_Graphics
		],
		Example[{Basic,"Suite timeline plot on status:"},
			PlotTestSuiteTimeline[Object[UnitTest,Suite,"PlotTestSuiteTimeline Unit Test Suite "<>$SessionUUID],Status->Passed],
			_Legended|_Graphics
		]
	},
	SymbolSetUp :> {
		setUpUnitTestSuite["PlotTestSuiteTimeline Unit Test Suite",Search,Download]
	},
	SymbolTearDown :> {
		tearDownUnitTestSuite["PlotTestSuiteTimeline Unit Test Suite",Search,Download]
	}
];

DefineTests[PlotTestSuiteSummaries,
	{
		Example[{Basic,"Plots test summaries for a given Object[UnitTest, Suite]."},
			PlotTestSuiteSummaries[Object[UnitTest,Suite,"PlotTestSuiteSummaries Unit Test Suite "<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Plots test summaries for a given Object[UnitTest, Function]."},
			PlotTestSuiteSummaries[Object[UnitTest,Function,"Download "<>$SessionUUID]],
			_Grid
		],
		Example[{Options,Status,"Plots test summaries for unit tests that match the given status."},
			PlotTestSuiteSummaries[Object[UnitTest,Suite,"PlotTestSuiteSummaries Unit Test Suite "<>$SessionUUID],Status->Failed],
			_Grid
		]
	},
	SymbolSetUp :> {
		setUpUnitTestSuite["PlotTestSuiteSummaries Unit Test Suite",Search,Download]
	},
	SymbolTearDown :> {
		tearDownUnitTestSuite["PlotTestSuiteSummaries Unit Test Suite",Search,Download]
	}
];

(* Creates a mock Object[EmeraldCloudFile] to be used in setUpUnitTestSuite *)
setupCloudFile[CloudFileName_String]:=Module[{},
	Upload[
		<|
			Type -> Object[EmeraldCloudFile],
			Name -> CloudFileName,
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/1234567890.nb", "qwertyuiopasdfghjklzxcvbnm"]
		|>
	];
];

(* Creates a Object[UnitTest,Suite] that has one passing and one failing Object[UnitTest,Function] *)
setUpUnitTestSuite[TestSuiteName_String,FirstFunctionSymbol_Symbol,SecondFunctionSymbol_Symbol]:=Module[{},
	(* Create CloudFiles *)
	setupCloudFile[ToString[FirstFunctionSymbol]<>" Cloud File "<>$SessionUUID];
	setupCloudFile[ToString[SecondFunctionSymbol]<>" Cloud File "<>$SessionUUID];

	(* Create the unit test functions *)
	With[
		{
			firstUnitTestPacket=
       <|
				 Type->Object[UnitTest,Function],
				 Name->ToString[FirstFunctionSymbol]<>" "<>$SessionUUID,
				 DeveloperObject->True,
				 Function->FirstFunctionSymbol,
				 DateCreated->Now-10 Minute,
				 DateEnqueued->Now-9 Minute,
				 DateStarted->Now-8 Minute,
				 DateCompleted->Now-5 Minute,
				 Database->0,
				 Status->Passed,
				 Passed->True,
				 EmeraldTestSummary->Link[Object[EmeraldCloudFile,ToString[FirstFunctionSymbol]<>" Cloud File "<>$SessionUUID]]
			 |>,
			secondUnitTestPacket =
       <|
				 Type->Object[UnitTest,Function],
				 Name->ToString[SecondFunctionSymbol]<>" "<> $SessionUUID,
				 DeveloperObject->True,
				 Function->SecondFunctionSymbol,
				 DateCreated->Now-9 Minute,
				 DateEnqueued->Now-8 Minute,
				 DateStarted->Now-7 Minute,
				 DateCompleted->Now-6 Minute,
				 Database->1,
				 Status->Failed,
				 Passed->False,
				 EmeraldTestSummary->Link[Object[EmeraldCloudFile,ToString[SecondFunctionSymbol]<>" Cloud File "<>$SessionUUID]]
			 |>
		},
		Upload[{firstUnitTestPacket,secondUnitTestPacket}];
	];
	(* Create the unit test suite *)
	With[
		{
			testSuitePacket =
       <|
				 Type->Object[UnitTest,Suite],
				 Name->TestSuiteName<>" "<>$SessionUUID,
				 DeveloperObject->True,
				 DateCreated->Now-11 Minute,
				 DateCompleted->Now-4 Minute,
				 Replace[UnitTestStatus]->{Passed, Failed},
				 Replace[UnitTestedItems]->{FirstFunctionSymbol, SecondFunctionSymbol},
				 Replace[UnitTests]->{
					 Link[Object[UnitTest,Function,ToString[FirstFunctionSymbol]<>" "<>$SessionUUID],UnitTestSuite],
					 Link[Object[UnitTest,Function,ToString[SecondFunctionSymbol]<>" "<>$SessionUUID],UnitTestSuite]
				 }
			|>
		},
		Upload[testSuitePacket];
	];
];

(* Deletes the objects created by setUpUnitTestSuite*)
tearDownUnitTestSuite[TestSuiteName_String,FirstFunctionSymbol_Symbol,SecondFunctionSymbol_Symbol]:=Module[
	{objects,existingObjects},
	(* All objects created for this unit test *)
	objects={
		Object[UnitTest,Suite,TestSuiteName<>" "<>$SessionUUID],
		Object[UnitTest,Function,ToString[FirstFunctionSymbol]<>" "<>$SessionUUID],
		Object[UnitTest,Function,ToString[SecondFunctionSymbol]<>" "<>$SessionUUID],
		Object[EmeraldCloudFile,ToString[FirstFunctionSymbol]<>" Cloud File "<>$SessionUUID],
		Object[EmeraldCloudFile,ToString[SecondFunctionSymbol]<>" Cloud File "<>$SessionUUID]
	};
	existingObjects = PickList[objects,DatabaseMemberQ[objects]];
	EraseObject[existingObjects,Force->True,Verbose->False];
];

(* Deletes the objects created by setUpUnitTestSuite*)
tearDownUnitTestSuite[TestSuiteName_String,FirstFunctionSymbol_Symbol,SecondFunctionSymbol_Symbol]:=Module[
	{objects,existingObjects},
	(* All objects created for this unit test *)
	objects={
		Object[UnitTest,Suite,TestSuiteName<>" "<>$SessionUUID],
		Object[UnitTest,Function,ToString[FirstFunctionSymbol]<>" "<>$SessionUUID],
		Object[UnitTest,Function,ToString[SecondFunctionSymbol]<>" "<>$SessionUUID],
		Object[EmeraldCloudFile,ToString[FirstFunctionSymbol]<>" Cloud File "<>$SessionUUID],
		Object[EmeraldCloudFile,ToString[SecondFunctionSymbol]<>" Cloud File "<>$SessionUUID]
	};
	existingObjects = PickList[objects,DatabaseMemberQ[objects]];
	EraseObject[existingObjects,Force->True,Verbose->False];
];

(* ::Subsection::Closed:: *)
(*getFargateLogURL*)
DefineTests[getFargateLogURL,
	{
		Example[{Basic,"Works on a computation:"},
			getFargateLogURL[Object[Notebook,Computation,"id:-1"]],
			_Hyperlink,
			Stubs:>{
				Download[Object[Notebook,Computation,"id:-1"],{
					Packet[FargateClusterName,TaskID,DateCreated],
					Packet[Job[{HardwareConfiguration,MathematicaVersion}]]
				}]:={
					<|
						FargateClusterName->"manifold-mm-cluster-stage",
						TaskID->"a6b2e71c40d540a48e6620e336aac6a7",
						DateCreated->DateObject[{2024,2,13,13,26,6.28004},"Instant","Gregorian",-5.],
						Object->Object[Notebook,Computation,"id:-1"],
						ID->"id:-1",Type->Object[Notebook,Computation]
					|>,
					<|
						HardwareConfiguration->Standard,
						MathematicaVersion->"12.0.1",
						Object->Object[Notebook,Job,"id:-2"],
						ID->"id:-2",
						Type->Object[Notebook,Job]
					|>}}
		],
		Example[{Basic,"Works on packets:"},
			getFargateLogURL[
				<|
					FargateClusterName -> "manifold-mm-cluster-stage",
					TaskID -> "a6b2e71c40d540a48e6620e336aac6a7",
					DateCreated -> DateObject[{2024, 2, 13, 13, 26, 6.28004}, "Instant","Gregorian", -5.],
					Object -> Object[Notebook, Computation, "id:-1"],
					ID -> "id:-1", Type -> Object[Notebook, Computation]
				|>,
				<|
					HardwareConfiguration -> Standard,
					MathematicaVersion -> "12.0.1",
					Object -> Object[Notebook, Job, "id:-2"],
					ID -> "id:-2",
					Type -> Object[Notebook, Job]
				|>],
			_Hyperlink
		],
		Example[{Basic,"If there is no Job for the Computation, returns Null:"},
			getFargateLogURL[
				<|FargateClusterName -> "manifold-mm-cluster-stage",
				TaskID -> "a6b2e71c40d540a48e6620e336aac6a7",
				DateCreated -> DateObject[{2024, 2, 13, 13, 26, 6.28004}, "Instant","Gregorian", -5.],
				Object -> Object[Notebook, Computation, "id:-1"],
				ID -> "id:-1", Type -> Object[Notebook, Computation]
				|>,
				Null],
			Null
		]
	}
]