(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*updateParallelComputationFields*)

DefineTests[
	updateParallelComputationFields,
	{
		Test["Update the ComputationsOutstanding and ErroneousComputations fields of all protocol objects to update:",
			updateParallelComputationFields[];
			{
				Download[
					{
						Object[Protocol, HPLC, "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID],
						Object[Protocol, Filter, "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID],
						Object[Protocol, Transfer, "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID]
					},
					{
						ComputationsOutstanding,
						ErroneousComputations
					}
				],
				Download[{
					Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests"<>$SessionUUID],
					Object[Notebook, Computation, "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID]
				}, Status],
				(* Call the function again since theoretically after the first call we should have updated all the test protocols to ComputationsOutStanding->False, so we can cover the case where no protocols are ComputationsOutStanding->True and make sure no errors are thrown *)
				updateParallelComputationFields[]
			},
			{
				{
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID]]}},
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID]]}},
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID]]}}
				},
				{TimedOut, TimedOut},
				{}
			}
		]
	},
	Stubs :> {
		CreateAsanaTask[x_]:=x,
		$DeveloperSearch = True,
		$RequiredSearchName = $SessionUUID
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Protocol, HPLC, "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Filter, "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Transfer, "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{testProt1, testProt2, testProt3, manifoldKernelCommand1, manifoldKernelCommand2, manifoldKernelCommand3,
			manifoldKernelCommand4, manifoldKernelCommand5, manifoldKernelCommand6, job1, job2, job3, job4, job5, job6, comp1, comp2, comp3, comp4, comp5, comp6},

			{
				(*1*)testProt1,
				(*2*)testProt2,
				(*3*)testProt3,
				(*4*)manifoldKernelCommand1,
				(*5*)manifoldKernelCommand2,
				(*6*)manifoldKernelCommand3,
				(*7*)manifoldKernelCommand4,
				(*8*)manifoldKernelCommand5,
				(*9*)manifoldKernelCommand6,
				(*10*)job1,
				(*11*)job2,
				(*12*)job3,
				(*13*)job4,
				(*14*)job5,
				(*15*)job6,
				(*16*)comp1,
				(*17*)comp2,
				(*18*)comp3,
				(*19*)comp4,
				(*20*)comp5,
				(*21*)comp6
			} = CreateID[{
				(*1*)Object[Protocol, HPLC],
				(*2*)Object[Protocol, Filter],
				(*3*)Object[Protocol, Transfer],
				(*4*)Object[Software, ManifoldKernelCommand],
				(*5*)Object[Software, ManifoldKernelCommand],
				(*6*)Object[Software, ManifoldKernelCommand],
				(*7*)Object[Software, ManifoldKernelCommand],
				(*8*)Object[Software, ManifoldKernelCommand],
				(*9*)Object[Software, ManifoldKernelCommand],
				(*10*)Object[Notebook, Job],
				(*11*)Object[Notebook, Job],
				(*12*)Object[Notebook, Job],
				(*13*)Object[Notebook, Job],
				(*14*)Object[Notebook, Job],
				(*15*)Object[Notebook, Job],
				(*16*)Object[Notebook, Computation],
				(*17*)Object[Notebook, Computation],
				(*18*)Object[Notebook, Computation],
				(*19*)Object[Notebook, Computation],
				(*20*)Object[Notebook, Computation],
				(*21*)Object[Notebook, Computation]
			}];

			Upload[{
				<|
					Object -> testProt1,
					DeveloperObject -> True,
					Name -> "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand1, manifoldKernelCommand2, job1, job2}],
					Replace[ErroneousComputations] -> {Link[manifoldKernelCommand2]}
				|>,
				<|
					Object -> testProt2,
					DeveloperObject -> True,
					Name -> "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand3, manifoldKernelCommand4, job3, job4}]
				|>,
				<|
					Object -> testProt3,
					DeveloperObject -> True,
					Name -> "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand5, manifoldKernelCommand6, job5, job6}]
				|>,
				<|
					Object -> manifoldKernelCommand1,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 1",
					Result -> "2",
					Replace[Messages] -> {},
					Status -> Completed,
					DateCreated -> Now,
					DateStarted -> Now + 1 Second,
					DateCompleted -> Now + 5 Second
				|>,
				<|
					Object -> manifoldKernelCommand2,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "Message[Error::ThrowingAMessage]",
					Result -> Null,
					Replace[Messages] -> {{"Error::ThrowingAMessage", "Error::ThrowingAMessage :  -- Message text not found --", "Hold[Message[Error::ThrowingAMessage]]"}},
					Status -> Completed,
					DateCreated -> Now,
					DateStarted -> Now + 1 Second,
					DateCompleted -> Now + 5 Second
				|>,
				<|
					Object -> manifoldKernelCommand3,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "Import[\"not-a-real-file.txt\"]",
					Result -> "$Failed",
					Replace[Messages] -> {{"Import::nffil", "Import::nffil : File not-a-real-file.txt not found during Import.", "Hold[Message[Import::nffil, \"not-a-real-file.txt\"]]"}},
					Status -> Completed,
					DateCreated -> Now,
					DateStarted -> Now + 1 Second,
					DateCompleted -> Now + 5 Second
				|>,
				<|
					Object -> manifoldKernelCommand4,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 4 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 2",
					Result -> "3",
					Replace[Messages] -> {},
					Status -> Completed,
					DateCreated -> Now,
					DateStarted -> Now + 1 Second,
					DateCompleted -> Now + 5 Second
				|>,
				<|
					Object -> manifoldKernelCommand5,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 5 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 3",
					Result -> "4",
					Replace[Messages] -> {},
					Status -> Completed,
					DateCreated -> Now,
					DateStarted -> Now + 1 Second,
					DateCompleted -> Now + 5 Second
				|>,
				<|
					Object -> manifoldKernelCommand6,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 3",
					Replace[Messages] -> {},
					Status -> Running,
					DateCreated -> Now - 24 Hour,
					DateStarted -> Now - 18 Hour
				|>,
				<|
					Object -> job1,
					DeveloperObject -> True,
					Name -> "Test Job 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp1, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> job2,
					DeveloperObject -> True,
					Name -> "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp2, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> job3,
					DeveloperObject -> True,
					Name -> "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp3, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> job4,
					DeveloperObject -> True,
					Name -> "Test Job 4 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp4, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> job5,
					DeveloperObject -> True,
					Name -> "Test Job 5 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp5, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> job6,
					DeveloperObject -> True,
					Name -> "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID,
					Replace[Computations] -> {Link[comp6, Job]},
					Status -> Inactive,
					DateCreated -> Now
				|>,
				<|
					Object -> comp1,
					DeveloperObject -> True,
					Name -> "Test Computation 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Completed,
					DateEnqueued -> Now,
					DateStarted -> Now + 2 Second,
					DateCompleted -> Now + 3 Second,
					Replace[History] -> {<|Expression -> Hold[1 + 1], Kernel -> Null, Messages -> {}, Exception -> False, Output -> Hold[2], ObjectsGenerated -> {}|>}
				|>,
				<|
					Object -> comp2,
					DeveloperObject -> True,
					Name -> "Test Computation 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Error,
					DateEnqueued -> Now,
					DateStarted -> Now + 2 Second,
					DateCompleted -> Now + 3 Second,
					Replace[History] -> {
						<|
							Expression -> Hold[Message[Error::ThrowingAMessage];],
							Kernel -> Null,
							Messages -> {"StringForm::string : String expected at position 1 in StringForm[General::ThrowingAMessage].", "Error::ThrowingAMessage : StringForm[General::ThrowingAMessage]"},
							Exception -> True,
							Output -> Hold[Null],
							ObjectsGenerated -> {}
						|>
					}
				|>,
				<|
					Object -> comp3,
					DeveloperObject -> True,
					Name -> "Test Computation 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Completed,
					DateEnqueued -> Now,
					DateStarted -> Now + 2 Second,
					DateCompleted -> Now + 3 Second,
					Replace[History] -> {
						<|
							Expression -> Hold[Import["not-a-real-file.txt"]],
							Kernel -> Null,
							Messages -> {"Import::nffil : File not-a-real-file.txt not found during Import."},
							Exception -> False,
							Output -> Hold[$Failed],
							ObjectsGenerated -> {}
						|>
					}
				|>,
				<|
					Object -> comp4,
					DeveloperObject -> True,
					Name -> "Test Computation 4 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Completed,
					DateEnqueued -> Now,
					DateStarted -> Now + 2 Second,
					DateCompleted -> Now + 3 Second,
					Replace[History] -> {
						<|
							Expression -> Hold[1+2],
							Kernel -> Null,
							Messages -> {},
							Exception -> False,
							Output -> Hold[3],
							ObjectsGenerated -> {}
						|>
					}
				|>,
				<|
					Object -> comp5,
					DeveloperObject -> True,
					Name -> "Test Computation 5 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Completed,
					DateEnqueued -> Now,
					DateStarted -> Now + 2 Second,
					DateCompleted -> Now + 3 Second,
					Replace[History] -> {
						<|
							Expression -> Hold[1+3],
							Kernel -> Null,
							Messages -> {},
							Exception -> False,
							Output -> Hold[4],
							ObjectsGenerated -> {}
						|>
					}
				|>,
				<|
					Object -> comp6,
					DeveloperObject -> True,
					Name -> "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Running,
					DateCreated -> Now - 24 Hour,
					DateEnqueued -> Now - 21 Hour,
					DateReady -> Now - 20 Hour,
					DateStaged -> Now - 19 Hour,
					DateStarted -> Now - 18 Hour,
					Replace[History] -> {}
				|>
			}];

		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Protocol, HPLC, "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Filter, "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Transfer, "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];